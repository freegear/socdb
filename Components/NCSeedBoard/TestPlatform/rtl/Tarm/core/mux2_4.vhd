-- VHDL Model Created from SGE Symbol mux3_32.sym -- Jun 27 14:13:54 2003

library IEEE;
   use IEEE.std_logic_1164.all;
   use IEEE.std_logic_misc.all;
   use IEEE.std_logic_arith.all;

entity MUX2_4 is
      Port (     IN1 : In    std_logic_vector (3 downto 0);
                 IN2 : In    std_logic_vector (3 downto 0);
                 SEL : In    std_logic;
                OUT1 : Out   std_logic_vector (3 downto 0) );
end MUX2_4;

architecture BEHAVIORAL of MUX2_4 is
	--------------------------------
	-- ToyARM 1.0
	-- Author: Oh, kyungsoo
	-- Last updated: 2003.08.07.
	--------------------------------

   begin
	process (SEL,IN1,IN2)
	begin
		case SEL is
		when '0' =>
			OUT1 <= IN1;
		when '1' =>
			OUT1 <= IN2;
		when others =>
			OUT1 <= IN1;
		end case;
	end process;

end BEHAVIORAL;

configuration CFG_MUX2_4 of MUX2_4 is
   for BEHAVIORAL

   end for;

end CFG_MUX2_4;
