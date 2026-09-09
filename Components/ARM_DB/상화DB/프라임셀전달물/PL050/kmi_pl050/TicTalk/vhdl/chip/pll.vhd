--------------------------------------------------------------------------------
--  This confidential and proprietary software may be used only as
--  authorised by a licensing agreement from ARM Limited
--    (C) COPYRIGHT 1998 ARM Limited
--        ALL RIGHTS RESERVED
--  The entire notice above must be reproduced on all authorised
--  copies and copies may only be made to the extent permitted
--  by a licensing agreement from ARM Limited.
--------------------------------------------------------------------------------
--  
--  Version and Release Control Information:
--  
--  File Name              : pll.vhd,v
--  File Revision          : 1.1.1.1
--  
--  Release Information    : PL050-REL1v1
--  
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--  Purpose          : On-chip clock driver 
--
--------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;

library common;
--#synth off
use common.params.all;
--#synth on

entity pll is
  port (
        XCLKIN       : in     std_logic;   -- external clock input
        BCLK         : out    std_ulogic
        );
end pll;

architecture behavioral of pll is
 
  signal BCLKi       : std_ulogic;

  begin
  
  BCLKi <= XCLKIN;

  -- propagate clocks outside of this module
  BCLK <= BCLKi;

end behavioral;
