# nvim-config-super-duper-octo-fiesta
My configuration files and tools

This is tushar's configuration repo. Feel free to use whatever you would like from it! It'd be great if you mentioned where it came from if you think it's cool.

in the end it will look like this
![alt text](https://github.com/tusharxoxoxo/nvim-config-super-duper-octo-fiesta/blob/cookies/Screenshot%202023-06-22%20at%2013.51.51.jpg)

and here is the link for the background waifu photo, i have kept my nvim transparent, so this photo u need to add to your terminal background
https://github.com/tusharxoxoxo/nvim-config-super-duper-octo-fiesta/blob/cookies/sexy-anime-girl-in-space-jtrt80grfiym6iyx.jpeg

If you like what I'm doing, consider supporting me by clicking the heart button above!

Major areas include:

Prerequisite: install [ripgrep](https://github.com/BurntSushi/ripgrep).

## xdg_config

This area contains the configuration I want to share between machines that will go to `$XDG_CONFIG_HOME` (generally, `~/.config`).

Here is a small list of shortcuts (space is my leader key)
1. `nvim .` for opening the explorer
2. `%` to create a new file
3. `d` to create a new directory
4. `:Ex` for opening the Explorer
5. `<leader>pv` for opening the explorer
6. `:so` to source that file
7. a small tip for indentation: `=ap` for indenting the entire file
8. `=` After highlighting in visual mode, this will indent the highlighted portion
9. `:PackerSync` for synching packers
10. `<leader>pf` find files by typing their name
11. `<leader>ps` this opens grep find words in the entire directory
12. `ciw` delete the current word and go to insert mode
13. `lua ColorMyPencils()` After doing :PackerSync the background waifu disappears, this is to bring our waifu back
14. `:TSPlaygroundToggle` A syntax tree, also known as a parse tree or abstract syntax tree (AST), is a hierarchical representation of the syntactic structure of a program or a piece of code. It illustrates how the various elements of the code relate to each other grammatically.
<br/> <br/>   Harpoon shortcuts
15. `control e` harpoon menu
16. `<leader>a` add file to harpoon
17. `control h` file 1 in harpoon
18. `control t` file 2 in harpoon
19. `control n` file 3 in Harpoon
20. `control s` file 4 in Harpoon


<br/><br/>
21. `<leader>u` undotree toggle<br/>
22. `control ww` for window switch (usually control w should do the window switch, but it's just not working so ww<br/>
23. `<leader>gs` manipulate inside a git repo<br/>


<br/><br/>
24. `K` and `J`, first highlight the text, then these two keys we can move up and down carrying the highlighted text<br/>
25. `control u` for page up<br/>
26. `control d` for page down<br/>
27. `/something` this search something in that file<br/>



<br/><br/>
28. `n` for the next occurrence of that search thing, but for that first we need to get out of searching by pressing enter, and `shift n` or `N` to go backwards<br/>
29. `:%s/original-name/new-name/g` here `%s` is for searching something, `/original-name` for searching this name, `/new-name` for the new name, `/g` for doing this globally<br/>
30. `:s/original-name/new-name/g` if we only want to change the occurence of a specific word in a single line<br/>
31. `:%s/original-name/new-name` if we want to replace all the first instance of a specific word in all the lines<br/>
32. `:%s#/#doom#g` if we want to replace the occurence of `//` in our file then we can use a different delimiter say `#`<br/>
33. `:s/original-name/new-name/gc` this will give u option to replace the next occurence or not, press y or n<br> <br/>
    	
- `y`: Yes; make this change.
- `n`: No; skip this match.
- `a`: All; make this change and all remaining ones without further confirmation.
- `q`: Quit; don't make any more changes.
- `l`: Last; make this change and then quit.
- `CTRL-E`: Scroll the text one line up.
- `CTRL-Y`: Scroll the text one line down.

35. `:.,+5s/original-name/new-name/g` a way to change the next 5 occurence of a specific word<br/>



 <br/><br/>   lsp ones<br/>
36. `control p` select the previous item<br/>
37. `control n` select the next item<br/>
38. `control y` confirm, don't forget this one, it's important cause without this u will kinda hate lsp<br/>
39. `control<leader>` complete, this one too, imp<br/>

<br/><br/>
40. `gd` lsp buffer definition<br/>
41. `control o` for going back from buffer to the original file<br/>
42. `K` Hower<br/>
43. `vws` workspace symbols<br/>
44. `<leader>vd` diagnostic open float<br/>
45. `[d` diagnostic goto next<br/>
46. `]d` diagnostic goto prev<br/>
47. `<leader>vca` buffer code action<br/>
48. `<leader>vrr` buffer references<br/>
49. `<leader>vrn` buffer rename<br/>
50. `control h` signature help<br/>



<br/><br/>
51. `control v` then highlight the area/block u want to comment `shift i` to go into insert mode at the very start of the line<br/>
    `//` and then press ESC or control [<br/>
52. `vi"` and it will select everything within double quotes or `vi(`, the best part is it will jump the cursor before the string<br/>
53. `"+y` to copy into clipboard from Vim editor<br/>
    `"` says to use a register, `+` specifies the register to use (where + means the system clipboard in this case)m `y` is the yank operation<br/>
54. `"+p` and `"+P` paste into vim from system clipboard<br/>
55. `gg"+yG` if u r in normal mode and want to select all the content on the current file, something which we usually do via `cmd a` in our normal day to day browsing<br/>
56. `ctrl r` to fzf zsh history<br/> 



<br/><br/>  fzf ones<br/>
57. `fzf` for simple searching for a file in terminal<br/>
58. `fzf --preview='cat {}'` with this we can preview different files for searching for a particular file<br/>
59. `nvim $(fzf --preview='cat {}')` for searching a file a then opening that file in nvim<br/>

60. `diw`, `diW` are a better alternative for using multiple dw (delete word), `diw` will delete the word i am middle of, `diW` will delete the entire thing we r inside of<br/>

61. `<leader>f` after installing prettier using the command `bun i --save-dev prettier`, we can using prettier format using this command for formating inside the vim in a instant<br/>

<br/><br/> just added vim-sneak<br/>
62. `s<char><char>` to search this two character combination in your entire file, and all the other additional gets lighted in beautiful pink color, which is lovely to see with naked eyes, u will be mesmerised the movement u see it<br/>
63. `;` for going to next match of that two character sequence that u just searched or u can also do s<char><char> for repeat that again, but u would be done if u do so, like why in the world would u want to do that, r u dumb or what, just do `;`
64. `3;` to skip to the third (3rd) match from your current<br/>
65. `ctrl o` for going back to that starting position<br/>
66. `s<Enter>` to repeat the last search<br/>
67. `S` for searching backwards<br/>

there r a lot more such shortcuts, but these r what coming to my mind will definitely update this list in future<br/>


Subdirectories include:

### Neovim

Check the `nvim` folder for configuration. For more instructions, see the README there.

> *this page was last updated on 6 Aug 2024. please contact me if you notice it is outdated, or if you would like more recent information.*

