[[ -s "$HOME/.profile" ]] && source "$HOME/.profile" # Load the default .profile


if [ -e /home/gary/.nix-profile/etc/profile.d/nix.sh ]; then . /home/gary/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer

export PATH="$HOME/.cargo/bin:$PATH"
