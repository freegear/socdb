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
-- File Name           : clockgen.vhd.rca 
-- File Revision       : 1.1 
-- 
-- Release Information : PrimeCell(TM)-GLOBAL-REL1v5 
-- 
-- ---------------------------------------------------------------------
-- Purpose             : To generate the system clock. 
-- --=================================================================--

library ieee;
use     ieee.std_logic_1164.all;

library common;
use common.defs.all;

entity clockgen is
  generic(
          tclks  : time;
          tclkl  : time;
          tclkh  : time
          );          
  port(
       PCLK : out std_logic
       );
end clockgen;

architecture behavioural of clockgen is

  signal i_PCLK             : std_logic := '0';
  signal Start_PCLK         : std_logic := '0';

begin

    -- The PCLK signal will be allowed to toggle only if
    -- the Start_PCLK signal is set. The Start_PCLK signal
    -- will be set after a time duration of tclks. This is
    -- used to control the initial delay of the first 
    -- rising edge of clock.
    Start_PCLK <= '1' after tclks;

    clock : process(i_PCLK, Start_PCLK)
    begin
      
    -- If Start_PCLK is set allow the clock to toggle
    if (Start_PCLK = '1') then
      if i_PCLK = '0' then
        i_PCLK <= '1' after tclkl;
      else
        i_PCLK <= '0' after tclkh;
      end if;
    -- If Start_PCLK is cleared, the clock line will be low 
    else
      i_PCLK <= '0';
    end if;

    PCLK <= i_PCLK;

    end process clock;

end behavioural;

-- --============================= End ===============================--
