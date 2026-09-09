/*-------------------------------------------------------------------
File name : Lib.c

middle level routines
----------------------------------------------------------------------*/
/*/////////////////////////////////////////////////////////
        INCLUDE
///////////////////////////////////////////////////////// */
#include <stdio.h>
#include <string.h>
#include <stdarg.h>

#include "sysinc.h"
#include "structDef.h"
#include "Commonmacro.h"

#include "lib.h"

#define GLOBAL_DEFINE
#include "global.h"


/*/////////////////////////////////////////////////////////
        FUNCTION
///////////////////////////////////////////////////////// */

/*-----------------------------------------------------------------------
    Function name   : smtDelay100us()
    Prototype           : smtBoolean smtDelay100us(smtInt32 time);
    Return              : smtBoolean
    Argument            : time ->  time to delay
    Comments        : function to delay.
                      time > 0 : the number of loop time
-----------------------------------------------------------------------*/
smtBoolean smtDelay100us(smtInt32 time)
{
#if 0
    //sysDelay100us(time);  //sysArmLib.c

#else
	{
		smtUint32 i;
		for(i=0; i<(time*100*4); i++)
		{
			volatile smtInt32 j;	// this volatile is effective when compiler cutting over at optimization.
			j++;
			j--;
		}
	}
#endif

    return SMT_SUCCESS;
}

/*---------------------------------------------------------
        MEMORY
--------------------------------------------------------- */
/* FMC */
/*-----------------------------------------------------------------------
    Function name   : smtFMCSetMode()
    Prototype           : smtBoolean smtFMCSetMode(FMC_STRUCT fmc);
    Return              : smtBoolean
    Argument            :
    Comments        : 
                Set System wait & cpu hold & operation mode
-----------------------------------------------------------------------*/
smtBoolean smtFMCSetMode(FMC_STRUCT fmc)
{
    SMT_WRITE(FMUCON,
        fmc.waitReg<<SHIFT_DN_FROM_MASK(WAIT_REG) |
        0<<SHIFT_DN_FROM_MASK(UCPUH_EN) |   // CPU hold disable
        fmc.mode);

    return SMT_SUCCESS;
}

/*-----------------------------------------------------------------------
    Function name   : smtFMWrite()
    Prototype           : smtBoolean smtFMWrite(FM_STRUCT flashWrite);
    Return              : error code
    Argument        :
    Comments        : Write operation
            Erase   - Sector or Chip erase
            Program - Normal or Option program
-----------------------------------------------------------------------*/
smtBoolean smtFMWrite(FM_STRUCT flashWrite)
{
    FM_STRUCT flash;

    flash.addr = flashWrite.addr+FLASH_STARTADDR;
    flash.data = flashWrite.data;
    flash.length = flashWrite.length;
    flash.mode = flashWrite.mode;

    if(flash.mode > FM_ERASE_CHIP)      // Except for flash memory chip erase operation.
        SMT_WRITE(FMADDR, flash.addr);

    if(flash.mode > FM_ERASE_SECTOR)        // When normal program or option program is
        SMT_WRITE(FMDATA, flash.data);

    SMT_WRITE(FMKEY, FM_KEYVALUE);

    //SMT_WRITE(FMUCON, UOSCEN_EN);    // OSCEN set. Don't care 2006/03/10
    SMT_WRITE(FMUCON, SMT_READ(FMUCON) | USTRSTPT | flash.mode );

    while(SMT_READ(FMKEY) != 0);        // When program operation complete is, FMKEY/FMUCON is cleared

    return SMT_SUCCESS;
}

/*-----------------------------------------------------------------------
    Function name   : smtFMRead()
    Prototype           : smtUint32 smtFMRead(smtUint32 addr)
    Return              : read data
    Argument        :
    Comments        : 4B read operation
-----------------------------------------------------------------------*/
smtUint32 smtFMRead(smtUint32 addr)
{
    smtUint32 readData;
    readData = *((smtUint32 *)(addr+FLASH_STARTADDR));

    return readData;
}

/*-----------------------------------------------------------------------
    Function name   : smt2FMProgramNormal()
    Prototype           : smtBoolean smt2FMProgramNormal(void)
    Return              : error code
    Argument        :
    Comments        : Write operation
            Normal program
-----------------------------------------------------------------------*/
smtBoolean smt2FMProgramNormal(smtUint32 addr, smtUint32 *data, smtUint32 length)
{
    smtUint32 size;
    FM_STRUCT flashWrite;

    flashWrite.addr = addr;
    flashWrite.length = length;
    flashWrite.mode = FM_PROGRAM;

    for(size=0; size<length/4; size++)
    {
        flashWrite.data = *(data+size);     // Flash memory 4Byte(Word) access
        smtFMWrite(flashWrite);
        flashWrite.addr += 4;
    }

    return SMT_SUCCESS;
}

/*-----------------------------------------------------------------------
    Function name   : smt2FMProgramOption()
    Prototype           : smtBoolean smt2FMProgramOption(FM_OPTION_TYPE optionType, smtUint32 sector)
    Return              : error code
    Argument        :
    Comments        : Write operation
            Option operation (Smart or HW protect or RD protect
-----------------------------------------------------------------------*/
smtBoolean smt2FMProgramOption(FM_OPTION_TYPE optionType, smtUint32 sector)
{
    FM_STRUCT flashWrite;

    switch(optionType)
    {
        case OPTION_SMART:
            flashWrite.addr = SMART_OPT;
            flashWrite.data = sector;   // sector setting
            flashWrite.length = 4;
            flashWrite.mode = FM_PROGRAM_OPTION;
            smtFMWrite(flashWrite);
            break;
        case OPTION_PROTECT_HW:
            flashWrite.addr = PROTECTION_OPT;
            flashWrite.data = ~FM_PROTECT_HW;
            flashWrite.mode = FM_PROGRAM_OPTION;
            smtFMWrite(flashWrite);
            break;
        case OPTION_PROTECT_RD :
            flashWrite.addr = PROTECTION_OPT;
            flashWrite.data = ~FM_PROTECT_RD;
            flashWrite.mode = FM_PROGRAM_OPTION;
            smtFMWrite(flashWrite);
            break;

        default :
            return SMT_ERROR;
    }

    return SMT_SUCCESS;
}

/*-----------------------------------------------------------------------
    Function name   : smt2FMErase()
    Prototype           : smtBoolean smt2FMErase(FM_OPERATION_MODE eraseType, smtUint32 sector)
    Return              : error code
    Argument        :
    Comments        : Erase operation
            Flash memory erase (Sector or Chip)
-----------------------------------------------------------------------*/
smtBoolean smt2FMErase(FM_OPERATION_MODE eraseType, smtUint32 sector)
{
    smtUint32 errCode;
    FM_STRUCT flashWrite;

    if(eraseType == FM_ERASE_SECTOR)    // Sector erase
        flashWrite.addr = sector;

    if(eraseType > FM_ERASE_SECTOR)     // When FM_PROGRAM or FM_PROGRAM_OPTION is
        return SMT_ERROR;

    flashWrite.mode = eraseType;
    errCode = smtFMWrite(flashWrite);

    if(errCode != SMT_SUCCESS)
        return SMT_ERROR;

    return SMT_SUCCESS;
}

/* ESMC */
/*-----------------------------------------------------------------------
    Function name   : smtMemoryWrite()
    Prototype           : smtBoolean smtMemoryWrite(smtUint32 addr, smtUint32 *data, smtUint32 length)
    Return              : error code
    Argument        :
    Comments        : Write operation
            Write data to memory as length
-----------------------------------------------------------------------*/
smtBoolean smtMemoryWrite(smtUint32 addr, smtUint32 *data, smtUint32 length)
{
    smtUint32 size;
    smtUint32 memAddr;

    memAddr = addr;

    for(size=0; size<length/4; size++)
    {
        SMT_WRITE((*(smtUint32 *)memAddr), *(data+size))
        memAddr += 4;
    }

    return SMT_SUCCESS;
}

/*-----------------------------------------------------------------------
    Function name   : smtMemoryRead()
    Prototype           : smtBoolean smtMemoryRead(void)
    Return              : error code
    Argument        :
    Comments        : Write operation
            Normal program
-----------------------------------------------------------------------*/
smtBoolean smtMemoryRead(smtUint32 addr, smtUint32 *data, smtUint32 length)
{
    smtUint32 size;
    smtUint32 memAddr;

    memAddr = addr;

    for(size=0; size<length/4; size++)
    {
        *(data+size) = SMT_READ((*(smtUint32 *)memAddr));
        memAddr += 4;
    }

    return SMT_SUCCESS;
}


/*---------------------------------------------------------
        UART
--------------------------------------------------------- */
/*-----------------------------------------------------------------------
    Function name   : smtUartSetBaudRate()
    Prototype           : smtBoolean smtUartSetBaudRate(smtUint32 baudRate)
    Return              : error code
    Argument        :
    Comments        :
            Baud-rate setting
                baudDiv = 8M/(16*baudrate)
                iBRD = Integer(baudDiv)
                fBRD = baudDiv - iBRD
                m = integer(fBRD*2n+0.5)
-----------------------------------------------------------------------*/
smtBoolean smtUartSetBaudRate(smtUint32 baudRate)
{
    smtUint32 iBRD, m;
    smtFloat baudDiv, fBRD;
    
    baudDiv = (8*1000000)/(16*baudRate);
    iBRD = (smtUint32)baudDiv;
    fBRD = baudDiv - iBRD;
    m = (smtUint32)(fBRD*64+0.5);   // m = integer(BFDF*2n + 0.5) - n is width of UARTFBRD

    SMT_WRITE(UARTIBRD, iBRD);
    SMT_WRITE(UARTFBRD, m);
    //baudDiv = iBRD + m/64;
    //realBaudRate = (8*1000000)/(16*baudDiv);

    return SMT_SUCCESS;
}

