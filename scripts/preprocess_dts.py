#!/usr/bin/env python3
"""
Preprocess a DTS file by inlining local #include directives and
replacing dt-bindings macros with literal values.
Usage: python3 preprocess_dts.py <input.dts> <output.dts> <include_dir>
"""
import sys, os, re

GPIO_ACTIVE_HIGH = 0
GPIO_ACTIVE_LOW = 1

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
            pass  # skip angle-bracket includes
        else:
            result.append(line)
    return '\n'.join(result)

if len(sys.argv) < 4:
    print(f"Usage: {sys.argv[0]} <input.dts> <output.dts> <include_dir>")
    sys.exit(1)

input_file = sys.argv[1]
output_file = sys.argv[2]
include_dir = sys.argv[3]

with open(input_file, 'r') as f:
    content = f.read()

processed = resolve_includes(content, include_dir)

defines = """
#ifndef GPIO_ACTIVE_HIGH
#define GPIO_ACTIVE_HIGH 0
#endif
#ifndef GPIO_ACTIVE_LOW
#define GPIO_ACTIVE_LOW 1
#endif
"""
processed = defines + processed

with open(output_file, 'w') as f:
    f.write(processed)

print(f"Preprocessed: {input_file} -> {output_file} ({len(processed.splitlines())} lines)")
