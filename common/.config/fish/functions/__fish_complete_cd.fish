function __fish_complete_cd --description 'Completions for the cd command'
	
	# We can't simply use __fish_complete_directories because of the CDPATH
	#
	set -l wd $PWD

	# Check if CDPATH is set

	set -l mycdpath

	if test -z $CDPATH[1]
		set mycdpath .
	else
		set mycdpath $CDPATH
	end

	# Note how this works: we evaluate $ctoken*/
	# That trailing slash ensures that we only expand directories

	set -l ctoken (commandline -ct)
	if echo $ctoken | sgrep '^/\|^\./\|^\.\./\|^~/' >/dev/null
		# This is an absolute search path
		# Squelch descriptions per issue 254
		#eval printf '\%s\\n' $ctoken\*/
		#printf '\%s\\n' $ctoken\*/
		set expanded (echo $ctoken|sed "s|^~/|$HOME/|")
		if test -d $expanded
			for ctk in (find $expanded -maxdepth 1 -type d)
				printf '%s\n' $ctk
			end
		else
			for ctk in (find (dirname $expanded) -maxdepth 1 -type d -wholename (basename $expanded)\*)
				printf '%s\n' $ctk
			end
		end
	else
		# This is a relative search path
		# Iterate over every directory in CDPATH
		# and check for possible completions

		for i in $mycdpath
			# Move to the initial directory first,
			# in case the CDPATH directory is relative

			builtin cd $wd
			builtin cd $i

			# What we would really like to do is skip descriptions if all
			# valid paths are in the same directory, but we don't know how to
			# do that yet; so instead skip descriptions if CDPATH is just .
			if test "$mycdpath" = .
				if test -d $ctoken
					for ctk in (find $ctoken -maxdepth 1 -type d)
						printf '%s\n' $ctk
					end
				else
					for ctk in (find . -maxdepth 1 -type d -wholename $ctoken\*)
						printf '%s\n' $ctk
					end
				end
			else

				printf '"%s\tin "'$i'"\n"' $ctoken\*/
			end
		end
	end

	builtin cd $wd
end
