-- --=========================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 2003 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
--
-- -----------------------------------------------------------------------------
-- Version and Release Control Information:
--
-- File Name              : SsmcTrWaitCntl.vhd.rca
-- File Revision          : 1.8
--
-- Release Information    : PrimeCell(TM)-PL093-r0p3-00rel0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           This module routes the SMWAIT signal and asserts the CANCELSMWAIT
--           signal when the SMWAIT signal gets timed-out.
--           
--
-- --=========================================================================--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

-- -----------------------------------------------------------------------------
entity SsmcTrWaitCntl is

  generic (
           Tclk : time :=7.51 ns
          );
  port (
-- Inputs
        -- AHB bus signals
        SMMemCLK         : in    std_logic; -- Memory clock
        HRESETn          : in    std_logic; -- Bus Reset
        nSSMCS           : in    std_logic_vector(7 downto 0);
                                            -- Active low Memory Bank Select
        SMADDR           : in    std_logic_vector(25 downto 0);
                                            -- External Address Bus   
        SSMCTrCS2WTR0    : in    std_logic_vector(11 downto 0);
                                            -- CS-SSMCTrnWAIT assertion delay
                                            -- for Bank 0
        SSMCTrCS2WTR1    : in    std_logic_vector(11 downto 0);
                                            -- CS-SSMCTrWAIT assertion delay
                                            -- for Bank 1
        SSMCTrCS2WTR2    : in    std_logic_vector(11 downto 0);
                                            -- CS-SSMCTrWAIT assertion delay
                                            -- for Bank 2
        SSMCTrCS2WTR3    : in    std_logic_vector(11 downto 0);
                                            -- CS-SSMCTrWAIT assertion delay
                                            -- for Bank 3
        SSMCTrCS2WTR4    : in    std_logic_vector(11 downto 0);
                                            -- CS-SMCTrWAIT assertion delay
                                            -- for Bank 4
        SSMCTrCS2WTR5    : in    std_logic_vector(11 downto 0);
                                            -- CS-SMCTrWAIT assertion delay
                                            -- for Bank 5
        SSMCTrCS2WTR6    : in    std_logic_vector(11 downto 0);
                                            -- CS-SMCTrWAIT assertion delay
                                            -- for Bank 6
        SSMCTrCS2WTR7    : in    std_logic_vector(11 downto 0);
                                            -- CS-SMCTrWAIT assertion delay
                                            -- for Bank 7
        SSMCTrWTCNCL     : in    std_logic_vector(8 downto 0);
                                            -- CANCELSMWAIT assertion delay
        SMMemClkRatio    : in    std_logic_vector(1 downto 0);
                                            -- Clock Ratio;
-- Outputs
        SMWAIT           : out   std_logic; -- External Wait signal routed to
                                            -- the SMC
        SMCANCELWAIT     : out   std_logic
                                            -- External Wait time out signal
       );
end SsmcTrWaitCntl;
-- -----------------------------------------------------------------------------
--
--                                SsmcTrWaitCntl
--                                ==============
--
-- -----------------------------------------------------------------------------
--
-- Overview
-- ========
-- SSMC Tricbox is an AHB slave. This block performs the following operations:
--   - Routes the SMWAIT signal according to the selected Memory Bank.
--   - Asserts the CANCELSMWAIT signal when the SMWAIT signal gets timed out.
--
-- -----------------------------------------------------------------------------

-- --============================ ARCHITECTURE ===============================--

architecture behavioural of SsmcTrWaitCntl is

-- -----------------------------------------------------------------------------
-- Component declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Constant declarations
-- -----------------------------------------------------------------------------
-- constant WTSTATE_TOUT    : unsigned(4 downto 0) := "11111";
-- External Wait time-out count

-- -----------------------------------------------------------------------------
-- Signal declarations
-- -----------------------------------------------------------------------------
signal SMWAIT4In        : std_logic :='1';
-- Internal version of the SMWAIT (Active Low) 

signal DelSMADDR        : std_logic_vector(25 downto 0);
-- Delayed SMADDR

signal SelWaitPol       : std_logic := '0';
-- The Wait Polarity of the Selected Memory

signal WaitEn           : std_logic_vector(7 downto 0);
-- The Wait Enable of the Memory Banks

signal WaitPol          : std_logic_vector(7 downto 0);
-- The Wait Polarity of the Memory Banks

signal WaitCount        : unsigned(6 downto 0) := "0000000";
-- external wait state counter.

signal IntWaitCount     : time := 0 ns;
-- External Wait State Counter in time format

signal IntCS2WTR0       : time := 0 ns;
-- Memory Chip Select to SMWAIT assertion delay time for Bank 0

