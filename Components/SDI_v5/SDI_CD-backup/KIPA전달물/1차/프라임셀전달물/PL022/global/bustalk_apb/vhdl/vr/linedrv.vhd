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
-- File Name           : linedrv.vhd.rca 
-- File Revision       : 1.1 
-- 
-- Release Information : PrimeCell(TM)-GLOBAL-REL1v5 
-- 
-- ---------------------------------------------------------------------
-- Purpose             : Virtual Registers line drivers (one per VR)
-- --=================================================================--

library ieee;
use     ieee.std_logic_1164.all;

library common;
use     common.defs.all;
use     common.funcs.all;

entity linedrv is
  generic (
           Verbosity      : boolean;
           HaltOnMismatch : boolean
          );
  port(
       PCLK      : in std_logic;
       VIO_sel   : in T_v_drv_sel;
       vr_packet : in T_vr;
       regen     : out std_ulogic;
       data_bus  : inout T_vreg;
       mask_bus  : out T_vreg
      );
end linedrv;

architecture behavioural of linedrv is

     signal i_reg_sel  : integer range 0 to 7;
     signal i_data     : T_vreg;
     signal i_mask     : T_vreg;
     signal i_phase    : T_line;
 
     signal i_edge     : T_line;
     signal i_tag      : string(1 to 20);

     signal i_r_data   : T_vreg;
     signal i_exp      : T_vreg;

     signal i_regen    : std_ulogic;

begin

   latch_wval : process (VIO_sel, PCLK)
   begin
     if VIO_sel = v_write or VIO_sel = v_read then
           i_reg_sel <= vr_packet.vregno;   --  select register
           i_data    <= vr_packet.data; --  Drive data bus
           i_mask    <= vr_packet.mask; --  Drive mask bus
           i_phase   <= vr_packet.phase;
           i_exp     <= vr_packet.exp;
           i_edge    <= vr_packet.edge;
           i_tag     <= vr_packet.tag;
     end if;
   end process;

   i_regen <= '1' when ((i_phase = PCLK) and VIO_sel = v_write) 
               else '0';
   regen <= i_regen;

   mask_bus    <= i_mask;      --  Drive mask bus

   dbdriv : process (PCLK, VIO_sel, i_phase, i_data)
   begin
     if VIO_sel = v_read then
          data_bus <= (others => 'Z');
     elsif VIO_sel = v_write and i_phase = PCLK then
          data_bus <= i_data;  
     end if;
   end process;

   reportwr : process (i_data, i_mask)
    begin 
         if (i_data'event  or i_mask'event) and VIO_sel = v_write and
            Verbosity then
            ReportVirWrite(i_data,i_mask,i_reg_sel);
         end if;
   end process;

   reportrd : process (PCLK)
    begin
         if (PCLK'event and (PCLK = i_edge)) and VIO_sel = v_read then
            ReportVirRead(Verbosity, HaltOnMismatch,
                          data_bus,i_mask,i_exp,i_reg_sel,i_tag);
         end if;
   end process;
    
end behavioural;

-- --============================= End ===============================--
