default:
    @just --list

fmt:
    nix fmt

check:
    nix flake check

update:
    nix flake update

palette:
    nix run .#generate-palette
