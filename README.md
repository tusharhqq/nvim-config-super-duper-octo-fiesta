# nvim-config-super-duper-octo-fiesta

My Neovim configuration files - clean, fast, and productive.

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

- 🚀 **Fast startup** with lazy loading
- 🎨 **Rose-pine theme** with transparent background
- 🔍 **Telescope** for fuzzy finding
- 🎯 **Harpoon** for quick file navigation
- 🔧 **Modern LSP** setup with mason
- 📝 **Smart formatting** with conform.nvim plus Oxc and Ruff
- 🐙 **Git integration** with fugitive and gitsigns
- ⚡ **Modern JS/Python tooling** with VoidZero and Astral

## Keyboard Shortcuts

_Space is the leader key_  
_All shortcuts are optimized for macOS and avoid system conflicts_

This README is a personal reference sheet that includes custom mappings, plugin commands, and useful built-in Vim commands.

### File Explorer & Navigation

| Shortcut     | Action                          |
| ------------ | ------------------------------- |
| `nvim .`     | Open netrw in current directory |
| `<leader>pv` | Open file explorer              |
| `:Ex`        | Open netrw explorer             |
| `%`          | Create new file (in netrw)      |
| `d`          | Create new directory (in netrw) |

### File Finding (Telescope)

| Shortcut     | Action                      |
| ------------ | --------------------------- |
| `<leader>pf` | Find files by name          |
| `<C-p>`      | Find git files              |
| `<leader>ps` | Live grep (search in files) |
| `<leader>vh` | Help tags                   |

### Harpoon (Quick Navigation)

| Shortcut    | Action                      |
| ----------- | --------------------------- |
| `<leader>a` | Add current file to harpoon |
| `<C-e>`     | Toggle harpoon menu         |
| `<C-h>`     | Navigate to harpoon file 1  |
| `<C-t>`     | Navigate to harpoon file 2  |
| `<C-n>`     | Navigate to harpoon file 3  |
| `<C-s>`     | Navigate to harpoon file 4  |
| `<A-p>`     | Navigate to previous mark   |
| `<A-n>`     | Navigate to next mark       |

### Text Editing & Movement

| Shortcut     | Action                           |
| ------------ | -------------------------------- |
| `J` (visual) | Move selected lines down         |
| `K` (visual) | Move selected lines up           |
| `<C-d>`      | Page down (centered)             |
| `<C-u>`      | Page up (centered)               |
| `n`          | Next search match (centered)     |
| `N`          | Previous search match (centered) |
| `ciw`        | Change inner word                |
| `=ap`        | Indent entire paragraph          |
| `=` (visual) | Indent selected lines            |

### Clipboard Operations

| Shortcut             | Action                             | Original Command |
| -------------------- | ---------------------------------- | ---------------- |
| `<leader>y`          | Copy to system clipboard           | `"+y`            |
| `<leader>Y`          | Copy line to system clipboard      | `"+Y`            |
| `"+p`                | Paste from system clipboard        | `"+p`            |
| `gg<leader>yG`       | Copy entire file to clipboard      | `gg"+yG`         |
| `<leader>p` (visual) | Paste without overwriting register | `"_dP`           |

### Search & Replace

| Shortcut         | Action                           |
| ---------------- | -------------------------------- |
| `/pattern`       | Search for pattern               |
| `<leader>s`      | Substitute word under cursor     |
| `:%s/old/new/g`  | Replace all occurrences globally |
| `:%s/old/new/gc` | Replace with confirmation        |
| `:s/old/new/g`   | Replace in current line          |

### LSP (Language Server)

