-- VHDL Model Created from SGE Symbol alu.sym -- Jun 30 11:01:47 2003

library IEEE;
   use IEEE.std_logic_1164.all;
   use IEEE.std_logic_misc.all;
   use IEEE.std_logic_arith.all;

entity ALU is
      Port ( EXEC_EN : In    std_logic;
             FLAG_IN : In    std_logic_vector (3 downto 0);
                  OP : In    std_logic_vector (3 downto 0);
                  RN : In    std_logic_vector (31 downto 0);
                  RS : In    std_logic_vector (31 downto 0);
                SCIN : In    std_logic;
                ADDR : Out   std_logic_vector (31 downto 0);
             FLAG_OUT : Out   std_logic_vector (3 downto 0);
                  RD : Out   std_logic_vector (31 downto 0) );
end ALU;

architecture BEHAVIORAL of ALU is
	--------------------------------
	-- ToyARM 1.0
	-- Author: Oh, kyungsoo
	-- Last updated: 2003.08.02.
	--------------------------------

	signal alu_op : std_logic_vector(3 downto 0);
	signal src1 : std_logic_vector(32 downto 0);
	signal src2 : std_logic_vector(32 downto 0);
	signal src1c : std_logic_vector(32 downto 0);
	signal src2c : std_logic_vector(32 downto 0);
	signal src1d : std_logic_vector(32 downto 0);
	signal src2d : std_logic_vector(32 downto 0);
	signal result : std_logic_vector(32 downto 0);
	signal arith_result0 : std_logic_vector(32 downto 0);
	signal arith_result1 : std_logic_vector(32 downto 0);
	signal logic_result : std_logic_vector(31 downto 0);
	signal alu_result : std_logic_vector(32 downto 0);
	signal c_flag_in : std_logic;
	signal v_flag_in : std_logic;
	signal n_flag,z_flag,c_flag,v_flag : std_logic;
	-- DEBUG_030820: sign
	signal src1_sign,src2_sign,src1c_sign,src2c_sign: std_logic;


begin
	SRC_SELECT : process (OP, RN, RS, FLAG_IN )
	begin
			-- In current version, Speed optimization is more important than  power optimization 
			-- Thus, I don't use EXEC_EN signal.
			alu_op 	<= OP;

			-- Normal Source
			-- Add most significant bit '0' to detect carry
			src1 	<= '0' & RN;
			src2 	<= '0' & RS;

			-- Inverted source
			src1d   <= '0' & (not RN);
			src2d   <= '0' & (not RS);

			-- 2's Complementary Source
			-- If zero, most significant bit must be '1'.
			-- In case of subtracting 0, there is no borrow and no carry.
			-- But In toyarm alu, the fact that result(32) is '0', means borrow. 
			-- Below adjust can adress this problem.
			src1c(32)	<= '0';
			src1c(31 downto 0) <= unsigned((not RN)) + '1';
			src2c(32)	<= '0';
			src2c(31 downto 0) <= unsigned((not RS)) + '1';

			if(RN="00000000000000000000000000000000" ) then
				src1c <= "100000000000000000000000000000000";
			end if;
			if(RS="00000000000000000000000000000000" ) then
				src2c <= "100000000000000000000000000000000";
			end if;

			-- DEBUG_030820: sign
			-- In case of src2 = 0x80000000 and src2c = 0x80000000,  
			-- src2(31)=src2c(31) but the sign bits must be different!
			src1_sign <= RN(31);
			src2_sign <= RS(31);
			src1c_sign <= not RN(31);
			src2c_sign <= not RS(31);

			-- From FLAG
			c_flag_in <= FLAG_IN(1);
			v_flag_in <= FLAG_IN(0);
	end process;

	ALU_PROCESS : process (alu_op, src1, src2, src1d, src2d, SCIN, c_flag_in, v_flag_in,n_flag,z_flag,c_flag,v_flag,result,src1_sign,src2_sign,src1c_sign,src2c_sign)
	begin
		-- Default Value
		c_flag <= '0';
		v_flag <= '0';
		result <= (others=>'0');
		ADDR   <= (others=>'0');
		case alu_op(3 downto 0) is
			when "0000" =>		-- 4.1.4 AND
				result <= src1 and src2;
				c_flag <= SCIN;
				v_flag <= v_flag_in;
				ADDR   <= result(31 downto 0);
			when "0001" =>		-- 4.1.15 EOR
				result <= src1 xor src2;
				c_flag <= SCIN;
				v_flag <= v_flag_in;
				ADDR   <= result(31 downto 0);
			when "0010" =>		-- 4.1.49 SUB
