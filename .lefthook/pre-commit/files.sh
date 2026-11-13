#!/bin/sh
# Rejects files that must not be in the repository
# (compiled files, binaries, temporary files...).
# Usage: check-forbidden-files.sh <files...>

errors=""

for f in "$@"; do
    case "$f" in
        *.o | *.a | *.so | *.gch | *.pch | *.d | *.obj | *.exe | *.out \
        | *~ | \#*\# | *.swp | vgcore.* | *.gcda | *.gcno \
        | build/* | */build/* | cmake-build-*/* | CMakeFiles/* | */CMakeFiles/* \
        | CMakeCache.txt | */CMakeCache.txt | .idea/*)
            errors="$errors\n  $f"
            continue
            ;;
    esac

    # Compiled executable (ELF format), even without an extension.
    # We read the staged version of the file, not the one on disk.
    if [ "$(git show ":$f" 2>/dev/null | head -c 4 | tail -c 3)" = "ELF" ]; then
        errors="$errors\n  $f (compiled executable)"
    fi
done

if [ -n "$errors" ]; then
    echo ""
    printf "Forbidden files in this commit:%b\n" "$errors"
    echo ""
    echo "Remove them with: git restore --staged <file>"
    echo "Then add them to .gitignore so it does not happen again."
    echo ""
    exit 1
fi

exit 0