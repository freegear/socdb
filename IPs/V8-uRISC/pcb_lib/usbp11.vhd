--------------------------------------------------------------------------------
-- Copyright 1996 VAutomation Inc. Nashua NH USA ALL RIGHTS RESERVED.
-- This software is provided under license and contains proprietary and 
-- confidential material which is the property of VAutomation Inc.
--
-- File: usbp11.vhd
--
-- Description: 
--	VHDL entity for the Philips Semiconductors generic USB
--      transceiver. Only used for PCB generation.
-- Phillips Semi part # PDIUSBP11D
--

--------------------------------------------------------------------------------
-- Revision History
-- $Log: usbp11.vhd,v $
-- Revision 1.5  1998/05/06 21:11:16  eric
-- removed RCV driving Xes - sends noise instead.
--
-- Revision 1.4  1997/02/20  22:01:39  chris
-- Corrected input port functions.
--
-- Revision 1.3  1997/02/07 20:00:54  chris
-- Added greggs architecture to pass the appropriate signals.
--
-- Revision 1.2  1996/11/11  19:55:04  eric
-- Added architecture.
--
--------------------------------------------------------------------------------
library ieee, std;
use ieee.std_logic_1164.all;

entity usbp11 is
  port (oe_n   : in    std_logic;  -- Ouput enable
        rcv    : out   std_logic;  -- Receive data
        vp     : out   std_logic;  -- V plus
        vm     : out   std_logic;  -- V minus
        suspnd : in    std_logic;  -- Suspend
        speed  : in    std_logic;  -- Speed
        dminus : inout std_logic;  -- D minus
        dplus  : inout std_logic;  -- D plus
        vpo    : in    std_logic;  -- Data out
        vmo    : in    std_logic;  -- Data out
        gnds   : in    std_logic;  -- Ground
        pwr    : in    std_logic); -- VCC power supply (3.3V!!!)

--type string_array is array (natural range <>, natural range <>) of character;

attribute pin_number   : string;
attribute package_type : string;
attribute package_type of usbp11 : entity is "USBP11@SO14";

-- I/O pin assignments
attribute pin_number of oe_n   : signal is "2";
attribute pin_number of rcv    : signal is "3";
attribute pin_number of vp     : signal is "4";
attribute pin_number of vm     : signal is "5";
attribute pin_number of suspnd : signal is "6";
attribute pin_number of gnds    : signal is "7";
attribute pin_number of speed  : signal is "9";
attribute pin_number of dminus : signal is "10";
attribute pin_number of dplus  : signal is "11";
attribute pin_number of vpo    : signal is "12";
attribute pin_number of vmo    : signal is "13";
attribute pin_number of pwr    : signal is "14";

end usbp11;

architecture behavioral of usbp11 is
signal pwron,noise : std_logic;
begin

process begin
  pwron <= '0';
  wait for 1000 ns;
  pwron <= '1';
  wait; -- forever...
end process;

noise <= NOT noise AND pwron after 321 ns;	-- 321 is arbitrary

-- RCV by spec must be ignored during an SE0 as it is likely
-- that RCV will bounce around when both sides of the differential
-- receiver are at the same voltage.
-- The NOISE signal injects random transitions on the RCV signal
-- during a SE0. This is better than outputting an X because in
-- most gate level simulations the X will propagate no matter what.
-- When extracting test vectors. you may want to force
-- pwron to be 0 so that the noise signal is always 0.
-- Otherwise there will be various errors due to the asynchronous
-- NOISE signal.

dplus <= vpo when oe_n = '0' else
	 'Z' when oe_n = '1' else
	 'X';

dminus <= vmo when oe_n = '0' else
	  'Z' when oe_n = '1' else
	  'X';

-- differencial input reciever
rcv <= '1' when (dplus = '1' or dplus = 'H') and 
	        (dminus = '0' or dminus = 'L') else
       '0' when (dplus = '0' or dplus = 'L') and 
	        (dminus = '1' or dminus = 'H') else
       noise;	

-- single ended input recievers
vp <= '1' when (dplus = '1' or dplus = 'H') else
      '0' when (dplus = '0' or dplus = 'L') else
      'X';

vm <= '1' when (dminus = '1' or dminus = 'H') else
      '0' when (dminus = '0' or dminus = 'L') else
      'X';

end;
