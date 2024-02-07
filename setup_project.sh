#!/usr/bin/bash

project_name=$1
home_directory=$2
project_type=$3  

cmake_file="CMakeLists.txt"

mkdir -p "$home_directory"
mkdir -p "$home_directory/$project_name"

cd "$home_directory/$project_name"
mkdir -p "src" && mkdir -p "include"


touch "$cmake_file"
echo "cmake_minimum_required(VERSION 3.10)" >> "$cmake_file"

if [ "$project_type" == "cu" ]
then
	echo "project($project_name LANGUAGES CUDA CXX)" >> "$cmake_file"
	echo "set(CMAKE_CXX_STANDARD 17)" >> "$cmake_file"
	echo "set(CMAKE_CUDA_STANDARD 17)" >> "$cmake_file"
	echo "SET(CMAKE_CUDA_FLAGES \x22\x36{CMAKE_CUDA_FLAGS}\x22)"
	echo "SET(CMAKE_CXX_FLAGS \x22\x36{CMAKE_CXX_FLAGS}\x22)"

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

echo "void display(int);" >> "$project_name.h"

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

