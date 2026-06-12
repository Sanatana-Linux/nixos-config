import { tool } from "@opencode-ai/plugin"

/**
 * Nix info tool — returns project metadata, host info, and configuration paths for ShizNix.
 */
export default tool({
  name: "nix-info",
  description: "Returns ShizNix project metadata — hosts, paths, flake inputs, and conventions",
  args: {
    host: {
      type: "string",
      description: "Optional host to get specific info for",
      default: ""
    }
  },
  async execute(args, context) {
    const projectInfo = {
      name: "ShizNix",
      language: "nix",
      framework: "nixos",
      buildSystem: "flake",
      hosts: {
        bagalamukhi: {
          user: "tlh",
          gpu: "nvidia+intel-prime",
          desktop: "awesome",
          kernel: "xanmod"
        },
        matangi: {
          user: "smg",
          gpu: "nvidia+intel-prime",
          desktop: "xfce",
          kernel: "xanmod"
        },
        bhairavi: {
          user: "tlh",
          gpu: "modesetting",
          desktop: "awesome",
          kernel: "xanmod"
        },
        chhinamasta: {
          user: "user",
          gpu: "intel",
          desktop: "awesome",
          kernel: "xanmod"
        }
      },
      directories: {
        nixosModules: "modules/nixos/",
        homeManagerModules: "modules/home-manager/",
        hosts: "hosts/",
        home: "home/",
        pkgs: "pkgs/",
        overlays: "overlays/"
      },
      buildCommands: {
        format: "alejandra .",
        check: "nix flake check",
        build: "nixos-rebuild build --flake .#<host>",
        switch: "sudo nixos-rebuild switch --flake .#<host>",
        vm: "nixos-rebuild vm --flake .#bhairavi"
      },
      conventions: {
        modulePattern: "enable-by-option with mkIf guard",
        stateVersion: "24.11 (set once, never change)",
        externalDir: "git submodules — do not modify directly",
        styling: "Stylix with Monokai Pro Spectrum base16"
      }
    }

    // If a host was requested, return only that host's info
    if (args.host && args.host in projectInfo.hosts) {
      return {
        project: projectInfo.name,
        host: args.host,
        config: projectInfo.hosts[args.host as keyof typeof projectInfo.hosts],
        directories: projectInfo.directories,
        buildCommands: projectInfo.buildCommands
      }
    }

    return projectInfo
  }
})