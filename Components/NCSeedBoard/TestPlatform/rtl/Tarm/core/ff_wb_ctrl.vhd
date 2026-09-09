-- VHDL Model Created from SGE Symbol ff_wb_ctrl.sym -- Jul 11 15:14:47 2003

library IEEE;
   use IEEE.std_logic_1164.all;
   use IEEE.std_logic_misc.all;
   use IEEE.std_logic_arith.all;

entity FF_WB_CTRL is
      Port (     CLK : In    std_logic;
             COND_WOP : In    std_logic_vector (1 downto 0);
             CPSR_WOP : In    std_logic_vector (3 downto 0);
               FLUSH : In    std_logic;
             SPSR_WA : In    std_logic_vector (2 downto 0);
             SPSR_WOP : In    std_logic_vector (3 downto 0);
               STALL : In    std_logic;
                 WA1 : In    std_logic_vector (4 downto 0);
                 WA2 : In    std_logic_vector (4 downto 0);
                WOP1 : In    std_logic_vector (5 downto 0);
                WOP2 : In    std_logic_vector (5 downto 0);
             COND_WOP_F : Out   std_logic_vector (1 downto 0);
             CPSR_WOP_F : Out   std_logic_vector (3 downto 0);
             SPSR_WA_F : Out   std_logic_vector (2 downto 0);
             SPSR_WOP_F : Out   std_logic_vector (3 downto 0);
               WA1_F : Out   std_logic_vector (4 downto 0);
               WA2_F : Out   std_logic_vector (4 downto 0);
              WOP1_F : Out   std_logic_vector (5 downto 0);
              WOP2_F : Out   std_logic_vector (5 downto 0) );
end FF_WB_CTRL;

architecture BEHAVIORAL of FF_WB_CTRL is
	--------------------------------
	-- ToyARM 1.0
	-- Author: Oh, kyungsoo
	-- Last updated: 2003.08.07.
	--------------------------------

   begin
	process(CLK)
	begin
		if(CLK'event and CLK='1') then
			if(FLUSH='1') then
				CPSR_WOP_F <= (others=>'0');
				SPSR_WOP_F <= (others=>'0');
				SPSR_WA_F <= (others=>'0');
				WA1_F <= (others=>'0');
				WA2_F <= (others=>'0');
				WOP1_F <= (others=>'0');
				WOP2_F <= (others=>'0');
				COND_WOP_F <= (others=>'0');
			elsif(STALL='0') then
				CPSR_WOP_F <= CPSR_WOP; 
				SPSR_WOP_F <= SPSR_WOP;
				SPSR_WA_F <= SPSR_WA;
				WA1_F <= WA1;
				WA2_F <= WA2;
				WOP1_F <= WOP1;
				WOP2_F <= WOP2;
				COND_WOP_F <= COND_WOP;
			end if;
		end if;
	end process;

end BEHAVIORAL;

configuration CFG_FF_WB_CTRL of FF_WB_CTRL is
   for BEHAVIORAL

   end for;

end CFG_FF_WB_CTRL;
