# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"


# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

export GTK_IM_MODULE=ibus
export XMODIFIERS=@im=ibus
export QT_IM_MODULE=ibus
#export JAVA_HOME=/usr/java/jdk1.6.0_31/
#export JDK_HOME=/usr/java/jdk1.6.0_31/ 
export MVN_HOME="/home/peterb/apps/maven/"

# Source global definitions
if [ -f /etc/bashrc ]; then
        . /etc/bashrc
fi

# User specific aliases and functions
# search ~/bin for executables
#if [ -d ~/bin ]; then
#    PATH="~/bin:$PATH"
#fi

# colorize commads
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias lg='gvfs-ls'

# handy ls aliases
alias ll='ls -l'
alias la='ls  -A'
alias l='ls -CF'

# verbose file operations
alias mv='mv -v'
alias cp='cp -v'
alias rm='rm -v'
alias ln='ln -v'

#alias matlab='matlab -nodesktop -nosplash'

smiley () { if [ $? == 0 ]; then echo '$';else echo '!';fi; }
# colorize prompt
case "$TERM" in
xterm*|rxvt*)
        PS1='\[\e[1;34m\]\u\[\e[m\]\[\e[0;34m\]@\[\e[m\]\[\e[1;34m\]\h\[\e[m\] \[\e[1;37m\]\w\[\e[m\] \[\e[1;32m\]$(smiley)\[\e[m\] \[\033]0;\u@\H:\w\007\]'
        ;;
screen*)
        PS1='\[\e[1;34m\]\u\[\e[m\]\[\e[0;34m\]@\[\e[m\]\[\e[1;34m\]\h\[\e[m\] \[\e[1;37m\]\w\[\e[m\] \[\e[1;32m\]$(smiley)\[\e[m\] \[\033]0;\u@\H:\w\007\]'
        ;;
*)
        PS1='\[\e[34;1m\]\u@\H\[\e[0m\] \w \[\e[32;1m\]\$\[\e[0m\] '
        ;;
esac

renice -n 20 -p $$