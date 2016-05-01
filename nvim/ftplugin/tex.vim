inoremap <buffer> $ \(
inoremap <buffer> $<space> \)
inoremap <buffer> $. \).
inoremap <buffer> $$e <esc>o\begin{equation*}<cr>\end{equation*}<esc>O
inoremap <buffer> $$a <esc>o\begin{align*}<cr>\end{align*}<esc>O
inoremap <buffer> #q <esc>o\begin{quote}<cr>\end{quote}<esc>O
inoremap <buffer> #fig <esc>o\begin{figure}<cr>\centering<cr>\end{figure}<esc>O<cr>\caption{}<cr>\label{}<esc>kkA<tab>
inoremap <buffer> #stikz <esc>o\begin{tikzpicture}<cr>\end{tikzpicture}<esc>O
inoremap <buffer> #tikz <esc>o\begin{figure}<cr>\centering<cr>\end{figure}<esc>O\begin{tikzpicture}<cr>\end{tikzpicture}<cr>\caption{}<cr>\label{}<esc>:call TikzMap()<cr>kkO
inoremap <buffer> #sas <esc>o\begin{sagesilent}<cr>\end{sagesilent}<esc>O

nnoremap <leader>tikz :call TikzMap()<cr>

function! TikzMap()
  inoremap <buffer> drw \draw (
  inoremap <buffer> -- ) -- (
  inoremap <buffer> -c ) -- cycle;<cr>
  inoremap <buffer> ; ;<cr>
  inoremap <buffer> drw[ \draw[] (<esc>hhi
  inoremap <buffer> len \draw[stealth'-stealth'] (
  inoremap <buffer> node node {};<left><left>
  inoremap <buffer> node[ node[] {};<left><left><left><left><left>

  inoremap <buffer> endtikz <esc>:call TikzUnmap()<cr>
endfunction
" 0fnceunmap3f d$j
function! TikzUnmap()
  iunmap <buffer> drw
  iunmap <buffer> --
  iunmap <buffer> -c
  iunmap <buffer> ;
  iunmap <buffer> drw[
  iunmap <buffer> len
  iunmap <buffer> node
  iunmap <buffer> node[
  iunmap <buffer> endtikz
endfunction


function! Insert(empty,nonempty)
  if strlen(getline(".")) == 0
    return a:empty
  else
    return a:nonempty
  endif
endfunction
inoremap <buffer> <expr> #se Insert('\section{}<esc>i', '<esc>o\section{}<esc>i')
inoremap <buffer> <expr> #sse Insert('\subsection{}<esc>i', '<esc>o\subsection{}<esc>i')
inoremap <buffer> <expr> #ssse Insert('\subsubsection{}<esc>i', '<esc>o\subsubsection{}<esc>i')

