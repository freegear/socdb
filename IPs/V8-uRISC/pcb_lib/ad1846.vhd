-------------------------------------------------------------------------------
-- Copyright 1995 VAutomation Inc. Nashua NH (603) 882-2282 ALL RIGHTS RESERVED.
-- This software is provided under license and contains proprietary and
-- confidential material which is the property of VAutomation Inc.
--
-- File: ad1846.vhd
-- Description:
-- 	Crude model of the Analog Devices AD1846/ad1845 sound chip
--	The AD1848/AD1845 parts are pin-for-pin compatible.
--
--	This model does NOT attemp to accurately model the functions of the
--	actual AD184x! It provides enough behavior to help verify that
--	the interface is correct and to provide DMA data at approximately
--	the proper rate.
--
--	Capture data is always incrementing data on the left channel and
--	decrementing data on the right channel. The data rate can be selected
--	with the CLKFMT register. Supported data rates are:
--	CLKFMT[3:1] = 000 = 8Khz
--	all other values result in a 1Mhz (note this is not the real data rate!)
--	sampling rate for faster simulations.
--
--	The number of bytes for each sample is controlled by the CLKFMT[4] and
--	CLKFMT[6] bits. CLKFMT[4] selects stereo/mono (1 or 2 samples) and
--	CLKFMT[6] selects 8 or 16 bit samples (0=8 bits, 1=16 bits).
--	Capture/Playback can be independently enabled. 
--	Depending on the combination of these registers, you can get between
--	1 and 64 bytes required for each sample. 1 byte is obtained by enabling
--	Mono, 8 bit data on only capture or playback. 64 bytes is obtained
--	by Stereo, 16 bit samples, and enabling both playback and capture.
--
--	The DMA channels are modeled but the FIFOs are not.
--	
--	The capture and playback sample rates are deliberatly set to slightly
--	different rates to cause variations in requests for DMA service.
--
-- Signals ending in _n are active low.
--------------Revision History--------------------------------------------------
-- $Log: ad1846.vhd,v $
-- Revision 1.6  1998/03/30 14:59:22  eric
-- Changed from the 68PLCC to 100TQFP which is MUCH more available.
--
-- Revision 1.5  1997/12/01  16:54:28  eric
-- Minor mods for easier conversion to verilog
--
-- Revision 1.4  1997/05/13 01:35:14  eric
-- added MODE2 registers.
--
-- Revision 1.3  1997/02/14 18:59:49  eric
-- Pinout matches the ad1846, RESET_N added.
--
-- Revision 1.2  1996/12/20 21:37:52  eric
-- Added the behavioral code.
--
-- Revision 1.1  1996/11/11  19:55:39  eric
-- Initial revision
--
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;	-- we use the IEEE standard 1164 logic types.
USE ieee.std_logic_arith.all;	-- + and - operators

ENTITY	ad1846	IS --------------------ENTITY-------------------------------
  PORT (
	addr   : in  std_logic_vector(1 downto 0);
	cdak_n : in std_logic;
	cdrq   : out std_logic;
	cs_n   : in std_logic;
	data   : inout std_logic_vector(7 downto 0);
	dbdir  : out std_logic;
	dben_n : out std_logic;
	int    : out std_logic;
	pdak_n : in std_logic;
	pdrq   : out std_logic;
	pwrdn_n: in std_logic;
	reset_n: in std_logic;
	rd_n   : in std_logic;
	wr_n   : in std_logic;
	xctl0  : out std_logic;
	xctl1  : out std_logic;
	-- Below are the analog pins
	l_line : in std_logic;
	r_line : in std_logic;
	l_mic  : in std_logic;
	r_mic  : in std_logic;
	l_aux1 : in std_logic;
	r_aux1 : in std_logic;
	l_aux2 : in std_logic;
	r_aux2 : in std_logic;
	l_out  : out std_logic;
	r_out  : out std_logic;
	xtal1i : in std_logic;
	xtal1o : out std_logic;
	xtal2i : in std_logic;
	xtal2o : out std_logic;
	vref   : out std_logic;
	vref_f : in std_logic;
	l_filt : in std_logic;
	r_filt : in std_logic);
-- pinout is for the 100 pin tqfp
TYPE string_array IS ARRAY (natural range <>, natural range <>) OF CHARACTER;

