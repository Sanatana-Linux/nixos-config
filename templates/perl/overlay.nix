self: super: {
  perl = super.perl.override {
    overrides = perlPackages:
      with perlPackages; let
        inherit (self) lib fetchurl;
      in {
        # Packages generated with nix-generate-from-cpan goes here

        #TestLib = buildPerlPackage {
        #  pname = "Test-Lib";
        #  version = "0.003";
        #  src = fetchurl {
        #    url = "mirror://cpan/authors/id/H/HA/HAARG/Test-Lib-0.003.tar.gz";
        #    sha256 = "d84b48d92567cba3d0afb1e8175aab836bfa8a838e19ac9080cabc2e3f9dc9f5";
        #  };
        #  meta = {
        #    description = "Use libraries from a t/lib directory";
        #    license = with lib.licenses; [ artistic1 gpl1Plus ];
        #  };
        #};
      };
  };
}
