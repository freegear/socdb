MBA2440_nand_loader.zip :
	nboot source code


nboot.bin :
	nboot binary image
	
	Write this image to first block of NAND flash memory
	and then, write WinCE image to second block
	WinCE image must be 0x1400000 size