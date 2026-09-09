/* --=========================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 2000-2001 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
--
-- -----------------------------------------------------------------------------
-- Version and Release Control Information:
--
-- File Name              : Dmac.h.rca
-- File Revision          : 1.5
--
-- Release Information    : PrimeCell(TM)-PL081-REL1v0
--
-- -----------------------------------------------------------------------------
-- Purpose : This file contains the register offsets and other
--           definitions for the Dmac.c functional test code.
--
-- --=========================================================================*/
 
/******************************************************************************/
/********************** USER CONFIGURABLE PARAMETERS **************************/
#define NUMBEROFCHANNELS 2

#define NUMBEROFMASTERS  1

/******************************************************************************/

#if NUMBEROFCHANNELS > 2
 #define MORETHAN2CHS
#endif

#if NUMBEROFCHANNELS > 4
  #define MORETHAN4CHS
#endif

#if NUMBEROFMASTERS > 1
 #define TWOMASTERCONFIG
#endif

/******************************************************************************/
/*  There are 8 channels in the DMA controller.                               */
/*  The following tests are dealing with only one channel defined by          */
/*  the constant CHANNEL below:                                               */
/*  1. DmacM2MTests.c  - Memory-Memory DMA                                    */
/*  2. DmacM2PTests.c  - Memory-Peripheral DMA                                */
/*  3. DmacP2MTests.c  - Peripheral-Memory DMA                                */
/*  4. DmacP2PTests.c  - Peripheral-Peripheral DMA                            */
/*  5. DmacLLILTests.c - DMA with LLI                                         */
/*                                                                            */
/* CHANNEL can be set to any integer value from 0 to 7.                       */
/******************************************************************************/
#define CHANNEL 1 

/******************************************************************************/
/*  The constant TESTCONFIGURATION defines the following variables of the     */
/*  DMA transfer:                                                             */
/*  1. DMAC Master of the source/destination transfer.                        */
/*  2. Incrementing the address of the source/destination transfer.           */
/*  3. Source and Destination peripheral for the M2P/P2M/P2P DMA              */
/*  4. Terminal Count, Error Mask and TC-Enable bit set/clear.                */
/*  5. Combination of the AHB response for the source/destination transfer.   */
/*                                                                            */
/*  The test cases are as defined in the test document, that does not         */
/*  consider the above variables into account. Therefore the user can         */
/*  configure the test code to program the memory/peripheral models for the   */
/*  desired combination of these variables.                                   */
/*                                                                            */
/*  If the user desires to configure these variables, the parameter           */
/*  TESTCONFIGURATION should be set to "USER". By "DEFAULT", all the          */
/*  above mentioned variables are used as they are in the test code.          */
/*  TESTCONFIGURATION can be set to "DEFAULT" or "USER"                       */
/******************************************************************************/
#define TESTCONFIGURATION "DEFAULT"

/******************************************************************************/
/* SMASTER - DMA Master of the source transfer.                               */
/* DMASTER - DMA Master of the destination transfer.                          */
/*                                                                            */
/* Both of them can be 0 or 1 only.                                           */
/* 0 - DMA Master 0 will initiate the transfer.                               */
/* 1 - DMA Master 1 will initiate the transfer.                               */
/* Any of the four possible combinations of SMASTER/DMASTER are allowed.      */
/******************************************************************************/
#define SOURCEMASTER 0
#define DESTMASTER   0

/******************************************************************************/
/* For single master configuration master for bith source and desination is   */
/* same i.e. Master Interface 0                                               */
/******************************************************************************/
#if NUMBEROFMASTERS == 2
  #define SMASTER  SOURCEMASTER
  #define DMASTER  DESTMASTER
#else
  #define SMASTER  0
  #define DMASTER  0
#endif
/******************************************************************************/
#define SINC     "NI"
#define DINC     "NI"

/******************************************************************************/
/* SPERIPH - Source peripheral for a P2M/P2P DMA.                             */
/* DPERIPH - Destination peripheral for an M2P/P2P DMA.                       */
/*                                                                            */
/* The DMA controller can handle upto a maximum of 16 peripherals.            */
/* Therefore the SPERIPH/DPERIPH value can be from 0 to 15 only.              */
/*                                                                            */
/* For a P2P transfer, both SPERIPH and DPERIPH values cannot be same.        */
/******************************************************************************/
#define SPERIPH  0
#define DPERIPH  1

/******************************************************************************/
/* TC - Terminal Count                                                        */
/* TCENABLE - TC Enable to be set/clear in channel control register.          */
/* TCMASK   - TC Mask to be set/clear in channel configuration register.      */
/* ERRMASK  - Interrupt Error Mask to be set/clear channel configuration      */
/*            register.                                                       */
/*                                                                            */
/* These can be set to 0 or 1 only.                                           */
/******************************************************************************/
#define TCENABLE 0
#define TCMASK   0
#define ERRMASK  0

/******************************************************************************/
/* AHB Response type for the source transfer of the DMA.                      */
/* The memory/peripheral model that is the source of the DMA will be          */
/* programmed to return the given combination of responses.                   */
/*                                                                            */
/* SOKAY  - AHB okay response to be returned for the source transfer.         */
/* SRETRY - AHB retry response to be returned for the source transfer.        */
/* SSPLIT - AHB split response to be returned for the source transfer.        */
/* SERROR - AHB error response to be returned for the source transfer.        */
/* SWAIT  - Wait inserted response to be returned for the source transfer.    */
/*                                                                            */
/* The valid values of all these constants are 0 and 1 only.                  */
/*                                                                            */
/* The order in which they are defined here will affect the default           */
/* response of the memory/peripheral model. Whichever value is samped '1'     */
/* first, in the following order, will be programmed as the default           */
/* response for the source transfers.                                         */
/*                                                                            */
/* If all of them are '0', then the memory/peripheral will be programmed      */
/* AHB okay response as the default response for all source transfers.        */
/******************************************************************************/
#define SOKAY    0
#define SRETRY   0
#define SSPLIT   0
#define SERROR   0
#define SWAIT    0

/******************************************************************************/
/* AHB Response type for the destination transfer of the DMA.                 */
/* The memory/peripheral model that is the destination of the DMA will be     */
/* programmed to return the given combination of responses.                   */
/*                                                                            */
/* DOKAY  - AHB okay response to be returned for the destination transfer.    */
/* DRETRY - AHB retry response to be returned for the destination transfer.   */
/* DSPLIT - AHB split response to be returned for the destination transfer.   */
/* DERROR - AHB error response to be returned for the destination transfer.   */
/* DWAIT  - Wait inserted response to be returned for the destination         */
/*          transfer.                                                         */
/*                                                                            */
/* The valid values of all these constants are 0 and 1 only.                  */
/*                                                                            */
/* The order in which they are defined here will affect the default           */
/* response of the memory/peripheral model. Whichever value is samped '1'     */
/* first, in the following order, will be programmed as the default           */
/* response for the destination transfers.                                    */
/*                                                                            */
/* If all of them are '0', then the memory/peripheral will be programmed      */
/* AHB okay response as the default response for all destination transfers.   */
/******************************************************************************/
#define DOKAY    0
#define DRETRY   0
#define DSPLIT   0
#define DERROR   0
#define DWAIT    0

#define DEBUG    0
#define INFO     0

/******************************************************************************/

#define DMAC_BASE             (0x50000000)
#define DMACTR_BASE           (0xA0000000)

/********************* END OF USER CONFIGURABLE PARAMETERS ********************/
/******************************************************************************/

/******************************************************************************/
/******************************** DMAC REGISTERS ******************************/
/******************************************************************************/

/*** ---------------------------------------------------------------------- ***/
/*** The Offset values are from the DMAC register base address.             ***/
/*** ---------------------------------------------------------------------- ***/
/******************************************************************************/
/*** Register          Offset  Size Type  Valid-bits   Description          ***/
/*** ====================================================================== ***/
/*** DMACIntStat       0x000     8    R       7-0      Interrupt status     ***/
/*** DMACIntTCStat     0x004     8    R       7-0      TC Interrupt status  ***/
/*** DMACIntTCClr      0x008     8    W       7-0      TC Interrupt clear   ***/
/*** DMACIntErrStat    0x00C     8    R       7-0      Error Interrupt      ***/
/***                                                   status               ***/
/*** DMACIntErrClr     0x010     8    W       7-0      Error Interrupt      ***/
/***                                                   clear                ***/
/*** DMACRawIntTC      0x014     8    R       7-0      Raw TC Interrupt     ***/
/***                                                   status               ***/
/*** DMACRawIntErr     0x018     8    R       7-0      Raw Error Interrupt  ***/
/***                                                   status               ***/
/*** DMACEnbldChns     0x01C     8    R       7-0      Channel Enables      ***/
/*** DMACSoftBReq      0x020    16    R/W    15-0      Soft DMA burst       ***/
/***                                                   request              ***/
/*** DMACSoftSReq      0x024    16    R/W    15-0      Soft DMA single      ***/
/***                                                   request              ***/
/*** DMACSoftLBReq     0x028    16    R/W    15-0      Soft DMA last-burst  ***/
/***                                                   request              ***/
/*** DMACSoftLSReq     0x02C    16    R/W    15-0      Soft DMA last-single ***/
/***                                                   request              ***/
/*** DMACConfig        0x030     3    R/W     2-0      DMAC configuration   ***/
/*** DMACSync          0x034    16    R/W    15-0      DMAC requests select ***/
/***                                                   control              ***/
/*** DMACC0SrcAddr     0x100    32    R/W    31-0      DMA channel 0 source ***/
/***                                                   address.             ***/
/*** DMACC0DestAddr    0x104    32    R/W    31-0      DMA channel 0        ***/
/***                                                   destination address. ***/
/*** DMACC0LLIReg      0x108    31    R/W    31-2, 0   DMA channel 0 Linked ***/
/***                                                   List address.        ***/
/*** DMACC0Control     0x10C    32    R/W    31-0      DMA channel 0        ***/
/***                                                   control              ***/
/*** DMACC0Config      0x110    19    R/W    18-0      DMA channel 0        ***/
/***                                                   configuration.       ***/
/*** DMACC1SrcAddr     0x120    32    R/W    31-0      DMA channel 1 source ***/
/***                                                   address.             ***/
/*** DMACC1DestAddr    0x124    32    R/W    31-0      DMA channel 1        ***/
/***                                                   destination address. ***/
/*** DMACC1LLIReg      0x128    31    R/W    31-2, 0   DMA channel 1 Linked ***/
/***                                                   List address.        ***/
/*** DMACC1Control     0x12C    32    R/W    31-0      DMA channel 1        ***/
/***                                                   control              ***/
/*** DMACC1Config      0x130    19    R/W    18-0      DMA channel 1        ***/
/***                                                   configuration.       ***/
/*** DMACC2SrcAddr     0x140    32    R/W    31-0      DMA channel 2 source ***/
/***                                                   address.             ***/
/*** DMACC2DestAddr    0x144    32    R/W    31-0      DMA channel 2        ***/
/***                                                   destination address. ***/
/*** DMACC2LLIReg      0x148    31    R/W    31-2, 0   DMA channel 2 Linked ***/
/***                                                   List address.        ***/
/*** DMACC2Control     0x14C    32    R/W    31-0      DMA channel 2        ***/
/***                                                   control              ***/
/*** DMACC2Config      0x150    19    R/W    18-0      DMA channel 2        ***/
/***                                                   configuration.       ***/
/*** DMACC3SrcAddr     0x160    32    R/W    31-0      DMA channel 3 source ***/
/***                                                   address.             ***/
/*** DMACC3DestAddr    0x164    32    R/W    31-0      DMA channel 3        ***/
/***                                                   destination address. ***/
/*** DMACC3LLIReg      0x168    31    R/W    31-2, 0   DMA channel 3 Linked ***/
/***                                                   List address.        ***/
/*** DMACC3Control     0x16C    32    R/W    31-0      DMA channel 3        ***/
/***                                                   control              ***/
/*** DMACC3Config      0x170    19    R/W    18-0      DMA channel 3        ***/
/***                                                   configuration.       ***/
/*** DMACC4SrcAddr     0x180    32    R/W    31-0      DMA channel 4 source ***/
/***                                                   address.             ***/
/*** DMACC4DestAddr    0x184    32    R/W    31-0      DMA channel 4        ***/
/***                                                   destination address. ***/
/*** DMACC4LLIReg      0x188    31    R/W    31-2, 0   DMA channel 4 Linked ***/
/***                                                   List address.        ***/
/*** DMACC4Control     0x18C    32    R/W    31-0      DMA channel 4        ***/
/***                                                   control              ***/
/*** DMACC4Config      0x190    19    R/W    18-0      DMA channel 4        ***/
/***                                                   configuration.       ***/
/*** DMACC5SrcAddr     0x1A0    32    R/W    31-0      DMA channel 5 source ***/
/***                                                   address.             ***/
/*** DMACC5DestAddr    0x1A4    32    R/W    31-0      DMA channel 5        ***/
/***                                                   destination address. ***/
/*** DMACC5LLIReg      0x1A8    31    R/W    31-2, 0   DMA channel 5 Linked ***/
/***                                                   List address.        ***/
/*** DMACC5Control     0x1AC    32    R/W    31-0      DMA channel 5        ***/
/***                                                   control              ***/
/*** DMACC5Config      0x1B0    19    R/W    18-0      DMA channel 5        ***/
/***                                                   configuration.       ***/
/*** DMACC6SrcAddr     0x1C0    32    R/W    31-0      DMA channel 6 source ***/
/***                                                   address.             ***/
/*** DMACC6DestAddr    0x1C4    32    R/W    31-0      DMA channel 6        ***/
/***                                                   destination address. ***/
/*** DMACC6LLIReg      0x1C8    31    R/W    31-2, 0   DMA channel 6 Linked ***/
/***                                                   List address.        ***/
/*** DMACC6Control     0x1CC    32    R/W    31-0      DMA channel 6        ***/
/***                                                   control              ***/
/*** DMACC6Config      0x1D0    19    R/W    18-0      DMA channel 6        ***/
/***                                                   configuration.       ***/
/*** DMACC7SrcAddr     0x1E0    32    R/W    31-0      DMA channel 7 source ***/
/***                                                   address.             ***/
/*** DMACC7DestAddr    0x1E4    32    R/W    31-0      DMA channel 7        ***/
/***                                                   destination address. ***/
/*** DMACC7LLIReg      0x1E8    31    R/W    31-2, 0   DMA channel 7 Linked ***/
/***                                                   List address.        ***/
/*** DMACC7Control     0x1EC    32    R/W    31-0      DMA channel 7        ***/
/***                                                   control              ***/
/*** DMACC7Config      0x1F0    19    R/W    18-0      DMA channel 7        ***/
/***                                                   configuration.       ***/
/*** DMACTCR           0x500     2    R/W     1-0      Test Control         ***/
/*** DMACITOP1         0x504    16    R/W    15-0      Integration Test     ***/
/***                                                   output               ***/
/*** DMACITOP2         0x508    16    R/W    15-0      Integration Test     ***/
/***                                                   output               ***/
/*** DMACITOP3         0x50C     2    R/W     1-0      Integration Test     ***/
/***                                                   output               ***/
/*** DMACPeriphId0     0xFE0     8    R       7-0      Peripheral ID        ***/
/***                                                   bits 7:0   (0x80)    ***/
/*** DMACPeriphId1     0xFE4     8    R       7-0      Peripheral ID        ***/
/***                                                   bits 15:8  (0x10)    ***/
/*** DMACPeriphId2     0xFE8     8    R       7-0      Peripheral ID        ***/
/***                                                   bits 23:16 (0x04)    ***/
/*** DMACPeriphId3     0xFEC     8    R       7-0      Peripheral ID        ***/
/***                                                   bits 31:24 (0x0A)    ***/
/*** DMACPCellId0      0xFF0     8    R       7-0      PrimeCell ID         ***/
/***                                                   bits 7:0   (0x0D)    ***/
/*** DMACPCellId1      0xFF4     8    R       7-0      PrimeCell ID         ***/
/***                                                   bits 15:8  (0xF0)    ***/
/*** DMACPCellId2      0xFF8     8    R       7-0      PrimeCell ID         ***/
/***                                                   bits 23:16 (0x05)    ***/
/*** DMACPCellId3      0xFFC     8    R       7-0      PrimeCell ID         ***/
/***                                                   bits 31:24 (0xB1)    ***/
/******************************************************************************/
#define DMACIntStat           (DMAC_BASE + 0x000)
#define DMACIntTCStat         (DMAC_BASE + 0x004)
#define DMACIntTCClr          (DMAC_BASE + 0x008)
#define DMACIntErrStat        (DMAC_BASE + 0x00C)
#define DMACIntErrClr         (DMAC_BASE + 0x010)
#define DMACRawIntTC          (DMAC_BASE + 0x014)
#define DMACRawIntErr         (DMAC_BASE + 0x018)
#define DMACEnbldChns         (DMAC_BASE + 0x01C)
#define DMACSoftBReq          (DMAC_BASE + 0x020)
#define DMACSoftSReq          (DMAC_BASE + 0x024)
#define DMACSoftLBReq         (DMAC_BASE + 0x028)
#define DMACSoftLSReq         (DMAC_BASE + 0x02C)
#define DMACConfig            (DMAC_BASE + 0x030)
#define DMACSync              (DMAC_BASE + 0x034)
#define DMACC0SrcAddr         (DMAC_BASE + 0x100)
#define DMACC0DestAddr        (DMAC_BASE + 0x104)
#define DMACC0LLIReg          (DMAC_BASE + 0x108)
#define DMACC0Control         (DMAC_BASE + 0x10C)
#define DMACC0Config          (DMAC_BASE + 0x110)
#define DMACC1SrcAddr         (DMAC_BASE + 0x120)
#define DMACC1DestAddr        (DMAC_BASE + 0x124)
#define DMACC1LLIReg          (DMAC_BASE + 0x128)
#define DMACC1Control         (DMAC_BASE + 0x12C)
#define DMACC1Config          (DMAC_BASE + 0x130)
#define DMACC2SrcAddr         (DMAC_BASE + 0x140)
#define DMACC2DestAddr        (DMAC_BASE + 0x144)
#define DMACC2LLIReg          (DMAC_BASE + 0x148)
#define DMACC2Control         (DMAC_BASE + 0x14C)
#define DMACC2Config          (DMAC_BASE + 0x150)
#define DMACC3SrcAddr         (DMAC_BASE + 0x160)
#define DMACC3DestAddr        (DMAC_BASE + 0x164)
#define DMACC3LLIReg          (DMAC_BASE + 0x168)
#define DMACC3Control         (DMAC_BASE + 0x16C)
#define DMACC3Config          (DMAC_BASE + 0x170)
#define DMACC4SrcAddr         (DMAC_BASE + 0x180)
#define DMACC4DestAddr        (DMAC_BASE + 0x184)
#define DMACC4LLIReg          (DMAC_BASE + 0x188)
#define DMACC4Control         (DMAC_BASE + 0x18C)
#define DMACC4Config          (DMAC_BASE + 0x190)
#define DMACC5SrcAddr         (DMAC_BASE + 0x1A0)
#define DMACC5DestAddr        (DMAC_BASE + 0x1A4)
#define DMACC5LLIReg          (DMAC_BASE + 0x1A8)
#define DMACC5Control         (DMAC_BASE + 0x1AC)
#define DMACC5Config          (DMAC_BASE + 0x1B0)
#define DMACC6SrcAddr         (DMAC_BASE + 0x1C0)
#define DMACC6DestAddr        (DMAC_BASE + 0x1C4)
#define DMACC6LLIReg          (DMAC_BASE + 0x1C8)
#define DMACC6Control         (DMAC_BASE + 0x1CC)
#define DMACC6Config          (DMAC_BASE + 0x1D0)
#define DMACC7SrcAddr         (DMAC_BASE + 0x1E0)
#define DMACC7DestAddr        (DMAC_BASE + 0x1E4)
#define DMACC7LLIReg          (DMAC_BASE + 0x1E8)
#define DMACC7Control         (DMAC_BASE + 0x1EC)
#define DMACC7Config          (DMAC_BASE + 0x1F0)
#define DMACTCR               (DMAC_BASE + 0x500)
#define DMACITOP1             (DMAC_BASE + 0x504)
#define DMACITOP2             (DMAC_BASE + 0x508)
#define DMACITOP3             (DMAC_BASE + 0x50C)
#define DMACPeriphId0         (DMAC_BASE + 0xFE0)
#define DMACPeriphId1         (DMAC_BASE + 0xFE4)
#define DMACPeriphId2         (DMAC_BASE + 0xFE8)
#define DMACPeriphId3         (DMAC_BASE + 0xFEC)
#define DMACPCellId0          (DMAC_BASE + 0xFF0)
#define DMACPCellId1          (DMAC_BASE + 0xFF4)
#define DMACPCellId2          (DMAC_BASE + 0xFF8)
#define DMACPCellId3          (DMAC_BASE + 0xFFC)

