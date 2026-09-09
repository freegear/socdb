--  ----------------------------------------------------------------------------
--  This confidential and proprietary software may be used only
--  as authorised by a licensing agreement from ARM Limited
--  (C) COPYRIGHT 1998 ARM Limited
--  ALL RIGHTS RESERVED
--  The entire notice above must be reproduced on all authorised copies
--  and copies may only be made to the extent permitted by a
--  licensing agreement from ARM Limited.
--  ----------------------------------------------------------------------------
--
--  Version and Release Control Information :
--
--
--  Filename            : KmiTrDataWidth.vhd,v
--
--  File Revision       : 1.1
--
--  Release Information : PL050-REL1v1
--
-- ----------------------------------------------------------------------------
-- Purpose : This module measures the different timing parameters and 
--           asserts the corresponding Error Signals.
--
-- ----------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

entity KmiTrDataWidth is
  port (
        BnRES         : in  std_logic; -- APB Reset 
        KmiTrCLKL     : in  std_logic_vector(8 downto 0); -- Low clock time
        KmiTrCLKH     : in  std_logic_vector(8 downto 0); -- High clock time
        REFCLK        : in  std_logic; -- Reference Clock
        Pulse8MHz     : in  std_logic; -- 8 MHz signal
        WrenSTAT      : in  std_logic; -- Status Register Write Enable 
        KDATAIn       : in  std_logic; -- Data Input from PAD 
        KDATAOut      : in  std_logic; -- Data Output to PAD
        WidthMsrEn    : in  std_logic; -- Data Width Measurement Enable
        KCLKOut       : in  std_logic; -- Clock Output to the PAD
        WrenTIMESTAT  : in  std_logic; -- Time Status Register Write Enable
        BitCount      : in  std_logic_vector(3 downto 0); -- Bit Counter Value
        KmiTrDSO      : in  std_logic_vector(15 downto 0); -- Setup Timing
        KmiTrDHO      : in  std_logic_vector(15 downto 0); -- Hold Timing
        CurrentState  : in  std_logic_vector(1 downto 0); -- Current State
        PWDATAIN      : in  std_logic_vector(15 downto 0); -- APB Data Input
        TdsoErr       : out std_logic; -- DSO Timing Error
        TdhoErr       : out std_logic; -- DHO Timing Error
        KmiTrDWIDTHERR: out std_logic -- Data Width Error 
        );
end KmiTrDataWidth;

-- ----------------------------------------------------------------------------
--
--                             KmiTrDataWidth
--                             ==============
--
-- ----------------------------------------------------------------------------
--
-- Overview
-- ========
-- This module checks the data signal for different timing parameters. 
-- An internal counter has been implemented for Data Width measurement 
-- test. It  takes the Clock line and Data line for testing the setup 
-- and hold timing parameters. The Error signals can be cleared by 
-- writing '1' to the corresponding location in Status register.  
--
-- ----------------------------------------------------------------------------
--
-- ========================== ARCHITECTURE ==================================--

architecture behavioural of KmiTrDataWidth is

-- ----------------------------------------------------------------------------
-- Function Definition : to_integer
-- ----------------------------------------------------------------------------
 function to_integer( arg: std_logic_vector(15 downto 0)) return integer is
  variable OutVal : integer := 0;
  begin
   if(arg = "UUUUUUUUUUUUUUUU") then
     OutVal := 0;
   else
     OutVal := CONV_INTEGER(unsigned(arg));
   end if;
   return OutVal;
 end;

-- ----------------------------------------------------------------------------
-- Constant declarations 
-- ----------------------------------------------------------------------------
constant MARGIN    : std_logic_vector(9 downto 0) := "0000000011";
-- This is the tolerance in the Data Width Measurement. 

constant TIMEMARGIN: time := 1 ns;
-- Tolerance for DSO and DHO time test.

-- ----------------------------------------------------------------------------
-- Signal declarations
-- ----------------------------------------------------------------------------
signal Counter        : std_logic_vector(9 downto 0); 
-- Counter for Data Width measurement
      
signal NextCounter    : std_logic_vector(9 downto 0); 
-- D-Input for The Counter

signal DelayData      : std_logic; 
-- Delayed version of Data Line

signal ValidData      : std_logic; 
-- Combination of KDATAOut and KDATAIn
 
