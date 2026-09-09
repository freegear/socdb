-- VHDL Model Created from SGE Symbol inst_ctrl.sym -- Aug 27 11:23:56 2003

library IEEE;
   use IEEE.std_logic_1164.all;
   use IEEE.std_logic_misc.all;
   use IEEE.std_logic_arith.all;

entity INST_CTRL is
      Port (     CLK : In    std_logic;
                CPSR : In    std_logic_vector (31 downto 0);
              DABORT : In    std_logic;
               FLUSH : In    std_logic;
              HIVECS : In    std_logic;
              IABORT : In    std_logic;
             INST_CODE : In    std_logic_vector (31 downto 0);
                NFIQ : In    std_logic;
                NIRQ : In    std_logic;
               STALL : In    std_logic;
             X1_BRANCH1_IN : In    std_logic;
             X1_BRANCH2_IN : In    std_logic;
             X2_BRANCH2_IN : In    std_logic;
             ID_COND_ROP : Out   std_logic;
             ID_MULTI_CYCLE : Out   std_logic;
             ID_R1_IMMED : Out   std_logic_vector (31 downto 0);
             ID_R1_SEL : Out   std_logic_vector (1 downto 0);
             ID_R2_IMMED : Out   std_logic_vector (31 downto 0);
             ID_R2_SEL : Out   std_logic;
             ID_R3_IMMED : Out   std_logic_vector (31 downto 0);
             ID_R3_SEL : Out   std_logic;
             ID_R4_IMMED : Out   std_logic_vector (31 downto 0);
             ID_R4_SEL : Out   std_logic_vector (1 downto 0);
              ID_RA1 : Out   std_logic_vector (3 downto 0);
              ID_RA2 : Out   std_logic_vector (3 downto 0);
              ID_RA3 : Out   std_logic_vector (3 downto 0);
              ID_RA4 : Out   std_logic_vector (3 downto 0);
             ID_ROP1 : Out   std_logic;
             ID_ROP2 : Out   std_logic;
             ID_ROP3 : Out   std_logic;
             ID_ROP4 : Out   std_logic;
             ID_RREG1_CONV_MODE : Out   std_logic_vector (4 downto 0);
             ID_RREG2_CONV_MODE : Out   std_logic_vector (4 downto 0);
             ID_RREG3_CONV_MODE : Out   std_logic_vector (4 downto 0);
             ID_RREG4_CONV_MODE : Out   std_logic_vector (4 downto 0);
             ID_SPSR_RA : Out   std_logic_vector (2 downto 0);
             ID_WREG1_CONV_MODE : Out   std_logic_vector (4 downto 0);
             ID_WREG2_CONV_MODE : Out   std_logic_vector (4 downto 0);
             WB_COND_WOP : Out   std_logic_vector (1 downto 0);
             WB_CPSR_WOP : Out   std_logic_vector (3 downto 0);
             WB_SPSR_WA : Out   std_logic_vector (2 downto 0);
             WB_SPSR_WOP : Out   std_logic_vector (3 downto 0);
              WB_WA1 : Out   std_logic_vector (3 downto 0);
              WB_WA2 : Out   std_logic_vector (3 downto 0);
             WB_WOP1 : Out   std_logic_vector (5 downto 0);
             WB_WOP2 : Out   std_logic_vector (5 downto 0);
             X1_ADDR_SEL : Out   std_logic;
             X1_ALU_EN : Out   std_logic;
             X1_ALU_OP : Out   std_logic_vector (3 downto 0);
             X1_BRANCH1 : Out   std_logic;
             X1_CLZ_EN : Out   std_logic;
             X1_DMIU_EN : Out   std_logic;
             X1_DMIU_OP : Out   std_logic_vector (2 downto 0);
             X1_INST_COND : Out   std_logic_vector (3 downto 0);
             X1_MUL_EN : Out   std_logic;
             X1_MUL_OP : Out   std_logic_vector (2 downto 0);
             X1_SHIFT_EN : Out   std_logic;
             X1_SHIFT_OP : Out   std_logic_vector (3 downto 0);
             X1_WCOND1_SEL : Out   std_logic;
             X1_WR_SEL : Out   std_logic_vector (1 downto 0);
             X2_ADDR2_SEL : Out   std_logic;
             X2_BRANCH2 : Out   std_logic;
             X2_DMEM_EN : Out   std_logic;
             X2_DMEM_OP : Out   std_logic_vector (2 downto 0);
             X2_DMOU_EN : Out   std_logic;
             X2_DMOU_OP : Out   std_logic_vector (2 downto 0);
             X2_WCOND2_SEL : Out   std_logic;
             X2_WCPSR_SEL : Out   std_logic_vector (1 downto 0);
             X2_WR1_SEL : Out   std_logic_vector (1 downto 0);
             X2_WR2_SEL : Out   std_logic_vector (1 downto 0);
             X2_WSPSR_SEL : Out   std_logic_vector (1 downto 0) );

end INST_CTRL;

architecture BEHAVIORAL of INST_CTRL is
	--------------------------------
	-- ToyARM 1.0
	-- Author: Oh, kyungsoo
	-- Last updated: 2003.08.27.
	--------------------------------

	-- DEBUG_030826 : For base address forwarding
	-- DEBUG_030826b: For User mode register access and mode specific base register access

    -- XX_WOP#(1 downto 0)
	-- XX: Operation Stage
	-- #: Write Register Port Number

	-- XX_WOP#(0): 0=write enable 1=write disable
	-- XX_WOP#(1): 0=write value is created in X1 stage
	-- XX_WOP#(1): 1=write value is created in X2 stage

	-- Mode bits
	constant MODE_USER 		: std_logic_vector(4 downto 0) := "10000";
	constant MODE_FIQ 		: std_logic_vector(4 downto 0) := "10001";
	constant MODE_IRQ 		: std_logic_vector(4 downto 0) := "10010";
	constant MODE_SVC		: std_logic_vector(4 downto 0) := "10011";
	constant MODE_ABT		: std_logic_vector(4 downto 0) := "10111";
	constant MODE_UND		: std_logic_vector(4 downto 0) := "11011";
	constant MODE_SYS 		: std_logic_vector(4 downto 0) := "11111";
	-- DEBUG_030826: For base address forwarding
	constant MODE_NOP		: std_logic_vector(4 downto 0) := "00000";

	-- See TOYARM_SPEC1.0
	constant ADDR_SPSR_SVC: std_logic_vector(2 downto 0) := "000";
	constant ADDR_SPSR_ABT: std_logic_vector(2 downto 0) := "001";
	constant ADDR_SPSR_UND: std_logic_vector(2 downto 0) := "010";
	constant ADDR_SPSR_IRQ: std_logic_vector(2 downto 0) := "011";
	constant ADDR_SPSR_FIQ: std_logic_vector(2 downto 0) := "100";

	-- Table 3-2 Data-processing instructions
	constant OP_AND		: std_logic_vector(3 downto 0):="0000";
	constant OP_EOR		: std_logic_vector(3 downto 0):="0001";
	constant OP_SUB		: std_logic_vector(3 downto 0):="0010";
	constant OP_RSB		: std_logic_vector(3 downto 0):="0011";
	constant OP_ADD		: std_logic_vector(3 downto 0):="0100";
	constant OP_ADC		: std_logic_vector(3 downto 0):="0101";
	constant OP_SBC		: std_logic_vector(3 downto 0):="0110";
	constant OP_RSC		: std_logic_vector(3 downto 0):="0111";
	constant OP_TST		: std_logic_vector(3 downto 0):="1000";
	constant OP_TEQ		: std_logic_vector(3 downto 0):="1001";
	constant OP_CMP		: std_logic_vector(3 downto 0):="1010";
	constant OP_CMN		: std_logic_vector(3 downto 0):="1011";
	constant OP_ORR		: std_logic_vector(3 downto 0):="1100";
	constant OP_MOV		: std_logic_vector(3 downto 0):="1101";
	constant OP_BIC		: std_logic_vector(3 downto 0):="1110";
	constant OP_MVN		: std_logic_vector(3 downto 0):="1111";

	-- Constant Variable
	constant C_ZERO8	: std_logic_vector(7 downto 0):=(others=>'0'); 
	constant C_ZERO16	: std_logic_vector(15 downto 0):=(others=>'0'); 
	constant C_ZERO20	: std_logic_vector(19 downto 0):=(others=>'0'); 
	constant C_ZERO24	: std_logic_vector(23 downto 0):=(others=>'0'); 
	-- ID MUX
	constant S_R1_REG	: std_logic_vector(1 downto 0):="00"; 
	constant S_R1_IMMED	: std_logic_vector(1 downto 0):="01"; 
	constant S_R1_CPSR	: std_logic_vector(1 downto 0):="10"; 
	constant S_R1_SPSR	: std_logic_vector(1 downto 0):="11"; 
	constant S_R2_REG	: std_logic:='0'; 
	constant S_R2_IMMED	: std_logic:='1'; 
	constant S_R3_REG	: std_logic:='0'; 
	constant S_R3_IMMED	: std_logic:='1'; 
	constant S_R4_REG	: std_logic_vector(1 downto 0):="00"; 
	constant S_R4_IMMED	: std_logic_vector(1 downto 0):="01"; 
	constant S_R4_PC_4	: std_logic_vector(1 downto 0):="10"; 
	constant S_R4_ABORT_PC_8	: std_logic_vector(1 downto 0):="11"; 

	-- X1 MUX
	constant S_X1_WR_ALU: std_logic_vector(1 downto 0):="00"; 
	constant S_X1_WR_R1	: std_logic_vector(1 downto 0):="01"; 
	constant S_X1_WR_R4	: std_logic_vector(1 downto 0):="10"; 
	constant S_X1_WR_CLZ: std_logic_vector(1 downto 0):="11";  -- ADD_030730

	constant S_X1_ADDR1_ALU	: std_logic:='0'; 
	constant S_X1_ADDR1_R1	: std_logic:='1'; 

	constant S_X1_COND_CPSR_F : std_logic:='0';
	constant S_X1_COND_ALU	  : std_logic:='1';

	-- X2 MUX
	constant S_X2_WR1_WR	: std_logic_vector(1 downto 0):="00"; 
	constant S_X2_WR1_DMEM	: std_logic_vector(1 downto 0):="01"; 
	constant S_X2_WR1_MUL_LO: std_logic_vector(1 downto 0):="10"; 
	constant S_X2_WR2_WR	: std_logic_vector(1 downto 0):="00"; 
	constant S_X2_WR2_MUL_HI: std_logic_vector(1 downto 0):="01"; 
	constant S_X2_WR2_BACKUP: std_logic_vector(1 downto 0):="10"; 

	constant S_X2_ADDR2_DMEM: std_logic:='0'; 
	constant S_X2_ADDR2_R3	: std_logic:='1'; 

	constant S_X2_WSPSR_CPSR	: std_logic_vector:="00"; 
	constant S_X2_WSPSR_R1		: std_logic_vector:="01"; 
	constant S_X2_WSPSR_X1_WR	: std_logic_vector(1 downto 0):="10"; 
	constant S_X2_WCPSR_CPSR	: std_logic_vector(1 downto 0):="00"; 
	constant S_X2_WCPSR_SPSR	: std_logic_vector(1 downto 0):="01"; 
	constant S_X2_WCPSR_R1		: std_logic_vector(1 downto 0):="10"; 
	constant S_X2_WCPSR_X1_WR	: std_logic_vector(1 downto 0):="11"; 

	constant S_X2_COND_X1	: std_logic:='0';
	constant S_X2_COND_MUL	: std_logic:='1';

	constant OP_REG_CONV_PASS: 		std_logic :='0';
	constant OP_REG_CONV_TRANSLATE: std_logic :='1';

	-- WB OP
	constant OP_X1_EXEC		: std_logic_vector(1 downto 0):="01"; 
	constant OP_X2_EXEC		: std_logic_vector(1 downto 0):="11"; 
	constant OP_X1			: std_logic:='0'; 
	constant OP_X2			: std_logic:='1'; 
	constant OP_EXEC		: std_logic:='1'; 

	-- Consider Addressing Mode 3 inst_code(6:5) S,H
    constant OP_DMOU_UBYTE 	: std_logic_vector(2 downto 0):="000"; 
    constant OP_DMOU_SBYTE 	: std_logic_vector(2 downto 0):="010";
    constant OP_DMOU_UHALF  : std_logic_vector(2 downto 0):="001";
    constant OP_DMOU_SHALF  : std_logic_vector(2 downto 0):="011";
    constant OP_DMOU_WORD 	: std_logic_vector(2 downto 0):="100";
	-- LDMs ignores the least significant two bits of address
    constant OP_DMOU_WORD_M	: std_logic_vector(2 downto 0):="101";

    constant OP_DMIU_UBYTE 	: std_logic_vector(2 downto 0):="000"; 
    constant OP_DMIU_SBYTE 	: std_logic_vector(2 downto 0):="010";
    constant OP_DMIU_UHALF  : std_logic_vector(2 downto 0):="001";
    constant OP_DMIU_SHALF  : std_logic_vector(2 downto 0):="011";
    constant OP_DMIU_WORD 	: std_logic_vector(2 downto 0):="100";

	constant OP_WOP_WRITE		: std_logic_vector(5 downto 0) := "000001";
	constant OP_WOP_PWRITE		: std_logic_vector(5 downto 0) := "100001";
	constant OP_WOP_NO_STALL	: std_logic_vector(5 downto 0) := "000100";
	constant OP_WOP_BACKUP		: std_logic_vector(5 downto 0) := "001000";
	constant OP_WOP_BACKUP_WR1	: std_logic_vector(5 downto 0) := "001000";
	constant OP_WOP_BACKUP_WR2	: std_logic_vector(5 downto 0) := "011000";
	constant OP_WOP_RESULT_X1	: std_logic_vector(5 downto 0) := "000000";
	constant OP_WOP_RESULT_X2	: std_logic_vector(5 downto 0) := "000010";
	

	type inst_ctrl_state_type is (SIMPLE_INST, COMPLEX_INST);
	type inst_ctrl_state_c_type is (S_IDLE, S_SWP2, S_LDM_STM2,S_MRS2,S_MRS3,S_MSR2,S_MSR3);
	signal cur_state,next_state: inst_ctrl_state_type;
	signal cur_state_c,next_state_c: inst_ctrl_state_c_type;
	signal cur_inst,next_inst: std_logic_vector(31 downto 0);
	signal cur_iabort,next_iabort: std_logic;

	-- DEBUG_030822: IF DABORT, Flush ID stage.
	signal DABORT_ff1: std_logic;

	-- For LDM,STM
	signal sum2_0,sum2_1,sum2_2,sum2_3,sum2_4,sum2_5,sum2_6,sum2_7: std_logic_vector(1 downto 0);
	signal sum3_0,sum3_1,sum3_2,sum3_3: std_logic_vector(2 downto 0);
	signal sum4_0,sum4_1: std_logic_vector(3 downto 0);
	signal sum5_0: std_logic_vector(4 downto 0);

	-- OPT_TIME_030902:
	signal cur_register_list_sum,next_register_list_sum: std_logic_vector(4 downto 0);
	signal cur_register,next_register: std_logic_vector(15 downto 0);
	signal cur_access_count,next_access_count: std_logic_vector(4 downto 0);
	signal access_register: std_logic_vector(3 downto 0);
	signal cur_backup_rn, next_backup_rn: std_logic;
	signal spsr_addr: std_logic_vector(2 downto 0);

	-- DEBUG_030721c: To avoid bubble inst, in IRQ
	signal X1_BRANCH1_IN_ff1, X2_BRANCH2_IN_ff1: std_logic;

	-- DEBUG_030728: To avoid timing loop
	signal STALL_ff1, FLUSH_ff1: std_logic;

	-- ADD_030730: To synchronize to CLK
	signal NIRQ_ff1, NFIQ_ff1: std_logic;

	-- OPT_TIME _030903
	signal cur_ldm_stm_first,next_ldm_stm_first: std_logic;
	
