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
-- File Name              : MpmcTrRegBlk.vhd.rca
-- File Revision          : 1.6
--
-- Release Information    : PrimeCell(TM)-PL172-r2p3-00rel0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           This block implements the AHB read/write registers in the
--           MPMC Trickbox
--
-- --=========================================================================--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

-- -----------------------------------------------------------------------------

entity MpmcTrRegBlk is
  port (
-- Inputs
        -- AHB bus signals
        HCLK             : in    std_logic; -- AHB Bus Clock
        nPOR             : in    std_logic; -- Power on reset
        HRESETn          : in    std_logic; -- Bus Reset
        HREADYIN0        : in    std_logic; -- HREADYIN for AHB0
        HREADYIN1        : in    std_logic; -- HREADYIN for AHB1
        HREADYIN2        : in    std_logic; -- HREADYIN for AHB2
        HREADYIN3        : in    std_logic; -- HREADYIN for AHB3
        WriteData        : in    std_logic_vector(31 downto 0);
                                            -- Write Data bus to the Register
                                            -- Block
        MPMCTrSRWr       : in    std_logic; -- MPMCTrSR register write enable
        MPMCTrCRWr       : in    std_logic; -- MPMCTrCR Register Write Enable
        MPMCTrSNPCRWr    : in    std_logic; -- MPMCTrSNP Control Register
                                            -- Write Enable
        MPMCTrControlWr  : in    std_logic; -- MPMCTrControl Register Write
                                            -- Enable
        MPMCTrConfigWr   : in    std_logic; -- MPMCTrConfig Register Write
                                            -- Enable
        MPMCTrDynCntlWr  : in    std_logic; -- MPMCTrDynCntl Register Write
                                            -- Enable
        MPMCTrDynRfrshWr : in    std_logic; -- MPMCTrDynRfrsh Register Write
                                            -- Enable
        MPMCTrStExtWtWr  : in    std_logic; -- MPMCTrExtWait Register Write
                                            -- Enable
        MPMCTrDynRC0Wr   : in    std_logic; -- MPMCTrDynRC0 Register Write
                                            -- Enable
        MPMCTrDynRC1Wr   : in    std_logic; -- MPMCTrDynRC1 Register Write
                                            -- Enable
        MPMCTrDynRC2Wr   : in    std_logic; -- MPMCTrDynRC2 Register Write
                                            -- Enable
        MPMCTrDynRC3Wr   : in    std_logic; -- MPMCTrDynRC3 Register Write
                                            -- Enable
        MPMCTrDynCnfg0Wr : in    std_logic; -- MPMCTrDynCnfg0 Register Write
                                            -- Enable
        MPMCTrDynCnfg1Wr : in    std_logic; -- MPMCTrDynCnfg1 Register Write
                                            -- Enable
        MPMCTrDynCnfg2Wr : in    std_logic; -- MPMCTrDynCnfg2 Register Write
                                            -- Enable
        MPMCTrDynCnfg3Wr : in    std_logic; -- MPMCTrDynCnfg3 Register Write
                                            -- Enable
        MPMCTrStCSWr     : in    std_logic; -- MPMCTrStCS Register Write Enable
        MPMCTrTESWr0     : in    std_logic; -- MPMCTrTES Register Write Enable
                                            -- (AHB0)
        MPMCTrTESWr1     : in    std_logic; -- MPMCTrTES Register Write Enable
                                            -- (AHB1)
        MPMCTrTESWr2     : in    std_logic; -- MPMCTrTES Register Write Enable
                                            -- (AHB2)
        MPMCTrTESWr3     : in    std_logic; -- MPMCTrTES Register Write Enable
                                            -- (AHB3)
        MPMCTrExpRefWr   : in    std_logic; -- MPMCTrExpRef Register Write
                                            -- Enable
        MPMCTrExBkOffWr  : in    std_logic; -- MPMCTrExBkOff Register Write
                                            -- Enable
        HREADY0CNTWr     : in    std_logic; -- HREADY0CNT Register Write
                                            -- Enable
        HREADY1CNTWr     : in    std_logic; -- HREADY1CNT Register Write
                                            -- Enable

-- Outputs
        -- MPMC related signals
        MPMCTrCR         : out   std_logic_vector(6 downto 0);
                                            -- MPMCTrCR Register
        MPMCTrSNPCR      : out   std_logic_vector(3 downto 0);
                                            -- MPMCTrSNPCR Register
        MPMCTrExpRef     : out   std_logic_vector(3 downto 0);
                                            -- MPMCTrExpRef Register
        MPMCTrExBkOff    : out   std_logic_vector(5 downto 0);
                                            -- MPMCTrExBkOff Register
        MPMCTrControl    : out   std_logic_vector(3 downto 0);
                                            -- MPMCTrControl Register
        MPMCTrConfig     : out   std_logic_vector(9 downto 0);
                                            -- MPMCTrConfig Register
        MPMCTrDynCntl    : out   std_logic_vector(15 downto 0);
                                            -- MPMCTrDynCntl Register
        MPMCTrDynRfrsh   : out   std_logic_vector(10 downto 0);
                                            -- MPMCTrDynRfrsh Register
        MPMCTrStExtWt    : out   std_logic_vector(9 downto 0);
                                            -- MPMCTrExtWait Register
        MPMCTrDynRC0     : out   std_logic_vector(9 downto 0);
                                            -- MPMCTrDynRC0 Register
        MPMCTrDynRC1     : out   std_logic_vector(9 downto 0);
                                            -- MPMCTrDynRC1 Register
        MPMCTrDynRC2     : out   std_logic_vector(9 downto 0);
                                            -- MPMCTrDynRC2 Register
        MPMCTrDynRC3     : out   std_logic_vector(9 downto 0);
                                            -- MPMCTrDynRC3 Register
        MPMCTrDynCnfg0   : out   std_logic_vector(29 downto 0);
                                            -- MPMCTrDynCnfg0 Register
        MPMCTrDynCnfg1   : out   std_logic_vector(29 downto 0);
                                            -- MPMCTrDynCnfg1 Register
        MPMCTrDynCnfg2   : out   std_logic_vector(29 downto 0);
                                            -- MPMCTrDynCnfg2 Register
        MPMCTrDynCnfg3   : out   std_logic_vector(29 downto 0);
                                            -- MPMCTrDynCnfg3 Register
        MPMCTrStCS       : out   std_logic_vector(6 downto 0);
                                            -- MPMCTrStCS Register
        MPMCTrDynMEMT    : out   std_logic_vector(3 downto 0);
                                            -- MPMCTrDynMEMT Register
        MPMCTrWrPrStat   : out   std_logic_vector(3 downto 0);
                                            -- Indicates the status of write
                                            -- protect bits of memory
        MPMCTrTES        : out   std_logic_vector(3 downto 0);
                                            -- MPMCTrTES Register
        DataSR           : out   std_logic_vector(8 downto 0);
                                            -- Data for MPMCTrSR register
        HREADY0CNT       : out   std_logic_vector(7 downto 0);
                                            -- HREADY0CNT Register to check
                                            -- the latency of Port0
        HREADY1CNT       : out   std_logic_vector(7 downto 0)
                                            -- HREADY1CNT Register to check
                                            -- the latency of Port1
       );
