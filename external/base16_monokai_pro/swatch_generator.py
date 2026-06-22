#!/usr/bin/env python3
import re
from pathlib import Path

def hex_to_rgb(hex_color):
    hex_color = hex_color.lstrip('#')
    return tuple(int(hex_color[i:i+2], 16) for i in (0, 2, 4))

def rgb_to_hsl(r, g, b):
    r, g, b = r / 255.0, g / 255.0, b / 255.0
    max_c = max(r, g, b)
    min_c = min(r, g, b)
    l = (max_c + min_c) / 2
    if max_c == min_c:
        h = s = 0
    else:
        d = max_c - min_c
        s = d / (2 - max_c - min_c) if l > 0.5 else d / (max_c + min_c)
        if max_c == r:
            h = (g - b) / d + (6 if g < b else 0)
        elif max_c == g:
            h = (b - r) / d + 2
        else:
            h = (r - g) / d + 4
        h /= 6
    return round(h * 360), round(s * 100), round(l * 100)

def rgb_to_oklch(r, g, b):
    # Linearize sRGB
    def linearize(c):
        c = c / 255.0
        return ((c + 0.055) / 1.055) ** 2.4 if c > 0.04045 else c / 12.92

    r_l = linearize(r)
    g_l = linearize(g)
    b_l = linearize(b)

    # Linear RGB to LMS
    l = 0.4122214708 * r_l + 0.5363325363 * g_l + 0.0514459929 * b_l
    m = 0.2119034982 * r_l + 0.6806995451 * g_l + 0.1073969566 * b_l
    s = 0.0883024619 * r_l + 0.2817188376 * g_l + 0.6299787005 * b_l

    # LMS to OKLab
    import math
    l_ = math.cbrt(l)
    m_ = math.cbrt(m)
    s_ = math.cbrt(s)

    L = 0.2104542553 * l_ + 0.7936177850 * m_ - 0.0040720468 * s_
    a = 1.9779984951 * l_ - 2.4285922050 * m_ + 0.4505937099 * s_
    b_lab = 0.0259040371 * l_ + 0.7827717662 * m_ - 0.8086757660 * s_

    # OKLab to OKLCH
    C = math.sqrt(a * a + b_lab * b_lab)
    H = math.degrees(math.atan2(b_lab, a))
    if H < 0:
        H += 360.0

    return round(L, 4), round(C, 4), round(H, 1)


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

def create_html(scheme_name, colors, output_path):
    cards_html = ""
    base_labels = {
        'base00': 'Default Background',
        'base01': 'Lighter Background',
        'base02': 'Selection Background',
        'base03': 'Comments, Invisible',
        'base04': 'Light Foreground',
        'base05': 'Default Foreground',
        'base06': 'Light Accent Foreground',
        'base07': 'Bright Accent Foreground',
        'base08': 'Red',
        'base09': 'Orange',
        'base0A': 'Yellow',
        'base0B': 'Green',
        'base0C': 'Cyan',
        'base0D': 'Blue',
        'base0E': 'Magenta',
        'base0F': 'Brown'
    }

    for base_name, hex_color in colors.items():
        hex_color = hex_color.lstrip('#')
        r, g, b = hex_to_rgb(hex_color)
        h, s, l = rgb_to_hsl(r, g, b)
        okl, okc, okh = rgb_to_oklch(r, g, b)
        label = base_labels.get(base_name, base_name)
        text_color = "#000000" if get_luminance(hex_color) > 0.5 else "#ffffff"

        cards_html += f'''
        <div class="color-card" style="background-color: #{hex_color};">
            <div class="card-header" style="color: {text_color};">
                <span class="base-name">{base_name}</span>
                <span class="label">{label}</span>
            </div>
            <div class="color-values" style="color: {text_color};">
                <div class="value-row">
                    <span class="value-type">HEX</span>
                    <span class="value">#{hex_color}</span>
                </div>
                <div class="value-row">
                    <span class="value-type">RGB</span>
                    <span class="value">rgb({r}, {g}, {b})</span>
                </div>
                <div class="value-row">
                    <span class="value-type">HSL</span>
                    <span class="value">hsl({h}, {s}%, {l}%)</span>
                </div>
                <div class="value-row">
                    <span class="value-type">OKLCH</span>
                    <span class="value">oklch({okl:.4f} {okc:.4f} {okh:.1f})</span>
                </div>
            </div>
        </div>'''

    html = f'''<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>{scheme_name} - Color Swatch</title>
    <style>
        * {{
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }}
        body {{
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, sans-serif;
            background: #1a1a1a;
            min-height: 100vh;
            padding: 2rem;
        }}
        .container {{
            max-width: 1400px;
            margin: 0 auto;
        }}
        h1 {{
            color: #ffffff;
            text-align: center;
            margin-bottom: 2rem;
            font-size: 2.5rem;
            font-weight: 300;
        }}
        .grid {{
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 1.5rem;
        }}
        .color-card {{
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.3);
            transition: transform 0.2s ease, box-shadow 0.2s ease;
            aspect-ratio: 1;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }}
        .color-card:hover {{
            transform: translateY(-4px);
            box-shadow: 0 8px 30px rgba(0, 0, 0, 0.4);
        }}
        .card-header {{
            padding: 0.75rem 1rem;
        }}
        .base-name {{
            display: block;
            font-size: 1.1rem;
            font-weight: 600;
            margin-bottom: 0.25rem;
            font-family: 'SF Mono', 'Fira Code', monospace;
        }}
        .label {{
            display: block;
            font-size: 0.85rem;
            opacity: 0.8;
        }}
        .color-values {{
            padding: 0.5rem 0.75rem;
            background: rgba(0, 0, 0, 0.15);
            backdrop-filter: blur(10px);
        }}
        .value-row {{
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0.15rem 0;
            font-size: 0.65rem;
            line-height: 1.2;
        }}
        .value-type {{
            font-weight: 600;
            text-transform: uppercase;
            font-size: 0.6rem;
            opacity: 0.7;
        }}
        .value {{
            font-family: 'SF Mono', 'Fira Code', monospace;
            font-size: 0.68rem;
        }}
    </style>
</head>
<body>
    <div class="container">
        <h1>{scheme_name}</h1>
        <div class="grid">
{cards_html}
        </div>
    </div>
</body>
</html>'''

    with open(output_path, 'w') as f:
        f.write(html)

def main():
    current_dir = Path(__file__).parent.resolve()
    output_dir = current_dir / "swatches"
    output_dir.mkdir(exist_ok=True)

    for yaml_file in sorted(list(current_dir.glob("*.yaml")) + list(current_dir.glob("*.yml"))):
        data = parse_yaml(yaml_file)
        scheme_name = data.get('scheme', yaml_file.stem)
        colors = {k: v for k, v in data.items() if k.startswith('base')}

        output_name = yaml_file.stem.replace('base16-', 'swatch-')
        output_path = output_dir / f"{output_name}.html"
        create_html(scheme_name, colors, output_path)
        print(f"Generated: {output_path}")

if __name__ == '__main__':
    main()