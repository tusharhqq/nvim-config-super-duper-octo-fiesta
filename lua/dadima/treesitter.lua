local markdown = require("dadima.markdown")
local languages = require("dadima.languages")

return {
	-- Auto Tag
	{
		"windwp/nvim-ts-autotag",
		ft = languages.autotag_filetypes(),
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
				ensure_installed = languages.treesitter_ensure_installed(),

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
					disable = vim.list_extend(languages.treesitter_indent_disable(), { markdown.ft }),
				},
			})
		end,
	},

	-- Sticky scroll: pin function/class headers at top while scrolling
	{
		"nvim-treesitter/nvim-treesitter-context",
		event = { "BufReadPost", "BufNewFile" },
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		config = function()
			require("treesitter-context").setup({
				max_lines = 3,
				multiline_threshold = 20,
				on_attach = function(bufnr)
					return not markdown.is_markdown_buf(bufnr)
				end,
			})
		end,
	},
	{
		"nvim-treesitter/playground",
		cmd = "TSPlaygroundToggle",
	},
}
