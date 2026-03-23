{
  xdg.configFile = {
    # AI chat configuration with multiple providers
    "aichat/config.toml".text = ''
      model = "mistral:7b"
      temperature = 0.5
      highlight = true
      light_theme = false
      save = true
      keybindings = "vi"
      wrap = "auto"
      wrap_code = false

      [clients.ollama]
      type = "ollama"
      api_base = "http://localhost:11434"
      api_key = ""
      models = [
        { name = "mistral", max_input_tokens = 131072, supports_vision = false },
        { name = "granite:8b-code-instruct", max_input_tokens = 8192 },
        { name = "codegeex4:latest", max_input_tokens = 131072 },
        { name = "deepseek:67b", max_input_tokens = 131072 },
        { name = "mistral-nemo", max_input_tokens = 131072 },
        { name = "huggingface.co/THUDM/codegeex4-all-9b-GGUF:latest", max_input_tokens = 131072 },
        { name = "yi:34b-chat", max_input_tokens = 4096 },
        { name = "yi:6b-chat", max_input_tokens = 4096 },
        { name = "yi:9b-chat", max_input_tokens = 4096 },
        { name = "granite-code:3b-base", max_input_tokens = 4096 },
        { name = "granite-code:8b-base", max_input_tokens = 4096 },
        { name = "granite-code:8b-instruct", max_input_tokens = 4096 },
        { name = "granite-code:20b-base", max_input_tokens = 4096 },
        { name = "granite-code:34b-base", max_input_tokens = 4096 },
        { name = "granite-code:34b-instruct", max_input_tokens = 4096 },
        { name = "snowflake-arctic-embed2", max_input_tokens = 8192, supports_vision = false, type = "embedding" },
      ]

      [clients.gemini]
      type = "gemini"
      api_key = ""
      models = [
        { name = "gemini-2.0-flash-exp", max_input_tokens = 2097152, input_price = 0, output_price = 0 },
        { name = "gemini-2.5-flash-exp", max_input_tokens = 8388608, input_price = 0, output_price = 0 },
        { name = "gemini-exp-1206", max_input_tokens = 2097152, input_price = 0, output_price = 0 },
      ]

      [clients.mistral]
      type = "mistral"
      api_key = ""

      [clients.groq]
      type = "groq"
      api_key = ""
      models = [
        { name = "deepseek-r1-distill-llama-70b", max_input_tokens = 131072, input_price = 0.59, output_price = 0.79 },
      ]

      [rag]
      embedding_model = "ollama:snowflake-arctic-embed2"
      reranker_model = ""
      top_k = 4

      [function_calling]
      declaration = "auto"
    '';
  };
}
