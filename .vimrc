runtime bundle/vim-pathogen/autoload/pathogen.vim

" stuffs
set mouse=a 
set hlsearch
set background=dark
set backspace=indent,eol,start
set nocp
set clipboard=unnamed
source $VIMRUNTIME/mswin.vim
behave xterm
set ttymouse=xterm2
set mousemodel=popup

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
set tabstop=4
set shiftwidth=4
set linebreak
set display+=lastline

" Things for new files
:nmap <C-n> :tabnew<CR>
:imap <C-n> <Esc>:tabnew<CR>


" Use the arrow keys to move through soft wrapped lines
:imap <Down> <C-o>gj
:imap <Up> <C-o>gk

" Get Visual block to work
:map <S-C-B> <Esc>v<C-Q>
:imap <S-C-B> <Esc>v<C-Q>

" increment with keypad
:noremap <C-kPlus> <C-A>
:noremap <C-kMinus> <C-X>

execute pathogen#infect()
filetype plugin on
syntax on

" Turn on omni completion
" set omnifunc=syntaxcomplete#Complete
" set completeopt=menuone,preview

let g:SuperTabDefaultCompletionType = "<c-n>"
let g:jedi#show_call_signatures = "0"

" Printing options
set pdev=Virtual_PDF_Printer
set printoptions=number:y,syntax:y,paper:letter,wrap:y,left:0.5in,right:0.5in,top:0.5in,bottom:0.5in

" add tags
set tags+=~/.vim/tags/cpp

if has("gui_running")
	colors darkblue
	:map <F11> :call FullScreen()<CR>
endif

:map <S-F11> :call ToggleStatus()<CR>

" ---- FUNCS AND CMDS

command! SpaceEqs :'<,'>s/\([^><!= ]\)=\([^= ]\)/\1 = \2/g
command! SpaceCommas :'<,'>s/\([^ ]\),\([^ ]\)/\1, \2/g

command! -nargs=* Hc call DoPrint('<args>')
function! DoPrint(args)
  let colorsave=g:colors_name
  color default
  exec 'hardcopy '.a:args
  exec 'color '.colorsave
endfunction

let g:fullScreened = 0
function! FullScreen()
	if g:fullScreened == 0
		let g:fullScreened = 1
		set guioptions-=T guioptions-=m
	else
		let g:fullScreened = 0
		set guioptions+=T guioptions+=m
	endif
endfunction

function! ToggleStatus()
	if &laststatus > 0
		set laststatus=0
	else
		set laststatus=2
	endif
endfunction

" see https://gist.github.com/cormacrelf/d0bee254f5630b0e93c3
function! WordCount()
	let currentmode = mode()
	if !exists('g:lastmode_wc')
		let g:lastmode_wc = currentmode
	endif
	" if we modify file, open a new buffer, be in visual ever, or switch modes
	" since last run, we recompute.

	if &modified || !exists('b:wordcount') || currentmode =~? '\c.*v' || currentmode != g:lastmode_wc
		let g:lastmode_wc = currentmode
		let l:old_position = getpos('.')
		let l:old_status = v:statusmsg
		if currentmode == 's'
			silent execute "insert \<C-o>"
		endif
		silent execute "normal! g\<C-g>"
		if v:statusmsg == '--No lines in buffer--'
			let b:wordcount = 0
		else
			let b:split_wc = split(v:statusmsg)
			if len(b:split_wc) == 0
				let b:wordcount = 0
			else
				if index(b:split_wc, 'Selected') < 0
					let b:wordcount = str2nr(b:split_wc[11])
				else
					let b:wordcount = str2nr(b:split_wc[5])
				endif
			endif
			let v:statusmsg = l:old_status
		endif
		call setpos('.', l:old_position)
		return b:wordcount
	else
		return b:wordcount
	endif
endfunction

" ---- STATUSLINE

set statusline=%t	   "tail of the filename
set statusline+=[%{strlen(&fenc)?&fenc:'none'}, "file encoding
set statusline+=%{&ff}] "file format
set statusline+=%h	  "help file flag
set statusline+=%m	  "modified flag
set statusline+=%r	  "read only flag
set statusline+=%y	  "filetype
set statusline+=%=	  "left/right separator
set statusline+=%l[%c]/%L   "cursor line[column]/total lines
set statusline+=\ wc:%{WordCount()}	"word count
set laststatus=2

" ---- FTYPES

let g:xml_syntax_folding=1
au FileType xml setlocal foldmethod=syntax
au FileType yaml setlocal expandtab

" ---- TAB VISIBILITY

highlight SpecialKey ctermfg=1
set list
set listchars=tab:»·
