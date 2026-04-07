return { -- Highlight, edit, and navigate code
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdate",
    config = function()
        local parsers = {
            "bash",
            "c",
            "cpp",
            "diff",
            "html",
            "lua",
            "luadoc",
            "markdown",
            "markdown_inline",
            "python",
            "query",
            "starlark",
            "vim",
            "vimdoc",
        }

        local installed = require("nvim-treesitter.config").get_installed()
        local to_install = vim.iter(parsers)
            :filter(function(p)
                return not vim.tbl_contains(installed, p)
            end)
            :totable()
        if #to_install > 0 then
            require("nvim-treesitter").install(to_install)
        end

        vim.treesitter.language.register("starlark", "bzl")

        vim.api.nvim_create_autocmd("FileType", {
            callback = function()
                pcall(vim.treesitter.start)
            end,
        })
    end,
}
