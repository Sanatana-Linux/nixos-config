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
    import nixpkgs {overlays = import ./overlays {};},
  ...
}: {
  default = pkgs.mkShell {
    NIX_CONFIG = "extra-experimental-features = nix-command auto-allocate-uids recursive-nix flakes ";

    nativeBuildInputs = with pkgs; [
      nix
      home-manager
      git
      vim
      zsh
    ];
    # shellHook = "" "bash echo && \
    #  echo '   _______                     __                          ' && \
    #  echo '   |     __|.---.-.-----.---.-.|  |_.---.-.-----.---.-.    ' && \
    #  echo '   |__     ||  _  |     |  _  ||   _|  _  |     |  _  |    ' && \
    #  echo '   |_______||___._|__|__|___._||____|___._|__|__|___._|    ' && \
    #  echo '    _____   __                                             ' && \
    #  echo '   |     |_|__|.-----.--.--.--.--.                         ' && \
    #  echo '   |       |  ||     |  |  |_   _|                         ' && \
    #  echo '   |_______|__||__|__|_____|__.__|                         '  && \
    #  echo '    _______ __         __                                  ' && \
    #  echo '   |    ___|  |.---.-.|  |--.-----.                        ' && \
    #  echo '   |    ___|  ||  _  ||    <|  -__|                        ' && \
    #  echo '   |___|   |__||___._||__|__|_____|                        ' && \
    #  echo
    # " "";
  };
}
