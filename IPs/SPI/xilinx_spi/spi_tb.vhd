-------------------------------------------------------------------------------- 
-- Copyright (c) 2003 Xilinx, Inc. 
-- All Rights Reserved 
-------------------------------------------------------------------------------- 
--   ____  ____ 
--  /   /\/   / 
-- /___/  \  /   Vendor: Xilinx 
-- \   \   \/    Version: 6.1i SP3
--  \   \        Filename: spi_tb.vhd 
--  /   /        Date Last Modified:  12/15/2003 
-- /___/   /\    Date Created: 10/2/2003 
-- \   \  /  \ 
--  \___\/\___\ 
-- 
--	Device:	Xilinx 
--
--	Library:	IEEE 
--
--	Purpose:	Testbench for spi_cpld.vhd design.  This file tests configuration
--				of the FPGA using SPI Flash memory via a CPLD.  The first test
--				checks to see if upon power up, the FPGA will correctly configure.
--				The second test checks to see if a re-configuration will occur by
--				the user pulling PROGRAMn LOW on the FPGA.  The third test checks
--				to see if the FPGA can send/receive data to/from the SPI memory
--				which emulates post FPGA configuration use of the SPI as user
--				memory.  The fourth test checks to see if the CPLD will correctly
--				3-state in the case where the SPI memory is programmed from an
--				external source.
--
--	Revision History: 
--				Rev 1.0	-Initial Release	JRH
-------------------------------------------------------------------------------- 

--------------------------------------------------------------------------------
--	This software may not be reproduced or transmitted without the
--	written permission of Xilinx Incorporated. Xilinx does not assume
--	any liability arising out of the application or use of its software;
--	nor does it convey any license under its patents, copyrights, or any
--	rights of others. Xilinx reserves the right to make changes, at any
--	time, in order to improve reliability, function, or design and to
--	supply the best product possible.
--	
--	Xilinx assumes no obligation to correct any errors contained herein
--	or to advise any user of this software of any correction if such be
--	made. Xilinx will not assume any liability for the accuracy or
--	correctness of any engineering or software support or assistance
--	provided to a user.
--	
--	Xilinx products and software are not intended for use in life
--	support appliances, devices, or systems. Use of a Xilinx product or
--	software in such applications without the written consent of the
--	appropriate Xilinx officer is prohibited.
--	
--	(c) Copyright 2003 Xilinx, Inc. All rights reserved.
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity spi_cpld_tb is
end spi_cpld_tb;

architecture behavior of spi_cpld_tb is 

-- ****************************** Constants *****************************
constant CLK_PERIOD			: time := 50 nS;	-- system clock period (20MHz)

constant READ_INSTRUCTION	: std_logic_vector(7 downto 0)	:= "00001011";
constant START_ADDRESS		: std_logic_vector(23 downto 0)	:= "000000000000000000000000";

-- ************************* CPLD Instantiation *************************
component spi_cpld
port(	fpga_cclk		: in	std_logic;
		---------------------------------------------------------
		-- used when CPLD buffers signals after FPGA configuration
		fpga_io_clk		: in	std_logic;
		fpga_io_sn		: in	std_logic;
		fpga_io_wn		: in	std_logic;
		fpga_io_holdn	: in	std_logic;
		---------------------------------------------------------
		fpga_init		: in	std_logic;
		fpga_done		: in	std_logic;
		fpga_din			: out	std_logic;
		spi_c				: out	std_logic;
		spi_d				: out	std_logic;
		spi_q				: in	std_logic;    
		spi_sn			: out	std_logic;
		spi_wn			: out	std_logic;
		spi_holdn		: out	std_logic;
		ext_spi			: in	std_logic
	);
end component;

-- ************** ST Micro M25P20 SPI Flash Instantiation **************
component M25P20
generic (init_file : string); 
port(	VCC					: in	real;
		C, D, S, W, HOLD	: in	std_logic ;
		Q						: out	std_logic
		);
end component;

-- ****************************** Signals ******************************
signal vcc				: real	:= 0.0;

signal fpga_io_clk	: std_logic;
signal fpga_io_sn		: std_logic;
signal fpga_io_wn		: std_logic;
signal fpga_io_holdn	: std_logic;
signal fpga_cclk		: std_logic;
signal fpga_init		: std_logic;
signal fpga_din		: std_logic;
signal fpga_done		: std_logic;
signal spi_c			: std_logic;
signal spi_d			: std_logic;
signal spi_q			: std_logic;
signal spi_sn			: std_logic;
signal spi_wn			: std_logic;
signal spi_holdn		: std_logic;
signal config			: std_logic;
signal int_clk			: std_logic;
signal io_clk_go		: std_logic;
signal io_clk			: std_logic;
signal ext_spi			: std_logic;

begin

   
-- ************************ Generate FPGA CCLK Process ***********************   
   gen_cclk : process
   begin
		int_clk <= '1';
		wait for CLK_PERIOD/2;
		int_clk <= '0';
		wait for CLK_PERIOD/2;

   end process;

	fpga_cclk <= int_clk when config = '1' else '0';
	
