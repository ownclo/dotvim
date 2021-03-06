execute pathogen#infect()

"set t_ti= t_te=
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
set ignorecase smartcase
set showtabline=2
"set winwidth=79
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

" USE SYSTEM CLIPBOARD AS DEFAULT REGISTER
set clipboard=unnamedplus

" FILE ENCODINGS
set termencoding=utf-8
set fileencodings=utf8,cp1251
set encoding=utf8

" PERMANENT UNDO HISTORY
set history=64
set undolevels=128
set undodir=/home/ownclo/.vim/undodir/
set undofile
set undolevels=1000
set undoreload=10000

" highlights trailling whitespaces
"set list listchars=tab:>-,trail:·

"function! MapCR()
"  nnoremap <cr> :nohlsearch<cr>
"endfunction
"call MapCR()

let mapleader=","

map Q @q
command! W :w
command! Q :q

":set t_Co=256 " 256 colors
":set background=dark
"colorscheme grb256
set t_Co=16
set background=dark
colorscheme solarized

set cursorline
:hi CursorLine guifg=none guibg=none term=none cterm=none ctermbg=236 ctermfg=none
set nocursorline

set grepprg=grep\ -nH\ $*
let g:tex_flavor='latex'
let g:Tex_DefaultTargetFormat='pdf'
let g:Tex_MultipleCompileFormats='dvi,pdf'
let g:Tex_ViewRule_pdf = 'evince'
let g:Tex_ViewRule_dvi = 'evince'

autocmd BufReadPost *
            \ if line("'\"") > 0 && line("'\"") <= line("$") |
            \   exe "normal g`\"" |
            \ endif

function! RenameFile()
    let old_name = expand('%')
    let new_name = input('New file name: ', expand('%'), 'file')
    if new_name != '' && new_name != old_name
        exec ':saveas ' . new_name
        exec ':silent !rm ' . old_name
        redraw!
    endif
endfunction
map <leader>n :call RenameFile()<cr>

