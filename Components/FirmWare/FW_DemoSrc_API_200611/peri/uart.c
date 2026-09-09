/*
 * Copyright: 
 * ----------------------------------------------------------------
 * This confidential and proprietary software may be used only as
 * authorised by a licensing agreement from ARM Limited
 *   (C) COPYRIGHT 1999,2000,2001 ARM Limited
 *       ALL RIGHTS RESERVED
 * The entire notice above must be reproduced on all authorised
 * copies and copies may only be made to the extent permitted
 * by a licensing agreement from ARM Limited.
 * ----------------------------------------------------------------
 * File:     uart.c,v
 * Revision: 1.82
 * ----------------------------------------------------------------
 * 
 *  ----------------------------------------
 *  Version and Release Control Information:
 * 
 *  File Name              : uart.c.rca
 *  File Revision          : 1.2
 * 
 *  Release Information    : PrimeCell(TM)-PL011-REL2v0
 *  ----------------------------------------
 *
 * UART device driver code
 */

//#include "../apcommon/aptypes.h"
//#include "../apcommon/apbitops.h"
//#include "../apos/apos.h"
#include "uartglobal.h"
#include "apuart.h"
#include "uart.h"

#if !defined(apOS_NO_STATIC_STATE) || (!apOS_NO_STATIC_STATE)
PRIVATE UART_sStateStruct UART_sState[apOS_UART_MAXIMUM];
#endif




/*
 * Macros defined to cater for differences in interrupt register definitions for different variants
 */

#if ((apUART_VERSION == apUART_VERS_AP) || (apUART_VERSION == 10))
#define UART_INTENABLE(__type, __enab)  apBIT_SET(pBase->Control, UART_ ## __type ## _INTENAB, UART_INTERRUPT_ ## __enab);
#define UART_INTCLEAR( __type)           apBIT_SET(pBase->Interrupt, UART_ ## __type, 0xFFFFFF);
#define UART_INTMASK() pBase->Control
#else
#define UART_INTENABLE(__type, __enab)  apBIT_SET(pBase->IntMask, UART_ ## __type ## _INTENAB, UART_INTERRUPT_ ## __enab);
#define UART_INTCLEAR(__type)           apBIT_SET(pBase->IntClear, UART_ ## __type, 0xFFF);
#define UART_INTMASK() pBase->IntMask

#endif

#define UART_INTREAD()    InterRead = pBase->Interrupt;
#define UART_INTTEST(__type)  InterRead & (UART_INTBIT_ ## __type)

/*
 * Reads as much data from FIFO until either FIFO is empty or pBuffer is full.
 */
#define UART_FIFO_READ()                                                                                        \
    {                                                                                                           \
        while ((apBIT_GET(pBase->Flag, UART_RECEIVE_EMPTY) != UART_FIFO_SERVICE) && (pState->RemainReceive > 0))\
        {                                                                                                       \
            *(pState->pDataReceive)++ = (UBYTE8)((pBase->DataRead) & 0xFF);                                     \
            pState->RemainReceive--;                                                                            \
        }                                                                                                       \
    }
/* 
 * Writes as much of the current buffer data to the transmit buffer until it fills
 * or there is no more data to send. Reads words at a time from memory for speed.
 */

#define UART_FIFO_WRITE() \
    { \
        while ((apBIT_GET(pBase->Flag, UART_TRANSMIT_FULL) != UART_FIFO_SERVICE) && (pState->RemainSend > 0)) \
        {                                                                                                     \
            pBase->DataRead = (UWORD32)(*(pState->pDataSend)++) & (UWORD32)(0xFF);                            \
            pState->RemainSend--;                                                                             \
        }                                                                                                     \
    }
 
/*====================================================================*/

/*                  Operating System Functions                        */

/*====================================================================*/

PUBLIC UWORD32 apUART_StateSizeGet(void)
{
    return sizeof(UART_sStateStruct);
}

/*
 * This function is a raw interrupt service routine entry point, 
 * which can be called from the interrupt vector
 */
// holelee PUBLIC IRQ void apUART_RawISR(void)
PUBLIC void apUART_RawISR(void)
{
    UWORD32 oId;
    apOS_INT_oInterruptSource oSource;

#if !apOS_NO_STATIC_STATE
    /*peripheral instance 0 if only one in use*/
    if (apOS_UART_MAXIMUM == 1)
    {
        oId= 0;
    }
    else
#endif
    {
        /*retrieve the peripheral instance*/
        oId= apOS_INT_InstanceGet();
    }
    /*retrieve the active interrupt source*/
    oSource= apOS_INT_SourceGet();

    /*call the normal ISR entry point*/
    apUART_IntHandler(oSource,oId);
}

/*====================================================================*/

/*                  UART API Functions                                */

