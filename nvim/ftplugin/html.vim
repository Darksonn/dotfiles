
fun! IsSynHtmlText(a, b)
  let x = synID(line("."), col(".")-1, 1)
  let allow = [0, 102, 103, 156, 163, 171]
  if (index(allow, x) >= 0)
    return a:a
  endif
  return a:b
endfun

inoremap <buffer> <expr> <silent> ` IsSynHtmlText("‘", "`")
inoremap <buffer> <expr> <silent> ' IsSynHtmlText("’", "'")
inoremap <buffer> <expr> <silent> `` IsSynHtmlText("“", "``")
inoremap <buffer> <expr> <silent> " IsSynHtmlText("”", "\"")

inoremap <buffer> <silent> <p> <p><esc>o</p><esc>O
inoremap <buffer> <silent> <a> <a href=""></a><esc>5hi

