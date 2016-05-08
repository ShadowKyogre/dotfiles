function tag_search
	set all_tags (implode $argv '.*')
	# echo "[\[^[\]*$all_tags\.*].*\$"
	# above is constructed regex for debugging
	ls .|grep "[\[^[\]*$all_tags.*].*\$"
end
