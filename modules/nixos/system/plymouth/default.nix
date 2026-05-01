{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.system.plymouth;

  # Create the Sanatana Plymouth theme
  sanatanaTheme = pkgs.stdenv.mkDerivation rec {
    pname = "sanatana-plymouth-theme";
    version = "1.0.0";

    src = ./.; # Use current directory as source

    buildInputs = with pkgs; [
      plymouth
    ];

    installPhase = ''
            mkdir -p $out/share/plymouth/themes/sanatana

            # Copy the logo image
            cp ${./sanatana-linux-icon.png} $out/share/plymouth/themes/sanatana/logo.png

            # Create the theme configuration file
            cat > $out/share/plymouth/themes/sanatana/sanatana.plymouth << 'EOF'
      [Plymouth Theme]
      Name=Sanatana Linux
      Description=Sanatana Linux Plymouth theme with custom logo
      ModuleName=script

      [script]
      ImageDir=$out/share/plymouth/themes/sanatana
      ScriptFile=$out/share/plymouth/themes/sanatana/sanatana.script
      EOF

            # Create the script file
            cat > $out/share/plymouth/themes/sanatana/sanatana.script << 'EOF'
      # Sanatana Linux Plymouth Theme Script
      # Based on two-step theme with custom branding

      Window.SetBackgroundTopColor(0.07, 0.07, 0.07);
      Window.SetBackgroundBottomColor(0.07, 0.07, 0.07);

      # Load and display the logo
      logo.image = Image("logo.png");
      logo.sprite = Sprite(logo.image);
      logo.sprite.SetPosition(Window.GetWidth() / 2 - logo.image.GetWidth() / 2,
                             Window.GetHeight() / 2 - logo.image.GetHeight() / 2 - 50);

      # Progress bar configuration
      progress_box.image = Image.Text("", 1, 1, 1);
      progress_box.sprite = Sprite(progress_box.image);
      progress_box.x = Window.GetWidth() / 2 - progress_box.image.GetWidth() / 2;
      progress_box.y = Window.GetHeight() * 0.75;
      progress_box.sprite.SetPosition(progress_box.x, progress_box.y);

      # Progress bar styling - draw programmatically
      progress_bar.width = 400;
      progress_bar.height = 4;

      progress_bar.bg_image = Image.Text(" ", 0, 0, 0);
      progress_bar.bg_image = progress_bar.bg_image.Scale(progress_bar.width, progress_bar.height);
      progress_bar.bg_sprite = Sprite(progress_bar.bg_image);
      progress_bar.x = Window.GetWidth() / 2 - progress_bar.width / 2;
      progress_bar.y = Window.GetHeight() * 0.75;
      progress_bar.bg_sprite.SetPosition(progress_bar.x, progress_bar.y);
      progress_bar.bg_sprite.SetOpacity(0.3);

      progress_bar.fg_image = Image.Text(" ", 0.42, 0.61, 0.91);
      progress_bar.sprite = Sprite();
      progress_bar.sprite.SetPosition(progress_bar.x, progress_bar.y);

      fun progress_callback(duration, progress) {
          new_width = Math.Int(progress_bar.width * progress);
          if (new_width > 0) {
              progress_bar.image = progress_bar.fg_image.Scale(new_width, progress_bar.height);
              progress_bar.sprite.SetImage(progress_bar.image);
          }
      }

      Plymouth.SetBootProgressFunction(progress_callback);

      # Message display
      message_sprite = Sprite();
      message_sprite.SetPosition(Window.GetWidth() / 2 - 200, Window.GetHeight() * 0.9);

      fun display_normal_callback() {
          global.status = "normal";
      }

      fun display_password_callback(prompt, bullets) {
          global.status = "password";
          bullet_image = Image.Text("*", 1, 1, 1);
          prompt_image = Image.Text(prompt, 1, 1, 1);

          bullet_string = "";
          for (i = 0; i < bullets; i++) {
              bullet_string += "*";
          }

          if (bullet_string) {
              bullet_message = Image.Text(bullet_string, 1, 1, 1);
          } else {
              bullet_message = Image.Text("", 0, 0, 0);
          }

          message_sprite.SetImage(prompt_image);
          message_sprite.SetPosition(Window.GetWidth() / 2 - prompt_image.GetWidth() / 2,
                                    Window.GetHeight() * 0.9);
      }

      fun display_message_callback(text) {
          global.status = "message";
          message_image = Image.Text(text, 1, 1, 1);
          message_sprite.SetImage(message_image);
          message_sprite.SetPosition(Window.GetWidth() / 2 - message_image.GetWidth() / 2,
                                    Window.GetHeight() * 0.9);
      }

      Plymouth.SetDisplayNormalFunction(display_normal_callback);
      Plymouth.SetDisplayPasswordFunction(display_password_callback);
      Plymouth.SetMessageFunction(display_message_callback);

      # Quit callback
      fun quit_callback() {
      }

      Plymouth.SetQuitFunction(quit_callback);

      # Refresh callback
      fun refresh_callback() {
      }

      Plymouth.SetRefreshFunction(refresh_callback);
      EOF
    '';

    meta = with lib; {
      description = "Sanatana Linux Plymouth theme";
      license = licenses.gpl3Plus;
      platforms = platforms.linux;
    };
  };
in {
  options.modules.system.plymouth = {
    enable = mkEnableOption "Sanatana Linux Plymouth theme";

    disableStylelix = mkOption {
      type = types.bool;
      default = true;
      description = "Disable Stylix Plymouth theming when this theme is enabled";
    };
  };

  config = mkIf cfg.enable {
    # Disable Stylix Plymouth theming if requested
    stylix.targets.plymouth.enable = mkIf cfg.disableStylelix (mkForce false);

    boot.plymouth = {
      enable = true;
      theme = "sanatana";
      themePackages = [sanatanaTheme];
    };

    # Ensure Plymouth is available in the environment
    environment.systemPackages = with pkgs; [
      plymouth
      sanatanaTheme
    ];
  };
}
