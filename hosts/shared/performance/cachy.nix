{inputs, ...}: {
  imports = [inputs.cachy-tweaks.nixosModules.default];

  cachy = {
    enable = true;
    all = true;
  };
}
