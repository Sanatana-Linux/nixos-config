{
  lib,
  stdenvNoCC,
  bun,
  fetchFromGitHub,
  makeBinaryWrapper,
  models-dev,
  nodejs,
  ripgrep,
  installShellFiles,
  writableTmpDirAsHomeHook,
  versionCheckHook,
}: let
  version = "1.17.9";

  src = fetchFromGitHub {
    owner = "anomalyco";
    repo = "opencode";
    rev = "v${version}";
    hash = "sha256-OWfI2dp0PeNShVZMzEdm69EtxWX7UwmyPmX02SfrjP8=";
  };

  patches = [
    ./remove-skills-slashname.patch
    ./remove-share-slash.patch
    ./remove-init-command.patch
    ./bun-version-warn.patch
  ];
in
  stdenvNoCC.mkDerivation (finalAttrs: {
    pname = "opencode";
    inherit version src patches;

    __structuredAttrs = true;
    strictDeps = true;

    # Fixed-output sub-derivation: downloads npm dependencies with network access
    node_modules = stdenvNoCC.mkDerivation {
      pname = "${finalAttrs.pname}-node_modules";
      inherit (finalAttrs) version src patches;

      __structuredAttrs = true;

      impureEnvVars =
        lib.fetchers.proxyImpureEnvVars
        ++ [
          "GIT_PROXY_COMMAND"
          "SOCKS_SERVER"
        ];

      nativeBuildInputs = [
        bun
        writableTmpDirAsHomeHook
      ];

      dontConfigure = true;

      buildPhase = ''
        runHook preBuild

        export BUN_INSTALL_CACHE_DIR=$(mktemp -d)
        bun install \
          --frozen-lockfile \
          --filter ./ \
          --filter ./packages/app \
          --filter ./packages/desktop \
          --filter ./packages/opencode \
          --filter ./packages/shared \
          --filter ./packages/tui \
          --ignore-scripts \
          --no-progress

        bun --bun ./nix/scripts/canonicalize-node-modules.ts
        bun --bun ./nix/scripts/normalize-bun-binaries.ts

        runHook postBuild
      '';

      installPhase = ''
        runHook preInstall
        mkdir -p $out
        find . -type d -name node_modules -exec cp -R --parents {} $out \;
        runHook postInstall
      '';

      dontFixup = true;

      outputHash = "sha256-ERywlcNEF9EUW3JDGH8987g+GAj76RylUtegqMvStyg=";
      outputHashAlgo = "sha256";
      outputHashMode = "recursive";
    };

    nativeBuildInputs = [
      bun
      nodejs
      installShellFiles
      makeBinaryWrapper
      writableTmpDirAsHomeHook
    ];

    configurePhase = ''
      runHook preConfigure
      cp -R ${finalAttrs.node_modules}/. .
      patchShebangs node_modules
      patchShebangs packages/*/node_modules
      runHook postConfigure
    '';

    env.MODELS_DEV_API_JSON = "${models-dev}/dist/_api.json";
    env.OPENCODE_DISABLE_MODELS_FETCH = true;
    env.OPENCODE_VERSION = finalAttrs.version;
    env.OPENCODE_CHANNEL = "stable";

    buildPhase = ''
      runHook preBuild
      cd packages/opencode
      bun --bun ./script/build.ts --single --skip-install
      bun --bun ./script/schema.ts config.json tui.json
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      install -Dm755 dist/opencode-*/bin/opencode $out/bin/opencode
      wrapProgram $out/bin/opencode \
        --prefix PATH : ${lib.makeBinPath [ripgrep]} \
        --set OPENCODE_DISABLE_AUTOUPDATE true
      install -Dm644 config.json $out/share/opencode/config.json
      install -Dm644 tui.json $out/share/opencode/tui.json
      runHook postInstall
    '';

    postInstall = lib.optionalString (stdenvNoCC.buildPlatform.canExecute stdenvNoCC.hostPlatform) ''
      installShellCompletion --cmd opencode \
        --bash <($out/bin/opencode completion) \
        --zsh <(SHELL=/bin/zsh $out/bin/opencode completion)
    '';

    nativeInstallCheckInputs = [
      versionCheckHook
      writableTmpDirAsHomeHook
    ];
    doInstallCheck = true;
    versionCheckKeepEnvironment = [
      "HOME"
      "OPENCODE_DISABLE_MODELS_FETCH"
    ];
    versionCheckProgramArg = "--version";

    passthru = {
      jsonschema = {
        config = "${placeholder "out"}/share/opencode/config.json";
        tui = "${placeholder "out"}/share/opencode/tui.json";
      };
    };

    meta = {
      description = "AI coding agent built for the terminal";
      homepage = "https://github.com/anomalyco/opencode";
      license = lib.licenses.mit;
      maintainers = [];
      sourceProvenance = with lib.sourceTypes; [fromSource];
      platforms = [
        "aarch64-linux"
        "x86_64-linux"
        "aarch64-darwin"
      ];
      mainProgram = "opencode";
    };
  })
