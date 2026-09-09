/* --=========================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 2000 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
--
-- -----------------------------------------------------------------------------
-- Version and Release Control Information:
--
-- File Name              : Mmci.h.rca
-- File Revision          : 1.2
--
-- Release Information    : PrimeCell(TM)-PL181-REL1v0
--
-- -----------------------------------------------------------------------------
-- Purpose : This file contains the register offsets and other
--           definitions for the Mmci.c free running test code.
--
-- --=========================================================================*/

/******************************************************************************/
/*** Register       Offset Size Type Function                               ***/
/*** =============================================================          ***/
/*** MMCI Registers Common to both UUT and TRICKBOX                         ***/
/*** =============================================                          ***/
/*** MMCIPower       0x00   8    R/W  Power control register                ***/
/*** MMCIClock       0x04   12   R/W  Clock control register                ***/
/*** MMCICommand     0x0C   11   R/W  Command register                      ***/
/*** MMCIDataLength  0x28   16   R/W  Data length register                  ***/
/*** MMCIDataCtrl    0x2C   7    R/W  Data control register                 ***/
/***                                                                        ***/
/*** MMCI Registers in UUT(other than common)                               ***/
/*** =======================================                                ***/
/*** MMCIArgument    0x08   32   R/W  Argument register                     ***/
/*** MMCIRespCmd     0x10   6    R/   Response Command register             ***/
/*** MMCIResponse0   0x14   32   R/   Response register                     ***/
/*** MMCIResponse1   0x18   32   R/   Response register                     ***/
/*** MMCIResponse2   0x1C   32   R/   Response register                     ***/
/*** MMCIResponse3   0x20   32   R/   Response register                     ***/
/*** MMCIDataTimer   0x24   32   R/W  Data timer register                   ***/
/*** MMCIDataCnt     0x30   16   R/   Data control register                 ***/
/*** MMCIStatus      0x34   22   R/   Status register                       ***/
/*** MMCIClear       0x38   22   W/   Clear register                        ***/
/*** MMCIMask0       0x3C   22   R/W  Interrupt 0 mask register             ***/
/*** MMCIMask1       0x40   22   R/W  Interrupt 1 mask register             ***/
/*** MMCISelect      0x44   4    R/W  Card address input from MMCI          ***/
/***                                 controller                             ***/
/*** MMCIFifoCnt     0x48   14   R/   Fifo Counter
/*** MMCIFIFO        0x80 - 32   R/W  Data FIFO registers                   ***/
/***                0xBC                                                    ***/
/*** MMCIITIP        0x104       R/W  Test Registers for Integration        ***/
/*** MMCIITOP        0x108       R/W  Test Registers for Integration        ***/
/*** MMCIPeriphID0   0xFE0       R/   Peripheral ID reg,bits 7:0            ***/
/*** MMCIPeriphID1   0xFE4       R/   Peripheral ID reg,bits 15:8           ***/
/*** MMCIPeriphID2   0xFE8       R/   Peripheral ID reg,bits 23:16          ***/
/*** MMCIPeriphID3   0xFEC       R/   Peripheral ID reg,bits 31:24          ***/
/*** MMCIPCellID0    0xFF0       R/   Peripheral cell ID register,          ***/
/***                                 bits 7:0                               ***/
/*** MMCIPCellID1    0xFF4       R/   Peripheral cell ID register,          ***/
/***                                 bits 15:8                              ***/
/*** MMCIPCellID2    0xFF8       R/   Peripheral cell ID register,          ***/
/***                                 bits 23:16                             ***/
/*** MMCIPCellID3    0xFFC       R/   Peripheral cell ID register,          ***/
/***                                 bits 31:24                             ***/
/***                                                                        ***/
/*** MMCI Trickbox  Registers                                               ***/
/*** ========================                                               ***/
/*** MMCITBCmdResponse    0x00   6  R/W  Command Response register          ***/
/*** MMCITBResponse0      0x04   32 R/W  Response register                  ***/
/*** MMCITBResponse1      0x08   32 R/W  Response register                  ***/
/*** MMCITBResponse2      0x0C   32 R/W  Response register                  ***/
/*** MMCITBResponse3      0x10   31 R/W  Response register                  ***/
/*** MMCITBDataTimer      0x14   32 R/W  Data timer register                ***/
/*** MMCITBDataCnt        0x18   16 R/   Data Counter                       ***/
/*** MMCITBMClkPeriod     0x1C   32 R/W  MCLK frequency control             ***/
/***                                    register                            ***/
/*** MMCITBControl        0x20   13 R/W  Control bits for correct and       ***/
/***                                    incorrect CRC bits and              ***/
/***                                    tokens                              ***/
/*** MMCITBRespTimer      0x24   32 R/W  Delay register for command         ***/
/***                                    response                            ***/
/*** MMCITBSIGSTAT        0x28   6  R/   Register for storing DMA and       ***/
/***                                    interrupt requests                  ***/
/*** MMCITBRecdCmdInd     0x30   6  R/W  Register to store command          ***/
/***                                    index                               ***/
/*** MMCITBRecdCmdArg     0x34   32 R/W  Register to store command          ***/
/***                                    argument                            ***/
/*** MMCITBStatus         0x38   6  R/   Status of trickbox FIFO            ***/
/*** MMCITBTokenTimer     0x3C   32 R/W  Delay to be inserted before        ***/
/***                                    CRC token                           ***/
/*** MMCITBBusyTimer      0x40   32 R/W  Delay to be inserted after         ***/
/***                                    CRC token and before BUSY           ***/
/***                                    status                              ***/
/*** MMCITBPCDisable      0x44   16 R/W  Reg to determine which             ***/
/***                                    protocol check to be active         ***/
/*** MMCITBStTimeout      0x48   32 R/W  Reg to determine max delay         ***/
/***                                    before MMCI gives start bit         ***/
/*** MMCITBCLKRSTCntl     0x4C   3  R/W  Reg to detgger a nMCLKRESET        ***/
/***                                    from the trickbox to the MMCI       ***/
/***                                    and to control the MCLK             ***/
/***                                    muxing                              ***/
/***                                    before MMCI gives start bit         ***/
/******************************************************************************/

