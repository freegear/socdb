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
//  Header:  smt926a_uart.h
//
//  Defines the UART controller register layout associated types and constants.
//
#ifndef __SMT926A_UART_H
#define __SMT926A_UART_H

#if __cplusplus
extern "C" {
#endif

//------------------------------------------------------------------------------
//
//  Type:  SMT926A_UART_REG    
//
//  UART control registers. This register bank is located by the constant
//  SMT926A_BASE_REG_XX_UARTn in the configuration file
//  smt926a_base_reg_cfg.h.
//
#define DEFAULT_SMT926A_HCLK	(399651840 / 4)

typedef struct {
    UINT32 ULCON;                   // line control reg
    UINT32 UCON;                    // control reg
    UINT32 UFCON;                   // FIFO control reg
    UINT32 UMCON;                   // modem control reg
    UINT32 UTRSTAT;                 // tx/rx status reg
    UINT32 UERSTAT;                 // rx error status reg
    UINT32 UFSTAT;                  // FIFO status reg
    UINT32 UMSTAT;                  // modem status reg
    UINT32 UTXH;                    // tx buffer reg
    UINT32 URXH;                    // rx buffer reg
    UINT32 UBRDIV;                  // baud rate divisor

	/* SMT926 UART registers */
	// Inserted by DJKIM 2006/09/27
    UINT32  UARTDR;                         // 0x00 
    UINT32  UARTSR;                         // 0x04
    UINT32  Reserved1;                      // 0x08
    UINT32  Reserved2;                      // 0x0C
    UINT32  Reserved3;                      // 0x10
    UINT32  Reserved4;                      // 0x14
    UINT32  UARTFR;                         // 0x18
    UINT32  Reserved5;                      // 0x1C
    UINT32  UARTILPR;                       // 0x20
    UINT32  UARTIBRD;                       // 0x24
    UINT32  UARTFBRD;                       // 0x28
    UINT32  UARTLCR_H;                      // 0x2C
    UINT32  UARTCR;                         // 0x30
    UINT32  UARTIFLS;                       // 0x34
    UINT32  UARTIMSC;                       // 0x38
    UINT32  UARTRIS;                        // 0x3C
    UINT32  UARTMIS;                        // 0x40
    UINT32  UARTICR;                        // 0x44
    UINT32  UARTDMACR;                      // 0x48

} SMT926A_UART_REG, *PSMT926A_UART_REG;

/////////////////////////////////////////////////////////////////////////////////////////
// SMT926 UART Register mask - Inserted by DJKIM 2006/09/27

// UART_DR register
#define DR_OVERRUN_ERR  	(0x1UL)<<11
#define DR_BREAK_ERR    	(0x1UL)<<10
#define DR_PARITY_ERR   	(0x1UL)<<9
#define DR_FRAMING_ERR  	(0x1UL)<<8
#define DR_DATA             (0xffUL)<<0

// UARTRSR register
#define RSR_OVERUN_ERR  	(0x1UL)<<3
#define RSR_BREAK_ERR  		(0x1UL)<<2
#define RSR_PARITY_ERR  	(0x1UL)<<1
#define RSR_FRAMING_ERR  	(0x1UL)<<0

// UARTFR register
#define RING_INDICATOR  	(0x1UL)<<8
#define TXFIFO_EMPTY    	(0x1UL)<<7
#define RXFIFO_FULL     	(0x1UL)<<6
#define TXFIFO_FULL     	(0x1UL)<<5
#define RXFIFO_EMPTY    	(0x1UL)<<4
#define UART_BUSY       	(0x1UL)<<3
#define CARRIER_DETECT  	(0x1UL)<<2
#define SET_RETRY       	(0x1UL)<<1
#define CLEAR_TO_SEND  		(0x1UL)<<0

// UARTLCR_H register
#define STICK_PAR_SEL   	(0x1UL)<<7
#define WORD_LENGTH     	(0x3UL)<<5
#define EN_FIFO         	(0x1UL)<<4
#define T_STOP_BIT_SEL  	(0x1UL)<<3
#define EVEN_PARITY_SEL 	(0x1UL)<<2
#define PARITY_EN       	(0x1UL)<<1
#define SEND_BREAK      	(0x1UL)<<0

#define WORD_LENGTH_BS      5

// UARTCR register
#define CTS_HW_FLOW 		(0x1UL)<<15
#define RTS_HW_FLOW 		(0x1UL)<<14
#define OUT2                (0x1UL)<<13
#define OUT1                (0x1UL)<<12
#define REQ_TO_SEND 		(0x1UL)<<11
#define DATA_TX_READY   	(0x1UL)<<10
#define RX_EN               (0x1UL)<<9
#define TX_EN               (0x1UL)<<8
#define LOOP_BACK_EN    	(0x1UL)<<7
#define UART_EN         	(0x1UL)<<0

// UARTFLS register
#define RX_INTERRUPT_LEVEL  (0x7UL)<<3
#define TX_INTERRUPT_LEVEL  (0x7UL)<<0

#define RX_INTERRUPT_LEVEL_BS  3

// UARTMSC & RIS & MIS & ICR register
#define OVERRUN_ERR_MASK 	(0x1UL)<<10
#define BREAK_ERR_MASK   	(0x1UL)<<9
#define PARITY_ERR_MASK  	(0x1UL)<<8
#define FRAMING_ERR_MASK 	(0x1UL)<<7
#define RX_TIMEOUT          (0x1UL)<<6
#define TX_INTERRUPT_MASK   (0x1UL)<<5
#define RX_INTERRUPT_MASK   (0x1UL)<<4
#define DSR_INTERRUPT_MASK  (0x1UL)<<3
#define DCD_INTERRUPT_MASK  (0x1UL)<<2
#define CTS_INTERRUPT_MASK  (0x1UL)<<1
#define RI_INTERRUPT_MASK   (0x1UL)<<0


#define SMTUART_INT_RXD (RX_INTERRUPT_MASK)
#define SMTUART_INT_TXD (TX_INTERRUPT_MASK)
#define SMTUART_INT_ERR ((OVERRUN_ERR_MASK) \
                        |(BREAK_ERR_MASK)   \
                        |(PARITY_ERR_MASK)  \
                        |(FRAMING_ERR_MASK))


/////////////////////////////////////////////////////////////////////////////////////////
// SMT926 UART struct definition - Inserted by shkim 2006/09/29

typedef enum {
    UART_BAUD_2400 = 2400,
    UART_BAUD_4800 = 4800,
    UART_BAUD_9600 = 9600,
    UART_BAUD_19200 = 19200,
    UART_BAUD_38400 = 38400,
    UART_BAUD_115200 = 115200
} UART_BAUDRATE;

typedef enum {
    SET_UARTLCR,   // Line control set
    GET_UARTLCR,
    //SET_UARTCR,   // UART Tx/Rx
    //GET_UARTCR,
    SET_UARTIFLS,  // Interrupt level set
    GET_UARTIFLS,
    SET_UARTICR,
    SET_UARTIMSC,
    CLR_UARTIMSC,
    GET_UARTIMSC
} UART_MODE;

typedef enum {
    SEND_BREAK_DISABLE,
    SEND_BREAK_ENABLE
} SEND_BREAK_ENUM;

typedef enum {
    PARITY_DISABLE,
    PARITY_ENABLE
} PARITY_EN_ENUM;

typedef enum {
    ODD_PARITY,
    EVEN_PARITY
} PARITY_SEL_ENUM;

typedef enum {
    ONE_STOP_BIT,
    TWO_STOP_BIT
} STOP_SEL_ENUM;

typedef enum {
    FIFO_DISABLE,
    FIFO_ENABLE
} FIFO_EN_ENUM;

typedef enum {
    STICK_PARITY_DISABLE,
    STICK_PARITY_ENABLE
} STICK_PARITY_EN_ENUM;

typedef enum {
    DATA_5BIT,
    DATA_6BIT,
    DATA_7BIT,
    DATA_8BIT
} WORD_LENGTH_ENUM;

typedef enum {
    SHMT_LOOPBACK,
    SHMT_TRANSMIT,
    SHMT_RECEIVE
} UART_OPERATION;

