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
-- File Name              : DmacTrRouter.vhd.rca
-- File Revision          : 1.5
--
-- Release Information    : PrimeCell(TM)-PL081-REL1v0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           This module is responsible for routing the channel resources
--
-- --=========================================================================--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

-- -----------------------------------------------------------------------------

entity DmacTrRouter is
  port (
-- Inputs
        HCLK             : in    std_logic; -- AHB Clock
        HRESETn          : in    std_logic; -- AHB Reset
        Ch0Arb1Comb      : in    std_logic; -- Channel0 Selected on Bus1
        Ch1Arb1Comb      : in    std_logic; -- Channel1 Selected on Bus1
        Ch2Arb1Comb      : in    std_logic; -- Channel2 Selected on Bus1
        Ch3Arb1Comb      : in    std_logic; -- Channel3 Selected on Bus1
        Ch4Arb1Comb      : in    std_logic; -- Channel4 Selected on Bus1
        Ch5Arb1Comb      : in    std_logic; -- Channel5 Selected on Bus1
        Ch6Arb1Comb      : in    std_logic; -- Channel6 Selected on Bus1
        Ch7Arb1Comb      : in    std_logic; -- Channel7 Selected on Bus1
        Ch0Arb2Comb      : in    std_logic; -- Channel0 Selected on Bus2
        Ch1Arb2Comb      : in    std_logic; -- Channel1 Selected on Bus2
        Ch2Arb2Comb      : in    std_logic; -- Channel2 Selected on Bus2
        Ch3Arb2Comb      : in    std_logic; -- Channel3 Selected on Bus2
        Ch4Arb2Comb      : in    std_logic; -- Channel4 Selected on Bus2
        Ch5Arb2Comb      : in    std_logic; -- Channel5 Selected on Bus2
        Ch6Arb2Comb      : in    std_logic; -- Channel6 Selected on Bus2
        Ch7Arb2Comb      : in    std_logic; -- Channel7 Selected on Bus2
        Ch0AddrBus1      : in    std_logic_vector(31 downto 0);
                                            -- Channel0 Address on Bus1
        Ch1AddrBus1      : in    std_logic_vector(31 downto 0);
                                            -- Channel1 Address on Bus1
        Ch2AddrBus1      : in    std_logic_vector(31 downto 0);
                                            -- Channel2 Address on Bus1
        Ch3AddrBus1      : in    std_logic_vector(31 downto 0);
                                            -- Channel3 Address on Bus1
        Ch4AddrBus1      : in    std_logic_vector(31 downto 0);
                                            -- Channel4 Address on Bus1
        Ch5AddrBus1      : in    std_logic_vector(31 downto 0);
                                            -- Channel5 Address on Bus1
        Ch6AddrBus1      : in    std_logic_vector(31 downto 0);
                                            -- Channel6 Address on Bus1
        Ch7AddrBus1      : in    std_logic_vector(31 downto 0);
                                            -- Channel7 Address on Bus1
        Ch0AddrBus2      : in    std_logic_vector(31 downto 0);
                                            -- Channel0 Address on Bus2
        Ch1AddrBus2      : in    std_logic_vector(31 downto 0);
                                            -- Channel1 Address on Bus2
        Ch2AddrBus2      : in    std_logic_vector(31 downto 0);
                                            -- Channel2 Address on Bus2
        Ch3AddrBus2      : in    std_logic_vector(31 downto 0);
                                            -- Channel3 Address on Bus2
        Ch4AddrBus2      : in    std_logic_vector(31 downto 0);
                                            -- Channel4 Address on Bus2
        Ch5AddrBus2      : in    std_logic_vector(31 downto 0);
                                            -- Channel5 Address on Bus2
        Ch6AddrBus2      : in    std_logic_vector(31 downto 0);
                                            -- Channel6 Address on Bus2
        Ch7AddrBus2      : in    std_logic_vector(31 downto 0);
                                            -- Channel7 Address on Bus2
        Ch0HProtBus1     : in    std_logic_vector(3 downto 0);
                                            -- Channel0 HPROT inf on Bus1
        Ch1HProtBus1     : in    std_logic_vector(3 downto 0);
                                            -- Channel1 HPROT inf on Bus1
        Ch2HProtBus1     : in    std_logic_vector(3 downto 0);
                                            -- Channel2 HPROT inf on Bus1
        Ch3HProtBus1     : in    std_logic_vector(3 downto 0);
                                            -- Channel3 HPROT inf on Bus1
        Ch4HProtBus1     : in    std_logic_vector(3 downto 0);
                                            -- Channel4 HPROT inf on Bus1
        Ch5HProtBus1     : in    std_logic_vector(3 downto 0);
                                            -- Channel5 HPROT inf on Bus1
        Ch6HProtBus1     : in    std_logic_vector(3 downto 0);
                                            -- Channel6 HPROT inf on Bus1
        Ch7HProtBus1     : in    std_logic_vector(3 downto 0);
                                            -- Channel7 HPROT inf on Bus1
        Ch0HProtBus2     : in    std_logic_vector(3 downto 0);
                                            -- Channel0 HPROT inf on Bus2
        Ch1HProtBus2     : in    std_logic_vector(3 downto 0);
                                            -- Channel1 HPROT inf on Bus2
        Ch2HProtBus2     : in    std_logic_vector(3 downto 0);
                                            -- Channel2 HPROT inf on Bus2
        Ch3HProtBus2     : in    std_logic_vector(3 downto 0);
                                            -- Channel3 HPROT inf on Bus2
        Ch4HProtBus2     : in    std_logic_vector(3 downto 0);
                                            -- Channel4 HPROT inf on Bus2
        Ch5HProtBus2     : in    std_logic_vector(3 downto 0);
                                            -- Channel5 HPROT inf on Bus2
        Ch6HProtBus2     : in    std_logic_vector(3 downto 0);
                                            -- Channel6 HPROT inf on Bus2
        Ch7HProtBus2     : in    std_logic_vector(3 downto 0);
                                            -- Channel7 HPROT inf on Bus2
        Ch0HLockBus1     : in    std_logic; -- Channel0 Lock on Bus1
        Ch1HLockBus1     : in    std_logic; -- Channel1 Lock on Bus1
        Ch2HLockBus1     : in    std_logic; -- Channel2 Lock on Bus1
        Ch3HLockBus1     : in    std_logic; -- Channel3 Lock on Bus1
        Ch4HLockBus1     : in    std_logic; -- Channel4 Lock on Bus1
        Ch5HLockBus1     : in    std_logic; -- Channel5 Lock on Bus1
        Ch6HLockBus1     : in    std_logic; -- Channel6 Lock on Bus1
        Ch7HLockBus1     : in    std_logic; -- Channel7 Lock on Bus1
        Ch0HLockBus2     : in    std_logic; -- Channel0 Lock on Bus2
        Ch1HLockBus2     : in    std_logic; -- Channel1 Lock on Bus2
        Ch2HLockBus2     : in    std_logic; -- Channel2 Lock on Bus2
        Ch3HLockBus2     : in    std_logic; -- Channel3 Lock on Bus2
        Ch4HLockBus2     : in    std_logic; -- Channel4 Lock on Bus2
        Ch5HLockBus2     : in    std_logic; -- Channel5 Lock on Bus2
        Ch6HLockBus2     : in    std_logic; -- Channel6 Lock on Bus2
        Ch7HLockBus2     : in    std_logic; -- Channel7 Lock on Bus2
        Ch0AddrIncBus1   : in    std_logic; -- Channel0 Address Incr on Bus1
        Ch1AddrIncBus1   : in    std_logic; -- Channel1 Address Incr on Bus1
        Ch2AddrIncBus1   : in    std_logic; -- Channel2 Address Incr on Bus1
        Ch3AddrIncBus1   : in    std_logic; -- Channel3 Address Incr on Bus1
        Ch4AddrIncBus1   : in    std_logic; -- Channel4 Address Incr on Bus1
        Ch5AddrIncBus1   : in    std_logic; -- Channel5 Address Incr on Bus1
        Ch6AddrIncBus1   : in    std_logic; -- Channel6 Address Incr on Bus1
        Ch7AddrIncBus1   : in    std_logic; -- Channel7 Address Incr on Bus1
        Ch0AddrIncBus2   : in    std_logic; -- Channel0 Address Incr on Bus2
        Ch1AddrIncBus2   : in    std_logic; -- Channel1 Address Incr on Bus2
        Ch2AddrIncBus2   : in    std_logic; -- Channel2 Address Incr on Bus2
        Ch3AddrIncBus2   : in    std_logic; -- Channel3 Address Incr on Bus2
        Ch4AddrIncBus2   : in    std_logic; -- Channel4 Address Incr on Bus2
        Ch5AddrIncBus2   : in    std_logic; -- Channel5 Address Incr on Bus2
        Ch6AddrIncBus2   : in    std_logic; -- Channel6 Address Incr on Bus2
        Ch7AddrIncBus2   : in    std_logic; -- Channel7 Address Incr on Bus2
        Ch0DisableBus1   : in    std_logic; -- Channel0 Disable for Bus1
        Ch1DisableBus1   : in    std_logic; -- Channel1 Disable for Bus1
        Ch2DisableBus1   : in    std_logic; -- Channel2 Disable for Bus1
        Ch3DisableBus1   : in    std_logic; -- Channel3 Disable for Bus1
        Ch4DisableBus1   : in    std_logic; -- Channel4 Disable for Bus1
        Ch5DisableBus1   : in    std_logic; -- Channel5 Disable for Bus1
        Ch6DisableBus1   : in    std_logic; -- Channel6 Disable for Bus1
        Ch7DisableBus1   : in    std_logic; -- Channel7 Disable for Bus1
        Ch0DisableBus2   : in    std_logic; -- Channel0 Disable for Bus2
        Ch1DisableBus2   : in    std_logic; -- Channel1 Disable for Bus2
        Ch2DisableBus2   : in    std_logic; -- Channel2 Disable for Bus2
        Ch3DisableBus2   : in    std_logic; -- Channel3 Disable for Bus2
        Ch4DisableBus2   : in    std_logic; -- Channel4 Disable for Bus2
        Ch5DisableBus2   : in    std_logic; -- Channel5 Disable for Bus2
        Ch6DisableBus2   : in    std_logic; -- Channel6 Disable for Bus2
        Ch7DisableBus2   : in    std_logic; -- Channel7 Disable for Bus2
        Ch0BeatCntBus1   : in    std_logic_vector(4 downto 0);
                                            -- Channel0 BeatCount for Bus1
        Ch1BeatCntBus1   : in    std_logic_vector(4 downto 0);
                                            -- Channel1 BeatCount for Bus1
        Ch2BeatCntBus1   : in    std_logic_vector(4 downto 0);
                                            -- Channel2 BeatCount for Bus1
        Ch3BeatCntBus1   : in    std_logic_vector(4 downto 0);
                                            -- Channel3 BeatCount for Bus1
        Ch4BeatCntBus1   : in    std_logic_vector(4 downto 0);
                                            -- Channel4 BeatCount for Bus1
        Ch5BeatCntBus1   : in    std_logic_vector(4 downto 0);
                                            -- Channel5 BeatCount for Bus1
        Ch6BeatCntBus1   : in    std_logic_vector(4 downto 0);
                                            -- Channel6 BeatCount for Bus1
        Ch7BeatCntBus1   : in    std_logic_vector(4 downto 0);
                                            -- Channel7 BeatCount for Bus1
        Ch0BeatCntBus2   : in    std_logic_vector(4 downto 0);
                                            -- Channel0 BeatCount for Bus2
        Ch1BeatCntBus2   : in    std_logic_vector(4 downto 0);
                                            -- Channel1 BeatCount for Bus2
        Ch2BeatCntBus2   : in    std_logic_vector(4 downto 0);
                                            -- Channel2 BeatCount for Bus2
        Ch3BeatCntBus2   : in    std_logic_vector(4 downto 0);
                                            -- Channel3 BeatCount for Bus2
        Ch4BeatCntBus2   : in    std_logic_vector(4 downto 0);
                                            -- Channel4 BeatCount for Bus2
        Ch5BeatCntBus2   : in    std_logic_vector(4 downto 0);
                                            -- Channel5 BeatCount for Bus2
        Ch6BeatCntBus2   : in    std_logic_vector(4 downto 0);
                                            -- Channel6 BeatCount for Bus2
        Ch7BeatCntBus2   : in    std_logic_vector(4 downto 0);
                                            -- Channel7 BeatCount for Bus2
        Ch0WriteBus1     : in    std_logic; -- Channel0 HWRITE for Bus1
        Ch1WriteBus1     : in    std_logic; -- Channel1 HWRITE for Bus1
        Ch2WriteBus1     : in    std_logic; -- Channel2 HWRITE for Bus1
        Ch3WriteBus1     : in    std_logic; -- Channel3 HWRITE for Bus1
        Ch4WriteBus1     : in    std_logic; -- Channel4 HWRITE for Bus1
        Ch5WriteBus1     : in    std_logic; -- Channel5 HWRITE for Bus1
        Ch6WriteBus1     : in    std_logic; -- Channel6 HWRITE for Bus1
        Ch7WriteBus1     : in    std_logic; -- Channel7 HWRITE for Bus1
        Ch0WriteBus2     : in    std_logic; -- Channel0 HWRITE for Bus2
        Ch1WriteBus2     : in    std_logic; -- Channel1 HWRITE for Bus2
        Ch2WriteBus2     : in    std_logic; -- Channel2 HWRITE for Bus2
        Ch3WriteBus2     : in    std_logic; -- Channel3 HWRITE for Bus2
        Ch4WriteBus2     : in    std_logic; -- Channel4 HWRITE for Bus2
        Ch5WriteBus2     : in    std_logic; -- Channel5 HWRITE for Bus2
        Ch6WriteBus2     : in    std_logic; -- Channel6 HWRITE for Bus2
        Ch7WriteBus2     : in    std_logic; -- Channel7 HWRITE for Bus2
        Ch0HSIZEBus1     : in    std_logic_vector(2 downto 0);
                                            -- Channel0 Hsize for Mas1
        Ch1HSIZEBus1     : in    std_logic_vector(2 downto 0);
                                            -- Channel1 Hsize for Mas1
        Ch2HSIZEBus1     : in    std_logic_vector(2 downto 0);
                                            -- Channel2 Hsize for Mas1
        Ch3HSIZEBus1     : in    std_logic_vector(2 downto 0);
                                            -- Channel3 Hsize for Mas1
        Ch4HSIZEBus1     : in    std_logic_vector(2 downto 0);
                                            -- Channel4 Hsize for Mas1
        Ch5HSIZEBus1     : in    std_logic_vector(2 downto 0);
                                            -- Channel5 Hsize for Mas1
        Ch6HSIZEBus1     : in    std_logic_vector(2 downto 0);
                                            -- Channel6 Hsize for Mas1
        Ch7HSIZEBus1     : in    std_logic_vector(2 downto 0);
                                            -- Channel7 Hsize for Mas1
        Ch0HSIZEBus2     : in    std_logic_vector(2 downto 0);
                                            -- Channel0 Hsize for Mas2
        Ch1HSIZEBus2     : in    std_logic_vector(2 downto 0);
                                            -- Channel1 Hsize for Mas2
        Ch2HSIZEBus2     : in    std_logic_vector(2 downto 0);
                                            -- Channel2 Hsize for Mas2
        Ch3HSIZEBus2     : in    std_logic_vector(2 downto 0);
                                            -- Channel3 Hsize for Mas2
        Ch4HSIZEBus2     : in    std_logic_vector(2 downto 0);
                                            -- Channel4 Hsize for Mas2
        Ch5HSIZEBus2     : in    std_logic_vector(2 downto 0);
                                            -- Channel5 Hsize for Mas2
        Ch6HSIZEBus2     : in    std_logic_vector(2 downto 0);
                                            -- Channel6 Hsize for Mas2
        Ch7HSIZEBus2     : in    std_logic_vector(2 downto 0);
                                            -- Channel7 Hsize for Mas2
        StopArb1         : in    std_logic; -- Stop Arbitration from Mas1
        StopArb2         : in    std_logic; -- Stop Arbitration from Mas2
        Ch0SOFTCLR       : in    std_logic_vector(15 downto 0);
                                            -- Channel0 SoftReq Clear Generation
        Ch1SOFTCLR       : in    std_logic_vector(15 downto 0);
                                            -- Channel1 SoftClear Generation
        Ch2SOFTCLR       : in    std_logic_vector(15 downto 0);
                                            -- Channel2 SoftClear Generation
        Ch3SOFTCLR       : in    std_logic_vector(15 downto 0);
                                            -- Channel3 SoftClear Generation
        Ch4SOFTCLR       : in    std_logic_vector(15 downto 0);
                                            -- Channel4 SoftClear Generation
        Ch5SOFTCLR       : in    std_logic_vector(15 downto 0);
                                            -- Channel5 SoftClear Generation
        Ch6SOFTCLR       : in    std_logic_vector(15 downto 0);
                                            -- Channel6 SoftClear Generation
        Ch7SOFTCLR       : in    std_logic_vector(15 downto 0);
                                            -- Channel7 SoftClear Generation
        Ch0DMACTC        : in    std_logic_vector(15 downto 0);
                                            -- Channel0 TC Generation
        Ch1DMACTC        : in    std_logic_vector(15 downto 0);
                                            -- Channel1 TC Generation
        Ch2DMACTC        : in    std_logic_vector(15 downto 0);
                                            -- Channel2 TC Generation
        Ch3DMACTC        : in    std_logic_vector(15 downto 0);
                                            -- Channel3 TC Generation
        Ch4DMACTC        : in    std_logic_vector(15 downto 0);
                                            -- Channel4 TC Generation
        Ch5DMACTC        : in    std_logic_vector(15 downto 0);
                                            -- Channel5 TC Generation
        Ch6DMACTC        : in    std_logic_vector(15 downto 0);
                                            -- Channel6 TC Generation
        Ch7DMACTC        : in    std_logic_vector(15 downto 0);
                                            -- Channel7 TC Generation
        Ch0DMACCLR       : in    std_logic_vector(15 downto 0);
                                            -- Channel0 Clear Generation
        Ch1DMACCLR       : in    std_logic_vector(15 downto 0);
                                            -- Channel1 Clear Generation
        Ch2DMACCLR       : in    std_logic_vector(15 downto 0);
                                            -- Channel2 Clear Generation
        Ch3DMACCLR       : in    std_logic_vector(15 downto 0);
                                            -- Channel3 Clear Generation
        Ch4DMACCLR       : in    std_logic_vector(15 downto 0);
                                            -- Channel4 Clear Generation
        Ch5DMACCLR       : in    std_logic_vector(15 downto 0);
                                            -- Channel5 Clear Generation
        Ch6DMACCLR       : in    std_logic_vector(15 downto 0);
                                            -- Channel6 Clear Generation
        Ch7DMACCLR       : in    std_logic_vector(15 downto 0);
                                            -- Channel7 Clear Generation
-- Outputs
        ChHLOCKBus1      : out   std_logic; -- HLOCK for Bus1
        ChHLOCKBus2      : out   std_logic; -- HLOCK for Bus2
        ChWRITEBus1      : out   std_logic; -- HWRITE for Bus1
        ChWRITEBus2      : out   std_logic; -- HWRITE for Bus2
        ChAddrIncrBus1   : out   std_logic; -- Channel Addr Increment for Bus1
        ChAddrIncrBus2   : out   std_logic; -- Channel Addr Increment for Bus2
        ChDisableBus1    : out   std_logic; -- Channel disable for Mas1
        ChDisableBus2    : out   std_logic; -- Channel disable for Bus2
        ChPriorityBus1   : out   std_logic; -- Channel priority for Mas1
        ChPriorityBus2   : out   std_logic; -- Channel priority for Mas2
        ChHProtBus1      : out   std_logic_vector(3 downto 0);
                                            -- HPROT for Bus1
        ChHProtBus2      : out   std_logic_vector(3 downto 0);
                                            -- HPROT for Bus2
        ChHSIZEBus1      : out   std_logic_vector(2 downto 0);
                                            -- HSIZE for Bus1
        ChHSIZEBus2      : out   std_logic_vector(2 downto 0);
                                            -- HSIZE for Bus2
        ChAddrBus1       : out   std_logic_vector(31 downto 0);
                                            -- Channel Address for Bus1
        ChAddrBus2       : out   std_logic_vector(31 downto 0);
                                            -- Channel Address for Bus2
        ChBeatCountBus1  : out   std_logic_vector(4 downto 0);
                                            -- BeatCount for Mas1
        ChBeatCountBus2  : out   std_logic_vector(4 downto 0);
                                            -- BeatCount for Mas2
        SOFTCLR          : out   std_logic_vector(15 downto 0);
                                            -- DMAC SoftReq Clear
        DMACCLR          : out   std_logic_vector(15 downto 0);
                                            -- DMAC Clear
        DMACTC           : out   std_logic_vector(15 downto 0)
                                            -- DMAC TC
       );
end DmacTrRouter;

-- -----------------------------------------------------------------------------
--
--                                DmacTrRouter
--                                ============
--
-- -----------------------------------------------------------------------------
--
-- Overview
-- ========
-- This module is responsible for routing the Channel resources on to Bus and
-- Vice-Versa. The routing of resources happens when 1HCLK Comb pulse for each
-- Channel(From Internal Arbiter) is active. In this module some of the Channel
-- resources are registered, so that AHB Master can need not register it.
-- These registered contents are flushed when StopArb is sampled low.
--
-- -----------------------------------------------------------------------------

-- --=========================== ARCHITECTURE ================================--

architecture behavioural of DmacTrRouter is

-- -----------------------------------------------------------------------------
-- Component declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Constant declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Signal declarations
-- -----------------------------------------------------------------------------
signal ChHLOCKBus1Reg   : std_logic;
-- Registered HLOCK information from channel

signal NextChHLOCKBus1  : std_logic;
-- D-Input of ChHLOCKBus1Reg

signal CombChHLOCKBus1  : std_logic;
-- Signal active for 1 HCLK wide

signal ChWRITEBus1Reg   : std_logic;
-- Registered WRITE information from channel

signal NextChWRITEBus1  : std_logic;
-- D-Input of ChWRITEBus1Reg

