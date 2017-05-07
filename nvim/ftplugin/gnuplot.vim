setlocal textwidth=0
setlocal colorcolumn=0

fun! GnuplotAutocomplete()
  let line=getline('.')
  if line ==? "fit"
    return " a*x + b 'data' using ($1):($2) via a, b0fdv3l"
  elseif line ==? "set terminal"
    return " pngcairo0fpve"
  endif
  return " "
endfun

inoremap <buffer> <expr> <silent> <space> GnuplotAutocomplete()

