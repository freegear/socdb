-- VHDL Model Created from SGE Schematic toyarm.sch -- Sep 15 12:00:30 2003

library IEEE;
   use IEEE.std_logic_1164.all;
   use IEEE.std_logic_misc.all;
   use IEEE.std_logic_arith.all;

entity TOYARM is
      Port (  BIGEND : In    std_logic;
                 CLK : In    std_logic;
              DABORT : In    std_logic;
                DDIN : In    std_logic_vector (31 downto 0);
              DNWAIT : In    std_logic;
              HIVECS : In    std_logic;
              IABORT : In    std_logic;
                  ID : In    std_logic_vector (31 downto 0);
              INWAIT : In    std_logic;
                NFIQ : In    std_logic;
                NIRQ : In    std_logic;
              NRESET : In    std_logic;
                  DA : Out   std_logic_vector (31 downto 0);
               DDOUT : Out   std_logic_vector (31 downto 0);
                DMAS : Out   std_logic_vector (1 downto 0);
               DMORE : Out   std_logic;
              DNMREQ : Out   std_logic;
                DNRW : Out   std_logic;
                DSEQ : Out   std_logic;
                  IA : Out   std_logic_vector (31 downto 0);
              INMREQ : Out   std_logic;
                ISEQ : Out   std_logic );
end TOYARM;

architecture SCHEMATIC of TOYARM is

   signal  IF_PC_8 : std_logic_vector(31 downto 0);
   signal    ID_R4 : std_logic_vector(31 downto 0);
   signal    ID_R3 : std_logic_vector(31 downto 0);
   signal    ID_R2 : std_logic_vector(31 downto 0);
   signal  IF_PC_4 : std_logic_vector(31 downto 0);
   signal    ID_R1 : std_logic_vector(31 downto 0);
   signal    IF_PC : std_logic_vector(31 downto 0);
   signal   ID_RA1 : std_logic_vector(4 downto 0);
   signal   ID_RA2 : std_logic_vector(4 downto 0);
   signal   ID_RA3 : std_logic_vector(4 downto 0);
   signal   ID_RA4 : std_logic_vector(4 downto 0);
   signal    X1_R1 : std_logic_vector(31 downto 0);
   signal    X1_R4 : std_logic_vector(31 downto 0);
   signal    X1_R2 : std_logic_vector(31 downto 0);
   signal X1_SHIFTER_OPERAND : std_logic_vector(31 downto 0);
   signal X1_ALU_OP : std_logic_vector(3 downto 0);
   signal X1_CPSR_F : std_logic_vector(3 downto 0);
   signal X1_ALU_OUT : std_logic_vector(31 downto 0);
   signal X2_MUL_RD_LO : std_logic_vector(31 downto 0);
   signal X2_MUL_RD_HI : std_logic_vector(31 downto 0);
   signal X1_ALU_CPSR_F : std_logic_vector(3 downto 0);
   signal X2_COND_F : std_logic_vector(3 downto 0);
   signal ID_COND_F : std_logic_vector(3 downto 0);
   signal X2_WR2_F : std_logic_vector(31 downto 0);
   signal X2_WR1_F : std_logic_vector(31 downto 0);
   signal  X1_WR_F : std_logic_vector(31 downto 0);
   signal   X2_WR2 : std_logic_vector(31 downto 0);
   signal  ID_R4_F : std_logic_vector(31 downto 0);
   signal   X2_WR1 : std_logic_vector(31 downto 0);
   signal  ID_R3_F : std_logic_vector(31 downto 0);
   signal    X1_WR : std_logic_vector(31 downto 0);
   signal  ID_R2_F : std_logic_vector(31 downto 0);
   signal  ID_R1_F : std_logic_vector(31 downto 0);
   signal  X1_COND : std_logic_vector(3 downto 0);
   signal  X2_COND : std_logic_vector(3 downto 0);
   signal   X1_WA1 : std_logic_vector(4 downto 0);
   signal   X1_WA2 : std_logic_vector(4 downto 0);
   signal X1_INST_COND : std_logic_vector(3 downto 0);
   signal X1_COND_WOP : std_logic_vector(1 downto 0);
   signal X2_COND_WOP : std_logic_vector(1 downto 0);
   signal   ID_WA2 : std_logic_vector(4 downto 0);
   signal   ID_WA1 : std_logic_vector(4 downto 0);
   signal  ID_CPSR : std_logic_vector(31 downto 0);
   signal  ID_SPSR : std_logic_vector(31 downto 0);
   signal   WB_WA2 : std_logic_vector(4 downto 0);
   signal   WB_WA1 : std_logic_vector(4 downto 0);
   signal X2_WR1_SEL : std_logic_vector(1 downto 0);
   signal X2_DMEM_OP : std_logic_vector(2 downto 0);
   signal   X2_WA1 : std_logic_vector(4 downto 0);
   signal   X2_WA2 : std_logic_vector(4 downto 0);
   signal  WB_CPSR : std_logic_vector(31 downto 0);
   signal  WB_SPSR : std_logic_vector(31 downto 0);
   signal X1_FORWARD_R1_SEL : std_logic_vector(1 downto 0);
   signal X1_FORWARD_R2_SEL : std_logic_vector(1 downto 0);
   signal X1_FORWARD_R3_SEL : std_logic_vector(1 downto 0);
   signal X1_FORWARD_R4_SEL : std_logic_vector(1 downto 0);
   signal X1_FORWARD_COND_SEL : std_logic_vector(1 downto 0);
   signal X2_ADDR2 : std_logic_vector(31 downto 0);
   signal X1_ADDR1_0 : std_logic_vector(31 downto 0);
   signal WB_CPSR_WOP : std_logic_vector(3 downto 0);
   signal WB_SPSR_WA : std_logic_vector(2 downto 0);
   signal X1_WR_SEL : std_logic_vector(1 downto 0);
   signal WB_COND_WOP : std_logic_vector(1 downto 0);
   signal ID_COND_WOP_F : std_logic_vector(1 downto 0);
   signal ID_COND_WOP : std_logic_vector(1 downto 0);
   signal X1_SPSR_WA : std_logic_vector(2 downto 0);
   signal ID_SPSR_WA : std_logic_vector(2 downto 0);
   signal X1_CPSR_WOP : std_logic_vector(3 downto 0);
   signal ID_CPSR_WOP_F : std_logic_vector(3 downto 0);
   signal ID_CPSR_WOP : std_logic_vector(3 downto 0);
   signal X1_WR1_SEL : std_logic_vector(1 downto 0);
   signal ID_WR1_SEL : std_logic_vector(1 downto 0);
   signal ID_DMEM_OP : std_logic_vector(2 downto 0);
   signal ID_WR_SEL : std_logic_vector(1 downto 0);
   signal ID_MUL_OP : std_logic_vector(2 downto 0);
   signal ID_ALU_OP : std_logic_vector(3 downto 0);
   signal ID_INST_COND : std_logic_vector(3 downto 0);
   signal  X1_CPSR : std_logic_vector(31 downto 0);
   signal X1_MUL_OP : std_logic_vector(2 downto 0);
   signal  X1_SPSR : std_logic_vector(31 downto 0);
   signal ID_SPSR_WOP : std_logic_vector(3 downto 0);
   signal ID_SPSR_WOP_F : std_logic_vector(3 downto 0);
   signal X1_SPSR_WOP : std_logic_vector(3 downto 0);
   signal WB_SPSR_WOP : std_logic_vector(3 downto 0);
   signal ID_SPSR_RA : std_logic_vector(2 downto 0);
   signal X1_CPSR_0 : std_logic_vector(31 downto 0);
   signal  X2_SPSR : std_logic_vector(31 downto 0);
   signal  X2_CPSR : std_logic_vector(31 downto 0);
   signal X2_CPSR_1 : std_logic_vector(31 downto 0);
   signal X2_WCPSR_SEL : std_logic_vector(1 downto 0);
   signal ID_WCPSR_SEL_F : std_logic_vector(1 downto 0);
   signal    X2_R1 : std_logic_vector(31 downto 0);
   signal ID_WCPSR_SEL : std_logic_vector(1 downto 0);
   signal ID_WA1_0 : std_logic_vector(3 downto 0);
   signal ID_R4_IMMED : std_logic_vector(31 downto 0);
   signal  ID_R4_0 : std_logic_vector(31 downto 0);
   signal ID_R4_SEL : std_logic_vector(1 downto 0);
   signal   WB_WR2 : std_logic_vector(31 downto 0);
   signal ID_R3_IMMED : std_logic_vector(31 downto 0);
   signal   WB_WR1 : std_logic_vector(31 downto 0);
   signal  ID_R3_0 : std_logic_vector(31 downto 0);
   signal ID_RA4_0 : std_logic_vector(3 downto 0);
   signal  ID_R2_0 : std_logic_vector(31 downto 0);
   signal  ID_R1_0 : std_logic_vector(31 downto 0);
   signal ID_R2_IMMED : std_logic_vector(31 downto 0);
   signal ID_RA3_0 : std_logic_vector(3 downto 0);
   signal ID_RA2_0 : std_logic_vector(3 downto 0);
   signal ID_R1_IMMED : std_logic_vector(31 downto 0);
   signal ID_RA1_0 : std_logic_vector(3 downto 0);
   signal ID_R1_SEL : std_logic_vector(1 downto 0);
   signal ID_WA2_0 : std_logic_vector(3 downto 0);
   signal X2_CPSR_WOP : std_logic_vector(3 downto 0);
   signal X2_SPSR_WOP : std_logic_vector(3 downto 0);
   signal X2_SPSR_WA : std_logic_vector(2 downto 0);
   signal    X2_R3 : std_logic_vector(31 downto 0);
   signal X2_DMEM_OUT : std_logic_vector(31 downto 0);
   signal X1_ADDR1_F : std_logic_vector(31 downto 0);
   signal X1_COND_F : std_logic_vector(3 downto 0);
   signal X2_MUL_CPSR_NZ : std_logic_vector(1 downto 0);
   signal    X1_R3 : std_logic_vector(31 downto 0);
   signal X1_SHIFT_OP : std_logic_vector(3 downto 0);
   signal ID_SHIFT_OP : std_logic_vector(3 downto 0);
   signal ID_DMOU_OP : std_logic_vector(2 downto 0);
   signal X2_DMOU_OP : std_logic_vector(2 downto 0);
   signal X1_DMOU_OP : std_logic_vector(2 downto 0);
   signal ID_DMIU_OP : std_logic_vector(2 downto 0);
   signal X1_DMIU_OP : std_logic_vector(2 downto 0);
   signal X1_DMEM_IN : std_logic_vector(31 downto 0);
   signal X1_ADDR1 : std_logic_vector(31 downto 0);
   signal ID_WR2_SEL : std_logic_vector(1 downto 0);
   signal  X1_WOP1 : std_logic_vector(5 downto 0);
   signal  X1_WOP2 : std_logic_vector(5 downto 0);
   signal  X2_WOP1 : std_logic_vector(5 downto 0);
   signal X1_WR2_SEL : std_logic_vector(1 downto 0);
   signal X2_WR2_SEL : std_logic_vector(1 downto 0);
   signal  ID_WOP1 : std_logic_vector(5 downto 0);
   signal  ID_WOP2 : std_logic_vector(5 downto 0);
   signal ID_WOP1_F : std_logic_vector(5 downto 0);
   signal ID_WOP2_F : std_logic_vector(5 downto 0);
   signal X2_BACKUP : std_logic_vector(31 downto 0);
   signal  X2_WOP2 : std_logic_vector(5 downto 0);
   signal  WB_WOP1 : std_logic_vector(5 downto 0);
   signal  WB_WOP2 : std_logic_vector(5 downto 0);
   signal ID_WSPSR_SEL : std_logic_vector(1 downto 0);
   signal X2_WSPSR_SEL : std_logic_vector(1 downto 0);
   signal ID_WSPSR_SEL_F : std_logic_vector(1 downto 0);
   signal DDIN_FILTERED : std_logic_vector(31 downto 0);
   signal ID_FILTERED : std_logic_vector(31 downto 0);
   signal  X1_PC_8 : std_logic_vector(31 downto 0);
   signal ABORT_PC_8 : std_logic_vector(31 downto 0);
   signal  X2_PC_8 : std_logic_vector(31 downto 0);
   signal X1_CLZ_OUT : std_logic_vector(31 downto 0);
   signal DMOU_X2_ADDR : std_logic_vector(31 downto 0);
   signal ID_WREG2_CONV_MODE : std_logic_vector(4 downto 0);
   signal ID_WREG1_CONV_MODE : std_logic_vector(4 downto 0);
   signal ID_RREG1_CONV_MODE : std_logic_vector(4 downto 0);
   signal ID_RREG2_CONV_MODE : std_logic_vector(4 downto 0);
   signal ID_RREG3_CONV_MODE : std_logic_vector(4 downto 0);
   signal ID_RREG4_CONV_MODE : std_logic_vector(4 downto 0);
   signal IF_FLUSH : std_logic;
   signal ID_CLZ_EN_F : std_logic;
   signal ID_CLZ_EN : std_logic;
   signal X1_CLZ_EN : std_logic;
   signal DABORT_FILTERED : std_logic;
   signal IABORT_FILTERED : std_logic;
   signal    RESET : std_logic;
   signal ID_DMIU_EN_F : std_logic;
   signal X1_DMIU_EN : std_logic;
   signal ID_DMIU_EN : std_logic;
   signal X1_ADDR2_SEL : std_logic;
   signal ID_ADDR2_SEL : std_logic;
   signal ID_R2_SEL : std_logic;
   signal ID_R3_SEL : std_logic;
   signal X1_WCOND1_SEL : std_logic;
   signal X1_ADDR1_SEL : std_logic;
   signal ID_BRANCH1_F : std_logic;
   signal ID_SHIFT_EN_F : std_logic;
   signal ID_BRANCH1 : std_logic;
   signal ID_SHIFT_EN : std_logic;
   signal ID_ALU_EN_F : std_logic;
   signal ID_ALU_EN : std_logic;
   signal ID_MUL_EN_F : std_logic;
   signal ID_MUL_EN : std_logic;
   signal ID_WCOND1_SEL : std_logic;
   signal ID_ADDR1_SEL : std_logic;
   signal ID_DMEM_EN_F : std_logic;
   signal ID_DMEM_EN : std_logic;
   signal ID_DMOU_EN_F : std_logic;
   signal ID_DMOU_EN : std_logic;
   signal X1_DMOU_EN : std_logic;
   signal X2_DMOU_EN : std_logic;
   signal ID_BRANCH2_F : std_logic;
   signal ID_BRANCH2 : std_logic;
   signal X1_BRANCH2 : std_logic;
   signal ID_WCOND2_SEL : std_logic;
   signal X2_WCOND2_SEL : std_logic;
   signal X1_WCOND2_SEL : std_logic;
   signal X2_ADDR2_SEL : std_logic;
   signal X2_BRANCH2 : std_logic;
   signal X1_BRANCH1 : std_logic;
   signal ID_FLUSH : std_logic;
   signal ID_STALL : std_logic;
   signal IF_STALL : std_logic;
   signal X2_DMEM_EN : std_logic;
   signal WB_STALL : std_logic;
   signal WB_FLUSH : std_logic;
   signal X2_STALL : std_logic;
   signal X2_FLUSH : std_logic;
   signal X1_COND_PASS : std_logic;
   signal X1_MUL_EN : std_logic;
   signal X1_ALU_EN : std_logic;
   signal X1_SHIFTER_CARRY_OUT : std_logic;
   signal X1_SHIFT_EN : std_logic;
   signal X1_FLUSH : std_logic;
   signal X1_STALL : std_logic;
   signal ID_MULTI_CYCLE : std_logic;
   signal  ID_ROP1 : std_logic;
   signal  ID_ROP2 : std_logic;
   signal  ID_ROP3 : std_logic;
   signal  ID_ROP4 : std_logic;
   signal ID_COND_ROP : std_logic;
   signal     DNRW_DUMMY : std_logic;
   signal   DNMREQ_DUMMY : std_logic;
   signal   INMREQ_DUMMY : std_logic;

   component CLZ_UNIT
      Port ( EXEC_EN : In    std_logic;
                  RM : In    std_logic_vector (31 downto 0);
                  RD : Out   std_logic_vector (31 downto 0) );
   end component;

   component DATA_FILTER
      Port ( ABORT_IN : In    std_logic;
                 CLK : In    std_logic;
             DATA_IN : In    std_logic_vector (31 downto 0);
               FLUSH : In    std_logic;
                NREQ : In    std_logic;
                 NRW : In    std_logic;
               NWAIT : In    std_logic;
               STALL : In    std_logic;
             ABORT_OUT : Out   std_logic;
             DATA_OUT : Out   std_logic_vector (31 downto 0) );
   end component;

   component WR_BACKUP
      Port ( BACKUP_OP : In    std_logic_vector (1 downto 0);
                 CLK : In    std_logic;
               FLUSH : In    std_logic;
                 IN1 : In    std_logic_vector (31 downto 0);
                 IN2 : In    std_logic_vector (31 downto 0);
               STALL : In    std_logic;
                OUT1 : Out   std_logic_vector (31 downto 0) );
   end component;

   component INV1
      Port (     IN1 : In    std_logic;
                OUT1 : Out   std_logic );
   end component;

   component DMIU
      Port (    ADDR : In    std_logic_vector (1 downto 0);
              BIGEND : In    std_logic;
             DATA_IN : In    std_logic_vector (31 downto 0);
                  OP : In    std_logic_vector (2 downto 0);
             DATA_OUT : Out   std_logic_vector (31 downto 0) );
   end component;

   component PASS_WB_DATA
      Port (  X2_WR1 : In    std_logic_vector (31 downto 0);
              X2_WR2 : In    std_logic_vector (31 downto 0);
              WB_WR1 : Out   std_logic_vector (31 downto 0);
              WB_WR2 : Out   std_logic_vector (31 downto 0) );
   end component;

   component PASS_WB_CTRL
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
   end component;

   component INST_CTRL
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
   end component;

   component CPSR_UPDATE
      Port ( CPSR210 : In    std_logic_vector (27 downto 0);
              CPSR_F : In    std_logic_vector (3 downto 0);
                CPSR : Out   std_logic_vector (31 downto 0) );
   end component;

   component FF_X2B_CTRL
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
   end component;

   component FF_WB_CTRL
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
   end component;

   component FF_X2_CTRL
      Port ( ADDR2_SEL : In    std_logic;
             BRANCH2 : In    std_logic;
                 CLK : In    std_logic;
             DMEM_EN : In    std_logic;
             DMEM_OP : In    std_logic_vector (2 downto 0);
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
             DMEM_EN_F : Out   std_logic;
             DMEM_OP_F : Out   std_logic_vector (2 downto 0);
             DMOU_EN_F : Out   std_logic;
             DMOU_OP_F : Out   std_logic_vector (2 downto 0);
             WCOND_SEL_F : Out   std_logic;
             WCPSR_SEL_F : Out   std_logic_vector (1 downto 0);
             WR1_SEL_F : Out   std_logic_vector (1 downto 0);
             WR2_SEL_F : Out   std_logic_vector (1 downto 0);
             WSPSR_SEL_F : Out   std_logic_vector (1 downto 0) );
   end component;

   component FF_X1_CTRL
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
   end component;

   component OP_FILTER
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
   end component;

   component DMOU
      Port (    ADDR : In    std_logic_vector (1 downto 0);
              BIGEND : In    std_logic;
             DATA_IN : In    std_logic_vector (31 downto 0);
                  OP : In    std_logic_vector (2 downto 0);
             DATA_OUT : Out   std_logic_vector (31 downto 0);
             X2_ADDR : Out   std_logic_vector (31 downto 0) );
   end component;

   component MUX2_4
      Port (     IN1 : In    std_logic_vector (3 downto 0);
                 IN2 : In    std_logic_vector (3 downto 0);
                 SEL : In    std_logic;
                OUT1 : Out   std_logic_vector (3 downto 0) );
   end component;

   component MUX3_4
      Port (     IN1 : In    std_logic_vector (3 downto 0);
                 IN2 : In    std_logic_vector (3 downto 0);
                 IN3 : In    std_logic_vector (3 downto 0);
                 SEL : In    std_logic_vector (1 downto 0);
                OUT1 : Out   std_logic_vector (3 downto 0) );
   end component;

   component DMEM_CTRL
      Port (    ADDR : In    std_logic_vector (31 downto 0);
                 CLK : In    std_logic;
             DATA_IN : In    std_logic_vector (31 downto 0);
                  EN : In    std_logic;
               FLUSH : In    std_logic;
                  OP : In    std_logic_vector (2 downto 0);
               STALL : In    std_logic;
                  DA : Out   std_logic_vector (31 downto 0);
               DDOUT : Out   std_logic_vector (31 downto 0);
                DMAS : Out   std_logic_vector (1 downto 0);
               DMORE : Out   std_logic;
              DNMREQ : Out   std_logic;
                DNRW : Out   std_logic;
                DSEQ : Out   std_logic );
   end component;

   component MUX3_32
      Port (     IN1 : In    std_logic_vector (31 downto 0);
                 IN2 : In    std_logic_vector (31 downto 0);
                 IN3 : In    std_logic_vector (31 downto 0);
                 SEL : In    std_logic_vector (1 downto 0);
                OUT1 : Out   std_logic_vector (31 downto 0) );
   end component;

   component FF1_4
      Port (     CLK : In    std_logic;
               FLUSH : In    std_logic;
                 IN1 : In    std_logic_vector (3 downto 0);
               STALL : In    std_logic;
                OUT1 : Out   std_logic_vector (3 downto 0) );
   end component;

   component COND_CHECK
      Port ( CPSR_COND : In    std_logic_vector (3 downto 0);
             INST_COND : In    std_logic_vector (3 downto 0);
             COND_PASS : Out   std_logic );
   end component;

   component FF1_32
      Port (     CLK : In    std_logic;
               FLUSH : In    std_logic;
                 IN1 : In    std_logic_vector (31 downto 0);
               STALL : In    std_logic;
                OUT1 : Out   std_logic_vector (31 downto 0) );
   end component;

   component MUX2_32
      Port (     IN1 : In    std_logic_vector (31 downto 0);
                 IN2 : In    std_logic_vector (31 downto 0);
                 SEL : In    std_logic;
                OUT1 : Out   std_logic_vector (31 downto 0) );
   end component;

   component MUL
      Port (     CLK : In    std_logic;
             EXEC_EN : In    std_logic;
             FLUSH_X2 : In    std_logic;
                  OP : In    std_logic_vector (2 downto 0);
                  RM : In    std_logic_vector (31 downto 0);
               RN_HI : In    std_logic_vector (31 downto 0);
               RN_LO : In    std_logic_vector (31 downto 0);
                  RS : In    std_logic_vector (31 downto 0);
             STALL_X2 : In    std_logic;
             FLAG_NZ : Out   std_logic_vector (1 downto 0);
               RD_HI : Out   std_logic_vector (31 downto 0);
               RD_LO : Out   std_logic_vector (31 downto 0) );
   end component;

   component ALU
      Port ( EXEC_EN : In    std_logic;
             FLAG_IN : In    std_logic_vector (3 downto 0);
                  OP : In    std_logic_vector (3 downto 0);
                  RN : In    std_logic_vector (31 downto 0);
                  RS : In    std_logic_vector (31 downto 0);
                SCIN : In    std_logic;
                ADDR : Out   std_logic_vector (31 downto 0);
             FLAG_OUT : Out   std_logic_vector (3 downto 0);
                  RD : Out   std_logic_vector (31 downto 0) );
   end component;

   component SHIFT
      Port ( C_FLAG_IN : In    std_logic;
             EXEC_EN : In    std_logic;
                  OP : In    std_logic_vector (3 downto 0);
                SRC1 : In    std_logic_vector (31 downto 0);
                SRC2 : In    std_logic_vector (8 downto 0);
                 SCO : Out   std_logic;
                   Z : Out   std_logic_vector (31 downto 0) );
   end component;

   component FORWARD_CTRL
      Port (     CLK : In    std_logic;
               FLUSH : In    std_logic;
             ID_COND_ROP : In    std_logic;
              ID_RA1 : In    std_logic_vector (4 downto 0);
              ID_RA2 : In    std_logic_vector (4 downto 0);
              ID_RA3 : In    std_logic_vector (4 downto 0);
              ID_RA4 : In    std_logic_vector (4 downto 0);
             ID_ROP1 : In    std_logic;
             ID_ROP2 : In    std_logic;
             ID_ROP3 : In    std_logic;
             ID_ROP4 : In    std_logic;
               STALL : In    std_logic;
             X1_COND_WOP : In    std_logic_vector (1 downto 0);
              X1_WA1 : In    std_logic_vector (4 downto 0);
              X1_WA2 : In    std_logic_vector (4 downto 0);
             X1_WOP1 : In    std_logic_vector (1 downto 0);
             X1_WOP2 : In    std_logic_vector (1 downto 0);
             X2_COND_WOP : In    std_logic_vector (1 downto 0);
              X2_WA1 : In    std_logic_vector (4 downto 0);
              X2_WA2 : In    std_logic_vector (4 downto 0);
             X2_WOP1 : In    std_logic_vector (1 downto 0);
             X2_WOP2 : In    std_logic_vector (1 downto 0);
             COND_SEL : Out   std_logic_vector (1 downto 0);
              R1_SEL : Out   std_logic_vector (1 downto 0);
              R2_SEL : Out   std_logic_vector (1 downto 0);
              R3_SEL : Out   std_logic_vector (1 downto 0);
              R4_SEL : Out   std_logic_vector (1 downto 0) );
   end component;

   component FF4_32
      Port (     CLK : In    std_logic;
               FLUSH : In    std_logic;
                 IN1 : In    std_logic_vector (31 downto 0);
                 IN2 : In    std_logic_vector (31 downto 0);
                 IN3 : In    std_logic_vector (31 downto 0);
                 IN4 : In    std_logic_vector (31 downto 0);
               STALL : In    std_logic;
                OUT1 : Out   std_logic_vector (31 downto 0);
                OUT2 : Out   std_logic_vector (31 downto 0);
                OUT3 : Out   std_logic_vector (31 downto 0);
                OUT4 : Out   std_logic_vector (31 downto 0) );
   end component;

   component STALL_FLUSH_CTRL
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
   end component;

   component MUX4_32
      Port (     IN1 : In    std_logic_vector (31 downto 0);
                 IN2 : In    std_logic_vector (31 downto 0);
                 IN3 : In    std_logic_vector (31 downto 0);
                 IN4 : In    std_logic_vector (31 downto 0);
                 SEL : In    std_logic_vector (1 downto 0);
                OUT1 : Out   std_logic_vector (31 downto 0) );
   end component;

   component GREG
      Port (     CLK : In    std_logic;
                  D1 : In    std_logic_vector (31 downto 0);
                  D2 : In    std_logic_vector (31 downto 0);
               FLUSH : In    std_logic;
                PC_8 : In    std_logic_vector (31 downto 0);
             PC_8_STALL : In    std_logic;
              RADDR1 : In    std_logic_vector (4 downto 0);
              RADDR2 : In    std_logic_vector (4 downto 0);
              RADDR3 : In    std_logic_vector (4 downto 0);
              RADDR4 : In    std_logic_vector (4 downto 0);
               STALL : In    std_logic;
              WADDR1 : In    std_logic_vector (4 downto 0);
              WADDR2 : In    std_logic_vector (4 downto 0);
                WEN1 : In    std_logic;
                WEN2 : In    std_logic;
                  Q1 : Out   std_logic_vector (31 downto 0);
                  Q2 : Out   std_logic_vector (31 downto 0);
                  Q3 : Out   std_logic_vector (31 downto 0);
                  Q4 : Out   std_logic_vector (31 downto 0) );
   end component;

   component PSR
      Port (     CLK : In    std_logic;
             CPSR_IN : In    std_logic_vector (31 downto 0);
             CPSR_WEN : In    std_logic_vector (3 downto 0);
               FLUSH : In    std_logic;
             SPSR_IN : In    std_logic_vector (31 downto 0);
             SPSR_RADDR : In    std_logic_vector (2 downto 0);
             SPSR_WADDR : In    std_logic_vector (2 downto 0);
             SPSR_WEN : In    std_logic_vector (3 downto 0);
               STALL : In    std_logic;
             CPSR_OUT : Out   std_logic_vector (31 downto 0);
             SPSR_OUT : Out   std_logic_vector (31 downto 0) );
   end component;

   component REG_CONV
      Port ( ADDR_IN : In    std_logic_vector (3 downto 0);
                MODE : In    std_logic_vector (4 downto 0);
             ADDR_OUT : Out   std_logic_vector (4 downto 0) );
   end component;

   component IF_CTRL
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
   end component;

