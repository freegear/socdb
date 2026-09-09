-- VHDL Model Created from SGE Symbol shift.sym -- Jul  4 14:14:07 2003

library IEEE;
   use IEEE.std_logic_1164.all;
   use IEEE.std_logic_misc.all;
   use IEEE.std_logic_arith.all;

entity SHIFT is
      Port ( C_FLAG_IN : In    std_logic;
             EXEC_EN : In    std_logic;
                  OP : In    std_logic_vector (3 downto 0);
                SRC1 : In    std_logic_vector (31 downto 0);
                SRC2 : In    std_logic_vector (8 downto 0);
                 SCO : Out   std_logic;
                   Z : Out   std_logic_vector (31 downto 0) );
end SHIFT;

architecture BEHAVIORAL of SHIFT is
	--------------------------------
	-- ToyARM 1.0
	-- Author: Oh, kyungsoo
	-- Last updated: 2003.08.01.
	--------------------------------

	----------------------------------------------
	-- OP(2 downto 0) :INST_CODE(6 downto 4):
	-- 0000: Logical Shift left by immediate
	-- 0001: Logical Shift left by register
	-- 0010: Logical Shift right by immediate
	-- 0011: Logical Shift right by register
	-- 0100: Arithmetic Shift right by immediate
	-- 0101: Arithmetic Shift right by register
	-- 0110: Rotate right by immediate
	-- 0111: Rotate right by register
	----------------------------------------------

	-- Data Paths are classifed to 3 part.
	-- These are for speed optimization.
	-- 1. Shift Left
	-- 2. Shift Right(Logical & Arithmetic)
	-- 3. Rotate Right
	-- not optimized file is shift.vhd.0801


	-- Source
	signal shift_op : std_logic_vector(3 downto 0); 	-- oks: 030704: inc 2 -> 3
	signal shift_amount : std_logic_vector(8 downto 0); -- oks: 030704: inc 7 -> 8
	signal shift_msb : std_logic;
	signal shift_in: std_logic_vector(32 downto 0);

	-- Result
	signal lsh16_out, lsh8_out, lsh4_out, lsh2_out, lsh_out : std_logic_vector(32 downto 0);
	signal rsh16_out, rsh8_out, rsh4_out, rsh2_out, rsh_out : std_logic_vector(32 downto 0);
	signal ror16_out, ror8_out, ror4_out, ror2_out, ror_out : std_logic_vector(32 downto 0);

