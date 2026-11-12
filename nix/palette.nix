# rivet's palette: `nix run .#generate-palette` writes sass/_palette.scss, the
# --base00 … --base17 custom properties every rivet site shares, from a
# base24-themes scheme. Change the scheme here and regenerate to recolor every
# site.
{ inputs, lib, ... }:

let
  inherit (inputs.base24-themes.lib) base24;
  scheme = "birdland";
  output = "sass/_palette.scss";
in
{
  perSystem =
    { pkgs, ... }:

    let
      theme = base24.themes.${scheme};
      meta = base24.getMeta theme;
      colors = base24.getColors theme;

      cssColors = lib.concatMapStringsSep "\n" (
        name: "  --${name}: #" + colors.${name} + ";"
      ) base24.colorNames;

      generatedScss = ''
        // Generated from red-oxide/base24-themes by `nix run .#generate-palette`
        // Scheme: ${meta.name}
        // Variant: ${meta.variant}
        // Do not edit manually.

        :root {
        ${cssColors}
        }
      '';
    in
    {
      packages.generate-palette = pkgs.writeShellApplication {
        name = "generate-palette";

        runtimeInputs = [
          pkgs.coreutils
        ];

        text = ''
          set -euo pipefail

          output="''${1:-${output}}"

          mkdir -p "$(dirname "$output")"

          # generatedScss ends in a newline, so the delimiter follows it
          # directly: no trailing blank line for the formatter to remove.
          cat > "$output" <<'PALETTE_SCSS'
          ${generatedScss}PALETTE_SCSS

          echo "Generated $output"
        '';
      };
    };
}
