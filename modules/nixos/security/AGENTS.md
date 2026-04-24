<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-04-21 | Updated: 2026-04-22 -->

# modules/nixos/security/

## Purpose
System security configuration — authentication, access control, firewall, and monitoring. These modules harden the system while maintaining usability for a desktop workstation.

## Key Files

| File | Description |
|------|-------------|
| `default.nix` | Re-exports security submodules |
| `doas.nix` | Doas (sudo alternative) configuration |
| `sudo.nix` | Sudo configuration |
| `firewall.nix` | Firewall rules and ports |
| `fail2ban.nix` | Fail2ban intrusion prevention |
| `pam.nix` | PAM session configuration |
| `ssh.nix` | SSH server configuration |
| `packages.nix` | Security-related packages (gnupg, cryptsetup, etc.) |

## For AI Agents

### Working In This Directory
- Doas is the primary privilege escalation tool; sudo is available as fallback
- Firewall module opens specific ports needed for services — never open all ports
- SSH module configures server settings; keys should eventually use sops-nix or agenix

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->