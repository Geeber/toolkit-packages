" Loads the Vundle Vim plugin manager. To install:
"
" 1) Clone the vundle repo:
" $ git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle
"
" 2) Load Vundle in ~/.vimrc:
" source ~/.vim/vundle.vim
"
" 3) Run :BundleInstall in vim
"

filetype off

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

Bundle 'gmarik/vundle'

Bundle 'kchmck/vim-coffee-script'
"Bundle 'myusuf3/numbers.vim'
Bundle 'tpope/vim-fugitive'
Bundle 'tpope/vim-surround'

" Ledger
Bundle 'ledger/vim-ledger'

filetype plugin indent on
