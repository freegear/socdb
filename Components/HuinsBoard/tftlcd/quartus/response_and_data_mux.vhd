-- response_and_data_mux.vhd
--
-- Author: Jeremy Fox, Altera UK
-- Date: 9/26/02
-- Rev 0
--

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY response_and_data_mux IS PORT (
	-- system signals
	hclock			: IN std_logic;
	hresetn			: IN std_logic;

	-- slave iface signals
	hsel_slave_iface	: IN std_logic;
	hready_slave_iface	: IN std_logic;
	hresp_slave_iface	: IN std_logic_vector(1 downto 0);
	hrdata_slave_iface	: IN std_logic_vector(31 downto 0);

	-- default slave signals
	hsel_default_slave	: IN std_logic;
	hready_default_slave	: IN std_logic;
	hresp_default_slave	: IN std_logic_vector(1 downto 0);

	-- outputs to bridge
	hready			: OUT std_logic;
	hresp			: OUT std_logic_vector(1 downto 0);
	hrdata			: OUT std_logic_vector(31 downto 0));	
END response_and_data_mux;

ARCHITECTURE rtl OF response_and_data_mux IS
	
	SIGNAL hsel_slave_iface_delay : std_logic;
	
BEGIN

-- delay the hsel signal by 1 clock cycle as the data phase of a transaction occurs 1 clock
-- cycle after the address phase;
PROCESS(hclock,hresetn)
BEGIN
	IF hresetn = '0' THEN
		hsel_slave_iface_delay <= '0';
	ELSIF rising_edge(hclock) THEN   --PLD select HSEL
		hsel_slave_iface_delay <= hsel_slave_iface;
	END IF;
END PROCESS;
	
-- hrdata mux
PROCESS(hsel_slave_iface_delay,hsel_default_slave,hrdata_slave_iface,hresp_slave_iface,hresp_default_slave)
BEGIN
	IF hsel_slave_iface_delay = '1' THEN
		hrdata <= hrdata_slave_iface;
		hresp <= hresp_slave_iface;
	ELSE
		hresp <= hresp_default_slave;
		hrdata <= (others => '0');  -- we are idle or have a default slave hit
	END IF;		
END PROCESS;

hready <= hready_slave_iface AND hready_default_slave;

END rtl;