" runtime bundle/vim-pathogen/autoload/pathogen.vim

" ---- don't clutter filesystem with lots of swap files {{{1
	set directory=$HOME/.vim/swap//
	if !isdirectory(&directory)
		call mkdir(&directory, "p")
	endif
" }}}

" --- preserve undo when closed {{{1
	set undofile
	set undodir=$HOME/.vim/undo//
	if !isdirectory(&undodir)
		call mkdir(&undodir, "p")
	endif
	set undolevels=1000
	set undoreload=10000
" }}}

" ---- misc cfgs {{{1
	set mouse=a 
	set hlsearch
	set background=dark
	set backspace=indent,eol,start
	set nocp
	set nojoinspaces
	set splitright
	set splitbelow
" }}}

" --- set sane defaults for truecolor codes {{{1
    let &t_8f="\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b="\<Esc>[48;2;%lu;%lu;%lum"
" }}}

" set clipboard=autoselectplus,exclude:cons\|linux

" ---- mappings for usual stuff {{{1
	" on the same key as \, and I don't really use the | motion anyway
	let maplocalleader = '|'
	" make Y behave like other capitals
	noremap Y y$

	" don't force set clipboard to always clip {{{2
	" instead, use these convenience bindings
		noremap <Leader>y "+y
		vnoremap <Leader>Y "+y
		nnoremap <Leader>Y "+y$
		noremap <Leader>p "+p
		noremap <Leader>P "+P
		noremap <Leader>d "+d
		noremap <Leader>D "+D
	"}}}

	" Quit all one-handed mapping
	nnoremap ZA :qa<CR>

	" quick mappings for search and Subvert {{{2
		nnoremap s :s###<Left><Left>
		nnoremap S :S###<Left><Left>
	" }}}

	" Tab navigation {{{2
		nnoremap <C-N> :tabnew<CR>
		nnoremap <C-P> :tabnew
	" }}}

	" always center current line after movement {{{2
		nnoremap <ScrollWheelUp> 3k
		nnoremap <ScrollWheelDown> 3j
		nnoremap <silent> <expr> j (v:count == 0 ? 'gj' : 'j')
		nnoremap <silent> <expr> k (v:count == 0 ? 'gk' : 'k')
		vnoremap <silent> <expr> j (v:count == 0 ? 'gj' : 'j')
		vnoremap <silent> <expr> k (v:count == 0 ? 'gk' : 'k')
		nnoremap <C-U> 11k
		nnoremap <C-D> 11j
		nnoremap <Down> gj
		nnoremap <Up> gk
		" nnoremap j jzz
		" nnoremap k kzz
		" nnoremap # #zz
		" nnoremap * *zz
		" nnoremap n nzz
		" nnoremap N Nzz
		" nnoremap G Gzz
		" nnoremap <PageUp> <PageUp>zz
		" nnoremap <PageDown> <PageDown>zz
	"}}}

	" Use the arrow keys to move through soft wrapped lines {{{2
		inoremap <Down> <C-o>gj
		inoremap <Up> <C-o>gk
		inoremap <PageUp> <C-o><PageUp>
		inoremap <PageDown> <C-o><PageDown>
		inoremap <ScrollWheelUp> <C-o>3k
		inoremap <ScrollWheelDown> <C-o>3j
	"}}}

	" Undo remap changes {{{2
		nnoremap U <C-r>
		nnoremap <C-r> echo "I confuse people"<CR>
		inoremap <c-u> <c-g>u<c-u>
		inoremap <c-w> <c-g>u<c-w>
	"}}}

	if has('nvim')
		:tnoremap <C-[> <C-\><C-n>
	endif

	" Get Visual block to work
	" :map <S-C-B> <Esc>v<C-Q>
	" :imap <S-C-B> <Esc>v<C-Q>
	
	" line bubbling {{{2
		nnoremap <silent> <C-Up> :silent! m--<CR>
		nnoremap <silent> <C-Down> :silent! m+<CR>
		vnoremap <silent> <C-Up> :<C-u>silent! '<,'>m '<-2<CR>gv=gv
		vnoremap <silent> <C-Down> :<C-u>silent! '<,'>m '>+1<CR>gv=gv
	" }}}

	" increment with keypad {{{2
		nnoremap <kPlus> <C-A>
		nnoremap <kMinus> <C-X>
		nnoremap + <C-A>
		nnoremap - <C-X>
		vnoremap <kPlus> <C-A>gv
		vnoremap <kMinus> <C-X>gv
		vnoremap + <C-A>gv
		vnoremap - <C-X>gv
	"}}}

	" shortcut for selecting previously inserted text {{{2
		nnoremap gV `[v`]
	" }}}

	" remap useless gs to inserting newlines on demand {{{2
		nnoremap <silent> gs :<C-U>call append(line('.'), repeat([''], v:count1))<CR>
		nnoremap <silent> gS :<C-U>call append(line('.')-1, repeat([''], v:count1))<CR>
	"}}}

	" map gz to split a line at cursor on demand {{{2
		nnoremap <silent> gz i<CR><C-G>k<Esc>
		nnoremap <silent> gZ i<CR><Esc>
	"}}}
	
	" slots for unmapped commands {{{2
		nnoremap gy ggVGy
		if !empty($DISPLAY)
			nnoremap gY ggVG"+y
		else
			nnoremap gY ggVGy
		endif
		
		nnoremap gx ggVGd
		if !empty($DISPLAY)
			nnoremap gX ggVG"+d
		else
			nnoremap gX ggVGd
		endif
		
		nnoremap <silent> g. :<C-U>exe v:count1 . 'wincmd w'<CR>
		nnoremap <silent> gb :tabnew<CR>
		nnoremap <silent> gB :-tabnew<CR>
		" gc/gC
	"}}}
" }}}

" ---- Mouse details {{{1
	" source $VIMRUNTIME/mswin.vim
	if !empty($DISPLAY) || has("gui_running")
		behave xterm
	endif
	if (!has('nvim') && !empty($DISPLAY)) || $TERM =~ "screen"
		set ttymouse=xterm2
	elseif $TERM =~ "fbterm"
		set ttymouse=xterm
	endif
	set mousemodel=popup
" }}}

" ---- folding stuff {{{1
	set foldmethod=syntax
	" autocmd Filetype python set foldmethod=indent
	set foldcolumn=1
	set is
" }}}

" ---- small tweaks borrowed from skottish {{{1
	set showmode
	set shortmess+=I
	set wrap
	set textwidth=0
	set lbr
	set display=lastline
	set wildmenu
	set wildmode=list:longest,full
" }}}

" ---- borrowed from ArchArael {{{1
	set number
" }}}

" ---- my own tweaks {{{1
	set nobackup
	set nowritebackup
	set spell
	" set up autocompletion dictionary
	set dictionary+=/usr/share/dict/words
	set smartindent
	set tabstop=4
	set shiftwidth=4
	set linebreak
	set display+=lastline
" }}}

" map \m to doge
let g:doge_mapping = '<Leader>m'
let g:doge_doc_standard_python = 'numpy'

" ---- Load plugins {{{1
	packloadall

	" The following plugins are handled by pacman
	" Uncomment in the case of a local copy
	" vim-supertab:: https://github.com/ervandew/supertab.git
	" packadd supertab
	" vim-jedi:: https://github.com/davidhalter/jedi-vim
	" packadd jedi-vim
	" vim-ultisnips:: https://github.com/SirVer/ultisnips
	" packadd ultisnips

	filetype plugin on
	syntax on
" }}}

" Wailing setup
let g:wailing_opts = {
	\ 'alert': {
		\ 'fpath' : '~/Music/barn_owl_screech_modded.mp3',
	\ },
	\ 'award': {
		\ 'fpath' : "~/Music/Bayonetta/Bayonetta_-_Lets_Dance_Boys.mp3",
		\ 'start' : 3,
		\ 'length' : 71.5,
	\ },
\ }

" ---- Autopairs and Sparkup co-op {{{1
	let g:sparkupMaps = 0
	au FileType xml imap <buffer> <c-e> <Esc>:let b:autopairs_enabled=0<CR>gi<Plug>SparkupExecute<Esc>:let b:autopairs_enabled=1<CR>gi
	au FileType html imap <buffer> <c-e> <Esc>:let b:autopairs_enabled=0<CR>gi<Plug>SparkupExecute<Esc>:let b:autopairs_enabled=1<CR>gi
	au FileType htmldjango imap <buffer> <c-e> <Esc>:let b:autopairs_enabled=0<CR>gi<Plug>SparkupExecute<Esc>:let b:autopairs_enabled=1<CR>gi
	au FileType smarty imap <buffer> <c-e> <Esc>:let b:autopairs_enabled=0<CR>gi<Plug>SparkupExecute<Esc>:let b:autopairs_enabled=1<CR>gi
"}}}

" ---- SuperTab and Jedi {{{1
" Turn on omni completion
" set omnifunc=syntaxcomplete#Complete
	set completeopt=menuone,preview,longest

	let g:SuperTabDefaultCompletionType = "context"
	let g:SuperTabLongestHighlight = 1
	let g:jedi#show_call_signatures = "0"
	let g:jedi#auto_initialization = 0
" }}}

" ---- UltiSnips {{{1
	let g:UltiSnipsEditSplit = "vertical"
" }}}

" ---- Printing options {{{1
set pdev=Virtual_PDF_Printer
set printoptions=number:y,syntax:y,paper:letter,wrap:y,left:0.5in,right:0.5in,top:0.5in,bottom:0.5in
" }}}

" ---- Highlight extra whitespace {{{1
	au InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
	au InsertLeave * match ExtraWhitespace /\s\+$/
	highlight ExtraWhitespace ctermbg=darkred guibg=darkred
" }}}

" ---- UI Tweaks {{{1
	colors sk_inkpot
	if has("gui_running")
		set guioptions=c
		" noremap <F11> :call FullScreen()<CR>
	endif

	noremap <S-F11> :call ToggleStatus()<CR>
" }}}

" ---- FUNCS AND CMDS {{{1
	command! SpaceEqs :'<,'>s/\([^><!= ]\)=\([^= ]\)/\1 = \2/g
	command! SpaceCommas :'<,'>s/\([^ ]\),\([^ ]\)/\1, \2/g
	command! Unventilate :set tw=1000000|normal! gggqG\<Esc\>:set tw=0\<CR\>
	command! Ventilate :call Ventilate()
	command! -nargs=1 TabRename :call settabvar(tabpagenr(), 'tabname', <q-args>)|redraw!
	command! Reload :source $MYVIMRC

	function! FontSizeIncrement(...) " {{{2
		if !has('gui_running')
			return
		endif

		let l:font_info = matchlist(&guifont, '\v(.*)( [0-9]*)')
		let l:font_face = l:font_info[1]
		let l:font_size = str2nr(l:font_info[2])
		let l:font_size = l:font_size + str2nr(a:1)
		let &guifont=l:font_face . ' ' .  l:font_size
	endfunction
	" }}}

	function! RegToTmux(...) " {{{2
		if a:0 == 0
			let l:reggy = '"'
		else
			let l:reggy = a:1
		endif

		call system('xargs -0 tmux set-buffer -b vim_reg_type', getregtype(l:reggy))
		call system('xargs -0 tmux set-buffer -b vim_reg', getreg(l:reggy, 1))
	endfunction " }}}

	function! WCGoal(...) " {{{2
		if exists('b:pb')
			let wc = WordCount()
			let b:pb.cur_value = wc > b:pb.max_value ? b:pb.max_value : wc
			call b:pb.paint()
		endif
	endfunction " }}}

	function! WCGoalSetup(...) " {{{2
		if !exists('b:pb')
			let wc_goal = a:0 ? a:1 : 500
			let b:pb = vim#widgets#progressbar#NewSimpleProgressBar("WC: ", wc_goal)
		endif
		let b:wcp_timer = timer_start(1000, 'WCGoal', {'repeat': -1})
	endfunction
	" }}}

	function! TmuxToReg(...) "{{{2
		if a:0 == 0
			let l:reggy = '"'
		else
			let l:reggy = a:1
		endif

		let reg_contents = system('tmux show-buffer -b vim_reg')
		let reg_type = system('tmux show-buffer -b vim_reg_type -')

		call setreg(l:reggy, reg_contents, reg_type)
	endfunction "}}}

	command! -nargs=* Hc call DoPrint('<args>') " {{{2
	function! DoPrint(args)
		let colorsave=g:colors_name
		color default
		exec 'hardcopy '.a:args
		exec 'color '.colorsave
	endfunction " }}}

	let g:fullScreened = 0
	function! FullScreen(...) " {{{2
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

	function! ToggleStatus() " {{{2
		if &laststatus > 0
			set laststatus=0
		else
			set laststatus=2
		endif
	endfunction " }}}

	function! WriteMode(...) " {{{2
		" hi underlines gui=underline cterm=underline
		" sign define wholeline linehl=underlines
		if has("gui_running")
			set columns=999
			set lines=999
			set guifont=Monospace\ 32
		else
			if exists("+lines")
				set lines=999
			endif
			if exists("+columns")
				set columns=999
			endif
			if getenv('TERM') =~ "xterm-kitty"
				silent !kitty @ set-font-size 0
				silent !kitty @ set-font-size +32
				autocmd QuitPre * silent !kitty @ set-font-size 0
			endif
		endif
		setlocal nospell
		Goyo 80x16
		Limelight
	endfunction " }}}

	function! Ventilate() " {{{2
		" https://www.english-grammar-revolution.com/list-of-conjunctions.html
		let l:save = winsaveview()
		let l:old = @/

		" break up at vital punctuation marks
		%s/\([.,?!;:]"\?\) /\1\r/ge

		" for, and, nor, but, or, yet, so
		%s/ \<\(for\|and\|nor\|but\|or\|yet\|so\)\>/\r\1/ge

		" after, although
		" once
		" since
		" than
		" till
		" unless
		" until
		%s/ \<\(after\|although\|once\|since\|than\|till\|unless\|until\)\>/\r\1/ge

		" as, as if, as long as, as much as, as soon as, as though
		%s/ \<as\>\( \<\%\(if\|long as\|much as\|soon as\|though\)\>\?\)\?/\ras\1/ge

		" even if, even though, if, only if, though
		%s/ \(\<\%\(even\|only\)\?\> \)\?\(\<\%\(if\|though\)\>\)/\r\1\2/ge

		" in order that, in case
		%s/ in \(\<order that\>\|\<case\>\)/\r in \1/ge

		" provided that, so that, that
		%s/ \(\%\(\<provided\>\|\<so\>\|\<in order\>\) \)\?that/\r\1that/ge

		" when, whenever, where, whenever, while
		%s/ \<wh\(en\%\(ever\)\?\|ere\%\(ver\)\?\|ile\)\>/\rwh\1/ge

		call winrestview(l:save)
		call histdel('search', -1)
		let @/ = l:old

	endfunction
	" }}}

	function! ShowTooLong(...) " {{{2
		let cols = 80

		if a:0 > 0
			let cols = a:1
		endif

		exec 'normal! /\v^.{' . cols . '}\zs.*$' . "\<CR>"
	endfunction " }}}

	" http://vim.wikia.com/wiki/Word_frequency_statistics_for_a_file
	function! WordFrequency(caseSensitive) range " {{{2
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
	function! WordCount() " {{{2
		let currentmode = mode()
		if !exists('g:lastmode_wc')
			let g:lastmode_wc = currentmode
		endif
		" if we modify file, open a new buffer, be in visual ever, or switch modes
		" since last run, we recompute.

		if &buftype != 'terminal' && (&modified || !exists('b:wordcount') || currentmode =~? '\c.*v' || currentmode != g:lastmode_wc)
			let g:lastmode_wc = currentmode
			let wc_info = wordcount()

			if has_key(wc_info, 'visual_words')
				let b:wordcount = wc_info['visual_words']
			else
				let b:wordcount = wc_info['words']
			endif

			return b:wordcount
		elseif &buftype != 'terminal'
			return b:wordcount
		else
			return 'N/A'
		endif
	endfunction " }}}

	function! QuickPTPB() "{{{2
		let fpath = fnameescape(expand("%:p"))
		exec '!curl -i -F c=@' . fpath .' https://ptpb.pw'
	endfunction
	"}}}

	function! ToggleReturn() "{{{2
		" Kinda need to resist the temptation to ventilate when writing
		if !exists('b:disable_return')
			let b:disable_return = 1
		else
			let b:disable_return = !b:disable_return
		endif
		if b:disable_return
			inoremap <buffer> <CR> <Nop>
		else
			silent iunmap <buffer> <CR>
		endif
	endfunction

	function! ToggleNav() "{{{2
		" Kinda need to resist the temptation to ventilate when writing
		if !exists('b:disable_nav')
			let b:disable_nav = 1
		else
			let b:disable_nav = !b:disable_nav
		endif
		if b:disable_nav
			inoremap <buffer> <Left> <Nop>
			inoremap <buffer> <Right> <Nop>
			inoremap <buffer> <Up> <Nop>
			inoremap <buffer> <Down> <Nop>
		else
			silent iunmap <buffer> <Left>
			silent iunmap <buffer> <Right>
			silent iunmap <buffer> <Up>
			silent iunmap <buffer> <Down>
		endif
	endfunction
	" }}}
	" }}}

	function! ToggleOnlyAddInInsertMode() "{{{2
		" remove the previous mapping
		if !exists('b:disable_del_and_bs')
			" assume when we are called, we want to disable it the first time
			let b:disable_del_and_bs = 1
		else
			let b:disable_del_and_bs = !b:disable_del_and_bs
		endif
		if b:disable_del_and_bs
			inoremap <buffer> <BS> <Nop>
			inoremap <buffer> <Del> <Nop>
		else
			let autopairs_exists = exists('b:autopairs_loaded') && exists('g:AutoPairsMapBS')
			if autopairs_exists && b:autopairs_loaded && g:AutoPairsMapBS
				inoremap <buffer> <silent> <BS> <C-R>=AutoPairsDelete()<CR>
			else
				silent iunmap <buffer> <BS>
			endif
			silent iunmap <buffer> <Del>
		endif
	endfunction "}}}

	function! CurrentSpellSuggest()
		return spellsuggest(expand('<cWORD>'))
	endfunction

	function! CurrentSwapWord(word)
		exec 'normal! ciw' . a:word . "\<Esc>"
	endfunction
"}}}

" ---- STATUSLINE {{{1
	set statusline=%{winnr('$')\ >\ 1?'['.winnr().']':''}	   "window number
	set statusline+=%{pathshorten(expand('%:p'))}	   "tail of the filename
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

" ---- TABLINE {{{1
if exists("+showtabline")
	function! MyTabLine()
		let s = ''
		let wn = ''
		let t = tabpagenr()
		let i = 1
		while i <= tabpagenr('$')
			let buflist = tabpagebuflist(i)
			let winnr = tabpagewinnr(i)
			let s .= '%' . i . 'T'
			let s .= (i == t ? '%1*' : '%2*')
			let s .= ' '
			let wn = tabpagewinnr(i,'$')

			let s .= (i== t ? '%#TabNumSel#' : '%#TabNum#')
			let s .= i
			if tabpagewinnr(i,'$') > 1
				let s .= '.'
				let s .= (i== t ? '%#TabWinNumSel#' : '%#TabWinNum#')
				let s .= (tabpagewinnr(i,'$') > 1 ? wn : '')
			end

			let s .= ' %*'
			let s .= (i == t ? '%#TabLineSel#' : '%#TabLine#')
			let bufnr = buflist[winnr - 1]
			let file = bufname(bufnr)
			let buftype = getbufvar(bufnr, 'buftype')
			let tabname = gettabvar(i, 'tabname')

			if tabname != ''
				let s .= '[' . tabname . ']::'
			endif

			if buftype == 'nofile'
				if file =~ '\/.'
					let file = substitute(file, '.*\/\ze.', '', '')
				endif
			else
				let file = fnamemodify(file, ':p:t')
			endif

			if file == ''
				let file = '[No Name]'
			endif

			let s .= file
			let s .= (i == t ? '%m' : '')
			let i = i + 1
		endwhile
		let s .= '%T%#TabLineFill#%='
		return s
	endfunction
	set stal=1
	set tabline=%!MyTabLine()
endif
" }}}

" --- GVIM WINDOW TITLE {{{1
set titlestring=%(%{gettabvar(tabpagenr(),'tabname')}\ %)%t\ %m\ (%{expand('%:p:h')})\ -\ %{v:servername}
" }}}

" ---- FTYPES {{{1
	let g:xml_syntax_folding=1
	au FileType xml  setlocal foldmethod=syntax
	au FileType yaml setlocal expandtab ts=2 sw=2
	au FileType python setlocal expandtab ts=4
	au FileType cpp  setlocal tags+=~/.vim/tags/cpp
	au FileType voomtree setlocal wrap
	au FileType tsv setlocal nowrap tabstop=20 list
	" ---- Prose Types {{{2
		au FileType text setlocal foldmethod=marker
		au FileType markdown setlocal complete+=k
		au FileType markdown call SuperTabSetDefaultCompletionType("<c-n>")
		au FileType asciidoc setlocal autoindent textwidth=70 wrapmargin=0 formatoptions=tcqn complete+=k
		au FileType asciidoc setlocal comments=:// commentstring=//\ %s
		au FileType asciidoc setlocal formatlistpat=^\\s*[-*+.]\\+\\s\\+\\%\\(\\S\\+\\)\\@=\\\\|^\\s*\\d\\+\\.\\s\\+\\\\|^\\s*<\\d\\+>\\s\\+\\\\|^\\s*[a-zA-Z.]\\.\\s\\+\\\\|^\\s*[ivxIVX]\\+\\.\\s\\+
		au FileType asciidoc noremap <buffer> <LocalLeader>w <Esc>:SemanticLinebreaks!<CR>
		au FileType asciidoc noremap <buffer> <LocalLeader>W <Esc>:SemanticLinebreaks<CR>
		au FileType asciidoc call SuperTabSetDefaultCompletionType("<c-n>")
	"}}}

	" Restore Jedi bindings under localleader {{{2
		au FileType python setlocal omnifunc=jedi#completions
		au FileType python nnoremap <silent> <buffer> <LocalLeader>g :call jedi#goto_assignments()<CR>
		au FileType python nnoremap <silent> <buffer> <LocalLeader>d :call jedi#goto_definitions()<CR>
		au FileType python nnoremap <silent> <buffer> <LocalLeader>r :call jedi#rename()<CR>
		au FileType python nnoremap <silent> <buffer> K :call jedi#show_documentation()<CR>
		au FileType python nnoremap <silent> <buffer> <LocalLeader>n :call jedi#usages()<CR>
	" }}}
	au BufReadCmd *.epub call zip#Browse(expand("<amatch>"))
	au BufRead,BufNewFile *.xrdb setlocal filetype=xdefaults
	au BufRead,BufNewFile *.adoc setlocal filetype=asciidoc
	au BufRead,BufNewFile *.gradle setlocal filetype=groovy
	au BufRead,BufNewFile *.tsv setlocal filetype=tsv
" }}}

" ---- TAB VISIBILITY {{{1
	highlight SpecialKey ctermfg=1
	set list
	set listchars=tab:▸⪢,eol:¬,nbsp:␣
" }}}

" ---- PERFORMANCE {{{1
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

" ---- LEADER KEY MAPPINGS {{{1
	" ------ MANAGE TABS AND BUFFERS {{{2
		" map \b to buffers for tab and \w to tab list
		nnoremap <Leader>b :Clap buffers<CR>
		" nnoremap <Leader>w :Unite -buffer-name=tabs tab -vertical -winwidth=40 -quit<CR>
		" let unite be the tab sidebar
		" set showtabline=0
		" switch to a tab that already has a buffer
		set switchbuf=usetab
	" }}}

	" ------ MISC MAPPINGS {{{2
		" map \r to rainbow toggle
		nnoremap <Leader>r :RainbowParenthesesToggle<CR>

		" map \s to toggling virtual edit
		nnoremap <silent> <Leader>s :if empty(&virtualedit) \| set virtualedit=block \| else \| set virtualedit= \| endif<CR>

		" map \t in normal mode to undo tree
		nnoremap <Leader>t :UndotreeToggle<CR>

		" map \v to Voom
		nnoremap <Leader>v :VoomToggle<CR>

		" map \g to Goyo
		nnoremap <Leader>g :Goyo<CR>

		" map \e to Clap filer
		nnoremap <Leader>e :Clap filer<CR>

		" map \<BS> to toggling disabling the BS and del keys in insert mode
		nnoremap <Leader><BS> :call ToggleOnlyAddInInsertMode()<CR>
		" map \<CR> to disabling return in insert mode
		nnoremap <Leader><CR> :call ToggleReturn()<CR>
	" }}}

	" ------ Spelling / Grammar {{{2
		" map to \c to LanguageToolCheck and \C to LanguageToolClear
		nnoremap <Leader>c :LanguageToolCheck<CR>
		nnoremap <Leader>C :LanguageToolClear<CR>

		" map z= to showing spell check
		nnoremap z= :Clap spellsuggest<CR>
	" }}}

	" ------ Word lookups {{{2
		nnoremap <Leader>/   :Wordnet <C-r>=expand('<cword>')<CR><CR>
		nnoremap <Leader>/d  :WordnetSyns <C-r>=expand('<cword>')<CR><CR>
		nnoremap <Leader>/e  :Etymology<CR>
		nnoremap <Leader>/r  :ReverseDict<CR>
		nnoremap <Leader>/s  :SoundsLike<CR>
		nnoremap <Leader>/ss :SpelledLike<CR>
		vnoremap <Leader>/   <Esc>:Wordnet <C-r>=WordStudy#GetVisualSelection()<CR><CR>
		vnoremap <Leader>/d  <Esc>:WordnetSyns <C-r>=WordStudy#GetVisualSelection()<CR><CR>
		vnoremap <Leader>/e  :EtymologyV<CR>
		vnoremap <Leader>/r  :ReverseDictV<CR>
		vnoremap <Leader>/s  :SoundsLikeV<CR>
		vnoremap <Leader>/ss :SpelledLikeV<CR>
	" }}}

	" ------ Distraction free mode config {{{2
		if has("gui_running") 
			"autocmd! User GoyoEnter nested call FullScreen(1)
			"autocmd! User GoyoLeave nested call FullScreen(1)
			nnoremap <Leader>f :Limelight!! 0.75<CR>
		else
			let g:limelight_conceal_ctermfg=235
			nnoremap <Leader>f :Limelight!!<CR>
		endif
	" }}}
" }}}

" ---- convenience ft settings for Voom {{{1
	let g:voom_ft_modes = {
		\ 'markdown': 'markdown',
		\ 'asciidoc': 'asciidoc',
		\ 'python': 'python'
	\ }
	let g:loaded_netrwPlugin = 1
" }}}

" ---- Window submode {{{1
	let g:submode_always_show_submode = 1

	" We're taking over the default <C-w> setting. Don't worry we'll do
	" our best to put back the default functionality.
	call submode#enter_with('window', 'n', '', '<C-w>')

	" Go through every letter
	for key in ['a','b','c','d','e','f','g','h','i','j','k','l','m',
	\           'n','o','p','q','r','s','t','u','v','w','x','y','z']
	  " maps lowercase, uppercase and <C-key>
	  call submode#map('window', 'n', '', key, '<C-w>' . key)
	  call submode#map('window', 'n', '', toupper(key), '<C-w>' . toupper(key))
	  call submode#map('window', 'n', '', '<C-' . key . '>', '<C-w>' . '<C-'.key . '>')
	endfor

	" Go through symbols. Sadly, '|', not supported in submode plugin.
	for key in ['=','_','+','-','<','>']
	  call submode#map('window', 'n', '', key, '<C-w>' . key)
	endfor

	" Resize faster
	call submode#map('window', 'n', '', '+', '3<C-w>+')
	call submode#map('window', 'n', '', '-', '3<C-w>-')
	call submode#map('window', 'n', '', '<', '10<C-w><')
	call submode#map('window', 'n', '', '>', '10<C-w>>')


	" Old way, just in case.
	nnoremap <Leader>w <C-w>
" }}}

" ---- ALE {{{1
set omnifunc=ale#completion#OmniFunc
let g:ale_completion_enabled = 1
let g:ale_linters = {
	\ 'dart': ['language_server'],
\ }

let g:ale_fixers = {
	\ 'dart': ['dartfmt'],
\ }
" }}}

" ---- Clap {{{1

let g:clap_provider_spellsuggest = {
	\ 'source': function('CurrentSpellSuggest'),
	\ 'sink': function('CurrentSwapWord'),
\ }

" }}}

" vim: foldmethod=marker
