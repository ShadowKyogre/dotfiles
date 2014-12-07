function transfer
	set ARGS "-i"
        for i in $argv
                set ARGS $ARGS "-F" "filedata=@$i"
        end
        curl $ARGS https://transfer.sh
end
