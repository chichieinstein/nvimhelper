# nvimhelper
This repo contains lua files that help setup Neovim for development in Rust and C++. Features include code autoformatting, code completion, error highlighting and git integration.

To use this, ensure that

1. Nvim
2. Cmake
3. Cargo

are installed. The setup of other required nvim dependencies are taken care of internally.

Copy the nvim folder to your .config directory and start using nvim.

We know that for Rust, the ``cargo new`` command exists, immediately after which rust-analyzer will start analyzing your code semantics. Setting up a C/C++ project with cmake  so that clangd can start doing its thing requires writing some tedious boiler plate code, as clangd requires a specifically named json file in the project directory. Therefore, a bash script, named ``setup_project.sh`` is included to automate the writing of this boiler plate. It takes one commandline argument which is the name of the new C/C++/CUDA project. It does the following actions:

1. Create include and source directories.
2. Run cmake to create the ``compile_commands.json`` file required by clangd. 

Run this bash script (after setting execution permissions with ``chmod +x setup_project.sh``), passing in the project name. Once done, you can fire nvim to start editing source files. Clangd would then have everything it needs to start helping you in your development. One final thing to keep in mind is that as new source files are added/removed, the CmakeLists.txt file needs to be updated, and the cmake command needs to be run again.

More plugins would be added in the future.
