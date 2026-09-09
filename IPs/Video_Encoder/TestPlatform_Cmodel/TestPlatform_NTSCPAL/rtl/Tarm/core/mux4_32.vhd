library IEEE;
   use IEEE.std_logic_1164.all;
   use IEEE.std_logic_arith.all;
   use IEEE.std_logic_misc.all;

entity MUX4_32 is
      Port ( SEL : In    std_logic_vector(1 downto 0);
             IN1 : In    std_logic_vector (31 downto 0);
             IN2 : In    std_logic_vector (31 downto 0);
             IN3 : In    std_logic_vector (31 downto 0);
             IN4 : In    std_logic_vector (31 downto 0);
             OUT1 : Out   std_logic_vector (31 downto 0)
		    );
end MUX4_32;

architecture BEHAVIORAL of MUX4_32 is
	--------------------------------
	-- ToyARM 1.0
	-- Author: Oh, kyungsoo
	-- Last updated: 2003.08.07.
	--------------------------------
begin
	process (SEL,IN1,IN2,IN3,IN4)
	begin
		case SEL is
		when "00" =>
			OUT1 <= IN1;
		when "01" =>
			OUT1 <= IN2;
		when "10" =>
			OUT1 <= IN3;
		when "11" =>
			OUT1 <= IN4;
		when others =>
			OUT1 <= IN1;
		end case;
	end process;
end BEHAVIORAL;

configuration CFG_MUX4_32 of MUX4_32 is
   for BEHAVIORAL

   end for;

end CFG_MUX4_32;
