/*------------------------------------------------------------------------------
--  This confidential and proprietary software may be used only as
--  authorised by a licensing agreement from ARM Limited
--    (C) COPYRIGHT 1998 ARM Limited
--        ALL RIGHTS RESERVED
--  The entire notice above must be reproduced on all authorised
--  copies and copies may only be made to the extent permitted
--  by a licensing agreement from ARM Limited.
--------------------------------------------------------------------------------
--  
--  Version and Release Control Information:
--  
--  File Name              : Kmi_prod.h,v
--  File Revision          : 1.3
--  
--  Release Information    : PL050-REL1v1
--  
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
--  Purpose  :                                                            
--             Register offsets and masks definitions for
--             Kmi bus compliance (BusTalk) tests.
--
------------------------------------------------------------------------------*/

/******************************************************************************/
/*** Register  Offset Width Type Function                                   ***/
/*** ====================================================================== ***/
/*** Normal Registers                                                       ***/
/*** ================                                                       ***/
/*** KMICR     0x00   6 bits R/W Kmi Control Register                       ***/
/*** KMISTAT   0x04   7 bits R   Kmi Status Register                        ***/
/*** KMIDATA   0x08   8 bits R/W Kmi Data Register (Writes to the Transmit  ***/
/***                                 Register. Reads from Receive Register) ***/
/*** KMICLKDIV 0x0c   4 bits R/W Kmi Clock Pre-Scaler Register              ***/
/*** KMIIR     0x10   2 bits R/W Kmi Interrupt Register                     ***/
/***                                                                        ***/
/*** Test  Registers                                                        ***/
/*** ================                                                       ***/
/*** KMITCER   0x40 - 0 bits R/W Kmi Test Clock Enable Register             ***/
/***           0x7c                                                         ***/
/*** KMITCR    0x80   5 bits R/W Kmi Test Control Register                  ***/
/*** KMITMR    0x84   4 bits R/W Kmi Test Mode Register                     ***/
/*** KMITISR   0x88   2 bits R/W Kmi Test Input Stimulus Register           ***/
/*** KMITOCR   0x8c   3 bits R   Kmi Test Output Capture Register           ***/
/*** KMISTG1   0x90   6 bits R   Kmi Stage1 Readback of Timer               ***/
/*** KMISTG2   0x94   5 bits R   Kmi Stage2 Readback of Timer (Bit0-2)      ***/
/***                                 Usec64 (Bit 4) and Msec(Bit 5)         ***/
/*** KMISTG3   0x98   8 bits R   Kmi Stage3 Readback of Timer (Bit0-2)      ***/
/*** KMISTATE  0x9c   4 bits R   Kmi Control States Readback                ***/
/******************************************************************************/

/******************************************************************************/
/*** For more information on the Kmi, please refer to PL050 AMBA Keyboard/  ***/
/*** Mouse Interface Block Specification                                    ***/
/******************************************************************************/

/******************************************************************************/
/******************** KMI  NORMAL-MODE REGISTERS ******************************/
/******************************************************************************/

#define KMI_BASE_ADD  0x9C000000
#define KMICR         KMI_BASE_ADD + 0x00
#define KMISTAT       KMI_BASE_ADD + 0x04
#define KMIDATA       KMI_BASE_ADD + 0x08
#define KMICLKDIV     KMI_BASE_ADD + 0x0C
#define KMIIR         KMI_BASE_ADD + 0x10

/******************************************************************************/
/***************** KMI  TEST-MODE REGISTERS ***********************************/
/******************************************************************************/

#define KMITCER       KMI_BASE_ADD + 0x40
#define KMITCR        KMI_BASE_ADD + 0x80
#define KMITMR        KMI_BASE_ADD + 0x84
#define KMITISR       KMI_BASE_ADD + 0x88
#define KMITOCR       KMI_BASE_ADD + 0x8C
#define KMISTG1       KMI_BASE_ADD + 0x90
#define KMISTG2       KMI_BASE_ADD + 0x94
#define KMISTG3       KMI_BASE_ADD + 0x98
#define KMISTATE      KMI_BASE_ADD + 0x9C

/******************************************************************************/
/**************** Bit Masking Constants ***************************************/
/******************************************************************************/


/*  All 8 bits valid                                                          */
#define NoMask       0xFF

/*  Mask all bits in a register                                               */
#define MaskAll      0x00

/* Mask values for bits in the KMICR register                                 */
#define FKMIC         0x01
#define FKMID         0x02
#define KMIEN         0x04
#define KMITXEEN      0x08
#define KMIRXFEN      0x10
#define KMITYPE       0x20

/* Mask values for bits in the KMISTAT registers                              */
#define KMIDATAIN     0x01
#define KMICLKIN      0x02
#define RXP           0x04
#define RXB           0x08
#define RXF           0x10
#define TXB           0x20
#define TXE           0x40

/*  Mask value for all the bits in the KMIDATA register                       */
#define DATA          0xFF

/* Mask value for all the bits in the KMICLKDIV register                      */
#define CLKDIV        0x0F

/* Mask value for all the bits in the KMIIR register                          */
#define RXINTR        0x01
#define TXINTR        0x02

/*  Mask values for bits in the KMITCR register                               */
#define TESTEN        0x01
#define TESTCLKEN     0x02
#define REGCLK        0x04
#define TESTRST       0x08
#define TESTINPSEL    0x10

/*  Mask values for bits in the KMITMR register                               */
#define Stg1Bypass    0x01
#define Stg2Bypass    0x02
#define S1NIB         0x04
#define S3NIB         0x08

/*  Mask values for bits in the KMITISR register                              */
#define KMIDATAIN    0x01
#define KMICLKIN     0x02

/*  Mask values for bits in the KMITOCR register                              */
#define KMIDATAEN    0x01
#define KMICLKEN     0x02
#define KMIINTR      0x04

/*  Mask value for all bits in the KMISTG1 register                           */
#define COUNTERSTG1  0x3F

/*  Mask value for all bits in the KMISTG3 register                           */
#define COUNTERSTG3   0xFF

/*  Mask value for all bits in the KMISTG2 register                           */
#define COUNTERSTG2   0x07
#define us_64         0x08
#define ms_16         0x10

/*   Mask values for states in the KMISTATE register                          */
#define STATE         0x0F 
#define IDLEST        0x00
#define TX64USST      0x01
#define TXST          0x03
#define RECOVERST     0x02
#define RESETST       0x06
#define TXDONEST      0x07
#define WAITST        0x05
#define RXST          0x04
#define LOCKST        0x0C

/*********************** End of Kmi_prod.h ************************************/



