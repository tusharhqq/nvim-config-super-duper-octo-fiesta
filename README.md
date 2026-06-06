# nvim-config-super-duper-octo-fiesta

Personal Neovim configuration for a fast, keyboard-focused editor setup with lazy-loaded plugins, Rose Pine styling, Telescope navigation, Harpoon marks, LSP support, formatting, diagnostics, and Git helpers.

## What is this?

This repository contains my Neovim config. The entry point is `init.lua`, which loads the `lua/dadima/` modules:

- `lua/dadima/init.lua` wires the config together.
- `lua/dadima/lazy.lua` bootstraps lazy.nvim and imports plugin modules in load order.
- `lua/dadima/plugins.lua` declares shared plugin specs, conform.nvim formatting, and nvim-lint linting.
- `lua/dadima/lsp.lua` configures language servers, completion, and LSP-specific settings.
- `lua/dadima/treesitter.lua` configures Treesitter.
- `lua/dadima/markdown.lua` disables the unstable Markdown Treesitter path and is loaded before lazy.nvim.
- `lua/dadima/harpoon.lua` configures Harpoon navigation and keymaps.
- `lua/dadima/git.lua` configures Git integrations.
- `lua/dadima/undotree.lua` configures undo history.
- `lua/dadima/remap.lua` defines keymaps.
- `lua/dadima/set.lua` defines editor options and global diagnostic display behavior.
- `lazy-lock.json` pins plugin versions.

## Who is it for?

This is mainly for me and for anyone who wants to study or reuse a macOS-oriented Neovim setup with modern JavaScript, Python, LSP, formatting, fuzzy finding, and Git workflows.

## Run it locally

Back up your current Neovim config first if you already have one:

```sh
mv ~/.config/nvim ~/.config/nvim.backup
```

Clone this repository into Neovim's config directory:

```sh
git clone https://github.com/tusharxoxoxo/nvim-config-super-duper-octo-fiesta ~/.config/nvim
```

Open Neovim:

```sh
nvim
```

lazy.nvim will bootstrap itself on first launch. Install the prerequisites listed below before expecting every plugin and keymap to work.

## Check and test

There is no separate build step for this project. Use these commands as smoke checks:

```sh
nvim --headless +qa
nvim --headless "+Lazy! sync" +qa
nvim --headless "+checkhealth" +qa
```

The first command checks that Neovim can start with this config. The second syncs plugins. The third opens Neovim's health checks.

## Contribute

Keep changes small and focused. Before changing mappings, plugin behavior, or workflow notes, read the existing sections below and `jj.md` so the config stays consistent with the current habits documented here.

Useful areas to check before contributing:

- `lua/dadima/remap.lua` for keymaps
- `lua/dadima/plugins.lua` for shared plugin specs, formatting, and linting
- `lua/dadima/lsp.lua`, `lua/dadima/harpoon.lua`, `lua/dadima/git.lua`, `lua/dadima/treesitter.lua`, and `lua/dadima/undotree.lua` for focused plugin setup
- `lua/dadima/markdown.lua` for Markdown Treesitter guards that affect startup and formatting behavior
- `lua/dadima/set.lua` for editor options and diagnostic display settings
- `jj.md` for the repo workflow notes

## License

This project is licensed under the MIT License. See [LICENSE](LICENSE).

---

## Preview

Current setup with transparent background and rose-pine theme:

