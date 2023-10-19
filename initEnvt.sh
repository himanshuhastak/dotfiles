#!/bin/bash
#### You need to run this only once

echo "source ~/.bashrc.hastakh"             >> ~/.bashrc
ln -nfs ~/GIT/dotfiles/bash_aliases         ~/.bash_aliases
ln -nfs ~/GIT/dotfiles/bashrc.hastakh       ~/.bashrc.hastakh
ln -nfs ~/GIT/dotfiles/vimrc                ~/.vimrc
ln -nfs ~/GIT/dotfiles/tmux.conf            ~/.tmux.conf
ln -nfs ~/GIT/dotfiles/taskrc               ~/.taskrc
mkdir -p ~/bin
ln -nfs ~/GIT/dotfiles/rsync.sh             ~/bin/rsync.sh
#ln -nfs ~/GIT/dotfiles/tmux.sh             ~/bin/tmux.sh

imkdir -p ~/.tmux/plugins
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
git clone https://github.com/wenijinew/eu.tmux.git ~/.tmux/plugins/eu.tmux


#### SSH stuff
chmod g-w ~
mkdir -p                                    ~/.ssh/
chmod 744                                   ~/.ssh
touch                                       ~/.ssh/authorized_keys
#cat ~/.ssh/id_rsa.pub                      >> ~/.ssh/authorized_keys
touch                                       ~/.ssh/config

echo "
Host *
    StrictHostKeyChecking no
    UserKnownHostsFile /dev/null
    IdentityFile ~/.ssh/id_rsa
    User                hastakh
    ForwardAgent        yes
    ForwardX11          yes
    ForwardX11Trusted   yes
    #RemoteCommand      exec bash --login && cd /
    #controlmaster       auto
    #controlpath         ~/.ssh/control-%h-%p-%r
    #ControlPersist      yes
    BatchMode           yes
    PasswordAuthentication no
" >> ~/.ssh/config

echo "
Host github.com
    Hostname ssh.github.com
    Port 443
    User git" >> ~/.ssh/config


chmod 755                               ~/.ssh/authorized_keys
#chmod 640                              ~/.ssh/authorized_keys
chmod 644                               ~/.ssh/config
chmod 600                               ~/.ssh/id_rsa
chmod 644                               ~/.ssh/id_rsa.pub
chmod 700                               ~/.ssh
#chmod 755 ~


