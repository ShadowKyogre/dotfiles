function fish_title
	if test $TERM != fbpad-256
		echo $_ " "
		prompt_pwd
	end
end
