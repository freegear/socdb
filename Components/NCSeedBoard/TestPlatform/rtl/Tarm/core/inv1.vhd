-- VHDL Model Created from SGE Symbol inv1.sym -- Jul  4 11:15:40 2003

library IEEE;
   use IEEE.std_logic_1164.all;
   use IEEE.std_logic_misc.all;
   use IEEE.std_logic_arith.all;

entity INV1 is
      Port (     IN1 : In    std_logic;
                OUT1 : Out   std_logic );
end INV1;

architecture BEHAVIORAL of INV1 is
	--------------------------------
	-- ToyARM 1.0
	-- Author: Oh, kyungsoo
	-- Last updated: 2003.08.07.
	--------------------------------

   begin
	process(IN1)
	begin
		OUT1 <= not IN1;
	end process;

end BEHAVIORAL;

configuration CFG_INV1 of INV1 is
   for BEHAVIORAL

   end for;

end CFG_INV1;
