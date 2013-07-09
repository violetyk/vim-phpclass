let s:save_cpo = &cpo
set cpo&vim

function! phpclass#get_classes() "{{{
  let d = {}

  for i in items(g:phpclass_dir)
    let directory = i[0]
    let Fn = i[1]
    for path in split(globpath(directory, "**/*.php"), "\n")
      let class_name = call(Fn, [path, directory])
      let d[class_name] = path
    endfor
  endfor

  return d
endfunction "}}}

function! phpclass#pear(file_path, top_directory) "{{{
  let word = substitute(a:file_path, a:top_directory, '', '')
  if word[0] == '/'
    let word = word[1:strlen(word)]
  endif
  let word =  fnamemodify(word, ':r')
  return substitute(word, '/', '_', 'g')
endfunction "}}}
function! phpclass#psr0(file_path, top_directory) "{{{
  let word = substitute(a:file_path, a:top_directory, '', '')
  if word[0] == '/'
    let word = word[1:strlen(word)]
  endif
  let word =  fnamemodify(word, ':r')
  return join(split(word, '/'), '\')
  " return join(map(split(word, '/'), 'toupper(v:val[0]) . tolower(v:val[1:])'), '\')
endfunction "}}}
function! phpclass#camelize(file_path, top_directory) "{{{
  return phpclass#util#camelize(fnamemodify(a:file_path, ":t:r"))
endfunction "}}}

function! phpclass#jump(...) "{{{
  let split_option = a:1
  let targets = []
  let classes = phpclass#get_classes()
  let a = s:parse_args(a:000)

  for class in a.targets
    if has_key(classes, class)
      call phpclass#util#open_file(classes[class], a.split_option, 0)
    endif
  endfor

endfunction "}}}

function! s:parse_args(args) "{{{
  let d = {'split_option' : 'n', 'targets' : []}
  for arg in a:args
    if phpclass#util#in_array(arg, ['n', 's', 'v', 't'])
      let d.split_option = arg
      continue
    endif
    call add(d.targets, arg)
  endfor
  return d
endfunction "}}}

let &cpo = s:save_cpo
unlet s:save_cpo
" vim:set fenc=utf-8 ff=unix ft=vim fdm=marker:
