"------------------------------------------------------------------------------
" File: $HOME/.vimrc
" Author: Ilias Tsitsimpis <i.tsitsimpis@gmail.com>
"------------------------------------------------------------------------------

"------------------------------------------------------------------------------
" Enable Vundle
"------------------------------------------------------------------------------
filetype off            " Required by Vundle
set rtp+=~/.vim/bundle/vundle
call vundle#begin()

" makes Vundle use `https` when building repo url
let g:vundle_default_git_proto = 'https'

" Github original repos
Plugin 'gmarik/vundle'
Plugin 'kien/ctrlp.vim'
Plugin 'jamessan/vim-gnupg'
Plugin 'tomasr/molokai'
Plugin 'tpope/vim-surround'
Plugin 'scrooloose/syntastic'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-unimpaired'
Plugin 'myusuf3/numbers.vim'
Plugin 'majutsushi/tagbar'
Plugin 'iliastsi/hasksyn'
" Github repos of user 'vim-scripts'
Plugin 'grep.vim'
Plugin 'tComment'

" All of your Plugins must be added before the following line
call vundle#end()


"------------------------------------------------------------------------------
" Standard stuff.
"------------------------------------------------------------------------------
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
set incsearch           " Incremental search
set noautoindent        " I indent my code myself
set scrolloff=5         " Keep a context when scrolling
set nomodeline          " Disable modeline for security reasons
set esckeys             " Cursor keys in insert mode
"set gdefault           " Use 'g' flag by default with :s/foo/bar/
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

" Create Greek dictionary
" mkspell ~/.vim/spell/el /usr/share/hunspell/el_GR

" Escape with jk
inoremap jk <esc>


"------------------------------------------------------------------------------
" Colors
"------------------------------------------------------------------------------
set t_Co=256
let g:rehash256 = 1 " Alternative sheme under development
colo molokai        " Set colorscheme

" Highlight text over 80 columns
let w:m1=matchadd('ErrorMsg', '\%>80v.\+', -1)
" Apply it to every window
" (see http://vim.wikia.com/wiki/Detect_window_creation_with_WinEnter)
autocmd VimEnter * autocmd WinEnter * let w:created=1
autocmd VimEnter * let w:created=1
autocmd WinEnter *
    \ if !exists('w:created') |
    \ let w:m1=matchadd('ErrorMsg', '\%>80v.\+', -1) |
    \ endif


"------------------------------------------------------------------------------
" Configure plugins
"------------------------------------------------------------------------------
" TagBar
let g:tagbar_left = 1
let g:tagbar_autoclose = 1
nnoremap <silent> <leader>t :TagbarToggle<CR>

" AirLine symbols
let g:airline_symbols = {}
let g:airline_left_sep = '▶'
let g:airline_right_sep = '◀'
let g:airline_symbols.linenr = '␤ '
let g:airline_symbols.branch = '⎇ '
" Control which sections get truncated and at what width
let g:airline#extensions#default#section_truncate_width = {
    \ 'b': 60,
    \ 'x': 70,
    \ 'y': 70,
    \ 'z': 40,
    \ }
" Mixed-indent errors
let g:airline#extensions#whitespace#enabled = 1
let g:airline#extensions#whitespace#mixed_indent_algo = 1

" Syntastic
let g:syntastic_enable_balloons = 0
let g:syntastic_haskell_checkers = ['hdevtools', 'hlint']
"let g:syntastic_python_checkers = ['python', 'flake8', 'pylint']
let g:syntastic_python_checkers = ['python', 'flake8']
let g:syntastic_c_compiler_options = ' -Wall -Wextra'
let g:syntastic_c_check_header = 1
let g:syntastic_c_auto_refresh_includes = 1
let g:syntastic_c_config_file = '.syntastic_c_config'

" GnuPG
let g:GPGExecutable = "gpg2"


"------------------------------------------------------------------------------
" File-type specific settings.
"------------------------------------------------------------------------------
syntax on

" Starting with Vim 7, the filetype of empty .tex files defaults to
" 'plaintex' instead of 'tex', which results in vim-latex not being loaded.
" The following changes the default filetype back to 'tex':
let g:tex_flavor = 'latex'

" Enabled file type detection and file-type specific plugins.
filetype plugin indent on

" Matchit already installed in newer versions of vim.
" No need to add this onto vundle. We only need to configure it.
runtime macros/matchit.vim

" C code
au FileType                 c,cpp
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

" Git commit message
function! CommitMessages()
    set spelllang=en_us spell
    let g:git_ci_msg_user = substitute(system("git config --get user.name"),
              \ '\n$', '', '')
    let g:git_ci_msg_email = substitute(system("git config --get user.email"),
              \ '\n$', '', '')

    nmap <leader>s oSigned-off-by: <C-R>=printf("%s <%s>",
              \ g:git_ci_msg_user, g:git_ci_msg_email)<CR><ESC>0
    nmap <leader>r oReviewed-by: <C-R>=printf("%s <%s>",
                \ g:git_ci_msg_user, g:git_ci_msg_email)<CR><ESC>0
endf
au FileType                 gitcommit
    \ call CommitMessages()
au BufWinEnter COMMIT_EDITMSG,*.diff,*.patch,*.patches.txt
    \ call CommitMessages()

" Mail
function! MailSnip(type, ...)
    let sel_save = &selection
    let &selection = "inclusive"
    let reg_save = @@

    if a:0  " Invoked from Visual mode, use gv command.
        silent execute "normal! gvc[...]"
    elseif a:type == 'line'
        silent exe "normal! '[V']c[...]"
    else
        silent exe "normal! `[v`]c[...]"
    endif

    let &selection = sel_save
    let @@ = reg_save
endfunction

au FileType                 mail
    \ set spelllang=en_us,el spell
au FileType                 mail
    \ nnoremap <silent> <leader>n :set opfunc=MailSnip<CR>g@
au FileType                 mail
    \ vnoremap <silent> <leader>n :<C-U>call MailSnip(visualmode(), 1)<CR>


"------------------------------------------------------------------------------
" Use Greek letters in command mode
"------------------------------------------------------------------------------
set langmap=ΑA,ΒB,ΨC,ΔD,ΕE,ΦF,ΓG,ΗH,ΙI,ΞJ,ΚK,ΛL,ΜM,ΝN,ΟO,ΠP,QQ,ΡR
set langmap+=ΣS,ΤT,ΘU,ΩV,WW,ΧX,ΥY,ΖZ,αa,βb,ψc,δd,εe,φf,γg,ηh,ιi,ξj
set langmap+=κk,λl,μm,νn,οo,πp,qq,ρr,σs,τt,θu,ωv,ςw,χx,υy,ζz
