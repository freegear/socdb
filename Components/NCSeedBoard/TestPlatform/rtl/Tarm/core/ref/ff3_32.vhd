-- VHDL Model Created from SGE Symbol ff4_32.sym -- Jun 27 11:48:25 2003

library IEEE;
   use IEEE.std_logic_1164.all;
   use IEEE.std_logic_misc.all;
   use IEEE.std_logic_arith.all;

entity FF3_32 is
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
end FF3_32;

architecture BEHAVIORAL of FF3_32 is

   begin
	process(CLK,FLUSH,STALL,IN1,IN2,IN3,IN4)
	begin
	if(CLK'event and CLK='1') then
		if(FLUSH='1') then
			OUT1 <= (others=>'0');
			OUT2 <= (others=>'0');
			OUT3 <= (others=>'0');
		elsif(STALL='0') then
			OUT1 <= IN1;
			OUT2 <= IN2;
			OUT3 <= IN3;
		end if;
	end if;
	end process;

end BEHAVIORAL;

configuration CFG_FF3_32 of FF3_32 is
   for BEHAVIORAL

   end for;

end CFG_FF3_32;
