{
  description = "NixOS System Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.1";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence.url = "github:nix-community/impermanence";

    auto-cpufreq = {
      url = "github:AdnanHodzic/auto-cpufreq";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    niri.url = "github:sodiboo/niri-flake";

    stylix.url = "github:danth/stylix/release-24.11";

    agenix.url = "github:ryantm/agenix";
    agenix-rekey = {
      url = "github:oddlama/agenix-rekey";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    crowdsec = {
      url = "git+https://codeberg.org/kampka/nix-flake-crowdsec.git";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    authentik-nix.url = "github:nix-community/authentik-nix";

    lurker.url= "github:oppiliappan/lurker";
  };

  outputs = {
    self,
    nixpkgs, nixpkgs-unstable,
    lanzaboote,
    impermanence,
    disko,
    auto-cpufreq,
    home-manager,
    niri,
    stylix,
    agenix, agenix-rekey,
    crowdsec, authentik-nix,
    lurker,
    ...
  }@inputs:

  let
    commonModules = [
      { nixpkgs.hostPlatform = "x86_64-linux"; }
      stylix.nixosModules.stylix
      agenix.nixosModules.default
      agenix-rekey.nixosModules.default
			home-manager.nixosModules.home-manager {
			  home-manager.useGlobalPkgs = true;
			  home-manager.useUserPackages = true;
        home-manager.backupFileExtension = "backup";
      }
    ];

    laptopModules = commonModules ++ [
      impermanence.nixosModules.impermanence
      disko.nixosModules.disko
			auto-cpufreq.nixosModules.default
      niri.nixosModules.niri
      { home-manager.users.fern.imports = [ impermanence.homeManagerModules.impermanence ]; }
    ];

    serverModules = commonModules ++ [
      authentik-nix.nixosModules.default
      crowdsec.nixosModules.crowdsec
      crowdsec.nixosModules.crowdsec-firewall-bouncer
      lurker.nixosModules.default
    ];
  in {
    agenix-rekey = agenix-rekey.configure {
      userFlake = self;
      nixosConfigurations = self.nixosConfigurations;
    };

    nixosConfigurations.garden = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };
      modules = laptopModules ++ [
			  lanzaboote.nixosModules.lanzaboote
			  { home-manager.users.fern = import ./home/hosts/garden.nix; }
        ./system/hosts/garden
      ];
    };

    nixosConfigurations.leaf = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };
      modules = laptopModules ++ [
			  { home-manager.users.fern = import ./home/hosts/leaf.nix; }
        ./system/hosts/leaf
      ];
    };

    nixosConfigurations.forest = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };
      modules = serverModules ++ [
			  lanzaboote.nixosModules.lanzaboote
			  { home-manager.users.fern = import ./home/hosts/forest.nix; }
        ./system/hosts/forest
      ];
    };
  };
}
