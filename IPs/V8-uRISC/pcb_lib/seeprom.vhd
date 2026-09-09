-----------------------------------------------------------------------------
--
-- File: seeprom.vhd
--
-- Description: Crude simulation model of a serial EEPROM.
--	Inits all 8K to incrementing bytes and can then be read/written 
--	like a RAM.
--
-- Pinout is for an ATMEL AT24C64-10C 8 pin gullwing
-- Also compatible with the MicroChip 24C65 family
--
-- Copyright 1995 VAutomation Inc. Nashua NH. All rights reserved.
-- VAutomation Inc. 20 Trafalgar Sq. Nashua NH 03063 (603)882-2282.
-- This software is provided under license and contains proprietary
-- and confidential material which is the property of VAutomation Inc.
--
-----------------------------------------------------------------------------
-- $Log: seeprom.vhd,v $
-- Revision 1.5  1997/10/27 13:58:43  eric
-- added to_x01 to the addr pins.
--
-- Revision 1.4  1997/01/23 21:58:26  eric
-- Changed addr to individual signals for easy connection to GND or PWR.
--
-- Revision 1.3  1996/12/23 17:36:31  eric
-- Added the i2c bus behavioral code. No longer inits from a HEX file.
--
-- Revision 1.2  1996/11/11  19:50:21  eric
-- added tristate for SDA.
--
-- Revision 1.1  1996/10/31  17:32:46  eric
-- Initial revision
--
-----------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

----------------- Entity declaration ---------------------------------

ENTITY seeprom IS
--GENERIC(infname: STRING(1 TO 12) := "seeprom1.hex");
  PORT (SIGNAL addr0: IN    std_logic; -- Address
  	SIGNAL addr1: IN    std_logic; -- Address
  	SIGNAL addr2: IN    std_logic; -- Address
        SIGNAL sda : INOUT std_logic;  -- Serial Data
        SIGNAL clk : IN    std_logic;  -- clock
        SIGNAL wp  : IN    std_logic); -- Write pulse (NC on some)

TYPE string_array IS ARRAY (NATURAL RANGE <>, NATURAL RANGE <>) OF CHARACTER;
ATTRIBUTE pin_number : string;
ATTRIBUTE package_type: STRING;
ATTRIBUTE package_type OF seeprom : ENTITY is "seeprom@SOIC8_207mil_body_EIAJ";
ATTRIBUTE pin_number of addr0 : signal is "1";
ATTRIBUTE pin_number of addr1 : signal is "2";
ATTRIBUTE pin_number of addr2 : signal is "3";
ATTRIBUTE pin_number of sda : signal is "5";
ATTRIBUTE pin_number of clk : signal is "6";
ATTRIBUTE pin_number of wp  : signal is "7";
ATTRIBUTE VCC_pins:  STRING;
ATTRIBUTE GND_pins:  STRING;
ATTRIBUTE VCC_pins OF seeprom: ENTITY IS "8";
ATTRIBUTE GND_pins OF seeprom: ENTITY IS "4";

END seeprom;

ARCHITECTURE behavioral of seeprom is	---------------------Architecture-----
constant DEBUG : boolean := false; -- debugging messages are printed when false
type see_state is (IDLE, BUSY, START, STOP, CTL, ADDR_1, ADDR_2, READ, WRITE);
type byte_array is array (INTEGER RANGE <>) of STD_LOGIC_VECTOR(7 downto 0);
signal sdal : std_logic; -- local version of SDA before the IO cell.
signal state : see_state;
SIGNAL control,byte_data : std_logic_vector(7 downto 0);
SIGNAL addr_sig,bit_cnt : std_logic_vector(15 downto 0);
BEGIN

ram:PROCESS(sda,clk)
VARIABLE ram_core : byte_array( 0 to (8*1024)-1); -- 8K bytes
VARIABLE address : integer;
VARIABLE i, bit_count : integer;
VARIABLE firstime : boolean := true;
VARIABLE temp : std_logic_vector(7 downto 0);

