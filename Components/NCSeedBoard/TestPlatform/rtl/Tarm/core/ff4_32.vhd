-- VHDL Model Created from SGE Symbol ff4_32.sym -- Jun 27 11:48:25 2003

library IEEE;
   use IEEE.std_logic_1164.all;
   use IEEE.std_logic_misc.all;
   use IEEE.std_logic_arith.all;

entity FF4_32 is
      Port (     CLK : In    std_logic;
               FLUSH : In    std_logic;
                 IN1 : In    std_logic_vector (31 downto 0);
                 IN2 : In    std_logic_vector (31 downto 0);
                 IN3 : In    std_logic_vector (31 downto 0);
                 IN4 : In    std_logic_vector (31 downto 0);
               STALL : In    std_logic;
                OUT1 : Out   std_logic_vector (31 downto 0);
                OUT2 : Out   std_logic_vector (31 downto 0);
                OUT3 : Out   std_logic_vector (31 downto 0);
                OUT4 : Out   std_logic_vector (31 downto 0) );
end FF4_32;

architecture BEHAVIORAL of FF4_32 is
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
			OUT2 <= (others=>'0');
			OUT3 <= (others=>'0');
			OUT4 <= (others=>'0');
		elsif(STALL='0') then
			OUT1 <= IN1;
			OUT2 <= IN2;
			OUT3 <= IN3;
			OUT4 <= IN4;
		end if;
	end if;
	end process;

end BEHAVIORAL;

configuration CFG_FF4_32 of FF4_32 is
   for BEHAVIORAL

   end for;

end CFG_FF4_32;
