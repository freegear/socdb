-- Copyright (C) 1991-2002 Altera Corporation
-- Any  megafunction  design,  and related netlist (encrypted  or  decrypted),
-- support information,  device programming or simulation file,  and any other
-- associated  documentation or information  provided by  Altera  or a partner
-- under  Altera's   Megafunction   Partnership   Program  may  be  used  only
-- to program  PLD  devices (but not masked  PLD  devices) from  Altera.   Any
-- other  use  of such  megafunction  design,  netlist,  support  information,
-- device programming or simulation file,  or any other  related documentation
-- or information  is prohibited  for  any  other purpose,  including, but not
-- limited to  modification,  reverse engineering,  de-compiling, or use  with
-- any other  silicon devices,  unless such use is  explicitly  licensed under
-- a separate agreement with  Altera  or a megafunction partner.  Title to the
-- intellectual property,  including patents,  copyrights,  trademarks,  trade
-- secrets,  or maskworks,  embodied in any such megafunction design, netlist,
-- support  information,  device programming or simulation file,  or any other
-- related documentation or information provided by  Altera  or a megafunction
-- partner, remains with Altera, the megafunction partner, or their respective
-- licensors. No other licenses, including any licenses needed under any third
-- party's intellectual property, are provided herein.

-- PROGRAM "Quartus II"
-- VERSION "Version 2.2 Build 147 12/02/2002 SJ Full Version"

LIBRARY ieee;
USE ieee.std_logic_1164.all; 

LIBRARY work;

ENTITY video_dma3 IS 
	port
	(
		reset_n :  IN  STD_LOGIC;
		siface_hsel :  IN  STD_LOGIC;
		siface_hbusreq_from_stripe :  IN  STD_LOGIC;
		miface_hready_from_stripe :  IN  STD_LOGIC;
		miface_hgrant_from_stripe :  IN  STD_LOGIC;
		clock25 :  IN  STD_LOGIC;
		hclock :  IN  STD_LOGIC;
		clock50 :  IN  STD_LOGIC;
		siface_hwrite_from_stripe :  IN  STD_LOGIC;
		miface_hrdata_from_stripe :  IN  STD_LOGIC_VECTOR(31 downto 0);
		siface_haddress_from_stripe :  IN  STD_LOGIC_VECTOR(31 downto 0);
		siface_hburst_from_stripe :  IN  STD_LOGIC_VECTOR(2 downto 0);
		siface_hsize_from_stripe :  IN  STD_LOGIC_VECTOR(1 downto 0);
		siface_htrans_from_stripe :  IN  STD_LOGIC_VECTOR(1 downto 0);
		siface_hwdata_from_stripe :  IN  STD_LOGIC_VECTOR(31 downto 0);
		hsync :  OUT  STD_LOGIC;
		irq :  OUT  STD_LOGIC;
		miface_hlock_to_stripe :  OUT  STD_LOGIC;
		miface_hbusreq_to_stripe :  OUT  STD_LOGIC;
		siface_hready_to_stripe :  OUT  STD_LOGIC;
		vga_clk :  OUT  STD_LOGIC;
		vsync :  OUT  STD_LOGIC;
		DE :  OUT  STD_LOGIC;
		B :  OUT  STD_LOGIC_VECTOR(7 downto 0);
		G :  OUT  STD_LOGIC_VECTOR(7 downto 0);
		miface_haddr_to_stripe :  OUT  STD_LOGIC_VECTOR(31 downto 0);
		miface_hburst_to_stripe :  OUT  STD_LOGIC_VECTOR(2 downto 0);
		miface_hsize_to_stripe :  OUT  STD_LOGIC_VECTOR(1 downto 0);
		miface_htrans_to_stripe :  OUT  STD_LOGIC_VECTOR(1 downto 0);
		miface_hwdata_to_stripe :  OUT  STD_LOGIC_VECTOR(31 downto 0);
		R :  OUT  STD_LOGIC_VECTOR(7 downto 0);
		siface_hrdata_to_stripe :  OUT  STD_LOGIC_VECTOR(31 downto 0);
		siface_hresp_to_stripe :  OUT  STD_LOGIC_VECTOR(1 downto 0)
	);
END video_dma3;

ARCHITECTURE bdf_type OF video_dma3 IS 

component line_buffer
	PORT(wren : IN STD_LOGIC;
		 rden : IN STD_LOGIC;
		 wrclock : IN STD_LOGIC;
		 rdclock : IN STD_LOGIC;
		 data : IN STD_LOGIC_VECTOR(31 downto 0);
		 rdaddress : IN STD_LOGIC_VECTOR(8 downto 0);
		 wraddress : IN STD_LOGIC_VECTOR(8 downto 0);
		 q : OUT STD_LOGIC_VECTOR(31 downto 0)
	);
