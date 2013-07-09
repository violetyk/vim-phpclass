if exists('g:loaded_phpclass_vim')
  finish
endif
let g:loaded_phpclass_vim = 1

let s:save_cpo = &cpo
set cpo&vim

let g:phpclass_dir = get(g:, 'phpclass_dir', {
      \ '/home/yuhei/tmp/test' : 'phpclass#camelize',
      \ })
      " \ '/home/yuhei/public_html/symfony/vendor/symfony/symfony/src/Symfony/Component/Console' : 'phpclass#psr0',
      " \ '/usr/local/php/lib/php' : 'phpclass#pear',

call gf#user#extend('phpclass#gf#find', 1000)

function! s:GetCompleListPHPClass(ArgLead, CmdLine, CursorPos) "{{{
  return  phpclass#util#filter_complelist(phpclass#get_classes(), a:ArgLead)
endfunction "}}}

command! -n=+ -complete=customlist,s:GetCompleListPHPClass PHPClass    call phpclass#jump('n', <f-args>)
command! -n=+ -complete=customlist,s:GetCompleListPHPClass PHPClasssp  call phpclass#jump('s', <f-args>)
command! -n=+ -complete=customlist,s:GetCompleListPHPClass PHPClassvsp call phpclass#jump('v', <f-args>)
command! -n=+ -complete=customlist,s:GetCompleListPHPClass PHPClasstab call phpclass#jump('t', <f-args>)

let &cpo = s:save_cpo
unlet s:save_cpo
" vim:set fenc=utf-8 ff=unix ft=vim fdm=marker:
