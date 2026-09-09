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
-- File Name           : countdown.vhd.rca 
-- File Revision       : 1.1 
-- 
-- Release Information : PrimeCell(TM)-GLOBAL-REL1v4 
-- 
-- ---------------------------------------------------------------------
-- Purpose : 
--          Down-Counter to track cycles within the testbench model
-- --=================================================================--

library ieee;
use     ieee.std_logic_1164.all;

library common;
use     common.defs.all;

entity countdown is
  port(
       PCLK       : in std_logic;
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

  output : process (PCLK,Value0,Value1)
  begin
    case cnt_sel is
      when 1 => last <= Value0;
      when 0 => last <= Value1;
    end case;
  end process;

  loader : process (Val,PCLK)
  begin
    if (PCLK = '1') then
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

  inmux : process (PCLK,Val)
  begin
    if (Val /= 0) and falling_edge(PCLK) then
      case cnt_sel is
        when 1 => cnt_sel <= 0;
        when 0 => cnt_sel <= 1;
      end case;
    end if;
  end process;

  -- These are two neg. edge triggered down counters which load
  -- non zero values from their input and count to zero.
  
  dec0 : process (PCLK,Value0,Val0)
  begin
    if falling_edge(PCLK) then
      if (Value0 = 0) and (Val0 /= 0) then
        Value0 <= Val0;
      elsif (Value0 /= 0) then
        Value0 <= Value0 - 1;
      else
      Value0 <= 0;
      end if;
    end if;
  end process;

  dec1 : process (PCLK,Value1,Val1)
  begin
    if falling_edge(PCLK) then
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

-- --============================= End ===============================--
