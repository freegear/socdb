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
--  File Name              : Ssp.h.rca
--  File Revision          : 1.2
--  
--  Release Information    : PrimeCell(TM)-PL022-REL1v2
--  
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
--  Purpose  :  This file contains the register offsets and other definitions 
--              for the Ssp_free.c free running test code.
--
------------------------------------------------------------------------------*/

/*****************************************************************************/
/*** Register Offset Size Type Function                                    ***/
/*** ===================================================================== ***/
/*** SSP Normal Registers                                                  ***/
/*** ====================                                                  ***/
/*** SSPCR0    0x00   16   R/W  Control Register 0                         ***/
/*** SSPCR1    0x04    4   R/W  Control Register 1                         ***/
/*** SSPDR     0x08   16   R/W  Data read or written from the interface    ***/
/*** SSPSR     0x0C    5   R    Status Register                            ***/
/*** SSPCPSR   0x10    8   R/W  Clock Prescale Register                    ***/
/*** SSPIMSC   0x14    4   R/W  Interrupt Mask Set/Clear register          ***/
/*** SSPRIS    0x18    4   R    Raw Interrupt Status register              ***/
/*** SSPMIS    0x1C    4   R    Masked Interrupt Status register           ***/
/*** SSPICR    0x20    4   W    Interrupt Clear Register                   ***/
/*** SSPDMACR  0x24    3   R/W  DMA Control Register                       ***/
/***                                                                       ***/
/*** SSP Test  Registers                                                   ***/
/*** ===================                                                   ***/
/*** SSPTCR    0x80    2   R/W  Test Control Register                      ***/
/*** SSPITIP   0x84    5   R/W  Integration Test Input Register            ***/
/*** SSPITOP   0x88   10   R/W  Test Input Stimulas  Register              ***/
/*** SSPTDR    0x8C   16   R/W  Test Data Register (FIFO)                  ***/
/***                                                                       ***/
/*** SSP Peripheral ID Registers                                           ***/
/*** ===========================                                           ***/
/*** SSPPERIPHID0    0xFE0   8   R  Peripheral ID Register                 ***/
/*** SSPPERIPHID1    0xFE4   8   R  Peripheral ID Register                 ***/
/*** SSPPERIPHID2    0xFE8   8   R  Peripheral ID Register                 ***/
/*** SSPPERIPHID3    0xFEC   8   R  Peripheral ID Register                 ***/
/***                                                                       ***/
/*** SSP PrimeCell ID Registers                                            ***/
/*** ==========================                                            ***/
/*** SSPPCELLID0     0xFF0   8   R  PrimeCell ID Register                  ***/
/*** SSPPCELLID1     0xFF4   8   R  PrimeCell ID Register                  ***/
/*** SSPPCELLID2     0xFF8   8   R  PrimeCell ID Register                  ***/
/*** SSPPCELLID3     0xFFC   8   R  PrimeCell ID Register                  ***/
/***                                                                       ***/
/*** SSP Trickbox  Registers                                               ***/
/*** ========================                                              ***/
/*** SSPTBPRE       0x00 4  R/W  Prescale Value Register                   ***/
/*** SSPTBSCR0      0x04 16 R/W  Trickbox Control Register 0               ***/
/*** SSPTBSCR1      0x08 6  R/W  Trickbox Control Register 1               ***/
/*** SSPTBSTDR      0x0C 16 R/W  Trickbox Transmit data Register           ***/
/*** SSPTBSRDR      0x10 16 R/W  Trickbox Receive  data Register           ***/
/*** SSPTBSSR       0x14 13 R/W  Trickbox Status Register                  ***/
/*** SSPTB_SET_PINS 0x18 7  R/W  Trickbox Set Pin Register                 ***/
/*** SSPTBCLKREG    0x1C 16 R/W  Trickbox SSP Reference Clock Period Reg.  ***/
/*** SSPTBCR2       0x20 11 R/W  Trickbox SSP SCLK Counter Reg.            ***/
/*** SSPTBCLKREG1   0x24 16 R/W  Trickbox SSP Reference Clock1 Period Reg. ***/
/*** SSPTBDMACR     0x28 6  R/W  Trickbox SSP DMA Register.                ***/
/*****************************************************************************/

/*****************************************************************************/
/*** For more information on the Ssp , please refer to PL021 AMBA SSP      ***/
/*** Block Specification                                                   ***/
/*****************************************************************************/

/*****************************************************************************/
/******************** SSP NORMAL-MODE REGISTERS  *****************************/
/*****************************************************************************/

