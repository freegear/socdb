-- --=================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 2000 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
--
-- ---------------------------------------------------------------------
-- Version and Release Control Information:
--
-- File Name              : AaciTrClkGen.vhd.rca
-- File Revision          : 1.3
--
-- Release Information    : PrimeCell(TM)-PL041-REL1v0
--
-- ---------------------------------------------------------------------
-- Purpose :
--           This generates the AACIBITCLK and AACIBITCLKRSTn in
--           AACIBITCLK domain.
--
-- --=================================================================--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

use work.AaciTrPackage.all;

-- ---------------------------------------------------------------------

entity AaciTrClkGen is
  port (
-- Inputs
        PCLK             : in    std_logic; -- APB bus clock
        PRESETn          : in    std_logic; -- APB bus reset
        AACITrBtClkE     : in    std_logic; -- BITCLKE
        AACITrBtClkRst   : in    std_logic; -- AACI BITCLK domain reset
        AACITrBtClkPrd   : in    std_logic_vector(15 downto 0);
                                            -- BITCLK period value
        AACITrClkReg     : in    std_logic_vector(2 downto 0);
                                            -- BITCLK muxing register
-- Outputs
        PCLKOn           : out   std_logic; -- Indicates PCLK is routed
                                            -- to BITCLK
        BITCLKOn         : out   std_logic; -- Indicates BITCLK is
                                            -- routed to BITCLK
        AACIBITCLK       : out   std_logic; -- AACI serial Clock out
        BITCLKIn         : out   std_logic; -- AACI serial Clock local
        nAACIBITCLKRST   : out   std_logic; -- Reset in the AACIBITCLK
                                            -- domain
        nFAACIBITCLKRST  : out   std_logic  -- Reset in the nAACIBITCLK
                                            -- domain
       );
end AaciTrClkGen;

-- ---------------------------------------------------------------------
--
--                            AaciTrClkGen
--                            ============
--
-- ---------------------------------------------------------------------
--
-- Overview
-- ========
--
-- This submodule of the AACI trickbox provides the BITCLK serial clock
-- output for the serial data transmission. The BITCLK generator
-- generates a clock whose frequency is dependent on the value in the
-- AACITrBtClkPrd. Similarly the nAACIBITCLKRST is driven low when the
-- AACITrBtCLkRst bit from the control register of the trickbox is
-- reset to zero. The assertion to low value is asynchronous but the
-- de-assertion is synchronous to BITCLK.
--
-- ---------------------------------------------------------------------

-- --======================== ARCHITECTURE ===========================--

architecture behavioural of AaciTrClkGen is

-- ---------------------------------------------------------------------
-- Constant declarations
-- ---------------------------------------------------------------------

-- ---------------------------------------------------------------------
-- Signal declarations
-- ---------------------------------------------------------------------
signal iBITCLK          : std_logic := '0';
-- Internal BITCLK

signal BitClkSelected   : std_logic := '0';
-- Internal BITCLK

signal AACITrBtClkESync : std_logic;
-- Synchronised version of AACITrBtClkE to iBITCLK

signal BITCLKSkewd      : std_logic := '0';
-- Internal BITCLK

signal PCLKEnNegSync    : std_logic := '0';
-- PCLKEN bit synced to falling edge of PCLK

signal BITCLKEnNegSync  : std_logic := '0';
-- BITCLKEn bit synced to falling edge of BITCLK

signal MuxInBITCLK      : std_logic := '0';
-- RCLKEnNegSync anded with BITCLK

signal MuxInPCLK        : std_logic := '0';
-- PCLKEnNegSync anded with PCLK

-- ---------------------------------------------------------------------
-- Function declarations
-- ---------------------------------------------------------------------
function CONV_INTEGER (
         arg: std_logic_vector
                      ) return integer is
variable OutVal : integer;
begin
  if (arg = "UUUUUUUUUUUUUUUU") then
    OutVal := 2;
  else
    OutVal := CONV_INTEGER (arg);
  end if;
    return OutVal;
end CONV_INTEGER;

-- ---------------------------------------------------------------------
--
-- Main body of code
-- =================
--
-- ---------------------------------------------------------------------

begin

-- ---------------------------------------------------------------------
-- Connect local copies to output ports
-- ---------------------------------------------------------------------
BITCLKIn      <= BITCLKSkewd;

-- ---------------------------------------------------------------------
-- BITCLK generation based on the value in AACTrBtClkPrd
-- ---------------------------------------------------------------------
p_BITCLKGenSeq: process (AACITrBtClkPrd, iBITCLK)
  variable Clk_low  : time;  -- Clock Width
  variable Clk_high : time;  -- Clock Width
begin
  if (AACITrBtClkPrd /= "0000000000000000" and
      AACITrBtClkPrd /= "UUUUUUUUUUUUUUUU") then
    if (AACITrBtClkPrd (0) = '1') then
      Clk_low := (CONV_INTEGER (unsigned('0' &
                    AACITrBtClkPrd (15 downto 1))) + 1 ) * 1 ns;
    else
      Clk_low := CONV_INTEGER (unsigned('0' &
                   AACITrBtClkPrd (15 downto 1))) * 1 ns;
    end if;
    Clk_high := CONV_INTEGER (unsigned('0' &
                  AACITrBtClkPrd (15 downto 1))) * 1 ns;
    if (iBITCLK = '1') then
      iBITCLK <= '0' after Clk_high;
    else
      iBITCLK <= '1' after Clk_low;
    end if;
  end if;
end process p_BITCLKGenSeq;

-- --------------------------------------------------------------------
-- Derive final clock signals by gating the clocks with the respective
-- enable signals synchronised to the BITCLK clock domain.
-- --------------------------------------------------------------------
AACIBITCLK   <= BITCLKSkewd and AACITrBtClkESync;

-- ---------------------------------------------------------------------
-- Synchronize the Enable of the BITCLK to the iBITCLK domain.
-- ---------------------------------------------------------------------
p_BtlkEnSyncSeq: process (iBITCLK)
begin
  if (iBITCLK'event and iBITCLK = '1') then
    AACITrBtClkESync <= AACITrBtClkE;
  end if;
end process p_BtlkEnSyncSeq;

-- ---------------------------------------------------------------------
-- BITCLKSkewd generation based on the value in BtClkSkew
-- ---------------------------------------------------------------------
p_BITCLKSkdGen: process (BitClkSelected)
begin
  BITCLKSkewd <= BitClkSelected after BtClkSkew;
end process p_BITCLKSkdGen;

-- ---------------------------------------------------------------------
-- Reset signal generator.The Reset is done asynchronously but the
-- deassertion is done synchronous to the AACIBITCLK clock.
-- ---------------------------------------------------------------------
p_RstCtrlSeq: process (AACITrBtClkRst, BITCLKSkewd)
begin
  if (AACITrBtClkRst = '0') then
    nAACIBITCLKRST <= '0';
  elsif ((AACITrBtClkRst = '1')and (PCLKEnNegSync = '0') and
          (BITCLKEnNegSync = '0')) then
    nAACIBITCLKRST <= '1';
  elsif (BITCLKSkewd'event and BITCLKSkewd = '0') then
    nAACIBITCLKRST <= AACITrBtClkRst;
  end if;
end process p_RstCtrlSeq;

-- ---------------------------------------------------------------------
-- Reset signal generator.The Reset is done asynchronously but the
-- deassertion is done synchronous to the nAACIBITCLK clock.
-- ---------------------------------------------------------------------
p_RstCtrlSeq1: process (AACITrBtClkRst, BITCLKSkewd)
begin
  if (AACITrBtClkRst = '0') then
    nFAACIBITCLKRST <= '0';
  elsif ((AACITrBtClkRst = '1')and (PCLKEnNegSync = '0') and
          (BITCLKEnNegSync = '0')) then
    nFAACIBITCLKRST <= '1';
  elsif (BITCLKSkewd'event and BITCLKSkewd = '1') then
    nFAACIBITCLKRST <= AACITrBtClkRst;
  end if;
end process p_RstCtrlSeq1;

-- ---------------------------------------------------------------------
-- Synchronize the Enable of the PCLK to the PCLK domain.
-- The synchronising is done on the falling edges of the clock so as to
-- avoid glitiches on the gated versions of the clocks.
-- ---------------------------------------------------------------------
p_PCLKEnSyncSeq: process (PCLK, AACITrClkReg)
begin
  if (PCLK'event and PCLK = '0') then
    PCLKEnNegSync <= AACITrClkReg(1);
  end if;
end process p_PCLKEnSyncSeq;

-- ---------------------------------------------------------------------
-- Synchronize the Enable of the iBITCLK to the iBITCLK domain.
-- The synchronising is done on the falling edges of the clock so as to
-- avoid glitiches on the gated versions of the clocks.
-- ---------------------------------------------------------------------
p_BtCkEnSncSeq: process (iBITCLK, AACITrClkReg)
begin
  if (iBITCLK'event and iBITCLK = '0') then
    BITCLKEnNegSync <= AACITrClkReg(2);
  end if;
end process p_BtCkEnSncSeq;

-- ---------------------------------------------------------------------
-- Derive intermediate clock signals by gating the clocks with the
-- respective enable signals synchronised to the corresponding clock
-- domain.
-- ---------------------------------------------------------------------
MuxInBITCLK  <= iBITCLK and BITCLKEnNegSync;
MuxInPCLK    <= PCLK    and PCLKEnNegSync;

-- ---------------------------------------------------------------------
-- Writes the Status Bits PCLKOn and BITCLK into the Status Register of
-- the TrickBox and the write is done on seeing the positive edge of
-- the PCLK. These signals will be used by the test code to detect
-- whether the respective clock is died down or not.
-- ---------------------------------------------------------------------
p_StatGenSeq: process (PCLK)
begin
  if (PCLK'event and PCLK = '1') then
    PCLKOn    <= PCLKEnNegSync;
    BITCLKOn  <= BITCLKEnNegSync;
  end if;
end process p_StatGenSeq;

-- ---------------------------------------------------------------------
-- This process routes either MuxInPCLK or MuxInBITCLK to BITCLK.
-- ---------------------------------------------------------------------
p_RoutComb : process (AACITrClkReg, MuxInPCLK, MuxInBITCLK)
begin
  if (AACITrClkReg(0) /= 'X') then
    if (AACITrClkReg(0) = '1') then
      BitClkSelected   <= MuxInPCLK;
    else
      BitClkSelected   <= MuxInBITCLK;
    end if;
  end if;
end process p_RoutComb;

end behavioural;

-- --============================ End ================================--
