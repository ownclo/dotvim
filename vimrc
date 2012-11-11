"color darkblue
set keymap=russian-jcukenwin
set iminsert=0
set imsearch=0
set hidden
set nocompatible
set history=10000
set softtabstop=4
set laststatus=2
set showmatch
set switchbuf=useopen
set numberwidth=5
"set hlsearch
set showtabline=2
set winwidth=79
set scrolloff=2
set cmdheight=2
set backup
set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set backspace=indent,eol,start
set showcmd
set nowrap
syntax on
filetype plugin indent on
set wildmode=longest,list
set wildmenu
set wildignore-=hidden

"function! MapCR()
"  nnoremap <cr> :nohlsearch<cr>
"endfunction
"call MapCR()
map Q @q
command! W :w
command! Q :q

:set t_Co=256 " 256 colors
:set background=dark
colorscheme grb256
set cursorline
:hi CursorLine guifg=none guibg=none term=none cterm=none ctermbg=236 ctermfg=none

set grepprg=grep\ -nH\ $*
let g:tex_flavor='latex'
let g:Tex_DefaultTargetFormat='pdf'
let g:Tex_MultipleCompileFormats='dvi,pdf'

au BufEnter *.hs compiler ghc
autocmd BufReadPost fugitive://* set bufhidden=delete
set statusline=%<%f\ %h%m%r%{fugitive#statusline()}%=%-14.(%l,%c%V%)\ %P

nnoremap <tab> <c-w>w
nnoremap <S-tab> <c-w>W
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l
" Insert a hash rocket with <c-l>
imap <c-l> <space>-><space>
" Can't be bothered to understand ESC vs <c-c> in insert mode
imap <c-c> <esc>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" OPEN FILES IN DIRECTORY OF CURRENT FILE
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
cnoremap %% <C-R>=expand('%:h').'/'<cr>
map <leader>e :edit %%
map <leader>v :view %%
map ,c :NERDTreeToggle <cr>
map <C-g><C-w> :Gwrite<cr>
map <C-g><C-c> :Gcommit<cr>
map <C-g><C-r> :Gread<cr>
map <C-g><C-g> :Gstatus <cr>
map <C-g><C-t> :Git tr<cr>
map <C-g><C-d> :Gdiff<cr>
map Q @q

let g:haddock_browser = "/usr/bin/google-chrome"
let g:ghc = "/usr/bin/ghc"
set nu
set autoindent
set autowrite
set smartindent
set incsearch
set guioptions-=T
syntax on
function InsertTabWrapper()
 let col = col('.') - 1
 if !col || getline('.')[col - 1] !~ '\k'
 return "\<tab>"
 else
 return "\<c-p>"
 endif
endfunction
imap <tab> <c-r>=InsertTabWrapper()<cr>
set complete=""
set complete+=.
set complete+=k
set complete+=b
set complete+=t
set tabstop=4
set shiftwidth=4
set expandtab
set background=dark
" autocmd BufEnter * lcd %:p:h

autocmd FileType haskell nmap <C-c><C-r> :GhciRange<CR>
autocmd FileType haskell vmap <C-c><C-r> :GhciRange<CR>
autocmd FileType haskell nmap <C-c><C-l> :GhciFile<CR>
autocmd FileType haskell nmap <C-c><C-x> :GhciReload<CR>

au BufRead,BufNewFile *.pic set filetype=pic
autocmd FileType pic map ,l :w \|!pic2pdf % && xdg-open %:r.pdf <cr>

map ,, <C-^>
map ,m :TlistToggle <cr>
let mapleader = ","
command! InsertTime :normal a<c-r>=strftime('%F %H:%M:%S.0 %z')<cr>

set langmap=ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯЖ;ABCDEFGHIJKLMNOPQRSTUVWXYZ:,фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz
