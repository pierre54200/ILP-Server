#!/bin/sh
# Checks that the project compiles before pushing.
# Uses CMake if a CMakeLists.txt exists, otherwise the Makefile.

echo "Checking that the project compiles..."

if [ -f CMakeLists.txt ]; then
    generator=""
    command -v ninja >/dev/null 2>&1 && generator="-G Ninja"
    # shellcheck disable=SC2086
    cmake -S . -B build/.hook-check $generator >/dev/null \
        && cmake --build build/.hook-check
    status=$?
elif [ -f Makefile ]; then
    make
    status=$?
else
    echo "No CMakeLists.txt or Makefile found: check skipped."
    exit 0
fi

if [ "$status" -ne 0 ]; then
    echo ""
    echo "The project does not compile: push cancelled."
    echo ""
    exit 1
fi

exit 0