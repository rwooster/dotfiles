return {
    'rwooster/bazel-build-file.nvim',
    dependencies = {
        'nvim-lua/plenary.nvim',
        'nvim-treesitter/nvim-treesitter',
    },
    cmd = 'BazelBuildFile',
    keys = {
        { '<leader>bb', '<cmd>BazelBuildFile<CR>', desc = 'Open Bazel BUILD file' },
    },
}
