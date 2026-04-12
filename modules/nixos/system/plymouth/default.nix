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
ModuleName=two-step

[two-step]
ImageDir=$out/share/plymouth/themes/sanatana
DialogHorizontalAlignment=.5
DialogVerticalAlignment=.382
TitleHorizontalAlignment=.5
TitleVerticalAlignment=.382
HorizontalAlignment=.5
VerticalAlignment=.5
WatermarkHorizontalAlignment=.5
WatermarkVerticalAlignment=.96
Transition=none
TransitionDuration=0.0
BackgroundStartColor=0x131313
BackgroundEndColor=0x131313
ProgressBarBackgroundColor=0x222222
ProgressBarForegroundColor=0x948ae3
MessageBelowAnimation=true
UseEndAnimation=false

[boot-up]
UseFirmwareBackground=false

[shutdown]
UseFirmwareBackground=false

[reboot]
UseFirmwareBackground=false

[updates]
SuppressMessages=true
ProgressBarShowPercentComplete=true

[system-upgrade]
SuppressMessages=true
ProgressBarShowPercentComplete=true
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

# Progress bar styling
progress_bar.original_image = Image("progress_bar.png");
if (!progress_bar.original_image) {
    # Fallback: create a simple progress bar
    progress_bar.original_image = Image.Text("████████████████████", 1, 1, 1);
}

progress_bar.sprite = Sprite();
progress_bar.x = Window.GetWidth() / 2 - progress_bar.original_image.GetWidth() / 2;
progress_bar.y = Window.GetHeight() * 0.8;
progress_bar.sprite.SetPosition(progress_bar.x, progress_bar.y);

fun progress_callback(duration, progress) {
    if (progress_bar.image.GetWidth() != Math.Int(progress_bar.original_image.GetWidth() * progress)) {
        progress_bar.image = progress_bar.original_image.Scale(
            Math.Int(progress_bar.original_image.GetWidth() * progress), 
            progress_bar.original_image.GetHeight()
        );
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
      themePackages = [ sanatanaTheme ];
    };

    # Ensure Plymouth is available in the environment
    environment.systemPackages = with pkgs; [
      plymouth
      sanatanaTheme
    ];
  };
}