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
