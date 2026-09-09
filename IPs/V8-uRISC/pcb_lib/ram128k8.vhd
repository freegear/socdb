-----------------------------------------------------------------------------
--
-- File: RAM128K8.VHD
--
-- Description: Full Functional Model of a 128kx8 SRAM.
--	Initializes the low 64k from an Intel Hex format file called ram.hex.
-- 	Upper 64k cannot be initialized...
--
-- Copyright 1995 VAutomation Inc. Nashua NH. All rights reserved.
-- VAutomation Inc. 20 Trafalgar Sq. Nashua NH 03063 (603)882-2282.
-- This software is provided under license and contains proprietary
-- and confidential material which is the property of VAutomation Inc.
--
-----------------------------------------------------------------------------
-- $Log: ram128k8.vhd,v $
-- Revision 1.6  1999/09/10 17:49:54  gregg
-- Uncommented gereric infname
--
-- Revision 1.5  1999/04/01 17:59:30  eric
-- increased addr and data delays from 1 to 3 ns to ease gate level simulations.
--
-- Revision 1.4  1998/02/13 15:31:35  chris
-- Changed RAM access time from 20ns to 10ns to support faster V8 simulations.
--
-- Revision 1.3  1997/08/19 16:28:32  chris
-- Added 1ns of delay on address and data to prevent hold time failures.
--
-- Revision 1.2  1997/02/14  18:59:02  eric
-- improved package_type attribute.
--
-- Revision 1.1  1996/11/11 19:55:44  eric
-- Initial revision
--
-----------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use work.v8_pkg.all;
use std.textio.all;

----------------- Entity declaration ---------------------------------

ENTITY ram128k8 IS
  GENERIC(infname  : STRING  := "ram128k8.hex");
  PORT (SIGNAL addr: IN    std_logic_vector(16 DOWNTO 0); -- Address
        SIGNAL ce_n: IN    std_logic;  -- Chip enable1 active low
        SIGNAL ce  : IN    std_logic;  -- Chip enable2 active high
        SIGNAL data: INOUT std_logic_vector(7 DOWNTO 0); -- Data I/O port
        SIGNAL oe_n: IN    std_logic;  -- Output enable
        SIGNAL we_n: IN    std_logic); -- Write enable
-- pinout is for a Cypress CY7C109 SOJ32
TYPE string_array IS ARRAY (natural range <>, natural range <>) OF CHARACTER;
attribute pin_number : string;
attribute array_pin_number : string_array;
attribute array_pin_number of addr : SIGNAL is ("2 ","31","3 ","28","4 ","25","23","26","27","5 ","6 ","7 ","8 ","9 ","10","11","12");
attribute array_pin_number of data : SIGNAL is ("21","20","19","18","17","15","14","13");
attribute pin_number of ce   : SIGNAL is "30";
attribute pin_number of ce_n : SIGNAL is "22";
attribute pin_number of oe_n : SIGNAL is "24";
attribute pin_number of we_n : SIGNAL is "29";
attribute VCC_PINS : STRING;
attribute GND_PINS : STRING;
attribute VCC_PINS of ram128k8 : ENTITY is "32";
attribute GND_PINS of ram128k8 : ENTITY is "16";
attribute package_type : STRING;
attribute package_type of ram128k8 : ENTITY is "ram128k8@SOJ32_300MIL";
END ram128k8;

ARCHITECTURE behavioral of ram128k8 is	---------------------Architecture-----
signal ramout : std_logic_vector(7 downto 0); -- this is read data
signal chip_enable : std_logic;
signal data_d : std_logic_vector(7 DOWNTO 0); -- Data I/O port
signal addr_d: std_logic_vector(16 DOWNTO 0); -- Address

CONSTANT Xes : std_logic_vector(7 downto 0):="XXXXXXXX";

BEGIN

chip_enable <= To_x01(ce) AND NOT To_x01(ce_n);
addr_d <= TRANSPORT addr after 3 ns;
data_d <= TRANSPORT data after 3 ns;

ram:PROCESS	-- This is the primary RAM model process
VARIABLE ram_core : byte_array( 0 to (128*1024)-1); -- 128K bytes
VARIABLE address : integer;
VARIABLE i : integer;
VARIABLE temp: std_logic_vector(31 downto 0);
VARIABLE infile : string(1 to 12);
VARIABLE firstime: BOOLEAN:=TRUE; -- Tells us if first time thru

BEGIN
  if firstime THEN -- init the ram
    infile := infname;
    init_ramcore(ram_core,	-- ram to be initialized
	infile,			-- file name to be loaded
	"ram128K");		-- name of RAM
    firstime := FALSE;	-- disable init once we have done it.
    ramout <= "LLLLLLLL"; -- weak zero on powerup
  end if;
  WHILE chip_enable = '0'
  LOOP -- no ce_n enabled so we can remain idle.
    WAIT ON chip_enable;
  END LOOP;
  -- CE's enabled, so lets do something!
  IF (we_n = '0') THEN -- it's a write cycle.
    WAIT ON we_n, chip_enable;	-- wait for WE or CE to change which signals the write
    address := vec2int(addr_d); -- convert the address.
    ram_core(address) := data_d;
  ELSE -- we assume a read cycle
    address := vec2int(addr); -- convert the address.
    ramout <= TRANSPORT ram_core(address) after 5 ns;
    WAIT ON chip_enable, addr , we_n;
  END IF;
END PROCESS;

-- The tristate enable logic is here.
data <=  TRANSPORT ramout after 5 ns WHEN (chip_enable='1') AND (oe_n='0')
	ELSE "ZZZZZZZZ" after 5 ns;
end behavioral;
