local original_start = vim.treesitter.start

vim.treesitter.start = function(bufnr, lang)
	bufnr = bufnr or 0
	lang = lang or vim.treesitter.language.get_lang(vim.bo[bufnr].filetype)

	if lang == "markdown" and vim.bo[bufnr].filetype == "markdown" then
		return false
	end

	return original_start(bufnr, lang)
end
