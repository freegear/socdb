-- VHDL Model Created from SGE Symbol ff1_4.sym -- Jun 27 11:48:25 2003

library IEEE;
   use IEEE.std_logic_1164.all;
   use IEEE.std_logic_misc.all;
   use IEEE.std_logic_arith.all;

entity FF1_4 is
      Port (     CLK : In    std_logic;
               FLUSH : In    std_logic;
                 IN1 : In    std_logic_vector (3 downto 0);
               STALL : In    std_logic;
                OUT1 : Out   std_logic_vector (3 downto 0));
end FF1_4;

architecture BEHAVIORAL of FF1_4 is
	--------------------------------
	-- ToyARM 1.0
	-- Author: Oh, kyungsoo
	-- Last updated: 2003.08.07.
	--------------------------------

   begin
	process(CLK)
	begin
	if(CLK'event and CLK='1') then
		if(FLUSH='1') then
			OUT1 <= (others=>'0');
		elsif(STALL='0') then
			OUT1 <= IN1;
		end if;
	end if;
	end process;

end BEHAVIORAL;

configuration CFG_FF1_4 of FF1_4 is
   for BEHAVIORAL

   end for;

end CFG_FF1_4;
