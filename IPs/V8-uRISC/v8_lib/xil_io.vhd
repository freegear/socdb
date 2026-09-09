--------------------------------------------------------------------------------
-- Copyright 1997 VAutomation Inc. Nashua NH (603) 882-2282 ALL RIGHTS RESERVED.
-- This software is provided under license and contains proprietary and
-- confidential material which is the property of VAutomation Inc.
--
-- File: xil_io.vhd
-- Description:
-- 	IO buffers for directly instantiating Xilinx XC4000 IO cells.
--
-- Signals ending in _n are active low.
--------------Revision History--------------------------------------------------
-- $Log: xil_io.vhd,v $
-- Revision 1.12  1999/09/20 18:54:59  eric
-- Added the Altera NAND gate.
--
-- Revision 1.11  1999/08/27 15:32:06  scott
-- Changed RAMD to RAM16X1D which is more portable across Xilinx
-- libraries, ie. preferred for Virtex.
--
-- Revision 1.10  1999/03/31 18:22:09  eric
-- added obuf.
--
-- Revision 1.9  1998/07/13 20:56:03  gregg
-- Changed entity names to lower case for vhdl2v conversion
--
-- Revision 1.8  1998/07/01 23:32:16  eric
-- added FMAP.
--
-- Revision 1.7  1998/06/13  01:00:46  eric
-- added Altera GLOBAL clock buffer
--
-- Revision 1.6  1998/05/31 03:03:42  eric
-- Added OR2B1 and AND2.
--
-- Revision 1.5  1998/02/16 16:09:32  eric
-- added OBUFT_NG for jtag.
--
-- Revision 1.4  1998/01/19 22:32:28  eric
-- Added OBUFT.
--
-- Revision 1.3  1997/12/23 01:56:45  eric
-- Added RAMD.
--
-- Revision 1.2  1997/10/31 20:19:10  chris
-- Added IPAD cell.
--
-- Revision 1.1  1997/09/17 17:08:45  eric
-- Initial revision
--
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;
ENTITY ibuf IS	-----------------------------ENTITY---------------------
  port(I	: in  std_logic;
       O	: out std_logic);
END ibuf;

ARCHITECTURE synth of ibuf is -----------------Architecture synth-----------

BEGIN

O <= I;	-- input buffer
END synth;

LIBRARY ieee;
USE ieee.std_logic_1164.all;
ENTITY obuf IS	-----------------------------ENTITY---------------------
  port(I	: in  std_logic;
       O	: out std_logic);
END obuf;
ARCHITECTURE synth of obuf is -----------------Architecture synth-----------
BEGIN
O <= I;	-- output buffer
END synth;

LIBRARY ieee;
USE ieee.std_logic_1164.all;
ENTITY ipad IS	-----------------------------ENTITY---------------------
  port(PAD	: in  std_logic);
END ipad;

ARCHITECTURE synth of ipad is -----------------Architecture synth-----------

BEGIN

END synth;

LIBRARY ieee;
USE ieee.std_logic_1164.all;
ENTITY bufgls IS	-----------------------------ENTITY---------------------
  port(I	: in  std_logic;
       O	: out std_logic);
END bufgls;

ARCHITECTURE synth of bufgls is -----------------Architecture synth-----------

BEGIN

O <= I;	-- clock buffer

END synth;

LIBRARY ieee;
USE ieee.std_logic_1164.all;
ENTITY obuft IS	-----------------------------ENTITY---------------------
  port(I	: in  std_logic;
       T	: in  std_logic;
       O	: out std_logic);
END obuft;

ARCHITECTURE synth of obuft is -----------------Architecture synth-----------

BEGIN

O <= I when T='0' else 'Z';	-- tristate IO buffer, enable is active low

END synth;

LIBRARY ieee;
LIBRARY ieee;
USE ieee.std_logic_1164.all;
ENTITY obuft_ng IS	-----------------------------ENTITY---------------------
  port(I	: in  std_logic;
       T	: in  std_logic;
       O	: out std_logic);
END obuft_ng;

ARCHITECTURE synth of obuft_ng is -----------------Architecture synth-----------

BEGIN

