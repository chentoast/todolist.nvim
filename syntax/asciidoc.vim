for val in g:todo_keywords
    if val !=? "DONE"
        exe "syn keyword Identifier " . val
    endif
endfor

syn keyword Comment DONE
syn match Number "(#[A-Z])"
syn match String "@[a-zA-z]\+"
