# Can't find any completions here?

unknown_cmds=(
	asciinema
	qpdfview
	termite
	dadd
	dateadd
	dateconv
	datediff
	dategrep
	dateround
	dateseq
	datesort
	datetest
	datezone
	dconv
	ddiff
	dgrep
	dround
	dseq
	dsort
	dtest
	dzone
	strptime
	percol
	ag
)

compdef _gnu_generic ${unknown_cmds[@]}

compdef _functions funced
compdef _functions funcsave
compdef _functions newf
