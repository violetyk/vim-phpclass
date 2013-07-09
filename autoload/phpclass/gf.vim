let s:save_cpo = &cpo
set cpo&vim

function! phpclass#gf#find() "{{{

  if !exists("g:loaded_gf_user")
    return 0
  endif

  let path = expand("%:p")
  let line = getline('.')
  let word = expand('<cword>')
  let l_word = expand('<cWORD>')
  let candidate = {}

  let target = {
        \ 'path': '',
        \ 'line' : 0,
        \ 'col'  : 0
        \ }

  let classes = phpclass#get_classes()

  let candidate = filter(copy(classes), 'v:key =~ "'. word . '$"')
  if len(candidate)
    if len(candidate) == 1
      let tmp = values(candidate)
      let target.path = tmp[0]
      return target
    else
      let n = 'A'
      let choices = ''
      let path_list = []
      for i in items(candidate)
        let choices .= n . ' : ' . i[0] . "\n"
        call add(path_list, i[1])
        let _n = char2nr(n)
        let _n = _n + 1
        let n = nr2char(_n)
      endfor
      let c = confirm('Which?', choices, 0)
      if c > 0
        let target.path = path_list[c - 1]
        return target
      endif
    endif
  endif

  " not found
  return 0

endfunction "}}}

function! s:search_line(path, term) " {{{
  let line = match(readfile(a:path), '\%(const\|static\|function\)!\?\s*' . a:term)
  if line >= 0
    return line+1
  endif
  return 0
endfunction " }}}
let s:surround_margin = 60
function! s:get_surround(line, col) " {{{
  let start = a:col - s:surround_margin <= 0 ? 0 : a:col - s:surround_margin
  let end = a:col + s:surround_margin
  return a:line[start : end]
endfunction " }}}


let &cpo = s:save_cpo
unlet s:save_cpo
" vim:set fenc=utf-8 ff=unix ft=vim fdm=marker:
