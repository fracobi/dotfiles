# Dotfiles

Personal Linux dotfiles for my Hyprland-based desktop environment.

This repository contains the configuration files I use to reproduce my current setup across machines.
The setup is managed with **Git** and **GNU Stow**, so every configuration module can be symlinked into the correct location inside the home directory.

## Current setup

This dotfiles repository currently includes:

* **Hyprland** configuration in Lua
* **Hyprlock**, **Hypridle** and **Hyprpaper**
* **Kitty** terminal configuration
* **Zsh** shell configuration
* **Starship** prompt configuration
* **Fastfetch** configuration
* **Noctalia** configuration
* **Quickshell** configuration, including Noctalia shell and overview
* **GTK / Qt / Kvantum** theming configuration
* Fedora package list

## Repository structure

```text
dotfiles/
├── fastfetch/
│   └── .config/fastfetch/
├── hypr/
│   └── .config/hypr/
├── kitty/
│   └── .config/kitty/
├── noctalia/
│   └── .config/noctalia/
├── packages/
│   └── fedora.txt
├── quickshell/
│   └── .config/quickshell/
├── starship/
│   └── .config/starship.toml
├── theming/
│   └── .config/
│       ├── gtk-3.0/
│       ├── gtk-4.0/
│       ├── qt6ct/
│       └── Kvantum/
├── zsh/
│   └── .zshrc
├── install.sh
└── README.md
```

## Requirements

Before applying the dotfiles, install at least:

```bash
git
stow
```

On Fedora:

```bash
sudo dnf install git stow
```

The full list of packages used by this setup is available in:

```text
packages/fedora.txt
```

You can install them manually or use the file as a reference.

## Installation

Clone the repository:

```bash
git clone <repo-url> ~/dotfiles
cd ~/dotfiles
```

Apply the configurations using GNU Stow:

```bash
stow hypr
stow kitty
stow starship
stow zsh
stow fastfetch
stow noctalia
stow quickshell
stow theming
```

Alternatively, run the install script:

```bash
./install.sh
```

The script applies all available Stow packages from this repository.

## How GNU Stow is used

Each top-level folder represents one configuration module.

For example:

```text
hypr/.config/hypr/
```

is symlinked to:

```text
~/.config/hypr
```

This means that editing:

```text
~/.config/hypr/hyprland.lua
```

actually edits the tracked file inside:

```text
~/dotfiles/hypr/.config/hypr/hyprland.lua
```

After changing any configuration file, commit the changes with Git:

```bash
cd ~/dotfiles
git status
git add .
git commit -m "Update configuration"
git push
```

## Hyprland notes

The Hyprland configuration uses the new **Lua-based configuration format**.

Main file:

```text
hypr/.config/hypr/hyprland.lua
```

Modular Lua configuration files:

```text
hypr/.config/hypr/lua/
```

Current modules include:

```text
00-variables.lua
10-monitors.lua
20-autostart.lua
30-env.lua
40-looknfeel.lua
50-input.lua
60-layouts.lua
70-rules.lua
80-workspaces.lua
90-binds.lua
95-plugins.lua
```

Some settings are machine-specific, especially:

* monitor names
* monitor positions
* scaling
* workspace-to-monitor rules
* hardware-specific bindings
* laptop-specific power management

These may need to be adjusted on a different machine.

## Quickshell and Noctalia

This repository currently includes the local Quickshell and Noctalia configuration used by my setup.

Included paths:

```text
~/.config/noctalia
~/.config/quickshell
```

At the moment, Quickshell/Noctalia are stored directly in this repository to make the setup easier to reproduce.

A possible future improvement is to separate:

* upstream Noctalia/Quickshell source files
* personal settings and overrides
* local machine-specific configuration

For now, the goal is practical reproducibility.

## Theming

The repository includes minimal GTK, Qt and Kvantum configuration:

```text
~/.config/gtk-3.0
~/.config/gtk-4.0
~/.config/qt6ct
~/.config/Kvantum
```

The actual themes and icons may still need to be installed separately through the system package manager.

## Package list

The Fedora package list is stored in:

```text
packages/fedora.txt
```

This file is intended as a reference for rebuilding the environment on a fresh Fedora installation.

Example usage:

```bash
sudo dnf install $(cat packages/fedora.txt)
```

Review the package list before running the command on a new system.

## Safety notes

This repository should not contain secrets or private credentials.

Do not add:

* SSH private keys
* API keys
* VPN profiles
* browser profiles
* cookies
* passwords
* rclone configuration
* NAS credentials
* private tokens
* application caches

Before pushing changes, check the repository status:

```bash
git status
```

And inspect staged files if needed:

```bash
git diff --cached
```

## Useful commands

Check repository status:

```bash
git status
```

Check recent commits:

```bash
git log --oneline --max-count=10
```

Check if there are embedded Git repositories or submodule-like entries:

```bash
git ls-files -s | grep '160000'
```

Check whether Stow would create conflicts:

```bash
stow -n -v hypr
stow -n -v kitty
stow -n -v starship
stow -n -v zsh
stow -n -v fastfetch
stow -n -v noctalia
stow -n -v quickshell
stow -n -v theming
```

Check where a configuration symlink points:

```bash
readlink -f ~/.config/hypr
readlink -f ~/.config/noctalia
readlink -f ~/.config/quickshell
readlink -f ~/.config/kitty
readlink -f ~/.config/gtk-3.0
```

## Rollback

If a Stow package needs to be removed:

```bash
cd ~/dotfiles
stow -D <package>
```

Example:

```bash
stow -D hypr
```

This removes the symlinks created by Stow, but does not delete the files inside the repository.

## Status

This repository is currently tailored to my personal Fedora + Hyprland setup.

It is not intended to be a universal installation framework yet, but rather a reproducible backup of my working desktop environment.
