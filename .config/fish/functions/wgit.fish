function wgit
	if test (count $argv) -eq 1
		git clone "git@github.com:ShadowKyogre/"$argv[1]".git"
	else if test (count $argv) -eq 2
		git clone "git@github.com:"$argv[1]"/"$argv[2]".git"
	else if test (count $argv) -eq 3
		git clone "git@github.com:"$argv[1]"/"$argv[2]".git" -b $argv[3]
	end
end
