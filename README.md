# dotfiles

Personal Linux dotfiles for my Hyprland-based desktop setup.

These configurations are managed with **Git** and **GNU Stow**, so each module can be symlinked into the correct location in the home directory.

## Setup

Main components:

* Hyprland with Lua configuration
* Hyprlock, Hypridle and Hyprpaper
* Quickshell / Noctalia
* Kitty
* Zsh
* Starship
* Fastfetch
* GTK / Qt / Kvantum theming

## Structure

```text
dotfiles/
├── fastfetch/
├── hypr/
├── kitty/
├── noctalia/
├── packages/
├── quickshell/
├── starship/
├── theming/
└── zsh/
```

Each directory is a Stow package. For example:

```text
hypr/.config/hypr
```

is linked to:

```text
~/.config/hypr
```

## Installation

Clone the repository:

```bash
git clone https://github.com/fracobi/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

Install the required packages manually or use the Fedora package list as a reference:

```bash
packages/fedora.txt
```

Apply the configuration:

```bash
./install.sh
```

Or manually with Stow:

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

## Notes

This repository is tailored to my personal setup and is not intended to be a universal installation framework.

Some configuration values are machine-specific, especially:

* monitor names
* workspace rules
* scaling
* hardware-specific bindings
* local paths

Review the files before applying them on a different machine.

## License

No license is currently provided. This repository is mainly intended as a personal configuration backup.
