# -------------------- P10K instant prompt (keep at top) --------------------
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# -------------------- Oh My Zsh --------------------
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""

# Plugins (put syntax-highlighting last)
plugins=(git zsh-autosuggestions zsh-completions zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

# ---- Powerlevel10k theme (from Arch package) ----
if [ -f /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme ]; then
  source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme
fi
# Load your personal prompt settings
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh


# -------------------- Powerlevel10k config --------------------
# Your prompt configuration file; keep this exactly as-is.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# -------------------- Environment --------------------
export TERMINAL=kitty
# PATH (optional example; uncomment if you need it)
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# -------------------- Conda (keep only the managed block) --------------------
# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/pri/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/pri/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/pri/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/pri/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

# -------------------- fzf + zoxide --------------------
# System-wide fzf bindings (Arch packages)
source /usr/share/fzf/key-bindings.zsh
source /usr/share/fzf/completion.zsh

# zoxide (smart cd)
eval "$(zoxide init zsh)"

# fzf defaults: right-side preview panel, toggle with Ctrl-/
export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS
  --height=90%
  --layout=reverse
  --border
  --preview-window=right:60%:wrap
  --bind=ctrl-/:toggle-preview
  --bind=ctrl-f:page-down,ctrl-b:page-up
"

# -------------------- LSD (colorful ls with hyperlinks) --------------------
alias ls='lsd --color=auto --group-dirs=first --icon=always --hyperlink=auto'
alias ll='lsd -lh --color=auto --group-dirs=first --hyperlink=auto'
alias la='lsd -lha --color=auto --group-dirs=first --hyperlink=auto'
alias lt='lsd --tree --color=auto --group-dirs=first --hyperlink=auto'

# -------------------- Kitty image helpers + fzf preview --------------------
# Quick inline image viewer (Kitty)
img() { kitty +kitten icat "$@"; }

# Fuzzy file picker with preview (images via icat, text via bat/head)
ff() {
  local src="${1:-.}"
  local list_cmd
  if command -v fd >/dev/null 2>&1; then
    list_cmd=(fd -H -L -t f . "$src")
  else
    list_cmd=(find "$src" -type f)
  fi
  "${list_cmd[@]}" | fzf --preview 'bash -c '\''
    mime=$(file --mime-type -Lb -- {} | cut -d: -f2 | tr -d " ")
    
    # Always clear everything first
    clear
    printf "\e_Ga=d,d=A\e\\"
    tput clear
    
    if [[ $mime == image/* ]]; then
      kitty +kitten icat --clear --transfer-mode=stream --stdin=no --place=${FZF_PREVIEW_COLUMNS}x${FZF_PREVIEW_LINES}@0x0 "{}"
    elif [[ $mime == text/* || $mime == */json || $mime == */xml || $mime == */yaml ]]; then
      if command -v bat >/dev/null 2>&1; then
        bat --style=numbers --color=always --line-range=:300 "{}"
      else
        head -n 300 "{}"
      fi
    else
      file -h "{}"
      command -v exiftool >/dev/null 2>&1 && exiftool -s "{}" 2>/dev/null | head -n 50
    fi
  '\''' --bind 'enter:execute(
      mime=$(file --mime-type -Lb -- {} | cut -d: -f2 | tr -d " ");
      if [[ $mime == image/* ]]; then
        # Open image in default viewer or specify one
        if command -v xdg-open >/dev/null 2>&1; then
          xdg-open {} >/dev/null 2>&1
        elif command -v feh >/dev/null 2>&1; then
          feh {}
        elif command -v imv >/dev/null 2>&1; then
          imv {}
        else
          kitty +kitten icat --transfer-mode=stream --stdin=no {}
          read -k1 "?Press any key to continue..."
        fi
      else
        ${EDITOR:-nano} {}
      fi
    )'
}