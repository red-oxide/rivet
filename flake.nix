{
  description = "rivet: the Zola theme shared by chris.palmerlife.online and red-oxide.org";

  inputs = {
    base24-themes = {
      url = "github:red-oxide/base24-themes";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.devfmt.follows = "devfmt";
    };
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    devfmt = {
      url = "github:red-oxide/devfmt";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs:
    inputs.devfmt.lib.mkFlake { inherit inputs; } {
      imports = [
        (inputs.devfmt.lib.importTree ./nix)
      ];
    };
}
