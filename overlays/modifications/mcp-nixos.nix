{inputs, ...}: {
  modifications = final: prev: let
    # Import stable nixpkgs for pinned Python packages
    stable-pkgs = import inputs.stable {
      system = final.stdenv.hostPlatform.system;
      config = {
        allowUnfree = true;
        permittedInsecurePackages = ["electron-39.8.10"];
      };
    };
  in {
    # fastmcp-slim is marked broken on unstable while upstream fastmcp is not
    # yet compatible with mcp 2.x, which makes mcp-nixos unevaluable there.
    # The stable channel still pairs mcp 1.x with a working fastmcp, and
    # mcp-nixos is the MCP server OpenCode launches by name, so it must stay
    # on PATH. fastmcp's async proxy tests are flaky in the Nix sandbox, so
    # skip its checks.
    mcp-nixos = stable-pkgs.mcp-nixos.override {
      python3Packages = stable-pkgs.python3Packages.overrideScope (
        _python-final: python-prev: {
          fastmcp = python-prev.fastmcp.overridePythonAttrs (_: {
            doCheck = false;
          });
        }
      );
    };
  };
}
