return {
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
}