signal DataPulse      : std_logic; 
-- Indicates the edge on the ValidData signal

signal DelayDataPulse : std_logic; 
-- Delayed DataPulse for loading of Counter 
 
signal ExpWidthMin    : std_logic_vector(9 downto 0); 
-- Expected Minimum Data Width
 
signal ExpWidthMax    : std_logic_vector(9 downto 0); 
-- Expected Maximum Data Width
 
signal CounterEn      : std_logic; 
-- Internal Counter Enable signal
 
signal Tdso           : time; 
-- DSO time
 
signal Tdho           : time; 
-- DHO time
 
signal TdhoEn         : std_logic; 
-- DSO time test enable
 
signal TdsoEn         : std_logic; 
-- DHO time test enable

signal DelayKCLK      : std_logic; 
-- Delayed version of KCLKOut

-- -----------------------------------------------------------------------------
--
-- Main body of code
-- =================
--
-- -----------------------------------------------------------------------------

begin
 
Tdso <= to_integer(KmiTrDSO) * 1 ns - TIMEMARGIN;
Tdho <= to_integer(KmiTrDHO) * 1 ns - TIMEMARGIN;

ValidData   <= '1' when KDATAOut = '0' 
            else
               KDATAIn;

-- ----------------------------------------------------------------------------
-- Data Line is delayed by one REFCLK for generating the DataPulse.
-- ----------------------------------------------------------------------------
p_DelayDataSeq : process (REFCLK, BnRES)
begin
  if (BnRES = '0') then
    DelayData <= '0';
  elsif (REFCLK'event and REFCLK = '1') then
    DelayData <= ValidData;
  end if;
end process p_DelayDataSeq;

-- ----------------------------------------------------------------------------
-- Data Pulse is being generated with REFCLK.
-- ----------------------------------------------------------------------------
p_DataPulseSeq : process (REFCLK, BnRES)
begin
  if (BnRES = '0') then
    DataPulse <= '0';
  elsif (REFCLK'event and REFCLK = '0') then
    DataPulse <= ValidData xor DelayData;
  end if;
end process p_DataPulseSeq;

-- ----------------------------------------------------------------------------
-- DelayData Pulse is being generated with REFCLK.
-- ----------------------------------------------------------------------------
p_DelayDataPulseSeq : process (REFCLK, BnRES)
begin
  if (BnRES = '0') then
    DelayDataPulse <= '0';
  elsif (REFCLK'event and REFCLK = '0') then
    DelayDataPulse <= DataPulse;
  end if;
end process p_DelayDataPulseSeq;

-- ----------------------------------------------------------------------------
-- Clock is being delayed by one REFCLK.
-- ----------------------------------------------------------------------------
p_DelayKCLKSeq : process (REFCLK, BnRES)
begin
  if (BnRES = '0') then
    DelayKCLK <= '0';
  elsif (REFCLK'event and REFCLK = '0') then
    DelayKCLK <= KCLKOut;
  end if;
end process p_DelayKCLKSeq;

-- ----------------------------------------------------------------------------
-- DHO measurement
--
-- This process generate the DHO time window. TdhoEn will be asserted at the 
-- negative edge of KCLKOut and remain high for the Tdho time. During this 
-- window, there must not be any change on KDATAIn.
--
-- ----------------------------------------------------------------------------
p_TdhoComb : process (DelayKCLK, BnRES, TdhoEn)
begin
  if (BnRES = '0') then
    TdhoEn <= '0';
  elsif (DelayKCLK'event and  DelayKCLK = '0') then
    TdhoEn <= '1';
  elsif (TdhoEn = '1') then
    TdhoEn <= '0' after Tdho;
  end if;
end process p_TdhoComb;
 
-- ----------------------------------------------------------------------------
-- If DataPulse is being asserted during TdhoEn High, TdhoErr will be set.
-- It can be cleared by writing one to corresponding location.
-- ----------------------------------------------------------------------------
p_TdhoErrComb : process (TdhoEn, BnRES, DataPulse, PWDATAIN)
begin
  if (BnRES = '0') then
    TdhoErr <= '0';
  elsif ((WrenTIMESTAT and PWDATAIN(0)) = '1') then
    TdhoErr <= '0';
  elsif ((DataPulse and TdhoEn) = '1') then
    assert false report 
    "DHO Timing Error" 
    severity error;
    TdhoErr <= '1';
  end if;
end process p_TdhoErrComb;

-- ----------------------------------------------------------------------------
-- DSO measurement
--
-- The TdsoEn signal will be asserted with the event on the KDATAIn. It will
-- remain high for the Tdso time. During this period there must not be any 
-- activity on the KCLKIn line.
--
-- ----------------------------------------------------------------------------
p_TdsoComb : process (DataPulse, BnRES, TdsoEn)
begin
  if (BnRES = '0') then
    TdsoEn <= '0';
  elsif ((DataPulse = '1') and (CurrentState = "01")) then
    TdsoEn <= '1';
  elsif (TdsoEn = '1') then
    TdsoEn <= '0' after Tdso;
  end if;
end process p_TdsoComb;
 
-- ----------------------------------------------------------------------------
-- If there is some event on KCLK line during TdsoEn High, TdsoErr will be set.
-- It can be cleared by writing one to corresponding location.
-- ----------------------------------------------------------------------------
p_TdsoErrComb : process (TdsoEn, BnRES, KCLKOut, PWDATAIN)
begin
  if (BnRES = '0') then
    TdsoErr <= '0';
  elsif ((WrenTIMESTAT and PWDATAIN(1)) = '1') then
    TdsoErr <= '0';
  elsif ((DelayKCLK and TdsoEn) = '1') then
    assert false report 
    "DSO Timing Error" 
    severity note;
    TdsoErr <= '1';
  end if;
end process p_TdsoErrComb;

-- ----------------------------------------------------------------------------
-- Counter for Data Width Measurement
--
-- This counter is being incremented at Pulse8MHz. This counter is being 
-- reloaded at the next edge on the KDATAIn line.
-------------------------------------------------------------------------------
p_NextCounterComb : process (Counter, Pulse8MHz, DelayDataPulse, CounterEn)
begin
  if ((DelayDataPulse or not(CounterEn)) = '1') then
    NextCounter <= "0000000000";
  elsif ((Pulse8MHz and CounterEn) = '1') then
    NextCounter <= unsigned(Counter) + 1;
  else
    NextCounter <= Counter;
  end if;
end process p_NextCounterComb;

-- ----------------------------------------------------------------------------
-- Counter Upadate with every positive edge of REFCLK
-- ----------------------------------------------------------------------------
p_CounterSeq : process (REFCLK, BnRES)
begin
  if (BnRES = '0') then
    Counter <= "0000000000";
  elsif (REFCLK'event and REFCLK = '1') then
    Counter <= NextCounter;
  end if;
end process p_CounterSeq;

-- ----------------------------------------------------------------------------
-- Data Width Measurement
-- ----------------------------------------------------------------------------
ExpWidthMin <= unsigned(KmiTrCLKL) + unsigned(KmiTrCLKH) - unsigned(MARGIN);

ExpWidthMax <= unsigned(KmiTrCLKL) + unsigned(KmiTrCLKH) + unsigned(MARGIN);

CounterEn   <= '1' when((CurrentState = "01") and (WidthMsrEn = '1')) 
            else
               '0';

-- ----------------------------------------------------------------------------
-- When DataPulse is there, Counter value must be between the ExpWidthMin 
-- and ExpWidthMax. If it is not, DWIDTHERR will be asserted. It can be 
-- cleared by writing one to the corresponding location.
-- ----------------------------------------------------------------------------
p_DWIDTHERRComb : process (Counter, WrenSTAT, DataPulse, CounterEn, PWDATAIN, 
                          BnRES)
begin
  if (BnRES = '0') then
    KmiTrDWIDTHERR <= '0';
  elsif ((WrenSTAT and PWDATAIN(5)) = '1') then
    KmiTrDWIDTHERR <= '0';
  elsif ((BitCount > "0000") and (BitCount < "1001")) then
    if ((DataPulse and CounterEn) = '1') then 
      if ((Counter < ExpWidthMin) or (Counter > ExpWidthMax)) then 
        KmiTrDWIDTHERR <= '1';
      end if;
    end if;
  end if;
end process p_DWIDTHERRComb;
 
end behavioural;

-- ======================== End Of KmiTrDataWidth ===========================--