#define SSPBASE_ADD   (0x84000000)
#define SSPCR0        (SSPBASE_ADD + 0x00)
#define SSPCR1        (SSPBASE_ADD + 0x04)
#define SSPDR         (SSPBASE_ADD + 0x08)
#define SSPSR         (SSPBASE_ADD + 0x0C)
#define SSPCPSR       (SSPBASE_ADD + 0x10)
#define SSPIMSC       (SSPBASE_ADD + 0x14)
#define SSPRIS        (SSPBASE_ADD + 0x18)
#define SSPMIS        (SSPBASE_ADD + 0x1C)
#define SSPICR        (SSPBASE_ADD + 0x20)
#define SSPDMACR      (SSPBASE_ADD + 0x24)

/*****************************************************************************/
/********************* SSP TEST-MODE REGISTERS *******************************/
/*****************************************************************************/

#define SSPTCR        (SSPBASE_ADD + 0X80) 
#define SSPITIP       (SSPBASE_ADD + 0X84) 
#define SSPITOP       (SSPBASE_ADD + 0X88) 
#define SSPTDR        (SSPBASE_ADD + 0X8C) 

/*****************************************************************************/
/********************* SSP Peripheral ID REGISTERS ***************************/
/*****************************************************************************/

#define SSPPERIPHID0  (SSPBASE_ADD + 0XFE0) 
#define SSPPERIPHID1  (SSPBASE_ADD + 0XFE4) 
#define SSPPERIPHID2  (SSPBASE_ADD + 0XFE8) 
#define SSPPERIPHID3  (SSPBASE_ADD + 0XFEC) 

/*****************************************************************************/
/********************* SSP PrimeCell ID REGISTERS ****************************/
/*****************************************************************************/
#define SSPPCELLID0   (SSPBASE_ADD + 0XFF0) 
#define SSPPCELLID1   (SSPBASE_ADD + 0XFF4) 
#define SSPPCELLID2   (SSPBASE_ADD + 0XFF8) 
#define SSPPCELLID3   (SSPBASE_ADD + 0XFFC) 

/*****************************************************************************/
/********************* TRICKBOX REGISTERS ************************************/
/*****************************************************************************/

#define SSPTBBASE_ADD   (0x60000000)
#define SSPTBPRE        (SSPTBBASE_ADD + 0x0)
#define SSPTBSCR0 	(SSPTBBASE_ADD + 0x04)
#define SSPTBSCR1 	(SSPTBBASE_ADD + 0x08)
#define SSPTBSTDR 	(SSPTBBASE_ADD + 0x0C)
#define SSPTBSRDR 	(SSPTBBASE_ADD + 0x10)
#define SSPTBSSR  	(SSPTBBASE_ADD + 0x14)
#define TB_SET_PINS    	(SSPTBBASE_ADD + 0x18)
#define SSPCLKREG 	(SSPTBBASE_ADD + 0x1C)
#define SSPTBCR2        (SSPTBBASE_ADD + 0x20)
#define SSPCLKREG1      (SSPTBBASE_ADD + 0x24)
#define SSPTBDMACR      (SSPTBBASE_ADD + 0x28)

/*****************************************************************************/
/******************** MASKS FOR REGISTERS ************************************/
/*****************************************************************************/

/* SSP Register Masks */

#define  MASK_SSP_DATA_SIZE   0x0000000F
#define  MASK_SSP_FRM_FORMAT  0x000000F0
#define  MASK_SSP_SCLK_RATE   0x0000FF00
#define  MASK_SSP_ENABLE      0x00000008
/* #define  MASK_SSP_ENABLE      0x00000008 ??? shouldn't this be 0x00000010 */
#define  MASK_SSP_SSPCPSR     0x000000FF

#define MASK_RESET_SSPCR0        0xFFFF
#define MASK_RESET_SSPCR1        0xFFFF
#define MASK_RESET_SSPDR         0xFFFF
#define MASK_RESET_SSPSR         0xFFFF
#define MASK_RESET_SSPCPSR       0xFFFF
#define MASK_RESET_SSPIMSC       0xFFFF
#define MASK_RESET_SSPRIS        0xFFFF
#define MASK_RESET_SSPMIS        0xFFFF
#define MASK_RESET_SSPICR        0xFFFF
#define MASK_RESET_SSPDMACR      0xFFFF
#define MASK_RESET_SSPTCR        0xFFFF
#define MASK_RESET_SSPITIP       0xFFFE
#define MASK_RESET_SSPITOP       0xFFFF
#define MASK_RESET_SSPTDR        0xFFFF    
#define MASK_RESET_SSPPERIPHID0  0xFFFF
#define MASK_RESET_SSPPERIPHID1  0xFFFF
#define MASK_RESET_SSPPERIPHID2  0xFFFF
#define MASK_RESET_SSPPERIPHID3  0xFFFF
#define MASK_RESET_SSPPCELLID0   0xFFFF
#define MASK_RESET_SSPPCELLID1   0xFFFF
#define MASK_RESET_SSPPCELLID2   0xFFFF
#define MASK_RESET_SSPPCELLID3   0xFFFF
#define MASK_RESET_SSPIMSC       0xFFFF

