return {
    'rwooster/bazel-build-file.nvim',
    dependencies = {
        'rwooster/libbazel.nvim',
    },
    cmd = 'BazelBuildFile',
    keys = {
        { '<leader>bb', '<cmd>BazelBuildFile<CR>', desc = 'Open Bazel BUILD file' },
    },
}