-- ***************** Generate FPGA I/O Derived CLK Process *******************   
   gen_io_clk : process
   begin
		io_clk <= '1';
		wait for CLK_PERIOD/2;
		io_clk <= '0';
		wait for CLK_PERIOD/2;

   end process;

	fpga_io_clk <= io_clk when io_clk_go = '1' else '0';
	
-- ******************************* Main Process ******************************   
   test_process : process
   begin
		fpga_io_sn		<= '1';
		fpga_io_wn		<= '1';
		fpga_io_holdn	<= '1';
		io_clk_go		<= '0';
		ext_spi			<= '0';
		config			<= '0';
		
		-- initial board power up conditions
		fpga_init		<= '0';
		fpga_done		<= '0';
		
		-- ***************** Power Up *****************
		-- SPI Flash Vcc rises to 1.0V during power up (to Vwi)
		vcc			<= 2.5;		
		
		-- SPI Flash Vcc reaches 2.7V after delay during power up
		wait for 5 us;
		vcc	<= 3.0;
		
		-- init goes high 10 us after Vcc(min) is reached for Flash (2.7V)
		wait for 10 us;
		fpga_init	<= '1';
		
		-- cclk output delay is 0.5us min after init goes high per Spartan-IIE
		-- data sheet
		wait for 0.5 us;
		config <= '1';


		-- ******* Begin Configuration of FPGA ********
		--	FPGA initializes
		wait until int_clk = '0';
		
		-- FPGA initialization done
		wait for 200 ns;
		wait until int_clk = '0';
		fpga_init	<= '1';

		-- Configure FPGA
		wait for 10 us;
		
		-- FPGA Configuration complete
		wait until int_clk = '0';
		fpga_done <= '1';
		wait until int_clk = '0';
		config <= '0';
		
		
		
		-- ******* Begin Re-configuration of FPGA ********
		--	FPGA initializes
		wait for 10 us;
		wait until int_clk = '0';
		fpga_init	<= '0';
		fpga_done	<= '0';
		
		-- FPGA initialization done
		wait for 200 ns;
		wait until int_clk = '0';
		fpga_init	<= '1';
		config <= '1';

		-- Re-configure FPGA
		wait for 10 us;
		
		-- FPGA Re-configuration complete
		wait until int_clk = '0';
		fpga_done <= '1';
		wait until int_clk = '0';
		config <= '0';
		
		
		
		-- ******* Read data from SPI using FPGA (CPLD Buffered Mode) ********
		--	FPGA initializes
		wait for 10 us;
		wait until io_clk = '0';
		fpga_init		<= '1';	-- fpga_init is data output of FPGA at this point
		fpga_done		<= '1';
		fpga_io_sn		<= '1';
		fpga_io_wn		<= '1';
		fpga_io_holdn	<= '1';
		
		
		-- Begin SPI transaction
		wait for 200 ns;
		wait until io_clk = '0';
		fpga_io_sn		<= '0';
		io_clk_go <= '1';

		-- Shift in read instruction (FAST READ)
		for i in 7 downto 0 loop
			fpga_init <= READ_INSTRUCTION(i);
			wait until io_clk = '1';
			wait until io_clk = '0';
		end loop;
		
		-- Shift in start address
		for i in 23 downto 0 loop
			fpga_init <= START_ADDRESS(i);
			wait until io_clk = '1';
			wait until io_clk = '0';
		end loop;
		
		-- Shift in dummy byte
		for i in 7 downto 0 loop
			fpga_init <= '0';
			wait until io_clk = '1';
			wait until io_clk = '0';
		end loop;
		
		-- Re-configure FPGA
		wait for 10 us;
		
		-- FPGA Re-configuration complete
		wait until io_clk = '0';
		io_clk_go <= '0';
		fpga_io_sn		<= '1';
		
		
		-- ******* CPLD in benign mode so SPI memory can be programmed ********
		wait for 10 us;
		ext_spi			<= '1';
		wait for 10 us;
		ext_spi			<= '0';

		wait;

   end process;


--	***************************** Instantiations *****************************	
	spicpld: spi_cpld
	port map (	fpga_cclk		=> fpga_cclk,
					fpga_io_clk		=> fpga_io_clk,
					fpga_io_sn		=> fpga_io_sn,
					fpga_io_wn		=> fpga_io_wn,
					fpga_io_holdn	=> fpga_io_holdn,
					fpga_init		=> fpga_init,
					fpga_din			=> fpga_din,
					fpga_done		=> fpga_done,
					spi_c				=> spi_c,
					spi_d				=> spi_d,
					spi_q				=> spi_q,
					spi_sn			=> spi_sn,
					spi_wn			=> spi_wn,
					spi_holdn		=> spi_holdn,
					ext_spi			=> ext_spi
				);


	spimemory: M25P20
	-- memory initializes with user memory content found in init.txt
	generic map (init_file => string'("init.txt"))
	port map ( 	VCC	=> vcc,
					C		=> spi_c,
					D		=> spi_d,
					S		=> spi_sn,
					W		=> spi_wn,
					HOLD	=> spi_holdn,
					Q		=> spi_q
				);


end;