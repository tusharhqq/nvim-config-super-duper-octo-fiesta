local markdown = require("dadima.markdown")

return {
	-- Package Manager
	"folke/lazy.nvim",

	-- Snacks.nvim (high priority, not lazy loaded)
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		opts = {
			bigfile = { enabled = true },
			notifier = { enabled = true },
			-- Disabled: quickfile starts Treesitter before dadima.markdown guards apply.
			quickfile = { enabled = false },
			statuscolumn = { enabled = true },
			words = { enabled = true },
			styles = {
				notification = {
					wo = { wrap = true }, -- Wrap notifications
				},
			},
		},
	},

	-- Sneak
	"justinmk/vim-sneak",

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

	-- Linting
	{
		"mfussenegger/nvim-lint",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			local lint = require("lint")

			lint.linters_by_ft = {
				lua = { "luacheck" },
				json = { "jsonlint" },
				yaml = { "yamllint" },
				go = { "golangcilint" },
				-- Rust diagnostics are handled by rust-analyzer. Running clippy
				-- automatically on every Rust buffer open is slow and noisy because
				-- nvim-lint's clippy linter shells out to `cargo clippy`.
				-- Run `cargo clippy` manually when you want full project linting.
				-- rust = { "clippy" },
			}

			-- Create autocommand which carries out the actual linting
			local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
			vim.api.nvim_create_autocmd({ "BufWritePost" }, {
				group = lint_augroup,
				callback = function()
					-- Only run the linter in buffers that you can modify
					if vim.bo.modifiable then
						local ft = vim.bo.filetype
						local names = lint.linters_by_ft[ft] or {}
						local available = vim.tbl_filter(function(name)
							local linter = lint.linters[name]
							if not linter then
								return false
							end

							local cmd = linter.cmd
							if type(cmd) == "function" or cmd == nil then
								return true
							end

							return vim.fn.executable(cmd) == 1
						end, names)

						if #available > 0 then
							lint.try_lint(available)
						end
					end
				end,
			})
		end,
	},

	-- Telescope
	{
		"nvim-telescope/telescope.nvim",
		cmd = "Telescope",
		keys = {
			{ "<leader>pf", "<cmd>Telescope find_files<cr>", desc = "Find files" },
			{ "<C-p>", "<cmd>Telescope git_files<cr>", desc = "Find git files" },
			{ "<leader>ps", "<cmd>Telescope live_grep<cr>", desc = "Live grep" },
			{ "<leader>vh", "<cmd>Telescope help_tags<cr>", desc = "Help tags" },
		},
		dependencies = { "nvim-lua/plenary.nvim" },
	},

	-- Theme (prioritized for fast loading)
	{
		"rose-pine/neovim",
		name = "rose-pine",
		priority = 1000, -- Load before other plugins
		lazy = false, -- Don't lazy load the colorscheme
		config = function()
			require("rose-pine").setup({
				disable_background = true,
			})
			vim.defer_fn(function()
				vim.cmd.colorscheme("rose-pine")
				vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
				vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
			end, 50)
		end,
	},

	{
		"ThePrimeagen/vim-be-good",
		cmd = "VimBeGood",
	},
}
