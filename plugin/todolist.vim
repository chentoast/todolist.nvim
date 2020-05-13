if exists("g:todolist_loaded")
    finish
endif

let s:save_cpo = &cpo
set cpo&vim

let g:todo_keywords = ["TODO"]

let g:todo_tags = ["home", "school", "appointment"]

function! CompleteTags()
    call complete(col("."), g:todo_tags)
    return ''
endfunction

let g:todolist_loaded=1

let &cpo = s:save_cpo
unlet s:save_cpo
