# NixPak — Runtime Sandboxing for Nix

> Source: https://github.com/nixpak/nixpak | License: EUPL-1.2

Declarative wrapper around [bubblewrap](https://github.com/containers/bubblewrap) for sandboxing Nix-packaged apps (including graphical ones). Think "Flatpak, but for Nix."

## Optional Integrations

- **pasta** — customizable network isolation
- **xdg-dbus-proxy** — D-Bus service access control
- **wayland-proxy-virtwl** — Wayland protocol access control

## Features

- Bind-mount host paths (ro/rw), devices
- Full network isolation
- D-Bus access control
- Flatpak Shim — fools `xdg-desktop-portal` into treating Nix apps as Flatpaks, enabling Document Portal (no need to bind-mount entire `$HOME`)

## Flake Integration

```nix
{
  inputs.nixpak = {
    url = "github:nixpak/nixpak";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = { self, nixpkgs, nixpak }: {
    packages.x86_64-linux = let
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      mkNixPak = nixpak.lib.nixpak { inherit (pkgs) lib; inherit pkgs; };
    in {
      hello = (mkNixPak { config = { sloth, ... }: {
        app.package = pkgs.hello;
        flatpak.appId = "org.myself.HelloApp";
        dbus.enable = true;
        dbus.policies = {
          "org.freedesktop.DBus" = "talk";
          "ca.desrt.dconf" = "talk";
        };
        bubblewrap = {
          network = false;
          bind.rw = [
            (sloth.concat' sloth.homeDir "/Documents")
            (sloth.env "XDG_RUNTIME_DIR")
          ];
          bind.ro = [ (sloth.concat' sloth.homeDir "/Downloads") ];
          bind.dev = [ "/dev/dri" ];
        };
      };}).config.script;
    };
  };
}
```

## Sloth Values (lazy runtime resolution)

`sloth` attrset is available in module config. Values resolve at runtime, not eval time.

| Function | Signature | Purpose |
|----------|-----------|---------|
| `sloth.env` | `string -> Sloth` | Resolve env var at runtime |
| `sloth.mkdir` | `Sloth -> Sloth` | Ensure dir exists (mkdir -p, 0700) |
| `sloth.concat` | `[Sloth] -> Sloth` | Concat sloth values |
| `sloth.concat'` | `Sloth -> Sloth -> Sloth` | Concat two sloth values |
| `sloth.instanceId` | `Sloth` | Unique ID from launcher PID |
| `sloth.uid` | `Sloth` | UID at runtime |
| `sloth.gid` | `Sloth` | GID at runtime |
| `sloth.homeDir` | `Sloth` | `$HOME` at runtime |

### Examples

```nix
sloth.env "HOME"                                    # "/home/user"
sloth.mkdir (sloth.env "MY_CACHE_DIRECTORY")        # mkdir -p, then return value
sloth.concat [ sloth.homeDir "/.config" ]           # "/home/user/.config"
sloth.concat' sloth.homeDir "/.config"              # same, shorter
sloth.concat [ (sloth.env "XDG_RUNTIME_DIR") "/my-app-" sloth.instanceId ]
# "/run/user/1000/my-app-jim1rivq0gblz0vn6k32wgv7aq"
```

## Outputs

| Attribute | Description |
|-----------|-------------|
| `config.script` | Wrapped `/bin/<mainProgram>` binary |
| `config.env` | symlinkJoin resembling original package with wrapper swapped in (for GUI apps; fixes D-Bus service file references) |

## Key Config Fields

| Field | Purpose |
|-------|---------|
| `app.package` | Package to isolate |
| `app.binPath` | Path to executable (auto-detected usually) |
| `flatpak.appId` | Required for Flatpak emulation; defaults to `com.nixpak.<Name>` |
| `dbus.enable` | Enable xdg-dbus-proxy integration |
| `dbus.policies` | Per-service `see`/`talk`/`own` like Flatpak |
| `bubblewrap.network` | `false` disables all network |
| `bubblewrap.bind.rw` | Host paths mounted read-write |
| `bubblewrap.bind.ro` | Host paths mounted read-only |
| `bubblewrap.bind.dev` | Device nodes to bind-mount (e.g. `/dev/dri`) |
