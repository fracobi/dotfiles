# ---------- PATH ----------
export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$PATH"
export PATH="$HOME/go/bin:$PATH"

#----------- COLORS FOR NMTUI---------
export NEWT_COLORS='window=white,black;border=cyan,black;textbox=white,black;button=black,cyan;actbutton=black,green'

# ---------- STARSHIP (prompt) ----------
command -v starship >/dev/null 2>&1 && eval "$(starship init zsh)"

# ---------- ATUIN ----------
command -v atuin >/dev/null 2>&1 && eval "$(atuin init zsh)"

# ---------- ZOXIDE ----------
command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init zsh)"

# ---------- FZF ----------
command -v fzf >/dev/null 2>&1 && eval "$(fzf --zsh)"

# ---------- THE FUCK ----------
if command -v thefuck >/dev/null 2>&1; then
  eval "$(thefuck --alias)"
  eval "$(thefuck --alias fk)"
fi

# ---------- AUTOCOMPLETE ----------
autoload -Uz compinit
compinit

# --------Zsh Autosuggestions----------
if [ -f /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
  source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
elif [ -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
  source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

# ---------Zsh syntax highlighting---------
if [ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
  source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
elif [ -f /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
  source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# ---------- ALIAS ----------

alias ls="eza"
alias ll="eza -lah"
alias cat="bat"

#MimeApp Nocatilia 

alias mime-app='qs -c noctalia-shell ipc call plugin:mimeapp-gui openPanel'

#Overview
alias overview-fix='systemctl --user restart quickshell-overview.service && qs ipc -c overview call overview toggle'

unalias virtual-monitor-fix 2>/dev/null

# virtual monitor / WINSCREEN
_virtual_monitor_on() {
  hyprctl output create headless WINSCREEN 2>/dev/null || true
  sleep 0.3

  hyprctl eval 'hl.monitor({ output = "WINSCREEN", mode = "1920x1080@60", position = "3520x0", scale = 1 })'
  hyprctl dispatch 'hl.dsp.workspace.move({ workspace = "11", monitor = "WINSCREEN" })'
}

_virtual_monitor_off() {
  hyprctl output remove WINSCREEN
}

alias virtual-monitor-on='_virtual_monitor_on'
alias virtual-monitor-off='_virtual_monitor_off'

virtual-monitor-fix() {
  systemctl --user reset-failed

  systemctl --user restart pipewire.service wireplumber.service
  sleep 1

  systemctl --user restart xdg-desktop-portal-hyprland.service
  sleep 1

  systemctl --user status xdg-desktop-portal-hyprland.service --no-pager
}

# Local/private aliases and machine-specific settings
[ -f "$HOME/.zshrc.local" ] && source "$HOME/.zshrc.local"

# Brave Reset
alias fix-brave="rm -f ~/.config/BraveSoftware/Brave-Browser/Singleton*"

# ---------- KEYBINDINGS ----------

# ctrl + freccia destra → avanti parola
bindkey "^[[1;5C" forward-word

# ctrl + freccia sinistra → indietro parola
bindkey "^[[1;5D" backward-word

# ctrl + backspace → cancella parola
bindkey '^H' backward-kill-word

# atuin su ctrl+r
command -v atuin >/dev/null 2>&1 && bindkey '^R' atuin-search

# Utilizzo tasto Canc
bindkey "^[[3~" delete-char-or-list

# ---------- HISTORY ----------
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_DUPS
setopt SHARE_HISTORY

# ---------- FASTFETCH ----------
command -v fastfetch >/dev/null 2>&1 && fastfetch




# pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# pnpm end
export PKG_CONFIG_PATH="$HOME/.local/share/pkgconfig:$PKG_CONFIG_PATH"