/*====================================================================*/
PUBLIC void apUART_IntHandler(CONST apOS_INT_oInterruptSource IntID, UWORD32 oId)
{
    apUART_rListener rListCall;
    apUART_rCallback rRecvCall;
    apUART_rCallback rTranCall ;
    apUART_eListenerMessage eListParm ;
    apError eRecvErr;
    apError eTranErr;
    UWORD32 InterRead;
    UART_sStateStruct * pState;    
    UART_sPort * pBase;

    /* Disable and clear Interrupts */
    apOS_ISR_InterruptDisable(IntID);
    apOS_INT_InterruptClear(IntID);
    
    /* Set up pointer to state - pState */
    pState = apSTATE_GET(UART, oId);
    
    /* Set up pointer to base address - pBase */
    pBase = pState->pBaseAddress;

    rListCall = aRNULL;
    rRecvCall = aRNULL;
    rTranCall = aRNULL;
    eListParm = (apUART_eListenerMessage) 0;
    eRecvErr = (apError) 0;
    eTranErr = (apError) 0;

    UART_INTREAD();

    /* Timeout interrupt */
    if (UART_INTTEST(TIMEOUT))
    {
        if (pState->Status & UART_STATE_RECEIVE)
        {
            UART_FIFO_READ();
            
            /* Check if end of pBuffer storage and there is still data in Rx FIFO */
            if ((pState->RemainReceive == 0) && (apBIT_GET(pBase->Flag, UART_RECEIVE_EMPTY) != UART_FIFO_SERVICE))
            {
                rRecvCall = pState->rNotifyReceive;
                pState->Status &= ~UART_STATE_RECEIVE;
                eRecvErr = (apError) apUART_BUFFER_FULL;
            }
            else
            { /* Rx FIFO empty */
                pState->Status &= ~UART_STATE_RECEIVE;
                rRecvCall = pState->rNotifyReceive;
                eRecvErr = apERR_NONE;
            }
        }
        else
        {
            rListCall = pState->rNotifyListener;
            eListParm = apUART_DATA_ARRIVED;
        }
        UART_INTCLEAR(TIMEOUT);
        UART_INTCLEAR(RECEIVE);           
    }
    /* Receive interrupt */
    else if (UART_INTTEST(RECEIVE))
    {
        if (pState->Status & UART_STATE_RECEIVE)
        {                       
            UART_FIFO_READ();

            /* End of pBuffer */
            if (pState->RemainReceive == 0)
            {
                rRecvCall = pState->rNotifyReceive;
                pState->Status &= ~UART_STATE_RECEIVE;
                eRecvErr = (apError) apUART_BUFFER_FULL;
            }
            /* no else case - will just read more data at the next interrupt (timeout or receive) */
            UART_INTCLEAR(RECEIVE);
        }
        else
        {
            rListCall = pState->rNotifyListener;
            eListParm = apUART_DATA_ARRIVED;
            
            /* Check otherwise ISR loops forever */
            if (rListCall == aRNULL)
            {
                UART_INTCLEAR(RECEIVE);
            }
        }
    }    
    /* Modem interrupt */
    else if (UART_INTTEST(MODEM))
    {
        rListCall = pState->rNotifyListener;
#if (apUART_VERSION == 11)
        if (UART_INTTEST(MODEMRI))
        {
            eListParm = apUART_DEVICE_CHANGED_RI;
            UART_INTCLEAR(MODEMRI);            
        }
        else if (UART_INTTEST(MODEMCTS))
        {
            eListParm = apUART_DEVICE_CHANGED_CTS;        
            UART_INTCLEAR(MODEMCTS);
        }
        else if (UART_INTTEST(MODEMDCD))
        {
            eListParm = apUART_DEVICE_CHANGED_DCD;        
            UART_INTCLEAR(MODEMDCD);
        }
        else /* (if UART_INTTEST(oId, MODEMDSR)) case */
        {
            eListParm = apUART_DEVICE_CHANGED_DSR;        
            UART_INTCLEAR(MODEMDSR);
        }
#else
        eListParm = apUART_DEVICE_CHANGED;
        UART_INTCLEAR(MODEM);
#endif

    }
#if (apUART_VERSION == 11)
    /* Framing, parity, break, overrun interrupts */
    else if (UART_INTTEST(ERROR))
    {
        rRecvCall = pState->rNotifyReceive;
        
        if (UART_INTTEST(OVERRUN)) 
        {
            eRecvErr = (apError) apUART_ERROR_OVERRUN;
            UART_INTCLEAR(OVERRUN);                    
        }
        else if (UART_INTTEST(FRAME))
        {
            eRecvErr = (apError) apUART_ERROR_FRAME;
            UART_INTCLEAR(FRAME);
        }
        else if (UART_INTTEST(PARITY))
        {
            eRecvErr = (apError) apUART_ERROR_PARITY;
            UART_INTCLEAR(PARITY);
        }
        else /* if (UART_INTTEST(oId, BREAK)) test */
        {
            eRecvErr = (apError) apUART_ERROR_BREAK;    
            UART_INTCLEAR(BREAK);     
        }
        
    }
#endif
        
    /* Transmit interrupt - not connected to above checks as different
       user callback (transmit) handler routine, trancall */
    if (UART_INTTEST(TRANSMIT))
    {
        if (pState->Status & UART_STATE_SEND)
        {
            UART_FIFO_WRITE();

            if (pState->RemainSend == 0)
            {
                pState->Status &= ~UART_STATE_SEND;
                rTranCall = pState->rNotifySend;
                eTranErr = apERR_NONE;
                pState->rNotifySend = aRNULL;
                pState->pDataSend = aNULL;
                UART_INTENABLE(TRANSMIT, DISABLED);
            }
        }
        else
        {
            UART_INTENABLE(TRANSMIT, DISABLED);
        }
        UART_INTCLEAR(TRANSMIT);
    }


    if (rListCall != aRNULL) (rListCall)(oId, eListParm);
    if (rRecvCall != aRNULL) (rRecvCall)(oId, eRecvErr);
    if (rTranCall != aRNULL) (rTranCall)(oId, eTranErr);
    
    /* enable the interrupts*/
    apOS_ISR_InterruptEnable(IntID);
}

/*====================================================================*/
PUBLIC void apUART_Initialize (apOS_UART_oId oId,
                               apOS_System_eBaseAddress eBase,
                               UWORD32 Interrupts,
                               CONST apOS_INT_oInterruptSource * pSources,
                               CONST apUART_sInitialData *pInitial)
{
    UWORD32 Trash;

    /* Define and set up pointer to state - pState */
    UART_sStateStruct * CONST pState = apSTATE_GET(UART, oId);

    /* Define and set up pointer to base address - pBase */
    UART_sPort * CONST pBase = (UART_sPort *) eBase;

#if !apOS_NO_STATIC_STATE
    apASSERT(oId < apOS_UART_MAXIMUM);
#endif

    pState->pBaseAddress = (UART_sPort *) eBase;

    pState->rNotifyListener = aRNULL;
    pState->rNotifySend     = aRNULL;
    pState->rNotifyReceive  = aRNULL;
    pState->Status          = 0;
    
    /* Reference clock frequency applied to UARTCLK input */
    pState->ClockFrequency = pInitial->ClockFrequency >> 4;
    
    /* Not used within functions but there for future potential use */
    pState->FIFOSize = ((UWORD32) pInitial->FIFOSize);
    
    /* Sets relevant control settings:
     * PL011 register halves set separately as have write reserved bits in middle of register.
     */
#if ((apUART_VERSION == apUART_VERS_AP) || (apUART_VERSION == 10))
        pBase->Control = UART_READY_CODE;
#elif (apUART_VERSION == 11)
        apBIT_SET(pBase->Control, UART_CONTROL_LOWBITS, UART_READY_CODE_LOW);
        apBIT_SET(pBase->Control, UART_CONTROL_HIGHBITS, UART_READY_CODE_HIGH);
#endif

    /* Due to reset values and the following this sets word length to 8,
     * enables the FIFOs, one stop bit, no parity and send break = 0.  
     */   
    apBIT_SET(pBase->LineCon_H, UART_WORD_LENGTH, apUART_BITS_8);
    apBIT_SET(pBase->LineCon_H, UART_FIFO_ENABLE, UART_FIFO_ENABLE);
    apBIT_SET(pBase->LineCon_H, UART_SEND_BREAK, 0);
    apBIT_SET(pBase->LineCon_H, UART_TWO_STOP_BITS, apUART_ONE_STOP_BIT);
    apBIT_SET(pBase->LineCon_H, UART_PARITY_SELECT, apUART_NO_PARITY);
#if (apUART_VERSION == 11)
    /* Disable stick parity */
    apBIT_SET(pBase->LineCon_H, UART_STICK_PARITY, apUART_STICK_DISABLED);
    /* Set Transmit and Receive Fifos to trigger at their halfway level */
    apBIT_SET(pBase->FifoSelect, UART_TRANS_INT_LEVEL, apUART_HALF);
    apBIT_SET(pBase->FifoSelect, UART_RECV_INT_LEVEL, apUART_HALF);
#endif

    /* Empty the receive FIFO */
    while (apBIT_GET(pBase->Flag, UART_RECEIVE_EMPTY) != UART_FIFO_SERVICE)
    {
        Trash = pBase->DataRead;
    }
    
    UART_INTCLEAR(ALL);

    UART_INTMASK()=0;

    /* Register the interrupt handler(s) and enable the interrupt on the
     * interrupt controller for each source 
     */
    apBIND_ALL_INTERRUPTS(apUART_IntHandler,apUART_RawISR);
}

/*====================================================================*/
PUBLIC apError apUART_DMAModeSet(apOS_UART_oId oId, apUART_eDMAMode eDMAMode)
{
    /* Define and set up pointer to state - pState */
    UART_sStateStruct * CONST pState = apSTATE_GET(UART, oId);
    
    /* Define and set up pointer to base address - pBase */
    UART_sPort * CONST pBase = pState->pBaseAddress;

#if !apOS_NO_STATIC_STATE
    apASSERT(oId < apOS_UART_MAXIMUM);
#endif

#if (apUART_VERSION == 11)
    /* Set DMA enable bit */
    switch (eDMAMode)
    {
        case apUART_DMA_TX_ON:
            apBIT_SET(pBase->DmaCon, UART_DMA_TRANSMIT_ENABLE, 1);
            break;
        case apUART_DMA_TX_OFF:
            apBIT_CLEAR(pBase->DmaCon, UART_DMA_TRANSMIT_ENABLE);
            break;
        case apUART_DMA_RX_ON:
            apBIT_SET(pBase->DmaCon, UART_DMA_RECEIVE_ENABLE, 1);
            break;
        case apUART_DMA_RX_OFF:
            apBIT_CLEAR(pBase->DmaCon, UART_DMA_RECEIVE_ENABLE);
            break;
    }
    return apERR_NONE;
#else
    IGNORE (pBase);
    IGNORE (eDMAMode);
    return apERR_UNSUPPORTED;
#endif

}

