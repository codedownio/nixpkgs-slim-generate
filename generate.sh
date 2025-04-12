#!/usr/bin/env bash

SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPTDIR"

fullNixpkgs=$(nix-build --no-out-link ./full-nixpkgs.nix)
echo "Got full Nixpkgs: ${fullNixpkgs}"

SYSTEM=$(nix eval --impure --expr "builtins.currentSystem" | tr -d '"')
echo "Generating for system: $SYSTEM"

NIX_PATH="nixpkgs=$fullNixpkgs"
export NIX_PATH

STORE=$(mktemp -d -p $(pwd) store.XXXXXXXXXX)

cleanup() {
  echo "Cleaning up $STORE..."
  chmod -R u+w "$STORE"
  rm -rf "$STORE"
}
trap cleanup EXIT

nix-build -vv expr.nix --store "$STORE" --no-out-link --substituters https://cache.nixos.org > all_build_output.txt 2>&1

grep -o "$fullNixpkgs/[^']*" all_build_output.txt | sort | uniq > "files/$SYSTEM.txt"

rm all_build_output.txt
