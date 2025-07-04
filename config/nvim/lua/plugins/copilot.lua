-- return {
--     "github/copilot.vim",
--     -- disable copilot by default
--     lazy = true,
--     keys = { "<leader>ce" },
--     config = function()
--         vim.keymap.set("i", "<C-j>", 'copilot#Accept("\\<CR>")', {
--             expr = true,
--             replace_keycodes = false,
--         })
--         vim.keymap.set("n", "<leader>cd", ":Copilot disable <CR>", {})
--         vim.keymap.set("n", "<leader>ce", ":Copilot enable <CR>", {})
--     end,
-- }
return {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    opts = {
        suggestion = {
            enabled = false,
            auto_trigger = true,
            keymap = {
                accept = "<C-j>",
                next = "<C-]>",
                prev = "<C-[>",
            },
        },
        panel = {
            enabled = false,
        },
    },
}
