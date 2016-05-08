function getarchpkg
	command git clone --depth=1 https://projects.archlinux.org/git/svntogit/packages.git -b packages/$argv[1] $argv[1]
	if test $status -eq 128
		command git clone --depth=1 https://projects.archlinux.org/git/svntogit/community.git -b packages/$argv[1] $argv[1]
	end
end
