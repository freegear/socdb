----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:03:02 12/01/2006 
-- Design Name: 
-- Module Name:    LED_TEST - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity LED_TEST is
    Port ( CLK, nRST : in  STD_LOGIC;
           LED : out  STD_LOGIC_VECTOR (3 downto 0));
end LED_TEST;

architecture Behavioral of LED_TEST is
	SIGNAL LED_SIG : STD_LOGIC_VECTOR( 3 DOWNTO 0);
	SIGNAL CK : STD_LOGIC;
begin
	PROCESS( CLK, nRST )
		VARIABLE CNT : INTEGER RANGE 0 TO 12500000;
	BEGIN
		IF nRST='0' THEN
			CNT := 0;
			CK <= '0';
		ELSIF RISING_EDGE(CLK) THEN
			IF CNT=12500000 THEN
				CNT:=0;
				CK <= NOT CK;
			ELSE
				CNT := CNT + 1;
			END IF;
		END IF;
	END PROCESS;
	
	PROCESS(CK, nRST)
	BEGIN
		IF nRST='0' THEN
			LED_SIG <= "1110";
		ELSIF RISING_EDGE(CK) THEN
			LED_SIG <= LED_SIG( 2 DOWNTO 0 ) & LED_SIG(3);
		END IF;
	END PROCESS;
	
	LED <= LED_SIG;

end Behavioral;

