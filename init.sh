echo "Starting the madness"

ln -s ~/.vim/.gitignore_global ~/.gitignore_global
ln -s ~/.vim/.tmux.conf ~/.tmux.conf
ln -s ~/.vim/.vimrc ~/.vimrc
ln -s ~/.vim/.ideavimrc ~/.ideavimrc
rm ~/.gitconfig
ln -s ~/.vim/.gitconfig ~/.gitconfig
ln -s ~/.vim/.ctags ~/.ctags
ln -s ~/.vim/.psqlrc ~/.psqlrc
ln -s ~/.vim/.emacs ~/.emacs

# add . ./setup.bash to ~/bashrc
ln -s ~/.vim/.bashrc ~/.setup.bash

# vim
yes | sudo apt-get install libx11-dev libxtst-dev libxt-dev libsm-dev libxpm-dev libncurses5-dev xsel

# tmux
sudo apt-get install tmux

# nvm
wget -qO- https://raw.githubusercontent.com/creationix/nvm/v0.33.8/install.sh | bash

# public key
if [ ! -f ~/.ssh/id_rsa ]; then
  ssh-keygen
fi

mkdir undofile
alias vi=vim

sudo add-apt-repository ppa:kelleyk/emacs
sudo apt-get update
sudo apt install emacs26
git clone https://github.com/emacs-evil/evil ~/.emacs.d/evil
