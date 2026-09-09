-- --=========================================================================--
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
-- File Name              : MmciTrick.vhd.rca
-- File Revision          : 1.3
--
-- Release Information    : PrimeCell(TM)-PL181-REL1v0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           Data Flow code for the Top level. Instantiates the
--           following modules MmciTrApbif, MmciTrRegblk,
--           MmciTrMclkRsgen, MmciTrSynctoMCLK, MmciTrSynctoPCLK,
--           MmciTrRxFifo, MmciTrTxFifo, MmciTrCrc16gen, MmciTrCrc7gen,
--           MmciTrStoP, MmciTrPtoS, MmciTrChecker and defines the
--           connectivity between them.
--
-- --=========================================================================--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

-- -----------------------------------------------------------------------------

entity MmciTrick is
  port (
-- Inputs
        PCLK             : in    std_logic; -- APB Bus Clock
        MMCICLKOUT       : in    std_logic; -- MMCI Bus Clock
        PRESETn          : in    std_logic; -- APB Bus Reset
        PSEL             : in    std_logic; -- APB MMCI select
        PSELT            : in    std_logic; -- APB Trickbox select
        PWRITE           : in    std_logic; -- APB Peripheral Write
        PENABLE          : in    std_logic; -- APB Peripheral enable
        MMCIPWR          : in    std_logic; -- MMCI Bus Power phase
                                            -- Indication
        MMCIVDD          : in    std_logic_vector(3 downto 0);
                                            -- Power Supply input
                                            -- voltage
        MMCIROD          : in    std_logic; -- Open Drain resistor
                                            -- enable
        MMCIINTR0        : in    std_logic; -- Interrupt 0 Request
                                            -- from MMCI
        MMCIINTR1        : in    std_logic; -- Interrupt 1 Request
                                            -- from MMCI
        MMCIDMASREQ      : in    std_logic; -- DMA Single Req from MMCI
        MMCIDMABREQ      : in    std_logic; -- DMA Burst Req from MMCI
        MMCIDMALSREQ     : in    std_logic; -- DMA last single Req
                                            -- from MMCI
        MMCIDMALBREQ     : in    std_logic; -- DMA last Burst Req
                                            -- from MMCI
        PADDR            : in    std_logic_vector(11 downto 2);
                                            -- APB Addr
        PWDATA           : in    std_logic_vector(31 downto 0);
                                            -- Write databus
-- Inouts
        MMCICMD          : inout std_logic; -- MMCI command path
        MMCIDAT          : inout std_logic; -- MMCI data path
-- Outputs
        MCLK             : out   std_logic; -- MMCI Adapter Clock
        nMMCIRST         : out   std_logic; -- MCLK Domain reset signal
        MMCIDMACLR       : out   std_logic; -- MMCI DMA request clear
        PRDATA           : out   std_logic_vector(31 downto 0)
                                            -- Read Databus
       );
end MmciTrick;

-- -----------------------------------------------------------------------------
--
--                                  MmciTrick
--                                  =========
--
-- -----------------------------------------------------------------------------
--
-- Overview
-- ========
--
-- This module instantiates the following sub-modules:
--
-- 1. MmciTrApbif         - APB Interface
-- 2. MmciTrRegBlk        - Register Block
-- 3. MmciTrRxFifo        - Receive FIFO
-- 4. MmciTrTxFifo        - Transmit FIFO
-- 5. MmciTrStoP          - Receiver/Serial to Parallel converter
-- 6. MmciTrSynctoPCLK    - Synchronisers for signals crossing into
--                         PCLK domain
-- 7. MmciTrSynctoMCLK    - Synchronisers for signals crossing into
--                         MMCICLK domain
-- 8. MmciTrMclkRsgen     - Clock generation and RST Controller Block
-- 9. MmciTrChecker       - Protocol Checker Block
-- 10.MmciTrPtoS          - Transmitter/Parallel to Serial Convertor
-- 11.MmciTrCrc7gen       - Generates CRC7
-- 12.MmciTrCrc16gen      - Generates CRC16
--
-- -----------------------------------------------------------------------------

-- --=========================== ARCHITECTURE ================================--

architecture structural of MmciTrick is

-- -----------------------------------------------------------------------------
-- Component declarations
-- -----------------------------------------------------------------------------
component MmciTrApbif
  port (
        PCLK             : in    std_logic;
        PRESETn          : in    std_logic;
        PSEL             : in    std_logic;
        PSELT            : in    std_logic;
        PWRITE           : in    std_logic;
        PENABLE          : in    std_logic;
        MMCITBSIGSTAT    : in    std_logic_vector(5 downto 0);
        MMCITBRxdCInd    : in    std_logic_vector(5 downto 0);
        MMCITBRxdCArg    : in    std_logic_vector(31 downto 0);
        RFF              : in    std_logic;
        TFF              : in    std_logic;
        RFE              : in    std_logic;
        TFE              : in    std_logic;
        TFHE             : in    std_logic;
        RFHF             : in    std_logic;
        PCLKOn           : in    std_logic;
        MCLKOn           : in    std_logic;
        RxFRdData        : in    std_logic_vector(32 downto 0);
        CmdCrcErrStat    : in    std_logic;
        PADDR            : in    std_logic_vector(11 downto 2);
        PWDATA           : in    std_logic_vector(31 downto 0);
        RxFRdPtrInc      : out   std_logic;
        MMCIPowerWr      : out   std_logic;
        MMCIClockWr      : out   std_logic;
        MMCICommandWr    : out   std_logic;
        MMCIDataLenWr    : out   std_logic;
        MMCIDataCntlWr   : out   std_logic;
        MMCITBCmdRespWr  : out   std_logic;
        MMCITBResp0Wr    : out   std_logic;
        MMCITBResp1Wr    : out   std_logic;
        MMCITBResp2Wr    : out   std_logic;
        MMCITBResp3Wr    : out   std_logic;
        MMCITBDtTimWr    : out   std_logic;
        MMCITBMCLKWr     : out   std_logic;
        MMCITBCntlWr     : out   std_logic;
        MMCITBReTimWr    : out   std_logic;
        MMCITBTokTimWr   : out   std_logic;
        MMCITBBsyTimWr   : out   std_logic;
        MMCITBPCDisWr    : out   std_logic;
        MMCITBStTimWr    : out   std_logic;
        MMCITBCLKRSTWr   : out   std_logic;
        MMCITBTXFWr      : out   std_logic;
        PRDATA           : out   std_logic_vector(31 downto 0);
        PWDATAIn         : out   std_logic_vector(31 downto 0)
       );
