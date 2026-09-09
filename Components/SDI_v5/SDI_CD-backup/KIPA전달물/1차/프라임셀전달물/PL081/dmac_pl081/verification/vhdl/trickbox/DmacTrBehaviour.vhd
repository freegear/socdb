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
-- File Name              : DmacTrBehaviour.vhd.rca
-- File Revision          : 1.5
--
-- Release Information    : PrimeCell(TM)-PL081-REL1v0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           This block is the top level of the Behavioural DMAC.
--
-- --=========================================================================--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

-- -----------------------------------------------------------------------------

entity DmacTrBehaviour is
  port (
-- Inputs
        HCLK             : in    std_logic; -- AHB clock
        HRESETn          : in    std_logic; -- AHB reset
        HSELDMAC         : in    std_logic; -- Slave Select for DMAC
        HSELDMACTrSlave  : in    std_logic; -- Slave Select for Trickbox
        HWRITE           : in    std_logic; -- Transfer direction
        HTRANS           : in    std_logic; -- Type of transfer on AHB3
        HADDR            : in    std_logic_vector(20 downto 2);
                                            -- AHB3 address bus
        HSIZE            : in    std_logic_vector(2 downto 0);
                                            -- The width of the transfer on AHB3
        HWDATA           : in    std_logic_vector(31 downto 0);
                                            -- AHB3 address bus
        HREADYIN         : in    std_logic; -- Transfer done response
        HGRANTDMACM1     : in    std_logic; -- AHB bus grant for master1
        HGRANTDMACM2     : in    std_logic; -- AHB bus grant for master2
        HREADYINM1       : in    std_logic; -- Transfer done response from AHB1
        HREADYINM2       : in    std_logic; -- Transfer done response from AHB2
        HRESPM1          : in    std_logic_vector(1 downto 0);
                                            -- Transfer response from AHB1
        HRESPM2          : in    std_logic_vector(1 downto 0);
                                            -- Transfer response from AHB2
        HRDATAM1         : in    std_logic_vector(31 downto 0);
                                            -- Read Data from the AHB1
        HRDATAM2         : in    std_logic_vector(31 downto 0);
                                            -- Read Data from the AHB2
        DMACBREQ         : in    std_logic_vector(15 downto 0);
                                            -- DMAC burst transfer request
        DMACLBREQ        : in    std_logic_vector(15 downto 0);
                                            -- DMAC last burst transfer request
        DMACSREQ         : in    std_logic_vector(15 downto 0);
                                            -- DMAC single transfer request
        DMACLSREQ        : in    std_logic_vector(15 downto 0);
                                            -- DMAC last single transfer request
-- Outputs
        HREADYOUT        : out   std_logic; -- Transfer done response to AHB3
        HRESP            : out   std_logic_vector(1 downto 0);
                                            -- Transfer response to AHB3
        HBUSREQDMACM1    : out   std_logic; -- Bus req signal to the AHB Arb1
        HBUSREQDMACM2    : out   std_logic; -- Bus req signal to the AHB Arb2
        HLOCKDMACM1      : out   std_logic; -- Indicates locked transfer on AHB1
        HLOCKDMACM2      : out   std_logic; -- Indicates locked transfer on AHB2
        HTRANSM1         : out   std_logic_vector(1 downto 0);
                                            -- Type of transfer on AHB1
        HTRANSM2         : out   std_logic_vector(1 downto 0);
                                            -- Type of transfer on AHB2
        HADDRM1          : out   std_logic_vector(31 downto 0);
                                            -- AHB1 address bus
        HADDRM2          : out   std_logic_vector(31 downto 0);
                                            -- AHB2 address bus
        HSIZEM1          : out   std_logic_vector(2 downto 0);
                                            -- Width of transfer on AHB1
        HSIZEM2          : out   std_logic_vector(2 downto 0);
                                            -- Width of transfer on AHB2
        HBURSTM1         : out   std_logic_vector(2 downto 0);
                                            -- Burst length on AHB1
        HBURSTM2         : out   std_logic_vector(2 downto 0);
                                            -- Burst length on AHB2
        HPROTM1          : out   std_logic_vector(3 downto 0);
                                            -- Protection information on AHB1
        HPROTM2          : out   std_logic_vector(3 downto 0);
                                            -- Protection information on AHB2
        HWRITEM1         : out   std_logic; -- Transfer direction on AHB1
        HWRITEM2         : out   std_logic; -- Transfer direction on AHB2
        HWDATAM1         : out   std_logic_vector(31 downto 0);
                                            -- Write data to AHB1
        HWDATAM2         : out   std_logic_vector(31 downto 0);
                                            -- Write data to AHB2
        DMACCLR          : out   std_logic_vector(15 downto 0);
                                            -- DMAC request clear
        DMACTC           : out   std_logic_vector(15 downto 0);
                                            -- DMAC terminal count
        DMACINTERR       : out   std_logic; -- DMAC error interrupt request
        DMACINTTC        : out   std_logic; -- DMAC terminal count interrupt
        DMACINTR         : out   std_logic; -- DMAC combined interrupt request
        DmacTrEn         : out   std_logic; -- DMAC Trickbox Enable
        ReqConfig        : out   std_logic_vector(17 downto 0);
                                            -- Trickbox config Reg for Perp/Mem
        GrantCount0      : out   std_logic_vector(31 downto 0);
                                            -- Trickbox Grant Generation Reg
                                            -- used by AHB Arbiter0
        GrantCount1      : out   std_logic_vector(31 downto 0)
                                            -- Trickbox Grant Generation Reg
                                            -- used by AHB Arbiter1
       );
end DmacTrBehaviour;

-- -----------------------------------------------------------------------------
--
--                               DmacTrBehaviour
--                               ===============
--
-- -----------------------------------------------------------------------------
--
-- Overview
-- ========
--   This block is the top level of the DMAC Behaviour. This block instantiates
-- the following functional sub-blocks in the DMAC.
--      - DmacTrAhbSlaveIf
--      - DmacTrAhbMaster(2 instances)
--      - DmacTrIntArb(2 instances)
--      - DmacTrChLogic(8 instances)
--      - DmacTrRouter
--
-- -----------------------------------------------------------------------------


-- --=========================== ARCHITECTURE ================================--

architecture structural of DmacTrBehaviour is

-- -----------------------------------------------------------------------------
-- Component declarations
-- -----------------------------------------------------------------------------
component DmacTrAhbSlaveIf
  port (
        HCLK             : in    std_logic;
        HRESETn          : in    std_logic;
        HSELDMAC         : in    std_logic;
        HSELDMACTrSlave  : in    std_logic;
        HWRITE           : in    std_logic;
        HTRANS           : in    std_logic;
        HWDATA           : in    std_logic_vector(31 downto 0);
        HADDR            : in    std_logic_vector(20 downto 2);
        HSIZE            : in    std_logic_vector(2 downto 0);
        HREADYIN         : in    std_logic;
        SoftClr          : in    std_logic_vector(15 downto 0);
        DmacClr          : in    std_logic_vector(15 downto 0);
        DMACBREQ         : in    std_logic_vector(15 downto 0);
        DMACLBREQ        : in    std_logic_vector(15 downto 0);
        DMACSREQ         : in    std_logic_vector(15 downto 0);
        DMACLSREQ        : in    std_logic_vector(15 downto 0);
        HREADYOUT        : out   std_logic;
        HRESP            : out   std_logic_vector(1 downto 0);
        DmacSrcRegWrEn0  : out   std_logic;
        DmacDstRegWrEn0  : out   std_logic;
        DmacLLIRegWrEn0  : out   std_logic;
        DmacCntlRegWrEn0 : out   std_logic;
        DmacChCnfgWrEn0  : out   std_logic;
        DmacSrcRegWrEn1  : out   std_logic;
        DmacDstRegWrEn1  : out   std_logic;
        DmacLLIRegWrEn1  : out   std_logic;
        DmacCntlRegWrEn1 : out   std_logic;
        DmacChCnfgWrEn1  : out   std_logic;
        DmacSrcRegWrEn2  : out   std_logic;
        DmacDstRegWrEn2  : out   std_logic;
        DmacLLIRegWrEn2  : out   std_logic;
        DmacCntlRegWrEn2 : out   std_logic;
        DmacChCnfgWrEn2  : out   std_logic;
        DmacSrcRegWrEn3  : out   std_logic;
        DmacDstRegWrEn3  : out   std_logic;
        DmacLLIRegWrEn3  : out   std_logic;
        DmacCntlRegWrEn3 : out   std_logic;
        DmacChCnfgWrEn3  : out   std_logic;
        DmacSrcRegWrEn4  : out   std_logic;
        DmacDstRegWrEn4  : out   std_logic;
        DmacLLIRegWrEn4  : out   std_logic;
        DmacCntlRegWrEn4 : out   std_logic;
        DmacChCnfgWrEn4  : out   std_logic;
        DmacSrcRegWrEn5  : out   std_logic;
        DmacDstRegWrEn5  : out   std_logic;
        DmacLLIRegWrEn5  : out   std_logic;
        DmacCntlRegWrEn5 : out   std_logic;
        DmacChCnfgWrEn5  : out   std_logic;
        DmacSrcRegWrEn6  : out   std_logic;
        DmacDstRegWrEn6  : out   std_logic;
        DmacLLIRegWrEn6  : out   std_logic;
        DmacCntlRegWrEn6 : out   std_logic;
        DmacChCnfgWrEn6  : out   std_logic;
        DmacSrcRegWrEn7  : out   std_logic;
        DmacDstRegWrEn7  : out   std_logic;
        DmacLLIRegWrEn7  : out   std_logic;
        DmacCntlRegWrEn7 : out   std_logic;
        DmacChCnfgWrEn7  : out   std_logic;
        DMACBREQCh       : out   std_logic_vector(15 downto 0);
        DMACLBREQCh      : out   std_logic_vector(15 downto 0);
        DMACSREQCh       : out   std_logic_vector(15 downto 0);
        DMACLSREQCh      : out   std_logic_vector(15 downto 0);
        SOFTBREQCh       : out   std_logic_vector(15 downto 0);
        SOFTLBREQCh      : out   std_logic_vector(15 downto 0);
        SOFTSREQCh       : out   std_logic_vector(15 downto 0);
        SOFTLSREQCh      : out   std_logic_vector(15 downto 0);
        ClrIntErr        : out   std_logic_vector (7 downto 0);
        ClrIntTC         : out   std_logic_vector (7 downto 0);
        DMACEn           : out   std_logic;
        ReqConfig        : out   std_logic_vector(17 downto 0);
        GrantCount0      : out   std_logic_vector(31 downto 0);
        GrantCount1      : out   std_logic_vector(31 downto 0);
        DmacTrEn         : out   std_logic;
        MasterEndian1    : out   std_logic;
        MasterEndian2    : out   std_logic
       );
end component;

component DmacTrAhbMaster
  port (
        HCLK             : in    std_logic;
        HRESETn          : in    std_logic;
        HGRANTDMACM      : in    std_logic;
        HREADYINM        : in    std_logic;
        HRESPM           : in    std_logic_vector(1 downto 0);
        ChHLOCK          : in    std_logic;
        ChWRITE          : in    std_logic;
        ReqForAhbBus     : in    std_logic;
        ChHPROT          : in    std_logic_vector(3 downto 0);
        ChHSIZE          : in    std_logic_vector(2 downto 0);
        ChAddr           : in    std_logic_vector(31 downto 0);
        ChAddrIncr       : in    std_logic;
        ChDisable        : in    std_logic;
        ChPriority       : in    std_logic;
        ChBeatCount      : in    std_logic_vector(4 downto 0);
        HWDATA           : in    std_logic_vector(31 downto 0);
        HBUSREQDMACM     : out   std_logic;
        HLOCKDMACM       : out   std_logic;
        HPROTM           : out   std_logic_vector(3 downto 0);
        HBURSTM          : out   std_logic_vector(2 downto 0);
        HTRANSM          : out   std_logic_vector(1 downto 0);
        HADDRM           : out   std_logic_vector(31 downto 0);
        HSIZEM           : out   std_logic_vector(2 downto 0);
        HWRITEM          : out   std_logic;
        HWDATAM          : out   std_logic_vector(31 downto 0);
        DataValid        : out   std_logic;
        MREADY           : out   std_logic;
        DisAckMas        : out   std_logic;
        StopArb          : out   std_logic;
        ErrorMas         : out   std_logic
       );
end component;

component DmacTrIntArb
  port (
        HCLK             : in    std_logic;
        HRESETn          : in    std_logic;
        Ch0Req           : in    std_logic;
        Ch1Req           : in    std_logic;
        Ch2Req           : in    std_logic;
        Ch3Req           : in    std_logic;
        Ch4Req           : in    std_logic;
        Ch5Req           : in    std_logic;
        Ch6Req           : in    std_logic;
        Ch7Req           : in    std_logic;
        StopArb          : in    std_logic;
        Ch0HWDATA        : in    std_logic_vector(31 downto 0);
        Ch1HWDATA        : in    std_logic_vector(31 downto 0);
        Ch2HWDATA        : in    std_logic_vector(31 downto 0);
        Ch3HWDATA        : in    std_logic_vector(31 downto 0);
        Ch4HWDATA        : in    std_logic_vector(31 downto 0);
        Ch5HWDATA        : in    std_logic_vector(31 downto 0);
        Ch6HWDATA        : in    std_logic_vector(31 downto 0);
        Ch7HWDATA        : in    std_logic_vector(31 downto 0);
        ReqForAhbBus     : out   std_logic;
        HWDATA           : out   std_logic_vector(31 downto 0);
        Ch0Comb          : out   std_logic;
        Ch1Comb          : out   std_logic;
        Ch2Comb          : out   std_logic;
        Ch3Comb          : out   std_logic;
        Ch4Comb          : out   std_logic;
        Ch5Comb          : out   std_logic;
        Ch6Comb          : out   std_logic;
        Ch7Comb          : out   std_logic
       );
end component;

