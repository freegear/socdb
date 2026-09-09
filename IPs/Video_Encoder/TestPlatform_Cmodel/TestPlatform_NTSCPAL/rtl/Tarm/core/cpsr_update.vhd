-- VHDL Model Created from SGE Symbol cpsr_update.sym -- Jul  1 15:16:54 2003

library IEEE;
   use IEEE.std_logic_1164.all;
   use IEEE.std_logic_misc.all;
   use IEEE.std_logic_arith.all;

entity CPSR_UPDATE is
      Port ( CPSR210 : In    std_logic_vector (27 downto 0);
              CPSR_F : In    std_logic_vector (3 downto 0);
                CPSR : Out   std_logic_vector (31 downto 0) );
end CPSR_UPDATE;

architecture BEHAVIORAL of CPSR_UPDATE is
	--------------------------------
	-- ToyARM 1.0
	-- Author: Oh, kyungsoo
	-- Last updated: 2003.08.07.
	--------------------------------

   begin
	process(CPSR210,CPSR_F)
	begin
		CPSR <= CPSR_F & CPSR210;

	end process;

end BEHAVIORAL;

configuration CFG_CPSR_UPDATE of CPSR_UPDATE is
   for BEHAVIORAL

   end for;

end CFG_CPSR_UPDATE;
