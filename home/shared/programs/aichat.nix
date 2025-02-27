{pkgs, ...}: let
  aichatConfig =
    #yaml
    ''
      stream: true                     # Controls whether to use the stream-style API.
      save: true                       # Indicates whether to persist the message
      editor: nvim                     # Specifies the command used to edit input buffer or session.yaml. env: EDITOR
      wrap: auto                         # Controls text wrapping (no, auto, <max-width>)
      wrap_code: true
      # Visit https://github.com/sigoden/llm-functions for setup instructions
      function_calling: true           # Enables or disables function calling (Globally).
      mapping_tools:                   # Alias for a tool or toolset
         fs: 'fs_cat,fs_ls,fs_mkdir,fs_rm,fs_write'
      use_tools: fts,web_search # Enables or disables wrapping of code blocks
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
          - name: huggingface.co/TheBloke/deepseek-coder-33B-instruct-GGUF:latest
            max_input_tokens: null
          - name: deepseek-r1:14b
            max_input_tokens: null
          - name: granite3-dense:8b
            max_input_tokens: null
          - name: zephyr:7b
            max_input_tokens: null
          - name: nemotron-mini:4b
            max_input_tokens: null


    '';
  english_role =
    #markdown
    ''
      ---
      model: ollama:llama3.2:3b
      temperature:
      top_p:
      ---

      You are a language assistant. If the input is in English, you review the text and fix errors. If the input in another language than English, you translate the input to English. Do NOT add any additional information. Reply only with the translated or improved text.
    '';
  bash_one_liner_role = ''
         ---
         model: ollama:llama3.2:3b
         temperature:
         top_p:
         ---

    I want you to act as a linux shell expert. You will provide a bash one-liner that meets the
    spcifications I will provide to you. I want you to answer only with code. Do not write explanations.
  '';
  coder_role = ''
       ---
       model: ollama:llama3.2:3b
       temperature:
       top_p:
       ---
    I want you to act as a senior programmer. I want you to answer only with the fenced code block. I want you to add an language identifier to the fenced code block. Do not write explanations.
  '';

  commit_suggester_role =
    #markdown
    ''
      ---
      model: ollama:granite3-dense:8b
      temperature: 0.9
      top_p:
      ---

      Please provide a concise one-line summary of the changes introduced in this commit. The change
      should follow the Conventional Commits format: `<type>(<scope>): <short summary>`. Do not
      respond with anything other than the commit message(!IMPORTANT) .Here is the
      `git diff -z` output to base your message on:
    '';
  prompt_improver_role = ''
     ---
     model: ollama:deepseek-r1:14b
     temperature: 0.8
     top_p:
     ---
    As a world-clas AI researcher, your task is to improve the generative language model prompt provided in the next message.
    First, organize the information.
    Then, eliminate duplicates.
    Use short and clear sentences, each on their own line.
    Do not remove any roles mentioned and keep the prompt in the second person.
    Consider the user's goal and potential misinterpretations while making improvements.
    After that, provide specific editorial recommendations and reasoning.
    Finally, present the revised prompt, with one sentence per line (no extra whitespace or blank lines).
    The prompt is:
  '';
  prompt_creator_role = ''
     ---
     model: ollama:deepseek-r1:14b
     temperature: 0.8
     top_p:
    ---
     As a world-class AI researcher, your task is to asist the user in creating a system prompt for a the generative language model.
     Consider the user's goal and potential misinterpretations while making improvements.
     Use the language "think step by step" at least once in a relevant place to increase its effectiveness.
     Use unambiguous, concise language in the prompt.
     First, think step by step about the user's request and summarize the requirements.
     Then, present the prompt that accomplishes the goal.
  '';
in {
  home.packages = with pkgs; [
    aichat
    ollama
  ];

  xdg.configFile."aichat/config.yaml".text = aichatConfig;

  # Roles
  xdg.configFile."aichat/roles/english.md".text = english_role;
  xdg.configFile."aichat/roles/bashOneLiner.md".text = bash_one_liner_role;
  xdg.configFile."aichat/roles/prompt_improver_role.md".text = prompt_improver_role;
  xdg.configFile."aichat/roles/prompt_creator_role.md".text = prompt_creator_role;
  xdg.configFile."aichat/roles/coder.md".text = coder_role;
  xdg.configFile."aichat/roles/commit.md".text = builtins.readFile ./aichat/commit.md;
  xdg.configFile."aichat/roles/commitSuggester.md".text = commit_suggester_role;
}
