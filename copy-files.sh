#!/usr/bin/env bash

SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPTDIR"

TARGET_DIR="$1"

fullNixpkgs=$(nix-build --no-out-link ./full-nixpkgs.nix)
echo "Got fullNixpkgs: $fullNixpkgs"

for file in ./files/*; do
    echo "Processing $file..."

    rsync -av --files-from="$file" "$fullNixpkgs" "$TARGET_DIR"
done

rm -rf "$TARGET_DIR/.github"
cp -r github "$TARGET_DIR/.github"
