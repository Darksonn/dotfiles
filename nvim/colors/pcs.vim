set background=dark
hi clear
if exists("syntax_on")
    syntax reset
endif
let g:colors_name="personal color scheme"

hi Normal ctermfg=15 ctermbg=0
hi Cursor ctermfg=16 ctermbg=196
hi CursorIM ctermfg=16 ctermbg=196
hi CursorLine cterm=none ctermbg=233
hi LineNr ctermfg=250 ctermbg=0

" syntax highlighting groups
hi Comment ctermfg=28
hi Constant ctermfg=5
hi String ctermfg=13
hi Statement ctermfg=9
hi Operator ctermfg=1
hi Delimiter ctermfg=15
hi Special ctermfg=3

hi MBEVisibleNormal ctermfg=10 ctermbg=0
hi MBENormal ctermfg=13 ctermbg=0
hi MBEVisibleChanged ctermfg=9 ctermbg=0
hi MBEChanged ctermfg=11 ctermbg=0

