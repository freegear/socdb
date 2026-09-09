-- VHDL Model Created from SGE Symbol ddin_sel.sym -- Sep 15 16:33:54 2003

library IEEE;
   use IEEE.std_logic_1164.all;
   use IEEE.std_logic_misc.all;
   use IEEE.std_logic_arith.all;

entity DDIN_SEL_TA01 is
      Port (     CLK : In    std_logic;
               DDIN0 : In    std_logic_vector (31 downto 0);
               DDIN1 : In    std_logic_vector (31 downto 0);
               DDIN2 : In    std_logic_vector (31 downto 0);
               DDIN3 : In    std_logic_vector (31 downto 0);
             DNMREQ0 : In    std_logic;
             DNMREQ1 : In    std_logic;
             DNMREQ2 : In    std_logic;
             DNMREQ3 : In    std_logic;
                DDIN : Out   std_logic_vector (31 downto 0) );
end DDIN_SEL_TA01;

architecture BEHAVIORAL of DDIN_SEL_TA01 is

	signal cur_ddin,next_ddin:std_logic_vector(1 downto 0);

   begin
	process(CLK)
	begin
	if(CLK'event and CLK='1') then
		cur_ddin <= next_ddin;
	end if;
	end process;

	process(CLK,DNMREQ0,DNMREQ1,DNMREQ2,DNMREQ3,DDIN0,DDIN1,DDIN2,DDIN3,cur_ddin)
	begin

	next_ddin <= cur_ddin;

	-- data out is one clock delayed!
	if(DNMREQ0 = '0') then
		next_ddin <= "00";
	elsif(DNMREQ1 = '0') then
		next_ddin <= "01";
	elsif(DNMREQ2 = '0') then
		next_ddin <= "10";
	elsif(DNMREQ3 = '0') then
		next_ddin <= "11";
	end if;

	case cur_ddin is
	when "00" => 	
		DDIN <= DDIN0;
	when "01" => 	
		DDIN <= DDIN1;
	when "10" => 	
		DDIN <= DDIN2;
	when "11" => 	
		DDIN <= DDIN3;
	when others =>
		DDIN <= DDIN0;
	end case;

	end process;

end BEHAVIORAL;

configuration CFG_DDIN_SEL_TA01 of DDIN_SEL_TA01 is
   for BEHAVIORAL

   end for;

end CFG_DDIN_SEL_TA01;
