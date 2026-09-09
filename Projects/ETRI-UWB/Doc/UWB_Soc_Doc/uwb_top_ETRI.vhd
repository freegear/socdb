library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity uwb_top is
port (	rst						: in std_logic;
		clk						: in std_logic;
		cpu_clk					: in std_logic;
		p_clk					: in std_logic;
		
		-- AHB signal 
		master_hlock			: out 	std_logic;
		master_hbusreq			: out 	std_logic;
		master_hbusgrant		: in	std_logic;
		master_hmaster			: in	std_logic_vector(3 downto 0); --not used		
		master_hmastlock		: in	std_logic; --not used							
		master_hsplit			: in	std_logic_vector(15 downto 0); --not used		
		
		master_hwrite			: out 	std_logic;
		master_hprot			: out 	std_logic_vector(3 downto 0); --all zero
		master_hsize			: out 	std_logic_vector(2 downto 0);
		master_hburst			: out 	std_logic_vector(2 downto 0);
		master_htrans			: out 	std_logic_vector(1 downto 0);
		master_haddr			: out 	std_logic_vector(31 downto 0);
		master_hwdata			: out 	std_logic_vector(31 downto 0);
		master_hready			: in 	std_logic;
		master_hrdata			: in 	std_logic_vector(31 downto 0);
		master_hresp			: in	std_logic_vector(1 downto 0);
		
		slave_hsel				: in	std_logic;
		slave_hwrite			: in 	std_logic;
		slave_htrans			: in 	std_logic_vector(1 downto 0);
		slave_haddr				: in 	std_logic_vector(31 downto 0);
		slave_hsize				: in 	std_logic_vector(2 downto 0); --not used
		slave_hburst			: in 	std_logic_vector(2 downto 0);
		slave_hwdata			: in 	std_logic_vector(31 downto 0);
		slave_hready			: out 	std_logic;
		slave_hresp				: out 	std_logic_vector(1 downto 0);
		slave_hrdata			: out 	std_logic_vector(31 downto 0);
		
		interrupt_pin			: out	std_logic;

		-- PHY Interface Signals
		p_phy_active		: in std_logic;
		p_cca_status		: in std_logic;
		p_data_en			: in std_logic;
		p_data				: inout std_logic_vector(7 downto 0);
		p_rx_en				: out std_logic;
		p_tx_en				: out std_logic;
		p_reset				: out std_logic;
		p_serial_data		: inout std_logic
);
end uwb_top;

