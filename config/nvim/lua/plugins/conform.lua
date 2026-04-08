--- Search for the repo's bazel-managed clang-format binary.
--- Uses `bazel info output_base` (fast, no fetching) then globs for candidates.
--- When multiple binaries exist, picks by preference order.
---@param git_root string
---@return string|nil
local function resolve_bazel_clang_format(git_root)
    local cmd = "cd " .. vim.fn.shellescape(git_root) .. " && bazelisk info output_base 2>/dev/null"
    local output_base = vim.fn.system(cmd):gsub("%s+$", "")
    if vim.v.shell_error ~= 0 or output_base == "" then
        return nil
    end

    local candidates = vim.fn.glob(output_base .. "/external/*/bin/clang-format", false, true)
    if #candidates == 0 then
        return nil
    end
    if #candidates == 1 then
        return candidates[1]
    end

    -- When multiple binaries exist, prefer repo-specific toolchains
    local preferences = {
        "arene%-linters",
        "llvm_toolchain_patched_files",
        "llvm17_toolchain/",
    }
    for _, pattern in ipairs(preferences) do
        for _, bin_path in ipairs(candidates) do
            if bin_path:find(pattern) then
                return bin_path
            end
        end
    end
    return candidates[1]
end

--- Find a .clang-format style file in known repo locations.
---@param git_root string
---@return string|nil
local function find_clang_format_config(git_root)
    local dir_name = git_root:match("([^/]+)$")
    local bazel_external = git_root .. "/bazel-" .. dir_name .. "/external"
    local candidates = {
        bazel_external .. "/bazel_tooling/.clang-format",
        git_root .. "/tools/clang-format/.clang-format",
    }
    for _, path in ipairs(candidates) do
        local f = io.open(path, "r")
        if f then
            f:close()
            return path
        end
    end
    return nil
end

---@type table<string, table>
local clang_format_cache = {}

return {
    "stevearc/conform.nvim",
    dependencies = { "ibhagwan/fzf-lua" }, -- For fzf-lua.path to get the git root
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
        {
            "<leader>cf",
            function()
                require("conform").format({ async = true })
            end,
            mode = "",
            desc = "[C]ode [F]ormat",
        },
    },
    -- This will provide type hinting with LuaLS
    ---@module "conform"
    ---@type conform.setupOpts
    opts = {
        -- Define your formatters
        formatters_by_ft = {
            lua = { "stylua" },
            python = { "black" },
            cpp = { "clang-format" },
            bzl = { "buildifier" },
        },
        -- Set default options
        default_format_opts = {
            lsp_format = "fallback",
        },
        -- Set up format-on-save
        -- NOTE: Save without running formatting with :noau w
        -- This will run the command without running any autocommands
        format_on_save = { timeout_ms = 500 },
        -- Customize formatters
        formatters = {
            stylua = {
                prepend_args = { "--indent-type", "Spaces" },
            },
            -- Resolve the repo's bazel-managed clang-format binary and config.
            -- Falls back to the default (Mason or system) clang-format.
            ["clang-format"] = function()
                local git_root = require("fzf-lua.path").git_root({}, true)
                if not git_root then
                    return {}
                end

                if clang_format_cache[git_root] then
                    return clang_format_cache[git_root]
                end

                local config = {}
                local bin = resolve_bazel_clang_format(git_root)
                if bin then
                    config.command = bin
                end
                local style = find_clang_format_config(git_root)
                if style then
                    config.prepend_args = { "--style=file:" .. style }
                end

                clang_format_cache[git_root] = config
                return config
            end,
        },
    },
}
