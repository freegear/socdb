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
-- File Name           : viregcyc_drivers.vhd.rca 
-- File Revision       : 1.1 
-- 
-- Release Information : PrimeCell(TM)-GLOBAL-REL1v3 
-- 
-- ---------------------------------------------------------------------
-- Purpose             : Drives select lines (VIO_sel) for each Virtual 
--                       Register
-- --=================================================================--

library ieee;
use     ieee.std_logic_1164.all;

library common;
use     common.defs.all;

entity viregcyc_drivers is
  port(
       PCLK          : in std_logic;
       cyc_sel       : in T_cyclebus;
       vr_packet     : in T_vrbus;
       cyc_count     : in T_int;
       vreg_get_line : out T_get;
       VIO_sel       : out T_v_drv_selbus
       );
end viregcyc_drivers;

architecture behavioural of viregcyc_drivers is
 
  signal Val     : T_int := 0;
  signal max_val : T_int := 0;
  signal last    : T_int := 0;

  signal vr_active    : T_boolbus := (others => FALSE);
  signal i_VIO_sel    : T_v_drv_selbus :=(0 => v_read, 1 => v_read, 2 => v_read,
                                          3 => v_read, 4 => v_read, 5 => v_read,
                                          6 => v_read, 7 => v_read);

begin

    VIO_sel <= i_VIO_sel;
    
  loader : process (cyc_sel, PCLK)            

    variable temp_val : T_int := 0;

  begin
    
   if PCLK = '1' then
    for i in 0 to 7 loop
    if (cyc_sel(i) = c_vr) or (cyc_sel(i) = c_vw) then
         vr_active(i) <= TRUE;
      if temp_val < vr_packet(i).delay then
        temp_val := vr_packet(i).delay;
      end if;
     max_val <= temp_val;
    elsif cyc_sel(i) = c_idle then
         vr_active(i) <= FALSE;
    end if;
    end loop;
   end if;
    temp_val := 0;

  end process;


  v_timing : process (cyc_count, PCLK, vr_active)
  begin
    if PCLK = '0' then
    for i in 0 to 7 loop
      if vr_active(i) then
        if cyc_count = vr_packet(i).delay then
          if vr_packet(i).write = '1' then
            i_VIO_sel(i) <= v_write;
          else
            i_VIO_sel(i) <= v_read;
          end if;
        elsif cyc_count < vr_packet(i).delay then
         i_VIO_sel(i) <= v_count;
        end if;
      elsif i_VIO_sel(i) = v_count then
        if cyc_count = vr_packet(i).delay then
          if vr_packet(i).write = '1' then
            i_VIO_sel(i) <= v_write;
          else
            i_VIO_sel(i) <= v_read;
          end if;
        end if;
      elsif i_VIO_sel(i) = v_write or i_VIO_sel(i) = v_read then
         i_VIO_sel(i) <= v_idle;
      else
         i_VIO_sel(i) <= v_idle;
      end if;
    end loop;
    end if;

  end process;


  line_output : process (cyc_count)  
  begin
    if max_val = cyc_count or cyc_count = 1 then
      vreg_get_line <= g_get;
    else
      vreg_get_line <= g_idle;
    end if;
  end process;

end behavioural;

-- --============================= End ===============================--
