# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm

export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting

export PATH="$PATH:$HOME/.local/bin" # Add pip stuff

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

eval "$(direnv hook bash)"

# added by Miniconda2 4.3.11 installer
# export PATH="/home/gary/opt/miniconda2/bin:$PATH"

if [ -e /home/gary/.nix-profile/etc/profile.d/nix.sh ]; then . /home/gary/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer

# OPAM configuration
. /home/gary/.opam/opam-init/init.sh > /dev/null 2> /dev/null || true

export HOSTALIASES=~/.hosts

[ -s ~/.credentials ] && . ~/.credentials

export GENISYS_DATA="$HOME/dev/arena/genisys-data"
export ANSIBLE_VAULT_PASSWORD_FILE="/home/gary/dev/arena/godzilla/scripts/ansible_vault_lpass.sh"
export ANSIBLE_HOST_KEY_CHECKING=false
export ANSIBLE_SCP_IF_SSH=smart
export AWS_PROFILE=staging

export PATH="$HOME/.cargo/bin:$PATH"

export BOOT_JVM_OPTIONS="-XX:-OmitStackTraceInFastThrow -client -XX:+TieredCompilation -XX:TieredStopAtLevel=1 -Xverify:none"

export EDITOR='emacs -nw -q'

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/home/gary/.sdkman"
[[ -s "/home/gary/.sdkman/bin/sdkman-init.sh" ]] && source "/home/gary/.sdkman/bin/sdkman-init.sh"
# Load pyenv automatically by adding
# the following to ~/.bashrc:

export PATH="/home/gary/.pyenv/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
