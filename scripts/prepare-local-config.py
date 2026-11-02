#!/usr/bin/env python3
"""Relocate snapshot paths without writing through Stow file symlinks."""
import os
from pathlib import Path
import sys
import tempfile

home = Path(sys.argv[1]).resolve()
for relative in ('.config/noctalia/settings.json', '.config/hypr/hyprpaper.conf'):
    target = home / relative
    original = target.read_text()
    relocated = original.replace('/home/cobi/', str(home) + '/')
    if relocated == original:
        continue
    # Replace the file symlink, preserving the repository's template.
    fd, name = tempfile.mkstemp(prefix='.dotfiles-', dir=target.parent)
    try:
        with os.fdopen(fd, 'w') as stream:
            stream.write(relocated)
        os.replace(name, target)
    finally:
        if os.path.exists(name):
            os.unlink(name)
    print(f'Personalized paths: {target}')
