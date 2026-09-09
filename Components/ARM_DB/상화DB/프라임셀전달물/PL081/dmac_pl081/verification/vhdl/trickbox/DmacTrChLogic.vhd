-- --=========================================================================--
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
-- File Name              : DmacTrChLogic.vhd.rca
-- File Revision          : 1.5
--
-- Release Information    : PrimeCell(TM)-PL081-REL1v0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           Dmac Channel logic block
--
-- --=========================================================================--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

use work.DmacTrPackage.all;

-- -----------------------------------------------------------------------------

entity DmacTrChLogic is
  port (
-- Inputs
        HCLK             : in    std_logic; -- AHB clock
        HRESETn          : in    std_logic; -- AHB reset
        ChComb1          : in    std_logic; -- Channel grant signal from Arb1
        ChComb2          : in    std_logic; -- Channel grant signal from Arb2
        ChSrcAddrWrEn    : in    std_logic; -- Source RegWrEn from Slave
        ChDstAddrWrEn    : in    std_logic; -- Dstn RegWrEn from Slave
        ChControlWrEn    : in    std_logic; -- Control RegWrEn from Slave
        ChLLIWrEn        : in    std_logic; -- LLI RegWrEn from Slave
        ChConfigWrEn     : in    std_logic; -- Config RegWrEn from Slave
        HWDATA           : in    std_logic_vector(31 downto 0);
                                            -- AHB Write Data bus from Slave
        HRDATAM1         : in    std_logic_vector(31 downto 0);
                                            -- AHB read Data Bus1
        HRDATAM2         : in    std_logic_vector(31 downto 0);
                                            -- AHB read Data Bus2
        DataValid1       : in    std_logic; -- DataValid from Master1
        DataValid2       : in    std_logic; -- DataValid from Master2
        MREADY1          : in    std_logic; -- MREADY routed from AHBLite1
        MREADY2          : in    std_logic; -- MREADY routed from AHBLite2
        ErrorMas1        : in    std_logic; -- Error indication from Master1
        ErrorMas2        : in    std_logic; -- Error indication from Master2
        DisAckMas1       : in    std_logic; -- Disable Ack from Master1
        DisAckMas2       : in    std_logic; -- Disable Ack from Master2
        MasterEndian1    : in    std_logic; -- Endianness for Master1
        MasterEndian2    : in    std_logic; -- Endianness for Master2
        DMACBREQ         : in    std_logic_vector(15 downto 0);
                                            -- DMAC Burst request
        DMACSREQ         : in    std_logic_vector(15 downto 0);
                                            -- DMAC Single request
        DMACLBREQ        : in    std_logic_vector(15 downto 0);
                                            -- DMAC Last Burst request
        DMACLSREQ        : in    std_logic_vector(15 downto 0);
                                            -- DMAC Last Single request
        SOFTBREQ         : in    std_logic_vector(15 downto 0);
                                            -- DMAC Soft Burst request
        SOFTLBREQ        : in    std_logic_vector(15 downto 0);
                                            -- DMAC Soft Last Burst request
        SOFTSREQ         : in    std_logic_vector(15 downto 0);
                                            -- DMAC Soft Single request
        SOFTLSREQ        : in    std_logic_vector(15 downto 0);
                                            -- DMAC Soft Last Single request
        DMACEn           : in    std_logic; -- DMAC Controller Enable
        DmacTrEn         : in    std_logic; -- DMAC Trickbox Enable
        ClrIntTC         : in    std_logic; -- TC Interrupt clear for channel
        ClrIntErr        : in    std_logic; -- Error Interrupt clear for channel
-- Outputs
        ChReqArb1        : out   std_logic; -- Channel Req to Arb1
        ChReqArb2        : out   std_logic; -- Channel Req to Arb2
        ChDisableBus1    : out   std_logic; -- Channel disable signal for Mas1
        ChDisableBus2    : out   std_logic; -- Channel disable signal for Mas2
        HWDATA1          : out   std_logic_vector(31 downto 0);
                                            -- AHB Write Data Bus1
        HWDATA2          : out   std_logic_vector(31 downto 0);
                                            -- AHB Write Data Bus2
        ChAddrBus1       : out   std_logic_vector(31 downto 0);
                                            -- Channel Address on Bus1
        ChAddrBus2       : out   std_logic_vector(31 downto 0);
                                            -- Channel Address on Bus2
        ChHLockBus1      : out   std_logic; -- HLOCK signal on Bus1
        ChHLockBus2      : out   std_logic; -- HLOCK signal on Bus2
        ChHProtBus1      : out   std_logic_vector(3 downto 0);
                                            -- HPROT signal on Bus1
        ChHProtBus2      : out   std_logic_vector(3 downto 0);
                                            -- HPROT signal on Bus2
        ChBeatCntBus1    : out   std_logic_vector(4 downto 0);
                                            -- BeatCount for Master1
        ChBeatCntBus2    : out   std_logic_vector(4 downto 0);
                                            -- BeatCount for Master2
        ChAddrIncr1      : out   std_logic; -- Channel Increment for Master1
        ChAddrIncr2      : out   std_logic; -- Channel Increment for Master2
        ChWRITEBus1      : out   std_logic; -- HWRITE information for Bus1
        ChWRITEBus2      : out   std_logic; -- HWRITE information for Bus2
        ChHSIZEBus1      : out   std_logic_vector(2 downto 0);
                                            -- HSIZE information for Bus1
        ChHSIZEBus2      : out   std_logic_vector(2 downto 0);
                                            -- HSIZE information for Bus2
        ChIntTC          : out   std_logic; -- Channel Interrupt for TC
        ChIntErr         : out   std_logic; -- Channel Interrupt for Error
        SOFTCLR          : out   std_logic_vector(15 downto 0);
                                            -- Soft Request Clear signal
        DMACTC           : out   std_logic_vector(15 downto 0);
                                            -- DMACTC signal
        DMACCLR          : out   std_logic_vector(15 downto 0)
                                            -- DMACCLR signal
       );
end DmacTrChLogic;

-- -----------------------------------------------------------------------------
--
--                                DmacTrChLogic
--                                =============
--
-- -----------------------------------------------------------------------------
--
-- Overview
-- ========
--
-- This module is responsible for carrying out all channel related activities
-- like, updating channel registers, generating interrupts, generating DMACCLR
-- and DMACTC, loading the Burst and TC counters, moving the data from FIFO to
-- peripheral and vice - versa. This module consists of a Channel SM whose
-- state bit is used to control most of the activities.
--
-- -----------------------------------------------------------------------------

-- --=========================== ARCHITECTURE ================================--

architecture behavioural of DmacTrChLogic is

-- -----------------------------------------------------------------------------
-- Component declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Constant declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Type declarations
-- -----------------------------------------------------------------------------
subtype FifoWidth is std_logic_vector(7 downto 0);
-- Fifo Width of 8 bit

type FIFO is array (0 to 15) of FifoWidth;
-- Fifo is of 16 deep

-- -----------------------------------------------------------------------------
-- Signal declarations
-- -----------------------------------------------------------------------------
signal ChSrcAddrReg     : std_logic_vector(31 downto 0);
-- Source Address register

signal NextChSrcAddrReg : std_logic_vector(31 downto 0);
-- D-Input of Source Address register

signal ChDstAddrReg     : std_logic_vector(31 downto 0);
-- Destination Address register

signal NextChDstAddrReg : std_logic_vector(31 downto 0);
-- D-Input of Destination Address register

signal ChControlReg     : std_logic_vector(31 downto 0);
-- Channel Control register

signal NextChControlReg : std_logic_vector(31 downto 0);
-- D-Input of Channel Control register

signal ChLLIReg         : std_logic_vector(31 downto 0);
-- LLI register

signal NextChLLIReg     : std_logic_vector(31 downto 0);
-- D-Input of LLI register

signal ChConfigReg      : std_logic_vector(31 downto 0);
-- Channel Config register

signal NextChConfigReg  : std_logic_vector(31 downto 0);
-- D-Input of Channel Config register

signal DstSelComb       : std_logic;
-- Destination select signal

signal SrcSelComb       : std_logic;
-- Source select signal

signal LLISelComb       : std_logic;
-- LLI select signal

signal LLISelReg        : std_logic;
-- Register to indicate that LLI is selected

signal NextLLISelReg    : std_logic;
-- D-Input of LLISelReg

signal SrcReqCh         : std_logic;
-- Source request signal

signal SrcTxrOn         : std_logic;
-- Indication of source transfer when peripheral are on different bus

signal NextSrcTxrOn     : std_logic;
-- D-Input of SrcTxrOn reg

signal DstTxrOn         : std_logic;
-- Indication of destination transfer when peripheral are on different bus

signal NextDstTxrOn     : std_logic;
-- D-Input of SrcTxrOn reg

signal DstReqCh         : std_logic;
-- Destination request signal

signal ChannelState     : std_logic_vector(4 downto 0);
-- Channel State register

signal NextChState      : std_logic_vector(4 downto 0);
-- D-Input of Channel State register

signal SourceTC         : std_logic_vector(13 downto 0);
-- SourceTC counter

signal NextSourceTC     : std_logic_vector(13 downto 0);
-- D-Input of SourceTC register

signal SrcTCDstFlow     : std_logic_vector(13 downto 0);
-- SourceTC counter

signal NxtSrcTCDstFlow  : std_logic_vector(13 downto 0);
-- D-Input of SrcTCDstFlow counter

signal DstTC            : std_logic_vector(13 downto 0);
-- Destination TC counter

signal NextDstTC        : std_logic_vector(13 downto 0);
-- D-Input of DstTC register

signal DstTCSrcFlow     : std_logic_vector(13 downto 0);
-- Destination TC counter

signal NxtDstTCSrcFlow  : std_logic_vector(13 downto 0);
-- Destination TC counter

signal SrcBurst         : std_logic_vector(13 downto 0);
-- SrcBurst counter

signal NextSrcBurst     : std_logic_vector(13 downto 0);
-- D-Input of SrcBurst register

signal DstBurst         : std_logic_vector(13 downto 0);
-- DstBurst counter

signal NextDstBurst     : std_logic_vector(13 downto 0);
-- D-Input of DstBurst register

signal SrcReg           : std_logic_vector(3 downto 0);
-- Encoded value for source peripheral

signal DstReg           : std_logic_vector(3 downto 0);
-- Encoded value for destination peripheral

signal SrcBusWidth      : std_logic_vector(2 downto 0);
-- Increment value based on source peripheral bus width

signal SrcWidth         : std_logic_vector(2 downto 0);
-- Encoded value for source bus width

signal DstBusWidth      : std_logic_vector(2 downto 0);
-- Increment value based on destination peripheral bus width

signal DstWidth         : std_logic_vector(2 downto 0);
-- Encoded value for destination bus width

signal SrcBurstSize     : std_logic_vector(2 downto 0);
-- Encoded value for source burst size

signal DstBurstSize     : std_logic_vector(2 downto 0);
-- Encoded value for destination burst size

signal FlowCntl         : std_logic_vector(2 downto 0);
-- Encoded value for Flow Controller

signal FactorOnDstNum   : std_logic_vector(2 downto 0);
-- Factor calculation based on Destination width

signal FactorOnDstDen   : std_logic_vector(2 downto 0);
-- Factor calculation based on Destination width

signal FactorOnSrcNum   : std_logic_vector(2 downto 0);
-- Factor calculation based on Source width

signal FactorOnSrcDen   : std_logic_vector(2 downto 0);
-- Factor calculation based on Source width

signal TwoBitCnt        : std_logic_vector(1 downto 0);
-- Two bit counter to help LLI Load

signal NextTwoBitCnt    : std_logic_vector(1 downto 0);
-- D-Input of TwoBitCnt reg

signal SameBus          : std_logic;
-- Indication that peripheral on same bus

signal DiffBus          : std_logic;
-- Indication that peripheral on different bus

signal SrcAhbMasSel     : std_logic;
-- Source AHB select

signal SrcReqBefMask    : std_logic;
-- Source request before mask

signal DstReqBefMask    : std_logic;
-- Destination request before mask

signal DstFlowReq       : std_logic;
-- Destination request before Delaying

signal DelDstFlowReq    : std_logic;
-- Destination request after Delaying during destination flow control

signal DelChEnable      : std_logic;
-- Delayed Channel Enable

signal DelDstRqBefMask  : std_logic;
-- Destination request before mask

signal NextDelDstRq     : std_logic;
-- D-Input of DelDstRqBefMask

signal LLIReq           : std_logic;
-- LLI request

signal DstAhbMasSel     : std_logic;
-- Destination AHB select

signal LLIAhbMasSel     : std_logic;
-- LLI AHB select

signal NextLLIAhbMasSel : std_logic;
-- D-Input of LLIAhbMasSel

signal LLILoad          : std_logic_vector(29 downto 0);
-- Indication of LLI Load

signal SrcIncrBit       : std_logic;
-- Source increment signal

signal SrcMask          : std_logic;
-- Mask for source request

signal SrcLstOccrd      : std_logic;
-- Indication of source last occurred when source is flow controller

signal SrcLstOccrdReg   : std_logic;
-- Registered signal of SrcLstOccrd

signal NextSrcLstOccrd  : std_logic;
-- D-Input of SrcLstOccrdReg register

signal DstMask          : std_logic;
-- Mask for destination request

signal DstLstOccrd      : std_logic;
-- Indication of Destination last occurred when destination is flow controller

signal DstLstOccrdReg   : std_logic;
-- Registered signal of DstLstOccrd

signal NextDstLstOccrd  : std_logic;
-- D-Input of DstLstOccrdReg register

signal DstIncrBit       : std_logic;
-- Destination increment signal

signal ChEnable         : std_logic;
-- Channel enable signal

signal ChSrcMas1WrEn    : std_logic;
-- Src write enable during LLI load from Master1

signal ChSrcMas2WrEn    : std_logic;
-- Src write enable during LLI load from Master2

signal ChDstMas1WrEn    : std_logic;
-- Destination write enable during LLI load from Master1

signal ChDstMas2WrEn    : std_logic;
-- Destination write enable during LLI load from Master2

signal ChCtrlMas1WrEn   : std_logic;
-- Control write enable during LLI load from Master1

signal ChCtrlMas2WrEn   : std_logic;
-- Control write enable during LLI load from Master2

signal ChLLIMas1WrEn    : std_logic;
-- LLI reg write enable during LLI load from Master1

signal ChLLIMas2WrEn    : std_logic;
-- LLI reg write enable during LLI load from Master2

signal DMAFIFOLevel     : std_logic_vector(4 downto 0);
-- DMAFifoLevel in bytes. This Fifo Level is in Sync with UUT during Source Txrs

signal ActFifoLevel     : std_logic_vector(4 downto 0);
-- DMAFifoLevel in bytes. This Fifo Level is based on DataValid's Received.

signal ActFifoLevDel    : std_logic_vector(4 downto 0);
-- DMAFifoLevel in bytes. This is 1HCLK delayed version of ActFifoLevel

signal SrcMaskReg       : std_logic;
-- Register to hold that Source is selected when SM is in active state

signal NextSrcMaskReg   : std_logic;
-- D-Input of SrcMaskReg

signal SrcLoadComb      : std_logic;
-- Indication to load the counters combinationally for source

signal DstLoadComb      : std_logic;
-- Indication to load the counters combinationally for destination

signal SrcBurstCh       : std_logic_vector(13 downto 0);
-- vector to decide the loading of source counters

signal SrcBurstChNxt    : std_logic_vector(13 downto 0);
-- vector to decide the loading of source counters

signal SrcBstDstFlow    : std_logic_vector(13 downto 0);
-- Source burst counter when destination is flow controller

signal NxtSrcBstDstFlow : std_logic_vector(13 downto 0);
-- D-Input of SrcBstDstFlow counter

signal DstLstSrc        : std_logic;
-- Indication as to Destination last has occurred

signal DstLstSrcReg     : std_logic;
-- Register signal of DstLstSrc

signal NextDstLstSrc    : std_logic;
-- D-input of DstLstSrcReg register

signal SrcBeat          : std_logic_vector(4 downto 0);
-- Source beat counter for channel

signal NextSrcBeat      : std_logic_vector(4 downto 0);
-- D-Input of SrcBeat counter

signal DstBurstCh       : std_logic_vector(13 downto 0);
-- vector to decide the loading of Destination counters

signal DstBurstChNxt    : std_logic_vector(13 downto 0);
-- vector to decide the loading of Destination counters

signal DstBstSrcFlow    : std_logic_vector(13 downto 0);
-- Destination burst counter when source is flow controller

signal NxtDstBstSrcFlow : std_logic_vector(13 downto 0);
-- D-Input of DstBstSrcFlow counter

signal DstBeat          : std_logic_vector(4 downto 0);
-- Destination beat counter for channel

signal NextDstBeat      : std_logic_vector(4 downto 0);
-- D-Input of DstBeat Reg

signal DstBeatCopy      : std_logic_vector(4 downto 0);
-- Destination beat counter copy for Synchronizing with UUT.

signal NextDstBeatCopy  : std_logic_vector(4 downto 0);
-- D-Input of DstBeatCopy

signal LLIBeat          : std_logic_vector(2 downto 0);
-- LLI beat counter for channel

signal NextLLIBeat      : std_logic_vector(2 downto 0);
-- D-Input of LLIBeat Reg

signal SrcSelReg        : std_logic;
-- Information as to source is selected when SM is in active state

signal NextSrcSelReg    : std_logic;
-- D-Input of SrcSelReg

signal DstSelReg        : std_logic;
-- Information as to destination is selected when SM is in active state

signal NextDstSelReg    : std_logic;
-- D-Input of DstSelReg

signal iDMACTC          : std_logic_vector(15 downto 0);
-- Internal copy of DMACTC

signal NextDMACTC       : std_logic_vector(15 downto 0);
-- D-Input of iDMACTC register

signal iDMACCLR         : std_logic_vector(15 downto 0);
-- Internal copy of DMACCLR

signal NextDMACCLR      : std_logic_vector(15 downto 0);
-- D-Input of iDMACCLR register

signal SoftClrPulse     : std_logic;
-- D-Input of SoftClrPulse register

signal NextSoftClrPulse : std_logic;
-- D-Input of SoftClrPulse register

signal DMACTCDel        : std_logic_vector(15 downto 0);
-- Delayed DMACTC

signal DMACCLRDel       : std_logic_vector(15 downto 0);
-- Delayed DMACCLR by 1HCLK

signal DMACCLR2Del      : std_logic_vector(15 downto 0);
-- Delayed DMACCLR by 2HCLK

signal BstRqSrc         : std_logic;
-- Burst request for Source Peripheral

signal SglRqSrc         : std_logic;
-- Single request for Source Peripheral

signal BstRqDst         : std_logic;
-- Burst request for Destination Peripheral

signal SglRqDst         : std_logic;
-- Single request for Destination Peripheral

signal BstRqSrcAll      : std_logic;
-- Burst request for Source Peripheral including Last DMAC request

signal SglRqSrcAll      : std_logic;
-- Single request for Source Peripheral including Last DMAC request

signal BstRqDstAll      : std_logic;
-- Burst request for Destination Peripheral including Last DMAC request

signal SglRqDstAll      : std_logic;
-- Single request for Destination Peripheral including Last DMAC request

signal ReqConcat        : std_logic_vector(2 downto 0);
-- Concatenation of all request

signal ZERO_1           : std_logic := '0';
-- 1 bit LOW signal

signal ONE_1            : std_logic := '1';
-- 1 bit HIGH signal

signal WrPtr            : std_logic_vector(3 downto 0);
-- Fifo write pointer

signal NextWrPtr        : std_logic_vector(3 downto 0);
-- D-Input of write pointer

signal AddrOffSetSrc    : std_logic_vector(1 downto 0);
-- Address offset for endianization

signal Wrap             : std_logic;
-- Wrap indication for FIFO

signal NextWrap         : std_logic;
-- D-Input of Wrap Register

signal SrcErrMask       : std_logic;
-- Mask for source error

signal SrcErrOccrd      : std_logic;
-- Registered version of SrcErrMask

signal NextSrcErrOccrd  : std_logic;
-- D-Input of SrcErrOccrd Reg

signal DstErrMask       : std_logic;
-- Mask for destination error

signal DstErrOccrd      : std_logic;
-- Registered version of DstErrMask

signal NextDstErrOccrd  : std_logic;
-- D-Input of DstErrOccrd Reg

signal ChHalt           : std_logic;
-- Channel halt indication

signal ChHaltReg        : std_logic;
-- Registered ChHalt signal

signal NextChHalt       : std_logic;
-- D-Input of ChHaltReg

signal DstDisAckOccrd   : std_logic;
-- Ack occurred for destination Transfer

signal SrcDisAckOccrd   : std_logic;
-- Ack occurred for source Transfer

signal LLIDisAckOccrd   : std_logic;
-- Ack occurred for LLI Transfer

signal ChIntReg         : std_logic;
-- Registered version of channel TC Interrupt

signal NextChIntReg     : std_logic;
-- D-input of ChIntReg

signal IntMask          : std_logic;
-- Mask for channel Interrupt

signal ErrMask          : std_logic;
-- Mask for Error Interrupt

signal iChIntErr        : std_logic;
-- internal copy of ChIntErr

signal NextChIntErr     : std_logic;
-- D-input of iChIntErr

signal ChIntErrDel1     : std_logic;
-- Delayed version of iChIntErr

signal ChDisable        : std_logic;
-- Channel disable indication

signal ChDisableReg     : std_logic;
-- Registered version of ChDisable

signal NextChDisable    : std_logic;
-- D-Input of ChDisableReg

signal DelChDisable     : std_logic;
-- Delayed Channel disable indication

signal SrcMskDstFlow    : std_logic;
-- Source mask when Destination is the Flow Controller

signal SrcStart         : std_logic;
-- Source start signal when Destination is the Flow Controller

signal NextSrcStart     : std_logic;
-- D-Input of SrcStart Reg

signal OnebitTog        : std_logic;
-- Counter to indicate the decrement factor for Control register

signal NextOneBitTog    : std_logic;
-- D-Input of OnebitTog

signal TwoBitTog        : std_logic_vector(1 downto 0);
-- Counter to indicate the decrement factor for Control register

signal NextTwoBitTog    : std_logic_vector(1 downto 0);
-- D-Input of TwoBitTog

signal SrcDisAckTemp    : std_logic;
-- Temp Signal for Disable

signal DstDisAckTemp    : std_logic;
-- Temp Signal for Disable

signal SrcState         : std_logic;
-- Signal to indicate SM is in Source Transfer State

signal DelSrcState      : std_logic;
-- 1HCLK Delayed SrcState

signal NextDelSrcState  : std_logic;
-- D-Input of DelSrcState

signal DstState         : std_logic;
-- Signal to indicate SM is in Destination Transfer State

signal DelDstState      : std_logic;
-- 1HCLK Delayed DstState

signal NextDelDstState  : std_logic;
-- D-Input of DelDstState

signal Del2DstState     : std_logic;
-- 1HCLK Delayed version of DelDstState

signal RdPtrAhead       : std_logic_vector(3 downto 0);
-- Fifo Read Pointer which is getting incremented Ahead of DataValid Reception.

signal NextRdPtrAhead   : std_logic_vector(3 downto 0);
-- D-Input of RdPtrAhead

signal HwdataBuff1      : std_logic_vector(31 downto 0);
-- Buffered HWDATA Data

signal NextHwdataBuff1  : std_logic_vector(31 downto 0);
-- D-Input of HwdataBuff1

signal HwdataBuff2      : std_logic_vector(31 downto 0);
-- Buffered HWDATA Data

signal NextHwdataBuff2  : std_logic_vector(31 downto 0);
-- D-Input of HwdataBuff2

signal AddrPhase        : std_logic;
-- Address phase for Destination Transactions on Dual Bus

signal ErrorState       : std_logic_vector(4 downto 0);
-- Error State SM

signal NextErrorState   : std_logic_vector(4 downto 0);
-- D-Input of ErrorState

signal SingleBusErr     : std_logic;
-- Error on Single Bus Indication

signal DualBusErr       : std_logic;
-- Error on Dual Bus Indication

signal ChHwdata1        : std_logic_vector(31 downto 0);
-- Data Brought out from FIFO after endianization which is put on Bus1

signal NextChHwdata1    : std_logic_vector(31 downto 0);
-- D-Input of ChHwdata1

signal iHWDATA1         : std_logic_vector(31 downto 0);
-- Internal copy of HWDATA1;

signal ChHwdata2        : std_logic_vector(31 downto 0);
-- Data Brought out from FIFO after endianization which is put on Bus2

signal NextChHwdata2    : std_logic_vector(31 downto 0);
-- D-Input of ChHwdata2

signal iHWDATA2         : std_logic_vector(31 downto 0);
-- Internal copy of HWDATA2;

signal DstHwdataState   : std_logic_vector(2 downto 0);
-- State Machine to drive out HWDATA and for Read Pointer Increment

signal NextDstState     : std_logic_vector(2 downto 0);
-- D-Input of DstHwdataState

signal DelMready1       : std_logic;
-- Delayed Mready1

signal DelMready2       : std_logic;
-- Delayed Mready2

signal DelLLIState      : std_logic;
-- Delayed LLILOAD State

