-- VHDL Model Created from SGE Symbol pass_wb_data.sym -- Jul  4 12:03:25 2003

library IEEE;
   use IEEE.std_logic_1164.all;
   use IEEE.std_logic_misc.all;
   use IEEE.std_logic_arith.all;

entity PASS_WB_DATA is
      Port (  X2_WR1 : In    std_logic_vector (31 downto 0);
              X2_WR2 : In    std_logic_vector (31 downto 0);
              WB_WR1 : Out   std_logic_vector (31 downto 0);
              WB_WR2 : Out   std_logic_vector (31 downto 0) );
end PASS_WB_DATA;

architecture BEHAVIORAL of PASS_WB_DATA is
	--------------------------------
	-- ToyARM 1.0
	-- Author: Oh, kyungsoo
	-- Last updated: 2003.08.07.
	--------------------------------

	-- Only for aliasing signal name

   begin
	process(X2_WR1,X2_WR2)
	begin
		WB_WR1 <= X2_WR1;
		WB_WR2 <= X2_WR2;
	end process;

end BEHAVIORAL;

configuration CFG_PASS_WB_DATA of PASS_WB_DATA is
   for BEHAVIORAL

   end for;

end CFG_PASS_WB_DATA;