#define MASK_SSPCR0   0xFFFF
#define MASK_SSPCR1   0x000F
#define MASK_SSPDR    0xFFFF
#define MASK_SSPSR    0x001F
#define MASK_SSPCPSR  0x00FE
#define MASK_SSPIMSC  0x000F
#define MASK_SSPRIS   0x000F
#define MASK_SSPMIS   0x000F
#define MASK_SSPDMACR 0x0003

/* Test Register Masks */
#define MASK_SSPTCR       0x3
#define MASK_SSPITIP      0x1F
#define MASK_SSPITIP_4_3  0x18
#define MASK_SSPITIP_2_0  0x07
#define MASK_SSPITOP      0x3FFF
#define MASK_SSPITOP_13_5 0x3fe0
#define MASK_SSPITOP_4_0  0x001f
#define MASK_SSPTDR       0xFFFF

/* SSP TrickBox Register Masks */
#define  MASK_SSPTB_DATA_SIZE   0x0000000F
#define  MASK_SSPTB_FRM_FORMAT  0x00000030
#define  MASK_SSPTB_SCLK_RATE   0x0000FF00
#define  MASK_SSPTB_ENABLE      0x00000040
#define  MASK_SSPTB_PRE         0x0000000F
#define  MASK_SSPTB_RXW         0x0000000C
#define  MASK_SSPTB_PCLKON      0x00000400
#define  MASK_SSPTB_REFCLKON    0x00000800
#define  MASK_SSPTB_REFCLK1ON   0x00001000

#define  MASK_SSPTB_DMACR       0x0000003F

/*****************************************************************************/
/******************** REGISTER BIT MASKS *************************************/
/*****************************************************************************/
 
/* SSP SCR0 register values */
#define  SSP_TI         0x10
#define  SSP_MICROWIRE  0x20
#define  SSP_SPI00      0x00
#define  SSP_SPI01      0x40
#define  SSP_SPI10      0x80
#define  SSP_SPI11      0xC0

/* SSP SCR1 register values */
#define  SSP_LBM        0x1
#define  SSP_ENABLE     0x2
#define  SSP_MS         0x4
#define  SSP_SOD        0x8

/* SSP Status register bit positions */
#define SSP_TFE         0x01
#define SSP_TNF         0x02
#define SSP_RNE         0x04
#define SSP_RFF         0x08
#define SSP_BSY         0x10 
  
/* SSP SSPIMSC register values */
#define SSP_IMCLR       0x00
#define SSP_RORSC       0x01
#define SSP_RTSC        0x02
#define SSP_RXSC        0x04
#define SSP_TXSC        0x08

/* SSP SSPRIS register values */
#define SSP_RORRIS      0x01
#define SSP_RTRIS       0x02
#define SSP_RXRIS       0x04
#define SSP_TXRIS       0x08

/* SSP SSPMIS register values */
#define SSP_RORMIS      0x01
#define SSP_RTMIS       0x02
#define SSP_RXMIS       0x04
#define SSP_TXMIS       0x08

/* SSP SSPICR register values */
#define SSP_RORIC       0x01
#define SSP_RTIC        0x02

/* SSP SSPDMACR register values */
#define SSP_RXDMAE      0x01
#define SSP_TXDMAE      0x02
#define SSP_ONERROR     0x04

/* SSP SSPTCR register values */
#define SSP_ITEN        0x01
#define SSP_TESTFIFO    0x02


/* SSP TrickBox SCR0 register values */
#define  SSPTB_SPI          0x00
#define  SSPTB_TI           0x10
#define  SSPTB_MICROWIRE    0x20
#define  SSPTB_ENABLE       0x40

/* SSP TrickBox SCR1 register values */
#define  SSPTB_SPI00    0x00
#define  SSPTB_SPI01    0x01
#define  SSPTB_SPI10    0x02
#define  SSPTB_SPI11    0x03
#define  SSPTB_MS       0x10
#define  SSPTB_OD       0x20

/* SSP TrickBox Status register bit positions */
#define SSPTB_RXFE               0x0001
#define SSPTB_RXFF               0x0002
#define SSPTB_TXFE               0x0004
#define SSPTB_TXFF               0x0008
#define SSPTB_BSY                0x0010
#define SSPTB_SSPINT             0x0020
#define SSPTB_RXWFLG             0x0040
#define SSPTB_RFSFLG             0x0080
#define SSPTB_TFSFLG             0x0100
#define SSPTB_RORFLG             0x0200
#define SSPTB_PCLKON             0x0400
#define SSPTB_REFCLKON           0x0800
#define SSPTB_RTFLG              0x1000

