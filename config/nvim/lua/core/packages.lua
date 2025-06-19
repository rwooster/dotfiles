return {
    --  Add any additional override configuration in the following tables. Available keys are:
    --  - cmd (table): Override the default command used to start the server
    --  - filetypes (table): Override the default list of associated filetypes for the server
    --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
    --  - settings (table): Override the default settings passed when initializing the server.
    --        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
    servers = {
        bashls = {},
        marksman = {},
        clangd = {},
        pyright = {},
        starpls = {
            filetypes = {
                "bzl",
                "bazel",
            },
        },
        lua_ls = {
            -- cmd = { ... },
            -- filetypes = { ... },
            -- capabilities = {},
            -- settings = {
            --   Lua = {
            --     completion = {
            --       callSnippet = 'Replace',
            --     },
            --     -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
            --     -- diagnostics = { disable = { 'missing-fields' } },
            --   },
            -- },
        },
    },
    formatters = {
        "stylua",
        -- "black",
        -- Ubuntu 20.04 has too old of a system python to install
        {
            "clang-format",
            condition = function()
                return vim.fn.executable("clang-format") == 0
            end,
        },
        "buildifier",
    },
}
