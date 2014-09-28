function new_wine_prefix
	if test (count argv) -eq 0
		echo "Sorry, can't make another wine prefix without a parameter"
	        return 1
	else if test (count argv) -eq 1
		env WINEPREFIX=~/.local/share/wineprefixes/"{$argv[1]}" WINEARCH="win32" wine wineboot
	else
		env WINEPREFIX=~/.local/share/wineprefixes/"{$argv[1]}" WINEARCH="{$argv[2]}" wine wineboot
	end
end
