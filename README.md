# nvimhelper
This repo contains lua files that help setup Neovim for development in Rust and C++. Features include code autoformatting, code completion, error highlighting and git integration.

To use this, ensure that

1. Nvim
2. Cmake
3. Cargo
4. clang-format

are installed. The setup of other required nvim dependencies are taken care of internally. The LSP lua module assumes that Cargo has been installed in the default location ``$HOME/.cargo``. If that is not the case for you, modify the ``cargo_home`` variable in the ``nvim/lua/plugins/lsp.lua`` file.

Copy the nvim folder to your .config directory and start using nvim.

We know that for Rust, the ``cargo new`` command automatically creates a skeleton project, immediately after which rust-analyzer will start analyzing your code semantics. Setting up a similar skeletal project for C/C++ with cmake  so that clangd can start doing its thing requires writing some tedious boiler plate code. This is because clangd requires a specifically named json file in the project root directory. Therefore, the ``setup_project.sh`` script is included to automate the writing of this boiler plate. It takes one commandline argument which is the name of the new C/C++/CUDA project. It does the following actions:

1. Create include and source directories.
2. Run cmake to create the ``compile_commands.json`` file required by clangd. 

Run this bash script (after setting execution permissions with ``chmod +x setup_project.sh``), passing in the project name. Once done, you can fire nvim to start editing source files. Clangd would then have everything it needs to start helping you in your development. One final thing to keep in mind is that as new source files are added/removed, the CmakeLists.txt file needs to be updated, and the cmake command needs to be run again.

Finally, note that clangd embeds clang-format by default. One approach to formatting C/C++ would therefore be to create keybindings that trigger the autoformatter in clangd. However, the problem here is that if we want a different code style formatting (default is google), we would need to include a .clang-format file in the project root. And its tedious to write one without clang-format installed. Hence the decision to require the installation of clang-format here. That way we can also use vim plugins to directly trigger buffer formatting easily.

More plugins would be added in the future.
