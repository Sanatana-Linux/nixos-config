# Bitwarden browser extension, repacked so it never probes for or contacts the
# Bitwarden desktop app.
#
# Upstream reaches the desktop app over native messaging (`com.8bit.bitwarden`,
# an optional permission). When no host is registered every connection attempt
# fails and the extension retries on a 10 s timer, which keeps a failing IPC
# path hot for no benefit. Three entry points are disabled here instead of
# installing bitwarden-desktop just to keep the extension quiet:
#
#   permissionsGranted()                     always false — the "native
#                                            messaging not granted" state the
#                                            extension already handles cleanly
#   nativeMessagingBackground.startConnecting()  retry timer never starts
#   SDK-IPC service init()                   reconnect timer never starts
#
# Vault, sync, autofill and passkeys are untouched.
#
# NOTE: this yields an unsigned XPI. It only loads in a Firefox built with
# `enableAddonSigning = false` (Nightly, or `pkgs.firefox.override
# { enableAddonSigning = false; }`), because nixpkgs' release Firefox defines
# MOZ_REQUIRE_SIGNING at build time and then ignores
# `xpinstall.signatures.required`.
{
  lib,
  stdenv,
  unzip,
  zip,
  jq,
  src,
}:
stdenv.mkDerivation {
  pname = "bitwarden-xpi-nodesktop";

  inherit src;

  nativeBuildInputs = [unzip zip jq];

  # Upstream layout: share/mozilla/extensions/<firefox-app-id>/<addon-guid>.xpi
  # home-manager reads exactly that path out of each `extensions.packages`
  # entry, so the repacked XPI is written back to the same place.
  unpackPhase = ''
    runHook preUnpack
    mkdir -p unpacked
    cd unpacked
    unzip -q "$(find "$src" -name '*.xpi' -print -quit)"
    runHook postUnpack
  '';

  buildPhase = ''
    runHook preBuild

    # Native messaging is the only channel to the desktop app; close it at the
    # permission gate and stop both timers that would retry it.
    substituteInPlace background.js \
      --replace-fail 'static permissionsGranted(e){return JM(this,void 0,void 0,function*(){return new Promise(t=>chrome.permissions.contains({permissions:e},e=>t(e)))})}' \
                     'static permissionsGranted(e){return Promise.resolve(!1)}' \
      --replace-fail 'startConnecting(){' \
                     'startConnecting(){return;' \
      --replace-fail 'init(){this.startReconnectTimer()}' \
                     'init(){}'

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    extDir="$out/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}"
    addonId=$(jq -r '.browser_specific_settings.gecko.id' manifest.json)
    mkdir -p "$extDir"
    zip -q -r -X "$extDir/$addonId.xpi" .

    runHook postInstall
  '';

  meta = {
    description = "Bitwarden browser extension with desktop-app integration disabled";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.all;
  };
}
