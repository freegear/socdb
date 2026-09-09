/* --=========================================================================--
--  This confidential and proprietary software may be used only as
--  authorised by a licensing agreement from ARM Limited
--    (C) COPYRIGHT 2003 ARM Limited
--        ALL RIGHTS RESERVED
--  The entire notice above must be reproduced on all authorised
--  copies and copies may only be made to the extent permitted
--  by a licensing agreement from ARM Limited.
-- -----------------------------------------------------------------------------
--
--  Version and Release Control Information:
--
--  File Name              : Ssmc.h.rca
--  File Revision          : 1.12
--
--  Release Information    : PrimeCell(TM)-PL093-r0p3-00rel0
--
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Purpose :
--           This file contains the register offsets and other definitions
--           for the Ssmc.c test code.
--
-- --=========================================================================*/

/******************************************************************************/

#define ZERO        0x00000000
#define BUnMask0    0x000000FF
#define BUnMask1    0x0000FF00
#define BUnMask2    0x00FF0000
#define BUnMask3    0xFF000000
#define HWUnMaskL   0x0000FFFF
#define HWUnMaskB   0xFFFF0000
#define NoMask      0xFFFFFFFF
#define MaskAll     0x00000000
#define MASKALL     0x00000000
#define Data0       0x00000000
#define Data5       0x55555555
#define DataA       0xAAAAAAAA
#define DataF       0xFFFFFFFF

/******************************************************************************/
/************************* USER PROGRAMMABLE CONSTANTS ************************/
/******************************************************************************/
 /*  Setting the INFO = '0' , will result in mininmum most comments in logs.
    While  when INFO = '1' will enable all the comments */
#define INFO        0         

 /* The Clock Ratio can be set to CLKR11, CLKR12 or CLKR13 as desired  */
#define CLKRATIO                        CLKR11

/******************************************************************************/
/************************** TRICKBOX REGISTERS ********************************/
/******************************************************************************/

/******************************************************************************/
/*** SSMC TrickMem  Registers                                                ***/
/*** =========================                                              ***/
/*** SSMCTrMEMARRAY 0x0000    32/32  R/W  Memory Array                      ***/
/*** SSMCTrMEMBASE  0x2000    15/15  R/W  Memory Base Address Register      ***/
/*** ---------------------TrickMem Mirror Registers------------------------ ***/
/*** SMBIDCYR0      0x00       0/6   R/W  Memory Idle Time Register         ***/
/*** SMBWSTRDR0     0x04       0/5   R/W  Read Wait State Control Register  ***/
/*** SMBWSTWRR0     0x08       0/5   R/W  Write Wait State Control Register ***/
/*** SMBWSTOENR0    0x0C       0/4   R/W  O/P Enable Delay Control Register ***/
/*** SMBWSTWENR0    0x10       0/4   R/W  Write Enable Delay Control Registe***/
/*** SMBCR0         0x14       0/15  R/W  Memory Bank Control Register      ***/
/*** SMBWSTBRDR0    0x1C       0/5   R/W  Burst Read Delay Control Register ***/
/*** SMBIDCYR1      0x20       0/6   R/W  Memory Idle Time Register         ***/
/*** SMBWSTRDR1     0x24       0/5   R/W  Read Wait State Control Register  ***/
/*** SMBWSTWRR1     0x28       0/5   R/W  Write Wait State Control Register ***/
/*** SMBWSTOENR1    0x2C       0/4   R/W  O/P Enable Delay Control Register ***/
/*** SMBWSTWENR1    0x30       0/4   R/W  Write Enable Delay Control Registe***/
/*** SMBCR1         0x34       0/15  R/W  Memory Bank Control Register      ***/
/*** SMBWSTBRDR1    0x3C       0/5   R/W  Burst Read Delay Control Register ***/
/*** SMBIDCYR2      0x40       0/6   R/W  Memory Idle Time Register         ***/
/*** SMBWSTRDR2     0x44       0/5   R/W  Read Wait State Control Register  ***/
/*** SMBWSTWRR2     0x48       0/5   R/W  Write Wait State Control Register ***/
/*** SMBWSTOENR2    0x4C       0/4   R/W  O/P Enable Delay Control Register ***/
/*** SMBWSTWENR2    0x50       0/4   R/W  Write Enable Delay Control Registe***/
/*** SMBCR2         0x54       0/15  R/W  Memory Bank Control Register      ***/
/*** SMBWSTBRDR2    0x5C       0/5   R/W  Burst Read Delay Control Register ***/
/*** SMBIDCYR3      0x60       0/6   R/W  Memory Idle Time Register         ***/
/*** SMBWSTRDR3     0x64       0/5   R/W  Read Wait State Control Register  ***/
/*** SMBWSTWRR3     0x68       0/5   R/W  Write Wait State Control Register ***/
/*** SMBWSTOENR3    0x6C       0/4   R/W  O/P Enable Delay Control Register ***/
/*** SMBWSTWENR3    0x70       0/4   R/W  Write Enable Delay Control Registe***/
/*** SMBCR3         0x74       0/15  R/W  Memory Bank Control Register      ***/
/*** SMBWSTBRDR3    0x7C       0/5   R/W  Burst Read Delay Control Register ***/
/*** SMBIDCYR4      0x80       0/6   R/W  Memory Idle Time Register         ***/
/*** SMBWSTRDR4     0x84       0/5   R/W  Read Wait State Control Register  ***/
/*** SMBWSTWRR4     0x88       0/5   R/W  Write Wait State Control Register ***/
/*** SMBWSTOENR4    0x8C       0/4   R/W  O/P Enable Delay Control Register ***/
/*** SMBWSTWENR4    0x90       0/4   R/W  Write Enable Delay Control Registe***/
/*** SMBCR4         0x94       0/15  R/W  Memory Bank Control Register      ***/
/*** SMBWSTBRDR4    0x9C       0/5   R/W  Burst Read Delay Control Register ***/
/*** SMBIDCYR5      0xA0       0/6   R/W  Memory Idle Time Register         ***/
/*** SMBWSTRDR5     0xA4       0/5   R/W  Read Wait State Control Register  ***/
/*** SMBWSTWRR5     0xA8       0/5   R/W  Write Wait State Control Register ***/
/*** SMBWSTOENR5    0xAC       0/4   R/W  O/P Enable Delay Control Register ***/
/*** SMBWSTWENR5    0xB0       0/4   R/W  Write Enable Delay Control Registe***/
/*** SMBCR5         0xB4       0/15  R/W  Memory Bank Control Register      ***/
/*** SMBWSTBRDR5    0xBC       0/5   R/W  Burst Read Delay Control Register ***/
/*** SMBIDCYR6      0xC0       0/6   R/W  Memory Idle Time Register         ***/
/*** SMBWSTRDR6     0xC4       0/5   R/W  Read Wait State Control Register  ***/
/*** SMBWSTWRR6     0xC8       0/5   R/W  Write Wait State Control Register ***/
/*** SMBWSTOENR6    0xCC       0/4   R/W  O/P Enable Delay Control Register ***/
/*** SMBWSTWENR6    0xD0       0/4   R/W  Write Enable Delay Control Registe***/
/*** SMBCR6         0xD4       0/15  R/W  Memory Bank Control Register      ***/
/*** SMBWSTBRDR6    0xDC       0/5   R/W  Burst Read Delay Control Register ***/
/*** SMBIDCYR7      0xE0       0/6   R/W  Memory Idle Time Register         ***/
/*** SMBWSTRDR7     0xE4       0/5   R/W  Read Wait State Control Register  ***/
/*** SMBWSTWRR7     0xE8       0/5   R/W  Write Wait State Control Register ***/
/*** SMBWSTOENR7    0xEC       0/4   R/W  O/P Enable Delay Control Register ***/
/*** SMBWSTWENR7    0xF0       0/4   R/W  Write Enable Delay Control Registe***/
/*** SMBCR7         0xF4       0/15  R/W  Memory Bank Control Register      ***/
/*** SMBWSTBRDR7    0xFC       0/5   R/W  Burst Read Delay Control Register ***/
/*** SSMCTrBurstWT  0x20000    8/8   R/W  Burst wait Delay Register         ***/
/*** SMMemCLKRatio  0x24000    0-3/8-11 R/W Delay Locked Loop register      ***/
/******************************************************************************/
#define TM_BASE		0xC0000000

