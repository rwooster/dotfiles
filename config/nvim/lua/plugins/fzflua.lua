return {
    "ibhagwan/fzf-lua",
    dependencies = { "echasnovski/mini.icons" },
    opts = {},
    keys = {
        {
            "<leader>ff",
            function()
                local fzf_lua = require("fzf-lua")
                local path = require("fzf-lua.path")
                -- Setting the second argument to true suppresses
                -- warning if we aren't in a git repo
                local git_root = path.git_root({}, true)
                fzf_lua.files({ cwd = git_root })
            end,
            desc = "Find Files in project directory",
        },
        {
            "<leader>fg",
            function()
                local fzf_lua = require("fzf-lua")
                local path = require("fzf-lua.path")
                -- Setting the second argument to true suppresses
                -- warning if we aren't in a git repo
                local git_root = path.git_root({}, true)
                fzf_lua.live_grep({ cwd = git_root })
            end,
            desc = "Find by grepping in project directory",
        },
        {
            "<leader>fgc",
            function()
                local fzf_lua = require("fzf-lua")
                fzf_lua.live_grep({ cwd = vim.fn.getcwd() })
            end,
            desc = "Find by grepping in current directory",
        },
        {
            "<leader>fc",
            function()
                require("fzf-lua").files({ cwd = vim.fn.stdpath("config") .. "/lua" })
            end,
            desc = "Find in neovim configuration",
        },
        {
            "<leader>fh",
            function()
                require("fzf-lua").helptags()
            end,
            desc = "[F]ind [H]elp",
        },
        {
            "<leader>fk",
            function()
                require("fzf-lua").keymaps()
            end,
            desc = "[F]ind [K]eymaps",
        },
        {
            "<leader>fb",
            function()
                require("fzf-lua").builtin()
            end,
            desc = "[F]ind [B]uiltin FZF",
        },
        {
            "<leader>fw",
            function()
                require("fzf-lua").grep_cword()
            end,
            desc = "[F]ind current [W]ord",
        },
        {
            "<leader>fW",
            function()
                require("fzf-lua").grep_cWORD()
            end,
            desc = "[F]ind current [W]ORD",
        },
        {
            "<leader>fd",
            function()
                require("fzf-lua").diagnostics_document()
            end,
            desc = "[F]ind [D]iagnostics",
        },
        {
            "<leader>fr",
            function()
                require("fzf-lua").resume()
            end,
            desc = "[F]ind [R]esume",
        },
        {
            "<leader><leader>",
            function()
                require("fzf-lua").buffers()
            end,
            desc = "[ ] Find existing buffers",
        },
        {
            "<leader>/",
            function()
                require("fzf-lua").lgrep_curbuf()
            end,
            desc = "[/] Live grep the current buffer",
        },
    },
}
