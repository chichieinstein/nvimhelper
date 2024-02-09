import os
import sys
import shutil
import subprocess

arg_len = len(sys.argv)

# First argument is the project name. Default value if unspecified is "default".
# Second argument is the project type. It is 'c' by default.
# Third argument is the parent directory of the project root. By default, it is the home directory.
# If specified as a relative path, it is taken to be relative to current
# working directory.

project_name = sys.argv[1] if arg_len >= 2 else "default"
project_type = sys.argv[2] if arg_len >= 3 else "c"
root_parent = sys.argv[3] if arg_len >= 4 else os.path.expanduser("~")
root_parent = os.path.abspath(root_parent)
os.makedirs(root_parent, exist_ok=True)  # Make sure that root_parent exists.
project_root = os.path.join(root_parent, project_name)

if os.path.exists(project_root):
    shutil.rmtree(project_root)
os.mkdir(project_root)  # Create fresh root directory
src_directory = os.path.join(project_root, "src")
os.mkdir(src_directory)
os.chdir(project_root)
if project_type == "py":
    with open("pyproject.toml", "w") as config_file:
        print("[tool.pyright]", file=config_file)
        print("include = [\"src\"]", file=config_file)
        print("defineConstant = { DEBUG = true }", file=config_file)
        print("reportMissingImports = true", file=config_file)
        print("pythonVersion = \"3.8\"", file=config_file)
        print("pythonPlatform = \"Linux\"", file=config_file)
    os.chdir(src_directory)
    with open("test.py", "w") as main_file:
        print("if __name__ == \"__main__\":", file=main_file)
        print(" print(\"HelloWorld\")", file=main_file)
elif (project_type == 'c' or project_type == 'cxx' or project_type == 'cu'):
    header_directory = os.path.join(project_root, "include")
    os.mkdir(header_directory)
    file_ext = "cpp" if project_type == 'cxx' else project_type
    header_ext = 'cuh' if project_type == 'cu' else 'h'
    with open("CMakeLists.txt", "w") as cmake_file:
        print("cmake_minimum_required(VERSION 3.10)", file=cmake_file)
        if project_type == "c":
            print(f"project({project_name})", file=cmake_file)
        elif project_type == "cxx":
            print(f"project({project_name} LANGUAGES CXX)", file=cmake_file)
            print("set(CMAKE_CXX_STANDARD 17)", file=cmake_file)
        else:
            print(
                f"project({project_name} LANGUAGES CUDA CXX)",
                file=cmake_file)
            print(f"set(CMAKE_CXX_STANDARD 17)", file=cmake_file)
            print(f"set(CMAKE_CUDA_STANDARD 17)", file=cmake_file)
            print(
                "SET(CMAKE_CUDA_FLAGS\"${CMAKE_CUDA_FLAGS}\")",
                file=cmake_file)
            print(
                "SET(CMAKE_CXX_FLAGS\"${CMAKE_CXX_FLAGS}\")",
                file=cmake_file)
        print("set(CMAKE_EXPORT_COMPILE_COMMANDS ON)", file=cmake_file)
        print(f"add_executable({project_name})", file=cmake_file)
        print(
            f"target_sources({project_name} PRIVATE ./src/{project_name}.{file_ext} ./src/main.{file_ext})",
            file=cmake_file)
        if project_type == 'cu':
            print(
                f"set_property(TARGET {project_name} PROPERTY CUDA_ARCHITECTURES 75)",
                file=cmake_file)
            print("find_package(CUDA)", file=cmake_file)
    os.chdir(header_directory)
    with open(f"{project_name}.{header_ext}", "w") as header_file:
        if project_type != 'c':
            print("#include <iostream>", file=header_file)
        else:
            print("#include <stdio.h>", file=header_file)
        print("void display(int);", file=header_file)
    os.chdir(src_directory)
    with open(f"{project_name}.{file_ext}", "w") as src_file:
        print(
            f"#include\"../include/{project_name}.{header_ext}\"",
            file=src_file)
        if project_type != "c":
            print("using std::cout;\nusing std::endl;", file=src_file)
        print("void display(int x)\n{", file=src_file)
        if project_type != "c":
            print(" cout << x << endl;\n}", file=src_file)
        else:
            print(" printf(\"%d\\n\", x);"+"\n}", file=src_file)
    with open(f"main.{file_ext}", "w") as main_file:
        print(
            f"#include \"../include/{project_name}.{header_ext}\"",
            file=main_file)
        print("int main()\n{", file=main_file)
        print(" int z=5;", file=main_file)
        print(" display(z);\n}", file=main_file)
    os.chdir(project_root)
    subprocess.run(["cmake", "-S", ".", "-B", "build"])
    subprocess.run(["ln", "-s", "build/compile_commands.json", "."])
    if project_type == "cu":
        with open(".clangd", "w") as format_config:
            print("CompileFlags:", file=format_config)
            print("  Remove:", file=format_config)
            print(
                "    - -forward-unknown-to-host-compiler",
                file=format_config)
            print("    - --generate-code*", file=format_config)
            print("  Add:", file=format_config)
            print("    - -std=c++17", file=format_config)
            print("    - --cuda-path=/usr/local/cuda", file=format_config)
            print("    - --cuda-gpu-arch=sm_75", file=format_config)
            print("    - -L/usr/local/cuda/lib64", file=format_config)
            print("    - -I/usr/local/cuda/include", file=format_config)
            print("    - -I.", file=format_config)
