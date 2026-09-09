/*----------------------------------------------------------------------
--  This confidential and proprietary software may be used only as
--  authorised by a licensing agreement from ARM Limited
--    (C) COPYRIGHT 2000 ARM Limited
--        ALL RIGHTS RESERVED
--  The entire notice above must be reproduced on all authorised
--  copies and copies may only be made to the extent permitted
--  by a licensing agreement from ARM Limited.
------------------------------------------------------------------------
--  
--  Version and Release Control Information:
--  
--  File Name              : $RCSfile : Gpio.h.rca $
--  File Revision          : $Revision : 1.1 $
--  Release Information    : PrimeCell(TM)-PL061-REL1v0
--  
------------------------------------------------------------------------

------------------------------------------------------------------------
--  Purpose  :  This file contains the register offsets and other 
--              definitions for the Gpio_free.c free running test code.
--
----------------------------------------------------------------------*/

/**********************************************************************/
/*** Register  Offset  Width Type Function                          ***/
/*** ============================================================== ***/
/*** GPIO Normal Registers                                          ***/
/*** =====================                                          ***/
/***                                                                ***/
/*** GPIODATA      0x000  8  R/W  Data register                     ***/
/*** GPIODIR       0x400  8  R/W  Data Direction register           ***/
/*** GPIOIS        0x404  8  R/W  Interrupt Sense register          ***/
/*** GPIOIBE       0x408  8  R/W  Interrupt Both Edges register     ***/
/*** GPIOIEV       0x40C  8  R/W  Interrupt EVent register          ***/
/*** GPIOIE        0x410  8  R/W  Interrupt Enable register         ***/
/*** GPIORIS       0x414  8  R    Raw Interrupt register            ***/
/*** GPIOMIS       0x418  8  R    Masked Interrupt register         ***/
/*** GPIOIC        0x41C  8  W    Interrupt Clear register          ***/
/*** GPIOAFSEL     0x420  8  R/W  Alternate Functionality reg.      ***/
/***                                                                ***/
/*** GPIO Integration Vector Registers                              ***/
/*** =================================                              ***/
/*** GPIOITCR      0x600  1  R/W  Integration Test Control reg.     ***/
/*** GPIOITIP1     0x604  8  R/W  Integr. Vect. I/P for GPAFOUT     ***/ 
/*** GPIOITIP2     0x608  8  R/W  Integr. Vect. O/P for GPAFIN      ***/ 
/*** GPIOITOP1     0x60C  8  W    Integration MIS Test O/P Set reg. ***/
/*** GPIOITOP2     0x610  1  R    Integr. Interrupt Test O/P Read r.***/
/*** GPIOITOP3     0x614  8  R/W  Integr. Vect. I/P for nGPAFEN     ***/
/***                                                                ***/
/*** GPIO Identification Registers                                  ***/
/*** ===================                                            ***/
/***                                                                ***/
/*** GPIOPeriphID0 0xFE0  8  R    Identification(0) register        ***/
/*** GPIOPeriphID1 0xFE4  8  R    Identification(1) register        ***/
/*** GPIOPeriphID2 0xFE8  8  R    Identification(2) register        ***/
/*** GPIOPeriphID3 0xFEC  8  R    Identification(3) register        ***/
/*** GPIOPCellID0  0xFF0  8  R    Octopus Identification(0) reg.    ***/
/*** GPIOPCellID1  0xFF4  8  R    Octopus Identification(1) reg.    ***/
/*** GPIOPCellID2  0xFF8  8  R    Octopus Identification(2) reg.    ***/
/*** GPIOPCellID3  0xFFC  8  R    Octopus Identification(3) reg.    ***/
/***                                                                ***/
/*** GPIO Trickbox Registers                                        ***/
/*** =======================                                        ***/
/*** GTENR    0x00  8  R    status of GPIO Output Enables  :nGPEN   ***/
/*** GTOUTR   0x04  8  R    status of GPIO Outputs         :GPOUT   ***/
/*** GTINR    0x08  8  R/W  Controls GPIO Inputs           :GPIN    ***/
/*** GTAENR   0x0C  8  R/W  Controls GPIO A.F. O/P Enables :nGPAFEN ***/
/*** GTAOUTR  0X10  8  R/W  Controls GPIO A.F. Outputs     :GPAFOUT ***/
/*** GTAINR   0x14  8  R    status GPIO Alt. Funct. Inputs :GPAFIN  ***/
/*** GTINT    0x18  1  R    status of Interrupt Output     :GPIOINTR***/
/*** GTMIS    0x1C  8  R    status of Masked Int. Output   :GPIOMIS ***/
/***                                                                ***/
/**********************************************************************/

