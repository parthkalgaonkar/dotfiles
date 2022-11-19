set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
	Plugin 'VundleVim/Vundle.vim'
	Plugin 'arcticicestudio/nord-vim'
	Plugin 'preservim/nerdtree'
	Plugin 'mattn/emmet-vim'
	Plugin 'ap/vim-css-color'
call vundle#end()
filetype plugin on

let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"

set termguicolors
colorscheme nord
set relativenumber number
set autoindent smartindent
syntax on
set bs=2

nmap <silent> <F8> :call ToggleDiff()<CR>
function ToggleDiff()
	if(&diff)
		windo diffoff
	else
		windo diffthis
	endif
endfunction

function TrimTrailing()
	let l:save = winsaveview()
	keeppatterns %s/\s\+$//e
	call winrestview(l:save)
endfunction

let g:user_emmet_leader_key=','