signal CombChWRITEBus1  : std_logic;
-- Signal active for 1 HCLK wide

signal AddrIncBus1Reg   : std_logic;
-- Registered AddrIncr information from channel

signal NextAddrIncBus1  : std_logic;
-- D-Input of AddrIncBus1Reg

signal CombAddrIncBus1  : std_logic;
-- Signal active for 1 HCLK wide

signal ChHProtBus1Reg   : std_logic_vector(3 downto 0);
-- Registered HPROT information from channel

signal NextChHProtBus1  : std_logic_vector(3 downto 0);
-- D-Input of ChHProtBus1Reg

signal CombChHProtBus1  : std_logic_vector(3 downto 0);
-- Signal active for 1 HCLK wide

signal PriBus1Reg       : std_logic;
-- Registered Channel priority information from channel

signal NextPriBus1      : std_logic;
-- D-Input of PriBus1Reg

signal CombPriBus1      : std_logic;
-- Signal active for 1 HCLK wide

signal ChHSIZEBus1Reg   : std_logic_vector(2 downto 0);
-- Registered HSIZE information from channel

signal NextChHSIZEBus1  : std_logic_vector(2 downto 0);
-- D-Input of ChHSIZEBus1Reg

signal CombChHSIZEBus1  : std_logic_vector(2 downto 0);
-- Signal active for 1 HCLK wide

