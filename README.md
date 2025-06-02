# nix-pin

A function to pin a package to a given nixpkgs revision.

## Usage

Search for the right pkg name and revision here:
- https://nixhub.io
- https://lazamar.co.uk/nix-versions

Then use the `withRevision` function like so:

```nix
{
  description = "A basic flake";

  inputs = {
    nix-pin.url = "github:akeboshiwind/nix-pin";
  };

  outputs = { self, nix-pin }: {
    devShells.x86_64-linux.default = 
      let
        # 20.18.2
        nodejs = (nix-pin.lib.withRevision {
          system = "x86_64-linux";
          pkg = "nodejs_20";
          rev = "e8d0b02af0958823c955aaab3c82b03f54411d91";
        });
      in
      mkShell {
        buildInputs = [
          nodejs
        ];
      };
  };
}
```

Full example w/ nixpkgs & flake-utils:

```nix
{
  description = "A more complicated flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-24.11";
    flake-utils.url = "github:numtide/flake-utils";
    nix-pin.url = "github:akeboshiwind/nix-pin";
  };

  outputs = { self, nixpkgs, flake-utils, nix-pin }:
    flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = nixpkgs.legacyPackages.${system};

      # 20.18.2
      nodejs = (nix-pin.lib.withRevision {
        inherit system;
        pkg = "nodejs_20";
        rev = "e8d0b02af0958823c955aaab3c82b03f54411d91";
      });
      # 9.15.4
      pnpm = (nix-pin.lib.withRevision {
        inherit system;
        pkg = "pnpm";
        rev = "64e75cd44acf21c7933d61d7721e812eac1b5a0a";
      });
    in {
      devShells.default = pkgs.mkShell {
        packages = [
          # Version doesn't matter
          pkgs.fish

          # Versions do matter
          nodejs
          (pnpm.override { nodejs = nodejs; })
        ];
      };
    });
}
```

You can then start the development shell with: `nix develop -c $SHELL`
