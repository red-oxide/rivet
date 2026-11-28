# SPDX-FileCopyrightText: 2026 Chris Palmer <chris@red-oxide.org>
# SPDX-License-Identifier: MIT

# Zola, just and the pinned tack.
{ inputs, ... }:
{
  perSystem =
    { pkgs, system, ... }:
    {
      devShells.default = pkgs.mkShell {
        packages = [
          pkgs.just
          pkgs.zola
          inputs.tack.packages.${system}.tack
        ];
      };
    };
}
