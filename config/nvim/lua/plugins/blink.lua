return {
    "saghen/blink.cmp",
    -- optional: provides snippets for the snippet source
    -- use a release tag to download pre-built binaries
    version = "1.*",
    dependencies = {
        "folke/lazydev.nvim",
        "fang2hou/blink-copilot",
    },
    event = "InsertEnter",
    -- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
    -- build = 'cargo build --release',
    -- If you use nix, you can build from source using latest nightly rust with:
    -- build = 'nix run .#build-plugin',

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
        keymap = {
            ["<Tab>"] = { "select_next", "accept", "fallback" },
            ["<S-Tab>"] = { "select_prev", "fallback" },
            ["<C-j>"] = { "select_and_accept" },
        },

        appearance = {
            -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
            -- Adjusts spacing to ensure icons are aligned
            nerd_font_variant = "mono",
        },

        -- (Default) Only show the documentation popup when manually triggered
        completion = {
            list = { selection = { preselect = false, auto_insert = true } },
            documentation = { auto_show = true },
        },
        signature = { enabled = true },

        -- Default list of enabled providers defined so that you can extend it
        -- elsewhere in your config, without redefining it, due to `opts_extend`
        sources = {
            default = { "lsp", "path", "buffer", "copilot", "lazydev" },
            per_filetype = {
                codecompanion = { "codecompanion" },
            },
            providers = {
                path = {
                    opts = {
                        show_hidden_files_by_default = true,
                    },
                },
                lazydev = {
                    name = "LazyDev",
                    module = "lazydev.integrations.blink",
                    -- make lazydev completions top priority (see `:h blink.cmp`)
                    score_offset = 100,
                },
                copilot = {
                    name = "copilot",
                    module = "blink-copilot",
                    score_offset = 100,
                    async = true,
                },
            },
        },
        -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
        -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
        -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
        --
        -- See the fuzzy documentation for more information
        fuzzy = { implementation = "prefer_rust_with_warning" },
    },
    opts_extend = { "sources.default" },
}
