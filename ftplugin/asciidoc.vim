lua todo = require'todo'

function! CompleteTags()
    call complete(col("."), g:todo_tags)
    return ''
endfunction

nnoremap <silent><buffer> <localleader>] :lua todo.cycle_todo_next()<cr>
nnoremap <silent><buffer> <localleader>[ :lua todo.cycle_todo_prev()<cr>
nnoremap <silent><buffer> <localleader>j :lua todo.decrement_priority()<cr>
nnoremap <silent><buffer> <localleader>j :lua todo.increment_priority()<cr>
nnoremap <silent><buffer> <localleader>x :lua todo.mark_checkbox()<cr>

inoremap <buffer> @<tab> <c-r>=CompleteTags()<cr>
inoremap <buffer> <s-cr> <c-r>=todo.add_new_entry()<cr>
