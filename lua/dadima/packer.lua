-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd.packadd('packer.nvim')

return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'
  use 'justinmk/vim-sneak'




  use ({
      'nvimtools/none-ls.nvim',
      opts = function ()
      end,
      })

  use ({
      'windwp/nvim-ts-autotag',
      ft = {
          "javascript",
          "typescript",
          "typescriptreact",
          "javascriptreact"
      },

      config = function ()
          require("nvim-ts-autotag").setup()
      end
  })
















  use 'sbdchd/neoformat'
  use {
	  'nvim-telescope/telescope.nvim', tag = '0.1.5',
	  -- or                            , branch = '0.1.x',
	  requires = { {'nvim-lua/plenary.nvim'} }
  }

  use({
	  'rose-pine/neovim',
	  as = 'rose-pine',
	  config = function()
		  vim.cmd('colorscheme rose-pine')
	  end
  })

   use {
			'nvim-treesitter/nvim-treesitter',
			run = function()
				local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
				ts_update()
			end,}
  use("nvim-treesitter/playground")
  use("nvim-treesitter/nvim-treesitter-context")
  use("theprimeagen/harpoon")
  use("mbbill/undotree")
  use("tpope/vim-fugitive")
  use("ThePrimeagen/vim-be-good")
--  use { 'sourcegraph/sg.nvim', run = 'nvim -l build/init.lua' }
--  use { 'nvim-lua/plenary.nvim' }

--use{
--    "github/copilot.vim",
--    cmd = "Copilot",
--    event = "TextChangedI",
--    ft = "markdown"
--}

  use {
      'VonHeikemen/lsp-zero.nvim',
      branch = 'v1.x',
      requires = {
          -- LSP Support
          {'neovim/nvim-lspconfig'},
          {'williamboman/mason.nvim'},
          {'williamboman/mason-lspconfig.nvim'},

		  -- Autocompletion
		  {'hrsh7th/nvim-cmp'},
		  {'hrsh7th/cmp-buffer'},
		  {'hrsh7th/cmp-path'},
		  {'saadparwaiz1/cmp_luasnip'},
		  {'hrsh7th/cmp-nvim-lsp'},
		  {'hrsh7th/cmp-nvim-lua'},
          {'hrsh7th/cmp-cmdline'},

		  -- Snippets
		  {'L3MON4D3/LuaSnip'},
		  {'rafamadriz/friendly-snippets'},

          {'j-hui/fidget.nvim'},

	  }
  }
  end)
