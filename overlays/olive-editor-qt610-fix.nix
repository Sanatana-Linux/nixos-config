final: prev: {
  olive-editor = prev.olive-editor.overrideAttrs (oldAttrs: {
    patches =
      (oldAttrs.patches or [])
      ++ [
        ../patches/olive-editor-qt610-fix.patch
      ];
  });
}
