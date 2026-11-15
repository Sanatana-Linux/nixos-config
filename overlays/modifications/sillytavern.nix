{inputs, ...}: {
  modifications = final: prev: {
    # SillyTavern is tracked from the upstream `staging` branch — the server's
    # development branch, which is always ahead of the newest release tag — so the
    # package builds current upstream instead of a frozen snapshot.
    #
    # Nix pins sources by content, so the branch is captured as `rev = "staging"`
    # plus the hash of whichever commit the branch pointed at when that hash was
    # computed. To move to the current head:
    #
    #   nix hash convert --from nix32 --to sri --hash-algo sha256 \
    #     "$(nix-prefetch-url --unpack --type base32 \
    #        https://github.com/SillyTavern/SillyTavern/archive/refs/heads/staging.tar.gz)"
    #
    # A staging bump that touches package-lock.json also changes the `npmDeps` hash
    # below; build once and copy the value Nix reports for the new source.
    sillytavern = prev.sillytavern.overrideAttrs (oldAttrs: rec {
      pname = "sillytavern";
      # Staging is unreleased work with no release version to name, so the build is
      # identified by its source hash rather than a hand-maintained version string.
      version = "unstable";
      src = final.fetchFromGitHub {
        owner = "SillyTavern";
        repo = "SillyTavern";
        rev = "staging";
        hash = "sha256-YR9+FpG7F4ypgQNYEYzb8PoITGZnbSihLytwKozpn24=";
      };
      # `npmDepsHash` cannot be overridden here: the upstream package already
      # instantiated its fetchNpmDeps derivation during evaluation, so only replacing
      # `npmDeps` itself re-resolves the hash against this `src`.
      npmDeps = final.fetchNpmDeps {
        inherit src;
        hash = "sha256-wAVmQuchjDXh7sTj8Q7+bJJoYCi7JdvlEeC5G9VtjMU=";
      };

      # Upstream hardcodes plugins to <serverDirectory>/plugins (read-only in Nix store),
      # so user-installed plugins in ~/.local/share/SillyTavern/plugins are never loaded.
      # Patch to load from the built-in store dir AND the user plugins dir.
      postPatch =
        (oldAttrs.postPatch or "")
        + ''
          ${final.python313.interpreter} - <<'PYTHON'
          from pathlib import Path

          path = Path("src/server-main.js")
          text = path.read_text()

          old_import = "import path from 'node:path';"
          if old_import not in text:
              raise SystemExit("server-main.js: expected node:path import not found")
          if "import os from 'node:os';" not in text:
              text = text.replace(old_import, old_import + "\nimport os from 'node:os';", 1)

          old_block = """    const pluginsDirectory = path.join(serverDirectory, 'plugins');
              const cleanupPlugins = await loadPlugins(app, pluginsDirectory);"""

          new_block = """    const builtInPluginsDirectory = path.join(serverDirectory, 'plugins');
              const userPluginsDirectory = process.env.SILLYTAVERN_PLUGINS_PATH
                  || path.join(process.env.XDG_DATA_HOME || path.join(os.homedir(), '.local', 'share'), 'SillyTavern', 'plugins');
              // Load user plugins first so they take precedence over baked-in store plugins.
              const pluginDirectories = [userPluginsDirectory, builtInPluginsDirectory]
                  .filter((dir, i, arr) => dir && arr.indexOf(dir) === i);
              const cleanupPluginFns = [];
              for (const pluginsDirectory of pluginDirectories) {
                  const cleanup = await loadPlugins(app, pluginsDirectory);
                  if (typeof cleanup === 'function') {
                      cleanupPluginFns.push(cleanup);
                  }
              }
              const cleanupPlugins = async () => {
                  await Promise.all(cleanupPluginFns.map(fn => fn()));
              };"""

          if old_block not in text:
              raise SystemExit("server-main.js: expected plugins loading block not found")
          text = text.replace(old_block, new_block)

          path.write_text(text)
          PYTHON
        '';

      postInstall = oldAttrs.postInstall or "";
    });
  };
}
