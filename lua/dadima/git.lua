return {
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
			{
				"<leader>gg",
				function()
					vim.cmd("tabnew")
					local win = vim.api.nvim_get_current_win()
					vim.fn.termopen("lazygit", {
						on_exit = function()
							vim.schedule(function()
								if vim.api.nvim_win_is_valid(win) then
									vim.api.nvim_win_close(win, true)
								end
							end)
						end,
					})
					vim.cmd("startinsert")
				end,
				desc = "LazyGit",
			},
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
}