typedef enum {
    INT_LEVEL_1BY8 = 0,
    INT_LEVEL_1BY4,
    INT_LEVEL_1BY2,
    INT_LEVEL_3BY4,
    INT_LEVEL_7BY8
} UART_COMM_INT_LEVEL;

typedef enum {
    MODEM_RI_INT = 0x1,
    MODEM_CTS_INT = 0x2 ,
    MODEM_DCD_INT = 0x4,
    MODEM_DSR_INT = 0x8,

    RX_INT = 0x10,
    TX_INT = 0x20,
    RX_TIMEOUT_INT = 0x40,
    FRAME_ERR_INT = 0x80,
    PARITY_ERR_INT = 0x100,
    BREAK_ERR_INT = 0x200,
    OVERRUN_ERR_INT = 0x400,

    ALL_INT = 0x7ff
} UART_INT;

typedef struct {
    UINT8 sendBreak;
    UINT8 parityEn;
    UINT8 paritySel;
    UINT8 stopSel;
    UINT8 fifoEn;
    UINT8 stickParitySel;
    UINT8 wordLengh;
} UART_DATA_STRUCT;

typedef struct {
    UART_OPERATION operation;
    UINT8 txIntLevel;
    UINT8 rxIntLevel;
    UINT16 intClear;
    UINT16 intMask;

    UART_DATA_STRUCT lineCtrl;
} UART_STRUCT;
/////////////////////////////////////////////////////////////////////////////////////////
// SMT926 UART common macro - Inserted by shkim 2006/09/29
/*----------------------------------------------------------------------------
                           SHIFT_DN_FROM_MASK

This macro uses the register mask definitions in xxx.h to calculate
how many times a bit value needs to be shifted so that it modifies the correct
bit within a register.

The design is identical to SHIFT_FROM_MASK except that the full name of the
mask is used.  This is needed for use in existing that already take the full
mask name as a parameter.

INPUT:
    x   = MASK

NOTE:   ONLY A MASK DEFINITION CAN BE USE AS AN INPUT FOR THIS MACRO!.
        THIS MACRO PRODUCES NO CODE, IT RETURNS A CONSTANT!.
---------------------------------------------------------------------------*/
#define SHIFT_DN_FROM_MASK(x)     \
            ((x & 0x00000001) ? 0 :    \
            ((x & 0x00000002) ? 1 :    \
            ((x & 0x00000004) ? 2 :    \
            ((x & 0x00000008) ? 3 :    \
            ((x & 0x00000010) ? 4 :    \
            ((x & 0x00000020) ? 5 :    \
            ((x & 0x00000040) ? 6 :    \
            ((x & 0x00000080) ? 7 :    \
            ((x & 0x00000100) ? 8 :    \
            ((x & 0x00000200) ? 9 :    \
            ((x & 0x00000400) ? 10 :   \
            ((x & 0x00000800) ? 11 :   \
            ((x & 0x00001000) ? 12 :   \
            ((x & 0x00002000) ? 13 :   \
            ((x & 0x00004000) ? 14 :   \
            ((x & 0x00008000) ? 15 :   \
            ((x & 0x00010000) ? 16 :   \
            ((x & 0x00020000) ? 17 :   \
            ((x & 0x00040000) ? 18 :   \
            ((x & 0x00080000) ? 19 :   \
            ((x & 0x00100000) ? 20 :   \
            ((x & 0x00200000) ? 21 :   \
            ((x & 0x00400000) ? 22 :   \
            ((x & 0x00800000) ? 23 :   \
            ((x & 0x01000000) ? 24 :   \
            ((x & 0x02000000) ? 25 :   \
            ((x & 0x04000000) ? 26 :   \
            ((x & 0x08000000) ? 27 :   \
            ((x & 0x10000000) ? 28 :   \
            ((x & 0x20000000) ? 29 :   \
            ((x & 0x40000000) ? 30 :   \
            ((x & 0x80000000) ? 31 : 0 \
            ))))))))))))))))))))))))))))))))            
#if __cplusplus
    }
#endif

#endif

