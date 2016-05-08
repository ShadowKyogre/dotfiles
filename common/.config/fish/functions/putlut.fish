function putlut
	set img_short (curl -F format=json -F "file=@$argv[1]"  https://lut.im|jshon -e msg -e short -u)
	echo "https://lut.im/$img_short"
end
