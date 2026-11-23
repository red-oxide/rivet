# SPDX-FileCopyrightText: 2026 Chris Palmer <chris@red-oxide.org>
# SPDX-License-Identifier: MIT

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
