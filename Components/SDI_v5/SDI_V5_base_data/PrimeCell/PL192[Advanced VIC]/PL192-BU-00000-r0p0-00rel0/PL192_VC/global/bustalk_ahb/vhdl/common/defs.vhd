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
-- File Name              : defs.vhd.rca
-- File Revision          : 1.1
--
-- Release Information    : PrimeCell(TM)-GLOBAL-r8p0-00rel0
--
-- ---------------------------------------------------------------------
-- Purpose :
--           Definitions for cycle timings, cycle types and get_line
--           enumeration
--
-- --=================================================================--

library IEEE;
use     IEEE.std_logic_1164.all;

package defs is

-- --------------------------------------------------------------------
-- Constant declarations
-- ---------------------------------------------------------------------
constant read_setup_delay   : time    := 1 ns;
constant max_token_len      : integer := 32;
constant max_string_len     : integer := 256;
constant END_OF_LINE_MARKER : string(1 TO 2) := LF & ' ';
constant IntegerBitLength   : integer := 32;
constant MaxWaitState       : integer := 2147483647;
constant Maxint             : integer := 2147483647;
constant ALLZEROES          : std_logic_vector(63 downto 0)
  := "0000000000000000000000000000000000000000000000000000000000000000";
-- ---------------------------------------------------------------------
-- Type declarations
-- ---------------------------------------------------------------------
type T_reset      is (Ridle,Rdel,Rres);
type T_cycle      is (Cidle,Csr,Csw,Csp, Cvr, Cvw, Csplit, Cendian,
                      Cres,Cend);
type T_get        is (Gidle,Gget);
type T_edge       is (rising, falling);
type T_v_drv_sel  is (Vidle,Vcount,Vread,Vwrite);
type T_numcyc     is array (0 to 15) of integer;

type ascii_text is file of character;
type regmode_type is ( TwosComp, normal);
-- ---------------------------------------------------------------------
-- These let you change the size of address and data lines, but again
-- changes would have to be made in the readline procedure to take
-- account of the new string widths to describe the values
-- ---------------------------------------------------------------------
subtype T_int    is integer range 0 to 2147483647;
subtype T_data   is std_logic_vector(63 downto 0);
subtype T_addr   is std_logic_vector(31 downto 0);
subtype T_size   is std_logic_vector(2 downto 0);
subtype T_trans  is std_logic_vector(1 downto 0);
subtype T_master is std_logic_vector(3 downto 0);
subtype T_prot   is std_logic_vector(3 downto 0);
subtype T_burst  is std_logic_vector(2 downto 0);
subtype T_resp   is std_logic_vector(1 downto 0);
subtype T_line   is std_logic;
subtype T_splitx is std_logic_vector(15 downto 0);
-- ---------------------------------------------------------------------
-- The records hold the lines you are interested in for the test bench.
-- The vr and res should stay the same, with bid changing
-- ---------------------------------------------------------------------
-- Bidpacket definition  
type T_bid is record
  addr      : T_addr;
  data      : T_data;
  mask      : T_data;
  exp       : T_data;
  size      : T_size;
  prot      : T_prot;
  trans     : T_trans;
  burst     : T_burst;
  write     : T_line;
  resp      : T_trans;
  numcyc    : T_int;
  limit     : integer;
  masternum : T_master;
  masterlock: T_line;
  timeout   : T_addr; 
  idlcyc    : integer;
  rslimit   : integer;
  suppmsg   : boolean;
  tag       : string(1 to 20);
end record;

-- Reset packet definition
type T_res is record
  phase   : T_line;
  delay   : T_int;
  numcyc  : T_int;
end record;

subtype T_vreg is std_logic_vector(31 downto 0);
type T_vio is array (0 to 7) of std_logic_vector(31 downto 0);

-- VR packet definition 
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

-- Split packet definition
type T_split is record
  exphsplit   : std_logic_vector(15 downto 0);
  Numcyc0     : T_int;
  Numcyc1     : T_int;
  Numcyc2     : T_int;
  Numcyc3     : T_int;
  Numcyc4     : T_int;
  Numcyc5     : T_int;
  Numcyc6     : T_int;
  Numcyc7     : T_int;
  Numcyc8     : T_int;
  Numcyc9     : T_int;
  Numcyc10    : T_int;
  Numcyc11    : T_int;
  Numcyc12    : T_int;
  Numcyc13    : T_int;
  Numcyc14    : T_int;
  Numcyc15    : T_int;
  limit       : T_int;
end record;

-- Endian packet definition 
type T_endian is record
  endian     : std_logic_vector(1 downto 0);
end record;
 
type T_vrbus        is  array (0 to 7) of T_vr;
type T_cyclebus     is  array (0 to 7) of T_cycle;
type T_boolbus      is  array (0 to 7) of boolean;
type t_array        is  array (0 to 7) of time;
type T_v_drv_selbus is  array (0 to 7) of T_v_drv_sel;

------------------------------------------------------------------------
--  constant definitions for B_SIZE : Bus Transfer size
------------------------------------------------------------------------
constant SIZE_BYTE  : std_logic_vector(2 downto 0) := "000" ;
constant SIZE_HALF  : std_logic_vector(2 downto 0) := "001" ;
constant SIZE_WORD  : std_logic_vector(2 downto 0) := "010" ;
constant SIZE_DWORD : std_logic_vector(2 downto 0) := "011" ;
constant SIZE_4WORD : std_logic_vector(2 downto 0) := "100" ;
constant SIZE_8WORD : std_logic_vector(2 downto 0) := "101" ;
constant SIZE_16WORD: std_logic_vector(2 downto 0) := "110" ;
constant SIZE_32WORD: std_logic_vector(2 downto 0) := "111" ;
constant SIZE_HIZ   : std_logic_vector(2 downto 0) := "ZZZ" ;
constant SIZE_X     : std_logic_vector(2 downto 0) := "XXX" ;

type SIZE_S is (BYTE, HALF, WORD, DWORD, FOURWRD, EIGHTWRD, SIXTEENWRD, 
                THIRTYTWOWRD, XXXX);

function To_SIZE_S (Size : std_logic_vector(2 downto 0))
    return SIZE_S ;

end defs;
-- ---------------------------------------------------------------------
--
--                                  defs
--                                  ====
--
-- ---------------------------------------------------------------------
--
-- Overview
-- ========
--   Interestingly, the total content of this file is not contained in
-- the body of code but in declaration itself. In the declaration part,
-- various types and subtypes are declared, whose nature are obvious
-- from type-names. These have been declared to act as useful aliases
-- for the lengthy type declarations.
-- 
-- --============================= BODY ==============================--

package body defs is
 
function To_SIZE_S (Size : std_logic_vector(2 downto 0))
  return SIZE_S is
begin
  case Size is
    when SIZE_BYTE    => return (BYTE);
    when SIZE_HALF    => return (HALF);
    when SIZE_WORD    => return (WORD);
    when SIZE_DWORD   => return (DWORD);
    when SIZE_4WORD   => return (FOURWRD);
    when SIZE_8WORD   => return (EIGHTWRD);
    when SIZE_16WORD  => return (SIXTEENWRD);
    when SIZE_32WORD  => return (THIRTYTWOWRD);
    when others       => return (XXXX);
  end case ;
end To_SIZE_S ;

end defs;

-- --============================= End ===============================--
