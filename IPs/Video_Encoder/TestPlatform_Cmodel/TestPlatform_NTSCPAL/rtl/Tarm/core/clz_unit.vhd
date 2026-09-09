-- VHDL Model Created from SGE Symbol clz_unit.sym -- Jul 30 15:23:19 2003

library IEEE;
   use IEEE.std_logic_1164.all;
   use IEEE.std_logic_misc.all;
   use IEEE.std_logic_arith.all;

entity CLZ_UNIT is
      Port ( EXEC_EN : In    std_logic;
                  RM : In    std_logic_vector (31 downto 0);
                  RD : Out   std_logic_vector (31 downto 0) );
end CLZ_UNIT;

architecture BEHAVIORAL of CLZ_UNIT is
	--------------------------------
	-- ToyARM 1.0
	-- Author: Oh, kyungsoo
	-- Last updated: 2003.08.07.
	--------------------------------

	-- The CLZ(Count Leading Zeros) instruction returns the number of 
	-- binary zero bits before the first binary one bit in a register 
	-- value. The source register is scanned from the most significant 
	-- bit(bit[31]) towards the least significant bit(bit[0]). 
	-- The result is 2 if no bits are set in the source regiser, 
	-- and zero if bit[31] is set.

   begin
	process(RM)
	begin

--	if(RM = "00000000000000000000000000000000" ) then
--		RD <= "0000000000000000" & "00000000" & "00100000"; -- 32
--	elsif(RM(31)='1') then
	if(RM(31)='1') then
		RD <= "0000000000000000" & "00000000" & "00000000"; -- 0
	elsif(RM(30)='1') then
		RD <= "0000000000000000" & "00000000" & "00000001"; -- 1 
	elsif(RM(29)='1') then
		RD <= "0000000000000000" & "00000000" & "00000010"; -- 2
	elsif(RM(28)='1') then
		RD <= "0000000000000000" & "00000000" & "00000011"; -- 3
	elsif(RM(27)='1') then
		RD <= "0000000000000000" & "00000000" & "00000100"; -- 4 
	elsif(RM(26)='1') then
		RD <= "0000000000000000" & "00000000" & "00000101"; -- 5 
	elsif(RM(25)='1') then
		RD <= "0000000000000000" & "00000000" & "00000110"; -- 6 
	elsif(RM(24)='1') then
		RD <= "0000000000000000" & "00000000" & "00000111"; -- 7 
	elsif(RM(23)='1') then
		RD <= "0000000000000000" & "00000000" & "00001000"; -- 8 
	elsif(RM(22)='1') then
		RD <= "0000000000000000" & "00000000" & "00001001"; -- 9 
	elsif(RM(21)='1') then
		RD <= "0000000000000000" & "00000000" & "00001010"; -- 10
	elsif(RM(20)='1') then
		RD <= "0000000000000000" & "00000000" & "00001011"; -- 11
	elsif(RM(19)='1') then
		RD <= "0000000000000000" & "00000000" & "00001100"; -- 12
	elsif(RM(18)='1') then
		RD <= "0000000000000000" & "00000000" & "00001101"; -- 13
	elsif(RM(17)='1') then
		RD <= "0000000000000000" & "00000000" & "00001110"; -- 14
	elsif(RM(16)='1') then
		RD <= "0000000000000000" & "00000000" & "00001111"; -- 15
	elsif(RM(15)='1') then
		RD <= "0000000000000000" & "00000000" & "00010000"; -- 16
	elsif(RM(14)='1') then
		RD <= "0000000000000000" & "00000000" & "00010001"; -- 17
	elsif(RM(13)='1') then
		RD <= "0000000000000000" & "00000000" & "00010010"; -- 18
	elsif(RM(12)='1') then
		RD <= "0000000000000000" & "00000000" & "00010011"; -- 19
	elsif(RM(11)='1') then
		RD <= "0000000000000000" & "00000000" & "00010100"; -- 20
	elsif(RM(10)='1') then
		RD <= "0000000000000000" & "00000000" & "00010101"; -- 21
	elsif(RM(9)='1') then
		RD <= "0000000000000000" & "00000000" & "00010110"; -- 22
	elsif(RM(8)='1') then
		RD <= "0000000000000000" & "00000000" & "00010111"; -- 23
	elsif(RM(7)='1') then
		RD <= "0000000000000000" & "00000000" & "00011000"; -- 24
	elsif(RM(6)='1') then
		RD <= "0000000000000000" & "00000000" & "00011001"; -- 25
	elsif(RM(5)='1') then
		RD <= "0000000000000000" & "00000000" & "00011010"; -- 26
	elsif(RM(4)='1') then
		RD <= "0000000000000000" & "00000000" & "00011011"; -- 27
	elsif(RM(3)='1') then
		RD <= "0000000000000000" & "00000000" & "00011100"; -- 28
	elsif(RM(2)='1') then
		RD <= "0000000000000000" & "00000000" & "00011101"; -- 29
	elsif(RM(1)='1') then
		RD <= "0000000000000000" & "00000000" & "00011110"; -- 30
	elsif(RM(0)='1') then
		RD <= "0000000000000000" & "00000000" & "00011111"; -- 31
	else	--	if(RM = "00000000000000000000000000000000" ) then
		RD <= "0000000000000000" & "00000000" & "00100000"; -- 32
	end if;
	end process;

end BEHAVIORAL;

configuration CFG_CLZ_UNIT of CLZ_UNIT is
   for BEHAVIORAL

   end for;

end CFG_CLZ_UNIT;