end component;

component MmciTrRxFifo
  port (
        PCLK             : in    std_logic;
        PRESETn          : in    std_logic;
        FifoClearSync    : in    std_logic;
        RxFWrSync        : in    std_logic;
        RxFRdPtrInc      : in    std_logic;
        RxFWrData        : in    std_logic_vector(32 downto 0);

        RNE              : out   std_logic;
        RFF              : out   std_logic;
        RFHF             : out   std_logic;
        RxFRdData        : out   std_logic_vector(32 downto 0)
       );
end component;

component MmciTrTxFifo
  port (
        PCLK             : in    std_logic;
        PRESETn          : in    std_logic;
        FifoClearSync    : in    std_logic;
        MMCITBTXFWr      : in    std_logic;
        TxFRdSync        : in    std_logic;
        PWDATAIn         : in    std_logic_vector(31 downto 0);
        TxDataAvlbl      : out   std_logic;
        TNF              : out   std_logic;
        TFE              : out   std_logic;
        TFHE             : out   std_logic;
        TxFRdData        : out   std_logic_vector(31 downto 0)
       );
end component;

component MmciTrSynctoPCLK
  port (
        PCLK             : in    std_logic;
        PRESETn          : in    std_logic;
        MTBCIUpdate      : in    std_logic;
        MTBCAUpdate      : in    std_logic;
        RxFWr            : in    std_logic;
        TxFRd            : in    std_logic;
        FifoClear        : in    std_logic;
        MTBCIUpdateSync  : out   std_logic;
        MTBCAUpdateSync  : out   std_logic;
        FifoClearSync    : out   std_logic;
        RxFWrSync        : out   std_logic;
        TxFRdSync        : out   std_logic
       );
end component;

component MmciTrSynctoMCLK
  port (
        MCLK             : in    std_logic;
        nMMCIRST         : in    std_logic;
        MPUpdate         : in    std_logic;
        MCUpdate         : in    std_logic;
        MCMUpdate        : in    std_logic;
        MDLUpdate        : in    std_logic;
        MDCUpdate        : in    std_logic;
        MTBCUpdate       : in    std_logic;
        MPUpdateSync     : out   std_logic;
        MCUpdateSync     : out   std_logic;
        MCMUpdateSync    : out   std_logic;
        MDLUpdateSync    : out   std_logic;
        MDCUpdateSync    : out   std_logic;
        MTBCUpdateSync   : out   std_logic
       );
end component;

component MmciTrRegblk
  port (
        PCLK             : in    std_logic;
        PRESETn          : in    std_logic;
        MMCIPowerWr      : in    std_logic;
        MMCIClockWr      : in    std_logic;
        MMCICommandWr    : in    std_logic;
        MMCIDataLenWr    : in    std_logic;
        MMCIDataCntlWr   : in    std_logic;
        MMCITBCntlWr     : in    std_logic;
        MMCITBRxdCIndS2  : in    std_logic_vector(5 downto 0);
        MMCITBRxdCArgS2  : in    std_logic_vector(31 downto 0);
        MTBCIUpdateSync  : in    std_logic;
        MTBCAUpdateSync  : in    std_logic;
        PWDATAIn         : in    std_logic_vector(31 downto 0);
        MMCIPower        : out   std_logic_vector(7 downto 0);
        MMCIClock        : out   std_logic_vector(10 downto 0);
        MMCICommand      : out   std_logic_vector(10 downto 0);
        MMCIDataLength   : out   std_logic_vector(15 downto 0);
        MMCIDataCntl     : out   std_logic_vector(7 downto 0);
        MMCITBCntl       : out   std_logic_vector(13 downto 0);
        MPUpdate         : out   std_logic;
        MCUpdate         : out   std_logic;
        MCMUpdate        : out   std_logic;
        MDLUpdate        : out   std_logic;
        MDCUpdate        : out   std_logic;
        MTBCUpdate       : out   std_logic;
        MMCITBRxdCInd    : out   std_logic_vector(5 downto 0);
        MMCITBRxdCArg    : out   std_logic_vector(31 downto 0)
       );
end component;

component MmciTrCrc7gen
  port (
        MMCICLK          : in    std_logic;
        nMMCIRST         : in    std_logic;
        Crc7En           : in    std_logic;
        SendResponse     : in    std_logic;
        MMCICMD          : in    std_logic;
        CRC7             : out   std_logic_vector(6 downto 0);
        CrcBufferBit     : out   std_logic
       );
end component;

component MmciTrCrc16gen
  port (
        MMCICLK          : in    std_logic;
        nMMCIRST         : in    std_logic;
        CRC16En          : in    std_logic;
        DataDirection    : in    std_logic;
        MMCIDAT          : in    std_logic;
        CRC16            : out   std_logic_vector(15 downto 0);
        DCrcBufferBit    : out   std_logic
       );
end component;

