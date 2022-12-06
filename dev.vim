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

if &background == "light"
    colorscheme shine
else
    colorscheme desert
endif

" Doesn't work fully as of 17 Jan 2019
"set termguicolors

if has('gui_running')
	" Good font
	set guifont=Source\ Code\ Pro\ Medium\ for\ Powerline,JetBrains\ Mono,Consolas,Monaco,Courier\ New:h20

	" Sufficient size window
	set lines=40
	set columns=150

	" Spelling check
	set spell

    " diff windows should be vertically split
    set diffopt+=vertical

    " diff should ignore whitespaces
    set diffopt+=iwhite
endif

" Allow mouse controls
if has('mouse')
	set mouse=a
endif

" Ensure that yank 'y' uses clipboard by default
set clipboard=unnamed

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

" Open file / tag under cursor new tab
map <C-\> :tab split<CR>:exec("tag ".expand("<cword>"))<CR>

" Keyboard short cut for closing all tabs and come out of VIM
"map <C-w>q <ESC>:qa<CR>

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
"set statusline="%<%f\ %h%m%r%{fugitive#statusline()}%=%-14.(%l,%c%V%)\ %P"

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Tree-view file explorer on left side.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_browse_split = 4
let g:netrw_altv = 1
let g:netrw_winsize = 25
let g:netrw_keepdir = 0
let g:netrw_list_hide = '\(^\|\s\s\)\zs\.\S\+'
autocmd VimEnter * :Vexplore
autocmd VimEnter * if (argc() > 0 && filereadable(argv()[0])) | wincmd l | endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Detect custom filetypes based on file contents
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function! UMDetectCustomFiletype()
    let umline1 = getline(1)

    if ! has('filetype')
        if umline1 =~ "apiVersion:"
            setfiletype yaml
        elseif umline1 =~ "[DEFAULT]"
            setfiletype dosini
        endif
    endif
endfunction

augroup filetypedetect
    au BufRead,BufNewFile * call UMDetectCustomFiletype()
augroup END

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" File type specific settings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
filetype plugin indent on

autocmd FileType javascript setlocal tabstop=2 shiftwidth=2 softtabstop=2 nowrap expandtab
autocmd FileType json setlocal tabstop=2 shiftwidth=2 softtabstop=2 nowrap expandtab
autocmd FileType html setlocal tabstop=2 shiftwidth=2 softtabstop=2 nowrap expandtab
autocmd FileType xml setlocal tabstop=2 shiftwidth=2 softtabstop=2 nowrap expandtab
autocmd FileType tf setlocal tabstop=2 shiftwidth=2 softtabstop=2 nowrap expandtab
autocmd FileType xslt setlocal tabstop=2 shiftwidth=2 softtabstop=2 nowrap expandtab
autocmd FileType yaml setlocal tabstop=2 shiftwidth=2 softtabstop=2 nowrap expandtab
autocmd FileType python setlocal tabstop=4 shiftwidth=4 softtabstop=4 nowrap expandtab
autocmd FileType java setlocal tabstop=4 shiftwidth=4 softtabstop=4 nowrap expandtab
autocmd FileType sh setlocal tabstop=4 shiftwidth=4 softtabstop=4 nowrap expandtab
autocmd FileType groovy setlocal tabstop=4 shiftwidth=4 softtabstop=4 nowrap expandtab
autocmd FileType vim setlocal tabstop=4 shiftwidth=4 softtabstop=4 nowrap expandtab
autocmd FileType plantuml setlocal tabstop=4 shiftwidth=4 softtabstop=4 nowrap expandtab
autocmd FileType Dockerfile setlocal tabstop=4 shiftwidth=4 softtabstop=4 nowrap expandtab
autocmd FileType yaml.docker-compose setlocal tabstop=4 shiftwidth=4 softtabstop=4 nowrap expandtab

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugin settings - ALE - Python Customization
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Show errors and warnings in quick fix window
let g:ale_set_loclist = 0
let g:ale_set_quickfix = 0
let g:ale_open_list = 1

" Since pylint doesn't install on some Linux OS using flake8
" autocmd FileType python let g:ale_python_pylint_options='--module-naming-style=any --const-naming-style=any --class-naming-style=any --function-naming-style=any --method-naming-style=any --attr-naming-style=any --argument-naming-style=any --variable-naming-style=any --class-attribute-naming-style=any --inlinevar-naming-style=any --disable=multiple-statements,line-too-long,superfluous-parens,trailing-whitespace,old-style-class,bare-except,missing-docstring,too-many-instance-attributes,bad-whitespace --generated-members=os'

" Disable trailing blank line and whitespace warnings
let g:ale_warn_about_trailing_blank_lines = 0
let g:ale_warn_about_trailing_whitespace = 0

autocmd FileType python let g:ale_python_flake8_options='--ignore E121,E123,E126,E127,E128,E129,E201,E202,E203,E211,E221,E222,E225,E226,E231,E241,E251,E261,E265,E266,E272,E302,E303,E305,E501,E701,E702,E722,W291,W293,W391'

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugin settings - Jedi-VIM python auto complete plugin
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Bug in Jedi opens too many windows on auto complete so workaround as per
" https://github.com/davidhalter/jedi-vim/issues/870
if has("win32")
    py3 import os; sys.executable=os.path.join(sys.prefix, 'python3.exe')
endif

autocmd FileType java set completeopt-=preview
autocmd FileType python set completeopt-=preview
hi def jediFat term=bold,underline cterm=bold,underline gui=bold,underline ctermbg=Grey guibg=#555555

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugin settings - javacomplete2
"
" Usage:
" To see autocomplete work, press Control-X  + Control-O. Control-Space might
" also work.
"
" Start typing :JC and then there are variety of commands for auto
" complete. E.g. :JCimportAdd will add import of class under cursor.
"
" NOTE: This plugin was really slow so removed it.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"autocmd FileType java let g:JavaComplete_ShowExternalCommandsOutput = 1
"autocmd FileType java let g:JavaComplete_UsePython3=1
"autocmd FileType java let g:JavaComplete_JavaviLogfileDirectory=$HOME
"autocmd FileType java let g:JavaComplete_JavaviDebug=1
"autocmd FileType java let g:JavaComplete_ImportOrder=[ 'com', 'oracle', 'org', 'javax', 'java' ]
"autocmd FileType java let g:JavaComplete_CompletionResultSort=1
"
"autocmd FileType java setlocal omnifunc=javacomplete#Complete
"autocmd FileType java setlocal completefunc=javacomplete#CompleteParamsInfo
"
"" Key mapping for Using control space to bring up auto complete window
"autocmd FileType java imap c-space c x c o
"
""if filereadable('c:\Program Files\Git\bin\bash.exe')
""	set shell=c:\Program\ Files\Git\bin\bash.exe
""endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Setup java compiler
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

autocmd FileType java compiler gradle

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugin settings - ctrlp
"
" To search for files based on keywords / substrings faster.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:ctrlp_prompt_mappings = {
    \ 'AcceptSelection("e")': ['<2-LeftMouse>'],
    \ 'AcceptSelection("t")': ['<cr>'],
    \ }
