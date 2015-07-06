function tag_ls
	set tag_cats (cat tags.cfg.json|jshon -k)
	for tag_cat in $tag_cats
		printf "%s%s" (set_color -b (cat tags.cfg.json|jshon -e $tag_cat|jshon -e bg -u) ) (set_color (cat tags.cfg.json|jshon -e $tag_cat|jshon -e fg -u) ) 
		printf "%s%s%s\n" $tag_cat (set_color -b normal) (set_color normal)
	end
end
