import { tool } from "@opencode-ai/plugin"
import { execSync } from "child_process"
import * as fs from "fs"
import * as path from "path"

const VALID_ACTIONS = ["format", "check", "format-file", "check-file"] as const

export default tool({
  description: "Format Nix files with alejandra. Supports formatting entire projects, checking formatting, or targeting specific files. Integrates with the ShizNix project's alejandra formatter.",
  args: {
    action: tool.schema.string().describe(`Action to perform. Valid: ${VALID_ACTIONS.join(", ")}`),
    path: tool.schema.string().optional().describe("Path to format or check (default: current directory '.')"),
    file: tool.schema.string().optional().describe("Specific file to format (for format-file/check-file actions)"),
    quiet: tool.schema.boolean().optional().describe("Suppress output except errors (default: false)"),
  },
  async execute(args) {
    const action = args.action || "format"
    const targetPath = args.file || args.path || "."

    if (!VALID_ACTIONS.includes(action as any)) {
      return JSON.stringify({ error: `Invalid action '${action}'. Valid: ${VALID_ACTIONS.join(", ")}` })
    }

    // Verify the target exists
    try {
      fs.accessSync(targetPath)
    } catch {
      return JSON.stringify({ error: `Path does not exist: ${targetPath}` })
    }

    let cmd: string

    switch (action) {
      case "format":
        cmd = `alejandra ${targetPath}`
        break
      case "check":
        cmd = `alejandra --check ${targetPath}`
        break
      case "format-file":
        cmd = `alejandra ${targetPath}`
        break
      case "check-file":
        cmd = `alejandra --check ${targetPath}`
        break
      default:
        return JSON.stringify({ error: `Unknown action: ${action}` })
    }

    if (args.quiet) cmd += " --quiet"

    try {
      const output = execSync(cmd, {
        encoding: "utf-8",
        timeout: 120000, // 2 minutes
        stdio: ["pipe", "pipe", "pipe"],
      })

      const isCheck = action === "check" || action === "check-file"
      const isFormatted = isCheck ? output.trim() === "" : true

      return JSON.stringify({
        success: true,
        action,
        target: targetPath,
        formatted: isFormatted,
        output: output.trim() || (isCheck ? "All files are properly formatted." : "Formatting complete."),
        exitCode: 0,
      })
    } catch (e: any) {
      // alejandra --check exits non-zero when files need formatting
      const stderr = e.stderr?.trim() || ""
      const stdout = e.stdout?.trim() || ""

      if ((action === "check" || action === "check-file") && e.status === 1) {
        return JSON.stringify({
          success: true,
          action,
          target: targetPath,
          formatted: false,
          output: stdout || "Files need formatting.",
          details: stderr,
          exitCode: 1,
        })
      }

      return JSON.stringify({
        success: false,
        action,
        target: targetPath,
        error: stderr || e.message,
        output: stdout,
        exitCode: e.status || 1,
      })
    }
  },
})
