/*----------------------------------------------------------
	File Name   : fmc.c 
	Description : FMC test code
	Created by  : SHMT SOC Team
-----------------------------------------------------------*/

/*/////////////////////////////////////////////////////////
        INCLUDE
///////////////////////////////////////////////////////// */
#include "sysinc.h"
#include "Commonmacro.h"
#include "lib.h"
#include "irq.h"
#include "structDef.h"

#include "fmc.h"


/*/////////////////////////////////////////////////////////
        DEFINITION
///////////////////////////////////////////////////////// */
#define REGISTER_CHK    1
#define PROG_NORMAL     1
#define PROG_OPTION     1
#define ERASE_SECTOR    1
#define ERASE_CHIP      1

#define FIXED_VALUE     0xaaaaaaaa
#define FLASH_INIT_VALUE    0xffffffff


#define EXT_SRAM_ADDR   0x00400000
#define FMC_TEST_ERR    0x0
#define FMC_REG_ERR     0x1000
#define FMC_OPT_ERR     0xa000

// If you wanna test FMC module detaily, the following define is valid.
#if 1
#define OUTERRCODE(x)      OutErrCode(x)    // FMC detail error-code print
#else
#define OUTERRCODE(x)
#endif

/*/////////////////////////////////////////////////////////
        FUNCTION DECLARATION
///////////////////////////////////////////////////////// */
smtUint32 FMCTest(void);

/*/////////////////////////////////////////////////////////
        FUNCTION
///////////////////////////////////////////////////////// */

/*-----------------------------------------------------------------------
    Function name   : FMCTest()
    Prototype           : smtUint32 FMCTest(void)
    Return              : error code
    Argument        :
    Comments        : Return a error-code

    FMC register list
-----------------------------------------------------------------------*/
smtUint32 FMCTest(void)
{
    volatile smtUint32 readData;

#if REGISTER_CHK
    OUTERRCODE(FMC_TEST_ERR+1);
    if(RegisterChk() != NO_ERROR)
        return FMC_ERROR;
    OUTERRCODE(~(FMC_TEST_ERR+1));
#endif

#if ERASE_CHIP
    // Chip Erase
    OUTERRCODE(FMC_TEST_ERR+2);
    if(EraseChipTest() != NO_ERROR)
        return FMC_ERROR;
    OUTERRCODE(~(FMC_TEST_ERR+2));
	
    // flash memory read
    OUTERRCODE(FMC_TEST_ERR+3);
    readData = FlashMemRead(0x00000);
    if(readData != FLASH_INIT_VALUE)
        return FMC_ERROR;
        
    OUTERRCODE(FMC_TEST_ERR+4);
    readData = FlashMemRead(0x00004);
    if(readData != FLASH_INIT_VALUE)
        return FMC_ERROR;
        
    OUTERRCODE(FMC_TEST_ERR+5);
    readData = FlashMemRead(0x00010);
    if(readData != FLASH_INIT_VALUE)
        return FMC_ERROR;
        
    OUTERRCODE(FMC_TEST_ERR+6);
    readData = FlashMemRead(0x0a000);
    if(readData != FLASH_INIT_VALUE)
        return FMC_ERROR;

    OUTERRCODE(FMC_TEST_ERR+7);
    readData = FlashMemRead(0x0a004);
    if(readData != FLASH_INIT_VALUE)
        return FMC_ERROR;

    OUTERRCODE(FMC_TEST_ERR+8);
    readData = FlashMemRead(0x0a010);
    if(readData != FLASH_INIT_VALUE)
        return FMC_ERROR;
#endif

#if PROG_NORMAL
    OUTERRCODE(FMC_TEST_ERR+9);
    if(Prog2Page() != NO_ERROR)
        return FMC_ERROR;
    OUTERRCODE(~(FMC_TEST_ERR+9));
#endif

#if PROG_OPTION
    OUTERRCODE(FMC_TEST_ERR+0xa);
    if(ProgOptionTest() != NO_ERROR)
        return FMC_ERROR;
    OUTERRCODE(~(FMC_TEST_ERR+0xa));
	
    // Chip Erase
    OUTERRCODE(FMC_TEST_ERR+0xb);
    if(EraseChipTest() != NO_ERROR)
        return FMC_ERROR;
    OUTERRCODE(~(FMC_TEST_ERR+0xb));
	  	
    // flash memory read
    OUTERRCODE(FMC_TEST_ERR+0xc);
        readData = FlashMemRead(0x00000);
    if(readData != FLASH_INIT_VALUE)
    return FMC_ERROR;
        
    OUTERRCODE(FMC_TEST_ERR+0xd);	
    readData = FlashMemRead(0x00004);
    if(readData != FLASH_INIT_VALUE)
        return FMC_ERROR;
        
    OUTERRCODE(FMC_TEST_ERR+0xe);
    readData = FlashMemRead(0x00010);
    if(readData != FLASH_INIT_VALUE)
        return FMC_ERROR;
        
    OUTERRCODE(FMC_TEST_ERR+0xf);
    readData = FlashMemRead(0x0a000);
    if(readData != FLASH_INIT_VALUE)
        return FMC_ERROR;
	
    OUTERRCODE(FMC_TEST_ERR+0x10);
    readData = FlashMemRead(0x0a004);
    if(readData != FLASH_INIT_VALUE)
        return FMC_ERROR;

    OUTERRCODE(FMC_TEST_ERR+0x11);
    readData = FlashMemRead(0x0a010);
    if(readData != FLASH_INIT_VALUE)
        return FMC_ERROR;
#endif
    OUTERRCODE(FMC_TEST_ERR+0x12);

    return NO_ERROR;
}