component DmacTrChLogic
  port (
        HCLK             : in    std_logic;
        HRESETn          : in    std_logic;
        ChComb1          : in    std_logic;
        ChComb2          : in    std_logic;
        ChSrcAddrWrEn    : in    std_logic;
        ChDstAddrWrEn    : in    std_logic;
        ChControlWrEn    : in    std_logic;
        ChLLIWrEn        : in    std_logic;
        ChConfigWrEn     : in    std_logic;
        HWDATA           : in    std_logic_vector(31 downto 0);
        HRDATAM1         : in    std_logic_vector(31 downto 0);
        HRDATAM2         : in    std_logic_vector(31 downto 0);
        DataValid1       : in    std_logic;
        DataValid2       : in    std_logic;
        MREADY1          : in    std_logic;
        MREADY2          : in    std_logic;
        ErrorMas1        : in    std_logic;
        ErrorMas2        : in    std_logic;
        DisAckMas1       : in    std_logic;
        DisAckMas2       : in    std_logic;
        MasterEndian1    : in    std_logic;
        MasterEndian2    : in    std_logic;
        DMACBREQ         : in    std_logic_vector(15 downto 0);
        DMACSREQ         : in    std_logic_vector(15 downto 0);
        DMACLBREQ        : in    std_logic_vector(15 downto 0);
        DMACLSREQ        : in    std_logic_vector(15 downto 0);
        SOFTBREQ         : in    std_logic_vector(15 downto 0);
        SOFTLBREQ        : in    std_logic_vector(15 downto 0);
        SOFTSREQ         : in    std_logic_vector(15 downto 0);
        SOFTLSREQ        : in    std_logic_vector(15 downto 0);
        DMACEn           : in    std_logic;
        DmacTrEn         : in    std_logic;
        ClrIntTC         : in    std_logic;
        ClrIntErr        : in    std_logic;
        ChReqArb1        : out   std_logic;
        ChReqArb2        : out   std_logic;
        ChDisableBus1    : out   std_logic;
        ChDisableBus2    : out   std_logic;
        HWDATA1          : out   std_logic_vector(31 downto 0);
        HWDATA2          : out   std_logic_vector(31 downto 0);
        ChAddrBus1       : out   std_logic_vector(31 downto 0);
        ChAddrBus2       : out   std_logic_vector(31 downto 0);
        ChHLockBus1      : out   std_logic;
        ChHLockBus2      : out   std_logic;
        ChHProtBus1      : out   std_logic_vector(3 downto 0);
        ChHProtBus2      : out   std_logic_vector(3 downto 0);
        ChBeatCntBus1    : out   std_logic_vector(4 downto 0);
        ChBeatCntBus2    : out   std_logic_vector(4 downto 0);
        ChAddrIncr1      : out   std_logic;
        ChAddrIncr2      : out   std_logic;
        ChWRITEBus1      : out   std_logic;
        ChWRITEBus2      : out   std_logic;
        ChHSIZEBus1      : out   std_logic_vector(2 downto 0);
        ChHSIZEBus2      : out   std_logic_vector(2 downto 0);
        ChIntTC          : out   std_logic;
        ChIntErr         : out   std_logic;
        SOFTCLR          : out   std_logic_vector(15 downto 0);
        DMACTC           : out   std_logic_vector(15 downto 0);
        DMACCLR          : out   std_logic_vector(15 downto 0)
       );
end component;

component DmacTrRouter
  port (
        HCLK             : in    std_logic;
        HRESETn          : in    std_logic;
        Ch0Arb1Comb      : in    std_logic;
        Ch1Arb1Comb      : in    std_logic;
        Ch2Arb1Comb      : in    std_logic;
        Ch3Arb1Comb      : in    std_logic;
        Ch4Arb1Comb      : in    std_logic;
        Ch5Arb1Comb      : in    std_logic;
        Ch6Arb1Comb      : in    std_logic;
        Ch7Arb1Comb      : in    std_logic;
        Ch0Arb2Comb      : in    std_logic;
        Ch1Arb2Comb      : in    std_logic;
        Ch2Arb2Comb      : in    std_logic;
        Ch3Arb2Comb      : in    std_logic;
        Ch4Arb2Comb      : in    std_logic;
        Ch5Arb2Comb      : in    std_logic;
        Ch6Arb2Comb      : in    std_logic;
        Ch7Arb2Comb      : in    std_logic;
        Ch0AddrBus1      : in    std_logic_vector(31 downto 0);
        Ch1AddrBus1      : in    std_logic_vector(31 downto 0);
        Ch2AddrBus1      : in    std_logic_vector(31 downto 0);
        Ch3AddrBus1      : in    std_logic_vector(31 downto 0);
        Ch4AddrBus1      : in    std_logic_vector(31 downto 0);
        Ch5AddrBus1      : in    std_logic_vector(31 downto 0);
        Ch6AddrBus1      : in    std_logic_vector(31 downto 0);
        Ch7AddrBus1      : in    std_logic_vector(31 downto 0);
        Ch0AddrBus2      : in    std_logic_vector(31 downto 0);
        Ch1AddrBus2      : in    std_logic_vector(31 downto 0);
        Ch2AddrBus2      : in    std_logic_vector(31 downto 0);
        Ch3AddrBus2      : in    std_logic_vector(31 downto 0);
        Ch4AddrBus2      : in    std_logic_vector(31 downto 0);
        Ch5AddrBus2      : in    std_logic_vector(31 downto 0);
        Ch6AddrBus2      : in    std_logic_vector(31 downto 0);
        Ch7AddrBus2      : in    std_logic_vector(31 downto 0);
        Ch0HProtBus1     : in    std_logic_vector(3 downto 0);
        Ch1HProtBus1     : in    std_logic_vector(3 downto 0);
        Ch2HProtBus1     : in    std_logic_vector(3 downto 0);
        Ch3HProtBus1     : in    std_logic_vector(3 downto 0);
        Ch4HProtBus1     : in    std_logic_vector(3 downto 0);
        Ch5HProtBus1     : in    std_logic_vector(3 downto 0);
        Ch6HProtBus1     : in    std_logic_vector(3 downto 0);
        Ch7HProtBus1     : in    std_logic_vector(3 downto 0);
        Ch0HProtBus2     : in    std_logic_vector(3 downto 0);
        Ch1HProtBus2     : in    std_logic_vector(3 downto 0);
        Ch2HProtBus2     : in    std_logic_vector(3 downto 0);
        Ch3HProtBus2     : in    std_logic_vector(3 downto 0);
        Ch4HProtBus2     : in    std_logic_vector(3 downto 0);
        Ch5HProtBus2     : in    std_logic_vector(3 downto 0);
        Ch6HProtBus2     : in    std_logic_vector(3 downto 0);
        Ch7HProtBus2     : in    std_logic_vector(3 downto 0);
        Ch0HLockBus1     : in    std_logic;
        Ch1HLockBus1     : in    std_logic;
        Ch2HLockBus1     : in    std_logic;
        Ch3HLockBus1     : in    std_logic;
        Ch4HLockBus1     : in    std_logic;
        Ch5HLockBus1     : in    std_logic;
        Ch6HLockBus1     : in    std_logic;
        Ch7HLockBus1     : in    std_logic;
        Ch0HLockBus2     : in    std_logic;
        Ch1HLockBus2     : in    std_logic;
        Ch2HLockBus2     : in    std_logic;
        Ch3HLockBus2     : in    std_logic;
        Ch4HLockBus2     : in    std_logic;
        Ch5HLockBus2     : in    std_logic;
        Ch6HLockBus2     : in    std_logic;
        Ch7HLockBus2     : in    std_logic;
        Ch0AddrIncBus1   : in    std_logic;
        Ch1AddrIncBus1   : in    std_logic;
        Ch2AddrIncBus1   : in    std_logic;
        Ch3AddrIncBus1   : in    std_logic;
        Ch4AddrIncBus1   : in    std_logic;
        Ch5AddrIncBus1   : in    std_logic;
        Ch6AddrIncBus1   : in    std_logic;
        Ch7AddrIncBus1   : in    std_logic;
        Ch0AddrIncBus2   : in    std_logic;
        Ch1AddrIncBus2   : in    std_logic;
        Ch2AddrIncBus2   : in    std_logic;
        Ch3AddrIncBus2   : in    std_logic;
        Ch4AddrIncBus2   : in    std_logic;
        Ch5AddrIncBus2   : in    std_logic;
        Ch6AddrIncBus2   : in    std_logic;
        Ch7AddrIncBus2   : in    std_logic;
        Ch0DisableBus1   : in    std_logic;
        Ch1DisableBus1   : in    std_logic;
        Ch2DisableBus1   : in    std_logic;
        Ch3DisableBus1   : in    std_logic;
        Ch4DisableBus1   : in    std_logic;
        Ch5DisableBus1   : in    std_logic;
        Ch6DisableBus1   : in    std_logic;
        Ch7DisableBus1   : in    std_logic;
        Ch0DisableBus2   : in    std_logic;
        Ch1DisableBus2   : in    std_logic;
        Ch2DisableBus2   : in    std_logic;
        Ch3DisableBus2   : in    std_logic;
        Ch4DisableBus2   : in    std_logic;
        Ch5DisableBus2   : in    std_logic;
        Ch6DisableBus2   : in    std_logic;
        Ch7DisableBus2   : in    std_logic;
        Ch0BeatCntBus1   : in    std_logic_vector(4 downto 0);
        Ch1BeatCntBus1   : in    std_logic_vector(4 downto 0);
        Ch2BeatCntBus1   : in    std_logic_vector(4 downto 0);
        Ch3BeatCntBus1   : in    std_logic_vector(4 downto 0);
        Ch4BeatCntBus1   : in    std_logic_vector(4 downto 0);
        Ch5BeatCntBus1   : in    std_logic_vector(4 downto 0);
        Ch6BeatCntBus1   : in    std_logic_vector(4 downto 0);
        Ch7BeatCntBus1   : in    std_logic_vector(4 downto 0);
        Ch0BeatCntBus2   : in    std_logic_vector(4 downto 0);
        Ch1BeatCntBus2   : in    std_logic_vector(4 downto 0);
        Ch2BeatCntBus2   : in    std_logic_vector(4 downto 0);
        Ch3BeatCntBus2   : in    std_logic_vector(4 downto 0);
        Ch4BeatCntBus2   : in    std_logic_vector(4 downto 0);
        Ch5BeatCntBus2   : in    std_logic_vector(4 downto 0);
        Ch6BeatCntBus2   : in    std_logic_vector(4 downto 0);
        Ch7BeatCntBus2   : in    std_logic_vector(4 downto 0);
        Ch0WriteBus1     : in    std_logic;
        Ch1WriteBus1     : in    std_logic;
        Ch2WriteBus1     : in    std_logic;
        Ch3WriteBus1     : in    std_logic;
        Ch4WriteBus1     : in    std_logic;
        Ch5WriteBus1     : in    std_logic;
        Ch6WriteBus1     : in    std_logic;
        Ch7WriteBus1     : in    std_logic;
        Ch0WriteBus2     : in    std_logic;
        Ch1WriteBus2     : in    std_logic;
        Ch2WriteBus2     : in    std_logic;
        Ch3WriteBus2     : in    std_logic;
        Ch4WriteBus2     : in    std_logic;
        Ch5WriteBus2     : in    std_logic;
        Ch6WriteBus2     : in    std_logic;
        Ch7WriteBus2     : in    std_logic;
        Ch0HSIZEBus1     : in    std_logic_vector(2 downto 0);
        Ch1HSIZEBus1     : in    std_logic_vector(2 downto 0);
        Ch2HSIZEBus1     : in    std_logic_vector(2 downto 0);
        Ch3HSIZEBus1     : in    std_logic_vector(2 downto 0);
        Ch4HSIZEBus1     : in    std_logic_vector(2 downto 0);
        Ch5HSIZEBus1     : in    std_logic_vector(2 downto 0);
        Ch6HSIZEBus1     : in    std_logic_vector(2 downto 0);
        Ch7HSIZEBus1     : in    std_logic_vector(2 downto 0);
        Ch0HSIZEBus2     : in    std_logic_vector(2 downto 0);
        Ch1HSIZEBus2     : in    std_logic_vector(2 downto 0);
        Ch2HSIZEBus2     : in    std_logic_vector(2 downto 0);
        Ch3HSIZEBus2     : in    std_logic_vector(2 downto 0);
        Ch4HSIZEBus2     : in    std_logic_vector(2 downto 0);
        Ch5HSIZEBus2     : in    std_logic_vector(2 downto 0);
        Ch6HSIZEBus2     : in    std_logic_vector(2 downto 0);
        Ch7HSIZEBus2     : in    std_logic_vector(2 downto 0);
        StopArb1         : in    std_logic;
        StopArb2         : in    std_logic;
        Ch0SOFTCLR       : in    std_logic_vector(15 downto 0);
        Ch1SOFTCLR       : in    std_logic_vector(15 downto 0);
        Ch2SOFTCLR       : in    std_logic_vector(15 downto 0);
        Ch3SOFTCLR       : in    std_logic_vector(15 downto 0);
        Ch4SOFTCLR       : in    std_logic_vector(15 downto 0);
        Ch5SOFTCLR       : in    std_logic_vector(15 downto 0);
        Ch6SOFTCLR       : in    std_logic_vector(15 downto 0);
        Ch7SOFTCLR       : in    std_logic_vector(15 downto 0);
        Ch0DMACTC        : in    std_logic_vector(15 downto 0);
        Ch1DMACTC        : in    std_logic_vector(15 downto 0);
        Ch2DMACTC        : in    std_logic_vector(15 downto 0);
        Ch3DMACTC        : in    std_logic_vector(15 downto 0);
        Ch4DMACTC        : in    std_logic_vector(15 downto 0);
        Ch5DMACTC        : in    std_logic_vector(15 downto 0);
        Ch6DMACTC        : in    std_logic_vector(15 downto 0);
        Ch7DMACTC        : in    std_logic_vector(15 downto 0);
        Ch0DMACCLR       : in    std_logic_vector(15 downto 0);
        Ch1DMACCLR       : in    std_logic_vector(15 downto 0);
        Ch2DMACCLR       : in    std_logic_vector(15 downto 0);
        Ch3DMACCLR       : in    std_logic_vector(15 downto 0);
        Ch4DMACCLR       : in    std_logic_vector(15 downto 0);
        Ch5DMACCLR       : in    std_logic_vector(15 downto 0);
        Ch6DMACCLR       : in    std_logic_vector(15 downto 0);
        Ch7DMACCLR       : in    std_logic_vector(15 downto 0);
        ChHLOCKBus1      : out   std_logic;
        ChHLOCKBus2      : out   std_logic;
        ChWRITEBus1      : out   std_logic;
        ChWRITEBus2      : out   std_logic;
        ChAddrIncrBus1   : out   std_logic;
        ChAddrIncrBus2   : out   std_logic;
        ChDisableBus1    : out   std_logic;
        ChDisableBus2    : out   std_logic;
        ChPriorityBus1   : out   std_logic;
        ChPriorityBus2   : out   std_logic;
        ChHProtBus1      : out   std_logic_vector(3 downto 0);
        ChHProtBus2      : out   std_logic_vector(3 downto 0);
        ChHSIZEBus1      : out   std_logic_vector(2 downto 0);
        ChHSIZEBus2      : out   std_logic_vector(2 downto 0);
        ChAddrBus1       : out   std_logic_vector(31 downto 0);
        ChAddrBus2       : out   std_logic_vector(31 downto 0);
        ChBeatCountBus1  : out   std_logic_vector(4 downto 0);
        ChBeatCountBus2  : out   std_logic_vector(4 downto 0);
        SOFTCLR          : out   std_logic_vector(15 downto 0);
        DMACCLR          : out   std_logic_vector(15 downto 0);
        DMACTC           : out   std_logic_vector(15 downto 0)
       );