attribute pin_number : string;
attribute array_pin_number : string_array;
attribute array_pin_number of data	: SIGNAL is ("84","85","86","87","90","91","92","93");
attribute array_pin_number of addr	: SIGNAL is ("100","1  ");
attribute pin_number of cdak_n	: SIGNAL is "6";
attribute pin_number of cdrq	: SIGNAL is "7";
attribute pin_number of pdak_n	: SIGNAL is "8";
attribute pin_number of pdrq	: SIGNAL is "9";
attribute pin_number of xtal1i	: SIGNAL is "12";
attribute pin_number of xtal1o	: SIGNAL is "13";
attribute pin_number of xtal2i	: SIGNAL is "16";
attribute pin_number of xtal2o	: SIGNAL is "17";
attribute pin_number of pwrdn_n	: SIGNAL is "18";
attribute pin_number of reset_n	: SIGNAL is "19";
attribute pin_number of r_filt	: SIGNAL is "25";
attribute pin_number of r_line	: SIGNAL is "28";
attribute pin_number of r_mic	: SIGNAL is "29";
attribute pin_number of l_mic	: SIGNAL is "30";
attribute pin_number of l_line	: SIGNAL is "31";
attribute pin_number of l_filt	: SIGNAL is "33";
attribute pin_number of vref	: SIGNAL is "35";
attribute pin_number of vref_f	: SIGNAL is "38";
attribute pin_number of l_aux2	: SIGNAL is "44";
attribute pin_number of l_aux1	: SIGNAL is "45";
attribute pin_number of l_out	: SIGNAL is "46";
attribute pin_number of r_out	: SIGNAL is "47";
attribute pin_number of r_aux1	: SIGNAL is "48";
attribute pin_number of r_aux2	: SIGNAL is "49";
attribute pin_number of xctl0	: SIGNAL is "71";
attribute pin_number of int	: SIGNAL is "72";
attribute pin_number of xctl1	: SIGNAL is "73";
attribute pin_number of cs_n	: SIGNAL is "74";
attribute pin_number of rd_n	: SIGNAL is "75";
attribute pin_number of wr_n	: SIGNAL is "76";
attribute pin_number of dbdir	: SIGNAL is "77";
attribute pin_number of dben_n	: SIGNAL is "78";

attribute VCC_PINS : STRING_array;
attribute GND_PINS : STRING_array;
attribute VCC_PINS of ad1846 : ENTITY is ("10","14","41","42","55","68","88","98");
attribute GND_PINS of ad1846 : ENTITY is ("11","15","20","40","43","54","67","79","89","99");
attribute package_type : STRING;
attribute package_type of ad1846 : ENTITY is "AD1846@ST100";
END ad1846;

ARCHITECTURE behav of ad1846 is ----------------Architecture----------------
SIGNAL misc_reg	: std_logic_vector(7 downto 0) :="00001010";
SIGNAL index	: std_logic_vector(4 downto 0);
SIGNAL index_data	: std_logic_vector(7 downto 0);
SIGNAL clkfmt_reg	: std_logic_vector(7 downto 0) := "00000000";
SIGNAL clk_capture  : std_logic; -- capture clock
SIGNAL clk_playback : std_logic; -- playback clock
SIGNAL capture_data_left  : std_logic_vector(15 downto 0) := "0000000000000000";
SIGNAL capture_data_right : std_logic_vector(15 downto 0) := "0000000000000000";
SIGNAL cen		: std_logic; -- capture enable
SIGNAL cdrql		: std_logic; -- local version
SIGNAL cl_r		: std_logic := '0'; -- capture Left/Right bit
SIGNAL cu_l		: std_logic := '0'; -- capture upper/lower bit
SIGNAL iface_reg	: std_logic_vector(7 downto 0) := "00001000";
SIGNAL init		: std_logic; -- 1 when busy, 0 otherwise.
SIGNAL index_reg	: std_logic_vector(7 downto 0) := "01000000";
SIGNAL laux1_reg	: std_logic_vector(7 downto 0);
SIGNAL laux2_reg	: std_logic_vector(7 downto 0);
SIGNAL lic_reg  	: std_logic_vector(7 downto 0);
SIGNAL lout_reg 	: std_logic_vector(7 downto 0);
SIGNAL low_base_reg	: std_logic_vector(7 downto 0);
SIGNAL mce		: std_logic; -- mode change enable reg
SIGNAL mix_reg		: std_logic_vector(7 downto 0);
SIGNAL mode2_regs	: std_logic_vector(7 downto 0);
SIGNAL pdrql		: std_logic; -- local version
SIGNAL pen		: std_logic; -- playback enable
SIGNAL pin_reg		: std_logic_vector(7 downto 0);
SIGNAL pio_write_strobe	: std_logic; -- write to the PIO reg
SIGNAL pio_read 	: std_logic_vector(7 downto 0);
SIGNAL pl_r		: std_logic := '0'; -- capture Left/Right bit
SIGNAL pu_l		: std_logic := '0'; -- capture upper/lower bit
SIGNAL ric_reg  	: std_logic_vector(7 downto 0);
SIGNAL raux1_reg	: std_logic_vector(7 downto 0);
SIGNAL raux2_reg	: std_logic_vector(7 downto 0);
SIGNAL read_capture 	: std_logic; -- indicates that a read cycle in progress
SIGNAL rout_reg 	: std_logic_vector(7 downto 0);
SIGNAL status_clr	: std_logic; -- write to the status reg, clear various bits
SIGNAL status_reg	: std_logic_vector(7 downto 0);
SIGNAL test_reg		: std_logic_vector(7 downto 0);
SIGNAL up_base_reg	: std_logic_vector(7 downto 0);
SIGNAL write_play	: std_logic; -- playback data strobe
BEGIN

