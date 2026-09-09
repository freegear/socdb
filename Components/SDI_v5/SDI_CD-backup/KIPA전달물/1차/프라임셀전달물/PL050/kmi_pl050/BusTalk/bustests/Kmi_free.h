/*------------------------------------------------------------------------------
--  This confidential and proprietary software may be used only as
--  authorised by a licensing agreement from ARM Limited
--    (C) COPYRIGHT 1999 ARM Limited
--        ALL RIGHTS RESERVED
--  The entire notice above must be reproduced on all authorised
--  copies and copies may only be made to the extent permitted
--  by a licensing agreement from ARM Limited.
--------------------------------------------------------------------------------
--
--  Version and Release Control Information:
--
--  File Name              : Kmi_free.h,v
--  File Revision          : 1.6
--
--  Release Information    : PL050-REL1v1
--
--------------------------------------------------------------------------------
 
--------------------------------------------------------------------------------
--  Purpose  :  This file contains the register offsets and other definitions
--              for the Kmi_free.c free running test code.
--
------------------------------------------------------------------------------*/

/*********************************************************************/

#define ZERO    0x00000000
#define NoMask  0xFFFFFFFF
#define MaskAll 0x00000000

/************** Trick Box Internal Register addresses ***************/

#define TB_BASE 0x60000000

#define TB_DR             TB_BASE + 0x00
#define TB_CR             TB_BASE + 0x04
#define TB_STAT           TB_BASE + 0x08
#define TB_CK_L           TB_BASE + 0x0c
#define TB_CK_H           TB_BASE + 0x10
#define TB_DSI            TB_BASE + 0x14
#define TB_DHI            TB_BASE + 0x18
#define TB_DSO            TB_BASE + 0x1c
#define TB_DHO            TB_BASE + 0x20
#define TB_REFCLK_PERIOD  TB_BASE + 0x24
#define TB_RG             TB_BASE + 0x28
#define TB_FFLAG          TB_BASE + 0x2c
#define TB_CHECK_PINS     TB_BASE + 0x30
#define TB_TIMOUT         TB_BASE + 0x34
#define TB_CLKDIV         TB_BASE + 0x38
#define RSTMODE_REG       TB_BASE + 0x3c
#define TIMESTAT          TB_BASE + 0x40


/* masks of registers */
#define TB_CHECK_PINS_MASK 0x001f

/* Bit masks */

/* Control Register Masks */
#define TB_ENABLE 0x01
#define TB_FORCED_PARITY_ERR 0x02
#define TB_KDATA_WIDTH 0x04
#define TB_TYPE_BIT     0x08
#define TB_SCANMODE     0x10

/* Status Register Masks */
#define TB_PARITY_ERROR 0x01
#define TB_FRAMING_ERROR 0x02
#define TB_RXBUSY 0x04
#define TB_TXBUSY 0x08
#define TB_KDATA_ERROR 0x10
#define TB_PCLKOn    0x20
#define TB_REFCLKOn    0x40

/* Check Pin Register Masks */
#define TB_KCLK 0x01
#define TB_KDATA 0x02
#define TB_TXINTR 0x04
#define TB_RXINTR 0x08
#define TB_INTR 0x10

/* For RSTMODE_REG Register */
#define RSTMODE_ENABLE 0x01
#define PCLK_ENABLE    0x02
#define PCLKEn         0x04
#define REFCLKEn       0x08

/* For TIME OUT Register */
#define TIMEOUT_EN     0x10


/*********************  Keyboard Controller Register **********************/

#define KMI_BASE 0x9C000000

#define KMICR      KMI_BASE + 0x00
#define KMISTAT    KMI_BASE + 0x04
#define KMIDATA    KMI_BASE + 0x08
#define KMIClkDiv  KMI_BASE + 0x0c
#define KMIIR      KMI_BASE + 0x10
#define KMITEST1   KMI_BASE + 0x20
#define KMITEST2   KMI_BASE + 0x24
#define KMITEST3   KMI_BASE + 0x28
#define KMITEST4   KMI_BASE + 0x2c

/* Test Register */
#define KMITMR     KMI_BASE + 0x84
#define KMITCR     KMI_BASE + 0x80

/* Test Register Reset Bit  */
#define TESTRST  0x08

/* Register Masks */
#define KMICR_MASK       0x07  
#define KMISTAT_MASK     0x7b 
#define KMIDATA_MASK     0xff
#define KMIClkDiv_MASK   0x0f
#define KMIIR_MASK       0x03

/* Control Register Masks */
#define KMI_FKC    0x01
#define KMI_FKD    0x02
#define KMI_ENABLE 0x04
#define KMI_TXINTR_ENABLE 0x08
#define KMI_RXINTR_ENABLE 0x10
#define KMI_TYPE_BIT      0x20

/* Status Register Masks */
#define KMI_KMI    0x01
#define KMI_KBC    0x02
#define KMI_PXD    0x04
#define KMI_RXB    0x08
#define KMI_RXF    0x10
#define KMI_TXB    0x20
#define KMI_TXE    0x40

/* Interrupt Status Register Masks */
#define KMIRXINTR 0x01
#define KMITXINTR 0x02

/* Status Register Reset value */
#define KMISTAT_RESET  (KMI_TXE | KMI_KBC | KMI_KMI)

/* Mode Masks */
#define STAGE_3_NIBBLE_MODE   0x08
#define STAGE_1_BYPASS_MODE   0x01
#define STAGE_2_BYPASS_MODE   0x02

/* Various constants */ 
#define SYNC_DELAY                    5  
#define MARGIN                        1000
#define TIMEOUT_DURATION              16000 
#define RQS_TO_SEND_TIME              64000
#define RQS_TO_SEND_TIME_WITH_MARGIN  ( RQS_TO_SEND_TIME + MARGIN )
#define TXBITS_WITH_MARGIN            14 
#define RXBITS_WITH_MARGIN            15 

/* 
 *   KMIREFCLK  cycles required for generating timeout in nibble mode for
 *   stage1 is 2^3 = 8 and
 *   stage3 is 2^4 = 16 .
 */
#define CYCLES_FOR_STG1_IN_NB_MODE    8   
#define CYCLES_FOR_STG3_IN_NB_MODE    16

/***************************************************************************/
/*** MACRO DEFINITIONS                                                   ***/
/***                                                                     ***/
/*** PNW(data, addr,[tag])                                               ***/
/*** PSW(data, addr,[tag])                                               ***/
/*** PNR(addr,[tag])                                                     ***/
/*** PSR(expected, mask, addr,[tag])                                     ***/
/*** PO(expected, mask, addr, [num_cyc],[tag])                           ***/
/*** PI(num_cyc,[tag])                                                   ***/
/*** RES(phase,[delay],[num_cyc])                                        ***/
/*** C(message)                                                          ***/
/***                                                                     ***/
/***************************************************************************/

/******* Defines ***************************/
#define DATA_As 0xAAAAAAAA
#define DATA_5s 0x55555555
#define DATA_Fs 0xFFFFFFFF
#define DATA_0s 0x00000000

/******* Global Constants  *****************/
unsigned long masks[9] = { 0x00, 0x01, 0x03, 0x07, 0x0f, 
                                 0x1f, 0x3f, 0x7f, 0xff};
    
/******* Global Variables  *****************/
unsigned int Tb_ck_h,Tb_ck_l;
int32 tx_byte_cycles, rx_byte_cycles, kclk_h_cycles, start_pulse_cycles;
static unsigned int SyncDelay  = ( SYNC_DELAY * PCLK_PERIOD );
enum op_mode { PS2_AT_MODE, LEGACY_MODE};
int Equiv_One, DSO_Time;

/******* Macros ****************************/

#define MAX(a,b) ((a >= b) ? a : b)
#define MIN(a,b) ((a <= b) ? a : b)