end MpmcTrRegBlk;

-- -----------------------------------------------------------------------------
--
--                                MpmcTrRegBlk
--                                ============
--
-- -----------------------------------------------------------------------------
--
-- Overview
-- ========
-- MPMC Tricbox is an AHB slave. This block performs the following operations:
--   - Implements MPMC Trickbox registers
--   - Drives non-AMBA, non-memory related signals into the MPMC
--
-- -----------------------------------------------------------------------------

-- --============================ ARCHITECTURE ===============================--

architecture behavioural of MpmcTrRegBlk is

-- -----------------------------------------------------------------------------
-- Component declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Constant declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Signal declarations
-- -----------------------------------------------------------------------------
signal iMPMCTrCR        : std_logic_vector(6 downto 0)  := (others => '0');
-- Internal version of MPMCTrCR Register

signal iMPMCTrSNPCR     : std_logic_vector(3 downto 0)  := (others => '0');
-- Internal version of MPMCTrSNPCR Register

signal iMPMCTrExpRef    : std_logic_vector(3 downto 0)  := (others => '0');
-- Internal version of MPMCTrExpRef Register

signal iMPMCTrExBkOff   : std_logic_vector(5 downto 0)  := (others => '0');
-- Internal version of MPMCTrExBkOff Register

signal iMPMCTrControl   : std_logic_vector(3 downto 0) := (others => '0');
-- Internal version of MPMCTrControl Register

signal iMPMCTrConfig    : std_logic_vector(9 downto 0) := (others => '0');
-- Internal version of MPMCTrConfig Register

signal iMPMCTrDynCntl   : std_logic_vector(15 downto 0) := (others => '0');
-- Internal version of MPMCTrDynCntl Register

signal iMPMCTrDynRfrsh  : std_logic_vector(10 downto 0) := (others => '0');
-- Internal version of MPMCTrDynRfrsh Register

signal iMPMCTrStExtWt   : std_logic_vector(9 downto 0) := (others => '0');
-- Internal version of MPMCTrStExtWt Register

signal iMPMCTrDynRC0    : std_logic_vector(9 downto 0) := (others => '0');
-- Internal version of MPMCTrDynRC0 Register

signal iMPMCTrDynRC1    : std_logic_vector(9 downto 0) := (others => '0');
-- Internal version of MPMCTrDynRC1 Register

signal iMPMCTrDynRC2    : std_logic_vector(9 downto 0) := (others => '0');
-- Internal version of MPMCTrDynRC2 Register

signal iMPMCTrDynRC3    : std_logic_vector(9 downto 0) := (others => '0');
-- Internal version of MPMCTrDynRC3 Register

signal iMPMCTrDynCnfg0  : std_logic_vector(29 downto 0) := (others => '0');
-- Internal version of MPMCTrDynCnfg0 Register

signal iMPMCTrDynCnfg1  : std_logic_vector(29 downto 0) := (others => '0');
-- Internal version of MPMCTrDynCnfg1 Register

signal iMPMCTrDynCnfg2  : std_logic_vector(29 downto 0) := (others => '0');
-- Internal version of MPMCTrDynCnfg2 Register

signal iMPMCTrDynCnfg3  : std_logic_vector(29 downto 0) := (others => '0');
-- Internal version of MPMCTrDynCnfg3 Register

signal iMPMCTrStCS      : std_logic_vector(6 downto 0) := "0100000";
-- Internal version of MPMCTrStCS Register

signal iMPMCTrTES       : std_logic_vector(3 downto 0) := (others => '0');
-- Internal version of MPMCTrTES Register

signal NxtMPMCTrCR      : std_logic_vector(6 downto 0)  := (others => '0');
-- D-input for the MPMCTrCR Register

signal NxtMPMCTrSNPCR   : std_logic_vector(3 downto 0)  := (others => '0');
-- D-input for the MPMCTrSNPCR Register

signal NxtMPMCTrExpRef  : std_logic_vector(3 downto 0)  := (others => '0');
-- D-input for the MPMCTrExpRef Register

signal NxtMPMCTrExBkOff : std_logic_vector(5 downto 0)  := (others => '0');
-- D-input for the MPMCTrExBkOff Register

signal NxtMPMCTrControl : std_logic_vector(3 downto 0) := (others => '0');
-- D-input for the MPMCTrControl Register

signal NxtMPMCTrConfig  : std_logic_vector(9 downto 0) := (others => '0');
-- D-input for the MPMCTrConfig Register

signal NxtMPMCTrDynCntl : std_logic_vector(15 downto 0) := (others => '0');
-- D-input for the MPMCTrDynCntl Register

signal NxtMPMCTrDyRfrsh : std_logic_vector(10 downto 0) := (others => '0');
-- D-input for the MPMCTrDynRfrsh Register

signal NxtMPMCTrStExtWt : std_logic_vector(9 downto 0) := (others => '0');
-- D-input for the MPMCTrStExtWt Register

signal NxtMPMCTrDynRC0  : std_logic_vector(9 downto 0) := (others => '0');
-- D-input for the MPMCTrDynRC0 Register

signal NxtMPMCTrDynRC1  : std_logic_vector(9 downto 0) := (others => '0');
-- D-input for the MPMCTrDynRC1 Register

signal NxtMPMCTrDynRC2  : std_logic_vector(9 downto 0) := (others => '0');
-- D-input for the MPMCTrDynRC2 Register

signal NxtMPMCTrDynRC3  : std_logic_vector(9 downto 0) := (others => '0');
-- D-input for the MPMCTrDynRC3 Register

signal NxtMPMCTrDyCnfg0 : std_logic_vector(29 downto 0) := (others => '0');
-- D-input for the MPMCTrDynCnfg0 Register

signal NxtMPMCTrDyCnfg1 : std_logic_vector(29 downto 0) := (others => '0');
-- D-input for the MPMCTrDynCnfg1 Register

signal NxtMPMCTrDyCnfg2 : std_logic_vector(29 downto 0) := (others => '0');
-- D-input for the MPMCTrDynCnfg2 Register

signal NxtMPMCTrDyCnfg3 : std_logic_vector(29 downto 0) := (others => '0');
-- D-input for the MPMCTrDynCnfg3 Register

signal NxtMPMCTrStCS    : std_logic_vector(6 downto 0) := "0100000";
-- D-input for the MPMCTrStCS Register

signal NxtMPMCTrTES     : std_logic_vector(3 downto 0) := (others => '0');
-- D-input for the MPMCTrTES Register

signal NxtHREADY0CNT    : std_logic_vector(7 downto 0) := (others => '0');
-- D-input for the HREADY0CNT Register

signal NxtHREADY1CNT    : std_logic_vector(7 downto 0) := (others => '0');
-- D-input for the HREADY1CNT Register

signal iHREADY0CNT    : std_logic_vector(7 downto 0) := (others => '0');
-- Internal version of the HREADY0CNT Register

signal iHREADY1CNT    : std_logic_vector(7 downto 0) := (others => '0');
-- Internal version of the HREADY1CNT Register
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
-- Combinational logic for all functional registers. When the respective
-- write enable input is asserted, copy the contents of the HWDATA Bus into
-- the corresponding registers.
-- -----------------------------------------------------------------------------
NxtMPMCTrCR      <= WriteData(6 downto 0) when (MPMCTrCRWr = '1')
                 else
                     iMPMCTrCR;

NxtMPMCTrSNPCR   <= WriteData(3 downto 0) when (MPMCTrSNPCRWr = '1')
                 else
                    iMPMCTrSNPCR;

NxtMPMCTrExpRef  <= WriteData(3 downto 0) when (MPMCTrExpRefWr = '1')
                 else
                    iMPMCTrExpRef;

NxtMPMCTrExBkOff <= WriteData(5 downto 0) when (MPMCTrExBkOffWr = '1')
                 else
                    iMPMCTrExBkOff;

NxtMPMCTrControl <= WriteData(3 downto 0) when (MPMCTrControlWr = '1')
                 else
                     iMPMCTrControl;

NxtMPMCTrConfig  <= WriteData(9 downto 0) when (MPMCTrConfigWr = '1')
                 else
                     iMPMCTrConfig;

NxtMPMCTrDynCntl <= WriteData(15 downto 0) when (MPMCTrDynCntlWr = '1')
                 else
                     iMPMCTrDynCntl;

NxtMPMCTrDyRfrsh <= WriteData(10 downto 0) when (MPMCTrDynRfrshWr = '1')
                 else
                     iMPMCTrDynRfrsh;

NxtMPMCTrStExtWt <= WriteData(9 downto 0) when (MPMCTrStExtWtWr = '1')
                 else
                     iMPMCTrStExtWt;

NxtMPMCTrDynRC0  <= WriteData(9 downto 0) when (MPMCTrDynRC0Wr = '1')
                 else
                     iMPMCTrDynRC0;

NxtMPMCTrDynRC1  <= WriteData(9 downto 0) when (MPMCTrDynRC1Wr = '1')
                 else
                     iMPMCTrDynRC1;

NxtMPMCTrDynRC2  <= WriteData(9 downto 0) when (MPMCTrDynRC2Wr = '1')
                 else
                     iMPMCTrDynRC2;

NxtMPMCTrDynRC3  <= WriteData(9 downto 0) when (MPMCTrDynRC3Wr = '1')
                 else
                     iMPMCTrDynRC3;

NxtMPMCTrDyCnfg0 <= WriteData(29 downto 0) when (MPMCTrDynCnfg0Wr = '1')
                 else
                     iMPMCTrDynCnfg0;

NxtMPMCTrDyCnfg1 <= WriteData(29 downto 0) when (MPMCTrDynCnfg1Wr = '1')
                 else
                     iMPMCTrDynCnfg1;

NxtMPMCTrDyCnfg2 <= WriteData(29 downto 0) when (MPMCTrDynCnfg2Wr = '1')
                 else
                     iMPMCTrDynCnfg2;

NxtMPMCTrDyCnfg3 <= WriteData(29 downto 0) when (MPMCTrDynCnfg3Wr = '1')
                 else
                     iMPMCTrDynCnfg3;

NxtMPMCTrStCS    <= WriteData(6 downto 0) when (MPMCTrStCSWr = '1')
                 else
                     iMPMCTrStCS;

NxtMPMCTrTES(0)  <= WriteData(0) when (MPMCTrTESWr0 = '1')
                 else
                     iMPMCTrTES(0);

NxtMPMCTrTES(1)  <= WriteData(1) when (MPMCTrTESWr1 = '1')
                 else
                     iMPMCTrTES(1);

NxtMPMCTrTES(2)  <= WriteData(2) when (MPMCTrTESWr2 = '1')
                 else
                     iMPMCTrTES(2);

NxtMPMCTrTES(3)  <= WriteData(3) when (MPMCTrTESWr3 = '1')
                 else
                     iMPMCTrTES(3);
NxtHREADY0CNT    <= WriteData(7 downto 0) when (HREADY0CNTWr = '1')
                 else
                    iHREADY0CNT; 

NxtHREADY1CNT    <= WriteData(7 downto 0) when (HREADY1CNTWr = '1')
                 else
                    iHREADY1CNT;

DataSR           <= WriteData(8 downto 0) when (MPMCTrSRWr = '1')
                  else
                    (others => '0');

-- -----------------------------------------------------------------------------
-- Sequential process for all functional registers writes.
-- -----------------------------------------------------------------------------
p_HResRegUpdSeq : process (HCLK, HRESETn)
begin
  if (HRESETn = '0') then
    iMPMCTrCR        <= (others => '0');
    iMPMCTrSNPCR     <= (others => '0');
    iMPMCTrTES       <= (others => '0');
    iMPMCTrExBkOff   <= (others => '1');
    iMPMCTrExpRef    <= "0010";
    iHREADY0CNT      <= (others => '1');
    iHREADY1CNT      <= (others => '1');
  elsif (HCLK'event and HCLK = '1') then
    iMPMCTrCR        <= NxtMPMCTrCR;
    iMPMCTrSNPCR     <= NxtMPMCTrSNPCR;
    iMPMCTrStCS      <= NxtMPMCTrStCS;
    iMPMCTrTES       <= NxtMPMCTrTES;
    iMPMCTrExpRef    <= NxtMPMCTrExpRef;
    iMPMCTrExBkOff   <= NxtMPMCTrExBkOff;
    iHREADY0CNT      <= NxtHREADY0CNT;
    iHREADY1CNT      <= NxtHREADY1CNT;
  end if;
end process p_HResRegUpdSeq;

-- -----------------------------------------------------------------------------
-- Sequential process for all nPOR reset registers writes.
-- -----------------------------------------------------------------------------
p_PORRegUpdSeq : process (HCLK, nPOR)
begin
  if (nPOR = '0') then
    iMPMCTrControl   <= "0011";
    iMPMCTrConfig(7 downto 0)    <= (others => '0');
    iMPMCTrDynCntl   <= "0000000000000010";
    iMPMCTrDynRfrsh  <= (others => '0');
    iMPMCTrStExtWt   <= (others => '0');
    iMPMCTrDynRC0    <= "1100000011";
    iMPMCTrDynRC1    <= "0100100100";
    iMPMCTrDynRC2    <= "0101000100";
    iMPMCTrDynRC3    <= "0101100100";
    iMPMCTrDynCnfg0  <= "000000000000000000000100000000";
    iMPMCTrDynCnfg1  <= "000000000000000000000100100000";
    iMPMCTrDynCnfg2  <= "000000000000000000000100100100";
    iMPMCTrDynCnfg3  <= "000000000000000000000101100000";
  elsif (HCLK'event and HCLK = '1') then
    iMPMCTrControl   <= NxtMPMCTrControl;
    iMPMCTrConfig    <= NxtMPMCTrConfig;
    iMPMCTrDynCntl   <= NxtMPMCTrDynCntl;
    iMPMCTrDynRfrsh  <= NxtMPMCTrDyRfrsh;
    iMPMCTrStExtWt   <= NxtMPMCTrStExtWt;
    iMPMCTrDynRC0    <= NxtMPMCTrDynRC0;
    iMPMCTrDynRC1    <= NxtMPMCTrDynRC1;
    iMPMCTrDynRC2    <= NxtMPMCTrDynRC2;
    iMPMCTrDynRC3    <= NxtMPMCTrDynRC3;
    iMPMCTrDynCnfg0  <= NxtMPMCTrDyCnfg0;
    iMPMCTrDynCnfg1  <= NxtMPMCTrDyCnfg1;
    iMPMCTrDynCnfg2  <= NxtMPMCTrDyCnfg2;
    iMPMCTrDynCnfg3  <= NxtMPMCTrDyCnfg3;
  end if;
end process p_PORRegUpdSeq;

-- -----------------------------------------------------------------------------
-- Assign local copies of signals to the outputs
-- -----------------------------------------------------------------------------
MPMCTrCR         <= iMPMCTrCR;
MPMCTrSNPCR      <= iMPMCTrSNPCR;
MPMCTrControl    <= iMPMCTrControl;
MPMCTrConfig     <= iMPMCTrConfig;
MPMCTrDynCntl    <= iMPMCTrDynCntl;
MPMCTrDynRfrsh   <= iMPMCTrDynRfrsh;
MPMCTrStExtWt    <= iMPMCTrStExtWt;
MPMCTrDynRC0     <= iMPMCTrDynRC0;
MPMCTrDynRC1     <= iMPMCTrDynRC1;
MPMCTrDynRC2     <= iMPMCTrDynRC2;
MPMCTrDynRC3     <= iMPMCTrDynRC3;
MPMCTrDynCnfg0   <= iMPMCTrDynCnfg0;
MPMCTrDynCnfg1   <= iMPMCTrDynCnfg1;
MPMCTrDynCnfg2   <= iMPMCTrDynCnfg2;
MPMCTrDynCnfg3   <= iMPMCTrDynCnfg3;
MPMCTrStCS       <= iMPMCTrStCS;
MPMCTrDynMEMT    <= iMPMCTrDynCnfg3(4) & iMPMCTrDynCnfg2(4) &
                    iMPMCTrDynCnfg1(4) & iMPMCTrDynCnfg0(4);
MPMCTrTES        <= iMPMCTrTES;
MPMCTrExpRef     <= iMPMCTrExpRef;
MPMCTrExBkOff    <= iMPMCTrExBkOff;
MPMCTrWrPrStat   <= iMPMCTrDynCnfg3(20) & iMPMCTrDynCnfg2(20) &
                    iMPMCTrDynCnfg1(20) & iMPMCTrDynCnfg0(20);
HREADY0CNT       <= iHREADY0CNT;
HREADY1CNT       <= iHREADY1CNT;
end behavioural;

-- --================================== End ==================================--