/*-----------------------------------------------------------------------
    Function name   : smtUartSetMode()
    Prototype           : smtBoolean smtUartSetMode(UART_STRUCT *uart, UART_MODE mode)
    Return              : error code
    Argument        :
    Comments        :
            Line control & interrupt level & interrupt flag clear & interrup mask setting
            This function set or get value of register (UARTLCR_H, UARTIFLS, UARTICR, UARTIMSC)

            UARTLCR_H
            UARTIFLS

            UARTICR
            UARTIMSC
-----------------------------------------------------------------------*/
smtBoolean smtUartSetMode(UART_STRUCT *uart, UART_MODE mode)
{
    smtUint32 regValue;

    switch(mode)
    {
        case SET_UARTLCR :
            /* Set UARTLCR_H (line control register) */
            SMT_WRITE(UARTLCR_H,
                uart->lineCtrl.sendBreak<<SHIFT_DN_FROM_MASK(SEND_BREAK) |
                uart->lineCtrl.parityEn<<SHIFT_DN_FROM_MASK(PARITY_EN) |
                uart->lineCtrl.paritySel<<SHIFT_DN_FROM_MASK(EVEN_PARITY_SEL) |
                uart->lineCtrl.stopSel<<SHIFT_DN_FROM_MASK(T_STOP_BIT_SEL) |
                uart->lineCtrl.fifoEn<<SHIFT_DN_FROM_MASK(EN_FIFO) |
                uart->lineCtrl.wordLengh<<SHIFT_DN_FROM_MASK(WORD_LENGTH) |
                uart->lineCtrl.stickParitySel<<SHIFT_DN_FROM_MASK(STICK_PAR_SEL) );
            break;
        case GET_UARTLCR :
            /* Get UARTLCR_H (line control register) */
            {
                regValue = SMT_READ(UARTLCR_H);
                uart->lineCtrl.sendBreak = (smtUint8)((regValue & SEND_BREAK)>>SHIFT_DN_FROM_MASK(SEND_BREAK));
                uart->lineCtrl.parityEn = (smtUint8)((regValue & PARITY_EN)>>SHIFT_DN_FROM_MASK(PARITY_EN));
                uart->lineCtrl.paritySel = (smtUint8)((regValue & EVEN_PARITY_SEL)>>SHIFT_DN_FROM_MASK(EVEN_PARITY_SEL));
                uart->lineCtrl.stopSel = (smtUint8)((regValue & T_STOP_BIT_SEL)>>SHIFT_DN_FROM_MASK(T_STOP_BIT_SEL));
                uart->lineCtrl.fifoEn = (smtUint8)((regValue & EN_FIFO)>>SHIFT_DN_FROM_MASK(EN_FIFO));
                uart->lineCtrl.wordLengh = ((smtUint8)(regValue & WORD_LENGTH)>>SHIFT_DN_FROM_MASK(WORD_LENGTH));
                uart->lineCtrl.stickParitySel = (smtUint8)((regValue & STICK_PAR_SEL)>>SHIFT_DN_FROM_MASK(STICK_PAR_SEL));
            }
            break;
#if 0
        case SET_UARTCR :
            /* Set UART control register */
            break;
        case GET_UARTCR :
            /* Get UART control register */
            break;
#endif

        case SET_UARTIFLS :
            /* Set UARTIFLS (interrupt FIFO level select register) */
            UART_INT_FIFO_LEVEL_SET(UARTIFLS, uart->rxIntLevel, RX_INTERRUPT_LEVEL);
            UART_INT_FIFO_LEVEL_SET(UARTIFLS, uart->rxIntLevel, TX_INTERRUPT_LEVEL);

            break;
        case GET_UARTIFLS :
            /* Get UARTIFLS (interrupt FIFO level select register) */
            UART_INT_FIFO_LEVEL_GET(UARTIFLS, uart->rxIntLevel, RX_INTERRUPT_LEVEL);
            UART_INT_FIFO_LEVEL_GET(UARTIFLS, uart->txIntLevel, TX_INTERRUPT_LEVEL);
        break;

        case SET_UARTICR :
            /* Set UARTCR (interrupt clear register) */
            UART_INT_CLEAR(UARTICR, uart->intClear);
            break;

        case SET_UARTIMSC :
            /* Set UARTIMSC (interrupt mask set/clear register) */
            UART_INT_MASK_SET(UARTIMSC, uart->intMask);
            break;
        case CLR_UARTIMSC :
            /* Clear UARTIMSC (interrupt mask set/clear register) */
            UART_INT_MASK_CLR(UARTIMSC, uart->intMask);
            break;
        case GET_UARTIMSC :
            /* Get UARTIMSC (interrupt mask set/clear register) */
            UART_INT_MASK_GET(UARTIMSC, uart->intMask);
            break;

        default :
            return SMT_ERROR;
    }

    return SMT_SUCCESS;
}

/*-----------------------------------------------------------------------
    Function name   : smtUartCharWrite()
    Prototype           : smtBoolean smtUartCharWrite(smtUint8 data)
    Return              : error code
    Argument        : data
    Comments        :
            Transmit character data
-----------------------------------------------------------------------*/
smtBoolean smtUartCharWrite(smtInt8 data)
{
    if(data =='\n')
    {
        while(!(UARTFR&TXFIFO_EMPTY));  // Wait until Tx FIFO empty

#if 0
        smtDelay100us(1);
#endif
        SMT_WRITE(UARTDR, '\r');
    }

    while(!(UARTFR&TXFIFO_EMPTY));  // Wait until Tx FIFO empty

#if 0
    smtDelay100us(1);
#endif
    SMT_WRITE(UARTDR, data);

    return SMT_SUCCESS;
}

/*-----------------------------------------------------------------------
    Function name   : smtUartCharRead()
    Prototype           : smtUint8 smtUartCharRead(smtUint32 waitTime)
    Return              : Received data
    Argument        :   waitTime
    Comments        :
            Receive character data
-----------------------------------------------------------------------*/
smtUint8 smtUartCharRead(smtUint32 waitTime)
{
    int cnt = 0;

    while(UARTFR&RXFIFO_EMPTY)       // Wait until Rx FIFO not empty.
    {
        if(waitTime == 0 /*WAIT_FOREVER*/)
            continue;

        if(cnt++ < waitTime)
            smtDelay100us(1);
        else
            return SMT_ERROR;
    }

    return (smtUint8)SMT_READ(UARTDR);
}

/*-----------------------------------------------------------------------
    Function name   : smtUartStrWrite()
    Prototype           : smtBoolean smtUartStrWrite(smtUint8 *pData)
    Return              : error code
    Argument        : transmit data
    Comments        :
            Transmit the data as data count
-----------------------------------------------------------------------*/
smtBoolean smtUartStrWrite(smtInt8 *pData)
{
    while(*pData)
        smtUartCharWrite(*pData++);
    return SMT_SUCCESS;
}
/*-----------------------------------------------------------------------
    Function name   : smtUartStrRead()
    Prototype           : smtBoolean smtUartStrRead(smtUint8 *pData, smtUint8 dataCnt)
    Return              : error code
    Argument        : Received data, receive data count
    Comments        :
            Receive the data as data count
-----------------------------------------------------------------------*/
smtBoolean smtUartStrRead(smtUint8 *pData, smtUint8 dataCnt)
{
    while(dataCnt--)
        *pData++ = smtUartCharRead(1);
    return SMT_SUCCESS;
}

