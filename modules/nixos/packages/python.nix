{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options.modules.packages.python = {
    enable = mkEnableOption "Python development environment with comprehensive package collection";

    development = mkEnableOption "Python development and linting tools" // {default = true;};
    webDevelopment = mkEnableOption "Web development packages" // {default = true;};
    dataProcessing = mkEnableOption "Data processing and validation packages" // {default = true;};
    systemIntegration = mkEnableOption "System integration and API packages" // {default = true;};
    graphics = mkEnableOption "Graphics and visualization packages" // {default = true;};
  };

  config = mkIf config.modules.packages.python.enable {
    environment.systemPackages = with pkgs;
      [
        # Core Python 3.12 runtime
        python312Full
      ]
      ++ (
        with python312Packages;
          []
          # Development tools
          ++ optionals config.modules.packages.python.development [
            flake8 # Style guide enforcement
            pylint # Static code analysis
            pip-tools # Pip dependency management
            pipx # Install Python applications in isolated environments
            setuptoolsBuildHook
            meson-python # Build backend for Python packages
          ]
          # Web development
          ++ optionals config.modules.packages.python.webDevelopment [
            beautifulsoup4 # HTML/XML parsing
            websockets # WebSocket client and server implementation
            python-dotenv # Environment variable management
          ]
          # Data processing and validation
          ++ optionals config.modules.packages.python.dataProcessing [
            pydantic # Data validation using Python type annotations
            pydantic-core # Core validation logic for pydantic
            levenshtein # Fast computation of Levenshtein distance
            pylatexenc # LaTeX encoding/decoding
          ]
          # System integration and APIs
          ++ optionals config.modules.packages.python.systemIntegration [
            gitpython # Git repository interaction
            gitdb # Git object database
            youtube-transcript-api # YouTube transcript fetching
            playsound # Simple audio playback
          ]
          # Graphics and visualization
          ++ optionals config.modules.packages.python.graphics [
            pycairo # Python bindings for Cairo graphics
            pygobject3 # Python bindings for GObject
            pylatex # LaTeX document generation
          ]
      )
      ++ [
        # External Python tools (not part of python312Packages)
        black # Opinionated code formatter
        ruff # Extremely fast Python linter
        pylint # Static code checker (standalone)
        pipenv # Python development workflow tool
        streamlit # Data science web app framework
        virtualenv # Virtual environment creation
        virtualenv-clone # Clone virtual environments
      ]
      ++ [
        # System libraries required for Python GUI development
        gobject-introspection # Required for PyGObject
      ];
  };
}
