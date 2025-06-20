return {
    "olimorris/codecompanion.nvim",
    cmd = { "CodeCompanion", "CodeCompanionChat", "CodeCompanionActions" },
    dependencies = {
        "nvim-lua/plenary.nvim",
        "j-hui/fidget.nvim",
        {
            "echasnovski/mini.diff",
            config = function()
                local diff = require("mini.diff")
                diff.setup({
                    -- Disabled by default
                    source = diff.gen_source.none(),
                })
            end,
        },
        "nvim-treesitter/nvim-treesitter",
    },
    opts = {
        strategies = {
            chat = {
                adapter = "copilot",
            },
            inline = {
                adapter = "copilot",
            },
            cmd = {
                adapter = "copilot",
            },
            -- Necessary for the in-chat spinner implementation
            send = {
                callback = function(chat)
                    vim.cmd("stopinsert")
                    chat:submit()
                    chat:add_buf_message({ role = "llm", content = "" })
                end,
                index = 1,
                description = "Send",
            },
        },
        display = {
            chat = {
                auto_scroll = true,
            },
            diff = {
                provider = "mini_diff",
            },
        },
    },
    keys = {
        {
            "<leader>aa",
            "<cmd>CodeCompanionActions<CR>",
            desc = "[A]i [A]ctions",
            mode = { "n", "v" },
        },
        {
            "<leader>ac",
            "<cmd>CodeCompanionChat Toggle<CR>",
            desc = "[A]i [C]hat",
            mode = { "n", "v" },
        },
        {
            "<leader>ap",
            "<cmd>CodeCompanion<CR>",
            desc = "[A]i [P]rompt in current buffer",
            mode = { "n", "v" },
        },
        {
            "<leader>av",
            "<cmd>CodeCompanionChat Add<CR>",
            desc = "[A]i add [v]isual selection to a chat buffer",
            mode = { "v" },
        },
    },
    init = function()
        vim.cmd([[cab cc CodeCompanion]])
        require("plugins.custom.codecompanion-chat-spinner"):init()
    end,
}