/*-----------------------------------------------------------------------
    Function name   : smtUartPrint()
    Prototype       : void smtUartPrint(char *fmt, ...);
    Return          : void
    Argument        : fmt  -> format operator
    Comments        : print out though console
-----------------------------------------------------------------------*/
smtBoolean smtUartPrint(int dispLvl, char *fmt, ...)
{
    va_list ap;
    smtInt8 string[255]; 

    if(dispLvl > 10)
    {
        va_start(ap, fmt);
        vsprintf(string, fmt, ap);
        smtUartStrWrite(string);
        va_end(ap);
    }
    return SMT_SUCCESS;
}


/*---------------------------------------------------------
        I2C
--------------------------------------------------------- */
/*-----------------------------------------------------------------------
    Function name   : smtI2CSetMode()
    Prototype           : void smtI2CSetMode(I2C_STRUCT i2c)
    Return              : 
    Argument        :
    Comments        : 
            I2C mode set    - I2C communcation speed and slave address
-----------------------------------------------------------------------*/
void smtI2CSetMode(I2C_STRUCT i2c)
{
    if(i2c.channel == I2C_CH0)
    {
        SMT_WRITE(ICCR0_0,
            i2c.txClkSel<<SHIFT_DN_FROM_MASK(TX_CLK_SEL) |
            i2c.txClk<<SHIFT_DN_FROM_MASK(TX_CLK_VALUE) );
        SMT_WRITE(ICCR0_1, i2c.highPeriod);     // High period cycle
        SMT_WRITE(IAR0, i2c.slaveAddr);         // Slave address

        // I2C interrupt enable & TxRx enable is setted in the I2CWrite()/I2CRead()
    }
    else
    {
        SMT_WRITE(ICCR1_0,
            i2c.txClkSel<<SHIFT_DN_FROM_MASK(TX_CLK_SEL) |
            i2c.txClk<<SHIFT_DN_FROM_MASK(TX_CLK_VALUE) );
        SMT_WRITE(ICCR1_1, i2c.highPeriod);     // High period cycle
        SMT_WRITE(IAR1, i2c.slaveAddr);         // Slave address

        // I2C interrupt enable & TxRx enable is setted in the I2CWrite()/I2CRead()
    }
}

/*-----------------------------------------------------------------------
    Function name   : smt2I2CWrite()
    Prototype           : smtBoolean smt2I2CWrite(smtUint8 slaveAddr, smtUint8 *data, smtUint8 length);
    Return              : smtBoolean
    Argument            :
            slave Addr  -> slave address
            data            -> address + Tx data
            length          -> (address+Tx data) count
    Comments        : 
                write as (length-1) through I2C
-----------------------------------------------------------------------*/
smtBoolean smt2I2CWrite(smtUint8 slaveAddr, smtUint8 *data, smtUint8 length)
{
    smtUint8 idx, *pData;
    I2C_STRUCT i2c;

    pData = data;
    i2c.txClkSel = gI2C.txClkSel;
    i2c.txClk = gI2C.txClk;
    i2c.highPeriod = gI2C.highPeriod;
    i2c.channel = gI2C.channel;
    smtI2CSetMode(i2c);     // I2C comm speed setting

    // 0. Start condition
    interruptWait = 1;
    SMT_WRITE(ICCR0_0, INTERRUPT_EN);           // Interrupt enable
    SMT_WRITE(ICSR0, TXRX_EN | I2C_START);  //Start condition
    while(interruptWait == 1);                          // Wait until I2C interrupt process is completed
    interruptWait = 1;

    // 1. Slave addr transmit
    SMT_WRITE(IDSR0, slaveAddr+0);       // Master Tx mode
    SMT_WRITE(ICCR0_0, INTERRUPT_EN);   // Interrupt Clear
    while(interruptWait == 1);
    interruptWait = 1;

    // 2. Addr transmit
    SMT_WRITE(IDSR0, *pData);               // Master Tx mode
    SMT_WRITE(ICCR0_0, INTERRUPT_EN);   // Interrupt Clear
    while(interruptWait == 1);
    interruptWait = 1;

    // 3. Data transmit
    for(idx=0; idx<length-1; idx++)
    {
        SMT_WRITE(IDSR0, *(pData+idx+1));   // Master Tx mode
        SMT_WRITE(ICCR0_0, INTERRUPT_EN);   // Interrupt Clear
        while(interruptWait == 1);
        interruptWait = 1;
    }

    // 4. Stop condition
    SMT_WRITE(ICSR0, TXRX_EN | (~(signed)I2C_START&I2C_START)); // Tx/Rx enable & Stop condition
    SMT_WRITE(ICCR0_0, INTERRUPT_EN);   // Interrupt Clear

    // Interrupt disable
    SMT_WRITE(ICCR0_0,  SMT_READ(ICCR0_0) | 0<< SHIFT_DN_FROM_MASK(INTERRUPT_EN) );
    // Tx/Rx disable
    SMT_WRITE(ICSR0,  SMT_READ(ICSR0) | 0<<SHIFT_DN_FROM_MASK(TXRX_EN));

    // Master status check (Refer to smtI2CMasterHandler())
    if(masterStatus != (I2C_MASTER_NO_ERROR|I2C_MASTER_START_FLAG
        |I2C_MASTER_WR_ADDR_ACK_FLAG|I2C_MASTER_WR_DATA_ACK_FLAG))
        return SMT_ERROR;

    return SMT_SUCCESS;
}

