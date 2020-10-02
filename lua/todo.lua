M = {}

local api = vim.api
-- table of todo keywords, where keys = 1, 2, ...
local todo_kw = vim.g.todo_keywords
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
    vim.cmd("sno/[ ]/[x]/e")
    vim.cmd("noh")
end
M.mark_checkbox = save_excursion(mark_checkbox)

local function set_priority()
    vim.cmd([[sno/\(\[=-]\+ \*"]] .. todo_kw_pattern .. [[\) /\1 (#A) /e]])
    vim.cmd("noh")
end
M.set_priority = save_excursion(set_priority)

local function increment_priority()
    -- If no priority, then set it
    -- if not vim.regex("(#[A-Z])"):match_str(api.nvim_get_current_line()) then
    local cur_line = api.nvim_get_current_line()
    if not string.find(cur_line, "%(#[A-Z]%)") then
        M.set_priority()
    else
        vim.cmd([[sno/(#\(\[A-Z]\))/\="(#" . nr2char(char2nr(submatch(1)) + 1) . ")"/e"]])
        vim.cmd("noh")
    end
end
M.increment_priority = save_excursion(increment_priority)

local function decrement_priority()
    local cur_line = api.nvim_get_current_line()
    -- if vim.regex("(#A) "):match_str(cur_line) then
    if string.find(cur_line, "%(#A%)") then
        vim.cmd("sno/(#A) //")
        vim.cmd("noh")
    -- elseif vim.regex("(#[A-Z])"):match_str(cur_line) then
    elseif string.find(cur_line, "%(#[B-Z]%)") then
        vim.cmd([[sno/(#\(\[B-Z]\))/\="(#" . nr2char(char2nr(submatch(1)) - 1) . ")"/e]])
        vim.cmd("noh")
    end
end
M.decrement_priority = save_excursion(decrement_priority)

local function add_new_entry()
    local cur_line = api.nvim_get_current_line()

    local match = vim.regex("[=-]\\+ \\(" .. todo_kw_pattern .. "\\|\\[ ]\\)\\=")
    match_idx_start, match_idx_end = match:match_str(cur_line)
    if match_idx_start then
        api.nvim_feedkeys('\r' .. string.sub(cur_line, match_idx_start + 1, match_idx_end), "m", true)
    end
end
M.add_new_entry = save_excursion(add_new_entry)

local function cycle_todo_next()
    local cur_line = api.nvim_get_current_line()

    local match_idx_start, match_idx_end = vim.regex(todo_kw_pattern):match_str(cur_line)
    if match_idx_start then
        local match = string.sub(cur_line, match_idx_start + 1, match_idx_end)
        vim.cmd("sno/" .. match .. "/" .. todo_kw_next[match] .. "/e")
    end
end
M.cycle_todo_next = save_excursion(cycle_todo_next)

local function cycle_todo_prev()
    local cur_line = api.nvim_get_current_line()

    local match_idx_start, match_idx_end = vim.regex(todo_kw_pattern):match_str(cur_line)
    if match_idx_start then
        local match = string.sub(cur_line, match_idx_start + 1, match_idx_end)
        vim.cmd("sno/" .. match .. "/" .. todo_kw_prev[match])
    end
end
M.cycle_todo_prev = save_excursion(cycle_todo_prev)

function M.open_project_todo()
    local root = io.popen("git rev-parse --show-toplevel 2>/dev/null"):read("*a")
    -- strip newline
    root = root:sub(1, -2)
    if root == '' then
        api.nvim_err_writeln("not in git repo!")
    else
        vim.cmd('e ' .. root .. '/todo.adoc')
    end
end

function M.todo_capture(filename)
end

function M.popup_todo_file(filename)
    local buf = api.nvim_create_buf(false, true)
    local border_buf = api.nvim_create_buf(false, true)

    if buf == 0 or border_buf == 0 then
        return
    end

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
        col = col - 2
    }

    local border_win = api.nvim_open_win(border_buf, true, border_opts)
    local win = api.nvim_open_win(buf, true, opts)

    if border_win == 0 or win == 0 then
        return
    end

    api.nvim_win_set_option(win, "winhl", "Normal:TodoFloatWin")
    api.nvim_win_set_option(border_win, "winhl", "Normal:TodoFloatWin")

    api.nvim_set_current_win(win)
    vim.cmd("e " .. filename)
    vim.cmd('au BufWipeout <buffer> silent bw! ' .. border_buf)
end

return M
