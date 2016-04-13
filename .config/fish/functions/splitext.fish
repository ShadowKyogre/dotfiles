function splitext
	set pycode "import sys, os, shlex;print('\n'.join([shlex.quote(s) for s in os.path.splitext(sys.argv[1])]))" 
	python -c "$pycode" "$argv[1]"
end
