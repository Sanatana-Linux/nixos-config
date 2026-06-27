import { tool } from "@opencode-ai/plugin"
import { execSync } from "child_process"

const VALID_ACTIONS = ["build", "switch", "vm", "iso", "check", "dry-build", "dry-activate"] as const
const VALID_HOSTS = ["bagalamukhi", "matangi", "bhairavi", "chhinamasta"]

export default tool({
  description: "Build, switch, or test NixOS configurations via nixos-rebuild and nix build. Supports all 4 hosts, VM testing, ISO building, and flake checks.",
  args: {
    action: tool.schema.string().describe(`Action to perform. Valid: ${VALID_ACTIONS.join(", ")}`),
    host: tool.schema.string().optional().describe(`Target host. Valid: ${VALID_HOSTS.join(", ")}. Default: bhairavi (VM test host)`),
    flake: tool.schema.string().optional().describe("Flake URI (default: .#<host>)"),
    showTrace: tool.schema.boolean().optional().describe("Show full error trace (default: false)"),
    verbose: tool.schema.boolean().optional().describe("Verbose output (default: false)"),
    fast: tool.schema.boolean().optional().describe("Skip building dependencies that are already built (default: false)"),
    extraFlags: tool.schema.string().optional().describe("Additional flags to pass to nixos-rebuild"),
  },
  async execute(args) {
    const host = args.host || "bhairavi"
    const flake = args.flake || `.#${host}`
    const action = args.action || "build"

    if (!VALID_ACTIONS.includes(action as any)) {
      return JSON.stringify({ error: `Invalid action '${action}'. Valid: ${VALID_ACTIONS.join(", ")}` })
    }
    if (!VALID_HOSTS.includes(host)) {
      return JSON.stringify({ error: `Invalid host '${host}'. Valid: ${VALID_HOSTS.join(", ")}` })
    }

    let cmd: string

    switch (action) {
      case "build":
        cmd = `nixos-rebuild build --flake ${flake}`
        break
      case "switch":
        cmd = `sudo nixos-rebuild switch --flake ${flake}`
        break
      case "vm":
        cmd = `nixos-rebuild vm --flake ${flake}`
        break
      case "iso":
        cmd = `nixos-rebuild build --flake ${flake}`
        break
      case "check":
        cmd = `nix flake check`
        break
      case "dry-build":
        cmd = `nixos-rebuild dry-build --flake ${flake}`
        break
      case "dry-activate":
        cmd = `nixos-rebuild dry-activate --flake ${flake}`
        break
      default:
        return JSON.stringify({ error: `Unknown action: ${action}` })
    }

    if (args.showTrace) cmd += " --show-trace"
    if (args.verbose) cmd += " -v"
    if (args.fast) cmd += " --fast"
    if (args.extraFlags) cmd += ` ${args.extraFlags}`

    try {
      const output = execSync(cmd, {
        encoding: "utf-8",
        timeout: 600000, // 10 minutes for Nix builds
        stdio: ["pipe", "pipe", "pipe"],
      })
      return JSON.stringify({
        success: true,
        action,
        host,
        flake,
        output: output.trim(),
        exitCode: 0,
      })
    } catch (e: any) {
      return JSON.stringify({
        success: false,
        action,
        host,
        flake,
        error: e.stderr?.trim() || e.message,
        output: e.stdout?.trim() || "",
        exitCode: e.status || 1,
      })
    }
  },
})