| Shortcut     | Action                                          |
| ------------ | ----------------------------------------------- |
| `gd`         | Go to definition                                |
| `gr`         | Show references                                 |
| `gi`         | Go to implementation                            |
| `go`         | Go to type definition                           |
| `K`          | Show hover documentation                        |
| `gs`         | Signature help                                  |
| `<leader>rn` | Rename symbol                                   |
| `<leader>fm` | Format code                                     |
| `<leader>ca` | Code actions                                    |
| `<C-o>`      | Jump back                                       |
| `<C-i>`      | Jump back forward (reverse of the above command |

\*note, don't change the above command action details, i have written it differently for my own convinience

### Diagnostics

| Shortcut     | Action                |
| ------------ | --------------------- |
| `gl`         | Show line diagnostics |
| `[d`         | Previous diagnostic   |
| `]d`         | Next diagnostic       |
| `<leader>ld` | Open diagnostics list |

### Completion (nvim-cmp)

| Shortcut    | Action                   |
| ----------- | ------------------------ |
| `<C-Space>` | Trigger completion       |
| `<Tab>`     | Next completion item     |
| `<S-Tab>`   | Previous completion item |
| `<CR>`      | Confirm selection        |
| `<C-e>`     | Abort completion         |

### Git Operations

| Shortcut     | Action                |
| ------------ | --------------------- |
| `<leader>gs` | Git status (fugitive) |
| `]c`         | Next git hunk         |
| `[c`         | Previous git hunk     |
| `<leader>hs` | Stage hunk            |
| `<leader>hr` | Reset hunk            |
| `<leader>hp` | Preview hunk          |

### Utility Tools

| Shortcut     | Action                          |
| ------------ | ------------------------------- |
| `<leader>u`  | Toggle undo tree                |
| `<leader>mp` | Format file (oxfmt/ruff/stylua) |
| `<leader>x`  | Make file executable            |
| `:Lazy sync` | Update plugins                  |

### Vim-Sneak (Enhanced Movement)

| Shortcut        | Action                         |
| --------------- | ------------------------------ |
| `s<char><char>` | Jump to two-character sequence |
| `;`             | Repeat last sneak forward      |
| `S`             | Sneak backwards                |
| `<C-o>`         | Jump back to starting position |

### Special Functions

| Shortcut               | Action                         |
| ---------------------- | ------------------------------ |
| `lua ColorMyPencils()` | Restore transparent background |
| `:TSPlaygroundToggle`  | Toggle treesitter playground   |

<!-- ### Avante AI Assistant (DISABLED)

_Space is the leader key_

| Shortcut     | Action                                  |
| ------------ | --------------------------------------- |
| `<leader>aa` | Toggle Avante sidebar                   |
| `<leader>ac` | Start Avante chat                       |
| `<leader>ai` | Edit selected code with Avante (visual) |
| `<leader>ar` | Refresh Avante                          |
| `<leader>af` | Switch Avante sidebar focus             |
| `co`         | Choose ours (conflict resolution)       |
| `ct`         | Choose theirs (conflict resolution)     |
| `ca`         | Choose all theirs (conflict resolution) |
| `c0`         | Choose none (conflict resolution)       |
| `cb`         | Choose both (conflict resolution)       |
| `cc`         | Choose cursor (conflict resolution)     |
| `]x`         | Move to previous conflict               |
| `[x`         | Move to next conflict                   |
| `[[`         | Jump to previous code blocks (results)  |
| `]]`         | Jump to next code blocks (results)      |

#### Avante Commands

| Command                 | Description                   |
| ----------------------- | ----------------------------- |
| `:AvanteAsk [question]` | Ask AI about your code        |
| `:AvanteChat`           | Start chat session with AI    |
| `:AvanteEdit`           | Edit selected code blocks     |
| `:AvanteFocus`          | Switch focus to/from sidebar  |
| `:AvanteToggle`         | Toggle Avante sidebar         |
| `:AvanteRefresh`        | Refresh all Avante windows    |
| `:AvanteSwitchProvider` | Switch AI provider            |
| `:AvanteShowRepoMap`    | Show repository structure map |
| `:AvanteBuild`          | Build project dependencies    |
-->

### Text Objects & Motions

| Shortcut    | Action                    |
| ----------- | ------------------------- |
| `vi"`       | Select inside quotes      |
| `vi(`       | Select inside parentheses |
| `cit`       | Change inside HTML tags   |
| `dit`       | Delete inside HTML tags   |
| `.`         | Repeat last command       |
| `:set wrap` | Enable line wrapping      |

### Window Management

| Shortcut       | Action                 |
| -------------- | ---------------------- |
| `<C-w>w`       | Switch between windows |
| `<C-w>h/j/k/l` | Navigate windows       |
| `<C-w>s`       | Split horizontally     |
| `<C-w>v`       | Split vertically       |

## Go Development Shortcuts

| Shortcut     | Action                           |
| ------------ | -------------------------------- |
| `<leader>ee` | Insert error return pattern      |
| `<leader>ea` | Insert assert.NoError            |
| `<leader>ef` | Insert log.Fatalf error handling |
| `<leader>el` | Insert logger.Error pattern      |

## Debugging (DAP)

| Shortcut     | Action                     |
| ------------ | -------------------------- |
| `<leader>dc` | Start/Continue debugging   |
| `<leader>di` | Step into                  |
| `<leader>do` | Step over                  |
| `<leader>du` | Step out                   |
| `<leader>dt` | Toggle debug UI            |
| `<leader>db` | Toggle breakpoint          |
| `<leader>dB` | Set conditional breakpoint |

## Installation

1. Backup your existing config:

```bash
mv ~/.config/nvim ~/.config/nvim.backup
```

2. Clone this config:

```bash
git clone https://github.com/tusharxoxoxo/nvim-config-super-duper-octo-fiesta ~/.config/nvim
```

3. Install ripgrep:

```bash
# macOS
brew install ripgrep

# Ubuntu/Debian
sudo apt install ripgrep

# Arch
sudo pacman -S ripgrep
```

4. Start Neovim and let Lazy.nvim install plugins:

```bash
nvim
```

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
<!-- - **avante.nvim** - AI-powered code assistant (DISABLED) -->
- **rose-pine** - Beautiful theme

## Notes

- The configuration uses a transparent background for terminal aesthetics
- LSP servers are automatically installed via Mason
- Formatting is handled by conform.nvim with `oxfmt`, Ruff, Stylua, and others
- JavaScript/TypeScript use `tsgo` for LSP and `oxlint`/`oxfmt` for linting and formatting
- Python uses Ruff plus `ty` for fast linting, formatting, imports, and language features
<!-- - Avante.nvim provides AI-powered code assistance with Claude Sonnet 4 and Moonshot models (DISABLED) -->
- All plugins are lazy-loaded for optimal startup performance

---

_Configuration last updated: March 2026_
_Feel free to use and modify - attribution appreciated!_
