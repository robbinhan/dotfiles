set -x TERM xterm-256color


if status is-interactive
    # Commands to run in interactive sessions can go here
end


set gopath (go env GOPATH)/bin

set -x PATH $PATH /usr/local/bin $HOME/.cargo/bin /Users/funplususer/.local/bin /Users/funplususer/anaconda3/bin $HOME/.cargo/bin  $gopath
#~/.asdf/shims 


# (go env GOPATH)/bin

set EDITOR nvim



# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
eval /Users/funplususer/anaconda3/bin/conda "shell.fish" "hook" $argv | source
# <<< conda initialize <<<


alias gnvim='alacritty --title nvim --working-directory . -e $SHELL -lc "nvim" >/dev/null'
