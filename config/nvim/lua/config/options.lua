vim.g.python3_host_prog = '/usr/bin/python3.9'

vim.o.expandtab = true -- convert tabs to spaces
vim.o.shiftwidth = 4 -- Amount to indent with << and >>
vim.o.tabstop = 4 -- How many spaces are shown per Tab
vim.o.softtabstop = 4 -- How many spaces are applied when pressing Tab

vim.o.smarttab = true
vim.o.smartindent = true
vim.o.autoindent = true -- Keep identation from previous line

-- Always show relative line numbers
vim.o.number = true
vim.o.relativenumber = true

-- Show line under cursor
vim.o.cursorline = true

-- Store undos between sessions
vim.o.undofile = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.o.mouse = "a"

-- Don't show the mode, since it's already in the status line
vim.o.showmode = false

-- Decrease update time
vim.o.updatetime = 250

-- Decrease mapped sequence wait time
vim.o.timeoutlen = 300

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.o.signcolumn = "yes"

-- Configure how new splits should be opened
vim.o.splitright = true
vim.o.splitbelow = true

-- Disable creating swap files
vim.o.swapfile = false

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.o.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Minimal number of screen lines to keep above and below the cursor.
vim.o.scrolloff = 5

-- Set the cwd to the directory of the current buffer
vim.o.autochdir = true

-- Preview substitutions live
vim.o.inccommand = "split"

-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight when yanking (copying) text",
    group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
    callback = function()
        vim.hl.on_yank({ timeout = 300 })
    end,
})

-- Include angle brackets in matched pairs
vim.opt.matchpairs:append("<:>")
