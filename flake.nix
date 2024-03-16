{
  description = "NixOS";

  nixConfig = {
    extra-substituters =
      [ "https://nyx.chaotic.cx/" "https://nix-gaming.cachix.org" ];
    extra-trusted-public-keys = [
      "nyx.chaotic.cx-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8="
      "chaotic-nyx.cachix.org-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8="
      "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
    ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-master.url = "github:nixos/nixpkgs/master";
    hardware.url = "github:nixos/nixos-hardware";
    impermanence.url = "github:nix-community/impermanence";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    chaotic = { url = "github:chaotic-cx/nyx/nyxpkgs-unstable"; };
    plasma-manager.url = "github:pjones/plasma-manager";
    plasma-manager.inputs.nixpkgs.follows = "nixpkgs";
    plasma-manager.inputs.home-manager.follows = "home-manager";
    nix-gaming.url = "github:fufexan/nix-gaming";
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs:
    with inputs;
    let
      inherit (self) outputs;
      lib = nixpkgs.lib // home-manager.lib;
      systems = [ "x86_64-linux" "aarch64-linux" ];
      forEachSystem = f: lib.genAttrs systems (system: f pkgsFor.${system});
      pkgsFor = lib.genAttrs systems (system:
        import nixpkgs {
          inherit system;
          config.allowUnfree = true;
          config.joypixels.acceptLicense = true;
          config.allowUnfreePredicate = (_: true);
        });
    in {
      inherit lib;
      nixosModules = import ./modules/nixos;
      homeManagerModules = import ./modules/home-manager;
      templates = import ./templates;

      overlays = import ./overlays { inherit inputs outputs; };

      packages = forEachSystem (pkgs: import ./pkgs { inherit pkgs; });
      formatter = forEachSystem (pkgs: pkgs.nixpkgs-fmt);

      nixosConfigurations = {
        sangrainwong = let
          configName = "sangrainwong";
          userConfigName = configName;
          _specialArgs = rec {
            inherit inputs outputs self;
            secrets = builtins.fromJSON (builtins.readFile
              "${self}/secrets/${configName}/evalsecrets.json");
            hostname = secrets.machine."hostname";
            username = secrets.os."username";
            homeDirectory = secrets."home_directory";
            displayForBoot = let x = builtins.elemAt secrets."displays" 0;
            in x // rec {
              dpi = builtins.ceil (x.resolution.width / (x.width_mm / 25.4));
              scale = x.multiplier * (dpi / 96.0);
            };
            inherit configName userConfigName;
          };
        in lib.nixosSystem {
          modules = [ ./hosts/${configName} ];
          specialArgs = _specialArgs // {
            specialArgsPassthrough = _specialArgs;
          };
        };
        test = let
          configName = "test";
          userConfigName = configName;
          _specialArgs = rec {
            inherit inputs outputs self;
            secrets = {
              hostname = "test";
              username = "test";
              home_directory = "/home/test";
              machine_id = "66666666666666666666666666666666";
            };
            hostname = secrets."hostname";
            username = secrets."username";
            homeDirectory = secrets."home_directory";
            displayForBoot = let x = builtins.elemAt secrets."displays" 0;
            in x // rec {
              dpi = builtins.ceil (x.resolution.width / (x.width_mm / 25.4));
              scale = x.multiplier * (dpi / 96.0);
            };
            inherit configName userConfigName;
          };
        in lib.nixosSystem {
          modules = [ ./hosts/${configName} ];
          specialArgs = _specialArgs // {
            specialArgsPassthrough = _specialArgs;
          };
        };
      };
    };
}
