=================================================================================
=  Realtek 8139C/8139C+/8169(s) Driver for FreeBSD v4.x/5.1                     =
=================================================================================

This driver is modified by Realtek Semiconductor corp. and it has been tested OK
on FreeBSD v5.1. To update the driver, you may use method 1. If method 1 failed,
you must use method 2 which is more complex.

Method 1:
	1.Copy if_rl.ko in "modules" directory to "/modules" directory and overwrite 
	  the existing file.
	2.Modify the file "/boot/defaults/loader.conf" and set "if_rl_load" in "Network 
	  drivers" section to "Yes"
	3.Reboot.

Method 2:
	Because the FreeBSD kernel has a default Rtl8139C driver, this default driver 
	will be loaded even though the NIC on your computer is Rtl8139C+(because they 
	have the same vender ID and device ID). To use the new features of 8139C+, you 
	need to update your NIC driver and recompile your FreeBSD kernel.

	The main steps you have to do:(FreeBSDSrcDir means the directory of FreeBSD source code
	and it may be "/usr/src/sys")

		0.Replace your NIC with the card listed above.
		1.copy if_rl.c and if_rlreg.h to /FreeBSDSrcDir/pci directory
		2.recompile your kernel	(you must install your FreeBSD source code first !!)

			# cd /usr/src/sys/i386/conf
			# /usr/sbin/config GENERIC
			# cd ../../compile/GENERIC
			# make depend
			# make
			# make install
			# reboot

Question & Answer:
	Q:How to compile under FreeBSD v4.x ?
	A:Change the definition of "OS_VER" in if_rlreg.h