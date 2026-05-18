vim.opt.guicursor = "n-v-c:block-blinkwait700-blinkoff400-blinkon250,i-ci-ve:ver25-blinkwait700-blinkoff400-blinkon250,r-cr:hor20,o:hor50"

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.ignorecase = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

vim.opt.colorcolumn = "80"

-- The markdown / markdown_inline Treesitter parsers currently crash on this
-- Neovim 0.12.x setup during injection parsing. Use regular markdown syntax
-- highlighting instead and prevent plugins from starting Treesitter for .md files.
local ts_start = vim.treesitter.start
vim.treesitter.start = function(bufnr, lang)
	bufnr = bufnr == 0 and vim.api.nvim_get_current_buf() or (bufnr or vim.api.nvim_get_current_buf())
	lang = lang or vim.treesitter.language.get_lang(vim.bo[bufnr].filetype)
	if lang == "markdown" or lang == "markdown_inline" then
		return
	end
	return ts_start(bufnr, lang)
end

vim.api.nvim_create_autocmd("FileType", {
	pattern = "markdown",
	callback = function(args)
		pcall(vim.treesitter.stop, args.buf)
	end,
})

vim.diagnostic.config({
	severity_sort = true,
	underline = true,
	update_in_insert = false,
	virtual_text = {
		spacing = 2,
		source = "if_many",
	},
	float = {
		border = "rounded",
		source = "if_many",
	},
})