/*-----------------------------------------------------------------------
    Function name   : RegisterChk()
    Prototype           : smtUint32 RegisterChk(void)
    Return              : error code
    Argument        :
    Comments        : Register check
-----------------------------------------------------------------------*/
smtUint32 RegisterChk(void)
{
    volatile smtUint32 readData;

    // FM Register WR/RD check
    OUTERRCODE(FMC_REG_ERR+1);
    SMT_WRITE(FMKEY, 0x5a5a5a5a);
    readData=SMT_READ(FMKEY);
    if(readData != 0x5a5a5a5a)
        return FMC_ERROR;

    OUTERRCODE(FMC_REG_ERR+2);
    SMT_WRITE(FMKEY, 0xa5a5a5a5);
    readData=SMT_READ(FMKEY);
    if(readData != 0xa5a5a5a5)
        return FMC_ERROR;

    OUTERRCODE(FMC_REG_ERR+3);

    SMT_WRITE(FMADDR, 0x3c3c3c3c);      // Flash memory address
    readData=SMT_READ(FMADDR);
    if(readData != 0x3c3c3c3c)
        return FMC_ERROR;

    OUTERRCODE(FMC_REG_ERR+4);
    SMT_WRITE(FMADDR, 0xc3c3c3c3);      // Flash memory address
    readData=SMT_READ(FMADDR);
    if(readData != 0xc3c3c3c3)
        return FMC_ERROR;

    OUTERRCODE(FMC_REG_ERR+5);
    SMT_WRITE(FMDATA, 0xc3c3c3c3);      // Flash memory data
    readData=SMT_READ(FMDATA);
    if(readData != 0xc3c3c3c3)
        return FMC_ERROR;

    OUTERRCODE(FMC_REG_ERR+6);
    SMT_WRITE(FMDATA, 0x3c3c3c3c);      // Flash memory data
    readData=SMT_READ(FMDATA);
    if(readData != 0x3c3c3c3c)
        return FMC_ERROR;

    OUTERRCODE(FMC_REG_ERR+7);
    SMT_WRITE(FMUCON, 0x000007a7);
    readData=SMT_READ(FMUCON);
    if(readData != 0x000007a7)
        return FMC_ERROR;

    OUTERRCODE(FMC_REG_ERR+8);
    SMT_WRITE(FMTNV, 0xa5a5a5a5);
    readData=SMT_READ(FMTNV);
    OUTERRCODE(readData>>16);
    OUTERRCODE(readData);
    if(readData != 0xa5a5a5a5)
        return FMC_ERROR;
        
    OUTERRCODE(FMC_REG_ERR+9);
    SMT_WRITE(FMTPG, 0x5a5a5a5a);
    readData=SMT_READ(FMTPG);
    if(readData != 0x5a5a5a5a)
        return FMC_ERROR;

    OUTERRCODE(FMC_REG_ERR+0xA);
    SMT_WRITE(FMTRCV, 0xa5a5a5a5);
    readData=SMT_READ(FMTRCV);
    if(readData != 0xa5a5a5a5)
        return FMC_ERROR;
    
    OUTERRCODE(FMC_REG_ERR+0xB);
    SMT_WRITE(FMTPROG, 0x005a5a5a);
    readData=SMT_READ(FMTPROG);
    if(readData != 0x005a5a5a)
        return FMC_ERROR;

    OUTERRCODE(FMC_REG_ERR+0xC);
    SMT_WRITE(FMTERASE, 0xa5a5a5a5);
    readData=SMT_READ(FMTERASE);
    if(readData != 0xa5a5a5a5)
        return FMC_ERROR;

    OUTERRCODE(FMC_REG_ERR+0xD);
    SMT_WRITE(FMTME, 0x5a5a5a5a);
    readData=SMT_READ(FMTME);
    if(readData != 0x5a5a5a5a)
        return FMC_ERROR;

    OUTERRCODE(FMC_REG_ERR+0xE);
    //----------------------
    // Return initial value
    SMT_WRITE(FMUCON, 0x00000300);
    readData=SMT_READ(FMUCON);
    if(readData != 0x00000300)
        return FMC_ERROR;
        
    SMT_WRITE(FMTNV, 0x003F003F);
    readData=SMT_READ(FMTNV);
    if(readData != 0x003F003F)
        return FMC_ERROR;

    SMT_WRITE(FMTPG, 0x007F0003);
    readData=SMT_READ(FMTPG);
    if(readData != 0x007F0003)
        return FMC_ERROR;

    SMT_WRITE(FMTRCV, 0x000E04EA);
    readData=SMT_READ(FMTRCV);
    if(readData != 0x000E04EA)
        return FMC_ERROR;

    SMT_WRITE(FMTPROG, 0x000500FB);
    readData=SMT_READ(FMTPROG);
    if(readData != 0x000500FB)
        return FMC_ERROR;

    SMT_WRITE(FMTERASE, 0x0003D090);
    readData=SMT_READ(FMTERASE);
    if(readData != 0x0003D090)
        return FMC_ERROR;

    SMT_WRITE(FMTME, 0x0003D090);
    readData=SMT_READ(FMTME);
    if(readData != 0x0003D090)
        return FMC_ERROR;

    return NO_ERROR;
}

/*-----------------------------------------------------------------------
    Function name   : ProgNormalTest()
    Prototype           : smtUint32 ProgNormalTest(void)
    Return              : error code
    Argument        :
    Comments        : Write operation
            Normal program test
-----------------------------------------------------------------------*/
smtUint32 ProgNormalTest(void)
{
    volatile smtUint32 readData;
    smtUint32 errorCnt, size;
    FM_STRUCT flashWrite;

    flashWrite.addr = 0x0;
    flashWrite.data = FIXED_VALUE;
    flashWrite.length = 4;
    flashWrite.mode = FM_PROGRAM;

    // Flash whole size write
    for(size=0; size<(FLASH_MAX_SIZE/4)/256; size++)     // 1KB
    {
        FlashMemWrite(flashWrite);
        flashWrite.addr += 4;
    }

    errorCnt = 0;
    // Flash whole size read
    flashWrite.addr = 0x0;

    for(size=0; size<(FLASH_MAX_SIZE/4)/256; size++)
    {
        readData = FlashMemRead(flashWrite.addr );
        if(readData != FIXED_VALUE)
        {
            //errorCnt++;
            return FMC_ERROR;
        }
        flashWrite.addr += 4;
    }

    return NO_ERROR;
}

/*-----------------------------------------------------------------------
    Function name   : Prog2Page()
    Prototype           : smtUint32 ProgNormalTest(void)
    Return              : error code
    Argument        :
    Comments        : Write operation
          Write words at page 0 and 0x28
-----------------------------------------------------------------------*/
smtUint32 Prog2Page(void)
{
    volatile smtUint32 readData;
    FM_STRUCT flashWrite;

    flashWrite.length = 4;
    flashWrite.mode = FM_PROGRAM;

    // Flash programming at page 0
    flashWrite.addr = 0x00;
    flashWrite.data = 0x3a35a5ac;

    FlashMemWrite(flashWrite);
    readData = FlashMemRead(flashWrite.addr );
    if(readData != flashWrite.data)
        return FMC_ERROR;

    flashWrite.addr = 0x04;
    flashWrite.data = 0x130a5088;

    FlashMemWrite(flashWrite);
    readData = FlashMemRead(flashWrite.addr );
    if(readData != flashWrite.data)
        return FMC_ERROR;

    flashWrite.addr = 0x010;
    flashWrite.data = 0x0;

    FlashMemWrite(flashWrite);
    readData = FlashMemRead(flashWrite.addr );
    if(readData != flashWrite.data)
        return FMC_ERROR;

    // Flash programming at page 0x28
    flashWrite.addr = 0x0a000;
    flashWrite.data = 0x12579bdf;

    FlashMemWrite(flashWrite);
    readData = FlashMemRead(flashWrite.addr );
    if(readData != flashWrite.data)
        return FMC_ERROR;

    flashWrite.addr = 0x0a004;
    flashWrite.data = 0x12579bdf;

    FlashMemWrite(flashWrite);
    readData = FlashMemRead(flashWrite.addr );
    if(readData != flashWrite.data)
        return FMC_ERROR;

    flashWrite.addr = 0x0a010;
    flashWrite.data = 0xa3a35a5a;

    FlashMemWrite(flashWrite);
    readData = FlashMemRead(flashWrite.addr );
    if(readData != flashWrite.data)
        return FMC_ERROR;

    return NO_ERROR;
}

