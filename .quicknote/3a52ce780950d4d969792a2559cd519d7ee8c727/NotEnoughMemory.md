# Not Enough Memory on Device

**Problem:** `nixos-rebuild` fails complaining of not having enough available memory on device 

**Solution:** A recent change is likely trying to copy all of some huge mess of files into the nix store, exceeding the device's capacity. Roll back that change or make sure to include surrounding `"` around any values that represent paths.
