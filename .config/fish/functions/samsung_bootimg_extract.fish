function samsung_bootimg_extract
	for OFFSET in (od -A d -tx1 boot.img|grep '1f 8b 08'|awk '{print $1}')
		dd if=boot.img bs=1 skip=$OFFSET of=initramfs-$OFFSET.gz
	end
end
