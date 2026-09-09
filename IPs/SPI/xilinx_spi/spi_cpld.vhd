-------------------------------------------------------------------------------- 
-- Copyright (c) 2003 Xilinx, Inc. 
-- All Rights Reserved 
-------------------------------------------------------------------------------- 
--   ____  ____ 
--  /   /\/   / 
-- /___/  \  /   Vendor: Xilinx 
-- \   \   \/    Version: 6.1i SP3
--  \   \        Filename: spi_cpld.vhd 
--  /   /        Date Last Modified:  12/15/2003 
-- /___/   /\    Date Created: 10/2/2003 
-- \   \  /  \ 
--  \___\/\___\ 
-- 
--	Device:	Xilinx 
--
--	Library:	IEEE 
--
--	Purpose:	SPI_CPLD (SPI CPLD controller) maps Xilinx FPGA configuration 
-- 			signals to SPI format so that SPI flash device can be used as
--				configuration memory. The SPI memory can then be used for data
--				storage after configuration by the design loaded into the FPGA. The
--				current (July 2003) generation of Xilinx FPGAs will hold CCLK low
--				after	configuration; the user has to connect an IO pin (defined to
--				function as the SPI clock after configuration) to the CPLD which
--				routes the clock signal to the SPI device.  This code supports the
--				following devices:
--					STMicro Electronics
--					NexFlash
--					PMC
-- 				SST25VF
-- 				SST45LF
-- 			The user can easily define a custom SPI device.
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
--	------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity spi_cpld is
generic (
			------------------------------------------------------------
			------------------------------------------------------------
			-- Set cpld_buffer to 1 when CPLD is used as a buffer between the 
			-- FPGA and the CPLD after the FPGA has been configured.  Set to
			-- 0 to place CPLD in a benign state after the FPGA has been 
			-- configured.
			cpld_buffer			: std_logic					:= '1';

			------------------------------------------------------------
			------------------------------------------------------------
			-- Select the correct parameters from the below table of generics
			--	to support the specific SPI memory in use.
			--
			-- READ_INSTRUCTION		Read instruction
			-- START_ADDRESS			Starting address of data
			--	INSTRUCTION_LENGTH	Number of bits in the instruction
			--	ADDRESS_LENGTH 		Number of bits in the address
			--	DUMMY_LENGTH 			Number of dummy bits after the address.
			--								If no dummy bits required, enter zero.
			--	COUNTER_WIDTH			The counter tracks how many bits have
			--								been shifted out.  This number represents
			--								the width of the counter in bits.  For
			--								example, if the total number of bits shifted
			--								out is 40 (INSTRUCTION_LENGTH + ADDRESS_LENGTH +
			--								DUMMY_LENGTH), the counter must be able to count
			--								to this value.  Therefore the counter width
			--								is 6 bits (2^6 = 64)
			--
			------------------------------------------------------------
			------------------------------------------------------------
			
			------------------------------------------------------------
			-- STMicro Electronics, NexFlash, PMC -- Fast Read
			READ_INSTRUCTION		: std_logic_vector	:= "00001011";		-- 0Bh
			START_ADDRESS			: std_logic_vector	:= "000000000000000000000000";
			INSTRUCTION_LENGTH 	: integer				:= 8;									
			ADDRESS_LENGTH 		: integer				:= 24;								
			DUMMY_LENGTH 			: integer				:= 8;									
			COUNTER_WIDTH 			: integer				:= 6;									
			
			------------------------------------------------------------
			-- STMicro Electronics, NexFlash, PMC, SST25VF -- Standard Read
--			READ_INSTRUCTION		: std_logic_vector	:= "00000011";		-- 03h	
--			START_ADDRESS			: std_logic_vector	:= "000000000000000000000000";
--			INSTRUCTION_LENGTH 	: integer				:= 8;									
--			ADDRESS_LENGTH 		: integer				:= 24;								
--			DUMMY_LENGTH 			: integer				:= 0;									
--			COUNTER_WIDTH 			: integer				:= 5;									
			
			------------------------------------------------------------
			-- SST45LF -- Only Read Speed
--			READ_INSTRUCTION		: std_logic_vector	:= "11111111";		-- FFh			
--			START_ADDRESS			: std_logic_vector	:= "000000000000000000000000";
--			INSTRUCTION_LENGTH 	: integer				:= 8;									
--			ADDRESS_LENGTH 		: integer				:= 24;								
--			DUMMY_LENGTH 			: integer				:= 16;								
--			COUNTER_WIDTH 			: integer				:= 6;									

			------------------------------------------------------------
			-- Atmel -- Only Read Speed
--			READ_INSTRUCTION		: std_logic_vector	:= "11101000";		-- E8h			
--			START_ADDRESS			: std_logic_vector	:= "000000000000000000000000";
--			INSTRUCTION_LENGTH 	: integer				:= 8;									
--			ADDRESS_LENGTH 		: integer				:= 24;								
--			DUMMY_LENGTH 			: integer				:= 24;		
--			COUNTER_WIDTH 			: integer				:= 6;									

			------------------------------------------------------------
			-- User Defined
--			READ_INSTRUCTION		: std_logic_vector	:= "00000000";		-- 00h			
--			START_ADDRESS			: std_logic_vector	:= "000000000000000000000000";
--			INSTRUCTION_LENGTH 	: integer				:= 8;									
--			ADDRESS_LENGTH 		: integer				:= 24;								
--			DUMMY_LENGTH 			: integer				:= 8;									
--			COUNTER_WIDTH 			: integer				:= 6;									
																							
			-- Disregard the below unused integer.
			UNUSED					: integer				:= 0);		
			
			
