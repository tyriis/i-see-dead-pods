let
  pkgs = import <nixpkgs> {};
in
  pkgs.mkShell {
    packages = [
      pkgs.go-task
      pkgs.kubernetes-helm
      pkgs.pre-commit
    ];
  }
