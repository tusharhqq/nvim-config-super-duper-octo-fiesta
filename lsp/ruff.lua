---@type vim.lsp.Config
return {
	cmd = { "ruff", "server" },
	filetypes = { "python" },
	root_markers = { "pyproject.toml", "ruff.toml", ".ruff.toml", ".git" },
	on_init = function(client)
		-- ty owns hover for Python buffers.
		client.server_capabilities.hoverProvider = false
	end,
	init_options = {
		settings = {
			-- Ruff language server settings go here.
		},
	},
}