signal IntWT2DeWTR0     : time := 0 ns;
-- SMWAIT assertion to de-assertion delay time for Bank 0

signal IntCS2WTR1       : time := 0 ns;
-- Memory Chip Select to SMWAIT assertion delay time for Bank 1

signal IntWT2DeWTR1     : time := 0 ns;
-- SMWAIT assertion to de-assertion delay time for Bank 1

signal IntCS2WTR2       : time := 0 ns;
-- Memory Chip Select to SMCWAIT assertion delay time for Bank 2

signal  IntWT2DeWTR2    : time := 0 ns;
-- SMWAIT assertion to de-assertion delay time for Bank 2

signal IntCS2WTR3       : time := 0 ns;
-- Memory Chip Select to SMWAIT assertion delay time for Bank 3

signal  IntWT2DeWTR3    : time := 0 ns;
-- SMWAIT assertion to de-assertion delay time for Bank 3

signal IntCS2WTR4       : time := 0 ns;
-- Memory Chip Select to SMWAIT assertion delay time for Bank 4

signal  IntWT2DeWTR4    : time := 0 ns;
-- SMWAIT assertion to de-assertion delay time for Bank 4

signal IntCS2WTR5       : time := 0 ns;
-- Memory Chip Select to SMWAIT assertion delay time for Bank 5

signal  IntWT2DeWTR5    : time := 0 ns;
-- SMWAIT assertion to de-assertion delay time for Bank 5

signal IntCS2WTR6       : time := 0 ns;
-- Memory Chip Select to SMWAIT assertion delay time for Bank 6

signal  IntWT2DeWTR6    : time := 0 ns;
-- SMWAIT assertion to de-assertion delay time for Bank 6

signal IntCS2WTR7       : time := 0 ns;
-- Memory Chip Select to SMWAIT assertion delay time for Bank 7

signal  IntWT2DeWTR7    : time := 0 ns;
-- SMCTrWAIT assertion to de-assertion delay time for Bank 7

signal IntTOUT          : time := 32 * Tclk;
-- Time out period for the External Wait transfer, this will assert CANCELSMWAIT

signal TOUT          : unsigned(6 downto 0);
-- Time out value for the External Wait transfer, this will assert CANCELSMWAIT

signal SMWAITIgnore     : std_logic;
-- This is to ignore SMWAIT signal for SMCANCELWAIT assertion 

signal SMCnclEn         : std_logic;
-- This is to put SMCANCELWAIT signal masked

signal ClkFactor        : integer range 1 to 3 := 1;
-- Multiplying factor for Clock duration
 
-- -----------------------------------------------------------------------------
-- Function declarations
-- -----------------------------------------------------------------------------
-- -----------------------------------------------------------------------------
-- ToTime
-- -------
-- This function converts the integer input argument into time and returns the 
-- time value.
-- -----------------------------------------------------------------------------
function ToTime (val :integer)
return time is
variable Temp : time;
variable Temp1 : integer;
variable Temp2 : time;
begin
  Temp1 := val;
  Temp2 := 1 * Tclk;
  Temp := Temp1 * Temp2;
  return Temp;
end ToTime;
-- -----------------------------------------------------------------------------
-- ToInteger
-- ---------
-- This function converts the std_logic_vector input argument into integer
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
-- -----------------------------------------------------------------------------

begin

-- -----------------------------------------------------------------------------
-- ClkFactor determination
-- -----------------------------------------------------------------------------
p_ClkFactorComb : process (SMMemClkRatio)
begin
  case SMMemClkRatio is
    when "00" =>
      ClkFactor <= 1;
    when "01" =>
      ClkFactor <= 2;
    when "10" =>
      ClkFactor <= 3;
    when others =>
      ClkFactor <= 1;
  end case;
end process p_ClkFactorComb; 

-- -----------------------------------------------------------------------------
-- SSMCTrCS2WT Register field rename
-- -----------------------------------------------------------------------------
WaitEn           <= SSMCTrCS2WTR7(11) & SSMCTrCS2WTR6(11) & SSMCTrCS2WTR5(11) &
                    SSMCTrCS2WTR4(11) & SSMCTrCS2WTR3(11) & SSMCTrCS2WTR2(11) &
                    SSMCTrCS2WTR1(11) & SSMCTrCS2WTR0(11);

WaitPol          <= SSMCTrCS2WTR7(10) & SSMCTrCS2WTR6(10) & SSMCTrCS2WTR5(10) &
                    SSMCTrCS2WTR4(10) & SSMCTrCS2WTR3(10) & SSMCTrCS2WTR2(10) &
                    SSMCTrCS2WTR1(10) & SSMCTrCS2WTR0(10);