end component;

-- -----------------------------------------------------------------------------
-- Constant declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Signal declarations
-- -----------------------------------------------------------------------------
signal DmacSrcRegWrEn0  : std_logic;
-- Write Enable for DMACC0SrcAddr

signal DmacDstRegWrEn0  : std_logic;
-- Write Enable for DMACC0DestAddr

signal DmacLLIRegWrEn0  : std_logic;
-- Write Enable for DMACC0LLIReg

signal DmacCntlRegWrEn0 : std_logic;
-- Write Enable for DMACC0Control

signal DmacChCnfgWrEn0  : std_logic;
-- Write Enable for DMACC0Config

signal DmacSrcRegWrEn1  : std_logic;
-- Write Enable for DMACC1SrcAddr

signal DmacDstRegWrEn1  : std_logic;
-- Write Enable for DMACC1DestAddr

signal DmacLLIRegWrEn1  : std_logic;
-- Write Enable for DMACC1LLIReg

signal DmacCntlRegWrEn1 : std_logic;
-- Write Enable for DMACC1Control

signal DmacChCnfgWrEn1  : std_logic;
-- Write Enable for DMACC1Config

signal DmacSrcRegWrEn2  : std_logic;
-- Write Enable for DMACC2SrcAddr

signal DmacDstRegWrEn2  : std_logic;
-- Write Enable for DMACC2DestAddr

signal DmacLLIRegWrEn2  : std_logic;
-- Write Enable for DMACC2LLIReg

signal DmacCntlRegWrEn2 : std_logic;
-- Write Enable for DMACC2Control

signal DmacChCnfgWrEn2  : std_logic;
-- Write Enable for DMACC2Config

signal DmacSrcRegWrEn3  : std_logic;
-- Write Enable for DMACC3SrcAddr

signal DmacDstRegWrEn3  : std_logic;
-- Write Enable for DMACC3DestAddr

signal DmacLLIRegWrEn3  : std_logic;
-- Write Enable for DMACC3LLIReg

signal DmacCntlRegWrEn3 : std_logic;
-- Write Enable for DMACC3Control

signal DmacChCnfgWrEn3  : std_logic;
-- Write Enable for DMACC3Config

signal DmacSrcRegWrEn4  : std_logic;
-- Write Enable for DMACC4SrcAddr

signal DmacDstRegWrEn4  : std_logic;
-- Write Enable for DMACC4DestAddr

signal DmacLLIRegWrEn4  : std_logic;
-- Write Enable for DMACC4LLIReg

signal DmacCntlRegWrEn4 : std_logic;
-- Write Enable for DMACC4Control

signal DmacChCnfgWrEn4  : std_logic;
-- Write Enable for DMACC4Config

signal DmacSrcRegWrEn5  : std_logic;
-- Write Enable for DMACC5SrcAddr

signal DmacDstRegWrEn5  : std_logic;
-- Write Enable for DMACC5DestAddr

signal DmacLLIRegWrEn5  : std_logic;
-- Write Enable for DMACC5LLIReg

signal DmacCntlRegWrEn5 : std_logic;
-- Write Enable for DMACC5Control

signal DmacChCnfgWrEn5  : std_logic;
-- Write Enable for DMACC5Config

signal DmacSrcRegWrEn6  : std_logic;
-- Write Enable for DMACC6SrcAddr

signal DmacDstRegWrEn6  : std_logic;
-- Write Enable for DMACC6DestAddr

signal DmacLLIRegWrEn6  : std_logic;
-- Write Enable for DMACC6LLIReg

signal DmacCntlRegWrEn6 : std_logic;
-- Write Enable for DMACC6Control

signal DmacChCnfgWrEn6  : std_logic;
-- Write Enable for DMACC6Config

signal DmacSrcRegWrEn7  : std_logic;
-- Write Enable for DMACC7SrcAddr

signal DmacDstRegWrEn7  : std_logic;
-- Write Enable for DMACC7DestAddr

signal DmacLLIRegWrEn7  : std_logic;
-- Write Enable for DMACC7LLIReg

signal DmacCntlRegWrEn7 : std_logic;
-- Write Enable for DMACC7Control

signal DmacChCnfgWrEn7  : std_logic;
-- Write Enable for DMACC7Config

signal DMACBREQCh       : std_logic_vector(15 downto 0);
-- DMA burst transfer request

signal DMACLBREQCh      : std_logic_vector(15 downto 0);
-- DMAC last burst transfer request

signal DMACSREQCh       : std_logic_vector(15 downto 0);
-- DMAC single transfer request

signal DMACLSREQCh      : std_logic_vector(15 downto 0);
-- DMAC last single transfer request

signal SOFTBREQCh       : std_logic_vector(15 downto 0);
-- Soft burst transfer request

signal SOFTLBREQCh      : std_logic_vector(15 downto 0);
-- Soft last burst transfer request

signal SOFTSREQCh       : std_logic_vector(15 downto 0);
-- Soft single transfer request

signal SOFTLSREQCh      : std_logic_vector(15 downto 0);
-- Soft last single transfer request

signal ClrIntErr        : std_logic_vector(7 downto 0);
-- DMAC error interrupt

signal ClrIntTC         : std_logic_vector(7 downto 0);
-- DMAC terminal count interrupt

signal DMACEn           : std_logic;
-- DMAC Controller Enable

signal MasterEndian1    : std_logic;
-- Endianness bit for master 1

signal MasterEndian2    : std_logic;
-- Endianness bit for master 2

signal Ch0ReqArb1       : std_logic;
-- Channel0 req to Arbiter1

signal Ch1ReqArb1       : std_logic;
-- Channel1 req to Arbiter1

signal Ch2ReqArb1       : std_logic;
-- Channel2 req to Arbiter1

signal Ch3ReqArb1       : std_logic;
-- Channel3 req to Arbiter1

signal Ch4ReqArb1       : std_logic;
-- Channel4 req to Arbiter1

signal Ch5ReqArb1       : std_logic;
-- Channel5 req to Arbiter1

signal Ch6ReqArb1       : std_logic;
-- Channel6 req to Arbiter1

signal Ch7ReqArb1       : std_logic;
-- Channel7 req to Arbiter1

signal Ch0ReqArb2       : std_logic;
-- Channel0 req to Arbiter2

signal Ch1ReqArb2       : std_logic;
-- Channel1 req to Arbiter2

signal Ch2ReqArb2       : std_logic;
-- Channel2 req to Arbiter2

signal Ch3ReqArb2       : std_logic;
-- Channel3 req to Arbiter2

signal Ch4ReqArb2       : std_logic;
-- Channel4 req to Arbiter2

signal Ch5ReqArb2       : std_logic;
-- Channel5 req to Arbiter2

signal Ch6ReqArb2       : std_logic;
-- Channel6 req to Arbiter2

signal Ch7ReqArb2       : std_logic;
-- Channel7 req to Arbiter2

signal DataValidBus1    : std_logic;
-- DataValid info for Channel from Master1

signal DataValidBus2    : std_logic;
-- DataValid info for Channel from Master2

signal Ch0HWDATABus1    : std_logic_vector(31 downto 0);
-- AHB Write Data Bus1 from Channel0

signal Ch1HWDATABus1    : std_logic_vector(31 downto 0);
-- AHB Write Data Bus1 from Channel1

signal Ch2HWDATABus1    : std_logic_vector(31 downto 0);
-- AHB Write Data Bus1 from Channel2

signal Ch3HWDATABus1    : std_logic_vector(31 downto 0);
-- AHB Write Data Bus1 from Channel3

signal Ch4HWDATABus1    : std_logic_vector(31 downto 0);
-- AHB Write Data Bus1 from Channel4

signal Ch5HWDATABus1    : std_logic_vector(31 downto 0);
-- AHB Write Data Bus1 from Channel5

signal Ch6HWDATABus1    : std_logic_vector(31 downto 0);
-- AHB Write Data Bus1 from Channel6

signal Ch7HWDATABus1    : std_logic_vector(31 downto 0);
-- AHB Write Data Bus1 from Channel7

signal Ch0HWDATABus2    : std_logic_vector(31 downto 0);
-- AHB Write Data Bus2 from Channel0

signal Ch1HWDATABus2    : std_logic_vector(31 downto 0);
-- AHB Write Data Bus2 from Channel1

signal Ch2HWDATABus2    : std_logic_vector(31 downto 0);
-- AHB Write Data Bus2 from Channel2

signal Ch3HWDATABus2    : std_logic_vector(31 downto 0);
-- AHB Write Data Bus2 from Channel3

signal Ch4HWDATABus2    : std_logic_vector(31 downto 0);
-- AHB Write Data Bus2 from Channel4

signal Ch5HWDATABus2    : std_logic_vector(31 downto 0);
-- AHB Write Data Bus2 from Channel5

signal Ch6HWDATABus2    : std_logic_vector(31 downto 0);
-- AHB Write Data Bus2 from Channel6

signal Ch7HWDATABus2    : std_logic_vector(31 downto 0);
-- AHB Write Data Bus2 from Channel7

signal ReqForAhbBus1    : std_logic;
-- Indication for Master Interface to put request on Bus1

signal ReqForAhbBus2    : std_logic;
-- Indication for Master Interface to put request on Bus2

signal HWDATABus1       : std_logic_vector(31 downto 0);
-- AHB Write Data bus1

signal HWDATABus2       : std_logic_vector(31 downto 0);
-- AHB Write Data bus1

signal Ch0CombBus1      : std_logic;
-- Channel0 selected(1HCLK Wide)

signal Ch1CombBus1      : std_logic;
-- Channel1 selected(1HCLK Wide)

signal Ch2CombBus1      : std_logic;
-- Channel2 selected(1HCLK Wide)

signal Ch3CombBus1      : std_logic;
-- Channel3 selected(1HCLK Wide)

signal Ch4CombBus1      : std_logic;
-- Channel4 selected(1HCLK Wide)

signal Ch5CombBus1      : std_logic;
-- Channel5 selected(1HCLK Wide)

signal Ch6CombBus1      : std_logic;
-- Channel6 selected(1HCLK Wide)

signal Ch7CombBus1      : std_logic;
-- Channel7 selected(1HCLK Wide)

signal Ch0CombBus2      : std_logic;
-- Channel0 selected(1HCLK Wide)

signal Ch1CombBus2      : std_logic;
-- Channel1 selected(1HCLK Wide)

signal Ch2CombBus2      : std_logic;
-- Channel2 selected(1HCLK Wide)

signal Ch3CombBus2      : std_logic;
-- Channel3 selected(1HCLK Wide)

signal Ch4CombBus2      : std_logic;
-- Channel4 selected(1HCLK Wide)

signal Ch5CombBus2      : std_logic;
-- Channel5 selected(1HCLK Wide)

signal Ch6CombBus2      : std_logic;
-- Channel6 selected(1HCLK Wide)

signal Ch7CombBus2      : std_logic;
-- Channel7 selected(1HCLK Wide)

signal SOFTCLR          : std_logic_vector(15 downto 0);
-- DMAC SoftReq Clear

signal iDMACCLR         : std_logic_vector(15 downto 0);
-- Internal copy of DMAC Clear

signal ChHLOCKBus1      : std_logic;
-- HLOCK for Bus1

signal ChHLOCKBus2      : std_logic;
-- HLOCK for Bus2

signal ChWRITEBus1      : std_logic;
-- HWRITE for Bus1

signal ChWRITEBus2      : std_logic;
-- HWRITE for Bus2

signal ChHProtBus1      : std_logic_vector(3 downto 0);
-- HPROT for Bus1

signal ChHProtBus2      : std_logic_vector(3 downto 0);
-- HPROT for Bus2

signal ChHSIZEBus1      : std_logic_vector(2 downto 0);
-- HSIZE for Bus1

signal ChHSIZEBus2      : std_logic_vector(2 downto 0);
-- HSIZE for Bus2

signal ChAddrBus1       : std_logic_vector(31 downto 0);
-- Channel Address for Bus1

signal ChAddrBus2       : std_logic_vector(31 downto 0);
-- Channel Address for Bus1

signal ChAddrIncrBus1   : std_logic;
-- Channel Addr Increment for Bus1

signal ChAddrIncrBus2   : std_logic;
-- Channel Addr Increment for Bus2

signal ChDisableBus1    : std_logic;
-- Channel disable for Mas1

signal ChDisableBus2    : std_logic;
-- Channel disable for Mas2

signal ChPriorityBus1   : std_logic;
-- Channel priority for Mas1

signal ChPriorityBus2   : std_logic;
-- Channel priority for Mas2

signal ChBeatCountBus1  : std_logic_vector(4 downto 0);
-- BeatCount for Mas1

signal ChBeatCountBus2  : std_logic_vector(4 downto 0);
-- BeatCount for Mas2

signal DisAckMas1       : std_logic;
-- Channel Disable Acknowledge from Master1

signal DisAckMas2       : std_logic;
-- Channel Disable Acknowledge from Master2

signal StopArb1         : std_logic;
-- Stop Arbitration indication from Master1

signal StopArb2         : std_logic;
-- Stop Arbitration indication from Master2

signal ErrorMas1        : std_logic;
-- Error on Master1

signal ErrorMas2        : std_logic;
-- Error on Master1

signal MREADY1          : std_logic;
-- MREADY from Master1

signal MREADY2          : std_logic;
-- MREADY from Master2

signal Ch0DisableBus1   : std_logic;
-- Channel0 Disable for Bus1

signal Ch0DisableBus2   : std_logic;
-- Channel0 Disable for Bus2

signal Ch1DisableBus1   : std_logic;
-- Channel1 Disable for Bus1

signal Ch1DisableBus2   : std_logic;
-- Channel1 Disable for Bus2

signal Ch2DisableBus1   : std_logic;
-- Channel2 Disable for Bus1

signal Ch2DisableBus2   : std_logic;
-- Channel2 Disable for Bus2

signal Ch3DisableBus1   : std_logic;
-- Channel3 Disable for Bus1

signal Ch3DisableBus2   : std_logic;
-- Channel3 Disable for Bus2

signal Ch4DisableBus1   : std_logic;
-- Channel4 Disable for Bus1

signal Ch4DisableBus2   : std_logic;
-- Channel4 Disable for Bus2

signal Ch5DisableBus1   : std_logic;
-- Channel5 Disable for Bus1

signal Ch5DisableBus2   : std_logic;
-- Channel5 Disable for Bus2

signal Ch6DisableBus1   : std_logic;
-- Channel6 Disable for Bus1

signal Ch6DisableBus2   : std_logic;
-- Channel6 Disable for Bus2

signal Ch7DisableBus1   : std_logic;
-- Channel0 Disable for Bus1

signal Ch7DisableBus2   : std_logic;
-- Channel0 Disable for Bus2

signal Ch0AddrBus1      : std_logic_vector(31 downto 0);
-- Channel0 Address on Bus1

signal Ch0AddrBus2      : std_logic_vector(31 downto 0);
-- Channel0 Address on Bus2

signal Ch1AddrBus1      : std_logic_vector(31 downto 0);
-- Channel1 Address on Bus1

signal Ch1AddrBus2      : std_logic_vector(31 downto 0);
-- Channel1 Address on Bus2

signal Ch2AddrBus1      : std_logic_vector(31 downto 0);
-- Channel2 Address on Bus1

signal Ch2AddrBus2      : std_logic_vector(31 downto 0);
-- Channel2 Address on Bus2

signal Ch3AddrBus1      : std_logic_vector(31 downto 0);
-- Channel3 Address on Bus1

signal Ch3AddrBus2      : std_logic_vector(31 downto 0);
-- Channel3 Address on Bus2

signal Ch4AddrBus1      : std_logic_vector(31 downto 0);
-- Channel4 Address on Bus1

signal Ch4AddrBus2      : std_logic_vector(31 downto 0);
-- Channel4 Address on Bus2

signal Ch5AddrBus1      : std_logic_vector(31 downto 0);
-- Channel5 Address on Bus1

signal Ch5AddrBus2      : std_logic_vector(31 downto 0);
-- Channel5 Address on Bus2

signal Ch6AddrBus1      : std_logic_vector(31 downto 0);
-- Channel6 Address on Bus1

signal Ch6AddrBus2      : std_logic_vector(31 downto 0);
-- Channel6 Address on Bus2

signal Ch7AddrBus1      : std_logic_vector(31 downto 0);
-- Channel7 Address on Bus1

signal Ch7AddrBus2      : std_logic_vector(31 downto 0);
-- Channel7 Address on Bus2

signal Ch0HLockBus1     : std_logic;
-- Channel0 Lock on Bus1

signal Ch0HLockBus2     : std_logic;
-- Channel0 Lock on Bus2

signal Ch1HLockBus1     : std_logic;
-- Channel1 Lock on Bus1

signal Ch1HLockBus2     : std_logic;
-- Channel1 Lock on Bus2

signal Ch2HLockBus1     : std_logic;
-- Channel2 Lock on Bus1

signal Ch2HLockBus2     : std_logic;
-- Channel2 Lock on Bus2

signal Ch3HLockBus1     : std_logic;
-- Channel3 Lock on Bus1

signal Ch3HLockBus2     : std_logic;
-- Channel3 Lock on Bus2

signal Ch4HLockBus1     : std_logic;
-- Channel4 Lock on Bus1

signal Ch4HLockBus2     : std_logic;
-- Channel4 Lock on Bus2

signal Ch5HLockBus1     : std_logic;
-- Channel5 Lock on Bus1

signal Ch5HLockBus2     : std_logic;
-- Channel5 Lock on Bus2

signal Ch6HLockBus1     : std_logic;
-- Channel6 Lock on Bus1

signal Ch6HLockBus2     : std_logic;
-- Channel6 Lock on Bus2

signal Ch7HLockBus1     : std_logic;
-- Channel7 Lock on Bus1

signal Ch7HLockBus2     : std_logic;
-- Channel7 Lock on Bus2

signal Ch0HProtBus1     : std_logic_vector(3 downto 0);
-- Channel0 HPROT inf on Bus1

signal Ch0HProtBus2     : std_logic_vector(3 downto 0);
-- Channel0 HPROT inf on Bus2

signal Ch1HProtBus1     : std_logic_vector(3 downto 0);
-- Channel1 HPROT inf on Bus1

signal Ch1HProtBus2     : std_logic_vector(3 downto 0);
-- Channel1 HPROT inf on Bus2

signal Ch2HProtBus1     : std_logic_vector(3 downto 0);
-- Channel2 HPROT inf on Bus1

signal Ch2HProtBus2     : std_logic_vector(3 downto 0);
-- Channel2 HPROT inf on Bus2

signal Ch3HProtBus1     : std_logic_vector(3 downto 0);
-- Channel3 HPROT inf on Bus1

signal Ch3HProtBus2     : std_logic_vector(3 downto 0);
-- Channel3 HPROT inf on Bus2

signal Ch4HProtBus1     : std_logic_vector(3 downto 0);
-- Channel4 HPROT inf on Bus1

signal Ch4HProtBus2     : std_logic_vector(3 downto 0);
-- Channel4 HPROT inf on Bus2

signal Ch5HProtBus1     : std_logic_vector(3 downto 0);
-- Channel5 HPROT inf on Bus1

signal Ch5HProtBus2     : std_logic_vector(3 downto 0);
-- Channel5 HPROT inf on Bus2

signal Ch6HProtBus1     : std_logic_vector(3 downto 0);
-- Channel6 HPROT inf on Bus1

signal Ch6HProtBus2     : std_logic_vector(3 downto 0);
-- Channel6 HPROT inf on Bus2

signal Ch7HProtBus1     : std_logic_vector(3 downto 0);
-- Channel7 HPROT inf on Bus1

signal Ch7HProtBus2     : std_logic_vector(3 downto 0);
-- Channel7 HPROT inf on Bus2

signal Ch0BeatCntBus1   : std_logic_vector(4 downto 0);
-- Channel0 BeatCount for Bus1

signal Ch0BeatCntBus2   : std_logic_vector(4 downto 0);
-- Channel0 BeatCount for Bus2

signal Ch1BeatCntBus1   : std_logic_vector(4 downto 0);
-- Channel1 BeatCount for Bus1

signal Ch1BeatCntBus2   : std_logic_vector(4 downto 0);
-- Channel1 BeatCount for Bus2

signal Ch2BeatCntBus1   : std_logic_vector(4 downto 0);
-- Channel2 BeatCount for Bus1

signal Ch2BeatCntBus2   : std_logic_vector(4 downto 0);
-- Channel2 BeatCount for Bus2

signal Ch3BeatCntBus1   : std_logic_vector(4 downto 0);
-- Channel3 BeatCount for Bus1

signal Ch3BeatCntBus2   : std_logic_vector(4 downto 0);
-- Channel3 BeatCount for Bus2

signal Ch4BeatCntBus1   : std_logic_vector(4 downto 0);
-- Channel4 BeatCount for Bus1

signal Ch4BeatCntBus2   : std_logic_vector(4 downto 0);
-- Channel4 BeatCount for Bus2

signal Ch5BeatCntBus1   : std_logic_vector(4 downto 0);
-- Channel5 BeatCount for Bus1

signal Ch5BeatCntBus2   : std_logic_vector(4 downto 0);
-- Channel5 BeatCount for Bus2

signal Ch6BeatCntBus1   : std_logic_vector(4 downto 0);
-- Channel6 BeatCount for Bus1

signal Ch6BeatCntBus2   : std_logic_vector(4 downto 0);
-- Channel6 BeatCount for Bus2

signal Ch7BeatCntBus1   : std_logic_vector(4 downto 0);
-- Channel7 BeatCount for Bus1

signal Ch7BeatCntBus2   : std_logic_vector(4 downto 0);
-- Channel7 BeatCount for Bus2

signal Ch0AddrIncBus1   : std_logic;
-- Channel0 Address Incr on Bus1

signal Ch0AddrIncBus2   : std_logic;
-- Channel0 Address Incr on Bus2

signal Ch1AddrIncBus1   : std_logic;
-- Channel1 Address Incr on Bus1

signal Ch1AddrIncBus2   : std_logic;
-- Channel1 Address Incr on Bus2

signal Ch2AddrIncBus1   : std_logic;
-- Channel2 Address Incr on Bus1

signal Ch2AddrIncBus2   : std_logic;
-- Channel2 Address Incr on Bus2

signal Ch3AddrIncBus1   : std_logic;
-- Channel3 Address Incr on Bus1

signal Ch3AddrIncBus2   : std_logic;
-- Channel3 Address Incr on Bus2

signal Ch4AddrIncBus1   : std_logic;
-- Channel4 Address Incr on Bus1

signal Ch4AddrIncBus2   : std_logic;
-- Channel4 Address Incr on Bus2

signal Ch5AddrIncBus1   : std_logic;
-- Channel5 Address Incr on Bus1

signal Ch5AddrIncBus2   : std_logic;
-- Channel5 Address Incr on Bus2

signal Ch6AddrIncBus1   : std_logic;
-- Channel6 Address Incr on Bus1

signal Ch6AddrIncBus2   : std_logic;
-- Channel6 Address Incr on Bus2

signal Ch7AddrIncBus1   : std_logic;
-- Channel7 Address Incr on Bus1

signal Ch7AddrIncBus2   : std_logic;
-- Channel7 Address Incr on Bus2

signal Ch0WriteBus1     : std_logic;
-- Channel0 HWRITE for Bus1

signal Ch0WriteBus2     : std_logic;
-- Channel0 HWRITE for Bus2

signal Ch1WriteBus1     : std_logic;
-- Channel1 HWRITE for Bus1

signal Ch1WriteBus2     : std_logic;
-- Channel1 HWRITE for Bus2

signal Ch2WriteBus1     : std_logic;
-- Channel2 HWRITE for Bus1

signal Ch2WriteBus2     : std_logic;
-- Channel2 HWRITE for Bus2

signal Ch3WriteBus1     : std_logic;
-- Channel3 HWRITE for Bus1

signal Ch3WriteBus2     : std_logic;
-- Channel3 HWRITE for Bus2

signal Ch4WriteBus1     : std_logic;
-- Channel4 HWRITE for Bus1

signal Ch4WriteBus2     : std_logic;
-- Channel4 HWRITE for Bus2

signal Ch5WriteBus1     : std_logic;
-- Channel5 HWRITE for Bus1

signal Ch5WriteBus2     : std_logic;
-- Channel5 HWRITE for Bus2

signal Ch6WriteBus1     : std_logic;
-- Channel6 HWRITE for Bus1

signal Ch6WriteBus2     : std_logic;
-- Channel6 HWRITE for Bus2

signal Ch7WriteBus1     : std_logic;
-- Channel7 HWRITE for Bus1

signal Ch7WriteBus2     : std_logic;
-- Channel7 HWRITE for Bus2

signal Ch0HSIZEBus1     : std_logic_vector(2 downto 0);
-- Channel0 Hsize for Mas1

signal Ch0HSIZEBus2     : std_logic_vector(2 downto 0);
-- Channel0 Hsize for Mas2

signal Ch1HSIZEBus1     : std_logic_vector(2 downto 0);
-- Channel1 Hsize for Mas1

signal Ch1HSIZEBus2     : std_logic_vector(2 downto 0);
-- Channel1 Hsize for Mas2

signal Ch2HSIZEBus1     : std_logic_vector(2 downto 0);
-- Channel2 Hsize for Mas1

signal Ch2HSIZEBus2     : std_logic_vector(2 downto 0);
-- Channel2 Hsize for Mas2

signal Ch3HSIZEBus1     : std_logic_vector(2 downto 0);
-- Channel3 Hsize for Mas1

signal Ch3HSIZEBus2     : std_logic_vector(2 downto 0);
-- Channel3 Hsize for Mas2

signal Ch4HSIZEBus1     : std_logic_vector(2 downto 0);
-- Channel4 Hsize for Mas1

signal Ch4HSIZEBus2     : std_logic_vector(2 downto 0);
-- Channel4 Hsize for Mas2

signal Ch5HSIZEBus1     : std_logic_vector(2 downto 0);
-- Channel5 Hsize for Mas1

signal Ch5HSIZEBus2     : std_logic_vector(2 downto 0);
-- Channel5 Hsize for Mas2

signal Ch6HSIZEBus1     : std_logic_vector(2 downto 0);
-- Channel6 Hsize for Mas1