#define DMAC_REGADDR_LIMIT    (DMAC_BASE + 0xFFC)

/******************************************************************************/
/***************************** TRICKBOX REGISTERS *****************************/
/******************************************************************************/

/*** ---------------------------------------------------------------------- ***/
/*** The Offset values are from the base address of the Trickbox.           ***/
/*** ---------------------------------------------------------------------- ***/
/******************************************************************************/
/*** Register          Offset  Size Type  Valid-bits   Description          ***/
/*** ====================================================================== ***/
/*** DMACREQCONFIG     0x000     8    R      17-0      Memory & Peripheral  ***/
/***                                                   configuration.       ***/
/*** DMACGRANTCNT0     0x004     8    R      11-0      AHB bus grant for    ***/
/***                                                   DMA Master 0.        ***/
/*** DMACGRANTCNT1     0x008     8    W      11-0      AHB bus grant for    ***/
/***                                                   DMA Master 1.        ***/
/*** DMACTRICKEN       0x00C     8    R       7-0      Trickbox Enable.     ***/
/******************************************************************************/
#define DMACREQCONFIG         (DMACTR_BASE + 0x000)
#define DMACGRANTCNT0         (DMACTR_BASE + 0x004)
#define DMACGRANTCNT1         (DMACTR_BASE + 0x008)
#define DMACTRICKEN           (DMACTR_BASE + 0x00C)

