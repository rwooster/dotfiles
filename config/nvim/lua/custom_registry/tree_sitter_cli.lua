return {
    name = "tree-sitter-cli",
    description = "Tree-sitter CLI built from source via cargo to avoid glibc incompatibility with pre-built binaries.",
    homepage = "https://github.com/tree-sitter/tree-sitter",
    licenses = { "MIT" },
    languages = {},
    categories = { "Compiler" },
    source = {
        id = "pkg:cargo/tree-sitter-cli@0.26.8",
    },
    bin = {
        ["tree-sitter"] = "cargo:tree-sitter",
    },
}