/*====================================================================*/
PUBLIC UWORD32 apUART_DMAAddressGet(apOS_UART_oId oId)
{
    /* Define and set up pointer to state - pState */
    UART_sStateStruct * CONST pState = apSTATE_GET(UART, oId);
    
    /* Define and set up pointer to base address - pBase */
    UART_sPort * CONST pBase = pState->pBaseAddress;

#if !apOS_NO_STATIC_STATE
    apASSERT(oId < apOS_UART_MAXIMUM);
#endif

    return (UWORD32) &pBase->DataRead;
}

/*====================================================================*/
PUBLIC apError apUART_BaudRateSet(apOS_UART_oId oId, UWORD32 Rate)
{
    /* Define and set up pointer to state - pState */
    UART_sStateStruct * CONST pState = apSTATE_GET(UART, oId);
    
    /* Define and set up pointer to base address - pBase */
    UART_sPort * CONST pBase = pState->pBaseAddress;

#if !apOS_NO_STATIC_STATE
    apASSERT(oId < apOS_UART_MAXIMUM);
#endif

#if ((apUART_VERSION == apUART_VERS_AP) || (apUART_VERSION == 10))
    {
        UWORD32 Baud;

        Baud = (UWORD32) (pState->ClockFrequency / Rate) - 1;
        if ( Baud > 65535 )
        {
            return (apError) apUART_INVALID_BAUD_RATE;
        }
        apBIT_SET(pBase->LineCon_L, UART_BAUD_DIVISOR, Baud);
        Baud >>= 8;
        apBIT_SET(pBase->LineCon_M, UART_BAUD_DIVISOR, Baud);
    }
#elif (apUART_VERSION == 11)
    {
        UWORD32 BaudIntDiv;
        float BaudRateDiv = (float) pState->ClockFrequency / Rate;

        /* Calculate integer baud rate register value */
        BaudIntDiv = (UWORD32) BaudRateDiv;
        if (( BaudIntDiv > 65535 ) || ( BaudIntDiv == 0 ))
        {
            return (apError) apUART_INVALID_BAUD_RATE;
        }
        pBase->IntBaudDivisor = BaudIntDiv;

        /* Calculate fractional baud rate register value */
        if ( BaudIntDiv == 65535 )
        {
            pBase->FractBaudDivisor = 0;
        }
        else
        {
            BaudRateDiv -= BaudIntDiv;
            pBase->FractBaudDivisor = (UWORD32) ((BaudRateDiv * 64) + 0.5);
        }  
    }
#endif
   /* 
    * For PL010 must write to UARTLCR_H last to actually write to UARTLCR_L, UARTLCR_M.
    * For PL011 must write to UARTLCR_H last to actually write to UARTIBRD and UARTFBRD.
    */
    pBase->LineCon_H = pBase->LineCon_H;
    return apERR_NONE;

}

/*====================================================================*/
PUBLIC UWORD32 apUART_BaudRateGet(apOS_UART_oId oId)
{
    /* Define and set up pointer to state - pState */
    UART_sStateStruct * CONST pState = apSTATE_GET(UART, oId);
    
    /* Define and set up pointer to base address - pBase */
    UART_sPort * CONST pBase = pState->pBaseAddress;

#if !apOS_NO_STATIC_STATE
    apASSERT(oId < apOS_UART_MAXIMUM);
#endif

#if ((apUART_VERSION == apUART_VERS_AP) || (apUART_VERSION == 10))
    {
        UWORD32 Baud;
    
        Baud = apBIT_GET(pBase->LineCon_L, UART_BAUD_DIVISOR);
        Baud |= (apBIT_GET(pBase->LineCon_M, UART_BAUD_DIVISOR) << 8);
        return pState->ClockFrequency / (Baud + 1);
    }
#elif (apUART_VERSION == 11)
    {
        float BaudRateDiv;
        if (pBase->FractBaudDivisor != 0)
        {
            BaudRateDiv = (float) (((pBase->FractBaudDivisor - 0.5)/64) + pBase->IntBaudDivisor);
            return (UWORD32) (pState->ClockFrequency / BaudRateDiv);
        }
        else 
        {
            return (UWORD32) (pState->ClockFrequency / pBase->IntBaudDivisor);
        }
    }
#endif
}

/*====================================================================*/
PUBLIC void apUART_Enable(apOS_UART_oId oId)
{
    /* Define and set up pointer to state - pState */
    UART_sStateStruct * CONST pState = apSTATE_GET(UART, oId);
    
    /* Define and set up pointer to base address - pBase */
    UART_sPort * CONST pBase = pState->pBaseAddress;

#if !apOS_NO_STATIC_STATE
    apASSERT(oId < apOS_UART_MAXIMUM);
#endif

    apBIT_SET(pBase->LineCon_H, UART_FIFO_ENABLE, UART_FIFO_ENABLE);
    
    /* Enables all interrupts except transmit */
    UART_INTENABLE(ALL, READY);
    
    apBIT_SET(pBase->Control, UART_ENABLE, UART_ENABLED);
}

/*====================================================================*/
PUBLIC void apUART_Disable(apOS_UART_oId oId)
{
    /* Define and set up pointer to state - pState */
    UART_sStateStruct * CONST pState = apSTATE_GET(UART, oId);
    
    /* Define and set up pointer to base address - pBase */
    UART_sPort * CONST pBase = pState->pBaseAddress;

#if !apOS_NO_STATIC_STATE
   apASSERT(oId < apOS_UART_MAXIMUM);
#endif

    apBIT_SET(pBase->Control, UART_ENABLE, UART_DISABLED);
}

/*====================================================================*/
PUBLIC apError apUART_TxEnable(apOS_UART_oId oId)
{
    /* Define and set up pointer to state - pState */
    UART_sStateStruct * CONST pState = apSTATE_GET(UART, oId);
    
    /* Define and set up pointer to base address - pBase */
    UART_sPort * CONST pBase = pState->pBaseAddress;

#if (apUART_VERSION == 11)
    apBIT_SET(pBase->Control, UART_TRANSMIT_ENABLE, UART_ENABLED);
    return apERR_NONE;
#else
    IGNORE (pBase);
    return apERR_UNSUPPORTED;
#endif
}

/*====================================================================*/
PUBLIC apError apUART_TxDisable(apOS_UART_oId oId)
{
    /* Define and set up pointer to state - pState */
    UART_sStateStruct * CONST pState = apSTATE_GET(UART, oId);
    
    /* Define and set up pointer to base address - pBase */
    UART_sPort * CONST pBase = pState->pBaseAddress;

#if !apOS_NO_STATIC_STATE
    apASSERT(oId < apOS_UART_MAXIMUM);
#endif

#if (apUART_VERSION == 11)
    apBIT_SET(pBase->Control, UART_TRANSMIT_ENABLE, UART_DISABLED);
    return apERR_NONE;
#else
    IGNORE (pBase);
    return apERR_UNSUPPORTED;
#endif
}

