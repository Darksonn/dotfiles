filetype plugin indent off

let g:python_host_prog = '/usr/bin/python2'
let g:python3_host_prog = '/usr/bin/python'

set runtimepath+=~/.config/nvim/bundle/neobundle.vim/,/opt/neovim/runtime
call neobundle#begin(expand('~/.config/nvim/bundle/'))

NeoBundleFetch 'Shougo/neobundle.vim'
"NeoBundle 'bling/vim-airline'
NeoBundle 'wting/rust.vim'
NeoBundle 'Valloric/YouCompleteMe'
NeoBundle 'kien/ctrlp.vim'
NeoBundle 'vim-scripts/Vim-R-plugin'
NeoBundle 'scrooloose/nerdtree'
NeoBundle 'scrooloose/nerdcommenter'
NeoBundle 'rking/ag.vim'
NeoBundle 'tpope/vim-repeat'
NeoBundle 'scratch.vim'
NeoBundle 'taglist.vim'
NeoBundle 'netrw.vim'
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'gerw/vim-HiLinkTrace'
NeoBundle 'minibufexpl.vim'
NeoBundle 'derekwyatt/vim-scala'
NeoBundle 'scrooloose/syntastic'
NeoBundle 'vim-scripts/vim-auto-save'

call neobundle#end()
NeoBundleCheck " warn me if any packages aren't installed
filetype plugin indent on

" Building with F9
function! Run_Build()
  set nornu
  if filereadable("./Makefile")
    make
  elseif (&filetype == "tex")
    execute("!lualatex " . bufname("%"))
  endif
  set rnu
endfunction
nnoremap <silent> <F9> :call Run_Build()<CR>

" Syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

" Statusbar
" let g:airline#extensions#tabline#enabled = 1
" let g:airline_powerline_fonts = 1
set laststatus=2

" Leader init
noremap <Space> <Nop>
let mapleader = ":"

" Neovims terminal
tnoremap jk <C-\><C-n>

" sometimes I start leaving with ZZ, but then redecide and leave with :q
nnoremap <space> :

set backspace=indent,eol,start " reasonable backspaces
set nofoldenable               " folding is weird
set background=dark            " why would you use a light terminal?

" REVEAL THE WHITESPACE
set listchars=tab:>.,trail:~,extends:#,precedes:<
set list

" strip all trailing whitespace
nnoremap <leader>W :%s/\s\+$//<cr>:noh<CR>

" tabs
if (bufname("%") != "makefile" && bufname("%") != "Makefile")
  set smartindent
  set expandtab
  set tabstop=2
  set shiftwidth=2
endif

" searching
set ignorecase
set smartcase
set hlsearch
set incsearch
set gdefault
set showmatch


" Nul is <C-Space>
noremap  <Nul> <Nop>
xnoremap <Nul> <Nop>
cnoremap <Nul> <Nop>
nnoremap <Nul> <Nop>
inoremap <Nul> <Nop>

" linenumbering
augroup line_numbering
	autocmd!
	au InsertEnter * set nornu
	au InsertLeave * set rnu
  au TermOpen * set rnu
  au TermOpen * set number
augroup END
set rnu
set number

" scratch.vim
noremap <leader>s :Scratch<CR>
noremap <leader>S <C-W>v<C-W>l:Scratch<CR>

" Various