#define SSMCTrMEMARRAY0	  (TM_BASE + 0x00000)
#define SSMCTrMEMARRAY1   (TM_BASE + 0x02000)
#define SSMCTrMEMARRAY2   (TM_BASE + 0x04000)
#define SSMCTrMEMARRAY3   (TM_BASE + 0x06000)
#define SSMCTrMEMARRAY4   (TM_BASE + 0x08000)
#define SSMCTrMEMARRAY5   (TM_BASE + 0x0A000)
#define SSMCTrMEMARRAY6   (TM_BASE + 0x0C000)
#define SSMCTrMEMARRAY7   (TM_BASE + 0x0E000)

#define SSMCTrMEMBase0    (TM_BASE + 0x10000)
#define SSMCTrMEMBase1    (TM_BASE + 0x12000)
#define SSMCTrMEMBase2    (TM_BASE + 0x14000)
#define SSMCTrMEMBase3    (TM_BASE + 0x16000)
#define SSMCTrMEMBase4    (TM_BASE + 0x18000)
#define SSMCTrMEMBase5    (TM_BASE + 0x1A000)
#define SSMCTrMEMBase6    (TM_BASE + 0x1C000)
#define SSMCTrMEMBase7    (TM_BASE + 0x1E000)

#define SSMCTrBurstWT     (TM_BASE + 0x20000)
#define SMMemCLKRatio     (TM_BASE + 0x24000)
/******************************************************************************/
/*** SSMC Trickbox  Registers                                                ***/
/*** =========================                                              ***/
/*** SSMCTrMWCS    0x0000    2/2  R/W  Boot Memory Width Register           ***/
/*** SSMCTrExtMux  0x0004    1/1  R/W  External Mux Register                ***/
/*** SSMCTrEndian  0x0008    1/1  R/W  Endianness register                  ***/
/*** SSMCTrCS2WTR 0-7       10/10 R/W  Enables SMWAIT Register for banks 0-7***/
/*** SSMCTrWTCNCL           8/8   R/W  CancelSMWAIT assertion delay control ***/
/*** SSMCTrBurstWT          8/8   R/W  Burst Wait Control                   ***/
/******************************************************************************/

#define TB_BASE          0x80000000
#define SSMCTrMWCS        (TB_BASE + 0x0000)
#define SSMCTrExtMux      (TB_BASE + 0x0004)
#define SSMCTrEndian      (TB_BASE + 0x0008)
#define SSMCTrCS2WTR0     (TB_BASE + 0x000C)
#define SSMCTrCS2WTR1     (TB_BASE + 0x0010)
#define SSMCTrCS2WTR2     (TB_BASE + 0x0014)
#define SSMCTrCS2WTR3     (TB_BASE + 0x0018)
#define SSMCTrCS2WTR4     (TB_BASE + 0x001C)
#define SSMCTrCS2WTR5     (TB_BASE + 0x0020)
#define SSMCTrCS2WTR6     (TB_BASE + 0x0024)
#define SSMCTrCS2WTR7     (TB_BASE + 0x0028)
#define SSMCTrWTCNCL      (TB_BASE + 0x002C)
#define SSMCTrCR          (TB_BASE + 0x0030)
#define SSMCTrSMBLSPOL    (TB_BASE + 0x0034)

/******************************************************************************/
/******************************* SSMC Register *********************************/
/******************************************************************************/

#define Memory_BASE      0x00000000
#define SSMCCR_BASE       0x40000000