component MmciTrStoP
  port (
        MMCICLK          : in    std_logic;
        nMMCIRST         : in    std_logic;
        DataLength       : in    std_logic_vector(15 downto 0);
        Blocklen         : in    std_logic_vector(3 downto 0);
        RxCommand        : in    std_logic;
        SendResponse     : in    std_logic;
        CmdEnable        : in    std_logic;
        DataEn           : in    std_logic;
        DataDirection    : in    std_logic;
        DataMode         : in    std_logic;
        TokenSent        : in    std_logic;
        MDCStg2WrEn      : in    std_logic;
        CRC7             : in    std_logic_vector(6 downto 0);
        CRC160           : in    std_logic_vector(15 downto 0);
        MMCICMDIn        : in    std_logic;
        MMCIDATIn        : in    std_logic;
        MMCITBRxdCIndS2  : out   std_logic_vector(5 downto 0);
        MMCITBRxdCArgS2  : out   std_logic_vector(31 downto 0);
        MTBCIUpdate      : out   std_logic;
        MTBCAUpdate      : out   std_logic;
        DataCnt          : out   std_logic_vector(15 downto 0);
        BitCnt           : out   std_logic_vector(2 downto 0);
        RxFWr            : out   std_logic;
        CmdCrcErrStat    : out   std_logic;
        CTxBitCheckErr   : out   std_logic;
        RCRC7En          : out   std_logic;
        RCRC16En         : out   std_logic;
        DataRxd          : out   std_logic;
        RxFWrData        : out   std_logic_vector(32 downto 0)
       );
end component;

component MmciTrPtoS
  port (
        MMCICLK          : in    std_logic;
        nMMCIRST         : in    std_logic;
        ResponseBits     : in    std_logic_vector(1 downto 0);
        CmdEnable        : in    std_logic;
        CmdRespCnt       : in    std_logic_vector(31 downto 0);
        MMCITBCmdRespWr  : in    std_logic;
        MMCITBResp0Wr    : in    std_logic;
        MMCITBResp1Wr    : in    std_logic;
        MMCITBResp2Wr    : in    std_logic;
        MMCITBResp3Wr    : in    std_logic;
        CRC7             : in    std_logic_vector(6 downto 0);
        CrcBufferBit     : in    std_logic;
        CmdCrcErr        : in    std_logic;
        DataEn           : in    std_logic;
        DataDirection    : in    std_logic;
        DataMode         : in    std_logic;
        DataLength       : in    std_logic_vector(15 downto 0);
        Blocklen         : in    std_logic_vector(3 downto 0);
        MDCStg2WrEn      : in    std_logic;
        TxFRdData        : in    std_logic_vector(31 downto 0);
        CRC160           : in    std_logic_vector(15 downto 0);
        DCrcBufferBit    : in    std_logic_vector(3 downto 0);
        DataTimeCnt      : in    std_logic_vector(31 downto 0);
        TokenTimeCnt     : in    std_logic_vector(15 downto 0);
        BsyTimeCnt       : in    std_logic_vector(15 downto 0);
        DataRxd          : in    std_logic;
        TokenErrBit      : in    std_logic;
        DataCrcErr       : in    std_logic;
        SendResponse     : in    std_logic;
        RxCommand        : in    std_logic;
        PWDATAIn         : in    std_logic_vector(31 downto 0);
        TokenSent        : out   std_logic;
        TkCntOver        : out   std_logic;
        TxFRd            : out   std_logic;
        TCRC7En          : out   std_logic;
        TCRC16En         : out   std_logic;
        BlkEnd           : out   std_logic;
        MMCICMD          : out   std_logic;
        MMCIDAT          : out   std_logic
       );
end component;

component MmciTrChecker
  port (
        MMCICLK          : in    std_logic;
        nMMCIRST         : in    std_logic;
        MMCIINTR0        : in    std_logic;
        MMCIINTR1        : in    std_logic;
        MMCIDMASREQ      : in    std_logic;
        MMCIDMABREQ      : in    std_logic;
        MMCIDMALSREQ     : in    std_logic;
        MMCIDMALBREQ     : in    std_logic;
        MMCIPWR          : in    std_logic;
        MMCIVDD          : in    std_logic_vector(3 downto 0);
        MMCIROD          : in    std_logic;
        MMCIPower        : in    std_logic_vector(7 downto 0);
        MMCIClock        : in    std_logic_vector(10 downto 0);
        MMCICommand      : in    std_logic_vector(10 downto 0);
        MMCIDataLength   : in    std_logic_vector(15 downto 0);
        MMCIDataCntl     : in    std_logic_vector(7 downto 0);
        MMCITBCntl       : in    std_logic_vector(13 downto 0);
        MMCITBMCLKPeriod : in    std_logic_vector(31 downto 0);
        DataCnt          : in    std_logic_vector(15 downto 0);
        BitCnt           : in    std_logic_vector(2 downto 0);
        MMCITBReTimWr    : in    std_logic;
        MMCITBDtTimWr    : in    std_logic;
        MMCITBTokTimWr   : in    std_logic;
        MMCITBBsyTimWr   : in    std_logic;
        MMCITBPCDisWr    : in    std_logic;
        MMCITBStTimWr    : in    std_logic;
        MPUpdateSync     : in    std_logic;
        MCUpdateSync     : in    std_logic;
        MCMUpdateSync    : in    std_logic;
        MDLUpdateSync    : in    std_logic;
        MDCUpdateSync    : in    std_logic;
        MTBCUpdateSync   : in    std_logic;
        TokenSent        : in    std_logic;
        BlkEnd           : in    std_logic;
        PWDATAIn         : in    std_logic_vector(31 downto 0);
        MMCICMD          : in    std_logic;
        MMCIDAT          : in    std_logic;
        MMCITBSIGSTAT    : out   std_logic_vector(5 downto 0);
        ResponseBits     : out   std_logic_vector(1 downto 0);
        CmdEnable        : out   std_logic;
        DataEn           : out   std_logic;
        DataDirection    : out   std_logic;
        DataMode         : out   std_logic;
        DataLength       : out   std_logic_vector(15 downto 0);
        Blocklen         : out   std_logic_vector(3 downto 0);
        MDCStg2WrEn      : out   std_logic;
        CmdCrcErr        : out   std_logic;
        DataCrcErr       : out   std_logic;
        TokenErrBit      : out   std_logic;
        CmdRespCnt       : out   std_logic_vector(31 downto 0);
        DataTimeCnt      : out   std_logic_vector(31 downto 0);
        TokenTimeCnt     : out   std_logic_vector(15 downto 0);
        BsyTimeCnt       : out   std_logic_vector(15 downto 0);
        MMCIDMACLR       : out   std_logic;
        FifoClear        : out   std_logic;
        SendResponse     : out   std_logic;
        RxCommand        : out   std_logic
       );