" Remove search highlighting when pressing backspace
nnoremap <expr> <BS> v:hlsearch?':noh<cr>':'<BS>'
" Add . at the end of suitable lines
function! DotLineEnd()
	%s/^\([^#].*[^. )?!_]\)\([ ]*$\)/\1.\2/
	noh
endfunction
cmap w!! w !sudo tee > /dev/null %
set ruler
set wrap
if has("syntax")
  syntax on
endif
set scrolloff=3
set cursorline
inoremap <F1> <ESC>
nnoremap <F1> <ESC>
vnoremap <F1> <ESC>
inoremap jk <esc>
set hidden
set wildignore=*.swp,*.bak,*.pyc,*.class
set virtualedit=block
set noshowmode
map <silent> <leader>I :set paste<cr>i
map <silent> <leader>A :set paste<cr>a

set backupdir=~/.nvim_backup
set directory=~/.nvim_swap
set backup

augroup write_on_focus_lost
	autocmd!
	au FocusLost * :wa
	au InsertLeave * :set nopaste
augroup END

" reformat paragraph
nnoremap <leader>r gqiv

" close vim if only buffer left is nerdtree
augroup nerdtree_only_left
	autocmd!
	au bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
augroup END

" edit nvimrc
nnoremap <leader>ve <C-w>v<C-w>l:e $MYVIMRC<CR>
nnoremap <leader>vE :e $MYVIMRC<CR>
nnoremap <leader>vs :source $MYVIMRC<CR>

" windows
nnoremap <leader>br :execute "rightbelow vsplit " . bufname("#")<CR>
nnoremap <leader>bl :execute "leftabove vsplit " . bufname("#")<CR>
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

" colors
colorscheme pcs

" change case
nnoremap <leader>~u viwU
nnoremap <leader>~l viwUviw~
nnoremap <leader>~~ viw~

" dont start highlighting anything
noh

" movements
onoremap p i(
onoremap <silent> <leader>f :<C-U>normal! 0f(hviw<CR>
onoremap in( :<c-u>normal! f(vi(<cr>
onoremap il( :<c-u>normal! F)vi(<cr>

" ; at end of line
nnoremap <leader>; mqA;<esc>`q
xnoremap <silent> <leader>; :s/^.*[^ ].*$/&;/<cr>:noh<cr>

" append and prepend a line
xnoremap <silent> <expr> A mode()==#"V" ? ":s/$/".escape(input("append: "), '\^$.*~[]^&')."<cr>:noh<cr>" : "A"
xnoremap <silent> <expr> I mode()==#"V" ? ":s/^/".escape(input("prepend: "), '\^$.*~[]^&')."<cr>:noh<cr>" : "I"
xnoremap <silent> <expr> a mode()==#"V" ? ":s/^.*[^ ].*$/&".escape(input("append: "), '\^$.*~[]^&')."<cr>:noh<cr>" : "a"
xnoremap <silent> <expr> i mode()==#"V" ? ":s/^.*[^ ].*$/".escape(input("prepend: "), '\^$.*~[]^&')."&<cr>:noh<cr>" : "i"

" taglist
map <leader>Tagbuild :!/usr/bin/ctags -R .<CR>
let Tlist_Ctags_Cmd = "/usr/bin/ctags"
let Tlist_WinWidth = 50
map <leader>t :TlistToggle<cr>

" clipboard
function! ClipboardYank()
  call system('xclip -i -selection clipboard', @@)
endfunction
function! ClipboardPaste()
  let @@ = system('xclip -o -selection clipboard')
endfunction

nnoremap <silent> <leader>y :call ClipboardYank()<cr>
nnoremap <silent> <leader>p :call ClipboardPaste()<cr>


" beginning of line
noremap 0 ^
noremap ^ 0

nnoremap <leader>l :b 
nnoremap <leader>k :e 

" tex autopreview
function! InotwFunc()
  :!~/dotfiles/inot update %:t
  :w
endfunction
command Inotw call InotwFunc()
command HInotw echom "Guide" | echom ":AutoSaveToggle" | echom "Start ~/inot inot buffer" | echom "Start mupdf on diff.pdf"

" no holding several keys
" inoremap <Shift>` ~
" inoremap <Shift>1 !
" inoremap <Shift>2 @
" inoremap <Shift>3 #
" inoremap <Shift>4 $
" inoremap <Shift>5 %
" inoremap <Shift>6 ^
" inoremap <Shift>7 &
" inoremap <Shift>8 *
" inoremap <Shift>9 (
" inoremap <Shift>0 )
" inoremap <Shift>- _
" inoremap <Shift>= +
" inoremap <Shift>[ {
" inoremap <Shift>] }
" inoremap <Shift>; :
" inoremap <Shift>' "
" inoremap <Shift>, <
" inoremap <Shift>. >
" inoremap <Shift>/ ?
" inoremap <Shift>\ |

