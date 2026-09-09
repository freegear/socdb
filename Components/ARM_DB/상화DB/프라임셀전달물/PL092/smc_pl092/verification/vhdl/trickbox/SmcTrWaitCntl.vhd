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
-- File Name              : SmcTrWaitCntl.vhd.rca
-- File Revision          : 1.9
--
-- Release Information    : PrimeCell(TM)-PL092-REL1v1
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           This module routes the SMWAIT signal and asserts the CancelSMWAIT
--           signal when the SMWAIT signal gets timed-out.
--
-- --=========================================================================--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

-- -----------------------------------------------------------------------------

entity SmcTrWaitCntl is
  generic (
           Tclk : time
          );
  port (
-- Inputs
        -- AHB bus signals
        HCLK             : in    std_logic; -- AHB Bus Clock
        HRESETn          : in    std_logic; -- Bus Reset
        SMCActLowCS      : in    std_logic_vector(7 downto 0);
                                            -- Active low Memory Bank Select
        SMADDR           : in    std_logic_vector(25 downto 0);
                                            -- External Address Bus
        SMCTrCS2WTR0     : in    std_logic_vector(25 downto 0);
                                            -- nCS-SMCTrnWAIT assertion delay
                                            -- for Bank 0
        SMCTrCEWTR0      : in    std_logic_vector(23 downto 0);
                                            -- Counter expiry-SMWAIT
                                            -- de-assertion delay for Bank 0
        SMCTrCS2WTR1     : in    std_logic_vector(25 downto 0);
                                            -- nCS-SMCTrnWAIT assertion delay
                                            -- for Bank 1
        SMCTrCEWTR1      : in    std_logic_vector(23 downto 0);
                                            -- Counter expiry-SMWAIT
                                            -- de-assertion delay for Bank 1
        SMCTrCS2WTR2     : in    std_logic_vector(25 downto 0);
                                            -- nCS-SMCTrnWAIT assertion delay
                                            -- for Bank 2
        SMCTrCEWTR2      : in    std_logic_vector(23 downto 0);
                                            -- Counter expiry-SMWAIT
                                            -- de-assertion delay for Bank 2
        SMCTrCS2WTR3     : in    std_logic_vector(25 downto 0);
                                            -- nCS-SMCTrnWAIT assertion delay
                                            -- for Bank 3
        SMCTrCEWTR3      : in    std_logic_vector(23 downto 0);
                                            -- Counter expiry-SMWAIT
                                            -- de-assertion delay for Bank 3
        SMCTrCS2WTR4     : in    std_logic_vector(25 downto 0);
                                            -- nCS-SMCTrnWAIT assertion delay
                                            -- for Bank 4
        SMCTrCEWTR4      : in    std_logic_vector(23 downto 0);
                                            -- Counter expiry-SMWAIT
                                            -- de-assertion delay for Bank 4
        SMCTrCS2WTR5     : in    std_logic_vector(25 downto 0);
                                            -- nCS-SMCTrnWAIT assertion delay
                                            -- for Bank 5
        SMCTrCEWTR5      : in    std_logic_vector(23 downto 0);
                                            -- Counter expiry-SMWAIT
                                            -- de-assertion delay for Bank 5
        SMCTrCS2WTR6     : in    std_logic_vector(25 downto 0);
                                            -- nCS-SMCTrnWAIT assertion delay
                                            -- for Bank 6
        SMCTrCEWTR6      : in    std_logic_vector(23 downto 0);
                                            -- Counter expiry-SMWAIT
                                            -- de-assertion delay for Bank 6
        SMCTrCS2WTR7     : in    std_logic_vector(25 downto 0);
                                            -- nCS-SMCTrnWAIT assertion delay
                                            -- for Bank 7
        SMCTrCEWTR7      : in    std_logic_vector(23 downto 0);
                                            -- Counter expiry-SMWAIT
                                            -- de-assertion delay for Bank 7

-- Outputs
        SMWAIT           : out   std_logic; -- External Wait signal routed to
                                            -- the SMC
        CANCELSMWAIT     : out   std_logic  -- External Wait time out signal
       );
end SmcTrWaitCntl;

-- -----------------------------------------------------------------------------
--
--                                SmcTrWaitCntl
--                                =============
--
-- -----------------------------------------------------------------------------
--
-- Overview
-- ========
-- SMC Tricbox is an AHB slave. This block performs the following operations:
--   - Routes the SMWAIT signal according to the selected Memory Bank.
--   - Asserts the CancelSMWAIT signal when the SMWAIT signal gets timed out.
--
-- -----------------------------------------------------------------------------

