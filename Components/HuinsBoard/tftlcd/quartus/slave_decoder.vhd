-- slave_decoder.vhd
--
-- Author: Jeremy Fox, Altera UK
-- Date: 9/26/02
-- Rev 0

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY slave_decoder IS PORT 
	(
	-- bridge signals
	hbusreq			: IN std_logic;
	haddr			: IN std_logic_vector(31 downto 0);

	-- outputs to slave iface
	hsel_slave_iface	: OUT std_logic;
	hsel_default_slave	: OUT std_logic
	);
END slave_decoder;

ARCHITECTURE rtl OF slave_decoder IS
	
	CONSTANT siface_base_address	: std_logic_vector(31 downto 0) := X"80000000";
	
BEGIN

PROCESS(hbusreq,haddr)
BEGIN
	IF hbusreq = '1' AND haddr(31 downto 10) = siface_base_address(31 downto 10) THEN
		hsel_slave_iface <= '1';
		hsel_default_slave <= '0';
	-- The AHB spec defines slave as having a minimum 1K address space.  The slave interface
	-- only contains 8 registers so accesses to address within the 1K address space of the 
	-- slave that are not targeting one of the 8 registers will still generate an error
	-- responce.
	ELSIF hbusreq = '1' AND haddr(31 downto 10) /= siface_base_address(31 downto 10) THEN
		hsel_slave_iface <= '0';
		hsel_default_slave <= '1';
	END IF;
END PROCESS;

END rtl;