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
-- Release Information    : PrimeCell(TM)-GLOBAL-REL1v4
--
-- ---------------------------------------------------------------------
-- Purpose :
--           This instantiates the virtual registers. They can be
--           individually configured as inputs or outputs. data_bus
--           is the signal by which they interface with the line
--           driver. Depending on the reg_sel signal, one of them 
--           (or none) are selected to connect to data_bus.
--
-- --=================================================================--

library ieee;
use     ieee.std_logic_1164.all;

library common;
use     common.defs.all;

library vr;

entity vregbank is
  generic (
           vio_del        : t_array
          );
  port(
       regen_bus  : in std_ulogic_vector( 0 to 7);
       VIO_selbus : in T_v_drv_selbus;
       VIO        : inout T_vio;
       data_bus   : inout T_vio;  -- This is an array of std_logic_vectors
       mask_bus   : in T_vio      -- This is an array of std_logic_vectors
       );
       
end vregbank;

architecture behavioural of vregbank is

  component reg
  generic(
          vio_del : time
          );
  port(
       reg_ena  : in std_ulogic;
       VIO_sel  : in T_v_drv_sel;
       data     : inout T_vreg;
       mask     : in T_vreg;
       vio      : inout T_vreg
       );
  end component;

begin

  -- This is a 'clever' bit that generates the vregbank depending on
  -- the parameters in config.vhd
  
  gen_reg : for i in 0 to 7 generate  
  u_REG : reg
  generic map(
              vio_del => vio_del(i)
              )
  port map (
            reg_ena  => regen_bus(i),
            VIO_sel  => VIO_selbus(i),
            data     => data_bus(i), -- multiplexed I/O line from the vio_driver
            mask     => mask_bus(i),
            vio      => VIO(i)   -- onto the virtual registers
            );
  end generate gen_reg;

end behavioural;

-- --========================== End ==================================--