O <= I when T='0' else 'Z';	-- tristate IO buffer, enable is active low

END synth;

LIBRARY ieee;
LIBRARY ieee;
USE ieee.std_logic_1164.all;
ENTITY or2b1 IS	-----------------------------ENTITY---------------------
  port(I0	: in  std_logic;
       I1	: in  std_logic;
       O	: out std_logic);
END or2b1;

ARCHITECTURE synth of or2b1 is -----------------Architecture synth-----------

BEGIN

O <= (NOT I0) OR I1;

END synth;

LIBRARY ieee;
LIBRARY ieee;
USE ieee.std_logic_1164.all;
ENTITY and2 IS	-----------------------------ENTITY---------------------
  port(I0	: in  std_logic;
       I1	: in  std_logic;
       O	: out std_logic);
END and2;
ARCHITECTURE synth of and2 is -----------------Architecture synth-----------
BEGIN
O <= I0 AND I1;
END synth;


LIBRARY ieee;
USE ieee.std_logic_1164.all;
ENTITY fmap IS	-----------------------------ENTITY---------------------
  port(I1,I2,I3,I4	: in  std_logic;
       O	: out std_logic := 'Z');
END fmap;
ARCHITECTURE synth of fmap is -----------------Architecture synth-----------
BEGIN	-- does nothing - put in parallel with various gates to get the 
END synth; -- LOC parameter to lock the gates in the desired place.


LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
ENTITY RAM16X1D IS	-----------------------------ENTITY---------------------
      port (
         SPO : OUT std_logic ;
         DPO : OUT std_logic ;
         A0 : IN std_logic;
         A1 : IN std_logic;
         A2 : IN std_logic;
         A3 : IN std_logic;
         WE : IN std_logic;
         D : IN std_logic;
         WCLK : IN std_logic ;
         DPRA0 : IN std_logic ;
         DPRA1 : IN std_logic ;
         DPRA2 : IN std_logic ;
         DPRA3 : IN std_logic) ;
END RAM16X1D;

ARCHITECTURE synth of RAM16X1D is --------------Architecture synth-----------

SIGNAL regfile : std_logic_vector(15 downto 0);

SIGNAL reg_load : std_logic_vector(15 downto 0);
SIGNAL data_a : std_logic;
SIGNAL data_b : std_logic;
SIGNAL addr_a : std_logic_vector(3 downto 0);
SIGNAL addr_b : std_logic_vector(3 downto 0);
BEGIN	----------------------------------------------------------------------

addr_a <= A3 & A2 & A1 & A0;
addr_b <= DPRA3 & DPRA2 & DPRA1 & DPRA0;
SPO <= DATA_A;
DPO <= DATA_B;

G1: for i in 0 to 15 GENERATE
regs:PROCESS 	----- Create the registers (with load enable)-----
BEGIN
  WAIT UNTIL wclk'event AND wclk='1';
  if (reg_load(i)='1') then
    regfile(i) <= D;
  end if;
END PROCESS;
END GENERATE;

G2: for i in 0 to 15 GENERATE
  reg_load(i) <= we WHEN CONV_INTEGER(UNSIGNED(addr_a)) = i ELSE '0';
END GENERATE;

data_a <= regfile(CONV_INTEGER(UNSIGNED(addr_a)));	-- read muxes

data_b <= regfile(CONV_INTEGER(UNSIGNED(addr_b)));	-- read muxes

END synth;

------------------------------Altera IO cells--------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;
ENTITY global IS	-----------------------------ENTITY---------------------
  port(i	: in  std_logic;
       o	: out std_logic);
END GLOBAL;

ARCHITECTURE synth of global is -----------------Architecture synth-----------

BEGIN

O <= I;	-- clock buffer

END synth;

LIBRARY ieee;
USE ieee.std_logic_1164.all;
ENTITY nand2 IS	-----------------------------ENTITY---------------------
  port(IN1,IN2	: in  std_logic;
       Y	: out std_logic);
END nand2;

ARCHITECTURE rtl of nand2 is -----------------Architecture -----------

BEGIN

Y <= NOT (IN1 AND IN2);

END rtl;