signal NextDelLLIState  : std_logic;
-- D-input of DelLLIState

signal Del2LLIState     : std_logic;
-- Delayed LLILOAD State by 2 HCLK for synchronizing with UUT during DP Flow

signal LLIErrOccrd      : std_logic;
-- Error occurred during LLILoad

signal NextLLIErrOccrd  : std_logic;
-- D-input of LLIErrOccrd

signal LLIErrMask       : std_logic;
-- Or of LLIErrOccrd and NextLLIErrOccrd

signal StopSrc          : std_logic;
-- Stop Source Txr when Data is there in FIFO in case of Destination Flow Cntl

signal SrcBeatCopy      : std_logic_vector (4 downto 0);
-- Copy of SrcBeat Counter

signal NextSrcBeatCopy  : std_logic_vector (4 downto 0);
-- D-input of SrcBeatCopy

signal SrcCopy1         : std_logic_vector (4 downto 0);
-- Delayed version of SrcBeatCopy

signal NextSrcCopy1     : std_logic_vector (4 downto 0);
-- D-input of SrcCopy1

signal SrcCopy2         : std_logic_vector (4 downto 0);
-- Delayed version of SrcCopy1

signal NextSrcCopy2     : std_logic_vector (4 downto 0);
-- D-input of SrcCopy2

signal SrcCopyState     : std_logic_vector (2 downto 0);
-- Source Copy State SM

signal NextSrcCopyST    : std_logic_vector (2 downto 0);
-- D-input of SrcCopyState

signal PredictFactor    : std_logic_vector (1 downto 0);
-- Prediction factor for Destination Transfers

signal NotValidSrcST    : std_logic_vector (2 downto 0);
-- NotValid State for Source Transfers

signal NextSrcNotState  : std_logic_vector (2 downto 0);
-- D-input of NotValidSrcST

signal NotValidDstST    : std_logic_vector (2 downto 0);
-- NotValid State for Destination Transfers

signal NextDstNotState  : std_logic_vector (2 downto 0);
-- D-input of NotValidDstST

signal NotValidLLIST    : std_logic_vector (2 downto 0);
-- NotValid State for LLI Transfers

signal NextLLINotState  : std_logic_vector (2 downto 0);
-- D-input of NotValidLLIST

signal NotValidDataSrc  : std_logic;
-- Not Valid signal for Source Transfers

signal DelNotValidSrc   : std_logic;
-- Delayed Not Valid signal for Source Transfers

signal NotValidDataDst  : std_logic;
-- Not Valid signal for Destination Transfers

signal DelNotValidDst   : std_logic;
-- Delayed Not Valid signal for Destination Transfers

signal NotValidDataLLI  : std_logic;
-- Not Valid signal for LLI Transfers

signal DelNotValidLLI   : std_logic;
-- Delayed Not Valid signal for LLI Transfers

signal DMACTCP2M        : std_logic;
-- DmacTC indication for P2M Transfers

signal NextDMACTCP2M    : std_logic;
-- D-input of DMACTCP2M

signal DelDMACTCP2M     : std_logic;
-- Delayed DMACTCP2M

signal WaitedForClr     : std_logic;
-- Signal used to synchronize the Interrupts with UUT.
-- This signal indicates that Clear is generated.

signal NextWaitedForClr : std_logic;
-- D-input of WaitedForClr

signal DelErrMas1       : std_logic;
-- Delayed Error from Master1

signal DelErrMas2       : std_logic;
-- Delayed Error from Master2

signal ErrPulse1        : std_logic;
-- Error Pulse from Bus1

signal ErrPulse2        : std_logic;
-- Error Pulse from Bus2

signal DelIntr          : std_logic;
-- Indication to Delay the Interrupts. This signal generated to Sync with UUT

signal NextDelIntr      : std_logic;
-- D-input of DelIntr

signal ValidDataSrc     : std_logic;
-- Valid Data for Source Transfer

signal ValidDataDst     : std_logic;
-- Valid Data for Destination Transfer

signal ValidDataLLI     : std_logic;
-- Valid Data for LLI Transfer

signal DisableST        : std_logic_vector (3 downto 0);
-- Disable SM's Flip Flops

signal NextDisableST    : std_logic_vector (3 downto 0);
-- D-input of DisableST

signal SrcDisable       : std_logic;
-- Source Disable indication

signal NextSrcDisable   : std_logic;
-- D-input of SrcDisable

signal DstDisable       : std_logic;
-- Destination Disable indication

signal NextDstDisable   : std_logic;
-- D-input of DstDisable

signal LLIDisable       : std_logic;
-- Destination Disable indication

signal NextLLIDisable   : std_logic;
-- D-input of DstDisable

signal Pulse1           : std_logic;
-- Disable Ack indication

signal Pulse2           : std_logic;
-- Disable Ack indication

signal Pulse3           : std_logic;
-- Disable Ack indication

signal Pulse4           : std_logic;
-- Disable Ack indication

signal Pulse5           : std_logic;
-- Disable Ack indication

signal FifoReg          : FIFO;
-- Two dimensional array

signal NextFifoReg      : FIFO;
-- D-Input of FifoReg

-- -----------------------------------------------------------------------------
-- Function declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Function to select the appropriate Channel Select Combinational signal from
-- Internal Arbiter.
-- -----------------------------------------------------------------------------
function SelComb (
         signal AhbMasSel        : in std_logic;
         signal ChComb1          : in std_logic;
         signal ChComb2          : in std_logic
                 ) return std_logic is
variable Result           : std_logic;
-- return from function
begin
  if (AhbMasSel = '1') then
    Result := ChComb2;
  else
    Result := ChComb1;
  end if;
  return (Result);
end SelComb;

-- -----------------------------------------------------------------------------
-- Function to select the appropriate MREADY
-- -----------------------------------------------------------------------------
function MREADY (
         signal AhbMasSel        : in std_logic;
         signal MREADY1          : in std_logic;
         signal MREADY2          : in std_logic
                      ) return std_logic is
variable Result           : std_logic;
-- return from function
begin
  if (AhbMasSel = '1') then
    Result := MREADY2;
  else
    Result := MREADY1;
  end if;
  return (Result);
end MREADY;

-- -----------------------------------------------------------------------------
-- Function to select the appropriate Endianness
-- -----------------------------------------------------------------------------
function MasterEndian (
         signal AhbMasSel        : in std_logic;
         signal MasterEndian1    : in std_logic;
         signal MasterEndian2    : in std_logic
                      ) return std_logic is
variable Result           : std_logic;
-- return from function
begin
  if (AhbMasSel = '1') then
    Result := MasterEndian2;
  else
    Result := MasterEndian1;
  end if;
  return (Result);
end MasterEndian;

-- -----------------------------------------------------------------------------
-- Function to select the appropriate DataValid's from Master Interface
-- -----------------------------------------------------------------------------
function DataValid (
         signal AhbMasSel        : in std_logic;
         signal DataValid1       : in std_logic;
         signal DataValid2       : in std_logic
                   ) return std_logic is
variable Result           : std_logic;
-- return from function
begin
  if (AhbMasSel = '1') then
    Result := DataValid2;
  else
    Result := DataValid1;
  end if;
  return (Result);
end DataValid;

-- -----------------------------------------------------------------------------
-- Function to select the appropriate Disable Acknowledge from Master Interface
-- -----------------------------------------------------------------------------
function DisableAck (
         signal AhbMasSel        : in std_logic;
         signal DisAckMas1       : in std_logic;
         signal DisAckMas2       : in std_logic
                    ) return std_logic is
variable Result           : std_logic;
-- return from function
begin
  if (AhbMasSel = '1') then
    Result := DisAckMas2;
  else
    Result := DisAckMas1;
  end if;
  return (Result);
end DisableAck;

-- -----------------------------------------------------------------------------
-- Function to select the appropriate Error from Master Interface
-- -----------------------------------------------------------------------------
function ErrorMas (
         signal AhbMasSel        : in std_logic;
         signal ErrorMas1        : in std_logic;
         signal ErrorMas2        : in std_logic
                  ) return std_logic is
variable Result : std_logic;
-- return from function
begin
  if (AhbMasSel = '1') then
    Result := ErrorMas2;
  else
    Result := ErrorMas1;
  end if;
  return (Result);
end ErrorMas;

-- -----------------------------------------------------------------------------
-- Function to Decide the Increment Factor for incrementing Source and
-- Destination register.
-- -----------------------------------------------------------------------------
function SrcDstSize (
         signal Size             : in std_logic_vector(2 downto 0)
                    ) return std_logic_vector is
variable Result : std_logic_vector(2 downto 0);
-- return from function
begin
  case Size is
    when "000" =>
      Result := "001";
    when "001" =>
      Result := "010";
    when "010" =>
      Result := "100";
    when others =>
      Result := "001";
  end case;
  return (Result);
end SrcDstSize;

-- -----------------------------------------------------------------------------
-- Function to Decide the Burst Size
-- -----------------------------------------------------------------------------
function BurstSize (
         signal Burst            : in std_logic_vector(2 downto 0);
         signal SingleReq        : in std_logic;
         signal BurstReq         : in std_logic;
         signal TypeMem          : in std_logic
                    ) return std_logic_vector is
variable Result       : std_logic_vector(13 downto 0);
-- return from function
begin
  if ((BurstReq = '1') or (TypeMem = '1')) then
    case Burst is
      when "000" =>
        Result := ONE_14;
      when "001" =>
        Result := FOUR_14;
      when "010" =>
        Result := EIGHT_14;
      when "011" =>
        Result := SIXTEEN_14;
      when "100" =>
        Result := THIRTYTWO_14;
      when "101" =>
        Result := SIXTYFOUR_14;
      when "110" =>
        Result := ONETWOEIGHT_14;
      when "111" =>
        Result := TWOFIVESIX_14;
      when others =>
        Result := ONE_14;
    end case;
  else
    Result := ONE_14;
  end if;
  return (Result);
end BurstSize;

-- -----------------------------------------------------------------------------
-- Function to Calculate the Beat Count for AHB Master logic When Receiving
-- data from Source peripheral.
-- -----------------------------------------------------------------------------
function SrcBeatCount (
         signal SrcWidth         : in std_logic_vector(2 downto 0);
         signal DstWidth         : in std_logic_vector(2 downto 0);
         signal DstBeat          : in std_logic_vector(4 downto 0);
         signal Burst            : in std_logic_vector(13 downto 0);
         signal FifoLevelDel     : in std_logic_vector(4 downto 0);
         signal FifoLevelAct     : in std_logic_vector(4 downto 0);
         signal ChannelState     : in std_logic_vector(4 downto 0);
         signal AddrPhase        : in std_logic;
         signal SameBus          : in std_logic
                      ) return std_logic_vector is
variable Result : std_logic_vector(4 downto 0);
-- return from function
variable Temp1 : std_logic_vector(4 downto 0);
variable Temp2 : std_logic_vector(7 downto 0);
variable Temp3 : integer;
variable Temp4 : std_logic_vector(4 downto 0);
begin
  Temp1 := "10000" - (FifoLevelDel);
  Temp2 := ("10000" - FifoLevelAct + (DstBeat * DstWidth));
  Temp4 := ("10000" - FifoLevelAct);
  if (ChannelState = ST_IDLE) then
    if ((SrcWidth * Burst) >= Temp1) then
      Temp3 := (to_integer(Temp1) / to_integer(SrcWidth));
      Result := "00000" + Temp3;
    else
      Result := Burst(4 downto 0);
    end if;
  elsif ((SameBus = '1') and (ChannelState = ST_DMA_DST_XFER)) then
    if (AddrPhase = '0') then
      if ((SrcWidth * Burst) >= Temp2) then
        Result := to_integer(Temp2) / to_integer(SrcWidth) + "00000";
      else
        Result := Burst(4 downto 0);
      end if;
    else
      if ((SrcWidth * Burst) >= Temp4) then
        Result := to_integer(Temp4) / to_integer(SrcWidth) + "00000";
      else
        Result := Burst(4 downto 0);
      end if;
    end if;
  elsif (ChannelState = ST_PER_DUAL_BUS) then
    if ((SrcWidth * Burst) >= Temp1) then
      Result := to_integer(Temp1) / to_integer(SrcWidth) + "00000";
    else
      Result := Burst(4 downto 0);
    end if;
  end if;
  return (Result);
end SrcBeatCount;

-- -----------------------------------------------------------------------------
-- Function to Calculate the Beat Count for AHB Master logic When Transferring
-- data from DMA to Destination peripheral.
-- -----------------------------------------------------------------------------
function DstBeatCount (
         signal DstWidth         : in std_logic_vector(2 downto 0);
         signal SrcWidth         : in std_logic_vector(2 downto 0);
         signal Predict          : in std_logic_vector(1 downto 0);
         signal DstBurst         : in std_logic_vector(13 downto 0);
         signal FifoLevelDel     : in std_logic_vector(4 downto 0)
                      ) return std_logic_vector is
variable Result : std_logic_vector(4 downto 0);
-- return from function
variable Temp1 : std_logic_vector(5 downto 0);
begin
  Temp1 := ('0' & (FifoLevelDel + (Predict * SrcWidth)));
  if ((DstWidth * DstBurst) >= Temp1) then
    Result := to_integer(Temp1) / to_integer(DstWidth) + "00000";
  else
    Result := DstBurst(4 downto 0);
  end if;
  return (Result);
end DstBeatCount;

-- -----------------------------------------------------------------------------
-- Function to Calculate the minimum of Two Burst Counters
-- -----------------------------------------------------------------------------
function MinCnt (
         signal Burst1           : in std_logic_vector(13 downto 0);
         signal Burst2           : in std_logic_vector(13 downto 0)
                ) return std_logic_vector is
variable Result : std_logic_vector(13 downto 0);
-- return from function
begin
  if (Burst1 <= Burst2) then
    Result := Burst1;
  else
    Result := Burst2;
  end if;
  return (Result);
end MinCnt;


-- -----------------------------------------------------------------------------
-- Function to Calculate the maximum of Two FiFolevels
-- -----------------------------------------------------------------------------
function MaxCnt (
         signal Level1           : in std_logic_vector(4 downto 0);
         signal Level2           : in std_logic_vector(4 downto 0)
                ) return std_logic_vector is
variable Result : std_logic_vector(4 downto 0);
-- return from function
begin
  if (Level1 >= Level2) then
    Result := Level1;
  else
    Result := Level2;
  end if;
  return (Result);
end MaxCnt;

-- -----------------------------------------------------------------------------
-- Function to Select the Source Burst Count for SM based on Flow controller
-- and counter value i.e Minimum of TC and Burst values
-- -----------------------------------------------------------------------------
function SrcBurstCal (
         signal FlowCntl         : in std_logic_vector(2 downto 0);
         signal SrcBurst         : in std_logic_vector(13 downto 0);
         signal SrcBstDstFlow    : in std_logic_vector(13 downto 0);
         signal SourceTC         : in std_logic_vector(13 downto 0)
                      ) return std_logic_vector is
variable Result : std_logic_vector(13 downto 0);
-- return from function
begin
  case FlowCntl is
    when "000" | "001" | "010" | "011" =>
      if (SourceTC >= SrcBurst) then
        Result := SrcBurst;
      else
        Result := SourceTC;
      end if;
    when "100" | "101" =>
      if (SrcBstDstFlow >= SrcBurst) then
        Result := SrcBurst;
      else
        Result := SrcBstDstFlow;
      end if;
    when "110" | "111" =>
      Result := SrcBurst;
    when others =>
      null;
  end case;
  return (Result);
end SrcBurstCal;

-- -----------------------------------------------------------------------------
-- Function to Select the Destination Burst Count for SM based on Flow
-- controller and counter value, i.e Minimum of TC and Burst values
-- -----------------------------------------------------------------------------
function DstBurstCal (
         signal FlowCntl         : in std_logic_vector(2 downto 0);
         signal DstBurst         : in std_logic_vector(13 downto 0);
         signal DstBstSrcFlow    : in std_logic_vector(13 downto 0);
         signal DstTC            : in std_logic_vector(13 downto 0)
                     ) return std_logic_vector is
variable Result : std_logic_vector(13 downto 0);
-- return from function
begin
  case FlowCntl is
    when "000" | "001" | "010" | "011" =>
      if (DstTC >= DstBurst) then
        Result := DstBurst;
      else
        Result := DstTC;
      end if;
    when "100" | "101" =>
      Result := DstBurst;
    when "110" | "111" =>
      if (DstBstSrcFlow >= DstBurst) then
        Result := DstBurst;
      else
        Result := DstBstSrcFlow;
      end if;
    when others =>
      null;
  end case;
  return (Result);
end DstBurstCal;

-- -----------------------------------------------------------------------------
-- Function to Select the TC Counter This function is not effective for Source
-- Flow Controller.
-- -----------------------------------------------------------------------------
function SelTC (
         signal FlowCntl         : in std_logic_vector(2 downto 0);
         signal TCCount          : in std_logic_vector(13 downto 0);
         signal TCXflow          : in std_logic_vector(13 downto 0);
         signal XLstOccrd        : in std_logic;
         signal LstOccrd         : in std_logic
                     ) return std_logic_vector is
variable Result : std_logic_vector(13 downto 0);
-- return from function
begin
  if (FlowCntl(2) = '0') then
    Result := TCCount;
  elsif (LstOccrd = '1') then
    Result := TCCount;
  else
    Result := ALLONE_14;
  end if;
  return (Result);
end SelTC;

-- -----------------------------------------------------------------------------
--
-- Main body of code
-- =================
--
-- -----------------------------------------------------------------------------

begin

-- -----------------------------------------------------------------------------
-- Assigning internal signals to the outputs and few signals for Aliasing
-- -----------------------------------------------------------------------------
SrcReg           <= ChConfigReg(4 downto 1);
DstReg           <= ChConfigReg(9 downto 6);
SrcAhbMasSel     <= '0';
DstAhbMasSel     <= '0';
-- FOLLOWING LINES ARE COMMENTED OUT FOR VARIANT
--SrcAhbMasSel     <= ChControlReg(24);
--DstAhbMasSel     <= ChControlReg(25);
SrcWidth         <= ChControlReg(20 downto 18);
DstWidth         <= ChControlReg(23 downto 21);
SrcBusWidth      <= SrcDstSize(SrcWidth);
DstBusWidth      <= SrcDstSize(DstWidth);
SrcBurstSize     <= ChControlReg(14 downto 12);
DstBurstSize     <= ChControlReg(17 downto 15);
SrcIncrBit       <= ChControlReg(26);
DstIncrBit       <= ChControlReg(27);
FlowCntl         <= ChConfigReg(13 downto 11);
ChEnable         <= ChConfigReg(0) and DmacTrEn;
IntMask          <= ChControlReg(31) and ChConfigReg(15);
ErrMask          <= ChConfigReg(14);
SameBus          <= '1' when (DstAhbMasSel = SrcAhbMasSel)
                 else
                    '0';
DiffBus          <= '1' when (DstAhbMasSel /= SrcAhbMasSel)
                 else
                    '0';
LLILoad          <= ChLLIReg(31 downto 2);
NextLLIAhbMasSel <= '0';
-- FOLLOWING LINES ARE COMMENTED OUT FOR VARIANT
--NextLLIAhbMasSel <= ChLLIReg(0) when (ChannelState /= ST_LLI_LOAD)
--                 else
--                    LLIAhbMasSel;
AddrOffSetSrc    <= ChSrcAddrReg(1 downto 0);
ValidDataSrc     <= DataValid(SrcAhbMasSel, DataValid1, DataValid2);
ValidDataDst     <= DataValid(DstAhbMasSel, DataValid1, DataValid2);
ValidDataLLI     <= DataValid(LLIAhbMasSel, DataValid1, DataValid2);

-- -----------------------------------------------------------------------------
-- This process is responsible for Synchronizing DMACCLR and DMACTC signals
-- With UUT.
-- -----------------------------------------------------------------------------
p_DmacClrComb : process (DstReqBefMask, iDMACTC, iDMACCLR, DstReg, DMACTCDel,
                         DMACCLRDel, SrcReqBefMask, SrcReg, FlowCntl,
                         SoftClrPulse)
begin
  DMACTC <= (others => '0');
  DMACCLR <= (others => '0');
  SOFTCLR <= (others => '0');
  if ((FlowCntl = "001") or (FlowCntl = "011") or (FlowCntl = "100") or
                                 (FlowCntl = "101") or (FlowCntl = "111")) then
    if (DstReqBefMask = '0') then
      DMACTC(to_integer(DstReg)) <= iDMACTC(to_integer(DstReg));
      DMACCLR(to_integer(DstReg)) <= iDMACCLR(to_integer(DstReg));
    else
      DMACTC(to_integer(DstReg)) <= DMACTCDel(to_integer(DstReg));
      DMACCLR(to_integer(DstReg)) <= DMACCLRDel(to_integer(DstReg));
    end if;
    SOFTCLR(to_integer(DstReg)) <= SoftClrPulse;
  end if;

  if ((FlowCntl = "010") or (FlowCntl = "011") or (FlowCntl = "100") or
                                 (FlowCntl = "110") or (FlowCntl = "111")) then
    if (SrcReqBefMask = '0') then
      DMACTC(to_integer(SrcReg)) <= iDMACTC(to_integer(SrcReg));
      DMACCLR(to_integer(SrcReg)) <= iDMACCLR(to_integer(SrcReg));
    else
      DMACTC(to_integer(SrcReg)) <= DMACTCDel(to_integer(SrcReg));
      DMACCLR(to_integer(SrcReg)) <= DMACCLRDel(to_integer(SrcReg));
    end if;
    SOFTCLR(to_integer(SrcReg)) <= SoftClrPulse;
  end if;
end process p_DmacClrComb;

-- -----------------------------------------------------------------------------
-- This process is responsible for Synchronizing Channel Error Interrupt signal
-- With UUT.
-- -----------------------------------------------------------------------------
p_ErrIntComb : process (FlowCntl, iChIntErr, iDMACCLR, DstReg, ChIntErrDel1,
                        DMACCLR2Del, SrcReg, WaitedForClr, DelIntr)
begin
  ChIntErr <= '0';
  NextWaitedForClr <= WaitedForClr;
  case FlowCntl is
    when "000" =>
      if (iChIntErr /= '0') then
        ChIntErr <= ChIntErrDel1;
      else
        ChIntErr <= iChIntErr;
      end if;

    when "001" | "101" =>
      if ((iDMACCLR(to_integer(DstReg)) = '1') or
                                   (DMACCLR2Del(to_integer(DstReg)) = '1')) then
        ChIntErr <= iChIntErr;
        NextWaitedForClr <= '1';
      elsif ((iChIntErr /= '0') and (WaitedForClr = '0')) then
        ChIntErr <= ChIntErrDel1;
      elsif ((iChIntErr /= '0') and (WaitedForClr = '1') and
                                                          (DelIntr = '1')) then
        ChIntErr <= ChIntErrDel1;
      else
        ChIntErr <= iChIntErr;
      end if;

      if ((iDMACCLR(to_integer(DstReg)) = '0') and (iChIntErr = '0') and
                               (DMACCLR2Del(to_integer(DstReg)) = '0')) then
        NextWaitedForClr <= '0';
      end if;

    when "010" | "110" =>
      if ((iDMACCLR(to_integer(SrcReg)) = '1') or
                                   (DMACCLR2Del(to_integer(SrcReg)) = '1')) then
        ChIntErr <= iChIntErr;
        NextWaitedForClr <= '1';
      elsif ((iChIntErr /= '0') and (WaitedForClr = '0')) then
        ChIntErr <= ChIntErrDel1;
      elsif ((iChIntErr /= '0') and (WaitedForClr = '1') and
                                                          (DelIntr = '1')) then
        ChIntErr <= ChIntErrDel1;
      else
        ChIntErr <= iChIntErr;
      end if;

      if ((iDMACCLR(to_integer(SrcReg)) = '0') and (iChIntErr = '0') and
                                 (DMACCLR2Del(to_integer(SrcReg)) = '0')) then
        NextWaitedForClr <= '0';
      end if;

    when "011" | "100" | "111" =>
      if ((iDMACCLR(to_integer(DstReg)) = '1') or
                                   (DMACCLR2Del(to_integer(DstReg)) = '1') or
         (iDMACCLR(to_integer(SrcReg)) = '1') or
                                  (DMACCLR2Del(to_integer(SrcReg)) = '1')) then
        ChIntErr <= iChIntErr;
        NextWaitedForClr <= '1';
      elsif ((iChIntErr /= '0') and (WaitedForClr = '0')) then
        ChIntErr <= ChIntErrDel1;
      elsif ((iChIntErr /= '0') and (WaitedForClr = '1') and
                                                          (DelIntr = '1')) then
        ChIntErr <= ChIntErrDel1;
      else
        ChIntErr <= iChIntErr;
      end if;

      if ((iDMACCLR(to_integer(DstReg)) = '0') and
                                 (DMACCLR2Del(to_integer(DstReg)) = '0') and
         (iDMACCLR(to_integer(SrcReg)) = '0') and (iChIntErr = '0') and
                                (DMACCLR2Del(to_integer(SrcReg)) = '0')) then
        NextWaitedForClr <= '0';
      end if;

    when others =>
      null;
  end case;
