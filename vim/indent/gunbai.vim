" Vim indent file
" Language:		gunbai
" Maintainer:		Sho Aita
" Last Modified:	3sep2013 

" Only load this indent file when no other was loaded.
if exists("b:did_indent")
    finish
endif

let b:did_indent = 1

"setlocal indentexpr=TcshGetIndent()
"setlocal indentkeys+=e,0=end,0=endsw indentkeys-=0{,0},0),:,0#
setlocal autoindent
setlocal indentexpr=GetGunbaiIndent()
setlocal indentkeys=!^F,o,O,O=elif,0=else,0=endif,0=endwhile,0=endfunc


" Only define the function once.
if exists("*GetGunbaiIndent")
    finish
endif


let b:undo_indent='setlocal autoindent< indentexpr< indentkeys<'
"let b:undo_indent = 'setlocal '.join([
"\   'autoindent<',
"\   'expandtab<',
"\   'indentexpr<',
"\   'indentkeys<',
"\   'shiftwidth<',
"\   'softtabstop<',
"\   'tabstop<',
"\ ])


function! GetGunbaiIndent()
  " Find a non-blank line above the current line.
  let lnum = prevnonblank(v:lnum - 1)
  " Hit the start of the file, use zero indent.
  if lnum == 0
    return 0
  endif
  " Add indent if previous line begins with while or foreach
  " OR line ends with case <str>:, default:, else, then or \
  let ind = indent(lnum)
  let line = getline(lnum)
  if line =~ '^\s*\(if\|elif\|while\|func\|else\)\(\s\|$\|(\)'
    let ind = ind + &sw 
  endif

  " Subtract indent if current line has on end, endif, case commands
  let line = getline(v:lnum)
  if line =~ '^\s*\(else\|elif\|end\|endif\|endwhile\|endfunc\)\s*'
    let ind = ind - &sw
  endif
  return ind
endfunction

