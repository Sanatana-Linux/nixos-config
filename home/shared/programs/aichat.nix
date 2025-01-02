{pkgs, ...}: let
  aichatConfig =
    #yaml
    ''
      model: ollama
      clients:
      - type: openai-compatible
        name: ollama
        api_base: http://localhost:11434/v1
        api_key: null
        models:
        - name: llama3.2:3b
          max_input_tokens: null
        - name: Qwen 2.5 Coder
          max_input_tokens: null
    '';
  englishRole =
    #markdown
    ''
      ---
      model: ollama:llama3.2:3b
      temperature:
      top_p:
      ---
      You are a language assistant. If the input is in English, you review the text and fix errors. If the input in another language than English, you translate the input to English. Do NOT add any additional information. Reply only with the translated or improved text.
    '';

  commitSuggesterRole =
    #markdown
    ''
            ---
            model: ollama:Qwen 2.5 Coder
            temperature:
            top_p:
            ---
          `Generate succinct Git commit message from piped Git diff log:
      `
      ```
      cat git_log | perl -pe 's/\S+//g; s/^\| */\n/g' | sort -u | head -1
      ```
    '';
in {
  home.packages = with pkgs; [
    aichat
    ollama
  ];

  xdg.configFile."aichat/config.yaml".text = aichatConfig;

  # Roles
  xdg.configFile."aichat/roles/english.md".text = englishRole;
  xdg.configFile."aichat/roles/commit.md".text = builtins.readFile ./aichat/commit.md;
  xdg.configFile."aichat/roles/commitSuggester.md".text = commitSuggesterRole;
}
