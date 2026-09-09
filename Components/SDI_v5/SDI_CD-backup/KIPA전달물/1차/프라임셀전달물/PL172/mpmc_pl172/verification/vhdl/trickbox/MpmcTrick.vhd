-- --=========================================================================--
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
-- File Name              : MpmcTrick.vhd.rca
-- File Revision          : 1.6
--
-- Release Information    : PrimeCell(TM)-PL172-r2p3-00rel0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           This block is the top level of the MPMC Trickbox.
--
-- --=========================================================================--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

-- -----------------------------------------------------------------------------

entity MpmcTrick is
  generic (
           Tclkl            : time := 10 ns; -- HCLK low time
           Tclkh            : time := 10 ns; -- HCLK high time
           Tclks            : time := 10 ns  -- MPMCCLK start delay
          );
  port (
-- Inputs
        -- AHB bus signals
        HCLK             : in    std_logic; -- AHB Bus Clock
        HRESETn          : in    std_logic; -- Bus Reset
        HADDR0           : in    std_logic_vector(11 downto 2);
                                            -- AHB0 Address Bus
        HADDR1           : in    std_logic_vector(11 downto 2);
                                            -- AHB1 Address Bus
        HADDR2           : in    std_logic_vector(11 downto 2);
                                            -- AHB2 Address Bus
        HADDR3           : in    std_logic_vector(11 downto 2);
                                            -- AHB3 Address Bus
        HTRANS0          : in    std_logic_vector(1 downto 0);
                                            -- Transfer type AHB0
        HTRANS1          : in    std_logic_vector(1 downto 0);
                                            -- Transfer type AHB1
        HTRANS2          : in    std_logic_vector(1 downto 0);
                                            -- Transfer type AHB2
        HTRANS3          : in    std_logic_vector(1 downto 0);
                                            -- Transfer type AHB3
        HWRITE0          : in    std_logic; -- AHB0 Peripheral Write
        HWRITE1          : in    std_logic; -- AHB1 Peripheral Write
        HWRITE2          : in    std_logic; -- AHB2 Peripheral Write
        HWRITE3          : in    std_logic; -- AHB3 Peripheral Write
        HSIZE0           : in    std_logic_vector(2 downto 0);
                                            -- Transfer size AHB0
        HSIZE1           : in    std_logic_vector(2 downto 0);
                                            -- Transfer size AHB1
        HSIZE2           : in    std_logic_vector(2 downto 0);
                                            -- Transfer size AHB2
        HSIZE3           : in    std_logic_vector(2 downto 0);
                                            -- Transfer size AHB3
        HBURST0          : in    std_logic_vector(2 downto 0);
                                            -- AHB0 Burst type
        HBURST1          : in    std_logic_vector(2 downto 0);
                                            -- AHB1 Burst type
        HBURST2          : in    std_logic_vector(2 downto 0);
                                            -- AHB2 Burst type
        HBURST3          : in    std_logic_vector(2 downto 0);
                                            -- AHB3 Burst type
        HREADYIN0        : in    std_logic; -- Multiplexed version of
                                            -- HREADY outputs for AHB0
        HREADYIN1        : in    std_logic; -- Multiplexed version of
                                            -- HREADY outputs for AHB1
        HREADYIN2        : in    std_logic; -- Multiplexed version of
                                            -- HREADY outputs for AHB2
        HREADYIN3        : in    std_logic; -- Multiplexed version of
                                            -- HREADY outputs for AHB3
        HWDATA0          : in    std_logic_vector(31 downto 0);
                                            -- AHB0 Write Data bus
        HWDATA1          : in    std_logic_vector(31 downto 0);
                                            -- AHB1 Write Data bus
        HWDATA2          : in    std_logic_vector(31 downto 0);
                                            -- AHB2 Write Data bus
        HWDATA3          : in    std_logic_vector(31 downto 0);
                                            -- AHB3 Write Data bus
        HSELMPMCTR0      : in    std_logic; -- AHB0 Peripheral (Trickbox)
                                            -- Select
        HSELMPMCTR1      : in    std_logic; -- AHB1 Peripheral (Trickbox)
                                            -- Select
        HSELMPMCTR2      : in    std_logic; -- AHB2 Peripheral (Trickbox)
                                            -- Select
        HSELMPMCTR3      : in    std_logic; -- AHB3 Peripheral (Trickbox)
                                            -- Select
        HSELMPMCREG      : in    std_logic; -- AHB Peripheral (MPMC Reg)
                                            -- Select (for AHB0)
        MPMCCLKOUT       : in    std_logic_vector(3 downto 0);
                                            -- Memory clock out from MPMC
        MPMCCKEOUT       : in    std_logic_vector(3 downto 0);
                                            -- Clock Enable Pin to memory device
        nMPMCRASOUT      : in    std_logic; -- nMPMCRASOUT output from the
                                            -- memory module
        nMPMCCASOUT      : in    std_logic; -- nMPMCCASOUT output from the
                                            -- memory module
        nMPMCDYCSOUT     : in    std_logic_vector(3 downto 0);
                                            -- Synchronise memory Chip Select
                                            -- from MPMC
        nMPMCSTCSOUT     : in    std_logic_vector(3 downto 0);
                                            -- Memory Bank Select signals from
                                            -- the MPMC
        MPMCACTLOWCS     : in    std_logic_vector(3 downto 0);
                                            -- Active low Memory Bank Select
                                            -- from TrickMem
        nMPMCWEOUT       : in    std_logic; -- nMPMCWEOUT output from the memory
                                            -- module
        nMPMCDATAEN      : in    std_logic_vector(3 downto 0);
                                            -- Data Bus enable signal
        nMPMCOEOUT       : in    std_logic; -- Memory read enable
        MPMCDQMOUT       : in    std_logic_vector(3 downto 0);
                                            -- Data Bus Lane Enable signal
        nMPMCRPOUT       : in    std_logic; -- Sync Flash Reset/Power down
                                            -- signal
        MPMCRPVHHOUT     : in    std_logic; -- Sync Flash Reset/Power down
                                            -- to be driven to VHH
        MPMCSREFACK      : in    std_logic; -- Self referesh acknowledge from
                                            -- MPMC
        MPMCADDROUT      : in    std_logic_vector(27 downto 0);
                                            -- Memory Address from the MPMC
        MPMCDATAIN       : in    std_logic_vector(31 downto 0);
                                            -- Memory Data Out from the MPMC
        MPMCDATAOUT      : in    std_logic_vector(31 downto 0);
                                            -- Memory Data Out from the MPMC
        MPMCEBIREQ       : in    std_logic; -- EBI request from the MPMC

        HREADYOutMpmc0   : in    std_logic; -- HREADYOUT of Port0
        HREADYOutMpmc1   : in    std_logic; -- HREADYOUT of Port1

-- Outputs
        MPMCTrStExtWt    : out   std_logic_vector(9 downto 0);
                                            -- Extended Wait count to the
                                            -- memory block
        HREADYOUT0       : out   std_logic; -- Slave HREADY output (AHB0)
        HREADYOUT1       : out   std_logic; -- Slave HREADY output (AHB1)
        HREADYOUT2       : out   std_logic; -- Slave HREADY output (AHB2)
        HREADYOUT3       : out   std_logic; -- Slave HREADY output (AHB3)
        HRESP0           : out   std_logic_vector(1 downto 0);
                                            -- Slave response (AHB0)
        HRESP1           : out   std_logic_vector(1 downto 0);
                                            -- Slave response (AHB1)
        HRESP2           : out   std_logic_vector(1 downto 0);
                                            -- Slave response (AHB2)
        HRESP3           : out   std_logic_vector(1 downto 0);
                                            -- Slave response (AHB3)
        MPMCEBIGNT       : out   std_logic; -- EBI grant to the controller
        MPMCEBIBACKOFF   : out   std_logic; -- EBI backoff to the controller
        MPMCCLK          : out   std_logic; -- Memory clock to the MPMC
        MPMCCLKDELAY     : out   std_logic; -- Delayed Memory clock to the MPMC
        nPOR             : out   std_logic; -- Power On Reset
        MPMCSREFREQ      : out   std_logic; -- Self refersh reques to MPMC
        MPMCBIGENDIAN    : out   std_logic; -- Endianness
        MPMCSTCS0POL     : out   std_logic; -- Indicates CS1 polarity
        MPMCSTCS1POL     : out   std_logic; -- Indicates CS2 polarity
        MPMCSTCS2POL     : out   std_logic; -- Indicates CS3 polarity
        MPMCSTCS3POL     : out   std_logic; -- Indicates CS4 polarity
        MPMCSTCS1MW      : out   std_logic_vector(1 downto 0);
                                            -- Indicates CS1 memory width
        MPMCSTCS1PB      : out   std_logic; -- Indicates BLS for CS1
        HRDATA0          : out   std_logic_vector(31 downto 0);
                                            -- AHB0 Read Data bus
        HRDATA1          : out   std_logic_vector(31 downto 0);
                                            -- AHB1 Read Data bus
        HRDATA2          : out   std_logic_vector(31 downto 0);
                                            -- AHB2 Read Data bus
        HRDATA3          : out   std_logic_vector(31 downto 0)
                                            -- AHB3 Read Data bus
       );