/*====================================================================*/
PUBLIC BOOL apUART_TxFIFOEmpty(apOS_UART_oId oId)
{
    /* Define and set up pointer to state - pState */
    UART_sStateStruct * CONST pState = apSTATE_GET(UART, oId);
    
    /* Define and set up pointer to base address - pBase */
    UART_sPort * CONST pBase = pState->pBaseAddress;

#if !apOS_NO_STATIC_STATE
    apASSERT(oId < apOS_UART_MAXIMUM);
#endif

    return (apBIT_GET(pBase->Flag, UART_TRANSMIT_EMPTY)) ? TRUE:FALSE;
}

/*====================================================================*/
PUBLIC apError apUART_RxEnable(apOS_UART_oId oId)
{
    /* Define and set up pointer to state - pState */
    UART_sStateStruct * CONST pState = apSTATE_GET(UART, oId);
    
    /* Define and set up pointer to base address - pBase */
    UART_sPort * CONST pBase = pState->pBaseAddress;

#if !apOS_NO_STATIC_STATE
    apASSERT(oId < apOS_UART_MAXIMUM);
#endif

#if (apUART_VERSION == 11)
    apBIT_SET(pBase->Control, UART_RECEIVE_ENABLE, UART_ENABLED);
    return apERR_NONE;
#else
    IGNORE (pBase);
    return apERR_UNSUPPORTED;
#endif
}

/*====================================================================*/
PUBLIC apError apUART_RxDisable(apOS_UART_oId oId)
{
    /* Define and set up pointer to state - pState */
    UART_sStateStruct * CONST pState = apSTATE_GET(UART, oId);
    
    /* Define and set up pointer to base address - pBase */
    UART_sPort * CONST pBase = pState->pBaseAddress;

#if !apOS_NO_STATIC_STATE
    apASSERT(oId < apOS_UART_MAXIMUM);
#endif

#if (apUART_VERSION == 11)
    apBIT_SET(pBase->Control, UART_RECEIVE_ENABLE, UART_DISABLED);
    return apERR_NONE;
#else
    IGNORE (pBase);
    return apERR_UNSUPPORTED;
#endif
}

/*====================================================================*/
PUBLIC apError apUART_Transmit(apOS_UART_oId oId, void *pBuffer, UWORD32 Size, apUART_rCallback rCallback)
{
    /* Define and set up pointer to state - pState */
    UART_sStateStruct * CONST pState = apSTATE_GET(UART, oId);
    
    /* Define and set up pointer to base address - pBase */
    UART_sPort * CONST pBase = pState->pBaseAddress;

#if !apOS_NO_STATIC_STATE
    apASSERT(oId < apOS_UART_MAXIMUM);
#endif

    if (pState->Status & UART_STATE_SEND)
    {
        return (apError) apUART_IN_USE;
    }
    if (pBuffer == aNULL)
    {
        return (apError) apUART_NO_BUFFER;
    }
    if (Size == 0)
    {
        return (apError) apUART_SIZE_ZERO;
    }

    pState->Status |= UART_STATE_SEND;
    
    apBIT_SET(pBase->Control, UART_ENABLE, UART_ENABLED);
   

    pState->rNotifySend = rCallback;
    pState->pDataSend = (UBYTE8 *) pBuffer;
    pState->RemainSend = Size;

    /* Set transfer going */
    UART_FIFO_WRITE();

    /* Transfer stopped so confirm whether Tx FIFO full or end of pBuffer */
    if (pState->RemainSend > 0)
    {
        UART_INTENABLE(TRANSMIT, ENABLED);
    }
    else
    {
        pState->Status &= ~UART_STATE_SEND;
        pState->rNotifySend = aRNULL;
        pState->pDataSend = aNULL;
        (rCallback) ((UWORD32) oId, apERR_NONE);
    }

    return apERR_NONE;
}

/*====================================================================*/
PUBLIC apError apUART_Receive(apOS_UART_oId oId, void *pBuffer, UWORD32 Size, apUART_rCallback rCallback)
{
    /* Define and set up pointer to state - pState */
    UART_sStateStruct * CONST pState = apSTATE_GET(UART, oId);
    
    /* Define and set up pointer to base address - pBase */
    UART_sPort * CONST pBase = pState->pBaseAddress;

#if !apOS_NO_STATIC_STATE
    apASSERT(oId < apOS_UART_MAXIMUM);
#endif

    if (pState->Status & UART_STATE_RECEIVE)
    {
        return (apError) apUART_IN_USE;
    }
    if (pBuffer == aNULL)
    {
        return (apError) apUART_NO_BUFFER;
    }
    if (Size == 0)
    {
        return (apError) apUART_SIZE_ZERO;
    }
    
    pState->Status |= UART_STATE_RECEIVE;
    pState->rNotifyReceive = rCallback;
    pState->RemainReceive = Size;
    
    pState->pDataReceive = (UBYTE8 *)pBuffer;
 
    /* Ensure receive is underway */
    apBIT_SET(pBase->Control, UART_ENABLE, UART_ENABLED);
    return apERR_NONE;
}

/*====================================================================*/
PUBLIC apError apUART_Continue(apOS_UART_oId oId)
{
    /* Define and set up pointer to state - pState */
    UART_sStateStruct * CONST pState = apSTATE_GET(UART, oId);
    
#if !apOS_NO_STATIC_STATE
    apASSERT(oId < apOS_UART_MAXIMUM);
#endif

    if (pState->Status & UART_STATE_RECEIVE)
    {
        return (apError) apUART_IN_USE;
    }
    pState->Status |= UART_STATE_RECEIVE;
    return apERR_NONE;
}

/*====================================================================*/
PUBLIC UWORD32 apUART_Read(apOS_UART_oId oId)
{
    /* Define and set up pointer to state - pState */
    UART_sStateStruct * CONST pState = apSTATE_GET(UART, oId);
    
    /* Define and set up pointer to base address - pBase */
    UART_sPort * CONST pBase = pState->pBaseAddress;

#if !apOS_NO_STATIC_STATE
    apASSERT(oId < apOS_UART_MAXIMUM);
#endif

    /* Check that we're not busy */
    if (pState->Status & UART_STATE_RECEIVE)
    {
        return (apError) apUART_IN_USE;
    }
    /* check receive buffer is not empty */
    if (apBIT_GET(pBase->Flag, UART_RECEIVE_EMPTY) == UART_FIFO_SERVICE)
    {
        return (apError) apUART_FIFO_EMPTY;
    }
    /* return next character from FIFO */
    return pBase->DataRead;
}

/*====================================================================*/
PUBLIC apError apUART_Write(apOS_UART_oId oId, UWORD32 Byte_to_send)
{
    /* Define and set up pointer to state - pState */
    UART_sStateStruct * CONST pState = apSTATE_GET(UART, oId);
    
    /* Define and set up pointer to base address - pBase */
    UART_sPort * CONST pBase = pState->pBaseAddress;

#if !apOS_NO_STATIC_STATE
    apASSERT(oId < apOS_UART_MAXIMUM);
#endif

    /* Check that we're not busy */
    if (pState->Status & UART_STATE_SEND)
    {
        return (apError) apUART_IN_USE;
    }
    /* Check for FIFO transmit buffer full condition */
    if (apBIT_GET(pBase->Flag, UART_TRANSMIT_FULL) == UART_FIFO_SERVICE)
    {
        return (apError) apUART_FIFO_FULL;
    }
    /* Write into FIFO */
    pBase->DataRead = Byte_to_send;

    return apERR_NONE;
}

