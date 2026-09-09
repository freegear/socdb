/* --===================================================================
--  This confidential and proprietary software may be used only as
--  authorised by a licensing agreement from ARM Limited
--    (C) COPYRIGHT 2000 ARM Limited
--        ALL RIGHTS RESERVED
--  The entire notice above must be reproduced on all authorised
--  copies and copies may only be made to the extent permitted
--  by a licensing agreement from ARM Limited.
--  
------------------------------------------------------------------------
--  Version and Release Control Information:
--  
--  File Name              : Aaci.h.rca
--  File Revision          : 1.5
--  
--  Release Information    : PrimeCell(TM)-PL041-REL1v0
--  
------------------------------------------------------------------------
--  Purpose  : 
--            This file contains the register offsets and other 
--            definitions for the Aaci.c functional test code.
--
-- --=================================================================*/

/**********************************************************************/
/* Register       Offset Size Type Function                           */
/* ================================================================== */
/* AACI Normal Registers                                              */
/* =====================                                              */
/* AACIRXCR1      0x00   29   R/W  Control Register for RxFIFO1       */
/* AACITXCR1      0x04   17   R/W  Control Register for TxFIFO1       */
/* AACISR1        0x08   11   R/W  Status register for channel1       */
/* AACIISR1       0x0C   6    R    Interrupt status/clear channel1    */
/* AACIIE1        0x10   6    R/W  Interrupt Enable for channel1      */
/* AACIRXCR2      0x14   29   R/W  Control Register for recieve FIFO2 */
/* AACITXCR2      0x18   17   R/W  Control Register for TxFIFO2       */
/* AACISR2        0x1C   11   R/W  Status register for channel2       */
/* AACIISR2       0x20   6    R    Interrupt status/clear channel2    */
/* AACIIE2        0x24   6    R/W  Interrupt Enable for channel2      */
/* AACIRXCR3      0x28   29   R/W  Control Register for recieve FIFO3 */
/* AACITXCR3      0x2C   17   R/W  Control Register for TxFIFO3       */
/* AACISR3        0x30   11   R/W  Status register for channel3       */
/* AACIISR3       0x34   6    R    Interrupt status/clear channel3    */
/* AACIIE3        0x38   6    R/W  Interrupt Enable for channel3      */
/* AACIRXCR4      0x3C   29   R/W  Control Register for recieve FIFO4 */
/* AACITXCR4      0x40   17   R/W  Control Register for TxFIFO4       */
/* AACISR4        0x44   11   R/W  Status register for channel4       */
/* AACIISR4       0x48   6    R    Interrupt status/clear channel4    */
/* AACIIE4        0x4C   6    R/W  Interrupt Enable for channel4      */
/* AACISL1RX      0x50   20   R    Data recieved on SLOT1             */
/* AACISL1TX      0x54   20   R/W  Data transmitted on SLOT1          */
/* AACISL2RX      0x58   20   R    Data recieved on SLOT2             */
/* AACISL2TX      0x5C   20   R/W  Data transmitted on SLOT2          */
/* AACISL12RX     0x60   20   R    Data recieved on SLOT12            */
/* AACISL12TX     0x64   20   R/W  Data transmitted on SLOT12         */
/* AACISLFR       0x68   14   R/W  Raw interrupt status Register      */
/* AACISLISTAT    0x6C   8    R    Interrupt status Register          */
/* AACISLIEN      0x70   9    R/W  Slot interrupt Enable Register     */
/* AACIINTCLR     0x74   1    W    Interrupt clear register    */
/* AACIMAINCR     0x78   12   R/W  Main control register              */
/* AACIRESET      0x7C   1    R/W  Reset control Register             */
/* AACISYNC       0x80   1    R/W  Sync Control Register              */
/* AACIALLINTS    0x84   32   R    All FIFO interrupt status Register */
/* AACIMAINFR     0x88   2    R    Main status register for FIFOs     */
/* AACIDR1        0x90   32   R/W  Data read or written from/to FIFO1 */
/* AACIDR2        0xB0   32   R/W  Data read or written from/to FIFO2 */
/* AACIDR3        0xD0   32   R/W  Data read or written from/to FIFO3 */
/* AACIDR4        0xF0   32   R/W  Data read or written from/to FIFO4 */

