## nvimhelper
Welcome to `nvimhelper`. If you are a beginner to the Neovim ecosystem, this can be used as an initial config template. This repository contains `lua` files for configuring NeoVim for setting up an IDE-like environment. Supported features include 

1. Code Formatting 
2. Code completion 
3. File search in current directory
4. Diagnostics in non-insert mode in floating non-focusable windows
5. Type hints in insert mode
6. Pretty statuslines
7. LiveGrep on folder of choice 
8. File search on folder of choice 

Currently supported languages are C, C++, CUDA, Rust and Markdown. More languages will be supported in the future. To ensure smooth operation of neovim, ensure that the following depndencies are met 

1. Nvim (version 0.10.0, as that is the only version of Nvim currently allowing inlay hints).
2. Cmake
3. Cargo
4. clang-format
5. rip-grep
6. marksman

Further, ensure that your terminal has been configured to display at least one of the Nerd Fonts (I personally like FiraCode). In addition, use a good terminal emulator like `kitty`, `alacritty` etc. The setup of other required nvim dependencies is taken care of internally. Please ensure that the `$CARGO_HOME` env variable is set to point to the cargo installation directory in your system. Once these dependencies are met, setup is remarkably simple: copy the nvim folder to your `.config` directory and that is it! Start using nvim.

For editing C/C++/CUDA files, we have here an easy way to integrate the Cmake build system with the Clangd LSP, mimicking the relationship between rust-analyzer and cargo. The `setup_project.sh` script is included to facilitate this integration by automating the writing of the boiler plate that is needed to directly start using Clangd with Neovim in the project directory. It takes two commandline arguments:

1. The name of the new C/C++/CUDA project.
2. The directory which will contain the project.

It does the following actions:

1. Create include and source directories.
2. Run cmake to create the `compile_commands.json` file required by clangd. 

Run this bash script (after setting execution permissions with `chmod +x setup_project.sh`), passing in the project name and directory. One thing to keep in mind is that as new source files are added/removed, the CmakeLists.txt file needs to be updated, and the cmake command needs to be run again. Finally, note that while `clangd` embeds `clang-format` by default, if we want a different code style formatting from the default (google style), we would need to include a `.clang-format` file in the project root which is tedious to write without `clang-format` installed. Hence the decision here to require the installation of `clang-format`. That way we can also use vim plugins to directly trigger buffer formatting. 

|   Keys    |     Mode  |Action               |
|-----------|----------|---------------------|
|`<Alt><w>`|`Normal`|Open Split Window to the right |   
|`<Ctrl><h>`|`Normal`|Move to an existing left window|
|`<Ctrl><l>`|`Normal`|Move to an existing right wndow |
|`<Space><op>`|`Normal`|Open an NvimTree buffer |
|`<Space><sd>`|`Normal`|FileSearch under cursor|
|`<Space><tt>`|`Normal`|LiveGrep under cursor|
|`<Space><ff>`|`Normal`|File search|
|`<Space><x>`|`Normal` |Close NvimTree|

Another neat thing that has been achieved here is an integration of `NvimTree` with `Telescope`. This means that LiveGrep, as well as FileSearch can be done very easily in the NvimTree tab. This can be seen in the last five keybindings above. 
