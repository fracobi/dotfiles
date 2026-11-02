#!/usr/bin/env bash
# Runtime used by this dotfiles snapshot. Tested in the Fedora 44 test VM.
set -euo pipefail
source /etc/os-release
[[ $ID == fedora && ${VERSION_ID:-} == 44 ]] || { echo 'Requires Fedora 44 (DNF).' >&2; exit 1; }
(( EUID != 0 )) || { echo 'Run as your normal user.' >&2; exit 1; }
COMMIT=f308426239665e3bc3d624014e9295b2ae2f58ff
SOURCE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/dotfiles/noctalia-qs-$COMMIT"
sudo dnf install git gcc-c++ cmake ninja-build pkgconf-pkg-config \
  qt6-qtbase-devel qt6-qtbase-private-devel qt6-qtdeclarative-devel qt6-qtdeclarative-private-devel \
  qt6-qtwayland-devel qt6-qtshadertools-devel qt6-qtsvg qt6-qt5compat qt6-qtmultimedia \
  libdrm-devel mesa-libgbm-devel mesa-libEGL-devel vulkan-headers \
  wayland-devel wayland-protocols-devel cli11-devel pipewire-devel polkit-devel pam-devel \
  jemalloc-devel libxcb-devel
mkdir -p "$(dirname "$SOURCE_DIR")"
if [[ ! -d "$SOURCE_DIR" ]]; then
  git clone https://github.com/noctalia-dev/noctalia-qs.git "$SOURCE_DIR"
fi
cd "$SOURCE_DIR"
git diff --quiet && git diff --cached --quiet || { echo 'Source has local changes; refusing to build.' >&2; exit 1; }
git checkout --detach "$COMMIT"
cmake -S . -B build -G Ninja -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr/local -DCRASH_HANDLER=OFF
cmake --build build --parallel "${BUILD_JOBS:-2}"
sudo cmake --install build
/usr/local/bin/qs --version
