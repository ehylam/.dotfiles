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

# PHP brew
set -gx PATH /usr/local/opt/php@8.2/bin $PATH

# NVM
function __check_rvm --on-variable PWD --description 'Do nvm stuff'
  status --is-command-substitution; and return

  if test -f .nvmrc; and test -r .nvmrc;
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
if test -f /Users/ericlam/miniforge3/bin/conda && status is-interactive
    eval /Users/ericlam/miniforge3/bin/conda "shell.fish" "hook" $argv | source
end
# <<< conda initialize <<<


# pnpm
set -gx PNPM_HOME "/Users/ericlam/Library/pnpm"
set -gx PATH "$PNPM_HOME" $PATH
set -gx PATH "$HOME/.cargo/bin" $PATH;
# pnpm end


set --export ANDROID_SDK_ROOT $HOME/Library/Android/sdk;

set -gx PATH $ANDROID_SDK_ROOT/emulator $PATH;
set -gx PATH $ANDROID_SDK_ROOT/platform-tools $PATH;