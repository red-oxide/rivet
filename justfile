# SPDX-FileCopyrightText: 2026 Chris Palmer <chris@red-oxide.org>
# SPDX-License-Identifier: MIT

dev := if env("IN_NIX_SHELL", "") == "" { "nix develop --command " } else { "" }

default:
    @just --list

fmt:
    nix fmt

check:
    nix flake check

# Update the pins (tack): all, or the ones named, like `just update nixpkgs`
update *names:
    {{ dev }}tack update {{ names }}

# Show which pins have newer upstream revisions
look:
    {{ dev }}tack look

# Run any other tack command
tack *args:
    {{ dev }}tack {{ args }}

palette:
    nix run .#generate-palette