/*-----------------------------------------------------------------------
    Function name   : smt2I2CRead()
    Prototype           : smtBoolean smt2I2CRead(smtUint8 slaveAddr, smtUint8 *data, smtUint8 length);
    Return              : smtBoolean
    Argument            :
            slave Addr  -> slave address
            data            -> address + Tx data
            length          -> (address+Tx data) count
    Comments        : 
                Read as (length-1) through I2C
-----------------------------------------------------------------------*/
smtBoolean smt2I2CRead(smtUint8 slaveAddr, smtUint8 *data, smtUint8 length)
{
    smtUint8 idx, *pData;
    I2C_STRUCT i2c;

    pData = data;
    i2c.txClkSel = gI2C.txClkSel;
    i2c.txClk = gI2C.txClk;
    i2c.highPeriod = gI2C.highPeriod;
    i2c.channel = gI2C.channel;
    smtI2CSetMode(i2c);     // I2C comm speed setting

    // 0. Start condition
    interruptWait = 1;
    SMT_WRITE(ICCR0_0, INTERRUPT_EN);   // Interrupt enable
    SMT_WRITE(ICSR0, TXRX_EN | I2C_START);
    while(interruptWait == 1);
    interruptWait = 1;

    // 1. Slave addr transmit
    SMT_WRITE(IDSR0, slaveAddr+1);       // Master Rx mode
    SMT_WRITE(ICCR0_0, INTERRUPT_EN);   // Interrupt Clear
    while(interruptWait == 1);
    interruptWait = 1;

    // 2. Addr transmit
    SMT_WRITE(IDSR0, *pData);                   // Master Tx mode
    SMT_WRITE(ICCR0_0, INTERRUPT_EN);   // Interrupt Clear
    while(interruptWait == 1);

    // Further work - Need to continuous data rx coding
    // 3. Data receive
    //SMT_WRITE(ICCR0_0, ACK_EN | INTERRUPT_EN);  // Ack enable & interrupt flag clear [4] = '0'

    // 4. Stop condition
    SMT_WRITE(ICSR0, TXRX_EN | (~(signed)I2C_START&I2C_START)); // Tx/Rx enable & Stop condition
    *pData = SMT_READ(IDSR0);               // Read Data Register
    SMT_WRITE(ICCR0_0, INTERRUPT_EN);   // Interrupt Clear

    // Interrupt disable
    SMT_WRITE(ICCR0_0,  SMT_READ(ICCR0_0) | 0<< SHIFT_DN_FROM_MASK(INTERRUPT_EN) );
    // Tx/Rx disable
    SMT_WRITE(ICSR0, SMT_READ(ICSR0) | 0<<SHIFT_DN_FROM_MASK(TXRX_EN));

    // Master status check (Refer to smtI2CMasterHandler())
    if(masterStatus != (I2C_MASTER_NO_ERROR|I2C_MASTER_START_FLAG
        |I2C_MASTER_RD_ADDR_ACK_FLAG|I2C_MASTER_RD_DATA_NON_ACK_FLAG))
        return SMT_ERROR;

    return SMT_SUCCESS;
}

/*-----------------------------------------------------------------------
    Function name   : smtI2CMasterHandler()
    Prototype           : void smtI2CMasterHandler(void)
    Return              : 
    Argument            :
    Comments        : 
                I2C master isr handler
                The status of the i2c master Tx/Rx processing
-----------------------------------------------------------------------*/
void smtI2CMasterHandler(void)
{
    smtUint32 i2cStatus;

    i2cStatus = (0x1f & SMT_READ(ICSR0)) << 3 ;
    switch (i2cStatus) {
        case 0x28 :
            masterStatus |= I2C_MASTER_WR_DATA_ACK_FLAG;
            masterStatus |= I2C_MASTER_NO_ERROR;
            break;          
        case 0x18:          // address + write trans Ack received
            masterStatus |= I2C_MASTER_WR_ADDR_ACK_FLAG;
            masterStatus |= I2C_MASTER_NO_ERROR;
            break;
        case 0x08 :
            masterStatus |= I2C_MASTER_START_FLAG;
            masterStatus |= I2C_MASTER_NO_ERROR;
            break;
        case 0x10:
            masterStatus |= I2C_MASTER_RESTART_FLAG;
            masterStatus |= I2C_MASTER_NO_ERROR;
            break;
        case 0x58:
            masterStatus |= I2C_MASTER_RD_DATA_NON_ACK_FLAG;
            masterStatus |= I2C_MASTER_NO_ERROR;
            break;
        case 0x50:
            masterStatus |= I2C_MASTER_RD_DATA_ACK_FLAG;
            masterStatus |= I2C_MASTER_NO_ERROR;
            break;
        case 0x40:          // address + Read trans Ack received
            masterStatus |= I2C_MASTER_RD_ADDR_ACK_FLAG;
            masterStatus |= I2C_MASTER_NO_ERROR;
            break;
#if 0
        case 0x48:
            bAdrReNAck=1;
            bError=0;
            break;
        case 0x20:
            bAddrTrNAck=1;                
            bError=0;
            break;
        case 0x30:
            bDataTrNAck=1;
            bError=0;
            break;
#endif
        default:
            masterStatus |= I2C_MASTER_ERROR;
            break;
    }
    interruptWait = 0;
}