end component;

component MmciTrMclkRsgen
  port (
        PCLK             : in    std_logic;
        PRESETn          : in    std_logic;
        MMCITBMCLKWr     : in    std_logic;
        MMCITBCLKRSTWr   : in    std_logic;
        PWDATAIn         : in    std_logic_vector(31 downto 0);
        MCLK             : out   std_logic;
        nMMCIRST         : out   std_logic;
        MMCITBMCLKPeriod : out   std_logic_vector(31 downto 0);
        PCLKOn           : out   std_logic;
        MCLKOn           : out   std_logic
       );
end component;

-- -----------------------------------------------------------------------------
-- Constant declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Signal declarations
-- -----------------------------------------------------------------------------
signal inMMCIRST        : std_logic;
-- Reset for MMCI Controller

signal MMCITBSIGSTAT    : std_logic_vector(5 downto 0);
-- Gives readability to Interrupt and DMA Requests of MMCI

signal MMCITBRxdCInd    : std_logic_vector(5 downto 0);
-- Cmd Index recd from MMCI

signal MMCITBRxdCArg    : std_logic_vector(31 downto 0);
-- Cmd Argument recd from MMCI

signal MMCIPower        : std_logic_vector(7 downto 0);
-- MMCIPower register

signal MMCIClock        : std_logic_vector(10 downto 0);
-- MMCIClock register

signal MMCICommand      : std_logic_vector(10 downto 0);
-- MMCICommand register

signal MMCIDataLength   : std_logic_vector(15 downto 0);
-- MMCIDataLength register

signal MMCIDataCntl     : std_logic_vector(7 downto 0);
-- MMCIDataCntl register

signal MMCITBCntl       : std_logic_vector(13 downto 0);
-- MMCITBCntl register

signal MMCITBMCLKPeriod : std_logic_vector(31 downto 0);
-- The period of MCLK

signal iMCLK            : std_logic;
-- local copy of MCLK

signal RFF              : std_logic;
-- RX FIFO Full indication

signal TFF              : std_logic;
-- TX FIFO Full indication

signal RFE              : std_logic;
-- RX FIFO empty indication

signal TFE              : std_logic;
-- TX FIFO empty indication

signal TFHE             : std_logic;
-- TX FIFO half empty indication

signal RFHF             : std_logic;
-- RX FIFO half full indication

signal FifoClear        : std_logic;
-- Clear signal for FIFO

signal FifoClearSync    : std_logic;
-- Syncd version of FifoClear

signal PCLKOn           : std_logic;
-- Indicates PCLK in internally active

signal MCLKOn           : std_logic;
-- Indicates MCLK in internally active

signal RxFRdData        : std_logic_vector(32 downto 0);
-- RX FIFO read data

signal RxFRdPtrInc      : std_logic;
-- RX FIFO read pionter increment

signal MMCIPowerWr      : std_logic;
-- Write enable for MMCIPower Reg

signal MMCIClockWr      : std_logic;
-- Write enable for MMCIClock Reg

signal MMCICommandWr    : std_logic;
-- Write enable for MMCICommand Reg

signal MMCIDataLenWr    : std_logic;
-- Write enable for MMCIDataLength Reg

signal MMCIDataCntlWr   : std_logic;
-- Write enable for MMCIDataCntl Reg

signal MMCITBCmdRespWr  : std_logic;
-- Write enable for MMCITBCmdResp Reg

signal MMCITBResp0Wr    : std_logic;
-- Write enable for MMCITBResp0 Reg

signal MMCITBResp1Wr    : std_logic;
-- Write enable for MMCITBResp1 Reg

signal MMCITBResp2Wr    : std_logic;
-- Write enable for MMCITBResp2 Reg

signal MMCITBResp3Wr    : std_logic;
-- Write enable for MMCITBResp3 Reg

signal MMCITBMCLKWr     : std_logic;
-- Write enable for MMCITBMCLK Reg

signal MMCITBCntlWr     : std_logic;
-- Write enable for MMCITBCntl Reg

signal MMCITBReTimWr    : std_logic;
-- Write enable for MMCITBRespTimer Reg

signal MMCITBDtTimWr    : std_logic;
-- Write enable for MMCITBDataTimer reg

signal MMCITBTokTimWr   : std_logic;
-- Write enable for MMCITBTokenTimer Reg

signal MMCITBBsyTimWr   : std_logic;
-- Write enable for MMCITBBsyTimer Reg

signal MMCITBPCDisWr    : std_logic;
-- Write enable for MMCITBPCDisable Reg

signal MMCITBStTimWr    : std_logic;
-- Write enable for MMCITBStTimeout Reg

signal MMCITBCLKRSTWr   : std_logic;
-- Write enable for MMCITBCLKRST Reg

signal PWDATAIn         : std_logic_vector(31 downto 0);
-- local version of PWDATA

signal RxFWrSync        : std_logic;
-- Syncd version of Rx Fifo Write enable

signal RxFWrData        : std_logic_vector(32 downto 0);
-- Rx Fifo Write Data

signal RNE              : std_logic;
-- Rx Fifo not empty indication

