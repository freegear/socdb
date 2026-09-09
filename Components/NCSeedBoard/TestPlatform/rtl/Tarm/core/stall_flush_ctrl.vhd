-- VHDL Model Created from SGE Symbol stall_flush_ctrl.sym -- Jul 30 14:02:46 2003

library IEEE;
   use IEEE.std_logic_1164.all;
   use IEEE.std_logic_misc.all;
   use IEEE.std_logic_arith.all;

entity STALL_FLUSH_CTRL is
      Port (     CLK : In    std_logic;
              DABORT : In    std_logic;
              DNWAIT : In    std_logic;
             ID_COND_ROP : In    std_logic;
             ID_MULTI_CYCLE : In    std_logic;
              ID_RA1 : In    std_logic_vector (4 downto 0);
              ID_RA2 : In    std_logic_vector (4 downto 0);
              ID_RA3 : In    std_logic_vector (4 downto 0);
              ID_RA4 : In    std_logic_vector (4 downto 0);
             ID_ROP1 : In    std_logic;
             ID_ROP2 : In    std_logic;
             ID_ROP3 : In    std_logic;
             ID_ROP4 : In    std_logic;
              INWAIT : In    std_logic;
              NRESET : In    std_logic;
             X1_BRANCH : In    std_logic;
             X1_COND_WOP : In    std_logic_vector (1 downto 0);
              X1_WA1 : In    std_logic_vector (4 downto 0);
              X1_WA2 : In    std_logic_vector (4 downto 0);
             X1_WOP1 : In    std_logic_vector (5 downto 0);
             X1_WOP2 : In    std_logic_vector (5 downto 0);
             X2_BRANCH : In    std_logic;
             X2_COND_WOP : In    std_logic_vector (1 downto 0);
              X2_WA1 : In    std_logic_vector (4 downto 0);
              X2_WA2 : In    std_logic_vector (4 downto 0);
             X2_WOP1 : In    std_logic_vector (5 downto 0);
             X2_WOP2 : In    std_logic_vector (5 downto 0);
             ID_FLUSH : Out   std_logic;
             ID_STALL : Out   std_logic;
             IF_FLUSH : Out   std_logic;
             IF_STALL : Out   std_logic;
             WB_FLUSH : Out   std_logic;
             WB_STALL : Out   std_logic;
             X1_FLUSH : Out   std_logic;
             X1_STALL : Out   std_logic;
             X2_FLUSH : Out   std_logic;
             X2_STALL : Out   std_logic );
end STALL_FLUSH_CTRL;

architecture BEHAVIORAL of STALL_FLUSH_CTRL is
	--------------------------------
	-- ToyARM 1.0
	-- Author: Oh, kyungsoo
	-- Last updated: 2003.08.11.
	--------------------------------

	-- WOP BIT
	constant WOP_WRITE_BIT		: integer:=0; -- Write
	constant WOP_X2_RESULT_BIT	: integer:=1;
	constant WOP_NO_STALL_BIT	: integer:=2;
	constant WOP_BACKUP_BIT		: integer:=3;
	constant WOP_BACKUP_SEL_BIT	: integer:=4;
	constant WOP_PWRITE_BIT		: integer:=5; -- Pseudo Write

	signal s_x1_wop1: std_logic_vector(1 downto 0);
	signal s_x1_wop2: std_logic_vector(1 downto 0);

	signal cur_reset_count,next_reset_count: std_logic_vector(1 downto 0);

	-- DEBUG_030721d: 
	signal global_wait: std_logic;