end MpmcTrick;

-- -----------------------------------------------------------------------------
--
--                                  MpmcTrick
--                                  =========
--
-- -----------------------------------------------------------------------------
--
-- Overview
-- ========
--   This block is the top level of the Trickbox. This block instantiates the
-- following functional sub-blocks in the trickbox.
--      - MpmcTrAhbif
--      - MpmcTrRegBlk
--      - MpmcTrClkResGen
--      - MpmcTrProChkr
--      - MpmcTrSnp
--
-- -----------------------------------------------------------------------------


-- --=========================== ARCHITECTURE ================================--

architecture structural of MpmcTrick is

-- -----------------------------------------------------------------------------
-- Component declarations
-- -----------------------------------------------------------------------------
component MpmcTrAhbif
  port (
        HCLK             : in    std_logic;
        HRESETn          : in    std_logic;
        HADDR            : in    std_logic_vector(11 downto 2);
        HTRANS           : in    std_logic_vector(1 downto 0);
        HWRITE           : in    std_logic;
        HSIZE            : in    std_logic_vector(2 downto 0);
        HREADYIN         : in    std_logic;
        MPMCTrSR         : in    std_logic_vector(8 downto 0);
        HWDATA           : in    std_logic_vector(31 downto 0);
        HSELMPMCTR       : in    std_logic;
        HSELMPMCREG      : in    std_logic;
        Fifo1Out         : in    std_logic_vector(31 downto 0);
        Fifo2Out         : in    std_logic_vector(31 downto 0);
        MPMCTrCR         : in    std_logic_vector(6 downto 0);
        MPMCTrSNPCR      : in    std_logic_vector(3 downto 0);
        MPMCTrExpRef     : in    std_logic_vector(3 downto 0);
        MPMCTrExBkOff    : in    std_logic_vector(5 downto 0);
        HREADY0CNT       : in    std_logic_vector(7 downto 0);
        HREADY1CNT       : in    std_logic_vector(7 downto 0);
        MPMCTrStCS       : in    std_logic_vector(6 downto 0);
        MPMCTrTES        : in    std_logic_vector(3 downto 0);
        HRESP            : out   std_logic_vector(1 downto 0);
        HRDATA           : out   std_logic_vector(31 downto 0);
        WriteData        : out   std_logic_vector(31 downto 0);
        MPMCTrSRWr       : out   std_logic;
        MPMCTrCRWr       : out   std_logic;
        MPMCTrSNPCRWr    : out   std_logic;
        MPMCTrControlWr  : out   std_logic;
        MPMCTrConfigWr   : out   std_logic;
        MPMCTrDynCntlWr  : out   std_logic;
        MPMCTrDynRfrshWr : out   std_logic;
        MPMCTrStExtWtWr  : out   std_logic;
        MPMCTrDynRC0Wr   : out   std_logic;
        MPMCTrDynRC1Wr   : out   std_logic;
        MPMCTrDynRC2Wr   : out   std_logic;
        MPMCTrDynRC3Wr   : out   std_logic;
        MPMCTrDynCnfg0Wr : out   std_logic;
        MPMCTrDynCnfg1Wr : out   std_logic;
        MPMCTrDynCnfg2Wr : out   std_logic;
        MPMCTrDynCnfg3Wr : out   std_logic;
        MPMCTrStCSWr     : out   std_logic;
        MPMCTrTESWr      : out   std_logic;
        MPMCTrExpRefWr   : out   std_logic;
        MPMCTrExBkOffWr  : out   std_logic;
        HREADY0CNTWr     : out   std_logic;
        HREADY1CNTWr     : out   std_logic;
        HREADYOUT        : out   std_logic;
        Fifo1Rd          : out   std_logic;
        Fifo2Rd          : out   std_logic
       );
end component;

component MpmcTrRegBlk
  port (
        HCLK             : in    std_logic;
        nPOR             : in    std_logic;
        HRESETn          : in    std_logic;
        HREADYIN0        : in    std_logic;
        HREADYIN1        : in    std_logic;
        HREADYIN2        : in    std_logic;
        HREADYIN3        : in    std_logic;
        WriteData        : in    std_logic_vector(31 downto 0);
        MPMCTrSRWr       : in    std_logic;
        MPMCTrCRWr       : in    std_logic;
        MPMCTrSNPCRWr    : in    std_logic;
        MPMCTrControlWr  : in    std_logic;
        MPMCTrConfigWr   : in    std_logic;
        MPMCTrDynCntlWr  : in    std_logic;
        MPMCTrDynRfrshWr : in    std_logic;
        MPMCTrStExtWtWr  : in    std_logic;
        MPMCTrDynRC0Wr   : in    std_logic;
        MPMCTrDynRC1Wr   : in    std_logic;
        MPMCTrDynRC2Wr   : in    std_logic;
        MPMCTrDynRC3Wr   : in    std_logic;
        MPMCTrDynCnfg0Wr : in    std_logic;
        MPMCTrDynCnfg1Wr : in    std_logic;
        MPMCTrDynCnfg2Wr : in    std_logic;
        MPMCTrDynCnfg3Wr : in    std_logic;
        MPMCTrStCSWr     : in    std_logic;
        MPMCTrTESWr0     : in    std_logic;
        MPMCTrTESWr1     : in    std_logic;
        MPMCTrTESWr2     : in    std_logic;
        MPMCTrTESWr3     : in    std_logic;
        MPMCTrExpRefWr   : in    std_logic;
        MPMCTrExBkOffWr  : in    std_logic;
        HREADY0CNTWr     : in    std_logic;
        HREADY1CNTWr     : in    std_logic;
        MPMCTrCR         : out   std_logic_vector(6 downto 0);
        MPMCTrSNPCR      : out   std_logic_vector(3 downto 0);
        MPMCTrExpRef     : out   std_logic_vector(3 downto 0);
        MPMCTrExBkOff    : out   std_logic_vector(5 downto 0);
        HREADY0CNT       : out   std_logic_vector(7 downto 0);
        HREADY1CNT       : out   std_logic_vector(7 downto 0);
        MPMCTrControl    : out   std_logic_vector(3 downto 0);
        MPMCTrConfig     : out   std_logic_vector(9 downto 0);
        MPMCTrDynCntl    : out   std_logic_vector(15 downto 0);
        MPMCTrDynRfrsh   : out   std_logic_vector(10 downto 0);
        MPMCTrStExtWt    : out   std_logic_vector(9 downto 0);
        MPMCTrDynRC0     : out   std_logic_vector(9 downto 0);
        MPMCTrDynRC1     : out   std_logic_vector(9 downto 0);
        MPMCTrDynRC2     : out   std_logic_vector(9 downto 0);
        MPMCTrDynRC3     : out   std_logic_vector(9 downto 0);
        MPMCTrDynCnfg0   : out   std_logic_vector(29 downto 0);
        MPMCTrDynCnfg1   : out   std_logic_vector(29 downto 0);
        MPMCTrDynCnfg2   : out   std_logic_vector(29 downto 0);
        MPMCTrDynCnfg3   : out   std_logic_vector(29 downto 0);
        MPMCTrStCS       : out   std_logic_vector(6 downto 0);
        MPMCTrDynMEMT    : out   std_logic_vector(3 downto 0);
        MPMCTrWrPrStat   : out   std_logic_vector(3 downto 0);
        MPMCTrTES        : out   std_logic_vector(3 downto 0);
        DataSR           : out   std_logic_vector(8 downto 0)
       );
end component;

component MpmcTrClkResGen
  generic (
           Tclkl            : time;
           Tclkh            : time;
           Tclks            : time
          );

  port (
        HCLK             : in    std_logic;
        MPMCCLKOUT       : in    std_logic_vector(3 downto 0);
        HRESETn          : in    std_logic;
        MPMCTrCR         : in    std_logic_vector(3 downto 0);
        MPMCTrConfig     : in    std_logic_vector(9 downto 0);
        MPMCSREFACK      : in    std_logic;
        MPMCCLK          : out   std_logic;
        MPMCCLKDELAY     : out   std_logic;
        nPOR             : out   std_logic;
        nReset           : out   std_logic;
        MPMCSREFREQ      : out   std_logic
       );
end component;