end component;

component video_dma_controller
	PORT(enable_dma : IN STD_LOGIC;
		 vblank : IN STD_LOGIC;
		 hblank : IN STD_LOGIC;
		 reset_n : IN STD_LOGIC;
		 masterhclk : IN STD_LOGIC;
		 masterhgrant : IN STD_LOGIC;
		 masterhready : IN STD_LOGIC;
		 buffer_address : IN STD_LOGIC_VECTOR(31 downto 0);
		 masterhrdata : IN STD_LOGIC_VECTOR(31 downto 0);
		 num_lines : IN STD_LOGIC_VECTOR(15 downto 0);
		 num_words_per_line : IN STD_LOGIC_VECTOR(15 downto 0);
		 masterhlock : OUT STD_LOGIC;
		 masterhbusreq : OUT STD_LOGIC;
		 set_irq : OUT STD_LOGIC;
		 buffer_select : OUT STD_LOGIC;
		 dma_data_valid : OUT STD_LOGIC;
		 dma_data : OUT STD_LOGIC_VECTOR(31 downto 0);
		 masterhaddr : OUT STD_LOGIC_VECTOR(31 downto 0);
		 masterhburst : OUT STD_LOGIC_VECTOR(2 downto 0);
		 masterhsize : OUT STD_LOGIC_VECTOR(1 downto 0);
		 masterhtrans : OUT STD_LOGIC_VECTOR(1 downto 0);
		 masterhwdata : OUT STD_LOGIC_VECTOR(31 downto 0);
		 rx_buffer_wraddress : OUT STD_LOGIC_VECTOR(9 downto 0)
	);
end component;

component slave_interface
	PORT(hresetn : IN STD_LOGIC;
		 hclock : IN STD_LOGIC;
		 hwrite : IN STD_LOGIC;
		 hsel : IN STD_LOGIC;
		 current_address : IN STD_LOGIC_VECTOR(31 downto 0);
		 haddress : IN STD_LOGIC_VECTOR(31 downto 0);
		 hburst : IN STD_LOGIC_VECTOR(2 downto 0);
		 hsize : IN STD_LOGIC_VECTOR(1 downto 0);
		 htrans : IN STD_LOGIC_VECTOR(1 downto 0);
		 hwdata : IN STD_LOGIC_VECTOR(31 downto 0);
		 status : IN STD_LOGIC_VECTOR(31 downto 0);
		 hready : OUT STD_LOGIC;
		 buffer_address : OUT STD_LOGIC_VECTOR(31 downto 0);
		 control : OUT STD_LOGIC_VECTOR(31 downto 0);
		 hrdata : OUT STD_LOGIC_VECTOR(31 downto 0);
		 hresp : OUT STD_LOGIC_VECTOR(1 downto 0);
		 image_dimensions : OUT STD_LOGIC_VECTOR(31 downto 0)
	);
end component;

component irq_control
	PORT(hclock : IN STD_LOGIC;
		 reset_n : IN STD_LOGIC;
		 siface_hsel : IN STD_LOGIC;
		 siface_hwrite_from_stripe : IN STD_LOGIC;
		 set_irq : IN STD_LOGIC;
		 siface_haddress_from_stripe : IN STD_LOGIC_VECTOR(31 downto 0);
		 irq : OUT STD_LOGIC
	);
end component;

component vga_driver
	PORT(clock25 : IN STD_LOGIC;
		 reset_n : IN STD_LOGIC;
		 enable : IN STD_LOGIC;
		 image_dimensions : IN STD_LOGIC_VECTOR(31 downto 0);
		 num_lines : INOUT STD_LOGIC_VECTOR(15 downto 0);
		 num_words_per_line : INOUT STD_LOGIC_VECTOR(15 downto 0);
		 video_data : IN STD_LOGIC_VECTOR(31 downto 0);
		 hblank : OUT STD_LOGIC;
		 vblank : OUT STD_LOGIC;
		 clockext : OUT STD_LOGIC;
		 vsync : OUT STD_LOGIC;
		 hsync : OUT STD_LOGIC;
		 DE : OUT STD_LOGIC;
		 pwr_en : OUT STD_LOGIC;
		 B : OUT STD_LOGIC_VECTOR(7 downto 0);
		 G : OUT STD_LOGIC_VECTOR(7 downto 0);
		 R : OUT STD_LOGIC_VECTOR(7 downto 0);
		 video_address : OUT STD_LOGIC_VECTOR(31 downto 0)
	);
end component;

