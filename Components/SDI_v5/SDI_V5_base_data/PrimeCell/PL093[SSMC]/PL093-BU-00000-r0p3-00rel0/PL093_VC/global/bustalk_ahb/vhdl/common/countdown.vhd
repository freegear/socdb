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
-- File Name              : countdown.vhd.rca
-- File Revision          : 1.1
--
-- Release Information    : PrimeCell(TM)-GLOBAL-REL1v7
--
-- ---------------------------------------------------------------------
-- Purpose :
--           To downcount from the loaded value 'Val' to '1' or '0'
--
-- --=================================================================--

library IEEE;
use     IEEE.std_logic_1164.all;
use     IEEE.std_logic_arith.all;
library common;
use     common.defs.all;

-- ---------------------------------------------------------------------

entity countdown is
  port(
       HCLK  : in std_logic;
       -- the main system clock
       Val   : in T_int;
       -- signal which loads its value on 'last' at -ive edge of clock
       -- for counting down to 0
       Rscyc : in  std_logic;
       -- Denotes Retry/Split cycle
       last : out T_int
       -- signal which counts down from 'Val' to 1
      );
end countdown;

-- ---------------------------------------------------------------------
--
--                             countdown
--                             =========
--
-- ---------------------------------------------------------------------
--
-- Overview
-- ========
--   This block counts from value down to 0, sending its last signal
-- high when the value is 1. Decided against flagging zero, so that we
-- have two edges to work with (can see 0 by falling edge of last).
-- Because of the flag on 1, there has to be two physical counters in
-- this unit for the case when a stream of 1's are loaded. It seems a
-- bit complex, but has the functionality needed.
-- 
-- --========================== ARCHITECTURE =========================--
 
architecture behavioural of countdown is

-- ---------------------------------------------------------------------
-- Signal declarations
-- ---------------------------------------------------------------------
signal Val0   : T_int := 0;
-- value to be loaded on counter-1 for downcounting

signal Val1   : T_int := 0;
-- value to be loaded on counter-2 for downcounting

signal Value0 : T_int := 0;
-- output of counter-1, which is reflected in the signal 'last'

signal Value1 : T_int := 0;
-- output of counter-2, which is reflected in the signal 'last'

signal CntSel : integer range 0 to 1 := 0;
-- signal deciding which counter (counter-1 or counter-2) will be
-- counting next and whose output should be presently reflected in
-- the signal 'last'

-- ---------------------------------------------------------------------
--
-- Main body of code
-- =================
--
-- ---------------------------------------------------------------------

begin

-- ---------------------------------------------------------------------
-- This block 'routes' the proper output (either counter-1 or counter-2)
-- to the 'last' signal
-- ---------------------------------------------------------------------
p_output : process (HCLK, Value0, Value1)
begin
  case CntSel is
    when 1 =>
      last <= Value0;
    when 0 =>
      last <= Value1;
  end case;
end process p_output;

-- ---------------------------------------------------------------------
-- This block loads 'Val' either to Val0 or to Val1 on the basis of
-- CntSel
-- ---------------------------------------------------------------------
p_loader : process (Val, HCLK)
begin
  if (HCLK = '0') then
    case Val is
      when 0 =>
        case CntSel is
          when 1 =>
            Val0 <= 0;
          when 0 =>
            Val1 <= 0;
        end case;
      when others =>
        case CntSel is
          when 1 =>
            Val1 <= Val;
            Val0 <= 0;
          when 0 =>
            Val0 <= Val;
            Val1 <= 0;
        end case;
    end case;
  end if;
end process p_loader;

-- ---------------------------------------------------------------------
-- This block toggles the value of CntSel which in turn determines the
-- counter that will do the downcounting next.
-- ---------------------------------------------------------------------
p_inmux : process (HCLK, Val)
begin
  if (Val /= 0) and rising_edge(HCLK) and Rscyc /= '1' then
    case CntSel is
      when 1 =>
        CntSel <= 0;
      when 0 =>
        CntSel <= 1;
    end case;
  end if;
end process p_inmux;

-- ---------------------------------------------------------------------
-- These are two neg. edge triggered down counters which load non zero
-- values from their input and count to zero.
-- ---------------------------------------------------------------------
p_dec0 : process (HCLK, Value0, Val0)
begin
  if (Rscyc = '1' and HCLK'event and HCLK = '1') then
    if (Cntsel = 1) then
      Value0 <= 1;
    else
      Value0 <= 0;
    end if;
  elsif rising_edge(HCLK) then
    if (Value0 = 0) and (Val0 /= 0) then
      Value0 <= Val0;
    elsif (Value0 /= 0) then
      Value0 <= Value0 - 1;
    else
      Value0 <= 0;
    end if;
  end if;
end process p_dec0;

p_dec1 : process (HCLK, Value1, Val1)
begin
  if (Rscyc = '1' and HCLK'event and HCLK = '1') then
    if (Cntsel = 1) then
      Value1 <= 0;
    else
      Value1 <= 1;
    end if;
  elsif rising_edge(HCLK) then
    if (Value1 = 0) and (Val1 /= 0) then
      Value1 <= Val1;
    elsif (Value1 /= 0) then
      Value1 <= Value1 - 1;
    else
      Value1 <= 0;
    end if;
  end if;
end process p_dec1;

end behavioural;

-- --============================= END ===============================--
