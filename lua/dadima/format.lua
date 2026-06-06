local markdown = require("dadima.markdown")
local languages = require("dadima.languages")

return {
	-- Formatting (using conform.nvim instead of none-ls)
	{
		"stevearc/conform.nvim",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			local conform = require("conform")
			local format_opts = {
				lsp_format = "fallback",
				async = false,
				timeout_ms = 1000,
			}

			conform.setup({
				formatters = {
					oxfmt = {
						command = "oxfmt",
						args = { "--stdin-filepath", "$FILENAME" },
						stdin = true,
						cwd = require("conform.util").root_file({
							"package.json",
							"oxfmt.json",
							".oxfmt.json",
							".git",
						}),
					},
				},
				formatters_by_ft = languages.formatters_by_ft(),
				format_on_save = function(bufnr)
					if markdown.is_markdown_buf(bufnr) then
						return nil
					end

					return format_opts
				end,
			})

			vim.keymap.set({ "n", "v" }, "<leader>fm", function()
				conform.format(format_opts)
			end, { desc = "Format file or range (in visual mode)" })
		end,
	},
}
