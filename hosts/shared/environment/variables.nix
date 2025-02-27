{
  environment.variables = {
    #    AI_PROVIDER = "ollama";
    BROWSER = "firefox";
    LIBGL_DRI3_DISABLE = "1";
    _JAVA_AWT_WM_NONREPARENTING = "1";
    JDK_JAVA_OPTIONS = "-Dawt.useSystemAAFontSettings=on -Dswing.aatext=true -Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel -Djdk.gtk.version=2.2 -Dsun.java2d.opengl=true";
    ZSH_AUTOSUGGEST_USE_ASYNC = "true";
    G2TP_OVMF_IMAGE = "/run/libvirt/nix-ovmf/OVMF_CODE.fd";
    G2TP_GRUB_LIB = "/nix/store/77r7pkdhylp119m32lhh349yqc5dyig6-grub-2.12/lib/grub";
    OLLAMA_API_BASE = "http://127.0.0.1:11434";
    OPENAI_API_BASE = "http://localhost:11434";
  };
}
