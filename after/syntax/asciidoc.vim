for val in g:todolist_values
    exe "syn keyword Identifier " . val
endfor

syn keyword Comment DONE
syn match Number "(#[A-Z])"
syn match String "@[a-zA-z]\+"
