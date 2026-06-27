import { tool } from "@opencode-ai/plugin"
import { execSync } from "child_process"

const VALID_ACTIONS = ["update", "update-input", "lock", "check", "show", "list-inputs", "metadata"] as const

export default tool({
  description: "Manage Nix flakes — update inputs, lock flake, check evaluation, show metadata. Wraps nix flake commands for the ShizNix project.",
  args: {
    action: tool.schema.string().describe(`Action to perform. Valid: ${VALID_ACTIONS.join(", ")}`),
    input: tool.schema.string().optional().describe("Input name to update (for update-input action, e.g. 'stylix', 'home-manager')"),
    flake: tool.schema.string().optional().describe("Flake URI (default: '.')"),
    commit: tool.schema.boolean().optional().describe("Commit the updated flake.lock (default: false)"),
    commitMessage: tool.schema.string().optional().describe("Custom commit message for the lock update"),
    showTrace: tool.schema.boolean().optional().describe("Show full error trace (default: false)"),
    extraFlags: tool.schema.string().optional().describe("Additional flags to pass to nix flake"),
  },
  async execute(args) {
    const flake = args.flake || "."
    const action = args.action || "check"

    if (!VALID_ACTIONS.includes(action as any)) {
      return JSON.stringify({ error: `Invalid action '${action}'. Valid: ${VALID_ACTIONS.join(", ")}` })
    }

    let cmd: string

    switch (action) {
      case "update":
        cmd = `nix flake update ${flake}`
        break
      case "update-input":
        if (!args.input) return JSON.stringify({ error: "input is required for update-input action" })
        cmd = `nix flake lock --update-input ${args.input} ${flake}`
        break
      case "lock":
        cmd = `nix flake lock ${flake}`
        break
      case "check":
        cmd = `nix flake check ${flake}`
        break
      case "show":
        cmd = `nix flake show ${flake}`
        break
      case "list-inputs":
        cmd = `nix flake metadata ${flake} --json`
        break
      case "metadata":
        cmd = `nix flake metadata ${flake}`
        break
      default:
        return JSON.stringify({ error: `Unknown action: ${action}` })
    }

    if (args.showTrace) cmd += " --show-trace"
    if (args.extraFlags) cmd += ` ${args.extraFlags}`

    try {
      const output = execSync(cmd, {
        encoding: "utf-8",
        timeout: 300000, // 5 minutes
        stdio: ["pipe", "pipe", "pipe"],
      })

      let parsed: any = { success: true, action, flake, output: output.trim(), exitCode: 0 }

      // If list-inputs with --json, parse the JSON
      if (action === "list-inputs") {
        try {
          const meta = JSON.parse(output)
          parsed.inputs = meta.locks?.nodes
            ? Object.entries(meta.locks.nodes)
                .filter(([key]) => key !== "root")
                .map(([key, val]: [string, any]) => ({
                  name: key,
                  original: val.original?.url || val.locked?.url || "unknown",
                  resolved: val.locked?.url || "unknown",
                  revision: val.locked?.rev || "unknown",
                }))
            : []
        } catch {}
      }

      return JSON.stringify(parsed)
    } catch (e: any) {
      return JSON.stringify({
        success: false,
        action,
        flake,
        error: e.stderr?.trim() || e.message,
        output: e.stdout?.trim() || "",
        exitCode: e.status || 1,
      })
    }
  },
})
