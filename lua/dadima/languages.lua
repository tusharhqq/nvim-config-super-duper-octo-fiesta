local M = {}

local language_specs = {
	{
		name = "bash",
		treesitter = "bash",
		lsp = "bashls",
	},
	{
		name = "c",
		treesitter = "c",
		formatters = { "clang_format" },
		lsp = "clangd",
		disable_treesitter_indent = true,
	},
	{
		name = "cpp",
		treesitter = "cpp",
		formatters = { "clang_format" },
		lsp = "clangd",
		disable_treesitter_indent = true,
	},
	{
		name = "css",
		treesitter = "css",
		formatters = { "oxfmt" },
	},
	{
		name = "dockerfile",
		treesitter = "dockerfile",
		lsp = "dockerls",
	},
	{
		name = "go",
		treesitter = "go",
		formatters = { "gofmt" },
		linters = { "golangcilint" },
		lsp = "gopls",
	},
	{
		name = "html",
		treesitter = "html",
		formatters = { "oxfmt" },
		lsp = "html",
	},
	{
		name = "javascript",
		treesitter = "javascript",
		formatters = { "oxfmt" },
		lsp = { "tsgo", "oxlint" },
	},
	{
		name = "javascriptreact",
		formatters = { "oxfmt" },
	},
	{
		name = "json",
		treesitter = "json",
		formatters = { "oxfmt" },
		linters = { "jsonlint" },
		lsp = "jsonls",
	},
	{
		name = "lua",
		treesitter = "lua",
		formatters = { "stylua" },
		linters = { "luacheck" },
		lsp = {
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
		},
	},
	{
		name = "ocaml",
		formatters = { "ocamlformat" },
		lsp = "ocamllsp",
	},
	{
		name = "python",
		treesitter = "python",
		formatters = { "ruff_fix", "ruff_organize_imports", "ruff_format" },
		-- ruff server config lives in lsp/ruff.lua; enabled here for cmp capabilities.
		lsp = { "ruff", "ty" },
	},
	{
		name = "reason",
		formatters = { "ocamlformat" },
	},
	{
		name = "rust",
		treesitter = "rust",
		formatters = { "rustfmt" },
		lsp = "rust_analyzer",
	},
	{
		name = "svelte",
		treesitter = "svelte",
		lsp = "svelte",
	},
	{
		name = "toml",
		treesitter = "toml",
		formatters = { "oxfmt" },
	},
	{
		name = "tsx",
		treesitter = "tsx",
	},
	{
		name = "typescript",
		treesitter = "typescript",
		formatters = { "oxfmt" },
	},
	{
		name = "typescriptreact",
		formatters = { "oxfmt" },
	},
	{
		name = "yaml",
		treesitter = "yaml",
		formatters = { "oxfmt" },
		linters = { "yamllint" },
	},
	{
		name = "zig",
		treesitter = "zig",
		formatters = { "zigfmt" },
		lsp = "zls",
	},
}

local treesitter_extras = { "query", "vim", "vimdoc" }
local autotag_filetypes = {
	"html",
	"javascript",
	"svelte",
	"typescript",
	"typescriptreact",
	"javascriptreact",
}

local function listify(value)
	if value == nil then
		return {}
	end

	if type(value) == "table" then
		if value.name then
			return { value }
		end

		return value
	end

	return { value }
end

function M.treesitter_ensure_installed()
	local parsers = {}
	for _, spec in ipairs(language_specs) do
		if spec.treesitter then
			table.insert(parsers, spec.treesitter)
		end
	end

	for _, parser in ipairs(treesitter_extras) do
		table.insert(parsers, parser)
	end

	return parsers
end

function M.treesitter_indent_disable()
	local disabled = {}
	for _, spec in ipairs(language_specs) do
		if spec.disable_treesitter_indent then
			table.insert(disabled, spec.treesitter or spec.name)
		end
	end

	return disabled
end

function M.formatters_by_ft()
	local formatters = {}
	for _, spec in ipairs(language_specs) do
		if spec.formatters then
			formatters[spec.name] = spec.formatters
		end
	end

	return formatters
end

function M.linters_by_ft()
	local linters = {}
	for _, spec in ipairs(language_specs) do
		if spec.linters then
			linters[spec.name] = spec.linters
		end
	end

	return linters
end

function M.lsp_servers()
	local servers = {}
	local seen = {}

	for _, spec in ipairs(language_specs) do
		for _, server in ipairs(listify(spec.lsp)) do
			local normalized = type(server) == "string" and { name = server } or server
			if normalized and not seen[normalized.name] then
				seen[normalized.name] = true
				table.insert(servers, normalized)
			end
		end
	end

	return servers
end

function M.autotag_filetypes()
	return autotag_filetypes
end

return M
