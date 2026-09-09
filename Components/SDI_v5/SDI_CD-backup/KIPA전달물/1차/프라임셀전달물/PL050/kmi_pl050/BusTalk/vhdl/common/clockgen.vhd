-- --=========================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 1998 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
-- 
-- -----------------------------------------------------------------------------
-- Version and Release Control Information:
-- 
-- File Name           : clockgen.vhd,v 
-- File Revision       : 1.2 
-- 
-- Release Information : PL050-REL1v1 
-- 
-- -----------------------------------------------------------------------------
-- Purpose             : To generate the system clock. 
-- --=========================================================================--

library ieee;
use     ieee.std_logic_1164.all;

library common;
use common.defs.all;

entity clockgen is
  generic(
          tclkl  : time;
          tclkh  : time
          );          
  port(
       BCLK : out std_logic
       );
end clockgen;

architecture behavioural of clockgen is

  signal i_BCLK : std_logic := '0';

begin

    clock : process(i_BCLK)
    begin
      
    if i_BCLK = '0' then
      i_BCLK <= '1' after tclkl;
    else
      i_BCLK <= '0' after tclkh;
    end if;

    BCLK <= i_BCLK;

    end process clock;

end behavioural;

-- --================================= End ===================================--
