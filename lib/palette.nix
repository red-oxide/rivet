# The files `nix run .#generate-palette` writes, from every base24-themes
# scheme. Pure: it needs only a nixpkgs `lib` and base24-themes' `lib.base24`.
#
#   sass/_palette.scss              one block of --base00 … --base17 per scheme
#   templates/theme-options.html    the theme picker's <option>s, one per family
#
# A family is a dark scheme and its `-light` counterpart (`harbor`,
# `harbor-light`); a page picks one with `data-theme` on <html>.
{
  lib,
  base24,
  default ? "birdland",
}:

let
  inherit (base24) themes;

  names = lib.attrNames themes;
  isLight = lib.hasSuffix "-light";

  # Families are named by their dark scheme; a light-only scheme is its own.
  families = lib.filter (
    name: !(isLight name) || !(themes ? ${lib.removeSuffix "-light" name})
  ) names;

  hasLight = family: themes ? "${family}-light";

  # A family without a light variant answers to `-light` with its dark colors,
  # so the light/dark toggle never falls back to another family.
  selectors =
    name:
    lib.optional (name == default) ":root"
    ++ lib.optional (!(isLight name) && !(hasLight name)) ''[data-theme="${name}-light"]''
    ++ [ ''[data-theme="${name}"]'' ];

  block =
    name:
    let
      theme = themes.${name};
      meta = base24.getMeta theme;
      colors = base24.getColors theme;
      vars = lib.concatMapStrings (color: "  --${color}: #${colors.${color}};\n") base24.colorNames;
    in
    ''
      // ${meta.name} (${meta.variant})
      ${lib.concatStringsSep ",\n" (selectors name)} {
        color-scheme: ${meta.variant};
      ${vars}}
    '';

  option = family: ''
    <option value="${family}">${(base24.getMeta themes.${family}).name}</option>
  '';
in
assert lib.assertMsg (themes ? ${default}) "rivet: no base24 scheme named ${default}";
{
  scss = ''
    // Generated from red-oxide/base24-themes by `nix run .#generate-palette`.
    // Do not edit manually. `:root` gets ${default}, for pages without a theme.

    ${lib.concatMapStringsSep "\n" block names}'';

  options = ''
    {#- Generated from red-oxide/base24-themes by `nix run .#generate-palette`. -#}
    {#- Do not edit manually. -#}
    ${lib.concatMapStrings option families}'';
}