/******************************************************************************/
/*** The test environment contains 2 Memory and 16 Peripheral Models.       ***/
/*** Each one of them have got their own programmable registers.            ***/
/*** The register address range of these models are as follows:             ***/
/***                                                                        ***/
/*** ---------------------------------------------------------------------- ***/
/*** The Offset values are from the base address of the Trickbox.           ***/
/*** ---------------------------------------------------------------------- ***/
/*** Address Range            Device                                        ***/
/*** ====================================================================== ***/
/*** 0x000000 - 0x00FFFC  - Top level trickbox registers.                   ***/
/*** 0x010000 - 0x01FFFC  - Memory 0 registers.                             ***/
/*** 0x020000 - 0x02FFFC  - Memory 1 registers.                             ***/
/*** 0x030000 - 0x03FFFC  - Peripheral 0 registers.                         ***/
/*** 0x040000 - 0x04FFFC  - Peripheral 1 registers.                         ***/
/*** 0x050000 - 0x05FFFC  - Peripheral 2 registers.                         ***/
/*** 0x060000 - 0x06FFFC  - Peripheral 3 registers.                         ***/
/*** 0x070000 - 0x07FFFC  - Peripheral 4 registers.                         ***/
/*** 0x080000 - 0x08FFFC  - Peripheral 5 registers.                         ***/
/*** 0x090000 - 0x09FFFC  - Peripheral 6 registers.                         ***/
/*** 0x0A0000 - 0x0AFFFC  - Peripheral 7 registers.                         ***/
/*** 0x0B0000 - 0x0BFFFC  - Peripheral 8 registers.                         ***/
/*** 0x0C0000 - 0x0CFFFC  - Peripheral 9 registers.                         ***/
/*** 0x0D0000 - 0x0DFFFC  - Peripheral 10 registers.                        ***/
/*** 0x0E0000 - 0x0EFFFC  - Peripheral 11 registers.                        ***/
/*** 0x0F0000 - 0x0FFFFC  - Peripheral 12 registers.                        ***/
/*** 0x100000 - 0x10FFFC  - Peripheral 13 registers.                        ***/
/*** 0x110000 - 0x11FFFC  - Peripheral 14 registers.                        ***/
/*** 0x120000 - 0x12FFFC  - Peripheral 15 registers.                        ***/
/******************************************************************************/
#define DMACTRMEM0REGBASE     (DMACTR_BASE + 0x00010000)
#define DMACTRMEM1REGBASE     (DMACTR_BASE + 0x00020000)
#define DMACTRP0REGBASE       (DMACTR_BASE + 0x00030000)
#define DMACTRP1REGBASE       (DMACTR_BASE + 0x00040000)
#define DMACTRP2REGBASE       (DMACTR_BASE + 0x00050000)
#define DMACTRP3REGBASE       (DMACTR_BASE + 0x00060000)
#define DMACTRP4REGBASE       (DMACTR_BASE + 0x00070000)
#define DMACTRP5REGBASE       (DMACTR_BASE + 0x00080000)
#define DMACTRP6REGBASE       (DMACTR_BASE + 0x00090000)
#define DMACTRP7REGBASE       (DMACTR_BASE + 0x000A0000)
#define DMACTRP8REGBASE       (DMACTR_BASE + 0x000B0000)
#define DMACTRP9REGBASE       (DMACTR_BASE + 0x000C0000)
#define DMACTRP10REGBASE      (DMACTR_BASE + 0x000D0000)
#define DMACTRP11REGBASE      (DMACTR_BASE + 0x000E0000)
#define DMACTRP12REGBASE      (DMACTR_BASE + 0x000F0000)
#define DMACTRP13REGBASE      (DMACTR_BASE + 0x00100000)
#define DMACTRP14REGBASE      (DMACTR_BASE + 0x00110000)
#define DMACTRP15REGBASE      (DMACTR_BASE + 0x00120000)
 
/******************************************************************************/
/****************************** MEMORY REGISTERS ******************************/
/******************************************************************************/
/*** ---------------------------------------------------------------------- ***/
/*** The Offset values are from the base address of the respective memory   ***/
/*** register base address.                                                 ***/
/*** ---------------------------------------------------------------------- ***/
/******************************************************************************/
/*** Register          Offset  Size Type  Valid-bits   Description          ***/
/*** ====================================================================== ***/
/*** DMACTrMemEn       0x000    32   R/W     31-0      Memory Enable and    ***/
/***                                                   Default Response.    ***/
/*** DMACTrMemData     0x004    32   R/W     31-0      Data generation.     ***/
/*** DMACTrMemControl  0x008-   32   R/W     31-0      Response control.    ***/
/***                   0x040                                                ***/
/******************************************************************************/
#define DMACTrMemEn0          (DMACTRMEM0REGBASE + 0x00000000)
#define DMACTrMemData0        (DMACTRMEM0REGBASE + 0x00000004)
#define DMACTrMemControl0     (DMACTRMEM0REGBASE + 0x00000008)

#define DMACTrMemEn1          (DMACTRMEM1REGBASE + 0x00000000)
#define DMACTrMemData1        (DMACTRMEM1REGBASE + 0x00000004)
#define DMACTrMemControl1     (DMACTRMEM1REGBASE + 0x00000008)

/******************************************************************************/
/**************************** PERIPHERAL REGISTERS ****************************/
/******************************************************************************/
/*** ---------------------------------------------------------------------- ***/
/*** The Offset values are from the base address of the respective          ***/
/*** peripheral register base address.                                      ***/
/*** ---------------------------------------------------------------------- ***/
/******************************************************************************/
/*** Register          Offset  Size Type  Valid-bits   Description          ***/
/*** ====================================================================== ***/
/*** PERIPHENREG       0x000    32   R/W     31-0      Peripheral enable &  ***/
/***                                                   Default Response.    ***/
/*** PERIPHDATAREG     0x004    32   R/W     31-0      Data generation.     ***/
/*** PERIPHREQREG      0x008    32   R/W     31-0      Request generation.  ***/
/*** PERIPHRESPREG     0x00C    32   R/W     31-0      TC/CLR monitor.      ***/
/*** PERIPHCTRLREG     0x010-   32   R/W     31-0      Response control.    ***/
/***                   0x040                                                ***/
/******************************************************************************/
#define PERIPHENREG           0x00000000
#define PERIPHDATAREG         0x00000004
#define PERIPHREQREG          0x00000008
#define PERIPHTCREG           0x0000000C
#define PERIPHCLRREG          0x00000010
#define PERIPHCTRLREG         0x00000014

