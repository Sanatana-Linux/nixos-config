# TODO get this to work right 
# Development Shell for Bootstrapping NixOS with Flakes enabled and including useful programs like git and home manager.
# use "nix shell" or 'nix develop' to use it 

# Shell for bootstrapping flake-enabled nix and home-manager
{ pkgs ? let
    # If pkgs is not defined, instantiate nixpkgs from locked commit
    lock = (builtins.fromJSON (builtins.readFile ./flake.lock)).nodes.nixpkgs.locked;
    nixpkgs = fetchTarball {
      url = "https://github.com/nixos/nixpkgs/archive/${lock.rev}.tar.gz";
      sha256 = lock.narHash;
    };
    system = builtins.currentSystem;
    overlays = [ ]; # Explicit blank overlay to avoid interference
  in
  import nixpkgs { inherit system overlays; }
, ...
}: pkgs.mkShell {
  # Enable experimental features without having to specify the argument
  NIX_CONFIG = "experimental-features = nix-command flakes";
  nativeBuildInputs = with pkgs; [ nix home-manager git ];
  shellHook=""
     ______   _           _
    |  ____| | |         | |
    | |__    | |   __ _  | | __   ___   ___
    |  __|   | |  / _\` | | |/ /  / _ \ / __|
    | |      | | | (_| | |   <  |  __/ \\__ \\
    |_|      |_|  \__,_| |_|\_\  \___| |___/
          "
            export PS1="[\e[0;34m(Flakes)\$\e[m:\w]\$ "
  '';


}
