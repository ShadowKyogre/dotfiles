function wgit
	set -l SLUG_FMT "[a-zA-Z0-9_-]\+"

	# repo checking formats
	set -l REPO_FORMATS \
		"^$SLUG_FMT\$" \
		"^$SLUG_FMT/$SLUG_FMT\$" \
		"^$SLUG_FMT#.*\$" \
		"^$SLUG_FMT/$SLUG_FMT#.*\$"

	# output: owner repo branch
	set -l EXTRACTORS \
		"s|\(^$SLUG_FMT\$\)|\n\1\n|g" \
		"s|\(^$SLUG_FMT\)/\($SLUG_FMT\$\)|\1\n\2\n|g" \
		"s|\(^$SLUG_FMT\)#\(.*\$\)|\n\1\n\2\n|g" \
		"s|\(^$SLUG_FMT\)/\($SLUG_FMT\)#\(.*\$\)|\1\n\2\n\3|g"

	for arg in $argv
		for idx in (count REPO_FORMATS)
			echo "$REPO_FORMATS[$idx]"
			if echo "$arg"|sgrep -q "$REPO_FORMATS[$idx]"

				set -l repo_parts (echo "$arg"|sed -e "$EXTRACTORS[$idx]")
				breakpoint
				if test -z "$repo_parts[1]"
					set repo_parts[1] "ShadowKyogre"
				end

				if echo "$repo_parts[1]"|sgrep -qi "ShadowKyogre"
					set -l repo_fmt "git@github.com:$repo_parts[1]/$repo_parts[2].git"
				else
					set -l repo_fmt "https://github.com/$repo_parts[1]/$repo_parts[2].git"
				end

				if test -z "$repo_parts[3]"
					git clone "$repo_fmt"
				else
					git clone "$repo_fmt" -b "$repo_parts[3]"
				end

				break
			end
		end
	end
end
