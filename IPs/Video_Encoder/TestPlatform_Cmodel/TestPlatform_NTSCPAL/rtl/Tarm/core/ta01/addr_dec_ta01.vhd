-- VHDL Model Created from SGE Symbol addr_dec_01.sym -- Sep 15 16:12:30 2003

library IEEE;
   use IEEE.std_logic_1164.all;
   use IEEE.std_logic_misc.all;
   use IEEE.std_logic_arith.all;

entity ADDR_DEC_TA01 is
      Port (     CLK : In    std_logic;
                  DA : In    std_logic_vector (31 downto 0);
              DNMREQ : In    std_logic;
             DNMREQ0 : Out   std_logic;
             DNMREQ1 : Out   std_logic;
             DNMREQ2 : Out   std_logic;
             DNMREQ3 : Out   std_logic );
end ADDR_DEC_TA01;

architecture BEHAVIORAL of ADDR_DEC_TA01 is

   begin
	process(CLK,DA,DNMREQ)
	begin
		DNMREQ0 <= '1';
		DNMREQ1 <= '1';
		DNMREQ2 <= '1';
		DNMREQ3 <= '1';

		-- TOYARM01 Address Map
		-- REQ0: 0x00000000
		-- REQ1: 0x80000000 
		-- REQ2: 0x81000000
		-- REQ3: 0x82000000

		if(DA(31 downto 24)="00000000" ) then 		-- CACHE
			DNMREQ0 <= DNMREQ;
		elsif(DA(31 downto 24)="10000000" ) then 	-- PIO_TA01
			DNMREQ1 <= DNMREQ;
		elsif(DA(31 downto 24)="10000001" ) then 	-- STDIO_TA01
			DNMREQ2 <= DNMREQ;
		elsif(DA(31 downto 24)="10000010" ) then 	-- STDIO_TA01
			DNMREQ3 <= DNMREQ;
		else
			DNMREQ0 <= DNMREQ;
		end if;
			
	end process;

end BEHAVIORAL;

configuration CFG_ADDR_DEC_TA01 of ADDR_DEC_TA01 is
   for BEHAVIORAL

   end for;

end CFG_ADDR_DEC_TA01;
