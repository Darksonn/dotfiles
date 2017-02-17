
inoremap jk <esc>
tnoremap jk <C-\><C-n>
nnoremap <space> :

filetype off
set rtp+=~/.config/nvim/bundle/Vundle.vim
call vundle#begin("~/.config/nvim/bundle")
Plugin 'VundleVim/Vundle.vim'

Plugin 'rust-lang/rust.vim'
Plugin 'mtth/scratch.vim'
Plugin 'fholgado/minibufexpl.vim'
Plugin 'Valloric/YouCompleteMe'

call vundle#end()

filetype plugin indent on
syntax enable

let g:python_host_prog = '/usr/bin/python2'
let g:python3_host_prog = '/usr/bin/python'

" Building with F9
function! Run_Build()
  set nornu
  if filereadable("./Makefile")
    make!
  elseif (&filetype == "tex")
    execute("!lualatex " . bufname("%"))
  endif
  set rnu
endfunction
nnoremap <silent> <F9> :call Run_Build()<CR>

" Leader
let mapleader = ":"

set backspace=indent,eol,start
set nofoldenable
set background=dark

" whitespace
set listchars=tab:>.,trail:~,extends:#,precedes:<
set list
" strip trailing whitespace
nnoremap <leader>W :%s/\s\+$//<cr>:noh<CR>

" indents
set smartindent
set expandtab
set tabstop=2
set shiftwidth=2
autocmd FileType make set noexpandtab shiftwidth=8 softtabstop=0

" searching
set ignorecase
set smartcase
set hlsearch
set incsearch
set gdefault
set showmatch

" line numbers
set number
set rnu
augroup line_numbering
  autocmd!
  au InsertEnter * set nornu
  au InsertLeave * set rnu
  au TermOpen * set rnu
augroup END

" Remove search highlighting when pressing backspace
nnoremap <expr> <BS> v:hlsearch?':noh<cr>':'<BS>'
noh

cmap w!! w !sudo tee > /dev/null %
set ruler
set wrap

inoremap <F1> <ESC>
nnoremap <F1> <ESC>
vnoremap <F1> <ESC>
set hidden
set wildignore=*.swp,*.bak,*.pyc,*.class

set backupdir=~/.nvim_backup
set directory=~/.nvim_swap
set backup

augroup write_on_focus_lost
  autocmd!
  au FocusLost * :wa
  au InsertLeave * :set nopaste
augroup END

" append and prepend a line
xnoremap <silent> <expr> A mode()==#"V" ? ":s/$/".escape(input("append: "), '\^$.*~[]^&')."<cr>:noh<cr>" : "A"
xnoremap <silent> <expr> I mode()==#"V" ? ":s/^/".escape(input("prepend: "), '\^$.*~[]^&')."<cr>:noh<cr>" : "I"
xnoremap <silent> <expr> a mode()==#"V" ? ":s/^.*[^ ].*$/&".escape(input("append: "), '\^$.*~[]^&')."<cr>:noh<cr>" : "a"
xnoremap <silent> <expr> i mode()==#"V" ? ":s/^.*[^ ].*$/".escape(input("prepend: "), '\^$.*~[]^&')."&<cr>:noh<cr>" : "i"

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

" tex autopreview
"function! InotwFunc()
"  :!~/dotfiles/inot update %:t
"  :w
"endfunction
"command! Inotw call InotwFunc()
"command! HInotw echom "Guide" | echom ":AutoSaveToggle" | echom "Start ~/inot inot buffer" | echom "Start mupdf on diff.pdf"

set textwidth=80
set colorcolumn=82

" YouCompleteMe configuration
nnoremap <leader>g :YcmCompleter GoTo<CR>
nnoremap <leader>t :YcmCompleter GetType<CR>
nnoremap <leader>t :YcmCompleter FixIt<CR>
let g:ycm_autoclose_preview_window_after_insertion = 1

" rust completion
let g:ycm_rust_src_path = system("rustup which cargo | sed 's#/bin/cargo$#/lib/rustlib/src/rust/src#' | tr -d '\n'")