signal MMCITBTXFWr      : std_logic;
-- Write enable for Tx Fifo

signal TxFRdSync        : std_logic;
-- Tx Fifo Read pointer Inc, syncd with PCLK

signal TxDataAvlbl      : std_logic;
-- Indication of Data availability in Tx Fifo

signal TxFRdData        : std_logic_vector(31 downto 0);
-- Tx FIFO Read Data

signal TNF              : std_logic;
-- Tx Fifo not empty indication

signal MTBCIUpdate      : std_logic;
-- Update signal to MMCITBRxdCInd Reg

signal MTBCAUpdate      : std_logic;
-- Update signal to MMCITBRxdCArg Reg

signal RxFWr            : std_logic;
-- write enable for Rx Fifo, in MMCICLK domain

signal TxFRd            : std_logic;
-- Read pointer inc for Tx Fifo, in MMCICLK domain

signal MTBCIUpdateSync  : std_logic;
-- Syncd Update signal to MMCITBRxdCInd Reg

signal MTBCAUpdateSync  : std_logic;
-- Syncd Update signal to MMCITBRxdCArg Reg

signal MPUpdate         : std_logic;
-- Update signal to MMCIPower Reg

signal MCUpdate         : std_logic;
-- Update signal to MMCIClock Reg

signal MCMUpdate        : std_logic;
-- Update signal to MMCICommand Reg

signal MDLUpdate        : std_logic;
-- Update signal to MMCIDataLength Reg

signal MDCUpdate        : std_logic;
-- Update signal to MMCIDataCntl Reg

signal MTBCUpdate       : std_logic;
-- Update signal to MMCITBCntl Reg

signal MPUpdateSync     : std_logic;
-- Syncd Update signal to MMCIPower Reg

signal MCUpdateSync     : std_logic;
-- Syncd Update signal to MMCIClock Reg

signal MCMUpdateSync    : std_logic;
-- Syncd Update signal to MMCICommand Reg

signal MDLUpdateSync    : std_logic;
-- Syncd Update signal to MMCIDataLength Reg

signal MDCUpdateSync    : std_logic;
-- Syncd Update signal to MMCIDataCntl Reg

signal MTBCUpdateSync   : std_logic;
-- Syncd Update signal to MMCITBCntl Reg

signal MDCStg2WrEn      : std_logic;
-- Indicates any write to MMCIDataCtrl register

signal MMCITBRxdCIndS2  : std_logic_vector(5 downto 0);
-- Buffered MMCITBRxdCInd Reg

signal MMCITBRxdCArgS2  : std_logic_vector(31 downto 0);
-- Buffered MMCITBRxdCArg Reg

signal CRC7En           : std_logic;
-- Enable for CRC7 calculation

signal TCRC7En          : std_logic;
-- Enable for CRC7 calculation for txd response

signal RCRC7En          : std_logic;
-- Enable for CRC7 calculation for cmd rxd

signal CRC7             : std_logic_vector(6 downto 0);
-- CRC7 Value

signal CrcBufferBit     : std_logic;
-- Crc buffer bit, to make up for 2 clk latency b/w CmdCnt and CRC7

signal CmdCrcErrStat    : std_logic;
-- Gives the status of Crc bits in the recd command

signal CRC16En          : std_logic;
-- Enable for CRC16 calculation

signal RCRC16En         : std_logic;
-- Enable for CRC16 calculation for data reception

signal TCRC16En         : std_logic;
-- Enable for CRC16 calculation for data transmission

signal CRC160           : std_logic_vector(15 downto 0);
-- CRC160 for data on line 0

signal DCrcBufferBit    : std_logic_vector(3 downto 0);
-- BufferBit for CRC16, one bit per data line

signal Blocklen         : std_logic_vector(3 downto 0);
-- Block size as specified in DataCntl Reg

signal RxCommand        : std_logic;
-- Handshake signal used to qualify command reception

signal CmdEnable        : std_logic;
-- Enable bit in command register

signal DataEn           : std_logic;
-- Enable bit in Data register

signal DataDirection    : std_logic;
-- Direction of flow on data lines

signal DataMode         : std_logic;
-- Indicates whether Data is in Stream or Block mode

signal DataLength       : std_logic_vector(15 downto 0);
-- Number of bytes of data involved in transfer

signal TokenSent        : std_logic;
-- Handshake signal, qualifies sending of token bits

signal TkCntOver        : std_logic;
-- Qualifies the period when token is being sent

signal SendResponse     : std_logic;
-- Qualifies sending of responce

signal CTxBitCheckErr   : std_logic;
-- Indicates Error on Tx Bit

signal DataRxd          : std_logic;
-- Qualifies completion of data reception

signal DataCnt          : std_logic_vector(15 downto 0);
-- Counts down with each byte of data received

signal BitCnt           : std_logic_vector(2 downto 0);
-- Counts each bit of data received

signal ResponseBits     : std_logic_vector(1 downto 0);
-- Responce bits in command register

signal CmdRespCnt       : std_logic_vector(31 downto 0);
-- Counter to count CmdRespTimer Reg value

signal CmdCrcErr        : std_logic;
-- Indicates any error on recd command CRC

signal DataTimeCnt      : std_logic_vector(31 downto 0);
-- Counter to count DataTimer Reg value

signal BlkEnd           : std_logic;
-- Indicates the end of a block

signal TokenTimeCnt     : std_logic_vector(15 downto 0);
-- Counter to count TokenTimer Reg value

signal BsyTimeCnt       : std_logic_vector(15 downto 0);
-- Counter to count BsyTimer Reg value

signal TokenErrBit      : std_logic;
-- Controls Tx of correct Crc Token

signal DataCrcErr       : std_logic;
-- Controls Tx of correct Crc with data, one bit for each line

signal MMCICMDBUS       : std_logic;
-- Version of MMCICMD, which takes into account the OpenDrain mode
-- cmd transfer