/******************************************************************************/
/*** For more information on the MMCI , please refer to PL181 AMBA MMCI     ***/
/*** Block Specification                                                    ***/
/******************************************************************************/

/******************************************************************************/
/******************** MMCI NORMAL-MODE REGISTERS  *****************************/
/******************************************************************************/

#define MMCIBASE_ADD     (0x84000000)
#define MMCIPower        (MMCIBASE_ADD + 0x00)
#define MMCIClock        (MMCIBASE_ADD + 0x04)
#define MMCIArgument     (MMCIBASE_ADD + 0x08)
#define MMCICommand      (MMCIBASE_ADD + 0x0C)
#define MMCIRespCmd      (MMCIBASE_ADD + 0x10)
#define MMCIResponse0    (MMCIBASE_ADD + 0x14)
#define MMCIResponse1    (MMCIBASE_ADD + 0x18)
#define MMCIResponse2    (MMCIBASE_ADD + 0x1C)
#define MMCIResponse3    (MMCIBASE_ADD + 0x20)
#define MMCIDataTimer    (MMCIBASE_ADD + 0x24)
#define MMCIDataLength   (MMCIBASE_ADD + 0x28)
#define MMCIDataCtrl     (MMCIBASE_ADD + 0x2C)
#define MMCIDataCnt      (MMCIBASE_ADD + 0x30)
#define MMCIStatus       (MMCIBASE_ADD + 0x34)
#define MMCIClear        (MMCIBASE_ADD + 0x38)
#define MMCIMask0        (MMCIBASE_ADD + 0x3C)
#define MMCIMask1        (MMCIBASE_ADD + 0x40)
#define MMCISelect       (MMCIBASE_ADD + 0x44)
#define MMCIFifoCnt      (MMCIBASE_ADD + 0x48)
#define MMCIFIFO         (MMCIBASE_ADD + 0x80)
#define MMCITCR          (MMCIBASE_ADD + 0x100)
#define MMCIITIP         (MMCIBASE_ADD + 0x104)
#define MMCIITOP         (MMCIBASE_ADD + 0x108)
#define MMCIPeriphID0    (MMCIBASE_ADD + 0xFE0)
#define MMCIPeriphID1    (MMCIBASE_ADD + 0xFE4)
#define MMCIPeriphID2    (MMCIBASE_ADD + 0xFE8)
#define MMCIPeriphID3    (MMCIBASE_ADD + 0xFEC)
#define MMCIPCellID0     (MMCIBASE_ADD + 0xFF0)
#define MMCIPCellID1     (MMCIBASE_ADD + 0xFF4)
#define MMCIPCellID2     (MMCIBASE_ADD + 0xFF8)
#define MMCIPCellID3     (MMCIBASE_ADD + 0xFFC)


