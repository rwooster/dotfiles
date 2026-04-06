-- Remap escape
vim.keymap.set("i", "jj", "<Esc>", { desc = "Exit insert mode as <Esc>" })

-- Buffer navigation
vim.keymap.set("n", "<C-h>", "<cmd>bp<CR>", { desc = "Move to previous buffer" })
vim.keymap.set("n", "<C-l>", "<cmd>bn<CR>", { desc = "Move to next buffer" })

-- "Bubble" lines up/down
vim.keymap.set("n", "<C-k>", "ddkP", { desc = "Bubble a line up" })
vim.keymap.set("n", "<C-j>", "ddp", { desc = "Bubble a line down" })
vim.keymap.set("v", "<C-k>", "xkP`[V`]", { desc = "Bubble a line up" })
vim.keymap.set("v", "<C-j>", "xp`[V`]", { desc = "Bubble a line down" })

-- Find and Replace
vim.keymap.set("n", "<Leader>s", ":%s/<C-r><C-w>/", { desc = "Start a replace on the current word" })
vim.keymap.set("n", "<Leader>h", "<cmd>nohlsearch<CR>", { desc = "Clear highlighted results from search" })

-- Map build-in commenting keybind to the vim+nerdcommenter mapping.
vim.keymap.set("n", "<Leader>cc", "gcc", { remap = true, desc = "[C]ode [C]omment" })
vim.keymap.set("v", "<Leader>cc", "gc", { remap = true, desc = "[C]ode [C]omment" })

--vim.keymap.set("n", "gl", function()
--vim.diagnostic.open_float()
--end, { desc = "Open Diagnostics in Float" })

--vim.keymap.set("n", "<leader>cf", function()
--require("conform").format({
--lsp_format = "fallback",
--})
--end, { desc = "Format current file" })

---- Map <leader>fp to open projects
--vim.keymap.set("n", "<leader>fp", ":ProjectFzf<CR>", { noremap = true, silent = true })

vim.keymap.set("n", "<leader>gl", function()
    local file = vim.fn.expand("%")
    local git_log = "log --graph --decorate --color"
    -- Set -+F to disable -F on the pager (less) for git so it doesn't immediately exit on short logs.
    -- Set -R to forward colors.
    local git_config = '-c core.pager="less -+F -R"'
    local tmux = require("libtmux")
    tmux:split_window({
        horizontal = true,
        shell_command = string.format("git %s %s -- %s", git_config, git_log, file),
    })
end, { desc = "Git log in tmux pane" })