signal MMCIDATIn        : std_logic;
-- Version of MMCIDAT, which is drived only in trickbox rception mode

-- -----------------------------------------------------------------------------
-- Function declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
--
-- Main body of code
-- =================
--
-- -----------------------------------------------------------------------------

begin

-- -----------------------------------------------------------------------------
-- Assigning Fifo Flags
-- -----------------------------------------------------------------------------
RFE               <= not(RNE);
TFF               <= not(TNF);

-- -----------------------------------------------------------------------------
-- Assigning Reset and clock outputs
-- -----------------------------------------------------------------------------
nMMCIRST          <= inMMCIRST;
MCLK              <= iMCLK;

-- -----------------------------------------------------------------------------
-- Generating enables for CRC computation
-- -----------------------------------------------------------------------------
CRC7En            <= TCRC7En or RCRC7En;
CRC16En           <= TCRC16En or RCRC16En;

-- -----------------------------------------------------------------------------
-- Component Instantiations and port mapping
-- -----------------------------------------------------------------------------
-- -----------------------------------------------------------------------------
-- MmciTrApbif Instantiation
-- -----------------------------------------------------------------------------
uMmciTrApbif : MmciTrApbif
  port map (
            PCLK             => PCLK,
            PRESETn          => PRESETn,
            PSEL             => PSEL,
            PSELT            => PSELT,
            PWRITE           => PWRITE,
            PENABLE          => PENABLE,
            MMCITBSIGSTAT    => MMCITBSIGSTAT,
            MMCITBRxdCInd    => MMCITBRxdCInd,
            MMCITBRxdCArg    => MMCITBRxdCArg,
            RFF              => RFF,
            TFF              => TFF,
            RFE              => RFE,
            TFE              => TFE,
            TFHE             => TFHE,
            RFHF             => RFHF,
            PCLKOn           => PCLKOn,
            MCLKOn           => MCLKOn,
            CmdCrcErrStat    => CmdCrcErrStat,
            RxFRdData        => RxFRdData,
            PADDR            => PADDR,
            PWDATA           => PWDATA,
            RxFRdPtrInc      => RxFRdPtrInc,
            MMCIPowerWr      => MMCIPowerWr,
            MMCIClockWr      => MMCIClockWr,
            MMCICommandWr    => MMCICommandWr,
            MMCIDataLenWr    => MMCIDataLenWr,
            MMCIDataCntlWr   => MMCIDataCntlWr,
            MMCITBCmdRespWr  => MMCITBCmdRespWr,
            MMCITBResp0Wr    => MMCITBResp0Wr,
            MMCITBResp1Wr    => MMCITBResp1Wr,
            MMCITBResp2Wr    => MMCITBResp2Wr,
            MMCITBResp3Wr    => MMCITBResp3Wr,
            MMCITBDtTimWr    => MMCITBDtTimWr,
            MMCITBMCLKWr     => MMCITBMCLKWr,
            MMCITBCntlWr     => MMCITBCntlWr,
            MMCITBReTimWr    => MMCITBReTimWr,
            MMCITBTokTimWr   => MMCITBTokTimWr,
            MMCITBBsyTimWr   => MMCITBBsyTimWr,
            MMCITBPCDisWr    => MMCITBPCDisWr,
            MMCITBStTimWr    => MMCITBStTimWr,
            MMCITBCLKRSTWr   => MMCITBCLKRSTWr,
            MMCITBTXFWr      => MMCITBTXFWr,
            PRDATA           => PRDATA,
            PWDATAIn         => PWDATAIn
           );

-- -----------------------------------------------------------------------------
-- Rx FIFO instantiation
-- -----------------------------------------------------------------------------

uMmciTrRxFifo : MmciTrRxFifo
  port map (
            PCLK             => PCLK,
            PRESETn          => PRESETn,
            FifoClearSync    => FifoClearSync,
            RxFWrSync        => RxFWrSync,
            RxFRdPtrInc      => RxFRdPtrInc,
            RxFWrData        => RxFWrData,
            RNE              => RNE,
            RFF              => RFF,
            RFHF             => RFHF,
            RxFRdData        => RxFRdData
           );

-- -----------------------------------------------------------------------------
-- Tx FIFO instantiation
-- -----------------------------------------------------------------------------

uMmciTrTxFifo : MmciTrTxFifo
  port map (
            PCLK             => PCLK,
            PRESETn          => PRESETn,
            FifoClearSync    => FifoClearSync,
            MMCITBTXFWr      => MMCITBTXFWr,
            TxFRdSync        => TxFRdSync,
            PWDATAIn         => PWDATAIn,
            TxDataAvlbl      => TxDataAvlbl,
            TNF              => TNF,
            TFE              => TFE,
            TFHE             => TFHE,
            TxFRdData        => TxFRdData
           );

-- -----------------------------------------------------------------------------
-- MmciTrSynctoPCLK instantiation
-- -----------------------------------------------------------------------------

uMmciTrSynctoPCLK : MmciTrSynctoPCLK
  port map (
            PCLK             => PCLK,
            PRESETn          => PRESETn,
            MTBCIUpdate      => MTBCIUpdate,
            MTBCAUpdate      => MTBCAUpdate,
            RxFWr            => RxFWr,
            TxFRd            => TxFRd,
            FifoClear        => FifoClear,
            MTBCIUpdateSync  => MTBCIUpdateSync,
            MTBCAUpdateSync  => MTBCAUpdateSync,
            FifoClearSync    => FifoClearSync,
            RxFWrSync        => RxFWrSync,
            TxFRdSync        => TxFRdSync
           );

-- -----------------------------------------------------------------------------
-- MmciTrSynctoMCLK instantiation
-- -----------------------------------------------------------------------------