port(	fpga_cclk		: in		std_logic;
		-----------------------------------------------------------
		-- used when CPLD buffers signals after FPGA configuration.
		fpga_io_clk		: in		std_logic;
		fpga_io_sn		: in		std_logic;
		fpga_io_wn		: in		std_logic;
		fpga_io_holdn	: in		std_logic;
		-----------------------------------------------------------
		fpga_init		: in		std_logic;
		fpga_din			: out		std_logic;
		fpga_done		: in		std_logic;
		spi_c				: out		std_logic;
		spi_d				: out		std_logic;
		spi_q				: in		std_logic;
		spi_sn			: out		std_logic;
		spi_wn			: out		std_logic;
		spi_holdn		: out		std_logic;
		ext_spi			: in		std_logic
	);
end spi_cpld;

architecture Behavioral of spi_cpld is

-- **************************** Components ****************************
-------------------------------------------------------------
-- Variable bit witdth counter used to control SPI read command
-- and SPI read address shift.
-------------------------------------------------------------
component varcount
generic(WIDTH: INTEGER);
port(	cnt_en		: in		STD_LOGIC;	-- Count enable
		clr			: in		STD_LOGIC;	-- Active low clear
		clk			: in		STD_LOGIC;	-- Clock
		qout			: out		STD_LOGIC_VECTOR ((COUNTER_WIDTH-1) downto 0)
	);
end component;	     

-- **************************** Constants ****************************
-- State Machine state definitions
constant STATE_RESET             : STD_LOGIC_VECTOR (2 downto 0)	:= "000";
constant STATE_LOAD_READ_OPCODE  : STD_LOGIC_VECTOR (2 downto 0)	:= "001";
constant STATE_LOAD_READ_ADDRESS : STD_LOGIC_VECTOR (2 downto 0)	:= "010";
constant STATE_READ_DATA         : STD_LOGIC_VECTOR (2 downto 0)	:= "011";
constant STATE_WAIT_STATE        : STD_LOGIC_VECTOR (2 downto 0)	:= "100";

-- Active reset level
constant RESET_ACTIVE 				: std_logic								:= '0';

-- Length of instruction minus 1, e.g. 8 bits instruction - 1 = 7  
constant I_LENGTH			: integer	:= (INSTRUCTION_LENGTH - 1);
constant I_LENGTH_VEC	: std_logic_vector((COUNTER_WIDTH-1) downto 0)	:= conv_std_logic_vector(I_LENGTH,COUNTER_WIDTH);

-- Length of instruction, address and dummy bits 1,
-- (e.g. 8 bit instruction + 24 bit address + 8 dummy bits - 1 = 39)
constant A_LENGTH			: integer	:= (INSTRUCTION_LENGTH + ADDRESS_LENGTH + DUMMY_LENGTH - 1);
constant A_LENGTH_VEC	: std_logic_vector((COUNTER_WIDTH-1) downto 0)	:= conv_std_logic_vector(A_LENGTH,COUNTER_WIDTH);