-- write_play is active when a write of the playback data takes place.
write_play <= '1' after 1 ns WHEN 
	(cs_n='0' AND wr_n='0' AND addr="11" AND iface_reg(6)='1') OR
	(pdrql='1' AND pdak_n='0' AND wr_n='0' AND pen='1' AND iface_reg(6)='0')
	else '0' after 1 ns;

-- read_capture is active when a read of the capture data takes place.
read_capture <= '1' after 1 ns WHEN 
	(cs_n='0' AND rd_n='0' AND addr="11" and iface_reg(7)='1') OR
	(cdrql='1' AND cdak_n='0' AND rd_n='0' AND cen='1' and iface_reg(7)='0')
	else '0' after 1 ns;

status_reg <= cu_l & cl_r & cdrql & '0' & pu_l & pl_r & pdrql & '0';

-- create the microprocessor register readback mux
data <= init & index_reg(6 downto 0) 	WHEN cs_n='0' AND rd_n='0' AND addr="00" 
  else	index_data 	WHEN cs_n='0' AND rd_n='0' AND addr="01" 
  else	status_reg 	WHEN cs_n='0' AND rd_n='0' AND addr="10" 
  else	pio_read 	WHEN read_capture='1'
  else "ZZZZZZZZ";

-- create the indexed register readback mux
index_data <= lic_reg	WHEN index="00000"
  else	ric_reg		WHEN index="00001"
  else	laux1_reg	WHEN index="00010"
  else	raux1_reg	WHEN index="00011"
  else	laux2_reg	WHEN index="00100"
  else	raux2_reg	WHEN index="00101"
  else	lout_reg	WHEN index="00110"
  else	rout_reg	WHEN index="00111"
  else	clkfmt_reg	WHEN index="01000"
  else	iface_reg	WHEN index="01001"
  else	pin_reg		WHEN index="01010"
  else	test_reg	WHEN index="01011"
  else	misc_reg	WHEN index="01100"
  else	mix_reg		WHEN index="01101"
  else	up_base_reg	WHEN index="01110"
  else	low_base_reg	WHEN index="01111"
  else  "XXXXXXXX";

index <= (index_reg(4) AND misc_reg(6)) & -- bit 4 of the index is only active in mode2.
	index_reg(3 downto 0); -- alias the low 4 bits of the index reg.
mce <= index_reg(6); -- alias the mode-change-enable bit of the index reg.
pen <= iface_reg(0);
cen <= iface_reg(1);
xctl0 <= pin_reg(6);
xctl1 <= pin_reg(7);

main:process	----------process all microprocessor writes---------------
begin
  -- wait until a write cycle takes place. Data is latched on the rising edge
  -- of WR_N when CS_N is active.
  wait until wr_n'event and wr_n='1'; -- requires that WR_N be actively driven high, pullup is not enough
  if (cs_n='0') then	-- ignore unless CS is active.
   case addr is
   WHEN "00" =>  -- index register
	index_reg <= data;
   WHEN "01" =>	-- indexed data register
	case index is
	when "00000" => lic_reg <= data;
	when "00001" => ric_reg <= data;
	when "00010" => laux1_reg <= data;
	when "00011" => raux1_reg <= data;
	when "00100" => laux2_reg <= data;
	when "00101" => raux2_reg <= data;
	when "00110" => lout_reg <= data;
	when "00111" => rout_reg <= data;
	when "01000" => if (mce='1') then 
		clkfmt_reg <= data;
		else
		assert false report "No change to Clock Format reg because MCE is not 1";
		end if;
	when "01001" => if (mce='1') then
		iface_reg <= data;
		else 
		iface_reg(1 downto 0) <= data(1 downto 0);
		end if;
	when "01010" => pin_reg <= data;
	when "01011" => test_reg <= data;
	when "01100" => misc_reg(7 downto 4) <= data(7 downto 4); -- low 4 bits are read only.
	when "01101" => mix_reg <= data;
	when "01110" => up_base_reg <= data;
	when "01111" => low_base_reg <= data;
	when "10000" | "10001" | "10010" | "10011" | "10100" | "10101" | "10110" | "10111" | 
	     "11000" | "11001" | "11010" | "11011" | "11100" | "11101" | "11110" | "11111"  
		=> mode2_regs <= data;
	when others => assert false report "INDEX register is undefined";
	end case;
   WHEN "10" =>	-- status register, read only
	status_clr <= '1', '0' after 1 ns; -- clear some status bits
   WHEN "11" =>  -- we don't need to do anything here...
   WHEN others => assert false report "Invalid write, address is unknown";
   end case;
  end if;
