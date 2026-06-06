return {
	-- Linting
	{
		"mfussenegger/nvim-lint",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			local languages = require("dadima.languages")
			local lint = require("lint")
			local function filter_available_linters(names)
				return vim.tbl_filter(function(name)
					local linter = lint.linters[name]
					if not linter then
						return false
					end

					local cmd = linter.cmd
					if type(cmd) == "function" or cmd == nil then
						return true
					end

					return vim.fn.executable(cmd) == 1
				end, names)
			end

			lint.linters_by_ft = languages.linters_by_ft()

			-- Create autocommand which carries out the actual linting
			local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
			vim.api.nvim_create_autocmd({ "BufWritePost" }, {
				group = lint_augroup,
				callback = function()
					-- Only run the linter in buffers that you can modify
					if vim.bo.modifiable then
						local ft = vim.bo.filetype
						local names = lint.linters_by_ft[ft] or {}
						local available = filter_available_linters(names)

						if #available > 0 then
							lint.try_lint(available)
						end
					end
				end,
			})
		end,
	},
}
