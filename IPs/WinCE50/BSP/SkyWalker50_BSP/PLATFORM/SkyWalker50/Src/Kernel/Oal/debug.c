//
// Copyright (c) Microsoft Corporation.  All rights reserved.
//
//
// Use of this source code is subject to the terms of the Microsoft end-user
// license agreement (EULA) under which you licensed this SOFTWARE PRODUCT.
// If you did not accept the terms of the EULA, you are not authorized to use
// this source code. For a copy of the EULA, please see the LICENSE.RTF on your
// install media.
//
//------------------------------------------------------------------------------
//
//  File:  debug.c            
//
//  This module is provides the interface to the serial port.
//
#include <bsp.h>
#include <nkintr.h>
 
//------------------------------------------------------------------------------
// Defines 
//shkim-0929 : insert macro for UART
 /*
macro_SET/GET(x,y)
	SET	-> Write data to register
	GET	-> Read data from register
	x	-> register
	y	-> data (bit mask)
macro_SET/GET(x,y,z)
	z	-> shift count
*/

#define UART_RX_ENABLE(x, y)    	{OUTREG32(x, (INREG32(x)&~(signed)y) | y);}
#define UART_TX_ENABLE(x,y)     	{OUTREG32(x, (INREG32(x)&~(signed)y) | y);}
#define UART_LOOPBACK_ENABLE(x,y)	{OUTREG32(x, (INREG32(x)&~(signed)y) | y);}
#define UART_ENABLE(x,y)			{OUTREG32(x, (INREG32(x)&~(signed)y) | y);}

#define UART_RX_DISABLE(x,y)    	{OUTREG32(x, (INREG32(x)&~(signed)y));}
#define UART_TX_DISABLE(x,y)    	{OUTREG32(x, (INREG32(x)&~(signed)y));}
#define UART_LOOPBACK_DISABLE(x,y)	{OUTREG32(x, (INREG32(x)&~(signed)y));}
#define UART_DIASBLE(x,y)			{OUTREG32(x, (INREG32(x)&~(signed)y));}

#define UART_INT_FIFO_LEVEL_SET(x, y, z)		\
	{OUTREG32(x, 								\
		INREG32(x)& ~(y<<SHIFT_DN_FROM_MASK(z))\
		| y<<SHIFT_DN_FROM_MASK(z));}

#define UART_INT_FIFO_LEVEL_GET(x, y, z)		\
	{y = ((UINT8)(INREG32(x) & z))>>z;}


#define UART_INT_CLEAR(x,y)		{OUTREG32(x, y);}
#define UART_INT_MASK_CLR(x,y)	{OUTREG32(x, INREG32(x)&~y);}
#define UART_INT_MASK_SET(x,y)	{OUTREG32(x, (INREG32(x)&~y) |y);}
#define UART_INT_MASK_GET(x,y)  {y = (UINT16)(INREG32(x));}

#define SMT_SUCCESS 0
#define SMT_ERROR   1
//------------------------------------------------------------------------------
// Externs
 
//------------------------------------------------------------------------------
// Global Variables 
 
//------------------------------------------------------------------------------
// Local Variables 
static SMT926A_UART_REG *g_pUARTReg;

//------------------------------------------------------------------------------
// Local Functions 
UINT8 smtUartSetBaudRate(UINT32 baudRate);
UINT8 smtUartSetMode(UART_STRUCT *uart, UART_MODE mode);
UINT8 smtDelay100us(UINT32 time);

//------------------------------------------------------------------------------
//
//  Function: OEMInitDebugSerial
//
//  Initializes the debug serial port
//
VOID OEMInitDebugSerial() 
{
    UART_STRUCT uartInit;
    UINT8 crash;
    
#if 0 //shkim-0929 : set clock, TX/RX int further work
    OUTREG32(SYSCON, 
        0<<SHIFT_DN_FROM_MASK(UART_CLK_DIV) |   // Uart clock divider : HCLK
        0<<SHIFT_DN_FROM_MASK(UART_INT_SEL) );  // Uart interrupt Tx/Rx
#endif        
    /*
    smtUartSetMode();

    1. Baud-rate setting
    2. Line control setting
    3. Control setting
    4. Rx/Tx interrupt level setting
    5. Rx FIFO flush
    6. Interrupt status flag clear
    7. Interrupt mask setting

    UARTIBRD/UARTFBRD

    UARTLCR_H
    UARTCR TxEn/RxEn/UartEn
    UARTIFLS

    UARTICR
    UARTIMSC
    */

    smtUartSetBaudRate(UART_BAUD_9600);

    uartInit.lineCtrl.fifoEn = FIFO_ENABLE;
    uartInit.lineCtrl.parityEn = PARITY_DISABLE;
    uartInit.lineCtrl.paritySel = ODD_PARITY;
    uartInit.lineCtrl.sendBreak = SEND_BREAK_DISABLE;
    uartInit.lineCtrl.stickParitySel = STICK_PARITY_DISABLE;
    uartInit.lineCtrl.stopSel = ONE_STOP_BIT;
    uartInit.lineCtrl.wordLengh = DATA_8BIT;
    smtUartSetMode(&uartInit, SET_UARTLCR);

    // UARTCR register setting
    UART_RX_ENABLE(&g_pUARTReg->UARTCR, RX_EN);      // Rx enable
    UART_TX_ENABLE(&g_pUARTReg->UARTCR, TX_EN);      // Tx enable
    UART_LOOPBACK_DISABLE(&g_pUARTReg->UARTCR, LOOP_BACK_EN);    // Loop-back disable
    UART_DIASBLE(&g_pUARTReg->UARTCR, UART_EN);      // Uart disable

    // Empty the receive FIFO
    while((INREG32(&g_pUARTReg->UARTFR)&RXFIFO_EMPTY) != RXFIFO_EMPTY)
        crash = (UINT8)INREG32(&g_pUARTReg->UARTDR);

    uartInit.rxIntLevel = INT_LEVEL_1BY2;
    uartInit.txIntLevel = INT_LEVEL_1BY2;
    uartInit.intClear = ALL_INT;
    uartInit.intMask = ALL_INT;
    smtUartSetMode(&uartInit, SET_UARTIFLS);
    smtUartSetMode(&uartInit, SET_UARTICR);
    smtUartSetMode(&uartInit, CLR_UARTIMSC);

    // UART ISR register
}


//------------------------------------------------------------------------------
//
//  Function: OEMWriteDebugByte
//
//  Transmits a character out the debug serial port.
//
VOID OEMWriteDebugByte(UINT8 ch) 
{
#if 1//shkim-0929
    if(ch =='\n')
    {
        while(!((INREG32(&g_pUARTReg->UARTFR))&TXFIFO_EMPTY));  // Wait until Tx FIFO empty
#if 0
    smtDelay100us(1);
#endif
        OUTREG32(&g_pUARTReg->UARTDR, '\r');
    }

    while(!((INREG32(&g_pUARTReg->UARTFR))&TXFIFO_EMPTY));  // Wait until Tx FIFO empty

#if 0
    smtDelay100us(1);
#endif
    OUTREG32(&g_pUARTReg->UARTDR, ch);
#else
    // Wait for transmit buffer to be empty
    while ((INREG32(&g_pUARTReg->UTRSTAT) & 0x02) == 0);

    // Send character
    OUTREG32(&g_pUARTReg->UTXH, ch);
#endif    
}


//------------------------------------------------------------------------------
//
//  Function: OEMReadDebugByte
//
//  Reads a byte from the debug serial port. Does not wait for a character. 
//  If a character is not available function returns "OEM_DEBUG_READ_NODATA".
//

int OEMReadDebugByte() 
{

#if 1//shkim-0929
    UINT32 ch;
    UINT32 waitTime = 0, cnt = 0;

    while(INREG32(&g_pUARTReg->UARTFR) & RXFIFO_EMPTY)       // Wait until Rx FIFO not empty.
    {
        if(waitTime == 0 /*WAIT_FOREVER*/)
            continue;

        if(cnt++ < waitTime)
            smtDelay100us(1);
        else
            return OEM_DEBUG_READ_NODATA;
    }

    ch = INREG32(&g_pUARTReg->UARTDR);

    return (int)ch;
#else
    UINT32 status, ch;
    status = INREG32(&g_pUARTReg->UTRSTAT);
    if ((status & 0x01) != 0) {
       ch = INREG32(&g_pUARTReg->URXH);
       // if ((status & UART_LINESTAT_RF) != 0) ch = OEM_DEBUG_COM_ERROR;
    } else {
       ch = OEM_DEBUG_READ_NODATA;
    }
    return (int)ch;
#endif    
}


/*
    @func   void | OEMWriteDebugLED | Writes specified pattern to debug LEDs 1-4.
    @rdesc  None.
    @comm    
    @xref   
*/
void OEMWriteDebugLED(UINT16 Index, DWORD Pattern)
{
#if 0 //shkim-0929
    volatile SMT926A_IOPORT_REG *smtIOP = (SMT926A_IOPORT_REG *)OALPAtoVA(SMT926A_BASE_REG_PA_IOPORT, FALSE);

    // The SMT926A Eval platform supports 4 LEDs..
    //
    smtIOP->GPFDAT=(smtIOP->GPFDAT & 0xf) | ((Pattern & 0xf)<<4);
#endif
}

