LIBRARY IEEE;
USE IEEE.std_logic_arith.all;
USE IEEE.std_logic_unsigned.all;
USE IEEE.std_logic_1164.all;

entity irq_control is
  port ( hclock      : in std_logic; 
         reset_n     : in std_logic;
         siface_hsel : in std_logic;
         siface_haddress_from_stripe : in std_logic_vector(31 downto 0);
         siface_hwrite_from_stripe : in std_logic;
         set_irq : in std_logic;
         irq : out std_logic
       );
end irq_control;

Architecture behavioral of irq_control is
begin

PROCESS(hclock,reset_n)
BEGIN
	IF reset_n = '0' THEN
		irq <= '0';
	ELSIF rising_edge(hclock) THEN
		IF set_irq = '1' THEN
			irq <= '1';
		ELSIF siface_hsel = '1' AND siface_haddress_from_stripe = X"80000000" AND siface_hwrite_from_stripe = '1' THEN
			irq <= '0';
		END IF;
	END IF;
END PROCESS;

end behavioral;
