# Annoying Permissions Errors

**Problem:** during rebuilds, rebuild would fail if not invoked using doas/sudo and using such it would complain the current user did not own the $HOME/.cache/nix/tarball-cache directory requiring the root to own a user directory, which makes zero sense to actually implement and caused other transient issues to emerge.

**Solution:** adding `--use-remote-sudo** in the `nixos-rebuild` command and running as the regular user. Now added to the `om` wrapper. 
