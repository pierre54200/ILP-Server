#!/bin/sh
# Rejects files that still contain merge conflict markers.
# Usage: check-conflict-markers.sh <files...>

# Only "<<<<<<< " and ">>>>>>> " are checked: a line of "=======" alone
# can be legitimate (Markdown titles, ASCII art...).
pattern='^(<<<<<<<|>>>>>>>)( |$)'

errors=""

for f in "$@"; do
    # Staged version of the file; -I skips binary files
    matches=$(git show ":$f" 2>/dev/null | grep -nIE "$pattern" | cut -d: -f1 | tr '\n' ' ' | sed 's/ $//')
    if [ -n "$matches" ]; then
        errors="$errors\n  $f (lines: $matches)"
    fi
done

if [ -n "$errors" ]; then
    echo ""
    printf "Merge conflict markers found:%b\n" "$errors"
    echo ""
    echo "Finish resolving the conflicts, then run git add again."
    echo ""
    exit 1
fi

exit 0