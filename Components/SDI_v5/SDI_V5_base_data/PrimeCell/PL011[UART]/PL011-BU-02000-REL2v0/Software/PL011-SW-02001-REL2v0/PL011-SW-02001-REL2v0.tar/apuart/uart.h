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
 * File:     uart.h,v
 * Revision: 1.29
 * ----------------------------------------------------------------
 * 
 *  ----------------------------------------
 *  Version and Release Control Information:
 * 
 *  File Name              : uart.h.rca
 *  File Revision          : 1.2
 * 
 *  Release Information    : PrimeCell(TM)-PL011-REL2v0
 *  ----------------------------------------
 *
 * Private header for parallel port interface
 */

#ifndef UART_H
#define UART_H

#include "../apcommon/aptypes.h"
#include "../apos/apos.h"

#ifdef __cplusplus
extern "C" {  /* allow C++ to use these headers */
#endif /* __cplusplus */


/*
 * Data read register UARTDR
 */
#define bwUART_DATA                    8   /* The actual data byte */
#define bsUART_DATA                    0

/* Not used, left in for completeness */
//#define bwUART_ERR_FRAME               1   /* Framing error */
//#define bwUART_ERR_PARITY              1   /* Parity error */
//#define bwUART_ERR_BREAK               1   /* Break error */
//#define bwUART_ERR_OVERRUN             1   /* Overrun error */

//#define bsUART_ERR_FRAME               8
//#define bsUART_ERR_PARITY              9
//#define bsUART_ERR_BREAK              10
//#define bsUART_ERR_OVERRUN            11
/* End of not used */


/*
 * Receive status / Error clear register UARTRSR/UARTECR
 */

/* Not used, left in for completeness */
//#define bwUART_STAT_FRAME              1   /* Framing error */
//#define bwUART_STAT_PARITY             1   /* Parity error */
//#define bwUART_STAT_BREAK              1   /* Break error */
//#define bwUART_STAT_OVERRUN            1   /* Overrun error */

//#define bsUART_STAT_FRAME              0
//#define bsUART_STAT_PARITY             1
//#define bsUART_STAT_BREAK              2
//#define bsUART_STAT_OVERRUN            3
/* End of not used */

/*
 * Flags register UARTFR
 */
/* Not used, left in for completeness */
//#define bwUART_CLEAR_TO_SEND           1   /* Clear to send */
//#define bwUART_READY                   1   /* Data set ready */
//#define bwUART_CARRIER                 1   /* Data carrier detect */
//#define bwUART_BUSY                    1   /* UART busy */
/* End of not used */

#define bwUART_RECEIVE_EMPTY           1   /* Receive FIFO empty */
#define bwUART_TRANSMIT_FULL           1   /* Transmit FIFO full */
//#define bwUART_RECEIVE_FULL            1   /* Receive FIFO full */
#define bwUART_TRANSMIT_EMPTY          1   /* Transmit FIFO empty */
//#define bwUART_RING                    1   /* Complement of UART ring indicator modem status input */

/* Not used, left in for completeness */
//#define bsUART_CLEAR_TO_SEND           0
//#define bsUART_READY                   1
//#define bsUART_CARRIER                 2
//#define bsUART_BUSY                    3
/* End of not used */

#define bsUART_RECEIVE_EMPTY           4
#define bsUART_TRANSMIT_FULL           5
//#define bsUART_RECEIVE_FULL            6  /* Not used, left in for completeness */
#define bsUART_TRANSMIT_EMPTY          7
//#define bsUART_RING                    8  /* Not used, left in for completeness */


/*
 * Low power divisor register UARTILPR
 */
#if (apUART_VERSION != apUART_VERS_AP)
#define bwUART_LP_DIVISOR              8   /* IrDA low power divisor */

#define bsUART_LP_DIVISOR              0
#endif

/*
 * Baud rate divisor register
 */
#if ((apUART_VERSION == apUART_VERS_AP) || (apUART_VERSION == 10))
#define bwUART_BAUD_DIVISOR            8   /* Old primecell Baud rate divisor */
#else
#define bwUART_BAUD_DIVISOR           16   /* PL_011 Baud rate divisor */
#endif
#define bsUART_BAUD_DIVISOR            0


/*
 * Line control register UARTLCR_H
 */
#define bwUART_SEND_BREAK              1   /* Send break */
#define bwUART_PARITY_SELECT           2   /* Even, odd or no parity checking */
#define bwUART_TWO_STOP_BITS           1   /* Transmit two stop bits at end of frame */
#define bwUART_FIFO_ENABLE             1   /* FIFO enable */
#define bwUART_WORD_LENGTH             2   /* Word length */
#if (apUART_VERSION == 11)
#define bwUART_STICK_PARITY            1   /* Stick parity */
#endif

#define bsUART_SEND_BREAK              0
#define bsUART_PARITY_SELECT           1
#define bsUART_TWO_STOP_BITS           3
#define bsUART_FIFO_ENABLE             4
#define bsUART_WORD_LENGTH             5
#if (apUART_VERSION == 11)
#define bsUART_STICK_PARITY            7
#endif

/*
 * Control register UARTCR
 */
#define bwUART_ENABLE                  1   /* UART master enable */
#define bwUART_SIR_ENABLE              1   /* SIR enable     - Not Used on Integrator */
#define bwUART_LOW_POWER_MODE          1   /* IrDA encoding low power mode - Not Used on Integrator */
#define bwUART_LOOP_BACK               1   /* Loop back enable */

#define bsUART_ENABLE                  0
#define bsUART_SIR_ENABLE              1
#define bsUART_LOW_POWER_MODE          2
#define bsUART_LOOP_BACK               7


#if (apUART_VERSION == 11)
#define bwUART_CONTROL_LOWBITS         3   /* Used to allow rapid setting of control register */
#define bwUART_CONTROL_HIGHBITS        9   /* without disturbing reserved bits */
#define bwUART_TRANSMIT_ENABLE         1   /* Transmit enable */
#define bwUART_RECEIVE_ENABLE          1   /* Receive enable */
#define bwUART_TRANSMIT_READY          1   /* Data transmit ready */
#define bwUART_REQUEST_SEND            1   /* Request to Send */
#define bwUART_OUT1                    1   /* Complement of UART Out1 modem status output */
#define bwUART_OUT2                    1   /* Complement of UART Out2 modem status output */
#define bwUART_HWFLOW_ENABLE           2   /* HW flow control enable/disable */

#define bsUART_CONTROL_LOWBITS         0
#define bsUART_CONTROL_HIGHBITS        7
#define bsUART_TRANSMIT_ENABLE         8
#define bsUART_RECEIVE_ENABLE          9
#define bsUART_TRANSMIT_READY         10
#define bsUART_REQUEST_SEND           11
#define bsUART_OUT1                   12
#define bsUART_OUT2                   13
#define bsUART_HWFLOW_ENABLE          14
#endif


/*
 * Interrupt identification / clear register UARTIIR/UARTICR
 */
#if ((apUART_VERSION == apUART_VERS_AP) || (apUART_VERSION == 10))
#define bwUART_MODEM                   1   /* Modem interrupt */
#define bwUART_RECEIVE                 1   /* Receive interrupt */
#define bwUART_TRANSMIT                1   /* Transmit interrupt */
#define bwUART_TIMEOUT                 1   /* Receive timeout interrupt */
#define bwUART_ALL                     4   /* All interrupts */

#define bsUART_MODEM                   0
#define bsUART_RECEIVE                 1
#define bsUART_TRANSMIT                2
#define bsUART_TIMEOUT                 3
#define bsUART_ALL                     0

#else /*if (apUART_VERSION == 11)*/
#define bwUART_MODEMRI                 1   /* Modem RI interrupt */
#define bwUART_MODEMCTS                1   /* Modem CTS interrupt */
#define bwUART_MODEMDCD                1   /* Modem DCD interrupt */
#define bwUART_MODEMDSR                1   /* Modem DSR interrupt */
#define bwUART_RECEIVE                 1   /* Receive interrupt */
#define bwUART_TRANSMIT                1   /* Transmit interrupt */
#define bwUART_TIMEOUT                 1   /* Receive timeout interrupt */
#define bwUART_FRAME                   1   /* Framing error */
#define bwUART_PARITY                  1   /* Parity error */
#define bwUART_BREAK                   1   /* Break error */
#define bwUART_OVERRUN                 1   /* Overrun error */

#define bwUART_MODEM                   4   /* All Modem interrupts */

/* Not used, left in for completeness */
//#define bwUART_ERROR                   4   /* All Error interrupts */

#define bwUART_ALL                    11   /* All interrupts */

#define bsUART_MODEMRI                 0
#define bsUART_MODEMCTS                1
#define bsUART_MODEMDCD                2
#define bsUART_MODEMDSR                3
#define bsUART_RECEIVE                 4
#define bsUART_TRANSMIT                5
#define bsUART_TIMEOUT                 6
#define bsUART_FRAME                   7
#define bsUART_PARITY                  8
#define bsUART_BREAK                   9
#define bsUART_OVERRUN                10

#define bsUART_MODEM                   0

/* Not used, left in for completeness */
//#define bsUART_ERROR                   7

#define bsUART_ALL                     0

#endif

/* Interrupt Mask */
#if ((apUART_VERSION == apUART_VERS_AP) || (apUART_VERSION == 10))
/* Held in control register UARTCR */
#define bwUART_MODEM_INTENAB           1   /* Modem interrupt enable */
#define bwUART_RECEIVE_INTENAB         1   /* Receive interrupt enable */
#define bwUART_TRANSMIT_INTENAB        1   /* Transmit interrupt enable */
#define bwUART_TIMEOUT_INTENAB         1   /* Receive timeout interrupt enable */
#define bwUART_ALL_INTENAB             4   /* All interrupts */

#define bsUART_MODEM_INTENAB           3
#define bsUART_RECEIVE_INTENAB         4
#define bsUART_TRANSMIT_INTENAB        5
#define bsUART_TIMEOUT_INTENAB         6
#define bsUART_ALL_INTENAB             3

/* Used by INTTEST within ISR */
#define UART_INTBIT_RECEIVE            0x2
#define UART_INTBIT_TRANSMIT           0x4
#define UART_INTBIT_TIMEOUT            0x8
#define UART_INTBIT_MODEM              0x1

#else /* PL_011 */
/* PL_011 has seperate mask set/clear register UARTIMSC  and status register UARTMIS 
 * and clear register UARTICR */
#define bwUART_MODEM_INTENAB           4   /* Modem interrupt enable */
#define bwUART_RECEIVE_INTENAB         1   /* Receive interrupt enable */
#define bwUART_TRANSMIT_INTENAB        1   /* Transmit interrupt enable */
#define bwUART_TIMEOUT_INTENAB         1   /* Receive timeout interrupt enable */
#define bwUART_ERROR_INTENAB           4
#define bwUART_FRAME_INTENAB           1   /* Framing error */
#define bwUART_PARITY_INTENAB          1   /* Parity error */
#define bwUART_BREAK_INTENAB           1   /* Break error */
#define bwUART_OVERRUN_INTENAB         1   /* Overrun error */
#define bwUART_ALL_INTENAB            11   /* All interrupts */


#define bsUART_MODEM_INTENAB           0
#define bsUART_RECEIVE_INTENAB         4
#define bsUART_TRANSMIT_INTENAB        5
#define bsUART_TIMEOUT_INTENAB         6
#define bsUART_ERROR_INTENAB           7
#define bsUART_FRAME_INTENAB           7
#define bsUART_PARITY_INTENAB          8
#define bsUART_BREAK_INTENAB           9
#define bsUART_OVERRUN_INTENAB        10
#define bsUART_ALL_INTENAB             0

/* Used by INTTEST within ISR */
#define UART_INTBIT_RECEIVE            0x10
#define UART_INTBIT_TRANSMIT           0x20
#define UART_INTBIT_TIMEOUT            0x40
#define UART_INTBIT_MODEM              0xF
#define UART_INTBIT_MODEMRI            0x1
#define UART_INTBIT_MODEMCTS           0x2
#define UART_INTBIT_MODEMDCD           0x4
#define UART_INTBIT_MODEMDSR           0x8
#define UART_INTBIT_ERROR              0x780
#define UART_INTBIT_FRAME              0x80
#define UART_INTBIT_PARITY             0x100
#define UART_INTBIT_BREAK              0x200
#define UART_INTBIT_OVERRUN            0x400

#endif

/*
 * Descripton:
 * Bit shifts and widths for DMA Control Register UARTDMACR
 */
#if defined(apUART_VERSION) && apUART_VERSION == 11
#define bsUART_DMA_ON_ERROR_DISABLE        ( (WORD32) 2)
#define bwUART_DMA_ON_ERROR_DISABLE        ( (WORD32) 1)
#define bsUART_DMA_TRANSMIT_ENABLE        ( (WORD32) 1)
#define bwUART_DMA_TRANSMIT_ENABLE        ( (WORD32) 1)
#define bsUART_DMA_RECEIVE_ENABLE         ( (WORD32) 0)
#define bwUART_DMA_RECEIVE_ENABLE         ( (WORD32) 1)
#endif

/* Test Register specific for SIR loopback enabling */
#define bwUART_SIR_TEST                1

#if (apUART_VERSION == 11)
  #define bsUART_SIR_TEST                2
#else /*(apUART_VERSION == 10)*/
  #define bsUART_SIR_TEST                1
#endif

/*
 * FIFO select register UARTIFLS
 */
#if (apUART_VERSION == 11)
#define bwUART_TRANS_INT_LEVEL        3   /* Interrupt level for Transmit FIFO */
#define bwUART_RECV_INT_LEVEL         3   /* Interrupt level for Receive FIFO */


#define bsUART_TRANS_INT_LEVEL        0
#define bsUART_RECV_INT_LEVEL         3
#endif


/*
 * Description:
 * UART enable state control.
 */
typedef enum UART_xEnable
{
    UART_DISABLED,    // UART disabled
    UART_ENABLED      // UART enabled
}
UART_eEnable;


/*
 * Description:
 * FIFO needs servicing. It is either full or empty.
 */
typedef enum UART_xFIFOService
{
    UART_FIFO_OKAY,     // FIFO needs no attention
    UART_FIFO_SERVICE   // FIFO needs servicing
}
UART_eFIFOService;


/*
 * Description:
 * FIFOs enabled
 */
typedef enum UART_xFIFOEnable
{
    UART_FIFO_DISABLE,  // FIFOs disabled
    UART_FIFO_ENABLE    // FIFOs enabled
}
UART_eFIFOEnable;


/*
 * Description:
 * UART state
 */
typedef enum UART_xFIFOState
{
    UART_STATE_IDLE,     // UART idle
    UART_STATE_RECEIVE,  // UART receiving
    UART_STATE_SEND      // UART sending
}
UART_eFIFOState;


/*
 * Description:
 * Interrupt enable enumerated type.
 */
typedef enum UART_xInterruptEnable
{
    UART_INTERRUPT_DISABLED,                    // Interrupt disabled
    UART_INTERRUPT_ENABLED,                     // Interrupt enabled
    UART_INTERRUPT_ALL = (WORD32) 0xFFFFFFFF   // All Interrupts
}
UART_eInterruptEnable;


/*
 * Memory mapped registers
 */
typedef volatile struct UART_xPort
{
    UWORD32 DataRead;                    // 0x00
    UWORD32 StatusClear;                 // 0x04
#if ((apUART_VERSION == apUART_VERS_AP) || (apUART_VERSION == 10))
    UWORD32 LineCon_H;                   // 0x08
    UWORD32 LineCon_M;                   // 0x0C
    UWORD32 LineCon_L;                   // 0x10
    UWORD32 Control;                     // 0x14
    UWORD32 Flag;                        // 0x18
    UWORD32 Interrupt;                   // 0x1C
//#if (apUART_VERSION == 10)
    UWORD32 LowPower;                    // 0x20
    UWORD32 Reserved6[96];               // 0x24
    UWORD32 SIRTest;                     // 0x84  
//#endif
#else /*(apUART_VERSION == 11)*/
    UWORD32 Reserved1;                   // 0x08
    UWORD32 Reserved2;                   // 0x0C
    UWORD32 Reserved3;                   // 0x10
    UWORD32 Reserved4;                   // 0x14
    UWORD32 Flag;                        // 0x18
    UWORD32 Reserved5;                   // 0x1C
    UWORD32 LowPower;                    // 0x20
    UWORD32 IntBaudDivisor;              // 0x24
    UWORD32 FractBaudDivisor;            // 0x28
    UWORD32 LineCon_H;                   // 0x2C
    UWORD32 Control;                     // 0x30
    UWORD32 FifoSelect;                  // 0x34
    UWORD32 IntMask;                     // 0x38
    UWORD32 IntRaw;                      // 0x3C
    UWORD32 Interrupt;                   // 0x40
    UWORD32 IntClear;                    // 0x44
    UWORD32 DmaCon;                      // 0x48
    UWORD32 Reserved6[13];               // 0x4C
    UWORD32 SIRTest;                     // 0x80
#endif
}
UART_sPort;


/*
 * UART status
 */
typedef volatile struct UART_xStateStruct
{
    UART_sPort *pBaseAddress;
    apUART_rListener rNotifyListener;
    apUART_rCallback rNotifySend;
    apUART_rCallback rNotifyReceive;
    UWORD32 FIFOSize;
    UWORD32 Status;
    UBYTE8  *pDataSend;
    UBYTE8  *pDataReceive;
    UWORD32 RemainSend;
    UWORD32 RemainReceive;
    UWORD32 ClockFrequency;
}
UART_sStateStruct;

/* UART_READY_CODE used for setting default bits in control register in apUART_Initialize
 * Uart disabled, SIR disabled, IrDA low power disabled, loop back disabled
 * PL011 specifically enables transmit and receive enable,
 *  disables DTR, RTS, Out1, Out2 and HW flow control is disabled
 * PL011 sets register halves separately as have write reserved bits in middle of register.
 */

#if ((apUART_VERSION == apUART_VERS_AP) || (apUART_VERSION == 10))
#define UART_READY_CODE 0x0
#else
#define UART_READY_CODE_LOW 0x0
#define UART_READY_CODE_HIGH 0x6 
#endif

/* Default settings for interrupt enable bits - enables all interrupts except transmit
 * Used in apUART_ENABLE
 */
#if ((apUART_VERSION == apUART_VERS_AP) || (apUART_VERSION == 10))
#define UART_INTERRUPT_READY (UART_INTBIT_MODEM | UART_INTBIT_TIMEOUT | UART_INTBIT_RECEIVE) // 0x0B
#else
#define UART_INTERRUPT_READY (UART_INTBIT_ERROR | UART_INTBIT_MODEM | UART_INTBIT_TIMEOUT | UART_INTBIT_RECEIVE) // 0x7DF
#endif

#ifdef __cplusplus
} /* allow C++ to use these headers */
#endif /* __cplusplus */

#endif