-- -----------------------------------------------------------------------------
-- Converting std_logic_vector to time.
-- -----------------------------------------------------------------------------
IntWT2DeWTR0     <= ToInteger(SSMCTrCS2WTR0(4 downto 0)) * ClkFactor * Tclk;
IntWT2DeWTR1     <= ToInteger(SSMCTrCS2WTR1(4 downto 0)) * ClkFactor * Tclk;
IntWT2DeWTR2     <= ToInteger(SSMCTrCS2WTR2(4 downto 0)) * ClkFactor * Tclk;
IntWT2DeWTR3     <= ToInteger(SSMCTrCS2WTR3(4 downto 0)) * ClkFactor * Tclk;
IntWT2DeWTR4     <= ToInteger(SSMCTrCS2WTR4(4 downto 0)) * ClkFactor * Tclk;
IntWT2DeWTR5     <= ToInteger(SSMCTrCS2WTR5(4 downto 0)) * ClkFactor * Tclk;
IntWT2DeWTR6     <= ToInteger(SSMCTrCS2WTR6(4 downto 0)) * ClkFactor * Tclk;
IntWT2DeWTR7     <= ToInteger(SSMCTrCS2WTR7(4 downto 0)) * ClkFactor * Tclk;

IntCS2WTR0       <= ToInteger(SSMCTrCS2WTR0(9 downto 5)) * ClkFactor * Tclk;
IntCS2WTR1       <= ToInteger(SSMCTrCS2WTR1(9 downto 5)) * ClkFactor * Tclk;
IntCS2WTR2       <= ToInteger(SSMCTrCS2WTR2(9 downto 5)) * ClkFactor * Tclk;
IntCS2WTR3       <= ToInteger(SSMCTrCS2WTR3(9 downto 5)) * ClkFactor * Tclk;
IntCS2WTR4       <= ToInteger(SSMCTrCS2WTR4(9 downto 5)) * ClkFactor * Tclk;
IntCS2WTR5       <= ToInteger(SSMCTrCS2WTR5(9 downto 5)) * ClkFactor * Tclk;
IntCS2WTR6       <= ToInteger(SSMCTrCS2WTR6(9 downto 5)) * ClkFactor * Tclk;
IntCS2WTR7       <= ToInteger(SSMCTrCS2WTR7(9 downto 5)) * ClkFactor * Tclk;

TOUT             <= unsigned(SSMCTrWTCNCL(6 downto 0));
IntTOUT          <= ToInteger(SSMCTrWTCNCL(6 downto 0))  * ClkFactor * Tclk;

-- -----------------------------------------------------------------------------
-- Generation of Delayed SMADDR
-- -----------------------------------------------------------------------------
DelSMADDR        <= SMADDR after 2 ns;

-- ------------------------------------------------------------------------------- Ignore the SMWAIT signal for the asertion of SMCANCELWAIT signal
-- -----------------------------------------------------------------------------

SMWAITIgnore     <= SSMCTrWTCNCL(7);   
SMCnclEn         <= SSMCTrWTCNCL(8);

-- -----------------------------------------------------------------------------
-- Choose the Wait Polarity of the selected Memory
-- -----------------------------------------------------------------------------
p_WaitPolSelComb : process (SMWAIT4In,nSSMCS)
begin
  if (SMWAIT4In = '1') then
    if (nSSMCS(0) = '0') then
      SelWaitPol <= WaitPol(0);
    elsif (nSSMCS(1) = '0') then
      SelWaitPol <= WaitPol(1);
    elsif (nSSMCS(2) = '0') then
      SelWaitPol <= WaitPol(2);
    elsif (nSSMCS(3) = '0') then
      SelWaitPol <= WaitPol(3);
    elsif (nSSMCS(4) = '0') then
      SelWaitPol <= WaitPol(4);
    elsif (nSSMCS(5) = '0') then
      SelWaitPol <= WaitPol(5);
    elsif (nSSMCS(6) = '0') then
      SelWaitPol <= WaitPol(6);
    elsif (nSSMCS(7) = '0') then
      SelWaitPol <= WaitPol(7);
    end if;
  end if;
end process p_WaitPolSelComb;

-- -----------------------------------------------------------------------------
-- Combinational logic for the Assertion and de-Assertion of the SMWAIT
-- signal
-- -----------------------------------------------------------------------------
p_SMWAITComb : process (nSSMCS, WaitEn,SMWAIT4In, DelSMADDR)
begin
  if (nSSMCS'event or (DelSMADDR'event and DelSMADDR = SMADDR)) then
    if (SMWAIT4In = '1') then
      if (nSSMCS(0) = '0' and WaitEn(0) = '1') then
          SMWAIT4In <= '0' after (IntCS2WTR0 - 3 ns);
      elsif (nSSMCS(1) = '0' and WaitEn(1) = '1') then
          SMWAIT4In <= '0' after (IntCS2WTR1 - 3 ns);
      elsif (nSSMCS(2) = '0' and WaitEn(2) = '1') then
          SMWAIT4In <= '0' after (IntCS2WTR2 - 3 ns);
      elsif (nSSMCS(3) = '0' and WaitEn(3) = '1') then
          SMWAIT4In <= '0' after (IntCS2WTR3 - 3 ns);
      elsif (nSSMCS(4) = '0' and WaitEn(4) = '1') then
          SMWAIT4In <= '0' after (IntCS2WTR4 - 3 ns);
      elsif (nSSMCS(5) = '0' and WaitEn(5) = '1') then
          SMWAIT4In <= '0' after (IntCS2WTR5 - 3 ns);
      elsif (nSSMCS(6) = '0' and WaitEn(6) = '1') then
          SMWAIT4In <= '0' after (IntCS2WTR6 - 3 ns);
      elsif (nSSMCS(7) = '0' and WaitEn(7) = '1') then
          SMWAIT4In <= '0' after (IntCS2WTR7 - 3 ns);
      else
        SMWAIT4In <= '1';
      end if;
    end if;
  elsif (SMWAIT4In = '0') then
       if (nSSMCS(0) = '0' and WaitEn(0) = '1') then
      SMWAIT4In <= '1' after (IntWT2DeWTR0 - 3 ns);
    elsif (nSSMCS(1) = '0' and WaitEn(1) = '1') then
      SMWAIT4In <= '1' after (IntWT2DeWTR1 - 3 ns);
    elsif (nSSMCS(2) = '0' and WaitEn(2) = '1') then
      SMWAIT4In <= '1' after (IntWT2DeWTR2 - 3 ns);
    elsif (nSSMCS(3) = '0' and WaitEn(3) = '1') then
      SMWAIT4In <= '1' after (IntWT2DeWTR3 - 3 ns);
    elsif (nSSMCS(4) = '0' and WaitEn(4) = '1') then
      SMWAIT4In <= '1' after (IntWT2DeWTR4 - 3 ns);
    elsif (nSSMCS(5) = '0' and WaitEn(5) = '1') then
      SMWAIT4In <= '1' after (IntWT2DeWTR5 - 3 ns);
    elsif (nSSMCS(6) = '0' and WaitEn(6) = '1') then
      SMWAIT4In <= '1' after (IntWT2DeWTR6 - 3 ns);
    elsif (nSSMCS(7) = '0' and WaitEn(7) = '1') then
      SMWAIT4In <= '1' after (IntWT2DeWTR7 - 3 ns);
    end if;
  end if;
end process p_SMWAITComb;
-- -----------------------------------------------------------------------------
-- Process to count for the External WAIT time-out
-- -----------------------------------------------------------------------------
p_ExtWAITCntSeq : process (SMMemCLK, HRESETn)
begin
  if (HRESETn = '0') then
    WaitCount <= "0000000";
  elsif (SMMemCLK'event and SMMemCLK = '1') then 
    if (SMWAITIgnore = '1') then
      if (SMWAIT4In = '0' ) then
        if (WaitCount < TOUT) then
          WaitCount    <= WaitCount + 1;
        else
          WaitCount    <= "0000000";
        end if;
      else
          WaitCount    <= "0000000";
      end if;
    elsif (SMWAITIgnore = '0') then
      if (WaitCount  <= TOUT) then
        WaitCount    <= WaitCount + 1;
      else
        WaitCount    <= "0000000";
      end if;
    end if;
  end if;
end process p_ExtWAITCntSeq;

-- -----------------------------------------------------------------------------
-- Process to generate CancelSMWAIT
-- -----------------------------------------------------------------------------
p_CanSMWAITComb : process (WaitCount, HRESETn)
begin
  if (HRESETn = '0') then
      SMCANCELWAIT <= '0';
  elsif ((WaitCount = TOUT) and (SMCnclEn = '1')) then  
      SMCANCELWAIT <= '1';
  else
      SMCANCELWAIT <= '0';
  end if;
end process p_CanSMWAITComb;

-- -----------------------------------------------------------------------------
-- Assign local copies of signals to the outputs
-- -----------------------------------------------------------------------------
SMWAIT           <= SMWAIT4In xor SelWaitPol;

end behavioural;

-- --================================= End ===================================--

    
