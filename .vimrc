" stuffs
set mouse=a 
set hlsearch
set background=dark
set backspace=indent,eol,start
set nocp
set clipboard=unnamed
source $VIMRUNTIME/mswin.vim

" folding stuff
set foldmethod=syntax
" autocmd Filetype python set foldmethod=indent
set foldcolumn=1
set is

" small tweaks borrowed from skottish
set showmode
set shortmess+=I
set wrap
set textwidth=0
set lbr
set display=lastline
set wildmenu
set wildmode=list:longest,full

" borrowed from ArchArael
set number

" my own tweaks
set nobackup
set nowritebackup
set spell
set smartindent
set linebreak
set display+=lastline

" Things for new files
:nmap <C-n> :tabnew<CR>
:imap <C-n> <Esc>:tabnew<CR>

" Get Visual block to work
:map <S-C-B> <Esc>v<C-Q>
:imap <S-C-B> <Esc>v<C-Q>

filetype plugin on
syntax on
