/*----------------------------------------------------------
	File Name   : esmc.c 
	Description : SMC test code
	Created by  : SHMT SOC Team
-----------------------------------------------------------*/

/*/////////////////////////////////////////////////////////
        INCLUDE
///////////////////////////////////////////////////////// */
#include "sysinc.h"
#include "Commonmacro.h"
#include "lib.h"
#include "irq.h"

#include "esmc.h"

/*/////////////////////////////////////////////////////////
        DEFINITION
///////////////////////////////////////////////////////// */

#define SRAM0_ADDR		0x00100000
#define SRAM1_ADDR		0x00200000
#define SRAM2_ADDR		0x00300000
#define SRAM3_ADDR		0x00400000
#define SRAM2_ADDR_INC	0x00020000
#define SRAM_SIZE       0x00000010

#define MAKE_GPIO_CON(x)	\
			(((x) << SHIFT_DN_FROM_MASK(GPIO_0))	\
			| ((x) << SHIFT_DN_FROM_MASK(GPIO_1))	\
			| ((x) << SHIFT_DN_FROM_MASK(GPIO_2))	\
			| ((x) << SHIFT_DN_FROM_MASK(GPIO_3))	\
			| ((x) << SHIFT_DN_FROM_MASK(GPIO_4))	\
			| ((x) << SHIFT_DN_FROM_MASK(GPIO_5))	\
			| ((x) << SHIFT_DN_FROM_MASK(GPIO_6))	\
			| ((x) << SHIFT_DN_FROM_MASK(GPIO_7)))

#define GPIO0_EINT_INPUT_MODE	MAKE_GPIO_CON(0)
#define GPIO0_GPIO_INPUT_MODE	MAKE_GPIO_CON(1)
#define GPIO0_GPIO_OUTPUT_MODE	MAKE_GPIO_CON(2)
#define GPIO0_TOUT_OUTPUT_MODE	MAKE_GPIO_CON(3)
			
#define GPIO1_GPIO_INPUT_MODE	MAKE_GPIO_CON(0)
#define GPIO1_GPIO_OUTPUT_MODE	MAKE_GPIO_CON(1)
#define GPIO1_TCAP_INPUT_MODE	MAKE_GPIO_CON(2)
#define GPIO1_OTHER_OUTPUT_MODE	MAKE_GPIO_CON(3)

#define GPIO2_PWM_OUTPUT_MODE	MAKE_GPIO_CON(0)
#define GPIO2_TOUT_OUTPUT_MODE	MAKE_GPIO_CON(1)
#define GPIO2_GPIO_INPUT_MODE	MAKE_GPIO_CON(2)
#define GPIO2_GPIO_OUTPUT_MODE	MAKE_GPIO_CON(3)

#define GPIO3_GPIO_INPUT_MODE	MAKE_GPIO_CON(0)
#define GPIO3_GPIO_OUTPUT_MODE	MAKE_GPIO_CON(1)
#define GPIO3_TCLK_INPUT_MODE	MAKE_GPIO_CON(2)
#define GPIO3_OTHER_OUTPUT_MODE	MAKE_GPIO_CON(3)

/*/////////////////////////////////////////////////////////
        FUNCTION
///////////////////////////////////////////////////////// */

/*-----------------------------------------------------------------------
    Function name   : ESMCTest()
    Prototype           : smtUint32 SMCTest(void)
    Return              : error code
    Argument        :
    Comments        : Return a error-code
-----------------------------------------------------------------------*/
smtUint32 ESMCTest(void)
{
    smtUint32 errorCode;

    // MEM_CS[1]/[2], MEM_WBE[0]/[1]
    //SMT_WRITE(GPIO_CON3, 0xffff);
    SMT_WRITE(GPIO_CON3,
        GPIO_0 | GPIO_1 | GPIO_2 | GPIO_3 |
        GPIO_4 | GPIO_5 | GPIO_6 | GPIO_7);

    //SMT_WRITE(ESMC_B3_CON, 0x01180225);
    SMT_WRITE(ESMC_B3_CON, 
        0x1<<SHIFT_DN_FROM_MASK(TCOSR_MASK) | 0x1<<SHIFT_DN_FROM_MASK(TACCR_MASK) |
        0x2<<SHIFT_DN_FROM_MASK(TCOHR_MASK) | 0x2<<SHIFT_DN_FROM_MASK(TCOSW_MASK) |
        0x2<<SHIFT_DN_FROM_MASK(TACCW_MASK) | 0x1<<SHIFT_DN_FROM_MASK(TCOHW_MASK) |
        0x1<<SHIFT_DN_FROM_MASK(WIDTH_MASK));

    SMT_WRITE(ESMC_B2_CON, 
        0x1<<SHIFT_DN_FROM_MASK(TCOSR_MASK) | 0x1<<SHIFT_DN_FROM_MASK(TACCR_MASK) |
        0x2<<SHIFT_DN_FROM_MASK(TCOHR_MASK) | 0x2<<SHIFT_DN_FROM_MASK(TCOSW_MASK) |
        0x2<<SHIFT_DN_FROM_MASK(TACCW_MASK) | 0x1<<SHIFT_DN_FROM_MASK(TCOHW_MASK) |
        0x1<<SHIFT_DN_FROM_MASK(WIDTH_MASK));

    //SMT_WRITE(ESMC_B1_CON, 0x01180224);
    SMT_WRITE(ESMC_B1_CON,
        0x1<<SHIFT_DN_FROM_MASK(TCOSR_MASK) | 0x1<<SHIFT_DN_FROM_MASK(TACCR_MASK) |
        0x2<<SHIFT_DN_FROM_MASK(TCOHR_MASK) | 0x2<<SHIFT_DN_FROM_MASK(TCOSW_MASK) |
        0x2<<SHIFT_DN_FROM_MASK(TACCW_MASK) | 0x1<<SHIFT_DN_FROM_MASK(TCOHW_MASK));

    errorCode = SRAMTest();

    return errorCode;
}

