" Version 0.0.0
" License: MIT license  {{{
"     Permission is hereby granted, free of charge, to any person obtaining
"     a copy of this software and associated documentation files (the
"     "Software"), to deal in the Software without restriction, including
"     without limitation the rights to use, copy, modify, merge, publish,
"     distribute, sublicense, and/or sell copies of the Software, and to
"     permit persons to whom the Software is furnished to do so, subject to
"     the following conditions:
"
"     The above copyright notice and this permission notice shall be included
"     in all copies or substantial portions of the Software.
"
"     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
"     OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
"     MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
"     IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
"     CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
"     TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
"     SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
" }}}




let s:save_cpo = &cpo
set cpo&vim

function! easysubmode#load()
  runtime! plugin/easysubmode.vim
endfunction

function! easysubmode#define(submode)
  let s:submode = a:submode
endfunction

function! easysubmode#submode(map, ...)
  let args = a:000

  if a:map =~# 'map$'
    let mode = a:map[0]
  else
    let mode = a:map
  endif

  if a:1 =~# '^<\%(enter\|leave\|unmap\)>$'
    let type = a:1
    let rest = args[1 : ]
  else
    let type = '<map>'
    let rest = args
  endif

  let options = ''
  for option in rest
    if option =~# '^<\%(buffer\|expr\|unique\|silent\|r\|x\)>$'
      let options .= option[1]
      call remove(rest, 0)
    endif
  endfor

  let mappings = rest
  if len(mappings) == 2
    let [lhs, rhs] = mappings
  else
    let lhs = mappings[0]
    let rhs = lhs
  endif

  if type ==# '<enter>'
    call submode#enter_with(s:submode, mode, options, lhs, rhs)
  elseif type ==# '<leave>'
    call submode#leave_with(s:submode, mode, options, lhs)
  elseif type ==# '<map>'
    call submode#map(s:submode, mode, options, lhs, rhs)
  elseif type ==# '<unmap>'
    call submode#unmap(s:submode, mode, options, lhs)
  endif
endfunction

function! easysubmode#define_end()
  if exists('s:submode')
    unlet s:submode
  endif
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
