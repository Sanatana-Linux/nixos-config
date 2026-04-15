{pkgs}:
with pkgs;
  writeScriptBin "icon-viewer" ''
        #!/usr/bin/env bash

          # ==========================================
          # USAGE & DEPENDENCIES
          # ==========================================
          show_usage() {
              echo "Usage: $0 <command> <font-file.ttf/.otf>"
              echo ""
              echo "Commands:"
              echo "  make-md    - Generate a Markdown file in /tmp and open in \$EDITOR."
              echo "  make-html  - Generate a responsive HTML UI in /tmp and open in default browser."
              echo "  rofi       - Open the icons in Rofi to fuzzy-search and copy to clipboard."
              echo ""
              echo "Example:"
              echo "  $0 make-html myfont.ttf"
              exit 1
          }

          if [[ $# -lt 2 ]]; then
              show_usage
          fi

          COMMAND="$1"
          FONT="$2"

          if [[ ! -f "$FONT" ]]; then
              echo "Error: Font file '$FONT' not found!"
              exit 1
          fi

          command -v ttx >/dev/null 2>&1 || { echo >&2 "Error: ttx (fonttools) is required. Install with: pip install fonttools"; exit 1; }
          command -v xmllint >/dev/null 2>&1 || { echo >&2 "Error: xmllint is required."; exit 1; }

          # Get the base filename without directories (e.g. "myfont.ttf")
          FONT_BASENAME=$(basename "$FONT")

          # ==========================================
          # CORE PARSER
          # ==========================================
          extract_codepoints() {
              local target_font="$1"
              local temp_dir=$(mktemp -d)
              local temp_ttx="$temp_dir/temp.ttx"
              # Convert font to XML temporarily
              ttx -o "$temp_ttx" "$target_font" >/dev/null 2>&1
              if [ $? -ne 0 ]; then
                  echo "Error: Failed to convert font to XML using ttx." >&2
                  rm -rf "$temp_dir"
                  return 1
              fi

              # Extract codepoints and format string dynamically using bash logic
              xmllint --xpath '//cmap/cmap_format_12/map | //cmap/cmap_format_4/map' "$temp_ttx" 2>/dev/null | \
              sed -n 's/.*code="0x\([0-9A-Fa-f]\+\)".*name="\([^"]*\)".*/U+\1 \2/p' | \
              while read -r codepoint_u glyph_name; do
                  codepoint_hex="''${codepoint_u#U+}"
                  codepoint_dec=$((16#$codepoint_hex))

                  if [ "$codepoint_dec" -le 65535 ]; then
                      hex_padded=$(printf "%04X" "$codepoint_dec")
                      printf -v char "\\u$hex_padded"
                  else
                      hex_padded=$(printf "%08X" "$codepoint_dec")
                      printf -v char "\\U$hex_padded"
                  fi

                  echo -e "$codepoint_u $glyph_name \t $char"
              done

              rm -rf "$temp_dir"
          }

          # ==========================================
          # COMMAND: MAKE-MD
          # ==========================================
          do_make_md() {
              local out="/tmp/''${FONT_BASENAME%.*}.md"
              echo "Generating $out..."
              extract_codepoints "$FONT" > "$out"
              echo "Done! Saved to $out."

              # Launch in $EDITOR (or default to vi if undefined)
              local current_editor="''${EDITOR:-vi}"
              if command -v "$current_editor" >/dev/null 2>&1; then
                  echo "Opening $out with $current_editor..."
                  "$current_editor" "$out"
              else
                  echo "Could not find editor '$current_editor'. Please open $out manually."
              fi
          }

          # ==========================================
          # COMMAND: ROFI
          # ==========================================
          do_rofi() {
              command -v rofi >/dev/null 2>&1 || { echo >&2 "Error: rofi is required."; exit 1; }

              local selection
              selection=$(extract_codepoints "$FONT" | grep '^U+' | rofi -dmenu -i -p "Copy Icon:")

              if [[ -n "$selection" ]]; then
                  local icon=$(echo "$selection" | awk '{print $NF}' | tr -d '\n')

                  if command -v wl-copy >/dev/null 2>&1; then
                      echo -n "$icon" | wl-copy
                      echo "Copied '$icon' to clipboard (Wayland: wl-copy)"
                  elif command -v xclip >/dev/null 2>&1; then
                      echo -n "$icon" | xclip -selection clipboard
                      echo "Copied '$icon' to clipboard (X11: xclip)"
                  else
                      echo "Selected icon: $icon"
                      echo "(Note: 'wl-copy' or 'xclip' is required to automatically copy to clipboard)"
                  fi
              fi
          }

          # ==========================================
          # COMMAND: MAKE-HTML
          # ==========================================
          do_make_html() {
              local out="/tmp/''${FONT_BASENAME%.*}.html"
              echo "Generating HTML visualizer at $out..."

              local ext="''${FONT##*.}"
              local format="truetype"
              [[ "''${ext,,}" == "otf" ]] && format="opentype"

              local b64_font=$(base64 "$FONT" | tr -d '\n')

              # 1. Output HTML Head & CSS
              cat > "$out" << 'HTMLEOF'
          <!DOCTYPE html>
          <html lang="en">
          <head>
              <meta charset="UTF-8">
              <meta name="viewport" content="width=device-width, initial-scale=1.0">
              <title>Icon Reference: FONT_BASENAME_PLACEHOLDER</title>
              <style>
                  @font-face {
                      font-family: 'EmbeddedFont';
                      src: url('data:font/FONT_EXT_PLACEHOLDER;charset=utf-8;base64,FONT_B64_PLACEHOLDER') format('FONT_FORMAT_PLACEHOLDER');
                      font-weight: normal; font-style: normal;
                  }
                  :root {
                      --bg: #121212; --fg: #e0e0e0; --accent: #60a5fa;
                      --card-bg: #1e1e1e; --card-border: #333; --card-hover: #262626;
                      --hex-bg: #2d2d2d; --hex-fg: #9ca3af;
                      --btn-bg: #374151; --btn-hover: #4b5563; --btn-active: #1f2937;
                  }
                  body { font-family: system-ui, -apple-system, sans-serif; background: var(--bg); color: var(--fg); margin: 0; padding: 2rem; }
                  h1 { text-align: center; font-size: 2rem; color: #fff; margin-bottom: 2rem; }

                  .grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(220px, 1fr)); gap: 1.5rem; max-width: 1800px; margin: 0 auto; }

                  .card { background: var(--card-bg); border: 1px solid var(--card-border); border-radius: 12px; padding: 1.5rem; display: flex; flex-direction: column; align-items: center; text-align: center; transition: transform 0.2s, border-color 0.2s, background 0.2s; box-shadow: 0 4px 6px rgba(0,0,0,0.3); }
                  .card:hover { transform: translateY(-3px); border-color: var(--accent); background: var(--card-hover); }

                  .icon { font-family: 'EmbeddedFont'; font-size: 3.5rem; color: var(--fg); margin-bottom: 1rem; line-height: 1; position: relative; display: flex; justify-content: center; align-items: center; width: 1.2em; height: 1.2em; transition: color 0.2s; }
                  .card:hover .icon { color: var(--accent); }

                  .icon.duotone .primary { position: relative; z-index: 2; }
                  .icon.duotone .secondary { position: absolute; opacity: 0.4; z-index: 1; }

                  .name { font-size: 0.95rem; font-weight: 500; margin-bottom: 0.5rem; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden; height: 2.3em; }
                  .hex { font-family: monospace; font-size: 0.85rem; color: var(--hex-fg); background: var(--hex-bg); padding: 0.2rem 0.5rem; border-radius: 4px; margin-bottom: 1rem; }

                  .copy-btn { cursor: pointer; background: var(--btn-bg); color: #fff; border: none; padding: 0.6rem 1rem; border-radius: 6px; font-size: 0.9rem; font-weight: 500; width: 100%; transition: all 0.2s; }
                  .copy-btn:hover { background: var(--btn-hover); }
                  .copy-btn:active { background: var(--btn-active); transform: scale(0.97); }
              </style>
              <script>
                  function copyText(button, text) {
                      navigator.clipboard.writeText(text).then(() => {
                          const originalText = button.innerText;
                          button.innerText = "Copied!";
                          button.style.background = "#059669";
                          setTimeout(() => {
                              button.innerText = originalText;
                              button.style.background = "";
                          }, 1500);
                      });
                  }
              </script>
          </head>
          <body>
              <h1>Icon Reference: FONT_BASENAME_PLACEHOLDER</h1>
               <div class="grid">
    HTMLEOF

               # Replace placeholders with actual values using a safer method
               sed -i "s/FONT_BASENAME_PLACEHOLDER/$FONT_BASENAME/g" "$out"
               sed -i "s/FONT_EXT_PLACEHOLDER/$ext/g" "$out"
               sed -i "s/FONT_FORMAT_PLACEHOLDER/$format/g" "$out"

               # Handle base64 font data separately to avoid "Argument list too long"
               # Write base64 data to a temporary file and use it for replacement
               local temp_script=$(mktemp)
               cat > "$temp_script" << 'EOF'
    import sys
    import re

    # Read the HTML file
    with open(sys.argv[1], 'r') as f:
        content = f.read()

    # Read the base64 data
    with open(sys.argv[2], 'r') as f:
        b64_data = f.read().strip()

    # Replace the placeholder
    content = content.replace('FONT_B64_PLACEHOLDER', b64_data)

    # Write back
    with open(sys.argv[1], 'w') as f:
        f.write(content)
    EOF

               # Create temp file with base64 data
               local temp_b64=$(mktemp)
               echo -n "$b64_font" > "$temp_b64"

               # Use python to do the replacement
               python3 "$temp_script" "$out" "$temp_b64"

               # Clean up
               rm -f "$temp_script" "$temp_b64"

              # 2. Extract Data & Append HTML Cards
              extract_codepoints "$FONT" | grep '^U+' | awk -F '\t' '
              BEGIN { count = 0; }
              {
                  char_val = $2; gsub(/^[ \t]+|[ \t]+$/, "", char_val);
                  str = $1; gsub(/^[ \t]+|[ \t]+$/, "", str);
                  idx = index(str, " ");
                  hex_val = substr(str, 1, idx-1);
                  name_val = substr(str, idx+1);

                  hex_map[hex_val] = char_val;
                  name_map[hex_val] = name_val;
                  keys[count++] = hex_val;
              }
              END {
                  for (i = 0; i < count; i++) {
                      h = keys[i];

                      # Skip standalone render for Duotone secondary layers
                      if (length(h) >= 5 && substr(h, 1, 2) == "10") {
                          base_hex = substr(h, 3);
                          if (base_hex in hex_map) { continue; }
                      }

                      char_val = hex_map[h];
                      name_val = name_map[h];

                      # Identify secondary layer
                      sec_hex = "10" h;
                      sec_char = "";
                      if (sec_hex in hex_map) { sec_char = hex_map[sec_hex]; }

                      print "        <div class=\"card\">"
                      if (sec_char != "") {
                          print "            <div class=\"icon duotone\" title=\"" name_val "\">"
                          print "                <span class=\"primary\">" char_val "</span>"
                          print "                <span class=\"secondary\">" sec_char "</span>"
                          print "            </div>"
                      } else {
                          print "            <div class=\"icon\" title=\"" name_val "\">" char_val "</div>"
                      }
                      print "            <div class=\"name\" title=\"" name_val "\">" name_val "</div>"
                      print "            <div class=\"hex\">" h "</div>"
                      print "            <button class=\"copy-btn\" onclick=\"copyText(this, \x27" char_val "\x27)\">Copy Icon</button>"
                      print "        </div>"
                  }
              }' >> "$out"

               # 3. Close HTML Tags
               cat >> "$out" << 'HTMLEOF2'
               </div>
           </body>
           </html>
    HTMLEOF2

              echo "Done! Saved to $out."

              # 4. Auto-launch the browser
              if command -v xdg-open >/dev/null 2>&1; then
                  echo "Opening in system default browser (xdg-open)..."
                  xdg-open "$out" &
              elif [[ -n "$BROWSER" ]] && command -v "$BROWSER" >/dev/null 2>&1; then
                  echo "Opening in \$BROWSER ($BROWSER)..."
                  "$BROWSER" "$out" &
              elif command -v firefox >/dev/null 2>&1; then
                  echo "Opening in Firefox..."
                  firefox "$out" &
              else
                  echo "Could not find xdg-open, \$BROWSER, or Firefox to auto-launch the HTML file."
              fi
          }

          # ==========================================
          # COMMAND ROUTER
          # ==========================================
          case "$COMMAND" in
              make-md)   do_make_md ;;
              make-html) do_make_html ;;
              rofi)      do_rofi ;;
              *)
                  echo "Error: Unknown command '$COMMAND'"
                  show_usage
                  ;;
          esac
  ''