end process p_ErrIntComb;

-- -----------------------------------------------------------------------------
-- This process is responsible for generating one signal which gives an
-- indication to Delay the Interrupt so that Synchronizing Channel Error
-- Interrupt signal With UUT happens.
-- -----------------------------------------------------------------------------
p_ErrClrDetComb : process (DelIntr, SrcState, SrcAhbMasSel, ErrPulse1,
                           ErrPulse2, iDMACCLR, DstReg, SrcReg, iChIntErr,
                           DMACCLR2Del, DstState, DstAhbMasSel, DelSrcState,
                           DelDstState)
begin
  NextDelIntr <= DelIntr;
  if ((SrcState = '1') or (DelSrcState = '1')) then
    if ((SelComb(SrcAhbMasSel, ErrPulse1, ErrPulse2) = '1') and
        (iDMACCLR(to_integer(DstReg)) = '0')) then
      NextDelIntr <= '1';
    elsif ((iDMACCLR(to_integer(DstReg)) = '0') and
           (DMACCLR2Del(to_integer(DstReg)) = '0') and (iChIntErr = '0')) then
      NextDelIntr <= '0';
    end if;
  elsif ((DstState = '1') or (DelDstState = '1')) then
    if ((SelComb(DstAhbMasSel, ErrPulse1, ErrPulse2) = '1') and
        (iDMACCLR(to_integer(SrcReg)) = '0')) then
      NextDelIntr <= '1';
    elsif ((iDMACCLR(to_integer(SrcReg)) = '0') and
           (DMACCLR2Del(to_integer(SrcReg)) = '0') and (iChIntErr = '0')) then
      NextDelIntr <= '0';
    end if;
  end if;
end process p_ErrClrDetComb;

-- -----------------------------------------------------------------------------
-- Factor Calculation based on Destination. i.e FactorOnDstNum/FactorOnDstDen
-- -----------------------------------------------------------------------------
p_FactorDstComb : process (DstBusWidth, SrcBusWidth)
begin
  FactorOnDstNum <= "001";
  FactorOnDstDen <= "001";
  if (DstBusWidth = "100") then
    FactorOnDstNum <= (to_integer(DstBusWidth) / to_integer(SrcBusWidth)) +
                                                                          "000";
    FactorOnDstDen <= "001";
  end if;
  if (DstBusWidth = "010") then
    if (SrcBusWidth = "100") then
      FactorOnDstNum <= "001";
      FactorOnDstDen <= "010";
    else
      FactorOnDstNum <= (to_integer(DstBusWidth) / to_integer(SrcBusWidth)) +
                                                                          "000";
      FactorOnDstDen <= "001";
    end if;
  end if;
  if (DstBusWidth = "001") then
    FactorOnDstDen <= (to_integer(SrcBusWidth) / to_integer(DstBusWidth)) +
                                                                          "000";
    FactorOnDstNum <= "001";
  end if;
end process p_FactorDstComb;

-- -----------------------------------------------------------------------------
-- Factor Calculation based on Source. i.e FactorOnSrcNum/FactorOnSrcDen
-- -----------------------------------------------------------------------------
p_FactorSrcComb : process (DstBusWidth, SrcBusWidth)
begin
  FactorOnSrcNum <= "001";
  FactorOnSrcDen <= "001";
  if (SrcBusWidth = "100") then
    FactorOnSrcNum <= (to_integer(SrcBusWidth) / to_integer(DstBusWidth)) +
                                                                          "000";
    FactorOnSrcDen <= "001";
  end if;
  if (SrcBusWidth = "010") then
    if (DstBusWidth = "100") then
      FactorOnSrcNum <= "001";
      FactorOnSrcDen <= "010";
    else
      FactorOnSrcNum <= (to_integer(SrcBusWidth) / to_integer(DstBusWidth)) +
                                                                          "000";
      FactorOnSrcDen <= "001";
    end if;
  end if;
  if (SrcBusWidth = "001") then
    FactorOnSrcDen <= (to_integer(DstBusWidth) / to_integer(SrcBusWidth)) +
                                                                          "000";
    FactorOnSrcNum <= "001";
  end if;
end process p_FactorSrcComb;

-- -----------------------------------------------------------------------------
-- Writing into DMA Channel registers from different sources. The different
-- sources include from slave, during LLI Load from Bus1 or Bus2 and updating
-- of registers when transactions proceed.
-- -----------------------------------------------------------------------------
p_WriteComb : process (ChSrcAddrReg, ChDstAddrReg, ChControlReg, ChLLIReg,
                       ChConfigReg, ChSrcAddrWrEn, ChSrcMas1WrEn, ChSrcMas2WrEn,
                       ChDstAddrWrEn, ChDstMas1WrEn, ChDstMas2WrEn,
                       ChControlWrEn, ChCtrlMas1WrEn, ChCtrlMas2WrEn, ChLLIWrEn,
                       ChLLIMas1WrEn, ChLLIMas2WrEn, ChConfigWrEn, HWDATA,
                       HRDATAM1, HRDATAM2, ChannelState, SrcBusWidth,
                       SrcIncrBit, DstIncrBit, DstBusWidth, FlowCntl,
                       LLILoad, DstTC, DstTCSrcFlow, SrcLstOccrd, DstLstOccrd,
                       SrcDisAckOccrd, DstDisAckOccrd, DiffBus, OneBitTog,
                       TwoBitTog, ChHaltReg, LLIErrOccrd, ChDisableReg,
                       SrcWidth, DstWidth, SingleBusErr, DualBusErr, ChEnable,
                       SrcMaskReg, DMAFIFOLevel, ActFifoLevel, DelSrcState,
                       NotValidDataSrc, NotValidDataDst, ValidDataSrc,
                       ValidDataDst, DstBeat, SrcState, DstState,
                       LLIDisAckOccrd)
begin
  NextChSrcAddrReg <= ChSrcAddrReg;
  NextChDstAddrReg <= ChDstAddrReg;
  NextChControlReg <= ChControlReg;
  NextChLLIReg     <= ChLLIReg;
  NextChConfigReg  <= ChConfigReg;
  NextOneBitTog    <= OneBitTog;
  NextTwoBitTog    <= TwoBitTog;
  NextChHalt       <= ChHaltReg;
  NextChDisable    <= ChDisableReg;

  if (ChSrcAddrWrEn = '1') then
    NextChSrcAddrReg <= HWDATA;
  elsif (ChSrcMas1WrEn = '1') then
    NextChSrcAddrReg <= HRDATAM1;
  elsif (ChSrcMas2WrEn = '1') then
    NextChSrcAddrReg <= HRDATAM2;
  elsif (SrcState = '1') then
    if ((ValidDataSrc = '1') and (NotValidDataSrc = '0') and
                                                        (SrcIncrBit = '1')) then
      NextChSrcAddrReg <= ChSrcAddrReg + SrcBusWidth;
    end if;
  end if;

  if (ChDstAddrWrEn = '1') then
    NextChDstAddrReg <= HWDATA;
  elsif (ChDstMas1WrEn = '1') then
    NextChDstAddrReg <= HRDATAM1;
  elsif (ChDstMas2WrEn = '1') then
    NextChDstAddrReg <= HRDATAM2;
  elsif (DstState = '1') then
    if ((ValidDataDst = '1') and (NotValidDataDst = '0') and
                                                        (DstIncrBit = '1')) then
      NextChDstAddrReg <= ChDstAddrReg + DstBusWidth;
    end if;
  end if;

  if (ChControlWrEn = '1') then
    NextChControlReg <= HWDATA;
  elsif (ChCtrlMas1WrEn = '1') then
    NextChControlReg <= HRDATAM1;
  elsif (ChCtrlMas2WrEn = '1') then
    NextChControlReg <= HRDATAM2;
  elsif (DstState = '1') then
    if ((ValidDataDst = '1') and (NotValidDataDst = '0') and
                                                       (FlowCntl(2) = '0')) then
      case SrcWidth is
        when "000" =>
          case DstWidth is
            when "000" =>
              NextChControlReg(11 downto 0) <= ChControlReg(11 downto 0) - '1';
            when "001" =>
              NextChControlReg(11 downto 0) <= ChControlReg(11 downto 0) - "10";
            when "010" =>
              NextChControlReg(11 downto 0) <=
                                              ChControlReg(11 downto 0) - "100";
            when others =>
              null;
          end case;
        when "001" =>
          case DstWidth is
            when "000" =>
              if (OneBitTog = '1') then
                NextChControlReg(11 downto 0) <=
                                               ChControlReg(11 downto 0) - "10";
              else
                NextOneBitTog <= not OneBitTog;
              end if;
            when "001" =>
              NextChControlReg(11 downto 0) <= ChControlReg(11 downto 0) - '1';
            when "010" =>
              NextChControlReg(11 downto 0) <= ChControlReg(11 downto 0) - "10";
            when others =>
              null;
          end case;
        when "010" =>
          case DstWidth is
            when "000" =>
              if (TwoBitTog = "11") then
                NextChControlReg(11 downto 0) <=
                                              ChControlReg(11 downto 0) - "100";
              else
                NextTwoBitTog <= TwoBitTog + "01";
              end if;
            when "001" =>
              if (OneBitTog = '1') then
                NextChControlReg(11 downto 0) <=
                                               ChControlReg(11 downto 0) - "10";
              else
                NextOneBitTog <= not OneBitTog;
              end if;
            when "010" =>
              NextChControlReg(11 downto 0) <= ChControlReg(11 downto 0) - '1';
            when others =>
              null;
          end case;
        when others =>
          null;
      end case;
    end if;
  end if;

  if (ChLLIWrEn = '1') then
    NextChLLIReg <= HWDATA;
  elsif (ChLLIMas1WrEn = '1') then
    NextChLLIReg <= HRDATAM1;
  elsif (ChLLIMas2WrEn = '1') then
    NextChLLIReg <= HRDATAM2;
  end if;

  if (ChConfigWrEn = '1') then
    NextChConfigReg  <= HWDATA;
    NextChHalt       <= HWDATA(18);
    if (ChEnable = '1') then
      NextChDisable    <= not HWDATA(0);
    else
      NextChDisable    <= '0';
    end if;
    if ((ChannelState = ST_IDLE) and (HWDATA(0) = '0')) then
      NextChConfigReg(0) <= '0';
    end if;
  elsif (((LLILoad = ZERO_30) and ((SelTC(FlowCntl, DstTC, DstTCSrcFlow,
           SrcLstOccrd, DstLstOccrd) = ONE_14) or ((SrcMaskReg = '1') and
           (DMAFIFOLevel = "00000") and (ActFifoLevel = "00000") and
           (DelSrcState = '0') and (FlowCntl(2 downto 1) = "11") and
           (DstBeat = "00001"))) and (DstState = '1') and
           (ValidDataDst = '1') and (NotValidDataDst = '0')) or
          (((SrcDisAckOccrd = '1') and (DstDisAckOccrd = '1') and
            (DiffBus = '1')) or (((SrcDisAckOccrd = '1') or
            (DstDisAckOccrd = '1') or (LLIDisAckOccrd = '1')) and
            (DiffBus = '0'))) or ((SingleBusErr = '1') or (DualBusErr = '1') or
                                                     (LLIErrOccrd = '1'))) then
    NextChConfigReg(0) <= '0';
  end if;
end process p_WriteComb;

-- -----------------------------------------------------------------------------
-- This process is responsible for generating the Disable condition. That is it
-- generates the Channel Disable indication to Respective Source or Destination
-- Master, and it waits for the Acknowledge to be received from Masters to
-- Completely Disable the Channel. The timing of generation of these signals is
-- controlled by the SM.
-- -----------------------------------------------------------------------------
p_DisSMComb : process (SingleBusErr, DualBusErr, DisableST, SrcDisable,
                       DstDisable, DelChDisable, SrcState,
                       DstState,
                       SameBus, SrcAhbMasSel, DisAckMas1, DisAckMas2,
                       NotValidDataSrc, NotValidDataDst, SrcBeat, DstBeat,
                       DstAhbMasSel, DelNotValidSrc, DelNotValidDst,
                       DelNotValidLLI, ChannelState, LLIBeat, LLIDisable,
                       LLIAhbMasSel, NotValidDataLLI)
begin
  NextDisableST  <= DisableST;
  NextSrcDisable <= SrcDisable;
  NextDstDisable <= DstDisable;
  NextLLIDisable <= LLIDisable;
  if ((SingleBusErr = '0') or (DualBusErr = '0')) then
    case DisableST is
      when ST_DISABLE_IDLE =>
        if ((DelChDisable = '1') and (SrcState = '1') and
            (DelNotValidSrc = '0') and (SrcBeat > "00011")) then
          NextDisableST <= ST_DISABLE_OCCRD;
          NextSrcDisable <= '1';
          NextDstDisable <= '1';
        elsif ((DelChDisable = '1') and (DstState = '1') and
               (DelNotValidDst = '0') and (DstBeat > "00011")) then
          NextDisableST <= ST_DISABLE_OCCRD;
          NextSrcDisable <= '1';
          NextDstDisable <= '1';
        elsif ((DelChDisable = '1') and (ChannelState = ST_LLI_LOAD) and
               (DelNotValidLLI = '0') and (LLIBeat > "00011")) then
          NextDisableST <= ST_DISABLE_OCCRD;
          NextLLIDisable <= '1';
        end if;

      when ST_DISABLE_OCCRD =>
        if ((SameBus = '1') and (DisableAck(SrcAhbMasSel, DisAckMas1,
          DisAckMas2) = '1') and (((SrcState = '1') and (NotValidDataSrc = '0'))
            or ((DstState = '1') and (NotValidDataDst = '0')))) then
          NextDisableST <= ST_DISABLE_IDLE;
          NextSrcDisable <= '0';
          NextDstDisable <= '0';
          NextLLIDisable <= '0';
        elsif ((SameBus = '1') and (((SrcState = '1') and (SrcBeat <= "00011"))
               or ((DstState = '1') and (DstBeat <= "00011")))) then
          NextDisableST <= ST_DISABLE_IDLE;
          NextSrcDisable <= '0';
          NextDstDisable <= '0';
          NextLLIDisable <= '0';
        elsif ((SameBus = '0') and (DisableAck(SrcAhbMasSel, DisAckMas1,
            DisAckMas2) = '1') and (SrcState = '1') and (NotValidDataSrc = '0')
            and (DstState = '1') and (NotValidDataDst = '0') and
            (DisableAck(DstAhbMasSel, DisAckMas1, DisAckMas2) = '1')) then
          NextDisableST <= ST_DISABLE_IDLE;
          NextSrcDisable <= '0';
          NextDstDisable <= '0';
          NextLLIDisable <= '0';
        elsif ((SameBus = '0') and (SrcState = '1') and (NotValidDataSrc = '0')
               and ((DisableAck(SrcAhbMasSel, DisAckMas1, DisAckMas2) = '1') or
                   (SrcBeat <= "00011"))) then
          NextSrcDisable <= '0';
          NextDisableST <= ST_DISABLE_SRCACK_RXD;
        elsif ((SameBus = '0') and (DstState = '1') and (NotValidDataDst = '0')
               and ((DisableAck(DstAhbMasSel, DisAckMas1, DisAckMas2) = '1') or
                                                   (DstBeat <= "00011"))) then
          NextDstDisable <= '0';
          NextDisableST <= ST_DISABLE_DSTACK_RXD;
        elsif (((DisableAck(LLIAhbMasSel, DisAckMas1, DisAckMas2) = '1') or
                (LLIBeat <= "00011")) and (ChannelState = ST_LLI_LOAD) and
                                                   (NotValidDataLLI = '0')) then
          NextDisableST <= ST_DISABLE_IDLE;
          NextSrcDisable <= '0';
          NextDstDisable <= '0';
          NextLLIDisable <= '0';
        end if;

      when ST_DISABLE_SRCACK_RXD =>
        if ((DstState = '1') and (NotValidDataDst = '0')
            and ((DisableAck(DstAhbMasSel, DisAckMas1, DisAckMas2) = '1') or
                                                   (DstBeat <= "00011"))) then
          NextDisableST <= ST_DISABLE_IDLE;
          NextDstDisable <= '0';
        end if;

      when ST_DISABLE_DSTACK_RXD =>
        if ((SrcState = '1') and (NotValidDataSrc = '0')
            and ((DisableAck(SrcAhbMasSel, DisAckMas1, DisAckMas2) = '1') or
                                                   (SrcBeat <= "00011"))) then
          NextDisableST <= ST_DISABLE_IDLE;
          NextSrcDisable <= '0';
        end if;

      when others =>
        null;
    end case;
  else
    NextDisableST <= ST_DISABLE_IDLE;
    NextSrcDisable <= '0';
    NextDstDisable <= '0';
    NextLLIDisable <= '0';
  end if;
end process p_DisSMComb;


-- -----------------------------------------------------------------------------
-- Pulse generations for recognizing the Disable Acknowledge
-- -----------------------------------------------------------------------------
Pulse1 <= '1' when ((NextDisableST = ST_DISABLE_IDLE) and
                                                 (DisableST = ST_DISABLE_OCCRD))
       else
          '0';

Pulse2 <= '1' when ((NextDisableST = ST_DISABLE_SRCACK_RXD) and
                                                 (DisableST = ST_DISABLE_OCCRD))
       else
          '0';

Pulse3 <= '1' when ((NextDisableST = ST_DISABLE_DSTACK_RXD) and
                                                 (DisableST = ST_DISABLE_OCCRD))
       else
          '0';

Pulse4 <= '1' when ((NextDisableST = ST_DISABLE_IDLE) and
                                           (DisableST = ST_DISABLE_SRCACK_RXD))
       else
          '0';

Pulse5 <= '1' when ((NextDisableST = ST_DISABLE_IDLE) and
                                           (DisableST = ST_DISABLE_DSTACK_RXD))
       else
          '0';

-- -----------------------------------------------------------------------------
-- Indication of Source Disable Acknowledge
-- -----------------------------------------------------------------------------
SrcDisAckOccrd <= '1' when ((Pulse1 = '1') or (Pulse2 = '1') or (Pulse5 = '1'))
               else
                  '0';

-- -----------------------------------------------------------------------------
-- Indication of Destination Disable Acknowledge
-- -----------------------------------------------------------------------------
DstDisAckOccrd <= '1' when ((Pulse1 = '1') or (Pulse3 = '1') or (Pulse4 = '1'))
               else
                  '0';

-- -----------------------------------------------------------------------------
-- Indication of LLI Disable Acknowledge
-- -----------------------------------------------------------------------------
LLIDisAckOccrd <= '1' when (Pulse1 = '1')
               else
                  '0';

-- -----------------------------------------------------------------------------
-- This process is responsible for generating the Error condition. That is it
-- generates SingleBusErr and DualBusErr signal. The timing of this signal
-- generation is controlled by the SM.
-- -----------------------------------------------------------------------------
p_ErrSMComb : process (ErrorState, SrcErrOccrd, DstErrOccrd, SameBus, ChEnable,
                       DstBeat, SrcBeat, LLIErrOccrd, NotValidDataDst, DstState,
                       SrcState, NotValidDataSrc, SrcSelComb, DstSelComb,
                       FlowCntl, iDMACCLR, SrcReg, DstReg, DelSrcState,
                       DelDstState)
begin
  NextErrorState <= ErrorState;
  case ErrorState is
    when ST_ERROR_INIT =>

      if ((SrcErrOccrd = '1') and (SameBus = '1')) then
        if ((FlowCntl = "001") or (FlowCntl = "011") or (FlowCntl = "100")
              or (FlowCntl = "101") or (FlowCntl = "111")) then
          if (iDMACCLR(to_integer(DstReg)) = '0') then
            NextErrorState <= ST_ERROR_SINGLE;
          end if;
        else
          NextErrorState <= ST_ERROR_SINGLE;
        end if;
      elsif ((DstErrOccrd = '1') and (SameBus = '1')) then
        if ((FlowCntl = "010") or (FlowCntl = "011") or (FlowCntl = "100")
              or (FlowCntl = "110") or (FlowCntl = "111")) then
          if (iDMACCLR(to_integer(SrcReg)) = '0') then
            NextErrorState <= ST_ERROR_SINGLE;
          end if;
        else
          NextErrorState <= ST_ERROR_SINGLE;
        end if;
      elsif (LLIErrOccrd = '1') then
        if ((FlowCntl = "001") or (FlowCntl = "011") or (FlowCntl = "100")
              or (FlowCntl = "101") or (FlowCntl = "111")) then
          if (iDMACCLR(to_integer(DstReg)) = '0') then
            NextErrorState <= ST_ERROR_SINGLE;
          end if;
        else
          NextErrorState <= ST_ERROR_SINGLE;
        end if;
      elsif ((SrcErrOccrd = '1') and (DstErrOccrd = '1') and
                                                           (SameBus = '0')) then
        NextErrorState <= ST_ERROR_DUAL;
      elsif ((SrcErrOccrd = '1') and (DstErrOccrd = '0') and (SameBus = '0') and
             (DstBeat >= "00001")) then
        NextErrorState <= ST_ERROR_SOURCE;
      elsif ((SrcErrOccrd = '1') and (DstErrOccrd = '0') and (SameBus = '0') and
             (DstBeat = "00000") and (DstSelComb = '0')) then
        if (((FlowCntl = "001") or (FlowCntl = "011") or (FlowCntl = "100")
                or (FlowCntl = "101") or (FlowCntl = "111")) and
                                                          (DstState = '0')) then
          if (iDMACCLR(to_integer(DstReg)) = '0') then
            NextErrorState <= ST_ERROR_DUAL;
          end if;
        elsif ((DstBeat = "00000") and (DstState = '0') and
               (NotValidDataDst = '0') and ((FlowCntl = "000") or
                               (FlowCntl = "010") or (FlowCntl = "110"))) then
          NextErrorState <= ST_ERROR_DUAL;
        end if;
      elsif ((SrcErrOccrd = '0') and (DstErrOccrd = '1') and (SameBus = '0') and
             (SrcBeat >= "00001")) then
        NextErrorState <= ST_ERROR_DEST;
      elsif ((SrcErrOccrd = '0') and (DstErrOccrd = '1') and (SameBus = '0') and
             (SrcBeat = "00000") and (SrcSelComb = '0')) then
        if (((FlowCntl = "010") or (FlowCntl = "011") or (FlowCntl = "100")
                or (FlowCntl = "110") or (FlowCntl = "111")) and
                                                         (SrcState = '0')) then
          if (iDMACCLR(to_integer(SrcReg)) = '0') then
            NextErrorState <= ST_ERROR_DUAL;
          end if;
        elsif ((SrcBeat = "00000") and (SrcState = '0') and
               (NotValidDataSrc = '0') and ((FlowCntl = "000") or
                               (FlowCntl = "001") or (FlowCntl = "101"))) then
          NextErrorState <= ST_ERROR_DUAL;
        end if;
      end if;

    when ST_ERROR_SINGLE =>
      if (ChEnable = '0') then
        NextErrorState <= ST_ERROR_INIT;
      end if;

    when ST_ERROR_DUAL =>
      if (ChEnable = '0') then
        NextErrorState <= ST_ERROR_INIT;
      end if;

    when ST_ERROR_SOURCE =>
      if (DstErrOccrd = '1') then
        NextErrorState <= ST_ERROR_DUAL;
      elsif ((DstBeat = "00000") and (DelDstState = '1') and
             (NotValidDataDst = '0') and ((FlowCntl = "000") or
                               (FlowCntl = "010") or (FlowCntl = "110"))) then
        NextErrorState <= ST_ERROR_DUAL;
      elsif ((DstBeat = "00000") and (DelDstState = '1') and
             (NotValidDataDst = '0') and
                                      (iDMACCLR(to_integer(DstReg)) = '0')) then
        NextErrorState <= ST_ERROR_DUAL;
      elsif (((FlowCntl = "001") or (FlowCntl = "011") or (FlowCntl = "100")
              or (FlowCntl = "101") or (FlowCntl = "111")) and
                                                          (DstState = '0')) then
        if (iDMACCLR(to_integer(DstReg)) = '0') then
          NextErrorState <= ST_ERROR_DUAL;
        end if;
      end if;

    when ST_ERROR_DEST =>
      if (SrcErrOccrd = '1') then
        NextErrorState <= ST_ERROR_DUAL;
      elsif ((SrcBeat = "00000") and (DelSrcState = '1') and
             (NotValidDataSrc = '0') and ((FlowCntl = "000") or
                                (FlowCntl = "001") or (FlowCntl = "101"))) then
        NextErrorState <= ST_ERROR_DUAL;
      elsif ((SrcBeat = "00000") and (DelSrcState = '1') and
             (NotValidDataSrc = '0') and
                                     (iDMACCLR(to_integer(SrcReg)) = '0')) then
        NextErrorState <= ST_ERROR_DUAL;
      elsif (((FlowCntl = "010") or (FlowCntl = "011") or (FlowCntl = "100")
              or (FlowCntl = "110") or (FlowCntl = "111")) and
                                                          (SrcState = '0')) then
        if (iDMACCLR(to_integer(SrcReg)) = '0') then
          NextErrorState <= ST_ERROR_DUAL;
        end if;
      end if;

    when others =>
      null;
  end case;
end process p_ErrSMComb;

