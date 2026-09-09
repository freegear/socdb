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
--           To describe one individual virtual register
--
-- --=================================================================--

library IEEE;
use     IEEE.std_logic_1164.all;
use     IEEE.std_logic_arith.all;

library common;
use     common.defs.all;
 
-- ---------------------------------------------------------------------

entity reg is
  generic (
           VIODel : time
          );
  port (
        RegEna : in std_logic;
        -- when high, indicates that the Virtual Register can be written
        -- into
        VIOSel : in T_v_drv_sel;
        -- indicates the current vr cycle e.g v_write, v_read, v_count
        -- or v_idle
        data   : inout T_vreg;
        -- internal i/o between linedriver and vregbank module
        mask   : in T_vreg;
        -- 32 bit mask used for reading and comparing data from virtual
        -- register
        vio    : inout T_vreg
        -- virtual register i/o between the vrblock and outside world
       );
end reg;

-- ---------------------------------------------------------------------
--
--                                     reg
--                                     ===
--
-- ---------------------------------------------------------------------
--
-- Overview
-- ========
--   This is a single virtual register, with generic mode (m_in or
-- m_out) and identification. Remember VIO = Non-Amba I/O
--
-- ---------------------------------------------------------------------
 
-- --========================= ARCHITECTURE ==========================--

architecture behavioural of reg is

-- ---------------------------------------------------------------------
--
-- Main body of code
-- =================
--
-- ---------------------------------------------------------------------

begin

p_reg : process (VIOSel, RegEna, data, mask, vio)
-- ---------------------------------------------------------------------
-- Variable declarations
-- ---------------------------------------------------------------------
variable i_data : T_vreg := (others => '0');
-- This variable is used to store the output value
    
begin
  case VIOSel is
    when Vread  =>
      -- If configured as input, don't drive the input. Instead pass the
      -- input to linedriver module for comparison.
      vio <= (others => 'Z');
      data <= vio;
    when Vwrite =>
      -- don't drive the output
      data <= (others => 'Z');
      -- if selected then
      if (RegEna = '1') then
        -- update internal data
        i_data := (data and mask) or (i_data and data) or
                  (i_data and not mask);
        vio <= i_data after VIODel;
      end if;
    when others => null;
  end case;
end process p_reg;

end behavioural;

-- --============================== End ==============================--
