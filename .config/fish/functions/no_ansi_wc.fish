function no_ansi_wc
	printf "%s" "$argv[1]"|sed -e 's/\x1B\(\[\|(\)[0-9;]*[JKmsuB]//g'|wc -c
end
