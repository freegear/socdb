[ReadMe]

-Ethernet Driver ver0.1(2006/10/13)

#######ethernet driver for Wince(miniport driver : LAN91C111.DLL)

further work:
	- modifying LAN91c111.reg
		- base address
		- interrupt number
		- bustype/busnumber
		- dhcp enable/disable
	- memory address mapping issue
		- NdisMRegisterIoPortRange 
							 
######## ethernet driver for kitl(oal_ethdrv_lan91c.lib)

####### ethernet driver for eboot (smsc91c.lib)
0. create the folder and files for smsc91c.lib
 	PUBLIC\COMMON\OAK\DRIVERS\ETHDBG
 		\SMSC91C
				smsc91c.c
				makefile
				sources
1. modifying
	PUBLIC\COMMON\OAK\DRIVERS\ETHDBG
		- dir
			add smsc91c
			
	PUBLIC\COMMON\OAK\DRIVERS\ETHDBG
 		\SMSC91C
		- smsc91c.c 
			 remove the the line #include <oal.h>
			 replace the fuction OALMSGS to EdbgOutputDebugString
			 define the macro OUTPORT16/INPORT16/SETPORT16
		 
		- sources
			 just remove the lines below
			 #xref VIGUID {55a4336f-155d-47d7-b486-bfcf912e48f4}
			 #xref VSGUID {a6ebad8f-c0c0-4ce0-9732-d2751306f813}
		
	 PUBLIC\COMMON\OAK\INC\
	 	- halether.h
		 	add smsc91c driver function prototype.
	 	
	PUBLIC\COMMON\CESYSGEN\
		- makefile
			 add smsc91c 

	PLATFORM\SkyWalker50\Src\Bootloader\Eboot
		- ether.c
			replace the func pointer to smsc91c driver function below.
			BOOL    Smsc91CInit(UINT8 *pAddress, UINT32 offset, UINT16 mac[3]);
			UINT16  Smsc91CGetFrame(UINT8 *pBuffer, UINT16 *pLength);
			UINT16  Smsc91CSendFrame(UINT8 *pBuffer, UINT32 length);
		- sources 
			smsc100.lib -> smsc91c.lib
	
further work : 	
	- implementing the functioins below.
		 Smsc91CGetTickCount
		 Smsc91CStall
	- think about how to debug the driver.		 
