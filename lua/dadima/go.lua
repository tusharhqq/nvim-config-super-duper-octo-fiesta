local M = {}

local go_maps = {
	{ "<leader>ee", "oif err != nil {<CR>}<Esc>Oreturn err<Esc>", desc = "Return err" },
	{ "<leader>ea", 'oassert.NoError(err, "")<Esc>F";a', desc = "Assert no error" },
	{ "<leader>ef", 'oif err != nil {<CR>}<Esc>Olog.Fatalf("error: %s\\n", err.Error())<Esc>jj', desc = "Fatal err" },
	{ "<leader>el", 'oif err != nil {<CR>}<Esc>O.logger.Error("error", "error", err)<Esc>F.;i', desc = "Log err" },
}

function M.setup()
	vim.api.nvim_create_autocmd("FileType", {
		group = vim.api.nvim_create_augroup("dadima_go", { clear = true }),
		pattern = "go",
		callback = function(event)
			for _, map in ipairs(go_maps) do
				vim.keymap.set("n", map[1], map[2], { buffer = event.buf, desc = map.desc })
			end
		end,
	})
end

return M