/**********************************************************************/
/*** For more information on the Gpio, please refer to PL060 AMBA   ***/
/*** GPIO Block Specification                                       ***/
/**********************************************************************/
 
/**********************************************************************/
/******************* GPIO NORMAL-MODE REGISTERS  **********************/
/**********************************************************************/

#define GPIOBASE_ADD     0x98000000 
#define GPIODATA         GPIOBASE_ADD + 0x000         /*0x000 to 0x3FC*/
#define GPIODIR          GPIOBASE_ADD + 0x400
#define GPIOIS           GPIOBASE_ADD + 0x404
#define GPIOIBE          GPIOBASE_ADD + 0x408
#define GPIOIEV          GPIOBASE_ADD + 0x40C
#define GPIOIE           GPIOBASE_ADD + 0x410
#define GPIORIS          GPIOBASE_ADD + 0x414
#define GPIOMIS          GPIOBASE_ADD + 0x418
#define GPIOIC           GPIOBASE_ADD + 0x41C
#define GPIOAFSEL        GPIOBASE_ADD + 0x420


/**********************************************************************/
/******************** GPIO INTEGRATION VECTORS ************************/
/**********************************************************************/

#define GPIOITCR         GPIOBASE_ADD + 0x600
#define GPIOITIP1        GPIOBASE_ADD + 0x604
#define GPIOITIP2        GPIOBASE_ADD + 0x608
#define GPIOITOP1        GPIOBASE_ADD + 0x60C
#define GPIOITOP2        GPIOBASE_ADD + 0x610
#define GPIOITOP3        GPIOBASE_ADD + 0x614


/**********************************************************************/
/***************** GPIO IDENTIFICATION REGISTERS **********************/
/**********************************************************************/
 
#define GPIOPeriphID0    GPIOBASE_ADD + 0xFE0
#define GPIOPeriphID1    GPIOBASE_ADD + 0xFE4
#define GPIOPeriphID2    GPIOBASE_ADD + 0xFE8
#define GPIOPeriphID3    GPIOBASE_ADD + 0xFEC

#define GPIOPCellID0     GPIOBASE_ADD + 0xFF0
#define GPIOPCellID1     GPIOBASE_ADD + 0xFF4
#define GPIOPCellID2     GPIOBASE_ADD + 0xFF8
#define GPIOPCellID3     GPIOBASE_ADD + 0xFFC

/**********************************************************************/
/******************** TRICKBOX REGISTERS ******************************/
/**********************************************************************/

#define GTBASE_ADD       0x60000000 /* 0x60 00 00 00 */
#define GTENR            GTBASE_ADD + 0x00
#define GTOUTR           GTBASE_ADD + 0x04
#define GTINR            GTBASE_ADD + 0x08
#define GTAENR           GTBASE_ADD + 0x0C
#define GTAOUTR          GTBASE_ADD + 0x10
#define GTAINR           GTBASE_ADD + 0x14
#define GTINT            GTBASE_ADD + 0x18
#define GTMIS            GTBASE_ADD + 0x1C

/**********************************************************************/
/****************** Bit Masking Constants *****************************/
/**********************************************************************/
 
#define NoMask           0x000000FF
#define MaskAll          0x00000000
 
/************************** End of file *******************************/
