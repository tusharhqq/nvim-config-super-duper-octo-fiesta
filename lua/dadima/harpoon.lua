local nav_keys = {
	{ "<C-h>", 1 },
	{ "<C-t>", 2 },
	{ "<C-n>", 3 },
	{ "<C-s>", 4 },
}

local keys = {
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
}

for _, nav_key in ipairs(nav_keys) do
	local key = nav_key[1]
	local slot = nav_key[2]
	keys[#keys + 1] = {
		key,
		function()
			require("harpoon.ui").nav_file(slot)
		end,
		desc = "Navigate to harpoon file " .. slot,
	}
end

keys[#keys + 1] = {
	"<A-p>",
	function()
		require("harpoon.ui").nav_prev()
	end,
	desc = "Navigate to previous harpoon mark",
}

keys[#keys + 1] = {
	"<A-n>",
	function()
		require("harpoon.ui").nav_next()
	end,
	desc = "Navigate to next harpoon mark",
}

return {
	{
		"ThePrimeagen/harpoon",
		lazy = true, -- Only load when keys are used
		keys = keys,
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