/*====================================================================*/
PUBLIC UWORD32 apUART_Read_N(apOS_UART_oId oId, UBYTE8* pBuffer, UWORD32 Length)
{
    UWORD32 len = Length;

    /* Define and set up pointer to state - pState */
    UART_sStateStruct * CONST pState = apSTATE_GET(UART, oId);
    
    /* Define and set up pointer to base address - pBase */
    UART_sPort * CONST pBase = pState->pBaseAddress;

#if !apOS_NO_STATIC_STATE
    apASSERT(oId < apOS_UART_MAXIMUM);
#endif

    /* Check that we're not busy */
    if (pState->Status & UART_STATE_RECEIVE)
    {
        return (apError) apUART_IN_USE;
    }

    /* Check for buffer empty condition */
    while ((apBIT_GET(pBase->Flag, UART_RECEIVE_EMPTY) != UART_FIFO_SERVICE) && (len > 0))
    {
        len--;
        *pBuffer++ = (UBYTE8) pBase->DataRead;
    }
    /* Return number of bytes read */
    return Length-len;
}

/*====================================================================*/
PUBLIC UWORD32 apUART_Write_N(apOS_UART_oId oId, UBYTE8* pBuffer, UWORD32 Length)
{
    UWORD32 len = Length;

    /* Define and set up pointer to state - pState */
    UART_sStateStruct * CONST pState = apSTATE_GET(UART, oId);
    
    /* Define and set up pointer to base address - pBase */
    UART_sPort * CONST pBase = pState->pBaseAddress;

#if !apOS_NO_STATIC_STATE
    apASSERT(oId < apOS_UART_MAXIMUM);
#endif

    /* Check that we're not busy */
    if (pState->Status & UART_STATE_SEND) 
    {
        return (apError) apUART_IN_USE;
    }
    
    /* check for buffer full condition */
    while ((apBIT_GET(pBase->Flag, UART_TRANSMIT_FULL) != UART_FIFO_SERVICE) && (len > 0))
    {
        len--;
        pBase->DataRead = *pBuffer++;
    }
    /* Return number of bytes written */
    return Length-len;
}

/*====================================================================*/
PUBLIC UWORD32 apUART_TransmitStatusGet(apOS_UART_oId oId)
{
    /* Define and set up pointer to state - pState */
    UART_sStateStruct * CONST pState = apSTATE_GET(UART, oId);
    
#if !apOS_NO_STATIC_STATE
    apASSERT(oId < apOS_UART_MAXIMUM);
#endif

    return pState->RemainSend;
}

/*====================================================================*/
PUBLIC UWORD32 apUART_ReceiveStatusGet(apOS_UART_oId oId)
{
    /* Define and set up pointer to state - pState */
    UART_sStateStruct * CONST pState = apSTATE_GET(UART, oId);
    
#if !apOS_NO_STATIC_STATE
    apASSERT(oId < apOS_UART_MAXIMUM);
#endif

    return pState->RemainReceive;
}

/*====================================================================*/
PUBLIC void apUART_TerminateTransmit(apOS_UART_oId oId)
{
    /* Define and set up pointer to state - pState */
    UART_sStateStruct * CONST pState = apSTATE_GET(UART, oId);
    
    /* Define and set up pointer to base address - pBase */
    UART_sPort * CONST pBase = pState->pBaseAddress;

#if !apOS_NO_STATIC_STATE
    apASSERT(oId < apOS_UART_MAXIMUM);
#endif

    UART_INTENABLE(TRANSMIT, DISABLED)
    pState->Status &= ~UART_STATE_SEND;
    pState->RemainSend = 0;
}

/*====================================================================*/
PUBLIC void apUART_TerminateReceive(apOS_UART_oId oId)
{
    /* Define and set up pointer to state - pState */
    UART_sStateStruct * CONST pState = apSTATE_GET(UART, oId);
    
#if !apOS_NO_STATIC_STATE
    apASSERT(oId < apOS_UART_MAXIMUM);
#endif

    pState->Status &= ~UART_STATE_RECEIVE;
    pState->RemainReceive = 0;
    pState->rNotifyReceive = aRNULL;
}

/*====================================================================*/
PUBLIC void apUART_CallbackSet(apOS_UART_oId oId, apUART_rListener rListener)
{
    /* Define and set up pointer to state - pState */
    UART_sStateStruct * CONST pState = apSTATE_GET(UART, oId);
    
#if !apOS_NO_STATIC_STATE
    apASSERT(oId < apOS_UART_MAXIMUM);
#endif

    pState->rNotifyListener = rListener;
}

/*====================================================================*/
PUBLIC void apUART_FIFOEnable(apOS_UART_oId oId)
{
    /* Define and set up pointer to state - pState */
    UART_sStateStruct * CONST pState = apSTATE_GET(UART, oId);
    
    /* Define and set up pointer to base address - pBase */
    UART_sPort * CONST pBase = pState->pBaseAddress;

#if !apOS_NO_STATIC_STATE
    apASSERT(oId < apOS_UART_MAXIMUM);
#endif

    apBIT_SET(pBase->LineCon_H, UART_FIFO_ENABLE, UART_FIFO_ENABLE);
}

/*====================================================================*/
PUBLIC void apUART_FIFODisable(apOS_UART_oId oId)
{
    /* Define and set up pointer to state - pState */
    UART_sStateStruct * CONST pState = apSTATE_GET(UART, oId);
    
    /* Define and set up pointer to base address - pBase */
    UART_sPort * CONST pBase = pState->pBaseAddress;

#if !apOS_NO_STATIC_STATE
    apASSERT(oId < apOS_UART_MAXIMUM);
#endif

    apBIT_SET(pBase->LineCon_H, UART_FIFO_ENABLE, UART_FIFO_DISABLE);
}

/*====================================================================*/
PUBLIC apError apUART_FIFOConfigSet(apOS_UART_oId oId, apUART_sConfigFIFOs *pConfig)
{
    /* Define and set up pointer to state - pState */
    UART_sStateStruct * CONST pState = apSTATE_GET(UART, oId);
    
    /* Define and set up pointer to base address - pBase */
    UART_sPort * CONST pBase = pState->pBaseAddress;

#if !apOS_NO_STATIC_STATE
    apASSERT(oId < apOS_UART_MAXIMUM);
#endif

#if (apUART_VERSION == 11)
    apBIT_SET(pBase->FifoSelect, UART_RECV_INT_LEVEL,  pConfig->eReceiveFIFOLevel);
    apBIT_SET(pBase->FifoSelect, UART_TRANS_INT_LEVEL, pConfig->eTransmitFIFOLevel);
    return apERR_NONE;
#else
    IGNORE(pConfig);
    IGNORE (pBase);
    return apERR_UNSUPPORTED;
#endif
}

/*====================================================================*/
PUBLIC apError apUART_FIFOConfigGet(apOS_UART_oId oId, apUART_sConfigFIFOs *pConfig)
{
    /* Define and set up pointer to state - pState */
    UART_sStateStruct * CONST pState = apSTATE_GET(UART, oId);
    
    /* Define and set up pointer to base address - pBase */
    UART_sPort * CONST pBase = pState->pBaseAddress;

#if !apOS_NO_STATIC_STATE
    apASSERT(oId < apOS_UART_MAXIMUM);
#endif

#if (apUART_VERSION == 11)
    pConfig->eReceiveFIFOLevel  = (apUART_eFIFOLevelSelect) apBIT_GET(pBase->FifoSelect, UART_RECV_INT_LEVEL);
    pConfig->eTransmitFIFOLevel = (apUART_eFIFOLevelSelect) apBIT_GET(pBase->FifoSelect, UART_TRANS_INT_LEVEL);
    return apERR_NONE;
#else
    IGNORE(pConfig);
    IGNORE (pBase);
    return apERR_UNSUPPORTED;
#endif
}

