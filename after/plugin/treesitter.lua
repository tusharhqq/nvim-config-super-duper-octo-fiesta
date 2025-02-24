return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
        require("nvim-treesitter.configs").setup({
            -- A list of parser names, or "all" (the listed parsers should always be installed)
            ensure_installed = {
                 "javascript", "typescript", "c", "lua", "rust", "zig", "go", "cpp",
                "jsdoc", "bash", "markdown_inline", "markdown", "json", "html", "css", "ocaml", "python",
            },

            -- Install parsers synchronously (only applied to `ensure_installed`)
            sync_install = false,

            -- Automatically install missing parsers when entering buffer
            auto_install = true,

            highlight = {
                enable = true,
                -- Disable highlighting for files larger than 100KB
                disable = function(lang, buf)
                    local max_filesize = 100 * 1024 -- 100 KB
                    local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
                    if ok and stats and stats.size > max_filesize then
                        return true
                    end
                    return false
                end,
                -- Disable additional Vim regex highlighting to avoid duplicates
                additional_vim_regex_highlighting = false,
            },

            indent = {
                enable = true
            },
        })

    end
}
