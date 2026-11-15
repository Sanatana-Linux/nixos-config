# Aggregates all overlays: additions, modifications, stable-packages.
# Consumed by hosts via `outputs.overlays.<name>`.
{inputs, ...}: {
  additions = (import ./additions.nix {inherit inputs;}).additions;
  modifications = (import ./modifications {inherit inputs;}).modifications;
  stable-packages = (import ./stable-packages.nix {inherit inputs;}).stable-packages;
}
