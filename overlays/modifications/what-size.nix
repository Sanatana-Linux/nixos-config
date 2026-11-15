{inputs, ...}: {
  modifications = final: prev: {
    # yazi plugin that reports file sizes in the preview pane; not in nixpkgs.
    what-size = prev.yaziPlugins.mkYaziPlugin {
      pname = "what-size";
      version = "2025-03-07";
      src = final.fetchFromGitHub {
        owner = "pirafrank";
        repo = "what-size.yazi";
        rev = "main";
        hash = "sha256-7q/45TopqbojNRvYDmP9+hgSGPmiyLHBcV051qpOB2Y=";
      };
    };
  };
}
