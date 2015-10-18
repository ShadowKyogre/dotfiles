runtime bundle/vim-pathogen/autoload/pathogen.vim

" ---- don't clutter filesystem with lots of swap files {{{
	set directory=$HOME/.vim/swap//
	if !isdirectory(&directory)
		call mkdir(&directory, "p")
	endif
" }}}

" ---- misc cfgs {{{
	set mouse=a 
	set hlsearch
	set background=dark
	set backspace=indent,eol,start
	set nocp
" }}}

" set clipboard=unnamedplus

" ---- mappings for usual stuff {{{
	" on the same key as \, and I don't really use the | motion anyway
	let maplocalleader = '|'
	" make Y behave like other capitals
	noremap Y y$

	" don't force set clipboard to always clip
	" instead, use these convenience bindings

	noremap ty "+y
	vnoremap tY "+y
	nnoremap tY "+y$
	noremap tp "+p
	noremap tP "+P
	noremap td "+d
	noremap tD "+D

	" Quit all one-handed mapping
	nnoremap ZA :qa<CR>

	" go back to last insert keybindings
	nnoremap <C-i> gi

	" always center current line after movement
	nnoremap <ScrollWheelUp> 3kzz
	nnoremap <ScrollWheelDown> 3jzz
	nnoremap <C-U> 11kzz
	nnoremap <C-D> 11jzz
	nnoremap <Down> gjzz
	nnoremap <Up> gkzz
	nnoremap j gjzz
	nnoremap k gkzz
	nnoremap # #zz
	nnoremap * *zz
	nnoremap n nzz
	nnoremap N Nzz
	nnoremap G Gzz
	nnoremap <PageUp> <PageUp>zz
	nnoremap <PageDown> <PageDown>zz

	" Use the arrow keys to move through soft wrapped lines
	inoremap <Down> <C-o>gj<C-o>zz
	inoremap <Up> <C-o>gk<C-o>zz
	inoremap <PageUp> <C-o><PageUp><C-o>zz
	inoremap <PageDown> <C-o><PageDown><C-o>zz
	inoremap <ScrollWheelUp> <C-o>3k<C-o>zz
	inoremap <ScrollWheelDown> <C-o>3j<C-o>zz

	" Undo remap changes
	nnoremap U <C-r>
	inoremap <c-u> <c-g>u<c-u>
	inoremap <c-w> <c-g>u<c-w>

	if has('nvim')
		:tnoremap <C-[> <C-\><C-n>
	endif

	" Get Visual block to work
	" :map <S-C-B> <Esc>v<C-Q>
	" :imap <S-C-B> <Esc>v<C-Q>

	" increment with keypad
	nnoremap <kPlus> <C-A>
	nnoremap <kMinus> <C-X>
	nnoremap + <C-A>
	nnoremap - <C-X>
" }}}

" ---- Mouse details {{{
	" source $VIMRUNTIME/mswin.vim
	if $DISPLAY != "" || has("gui_running")
		behave xterm
	endif
	if (!has('nvim') && !empty($DISPLAY)) || $TERM =~ "screen"
		set ttymouse=xterm2
	elseif $TERM =~ "fbterm"
		set ttymouse=xterm
	endif
	set mousemodel=popup
" }}}

" ---- folding stuff {{{
	set foldmethod=syntax
	" autocmd Filetype python set foldmethod=indent
	set foldcolumn=1
	set is
" }}}

" ---- small tweaks borrowed from skottish {{{
	set showmode
	set shortmess+=I
	set wrap
	set textwidth=0
	set lbr
	set display=lastline
	set wildmenu
	set wildmode=list:longest,full
" }}}

" ---- borrowed from ArchArael {{{
	set number
" }}}

" ---- my own tweaks {{{
	set nobackup
	set nowritebackup
	set spell
	set smartindent
	set tabstop=4
	set shiftwidth=4
	set linebreak
	set display+=lastline
" }}}

" ---- Things for new files {{{
	nnoremap <C-n> :tabnew<CR>
	inoremap <C-n> <Esc>:tabnew<CR>
" }}}

" ---- Load plugins {{{
	execute pathogen#infect()
	execute pathogen#helptags()
	filetype plugin on
	syntax on
" }}}

" ---- SuperTab and Jedi {{{
" Turn on omni completion
" set omnifunc=syntaxcomplete#Complete
	set completeopt=menuone,preview,longest

	let g:SuperTabDefaultCompletionType = "context"
	let g:jedi#show_call_signatures = "0"
	let g:jedi#auto_initialization = 0
" }}}

" ---- Printing options {{{
set pdev=Virtual_PDF_Printer
set printoptions=number:y,syntax:y,paper:letter,wrap:y,left:0.5in,right:0.5in,top:0.5in,bottom:0.5in
" }}}

" ---- Highlight extra whitespace {{{
	au InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
	au InsertLeave * match ExtraWhitespace /\s\+$/
	highlight ExtraWhitespace ctermbg=darkred guibg=darkred
" }}}

" ---- UI Tweaks {{{
	colors sk_inkpot
	if has("gui_running")
		noremap <F11> :call FullScreen()<CR>
	endif

	noremap <S-F11> :call ToggleStatus()<CR>
" }}}

" ---- FUNCS AND CMDS {{{
	command! SpaceEqs :'<,'>s/\([^><!= ]\)=\([^= ]\)/\1 = \2/g
	command! SpaceCommas :'<,'>s/\([^ ]\),\([^ ]\)/\1, \2/g

	command! -nargs=* Hc call DoPrint('<args>') " {{{
	function! DoPrint(args)
		let colorsave=g:colors_name
		color default
		exec 'hardcopy '.a:args
		exec 'color '.colorsave
	endfunction " }}}

	let g:fullScreened = 0
	function! FullScreen(...) " {{{
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
	endfunction " }}}

	function! ToggleStatus() " {{{
		if &laststatus > 0
			set laststatus=0
		else
			set laststatus=2
		endif
	endfunction " }}}

	" http://vim.wikia.com/wiki/Word_frequency_statistics_for_a_file
	function! WordFrequency(caseSensitive) range " {{{
		let all = split(join(getline(a:firstline, a:lastline)), '\A\+')
		let frequencies = {}
		for word in all
			if a:caseSensitive
				let frequencies[word] = get(frequencies, word, 0) + 1
			else
				let frequencies[tolower(word)] = get(frequencies, word, 0) + 1
			endif
		endfor
		vertical belowright new
		setlocal buftype=nofile bufhidden=hide noswapfile tabstop=20
		for [key,value] in items(frequencies)
			call append('$', key."\t".value)
		endfor
		sort i
		call setline(1, "count\twords")
	endfunction " }}}
	command! -bang -range=% WordFrequency <line1>,<line2>call WordFrequency(<bang>0)

	" see https://gist.github.com/cormacrelf/d0bee254f5630b0e93c3
	function! WordCount() " {{{
		let currentmode = mode()
		if !exists('g:lastmode_wc')
			let g:lastmode_wc = currentmode
		endif
		" if we modify file, open a new buffer, be in visual ever, or switch modes
		" since last run, we recompute.

		if &buftype != 'terminal' && (&modified || !exists('b:wordcount') || currentmode =~? '\c.*v' || currentmode != g:lastmode_wc)
			let g:lastmode_wc = currentmode
			let l:old_position = getpos('.')
			"let l:old_status = v:statusmsg
			
			redir => wordCountMsg
				if currentmode == 's'
					silent execute "insert \<C-o>"
				endif
				silent execute "normal! g\<C-g>"
			redir END

			if wordCountMsg =~ '--No lines in buffer--'
				let b:wordcount = 0
			else
				let b:split_wc = split(wordCountMsg)
				if len(b:split_wc) == 0
					let b:wordcount = 0
				else
					if index(b:split_wc, 'Selected') < 0
						let b:wordcount = str2nr(b:split_wc[11])
					else
						let b:wordcount = str2nr(b:split_wc[5])
					endif
				endif
				"let v:statusmsg = l:old_status
			endif
			call setpos('.', l:old_position)
			return b:wordcount
		elseif &buftype != 'terminal'
			return b:wordcount
		else
			return 'N/A'
		endif
	endfunction " }}}

"}}}

" ---- STATUSLINE {{{
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
" }}}

" ---- FTYPES {{{
	let g:xml_syntax_folding=1
	au FileType xml  setlocal foldmethod=syntax
	au FileType yaml setlocal expandtab
	au FileType cpp  setlocal tags+=~/.vim/tags/cpp

	" Restore Jedi bindings under localleader {{{
		au FileType python setlocal omnifunc=jedi#complete
		au FileType python nnoremap <silent> <buffer> <LocalLeader>g :call jedi#goto_assignments()<CR>
		au FileType python nnoremap <silent> <buffer> <LocalLeader>d :call jedi#goto_definitions()<CR>
		au FileType python nnoremap <silent> <buffer> <LocalLeader>r :call jedi#rename()<CR>
		au FileType python nnoremap <silent> <buffer> K :call jedi#show_documentation()<CR>
		au FileType python nnoremap <silent> <buffer> <LocalLeader>n :call jedi#usages()<CR>
	" }}}

	au BufRead,BufNewFile *.adoc setlocal autoindent textwidth=70 wrapmargin=0 formatoptions=nt filetype=asciidoc
	au BufRead,BufNewFile *.gradle setlocal filetype=groovy
" }}}

" ---- TAB VISIBILITY {{{
	highlight SpecialKey ctermfg=1
	set list
	set listchars=tab:▸\ ,eol:¬
" }}}

" ---- PERFORMANCE {{{
	set synmaxcol=128
	set ttyfast " u got a fast terminal
	if !has('nvim')
		set ttyscroll=3
	endif
	set lazyredraw " to avoid scrolling problems
	
	" rainbow parentheses
	let g:rbpt_max = 16
	let g:rbpt_loadcmd_toggle = 0
" }}}

" ---- LEADER KEY MAPPINGS {{{
	" ------ MANAGE TABS AND BUFFERS {{{
		" map \b to buffers for tab and \w to tab list
		nnoremap <Leader>b :Unite -buffer-name=bufs buffer<CR>
		nnoremap <Leader>w :Unite -buffer-name=tabs tab -quit<CR>
		" let unite be the tab sidebar
		set showtabline=0
		" switch to a tab that already has a buffer
		set switchbuf=usetab
	" }}}

	" ------ MISC MAPPINGS {{{
		" map \r to rainbow toggle
		nnoremap <Leader>r :RainbowParenthesesToggle<CR>

		" map \t in normal mode to undo tree
		nnoremap <Leader>t :UndotreeToggle<CR>

		" map \v to Voom
		nnoremap <Leader>v :VoomToggle<CR>

		" map \g to Goyo
		nnoremap <Leader>g :Goyo<CR>

		" map \e to VimFilerSplit
		nnoremap <Leader>e :VimFilerSplit<CR>
	" }}}

	" ------ Spelling / Grammar {{{
		" map to \c to LanguageToolCheck and \C to LanguageToolClear
		nnoremap <Leader>c :LanguageToolCheck<CR>
		nnoremap <Leader>C :LanguageToolClear<CR>

		" map \s to showing spell check panel
		nnoremap <Leader>s :Unite spell_suggest -buffer-name=spell_suggest<CR>
	" }}}

	" ------ Word lookups {{{
		nnoremap <Leader>d   :Wordnet <C-r>=expand('<cword>')<CR><CR>
		nnoremap <Leader>dd  :WordnetSyns <C-r>=expand('<cword>')<CR><CR>
		nnoremap <Leader>de  :Etymology<CR>
		nnoremap <Leader>dr  :ReverseDict<CR>
		nnoremap <Leader>ds  :SoundsLike<CR>
		nnoremap <Leader>dss :SpelledLike<CR>
		vnoremap <Leader>d   <Esc>:Wordnet <C-r>=WordStudy#GetVisualSelection()<CR><CR>
		vnoremap <Leader>dd  <Esc>:WordnetSyns <C-r>=WordStudy#GetVisualSelection()<CR><CR>
		vnoremap <Leader>de  :EtymologyV<CR>
		vnoremap <Leader>dr  :ReverseDictV<CR>
		vnoremap <Leader>ds  :SoundsLikeV<CR>
		vnoremap <Leader>dss :SpelledLikeV<CR>
	" }}}

	" ------ Distraction free mode config {{{
		if has("gui_running") 
			autocmd! User GoyoEnter nested call FullScreen(1)
			autocmd! User GoyoLeave nested call FullScreen(1)
			nnoremap <Leader>f :Limelight!! 0.75<CR>
		else
			let g:limelight_conceal_ctermfg=235
			nnoremap <Leader>f :Limelight!!<CR>
		endif
	" }}}
" }}}

" ---- convenience ft settings for Voom {{{
	let g:voom_ft_modes = {
		\ 'markdown': 'markdown',
		\ 'asciidoc': 'asciidoc',
		\ 'python': 'python'
	\ }
	let g:vimfiler_as_default_explorer = 1
" }}}

" ---- Shougo plugin default contexts {{{
	call vimfiler#custom#profile('default', 'context', {
		\ 'simple': 1,
		\ 'toggle': 1,
		\ 'no_quit': 1,
	\ })

	call unite#custom#profile('default', 'context', {
		\ 'toggle': 1,
		\ 'vertical': 1,
		\ 'no_quit': 1,
		\ 'wrap': 1,
		\ 'winwidth': 40,
	\ })
" }}}

" vim: foldmethod=marker
