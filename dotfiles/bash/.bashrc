source -- "$(blesh-share)"/ble.sh --attach=none

# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
*i*) ;;
*) return ;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=3000
HISTFILESIZE=6000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
  . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# Enable vi mode for bash
set -o vi

# GLOBBING IN BASH ENABLED
# ---------------------------
# Enable extended globbing patterns
shopt -s extglob

# Extended glob operators:
# *(pattern) - zero or more occurrences
# +(pattern) - one or more occurrences
# ?(pattern) - zero or one occurrence
# @(pat1|pat2) - matches pat1 or pat2
# !(pattern) - anything except pattern

# Enable recursive globbing
shopt -s globstar

# Find all Python files in current directory and subdirectories
#ls **/*.py
# Find all directories containing config files
#echo **/config*/

# Include hidden files in matches
shopt -s dotglob

#echo *                    # Includes hidden files

#-------------------------

# Terminal
export TERM=xterm-256color

# 1Password
#source <(op completion bash)


# colorize output
export GRC_ALIASES=true

# If running in a graphical environment (GNOME), set brightness keybindings
if [ "$XDG_CURRENT_DESKTOP" = "GNOME" ] || [ "$DESKTOP_SESSION" = "gnome" ]; then
  gsettings set org.gnome.shell.keybindings screen-brightness-up "['<Ctrl><Super>Up']" 2>/dev/null || true
  gsettings set org.gnome.shell.keybindings screen-brightness-down "['<Ctrl><Super>Down']" 2>/dev/null || true
fi

# gnome auto-focus
# gsettings set org.gnome.desktop.wm.preferences auto-raise "true"

# preferred text editor
export EDITOR="nvim"

#ble.sh - for ble-update command
if command -v ble &>/dev/null; then
  source $(which ble)
fi
# source -- ~/.local/share/blesh/ble.sh

# Colorful manpages
# Add to your shell config (e.g., ~/.bashrc, ~/.zshrc)
if command -v batman &>/dev/null; then
  eval "$(batman --export-env)"
fi

#bat theme
export BAT_THEME="Coldark-Dark"

# greet me
echo "w3lc0m3 h4ck3r - let the games begin! - m4ast3r y0ur cr4ft" | lolcat

# Kitty ssh config alias
alias s="kitten ssh"

# carapace
if command -v carapace &>/dev/null; then
  export CARAPACE_BRIDGES='zsh,fish,bash,inshellisense' # optional
  source <(carapace _carapace)
fi

# Atuin
 eval "$(atuin init bash)"

# zoxide
eval "$(zoxide init bash)"

#starship prompt - shell prompt
eval "$(starship init bash)"

# Attach ble.sh if loaded
if [[ ${BLE_VERSION-} ]]; then
  ble-attach
fi
