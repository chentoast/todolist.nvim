-- finish task: do a substitute

todo = {}

local api = vim.api
-- table of todo keywords, where keys = 1, 2, ...
local todo_kw = api.nvim_get_var("todo_keywords")
local num_todo_kw = #todo_kw

-- pattern to match for all todo keywords
local todo_kw_pattern = table.concat(todo_kw, "|")

-- each value in todo points to the next one in the cycle
local todo_kw_next = {}
for i=1,num_todo_kw - 1 do
    todo_kw_next[todo_kw[i]] = todo_kw[i + 1]
end
todo_kw_next[todo_kw[num_todo_kw]] = todo_kw[1]

function todo.mark_checkbox()
    api.nvim_command("s/[ ]/[x]")
end

function todo.set_priority()
    api.nvim_feedkeys("A(#A)")
end

function todo.increment_priority()
    api.nvim_command('s/(#\\([A-Z]\\))/\\=nr2char(char2nr(submatch(0)) + 1)')
end

function todo.decrement_priority()
    api.nvim_command('s/(#\\([A-Z]\\))/\\=nr2char(char2nr(submatch(0)) - 1)')
end

function todo.cycle_todos()
    local cur_line = api.nvim_buf_get_lines(0, 
        api.nvim_call_function("lines", {"."}))

    local match = api.nvim_call_function("matchstr", {cur_line, todo_kw_pattern})
    api.nvim_command("s/" .. match .. "/" .. todo_kw_next[match])
end
