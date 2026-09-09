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
-- File Name              : MmciTrMclkRsgen.vhd.rca
-- File Revision          : 1.3
--
-- Release Information    : PrimeCell(TM)-PL181-REL1v0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           This block generates the MCLK and nMMCIRST signals
--           for the MMCI controller
--
-- --=========================================================================--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

-- -----------------------------------------------------------------------------

entity MmciTrMclkRsgen is
  port (
-- Inputs
        PCLK             : in    std_logic; -- APB Bus clock
        PRESETn          : in    std_logic; -- Bus reset
        MMCITBMCLKWr     : in    std_logic; -- WrEn to MMCITBMCLKPd
        MMCITBCLKRSTWr   : in    std_logic; -- WrEn to MMCITBCkRsCtl
        PWDATAIn         : in    std_logic_vector(31 downto 0);
                                            -- Write Data from APB Bus
-- Outputs
        MCLK             : out   std_logic; -- MCLK output to MMCI
        nMMCIRST         : out   std_logic; -- Reset to MMCI
        MMCITBMCLKPeriod : out   std_logic_vector(31 downto 0);
                                            -- Mclk period value reg
        PCLKOn           : out   std_logic; -- Indicates PCLK in
                                            -- enabled internally
        MCLKOn           : out   std_logic  -- Indicates MCLK in
                                            -- enabled internally
       );
end MmciTrMclkRsgen;

-- -----------------------------------------------------------------------------
--
--                               MmciTrMclkRsgen
--                               ===============
--
-- -----------------------------------------------------------------------------
--
-- Overview
-- ========
--   This block generates the MCLK and the nMMCIRST signals.The
-- MmciTrMclkRstCtrl register bits are interpreted in this block.
-- -----------------------------------------------------------------------------

-- --============================ ARCHITECTURE ===============================--

architecture behavioural of MmciTrMclkRsgen is

-- -----------------------------------------------------------------------------
-- Component declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Constant declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Signal declarations
-- -----------------------------------------------------------------------------
signal MMCITBMCLKPd     : std_logic_vector(31 downto 0);
-- MMCITBMCLKPd Register to hold MCLk period value

signal MMCITBCkRsCtl    : std_logic_vector(3 downto 0) := "0000";
-- MMCITBCkRsCtl register, holds clock muxing bits

signal NxtMMCITBMCLKPd  : std_logic_vector(31 downto 0);
-- D-Input to MMCITBMCLKPd

signal NxtMMCITBCkRsCtl : std_logic_vector(3 downto 0) := "0000";
-- D-Input to MMCITBCkRsCtl

signal MRefClk          : std_logic := '0';
-- Generated as per MMCITBMCLKPd

signal iMCLK            : std_logic := '0';
-- Internal MCLK

signal PCLKEnNegSync    : std_logic := '0';
-- PCLKEN bit synced to falling edge of PCLK

signal RCLKEnNegSync    : std_logic := '0';
-- RCLKEn bit synced to falling edge of MRefClk

signal MuxInRCLK        : std_logic := '0';
-- RCLKEnNegSync anded with MRefClk

signal MuxInPCLK        : std_logic := '0';
-- PCLKEnNegSync anded with PCLK

signal RSTBIT           : std_logic;
-- Gives the status of reset bit in MciClkRstCntl Register

signal IntnMMCIRST      : std_logic;
-- Used to generate a pulse of nMMCIRST

-- -----------------------------------------------------------------------------
-- Function declarations
-- -----------------------------------------------------------------------------
function to_integer (val : std_logic_vector; x : integer := 0)
return integer is
variable returnint : integer;
-- Return integer from the function

variable xtmp      : integer;
-- Temporary variable

begin
  returnint := 0;
  xtmp := 0;
  if x /= 0 then
    xtmp := 1;
  end if;
  for i in val'range loop
    returnint := returnint + returnint;
    case val(i) is
      when '0' => null;
      when '1' => returnint := returnint + 1;
      when others => returnint := returnint + xtmp;
    end case;
  end loop;
  return returnint;
end to_integer;

function CONV_INTEGER(arg: std_logic_vector) return integer is
variable OutVal : integer;
begin
  if (arg = "UUUUUUUUUUUUUUUU") then
    OutVal := 2;
  else
    OutVal := CONV_INTEGER(arg);
  end if;
    return OutVal;
end CONV_INTEGER;

-- -----------------------------------------------------------------------------
--
-- Main body of code
-- =================
--
-- -----------------------------------------------------------------------------

begin

-- -----------------------------------------------------------------------------
-- Connect local copies to output ports
-- -----------------------------------------------------------------------------
MCLK             <= iMCLK;
MMCITBMCLKPeriod <= MMCITBMCLKPd;

-- -----------------------------------------------------------------------------
-- MRefClk generation based on the value in MMCITBMCLKPd
-- -----------------------------------------------------------------------------
p_MCLKGenSeq : process (MMCITBMCLKPd, MRefClk)
  variable Clk_low  : time := 10 ns;
-- Clock Width

  variable Clk_high : time := 10 ns;
-- Clock Width
begin
  if (MMCITBMCLKPd /= "00000000000000000000000000000000" and
      MMCITBMCLKPd /= "UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU") then
    if (MMCITBMCLKPd(0) = '1') then
      Clk_low := (CONV_INTEGER(unsigned('0' &
                          MMCITBMCLKPd(31 downto 1))) + 1 ) * 1 ns;
    else
      Clk_low := CONV_INTEGER(unsigned('0' &
                          MMCITBMCLKPd(31 downto 1))) * 1 ns;
    end if;
    Clk_high := CONV_INTEGER(unsigned('0' &
                          MMCITBMCLKPd(31 downto 1))) * 1 ns;
  end if;

  if (MRefClk = '1') then
    MRefClk <= '0' after Clk_high;
  else
    MRefClk <= '1' after Clk_low;
  end if;
end process p_MCLKGenSeq;

-- -----------------------------------------------------------------------------
-- Reset signal generator.The Reset is done asynchronously but the
-- deassertion is done synchronous to the MMCIClk clock.
-- -----------------------------------------------------------------------------

p_RstCtrlSeq : process (RSTBIT, iMCLK, PRESETn)
begin
  if (RSTBIT = '1' or PRESETn = '0') then
    nMMCIRST    <= '0';
    IntnMMCIRST <= '0';
  elsif (iMCLK'event and iMCLK = '1') then
    IntnMMCIRST <= '1';
    nMMCIRST    <= IntnMMCIRST;
  end if;
end process p_RstCtrlSeq;

-- -----------------------------------------------------------------------------
-- Synchronize the Enable of the PCLK to the PCLK domain.
-- -----------------------------------------------------------------------------
p_PCLKEnSyncSeq : process (PCLK, MMCITBCkRsCtl)
begin
  if (PCLK'event and PCLK = '0') then
    PCLKEnNegSync <= MMCITBCkRsCtl(1);
  end if;
end process p_PCLKEnSyncSeq;

-- -----------------------------------------------------------------------------
-- Synchronize the Enable of the MRefClk to the MRefClk domain.
-- -----------------------------------------------------------------------------
p_RCLKEnSyncSeq : process (MRefClk, MMCITBCkRsCtl)
begin
  if (MRefClk'event and MRefClk = '0') then
    RCLKEnNegSync <= MMCITBCkRsCtl(2);
  end if;
end process p_RCLKEnSyncSeq;
-- -----------------------------------------------------------------------------
-- Writes the Status Bits PCLKOn and MCLKOn into the Status Register of
-- the TrickBox and the write is done on seeing the positive edge of
-- the PCLK
-- -----------------------------------------------------------------------------
p_StatGenSeq: process (PCLK, PCLKEnNegSync, RCLKEnNegSync)
begin
  if (PCLK'event and PCLK = '1') then
    PCLKOn <= PCLKEnNegSync;
    MCLKOn <= RCLKEnNegSync;
  end if;
end process p_StatGenSeq;

-- ----------------------------------------------------------------------------
-- Derive intermediate clock signals by gating the clocks with the
-- respective enable signals synchronised to the corresponding clock
-- domain.
-- ----------------------------------------------------------------------------
MuxInRCLK <= MRefClk and RCLKEnNegSync;
MuxInPCLK <= PCLK when (PCLKEnNegSync = '1')
          else
             '0';

-- ----------------------------------------------------------------------------
-- This process routes the MuxInRCLK to the MCLK
-- ----------------------------------------------------------------------------
p_RoutComb : process (MuxInRCLK, MuxInPCLK)
variable temp : std_logic := '0';
begin
  if (MMCITBCkRsCtl(3) = '1') then
    iMCLK <= MuxInRCLK;
  else
    temp := MuxInPCLK;
    iMCLK <= temp;
  end if;
end process p_RoutComb;

-- ----------------------------------------------------------------------------
--  Driving the RSTBIT
-- ----------------------------------------------------------------------------
RSTBIT <= MMCITBCkRsCtl(0);

-- ----------------------------------------------------------------------------
--  Writes to the registers
-- ----------------------------------------------------------------------------
p_RegWriteComb : process (MMCITBMCLKPd, MMCITBCkRsCtl, MMCITBMCLKWr,
                          PWDATAIn, MMCITBCLKRSTWr)
begin
  if (MMCITBMCLKWr = '1') then
    NxtMMCITBMCLKPd <= PWDATAIn;
  else
    NxtMMCITBMCLKPd <= MMCITBMCLKPd;
  end if;

  if (MMCITBCLKRSTWr = '1') then
    NxtMMCITBCkRsCtl <= PWDATAIn(3 downto 0);
  else
    NxtMMCITBCkRsCtl <= MMCITBCkRsCtl;
  end if;
end process p_RegWriteComb;

p_RegWriteSeq : process (PCLK, PRESETn)
begin
  if (PRESETn = '0') then
    MMCITBMCLKPd  <= (others => '0');
    MMCITBCkRsCtl <= (others => '0');
  elsif (PCLK'event and PCLK = '1') then
    MMCITBMCLKPd  <= NxtMMCITBMCLKPd;
    MMCITBCkRsCtl <= NxtMMCITBCkRsCtl;
  end if;
end process p_RegWriteSeq;
end behavioural;

-- --================================== End ==================================--
