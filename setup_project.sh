#!/usr/bin/bash

project_name=$1
home_directory=$2
project_type=$3  

mkdir -p "$home_directory"
mkdir -p "$home_directory/$project_name"

cd "$home_directory/$project_name"
if [ "$project_type" == "py" ]
then 
	mkdir -p "src"
        config_file="pyproject.toml"

	touch "$config_file"
	echo "[tool.pyright]" >> "$config_file"
	echo "include = [\"src\"]" >> "$config_file"
	echo "defineConstant = { DEBUG = true }" >> "$config_file"
	echo "reportMissingImports = true" >> "$config_file"
	echo "pythonVersion = \"3.8\"" >> "$config_file"
	echo "pythonPlatform = \"Linux\"" >> "$config_file"
else 
	mkdir -p "src" && mkdir -p "include"
	cmake_file="CMakeLists.txt"

	touch "$cmake_file"
	echo "cmake_minimum_required(VERSION 3.10)" >> "$cmake_file"

	if [ "$project_type" == "cu" ]
	then
		echo "project($project_name LANGUAGES CUDA CXX)" >> "$cmake_file"
		echo "set(CMAKE_CXX_STANDARD 17)" >> "$cmake_file"
		echo "set(CMAKE_CUDA_STANDARD 17)" >> "$cmake_file"
		echo "SET(CMAKE_CUDA_FLAGS \"\${CMAKE_CUDA_FLAGS}\")" >> "$cmake_file"
		echo "SET(CMAKE_CXX_FLAGS \"\${CMAKE_CXX_FLAGS}\")" >> "$cmake_file"

	elif [ "$project_type" == "cxx" ]
	then
		echo "project($project_name LANGUAGES CXX)" >> "$cmake_file"
		echo "set(CMAKE_CXX_STANDARD 17)" >> "$cmake_file"

	else 
		echo "project($project_name)" >> "$cmake_file"
	fi 

	echo "set(CMAKE_EXPORT_COMPILE_COMMANDS ON)" >> "$cmake_file"
	echo "add_executable($project_name)" >> "$cmake_file"

	if [ "$project_type" == "cxx" ]
	then 
		file_ext="cpp" 
		header_ext="h"
	elif [ "$project_type" == "cu" ]
	then 
		file_ext="cu" 
		header_ext="cuh"
	else 
		file_ext="c"
		header_ext="h"
	fi 

	echo "target_sources($project_name PRIVATE ./src/$project_name.$file_ext ./src/main.$file_ext)" >> "$cmake_file"

	if [ "$project_type" == "cu" ]
	then 
		echo "set_property(TARGET $project_name PROPERTY CUDA_ARCHITECTURES 75)" >> "$cmake_file"
		echo "find_package(CUDA)" >> "$cmake_file"
	fi 


	cd "include"

	touch "$project_name.$header_ext"
	if [ "$project_type" == "cu" ] || [ "$project_type" == "cxx" ]
	then 
		echo "#include <iostream>" >> "$project_name.$header_ext"
	else 
		echo "#include <stdio.h>" >> "$project_name.h"
	fi

	echo "void display(int);" >> "$project_name.$header_ext"

	cd "../src"
	touch "$project_name.$file_ext"

	echo "#include \"../include/$project_name.$header_ext\"" >> "$project_name.$file_ext"
	if [ "$project_type" == "cu" ] || [ "$project_type" == "cxx" ]
	then 
		echo "using std::cout;" >> "$project_name.$file_ext"
		echo "using std::endl;" >> "$project_name.$file_ext"
	fi 

	echo "void display(int x)" >> "$project_name.$file_ext"
	echo "{" >> "$project_name.$file_ext"

	if [ "$project_type" == "cu" ] || [ "$project_type" == "cxx" ]
	then
		echo "	cout << x << endl;" >> "$project_name.$file_ext"
	else 
		echo "	printf(\"%d\n\", x);" >> "$project_name.c"
	fi 

	echo "}" >> "$project_name.$file_ext"


	touch "main.$file_ext"
	echo "#include \"../include/$project_name.$header_ext\"" >> "main.$file_ext"
	echo "int main()" >> "main.$file_ext"
	echo "{" >> "main.$file_ext"
	echo "	int z = 5;" >> "main.$file_ext"
	echo "	display(z);" >> "main.$file_ext"
	echo "}" >> "main.$file_ext"

	cd ".."
	cmake -S . -B build
	ln -s build/compile_commands.json .

	if [ "$project_type" == "cu" ]
	then 
		touch ".clangd"
		echo "CompileFlags:" >> ".clangd"
		echo "  Remove:" >> ".clangd"
		echo "    - -forward-unknown-to-host-compiler" >> ".clangd"
		echo "    - --generate-code*" >> ".clangd"
		echo "  Add:" >> ".clangd"
		echo "    - -std=c++17" >> ".clangd"
		echo "    - --cuda-path=/usr/local/cuda" >> ".clangd"
		echo "    - --cuda-gpu-arch=sm_75" >> ".clangd"
		echo "    - -L/usr/local/cuda/lib64" >> ".clangd"
		echo "    - -I/usr/local/cuda/include" >> ".clangd"
		echo "    - -I." >> ".clangd"
	fi
fi 
