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
      use_tools: all # Enables or disables wrapping of code blocks


      # ---- apperence ----
      highlight: true                  # Controls syntax highlighting
      light_theme: false               # Activates a light color theme when true. env: AICHAT_LIGHT_THEME
      # Custom REPL left/right prompts, see https://github.com/sigoden/aichat/wiki/Custom-REPL-Prompt for more details
      left_prompt: '{color.green}{?session {?agent {agent}>}{session}{?role /}}{!session {?agent {agent}>}}{role}{?rag @{rag}}{color.cyan}{?session )}{!session >}{color.reset} '
      right_prompt:  '{color.purple}{?session {?consume_tokens {consume_tokens}({consume_percent}%)}{!consume_tokens {consume_tokens}}}{color.reset}'
      model: ollama:deepseek-r1:14b
      clients:
        - type: openai-compatible
          name: ollama
          api_base: http://localhost:11434/v1
          api_key: null
          models:
          - name: huggingface.co/mradermacher/Arch-Function-7B-GGUF:latest
            supports_function_calling: true
          - name: huggingface.co/QuantFactory/Llama3.2-3B-Enigma-GGUF:latest
          - name: huggingface.co/QuantFactory/OpenCoder-8B-Instruct-GGUF:latest
          - name: huggingface.co/bartowski/suayptalha_Maestro-10B-GGUF:latest
          - name: huggingface.co/DavidAU/L3.1-Dark-Planet-10.7B-ExxxxxxxxTended-GGUF:latest
          - name: granite3.2:latest
            supports_function_calling: true
          - name: huggingface.co/THUDM/codegeex4-all-9b-GGUF:latest
            supports_function_calling: false
          - name: bge-m3:latest
            type: embedding
          - name: snowflake-arctic-embed:latest
            type: embedding
          - name: nomic-embed-text:latest
            type: embedding
          - name: huggingface.co/DavidAU/DeepSeek-MOE-4X8B-R1-Distill-Llama-3.1-Deep-Thinker-Uncensored-24B-GGUF:latest
          - name: huggingface.co/TheBloke/deepseek-coder-33B-instruct-GGUF:latest
          - name: huggingface.co/DavidAU/Mistral-MOE-4X7B-Dark-MultiVerse-Uncensored-Enhanced32-24B-gguf:latest
          - name: huggingface.co/DevQuasar/DevQuasar-R1-Uncensored-Llama-8B-GGUF:latest
          - name: deepseek-r1:14b
            supports_function_calling: false
          - name: llama3.2:3b
          - name: huggingface.co/DavidAU/L3-Grand-Story-Darkness-MOE-4X8-24.9B-e32-GGUF:latest
          - name: huggingface.co/DavidAU/Llama-3.2-4X3B-MOE-Hell-California-Uncensored-10B-GGUF:latest
          - name: huggingface.co/DavidAU/Llama-3.2-8X3B-MOE-Dark-Champion-Instruct-uncensored-abliterated-18.4B-GGUF:latest
          - name: huggingface.co/byroneverson/LongWriter-glm4-9b-abliterated-gguf:latest
          - name: huggingface.co/QuantFactory/DarkIdol-Llama-3.1-8B-Instruct-1.2-Uncensored-GGUF:latest
          - name: nemotron-mini:4b
          - name: wizard-vicuna-uncensored:13b

    '';
  bash_one_liner_role = ''
    ---
    model: ollama:huggingface.co/THUDM/codegeex4-all-9b-GGUF:latest
    ---

    I want you to act as a linux shell expert. You will provide a bash one-liner that meets the
    spcifications I will provide to you. I want you to answer only with code. Do not write explanations.
  '';
  coder_role = ''
    ---
    model: ollama:huggingface.co/THUDM/codegeex4-all-9b-GGUF:latest
    ---
    I want you to act as a senior programmer. I want you to answer only with the fenced code block. I want you to add an language identifier to the fenced code block. Do not write explanations.
  '';
  prompt_improver_role = ''
    As a world-clas AI researcher, your task is to improve the generative language model prompt provided in the next message.
    First, organize the information.
    Then, eliminate duplicates.
    Use short and clear sentences, each on their own line.
    Do not remove any roles mentioned and keep the prompt in the second person.
    Consider the user's goal and potential misinterpretations while making improvements.
    After that, provide specific editorial recommendations and reasoning.
    Finally, present the revised prompt, with one sentence per line (no extra whitespace or blank lines).
    Remember, my next message will be the prompt you are to improve and is intended not for you to follow but for you to actively improve as described above.

    The prompt is:
    ````
  '';
  prompt_creator_role = ''
     ---
     model: ollama:deepseek-r1:14b
     temperature: 0.8
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
  xdg.configFile."aichat/roles/bash_one_liner.md".text = bash_one_liner_role;
  xdg.configFile."aichat/roles/prompt_improver_role.md".text = prompt_improver_role;
  xdg.configFile."aichat/roles/prompt_creator_role.md".text = prompt_creator_role;
  xdg.configFile."aichat/roles/coder.md".text = coder_role;
  xdg.configFile."aichat/roles/commit.md".text = builtins.readFile ./aichat/commit.md;
  xdg.configFile."aichat/roles/system_design.md".text = builtins.readFile ./aichat/system_design.md;
  xdg.configFile."aichat/roles/kb_creator.md".text = builtins.readFile ./aichat/kb_creator.md;
}
