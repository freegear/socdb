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
-- File Name              : vregbank.vhd.rca
-- File Revision          : 1.1
--
-- Release Information    : PrimeCell(TM)-GLOBAL-REL1v7
--
-- ---------------------------------------------------------------------
-- Purpose :
--           To instantiate reg.vhd module 8 times and thus form a
--           register-bank
--
-- --=================================================================--

library IEEE;
use     IEEE.std_logic_1164.all;

library common;
use     common.defs.all;
library vr;
 
-- ---------------------------------------------------------------------

entity vregbank is
  generic (
           VIODel : t_array
          );
  port (
        RegEnBus  : in std_ulogic_vector( 0 to 7);
        -- when high, indicates that the Virtual Register can be written
        -- into
        VIOSelBus : in T_v_drv_selbus;
        -- indicates the current vr cycle e.g v_write, v_read, v_count
        -- or v_idle
        VIO       : inout T_vio;
        -- virtual register i/o between the vrblock and outside world
        DataBus   : inout T_vio;
        -- internal i/o between linedriver and vregbank module
        MaskBus   : in T_vio
        -- 32 bit mask used for reading and comparing data from virtual
        -- register
       );
end vregbank;

-- ---------------------------------------------------------------------
--
--                                vregbank
--                                ========
--
-- ---------------------------------------------------------------------
--
-- Overview
-- ========
--   This instantiates the virtual registers. They can be individually
-- configured as inputs or outputs. DataBus is the signal by which they
-- interface with the line driver. Depending on the reg_sel signal, one
-- of them (or none) are selected to connect to DataBus.
--
-- ---------------------------------------------------------------------
 
-- --========================= ARCHITECTURE ==========================--

architecture behavioural of vregbank is

-- ---------------------------------------------------------------------
-- Component declarations
-- ---------------------------------------------------------------------
component reg
  generic (
           VIODel : time
          );
  port (
        RegEna : in std_ulogic;
        VIOSel : in T_v_drv_sel;
        data   : inout T_vreg;
        mask   : in T_vreg;
        vio    : inout T_vreg
       );
end component;

-- ---------------------------------------------------------------------
--
-- Main body of code
-- =================
--
-- ---------------------------------------------------------------------

begin

-- ---------------------------------------------------------------------
-- This is a 'clever' bit that generates the vregbank depending on the 
-- parameters in config.vhd
-- ---------------------------------------------------------------------
gen_reg : for i in 0 to 7 generate  
u_REG : reg
  generic map (
               VIODel => VIODel(i)
              )
  port map (
            RegEna => RegEnBus(i),
            VIOSel => VIOSelBus(i),
            data   => DataBus(i),
            mask   => MaskBus(i),
            vio    => VIO(i)
           );
end generate gen_reg;

end behavioural;

-- --============================== End ==============================--
