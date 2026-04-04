return {
    "FabijanZulj/blame.nvim",
    opts = {
        mappings = {
            commit_info = "i",
            stack_push = "<TAB>",
            stack_pop = "<BS>",
            show_commit = "<CR>",
            close = { "<esc>", "q" },
            copy_hash = "y",
            open_in_browser = "o",
        },
    },
    keys = {
        { "<leader>gb", "<cmd>BlameToggle<CR>", desc = "[G]it [B]lame for the current file" },
    },
}
