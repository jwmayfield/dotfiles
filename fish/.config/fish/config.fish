set -g fish_key_bindings fish_vi_key_bindings
set -g HOMEBREW_PREFIX /opt/homebrew
set -g XDG_CONFIG_HOME $HOME/.config

eval (/opt/homebrew/bin/brew shellenv)
starship init fish | source

source $XDG_CONFIG_HOME/fish/alias.fish
source /opt/homebrew/opt/asdf/libexec/asdf.fish

fish_add_path /opt/homebrew/opt/openjdk/bin
