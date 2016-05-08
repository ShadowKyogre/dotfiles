function newls
	if test (count $argv) -gt 0
		find {$HOME,/media/$USER/sd*-usb-PNY_USB_2.0_FD_*}/{skart,School,Dropbox} \( ! -regex '.*/\..*' \) -type f -mmin -(math 1440 \* $argv[1])
	else
		find {$HOME,/media/$USER/sd*-usb-PNY_USB_2.0_FD_*}/{skart,School,Dropbox} \( ! -regex '.*/\..*' \) -type f -mmin -(math 1440 \* 1)
	end
end
