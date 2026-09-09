-- VHDL Model Created from SGE Symbol greg.sym -- Jul 22 16:43:08 2003

library IEEE;
   use IEEE.std_logic_1164.all;
   use IEEE.std_logic_misc.all;
   use IEEE.std_logic_arith.all;

entity GREG is
      Port (     CLK : In    std_logic;
                  D1 : In    std_logic_vector (31 downto 0);
                  D2 : In    std_logic_vector (31 downto 0);
               FLUSH : In    std_logic;
                PC_8 : In    std_logic_vector (31 downto 0);
             PC_8_STALL : In    std_logic;
              RADDR1 : In    std_logic_vector (4 downto 0);
              RADDR2 : In    std_logic_vector (4 downto 0);
              RADDR3 : In    std_logic_vector (4 downto 0);
              RADDR4 : In    std_logic_vector (4 downto 0);
               STALL : In    std_logic;
              WADDR1 : In    std_logic_vector (4 downto 0);
              WADDR2 : In    std_logic_vector (4 downto 0);
                WEN1 : In    std_logic;
                WEN2 : In    std_logic;
                  Q1 : Out   std_logic_vector (31 downto 0);
                  Q2 : Out   std_logic_vector (31 downto 0);
                  Q3 : Out   std_logic_vector (31 downto 0);
                  Q4 : Out   std_logic_vector (31 downto 0) );
end GREG;

architecture BEHAVIORAL of GREG is
	--------------------------------
	-- ToyARM 1.0
	-- Author: Oh, kyungsoo
	-- Last updated: 2003.08.27.
	--------------------------------
	-- OPT_TIME_030902b: Synthesis version

	--
	-- Refer to TOYARM_SPEC1.0 for Register Map
	-- The number of buf_cell is 16 + 2*4 + 7 = 31
	-- DEBUG_030826: For base address forwarding
	-- +1 = 32
	--
    constant reg_no  : integer := 32;
    constant reg_bit : integer := 32;

	subtype reg_word is std_logic_vector(reg_bit-1 downto 0);
	type reg_table is array (natural range <>) of reg_word;
	signal buf_cell  : reg_table(0 to (reg_no-1));

	type reg_sel_array is array (natural range<>) of std_logic;
	signal reg_sel1 : reg_sel_array(0 to (reg_no-1));
	signal reg_sel2 : reg_sel_array(0 to (reg_no-1));

begin

	REG_SEL: process(WADDR1,WADDR2)
	variable address1 : integer range 0 to reg_no-1;
	variable address2 : integer range 0 to reg_no-1;
	begin
		-- OPT_TIME_030813: oks: for time optimization
		address1 := conv_integer(unsigned(WADDR1));
		address2 := conv_integer(unsigned(WADDR2));

		reg_sel1(0) <= '0';
		reg_sel1(1) <= '0';
		reg_sel1(2) <= '0';
		reg_sel1(3) <= '0';
		reg_sel1(4) <= '0';
		reg_sel1(5) <= '0';
		reg_sel1(6) <= '0';
		reg_sel1(7) <= '0';
		reg_sel1(8) <= '0';
		reg_sel1(9) <= '0';
		reg_sel1(10) <= '0';
		reg_sel1(11) <= '0';
		reg_sel1(12) <= '0';
		reg_sel1(13) <= '0';
		reg_sel1(14) <= '0';
		reg_sel1(15) <= '0';
		reg_sel1(16) <= '0';
		reg_sel1(17) <= '0';
		reg_sel1(18) <= '0';
		reg_sel1(19) <= '0';
		reg_sel1(20) <= '0';
		reg_sel1(21) <= '0';
		reg_sel1(22) <= '0';
		reg_sel1(23) <= '0';
		reg_sel1(24) <= '0';
		reg_sel1(25) <= '0';
		reg_sel1(26) <= '0';
		reg_sel1(27) <= '0';
		reg_sel1(28) <= '0';
		reg_sel1(29) <= '0';
		reg_sel1(30) <= '0';
		reg_sel1(31) <= '0';

		reg_sel2(0) <= '0';
		reg_sel2(1) <= '0';
		reg_sel2(2) <= '0';
		reg_sel2(3) <= '0';
		reg_sel2(4) <= '0';
		reg_sel2(5) <= '0';
		reg_sel2(6) <= '0';
		reg_sel2(7) <= '0';
		reg_sel2(8) <= '0';
		reg_sel2(9) <= '0';
		reg_sel2(10) <= '0';
		reg_sel2(11) <= '0';
		reg_sel2(12) <= '0';
		reg_sel2(13) <= '0';
		reg_sel2(14) <= '0';
		reg_sel2(15) <= '0';
		reg_sel2(16) <= '0';
		reg_sel2(17) <= '0';
		reg_sel2(18) <= '0';
		reg_sel2(19) <= '0';
		reg_sel2(20) <= '0';
		reg_sel2(21) <= '0';
		reg_sel2(22) <= '0';
		reg_sel2(23) <= '0';
		reg_sel2(24) <= '0';
		reg_sel2(25) <= '0';
		reg_sel2(26) <= '0';
		reg_sel2(27) <= '0';
		reg_sel2(28) <= '0';
		reg_sel2(29) <= '0';
		reg_sel2(30) <= '0';
		reg_sel2(31) <= '0';

		reg_sel1(address1) <= '1';
		reg_sel2(address2) <= '1';

	end process;

	MAIN : process (CLK)
	begin
		if (CLK'event and CLK = '1') then
			if(FLUSH='1') then
				for i in 0 to (reg_no-1) loop
					buf_cell(i) <= (others=>'0');
				end loop;
			else
				if(STALL='0') then
					if (WEN1 = '1' and reg_sel1(0)='1') then
						buf_cell(0) <= D1;
					end if; 
					if (WEN1 = '1' and reg_sel1(1)='1') then
						buf_cell(1) <= D1;
					end if; 
					if (WEN1 = '1' and reg_sel1(2)='1') then
						buf_cell(2) <= D1;
					end if; 
					if (WEN1 = '1' and reg_sel1(3)='1') then
						buf_cell(3) <= D1;
					end if; 
					if (WEN1 = '1' and reg_sel1(4)='1') then
						buf_cell(4) <= D1;
					end if; 
					if (WEN1 = '1' and reg_sel1(5)='1') then
						buf_cell(5) <= D1;
					end if; 
					if (WEN1 = '1' and reg_sel1(6)='1') then
						buf_cell(6) <= D1;
					end if; 
					if (WEN1 = '1' and reg_sel1(7)='1') then
						buf_cell(7) <= D1;
					end if; 
					if (WEN1 = '1' and reg_sel1(8)='1') then
						buf_cell(8) <= D1;
					end if; 
					if (WEN1 = '1' and reg_sel1(9)='1') then
						buf_cell(9) <= D1;
					end if; 
					if (WEN1 = '1' and reg_sel1(10)='1') then
						buf_cell(10) <= D1;
					end if; 
					if (WEN1 = '1' and reg_sel1(11)='1') then
						buf_cell(11) <= D1;
					end if; 
					if (WEN1 = '1' and reg_sel1(12)='1') then
						buf_cell(12) <= D1;
					end if; 
					if (WEN1 = '1' and reg_sel1(13)='1') then
						buf_cell(13) <= D1;
					end if; 
					if (WEN1 = '1' and reg_sel1(14)='1') then
						buf_cell(14) <= D1;
					end if; 
--					if (WEN1 = '1' and reg_sel1(15)='1') then
--						buf_cell(15) <= D1;
--					end if; 
					if (WEN1 = '1' and reg_sel1(16)='1') then
						buf_cell(16) <= D1;
					end if; 
					if (WEN1 = '1' and reg_sel1(17)='1') then
						buf_cell(17) <= D1;
					end if; 
					if (WEN1 = '1' and reg_sel1(18)='1') then
						buf_cell(18) <= D1;
					end if; 
					if (WEN1 = '1' and reg_sel1(19)='1') then
						buf_cell(19) <= D1;
					end if; 
					if (WEN1 = '1' and reg_sel1(20)='1') then
						buf_cell(20) <= D1;
					end if; 
					if (WEN1 = '1' and reg_sel1(21)='1') then
						buf_cell(21) <= D1;
					end if; 
					if (WEN1 = '1' and reg_sel1(22)='1') then
						buf_cell(22) <= D1;
					end if; 
					if (WEN1 = '1' and reg_sel1(23)='1') then
						buf_cell(23) <= D1;
					end if; 
					if (WEN1 = '1' and reg_sel1(24)='1') then
						buf_cell(24) <= D1;
					end if; 
					if (WEN1 = '1' and reg_sel1(25)='1') then
						buf_cell(25) <= D1;
					end if; 
					if (WEN1 = '1' and reg_sel1(26)='1') then
						buf_cell(26) <= D1;
					end if; 
					if (WEN1 = '1' and reg_sel1(27)='1') then
						buf_cell(27) <= D1;
					end if; 
					if (WEN1 = '1' and reg_sel1(28)='1') then
						buf_cell(28) <= D1;
					end if; 
					if (WEN1 = '1' and reg_sel1(29)='1') then
						buf_cell(29) <= D1;
					end if; 
					if (WEN1 = '1' and reg_sel1(30)='1') then
						buf_cell(30) <= D1;
					end if; 
					if (WEN1 = '1' and reg_sel1(31)='1') then
						buf_cell(31) <= D1;
					end if; 


					if (WEN2 = '1' and reg_sel2(0)='1') then
						buf_cell(0) <= D2;
					end if; 
					if (WEN2 = '1' and reg_sel2(1)='1') then
						buf_cell(1) <= D2;
					end if; 
					if (WEN2 = '1' and reg_sel2(2)='1') then
						buf_cell(2) <= D2;
					end if; 
					if (WEN2 = '1' and reg_sel2(3)='1') then
						buf_cell(3) <= D2;
					end if; 
					if (WEN2 = '1' and reg_sel2(4)='1') then
						buf_cell(4) <= D2;
					end if; 
					if (WEN2 = '1' and reg_sel2(5)='1') then
						buf_cell(5) <= D2;
					end if; 
					if (WEN2 = '1' and reg_sel2(6)='1') then
						buf_cell(6) <= D2;
					end if; 
					if (WEN2 = '1' and reg_sel2(7)='1') then
						buf_cell(7) <= D2;
					end if; 
					if (WEN2 = '1' and reg_sel2(8)='1') then
						buf_cell(8) <= D2;
					end if; 
					if (WEN2 = '1' and reg_sel2(9)='1') then
						buf_cell(9) <= D2;
					end if; 
					if (WEN2 = '1' and reg_sel2(10)='1') then
						buf_cell(10) <= D2;
					end if; 
					if (WEN2 = '1' and reg_sel2(11)='1') then
						buf_cell(11) <= D2;
					end if; 
					if (WEN2 = '1' and reg_sel2(12)='1') then
						buf_cell(12) <= D2;
					end if; 
					if (WEN2 = '1' and reg_sel2(13)='1') then
						buf_cell(13) <= D2;
					end if; 
					if (WEN2 = '1' and reg_sel2(14)='1') then
						buf_cell(14) <= D2;
					end if; 
--					if (WEN2 = '1' and reg_sel2(15)='1') then
--						buf_cell(15) <= D2;
--					end if; 
					if (WEN2 = '1' and reg_sel2(16)='1') then
						buf_cell(16) <= D2;
					end if; 
					if (WEN2 = '1' and reg_sel2(17)='1') then
						buf_cell(17) <= D2;
					end if; 
					if (WEN2 = '1' and reg_sel2(18)='1') then
						buf_cell(18) <= D2;
					end if; 
					if (WEN2 = '1' and reg_sel2(19)='1') then
						buf_cell(19) <= D2;
					end if; 
					if (WEN2 = '1' and reg_sel2(20)='1') then
						buf_cell(20) <= D2;
					end if; 
					if (WEN2 = '1' and reg_sel2(21)='1') then
						buf_cell(21) <= D2;
					end if; 
					if (WEN2 = '1' and reg_sel2(22)='1') then
						buf_cell(22) <= D2;
					end if; 
					if (WEN2 = '1' and reg_sel2(23)='1') then
						buf_cell(23) <= D2;
					end if; 
					if (WEN2 = '1' and reg_sel2(24)='1') then
						buf_cell(24) <= D2;
					end if; 
					if (WEN2 = '1' and reg_sel2(25)='1') then
						buf_cell(25) <= D2;
					end if; 
					if (WEN2 = '1' and reg_sel2(26)='1') then
						buf_cell(26) <= D2;
					end if; 
					if (WEN2 = '1' and reg_sel2(27)='1') then
						buf_cell(27) <= D2;
					end if; 
					if (WEN2 = '1' and reg_sel2(28)='1') then
						buf_cell(28) <= D2;
					end if; 
					if (WEN2 = '1' and reg_sel2(29)='1') then
						buf_cell(29) <= D2;
					end if; 
					if (WEN2 = '1' and reg_sel2(30)='1') then
						buf_cell(30) <= D2;
					end if; 
					if (WEN2 = '1' and reg_sel2(31)='1') then
						buf_cell(31) <= D2;
					end if; 
				end if;

				-- Alwayse Write First
				-- DEBUG_030722c
				if(PC_8_STALL='0') then
					buf_cell(15) <= PC_8;
				end if;
			end if; -- if(STALL='0') then
		end if;
	end process;

	GREG_READ : process (RADDR1, RADDR2, RADDR3,
 						 RADDR4,
						 buf_cell)
		variable address1 : integer range 0 to (reg_no-1);
		variable address2 : integer range 0 to (reg_no-1);
		variable address3 : integer range 0 to (reg_no-1);
 		variable address4 : integer range 0 to (reg_no-1);
	begin
		address1 := conv_integer(unsigned(RADDR1));
		address2 := conv_integer(unsigned(RADDR2));
		address3 := conv_integer(unsigned(RADDR3));
 		address4 := conv_integer(unsigned(RADDR4));

		Q1 <= buf_cell(address1);
		Q2 <= buf_cell(address2);
		Q3 <= buf_cell(address3);
 		Q4 <= buf_cell(address4);
	end process;

end BEHAVIORAL;

configuration CFG_GREG of GREG is
   for BEHAVIORAL

   end for;

end CFG_GREG;
