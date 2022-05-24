#!/bin/bash

# ln -nfs ~/GIT/dotfiles/bash_aliases        ~/.bash_aliases
ln -nfs ~/GIT/dotfiles/bashrc.hastakh      ~/.bashrc.hastakh
ln -nfs ~/GIT/dotfiles/vimrc               ~/.vimrc
ln -nfs ~/GIT/dotfiles/tmux.conf           ~/.tmux.conf
ln -nfs ~/GIT/dotfiles/taskrc              ~/.taskrc
mkdir -p ~/bin
ln -nfs ~/GIT/dotfiles/rsync.sh            ~/bin/rsync.sh

#### SSH stuff
chmod g-w ~
mkdir -p ~/.ssh/
chmod 744 ~/.ssh
touch ~/.ssh/authorized_keys
chmod 700 ~/.ssh
chmod 755 ~/.ssh/authorized_keys
#chmod 640 ~/.ssh/authorized_keys
chmod 644 ~/.ssh/config
chmod 600 ~/.ssh/id_rsa
#chmod ~ 755 