-- -----------------------------------------------------------------------------
-- Single Bus Error indication
-- -----------------------------------------------------------------------------
SingleBusErr <= '1' when (ErrorState = ST_ERROR_SINGLE)
             else
               '0';

-- -----------------------------------------------------------------------------
-- Dual Bus Error indication
-- -----------------------------------------------------------------------------
DualBusErr <= '1' when (ErrorState = ST_ERROR_DUAL)
             else
               '0';

ChDisable <= ChDisableReg or NextChDisable;
ChHalt    <= ChHaltReg;

-- -----------------------------------------------------------------------------
-- Generation of Write enables when LLI Loading is taking place
-- -----------------------------------------------------------------------------
p_LLILoadWrComb : process (ChannelState, LLIAhbMasSel, DataValid1, TwoBitCnt,
                           DataValid2, NotValidDataLLI)
begin
  ChSrcMas1WrEn  <= '0';
  ChDstMas1WrEn  <= '0';
  ChCtrlMas1WrEn <= '0';
  ChLLIMas1WrEn  <= '0';
  ChSrcMas2WrEn  <= '0';
  ChDstMas2WrEn  <= '0';
  ChCtrlMas2WrEn <= '0';
  ChLLIMas2WrEn  <= '0';
  if (ChannelState = ST_LLI_LOAD) then
    if (LLIAhbMasSel = '0') then
      if ((DataValid1 = '1') and (NotValidDataLLI = '0') and
                                                       (TwoBitCnt = "00")) then
        ChSrcMas1WrEn <= '1';
      elsif ((DataValid1 = '1') and (NotValidDataLLI = '0') and
                                                       (TwoBitCnt = "01")) then
        ChDstMas1WrEn <= '1';
      elsif ((DataValid1 = '1') and (NotValidDataLLI = '0') and
                                                       (TwoBitCnt = "10")) then
        ChLLIMas1WrEn <= '1';
      elsif ((DataValid1 = '1') and (NotValidDataLLI = '0') and
                                                       (TwoBitCnt = "11")) then
        ChCtrlMas1WrEn <= '1';
      end if;
    else
      if ((DataValid2 = '1') and (NotValidDataLLI = '0') and
                                                       (TwoBitCnt = "00")) then
        ChSrcMas2WrEn <= '1';
      elsif ((DataValid2 = '1') and (NotValidDataLLI = '0') and
                                                       (TwoBitCnt = "01")) then
        ChDstMas2WrEn <= '1';
      elsif ((DataValid2 = '1') and (NotValidDataLLI = '0') and
                                                       (TwoBitCnt = "10")) then
        ChLLIMas2WrEn <= '1';
      elsif ((DataValid2 = '1') and (NotValidDataLLI = '0') and
                                                       (TwoBitCnt = "11")) then
        ChCtrlMas2WrEn <= '1';
      end if;
    end if;
  end if;
end process p_LLILoadWrComb;

-- -----------------------------------------------------------------------------
-- Logic to generate SrcReqCh and DstReqCh
-- Here only the selected DMA request lines are sampled based on the flow
-- controller. For Memory type transactions the Request is asserted till the
-- end of Transfer. For LLI load the request is asserted when the SM enters the
-- ST_LLI_LOAD.
-- -----------------------------------------------------------------------------
p_SrcDstReqComb : process (FlowCntl, SrcReg, DstReg, DMACBREQ, SOFTBREQ,
                           DMACSREQ, SOFTSREQ, DMACLBREQ, DMACLSREQ, SOFTLSREQ,
                           SOFTLBREQ, DelLLIState, LLIBeat, DelDstFlowReq,
                           DMAFIFOLevel, DstBusWidth, DelChEnable, ChEnable,
                           NotValidDataLLI, LLIAhbMasSel, ErrorMas1, ErrorMas2,
                           LLISelReg)
variable Temp1        : std_logic;
begin
SrcReqBefMask <= '0';
DstReqBefMask <= '0';
DstFlowReq    <= '0';
  for i in 0 to 15 loop
    case FlowCntl is
      when "000" =>
        SrcReqBefMask <= '1';
        DstReqBefMask <= '1';

      when "001" =>
        SrcReqBefMask <= '1';
        if (DstReg = i) then
          DstReqBefMask <= DMACBREQ(i) or SOFTBREQ(i);
        end if;

      when "010" =>
        if (SrcReg = i) then
          SrcReqBefMask <= DMACBREQ(i) or SOFTBREQ(i) or
                           DMACSREQ(i) or SOFTSREQ(i);
        end if;
        DstReqBefMask <= '1';

      when "011" =>
        if (SrcReg = i) then
          SrcReqBefMask <= DMACBREQ(i) or DMACSREQ(i) or
                           SOFTBREQ(i) or SOFTSREQ(i);
        end if;

        if (DstReg = i) then
          DstReqBefMask <= DMACBREQ(i) or SOFTBREQ(i);
        end if;

      when "100" =>
        if (SrcReg = i) then
          SrcReqBefMask <= DMACBREQ(i) or DMACSREQ(i) or
                          SOFTBREQ(i) or SOFTSREQ(i);
        end if;

        if (DstReg = i) then
          DstFlowReq <= DMACBREQ(i) or DMACSREQ(i) or DMACLBREQ(i) or
                        DMACLSREQ(i) or SOFTBREQ(i) or SOFTSREQ(i) or
                        SOFTLSREQ(i) or SOFTLBREQ(i);
          Temp1 := DMACBREQ(i) or DMACSREQ(i) or DMACLBREQ(i) or
                   DMACLSREQ(i) or SOFTBREQ(i) or SOFTSREQ(i) or
                   SOFTLSREQ(i) or SOFTLBREQ(i);
          if (DelChEnable = '0') then
            DstReqBefMask <= DelDstFlowReq;
          elsif (((to_integer(DMAFIFOLevel) / to_integer(DstBusWidth)) > 0) and
                                                          (ChEnable = '1')) then
            DstReqBefMask <= Temp1;
          else
            DstReqBefMask <= DelDstFlowReq;
          end if;
        end if;

      when "101" =>
        SrcReqBefMask <= '1';
        if (DstReg = i) then
          DstFlowReq <= DMACBREQ(i) or DMACSREQ(i) or DMACLBREQ(i) or
                        DMACLSREQ(i) or SOFTBREQ(i) or SOFTSREQ(i) or
                        SOFTLSREQ(i) or SOFTLBREQ(i);
          Temp1 := DMACBREQ(i) or DMACSREQ(i) or DMACLBREQ(i) or
                   DMACLSREQ(i) or SOFTBREQ(i) or SOFTSREQ(i) or
                   SOFTLSREQ(i) or SOFTLBREQ(i);
          if (DelChEnable = '0') then
            DstReqBefMask <= DelDstFlowReq;
          elsif (((to_integer(DMAFIFOLevel) / to_integer(DstBusWidth)) > 0) and
                                                          (ChEnable = '1')) then
            DstReqBefMask <= Temp1;
          else
            DstReqBefMask <= DelDstFlowReq;
          end if;
        end if;

      when "110" =>
        if (SrcReg = i) then
          SrcReqBefMask <= DMACBREQ(i) or DMACSREQ(i) or DMACLBREQ(i) or
                           DMACLSREQ(i) or SOFTBREQ(i) or SOFTSREQ(i) or
                           SOFTLSREQ(i) or SOFTLBREQ(i);
        end if;
        DstReqBefMask <= '1';

      when "111" =>
        if (SrcReg = i) then
          SrcReqBefMask <= DMACBREQ(i) or DMACSREQ(i) or DMACLBREQ(i) or
                           DMACLSREQ(i) or SOFTBREQ(i) or SOFTSREQ(i) or
                           SOFTLSREQ(i) or SOFTLBREQ(i);
        end if;

        if (DstReg = i) then
          DstReqBefMask <= DMACBREQ(i) or SOFTBREQ(i);
        end if;
      when others =>
        SrcReqBefMask <= '0';
        DstReqBefMask <= '0';
    end case;
  end loop;
  if ((DelLLIState = '1') and (LLIBeat >= "011") and (ChEnable = '1') and
      (not ((NotValidDataLLI = '0') and (ErrorMas(LLIAhbMasSel, ErrorMas1,
             ErrorMas2) = '1') and (LLISelReg = '1')))) then
    LLIReq <= '1';
  else
    LLIReq <= '0';
  end if;
end process p_SrcDstReqComb;

-- -----------------------------------------------------------------------------
-- Request masking for Destination:
-- The request are masked out the moment they enter ST_DMA_DST_XFER or
-- ST_PER_DUAL_BUS with DstTxrOn bit set, in the state machine. Since moving
-- into one of valid state indicates the recognition of grant for that
-- particular peripheral we can safely drop down the request. The correction
-- factor is required for the back to back case where source burst is followed
-- by destination burst provided both are on same bus. we cannot have this
-- expression factor for different bus because we cannot predict as to when the
-- transaction will finish on other bus. When LLI loading is happening both
-- source and destination request are masked out.
-- -----------------------------------------------------------------------------
p_DstMaskComb : process (DstErrMask, DMAFIFOLevel, DstBusWidth, ChDisable,
                         ChannelState, iDMACCLR, DstReg, DMACEn, ChEnable,
                         DstSelReg, FlowCntl, DstState, DelDstState,
                         NotValidDataDst, DstAhbMasSel, ErrorMas1, ErrorMas2,
                         SingleBusErr, DualBusErr, SrcErrOccrd)
begin
  DstMask <= '0';
  if (((DMACEn = '1') and (ChEnable = '1')) and (DstErrMask = '0') and
       (not ((iDMACCLR(to_integer(DstReg)) = '1') and
            (not ((FlowCntl = "000") or (FlowCntl = "010") or
                  (FlowCntl = "110"))))) and (ChDisable = '0') and
                               (DelDstState = '0') and (DstSelReg = '0')) then
    if ((DstState = '1') or (SingleBusErr = '1') or (DualBusErr = '1') or
        (SrcErrOccrd = '1') or (ChannelState = ST_LLI_LOAD)) then
      DstMask <= '1';
    elsif ((to_integer(DMAFIFOLevel) / to_integer(DstBusWidth)) > 0) then
      DstMask <= '0';
    else
      DstMask <= '1';
    end if;
  elsif ((DelDstState = '1') and
          (NotValidDataDst = '1') and (ErrorMas(DstAhbMasSel, ErrorMas1,
                                                       ErrorMas2) = '1')) then
    DstMask <= '0';
  else
    DstMask <= '1';
  end if;
end process p_DstMaskComb;

-- -----------------------------------------------------------------------------
-- Request masking for Source:
-- The request are masked out the moment they enter ST_SRC_DMA_XFER or
-- ST_PER_DUAL_BUS with SrcTxrOn bit set, in the state machine. Since moving
-- into one of valid state indicates the recognition of grant for that
-- particular peripheral we can safely drop down the request. The correction
-- factor is required for the back to back case where source burst is followed
-- by destination burst provided both are on same bus. we cannot have this
-- expression factor for different bus because we cannot predict as to when the
-- transaction will finish on other bus. When LLI loading is happening both
-- source and destination request are masked out.
-- -----------------------------------------------------------------------------
p_SrcMaskComb : process (SrcErrMask, ActFifoLevel, SrcBusWidth, ChDisable,
                         ChHalt, DstReqBefMask, FlowCntl, SrcMaskReg, iDMACCLR,
                         SrcReg, ChannelState, SrcMskDstFlow, DMACEn, ChEnable,
                         DstBusWidth, ChControlReg, SrcSelReg, DMAFIFOLevel,
                         DelSrcState, DelChEnable, DelLLIState, SrcState,
                         StopSrc, NotValidDataSrc, SrcAhbMasSel, ErrorMas1,
                         ErrorMas2, SingleBusErr, DualBusErr, DstErrOccrd,
                         Del2LLIState)
variable Temp1 : std_logic_vector(4 downto 0);
begin
  Temp1 := "10000" - DMAFIFOLevel;
  SrcMask <= '0';
  if (((DMACEn = '1') and (ChEnable = '1')) and (SrcErrMask = '0') and
      (not ((iDMACCLR(to_integer(SrcReg)) = '1') and
            (not ((FlowCntl = "000") or (FlowCntl = "001") or
                  (FlowCntl = "101"))))) and (ChDisable = '0') and
      (SrcMaskReg = '0') and (SrcMskDstFlow = '0') and (SrcSelReg = '0') and
      (not ((FlowCntl(2) = '0') and (ChControlReg = "000000000000"))) and
      (DelSrcState = '0') and (ChHalt = '0')) then
    if ((SrcState = '1') or (ChannelState = ST_LLI_LOAD) or
        (DelLLIState = '1') or (SingleBusErr = '1') or (DualBusErr = '1') or
                                                      (DstErrOccrd = '1')) then
      SrcMask <= '1';
    elsif (((FlowCntl = "100") or (FlowCntl = "101")) and
           ((DelChEnable = '0') or (DstReqBefMask = '0') or (Del2LLIState = '1')
                                                     or (StopSrc = '1'))) then
      SrcMask <= '1';
    elsif ((to_integer(Temp1) / to_integer(SrcBusWidth)) > 0) then
      SrcMask <= '0';
    else
      SrcMask <= '1';
    end if;
  elsif ((DelSrcState = '1') and
          (NotValidDataSrc = '1') and (ErrorMas(SrcAhbMasSel, ErrorMas1,
                                                       ErrorMas2) = '1')) then
    SrcMask <= '0';
  else
    SrcMask <= '1';
  end if;
end process p_SrcMaskComb;

-- -----------------------------------------------------------------------------
-- Source Mask generation block when Destination Flow Controller Transfers are
-- happening.
-- -----------------------------------------------------------------------------
p_AllowSrcComb : process (DMAFIFOLevel, Del2DstState, ChEnable, DstBurst,
                          SrcBstDstFlow, DelDstState)
begin
  StopSrc <= '0';
  if (ChEnable = '1') then
    if ((DMAFIFOLevel /= "00000") and (SrcBstDstFlow = ZERO_14)) then
      StopSrc <= '1';
    elsif (((DelDstState = '0') and (Del2DstState = '0')) and
                                                    (DstBurst /= ZERO_14)) then
      StopSrc <= '0';
    elsif (((DelDstState = '1') or (Del2DstState = '1')) and
                                                 (SrcBstDstFlow = ZERO_14)) then
      StopSrc <= '1';
    end if;
  else
    StopSrc <= '1';
  end if;
end process p_AllowSrcComb;

-- -----------------------------------------------------------------------------
-- Source Mask generation block when TC happens on source side
-- -----------------------------------------------------------------------------
p_SrcMaskRegComb : process (SrcMaskReg, SrcReg, iDMACTC, FlowCntl, SourceTC,
                            ChannelState, LLILoad, ChDisable, DstTC,
                            DstTCSrcFlow, SrcLstOccrd, DstLstOccrd,
                            DelDstState, ChEnable, SrcState)
begin
  NextSrcMaskReg <= SrcMaskReg;
  if (ChEnable = '0') then
    NextSrcMaskReg <= '0';
  elsif (iDMACTC(to_integer(SrcReg)) = '1') then
    NextSrcMaskReg <= '1';
  elsif ((not ((FlowCntl = "100") or (FlowCntl = "101"))) and
         (SourceTC = ONE_14) and (SrcState = '1')) then
    NextSrcMaskReg <= '1';
  elsif ((ChannelState = ST_LLI_LOAD) or ((LLILoad = ZERO_30) and
         ((ChDisable = '1') or ((SelTC(FlowCntl, DstTC, DstTCSrcFlow,
         SrcLstOccrd, DstLstOccrd) = ZERO_14) and (DelDstState = '1'))))) then
    NextSrcMaskReg <= '0';
  end if;
end process p_SrcMaskRegComb;

-- -----------------------------------------------------------------------------
-- Source Mask generation block when Destination is flow controller
-- -----------------------------------------------------------------------------
p_MskDstFlowComb : process (SrcStart, FlowCntl, DstReqBefMask, DelDstRqBefMask,
                            SrcBstDstFlow, DelSrcState, ChEnable, DstReg,
                            iDMACCLR)
begin
  NextSrcStart <= SrcStart;
  if (ChEnable = '0') then
    NextSrcStart <= '1';
  elsif ((FlowCntl = "100") or (FlowCntl = "101")) then
    if ((DstReqBefMask = '1') and (DelDstRqBefMask = '0')) then
      NextSrcStart <= '1';
    elsif (((SrcBstDstFlow = ZERO_14) and (DelSrcState = '1')) or
                                     (iDMACCLR(to_integer(DstReg)) = '1')) then
      NextSrcStart <= '0';
    end if;
  else
    NextSrcStart <= '1';
  end if;
end process p_MskDstFlowComb;

SrcMskDstFlow <= (not (NextSrcStart or SrcStart));

-- -----------------------------------------------------------------------------
-- Source Mask generation when we move out of Source Transfer State
-- -----------------------------------------------------------------------------
p_SrcTxrSTComb : process (DelSrcState, SrcState)
begin
  NextDelSrcState <= DelSrcState;
  if (SrcState = '1') then
    NextDelSrcState <= '1';
  else
    NextDelSrcState <= '0';
  end if;
end process p_SrcTxrSTComb;

SrcState <= '1' when ((ChannelState = ST_SRC_DMA_XFER) or
                     ((ChannelState = ST_PER_DUAL_BUS) and (SrcTxrOn = '1')))
         else
            '0';

-- -----------------------------------------------------------------------------
-- Delayed Destination Transfer state for putting mask on SrcReg
-- -----------------------------------------------------------------------------
p_DstTxrSTComb : process (DelDstState, DstState)
begin
  NextDelDstState <= DelDstState;
  if (DstState = '1') then
    NextDelDstState <= '1';
  else
    NextDelDstState <= '0';
  end if;
end process p_DstTxrSTComb;

DstState <= '1' when ((ChannelState = ST_DMA_DST_XFER) or
                     ((ChannelState = ST_PER_DUAL_BUS) and (DstTxrOn = '1')))
         else
            '0';

-- -----------------------------------------------------------------------------
-- Delayed LLILoad Transfer state for putting mask on SrcReg and LLISelect
-- -----------------------------------------------------------------------------
p_LLITxrSTComb : process (DelLLIState, ChannelState)
begin
  NextDelLLIState <= DelLLIState;
  if (ChannelState = ST_LLI_LOAD) then
    NextDelLLIState <= '1';
  else
    NextDelLLIState <= '0';
  end if;
end process p_LLITxrSTComb;

-- -----------------------------------------------------------------------------
-- Source Error Mask generation block
-- -----------------------------------------------------------------------------
p_SrcErrComb : process (SrcErrOccrd, SrcAhbMasSel, ErrorMas1, ErrorMas2,
                        ChEnable, NotValidDataSrc, SrcState)
begin
  NextSrcErrOccrd <= SrcErrOccrd;
  if ((ErrorMas(SrcAhbMasSel, ErrorMas1, ErrorMas2) = '1') and
      (SrcState = '1') and (SrcErrOccrd = '0') and (NotValidDataSrc = '0')) then
    NextSrcErrOccrd <= '1';
  elsif (ChEnable = '0') then
    NextSrcErrOccrd <= '0';
  end if;
end process p_SrcErrComb;

SrcErrMask <= SrcErrOccrd or NextSrcErrOccrd;

-- -----------------------------------------------------------------------------
-- Destination Error Mask generation block
-- -----------------------------------------------------------------------------
p_DstErrComb : process (DstErrOccrd, DstAhbMasSel, ErrorMas1, ErrorMas2,
                        ChEnable, NotValidDataDst, DstState)
begin
  NextDstErrOccrd <= DstErrOccrd;
  if ((ErrorMas(DstAhbMasSel, ErrorMas1, ErrorMas2) = '1') and
      (DstState = '1') and (DstErrOccrd = '0') and (NotValidDataDst = '0')) then
    NextDstErrOccrd <= '1';
  elsif (ChEnable = '0') then
    NextDstErrOccrd <= '0';
  end if;
end process p_DstErrComb;

DstErrMask <= DstErrOccrd or NextDstErrOccrd;

-- -----------------------------------------------------------------------------
-- LLI Error Mask generation block
-- -----------------------------------------------------------------------------
p_LLIErrComb : process (LLIErrOccrd, ChannelState, LLIAhbMasSel, ErrorMas1,
                        ErrorMas2, ChEnable, NotValidDataLLI, LLIReq)
begin
  NextLLIErrOccrd <= LLIErrOccrd;
  if ((ErrorMas(LLIAhbMasSel, ErrorMas1, ErrorMas2) = '1') and
      (ChannelState = ST_LLI_LOAD) and (LLIErrOccrd = '0') and (LLIReq = '0')
                                            and (NotValidDataLLI = '0')) then
    NextLLIErrOccrd <= '1';
  elsif (ChEnable = '0') then
    NextLLIErrOccrd <= '0';
  end if;
end process p_LLIErrComb;

LLIErrMask <= LLIErrOccrd or NextLLIErrOccrd;

-- -----------------------------------------------------------------------------
-- Logic to handle Error Interrupt
-- -----------------------------------------------------------------------------
p_IntErrComb : process (ClrIntErr, iChIntErr, ErrMask, SingleBusErr, DualBusErr,
                        SoftClrPulse)
begin
  NextChIntErr     <= iChIntErr;
  NextSoftClrPulse <= SoftClrPulse;
  if (ClrIntErr = '1') then
    NextChIntErr <= '0';
  elsif (((SingleBusErr = '1') or (DualBusErr = '1')) and
                                                         (iChIntErr = '0')) then
    NextChIntErr <= ErrMask;
  end if;

  if (ClrIntErr = '1') then
    NextSoftClrPulse <= '0';
  elsif (((SingleBusErr = '1') or (DualBusErr = '1')) and
                                (SoftClrPulse = '0') and (iChIntErr = '0')) then
    NextSoftClrPulse <= '1';
  else
    NextSoftClrPulse <= '0';
  end if;
end process p_IntErrComb;

-- -----------------------------------------------------------------------------
-- Logic to handle TC Interrupt
-- -----------------------------------------------------------------------------
p_IntTCComb : process (ClrIntTC, ChIntReg, IntMask, iDMACTC, DstReg, FlowCntl,
                       DelDstState, DstTC, SrcErrOccrd, DstErrOccrd, DMACTCP2M)
begin
  NextChIntReg <= ChIntReg;
  if ((ClrIntTC = '1') or (SrcErrOccrd = '1') or (DstErrOccrd = '1')) then
    NextChIntReg <= '0';
  elsif (ChIntReg = '0') then
    if (IntMask = '1') then
      case FlowCntl is
        when "000" | "010" =>
          if ((DelDstState = '1') and (DstTC = ZERO_14)) then
            NextChIntReg <= '1';
          else
            NextChIntReg <= '0';
          end if;
        when "110" =>
          if ((DMACTCP2M = '1') and (ChIntReg = '0')) then
            NextChIntReg <= '1';
          else
            NextChIntReg <= '0';
          end if;
        when "001" | "011" | "100" | "101" | "111" =>
          NextChIntReg <= iDMACTC(to_integer(DstReg));
        when others =>
          null;
      end case;
    else
      NextChIntReg <= '0';
    end if;
  end if;
end process p_IntTCComb;

ChIntTC      <= ChIntReg;

DstReqCh     <= DstReqBefMask and (not DstMask);
SrcReqCh     <= SrcReqBefMask and (not SrcMask);
ReqConcat    <= (SrcReqCh & DstReqCh & LLIReq);

-- -----------------------------------------------------------------------------
-- Logic to generate channel request line combinationally
-- Depending on the peripheral request ie source, destination or LLI loading
-- the request lines are routed to the corresponding Arbiter. The Combinational
-- grant lines are generated based on the internal arbiter grant. These grant
-- signals are active for only one clock period.
-- -----------------------------------------------------------------------------
p_ChReqComb : process (ChEnable, ReqConcat, DstAhbMasSel, SrcAhbMasSel, SameBus,
                       DstReqCh, SrcReqCh, LLIAhbMasSel, ChComb1, ChComb2,
                       DiffBus, DMACEn)
