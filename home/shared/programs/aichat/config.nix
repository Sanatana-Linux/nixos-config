{pkgs, ...}: {
  xdg.configFile."aichat/config.yaml".source = pkgs.writers.writeYAML "aichat-config.yaml" {
    # --- Default Model ---
    model = "ollama:mistral-nemo:latest";
    clients = [
      {
        type = "openai-compatible";
        name = "openrouter";
        api_base = "https://openrouter.ai/api/v1";
        models = [
          {
            name = "deepseek/deepseek-chat-v3-0324:free";
            max_input_tokens = 163840; # Added token limit
          }
        ];
      }
      {
        type = "openai-compatible";
        name = "ollama";
        api_base = "http://localhost:11434/v1";
        models = [
          {
            name = "mistral-nemo:latest";
            max_input_tokens = 102400; # Added token limit
          }
          {
            name = "granite3.2:latest";
            max_input_tokens = 131072; # Added token limit
          }
          {
            name = "huggingface.co/mradermacher/Arch-Function-7B-GGUF:latest";
            max_input_tokens = 32768; # Added token limit
          }
          {
            name = "huggingface.co/THUDM/codegeex4-all-9b-GGUF:latest";
            max_input_tokens = 131072; # Added token limit
          }
          {
            name = "devstral:24b";
            max_input_tokens = 131072; # Added token limit
          }
          {
            name = "huggingface.co/bartowski/Dolphin3.0-Llama3.2-3B-GGUF:latest";
            max_input_tokens = 131072; # Added token limit
          }
          {
            name = "huihui_ai/qwen3-abliterated:16b";
            max_input_tokens = 40960; # Added token limit
            supports_function_calling = true;
          }
          {
            name = "huggingface.co/DavidAU/Llama-3.2-8X4B-MOE-V2-Dark-Champion-Instruct-uncensored-abliterated-21B-GGUF:latest";
            max_input_tokens = 131072; # Added token limit
          }
          {
            name = "huggingface.co/DavidAU/Llama-3.2-8X3B-MOE-Dark-Champion-Instruct-uncensored-18.4B-GGUF:latest";
            max_input_tokens = 131072; # Added token limit
          }
          {
            name = "huggingface.co/DavidAU/DeepSeek-MOE-4X8B-R1-Distill-Llama-3.1-Deep-Thinker-Uncensored-24B-GGUF:latest";
            max_input_tokens = 131072; # Added token limit
          }
          {
            name = "huggingface.co/DavidAU/L3-Grand-Story-Darkness-MOE-4X8-24.9B-e32-GGUF:latest";
            max_input_tokens = 131072; # Added token limit
          }
          {
            name = "huggingface.co/DavidAU/Llama-3.2-4X3B-MOE-Hell-California-Uncensored-10B-GGUF:latest";
            max_input_tokens = 131072; # Added token limit
          }
          {
            name = "huggingface.co/DavidAU/MN-WORDSTORM-pt3-RCM-POV-Nightmare-18.5B-Instruct-GGUF:latest";
            max_input_tokens = 131072; # Added token limit
          }
          {
            name = "huggingface.co/DavidAU/Mistral-MOE-4X7B-Dark-MultiVerse-Uncensored-Enhanced32-24B-GGUF:latest";
            max_input_tokens = 131072; # Added token limit
          }
          {
            name = "huggingface.co/byroneverson/LongWriter-glm4-9b-abliterated-GGUF:latest";
            max_input_tokens = 131072; # Added token limit
          }
          {
            name = "huggingface.co/DavidAU/Llama-3.2-8X3B-MOE-Dark-Champion-Instruct-uncensored-abliterated-18.4B-GGUF:latest";
            max_input_tokens = 131072; # Added token limit
          }
          {
            name = "huggingface.co/DavidAU/MN-GRAND-Gutenberg-Lyra4-Lyra-12B-MADNESS-GGUF:latest";
            max_input_tokens = 1024000;
          }
          {
            name = "huggingface.co/mradermacher/MS-Magpantheonsel-lark-v4x1.6.2RP-Cydonia-vXXX-22B-6-i1-GGUF:latest";
            max_input_tokens = 131072; # Added token limit
          }
          {
            name = "huggingface.co/DavidAU/Mistral-MOE-4X7B-Dark-MultiVerse-Uncensored-Enhanced32-24B-gguf:latest";
            max_input_tokens = 32768; # Added token limit
          }
          {
            name = "huggingface.co/lmstudio-community/DeepSeek-Coder-V2-Lite-Instruct-GGUF:latest";
            max_input_tokens = 163840; # Added token limit
          }
          {
            name = "huggingface.co/DavidAU/DeepSeek-MOE-4X8B-R1-Distill-Llama-3.1-Deep-Thinker-Uncensored-24B-GGUF:latest";
            max_input_tokens = 131072; # Added token limit
          }
          {
            name = "huggingface.co/DavidAU/MN-WORDSTORM-pt3-RCM-POV-Nightmare-18.5B-Instruct-GGUF:latest";
            max_input_tokens = 102400; # Added token limit
          }
          {
            name = "snowflake-arctic-embed2:latest";
            type = "embedding";
            # max_tokens_per_chunk = 8192;
            # default_chunk_size = 1000;
            #  max_batch_size = 50;
          }
        ];
      }
    ];

    # --- Behavior ---
    stream = false;
    save = true;
    keybindings = "vi";
    editor = "nvim";
    wrap = "auto"; # Increased for better readability
    wrap_code = true; # Enable code wrapping for better display

    # --- Function Calling ---
    function_calling = false;
    #    use_tools = "all"; # Enabled file system tools

    # --- Session ---
    # save_session = true;
    # compress_threshold = 4000;
    # summarize_prompt = "Summarize the discussion briefly in 200 words or less to use as a prompt for future context.";
    # summary_prompt = "This is a summary of the chat history as a recap: ";

    # --- RAG ---
    rag_embedding_model = "ollama:snowflake-arctic-embed2:latest";
    rag_reranker_model = null;
    # rag_top_k = 4;
    #rag_chunk_size = 1000; # Added specific chunk size
    #rag_chunk_overlap = 200; # Added overlap for better context

    # --- Appearance ---
    highlight = true;
    light_theme = false;
    left_prompt = "{color.green}{?session {?agent {agent}>}{session}{?role /}}{!session {?agent {agent}>}}{role}{?rag @{rag}}{color.cyan}{?session )}{!session >}{color.reset} ";
    right_prompt = "{color.yellow}{model_name} {color.light_blue}[{?consume_tokens {consume_tokens}{color.magenta}({consume_percent:.2f}%){color.light_blue}}{!consume_tokens -}]{color.reset}";

    # --- Misc ---
    server_addr = "127.0.0.1:8000";
    user_agent = "auto"; # Set to auto for version tracking
    save_shell_history = true;
  };
}