/*-----------------------------------------------------------------------
    Function name   : ProgOptionTest()
    Prototype           : smtUint32 ProgOptionTest(void)
    Return              : error code
    Argument        :
    Comments        : Write operation
            Option program test

            1. Smart option write
            2. HW protection write
            3. protection test
-----------------------------------------------------------------------*/
smtUint32 ProgOptionTest(void)
{
    volatile smtUint32 readData_p, readData;
    FM_STRUCT flashWrite;

    /////////////////////
    //  H/W PROTECTION 

    OUTERRCODE(FMC_OPT_ERR+1);
    // Smart option bit
    flashWrite.addr = SMART_OPT;
    flashWrite.data = 0xfffe;       // sector 0
    flashWrite.length = 4;
    flashWrite.mode = FM_PROGRAM_OPTION;
    FlashMemWrite(flashWrite);

    // Check FSO(RD only) register
    readData = SMT_READ(FSO) & 0x0ffff;
    if(readData != 0x0000fffe)
        return FMC_ERROR;
    
    OUTERRCODE(FMC_OPT_ERR+2);
    // HW protection bit
    flashWrite.addr = PROTECTION_OPT;
    //flashWrite.data = 0<< SHIFT_DN_FROM_MASK(FM_PROTECT_HW);    // HW protection
    flashWrite.data = ~FM_PROTECT_HW;
    flashWrite.mode = FM_PROGRAM_OPTION;
    FlashMemWrite(flashWrite);

    // Check FPO(RD only) register
    readData = SMT_READ(FPO) & FM_PROTECT_HW;
    if(readData != 0x0)             // because low active
        return FMC_ERROR;
    
    OUTERRCODE(FMC_OPT_ERR+3);
    // Information block Read test through AHB
    // Information block enable
    SMT_WRITE(FMUCON, 0x400);

    readData = FlashMemRead(0x00E<<2) & 0x0ffff;
    if(readData != 0x0000fffe)
        return FMC_ERROR;

    OUTERRCODE(FMC_OPT_ERR+4);
    readData = FlashMemRead(0x00F<<2) & FM_PROTECT_HW;
    if(readData != 0x0) // because low active
        return FMC_ERROR;
    
    // Information block disable
    SMT_WRITE(FMUCON, 0);
    OUTERRCODE(FMC_OPT_ERR+5);

    // 1. WR & RD
    // Page 0  is non-writable
    OUTERRCODE(FMC_OPT_ERR+6);
    flashWrite.addr = 0x0014;
    flashWrite.data = 0x11112222;
    flashWrite.mode = FM_PROGRAM;
    
    readData_p = FlashMemRead(flashWrite.addr);
    FlashMemWrite(flashWrite);

    OUTERRCODE(FMC_OPT_ERR+7);
    readData = FlashMemRead(flashWrite.addr);
    if(readData == flashWrite.data || readData != readData_p)
        return FMC_ERROR;

    // Page 28h is writable
    OUTERRCODE(FMC_OPT_ERR+8);
    flashWrite.addr = 0x0a020;
    flashWrite.data = 0x000ff00f;
    flashWrite.mode = FM_PROGRAM;
    
    readData_p = FlashMemRead(flashWrite.addr);
    FlashMemWrite(flashWrite);

    OUTERRCODE(FMC_OPT_ERR+9);
    readData = FlashMemRead(flashWrite.addr);
    if(readData != flashWrite.data || readData == readData_p)
        return FMC_ERROR;

    // 2. Sector erase & check
    // Erase page 0 - Sector 0 is HW protect status.
    OUTERRCODE(FMC_OPT_ERR+0xA);
    flashWrite.addr = 0x0;
    flashWrite.mode = FM_ERASE_SECTOR;
    
    readData_p = FlashMemRead(flashWrite.addr);
    FlashMemWrite(flashWrite);

    OUTERRCODE(FMC_OPT_ERR+0xB);
    readData = FlashMemRead(flashWrite.addr );
    if(readData == FLASH_INIT_VALUE || readData != readData_p)
        return FMC_ERROR;   // HW protection fail
        
    // Erase page 28h   - Sector 28h is R/W possible status.
    OUTERRCODE(FMC_OPT_ERR+0xC);
    flashWrite.addr = 0x0a000;
    flashWrite.mode = FM_ERASE_SECTOR;

    readData_p = FlashMemRead(flashWrite.addr);
    FlashMemWrite(flashWrite);

    OUTERRCODE(FMC_OPT_ERR+0xD);
    readData = FlashMemRead(flashWrite.addr);
    if(readData != FLASH_INIT_VALUE || readData == readData_p)
        return FMC_ERROR;   // HW protection fail

    /*
    // 3. Chip erase & check
    flashWrite.mode = FM_ERASE_CHIP;
    FlashMemWrite(flashWrite);
    readData = FlashMemRead(flashWrite.addr);
    if(readData != FLASH_INIT_VALUE)
        return FMC_ERROR;
    */
	
    return NO_ERROR;
}

