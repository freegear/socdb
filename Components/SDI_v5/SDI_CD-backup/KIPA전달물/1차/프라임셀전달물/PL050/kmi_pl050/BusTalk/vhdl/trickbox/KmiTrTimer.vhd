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
--  Filename            : KmiTrTimer.vhd,v
--
--  File Revision       : 1.1
--
--  Release Information : PL050-REL1v1
--
-- ---------------------------------------------------------------------------
-- Purpose : This modules samples the input KCLK and DATA signals and 
--           asserts the Contention/Rx signal.
--
-- ---------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

entity KmiTrTimer is
  port  (
        REFCLK      : in  std_logic; -- Reference Clock Input
        BnRES       : in  std_logic; -- APB nKMIRST
        Pulse8MHz   : in  std_logic; -- 8 MHz clock input
        nKMIRST     : in  std_logic; -- KMI nKMIRST
        KDATAIn     : in  std_logic; -- Data Line/RTS
        KCLKIn      : in  std_logic; -- KMI Clock/CTS
        KDATAOut    : in  std_logic; -- TrickBox Data Output
        KCLKOut     : in  std_logic; -- TrickBox Clock Output
        RTS         : out std_logic -- Request to Send
        );
end KmiTrTimer;

-- ---------------------------------------------------------------------------
--
--                        KmiTrTimer
--                        ==========
--
-- ---------------------------------------------------------------------------
--
-- Overview
-- ========
-- This module samples the KCLK line. If the  KCLK line is LOW for more than 
-- 64 us then it asserts the RTS signal at the next edge of KCLK. 
--
-- ---------------------------------------------------------------------------
--
--============================ ARCHITECTURE ==================================
--

architecture behavioural of KmiTrTimer is

-- ----------------------------------------------------------------------------
-- Constant declarations
-- ----------------------------------------------------------------------------
constant WAITCYCLES  : std_logic_vector(9 downto 0):="0111111100";
-- Number of Pulse8MHz to count 64 us.

-- -----------------------------------------------------------------------------
-- Signal declarations
-- -----------------------------------------------------------------------------
signal Counter       : std_logic_vector(9 downto 0); 
-- 64 usec Counter
 
signal NextCounter   : std_logic_vector(9 downto 0); 
-- D-input of Counter
 
signal TimerEn       : std_logic; 
-- This signal enables the counter
 
signal DelayTimerEn  : std_logic; 
-- Delayed version of TimerEn
 
signal LoadTimer     : std_logic; 
-- This causes the Reloading of the Counter
 
signal iRTS          : std_logic; 
-- Internal copy of RTS
 
-- -----------------------------------------------------------------------------
--
-- Main body of code
-- =================
--
-- -----------------------------------------------------------------------------
 
begin

TimerEn   <= (not(KCLKIn) and KCLKOut);
LoadTimer <= (DelayTimerEn and not(TimerEn));
RTS       <= iRTS;

-- ----------------------------------------------------------------------------
-- This process asserts the RTS signal if Counter Value is more then the 
-- value in WAITCYCLES. It remains high for 1 REFCLK period.
-- ----------------------------------------------------------------------------
p_iRTSComb : process (Counter, LoadTimer, KDATAIn) 
begin
  if (LoadTimer = '1') then
    if ((Counter >= WAITCYCLES) and (KDATAIn = '0')) then
      iRTS <= '1';
    else
      iRTS <= '0';
    end if;
  else
    iRTS <= '0';
  end if;
end process p_iRTSComb;
 
-- ----------------------------------------------------------------------------
-- Delayed Version of TimerEn.
-- ----------------------------------------------------------------------------
p_DelayTimerEnSeq : process(REFCLK, BnRES)
begin
  if (BnRES = '0') then
    DelayTimerEn <= '0';
  elsif (REFCLK'event and REFCLK = '1') then
    DelayTimerEn <= TimerEn;
  end if;
end process p_DelayTimerEnSeq;

-- ----------------------------------------------------------------------------
-- Counter is being updated at the positive edge of REFCLK.
-- ----------------------------------------------------------------------------
p_CounterSeq : process(REFCLK, BnRES)
begin
  if (BnRES = '0') then
    Counter <= "0000000000";
  elsif (REFCLK'event and REFCLK = '1') then
    Counter <= NextCounter ;
  end if;
end process p_CounterSeq;

-- ----------------------------------------------------------------------------
-- Counter value is incremented at Pulse8MHz signal.
-- ----------------------------------------------------------------------------
p_NextCounterComb : process(Counter, Pulse8MHz, nKMIRST, TimerEn, LoadTimer)
begin
  if ((not(nKMIRST) or LoadTimer) = '1' ) then
    NextCounter <= "0000000000";
  elsif ((Pulse8Mhz and TimerEn) = '1') then
    NextCounter <= unsigned(Counter) + 1;
  else
    NextCounter <= Counter;
  end if;
end process p_NextCounterComb;    

end behavioural;

--============================= End of KmiTrTimer ============================
