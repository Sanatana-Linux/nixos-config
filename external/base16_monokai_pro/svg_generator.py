#!/usr/bin/env python3
from pathlib import Path

def hex_to_rgb(hex_color):
    hex_color = hex_color.lstrip('#')
    return tuple(int(hex_color[i:i+2], 16) for i in (0, 2, 4))

def get_luminance(hex_color):
    r, g, b = hex_to_rgb(hex_color)
    return (0.299 * r + 0.587 * g + 0.114 * b) / 255

def parse_yaml(filepath):
    data = {}
    with open(filepath) as f:
        for line in f:
            line = line.strip()
            if ':' in line:
                key, value = line.split(':', 1)
                key = key.strip()
                value = value.strip()
                if value.startswith('"') and value.endswith('"'):
                    value = value[1:-1]
                if '#' in value:
                    hash_idx = value.find('#')
                    value = value[hash_idx:hash_idx+7]
                data[key] = value
    return data

def create_svg(scheme_name, colors, output_path):
    cols = 4
    rows = 4
    cell_width = 120
    cell_height = 140
    padding = 20
    total_width = cols * cell_width + padding * 2
    total_height = rows * cell_height + padding * 2

    svg_content = f'''<?xml version="1.0" encoding="UTF-8"?>
<svg xmlns="http://www.w3.org/2000/svg" width="{total_width}" height="{total_height}" viewBox="0 0 {total_width} {total_height}">
  <rect width="100%" height="100%" fill="#1a1a1a"/>
  <style>
    .hex-label {{ font-family: 'SF Mono', 'Fira Code', 'Consolas', monospace; font-size: 11px; text-anchor: middle; }}
  </style>
'''

    sorted_colors = sorted(colors.items(), key=lambda x: x[0])

    for idx, (base_name, hex_color) in enumerate(sorted_colors):
        col = idx % cols
        row = idx // cols
        x = padding + col * cell_width + 10
        y = padding + row * cell_height
        square_x = x + (cell_width - 20 - 100) // 2
        text_color = "#ffffff" if get_luminance(hex_color) <= 0.5 else "#000000"

        svg_content += f'''
  <rect x="{square_x}" y="{y}" width="100" height="100" rx="8" fill="{hex_color}"/>
  <text x="{x + 50}" y="{y + 120}" class="hex-label" fill="#e0e0e0">{hex_color}</text>
'''

    svg_content += '\n</svg>'

    with open(output_path, 'w') as f:
        f.write(svg_content)

def main():
    current_dir = Path(__file__).parent.resolve()
    output_dir = current_dir / "swatches"
    output_dir.mkdir(exist_ok=True)

    for yaml_file in sorted(current_dir.glob("*.yaml")):
        data = parse_yaml(yaml_file)
        scheme_name = data.get('scheme', yaml_file.stem)
        colors = {k: v for k, v in data.items() if k.startswith('base')}

        output_name = yaml_file.stem.replace('base16-', 'colors-')
        output_path = output_dir / f"{output_name}.svg"
        create_svg(scheme_name, colors, output_path)
        print(f"Generated: {output_path}")

if __name__ == '__main__':
    main()