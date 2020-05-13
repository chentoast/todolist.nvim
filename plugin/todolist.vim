if exists("g:todolist_loaded")
    finish
endif

let s:save_cpo = &cpo
set cpo&vim

let g:todo_keywords = ["TODO", "DONE"]

let g:todo_tags = ["home", "work", "appointment"]

let g:todolist_loaded=1

" highlight group for floating todo window
hi TodoFloatWin ctermbg=0, ctermfg=None

" let g:todo_capture_file = ~/org/todo.org

let &cpo = s:save_cpo
unlet s:save_cpo