signal Ch6HSIZEBus2     : std_logic_vector(2 downto 0);
-- Channel6 Hsize for Mas2

signal Ch7HSIZEBus1     : std_logic_vector(2 downto 0);
-- Channel7 Hsize for Mas1

signal Ch7HSIZEBus2     : std_logic_vector(2 downto 0);
-- Channel7 Hsize for Mas2

signal Ch0IntTC         : std_logic;
-- Channel0 TC Generation

signal Ch1IntTC         : std_logic;
-- Channel1 TC Generation

signal Ch2IntTC         : std_logic;
-- Channel2 TC Generation

signal Ch3IntTC         : std_logic;
-- Channel3 TC Generation

signal Ch4IntTC         : std_logic;
-- Channel4 TC Generation

signal Ch5IntTC         : std_logic;
-- Channel5 TC Generation

signal Ch6IntTC         : std_logic;
-- Channel6 TC Generation

signal Ch7IntTC         : std_logic;
-- Channel7 TC Generation

signal Ch0IntErr        : std_logic;
-- Channel0 Error Generation

signal Ch1IntErr        : std_logic;
-- Channel1 Error Generation

signal Ch2IntErr        : std_logic;
-- Channel2 Error Generation

signal Ch3IntErr        : std_logic;
-- Channel3 Error Generation

signal Ch4IntErr        : std_logic;
-- Channel4 Error Generation

signal Ch5IntErr        : std_logic;
-- Channel5 Error Generation

signal Ch6IntErr        : std_logic;
-- Channel6 Error Generation

signal Ch7IntErr        : std_logic;
-- Channel7 Error Generation

signal Ch0SOFTCLR       : std_logic_vector(15 downto 0);
-- Channel0 SoftReq Clear Generation

signal Ch1SOFTCLR       : std_logic_vector(15 downto 0);
-- Channel1 SoftReq Clear Generation

signal Ch2SOFTCLR       : std_logic_vector(15 downto 0);
-- Channel2 SoftReq Clear Generation

signal Ch3SOFTCLR       : std_logic_vector(15 downto 0);
-- Channel3 SoftReq Clear Generation

signal Ch4SOFTCLR       : std_logic_vector(15 downto 0);
-- Channel4 SoftReq Clear Generation

signal Ch5SOFTCLR       : std_logic_vector(15 downto 0);
-- Channel5 SoftReq Clear Generation

signal Ch6SOFTCLR       : std_logic_vector(15 downto 0);
-- Channel6 SoftReq Clear Generation

signal Ch7SOFTCLR       : std_logic_vector(15 downto 0);
-- Channel7 SoftReq Clear Generation

signal Ch0DMACTC        : std_logic_vector(15 downto 0);
-- Channel0 TC Generation

signal Ch1DMACTC        : std_logic_vector(15 downto 0);
-- Channel1 TC Generation

signal Ch2DMACTC        : std_logic_vector(15 downto 0);
-- Channel2 TC Generation

signal Ch3DMACTC        : std_logic_vector(15 downto 0);
-- Channel3 TC Generation

signal Ch4DMACTC        : std_logic_vector(15 downto 0);
-- Channel4 TC Generation

signal Ch5DMACTC        : std_logic_vector(15 downto 0);
-- Channel5 TC Generation

signal Ch6DMACTC        : std_logic_vector(15 downto 0);
-- Channel6 TC Generation

signal Ch7DMACTC        : std_logic_vector(15 downto 0);
-- Channel7 TC Generation

signal Ch0DMACCLR       : std_logic_vector(15 downto 0);
-- Channel0 Clear Generation

signal Ch1DMACCLR       : std_logic_vector(15 downto 0);
-- Channel1 Clear Generation

signal Ch2DMACCLR       : std_logic_vector(15 downto 0);
-- Channel2 Clear Generation

signal Ch3DMACCLR       : std_logic_vector(15 downto 0);
-- Channel3 Clear Generation

signal Ch4DMACCLR       : std_logic_vector(15 downto 0);
-- Channel4 Clear Generation

signal Ch5DMACCLR       : std_logic_vector(15 downto 0);
-- Channel5 Clear Generation

signal Ch6DMACCLR       : std_logic_vector(15 downto 0);
-- Channel6 Clear Generation

signal Ch7DMACCLR       : std_logic_vector(15 downto 0);
-- Channel7 Clear Generation

signal iDMACINTTC       : std_logic;
-- Internal copy of DMACINTTC

signal iDMACINTERR      : std_logic;
-- Internal copy of DMACINTERR

signal iDMACINTR        : std_logic;
-- Internal copy of DMACINTR

signal iDmacTrEn        : std_logic;
-- Internal copy of DmacTrEn


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
-- Connecting Local copies to output
-- -----------------------------------------------------------------------------
DmacTrEn <= iDmacTrEn;

-- -----------------------------------------------------------------------------
-- Instantiation of DmacTrAhbSlaveIf
-- -----------------------------------------------------------------------------
uDmacTrAhbSlaveIf : DmacTrAhbSlaveIf
  port map (
            HCLK             => HCLK,
            HRESETn          => HRESETn,
            HSELDMAC         => HSELDMAC,
            HSELDMACTrSlave  => HSELDMACTrSlave,
            HWRITE           => HWRITE,
            HTRANS           => HTRANS,
            HWDATA           => HWDATA,
            HADDR            => HADDR,
            HSIZE            => HSIZE,
            HREADYIN         => HREADYIN,
            SoftClr          => SOFTCLR,
            DmacClr          => iDMACCLR,
            DMACBREQ         => DMACBREQ,
            DMACLBREQ        => DMACLBREQ,
            DMACSREQ         => DMACSREQ,
            DMACLSREQ        => DMACLSREQ,
            HREADYOUT        => HREADYOUT,
            HRESP            => HRESP,
            DmacSrcRegWrEn0  => DmacSrcRegWrEn0,
            DmacDstRegWrEn0  => DmacDstRegWrEn0,
            DmacLLIRegWrEn0  => DmacLLIRegWrEn0,
            DmacCntlRegWrEn0 => DmacCntlRegWrEn0,
            DmacChCnfgWrEn0  => DmacChCnfgWrEn0,
            DmacSrcRegWrEn1  => DmacSrcRegWrEn1,
            DmacDstRegWrEn1  => DmacDstRegWrEn1,
            DmacLLIRegWrEn1  => DmacLLIRegWrEn1,
            DmacCntlRegWrEn1 => DmacCntlRegWrEn1,
            DmacChCnfgWrEn1  => DmacChCnfgWrEn1,
            DmacSrcRegWrEn2  => DmacSrcRegWrEn2,
            DmacDstRegWrEn2  => DmacDstRegWrEn2,
            DmacLLIRegWrEn2  => DmacLLIRegWrEn2,
            DmacCntlRegWrEn2 => DmacCntlRegWrEn2,
            DmacChCnfgWrEn2  => DmacChCnfgWrEn2,
            DmacSrcRegWrEn3  => DmacSrcRegWrEn3,
            DmacDstRegWrEn3  => DmacDstRegWrEn3,
            DmacLLIRegWrEn3  => DmacLLIRegWrEn3,
            DmacCntlRegWrEn3 => DmacCntlRegWrEn3,
            DmacChCnfgWrEn3  => DmacChCnfgWrEn3,
            DmacSrcRegWrEn4  => DmacSrcRegWrEn4,
            DmacDstRegWrEn4  => DmacDstRegWrEn4,
            DmacLLIRegWrEn4  => DmacLLIRegWrEn4,
            DmacCntlRegWrEn4 => DmacCntlRegWrEn4,
            DmacChCnfgWrEn4  => DmacChCnfgWrEn4,
            DmacSrcRegWrEn5  => DmacSrcRegWrEn5,
            DmacDstRegWrEn5  => DmacDstRegWrEn5,
            DmacLLIRegWrEn5  => DmacLLIRegWrEn5,
            DmacCntlRegWrEn5 => DmacCntlRegWrEn5,
            DmacChCnfgWrEn5  => DmacChCnfgWrEn5,
            DmacSrcRegWrEn6  => DmacSrcRegWrEn6,
            DmacDstRegWrEn6  => DmacDstRegWrEn6,
            DmacLLIRegWrEn6  => DmacLLIRegWrEn6,
            DmacCntlRegWrEn6 => DmacCntlRegWrEn6,
            DmacChCnfgWrEn6  => DmacChCnfgWrEn6,
            DmacSrcRegWrEn7  => DmacSrcRegWrEn7,
            DmacDstRegWrEn7  => DmacDstRegWrEn7,
            DmacLLIRegWrEn7  => DmacLLIRegWrEn7,
            DmacCntlRegWrEn7 => DmacCntlRegWrEn7,
            DmacChCnfgWrEn7  => DmacChCnfgWrEn7,
            DMACBREQCh       => DMACBREQCh,
            DMACLBREQCh      => DMACLBREQCh,
            DMACSREQCh       => DMACSREQCh,
            DMACLSREQCh      => DMACLSREQCh,
            SOFTBREQCh       => SOFTBREQCh,
            SOFTLBREQCh      => SOFTLBREQCh,
            SOFTSREQCh       => SOFTSREQCh,
            SOFTLSREQCh      => SOFTLSREQCh,
            ClrIntErr        => ClrIntErr,
            ClrIntTC         => ClrIntTC,
            DMACEn           => DMACEn,
            ReqConfig        => ReqConfig,
            GrantCount0      => GrantCount0,
            GrantCount1      => GrantCount1,
            DmacTrEn         => iDmacTrEn,
            MasterEndian1    => MasterEndian1,
            MasterEndian2    => MasterEndian2
           );

-- -----------------------------------------------------------------------------
-- Instantiation of DmacTrIntArb0
-- -----------------------------------------------------------------------------
u0DmacTrIntArb : DmacTrIntArb
  port map (
            HCLK             => HCLK,
            HRESETn          => HRESETn,
            Ch0Req           => Ch0ReqArb1,
            Ch1Req           => Ch1ReqArb1,
            Ch2Req           => Ch2ReqArb1,
            Ch3Req           => Ch3ReqArb1,
            Ch4Req           => Ch4ReqArb1,
            Ch5Req           => Ch5ReqArb1,
            Ch6Req           => Ch6ReqArb1,
            Ch7Req           => Ch7ReqArb1,
            StopArb          => StopArb1,
            Ch0HWDATA        => Ch0HWDATABus1,
            Ch1HWDATA        => Ch1HWDATABus1,
            Ch2HWDATA        => Ch2HWDATABus1,
            Ch3HWDATA        => Ch3HWDATABus1,
            Ch4HWDATA        => Ch4HWDATABus1,
            Ch5HWDATA        => Ch5HWDATABus1,
            Ch6HWDATA        => Ch6HWDATABus1,
            Ch7HWDATA        => Ch7HWDATABus1,
            ReqForAhbBus     => ReqForAhbBus1,
            HWDATA           => HWDATABus1,
            Ch0Comb          => Ch0CombBus1,
            Ch1Comb          => Ch1CombBus1,
            Ch2Comb          => Ch2CombBus1,
            Ch3Comb          => Ch3CombBus1,
            Ch4Comb          => Ch4CombBus1,
            Ch5Comb          => Ch5CombBus1,
            Ch6Comb          => Ch6CombBus1,
            Ch7Comb          => Ch7CombBus1
           );

-- -----------------------------------------------------------------------------
-- Instantiation of DmacTrIntArb1
-- -----------------------------------------------------------------------------
u1DmacTrIntArb : DmacTrIntArb
  port map (
            HCLK             => HCLK,
            HRESETn          => HRESETn,
            Ch0Req           => Ch0ReqArb2,
            Ch1Req           => Ch1ReqArb2,
            Ch2Req           => Ch2ReqArb2,
            Ch3Req           => Ch3ReqArb2,
            Ch4Req           => Ch4ReqArb2,
            Ch5Req           => Ch5ReqArb2,
            Ch6Req           => Ch6ReqArb2,
            Ch7Req           => Ch7ReqArb2,
            StopArb          => StopArb2,
            Ch0HWDATA        => Ch0HWDATABus2,
            Ch1HWDATA        => Ch1HWDATABus2,
            Ch2HWDATA        => Ch2HWDATABus2,
            Ch3HWDATA        => Ch3HWDATABus2,
            Ch4HWDATA        => Ch4HWDATABus2,
            Ch5HWDATA        => Ch5HWDATABus2,
            Ch6HWDATA        => Ch6HWDATABus2,
            Ch7HWDATA        => Ch7HWDATABus2,
            ReqForAhbBus     => ReqForAhbBus2,
            HWDATA           => HWDATABus2,
            Ch0Comb          => Ch0CombBus2,
            Ch1Comb          => Ch1CombBus2,
            Ch2Comb          => Ch2CombBus2,
            Ch3Comb          => Ch3CombBus2,
            Ch4Comb          => Ch4CombBus2,
            Ch5Comb          => Ch5CombBus2,
            Ch6Comb          => Ch6CombBus2,
            Ch7Comb          => Ch7CombBus2
           );

-- -----------------------------------------------------------------------------
-- Instantiation of DmacTrAhbMaster 1
-- -----------------------------------------------------------------------------
u1DmacTrAhbMaster : DmacTrAhbMaster
  port map (
            HCLK             => HCLK,
            HRESETn          => HRESETn,
            HGRANTDMACM      => HGRANTDMACM1,
            HREADYINM        => HREADYINM1,
            HRESPM           => HRESPM1,
            ChHLOCK          => ChHLOCKBus1,
            ChWRITE          => ChWRITEBus1,
            ReqForAhbBus     => ReqForAhbBus1,
            ChHPROT          => ChHProtBus1,
            ChHSIZE          => ChHSIZEBus1,
            ChAddr           => ChAddrBus1,
            ChAddrIncr       => ChAddrIncrBus1,
            ChDisable        => ChDisableBus1,
            ChPriority       => ChPriorityBus1,
            ChBeatCount      => ChBeatCountBus1,
            HWDATA           => HWDATABus1,
            HBUSREQDMACM     => HBUSREQDMACM1,
            HLOCKDMACM       => HLOCKDMACM1,
            HPROTM           => HPROTM1,
            HBURSTM          => HBURSTM1,
            HTRANSM          => HTRANSM1,
            HADDRM           => HADDRM1,
            HSIZEM           => HSIZEM1,
            HWRITEM          => HWRITEM1,
            HWDATAM          => HWDATAM1,
            DataValid        => DataValidBus1,
            MREADY           => MREADY1,
            DisAckMas        => DisAckMas1,
            StopArb          => StopArb1,
            ErrorMas         => ErrorMas1
           );