-- --============================ ARCHITECTURE ===============================--

architecture behavioural of SmcTrWaitCntl is

-- -----------------------------------------------------------------------------
-- Component declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Constant declarations
-- -----------------------------------------------------------------------------
constant WTSTATE_TOUT    : unsigned(4 downto 0) := "11111";
-- External Wait time-out count

-- -----------------------------------------------------------------------------
-- Signal declarations
-- -----------------------------------------------------------------------------
signal nSMWAIT          : std_logic := '1';
-- Internal version of the SMWAIT (Active LOW)

signal DelSMADDR        : std_logic_vector(25 downto 0);
-- Delayed SMADDR

signal SelWaitPol       : std_logic := '0';
-- The Wait Polarity of the Selected Memory

signal WaitEn           : std_logic_vector(7 downto 0);
-- The Wait Enable of the Memory Banks

signal WaitPol          : std_logic_vector(7 downto 0);
-- The Wait Polarity of the Memory Banks

signal WaitCount        : unsigned(4 downto 0);
-- External Wait State Counter

signal IntCS2WTR0       : time := 0 ns;
-- Memory Chip Select to SMCTrWAIT assertion delay time for Bank 0

signal IntCEWTR0        : time := 0 ns;
-- SMCTrWAIT assertion to de-assertion delay time for Bank 0

signal IntCS2WTR1       : time := 0 ns;
-- Memory Chip Select to SMCTrWAIT assertion delay time for Bank 1

signal IntCEWTR1        : time := 0 ns;
-- SMCTrWAIT assertion to de-assertion delay time for Bank 1

signal IntCS2WTR2       : time := 0 ns;
-- Memory Chip Select to SMCTrWAIT assertion delay time for Bank 2

signal IntCEWTR2        : time := 0 ns;
-- SMCTrWAIT assertion to de-assertion delay time for Bank 2

signal IntCS2WTR3       : time := 0 ns;
-- Memory Chip Select to SMCTrWAIT assertion delay time for Bank 3

signal IntCEWTR3        : time := 0 ns;
-- SMCTrWAIT assertion to de-assertion delay time for Bank 3

signal IntCS2WTR4       : time := 0 ns;
-- Memory Chip Select to SMCTrWAIT assertion delay time for Bank 4

signal IntCEWTR4        : time := 0 ns;
-- SMCTrWAIT assertion to de-assertion delay time for Bank 4

signal IntCS2WTR5       : time := 0 ns;
-- Memory Chip Select to SMCTrWAIT assertion delay time for Bank 5

signal IntCEWTR5        : time := 0 ns;
-- SMCTrWAIT assertion to de-assertion delay time for Bank 5

signal IntCS2WTR6       : time := 0 ns;
-- Memory Chip Select to SMCTrWAIT assertion delay time for Bank 6

signal IntCEWTR6        : time := 0 ns;
-- SMCTrWAIT assertion to de-assertion delay time for Bank 6

signal IntCS2WTR7       : time := 0 ns;
-- Memory Chip Select to SMCTrWAIT assertion delay time for Bank 7

signal IntCEWTR7        : time := 0 ns;
-- SMCTrWAIT assertion to de-assertion delay time for Bank 7

signal IntTOUT          : time := 32 * Tclk;
-- Time out period for the External Wait transfer

-- -----------------------------------------------------------------------------
-- Function declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- ToInteger
-- ---------
--   This function converts the std_logic_vector input argument into integer
-- and returns the integer value.
-- -----------------------------------------------------------------------------
function ToInteger (val : std_logic_vector; x : integer := 0)
return integer is
variable return_int, x_tmp : integer;
begin
  return_int := 0;
  x_tmp := 0;
    if x /= 0 then
      x_tmp := 1;
    end if;
    for i in val'range loop
      return_int := return_int + return_int;
      case val(i) is
        when '0' =>     null;
        when '1' =>     return_int := return_int + 1;
        when others =>  return_int := return_int + x_tmp;
      end case;
    end loop;
  return return_int;
end ToInteger;

-- -----------------------------------------------------------------------------
--
-- Main body of code
-- =================
--
-- -----------------------------------------------------------------------------

begin

-- -----------------------------------------------------------------------------
-- SMCTrCS2WT Register field rename
-- -----------------------------------------------------------------------------
WaitEn           <= SMCTrCS2WTR7(25) & SMCTrCS2WTR6(25) & SMCTrCS2WTR5(25) &
                    SMCTrCS2WTR4(25) & SMCTrCS2WTR3(25) & SMCTrCS2WTR2(25) &
                    SMCTrCS2WTR1(25) & SMCTrCS2WTR0(25);

WaitPol          <= SMCTrCS2WTR7(24) & SMCTrCS2WTR6(24) & SMCTrCS2WTR5(24) &
                    SMCTrCS2WTR4(24) & SMCTrCS2WTR3(24) & SMCTrCS2WTR2(24) &
                    SMCTrCS2WTR1(24) & SMCTrCS2WTR0(24);

-- -----------------------------------------------------------------------------
-- Converting std_logic_vector to time.
-- -----------------------------------------------------------------------------
IntCEWTR0        <= ToInteger(SMCTrCEWTR0) * Tclk;
IntCEWTR1        <= ToInteger(SMCTrCEWTR1) * Tclk;
IntCEWTR2        <= ToInteger(SMCTrCEWTR2) * Tclk;
IntCEWTR3        <= ToInteger(SMCTrCEWTR3) * Tclk;
IntCEWTR4        <= ToInteger(SMCTrCEWTR4) * Tclk;
IntCEWTR5        <= ToInteger(SMCTrCEWTR5) * Tclk;
IntCEWTR6        <= ToInteger(SMCTrCEWTR6) * Tclk;
IntCEWTR7        <= ToInteger(SMCTrCEWTR7) * Tclk;
IntCS2WTR0       <= ToInteger(SMCTrCS2WTR0(23 downto 0)) * Tclk;
IntCS2WTR1       <= ToInteger(SMCTrCS2WTR1(23 downto 0)) * Tclk;
IntCS2WTR2       <= ToInteger(SMCTrCS2WTR2(23 downto 0)) * Tclk;
IntCS2WTR3       <= ToInteger(SMCTrCS2WTR3(23 downto 0)) * Tclk;
IntCS2WTR4       <= ToInteger(SMCTrCS2WTR4(23 downto 0)) * Tclk;
IntCS2WTR5       <= ToInteger(SMCTrCS2WTR5(23 downto 0)) * Tclk;
IntCS2WTR6       <= ToInteger(SMCTrCS2WTR6(23 downto 0)) * Tclk;
IntCS2WTR7       <= ToInteger(SMCTrCS2WTR7(23 downto 0)) * Tclk;

-- -----------------------------------------------------------------------------
-- Generation of Delayed SMADDR
-- -----------------------------------------------------------------------------
DelSMADDR        <= SMADDR after 2 ns;

-- -----------------------------------------------------------------------------
-- Choose the Wait Polarity of the selected Memory
-- -----------------------------------------------------------------------------
p_WaitPolSelComb : process (nSMWAIT, SMCActLowCS)
begin
  if (nSMWAIT = '1') then
    if (SMCActLowCS(0) = '0') then
      SelWaitPol <= WaitPol(0);
    elsif (SMCActLowCS(1) = '0') then
      SelWaitPol <= WaitPol(1);
    elsif (SMCActLowCS(2) = '0') then
      SelWaitPol <= WaitPol(2);
    elsif (SMCActLowCS(3) = '0') then
      SelWaitPol <= WaitPol(3);
    elsif (SMCActLowCS(4) = '0') then
      SelWaitPol <= WaitPol(4);
    elsif (SMCActLowCS(5) = '0') then
      SelWaitPol <= WaitPol(5);
    elsif (SMCActLowCS(6) = '0') then
      SelWaitPol <= WaitPol(6);
    elsif (SMCActLowCS(7) = '0') then
      SelWaitPol <= WaitPol(7);
    end if;
  end if;
end process p_WaitPolSelComb;

-- -----------------------------------------------------------------------------
-- Combinational logic for the Assertion and de-Assertion of the SMWAIT
-- signal
-- -----------------------------------------------------------------------------
p_SMWAITComb : process (SMCActLowCS, WaitEn, nSMWAIT, DelSMADDR)
begin
  if (SMCActLowCS'event or (DelSMADDR'event and DelSMADDR = SMADDR)) then
    if (nSMWAIT = '1') then
      if (SMCActLowCS(0) = '0' and WaitEn(0) = '1') then
        if (IntCS2WTR0 < IntTOUT) then
          nSMWAIT <= '0' after (IntCS2WTR0 - 3 ns);
        end if;
      elsif (SMCActLowCS(1) = '0' and WaitEn(1) = '1') then
        if (IntCS2WTR1 < IntTOUT) then
          nSMWAIT <= '0' after (IntCS2WTR1 - 3 ns);
        end if;
      elsif (SMCActLowCS(2) = '0' and WaitEn(2) = '1') then
        if (IntCS2WTR2 < IntTOUT) then
          nSMWAIT <= '0' after (IntCS2WTR2 - 3 ns);
        end if;
      elsif (SMCActLowCS(3) = '0' and WaitEn(3) = '1') then
        if (IntCS2WTR3 < IntTOUT) then
          nSMWAIT <= '0' after (IntCS2WTR3 - 3 ns);
        end if;
      elsif (SMCActLowCS(4) = '0' and WaitEn(4) = '1') then
        if (IntCS2WTR4 < IntTOUT) then
          nSMWAIT <= '0' after (IntCS2WTR4 - 3 ns);
        end if;
      elsif (SMCActLowCS(5) = '0' and WaitEn(5) = '1') then
        if (IntCS2WTR5 < IntTOUT) then
          nSMWAIT <= '0' after (IntCS2WTR5 - 3 ns);
        end if;
      elsif (SMCActLowCS(6) = '0' and WaitEn(6) = '1') then
        if (IntCS2WTR6 < IntTOUT) then
          nSMWAIT <= '0' after (IntCS2WTR6 - 3 ns);
        end if;
      elsif (SMCActLowCS(7) = '0' and WaitEn(7) = '1') then
        if (IntCS2WTR7 < IntTOUT) then
          nSMWAIT <= '0' after (IntCS2WTR7 - 3 ns);
        end if;
      else
        nSMWAIT <= '1';
      end if;
    end if;
  elsif (nSMWAIT = '0') then
    if (SMCActLowCS(0) = '0' and WaitEn(0) = '1') then
      nSMWAIT <= '1' after (IntCEWTR0 - 3 ns);
    elsif (SMCActLowCS(1) = '0' and WaitEn(1) = '1') then
      nSMWAIT <= '1' after (IntCEWTR1 - 3 ns);
    elsif (SMCActLowCS(2) = '0' and WaitEn(2) = '1') then
      nSMWAIT <= '1' after (IntCEWTR2 - 3 ns);
    elsif (SMCActLowCS(3) = '0' and WaitEn(3) = '1') then
      nSMWAIT <= '1' after (IntCEWTR3 - 3 ns);
    elsif (SMCActLowCS(4) = '0' and WaitEn(4) = '1') then
      nSMWAIT <= '1' after (IntCEWTR4 - 3 ns);
    elsif (SMCActLowCS(5) = '0' and WaitEn(5) = '1') then
      nSMWAIT <= '1' after (IntCEWTR5 - 3 ns);
    elsif (SMCActLowCS(6) = '0' and WaitEn(6) = '1') then
      nSMWAIT <= '1' after (IntCEWTR6 - 3 ns);
    elsif (SMCActLowCS(7) = '0' and WaitEn(7) = '1') then
      nSMWAIT <= '1' after (IntCEWTR7 - 3 ns);
    end if;
  end if;
end process p_SMWAITComb;

-- -----------------------------------------------------------------------------
-- Process to count for the External WAIT time-out
-- -----------------------------------------------------------------------------
p_ExtWAITCntComb : process (HCLK, HRESETn)
begin
  if (HRESETn = '0') then
    WaitCount <= (others => '0');
  elsif (HCLK'event and HCLK = '1') then
    if (nSMWAIT = '0') then
      if (WaitCount <= WTSTATE_TOUT) then
        WaitCount <= WaitCount + 1;
      end if;
    else
      WaitCount <= (others => '0');
    end if;
  end if;
end process p_ExtWAITCntComb;

-- -----------------------------------------------------------------------------
-- Process to generate CancelSMWAIT
-- -----------------------------------------------------------------------------
p_CanSMWAITComb : process (HCLK, HRESETn)
begin
  if (HRESETn = '0') then
    CANCELSMWAIT <= '0';
  elsif (HCLK'event and HCLK = '1') then
    if (WaitCount = WTSTATE_TOUT) then
      CANCELSMWAIT <= '1';
    else
      CANCELSMWAIT <= '0';
    end if;
  end if;
end process p_CanSMWAITComb;

-- -----------------------------------------------------------------------------
-- Assign local copies of signals to the outputs
-- -----------------------------------------------------------------------------
SMWAIT           <= nSMWAIT xor SelWaitPol;

end behavioural;

-- --================================= End ===================================--
