function list_exe_icons
	for arg in $argv
		echo Files in $arg
		wrestool -l $arg | grep group_icon | awk '{ print $2}' | cut -f2 -d=
	end
end
