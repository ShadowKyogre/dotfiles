function tag_search
	set all_tags (implode $argv '.*')
	echo "[\[^[\]*$all_tags\.*].*\$"
	ls .|grep "[\[^[\]*$all_tags.*].*\$"
end