uMmciTrSynctoMCLK : MmciTrSynctoMCLK
  port map (
            MCLK             => iMCLK,
            nMMCIRST         => inMMCIRST,
            MPUpdate         => MPUpdate,
            MCUpdate         => MCUpdate,
            MCMUpdate        => MCMUpdate,
            MDLUpdate        => MDLUpdate,
            MDCUpdate        => MDCUpdate,
            MTBCUpdate       => MTBCUpdate,
            MPUpdateSync     => MPUpdateSync,
            MCUpdateSync     => MCUpdateSync,
            MCMUpdateSync    => MCMUpdateSync,
            MDLUpdateSync    => MDLUpdateSync,
            MDCUpdateSync    => MDCUpdateSync,
            MTBCUpdateSync   => MTBCUpdateSync
           );

-- -----------------------------------------------------------------------------
-- MmciTrRegBlk instantiation
-- -----------------------------------------------------------------------------

uMmciTrRegblk : MmciTrRegblk
  port map (
            PCLK             => PCLK,
            PRESETn          => PRESETn,
            MMCIPowerWr      => MMCIPowerWr,
            MMCIClockWr      => MMCIClockWr,
            MMCICommandWr    => MMCICommandWr,
            MMCIDataLenWr    => MMCIDataLenWr,
            MMCIDataCntlWr   => MMCIDataCntlWr,
            MMCITBCntlWr     => MMCITBCntlWr,
            MMCITBRxdCIndS2  => MMCITBRxdCIndS2,
            MMCITBRxdCArgS2  => MMCITBRxdCArgS2,
            MTBCIUpdateSync  => MTBCIUpdateSync,
            MTBCAUpdateSync  => MTBCAUpdateSync,
            PWDATAIn         => PWDATAIn,
            MMCIPower        => MMCIPower,
            MMCIClock        => MMCIClock,
            MMCICommand      => MMCICommand,
            MMCIDataLength   => MMCIDataLength,
            MMCIDataCntl     => MMCIDataCntl,
            MMCITBCntl       => MMCITBCntl,
            MPUpdate         => MPUpdate,
            MCUpdate         => MCUpdate,
            MCMUpdate        => MCMUpdate,
            MDLUpdate        => MDLUpdate,
            MDCUpdate        => MDCUpdate,
            MTBCUpdate       => MTBCUpdate,
            MMCITBRxdCInd    => MMCITBRxdCInd,
            MMCITBRxdCArg    => MMCITBRxdCArg
           );

-- -----------------------------------------------------------------------------
-- MmciTrCrc7gen instantiation
-- -----------------------------------------------------------------------------

uMmciTrCrc7gen : MmciTrCrc7gen
  port map (
            MMCICLK          => MMCICLKOUT,
            nMMCIRST         => inMMCIRST,
            CRC7En           => CRC7En,
            SendResponse     => SendResponse,
            MMCICMD          => MMCICMDBUS,
            CRC7             => CRC7,
            CrcBufferBit     => CrcBufferBit
           );

-- -----------------------------------------------------------------------------
-- MmciTrCrc16gen instantiation for Data line
-- -----------------------------------------------------------------------------

uMmciTrCrc16gen : MmciTrCrc16gen
  port map (
            MMCICLK          => MMCICLKOUT,
            nMMCIRST         => inMMCIRST,
            CRC16En          => CRC16En,
            DataDirection    => DataDirection,
            MMCIDAT          => MMCIDAT,
            CRC16            => CRC160,
            DCrcBufferBit    => DCrcBufferBit(0)
           );

-- -----------------------------------------------------------------------------
-- MmciTrStoP instantiation
-- -----------------------------------------------------------------------------

uMmciTrStoP : MmciTrStoP
  port map (
            MMCICLK          => MMCICLKOUT,
            nMMCIRST         => inMMCIRST,
            DataLength       => DataLength,
            Blocklen         => Blocklen,
            RxCommand        => RxCommand,
            SendResponse     => SendResponse,
            CmdEnable        => CmdEnable,
            DataEn           => DataEn,
            DataDirection    => DataDirection,
            DataMode         => DataMode,
            TokenSent        => TokenSent,
            MDCStg2WrEn      => MDCStg2WrEn,
            CRC7             => CRC7,
            CRC160           => CRC160,
            MMCICMDIn        => MMCICMDBUS,
            MMCIDATIn        => MMCIDATIn,
            MMCITBRxdCIndS2  => MMCITBRxdCIndS2,
            MMCITBRxdCArgS2  => MMCITBRxdCArgS2,
            MTBCIUpdate      => MTBCIUpdate,
            MTBCAUpdate      => MTBCAUpdate,
            DataCnt          => DataCnt,
            BitCnt           => BitCnt,
            RxFWr            => RxFWr,
            CmdCrcErrStat    => CmdCrcErrStat,
            CTxBitCheckErr   => CTxBitCheckErr,
            RCRC7En          => RCRC7En,
            RCRC16En         => RCRC16En,
            DataRxd          => DataRxd,
            RxFWrData        => RxFWrData
           );

-- -----------------------------------------------------------------------------
-- MmciTrPtoS instantiation
-- -----------------------------------------------------------------------------

