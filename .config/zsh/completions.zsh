# Can't find any completions here?

unknown_cmds=(
	dateseq
)

for cmd in unknown_cmds;do
	compdef _gnu_generic $cmd
done