-- **************************** Signals ****************************
signal pres_state,next_state	: STD_LOGIC_VECTOR (2 downto 0) := "000";

signal s_count					: STD_LOGIC_VECTOR ((COUNTER_WIDTH-1) downto 0);
signal s_spi_sn				: STD_LOGIC;
signal s_cmd_data				: STD_LOGIC;
signal s_instcode				: STD_LOGIC_VECTOR ((INSTRUCTION_LENGTH-1) downto 0);
signal s_addr					: STD_LOGIC_VECTOR ((ADDRESS_LENGTH-1) downto 0);

signal count_en				: STD_LOGIC;	-- counter enable
signal count_rst				: STD_LOGIC;	-- counter reset

signal dummybits				: STD_LOGIC;	-- Sets sending 1's to DIN conditon
signal init_condition		: STD_LOGIC;	-- Detects initialize FPGA condition




begin

	-----------------------------------------------------------------------------
	-- Controls all SPI and FPGA interface pins for various situations
	-----------------------------------------------------------------------------
	io_control: process (fpga_done, fpga_io_clk, fpga_cclk, fpga_init, s_cmd_data, fpga_io_sn, s_spi_sn,
								fpga_io_wn, fpga_io_holdn, dummybits, spi_q, ext_spi)
	begin
		if (cpld_buffer = '1') then				-- CPLD has been configured to be a buffer between SPI and FPGA after configuration
			if (ext_spi = '0') then					-- SPI Flash is ready for operations
				if (fpga_done = '1') then			-- FPGA is finished configuring
					spi_c     <=	fpga_io_clk;	-- SPI clock is from FPGA pin fpga_io_clk when FPGA is done configuring
					spi_d     <=	fpga_init;		-- SPI data is from fpga_init pin (dual purpose pin) when FPGA is done configuring
					spi_sn    <=	fpga_io_sn;		-- SPI select is from FPGA pin fpga_io_sn when FPGA is done configuring
					spi_wn    <=	fpga_io_wn;		-- SPI write protect is from FPGA pin fpga_io_wn when FPGA is done configuring
					spi_holdn <=	fpga_io_holdn;	-- SPI hold is from FPGA I/O pin fpga_io_holdn when FPGA is done configuring

				else										-- FPGA is in the process of configuring
					spi_c     <=	fpga_cclk;		-- SPI clock gets FPGA CCLK during FPGA configuration
					spi_d     <=	s_cmd_data;		-- SPI data gets the command data during FPGA configuration
					spi_sn    <=	s_spi_sn;		-- SPI select is active when appropriate during FPGA configuration
					spi_wn    <=	'1';				-- SPI write protect is inactive during FPGA configuration
					spi_holdn <=	'1';				-- SPI hold is inactive during FPGA configuration

				end if;

				if (dummybits = '1') then
					fpga_din  <=	'1';				-- Benign data sent to FPGA DIN while CPLD sets up SPI for reading data

				else
					fpga_din <= spi_q;				-- SPI data is sent to FPGA DIN after SPI is ready

				end if;
				
			else											-- SPI Flash is programmed from an external source
				spi_c     <=	'Z';					-- SPI clock is high-z during external SPI programming
				spi_d     <=	'Z';					-- SPI data is high-z during external SPI programming
				spi_sn    <=	'Z';					-- SPI select is high-z during external SPI programming
				spi_wn    <=	'1';					-- SPI write protect is high-z during external SPI programming
				spi_holdn <=	'1';					-- SPI hold is high-z during external SPI programming
				fpga_din  <=	'Z';					-- FPGA DIN is high-z during external SPI programming

			end if;
			
		else												-- CPLD has been configured to be a benign after FPGA configuration
			if (ext_spi = '0') then					-- SPI Flash is ready for operations
				if (fpga_done = '1') then			-- FPGA is finished configuring
					spi_c     <=	'Z';				-- SPI clock is high-z when FPGA is done configuring
					spi_d     <=	'Z';				-- SPI data is high-z when FPGA is done configuring
					spi_sn    <=	'Z';				-- SPI select is high-z when FPGA is done configuring
					spi_wn    <=	'Z';				-- SPI write protect is high-z when FPGA is done configuring
					spi_holdn <=	'Z';				-- SPI hold is high-z when FPGA is done configuring
					fpga_din  <=	'Z';				-- DIN is high-z when FPGA is done configuring

				else										-- FPGA is in the process of configuring
					spi_c     <=	fpga_cclk;		-- SPI clock gets FPGA CCLK during FPGA configuration
					spi_d     <=	s_cmd_data;		-- SPI data gets the command data during FPGA configuration
					spi_sn    <=	s_spi_sn;		-- SPI select is active when appropriate during FPGA configuration
					spi_wn    <=	'1';				-- SPI write protect is inactive during FPGA configuration
					spi_holdn <=	'1';				-- SPI hold is inactive during FPGA configuration

					if (dummybits = '1') then
						fpga_din  <=	'1';			-- Benign data sent to FPGA DIN while CPLD sets up SPI for reading data

					else
						fpga_din  <=	spi_q;		-- SPI data is sent to FPGA DIN after SPI is ready

					end if;

				end if;
			
			else											-- SPI Flash is programmed from an external source
				spi_c     <=	'Z';					-- SPI clock is high-z during external SPI programming
				spi_d     <=	'Z';					-- SPI data is high-z during external SPI programming
				spi_sn    <=	'Z';					-- SPI select is high-z during external SPI programming
				spi_wn    <=	'1';					-- SPI write protect is high-z during external SPI programming
				spi_holdn <=	'1';					-- SPI hold is high-z during external SPI programming
				fpga_din  <=	'Z';					-- FPGA DIN is high-z during external SPI programming

			end if;
			
		end if;
	
	end process;

	-------------------------------------------------------------
	-- init_condition allows for the FPGA INIT pin to be used as
	-- user I/O without causing the CPLD to issue data from the
	-- SPI Flash. This could occur when transitions occur on this
	-- dual purpose pin in user mode.
	-------------------------------------------------------------
	init_condition <= '0' when (fpga_init = '0' and fpga_done = '0') else
							'1';																	
																									
																									

	-------------------------------------------------------------
	-- dummybit_ctrl control logic specifies when a HIGH is placed on
	-- the FPGA DIN pin when device initialization occurs.
	-------------------------------------------------------------
	dummybit_ctrl: process (fpga_cclk,init_condition)
	begin
		if (init_condition = RESET_ACTIVE) then
			dummybits <= '1';
		elsif (fpga_cclk'event and fpga_cclk = '0') then
			case pres_state is
				when STATE_RESET =>
					dummybits <= '1';
					
				when STATE_LOAD_READ_OPCODE =>
					dummybits <= '1';
					
				when STATE_LOAD_READ_ADDRESS =>
					dummybits <= '1';
					
				when others =>
					dummybits <= '0';
					
			end case;
		end if;
	end process;


	-------------------------------------------------------------
	-- Registered portion of the state machine.
	-------------------------------------------------------------
	statem_reg: process (fpga_cclk,init_condition, next_state)
	begin
		-- Reset state machine when FPGA INIT and DONE pins goes LOW
		if (init_condition = RESET_ACTIVE) then
			pres_state <= STATE_RESET;
			
		-- State machine is clocked from FPGA CCLK pin
		elsif (fpga_cclk'event and fpga_cclk = '1') then
			pres_state <= next_state;
			
		end if;
	end process;

	-------------------------------------------------------------
	-- Combinatorial portion of the state machine
	-------------------------------------------------------------
	statem_comb: process (pres_state,fpga_done,s_count)
	begin
		-- Default conditions
		count_en <= '0';
		count_rst <= not(RESET_ACTIVE);


		case pres_state is

			-------------------------------------------------------------
			-- Starting state  of configuration.  The state machine leaves
			-- this state when it is recognized the configuration is to 
			-- start which is indicated when the FPGA pin INIT is HIGH and
			-- DONE is LOW.
			-------------------------------------------------------------
			when STATE_RESET =>
				count_rst <= RESET_ACTIVE;
				
				if (fpga_done = '0') then
					next_state <= STATE_LOAD_READ_OPCODE;
				end if;

			-------------------------------------------------------------
			-- Load/shift the SPI flash read instruction.
			-------------------------------------------------------------
			when STATE_LOAD_READ_OPCODE =>
				count_en <= '1';

				if (s_count = I_LENGTH_VEC) then
					next_state <= STATE_LOAD_READ_ADDRESS;
				else
					next_state <= STATE_LOAD_READ_OPCODE;
				end if;

			-------------------------------------------------------------
			-- Load/shift the SPI flash address 
			-- The count continues from the previous state.
			-------------------------------------------------------------
			when STATE_LOAD_READ_ADDRESS =>
				count_en <= '1';

				if (s_count = A_LENGTH_VEC) then
					next_state <= STATE_READ_DATA;
				else
					next_state <= STATE_LOAD_READ_ADDRESS;
				end if;

			-------------------------------------------------------------
			-- Read flash data until FPGA_DONE = 1 at which point the
			-- controller goes to the STATE_WAIT_STATE.
			-------------------------------------------------------------
			when STATE_READ_DATA =>

				if (fpga_done = '1') then
					next_state <= STATE_WAIT_STATE;
				else
					next_state <= STATE_READ_DATA;
				end if;

			-------------------------------------------------------------
			-- Configuration successful (i.e., FPGA_DONE signal = 1).
			-- Wait in this state until the FPGA wishes to reconfigure
			-- as indicated by the FPGA INIT pin going LOW.
			-------------------------------------------------------------
			when STATE_WAIT_STATE =>
				next_state   <= STATE_WAIT_STATE;

			-------------------------------------------------------------
			-- This state catches all undefined states and redirects the
			-- flow to the STATE_RESET state on the next clock.
			-------------------------------------------------------------
			when others =>
				next_state   <= STATE_RESET;

		end case;
	end process;


	-------------------------------------------------------------
	-- SPI flash chip select logic process.  The chip select is
	-- determined on the opposite clock edge as the state machine
	-- to retain proper timing of SPI signals.
	-------------------------------------------------------------
	process (fpga_cclk,init_condition)
	begin
		if (init_condition = RESET_ACTIVE) then
			s_spi_sn <= '1';
		elsif (fpga_cclk'event and fpga_cclk = '0') then
			case pres_state is
				when STATE_LOAD_READ_OPCODE =>
					s_spi_sn <= '0';
				when STATE_LOAD_READ_ADDRESS =>
					s_spi_sn <= '0';
				when STATE_READ_DATA =>
					s_spi_sn <= '0';
				when others =>
					s_spi_sn <= '1';
			end case;
		end if;
	end process;

	-------------------------------------------------------------
	-- instruction and address shift registers. S_CMD_DATA contains
	-- the SPI instruction or address data that is then given to
	-- the SPI D input. Data is shifted on opposite clock edge
	-- as state machine to retain proper timing of SPI signals.
	-------------------------------------------------------------
	process (fpga_cclk,init_condition, s_instcode, s_addr, s_cmd_data)
	begin
		if (init_condition = RESET_ACTIVE) then
			s_instcode	<= READ_INSTRUCTION;
			s_addr		<= START_ADDRESS;
			s_cmd_data	<= s_instcode(INSTRUCTION_LENGTH -1);
		elsif (fpga_cclk'event and fpga_cclk = '0') then
			case pres_state is
				when STATE_LOAD_READ_OPCODE =>
					s_instcode((INSTRUCTION_LENGTH-1) downto 1)	<= s_instcode((INSTRUCTION_LENGTH-2) downto 0);
					s_instcode(0)		<= '0';
					s_cmd_data			<= s_instcode(INSTRUCTION_LENGTH-1);
				when STATE_LOAD_READ_ADDRESS =>
					s_addr((ADDRESS_LENGTH-1) downto 1)		<= s_addr((ADDRESS_LENGTH-2) downto 0);
					s_addr(0)			<= '0';
					s_cmd_data			<= s_addr(ADDRESS_LENGTH-1);
				when others =>
					s_instcode	<= s_instcode;
					s_addr		<= s_addr;
					s_cmd_data	<= s_cmd_data;
			end case;
		end if;
	end process;



	-- ******************* Component Instantiations *******************

	-------------------------------------------------------------
	-- Variable bit witdth counter used to control SPI read command
	-- and SPI read address shift.
	-------------------------------------------------------------
	counter : varcount
	generic map(WIDTH		=> COUNTER_WIDTH)
	port map(	cnt_en	=> count_en,
					clr		=> count_rst,
					clk		=>	fpga_cclk,
					qout		=>	s_count
				);

end Behavioral;