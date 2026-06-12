import { tool } from "@opencode-ai/plugin"

/**
 * Nix build tool — build, switch, test, or check any ShizNix host configuration.
 */
export default tool({
  name: "nix-build",
  description: "Build, switch, test VM, or validate any ShizNix NixOS host configuration",
  args: {
    host: {
      type: "string",
      description: "Host to build for (bagalamukhi, matangi, bhairavi, chhinamasta)",
      default: "bagalamukhi"
    },
    action: {
      type: "string",
      description: "Build action to perform",
      enum: ["build", "switch", "test", "vm", "check"],
      default: "build"
    },
    dry: {
      type: "boolean",
      description: "Dry-run (print command without executing)",
      default: false
    }
  },
  async execute(args, context) {
    const host = args.host || "bagalamukhi"
    const action = args.action || "build"
    const validHosts = ["bagalamukhi", "matangi", "bhairavi", "chhinamasta"]

    if (!validHosts.includes(host)) {
      return { error: `Invalid host '${host}'. Valid: ${validHosts.join(", ")}` }
    }

    let command: string

    switch (action) {
      case "switch":
        command = `sudo nixos-rebuild switch --flake .#${host}`
        break
      case "test":
        command = `nixos-rebuild test --flake .#${host}`
        break
      case "vm":
        if (host !== "bhairavi") {
          return { error: `VM test only supported on bhairavi host, not '${host}'` }
        }
        command = `nixos-rebuild vm --flake .#${host}`
        break
      case "check":
        command = `nix flake check`
        break
      case "build":
      default:
        command = `nixos-rebuild build --flake .#${host}`
    }

    if (args.dry) {
      return { dry: true, command, host, action }
    }

    return {
      command,
      host,
      action,
      execute: command,
      note: action === "switch" ? "⚠️ Requires sudo — use bash tool" : "Run this command in bash"
    }
  }
})