/******************************************************************************/
/*********************** MEMORY/PERIPHERAL ADDRESS RANGE **********************/
/******************************************************************************/
/*** The following are the range of addresses allocated to each model on    ***/
/*** the DMA master bus. This ranges are applicable on both the buses.      ***/
/*** By changing the bit, corresponding to the Memory/Peripheral models, in ***/
/*** DMACREQCONFIG register, the DMA master bus of the Memory/Peripheral    ***/
/*** can be changed.                                                        ***/
/*** ---------------------------------------------------------------------- ***/
/*** Address Range            Device                                        ***/
/*** ====================================================================== ***/
/*** 0x00000000 - 0x07FFFFFF  - Reserved                                    ***/
/*** 0x08000000 - 0x0FFFFFFF  - Memory 0                                    ***/
/*** 0x10000000 - 0x17FFFFFF  - Memory 1                                    ***/
/*** 0x18000000 - 0x1FFFFFFF  - Peripheral 0                                ***/
/*** 0x20000000 - 0x27FFFFFF  - Peripheral 1                                ***/
/*** 0x28000000 - 0x2FFFFFFF  - Peripheral 2                                ***/
/*** 0x30000000 - 0x37FFFFFF  - Peripheral 3                                ***/
/*** 0x38000000 - 0x3FFFFFFF  - Peripheral 4                                ***/
/*** 0x40000000 - 0x47FFFFFF  - Peripheral 5                                ***/
/*** 0x48000000 - 0x4FFFFFFF  - Peripheral 6                                ***/
/*** 0x50000000 - 0x57FFFFFF  - Peripheral 7                                ***/
/*** 0x58000000 - 0x5FFFFFFF  - Peripheral 8                                ***/
/*** 0x60000000 - 0x67FFFFFF  - Peripheral 9                                ***/
/*** 0x68000000 - 0x6FFFFFFF  - Peripheral 10                               ***/
/*** 0x70000000 - 0x77FFFFFF  - Peripheral 11                               ***/
/*** 0x78000000 - 0x7FFFFFFF  - Peripheral 12                               ***/
/*** 0x80000000 - 0x87FFFFFF  - Peripheral 13                               ***/
/*** 0x88000000 - 0x8FFFFFFF  - Peripheral 14                               ***/
/*** 0x90000000 - 0xA7FFFFFF  - Peripheral 15                               ***/
/*** ---------------------------------------------------------------------- ***/
/***                                                                        ***/
/*** The memory models also handle the LLI address. 64 words have been      ***/
/*** reserved for the LLIs, as follows.                                     ***/
/*** 0x08000000 - 0x08000040  - Memory 0 LLI                                ***/
/*** 0x01000000 - 0x10000040  - Memory 1 LLI                                ***/
/******************************************************************************/
#define DMACTRMEM0BASE        0x08000000
#define DMACTRMEM1BASE        0x10000000
#define DMACTRP0BASE          0x18000000
#define DMACTRP1BASE          0x20000000
#define DMACTRP2BASE          0x28000000
#define DMACTRP3BASE          0x30000000
#define DMACTRP4BASE          0x38000000
#define DMACTRP5BASE          0x40000000
#define DMACTRP6BASE          0x48000000
#define DMACTRP7BASE          0x50000000
#define DMACTRP8BASE          0x58000000
#define DMACTRP9BASE          0x60000000
#define DMACTRP10BASE         0x68000000
#define DMACTRP11BASE         0x70000000
#define DMACTRP12BASE         0x78000000
#define DMACTRP13BASE         0x80000000
#define DMACTRP14BASE         0x88000000
#define DMACTRP15BASE         0x90000000

#define M0LOWADDRRANGE        0x08000040
#define M0HIGHADDRRANGE       0x0FFFFFFF

#define M1LOWADDRRANGE        0x10000040
#define M1HIGHADDRRANGE       0x17FFFFFF

#define P0LOWADDRRANGE        0x18000000
#define P0HIGHADDRRANGE       0x1FFFFFFF

#define P1LOWADDRRANGE        0x20000000
#define P1HIGHADDRRANGE       0x27FFFFFF

#define P2LOWADDRRANGE        0x28000000
#define P2HIGHADDRRANGE       0x2FFFFFFF

#define P3LOWADDRRANGE        0x30000000
#define P3HIGHADDRRANGE       0x37FFFFFF

#define P4LOWADDRRANGE        0x38000000
#define P4HIGHADDRRANGE       0x3FFFFFFF

#define P5LOWADDRRANGE        0x40000000
#define P5HIGHADDRRANGE       0x47FFFFFF

#define P6LOWADDRRANGE        0x48000000
#define P6HIGHADDRRANGE       0x4FFFFFFF

#define P7LOWADDRRANGE        0x50000000
#define P7HIGHADDRRANGE       0x57FFFFFF

#define P8LOWADDRRANGE        0x58000000
#define P8HIGHADDRRANGE       0x5FFFFFFF

#define P9LOWADDRRANGE        0x60000000
#define P9HIGHADDRRANGE       0x67FFFFFF

#define P10LOWADDRRANGE       0x68000000
#define P10HIGHADDRRANGE      0x6FFFFFFF

#define P11LOWADDRRANGE       0x70000000
#define P11HIGHADDRRANGE      0x77FFFFFF

#define P12LOWADDRRANGE       0x78000000
#define P12HIGHADDRRANGE      0x7FFFFFFF

#define P13LOWADDRRANGE       0x80000000
#define P13HIGHADDRRANGE      0x87FFFFFF

#define P14LOWADDRRANGE       0x88000000
#define P14HIGHADDRRANGE      0x8FFFFFFF

#define P15LOWADDRRANGE       0x90000000
#define P15HIGHADDRRANGE      0xA7FFFFFF
 