![Current Look](https://github.com/user-attachments/assets/4f7c9840-c9a9-4b84-becf-72588bdff009)

Background image for transparent terminal:

[Waifu Background](https://github.com/tusharxoxoxo/nvim-config-super-duper-octo-fiesta/blob/cookies/sexy-anime-girl-in-space-jtrt80grfiym6iyx.jpeg)

## Prerequisites

- **Required**: [ripgrep](https://github.com/BurntSushi/ripgrep) for telescope search
- **Recommended**: Nerd Font for better icons
- **Optional**: tmux for enhanced workflow

## Key Features

- **Fast startup** with lazy loading
- **Rose-pine theme** with transparent background
- **Telescope** for fuzzy finding
- **Harpoon** for quick file navigation
- **Modern LSP** setup with Mason-managed tools
- **Smart formatting** with conform.nvim plus Oxc and Ruff
- **Git integration** with fugitive and gitsigns
- **Modern JS/Python tooling** with VoidZero and Astral

## Keyboard Shortcuts

_Space is the leader key_  
_All shortcuts are optimized for macOS and avoid system conflicts_

This README is a personal reference sheet that includes custom mappings, plugin commands, and useful built-in Vim commands.

### File Explorer & Navigation

| Shortcut | Action |
|---|---|
| `nvim .` | Open netrw in current directory |
| `<leader>pv` | Open file explorer |
| `:Ex` | Open netrw explorer |
| `%` | Create new file (in netrw) |
| `d` | Create new directory (in netrw) |

### File Finding (Telescope)

| Shortcut | Action |
|---|---|
| `<leader>pf` | Find files by name |
| `<C-p>` | Find git files |
| `<leader>ps` | Live grep (search in files) |
| `<leader>vh` | Help tags |

### Harpoon (Quick Navigation)

| Shortcut | Action |
|---|---|
| `<leader>a` | Add current file to harpoon |
| `<C-e>` | Toggle harpoon menu |
| `<C-h>` | Navigate to harpoon file 1 |
| `<C-t>` | Navigate to harpoon file 2 |
| `<C-n>` | Navigate to harpoon file 3 |
| `<C-s>` | Navigate to harpoon file 4 |
| `<A-p>` | Navigate to previous mark |
| `<A-n>` | Navigate to next mark |

### Text Editing & Movement

| Shortcut | Action |
|---|---|
| `J` (visual) | Move selected lines down |
| `K` (visual) | Move selected lines up |
| `<C-d>` | Page down (centered) |
| `<C-u>` | Page up (centered) |
| `n` | Next search match (centered) |
| `N` | Previous search match (centered) |
| `ciw` | Change inner word |
| `=ap` | Indent entire paragraph |
| `=` (visual) | Indent selected lines |

### Clipboard Operations

| Shortcut | Action | Original Command |
|---|---|---|
| `<leader>y` | Copy to system clipboard | `"+y` |
| `<leader>Y` | Copy line to system clipboard | `"+Y` |
| `"+p` | Paste from system clipboard | `"+p` |
| `gg<leader>yG` | Copy entire file to clipboard | `gg"+yG` |
| `<leader>p` (visual) | Paste without overwriting register | `"_dP` |

### Search & Replace

| Shortcut | Action |
|---|---|
| `/pattern` | Search for pattern |
| `<leader>s` | Substitute word under cursor |
| `:%s/old/new/g` | Replace all occurrences globally |
| `:%s/old/new/gc` | Replace with confirmation |
| `:s/old/new/g` | Replace in current line |

### LSP (Language Server)

| Shortcut | Action |
|---|---|
| `gd` | Go to definition |
| `gr` | Show references |
| `gi` | Go to implementation |
| `go` | Go to type definition |
| `K` | Show hover documentation |
| `gs` | Signature help |
| `<leader>rn` | Rename symbol |
| `<leader>ca` | Code actions |
| `<C-o>` | Jump back |
| `<C-i>` | Jump back forward (reverse of the above command |

> \*note, don't change the above command action details, i have written it differently for my own convinience

### Diagnostics

| Shortcut | Action |
|---|---|
| `gl` | Show line diagnostics |
| `[d` | Previous diagnostic |
| `]d` | Next diagnostic |
| `<leader>ld` | Open diagnostics list |

### Completion (nvim-cmp)

| Shortcut | Action |
|---|---|
| `<C-Space>` | Trigger completion |
| `<Tab>` | Next completion item |
| `<S-Tab>` | Previous completion item |
| `<CR>` | Confirm selection |
| `<C-e>` | Abort completion |

### Git Operations

| Shortcut | Action |
|---|---|
| `<leader>gg` | Open LazyGit (`q` to exit) |
| `<leader>gs` | Git status (fugitive) |
| `]c` | Next git hunk |
| `[c` | Previous git hunk |
| `<leader>hs` | Stage hunk |
| `<leader>hr` | Reset hunk |
| `<leader>hp` | Preview hunk |

### Utility Tools

| Shortcut | Action |
|---|---|
| `<leader>u` | Toggle undo tree |
| `<leader>fm` | Format file or selection (oxfmt/ruff/stylua) |
| `<leader>x` | Make file executable |
| `:Lazy sync` | Update plugins |

### Vim-Sneak (Enhanced Movement)

| Shortcut | Action |
|---|---|
| `s<char><char>` | Jump to two-character sequence |
| `;` | Repeat last sneak forward |
| `S` | Sneak backwards |
| `<C-o>` | Jump back to starting position |

### Special Functions

| Shortcut | Action |
|---|---|
| `:TSPlaygroundToggle` | Toggle treesitter playground |

### Text Objects & Motions

| Shortcut | Action |
|---|---|
| `vi"` | Select inside quotes |
| `vi(` | Select inside parentheses |
| `cit` | Change inside HTML tags |
| `dit` | Delete inside HTML tags |
| `.` | Repeat last command |
| `:set wrap` | Enable line wrapping |

### Window Management

| Shortcut | Action |
|---|---|
| `<C-w>w` | Switch between windows |
| `<C-w>h/j/k/l` | Navigate windows |
| `<C-w>s` | Split horizontally |
| `<C-w>v` | Split vertically |

## Go Development Shortcuts

| Shortcut | Action |
|---|---|
| `<leader>ee` | Insert error return pattern |
| `<leader>ea` | Insert assert.NoError |
| `<leader>ef` | Insert log.Fatalf error handling |
| `<leader>el` | Insert logger.Error pattern |

## Plugin Highlights

- **lazy.nvim** - Modern plugin manager
- **telescope.nvim** - Fuzzy finder
- **harpoon** - Quick file navigation
- **nvim-lspconfig** - LSP integration
- **nvim-cmp** - Autocompletion
- **conform.nvim** - Code formatting
- **nvim-treesitter** - Syntax highlighting
- **vim-fugitive** - Git integration
- **undotree** - Undo history visualization
- **vim-sneak** - Enhanced movement
- **rose-pine** - Beautiful theme

## Notes

- The configuration uses a transparent background for terminal aesthetics
- Mason is available for manual tool installation; LSP servers are not auto-installed
- Formatting is handled by conform.nvim with `oxfmt`, Ruff, Stylua, and others
- JavaScript/TypeScript use `tsgo` for LSP and `oxlint`/`oxfmt` for linting and formatting
- Python uses Ruff plus `ty` for fast linting, formatting, imports, and language features
- All plugins are lazy-loaded for optimal startup performance

---

_Configuration last updated: march 2026_  
_Feel free to use and modify - attribution appreciated!_
