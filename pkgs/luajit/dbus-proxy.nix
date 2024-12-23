{
  luajit,
  luajitPackages,
  fetchFromGitHub,
}:
# ┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┫
luajit.pkgs.buildLuaPackage rec {
  pname = "dbus_proxy";
  version = "0.10.3";
  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "stefano-m";
    repo = "lua-${pname}";
    rev = "v${version}";
    sha256 = "sha256-Yd8TN/vKiqX7NOZyy8OwOnreWS5gdyVMTAjFqoAuces=";
  };

  propagatedBuildInputs = [luajitPackages.lgi];
  buildPhase = ":";

  installPhase = ''
    mkdir -p "$out/share/lua/${luajit.luaversion}"
    cp -r src/${pname} "$out/share/lua/${luajit.luaversion}/"
  '';
}
