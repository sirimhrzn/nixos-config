{
  description = "sirixnix";

  inputs = {
    nixpkgs-stable.url = "github:nixos/nixpkgs?ref=nixos-24.05";
    nixpkgs-beta.url = "github:nixos/nixpkgs?ref=nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs?ref=nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager?ref=release-24.05";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };
    ghostty.url = "git+ssh://git@github.com/ghostty-org/ghostty";
  };
  outputs =
    {
      self,
      nixpkgs-stable,
      nixpkgs-beta,
      nixpkgs-unstable,
      ghostty,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      # pkgs = import nixpkgs-stable {
      #   inherit system;
      #   config.allowUnfree = true;
      # };
      
      stable = import nixpkgs-stable {
        inherit system;
        config.allowUnfree = true;
      };
      beta = import nixpkgs-beta {
        inherit system;
        config.allowUnfree = true;
      };

	unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };
    in
    {
      nixosConfigurations = {
        sirimhrzn = nixpkgs-stable.lib.nixosSystem {
          specialArgs = {
            inherit
              system
              unstable
              stable
              beta
              inputs
              ;
          };
          modules = [
            ./nixos/configuration.nix
            inputs.home-manager.nixosModules.default
          ];
        };
      };
    };
}
