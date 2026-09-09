//--==========================================================================--
//This confidential and proprietary software may be used only as
//authorised by a licensing agreement from ARM Limited
//  (C) COPYRIGHT 2000 ARM Limited
//      ALL RIGHTS RESERVED
//The entire notice above must be reproduced on all authorised
//copies and copies may only be made to the extent permitted
//by a licensing agreement from ARM Limited.
//
// -----------------------------------------------------------------------------
//Version and Release Control Information:
//
//File Name              : MmciTrParams.v.rca
//File Revision          : 1.2
//
//Release Information    : PrimeCell(TM)-PL181-REL1v0
//
// -----------------------------------------------------------------------------
//Purpose :
//          This file contains the address offset of all the
//          registers in trickbox defined as constants to enchance
//          readability.
//
//--==========================================================================--

//------------------------------------------------------------------------------
//            Register Offsets
//------------------------------------------------------------------------------
`define PA_MMCIPOWER       10'h000
//MMCIPower offset

`define PA_MMCICLOCK       10'h001
//MMCIClock offset

`define PA_MMCICMD         10'h003
//MMCICommand offset

`define PA_MMCIDATALEN     10'h00A
//MMCIDataLength offset

`define PA_MMCIDATACNTL    10'h00B
//MMCIDataCntl offset

`define PA_MMCICMDRESP     10'h000
//MMCITBCmdResponse offset

`define PA_MMCIRESP0       10'h001
//MMCITBResponse0 offset

`define PA_MMCIRESP1       10'h002
//MMCITBResponse1 offset

`define PA_MMCIRESP2       10'h003
//MMCITBResponse2 offset

`define PA_MMCIRESP3       10'h004
//MMCITBResponse3 offset

`define PA_MMCIDTIMER      10'h005
//MMCITBDataTimer offset

`define PA_MMCIDATACNT     10'h006
//MMCITBDataCnt offset

`define PA_MMCIMCLK        10'h007
//MMCITBMCLKPeriod offset

`define PA_MMCICONTROL     10'h008
//MMCITBCntl offset

`define PA_MMCIRETIMER     10'h009
//MMCITBRespTimer offset

`define PA_MMCISIGSTAT     10'h00A
//MMCITBSIGSTAT offset

`define PA_MMCITBCARDSEL   10'h00B
//MMCITBRecdCardSel offset

`define PA_MMCITBCMDIND    10'h00C
//MMCITBRecdCmdInd offset

`define PA_MMCITBCMDARG    10'h00D
//MMCITBRecdCmdArg offset

`define PA_MMCITBFIFOSTAT  10'h00E
//MMCITBFifoStat offset

`define PA_MMCITOKTIMER    10'h00F
//MMCITBTokenTimer offset

`define PA_MMCIBSYTIMER    10'h010
//MMCITBBusyTimer offset

`define PA_MMCIPCDISABLE   10'h011
//MMCITBPCDisable offset

`define PA_MMCISTTIMEOUT   10'h012
//MMCITBStTimeout offset

`define PA_MMCICLKRST      10'h013
//MMCITBCLKRSTCntl offset

`define PA_MMCITXFIFO      10'h014
//MMCITBFIFOReg offset

`define PA_MMCITBRXFIFO    10'h014
//MMCITBFIFOReg offset

`define PA_MMCITBCRCSTAT   10'h015
//MMCITBCrcErrStat offset

