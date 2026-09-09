
-- Synopsis: 
--	This design implements an AHB slave peripheral which contains a
--	simple bank of 8 registers.  The register bank is intended to 
--	interface with a DMA controller and a VGA driver which used in 
--	conjunction with each other support driving still images and 
--	video from external SDRAM or any other memory source within
--	the system address space.
-- 
-- Documentation:
--	See video_driver.doc for more information on the register map and
--	the functions associated with individual registers.
--

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY slave_interface IS
	PORT (
	
		-- AHB interface
		hresetn		: IN std_logic;
		hclock		: IN std_logic;
		hwrite		: IN std_logic;
		hsel		: IN std_logic;
		htrans		: IN std_logic_vector(1 downto 0);
		hsize		: IN std_logic_vector(1 downto 0);
		hburst		: IN std_logic_vector(2 downto 0);
		haddress	: IN std_logic_vector(31 downto 0);
		hwdata		: IN std_logic_vector(31 downto 0);
		hready		: OUT std_logic;
		hresp		: OUT std_logic_vector(1 downto 0);
		hrdata		: OUT std_logic_vector(31 downto 0);
		
		-- Inteface to DMA Controller and VGA Driver
		status			: IN std_logic_vector(31 downto 0);
		current_address		: IN std_logic_vector(31 downto 0);
		buffer_address	: OUT std_logic_vector(31 downto 0);
		image_dimensions	: OUT std_logic_vector(31 downto 0);
		control			: OUT std_logic_vector(31 downto 0)
		);
END slave_interface;

ARCHITECTURE rtl OF slave_interface IS
-- Memory Map
-- ADDRESS	NAME			DESCRIPTION
-- 0x00		buffer_addr		This register contains the address from which the DMA 
--							should begin an image xfer from 
-- 0x04		image_dimensions	This address contains the number of lines in the image and
--								the numbe of pixels per line
-- 0x08		control_reg		This register is used to enable or disable the DMA, and 
--							clear or enable IRQs
-- 0x0C		current_address		The current address that the DMA is reading from
-- 0x10		status			This register is used to check the current status of the DMA
-- 0x14		reserved		Reserved for future use
-- 0x18		reserved		Reserved for future use
-- 0x1C		reserved		Reserved for future use

	SIGNAL buffer_address_reg	: std_logic_vector(31 downto 0);
	SIGNAL image_dimensions_reg	: std_logic_vector(31 downto 0);
	SIGNAL control_reg		: std_logic_vector(31 downto 0);

	SIGNAL internal_write	: std_logic;
	SIGNAL internal_address	: std_logic_vector(2 downto 0);

	TYPE state_type IS (address,data);
	SIGNAL state : state_type;
	
BEGIN

-- We are always ready and we always respond with an OKAY repsponces to the initiating master.
hready <= '1';
hresp <= "00";

-- Create a FSM to control the internal read and write signals to the register bank.
PROCESS(hclock,hresetn)
BEGIN
	IF hresetn = '0' THEN
		internal_write <= '0';
		state <= address;
	ELSIF rising_edge(hclock) THEN
		CASE state IS 
			WHEN address =>
				IF hsel = '1' AND htrans = "10" THEN
					IF hwrite = '1' THEN
						internal_write <= '1';
					ELSE
						internal_write <= '0';
					END IF;					
					state <= data;
				ELSE
					internal_write <= '0';
					state <= address;
				END IF;
			WHEN data =>
				-- Remain in data state on burst transfers
				IF htrans = "11" THEN
					IF hwrite = '1' THEN
						internal_write <= '1';
					ELSE
						internal_write <= '0';
					END IF;
					state <= data;
				ELSE
					internal_write <= '0';
					state <= address;
				END IF;
			WHEN others =>
				internal_write <= '0';
				state <= address;
		END CASE;
	END IF;
END PROCESS;


-- Create the Register Bank
PROCESS(hclock,hresetn)
BEGIN
	IF hresetn = '0' THEN
		internal_address <=(others => '0');
		buffer_address_reg <= (others => '0');
		image_dimensions_reg <= (others => '0');
		control_reg <= (others => '0');
		hrdata <= (others => '0');
	ELSIF rising_edge(hclock) THEN
		internal_address <= haddress(4 downto 2);
		IF internal_write = '1' THEN
			CASE internal_address IS
				WHEN "000" =>
					buffer_address_reg <= hwdata;
				WHEN "001" =>
					image_dimensions_reg <= hwdata;
				WHEN "010" =>
					control_reg <= hwdata;
				-- Not all of the registers are writeable.  This design does not
				-- return any errors if the processor tries to write to a non-
				-- writeable register.  Instead the design will ignore writes to
				-- non-writeable registers.
				WHEN others =>
					null;
			END CASE;										
		END IF;
		IF hsel = '1' AND hwrite = '0' THEN
			CASE haddress(4 downto 2) IS
				WHEN "000" =>
					hrdata <= buffer_address_reg;
				WHEN "001" =>
					hrdata <= image_dimensions_reg;	
				WHEN "010" =>
					hrdata <= control_reg;	
				WHEN "011" =>
					hrdata <= current_address;	
				WHEN "100" =>
					hrdata <= status;
				WHEN "101" =>
					hrdata <= (others => '0');					
				WHEN "110" =>
					hrdata <= (others => '0');
				WHEN "111" =>
					hrdata <= (others => '0');
				WHEN others =>
					hrdata <= (others => '0');			
			END CASE;	
		END IF;
	END IF;
END PROCESS;

-- These registers get assigned to output pins because they are used by the DMA controller 
-- and the VGA driver
buffer_address <= buffer_address_reg;
image_dimensions <= image_dimensions_reg;
control <= control_reg;

END rtl;