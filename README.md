# mynvimplugins
This repo contains lua files that help setup Neovim for development in Rust and C++. Features include code autoformatting, code completion, git integration and error highlighting.

To use this, ensure that

1. Nvim
2. Cmake
3. Cargo

are installed. The setup of other required nvim dependencies are taken care of internally.

There is also a bash script, named setup\_project.sh. It takes one commandline argument which is the name of the new C/C++/CUDA project. It does the following actions:

1. Create include and source directories.
2. Run cmake to create the compile\_commands.json file required by clangd, the C/C++ language server to start tracking the project. 

Run this bash script before starting a new C/C++ project. Once done, fire nvim to start editing source files. Clangd would have everything it needs to start helping you in your development. One final thing to keep in mind is that as new source files are added/removed, the CmakeLists.txt file needs to be updated, and the cmake command needs to be run again.

More plugins would be added in the future.