begin
	
	INST_FF: process(CLK)
	begin
		if(CLK'event and CLK='1') then
			if(FLUSH='1') then
				cur_inst 		<= (others=>'0');
				cur_iabort 		<= '0';
				cur_state 		<= SIMPLE_INST;
				cur_state_c 	<= S_IDLE;
				cur_register 	<= (others=>'0');
				cur_access_count<= (others=>'0');
				cur_backup_rn 	<= '0';
				cur_register_list_sum <= (others=>'0');
				cur_ldm_stm_first <= '0';
			elsif(STALL='0') then
				cur_inst 		<= next_inst;
				cur_iabort 		<= next_iabort;
				cur_state 		<= next_state;
				cur_state_c 	<= next_state_c;
				cur_register 	<= next_register;
				cur_access_count<= next_access_count;
				cur_backup_rn 	<= next_backup_rn ;
				cur_register_list_sum <= next_register_list_sum;
				cur_ldm_stm_first <= next_ldm_stm_first;
			end if;


			------------------------------------------------------
			-- Only delayed signal not flushed by ID_FLUSH signal
			------------------------------------------------------

			-- DEBUG_030721c2
			X1_BRANCH1_IN_ff1 <= X1_BRANCH1_IN;
			X2_BRANCH2_IN_ff1 <= X2_BRANCH2_IN;

			-- Delayed Signal , not flushed by FLUSH signal
			-- DEBUG_030822: IF DABORT, Flush ID stage.
			DABORT_ff1 <= DABORT;

			-- For IRQ, FIQ
			-- XXX_ff1 is delayed version of XXX
			STALL_ff1 <= STALL;
			FLUSH_ff1 <= FLUSH;

			-- IRQ,IFQ synchronize to CLK
			NIRQ_ff1 	<= NIRQ;
			NFIQ_ff1 	<= NFIQ;

		end if;
	end process;


	COUNT_BIT: process(cur_inst,sum2_0,sum2_1,sum2_2,sum2_3,sum2_4,sum2_5,sum2_6,sum2_7,
							    sum3_0,sum3_1,sum3_2,sum3_3,
								sum4_0,sum4_1,sum5_0)
	-- For LDM,STM
	-- Count access bits

	begin
		-- Stage1
		sum2_0(0) <= cur_inst(0) xor cur_inst(1);
		sum2_0(1) <= cur_inst(0) and cur_inst(1);
		sum2_1(0) <= cur_inst(2) xor cur_inst(3);
		sum2_1(1) <= cur_inst(2) and cur_inst(3);
		sum2_2(0) <= cur_inst(4) xor cur_inst(5);
		sum2_2(1) <= cur_inst(4) and cur_inst(5);
		sum2_3(0) <= cur_inst(6) xor cur_inst(7);
		sum2_3(1) <= cur_inst(6) and cur_inst(7);
		sum2_4(0) <= cur_inst(8) xor cur_inst(9);
		sum2_4(1) <= cur_inst(8) and cur_inst(9);
		sum2_5(0) <= cur_inst(10) xor cur_inst(11);
		sum2_5(1) <= cur_inst(10) and cur_inst(11);
		sum2_6(0) <= cur_inst(12) xor cur_inst(13);
		sum2_6(1) <= cur_inst(12) and cur_inst(13);
		sum2_7(0) <= cur_inst(14) xor cur_inst(15);
		sum2_7(1) <= cur_inst(14) and cur_inst(15);

		-- Stage2
		sum3_0 <= unsigned('0'&sum2_0)+unsigned('0'&sum2_1);
		sum3_1 <= unsigned('0'&sum2_2)+unsigned('0'&sum2_3);
		sum3_2 <= unsigned('0'&sum2_4)+unsigned('0'&sum2_5);
		sum3_3 <= unsigned('0'&sum2_6)+unsigned('0'&sum2_7);

		-- Stage3
		sum4_0 <= unsigned('0'&sum3_0)+unsigned('0'&sum3_1);
		sum4_1 <= unsigned('0'&sum3_2)+unsigned('0'&sum3_3);

		-- Stage4
		sum5_0 <= unsigned('0'&sum4_0)+unsigned('0'&sum4_1);

		next_register_list_sum <= sum5_0;
	end process;

	--
	-- SPSR
	--
	SPSR_ADDR_GEN:process(CPSR)
	begin
	-- See TOYARM_SPEC1.0
		case CPSR(4 downto 0) is
		when MODE_SVC 	=> spsr_addr <= ADDR_SPSR_SVC;
		when MODE_ABT	=> spsr_addr <= ADDR_SPSR_ABT;
		when MODE_UND	=> spsr_addr <= ADDR_SPSR_UND;
		when MODE_IRQ 	=> spsr_addr <= ADDR_SPSR_IRQ;
		when MODE_FIQ 	=> spsr_addr <= ADDR_SPSR_FIQ;
		when others 	=> spsr_addr <= ADDR_SPSR_SVC;
		end case;
	end process;
	

	DECODE : process(CPSR,cur_inst,next_state,cur_state,cur_state_c,INST_CODE,
					cur_register_list_sum, next_register_list_sum,
					cur_register, cur_access_count, access_register,spsr_addr,cur_backup_rn,
			NIRQ_ff1,NFIQ_ff1,IABORT,STALL_ff1,FLUSH_ff1,
			X1_BRANCH1_IN_ff1,X2_BRANCH2_IN_ff1, DABORT_ff1, cur_iabort, HIVECS,cur_ldm_stm_first)
	variable temp_value: std_logic_vector(31 downto 0);
	begin
	
	--------------------
	-- Default Signal --
	--------------------
	next_inst <= INST_CODE;
	next_state <= cur_state;
	next_state_c <= cur_state_c;

	next_iabort <= IABORT;

	-- LDM, STM
	next_access_count <= cur_access_count;
	next_register <= cur_register;
	access_register <= "0000";
	next_backup_rn <= cur_backup_rn;
	next_ldm_stm_first <= cur_ldm_stm_first;

    ID_COND_ROP 	<= '0';
    ID_MULTI_CYCLE 	<= '0';
    ID_R1_SEL 		<= S_R1_REG;
    ID_R2_SEL 		<= S_R2_REG;
    ID_R3_SEL 		<= S_R3_REG;
    ID_R4_SEL 		<= S_R4_REG;
    ID_R1_IMMED 	<= (others=>'0');
    ID_R2_IMMED 	<= (others=>'0');
    ID_R3_IMMED 	<= (others=>'0');
    ID_R4_IMMED 	<= (others=>'0');
    ID_RA1 			<= (others=>'0');
    ID_RA2 			<= (others=>'0');
    ID_RA3 			<= (others=>'0');
    ID_RA4 			<= (others=>'0');
    ID_ROP1 		<= '0';
    ID_ROP2 		<= '0';
    ID_ROP3 		<= '0';
    ID_ROP4 		<= '0';
    ID_SPSR_RA 		<= (others=>'0');
	-- DEBUG_030826 : For base address forwarding
	-- DEBUG_030826b: For User mode register access and mode specific base register access
	ID_WREG1_CONV_MODE <= CPSR(4 downto 0);
	ID_WREG2_CONV_MODE <= CPSR(4 downto 0);
    ID_RREG1_CONV_MODE <= CPSR(4 downto 0); 
    ID_RREG2_CONV_MODE <= CPSR(4 downto 0); 
    ID_RREG3_CONV_MODE <= CPSR(4 downto 0); 
    ID_RREG4_CONV_MODE <= CPSR(4 downto 0); 

    X1_ALU_EN 		<= '0';
    X1_ALU_OP 		<= (others=>'0');
    X1_BRANCH1 		<= '0';
    X1_ADDR_SEL 	<= '0';
    X1_INST_COND 	<= "0000";
    X1_MUL_EN 		<= '0';
    X1_MUL_OP 		<= (others=>'0');
    X1_SHIFT_EN 	<= '0';
    X1_SHIFT_OP 	<= (others=>'0');
    X1_WCOND1_SEL 	<= '0';
    X1_WR_SEL 		<= "00";
    X1_DMIU_EN 		<= '0'; 
    X1_DMIU_OP 		<= (others=>'0');
	X1_CLZ_EN 		<= '0';

    X2_ADDR2_SEL 	<= '0';
    X2_BRANCH2 		<='0';
    X2_DMEM_EN 		<='0';
    X2_DMEM_OP 		<=(others=>'0');
    X2_DMOU_EN 		<= '0'; 
    X2_DMOU_OP 		<= (others=>'0');
    X2_WCOND2_SEL 	<= '0';
    X2_WR1_SEL 		<= (others=>'0');
    X2_WR2_SEL 		<= (others=>'0');
    X2_WCPSR_SEL 	<= (others=>'0');
    X2_WSPSR_SEL 	<= (others=>'0');

    WB_COND_WOP <= (others=>'0');
    WB_CPSR_WOP <= (others=>'0');
    WB_SPSR_WA 	<= (others=>'0');
    WB_SPSR_WOP <= (others=>'0');
    WB_WA1 		<= (others=>'0');
    WB_WA2 		<= (others=>'0');
    WB_WOP1 	<= (others=>'0');
    WB_WOP2 	<= (others=>'0');

	--
	-- Condition Variable
	--
--	if(cur_inst(31 downto 28)/="1110") then -- AL Always(unconditional)
--		ID_COND_ROP <= OP_EXEC; -- Optimization is required in next version!!!
--	end if;

	-- DEBUG_0821b: omitted
	ID_COND_ROP <= OP_EXEC;

	-- COND field	
	X1_INST_COND<= cur_inst(31 downto 28);

	-- DEBUG_030722b: SPSR_RA
	ID_SPSR_RA <= spsr_addr;


	----------------------
	----------------------
	-- 1. SIMPLE_INST 
	----------------------
	----------------------
	if( cur_state = SIMPLE_INST) then


		-------------------------------
		-- Exception processing
		-------------------------------

		-------------------
		-- Data Abort
		-------------------
		if(DABORT_ff1='1') then

			-- DEBUG_030719
			X1_INST_COND<= "1110"; -- Always

			-- R14_abt(R4->WR_R4->X2_WR2 path)
        	ID_R4_SEL <= S_R4_ABORT_PC_8; --- Aborted inst PC+8 
			ID_WREG2_CONV_MODE <= MODE_ABT; -- R14_svc
			X1_WR_SEL <= S_X1_WR_R4;
			X2_WR2_SEL <= S_X2_WR2_WR;
           	WB_WOP2(1 downto 0)	<= OP_X1_EXEC; WB_WA2 <= "1110"; 

			-- SPSR_abt(CPSR forwarding path)
			WB_SPSR_WA	 <= ADDR_SPSR_ABT;
    		X2_WSPSR_SEL <= S_X2_WSPSR_CPSR; WB_SPSR_WOP <= "1111"; 

			-- CPSR (CPSR direct path)
			-- CPSR[6] is unchanged
           	ID_R1_SEL <= S_R1_IMMED; ID_R1_IMMED <= C_ZERO24 & '1' & CPSR(6) & '0' & MODE_ABT;
    		X2_WCPSR_SEL <= S_X2_WCPSR_R1; WB_CPSR_WOP <= "0001";  -- Update low 8bits no need cond forwarding

			-- PC (R3 direct path)
           	ID_R3_SEL <= S_R3_IMMED; 
			if(HIVECS='1') then
				ID_R3_IMMED <=  "1111111111111111" & "0000000000010000"; -- 0xFFFF0010
			else
				ID_R3_IMMED <=  "0000000000000000" & "0000000000010000"; -- 0x00000010
			end if;
			X2_BRANCH2 <= '1'; X2_ADDR2_SEL <= S_X2_ADDR2_R3;

		------------------
		-- Exception FIQ 
		------------------
		elsif( NFIQ_ff1='0' and CPSR(6)='0' and 
			-- OPT_TIME_030814: break combinational signal
--			X1_BRANCH1_IN='0' and X1_BRANCH2_IN='0' and X2_BRANCH2_IN='0' and 
			-- DEBUG_030721c: Branch delay
			X1_BRANCH1_IN_ff1='0' and X2_BRANCH2_IN_ff1='0' and 
			STALL_ff1='0' and FLUSH_ff1='0' ) then

			-- DEBUG_030719
			X1_INST_COND<= "1110"; -- Always
			
			-- R14_irq(R4->WR_R4->X2_WR2 path)
        	ID_R4_SEL <= S_R4_PC_4; --- PC+4
			ID_WREG2_CONV_MODE <= MODE_FIQ; -- R14_fiq
			X1_WR_SEL <= S_X1_WR_R4;
			X2_WR2_SEL <= S_X2_WR2_WR;
           	WB_WOP2(1 downto 0)	<= OP_X1_EXEC; WB_WA2 <= "1110"; -- R14

			-- SPSR_irq (CPSR forwarding path)
			WB_SPSR_WA	 <= ADDR_SPSR_FIQ;
    		X2_WSPSR_SEL <= S_X2_WSPSR_CPSR; WB_SPSR_WOP <= "1111"; 

			-- CPSR (CPSR direct path)
           	ID_R1_SEL <= S_R1_IMMED; ID_R1_IMMED <= C_ZERO24 & '1' & '1' & '0' & MODE_FIQ;
    		X2_WCPSR_SEL <= S_X2_WCPSR_R1; WB_CPSR_WOP <= "0001";  -- Update low 8bits no need cond forwarding

			-- PC (R3 direct path)
           	ID_R3_SEL <= S_R3_IMMED; 
			if(HIVECS='1') then
				ID_R3_IMMED <=  "1111111111111111" & "0000000000011100"; -- 0xFFFF001C
			else
				ID_R3_IMMED <=  "0000000000000000" & "0000000000011100"; -- 0x0000001C
			end if;
			X2_BRANCH2 <= '1'; X2_ADDR2_SEL <= S_X2_ADDR2_R3;

			-- DELETE_030825
			-- next_inst 	<= cur_inst; -- Inst_code stall

		------------------
		-- Exception IRQ
		------------------
		elsif( NIRQ_ff1='0' and CPSR(7)='0' and 
			-- OPT_TIME_030814: break combinational signal
--			X1_BRANCH1_IN='0' and X1_BRANCH2_IN='0' and X2_BRANCH2_IN='0' and 
			-- DEBUG_030721c: Branch delay
			X1_BRANCH1_IN_ff1='0' and X2_BRANCH2_IN_ff1='0' and 
			STALL_ff1='0' and FLUSH_ff1='0' ) then

			-- DEBUG_030719
			X1_INST_COND<= "1110"; -- Always
			
			-- R14_irq(R4->WR_R4->X2_WR2 path)
        	ID_R4_SEL <= S_R4_PC_4; --- PC+4
			ID_WREG2_CONV_MODE <= MODE_IRQ; -- R14_irq
			X1_WR_SEL <= S_X1_WR_R4;
			X2_WR2_SEL <= S_X2_WR2_WR;
           	WB_WOP2(1 downto 0)	<= OP_X1_EXEC; WB_WA2 <= "1110"; -- R14

			-- SPSR_irq (CPSR forwarding path)
			WB_SPSR_WA	 <= ADDR_SPSR_IRQ;
    		X2_WSPSR_SEL <= S_X2_WSPSR_CPSR; WB_SPSR_WOP <= "1111"; 

			-- CPSR (CPSR direct path)
			-- CPSR[6] is unchanged
           	ID_R1_SEL <= S_R1_IMMED; ID_R1_IMMED <= C_ZERO24 & '1' & CPSR(6) & '0' & MODE_IRQ;
    		X2_WCPSR_SEL <= S_X2_WCPSR_R1; WB_CPSR_WOP <= "0001";  -- Update low 8bits no need cond forwarding

			-- PC (R3 direct path)
           	ID_R3_SEL <= S_R3_IMMED; 
			if(HIVECS='1') then
				ID_R3_IMMED <=  "1111111111111111" & "0000000000011000"; -- 0xFFFF0018
			else
				ID_R3_IMMED <=  "0000000000000000" & "0000000000011000"; -- 0x00000018
			end if;
			X2_BRANCH2 <= '1'; X2_ADDR2_SEL <= S_X2_ADDR2_R3;

			-- DELETE_030825
			-- next_inst 	<= cur_inst; -- Inst_code stall

		-------------------
		-- Prefetch Abort
		-------------------
		elsif(cur_iabort='1') then

			-- DEBUG_030719
			X1_INST_COND<= "1110"; -- Always

			-- R14_abt(R4->WR_R4->X2_WR2 path)
        	ID_R4_SEL <= S_R4_PC_4; --- PC+4
			ID_WREG2_CONV_MODE <= MODE_ABT; -- R14_svc
			X1_WR_SEL <= S_X1_WR_R4;
			X2_WR2_SEL <= S_X2_WR2_WR;
           	WB_WOP2(1 downto 0)	<= OP_X1_EXEC; WB_WA2 <= "1110"; 

			-- SPSR_abt(CPSR forwarding path)
			WB_SPSR_WA	 <= ADDR_SPSR_ABT;
    		X2_WSPSR_SEL <= S_X2_WSPSR_CPSR; WB_SPSR_WOP <= "1111"; 

			-- CPSR (CPSR direct path)
			-- CPSR[6] is unchanged
           	ID_R1_SEL <= S_R1_IMMED; ID_R1_IMMED <= C_ZERO24 & '1' & CPSR(6) & '0' & MODE_ABT;
    		X2_WCPSR_SEL <= S_X2_WCPSR_R1; WB_CPSR_WOP <= "0001";  -- Update low 8bits no need cond forwarding

			-- PC (R3 direct path)
           	ID_R3_SEL <= S_R3_IMMED; 
			if(HIVECS='1') then
				ID_R3_IMMED <=  "1111111111111111" & "0000000000001100"; -- 0xFFFF000C
			else
				ID_R3_IMMED <=  "0000000000000000" & "0000000000001100"; -- 0x0000000C
			end if;
			X2_BRANCH2 <= '1'; X2_ADDR2_SEL <= S_X2_ADDR2_R3;

		---------
		-- UNDEF
		---------
		-- See Figure 3-1 ARM instruction set summary
		elsif( (cur_inst(31 downto 28)="1111") or 	-- include Branch and branch with link and change to Thumb
			   (cur_inst(27 downto 23)="00110" and cur_inst(21 downto 20)="00") or -- Undefined instruction[3]
			   (cur_inst(27 downto 25)="011" and cur_inst(4)='1') or  	-- Undefined instruction
			   (cur_inst(27 downto 25)="110") or  	-- Coprocessor load/store and double register transfers
			   (cur_inst(27 downto 24)="1110")) then-- Coprocessor data processing and register transfers
		-- Cause ToyARM don't support Thumb instruction!
			-- DEBUG_030719
			X1_INST_COND<= "1110"; -- Always

			-- R14_und(R4->WR_R4->X2_WR2 path)
        	ID_R4_SEL <= S_R4_PC_4; --- PC+4
			ID_WREG2_CONV_MODE <= MODE_UND; -- R14_und
			X1_WR_SEL <= S_X1_WR_R4;
			X2_WR2_SEL <= S_X2_WR2_WR;
           	WB_WOP2(1 downto 0)	<= OP_X1_EXEC; WB_WA2 <= "1110"; 

			-- SPSR_svc(CPSR forwarding path)
			WB_SPSR_WA	 <= ADDR_SPSR_UND;
    		X2_WSPSR_SEL <= S_X2_WSPSR_CPSR; WB_SPSR_WOP <= "1111"; 

			-- CPSR (CPSR direct path)
			-- CPSR[6] is unchanged
           	ID_R1_SEL <= S_R1_IMMED; ID_R1_IMMED <= C_ZERO24 & '1' & CPSR(6) & '0' & MODE_UND;
    		X2_WCPSR_SEL <= S_X2_WCPSR_R1; WB_CPSR_WOP <= "0001";  -- Update low 8bits no need cond forwarding

			-- PC (R3 direct path)
           	ID_R3_SEL <= S_R3_IMMED; 
			if(HIVECS='1') then
				ID_R3_IMMED <=  "1111111111111111" & "0000000000000100"; -- 0xFFFF0004
			else
				ID_R3_IMMED <=  "0000000000000000" & "0000000000000100"; -- 0x00000004
			end if;
			X2_BRANCH2 <= '1'; X2_ADDR2_SEL <= S_X2_ADDR2_R3;

		------------------------
		-- Normal Instruction
		------------------------

		--------------------------
		-- COND "000"
		--------------------------

		--
		-- First execute all miscellaneous instructions and then the data processing instruction
		--

		--
		-- See Figure 3-2 Multiplies and extra load/store instructions
		--
		--                 : cond "000"       		~ "1xx1" 
		-- Multiply        : cond "000" "000"    	~ "1001"
		-- Multiply long   : cond "000" "01"     	~ "1001"
		-- Swap			   : cond "000" "10x00"  	~ "1001"
		-- Load Store extra: cond "000"       		~ "1xx1"
		--

		---------------------------------
		-- 1.1 MUL,MULS,MLA,MLA... (000)
		---------------------------------
		elsif( (cur_inst(27 downto 22) = "000000" and cur_inst(7 downto 4)="1001") or
			(cur_inst(27 downto 23) = "00001" and cur_inst(7 downto 4)="1001") 	) then

           	ID_ROP1 <= OP_EXEC; ID_R1_SEL <= S_R1_REG; ID_RA1 <= cur_inst(3 downto 0);
           	ID_ROP2 <= OP_EXEC; ID_R2_SEL <= S_R2_REG; ID_RA2 <= cur_inst(11 downto 8);
			-- accumulate
			-- OP(2): long, OP(1): sign, OP(0): ACC
	 		X1_MUL_EN 	<= '1'; X1_MUL_OP <= cur_inst(23 downto 21);
			if(cur_inst(23) ='0') then
            	WB_WOP1(1 downto 0)	<= OP_X2_EXEC; WB_WA1 <= cur_inst(19 downto 16);
				if( cur_inst(21) = '1') then -- ACC
           			ID_ROP3 <= OP_EXEC; ID_R3_SEL <= S_R3_REG; ID_RA3 <= cur_inst(15 downto 12);
				else
				-- DEBUG_030728c: If no acc, Acc immediate value must be 0
           			ID_R3_SEL <= S_R3_IMMED; ID_R3_IMMED <= (others=>'0');
				end if;
			elsif(cur_inst(23) ='1') then -- Long multiply
            	WB_WOP1(1 downto 0)	<= OP_X2_EXEC; WB_WA1 <= cur_inst(15 downto 12);
            	WB_WOP2(1 downto 0)	<= OP_X2_EXEC; WB_WA2 <= cur_inst(19 downto 16);
				if( cur_inst(21) = '1' ) then -- ACC
           			ID_ROP3 <= OP_EXEC; ID_R3_SEL <= S_R3_REG; ID_RA3 <= cur_inst(15 downto 12);
           			ID_ROP4 <= OP_EXEC; ID_R4_SEL <= S_R4_REG; ID_RA4 <= cur_inst(19 downto 16);
				else
				-- DEBUG_030728c: If no acc, Acc immediate value must be 0
           			ID_R3_SEL <= S_R3_IMMED; ID_R3_IMMED <= (others=>'0');
           			ID_R4_SEL <= S_R4_IMMED; ID_R4_IMMED <= (others=>'0');
				end if;
			end if;
    		X1_WCOND1_SEL 	<= S_X1_COND_CPSR_F;
    		X2_WCOND2_SEL 	<= S_X2_COND_MUL;
    		X2_WR1_SEL 		<= S_X2_WR1_MUL_LO;
    		X2_WR2_SEL 		<= S_X2_WR2_MUL_HI;
			-- DEBUG_030725: Flag bit Error
			WB_COND_WOP <= OP_X2 & cur_inst(20); WB_CPSR_WOP <= cur_inst(20) & "000"; 

		-----------------------------
		-- 1.2 SWP, SWPB (000)
		-----------------------------
		elsif( (cur_inst(27 downto 23) = "00010") and (cur_inst(21 downto 20)="00") and 
				(cur_inst(11 downto 8)="0000") and (cur_inst(7 downto 4)="1001") ) then
			-- SWP1:(Load)
			-- Address Base			
           	ID_ROP1 <= OP_EXEC; ID_R1_SEL <= S_R1_REG; ID_RA1 <= cur_inst(19 downto 16);

			-- Address Offset
			X1_ADDR_SEL <= S_X1_ADDR1_R1;
			-- B(22) Byte
			if( cur_inst(22) = '1') then -- Half
           		X2_DMEM_EN <= '1'; X2_DMEM_OP <= "000"; -- Load Byte
           		X2_DMOU_EN <= '1'; X2_DMOU_OP <= OP_DMOU_UBYTE;
			else -- Byte
           		X2_DMEM_EN <= '1'; X2_DMEM_OP <= "100"; -- Load Word
           		X2_DMOU_EN <= '1'; X2_DMOU_OP <= OP_DMOU_WORD;
			end if;

    		X2_WR1_SEL 	<= S_X2_WR1_DMEM;
			-- NO_STALL & BACKUP_WR1 
			WB_WOP2 <= OP_WOP_NO_STALL or OP_WOP_BACKUP_WR1;

			next_inst <= cur_inst; -- Inst_code stall
			next_state <= COMPLEX_INST;
			next_state_c <= S_SWP2;

		----------------------------------------
		-- 1.3 Extra Load/stores(see load/store) 
		----------------------------------------
		-- See 5.3 Addressing Mode 3 - Miscellaneous Loads and Stores
		-- Load Store extra: cond "000"       		~ "1xx1"
		elsif( cur_inst(27 downto 25) = "000" and cur_inst(7)='1' and cur_inst(4)='1' and
			   (cur_inst(22)='1' or cur_inst(11 downto 8)="0000") ) then
			-- L(20) Load(1) or Sotre(0)
			if(cur_inst(20)='1') then -- Load
           		X2_DMOU_EN <= '1'; X2_DMOU_OP <= '0' & cur_inst(6 downto 5);
    			X2_WR1_SEL 	<= S_X2_WR1_DMEM;
				if( cur_inst(15 downto 12) = "1111" ) then -- load PC
					X2_BRANCH2 <= '1'; X2_ADDR2_SEL <= S_X2_ADDR2_DMEM;
				else
            		WB_WOP1(1 downto 0)	<= OP_X2_EXEC; WB_WA1 <= cur_inst(15 downto 12);
				end if;	
			else -- Store
           		ID_ROP4 <= OP_EXEC; ID_R4_SEL <= S_R4_REG; ID_RA4 <= cur_inst(15 downto 12);
    			X1_DMIU_EN 	<= '1'; X1_DMIU_OP 	<= '0' & cur_inst(6 downto 5);
			end if;

			-- Address Base			
           	ID_ROP1 <= OP_EXEC; ID_R1_SEL <= S_R1_REG; ID_RA1 <= cur_inst(19 downto 16);

			-- I(22)
			-- Address Offset
			if( cur_inst(22) = '1' ) then -- Immediate offset/index
           		ID_R2_SEL <= S_R2_IMMED; ID_R2_IMMED <= C_ZERO24 & cur_inst(11 downto 8) & cur_inst(3 downto 0);
	 			X1_SHIFT_EN <= '1'; X1_SHIFT_OP <= "0000"; -- Logical Shift Left
           		ID_R3_SEL <= S_R3_IMMED; ID_R3_IMMED <= (others=>'0');

			-- Register offset/index
			else	
           		ID_ROP2 <= OP_EXEC; ID_R2_SEL <= S_R2_REG; ID_RA2 <= cur_inst(3 downto 0);
	 			X1_SHIFT_EN <= '1'; X1_SHIFT_OP <= "0000"; -- Logical Shift Left
           		ID_R3_SEL <= S_R3_IMMED; ID_R3_IMMED <= (others=>'0');
			end if;

			-- H(5) Half or Byte
			if( cur_inst(5) = '1') then -- Half
           		X2_DMEM_EN <= '1'; X2_DMEM_OP <= "01" & (not cur_inst(20)); -- L = '1' -> read = '0'
			else -- Byte
           		X2_DMEM_EN <= '1'; X2_DMEM_OP <= "00" & (not cur_inst(20)); -- L = '0' -> write = '1'
			end if;

			-- U(23) Add or Subtract
			if(cur_inst(23) = '1') then -- U == 1
 				X1_ALU_EN 	<= '1'; X1_ALU_OP <= "0100"; -- ADD
			else -- U == 0
 				X1_ALU_EN 	<= '1'; X1_ALU_OP <= "0010"; -- SUB
			end if;

			-- P(24), W(21)
			-- 1. Memory Access ADDR 
			if(cur_inst(24)='1') then -- Pre-indexed addressing
				X1_ADDR_SEL <= S_X1_ADDR1_ALU;
			else -- Post-indexed addressing
				X1_ADDR_SEL <= S_X1_ADDR1_R1;
			end if;

			-- 2. Write Back Addr
			if(cur_inst(24)='1') then -- Pre-indexed addressing
				-- W(21) Write Back
				if(cur_inst(21)='1') then -- Write Back
    				X2_WR2_SEL 	<= S_X2_WR2_WR;
           			WB_WOP2(1 downto 0)	<= OP_X1_EXEC; WB_WA2 <= cur_inst(19 downto 16);
				end if;
			else -- Post-indexed addressing
				-- W(21) Write Back
				if(cur_inst(21)='0') then -- Normal write back
    				X2_WR2_SEL 	<= S_X2_WR2_WR;
           			WB_WOP2(1 downto 0)	<= OP_X1_EXEC; WB_WA2 <= cur_inst(19 downto 16);
				end if;
			end if;

		--
		-- See Figure 3-3 Miscellaneous instructions
		-- Move status register to register 
		-- Count leading zeros
		-- Software breakpoint
		--                 : cond "00010"       		~ "1xx1" 

		--------------------------
		-- 2.1 MRS (xPSR->R#) (000)
		--------------------------
		elsif(cur_inst(27 downto 23)="00010" and cur_inst(21 downto 20)="00" and
			  cur_inst(19 downto 16)="1111" and cur_inst(11 downto 0)="000000000000" ) then 
			-- MRS: NOP->NOP->MRS
			next_inst 		<= cur_inst; -- Inst_code stall
			next_state 		<= COMPLEX_INST;
			next_state_c 	<= S_MRS2;

		--------------------------------------
		-- 2.2 MSR (R#->xPSR) -- See 4.1.32 MSR 
		--------------------------------------
		-- FIX_030825     (00x)
		elsif(cur_inst(27 downto 26)="00" and cur_inst(24 downto 23)="10" and cur_inst(21 downto 20)="10" and
			  cur_inst(15 downto 12)="1111" and 
			  (cur_inst(25)='1' or cur_inst(11 downto 4)="00000000") ) then  -- Immediate or Register
			-- MSR: MSR->NOP->NOP

			-- Immediate operand
			if(cur_inst(25)='1' ) then
				ID_R2_SEL 	<= S_R2_IMMED; ID_R2_IMMED <= C_ZERO24 & cur_inst(7 downto 0);
				ID_R3_SEL 	<= S_R3_IMMED; ID_R3_IMMED <= C_ZERO24 & "000" & cur_inst(11 downto 8) & '0'; -- (rotate_imm*2) see A5.1.12
	 			X1_ALU_EN 	<= '1'; X1_ALU_OP <= OP_MOV;
	 			X1_SHIFT_EN <= '1'; X1_SHIFT_OP <= "1111"; -- see A5.1.12
			-- Register Operand 
			else
--			elsif(cur_inst(11 downto 4)="00000000")  then
           		ID_ROP1 <= OP_EXEC; ID_R1_SEL <= S_R1_REG; ID_RA1 <= cur_inst(3 downto 0);
           		ID_R2_SEL <= S_R2_IMMED; ID_R2_IMMED <= (others=>'0');
           		ID_R3_SEL <= S_R3_IMMED; ID_R3_IMMED <= (others=>'0');

	 			X1_ALU_EN 	<= '1'; X1_ALU_OP <= OP_ADD;
	 			X1_SHIFT_EN <= '1'; X1_SHIFT_OP <= (others=>'0');
			end if;

			X1_WR_SEL <= S_X1_WR_ALU;

			-- R(22)
			if( cur_inst(22) = '0') then -- To CPSR
    			X2_WCPSR_SEL <= S_X2_WCPSR_X1_WR; WB_CPSR_WOP <= cur_inst(19 downto 16); 
			else						 -- To SPSR
    			X2_WSPSR_SEL <= S_X2_WSPSR_X1_WR; WB_CPSR_WOP <= cur_inst(19 downto 16); 
             	WB_SPSR_WA <= spsr_addr;
			end if;

			-- DEBUG_030826c
			-- Any writes to CPSR[23:0] in User mode are ignored
			-- (so that User mode programs cannot change to a privileged mode).
			if(CPSR(4 downto 0)=MODE_USER) then
    			WB_CPSR_WOP(2 downto 0) <= "000"; 
			end if;

			next_inst 		<= cur_inst; -- Inst_code stall
			next_state 		<= COMPLEX_INST;
			next_state_c 	<= S_MSR2;

		-------------------
		-- 2.3 CLZ
		-------------------
		-- Supported in Architecture Version 5 and above, but Toyarm supports CLS
		elsif(cur_inst(27 downto 20) = "00010110" and 
			  cur_inst(19 downto 16)="1111" and cur_inst(11 downto 8)="1111" and cur_inst(7 downto 4)="0001" ) then

			-- ID Stage Operation
			ID_R1_SEL <= S_R1_REG; ID_ROP1 <= OP_EXEC; ID_RA1 <= cur_inst(3 downto 0);

			-- X1 Stage Operation
	 		X1_CLZ_EN 	<= '1';
    		X1_WR_SEL 		<= S_X1_WR_CLZ;
			 			 
			-- X2 Stage Operation
    		X2_WR1_SEL 		<= S_X2_WR1_WR;

			-- WB Stage Operation
           	WB_WOP1(1 downto 0)	<= OP_X1_EXEC; WB_WA1 <= cur_inst(15 downto 12);

		-------------------
		-- 2.4 BKPT
		-------------------
		elsif(cur_inst(31 downto 28) = "1110" and 
			  cur_inst(27 downto 20)="00010010" and cur_inst(7 downto 4)="0111" ) then

			-- R14_abt(R4->WR_R4->X2_WR2 path)
        	ID_R4_SEL <= S_R4_PC_4; --- PC+4
			ID_WREG2_CONV_MODE <= MODE_ABT; -- R14_svc
			X1_WR_SEL <= S_X1_WR_R4;
			X2_WR2_SEL <= S_X2_WR2_WR;
           	WB_WOP2(1 downto 0)	<= OP_X1_EXEC; WB_WA2 <= "1110"; 

			-- SPSR_abt(CPSR forwarding path)
			WB_SPSR_WA	 <= ADDR_SPSR_ABT;
    		X2_WSPSR_SEL <= S_X2_WSPSR_CPSR; WB_SPSR_WOP <= "1111"; 

			-- CPSR (CPSR direct path)
			-- CPSR[6] is unchanged
           	ID_R1_SEL <= S_R1_IMMED; ID_R1_IMMED <= C_ZERO24 & '1' & CPSR(6) & '0' & MODE_ABT;
    		X2_WCPSR_SEL <= S_X2_WCPSR_R1; WB_CPSR_WOP <= "0001";  -- Update low 8bits no need cond forwarding

			-- PC (R3 direct path)
           	ID_R3_SEL <= S_R3_IMMED; 
			if(HIVECS='1') then
				ID_R3_IMMED <=  "1111111111111111" & "0000000000001100"; -- 0xFFFF000C
			else
				ID_R3_IMMED <=  "0000000000000000" & "0000000000001100"; -- 0x0000000C
			end if;
			X2_BRANCH2 <= '1'; X2_ADDR2_SEL <= S_X2_ADDR2_R3;

		--------------------------
		--------------------------
		-- COND "000"
		-- COND "001"
		--------------------------
		--------------------------
		-- 3. Data processing immediate shift
		elsif( (cur_inst(27 downto 26) = "00" ) ) then

    		ID_MULTI_CYCLE <= '0';
			next_state <= SIMPLE_INST;

			case cur_inst(24 downto 21) is

			-- Data processing Inst <op3>
			when OP_ADD|OP_SUB|OP_RSB| OP_ADC|OP_SBC|OP_RSC|OP_AND|OP_BIC|OP_EOR|OP_ORR =>

				-- ID Stage Operation
				-- Addressing Mode1 - Data-processing operands on page A5-2
           		ID_ROP1 <= OP_EXEC; ID_R1_SEL <= S_R1_REG; ID_RA1 <= cur_inst(19 downto 16);
				if(cur_inst(25) = '1') then -- 32-bit immediate
					ID_R2_SEL 	<= S_R2_IMMED; ID_R2_IMMED <= C_ZERO24 & cur_inst(7 downto 0);
					ID_R3_SEL 	<= S_R3_IMMED; ID_R3_IMMED <= C_ZERO24 & "000" & cur_inst(11 downto 8) & '0'; -- (rotate_imm*2) see A5.1.12
				elsif(cur_inst(4)='0') then -- Immediate shifts
					ID_R2_SEL <= S_R2_REG; ID_ROP2 <= OP_EXEC; ID_RA2 <= cur_inst(3 downto 0);
					ID_R3_SEL <= S_R3_IMMED; ID_R3_IMMED <= C_ZERO24 & "000" & cur_inst(11 downto 7);
				elsif(cur_inst(7)='0') then -- Register shifts
					ID_R2_SEL <= S_R2_REG; ID_ROP2 <= OP_EXEC; ID_RA2 <= cur_inst(3 downto 0);
					ID_R3_SEL <= S_R3_REG; ID_ROP3 <= OP_EXEC; ID_RA3 <= cur_inst(11 downto 8);
				end if;

				-- X1 Stage Operation
				X1_INST_COND<= cur_inst(31 downto 28);
	 			X1_ALU_EN 	<= '1'; X1_ALU_OP <= cur_inst(24 downto 21);
				-- Addressing Mode1 - Data-processing operands on page A5-2
				if(cur_inst(25) = '1') then -- 32-bit immediate
	 				X1_SHIFT_EN <= '1'; X1_SHIFT_OP <= "1111"; -- see A5.1.12
				elsif(cur_inst(4)='0') then -- Immediate shifts
	 				X1_SHIFT_EN <= '1'; X1_SHIFT_OP <= '0' & cur_inst(6 downto 4);
				elsif(cur_inst(7)='0') then -- Register shifts
	 				X1_SHIFT_EN <= '1'; X1_SHIFT_OP <= '0' & cur_inst(6 downto 4);
				end if;

    			X1_WCOND1_SEL 	<= S_X1_COND_ALU;
    			X1_WR_SEL 		<= S_X1_WR_ALU;
			 			 
				-- X2 Stage Operation
    			X2_WCOND2_SEL 	<= S_X2_COND_X1;
    			X2_WR1_SEL 		<= S_X2_WR1_WR;

				-- WB Stage Operation
				-- IF Rd=R15
				if( cur_inst(15 downto 12) = "1111" ) then -- if (Rd /= PC)
					X1_BRANCH1 <= '1'; X1_ADDR_SEL <= S_X1_ADDR1_ALU;

					if( cur_inst(20) = '1') then
    					X2_WCPSR_SEL <= S_X2_WCPSR_SPSR; WB_CPSR_WOP <= "1111"; 
					end if;
				else
					-- WB Stage Operation
            		WB_WOP1(1 downto 0)	<= OP_X1_EXEC; WB_WA1 <= cur_inst(15 downto 12);
					-- DEBUG_030725: Flag bit error
					WB_COND_WOP <= OP_X1 & cur_inst(20); WB_CPSR_WOP <= cur_inst(20) & "000"; 
				end if;


			-- Data processing Inst <op1>
			when OP_MOV|OP_MVN =>

				-- ID Stage Operation
				-- Addressing Mode1 - Data-processing operands on page A5-2
				if(cur_inst(25) = '1') then -- 32-bit immediate
					ID_R2_SEL 	<= S_R2_IMMED; ID_R2_IMMED <= C_ZERO24 & cur_inst(7 downto 0);
					ID_R3_SEL 	<= S_R3_IMMED; ID_R3_IMMED <= C_ZERO24 & "000" & cur_inst(11 downto 8) & '0'; -- (rotate_imm*2) see A5.1.12
				elsif(cur_inst(4)='0') then -- Immediate shifts
					ID_R2_SEL <= S_R2_REG; ID_ROP2 <= OP_EXEC; ID_RA2 <= cur_inst(3 downto 0);
					ID_R3_SEL <= S_R3_IMMED; ID_R3_IMMED <= C_ZERO24 & "000" & cur_inst(11 downto 7);
				elsif(cur_inst(7)='0') then -- Register shifts
					ID_R2_SEL <= S_R2_REG; ID_ROP2 <= OP_EXEC; ID_RA2 <= cur_inst(3 downto 0);
					ID_R3_SEL <= S_R3_REG; ID_ROP3 <= OP_EXEC; ID_RA3 <= cur_inst(11 downto 8);
				end if;

				-- X1 Stage Operation
				X1_INST_COND<= cur_inst(31 downto 28);
	 			X1_ALU_EN 	<= '1'; X1_ALU_OP <= cur_inst(24 downto 21);
				-- Addressing Mode1 - Data-processing operands on page A5-2
				if(cur_inst(25) = '1') then -- 32-bit immediate
	 				X1_SHIFT_EN <= '1'; X1_SHIFT_OP <= "1111"; -- see A5.1.12
				elsif(cur_inst(4)='0') then -- Immediate shifts
	 				X1_SHIFT_EN <= '1'; X1_SHIFT_OP <= '0' & cur_inst(6 downto 4);
				elsif(cur_inst(7)='0') then -- Register shifts
	 				X1_SHIFT_EN <= '1'; X1_SHIFT_OP <= '0' & cur_inst(6 downto 4);
				end if;

    			X1_WCOND1_SEL 	<= S_X1_COND_ALU;
    			X1_WR_SEL 		<= S_X1_WR_ALU;
			 			 
				-- X2 Stage Operation
    			X2_WCOND2_SEL 	<= S_X2_COND_X1;
    			X2_WR1_SEL 		<= S_X2_WR1_WR;

				-- WB Stage Operation
				-- IF Rd=R15
				if( cur_inst(15 downto 12) = "1111" ) then -- if (Rd /= PC)
					X1_BRANCH1 <= '1'; X1_ADDR_SEL <= S_X1_ADDR1_ALU;

					if( cur_inst(20) = '1') then
    					X2_WCPSR_SEL <= S_X2_WCPSR_SPSR; WB_CPSR_WOP <= "1111"; 
					end if;
				else
					-- WB Stage Operation
            		WB_WOP1(1 downto 0)	<= OP_X1_EXEC; WB_WA1 <= cur_inst(15 downto 12);
					-- DEBUG_030725: Flag bit error
					WB_COND_WOP <= OP_X1 & cur_inst(20); WB_CPSR_WOP <= cur_inst(20) & "000"; 
				end if;

			-- Data processing Inst <op2>
			when OP_CMP|OP_CMN|OP_TST|OP_TEQ =>

				-- ID Stage Operation
				-- Addressing Mode1 - Data-processing operands on page A5-2
           		ID_ROP1 <= OP_EXEC; ID_R1_SEL <= S_R1_REG; ID_RA1 <= cur_inst(19 downto 16);
				if(cur_inst(25) = '1') then -- 32-bit immediate
					ID_R2_SEL 	<= S_R2_IMMED; ID_R2_IMMED <= C_ZERO24 & cur_inst(7 downto 0);
					ID_R3_SEL 	<= S_R2_IMMED; ID_R3_IMMED <= C_ZERO24 & "000" & cur_inst(11 downto 8) & '0'; -- (rotate_imm*2) see A5.1.12
				elsif(cur_inst(4)='0') then -- Immediate shifts
					ID_R2_SEL <= S_R2_REG; ID_ROP2 <= OP_EXEC; ID_RA2 <= cur_inst(3 downto 0);
					ID_R3_SEL <= S_R3_IMMED; ID_R3_IMMED <= C_ZERO24 & "000" & cur_inst(11 downto 7);
				elsif(cur_inst(7)='0') then -- Register shifts
					ID_R2_SEL <= S_R2_REG; ID_ROP2 <= OP_EXEC; ID_RA2 <= cur_inst(3 downto 0);
					ID_R3_SEL <= S_R3_REG; ID_ROP3 <= OP_EXEC; ID_RA3 <= cur_inst(11 downto 8);
				end if;

				-- X1 Stage Operation
	 			X1_ALU_EN 	<= '1'; X1_ALU_OP <= cur_inst(24 downto 21);
				-- Addressing Mode1 - Data-processing operands on page A5-2
				if(cur_inst(25) = '1') then -- 32-bit immediate
	 				X1_SHIFT_EN <= '1'; X1_SHIFT_OP <= "1111"; -- see A5.1.12
				elsif(cur_inst(4)='0') then -- Immediate shifts
	 				X1_SHIFT_EN <= '1'; X1_SHIFT_OP <= '0' & cur_inst(6 downto 4);
				elsif(cur_inst(7)='0') then -- Register shifts
	 				X1_SHIFT_EN <= '1'; X1_SHIFT_OP <= '0' & cur_inst(6 downto 4);
				end if;
    			X1_WCOND1_SEL 	<= S_X1_COND_ALU; -- DEBUG_030716

				-- X2 Stage Operation
    			X2_WCOND2_SEL 	<= S_X2_COND_X1;

				-- WB Stage Operation
				-- DEBUG_030725b: FLAG bit error
				WB_COND_WOP <= OP_X1 & '1'; WB_CPSR_WOP <= "1000"; -- FLAG  

			when others =>

			end case;

		--------------------------
		-- COND "010"
		-- COND "011"
		--------------------------

		--------------------------------------------
		-- Load and Store Word or Unsigned Byte	
		--------------------------------------------
		-- See Addressing Mode2
		-- Immediate offset/index	: cond "010"
		-- Register offset/index 	: cond "011" ~ "0"
		--
		elsif( cur_inst(27 downto 25)="010" or (cur_inst(27 downto 25)="011" and cur_inst(4)='0')  ) then 
			-- L(20) Load(1) or Sotre(0)
			if(cur_inst(20)='1') then -- Load
           		X2_DMOU_EN <= '1'; 
				if( cur_inst(22) = '1') then -- BYTE
					X2_DMOU_OP <= OP_DMOU_UBYTE;
				else
					X2_DMOU_OP <= OP_DMOU_WORD;
				end if;
				-- DEBUG_030725: If target is R15
    			X2_WR1_SEL 	<= S_X2_WR1_DMEM;
				if( cur_inst(15 downto 12) = "1111" ) then -- load PC
					X2_BRANCH2 <= '1'; X2_ADDR2_SEL <= S_X2_ADDR2_DMEM;
				else
            		WB_WOP1(1 downto 0)	<= OP_X2_EXEC; WB_WA1 <= cur_inst(15 downto 12);
				end if;	
			else -- Store
           		ID_ROP4 <= OP_EXEC; ID_R4_SEL <= S_R4_REG; ID_RA4 <= cur_inst(15 downto 12);
				if( cur_inst(22) = '1') then -- BYTE
    				X1_DMIU_EN 	<= '1'; X1_DMIU_OP 	<= OP_DMIU_UBYTE;
				else
    				X1_DMIU_EN 	<= '1'; X1_DMIU_OP 	<= OP_DMIU_WORD;
				end if;
			end if;

			-- Address Base			
           	ID_ROP1 <= OP_EXEC; ID_R1_SEL <= S_R1_REG; ID_RA1 <= cur_inst(19 downto 16);

			-- Address Offset
			if( cur_inst(25) = '0' ) then -- Immediate offset/index
           		ID_R2_SEL <= S_R2_IMMED; ID_R2_IMMED <= C_ZERO20 & cur_inst(11 downto 0);
	 			X1_SHIFT_EN <= '1'; X1_SHIFT_OP <= "0000"; -- Logical Shift Left
           		ID_R3_SEL <= S_R3_IMMED; ID_R3_IMMED <= (others=>'0');

			-- Register offset/index
			elsif( cur_inst(11 downto 4) = "00000000" ) then 
           		ID_ROP2 <= OP_EXEC; ID_R2_SEL <= S_R2_REG; ID_RA2 <= cur_inst(3 downto 0);
	 			X1_SHIFT_EN <= '1'; X1_SHIFT_OP <= "0000"; -- Logical Shift Left
           		ID_R3_SEL <= S_R3_IMMED; ID_R3_IMMED <= (others=>'0');

			-- Scaled register offset/index
			else	
           		ID_ROP2 <= OP_EXEC; ID_R2_SEL <= S_R2_REG; ID_RA2 <= cur_inst(3 downto 0);
	 			X1_SHIFT_EN <= '1'; X1_SHIFT_OP <= '0' & cur_inst(6 downto 5) & '0'; -- Shift Immediate
           		ID_R3_SEL <= S_R3_IMMED; ID_R3_IMMED <= C_ZERO20 & "0000000" & cur_inst(11 downto 7);
			end if;

			-- B(22) Byte or Word
			if( cur_inst(22) = '1') then -- BYTE
           		X2_DMEM_EN <= '1'; X2_DMEM_OP <= "00" & (not cur_inst(20)); -- L = '1' -> read = '0'
			else -- WORD
           		X2_DMEM_EN <= '1'; X2_DMEM_OP <= "10" & (not cur_inst(20)); -- L = '0' --> write = '1'
			end if;

			-- U(23) Add or Subtract
			if(cur_inst(23) = '1') then -- U == 1
 				X1_ALU_EN 	<= '1'; X1_ALU_OP <= "0100"; -- ADD
			else -- U == 0
 				X1_ALU_EN 	<= '1'; X1_ALU_OP <= "0010"; -- SUB
			end if;

			-- P(24), W(21)
			-- 1. Memory Access ADDR 
			if(cur_inst(24)='1') then -- Pre-indexed addressing
				X1_ADDR_SEL <= S_X1_ADDR1_ALU;
			else -- Post-indexed addressing
				X1_ADDR_SEL <= S_X1_ADDR1_R1;
			end if;

			-- 2. Write Back Addr
			if(cur_inst(24)='1') then -- Pre-indexed addressing
				if(cur_inst(21)='1') then -- Write Back
    				X2_WR2_SEL 	<= S_X2_WR2_WR;
           			WB_WOP2(1 downto 0)	<= OP_X1_EXEC; WB_WA2 <= cur_inst(19 downto 16);
				end if;
			else -- Post-indexed addressing
				if(cur_inst(21)='0') then -- Normal write back
    				X2_WR2_SEL 	<= S_X2_WR2_WR;
           			WB_WOP2(1 downto 0)	<= OP_X1_EXEC; WB_WA2 <= cur_inst(19 downto 16);
				else -- Unprivileged  memory access LDRT, STRT... ???
    				X2_WR2_SEL 	<= S_X2_WR2_WR;
           			WB_WOP2(1 downto 0)	<= OP_X1_EXEC; WB_WA2 <= cur_inst(19 downto 16);
				end if;
			end if;


		--------------------------
		-- COND "100"
		--------------------------

		--------------------------
		-- LDM, STM (100)
		--------------------------
		--
		-- See Figure 3-1 Load/store multiple
		--
		elsif(cur_inst(27 downto 25)="100") then
			-- Startup
			-- 1. Backup Updated Base Address 
           	ID_ROP1 <= OP_EXEC; ID_R1_SEL <= S_R1_REG; ID_RA1 <= cur_inst(19 downto 16); 
			-- Start offset and ALU operation
	 		X1_SHIFT_EN <= '1'; X1_SHIFT_OP <= "0000"; -- Logical Shift Left
           	ID_R2_SEL <= S_R2_IMMED; 
			ID_R2_IMMED <= C_ZERO24 & "000" & next_register_list_sum;
			-- U(23)
			if(cur_inst(23) = '1') then -- IA|IB  	Updated Address=Rn+no*4
 				X1_ALU_EN 	<= '1'; X1_ALU_OP <= "0100"; -- ADD
			else 						-- DA|DB	Updated Address=Rn-no*4
 				X1_ALU_EN 	<= '1'; X1_ALU_OP <= "0010"; -- SUB
			end if;
			-- Offset & operation select
           	ID_R3_SEL <= S_R3_IMMED; ID_R3_IMMED <= C_ZERO24 & "00000010"; -- << 2

			-- WR Backup Path
			X1_WR_SEL 	<= S_X1_WR_ALU;
			X2_WR2_SEL 	<= S_X2_WR2_WR;
			WB_WOP2 	<= OP_WOP_BACKUP_WR2;

			-- Setup next value
			next_access_count 	<= unsigned(next_register_list_sum) - '1';
			next_register 		<= cur_inst(15 downto 0);
			next_inst 			<= cur_inst; -- Inst_code stall
			next_state 			<= COMPLEX_INST;
			next_state_c 		<= S_LDM_STM2;
			next_backup_rn 		<= '0';
			-- OPT_TIME_030903
			next_ldm_stm_first	<= '1';

		--------------------------
		-- COND "101"
		--------------------------
		--
		-- See Figure 3-1 Branch and branch with link
		--

		--------------------------
		-- B, BL (101)
		--------------------------
		elsif(cur_inst(27 downto 25) = "101") then
			X1_BRANCH1 <= '1'; X1_ADDR_SEL <= S_X1_ADDR1_ALU;
           	ID_ROP1 <= OP_EXEC; ID_R1_SEL <= S_R1_REG; ID_RA1 <= "1111"; -- Read PC
           	ID_R2_SEL <= S_R2_IMMED; 
			ID_R2_IMMED(31 downto 26) <= (others=>cur_inst(23));
			ID_R2_IMMED(25 downto 0)  <= cur_inst(23 downto 0) & "00"; -- SignExt(immed24<<2)
           	ID_R3_SEL <= S_R3_IMMED; ID_R3_IMMED <= (others=>'0');
	 		X1_ALU_EN 	<= '1'; X1_ALU_OP <= "0100"; -- ADD
	 		X1_SHIFT_EN <= '1'; X1_SHIFT_OP <= "0000"; -- Logical Shift Left

			if(cur_inst(24)='1') then -- LINK
           		ID_R4_SEL 	<= S_R4_PC_4; 
    			X1_WR_SEL 	<= S_X1_WR_R4;
    			X2_WR2_SEL 	<= S_X2_WR2_WR;
            	WB_WOP2(1 downto 0)	<= OP_X1_EXEC; WB_WA2 <= "1110"; --LR
			end if;
		
		--------------------------
		-- COND "111"
		--------------------------

		---------
		-- SWI
		---------
		-- FIX_030825: 
		elsif(cur_inst(31 downto 28) /= "1111" and cur_inst(27 downto 24) = "1111" ) then

			-- R14_svc(R4->WR_R4->X2_WR2 path)
        	ID_R4_SEL <= S_R4_PC_4; --- PC+4
			ID_WREG2_CONV_MODE <= MODE_SVC; -- R14_svc
			X1_WR_SEL <= S_X1_WR_R4;
			X2_WR2_SEL <= S_X2_WR2_WR;
           	WB_WOP2(1 downto 0)	<= OP_X1_EXEC; WB_WA2 <= "1110"; 

			-- SPSR_svc(CPSR forwarding path)
			WB_SPSR_WA	 <= ADDR_SPSR_SVC;
    		X2_WSPSR_SEL <= S_X2_WSPSR_CPSR; WB_SPSR_WOP <= "1111"; 

			-- CPSR (CPSR direct path)
			-- CPSR[6] is unchanged
           	ID_R1_SEL <= S_R1_IMMED; ID_R1_IMMED <= C_ZERO24 & '1' & CPSR(6) & '0' & MODE_SVC;
    		X2_WCPSR_SEL <= S_X2_WCPSR_R1; WB_CPSR_WOP <= "0001";  -- Update low 8bits no need cond forwarding

			-- PC (R3 direct path)
           	ID_R3_SEL <= S_R3_IMMED; 
			if(HIVECS='1') then
				ID_R3_IMMED <=  "1111111111111111" & "0000000000001000"; -- 0xFFFF0008
			else
				ID_R3_IMMED <=  "0000000000000000" & "0000000000001000"; -- 0x00000008
			end if;
			X2_BRANCH2 <= '1'; X2_ADDR2_SEL <= S_X2_ADDR2_R3;

		---------
		-- UNDEF
		---------
		else
			-- DEBUG_030719
			X1_INST_COND<= "1110"; -- Always

			-- R14_und(R4->WR_R4->X2_WR2 path)
        	ID_R4_SEL <= S_R4_PC_4; --- PC+4
			ID_WREG2_CONV_MODE <= MODE_UND; -- R14_und
			X1_WR_SEL <= S_X1_WR_R4;
			X2_WR2_SEL <= S_X2_WR2_WR;
           	WB_WOP2(1 downto 0)	<= OP_X1_EXEC; WB_WA2 <= "1110"; 

			-- SPSR_svc(CPSR forwarding path)
			WB_SPSR_WA	 <= ADDR_SPSR_UND;
    		X2_WSPSR_SEL <= S_X2_WSPSR_CPSR; WB_SPSR_WOP <= "1111"; 

			-- CPSR (CPSR direct path)
			-- CPSR[6] is unchanged
           	ID_R1_SEL <= S_R1_IMMED; ID_R1_IMMED <= C_ZERO24 & '1' & CPSR(6) & '0' & MODE_UND;
    		X2_WCPSR_SEL <= S_X2_WCPSR_R1; WB_CPSR_WOP <= "0001";  -- Update low 8bits no need cond forwarding

			-- PC (R3 direct path)
           	ID_R3_SEL <= S_R3_IMMED; 
			if(HIVECS='1') then
				ID_R3_IMMED <=  "1111111111111111" & "0000000000000100"; -- 0xFFFF0004
			else
				ID_R3_IMMED <=  "0000000000000000" & "0000000000000100"; -- 0x00000004
			end if;
			X2_BRANCH2 <= '1'; X2_ADDR2_SEL <= S_X2_ADDR2_R3;


		end if; -- if(cur_inst ) 

	----------------------
	----------------------
	-- 2. COMPLEX_INST
	----------------------
	----------------------
	else 
        case cur_state_c is
		------------------
		-- SWP state
		------------------
        when S_SWP2 =>

			-- SWP2:(Store)
			-- Address Base			
           	-- ID_ROP1 <= OP_EXEC; ID_R1_SEL <= S_R1_REG; ID_RA1 <= cur_inst(19 downto 16);
			-- To avoid previous SWP1(load)(in X1) stall
			-- But X2 value must be forwarding! How???
           	ID_ROP1 <= OP_EXEC; ID_R1_SEL <= S_R1_REG; ID_RA1 <= cur_inst(19 downto 16); 
           	ID_ROP4 <= OP_EXEC; ID_R4_SEL <= S_R4_REG; ID_RA4 <= cur_inst(3 downto 0); 

			-- Address Offset
			X1_ADDR_SEL <= S_X1_ADDR1_R1;

			-- B(22) Byte
			if( cur_inst(22) = '1') then -- Byte
           		X1_DMIU_EN <= '1'; X1_DMIU_OP <= OP_DMOU_UBYTE;
           		X2_DMEM_EN <= '1'; X2_DMEM_OP <= "001"; -- Store Byte
			else -- Byte
           		X1_DMIU_EN <= '1'; X1_DMIU_OP <= OP_DMOU_WORD;
           		X2_DMEM_EN <= '1'; X2_DMEM_OP <= "101"; -- Store Word
			end if;

			-- Write backup data to wr2 which was stored prevous step(load)
    		X2_WR2_SEL 	<= S_X2_WR2_BACKUP;
           	WB_WOP2(1 downto 0)	<= OP_X2_EXEC; WB_WA2 <= cur_inst(15 downto 12);

			next_state <= SIMPLE_INST;
			next_state_c <= S_IDLE;

		------------------
		-- MRS state
		------------------
        when S_MRS2 =>
			-- MRS: NOP->NOP(*S_MRS2)->MRS(S_MRS3)
				next_inst 		<= cur_inst; -- Inst_code stall
				next_state 		<= COMPLEX_INST;
				next_state_c 	<= S_MRS3;

        when S_MRS3 =>
			-- MRS: NOP->NOP(S_MRS2)->MRS(*S_MRS3)
			-- R(22)
			if(cur_inst(22)='0') then
           		ID_R1_SEL <= S_R1_CPSR;
			else
				ID_SPSR_RA<= spsr_addr;
           		ID_R1_SEL <= S_R1_SPSR;
			end if;
			-- shifter operand = 0
	 		X1_ALU_EN 	<= '1'; X1_ALU_OP <= OP_ADD;
	 		X1_SHIFT_EN <= '1'; X1_SHIFT_OP <= (others=>'0');
           	ID_R2_SEL <= S_R2_IMMED; ID_R2_IMMED <= (others=>'0');
           	ID_R3_SEL <= S_R3_IMMED; ID_R3_IMMED <= (others=>'0');

    		X1_WR_SEL 		<= S_X1_WR_ALU;
    		X2_WR1_SEL 		<= S_X2_WR1_WR;

           	WB_WOP1	<= OP_WOP_WRITE or OP_WOP_RESULT_X1;
			WB_WA1 <= cur_inst(15 downto 12);

			next_state 		<= SIMPLE_INST;
			next_state_c 	<= S_IDLE;

		------------------
		-- MSR state
		------------------
        when S_MSR2 =>
			-- MSR: MSR->NOP(*S_MSR2)->NOP(S_MSR3)
				next_inst 		<= cur_inst; -- Inst_code stall
				next_state 		<= COMPLEX_INST;
				next_state_c 	<= S_MSR3;

        when S_MSR3 =>
			-- MSR: MSR->NOP(S_MSR2)->NOP(*S_MSR3)
				next_state 		<= SIMPLE_INST;
				next_state_c 	<= S_IDLE;

		---------------------------------
		---------------------------------
		-- LDM, STM Stage2: Data access
		---------------------------------
		---------------------------------
        when S_LDM_STM2 =>
			-- Default Signal
			next_state 		<= COMPLEX_INST;
			next_state_c 	<= S_LDM_STM2;

			-- Running
			-- Access Register
			if(cur_register(0)='1') then 	-- Access R0
				access_register <= "0000";
				next_register <= cur_register(15 downto 1)  & '0';
			elsif(cur_register(1)='1') then -- Access R1
				access_register <= "0001";
				next_register <= cur_register(15 downto 2)  & "00";
			elsif(cur_register(2)='1') then -- Access R2
				access_register <= "0010";
				next_register <= cur_register(15 downto 3)  & "000";
			elsif(cur_register(3)='1') then -- Access R3
				access_register <= "0011";
				next_register <= cur_register(15 downto 4)  & "0000";
			elsif(cur_register(4)='1') then -- Access R4
				access_register <= "0100";
				next_register <= cur_register(15 downto 5)  & "00000";
			elsif(cur_register(5)='1') then -- Access R5
				access_register <= "0101";
				next_register <= cur_register(15 downto 6)  & "000000";
			elsif(cur_register(6)='1') then -- Access R6
				access_register <= "0110";
				next_register <= cur_register(15 downto 7)  & "0000000";
			elsif(cur_register(7)='1') then -- Access R7
				access_register <= "0111";
				next_register <= cur_register(15 downto 8)  & "00000000";
			elsif(cur_register(8)='1') then -- Access R8
				access_register <= "1000";
				next_register <= cur_register(15 downto 9)  & "000000000";
			elsif(cur_register(9)='1') then -- Access R9
				access_register <= "1001";
				next_register <= cur_register(15 downto 10) & "0000000000";
			elsif(cur_register(10)='1') then -- Access R10
				access_register <= "1010";
				next_register <= cur_register(15 downto 11) & "00000000000";
			elsif(cur_register(11)='1') then -- Access R11
				access_register <= "1011";
				next_register <= cur_register(15 downto 12) & "000000000000";
			elsif(cur_register(12)='1') then -- Access R12
				access_register <= "1100";
				next_register <= cur_register(15 downto 13) & "0000000000000";
			elsif(cur_register(13)='1') then -- Access R13
				access_register <= "1101";
				next_register <= cur_register(15 downto 14) & "00000000000000";
			elsif(cur_register(14)='1') then -- Access R14
				access_register <= "1110";
				next_register <= cur_register(15) & "000000000000000";
			elsif(cur_register(15)='1') then -- Access R15
				access_register <= "1111";
				next_register <= (others=>'0');
			end if;


			-- Offset & operation select
           	ID_R2_SEL <= S_R2_IMMED; 
	 		X1_SHIFT_EN <= '1'; X1_SHIFT_OP <= "0000"; -- Logical Shift Left
           	ID_R3_SEL <= S_R3_IMMED; ID_R3_IMMED <= C_ZERO24 & "00000010"; -- << 2
			-- cur_access_count=real_access_count+1 
			-- Start
			-- OPT_TIME_030903
--			if(cur_access_count=(unsigned(cur_register_list_sum)-'1')) then 
			if(cur_ldm_stm_first='1') then
				next_ldm_stm_first <='0';
				-- DEBUG_030826: base update, temporary base address is R0 ***
				-- Base Addr: Can be forwarded to next access
           		ID_ROP1 <= OP_EXEC; ID_R1_SEL <= S_R1_REG; ID_RA1 <= cur_inst(19 downto 16); 

				-- Start offset and ALU operation
                case cur_inst(24 downto 23) is
                when "01" => -- IA: Rn+0
					ID_R2_IMMED <= (others=>'0'); 			-- 
 					X1_ALU_EN 	<= '1'; X1_ALU_OP <= "0100"; -- ADD
                when "11" => -- IB: Rn+1*4
					ID_R2_IMMED <= C_ZERO24 & "00000001"; 	-- +1
 					X1_ALU_EN 	<= '1'; X1_ALU_OP <= "0100"; -- ADD
                when "00" => -- DA: Rn-(n-1)*4
					ID_R2_IMMED <= C_ZERO24 & "000" & cur_access_count(4 downto 0);
 					X1_ALU_EN 	<= '1'; X1_ALU_OP <= "0010"; -- SUB
                when "10" => -- DB: Rn-n*4
					ID_R2_IMMED <= C_ZERO24 & "000" & cur_register_list_sum;
 					X1_ALU_EN 	<= '1'; X1_ALU_OP <= "0010"; -- SUB
                when others => null;
				end case;
			else 	-- Normal Case: Rn += 4
				-- DEBUG_030826: base update, temporary base address is R0 ***
				-- Base Addr: Can be forwarded to next access
    			ID_RREG1_CONV_MODE <= MODE_NOP; -- Base Register read
           		ID_ROP1 <= OP_EXEC; ID_R1_SEL <= S_R1_REG; ID_RA1 <= cur_inst(19 downto 16); 

 				X1_ALU_EN 	<= '1'; X1_ALU_OP <= "0100"; 	-- ADD
				ID_R2_IMMED <= C_ZERO24 & "00000001"; 		-- +4
			end if;

			-- Access Address Select from ALU result
			X1_ADDR_SEL <= S_X1_ADDR1_ALU;
				
			-- Target Register
			-- L(20) 
			if(cur_inst(20)='0') then -- Store
           		ID_ROP4 <= OP_EXEC; ID_R4_SEL <= S_R4_REG; ID_RA4 <= access_register; -- Read PC
    			X1_DMIU_EN 	<= '1'; X1_DMIU_OP 	<= OP_DMIU_WORD;
        		X2_DMEM_EN 	<= '1'; X2_DMEM_OP <= "101"; -- Store Word
			else -- Load
        		X2_DMEM_EN 	<= '1'; X2_DMEM_OP <= "100"; -- Load Word
           		X2_DMOU_EN 	<= '1'; X2_DMOU_OP <= OP_DMOU_WORD_M;
    			X2_WR1_SEL 	<= S_X2_WR1_DMEM;

				if(access_register = "1111") then -- Load R15(PC)
					X2_BRANCH2 <= '1'; X2_ADDR2_SEL <= S_X2_ADDR2_DMEM;
				else
           			WB_WOP1	<= OP_WOP_RESULT_X2 or OP_WOP_WRITE; WB_WA1 <= access_register;
				end if;
			end if;


			-- Base Register Rn Forwarding
			-- In last step, Rn in X1 must not be forwarded
			-- In WB stage, WOP2(0)='0' if PWRITE='1' therefore WB forwarding to X1 is impossible!
			if(cur_access_count = "00000" ) then 
           		WB_WOP2	<= (others=>'0');
			else

				-- BACK_UP rn:  rn ldm rn,{rn,ra,rb} or ldm rn,{ra,rn,rb}
				-- Pend rn load util last stage
				-- DEBUG_030715
				-- DEBUG_030825: only ldm
				if(access_register = cur_inst(19 downto 16) and cur_access_count /= "00000" and cur_inst(20)='1' )then -- WR Backup Path
--				if(access_register = cur_inst(19 downto 16) and cur_access_count /= "00000" )then -- WR Backup Path
--					WB_WOP2 <= OP_WOP_BACKUP_WR1;
           			WB_WOP1	<= (others=>'0');
					-- DEBUG_030721
					-- DEBUG_030826: base update, temporary base address is R0 ***
--           			WB_WOP2	<= OP_WOP_NO_STALL or OP_WOP_BACKUP_WR1 or OP_WOP_PWRITE or OP_WOP_RESULT_X1; WB_WA2 <= cur_inst(19 downto 16); -- Rn
    				ID_WREG2_CONV_MODE <= MODE_NOP; -- Base Register read
	           		WB_WOP2	<= OP_WOP_NO_STALL or OP_WOP_BACKUP_WR1 or OP_WOP_PWRITE or OP_WOP_RESULT_X1; WB_WA2 <= cur_inst(19 downto 16); -- Rn
					next_backup_rn <= '1';
					-- In final stage, backup value is store to rn
				else
					-- DEBUG_030826: base update, temporary base address is R0 ***
--           		WB_WOP2	<= OP_WOP_PWRITE or OP_WOP_RESULT_X1; WB_WA2 <= cur_inst(19 downto 16); -- Rn
    				ID_WREG2_CONV_MODE <= MODE_NOP; -- Base Register read
		           	WB_WOP2	<= OP_WOP_PWRITE or OP_WOP_RESULT_X1; WB_WA2 <= cur_inst(19 downto 16); -- Rn
				end if;
			end if;

			-- The S(22) bit: Access user mode register!
			if(cur_inst(22)='1') then
				-- L(20): Load
				if(cur_inst(20)='0') then -- ALL STMs
    				ID_RREG3_CONV_MODE <= MODE_USER; -- Store register passes RR3 path
				elsif(cur_inst(22)='1' and cur_inst(21)='0' and cur_inst(15)='0') then -- LDM(2)
					ID_WREG1_CONV_MODE <= MODE_USER; -- load register passes WR1 path
				end if;
			end if;


			-- Update access count
			next_access_count <= unsigned(cur_access_count) - '1';

			-- Finalize: Last Stage
			if(cur_access_count = "00000" ) then
				-- W(21) : base write back
				if(cur_inst(21)='1') then 
					-- Last and LDM final Rn must be updated by memory value
					-- L(20): Load
					if(cur_inst(20) = '1' and access_register=cur_inst(19 downto 16) ) then -- Only LDM Rn,{Rn}
           				WB_WOP2(1 downto 0)	<= (others=>'0');
					else
           				WB_WOP2	<= OP_WOP_RESULT_X2 or OP_WOP_WRITE; WB_WA2 <= cur_inst(19 downto 16);
    					X2_WR2_SEL 	<= S_X2_WR2_BACKUP; -- From Saved Value
					end if;
				end if;

				-- L(20),S(22),R15(15) bit: Copy SPSR to CPSR
				if(cur_inst(20)='1' and cur_inst(22)='1' and cur_inst(15)='1' ) then -- LDM(3) a
    				X2_WCPSR_SEL <= S_X2_WCPSR_SPSR; WB_CPSR_WOP <= "1111"; 
				end if;

				-- Restore rn from backuped value
				if(cur_backup_rn='1') then
           			WB_WOP2	<= OP_WOP_RESULT_X2 or OP_WOP_WRITE; WB_WA2 <= cur_inst(19 downto 16);
    				X2_WR2_SEL 	<= S_X2_WR2_BACKUP; -- From Saved Value
				end if;
				next_state <= SIMPLE_INST;
				next_state_c <= S_IDLE;
			else
				next_inst <= cur_inst; -- Inst_code stall
			end if;
        when others =>
            next_inst <= INST_CODE;
            next_state <= cur_state;
            next_state_c <= cur_state_c;
            next_iabort <= IABORT;
            next_access_count <= cur_access_count;
            next_register <= cur_register;
            access_register <= "0000";
            next_backup_rn <= cur_backup_rn;
            next_ldm_stm_first <= cur_ldm_stm_first;
        end case;
		-- Complex Inst
	end if;

	-- IF Stall???
	if(next_state = COMPLEX_INST ) then
   		ID_MULTI_CYCLE <= '1'; -- Stall IF
	end if;

	end process;
end BEHAVIORAL;

configuration CFG_INST_CTRL of INST_CTRL is
   for BEHAVIORAL

   end for;

end CFG_INST_CTRL;
