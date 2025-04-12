#!/usr/bin/env bash

SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPTDIR"

fullNixpkgs=$(nix-build --no-out-link ./full-nixpkgs.nix)
echo "Got full Nixpkgs: ${fullNixpkgs}"

STORE=$(mktemp -d -p $(pwd) store.XXXXXXXXXX)

cleanup() {
  echo "Cleaning up $STORE..."
  chmod -R u+w "$STORE"
  rm -rf "$STORE"
}
trap cleanup EXIT

function generate_for_system() {
  SYSTEM="$1"
  echo "Generating for system: $SYSTEM"

  NIX_PATH="nixpkgs=$fullNixpkgs"
  export NIX_PATH

  nix-build -vv expr.nix --store "$STORE" --no-out-link --argstr system "$SYSTEM" --substituters https://cache.nixos.org > all_build_output.txt 2>&1

  grep -o "$fullNixpkgs/[^']*" all_build_output.txt | sed "s|$fullNixpkgs/||g" | sort | uniq > "files/$SYSTEM.txt"

  rm all_build_output.txt
}

CURRENT_SYSTEM=$(nix eval --impure --expr "builtins.currentSystem" | tr -d '"')

if [[ $CURRENT_SYSTEM == *-linux ]]; then
    generate_for_system x86_64-linux
    generate_for_system aarch64-linux
elif [[ $CURRENT_SYSTEM == *-darwin ]]; then
    generate_for_system x86_64-darwin
    generate_for_system aarch64-darwin
else
    echo "Unrecognized current system: $CURRENT_SYSTEM"
fi
