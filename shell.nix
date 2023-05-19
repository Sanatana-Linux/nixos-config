# TODO get this to work right 
# Development Shell for Bootstrapping NixOS with Flakes enabled and including useful programs like git and home manager.
# use "nix shell" or 'nix develop' to use it 
{ pkgs ? (import ./nixpkgs.nix) { } }: {
  default = pkgs.mkShell {
    # Enable experimental features without having to specify the argument
    NIX_CONFIG = "experimental-features = nix-command flakes";
 shellHook = ''
          echo "
     ______   _           _
    |  ____| | |         | |
    | |__    | |   __ _  | | __   ___   ___
    |  __|   | |  / _\` | | |/ /  / _ \ / __|
    | |      | | | (_| | |   <  |  __/ \\__ \\
    |_|      |_|  \__,_| |_|\_\  \___| |___/
          "
            export PS1="[\e[0;34m(Flakes)\$\e[m:\w]\$ "
  '';
    nativeBuildInputs = with pkgs; [ nix home-manager git vim ];
  };
}
