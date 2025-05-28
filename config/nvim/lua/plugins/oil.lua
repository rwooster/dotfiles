return {
    "stevearc/oil.nvim",
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {
        view_options = {
            show_hidden = true,
        },
    },
    dependencies = { { "echasnovski/mini.icons", opts = {} } },
    -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
    lazy = false,
    keys = {
        { "-", "<cmd>Oil --float<CR>", desc = "[F]ile browser [O]pen current directory" },
        { "<leader>fo", "<cmd>Oil --float<CR>", desc = "[F]ile browser [O]pen current directory" },
    },
}
