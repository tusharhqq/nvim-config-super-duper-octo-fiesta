local lsp_maps = {
	{ "K", vim.lsp.buf.hover },
	{ "gd", vim.lsp.buf.definition },
	{ "gD", vim.lsp.buf.declaration },
	{ "gi", vim.lsp.buf.implementation },
	{ "go", vim.lsp.buf.type_definition },
	{ "gr", vim.lsp.buf.references },
	{ "gs", vim.lsp.buf.signature_help },
	{ "<leader>rn", vim.lsp.buf.rename },
	{ "<leader>ca", vim.lsp.buf.code_action },
}

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
				-- Required by nvim-cmp, even though this config does not use snippet expansion.
				snippet = { expand = function() end },
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
			local mason_bin = require("dadima.mason_bin")

			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("dadima_lsp_attach", { clear = true }),
				callback = function(event)
					local opts = { buffer = event.buf }
					for _, map in ipairs(lsp_maps) do
						vim.keymap.set("n", map[1], map[2], opts)
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

			local servers = {
				{
					name = "lua_ls",
					config = {
						settings = {
							Lua = {
								diagnostics = {
									globals = { "vim" },
								},
							},
						},
					},
				},
				{ name = "bashls" },
				{ name = "clangd" },
				{ name = "dockerls" },
				{ name = "rust_analyzer" },
				{ name = "gopls" },
				{ name = "html" },
				{ name = "jsonls" },
				{ name = "svelte" },
				{ name = "tsgo" },
				{ name = "oxlint" },
				{ name = "zls" },
				{
					name = "ruff",
					config = {
						on_init = function(client)
							-- Disable hover in favor of ty.
							client.server_capabilities.hoverProvider = false
						end,
					},
				},
				{ name = "ty" },
				{
					name = "ocamllsp",
					config = {
						cmd = { mason_bin .. "/ocamllsp" },
					},
				},
			}

			for _, server in ipairs(servers) do
				local config = vim.tbl_deep_extend("force", { capabilities = capabilities }, server.config or {})

				vim.lsp.config(server.name, config)
				vim.lsp.enable(server.name, true)
			end
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
