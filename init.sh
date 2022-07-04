echo "Starting the madness"

ln -s ~/.vim/.gitignore_global ~/.gitignore_global
ln -s ~/.vim/.tmux.conf ~/.tmux.conf
ln -s ~/.vim/.vimrc ~/.vimrc
rm ~/.gitconfig
ln -s ~/.vim/.gitconfig ~/.gitconfig
ln -s ~/.vim/.ctags ~/.ctags
ln -s ~/.vim/.psqlrc ~/.psqlrc
mkdir ~/.config/alacritty
mkdir ~/.vim/undodir
ln -s ~/.vim/alacritty.yml ~/.config/alacritty/alacritty.yml

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

git clone https://github.com/k-takata/minpac.git ~/.vim/pack/minpac/opt/minpac
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

sudo apt-get install silversearcher-ag

sudo apt install curl
cp -s ~/.vim/plugins.sbt ~/.sbt/1.0/plugins/plugins.sbt
