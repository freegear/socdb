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
--  File Name              : Sdram_CAS1.h,v
--  File Revision          : 1.3
--  
--  Release Information    : PrimeCell(TM)-PL170-REL2v2
--  
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
--  Purpose  : This file contains the register offsets and other definitions
--             for the Sdram_CAS1_0.c, Sdram_CAS1_1.c, Sdram_CAS1_2.c and
--             Sdram_CAS1_3.c test code files.
------------------------------------------------------------------------------*/

/******************************************************************************/
/*****************            BASE ADDRESS DEFINITION              ************/
/******************************************************************************/
#define SDRAMBase                   0xA0000000
#define SDRAMRegBase                0x00000000
#define MEMORY_BASE                 0xA0000000
#define TRICKBase                   0xC0000000

/******************************************************************************/
/*******************      SDRAM  DEVICE TYPE DEFINITION        ****************/
/******************************************************************************/
/***                         For CAS1 tests                                 ***/
#define SLOT0 "16M_x16"
#define SLOT1 "16M_x16"
#define SLOT2 "16M_x16"
#define SLOT3 "16M_x16"

/******************************************************************************/
/*******************      Configurability Options              ****************/
/******************************************************************************/
 
/* The Buffer size */
#define NO_OF_WRITE_BUFFERS         2
#define NO_OF_READ_BUFFERS          1

/* Address Mapping */
#define ADDRMAP                     1
 
/* BCLK Frequency */
/* If Cas Latency of 2 is being tested set this define to 66  */
/* If Cas Latency of 3 is being tested set this define to 100 */
#define BCLK_FREQ                   66

/* BusWidth Selection. Valid values are 32 or 64*/
/* The default value is 32 */
#define BUSWIDTH                32

#define EXTBUSWIDTH             0

/******************************************************************************/
/***************************** SDRAM REGISTERS  *******************************/
/******************************************************************************/

#define CONFIGURATION     SDRAMRegBase + 0X00
#define CONFIGURATION0    SDRAMRegBase + 0X00
#define CONFIGURATION1    SDRAMRegBase + 0X04
#define REFRESH_REG       SDRAMRegBase + 0x08

/******************************************************************************/
/******************        REGISTER ADDRESS                  ******************/
/******************************************************************************/
#define CONFIG_REG0  SDRAMRegBase + 0x00000000  
#define CONFIG_REG1  SDRAMRegBase + 0x00000004  
#define REFRESHCOUNT SDRAMRegBase + 0x00000008  
#define WRITETIMEOUT SDRAMRegBase + 0x0000000C

/* Register Mask */
#define REFRESH_REG_MASK            0x0000FFFF
#define WRITE_TIME_MASK             0x0000FFFF

#define CONFIG_REG_MASK             0x3BF5CCCC
#define CONFIG_REG0_MASK            0x3BF4CCCC
#define CONFIG_REG1_MASK            0x0000002F
 
/* Register Default for Sdram Tests */
#define CONFIG_REG_RES              0x01F00000
#define CONFIG_REG0_RES             0x01F00000
#define CONFIG_REG1_RES             0x00000000
#define REFRESH_REG_RES             0x00000080
 
/******************************************************************************/
/****************** Bit Masking Constants *************************************/
/******************************************************************************/
 
#define NoMask                      0xFFFFFFFF
#define MaskAll                     0x00000000
#define MaskIMBits                  0xFFFFFFFC
 
/******************************************************************************/
/********************** Register Bit Mask *************************************/
/******************************************************************************/
/* Config Register 0 */
#define CLKDIS                      0x00020000
#define CLOCK_EN                    0x00040000
#define EBUSWIDTH                   0x00080000
#define CASLT1                      0x00100000
#define CASLT2                      0x00200000
#define CASLT3                      0x00300000
#define RASLT1                      0x00400000
#define RASLT2                      0x00800000
#define RASLT3                      0x00C00000
#define AUTOPRE                     0x01000000

/* Config Register 1 */
#define WriteBufEn                  0x00000008
#define ReadBufEn                   0x00000004
#define MODE                        0x00000002
#define INIT                        0x00000001

/******************************************************************************/
/******************** For SDRAM devices  **************************************/
/******************************************************************************/

#define Device0       MEMORY_BASE
#define Device1       MEMORY_BASE + 0x08000000
#define Device2       MEMORY_BASE + 0x10000000
#define Device3       MEMORY_BASE + 0x18000000
 
#define DevInc                      0x08000000
 
#define QWInc                       0x00000010
 
#define W0                          0x00000000
#define W1                          0x00000004
#define W2                          0x00000008
#define W3                          0x0000000C
#define WInc                        0x00000004
 
#define HW0                         0x00000000
#define HW1                         0x00000002
#define HWInc                       0x00000002
 
#define B0                          0x00000000
#define B1                          0x00000001
#define B2                          0x00000002
#define B3                          0x00000003
#define BInc                        0x00000001
 
/* Trickbox defines */

#define PMU_REG         TRICKBase + 0x00000000
#define SIG_STAT        TRICKBase + 0x00000100
#define SNOOPER_REG     TRICKBase + 0x00000200

/* Register Bit Masks */
/* PMU Register */
#define BUSGNTDELAY                 0x00003E00
#define BUSGNTMODE                  0x00000100
#define POR                         0x00000002
#define SREFREQ                     0x00000001

#define ZERO                        0x00000000
#define DATA_0s                     ZERO 
#define Data_5s                     0x55555555
#define Data_As                     0xAAAAAAAA
#define DATA_Fs                     0xFFFFFFFF
#define WORDMask                    0xFFFFFFF3

#define DATA0                       0x00000000
#define DATA1                       0x11111111
#define DATA2                       0x22222222
#define DATA3                       0x33333333
 
#define DATA4                       0x44444444
#define DATA5                       0x55555555
#define DATA6                       0x66666666
#define DATA7                       0x77777777
 
#define DATA8                       0x88888888
#define DATA9                       0x99999999
#define DATA10                      0xAAAAAAAA
#define DATA11                      0xBBBBBBBB
 
#define DATA12                      0xCCCCCCCC
#define DATA13                      0xDDDDDDDD
#define DATA14                      0xEEEEEEEE
#define DATA15                      0xFFFFFFFF

#define DataCnt16                   16
