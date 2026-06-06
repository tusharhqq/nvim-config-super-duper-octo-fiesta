local M = {}

-- Markdown / markdown_inline Treesitter parsers crash on Neovim 0.12.x during
-- injection parsing. Use Vim's regex markdown syntax instead and prevent
-- Treesitter from starting on markdown buffers.
M.langs = { "markdown", "markdown_inline" }
M.ft = "markdown"

function M.is_markdown_lang(lang)
	return lang == "markdown" or lang == "markdown_inline"
end

function M.is_markdown_buf(bufnr)
	return vim.bo[bufnr or 0].filetype == M.ft
end

function M.setup()
	if M._setup_done then
		return
	end
	M._setup_done = true

	local ts_start = vim.treesitter.start
	vim.treesitter.start = function(bufnr, lang)
		bufnr = bufnr == 0 and vim.api.nvim_get_current_buf() or (bufnr or vim.api.nvim_get_current_buf())
		lang = lang or vim.treesitter.language.get_lang(vim.bo[bufnr].filetype)
		if M.is_markdown_lang(lang) then
			return
		end
		return ts_start(bufnr, lang)
	end

	vim.api.nvim_create_autocmd("FileType", {
		pattern = M.ft,
		callback = function(args)
			pcall(vim.treesitter.stop, args.buf)
		end,
	})
end

return M
