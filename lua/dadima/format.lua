local markdown = require("dadima.markdown")

return {
	-- Formatting (using conform.nvim instead of none-ls)
	{
		"stevearc/conform.nvim",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			local conform = require("conform")
			local mason_bin = require("dadima.mason_bin")
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
					ocamlformat = {
						command = mason_bin .. "/ocamlformat",
					},
				},
				formatters_by_ft = {
					javascript = { "oxfmt" },
					typescript = { "oxfmt" },
					javascriptreact = { "oxfmt" },
					typescriptreact = { "oxfmt" },
					css = { "oxfmt" },
					html = { "oxfmt" },
					json = { "oxfmt" },
					yaml = { "oxfmt" },
					toml = { "oxfmt" },
					lua = { "stylua" },
					python = {
						-- To fix auto-fixable lint errors.
						"ruff_fix",
						-- To organize the imports.
						"ruff_organize_imports",
						-- To run the Ruff formatter after fixes/import changes.
						"ruff_format",
					},
					go = { "gofmt" },
					rust = { "rustfmt" },
					ocaml = { "ocamlformat" },
					reason = { "ocamlformat" },
				},
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
