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
			quickfile = { enabled = true, exclude = { "latex", "markdown" } },
			statuscolumn = { enabled = true },
			words = { enabled = true },
			styles = {
				notification = {
					wo = { wrap = true }, -- Wrap notifications
				},
			},
		},
	},

	-- amp
	{
		"sourcegraph/amp.nvim",
		branch = "main",
		event = "VeryLazy",
		opts = { auto_start = true, log_level = "info" },
	},

	-- Sneak
	"justinmk/vim-sneak",

	-- Formatting (using conform.nvim instead of none-ls)
	{
		"stevearc/conform.nvim",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			local conform = require("conform")

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
					markdown = { "oxfmt" },
					toml = { "taplo" },
					liquid = { "prettier" },
					lua = { "stylua" },
					python = {
						-- To fix auto-fixable lint errors.
						"ruff_fix",
						-- To run the Ruff formatter.
						"ruff_format",
						-- To organize the imports.
						"ruff_organize_imports",
					},
					go = { "gofmt" },
					rust = { "rustfmt" },
				},
				format_on_save = {
					lsp_fallback = true,
					async = false,
					timeout_ms = 1000,
				},
			})

			vim.keymap.set({ "n", "v" }, "<leader>mp", function()
				conform.format({
					lsp_fallback = true,
					async = false,
					timeout_ms = 1000,
				})
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
				markdown = { "markdownlint-cli2" },
				json = { "jsonlint" },
				yaml = { "yamllint" },
				go = { "golangcilint" },
				rust = { "clippy" },
			}

			-- Create autocommand which carries out the actual linting
			local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
			vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
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

	-- Indentation guides (lazy loaded to improve startup)
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		event = { "BufReadPost", "BufNewFile" },
		enabled = false, -- Disable vertical indentation lines
		opts = {},
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
		config = function()
			-- Additional telescope configuration can be added here if needed
			-- Most functionality is handled via lazy.nvim keys
		end,
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
			-- Defer the actual colorscheme application to reduce startup impact
			vim.defer_fn(function()
				vim.cmd("colorscheme rose-pine")
				-- Apply custom highlights after colorscheme loads
				vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
				vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
			end, 50)

			-- Custom colorscheme function
			_G.ColorMyPencils = function(color)
				color = color or "rose-pine"
				vim.cmd.colorscheme(color)
				vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
				vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
			end
		end,
	},

	-- Treesitter
	{
		"nvim-treesitter/nvim-treesitter",
		event = { "BufReadPost", "BufNewFile" },
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter.configs").setup({
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
					"markdown",
					"markdown_inline", -- Essential for render-markdown
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
					-- Disable highlighting for files larger than 100KB
					disable = function(lang, buf)
						local max_filesize = 100 * 1024 -- 100 KB
						local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
						if ok and stats and stats.size > max_filesize then
							return true
						end
						return false
					end,
					-- Enable additional Vim regex highlighting for markdown to support render-markdown
					additional_vim_regex_highlighting = { "markdown" },
				},

				indent = {
					enable = true,
				},
			})

			-- Enable auto-install after startup delay to avoid slowing down startup
			vim.defer_fn(function()
				require("nvim-treesitter.configs").setup({
					auto_install = true,
				})
			end, 1000)

		end,
	},
	{
		"nvim-treesitter/playground",
		cmd = "TSPlaygroundToggle",
	},
	{
		"nvim-treesitter/nvim-treesitter-context",
		event = { "BufReadPost", "BufNewFile" },
		enabled = false, -- Disable context boxes
	},

	-- Navigation and Git
	{
		"ThePrimeagen/harpoon",
		lazy = true, -- Only load when keys are used
		keys = {
			{
				"<leader>a",
				function()
					require("harpoon.mark").add_file()
				end,
				desc = "Add file to harpoon",
			},
			{
				"<C-e>",
				function()
					require("harpoon.ui").toggle_quick_menu()
				end,
				desc = "Toggle harpoon menu",
			},
			{
				"<C-h>",
				function()
					require("harpoon.ui").nav_file(1)
				end,
				desc = "Navigate to harpoon file 1",
			},
			{
				"<C-t>",
				function()
					require("harpoon.ui").nav_file(2)
				end,
				desc = "Navigate to harpoon file 2",
			},
			{
				"<C-n>",
				function()
					require("harpoon.ui").nav_file(3)
				end,
				desc = "Navigate to harpoon file 3",
			},
			{
				"<C-s>",
				function()
					require("harpoon.ui").nav_file(4)
				end,
				desc = "Navigate to harpoon file 4",
			},
			{
				"<A-p>",
				function()
					require("harpoon.ui").nav_prev()
				end,
				desc = "Navigate to previous harpoon mark",
			},
			{
				"<A-n>",
				function()
					require("harpoon.ui").nav_next()
				end,
				desc = "Navigate to next harpoon mark",
			},
		},
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("harpoon").setup({
				global_settings = {
					save_on_toggle = false,
					save_on_change = true,
					enter_on_sendcmd = false,
					tmux_autoclose_windows = false,
					excluded_filetypes = { "harpoon" },
					mark_branch = false,
				},
			})
		end,
	},
	{
		"mbbill/undotree",
		cmd = "UndotreeToggle",
		keys = {
			{ "<leader>u", "<cmd>UndotreeToggle<cr>", desc = "Toggle UndoTree" },
		},
		config = function()
			local group = vim.api.nvim_create_augroup("undotree_close_fix", { clear = true })
			local bufenter_fixes = {
				undotree = {
					group = "Undotree_Main",
					clear_events = { "BufEnter", "BufLeave" },
					events = { "BufEnter", "BufLeave" },
					command = "if exists('t:undotree') | let t:undotree.width = winwidth(winnr()) | endif",
				},
				diff = {
					group = "Undotree_Diff",
					clear_events = { "BufEnter" },
					events = { "BufEnter" },
					command = "if exists('t:undotree') && exists('t:diffpanel') && !t:undotree.IsVisible() | call t:diffpanel.Hide() | endif",
				},
			}

			vim.api.nvim_create_autocmd("FileType", {
				group = group,
				pattern = { "undotree", "diff" },
				callback = function(args)
					vim.schedule(function()
						local fix = bufenter_fixes[args.match]

						if
							not fix
							or not vim.api.nvim_buf_is_valid(args.buf)
							or vim.b[args.buf].isUndotreeBuffer ~= 1
							or vim.b[args.buf].undotreeCloseFixApplied
						then
							return
						end

						local ok = pcall(vim.api.nvim_clear_autocmds, {
							group = fix.group,
							buffer = args.buf,
							event = fix.clear_events,
						})

						if not ok then
							return
						end

						vim.b[args.buf].undotreeCloseFixApplied = true
						vim.api.nvim_create_autocmd(fix.events, {
							group = fix.group,
							buffer = args.buf,
							command = fix.command,
						})
					end)
				end,
			})
		end,
	},
	{
		"tpope/vim-fugitive",
		cmd = {
			"Git",
			"G",
			"Gdiffsplit",
			"Gread",
			"Gwrite",
			"Ggrep",
			"GMove",
			"GDelete",
			"GBrowse",
			"GRemove",
			"GRename",
			"Glgrep",
			"Gedit",
		},
		keys = {
			{ "<leader>gs", "<cmd>Git<cr>", desc = "Git status" },
		},
	},
	{
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPre", "BufNewFile" },
		opts = {
			on_attach = function(bufnr)
				local gitsigns = require("gitsigns")

				local function map(mode, l, r, opts)
					opts = opts or {}
					opts.buffer = bufnr
					vim.keymap.set(mode, l, r, opts)
				end

				-- Navigation
				map("n", "]c", function()
					if vim.wo.diff then
						vim.cmd.normal({ "]c", bang = true })
					else
						gitsigns.nav_hunk("next")
					end
				end, { desc = "Jump to next git [c]hange" })

				map("n", "[c", function()
					if vim.wo.diff then
						vim.cmd.normal({ "[c", bang = true })
					else
						gitsigns.nav_hunk("prev")
					end
				end, { desc = "Jump to previous git [c]hange" })

				-- Actions
				-- visual mode
				map("v", "<leader>hs", function()
					gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end, { desc = "git [s]tage hunk" })
				map("v", "<leader>hr", function()
					gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end, { desc = "git [r]eset hunk" })
				-- normal mode
				map("n", "<leader>hs", gitsigns.stage_hunk, { desc = "git [s]tage hunk" })
				map("n", "<leader>hr", gitsigns.reset_hunk, { desc = "git [r]eset hunk" })
				map("n", "<leader>hS", gitsigns.stage_buffer, { desc = "git [S]tage buffer" })
				map("n", "<leader>hu", gitsigns.undo_stage_hunk, { desc = "git [u]ndo stage hunk" })
				map("n", "<leader>hR", gitsigns.reset_buffer, { desc = "git [R]eset buffer" })
				map("n", "<leader>hp", gitsigns.preview_hunk, { desc = "git [p]review hunk" })
				map("n", "<leader>hb", gitsigns.blame_line, { desc = "git [b]lame line" })
				map("n", "<leader>hd", gitsigns.diffthis, { desc = "git [d]iff against index" })
				map("n", "<leader>hD", function()
					gitsigns.diffthis("@")
				end, { desc = "git [D]iff against last commit" })
				-- Toggles
				map("n", "<leader>tb", gitsigns.toggle_current_line_blame, { desc = "[T]oggle git show [b]lame line" })
				map("n", "<leader>tD", gitsigns.toggle_deleted, { desc = "[T]oggle git show [D]eleted" })
			end,
		},
	},
	{
		"ThePrimeagen/vim-be-good",
		cmd = "VimBeGood",
	},

	-- Mason (separated from LSP for better lazy loading)
	{
		"williamboman/mason.nvim",
		lazy = false, -- Load Mason immediately to set up PATH
		priority = 999, -- Load before LSP
		config = function()
			require("mason").setup({
				PATH = "prepend", -- Ensure Mason's bin directory is added to PATH
				ui = {
					icons = {
						package_installed = "✓",
						package_pending = "➜",
						package_uninstalled = "✗",
					},
				},
			})
		end,
	},

	-- LSP (modernized setup without lsp-zero)
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-nvim-lua",
		},
		config = function()
			local cmp = require("cmp")

			cmp.setup({
				sources = {
					{ name = "nvim_lsp" },
					{ name = "buffer" },
					{ name = "path" },
				},
				snippet = {
					expand = function(args)
						local luasnip_ok, luasnip = pcall(require, "luasnip")
						if luasnip_ok then
							luasnip.lsp_expand(args.body)
						end
					end,
				},
				mapping = cmp.mapping.preset.insert({
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.abort(),
					["<CR>"] = cmp.mapping.confirm({ select = true }),
					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						else
							local luasnip_ok, luasnip = pcall(require, "luasnip")
							if luasnip_ok and luasnip.expand_or_jumpable() then
								luasnip.expand_or_jump()
							else
								fallback()
							end
						end
					end, { "i", "s" }),
					["<S-Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						else
							local luasnip_ok, luasnip = pcall(require, "luasnip")
							if luasnip_ok and luasnip.jumpable(-1) then
								luasnip.jump(-1)
							else
								fallback()
							end
						end
					end, { "i", "s" }),
				}),
			})
		end,
	},

	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			{
				"williamboman/mason-lspconfig.nvim",
				event = { "BufReadPre", "BufNewFile" },
			},
		},
		config = function()
			-- Setup Mason path resolution for LSP servers
			local mason_registry_ok, mason_registry = pcall(require, "mason-registry")
			if mason_registry_ok then
				vim.env.PATH = vim.env.PATH .. ":" .. vim.fn.stdpath("data") .. "/mason/bin"
			end

			vim.opt.signcolumn = "yes"

			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(event)
					local opts = { buffer = event.buf }
					vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
					vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
					vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
					vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
					vim.keymap.set("n", "go", vim.lsp.buf.type_definition, opts)
					vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
					vim.keymap.set("n", "gs", vim.lsp.buf.signature_help, opts)
					vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
					vim.keymap.set({ "n", "x" }, "<leader>fm", function()
						local conform_ok, conform = pcall(require, "conform")
						if conform_ok then
							conform.format({
								async = true,
								lsp_fallback = true,
								timeout_ms = 1000,
							})
						else
							vim.lsp.buf.format({ async = true })
						end
					end, opts)
					vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
				end,
			})

			-- Setup Mason LSP Config only if available (deferred to reduce startup time)
			vim.defer_fn(function()
				local mason_lspconfig_ok, mason_lspconfig = pcall(require, "mason-lspconfig")
				if mason_lspconfig_ok then
					mason_lspconfig.setup({
						ensure_installed = {
							"lua_ls",
							"rust_analyzer",
							"gopls",
							"oxlint",
							"ruff",
							"tsgo",
							"ty",
						},
						automatic_installation = true,
					})
				end
			end, 50)

			-- Get default capabilities for LSP
			local capabilities
			local cmp_nvim_lsp_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
			if cmp_nvim_lsp_ok then
				capabilities = cmp_nvim_lsp.default_capabilities()
			else
				capabilities = vim.lsp.protocol.make_client_capabilities()
			end

			-- Setup individual LSP servers using vim.lsp.config (replaces deprecated require('lspconfig'))
			vim.lsp.config("lua_ls", {
				capabilities = capabilities,
				settings = {
					Lua = {
						diagnostics = {
							globals = { "vim" },
						},
					},
				},
			})
			vim.lsp.enable("lua_ls", true)

			vim.lsp.config("rust_analyzer", {
				capabilities = capabilities,
			})
			vim.lsp.enable("rust_analyzer", true)

			vim.lsp.config("gopls", {
				capabilities = capabilities,
			})
			vim.lsp.enable("gopls", true)

			vim.lsp.config("tsgo", {
				capabilities = capabilities,
			})
			vim.lsp.enable("tsgo", true)

			vim.lsp.config("oxlint", {
				capabilities = capabilities,
			})
			vim.lsp.enable("oxlint", true)

			-- Ruff setup (new ruff server replaces ruff_lsp)
			vim.lsp.config("ruff", {
				capabilities = capabilities,
				init_options = {
					settings = {
						logLevel = "info", -- Change to 'debug' if needed
						-- logFile = '/tmp/ruff.log', -- Uncomment to set a custom log file

						-- Additional Ruff settings
						args = {}, -- Add any additional ruff arguments here if needed

						-- Enable/disable specific Ruff features
						lint = {
							enable = true, -- Enable linting (default: true)
						},
						format = {
							enable = true, -- Enable formatting (default: true)
						},
					},
				},
			})
			vim.lsp.enable("ruff", true)

			-- Disable Ruff's hover if using ty for hover and completions
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("lsp_attach_disable_ruff_hover", { clear = true }),
				callback = function(args)
					local client = vim.lsp.get_client_by_id(args.data.client_id)
					if client == nil then
						return
					end
					if client.name == "ruff" then
						-- Disable hover in favor of ty
						client.server_capabilities.hoverProvider = false
					end
				end,
				desc = "LSP: Disable hover capability from Ruff",
			})

			vim.lsp.config("ty", {
				capabilities = capabilities,
			})
			vim.lsp.enable("ty", true)
		end,
	},

	-- LuaSnip (completely separate for true lazy loading)
	{
		"L3MON4D3/LuaSnip",
		build = "make install_jsregexp",
		lazy = true, -- Only load when explicitly needed
		keys = {
			{ "<Tab>", mode = { "i", "s" } }, -- Load when Tab is pressed in insert/select mode
			{ "<S-Tab>", mode = { "i", "s" } }, -- Load when Shift+Tab is pressed
		},
		dependencies = {
			{
				"rafamadriz/friendly-snippets",
				lazy = true,
			},
			{
				"saadparwaiz1/cmp_luasnip",
				lazy = true,
			},
		},
		config = function()
			-- Set up snippet source for nvim-cmp when LuaSnip loads
			local cmp_ok, cmp = pcall(require, "cmp")
			if cmp_ok then
				local sources = cmp.get_config().sources or {}
				table.insert(sources, { name = "luasnip" })
				cmp.setup({ sources = sources })
			end

			-- Load friendly snippets
			require("luasnip.loaders.from_vscode").lazy_load()
		end,
	},

	-- TypeScript Error Translator
	{
		"dmmulroy/ts-error-translator.nvim",
		ft = { "typescript", "javascript", "typescriptreact", "javascriptreact" },
		config = function()
			require("ts-error-translator").setup({
				auto_override_publish_diagnostics = true,
			})
		end,
	},

	-- Debugging (DAP)
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			-- Creates a beautiful debugger UI
			"rcarriga/nvim-dap-ui",

			-- Required dependency for nvim-dap-ui
			"nvim-neotest/nvim-nio",

			-- Installs the debug adapters for you
			"williamboman/mason.nvim",
			"jay-babu/mason-nvim-dap.nvim",

			-- Add your own debuggers here
			"leoluz/nvim-dap-go",
		},
		keys = {
			-- macOS-friendly debugging keymaps
			{
				"<leader>dc",
				function()
					require("dap").continue()
				end,
				desc = "Debug: Start/Continue",
			},
			{
				"<leader>di",
				function()
					require("dap").step_into()
				end,
				desc = "Debug: Step Into",
			},
			{
				"<leader>do",
				function()
					require("dap").step_over()
				end,
				desc = "Debug: Step Over",
			},
			{
				"<leader>du",
				function()
					require("dap").step_out()
				end,
				desc = "Debug: Step Out",
			},
			{
				"<leader>db",
				function()
					require("dap").toggle_breakpoint()
				end,
				desc = "Debug: Toggle Breakpoint",
			},
			{
				"<leader>dB",
				function()
					require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
				end,
				desc = "Debug: Set Conditional Breakpoint",
			},
			-- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
			{
				"<leader>dt",
				function()
					require("dapui").toggle()
				end,
				desc = "Debug: Toggle UI",
			},
		},
		config = function()
			local dap = require("dap")
			local dapui = require("dapui")

			require("mason-nvim-dap").setup({
				-- Makes a best effort to setup the various debuggers with
				-- reasonable debug configurations
				automatic_installation = true,

				-- You can provide additional configuration to the handlers,
				-- see mason-nvim-dap README for more information
				handlers = {},

				-- You'll need to check that you have the required things installed
				-- online, please don't ask me how to install them :)
				ensure_installed = {
					-- Update this to ensure that you have the debuggers for the langs you want
					"delve",
				},
			})

			-- Dap UI setup
			-- For more information, see |:help nvim-dap-ui|
			dapui.setup({
				-- Set icons to characters that are more likely to work in every terminal.
				--    Feel free to remove or use ones that you like more! :)
				--    Don't feel like these are good choices.
				icons = { expanded = "▾", collapsed = "▸", current_frame = "*" },
				controls = {
					icons = {
						pause = "⏸",
						play = "▶",
						step_into = "⏎",
						step_over = "⏭",
						step_out = "⏮",
						step_back = "b",
						run_last = "▶▶",
						terminate = "⏹",
						disconnect = "⏏",
					},
				},
			})

			-- Change breakpoint icons
			-- vim.api.nvim_set_hl(0, 'DapBreak', { fg = '#e51400' })
			-- vim.api.nvim_set_hl(0, 'DapStop', { fg = '#ffcc00' })
			-- local breakpoint_icons = vim.g.have_nerd_font
			--     and { Breakpoint = '', BreakpointCondition = '', BreakpointRejected = '', LogPoint = '', Stopped = '' }
			--   or { Breakpoint = '●', BreakpointCondition = '⊜', BreakpointRejected = '⊘', LogPoint = '◆', Stopped = '⭔' }
			-- for type, icon in pairs(breakpoint_icons) do
			--   local tp = 'Dap' .. type
			--   local hl = (type == 'Stopped') and 'DapStop' or 'DapBreak'
			--   vim.fn.sign_define(tp, { text = icon, texthl = hl, numhl = hl })
			-- end

			dap.listeners.after.event_initialized["dapui_config"] = dapui.open
			dap.listeners.before.event_terminated["dapui_config"] = dapui.close
			dap.listeners.before.event_exited["dapui_config"] = dapui.close

			-- Install golang specific config
			require("dap-go").setup({
				delve = {
					-- On Windows delve must be run attached or it crashes.
					-- See https://github.com/leoluz/nvim-dap-go/blob/main/README.md#configuring
					detached = vim.fn.has("win32") == 0,
				},
			})
		end,
	},

	-- Avante.nvim - AI-powered code assistant (DISABLED)
	-- {
	--     "yetone/avante.nvim",
	--     -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
	--     -- ⚠️ must add this setting! ! !
	--     build = vim.fn.has("win32") ~= 0
	--         and "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
	--         or "make",
	--     event = "VeryLazy",
	--     version = false, -- Never set this value to "*"! Never!
	--     ---@module 'avante'
	--     ---@type avante.Config
	--     opts = {
	--         -- add any opts here
	--         -- for example
	--         provider = "claude",
	--         providers = {
	--             claude = {
	--                 endpoint = "https://api.anthropic.com",
	--                 model = "claude-sonnet-4-20250514",
	--                 timeout = 30000, -- Timeout in milliseconds
	--                 extra_request_body = {
	--                     temperature = 0.75,
	--                     max_tokens = 20480,
	--                 },
	--             },
	--             moonshot = {
	--                 endpoint = "https://api.moonshot.ai/v1",
	--                 model = "kimi-k2-0711-preview",
	--                 timeout = 30000, -- Timeout in milliseconds
	--                 extra_request_body = {
	--                     temperature = 0.75,
	--                     max_tokens = 32768,
	--                 },
	--             },
	--         },
	--     },
	--     dependencies = {
	--         "nvim-lua/plenary.nvim",
	--         "MunifTanjim/nui.nvim",
	--         --- The below dependencies are optional and lazy loaded,
	--         { "echasnovski/mini.pick", lazy = true }, -- for file_selector provider mini.pick
	--         { "nvim-telescope/telescope.nvim", lazy = true }, -- for file_selector provider telescope
	--         { "hrsh7th/nvim-cmp", lazy = true }, -- autocompletion for avante commands and mentions
	--         { "ibhagwan/fzf-lua", lazy = true }, -- for file_selector provider fzf
	--         { "stevearc/dressing.nvim", lazy = true }, -- for input provider dressing
	--         { "nvim-tree/nvim-web-devicons", lazy = true }, -- or echasnovski/mini.icons
	--         {
	--             -- support for image pasting
	--             "HakonHarnes/img-clip.nvim",
	--             event = "VeryLazy",
	--             opts = {
	--                 -- recommended settings
	--                 default = {
	--                     embed_image_as_base64 = false,
	--                     prompt_for_file_name = false,
	--                     drag_and_drop = {
	--                         insert_mode = true,
	--                     },
	--                     -- required for Windows users
	--                     use_absolute_path = true,
	--                 },
	--             },
	--         },
	--         {
	--             -- Make sure to set this up properly if you have lazy=true
	--             'MeanderingProgrammer/render-markdown.nvim',
	--             opts = {
	--                 file_types = { "markdown", "Avante" },
	--                 latex = { enabled = false }, -- Disable latex support to avoid warnings
	--                 html = { enabled = false },  -- Disable html support to avoid warnings
	--             },
	--             ft = { "markdown", "Avante" },
	--         },
	--     },
	-- },

	-- Parrot.nvim - AI-powered assistant (DISABLED)
	-- {
	--     "frankroeder/parrot.nvim",
	--     dependencies = { "ibhagwan/fzf-lua", "nvim-lua/plenary.nvim" },
	--     config = function()
	--         require("parrot").setup {
	--             -- Providers must be explicitly set up to make them available.
	--             providers = {
	--                 openai = {
	--                     name = "openai",
	--                     api_key = os.getenv "OPENAI_API_KEY",
	--                     endpoint = "https://api.openai.com/v1/chat/completions",
	--                     params = {
	--                         chat = { temperature = 1.1, top_p = 1 },
	--                         command = { temperature = 1.1, top_p = 1 },
	--                     },
	--                     topic = {
	--                         model = "gpt-4o-mini",
	--                         params = { max_completion_tokens = 64 },
	--                     },
	--                     models = {
	--                         "gpt-4o",
	--                         "gpt-4o-mini",
	--                         "o1-preview",
	--                         "o1-mini",
	--                     }
	--                 },
	--             },
	--
	--             -- Key bindings
	--             chat_shortcut_respond = { modes = { "n", "i", "v", "x" }, shortcut = "<C-g><C-g>" },
	--             chat_shortcut_delete = { modes = { "n", "i", "v", "x" }, shortcut = "<C-g>d" },
	--             chat_shortcut_stop = { modes = { "n", "i", "v", "x" }, shortcut = "<C-g>s" },
	--             chat_shortcut_new = { modes = { "n", "i", "v", "x" }, shortcut = "<C-g>c" },

	--             -- Default target for chats
	--             toggle_target = "vsplit",

	--             -- User interface
	--             user_input_ui = "native",
	--             style_popup_border = "single",
	--
	--             -- Additional hooks for common tasks
	--             hooks = {
	--                 Ask = function(parrot, params)
	--                     local template = [[
	--                         In light of your existing knowledge base, please generate a response that
	--                         is succinct and directly addresses the question posed. Prioritize accuracy
	--                         and relevance in your answer, drawing upon the most recent information
	--                         available to you. Aim to deliver your response in a concise manner,
	--                         focusing on the essence of the inquiry.
	--                         Question: {{command}}
	--                     ]]
	--                     local model_obj = parrot.get_model("command")
	--                     parrot.logger.info("Asking model: " .. model_obj.name)
	--                     parrot.Prompt(params, parrot.ui.Target.popup, model_obj, "🤖 Ask ~ ", template)
	--                 end,
	--
	--                 SpellCheck = function(prt, params)
	--                     local chat_prompt = [[
	--                         Your task is to take the text provided and rewrite it into a clear,
	--                         grammatically correct version while preserving the original meaning
	--                         as closely as possible. Correct any spelling mistakes, punctuation
	--                         errors, verb tense issues, word choice problems, and other
	--                         grammatical mistakes.
	--                     ]]
	--                     prt.ChatNew(params, chat_prompt)
	--                 end,

	--                 CompleteFullContext = function(prt, params)
	--                     local template = [[
	--                         I have the following code from {{filename}}:

	--                         ```{{filetype}}
	--                         {{filecontent}}
	--                         ```

	--                         Please look at the following section specifically:
	--                         ```{{filetype}}
	--                         {{selection}}
	--                         ```

	--                         Please finish the code above carefully and logically.
	--                         Respond just with the snippet of code that should be inserted.
	--                     ]]
	--                     local model_obj = prt.get_model("command")
	--                     prt.Prompt(params, prt.ui.Target.append, model_obj, nil, template)
	--                 end,

	--                 CodeConsultant = function(prt, params)
	--                     local chat_prompt = [[
	--                         Your task is to analyze the provided {{filetype}} code and suggest
	--                         improvements to optimize its performance. Identify areas where the
	--                         code can be made more efficient, faster, or less resource-intensive.
	--                         Provide specific suggestions for optimization, along with explanations
	--                         of how these changes can enhance the code's performance. The optimized
	--                         code should maintain the same functionality as the original code while
	--                         demonstrating improved efficiency.

	--                         Here is the code
	--                         ```{{filetype}}
	--                         {{filecontent}}
	--                         ```
	--                     ]]
	--                     prt.ChatNew(params, chat_prompt)
	--                 end,
	--             },

	--             -- Prompt collection for common tasks
	--             prompts = {
	--                 ["Spell"] = "I want you to proofread the provided text and fix the errors.",
	--                 ["Comment"] = "Provide a comment that explains what the snippet is doing.",
	--                 ["Complete"] = "Continue the implementation of the provided snippet in the file {{filename}}.",
	--                 ["Optimize"] = "Optimize the following code for better performance and readability.",
	--                 ["Explain"] = "Explain what this code does in simple terms.",
	--             },
	--         }
	--     end,
	-- },
}
