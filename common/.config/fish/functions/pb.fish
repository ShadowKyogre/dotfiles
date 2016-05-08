function pb
	for arg in $argv
		curl -H "Accept: application/json" -F "c=@$arg" https://ptpb.pw|jshon -e url -u
	end
end
