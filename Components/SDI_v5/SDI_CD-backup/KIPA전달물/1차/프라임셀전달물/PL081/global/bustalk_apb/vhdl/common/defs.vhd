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
-- File Name           : defs.vhd.rca 
-- File Revision       : 1.1 
-- 
-- Release Information : PrimeCell(TM)-GLOBAL-REL1v4 
-- 
-- ---------------------------------------------------------------------
-- Purpose : 
--           Definitions for timing of cycles, cycle types and
--           get_line enumeration.
-- --=================================================================--

library ieee;
use     ieee.std_logic_1164.all;
Use     STD.TEXTIO.all;

package defs is

  constant read_setup_delay : time := 1 ns;
  constant max_token_len      : integer := 32;
  constant max_string_len     : integer := 256;
  constant END_OF_LINE_MARKER : string(1 TO 2) := LF & ' ';   
  constant IntegerBitLength   : integer := 32;

  type T_t_drv_sel  is (en_ph1, en_ph2, en_ph3, en_ph4);
  type T_v_drv_sel  is (v_idle,v_count,v_read,v_write); 
  type T_a_drv_sel  is (a_idle,a_addr);
  type T_d_drv_sel  is (d_idle,dr_hiz,dr_idle,d_read,d_write,d_reset);
  type T_reset      is (r_idle,r_del,r_res);
  type T_cycle      is (c_idle,c_pnw,c_psw,c_pnr,c_psr,c_pi,c_res,c_vr,
                        c_vw, c_end,c_po);
  type T_apb_phase  is (idle, start, p1, p2, p3, p4, p5, p6);
  type T_get        is (g_idle,g_get);
  type T_edge       is (rising, falling);

  type ascii_text is file of character;
  type regmode_type is ( TwosComp, normal );


  -- These let you change the size of address and data lines, but again
  -- changes would have to be made in the readline procedure to take 
  -- account of the new string widths to describe the values
  
  subtype T_int  is integer range 0 to 255;
  subtype T_data is std_logic_vector(31 downto 0);
  subtype T_addr is std_logic_vector(31 downto 0);
  subtype T_line is std_logic;
  subtype INT8 is integer range 0 to 7;

  -- The records hold the lines you are interested in for the testbench.
  -- The vr and res should stay the same, with bid changing (suggest 
  -- change to include all asb lines in all test benches, then assign 
  -- and read the ones we're interested in)
 
  type T_apb is record
    sel     : T_line;
    write   : T_line;
    addr    : T_addr;
    data    : T_data;
    mask    : T_data;
    exp     : T_data;
    limit   : T_data;
    num_cyc : T_int;
    tag     : string(1 to 20);
  end record;
  
  subtype T_vreg is std_logic_vector(31 downto 0);
  type T_vio is array (0 to 7) of std_logic_vector(31 downto 0);

  type T_vr is record
    vregno : integer range 0 to 7;
    data   : T_vreg;
    mask   : T_vreg;
    exp    : T_vreg;
    write  : T_line;
    phase  : T_line;
    edge   : T_line;
    delay  : T_int;
    tag    : string(1 to 20);
  end record;
  
  type T_vrbus        is  array (0 to 7) of T_vr;
  type T_cyclebus     is  array (0 to 7) of T_cycle;
  type T_boolbus      is  array (0 to 7) of boolean;
  type T_v_drv_selbus is  array (0 to 7) of T_v_drv_sel;

  type T_res is record
    phase   : T_line;
    delay   : T_int;
    num_cyc : T_int;
  end record;

  type t_array is array(0 to 7) of time;
 
  -- TrickBox Base = 0x6000_0000
  constant TrickBoxAddr : std_logic_vector(23 downto 0) 
                          := "011000000000000000000000";

end defs;

package body defs is

end defs;

-- --============================= End ===============================--