#define SSMCMEM_0         (Memory_BASE + 0x00000000)
#define SSMCMEM_1         (Memory_BASE + 0x08000000)
#define SSMCMEM_2         (Memory_BASE + 0x10000000)
#define SSMCMEM_3         (Memory_BASE + 0x18000000)
#define SSMCMEM_4         (Memory_BASE + 0x20000000)
#define SSMCMEM_5         (Memory_BASE + 0x28000000)
#define SSMCMEM_6         (Memory_BASE + 0x30000000)
#define SSMCMEM_7         (Memory_BASE + 0x38000000)

#define SMBIDCYR0        (SSMCCR_BASE + 0x00)
#define SMBWSTRDR0       (SSMCCR_BASE + 0x04)
#define SMBWSTWRR0       (SSMCCR_BASE + 0x08)
#define SMBWSTOENR0      (SSMCCR_BASE + 0x0C)
#define SMBWSTWENR0      (SSMCCR_BASE + 0x10)
#define SMBCR0           (SSMCCR_BASE + 0x14)
#define SMBSR0           (SSMCCR_BASE + 0x18)
#define SMBWSTBRDR0      (SSMCCR_BASE + 0x1C)

#define SMBIDCYR1        (SSMCCR_BASE + 0x20)
#define SMBWSTRDR1       (SSMCCR_BASE + 0x24)
#define SMBWSTWRR1       (SSMCCR_BASE + 0x28)
#define SMBWSTOENR1      (SSMCCR_BASE + 0x2C)
#define SMBWSTWENR1      (SSMCCR_BASE + 0x30)
#define SMBCR1           (SSMCCR_BASE + 0x34)
#define SMBSR1           (SSMCCR_BASE + 0x38)
#define SMBWSTBRDR1      (SSMCCR_BASE + 0x3C)

#define SMBIDCYR2        (SSMCCR_BASE + 0x40)
#define SMBWSTRDR2       (SSMCCR_BASE + 0x44)
#define SMBWSTWRR2       (SSMCCR_BASE + 0x48)
#define SMBWSTOENR2      (SSMCCR_BASE + 0x4C)
#define SMBWSTWENR2      (SSMCCR_BASE + 0x50)
#define SMBCR2           (SSMCCR_BASE + 0x54)
#define SMBSR2           (SSMCCR_BASE + 0x58)
#define SMBWSTBRDR2      (SSMCCR_BASE + 0x5C)

#define SMBIDCYR3        (SSMCCR_BASE + 0x60)
#define SMBWSTRDR3       (SSMCCR_BASE + 0x64)
#define SMBWSTWRR3       (SSMCCR_BASE + 0x68)
#define SMBWSTOENR3      (SSMCCR_BASE + 0x6C)
#define SMBWSTWENR3      (SSMCCR_BASE + 0x70)
#define SMBCR3           (SSMCCR_BASE + 0x74)
#define SMBSR3           (SSMCCR_BASE + 0x78)
#define SMBWSTBRDR3      (SSMCCR_BASE + 0x7C)

#define SMBIDCYR4        (SSMCCR_BASE + 0x80)
#define SMBWSTRDR4       (SSMCCR_BASE + 0x84)
#define SMBWSTWRR4       (SSMCCR_BASE + 0x88)
#define SMBWSTOENR4      (SSMCCR_BASE + 0x8C)
#define SMBWSTWENR4      (SSMCCR_BASE + 0x90)
#define SMBCR4           (SSMCCR_BASE + 0x94)
#define SMBSR4           (SSMCCR_BASE + 0x98)
#define SMBWSTBRDR4      (SSMCCR_BASE + 0x9C)

#define SMBIDCYR5        (SSMCCR_BASE + 0xA0)
#define SMBWSTRDR5       (SSMCCR_BASE + 0xA4)
#define SMBWSTWRR5       (SSMCCR_BASE + 0xA8)
#define SMBWSTOENR5      (SSMCCR_BASE + 0xAC)
#define SMBWSTWENR5      (SSMCCR_BASE + 0xB0)
#define SMBCR5           (SSMCCR_BASE + 0xB4)
#define SMBSR5           (SSMCCR_BASE + 0xB8)
#define SMBWSTBRDR5      (SSMCCR_BASE + 0xBC)

#define SMBIDCYR6        (SSMCCR_BASE + 0xC0)
#define SMBWSTRDR6       (SSMCCR_BASE + 0xC4)
#define SMBWSTWRR6       (SSMCCR_BASE + 0xC8)
#define SMBWSTOENR6      (SSMCCR_BASE + 0xCC)
#define SMBWSTWENR6      (SSMCCR_BASE + 0xD0)
#define SMBCR6           (SSMCCR_BASE + 0xD4)
#define SMBSR6           (SSMCCR_BASE + 0xD8)
#define SMBWSTBRDR6      (SSMCCR_BASE + 0xDC)

#define SMBIDCYR7        (SSMCCR_BASE + 0xE0)
#define SMBWSTRDR7       (SSMCCR_BASE + 0xE4)
#define SMBWSTWRR7       (SSMCCR_BASE + 0xE8)
#define SMBWSTOENR7      (SSMCCR_BASE + 0xEC)
#define SMBWSTWENR7      (SSMCCR_BASE + 0xF0)
#define SMBCR7           (SSMCCR_BASE + 0xF4)
#define SMBSR7           (SSMCCR_BASE + 0xF8)
#define SMBWSTBRDR7      (SSMCCR_BASE + 0xFC)

#define SSMCSR		 (SSMCCR_BASE + 0x200)
#define SSMCCR           (SSMCCR_BASE + 0x204)
#define SSMCITCR	 (SSMCCR_BASE + 0x208)
#define SSMCITIP         (SSMCCR_BASE + 0x20C)
#define SSMCITOP         (SSMCCR_BASE + 0x210)

