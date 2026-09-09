-- VHDL Model Created from SGE Symbol ff_x2b_ctrl.sym -- Jul 16 15:48:28 2003

library IEEE;
   use IEEE.std_logic_1164.all;
   use IEEE.std_logic_misc.all;
   use IEEE.std_logic_arith.all;

entity FF_X2B_CTRL is
      Port ( ADDR2_SEL : In    std_logic;
             BRANCH2 : In    std_logic;
                 CLK : In    std_logic;
             DMOU_EN : In    std_logic;
             DMOU_OP : In    std_logic_vector (2 downto 0);
               FLUSH : In    std_logic;
               STALL : In    std_logic;
             WCOND_SEL : In    std_logic;
             WCPSR_SEL : In    std_logic_vector (1 downto 0);
             WR1_SEL : In    std_logic_vector (1 downto 0);
             WR2_SEL : In    std_logic_vector (1 downto 0);
             WSPSR_SEL : In    std_logic_vector (1 downto 0);
             ADDR2_SEL_F : Out   std_logic;
             BRANCH2_F : Out   std_logic;
             DMOU_EN_F : Out   std_logic;
             DMOU_OP_F : Out   std_logic_vector (2 downto 0);
             WCOND_SEL_F : Out   std_logic;
             WCPSR_SEL_F : Out   std_logic_vector (1 downto 0);
             WR1_SEL_F : Out   std_logic_vector (1 downto 0);
             WR2_SEL_F : Out   std_logic_vector (1 downto 0);
             WSPSR_SEL_F : Out   std_logic_vector (1 downto 0) );
end FF_X2B_CTRL;

architecture BEHAVIORAL of FF_X2B_CTRL is
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
				DMOU_EN_F<= '0';
				DMOU_OP_F<=(others=>'0');
				BRANCH2_F<='0';
				WCOND_SEL_F<='0';
				WR1_SEL_F<=(others=>'0');
				WR2_SEL_F<=(others=>'0');
				ADDR2_SEL_F <= '0';
             	WSPSR_SEL_F <= (others=>'0');
             	WCPSR_SEL_F <=(others=>'0');
			elsif(STALL='0') then
				DMOU_EN_F <= DMOU_EN;
				DMOU_OP_F <= DMOU_OP;
				BRANCH2_F <= BRANCH2;
				WCOND_SEL_F <= WCOND_SEL;
				WR1_SEL_F <= WR1_SEL;
				WR2_SEL_F <= WR2_SEL;
				ADDR2_SEL_F <= ADDR2_SEL;
             	WSPSR_SEL_F <= WSPSR_SEL;
             	WCPSR_SEL_F <= WCPSR_SEL;
			end if;
		end if;
	end process;

end BEHAVIORAL;

configuration CFG_FF_X2B_CTRL of FF_X2B_CTRL is
   for BEHAVIORAL

   end for;

end CFG_FF_X2B_CTRL;
