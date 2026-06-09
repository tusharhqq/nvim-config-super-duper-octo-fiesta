return {
	-- Package Manager
	"folke/lazy.nvim",

	-- Snacks.nvim (high priority, not lazy loaded)
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		opts = {
			bigfile = { enabled = true },
			notifier = { enabled = true },
			-- Disabled: quickfile starts Treesitter before dadima.markdown guards apply.
			quickfile = { enabled = false },
			statuscolumn = { enabled = true },
			words = { enabled = true },
			styles = {
				notification = {
					wo = { wrap = true }, -- Wrap notifications
				},
			},
		},
	},

	-- Sneak
	"justinmk/vim-sneak",

	-- GitHub PRs/issues
	{
		"justinmk/guh.nvim",
		cmd = "Guh",
		keys = {
			{ "<leader>gh", "<cmd>Guh<cr>", desc = "GitHub PRs/issues" },
		},
	},

	-- Telescope
	{
		"nvim-telescope/telescope.nvim",
		cmd = "Telescope",
		keys = {
			{ "<leader>pf", "<cmd>Telescope find_files<cr>", desc = "Find files" },
			{ "<C-p>", "<cmd>Telescope git_files<cr>", desc = "Find git files" },
			{ "<leader>ps", "<cmd>Telescope live_grep<cr>", desc = "Live grep" },
			{ "<leader>vh", "<cmd>Telescope help_tags<cr>", desc = "Help tags" },
		},
		dependencies = { "nvim-lua/plenary.nvim" },
	},

	-- Theme (prioritized for fast loading)
	{
		"rose-pine/neovim",
		name = "rose-pine",
		priority = 1000, -- Load before other plugins
		lazy = false, -- Don't lazy load the colorscheme
		config = function()
			require("rose-pine").setup({
				disable_background = true,
			})
			vim.defer_fn(function()
				vim.cmd.colorscheme("rose-pine")
				vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
				vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
			end, 50)
		end,
	},

	{
		"ThePrimeagen/vim-be-good",
		cmd = "VimBeGood",
	},
}