#define SSMCPeriphID0    (SSMCCR_BASE + 0xFE0)
#define SSMCPeriphID1    (SSMCCR_BASE + 0xFE4)
#define SSMCPeriphID2    (SSMCCR_BASE + 0xFE8)
#define SSMCPeriphID3    (SSMCCR_BASE + 0xFEC)

#define SSMCPCellID0     (SSMCCR_BASE + 0xFF0)
#define SSMCPCellID1     (SSMCCR_BASE + 0xFF4)
#define SSMCPCellID2     (SSMCCR_BASE + 0xFF8)
#define SSMCPCellID3     (SSMCCR_BASE + 0xFFC)

/******************************************************************************/
/************************** SSMC Register Reset Values ************************/
/******************************************************************************/
#define RST_SMBIDCYR       0x0000000F
#define RST_SMBWSTRDR      0x0000001F
#define RST_SMBWSTWRR      0x0000001F
#define RST_SMBWSTOENR     0x00000000
#define RST_SMBWSTWENR     0x00000001
#define RST_SMBWSTBRDR     0x0000001F
#define RST_SSMCSR         0x00000000
#define RST_SSMCCR         0x00000001
#define RST_SSMCITCR       0x00000000
#define RST_SSMCTrBurstWT  0x00000000

#define RST_SMBCR0         0x00303020
#define RST_SMBCR1         0x00303000
#define RST_SMBCR2         0x00303010
#define RST_SMBCR3         0x00303000
#define RST_SMBCR4         0x00303020
#define RST_SMBCR5         0x00303020
#define RST_SMBCR6         0x00303010
#define RST_SMBCR7         0x00303000

#define RST_SMBSR0         0x00000000
#define RST_SMBSR1         0x00000000
#define RST_SMBSR2         0x00000000
#define RST_SMBSR3         0x00000000
#define RST_SMBSR4         0x00000000
#define RST_SMBSR5         0x00000000
#define RST_SMBSR6         0x00000000
#define RST_SMBSR7         0x00000000

#define RST_SSMCPeriphID0  0x00000093
#define RST_SSMCPeriphID1  0x00000010
#define RST_SSMCPeriphID2  0x00000014
#define RST_SSMCPeriphID3  0x00000000

#define RST_SSMCPCellID0   0x0000000D
#define RST_SSMCPCellID1   0x000000F0
#define RST_SSMCPCellID2   0x00000005
#define RST_SSMCPCellID3   0x000000B1

/******************************************************************************/
/****************DIFFERENT VALUES FOR BANK NUMBER FIELD ***********************/
/******************************************************************************/
#define BANK0		0
#define BANK1		1
#define BANK2		2
#define BANK3		3
#define BANK4		4
#define BANK5		5
#define BANK6		6
#define BANK7		7

/******************************************************************************/
/****************DIFFERENT VALUES FOR IDLE CYCLE  FIELD ***********************/
/******************************************************************************/
#define WSTIDCY0	0x00
#define WSTIDCY1	0x01
#define WSTIDCY2	0x02
#define WSTIDCY3	0x03
#define WSTIDCY4	0x04
#define WSTIDCY5	0x05
#define WSTIDCY6	0x06
#define WSTIDCY7	0x07
#define WSTIDCY8	0x08
#define WSTIDCY9	0x09
#define WSTIDCY10	0x0A
#define WSTIDCY11	0x0B
#define WSTIDCY12	0x0C
#define WSTIDCY13	0x0D
#define WSTIDCY14	0x0E
#define WSTIDCY15	0x0F

#define IDCY0       	0x00
#define IDCY1           0x01
#define IDCY2           0x02
#define IDCY3           0x03
#define IDCY4           0x04
#define IDCY5           0x05
#define IDCY6           0x06
#define IDCY7           0x07
#define IDCY8           0x08
#define IDCY9           0x09
#define IDCY10          0x0A
#define IDCY11          0x0B
#define IDCY12          0x0C
#define IDCY13          0x0D
#define IDCY14          0x0E
#define IDCY15          0x0F

#define IC0       	0x00
#define IC1             0x01
#define IC2             0x02
#define IC3             0x03
#define IC4             0x04
#define IC5             0x05
#define IC6             0x06
#define IC7             0x07
#define IC8             0x08
#define IC9             0x09
#define IC10            0x0A
#define IC11            0x0B
#define IC12            0x0C
#define IC13            0x0D
#define IC14            0x0E
#define IC15            0x0F

/******************************************************************************/
/**************DIFFERENT VALUES FOR READ WAIT STATES FIELD ********************/
/******************************************************************************/
#define WSTRD0		0x00
#define WSTRD1		0x01
#define WSTRD2		0x02
#define WSTRD3		0x03
#define WSTRD4		0x04
#define WSTRD5		0x05
#define WSTRD6		0x06
#define WSTRD7		0x07
#define WSTRD8		0x08
#define WSTRD9		0x09
#define WSTRD10		0x0A
#define WSTRD11		0x0B
#define WSTRD12		0x0C
#define WSTRD13		0x0D
#define WSTRD14		0x0E
#define WSTRD15		0x0F
#define WSTRD16		0x10
#define WSTRD17		0x11
#define WSTRD18		0x12
#define WSTRD19		0x13
#define WSTRD20		0x14
#define WSTRD21		0x15
#define WSTRD22         0x16
#define WSTRD23		0x17
#define WSTRD24		0x18
#define WSTRD25		0x19
#define WSTRD26		0x1A
#define WSTRD27		0x1B
#define WSTRD28         0x1C
#define WSTRD29		0x1D
#define WSTRD30		0x1E
#define WSTRD31		0x1F

#define RD0             0x00
#define RD1             0x01
#define RD2             0x02
#define RD3             0x03
#define RD4             0x04
#define RD5             0x05
#define RD6             0x06
#define RD7             0x07
#define RD8             0x08
#define RD9             0x09
#define RD10            0x0A
#define RD11            0x0B
#define RD12            0x0C
#define RD13            0x0D
#define RD14            0x0E
#define RD15            0x0F
#define RD16            0x10
#define RD17            0x11
#define RD18            0x12
#define RD19            0x13
#define RD20            0x14
#define RD21            0x15
#define RD22            0x16
#define RD23            0x17
#define RD24            0x18
#define RD25            0x19
#define RD26            0x1A
#define RD27            0x1B
#define RD28         	0x1C
#define RD29         	0x1D
#define RD30         	0x1E
#define RD31         	0x1F