end process;

-- create the sample clocks:
clk_capture <= NOT clk_capture AND cen AFTER 75 us 
	when clkfmt_reg(3 downto 1)="000"
	else NOT clk_capture AND cen AFTER 500 ns;

clk_playback <= NOT clk_playback AND pen AFTER 74 us 
	when clkfmt_reg(3 downto 1)="000"
	else NOT clk_playback AND pen AFTER 503 ns;

rec: process	-- capture data generator
begin
  wait until clk_capture'event AND clk_capture='1';
  capture_data_left <= UNSIGNED(capture_data_left) + 1;
  capture_data_right <= UNSIGNED(capture_data_right) - 1;
end process;

init <= '1', '0' after 100 us;

cdrq <= cdrql;	-- drive the port

process
begin
  cdrql <= '0';
  wait until clk_capture'event AND clk_capture='1';
  cdrql <= '1';
  if (clkfmt_reg(4)='1' AND clkfmt_reg(6)='1') then -- stereo, 16 bit data
    cl_r <= '0';
    cu_l <= '0';
    pio_read <= capture_data_right(7 downto 0);
    wait until read_capture'event AND read_capture='0';
    cl_r <= '0';
    cu_l <= '1';
    pio_read <= capture_data_right(15 downto 8);
    wait until read_capture'event AND read_capture='0';
    cl_r <= '1';
    cu_l <= '0';
    pio_read <= capture_data_left(7 downto 0);
    wait until read_capture'event AND read_capture='0';
    cl_r <= '1';
    cu_l <= '1';
    pio_read <= capture_data_left(15 downto 8);
  elsif (clkfmt_reg(4)='1' AND clkfmt_reg(6)='0') then -- stereo, 8 bit data
    cl_r <= '0';
    cu_l <= '1';
    pio_read <= capture_data_right(7 downto 0);
    wait until read_capture'event AND read_capture='0';
    cl_r <= '1';
    cu_l <= '1';
    pio_read <= capture_data_left(7 downto 0);
  elsif (clkfmt_reg(4)='0' AND clkfmt_reg(6)='1') then	-- mono, 16 bit data
    cl_r <= '1';
    cu_l <= '0';
    pio_read <= capture_data_left(7 downto 0);
    wait until read_capture'event AND read_capture='0';
    cl_r <= '1';
    cu_l <= '1';
    pio_read <= capture_data_left(15 downto 8);
  elsif (clkfmt_reg(4)='0' AND clkfmt_reg(6)='1') then	-- mono 8 bit data
    cl_r <= '1';
    cu_l <= '1';
    pio_read <= capture_data_left(7 downto 0);
  end if; 
  wait until read_capture'event AND read_capture='0';
end process;

pdrq <= pdrql;	-- drive the port

process
begin
  pdrql <= '0';
  wait until clk_playback'event AND clk_playback='1';
  pdrql <= '1';
  if (clkfmt_reg(4)='1' AND clkfmt_reg(6)='1') then -- stereo, 16 bit data
    pl_r <= '0';
    pu_l <= '0';
    wait until write_play'event AND write_play='0';
    pl_r <= '0';
    pu_l <= '1';
    wait until write_play'event AND write_play='0';
    pl_r <= '1';
    pu_l <= '0';
    wait until write_play'event AND write_play='0';
    pl_r <= '1';
    pu_l <= '1';
  elsif (clkfmt_reg(4)='1' AND clkfmt_reg(6)='0') then -- stereo, 8 bit data
    pl_r <= '0';
    pu_l <= '1';
    wait until write_play'event AND write_play='0';
    pl_r <= '1';
    pu_l <= '1';
  elsif (clkfmt_reg(4)='0' AND clkfmt_reg(6)='1') then	-- mono, 16 bit data
    pl_r <= '1';
    pu_l <= '0';
    wait until write_play'event AND write_play='0';
    pl_r <= '1';
    pu_l <= '1';
  elsif (clkfmt_reg(4)='0' AND clkfmt_reg(6)='1') then	-- mono 8 bit data
    pl_r <= '1';
    pu_l <= '1';
  end if; 
  wait until write_play'event AND write_play='0';
end process;

end behav;

