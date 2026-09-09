-- --=========================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 1999 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
-- 
-- -----------------------------------------------------------------------------
-- Version and Release Control Information:
-- 
-- File Name           : countdown.vhd,v 
-- File Revision       : 1.2 
-- 
-- Release Information : PL160-REL1v1 
-- 
-- -----------------------------------------------------------------------------
-- Purpose             : To count from value down to 0, sending its last signal
--                       high when the value is 1.  Decided against flagging
--                       zero, so that we have two edges to work with (can see 0
--                       by falling edge of last).  Because of the flag on 1,
--                       there has to be two physical counters in this unit for
--                       the case when a stream of 1's are loaded. It seems a
--                       bit complex, but has the functionality needed.
-- 
-- --=========================================================================--

library ieee;
use     ieee.std_logic_1164.all;

library common;
use     common.defs.all;

entity countdown is
  port(
       BCLK       : in std_logic;
       Val        : in T_int;
       last       : out T_int
       );
end countdown;

architecture behavioural of countdown is
                  
  signal Val0     : T_int := 0;
  signal Val1     : T_int := 0;
  signal Value0   : T_int := 0;
  signal Value1   : T_int := 0;
  signal cnt_sel  : integer range 0 to 1 := 0;
begin

  output : process (BCLK,Value0,Value1)
  begin
    case cnt_sel is
      when 1 => last <= Value0;
      when 0 => last <= Value1;
    end case;
  end process;

  loader : process (Val,BCLK)
  begin
    if (BCLK = '1') then
      case Val is
        when 0 =>
          case cnt_sel is
            when 1 =>
              Val0 <= 0;
            when 0 =>
              Val1 <= 0;
          end case;
        when others =>
          case cnt_sel is
            when 1 =>
              Val1 <= Val;
              Val0 <= 0;
            when 0 =>
              Val0 <= Val;
              Val1 <= 0;
          end case;
      end case;
    end if;
  end process;

  inmux : process (BCLK,Val)
  begin
    if (Val /= 0) and falling_edge(BCLK) then
      case cnt_sel is
        when 1 => cnt_sel <= 0;
        when 0 => cnt_sel <= 1;
      end case;
    end if;
  end process;

  -- These are two neg. edge triggered down counters which load
  -- non zero values from their input and count to zero.
  
  dec0 : process (BCLK,Value0,Val0)
  begin
    if falling_edge(BCLK) then
      if (Value0 = 0) and (Val0 /= 0) then
        Value0 <= Val0;
      elsif (Value0 /= 0) then
        Value0 <= Value0 - 1;
      else
      Value0 <= 0;
      end if;
    end if;
  end process;

  dec1 : process (BCLK,Value1,Val1)
  begin
    if falling_edge(BCLK) then
      if (Value1 = 0) and (Val1 /= 0) then
        Value1 <= Val1;
      elsif (Value1 /= 0) then
        Value1 <= Value1 - 1;
      else
      Value1 <= 0;
      end if;
    end if;
  end process;
  
end behavioural;

-- --================================= End ===================================--