/******************************************************************************/
/************DIFFERENT VALUES FOR WRITE WAIT STATES FIELD *********************/
/******************************************************************************/
#define WSTWR0          0x00
#define WSTWR1          0x01
#define WSTWR2          0x02
#define WSTWR3          0x03
#define WSTWR4          0x04
#define WSTWR5          0x05
#define WSTWR6          0x06
#define WSTWR7          0x07
#define WSTWR8          0x08
#define WSTWR9          0x09
#define WSTWR10         0x0A
#define WSTWR11         0x0B
#define WSTWR12         0x0C
#define WSTWR13         0x0D
#define WSTWR14         0x0E
#define WSTWR15         0x0F
#define WSTWR16		0x10
#define WSTWR17         0x11
#define WSTWR18       	0x12
#define WSTWR19     	0x13
#define WSTWR20       	0x14
#define WSTWR21      	0x15
#define WSTWR22     	0x16
#define WSTWR23    	0x17
#define WSTWR24		0x18
#define WSTWR25         0x19
#define WSTWR26         0x1A
#define WSTWR27         0x1B
#define WSTWR28         0x1C
#define WSTWR29         0x1D
#define WSTWR30         0x1E
#define WSTWR31         0x1F

#define WR0             0x00
#define WR1             0x01
#define WR2             0x02
#define WR3             0x03
#define WR4             0x04
#define WR5             0x05
#define WR6             0x06
#define WR7             0x07
#define WR8             0x08
#define WR9             0x09
#define WR10            0x0A
#define WR11            0x0B
#define WR12            0x0C
#define WR13            0x0D
#define WR14            0x0E
#define WR15            0x0F
#define WR16            0x10
#define WR17            0x11
#define WR18            0x12
#define WR19            0x13
#define WR20            0x14
#define WR21            0x15
#define WR22            0x16
#define WR23            0x17
#define WR24            0x18
#define WR25            0x19
#define WR26            0x1A
#define WR27            0x1B
#define WR28            0x1C
#define WR29            0x1D
#define WR30            0x1E
#define WR31            0x1F

/******************************************************************************/
/*************DIFFERENT VALUES FOR OUTPUT ENABLE DALAY FIELD ******************/
/******************************************************************************/
#define WSTOEN0          0x00
#define WSTOEN1          0x01
#define WSTOEN2          0x02
#define WSTOEN3          0x03
#define WSTOEN4          0x04
#define WSTOEN5          0x05
#define WSTOEN6          0x06
#define WSTOEN7          0x07
#define WSTOEN8          0x08
#define WSTOEN9          0x09
#define WSTOEN10         0x0A
#define WSTOEN11         0x0B
#define WSTOEN12         0x0C
#define WSTOEN13         0x0D
#define WSTOEN14         0x0E
#define WSTOEN15         0x0F

#define OEN0             0x00
#define OEN1             0x01
#define OEN2             0x02
#define OEN3             0x03
#define OEN4             0x04
#define OEN5             0x05
#define OEN6             0x06
#define OEN7             0x07
#define OEN8             0x08
#define OEN9             0x09
#define OEN10            0x0A
#define OEN11            0x0B
#define OEN12            0x0C
#define OEN13            0x0D
#define OEN14            0x0E
#define OEN15            0x0F


/******************************************************************************/
/************ DIFFERENT VALUES FOR WRITE ENABLE DELAY FIELD *******************/
/******************************************************************************/
#define WSTWEN0          0x00
#define WSTWEN1          0x01
#define WSTWEN2          0x02
#define WSTWEN3          0x03
#define WSTWEN4          0x04
#define WSTWEN5          0x05
#define WSTWEN6          0x06
#define WSTWEN7          0x07
#define WSTWEN8          0x08
#define WSTWEN9          0x09
#define WSTWEN10         0x0A
#define WSTWEN11         0x0B
#define WSTWEN12         0x0C
#define WSTWEN13         0x0D
#define WSTWEN14         0x0E
#define WSTWEN15         0x0F

#define WEN0             0x00
#define WEN1             0x01
#define WEN2             0x02
#define WEN3             0x03
#define WEN4             0x04
#define WEN5             0x05
#define WEN6             0x06
#define WEN7             0x07
#define WEN8             0x08
#define WEN9             0x09
#define WEN10            0x0A
#define WEN11            0x0B
#define WEN12            0x0C
#define WEN13            0x0D
#define WEN14            0x0E
#define WEN15            0x0F

/******************************************************************************/
/************ DIFFERENT VALUES FOR BURST WAIT STATE  FIELD ********************/
/******************************************************************************/
#define WSTBRD0          0x00
#define WSTBRD1          0x01
#define WSTBRD2          0x02
#define WSTBRD3          0x03
#define WSTBRD4          0x04
#define WSTBRD5          0x05
#define WSTBRD6          0x06
#define WSTBRD7          0x07
#define WSTBRD8          0x08
#define WSTBRD9          0x09
#define WSTBRD10         0x0A
#define WSTBRD11         0x0B
#define WSTBRD12         0x0C
#define WSTBRD13         0x0D
#define WSTBRD14         0x0E
#define WSTBRD15         0x0F
#define WSTBRD16         0x10
#define WSTBRD17         0x11
#define WSTBRD18         0x12
#define WSTBRD19         0x13
#define WSTBRD20         0x14
#define WSTBRD21         0x15
#define WSTBRD22         0x16
#define WSTBRD23         0x17
#define WSTBRD24         0x18
#define WSTBRD25         0x19
#define WSTBRD26         0x1A
#define WSTBRD27         0x1B
#define WSTBRD28         0x1C
#define WSTBRD29         0x1D
#define WSTBRD30         0x1E
#define WSTBRD31         0x1F

