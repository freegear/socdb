/* --=========================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 2001-2002 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
--
-- -----------------------------------------------------------------------------
-- Version and Release Control Information:
--
-- File Name              : Mpmc.h.rca
-- File Revision          : 1.7 
--
-- Release Information    : PrimeCell(TM)-PL172-r2p3-00rel0
--
-- -----------------------------------------------------------------------------
-- Purpose : This file contains the register offsets and other
--           definitions for the Mpmc.c functional test code.
--
-- --=========================================================================*/

/******************************************************************************/
/******************************************************************************/
/****************************** TEST VARIABLES ********************************/
/******************************************************************************/
/******************************************************************************/



/******************************************************************************/
/****************************** MASK VALUES ***********************************/
/******************************************************************************/
#define MaskALL                  0xFFFFFFFF
#define BUnMask0                 0x000000FF
#define BUnMask1                 0x0000FF00
#define BUnMask2                 0x00FF0000
#define BUnMask3                 0xFF000000
#define HWDMask                  0x0000FFFF
#define Address_SNP              0x03FFFFFF
/******************************************************************************/
/****************************** GLOBAL VARIABLE *******************************/
/******************************************************************************/
/*** These variables are used by the verification test code to get random   ***/
/*** data from datagen function                                             ***/
unsigned byteset1[65536];
unsigned byteset2[65536];
unsigned byteset3[65536];
/******************************************************************************/
/********************** GENERAL VARIABLE DECLARATION **************************/
/******************************************************************************/
#define MPMCDISABLE              0xFFFFFFFE
#define TESTDIS                  0xFFFFFFFE
#define Data_0s                  0x00000000
#define Data_Fs                  0xFFFFFFFF
#define ZERO                     0x00000000
#define MPMC_BASE                0x80000000
#define INFO                     0
#define SEED                     27
#define MPMC_REGADDR_LIMIT       (MPMC_BASE + 0xFFC)

/***                           For Word Accesses                            ***/
#define W0                       0x00000000
#define W1                       0x00000004
#define W2                       0x00000008
#define W3                       0x0000000C
#define WInc                     0x00000004

/***                         For HalfWord Accesses                          ***/
#define HW0                      0x00000000
#define HW1                      0x00000002
#define HWInc                    0x00000002

/***                           For Byte Accesses                            ***/
#define B0                       0x00000000
#define B1                       0x00000001
#define B2                       0x00000002
#define B3                       0x00000003
#define BInc                     0x00000001

/******************************************************************************/
/******************************************************************************/
/*********************************** MPMC *************************************/
/******************************************************************************/
/******************************************************************************/



/******************************************************************************/
/*************************** MPMC REGISTERS ***********************************/
/******************************************************************************/

/* ---------------------------------------------------------------------------*/
/* The Offset values are from the MPMC register base address.                 */
/* ---------------------------------------------------------------------------*/
/******************************************************************************/
/*============================================================================*/
/* Register                 Offset                R/W              Size       */
/*============================================================================*/
/* MPMCControl              0x000                R/W               3-0        */
/* MPMCStatus               0x004                 R                2-0        */
/* MPMCConfig               0x008                R/W              9-8 ,0      */
/* MPMCDyCntl               0x020                R/W          14-13,8-7,2-0   */
/* MPMCDyRef                0x024                R/W              10-0        */
/* MPMCDyRdCfg              0x028                R/W               2-0        */
/* MPMCDytRP                0x030                R/W               3-0        */
/* MPMCDytRAS               0x034                R/W               3-0        */
/* MPMCDytSREX              0x038                R/W               3-0        */
/* MPMCDytAPR               0x03C                R/W               3-0        */
/* MPMCDytDAL               0x040                R/W               3-0        */
/* MPMCDytWR                0x044                R/W               3-0        */
/* MPMCDytRC                0x048                R/W               4-0        */
/* MPMCDytRFC               0x04C                R/W               4-0        */
/* MPMCDytXSR               0x050                R/W               4-0        */
/* MPMCDytRRD               0x054                R/W               4-0        */
/* MPMCDytMRD               0x058                R/W               4-0        */
/* MPMCStExdWt              0x080                R/W               9-0        */
/* MPMCDyConfig0            0x100                R/W          20-18,15-14,12  */
/*                                                              9-7,4-3,0     */
/* MPMCDyRasCas0            0x104                R/W              9-8,1-0     */
/* MPMCDyConfig1            0x120                R/W          20-18,15-14,12  */
/*                                                              9-7,4-3,0     */
/* MPMCDyRasCas1            0x124                R/W              9-8,1-0     */
/* MPMCDyConfig2            0x140                R/W          20-18,15-14,12  */
/*                                                              9-7,4-3,0     */
/* MPMCDyRasCas2            0x144                R/W              9-8,1-0     */

/* MPMCDyConfig3            0x160                R/W          20-18,15-14,12  */
/*                                                              9-7,4-3,0     */
/* MPMCDyRasCas3            0x164                R/W              9-8,1-0     */
/* MPMCStConfig0            0x200                R/W          20-18,8-6,3,1-0 */
/* MPMCStWtWen0             0x204                R/W               3-0        */
/* MPMCStWtOen0             0x208                R/W               3-0        */
/* MPMCStWtRd0              0x20C                R/W               4-0        */
/* MPMCStWtPg0              0x210                R/W               4-0        */
/* MPMCStWtWr0              0x214                R/W               4-0        */
/* MPMCStWtTurn0            0x218                R/W               3-0        */
/* MPMCStConfig1            0x220                R/W         20-18,8-6,3,1-0  */
/* MPMCStWtWen1             0x224                R/W               3-0        */
/* MPMCStWtOen1             0x228                R/W               3-0        */
/* MPMCStWtRd1              0x22C                R/W               4-0        */
/* MPMCStWtPg1              0x230                R/W               4-0        */
/* MPMCStWtWr1              0x234                R/W               4-0        */
/* MPMCStWtTurn1            0x238                R/W               3-0        */
/* MPMCStConfig2            0x240                R/W          20-18,8-6,3,1-0 */
/* MPMCStWtWen2             0x244                R/W               3-0        */
/* MPMCStWtOen2             0x248                R/W               3-0        */
/* MPMCStWtRd2              0x24C                R/W               4-0        */
/* MPMCStWtPg2              0x250                R/W               4-0        */
/* MPMCStWtWr2              0x254                R/W               4-0        */
/* MPMCStWtTurn2            0x258                R/W               3-0        */
/* MPMCStConfig3            0x260                R/W          20-18,8-6,3,1-0 */
/* MPMCStWtWen3             0x264                R/W               3-0        */
/* MPMCStWtOen3             0x268                R/W               3-0        */
/* MPMCStWtRd3              0x26C                R/W               4-0        */
/* MPMCStWtPg3              0x270                R/W               4-0        */
/* MPMCStWtWr3              0x274                R/W               4-0        */
/* MPMCStWtTurn3            0x278                R/W               3-0        */
/* MPMCITCR                 0xF00                R/W                 0        */
/* MPMCITIP                 0xF20                R/W                 0        */
/* MPMCITOP                 0xF40                R/W                 0        */
/* MPMCPeriphId4            0xFD0                R/W               7-0        */
/* MPMCPeriphId5            0xFD4                R/W               7-0        */
/* MPMCPeriphId6            0xFD8                R/W               7-0        */
/* MPMCPeriphId7            0xFDC                R/W               7-0        */
/* MPMCPeriphId0            0xFE0                R/W               7-0        */
/* MPMCPeriphId1            0xFE4                R/W               7-0        */
/* MPMCPeriphId2            0xFE8                R/W               7-0        */
/* MPMCPeriphId3            0xFEC                R/W               7-0        */
/* MPMCPCellId0             0xFF0                R/W               7-0        */
/* MPMCPCellId1             0xFF4                R/W               7-0        */
/* MPMCPCellId2             0xFF8                R/W               7-0        */
/* MPMCPCellId3             0xFFC                R/W               7-0        */
/******************************************************************************/
#define MPMCControl              (MPMC_BASE + 0x000)
#define MPMCStatus               (MPMC_BASE + 0x004)
#define MPMCConfig               (MPMC_BASE + 0x008)
#define MPMCDyCntl               (MPMC_BASE + 0x020)
#define MPMCDyRef                (MPMC_BASE + 0x024)
#define MPMCDyRdCfg              (MPMC_BASE + 0x028)

#define MPMCDytRP                (MPMC_BASE + 0x030)
#define MPMCDytRAS               (MPMC_BASE + 0x034)
#define MPMCDytSREX              (MPMC_BASE + 0x038)
#define MPMCDytAPR               (MPMC_BASE + 0x03C)
#define MPMCDytDAL               (MPMC_BASE + 0x040)
#define MPMCDytWR                (MPMC_BASE + 0x044)
#define MPMCDytRC                (MPMC_BASE + 0x048)
#define MPMCDytRFC               (MPMC_BASE + 0x04C)
#define MPMCDytXSR               (MPMC_BASE + 0x050)
#define MPMCDytRRD               (MPMC_BASE + 0x054)
#define MPMCDytMRD               (MPMC_BASE + 0x058)
#define MPMCStExdWt              (MPMC_BASE + 0x080)
#define MPMCDyConfig0            (MPMC_BASE + 0x100)
#define MPMCDyRasCas0            (MPMC_BASE + 0x104)

#define MPMCDyConfig1            (MPMC_BASE + 0x120)
#define MPMCDyRasCas1            (MPMC_BASE + 0x124)

#define MPMCDyConfig2            (MPMC_BASE + 0x140)
#define MPMCDyRasCas2            (MPMC_BASE + 0x144)

#define MPMCDyConfig3            (MPMC_BASE + 0x160)
#define MPMCDyRasCas3            (MPMC_BASE + 0x164)

#define MPMCStConfig0            (MPMC_BASE + 0x200)
#define MPMCStWtWen0             (MPMC_BASE + 0x204)
#define MPMCStWtOen0             (MPMC_BASE + 0x208)
#define MPMCStWtRd0              (MPMC_BASE + 0x20C)
#define MPMCStWtPg0              (MPMC_BASE + 0x210)
#define MPMCStWtWr0              (MPMC_BASE + 0x214)
#define MPMCStWtTurn0            (MPMC_BASE + 0x218)

#define MPMCStConfig1            (MPMC_BASE + 0x220)
#define MPMCStWtWen1             (MPMC_BASE + 0x224)
#define MPMCStWtOen1             (MPMC_BASE + 0x228)
#define MPMCStWtRd1              (MPMC_BASE + 0x22C)
#define MPMCStWtPg1              (MPMC_BASE + 0x230)
#define MPMCStWtWr1              (MPMC_BASE + 0x234)
#define MPMCStWtTurn1            (MPMC_BASE + 0x238)

#define MPMCStConfig2            (MPMC_BASE + 0x240)
#define MPMCStWtWen2             (MPMC_BASE + 0x244)
#define MPMCStWtOen2             (MPMC_BASE + 0x248)
#define MPMCStWtRd2              (MPMC_BASE + 0x24C)
#define MPMCStWtPg2              (MPMC_BASE + 0x250)
#define MPMCStWtWr2              (MPMC_BASE + 0x254)
#define MPMCStWtTurn2            (MPMC_BASE + 0x258)

#define MPMCStConfig3            (MPMC_BASE + 0x260)
#define MPMCStWtWen3             (MPMC_BASE + 0x264)
#define MPMCStWtOen3             (MPMC_BASE + 0x268)
#define MPMCStWtRd3              (MPMC_BASE + 0x26C)
#define MPMCStWtPg3              (MPMC_BASE + 0x270)
#define MPMCStWtWr3              (MPMC_BASE + 0x274)
#define MPMCStWtTurn3            (MPMC_BASE + 0x278)

#define MPMCITCR                 (MPMC_BASE + 0xF00)
#define MPMCITIP                 (MPMC_BASE + 0xF20)
#define MPMCITOP                 (MPMC_BASE + 0xF40)

#define MPMCPeriphId4            (MPMC_BASE + 0xFD0)
#define MPMCPeriphId5            (MPMC_BASE + 0xFD4)
#define MPMCPeriphId6            (MPMC_BASE + 0xFD8)
#define MPMCPeriphId7            (MPMC_BASE + 0xFDC)
#define MPMCPeriphId0            (MPMC_BASE + 0xFE0)
#define MPMCPeriphId1            (MPMC_BASE + 0xFE4)
#define MPMCPeriphId2            (MPMC_BASE + 0xFE8)
#define MPMCPeriphId3            (MPMC_BASE + 0xFEC)

#define MPMCPCellId0             (MPMC_BASE + 0xFF0)
#define MPMCPCellId1             (MPMC_BASE + 0xFF4)
#define MPMCPCellId2             (MPMC_BASE + 0xFF8)
#define MPMCPCellId3             (MPMC_BASE + 0xFFC)

/******************************************************************************/
/********************* RESET VALUES OF READ ONLY REGISTERS ********************/
/******************************************************************************/
#define RDO_MPMCStatus           0x00000000
#define RDO_MPMCPeriphId4        0x00000033
#define RDO_MPMCPeriphId5        0x00000000
#define RDO_MPMCPeriphId6        0x00000000
#define RDO_MPMCPeriphId7        0x00000000
#define RDO_MPMCPeriphId0        0x00000072
#define RDO_MPMCPeriphId1        0x00000011
#define RDO_MPMCPeriphId2        0x00000024
#define RDO_MPMCPeriphId3        0x00000007
#define RDO_MPMCPCellId0         0x0000000D
#define RDO_MPMCPCellId1         0x000000F0
#define RDO_MPMCPCellId2         0x00000005
#define RDO_MPMCPCellId3         0x000000B1 

/******************************************************************************/
/******************* HRESETn VALUES OF READ/WRITE REGISTERS *******************/
/******************************************************************************/
#define HRST_MPMCControl         0x00000001
#define HRST_MPMCITCR            0x00000000

#define HRST_MPMCITIP            0x00000008
#define HRST_MPMCITOP            0x00000001
#define HRST_MPMCPeriphId4       0x00000033
#define HRST_MPMCPeriphId5       0x00000000   
#define HRST_MPMCPeriphId6       0x00000000
#define HRST_MPMCPeriphId7       0x00000000
#define HRST_MPMCPeriphId0       0x00000072
#define HRST_MPMCPeriphId1       0x00000011
#define HRST_MPMCPeriphId2       0x00000024
#define HRST_MPMCPeriphId3       0x00000007

#define HRST_MPMCPCellId0        0x0000000D
#define HRST_MPMCPCellId1        0x000000F0
#define HRST_MPMCPCellId2        0x00000005
#define HRST_MPMCPCellId3        0x000000B1
/******************************************************************************/
/********************* nPOR VALUES OF READ/WRITE REGISTERS ********************/
/******************************************************************************/
#define PRST_MPMCControl         0x00000003
#define PRST_MPMCStatus          0x00000005 
#define PRST_MPMCConfig          0x00000000
#define PRST_MPMCDyCntl          0x00000006
#define PRST_MPMCDyRef           0x00000000
#define PRST_MPMCDyRdCfg         0x00000000
#define PRST_MPMCDytRP           0x0000000F
#define PRST_MPMCDytRAS          0x0000000F
#define PRST_MPMCDytSREX         0x0000000F
#define PRST_MPMCDytAPR          0x0000000F
#define PRST_MPMCDytDAL          0x0000000F
#define PRST_MPMCDytWR           0x0000000F 
#define PRST_MPMCDytRC           0x0000001F
#define PRST_MPMCDytRFC          0x0000001F
#define PRST_MPMCDytXSR          0x0000001F
#define PRST_MPMCDytRRD          0x0000000F
#define PRST_MPMCDytMRD          0x0000000F
#define PRST_MPMCStExdWt         0x00000000
#define PRST_MPMCDyConfig0       0x00000000
#define PRST_MPMCDyRasCas0       0x00000303
#define PRST_MPMCDyConfig1       0x00000000
#define PRST_MPMCDyRasCas1       0x00000303
#define PRST_MPMCDyConfig2       0x00000000
#define PRST_MPMCDyRasCas2       0x00000303
#define PRST_MPMCDyConfig3       0x00000000
#define PRST_MPMCDyRasCas3       0x00000303
#define PRST_MPMCStConfig0       0x00000000
#define PRST_MPMCStWtWen0        0x00000000
#define PRST_MPMCStWtOen0        0x00000000
#define PRST_MPMCStWtRd0         0x0000001F
#define PRST_MPMCStWtPg0         0x0000001F
#define PRST_MPMCStWtWr0         0x0000001F
#define PRST_MPMCStWtTurn0       0x0000000F
#define PRST_MPMCStConfig1       0x00000002
#define PRST_MPMCStWtWen1        0x00000000
#define PRST_MPMCStWtOen1        0x00000000
#define PRST_MPMCStWtRd1         0x0000001F
#define PRST_MPMCStWtPg1         0x0000001F
#define PRST_MPMCStWtWr1         0x0000001F
#define PRST_MPMCStWtTurn1       0x0000000F
#define PRST_MPMCStConfig2       0x00000000
#define PRST_MPMCStWtWen2        0x00000000
#define PRST_MPMCStWtOen2        0x00000000
#define PRST_MPMCStWtRd2         0x0000001F
#define PRST_MPMCStWtPg2         0x0000001F
#define PRST_MPMCStWtWr2         0x0000001F
#define PRST_MPMCStWtTurn2       0x0000000F
#define PRST_MPMCStConfig3       0x00000000
#define PRST_MPMCStWtWen3        0x00000000
#define PRST_MPMCStWtOen3        0x00000000
#define PRST_MPMCStWtRd3         0x0000001F
#define PRST_MPMCStWtPg3         0x0000001F
#define PRST_MPMCStWtWr3         0x0000001F
#define PRST_MPMCStWtTurn3       0x0000000F
#define PRST_MPMCITCR            0x00000000
#define PRST_MPMCPeriphId4       0x00000033
#define PRST_MPMCPeriphId5       0x00000000
#define PRST_MPMCPeriphId6       0x00000000
#define PRST_MPMCPeriphId7       0x00000000
#define PRST_MPMCPeriphId0       0x00000072
#define PRST_MPMCPeriphId1       0x00000011
#define PRST_MPMCPeriphId2       0x00000024
#define PRST_MPMCPeriphId3       0x00000007
#define PRST_MPMCPCellId0        0x0000000D
#define PRST_MPMCPCellId1        0x000000F0
#define PRST_MPMCPCellId2        0x00000005
#define PRST_MPMCPCellId3        0x000000B1
 
