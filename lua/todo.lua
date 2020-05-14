todo = {}

local api = vim.api
-- table of todo keywords, where keys = 1, 2, ...
local todo_kw = api.nvim_get_var("todo_keywords")
local num_todo_kw = #todo_kw

-- regex pattern to match for all todo keywords
local todo_kw_pattern = table.concat(todo_kw, '\\|')

-- each value in todo points to the next one in the cycle
local todo_kw_next = {}
local todo_kw_prev = {}
for i=1,num_todo_kw do
    if i ~= 1 and i ~= num_todo_kw then
        todo_kw_next[todo_kw[i]] = todo_kw[i + 1]
        todo_kw_prev[todo_kw[i]] = todo_kw[i - 1]
    elseif i == num_todo_kw then
        todo_kw_prev[todo_kw[i]] = todo_kw[i - 1]
    else
        todo_kw_next[todo_kw[i]] = todo_kw[i + 1]
    end
end
todo_kw_next[todo_kw[num_todo_kw]] = todo_kw[1]
todo_kw_prev[todo_kw[1]] = todo_kw[num_todo_kw]

local function save_excursion(func)
    -- wrapper function that saves and restores cursor position after applying func
    local function wrapped_fn()
        local cur_pos = api.nvim_win_get_cursor(0)
        func()
        api.nvim_win_set_cursor(0, cur_pos)
    end
    return wrapped_fn
end

local function mark_checkbox()
    api.nvim_command("sno/[ ]/[x]")
end
todo.mark_checkbox = save_excursion(mark_checkbox)

local function set_priority()
    api.nvim_command("sno/\\(\\[=-]\\+ \\*" .. todo_kw_pattern .. "\\) /\\1 (#A) /")
end
todo.set_priority = save_excursion(set_priority)

local function increment_priority()
    -- If no priority, then set it
    if not vim.regex("(#[A-Z])"):match_str(api.nvim_get_current_line()) then
        todo.set_priority()
    else
        api.nvim_command("sno/(#\\(\\[A-Z]\\))/\\=\"(#\" . nr2char(char2nr(submatch(1)) + 1) . \")\"")
    end
end
todo.increment_priority = save_excursion(increment_priority)

local function decrement_priority()
    local cur_line = api.nvim_get_current_line()
    if vim.regex("(#A) "):match_str(cur_line) then
        api.nvim_command("sno/(#A) //")
    elseif vim.regex("(#[A-Z])"):match_str(cur_line) then
        api.nvim_command("sno/(#\\(\\[A-Z]\\))/\\=\"(#\" . nr2char(char2nr(submatch(1)) - 1) . \")\"")
    end
end
todo.decrement_priority = save_excursion(decrement_priority)

local function add_new_entry()
    local cur_line = api.nvim_get_current_line()

    local match = vim.regex("[=-]\\+ \\(" .. todo_kw_pattern .. "\\|\\[ ]\\)\\=")
    match_idx_start, match_idx_end = match:match_str(cur_line)
    if match_idx_start then
        api.nvim_feedkeys('\r' .. string.sub(cur_line, match_idx_start + 1, match_idx_end), "m", true)
    end
end
todo.add_new_entry = save_excursion(add_new_entry)

local function cycle_todo_next()
    local cur_line = api.nvim_get_current_line()

    local match_idx_start, match_idx_end = vim.regex(todo_kw_pattern):match_str(cur_line)
    if match_idx_start then
        local match = string.sub(cur_line, match_idx_start + 1, match_idx_end)
        api.nvim_command("sno/" .. match .. "/" .. todo_kw_next[match])
    end
end
todo.cycle_todo_next = save_excursion(cycle_todo_next)

local function cycle_todo_prev()
    local cur_line = api.nvim_get_current_line()

    local match_idx_start, match_idx_end = vim.regex(todo_kw_pattern):match_str(cur_line)
    if match_idx_start then
        local match = string.sub(cur_line, match_idx_start + 1, match_idx_end)
        api.nvim_command("sno/" .. match .. "/" .. todo_kw_prev[match])
    end
end
todo.cycle_todo_next = save_excursion(cycle_todo_prev)

function todo.popup_todo_file()
    local buf = api.nvim_create_buf(true, false)
    local border_buf = api.nvim_create_buf(false, true)
    print(border_buf)

    local n_col = api.nvim_get_option("columns")
    local n_row = api.nvim_get_option("lines")

    local height = math.ceil(n_row * .7)
    local width = math.ceil(n_col * .7)

    local row = math.ceil((n_row - height) / 2)
    local col = math.ceil((n_col - width) / 2)

    local opts = {
        style = "minimal",
        relative = "editor",
        width = width,
        height = height,
        row = row,
        col = col
    }

    local border_opts = {
        style = "minimal",
        relative = "editor",
        width = width + 6,
        height = height + 4,
        row = row - 1,
        col = col - 1
    }

    local border_win = api.nvim_open_win(border_buf, true, border_opts)
    win = api.nvim_open_win(buf, true, opts)

    api.nvim_win_set_option(win, "winhl", "Normal:TodoFloatWin")
    api.nvim_win_set_option(border_win, "winhl", "Normal:TodoFloatWin")
    api.nvim_set_current_win(win)
    api.nvim_command('au BufWinLeave <buffer> exe "silent bwipeout! "' .. border_buf)
    api.nvim_command("e " .. api.nvim_get_option("todo_capture_file"))
end

return todo