// Further Work.
extern volatile smtInt32 readDataM[256];
extern volatile smtInt32 writeDataM[10];
extern volatile smtInt32 count;
extern volatile smtInt32 subAddress;
extern volatile smtBoolean repeatStart;
/*-----------------------------------------------------------------------
    Function name   : smtI2CSlaveHandler()
    Prototype           : void smtI2CSlaveHandler(void)
    Return              : 
    Argument        :
    Comments        : I2C slave ISR function
-----------------------------------------------------------------------*/
void smtI2CSlaveHandler(void)
{
    smtUint32 i2cStatus;

    i2cStatus = (0x1f & SMT_READ(ICSR1)) << 3 ;
    switch (i2cStatus)
    {
        case 0x00:  // bus error
            // error return
            break;

        case 0x80:  // Data byte received after slave address received, ACK transmitted 
        	if (count==1)
        	{
        	subAddress=SMT_READ(IDSR1);				// sub-address
        	}
        	else									
            {
            //readDataM[count]=SMT_READ(IDSR1);		// Data read
            readDataM[subAddress-1]=SMT_READ(IDSR1);		// Data read
            }
            SMT_WRITE(ICCR1_0,INTERRUPT_EN);		// Interrupt Clear
            SMT_WRITE(ICCR1_0,ACK_EN|INTERRUPT_EN);	// ACK bit setting
            subAddress++;
            count++;
            break;

        case 0x88:  // Data byte received after slave address received, not ACK transmitted
    		if (count == 1)
        	{
        	subAddress=SMT_READ(IDSR1);				// sub-address
        	}
        	else									
            {
            //readDataM[count]=SMT_READ(IDSR1);		// Data read
            readDataM[subAddress-1]=SMT_READ(IDSR1);		// Data read
            }
            SMT_WRITE(ICCR1_0,INTERRUPT_EN);		// Interrupt Clear
            SMT_WRITE(ICCR1_0,ACK_EN|INTERRUPT_EN);	// ACK bit setting
            subAddress++;
            count++;
            repeatStart=0;
            break;

        case 0xA0:  // STOP or repeated START condition received in slave mode
        	if (count==2) // repeated START condition detect
			{	
				if (repeatStart == 1)
			    {
			        repeatStart = 0;
				}
				else
				{
					repeatStart = 1;
				}
        	}
        	else
        	{
        	repeatStart = 0;
            }
            SMT_WRITE(ICCR1_0,INTERRUPT_EN);		// Interrupt Clear
            SMT_WRITE(ICCR1_0,ACK_EN|INTERRUPT_EN);	// ACK bit setting
            break;          

        case 0xB8:  // Data byte transmitted in slave mode, ACK received
        	if (repeatStart==1)
        	{
        	SMT_WRITE(IDSR1, readDataM[subAddress-1]);	// Data write
			}
			else
			{
			SMT_WRITE(IDSR1, readDataM[count]);	// Data write
			}
			SMT_WRITE(ICCR1_0,INTERRUPT_EN);		// Interrupt Clear
            SMT_WRITE(ICCR1_0,ACK_EN|INTERRUPT_EN);	// ACK bit setting
            subAddress++;
            count++;
            break;

        case 0xC0:  // Data byte transmitted in slave mode, ACK not received
            if (repeatStart==1)
        	{
        	SMT_WRITE(IDSR1, readDataM[subAddress-1]);	// Data write
			}
			else
			{
			SMT_WRITE(IDSR1, readDataM[count]);	// Data write
			}
			SMT_WRITE(ICCR1_0,INTERRUPT_EN);		// Interrupt Clear
            SMT_WRITE(ICCR1_0,ACK_EN|INTERRUPT_EN);	// ACK bit setting
            subAddress++;
            count++;
            repeatStart=0;
            break;

        case 0xC8:  // Last byte transmitted in slave mode, ACK received
            if (repeatStart==1)
        	{
        	SMT_WRITE(IDSR1, readDataM[subAddress-1]);	// Data write
			}
			else
			{
			SMT_WRITE(IDSR1, readDataM[count]);	// Data write
            }
            repeatStart =0;
            SMT_WRITE(ICCR1_0,INTERRUPT_EN);		// Interrupt Clear
            SMT_WRITE(ICCR1_0,ACK_EN|INTERRUPT_EN);	// ACK bit setting
            
            break;
    }
}


/*---------------------------------------------------------
        TIMER & PWM
--------------------------------------------------------- */
/*-----------------------------------------------------------------------
    Function name   : smtTimerSetMode()
    Prototype           : smtBoolean smtTimerSetMode(TIMER_STRUCT timer, TIMER_SEL timerSel);
    Return              : smtBoolean
    Argument            :
    Comments        : 
                Set timer mode
-----------------------------------------------------------------------*/
smtBoolean smtTimerSetMode(TIMER_STRUCT timer, TIMER_SEL timerSel)
{
    smtUint32 addr;

    addr = TPRE_START + 0x20*timerSel;
    //SMT_WRITE(TPRE0, TIMER0_PRE);
    SMT_WRITE((*(volatile unsigned*)addr), timer.prescale);

    if(!TIMER_CAPTURE)
    {
        addr = TDAT_START + 0x20*timerSel;
        //SMT_WRITE(TDAT0, TIMER0_DAT);
        SMT_WRITE((*(volatile unsigned*)addr), timer.data);
    }

    addr = TCON_START + 0x20*timerSel;
    //SMT_WRITE(TCON0, 0x0<<SHIFT_DN_FROM_MASK(TIMER_OP_MODE_SEL) | 
    SMT_WRITE((*(volatile unsigned*)addr),
        timer.phase<<SHIFT_DN_FROM_MASK(TIMER_PHASE_INVERT_SEL) |
        timer.clk<<SHIFT_DN_FROM_MASK(TIMER_IN_CLK_SEL) |
        timer.opMode<<SHIFT_DN_FROM_MASK(TIMER_OP_MODE_SEL) | 
        timer.timerClear<<SHIFT_DN_FROM_MASK(TIMER_CNT_CLR) );
        //timer.timerEn<<SHIFT_DN_FROM_MASK(TIMER_EN) );

    return SMT_SUCCESS;
}

