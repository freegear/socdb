-- VHDL Model Created from SGE Symbol pass_wb_ctrl.sym -- Jul 11 14:34:58 2003

library IEEE;
   use IEEE.std_logic_1164.all;
   use IEEE.std_logic_misc.all;
   use IEEE.std_logic_arith.all;

entity PASS_WB_CTRL is
      Port ( COND_WOP : In    std_logic_vector (1 downto 0);
             CPSR_WOP : In    std_logic_vector (3 downto 0);
               FLUSH : In    std_logic;
             SPSR_WA : In    std_logic_vector (2 downto 0);
             SPSR_WOP : In    std_logic_vector (3 downto 0);
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
end PASS_WB_CTRL;

architecture BEHAVIORAL of PASS_WB_CTRL is
	--------------------------------
	-- ToyARM 1.0
	-- Author: Oh, kyungsoo
	-- Last updated: 2003.08.07.
	--------------------------------

	-- WOP BIT
	constant WOP_WRITE_BIT		: integer:=0; -- Write
	constant WOP_X2_RESULT_BIT	: integer:=1;
	constant WOP_NO_STALL_BIT	: integer:=2;
	constant WOP_BACKUP_BIT		: integer:=3;
	constant WOP_BACKUP_SEL_BIT	: integer:=4;
	constant WOP_PWRITE_BIT		: integer:=5; -- Pseudo Write

   begin
	process(FLUSH,CPSR_WOP,SPSR_WOP,SPSR_WA,WA1,WA2,WOP1,WOP2,COND_WOP)
	begin
		-- OPT_TIME_030818
		-- OPT_TIME_030904
		-- Pass Address and filter OP
		-- 1. GREG Write Signals
		WOP1_F 	<= WOP1;
		WOP2_F 	<= WOP2;
		WA1_F 	<= WA1;
		WA2_F 	<= WA2;

		-- 2. PSR Write Signals
		CPSR_WOP_F 	<= CPSR_WOP; 
		SPSR_WOP_F 	<= SPSR_WOP;
		SPSR_WA_F 	<= SPSR_WA;

		-- 3. COND Write Signals
		COND_WOP_F <= COND_WOP;

		-- oks: 030711: add
		-- Pseudo write for base addr update!
		-- OPT_TIME_030904
		if(WOP1(WOP_PWRITE_BIT)='1') then
			WOP1_F(WOP_WRITE_BIT) <= '0';
		end if;
		if(WOP2(WOP_PWRITE_BIT)='1') then
			WOP2_F(WOP_WRITE_BIT) <= '0';
		end if;

		-- If WB_FLUSH, All WB operations are cancelled
		if(FLUSH='1') then
			WOP1_F(WOP_WRITE_BIT) 	<= '0'; -- WOP#_F(0) determines real write operation
			WOP2_F(WOP_WRITE_BIT) 	<= '0';
			CPSR_WOP_F 				<= (others=>'0'); 
			SPSR_WOP_F 				<= (others=>'0');
			COND_WOP_F 				<= (others=>'0');
		end if;
	end process;

end BEHAVIORAL;

configuration CFG_PASS_WB_CTRL of PASS_WB_CTRL is
   for BEHAVIORAL

   end for;

end CFG_PASS_WB_CTRL;
