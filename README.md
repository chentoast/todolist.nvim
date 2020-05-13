# Todolist.nvim

# Overview

Todolist.nvim is a neovim plugin that aims to provide basic todo list functionality for asciidoc and markdown files.
Most of its functionality is inspired and imported from org-mode, and includes:

- cycling between todo keywords ("TODO", "IN-PROGRESS", etc, configured through g:todo_keywords)
- checkboxes
- setting and changing priority of items
- tags, and insert mode tag completion (through g:todo_tags)
- an org-capture like workflow using Neovim's floating windows

For more information on how the plugin works, please see the documentation in doc/todolist.txt.

# Requirements

Neovim 0.5+

# Installation

Using vim-plug, put this in your init.vim:

`Plug chentau/todolist.nvim`

If installing manually, clone this repository to `~/.config/nvim/bundle/`, and put the following in your init.vim:

`set rtp+=~/.config/nvim/bundle/todolist.nvim`