#define BRD0             0x00
#define BRD1             0x01
#define BRD2             0x02
#define BRD3             0x03
#define BRD4             0x04
#define BRD5             0x05
#define BRD6             0x06
#define BRD7             0x07
#define BRD8             0x08
#define BRD9             0x09
#define BRD10            0x0A
#define BRD11            0x0B
#define BRD12            0x0C
#define BRD13            0x0D
#define BRD14            0x0E
#define BRD15            0x0F
#define BRD16            0x10
#define BRD17            0x11
#define BRD18            0x12
#define BRD19            0x13
#define BRD20            0x14
#define BRD21            0x15
#define BRD22            0x16
#define BRD23            0x17
#define BRD24            0x18
#define BRD25            0x19
#define BRD26            0x1A
#define BRD27            0x1B
#define BRD28            0x1C
#define BRD29            0x1D
#define BRD30            0x1E
#define BRD31            0x1F

/******************************************************************************/
/********** DIFFERENT VALUES FOR  THE  SSMC Control Register Fields ***********/
/******************************************************************************/
#define BIWRITE_DI			0x00000000
#define BIWRITE_EN			0x00200000

#define CRADDRVALIDWR_DI	   	0x00000000
#define CRADDRVALIDWR_EN		0x00100000

#define CRBURSTLENWR4	          	0x00000000
#define CRBURSTLENWR8	          	0x00040000
#define CRBURSTLENWRCONT	      	0x000C0000
#define BLENWR4                         0x00000000
#define BLENWR8                         0x00040000
#define BLENWRC                         0x000C0000
#define BLWR4                         	0x00000000
#define BLWR8                         	0x00040000
#define BLWRC                         	0x000C0000

#define CRSYNCENWR_ASY	        	0x00000000
#define CRSYNCENWR_SY		 	0x00020000

#define CRBMWRITE_DI			0x00000000
#define CRBMWRITE_EN			0x00010000

#define WRAPRD_DI			0x00000000
#define WRAPRD_EN			0x00004000

#define BIREAD_DI			0x00000000
#define BIREAD_EN			0x00002000

#define CRADDRVALIDRD_DI            	0x00000000
#define CRADDRVALIDRD_EN           	0x00001000

#define CRBURSTLENRD4                	0x00000000
#define CRBURSTLENRD8                	0x00000400
#define CRBURSTLENRD16                	0x00000800
#define CRBURSTLENRDCONT	       	0x00000C00
#define BLENRD4                         0x00000000
#define BLENRD8                         0x00000400
#define BLENRD16                        0x00000800
#define BLENRDC                         0x00000C00
#define BLRD4                         	0x00000000
#define BLRD8                         	0x00000400
#define BLRD16                         	0x00000800
#define BLRDC                         	0x00000C00

#define CRSYNCENRD_ASY			0x00000000
#define CRSYNCENRD_SY			0x00000200

#define CRBMREAD_DI			0x00000000
#define CRBMREAD_EN			0x00000100

#define SMBLSPOL_0			0x00000000
#define SMBLSPOL_1			0x00000040

#define CRMW8				0x00000000
#define CRMW16				0x00000010
#define CRMW32				0x00000020
#define MW8                             0x00000000
#define MW16 			        0x00000010
#define MW32                            0x00000020

#define CRWP_DI				0x00000000
#define CRWP_EN				0x00000008

#define CRWAITEN_DI			0x00000000
#define CRWAITEN_EN			0x00000004

#define CRWAITPOL_0			0x00000000
#define CRWAITPOL_1			0x00000002

#define RBLE_0				0x00000000
#define RBLE_1				0x00000001
#define RBL0				0x00000000
#define RBL1				0x00000001

/******************************************************************************/
/*********** DIFFERENT VALUES FOR THE SSMCCR Register Feild Values ************/
/******************************************************************************/
#define CLKR11                          0x00000000
#define CLKR12                          0x00000002
#define CLKR13                          0x00000004

#define	CLKDI				0x00000000
#define	CLKEN				0x00000001

#define CLKSTATUS                       CLKEN
/******************************************************************************/
/********** DIFFERENT VALUES FOR THE SMMemCLKRatio REG FEILD VALUES ***********/
/******************************************************************************/
#define MEMCR11                          0x00000000
#define MEMCR12                          0x00000001
#define MEMCR13                          0x00000002

#define MEMCLKRATIO                      CLKRATIO
/******************************************************************************/
/********** DIFFERENT VALUES FOR THE SSMCTrCS2WTRx Reg Feild Values ***********/
/******************************************************************************/
#define TRWAITEN_DI	0x00000000
#define TRWAITEN_EN	0x00000800
#define TRWT_DI         0x00000000
#define TRWT_EN         0x00000800
#define WTDI            0x00000000
#define WTEN            0x00000800


#define TRWAITPOL_0	0x00000000
#define TRWAITPOL_1	0x00000400
#define TRWTPOL_0	0x00000000
#define TRWTPOL_1	0x00000400
#define WTPOL0          0x00000000
#define WTPOL1          0x00000400


#define TRCS2WTR1 	0x00000020
#define TRCS2WTR2	0x00000040	
#define TRCS2WTR3	0x00000060
#define TRCS2WTR4	0x00000080
#define TRCS2WTR5	0x000000A0
#define TRCS2WTR6	0x000000C0
#define TRCS2WTR7	0x000000E0
#define TRCS2WTR8	0x00000100
#define TRCS2WTR9	0x00000120
#define TRCS2WTR10	0x00000140
#define TRCS2WTR11	0x00000160
#define TRCS2WTR12	0x00000180
#define TRCS2WTR13	0x000001A0
#define TRCS2WTR14	0x000001C0
#define TRCS2WTR15	0x000001E0
#define TRCS2WTR16      0x00000200
#define TRCS2WTR17      0x00000220
#define TRCS2WTR18      0x00000240
#define TRCS2WTR19      0x00000260
#define TRCS2WTR20      0x00000280
#define TRCS2WTR21      0x000002A0
#define TRCS2WTR22      0x000002C0
#define TRCS2WTR23      0x000002E0
#define TRCS2WTR24      0x00000300
#define TRCS2WTR25      0x00000320
#define TRCS2WTR26      0x00000340
#define TRCS2WTR27      0x00000360
#define TRCS2WTR28      0x00000380
#define TRCS2WTR29      0x000003A0
#define TRCS2WTR30      0x000003C0
#define TRCS2WTR31      0x000003E0