/******************************************************************************/
/******************** TRICKBOX REGISTERS **************************************/
/******************************************************************************/

#define MMCITBBASE_ADD       (0x60000000)
#define MMCITBCmdResponse    (MMCITBBASE_ADD + 0x00)
#define MMCITBResponse0      (MMCITBBASE_ADD + 0x04)
#define MMCITBResponse1      (MMCITBBASE_ADD + 0x08)
#define MMCITBResponse2      (MMCITBBASE_ADD + 0x0C)
#define MMCITBResponse3      (MMCITBBASE_ADD + 0x10)
#define MMCITBDataTimer      (MMCITBBASE_ADD + 0x14)
#define MMCITBDataCnt  	     (MMCITBBASE_ADD + 0x18)
#define MMCITBMCLKPeriod     (MMCITBBASE_ADD + 0x1C)
#define MMCITBControl        (MMCITBBASE_ADD + 0x20)
#define MMCITBRespTimer      (MMCITBBASE_ADD + 0x24)
#define MMCITBSIGSTAT        (MMCITBBASE_ADD + 0x28)
#define MMCITBRecdCmdInd     (MMCITBBASE_ADD + 0x30)
#define MMCITBRecdCmdArg     (MMCITBBASE_ADD + 0x34)
#define MMCITBStatus         (MMCITBBASE_ADD + 0x38)
#define MMCITBTokenTimer     (MMCITBBASE_ADD + 0x3C)
#define MMCITBBusyTimer      (MMCITBBASE_ADD + 0x40)
#define MMCITBPCDisable      (MMCITBBASE_ADD + 0x44)
#define MMCITBStTimeout      (MMCITBBASE_ADD + 0x48)
#define MMCITBCLKRSTCntl     (MMCITBBASE_ADD + 0x4C)
#define MMCITBFIFOReg        (MMCITBBASE_ADD + 0x50)
#define MMCITBCrcErrStat     (MMCITBBASE_ADD + 0x54)

/* Data values */
#define DATA_As                0xAAAAAAAA
#define DATA_5s                0x55555555
#define DATA_0s                0x00000000
#define DATA_Fs                0xFFFFFFFF

/* Mask Values */
#define MASK_ITIPWRITEBIT      0x000000001
#define MASK_TCR               0x00000000F
#define MASK_ITIP              0x00000003F
#define MASK_PERIPHCELLID      0x0000000FF
#define MASK_ITOP              0x000000FFF

#define MASK_MMCIPower         0x000000FF
#define MASK_MMCIClock         0x00000FFF
#define MASK_MMCIArgument      0xFFFFFFFF
#define MASK_MMCICommand       0x000007FF
#define MASK_MMCIRespCmd       0x0000003F
#define MASK_MMCIResponse0     0xFFFFFFFF
#define MASK_MMCIResponse1     0xFFFFFFFF
#define MASK_MMCIResponse2     0xFFFFFFFF
#define MASK_MMCIResponse3     0xFFFFFFFF
#define MASK_MMCIDataTimer     0xFFFFFFFF
#define MASK_MMCIDataLength    0x0000FFFF
#define MASK_MMCIDataCtrl      0x000000FF
#define MASK_MMCIDataCnt       0x0000FFFF
#define MASK_MMCIStatus        0x003FFFFF
#define MASK_MMCIClear         0x000007FF
#define MASK_MMCIMask0         0x003FFFFF
#define MASK_MMCIMask1         0x003FFFFF
#define MASK_MMCISelect        0x0000000F
#define MASK_MMCIFifoCnt       0x00007FFF
#define MASK_MMCIFIFO          0xFFFFFFFF

#define POWEROFF               0x00000000
#define POWERUP                0x00000002
#define POWERON                0x00000003
#define VOLTAGE3               0x0000000C
#define VOLTAGE15              0x0000003C
#define OPENDRAINEN            0x00000040

