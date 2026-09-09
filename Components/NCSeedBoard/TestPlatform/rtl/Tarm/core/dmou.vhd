-- VHDL Model Created from SGE Symbol dmou.sym -- Aug 13 15:27:39 2003

library IEEE;
   use IEEE.std_logic_1164.all;
   use IEEE.std_logic_misc.all;
   use IEEE.std_logic_arith.all;

entity DMOU is
      Port (    ADDR : In    std_logic_vector (1 downto 0);
              BIGEND : In    std_logic;
             DATA_IN : In    std_logic_vector (31 downto 0);
                  OP : In    std_logic_vector (2 downto 0);
             DATA_OUT : Out   std_logic_vector (31 downto 0);
             X2_ADDR : Out   std_logic_vector (31 downto 0) );
end DMOU;

architecture BEHAVIORAL of DMOU is
	--------------------------------
	-- ToyARM 1.0
	-- Author: Oh, kyungsoo
	-- Last updated: 2003.08.07.
	--------------------------------

	-- OPT_TIME_030903b: Use Default value
	-- OPT_TIME_030903c: Use Case statement instead of If statement
	-- OPT_TIME_030904c: Support only Little endian

	-- Constant Variable
	constant C_ZERO8	: std_logic_vector(7 downto 0):=(others=>'0'); 
	constant C_ZERO16	: std_logic_vector(15 downto 0):=(others=>'0'); 
	constant C_ZERO20	: std_logic_vector(19 downto 0):=(others=>'0'); 
	constant C_ZERO24	: std_logic_vector(23 downto 0):=(others=>'0'); 
	
	-- Consider Addressing Mode 3 inst_code(6:5) S,H
    constant OP_DMOU_UBYTE 	: std_logic_vector(2 downto 0):="000"; 
    constant OP_DMOU_SBYTE 	: std_logic_vector(2 downto 0):="010";
    constant OP_DMOU_UHALF  : std_logic_vector(2 downto 0):="001";
    constant OP_DMOU_SHALF  : std_logic_vector(2 downto 0):="011";
    constant OP_DMOU_WORD 	: std_logic_vector(2 downto 0):="100";
	-- DEBUG_080328: For LDMs
	-- LDMs ignores the least significant two bits of address
    constant OP_DMOU_WORD_M	: std_logic_vector(2 downto 0):="101";

	signal s_data_out : std_logic_vector(31 downto 0);

	-- OPT_TIME_0813b: If, target is PC
	signal s_x2_addr : std_logic_vector(31 downto 0);

begin

	COMB:process(OP, DATA_IN, ADDR, s_data_out, s_x2_addr)
	variable v_sign : std_logic;
	begin
		v_sign := OP(1);

		-- Default Value
		s_data_out <= DATA_IN; -- To avoid latch
		s_x2_addr  <= DATA_IN;

		-- OPT_TIME_030903b: Use Default value
-- 		if(OP=OP_DMOU_WORD_M) then
--			s_data_out <= DATA_IN;
--			s_x2_addr  <= DATA_IN;

-- 		elsif(OP=OP_DMOU_WORD) then
		case OP is
 		when OP_DMOU_WORD =>
			case ADDR is
			when "00" => 
				s_data_out <= DATA_IN;
				s_x2_addr  <= DATA_IN;
			when "01" => -- Rotate Right 8 
				s_data_out <= DATA_IN(7 downto 0) & DATA_IN(31 downto 8);
				s_x2_addr <= DATA_IN(7 downto 0) & DATA_IN(31 downto 8);
			when "10" => -- Rotate Right 16 
				s_data_out <= DATA_IN(15 downto 0) & DATA_IN(31 downto 16);
				s_x2_addr <= DATA_IN(15 downto 0) & DATA_IN(31 downto 16);
			-- OPT_TIME_030903b: Use Default value
--			when "11" => -- Rotate Right 16 
--				s_data_out <= DATA_IN(23 downto 0) & DATA_IN(31 downto 24);
--				s_x2_addr <= DATA_IN(23 downto 0) & DATA_IN(31 downto 24);
			when others =>
				s_data_out <= DATA_IN(23 downto 0) & DATA_IN(31 downto 24);
				s_x2_addr <= DATA_IN(23 downto 0) & DATA_IN(31 downto 24);
			end case;

	  	when OP_DMOU_UBYTE | OP_DMOU_SBYTE => -- unsigned byte
--			if(BIGEND='1') then
--				case ADDR is
--				when "00" => 
--					s_data_out(7 downto 0) <= DATA_IN(31 downto 24);
--				when "01" => 
--					s_data_out(7 downto 0) <= DATA_IN(23 downto 16);
--				when "10" => 
--					s_data_out(7 downto 0) <= DATA_IN(15 downto 8);
--				when "11" => 
--					s_data_out(7 downto 0) <= DATA_IN(7 downto 0);
--				when others =>
--					s_data_out(7 downto 0) <= DATA_IN(7 downto 0);
--				end case;
					
--			else -- Little Endian
				case ADDR is
				when "00" => 
					s_data_out(7 downto 0) <= DATA_IN(7 downto 0);
				when "01" => 
					s_data_out(7 downto 0) <= DATA_IN(15 downto 8);
				when "10" => 
					s_data_out(7 downto 0) <= DATA_IN(23 downto 16);
--				when "11" => 
--					s_data_out(7 downto 0) <= DATA_IN(31 downto 24);
				when others =>
					s_data_out(7 downto 0) <= DATA_IN(31 downto 24);
				end case;
--			end if;

			-- sign bit(31 downto 8)
			if(v_sign='1') then
				s_data_out(31 downto 8) <= (others=>s_data_out(7));
			else
				s_data_out(31 downto 8) <= (others=>'0');
			end if;
	  	when OP_DMOU_UHALF | OP_DMOU_SHALF =>
--			if(BIGEND='1') then
--				case ADDR(1) is
--				when '0' => 
--					s_data_out(15 downto 0) <= DATA_IN( 31 downto 16);
--				when '1' => 
--					s_data_out(15 downto 0) <= DATA_IN( 15 downto 0);
--				when others =>
--					s_data_out(15 downto 0) <= DATA_IN( 15 downto 0);
--				end case;
--			else -- Little Endian
				case ADDR(1) is
				when '0' => 
					s_data_out(15 downto 0) <= DATA_IN( 15 downto 0);
--				when '1' => 
--					s_data_out(15 downto 0) <= DATA_IN( 31 downto 16);
				when others =>
					s_data_out(15 downto 0) <= DATA_IN( 31 downto 16);
				end case;
--			end if;
			-- sign bit(31 downto 16)
			if(v_sign='1') then
				s_data_out(31 downto 16) <= (others=>s_data_out(15));
			else
				s_data_out(31 downto 16) <= (others=>'0');
			end if;

		when others =>
			s_data_out <= DATA_IN; -- To avoid latch
			s_x2_addr  <= DATA_IN;

		end case;

		DATA_OUT <= s_data_out;
		X2_ADDR  <= s_x2_addr;

	end process;	
end BEHAVIORAL;

configuration CFG_DMOU of DMOU is
   for BEHAVIORAL

   end for;

end CFG_DMOU;