/*-----------------------------------------------------------------------
    Function name   : EraseSectorTest()
    Prototype           : smtUint32 EraseSectorTest(void)
    Return              : error code
    Argument        :
    Comments        : Erase operation
            Sector erase test

            1. Flash whole size write
            2. Sector erase
-----------------------------------------------------------------------*/
smtUint32 EraseSectorTest(void)
{
    volatile smtUint32 readData;
    smtUint32 size;
    FM_STRUCT flashWrite;

    flashWrite.addr = 0x0;
    flashWrite.data = FIXED_VALUE;
    flashWrite.length = 4;
    flashWrite.mode = FM_PROGRAM;

    // Flash whole size write
    //for(size=0; size<FLASH_MAX_SIZE/4; size++)
    for(size=0; size<(FLASH_MAX_SIZE/4)/256; size++)
    {
        FlashMemWrite(flashWrite);
        flashWrite.addr += 4;
    }

    // Sector erase
    flashWrite.addr = 0x0;    // addr - 512
    flashWrite.mode = FM_ERASE_SECTOR;
    FlashMemWrite(flashWrite);

    readData = FlashMemRead(flashWrite.addr);
    if(readData != FLASH_INIT_VALUE)
        return FMC_ERROR;

    return NO_ERROR;
}

/*-----------------------------------------------------------------------
    Function name   : EraseChipTest()
    Prototype           : smtUint32 EraseChipTest(void)
    Return              : error code
    Argument        :
    Comments        : Erase operation
            Chip erase test
-----------------------------------------------------------------------*/
smtUint32 EraseChipTest(void)
{
    volatile smtUint32 readData;
    FM_STRUCT flashWrite;

    // Chip erase
    flashWrite.mode = FM_ERASE_CHIP;
    FlashMemWrite(flashWrite);

    flashWrite.addr = 0x0;
    readData = FlashMemRead(flashWrite.addr);
    if(readData != FLASH_INIT_VALUE)
        return FMC_ERROR;

    return NO_ERROR;
}

