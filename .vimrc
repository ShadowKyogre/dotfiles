runtime bundle/vim-pathogen/autoload/pathogen.vim

" stuffs
set mouse=a 
set hlsearch
set background=dark
set backspace=indent,eol,start
set nocp
" set clipboard=unnamedplus

" don't force set clipboard to always clip
" instead, use these convenience bindings

:noremap ty "+y
:noremap tY "+Y
:noremap tp "+p
:noremap tP "+P
:noremap td "+d
:noremap tD "+D

" source $VIMRUNTIME/mswin.vim
if $DISPLAY != "" || has("gui_running")
	behave xterm
endif
if !has('nvim') && $DISPLAY != "" 
	set ttymouse=xterm2
endif
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

" spelling keybindings
:inoremap <C-l> <esc>[sz=
:nnoremap <C-i> gi

" always center current line after movement
:nnoremap <ScrollWheelUp> 3kzz
:nnoremap <ScrollWheelDown> 3jzz
:nnoremap <C-U> 11kzz
:nnoremap <C-D> 11jzz
:nnoremap <Down> gjzz
:nnoremap <Up> gkzz
:nnoremap j gjzz
:nnoremap k gkzz
:nnoremap # #zz
:nnoremap * *zz
:nnoremap n nzz
:nnoremap N Nzz
:nnoremap G Gzz
:nnoremap <PageUp> <PageUp>zz
:nnoremap <PageDown> <PageDown>zz

" Use the arrow keys to move through soft wrapped lines
:inoremap <Down> <C-o>gj<C-o>zz
:inoremap <Up> <C-o>gk<C-o>zz
:inoremap <PageUp> <C-o><PageUp><C-o>zz
:inoremap <PageDown> <C-o><PageDown><C-o>zz
:inoremap <ScrollWheelUp> <C-o>3k<C-o>zz
:inoremap <ScrollWheelDown> <C-o>3j<C-o>zz

" Undo remap changes
:nnoremap U <C-r>
:inoremap <c-u> <c-g>u<c-u>
:inoremap <c-w> <c-g>u<c-w>

" hop out of insert mode quickly
:imap ii <Esc>

if has('nvim')
	:tnoremap ii <C-\><C-n>
endif

" Get Visual block to work
" :map <S-C-B> <Esc>v<C-Q>
" :imap <S-C-B> <Esc>v<C-Q>

" increment with keypad
:nnoremap <kPlus> <C-A>
:nnoremap <kMinus> <C-X>
:nnoremap + <C-A>
:nnoremap - <C-X>

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

au InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
au InsertLeave * match ExtraWhitespace /\s\+$/
highlight ExtraWhitespace ctermbg=darkred guibg=darkred

if has("gui_running")
	colors darkblue
	:map <F11> :call FullScreen()<CR>
else
	colors elflord
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
function! FullScreen(...)
	if g:fullScreened == 0
		let g:fullScreened = 1
		set guioptions-=T guioptions-=m
		if a:0 > 0
			set guioptions-=r
		endif
	else
		let g:fullScreened = 0
		set guioptions+=T guioptions+=m
		if a:0 > 0
			set guioptions+=r
		endif
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

	if &buftype != 'terminal' && (&modified || !exists('b:wordcount') || currentmode =~? '\c.*v' || currentmode != g:lastmode_wc)
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
	elseif &buftype != 'terminal'
		return b:wordcount
	else
		return 'N/A'
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
au BufRead,BufNewFile *.adoc setlocal autoindent textwidth=70 wrapmargin=0 formatoptions=ant filetype=asciidoc

" ---- TAB VISIBILITY

highlight SpecialKey ctermfg=1
set list
set listchars=tab:▸\ ,eol:¬

set synmaxcol=128
set ttyfast " u got a fast terminal
if !has('nvim')
	set ttyscroll=3
endif
set lazyredraw " to avoid scrolling problems

" rainbow parentheses
let g:rbpt_max = 16
let g:rbpt_loadcmd_toggle = 0

" buffergator
let g:buffergator_suppress_keymaps = 1
let g:buffergator_autodismiss_on_select = 0
let g:buffergator_autoexpand_on_split = 0
let g:buffergator_autoupdate = 1

" -- LEADER KEY MAPPINGS
" map \b to buffergator
:nnoremap <Leader>b :BuffergatorToggle<CR>

" map \r to rainbow toggle
:nnoremap <Leader>r :RainbowParenthesesToggle<CR>

" map \t in normal mode to undo tree
:nnoremap <Leader>t :UndotreeToggle<CR>

" map \v to Voom
:nnoremap <Leader>v :VoomToggle<CR>

" map \g to Goyo
:nnoremap <Leader>g :Goyo<CR>

" map to \c to LanguageToolCheck and \C to LanguageToolClear
:nnoremap <Leader>c :LanguageToolCheck<CR>
:nnoremap <Leader>C :LanguageToolClear<CR>

:nnoremap <Leader>d   :Wordnet <C-r>=expand('<cword>')<CR><CR>
:nnoremap <Leader>dd  :WordnetSyns <C-r>=expand('<cword>')<CR><CR>
:nnoremap <Leader>de  :Etymology<CR>
:nnoremap <Leader>dr  :ReverseDict<CR>
:nnoremap <Leader>ds  :SoundsLike<CR>
:nnoremap <Leader>dss :SpelledLike<CR>
:vnoremap <Leader>d   <Esc>:Wordnet <C-r>=WordStudy#GetVisualSelection()<CR><CR>
:vnoremap <Leader>dd  <Esc>:WordnetSyns <C-r>=WordStudy#GetVisualSelection()<CR><CR>
:vnoremap <Leader>de  :EtymologyV<CR>
:vnoremap <Leader>dr  :ReverseDictV<CR>
:vnoremap <Leader>ds  :SoundsLikeV<CR>
:vnoremap <Leader>dss :SpelledLikeV<CR>

if has("gui_running") 
	autocmd! User GoyoEnter nested call FullScreen(1)
	autocmd! User GoyoLeave nested call FullScreen(1)
	:nnoremap <Leader>f :Limelight!! 0.75<CR>
else
	let g:limelight_conceal_ctermfg=235
	:nnoremap <Leader>f :Limelight!!<CR>
endif
" -- /LEADER KEY MAPPINGS

" convenience ft settings for Voom
let g:voom_ft_modes = {'markdown': 'markdown', 'asciidoc': 'asciidoc', 'python': 'python'}
