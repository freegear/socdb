mba2440-uboot1.1.1-v1.3.tar.bz2 :
	U-boot source code for MBA2440


uboot-nor.bin :
	u-boot image
	this works only on the NOR flash
	write this image to 0x0 of physical address


uboot-nand.bin :
	u-boot image
	this works only on the NAND flash
	write this image to first block of NAND flash