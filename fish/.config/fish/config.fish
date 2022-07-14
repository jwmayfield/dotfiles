set -g fish_key_bindings fish_vi_key_bindings
set -g HOMEBREW_PREFIX /opt/homebrew
set -g XDG_CONFIG_HOME $HOME/.config

eval (/opt/homebrew/bin/brew shellenv)
starship init fish | source

source $XDG_CONFIG_HOME/fish/alias.fish
source $HOMEBREW_PREFIX/opt/asdf/asdf.fish

# Platform.sh config
fish_add_path $HOME/.platformsh/bin
if test -f $HOME/.platformsh/shell-config.rc
	$HOME/.platformsh/shell-config.rc
end
