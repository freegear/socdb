#include "bootcode.h"
#include "smt_nand_cfg.h"

extern smtBoolean NANDU_Open(void);
extern smtBoolean NANDU_Close(void);
extern smtBoolean	NANDU_128kWriter(smtUint32 addr128k, smtUint32 buffer);
extern smtBoolean	NANDU_128kReader(smtUint32 addr128k, smtUint32 buffer);

/*-----------------------------------------------------------------------
    Function name   : NandBootWriter
    Prototype       : smtUint32 NandBootWriter(void)
    Return          : 
    Argument        : 
    Comments        : 
-----------------------------------------------------------------------*/
smtUint32 NandBootWriter(void)
{
	
	smtUint32 	Idx;
	smtUint32	buffer;
	smtUint32	handle;
	smtUint32	len;
	smtUint8	ch;
	
	// Nand open
	NANDU_Open();
	
	
	smt2UartPrint(11, "Press any key to write nandboot!!\n");
	smt2UartGetCh(0);
	//--------------------------------------------------------------------------
	// temp use	
	//--------------------------------------------------------------------------
	
	// write test pattern
	{
		static char buffer[128*1024];
	
		
		/* second write try */
		
		// write boot up
		smt2UartPrint(11, "Boot up code write start ");
		NANDU_128kWriter(0, (smtUint32)bootCode);	// 0 : 1st block #, bootCode : Block size
		smt2UartPrint(11, "Boot up code write complete!!\n");
		
		
		smt2UartPrint(11, "ct500 binary image code write start from 0x60100000");
		// write image 2MB
		{
			int i;
			
			for(i = 0; i < 0x500000/0x20000; i++)	// 0x200000/0x20000 = 2MB/128KB
			{
				NANDU_128kWriter(i+1, (smtUint32)0x60100000+i*0x20000);
				smt2UartPrint(11, "NANDU_128kWriter: %d sector\n", i);
			}
		}
		smt2UartPrint(11, "ETRI UWB binary image code write complete!!!\n");
	}
	while(1);

	
	// NAND Close
	NANDU_Close();
	
	return 0;
}
