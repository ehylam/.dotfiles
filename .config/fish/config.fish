set fish_greeting ""

set -gx TERM xterm-256color

# theme
set -g theme_color_scheme terminal-dark
set -g fish_prompt_pwd_dir_length 1
set -g theme_display_user yes
set -g theme_hide_hostname no
set -g theme_hostname always

# aliases
alias ls "ls -p -G"
alias la "ls -A"
alias ll "ls -l"
alias lla "ll -A"
alias g git
command -qv nvim && alias vim nvim

set -gx EDITOR nvim

set -gx PATH bin $PATH
set -gx PATH ~/bin $PATH
set -gx PATH ~/.local/bin $PATH

# NodeJS
set -gx PATH node_modules/.bin $PATH

# Go
set -g GOPATH $HOME/go
set -gx PATH $GOPATH/bin $PATH

# # PHP brew
# set -gx PATH /usr/local/opt/php@8.2/bin $PATH
set -Ux fish_user_paths "/usr/local/opt/php@8.1/bin" $fish_user_paths
set -Ux fish_user_paths "/usr/local/opt/php@8.1/sbin" $fish_user_paths


# NVM
function __check_rvm --on-variable PWD --description 'Do nvm stuff'
    status --is-command-substitution; and return

    if test -f .nvmrc; and test -r .nvmrc
        nvm use
    else
    end
end

switch (uname)
    case Darwin
        source (dirname (status --current-filename))/config-osx.fish
    case Linux
        source (dirname (status --current-filename))/config-linux.fish
    case '*'
        source (dirname (status --current-filename))/config-windowkitt
        s.fish
end

set LOCAL_CONFIG (dirname (status --current-filename))/config-local.fish
if test -f $LOCAL_CONFIG
    source $LOCAL_CONFIG
end

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
if test -f /Users/ericlam/miniconda3/bin/conda
    eval /Users/ericlam/miniconda3/bin/conda "shell.fish" hook $argv | source
else
    if test -f "/Users/ericlam/miniconda3/etc/fish/conf.d/conda.fish"
        . "/Users/ericlam/miniconda3/etc/fish/conf.d/conda.fish"
    else
        set -x PATH /Users/ericlam/miniconda3/bin $PATH
    end
end
# <<< conda initialize <<<


# pnpm
set -gx PNPM_HOME /Users/ericlam/Library/pnpm
set -gx PATH "$PNPM_HOME" $PATH
set -gx PATH "$HOME/.cargo/bin" $PATH
# pnpm end


set --export ANDROID_SDK_ROOT $HOME/Library/Android/sdk

set -gx PATH $ANDROID_SDK_ROOT/emulator $PATH
set -gx PATH $ANDROID_SDK_ROOT/platform-tools $PATH

# Define functions for different Neovim configurations
function nvim-default
    env NVIM_APPNAME=nvim nvim $argv
end

function nvim-kickstart
    env NVIM_APPNAME=kickstart nvim $argv
end

function nvim-alt
    env NVIM_APPNAME=alt nvim $argv
end

function nvim-lite
    env NVIM_APPNAME=lite nvim $argv
end

function nvim-vii
    env NVIM_APPNAME=vii nvim $argv
end


function nvim-ecovim
    env NVIM_APPNAME=ecovim nvim $argv
end


# Create a function to select the Neovim configuration and open a file if specified
function nvims
    set items default lite kickstart alt vii
    set selected_config (printf "%s\n" $items | fzf --prompt=" Neovim Config = " --height=50% --layout=reverse --border --exit-0)

    switch $selected_config
        case default
            nvim-default $argv
        case kickstart
            nvim-kickstart $argv
        case lite
            nvim-lite $argv
        case vii
            nvim-vii $argv
        case alt
            nvim-alt $argv
        case *
            echo "Invalid selection"
    end
end

set -U fish_user_paths /usr/local/opt/ruby/bin $fish_user_paths


source ~/.phpbrew/phpbrew.fish
