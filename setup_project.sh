#!/usr/bin/bash

project_name=$1
home_directory=$2

cmake_file="CMakeLists.txt"
mkdir -p "$home_directory"
mkdir -p "$home_directory/$project_name"

cd "$home_directory/$project_name"

mkdir -p "src" && mkdir -p "include"

touch "$cmake_file"
echo "cmake_minimum_required(VERSION 3.10)" >> "$cmake_file"
echo "project($project_name LANGUAGES CXX)" >> "$cmake_file"
echo "set(CMAKE_EXPORT_COMPILE_COMMANDS ON)" >> "$cmake_file"
echo "set(CMAKE_CXX_STANDARD 17)" >> "$cmake_file"
echo "add_executable($project_name)" >> "$cmake_file"
echo "target_sources($project_name PRIVATE ./src/$project_name.cpp ./src/main.cpp)" >> "$cmake_file"

cd "include"

touch "$project_name.h"

echo "#include <iostream>" >> "$project_name.h"
echo "void display(int);" >> "$project_name.h"

cd "../src"
touch "$project_name.cpp"

echo "#include \"../include/$project_name.h\"" >> "$project_name.cpp"
echo "#include <iostream>" >> "$project_name.cpp"
echo "using std::cout;" >> "$project_name.cpp"
echo "using std::endl;" >> "$project_name.cpp"

echo "void display(int x)" >> "$project_name.cpp"
echo "{" >> "$project_name.cpp"
echo "	cout << x << endl;" >> "$project_name.cpp"
echo "}" >> "$project_name.cpp"

touch "main.cpp"
echo "#include \"../include/$project_name.h\"" >> "main.cpp"
echo "int main()" >> "main.cpp"
echo "{" >> "main.cpp"
echo "	int z = 5;" >> "main.cpp"
echo "	display(z);" >> "main.cpp"
echo "}" >> "main.cpp"

cd ".."
cmake -S . -B build
ln -s build/compile_commands.json .

