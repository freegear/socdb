-- VHDL Model Created from SGE Symbol dmou.sym -- Jul  9 17:58:10 2003

library IEEE;
   use IEEE.std_logic_1164.all;
   use IEEE.std_logic_misc.all;
   use IEEE.std_logic_arith.all;

entity DMIU is
      Port (    ADDR : In    std_logic_vector (1 downto 0);
              BIGEND : In    std_logic;
             DATA_IN : In    std_logic_vector (31 downto 0);
                  OP : In    std_logic_vector (2 downto 0);
             DATA_OUT : Out   std_logic_vector (31 downto 0) );
end DMIU;

architecture BEHAVIORAL of DMIU is
	--------------------------------
	-- ToyARM 1.0
	-- Author: Oh, kyungsoo
	-- Last updated: 2003.08.07.
	--------------------------------

	-- Constant Variable
	constant C_ZERO8	: std_logic_vector(7 downto 0):=(others=>'0'); 
	constant C_ZERO16	: std_logic_vector(15 downto 0):=(others=>'0'); 
	constant C_ZERO20	: std_logic_vector(19 downto 0):=(others=>'0'); 
	constant C_ZERO24	: std_logic_vector(23 downto 0):=(others=>'0'); 
	
	-- Consider Addressing Mode 3 inst_code(6:5) S,H
    constant OP_DMIU_UBYTE 	: std_logic_vector(2 downto 0):="000"; 
    constant OP_DMIU_SBYTE 	: std_logic_vector(2 downto 0):="010";
    constant OP_DMIU_UHALF  : std_logic_vector(2 downto 0):="001";
    constant OP_DMIU_SHALF  : std_logic_vector(2 downto 0):="011";
    constant OP_DMIU_WORD 	: std_logic_vector(2 downto 0):="100";

	signal s_data_out : std_logic_vector(31 downto 0);


begin

	COMB:process(OP,BIGEND,DATA_IN, ADDR,s_data_out)
--	variable v_sign : std_logic;
	begin
--		v_sign := OP(1);

		s_data_out <= (others=>'0'); -- To avoid latch
        case OP is
        when OP_DMIU_WORD =>
            s_data_out <= DATA_IN;
        when OP_DMIU_UBYTE | OP_DMIU_SBYTE =>
			if(BIGEND='1') then
				case ADDR is
				when "00" => 
					s_data_out(31 downto 24) 	<= DATA_IN(7 downto 0);
				when "01" => 
					s_data_out(23 downto 16) 	<= DATA_IN(7 downto 0);
				when "10" => 
					s_data_out(15 downto 8) 	<= DATA_IN(7 downto 0);
				when "11" => 
					s_data_out(7 downto 0) 		<= DATA_IN(7 downto 0);
				when others =>
					s_data_out(7 downto 0) 		<= DATA_IN(7 downto 0);
				end case;
					
			else -- Little Endian
				case ADDR is
				when "00" => 
					s_data_out(7 downto 0) 		<= DATA_IN(7 downto 0);
				when "01" => 
					s_data_out(15 downto 8) 	<= DATA_IN(7 downto 0);
				when "10" => 
					s_data_out(23 downto 16) 	<= DATA_IN(7 downto 0);
				when "11" => 
					s_data_out(31 downto 24) 	<= DATA_IN(7 downto 0);
				when others =>
					s_data_out(31 downto 24) 	<= DATA_IN(7 downto 0);
				end case;
			end if;
        when OP_DMIU_UHALF | OP_DMIU_SHALF =>
			if(BIGEND='1') then
				case ADDR(1) is
				when '0' => 
					s_data_out(31 downto 16)	<= DATA_IN(15 downto 0);
				when '1' => 
					s_data_out(15 downto 0) 	<= DATA_IN(15 downto 0);
				when others =>
					s_data_out(15 downto 0) 	<= DATA_IN(15 downto 0);
				end case;
			else -- Little Endian
				case ADDR(1) is
				when '0' => 
					s_data_out(15 downto 0) 	<= DATA_IN(15 downto 0);
				when '1' => 
					s_data_out(31 downto 16) 	<= DATA_IN(15 downto 0);
				when others =>
					s_data_out(31 downto 16) 	<= DATA_IN(15 downto 0);
				end case;
			end if;
        when others => null;
        end case;
		DATA_OUT <= s_data_out;

	end process;	
end BEHAVIORAL;

configuration CFG_DMIU of DMIU is
   for BEHAVIORAL

   end for;

end CFG_DMIU;