begin
	SHIFT_SELECT : process (EXEC_EN, SRC1, SRC2, OP, C_FLAG_IN)
	begin
		if (EXEC_EN = '1') then
		    shift_op <= OP;
			shift_in(32) <= C_FLAG_IN;
			shift_in(31 downto 0) <= SRC1;
		    shift_amount <= SRC2;
			if( OP(2 downto 1) = "10") then -- Arithmetic shift right by immediate or register
				shift_msb <= SRC1(31);
			else
				shift_msb <= '0';
			end if;
		else
			shift_op <= (others=>'0');
			shift_in <= (others => '0');
			shift_amount <= (others=>'0');
			shift_msb <= '0';
		end if;
	end process;


	--
	-- Left Shift Data Path
	--
	LEFT_SHIFT_16 : process (shift_amount, shift_in)
	begin
		if (shift_amount(4) = '1') then
			lsh16_out <= shift_in(16 downto 0) & "0000000000000000";
		else
			lsh16_out <= shift_in;
		end if;
	end process;

	LEFT_SHIFT_8 : process (shift_amount, lsh16_out)
	begin
		if (shift_amount(3) = '1') then
			lsh8_out <= lsh16_out(24 downto 0) & "00000000";
		else
			lsh8_out <= lsh16_out;
		end if;
	end process;

	LEFT_SHIFT_4 : process (shift_amount, lsh8_out)
	begin
		if (shift_amount(2) = '1') then
			lsh4_out <= lsh8_out(28 downto 0) & "0000";
		else
			lsh4_out <= lsh8_out;
		end if;
	end process;

	LEFT_SHIFT_2 : process (shift_amount, lsh4_out)
	begin
		if (shift_amount(1) = '1') then
			lsh2_out <= lsh4_out(30 downto 0) & "00";
		else
			lsh2_out <= lsh4_out;
		end if;
	end process;

	LEFT_SHIFT_1 : process (shift_amount, lsh2_out)
	begin
		if (shift_amount(0) = '1') then
			lsh_out <= lsh2_out(31 downto 0) & '0';
		else
			lsh_out <= lsh2_out;
		end if;
	end process;


	--
	-- Logical & Arithmetic Shift Right Path
	--
	RIGHT_SHIFT_16 : process (shift_amount, shift_msb, shift_in)
	begin
		if (shift_amount(4) = '1') then
			rsh16_out(32) <= shift_in(15);
			rsh16_out(31 downto 16) <= (others => shift_msb);
			rsh16_out(15 downto 0) 	<= shift_in(31 downto 16);
		else
			rsh16_out <= shift_in;
		end if;
	end process;

	RIGHT_SHIFT_8 : process (shift_amount, shift_msb, rsh16_out)
	begin
		if (shift_amount(3) = '1') then
			rsh8_out(32) <= rsh16_out(7);
			rsh8_out(31 downto 24) <= (others => shift_msb);
			rsh8_out(23 downto 0) <= rsh16_out(31 downto 8);
		else
			rsh8_out <= rsh16_out;
		end if;
	end process;

	RIGHT_SHIFT_4 : process (shift_amount, shift_msb, rsh8_out)
	begin
		if (shift_amount(2) = '1') then
			rsh4_out(32) <= rsh8_out(3);
			rsh4_out(31 downto 28) <= (others => shift_msb);
			rsh4_out(27 downto 0) <= rsh8_out(31 downto 4);
		else
			rsh4_out <= rsh8_out;
		end if;
	end process;

	RIGHT_SHIFT_2 : process (shift_amount, shift_msb, rsh4_out)
	begin
		if (shift_amount(1) = '1') then
			rsh2_out(32) <= rsh4_out(1);
			rsh2_out(31 downto 30) <= (others => shift_msb);
			rsh2_out(29 downto 0) <= rsh4_out(31 downto 2);
		else
			rsh2_out <= rsh4_out;
		end if;
	end process;

	RIGHT_SHIFT_1 : process (shift_amount, shift_msb, rsh2_out)
	begin
		if (shift_amount(0) = '1') then
			rsh_out(32) <= rsh2_out(0);
			rsh_out(31) <= shift_msb;
			rsh_out(30 downto 0) <= rsh2_out(31 downto 1);
		else
			rsh_out <= rsh2_out;
		end if;
	end process;


	--
	-- Rotate Right Path
	--
	ROTATE_RIGHT_16 : process (shift_amount, shift_in)
	begin
		if (shift_amount(4) = '1') then
			ror16_out(32) <= shift_in(15);
			ror16_out(31 downto 16) <= shift_in(15 downto 0);
			ror16_out(15 downto 0) 	<= shift_in(31 downto 16);
		else
			ror16_out <= shift_in;
		end if;
	end process;

	ROTATE_RIGHT_8 : process (shift_amount, ror16_out)
	begin
		if (shift_amount(3) = '1') then
			ror8_out(32) <= ror16_out(7);
			ror8_out(31 downto 24) <= ror16_out(7 downto 0);
			ror8_out(23 downto 0)  <= ror16_out(31 downto 8);
		else
			ror8_out <= ror16_out;
		end if;
	end process;

	ROTATE_RIGHT_4 : process (shift_amount, ror8_out)
	begin
		if (shift_amount(2) = '1') then
			ror4_out(32) <= ror8_out(3);
			ror4_out(31 downto 28) <= ror8_out(3 downto 0);
			ror4_out(27 downto 0)  <= ror8_out(31 downto 4);
		else
			ror4_out <= ror8_out;
		end if;
	end process;

	ROTATE_RIGHT_2 : process (shift_amount, ror4_out)
	begin
		if (shift_amount(1) = '1') then
			ror2_out(32) <= ror4_out(1);
			ror2_out(31 downto 30) <= ror4_out(1 downto 0);
			ror2_out(29 downto 0)  <= ror4_out(31 downto 2);
		else
			ror2_out <= ror4_out;
		end if;
	end process;

	ROTATE_RIGHT_1 : process (shift_amount, ror2_out)
	begin
		if (shift_amount(0) = '1') then
			ror_out(32) <= ror2_out(0);
			ror_out(31) <= ror2_out(0);
			ror_out(30 downto 0) <= ror2_out(31 downto 1);
		else
			ror_out <= ror2_out;
		end if;
	end process;



	--
	-- Need more data path optimization!
	--
	
	RESULT_MUX : process (shift_op, C_FLAG_IN, shift_amount, shift_msb, shift_in, rsh_out, lsh_out, ror_out)
	begin
		
		-- Check: 030801
		-- According to manual 
		case shift_op(3 downto 0) is
		when "0000" | "0001" => -- Shift left
			if( shift_amount(7 downto 5) /= "000") then 	-- if shf_amt>=32
				Z <= ( others =>'0');
				if( shift_amount( 7 downto 0) = "00100000") then -- if shf_amt==32
					SCO <= shift_in(0);
				else
					SCO <= '0';
				end if;
			else
				Z <= lsh_out(31 downto 0);
				SCO <= lsh_out(32); 
			end if;
		when "0010" => -- logical Shift right  by imm 
			if( shift_amount(4 downto 0) = "00000") then -- if shf_amt==0
				Z <= (others =>'0');
				SCO <= shift_in(31);
			else
				Z <= rsh_out(31 downto 0);
				SCO <= rsh_out(32); 
			end if;
		when "0011" => -- logical Shift right  by reg
			if( shift_amount(7 downto 5) /= "000") then 	-- if shf_amt>=32
				Z <= (others =>'0');
				if( shift_amount( 7 downto 0) = "00100000") then -- if shf_amt==32
					SCO <= shift_in(31);
				else
					SCO <= '0';
				end if;
			else
				Z <= rsh_out(31 downto 0);
				SCO <= rsh_out(32); 
			end if;
		when "0100"  => -- Arithmetic Shift right  by imm
			if( shift_amount(4 downto 0) = "00000") then 	-- if shf_amt==0
				if(shift_msb='0') then
					Z <= (others =>'0');
				else
					Z <= (others =>'1');
				end if;
				SCO <= shift_in(31);
			else
				Z <= rsh_out(31 downto 0);
				SCO <= rsh_out(32); 
			end if;
		when "0101" => -- Arithmetic Shift right  by reg
			if( shift_amount(7 downto 5) /= "000") then 	-- if shf_amt>=32
				if(shift_msb='0') then
					Z <= (others =>'0');
				else
					Z <= (others =>'1');
				end if;
				SCO <= shift_in(31);
			else
				Z <= rsh_out(31 downto 0);
				SCO <= rsh_out(32); 
			end if;
		when "0110" => -- shift rotate by immediate
			if( shift_amount(4 downto 0) = "00000") then 	-- if shf_amt==0 (5.1.13)
				Z <= C_FLAG_IN & shift_in(31 downto 1);
				SCO <= shift_in(0); 
			else
				Z <= ror_out(31 downto 0);
				SCO <= ror_out(32); 
			end if;
		when "0111" => -- shift rotate by register
			if( shift_amount(7 downto 0) = "00000000") then 	-- if shf_amt==0
				Z <= shift_in(31 downto 0);
				SCO <= shift_in(32);
			elsif( shift_amount( 4 downto 0) = "00000") then 
				Z <= shift_in(31 downto 0);
				SCO <= shift_in(31);
			else
				Z <= ror_out(31 downto 0);
				SCO <= ror_out(32); 
			end if;
		when "1111" => -- A.5.1.3 shift immed*2 rotate by immediate
			Z <= ror_out(31 downto 0);
--			if( shift_amount(8 downto 0) = "000000000") then
			-- DEBUG_030820b: real_rotate_amount = rotate_imm*2
			-- rotate_imm = "0000" => real_rotate_amount = "00000"
			if( shift_amount(4 downto 0) = "00000") then
				SCO <= C_FLAG_IN;
			else
				SCO <= ror_out(31); 
			end if;
		when others =>
				Z <= (others =>'0');
				SCO <= '0';

		end case;
	end process;


end BEHAVIORAL;

configuration CFG_SHIFT of SHIFT is
   for BEHAVIORAL

   end for;

end CFG_SHIFT;
