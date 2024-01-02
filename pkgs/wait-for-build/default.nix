{ stdenv
, writeShellScriptBin
, nixos-rebuild
, jq
, curl
, ...
}:
let

  wait-for-build-skript = writeShellScriptBin "wait-for-build" ''
    get_status() {
        result=$(${curl}/bin/curl -s https://drone.lounge.rocks/api/repos/alexanderwallau/nix/builds | ${jq}/bin/jq -r '.[0].status')

        if [ "$result" = "success" ]; then
            ${nixos-rebuild}/bin/nixos-rebuild --use-remote-sudo switch --flake .
            return 0

        elif [ "$result" = "failure" ]; then
            echo "❌ Build failed"
            return 0

        elif [ "$result" = "running" ]; then
            echo "🏃 Build still running"
            return 1

        elif [ "$result" = "pending" ]; then
            echo "🕒 Build pending"
            return 1

        else
            echo "🤷‍♂️ Build status unknown"
            return 0

        fi
    }

    until get_status; do
        sleep 5
    done
  '';

in
stdenv.mkDerivation
{

  pname = "wait-for-build";
  version = "0.1.0";

  # Needed if no src is used. Alternatively place script in
  # separate file and include it as src
  dontUnpack = true;

  installPhase = ''
    cp -r ${wait-for-build-skript} $out
  '';
}
