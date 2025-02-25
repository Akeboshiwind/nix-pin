{
  description = "A function to pin a package to a given nixpkgs revision.";

  outputs = { self }: {
    lib = {
      # Adapted from: https://lazamar.co.uk/nix-versions
      withRevision = (
        {
          pkg,
          rev,
          system,
          url ? "https://github.com/NixOS/nixpkgs/",
          ref ? "refs/heads/nixpkgs-unstable",
        }:
        let
          versionPkgs =
            import
              (builtins.fetchGit {
                name = "nixpkgs-from-${rev}";
                inherit url;
                inherit ref;
                inherit rev;
              })
              {
                inherit system;
              };
        in
        versionPkgs.${pkg}
      );
    };
  };
}