begin
  ChReqArb1       <= '0';
  ChReqArb2       <= '0';
  DstSelComb      <= '0';
  SrcSelComb      <= '0';
  LLISelComb      <= '0';
  if ((ChEnable = '1') and (DMACEn = '1')) then
    case ReqConcat is
      when "000" =>
        ChReqArb1    <= '0';
        ChReqArb2    <= '0';
        DstSelComb   <= '0';
        SrcSelComb   <= '0';
        LLISelComb   <= '0';

      when "010" =>
        ChReqArb1   <= not DstAhbMasSel;
        ChReqArb2   <= DstAhbMasSel;
        DstSelComb  <= SelComb(DstAhbMasSel, ChComb1, ChComb2);

      when "100" =>
        ChReqArb1   <= not SrcAhbMasSel;
        ChReqArb2   <= SrcAhbMasSel;
        SrcSelComb  <= SelComb(SrcAhbMasSel, ChComb1, ChComb2);

      when "110" =>
        if (SameBus = '1') then
          if (DstReqCh = '1') then
            ChReqArb1   <= not DstAhbMasSel;
            ChReqArb2   <= DstAhbMasSel;
            DstSelComb  <= SelComb(DstAhbMasSel, ChComb1, ChComb2);
          elsif (SrcReqCh = '1') then
            ChReqArb1   <= not SrcAhbMasSel;
            ChReqArb2   <= SrcAhbMasSel;
            SrcSelComb  <= SelComb(SrcAhbMasSel, ChComb1, ChComb2);
          end if;
        end if;
        if (DiffBus = '1') then
          if (DstReqCh = '1') then
            if (DstAhbMasSel = '0') then
              ChReqArb1 <= '1';
            else
              ChReqArb2 <= '1';
            end if;
            DstSelComb  <= SelComb(DstAhbMasSel, ChComb1, ChComb2);
          end if;
          if (SrcReqCh = '1') then
            if (SrcAhbMasSel = '0') then
              ChReqArb1 <= '1';
            else
              ChReqArb2 <= '1';
            end if;
            SrcSelComb  <= SelComb(SrcAhbMasSel, ChComb1, ChComb2);
          end if;
        end if;

      when "001" =>
        ChReqArb1   <= not LLIAhbMasSel;
        ChReqArb2   <= LLIAhbMasSel;
        LLISelComb  <= SelComb(LLIAhbMasSel, ChComb1, ChComb2);

      when others =>
        null;
    end case;
  end if;
end process p_ChReqComb;

-- -----------------------------------------------------------------------------
-- Generation of NotValid Signals for Source
-- -----------------------------------------------------------------------------
p_NotValidSrcComb : process (NotValidSrcST, SrcSelComb, SrcAhbMasSel, MREADY1,
                             MREADY2, ChannelState, SrcTxrOn, ChEnable,
                             SrcErrOccrd)
begin
  NextSrcNotState <= NotValidSrcST;
  if ((ChEnable = '1') and (ChannelState /= ST_LLI_LOAD) and
                                                      (SrcErrOccrd = '0')) then
    case NotValidSrcST is
      when ST_NOTVALIDSRC_IDLE =>
        if ((SrcSelComb = '1') and
                            (MREADY(SrcAhbMasSel, MREADY1, MREADY2) = '1')) then
          NextSrcNotState <= ST_NOTVALIDSRC_2MREADY;
        elsif ((SrcSelComb = '1') and
                            (MREADY(SrcAhbMasSel, MREADY1, MREADY2) = '0')) then
          NextSrcNotState <= ST_NOTVALIDSRC_1MREADY;
        end if;
      when ST_NOTVALIDSRC_1MREADY =>
        if ((ChannelState = ST_IDLE) or ((ChannelState = ST_PER_DUAL_BUS) and
                                                         (SrcTxrOn = '0'))) then
          NextSrcNotState <= ST_NOTVALIDSRC_IDLE;
        elsif (MREADY(SrcAhbMasSel, MREADY1, MREADY2) = '1') then
          NextSrcNotState <= ST_NOTVALIDSRC_2MREADY;
        end if;
      when ST_NOTVALIDSRC_2MREADY =>
        if ((ChannelState = ST_IDLE) or ((ChannelState = ST_PER_DUAL_BUS) and
                                                         (SrcTxrOn = '0'))) then
          NextSrcNotState <= ST_NOTVALIDSRC_IDLE;
        elsif (MREADY(SrcAhbMasSel, MREADY1, MREADY2) = '1') then
          NextSrcNotState <= ST_NOTVALIDSRC_IDLE;
        end if;
      when others =>
        null;
    end case;
  else
    NextSrcNotState <= ST_NOTVALIDSRC_IDLE;
  end if;
end process p_NotValidSrcComb;

NotValidDataSrc <= '1' when (NotValidSrcST /= ST_NOTVALIDSRC_IDLE)
                else
                   '0';

-- -----------------------------------------------------------------------------
-- Generation of NotValid Signals for Destination
-- -----------------------------------------------------------------------------
p_NotValidDstComb : process (NotValidDstST, DstSelComb, DstAhbMasSel, MREADY1,
                             MREADY2, ChannelState, DstTxrOn, DstErrOccrd,
                             ChEnable)
begin
  NextDstNotState <= NotValidDstST;
  if ((ChEnable = '1') and (ChannelState /= ST_LLI_LOAD) and
                                                      (DstErrOccrd = '0')) then
    case NotValidDstST is
      when ST_NOTVALIDDST_IDLE =>
        if ((DstSelComb = '1') and
                            (MREADY(DstAhbMasSel, MREADY1, MREADY2) = '1')) then
          NextDstNotState <= ST_NOTVALIDDST_2MREADY;
        elsif ((DstSelComb = '1') and
                            (MREADY(DstAhbMasSel, MREADY1, MREADY2) = '0')) then
          NextDstNotState <= ST_NOTVALIDDST_1MREADY;
        end if;
      when ST_NOTVALIDDST_1MREADY =>
        if ((ChannelState = ST_IDLE) or ((ChannelState = ST_PER_DUAL_BUS) and
                                                         (DstTxrOn = '0'))) then
          NextDstNotState <= ST_NOTVALIDDST_IDLE;
        elsif (MREADY(DstAhbMasSel, MREADY1, MREADY2) = '1') then
          NextDstNotState <= ST_NOTVALIDDST_2MREADY;
        end if;
      when ST_NOTVALIDDST_2MREADY =>
        if ((ChannelState = ST_IDLE) or ((ChannelState = ST_PER_DUAL_BUS) and
                                                         (DstTxrOn = '0'))) then
          NextDstNotState <= ST_NOTVALIDDST_IDLE;
        elsif (MREADY(DstAhbMasSel, MREADY1, MREADY2) = '1') then
          NextDstNotState <= ST_NOTVALIDDST_IDLE;
        end if;
      when others =>
        null;
    end case;
  else
    NextDstNotState <= ST_NOTVALIDDST_IDLE;
  end if;
end process p_NotValidDstComb;

NotValidDataDst <= '1' when (NotValidDstST /= ST_NOTVALIDDST_IDLE)
                else
                   '0';

-- -----------------------------------------------------------------------------
-- Generation of NotValid Signals for LLI
-- -----------------------------------------------------------------------------
p_NotValidLLIComb : process (NotValidLLIST, LLISelComb, LLIAhbMasSel, MREADY1,
                             MREADY2, ChannelState, ChEnable)
begin
  NextLLINotState <= NotValidLLIST;
  if (ChEnable = '1') then
    case NotValidLLIST is
      when ST_NOTVALIDLLI_IDLE =>
        if ((LLISelComb = '1') and
                            (MREADY(LLIAhbMasSel, MREADY1, MREADY2) = '1')) then
          NextLLINotState <= ST_NOTVALIDLLI_2MREADY;
        elsif ((LLISelComb = '1') and
                            (MREADY(LLIAhbMasSel, MREADY1, MREADY2) = '0')) then
          NextLLINotState <= ST_NOTVALIDLLI_1MREADY;
        end if;
      when ST_NOTVALIDLLI_1MREADY =>
        if (ChannelState = ST_IDLE) then
          NextLLINotState <= ST_NOTVALIDLLI_IDLE;
        elsif (MREADY(LLIAhbMasSel, MREADY1, MREADY2) = '1') then
          NextLLINotState <= ST_NOTVALIDLLI_2MREADY;
        end if;
      when ST_NOTVALIDLLI_2MREADY =>
        if (ChannelState = ST_IDLE) then
          NextLLINotState <= ST_NOTVALIDLLI_IDLE;
        elsif (MREADY(LLIAhbMasSel, MREADY1, MREADY2) = '1') then
          NextLLINotState <= ST_NOTVALIDLLI_IDLE;
        end if;
      when others =>
        null;
    end case;
  else
    NextLLINotState <= ST_NOTVALIDLLI_IDLE;
  end if;
end process p_NotValidLLIComb;

NotValidDataLLI <= '1' when (NotValidLLIST /= ST_NOTVALIDLLI_IDLE)
                else
                   '0';

SrcBurstChNxt <= SrcBurstCal(FlowCntl, NextSrcBurst, NxtSrcBstDstFlow,
                             NextSourceTC);
SrcBurstCh    <= SrcBurstCal(FlowCntl, SrcBurst, SrcBstDstFlow, SourceTC);
DstBurstChNxt <= DstBurstCal(FlowCntl, NextDstBurst, NxtDstBstSrcFlow,
                             NextDstTC);
DstBurstCh    <= DstBurstCal(FlowCntl, DstBurst, DstBstSrcFlow, DstTC);

-- -----------------------------------------------------------------------------
-- The Channel State machine has following states
-- ST_IDLE:
--   In this state the SM waits for the source request to be granted or the
--   destination request to be granted from the arbiter. For the arbiter it is
--   the channel request which comes as an input. The grant the SM receives is
--   for 1HCLK. From this state the SM makes a transition to ST_SRC_DMA_XFER
--   state if the peripherals are on same bus or else it will make a transition
--   to ST_PER_DUAL_BUS. SM makes a transition to ST_DMA_DST_XFER state if
--   destination request is sampled asserted and the peripherals are on same
--   bus or else it will move to ST_PER_DUAL_BUS. when making the transition
--   either the SourceBeat or the DstBeat counters are loaded. It is this count
--   that the AHB is supposed to carry out.
--
-- ST_SRC_DMA_XFER:
--   In this state SM does source fetching. The Data from source peripheral is
--   put into FIFO. There cannot be a source transactions followed by another
--   source transactions hence the SrcMask becomes active when in this state.
--   The SM makes a transition to ST_DMA_DST_XFER state if the destination
--   request is active. The DataValid's are interpreted properly by generating
--   NotValidData signal. If the destination request is not sampled asserted
--   then SM will move to ST_IDLE.
--
-- ST_DMA_DST_XFER:
--   In this state data is drained out of the FIFO, to the destinational
--   peripheral. There cannot be a destination transactions followed by another
--   destination transactions hence the DstMask becomes active when in this
--   state. The SM can switch to ST_LLI_LOAD state if the LLILoad is not null
--   and DstTC counter has expired. SM makes a transition to ST_SRC_DMA_XFER
--   state if the source grant is sampled asserted. transition takes place at
--   the end of the dataphase for the last destination beat committed. If there
--   is no LLILoad and no Source Grant then the SM will move to ST_IDLE state.
--
-- ST_PER_DUAL_BUS:
--   In this state both source fetching and draining of data happens. A
--   separate signal SrcTxrOn indicates that source transfer is going on and
--   DstTxrOn indicates that destination transfer is going on. In this dual bus
--   operation is happening so there is no forecasting of fifo levels to fetch
--   the data or for draining the data. The SM makes a transition from this
--   state only after DstTC counter expires. transition can happen to
--   ST_LLI_LOAD or ST_IDLE state depending upon LLILoad value being not null.
--
-- ST_LLI_LOAD:
--   In this state LLILoading takes place. Here a transfer of 4 words is
--   intimated to the AhbMaster module depending on the location where LLI is
--   located. From this state SM makes a transition to ST_IDLE state.
-- -----------------------------------------------------------------------------
p_ChSMComb : process (ChannelState, SrcBeat, DstBeat, SrcSelComb, SameBus,
                      SrcLoadComb, DstSelComb, DstLoadComb, DiffBus, FlowCntl,
                      SrcAhbMasSel, SrcDisAckOccrd, SrcErrMask, DstSelReg,
                      DstAhbMasSel, DstDisAckOccrd, DstErrMask, SrcSelReg,
                      SrcTxrOn, DstTxrOn, LLIAhbMasSel, LLIBeat, TwoBitCnt,
                      SrcBusWidth, SrcBurstChNxt, DMAFIFOLevel, SrcBurstCh,
                      DstBusWidth, DstBurstChNxt, DstBurstCh, DstTC,
                      DstTCSrcFlow, SrcLstOccrd, DstLstOccrd, ErrorMas1,
                      ErrorMas2, LLILoad, ActFifoLevel, AddrPhase, DstBeatCopy,
                      SrcMaskReg, PredictFactor, NotValidDataDst,
                      NotValidDataSrc, NotValidDataLLI, LLISelReg, LLISelComb,
                      DstErrOccrd, ValidDataSrc, LLIReq, ValidDataDst,
                      ValidDataLLI, LLIDisAckOccrd, LLISelReg)
begin
  NextSrcBeat      <= SrcBeat;
  NextChState      <= ChannelState;
  NextDstBeat      <= DstBeat;
  NextDstSelReg    <= DstSelReg;
  NextSrcSelReg    <= SrcSelReg;
  NextLLISelReg    <= LLISelReg;
  NextLLIBeat      <= LLIBeat;
  NextDstTxrOn     <= DstTxrOn;
  NextSrcTxrOn     <= SrcTxrOn;
  NextTwoBitCnt    <= TwoBitCnt;
  case ChannelState is
    when ST_IDLE =>
      if ((SrcSelComb = '1') and (SameBus = '1') and
                   (ErrorMas(SrcAhbMasSel, ErrorMas1, ErrorMas2) = '0')) then
        NextChState <= ST_SRC_DMA_XFER;
        if (SrcLoadComb = '1') then
          NextSrcBeat <= SrcBeatCount(SrcBusWidth, DstBusWidth, DstBeatCopy,
                                      SrcBurstChNxt, DMAFIFOLevel, ActFifoLevel,
                                      ChannelState, AddrPhase, SameBus);
        else
          NextSrcBeat <= SrcBeatCount(SrcBusWidth, DstBusWidth, DstBeatCopy,
                                      SrcBurstCh, DMAFIFOLevel, ActFifoLevel,
                                      ChannelState, AddrPhase, SameBus);
        end if;
      end if;

      if ((DstSelComb = '1') and (SameBus = '1') and
                   (ErrorMas(DstAhbMasSel, ErrorMas1, ErrorMas2) = '0')) then
        NextChState <= ST_DMA_DST_XFER;
        if (DstLoadComb = '1') then
          NextDstBeat <= DstBeatCount(DstBusWidth, SrcBusWidth, PredictFactor,
                                      DstBurstChNxt, DMAFIFOLevel);
        else
          NextDstBeat <= DstBeatCount(DstBusWidth, SrcBusWidth, PredictFactor,
                                      DstBurstCh, DMAFIFOLevel);
        end if;
      end if;

      if (((SrcSelComb = '1') or (DstSelComb = '1')) and (DiffBus = '1')) then
        NextChState  <= ST_PER_DUAL_BUS;
        if (ErrorMas(SrcAhbMasSel, ErrorMas1, ErrorMas2) = '0') then
          NextSrcTxrOn <= SrcSelComb;
          if (SrcLoadComb = '1') then
            NextSrcBeat <= SrcBeatCount(SrcBusWidth, DstBusWidth, DstBeatCopy,
                                      SrcBurstChNxt, DMAFIFOLevel, ActFifoLevel,
                                        ChannelState, AddrPhase, SameBus);
          else
            NextSrcBeat <= SrcBeatCount(SrcBusWidth, DstBusWidth, DstBeatCopy,
                                        SrcBurstCh, DMAFIFOLevel, ActFifoLevel,
                                        ChannelState, AddrPhase, SameBus);
          end if;
        end if;
        if (ErrorMas(DstAhbMasSel, ErrorMas1, ErrorMas2) = '0') then
          NextDstTxrOn <= DstSelComb;
          if (DstLoadComb = '1') then
            NextDstBeat <= DstBeatCount(DstBusWidth, SrcBusWidth, PredictFactor,
                                        DstBurstChNxt, DMAFIFOLevel);
          else
            NextDstBeat <= DstBeatCount(DstBusWidth, SrcBusWidth, PredictFactor,
                                        DstBurstCh, DMAFIFOLevel);
          end if;
        end if;
      end if;

    when ST_SRC_DMA_XFER =>
      if (DstSelComb = '1') then
        NextDstSelReg <= DstSelComb;
        if (DstLoadComb = '1') then
          NextDstBeat <= DstBeatCount(DstBusWidth, SrcBusWidth, PredictFactor,
                                      DstBurstChNxt, DMAFIFOLevel);
        else
          NextDstBeat <= DstBeatCount(DstBusWidth, SrcBusWidth, PredictFactor,
                                      DstBurstCh, DMAFIFOLevel);
        end if;
      end if;

      if ((SrcDisAckOccrd = '0') and (SrcErrMask = '0') and
          (not ((NotValidDataSrc = '1') and (ErrorMas(SrcAhbMasSel, ErrorMas1,
                                                       ErrorMas2) = '1')))) then
        if ((SrcBeat = "00001") and (ValidDataSrc = '1') and
                                                   (NotValidDataSrc = '0')) then
          NextSrcBeat <= (others => '0');
          if ((DstSelReg = '1') or (DstSelComb = '1')) then
            NextDstSelReg  <= '0';
            NextChState    <= ST_DMA_DST_XFER;
          else
            NextChState <= ST_IDLE;
            NextDstBeat <= (others => '0');
          end if;
        elsif ((ValidDataSrc = '1') and (NotValidDataSrc = '0')) then
          NextSrcBeat <= SrcBeat - '1';
        end if;
      else
        NextChState    <= ST_IDLE;
        NextSrcBeat    <= (others => '0');
        NextDstSelReg  <= '0';
        NextDstBeat    <= (others => '0');
      end if;

    when ST_DMA_DST_XFER =>
      if (SrcSelComb = '1') then
        NextSrcSelReg <= SrcSelComb;
        if (SrcLoadComb = '1') then
          NextSrcBeat <= SrcBeatCount(SrcBusWidth, DstBusWidth, DstBeatCopy,
                                      SrcBurstChNxt, DMAFIFOLevel, ActFifoLevel,
                                      ChannelState, AddrPhase, SameBus);
        else
          NextSrcBeat <= SrcBeatCount(SrcBusWidth, DstBusWidth, DstBeatCopy,
                                      SrcBurstCh, DMAFIFOLevel, ActFifoLevel,
                                      ChannelState, AddrPhase, SameBus);
        end if;
      end if;

      if ((DstDisAckOccrd = '0') and (DstErrMask = '0') and
          (not ((NotValidDataDst = '1') and (ErrorMas(DstAhbMasSel, ErrorMas1,
                                                       ErrorMas2) = '1')))) then
        if (DstBeat /= "00001") then
          if ((ValidDataDst = '1') and (NotValidDataDst = '0')) then
            NextDstBeat <= DstBeat - '1';
          end if;
        elsif ((ValidDataDst = '1') and (NotValidDataDst = '0')) then
          NextDstBeat <= (others => '0');
          if (((SelTC(FlowCntl, DstTC, DstTCSrcFlow, SrcLstOccrd, DstLstOccrd)
              = ONE_14) or ((SrcMaskReg = '1') and (ActFifoLevel = "00000") and
              (DMAFIFOLevel = "00000") and (FlowCntl(2 downto 1) = "11"))) and
                                                     (LLILoad /= ZERO_30)) then
            NextChState <= ST_LLI_LOAD;
            NextLLIBeat <= "100";
            NextSrcBeat <= (others => '0');
          elsif (((SelTC(FlowCntl, DstTC, DstTCSrcFlow, SrcLstOccrd,
                  DstLstOccrd) = ONE_14) or ((SrcMaskReg = '1') and
                 (DMAFIFOLevel = "00000") and (ActFifoLevel = "00000") and
                 (FlowCntl(2 downto 1) = "11"))) and (LLILoad = ZERO_30)) then
            NextSrcBeat <= (others => '0');
            NextChState <= ST_IDLE;
            NextSrcSelReg <= '0';
          elsif ((DstBeat = "00001") and ((SrcSelReg = '1') or
                                                      (SrcSelComb = '1'))) then
            NextSrcSelReg <= '0';
            NextChState   <= ST_SRC_DMA_XFER;
          else
            NextChState <= ST_IDLE;
            NextSrcBeat <= (others => '0');
            NextSrcSelReg <= '0';
          end if;
        end if;
      else
        NextChState   <= ST_IDLE;
        NextDstBeat   <= (others => '0');
        NextSrcSelReg <= '0';
        NextSrcBeat   <= (others => '0');
      end if;

    when ST_PER_DUAL_BUS =>
      if ((DstSelComb = '1') or (DstTxrOn = '1')) then
        NextDstTxrOn <= '1';
        if (DstSelComb = '1') then
          if (DstLoadComb = '1') then
            NextDstBeat <= DstBeatCount(DstBusWidth, SrcBusWidth, PredictFactor,
                                        DstBurstChNxt, DMAFIFOLevel);
          else
            NextDstBeat <= DstBeatCount(DstBusWidth, SrcBusWidth, PredictFactor,
                                        DstBurstCh, DMAFIFOLevel);
          end if;
        elsif ((DstDisAckOccrd = '0') and (DstErrMask = '0') and
          (not ((NotValidDataDst = '1') and (ErrorMas(DstAhbMasSel, ErrorMas1,
                                                       ErrorMas2) = '1')))) then
          if (DstBeat /= "00001") then
            if ((ValidDataDst = '1') and (NotValidDataDst = '0')) then
              NextDstBeat <= DstBeat - '1';
            end if;
          elsif ((ValidDataDst = '1') and (NotValidDataDst = '0')) then
            NextDstBeat <= (others => '0');
            if (((SelTC(FlowCntl, DstTC, DstTCSrcFlow, SrcLstOccrd,
                 DstLstOccrd) = ONE_14) or ((SrcMaskReg = '1') and
                 (DMAFIFOLevel = "00000") and (ActFifoLevel = "00000") and
                 (FlowCntl(2 downto 1) = "11"))) and (LLILoad /= ZERO_30) and
                                                          (SrcTxrOn = '0')) then
              NextChState  <= ST_LLI_LOAD;
              NextLLIBeat  <= "100";
              NextDstTxrOn <= '0';
              NextDstBeat  <= (others => '0');
            elsif (((SelTC(FlowCntl, DstTC, DstTCSrcFlow, SrcLstOccrd,
                    DstLstOccrd) = ONE_14) or ((SrcMaskReg = '1') and
                    (DMAFIFOLevel = "00000") and (ActFifoLevel = "00000") and
                    (FlowCntl(2 downto 1) = "11"))) and (LLILoad = ZERO_30) and
                                                          (SrcTxrOn = '0')) then
              NextChState  <= ST_IDLE;
              NextDstTxrOn <= '0';
              NextDstBeat  <= (others => '0');
            elsif (DstBeat = "00001") then
              NextDstTxrOn <= '0';
              NextDstBeat  <= (others => '0');
            end if;
          end if;
        elsif ((SrcTxrOn = '0') and (SrcSelComb = '0')) then
          NextChState  <= ST_IDLE;
          NextDstBeat  <= (others => '0');
          NextDstTxrOn <= '0';
        else
          NextDstBeat  <= (others => '0');
          NextDstTxrOn <= '0';
        end if;
      elsif ((SrcTxrOn = '0') and (SrcSelComb = '0') and
                                                       (DstErrOccrd = '1')) then
        NextChState  <= ST_IDLE;
        NextDstBeat  <= (others => '0');
        NextDstTxrOn <= '0';
      end if;

      if ((SrcSelComb = '1') or (SrcTxrOn = '1')) then
        NextSrcTxrOn <= '1';
        if (SrcSelComb = '1') then
          if (SrcLoadComb = '1') then
            NextSrcBeat <= SrcBeatCount(SrcBusWidth, DstBusWidth, DstBeatCopy,
                                        SrcBurstChNxt, DMAFIFOLevel,
                                        ActFifoLevel, ChannelState,
                                        AddrPhase, SameBus);
          else
            NextSrcBeat <= SrcBeatCount(SrcBusWidth, DstBusWidth, DstBeatCopy,
                                        SrcBurstCh, DMAFIFOLevel, ActFifoLevel,
                                        ChannelState, AddrPhase, SameBus);
          end if;
        elsif ((SrcDisAckOccrd = '0') and (SrcErrMask = '0') and
          (not ((NotValidDataSrc = '1') and (ErrorMas(SrcAhbMasSel, ErrorMas1,
                                                       ErrorMas2) = '1')))) then
          if ((SrcBeat = "00001") and (ValidDataSrc = '1') and
                                                   (NotValidDataSrc = '0')) then
            NextSrcBeat  <= (others => '0');
            NextSrcTxrOn <= '0';
          elsif ((ValidDataSrc = '1') and (NotValidDataSrc = '0')) then
            NextSrcBeat <= SrcBeat - '1';
          end if;
        else
          NextSrcBeat  <= (others => '0');
          NextSrcTxrOn <= '0';
        end if;
      end if;

    when ST_LLI_LOAD =>
      if (LLISelComb = '1') then
        NextLLISelReg <= '1';
      end if;

      if ((LLIDisAckOccrd = '0') and (not ((NotValidDataLLI = '0') and
          (LLIReq = '0') and (ErrorMas(LLIAhbMasSel, ErrorMas1, ErrorMas2)
                                       = '1') and (LLISelReg = '1')))) then
        if ((LLIBeat = "00001") and (ValidDataLLI = '1') and
                                                   (NotValidDataLLI = '0')) then
          NextLLIBeat   <= (others => '0');
          NextChState <= ST_IDLE;
          NextLLISelReg <= '0';
        elsif ((ValidDataLLI = '1') and (NotValidDataLLI = '0') and
                                                         (LLISelReg = '1')) then
          NextLLIBeat <= LLIBeat - '1';
        end if;

        if ((ValidDataLLI = '1') and (NotValidDataLLI = '0') and
                                                         (LLISelReg = '1')) then
          NextTwoBitCnt <= TwoBitCnt + '1';
        end if;
      else
        NextChState   <= ST_IDLE;
        NextLLIBeat   <= (others => '0');
        NextTwoBitCnt <= (others => '0');
        NextLLISelReg <= '0';
      end if;

    when others =>
      null;
  end case;