begin

	RESET_COUNT: process(CLK)
	begin
		
	if(CLK'event and CLK='1') then
		if(NRESET='0' ) then
			cur_reset_count <= "10";
		else
			-- DEBUG_030721d: 
			if(global_wait='0') then --  global_wait <= not (INWAIT and DNWAIT);
				cur_reset_count <= next_reset_count;
			end if;
		end if;
	end if;

	end process;

	STALL : process (NRESET,INWAIT,DNWAIT,ID_MULTI_CYCLE,ID_RA1,ID_RA2,ID_RA3,ID_RA4,
					ID_ROP1,ID_ROP2,ID_ROP3,ID_ROP4,
					X1_BRANCH,X2_BRANCH,
					   X1_WOP1,X1_WOP2, -- DEBUG_030721b
					   s_x1_wop1,s_x1_wop2,X1_WA1,X1_WA2,
					   ID_COND_ROP,X1_COND_WOP,cur_reset_count,DABORT)
	begin

		-- oks: 030711: add DEBUG_030711
		-- WOP_NO_STALL_BIT is used in 
		-- 1. swap operation and 
		-- 2. backup rn of ldm, stm insts
		s_x1_wop1 <= X1_WOP1(1 downto 0);
		s_x1_wop2 <= X1_WOP2(1 downto 0);
		if(X1_WOP1(WOP_NO_STALL_BIT)='1') then
			s_x1_wop1(0) <= '0';
		end if;	
		if(X1_WOP2(WOP_NO_STALL_BIT)='1') then
			s_x1_wop2(0) <= '0';
		end if;	

		-- Default Value
		IF_STALL <= '0';
		ID_STALL <= '0';
		X1_STALL <= '0';
		X2_STALL <= '0';
		WB_STALL <= '0';

		IF_FLUSH <= '0';
		ID_FLUSH <= '0';
		X1_FLUSH <= '0';
		X2_FLUSH <= '0';
		WB_FLUSH <= '0';

		next_reset_count <= cur_reset_count;

		-- DEBUG_030721d
		global_wait <= not (INWAIT and DNWAIT);


		-- DEBUG_030715b: Need one if statement
		if(NRESET='0') then
			IF_STALL <= '1';
			ID_STALL <= '1';
			X1_STALL <= '1';
			X2_STALL <= '1';
			WB_STALL <= '1';

			IF_FLUSH <= '1';
			ID_FLUSH <= '1';
			X1_FLUSH <= '1';
			X2_FLUSH <= '1';
			WB_FLUSH <= '1';

		elsif(cur_reset_count="10") then -- Delay ID execution time
			IF_STALL <= '1';
			ID_STALL <= '1';
			X1_STALL <= '1';
			X2_STALL <= '1';
			WB_STALL <= '1';
			next_reset_count <= "01";

		elsif(cur_reset_count="01") then -- Delay ID execution time
			IF_STALL <= '0';
			ID_STALL <= '1';
			X1_STALL <= '1';
			X2_STALL <= '1';
			WB_STALL <= '1';
			next_reset_count <= "00";

		--
		-- ***Critical path
		-- INWAIT,DNWAIT -> stall,flush
		-- DABORT -> stall,flush
		--
			
		--
		-- CASE1: All stall case : ICACHE, DCACHE miss
		-- ***May be critical path
		-- miss_delay + stall_delay + a < cycle time
		--
		elsif(INWAIT='0' or DNWAIT='0') then
			IF_STALL <= '1';
			ID_STALL <= '1';
			X1_STALL <= '1';
			X2_STALL <= '1';
			WB_STALL <= '1';

		--
		-- Dabort
		-- ***May be critical path
		-- miss_delay + stall_delay + a < cycle time
		--
		elsif(DABORT='1') then
			IF_STALL <= '1';
			-- DABORT signal must be transferred to ID stage
			-- and exception process will start.
			ID_FLUSH <= '1'; 
			X1_FLUSH <= '1';
			X2_FLUSH <= '1';
			WB_FLUSH <= '1'; -- clear WB

		--
		-- Branch
		--
		elsif(X2_BRANCH='1') then
			ID_FLUSH <= '1';
			X1_FLUSH <= '1';
			X2_FLUSH <= '1';

		elsif(X1_BRANCH='1') then
			ID_FLUSH <= '1';
			X1_FLUSH <= '1';
			
		-- CASE2: IF,ID STALL, X1 Flush and X2 go ahead 
		-- ID_RA1 Stall!
		elsif ( ID_ROP1 ='1' and ID_RA1 = X1_WA1 and s_x1_wop1="11" ) then
			IF_STALL <= '1';
			ID_STALL <= '1';
			X1_FLUSH <= '1';

		elsif ( ID_ROP1 ='1' and ID_RA1 = X1_WA2 and s_x1_wop2="11" ) then
			IF_STALL <= '1';
			ID_STALL <= '1';
			X1_FLUSH <= '1';

		-- ID_RA2 Stall!
		elsif ( ID_ROP2 ='1' and ID_RA2 = X1_WA1 and s_x1_wop1="11" ) then
			IF_STALL <= '1';
			ID_STALL <= '1';
			X1_FLUSH <= '1';
		elsif ( ID_ROP2 ='1' and ID_RA2 = X1_WA2 and s_x1_wop2="11" ) then
			IF_STALL <= '1';
			ID_STALL <= '1';
			X1_FLUSH <= '1';

		-- ID_RA3 Stall!
		elsif ( ID_ROP3 ='1' and ID_RA3 = X1_WA1 and s_x1_wop1="11" ) then
			IF_STALL <= '1';
			ID_STALL <= '1';
			X1_FLUSH <= '1';
		elsif ( ID_ROP3 ='1' and ID_RA3 = X1_WA2 and s_x1_wop2="11" ) then
			IF_STALL <= '1';
			ID_STALL <= '1';
			X1_FLUSH <= '1';

		-- ID_RA4 Stall!
		elsif ( ID_ROP4 ='1' and ID_RA4 = X1_WA1 and s_x1_wop1="11" ) then
			IF_STALL <= '1';
			ID_STALL <= '1';
			X1_FLUSH <= '1';
		elsif ( ID_ROP4 ='1' and ID_RA4 = X1_WA2 and s_x1_wop2="11" ) then
			IF_STALL <= '1';
			ID_STALL <= '1';
			X1_FLUSH <= '1';

		elsif ( ID_COND_ROP = '1' and X1_COND_WOP="11") then
			IF_STALL <= '1';
			ID_STALL <= '1';
			X1_FLUSH <= '1';

		-- Multi cycle case
		-- OPT_TIME_030903d: ignore signals filtered before!
--		elsif(ID_MULTI_CYCLE='1' and X1_BRANCH ='0' and X2_BRANCH='0') then
		elsif(ID_MULTI_CYCLE='1') then
			IF_STALL <= '1';
		end if;

	end process;	-- End of STALL
end BEHAVIORAL;

configuration CFG_STALL_FLUSH_CTRL of STALL_FLUSH_CTRL is
   for BEHAVIORAL

   end for;

end CFG_STALL_FLUSH_CTRL;
