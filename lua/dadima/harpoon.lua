return {
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
}
