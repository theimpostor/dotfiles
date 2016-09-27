#!/bin/sh

PREV_DIR=`pwd`
SCRIPT_DIR=`dirname $0`
cd "$SCRIPT_DIR"

cat .bashrc >> ~/.bashrc

mkdir ~/vimtmp
cat .vimrc >> ~/.vimrc

for f in .ackrc .gitconfig .minttyrc ; do
    ln -s `pwd`/$f ~/$f
done

cat <<EOF

To install Vundle run:
$ git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
$ vim +PluginInstall +qall

YouCompleteMe install:
$ sudo apt install build-essential cmake python-dev python3-dev
$ cd ~/.vim/bundle/YouCompleteMe
$ ./install.py

EOF


cd "$PREV_DIR"
