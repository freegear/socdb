/*------------------------------------------------------------------------------
--  This confidential and proprietary software may be used only as
--  authorised by a licensing agreement from ARM Limited
--    (C) COPYRIGHT 1999-2000 ARM Limited
--        ALL RIGHTS RESERVED
--  The entire notice above must be reproduced on all authorised
--  copies and copies may only be made to the extent permitted
--  by a licensing agreement from ARM Limited.
--------------------------------------------------------------------------------
--  
--  Version and Release Control Information:
--  
--  File Name              : Uart.h.rca
--  File Revision          : 1.9
--  
--  Release Information    : PrimeCell(TM)-PL011-REL1v3
--  
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
--  Purpose  :  This file contains the register offsets and other definitions 
--              for the Uart_free.c free running test code.
--
------------------------------------------------------------------------------*/

/******************************************************************************/
/*** Register  Offset Size Type Function                                    ***/
/*** ====================================================================== ***/
/*** UART Normal Registers                                                  ***/
/*** =====================                                                  ***/
/*** UARTDR        0x00   8    R/W  Data read or written from the interface ***/
/*** UARTRSR/      0x04   4/   R/   Receive Status Register (Read)/         ***/
/*** UARTECR              0    W    Error Clear Register (Write)            ***/
/*** UARTLCR_H     0x08   7    R/W  Line Control Register, High byte        ***/
/*** UARTLCR_M     0x0c   8    R/W  Line Control Register, Middle byte      ***/
/*** UARTLCR_L     0x10   8    R/W  Line Control Register, Low byte         ***/
/*** UARTCR        0x14   13   R/W  control register                        ***/
/*** UARTFR        0x18   8    R    Flag register (Read only)               ***/
/*** RESERVED      0x1c                                                     ***/
/*** UARTILPR      0x20   8    R/W  IrDA low power counter Register         ***/
/*** UARTBRD       0x24   16   R/W  BAud Rate Divisor Register              ***/
/*** UARTLCR_H_new 0x2C    7   R/W  Line Control Register, High byte        ***/
/*** UARTCR_new    0x30   14   R/W  Control register(new)                   ***/
/*** UARTIFLS      0x34    6   R/W  Interrupt fifo level select register    ***/
/*** UARTIMSC      0x38   11   R/W  Interrupt Mask Set/Clear
/*** UARTRIS       0x3c   11   R    Raw Interrupt Status
/*** UARTMIS       0x40   11   R    Masked Interrupt Status
/*** UARTICR       0x44   11   W    Interrupt Clear Register
/*** UARTDMACR     0x48   3    R/W  DMA Control Register
                                                                       
/*** UART Test  Registers                                                   ***/
/*** ====================                                                   ***/
/*** UARTTCR     0x80    3  R/W  Test Control Register                      ***/
/*** UARTITIP    0x84    8  R/W  Integration Test input register            ***/
/*** UARTITOP    0x88   14  R/W  Integration Test output register           ***/
/*** UARTTDR     0x8c   11  R/W  Test data regist                           ***/
/***                                                                        ***/
/*** UART Trickbox  Registers                                               ***/
/*** ========================                                               ***/
/*** UTDR           0x00 8  R/W  Data Read or Written from the interface    ***/
/*** UTRSR          0x04 2  R    Receive Status Register                    ***/
/*** UTLCR_H        0x08 8  R/W  Line Control Register, High Byte           ***/
/*** UTLCR_M        0x0c 8  R/W  Line Control Register, Middle Byte         ***/
/*** UTLCR_L        0x10 8  R/W  Line Control Register, Low Byte            ***/
/*** UTCR           0x14 8  R/W  Control Register                           ***/
/*** UTIIR          0x18 5  R    Interrupt Identification Register          ***/
/*** UTFR           0x1c 8  R    Trickbox Flag Register                     ***/
/*** UT_FREQ_ERR    0x20 1  R    Trickbox Frequency Error Register          ***/
/*** UT_FORCED_ERRS 0x24 8  R/W  Trickbox Forced Error Register             ***/
/*** UT_SET_PINS    0x28 7  R/W  Trickbox Set Pin Register                  ***/
/*** UT_CHECK_PINS  0x2c 2  R    Trickbox Check Pin Register                ***/
/*** UTILPR         0x30 8  R/W  IRLP Baud16 Counter Load Value Register    ***/
/*** UTBITSFT_DATA  0x34 8  W    IRLP Pulse Shift Register                  ***/
/*** UTBITSFT_DATA_2 0x38 8 W    IRLP Pulse Shift Register                  ***/
/*** UTCLKREG       0x3c 8  W    UARTCLK Timing Register                    ***/
/*** RSTMODE_REG    0x40 6  R/W  Synchronization And Reset Bits Register    ***/
/******************************************************************************/

/******************************************************************************/
/*** For more information on the Uart, please refer to PL011 AMBA UART      ***/
/*** Block Specification                                                    ***/
/******************************************************************************/

/******************************************************************************/
/******************** UART NORMAL-MODE REGISTERS  *****************************/
/******************************************************************************/

#define UARTBASE_ADD    0x8C000000
#define UARTDR          UARTBASE_ADD + 0x00   
#define UARTECR         UARTBASE_ADD + 0x04   
#define UARTRSR         UARTBASE_ADD + 0x04   
#define UARTLCR_H       UARTBASE_ADD + 0X08   
#define UARTLCR_M       UARTBASE_ADD + 0X0C   
#define UARTLCR_L       UARTBASE_ADD + 0X10   
#define UARTCR          UARTBASE_ADD + 0X14 
#define UARTFR          UARTBASE_ADD + 0X18 
#define UARTILPR        UARTBASE_ADD + 0X20
#define UARTIBRD        UARTBASE_ADD + 0X24
#define UARTFBRD        UARTBASE_ADD + 0X28
#define UARTLCR_H_new   UARTBASE_ADD + 0X2C
#define UARTCR_new      UARTBASE_ADD + 0X30
#define UARTIFLS        UARTBASE_ADD + 0X34
#define UARTIMSC        UARTBASE_ADD + 0X38
#define UARTRIS         UARTBASE_ADD + 0X3C
#define UARTMIS         UARTBASE_ADD + 0X40
#define UARTICR         UARTBASE_ADD + 0X44
#define UARTDMACR       UARTBASE_ADD + 0X48
#define PeripheralID0   UARTBASE_ADD + 0xFE0
#define PeripheralID1   UARTBASE_ADD + 0xFE4
#define PeripheralID2   UARTBASE_ADD + 0xFE8
#define PeripheralID3   UARTBASE_ADD + 0xFEC
#define PrimeCellID0    UARTBASE_ADD + 0xFF0
#define PrimeCellID1    UARTBASE_ADD + 0xFF4
#define PrimeCellID2    UARTBASE_ADD + 0xFF8
#define PrimeCellID3    UARTBASE_ADD + 0xFFC



/******************************************************************************/
/********************* UART TEST-MODE REGISTERS *******************************/
/******************************************************************************/

#define UARTTCR        UARTBASE_ADD + 0X80
#define UARTITIP       UARTBASE_ADD + 0X84
#define UARTITOP       UARTBASE_ADD + 0X88
#define UARTTDR        UARTBASE_ADD + 0X8C 




/******************************************************************************/
/******************** TRICKBOX REGISTERS **************************************/
/******************************************************************************/

#define UTBASE_ADD          0x60000000
#define UTDR                UTBASE_ADD + 0x00
#define UTRSR               UTBASE_ADD + 0x04
#define UTLCR_H             UTBASE_ADD + 0x08
#define UTLCR_M             UTBASE_ADD + 0x0c
#define UTLCR_L             UTBASE_ADD + 0x10
#define UTCR                UTBASE_ADD + 0x14
#define UTIIR               UTBASE_ADD + 0x18
#define UTFR                UTBASE_ADD + 0x1c
#define UT_FREQ_ERR         UTBASE_ADD + 0x20
#define UT_FORCED_ERRS      UTBASE_ADD + 0x24
#define UT_SET_PINS         UTBASE_ADD + 0x28
#define UT_CHECK_PINS       UTBASE_ADD + 0x2c
#define UTILPR              UTBASE_ADD + 0x30
#define UTBITSFT_DATA       UTBASE_ADD + 0x34
#define UTBITSFT_DATA_2     UTBASE_ADD + 0x38
#define UTCLKREG            UTBASE_ADD + 0x3c
#define RSTMODE_REG         UTBASE_ADD + 0x40
#define UTDMACR             UTBASE_ADD + 0x44
#define UTSTPARITY          UTBASE_ADD + 0x48
#define UTFBRD              UTBASE_ADD + 0x4C



/******************************************************************************/
/******************** MASKS FOR REGISTERS *************************************/
/******************************************************************************/

#define UTRSR_MASK            0x03
#define UTIIR_MASK            0x1f
#define UTFR_MASK             0xff
#define UTDMACR_MASK          0x3f

#define UARTDR_MASK           0xff
#define UARTECR_MASK          0xff
#define UARTRSR_MASK          0x0f
#define UARTLCR_H_MASK        0x7f
#define UARTLCR_M_MASK        0xff
#define UARTLCR_L_MASK        0xff
#define UARTCR_MASK           0x7f
#define UARTCR_newMASK        0xffff
#define UARTFR_MASK           0xf8
#define UARTILPR_MASK         0xff
#define UARTIBRD_MASK         0xffff
#define UARTFBRD_MASK         0x3f
#define UARTLCR_H_new_MASK    0xff
#define UARTIFLS_MASK         0x3f
#define UARTIMSC_MASK         0x7ff
#define UARTRIS_MASK          0x7ff
#define UARTMIS_MASK          0x7ff
#define UARTICR_MASK          0x7ff
#define UARTDMACR_MASK        0x07
#define MASK_IDREG            0x0ff


 
#define UARTTCR_MASK          0x07
#define UARTITIP_MASK         0xff
#define UARTITOP_MASK         0xffff
#define UARTTDR_MASK          0xfff


/******************************************************************************/
/******************** REGISTER BIT MASKS **************************************/
/******************************************************************************/
 
/* For RSTMODE_REG Register */ 
#define RSTMODE_ENABLE      0x01
#define PCLK_ENABLE         0x02
#define PCLKGEN             0x03
#define REFCLKGEN           0x04
#define REFCLKON            0x05
#define PCLKON              0x06

/* For UTIIR Register */
#define UT_MSINT            0x01
#define UT_RXINT            0x02
#define UT_TXINT            0x04
#define UT_RTISINT          0x08
#define UT_UARTINTR         0x10
#define UT_UARTEINTR        0x20

/* For UT_FORCED_ERROR Register */
#define FORCED_PARITY_ERR   0x01
#define FORCED_FRAMING_ERR  0x02
#define RX_JITTER_BITS      0x0c
#define RX_JITTER_SIGN      0x10
#define TX_JITTER_BITS      0x60
#define TX_JITTER_SIGN      0x80

/* For UTFR Register */
#define UTRXFIFO_EMPTY      0x01
#define UTRXFIFO_HALFFULL   0x02
#define UTRXFIFO_FULL       0x04
#define UTTXFIFO_EMPTY      0x08
#define UTTXFIFO_HALFEMPTY  0x10
#define UTTXFIFO_FULL       0x20
#define UTTXBUSY            0x40
#define UTRXBUSY            0x80

/* For UTRSR Register */
#define UTPE                0x02

/* For UTDMACR Register */
#define TXDMASREQ           0x04
#define RXDMASREQ           0x08
#define TXDMABREQ           0x10
#define RXDMABREQ           0x20

/* For UARTFR Register */
#define UART_CTS            0x01 
#define UART_DSR            0x02 
#define UART_DCD            0x04 
#define UART_UBUSY          0x08 
#define UART_RXFE           0x10 
#define UART_TXFF           0x20 
#define UART_RXFF           0x40 
#define UART_TXFE           0x80
#define UART_RI             0x100

/* For UARTIFLS Register */
#define UART_RXFEIGHT       0x00
#define UART_RXFQUART       0x08
#define UART_RXFHALF        0x10
#define UART_RXF3QUART      0x18
#define UART_RXF7EIGHT      0x20
#define UART_TXFEIGHT       0x00
#define UART_TXFQUART       0x01
#define UART_TXFHALF        0x02
#define UART_TXF3QUART      0x03
#define UART_TXF7EIGHT      0x04

/* UARTRIS Register */
#define UART_RIRINT         0x01
#define UART_CTSRINT        0x02
#define UART_DCDRINT        0x04
#define UART_DSRRINT        0x08
#define UART_RXRINT         0x10
#define UART_TXRINT         0x20
#define UART_RTRINT         0x40
#define UART_FERINT         0x80
#define UART_PERINT         0x100
#define UART_BERINT         0x200
#define UART_OERINT         0x400


/* UARTMIS Register */
#define UART_RIMINT         0x01
#define UART_CTSMINT        0x02
#define UART_DCDMINT        0x04
#define UART_DSRMINT        0x08
#define UART_RXMINT         0x10
#define UART_TXMINT         0x20
#define UART_RTMINT         0x40
#define UART_FEMINT         0x80
#define UART_PEMINT         0x100
#define UART_BEMINT         0x200
#define UART_OEMINT         0x400

/* UARTDMACR Register */
#define UART_RXDMAE         0x01
#define UART_TXDMAE         0x02
#define DMAONERR            0x04



/******************************************************************************/
/****************** MISCELLENEOUS *********************************************/
/******************************************************************************/
 
#define ZERO                0x00000000
#define NoMask              0xFFFFFFFF
#define MaskAll             0x00000000

#define TESTFIFO            0x02


#define UT_FIFO_ENABLE      0x10
 
#define UT_SET_CTS          0x01
#define UT_SET_DCD          0x02
#define UT_SET_DSR          0x04
#define UT_SET_TX           0x08
#define UT_SET_RI           0x20
#define UT_SET_SCANMODE     0x80
 
#define UT_RESET_CTS        0xfe
#define UT_RESET_DCD        0xfd
#define UT_RESET_DSR        0xfb
#define UT_RESET_RI         0xdf

#define UT_RTS              0x08

#define DATA_As             0xAAAAAAAA
#define DATA_5s             0x55555555
#define UARTFIFO_SIZE       16


#define IRLP_DIV            0x01


#define UARTTOCRmodem_MASK  0x78

#define UARTDR_ST_MASK      0xf00
#define UARTFR_MOD          0x107

#define RTSEn               0x4000
#define CTSEn               0x8000
#define nUARTRTS            0x800
#define nUARTCTS            0x01
#define UART_TXD            0x01

#define INTIP_MASK          0xC0
#define PIP_MASK            0x3F
#define INTOP_MASK          0xFFC0

/******************************************************************************/
/****************** GLOBAL CONSTANTS ******************************************/
/******************************************************************************/
 
unsigned long masks[9] = { 0x00, 0x01, 0x03, 0x07, 0x0f, 
                                 0x1f, 0x3f, 0x7f, 0xff};


enum op_mode { NORMAL_MODE, IRDA_MODE, IRDA_LP_MODE };

/******************************************************************************/
/****************** MACROS ****************************************************/
/******************************************************************************/
 
#define MAX(a,b) ((a >= b) ? a : b)
#define MIN(a,b) ((a <= b) ? a : b)

#define P_IDLE(x) for(i=0; i<x; i++) PI(0x01,"no_tag")

/*********************** End of Uart_free.h ***********************************/
 
