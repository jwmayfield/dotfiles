set -g fish_key_bindings fish_vi_key_bindings
set -g HOMEBREW_PREFIX /opt/homebrew
set -g XDG_CONFIG_HOME -$HOME/.config

starship init fish | source

source $XDG_CONFIG_HOME/fish/alias.fish
source $HOMEBREW_PREFIX/opt/asdf/asdf.fish
