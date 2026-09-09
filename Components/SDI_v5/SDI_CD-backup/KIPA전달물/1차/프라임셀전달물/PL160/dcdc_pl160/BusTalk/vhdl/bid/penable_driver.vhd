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
-- File Name           : penable_driver.vhd,v
-- File Revision       : 1.2
-- 
-- Release Information : PL160-REL1v1 
-- 
-- -----------------------------------------------------------------------------
-- Purpose             : To drive PENABLE.
-- 
-- --=========================================================================--

library ieee;
use     ieee.std_logic_1164.all;

library common;
use     common.defs.all;

entity  penable_driver is
  generic(
          Tclkl : time;
          Tis   : time;
          Tih   : time );
  port(
       penable_sel : in T_t_drv_sel;
       out_sig     : out std_logic
       );
end penable_driver;

architecture behavioral of penable_driver is

  signal i_out_sig  : std_logic;
 
  begin
    setup_and_hold_time : process (penable_sel, i_out_sig)
      begin
        case  penable_sel is
          when en_ph1 =>
            i_out_sig <= '0' after Tih ; -- sets it low on reset and end of transfer
          when en_ph3 =>
            i_out_sig <= '1' after (Tclkl - Tis) ; -- sets it high round BCLK low
          when others =>
            null;
        end case;
        out_sig <= i_out_sig;
      end process;

end behavioral;

-- --================================= End ===================================--
