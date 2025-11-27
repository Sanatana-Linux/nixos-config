pkgs: 
{
  material-symbols = pkgs.callPackage ./material-symbols {};
  sea-greeter = pkgs.callPackage ./sea-greeter.nix {};
  awesome-luajit = import ./awesome-luajit.nix {
    inherit pkgs;
    inherit (pkgs) stdenv lib fetchFromGitHub;
  };
}