end process p_ChSMComb;

-- -----------------------------------------------------------------------------
-- DMACCLR and DMACTC are generated here because it is set in One state of the
-- State machine and gets cleared in another state. so it is better to control
-- it from a separate always block. Here care has been taken care to select the
-- right Burst or TC counters depending on the Flow Controller.
-- -----------------------------------------------------------------------------
p_ClrTCComb : process (FlowCntl, SrcReg, DstReg, DstReqBefMask, DstTC, iDMACTC,
                       iDMACCLR, DstBurst, SrcReqBefMask, SourceTC, SrcBurst,
                       DstLstSrc, SrcTCDstFlow, SrcBstDstFlow, DstLstOccrd,
                       SrcLstOccrd, DstBstSrcFlow, DstFlowReq, SrcMaskReg,
                       DMAFIFOLevel, ActFifoLevel, DelSrcState, NotValidDataDst,
                       NotValidDataSrc, DMACTCP2M, DstBeat, SrcErrOccrd,
                       DstErrOccrd, ClrIntTC, IntMask, SrcState, DstState,
                       ValidDataDst, ValidDataSrc)
begin
  NextDMACCLR <= iDMACCLR;
  NextDMACTC  <= iDMACTC;
  NextDMACTCP2M  <= DMACTCP2M;
  case FlowCntl is
    when "000" =>
      NextDMACCLR(to_integer(SrcReg)) <= '0';
      NextDMACTC(to_integer(SrcReg))  <= '0';
      NextDMACTC(to_integer(DstReg))  <= '0';
      NextDMACCLR(to_integer(DstReg)) <= '0';

    when "001" =>
      if (DstReqBefMask = '0') then
        NextDMACTC(to_integer(DstReg))  <= '0';
        NextDMACCLR(to_integer(DstReg)) <= '0';
      elsif ((DstTC = ONE_14) and (ValidDataDst = '1') and
                                                  (NotValidDataDst = '0')) then
        if ((iDMACTC(to_integer(DstReg)) = '0') and
             (iDMACCLR(to_integer(DstReg)) = '0') and (DstState = '1')) then
          NextDMACTC(to_integer(DstReg))  <= '1';
          NextDMACCLR(to_integer(DstReg)) <= '1';
        end if;
      elsif ((DstBurst = ONE_14) and (ValidDataDst = '1') and
                                                  (NotValidDataDst = '0')) then
        if ((iDMACCLR(to_integer(DstReg)) = '0') and (DstState = '1')) then
          NextDMACCLR(to_integer(DstReg)) <= '1';
        end if;
      end if;

    when "010" =>
      if (SrcReqBefMask = '0') then
        NextDMACTC(to_integer(SrcReg))  <= '0';
        NextDMACCLR(to_integer(SrcReg)) <= '0';
      elsif ((SourceTC = ONE_14) and (ValidDataSrc = '1') and
                                                  (NotValidDataSrc = '0')) then
        if ((iDMACTC(to_integer(SrcReg)) = '0') and
             (iDMACCLR(to_integer(SrcReg)) = '0') and (SrcState = '1')) then
          NextDMACTC(to_integer(SrcReg))  <= '1';
          NextDMACCLR(to_integer(SrcReg)) <= '1';
        end if;
      elsif ((SrcBurst = ONE_14) and (ValidDataSrc = '1') and
                                                  (NotValidDataSrc = '0')) then
        if ((iDMACCLR(to_integer(SrcReg)) = '0') and (SrcState = '1')) then
          NextDMACCLR(to_integer(SrcReg)) <= '1';
        end if;
      end if;

    when "011" =>
      if (SrcReqBefMask = '0') then
        NextDMACTC(to_integer(SrcReg))  <= '0';
        NextDMACCLR(to_integer(SrcReg)) <= '0';
      elsif ((SourceTC = ONE_14) and (ValidDataSrc = '1') and
                                                   (NotValidDataSrc = '0')) then
        if ((iDMACTC(to_integer(SrcReg)) = '0') and
             (iDMACCLR(to_integer(SrcReg)) = '0') and (SrcState = '1')) then
          NextDMACTC(to_integer(SrcReg))  <= '1';
          NextDMACCLR(to_integer(SrcReg)) <= '1';
        end if;
      elsif ((SrcBurst = ONE_14) and (ValidDataSrc = '1') and
                                                  (NotValidDataSrc = '0')) then
        if ((iDMACCLR(to_integer(SrcReg)) = '0') and (SrcState = '1')) then
          NextDMACCLR(to_integer(SrcReg)) <= '1';
        end if;
      end if;

      if (DstReqBefMask = '0') then
        NextDMACTC(to_integer(DstReg))  <= '0';
        NextDMACCLR(to_integer(DstReg)) <= '0';
      elsif ((DstTC = ONE_14) and (ValidDataDst = '1') and
                                                  (NotValidDataDst = '0')) then
        if ((iDMACTC(to_integer(DstReg)) = '0') and
             (iDMACCLR(to_integer(DstReg)) = '0') and (DstState = '1')) then
          NextDMACTC(to_integer(DstReg))  <= '1';
          NextDMACCLR(to_integer(DstReg)) <= '1';
        end if;
      elsif ((DstBurst = ONE_14) and (ValidDataDst = '1') and
                                                  (NotValidDataDst = '0')) then
        if ((iDMACCLR(to_integer(DstReg)) = '0') and (DstState = '1')) then
          NextDMACCLR(to_integer(DstReg)) <= '1';
        end if;
      end if;

    when "100" =>
      if (SrcReqBefMask = '0') then
        NextDMACTC(to_integer(SrcReg))  <= '0';
        NextDMACCLR(to_integer(SrcReg)) <= '0';
      elsif ((DstLstSrc = '1') and (SrcTCDstFlow = ONE_14) and
                          (ValidDataSrc = '1') and (NotValidDataSrc = '0')) then
        if ((iDMACTC(to_integer(SrcReg)) = '0') and
             (iDMACCLR(to_integer(SrcReg)) = '0') and (SrcState = '1')) then
          NextDMACTC(to_integer(SrcReg))  <= '1';
          NextDMACCLR(to_integer(SrcReg)) <= '1';
        end if;
      elsif (((SrcBurst = ONE_14) or (SrcBstDstFlow = ONE_14)) and
                          (ValidDataSrc = '1') and (NotValidDataSrc = '0')) then
        if ((iDMACCLR(to_integer(SrcReg)) = '0') and (SrcState = '1')) then
          NextDMACCLR(to_integer(SrcReg)) <= '1';
        end if;
      end if;

      if (DstFlowReq = '0') then
        NextDMACTC(to_integer(DstReg))  <= '0';
        NextDMACCLR(to_integer(DstReg)) <= '0';
      elsif (((DstLstOccrd = '1') and (DstTC = ONE_14)) and
                          (ValidDataDst = '1') and (NotValidDataDst = '0')) then
        if ((iDMACTC(to_integer(DstReg)) = '0') and
             (iDMACCLR(to_integer(DstReg)) = '0') and (DstState = '1')) then
          NextDMACTC(to_integer(DstReg))  <= '1';
          NextDMACCLR(to_integer(DstReg)) <= '1';
        end if;
      elsif ((DstBurst = ONE_14) and (ValidDataDst = '1') and
                                                  (NotValidDataDst = '0')) then
        if ((iDMACCLR(to_integer(DstReg)) = '0') and (DstState = '1')) then
          NextDMACCLR(to_integer(DstReg)) <= '1';
        end if;
      end if;

    when "101" =>
      if (DstFlowReq = '0') then
        NextDMACTC(to_integer(DstReg))  <= '0';
        NextDMACCLR(to_integer(DstReg)) <= '0';
      elsif ((DstLstOccrd = '1') and (DstTC = ONE_14) and
                          (ValidDataDst = '1') and (NotValidDataDst = '0')) then
        if ((iDMACTC(to_integer(DstReg)) = '0') and
            (iDMACCLR(to_integer(DstReg)) = '0') and (DstState = '1')) then
          NextDMACTC(to_integer(DstReg))  <= '1';
          NextDMACCLR(to_integer(DstReg)) <= '1';
        end if;
      elsif ((DstBurst = ONE_14) and (ValidDataDst = '1') and
                                                   (NotValidDataDst = '0')) then
        if ((iDMACCLR(to_integer(DstReg)) = '0') and (DstState = '1')) then
          NextDMACCLR(to_integer(DstReg)) <= '1';
        end if;
      end if;

    when "110" =>
      if (SrcReqBefMask = '0') then
        NextDMACTC(to_integer(SrcReg))  <= '0';
        NextDMACCLR(to_integer(SrcReg)) <= '0';
      elsif ((SrcLstOccrd = '1') and (SourceTC = ONE_14) and
                         (ValidDataSrc = '1') and (NotValidDataSrc = '0')) then
        if ((iDMACTC(to_integer(SrcReg)) = '0') and
             (iDMACCLR(to_integer(SrcReg)) = '0') and (SrcState = '1')) then
          NextDMACTC(to_integer(SrcReg))  <= '1';
          NextDMACCLR(to_integer(SrcReg)) <= '1';
        end if;
      elsif ((SrcBurst = ONE_14) and (ValidDataSrc = '1') and
                                                  (NotValidDataSrc = '0')) then
        if ((iDMACCLR(to_integer(SrcReg)) = '0') and (SrcState = '1')) then
          NextDMACCLR(to_integer(SrcReg)) <= '1';
        end if;
      end if;

      if (((ClrIntTC = '1') or (SrcErrOccrd = '1') or (DstErrOccrd = '1')) and
           (IntMask = '1')) then
        NextDMACTCP2M  <= '0';
      elsif ((SrcLstOccrd = '1') and (DMAFIFOLevel = "00000") and
             (ActFifoLevel = "00000") and (SrcMaskReg = '1') and
             (DelSrcState = '0') and (ValidDataDst = '1') and
                                                   (NotValidDataDst = '0')) then
        if ((DMACTCP2M = '0') and (DstBeat = "00001") and (DstState = '1')) then
          NextDMACTCP2M <= '1';
        end if;
      end if;

    when "111" =>
      if (SrcReqBefMask = '0') then
        NextDMACTC(to_integer(SrcReg))  <= '0';
        NextDMACCLR(to_integer(SrcReg)) <= '0';
      elsif ((SrcLstOccrd = '1') and (SourceTC = ONE_14) and
                          (ValidDataSrc = '1') and (NotValidDataSrc = '0')) then
        if (((iDMACTC(to_integer(SrcReg)) = '0') and
             (iDMACCLR(to_integer(SrcReg)) = '0')) and (SrcState = '1')) then
          NextDMACTC(to_integer(SrcReg))  <= '1';
          NextDMACCLR(to_integer(SrcReg)) <= '1';
        end if;
      elsif ((SrcBurst = ONE_14) and (ValidDataSrc = '1') and
                                                   (NotValidDataSrc = '0')) then
        if ((iDMACCLR(to_integer(SrcReg)) = '0') and (SrcState = '1')) then
          NextDMACCLR(to_integer(SrcReg)) <= '1';
        end if;
      end if;

      if (DstReqBefMask = '0') then
        NextDMACTC(to_integer(DstReg))  <= '0';
        NextDMACCLR(to_integer(DstReg)) <= '0';
      elsif ((SrcLstOccrd = '1') and (DMAFIFOLevel = "00000") and
             (ActFifoLevel = "00000") and (SrcMaskReg = '1') and
             (DelSrcState = '0') and (ValidDataDst = '1') and
                          (DstBeat = "00001") and (NotValidDataDst = '0')) then
        if ((iDMACTC(to_integer(DstReg)) = '0') and
             (iDMACCLR(to_integer(DstReg)) = '0') and (DstState = '1')) then
          NextDMACTC(to_integer(DstReg))  <= '1';
          NextDMACCLR(to_integer(DstReg)) <= '1';
        end if;
      elsif (((DstBstSrcFlow = ONE_14) or (DstBurst = ONE_14)) and
                         (ValidDataDst = '1') and (NotValidDataDst = '0')) then
        if ((iDMACCLR(to_integer(DstReg)) = '0') and (DstState = '1')) then
          NextDMACCLR(to_integer(DstReg)) <= '1';
        end if;
      end if;

    when others =>
      null;
  end case;
end process p_ClrTCComb;

-- -----------------------------------------------------------------------------
-- ORed version of Source Burst Request including SoftReq
-- -----------------------------------------------------------------------------
BstRqSrc     <= DMACBREQ(to_integer(SrcReg)) or
                SOFTBREQ(to_integer(SrcReg));

-- -----------------------------------------------------------------------------
-- ORed version of Source Single Request including SoftReq
-- -----------------------------------------------------------------------------
SglRqSrc     <= DMACSREQ(to_integer(SrcReg)) or
                SOFTSREQ(to_integer(SrcReg));

-- -----------------------------------------------------------------------------
-- ORed version of Destination Burst Request including SoftReq
-- -----------------------------------------------------------------------------
BstRqDst     <= DMACBREQ(to_integer(DstReg)) or
                SOFTBREQ(to_integer(DstReg));

-- -----------------------------------------------------------------------------
-- ORed version of Destination Single Request including SoftReq
-- -----------------------------------------------------------------------------
SglRqDst     <= DMACSREQ(to_integer(DstReg)) or
                SOFTSREQ(to_integer(DstReg));

-- -----------------------------------------------------------------------------
-- ORed version of Destination Burst/Last Burst Request including SoftReq
-- -----------------------------------------------------------------------------
BstRqDstAll  <= DMACBREQ(to_integer(DstReg)) or
                DMACLBREQ(to_integer(DstReg)) or
                SOFTBREQ(to_integer(DstReg)) or
                SOFTLBREQ(to_integer(DstReg));

-- -----------------------------------------------------------------------------
-- ORed version of Destination Single/Last Single Request including SoftReq
-- -----------------------------------------------------------------------------
SglRqDstAll  <= SOFTSREQ(to_integer(DstReg)) or
                SOFTLSREQ(to_integer(DstReg)) or
                DMACSREQ(to_integer(DstReg)) or
                DMACLSREQ(to_integer(DstReg));

-- -----------------------------------------------------------------------------
-- ORed version of Source Burst/Last Burst Request including SoftReq
-- -----------------------------------------------------------------------------
BstRqSrcAll  <= DMACBREQ(to_integer(SrcReg)) or
                DMACLBREQ(to_integer(SrcReg)) or
                SOFTBREQ(to_integer(SrcReg)) or
                SOFTLBREQ(to_integer(SrcReg));

-- -----------------------------------------------------------------------------
-- ORed version of Source Single/Last Single Request including SoftReq
-- -----------------------------------------------------------------------------
SglRqSrcAll  <= SOFTSREQ(to_integer(SrcReg)) or
                SOFTLSREQ(to_integer(SrcReg)) or
                DMACSREQ(to_integer(SrcReg)) or
                DMACLSREQ(to_integer(SrcReg));

-- -----------------------------------------------------------------------------
-- Logic to Load Burst Count and Transfer Count for Source and Destination
-- peripheral. Also this block decrements the Count based on Datavalid's rxd.
-- The counters are loaded based on the flow controller and also corresponding
-- SrcSelComb or DstSelComb is required. Both the source and destination
-- counters can be loaded simultaneously. Hence it is written in the same
-- process as there is dependency on other counters.
-- -----------------------------------------------------------------------------
p_DmaClrCntComb : process (SrcSelComb, FlowCntl, SrcBurst, SourceTC, DstLstSrc,
                           SrcBstDstFlow, FactorOnDstNum, FactorOnDstDen,
                           DMACLBREQ, DMACLSREQ, SOFTLBREQ, SOFTLSREQ, DstReg,
                           SrcReg, ChannelState, SrcTCDstFlow, DstSelComb,
                           DstBurst, DstTC, ChControlReg, FactorOnSrcNum,
                           FactorOnSrcDen, SrcLstOccrd, DstBstSrcFlow, ChEnable,
                           DstTCSrcFlow, SrcBurstSize, ZERO_1, ONE_1, SglRqSrc,
                           BstRqSrc, BstRqDst, BstRqDstAll, SglRqDstAll,
                           BstRqSrcAll, SglRqSrcAll, NotValidDataDst, DstState,
                           NotValidDataSrc, DstBurstSize, DstLstSrcReg,
                           SrcLstOccrdReg, DstLstOccrdReg, ActFifoLevel,
                           DMAFIFOLevel, DstBusWidth, SrcBusWidth, SrcMaskReg,
                           DelSrcState, PredictFactor, DstBeat, SrcState,
                           ValidDataSrc, ValidDataDst)
variable Temp1 : std_logic_vector(14 downto 0);
variable Temp2 : std_logic_vector(14 downto 0);
variable Temp3 : std_logic_vector(16 downto 0);
variable Temp4 : std_logic_vector(5 downto 0);
variable Temp5 : std_logic_vector(13 downto 0);
begin
  NextSrcBurst      <= SrcBurst;
  NextDstBurst      <= DstBurst;
  NextSourceTC      <= SourceTC;
  NextDstTC         <= DstTC;
  NxtSrcBstDstFlow  <= SrcBstDstFlow;
  NxtSrcTCDstFlow   <= SrcTCDstFlow;
  NextDstLstSrc     <= DstLstSrcReg;
  NextSrcLstOccrd   <= SrcLstOccrdReg;
  NextDstLstOccrd   <= DstLstOccrdReg;
  NxtDstBstSrcFlow  <= DstBstSrcFlow;
  NxtDstTCSrcFlow   <= DstTCSrcFlow;
  SrcLoadComb       <= '0';
  DstLoadComb       <= '0';
  if ((SrcSelComb = '1') and (ChEnable = '1')) then
    case FlowCntl is
      when "000" =>
        if (SrcBurst = ZERO_14) then
          NextSrcBurst <= BurstSize(SrcBurstSize, ZERO_1, ZERO_1, ONE_1);
          SrcLoadComb  <= '1';
        end if;
        if (SourceTC = ZERO_14) then
          NextSourceTC <= ("00" & ChControlReg(11 downto 0));
        end if;

      when "001" =>
        if (SrcBurst = ZERO_14) then
          NextSrcBurst <= BurstSize(SrcBurstSize, ZERO_1, ZERO_1, ONE_1);
          SrcLoadComb  <= '1';
        end if;
        if (SourceTC = ZERO_14) then
          NextSourceTC <= ("00" & ChControlReg(11 downto 0));
        end if;

      when "010" =>
        if (SrcBurst = ZERO_14) then
          NextSrcBurst <= BurstSize(SrcBurstSize, SglRqSrc, BstRqSrc, ZERO_1);
          SrcLoadComb  <= '1';
        end if;
        if (SourceTC = ZERO_14) then
          NextSourceTC <= ("00" & ChControlReg(11 downto 0));
        end if;

      when "011" =>
        if (SrcBurst = ZERO_14) then
          NextSrcBurst <= BurstSize(SrcBurstSize, SglRqSrc, BstRqSrc, ZERO_1);
          SrcLoadComb  <= '1';
        end if;
        if (SourceTC = ZERO_14) then
          NextSourceTC <= ("00" & ChControlReg(11 downto 0));
        end if;

      when "100" =>
        if (SrcBstDstFlow = ZERO_14) then
          Temp3 := BurstSize(DstBurstSize, SglRqDstAll, BstRqDstAll, ZERO_1) *
                                                                 FactorOnDstNum;
          Temp1 := (to_integer(Temp3) / to_integer(FactorOnDstDen)
                                                           + "000000000000000");
          if (Temp1 = "000000000000000") then
            Temp1 := Temp1 + 1;
          end if;
          NxtSrcBstDstFlow <= Temp1(13 downto 0);
          SrcLoadComb      <= '1';
        end if;

        if (SrcBurst = ZERO_14) then
          SrcLoadComb  <= '1';
          if (Temp1(13 downto 0) > BurstSize(SrcBurstSize, SglRqSrc, BstRqSrc,
                                                                  ZERO_1)) then
            NextSrcBurst <= BurstSize(SrcBurstSize, SglRqSrc, BstRqSrc, ZERO_1);
          else
            NextSrcBurst <= Temp1(13 downto 0);
          end if;
        end if;

        if (SrcTCDstFlow = ZERO_14) then
          if ((DMACLBREQ(to_integer(DstReg)) or DMACLSREQ(to_integer(DstReg)) or
               SOFTLBREQ(to_integer(DstReg)) or
                                      SOFTLSREQ(to_integer(DstReg))) = '1') then
            Temp3 := BurstSize(DstBurstSize, SglRqDstAll, BstRqDstAll, ZERO_1) *
                                                                 FactorOnDstNum;
            Temp1 := (to_integer(Temp3) / to_integer(FactorOnDstDen)
                                                           + "000000000000000");
            if (Temp1 = "000000000000000") then
              Temp1 := Temp1 + 1;
            end if;
            NxtSrcTCDstFlow <= Temp1(13 downto 0);
            NextDstLstSrc   <= '1';
          end if;
        end if;

      when "101" =>
        if (SrcBstDstFlow = ZERO_14) then
          Temp3 := BurstSize(DstBurstSize, SglRqDstAll, BstRqDstAll, ZERO_1) *
                                                                 FactorOnDstNum;
          Temp1 := (to_integer(Temp3) / to_integer(FactorOnDstDen)
                                                           + "000000000000000");
          if (Temp1 = "000000000000000") then
            Temp1 := Temp1 + 1;
          end if;
          NxtSrcBstDstFlow <= Temp1(13 downto 0);
          SrcLoadComb      <= '1';
        end if;

        if (SrcBurst = ZERO_14) then
          SrcLoadComb  <= '1';
          if (Temp1(13 downto 0) > BurstSize(SrcBurstSize, ZERO_1, ZERO_1,
                                                                  ONE_1)) then
            NextSrcBurst <= BurstSize(SrcBurstSize, ZERO_1, ZERO_1, ONE_1);
          else
            NextSrcBurst <= Temp1(13 downto 0);
          end if;
        end if;

        if (SrcTCDstFlow = ZERO_14) then
          if ((DMACLBREQ(to_integer(DstReg)) or DMACLSREQ(to_integer(DstReg)) or
               SOFTLBREQ(to_integer(DstReg)) or
                                      SOFTLSREQ(to_integer(DstReg))) = '1') then
            Temp3 := BurstSize(DstBurstSize, SglRqDstAll, BstRqDstAll, ZERO_1) *
                                                                 FactorOnDstNum;
            Temp1 := (to_integer(Temp3) / to_integer(FactorOnDstDen)
                                                           + "000000000000000");
            if (Temp1 = "000000000000000") then
              Temp1 := Temp1 + 1;
            end if;
            NxtSrcTCDstFlow <= Temp1(13 downto 0);
            NextDstLstSrc   <= '1';
          end if;
        end if;

      when "110" =>
        if (SrcBurst = ZERO_14) then
          NextSrcBurst <= BurstSize(SrcBurstSize, SglRqSrcAll, BstRqSrcAll,
                                    ZERO_1);
          SrcLoadComb  <= '1';
        end if;

        if (SourceTC = ZERO_14) then
          if ((DMACLBREQ(to_integer(SrcReg)) or DMACLSREQ(to_integer(SrcReg)) or
               SOFTLBREQ(to_integer(SrcReg)) or
                                      SOFTLSREQ(to_integer(SrcReg))) = '1') then
            NextSourceTC    <= BurstSize(SrcBurstSize, SglRqSrcAll, BstRqSrcAll,
                                         ZERO_1);
            NextSrcLstOccrd <= '1';
          end if;
        end if;

      when "111" =>
        if (SrcBurst = ZERO_14) then
          NextSrcBurst <= BurstSize(SrcBurstSize, SglRqSrcAll, BstRqSrcAll,
                                    ZERO_1);
          SrcLoadComb  <= '1';
        end if;

        if (SourceTC = ZERO_14) then
          if ((DMACLBREQ(to_integer(SrcReg)) or DMACLSREQ(to_integer(SrcReg)) or
               SOFTLBREQ(to_integer(SrcReg)) or
                                      SOFTLSREQ(to_integer(SrcReg))) = '1') then
            NextSourceTC    <= BurstSize(SrcBurstSize, SglRqSrcAll, BstRqSrcAll,
                                         ZERO_1);
            NextSrcLstOccrd <= '1';
          end if;
        end if;

      when others =>
        null;
    end case;
  elsif ((ChEnable = '1') and (ChannelState /= ST_LLI_LOAD)) then
    if ((SrcState = '1') and (ValidDataSrc = '1') and
                                                   (NotValidDataSrc = '0')) then
      if (SrcBurst > ZERO_14) then
        NextSrcBurst <= SrcBurst - '1';
      end if;
      if (SourceTC > ZERO_14) then
        NextSourceTC <= SourceTC - '1';
      end if;
      if ((FlowCntl = "100") or (FlowCntl = "101")) then
        NxtSrcBstDstFlow <= SrcBstDstFlow - '1';
        if ((DstLstSrc = '1') and (SrcTCDstFlow > ZERO_14)) then
          NxtSrcTCDstFlow <= SrcTCDstFlow - '1';
        end if;
        if (SrcTCDstFlow <= ONE_14) then
          NextDstLstSrc <= '0';
        end if;
      end if;
    end if;
  else
    NextSrcBurst      <= (others => '0');
    NextSourceTC      <= (others => '0');
    NxtSrcBstDstFlow  <= (others => '0');
    NxtSrcTCDstFlow   <= (others => '0');
    NextDstLstSrc     <= '0';
  end if;