/******************************************************************************/
/************************** REGISTER MASK VALUES ******************************/
/******************************************************************************/
#define MASK_MPMCControl         0x00000006
#define MASK_MPMCConfig          0x00000101
#define MASK_MPMCDyCntl          0x0000E1A7
#define MASK_MPMCDyRef           0x000007FF
#define MASK_MPMCDyRdCfg         0x00000003
#define MASK_MPMCDytRP           0x0000000F
#define MASK_MPMCDytRAS          0x0000000F
#define MASK_MPMCDytSREX         0x0000000F
#define MASK_MPMCDytAPR          0x0000000F
#define MASK_MPMCDytDAL          0x0000000F
#define MASK_MPMCDytWR           0x0000000F
#define MASK_MPMCDytRC           0x0000001F
#define MASK_MPMCDytRFC          0x0000001F
#define MASK_MPMCDytXSR          0x0000001F
#define MASK_MPMCDytRRD          0x0000000F
#define MASK_MPMCDytMRD          0x0000000F
#define MASK_MPMCStExdWt         0x000003FF


#define MASK_MPMCDyConfig0       0x00185F98
#define MASK_MPMCDyRasCas0       0x00000303
#define MASK_MPMCDyConfig1       0x00185F98
#define MASK_MPMCDyRasCas1       0x00000303
#define MASK_MPMCDyConfig2       0x00185F98
#define MASK_MPMCDyRasCas2       0x00000303
#define MASK_MPMCDyConfig3       0x00185F98
#define MASK_MPMCDyRasCas3       0x00000303
#define MASK_MPMCStConfig0       0x001801CB
#define MASK_MPMCStWtWen0        0x0000000F
#define MASK_MPMCStWtOen0        0x0000000F
#define MASK_MPMCStWtRd0         0x0000001F
#define MASK_MPMCStWtPg0         0x0000001F
#define MASK_MPMCStWtWr0         0x0000001F
#define MASK_MPMCStWtTurn0       0x0000000F
#define MASK_MPMCStConfig1       0x001801CB
#define MASK_MPMCStWtWen1        0x0000000F
#define MASK_MPMCStWtOen1        0x0000000F
#define MASK_MPMCStWtRd1         0x0000001F
#define MASK_MPMCStWtPg1         0x0000001F
#define MASK_MPMCStWtWr1         0x0000001F
#define MASK_MPMCStWtTurn1       0x0000000F
#define MASK_MPMCStConfig2       0x001801CB
#define MASK_MPMCStWtWen2        0x0000000F
#define MASK_MPMCStWtOen2        0x0000000F
#define MASK_MPMCStWtRd2         0x0000001F
#define MASK_MPMCStWtPg2         0x0000001F
#define MASK_MPMCStWtWr2         0x0000001F
#define MASK_MPMCStWtTurn2       0x0000000F
#define MASK_MPMCStConfig3       0x001801CB
#define MASK_MPMCStWtWen3        0x0000000F
#define MASK_MPMCStWtOen3        0x0000000F
#define MASK_MPMCStWtRd3         0x0000001F
#define MASK_MPMCStWtPg3         0x0000001F
#define MASK_MPMCStWtWr3         0x0000001F
#define MASK_MPMCStWtTurn3       0x0000000F
#define MASK_MPMCITCR            0x00000000
#define MASK_MPMCITIP            0x000003FE
#define MASK_MPMCITOP            0x00000003
/******************************************************************************/
/************************ MASK VALUES FOR HRESETn VALUES **********************/
/******************************************************************************/
#define HMASK_MPMCControl         0x00000005
#define HMASK_MPMCITCR            0x00000001
#define HMASK_MPMCITIP            0x000000FF
#define HMASK_MPMCITOP            0x00000003