/*====================================================================*/
PUBLIC void apUART_DataConfigSet(apOS_UART_oId oId, apUART_sConfigData *pConfig)
{
    /* Define and set up pointer to state - pState */
    UART_sStateStruct * CONST pState = apSTATE_GET(UART, oId);
    
    /* Define and set up pointer to base address - pBase */
    UART_sPort * CONST pBase = pState->pBaseAddress;

#if !apOS_NO_STATIC_STATE
    apASSERT(oId < apOS_UART_MAXIMUM);
#endif

    apBIT_SET(pBase->LineCon_H, UART_WORD_LENGTH,   pConfig->eWordLen);
    apBIT_SET(pBase->LineCon_H, UART_TWO_STOP_BITS, pConfig->eStopBits);
    apBIT_SET(pBase->LineCon_H, UART_PARITY_SELECT, pConfig->eParitySelect);
#if (apUART_VERSION == 11)
    apBIT_SET(pBase->LineCon_H, UART_STICK_PARITY,  pConfig->eStickParity);
    apBIT_SET(pBase->Control,   UART_HWFLOW_ENABLE, pConfig->eHWFlowSelect);    
#endif
}

/*====================================================================*/
PUBLIC void apUART_DataConfigGet(apOS_UART_oId oId, apUART_sConfigData *pConfig)
{
    /* Define and set up pointer to state - pState */
    UART_sStateStruct * CONST pState = apSTATE_GET(UART, oId);
    
    /* Define and set up pointer to base address - pBase */
    UART_sPort * CONST pBase = pState->pBaseAddress;

#if !apOS_NO_STATIC_STATE
    apASSERT(oId < apOS_UART_MAXIMUM);
#endif

    pConfig->eWordLen      = (apUART_eWordLength) apBIT_GET(pBase->LineCon_H, UART_WORD_LENGTH);
    pConfig->eStopBits     = (apUART_eStopBits) apBIT_GET(pBase->LineCon_H, UART_TWO_STOP_BITS);
    pConfig->eParitySelect = (apUART_eParitySelect) apBIT_GET(pBase->LineCon_H, UART_PARITY_SELECT);
#if (apUART_VERSION == 11)
    pConfig->eStickParity  = (apUART_eStickParityEnable) apBIT_GET(pBase->LineCon_H, UART_STICK_PARITY);
    pConfig->eHWFlowSelect = (apUART_eHWFlowSelect) apBIT_GET(pBase->Control, UART_HWFLOW_ENABLE);
#endif
}

/*====================================================================*/
PUBLIC apError apUART_PowerConfigSet(apOS_UART_oId oId, apUART_sConfigPower *pConfig)
{
#if (apUART_VERSION != apUART_VERS_AP)
    UWORD32 Divisor;
#endif

    /* Define and set up pointer to state - pState */
    UART_sStateStruct * CONST pState = apSTATE_GET(UART, oId);
    
    /* Define and set up pointer to base address - pBase */
    UART_sPort * CONST pBase = pState->pBaseAddress;

#if !apOS_NO_STATIC_STATE
    apASSERT(oId < apOS_UART_MAXIMUM);
#endif

#if (apUART_VERSION == apUART_VERS_AP)
    IGNORE (pBase);
    IGNORE (pConfig);
    return apERR_UNSUPPORTED;
#else    
    apBIT_SET(pBase->Control, UART_LOW_POWER_MODE, pConfig->eLowPowerMode);
    
 #if (apUART_VERSION == 11)
    Divisor = (UWORD32) ((pState->ClockFrequency << 4) / pConfig->LowPowerBaud16);
 #else /*(apUART_VERSION == 10)*/
    Divisor = (UWORD32) ((pState->ClockFrequency << 4) / pConfig->LowPowerBaud16) - 1;
 #endif

    apBIT_SET(pBase->LowPower, UART_LP_DIVISOR, Divisor);
    return apERR_NONE;
#endif
}

/*====================================================================*/
PUBLIC apError apUART_PowerConfigGet(apOS_UART_oId oId, apUART_sConfigPower *pConfig)
{
#if (apUART_VERSION != apUART_VERS_AP)
    UWORD32 Divisor;
#endif

    /* Define and set up pointer to state - pState */
    UART_sStateStruct * CONST pState = apSTATE_GET(UART, oId);
    
    /* Define and set up pointer to base address - pBase */
    UART_sPort * CONST pBase = pState->pBaseAddress;

#if !apOS_NO_STATIC_STATE
    apASSERT(oId < apOS_UART_MAXIMUM);
#endif

#if (apUART_VERSION == apUART_VERS_AP)
    IGNORE (pBase);
    IGNORE (pConfig);
    return apERR_UNSUPPORTED;
#else    
    pConfig->eLowPowerMode   = (apUART_eLowPowerMode) apBIT_GET(pBase->Control, UART_LOW_POWER_MODE);
    Divisor = apBIT_GET(pBase->LowPower, UART_LP_DIVISOR);
    if(Divisor == 0)
    {
        pConfig->LowPowerBaud16 = 0;
    }
    else
    {
 #if (apUART_VERSION == 11)
        pConfig->LowPowerBaud16 = ((pState->ClockFrequency << 4) / Divisor);
 #else
        pConfig->LowPowerBaud16 = ((pState->ClockFrequency << 4) / (Divisor + 1));
 #endif
    }
    return apERR_NONE;
#endif
}

/*====================================================================*/
PUBLIC void apUART_IRConfigSet(apOS_UART_oId oId, apUART_sConfigIR *pConfig)
{
    /* Define and set up pointer to state - pState */
    UART_sStateStruct * CONST pState = apSTATE_GET(UART, oId);
    
    /* Define and set up pointer to base address - pBase */
    UART_sPort * CONST pBase = pState->pBaseAddress;

#if !apOS_NO_STATIC_STATE
    apASSERT(oId < apOS_UART_MAXIMUM);
#endif

    apBIT_SET(pBase->Control, UART_LOOP_BACK, pConfig->eLoopBackEnable);

#if (apUART_VERSION != apUART_VERS_AP)
    /* The UART on the integrator does not have a test register
     * as there is no IR support.
     * The following is used when loopback testing the SIR
     * to override the normal half-duplex operation
     */
    if ((pConfig->eLoopBackEnable == apUART_LOOPBACK_ENABLED) &&
             (pConfig->eSIREnable == apUART_SIR_ENABLED))
    {
        apBIT_SET(pBase->SIRTest, UART_SIR_TEST, 1);
    }
    else
    {
        apBIT_SET(pBase->SIRTest, UART_SIR_TEST, 0);
    }
    apBIT_SET(pBase->Control, UART_SIR_ENABLE, pConfig->eSIREnable);
#endif

}

/*====================================================================*/
PUBLIC void apUART_IRConfigGet(apOS_UART_oId oId, apUART_sConfigIR *pConfig)
{
    /* Define and set up pointer to state - pState */
    UART_sStateStruct * CONST pState = apSTATE_GET(UART, oId);
    
    /* Define and set up pointer to base address - pBase */
    UART_sPort * CONST pBase = pState->pBaseAddress;

#if !apOS_NO_STATIC_STATE
    apASSERT(oId < apOS_UART_MAXIMUM);
#endif

    pConfig->eLoopBackEnable = (apUART_eLoopBackEnable) apBIT_GET(pBase->Control, UART_LOOP_BACK);
    pConfig->eSIREnable      = (apUART_eSIREnable) apBIT_GET(pBase->Control, UART_SIR_ENABLE);
}