BEGIN
  if firstime THEN -- init the ram
    temp := "00000000";
    for i in 0 to 8*1024-1 loop
      ram_core(i) := temp;
      temp := UNSIGNED(temp) + 1;
    end loop;
    sdal <= '1';
    firstime := false;
  END if;
  if (sda'event AND sda='0' AND to_x01(clk)='1') then -- we have a start condition
	assert DEBUG report "I2C START condition detected" severity note;
	if (state /= BUSY) then
	  state <= START;
	end if;
  elsif (sda'event and to_x01(sda)='1' AND to_x01(clk)='1') then -- we have a stop condition
	assert DEBUG report "I2C STOP condition detected" severity note;
	-- at the end of a write cycle, we will ignore 1 cycle
	-- to emulate the EEPROM being busy in the write state.
	if (state = WRITE) then
	  state <= BUSY;
 	else
 	  state <= IDLE;
	end if;
	sdal <= '1';
  elsif (clk'event AND clk='0') then -- we have clocked in or out a bit
    case state is
    when IDLE => --do nothing... wait for the next start
    when BUSY => --do nothing... wait for the next stop
    when START => state <= CTL; bit_count := 7;
    when CTL =>
       if (bit_count = 0) then
	 sdal <= '0';
         temp(bit_count) := to_x01(sda); 
       elsif (bit_count = -1) then
	 sdal <= '1';
	 bit_count := 8;
	 control <= temp;
	 if (temp(7 downto 1) /= ("1010" & To_X01(addr2) & To_X01(addr1) & To_X01(addr0))) THEN -- it's not for us.
	   state <= IDLE;
	 elsif (temp(0)='1') THEN
	   state <= READ;
	   temp := ram_core(address);
	   sdal <= temp(7);
	   bit_count := 8;
	 else
	   state <= ADDR_1;
	   sdal <= '1';
	   bit_count := 8;
	 end if;
       else
         temp(bit_count) := to_x01(sda); 
       end if;
       bit_count := bit_count - 1;
    when ADDR_1 =>
       if (bit_count = 0) then
	 sdal <= '0';
         temp(bit_count) := to_x01(sda); 
       elsif (bit_count = -1) then
	 sdal <= '1';
	 state <= ADDR_2;
	 bit_count := 8;
	 address := CONV_INTEGER(UNSIGNED(temp));
	 address := address * 256; -- shift up 8 bits.
       else
         temp(bit_count) := to_x01(sda); 
       end if;
       bit_count := bit_count - 1;
    when ADDR_2 =>
       if (bit_count = 0) then
	 sdal <= '0';
         temp(bit_count) := to_x01(sda); 
       elsif (bit_count = -1) then
	 state <= WRITE;
	 sdal <= '1';
	 bit_count := 8;
	 address := address + CONV_INTEGER(UNSIGNED(temp));
       else
         temp(bit_count) := to_x01(sda); 
       end if;
       bit_count := bit_count - 1;
    when READ =>
       if (bit_count = 0) then
	 sdal <= '1';
       elsif (bit_count = -1) then
	 bit_count := 8;
	 address := address + 1;
	 temp := ram_core(address);
	 byte_data <= temp;
	 if (to_x01(sda) = '1') then -- no ack, go to idle.
	   state <= IDLE;
	 else
  	   sdal <= temp(7);
	 end if;
       else
         sdal <= temp(bit_count-1);
       end if;
       bit_count := bit_count - 1;
    when WRITE =>
       if (bit_count = 0) then
	 sdal <= '0';
         temp(bit_count) := to_x01(sda); 
       elsif (bit_count = -1) then
	 sdal <= '1';
	 ram_core(address) := temp;
	 byte_data <= temp;
	 address := address + 1;
	 bit_count := 8;
       else
         temp(bit_count) := to_x01(sda); 
       end if;
       bit_count := bit_count - 1;
    when others => assert false report "Invalid SEEPROM state" severity failure;
    end case;
  end if;
  addr_sig <= CONV_STD_LOGIC_VECTOR(address,16);
  bit_cnt <= CONV_STD_LOGIC_VECTOR(bit_count,16);
END PROCESS;

sda <= '0' after 300 ns when sdal = '0' ELSE 'Z' after 300 ns; -- open drain

end behavioral;
