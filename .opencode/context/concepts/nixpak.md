# NixPak — Runtime Sandboxing for Nix

Core concept: NixPak provides declarative sandboxing for Nix-packaged applications using bubblewrap (bwrap). It wraps any Nix package in a sandbox with fine-grained control over filesystem access, networking, D-Bus, and Wayland — combining Nix's declarative approach with Flatpak-style isolation, but without requiring Flatpak itself.

Key Points:
- **Bubblewrap-based sandbox** — uses bwrap for filesystem namespace isolation; config is declarative Nix module system, not imperative JSON like native bwrap
- **Sloth values for runtime paths** — `sloth.env`, `sloth.homeDir`, `sloth.concat'`, `sloth.mkdir`, `sloth.uid`/`sloth.gid` resolve at runtime, avoiding hardcoded paths like `/home/user`
- **D-Bus access control** — via `dbus.enable = true` and `dbus.policies` (talk/see/own), backed by xdg-dbus-proxy. Essential for GUI apps that need D-Bus services
- **Network isolation** — `bubblewrap.network = false` blocks all network; integrate with `pasta` for selective network access
- **Flatpak shim** — `flatpak.appId` makes xdg-desktop-portal treat your app as a Flatpak, enabling Document Portal for file open/save without bind-mounting the entire home directory
- **Two output types** — `config.script` (just the wrapped binary) vs `config.env` (symlinkJoin replacing the binary in the full package env — needed for GUI apps with D-Bus service files)

Example:
```nix
mkNixPak {
  config = { sloth, ... }: {
    app.package = pkgs.firefox;
    app.binPath = "bin/firefox";

    dbus.enable = true;
    dbus.policies = {
      "org.freedesktop.DBus" = "talk";
      "ca.desrt.dconf" = "talk";
    };

    flatpak.appId = "org.mozilla.firefox";

    bubblewrap = {
      network = false;
      bind.rw = [
        (sloth.concat' sloth.homeDir "/Downloads")
        (sloth.env "XDG_RUNTIME_DIR")
      ];
      bind.ro = [
        (sloth.concat' sloth.homeDir "/.config/fontconfig")
      ];
      bind.dev = [ "/dev/dri" ];
    };
  };
}
# Use: config.env for GUI apps, config.script for CLI wrappers
```

Sloth value reference:
- `sloth.env "VAR"` — resolve env var at runtime
- `sloth.homeDir` — user's home directory at runtime
- `sloth.concat' a b` — concatenation
- `sloth.mkdir s` — ensure dir exists (0700)
- `sloth.instanceId` — unique ID from launcher PID
- `sloth.uid` / `sloth.gid` — numeric user/group ID

Reference: [github.com/nixpak/nixpak](https://github.com/nixpak/nixpak)