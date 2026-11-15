{inputs, ...}: {
  modifications = final: prev: {
    # pipx and anyio fail their own test suites inside the Nix sandbox: pipx
    # wants a writable venv, anyio's TLS and hypothesis plugins need network.
    # Only the checks fail, never the build, so the tests are skipped rather
    # than patched. Overriding changes the derivation, so these two rebuild
    # locally instead of substituting — keep them scoped to just these two.
    python312Packages = prev.python312Packages.overrideScope (
      _python-final: python-prev:
        python-prev
        // {
          pipx = python-prev.pipx.overridePythonAttrs (_: {
            doCheck = false;
            pythonImportsCheck = ["pipx"];
          });
          anyio = python-prev.anyio.overridePythonAttrs (_: {
            doCheck = false;
          });
          # test_performance asserts the SVG path parser finishes in under
          # 0.1 s. That is a wall-clock assertion, and it fails on a loaded
          # build host (measured 0.26 s with four parallel builds) while all
          # 475 behavioural tests pass.
          svgwrite = python-prev.svgwrite.overridePythonAttrs (_: {
            doCheck = false;
          });
        }
    );
  };
}
