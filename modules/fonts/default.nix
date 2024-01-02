{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.tlh.defaults.fonts;
in {
  options.tlh.defaults.fonts = {enable = mkEnableOption "Fonts defaults";};

  config = mkIf cfg.enable {
    fonts = {
      fontDir.enable = true;
      fonts = with pkgs; [
        oto-fonts
        noto-fonts-cjk
        noto-fonts-emoji
        liberation_ttf
        fira-code
        fira-code-symbols
        mplus-outline-fonts.githubRelease
        dina-font
        proggyfonts
        league-of-moveable-type
        inter
        source-sans-pro
        source-serif-pro
        noto-fonts-emoji
        corefonts
        recursive
        iosevka-bin
        nur.repos.ilya-fedin.exo2
        nur.repos.ilya-fedin.cascadia-code-powerline
        nur.repos.ilya-fedin.ttf-croscore
        carlito
        caladea
        unifont
        symbola
        joypixels
        nur.repos.ilya-fedin.nerd-fonts-symbols
      ];

      fontconfig = {
        defaultFonts = {
          serif = ["Berkeley Mono" "Inconsolata Nerd Font Mono"];
          sansSerif = ["Berkeley Mono" "Inconsolata Nerd Font Mono"];
          monospace = ["Berkeley Mono" "Inconsolata Nerd Font Mono"];
          emoji = ["Noto Color Emoji"];
        };
      };
    };
  };
}
