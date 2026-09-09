#include "sysinc.h"
#include "commonmacro.h"
#include "uart_post_drv.h"

extern smtBoolean smtNorReset(void);
extern smtBoolean smtNorReadID(smtUint8 *mID, smtUint8 *dID);
extern smtBoolean smtNorWriteBlock(smtUint32 address,smtUint8 *data,smtUint32 datalen);
extern smtUint32 NorWriteTest(void);

#define FLASH_BOOTLOADER_BASE	0x0
#define FLASH_DDRIMAGE_BASE		0x8000

smtUint32 NorWriteTest(void)
{
	smtUint8 mID, dID;
	smtUint32 ret;
	
	ESMC_B1_CON = 0xFFFF0;
	
	smtNorReset();
	
	smtNorReadID(&mID, &dID);		
	smt2UARTPrint(CFG_UART_CH, "Manufacture ID = 0x%x\n", mID);	
	smt2UARTPrint(CFG_UART_CH, "Device ID = 0x%x\n", dID);

	ret = smtNorWriteBlock(0x0, (smtUint8*)0x63000000, 8*1024*1024);

	if(ret==SMT_FALSE)
		smt2UARTPrint(CFG_UART_CH, "Write Fail.....\n");	
	else
		smt2UARTPrint(CFG_UART_CH, "Write Success.....\n");	
			
	return 0;
}
