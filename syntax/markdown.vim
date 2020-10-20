for val in g:todo_keywords
    if val !=? "DONE"
        exe 'syn match TodoItem containedin=markdownBlock,markdownH1,markdownH2,markdownH3,markdownH4,markdownH5,markdownH6 "\C' . val . '"'
    endif
endfor

" let s:todo_pattern = join(g:todo_keywords, "|")
" exe 'syn match TodoItem "\C' . s:todo_pattern . '" containedin=markdownBlock,markdownH1,markdownH2,markdownH3,markdownH4,markdownH5,markdownH6'

syn match TodoDone containedin=markdownBlock,markdownH1,markdownH2,markdownH3,markdownH4,markdownH5,markdownH6 "\CDONE"
syn match TodoPriority containedin=markdownBlock,markdownH1,markdownH2,markdownH3,markdownH4,markdownH5,markdownH6 "\v\(#[A-Z]\)"
syn match TodoTag containedin=markdownBlock,markdownH1,markdownH2,markdownH3,markdownH4,markdownH5,markdownH6 "\v\@[a-zA-z]+"

hi def link TodoItem Identifier
hi def link TodoDone Comment
hi def link TodoPriority Number
hi def link TodoTag String
