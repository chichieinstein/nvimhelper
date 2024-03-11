#!/bin/bash 

# Run tests under compute-sanitizer
compute-sanitizer --tool memcheck --leak-check full ./leak_tests > sanitizer_output.txt 2>&1 

if grep -q "ERROR SUMMARY: 0 errors" sanitizer_output.txt; then
	exit 0
else 
	exit 1
fi
