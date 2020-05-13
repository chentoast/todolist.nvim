if exists("g:todolist_loaded")
    finish
endif

let s:save_cpo = &cpo
set cpo&vim

let g:todo_keywords = ["TODO", "DONE"]

let g:todo_tags = ["home", "work", "appointment"]

let g:todolist_loaded=1

let &cpo = s:save_cpo
unlet s:save_cpo
