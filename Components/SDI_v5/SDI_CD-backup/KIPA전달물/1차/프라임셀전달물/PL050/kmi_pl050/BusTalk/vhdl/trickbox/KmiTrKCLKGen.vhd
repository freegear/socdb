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
--  Filename            : KmiTrKCLKGen.vhd,v
--
--  File Revision       : 1.1
--
--  Release Information : PL050-REL1v1
--
--  ----------------------------------------------------------------------------
--  Purpose : This block generates the KCLK clock. 
--
--  --------------------------------------------------------------------------- 

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

entity KmiTrKCLKGen is
  port (
       BnRES        : in  std_logic; -- APB Reset
       KmiTrCLKL    : in  std_logic_vector(8 downto 0); -- Low clock time
       KmiTrCLKH    : in  std_logic_vector(8 downto 0); -- High clock time
       REFCLK       : in  std_logic; -- Reference Clock
       Pulse8MHz    : in  std_logic; -- 8 MHz signal
       CLKEn        : in  std_logic; -- Clock Hold/Enable
       CurrentState : in std_logic_vector(1 downto 0); -- Current State Input
       KCLK         : out std_logic -- Clock output
       );
end KmiTrKCLKGen;

-- ---------------------------------------------------------------------------- 
--
--                      KmiTrKCLKGen
--                      ============
--
-- ----------------------------------------------------------------------------
--
-- Overview
-- ========
-- This module generates the KCLK for Recieve/Transmit operation.
-- This Clock will be outputted on the KCLKOut line during. Clock Low time 
-- and High time is programmable. KCLK will be generated only when CLKEn is
-- High.
--
-- ----------------------------------------------------------------------------
--
-- ============================== ARCHITECTURE ==============================--
 
architecture behavioural of KmiTrKCLKGen  is

-- ----------------------------------------------------------------------------
-- Signal declarations
-- ----------------------------------------------------------------------------
signal Counter     : std_logic_vector(8 downto 0); 
-- Internal Counter

signal NextCounter : std_logic_vector(8 downto 0); 
-- D-Input for Counter

signal NextKCLK    : std_logic; 
-- D-input for iKCLK

signal iKCLK       : std_logic; 
-- Internal Copy of KCLK

-- -----------------------------------------------------------------------------
--
-- Main body of code
-- =================
--
-- -----------------------------------------------------------------------------

begin

-- ----------------------------------------------------------------------------
-- This module generate the NextCounter. The value loaded in the NextCounter
-- will be KmiTrCLKL or KmiTrCLKH depending on the present condition on the
-- KCLK line. Counter is being decremented at every Pulse8MHz signal.
-- ----------------------------------------------------------------------------
p_NextCounterComb : process (Counter, CLKEn, Pulse8MHz, iKCLK, KmiTrCLKL, 
                            KmiTrCLKH)
begin
  if ((Counter = "000000000") or (CLKEn = '0')) then
    if (iKCLK = '1') then
      NextCounter <= KmiTrCLKL;
    else
      NextCounter <= KmiTrCLKH;
    end if;
  elsif ((Pulse8MHz and CLKEn) = '1') then
    NextCounter <= unsigned(Counter) - 1;
  else
    NextCounter <= Counter;  
  end if;
end process p_NextCounterComb;

-- ----------------------------------------------------------------------------
-- This process updates the value of Counter at the positive edge of REFCLK.
-- ----------------------------------------------------------------------------
p_CounterSeq : process (REFCLK, BnRES)
begin
  if (BnRES = '0') then
    Counter <= "000000000";
  elsif (REFCLK'event and REFCLK = '1') then
    Counter <= NextCounter;
  end if;
end process p_CounterSeq;
   
-- In the Idle State NextKCLK will be pulled low. Otherwise it is being
-- toggled whenever Counter value reaches to zero.
NextKCLK <= '0' when CurrentState = "00" 
         else 
            not(iKCLK) when Counter = "000000000" 
         else
            iKCLK;

-- ----------------------------------------------------------------------------
-- iKCLK is being updated at the positive edge of REFCLK.
-- ----------------------------------------------------------------------------
p_iKCLKSeq : process (BnRES, REFCLK)
begin
  if (BnRES = '0') then
    iKCLK <= '1';
  elsif (REFCLK'event and REFCLK = '1') then
    iKCLK <= NextKCLK;
  end if;
end process p_iKCLKSeq;

KCLK <= iKCLK;
   
end behavioural;

-- =========================== End Of KmiTrKCLKGen ========================--