uMmciTrPtoS : MmciTrPtoS
  port map (
            MMCICLK          => MMCICLKOUT,
            nMMCIRST         => inMMCIRST,
            ResponseBits     => ResponseBits,
            CmdEnable        => CmdEnable,
            CmdRespCnt       => CmdRespCnt,
            MMCITBCmdRespWr  => MMCITBCmdRespWr,
            MMCITBResp0Wr    => MMCITBResp0Wr,
            MMCITBResp1Wr    => MMCITBResp1Wr,
            MMCITBResp2Wr    => MMCITBResp2Wr,
            MMCITBResp3Wr    => MMCITBResp3Wr,
            CRC7             => CRC7,
            CrcBufferBit     => CrcBufferBit,
            CmdCrcErr        => CmdCrcErr,
            DataEn           => DataEn,
            DataDirection    => DataDirection,
            DataMode         => DataMode,
            DataLength       => DataLength,
            Blocklen         => Blocklen,
            MDCStg2WrEn      => MDCStg2WrEn,
            TxFRdData        => TxFRdData,
            CRC160           => CRC160,
            DCrcBufferBit    => DCrcBufferBit,
            DataTimeCnt      => DataTimeCnt,
            TokenTimeCnt     => TokenTimeCnt,
            BsyTimeCnt       => BsyTimeCnt,
            DataRxd          => DataRxd,
            TokenErrBit      => TokenErrBit,
            DataCrcErr       => DataCrcErr,
            SendResponse     => SendResponse,
            RxCommand        => RxCommand,
            PWDATAIn         => PWDATAIn,
            TokenSent        => TokenSent,
            TkCntOver        => TkCntOver,
            TxFRd            => TxFRd,
            TCRC7En          => TCRC7En,
            TCRC16En         => TCRC16En,
            BlkEnd           => BlkEnd,
            MMCICMD          => MMCICMD,
            MMCIDAT          => MMCIDAT
           );

-- -----------------------------------------------------------------------------
-- MmciTrChecker instantiation
-- -----------------------------------------------------------------------------

uMmciTrChecker : MmciTrChecker
  port map (
            MMCICLK          => MMCICLKOUT,
            nMMCIRST         => inMMCIRST,
            MMCIINTR0        => MMCIINTR0,
            MMCIINTR1        => MMCIINTR1,
            MMCIDMASREQ      => MMCIDMASREQ,
            MMCIDMABREQ      => MMCIDMABREQ,
            MMCIDMALSREQ     => MMCIDMALSREQ,
            MMCIDMALBREQ     => MMCIDMALBREQ,
            MMCIPWR          => MMCIPWR,
            MMCIVDD          => MMCIVDD,
            MMCIROD          => MMCIROD,
            MMCIPower        => MMCIPower,
            MMCIClock        => MMCIClock,
            MMCICommand      => MMCICommand,
            MMCIDataLength   => MMCIDataLength,
            MMCIDataCntl     => MMCIDataCntl,
            MMCITBCntl       => MMCITBCntl,
            MMCITBMCLKPeriod => MMCITBMCLKPeriod,
            DataCnt          => DataCnt,
            BitCnt           => BitCnt,
            MMCITBReTimWr    => MMCITBReTimWr,
            MMCITBDtTimWr    => MMCITBDtTimWr,
            MMCITBTokTimWr   => MMCITBTokTimWr,
            MMCITBBsyTimWr   => MMCITBBsyTimWr,
            MMCITBPCDisWr    => MMCITBPCDisWr,
            MMCITBStTimWr    => MMCITBStTimWr,
            MPUpdateSync     => MPUpdateSync,
            MCUpdateSync     => MCUpdateSync,
            MCMUpdateSync    => MCMUpdateSync,
            MDLUpdateSync    => MDLUpdateSync,
            MDCUpdateSync    => MDCUpdateSync,
            MTBCUpdateSync   => MTBCUpdateSync,
            TokenSent        => TokenSent,
            BlkEnd           => BlkEnd,
            MMCICMD          => MMCICMD,
            MMCIDAT          => MMCIDAT,
            PWDATAIn         => PWDATAIn,
            MMCITBSIGSTAT    => MMCITBSIGSTAT,
            ResponseBits     => ResponseBits,
            CmdEnable        => CmdEnable,
            DataEn           => DataEn,
            DataDirection    => DataDirection,
            DataMode         => DataMode,
            DataLength       => DataLength,
            Blocklen         => Blocklen,
            MDCStg2WrEn      => MDCStg2WrEn,
            CmdCrcErr        => CmdCrcErr,
            DataCrcErr       => DataCrcErr,
            TokenErrBit      => TokenErrBit,
            CmdRespCnt       => CmdRespCnt,
            DataTimeCnt      => DataTimeCnt,
            TokenTimeCnt     => TokenTimeCnt,
            BsyTimeCnt       => BsyTimeCnt,
            MMCIDMACLR       => MMCIDMACLR,
            FifoClear        => FifoClear,
            SendResponse     => SendResponse,
            RxCommand        => RxCommand
            );

-- -----------------------------------------------------------------------------
-- MmciTrMclkRsgen instantiation
-- -----------------------------------------------------------------------------

uMmciTrMclkRsgen : MmciTrMclkRsgen
  port map (
            PCLK             => PCLK,
            PRESETn          => PRESETn,
            MMCITBMCLKWr     => MMCITBMCLKWr,
            MMCITBCLKRSTWr   => MMCITBCLKRSTWr,
            PWDATAIn         => PWDATAIn,
            MCLK             => iMCLK,
            nMMCIRST         => inMMCIRST,
            MMCITBMCLKPeriod => MMCITBMCLKPeriod,
            PCLKOn           => PCLKOn,
            MCLKOn           => MCLKOn
           );

-- -----------------------------------------------------------------------------
-- MMCICMDBUS driven by bidirectional MMCICMD, command transfer in open
-- drain mode is interpreted as '1' when MMCICMD is 'Z'.
-- -----------------------------------------------------------------------------

MMCICMDBUS         <= '1' when (MMCICMD = 'Z' and MMCIPower(6) = '1')
                  else
                     '0' when (MMCICMD = '0' and MMCIPower(6) = '1')
                  else
                     MMCICMD;

-- -----------------------------------------------------------------------------
-- MMCIDATIn is fed to MmciTrStoP and it is driven with MMCIDAT line only
-- in the data reception case.
-- -----------------------------------------------------------------------------

MMCIDATIn          <= MMCIDAT when (DataDirection = '0' and
                                  TkCntOver = '0')
                  else
                     'Z';

end structural;

-- --================================== End ==================================--
