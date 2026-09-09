-- default_slave.vhd
--
-- This default slave provides a 2-cycle error responce to the requesting master whenever it detects 
-- a NONSEQUENTIAL or SEQUENTIAL transaction.  
--
--			________	________	________	________
-- hclock	________|	|_______|	|_______|	|_______|	|_______
--
--			________________________________
-- hsel		________|				|_______________________________
--
--
--		-------\ /-------------\ /----------------------------------------------
-- htrans		.     NONSEQ	.
--		-------/ \-------------/ \----------------------------------------------	
--		________________________		________________________________
-- hready				|_______________|
--
--		------------------------\ /-----------------------------\ /--------------
-- hresp		OKAY		 .	       ERROR		 .    OKAY
--		------------------------/ \-----------------------------/ \--------------


LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY default_slave IS PORT (
	hclock		: IN std_logic;
	hresetn		: IN std_logic;
	hsel		: IN std_logic;
	htrans		: IN std_logic_vector(1 downto 0);
	hready		: OUT std_logic;
	hresp		: OUT std_logic_vector(1 downto 0);
	hrdata		: OUT std_logic_vector(31 downto 0)	
);
END default_slave;

ARCHITECTURE rtl OF default_slave IS

	TYPE state_type IS (address_phase,error_phase);
	SIGNAL state : state_type;

BEGIN

-- we don't care what gets driven onto hrdata so drive 0's for simplicity
hrdata <= (others => '0');

PROCESS(hclock,hresetn)
BEGIN
	IF hresetn = '0' THEN
		state <= address_phase;
	ELSIF rising_edge(hclock) THEN
		CASE state IS
			WHEN address_phase =>
				IF hsel = '1' THEN
					-- check for SEQ or NONSEQ transaction
					IF htrans = "10" OR htrans = "11" THEN  -- NONSEQ, SEQ  
						state <= error_phase;
						hresp <= "01";  -- ERROR responce
						hready <= '0';
					ELSE
						state <= address_phase;             -- IDLE, BUSY
						hresp <= "00";  -- OKAY responce
						hready <= '1';
					END IF;
				ELSE
					state <= address_phase;
					hresp <= "00";  -- OKAY responce
					hready <= '0';
				END IF;
			WHEN error_phase =>
				state <= address_phase;
				hresp <= "01";  -- ERROR responce
				hready <= '1';
		END CASE;
	END IF;
END PROCESS;

END rtl;