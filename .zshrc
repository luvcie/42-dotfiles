export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME=""

# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  zsh-vi-mode
  git
  zsh-syntax-highlighting
  colored-man-pages
  zsh-autosuggestions
  extract
)

source $ZSH/oh-my-zsh.sh

eval "$(zoxide init zsh)"

export PATH=~/homebrew/bin:$PATH
export PATH=/mnt/nfs/homes/USERNAME/.local/share/junest/bin:$PATH
export PATH="$PATH:/mnt/nfs/homes/USERNAME/.junest/usr/bin_wrappers"
export PATH="/mnt/nfs/homes/USERNAME/homebrew/bin:$PATH"

function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

eval "$(starship init zsh)"
