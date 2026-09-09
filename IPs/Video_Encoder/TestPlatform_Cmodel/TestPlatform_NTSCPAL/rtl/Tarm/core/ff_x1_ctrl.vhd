-- VHDL Model Created from SGE Symbol ff_x1_ctrl.sym -- Jul 30 15:06:44 2003

library IEEE;
   use IEEE.std_logic_1164.all;
   use IEEE.std_logic_misc.all;
   use IEEE.std_logic_arith.all;

entity FF_X1_CTRL is
      Port ( ADDR1_SEL : In    std_logic;
              ALU_EN : In    std_logic;
              ALU_OP : In    std_logic_vector (3 downto 0);
             BRANCH1 : In    std_logic;
                 CLK : In    std_logic;
              CLZ_EN : In    std_logic;
             DMIU_EN : In    std_logic;
             DMIU_OP : In    std_logic_vector (2 downto 0);
               FLUSH : In    std_logic;
             INST_COND : In    std_logic_vector (3 downto 0);
              MUL_EN : In    std_logic;
              MUL_OP : In    std_logic_vector (2 downto 0);
             SHIFT_EN : In    std_logic;
             SHIFT_OP : In    std_logic_vector (3 downto 0);
               STALL : In    std_logic;
             WCOND_SEL : In    std_logic;
              WR_SEL : In    std_logic_vector (1 downto 0);
             ADDR1_SEL_F : Out   std_logic;
             ALU_EN_F : Out   std_logic;
             ALU_OP_F : Out   std_logic_vector (3 downto 0);
             BRANCH1_F : Out   std_logic;
             CLZ_EN_F : Out   std_logic;
             DMIU_EN_F : Out   std_logic;
             DMIU_OP_F : Out   std_logic_vector (2 downto 0);
             INST_COND_F : Out   std_logic_vector (3 downto 0);
             MUL_EN_F : Out   std_logic;
             MUL_OP_F : Out   std_logic_vector (2 downto 0);
             SHIFT_EN_F : Out   std_logic;
             SHIFT_OP_F : Out   std_logic_vector (3 downto 0);
             WCOND_SEL_F : Out   std_logic;
             WR_SEL_F : Out   std_logic_vector (1 downto 0) );
end FF_X1_CTRL;

architecture BEHAVIORAL of FF_X1_CTRL is
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
       			ADDR1_SEL_F<='0' ; 
              	ALU_EN_F <='0' ; 
              	ALU_OP_F <=(others=>'0') ; 
             	BRANCH1_F <='0'; 
             	INST_COND_F<=(others=>'0') ;
              	MUL_EN_F <= '0'; 
              	MUL_OP_F <= (others=>'0'); 
             	SHIFT_EN_F<= '0';
             	SHIFT_OP_F <= (others=>'0'); 
             	WCOND_SEL_F<= '0';
              	WR_SEL_F<= (others=>'0');
				DMIU_EN_F <= '0';
				DMIU_OP_F <= (others=>'0');
				CLZ_EN_F <= '0';
			elsif(STALL='0') then
       			ADDR1_SEL_F <= ADDR1_SEL; 
              	ALU_EN_F <= ALU_EN; 
              	ALU_OP_F <= ALU_OP; 
             	BRANCH1_F <= BRANCH1; 
             	INST_COND_F<= INST_COND;
              	MUL_EN_F <= MUL_EN; 
              	MUL_OP_F <= MUL_OP; 
             	SHIFT_EN_F<= SHIFT_EN;
             	SHIFT_OP_F <= SHIFT_OP; 
             	WCOND_SEL_F<= WCOND_SEL;
              	WR_SEL_F<= WR_SEL;
				DMIU_EN_F <= DMIU_EN;
				DMIU_OP_F <= DMIU_OP;
				CLZ_EN_F <= CLZ_EN;
			end if;
		end if;
	end process;
end BEHAVIORAL;

configuration CFG_FF_X1_CTRL of FF_X1_CTRL is
   for BEHAVIORAL

   end for;

end CFG_FF_X1_CTRL;