/*-----------------------------------------------------------------------
    Function name   : MemoryTest()
    Prototype           : smtInt32 MemoryTest(smtUint32 *, smtUint32 *)
    Return              :
    Argument        :
            start_addr  -> memory test start address
            end_addr    -> memory test end address
    Comments        :
-----------------------------------------------------------------------*/
smtInt32 MemoryTest(smtUint32 *start_addr, smtUint32 *end_addr)
{
    smtInt32 i, size;

    size = (smtUint32)end_addr - (smtUint32)start_addr;
    size >>= 2;

    // Memory write
    for(i = 0; i < size; i++)
        start_addr[i] = 0xaaaaaaaa;
    // Memory read
    for(i = 0; i < size; i++)
    {
        if(start_addr[i] != 0xaaaaaaaa)
            return SMT_FALSE;
    }

    // Memory write
    for(i = 0; i < size; i++)
        start_addr[i] = 0x55555555;
    // Memory read
    for(i = 0; i < size; i++)
    {
        if(start_addr[i] != 0x55555555)
            return SMT_FALSE;
    }

    // Memory write
    for(i = 0; i < size; i++)
    {
        if(i & 0x01)
            start_addr[i] = 0x55555555;
        else
            start_addr[i] = 0xaaaaaaaa;
    }
    // Memory read
    for(i = 0; i < size; i++)
    {
        if(i & 0x01)
        {
            if(start_addr[i] != 0x55555555)
                return SMT_FALSE;
        }
        else
        {
            if(start_addr[i] != 0xaaaaaaaa)
                return SMT_FALSE;
        }
    }

    // Memory write
    for(i = 0; i < size; i++)
    {
        start_addr[i] = (smtUint32)(start_addr+i);
    }
    // Memory read
    for(i = 0; i < size; i++)
    {
        if(start_addr[i] != (smtUint32)(start_addr+i))
        {
            return SMT_FALSE;
        }
    }

    return SMT_TRUE;
}

/*-----------------------------------------------------------------------
    Function name   : BANK2Test()
    Prototype       : smtInt32 BANK2Test(void)
    Return          :
    Argument        :
    Comments        : Test Address Line[19:17] & Byte Enable
	                  SRAM2 Connected to Address Line[19:17] as LSB's.
-----------------------------------------------------------------------*/
smtInt32 BANK2Test(void)
{
	smtInt32 i;
	smtUint32 GPIO_CON1_backup, GPIO_CON3_backup;
	
	GPIO_CON1_backup = SMT_READ(GPIO_CON1);
	GPIO_CON3_backup = SMT_READ(GPIO_CON3);
	
	SMT_WRITE(GPIO_CON1, GPIO1_OTHER_OUTPUT_MODE);
	SMT_WRITE(GPIO_CON3, GPIO1_OTHER_OUTPUT_MODE);

	// Write data. This program doesn't test data line, that is tested elsewhere. 
	for(i = 0; i < 8; i++)
	{
		*((volatile smtUint8 *)(SRAM2_ADDR+SRAM2_ADDR_INC*i)) = (i<<1);
		*((volatile smtUint8 *)(SRAM2_ADDR+SRAM2_ADDR_INC*i+1)) = (i<<1)+1;
	}

	// read data       
	for(i = 0; i < 8; i++)  
	{           
		if(*((volatile smtUint8 *)(SRAM2_ADDR+SRAM2_ADDR_INC*i)) != (i<<1))
			goto error;  
		if(*((volatile smtUint8 *)(SRAM2_ADDR+SRAM2_ADDR_INC*i+1)) != (i<<1)+1)
			goto error;  
	}           
	            
	SMT_WRITE(GPIO_CON1, GPIO_CON1_backup);
	SMT_WRITE(GPIO_CON3, GPIO_CON3_backup);
	return SMT_TRUE;       
                
error:          
	SMT_WRITE(GPIO_CON1, GPIO_CON1_backup);
	SMT_WRITE(GPIO_CON3, GPIO_CON3_backup);
	return SMT_FALSE;       
}               
                
/*-----------------------------------------------------------------------
    Function name   : SRAMTest()
    Prototype           : smtUint32 SRAMTest(void)
    Return              : error code
    Argument        :
    Comments        : Return a error-code
-----------------------------------------------------------------------*/
smtInt32 SRAMTest(void)
{
    if(MemoryTest((smtUint32 *)SRAM1_ADDR, (smtUint32 *)(SRAM1_ADDR+SRAM_SIZE)) != SMT_TRUE)
        return ESRAM_ERROR;

    if(MemoryTest((smtUint32 *)SRAM3_ADDR, (smtUint32 *)(SRAM3_ADDR+SRAM_SIZE)) != SMT_TRUE)
        return ESRAM_ERROR;

	if(BANK2Test() != SMT_TRUE)
		return ESRAM_ERROR;

    return NO_ERROR;
}
