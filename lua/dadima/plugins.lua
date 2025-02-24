return {
    -- Package Manager
    "folke/lazy.nvim",

    -- Sneak
    "justinmk/vim-sneak",

    -- Formatting
    {
        "nvimtools/none-ls.nvim",
        opts = {}
    },

    -- Auto Tag
    {
        "windwp/nvim-ts-autotag",
        ft = {
            "javascript",
            "typescript",
            "typescriptreact",
            "javascriptreact"
        },
        config = function()
            require("nvim-ts-autotag").setup()
        end
    },

    -- Neoformat
    "sbdchd/neoformat",

    -- Telescope
    {
        "nvim-telescope/telescope.nvim",
        version = "0.1.5",
        dependencies = { "nvim-lua/plenary.nvim" }
    },

    -- Theme
    {
        "rose-pine/neovim",
        name = "rose-pine",
        config = function()
            vim.cmd('colorscheme rose-pine')
        end
    },

    -- Treesitter
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate"
    },
    "nvim-treesitter/playground",
    "nvim-treesitter/nvim-treesitter-context",

    -- Navigation and Git
    {
        "ThePrimeagen/harpoon",
        branch = "master",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            local harpoon = require("harpoon")
            harpoon.setup({
                global_settings = {
                    save_on_toggle = false,
                    save_on_change = true,
                    enter_on_sendcmd = false,
                    tmux_autoclose_windows = false,
                    excluded_filetypes = { "harpoon" },
                    mark_branch = false
                }
            })
        end
    },
    "mbbill/undotree",
    "tpope/vim-fugitive",
    "ThePrimeagen/vim-be-good",

    -- Copilot
    {
        "github/copilot.vim",
        cmd = "Copilot",
        event = "TextChangedI",
        ft = "markdown"
    },

    -- LSP
    {
        "VonHeikemen/lsp-zero.nvim",
        branch = "v1.x",
        dependencies = {
            -- LSP Support
            "neovim/nvim-lspconfig",
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",

            -- Autocompletion
            "hrsh7th/nvim-cmp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "saadparwaiz1/cmp_luasnip",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-nvim-lua",

            -- Snippets
            "L3MON4D3/LuaSnip",
            "rafamadriz/friendly-snippets"
        }
    }
}