#define CLKDIV0                0x00000000
#define CLKDIV1                0x00000001
#define CLKENB                 0x00000100
#define PWRSAVE                0x00000200
#define BYPASSENB              0x00000400
#define WIDEBUSENB             0x00000800

#define CMDINDEXFF             0x0000003F
#define CMDINDEX3A             0x0000003A
#define NORESP_LONGRSP_CLR     0x00000000
#define NORESP_LONGRSP_SET     0x00000080
#define SHORTRESP              0x00000040
#define LONGRESP               0x000000C0
#define INTERRUPTENB           0x00000100
#define PENDINGMODE            0x00000200
#define COMMANDENB             0x00000400

#define DATATXRENB             0x00000001
#define DATARXDIR              0x00000002
#define STREAMMODE             0x00000004
#define DMAENAB                0x00000008
#define BLOCKSIZE2             0x00000020
#define BLOCKSIZE3             0x00000030

#define CLEARALL               0x000007FF
#define CMDCRCFAILCLR          0x00000001
#define DATACRCFAILCLR         0x00000002
#define CMDTIMEOUTCLR          0x00000004
#define DATATIMEOUTCLR         0x00000008
#define TXUNDERRUNCLR          0x00000010
#define RXOVERRUNCLR           0x00000020
#define CMDRESPENDCLR          0x00000040
#define CMDSENTCLR             0x00000080
#define DATAENDCLR             0x00000100
#define STARTBITERRCLR         0x00000200
#define DATABLOCKENDCLR        0x00000400

#define CMDCRCFAIL             0x00000001
#define DATACRCFAIL            0x00000002
#define CMDTIMEOUT             0x00000004
#define DATATIMEOUT            0x00000008
#define TXUNDERRUN             0x00000010
#define RXOVERRUN              0x00000020
#define CMDRESPEND             0x00000040
#define CMDSENT                0x00000080
#define DATAEND                0x00000100
#define STARTBITERR            0x00000200
#define DATABLOCKEND           0x00000400
#define CMDACTIVE              0x00000800
#define TXACTIVE               0x00001000
#define RXACTIVE               0x00002000
#define TXFIFOHALFEMPTY        0x00004000
#define RXFIFOHALFEMPTY        0x00008000
#define TXFIFOFULL             0x00010000
#define RXFIFOFULL             0x00020000
#define TXFIFOEMPTY            0x00040000
#define RXFIFOEMPTY            0x00080000
#define TXDATAAVLBL            0x00100000
#define RXDATAAVLBL            0x00200000
#define STATICFLAGS            0x000007FF
#define MASK_STATUS            0x3FFFFF

#define TBTXFIFOEMPTY          0x00000001
#define TBTXFIFOFULL           0x00000002
#define TBTXHALFEMPTY          0x00000004
#define TBRXFIFOEMPTY          0x00000008
#define TBRXHALFFULL           0x00000020
#define TBMASKDMA              0x0000000F
#define TBMASKINTR             0x00000030
#define MASK_TBMMCIFIFO         0xFFFFFFFF
#define MASK_TBDATACRC         0x00000002
#define MASK_TBRECDCMDARG      0xFFFFFFFF
#define MASK_TBRECDCMDIND      0x0000003F

#define WRONGCMDCRC            0x00000001
#define WRONGDATACRC0          0x00000002
#define WRONGDATACRC1          0x00000004
#define WRONGDATACRC2          0x00000008
#define WRONGDATACRC3          0x00000010
#define WRONGCRCORTOKEN        0x00000020
#define STARTBITERR0           0x00000040
#define STARTBITERR1           0x00000080
#define STARTBITERR2           0x00000100
#define STARTBITERR3           0x00000200
#define DMACLROUT              0x00000400
#define TBRESET                0x00002000

#define MCLKRESETASSERT        0x00000001
#define PCLKSEL                0x00000002
#define MCLKSEL                0x00000004
#define GENCLK                 0x00000008


#define INDEX_MASK             0x0000003F
#define CLKDIV_MASK            0x0000003F

/******************************************************************************/
/* Modify this define to reflect the period of the PCLK set in the            */
/* testbench.                                                                 */
/******************************************************************************/
#define  PCLK_PERIOD    100
#define  MCLK_PERIOD    100

#define  SEED           30
#define  BYTE           0x000000FF
#define  HW             0x0000FFFF

/****************************** End of Mmci.h *********************************/
 
