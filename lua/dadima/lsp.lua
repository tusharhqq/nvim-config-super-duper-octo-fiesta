return {
	-- Mason
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

	-- Completion
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-nvim-lsp",
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
					expand = function() end,
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
							fallback()
						end
					end, { "i", "s" }),
					["<S-Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						else
							fallback()
						end
					end, { "i", "s" }),
				}),
			})
		end,
	},

	-- LSP
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			vim.opt.signcolumn = "yes"

			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("dadima_lsp_attach", { clear = true }),
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
					vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)

					local client = vim.lsp.get_client_by_id(event.data.client_id)
					if client and client.name == "ruff" then
						-- Disable hover in favor of ty
						client.server_capabilities.hoverProvider = false
					end
				end,
				desc = "LSP: Set keymaps and client-specific capabilities",
			})

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
			})
			vim.lsp.enable("ruff", true)

			vim.lsp.config("ty", {
				capabilities = capabilities,
			})
			vim.lsp.enable("ty", true)
		end,
	},

	-- TypeScript Error Translator
	{
		"dmmulroy/ts-error-translator.nvim",
		ft = { "typescript", "javascript", "typescriptreact", "javascriptreact" },
		config = function()
			require("ts-error-translator").setup({
				auto_attach = true,
			})
		end,
	},
}