/******************************************************************************/
/*********************** RESET VALUES OF DMAC REGISTERS ***********************/
/******************************************************************************/
#define RST_DMACIntStat       0x00000000
#define RST_DMACIntTCStat     0x00000000
#define RST_DMACIntTCClr      0x00000000
#define RST_DMACIntErrStat    0x00000000
#define RST_DMACIntErrClr     0x00000000
#define RST_DMACRawIntTC      0x00000000
#define RST_DMACRawIntErr     0x00000000
#define RST_DMACEnbldChns     0x00000000
#define RST_DMACSoftBReq      0x00000000
#define RST_DMACSoftSReq      0x00000000
#define RST_DMACSoftLBReq     0x00000000
#define RST_DMACSoftLSReq     0x00000000
#define RST_DMACConfig        0x00000000
#define RST_DMACSync          0x00000000
#define RST_DMACC0SrcAddr     0x00000000
#define RST_DMACC0DestAddr    0x00000000
#define RST_DMACC0LLIReg      0x00000000
#define RST_DMACC0Control     0x00000000
#define RST_DMACC0Config      0x00000000
#define RST_DMACC1SrcAddr     0x00000000
#define RST_DMACC1DestAddr    0x00000000
#define RST_DMACC1LLIReg      0x00000000
#define RST_DMACC1Control     0x00000000
#define RST_DMACC1Config      0x00000000
#define RST_DMACC2SrcAddr     0x00000000
#define RST_DMACC2DestAddr    0x00000000
#define RST_DMACC2LLIReg      0x00000000
#define RST_DMACC2Control     0x00000000
#define RST_DMACC2Config      0x00000000
#define RST_DMACC3SrcAddr     0x00000000
#define RST_DMACC3DestAddr    0x00000000
#define RST_DMACC3LLIReg      0x00000000
#define RST_DMACC3Control     0x00000000
#define RST_DMACC3Config      0x00000000
#define RST_DMACC4SrcAddr     0x00000000
#define RST_DMACC4DestAddr    0x00000000
#define RST_DMACC4LLIReg      0x00000000
#define RST_DMACC4Control     0x00000000
#define RST_DMACC4Config      0x00000000
#define RST_DMACC5SrcAddr     0x00000000
#define RST_DMACC5DestAddr    0x00000000
#define RST_DMACC5LLIReg      0x00000000
#define RST_DMACC5Control     0x00000000
#define RST_DMACC5Config      0x00000000
#define RST_DMACC6SrcAddr     0x00000000
#define RST_DMACC6DestAddr    0x00000000
#define RST_DMACC6LLIReg      0x00000000
#define RST_DMACC6Control     0x00000000
#define RST_DMACC6Config      0x00000000
#define RST_DMACC7SrcAddr     0x00000000
#define RST_DMACC7DestAddr    0x00000000
#define RST_DMACC7LLIReg      0x00000000
#define RST_DMACC7Control     0x00000000
#define RST_DMACC7Config      0x00000000
#define RST_DMACTCR           0x00000000
#define RST_DMACITOP1         0x00000000
#define RST_DMACITOP2         0x00000000
#define RST_DMACITOP3         0x00000000
#define RST_DMACPeriphId0     0x00000081
#define RST_DMACPeriphId1     0x00000010
#define RST_DMACPeriphId2     0x00000004
#define RST_DMACPeriphId3     0x00000000
#define RST_DMACPCellId0      0x0000000D
#define RST_DMACPCellId1      0x000000F0
#define RST_DMACPCellId2      0x00000005
#define RST_DMACPCellId3      0x000000B1

/******************************************************************************/
/************* READ-ONLY REGISTERS OF DMAC AND THEIR RESET VALUES *************/
/******************************************************************************/
#define RDO_DMACIntStat       0x00000000
#define RDO_DMACIntTCStat     0x00000000
#define RDO_DMACIntErrStat    0x00000000
#define RDO_DMACRawIntTC      0x00000000
#define RDO_DMACRawIntErr     0x00000000
#define RDO_DMACEnbldChns     0x00000000
#define RDO_DMACPeriphId0     0x00000081
#define RDO_DMACPeriphId1     0x00000010
#define RDO_DMACPeriphId2     0x00000004
#define RDO_DMACPeriphId3     0x00000000
#define RDO_DMACPCellId0      0x0000000D
#define RDO_DMACPCellId1      0x000000F0
#define RDO_DMACPCellId2      0x00000005
#define RDO_DMACPCellId3      0x000000B1

/******************************************************************************/
/************************ MASK VALUES OF DMAC REGISTERS ***********************/
/******************************************************************************/
#define MASK_DMACSoftBReq     0x0000FFFF
#define MASK_DMACSoftSReq     0x0000FFFF
#define MASK_DMACSoftLBReq    0x0000FFFF
#define MASK_DMACSoftLSReq    0x0000FFFF
#define MASK_DMACConfig       0x00000003
#define MASK_DMACSync         0x0000FFFF
#define MASK_DMACC0SrcAddr    0xFFFFFFFF
#define MASK_DMACC0DestAddr   0xFFFFFFFF

#ifdef TWOMASTERCONFIG
  #define MASK_DMACC0LLIReg     0xFFFFFFFD
#else
  #define MASK_DMACC0LLIReg     0xFFFFFFFC
#endif TWOMASTERCONFIG

#define MASK_DMACC0Control    0xFFFFF000
#define MASK_DMACC0Config     0x0005FFFF
#define MASK_DMACC1SrcAddr    0xFFFFFFFF
#define MASK_DMACC1DestAddr   0xFFFFFFFF

#ifdef TWOMASTERCONFIG
  #define MASK_DMACC1LLIReg     0xFFFFFFFD
#else
  #define MASK_DMACC1LLIReg     0xFFFFFFFC
#endif TWOMASTERCONFIG

#define MASK_DMACC1Control    0xFFFFF000
#define MASK_DMACC1Config     0x0005FFFF
#define MASK_DMACC2SrcAddr    0xFFFFFFFF
#define MASK_DMACC2DestAddr   0xFFFFFFFF
#define MASK_DMACC2LLIReg     0xFFFFFFFD
#define MASK_DMACC2Control    0xFFFFF000
#define MASK_DMACC2Config     0x0005FFFF
#define MASK_DMACC3SrcAddr    0xFFFFFFFF
#define MASK_DMACC3DestAddr   0xFFFFFFFF
#define MASK_DMACC3LLIReg     0xFFFFFFFD
#define MASK_DMACC3Control    0xFFFFF000
#define MASK_DMACC3Config     0x0005FFFF
#define MASK_DMACC4SrcAddr    0xFFFFFFFF
#define MASK_DMACC4DestAddr   0xFFFFFFFF
#define MASK_DMACC4LLIReg     0xFFFFFFFD
#define MASK_DMACC4Control    0xFFFFF000
#define MASK_DMACC4Config     0x0005FFFF
#define MASK_DMACC5SrcAddr    0xFFFFFFFF
#define MASK_DMACC5DestAddr   0xFFFFFFFF
#define MASK_DMACC5LLIReg     0xFFFFFFFD
#define MASK_DMACC5Control    0xFFFFF000
#define MASK_DMACC5Config     0x0005FFFF
#define MASK_DMACC6SrcAddr    0xFFFFFFFF
#define MASK_DMACC6DestAddr   0xFFFFFFFF
#define MASK_DMACC6LLIReg     0xFFFFFFFD
#define MASK_DMACC6Control    0xFFFFF000
#define MASK_DMACC6Config     0x0005FFFF
#define MASK_DMACC7SrcAddr    0xFFFFFFFF
#define MASK_DMACC7DestAddr   0xFFFFFFFF
#define MASK_DMACC7LLIReg     0xFFFFFFFD
#define MASK_DMACC7Control    0xFFFFF000
#define MASK_DMACC7Config     0x0005FFFF
#define MASK_DMACTCR          0x00000001
#define MASK_DMACITOP1        0x0000FFFF
#define MASK_DMACITOP2        0x0000FFFF
#define MASK_DMACITOP3        0x00000003

/******************************************************************************/
/***************************** GENERAL PARAMETERS *****************************/
/******************************************************************************/
#define ZERO                  0x00000000
#define NoMask                0xFFFFFFFF
#define MaskAll               0x00000000

