#!/usr/bin/env python3
"""
Fix VS environment file for bash.

Reads /tmp/vs_env.sh (written by cmd echo with Windows line endings
and double-quoted values), converts to single-quoted values safe for
bash (avoiding issues with parentheses in paths like "Program Files (x86)"),
and appends to ~/.bash_profile.
"""
import re
import os
import pathlib

VS_ENV_FILE = '/tmp/vs_env.sh'
BASH_PROFILE = pathlib.Path.home() / '.bash_profile'

# Read and fix line endings
content = open(VS_ENV_FILE).read().replace('\r', '')
lines = content.splitlines()

out = []
for line in lines:
    # Match: export VARNAME="value" or export VARNAME=value
    m = re.match(r'export ([A-Za-z_]+)="?(.*?)"?\s*$', line)
    if m:
        key = m.group(1)
        val = m.group(2)
        # PATH needs $PATH to be evaluated, so use double quotes
        if key == 'PATH':
            out.append(f'export {key}="{val}"')
        else:
            # Single-quote to prevent bash from interpreting () in paths
            out.append(f"export {key}='{val}'")
    else:
        out.append(line)

result = '\n'.join(out) + '\n'

# Write fixed file back
with open(VS_ENV_FILE, 'w') as f:
    f.write(result)

# Append to bash_profile
with open(BASH_PROFILE, 'a') as f:
    f.write('\n' + result)

print('=== vs_env.sh (fixed) ===')
print(result)
print(f'=== Appended to {BASH_PROFILE} ===')