/* AACI Test  Registers                                               */
/* ===================                                                */
/* AACITCR        0x180  4    R/W  Integration Test Control Register  */
/* AACIITIP       0x184  3/   R/   Integration Test Input Read        */
/*                                 Register                           */
/* AACIITIP       0x184  2    W    Integration Test Input Set Register*/
/* AACIITOP0      0x188  30   R/W  Integration Test Output Set/Read   */
/*                                 Register0                          */
/* AACIITOP1      0x18C  13   R/W  Integration Test Output Set/Read   */
/*                                 Register0                          */ 
/* AACI Identification Registers                                      */
/* ===================                                                */
/* AACIPERIPHID0  0x0FE0 8    R    Identification register bits 7:0   */
/* AACIPERIPHID1  0x0FE4 8    R    Identification register bits 15:8  */
/* AACIPERIPHID2  0x0FE8 8    R    Identification register bits 23:16 */
/* AACIPERIPHID3  0x0FEC 8    R    Identification register bits 31:24 */

/* AACIPCELLLID0  0x0FF0 8    R    PrimeCell ID  register bits 7:0    */
/* AACIPCELLLID1  0x0FF4 8    R    PrimeCell ID  register bits 15:8   */
/* AACIPCELLLID2  0x0FF8 8    R    PrimeCell ID  register bits 23:16  */
/* AACIPCELLLID3  0x0FFC 8    R    PrimeCell ID  register bits 31:24  */

/**********************************************************************/

/**********************************************************************/
/*** For more information on the Aaci, please refer to PL041        ***/
/*** AMBA AACI Block Specification                                  ***/
/**********************************************************************/

/*********************************************************************/
/* Modify this define to reflect the period of the PCLK and set in   */
/* AACIBITCLK_PERIOD
/*********************************************************************/
#define AACIBITCLK_PERIOD  80
#define PCLK_PERIOD        10

/**********************************************************************/
/* Modify this define to reflect the period of the AACICLK set in the */
/* tb_Aaci.vhd testbench.                                             */
/**********************************************************************/
#define SLOT_TIME       ((AACIBITCLK_PERIOD * 20 ) / PCLK_PERIOD)
#define BITCLK_TIME     (AACIBITCLK_PERIOD  / PCLK_PERIOD)

/**********************************************************************/
/******************** AACI NORMAL-MODE REGISTERS  *********************/
/**********************************************************************/
#define AACIBASE_ADD   0x84000000
#define AACIRXCR1      (AACIBASE_ADD + 0x00)
#define AACITXCR1      (AACIBASE_ADD + 0x04)
#define AACISR1        (AACIBASE_ADD + 0x08)
#define AACIISR1       (AACIBASE_ADD + 0x0C) 
#define AACIIE1        (AACIBASE_ADD + 0x10)
#define AACIRXCR2      (AACIBASE_ADD + 0x14)
#define AACITXCR2      (AACIBASE_ADD + 0x18)
#define AACISR2        (AACIBASE_ADD + 0x1C)
#define AACIISR2       (AACIBASE_ADD + 0x20)
#define AACIIE2        (AACIBASE_ADD + 0x24)
#define AACIRXCR3      (AACIBASE_ADD + 0x28)
#define AACITXCR3      (AACIBASE_ADD + 0x2C)
#define AACISR3        (AACIBASE_ADD + 0x30)
#define AACIISR3       (AACIBASE_ADD + 0x34)
#define AACIIE3        (AACIBASE_ADD + 0x38)
#define AACIRXCR4      (AACIBASE_ADD + 0x3C)
#define AACITXCR4      (AACIBASE_ADD + 0x40)
#define AACISR4        (AACIBASE_ADD + 0x44)
#define AACIISR4       (AACIBASE_ADD + 0x48)
#define AACIIE4        (AACIBASE_ADD + 0x4C)
#define AACISL1RX      (AACIBASE_ADD + 0x50)
#define AACISL1TX      (AACIBASE_ADD + 0x54)
#define AACISL2RX      (AACIBASE_ADD + 0x58)
#define AACISL2TX      (AACIBASE_ADD + 0x5C)
#define AACISL12RX     (AACIBASE_ADD + 0x60)
#define AACISL12TX     (AACIBASE_ADD + 0x64)
#define AACISLFR       (AACIBASE_ADD + 0x68)
#define AACISLISTAT    (AACIBASE_ADD + 0x6C)
#define AACISLIEN      (AACIBASE_ADD + 0x70)
#define AACIINTCLR     (AACIBASE_ADD + 0x74)
#define AACIMAINCR     (AACIBASE_ADD + 0x78)
#define AACIRESET      (AACIBASE_ADD + 0x7C)
#define AACISYNC       (AACIBASE_ADD + 0x80)
#define AACIALLINTS    (AACIBASE_ADD + 0x84)
#define AACIMAINFR     (AACIBASE_ADD + 0x88)

