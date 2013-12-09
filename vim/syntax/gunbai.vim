"
" Vim syntax file
" Language   :	Gunbai
" Maintainer :	Sho Aita
" File type  :	*.gun (see :help filetype)
" History
"	3sep2013	sho		0.1		Creation.  Adapted from gunbai.vim.
"


" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif


" Reserved words.
syn keyword gunbaiBuiltInFunction			gb_remaining_turns
syn keyword gunbaiBuiltInFunction			gb_turns_before_enabling_syzygies
syn keyword gunbaiBuiltInFunction			gb_field_size
syn keyword gunbaiBuiltInFunction			gb_hexel_owner
syn keyword gunbaiBuiltInFunction			gb_gate_positions
syn keyword gunbaiBuiltInFunction			gb_agent_positions
syn keyword gunbaiBuiltInFunction			gb_agent_status
syn keyword gunbaiBuiltInFunction			gb_team_id
syn keyword gunbaiBuiltInFunction			gb_random_value
syn keyword gunbaiBuiltInFunction			gb_move
syn keyword gunbaiBuiltInFunction			gb_storage
syn keyword gunbaiStatement			return
syn keyword gunbaiDeclare  			local 
syn keyword gunbaiFunction			func endfunc
"syn keyword gunbaiPredicate			
syn keyword gunbaiDebug				print
syn keyword gunbaiRepeat			while endwhile break continue
syn keyword gunbaiConditional		if elif else endif

" Reserved constants.
syn match gunbaiConstant			"\(%\)[0-9A-Za-z?!#$]\+"

" Delimiters and operators.
syn match gunbaiDelimiter			"[][,()]"
syn match gunbaiComparison			"[<=>!]="
syn match gunbaiComparison			"[<>]"
syn match gunbaiLogical				"[&|$]"
syn match gunbaiArithmetic			"="
syn match gunbaiArithmetic			"*="
syn match gunbaiArithmetic			"[+-/%]"
syn match gunbaiArithmetic			"[+-/%=]="
syn match gunbaiTransposition		"[])a-zA-Z0-9?!_#$.]'"lc=1

" Comments and tools.
syn keyword gunbaiTodo				TODO todo FIXME fixme TBD tbd	contained
syn match gunbaiComment				"#\s*[^\$].*$"	contains=gunbaiTodo
syn match gunbaiCommand				"#\s*\$"
"contains=gunbaiConditional,gunbaiNumber,gunbaiIdentifier,gunbaiString,gunbaiArithmetic,gunbaiVariable
syn match gunbaiVariable			"@\w\w*"
syn match gunbaiVariable			"@{\s*\w\w*\s*}"
syn match gunbaiVariable			";"

" Constants.
syn match gunbaiNumber				"[0-9]\+\(\.[0-9]*\)\=\([DEde][+-]\=[0-9]\+\)\="
syn match gunbaiNumber				"\.[0-9]\+\([DEde][+-]\=[0-9]\+\)\="
syn region gunbaiString				start=+'+ skip=+''+ end=+'+		oneline contains=gunbaiVariable
"syn region gunbaiString				start=+"+ end=+"+				oneline

" Identifiers.
syn match gunbaiIdentifier			"\<[A-Za-z?!_#$][A-Za-z0-9?!_#$]*\>"
syn match gunbaiOverload			"%[A-Za-z0-9?!_#$]\+_[A-Za-z0-9?!_#$]\+"


" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_gunbai_syntax_inits")
	if version < 508
		let did_gunbai_syntax_inits = 1
		command -nargs=+ HiLink hi link <args>
	else
		command -nargs=+ HiLink hi def link <args>
	endif

	HiLink	gunbaiStatement				Statement
	HiLink	gunbaiDeclare 				Type
	HiLink	gunbaiExec					Type
	HiLink	gunbaiBuiltInFunction		Macro
	HiLink	gunbaiFunction				Type
	HiLink	gunbaiPredicate				Keyword
	HiLink	gunbaiKeyword				Keyword
	HiLink	gunbaiDebug					Debug
	HiLink	gunbaiRepeat				Repeat
	HiLink	gunbaiConditional			Repeat
	HiLink  gunbaiVariable              Identifier

	HiLink	gunbaiConstant				Constant
	HiLink	gunbaiBoolean				Boolean
	HiLink	gunbaiCommand				Identifier

	HiLink	gunbaiDelimiter				Delimiter
	HiLink	gunbaiMlistAccess			Delimiter
	HiLink	gunbaiComparison			Operator
	HiLink	gunbaiLogical				Operator
	HiLink	gunbaiArithmetic			Operator
	HiLink	gunbaiRange					Operator
	HiLink	gunbaiLineContinuation		Underlined
	HiLink	gunbaiTransposition			Operator

	HiLink	gunbaiTodo					Todo
	HiLink	gunbaiComment				Comment

	HiLink	gunbaiNumber				Number
	HiLink	gunbaiString				String

	HiLink	gunbaiIdentifier			Normal
	HiLink	gunbaiOverload				Special

	delcommand HiLink
endif

let b:current_syntax = "gunbai"

"EOF	vim: ts=4 noet tw=100 sw=4 sts=0
