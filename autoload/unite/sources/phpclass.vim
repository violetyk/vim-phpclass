let s:save_cpo = &cpo
set cpo&vim

" phpclass " {{{
let s:unite_source_phpclass = {
      \ 'name' : 'phpclass',
      \ 'description' : 'PHP Classes',
      \ }

function! s:unite_source_phpclass.gather_candidates(args, context)
  let candidates = []

  try
    for i in items(phpclass#get_classes())
      call add(candidates, {
            \ 'word' : i[0],
            \ 'kind' : 'file',
            \ 'source' : 'phpclass',
            \ 'action__path' : i[1],
            \ 'action__directory' : fnamemodify(i[1],":p:h"),
            \ })
    endfor
  catch
  endtry

  return candidates
endfunction
" }}}
function! unite#sources#phpclass#define() "{{{
  let sources = [
        \ s:unite_source_phpclass,
        \ ]

  return sources
endfunction "}}}

let &cpo = s:save_cpo
unlet s:save_cpo
" vim:set fenc=utf-8 ff=unix ft=vim fdm=marker:
