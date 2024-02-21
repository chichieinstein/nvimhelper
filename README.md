# nvimhelper
Welcome to `nvimhelper`, a NeoVim config template that uses `Lua` for configuring a terminal based IDE-like environment powered by the NeoVim ecosystem. If you like what you see here, please star :). Supported features include 

1. Code Formatting 
2. Code completion 
3. File search in current directory
4. Diagnostics in non-insert mode in floating non-focusable windows
5. Type hints in insert mode
6. Pretty statuslines
7. LiveGrep on folder of choice 
8. File search on folder of choice 

Currently supported languages are 

1. C, C++, CUDA
2. Rust
3. Python 
4. markdown
5. LaTeX

More languages will be supported in the future. To start using this config, the following general dependencies must be met 

1. Nvim (version >= 0.10.0, built with LuaJit).
2. rip-grep
3. One of the NerdFonts installed and terminal configured to dispay it.
4. (Optional) Use a good terminal emulator like `kitty` or `alacritty` for the best rendering of the statuslines. This is not really needed if you are using Ubuntu 22.04 or later.

The setup of required NeoVim plugins is taken care of internally. Once these dependencies are satisfied, using the config is remarkably simple: copy the nvim folder to your `.config` directory and that is it! Start using nvim with these settings. 

We have also provided a python script that automates writing boiler plate code that is required by some LSPs to start working with NeoVim. The usage of this script will be made clear in the relevant sections below, where we deal with the setup of and requirements for each individual language.

# Python 
For Python editing, we need 

1. `pyright` as the LSP 
2. `black` or `autopep8` as the formatter (We choose the latter).

In addition to this, the Python project needs to have a specific structure for Pyright to not complain about there being no `root`. The `setup_project.py` script helps in creating the required folder structure and the `pyproject.toml` file required by the LSP to start displaying diagnostics. The invocation of the script has the following signature
```
python3 setup_project.py project_name py /location/of/root/folder 
```
Here, the first argument is the name of the project, the second argument `py` is the project type, and the third argument is the location of the project root. The convention we follow is that the name of the project root is the same as that of the project. If the third argument is not specfied, the project root will be created in the `HOME` directory. If a relative path is specified (without a leading `/`) then the root would be located in the corresponding subdirectory of the current working directory. If an absolute path is specified, then the root will be located in that directory. 

# C family

For editing C/C++/CUDA files, we need:

1. Clangd as the LSP
2. Clang-Format for formatting.
3. CMake 

Note that if you use the Clang toolchain, these clangd and clang-format are already pre-installed. Cmake is necessary, because it provides a good build system, but more importantly for editing purposes, it spits out the `compile_commands.json` file that is needed by `clangd` to start its diagnostics.

The `setup_project.py` script facilitates automation of the writing of the boiler plate here too. The invocation of this script takes the form:

```
python3 setup_project.py project_name c /location/of/root/folder    (For c projects) 
python3 setup_project.py project_name cxx /location/of/root/folder  (For cpp projects) 
python3 setup_project.py project_name cu /location/of/root/folder   (For cuda projects)
```
The structure of the third argument dealing with the location of the project root is the same as the one we saw for Python.

The script takes the following actions:

1. Create include and source directories.
2. Run cmake to create the `compile_commands.json` file required by clangd.
3. For `.cu` projects, create a `.clangd` YAML file to disable spurious diagnostics.

One thing to keep in mind is that as new source files are added/removed, the CmakeLists.txt file needs to be updated, and the cmake command needs to be run again. Finally, the config here has a neovim plugin installed that makes toggling between coding conventions easy without the need to generate a .clang-format file.

## Additional notes for CUDA editing:

In case of editing `.cu` files, use `gcc` as the host compiler. Clang has a lot of brittle interdependencies with the CUDA driver. Further, you need to create a `.clangd` file in your project root and add the following to remove spurious warnings:
```
CompileFlags:
    Remove:
        - -forward-unknown-to-host-compiler
        - --generate-code*
    Add:
        - -std=c++17
        - --cuda-path=/usr/local/cuda 
        - --cuda-gpu-arch=sm_75
        - -L/usr/local/cuda/lib64
        - -I/usr/local/cuda/include
        - -I.
```

Be sure to correctly include the compute architecture and the C++ version above. The `setup_project.py` script assumes a compute architecture of 75 by default.

# Rust 

For Rust editing, `cargo` already ships with `rust-analyzer` and `rustfmt`. These dependencies must be met for editing Rust with `nvimhelper`

1. Enable `rust-analyzer` and `rustfmt` in the rust toolchain. 
2. Ensure that the `$CARGO_HOME` env variable is set to point to the cargo installation directory of your system.

# Markdown
`nvimhelper` enables diagnostics and code completion abilities for markdown. We need both
1. `marksman` lsp. 
2. `markdown preview`
installed to take full advantage of the capabilities of the config. Note that while the lsp provides support to wiki-style links to other `.md` files in your project, the browser preview does not. 

# LaTeX 
`nvimhelper` also has the capability to edit LaTeX files. As before, we need an LSP and a TeX compiler to get this working. Accordingly,
1. `TeXLab` is our LaTeX lsp 
2. `Tectonic` is our LaTex compiler.

Having had a lot of experience with the bulk and difficulty of installing various TeX distributions, I can vouch for how simple `Tectonic` has made managing large Latex projects. Both the LSP and compiler are quite easy to install and `Tectonic` only installs packages as and when they are needed. Thus the overall bulk of the distribution is reduced. Handling bibiliographies is also a breeze with these tools.

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
