# nvimhelper
This repo contains lua files that help setup Neovim for development in Rust and C++. Features include code autoformatting, code completion, error highlighting and git integration.

To use this, ensure that

1. Nvim
2. Cmake
3. Cargo
4. clang-format

are installed. The setup of other required nvim dependencies are taken care of internally. The LSP lua module assumes that Cargo has been installed in the default location ``$HOME/.cargo``. If that is not the case for you, modify the ``cargo_home`` variable in the ``nvim/lua/plugins/lsp.lua`` file.

Copy the nvim folder to your .config directory and start using nvim.

For editing C/C++/CUDA files, the aim is to integrate the Cmake build system with the Clangd LSP. The ``setup_project.sh`` script is included to facilitate this integration by automating the writing of the boiler plate that is needed to directly start using Clangd with Neovim in the project directory. It takes one commandline argument which is the name of the new C/C++/CUDA project. It does the following actions:

1. Create include and source directories.
2. Run cmake to create the ``compile_commands.json`` file required by clangd. 

Run this bash script (after setting execution permissions with ``chmod +x setup_project.sh``), passing in the project name. One thing to keep in mind is that as new source files are added/removed, the CmakeLists.txt file needs to be updated, and the cmake command needs to be run again.

Finally, note that while ``clangd`` embeds ``clang-format`` by default, if we want a different code style formatting from the default (google style), we would need to include a ``.clang-format`` file in the project root which is tedious to write without a ``clang-format`` installed. Hence the decision here to require the installation of ``clang-format``. That way we can also use vim plugins to directly trigger buffer formatting.

More plugins would be added in the future.