/******************************************************************************/
/***************************** DATA CONSTANTS *********************************/
/******************************************************************************/
#define DMACDISABLE           0xFFFFFFFE
#define DMACENABLE            0x00000001
#define TESTMODE              0x00000001
#define DMACHALT              0x00040000
#define CHXENABLE             0x00000001
#define CHXDISABLE            0x00000000

#define CH0ENABLED            0x00000001
#define CH1ENABLED            0x00000002
#define CH2ENABLED            0x00000004
#define CH3ENABLED            0x00000008
#define CH4ENABLED            0x00000010
#define CH5ENABLED            0x00000020
#define CH6ENABLED            0x00000040
#define CH7ENABLED            0x00000080

/******************************************************************************/
/***************************** SOURCE BURST VALUES ****************************/
/******************************************************************************/
#define SBURST1               0x00000000
#define SBURST4               0x00001000
#define SBURST8               0x00002000
#define SBURST16              0x00003000
#define SBURST32              0x00004000
#define SBURST64              0x00005000
#define SBURST128             0x00006000
#define SBURST256             0x00007000

/******************************************************************************/
/************************* DESTINATION BURST VALUES ***************************/
/******************************************************************************/
#define DBURST1               0x00000000
#define DBURST4               0x00008000
#define DBURST8               0x00010000
#define DBURST16              0x00018000
#define DBURST32              0x00020000
#define DBURST64              0x00028000
#define DBURST128             0x00030000
#define DBURST256             0x00038000

/******************************************************************************/
/*************************** SOURCE WIDTH VALUES ******************************/
/******************************************************************************/
#define SWIDTH8               0x00000000
#define SWIDTH16              0x00040000
#define SWIDTH32              0x00080000

/******************************************************************************/
/************************ DESTINATION WIDTH VALUES ****************************/
/******************************************************************************/
#define DWIDTH8               0x00000000
#define DWIDTH16              0x00200000
#define DWIDTH32              0x00400000

/******************************************************************************/
/**************************** SOURCE MASTER VALUES ****************************/
/******************************************************************************/
#define SMASTER0              0x00000000
#define SMASTER1              0x01000000

/******************************************************************************/
/*********************** DESTINATION MASTER VALUES ****************************/
/******************************************************************************/
#define DMASTER0              0x00000000
#define DMASTER1              0x02000000

/******************************************************************************/
/****************************** LLI MASTER VALUES *****************************/
/******************************************************************************/
#define LLIMASTER0            0x00000000
#define LLIMASTER1            0x00000001

/******************************************************************************/
/*************************** SOURCE ADDRESS INCREMENT *************************/
/******************************************************************************/
#define SNONINCR              0x00000000
#define SINCR                 0x04000000

/******************************************************************************/
/************************* DESTINATION ADDRESS INCREMENT **********************/
/******************************************************************************/
#define DNONINCR              0x00000000
#define DINCR                 0x08000000

/******************************************************************************/
/*********************** INTERRUPT ENABLE AND MASKS ***************************/
/******************************************************************************/
#define INTTCEN               0x80000000
#define INTTCDI               0x00000000

#define INTTCMASK             0x00008000
#define INTTCNOMASK           0x00000000

#define INTERRMASK            0x00004000
#define INTERRNOMASK          0x00000000

/******************************************************************************/
/******************************* DMA TRANSFER TYPE ****************************/
/******************************************************************************/
#define M2MDMAC               0x00000000
#define M2PDMAC               0x00000800
#define P2MDMAC               0x00001000
#define P2PDMAC               0x00001800
#define P2PDP                 0x00002000
#define M2PDP                 0x00002800
#define P2MSP                 0x00003000
#define P2PSP                 0x00003800

/******************************************************************************/
/****************************** LOCK CONTROL **********************************/
/******************************************************************************/
#define LOCK                  0x00010000
#define NONLOCK               0x00000000

/******************************************************************************/
/************************** PROTECTION CONTROL BITS ***************************/
/******************************************************************************/
#define pbc                   0
#define pbC                   1
#define pBc                   2
#define pBC                   3
#define Pbc                   4
#define PbC                   5
#define PBc                   6
#define PBC                   7

#define Dmacpbc               0x00000000
#define DmacpbC               0x10000000
#define DmacpBc               0x20000000
#define DmacpBC               0x30000000
#define DmacPbc               0x40000000
#define DmacPbC               0x50000000
#define DmacPBc               0x60000000
#define DmacPBC               0x70000000

/******************************************************************************/
/****************************** LLI  CONTROL **********************************/
/******************************************************************************/
#define NoLLI                 0x00000000

/******************************************************************************/
/*************************** SOURCE PERIPHERALS *******************************/
/******************************************************************************/
#define SrcPeriph0            0x00000000
#define SrcPeriph1            0x00000002
#define SrcPeriph2            0x00000004
#define SrcPeriph3            0x00000006
#define SrcPeriph4            0x00000008
#define SrcPeriph5            0x0000000A
#define SrcPeriph6            0x0000000C
#define SrcPeriph7            0x0000000E
#define SrcPeriph8            0x00000010
#define SrcPeriph9            0x00000012
#define SrcPeriph10           0x00000014
#define SrcPeriph11           0x00000016
#define SrcPeriph12           0x00000018
#define SrcPeriph13           0x0000001A
#define SrcPeriph14           0x0000001C
#define SrcPeriph15           0x0000001E

/******************************************************************************/
/************************* DESTINATION PERIPHERALS ****************************/
/******************************************************************************/
#define DestPeriph0           0x00000000
#define DestPeriph1           0x00000040
#define DestPeriph2           0x00000080
#define DestPeriph3           0x000000C0
#define DestPeriph4           0x00000100
#define DestPeriph5           0x00000140
#define DestPeriph6           0x00000180
#define DestPeriph7           0x000001C0
#define DestPeriph8           0x00000200
#define DestPeriph9           0x00000240
#define DestPeriph10          0x00000280
#define DestPeriph11          0x000002C0
#define DestPeriph12          0x00000300
#define DestPeriph13          0x00000340
#define DestPeriph14          0x00000380
#define DestPeriph15          0x000003C0

/******************************************************************************/
/****** PROGRAMMING DEFAULT RESPONSE VALUES FOR MEMORY/PERIPHERAL MODLES ******/
/******************************************************************************/
/*** ---------------------------------------------------------------------- ***/
/***  Constant                 Description                                  ***/
/*** ---------------------------------------------------------------------- ***/
/*** MEMORYENABLE    - Enabling the Memory model.                           ***/
/*** MEMORYDISABLE   - Disabling the Memory model.                          ***/
/*** MEMORYRESET     - Reset all the registers in the Memory model.         ***/
/*** MEMORYRSTCLR    - Clear reset bit of the Memory model.                 ***/
/***                                                                        ***/
/*** PERIPHENABLE    - Enabling the Peripheral model.                       ***/
/*** PERIPHDISABLE   - Disabling the Peripheral model.                      ***/
/*** PERIPHRESET     - Reset all the registers in the Peripheral model.     ***/
/*** PERIPHRSTCLR    - Clear reset bit of the Peripheral model.             ***/
/***                                                                        ***/
/*** DEFOKOAY        - AHB okay as the default response.                    ***/
/*** DEFERROR        - AHB error as the default response.                   ***/
/*** DEFRETRY        - AHB retry as the default response.                   ***/
/*** DEFSPLIT        - AHB split as the default response.                   ***/
/***                                                                        ***/
/*** DEFRSCOUNT0     - 1 retry/split as the default response.               ***/
/*** DEFRSCOUNT1     - 2 retry/split as the default response.               ***/
/*** DEFRSCOUNT2     - 3 retry/split as the default response.               ***/
/*** DEFRSCOUNT3     - 4 retry/split as the default response.               ***/
/***                                                                        ***/
/*** DEFWAIT0 -      - Insert 1 - 16 wait cycles with the default response. ***/
/*** DEFWAIT15                                                              ***/
/******************************************************************************/
#define MEMORYENABLE  0x80000000
#define MEMORYDISABLE 0x00000000
#define MEMORYRESET   0x40000000
#define MEMORYRSTCLR  0x00000000

