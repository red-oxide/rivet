# SPDX-FileCopyrightText: 2026 Chris Palmer <chris@red-oxide.org>
# SPDX-License-Identifier: MIT

# The files `nix run .#generate-palette` writes, from every base24-themes
# scheme. Pure: it needs only a nixpkgs `lib` and base24-themes' `lib.base24`.
#
#   sass/_palette.scss           one block of --base00 … --base17 per scheme,
#                                picked by `data-theme` on <html>
#   templates/theme-check.html   fails the build on an unknown extra.rivet.theme
{
  lib,
  base24,
  default ? "birdland",
}:

let
  inherit (base24) themes;

  names = lib.attrNames themes;

  block =
    name:
    let
      theme = themes.${name};
      meta = base24.getMeta theme;
      colors = base24.getColors theme;
      selectors = lib.optional (name == default) ":root" ++ [ ''[data-theme="${name}"]'' ];
      vars = lib.concatMapStrings (color: "  --${color}: #${colors.${color}};\n") base24.colorNames;
    in
    ''
      // ${meta.name}
      ${lib.concatStringsSep ",\n" selectors} {
        color-scheme: ${meta.variant};
      ${vars}}
    '';

  # One per line, as djlint lays the list out.
  quoted = lib.concatMapStringsSep ",\n" (name: "    \"${name}\"") names;
in
assert lib.assertMsg (themes ? ${default}) "rivet: no base24 scheme named ${default}";
{
  scss = ''
    // Generated from red-oxide/base24-themes by `nix run .#generate-palette`.
    // Do not edit manually. `:root` gets ${default}, for pages without a theme.

    ${lib.concatMapStringsSep "\n" block names}'';

  check = ''
    {#- Generated from red-oxide/base24-themes by `nix run .#generate-palette`. -#}
    {#- Do not edit manually. Included by base.html. -#}
    {%- set rivet_themes = [
    ${quoted}
    ] -%}
    {%- if rivet.theme | default(value="${default}") not in rivet_themes -%}
        {{ throw(message="extra.rivet.theme: unknown theme '" ~ rivet.theme ~ "'; rivet has " ~ rivet_themes | join(sep=", ")) }}
    {%- endif -%}
  '';
}