#define AACIDR1        (AACIBASE_ADD + 0x90)
#define AACIDR2        (AACIBASE_ADD + 0xB0)
#define AACIDR3        (AACIBASE_ADD + 0xD0)
#define AACIDR4        (AACIBASE_ADD + 0xF0)

/**********************************************************************/
/******************** Test control register  **************************/
/**********************************************************************/
#define AACITCR         (AACIBASE_ADD + 0x180)
#define AACIITIP        (AACIBASE_ADD + 0x184)
#define AACIITOP0       (AACIBASE_ADD + 0x188)
#define AACIITOP1       (AACIBASE_ADD + 0x18C)

/**********************************************************************/
/********************* Pheripheral id registers  **********************/
/**********************************************************************/
#define AACIPERIPHID0   (AACIBASE_ADD + 0x0FE0)
#define AACIPERIPHID1   (AACIBASE_ADD + 0x0FE4)
#define AACIPERIPHID2   (AACIBASE_ADD + 0x0FE8)
#define AACIPERIPHID3   (AACIBASE_ADD + 0x0FEC)

#define AACIPCELLID0    (AACIBASE_ADD + 0x0FF0)
#define AACIPCELLID1    (AACIBASE_ADD + 0x0FF4)
#define AACIPCELLID2    (AACIBASE_ADD + 0x0FF8)
#define AACIPCELLID3    (AACIBASE_ADD + 0x0FFC)

/**********************************************************************/
/******************** MASKS FOR REGISTERS *****************************/
/**********************************************************************/
/* AACI Register Masks */
#define MASK_ALL           0xFFFFFFFF
#define MASK_AACIRXCR      0x1FFFFFFF
#define MASK_AACITXCR      0x0001FFFF
#define MASK_AACISR        0x000007FF
#define MASK_AACIISR       0x0000003F
#define MASK_AACIIE        0x0000007F
#define MASK_AACISL1RX     0x000FFFFF
#define MASK_AACISL1TX     0x000FFFFF
#define MASK_AACISL2RX     0x000FFFFF
#define MASK_AACISL2TX     0x000FFFFF
#define MASK_AACISL12RX    0x000FFFFF
#define MASK_AACISL12TX    0x000FFFFF
#define MASK_AACISLFR      0x00003FFF
#define MASK_AACISLISTAT   0x000000FF
#define MASK_AACISLIEN     0x000001FF
#define MASK_AACIINTCLR    0x00001FFF
#define MASK_AACIMAINCR    0x00000FFF
#define MASK_AACIRESET     0x00000001
#define MASK_AACISYNC      0x00000001
#define MASK_AACIALLINTS   0xFFFFFFFF
#define MASK_AACIDR        0xFFFFFFFF

#define MASK_AACITCR       0x0000000F
#define MASK_AACIITIP      0x00000003
#define MASK_AACIITOP0     0x3FFFFFFF
#define MASK_AACIITOP1     0x00001FFF

#define MASK_AACIPID0      0x000000FF
#define MASK_AACIPID1      0x000000FF
#define MASK_AACIPID2      0x000000FF
#define MASK_AACIPID3      0x000000FF

