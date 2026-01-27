{pkgs, ...}:
with pkgs;
  [
    (python312.withPackages (p:
      with p; [
        beautifulsoup4 # HTML/XML parsing library
        brotlicffi # Python CFFI bindings for Brotli
        brotlipy # Python bindings for Brotli compression
        cairocffi # CFFI-based bindings for Cairo
        flake8 # Python linting tool
        gitdb # Git object database
        gitpython # Python library for Git interactions
        levenshtein # Fast computation of Levenshtein distance
        meson # Meson build system Python module
        meson-python # Meson Python build backend
        pip # Python package installer
        pip-tools # Tools for managing pip requirements
        pipx # Install and run Python applications in isolated environments
        playsound # Simple audio playback library
        protobuf # Protocol Buffers Python library
        pycairo # Python bindings for Cairo graphics library
        pydantic # Data validation using Python type hints
        pydantic-core # Core functionality for Pydantic
        pygobject3 # Python bindings for GObject Introspection
        pyicu # Python extension wrapping ICU C++ API
        pylatex # Python library for creating LaTeX documents
        pylatexenc # LaTeX encoding/decoding utilities
        pylev # Pure Python Levenshtein implementation
        pylint # Python code static checker
        pylint-venv # Pylint plugin for virtual environments
        pylsp-mypy # Mypy plugin for Python LSP
        python-dotenv # Read key-value pairs from .env files
        python-lsp-server # Python Language Server Protocol implementation
        pyxdg # Python library for XDG standards
        setuptoolsBuildHook # Build hook for setuptools
        smmap # Pure Python sliding window memory map manager
        sortedcontainers # Sorted collections library
        typecode-libmagic # Type and MIME identification using libmagic
        venvShellHook # Shell hook for virtual environments
        websockets # WebSocket client and server library
        wheel # Built-package format for Python
        wheelUnpackHook # Build hook for unpacking wheels
        youtube-transcript-api # Python API for YouTube transcripts
      ]))
  ]
  ++ [
    black # Opinionated Python code formatter
    gobject-introspection # Middleware for C library bindings to GObject
    pipenv # Python development workflow tool
    pylint # Python code static checker
    ruff # Fast Python linter
    streamlit # App framework for data science
    virtualenv # Virtual Python environment builder
    virtualenv-clone # Clone virtual environments
  ]