#define HMASK_MPMCPeriphId4       0x000000FF
#define HMASK_MPMCPeriphId5       0x000000FF
#define HMASK_MPMCPeriphId6       0x000000FF
#define HMASK_MPMCPeriphId7       0x000000FF
#define HMASK_MPMCPeriphId0       0x000000FF
#define HMASK_MPMCPeriphId1       0x000000FF
#define HMASK_MPMCPeriphId2       0x000000FF
#define HMASK_MPMCPeriphId3       0x000000FF
#define HMASK_MPMCPCellId0        0x000000FF
#define HMASK_MPMCPCellId1        0x000000FF
#define HMASK_MPMCPCellId2        0x000000FF
#define HMASK_MPMCPCellId3        0x000000FF
/******************************************************************************/
/************************ MASK VALUES FOR nPOR VALUES *************************/
/******************************************************************************/
#define PMASK_MPMCControl         0x00000003
#define PMASK_MPMCStatus          0x00000007
#define PMASK_MPMCConfig          0x00000101
#define PMASK_MPMCDyCntl          0x0000E1A7
#define PMASK_MPMCDyRef           0x000007FF
#define PMASK_MPMCDyRdCfg         0x00000007
#define PMASK_MPMCDytRP           0x0000000F
#define PMASK_MPMCDytRAS          0x0000000F
#define PMASK_MPMCDytSREX         0x0000000F
#define PMASK_MPMCDytAPR          0x0000000F
#define PMASK_MPMCDytDAL          0x0000000F
#define PMASK_MPMCDytWR           0x0000000F
#define PMASK_MPMCDytRC           0x0000001F
#define PMASK_MPMCDytRFC          0x0000001F
#define PMASK_MPMCDytXSR          0x0000001F
#define PMASK_MPMCDytRRD          0x0000000F
#define PMASK_MPMCDytMRD          0x0000000F
#define PMASK_MPMCStExdWt         0x000003FF


#define PMASK_MPMCDyConfig0       0x01D8D399
#define PMASK_MPMCDyRasCas0       0x00000303
#define PMASK_MPMCDyConfig1       0x01D8D399
#define PMASK_MPMCDyRasCas1       0x00000303
#define PMASK_MPMCDyConfig2       0x01D8D399
#define PMASK_MPMCDyRasCas2       0x00000303
#define PMASK_MPMCDyConfig3       0x01D8D399
#define PMASK_MPMCDyRasCas3       0x00000303
#define PMASK_MPMCStConfig0       0x001801CB
#define PMASK_MPMCStWtWen0        0x0000000F
#define PMASK_MPMCStWtOen0        0x0000000F
#define PMASK_MPMCStWtRd0         0x0000001F
#define PMASK_MPMCStWtPg0         0x0000001F
#define PMASK_MPMCStWtWr0         0x0000001F
#define PMASK_MPMCStWtTurn0       0x0000000F
#define PMASK_MPMCStConfig1       0x001801CB
#define PMASK_MPMCStWtWen1        0x0000000F
#define PMASK_MPMCStWtOen1        0x0000000F
#define PMASK_MPMCStWtRd1         0x0000001F
#define PMASK_MPMCStWtPg1         0x0000001F
#define PMASK_MPMCStWtWr1         0x0000001F
#define PMASK_MPMCStWtTurn1       0x0000000F
#define PMASK_MPMCStConfig2       0x001801CB
#define PMASK_MPMCStWtWen2        0x0000000F
#define PMASK_MPMCStWtOen2        0x0000000F
#define PMASK_MPMCStWtRd2         0x0000001F
#define PMASK_MPMCStWtPg2         0x0000001F
#define PMASK_MPMCStWtWr2         0x0000001F
#define PMASK_MPMCStWtTurn2       0x0000000F
#define PMASK_MPMCStConfig3       0x001801CB
#define PMASK_MPMCStWtWen3        0x0000000F
#define PMASK_MPMCStWtOen3        0x0000000F
#define PMASK_MPMCStWtRd3         0x0000001F
#define PMASK_MPMCStWtPg3         0x0000001F
#define PMASK_MPMCStWtWr3         0x0000001F
#define PMASK_MPMCStWtTurn3       0x0000000F
#define PMASK_MPMCITCR            0x00000001
#define PMASK_MPMCITIP            0x00000001
#define PMASK_MPMCITOP            0x00000001

