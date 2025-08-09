return {
    -- Package Manager
    "folke/lazy.nvim",

    -- Sneak
    "justinmk/vim-sneak",



    -- Formatting (using conform.nvim instead of none-ls)
    {
        "stevearc/conform.nvim",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            local conform = require("conform")
        
            conform.setup({
                formatters_by_ft = {
                    javascript = { "prettier" },
                    typescript = { "prettier" },
                    javascriptreact = { "prettier" },
                    typescriptreact = { "prettier" },
                    css = { "prettier" },
                    html = { "prettier" },
                    json = { "prettier" },
                    yaml = { "prettier" },
                    markdown = { "prettier" },
                    liquid = { "prettier" },
                    lua = { "stylua" },
                    python = { "isort", "black" },
                    go = { "gofmt" },
                    rust = { "rustfmt" },
                },
                format_on_save = {
                    lsp_fallback = true,
                    async = false,
                    timeout_ms = 1000,
                },
            })
        
            vim.keymap.set({ "n", "v" }, "<leader>mp", function()
                conform.format({
                    lsp_fallback = true,
                    async = false,
                    timeout_ms = 1000,
                })
            end, { desc = "Format file or range (in visual mode)" })
        end,
    },

    -- Linting
    {
        "mfussenegger/nvim-lint",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            local lint = require("lint")
            
            lint.linters_by_ft = {
                javascript = { "eslint_d" },
                typescript = { "eslint_d" },
                javascriptreact = { "eslint_d" },
                typescriptreact = { "eslint_d" },
                python = { "pylint" },
                lua = { "luacheck" },
                markdown = { "markdownlint" },
                json = { "jsonlint" },
                yaml = { "yamllint" },
                go = { "golangci-lint" },
                rust = { "clippy" },
            }

            -- Create autocommand which carries out the actual linting
            local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
            vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
                group = lint_augroup,
                callback = function()
                    -- Only run the linter in buffers that you can modify
                    if vim.bo.modifiable then
                        lint.try_lint()
                    end
                end,
            })
        end,
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

    -- Indentation guides (lazy loaded to improve startup)
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        event = { "BufReadPost", "BufNewFile" },
        opts = {},
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
        config = function()
            -- Additional telescope configuration can be added here if needed
            -- Most functionality is handled via lazy.nvim keys
        end
    },

    -- Theme (prioritized for fast loading)
    {
        "rose-pine/neovim",
        name = "rose-pine",
        priority = 1000, -- Load before other plugins
        lazy = false, -- Don't lazy load the colorscheme
        config = function()
            require('rose-pine').setup({
                disable_background = true
            })
            -- Defer the actual colorscheme application to reduce startup impact
            vim.defer_fn(function()
                vim.cmd('colorscheme rose-pine')
                -- Apply custom highlights after colorscheme loads
                vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
                vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
            end, 50)
            
            -- Custom colorscheme function
            _G.ColorMyPencils = function(color)
                color = color or "rose-pine"
                vim.cmd.colorscheme(color)
                vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
                vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
            end
        end
    },

    -- Treesitter
    {
        "nvim-treesitter/nvim-treesitter",
        event = { "BufReadPost", "BufNewFile" },
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter.configs").setup({
                -- Only install essential parsers at startup
                ensure_installed = {
                    "lua", "vim", "vimdoc", "query", -- Essential for nvim
                },

                -- Install parsers synchronously (only applied to `ensure_installed`)
                sync_install = false,

                -- Enable auto-install after startup to avoid blocking
                auto_install = false, -- Disabled for faster startup

                highlight = {
                    enable = true,
                    -- Disable highlighting for files larger than 100KB
                    disable = function(lang, buf)
                        local max_filesize = 100 * 1024 -- 100 KB
                        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
                        if ok and stats and stats.size > max_filesize then
                            return true
                        end
                        return false
                    end,
                    -- Disable additional Vim regex highlighting to avoid duplicates
                    additional_vim_regex_highlighting = false,
                },

                indent = {
                    enable = true
                },
            })
            
            -- Enable auto-install after startup delay to avoid slowing down startup
            vim.defer_fn(function()
                require("nvim-treesitter.configs").setup({
                    auto_install = true,
                })
            end, 1000)
        end
    },
    {
        "nvim-treesitter/playground",
        cmd = "TSPlaygroundToggle",
    },
    {
        "nvim-treesitter/nvim-treesitter-context",
        event = { "BufReadPost", "BufNewFile" },
    },

    -- Navigation and Git
    {
        "ThePrimeagen/harpoon",
        lazy = true, -- Only load when keys are used
        keys = {
            { "<leader>a", function() require("harpoon.mark").add_file() end, desc = "Add file to harpoon" },
            { "<C-e>", function() require("harpoon.ui").toggle_quick_menu() end, desc = "Toggle harpoon menu" },
            { "<C-h>", function() require("harpoon.ui").nav_file(1) end, desc = "Navigate to harpoon file 1" },
            { "<C-t>", function() require("harpoon.ui").nav_file(2) end, desc = "Navigate to harpoon file 2" },
            { "<C-n>", function() require("harpoon.ui").nav_file(3) end, desc = "Navigate to harpoon file 3" },
            { "<C-s>", function() require("harpoon.ui").nav_file(4) end, desc = "Navigate to harpoon file 4" },
            { "<A-p>", function() require("harpoon.ui").nav_prev() end, desc = "Navigate to previous harpoon mark" },
            { "<A-n>", function() require("harpoon.ui").nav_next() end, desc = "Navigate to next harpoon mark" },
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
                    mark_branch = false
                }
            })
        end,
    },
    {
        "mbbill/undotree",
        cmd = "UndotreeToggle",
        keys = {
            { "<leader>u", "<cmd>UndotreeToggle<cr>", desc = "Toggle UndoTree" },
        },
    },
    {
        "tpope/vim-fugitive",
        cmd = { "Git", "G", "Gdiffsplit", "Gread", "Gwrite", "Ggrep", "GMove", "GDelete", "GBrowse", "GRemove", "GRename", "Glgrep", "Gedit" },
        keys = {
            { "<leader>gs", "<cmd>Git<cr>", desc = "Git status" },
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
    {
        "ThePrimeagen/vim-be-good",
        cmd = "VimBeGood",
    },

    -- Copilot (manual activation only)
    {
        "github/copilot.vim",
        cmd = "Copilot", -- Only loads when :Copilot command is used
        config = function()
            -- Disable auto-start and auto-suggestions
            vim.g.copilot_enabled = false
            vim.g.copilot_no_tab_map = true
            vim.g.copilot_assume_mapped = true
            
            -- Create commands for manual Copilot control
            vim.api.nvim_create_user_command('CopilotEnable', function()
                vim.g.copilot_enabled = true
                vim.cmd('Copilot enable')
                print("Copilot enabled")
            end, { desc = "Enable Copilot suggestions" })
            
            vim.api.nvim_create_user_command('CopilotDisable', function()
                vim.g.copilot_enabled = false
                vim.cmd('Copilot disable')
                print("Copilot disabled")
            end, { desc = "Disable Copilot suggestions" })
            
            vim.api.nvim_create_user_command('CopilotToggle', function()
                if vim.g.copilot_enabled then
                    vim.g.copilot_enabled = false
                    vim.cmd('Copilot disable')
                    print("Copilot disabled")
                else
                    vim.g.copilot_enabled = true
                    vim.cmd('Copilot enable')
                    print("Copilot enabled")
                end
            end, { desc = "Toggle Copilot suggestions" })
            
            -- Optional: Add keymaps for quick access
            -- vim.keymap.set('n', '<leader>ce', ':CopilotEnable<CR>', { desc = "Enable Copilot" })
            -- vim.keymap.set('n', '<leader>cd', ':CopilotDisable<CR>', { desc = "Disable Copilot" })
            -- vim.keymap.set('n', '<leader>ct', ':CopilotToggle<CR>', { desc = "Toggle Copilot" })
        end
    },

    -- Mason (separated from LSP for better lazy loading)
    {
        "williamboman/mason.nvim",
        cmd = { "Mason", "MasonInstall", "MasonLog" },
        config = function()
            require("mason").setup()
        end
    },

    -- LSP (modernized setup without lsp-zero)
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            {
                "williamboman/mason-lspconfig.nvim",
                event = { "BufReadPre", "BufNewFile" },
            },
            {
                "hrsh7th/nvim-cmp",
                event = "InsertEnter",
                dependencies = {
                    "hrsh7th/cmp-buffer",
                    "hrsh7th/cmp-path", 
                    "hrsh7th/cmp-nvim-lsp",
                    "hrsh7th/cmp-nvim-lua",
                }
            }
        },
        config = function()
            -- Only setup LSP if packages are available (lazy loaded)
            local lspconfig_ok, lspconfig = pcall(require, 'lspconfig')
            if not lspconfig_ok then
                return
            end
            
            local cmp_ok, cmp = pcall(require, 'cmp')
            
            -- Setup nvim-cmp only if available
            if cmp_ok then
                cmp.setup({
                  sources = {
                    { name = 'nvim_lsp' },
                    { name = 'buffer' },
                    { name = 'path' },
                  },
                  snippet = {
                    expand = function(args)
                      -- Only use LuaSnip if it's loaded, otherwise no snippets
                      local luasnip_ok, luasnip = pcall(require, 'luasnip')
                      if luasnip_ok then
                        luasnip.lsp_expand(args.body)
                      end
                    end,
                  },
                  mapping = cmp.mapping.preset.insert({
                    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-f>'] = cmp.mapping.scroll_docs(4),
                    ['<C-Space>'] = cmp.mapping.complete(),
                    ['<C-e>'] = cmp.mapping.abort(),
                    ['<CR>'] = cmp.mapping.confirm({ select = true }),
                    ['<Tab>'] = cmp.mapping(function(fallback)
                      if cmp.visible() then
                        cmp.select_next_item()
                      else
                        local luasnip_ok, luasnip = pcall(require, 'luasnip')
                        if luasnip_ok and luasnip.expand_or_jumpable() then
                          luasnip.expand_or_jump()
                        else
                          fallback()
                        end
                      end
                    end, { 'i', 's' }),
                    ['<S-Tab>'] = cmp.mapping(function(fallback)
                      if cmp.visible() then
                        cmp.select_prev_item()
                      else
                        local luasnip_ok, luasnip = pcall(require, 'luasnip')
                        if luasnip_ok and luasnip.jumpable(-1) then
                          luasnip.jump(-1)
                        else
                          fallback()
                        end
                      end
                    end, { 'i', 's' }),
                  }),
                })
            end
            
            vim.opt.signcolumn = 'yes'
            
            vim.api.nvim_create_autocmd('LspAttach', {
              callback = function(event)
                local opts = {buffer = event.buf}
                vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
                vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
                vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
                vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
                vim.keymap.set('n', 'go', vim.lsp.buf.type_definition, opts)
                vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
                vim.keymap.set('n', 'gs', vim.lsp.buf.signature_help, opts)
                vim.keymap.set('n', '<F2>', vim.lsp.buf.rename, opts)
                vim.keymap.set({'n', 'x'}, '<F3>', function() vim.lsp.buf.format({async = true}) end, opts)
                vim.keymap.set('n', '<F4>', vim.lsp.buf.code_action, opts)
              end,
            })
            
            -- Setup Mason LSP Config only if available (deferred to reduce startup time)
            vim.defer_fn(function()
                local mason_lspconfig_ok, mason_lspconfig = pcall(require, 'mason-lspconfig')
                if mason_lspconfig_ok then
                    mason_lspconfig.setup({
                      ensure_installed = {
                        'lua_ls',
                        'rust_analyzer', 
                        'gopls',
                        'ts_ls',
                        'pyright',
                        'ruff',
                      },
                      automatic_installation = true,
                    })
                end
            end, 50)
            
            -- Get default capabilities for LSP
            local capabilities
            local cmp_nvim_lsp_ok, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
            if cmp_nvim_lsp_ok then
                capabilities = cmp_nvim_lsp.default_capabilities()
            else
                capabilities = vim.lsp.protocol.make_client_capabilities()
            end
            
            -- Setup individual LSP servers
            lspconfig.lua_ls.setup({
              capabilities = capabilities,
              settings = {
                Lua = {
                  diagnostics = {
                    globals = {'vim'}
                  }
                }
              }
            })
            
            lspconfig.rust_analyzer.setup({
              capabilities = capabilities,
            })
            
            lspconfig.gopls.setup({
              capabilities = capabilities,
            })
            
            lspconfig.ts_ls.setup({
              capabilities = capabilities,
            })
            
            -- Ruff setup (new ruff server replaces ruff_lsp)
            lspconfig.ruff.setup({
              capabilities = capabilities,
              init_options = {
                settings = {
                  logLevel = 'info', -- Change to 'debug' if needed
                  -- logFile = '/tmp/ruff.log', -- Uncomment to set a custom log file
                }
              }
            })
            
            -- Disable Ruff's hover if using Pyright for hover
            vim.api.nvim_create_autocmd("LspAttach", {
              group = vim.api.nvim_create_augroup('lsp_attach_disable_ruff_hover', { clear = true }),
              callback = function(args)
                local client = vim.lsp.get_client_by_id(args.data.client_id)
                if client == nil then
                  return
                end
                if client.name == 'ruff' then
                  -- Disable hover in favor of Pyright
                  client.server_capabilities.hoverProvider = false
                end
              end,
              desc = 'LSP: Disable hover capability from Ruff',
            })
            
            -- Optional: Configure Pyright to defer linting/imports to Ruff
            require('lspconfig').pyright.setup {
              settings = {
                pyright = {
                  -- Using Ruff's import organizer
                  disableOrganizeImports = true,
                },
                python = {
                  analysis = {
                    -- Ignore all files for analysis to exclusively use Ruff for linting
                    ignore = { '*' },
                  },
                },
              },
            }
        end
    },

    -- LuaSnip (completely separate for true lazy loading)
    {
        "L3MON4D3/LuaSnip",
        build = "make install_jsregexp",
        lazy = true, -- Only load when explicitly needed
        keys = {
            { "<Tab>", mode = { "i", "s" } }, -- Load when Tab is pressed in insert/select mode
            { "<S-Tab>", mode = { "i", "s" } }, -- Load when Shift+Tab is pressed
        },
        dependencies = { 
            {
                "rafamadriz/friendly-snippets",
                lazy = true,
            },
            {
                "saadparwaiz1/cmp_luasnip",
                lazy = true,
            }
        },
        config = function()
            -- Set up snippet source for nvim-cmp when LuaSnip loads
            local cmp_ok, cmp = pcall(require, 'cmp')
            if cmp_ok then
                local sources = cmp.get_config().sources or {}
                table.insert(sources, { name = 'luasnip' })
                cmp.setup({ sources = sources })
            end
            
            -- Load friendly snippets
            require('luasnip.loaders.from_vscode').lazy_load()
        end,
    },

    -- Supermaven (disabled by default to avoid conflict with Copilot)
    {
        "supermaven-inc/supermaven-nvim",
        enabled = true, -- Set to true if you want to use Supermaven instead of Copilot
        event = "InsertEnter", -- Only load when entering insert mode
        config = function()
            require("supermaven-nvim").setup({})
        end,
    },

    -- Debugging (DAP)
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            -- Creates a beautiful debugger UI
            "rcarriga/nvim-dap-ui",

            -- Required dependency for nvim-dap-ui
            "nvim-neotest/nvim-nio",

            -- Installs the debug adapters for you
            "williamboman/mason.nvim",
            "jay-babu/mason-nvim-dap.nvim",

            -- Add your own debuggers here
            "leoluz/nvim-dap-go",
        },
        keys = {
            -- Basic debugging keymaps, feel free to change to your liking!
            {
                "<F5>",
                function()
                    require("dap").continue()
                end,
                desc = "Debug: Start/Continue",
            },
            {
                "<F1>",
                function()
                    require("dap").step_into()
                end,
                desc = "Debug: Step Into",
            },
            {
                "<F2>",
                function()
                    require("dap").step_over()
                end,
                desc = "Debug: Step Over",
            },
            {
                "<F3>",
                function()
                    require("dap").step_out()
                end,
                desc = "Debug: Step Out",
            },
            {
                "<leader>b",
                function()
                    require("dap").toggle_breakpoint()
                end,
                desc = "Debug: Toggle Breakpoint",
            },
            {
                "<leader>B",
                function()
                    require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
                end,
                desc = "Debug: Set Breakpoint",
            },
            -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
            {
                "<F7>",
                function()
                    require("dapui").toggle()
                end,
                desc = "Debug: See last session result.",
            },
        },
        config = function()
            local dap = require("dap")
            local dapui = require("dapui")

            require("mason-nvim-dap").setup({
                -- Makes a best effort to setup the various debuggers with
                -- reasonable debug configurations
                automatic_installation = true,

                -- You can provide additional configuration to the handlers,
                -- see mason-nvim-dap README for more information
                handlers = {},

                -- You'll need to check that you have the required things installed
                -- online, please don't ask me how to install them :)
                ensure_installed = {
                    -- Update this to ensure that you have the debuggers for the langs you want
                    "delve",
                },
            })

            -- Dap UI setup
            -- For more information, see |:help nvim-dap-ui|
            dapui.setup({
                -- Set icons to characters that are more likely to work in every terminal.
                --    Feel free to remove or use ones that you like more! :)
                --    Don't feel like these are good choices.
                icons = { expanded = "▾", collapsed = "▸", current_frame = "*" },
                controls = {
                    icons = {
                        pause = "⏸",
                        play = "▶",
                        step_into = "⏎",
                        step_over = "⏭",
                        step_out = "⏮",
                        step_back = "b",
                        run_last = "▶▶",
                        terminate = "⏹",
                        disconnect = "⏏",
                    },
                },
            })

            -- Change breakpoint icons
            -- vim.api.nvim_set_hl(0, 'DapBreak', { fg = '#e51400' })
            -- vim.api.nvim_set_hl(0, 'DapStop', { fg = '#ffcc00' })
            -- local breakpoint_icons = vim.g.have_nerd_font
            --     and { Breakpoint = '', BreakpointCondition = '', BreakpointRejected = '', LogPoint = '', Stopped = '' }
            --   or { Breakpoint = '●', BreakpointCondition = '⊜', BreakpointRejected = '⊘', LogPoint = '◆', Stopped = '⭔' }
            -- for type, icon in pairs(breakpoint_icons) do
            --   local tp = 'Dap' .. type
            --   local hl = (type == 'Stopped') and 'DapStop' or 'DapBreak'
            --   vim.fn.sign_define(tp, { text = icon, texthl = hl, numhl = hl })
            -- end

            dap.listeners.after.event_initialized["dapui_config"] = dapui.open
            dap.listeners.before.event_terminated["dapui_config"] = dapui.close
            dap.listeners.before.event_exited["dapui_config"] = dapui.close

            -- Install golang specific config
            require("dap-go").setup({
                delve = {
                    -- On Windows delve must be run attached or it crashes.
                    -- See https://github.com/leoluz/nvim-dap-go/blob/main/README.md#configuring
                    detached = vim.fn.has("win32") == 0,
                },
            })
        end,
    },

    -- Avante.nvim - AI-powered code assistant
    {
        "yetone/avante.nvim",
        -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
        -- ⚠️ must add this setting! ! !
        build = vim.fn.has("win32") ~= 0
            and "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
            or "make",
        event = "VeryLazy",
        version = false, -- Never set this value to "*"! Never!
        ---@module 'avante'
        ---@type avante.Config
        opts = {
            -- add any opts here
            -- for example
            provider = "claude",
            providers = {
                claude = {
                    endpoint = "https://api.anthropic.com",
                    model = "claude-sonnet-4-20250514",
                    timeout = 30000, -- Timeout in milliseconds
                    extra_request_body = {
                        temperature = 0.75,
                        max_tokens = 20480,
                    },
                },
                moonshot = {
                    endpoint = "https://api.moonshot.ai/v1",
                    model = "kimi-k2-0711-preview",
                    timeout = 30000, -- Timeout in milliseconds
                    extra_request_body = {
                        temperature = 0.75,
                        max_tokens = 32768,
                    },
                },
            },
        },
        dependencies = {
            "nvim-lua/plenary.nvim",
            "MunifTanjim/nui.nvim",
            --- The below dependencies are optional and lazy loaded,
            { "echasnovski/mini.pick", lazy = true }, -- for file_selector provider mini.pick
            { "nvim-telescope/telescope.nvim", lazy = true }, -- for file_selector provider telescope
            { "hrsh7th/nvim-cmp", lazy = true }, -- autocompletion for avante commands and mentions
            { "ibhagwan/fzf-lua", lazy = true }, -- for file_selector provider fzf
            { "stevearc/dressing.nvim", lazy = true }, -- for input provider dressing
            { "folke/snacks.nvim", lazy = true }, -- for input provider snacks
            { "nvim-tree/nvim-web-devicons", lazy = true }, -- or echasnovski/mini.icons
            { "zbirenbaum/copilot.lua", lazy = true }, -- for providers='copilot'
            {
                -- support for image pasting
                "HakonHarnes/img-clip.nvim",
                event = "VeryLazy",
                opts = {
                    -- recommended settings
                    default = {
                        embed_image_as_base64 = false,
                        prompt_for_file_name = false,
                        drag_and_drop = {
                            insert_mode = true,
                        },
                        -- required for Windows users
                        use_absolute_path = true,
                    },
                },
            },
            {
                -- Make sure to set this up properly if you have lazy=true
                'MeanderingProgrammer/render-markdown.nvim',
                opts = {
                    file_types = { "markdown", "Avante" },
                },
                ft = { "markdown", "Avante" },
            },
        },
    },
}