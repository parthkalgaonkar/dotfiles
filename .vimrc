set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
	Plugin 'VundleVim/Vundle.vim'
	Plugin 'arcticicestudio/nord-vim'
	Plugin 'preservim/nerdtree'
call vundle#end()
filetype plugin on

colorscheme nord
set relativenumber number
