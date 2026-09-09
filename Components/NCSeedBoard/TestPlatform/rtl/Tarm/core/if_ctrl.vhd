-- VHDL Model Created from SGE Symbol if_ctrl.sym -- Jun 30 15:03:00 2003

library IEEE;
   use IEEE.std_logic_1164.all;
   use IEEE.std_logic_misc.all;
   use IEEE.std_logic_arith.all;

entity IF_CTRL is
      Port (     CLK : In    std_logic;
               FLUSH : In    std_logic;
              HIVECS : In    std_logic;
               STALL : In    std_logic;
             X1_ADDR : In    std_logic_vector (31 downto 0);
             X1_BRANCH1 : In    std_logic;
             X2_ADDR : In    std_logic_vector (31 downto 0);
             X2_BRANCH2 : In    std_logic;
                  IA : Out   std_logic_vector (31 downto 0);
              INMREQ : Out   std_logic;
                ISEQ : Out   std_logic;
                  PC : Out   std_logic_vector (31 downto 0);
                PC_4 : Out   std_logic_vector (31 downto 0);
                PC_8 : Out   std_logic_vector (31 downto 0) );
end IF_CTRL;

architecture BEHAVIORAL of IF_CTRL is
	--------------------------------
	-- ToyARM 1.0
	-- Author: Oh, kyungsoo
	-- Last updated: 2003.07.30.
	--------------------------------

	signal cur_pc,next_pc: std_logic_vector(31 downto 0);
	signal cur_pc_4: std_logic_vector(31 downto 0);
   begin
	
	SEQ:process(CLK)
	begin
	if(CLK'event and CLK='1') then
		if(FLUSH='1') then -- Synchronous nReset
			if(HIVECS='0') then
	   			cur_pc <= "1111111111111111" & "1111111111111100"; -- -4
			else -- highvecs='1'
	   			cur_pc <= "1111111111111110" & "1111111111111100";
			end if;
		elsif(STALL='0') then
			cur_pc <= next_pc;
		end if;
	end if;
	end process;

	COMB:process(FLUSH,STALL,cur_pc,cur_pc_4,next_pc,X1_BRANCH1,X1_ADDR,X2_BRANCH2,X2_ADDR)
	begin

		-- These Miscellaneous signals is used in ID stage.
		cur_pc_4<= unsigned(cur_pc)+4;
		PC 		<= cur_pc;
		PC_4 	<= cur_pc_4;
		PC_8 	<= unsigned(cur_pc)+8;

		-----------------------
		-- Main output signals
		-----------------------
		if(X1_BRANCH1='1' or X2_BRANCH2='1') then
			ISEQ 	<= '0';
		else
			ISEQ 	<= '1';
		end if;

		-- INMREQ Control
		if(FLUSH='1' or STALL='1') then
			INMREQ 	<= '1';		-- Do not request.
		else
			INMREQ 	<= '0';
		end if;

		-- IA(next_pc) Control, this path may be critical path.
		if(X2_BRANCH2='1') then
			next_pc <= X2_ADDR;
	  	elsif(X1_BRANCH1='1') then
			next_pc <= X1_ADDR;
		else -- Normal Case
			next_pc <= cur_pc_4;
		end if;
		-- Instruction Address
		IA <= next_pc; -- next_pc is IA

	end process;	

end BEHAVIORAL;

configuration CFG_IF_CTRL of IF_CTRL is
   for BEHAVIORAL

   end for;

end CFG_IF_CTRL;