#define MASK_AACIPCID0     0x000000FF
#define MASK_AACIPCID1     0x000000FF
#define MASK_AACIPCID2     0x000000FF
#define MASK_AACIPCID3     0x000000FF

/**********************************************************************/
/************************ EXPECTED ID VALUES **************************/
/**********************************************************************/
#define EXP_AACIPCID0      0x0000000D
#define EXP_AACIPCID1      0x000000F0
#define EXP_AACIPCID2      0x00000005
#define EXP_AACIPCID3      0x000000B1

#define EXP_AACIPID0       0x00000041
#define EXP_AACIPID1       0x00000010
#define EXP_AACIPID2       0x00000004
#define EXP_AACIPID3       0x00000000

/**********************************************************************/
/******************** REGISTER BIT MASKS ******************************/
/**********************************************************************/
/* AACITrFIFOStat Register Mask  */
#define MASK_RxFFFillLevel   0x0000FFFF
#define MASK_TxFFFillLevel   0xFFFF0000
 
/**********************************************************************/
/*************** REGISTER RESET VALUES ********************************/
/**********************************************************************/
/* AACI Registers Reset value */
#define RESET_AACISR      0x000B
#define RESET_AACIRESET   0x01
#define RESET_AACISLFR    0xA80
#define RESET_AACIITOP0   0x00000000

/**********************************************************************/
/******************** REGISTER FIELD VALUES ***************************/
/**********************************************************************/
/* AACIRXCR register values */
#define  AACI_TOC1       0x00000000
#define  AACI_TOC2       0x001E0000
#define  AACI_TOC3       0x1FFE0000
#define  AACI_FEN        0x00010000
#define  AACI_CM         0x00008000
#define  AACI_RSIZE16    0x00000000
#define  AACI_RSIZE18    0x00002000
#define  AACI_RSIZE20    0x00004000
#define  AACI_RSIZE12    0x00006000
#define  AACI_RX12       0x00001000
#define  AACI_RX11       0x00000800
#define  AACI_RX10       0x00000400
#define  AACI_RX9        0x00000200
#define  AACI_RX8        0x00000100
#define  AACI_RX7        0x00000080
#define  AACI_RX6        0x00000040
#define  AACI_RX5        0x00000020
#define  AACI_RX4        0x00000010
#define  AACI_RX3        0x00000008
#define  AACI_RX2        0x00000004
#define  AACI_RX1        0x00000002
#define  AACI_REN        0x00000001
#define  AACI_RX3_12     0x00001FF8

/* AACITXCR register values */
#define  AACI_TSIZE16    0x00000000
#define  AACI_TSIZE18    0x00002000
#define  AACI_TSIZE20    0x00004000
#define  AACI_TSIZE12    0x00006000
#define  AACI_TX12       0x00001000
#define  AACI_TX11       0x00000800
#define  AACI_TX10       0x00000400
#define  AACI_TX9        0x00000200
#define  AACI_TX8        0x00000100
#define  AACI_TX7        0x00000080
#define  AACI_TX6        0x00000040
#define  AACI_TX5        0x00000020
#define  AACI_TX4        0x00000010
#define  AACI_TX3        0x00000008
#define  AACI_TX2        0x00000004
#define  AACI_TX1        0x00000002
#define  AACI_TEN        0x00000001
#define  AACI_TX3_12     0x00001FF8

/* AACISR register bit positions */
#define AACI_TOEFE       0x800
#define AACI_TIMEOUT     0x400
#define AACI_TXUE        0x200
#define AACI_RXOE        0x100
#define AACI_TXBUSY      0x080
#define AACI_RXBUSY      0x040
#define AACI_TXFF        0x020
#define AACI_RXFF        0x010
#define AACI_TXHE        0x008
#define AACI_RXHF        0x004
#define AACI_TXFE        0x002
#define AACI_RXFE        0x001

/* AACIISR register bit positions */
#define AACI_RXTOFEIS    0x40
#define AACI_TXUIS       0x20
#define AACI_ORIS        0x10
#define AACI_RIS         0x08
#define AACI_TIS         0x04
#define AACI_RTIS        0x02
#define AACI_TCIS        0x01
 