-- -----------------------------------------------------------------------------
-- Instantiation of DmacTrAhbMaster 2
-- -----------------------------------------------------------------------------
u2DmacTrAhbMaster : DmacTrAhbMaster
  port map (
            HCLK             => HCLK,
            HRESETn          => HRESETn,
            HGRANTDMACM      => HGRANTDMACM2,
            HREADYINM        => HREADYINM2,
            HRESPM           => HRESPM2,
            ChHLOCK          => ChHLOCKBus2,
            ChWRITE          => ChWRITEBus2,
            ReqForAhbBus     => ReqForAhbBus2,
            ChHPROT          => ChHProtBus2,
            ChHSIZE          => ChHSIZEBus2,
            ChAddr           => ChAddrBus2,
            ChAddrIncr       => ChAddrIncrBus2,
            ChDisable        => ChDisableBus2,
            ChPriority       => ChPriorityBus2,
            ChBeatCount      => ChBeatCountBus2,
            HWDATA           => HWDATABus2,
            HBUSREQDMACM     => HBUSREQDMACM2,
            HLOCKDMACM       => HLOCKDMACM2,
            HPROTM           => HPROTM2,
            HBURSTM          => HBURSTM2,
            HTRANSM          => HTRANSM2,
            HADDRM           => HADDRM2,
            HSIZEM           => HSIZEM2,
            HWRITEM          => HWRITEM2,
            HWDATAM          => HWDATAM2,
            DataValid        => DataValidBus2,
            MREADY           => MREADY2,
            DisAckMas        => DisAckMas2,
            StopArb          => StopArb2,
            ErrorMas         => ErrorMas2
           );

-- -----------------------------------------------------------------------------
-- Instantiation of DmacTrChLogic0
-- -----------------------------------------------------------------------------
u0DmacTrChLogic : DmacTrChLogic
  port map (
            HCLK             => HCLK,
            HRESETn          => HRESETn,
            ChComb1          => Ch0CombBus1,
            ChComb2          => Ch0CombBus2,
            ChSrcAddrWrEn    => DmacSrcRegWrEn0,
            ChDstAddrWrEn    => DmacDstRegWrEn0,
            ChControlWrEn    => DmacCntlRegWrEn0,
            ChLLIWrEn        => DmacLLIRegWrEn0,
            ChConfigWrEn     => DmacChCnfgWrEn0,
            HWDATA           => HWDATA,
            HRDATAM1         => HRDATAM1,
            HRDATAM2         => HRDATAM2,
            DataValid1       => DataValidBus1,
            DataValid2       => DataValidBus2,
            MREADY1          => MREADY1,
            MREADY2          => MREADY2,
            ErrorMas1        => ErrorMas1,
            ErrorMas2        => ErrorMas2,
            DisAckMas1       => DisAckMas1,
            DisAckMas2       => DisAckMas2,
            MasterEndian1    => MasterEndian1,
            MasterEndian2    => MasterEndian2,
            DMACBREQ         => DMACBREQCh,
            DMACSREQ         => DMACSREQCh,
            DMACLBREQ        => DMACLBREQCh,
            DMACLSREQ        => DMACLSREQCh,
            SOFTBREQ         => SOFTBREQCh,
            SOFTLBREQ        => SOFTLBREQCh,
            SOFTSREQ         => SOFTSREQCh,
            SOFTLSREQ        => SOFTLSREQCh,
            DMACEn           => DMACEn,
            DmacTrEn         => iDmacTrEn,
            ClrIntTC         => ClrIntTC(0),
            ClrIntErr        => ClrIntErr(0),
            ChReqArb1        => Ch0ReqArb1,
            ChReqArb2        => Ch0ReqArb2,
            ChDisableBus1    => Ch0DisableBus1,
            ChDisableBus2    => Ch0DisableBus2,
            HWDATA1          => Ch0HWDATABus1,
            HWDATA2          => Ch0HWDATABus2,
            ChAddrBus1       => Ch0AddrBus1,
            ChAddrBus2       => Ch0AddrBus2,
            ChHLockBus1      => Ch0HLockBus1,
            ChHLockBus2      => Ch0HLockBus2,
            ChHProtBus1      => Ch0HProtBus1,
            ChHProtBus2      => Ch0HProtBus2,
            ChBeatCntBus1    => Ch0BeatCntBus1,
            ChBeatCntBus2    => Ch0BeatCntBus2,
            ChAddrIncr1      => Ch0AddrIncBus1,
            ChAddrIncr2      => Ch0AddrIncBus2,
            ChWRITEBus1      => Ch0WriteBus1,
            ChWRITEBus2      => Ch0WriteBus2,
            ChHSIZEBus1      => Ch0HSIZEBus1,
            ChHSIZEBus2      => Ch0HSIZEBus2,
            ChIntTC          => Ch0IntTC,
            ChIntErr         => Ch0IntErr,
            SOFTCLR          => Ch0SOFTCLR,
            DMACTC           => Ch0DMACTC,
            DMACCLR          => Ch0DMACCLR
           );

-- -----------------------------------------------------------------------------
-- Instantiation of DmacTrChLogic1
-- -----------------------------------------------------------------------------
u1DmacTrChLogic : DmacTrChLogic
  port map (
            HCLK             => HCLK,
            HRESETn          => HRESETn,
            ChComb1          => Ch1CombBus1,
            ChComb2          => Ch1CombBus2,
            ChSrcAddrWrEn    => DmacSrcRegWrEn1,
            ChDstAddrWrEn    => DmacDstRegWrEn1,
            ChControlWrEn    => DmacCntlRegWrEn1,
            ChLLIWrEn        => DmacLLIRegWrEn1,
            ChConfigWrEn     => DmacChCnfgWrEn1,
            HWDATA           => HWDATA,
            HRDATAM1         => HRDATAM1,
            HRDATAM2         => HRDATAM2,
            DataValid1       => DataValidBus1,
            DataValid2       => DataValidBus2,
            MREADY1          => MREADY1,
            MREADY2          => MREADY2,
            ErrorMas1        => ErrorMas1,
            ErrorMas2        => ErrorMas2,
            DisAckMas1       => DisAckMas1,
            DisAckMas2       => DisAckMas2,
            MasterEndian1    => MasterEndian1,
            MasterEndian2    => MasterEndian2,
            DMACBREQ         => DMACBREQCh,
            DMACSREQ         => DMACSREQCh,
            DMACLBREQ        => DMACLBREQCh,
            DMACLSREQ        => DMACLSREQCh,
            SOFTBREQ         => SOFTBREQCh,
            SOFTLBREQ        => SOFTLBREQCh,
            SOFTSREQ         => SOFTSREQCh,
            SOFTLSREQ        => SOFTLSREQCh,
            DMACEn           => DMACEn,
            DmacTrEn         => iDmacTrEn,
            ClrIntTC         => ClrIntTC(1),
            ClrIntErr        => ClrIntErr(1),
            ChReqArb1        => Ch1ReqArb1,
            ChReqArb2        => Ch1ReqArb2,
            ChDisableBus1    => Ch1DisableBus1,
            ChDisableBus2    => Ch1DisableBus2,
            HWDATA1          => Ch1HWDATABus1,
            HWDATA2          => Ch1HWDATABus2,
            ChAddrBus1       => Ch1AddrBus1,
            ChAddrBus2       => Ch1AddrBus2,
            ChHLockBus1      => Ch1HLockBus1,
            ChHLockBus2      => Ch1HLockBus2,
            ChHProtBus1      => Ch1HProtBus1,
            ChHProtBus2      => Ch1HProtBus2,
            ChBeatCntBus1    => Ch1BeatCntBus1,
            ChBeatCntBus2    => Ch1BeatCntBus2,
            ChAddrIncr1      => Ch1AddrIncBus1,
            ChAddrIncr2      => Ch1AddrIncBus2,
            ChWRITEBus1      => Ch1WriteBus1,
            ChWRITEBus2      => Ch1WriteBus2,
            ChHSIZEBus1      => Ch1HSIZEBus1,
            ChHSIZEBus2      => Ch1HSIZEBus2,
            ChIntTC          => Ch1IntTC,
            ChIntErr         => Ch1IntErr,
            SOFTCLR          => Ch1SOFTCLR,
            DMACTC           => Ch1DMACTC,
            DMACCLR          => Ch1DMACCLR
           );

-- -----------------------------------------------------------------------------
-- Instantiation of DmacTrChLogic2
-- -----------------------------------------------------------------------------
u2DmacTrChLogic : DmacTrChLogic
  port map (
            HCLK             => HCLK,
            HRESETn          => HRESETn,
            ChComb1          => Ch2CombBus1,
            ChComb2          => Ch2CombBus2,
            ChSrcAddrWrEn    => DmacSrcRegWrEn2,
            ChDstAddrWrEn    => DmacDstRegWrEn2,
            ChControlWrEn    => DmacCntlRegWrEn2,
            ChLLIWrEn        => DmacLLIRegWrEn2,
            ChConfigWrEn     => DmacChCnfgWrEn2,
            HWDATA           => HWDATA,
            HRDATAM1         => HRDATAM1,
            HRDATAM2         => HRDATAM2,
            DataValid1       => DataValidBus1,
            DataValid2       => DataValidBus2,
            MREADY1          => MREADY1,
            MREADY2          => MREADY2,
            ErrorMas1        => ErrorMas1,
            ErrorMas2        => ErrorMas2,
            DisAckMas1       => DisAckMas1,
            DisAckMas2       => DisAckMas2,
            MasterEndian1    => MasterEndian1,
            MasterEndian2    => MasterEndian2,
            DMACBREQ         => DMACBREQCh,
            DMACSREQ         => DMACSREQCh,
            DMACLBREQ        => DMACLBREQCh,
            DMACLSREQ        => DMACLSREQCh,
            SOFTBREQ         => SOFTBREQCh,
            SOFTLBREQ        => SOFTLBREQCh,
            SOFTSREQ         => SOFTSREQCh,
            SOFTLSREQ        => SOFTLSREQCh,
            DMACEn           => DMACEn,
            DmacTrEn         => iDmacTrEn,
            ClrIntTC         => ClrIntTC(2),
            ClrIntErr        => ClrIntErr(2),
            ChReqArb1        => Ch2ReqArb1,
            ChReqArb2        => Ch2ReqArb2,
            ChDisableBus1    => Ch2DisableBus1,
            ChDisableBus2    => Ch2DisableBus2,
            HWDATA1          => Ch2HWDATABus1,
            HWDATA2          => Ch2HWDATABus2,
            ChAddrBus1       => Ch2AddrBus1,
            ChAddrBus2       => Ch2AddrBus2,
            ChHLockBus1      => Ch2HLockBus1,
            ChHLockBus2      => Ch2HLockBus2,
            ChHProtBus1      => Ch2HProtBus1,
            ChHProtBus2      => Ch2HProtBus2,
            ChBeatCntBus1    => Ch2BeatCntBus1,
            ChBeatCntBus2    => Ch2BeatCntBus2,
            ChAddrIncr1      => Ch2AddrIncBus1,
            ChAddrIncr2      => Ch2AddrIncBus2,
            ChWRITEBus1      => Ch2WriteBus1,
            ChWRITEBus2      => Ch2WriteBus2,
            ChHSIZEBus1      => Ch2HSIZEBus1,
            ChHSIZEBus2      => Ch2HSIZEBus2,
            ChIntTC          => Ch2IntTC,
            ChIntErr         => Ch2IntErr,
            SOFTCLR          => Ch2SOFTCLR,
            DMACTC           => Ch2DMACTC,
            DMACCLR          => Ch2DMACCLR
           );

-- -----------------------------------------------------------------------------
-- Instantiation of DmacTrChLogic3
-- -----------------------------------------------------------------------------
u3DmacTrChLogic : DmacTrChLogic
  port map (
            HCLK             => HCLK,
            HRESETn          => HRESETn,
            ChComb1          => Ch3CombBus1,
            ChComb2          => Ch3CombBus2,
            ChSrcAddrWrEn    => DmacSrcRegWrEn3,
            ChDstAddrWrEn    => DmacDstRegWrEn3,
            ChControlWrEn    => DmacCntlRegWrEn3,
            ChLLIWrEn        => DmacLLIRegWrEn3,
            ChConfigWrEn     => DmacChCnfgWrEn3,
            HWDATA           => HWDATA,
            HRDATAM1         => HRDATAM1,
            HRDATAM2         => HRDATAM2,
            DataValid1       => DataValidBus1,
            DataValid2       => DataValidBus2,
            MREADY1          => MREADY1,
            MREADY2          => MREADY2,
            ErrorMas1        => ErrorMas1,
            ErrorMas2        => ErrorMas2,
            DisAckMas1       => DisAckMas1,
            DisAckMas2       => DisAckMas2,
            MasterEndian1    => MasterEndian1,
            MasterEndian2    => MasterEndian2,
            DMACBREQ         => DMACBREQCh,
            DMACSREQ         => DMACSREQCh,
            DMACLBREQ        => DMACLBREQCh,
            DMACLSREQ        => DMACLSREQCh,
            SOFTBREQ         => SOFTBREQCh,
            SOFTLBREQ        => SOFTLBREQCh,
            SOFTSREQ         => SOFTSREQCh,
            SOFTLSREQ        => SOFTLSREQCh,
            DMACEn           => DMACEn,
            DmacTrEn         => iDmacTrEn,
            ClrIntTC         => ClrIntTC(3),
            ClrIntErr        => ClrIntErr(3),
            ChReqArb1        => Ch3ReqArb1,
            ChReqArb2        => Ch3ReqArb2,
            ChDisableBus1    => Ch3DisableBus1,
            ChDisableBus2    => Ch3DisableBus2,
            HWDATA1          => Ch3HWDATABus1,
            HWDATA2          => Ch3HWDATABus2,
            ChAddrBus1       => Ch3AddrBus1,
            ChAddrBus2       => Ch3AddrBus2,
            ChHLockBus1      => Ch3HLockBus1,
            ChHLockBus2      => Ch3HLockBus2,
            ChHProtBus1      => Ch3HProtBus1,
            ChHProtBus2      => Ch3HProtBus2,
            ChBeatCntBus1    => Ch3BeatCntBus1,
            ChBeatCntBus2    => Ch3BeatCntBus2,
            ChAddrIncr1      => Ch3AddrIncBus1,
            ChAddrIncr2      => Ch3AddrIncBus2,
            ChWRITEBus1      => Ch3WriteBus1,
            ChWRITEBus2      => Ch3WriteBus2,
            ChHSIZEBus1      => Ch3HSIZEBus1,
            ChHSIZEBus2      => Ch3HSIZEBus2,
            ChIntTC          => Ch3IntTC,
            ChIntErr         => Ch3IntErr,
            SOFTCLR          => Ch3SOFTCLR,
            DMACTC           => Ch3DMACTC,
            DMACCLR          => Ch3DMACCLR
           );

