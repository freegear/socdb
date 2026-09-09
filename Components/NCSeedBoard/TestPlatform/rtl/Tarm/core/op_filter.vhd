-- VHDL Model Created from SGE Symbol op_filter.sym -- Jul 30 15:22:18 2003

library IEEE;
   use IEEE.std_logic_1164.all;
   use IEEE.std_logic_misc.all;
   use IEEE.std_logic_arith.all;

entity OP_FILTER is
      Port ( COND_PASS : In    std_logic;
             WB_COND_WOP_IN : In    std_logic_vector (1 downto 0);
             WB_CPSR_WOP_IN : In    std_logic_vector (3 downto 0);
             WB_SPSR_WOP_IN : In    std_logic_vector (3 downto 0);
             WB_WOP1_IN : In    std_logic_vector (5 downto 0);
             WB_WOP2_IN : In    std_logic_vector (5 downto 0);
             X1_ALU_EN_IN : In    std_logic;
             X1_BRANCH1_IN : In    std_logic;
             X1_CLZ_EN_IN : In    std_logic;
             X1_DMIU_EN_IN : In    std_logic;
             X1_MUL_EN_IN : In    std_logic;
             X1_SHIFT_EN_IN : In    std_logic;
             X2_BRANCH2_IN : In    std_logic;
             X2_DMEM_EN_IN : In    std_logic;
             X2_DMOU_EN_IN : In    std_logic;
             WB_COND_WOP_OUT : Out   std_logic_vector (1 downto 0);
             WB_CPSR_WOP_OUT : Out   std_logic_vector (3 downto 0);
             WB_SPSR_WOP_OUT : Out   std_logic_vector (3 downto 0);
             WB_WOP1_OUT : Out   std_logic_vector (5 downto 0);
             WB_WOP2_OUT : Out   std_logic_vector (5 downto 0);
             X1_ALU_EN_OUT : Out   std_logic;
             X1_BRANCH1_OUT : Out   std_logic;
             X1_CLZ_EN_OUT : Out   std_logic;
             X1_DMIU_EN_OUT : Out   std_logic;
             X1_MUL_EN_OUT : Out   std_logic;
             X1_SHIFT_EN_OUT : Out   std_logic;
             X2_BRANCH2_OUT : Out   std_logic;
             X2_DMEM_EN_OUT : Out   std_logic;
             X2_DMOU_EN_OUT : Out   std_logic );
end OP_FILTER;

architecture BEHAVIORAL of OP_FILTER is
	--------------------------------
	-- ToyARM 1.0
	-- Author: Oh, kyungsoo
	-- Last updated: 2003.08.07.
	--------------------------------

   begin
	process(COND_PASS,
			WB_COND_WOP_IN,WB_CPSR_WOP_IN,WB_WOP1_IN,
			WB_WOP2_IN,WB_SPSR_WOP_IN,
			X1_ALU_EN_IN,X1_BRANCH1_IN,
            X1_MUL_EN_IN,X1_SHIFT_EN_IN,X1_DMIU_EN_IN,X1_CLZ_EN_IN,
			X2_BRANCH2_IN,X2_DMEM_EN_IN,X2_DMOU_EN_IN)

	begin

		-- Default Signal
		X1_BRANCH1_OUT <= X1_BRANCH1_IN;
		X1_SHIFT_EN_OUT <= X1_SHIFT_EN_IN;
		X1_ALU_EN_OUT <= X1_ALU_EN_IN;
		X1_MUL_EN_OUT <= X1_MUL_EN_IN;
		X1_DMIU_EN_OUT <= X1_DMIU_EN_IN;
		X1_CLZ_EN_OUT  <= X1_CLZ_EN_IN;

		X2_BRANCH2_OUT <= X2_BRANCH2_IN;
		X2_DMEM_EN_OUT <= X2_DMEM_EN_IN;
		X2_DMOU_EN_OUT <= X2_DMOU_EN_IN;

		WB_WOP1_OUT <= WB_WOP1_IN;
		WB_WOP2_OUT <= WB_WOP2_IN;
		WB_COND_WOP_OUT <= WB_COND_WOP_IN;
		WB_CPSR_WOP_OUT <= WB_CPSR_WOP_IN;
		WB_SPSR_WOP_OUT <= WB_SPSR_WOP_IN;


		-- Filter Operation according to COND_PASS signal
		if(COND_PASS='0') then	
			X1_BRANCH1_OUT <= '0';
		-- Annotate for timing optimization
--			X1_SHIFT_EN_OUT <= '0';
--			X1_ALU_EN_OUT <= '0';
--			X1_MUL_EN_OUT <= '0';
--			X1_DMIU_EN_OUT <= '0';
--			X1_CLZ_EN_OUT <= '0';

			-- X2 operaton unit
		    X2_BRANCH2_OUT <= '0';
			X2_DMEM_EN_OUT <= '0';
			X2_DMOU_EN_OUT <= '0';

			-- Write Back
			WB_WOP1_OUT <= (others=>'0');
			WB_WOP2_OUT <= (others=>'0');
			WB_COND_WOP_OUT(0) <= '0';
			WB_CPSR_WOP_OUT <= "0000";
			WB_SPSR_WOP_OUT <= "0000";
		end if;
	end process;
end BEHAVIORAL;

configuration CFG_OP_FILTER of OP_FILTER is
   for BEHAVIORAL

   end for;

end CFG_OP_FILTER;
