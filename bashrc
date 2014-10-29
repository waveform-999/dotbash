# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth
# don't modify history
bind 'revert-all-at-newline on'

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes
# useful aliases for bash color codes
source ~/.bash/bash-colors.sh

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

# put git info in prompt
source ~/.bash/git-prompt.sh
# show dirty status
GIT_PS1_SHOWDIRTYSTATE=1
# show divergence from upstream
GIT_PS1_SHOWUPSTREAM="auto"

if [ "$color_prompt" = yes ]; then
    PS1="\[$Blue\]\h\[$Color_Off\]:\[$BBlue\]\w\[$Yellow\]\$(__git_ps1)\[$Color_Off\]$ "
else
    PS1='\u@\h:\w\$ '
fi
# http://stackoverflow.com/questions/3058325/what-is-the-difference-between-ps1-and-prompt-command
# PROMPT_COMMAND='__git_ps1 ""${PS1}""'
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# marks (quicker cd)
source ~/.bash/marks

# Only enter my ssh passphrase once
# works by running a single ssh-agent at login and telling it to
# use a fixed socket with ssh-agent -a /tmp/$USER.agent : add this
# to an autostart (~/.kde/Autostart/ssh-agent), followed by ssh-add.
# export SSH_AUTH_SOCK=/tmp/$USER.agent
source ~/.bash/agent-ssh

# Fix for 256 colors in screen / vim
# http://stackoverflow.com/questions/6787734/strange-behavior-of-vim-color-inside-screen-with-256-colors
# force 256 color
if [[ $TERM==xterm ]]; then
    export TERM=xterm-256color
fi

if [[ $TERM==screen ]]; then
    export TERM=screen-256color
fi

export EDITOR='vim'

# some more ls aliases
alias ll='ls -l'
alias la='ls -A'
alias l='ls -CF'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash/bash_aliases ]; then
    . ~/.bash/bash_aliases
fi

# convert the csh aliases into bash syntax
# if [ -f ~/.csh_aliases ]; then
    # sed -e "s/alias \([a-z0-9_]*\) /alias \1=/" -e "s/\.csh/\.bash/" ~/.csh_aliases > ~/.bash_aliases 
# fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

## PATH
export PATH=$HOME/.local/bin:$HOME/bin:$PATH:$HOME/.gem/ruby/1.9.1/bin
export PATH=$HOME/.cabal/bin:$PATH
export PATH=$HOME/.bash/bin:$PATH  # bash scripts
export PATH=$HOME/src/nvim/bin:$PATH   # neovim

if [ $HOME = '/nfs/see-fs-02_users/eeaol' ]; then
    export PATH=$HOME/make/haskell/install/ghc-7.6.3/bin:$PATH
fi

laptop_canopy="/home/aaron/src/canopy/Enthought/Canopy_64bit/User"
work_canopy="/nfs/see-fs-02_users/eeaol/src/canopy/User"

laptop_anaconda="/home/aaron/src/anaconda"
alias anaconda="export PATH=$laptop_anaconda/bin:$PATH"
alias thesis="cd ~/thesis; source $laptop_anaconda/bin/activate thesis"

# Added by Canopy installer on 2013-07-02
# VIRTUAL_ENV_DISABLE_PROMPT can be set to '' to make bashprompt show that Canopy is active, otherwise 1
if [ $HOME = "/home/aaron" ]; then
    alias canopy="VIRTUAL_ENV_DISABLE_PROMPT='' source $laptop_canopy/bin/activate"
elif [ $HOME = "/nfs/see-fs-02_users/eeaol" ]; then
    alias canopy="VIRTUAL_ENV_DISABLE_PROMPT='1' source $work_canopy/bin/activate"
fi

# can't do this inside the if above because the alias isn't available
# until it ends
if [ $HOME = "/nfs/see-fs-02_users/eeaol" ]; then
    canopy
fi


# make aliases conditional on whether canopy is on or not
function canopy_wrapper {
    if [[ -z "$VIRTUAL_ENV" ]]; then
        command "$@"

    elif [ $VIRTUAL_ENV = $laptop_canopy ]; then
        APPDATA_ROOT="$HOME/src/canopy/appdata/"
        # find the most recent canopy install
        APPDATA=$(ls -d ${APPDATA_ROOT}canopy-1* | tail -n1)
        LD_LIBRARY_PATH="$APPDATA/lib:${LD_LIBRARY_PATH}" command "$@"

    elif [ $VIRTUAL_ENV = $work_canopy ]; then
        APPDATA_ROOT="$HOME/src/canopy/appdata/"
        # find the most recent canopy install
        APPDATA=$(ls -d ${APPDATA_ROOT}canopy-1* | tail -n1)
        LD_LIBRARY_PATH="$APPDATA/lib:${LD_LIBRARY_PATH}" command "$@"

    elif [ $VIRTUAL_ENV = "/apps/canopy-1.0.3/Enthought/Canopy_64bit/User" ]; then
        # other work canopy
        APPDATA=/apps/canopy/appdata/canopy-1.0.3.1262.rh5-x86_64
        LD_LIBRARY_PATH="$APPDATA/lib:${APPDATA}/lib/python2.7/site-packages/zmq:${LD_LIBRARY_PATH}" command "$@"

    else
        command "$@"
    fi
}

alias v="canopy_wrapper vim"
alias vi="canopy_wrapper vim"
alias vim="canopy_wrapper vim"
alias gvim="canopy_wrapper gvim"
alias vimdiff="canopy_wrapper vimdiff"

# virtualenvwrapper
# TODO: work on nesting these so that we can have a base environment
# to branch off from.
# see http://www.gossamer-threads.com/lists/python/python/1076939
# or possibly venv
virtualenvwrapper=$HOME/.local/bin/virtualenvwrapper.sh
if [ -f $virtualenvwrapper ]; then
    source $virtualenvwrapper
    export WORKON_HOME=$HOME/.virtualenvs
fi

# virtualenv_selector is a script in .bash/bin
# it lets us do virtualenvs based off of canopy
# I've done it like this because virtualenv_wrapper
# searches for the function using which
export VIRTUALENVWRAPPER_VIRTUALENV="virtualenv_selector"

stty stop undef # unmap ctrl-S (for vim-ipython)

# Work specific package management
if [ $HOME = '/nfs/see-fs-02_users/eeaol' ]; then
    # --- Package management... (duplicated in csh.login for safety)
    if [ -e /apps/.setup/bash ]
        then source /apps/.setup/bash
    fi
    # set up these apps and don't tell me about it
    app setup ImageMagick gimp mendeley libreoffice > /dev/null
fi

# use self compiled libraries
# TODO: consider setting these in aliases to the programs that need them
export PKG_CONFIG_PATH=$HOME/.local/lib/pkgconfig
export LD_LIBRARY_PATH=$HOME/lib/:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=$HOME/.local/lib/:$LD_LIBRARY_PATH
MANPATH=$MANPATH:$HOME/share/man