/*====================================================================*/
PUBLIC apError apUART_DCDConfigSet(apOS_UART_oId oId, apUART_eDCDEnable eConfig)
{
    /* Define and set up pointer to state - pState */
    UART_sStateStruct * CONST pState = apSTATE_GET(UART, oId);
    
    /* Define and set up pointer to base address - pBase */
    UART_sPort * CONST pBase = pState->pBaseAddress;

#if !apOS_NO_STATIC_STATE
    apASSERT(oId < apOS_UART_MAXIMUM);
#endif

#if (apUART_VERSION == 11)
    apBIT_SET(pBase->Control, UART_OUT1, eConfig);
    return apERR_NONE;
#else
    IGNORE (pBase);
    IGNORE (eConfig);
    return apERR_UNSUPPORTED;
#endif
}

/*====================================================================*/
PUBLIC apError apUART_DCDConfigGet(apOS_UART_oId oId, apUART_eDCDEnable *pConfig)
{
    /* Define and set up pointer to state - pState */
    UART_sStateStruct * CONST pState = apSTATE_GET(UART, oId);
    
    /* Define and set up pointer to base address - pBase */
    UART_sPort * CONST pBase = pState->pBaseAddress;

#if !apOS_NO_STATIC_STATE
    apASSERT(oId < apOS_UART_MAXIMUM);
#endif

#if (apUART_VERSION == 11)
    *pConfig = (apUART_eDCDEnable) apBIT_GET(pBase->Control, UART_OUT1);
    return apERR_NONE;
#else
    IGNORE (pBase);
    IGNORE (pConfig);
    return apERR_UNSUPPORTED;
#endif
}

/*====================================================================*/
PUBLIC apError apUART_RIConfigSet(apOS_UART_oId oId, apUART_eRIEnable eConfig)
{
    /* Define and set up pointer to state - pState */
    UART_sStateStruct * CONST pState = apSTATE_GET(UART, oId);
    
    /* Define and set up pointer to base address - pBase */
    UART_sPort * CONST pBase = pState->pBaseAddress;

#if !apOS_NO_STATIC_STATE
    apASSERT(oId < apOS_UART_MAXIMUM);
#endif

#if (apUART_VERSION == 11)
    apBIT_SET(pBase->Control, UART_OUT2, eConfig);
    return apERR_NONE;
#else 
    IGNORE (pBase);
    IGNORE (eConfig);
    return apERR_UNSUPPORTED;
#endif
}

/*====================================================================*/
PUBLIC apError apUART_RIConfigGet(apOS_UART_oId oId, apUART_eRIEnable *pConfig)
{
    /* Define and set up pointer to state - pState */
    UART_sStateStruct * CONST pState = apSTATE_GET(UART, oId);
    
    /* Define and set up pointer to base address - pBase */
    UART_sPort * CONST pBase = pState->pBaseAddress;

#if !apOS_NO_STATIC_STATE
    apASSERT(oId < apOS_UART_MAXIMUM);
#endif

#if (apUART_VERSION == 11)
    *pConfig = (apUART_eRIEnable) apBIT_GET(pBase->Control, UART_OUT2);
    return apERR_NONE;
#else
    IGNORE (pBase);
    IGNORE (pConfig);
    return apERR_UNSUPPORTED;
#endif

}

/*====================================================================*/
PUBLIC apError apUART_RTSConfigSet(apOS_UART_oId oId, apUART_eRTSEnable eConfig)
{
    /* Define and set up pointer to state - pState */
    UART_sStateStruct * CONST pState = apSTATE_GET(UART, oId);
    
    /* Define and set up pointer to base address - pBase */
    UART_sPort * CONST pBase = pState->pBaseAddress;

#if !apOS_NO_STATIC_STATE
    apASSERT(oId < apOS_UART_MAXIMUM);
#endif

#if (apUART_VERSION == 11)
    apBIT_SET(pBase->Control, UART_REQUEST_SEND, eConfig);
    return apERR_NONE;
#else
    IGNORE (pBase);
    IGNORE (eConfig);
    return apERR_UNSUPPORTED;
#endif
}

/*====================================================================*/
PUBLIC apError apUART_RTSConfigGet(apOS_UART_oId oId, apUART_eRTSEnable *pConfig)
{
    /* Define and set up pointer to state - pState */
    UART_sStateStruct * CONST pState = apSTATE_GET(UART, oId);
    
    /* Define and set up pointer to base address - pBase */
    UART_sPort * CONST pBase = pState->pBaseAddress;

#if !apOS_NO_STATIC_STATE
    apASSERT(oId < apOS_UART_MAXIMUM);
#endif

#if (apUART_VERSION == 11)
    *pConfig = (apUART_eRTSEnable) apBIT_GET(pBase->Control, UART_REQUEST_SEND);
    return apERR_NONE;
#else
    IGNORE (pBase);
    IGNORE (pConfig);
    return apERR_UNSUPPORTED;
#endif
}

/*====================================================================*/
PUBLIC apError apUART_DTRConfigSet(apOS_UART_oId oId, apUART_eDTREnable eConfig)
{
    /* Define and set up pointer to state - pState */
    UART_sStateStruct * CONST pState = apSTATE_GET(UART, oId);
    
    /* Define and set up pointer to base address - pBase */
    UART_sPort * CONST pBase = pState->pBaseAddress;

#if !apOS_NO_STATIC_STATE
    apASSERT(oId < apOS_UART_MAXIMUM);
#endif

#if (apUART_VERSION == 11)
    apBIT_SET(pBase->Control, UART_TRANSMIT_READY, eConfig);
    return apERR_NONE;
#else
    IGNORE (pBase);
    IGNORE (eConfig);
    return apERR_UNSUPPORTED;
#endif
}

/*====================================================================*/
PUBLIC apError apUART_DTRConfigGet(apOS_UART_oId oId, apUART_eDTREnable *pConfig)
{
    /* Define and set up pointer to state - pState */
    UART_sStateStruct * CONST pState = apSTATE_GET(UART, oId);
    
    /* Define and set up pointer to base address - pBase */
    UART_sPort * CONST pBase = pState->pBaseAddress;

#if !apOS_NO_STATIC_STATE
    apASSERT(oId < apOS_UART_MAXIMUM);
#endif

#if (apUART_VERSION == 11)
    *pConfig = (apUART_eDTREnable) apBIT_GET(pBase->Control, UART_TRANSMIT_READY);
    return apERR_NONE;
#else
    IGNORE (pBase);
    IGNORE (pConfig);
    return apERR_UNSUPPORTED;
#endif
}

/*====================================================================*/
PUBLIC apError apUART_ModemIntSet(apOS_UART_oId oId, UWORD32 Modemmask)
{
    /* Define and set up pointer to state - pState */
    UART_sStateStruct * CONST pState = apSTATE_GET(UART, oId);
    
    /* Define and set up pointer to base address - pBase */
    UART_sPort * CONST pBase = pState->pBaseAddress;

#if !apOS_NO_STATIC_STATE
    apASSERT(oId < apOS_UART_MAXIMUM);
#endif
    
#if ((apUART_VERSION == apUART_VERS_AP) || (apUART_VERSION == 10))
    if ((Modemmask != apUART_MODEM_INT_DISABLE) && (Modemmask != apUART_MODEM_INT_ENABLE))
    {
        return apERR_UNSUPPORTED;
    }
    else
    {
        if (Modemmask == apUART_MODEM_INT_ENABLE)
        {
            apBIT_SET(UART_INTMASK(), UART_MODEM_INTENAB, 1);
        }
        else
        {
            apBIT_SET(UART_INTMASK(), UART_MODEM_INTENAB, 0);
        }
        return apERR_NONE; 
    }
#else
    /*check no other bits are set*/
    apASSERT(!(Modemmask >> bwUART_MODEM_INTENAB));
    apBIT_SET(UART_INTMASK(), UART_MODEM_INTENAB, Modemmask);
    return apERR_NONE;
#endif
}

