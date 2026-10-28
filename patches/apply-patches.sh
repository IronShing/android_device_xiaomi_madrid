#!/bin/bash
# Apply the madrid patches to repos that are not forked. Run from the root of the LineageOS 24.0 tree.
set -e
TOP=$(pwd)
DIR=$(dirname "$(readlink -f "$0")")
for p in "$DIR"/*/; do
    repo_dir=$(basename "$p" | tr '_' '/')
    echo "== $repo_dir"
    (cd "$TOP/$repo_dir" && git am -3 "$p"/*.patch)
done
