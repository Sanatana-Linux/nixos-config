{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.tlh.programs.zsh;
in {
  options.tlh.programs.zsh.enable = mkEnableOption "enable zsh";

  config = mkIf cfg.enable {
    programs.zsh = {
      enable = true;
      enableAutosuggestions = true;
      enableCompletion = true;
      autocd = true;
      dotDir = ".config/zsh";

      sessionVariables = {ZDOTDIR = "/home/tlh/.config/zsh";};

      initExtra = ''
        bindkey "^[[1;5C" forward-word
        bindkey "^[[1;5D" backward-word

        # revert last n commits
        grv() {
          ${pkgs.git}/bin/git reset --soft HEAD~$1
        }

        # get github url of current repository
        gh() {
          echo $(${pkgs.git}/bin/git config --get remote.origin.url | sed -e 's/\(.*\)git@\(.*\):[0-9\/]*/https:\/\/\2\//g')
        }
        ipinfo() {
          nix-shell -p ipfetch --run "ipfetch && exit"
        }

      '';

      history = {
        expireDuplicatesFirst = true;
        ignoreSpace = false;
        save = 15000;
        share = true;
      };

      plugins = [
        {
          name = "fast-syntax-highlighting";
          file = "fast-syntax-highlighting.plugin.zsh";
          src = "${pkgs.zsh-fast-syntax-highlighting}/share/zsh/site-functions";
        }
        {
          name = "zsh-nix-shell";
          file = "nix-shell.plugin.zsh";
          src = "${pkgs.zsh-nix-shell}/share/zsh-nix-shell";
        }
      ];

      shellAliases = rec {
        ls = "${pkgs.exa}/bin/exa --group-directories-first --icons --color-scale";
        l = "${ls} -lbF --git --icons";
        ll = "${l} -G";
        la = "${ls} -lbhHigmuSa@ --time-style=long-iso --git --color-scale --icons";
        lt = "${ls} --tree --level=2 --icons";

        # Git
        gs = "${pkgs.git}/bin/git status";

        # nix

        # switching within a flake repository
        frb = "${pkgs.nixos-rebuild}/bin/nixos-rebuild --use-remote-sudo switch --flake";

        # always execute nixos-rebuild with sudo for switching
        nixos-rebuild = "${pkgs.nixos-rebuild}/bin/nixos-rebuild --use-remote-sudo";

        # list syslinks into nix-store
        nix-list = "${pkgs.nix}/bin/nix-store --gc --print-roots";

        # flake checks
        nfc = "${pkgs.nix}/bin/nix flake check";
        nfcs = "${pkgs.nix}/bin/nix flake check --show-trace";

        # Other
        lsblk = "${pkgs.util-linux}/bin/lsblk -o name,mountpoint,label,size,type,uuid";
        performance = "echo performance | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor";
        powersave = "echo powersave | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor";

        # Ultra easy single core bench
        qbench = "factor 82364768726407498326494787264827418648729874012787126398621046198639874623984721986439";
      };
    };

    programs.zsh.oh-my-zsh = {
      enable = true;
      theme = "agnoster";
    };

    programs.dircolors = {
      enable = true;
      enableZshIntegration = true;
    };

    programs.htop = {
      enable = true;
      settings = {
        show_cpu_frequency = true;
        show_cpu_temprature = true;
        show_cpu_usage = true;
        show_program_path = true;
        tree_view = false;
      };
    };

    programs.jq.enable = true;

    programs.bat = {
      enable = true;
      # This should pick up the correct colors for the generated theme. Otherwise
      # it is possible to generate a custom bat theme to ~/.config/bat/config
      config = {theme = "base16";};
    };
  };
}
