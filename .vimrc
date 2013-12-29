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

" Keymaps
" Line numbering on/off
:nnoremap <C-N><C-N> :set invnumber<CR>
" Open new tab
:nnoremap <C-T> :tabnew<CR>
" Turn search highlight on/off
:nnoremap <C-H> :set invhlsearch<CR>
" Show hidden chars/leading/trailing spaces
:nnoremap <C-L> :set listchars=tab:>-,eol:$,trail:-

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
amenu Utils.Format\ XML :call FormatXml()<cr>
amenu Utils.UpsertsToCsv :call UpsertsToCsv()<cr>
amenu Utils.LastLookToCsv :call LastLookToCsv()<cr>

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
colorscheme solarized




