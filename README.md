# fracobi/dotfiles

Personal Linux setup based on:

* Hyprland
* Quickshell / Noctalia
* Kitty
* Zsh + Starship
* Fastfetch
* GNU Stow

The goal of this repository is to provide a reproducible and easy-to-bootstrap Arch/CachyOS setup with minimal manual configuration.

---

# Features

* Hyprland desktop setup
* Modular Lua-based Hyprland configuration
* Quickshell / Noctalia shell
* Kitty terminal configuration
* Zsh + Starship prompt
* Fastfetch configuration
* Clipboard history support
* Screenshot utilities
* Brave browser configuration
* Automatic package installation
* Automatic config backup
* GNU Stow-based dotfiles management

---

# Installation

## Arch / CachyOS

```bash
sudo pacman -S --needed git
git clone https://github.com/fracobi/dotfiles.git ~/dotfiles
cd ~/dotfiles
./bootstrap-arch.sh
```

After installation:

```bash
reboot
```

---

# What the bootstrap script does

`bootstrap-arch.sh` automatically:

* updates the system
* installs required pacman packages
* installs `paru` if missing
* installs AUR packages
* applies dotfiles using GNU Stow
* backs up existing configs automatically
* sets `zsh` as the default shell

---

# Repository Structure

```text
dotfiles/
├── hypr/
├── kitty/
├── zsh/
├── starship/
├── fastfetch/
├── noctalia/
├── quickshell/
├── theming/
├── packages/
│   ├── arch.txt
│   └── aur.txt
├── install.sh
└── bootstrap-arch.sh
```

---

# Package Management

## Official repository packages

Packages installed through pacman are listed in:

```text
packages/arch.txt
```

---

# Dotfiles Management

This repository uses GNU Stow.

Each folder represents a package that gets symlinked into `$HOME`.

Example:

```bash
stow hypr
```

creates symlinks from:

```text
hypr/.config/hypr
```

to:

```text
~/.config/hypr
```

---


# VM / QEMU Notes

Running Hyprland inside QEMU/virt-manager may require additional configuration.

Known limitations:

* 3D acceleration may not work depending on host configuration
* monitor scaling and resolutions can behave differently
* Quickshell rendering may be degraded without GPU acceleration

---

# Requirements

Mainly tested on:

* CachyOS
* Fedora

Other distros are currently unsupported.

---

# Screenshots

TODO

---

# License

MIT License
