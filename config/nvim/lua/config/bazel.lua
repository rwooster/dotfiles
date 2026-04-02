-- Simple Bazel BUILD file navigation using treesitter

--- Walk up from start_path looking for BUILD.bazel or BUILD.
--- Stops at the git root if in a repo, otherwise walks to filesystem root.
local function find_build_file(start_path)
    local boundary = require('fzf-lua.path').git_root({}, true)
    local dir = vim.fn.fnamemodify(start_path, ':h')
    while dir ~= '/' and dir ~= '' do
        for _, name in ipairs({ 'BUILD.bazel', 'BUILD' }) do
            local candidate = dir .. '/' .. name
            if vim.fn.filereadable(candidate) == 1 then
                return candidate
            end
        end
        if dir == boundary then
            break
        end
        dir = vim.fn.fnamemodify(dir, ':h')
    end
    return nil
end

--- Check if a treesitter call node's arguments contain the given filename.
local function call_references_file(node, bufnr, filename)
    local args = node:named_child(1)
    if not args then
        return false
    end
    local text = vim.treesitter.get_node_text(args, bufnr)
    return text ~= nil and text:find(filename, 1, true) ~= nil
end

--- Check if a treesitter call node has name = "stem" in its arguments.
local function call_has_name(node, bufnr, stem)
    local args = node:named_child(1)
    if not args then
        return false
    end
    for arg in args:iter_children() do
        if arg:type() == 'keyword_argument' then
            local key = arg:named_child(0)
            local val = arg:named_child(1)
            if key and val then
                local key_text = vim.treesitter.get_node_text(key, bufnr)
                local val_text = vim.treesitter.get_node_text(val, bufnr)
                if key_text == 'name' and val_text and val_text:find(stem, 1, true) then
                    return true
                end
            end
        end
    end
    return false
end

--- Iterate top-level call expressions in a BUILD file buffer.
local function iter_top_level_calls(bufnr)
    local ok, parser = pcall(vim.treesitter.get_parser, bufnr, 'python')
    if not ok or not parser then
        return function() end
    end
    local tree = parser:parse()[1]
    if not tree then
        return function() end
    end

    local root = tree:root()
    local child_iter = root:iter_children()
    return function()
        while true do
            local child = child_iter()
            if not child then
                return nil
            end
            local node = child
            if node:type() == 'expression_statement' then
                node = node:named_child(0)
            end
            if node and node:type() == 'call' then
                return node
            end
        end
    end
end

--- Use treesitter to find the line of the rule referencing filename in bufnr.
local function find_rule_line(bufnr, filename)
    for node in iter_top_level_calls(bufnr) do
        if call_references_file(node, bufnr, filename) then
            return node:start()
        end
    end
    -- Fallback: match rule name against file stem
    local stem = vim.fn.fnamemodify(filename, ':r')
    for node in iter_top_level_calls(bufnr) do
        if call_has_name(node, bufnr, stem) then
            return node:start()
        end
    end
    return nil
end

local function open_build_file()
    local current_file = vim.api.nvim_buf_get_name(0)
    if current_file == '' then
        vim.notify('No file in current buffer', vim.log.levels.WARN)
        return
    end

    local build_file = find_build_file(current_file)
    if not build_file then
        vim.notify('No BUILD file found', vim.log.levels.WARN)
        return
    end

    local filename = vim.fn.fnamemodify(current_file, ':t')
    vim.cmd.edit(build_file)

    vim.schedule(function()
        local bufnr = vim.api.nvim_get_current_buf()
        local row = find_rule_line(bufnr, filename)
        if row then
            vim.api.nvim_win_set_cursor(0, { row + 1, 0 })
            vim.cmd('normal! zz')
        end
    end)
end

vim.api.nvim_create_user_command('BazelBuild', open_build_file, { desc = 'Open the BUILD file for the current buffer' })
vim.keymap.set('n', '<leader>bb', open_build_file, { desc = 'Open Bazel BUILD file' })