-- -----------------------------------------------------------------------------
-- Destination clear loading
-- -----------------------------------------------------------------------------
  if ((DstSelComb = '1') and (ChEnable = '1')) then
    DstLoadComb <= '0';
    case FlowCntl is
      when "000" =>
        if (DstBurst = ZERO_14) then
          NextDstBurst <= BurstSize(DstBurstSize, ZERO_1, ZERO_1, ONE_1);
          DstLoadComb <= '1';
        end if;
        if (DstTC = ZERO_14) then
          Temp2 := (ChControlReg(11 downto 0) * FactorOnSrcNum);
          Temp1 := (to_integer(Temp2) / to_integer(FactorOnSrcDen)
                                                           + "000000000000000");
          NextDstTC <= Temp1(13 downto 0);
        end if;

      when "001" =>
        if (DstBurst = ZERO_14) then
          NextDstBurst <= BurstSize(DstBurstSize, ZERO_1, BstRqDst, ZERO_1);
          DstLoadComb  <= '1';
        end if;
        if (DstTC = ZERO_14) then
          Temp2 := (ChControlReg(11 downto 0) * FactorOnSrcNum);
          Temp1 := (to_integer(Temp2) / to_integer(FactorOnSrcDen)
                                                           + "000000000000000");
          NextDstTC <= Temp1(13 downto 0);
        end if;

      when "010" =>
        if (DstBurst = ZERO_14) then
          NextDstBurst <= BurstSize(DstBurstSize, ZERO_1, ZERO_1, ONE_1);
          DstLoadComb  <= '1';
        end if;
        if (DstTC = ZERO_14) then
          Temp2 := (ChControlReg(11 downto 0) * FactorOnSrcNum);
          Temp1 := (to_integer(Temp2) / to_integer(FactorOnSrcDen)
                                                           + "000000000000000");
          NextDstTC <= Temp1(13 downto 0);
        end if;

      when "011" =>
        if (DstBurst = ZERO_14) then
          NextDstBurst <= BurstSize(DstBurstSize, ZERO_1, BstRqDst, ZERO_1);
          DstLoadComb  <= '1';
        end if;
        if (DstTC = ZERO_14) then
          Temp2 := (ChControlReg(11 downto 0) * FactorOnSrcNum);
          Temp1 := (to_integer(Temp2) / to_integer(FactorOnSrcDen)
                                                           + "000000000000000");
          NextDstTC <= Temp1(13 downto 0);
        end if;

      when "100" =>
        if (DstBurst = ZERO_14) then
          NextDstBurst <= BurstSize(DstBurstSize, SglRqDstAll, BstRqDstAll,
                                    ZERO_1);
          DstLoadComb  <= '1';
        end if;

        if (DstTC = ZERO_14) then
          if ((DMACLBREQ(to_integer(DstReg)) or DMACLSREQ(to_integer(DstReg)) or
               SOFTLBREQ(to_integer(DstReg)) or
                                      SOFTLSREQ(to_integer(DstReg))) = '1') then
            NextDstTC       <= BurstSize(DstBurstSize, SglRqDstAll, BstRqDstAll,
                                         ZERO_1);
            NextDstLstOccrd <= '1';
          end if;
        end if;

      when "101" =>
        if (DstBurst = ZERO_14) then
          NextDstBurst <= BurstSize(DstBurstSize, SglRqDstAll, BstRqDstAll,
                                    ZERO_1);
          DstLoadComb  <= '1';
        end if;

        if (DstTC = ZERO_14) then
          if ((DMACLBREQ(to_integer(DstReg)) or DMACLSREQ(to_integer(DstReg)) or
               SOFTLBREQ(to_integer(DstReg)) or
                                      SOFTLSREQ(to_integer(DstReg))) = '1') then
            NextDstTC       <= BurstSize(DstBurstSize, SglRqDstAll, BstRqDstAll,
                                         ZERO_1);
            NextDstLstOccrd <= '1';
          end if;
        end if;

      when "110" =>
          DstLoadComb  <= '1';
          NextDstBurst <= BurstSize(DstBurstSize, ZERO_1, ZERO_1, ONE_1);
          Temp5 := BurstSize(DstBurstSize, ZERO_1, ZERO_1, ONE_1);

        if (DstBstSrcFlow = ZERO_14) then
          Temp4 := ('0' & (DMAFIFOLevel + (PredictFactor * SrcBusWidth)));
          Temp2 := to_integer(Temp4) / to_integer(DstBusWidth) +
                                                             "000000000000000";
          if (Temp5(13 downto 0) >= Temp2(13 downto 0)) then
            NxtDstBstSrcFlow <= Temp2(13 downto 0);
            DstLoadComb      <= '1';
          else
            NxtDstBstSrcFlow <= Temp5(13 downto 0);
            DstLoadComb      <= '1';
          end if;
        end if;


      when "111" =>
          DstLoadComb  <= '1';
          NextDstBurst <= BurstSize(DstBurstSize, ZERO_1, ZERO_1, ONE_1);
          Temp5 := BurstSize(DstBurstSize, ZERO_1, ZERO_1, ONE_1);


        if (DstBstSrcFlow = ZERO_14) then
          Temp4 := ('0' & (DMAFIFOLevel + (PredictFactor * SrcBusWidth)));
          Temp2 := to_integer(Temp4) / to_integer(DstBusWidth) +
                                                             "000000000000000";
          if (Temp5(13 downto 0) >= Temp2(13 downto 0)) then
            NxtDstBstSrcFlow <= Temp2(13 downto 0);
            DstLoadComb      <= '1';
          else
            NxtDstBstSrcFlow <= Temp5(13 downto 0);
            DstLoadComb      <= '1';
          end if;
        end if;

      when others =>
        null;
    end case;
  elsif ((ChEnable = '1') and (ChannelState /= ST_LLI_LOAD)) then
    if ((DstState = '1') and (ValidDataDst = '1') and (NotValidDataDst = '0'))
                                                                            then
      if (DstBurst > ZERO_14) then
        NextDstBurst <= DstBurst - '1';
      end if;
      if (DstTC > ZERO_14) then
        NextDstTC <= DstTC - '1';
      else
        NextDstLstOccrd <= '0';
      end if;
      if ((FlowCntl = "110") or (FlowCntl = "111")) then
        NxtDstBstSrcFlow <= DstBstSrcFlow - '1';
        if ((SrcMaskReg = '1') and (SrcLstOccrd = '1') and
            (DMAFIFOLevel = "00000") and (ActFifoLevel = "00000") and
                              (DelSrcState = '0') and (DstBeat = "00001")) then
          NextSrcLstOccrd <= '0';
        end if;
      end if;
    end if;
  else
    NextDstBurst      <= (others => '0');
    NextDstTC         <= (others => '0');
    NextDstLstOccrd   <= '0';
    NextSrcLstOccrd   <= '0';
    NxtDstBstSrcFlow  <= (others => '0');
    NxtDstTCSrcFlow   <= (others => '0');
  end if;
end process p_DmaClrCntComb;


DstLstSrc   <= NextDstLstSrc or DstLstSrcReg;
SrcLstOccrd <= NextSrcLstOccrd or SrcLstOccrdReg;
DstLstOccrd <= NextDstLstOccrd or DstLstOccrdReg;

-- -----------------------------------------------------------------------------
-- Channel Disable Info on Bus1
-- -----------------------------------------------------------------------------
ChDisableBus1 <= SrcDisable when (SrcAhbMasSel = '0')
              else
                 DstDisable when (DstAhbMasSel = '0')
              else
                 LLIDisable when (LLIAhbMasSel = '0')
              else
                 '0';

-- -----------------------------------------------------------------------------
-- Channel Disable Info on Bus2
-- -----------------------------------------------------------------------------
ChDisableBus2 <= SrcDisable when (SrcAhbMasSel = '1')
              else
                 DstDisable when (DstAhbMasSel = '1')
              else
                 LLIDisable when (LLIAhbMasSel = '1')
              else
                 '0';

-- -----------------------------------------------------------------------------
-- Logic to load the AHB Count and channel resources to the AHB Master interface
-- -----------------------------------------------------------------------------
p_AhbLoadComb : process (SrcAhbMasSel, SrcSelComb, ChSrcAddrReg, ChControlReg,
                         ChConfigReg, SrcIncrBit, DstAhbMasSel, DstSelComb,
                         ChDstAddrReg, DstWidth, DstIncrBit, LLIAhbMasSel,
                         LLISelComb, LLILoad, NextDstBeat, NextSrcBeat,
                         SrcWidth)
begin
  ChAddrBus1    <= (others => '0');
  ChHProtBus1   <= (others => '0');
  ChBeatCntBus1 <= (others => '0');
  ChHLockBus1   <= '0';
  ChAddrIncr1   <= '0';
  ChHSIZEBus1   <= (others => '0');
  ChWRITEBus1   <= '0';
  ChAddrBus2    <= (others => '0');
  ChHProtBus2   <= (others => '0');
  ChBeatCntBus2 <= (others => '0');
  ChHLockBus2   <= '0';
  ChAddrIncr2   <= '0';
  ChHSIZEBus2   <= (others => '0');
  ChWRITEBus2   <= '0';
  if ((SrcAhbMasSel = '0') and (SrcSelComb = '1')) then
    ChBeatCntBus1 <= NextSrcBeat;
    ChAddrBus1    <= ChSrcAddrReg;
    ChHProtBus1   <= (ChControlReg(30 downto 28) & '1');
    ChHLockBus1   <= ChConfigReg(16);
    ChAddrIncr1   <= SrcIncrBit;
    ChHSIZEBus1   <= SrcWidth;
    ChWRITEBus1   <= '0';
  end if;
  if ((SrcAhbMasSel = '1') and (SrcSelComb = '1')) then
    ChBeatCntBus2 <= NextSrcBeat;
    ChAddrBus2    <= ChSrcAddrReg;
    ChHProtBus2   <= (ChControlReg(30 downto 28) & '1');
    ChHLockBus2   <= ChConfigReg(16);
    ChAddrIncr2   <= SrcIncrBit;
    ChHSIZEBus2   <= SrcWidth;
    ChWRITEBus2   <= '0';
  end if;
  if ((DstAhbMasSel = '0') and (DstSelComb = '1')) then
    ChBeatCntBus1 <= NextDstBeat;
    ChAddrBus1    <= ChDstAddrReg;
    ChHProtBus1   <= (ChControlReg(30 downto 28) & '1');
    ChHLockBus1   <= ChConfigReg(16);
    ChAddrIncr1   <= DstIncrBit;
    ChHSIZEBus1   <= DstWidth;
    ChWRITEBus1   <= '1';
  end if;
  if ((DstAhbMasSel = '1') and (DstSelComb = '1')) then
    ChBeatCntBus2 <= NextDstBeat;
    ChAddrBus2    <= ChDstAddrReg;
    ChHProtBus2   <= (ChControlReg(30 downto 28) & '1');
    ChHLockBus2   <= ChConfigReg(16);
    ChAddrIncr2   <= DstIncrBit;
    ChHSIZEBus2   <= DstWidth;
    ChWRITEBus2   <= '1';
  end if;
  if ((LLIAhbMasSel = '0') and (LLISelComb = '1')) then
    ChBeatCntBus1 <= "00100";
    ChAddrBus1    <= (LLILoad & "00");
    ChHProtBus1   <= "1011";
    ChHLockBus1   <= '0';
    ChAddrIncr1   <= '1';
    ChHSIZEBus1   <= "010";
    ChWRITEBus1   <= '0';
  end if;
  if ((LLIAhbMasSel = '1') and (LLISelComb = '1')) then
    ChBeatCntBus2 <= "00100";
    ChAddrBus2    <= (LLILoad & "00");
    ChHProtBus2   <= "1011";
    ChHLockBus2   <= '0';
    ChAddrIncr2   <= '1';
    ChHSIZEBus2   <= "010";
    ChWRITEBus2   <= '0';
  end if;
end process p_AhbLoadComb;

-- -----------------------------------------------------------------------------
-- Fifo Packing Logic i.e. when we are taking data from source peripheral. Here
-- SM needs to be in a state where source transfer is happening. Appropriate
-- byte lanes are selected based on endianness and also on the Address Offset.
-- -----------------------------------------------------------------------------
p_PackComb : process (ChannelState, SrcWidth, AddrOffSetSrc, SrcAhbMasSel,
                      HRDATAM1, HRDATAM2, WrPtr, SrcDisAckOccrd, SrcErrMask,
                      FifoReg, NotValidDataSrc, MasterEndian1, ChEnable,
                      MasterEndian2, SrcState, ValidDataSrc)
begin
  NextFifoReg <= FifoReg;
  NextWrPtr   <= WrPtr;
  if ((SrcState = '1') and (ChEnable = '1')) then
    case SrcWidth is
      when "000" =>
        if ((MasterEndian(SrcAhbMasSel, MasterEndian1, MasterEndian2) = '0') and
             (ValidDataSrc = '1') and (NotValidDataSrc = '0')) then
          if (AddrOffSetSrc = "00") then
            if (SrcAhbMasSel = '0') then
              NextFifoReg(to_integer(WrPtr)) <= HRDATAM1(7 downto 0);
            else
              NextFifoReg(to_integer(WrPtr)) <= HRDATAM2(7 downto 0);
            end if;
          elsif (AddrOffSetSrc = "01") then
            if (SrcAhbMasSel = '0') then
              NextFifoReg(to_integer(WrPtr)) <= HRDATAM1(15 downto 8);
            else
              NextFifoReg(to_integer(WrPtr)) <= HRDATAM2(15 downto 8);
            end if;
          elsif (AddrOffSetSrc = "10") then
            if (SrcAhbMasSel = '0') then
              NextFifoReg(to_integer(WrPtr)) <= HRDATAM1(23 downto 16);
            else
              NextFifoReg(to_integer(WrPtr)) <= HRDATAM2(23 downto 16);
            end if;
          elsif (AddrOffSetSrc = "11") then
            if (SrcAhbMasSel = '0') then
              NextFifoReg(to_integer(WrPtr)) <= HRDATAM1(31 downto 24);
            else
              NextFifoReg(to_integer(WrPtr)) <= HRDATAM2(31 downto 24);
            end if;
          end if;
          if ((SrcDisAckOccrd = '0') and (SrcErrMask = '0')) then
            NextWrPtr <= WrPtr + '1';
          else
            NextWrPtr <= "0000";
          end if;
        elsif ((MasterEndian(SrcAhbMasSel, MasterEndian1, MasterEndian2) = '1')
                     and (ValidDataSrc = '1') and (NotValidDataSrc = '0')) then
          if (AddrOffSetSrc = "00") then
            if (SrcAhbMasSel = '0') then
              NextFifoReg(to_integer(WrPtr)) <= HRDATAM1(31 downto 24);
            else
              NextFifoReg(to_integer(WrPtr)) <= HRDATAM2(31 downto 24);
            end if;
          elsif (AddrOffSetSrc = "01") then
            if (SrcAhbMasSel = '0') then
              NextFifoReg(to_integer(WrPtr)) <= HRDATAM1(23 downto 16);
            else
              NextFifoReg(to_integer(WrPtr)) <= HRDATAM1(23 downto 16);
            end if;
          elsif (AddrOffSetSrc = "10") then
            if (SrcAhbMasSel = '0') then
              NextFifoReg(to_integer(WrPtr)) <= HRDATAM1(15 downto 8);
            else
              NextFifoReg(to_integer(WrPtr)) <= HRDATAM2(15 downto 8);
            end if;
          elsif (AddrOffSetSrc = "11") then
            if (SrcAhbMasSel = '0') then
              NextFifoReg(to_integer(WrPtr)) <= HRDATAM1(7 downto 0);
            else
              NextFifoReg(to_integer(WrPtr)) <= HRDATAM2(7 downto 0);
            end if;
          end if;
          if ((SrcDisAckOccrd = '0') and (SrcErrMask = '0')) then
            NextWrPtr <= WrPtr + '1';
          else
            NextWrPtr <= "0000";
          end if;
        end if;

      when "001" =>
        if ((MasterEndian(SrcAhbMasSel, MasterEndian1, MasterEndian2) = '0') and
                          (ValidDataSrc = '1') and (NotValidDataSrc = '0')) then
          if (AddrOffSetSrc = "00") then
            if (SrcAhbMasSel = '0') then
              NextFifoReg(to_integer(WrPtr))       <= HRDATAM1(7 downto 0);
              NextFifoReg((to_integer(WrPtr)) + 1) <= HRDATAM1(15 downto 8);
            else
              NextFifoReg(to_integer(WrPtr))       <= HRDATAM2(7 downto 0);
              NextFifoReg((to_integer(WrPtr)) + 1) <= HRDATAM2(15 downto 8);
            end if;
          elsif (AddrOffSetSrc = "10") then
            if (SrcAhbMasSel = '0') then
              NextFifoReg(to_integer(WrPtr))       <= HRDATAM1(23 downto 16);
              NextFifoReg((to_integer(WrPtr)) + 1) <= HRDATAM1(31 downto 24);
            else
              NextFifoReg(to_integer(WrPtr))       <= HRDATAM2(23 downto 16);
              NextFifoReg((to_integer(WrPtr)) + 1) <= HRDATAM2(31 downto 24);
            end if;
          end if;
          if ((SrcDisAckOccrd = '0') or (SrcErrMask = '0')) then
            NextWrPtr <= WrPtr + "10";
          else
            NextWrPtr <= "0000";
          end if;
        elsif ((MasterEndian(SrcAhbMasSel, MasterEndian1, MasterEndian2) = '1')
                     and (ValidDataSrc = '1') and (NotValidDataSrc = '0')) then
          if (AddrOffSetSrc = "00") then
            if (SrcAhbMasSel = '0') then
              NextFifoReg(to_integer(WrPtr))       <= HRDATAM1(23 downto 16);
              NextFifoReg((to_integer(WrPtr)) + 1) <= HRDATAM1(31 downto 24);
            else
              NextFifoReg(to_integer(WrPtr))       <= HRDATAM2(23 downto 16);
              NextFifoReg((to_integer(WrPtr)) + 1) <= HRDATAM2(31 downto 24);
            end if;
          elsif (AddrOffSetSrc = "10") then
            if (SrcAhbMasSel = '0') then
              NextFifoReg(to_integer(WrPtr))       <= HRDATAM1(7 downto 0);
              NextFifoReg((to_integer(WrPtr)) + 1) <= HRDATAM1(15 downto 8);
            else
              NextFifoReg(to_integer(WrPtr))       <= HRDATAM2(7 downto 0);
              NextFifoReg((to_integer(WrPtr)) + 1) <= HRDATAM2(15 downto 8);
            end if;
          end if;
          if ((SrcDisAckOccrd = '0') and (SrcErrMask = '0')) then
            NextWrPtr <= WrPtr + "10";
          else
            NextWrPtr <= "0000";
          end if;
        end if;

      when "010" =>
        if ((ValidDataSrc = '1') and (NotValidDataSrc = '0')) then
          if (SrcAhbMasSel = '0') then
            NextFifoReg(to_integer(WrPtr))     <= HRDATAM1(7 downto 0);
          else
            NextFifoReg(to_integer(WrPtr))     <= HRDATAM2(7 downto 0);
          end if;
          if (SrcAhbMasSel = '0') then
            NextFifoReg((to_integer(WrPtr)) + 1) <= HRDATAM1(15 downto 8);
          else
            NextFifoReg((to_integer(WrPtr)) + 1) <= HRDATAM2(15 downto 8);
          end if;
          if (SrcAhbMasSel = '0') then
            NextFifoReg((to_integer(WrPtr)) + 2) <= HRDATAM1(23 downto 16);
          else
            NextFifoReg((to_integer(WrPtr)) + 2) <= HRDATAM2(23 downto 16);
          end if;
          if (SrcAhbMasSel = '0') then
            NextFifoReg((to_integer(WrPtr)) + 3) <= HRDATAM1(31 downto 24);
          else
            NextFifoReg((to_integer(WrPtr)) + 3) <= HRDATAM2(31 downto 24);
          end if;
          if ((SrcDisAckOccrd = '0') and (SrcErrMask = '0')) then
            NextWrptr <= Wrptr + "100";
          else
            NextWrPtr <= "0000";
          end if;
        end if;
      when others =>
        null;
    end case;
  elsif ((ChEnable = '0') or (ChannelState = ST_LLI_LOAD)) then
    NextWrPtr <= "0000";
  end if;
end process p_PackComb;

-- -----------------------------------------------------------------------------
-- This block is responsible for generating counts which help in doing
-- prediction factor Destination Transfers.
-- -----------------------------------------------------------------------------
p_SrcCountComb : process (ChEnable, ChannelState, SrcErrOccrd, SameBus,
                          SrcBusWidth, DstBusWidth, SrcCopyState, SrcSelComb,
                          NextSrcBeat, SrcBeatCopy, SrcCopy1, SrcAhbMasSel,
                          DelMready1, DelMready2, SrcCopy2, ErrorMas1,
                          ErrorMas2)
begin
  NextSrcBeatCopy <= SrcBeatCopy;
  NextSrcCopy1    <= SrcCopy1;
  NextSrcCopy2    <= SrcCopy2;
  NextSrcCopyST   <= SrcCopyState;
  if ((ChEnable = '1') and (ChannelState /= ST_LLI_LOAD) and (SrcErrOccrd = '0')
                     and (SameBus = '1') and (SrcBusWidth >= DstBusWidth)) then
    case SrcCopyState is
      when ST_SRC_PREDICT_IDLE =>
        if ((SrcSelComb = '1') and
                   (ErrorMas(SrcAhbMasSel, ErrorMas1, ErrorMas2) = '0')) then
          NextSrcCopyST <= ST_SRC_ADDR_PHASE;
          NextSrcBeatCopy <= NextSrcBeat;
          NextSrcCopy1    <= SrcBeatCopy;
          NextSrcCopy2    <= SrcCopy1;
        end if;

      when ST_SRC_ADDR_PHASE =>
        if ((MREADY(SrcAhbMasSel, DelMready1, DelMready2) = '1') and
                   (ErrorMas(SrcAhbMasSel, ErrorMas1, ErrorMas2) = '0')) then
          NextSrcCopyST  <= ST_SRC_DATA_PHASE;
        end if;

      when ST_SRC_DATA_PHASE =>
        if (MREADY(SrcAhbMasSel, DelMready1, DelMready2) = '1') then
          if (SrcBeatCopy = "00000") then
            NextSrcCopyST  <= ST_SRC_PREDICT_IDLE;
            NextSrcBeatCopy <= (others => '0');
            NextSrcCopy1    <= (others => '0');
            NextSrcCopy2    <= (others => '0');
          else
            NextSrcBeatCopy <= SrcBeatCopy - '1';
            NextSrcCopy1    <= SrcBeatCopy;
            NextSrcCopy2    <= SrcCopy1;
          end if;
        end if;
      when others =>
        null;
    end case;
  else
    NextSrcCopyST  <= ST_SRC_PREDICT_IDLE;
    NextSrcBeatCopy <= (others => '0');
    NextSrcCopy1    <= (others => '0');
    NextSrcCopy2    <= (others => '0');
  end if;
end process p_SrcCountComb;

-- -----------------------------------------------------------------------------
-- This block is responsible gives actual prediction factor for Destination
-- Transfers.
-- -----------------------------------------------------------------------------
p_PredictComb : process (SrcBeatCopy, SrcCopy1, SrcCopy2)
begin
  PredictFactor <= "00";
  if ((SrcBeatCopy = "0010") and (SrcCopy1 = "0011") and
                                                      (SrcCopy2 = "0100")) then
    PredictFactor <= "11";
  elsif ((SrcBeatCopy = "0001") and (SrcCopy1 = "0010") and
                                                      (SrcCopy2 = "0011")) then
    PredictFactor <= "10";
  elsif ((SrcBeatCopy = "0000") and (SrcCopy1 = "0001") and
                                                      (SrcCopy2 = "0010")) then
    PredictFactor <= "01";
  end if;
end process p_PredictComb;

-- -----------------------------------------------------------------------------
-- Fifo UnPacking. Here the data's are duplicated on other byte lanes if the
-- width is less than 32 bit. The Read Pointer for this is moved 1MREADY early.
-- -----------------------------------------------------------------------------
p_RemDataBefComb: process (ChHwdata1, ChHwdata2, RdPtrAhead, ChEnable,
                           ChannelState, DstHwdataState, DstSelComb,
                           DstAhbMasSel, DelMready1, DelMready2, DstWidth,
                           DstDisAckOccrd, DstErrMask, FifoReg, DstBeatCopy,
                           NextDstBeat, DstErrOccrd, ErrorMas1, ErrorMas2,
                           SingleBusErr, DualBusErr, SrcErrOccrd)