-- -----------------------------------------------------------------------------
-- Instantiation of DmacTrChLogic4
-- -----------------------------------------------------------------------------
u4DmacTrChLogic : DmacTrChLogic
  port map (
            HCLK             => HCLK,
            HRESETn          => HRESETn,
            ChComb1          => Ch4CombBus1,
            ChComb2          => Ch4CombBus2,
            ChSrcAddrWrEn    => DmacSrcRegWrEn4,
            ChDstAddrWrEn    => DmacDstRegWrEn4,
            ChControlWrEn    => DmacCntlRegWrEn4,
            ChLLIWrEn        => DmacLLIRegWrEn4,
            ChConfigWrEn     => DmacChCnfgWrEn4,
            HWDATA           => HWDATA,
            HRDATAM1         => HRDATAM1,
            HRDATAM2         => HRDATAM2,
            DataValid1       => DataValidBus1,
            DataValid2       => DataValidBus2,
            MREADY1          => MREADY1,
            MREADY2          => MREADY2,
            ErrorMas1        => ErrorMas1,
            ErrorMas2        => ErrorMas2,
            DisAckMas1       => DisAckMas1,
            DisAckMas2       => DisAckMas2,
            MasterEndian1    => MasterEndian1,
            MasterEndian2    => MasterEndian2,
            DMACBREQ         => DMACBREQCh,
            DMACSREQ         => DMACSREQCh,
            DMACLBREQ        => DMACLBREQCh,
            DMACLSREQ        => DMACLSREQCh,
            SOFTBREQ         => SOFTBREQCh,
            SOFTLBREQ        => SOFTLBREQCh,
            SOFTSREQ         => SOFTSREQCh,
            SOFTLSREQ        => SOFTLSREQCh,
            DMACEn           => DMACEn,
            DmacTrEn         => iDmacTrEn,
            ClrIntTC         => ClrIntTC(4),
            ClrIntErr        => ClrIntErr(4),
            ChReqArb1        => Ch4ReqArb1,
            ChReqArb2        => Ch4ReqArb2,
            ChDisableBus1    => Ch4DisableBus1,
            ChDisableBus2    => Ch4DisableBus2,
            HWDATA1          => Ch4HWDATABus1,
            HWDATA2          => Ch4HWDATABus2,
            ChAddrBus1       => Ch4AddrBus1,
            ChAddrBus2       => Ch4AddrBus2,
            ChHLockBus1      => Ch4HLockBus1,
            ChHLockBus2      => Ch4HLockBus2,
            ChHProtBus1      => Ch4HProtBus1,
            ChHProtBus2      => Ch4HProtBus2,
            ChBeatCntBus1    => Ch4BeatCntBus1,
            ChBeatCntBus2    => Ch4BeatCntBus2,
            ChAddrIncr1      => Ch4AddrIncBus1,
            ChAddrIncr2      => Ch4AddrIncBus2,
            ChWRITEBus1      => Ch4WriteBus1,
            ChWRITEBus2      => Ch4WriteBus2,
            ChHSIZEBus1      => Ch4HSIZEBus1,
            ChHSIZEBus2      => Ch4HSIZEBus2,
            ChIntTC          => Ch4IntTC,
            ChIntErr         => Ch4IntErr,
            SOFTCLR          => Ch4SOFTCLR,
            DMACTC           => Ch4DMACTC,
            DMACCLR          => Ch4DMACCLR
           );

-- -----------------------------------------------------------------------------
-- Instantiation of DmacTrChLogic5
-- -----------------------------------------------------------------------------
u5DmacTrChLogic : DmacTrChLogic
  port map (
            HCLK             => HCLK,
            HRESETn          => HRESETn,
            ChComb1          => Ch5CombBus1,
            ChComb2          => Ch5CombBus2,
            ChSrcAddrWrEn    => DmacSrcRegWrEn5,
            ChDstAddrWrEn    => DmacDstRegWrEn5,
            ChControlWrEn    => DmacCntlRegWrEn5,
            ChLLIWrEn        => DmacLLIRegWrEn5,
            ChConfigWrEn     => DmacChCnfgWrEn5,
            HWDATA           => HWDATA,
            HRDATAM1         => HRDATAM1,
            HRDATAM2         => HRDATAM2,
            DataValid1       => DataValidBus1,
            DataValid2       => DataValidBus2,
            MREADY1          => MREADY1,
            MREADY2          => MREADY2,
            ErrorMas1        => ErrorMas1,
            ErrorMas2        => ErrorMas2,
            DisAckMas1       => DisAckMas1,
            DisAckMas2       => DisAckMas2,
            MasterEndian1    => MasterEndian1,
            MasterEndian2    => MasterEndian2,
            DMACBREQ         => DMACBREQCh,
            DMACSREQ         => DMACSREQCh,
            DMACLBREQ        => DMACLBREQCh,
            DMACLSREQ        => DMACLSREQCh,
            SOFTBREQ         => SOFTBREQCh,
            SOFTLBREQ        => SOFTLBREQCh,
            SOFTSREQ         => SOFTSREQCh,
            SOFTLSREQ        => SOFTLSREQCh,
            DMACEn           => DMACEn,
            DmacTrEn         => iDmacTrEn,
            ClrIntTC         => ClrIntTC(5),
            ClrIntErr        => ClrIntErr(5),
            ChReqArb1        => Ch5ReqArb1,
            ChReqArb2        => Ch5ReqArb2,
            ChDisableBus1    => Ch5DisableBus1,
            ChDisableBus2    => Ch5DisableBus2,
            HWDATA1          => Ch5HWDATABus1,
            HWDATA2          => Ch5HWDATABus2,
            ChAddrBus1       => Ch5AddrBus1,
            ChAddrBus2       => Ch5AddrBus2,
            ChHLockBus1      => Ch5HLockBus1,
            ChHLockBus2      => Ch5HLockBus2,
            ChHProtBus1      => Ch5HProtBus1,
            ChHProtBus2      => Ch5HProtBus2,
            ChBeatCntBus1    => Ch5BeatCntBus1,
            ChBeatCntBus2    => Ch5BeatCntBus2,
            ChAddrIncr1      => Ch5AddrIncBus1,
            ChAddrIncr2      => Ch5AddrIncBus2,
            ChWRITEBus1      => Ch5WriteBus1,
            ChWRITEBus2      => Ch5WriteBus2,
            ChHSIZEBus1      => Ch5HSIZEBus1,
            ChHSIZEBus2      => Ch5HSIZEBus2,
            ChIntTC          => Ch5IntTC,
            ChIntErr         => Ch5IntErr,
            SOFTCLR          => Ch5SOFTCLR,
            DMACTC           => Ch5DMACTC,
            DMACCLR          => Ch5DMACCLR
           );

-- -----------------------------------------------------------------------------
-- Instantiation of DmacTrChLogic6
-- -----------------------------------------------------------------------------
u6DmacTrChLogic : DmacTrChLogic
  port map (
            HCLK             => HCLK,
            HRESETn          => HRESETn,
            ChComb1          => Ch6CombBus1,
            ChComb2          => Ch6CombBus2,
            ChSrcAddrWrEn    => DmacSrcRegWrEn6,
            ChDstAddrWrEn    => DmacDstRegWrEn6,
            ChControlWrEn    => DmacCntlRegWrEn6,
            ChLLIWrEn        => DmacLLIRegWrEn6,
            ChConfigWrEn     => DmacChCnfgWrEn6,
            HWDATA           => HWDATA,
            HRDATAM1         => HRDATAM1,
            HRDATAM2         => HRDATAM2,
            DataValid1       => DataValidBus1,
            DataValid2       => DataValidBus2,
            MREADY1          => MREADY1,
            MREADY2          => MREADY2,
            ErrorMas1        => ErrorMas1,
            ErrorMas2        => ErrorMas2,
            DisAckMas1       => DisAckMas1,
            DisAckMas2       => DisAckMas2,
            MasterEndian1    => MasterEndian1,
            MasterEndian2    => MasterEndian2,
            DMACBREQ         => DMACBREQCh,
            DMACSREQ         => DMACSREQCh,
            DMACLBREQ        => DMACLBREQCh,
            DMACLSREQ        => DMACLSREQCh,
            SOFTBREQ         => SOFTBREQCh,
            SOFTLBREQ        => SOFTLBREQCh,
            SOFTSREQ         => SOFTSREQCh,
            SOFTLSREQ        => SOFTLSREQCh,
            DMACEn           => DMACEn,
            DmacTrEn         => iDmacTrEn,
            ClrIntTC         => ClrIntTC(6),
            ClrIntErr        => ClrIntErr(6),
            ChReqArb1        => Ch6ReqArb1,
            ChReqArb2        => Ch6ReqArb2,
            ChDisableBus1    => Ch6DisableBus1,
            ChDisableBus2    => Ch6DisableBus2,
            HWDATA1          => Ch6HWDATABus1,
            HWDATA2          => Ch6HWDATABus2,
            ChAddrBus1       => Ch6AddrBus1,
            ChAddrBus2       => Ch6AddrBus2,
            ChHLockBus1      => Ch6HLockBus1,
            ChHLockBus2      => Ch6HLockBus2,
            ChHProtBus1      => Ch6HProtBus1,
            ChHProtBus2      => Ch6HProtBus2,
            ChBeatCntBus1    => Ch6BeatCntBus1,
            ChBeatCntBus2    => Ch6BeatCntBus2,
            ChAddrIncr1      => Ch6AddrIncBus1,
            ChAddrIncr2      => Ch6AddrIncBus2,
            ChWRITEBus1      => Ch6WriteBus1,
            ChWRITEBus2      => Ch6WriteBus2,
            ChHSIZEBus1      => Ch6HSIZEBus1,
            ChHSIZEBus2      => Ch6HSIZEBus2,
            ChIntTC          => Ch6IntTC,
            ChIntErr         => Ch6IntErr,
            SOFTCLR          => Ch6SOFTCLR,
            DMACTC           => Ch6DMACTC,
            DMACCLR          => Ch6DMACCLR
           );

-- -----------------------------------------------------------------------------
-- Instantiation of DmacTrChLogic7
-- -----------------------------------------------------------------------------
u7DmacTrChLogic : DmacTrChLogic
  port map (
            HCLK             => HCLK,
            HRESETn          => HRESETn,
            ChComb1          => Ch7CombBus1,
            ChComb2          => Ch7CombBus2,
            ChSrcAddrWrEn    => DmacSrcRegWrEn7,
            ChDstAddrWrEn    => DmacDstRegWrEn7,
            ChControlWrEn    => DmacCntlRegWrEn7,
            ChLLIWrEn        => DmacLLIRegWrEn7,
            ChConfigWrEn     => DmacChCnfgWrEn7,
            HWDATA           => HWDATA,
            HRDATAM1         => HRDATAM1,
            HRDATAM2         => HRDATAM2,
            DataValid1       => DataValidBus1,
            DataValid2       => DataValidBus2,
            MREADY1          => MREADY1,
            MREADY2          => MREADY2,
            ErrorMas1        => ErrorMas1,
            ErrorMas2        => ErrorMas2,
            DisAckMas1       => DisAckMas1,
            DisAckMas2       => DisAckMas2,
            MasterEndian1    => MasterEndian1,
            MasterEndian2    => MasterEndian2,
            DMACBREQ         => DMACBREQCh,
            DMACSREQ         => DMACSREQCh,
            DMACLBREQ        => DMACLBREQCh,
            DMACLSREQ        => DMACLSREQCh,
            SOFTBREQ         => SOFTBREQCh,
            SOFTLBREQ        => SOFTLBREQCh,
            SOFTSREQ         => SOFTSREQCh,
            SOFTLSREQ        => SOFTLSREQCh,
            DMACEn           => DMACEn,
            DmacTrEn         => iDmacTrEn,
            ClrIntTC         => ClrIntTC(7),
            ClrIntErr        => ClrIntErr(7),
            ChReqArb1        => Ch7ReqArb1,
            ChReqArb2        => Ch7ReqArb2,
            ChDisableBus1    => Ch7DisableBus1,
            ChDisableBus2    => Ch7DisableBus2,
            HWDATA1          => Ch7HWDATABus1,
            HWDATA2          => Ch7HWDATABus2,
            ChAddrBus1       => Ch7AddrBus1,
            ChAddrBus2       => Ch7AddrBus2,
            ChHLockBus1      => Ch7HLockBus1,
            ChHLockBus2      => Ch7HLockBus2,
            ChHProtBus1      => Ch7HProtBus1,
            ChHProtBus2      => Ch7HProtBus2,
            ChBeatCntBus1    => Ch7BeatCntBus1,
            ChBeatCntBus2    => Ch7BeatCntBus2,
            ChAddrIncr1      => Ch7AddrIncBus1,
            ChAddrIncr2      => Ch7AddrIncBus2,
            ChWRITEBus1      => Ch7WriteBus1,
            ChWRITEBus2      => Ch7WriteBus2,
            ChHSIZEBus1      => Ch7HSIZEBus1,
            ChHSIZEBus2      => Ch7HSIZEBus2,
            ChIntTC          => Ch7IntTC,
            ChIntErr         => Ch7IntErr,
            SOFTCLR          => Ch7SOFTCLR,
            DMACTC           => Ch7DMACTC,
            DMACCLR          => Ch7DMACCLR
           );
