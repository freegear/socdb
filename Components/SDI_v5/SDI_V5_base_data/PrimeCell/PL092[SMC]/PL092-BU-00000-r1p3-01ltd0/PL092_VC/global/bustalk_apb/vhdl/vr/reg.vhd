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
-- File Name              : reg.vhd.rca
-- File Revision          : 1.1
--
-- Release Information    : PrimeCell(TM)-GLOBAL-REL1v7
--
-- ---------------------------------------------------------------------
-- Purpose :
--           This is a single virtual register
--
-- --=================================================================--

library ieee;
use     ieee.std_logic_1164.all;

library common;
use     common.defs.all;

entity reg is
  generic(
          vio_del : time
          );
  port(
       reg_ena  : in std_logic;
       VIO_sel  : in T_v_drv_sel;
       data     : inout T_vreg;
       mask     : in T_vreg;
       vio      : inout T_vreg
       );
end reg;

architecture behavioural of reg is


begin

  reg : process (VIO_sel,reg_ena, data, mask, vio)
    
    -- This variable is used to store the output value
    
   variable i_data : T_vreg := (others => '0');
    
  begin
     case VIO_sel is
      when v_read  =>                      -- If configured as input
        vio <= (others => 'Z');            -- Don't drive the input!
          data <= vio;                     -- pass input to output
      when v_write =>                      -- if configured as output
        data <= (others => 'Z');           -- don't drive the output
        if (reg_ena = '1') then            -- if selected then
          i_data := (data and mask) or 
                    (i_data and data) or
                    (i_data and not mask); -- update internal data
          vio <= i_data after vio_del;
        end if;
      when others => null;
    end case;   
  end process;

end behavioural;

-- --=========================== End =================================--
