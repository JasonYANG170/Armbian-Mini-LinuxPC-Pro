#!/usr/bin/env python3
"""
Preprocess a DTS file by inlining local #include directives and
replacing dt-bindings macros with literal values.
Usage: python3 preprocess_dts.py <input.dts> <output.dts> <include_dir>
"""
import sys, os, re

# dt-bindings/gpio/gpio.h
GPIO_ACTIVE_HIGH = 0
GPIO_ACTIVE_LOW = 1
GPIO_PULL_UP = 1
GPIO_PULL_DOWN = 2
GPIO_LINE_OPEN_DRAIN = 0x1000
GPIO_LINE_OPEN_SOURCE = 0x2000

# dt-bindings/leds/common.h
LED_COLOR_ID_WHITE = 0
LED_COLOR_ID_RED = 1
LED_COLOR_ID_GREEN = 2
LED_COLOR_ID_BLUE = 3
LED_COLOR_ID_AMBER = 4

MACROS = {
    'GPIO_ACTIVE_HIGH': GPIO_ACTIVE_HIGH,
    'GPIO_ACTIVE_LOW': GPIO_ACTIVE_LOW,
    'GPIO_PULL_UP': GPIO_PULL_UP,
    'GPIO_PULL_DOWN': GPIO_PULL_DOWN,
    'GPIO_LINE_OPEN_DRAIN': GPIO_LINE_OPEN_DRAIN,
    'GPIO_LINE_OPEN_SOURCE': GPIO_LINE_OPEN_SOURCE,
    'LED_COLOR_ID_WHITE': LED_COLOR_ID_WHITE,
    'LED_COLOR_ID_RED': LED_COLOR_ID_RED,
    'LED_COLOR_ID_GREEN': LED_COLOR_ID_GREEN,
    'LED_COLOR_ID_BLUE': LED_COLOR_ID_BLUE,
    'LED_COLOR_ID_AMBER': LED_COLOR_ID_AMBER,
    'GIC_SPI': 0,
    'GIC_PPI': 1,
}

def resolve_includes(content, base_dir, depth=0):
    if depth > 10:
        return content
    result = []
    for line in content.split('\n'):
        m = re.match(r'^\s*#include\s+"([^"]+)"', line)
        if m:
            inc_file = os.path.join(base_dir, m.group(1))
            if os.path.exists(inc_file):
                with open(inc_file, 'r') as f:
                    inc_content = f.read()
                result.append(f'/* === BEGIN {m.group(1)} === */')
                result.append(resolve_includes(inc_content, base_dir, depth+1))
                result.append(f'/* === END {m.group(1)} === */')
            else:
                result.append(f'/* WARNING: include file {m.group(1)} not found */')
        elif re.match(r'^\s*#include\s+<', line):
            pass  # skip angle-bracket includes (dt-bindings)
        elif re.match(r'^\s*#(define|ifdef|ifndef|endif|if|else|elif)', line):
            pass  # skip preprocessor directives
        else:
            result.append(line)
    return '\n'.join(result)

def replace_macros(content):
    """Replace C preprocessor macros with their numeric values."""
    for name, value in MACROS.items():
        # Replace standalone macro references (not inside strings)
        content = re.sub(r'\b' + name + r'\b', str(value), content)
    return content

if len(sys.argv) < 4:
    print(f"Usage: {sys.argv[0]} <input.dts> <output.dts> <include_dir>")
    sys.exit(1)

input_file = sys.argv[1]
output_file = sys.argv[2]
include_dir = sys.argv[3]

with open(input_file, 'r') as f:
    content = f.read()

# Step 1: resolve includes
processed = resolve_includes(content, include_dir)

# Step 2: replace macros with values
processed = replace_macros(processed)

# Step 3: remove remaining preprocessor lines
processed = re.sub(r'^\s*#(define|ifdef|ifndef|endif|if|else|elif|undef)\b.*$', '', processed, flags=re.MULTILINE)

# Step 4: clean up multiple blank lines
processed = re.sub(r'\n{3,}', '\n\n', processed)

with open(output_file, 'w') as f:
    f.write(processed)

print(f"Preprocessed: {input_file} -> {output_file} ({len(processed.splitlines())} lines)")
