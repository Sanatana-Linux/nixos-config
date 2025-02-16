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
  bashOneLinerRole = ''
         ---
         model: ollama:llama3.2:3b
         temperature:
         top_p:
         ---

    I want you to act as a linux shell expert. You will provide a bash one-liner that meets the
    spcifications I will provide to you. I want you to answer only with code. Do not write explanations.
  '';
  coderRole = ''
       ---
       model: ollama:llama3.2:3b
       temperature:
       top_p:
       ---
    I want you to act as a senior programmer. I want you to answer only with the fenced code block. I want you to add an language identifier to the fenced code block. Do not write explanations.
  '';

  commitSuggesterRole =
    #markdown
    ''
      ---
      model: ollama:huggingface.co/TheBloke/deepseek-coder-33B-instruct-GGUF:latest
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
  xdg.configFile."aichat/roles/bashOneLiner.md".text = bashOneLinerRole;
  xdg.configFile."aichat/roles/coder.md".text = coderRole;
  xdg.configFile."aichat/roles/commit.md".text = builtins.readFile ./aichat/commit.md;
  xdg.configFile."aichat/roles/commitSuggester.md".text = commitSuggesterRole;
}
