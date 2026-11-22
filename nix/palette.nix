# rivet's palettes: `nix run .#generate-palette` writes sass/_palette.scss and
# templates/theme-options.html from every base24-themes scheme (see
# lib/palette.nix). Sites pick a default with extra.rivet.theme, and visitors
# can switch in the header. `nix flake check` fails if either file is stale.
{ inputs, lib, ... }:

let
  generated = import ../lib/palette.nix {
    inherit lib;
    inherit (inputs.base24-themes.lib) base24;
  };

  files = {
    "sass/_palette.scss" = generated.scss;
    "templates/theme-options.html" = generated.options;
  };
in
{
  perSystem =
    { pkgs, ... }:

    let
      store = lib.mapAttrs (path: text: pkgs.writeText (baseNameOf path) text) files;
    in
    {
      packages.generate-palette = pkgs.writeShellApplication {
        name = "generate-palette";

        runtimeInputs = [ pkgs.coreutils ];

        text = ''
          root="''${1:-.}"
        ''
        + lib.concatStrings (
          lib.mapAttrsToList (path: file: ''
            mkdir -p "$root/${dirOf path}"
            install -m 644 ${file} "$root/${path}"
            echo "Generated $root/${path}"
          '') store
        );
      };

      checks.palette = pkgs.runCommand "rivet-palette-up-to-date" { } (
        lib.concatStrings (
          lib.mapAttrsToList (path: file: ''
            diff -u ${../. + "/${path}"} ${file} \
              || { echo "${path} is stale: run \`nix run .#generate-palette\`"; exit 1; }
          '') store
        )
        + "touch $out\n"
      );
    };
}