/* AACIIE register bit positions */
#define AACI_RXTOFEIE    0x40
#define AACI_TXUIE       0x20
#define AACI_ORIE        0x10
#define AACI_RIE         0x08
#define AACI_TIE         0x04
#define AACI_RTIE        0x02
#define AACI_TCIE        0x01
  
/* AACISLFR register bit positions */
#define AACI_RWIS        0x2000
#define AACI_GPIOINTRX   0x1000
#define AACI_SL12TXEMPTY 0x0800
#define AACI_SL12RXVALID 0x0400
#define AACI_SL2TXEMPTY  0x0200
#define AACI_SL2RXVALID  0x0100
#define AACI_SL1TXEMPTY  0x0080
#define AACI_SL1RXVALID  0x0040
#define AACI_SL12TXBUSY  0x0020
#define AACI_SL12RXBUSY  0x0010
#define AACI_SL2TXBUSY   0x0008
#define AACI_SL2RXBUSY   0x0004
#define AACI_SL1TXBUSY   0x0002
#define AACI_SL1RXBUSY   0x0001

/* AACISLIEN register bit positions */
#define AACI_WISE           0x100
#define AACI_WIE            0x080
#define AACI_GPIOIE         0x040
#define AACI_SL12TXINTE     0x020
#define AACI_SL12RXINTE     0x010
#define AACI_SL2TXINTE      0x008
#define AACI_SL2RXINTE      0x004
#define AACI_SL1TXINTE      0x002
#define AACI_SL1RXINTE      0x001
  
/* AACIINTCLR register bit positions */
#define AACI_RXTOFEC4       0x1000
#define AACI_RXTOFEC3       0x0800
#define AACI_RXTOFEC2       0x0400
#define AACI_RXTOFEC1       0x0200

#define AACI_TXUEC4         0x0100
#define AACI_TXUEC3         0x0080
#define AACI_TXUEC2         0x0040
#define AACI_TXUEC1         0x0020

#define AACI_RXOEC4         0x0010
#define AACI_RXOEC3         0x0008
#define AACI_RXOEC2         0x0004
#define AACI_RXOEC1         0x0002

#define AACI_WISC           0x0001

/* AACIMAINCR register bit positions */
#define AACI_DMAEN        0x200
#define AACI_S12TXE       0x100
#define AACI_S12RXE       0x080
#define AACI_S2TXE        0x040
#define AACI_S2RXE        0x020
#define AACI_S1TXE        0x010
#define AACI_S1RXE        0x008
#define AACI_LPM          0x004
#define AACI_LOOP         0x002
#define AACI_AACIIFE      0x001

/* AACIRESET register bit positions */
#define AACI_FORCEDRESET0 0x0
#define AACI_FORCEDRESET1 0x1

/* AACISYNC register bit positions */
#define AACI_FORCEDSYNC0  0x0
#define AACI_FORCEDSYNC1  0x1

/* AACIMAINFR register bit positions */
#define AACI_MAINTXBUSY   0x002 
#define AACI_MAINRXBUSY   0x001

/* AACIALLINTS register bit positions */
#define AACI_RXTOFEIS4     0x08000000
#define AACI_TXUIS4        0x04000000
#define AACI_ORIS4         0x02000000
#define AACI_RIS4          0x01000000
#define AACI_TIS4          0x00800000
#define AACI_RTIS4         0x00400000
#define AACI_TCIS4         0x00200000

#define AACI_RXTOFEIS3     0x00100000
#define AACI_TXUIS3        0x00080000
#define AACI_ORIS3         0x00040000
#define AACI_RIS3          0x00020000
#define AACI_TIS3          0x00010000
#define AACI_RTIS3         0x00008000
#define AACI_TCIS3         0x00004000

#define AACI_RXTOFEIS2     0x00002000
#define AACI_TXUIS2        0x00001000
#define AACI_ORIS2         0x00000800
#define AACI_RIS2          0x00000400
#define AACI_TIS2          0x00000200
#define AACI_RTIS2         0x00000100
#define AACI_TCIS2         0x00000080

