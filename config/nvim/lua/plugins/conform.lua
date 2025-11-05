return {
    "stevearc/conform.nvim",
    dependencies = { "ibhagwan/fzf-lua" }, -- For fzf-lua.path to get the git root
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
        {
            "<leader>cf",
            function()
                require("conform").format({ async = true })
            end,
            mode = "",
            desc = "[C]ode [F]ormat",
        },
    },
    -- This will provide type hinting with LuaLS
    ---@module "conform"
    ---@type conform.setupOpts
    opts = {
        -- Define your formatters
        formatters_by_ft = {
            lua = { "stylua" },
            python = { "black" },
            cpp = { "clang-format" },
            bzl = { "buildifier" },
        },
        -- Set default options
        default_format_opts = {
            lsp_format = "fallback",
        },
        -- Set up format-on-save
        -- NOTE: Save without running formatting with :noau w
        -- This will run the command without running any autocommands
        format_on_save = { timeout_ms = 500 },
        -- Customize formatters
        formatters = {
            stylua = {
                prepend_args = { "--indent-type", "Spaces" },
            },
            -- Handle some special cases for certain repository structures
            -- Some repos define the clang-format file in a bazel external named bazel_tooling.
            -- If that exists, use the clang-format file from there. Otherwise, don't specify 
            -- a clang-format file and the usual `.clang-format` will be used.
            -- Some repos define a specific clang-format binary. Search for it it in 
            -- two known locations. If it is not found, then clang-format will be run via the PATH.
            --
            ["clang-format"] = function()
                local path = require("fzf-lua.path")
                local git_root = path.git_root({}, true)
                local config = {}

                if git_root then
                    -- Get the directory name to construct bazel-xyz path
                    local dir_name = git_root:match("([^/]+)$")
                    local bazel_external = git_root .. "/bazel-" .. dir_name .. "/external"

                    -- Check for custom clang-format binary (in priority order)
                    local clang_format_bins = {
                        bazel_external .. "/llvm_toolchain_patched_files/bin/clang-format",
                        bazel_external .. "/arene-linters~~non_module_dependencies~local_config_arene_linters/bin/clang-format",
                    }
                    for _, clang_format_bin in ipairs(clang_format_bins) do
                        local bin_file = io.open(clang_format_bin, "r")
                        if bin_file then
                            bin_file:close()
                            config.command = clang_format_bin
                            break
                        end
                    end

                    -- Check for custom .clang-format style file
                    local clang_format_path = bazel_external .. "/bazel_tooling/.clang-format"
                    local style_file = io.open(clang_format_path, "r")
                    if style_file then
                        style_file:close()
                        config.prepend_args = { "--style=file:" .. clang_format_path }
                    end
                end

                return config
            end,
        },
    },
}
