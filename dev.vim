""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" File: dev.vim
"
" Description: Global settings applicable for all files
"
" Date (M/D/Y)         Name            Description
" 11/03/2017           unicman   	Created
"
" Usage:
" On windows using cmd as administrator:
" mklink _vimrc c:\um-git\dev-tools\dev.vim
"
" On Linux:
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set background=light

if has('gui_running')
	" Good font
	set guifont=Courier\ New

	" Sufficient size window
	set lines=1000
	set columns=150

	" Spelling check
	set spell
endif

" Allow mouse controls
if has('mouse')
	set mouse=a
endif

" Avoid annoying ~ backup files
set nobackup

" Instead of annoying bell for any error, better to flash screen!
set visualbell

" Allow backspaces for indent and insert
set backspace=indent,start

" Cool syntax highlighting
syntax on

" Always show current position
set ruler

" Show number column
set number

" Ignore case when searching
set ignorecase

" When searching try to be smart about cases 
set smartcase

" Show the first match for the pattern, while you are still typing it
set incsearch

" Be smart when using tabs
set	smarttab		

" Does the right thing (mostly) in programs
set smartindent

" Turns on auto-indentation
set autoindent

" Highlight on the line your cursor is currently on.
set cursorline

" diff windows should be vertically split
set diffopt+=vertical

" Open file / tag under cursor new tab
map <C-\> :tab split<CR>:exec("tag ".expand("<cword>"))<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" VIM plugin manager
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Dynamic plugin loader, just load/clone any plugin under vimfiles/bundle
" folder!
execute pathogen#infect()

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugin settings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" fugitive
set statusline="%<%f\ %h%m%r%{fugitive#statusline()}%=%-14.(%l,%c%V%)\ %P"

" fugitive-gitlab.vim
let g:fugitive_gitlab_domains = ['https://orahub.oraclecorp.com']

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" File type specific settings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
filetype plugin indent on

autocmd Filetype javascript setlocal tabstop=2 shiftwidth=2 softtabstop=2 nowrap expandtab
autocmd Filetype json setlocal tabstop=2 shiftwidth=2 softtabstop=2 nowrap expandtab
autocmd Filetype html setlocal tabstop=2 shiftwidth=2 softtabstop=2 nowrap expandtab
autocmd Filetype xml setlocal tabstop=2 shiftwidth=2 softtabstop=2 nowrap expandtab
autocmd Filetype xslt setlocal tabstop=2 shiftwidth=2 softtabstop=2 nowrap expandtab
autocmd Filetype yaml setlocal tabstop=2 shiftwidth=2 softtabstop=2 nowrap expandtab
autocmd Filetype python setlocal tabstop=4 shiftwidth=4 softtabstop=4 nowrap expandtab
autocmd Filetype java setlocal tabstop=4 shiftwidth=4 softtabstop=4 nowrap expandtab
autocmd Filetype sh setlocal tabstop=4 shiftwidth=4 softtabstop=4 nowrap expandtab
autocmd Filetype groovy setlocal tabstop=4 shiftwidth=4 softtabstop=4 nowrap expandtab
autocmd Filetype vim setlocal tabstop=4 shiftwidth=4 softtabstop=4 nowrap expandtab
autocmd Filetype plantuml setlocal tabstop=4 shiftwidth=4 softtabstop=4 nowrap expandtab

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugin settings - NERDtree
"
" NOTE: Kept at the last because otherwise all commands and settings get
" applied to tree window instead of actual file.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Tagbar tree view to show for source code
if exists(':TagbarToggle')
    autocmd Filetype javascript,json,html,yaml,python,java,sh TagbarToggle
endif

let NERDTreeRespectWildIgnore=1

" Nerdtree - open explorer if no files specified
"autocmd StdinReadPre * let s:std_in=1

"autocmd Filetype javascript,json,html,yaml,python,java,sh if argc() != 0 && !exists("s:std_in") | NERDTree | endif

"autocmd BufRead,BufNewFile d:/dev/* NERDTree
"autocmd BufRead,BufNewFile d:/scratch/* NERDTree
"autocmd BufRead,BufNewFile c:/to_delete/* NERDTree

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugin settings - ALE - Python Customization
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

autocmd FileType python let g:ale_python_pylint_options='--module-naming-style=any --const-naming-style=any --class-naming-style=any --function-naming-style=any --method-naming-style=any --attr-naming-style=any --argument-naming-style=any --variable-naming-style=any --class-attribute-naming-style=any --inlinevar-naming-style=any --disable=multiple-statements,line-too-long,superfluous-parens,trailing-whitespace,old-style-class,bare-except,missing-docstring,too-many-instance-attributes,bad-whitespace --generated-members=os'

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugin settings - javacomplete2
" 
" To see autocomplete work, press Control-X Control-O
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

autocmd FileType java let g:JavaComplete_ShowExternalCommandsOutput = 1
autocmd FileType java let g:JavaComplete_UsePython3=0
autocmd FileType java let g:JavaComplete_JavaviLogfileDirectory=$TMP
autocmd FileType java let g:JavaComplete_JavaviDebug=1
autocmd FileType java let g:JavaComplete_ImportOrder=[ 'com', 'oracle', 'org', 'javax', 'java' ]
autocmd FileType java let g:JavaComplete_CompletionResultSort=1

autocmd FileType java setlocal omnifunc=javacomplete#Complete
autocmd FileType java setlocal completefunc=javacomplete#CompleteParamsInfo

"autocmd FileType java nmap <F4> <Plug>(JavaComplete-Imports-AddSmart)
"autocmd FileType java imap <F4> <Plug>(JavaComplete-Imports-AddSmart)
"autocmd FileType java nmap <F5> <Plug>(JavaComplete-Imports-Add)
"autocmd FileType java imap <F5> <Plug>(JavaComplete-Imports-Add)
"autocmd FileType java nmap <F6> <Plug>(JavaComplete-Imports-AddMissing)
"autocmd FileType java imap <F6> <Plug>(JavaComplete-Imports-AddMissing)
"autocmd FileType java nmap <F7> <Plug>(JavaComplete-Imports-RemoveUnused)
"autocmd FileType java imap <F7> <Plug>(JavaComplete-Imports-RemoveUnused)

"if filereadable('c:\Program Files\Git\bin\bash.exe')
"	set shell=c:\Program\ Files\Git\bin\bash.exe
"endif
