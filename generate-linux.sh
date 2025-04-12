#!/usr/bin/env bash

SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPTDIR"

fullNixpkgs=$(nix-build ./full-nixpkgs.nix)
echo "Got full Nixpkgs: ${fullNixpkgs}"

NIX_PATH="nixpkgs=$fullNixpkgs"
export NIX_PATH

STORE=$(mktemp -d)

cleanup() {
  echo "Cleaning up $STORE..."
  chmod -R u+w "$STORE"
  rm -rf "$STORE"
}
trap cleanup EXIT

nix-build -vv expr.nix --store "$STORE" --no-out-link --substituters https://cache.nixos.org > all_build_output.txt 2>&1

cat all_build_output.txt | grep -o -P "$fullNixpkgs/[^']*" | sort | uniq > files-linux.txt

rm all_build_output.txt
