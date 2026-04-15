{
  lib,
  fetchFromGitHub,
  writeText,
  stdenv,
}:
stdenv.mkDerivation rec {
  pname = "lightdm-webkit-theme-litarvan-sanatana";
  version = "unstable-2023-03-10";

  src = fetchFromGitHub {
    owner = "dragonfly1033";
    repo = "lightdm-webkit-theme-litarvan";
    rev = "e4e977239156f415a8e1c511317bcf73cfb4015f";
    hash = "sha256-03ttvg+w2Ikh/FfX0fgeL/KTy+C2DRaBXMwfMB+cppw=";
  };

  # MonokaiPro Spectrum color scheme
  customColors = writeText "monokai-pro-spectrum.css" ''
    :root {
      /* MonokaiPro Spectrum Color Scheme */
      --bg-primary: #131313;      /* base00 - Default Background */
      --bg-secondary: #191919;    /* base01 - Lighter Background */
      --bg-selection: #222222;    /* base02 - Selection Background */
      --fg-comment: #69676c;      /* base03 - Comments, Invisible */
      --fg-light: #8b888f;        /* base04 - Light Foreground */
      --fg-primary: #bab6c0;      /* base05 - Default Foreground */
      --fg-accent: #f7f1ff;       /* base06 - Light Accent Foreground */
      --fg-bright: #f7f1ff;       /* base07 - Bright Accent Foreground */
      --color-red: #fc618d;       /* base08 - Red */
      --color-orange: #fd9353;    /* base09 - Orange */
      --color-yellow: #fce566;    /* base0A - Yellow */
      --color-green: #7bd88f;     /* base0B - Green */
      --color-cyan: #5ad4e6;      /* base0C - Cyan */
      --color-blue: #948ae3;      /* base0D - Blue */
      --color-magenta: #948ae3;   /* base0E - Magenta */
      --color-brown: #fd9353;     /* base0F - Brown */
    }

    /* Override existing theme colors with MonokaiPro Spectrum */
    body {
      background-color: var(--bg-primary) !important;
      color: var(--fg-primary) !important;
    }

    /* Login panel styling */
    .main-container {
      background-color: rgba(25, 25, 25, 0.95) !important;
      border: 1px solid var(--color-blue) !important;
      border-radius: 12px !important;
      backdrop-filter: blur(10px) !important;
      box-shadow: 0 8px 32px rgba(0, 0, 0, 0.6) !important;
    }

    /* Input fields */
    input[type="text"], input[type="password"] {
      background-color: var(--bg-secondary) !important;
      border: 1px solid var(--color-blue) !important;
      color: var(--fg-primary) !important;
      border-radius: 6px !important;
      transition: all 0.3s ease !important;
    }

    input[type="text"]:focus, input[type="password"]:focus {
      border-color: var(--color-cyan) !important;
      box-shadow: 0 0 8px rgba(90, 212, 230, 0.3) !important;
      outline: none !important;
    }

    /* Login button */
    .login-button, button {
      background: linear-gradient(135deg, var(--color-blue), var(--color-magenta)) !important;
      border: none !important;
      color: var(--fg-bright) !important;
      border-radius: 6px !important;
      transition: all 0.3s ease !important;
    }

    .login-button:hover, button:hover {
      background: linear-gradient(135deg, var(--color-cyan), var(--color-blue)) !important;
      transform: translateY(-2px) !important;
      box-shadow: 0 4px 12px rgba(148, 138, 227, 0.4) !important;
    }

    /* Session selector */
    .session-container, .session-list {
      background-color: var(--bg-secondary) !important;
      border: 1px solid var(--color-blue) !important;
      border-radius: 6px !important;
    }

    /* User info and avatar container */
    .user-info, .user-avatar-container {
      color: var(--fg-primary) !important;
    }

    /* Username and hostname */
    .username, .hostname {
      color: var(--fg-accent) !important;
      font-weight: 600 !important;
    }

    /* Date and time */
    .date-time {
      color: var(--fg-light) !important;
    }

    /* Error messages */
    .error-message {
      color: var(--color-red) !important;
      background-color: rgba(252, 97, 141, 0.1) !important;
      border: 1px solid var(--color-red) !important;
      border-radius: 6px !important;
      padding: 8px !important;
    }

    /* Power options */
    .power-options button {
      background-color: var(--bg-secondary) !important;
      border: 1px solid var(--fg-comment) !important;
      color: var(--fg-primary) !important;
      border-radius: 6px !important;
    }

    .power-options button:hover {
      background-color: var(--color-red) !important;
      border-color: var(--color-red) !important;
      color: var(--fg-bright) !important;
    }

    /* Loading animations */
    .loading, .spinner {
      border-color: var(--color-cyan) !important;
    }
  '';

  # Copy sanatana logo for user avatar
  sanatanaLogo = ../.github/assets/sanatana-linux-icon.png;

  installPhase = ''
    runHook preInstall

    install -d $out

    # Copy source files to output
    cp -r $src/* $out/

    # Inject custom MonokaiPro colors
    echo "Injecting MonokaiPro Spectrum color scheme..."

    # Find and modify CSS files
    find $out -name "*.css" -type f | while read cssfile; do
      echo "Modifying CSS file: $cssfile"
      # Prepend our custom colors to the CSS file
      {
        cat ${customColors}
        echo ""
        cat "$cssfile"
      } > "$cssfile.tmp"
      mv "$cssfile.tmp" "$cssfile"
    done

    # Add custom CSS file if no CSS files were found
    if [ ! -f $out/css/index.*.css ] && [ ! -f $out/index.css ]; then
      echo "No CSS files found, creating custom stylesheet..."
      mkdir -p $out/css
      cp ${customColors} $out/css/monokai-pro-spectrum.css

      # Inject into HTML files
      find $out -name "*.html" -type f | while read htmlfile; do
        echo "Adding custom CSS to HTML file: $htmlfile"
        sed -i 's|</head>|<link rel="stylesheet" href="css/monokai-pro-spectrum.css"></head>|g' "$htmlfile"
      done
    fi

    # Replace user avatar with sanatana logo
    echo "Installing sanatana logo as default user avatar..."

    # Find image directories and copy logo
    for imgdir in images img assets; do
      if [ -d "$out/$imgdir" ]; then
        echo "Copying sanatana logo to $out/$imgdir/"
        cp "${sanatanaLogo}" "$out/$imgdir/default-user.png" 2>/dev/null || true
        cp "${sanatanaLogo}" "$out/$imgdir/user.png" 2>/dev/null || true
        cp "${sanatanaLogo}" "$out/$imgdir/avatar.png" 2>/dev/null || true
        cp "${sanatanaLogo}" "$out/$imgdir/profile.png" 2>/dev/null || true
      fi
    done

    # Create images directory if it doesn't exist
    if [ ! -d "$out/images" ]; then
      mkdir -p "$out/images"
      cp "${sanatanaLogo}" "$out/images/default-user.png"
      cp "${sanatanaLogo}" "$out/images/user.png"
      cp "${sanatanaLogo}" "$out/images/avatar.png"
    fi

    # Modify JavaScript files to use sanatana logo as default avatar
    find $out -name "*.js" -type f | while read jsfile; do
      echo "Updating avatar references in JS file: $jsfile"
      sed -i 's|default_user\.png|default-user.png|g' "$jsfile" 2>/dev/null || true
      sed -i 's|\/usr\/share\/pixmaps\/.*\.png|images\/default-user.png|g' "$jsfile" 2>/dev/null || true
      sed -i 's|user\.face|images\/default-user.png|g' "$jsfile" 2>/dev/null || true
    done

    echo "Theme installation complete!"
    ls -la $out/

    runHook postInstall
  '';

  meta = with lib; {
    description = "Litarvan's LightDM HTML Theme with MonokaiPro Spectrum colors and Sanatana branding";
    homepage = "https://github.com/dragonfly1033/lightdm-webkit-theme-litarvan";
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = [];
  };
}