/*-----------------------------------------------------------------------
    Function name   : smtTimerOperation()
    Prototype           : smtBoolean smtTimerOperation(TIMER_STRUCT timer, TIMER_SEL timerSel);
    Return              : smtBoolean
    Argument            :
    Comments        : 
            Timer start or stop
            You need to GPIO set before use the smtTimerOperatoin().
                ex)
                GPIO_STRUCT gpio;
                gpio.gpioMode = ;
                gpio.gpioNum = ;
                smtGpioSetDir(GPIO_STRUCT gpio);

                smtTimerOperation(timer, timerSel);
-----------------------------------------------------------------------*/
smtBoolean smtTimerOperation(TIMER_STRUCT timer, TIMER_SEL timerSel)
{
    smtUint32 addr;
    if(timer.timerEn == SMT_TRUE)       // When timer enable
        smtTimerSetMode(timer, timerSel);

    addr = TCON_START + 0x20*timerSel;
    SMT_WRITE((*(volatile unsigned*)addr),
        SMT_READ((*(volatile unsigned*)addr)) | timer.timerEn);

    return SMT_SUCCESS;
}


/*---------------------------------------------------------
        WDT
--------------------------------------------------------- */
/*-----------------------------------------------------------------------
    Function name   : smtWDTSetMode()
    Prototype           : smtBoolean smtWDTSetMode(WDT_STRUCT wdt);
    Return              : smtBoolean
    Argument            : WDT struct
    Comments        : 
                Set the WDT mode
-----------------------------------------------------------------------*/
smtBoolean smtWDTSetMode(WDT_STRUCT wdt)
{
    SMT_WRITE(WDTPSR,  wdt.preScale);
    SMT_WRITE(WDTTLDR, wdt.reloadValue);

    SMT_WRITE(WDTCR,
        wdt.div<<SHIFT_DN_FROM_MASK(WDT_DIV_SEL) |
        wdt.clkSel<<SHIFT_DN_FROM_MASK(WDT_CLKSEL) |
        wdt.intEn<<SHIFT_DN_FROM_MASK(WDT_INTEN) |
        wdt.rstEn<<SHIFT_DN_FROM_MASK(WDT_RSTEN) );

    return SMT_SUCCESS;
}

/*-----------------------------------------------------------------------
    Function name   : smtWDTOperation()
    Prototype           : smtBoolean smtWDTOperation(WDT_STRUCT wdt);
    Return              : smtBoolean
    Argument            : WDT struct
    Comments        : 
                WDT start/stop
-----------------------------------------------------------------------*/
smtBoolean smtWDTOperation(WDT_STRUCT wdt)
{
    smtWDTSetMode(wdt);
    SMT_WRITE(WDTCR, SMT_READ(WDTCR) | wdt.wdtEn<<SHIFT_DN_FROM_MASK(WDT_EN) );

    return SMT_SUCCESS;
}


/*---------------------------------------------------------
        GPIO
--------------------------------------------------------- */
/*-----------------------------------------------------------------------
    Function name   : smtGpioSetDir()
    Prototype           : smtBoolean smtGpioSetDir(GPIO_STRUCT gpio);
    Return              : smtBoolean
    Argument            : GPIO type & GPIO mode
    Comments        : 
                Set the GPIO mode
-----------------------------------------------------------------------*/
smtBoolean smtGpioSetDir(GPIO_STRUCT gpio)
{
    // GPIO#, mode
    switch(gpio.gpioNum)
    {
        case GPIO0_TYPE :
            SMT_WRITE(GPIO_CON0, gpio.gpioMode);
            break;
        case GPIO1_TYPE :
            SMT_WRITE(GPIO_CON1, gpio.gpioMode);
            break;
        case GPIO2_TYPE :
            SMT_WRITE(GPIO_CON2, gpio.gpioMode);
            break;
        case GPIO3_TYPE :
            SMT_WRITE(GPIO_CON3, gpio.gpioMode);
            break;
        default :
            return SMT_ERROR;
    }

    return SMT_SUCCESS;
}

/*-----------------------------------------------------------------------
    Function name   : smtGpioGetDir()
    Prototype           : smtUint16 smtGpioGetDir(GPIO_STRUCT gpio);
    Return              : smtUint16 - GPIO mode
    Argument            : GPIO type
    Comments        : 
                Get the GPIO mode
-----------------------------------------------------------------------*/
smtUint16 smtGpioGetDir(GPIO_STRUCT gpio)
{
    smtUint16 gpioDir;

    // GPIO#

    switch(gpio.gpioNum)
    {
        case GPIO0_TYPE :
            gpioDir = SMT_READ(GPIO_CON0);
            break;
        case GPIO1_TYPE :
            gpioDir = SMT_READ(GPIO_CON1);
            break;
        case GPIO2_TYPE :
            gpioDir = SMT_READ(GPIO_CON2);
            break;
        case GPIO3_TYPE :
            gpioDir = SMT_READ(GPIO_CON3);
            break;
        default :
            return SMT_ERROR;
    }
    return gpioDir;
}

/*-----------------------------------------------------------------------
    Function name   : smtGpioSetData()
    Prototype           : smtBoolean smtGpioSetData(GPIO_STRUCT gpio, smtUint8 gpioData);
    Return              : smtBoolean
    Argument            : GPIO type & GPIO data
    Comments        : 
                Set the GPIO data
-----------------------------------------------------------------------*/
smtBoolean smtGpioSetData(GPIO_STRUCT gpio, smtUint8 gpioData)
{
    // GPIO#, mode
    switch(gpio.gpioNum)
    {
        case GPIO0_TYPE :
            SMT_WRITE(GPIO_DAT0, gpioData); //gpio.gpioData);
            break;
        case GPIO1_TYPE :
            SMT_WRITE(GPIO_DAT1, gpioData); //gpio.gpioData);
            break;
        case GPIO2_TYPE :
            SMT_WRITE(GPIO_DAT2, gpioData); //gpio.gpioData);
            break;
        case GPIO3_TYPE :
            SMT_WRITE(GPIO_DAT3, gpioData); //gpio.gpioData);
            break;
        default :
            return SMT_ERROR;
    }

    return SMT_SUCCESS;
}