#define CS2WTR1       0x00000020
#define CS2WTR2       0x00000040
#define CS2WTR3       0x00000060
#define CS2WTR4       0x00000080
#define CS2WTR5       0x000000A0
#define CS2WTR6       0x000000C0
#define CS2WTR7       0x000000E0
#define CS2WTR8       0x00000100
#define CS2WTR9       0x00000120
#define CS2WTR10      0x00000140
#define CS2WTR11      0x00000160
#define CS2WTR12      0x00000180
#define CS2WTR13      0x000001A0
#define CS2WTR14      0x000001C0
#define CS2WTR15      0x000001E0
#define CS2WTR16      0x00000200
#define CS2WTR17      0x00000220
#define CS2WTR18      0x00000240
#define CS2WTR19      0x00000260
#define CS2WTR20      0x00000280
#define CS2WTR21      0x000002A0
#define CS2WTR22      0x000002C0
#define CS2WTR23      0x000002E0
#define CS2WTR24      0x00000300
#define CS2WTR25      0x00000320
#define CS2WTR26      0x00000340
#define CS2WTR27      0x00000360
#define CS2WTR28      0x00000380
#define CS2WTR29      0x000003A0
#define CS2WTR30      0x000003C0
#define CS2WTR31      0x000003E0

#define TRWT2DEWT1	0x00000001
#define TRWT2DEWT2	0x00000002
#define TRWT2DEWT3	0x00000003
#define TRWT2DEWT4	0x00000004
#define TRWT2DEWT5	0x00000005
#define TRWT2DEWT6	0x00000006
#define TRWT2DEWT7	0x00000007
#define TRWT2DEWT8	0x00000008
#define TRWT2DEWT9	0x00000009
#define TRWT2DEWT10	0x0000000A
#define TRWT2DEWT11	0x0000000B
#define TRWT2DEWT12	0x0000000C
#define TRWT2DEWT13	0x0000000D
#define TRWT2DEWT14	0x0000000E
#define TRWT2DEWT15	0x0000000F
#define TRWT2DEWT16     0x00000010
#define TRWT2DEWT17     0x00000011
#define TRWT2DEWT18     0x00000012
#define TRWT2DEWT19     0x00000013
#define TRWT2DEWT20     0x00000014
#define TRWT2DEWT21     0x00000015
#define TRWT2DEWT22     0x00000016
#define TRWT2DEWT23     0x00000017
#define TRWT2DEWT24     0x00000018
#define TRWT2DEWT25     0x00000019
#define TRWT2DEWT26     0x0000001A
#define TRWT2DEWT27     0x0000001B
#define TRWT2DEWT28     0x0000001C
#define TRWT2DEWT29     0x0000001D
#define TRWT2DEWT30     0x0000001E
#define TRWT2DEWT31     0x0000001F

#define WT2DEWT1      0x00000001
#define WT2DEWT2      0x00000002
#define WT2DEWT3      0x00000003
#define WT2DEWT4      0x00000004
#define WT2DEWT5      0x00000005
#define WT2DEWT6      0x00000006
#define WT2DEWT7      0x00000007
#define WT2DEWT8      0x00000008
#define WT2DEWT9      0x00000009
#define WT2DEWT10     0x0000000A
#define WT2DEWT11     0x0000000B
#define WT2DEWT12     0x0000000C
#define WT2DEWT13     0x0000000D
#define WT2DEWT14     0x0000000E
#define WT2DEWT15     0x0000000F
#define WT2DEWT16     0x00000010
#define WT2DEWT17     0x00000011
#define WT2DEWT18     0x00000012
#define WT2DEWT19     0x00000013
#define WT2DEWT20     0x00000014
#define WT2DEWT21     0x00000015
#define WT2DEWT22     0x00000016
#define WT2DEWT23     0x00000017
#define WT2DEWT24     0x00000018
#define WT2DEWT25     0x00000019
#define WT2DEWT26     0x0000001A
#define WT2DEWT27     0x0000001B
#define WT2DEWT28     0x0000001C
#define WT2DEWT29     0x0000001D
#define WT2DEWT30     0x0000001E
#define WT2DEWT31     0x0000001F

/******************************************************************************/
/************************ SSMCTrWTCNCL VALUES  ********************************/
/******************************************************************************/
#define SMWTCNCLDI       0x00000000
#define SMWTCNCLEN       0x00000100
#define SMWAITIGNORE_0   0x00000000
#define SMWAITIGNORE_1   0x00000080
#define TRWTIGNORE_0     0x00000000
#define TRWTIGNORE_1     0x00000080
#define TRWTIGN_0        0x00000000
#define TRWTIGN_1        0x00000080
#define WTIG0            0x00000000
#define WTIG1            0x00000080


