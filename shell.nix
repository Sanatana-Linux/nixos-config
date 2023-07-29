# Shell for bootstrapping flake-enabled nix and other tooling
{
  pkgs ?
  # If pkgs is not defined, instanciate nixpkgs from locked commit
  let
    lock = (builtins.fromJSON (builtins.readFile ./flake.lock)).nodes.nixpkgs.locked;
    nixpkgs = fetchTarball {
      url = "https://github.com/nixos/nixpkgs/archive/${lock.rev}.tar.gz";
      sha256 = lock.narHash;
    };
  in
    import nixpkgs {overlays = [];},
  ...
}: {
  default = pkgs.mkShell {
    NIX_CONFIG = "extra-experimental-features = nix-command flakes repl-flake";
    nativeBuildInputs = with pkgs; [
      nix
      home-manager
      git
    ];
    shellHook = ''
echo -n "   _______                     __                          " 
echo -n "   |     __|.---.-.-----.---.-.|  |_.---.-.-----.---.-.    "
echo -n "   |__     ||  _  |     |  _  ||   _|  _  |     |  _  |    "
echo -n "   |_______||___._|__|__|___._||____|___._|__|__|___._|    "
echo -n "    _____   __                                             "
echo -n "   |     |_|__|.-----.--.--.--.--.                         "
echo -n "   |       |  ||     |  |  |_   _|                         "
echo -n "   |_______|__||__|__|_____|__.__|                         "   
echo -n "    _______ __         __                                  "
echo -n "   |    ___|  |.---.-.|  |--.-----.                        "
echo -n "   |    ___|  ||  _  ||    <|  -__|                        "
echo -n "   |___|   |__||___._||__|__|_____|                        "
echo -n                                                                   
                         export PS1="[\e[0;34m(Flakes)\$\e[m:\w]\$  '';

  };
}
