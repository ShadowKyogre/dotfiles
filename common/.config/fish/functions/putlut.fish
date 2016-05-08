function putlut
	for arg in $argv
		set img_short (curl -F format=json -F "file=@$arg"  https://lut.im|jshon -e msg -e short -u)
		echo "https://lut.im/$img_short"
	end
end