#define AACI_RXTOFEIS1     0x00000040
#define AACI_TXUIS1        0x00000020
#define AACI_ORIS1         0x00000010
#define AACI_RIS1          0x00000008
#define AACI_TIS1          0x00000004
#define AACI_RTIS1         0x00000002
#define AACI_TCIS1         0x00000001

/* SLOTINTSTATUS register bit positions */
#define AACI_WIS           0x00000080
#define AACI_GPIOIS        0x00000040
#define AACI_SL12TXINT     0x00000020
#define AACI_SL12RXINT     0x00000010
#define AACI_SL2TXINT      0x00000008
#define AACI_SL2RXINT      0x00000004
#define AACI_SL1TXINT      0x00000002
#define AACI_SL1RXINT      0x00000001

/* AACI Test control register */
#define  ITEN              0x00000001
#define  NORMALMODE        0x00000000
#define  TESTMODE01        0x00000002
#define  TESTMODE10        0x00000004
#define  TESTMODE11        0x00000006
#define  REGTESTMODE       0x00000008

/* AACIITIP register bit positions */
#define  AACI_ITISDATAIN   0x00000004
#define  AACI_ITIDMCLRTX   0x00000002
#define  AACI_ITIDMCLRRX   0x00000001

/* AACIITOP0 register bit positions */
#define  AACI_ITOSDATAOUT  0x20000000
#define  AACI_ITODMBRQTX   0x10000000
#define  AACI_ITODMSRQRX   0x08000000
#define  AACI_ITODMBRQRX   0x04000000
#define  AACI_ITODMLSRQ    0x02000000
#define  AACI_ITODMLBRQ    0x01000000
#define  AACI_ITORXINTR1   0x00800000
#define  AACI_ITORXINTR2   0x00400000
#define  AACI_ITORXINTR3   0x00200000
#define  AACI_ITORXINTR4   0x00100000
#define  AACI_ITOTXINTR1   0x00080000
#define  AACI_ITOTXINTR2   0x00040000
#define  AACI_ITOTXINTR3   0x00020000
#define  AACI_ITOTXINTR4   0x00010000
#define  AACI_ITOORINTR1   0x00008000
#define  AACI_ITOORINTR2   0x00004000
#define  AACI_ITOORINTR3   0x00002000
#define  AACI_ITOORINTR4   0x00001000
#define  AACI_ITOURINTR1   0x00000800
#define  AACI_ITOURINTR2   0x00000400
#define  AACI_ITOURINTR3   0x00000200
#define  AACI_ITOURINTR4   0x00000100
#define  AACI_ITOTOINTR1   0x00000080
#define  AACI_ITOTOINTR2   0x00000040
#define  AACI_ITOTOINTR3   0x00000020
#define  AACI_ITOTOINTR4   0x00000010
#define  AACI_ITOTCINTR1   0x00000008
#define  AACI_ITOTCINTR2   0x00000004
#define  AACI_ITOTCINTR3   0x00000002
#define  AACI_ITOTCINTR4   0x00000001

/* AACIITOP1 register bit positions */
#define  AACI_ITOTOFEINT1  0x00001000
#define  AACI_ITOTOFEINT2  0x00000800
#define  AACI_ITOTOFEINT3  0x00000400
#define  AACI_ITOTOFEINT4  0x00000200
#define  AACI_ITOWINTR     0x00000100
#define  AACI_ITOGPIOINTR  0x00000080
#define  AACI_ITOS12RXINT  0x00000040
#define  AACI_ITOS12TXINT  0x00000020
#define  AACI_ITOS2RXINT   0x00000010
#define  AACI_ITOS2TXINT   0x00000008
#define  AACI_ITOS1RXINT   0x00000004
#define  AACI_ITOS1TXINT   0x00000002
#define  AACI_ITOINTR      0x00000001

/* Data values */
#define DATA_As 0xAAAAAAAA
#define DATA_5s 0x55555555
#define DATA_0s 0x00000000
#define DATA_Fs 0xFFFFFFFF

/*********************** End of Aaci.h ********************************/
 
