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
-- File Name              : VIODriver.vhd.rca
-- File Revision          : 1.1
--
-- Release Information    : PrimeCell(TM)-GLOBAL-REL1v7
--
-- ---------------------------------------------------------------------
-- Purpose :
--           Reading and Writing to the bank of Virtual Registers. 
--
-- --=================================================================--

library IEEE;
use     IEEE.std_logic_1164.all;

library common;
use     common.defs.all;
library vr;

-- ---------------------------------------------------------------------

entity VIODriver is
  generic (
           VIODel         : t_array;
           Verbosity      : boolean;
           HaltOnMismatch : boolean
          );
  port (
        HCLK     : in std_logic;
        -- main system bus clock
        Viosel   : in T_v_drv_selbus;
        -- indicates the current vr cycle e.g v_write, v_read, v_count
        -- or v_idle
        Vrpacket : in T_vrbus;
        -- packet containing info about values to be driven on virtual
        -- reg lines
        Vio      : inout T_vio
        -- virtual register i/o between the vrblock and outside world
       );
end VIODriver;

-- ---------------------------------------------------------------------
--
--                             VIODriver
--                             =========
--
-- ---------------------------------------------------------------------
--
-- Overview
-- ========
--   To write out or sample in values from the vregbank. When reading
-- they must be compared with expected values and when writing, only the
-- bits to be changed are written.
--
-- ---------------------------------------------------------------------
 
-- --========================= ARCHITECTURE ==========================--

architecture structural of VIODriver is
  
-- ---------------------------------------------------------------------
-- Component declarations
-- ---------------------------------------------------------------------
component vregbank
  generic (
           VIODel : t_array
          );
  port (
        RegEnBus  : in std_ulogic_vector(0 to 7);
        VIOSelBus : in T_v_drv_selbus;
        Vio       : inout T_vio;
        DataBus   : inout T_vio;
        MaskBus   : in T_vio
       );
end component;
  
component linedrv
  generic (
           Verbosity      : boolean;
           HaltOnMismatch : boolean
          );
  port (
        HCLK     : in std_logic;
        Viosel   : in T_v_drv_sel;
        Vrpacket : in T_vr;
        regen    : out std_ulogic;
        DataBus  : inout T_vreg;
        MaskBus  : out T_vreg
       );
end component;

-- ---------------------------------------------------------------------
-- Signal declarations
-- ---------------------------------------------------------------------
signal DataBus  : T_vio;
-- internal i/o between linedriver and vregbank module

signal MaskBus  : T_vio;
-- 32 bit mask used for reading and comparing data from virtual register

signal RegEnBus : std_ulogic_vector ( 0 to 7);
-- when high, indicates that the Virtual Register can be written into
  
-- ---------------------------------------------------------------------
--
-- Main body of code
-- =================
--
-- ---------------------------------------------------------------------

begin

gen_lndrv : for i in 0 to 7 generate  
u_lndrv : linedrv
  generic map (
               Verbosity      => Verbosity,
               HaltOnMismatch => HaltOnMismatch
              )
  port map (
            HCLK     => HCLK,
            Viosel   => Viosel(i),
            Vrpacket => Vrpacket(i),
            regen    => RegEnBus(i),
            DataBus  => DataBus(i),
            MaskBus  => MaskBus(i)
           );
end generate gen_lndrv;

u_vregbank : vregbank
  generic map (
               VIODel => VIODel
              )
  port map (
            RegEnBus  => RegEnBus,
            VIOSelBus => Viosel,
            Vio       => Vio,
            DataBus   => DataBus,
            MaskBus   => MaskBus
           );

end structural;

-- --============================== End ==============================--
