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
--  Filename             : $RCSfile :  $
--
--  File Revision        : $Revision : $
--
--  Release Information  : $State : $
--
-- ----------------------------------------------------------------------------
-- Purpose  : This block implements the 4-bit Bit Counter clocked by the
--           KCLK input whenever CounterEn is HIGH. It keeps track of the 
--           number of bits transmitted or received. The Bit Counter can be 
--           reset by deasserting CounterEn signal.
--
-- ---------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

entity KmiTrBitCounter is
  port (
        BnRES       : in  std_logic; -- APB Reset
        KCLK        : in  std_logic; -- Counter Clock
        CounterEn   : in  std_logic; -- Counter Enable Signal
        BitCount    : out std_logic_vector(3 downto 0) -- Bit Count Output
        );
end KmiTrBitCounter;

-- ---------------------------------------------------------------------------
--
--                          KmiTrBitCounter
--                          ===============
--
-- ---------------------------------------------------------------------------
--
-- Overview
-- ========
-- This block contains a free running 4-bit counter. It counts up by 1 at the 
-- positive edge of KCLK while the CounterEn is HIGH. The BitCounter also 
-- goes as input to the KmiTrController state machine.
--
-- ---------------------------------------------------------------------------
--
-- ======================= ARCHITECTURE ====================================--

architecture behavioural of KmiTrBitCounter  is 

--------------------------------------------------------------------------------
-- Signal Declarations
--------------------------------------------------------------------------------
signal Counter      : std_logic_vector(3 downto 0);
-- Internal Bit Counter 

signal NextCounter  : std_logic_vector(3 downto 0); 
-- D-Input for Bit Counter

-- ----------------------------------------------------------------------------
--
-- Main body of code
-- =================
--
-- ----------------------------------------------------------------------------
 
begin

BitCount <= Counter;

NextCounter <= "0000" when CounterEn = '0' 
            else
               (unsigned(Counter) + 1);

p_CounterComb : process (KCLK, BnRES, CounterEn)
begin
  if (BnRES  = '0') then
    Counter <= "0000";
  elsif (CounterEn = '0') then
    Counter <= "0000";
  elsif (KCLK'event and KCLK = '1') then
    Counter <= NextCounter;
  end if;
end process p_CounterComb;

end behavioural;

-- ===================== End of KmiTrBitCounter =============================--
