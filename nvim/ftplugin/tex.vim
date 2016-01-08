inoremap <buffer> $ \(
inoremap <buffer> $<space> \)
inoremap <buffer> $. \).
inoremap <buffer> $$e <esc>o\begin{equation*}<cr>\end{equation*}<esc>O
inoremap <buffer> $$a <esc>o\begin{align*}<cr>\end{align*}<esc>O
function! Insert(empty,nonempty)
  if strlen(getline(".")) == 0
    return a:empty
  else
    return a:nonempty
  endif
endfunction
inoremap <buffer> <expr> \[se Insert('\section{}<esc>i', '<esc>o\section{}<esc>i')
inoremap <buffer> <expr> \[sse Insert('\subsection{}<esc>i', '<esc>o\subsection{}<esc>i')
inoremap <buffer> <expr> \[ssse Insert('\subsubsection{}<esc>i', '<esc>o\subsubsection{}<esc>i')