let g:ctrlp_max_files=0
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_root_markers = ['pom.xml', '.p4ignore', 'gradlew']
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugin settings - vim-airline
"
" Customizations of how status and tag bar will look like.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:airline#extensions#tabline#enabled = 1
let g:airline_theme='papercolor'
let g:airline#extensions#whitespace#enabled=0

" Activate tagbar extension only for certain filetypes
let g:airline#extensions#tagbar#enabled = 0
autocmd FileType vim let g:airline#extensions#tagbar#enabled = 1
autocmd FileType java let g:airline#extensions#tagbar#enabled = 1
autocmd FileType python let g:airline#extensions#tagbar#enabled = 1

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugin settings - vim-dispatch (Vim 8)
"
" Asynchronously runs build commands and can run grep or test cases too.
"
" Usage:
" Use :Make! instead of standard :make
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:dispatch_handlers=[ 'headless' ]
autocmd BufReadPost quickfix nnoremap <buffer> r :Copen<CR>
autocmd BufReadPost quickfix nnoremap <buffer> R :Copen<CR>G

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Highlight on the line your cursor is currently on. This must be done
" after all formatting is done hence kept at the last.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"set cursorline
"set cursorcolumn
hi CursorLine   cterm=NONE ctermbg=cyan ctermfg=black guifg=black guibg=cyan
"hi Cursor       cterm=NONE ctermbg=gray ctermfg=black guifg=black guibg=gray
