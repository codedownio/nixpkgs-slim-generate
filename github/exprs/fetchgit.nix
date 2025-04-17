with { inherit (import ../../. {}) fetchgit symlinkJoin; };

symlinkJoin {
  name = "slim-nixpkgs-path-closure";
  paths = [
    (fetchgit {
      url = "https://github.com/NixOS/nixpkgs";
      rev = "6d3fc36c541ae715d43db5c1355890f39024b26f";
      sha256 = "sha256-cRsIC0Ft5McBSia0rDdJIHy3muWqKn3rvjFx92DU2dY=";
    })
  ];
}