begin
  NextChHwdata1  <= ChHwdata1;
  NextChHwdata2  <= ChHwdata2;
  NextRdPtrAhead <= RdPtrAhead;
  NextDstState   <= DstHwdataState;
  NextDstBeatCopy <= DstBeatCopy;
  if ((ChEnable = '1') and (ChannelState /= ST_LLI_LOAD) and
                                                       (DstErrOccrd = '0')) then
    case DstHwdataState is
      when ST_DST_HWDATA_IDLE =>
        if ((DstSelComb = '1') and
                      (ErrorMas(DstAhbMasSel, ErrorMas1, ErrorMas2) = '0')) then
          NextDstState  <= ST_DST_ADDR_PHASE;
          NextChHwdata1 <= (others => '0');
          NextChHwdata2 <= (others => '0');
          NextDstBeatCopy <= NextDstBeat;
          if (NextDstBeat = "00001") then
            AddrPhase <= '1';
          else
            AddrPhase <= '0';
          end if;
        end if;

      when ST_DST_ADDR_PHASE =>
        if ((MREADY(DstAhbMasSel, DelMready1, DelMready2) = '1') and
            (ErrorMas(DstAhbMasSel, ErrorMas1, ErrorMas2) = '0') and
            (SingleBusErr = '0') and (DualBusErr = '0') and
                                                 (ChannelState /= ST_IDLE)) then
          NextDstState  <= ST_DST_DATA_PHASE;
          NextDstBeatCopy <= DstBeatCopy - "00001";
          case DstWidth is
            when "000" =>
              if ((DstDisAckOccrd = '0') and (DstErrMask = '0')) then
                NextRdPtrAhead <= RdPtrAhead + '1';
              else
                NextRdPtrAhead <= (others => '0');
              end if;
              if (DstAhbMasSel = '0') then
                NextChHwdata1 <= (FifoReg(to_integer(RdPtrAhead)) &
                                  FifoReg(to_integer(RdPtrAhead)) &
                                  FifoReg(to_integer(RdPtrAhead)) &
                                  FifoReg(to_integer(RdPtrAhead)));
              else
                NextChHwdata2 <= (FifoReg(to_integer(RdPtrAhead)) &
                                  FifoReg(to_integer(RdPtrAhead)) &
                                  FifoReg(to_integer(RdPtrAhead)) &
                                  FifoReg(to_integer(RdPtrAhead)));
              end if;

            when "001" =>
              if ((DstDisAckOccrd = '0') and (DstErrMask = '0')) then
                NextRdPtrAhead <= RdPtrAhead + "10";
              else
                NextRdPtrAhead <= (others => '0');
              end if;
              if (DstAhbMasSel = '0') then
                NextChHwdata1 <= (FifoReg(to_integer(RdPtrAhead) + 1) &
                                  FifoReg(to_integer(RdPtrAhead)) &
                                  FifoReg(to_integer(RdPtrAhead) + 1) &
                                  FifoReg(to_integer(RdPtrAhead)));
              else
                NextChHwdata2 <= (FifoReg(to_integer(RdPtrAhead) + 1) &
                                  FifoReg(to_integer(RdPtrAhead)) &
                                  FifoReg(to_integer(RdPtrAhead) + 1) &
                                  FifoReg(to_integer(RdPtrAhead)));
              end if;

            when "010" =>
              if ((DstDisAckOccrd = '0') and (DstErrMask = '0')) then
                NextRdPtrAhead <= RdPtrAhead + "100";
              else
                NextRdPtrAhead <= (others => '0');
              end if;
              if (DstAhbMasSel = '0') then
                NextChHwdata1 <= (FifoReg(to_integer(RdPtrAhead) + 3) &
                                  FifoReg(to_integer(RdPtrAhead) + 2) &
                                  FifoReg(to_integer(RdPtrAhead) + 1) &
                                  FifoReg(to_integer(RdPtrAhead)));
              else
                NextChHwdata2 <= (FifoReg(to_integer(RdPtrAhead) + 3) &
                                  FifoReg(to_integer(RdPtrAhead) + 2) &
                                  FifoReg(to_integer(RdPtrAhead) + 1) &
                                  FifoReg(to_integer(RdPtrAhead)));
              end if;

            when others =>
              null;
          end case;
        else
          NextChHwdata1 <= (others => '0');
          NextChHwdata2 <= (others => '0');
        end if;

      when ST_DST_DATA_PHASE =>
        if ((MREADY(DstAhbMasSel, DelMready1, DelMready2) = '1') and
            (not ((ChannelState = ST_IDLE) and (SrcErrOccrd = '1')))) then
          if (DstBeatCopy = "00000") then
            NextDstState   <= ST_DST_HWDATA_IDLE;
            NextChHwdata1  <= (others => '0');
            NextChHwdata2  <= (others => '0');
            NextDstBeatCopy <= (others => '0');
            AddrPhase <= '0';
          else
            NextDstBeatCopy <= DstBeatCopy - "00001";
            case DstWidth is
              when "000" =>
                if ((DstDisAckOccrd = '0') and (DstErrMask = '0')) then
                  NextRdPtrAhead <= RdPtrAhead + '1';
                else
                  NextRdPtrAhead <= (others => '0');
                end if;
                if (DstAhbMasSel = '0') then
                  NextChHwdata1 <= (FifoReg(to_integer(RdPtrAhead)) &
                                    FifoReg(to_integer(RdPtrAhead)) &
                                    FifoReg(to_integer(RdPtrAhead)) &
                                    FifoReg(to_integer(RdPtrAhead)));
                else
                  NextChHwdata2 <= (FifoReg(to_integer(RdPtrAhead)) &
                                    FifoReg(to_integer(RdPtrAhead)) &
                                    FifoReg(to_integer(RdPtrAhead)) &
                                    FifoReg(to_integer(RdPtrAhead)));
                end if;

              when "001" =>
                if ((DstDisAckOccrd = '0') and (DstErrMask = '0')) then
                  NextRdPtrAhead <= RdPtrAhead + "10";
                else
                  NextRdPtrAhead <= (others => '0');
                end if;
                if (DstAhbMasSel = '0') then
                  NextChHwdata1 <= (FifoReg(to_integer(RdPtrAhead) + 1) &
                                    FifoReg(to_integer(RdPtrAhead)) &
                                    FifoReg(to_integer(RdPtrAhead) + 1) &
                                    FifoReg(to_integer(RdPtrAhead)));
                else
                  NextChHwdata2 <= (FifoReg(to_integer(RdPtrAhead) + 1) &
                                    FifoReg(to_integer(RdPtrAhead)) &
                                    FifoReg(to_integer(RdPtrAhead) + 1) &
                                    FifoReg(to_integer(RdPtrAhead)));
                end if;

              when "010" =>
                if ((DstDisAckOccrd = '0') and (DstErrMask = '0')) then
                  NextRdPtrAhead <= RdPtrAhead + "100";
                else
                  NextRdPtrAhead <= (others => '0');
                end if;
                if (DstAhbMasSel = '0') then
                  NextChHwdata1 <= (FifoReg(to_integer(RdPtrAhead) + 3) &
                                    FifoReg(to_integer(RdPtrAhead) + 2) &
                                    FifoReg(to_integer(RdPtrAhead) + 1) &
                                    FifoReg(to_integer(RdPtrAhead)));
                else
                  NextChHwdata2 <= (FifoReg(to_integer(RdPtrAhead) + 3) &
                                    FifoReg(to_integer(RdPtrAhead) + 2) &
                                    FifoReg(to_integer(RdPtrAhead) + 1) &
                                    FifoReg(to_integer(RdPtrAhead)));
                end if;

              when others =>
                null;
            end case;
          end if;
        elsif ((ChannelState = ST_IDLE) and (SrcErrOccrd = '1')) then
          NextChHwdata1 <= (others => '0');
          NextChHwdata2 <= (others => '0');
          NextRdPtrAhead <= (others => '0');
          AddrPhase     <= '0';
        end if;
      when others =>
        null;
    end case;
  else
    NextChHwdata1 <= (others => '0');
    NextChHwdata2 <= (others => '0');
    NextRdPtrAhead <= (others => '0');
    NextDstState   <= ST_DST_HWDATA_IDLE;
    AddrPhase     <= '0';
  end if;
end process p_RemDataBefComb;

-- -----------------------------------------------------------------------------
-- HWDATA for Bus1
-- -----------------------------------------------------------------------------
iHWDATA1   <= ChHwdata1 when (DelMready1 = '1')
           else
             HwdataBuff1;

-- -----------------------------------------------------------------------------
-- HWDATA for Bus2
-- -----------------------------------------------------------------------------
iHWDATA2   <= ChHwdata2 when (DelMready2 = '1')
           else
             HwdataBuff2;

HWDATA1 <= iHWDATA1;
HWDATA2 <= iHWDATA2;

-- -----------------------------------------------------------------------------
-- Wrap signal generation block
-- -----------------------------------------------------------------------------
p_WrapLevelComb : process (Wrap, ChEnable, WrPtr, NextWrPtr, RdPtrAhead,
                           NextRdPtrAhead, SrcWidth, DstWidth)
begin
  NextWrap <= Wrap;
  if (ChEnable = '1') then
    case SrcWidth is
      when "000" =>
        case DstWidth is
          when "000" =>
            if ((WrPtr = "1111") and (NextWrPtr = "0000")) then
              NextWrap <= '1';
            elsif ((RdPtrAhead = "1111") and (NextRdPtrAhead = "0000")) then
              NextWrap <= '0';
            else
              NextWrap <= Wrap;
            end if;
          when "001" =>
            if ((WrPtr = "1111") and (NextWrPtr = "0000")) then
              NextWrap <= '1';
            elsif ((RdPtrAhead = "1110") and (NextRdPtrAhead = "0000")) then
              NextWrap <= '0';
            else
              NextWrap <= Wrap;
            end if;
          when "010" =>
            if ((WrPtr = "1111") and (NextWrPtr = "0000")) then
              NextWrap <= '1';
            elsif ((RdPtrAhead = "1100") and (NextRdPtrAhead = "0000")) then
              NextWrap <= '0';
            else
              NextWrap <= Wrap;
            end if;
          when others =>
            null;
        end case;
      when "001" =>
        case DstWidth is
          when "000" =>
            if ((WrPtr = "1110") and (NextWrPtr = "0000")) then
              NextWrap <= '1';
            elsif ((RdPtrAhead = "1111") and (NextRdPtrAhead = "0000")) then
              NextWrap <= '0';
            else
              NextWrap <= Wrap;
            end if;
          when "001" =>
            if ((WrPtr = "1110") and (NextWrPtr = "0000")) then
              NextWrap <= '1';
            elsif ((RdPtrAhead = "1110") and (NextRdPtrAhead = "0000")) then
              NextWrap <= '0';
            else
              NextWrap <= Wrap;
            end if;
          when "010" =>
            if ((WrPtr = "1110") and (NextWrPtr = "0000")) then
              NextWrap <= '1';
            elsif ((RdPtrAhead = "1100") and (NextRdPtrAhead = "0000")) then
              NextWrap <= '0';
            else
              NextWrap <= Wrap;
            end if;
          when others =>
            null;
        end case;

      when "010" =>
        case DstWidth is
          when "000" =>
            if ((WrPtr = "1100") and (NextWrPtr = "0000")) then
              NextWrap <= '1';
            elsif ((RdPtrAhead = "1111") and (NextRdPtrAhead = "0000")) then
              NextWrap <= '0';
            else
              NextWrap <= Wrap;
            end if;
          when "001" =>
            if ((WrPtr = "1100") and (NextWrPtr = "0000")) then
              NextWrap <= '1';
            elsif ((RdPtrAhead = "1110") and (NextRdPtrAhead = "0000")) then
              NextWrap <= '0';
            else
              NextWrap <= Wrap;
            end if;
          when "010" =>
            if ((WrPtr = "1100") and (NextWrPtr = "0000")) then
              NextWrap <= '1';
            elsif ((RdPtrAhead = "1100") and (NextRdPtrAhead = "0000")) then
              NextWrap <= '0';
            else
              NextWrap <= Wrap;
            end if;
          when others =>
            null;
        end case;
      when others =>
        null;
    end case;
  else
    NextWrap <= '0';
  end if;
end process p_WrapLevelComb;

-- -----------------------------------------------------------------------------
-- Actual FifoLevel generation based on Wrap, RdPtrAhead and WrPtr
-- -----------------------------------------------------------------------------
ActFifoLevel <= (Wrap & WrPtr) - ('0' & RdPtrAhead);

-- -----------------------------------------------------------------------------
-- DMAFIFOLevel which is delayed ActFifoLevel in SrcState
-- -----------------------------------------------------------------------------
DMAFIFOLevel <= ActFifoLevel when (DstState = '1')
             else
               ActFifoLevDel;

-- -----------------------------------------------------------------------------
-- Registering all the next state signals
-- -----------------------------------------------------------------------------
p_WriteSeq : process (HRESETn, HCLK)
begin
  if (HRESETn = '0') then
    ChSrcAddrReg     <= (others => '0');
    ChDstAddrReg     <= (others => '0');
    ChControlReg     <= (others => '0');
    ChLLIReg         <= (others => '0');
    ChConfigReg      <= (others => '0');
    SrcErrOccrd      <= '0';
    DstErrOccrd      <= '0';
    LLIErrOccrd      <= '0';
    ChIntReg         <= '0';
    iChIntErr        <= '0';
    ChIntErrDel1     <= '0';
    SrcMaskReg       <= '0';
    SrcBeat          <= (others => '0');
    DstBeat          <= (others => '0');
    DstBeatCopy      <= (others => '0');
    ChannelState     <= ST_IDLE;
    DstSelReg        <= '0';
    SrcSelReg        <= '0';
    LLIBeat          <= (others => '0');
    DstTxrOn         <= '0';
    SrcTxrOn         <= '0';
    TwoBitCnt        <= (others => '0');
    iDMACCLR         <= (others => '0');
    iDMACTC          <= (others => '0');
    SrcBurst         <= (others => '0');
    DstBurst         <= (others => '0');
    SourceTC         <= (others => '0');
    DstTC            <= (others => '0');
    SrcBstDstFlow    <= (others => '0');
    SrcTCDstFlow     <= (others => '0');
    DstLstSrcReg     <= '0';
    SrcLstOccrdReg   <= '0';
    DstLstOccrdReg   <= '0';
    DstBstSrcFlow    <= (others => '0');
    DstTCSrcFlow     <= (others => '0');
    WrPtr            <= (others => '0');
    ActFifoLevDel    <= (others => '0');
    Wrap             <= '0';
    DelDstRqBefMask  <= '0';
    SrcStart         <= '0';
    OneBitTog        <= '0';
    TwoBitTog        <= (others => '0');
    ChHaltReg        <= '0';
    ChDisableReg     <= '0';
    DelSrcState      <= '0';
    DelDstState      <= '0';
    RdPtrAhead       <= (others => '0');
    HwdataBuff1      <= (others => '0');
    HwdataBuff2      <= (others => '0');
    ErrorState       <= ST_ERROR_INIT;
    DMACTCDel        <= (others => '0');
    DMACCLRDel       <= (others => '0');
    DMACCLR2Del      <= (others => '0');
    DelDstFlowReq    <= '0';
    DelChEnable      <= '0';
    DelMready1       <= '0';
    DelMready2       <= '0';
    DstHwdataState   <= ST_DST_HWDATA_IDLE;
    DelLLIState      <= '0';
    Del2LLIState     <= '0';
    ChHwdata1        <= (others => '0');
    ChHwdata2        <= (others => '0');
    LLIAhbMasSel     <= '0';
    SrcBeatCopy      <= (others => '0');
    SrcCopy1         <= (others => '0');
    SrcCopy2         <= (others => '0');
    SrcCopyState     <= ST_SRC_PREDICT_IDLE;
    NotValidSrcST    <= ST_NOTVALIDSRC_IDLE;
    NotValidDstST    <= ST_NOTVALIDDST_IDLE;
    NotValidLLIST    <= ST_NOTVALIDLLI_IDLE;
    LLISelReg        <= '0';
    DMACTCP2M        <= '0';
    DelDMACTCP2M     <= '0';
    WaitedForClr     <= '0';
    DelErrMas1       <= '0';
    DelErrMas2       <= '0';
    ErrPulse1        <= '0';
    ErrPulse2        <= '0';
    DelIntr          <= '0';
    SoftClrPulse     <= '0';
    SrcDisable       <= '0';
    DstDisable       <= '0';
    LLIDisable       <= '0';
    DisableST        <= ST_DISABLE_IDLE;
    DelChDisable     <= '0';
    DelNotValidSrc   <= '0';
    DelNotValidDst   <= '0';
    DelNotValidLLI   <= '0';
    for i in 0 to 15 loop
      FifoReg(i) <= (others => '0');
    end loop;
  elsif (HCLK'event and HCLK = '1') then
    ChSrcAddrReg     <= NextChSrcAddrReg;
    ChDstAddrReg     <= NextChDstAddrReg;
    ChControlReg     <= NextChControlReg;
    ChLLIReg         <= NextChLLIReg;
    ChConfigReg      <= NextChConfigReg;
    SrcErrOccrd      <= NextSrcErrOccrd;
    DstErrOccrd      <= NextDstErrOccrd;
    LLIErrOccrd      <= NextLLIErrOccrd;
    ChIntReg         <= NextChIntReg;
    iChIntErr        <= NextChIntErr;
    ChIntErrDel1     <= iChIntErr;
    SrcMaskReg       <= NextSrcMaskReg;
    SrcBeat          <= NextSrcBeat;
    DstBeat          <= NextDstBeat;
    DstBeatCopy      <= NextDstBeatCopy;
    ChannelState     <= NextChState;
    DstSelReg        <= NextDstSelReg;
    SrcSelReg        <= NextSrcSelReg;
    LLIBeat          <= NextLLIBeat;
    DstTxrOn         <= NextDstTxrOn;
    SrcTxrOn         <= NextSrcTxrOn;
    TwoBitCnt        <= NextTwoBitCnt;
    iDMACCLR         <= NextDMACCLR;
    iDMACTC          <= NextDMACTC;
    SrcBurst         <= NextSrcBurst;
    DstBurst         <= NextDstBurst;
    SourceTC         <= NextSourceTC;
    DstTC            <= NextDstTC;
    SrcBstDstFlow    <= NxtSrcBstDstFlow;
    SrcTCDstFlow     <= NxtSrcTCDstFlow;
    DstLstSrcReg     <= NextDstLstSrc;
    SrcLstOccrdReg   <= NextSrcLstOccrd;
    DstLstOccrdReg   <= NextDstLstOccrd;
    DstBstSrcFlow    <= NxtDstBstSrcFlow;
    DstTCSrcFlow     <= NxtDstTCSrcFlow;
    FifoReg          <= NextFifoReg;
    WrPtr            <= NextWrPtr;
    Wrap             <= NextWrap;
    DelDstRqBefMask  <= DstReqBefMask;
    SrcStart         <= NextSrcStart;
    ActFifoLevDel    <= ActFifoLevel;
    OneBitTog        <= NextOneBitTog;
    TwoBitTog        <= NextTwoBitTog;
    ChHaltReg        <= NextChHalt;
    ChDisableReg     <= NextChDisable;
    DelSrcState      <= NextDelSrcState;
    DelDstState      <= NextDelDstState;
    Del2DstState     <= DelDstState;
    RdPtrAhead       <= NextRdPtrAhead;
    ChHwdata1        <= NextChHwdata1;
    ChHwdata2        <= NextChHwdata2;
    if (MREADY1 = '0') then
      HwdataBuff1      <= iHWDATA1;
    else
      HwdataBuff1      <= (others => '0');
    end if;
    if (MREADY2 = '0') then
      HwdataBuff2      <= iHWDATA2;
    else
      HwdataBuff2      <= (others => '0');
    end if;
    ErrorState       <= NextErrorState;
    DMACTCDel        <= iDMACTC;
    DMACCLRDel       <= iDMACCLR;
    DMACCLR2Del      <= DMACCLRDel;
    DelDstFlowReq    <= DstFlowReq;
    DelChEnable      <= ChEnable;
    DelMready1       <= MREADY1;
    DelMready2       <= MREADY2;
    DstHwdataState   <= NextDstState;
    DelLLIState      <= NextDelLLIState;
    Del2LLIState     <= DelLLIState;
    LLIAhbMasSel     <= NextLLIAhbMasSel;
    SrcBeatCopy      <= NextSrcBeatCopy;
    SrcCopy1         <= NextSrcCopy1;
    SrcCopy2         <= NextSrcCopy2;
    SrcCopyState     <= NextSrcCopyST;
    NotValidSrcST    <= NextSrcNotState;
    NotValidDstST    <= NextDstNotState;
    NotValidLLIST    <= NextLLINotState;
    LLISelReg        <= NextLLISelReg;
    DMACTCP2M        <= NextDMACTCP2M;
    DelDMACTCP2M     <= DMACTCP2M;
    WaitedForClr     <= NextWaitedForClr;
    DelErrMas1       <= ErrorMas1;
    DelErrMas2       <= ErrorMas2;
    if ((MREADY1 = '0') and (ErrorMas1 = '1')) then
      ErrPulse1 <= '1';
    else
      ErrPulse1 <= '0';
    end if;
    if ((MREADY2 = '0') and (ErrorMas2 = '1')) then
      ErrPulse2 <= '1';
    else
      ErrPulse2 <= '0';
    end if;
    DelIntr          <= NextDelIntr;
    SoftClrPulse     <= NextSoftClrPulse;
    SrcDisable       <= NextSrcDisable;
    DstDisable       <= NextDstDisable;
    LLIDisable       <= NextLLIDisable;
    DisableST        <= NextDisableST;
    DelChDisable     <= ChDisableReg;
    DelNotValidSrc   <= NotValidDataSrc;
    DelNotValidDst   <= NotValidDataDst;
    DelNotValidLLI   <= NotValidDataLLI;
  end if;
end process p_WriteSeq;

-- -----------------------------------------------------------------------------
-- Protocol Checker Messages Block
-- -----------------------------------------------------------------------------
p_LLILoadMsg : process (HCLK)
variable NoteStr         : string (1 to 255);
variable Temp1           : std_logic_vector(31 downto 0);
begin
  if (HCLK'event and HCLK = '1') then
    if (LLISelComb = '1') then
      Temp1 := (LLILoad & "00");
      fprint (NoteStr, "DmacTrChLogic1: LLI Loading happening from" &
                       "Address: %s ", To_HexString(Temp1));
      assert false
      report NoteStr
      severity note;
    end if;

    if (ChSrcAddrWrEn = '1') then
      if (ChHaltReg = '1') then
        assert false
        report "DmacTrChLogic2: Channel is programmed when Halt bit is set"
        severity error;
      end if;

      if ((DMACEn = '0') and (DmacTrEn = '1')) then
        assert false
        report "DmacTrChLogic3: DMAC Not enabled but channel registers" &
               "are getting written"
        severity error;
      end if;
    end if;

    if ((ChConfigWrEn = '1') and (HWDATA(0) = '1')) then
      if ((FlowCntl(2) = '0') and (HWDATA(11 downto 0) = ZEROFILL(11 downto 0)))
                                                                            then
        assert false
        report "DmacTrChLogic4: Programmed with 0 Transfer size when DMAC is" &
               "Flow Controller"
        severity error;
      end if;

      if ((DMACEn = '0') and (DmacTrEn = '1')) then
        assert false
        report "DmacTrChLogic5: DMAC Not enabled but channel registers" &
               "are getting written"
        severity error;
      end if;
    end if;

    if (ChConfigWrEn = '1') then
      if ((HWDATA(18) = '1') and (SrcReqBefMask = '1')) then
        assert false
        report "DmacTrChLogic6: Channel is Halted and Further requests are" &
               "ignored till this bit is cleared"
        severity warning;
      end if;

      if ((DMACEn = '0') and (DmacTrEn = '1')) then
        assert false
        report "DmacTrChLogic7: DMAC Not enabled but channel registers" &
               "are getting written"
        severity error;
      end if;
    end if;

    if (((ErrPulse1 = '1') or (ErrPulse2 = '1')) and (SrcErrOccrd = '1')) then
      assert false
      report "DmacTrChLogic8: Error Response received during Source Transfer"
      severity warning;
    end if;

    if (((ErrPulse1 = '1') or (ErrPulse2 = '1')) and (DstErrOccrd = '1')) then
      assert false
      report "DmacTrChLogic9: Error Response received during Destination Txr"
      severity warning;
    end if;

    if (((ErrPulse1 = '1') or (ErrPulse2 = '1')) and (LLIErrOccrd = '1')) then
      assert false
      report "DmacTrChLogic10: Error Response received during LLI Txr"
      severity warning;
    end if;

    if ((ChConfigWrEn = '1') and (ChEnable = '1')) then
      if (HWDATA(0) = '0') then
        assert false
        report "DmacTrChLogic11: Channel Disable Occurred"
        severity warning;
      end if;
    end if;
  end if;
end process p_LLILoadMsg;

end behavioural;

-- --================================== End ==================================--
