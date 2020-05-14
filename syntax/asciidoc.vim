syn clear asciidocToDo

for val in g:todo_keywords
    if val !=? "DONE"
        exe "syn keyword TodoItem contained " . val
        " exe "syn keyword TodoItem " . val
    endif
endfor

syn keyword TodoDone contained DONE
syn match TodoPriority contained "(#[A-Z])"
syn match TodoTag contained "@[a-zA-z]\+"


" override some of the syntax groups from builtin asciidoc.vim
syn region asciidocList start=/^\s*\(-\|\*\{1,5}\)\s/ start=/^\s*\(\(\d\+\.\)\|\.\{1,5}\|\(\a\.\)\|\([ivxIVX]\+)\)\)\s\+/ start=/.\+\(:\{2,4}\|;;\)$/ end=/\(^[=*]\{4,}$\)\@=/ end=/\(^\(+\|--\)\?\s*$\)\@=/ contains=asciidocList.\+,asciidocQuoted.*,asciidocMacroAttributes,asciidocAttributeRef,asciidocEntityRef,asciidocEmail,asciidocURL,asciidocBackslash,asciidocCommentLine,asciidocAttributeList,asciidocToDo,TodoItem,TodoDone,TodoPriority,TodoTag
syn match asciidocOneLineTitle /^=\{1,5}\s\+\S.*$/ contains=asciidocQuoted.*,asciidocMacroAttributes,asciidocAttributeRef,asciidocEntityRef,asciidocEmail,asciidocURL,asciidocBackslash,TodoItem,TodoDone,TodoPriority,TodoTag
syn match asciidocTwoLineTitle /^[^. +/].*[^.]\n[-=~^+]\{3,}$/ contains=asciidocQuoted.*,asciidocMacroAttributes,asciidocAttributeRef,asciidocEntityRef,asciidocEmail,asciidocURL,asciidocBackslash,asciidocTitleUnderline,TodoItem,TodoDone,TodoPriority,TodoTag

hi def link TodoItem Identifier
hi def link TodoDone Comment
hi def link TodoPriority Number
hi def link TodoTag String