component MpmcTrProChkr
  generic (
           Tclk : time
          );
  port (
        HCLK             : in    std_logic;
        HRESETn          : in    std_logic;
        MPMCCLKOUT       : in    std_logic_vector(3 downto 0);
        MPMCCLK          : in    std_logic;
        nPOR             : in    std_logic;
        MPMCTrExpRef     : in    std_logic_vector(3 downto 0);
        MPMCTrExBkOff    : in    std_logic_vector(5 downto 0);
        MPMCTrSRWr       : in    std_logic;
        ProtChkMask      : in    std_logic;
        HREADY0ChkEn     : in    std_logic;
        HREADY1ChkEn     : in    std_logic;
        MPMCCKEOUT       : in    std_logic_vector(3 downto 0);
        nMPMCRASOUT      : in    std_logic;
        nMPMCCASOUT      : in    std_logic;
        MPMCTrDynMEMT    : in    std_logic_vector(3 downto 0);
        MPMCTrWrPrStat   : in    std_logic_vector(3 downto 0);
        nMPMCDYCSOUT     : in    std_logic_vector(3 downto 0);
        nMPMCSTCSOUT     : in    std_logic_vector(3 downto 0);
        MPMCACTLOWCS     : in    std_logic_vector(3 downto 0);
        nMPMCWEOUT       : in    std_logic;
        nMPMCDATAEN      : in    std_logic_vector(3 downto 0);
        nMPMCOEOUT       : in    std_logic;
        MPMCDQMOUT       : in    std_logic_vector(3 downto 0);
        nMPMCRPOUT       : in    std_logic;
        MPMCRPVHHOUT     : in    std_logic;
        MPMCSREFACK      : in    std_logic;
        MPMCADDROUT      : in    std_logic_vector(27 downto 0);
        MPMCDATAOUT      : in    std_logic_vector(31 downto 0);
        MPMCTrDynRfrshWr : in    std_logic;
        MPMCTrDynRfrsh   : in    std_logic_vector(10 downto 0);
        MPMCTrControl    : in    std_logic_vector(3 downto 0);
        MPMCTrDynCntl    : in    std_logic_vector(15 downto 0);
        DataSR           : in    std_logic_vector(8 downto 0);
        MPMCEBIREQ       : in    std_logic;
        HREADYOutMpmc0   : in    std_logic;
        HREADYOutMpmc1   : in    std_logic;
        HREADY0CNT       : in    std_logic_vector(7 downto 0);
        HREADY1CNT       : in    std_logic_vector(7 downto 0);
        MPMCEBIGNT       : out   std_logic;
        MPMCEBIBACKOFF   : out   std_logic;
        MPMCTrSR         : out   std_logic_vector(8 downto 0)
       );
end component;

component MpmcTrSnp
  port (
        HCLK             : in    std_logic;
        MPMCCLK          : in    std_logic;
        nReset           : in    std_logic;
        FifoIn           : in    std_logic_vector(31 downto 0);
        LatencyChkEn     : in    std_logic;
        MPMCDATAOUT      : in    std_logic_vector(31 downto 0);
        MPMCDATAIN       : in    std_logic_vector(31 downto 0);
        nMPMCDYCSOUT     : in    std_logic_vector(3 downto 0);
        nMPMCSTCSOUT     : in    std_logic_vector(3 downto 0);
        MPMCTrSNPCR      : in    std_logic_vector(3 downto 0);
        Fifo1Rd          : in    std_logic;
        Fifo2Rd          : in    std_logic;
        MPMCTrDynRC0     : in    std_logic_vector(9 downto 0);
        MPMCTrDynRC1     : in    std_logic_vector(9 downto 0);
        MPMCTrDynRC2     : in    std_logic_vector(9 downto 0);
        MPMCTrDynRC3     : in    std_logic_vector(9 downto 0);
        Fifo1Out         : out   std_logic_vector(31 downto 0);
        Fifo2Out         : out   std_logic_vector(31 downto 0)
       );
end component;

-- -----------------------------------------------------------------------------
-- Constant declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Signal declarations
-- -----------------------------------------------------------------------------
signal LatencyChkEn     : std_logic;
signal MPMCTrSR         : std_logic_vector(8 downto 0);
signal MPMCTrCR         : std_logic_vector(6 downto 0);
signal MPMCTrSNPCR      : std_logic_vector(3 downto 0);
signal MPMCTrExpRef     : std_logic_vector(3 downto 0);
signal MPMCTrExBkOff    : std_logic_vector(5 downto 0);
signal MPMCTrControl    : std_logic_vector(3 downto 0);
signal MPMCTrConfig     : std_logic_vector(9 downto 0);
signal MPMCTrDynCntl    : std_logic_vector(15 downto 0);
signal MPMCTrDynRfrsh   : std_logic_vector(10 downto 0);
signal MPMCTrDynRC0     : std_logic_vector(9 downto 0);
signal MPMCTrDynRC1     : std_logic_vector(9 downto 0);
signal MPMCTrDynRC2     : std_logic_vector(9 downto 0);
signal MPMCTrDynRC3     : std_logic_vector(9 downto 0);
signal MPMCTrDynCnfg0   : std_logic_vector(29 downto 0);
signal MPMCTrDynCnfg1   : std_logic_vector(29 downto 0);
signal MPMCTrDynCnfg2   : std_logic_vector(29 downto 0);
signal MPMCTrDynCnfg3   : std_logic_vector(29 downto 0);
signal MPMCTrStCS       : std_logic_vector(6 downto 0);
signal MPMCTrDynMEMT    : std_logic_vector(3 downto 0);
signal MPMCTrWrPrStat   : std_logic_vector(3 downto 0);
signal MPMCTrTES        : std_logic_vector(3 downto 0);
signal DataSR           : std_logic_vector(8 downto 0);
signal nReset           : std_logic;
signal FifoIn           : std_logic_vector(31 downto 0);
signal Fifo1Rd          : std_logic;
signal Fifo2Rd          : std_logic;
signal Fifo1Rd0         : std_logic;
signal Fifo2Rd0         : std_logic;
signal Fifo1Rd1         : std_logic;
signal Fifo2Rd1         : std_logic;
signal Fifo1Rd2         : std_logic;
signal Fifo2Rd2         : std_logic;
signal Fifo1Rd3         : std_logic;
signal Fifo2Rd3         : std_logic;
signal Fifo1Out         : std_logic_vector(31 downto 0);
signal Fifo2Out         : std_logic_vector(31 downto 0);
signal WriteData        : std_logic_vector(31 downto 0);
signal WriteData0       : std_logic_vector(31 downto 0);
signal WriteData1       : std_logic_vector(31 downto 0);
signal WriteData2       : std_logic_vector(31 downto 0);
signal WriteData3       : std_logic_vector(31 downto 0);
signal MPMCTrCRWr3      : std_logic;
signal MPMCTrSRWr3      : std_logic;
signal MPMCTrSNPCRWr3   : std_logic;
signal MPMCTrControlWr3 : std_logic;
signal MPMCTrConfigWr3  : std_logic;
signal MPMCTrDynCntlWr3 : std_logic;
signal MPMCTrDyRfrshWr3 : std_logic;
signal MPMCTrStExtWtWr3 : std_logic;
signal MPMCTrDynRC0Wr3  : std_logic;
signal MPMCTrDynRC1Wr3  : std_logic;
signal MPMCTrDynRC2Wr3  : std_logic;
signal MPMCTrDynRC3Wr3  : std_logic;
signal MPMCTrDyCnfg0Wr3 : std_logic;
signal MPMCTrDyCnfg1Wr3 : std_logic;
signal MPMCTrDyCnfg2Wr3 : std_logic;
signal MPMCTrDyCnfg3Wr3 : std_logic;
signal MPMCTrStCSWr3    : std_logic;
signal MPMCTrTESWr      : std_logic;
signal MPMCTrTESWr0     : std_logic;
signal MPMCTrTESWr1     : std_logic;
signal MPMCTrTESWr2     : std_logic;
signal MPMCTrTESWr3     : std_logic;
signal MPMCTrExpRefWr3  : std_logic;
signal MPMCTrExBkOffWr3 : std_logic;
signal HREADY0CNTWr     : std_logic;
signal HREADY1CNTWr     : std_logic;
signal iMPMCCLK         : std_logic;
signal inPOR            : std_logic;
signal HREADY0CNT       : std_logic_vector(7 downto 0);
signal HREADY1CNT       : std_logic_vector(7 downto 0);

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
-- Instantiation of MpmcTrAhbif (AHB0)
-- -----------------------------------------------------------------------------
u0MpmcTrAhbif : MpmcTrAhbif
  port map (
            HCLK             => HCLK,
            HRESETn          => HRESETn,
            HADDR            => HADDR0,
            HTRANS           => HTRANS0,
            HWRITE           => HWRITE0,
            HSIZE            => HSIZE0,
            HREADYIN         => HREADYIN0,
            MPMCTrSR         => MPMCTrSR,
            HWDATA           => HWDATA0,
            HSELMPMCTR       => HSELMPMCTR0,
            HSELMPMCREG      => HSELMPMCREG,
            Fifo1Out         => Fifo1Out,
            Fifo2Out         => Fifo2Out,
            MPMCTrCR         => MPMCTrCR,
            MPMCTrSNPCR      => MPMCTrSNPCR,
            MPMCTrExpRef     => MPMCTrExpRef,
            MPMCTrExBkOff    => MPMCTrExBkOff,
            HREADY0CNT       => HREADY0CNT,
            HREADY1CNT       => HREADY1CNT,
            MPMCTrStCS       => MPMCTrStCS,
            MPMCTrTES        => MPMCTrTES,
            HRESP            => HRESP0,
            HRDATA           => HRDATA0,
            HREADYOUT        => HREADYOUT0,
            WriteData        => WriteData0,
            MPMCTrSRWr       => open,
            MPMCTrCRWr       => open,
            MPMCTrSNPCRWr    => open,
            MPMCTrControlWr  => open,
            MPMCTrConfigWr   => open,
            MPMCTrDynCntlWr  => open,
            MPMCTrDynRfrshWr => open,
            MPMCTrStExtWtWr  => open,
            MPMCTrDynRC0Wr   => open,
            MPMCTrDynRC1Wr   => open,
            MPMCTrDynRC2Wr   => open,
            MPMCTrDynRC3Wr   => open,
            MPMCTrDynCnfg0Wr => open,
            MPMCTrDynCnfg1Wr => open,
            MPMCTrDynCnfg2Wr => open,
            MPMCTrDynCnfg3Wr => open,
            MPMCTrStCSWr     => open,
            MPMCTrTESWr      => MPMCTrTESWr0,
            MPMCTrExpRefWr   => open,
            MPMCTrExBkOffWr  => open,
            HREADY0CNTWr     => open,
            HREADY1CNTWr     => open,
            Fifo1Rd          => Fifo1Rd0,
            Fifo2Rd          => Fifo2Rd0
           );

-- -----------------------------------------------------------------------------
-- Instantiation of MpmcTrAhbif (AHB1)
-- -----------------------------------------------------------------------------
u1MpmcTrAhbif : MpmcTrAhbif
  port map (
            HCLK             => HCLK,
            HRESETn          => HRESETn,
            HADDR            => HADDR1,
            HTRANS           => HTRANS1,
            HWRITE           => HWRITE1,
            HSIZE            => HSIZE1,
            HREADYIN         => HREADYIN1,
            MPMCTrSR         => MPMCTrSR,
            HWDATA           => HWDATA1,
            HSELMPMCTR       => HSELMPMCTR1,
            HSELMPMCREG      => HSELMPMCREG,
            Fifo1Out         => Fifo1Out,
            Fifo2Out         => Fifo2Out,
            MPMCTrCR         => MPMCTrCR,
            MPMCTrSNPCR      => MPMCTrSNPCR,
            MPMCTrExpRef     => MPMCTrExpRef,
            MPMCTrExBkOff    => MPMCTrExBkOff,
            MPMCTrStCS       => MPMCTrStCS,
            MPMCTrTES        => MPMCTrTES,
            HREADY0CNT       => HREADY0CNT,
            HREADY1CNT       => HREADY1CNT,
            HREADYOUT        => HREADYOUT1,
            HRESP            => HRESP1,
            HRDATA           => HRDATA1,
            WriteData        => WriteData1,
            MPMCTrSRWr       => open,
            MPMCTrCRWr       => open,
            MPMCTrSNPCRWr    => open,
            MPMCTrControlWr  => open,
            MPMCTrConfigWr   => open,
            MPMCTrDynCntlWr  => open,
            MPMCTrDynRfrshWr => open,
            MPMCTrStExtWtWr  => open,
            MPMCTrDynRC0Wr   => open,
            MPMCTrDynRC1Wr   => open,
            MPMCTrDynRC2Wr   => open,
            MPMCTrDynRC3Wr   => open,
            MPMCTrDynCnfg0Wr => open,
            MPMCTrDynCnfg1Wr => open,
            MPMCTrDynCnfg2Wr => open,
            MPMCTrDynCnfg3Wr => open,
            MPMCTrStCSWr     => open,
            MPMCTrTESWr      => MPMCTrTESWr1,
            MPMCTrExpRefWr   => open,
            MPMCTrExBkOffWr  => open,
            HREADY0CNTWr     => open,
            HREADY1CNTWr     => open,
            Fifo1Rd          => Fifo1Rd1,
            Fifo2Rd          => Fifo2Rd1
           );

-- -----------------------------------------------------------------------------
-- Instantiation of MpmcTrAhbif (AHB2)
-- -----------------------------------------------------------------------------
u2MpmcTrAhbif : MpmcTrAhbif
  port map (
            HCLK             => HCLK,
            HRESETn          => HRESETn,
            HADDR            => HADDR2,
            HTRANS           => HTRANS2,
            HWRITE           => HWRITE2,
            HSIZE            => HSIZE2,
            HREADYIN         => HREADYIN2,
            MPMCTrSR         => MPMCTrSR,
            HWDATA           => HWDATA2,
            HSELMPMCTR       => HSELMPMCTR2,
            HSELMPMCREG      => HSELMPMCREG,
            Fifo1Out         => Fifo1Out,
            Fifo2Out         => Fifo2Out,
            MPMCTrCR         => MPMCTrCR,
            MPMCTrSNPCR      => MPMCTrSNPCR,
            MPMCTrExpRef     => MPMCTrExpRef,
            MPMCTrExBkOff    => MPMCTrExBkOff,
            MPMCTrStCS       => MPMCTrStCS,
            MPMCTrTES        => MPMCTrTES,
            HREADY0CNT       => HREADY0CNT,
            HREADY1CNT       => HREADY1CNT,
            HREADYOUT        => HREADYOUT2,
            HRESP            => HRESP2,
            HRDATA           => HRDATA2,
            WriteData        => WriteData2,
            MPMCTrSRWr       => open,
            MPMCTrCRWr       => open,
            MPMCTrSNPCRWr    => open,
            MPMCTrControlWr  => open,
            MPMCTrConfigWr   => open,
            MPMCTrDynCntlWr  => open,
            MPMCTrDynRfrshWr => open,
            MPMCTrStExtWtWr  => open,
            MPMCTrDynRC0Wr   => open,
            MPMCTrDynRC1Wr   => open,
            MPMCTrDynRC2Wr   => open,
            MPMCTrDynRC3Wr   => open,
            MPMCTrDynCnfg0Wr => open,
            MPMCTrDynCnfg1Wr => open,
            MPMCTrDynCnfg2Wr => open,
            MPMCTrDynCnfg3Wr => open,
            MPMCTrStCSWr     => open,
            MPMCTrTESWr      => MPMCTrTESWr2,
            MPMCTrExpRefWr   => open,
            MPMCTrExBkOffWr  => open,
            HREADY0CNTWr     => open,
            HREADY1CNTWr     => open,
            Fifo1Rd          => Fifo1Rd2,
            Fifo2Rd          => Fifo2Rd2
           );

-- -----------------------------------------------------------------------------
-- Instantiation of MpmcTrAhbif (AHB3)
-- -----------------------------------------------------------------------------
u3MpmcTrAhbif : MpmcTrAhbif
  port map (
            HCLK             => HCLK,
            HRESETn          => HRESETn,
            HADDR            => HADDR3,
            HTRANS           => HTRANS3,
            HWRITE           => HWRITE3,
            HSIZE            => HSIZE3,
            HREADYIN         => HREADYIN3,
            MPMCTrSR         => MPMCTrSR,
            HWDATA           => HWDATA3,
            HSELMPMCTR       => HSELMPMCTR3,
            HSELMPMCREG      => HSELMPMCREG,
            Fifo1Out         => Fifo1Out,
            Fifo2Out         => Fifo2Out,
            MPMCTrCR         => MPMCTrCR,
            MPMCTrSNPCR      => MPMCTrSNPCR,
            MPMCTrExpRef     => MPMCTrExpRef,
            MPMCTrExBkOff    => MPMCTrExBkOff,
            MPMCTrStCS       => MPMCTrStCS,
            MPMCTrTES        => MPMCTrTES,
            HREADY0CNT       => HREADY0CNT,
            HREADY1CNT       => HREADY1CNT,
            HREADYOUT        => HREADYOUT3,
            HRESP            => HRESP3,
            HRDATA           => HRDATA3,
            WriteData        => WriteData3,
            MPMCTrSRWr       => MPMCTrSRWr3,
            MPMCTrCRWr       => MPMCTrCRWr3,
            MPMCTrSNPCRWr    => MPMCTrSNPCRWr3,
            MPMCTrControlWr  => MPMCTrControlWr3,
            MPMCTrConfigWr   => MPMCTrConfigWr3,
            MPMCTrDynCntlWr  => MPMCTrDynCntlWr3,
            MPMCTrDynRfrshWr => MPMCTrDyRfrshWr3,
            MPMCTrStExtWtWr  => MPMCTrStExtWtWr3,
            MPMCTrDynRC0Wr   => MPMCTrDynRC0Wr3,
            MPMCTrDynRC1Wr   => MPMCTrDynRC1Wr3,
            MPMCTrDynRC2Wr   => MPMCTrDynRC2Wr3,
            MPMCTrDynRC3Wr   => MPMCTrDynRC3Wr3,
            MPMCTrDynCnfg0Wr => MPMCTrDyCnfg0Wr3,
            MPMCTrDynCnfg1Wr => MPMCTrDyCnfg1Wr3,
            MPMCTrDynCnfg2Wr => MPMCTrDyCnfg2Wr3,
            MPMCTrDynCnfg3Wr => MPMCTrDyCnfg3Wr3,
            MPMCTrStCSWr     => MPMCTrStCSWr3,
            MPMCTrTESWr      => MPMCTrTESWr3,
            MPMCTrExpRefWr   => MPMCTrExpRefWr3,
            MPMCTrExBkOffWr  => MPMCTrExBkOffWr3,
            HREADY0CNTWr     => HREADY0CNTWr,
            HREADY1CNTWr     => HREADY1CNTWr,
            Fifo1Rd          => Fifo1Rd3,
            Fifo2Rd          => Fifo2Rd3
           );

-- -----------------------------------------------------------------------------
-- Instantiation of MpmcTrRegBlk
-- -----------------------------------------------------------------------------
uMpmcTrRegBlk : MpmcTrRegBlk
  port map (
            HCLK             => HCLK,
            nPOR             => inPOR,
            HRESETn          => HRESETn,
            HREADYIN0        => HREADYIN0,
            HREADYIN1        => HREADYIN1,
            HREADYIN2        => HREADYIN2,
            HREADYIN3        => HREADYIN3,
            WriteData        => WriteData,
            MPMCTrSRWr       => MPMCTrSRWr3,
            MPMCTrCRWr       => MPMCTrCRWr3,
            MPMCTrSNPCRWr    => MPMCTrSNPCRWr3,
            MPMCTrControlWr  => MPMCTrControlWr3,
            MPMCTrConfigWr   => MPMCTrConfigWr3,
            MPMCTrDynCntlWr  => MPMCTrDynCntlWr3,
            MPMCTrDynRfrshWr => MPMCTrDyRfrshWr3,
            MPMCTrStExtWtWr  => MPMCTrStExtWtWr3,
            MPMCTrDynRC0Wr   => MPMCTrDynRC0Wr3,
            MPMCTrDynRC1Wr   => MPMCTrDynRC1Wr3,
            MPMCTrDynRC2Wr   => MPMCTrDynRC2Wr3,
            MPMCTrDynRC3Wr   => MPMCTrDynRC3Wr3,
            MPMCTrDynCnfg0Wr => MPMCTrDyCnfg0Wr3,
            MPMCTrDynCnfg1Wr => MPMCTrDyCnfg1Wr3,
            MPMCTrDynCnfg2Wr => MPMCTrDyCnfg2Wr3,
            MPMCTrDynCnfg3Wr => MPMCTrDyCnfg3Wr3,
            MPMCTrStCSWr     => MPMCTrStCSWr3,
            MPMCTrTESWr0     => MPMCTrTESWr0,
            MPMCTrTESWr1     => MPMCTrTESWr1,
            MPMCTrTESWr2     => MPMCTrTESWr2,
            MPMCTrTESWr3     => MPMCTrTESWr3,
            MPMCTrExpRefWr   => MPMCTrExpRefWr3,
            MPMCTrExBkOffWr  => MPMCTrExBkOffWr3,
            HREADY0CNTWr     => HREADY0CNTWr,
            HREADY1CNTWr     => HREADY1CNTWr,
            HREADY0CNT       => HREADY0CNT,
            HREADY1CNT       => HREADY1CNT,
            MPMCTrCR         => MPMCTrCR,
            MPMCTrSNPCR      => MPMCTrSNPCR,
            MPMCTrExpRef     => MPMCTrExpRef,
            MPMCTrExBkOff    => MPMCTrExBkOff,
            MPMCTrControl    => MPMCTrControl,
            MPMCTrConfig     => MPMCTrConfig,
            MPMCTrDynCntl    => MPMCTrDynCntl,
            MPMCTrDynRfrsh   => MPMCTrDynRfrsh,
            MPMCTrStExtWt    => MPMCTrStExtWt,
            MPMCTrDynRC0     => MPMCTrDynRC0,
            MPMCTrDynRC1     => MPMCTrDynRC1,
            MPMCTrDynRC2     => MPMCTrDynRC2,
            MPMCTrDynRC3     => MPMCTrDynRC3,
            MPMCTrDynCnfg0   => MPMCTrDynCnfg0,
            MPMCTrDynCnfg1   => MPMCTrDynCnfg1,
            MPMCTrDynCnfg2   => MPMCTrDynCnfg2,
            MPMCTrDynCnfg3   => MPMCTrDynCnfg3,
            MPMCTrStCS       => MPMCTrStCS,
            MPMCTrDynMEMT    => MPMCTrDynMEMT,
            MPMCTrWrPrStat   => MPMCTrWrPrStat,
            MPMCTrTES        => MPMCTrTES,
            DataSR           => DataSR
           );

-- Internal OR bus
WriteData        <= WriteData0 or WriteData1 or WriteData2 or WriteData3;
Fifo1Rd          <= Fifo1Rd0 or Fifo1Rd1 or Fifo1Rd2 or Fifo1Rd3;
Fifo2Rd          <= Fifo2Rd0 or Fifo2Rd1 or Fifo2Rd2 or Fifo2Rd3;

-- -----------------------------------------------------------------------------
-- Instantiation of MpmcTrClkResGen
-- -----------------------------------------------------------------------------
uMpmcTrClkResGen : MpmcTrClkResGen
  generic map (
               Tclkl            => Tclkl,
               Tclkh            => Tclkh,
               Tclks            => Tclks
              )
  port map (
            HCLK             => HCLK,
            MPMCCLKOUT       => MPMCCLKOUT,
            HRESETn          => HRESETn,
            MPMCTrCR         => MPMCTrCR(3 downto 0),
            MPMCTrConfig     => MPMCTrConfig,
            MPMCSREFACK      => MPMCSREFACK,
            MPMCCLK          => iMPMCCLK,
            MPMCCLKDELAY     => MPMCCLKDELAY,
            nPOR             => inPOR,
            nReset           => nReset,
            MPMCSREFREQ      => MPMCSREFREQ
           );

-- -----------------------------------------------------------------------------
-- Instantiation of MpmcTrProChkr
-- -----------------------------------------------------------------------------
uMpmcTrProChkr : MpmcTrProChkr
  generic map (
               Tclk => Tclkh + Tclkl
              )
  port map (
            HCLK             => HCLK,
            HRESETn          => HRESETn,
            MPMCCLKOUT       => MPMCCLKOUT,
            MPMCCLK          => iMPMCCLK,
            nPOR             => inPOR,
            MPMCTrExpRef     => MPMCTrExpRef,
            MPMCTrExBkOff    => MPMCTrExBkOff,
            MPMCTrSRWr       => MPMCTrSRWr3,
            ProtChkMask      => MPMCTrCR(4),
            HREADY0ChkEn     => MPMCTrCR(5),
            HREADY1ChkEn     => MPMCTrCR(6),
            MPMCCKEOUT       => MPMCCKEOUT,
            nMPMCRASOUT      => nMPMCRASOUT,
            nMPMCCASOUT      => nMPMCCASOUT,
            MPMCTrDynMEMT    => MPMCTrDynMEMT,
            MPMCTrWrPrStat   => MPMCTrWrPrStat,
            nMPMCDYCSOUT     => nMPMCDYCSOUT,
            nMPMCSTCSOUT     => nMPMCSTCSOUT,
            MPMCACTLOWCS     => MPMCACTLOWCS,
            nMPMCWEOUT       => nMPMCWEOUT,
            nMPMCDATAEN      => nMPMCDATAEN,
            nMPMCOEOUT       => nMPMCOEOUT,
            MPMCDQMOUT       => MPMCDQMOUT,
            nMPMCRPOUT       => nMPMCRPOUT,
            MPMCRPVHHOUT     => MPMCRPVHHOUT,
            MPMCSREFACK      => MPMCSREFACK,
            MPMCADDROUT      => MPMCADDROUT,
            MPMCDATAOUT      => MPMCDATAOUT,
            MPMCTrDynRfrshWr => MPMCTrDyRfrshWr3,
            MPMCTrDynRfrsh   => MPMCTrDynRfrsh,
            MPMCTrControl    => MPMCTrControl,
            MPMCTrDynCntl    => MPMCTrDynCntl,
            HREADYOutMpmc0   => HREADYOutMpmc0, 
            HREADYOutMpmc1   => HREADYOutMpmc1, 
            HREADY0CNT       => HREADY0CNT,
            HREADY1CNT       => HREADY1CNT,
            DataSR           => DataSR,
            MPMCEBIREQ       => MPMCEBIREQ,
            MPMCEBIGNT       => MPMCEBIGNT,
            MPMCEBIBACKOFF   => MPMCEBIBACKOFF, 
            MPMCTrSR         => MPMCTrSR
           );
-- -----------------------------------------------------------------------------
-- Instantiation of MpmcTrSnp
-- -----------------------------------------------------------------------------
uMpmcTrSnp : MpmcTrSnp
  port map (
            HCLK             => HCLK,
            MPMCCLK          => iMPMCCLK,
            nReset           => nReset,
            FifoIn           => FifoIn,
            LatencyChkEn     => LatencyChkEn,
            MPMCDATAOUT      => MPMCDATAOUT,
            MPMCDATAIN       => MPMCDATAIN,
            nMPMCDYCSOUT     => nMPMCDYCSOUT,
            nMPMCSTCSOUT     => nMPMCSTCSOUT,
            MPMCTrSNPCR      => MPMCTrSNPCR,
            Fifo1Rd          => Fifo1Rd,
            Fifo2Rd          => Fifo2Rd,
            MPMCTrDynRC0     => MPMCTrDynRC0,
            MPMCTrDynRC1     => MPMCTrDynRC1,
            MPMCTrDynRC2     => MPMCTrDynRC2,
            MPMCTrDynRC3     => MPMCTrDynRC3,
            Fifo1Out         => Fifo1Out,
            Fifo2Out         => Fifo2Out
          );

LatencyChkEn     <= MPMCTrCR(2);

-- -----------------------------------------------------------------------------
-- Input to the fifo
-- -----------------------------------------------------------------------------
FifoIn           <= '0' & nMPMCRASOUT & nMPMCCASOUT & nMPMCWEOUT &
                     MPMCADDROUT;

-- -----------------------------------------------------------------------------
-- Connecting local copies to the output port
-- -----------------------------------------------------------------------------
MPMCBIGENDIAN    <= MPMCTrCR(3);
MPMCCLK          <= iMPMCCLK;
nPOR             <= inPOR;
MPMCSTCS0POL     <= MPMCTrStCS(0);
MPMCSTCS1POL     <= MPMCTrStCS(1);
MPMCSTCS2POL     <= MPMCTrStCS(2);
MPMCSTCS3POL     <= MPMCTrStCS(3);
MPMCSTCS1MW      <= MPMCTrStCS(5 downto 4);
MPMCSTCS1PB      <= MPMCTrStCS(6);
end structural;

-- --================================== End ==================================--