#define PMASK_MPMCPeriphId4       0x000000FF
#define PMASK_MPMCPeriphId5       0x000000FF
#define PMASK_MPMCPeriphId6       0x000000FF
#define PMASK_MPMCPeriphId7       0x000000FF
#define PMASK_MPMCPeriphId0       0x000000FF
#define PMASK_MPMCPeriphId1       0x000000FF
#define PMASK_MPMCPeriphId2       0x000000FF
#define PMASK_MPMCPeriphId3       0x000000FF
#define PMASK_MPMCPCellId0        0x000000FF
#define PMASK_MPMCPCellId1        0x000000FF
#define PMASK_MPMCPCellId2        0x000000FF
#define PMASK_MPMCPCellId3        0x000000FF




/******************************************************************************/
/******************************************************************************/
/******************************* TRICKBOX *************************************/
/******************************************************************************/
/******************************************************************************/



/******************************************************************************/
/***************************** TRICKBOX REGISTERS *****************************/
/******************************************************************************/
/* ---------------------------------------------------------------------------*/
/* Below declaration indicates the trick box register offsets                 */
/* ---------------------------------------------------------------------------*/
/*============================================================================*/
/* Register            Offset               Size               Valid Bits
/*============================================================================*/
/* MPMCTrCR            0x000                 32                   5-0
   MPMCTrSR            0x004                 32                  20-0
   MPMCTrSNPFIFO1      0x008                 32                  31-0
   MPMCTrSNPFIFO2      0x00C                 32                  31-0
   MPMCTrStaticCS      0x014                 32                   5-0 
   MPMCTrTES           0x018                 32                   3-0     
   MPMCTrSNPCR         0x01C                 32
   MPMCTrExpRef        0x020                 32                               
   MPMCTrExBkOff       0x024                 32                               
   HREADY0CNT          0x028                  8                   7-0
   HREADY1CNT          0x02C                  8                   7-0         */
/******************************************************************************/
#define MPMCTrCR                 (MPMC_TRICK + 0x000)
#define MPMCTrSR                 (MPMC_TRICK + 0x004)
#define MPMCTrSNPFIFO1           (MPMC_TRICK + 0x008)
#define MPMCTrSNPFIFO2           (MPMC_TRICK + 0x00C)
#define MPMCTrStaticCS           (MPMC_TRICK + 0x014)
#define MPMCTrTES                (MPMC_TRICK + 0x018)
#define MPMCTrSNPCR              (MPMC_TRICK + 0x01C)
#define MPMCTrExpRef             (MPMC_TRICK + 0x020)
#define MPMCTrExBkOff            (MPMC_TRICK + 0x024)
#define HREADY0CNT               (MPMC_TRICK + 0x028)
#define HREADY1CNT               (MPMC_TRICK + 0x02C)
/******************************************************************************/
/***************************** TRICKMEM REGISTER ******************************/
/******************************************************************************/
/*** Trick Memory is the static memory model to check the functionlity      ***/
/*** of static memory controller.                                           ***/
#define MPMC_TRICK               0xC0000000
#define MPMC_TRMEM               0xD0000000
#define MPMC0_TRMEM              (MPMC_TRMEM + 0x00000000)
#define MPMC1_TRMEM              (MPMC_TRMEM + 0x10000000)
#define MPMC2_TRMEM              (MPMC_TRMEM + 0x20000000)
#define MPMC3_TRMEM              (MPMC_TRMEM + 0x28000000)

/******************************************************************************/

#define MEM0_BASE                0x00000000
#define MEM1_BASE                0x10000000
#define MEM2_BASE                0x20000000
#define MEM3_BASE                0x30000000

/******************************************************************************/
/* ---------------------------------------------------------------------------*/
/* Below declaration indicates the trick memory register offsets              */
/* ---------------------------------------------------------------------------*/
/*============================================================================*/
/* Register            Offset               Size               Valid Bits
/*============================================================================*/
/* MPMCTrMEMR          0x0000                32                   31-0
   MPMCTrIDCY          0x2000                32                    3-0
   MPMCTrMEMT          0x4000                32                    8-0
   MPMCTrMEMB          0x5000                32                   16-0 
   MPMCTrCS2Oen        0x6000                32                    3-0
   MPMCTrCS2Rd         0x7000                32                    4-0
   MPMCTrCS2Wen        0x8000                32                    3-0
   MPMCTrCS2Wr         0x9000                32                    4-0
   MPMCTrWtPg          0xA000                32                    4-0
   MPMCTrExtWait       0xB000                32                    9-0
   MPMCTrCSPOL         0xF000                32                    3-0        */
