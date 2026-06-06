local markdown = require("dadima.markdown")

return {
	-- Auto Tag
	{
		"windwp/nvim-ts-autotag",
		ft = {
			"javascript",
			"typescript",
			"typescriptreact",
			"javascriptreact",
		},
		config = function()
			require("nvim-ts-autotag").setup()
		end,
	},

	-- Treesitter
	{
		"nvim-treesitter/nvim-treesitter",
		event = { "BufReadPost", "BufNewFile" },
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter.configs").setup({
				ignore_install = markdown.langs,

				-- Only install essential parsers at startup
				ensure_installed = {
					"bash",
					"css",
					"go",
					"html",
					"javascript",
					"json",
					"lua",
					"vim",
					"vimdoc",
					"python",
					"query", -- Essential for nvim
					"rust",
					"toml",
					"tsx",
					"typescript",
					"yaml",
				},

				-- Install parsers synchronously (only applied to `ensure_installed`)
				sync_install = false,

				-- Enable auto-install after startup to avoid blocking
				auto_install = false, -- Disabled for faster startup

				highlight = {
					enable = true,
					disable = function(lang, buf)
						if markdown.is_markdown_lang(lang) then
							return true
						end

						local max_filesize = 100 * 1024 -- 100 KB
						local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
						if ok and stats and stats.size > max_filesize then
							return true
						end
						return false
					end,
				},

				indent = {
					enable = true,
					disable = { "c", "cpp", markdown.ft },
				},
			})
		end,
	},
	{
		"nvim-treesitter/playground",
		cmd = "TSPlaygroundToggle",
	},
}
