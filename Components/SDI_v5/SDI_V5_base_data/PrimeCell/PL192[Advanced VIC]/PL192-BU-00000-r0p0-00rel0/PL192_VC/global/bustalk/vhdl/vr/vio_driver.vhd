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
-- File Name           : vio_driver.vhd.rca 
-- File Revision       : 1.1 
-- 
-- Release Information : PrimeCell(TM)-GLOBAL-r8p0-00rel0 
-- 
-- -----------------------------------------------------------------------------
-- Purpose             : To write out or sample in values from the vregbank.
--                       When reading they must be compared with expected values
--                       and when writing, only the bits to be changed are
--                       written.
-- --=========================================================================--

library ieee;
use     ieee.std_logic_1164.all;

library common;
use     common.defs.all;

library vr;

entity vio_driver is
  generic (
           vio_del        : t_array;
           Verbosity      : boolean;
           HaltOnMismatch : boolean
          );
  port(
       BCLK      : in std_logic;
       VIO_sel   : in T_v_drv_selbus;
       vr_packet : in T_vrbus;
       VIO       : inout T_vio
       );
end vio_driver;

architecture structural of vio_driver is
  
  component vregbank
  generic (
           vio_del        : t_array
          );
  port(
       regen_bus  : in std_ulogic_vector ( 0 to 7);
       VIO_selbus : in T_v_drv_selbus;
       VIO        : inout T_vio;
       data_bus   : inout T_vio;
       mask_bus   : in T_vio
       );
  end component;
  
  component linedrv
  generic (
           Verbosity      : boolean;
           HaltOnMismatch : boolean
          );
  port(
       BCLK      : in std_logic;
       VIO_sel   : in T_v_drv_sel;
       vr_packet : in T_vr;
       regen     : out std_ulogic;
       data_bus  : inout T_vreg;
       mask_bus  : out T_vreg
      );
  end component;

  signal data_bus  : T_vio;
  signal mask_bus  : T_vio;
  signal regen_bus : std_ulogic_vector ( 0 to 7);
  
begin

  gen_lndrv : for i in 0 to 7 generate  
  u_lndrv : linedrv
  generic map (
               Verbosity      => Verbosity,
               HaltOnMismatch => HaltOnMismatch
              )
  port map(
           BCLK      => BCLK,
           VIO_sel   => VIO_sel(i),
           vr_packet => vr_packet(i),
           regen     => regen_bus(i),
           data_bus  => data_bus(i),
           mask_bus  => mask_bus(i)
          );

end generate gen_lndrv;

  u_vregbank : vregbank
  generic map (
               vio_del  => vio_del
               )
  port map (
       regen_bus  => regen_bus,
       VIO_selbus => VIO_sel,
       VIO        => VIO,
       data_bus   => data_bus,
       mask_bus   => mask_bus
    );

end structural;

-- --================================= End ===================================--