/******************************************************************************/
#define MPMCTrMEMR_0             (MPMC0_TRMEM + 0x0000)
#define MPMCTrIDCY_0             (MPMC0_TRMEM + 0x2000)
#define MPMCTrMEMT_0             (MPMC0_TRMEM + 0x4000)
#define MPMCTrMEMB_0             (MPMC0_TRMEM + 0x5000)
#define MPMCTrCS2Oen_0           (MPMC0_TRMEM + 0x6000)
#define MPMCTrCS2Rd_0            (MPMC0_TRMEM + 0x7000)
#define MPMCTrCS2Wen_0           (MPMC0_TRMEM + 0x8000)
#define MPMCTrCS2Wr_0            (MPMC0_TRMEM + 0x9000)
#define MPMCTrWtPg_0             (MPMC0_TRMEM + 0xA000)
#define MPMCTrExtWait_0          (MPMC0_TRMEM + 0xB000)
#define MPMCTrCSPOL_0            (MPMC0_TRMEM + 0xF000)
 
#define MPMCTrMEMR_1             (MPMC1_TRMEM + 0x0000)
#define MPMCTrIDCY_1             (MPMC1_TRMEM + 0x2000)
#define MPMCTrMEMT_1             (MPMC1_TRMEM + 0x4000)
#define MPMCTrMEMB_1             (MPMC1_TRMEM + 0x5000)
#define MPMCTrCS2Oen_1           (MPMC1_TRMEM + 0x6000)
#define MPMCTrCS2Rd_1            (MPMC1_TRMEM + 0x7000)
#define MPMCTrCS2Wen_1           (MPMC1_TRMEM + 0x8000)
#define MPMCTrCS2Wr_1            (MPMC1_TRMEM + 0x9000)
#define MPMCTrWtPg_1             (MPMC1_TRMEM + 0xA000)
#define MPMCTrExtWait_1          (MPMC1_TRMEM + 0xB000)
#define MPMCTrCSPOL_1            (MPMC1_TRMEM + 0xF000)
 
#define MPMCTrMEMR_2             (MPMC2_TRMEM + 0x0000)
#define MPMCTrIDCY_2             (MPMC2_TRMEM + 0x2000)
#define MPMCTrMEMT_2             (MPMC2_TRMEM + 0x4000)
#define MPMCTrMEMB_2             (MPMC2_TRMEM + 0x5000)
#define MPMCTrCS2Oen_2           (MPMC2_TRMEM + 0x6000)
#define MPMCTrCS2Rd_2            (MPMC2_TRMEM + 0x7000)
#define MPMCTrCS2Wen_2           (MPMC2_TRMEM + 0x8000)
#define MPMCTrCS2Wr_2            (MPMC2_TRMEM + 0x9000)
#define MPMCTrWtPg_2             (MPMC2_TRMEM + 0xA000)
#define MPMCTrExtWait_2          (MPMC2_TRMEM + 0xB000)
#define MPMCTrCSPOL_2            (MPMC2_TRMEM + 0xF000)

#define MPMCTrMEMR_3             (MPMC3_TRMEM + 0x0000)
#define MPMCTrIDCY_3             (MPMC3_TRMEM + 0x2000)
#define MPMCTrMEMT_3             (MPMC3_TRMEM + 0x4000)
#define MPMCTrMEMB_3             (MPMC3_TRMEM + 0x5000)
#define MPMCTrCS2Oen_3           (MPMC3_TRMEM + 0x6000)
#define MPMCTrCS2Rd_3            (MPMC3_TRMEM + 0x7000)
#define MPMCTrCS2Wen_3           (MPMC3_TRMEM + 0x8000)
#define MPMCTrCS2Wr_3            (MPMC3_TRMEM + 0x9000)
#define MPMCTrWtPg_3             (MPMC3_TRMEM + 0xA000)
#define MPMCTrExtWait_3          (MPMC3_TRMEM + 0xB000)
#define MPMCTrCSPOL_3            (MPMC3_TRMEM + 0xF000)
/* -- --============================ End ================================-- --*/
