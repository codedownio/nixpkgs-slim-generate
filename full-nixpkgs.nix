with { inherit (import <nixpkgs> {}) fetchFromGitHub; };

fetchFromGitHub {
  owner = "NixOS";
  repo = "nixpkgs";
  rev = "6af28b834daca767a7ef99f8a7defa957d0ade6f"; # nixpkgs-rev
  hash = "sha256-W4YZ3fvWZiFYYyd900kh8P8wU6DHSiwaH0j4+fai1Sk="; # nixpkgs-sha256
}
