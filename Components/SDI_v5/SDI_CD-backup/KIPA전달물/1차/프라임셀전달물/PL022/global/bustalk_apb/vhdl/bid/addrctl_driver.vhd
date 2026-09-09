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
-- File Name           : addrctl_driver.vhd.rca 
-- File Revision       : 1.1 
-- 
-- Release Information : PrimeCell(TM)-GLOBAL-REL1v5
-- 
-- ---------------------------------------------------------------------
-- Purpose  : 
--            To drive internal information onto the APB with the 
--            associated timing. Several signals have this timing.
-- --=================================================================--

library ieee;
use     ieee.std_logic_1164.all;

library common;
use     common.defs.all;

entity  addrctl_driver is
  generic(
          width : T_int;
          Tclkh : time;
          Tis   : time;
          Tih   : time
          );
  port(
       PRESETn    : in std_logic;
       addrctl_sel: in T_a_drv_sel;
       in_sig     : in std_logic_vector((width - 1) downto 0);
       out_sig    : out std_logic_vector((width - 1) downto 0)
       );
end addrctl_driver;

architecture behavioral of addrctl_driver is

  signal i_out_sig  : std_logic_vector((width - 1) downto 0);
 
  begin
    setup_and_hold_time : process (PRESETn, addrctl_sel,  i_out_sig)
      begin
        if PRESETn = '0' then
          i_out_sig <= (others => '0');
        elsif addrctl_sel'event and addrctl_sel = a_addr and 
              i_out_sig(0) /=  'X' then
          i_out_sig <= (others => 'X') after Tih; 
                                               -- sets line to 'X' trigd
                                               -- by sel
        elsif i_out_sig(0) =  'X' then
            i_out_sig <= in_sig after  (Tclkh - Tis - Tih); 
                                               -- drives line trigrd by
                                               -- previous X
        end if;
        out_sig <= i_out_sig;
      end process;

end behavioral;

-- --============================= End ===============================--
