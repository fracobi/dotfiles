# ---------- PATH ----------
export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$PATH"
export PATH="$HOME/go/bin:$PATH"

#----------- COLORS FOR NMTUI---------
export NEWT_COLORS='window=white,black;border=cyan,black;textbox=white,black;button=black,cyan;actbutton=black,green'

# ---------- STARSHIP (prompt) ----------
eval "$(starship init zsh)"

# ---------- ATUIN ----------
eval "$(atuin init zsh)"

# ---------- ZOXIDE ----------
eval "$(zoxide init zsh)"

# ---------- FZF ----------
eval "$(fzf --zsh)"

# ---------- THE FUCK ----------
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

#Weylus
alias virtual-monitor-on='hyprctl output create headless WINSCREEN; hyprctl keyword monitor "WINSCREEN,1920x1080@60,3520x0,1.25"; hyprctl dispatch moveworkspacetomonitor 11 WINSCREEN'
alias virtual-monitor-off='hyprctl output remove WINSCREEN'
alias virtual-monitor-fix='systemctl --user restart pipewire wireplumber xdg-desktop-portal xdg-desktop-portal-hyprland'

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
bindkey '^R' atuin-search

# Utilizzo tasto Canc
bindkey "^[[3~" delete-char-or-list

# ---------- HISTORY ----------
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_DUPS
setopt SHARE_HISTORY

# ---------- FASTFETCH ----------
fastfetch




# pnpm
export PNPM_HOME="/home/cobi/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