signal	buffer_address :  STD_LOGIC_VECTOR(31 downto 0);
signal	dma_control_register :  STD_LOGIC_VECTOR(31 downto 0);
signal	dma_data :  STD_LOGIC_VECTOR(31 downto 0);
signal	dma_data_valid :  STD_LOGIC;
signal	dma_status :  STD_LOGIC_VECTOR(31 downto 0);
signal	image_dimension :  STD_LOGIC_VECTOR(31 downto 0);
signal	miface_haddr_to_stripe_ALTERA_SYNTHESIZED :  STD_LOGIC_VECTOR(31 downto 0);
signal	num_lines :  STD_LOGIC_VECTOR(15 downto 0);
signal	num_words_per_line :  STD_LOGIC_VECTOR(15 downto 0);
signal	pwr_en :  STD_LOGIC;
signal	rx_buffer_rdaddress :  STD_LOGIC_VECTOR(31 downto 0);
signal	rx_buffer_wraddress :  STD_LOGIC_VECTOR(9 downto 0);
signal	setirq :  STD_LOGIC;
signal	video_data :  STD_LOGIC_VECTOR(31 downto 0);
signal	SYNTHESIZED_WIRE_0 :  STD_LOGIC;


BEGIN 
SYNTHESIZED_WIRE_0 <= '1';



b2v_inst : line_buffer
PORT MAP(wren => dma_data_valid,
		 rden => SYNTHESIZED_WIRE_0,
		 wrclock => hclock,
		 rdclock => clock25,
		 data => dma_data,
		 rdaddress => rx_buffer_rdaddress(9 downto 1),
		 wraddress => rx_buffer_wraddress(8 downto 0),
		 q => video_data);

b2v_inst1 : video_dma_controller
PORT MAP(enable_dma => dma_control_register(0),
		 vblank => dma_status(2),
		 hblank => dma_status(1),
		 reset_n => reset_n,
		 masterhclk => hclock,
		 masterhgrant => miface_hgrant_from_stripe,
		 masterhready => miface_hready_from_stripe,
		 buffer_address => buffer_address,
		 masterhrdata => miface_hrdata_from_stripe,
		 num_lines => num_lines,
		 num_words_per_line => num_words_per_line,
		 masterhlock => miface_hlock_to_stripe,
		 masterhbusreq => miface_hbusreq_to_stripe,
		 set_irq => setirq,
		 buffer_select => dma_status(0),
		 dma_data_valid => dma_data_valid,
		 dma_data => dma_data,
		 masterhaddr => miface_haddr_to_stripe_ALTERA_SYNTHESIZED,
		 masterhburst => miface_hburst_to_stripe,
		 masterhsize => miface_hsize_to_stripe,
		 masterhtrans => miface_htrans_to_stripe,
		 masterhwdata => miface_hwdata_to_stripe,
		 rx_buffer_wraddress => rx_buffer_wraddress);

b2v_inst2 : slave_interface
PORT MAP(hresetn => reset_n,
		 hclock => clock50,
		 hwrite => siface_hwrite_from_stripe,
		 hsel => siface_hsel,
		 current_address => miface_haddr_to_stripe_ALTERA_SYNTHESIZED,
		 haddress => siface_haddress_from_stripe,
		 hburst => siface_hburst_from_stripe,
		 hsize => siface_hsize_from_stripe,
		 htrans => siface_htrans_from_stripe,
		 hwdata => siface_hwdata_from_stripe,
		 status => dma_status,
		 hready => siface_hready_to_stripe,
		 buffer_address => buffer_address,
		 control => dma_control_register,
		 hrdata => siface_hrdata_to_stripe,
		 hresp => siface_hresp_to_stripe,
		 image_dimensions => image_dimension);

b2v_inst4 : irq_control
PORT MAP(hclock => hclock,
		 reset_n => reset_n,
		 siface_hsel => siface_hsel,
		 siface_hwrite_from_stripe => siface_hwrite_from_stripe,
		 set_irq => setirq,
		 siface_haddress_from_stripe => siface_haddress_from_stripe,
		 irq => irq);

b2v_inst5 : vga_driver
PORT MAP(clock25 => clock25,
		 reset_n => reset_n,
		 enable => dma_control_register(0),
		 image_dimensions => image_dimension,
		 num_lines => num_lines,
		 num_words_per_line => num_words_per_line,
		 video_data => video_data,
		 hblank => dma_status(1),
		 vblank => dma_status(2),
		 clockext => vga_clk,
		 vsync => vsync,
		 hsync => hsync,
		 DE => DE,
		 B => B,
		 G => G,
		 R => R,
		 video_address => rx_buffer_rdaddress);
miface_haddr_to_stripe <= miface_haddr_to_stripe_ALTERA_SYNTHESIZED;

dma_status(31 downto 3) <= "00000000000000000000000000000";
END; 