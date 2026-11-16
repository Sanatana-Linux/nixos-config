{inputs, ...}: {
  modifications = final: prev: {
    # Handle IOError on sysfs reads gracefully — firmware WMI failures return EINVAL
    # for features like rapidcharge, cpu_oc, power limits that the BIOS doesn't fully implement
    lenovo-legion = prev.lenovo-legion.overrideAttrs (old: {
      postPatch =
        (old.postPatch or "")
        + ''
                  # Don't crash the GUI when sysfs reads fail — some features exist but the EC
                  # returns EINVAL (Errno 22) because the BIOS doesn't fully implement the WMI method
                  ${final.python313.interpreter} -c "
          import re
          with open('./legion_linux/legion.py') as f:
              content = f.read()
          # Wrap _read_file_int in try/except
          old = '    def _read_file_int(self, file_path) -> int:\\n        return int(self._read_file_str(file_path))'
          new = '    def _read_file_int(self, file_path) -> int:\\n        try:\\n            return int(self._read_file_str(file_path))\\n        except (IOError, ValueError):\\n            log.warning("Feature _read_file_int failed for %s, returning 0", file_path)\\n            return 0'
          content = content.replace(old, new)
          with open('./legion_linux/legion.py', 'w') as f:
              f.write(content)
          "
        '';
    });
  };
}
