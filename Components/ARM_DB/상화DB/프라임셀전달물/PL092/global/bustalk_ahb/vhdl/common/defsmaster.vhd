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
-- File Name              : defsmaster.vhd.rca
-- File Revision          : 1.1
--
-- Release Information    : PrimeCell(TM)-GLOBAL-REL1v3
--
-- ---------------------------------------------------------------------
-- Purpose :
--           Definitions for cycle timings, cycle types and get_line
--           enumeration
--
-- --=================================================================--
 
library IEEE;
use     IEEE.std_logic_1164.all;
use     IEEE.std_logic_arith.all;
 
package defsmaster is

-- ---------------------------------------------------------------------
-- Constant declarations
-- ---------------------------------------------------------------------
constant READSETUPDELAY : time := 1 ns;
constant ALLZEROES      : std_logic_vector(63 downto 0)
  := "0000000000000000000000000000000000000000000000000000000000000000";
  
-- ---------------------------------------------------------------------
-- Subtype declarations
-- ---------------------------------------------------------------------
subtype T_int   is integer range 0 to 255;
subtype T_data  is std_logic_vector(63 downto 0);
subtype T_addr  is std_logic_vector(31 downto 0);
subtype T_size  is std_logic_vector(2 downto 0);
subtype T_trans is std_logic_vector(1 downto 0);
subtype T_prot  is std_logic_vector(3 downto 0);
subtype T_burst is std_logic_vector(2 downto 0);
subtype T_resp  is std_logic_vector(1 downto 0);
subtype T_line  is std_logic;
subtype T_vreg is std_logic_vector(31 downto 0);

-- ---------------------------------------------------------------------
-- Type declarations
-- ---------------------------------------------------------------------
type T_v_drv_sel is (v_idle,v_count,v_read,v_write);
type T_reset is (r_idle,r_del,r_res);
type T_cycle is (c_idle, c_mr, c_mw, c_gnt, c_ngt, c_res, c_req, c_vr,
                 c_vw, c_end);
type T_get is (g_idle,g_get);
--  type T_edge      is (rising, falling);

type T_endian is (little, big, no);
type T_bid is record
  data     : T_data;
  mask     : T_data;
  addr     : T_addr;
  trans    : T_trans;
  burst    : T_burst;
  resp     : T_resp;
  size     : T_size;
  num_cyc  : T_int;
  prot     : T_prot;
  lok      : T_line;
  endian   : T_endian;
  gnt      : boolean;
  gnt_cnt  : T_int;
  req      : T_int;
  lokatreq : boolean;
  exp      : T_data;
  write    : T_line;
  mast_no  : T_int;
  tag      : string(1 to 20);
end record;
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
type T_res is record
  phase   : T_line;
  delay   : T_int;
  num_cyc : T_int;
end record;
type T_vrbus    is array (0 to 7) of T_vr;
type T_cyclebus is array (0 to 7) of T_cycle;
type T_boolbus  is array (0 to 7) of boolean;
type T_v_drv_selbus is  array (0 to 7) of T_v_drv_sel;
type t_array is array(0 to 7) of time;
type T_LogVecFile is file of std_logic_vector;
  
end defsmaster;

-- ---------------------------------------------------------------------
--
--                                  defs
--                                  ====
--
-- ---------------------------------------------------------------------
 
-- --============================== BODY =============================--

package body defsmaster is

end defsmaster;

-- --============================ END ================================--