UINT8 smtUartSetMode(UART_STRUCT *uart, UART_MODE mode)
{
    UINT32 regValue;

    switch(mode)
    {
        case SET_UARTLCR :
            /* Set UARTLCR_H (line control register) */
            OUTREG32(&g_pUARTReg->UARTLCR_H,
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
                regValue = INREG32(&g_pUARTReg->UARTLCR_H);
                uart->lineCtrl.sendBreak = (UINT8)((regValue & SEND_BREAK)>>SHIFT_DN_FROM_MASK(SEND_BREAK));
                uart->lineCtrl.parityEn = (UINT8)((regValue & PARITY_EN)>>SHIFT_DN_FROM_MASK(PARITY_EN));
                uart->lineCtrl.paritySel = (UINT8)((regValue & EVEN_PARITY_SEL)>>SHIFT_DN_FROM_MASK(EVEN_PARITY_SEL));
                uart->lineCtrl.stopSel = (UINT8)((regValue & T_STOP_BIT_SEL)>>SHIFT_DN_FROM_MASK(T_STOP_BIT_SEL));
                uart->lineCtrl.fifoEn = (UINT8)((regValue & EN_FIFO)>>SHIFT_DN_FROM_MASK(EN_FIFO));
                uart->lineCtrl.wordLengh = ((UINT8)(regValue & WORD_LENGTH)>>SHIFT_DN_FROM_MASK(WORD_LENGTH));
                uart->lineCtrl.stickParitySel = (UINT8)((regValue & STICK_PAR_SEL)>>SHIFT_DN_FROM_MASK(STICK_PAR_SEL));
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
            UART_INT_FIFO_LEVEL_SET(&g_pUARTReg->UARTIFLS, uart->rxIntLevel, RX_INTERRUPT_LEVEL);
            UART_INT_FIFO_LEVEL_SET(&g_pUARTReg->UARTIFLS, uart->rxIntLevel, TX_INTERRUPT_LEVEL);

            break;
        case GET_UARTIFLS :
            /* Get UARTIFLS (interrupt FIFO level select register) */
            UART_INT_FIFO_LEVEL_GET(&g_pUARTReg->UARTIFLS, uart->rxIntLevel, RX_INTERRUPT_LEVEL);
            UART_INT_FIFO_LEVEL_GET(&g_pUARTReg->UARTIFLS, uart->txIntLevel, TX_INTERRUPT_LEVEL);
        break;

        case SET_UARTICR :
            /* Set UARTCR (interrupt clear register) */
            UART_INT_CLEAR(&g_pUARTReg->UARTICR, uart->intClear);
            break;

        case SET_UARTIMSC :
            /* Set UARTIMSC (interrupt mask set/clear register) */
            UART_INT_MASK_SET(&g_pUARTReg->UARTIMSC, uart->intMask);
            break;
        case CLR_UARTIMSC :
            /* Clear UARTIMSC (interrupt mask set/clear register) */
            UART_INT_MASK_CLR(&g_pUARTReg->UARTIMSC, uart->intMask);
            break;
        case GET_UARTIMSC :
            /* Get UARTIMSC (interrupt mask set/clear register) */
            UART_INT_MASK_GET(&g_pUARTReg->UARTIMSC, uart->intMask);
            break;

        default :
            return SMT_ERROR;
    }

    return SMT_SUCCESS;
}
/*-----------------------------------------------------------------------
    Function name   : smtUartSetBaudRate()
    Prototype           : smtBoolean smtUartSetBaudRate(UINT32 baudRate)
    Return              : error code
    Argument        :
    Comments        :
            Baud-rate setting
                baudDiv = 8M/(16*baudrate)
                iBRD = Integer(baudDiv)
                fBRD = baudDiv - iBRD
                m = integer(fBRD*2n+0.5)
-----------------------------------------------------------------------*/
UINT8 smtUartSetBaudRate(UINT32 baudRate)
{
    UINT32 iBRD, m;
    float baudDiv, fBRD;
    
    baudDiv = (float)(8*1000000)/(16*baudRate);
    iBRD = (UINT32)baudDiv;
    fBRD = baudDiv - iBRD;
    m = (UINT32)(fBRD*64+0.5);   // m = integer(BFDF*2n + 0.5) - n is width of UARTFBRD

    OUTREG32(&g_pUARTReg->UARTIBRD, iBRD);
    OUTREG32(&g_pUARTReg->UARTFBRD, m);
    //baudDiv = iBRD + m/64;
    //realBaudRate = (8*1000000)/(16*baudDiv);

    return SMT_SUCCESS;
}

/*-----------------------------------------------------------------------
    Function name   : smtDelay100us()
    Prototype           : smtBoolean smtDelay100us(smtInt32 time);
    Return              : smtBoolean
    Argument            : time ->  time to delay
    Comments        : function to delay.
                      time > 0 : the number of loop time
-----------------------------------------------------------------------*/
UINT8 smtDelay100us(UINT32 time)
{
#if 0
    //sysDelay100us(time);  //sysArmLib.c

#else
	{
		UINT32 i;
		for(i=0; i<(time*100*4); i++)
		{
			volatile UINT32 j = 0;	// this volatile is effective when compiler cutting over at optimization.
			j++;
			j--;
		}
	}
#endif

    return SMT_SUCCESS;
}
//------------------------------------------------------------------------------