signal ChAddrBus1Reg    : std_logic_vector(31 downto 0);
-- Registered Address information from channel

signal NextChAddrBus1   : std_logic_vector(31 downto 0);
-- D-Input of ChAddrBus1Reg

signal CombChAddrBus1   : std_logic_vector(31 downto 0);
-- Signal active for 1 HCLK wide

signal BeatCntBus1Reg   : std_logic_vector(4 downto 0);
-- Registered BeatCount information from channel

signal NextBeatCntBus1  : std_logic_vector(4 downto 0);
-- D-Input of BeatCntBus1Reg

signal CombBeatCntBus1  : std_logic_vector(4 downto 0);
-- Signal active for 1 HCLK wide

signal ChHLOCKBus2Reg   : std_logic;
-- Registered HLOCK information from channel

signal NextChHLOCKBus2  : std_logic;
-- D-Input of ChHLOCKBus2Reg

signal CombChHLOCKBus2  : std_logic;
-- Signal active for 1 HCLK wide

signal ChWRITEBus2Reg   : std_logic;
-- Registered WRITE information from channel

signal NextChWRITEBus2  : std_logic;
-- D-Input of ChWRITEBus2Reg

signal CombChWRITEBus2  : std_logic;
-- Signal active for 1 HCLK wide

signal AddrIncBus2Reg   : std_logic;
-- Registered AddrIncr information from channel

signal NextAddrIncBus2  : std_logic;
-- D-Input of AddrIncBus2Reg

signal CombAddrIncBus2  : std_logic;
-- Signal active for 1 HCLK wide

signal ChHProtBus2Reg   : std_logic_vector(3 downto 0);
-- Registered HPROT information from channel

signal NextChHProtBus2  : std_logic_vector(3 downto 0);
-- D-Input of ChHProtBus2Reg

signal CombChHProtBus2  : std_logic_vector(3 downto 0);
-- Signal active for 1 HCLK wide

signal PriBus2Reg       : std_logic;
-- Registered Channel priority information from channel

signal NextPriBus2      : std_logic;
-- D-Input of PriBus2Reg

signal CombPriBus2      : std_logic;
-- Signal active for 1 HCLK wide

signal ChHSIZEBus2Reg   : std_logic_vector(2 downto 0);
-- Registered HSIZE information from channel

signal NextChHSIZEBus2  : std_logic_vector(2 downto 0);
-- D-Input of ChHSIZEBus2Reg

signal CombChHSIZEBus2  : std_logic_vector(2 downto 0);
-- Signal active for 1 HCLK wide

signal ChAddrBus2Reg    : std_logic_vector(31 downto 0);
-- Registered Address information from channel

signal NextChAddrBus2   : std_logic_vector(31 downto 0);
-- D-Input of ChAddrBus2Reg

signal CombChAddrBus2   : std_logic_vector(31 downto 0);
-- Signal active for 1 HCLK wide

signal BeatCntBus2Reg   : std_logic_vector(4 downto 0);
-- Registered BeatCount information from channel

signal NextBeatCntBus2  : std_logic_vector(4 downto 0);
-- D-Input of BeatCntBus2Reg

signal CombBeatCntBus2  : std_logic_vector(4 downto 0);
-- Signal active for 1 HCLK wide

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
-- Assigning internal signals to the outputs
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Logic to Route Channel resources to BUS1
-- -----------------------------------------------------------------------------
p_Bus1RouteComb : process (Ch0Arb1Comb, Ch0HLockBus1, Ch0WriteBus1,
                           Ch0AddrIncBus1, Ch0HProtBus1, Ch0HSIZEBus1,
                           Ch0AddrBus1, Ch0BeatCntBus1, Ch1Arb1Comb,
                           Ch1HLockBus1, Ch1WriteBus1, Ch1AddrIncBus1,
                           Ch1HProtBus1, Ch1HSIZEBus1, Ch1AddrBus1,
                           Ch1BeatCntBus1, Ch2Arb1Comb, Ch2HLockBus1,
                           Ch2WriteBus1, Ch2AddrIncBus1, Ch2HProtBus1,
                           Ch2HSIZEBus1, Ch2AddrBus1, Ch2BeatCntBus1,
                           Ch3Arb1Comb, Ch3HLockBus1, Ch3WriteBus1,
                           Ch3AddrIncBus1, Ch3HProtBus1, Ch3HSIZEBus1,
                           Ch3AddrBus1, Ch3BeatCntBus1, Ch4Arb1Comb,
                           Ch4HLockBus1, Ch4WriteBus1, Ch4AddrIncBus1,
                           Ch4HProtBus1, Ch4HSIZEBus1, Ch4AddrBus1,
                           Ch4BeatCntBus1, Ch5Arb1Comb, Ch5HLockBus1,
                           Ch5WriteBus1, Ch5AddrIncBus1, Ch5HProtBus1,
                           Ch5HSIZEBus1, Ch5AddrBus1, Ch5BeatCntBus1,
                           Ch6Arb1Comb, Ch6HLockBus1, Ch6WriteBus1,
                           Ch6AddrIncBus1, Ch6HProtBus1, Ch6HSIZEBus1,
                           Ch6AddrBus1, Ch6BeatCntBus1, Ch7Arb1Comb,
                           Ch7HLockBus1, Ch7WriteBus1, Ch7AddrIncBus1,
                           Ch7HProtBus1, Ch7HSIZEBus1, Ch7AddrBus1,
                           Ch7BeatCntBus1)
begin
    CombChHLOCKBus1 <= '0';
    CombChWRITEBus1 <= '0';
    CombAddrIncBus1 <= '0';
    CombPriBus1     <= '0';
    CombChHProtBus1 <= (others => '0');
    CombChHSIZEBus1 <= (others => '0');
    CombChAddrBus1  <= (others => '0');
    CombBeatCntBus1 <= (others => '0');
  if (Ch0Arb1Comb = '1') then
    CombChHLOCKBus1 <= Ch0HLockBus1;
    CombChWRITEBus1 <= Ch0WriteBus1;
    CombAddrIncBus1 <= Ch0AddrIncBus1;
    CombPriBus1     <= '1';
    CombChHProtBus1 <= Ch0HProtBus1;
    CombChHSIZEBus1 <= Ch0HSIZEBus1;
    CombChAddrBus1  <= Ch0AddrBus1;
    CombBeatCntBus1 <= Ch0BeatCntBus1;
  end if;
  if (Ch1Arb1Comb = '1') then
    CombChHLOCKBus1 <= Ch1HLockBus1;
    CombChWRITEBus1 <= Ch1WriteBus1;
    CombAddrIncBus1 <= Ch1AddrIncBus1;
    CombPriBus1     <= '0';
    -- This change has been done for 2 channel configuration DMAC variant
    -- Where channel 1 is having low priority than channel 0
    CombChHProtBus1 <= Ch1HProtBus1;
    CombChHSIZEBus1 <= Ch1HSIZEBus1;
    CombChAddrBus1  <= Ch1AddrBus1;
    CombBeatCntBus1 <= Ch1BeatCntBus1;
  end if;
  if (Ch2Arb1Comb = '1') then
    CombChHLOCKBus1 <= Ch2HLockBus1;
    CombChWRITEBus1 <= Ch2WriteBus1;
    CombAddrIncBus1 <= Ch2AddrIncBus1;
    CombPriBus1     <= '1';
    CombChHProtBus1 <= Ch2HProtBus1;
    CombChHSIZEBus1 <= Ch2HSIZEBus1;
    CombChAddrBus1  <= Ch2AddrBus1;
    CombBeatCntBus1 <= Ch2BeatCntBus1;
  end if;
  if (Ch3Arb1Comb = '1') then
    CombChHLOCKBus1 <= Ch3HLockBus1;
    CombChWRITEBus1 <= Ch3WriteBus1;
    CombAddrIncBus1 <= Ch3AddrIncBus1;
    CombPriBus1     <= '1';
    CombChHProtBus1 <= Ch3HProtBus1;
    CombChHSIZEBus1 <= Ch3HSIZEBus1;
    CombChAddrBus1  <= Ch3AddrBus1;
    CombBeatCntBus1 <= Ch3BeatCntBus1;
  end if;
  if (Ch4Arb1Comb = '1') then
    CombChHLOCKBus1 <= Ch4HLockBus1;
    CombChWRITEBus1 <= Ch4WriteBus1;
    CombAddrIncBus1 <= Ch4AddrIncBus1;
    CombPriBus1     <= '1';
    CombChHProtBus1 <= Ch4HProtBus1;
    CombChHSIZEBus1 <= Ch4HSIZEBus1;
    CombChAddrBus1  <= Ch4AddrBus1;
    CombBeatCntBus1 <= Ch4BeatCntBus1;
  end if;
  if (Ch5Arb1Comb = '1') then
    CombChHLOCKBus1 <= Ch5HLockBus1;
    CombChWRITEBus1 <= Ch5WriteBus1;
    CombAddrIncBus1 <= Ch5AddrIncBus1;
    CombPriBus1     <= '1';
    CombChHProtBus1 <= Ch5HProtBus1;
    CombChHSIZEBus1 <= Ch5HSIZEBus1;
    CombChAddrBus1  <= Ch5AddrBus1;
    CombBeatCntBus1 <= Ch5BeatCntBus1;
  end if;
  if (Ch6Arb1Comb = '1') then
    CombChHLOCKBus1 <= Ch6HLockBus1;
    CombChWRITEBus1 <= Ch6WriteBus1;
    CombAddrIncBus1 <= Ch6AddrIncBus1;
    CombPriBus1     <= '0';
    CombChHProtBus1 <= Ch6HProtBus1;
    CombChHSIZEBus1 <= Ch6HSIZEBus1;
    CombChAddrBus1  <= Ch6AddrBus1;
    CombBeatCntBus1 <= Ch6BeatCntBus1;
  end if;
  if (Ch7Arb1Comb = '1') then
    CombChHLOCKBus1 <= Ch7HLockBus1;
    CombChWRITEBus1 <= Ch7WriteBus1;
    CombAddrIncBus1 <= Ch7AddrIncBus1;
    CombPriBus1     <= '0';
    CombChHProtBus1 <= Ch7HProtBus1;
    CombChHSIZEBus1 <= Ch7HSIZEBus1;
    CombChAddrBus1  <= Ch7AddrBus1;
    CombBeatCntBus1 <= Ch7BeatCntBus1;
  end if;
end process p_Bus1RouteComb;

-- -----------------------------------------------------------------------------
-- Logic to Route Channel resources to BUS2
-- -----------------------------------------------------------------------------
p_Bus2RouteComb : process (Ch0Arb2Comb, Ch0HLockBus2, Ch0WriteBus2,
                           Ch0AddrIncBus2, Ch0HProtBus2, Ch0HSIZEBus2,
                           Ch0AddrBus2, Ch0BeatCntBus2, Ch1Arb2Comb,
                           Ch1HLockBus2, Ch1WriteBus2, Ch1AddrIncBus2,
                           Ch1HProtBus2, Ch1HSIZEBus2, Ch1AddrBus2,
                           Ch1BeatCntBus2, Ch2Arb2Comb, Ch2HLockBus2,
                           Ch2WriteBus2, Ch2AddrIncBus2, Ch2HProtBus2,
                           Ch2HSIZEBus2, Ch2AddrBus2, Ch2BeatCntBus2,
                           Ch3Arb2Comb, Ch3HLockBus2, Ch3WriteBus2,
                           Ch3AddrIncBus2, Ch3HProtBus2, Ch3HSIZEBus2,
                           Ch3AddrBus2, Ch3BeatCntBus2, Ch4Arb2Comb,
                           Ch4HLockBus2, Ch4WriteBus2, Ch4AddrIncBus2,
                           Ch4HProtBus2, Ch4HSIZEBus2, Ch4AddrBus2,
                           Ch4BeatCntBus2, Ch5Arb2Comb, Ch5HLockBus2,
                           Ch5WriteBus2, Ch5AddrIncBus2, Ch5HProtBus2,
                           Ch5HSIZEBus2, Ch5AddrBus2, Ch5BeatCntBus2,
                           Ch6Arb2Comb, Ch6HLockBus2, Ch6WriteBus2,
                           Ch6AddrIncBus2, Ch6HProtBus2, Ch6HSIZEBus2,
                           Ch6AddrBus2, Ch6BeatCntBus2, Ch7Arb2Comb,
                           Ch7HLockBus2, Ch7WriteBus2, Ch7AddrIncBus2,
                           Ch7HProtBus2, Ch7HSIZEBus2, Ch7AddrBus2,
                           Ch7BeatCntBus2)
begin
    CombChHLOCKBus2 <= '0';
    CombChWRITEBus2 <= '0';
    CombAddrIncBus2 <= '0';
    CombPriBus2     <= '0';
    CombChHProtBus2 <= (others => '0');
    CombChHSIZEBus2 <= (others => '0');
    CombChAddrBus2  <= (others => '0');
    CombBeatCntBus2 <= (others => '0');
  if (Ch0Arb2Comb = '1') then
    CombChHLOCKBus2 <= Ch0HLockBus2;
    CombChWRITEBus2 <= Ch0WriteBus2;
    CombAddrIncBus2 <= Ch0AddrIncBus2;
    CombPriBus2     <= '1';
    CombChHProtBus2 <= Ch0HProtBus2;
    CombChHSIZEBus2 <= Ch0HSIZEBus2;
    CombChAddrBus2  <= Ch0AddrBus2;
    CombBeatCntBus2 <= Ch0BeatCntBus2;
  end if;
  if (Ch1Arb2Comb = '1') then
    CombChHLOCKBus2 <= Ch1HLockBus2;
    CombChWRITEBus2 <= Ch1WriteBus2;
    CombAddrIncBus2 <= Ch1AddrIncBus2;
    CombPriBus2     <= '0';
    -- This change has been done for 2 channel configuration DMAC variant
    -- Where channel 1 is having low priority than channel 0
    CombChHProtBus2 <= Ch1HProtBus2;
    CombChHSIZEBus2 <= Ch1HSIZEBus2;
    CombChAddrBus2  <= Ch1AddrBus2;
    CombBeatCntBus2 <= Ch1BeatCntBus2;
  end if;
  if (Ch2Arb2Comb = '1') then
    CombChHLOCKBus2 <= Ch2HLockBus2;
    CombChWRITEBus2 <= Ch2WriteBus2;
    CombAddrIncBus2 <= Ch2AddrIncBus2;
    CombPriBus2     <= '1';
    CombChHProtBus2 <= Ch2HProtBus2;
    CombChHSIZEBus2 <= Ch2HSIZEBus2;
    CombChAddrBus2  <= Ch2AddrBus2;
    CombBeatCntBus2 <= Ch2BeatCntBus2;
  end if;
  if (Ch3Arb2Comb = '1') then
    CombChHLOCKBus2 <= Ch3HLockBus2;
    CombChWRITEBus2 <= Ch3WriteBus2;
    CombAddrIncBus2 <= Ch3AddrIncBus2;
    CombPriBus2     <= '1';
    CombChHProtBus2 <= Ch3HProtBus2;
    CombChHSIZEBus2 <= Ch3HSIZEBus2;
    CombChAddrBus2  <= Ch3AddrBus2;
    CombBeatCntBus2 <= Ch3BeatCntBus2;
  end if;
  if (Ch4Arb2Comb = '1') then
    CombChHLOCKBus2 <= Ch4HLockBus2;
    CombChWRITEBus2 <= Ch4WriteBus2;
    CombAddrIncBus2 <= Ch4AddrIncBus2;
    CombPriBus2     <= '1';
    CombChHProtBus2 <= Ch4HProtBus2;
    CombChHSIZEBus2 <= Ch4HSIZEBus2;
    CombChAddrBus2  <= Ch4AddrBus2;
    CombBeatCntBus2 <= Ch4BeatCntBus2;
  end if;
  if (Ch5Arb2Comb = '1') then
    CombChHLOCKBus2 <= Ch5HLockBus2;
    CombChWRITEBus2 <= Ch5WriteBus2;
    CombAddrIncBus2 <= Ch5AddrIncBus2;
    CombPriBus2     <= '1';
    CombChHProtBus2 <= Ch5HProtBus2;
    CombChHSIZEBus2 <= Ch5HSIZEBus2;
    CombChAddrBus2  <= Ch5AddrBus2;
    CombBeatCntBus2 <= Ch5BeatCntBus2;
  end if;
  if (Ch6Arb2Comb = '1') then
    CombChHLOCKBus2 <= Ch6HLockBus2;
    CombChWRITEBus2 <= Ch6WriteBus2;
    CombAddrIncBus2 <= Ch6AddrIncBus2;
    CombPriBus2     <= '0';
    CombChHProtBus2 <= Ch6HProtBus2;
    CombChHSIZEBus2 <= Ch6HSIZEBus2;
    CombChAddrBus2  <= Ch6AddrBus2;
    CombBeatCntBus2 <= Ch6BeatCntBus2;
  end if;
  if (Ch7Arb2Comb = '1') then
    CombChHLOCKBus2 <= Ch7HLockBus2;
    CombChWRITEBus2 <= Ch7WriteBus2;
    CombAddrIncBus2 <= Ch7AddrIncBus2;
    CombPriBus2     <= '0';
    CombChHProtBus2 <= Ch7HProtBus2;
    CombChHSIZEBus2 <= Ch7HSIZEBus2;
    CombChAddrBus2  <= Ch7AddrBus2;
    CombBeatCntBus2 <= Ch7BeatCntBus2;
  end if;
end process p_Bus2RouteComb;

-- -----------------------------------------------------------------------------
-- Registering Channel resources which are put on BUS1
-- -----------------------------------------------------------------------------
p_Bus1RegComb : process (ChHLOCKBus1Reg, ChWRITEBus1Reg, AddrIncBus1Reg,
                         PriBus1Reg, ChHProtBus1Reg, ChHSIZEBus1Reg,
                         ChAddrBus1Reg, BeatCntBus1Reg, CombChHLOCKBus1,
                         CombChWRITEBus1, CombAddrIncBus1, CombPriBus1,
                         CombChHProtBus1, CombChHSIZEBus1, CombChAddrBus1,
                         CombBeatCntBus1, StopArb1)
begin
  NextChHLOCKBus1  <= ChHLOCKBus1Reg;
  NextChWRITEBus1  <= ChWRITEBus1Reg;
  NextAddrIncBus1  <= AddrIncBus1Reg;
  NextPriBus1      <= PriBus1Reg;
  NextChHProtBus1  <= ChHProtBus1Reg;
  NextChHSIZEBus1  <= ChHSIZEBus1Reg;
  NextChAddrBus1   <= ChAddrBus1Reg;
  NextBeatCntBus1  <= BeatCntBus1Reg;
  if (StopArb1 = '0') then
    NextChHLOCKBus1  <= CombChHLOCKBus1;
    NextChWRITEBus1  <= CombChWRITEBus1;
    NextAddrIncBus1  <= CombAddrIncBus1;
    NextPriBus1      <= CombPriBus1;
    NextChHProtBus1  <= CombChHProtBus1;
    NextChHSIZEBus1  <= CombChHSIZEBus1;
    NextChAddrBus1   <= CombChAddrBus1;
    NextBeatCntBus1  <= CombBeatCntBus1;
  end if;
end process p_Bus1RegComb;

-- -----------------------------------------------------------------------------
-- Registering all the next state signals
-- -----------------------------------------------------------------------------
p_Bus1RegSeq : process (HRESETn, HCLK)
begin
  if (HRESETn = '0') then
    ChHLOCKBus1Reg  <= '0';
    ChWRITEBus1Reg  <= '0';
    AddrIncBus1Reg  <= '0';
    PriBus1Reg      <= '0';
    ChHProtBus1Reg  <= (others => '0');
    ChHSIZEBus1Reg  <= (others => '0');
    ChAddrBus1Reg   <= (others => '0');
    BeatCntBus1Reg  <= (others => '0');
  elsif (HCLK'event and HCLK = '1') then
    ChHLOCKBus1Reg  <= NextChHLOCKBus1;
    ChWRITEBus1Reg  <= NextChWRITEBus1;
    AddrIncBus1Reg  <= NextAddrIncBus1;
    PriBus1Reg      <= NextPriBus1;
    ChHProtBus1Reg  <= NextChHProtBus1;
    ChHSIZEBus1Reg  <= NextChHSIZEBus1;
    ChAddrBus1Reg   <= NextChAddrBus1;
    BeatCntBus1Reg  <= NextBeatCntBus1;
  end if;
end process p_Bus1RegSeq;

-- -----------------------------------------------------------------------------
-- Routing channel resources on to AHB Master1
-- -----------------------------------------------------------------------------
ChHLOCKBus1     <= NextChHLOCKBus1 or (ChHLOCKBus1Reg and StopArb1);
ChWRITEBus1     <= NextChWRITEBus1 or (ChWRITEBus1Reg and StopArb1);
ChAddrIncrBus1  <= NextAddrIncBus1 or (AddrIncBus1Reg and StopArb1);
ChDisableBus1   <= Ch0DisableBus1 or Ch1DisableBus1 or Ch2DisableBus1 or
                   Ch3DisableBus1 or Ch4DisableBus1 or Ch5DisableBus1 or
                   Ch6DisableBus1 or Ch7DisableBus1;
ChPriorityBus1  <= NextPriBus1 or (PriBus1Reg and StopArb1);
ChHSIZEBus1     <= NextChHSIZEBus1 when (StopArb1 = '0')
                else
                   ChHSIZEBus1Reg;
ChHProtBus1     <= NextChHProtBus1 when (StopArb1 = '0')
                else
                   ChHProtBus1Reg;
ChAddrBus1      <= NextChAddrBus1 when (StopArb1 = '0')
                else
                   ChAddrBus1Reg;
ChBeatCountBus1 <= NextBeatCntBus1 when (StopArb1 = '0')
                else
                   BeatCntBus1Reg;

-- -----------------------------------------------------------------------------
-- Registering Channel resources which are put on BUS2
-- -----------------------------------------------------------------------------
p_Bus2RegComb : process (ChHLOCKBus2Reg, ChWRITEBus2Reg, AddrIncBus2Reg,
                         PriBus2Reg, ChHProtBus2Reg, ChHSIZEBus2Reg,
                         ChAddrBus2Reg, BeatCntBus2Reg, CombChHLOCKBus2,
                         CombChWRITEBus2, CombAddrIncBus2, CombPriBus2,
                         CombChHProtBus2, CombChHSIZEBus2, CombChAddrBus2,
                         CombBeatCntBus2, StopArb2)
begin
  NextChHLOCKBus2  <= ChHLOCKBus2Reg;
  NextChWRITEBus2  <= ChWRITEBus2Reg;
  NextAddrIncBus2  <= AddrIncBus2Reg;
  NextPriBus2      <= PriBus2Reg;
  NextChHProtBus2  <= ChHProtBus2Reg;
  NextChHSIZEBus2  <= ChHSIZEBus2Reg;
  NextChAddrBus2   <= ChAddrBus2Reg;
  NextBeatCntBus2  <= BeatCntBus2Reg;
  if (StopArb2 = '0') then
    NextChHLOCKBus2  <= CombChHLOCKBus2;
    NextChWRITEBus2  <= CombChWRITEBus2;
    NextAddrIncBus2  <= CombAddrIncBus2;
    NextPriBus2      <= CombPriBus2;
    NextChHProtBus2  <= CombChHProtBus2;
    NextChHSIZEBus2  <= CombChHSIZEBus2;
    NextChAddrBus2   <= CombChAddrBus2;
    NextBeatCntBus2  <= CombBeatCntBus2;
  end if;
end process p_Bus2RegComb;

-- -----------------------------------------------------------------------------
-- Routing channel resources on to AHB Master2
-- -----------------------------------------------------------------------------
ChHLOCKBus2     <= NextChHLOCKBus2 or (ChHLOCKBus2Reg and StopArb2);
ChWRITEBus2     <= NextChWRITEBus2 or (ChWRITEBus2Reg and StopArb2);
ChAddrIncrBus2  <= NextAddrIncBus2 or (AddrIncBus2Reg and StopArb2);
ChDisableBus2   <= Ch0DisableBus2 or Ch1DisableBus2 or Ch2DisableBus2 or
                   Ch3DisableBus2 or Ch4DisableBus2 or Ch5DisableBus2 or
                   Ch6DisableBus2 or Ch7DisableBus2;
ChPriorityBus2  <= NextPriBus2 or (PriBus2Reg and StopArb2);
ChHSIZEBus2     <= NextChHSIZEBus2 when (StopArb2 = '0')
                else
                   ChHSIZEBus2Reg;
ChHProtBus2     <= NextChHProtBus2 when (StopArb2 = '0')
                else
                   ChHProtBus2Reg;
ChAddrBus2      <= NextChAddrBus2 when (StopArb2 = '0')
                else
                   ChAddrBus2Reg;
ChBeatCountBus2 <= NextBeatCntBus2 when (StopArb2 = '0')
                else
                   BeatCntBus2Reg;

-- -----------------------------------------------------------------------------
-- Registering all the next state signals
-- -----------------------------------------------------------------------------
p_Bus2RegSeq : process (HRESETn, HCLK)
begin
  if (HRESETn = '0') then
    ChHLOCKBus2Reg  <= '0';
    ChWRITEBus2Reg  <= '0';
    AddrIncBus2Reg  <= '0';
    PriBus2Reg      <= '0';
    ChHProtBus2Reg  <= (others => '0');
    ChHSIZEBus2Reg  <= (others => '0');
    ChAddrBus2Reg   <= (others => '0');
    BeatCntBus2Reg  <= (others => '0');
  elsif (HCLK'event and HCLK = '1') then
    ChHLOCKBus2Reg  <= NextChHLOCKBus2;
    ChWRITEBus2Reg  <= NextChWRITEBus2;
    AddrIncBus2Reg  <= NextAddrIncBus2;
    PriBus2Reg      <= NextPriBus2;
    ChHProtBus2Reg  <= NextChHProtBus2;
    ChHSIZEBus2Reg  <= NextChHSIZEBus2;
    ChAddrBus2Reg   <= NextChAddrBus2;
    BeatCntBus2Reg  <= NextBeatCntBus2;
  end if;
end process p_Bus2RegSeq;

-- -----------------------------------------------------------------------------
-- Logic to Route SOFTCLR Lines on the Bus
-- -----------------------------------------------------------------------------
p_SOFTCLRComb : process (Ch0SOFTCLR, Ch1SOFTCLR, Ch2SOFTCLR, Ch3SOFTCLR,
                         Ch4SOFTCLR, Ch5SOFTCLR, Ch6SOFTCLR, Ch7SOFTCLR)
begin
  SOFTCLR <= Ch0SOFTCLR or Ch1SOFTCLR or Ch2SOFTCLR or Ch3SOFTCLR or
             Ch4SOFTCLR or Ch5SOFTCLR or Ch6SOFTCLR or Ch7SOFTCLR;
end process p_SOFTCLRComb;

-- -----------------------------------------------------------------------------
-- Logic to Route DMACCLR Lines on the Bus
-- -----------------------------------------------------------------------------
p_DMACCLRComb : process (Ch0DMACCLR, Ch1DMACCLR, Ch2DMACCLR, Ch3DMACCLR,
                         Ch4DMACCLR, Ch5DMACCLR, Ch6DMACCLR, Ch7DMACCLR)
begin
  DMACCLR <= Ch0DMACCLR or Ch1DMACCLR or Ch2DMACCLR or Ch3DMACCLR or
             Ch4DMACCLR or Ch5DMACCLR or Ch6DMACCLR or Ch7DMACCLR;
end process p_DMACCLRComb;

-- -----------------------------------------------------------------------------
-- Logic to Route DMACTC Lines on the Bus
-- -----------------------------------------------------------------------------
p_DMACTCComb : process (Ch0DMACTC, Ch1DMACTC, Ch2DMACTC, Ch3DMACTC,
                        Ch4DMACTC, Ch5DMACTC, Ch6DMACTC, Ch7DMACTC)
begin
  DMACTC <= Ch0DMACTC or Ch1DMACTC or Ch2DMACTC or Ch3DMACTC or
            Ch4DMACTC or Ch5DMACTC or Ch6DMACTC or Ch7DMACTC;
end process p_DMACTCComb;

end behavioural;

-- --================================== End ==================================--
