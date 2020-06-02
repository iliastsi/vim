"----------------------------------------------------------------------
" File: $HOME/.vimrc
" Author: Ilias Tsitsimpis <i.tsitsimpis@gmail.com>
"----------------------------------------------------------------------

"----------------------------------------------------------------------
" Plugins
"----------------------------------------------------------------------
call plug#begin('~/.vim/plugged')

Plug 'ctrlpvim/ctrlp.vim'
" Plug 'fatih/molokai'
Plug 'crusoexia/vim-monokai'
Plug 'tpope/vim-surround'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-unimpaired'
"Plug 'iliastsi/hasksyn'
Plug 'tpope/vim-commentary'
Plug 'w0rp/ale'

" Install extensions with:
" :CocInstall coc-python
" :CocInstall coc-clangd
Plug 'neoclide/coc.nvim', {'branch': 'release'}

call plug#end()


"----------------------------------------------------------------------
" Standard stuff
"----------------------------------------------------------------------
set nocompatible        " Disable vi compatibility
set nojoinspaces        " Do not insert two spaces after a '.'
set nobackup            " Do not keep a backup file
set textwidth=0         " Don't wrap words by default
set showcmd             " Show (partial) command in status line
set showmatch           " Show matching brackets
set showmode            " Show current mode
set cursorline          " Highlight current line
set number              " Line number
set ignorecase          " No case sensitive matching
set wildmenu            " Way cooler command line mode completion
set smartcase           " Case insensitive matching (unless given upper case)
set nofoldenable        " Disable folding
set incsearch           " Incremental search
set noautoindent        " I indent my code myself
set scrolloff=5         " Keep a context when scrolling
set nomodeline          " Disable modeline for security reasons
"set gdefault            " Use 'g' flag by default with :s/foo/bar/
set magic               " Use 'magic' patterns (extended regular expressions)
set tabstop=4           " Number of spaces <tab> counts for
set shiftwidth=4        " Used by syntax files
set et                  " Expand Tabs
set ttyfast             " We have a fast terminal connection
set hlsearch            " Highlight search matches
set encoding=utf-8      " Set default encoding to UTF-8
set nostartofline       " Do not jump to first character with page commands
set laststatus=2        " status line
set backspace=2         " Allow backspacing in insert mode
set wildmode=list:longest " Path/file expansion in colon-mode
set colorcolumn=80
set spelllang=en_us,el  " Set default spelling language
set spell

" Create Greek dictionary
" # apt install myspell-el-gr
" :mkspell ~/.vim/spell/el /usr/share/hunspell/el_GR

" Escape with jk
inoremap jk <esc>


"----------------------------------------------------------------------
" Colors
" Enable true-colors using termguicolors
" See `:h xterm-true-color` for the details
"----------------------------------------------------------------------
syntax enable
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
set termguicolors
colo monokai
" colo molokai
" colo desert

" hi clear CocErrorSign
" hi clear CocWarningSign
" hi clear CocInfoSign
" hi clear CocHintSign
" hi clear ALEError
" hi clear ALEWarning


"----------------------------------------------------------------------
" Configure plugins
"----------------------------------------------------------------------

" CtrlP
"------
" Do not delete the cache files upon exiting Vim
let g:ctrlp_clear_cache_on_exit = 0

" AirLine symbols
"----------------
" Mixed-indent errors
let g:airline#extensions#whitespace#enabled = 1
let g:airline#extensions#whitespace#mixed_indent_algo = 1
let g:airline#extensions#whitespace#checks = [ 'indent', 'trailing', 'long' ]
" Enable airline's native extension for ale
let g:airline#extensions#ale#enabled = 1

" Ale
"----
let g:ale_lint_on_enter = 0
let g:ale_lint_on_text_changed = 'never'
let g:ale_cache_executable_check_failures = 1

let g:ale_linters = {
\ 'haskell': ['hdevtools', 'hlint'],
\ 'python': ['python', 'flake8'],
\ 'c': ['gcc'],
\}


"----------------------------------------------------------------------
" Helper functions
"----------------------------------------------------------------------
" Git commit message
function! CommitMessages()
    let g:git_ci_msg_user = substitute(system("git config --get user.name"),
              \ '\n$', '', '')
    let g:git_ci_msg_email = substitute(system("git config --get user.email"),
              \ '\n$', '', '')

    nmap <leader>s oSigned-off-by: <C-R>=printf("%s <%s>",
              \ g:git_ci_msg_user, g:git_ci_msg_email)<CR><ESC>0
    nmap <leader>r oReviewed-by: <C-R>=printf("%s <%s>",
                \ g:git_ci_msg_user, g:git_ci_msg_email)<CR><ESC>0
endf

" Mail
function! MailSnip(type, ...)
    let sel_save = &selection
    let &selection = "inclusive"
    let reg_save = @@

    if a:0  " Invoked from Visual mode, use gv command.
        silent execute "normal! gvc> [...]"
    elseif a:type == 'line'
        silent exe "normal! '[V']c> [...]"
    else
        silent exe "normal! `[v`]c> [...]"
    endif

    let &selection = sel_save
    let @@ = reg_save
endfunction


"----------------------------------------------------------------------
" File-type specific settings.
"----------------------------------------------------------------------

" For *.h files use C syntax instead of C++
let c_syntax_for_h = 1

" Starting with Vim 7, the filetype of empty .tex files defaults to
" 'plaintex' instead of 'tex', which results in vim-latex not being loaded.
" The following changes the default filetype back to 'tex':
let g:tex_flavor = 'latex'

" Enabled file type detection and file-type specific plugins.
filetype plugin indent on

" Matchit already installed in newer versions of vim.
" No need to add this onto package. We only need to configure it.
runtime macros/matchit.vim

" C code
au FileType                 c,cpp,go
    \ setlocal cindent sw=8 ts=8 noet cino=(sw

" Haskell code
au FileType                 haskell
    \ setlocal sw=2 ts=2

" Python code
au FileType                 python
    \ setlocal sw=4 sts=4

" Latex code
au FileType                 tex
    \ setlocal tw=80 sw=2

" Git
au FileType                 gitcommit
    \ call CommitMessages()
au BufWinEnter COMMIT_EDITMSG,*.diff,*.patch,*.patches.txt
    \ call CommitMessages()

" Mail
au BufRead,BufNewFile *mutt* set filetype=mail
au FileType                 mail
    \ nnoremap <silent> <leader>n :set opfunc=MailSnip<CR>g@
au FileType                 mail
    \ vnoremap <silent> <leader>n :<C-U>call MailSnip(visualmode(), 1)<CR>

" reStructuredText
" https://docs.python.org/devguide/documenting.html
au FileType rst
    \ set sw=3 sts=3 et tw=80


"----------------------------------------------------------------------
" Use Greek letters in command mode
"----------------------------------------------------------------------
set langmap=ΑA,ΒB,ΨC,ΔD,ΕE,ΦF,ΓG,ΗH,ΙI,ΞJ,ΚK,ΛL,ΜM,ΝN,ΟO,ΠP,QQ,ΡR
set langmap+=ΣS,ΤT,ΘU,ΩV,WW,ΧX,ΥY,ΖZ,αa,βb,ψc,δd,εe,φf,γg,ηh,ιi,ξj
set langmap+=κk,λl,μm,νn,οo,πp,qq,ρr,σs,τt,θu,ωv,ςw,χx,υy,ζz
