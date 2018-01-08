"filetype plugin indent on
"Set multiple filetypes for snipmate
"au BufNewFile,BufRead *.Rnw setfiletype rnoweb.tex
"set listchars=tab:>-,eol:$,trail:-
"set ruler
"set laststatus=2
"set statusline=%F%m%r%h%w[%L][%{&ff}]%y[%p%%][%04l,%04v]
"set wildmenu
set nocompatible
source $VIMRUNTIME/vimrc_example.vim
source $VIMRUNTIME/mswin.vim
behave mswin

set diffexpr=MyDiff()
function! MyDiff()
  let opt = '-a --binary '
  if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
  if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
  let arg1 = v:fname_in
  if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
  let arg2 = v:fname_new
  if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
  let arg3 = v:fname_out
  if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
  let eq = ''
  if $VIMRUNTIME =~ ' '
    if &sh =~ '\<cmd'
      let cmd = '""' . $VIMRUNTIME . '\diff"'
      let eq = '"'
    else
      let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
    endif
  else
    let cmd = $VIMRUNTIME . '\diff'
  endif
  silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3 . eq
endfunction

" Maximize screen on startup
au GUIEnter * simalt ~x

set guifont=Consolas:h12:cANSI
set backupdir=c:/lib/vim/backup
set directory=c:/lib/vim/backup
set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4
set smarttab
set showmatch
set digraph
set autoindent
set ruler
set showcmd
set ttyfast
set laststatus=2
set statusline=%F%m%r%h%w\ (%{&ff}){%Y}\ [%l,%v][%p%%][%04l,%04v]
set wildmenu
set wildmode=list:longest
set title
set hlsearch
set incsearch
set backspace=indent,eol,start
set cursorline

" Keymaps
" Line numbering on/off
:nnoremap <C-N><C-N> :set invnumber<CR>
" Open new tab
:nnoremap <C-T> :tabnew<CR>
" Turn search highlight on/off
:nnoremap <C-H> :set invhlsearch<CR>
" Show hidden chars/leading/trailing spaces
:nnoremap <C-L> :set listchars=tab:>-,eol:$,trail:-<CR>
" Toggle cursorline
:nnoremap <C-;> :set invcursorline<CR>


" Prettyprint XML buffer
function! FormatXml()  
    %! xmllint --format -
    set ft=xml
endfunction

function! UpsertsToCsv()
    %s/\(\S\+ \d\+:\d\+:\d\+\),\(\d\+\) .*\.u\.upd\[`\([^;]\+\);.*\"\(SPDEE\|MAHI1\)\".*/\1\.\2,\3,\4/g
endfunction

function! LastLookToCsv() 
    %s/.*log:\(\d\+-\d\+-\d\+ \d\+:\d\+:\d\+\),.*Client: id='\(\S\+\) .*key: \([^\]]\+\)\].*currentClOrdId: \([^\]]\+\)\].*symbol: \([^\]]\+\)\].*price='\(\d\+\.\d\+\)', mid=\(\d\+\.\d\+\)'.*/\1,\2,\3,\4,\5,\6,\7/g
endfunction

function! FormatOrderBook()
    %s/,\s\+\(\S\+=\)/,/g | %s/\[O[^\]]\+\]//g | %s/,\+$//g | %s/^\s\+//g
endfunction


function! AggMetrics() 
    %v/MarketDataMetrics\|======/d
    %s/^\(\d\+-\d\+-\d\+ \d\+:\d\+:\d\+\),\(\d\+\) .*/\1\.\2,/g
    %s/.*Events processed | \(\d\+\) .*/\1,/g
    %s/.* STHandOff.*average=\(\S\+\) .*max=\(\S\+\).*/\1,\2/g 
    %s/.* \(SlowQuote\|PickUp\|MdsConversion\|EndToEnd\|BeforeAdd\|Receipt\).*average=\(\S\+\) .*max=\(\S\+\).*\n/\2,\3,/g
    %s/,\n/,/g
    execute "normal! 1GItime,events,slowquote_avg,slowquote_max,pickuptoend_avg,pickuptoend_max,mds_avg,mds_max,endtoend_avg,endtoend_max,beforeadd_avg,beforeadd_max,receipttobuf_avg,receipttobuf_max,sthandoff_avg,sthandoff_max\n\e"
endfunction

function! ParNew()
    %v/ParNew/d
    %s/.*ParNew:\s\+\(\d\+\)K->\(\d\+\)K(\(\d\+\)K), \(\d\+\.\d\+\) secs] \(\d\+\)K->\(\d\+\)K(\(\d\+\)K), \(\d\+\.\d\+\) secs.*/\1,\2,\3,\4,\5,\6,\7,\8/g
endfunction
    
" %s/\(\d\+-\d\+-\d\+\) \(\d\+:\d\+:\d\+\),\(\d\+\) .*orderId=\([^,]\+\),.*client=\([^,]\+\),.*PRICE_SOURCE=\([^,]\+\),/\1/g
    

" Matchit
runtime macros/matchit.vim


highlight MatchParen ctermbg=4

" File type handling
filetype on
filetype plugin indent on
syntax enable
syntax on

" Sweave handling
au BufNewFile,BufRead *.Rnw setfiletype rnoweb.tex

compiler gcc

" Cygwin
set shell=c:/cygwin/bin/bash
set shellcmdflag=--login\ -c
set shellxquote=\"

" Menu
amenu Utils.FormatOrderBook :call FormatOrderBook()<cr>

command! -nargs=? -range Hex2dec call s:Hex2dec(<line1>, <line2>, '<args>')
function! s:Hex2dec(line1, line2, arg) range
  if empty(a:arg)
    if histget(':', -1) =~# "^'<,'>" && visualmode() !=# 'V'
      let cmd = 's/\%V0x\x\+/\=submatch(0)+0/g'
    else
      let cmd = 's/0x\x\+/\=submatch(0)+0/g'
    endif
    try
      execute a:line1 . ',' . a:line2 . cmd
    catch
      echo 'Error: No hex number starting "0x" found'
    endtry
  else
    echo (a:arg =~? '^0x') ? a:arg + 0 : ('0x'.a:arg) + 0
  endif
endfunction


" Color
"colorscheme desert
syntax enable
set background=dark
let g:zenburn_high_Contrast=1
"colorscheme zenburn
colorscheme slate

" Airline options
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'

let $TMP="c:/temp"

"DirectX
if has("directx") && $VIM_USE_DIRECTX != '0'
  set renderoptions=type:directx,geom:1,taamode:1
endif

set enc=utf-8

