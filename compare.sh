#!/usr/bin/env sh

set -e

# Check that the newest directory which has all files
# also has matching files.

files="emscripten.txt ubuntu-trusty-clang.txt ubuntu-trusty.txt windows.txt "
firstFile="${files%% *}"
for dir in $(ls -dt ???????????*)
do
    cd "$dir"
    echo "Checking $dir..."
    existingFiles="$(ls -1 | tr '\n' ' ')"
    if [ "$existingFiles" = "$files" ]
    then
        # all files here
        (
        for f in $files
        do
            echo "Comparing $firstFile and $f..."
            diff "$firstFile" "$f"
        done
        )
        echo "All of them are equal!"
        break
    else
        # some files missing, complain if directory old
        if [ -z "$(find . -mtime 0)" ]
        then
            echo "Some files missing (or surplus files)"
            echo "Files here:"
            ls
            echo "Expected files: $files"
            false
        else
            echo " -> Directory not complete, but also less than a day old."
        fi
    fi
    cd ..
done