/* SSP TrickBox Rx Watermark Level */
#define SSPTB_RXW_2             0x00
#define SSPTB_RXW_4             0x04
#define SSPTB_RXW_6             0x08
#define SSPTB_RXW_8             0x0C

/* SSP TrickBox TB_SET_PINS Reset value  */
#define  TB_SET_PINS_RESET_VALUE 0x04
#define  SCANMODE_ENABLE  0x01
#define  RSTMODE_ENABLE   0x02
#define  GENCLK_ENABLE    0x04
#define  PCLK_ENABLE      0x08
#define  SSPCLK_ENABLE    0x10
#define  SSPCLK1_ENABLE   0x20
#define  GENCLK1_ENABLE   0x40

/* SSP TrickBox CR2 register values */
#define  SSPTB_FRC              0x100
#define  SSPTB_SPISFRMEN        0x200
#define  SSPTB_TIDASFRM         0x400

/* SSP TrickBox DMA register values */
/* 2 lsbs are write only */
#define  SSPTB_TXDMACLR         0x01
#define  SSPTB_RXDMACLR         0x02
#define  SSPTB_TXDMABREQ        0x04
#define  SSPTB_TXDMASREQ        0x08
#define  SSPTB_RXDMABREQ        0x10
#define  SSPTB_RXDMASREQ        0x20



/*****************************************************************************/
/****************** MISCELLENEOUS ********************************************/
/*****************************************************************************/

#define TRUE     0x1
#define FALSE    0x0

/* Data values */
#define DATA_As 0xAAAAAAAA
#define DATA_5s 0x55555555
#define DATA_0s 0x00000000
#define DATA_Fs 0xFFFFFFFF

/* Mask Values */
#define MASK_16   0xFFFF

/* SSP Normal Registers Reset value */
#define RESET_SSPCR0     DATA_0s
#define RESET_SSPCR1     DATA_0s
#define RESET_SSPDR      DATA_0s
#define RESET_SSPSR      0x0003
#define RESET_SSPCPSR    DATA_0s
#define RESET_SSPIMSC    DATA_0s
#define RESET_SSPRIS     0x8
#define RESET_SSPMIS     DATA_0s
#define RESET_SSPDMACR   DATA_0s

/* SSP Test Registers Reset Value*/
#define RESET_SSPTCR     DATA_0s
#define RESET_SSPITIP    DATA_0s
#define RESET_SSPITOP    DATA_0s

/* SSP Peripheral ID Register Value - Hard coded */
#define RESET_SSPPERIPHID0  0x22
#define RESET_SSPPERIPHID1  0x10
#define RESET_SSPPERIPHID2  0x04
#define RESET_SSPPERIPHID3  0x00

/* SSP PrimeCell ID Register Value - Hard coded */
#define RESET_SSPPCELLID0   0X0D
#define RESET_SSPPCELLID1   0xF0
#define RESET_SSPPCELLID2   0x05
#define RESET_SSPPCELLID3   0xB1

/* SSP SCLK value */
#define  SSP_SCLK_RATE0   0x0000
#define  SSP_SCLK_RATE1   0x0100
#define  SSP_SCLK_RATE2   0x0200
#define  SSP_SCLK_RATE3   0x0300
#define  SSP_SCLK_RATE4   0x0400
#define  SSP_SCLK_RATE5   0x0500
#define  SSP_SCLK_RATE6   0x0600
#define  SSP_SCLK_RATE7   0x0700
#define  SSP_SCLK_RATE8   0x0800
#define  SSP_SCLK_RATE9   0x0900
#define  SSP_SCLK_RATE11  0x0B00
#define  SSP_SCLK_RATE12  0x0C00
#define  SSP_SCLK_RATE13  0x0D00
#define  SSP_SCLK_RATE14  0x0E00

/* SSP Trickbox  SCLK value */
#define  SSPTB_SCLK_RATE0   0x0000
#define  SSPTB_SCLK_RATE1   0x0100
#define  SSPTB_SCLK_RATE2   0x0200
#define  SSPTB_SCLK_RATE3   0x0300
#define  SSPTB_SCLK_RATE4   0x0400
#define  SSPTB_SCLK_RATE5   0x0500
#define  SSPTB_SCLK_RATE6   0x0600
#define  SSPTB_SCLK_RATE7   0x0700
#define  SSPTB_SCLK_RATE8   0x0800
#define  SSPTB_SCLK_RATE9   0x0900
#define  SSPTB_SCLK_RATE11  0x0B00
#define  SSPTB_SCLK_RATE12  0x0C00
#define  SSPTB_SCLK_RATE13  0x0D00
#define  SSPTB_SCLK_RATE14  0x0E00

/*********************** End of Ssp_free.h ***********************************/
 
