# .bashrc

# User specific aliases and functions
# Source global definitions
if [ -f /etc/bashrc ]; then
        . /etc/bashrc
fi

# search ~/bin for executables
if [ -d ~/bin ]; then
    PATH="~/bin:$PATH"
fi


# colorize commads
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# handy ls aliases
alias ll='ls -l'
alias la='ls -A'
alias l='ls -CF'

# verbose file operations
alias mv='mv -vi'
alias cp='cp -vi'
alias rm='rm -vi'
alias ln='ln -v'

smiley () { if [ $? == 0 ]; then echo '#';else echo '!';fi; }
# colorize prompt
case "$TERM" in
xterm*|rxvt*)
        PS1='\[\e[1;34m\]\u\[\e[m\]\[\e[0;34m\]@\[\e[m\]\[\e[1;34m\]\h\[\e[m\] \[\e[1;37m\]\w\[\e[m\] \[\e[1;31m\]$(smiley)\[\e[m\] \[\033]0;\u@\H:\w\007\]'
        ;;
screen*)
        PS1='\[\e[1;34m\]\u\[\e[m\]\[\e[0;34m\]@\[\e[m\]\[\e[1;34m\]\h\[\e[m\] \[\e[1;37m\]\w\[\e[m\] \[\e[1;31m\]$(smiley)\[\e[m\] \[\033]0;\u@\H:\w\007\]'
        ;;
*)
        PS1='\[\e[34;1m\]\u@\H\[\e[0m\] \w \[\e[31;1m\]\$\[\e[0m\] '
        ;;
esac

