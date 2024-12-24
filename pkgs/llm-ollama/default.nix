{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "llm-ollama";
  version = "0.8.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "taketwo";
    repo = "llm-ollama";
    rev = version;
    hash = "sha256-9AgHX2FJRXSKZOLt7JR/9Fg4i2HGNQY2vSsJa4+2BGQ=";
  };

  build-system = [
    python3.pkgs.setuptools
    python3.pkgs.wheel
  ];

  dependencies = with python3.pkgs; [
    llm
    ollama
    pydantic
  ];

  optional-dependencies = with python3.pkgs; {
    lint = [
      black
    ];
    test = [
      pytest
      pytest-asyncio
    ];
  };

  pythonImportsCheck = [
    "llm_ollama"
  ];

  meta = {
    description = "LLM plugin providing access to models running on an Ollama server";
    homepage = "https://github.com/taketwo/llm-ollama";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "llm-ollama";
  };
}