-- -----------------------------------------------------------------------------
-- Instantiation of DmacTrRouter
-- -----------------------------------------------------------------------------
uDmacTrRouter : DmacTrRouter
  port map (
            HCLK             => HCLK,
            HRESETn          => HRESETn,
            Ch0Arb1Comb      => Ch0CombBus1,
            Ch1Arb1Comb      => Ch1CombBus1,
            Ch2Arb1Comb      => Ch2CombBus1,
            Ch3Arb1Comb      => Ch3CombBus1,
            Ch4Arb1Comb      => Ch4CombBus1,
            Ch5Arb1Comb      => Ch5CombBus1,
            Ch6Arb1Comb      => Ch6CombBus1,
            Ch7Arb1Comb      => Ch7CombBus1,
            Ch0Arb2Comb      => Ch0CombBus2,
            Ch1Arb2Comb      => Ch1CombBus2,
            Ch2Arb2Comb      => Ch2CombBus2,
            Ch3Arb2Comb      => Ch3CombBus2,
            Ch4Arb2Comb      => Ch4CombBus2,
            Ch5Arb2Comb      => Ch5CombBus2,
            Ch6Arb2Comb      => Ch6CombBus2,
            Ch7Arb2Comb      => Ch7CombBus2,
            Ch0AddrBus1      => Ch0AddrBus1,
            Ch1AddrBus1      => Ch1AddrBus1,
            Ch2AddrBus1      => Ch2AddrBus1,
            Ch3AddrBus1      => Ch3AddrBus1,
            Ch4AddrBus1      => Ch4AddrBus1,
            Ch5AddrBus1      => Ch5AddrBus1,
            Ch6AddrBus1      => Ch6AddrBus1,
            Ch7AddrBus1      => Ch7AddrBus1,
            Ch0AddrBus2      => Ch0AddrBus2,
            Ch1AddrBus2      => Ch1AddrBus2,
            Ch2AddrBus2      => Ch2AddrBus2,
            Ch3AddrBus2      => Ch3AddrBus2,
            Ch4AddrBus2      => Ch4AddrBus2,
            Ch5AddrBus2      => Ch5AddrBus2,
            Ch6AddrBus2      => Ch6AddrBus2,
            Ch7AddrBus2      => Ch7AddrBus2,
            Ch0HProtBus1     => Ch0HProtBus1,
            Ch1HProtBus1     => Ch1HProtBus1,
            Ch2HProtBus1     => Ch2HProtBus1,
            Ch3HProtBus1     => Ch3HProtBus1,
            Ch4HProtBus1     => Ch4HProtBus1,
            Ch5HProtBus1     => Ch5HProtBus1,
            Ch6HProtBus1     => Ch6HProtBus1,
            Ch7HProtBus1     => Ch7HProtBus1,
            Ch0HProtBus2     => Ch0HProtBus2,
            Ch1HProtBus2     => Ch1HProtBus2,
            Ch2HProtBus2     => Ch2HProtBus2,
            Ch3HProtBus2     => Ch3HProtBus2,
            Ch4HProtBus2     => Ch4HProtBus2,
            Ch5HProtBus2     => Ch5HProtBus2,
            Ch6HProtBus2     => Ch6HProtBus2,
            Ch7HProtBus2     => Ch7HProtBus2,
            Ch0HLockBus1     => Ch0HLockBus1,
            Ch1HLockBus1     => Ch1HLockBus1,
            Ch2HLockBus1     => Ch2HLockBus1,
            Ch3HLockBus1     => Ch3HLockBus1,
            Ch4HLockBus1     => Ch4HLockBus1,
            Ch5HLockBus1     => Ch5HLockBus1,
            Ch6HLockBus1     => Ch6HLockBus1,
            Ch7HLockBus1     => Ch7HLockBus1,
            Ch0HLockBus2     => Ch0HLockBus2,
            Ch1HLockBus2     => Ch1HLockBus2,
            Ch2HLockBus2     => Ch2HLockBus2,
            Ch3HLockBus2     => Ch3HLockBus2,
            Ch4HLockBus2     => Ch4HLockBus2,
            Ch5HLockBus2     => Ch5HLockBus2,
            Ch6HLockBus2     => Ch6HLockBus2,
            Ch7HLockBus2     => Ch7HLockBus2,
            Ch0AddrIncBus1   => Ch0AddrIncBus1,
            Ch1AddrIncBus1   => Ch1AddrIncBus1,
            Ch2AddrIncBus1   => Ch2AddrIncBus1,
            Ch3AddrIncBus1   => Ch3AddrIncBus1,
            Ch4AddrIncBus1   => Ch4AddrIncBus1,
            Ch5AddrIncBus1   => Ch5AddrIncBus1,
            Ch6AddrIncBus1   => Ch6AddrIncBus1,
            Ch7AddrIncBus1   => Ch7AddrIncBus1,
            Ch0AddrIncBus2   => Ch0AddrIncBus2,
            Ch1AddrIncBus2   => Ch1AddrIncBus2,
            Ch2AddrIncBus2   => Ch2AddrIncBus2,
            Ch3AddrIncBus2   => Ch3AddrIncBus2,
            Ch4AddrIncBus2   => Ch4AddrIncBus2,
            Ch5AddrIncBus2   => Ch5AddrIncBus2,
            Ch6AddrIncBus2   => Ch6AddrIncBus2,
            Ch7AddrIncBus2   => Ch7AddrIncBus2,
            Ch0DisableBus1   => Ch0DisableBus1,
            Ch1DisableBus1   => Ch1DisableBus1,
            Ch2DisableBus1   => Ch2DisableBus1,
            Ch3DisableBus1   => Ch3DisableBus1,
            Ch4DisableBus1   => Ch4DisableBus1,
            Ch5DisableBus1   => Ch5DisableBus1,
            Ch6DisableBus1   => Ch6DisableBus1,
            Ch7DisableBus1   => Ch7DisableBus1,
            Ch0DisableBus2   => Ch0DisableBus2,
            Ch1DisableBus2   => Ch1DisableBus2,
            Ch2DisableBus2   => Ch2DisableBus2,
            Ch3DisableBus2   => Ch3DisableBus2,
            Ch4DisableBus2   => Ch4DisableBus2,
            Ch5DisableBus2   => Ch5DisableBus2,
            Ch6DisableBus2   => Ch6DisableBus2,
            Ch7DisableBus2   => Ch7DisableBus2,
            Ch0BeatCntBus1   => Ch0BeatCntBus1,
            Ch1BeatCntBus1   => Ch1BeatCntBus1,
            Ch2BeatCntBus1   => Ch2BeatCntBus1,
            Ch3BeatCntBus1   => Ch3BeatCntBus1,
            Ch4BeatCntBus1   => Ch4BeatCntBus1,
            Ch5BeatCntBus1   => Ch5BeatCntBus1,
            Ch6BeatCntBus1   => Ch6BeatCntBus1,
            Ch7BeatCntBus1   => Ch7BeatCntBus1,
            Ch0BeatCntBus2   => Ch0BeatCntBus2,
            Ch1BeatCntBus2   => Ch1BeatCntBus2,
            Ch2BeatCntBus2   => Ch2BeatCntBus2,
            Ch3BeatCntBus2   => Ch3BeatCntBus2,
            Ch4BeatCntBus2   => Ch4BeatCntBus2,
            Ch5BeatCntBus2   => Ch5BeatCntBus2,
            Ch6BeatCntBus2   => Ch6BeatCntBus2,
            Ch7BeatCntBus2   => Ch7BeatCntBus2,
            Ch0WriteBus1     => Ch0WriteBus1,
            Ch1WriteBus1     => Ch1WriteBus1,
            Ch2WriteBus1     => Ch2WriteBus1,
            Ch3WriteBus1     => Ch3WriteBus1,
            Ch4WriteBus1     => Ch4WriteBus1,
            Ch5WriteBus1     => Ch5WriteBus1,
            Ch6WriteBus1     => Ch6WriteBus1,
            Ch7WriteBus1     => Ch7WriteBus1,
            Ch0WriteBus2     => Ch0WriteBus2,
            Ch1WriteBus2     => Ch1WriteBus2,
            Ch2WriteBus2     => Ch2WriteBus2,
            Ch3WriteBus2     => Ch3WriteBus2,
            Ch4WriteBus2     => Ch4WriteBus2,
            Ch5WriteBus2     => Ch5WriteBus2,
            Ch6WriteBus2     => Ch6WriteBus2,
            Ch7WriteBus2     => Ch7WriteBus2,
            Ch0HSIZEBus1     => Ch0HSIZEBus1,
            Ch1HSIZEBus1     => Ch1HSIZEBus1,
            Ch2HSIZEBus1     => Ch2HSIZEBus1,
            Ch3HSIZEBus1     => Ch3HSIZEBus1,
            Ch4HSIZEBus1     => Ch4HSIZEBus1,
            Ch5HSIZEBus1     => Ch5HSIZEBus1,
            Ch6HSIZEBus1     => Ch6HSIZEBus1,
            Ch7HSIZEBus1     => Ch7HSIZEBus1,
            Ch0HSIZEBus2     => Ch0HSIZEBus2,
            Ch1HSIZEBus2     => Ch1HSIZEBus2,
            Ch2HSIZEBus2     => Ch2HSIZEBus2,
            Ch3HSIZEBus2     => Ch3HSIZEBus2,
            Ch4HSIZEBus2     => Ch4HSIZEBus2,
            Ch5HSIZEBus2     => Ch5HSIZEBus2,
            Ch6HSIZEBus2     => Ch6HSIZEBus2,
            Ch7HSIZEBus2     => Ch7HSIZEBus2,
            StopArb1         => StopArb1,
            StopArb2         => StopArb2,
            Ch0SOFTCLR       => Ch0SOFTCLR,
            Ch1SOFTCLR       => Ch1SOFTCLR,
            Ch2SOFTCLR       => Ch2SOFTCLR,
            Ch3SOFTCLR       => Ch3SOFTCLR,
            Ch4SOFTCLR       => Ch4SOFTCLR,
            Ch5SOFTCLR       => Ch5SOFTCLR,
            Ch6SOFTCLR       => Ch6SOFTCLR,
            Ch7SOFTCLR       => Ch7SOFTCLR,
            Ch0DMACTC        => Ch0DMACTC,
            Ch1DMACTC        => Ch1DMACTC,
            Ch2DMACTC        => Ch2DMACTC,
            Ch3DMACTC        => Ch3DMACTC,
            Ch4DMACTC        => Ch4DMACTC,
            Ch5DMACTC        => Ch5DMACTC,
            Ch6DMACTC        => Ch6DMACTC,
            Ch7DMACTC        => Ch7DMACTC,
            Ch0DMACCLR       => Ch0DMACCLR,
            Ch1DMACCLR       => Ch1DMACCLR,
            Ch2DMACCLR       => Ch2DMACCLR,
            Ch3DMACCLR       => Ch3DMACCLR,
            Ch4DMACCLR       => Ch4DMACCLR,
            Ch5DMACCLR       => Ch5DMACCLR,
            Ch6DMACCLR       => Ch6DMACCLR,
            Ch7DMACCLR       => Ch7DMACCLR,
            ChHLOCKBus1      => ChHLOCKBus1,
            ChHLOCKBus2      => ChHLOCKBus2,
            ChWRITEBus1      => ChWRITEBus1,
            ChWRITEBus2      => ChWRITEBus2,
            ChAddrIncrBus1   => ChAddrIncrBus1,
            ChAddrIncrBus2   => ChAddrIncrBus2,
            ChDisableBus1    => ChDisableBus1,
            ChDisableBus2    => ChDisableBus2,
            ChPriorityBus1   => ChPriorityBus1,
            ChPriorityBus2   => ChPriorityBus2,
            ChHProtBus1      => ChHProtBus1,
            ChHProtBus2      => ChHProtBus2,
            ChHSIZEBus1      => ChHSIZEBus1,
            ChHSIZEBus2      => ChHSIZEBus2,
            ChAddrBus1       => ChAddrBus1,
            ChAddrBus2       => ChAddrBus2,
            ChBeatCountBus1  => ChBeatCountBus1,
            ChBeatCountBus2  => ChBeatCountBus2,
            SOFTCLR          => SOFTCLR,
            DMACCLR          => iDMACCLR,
            DMACTC           => DMACTC
           );

-- -----------------------------------------------------------------------------
-- Assign internal copies of signals to output ports
-- -----------------------------------------------------------------------------
DMACCLR           <= iDMACCLR;
DMACINTTC         <= iDMACINTTC;
DMACINTR          <= iDMACINTR;
DMACINTERR        <= iDMACINTERR;

-- -----------------------------------------------------------------------------
-- ORing of INTTC and INTERR from 8 Channels
-- -----------------------------------------------------------------------------
iDMACINTTC        <= Ch0IntTC or Ch1IntTC or Ch2IntTC or Ch3IntTC or Ch4IntTC or
                     Ch5IntTC or Ch6IntTC or Ch7IntTC;

iDMACINTERR       <= Ch0IntErr or Ch1IntErr or Ch2IntErr or Ch3IntErr or
                     Ch4IntErr or Ch5IntErr or Ch6IntErr or Ch7IntErr;
-- -----------------------------------------------------------------------------
-- ORing of INTTC and INTERR
-- -----------------------------------------------------------------------------
iDMACINTR         <= iDMACINTTC or iDMACINTERR;

end structural;

-- --================================== End ==================================--