begin

   DNRW <= DNRW_DUMMY;
   DNMREQ <= DNMREQ_DUMMY;
   INMREQ <= INMREQ_DUMMY;

   I_79 : CLZ_UNIT
      Port Map ( EXEC_EN=>X1_CLZ_EN, RM(31 downto 0)=>X1_R1(31 downto 0),
                 RD(31 downto 0)=>X1_CLZ_OUT(31 downto 0) );
   I_75 : DATA_FILTER
      Port Map ( ABORT_IN=>IABORT, CLK=>CLK,
                 DATA_IN(31 downto 0)=>ID(31 downto 0), FLUSH=>IF_FLUSH,
                 NREQ=>INMREQ_DUMMY, NRW=>INMREQ_DUMMY, NWAIT=>INWAIT,
                 STALL=>IF_STALL, ABORT_OUT=>IABORT_FILTERED,
                 DATA_OUT(31 downto 0)=>ID_FILTERED(31 downto 0) );
   I_74 : DATA_FILTER
      Port Map ( ABORT_IN=>DABORT, CLK=>CLK,
                 DATA_IN(31 downto 0)=>DDIN(31 downto 0),
                 FLUSH=>X2_FLUSH, NREQ=>DNMREQ_DUMMY, NRW=>DNRW_DUMMY,
                 NWAIT=>DNWAIT, STALL=>X2_STALL,
                 ABORT_OUT=>DABORT_FILTERED,
                 DATA_OUT(31 downto 0)=>DDIN_FILTERED(31 downto 0) );
   I_69 : WR_BACKUP
      Port Map ( BACKUP_OP(1 downto 0)=>X2_WOP2(4 downto 3), CLK=>CLK,
                 FLUSH=>X2_FLUSH, IN1(31 downto 0)=>X2_WR1(31 downto 0),
                 IN2(31 downto 0)=>X2_WR2(31 downto 0), STALL=>X2_STALL,
                 OUT1(31 downto 0)=>X2_BACKUP(31 downto 0) );
   I_70 : INV1
      Port Map ( IN1=>NRESET, OUT1=>RESET );
   I_68 : DMIU
      Port Map ( ADDR(1 downto 0)=>X1_ADDR1(1 downto 0), BIGEND=>BIGEND,
                 DATA_IN(31 downto 0)=>X1_R4(31 downto 0),
                 OP(2 downto 0)=>X1_DMIU_OP(2 downto 0),
                 DATA_OUT(31 downto 0)=>X1_DMEM_IN(31 downto 0) );
   I_67 : PASS_WB_DATA
      Port Map ( X2_WR1(31 downto 0)=>X2_WR1(31 downto 0),
                 X2_WR2(31 downto 0)=>X2_WR2(31 downto 0),
                 WB_WR1(31 downto 0)=>WB_WR1(31 downto 0),
                 WB_WR2(31 downto 0)=>WB_WR2(31 downto 0) );
   I_66 : PASS_WB_CTRL
      Port Map ( COND_WOP(1 downto 0)=>X2_COND_WOP(1 downto 0),
                 CPSR_WOP(3 downto 0)=>X2_CPSR_WOP(3 downto 0),
                 FLUSH=>WB_FLUSH,
                 SPSR_WA(2 downto 0)=>X2_SPSR_WA(2 downto 0),
                 SPSR_WOP(3 downto 0)=>X2_SPSR_WOP(3 downto 0),
                 WA1(4 downto 0)=>X2_WA1(4 downto 0),
                 WA2(4 downto 0)=>X2_WA2(4 downto 0),
                 WOP1(5 downto 0)=>X2_WOP1(5 downto 0),
                 WOP2(5 downto 0)=>X2_WOP2(5 downto 0),
                 COND_WOP_F(1 downto 0)=>WB_COND_WOP(1 downto 0),
                 CPSR_WOP_F(3 downto 0)=>WB_CPSR_WOP(3 downto 0),
                 SPSR_WA_F(2 downto 0)=>WB_SPSR_WA(2 downto 0),
                 SPSR_WOP_F(3 downto 0)=>WB_SPSR_WOP(3 downto 0),
                 WA1_F(4 downto 0)=>WB_WA1(4 downto 0),
                 WA2_F(4 downto 0)=>WB_WA2(4 downto 0),
                 WOP1_F(5 downto 0)=>WB_WOP1(5 downto 0),
                 WOP2_F(5 downto 0)=>WB_WOP2(5 downto 0) );
   I_65 : INST_CTRL
      Port Map ( CLK=>CLK, CPSR(31 downto 0)=>ID_CPSR(31 downto 0),
                 DABORT=>DABORT_FILTERED, FLUSH=>ID_FLUSH,
                 HIVECS=>HIVECS, IABORT=>IABORT_FILTERED,
                 INST_CODE(31 downto 0)=>ID_FILTERED(31 downto 0),
                 NFIQ=>NFIQ, NIRQ=>NIRQ, STALL=>ID_STALL,
                 X1_BRANCH1_IN=>X1_BRANCH1, X1_BRANCH2_IN=>X1_BRANCH2,
                 X2_BRANCH2_IN=>X2_BRANCH2, ID_COND_ROP=>ID_COND_ROP,
                 ID_MULTI_CYCLE=>ID_MULTI_CYCLE,
                 ID_R1_IMMED(31 downto 0)=>ID_R1_IMMED(31 downto 0),
                 ID_R1_SEL(1 downto 0)=>ID_R1_SEL(1 downto 0),
                 ID_R2_IMMED(31 downto 0)=>ID_R2_IMMED(31 downto 0),
                 ID_R2_SEL=>ID_R2_SEL,
                 ID_R3_IMMED(31 downto 0)=>ID_R3_IMMED(31 downto 0),
                 ID_R3_SEL=>ID_R3_SEL,
                 ID_R4_IMMED(31 downto 0)=>ID_R4_IMMED(31 downto 0),
                 ID_R4_SEL(1 downto 0)=>ID_R4_SEL(1 downto 0),
                 ID_RA1(3 downto 0)=>ID_RA1_0(3 downto 0),
                 ID_RA2(3 downto 0)=>ID_RA2_0(3 downto 0),
                 ID_RA3(3 downto 0)=>ID_RA3_0(3 downto 0),
                 ID_RA4(3 downto 0)=>ID_RA4_0(3 downto 0),
                 ID_ROP1=>ID_ROP1, ID_ROP2=>ID_ROP2, ID_ROP3=>ID_ROP3,
                 ID_ROP4=>ID_ROP4,
                 ID_RREG1_CONV_MODE(4 downto 0)=>ID_RREG1_CONV_MODE(4 downto 0),
                 ID_RREG2_CONV_MODE(4 downto 0)=>ID_RREG2_CONV_MODE(4 downto 0),
                 ID_RREG3_CONV_MODE(4 downto 0)=>ID_RREG3_CONV_MODE(4 downto 0),
                 ID_RREG4_CONV_MODE(4 downto 0)=>ID_RREG4_CONV_MODE(4 downto 0),
                 ID_SPSR_RA(2 downto 0)=>ID_SPSR_RA(2 downto 0),
                 ID_WREG1_CONV_MODE(4 downto 0)=>ID_WREG1_CONV_MODE(4 downto 0),
                 ID_WREG2_CONV_MODE(4 downto 0)=>ID_WREG2_CONV_MODE(4 downto 0),
                 WB_COND_WOP(1 downto 0)=>ID_COND_WOP(1 downto 0),
                 WB_CPSR_WOP(3 downto 0)=>ID_CPSR_WOP(3 downto 0),
                 WB_SPSR_WA(2 downto 0)=>ID_SPSR_WA(2 downto 0),
                 WB_SPSR_WOP(3 downto 0)=>ID_SPSR_WOP(3 downto 0),
                 WB_WA1(3 downto 0)=>ID_WA1_0(3 downto 0),
                 WB_WA2(3 downto 0)=>ID_WA2_0(3 downto 0),
                 WB_WOP1(5 downto 0)=>ID_WOP1(5 downto 0),
                 WB_WOP2(5 downto 0)=>ID_WOP2(5 downto 0),
                 X1_ADDR_SEL=>ID_ADDR1_SEL, X1_ALU_EN=>ID_ALU_EN,
                 X1_ALU_OP(3 downto 0)=>ID_ALU_OP(3 downto 0),
                 X1_BRANCH1=>ID_BRANCH1, X1_CLZ_EN=>ID_CLZ_EN,
                 X1_DMIU_EN=>ID_DMIU_EN,
                 X1_DMIU_OP(2 downto 0)=>ID_DMIU_OP(2 downto 0),
                 X1_INST_COND(3 downto 0)=>ID_INST_COND(3 downto 0),
                 X1_MUL_EN=>ID_MUL_EN,
                 X1_MUL_OP(2 downto 0)=>ID_MUL_OP(2 downto 0),
                 X1_SHIFT_EN=>ID_SHIFT_EN,
                 X1_SHIFT_OP(3 downto 0)=>ID_SHIFT_OP(3 downto 0),
                 X1_WCOND1_SEL=>ID_WCOND1_SEL,
                 X1_WR_SEL(1 downto 0)=>ID_WR_SEL(1 downto 0),
                 X2_ADDR2_SEL=>ID_ADDR2_SEL, X2_BRANCH2=>ID_BRANCH2,
                 X2_DMEM_EN=>ID_DMEM_EN,
                 X2_DMEM_OP(2 downto 0)=>ID_DMEM_OP(2 downto 0),
                 X2_DMOU_EN=>ID_DMOU_EN,
                 X2_DMOU_OP(2 downto 0)=>ID_DMOU_OP(2 downto 0),
                 X2_WCOND2_SEL=>ID_WCOND2_SEL,
                 X2_WCPSR_SEL(1 downto 0)=>ID_WCPSR_SEL(1 downto 0),
                 X2_WR1_SEL(1 downto 0)=>ID_WR1_SEL(1 downto 0),
                 X2_WR2_SEL(1 downto 0)=>ID_WR2_SEL(1 downto 0),
                 X2_WSPSR_SEL(1 downto 0)=>ID_WSPSR_SEL(1 downto 0) );
   I_58 : CPSR_UPDATE
      Port Map ( CPSR210(27 downto 0)=>X2_CPSR(27 downto 0),
                 CPSR_F(3 downto 0)=>X2_COND(3 downto 0),
                 CPSR(31 downto 0)=>X2_CPSR_1(31 downto 0) );
   I_55 : CPSR_UPDATE
      Port Map ( CPSR210(27 downto 0)=>X1_CPSR_0(27 downto 0),
                 CPSR_F(3 downto 0)=>X1_CPSR_F(3 downto 0),
                 CPSR(31 downto 0)=>X1_CPSR(31 downto 0) );
   I_51 : FF_X2B_CTRL
      Port Map ( ADDR2_SEL=>X1_ADDR2_SEL, BRANCH2=>X1_BRANCH2, CLK=>CLK,
                 DMOU_EN=>X1_DMOU_EN,
                 DMOU_OP(2 downto 0)=>X1_DMOU_OP(2 downto 0),
                 FLUSH=>X2_FLUSH, STALL=>X2_STALL,
                 WCOND_SEL=>X1_WCOND2_SEL,
                 WCPSR_SEL(1 downto 0)=>ID_WCPSR_SEL_F(1 downto 0),
                 WR1_SEL(1 downto 0)=>X1_WR1_SEL(1 downto 0),
                 WR2_SEL(1 downto 0)=>X1_WR2_SEL(1 downto 0),
                 WSPSR_SEL(1 downto 0)=>ID_WSPSR_SEL_F(1 downto 0),
                 ADDR2_SEL_F=>X2_ADDR2_SEL, BRANCH2_F=>X2_BRANCH2,
                 DMOU_EN_F=>X2_DMOU_EN,
                 DMOU_OP_F(2 downto 0)=>X2_DMOU_OP(2 downto 0),
                 WCOND_SEL_F=>X2_WCOND2_SEL,
                 WCPSR_SEL_F(1 downto 0)=>X2_WCPSR_SEL(1 downto 0),
                 WR1_SEL_F(1 downto 0)=>X2_WR1_SEL(1 downto 0),
                 WR2_SEL_F(1 downto 0)=>X2_WR2_SEL(1 downto 0),
                 WSPSR_SEL_F(1 downto 0)=>X2_WSPSR_SEL(1 downto 0) );
   I_50 : FF_WB_CTRL
      Port Map ( CLK=>CLK, COND_WOP(1 downto 0)=>X1_COND_WOP(1 downto 0),
                 CPSR_WOP(3 downto 0)=>X1_CPSR_WOP(3 downto 0),
                 FLUSH=>X2_FLUSH,
                 SPSR_WA(2 downto 0)=>X1_SPSR_WA(2 downto 0),
                 SPSR_WOP(3 downto 0)=>X1_SPSR_WOP(3 downto 0),
                 STALL=>X2_STALL, WA1(4 downto 0)=>X1_WA1(4 downto 0),
                 WA2(4 downto 0)=>X1_WA2(4 downto 0),
                 WOP1(5 downto 0)=>X1_WOP1(5 downto 0),
                 WOP2(5 downto 0)=>X1_WOP2(5 downto 0),
                 COND_WOP_F(1 downto 0)=>X2_COND_WOP(1 downto 0),
                 CPSR_WOP_F(3 downto 0)=>X2_CPSR_WOP(3 downto 0),
                 SPSR_WA_F(2 downto 0)=>X2_SPSR_WA(2 downto 0),
                 SPSR_WOP_F(3 downto 0)=>X2_SPSR_WOP(3 downto 0),
                 WA1_F(4 downto 0)=>X2_WA1(4 downto 0),
                 WA2_F(4 downto 0)=>X2_WA2(4 downto 0),
                 WOP1_F(5 downto 0)=>X2_WOP1(5 downto 0),
                 WOP2_F(5 downto 0)=>X2_WOP2(5 downto 0) );
   I_49 : FF_WB_CTRL
      Port Map ( CLK=>CLK, COND_WOP(1 downto 0)=>ID_COND_WOP(1 downto 0),
                 CPSR_WOP(3 downto 0)=>ID_CPSR_WOP(3 downto 0),
                 FLUSH=>X1_FLUSH,
                 SPSR_WA(2 downto 0)=>ID_SPSR_WA(2 downto 0),
                 SPSR_WOP(3 downto 0)=>ID_SPSR_WOP(3 downto 0),
                 STALL=>X1_STALL, WA1(4 downto 0)=>ID_WA1(4 downto 0),
                 WA2(4 downto 0)=>ID_WA2(4 downto 0),
                 WOP1(5 downto 0)=>ID_WOP1(5 downto 0),
                 WOP2(5 downto 0)=>ID_WOP2(5 downto 0),
                 COND_WOP_F(1 downto 0)=>ID_COND_WOP_F(1 downto 0),
                 CPSR_WOP_F(3 downto 0)=>ID_CPSR_WOP_F(3 downto 0),
                 SPSR_WA_F(2 downto 0)=>X1_SPSR_WA(2 downto 0),
                 SPSR_WOP_F(3 downto 0)=>ID_SPSR_WOP_F(3 downto 0),
                 WA1_F(4 downto 0)=>X1_WA1(4 downto 0),
                 WA2_F(4 downto 0)=>X1_WA2(4 downto 0),
                 WOP1_F(5 downto 0)=>ID_WOP1_F(5 downto 0),
                 WOP2_F(5 downto 0)=>ID_WOP2_F(5 downto 0) );
   I_47 : FF_X2_CTRL
      Port Map ( ADDR2_SEL=>ID_ADDR2_SEL, BRANCH2=>ID_BRANCH2, CLK=>CLK,
                 DMEM_EN=>ID_DMEM_EN,
                 DMEM_OP(2 downto 0)=>ID_DMEM_OP(2 downto 0),
                 DMOU_EN=>ID_DMOU_EN,
                 DMOU_OP(2 downto 0)=>ID_DMOU_OP(2 downto 0),
                 FLUSH=>X1_FLUSH, STALL=>X1_STALL,
                 WCOND_SEL=>ID_WCOND2_SEL,
                 WCPSR_SEL(1 downto 0)=>ID_WCPSR_SEL(1 downto 0),
                 WR1_SEL(1 downto 0)=>ID_WR1_SEL(1 downto 0),
                 WR2_SEL(1 downto 0)=>ID_WR2_SEL(1 downto 0),
                 WSPSR_SEL(1 downto 0)=>ID_WSPSR_SEL(1 downto 0),
                 ADDR2_SEL_F=>X1_ADDR2_SEL, BRANCH2_F=>ID_BRANCH2_F,
                 DMEM_EN_F=>ID_DMEM_EN_F,
                 DMEM_OP_F(2 downto 0)=>X2_DMEM_OP(2 downto 0),
                 DMOU_EN_F=>ID_DMOU_EN_F,
                 DMOU_OP_F(2 downto 0)=>X1_DMOU_OP(2 downto 0),
                 WCOND_SEL_F=>X1_WCOND2_SEL,
                 WCPSR_SEL_F(1 downto 0)=>ID_WCPSR_SEL_F(1 downto 0),
                 WR1_SEL_F(1 downto 0)=>X1_WR1_SEL(1 downto 0),
                 WR2_SEL_F(1 downto 0)=>X1_WR2_SEL(1 downto 0),
                 WSPSR_SEL_F(1 downto 0)=>ID_WSPSR_SEL_F(1 downto 0) );
   I_48 : FF_X1_CTRL
      Port Map ( ADDR1_SEL=>ID_ADDR1_SEL, ALU_EN=>ID_ALU_EN,
                 ALU_OP(3 downto 0)=>ID_ALU_OP(3 downto 0),
                 BRANCH1=>ID_BRANCH1, CLK=>CLK, CLZ_EN=>ID_CLZ_EN,
                 DMIU_EN=>ID_DMIU_EN,
                 DMIU_OP(2 downto 0)=>ID_DMIU_OP(2 downto 0),
                 FLUSH=>X1_FLUSH,
                 INST_COND(3 downto 0)=>ID_INST_COND(3 downto 0),
                 MUL_EN=>ID_MUL_EN,
                 MUL_OP(2 downto 0)=>ID_MUL_OP(2 downto 0),
                 SHIFT_EN=>ID_SHIFT_EN,
                 SHIFT_OP(3 downto 0)=>ID_SHIFT_OP(3 downto 0),
                 STALL=>X1_STALL, WCOND_SEL=>ID_WCOND1_SEL,
                 WR_SEL(1 downto 0)=>ID_WR_SEL(1 downto 0),
                 ADDR1_SEL_F=>X1_ADDR1_SEL, ALU_EN_F=>ID_ALU_EN_F,
                 ALU_OP_F(3 downto 0)=>X1_ALU_OP(3 downto 0),
                 BRANCH1_F=>ID_BRANCH1_F, CLZ_EN_F=>ID_CLZ_EN_F,
                 DMIU_EN_F=>ID_DMIU_EN_F,
                 DMIU_OP_F(2 downto 0)=>X1_DMIU_OP(2 downto 0),
                 INST_COND_F(3 downto 0)=>X1_INST_COND(3 downto 0),
                 MUL_EN_F=>ID_MUL_EN_F,
                 MUL_OP_F(2 downto 0)=>X1_MUL_OP(2 downto 0),
                 SHIFT_EN_F=>ID_SHIFT_EN_F,
                 SHIFT_OP_F(3 downto 0)=>X1_SHIFT_OP(3 downto 0),
                 WCOND_SEL_F=>X1_WCOND1_SEL,
                 WR_SEL_F(1 downto 0)=>X1_WR_SEL(1 downto 0) );
   I_43 : OP_FILTER
      Port Map ( COND_PASS=>X1_COND_PASS,
                 WB_COND_WOP_IN(1 downto 0)=>ID_COND_WOP_F(1 downto 0),
                 WB_CPSR_WOP_IN(3 downto 0)=>ID_CPSR_WOP_F(3 downto 0),
                 WB_SPSR_WOP_IN(3 downto 0)=>ID_SPSR_WOP_F(3 downto 0),
                 WB_WOP1_IN(5 downto 0)=>ID_WOP1_F(5 downto 0),
                 WB_WOP2_IN(5 downto 0)=>ID_WOP2_F(5 downto 0),
                 X1_ALU_EN_IN=>ID_ALU_EN_F, X1_BRANCH1_IN=>ID_BRANCH1_F,
                 X1_CLZ_EN_IN=>ID_CLZ_EN_F, X1_DMIU_EN_IN=>ID_DMIU_EN_F,
                 X1_MUL_EN_IN=>ID_MUL_EN_F,
                 X1_SHIFT_EN_IN=>ID_SHIFT_EN_F,
                 X2_BRANCH2_IN=>ID_BRANCH2_F,
                 X2_DMEM_EN_IN=>ID_DMEM_EN_F,
                 X2_DMOU_EN_IN=>ID_DMOU_EN_F,
                 WB_COND_WOP_OUT(1 downto 0)=>X1_COND_WOP(1 downto 0),
                 WB_CPSR_WOP_OUT(3 downto 0)=>X1_CPSR_WOP(3 downto 0),
                 WB_SPSR_WOP_OUT(3 downto 0)=>X1_SPSR_WOP(3 downto 0),
                 WB_WOP1_OUT(5 downto 0)=>X1_WOP1(5 downto 0),
                 WB_WOP2_OUT(5 downto 0)=>X1_WOP2(5 downto 0),
                 X1_ALU_EN_OUT=>X1_ALU_EN, X1_BRANCH1_OUT=>X1_BRANCH1,
                 X1_CLZ_EN_OUT=>X1_CLZ_EN, X1_DMIU_EN_OUT=>X1_DMIU_EN,
                 X1_MUL_EN_OUT=>X1_MUL_EN, X1_SHIFT_EN_OUT=>X1_SHIFT_EN,
                 X2_BRANCH2_OUT=>X1_BRANCH2, X2_DMEM_EN_OUT=>X2_DMEM_EN,
                 X2_DMOU_EN_OUT=>X1_DMOU_EN );
   I_39 : DMOU
      Port Map ( ADDR(1 downto 0)=>X1_ADDR1_F(1 downto 0),
                 BIGEND=>BIGEND,
                 DATA_IN(31 downto 0)=>DDIN_FILTERED(31 downto 0),
                 OP(2 downto 0)=>X2_DMOU_OP(2 downto 0),
                 DATA_OUT(31 downto 0)=>X2_DMEM_OUT(31 downto 0),
                 X2_ADDR(31 downto 0)=>DMOU_X2_ADDR(31 downto 0) );
   I_38 : MUX2_4
      Port Map ( IN1(3 downto 0)=>X1_COND_F(3 downto 0),
                 IN2(3 downto 2)=>X2_MUL_CPSR_NZ(1 downto 0),
                 IN2(1 downto 0)=>X1_COND_F(1 downto 0),
                 SEL=>X2_WCOND2_SEL,
                 OUT1(3 downto 0)=>X2_COND(3 downto 0) );
   I_37 : MUX2_4
      Port Map ( IN1(3 downto 0)=>X1_CPSR_F(3 downto 0),
                 IN2(3 downto 0)=>X1_ALU_CPSR_F(3 downto 0),
                 SEL=>X1_WCOND1_SEL,
                 OUT1(3 downto 0)=>X1_COND(3 downto 0) );
   I_34 : MUX3_4
      Port Map ( IN1(3 downto 0)=>ID_COND_F(3 downto 0),
                 IN2(3 downto 0)=>X1_COND_F(3 downto 0),
                 IN3(3 downto 0)=>X2_COND_F(3 downto 0),
                 SEL(1 downto 0)=>X1_FORWARD_COND_SEL(1 downto 0),
                 OUT1(3 downto 0)=>X1_CPSR_F(3 downto 0) );
   I_31 : DMEM_CTRL
      Port Map ( ADDR(31 downto 0)=>X1_ADDR1(31 downto 0), CLK=>CLK,
                 DATA_IN(31 downto 0)=>X1_DMEM_IN(31 downto 0),
                 EN=>X2_DMEM_EN, FLUSH=>X2_FLUSH,
                 OP(2 downto 0)=>X2_DMEM_OP(2 downto 0), STALL=>X2_STALL,
                 DA(31 downto 0)=>DA(31 downto 0),
                 DDOUT(31 downto 0)=>DDOUT(31 downto 0),
                 DMAS(1 downto 0)=>DMAS(1 downto 0), DMORE=>DMORE,
                 DNMREQ=>DNMREQ_DUMMY, DNRW=>DNRW_DUMMY, DSEQ=>DSEQ );
   I_72 : MUX3_32
      Port Map ( IN1(31 downto 0)=>X2_CPSR(31 downto 0),
                 IN2(31 downto 0)=>X2_R1(31 downto 0),
                 IN3(31 downto 0)=>X1_WR_F(31 downto 0),
                 SEL(1 downto 0)=>X2_WSPSR_SEL(1 downto 0),
                 OUT1(31 downto 0)=>WB_SPSR(31 downto 0) );
   I_71 : MUX3_32
      Port Map ( IN1(31 downto 0)=>X1_WR_F(31 downto 0),
                 IN2(31 downto 0)=>X2_MUL_RD_HI(31 downto 0),
                 IN3(31 downto 0)=>X2_BACKUP(31 downto 0),
                 SEL(1 downto 0)=>X2_WR2_SEL(1 downto 0),
                 OUT1(31 downto 0)=>X2_WR2(31 downto 0) );
   I_35 : MUX3_32
      Port Map ( IN1(31 downto 0)=>X1_WR_F(31 downto 0),
                 IN2(31 downto 0)=>X2_DMEM_OUT(31 downto 0),
                 IN3(31 downto 0)=>X2_MUL_RD_LO(31 downto 0),
                 SEL(1 downto 0)=>X2_WR1_SEL(1 downto 0),
                 OUT1(31 downto 0)=>X2_WR1(31 downto 0) );
   I_26 : FF1_4
      Port Map ( CLK=>CLK, FLUSH=>WB_FLUSH,
                 IN1(3 downto 0)=>X2_COND(3 downto 0), STALL=>WB_STALL,
                 OUT1(3 downto 0)=>X2_COND_F(3 downto 0) );
   I_27 : FF1_4
      Port Map ( CLK=>CLK, FLUSH=>X2_FLUSH,
                 IN1(3 downto 0)=>X1_COND(3 downto 0), STALL=>X2_STALL,
                 OUT1(3 downto 0)=>X1_COND_F(3 downto 0) );
   I_28 : FF1_4
      Port Map ( CLK=>CLK, FLUSH=>X1_FLUSH,
                 IN1(3 downto 0)=>ID_CPSR(31 downto 28), STALL=>X1_STALL,
                 OUT1(3 downto 0)=>ID_COND_F(3 downto 0) );
   I_29 : COND_CHECK
      Port Map ( CPSR_COND(3 downto 0)=>X1_CPSR_F(3 downto 0),
                 INST_COND(3 downto 0)=>X1_INST_COND(3 downto 0),
                 COND_PASS=>X1_COND_PASS );
   I_76 : FF1_32
      Port Map ( CLK=>CLK, FLUSH=>RESET,
                 IN1(31 downto 0)=>X2_PC_8(31 downto 0), STALL=>WB_STALL,
                 OUT1(31 downto 0)=>ABORT_PC_8(31 downto 0) );
   I_77 : FF1_32
      Port Map ( CLK=>CLK, FLUSH=>RESET,
                 IN1(31 downto 0)=>X1_PC_8(31 downto 0), STALL=>X2_STALL,
                 OUT1(31 downto 0)=>X2_PC_8(31 downto 0) );
   I_78 : FF1_32
      Port Map ( CLK=>CLK, FLUSH=>RESET,
                 IN1(31 downto 0)=>IF_PC_4(31 downto 0), STALL=>X1_STALL,
                 OUT1(31 downto 0)=>X1_PC_8(31 downto 0) );
   I_44 : FF1_32
      Port Map ( CLK=>CLK, FLUSH=>X2_FLUSH,
                 IN1(31 downto 0)=>X1_R3(31 downto 0), STALL=>X2_STALL,
                 OUT1(31 downto 0)=>X2_R3(31 downto 0) );
   I_32 : FF1_32
      Port Map ( CLK=>CLK, FLUSH=>X2_FLUSH,
                 IN1(31 downto 0)=>X1_ADDR1(31 downto 0),
                 STALL=>X2_STALL,
                 OUT1(31 downto 0)=>X1_ADDR1_F(31 downto 0) );
   I_64 : FF1_32
      Port Map ( CLK=>CLK, FLUSH=>X2_FLUSH,
                 IN1(31 downto 0)=>ID_R1_F(31 downto 0), STALL=>X2_STALL,
                 OUT1(31 downto 0)=>X2_R1(31 downto 0) );
   I_61 : FF1_32
      Port Map ( CLK=>CLK, FLUSH=>X2_FLUSH,
                 IN1(31 downto 0)=>X1_SPSR(31 downto 0), STALL=>X2_STALL,
                 OUT1(31 downto 0)=>X2_SPSR(31 downto 0) );
   I_56 : FF1_32
      Port Map ( CLK=>CLK, FLUSH=>X2_FLUSH,
                 IN1(31 downto 0)=>X1_CPSR(31 downto 0), STALL=>X2_STALL,
                 OUT1(31 downto 0)=>X2_CPSR(31 downto 0) );
   I_59 : FF1_32
      Port Map ( CLK=>CLK, FLUSH=>X1_FLUSH,
                 IN1(31 downto 0)=>ID_SPSR(31 downto 0), STALL=>X1_STALL,
                 OUT1(31 downto 0)=>X1_SPSR(31 downto 0) );
   I_57 : FF1_32
      Port Map ( CLK=>CLK, FLUSH=>X1_FLUSH,
                 IN1(31 downto 0)=>ID_CPSR(31 downto 0), STALL=>X1_STALL,
                 OUT1(31 downto 0)=>X1_CPSR_0(31 downto 0) );
   I_20 : FF1_32
      Port Map ( CLK=>CLK, FLUSH=>WB_FLUSH,
                 IN1(31 downto 0)=>X2_WR2(31 downto 0), STALL=>WB_STALL,
                 OUT1(31 downto 0)=>X2_WR2_F(31 downto 0) );
   I_21 : FF1_32
      Port Map ( CLK=>CLK, FLUSH=>WB_FLUSH,
                 IN1(31 downto 0)=>X2_WR1(31 downto 0), STALL=>WB_STALL,
                 OUT1(31 downto 0)=>X2_WR1_F(31 downto 0) );
   I_22 : FF1_32
      Port Map ( CLK=>CLK, FLUSH=>X2_FLUSH,
                 IN1(31 downto 0)=>X1_WR(31 downto 0), STALL=>X2_STALL,
                 OUT1(31 downto 0)=>X1_WR_F(31 downto 0) );
   I_33 : MUX2_32
      Port Map ( IN1(31 downto 0)=>X1_ADDR1_0(31 downto 0),
                 IN2(31 downto 0)=>X1_R1(31 downto 0), SEL=>X1_ADDR1_SEL,
                 OUT1(31 downto 0)=>X1_ADDR1(31 downto 0) );
   I_45 : MUX2_32
      Port Map ( IN1(31 downto 0)=>DMOU_X2_ADDR(31 downto 0),
                 IN2(31 downto 0)=>X2_R3(31 downto 0), SEL=>X2_ADDR2_SEL,
                 OUT1(31 downto 0)=>X2_ADDR2(31 downto 0) );
   I_40 : MUX2_32
      Port Map ( IN1(31 downto 0)=>ID_R3_0(31 downto 0),
                 IN2(31 downto 0)=>ID_R3_IMMED(31 downto 0),
                 SEL=>ID_R3_SEL, OUT1(31 downto 0)=>ID_R3(31 downto 0) );
   I_41 : MUX2_32
      Port Map ( IN1(31 downto 0)=>ID_R2_0(31 downto 0),
                 IN2(31 downto 0)=>ID_R2_IMMED(31 downto 0),
                 SEL=>ID_R2_SEL, OUT1(31 downto 0)=>ID_R2(31 downto 0) );
   I_24 : MUL
      Port Map ( CLK=>CLK, EXEC_EN=>X1_MUL_EN, FLUSH_X2=>X2_FLUSH,
                 OP(2 downto 0)=>X1_MUL_OP(2 downto 0),
                 RM(31 downto 0)=>X1_R1(31 downto 0),
                 RN_HI(31 downto 0)=>X1_R4(31 downto 0),
                 RN_LO(31 downto 0)=>X1_R3(31 downto 0),
                 RS(31 downto 0)=>X1_R2(31 downto 0), STALL_X2=>X2_STALL,
                 FLAG_NZ(1 downto 0)=>X2_MUL_CPSR_NZ(1 downto 0),
                 RD_HI(31 downto 0)=>X2_MUL_RD_HI(31 downto 0),
                 RD_LO(31 downto 0)=>X2_MUL_RD_LO(31 downto 0) );
   I_18 : ALU
      Port Map ( EXEC_EN=>X1_ALU_EN,
                 FLAG_IN(3 downto 0)=>X1_CPSR_F(3 downto 0),
                 OP(3 downto 0)=>X1_ALU_OP(3 downto 0),
                 RN(31 downto 0)=>X1_R1(31 downto 0),
                 RS(31 downto 0)=>X1_SHIFTER_OPERAND(31 downto 0),
                 SCIN=>X1_SHIFTER_CARRY_OUT,
                 ADDR(31 downto 0)=>X1_ADDR1_0(31 downto 0),
                 FLAG_OUT(3 downto 0)=>X1_ALU_CPSR_F(3 downto 0),
                 RD(31 downto 0)=>X1_ALU_OUT(31 downto 0) );
   I_19 : SHIFT
      Port Map ( C_FLAG_IN=>X1_CPSR_F(1), EXEC_EN=>X1_SHIFT_EN,
                 OP(3 downto 0)=>X1_SHIFT_OP(3 downto 0),
                 SRC1(31 downto 0)=>X1_R2(31 downto 0),
                 SRC2(8 downto 0)=>X1_R3(8 downto 0),
                 SCO=>X1_SHIFTER_CARRY_OUT,
                 Z(31 downto 0)=>X1_SHIFTER_OPERAND(31 downto 0) );
   I_12 : FORWARD_CTRL
      Port Map ( CLK=>CLK, FLUSH=>X1_FLUSH, ID_COND_ROP=>ID_COND_ROP,
                 ID_RA1(4 downto 0)=>ID_RA1(4 downto 0),
                 ID_RA2(4 downto 0)=>ID_RA2(4 downto 0),
                 ID_RA3(4 downto 0)=>ID_RA3(4 downto 0),
                 ID_RA4(4 downto 0)=>ID_RA4(4 downto 0),
                 ID_ROP1=>ID_ROP1, ID_ROP2=>ID_ROP2, ID_ROP3=>ID_ROP3,
                 ID_ROP4=>ID_ROP4, STALL=>X1_STALL,
                 X1_COND_WOP(1 downto 0)=>X1_COND_WOP(1 downto 0),
                 X1_WA1(4 downto 0)=>X1_WA1(4 downto 0),
                 X1_WA2(4 downto 0)=>X1_WA2(4 downto 0),
                 X1_WOP1(1 downto 0)=>X1_WOP1(1 downto 0),
                 X1_WOP2(1 downto 0)=>X1_WOP2(1 downto 0),
                 X2_COND_WOP(1 downto 0)=>X2_COND_WOP(1 downto 0),
                 X2_WA1(4 downto 0)=>X2_WA1(4 downto 0),
                 X2_WA2(4 downto 0)=>X2_WA2(4 downto 0),
                 X2_WOP1(1 downto 0)=>WB_WOP1(1 downto 0),
                 X2_WOP2(1 downto 0)=>WB_WOP2(1 downto 0),
                 COND_SEL(1 downto 0)=>X1_FORWARD_COND_SEL(1 downto 0),
                 R1_SEL(1 downto 0)=>X1_FORWARD_R1_SEL(1 downto 0),
                 R2_SEL(1 downto 0)=>X1_FORWARD_R2_SEL(1 downto 0),
                 R3_SEL(1 downto 0)=>X1_FORWARD_R3_SEL(1 downto 0),
                 R4_SEL(1 downto 0)=>X1_FORWARD_R4_SEL(1 downto 0) );
   I_13 : FF4_32
      Port Map ( CLK=>CLK, FLUSH=>X1_FLUSH,
                 IN1(31 downto 0)=>ID_R1(31 downto 0),
                 IN2(31 downto 0)=>ID_R2(31 downto 0),
                 IN3(31 downto 0)=>ID_R3(31 downto 0),
                 IN4(31 downto 0)=>ID_R4(31 downto 0), STALL=>X1_STALL,
                 OUT1(31 downto 0)=>ID_R1_F(31 downto 0),
                 OUT2(31 downto 0)=>ID_R2_F(31 downto 0),
                 OUT3(31 downto 0)=>ID_R3_F(31 downto 0),
                 OUT4(31 downto 0)=>ID_R4_F(31 downto 0) );
   I_11 : STALL_FLUSH_CTRL
      Port Map ( CLK=>CLK, DABORT=>DABORT_FILTERED, DNWAIT=>DNWAIT,
                 ID_COND_ROP=>ID_COND_ROP,
                 ID_MULTI_CYCLE=>ID_MULTI_CYCLE,
                 ID_RA1(4 downto 0)=>ID_RA1(4 downto 0),
                 ID_RA2(4 downto 0)=>ID_RA2(4 downto 0),
                 ID_RA3(4 downto 0)=>ID_RA3(4 downto 0),
                 ID_RA4(4 downto 0)=>ID_RA4(4 downto 0),
                 ID_ROP1=>ID_ROP1, ID_ROP2=>ID_ROP2, ID_ROP3=>ID_ROP3,
                 ID_ROP4=>ID_ROP4, INWAIT=>INWAIT, NRESET=>NRESET,
                 X1_BRANCH=>X1_BRANCH1,
                 X1_COND_WOP(1 downto 0)=>X1_COND_WOP(1 downto 0),
                 X1_WA1(4 downto 0)=>X1_WA1(4 downto 0),
                 X1_WA2(4 downto 0)=>X1_WA2(4 downto 0),
                 X1_WOP1(5 downto 0)=>X1_WOP1(5 downto 0),
                 X1_WOP2(5 downto 0)=>X1_WOP2(5 downto 0),
                 X2_BRANCH=>X2_BRANCH2,
                 X2_COND_WOP(1 downto 0)=>X2_COND_WOP(1 downto 0),
                 X2_WA1(4 downto 0)=>X2_WA1(4 downto 0),
                 X2_WA2(4 downto 0)=>X2_WA2(4 downto 0),
                 X2_WOP1(5 downto 0)=>X2_WOP1(5 downto 0),
                 X2_WOP2(5 downto 0)=>X2_WOP2(5 downto 0),
                 ID_FLUSH=>ID_FLUSH, ID_STALL=>ID_STALL,
                 IF_FLUSH=>IF_FLUSH, IF_STALL=>IF_STALL,
                 WB_FLUSH=>WB_FLUSH, WB_STALL=>WB_STALL,
                 X1_FLUSH=>X1_FLUSH, X1_STALL=>X1_STALL,
                 X2_FLUSH=>X2_FLUSH, X2_STALL=>X2_STALL );
   I_80 : MUX4_32
      Port Map ( IN1(31 downto 0)=>X1_ALU_OUT(31 downto 0),
                 IN2(31 downto 0)=>X1_R1(31 downto 0),
                 IN3(31 downto 0)=>X1_R4(31 downto 0),
                 IN4(31 downto 0)=>X1_CLZ_OUT(31 downto 0),
                 SEL(1 downto 0)=>X1_WR_SEL(1 downto 0),
                 OUT1(31 downto 0)=>X1_WR(31 downto 0) );
   I_73 : MUX4_32
      Port Map ( IN1(31 downto 0)=>X2_CPSR_1(31 downto 0),
                 IN2(31 downto 0)=>X2_SPSR(31 downto 0),
                 IN3(31 downto 0)=>X2_R1(31 downto 0),
                 IN4(31 downto 0)=>X1_WR_F(31 downto 0),
                 SEL(1 downto 0)=>X2_WCPSR_SEL(1 downto 0),
                 OUT1(31 downto 0)=>WB_CPSR(31 downto 0) );
   I_63 : MUX4_32
      Port Map ( IN1(31 downto 0)=>ID_R1_0(31 downto 0),
                 IN2(31 downto 0)=>ID_R1_IMMED(31 downto 0),
                 IN3(31 downto 0)=>ID_CPSR(31 downto 0),
                 IN4(31 downto 0)=>ID_SPSR(31 downto 0),
                 SEL(1 downto 0)=>ID_R1_SEL(1 downto 0),
                 OUT1(31 downto 0)=>ID_R1(31 downto 0) );
   I_54 : MUX4_32
      Port Map ( IN1(31 downto 0)=>ID_R4_0(31 downto 0),
                 IN2(31 downto 0)=>ID_R4_IMMED(31 downto 0),
                 IN3(31 downto 0)=>IF_PC(31 downto 0),
                 IN4(31 downto 0)=>ABORT_PC_8(31 downto 0),
                 SEL(1 downto 0)=>ID_R4_SEL(1 downto 0),
                 OUT1(31 downto 0)=>ID_R4(31 downto 0) );
   I_14 : MUX4_32
      Port Map ( IN1(31 downto 0)=>ID_R4_F(31 downto 0),
                 IN2(31 downto 0)=>X1_WR_F(31 downto 0),
                 IN3(31 downto 0)=>X2_WR1_F(31 downto 0),
                 IN4(31 downto 0)=>X2_WR2_F(31 downto 0),
                 SEL(1 downto 0)=>X1_FORWARD_R4_SEL(1 downto 0),
                 OUT1(31 downto 0)=>X1_R4(31 downto 0) );
   I_15 : MUX4_32
      Port Map ( IN1(31 downto 0)=>ID_R3_F(31 downto 0),
                 IN2(31 downto 0)=>X1_WR_F(31 downto 0),
                 IN3(31 downto 0)=>X2_WR1_F(31 downto 0),
                 IN4(31 downto 0)=>X2_WR2_F(31 downto 0),
                 SEL(1 downto 0)=>X1_FORWARD_R3_SEL(1 downto 0),
                 OUT1(31 downto 0)=>X1_R3(31 downto 0) );
   I_16 : MUX4_32
      Port Map ( IN1(31 downto 0)=>ID_R2_F(31 downto 0),
                 IN2(31 downto 0)=>X1_WR_F(31 downto 0),
                 IN3(31 downto 0)=>X2_WR1_F(31 downto 0),
                 IN4(31 downto 0)=>X2_WR2_F(31 downto 0),
                 SEL(1 downto 0)=>X1_FORWARD_R2_SEL(1 downto 0),
                 OUT1(31 downto 0)=>X1_R2(31 downto 0) );
   I_17 : MUX4_32
      Port Map ( IN1(31 downto 0)=>ID_R1_F(31 downto 0),
                 IN2(31 downto 0)=>X1_WR_F(31 downto 0),
                 IN3(31 downto 0)=>X2_WR1_F(31 downto 0),
                 IN4(31 downto 0)=>X2_WR2_F(31 downto 0),
                 SEL(1 downto 0)=>X1_FORWARD_R1_SEL(1 downto 0),
                 OUT1(31 downto 0)=>X1_R1(31 downto 0) );
   I_9 : GREG
      Port Map ( CLK=>CLK, D1(31 downto 0)=>WB_WR1(31 downto 0),
                 D2(31 downto 0)=>WB_WR2(31 downto 0), FLUSH=>RESET,
                 PC_8(31 downto 0)=>IF_PC_8(31 downto 0),
                 PC_8_STALL=>IF_STALL,
                 RADDR1(4 downto 0)=>ID_RA1(4 downto 0),
                 RADDR2(4 downto 0)=>ID_RA2(4 downto 0),
                 RADDR3(4 downto 0)=>ID_RA3(4 downto 0),
                 RADDR4(4 downto 0)=>ID_RA4(4 downto 0), STALL=>WB_STALL,
                 WADDR1(4 downto 0)=>WB_WA1(4 downto 0),
                 WADDR2(4 downto 0)=>WB_WA2(4 downto 0),
                 WEN1=>WB_WOP1(0), WEN2=>WB_WOP2(0),
                 Q1(31 downto 0)=>ID_R1_0(31 downto 0),
                 Q2(31 downto 0)=>ID_R2_0(31 downto 0),
                 Q3(31 downto 0)=>ID_R3_0(31 downto 0),
                 Q4(31 downto 0)=>ID_R4_0(31 downto 0) );
   I_2 : PSR
      Port Map ( CLK=>CLK, CPSR_IN(31 downto 0)=>WB_CPSR(31 downto 0),
                 CPSR_WEN(3 downto 0)=>WB_CPSR_WOP(3 downto 0),
                 FLUSH=>RESET,
                 SPSR_IN(31 downto 0)=>WB_SPSR(31 downto 0),
                 SPSR_RADDR(2 downto 0)=>ID_SPSR_RA(2 downto 0),
                 SPSR_WADDR(2 downto 0)=>WB_SPSR_WA(2 downto 0),
                 SPSR_WEN(3 downto 0)=>WB_SPSR_WOP(3 downto 0),
                 STALL=>WB_STALL,
                 CPSR_OUT(31 downto 0)=>ID_CPSR(31 downto 0),
                 SPSR_OUT(31 downto 0)=>ID_SPSR(31 downto 0) );
   I_8 : REG_CONV
      Port Map ( ADDR_IN(3 downto 0)=>ID_RA1_0(3 downto 0),
                 MODE(4 downto 0)=>ID_RREG1_CONV_MODE(4 downto 0),
                 ADDR_OUT(4 downto 0)=>ID_RA1(4 downto 0) );
   I_5 : REG_CONV
      Port Map ( ADDR_IN(3 downto 0)=>ID_RA4_0(3 downto 0),
                 MODE(4 downto 0)=>ID_RREG4_CONV_MODE(4 downto 0),
                 ADDR_OUT(4 downto 0)=>ID_RA4(4 downto 0) );
   I_6 : REG_CONV
      Port Map ( ADDR_IN(3 downto 0)=>ID_RA3_0(3 downto 0),
                 MODE(4 downto 0)=>ID_RREG3_CONV_MODE(4 downto 0),
                 ADDR_OUT(4 downto 0)=>ID_RA3(4 downto 0) );
   I_7 : REG_CONV
      Port Map ( ADDR_IN(3 downto 0)=>ID_RA2_0(3 downto 0),
                 MODE(4 downto 0)=>ID_RREG2_CONV_MODE(4 downto 0),
                 ADDR_OUT(4 downto 0)=>ID_RA2(4 downto 0) );
   I_3 : REG_CONV
      Port Map ( ADDR_IN(3 downto 0)=>ID_WA2_0(3 downto 0),
                 MODE(4 downto 0)=>ID_WREG2_CONV_MODE(4 downto 0),
                 ADDR_OUT(4 downto 0)=>ID_WA2(4 downto 0) );
   I_4 : REG_CONV
      Port Map ( ADDR_IN(3 downto 0)=>ID_WA1_0(3 downto 0),
                 MODE(4 downto 0)=>ID_WREG1_CONV_MODE(4 downto 0),
                 ADDR_OUT(4 downto 0)=>ID_WA1(4 downto 0) );
   I_1 : IF_CTRL
      Port Map ( CLK=>CLK, FLUSH=>IF_FLUSH, HIVECS=>HIVECS,
                 STALL=>IF_STALL,
                 X1_ADDR(31 downto 0)=>X1_ADDR1_0(31 downto 0),
                 X1_BRANCH1=>X1_BRANCH1,
                 X2_ADDR(31 downto 0)=>X2_ADDR2(31 downto 0),
                 X2_BRANCH2=>X2_BRANCH2,
                 IA(31 downto 0)=>IA(31 downto 0), INMREQ=>INMREQ_DUMMY,
                 ISEQ=>ISEQ, PC(31 downto 0)=>IF_PC(31 downto 0),
                 PC_4(31 downto 0)=>IF_PC_4(31 downto 0),
                 PC_8(31 downto 0)=>IF_PC_8(31 downto 0) );

