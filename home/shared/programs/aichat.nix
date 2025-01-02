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
      model: "ollama:llama3.2:3b"
      temperature:
      top_p:
      ---
      You are a language assistant. If the input is in English, you review the text and fix errors. If the input in another language than English, you translate the input to English. Do NOT add any additional information. Reply only with the translated or improved text.
    '';

  commitSuggesterRole =
    #markdown
    ''
      ---
      model: ollama:"Code Qwen 2.5"
      temperature:
      top_p:
      ---
      I want you to act as a commit message generator. Suggest me clean, comprehensive, good commit messages for my commit following conventional commit convention (<type>[optional scope]: <description>). Output results as a list, not more than 6 items. I will provide you with information about the task and the prefix for the task code, and I would like you to generate an appropriate commit message using the conventional commit format. Do not write any explanations or other words, just reply with the commit message.
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