/*-----------------------------------------------------------------------
    Function name   : FlashMemWrite()
    Prototype           : void FlashMemWrite(FM_STRUCT flashWrite)
    Return              : error code
    Argument        :
    Comments        : Write operation
            Erase   - Sector or Chip erase
            Program - Normal or Option program
-----------------------------------------------------------------------*/
void FlashMemWrite(FM_STRUCT flashWrite)
{
    FM_STRUCT flash;

    flash.addr = flashWrite.addr+FLASH_STARTADDR;
    flash.data = flashWrite.data;
    flash.length = flashWrite.length;
    flash.mode = flashWrite.mode;

    if(flash.mode > FM_ERASE_CHIP)      // Except for flash memory chip erase operation.
        SMT_WRITE(FMADDR, flash.addr);

    //if(flash.mode == FM_PROGRAM || flash.mode == FM_PROGRAM_OPTION)     // Only when program mode
    if(flash.mode > FM_ERASE_SECTOR)        // When normal program or option program is
        SMT_WRITE(FMDATA, flash.data);

    SMT_WRITE(FMKEY, FM_KEYVALUE);

    // Mode, Operation, OSCEN setting
    //SMT_WRITE(FMUCON, UOSCEN_EN);    // OSCEN set. Don't care 2006/03/10
    SMT_WRITE(FMUCON, SMT_READ(FMUCON) | USTRSTPT | flash.mode );

    //while(SMT_READ(FMUCON)&0xff);   // Wait until write operation is completed.
    while(SMT_READ(FMKEY) != 0);        // When program operation complete is, FMKEY/FMUCON is cleared
}

/*-----------------------------------------------------------------------
    Function name   : FlashMemRead()
    Prototype           : smtUint32 FlashMemRead(smtUint32 addr)
    Return              : read data
    Argument        :
    Comments        : 4B read operation
-----------------------------------------------------------------------*/
smtUint32 FlashMemRead(smtUint32 addr)
{
    smtUint32 readData;

    readData = *((smtUint32 *)(addr+FLASH_STARTADDR));
    return readData;
}

/*-----------------------------------------------------------------------
    Function name   : OutErrCode()
    Prototype           : void OutErrCode(smtUint32 errCode)
    Return              : 
    Argument        : error code
    Comments        : 
            Toggle the value to External sram pin out
-----------------------------------------------------------------------*/
static void OutErrCode(smtUint32 errCode)
{
    smtUint16  *errCodep;

    errCodep = (smtUint16 *) EXT_SRAM_ADDR;
    *errCodep = errCode;
}