/*-----------------------------------------------------------------------
    Function name   : smtGpioGetData()
    Prototype           : smtBoolean smtGpioGetData(GPIO_STRUCT gpio);
    Return              : smtUint8
    Argument            : GPIO type & GPIO mode
    Comments        : 
                Get the GPIO data
-----------------------------------------------------------------------*/
smtUint8 smtGpioGetData(GPIO_STRUCT gpio)
{
    smtUint16 gpioData;

    // GPIO#

    switch(gpio.gpioNum)
    {
        case GPIO0_TYPE :
            gpioData = SMT_READ(GPIO_DAT0);
            break;
        case GPIO1_TYPE :
            gpioData = SMT_READ(GPIO_DAT1);
            break;
        case GPIO2_TYPE :
            gpioData = SMT_READ(GPIO_DAT2);
            break;
        case GPIO3_TYPE :
            gpioData = SMT_READ(GPIO_DAT3);
            break;
        default :
            return SMT_ERROR;
    }
    return gpioData;
}


/*---------------------------------------------------------
        VIC (Vectored Interrupt Controller)
--------------------------------------------------------- */


/*---------------------------------------------------------
        ADC
--------------------------------------------------------- */
/*-----------------------------------------------------------------------
    Function name   : smtADCSetMode()
    Prototype           : smtBoolean smtADCSetMode(ADC_STRUCT adc);
    Return              : smtBoolean
    Argument            : ADC mode & channel
    Comments        : 
                Set ADC mode
-----------------------------------------------------------------------*/
smtBoolean smtADCSetMode(ADC_STRUCT adc)
{
    // Standby mode
    if(adc.opMode == ADC_STANDBY)
    {
        SMT_WRITE(ADCCON, 
                SMT_READ(ADCCON) | (ADC_STANDBY<<SHIFT_DN_FROM_MASK(ADC_STBY)) );
        return SMT_SUCCESS;
    }

    /*
        When readstart bit is enable, adcEnabe bit is not valid.
        But, readstart bit is disable, adcEnable bit is valid.
    */
    // Normal operation mode
    SMT_WRITE(ADCCON, 
                adc.adcEnable<<SHIFT_DN_FROM_MASK(ADENABLE) |
                adc.readStart<<SHIFT_DN_FROM_MASK(ADC_READ_START) |
                ADC_NORMAL<<SHIFT_DN_FROM_MASK(ADC_STBY)       |
                adc.adcChanSel<<SHIFT_DN_FROM_MASK(ADC_IN_SEL) );

    return SMT_SUCCESS;
}

/*-----------------------------------------------------------------------
    Function name   : smtADCDataRead()
    Prototype           : smtUint16 smtADCDataRead(void);
    Return              : smtUint16 - ADC data
    Argument            :
    Comments        : 
                Read ADC data
-----------------------------------------------------------------------*/
smtUint16 smtADCDataRead(void)
{
    smtUint16 adcData;

    // When ADC standby mode is.
    if(SMT_READ(ADCCON)&ADC_STBY == SMT_TRUE)
        return SMT_ERROR;       // A/D data is garbage

    // Wait until ADC operation is finished.
    // Need to ISR routine concern
    while((ADC_FLAG & SMT_READ(ADCCON)) != 1);

    adcData = SMT_READ(ADCDAT);
    return adcData;
}


/*---------------------------------------------------------
        POWER MANAGEMENT
--------------------------------------------------------- */
/*-----------------------------------------------------------------------
    Function name   : smtPower()
    Prototype           : smtUint16 smtPower(POWER_MODE pwrMode);
    Return              : smtUint16 - ADC data
    Argument            :
    Comments        : 
                Set power mode
-----------------------------------------------------------------------*/
smtBoolean smtPower(POWER_MODE pwrMode)
{
    switch(pwrMode)
    {
        case PWR_NORMAL :
            SMT_WRITE(SYSCON,
                PWR_NORMAL<<SHIFT_DN_FROM_MASK(STOP_CTL) |
                gPwr.sclkDiv<<SHIFT_DN_FROM_MASK(SYS_CLK_DIV) |
                gPwr.uclkDiv<<SHIFT_DN_FROM_MASK(UART_CLK_DIV) |
                gPwr.gie<<SHIFT_DN_FROM_MASK(SYS_GIE_EN) |
                gPwr.uartIntSel<<SHIFT_DN_FROM_MASK(UART_INT_SEL) |
                gPwr.aclkDiv<<SHIFT_DN_FROM_MASK(ADC_CLK_DIV) );
            break;

        case PWR_DOWN :     // Enable EINT, GIE enable, power-down mode start
            {
                //SMT_WRITE(GPIO_CON0, GPIO_EINTSET);
                GPIO_STRUCT gpio;
                gpio.gpioNum = GPIO0_TYPE;
                gpio.gpioMode = GPIO0_EINT;
                smtGpioSetDir(gpio);
            }

            if(SMT_READ(INTMSK)&0xf00f == 0)    // EINT0~7 interrupt mask check
            {
                //EnableIRQ(IRQ_EINT0);
                SMT_WRITE(INTMSK, 0xf00f);          // EINT0~7 interrupt mask enable
            }
            SMT_WRITE(SYSCON, SYS_GIE_EN | STOP_CTL);    // Power-down mode

#if __GCC_ARM__

           __asm__
           (
           	 "nop\n\t" \
           	 "nop\n\t" \
           	 "nop\n\t" \
           	 "nop\n\t" \
           );
#else
            __asm
           {
           	 nop;
           	 nop;
           	 nop;
           	 nop;
           }
#endif

            break;

        case PWR_SLOW :
            SMT_WRITE(SYSCON, 
                SMT_READ(SYSCON) | gPwr.sclkDiv<< SHIFT_DN_FROM_MASK(SYS_CLK_DIV) );
            break;


        default :
            return SMT_ERROR;
    }
    return SMT_SUCCESS;
}
