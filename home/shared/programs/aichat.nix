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
        - name: wizard-vicuna-uncensored:13b
          max_input_tokens: null
        - name: huggingface.co/Novaciano/Llama-3.2-3b-NSFW_Aesir_Uncensored-GGUF:latest
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
      model: ollama:codellama:13b
      temperature: 0.8
      top_p:
      ---

      Please provide a concise summary of the changes introduced in this commit. The change should follow the Conventional Commits format: `<type>(<scope>): <short summary>`. Here is the git diff output for reference:
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
