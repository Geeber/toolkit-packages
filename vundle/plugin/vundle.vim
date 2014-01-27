" Loads the Vundle Vim plugin manager. To make this work, clone vundle into the
" following directory:
" $ git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle

filetype off

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

Bundle 'gmarik/vundle'

Bundle 'kchmck/vim-coffee-script'
"Bundle 'myusuf3/numbers.vim'
Bundle 'tpope/vim-fugitive'
Bundle 'tpope/vim-surround'

filetype plugin indent on
