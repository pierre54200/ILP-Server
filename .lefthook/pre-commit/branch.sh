#!/bin/sh
# Prevents committing directly on protected branches.
# Work on a dedicated branch (feat/..., fix/...) and merge it instead.

protected='main master'

# No commit yet in the repository: allow the very first commit
git rev-parse --verify HEAD >/dev/null 2>&1 || exit 0

# Finishing a merge (after resolving conflicts): allow it
[ -f "$(git rev-parse --git-dir)/MERGE_HEAD" ] && exit 0

branch=$(git rev-parse --abbrev-ref HEAD)

for p in $protected; do
    if [ "$branch" = "$p" ]; then
        echo ""
        echo "Direct commits on \"$branch\" are not allowed."
        echo ""
        echo "Create a branch first, your changes will follow:"
        echo "  git switch -c feat/my-feature"
        echo ""
        exit 1
    fi
done

exit 0