#define PERIPHENABLE  0x80000000
#define PERIPHDISABLE 0x00000000
#define PERIPHRESET   0x40000000
#define PERIPHRSTCLR  0x00000000

#define DEFOKAY     0x00000000
#define DEFERROR    0x00000001
#define DEFRETRY    0x00000002
#define DEFSPLIT    0x00000003

#define DEFRSCOUNT0 0x00000000
#define DEFRSCOUNT1 0x00000040
#define DEFRSCOUNT2 0x00000080
#define DEFRSCOUNT3 0x000000C0

#define DEFWAIT0    0x00000000
#define DEFWAIT1    0x00000004
#define DEFWAIT2    0x00000008
#define DEFWAIT3    0x0000000C
#define DEFWAIT4    0x00000010
#define DEFWAIT5    0x00000014
#define DEFWAIT6    0x00000018
#define DEFWAIT7    0x0000001C
#define DEFWAIT8    0x00000020
#define DEFWAIT9    0x00000024
#define DEFWAIT10   0x00000028
#define DEFWAIT11   0x0000002C
#define DEFWAIT12   0x00000030
#define DEFWAIT13   0x00000034
#define DEFWAIT14   0x00000038
#define DEFWAIT15   0x0000003C

/******************************************************************************/
/******* PROGRAMMING CONTROL RESIGTERS OF THE MEMORY/PERIPHERAL MODLES ********/
/******************************************************************************/
/*** ---------------------------------------------------------------------- ***/
/***  Constant                 Description                                  ***/
/*** ---------------------------------------------------------------------- ***/
/*** REGENABLE       - Enabling the control register.                       ***/
/***                                                                        ***/
/*** ADDRBASE        - Programmed response to be returned based on address. ***/
/*** DATABASE        - Programmed response to be returned based on data.    ***/
/***                                                                        ***/
/*** PGMBYTE         - Byte data transfer is expected.                      ***/
/*** PGMHWORD        - Half-word data transfer is expected.                 ***/
/*** PGMWORD         - Word data transfer is expected.                      ***/
/***                                                                        ***/
/*** VALIDLSB0 -     - 1 - 16 bits, out of the allocated 16 bits, are       ***/
/*** VALIDLSB15        valid for the programmed response.                   ***/
/***                                                                        ***/
/*** PGMOKOAY        - AHB okay as the programed response.                  ***/
/*** PGMERROR        - AHB error as the programed response.                 ***/
/*** PGMRETRY        - AHB retry as the programed response.                 ***/
/*** PGMSPLIT        - AHB split as the programed response.                 ***/
/***                                                                        ***/
/*** PGMRSCOUNT0     - 1 retry/split as the programmed response.            ***/
/*** PGMRSCOUNT1     - 2 retry/split as the programmed response.            ***/
/*** PGMRSCOUNT2     - 3 retry/split as the programmed response.            ***/
/*** PGMRSCOUNT3     - 4 retry/split as the programmed response.            ***/
/***                                                                        ***/
/*** PGMWAIT0 -      - Insert 1 - 16 wait cycles with the programmed        ***/
/*** PGMWAIT15         response.                                            ***/
/******************************************************************************/
#define REGENABLE   0x80000000

#define ADDRBASE    0x00000000
#define DATABASE    0x40000000

#define PGMBYTE     0x00000000
#define PGMHWORD    0x10000000
#define PGMWORD     0x20000000

#define VALIDLSB0   0x00000000
#define VALIDLSB1   0x01000000
#define VALIDLSB2   0x02000000
#define VALIDLSB3   0x03000000
#define VALIDLSB4   0x04000000
#define VALIDLSB5   0x05000000
#define VALIDLSB6   0x06000000
#define VALIDLSB7   0x07000000
#define VALIDLSB8   0x08000000
#define VALIDLSB9   0x09000000
#define VALIDLSB10  0x0A000000
#define VALIDLSB11  0x0B000000
#define VALIDLSB12  0x0C000000
#define VALIDLSB13  0x0D000000
#define VALIDLSB14  0x0E000000
#define VALIDLSB15  0x0F000000

#define PGMOKAY     0x00000000
#define PGMERROR    0x00010000
#define PGMRETRY    0x00020000
#define PGMSPLIT    0x00030000

#define PGMRSCOUNT0 0x00000000
#define PGMRSCOUNT1 0x00000040
#define PGMRSCOUNT2 0x00000080
#define PGMRSCOUNT3 0x000000C0

#define PGMWAIT0    0x00000000
#define PGMWAIT1    0x00000004
#define PGMWAIT2    0x00000008
#define PGMWAIT3    0x0000000C
#define PGMWAIT4    0x00000010
#define PGMWAIT5    0x00000014
#define PGMWAIT6    0x00000018
#define PGMWAIT7    0x0000001C
#define PGMWAIT8    0x00000020
#define PGMWAIT9    0x00000024
#define PGMWAIT10   0x00000028
#define PGMWAIT11   0x0000002C
#define PGMWAIT12   0x00000030
#define PGMWAIT13   0x00000034
#define PGMWAIT14   0x00000038
#define PGMWAIT15   0x0000003C

/******************************************************************************/
/************************* Multichannel parameters ****************************/
/******************************************************************************/
#define DataControl     0x40000000
#define BYTEControl     0x00000000
#define HWORDControl    0x10000000
#define WORDControl     0x20000000

#define MASTER1  0
#define MASTER2  1
#define ADDRINCR "I"

#define PGMWAITCYC1      0x00040000
#define PGMWAITCYC2      0x00080000
#define PGMWAITCYC3      0x000C0000
#define PGMWAITCYC4      0x00100000
#define PGMWAITCYC5      0x00140000
#define PGMWAITCYC6      0x00180000
#define PGMWAITCYC7      0x001C0000
#define PGMWAITCYC8      0x00200000
#define PGMWAITCYC9      0x00240000
#define PGMWAITCYC10     0x00280000
#define PGMWAITCYC11     0x002C0000
#define PGMWAITCYC12     0x00300000
#define PGMWAITCYC13     0x00340000
#define PGMWAITCYC14     0x00380000
#define PGMWAITCYC15     0x003C0000

#define PGMRSRSP1        0x00400000
#define PGMRSRSP2        0x00800000
#define PGMRSRSP3        0x00C00000

/************************************ End *************************************/
