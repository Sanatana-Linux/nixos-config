{...}: {
  xdg.configFile."aichat/config.yaml".text = ''
    model: ollama
    clients:
    - type: ollama
      api_base: http://localhost:11434
      api_auth: null
      models:
      - name: llama3.2:3b
        max_input_tokens: 8096
      - name: wizard-vicuna-uncensored:latest
        max_input_tokens: 8096
      - name: nemotron-mini:latest
        max_input_tokens: 8096
      - name: codellama:7b
        max_input_tokens: 8096
      - name: codegemma:2b
        max_input_tokens: 8096
      - name: starcoder2:15b
        max_input_tokens: 8096
      - name: mannix/llama3.1-8b-abliterated:latest
        max_input_tokens: 8096
      - name: llama3.3:latest
        max_input_tokens: 8096
  '';

  xdg.configFile."aichat/roles.yaml".text =
    #yaml
    ''
      - name: grammar-genie
        prompt: >
          Your task is to take the text provided and rewrite it into a clear, grammatically correct version while preserving the original meaning as closely as possible. Correct any spelling mistakes, punctuation errors, verb tense issues, word choice problems, and other grammatical mistakes.

    '';
}
