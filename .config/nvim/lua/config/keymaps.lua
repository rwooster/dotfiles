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

-- Windows

-- Already used for switching buffers, consider if alternate key bindings are worth it.
--vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
--vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

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