end SCHEMATIC;

configuration CFG_TOYARM of TOYARM is

   for SCHEMATIC
      for I_79: CLZ_UNIT
         use configuration WORK.CFG_CLZ_UNIT;
      end for;
      for I_75, I_74: DATA_FILTER
         use configuration WORK.CFG_DATA_FILTER;
      end for;
      for I_69: WR_BACKUP
         use configuration WORK.CFG_WR_BACKUP;
      end for;
      for I_70: INV1
         use configuration WORK.CFG_INV1;
      end for;
      for I_68: DMIU
         use configuration WORK.CFG_DMIU;
      end for;
      for I_67: PASS_WB_DATA
         use configuration WORK.CFG_PASS_WB_DATA;
      end for;
      for I_66: PASS_WB_CTRL
         use configuration WORK.CFG_PASS_WB_CTRL;
      end for;
      for I_65: INST_CTRL
         use configuration WORK.CFG_INST_CTRL;
      end for;
      for I_58, I_55: CPSR_UPDATE
         use configuration WORK.CFG_CPSR_UPDATE;
      end for;
      for I_51: FF_X2B_CTRL
         use configuration WORK.CFG_FF_X2B_CTRL;
      end for;
      for I_50, I_49: FF_WB_CTRL
         use configuration WORK.CFG_FF_WB_CTRL;
      end for;
      for I_47: FF_X2_CTRL
         use configuration WORK.CFG_FF_X2_CTRL;
      end for;
      for I_48: FF_X1_CTRL
         use configuration WORK.CFG_FF_X1_CTRL;
      end for;
      for I_43: OP_FILTER
         use configuration WORK.CFG_OP_FILTER;
      end for;
      for I_39: DMOU
         use configuration WORK.CFG_DMOU;
      end for;
      for I_38, I_37: MUX2_4
         use configuration WORK.CFG_MUX2_4;
      end for;
      for I_34: MUX3_4
         use configuration WORK.CFG_MUX3_4;
      end for;
      for I_31: DMEM_CTRL
         use configuration WORK.CFG_DMEM_CTRL;
      end for;
      for I_72, I_71, I_35: MUX3_32
         use configuration WORK.CFG_MUX3_32;
      end for;
      for I_26, I_27, I_28: FF1_4
         use configuration WORK.CFG_FF1_4;
      end for;
      for I_29: COND_CHECK
         use configuration WORK.CFG_COND_CHECK;
      end for;
      for I_76, I_77, I_78, I_44, I_32, I_64, I_61, I_56, I_59, I_57,
          I_20, I_21, I_22: FF1_32
         use configuration WORK.CFG_FF1_32;
      end for;
      for I_33, I_45, I_40, I_41: MUX2_32
         use configuration WORK.CFG_MUX2_32;
      end for;
      for I_24: MUL
         use configuration WORK.CFG_MUL;
      end for;
      for I_18: ALU
         use configuration WORK.CFG_ALU;
      end for;
      for I_19: SHIFT
         use configuration WORK.CFG_SHIFT;
      end for;
      for I_12: FORWARD_CTRL
         use configuration WORK.CFG_FORWARD_CTRL;
      end for;
      for I_13: FF4_32
         use configuration WORK.CFG_FF4_32;
      end for;
      for I_11: STALL_FLUSH_CTRL
         use configuration WORK.CFG_STALL_FLUSH_CTRL;
      end for;
      for I_80, I_73, I_63, I_54, I_14, I_15, I_16, I_17: MUX4_32
         use configuration WORK.CFG_MUX4_32;
      end for;
      for I_9: GREG
         use configuration WORK.CFG_GREG;
      end for;
      for I_2: PSR
         use configuration WORK.CFG_PSR;
      end for;
      for I_8, I_5, I_6, I_7, I_3, I_4: REG_CONV
         use configuration WORK.CFG_REG_CONV;
      end for;
      for I_1: IF_CTRL
         use configuration WORK.CFG_IF_CTRL;
      end for;
   end for;

end CFG_TOYARM;
