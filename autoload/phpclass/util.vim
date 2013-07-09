let s:save_cpo = &cpo
set cpo&vim

function! phpclass#util#in_array(expr, list) " {{{
    return index(a:list, a:expr) != -1
endfunction " }}}

function! phpclass#util#filter_complelist(dict,ArgLead) "{{{
  let list = sort(keys(a:dict))
  return filter(list, 'v:val =~ "^'. fnameescape(a:ArgLead) . '"')
endfunction "}}}

function! phpclass#util#open_file(path, option, line) "{{{

  if !bufexists(a:path)
    exec "badd " . a:path
  endif

  let buf_no = bufnr(a:path)
  if buf_no != -1
    if a:option == 's'
      exec "sb" . buf_no
    elseif a:option == 'v'
      exec "vert sb" . buf_no
    elseif a:option == 't'
      exec "tabedit"
      exec "b" . buf_no
    else
      exec "b" . buf_no
    endif

    if type(a:line) == type(0) && a:line > 0
      exec a:line
      exec "normal! z\<CR>"
      exec "normal! ^"
    endif

  endif
endfunction
" }}}


function! phpclass#util#camelize(word) " {{{

  let word = a:word
  if word == ''
    return word
  endif

  if word =~# '^[A-Z]\+[a-z0-9]\+[A-Z]\+[a-z0-9]\+'
    return word
  endif

  " To Upper Camel Case
  return join(map(split(word, '_'), 'toupper(v:val[0]) . tolower(v:val[1:])'), '')

endfunction "}}}
function! phpclass#util#decamelize(word) " {{{

  let word = a:word
  if word == ''
    return word
  endif

  let result = ''

  if word =~# '^[A-Z]\+$'
   let result = tolower(word)
  else
    for c in split(word, '\zs')
      if c =~# '[A-Z]'
        let result = result . '_' . tolower(c)
      else 
        let result = result . c
      endif
    endfor

    if result[0] == '_'
      let result = result[1:]
    endif
  endif

  return result

endfunction "}}}

function! phpclass#util#singularize(word) " {{{
" rails.vim(http://www.vim.org/scripts/script.php?script_id=1567)
" rails#singularize

  let word = a:word
  if word == ''
    return word
  endif

  let word = substitute(word, '\v\Ceople$', 'ersons', '')
  let word = substitute(word, '\v\C[aeio]@<!ies$','ys', '')
  let word = substitute(word, '\v\Cxe[ns]$', 'xs', '')
  let word = substitute(word, '\v\Cves$','fs', '')
  let word = substitute(word, '\v\Css%(es)=$','sss', '')
  let word = substitute(word, '\v\Cs$', '', '')
  let word = substitute(word, '\v\C%([nrt]ch|tatus|lias)\zse$', '', '')
  let word = substitute(word, '\v\C%(nd|rt)\zsice$', 'ex', '')

  return word
endfunction
" }}}
function! phpclass#util#pluralize(word) " {{{
" rails.vim(http://www.vim.org/scripts/script.php?script_id=1567)
" rails#pluralize

  let word = a:word
  if word == ''
    return word
  endif

  let word = substitute(word, '\v\C[aeio]@<!y$', 'ie', '')
  let word = substitute(word, '\v\C%(nd|rt)@<=ex$', 'ice', '')
  let word = substitute(word, '\v\C%([osxz]|[cs]h)$', '&e', '')
  let word = substitute(word, '\v\Cf@<!f$', 've', '')
  let word .= 's'
  let word = substitute(word, '\v\Cersons$','eople', '')

  return word
endfunction
" }}}

function! phpclass#util#warning(message) " {{{
  echohl WarningMsg | redraw | echo  a:message | echohl None
endfunction " }}}
function! phpclass#util#error(message) " {{{
  echohl ErrorMsg | redraw | echo  a:message | echohl None
  let v:errmsg = a:message
endfunction " }}}

function! phpclass#util#confirm_create_file(path) " {{{
  let choice = confirm(a:path . " is not found. Do you make a file ?", "&Yes\n&No", 1)

  if choice == 0
    " Was interrupted. Using Esc or Ctrl-C.
    return 0
  elseif choice == 1
    let result1 = system("mkdir -p " . fnamemodify(a:path, ":p:h"))
    let result2 = system("touch " . a:path)
    if strlen(result1) != 0 && strlen(result2) != 0
      call phpclass#util#warning(result2)
      return 0
    else
      return 1
    endif
  endif

  return 0
endfunction
" }}}

function! phpclass#util#strtrim(string) " {{{
  return substitute(substitute(a:string, '^\s\+', "", ""), '\s\+$', "", "")
endfunction " }}}
function! phpclass#util#get_topdir(path) " {{{
  let h = fnamemodify(a:path, ":h")
  if h == '.'
    return a:path
  else
    return phpclass#util#get_topdir(h)
  endif
endfunction " }}}

function! phpclass#util#dirname(...) " {{{
  if a:0 != 1 || strlen(a:1) == 0
    return ''
  endif

  let path = a:1
  if path[strlen(path)-1:] == '/'
    let path = path[0:strlen(path)-2]
  endif

  return fnamemodify(path, ":h")

endfunction " }}}

function! phpclass#util#eval_json_file(path) " {{{
  let dic = {}

  if filereadable(a:path)
    let dic = eval(join(readfile(a:path), ''))
  endif

  return dic
endfunction
"}}}

function! phpclass#util#is_list(expr) " {{{
  return type(a:expr) == type([])
endfunction " }}}
function! phpclass#util#is_dict(expr) " {{{
  return type(a:expr) == type({})
endfunction " }}}

function! phpclass#util#nsort(list) " {{{
  return sort(copy(a:list), 'phpclass#util#compare')
endfunction " }}}
function! phpclass#util#nrsort(list) " {{{
  return reverse(sort(copy(a:list), 'phpclass#util#compare'))
endfunction " }}}
function! phpclass#util#compare(lhs, rhs) " {{{
    return a:lhs - a:rhs
endfunction " }}}



let &cpo = s:save_cpo
unlet s:save_cpo
" vim:set fenc=utf-8 ff=unix ft=vim fdm=marker:
