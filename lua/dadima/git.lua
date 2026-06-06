return {
	-- Git
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
				local opts = { buffer = bufnr }
				local function with_desc(desc)
					return vim.tbl_extend("force", opts, { desc = desc })
				end

				local function set_maps(mode, maps)
					for _, map in ipairs(maps) do
						vim.keymap.set(mode, map[1], map[2], with_desc(map.desc))
					end
				end

				local function nav_hunk(key, direction)
					return function()
						if vim.wo.diff then
							vim.cmd.normal({ key, bang = true })
						else
							gitsigns.nav_hunk(direction)
						end
					end
				end

				local function selected_hunk(action)
					return function()
						action({ vim.fn.line("."), vim.fn.line("v") })
					end
				end

				set_maps("n", {
					{ "]c", nav_hunk("]c", "next"), desc = "Jump to next git [c]hange" },
					{ "[c", nav_hunk("[c", "prev"), desc = "Jump to previous git [c]hange" },
					{ "<leader>hs", gitsigns.stage_hunk, desc = "git [s]tage hunk" },
					{ "<leader>hr", gitsigns.reset_hunk, desc = "git [r]eset hunk" },
					{ "<leader>hS", gitsigns.stage_buffer, desc = "git [S]tage buffer" },
					{ "<leader>hu", gitsigns.undo_stage_hunk, desc = "git [u]ndo stage hunk" },
					{ "<leader>hR", gitsigns.reset_buffer, desc = "git [R]eset buffer" },
					{ "<leader>hp", gitsigns.preview_hunk, desc = "git [p]review hunk" },
					{ "<leader>hb", gitsigns.blame_line, desc = "git [b]lame line" },
					{ "<leader>hd", gitsigns.diffthis, desc = "git [d]iff against index" },
					{
						"<leader>hD",
						function()
							gitsigns.diffthis("@")
						end,
						desc = "git [D]iff against last commit",
					},
					{ "<leader>tb", gitsigns.toggle_current_line_blame, desc = "[T]oggle git show [b]lame line" },
					{ "<leader>tD", gitsigns.toggle_deleted, desc = "[T]oggle git show [D]eleted" },
				})

				set_maps("v", {
					{ "<leader>hs", selected_hunk(gitsigns.stage_hunk), desc = "git [s]tage hunk" },
					{ "<leader>hr", selected_hunk(gitsigns.reset_hunk), desc = "git [r]eset hunk" },
				})
			end,
		},
	},
}