#define WTCNCL0       0x00000000
#define WTCNCL1       0x00000001
#define WTCNCL2       0x00000002
#define WTCNCL3       0x00000003
#define WTCNCL4       0x00000004
#define WTCNCL5       0x00000005
#define WTCNCL6       0x00000006
#define WTCNCL7       0x00000007
#define WTCNCL8       0x00000008
#define WTCNCL9       0x00000009
#define WTCNCL10      0x0000000A
#define WTCNCL11      0x0000000B
#define WTCNCL12      0x0000000C
#define WTCNCL13      0x0000000D
#define WTCNCL14      0x0000000E
#define WTCNCL15      0x0000000F
#define WTCNCL16      0x00000010
#define WTCNCL17      0x00000011
#define WTCNCL18      0x00000012
#define WTCNCL19      0x00000013
#define WTCNCL20      0x00000014
#define WTCNCL21      0x00000015
#define WTCNCL22      0x00000016
#define WTCNCL23      0x00000017
#define WTCNCL24      0x00000018
#define WTCNCL25      0x00000019
#define WTCNCL26      0x0000001A
#define WTCNCL27      0x0000001B
#define WTCNCL28      0x0000001C
#define WTCNCL29      0x0000001D
#define WTCNCL30      0x0000001E
#define WTCNCL31      0x0000001F
#define WTCNCL32      0x00000020
#define WTCNCL33      0x00000021
#define WTCNCL34      0x00000022
#define WTCNCL35      0x00000023
#define WTCNCL36      0x00000024
#define WTCNCL37      0x00000025
#define WTCNCL38      0x00000026
#define WTCNCL39      0x00000027
#define WTCNCL40      0x00000028
#define WTCNCL41      0x00000029
#define WTCNCL42      0x0000002A
#define WTCNCL43      0x0000002B
#define WTCNCL44      0x0000002C
#define WTCNCL45      0x0000002D
#define WTCNCL46      0x0000002E
#define WTCNCL47      0x0000002F
#define WTCNCL48      0x00000030
#define WTCNCL49      0x00000031
#define WTCNCL50      0x00000032
#define WTCNCL51      0x00000033
#define WTCNCL52      0x00000034
#define WTCNCL53      0x00000035
#define WTCNCL54      0x00000036
#define WTCNCL55      0x00000037
#define WTCNCL56      0x00000038
#define WTCNCL57      0x00000039
#define WTCNCL58      0x0000003A
#define WTCNCL59      0x0000003B
#define WTCNCL60      0x0000003C
#define WTCNCL61      0x0000003D
#define WTCNCL62      0x0000003E
#define WTCNCL63      0x0000003F

/******************************************************************************/
/************************ SSMCTrBurstWT VALUES  *******************************/
/******************************************************************************/
#define SSMCTrBurstWT0	0x00000000
#define SSMCTrBurstWT1	0x00000001
#define SSMCTrBurstWT2	0x00000002
#define SSMCTrBurstWT3	0x00000003
#define SSMCTrBurstWT4	0x00000004
#define SSMCTrBurstWT5	0x00000005
#define SSMCTrBurstWT6	0x00000006
#define SSMCTrBurstWT7	0x00000007	
#define SSMCTrBurstWT8	0x00000008
#define SSMCTrBurstWT9	0x00000009
#define SSMCTrBurstWT10	0x0000000A
#define SSMCTrBurstWT11	0x0000000B
#define SSMCTrBurstWT12	0x0000000C
#define SSMCTrBurstWT13	0x0000000D
#define SSMCTrBurstWT14	0x0000000E
#define SSMCTrBurstWT15	0x0000000F

#define Beat0	0x00000000
#define Beat1	0x00000010
#define Beat2	0x00000020
#define Beat3	0x00000030
#define Beat4	0x00000040
#define Beat5	0x00000050
#define Beat6	0x00000060
#define Beat7	0x00000070	
#define Beat8	0x00000080
#define Beat9	0x00000090
#define Beat10	0x000000A0
#define Beat11	0x000000B0
#define Beat12	0x000000C0
#define Beat13	0x000000D0
#define Beat14	0x000000E0
#define Beat15	0x000000F0

#define BWtMask_ON  0x00000100
#define BWtMask_OFF 0x00000000

#define BWtMask_EN 0x00000100
#define BWtMask_DI 0x00000000

/******************************************************************************/
/********************************* HBURST VALUES ******************************/
/******************************************************************************/

#define SIN     0
#define INC	1
#define INC4	2
#define INC8	3
#define INC16	4
#define WRP4	5
#define WRP8	6
#define WRP16	7

/******************************************************************************/
/****************************** ENDIANESS  VALUES *****************************/
/******************************************************************************/
#define small	0
#define big	1

/******************************************************************************/
/****************************** Ext Mux Values    *****************************/
/******************************************************************************/
#define ExtMuxDI 0x00000000
#define ExtMuxEN 0x00000001

#define ExtMuxDAss0     0x00000000
#define ExtMuxDAss1     0x00000002
#define ExtMuxDAss2	0x00000004
#define ExtMuxDAss3 	0x00000006
#define ExtMuxDAss4 	0x00000008
#define ExtMuxDAss5 	0x0000000A
#define ExtMuxDAss6 	0x0000000C
#define ExtMuxDAss7 	0x0000000E
#define ExtMuxDAss8 	0x00000010
#define ExtMuxDAss9 	0x00000012
#define ExtMuxDAss10 	0x00000014
#define ExtMuxDAss11 	0x00000016
#define ExtMuxDAss12 	0x00000018
#define ExtMuxDAss13	0x0000001A
#define ExtMuxDAss14 	0x0000001C
#define ExtMuxDAss15 	0x0000001E
 
#define ExtMuxAss0      0x00000000
#define ExtMuxAss1      0x00000020
#define ExtMuxAss2	0x00000040
#define ExtMuxAss3 	0x00000060
#define ExtMuxAss4 	0x00000080
#define ExtMuxAss5 	0x000000A0
#define ExtMuxAss6 	0x000000C0
#define ExtMuxAss7 	0x000000E0
#define ExtMuxAss8 	0x00000100
#define ExtMuxAss9 	0x00000120
#define ExtMuxAss10 	0x00000140
#define ExtMuxAss11 	0x00000160
#define ExtMuxAss12 	0x00000180
#define ExtMuxAss13	0x000001A0
#define ExtMuxAss14 	0x000001C0
#define ExtMuxAss15 	0x000001E0
 
/************************************** END ***********************************/
