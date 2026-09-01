#!/usr/bin/env sh

# Usage: bind_shell_key <zsh-seq> <bash-seq> <zsh-widget> [bash-readline-func] [zsh-menuselect]
bind_shell_key() {
	local zsh_seq="$1"
	local bash_seq="$2"
	local zsh_widget="$3"
	local bash_widget="${4:-$zsh_widget}"
	local use_menuselect="${5:-0}"

	if [ -n "${ZSH_VERSION-}" ]; then
		bindkey -- "$zsh_seq" "$zsh_widget"
		if [ "$use_menuselect" = "1" ]; then
			bindkey -M menuselect "$zsh_seq" "$zsh_widget"
		fi
	elif [ -n "${BASH_VERSION-}" ]; then
		bind "\"$bash_seq\": $bash_widget"
	fi
}

delete_seq_zsh='^[[3~'
if [ -n "${ZSH_VERSION-}" ] && [ -n "${terminfo[kdch1]-}" ]; then
	delete_seq_zsh="${terminfo[kdch1]}"
fi

# delete/backspace
bind_shell_key "$delete_seq_zsh" '\e[3~' delete-char
bind_shell_key '^?' '\C-?' backward-delete-char

# CTRL + A / CTRL + E
bind_shell_key '^A' '\C-a' beginning-of-line '' 1
bind_shell_key '^E' '\C-e' end-of-line '' 1

# Ctrl+Delete / Ctrl+Backspace
bind_shell_key '^[[3;5~' '\e[3;5~' kill-word '' 1
bind_shell_key '^H' '\C-h' backward-kill-word '' 1

# CTRL + LEFT / CTRL + RIGHT
bind_shell_key '^[[1;5D' '\e[1;5D' backward-word '' 1
bind_shell_key '^[[1;5C' '\e[1;5C' forward-word '' 1