autocmd BufReadPost fugitive://* set bufhidden=delete
set statusline=%<%f\ %h%m%r%{fugitive#statusline()}%=%-14.(%l,%c%V%)\ %P

nnoremap <tab> <c-w>w
nnoremap <S-tab> <c-w>W
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l

" Insert a hash rocket with <c-l>
imap <c-l> <Space>-><CR>
imap <c-b> <Space><-<Space>

" Can't be bothered to understand ESC vs <c-c> in insert mode
"imap <c-c> <esc>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" SWITCH BETWEEN TEST AND PRODUCTION CODE
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! OpenTestAlternate()
  let new_file = AlternateForCurrentFile()
  exec ':e ' . new_file
endfunction
function! AlternateForCurrentFile()
  let current_file = expand("%")
  let new_file = current_file
  let in_spec = match(current_file, '^spec/') != -1
  let going_to_spec = !in_spec
  "let in_app = match(current_file, '\<controllers\>') != -1 || match(current_file, '\<models\>') != -1 || match(current_file, '\<views\>') || match(current_file, '\<helpers\>') != -1
  let in_lib = match(current_file, '^lib/') != -1
  if going_to_spec
    if in_lib
      let new_file = substitute(new_file, '^lib/', '', '')
    end
    let new_file = substitute(new_file, '\.rb$', '_spec.rb', '')
    let new_file = 'spec/' . new_file
  else
    let new_file = substitute(new_file, '_spec\.rb$', '.rb', '')
    let new_file = substitute(new_file, '^spec/', 'lib/', '')
    " if in_lib
    "   let new_file = 'lib/' . new_file
    " end
  endif
  return new_file
endfunction
nnoremap <leader>. :call OpenTestAlternate()<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" RUNNING TESTS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
map <leader>p :call RunTestFile()<cr>
map <leader>r :call RunNearestTest()<cr>
map <leader>a :call RunTests('')<cr>
map <leader>c :w\|:!script/features<cr>
map <leader>w :w\|:!script/features --profile wip<cr>

function! RunTestFile(...)
    if a:0
        let command_suffix = a:1
    else
        let command_suffix = ""
    endif

    " Run the tests for the previously-marked file.
    let in_test_file = match(expand("%"), '\(.feature\|_spec.rb\)$') != -1
    if in_test_file
        call SetTestFile()
    elseif !exists("t:grb_test_file")
        return
    end
    call RunTests(t:grb_test_file . command_suffix)
endfunction

function! RunNearestTest()
    let spec_line_number = line('.')
    call RunTestFile(":" . spec_line_number . " -b")
endfunction

function! SetTestFile()
    " Set the spec file that tests will be run for.
    let t:grb_test_file=@%
endfunction

function! RunTests(filename)
    " Write the file and run tests for the given filename
    :w
    if match(a:filename, '\.feature$') != -1
        exec ":!script/features " . a:filename
    else
        if filereadable("script/test")
            exec ":!script/test " . a:filename
        elseif filereadable("Gemfile")
            exec ":!bundle exec rspec --color " . a:filename
        else
            exec ":!rspec --color " . a:filename
        end
    end
endfunction

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

set nu
set autoindent
set autowrite
set smartindent
set incsearch
set guioptions-=T

set complete=""
set complete+=.
set complete+=k
set complete+=b
set complete+=t
set tabstop=4
set shiftwidth=4
set expandtab
"set background=dark
" autocmd BufEnter * lcd %:p:h

let g:SuperTabDefaultCompletionType = "context"

au BufNewFile,BufReadPost *.coffee setl shiftwidth=2 sts=2 expandtab
autocmd FileType ruby,haml,eruby,html,javascript,sass,cucumber set ai sw=2 sts=2 et

"" HASKELL FEATURES
if isdirectory(".hsenv")
    let g:hdevtools_options = '-g-isrc -g-package-conf.hsenv/ghc_pkg_db'
endif

"" XXX: This is a dirty hack. Beware!
if isdirectory(".cabal-sandbox")
    let g:hdevtools_options = '-g-isrc -g-package-conf.cabal-sandbox/x86_64-linux-ghc-7.4.1-packages.conf.d'
endif

"let g:haskell_conceal = 3
autocmd FileType haskell normal zR
autocmd FileType haskell nmap <leader>w :HdevtoolsType<CR>
autocmd FileType haskell nmap <silent> <leader>d :HdevtoolsClear<CR>
let g:syntastic_haskell_checkers = ['hdevtools', 'hlint']

au BufRead,BufNewFile *.tex set filetype=tex
autocmd FileType tex set wrap linebreak

au BufRead,BufNewFile *.pic set filetype=pic
autocmd FileType pic map ,l :w \|!pic2pdf % && xdg-open %:r.pdf <cr>

au BufRead,BufNewFile *.gp set filetype=gnuplot
autocmd FileType gnuplot map ,p :update\|!gnuplot %<cr>

map ,, <C-^>

" Search in git for current word.
" Useful when reverse-engineering.
"   - In normal mode, search for current word.
"   - In visual mode, search for selected text.
nnoremap ,s :Ggrep <C-R><C-W><CR>
vnoremap ,s y\|:Ggrep <C-R>"<CR>
" Search in current file for selected text.
vnoremap g/ y/<C-R>"<CR>

" map ,m :TlistToggle <cr> " Do not work well.
let mapleader = ","
command! InsertTime :normal a<c-r>=strftime('%F %H:%M:%S.0 %z')<cr>

set langmap=ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯЖ;ABCDEFGHIJKLMNOPQRSTUVWXYZ:,фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz

" disables recognition of escape sequences in insert
" mode
set noesckeys

"" PROTODEF OPTIONS
au! BufEnter *.cpp let b:fswitch = 'hpp,h' | let b:fswitchlocs = '../inc,.'
let g:protodefctagsexe = 'ctags-exuberant'
let g:protodefprotogetter = '/home/ownclo/.vim/bundle/vim-protodef/pullproto.pl'

"" CLANG_COMPLETE OPTIONS
"let g:clang_close_preview=1
"set conceallevel=2
"set concealcursor=vin
"let g:clang_snippets=1
"let g:clang_conceal_snippets=1
"" The single one that works with clang_complete
"let g:clang_snippets_engine='clang_complete'

"" Complete options (disable preview scratch window, longest removed to aways
"" show menu)
"set completeopt=menu,menuone

"" Limit popup menu height
"set pumheight=20

"" SuperTab completion fall-back 
"let g:SuperTabDefaultCompletionType='<c-x><c-u><c-p>'

" Nobody wants to passing templates
" automatically.
let g:templates_no_autocmd = 1