--				result <= unsigned(src1) + unsigned(src2c);
				result <= unsigned(src1) + unsigned(src2d) + '1';
				c_flag <= result(32); 		
--				if(src1(31)=src2c(31) and src1(31)/=result(31)) then
				-- DEBUG_030820: sign
				if(src1_sign=src2c_sign and src1_sign/=result(31)) then
					v_flag <= '1';
				end if;
				ADDR   <= result(31 downto 0);
			when "0011" =>		-- 4.1.36 RSB
--				result <= unsigned(src2) + unsigned(src1c);
				result <= unsigned(src2) + unsigned(src1d) + '1';
				c_flag <= result(32); 		
				-- DEBUG_030820: sign
				if(src1c_sign=src2_sign and src1c_sign /=result(31)) then
					v_flag <= '1';
				end if;
				ADDR   <= result(31 downto 0);
			when "0100" =>		-- 4.1.3 ADD
				result <= unsigned(src1) + unsigned(src2);
				c_flag <= result(32); 
				if(src1(31)=src2(31) and src1(31)/=result(31)) then
					v_flag <= '1';
				end if;
				ADDR   <= result(31 downto 0);
			when "0101" =>		-- 4.1.2 ADC
				result <= unsigned(src1) + unsigned(src2) + c_flag_in;
				c_flag <= result(32); 
				if(src1(31)=src2(31) and src1(31)/=result(31)) then
					v_flag <= '1';
				end if;
				ADDR   <= result(31 downto 0);
			when "0110" =>		-- 4.1.38 SBC
--				result <= unsigned(src1) + unsigned(src2c) - (not c_flag_in);
				result <= unsigned(src1) + unsigned(src2d) + c_flag_in;
				c_flag <= result(32); 		
				-- DEBUG_030820: sign
				if(src1_sign=src2c_sign and src1_sign/=result(31)) then
					v_flag <= '1';
				end if;
				ADDR   <= result(31 downto 0);
			when "0111" =>		-- 4.1.37 RSC
--				result <= unsigned(src2) + unsigned(src1c) - (not c_flag_in);
				result <= unsigned(src2) + unsigned(src1d) + c_flag_in;
				c_flag <= result(32); 
				-- DEBUG_030820: sign
				if(src1c_sign=src2_sign and src1c_sign/=result(31)) then
					v_flag <= '1';
				end if;
				ADDR   <= result(31 downto 0);
			when "1000" =>		-- 4.1.54 TST
				result <= src1 and src2;
				c_flag <= SCIN;
				v_flag <= v_flag_in;
			when "1001" =>		-- 4.1.53 TEQ
				result <= src1 xor src2;
				c_flag <= SCIN;
				v_flag <= v_flag_in;
			when "1010" =>		-- 4.1.14 CMP
--				result <= unsigned(src1) + unsigned(src2c);
				result <= unsigned(src1) + unsigned(src2d) + '1';
				c_flag <= result(32); 	
				-- DEBUG_030820: sign
				if(src1_sign=src2c_sign and src1_sign/=result(31)) then
					v_flag <= '1';
				end if;
			when "1011" =>		-- 4.1.13 CMN
				result <= unsigned(src1) + unsigned(src2);
				c_flag <= result(32);
				-- DEBUG_030820: sign
				if(src1_sign=src2_sign and src1_sign/=result(31)) then
					v_flag <= '1';
				end if;
			when "1100" =>		-- 4.1.35 ORR
				result <= src1 or src2;
				c_flag <= SCIN;
				v_flag <= v_flag_in;
				ADDR   <= result(31 downto 0);
			when "1101" =>		-- 4.1.29 MOV
				result <= src2;
				c_flag <= SCIN;
				v_flag <= v_flag_in;
				ADDR   <= result(31 downto 0); -- DEBUG_030718
			when "1110" =>		-- 4.1.6 BIC
				result <= src1 and (not src2);
				c_flag <= SCIN;
				v_flag <= v_flag_in;
				ADDR   <= result(31 downto 0);
			when "1111" =>		-- 4.1.34 MVN
				result <= not src2;
				c_flag <= SCIN;
				v_flag <= v_flag_in;
				ADDR   <= result(31 downto 0);
			when others=>
		end case;

		-- N Flag
		n_flag <= result(31);
		-- Z Flag 
		if(result(31 downto 0) = "00000000000000000000000000000000" ) then
			z_flag <= '1';
		else
			z_flag <= '0';
		end if;
		-- NZCV
		FLAG_OUT <= n_flag & z_flag & c_flag & v_flag; 
		RD <= result(31 downto 0);
	end process;

end BEHAVIORAL;

configuration CFG_ALU of ALU is
   for BEHAVIORAL

   end for;

end CFG_ALU;

