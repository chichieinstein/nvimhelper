# nvimhelper
Welcome to `nvimhelper`, a basic NeoVim config template that illustrates how to use `Lua` for setting up a terminal based IDE-like environment powered by the NeoVim ecosystem. If you like what you see here, please star :). Supported features include 

1. Code Formatting 
2. Code completion 
3. File search in current directory
4. Diagnostics in non-insert mode in floating non-focusable windows
5. Type hints in insert mode
6. Pretty statuslines
7. LiveGrep on folder of choice 
8. File search on folder of choice 

Currently supported languages are C, C++, CUDA, Rust and Markdown. More languages will be supported in the future. The following general dependencies must be met 

1. Nvim (version >= 0.10.0, built with LuaJit).
2. Cmake
3. Cargo
4. clang-format
5. rip-grep
6. marksman
7. One of the NerdFonts installed and terminal configured to dispay it.
8. (Optional) Use a good terminal emulator like `kitty` or `alacritty` for the best rendering of the statuslines.

The setup of required NeoVim plugins is taken care of internally. Once all these dependencies are satisfied, using the config is remarkably simple: copy the nvim folder to your `.config` directory and that is it! Start using nvim with these settings. 

We next describe the specific language editing features and other requirements in detail.

# C family

For editing C/C++/CUDA files, we have here an easy way to integrate the Cmake build system with the Clangd LSP, mimicking the relationship between rust-analyzer and cargo. The `setup_project.sh` script is included to facilitate this integration by automating the writing of the boiler plate that is needed to directly start using Clangd with Neovim in the project directory. It takes two commandline arguments:

1. The name of the new C/C++/CUDA project.
2. The directory which will contain the project.

It does the following actions:

1. Create include and source directories.
2. Run cmake to create the `compile_commands.json` file required by clangd. 

Run this bash script (after setting execution permissions with `chmod +x setup_project.sh`), passing in the project name and directory. One thing to keep in mind is that as new source files are added/removed, the CmakeLists.txt file needs to be updated, and the cmake command needs to be run again. In order to toggle between different code formatting conventions, it is best to have `clang-format` installed and available.  

# Rust 

For Rust editing, `cargo` already ships with `rust-analyzer` and `rustfmt`. Enable these in the rust toolchain. Ensure that the `$CARGO_HOME` env variable is set to point to the cargo installation directory of your system.

# Markdown
`nvimhelper` enables diagnostics and code completion abilities for markdown, powered by the `marksman` lsp. The config has also been setup to trigger a browser preview of your markdown file. Note that while the lsp provides support to wiki-style links to other `.md` files in your project, the browser preview does not. 

# Custom keybindings

|   Keys    |     Mode  |Action               |
|-----------|----------|---------------------|
|`<Alt><w>`|`Normal`|Open Split Window to the right |   
|`<Ctrl><h>`|`Normal`|Move to an existing left window|
|`<Ctrl><l>`|`Normal`|Move to an existing right window |
|`<Space><ff>`|`Normal`|FileSearch in the current directory|
|`<Space><F>`|`Normal`|Format the buffer according to filetype|
|`<Space><p>`|`Normal`|Display preview for Markdown files|
|`<Space><op>`|`Normal`|Open an NvimTree buffer|
|`<Space><sd>`|`Normal`|FileSearch under cursor in NvimTree buffer|
|`<Space><tt>`|`Normal`|LiveGrep under cursor in NvimTree buffer|
|`<Space><x>`|`Normal`|Close an open NvimTree buffer|

Another neat thing that has been achieved here is an integration of `NvimTree` with `Telescope`. This means that LiveGrep, as well as FileSearch can be done very easily in the NvimTree tab, as can be seen in the last four keybindings above. 
