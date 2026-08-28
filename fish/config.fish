set -g fish_key_bindings fish_vi_key_bindings
set -g HOMEBREW_PREFIX /opt/homebrew
set -g XDG_CONFIG_HOME $HOME/.config

eval (/opt/homebrew/bin/brew shellenv)
starship init fish | source

source $XDG_CONFIG_HOME/fish/alias.fish

fish_add_path /opt/homebrew/opt/openjdk/bin
fish_config theme choose Nord

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH
export PATH="$HOME/.local/bin:$PATH"

# groundcrew: mise must run after all other PATH edits
/Users/jason.mayfield/.local/bin/mise activate fish | source