/*====================================================================*/
PUBLIC void apUART_ModemIntGet(apOS_UART_oId oId, UWORD32 *pModemmask)
{
    /* Define and set up pointer to state - pState */
    UART_sStateStruct * CONST pState = apSTATE_GET(UART, oId);
    
    /* Define and set up pointer to base address - pBase */
    UART_sPort * CONST pBase = pState->pBaseAddress;

#if !apOS_NO_STATIC_STATE
    apASSERT(oId < apOS_UART_MAXIMUM);
#endif
#if ((apUART_VERSION == apUART_VERS_AP) || (apUART_VERSION == 10))
    if apBIT_GET(UART_INTMASK(), UART_MODEM_INTENAB)
    {
        *pModemmask = apUART_MODEM_INT_ENABLE;
    }
    else
    {
        *pModemmask = apUART_MODEM_INT_DISABLE;
    }
#else
    *pModemmask = apBIT_GET(UART_INTMASK(), UART_MODEM_INTENAB);
#endif
}

/*====================================================================*/
PUBLIC UWORD32 apUART_ModemStatusGet(apOS_UART_oId oId)
{
    /* Define and set up pointer to state - pState */
    UART_sStateStruct * CONST pState = apSTATE_GET(UART, oId);
    
    /* Define and set up pointer to base address - pBase */
    UART_sPort * CONST pBase = pState->pBaseAddress;

#if !apOS_NO_STATIC_STATE
    apASSERT(oId < apOS_UART_MAXIMUM);
#endif

    return pBase->Flag;
}

/*====================================================================*/
PUBLIC apError apUART_ErrorIntSet(apOS_UART_oId oId, UWORD32 Errormask)
{
    /* Define and set up pointer to state - pState */
    UART_sStateStruct * CONST pState = apSTATE_GET(UART, oId);
    
    /* Define and set up pointer to base address - pBase */
    UART_sPort * CONST pBase = pState->pBaseAddress;

#if !apOS_NO_STATIC_STATE
    apASSERT(oId < apOS_UART_MAXIMUM);
#endif

#if ((apUART_VERSION == apUART_VERS_AP) || (apUART_VERSION == 10))
    IGNORE (pBase);
    IGNORE (Errormask);
    return apERR_UNSUPPORTED;
#else
    /*check no other bits are set*/
    apASSERT(!(Errormask >> bwUART_ERROR_INTENAB));
    apBIT_SET(UART_INTMASK(), UART_ERROR_INTENAB, Errormask);
    return apERR_NONE;
#endif
}

/*====================================================================*/
PUBLIC apError apUART_ErrorIntGet(apOS_UART_oId oId, UWORD32 *pErrormask)
{
    /* Define and set up pointer to state - pState */
    UART_sStateStruct * CONST pState = apSTATE_GET(UART, oId);
    
    /* Define and set up pointer to base address - pBase */
    UART_sPort * CONST pBase = pState->pBaseAddress;

#if !apOS_NO_STATIC_STATE
    apASSERT(oId < apOS_UART_MAXIMUM);
#endif

#if ((apUART_VERSION == apUART_VERS_AP) || (apUART_VERSION == 10))
    IGNORE (pBase);
    IGNORE (pErrormask);
    return apERR_UNSUPPORTED;
#else
    *pErrormask = apBIT_GET(UART_INTMASK(), UART_ERROR_INTENAB);
    return apERR_NONE;
#endif
}

/*====================================================================*/
PUBLIC void apUART_TxIntEnable(apOS_UART_oId oId)
{
    /* Define and set up pointer to state - pState */
    UART_sStateStruct * CONST pState = apSTATE_GET(UART, oId);
    
    /* Define and set up pointer to base address - pBase */
    UART_sPort * CONST pBase = pState->pBaseAddress;

#if !apOS_NO_STATIC_STATE
    apASSERT(oId < apOS_UART_MAXIMUM);
#endif

    UART_INTENABLE(TRANSMIT, ENABLED);
}

/*====================================================================*/
PUBLIC void apUART_TxIntDisable(apOS_UART_oId oId)
{
    /* Define and set up pointer to state - pState */
    UART_sStateStruct * CONST pState = apSTATE_GET(UART, oId);
    
    /* Define and set up pointer to base address - pBase */
    UART_sPort * CONST pBase = pState->pBaseAddress;

#if !apOS_NO_STATIC_STATE
    apASSERT(oId < apOS_UART_MAXIMUM);
#endif

    UART_INTENABLE(TRANSMIT, DISABLED);
}

/*====================================================================*/
PUBLIC void apUART_RxIntEnable(apOS_UART_oId oId)
{
    /* Define and set up pointer to state - pState */
    UART_sStateStruct * CONST pState = apSTATE_GET(UART, oId);
    
    /* Define and set up pointer to base address - pBase */
    UART_sPort * CONST pBase = pState->pBaseAddress;

#if !apOS_NO_STATIC_STATE
    apASSERT(oId < apOS_UART_MAXIMUM);
#endif

    UART_INTMASK() = ((UWORD32) (UART_INTMASK()) |
                      (UWORD32) (apBIT_MASK(UART_RECEIVE_INTENAB) |
                                 apBIT_MASK(UART_TIMEOUT_INTENAB)));
}

/*====================================================================*/
PUBLIC void apUART_RxIntDisable(apOS_UART_oId oId)
{
    /* Define and set up pointer to state - pState */
    UART_sStateStruct * CONST pState = apSTATE_GET(UART, oId);
    
    /* Define and set up pointer to base address - pBase */
    UART_sPort * CONST pBase = pState->pBaseAddress;

#if !apOS_NO_STATIC_STATE
    apASSERT(oId < apOS_UART_MAXIMUM);
#endif

    UART_INTMASK() = ((UWORD32) (UART_INTMASK()) &
                      (UWORD32)~(apBIT_MASK(UART_RECEIVE_INTENAB) |
                                 apBIT_MASK(UART_TIMEOUT_INTENAB)));
}

/*====================================================================*/
PUBLIC void apUART_ErrorStatusClear(apOS_UART_oId oId)
{
    /* Define and set up pointer to state - pState */
    UART_sStateStruct * CONST pState = apSTATE_GET(UART, oId);
    
    /* Define and set up pointer to base address - pBase */
    UART_sPort * CONST pBase = pState->pBaseAddress;

#if !apOS_NO_STATIC_STATE
    apASSERT(oId < apOS_UART_MAXIMUM);
#endif

    pBase->StatusClear = 0;
}

/*====================================================================*/
PUBLIC UWORD32 apUART_ErrorStatusGet(apOS_UART_oId oId)
{
    /* Define and set up pointer to state - pState */
    UART_sStateStruct * CONST pState = apSTATE_GET(UART, oId);
    
    /* Define and set up pointer to base address - pBase */
    UART_sPort * CONST pBase = pState->pBaseAddress;

#if !apOS_NO_STATIC_STATE
    apASSERT(oId < apOS_UART_MAXIMUM);
#endif

    return pBase->StatusClear;
}
