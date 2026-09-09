------------------------------------------------------------------------
-- Copyright 1995 VAutomation Inc. Nashua NH (603) 882-2282 ALL RIGHTS
-- RESERVED. This software is provided under license and contains
-- proprietary and confidential material which is the property of
-- VAutomation Inc.
--
-- File: op_dcd.vhd
-- Revision: $Name: REV9910 $
-- Description:
--      This is the Opcode Decode for the V8 uProcessor
--
-- The opcode is loaded into the INST register from the DATAIN bus
-- when OP_FETCH is active (indicating an opcode fetch). The STATE
-- register is loaded with 00000001 and shifts left each clock until
-- the next opcode is fetched. The shift register acts as a "one-hot"
-- counter indicating the processing step being executed during this
-- clock for the opcode in the INST register. Various control signals
-- are asserted based on a decode of the OPCODE and the STATE. Some
-- control signals are registered before being sent to other blocks
-- for performance reasons.
--
-- When any of the INT lines are active, a INT opcode is forced into
-- the INST register when OP_FETCH is active and interrupt processing
-- begins.
--
-- Most opcodes only decode bits 7:3 of the INST register as bits 2:0
-- are the Rn or REG field of the opcode. Bits 7:3 are aliased to the
-- signal OPCODE for improved readability.
--
-- Crude block diagram:
--
--                   +-------------------+
--                   |STATE              |
--                   |8 bit shift reg    |
--                   |>                  |
--                   +--------v----------+
--     +------+               |                 +-------+
--     |INST  |               |                 |       |
--     |      |     +---------v-----------+     |       |
--     |8 bit |     |Opcode Decode logic. |     |       |
--     |reg   |     |mostly concurrent    >----->       >------->
--     |      >----->signal               |     |>      |
--     |      |     |assignments          |     +-------+
--     |      |     |                     |     Registered control
--     |>     |     |                     |     signals
--     +------+     |                     |
--                  |                     |
--   inputs   >----->                     >--------->Direct control
--                  |                     |          signal outputs
--                  +---------------------+
--
-- Signals ending in _n are active low.

------------------------------------------------------------------------
-- $Log: op_dcd.vhd,v $
-- Revision 1.27  1999/09/13 19:21:50  eric
-- More RMM cleanups - no logic changes.
--
-- Revision 1.26  1999/08/26 15:07:54  scott
-- Fixed minor syntax error
--
-- Revision 1.25  1999/08/25 18:32:40  scott
-- Modified the code to use std_ulogic(_vector) and
-- IEEE numeric_std package and shorten code width
--
-- Revision 1.24  1999/01/26 18:37:01  eric
-- Corrected XSP - ALU_MODE must be forced to add to pass the SP thru.
--
-- Revision 1.23  1999/01/26 13:25:12  eric
-- Changed RSP to XSP.
--
-- Revision 1.22  1998/10/23 01:35:00  eric
-- added WRITE_D.
--
-- Revision 1.21 1998/08/14 19:56:55 eric
-- Defined the JMP group of opcodes to be 5 clocks long except for JMP
-- which is only 3. Without this, the V8 will hang and never fetch
-- another opcode if one of these opcodes is executed.
--
-- Revision 1.20  1998/07/02 19:06:44  eric
-- Improved to meet the latest Synopsys sync reset requirements.
--
-- Revision 1.19  1998/02/18  23:35:34  eric
-- Added the RSP opcode required for the C compiler.
--
-- Revision 1.17  1998/01/15 13:55:51  eric
-- Improved timing on REGB.
--
-- Revision 1.16  1997/12/04 21:03:55  eric
-- Made the INST register sync set to insure we come out of reset in
-- the simulator.
--
-- Revision 1.2  1996/09/05  17:54:48  eric
-- Improved performance by flopping the addr_sel signals.
--
------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all; -- use the IEEE standard 1164 logic types.
use ieee.numeric_std.all;

entity op_dcd is  -------------------ENTITY---------------------
  port(
    clk      : in  std_ulogic; -- everything clocks on rising edge
    rst      : in  std_ulogic; -- synchronous reset active high

    alu2op   : in  std_ulogic_vector(2 downto 0); -- alu flags
    datain   : in  std_ulogic_vector(7 downto 0); -- data bus in
    int      : in  std_ulogic_vector(7 downto 0);
    ready    : in  std_ulogic; -- 0=insert wait states,1=run

    addr_ctl : out std_ulogic_vector(12 downto 0);  -- control
    alu_ctl  : out std_ulogic_vector(13 downto 0); -- ALU control
    data_sel : out std_ulogic_vector(1 downto 0);
    op_ftch  : out std_ulogic; -- indicates an opcode fetch
    read     : out std_ulogic; -- 1=read cycle in progress
    rega     : out std_ulogic_vector(2 downto 0);
    regb     : out std_ulogic_vector(2 downto 0); -- Reg File b addr
    reg_wrt  : out std_ulogic; -- register file write enable
    write    : out std_ulogic; -- 1=write cycle in progress
    -- debugging signals
    write_nxt: out std_ulogic; -- WRITE one cycle early
    opcde    : out std_ulogic_vector(7 downto 0); -- current opcode
    cycle    : out std_ulogic_vector(8 downto 1) -- current state vector
    );
end op_dcd;

architecture rtl of op_dcd is -----------Architecture -----------
  signal alu_set_i , alu_load_psr ,
    alu_load_nz , alu_load_c , alu_carryin ,
    alu_carry_sel , alu_b_zero , alu_b_invert , alu_b_dcd
    : std_ulogic;       -- alu control bits
  signal alu_mode: std_ulogic_vector(2 downto 0); -- alu control bits
  signal alu_a_sel_gjr: std_ulogic_vector(1 downto 0); -- alu control
  signal alu2op0_f: std_ulogic; -- flopped version for speed
  signal inst, inst_nxt : std_ulogic_vector(7 downto 0);
  -- instruction register
  signal int_encoded : std_ulogic_vector(2 downto 0);
  -- encoded interrupt
  signal interrupt: std_ulogic; -- Interrupt is active
  signal op_fetch       : std_ulogic;   -- opcode fetch in progress
  signal opcode : std_ulogic_vector(7 downto 3); -- opcode part of inst
  signal rst_r1  : std_ulogic; -- flopped version
  signal regb_force_zero  : std_ulogic; -- timing improvement flop
  signal state  : std_ulogic_vector(8 downto 1); -- current state reg
  signal state_nxt : std_ulogic_vector(8 downto 1); -- D input to DFF
  signal write_d_lcl    : std_ulogic;   -- D input to write enable DFF
  signal writel : std_ulogic;   -- local copy

  attribute sync_set_reset : string;      -- required for synopsys
  attribute sync_set_reset of rst : signal is "true";
  -- required for synopsys

  signal addr_offset : std_ulogic;

  -- The following line is used when translating to Verilog...
  -- synopsys sync_set_reset "rst"

  -- the following signals are used in the addr_ctl bus
  signal addr_inc_low8,addr_branch,addr_abs : std_ulogic;
  signal addr_indx,addr_dl_ld : std_ulogic;
  signal addr_pc_elr,addr_pc_load : std_ulogic;
  signal addr_pch_ld : std_ulogic;
  signal sp_dec,sp_inc,sp_sel,sp_ld : std_ulogic;

  -- The following define the constants for each opcode
  constant INC_OP  : std_ulogic_vector(7 downto 3) := "00000";
  constant ADC_OP  : std_ulogic_vector(7 downto 3) := "00001";
  constant TX0_OP  : std_ulogic_vector(7 downto 3) := "00010";
  constant OR_OP   : std_ulogic_vector(7 downto 3) := "00011";
  constant AND_OP  : std_ulogic_vector(7 downto 3) := "00100";
  constant XOR_OP  : std_ulogic_vector(7 downto 3) := "00101";
  constant ROL_OP  : std_ulogic_vector(7 downto 3) := "00110";
  constant ROR_OP  : std_ulogic_vector(7 downto 3) := "00111";
  constant DEC_OP  : std_ulogic_vector(7 downto 3) := "01000";
  constant SBC_OP  : std_ulogic_vector(7 downto 3) := "01001";
  constant ADD_OP  : std_ulogic_vector(7 downto 3) := "01010";
  constant STP_OP  : std_ulogic_vector(7 downto 3) := "01011";
  constant BTT_OP  : std_ulogic_vector(7 downto 3) := "01100";
  constant CLP_OP  : std_ulogic_vector(7 downto 3) := "01101";
  constant T0X_OP  : std_ulogic_vector(7 downto 3) := "01110";
  constant CMP_OP  : std_ulogic_vector(7 downto 3) := "01111";
  -- The 16 opcodes above cannot be easily reassigned to new
  -- values. The HDL code has been preoptimized in such a way
  -- that these opcodes MUST be single cycle, register to register
  -- opcodes. In addition, the bit patterns used map very
  -- closely to the default ALU operation and thus they cannot
  -- be easily changed.
  constant PSH_OP  : std_ulogic_vector(7 downto 3) := "10000";
  constant POP_OP  : std_ulogic_vector(7 downto 3) := "10001";
  constant BR0_OP  : std_ulogic_vector(7 downto 3) := "10010";
  constant BR1_OP  : std_ulogic_vector(7 downto 3) := "10011";
  constant USR_OP  : std_ulogic_vector(7 downto 3) := "10100";
  constant INT_OP  : std_ulogic_vector(7 downto 3) := "10101";
  constant USR2_OP : std_ulogic_vector(7 downto 3) := "10110";
  -- Note that the next several opcodes share the same base 7:3
  -- pattern and they are differentiated by the lower 3 bits of
  -- the opcode which is usually used for the source register field.
  -- These opcodes do not need anything in the REG field and thus
  -- have been combined to provide additional opcodes (more than 32).
  constant XSP_OP  : std_ulogic_vector(7 downto 0) := "10111000";
  constant RTS_OP  : std_ulogic_vector(7 downto 0) := "10111001";
  constant RTI_OP  : std_ulogic_vector(7 downto 0) := "10111010";
  constant JMP_OP  : std_ulogic_vector(7 downto 0) := "10111100";
  constant JSR_OP  : std_ulogic_vector(7 downto 0) := "10111111";
  constant UPP_OP  : std_ulogic_vector(7 downto 3) := "11000";
  constant STA_OP  : std_ulogic_vector(7 downto 3) := "11001";
  constant STX_OP  : std_ulogic_vector(7 downto 3) := "11010";
  constant STO_OP  : std_ulogic_vector(7 downto 3) := "11011";
  constant LDI_OP  : std_ulogic_vector(7 downto 3) := "11100";
  constant LDA_OP  : std_ulogic_vector(7 downto 3) := "11101";
  constant LDX_OP  : std_ulogic_vector(7 downto 3) := "11110";
  constant LDO_OP  : std_ulogic_vector(7 downto 3) := "11111";

  -- The Enumerated type below is for debugging only It can be deleted
  -- if your synthesizer has problems with the syntax...
  type OPCODE_type is
    (INC,ADC,TX0,OR8,AND8,XOR8,ROL8,ROR8,DEC,SBC,ADD,STP,BTT,CLP,T0X,
     CMP,PSH,POP,BR0,BR1,USR,INTx,USR2,RTS_RTI_JMP_JSR,UPP,STA,STX,
     STO,LDI,LDA,LDX,LDO,RTS,RTI,JMP,JSR,XSP);
    -- these are decodes of the RTS_RTI_JMP_JSR opcode
  signal OPCODE_DEBUG : OPCODE_type;

begin   --------------------------------------------------------------

  -- OPCODE_DEBUG makes debugging easy when viewing a simulation
  -- waveform as the opcode being currently executed is displayed in
  -- mnemonic form. This signals is not used anywhere so synthesizers
  -- should ignore it or it can be removed before synthesis.

  OPCODE_DEBUG <= INC when opcode=INC_OP
                  else ADC when opcode=ADC_OP
                  else TX0 when opcode=TX0_OP
                  else OR8  when opcode= OR_OP
                  -- OR,AND and XOR are reserved words...
                  else AND8 when opcode=AND_OP
                  else XOR8 when opcode=XOR_OP
                  else ROL8 when opcode=ROL_OP
                  else ROR8 when opcode=ROR_OP
                  else DEC when opcode=DEC_OP
                  else SBC when opcode=SBC_OP
                  else ADD when opcode=ADD_OP
                  else STP when opcode=STP_OP
                  else BTT when opcode=BTT_OP
                  else CLP when opcode=CLP_OP
                  else T0X when opcode=T0X_OP
                  else CMP when opcode=CMP_OP
                  else PSH when opcode=PSH_OP
                  else POP when opcode=POP_OP
                  else BR0 when opcode=BR0_OP
                  else BR1 when opcode=BR1_OP
                  else INTx when opcode=INT_OP
                  else USR2 when opcode=USR2_OP
                  else RTS when inst=RTS_OP
                  else RTI when inst=RTI_OP
                  else JMP when inst=JMP_OP
                  else JSR when inst=JSR_OP
                  else XSP when inst=XSP_OP
                  else UPP when opcode=UPP_OP
                  else STA when opcode=STA_OP
                  else STO when opcode=STO_OP
                  else STX when opcode=STX_OP
                  else LDI when opcode=LDI_OP
                  else LDA when opcode=LDA_OP
                  else LDO when opcode=LDO_OP
                  else LDX when opcode=LDX_OP
                  else USR;

  op_ftch <= op_fetch;  -- drive the port

  -- NOTE: In a few cases we compute the decoded outputs on the
  -- Instruction (INST) register, and other times we decode OPCODE.
  -- OPCODE is simply an alias of INST(7 downto 3).

  ------------------------ALU control logic----------------------------
  alu_set_i <= '1' when -- Set the I mask bit on an interrupt
               rst_r1='1' or
               (opcode=INT_OP and state(5)='1')
               else '0';
  alu_load_psr <= '1' when
                  -- we want to load the entire PSR (from alu out)
                  (opcode=STP_OP) or
                  (opcode=CLP_OP) or
                  (inst=RTI_OP and state(5)='1')
                  else '0';
  alu_load_nz <= '1' when ready='1' and
                 (-- we want the NZ bits of the PSR updated
                   (opcode=INC_OP) or
                   (opcode=TX0_OP) or
                   (opcode=T0X_OP) or
                   (opcode=ADC_OP) or
                   (opcode=DEC_OP) or
                   (opcode=SBC_OP) or
                   (opcode=AND_OP) or
                   (opcode= OR_OP) or
                   (opcode=XOR_OP) or
                   (opcode=CMP_OP) or
                   (opcode=ROL_OP) or
                   (opcode=ROR_OP) or
                   (opcode=ADD_OP) or
                   (opcode=BTT_OP) or
                   (opcode=LDI_OP and state(2)='1') or
                   (opcode=LDA_OP and state(4)='1') or
                   (opcode=LDX_OP and state(3)='1') or
                   (opcode=LDO_OP and state(4)='1'))
                 else '0';
  alu_load_c <= '1' when ready='1' and
                (-- we want the C bit of the PSR updated
                  (opcode=INC_OP) or
                  (opcode=ADC_OP) or
                  (opcode=ADD_OP) or
                  (opcode=DEC_OP) or
                  (opcode=SBC_OP) or
                  (opcode=CMP_OP) or
                  (opcode=UPP_OP) or
                  (opcode=ROL_OP) or
                  (opcode=ROR_OP))
                else '0';
  alu_a_sel_gjr <= "11" when    -- Zero
                   (opcode=T0X_OP) or
                   (opcode=TX0_OP)
                   else "10" when       -- PSR
                   (opcode=BR1_OP) or
                   (opcode=BR0_OP) or
                   (opcode=STP_OP) or
                   (opcode=CLP_OP)
                   else "01" when       -- DATAIN
                   (inst=RTI_OP) or
                   (inst=XSP_OP) or
                   (opcode=POP_OP) or
                   (opcode=LDI_OP) or
                   (opcode=LDA_OP) or
                   (opcode=LDX_OP) or
                   (opcode=LDO_OP)
                   else "00";   -- A_IN
  alu_carryin <= '1' when -- we need to set the carry to be 1
                 (opcode=INC_OP) or -- add 1 by setting b=0 and carry=1
                 (opcode=CMP_OP) or -- C becomes NOT-Borrow in subtract
                 (opcode=UPP_OP and state(1)='1')
                 else '0';
  alu_carry_sel <= '1' when -- use PSR C bit instead of ALU_CARRYIN
                   (opcode=ADC_OP) or
                   (opcode=SBC_OP) or
                   (opcode=ROR_OP) or
                   (opcode=ROL_OP) or
                   (opcode=UPP_OP and state(2)='1')
                   else '0';
  alu_b_zero  <= '1' when -- we want the B side of the ALU to be zero
                 (opcode=INC_OP) or
                 (opcode=DEC_OP) or
                 (opcode=UPP_OP) or
                 (inst=RTI_OP) or
                 (inst=XSP_OP) or
                 (opcode=POP_OP) or
                 (opcode=LDI_OP) or
                 (opcode=LDA_OP) or
                 (opcode=LDX_OP) or
                 (opcode=LDO_OP)
                 else '0';
  alu_b_invert  <= '1' when -- we need to invert the B side of the ALU
                   (opcode=DEC_OP) or
                   (opcode=SBC_OP) or
                   (opcode=CMP_OP) or
                   (opcode=CLP_OP)
                   else '0';
  alu_b_dcd <= '1' when -- need the DCD field in the B side of the ALU
               (opcode=BTT_OP) or
               (opcode=STP_OP) or
               (opcode=CLP_OP) or
               (opcode=BR1_OP) or
               (opcode=BR0_OP)
               else '0';
  -- ALU_MODE is the operation that the opcode will perform. Mostly
  -- the opcodes have been mapped so that INST(5:3) are mapped
  -- directly to these bits. Unfortunately, there are a few
  -- exceptions.
  alu_mode <= "000" when -- we need to add
              (opcode(7 downto 6)="11") or
              -- all load/store opcodes need adds
              (opcode=CMP_OP) or
              (opcode=T0X_OP) or
              (opcode=ADD_OP) or
              (opcode=RTI_OP(7 downto 3)) or
              (opcode=UPP_OP)
              else "100" when -- we need to AND
              (opcode=CLP_OP) or
              (opcode=BR1_OP) or
              (opcode=BR0_OP)
              else inst(5 downto 3);
              -- default is part of the instruction field
  -- combine the individual ALU control bits into a bus
  alu_ctl <= alu_set_i & alu_load_psr &
             alu_load_nz & alu_load_c & alu_a_sel_gjr & alu_carryin &
             alu_carry_sel & alu_b_zero & alu_b_invert & alu_b_dcd &
             alu_mode;

  -- Data select lines,
  -- 00=B side of the register file,
  -- 01=PSR,
  -- 10=PCL,
  -- 11=PCH.
  data_sel <= "11" when         -- PCH
              (opcode=INT_OP and state(3)='1') or
              (inst=JSR_OP and state(2)='1')
              else "10" when    -- PCL
              (opcode=INT_OP and state(4)='1') or
              (inst=JSR_OP and state(3)='1')
              else "01" when    -- PSR
              (opcode=INT_OP and state(2)='1')
              else "00";        -- Register file

  rega <= "000" when -- we want register 0
          (opcode=ADC_OP) or
          (opcode=SBC_OP) or
          (opcode=AND_OP) or
          (opcode= OR_OP) or
          (opcode=XOR_OP) or
          (opcode=CMP_OP) or
          (opcode=TX0_OP) or
          (opcode=ADD_OP) or
          (opcode=BTT_OP) or
          (opcode=LDX_OP and state(3)='1') or
          (opcode=LDO_OP and state(4)='1')
          else inst(2 downto 1) & '1' when  -- force LSB=1
          (inst=XSP_OP and (state(4)='1' or state(5)='1')) or
          (opcode=UPP_OP and state(2)='1')
          else inst(2 downto 0);
          -- default is the REG field of the instruction

  -- register file write enable
  reg_wrt <= '1' when ready='1' and
             -- we have data to write into the REGister file
             ((opcode(7)='0' and not
             -- all low 16 opcode write to the reg file
               (opcode=CMP_OP or        -- except CMP
                opcode=BTT_OP or        -- except BTT
                opcode=STP_OP or        -- except STP
                opcode=CLP_OP)) or      -- except CLP
              (opcode=UPP_OP) or
              (inst=XSP_OP and (state(3)='1' or state(5)='1')) or
              (opcode=POP_OP and state(3)='1') or
              (opcode=LDI_OP and state(2)='1') or
              (opcode=LDA_OP and state(4)='1') or
              (opcode=LDX_OP and state(3)='1') or
              (opcode=LDO_OP and state(4)='1'))
             else '0';

  -- Address to the B port of the register file
  regb <= "000" when -- we want register 0
          (opcode=T0X_OP) or regb_force_zero='1'
          else inst(2 downto 1) & '1' when -- REG with LSB forced to 1
          (opcode=STX_OP and state(1)='1') or
          (opcode=STO_OP and state(2)='1') or
          (opcode=LDX_OP and state(1)='1') or
          (opcode=LDO_OP and state(2)='1')
          else inst(2 downto 0);
          -- default is the REG field of the instruction

  -----------------address control logic-------------------------------
  addr_ctl <=
    sp_inc &         -- bit 12
    sp_dec &         -- bit 11
    sp_sel &         -- bit 10
    addr_inc_low8 &  -- bit 9
    addr_branch &    -- bit 8
    addr_abs &       -- bit 7
    addr_indx &      -- bit 6
    addr_offset &    -- bit 5
    addr_dl_ld &     -- bit 4
    sp_ld &          -- bit 3
    addr_pc_elr &    -- bit 2
    addr_pch_ld &    -- bit 1
    addr_pc_load;    -- bit 0

  sp_inc <= '1' when ready='1' and
            (
              (inst=RTS_OP and (state(2)='1' or state(3)='1')) or
              (inst=RTI_OP and
               (state(2)='1' or state(3)='1' or state(4)='1')) or
              (opcode=POP_OP and state(2)='1') or
              (inst=XSP_OP and state(4)='1')
              )
            else '0';

  sp_dec <= '1' when ready='1' and
            ( (opcode=INT_OP and
               (state(1)='1' or STATE(2)='1' or state(3)='1')) or
              (inst=JSR_OP and (state(1)='1' or state(2)='1')) or
              (opcode=PSH_OP and state(1)='1') or
              (inst=XSP_OP and state(2)='1'))
            else '0';

  sp_ld <= '1' when (inst=XSP_OP and (state(2)='1' or state(4)='1'))
           else '0';

  sp_sel <= '1' when
            (opcode=PSH_OP and state(1)='1') or
            (opcode=POP_OP and state(1)='1') or
            (opcode=INT_OP and
             (state(1)='1' or state(2)='1' or state(3)='1')) or
            (inst=JSR_OP and (state(1)='1' or state(2)='1')) or
            (inst=RTS_OP and
             (state(1)='1' or state(2)='1' or state(3)='1')) or
            -- state(3) is not needed for RTS, but it allows
            -- logic sharing with RTI
            (inst=RTI_OP and
             (state(1)='1' or state(2)='1' or state(3)='1'))
            else '0';

  addr_inc_low8 <= '1' when rst='0' and
                   (-- increment the PC, but not during reset
                     (op_fetch='1' and not interrupt='1') or
                     -- inc on opcode fetch except interrupt
                     (opcode=INT_OP and state(5)='1') or
                     (opcode=BR1_OP and state(1)='1') or
                     (opcode=BR0_OP and state(1)='1') or
                     (inst=JSR_OP and state(1)='1') or
                     (inst=RTS_OP and state(4)='1') or
                     (inst=JMP_OP and state(1)='1') or
                     (opcode=LDI_OP and state(1)='1') or
                     (opcode=LDA_OP and
                      (state(1)='1' or state(3)='1')) or
                     (opcode=LDO_OP and state(1)='1') or
                     (opcode=STA_OP and
                      (state(1)='1' or state(3)='1')) or
                     (opcode=STO_OP and state(1)='1'))
                   else '0';

  addr_branch <= '1' when
                 -- for BR0,BR1 we reload if we are
                 -- going to take the branch, else inc.
                 (opcode=BR1_OP and state(2)='1' and alu2op0_f='0') or
                 (opcode=BR0_OP and state(2)='1' and alu2op0_f='1')
                 else '0';

  addr_abs <= '1' when  -- addr = datain & DL
              (opcode=STA_OP and state(2)='1') or
              (opcode=LDA_OP and state(2)='1') or
              (opcode=INT_OP and state(6)='1') or
              (inst=RTS_OP and state(3)='1') or
              (inst=RTI_OP and state(3)='1') or
              (inst=JMP_OP and state(2)='1') or
              (inst=JSR_OP and state(4)='1')
              else '0';

  addr_indx <= '1' when -- add DL + 0 in v8_addr
               (opcode=STX_OP and state(1)='1') or
               (opcode=LDX_OP and state(1)='1')
               else '0';

  addr_offset <= '1' when -- add DL + REGF_B in v8_addr
                 (opcode=STO_OP and state(2)='1') or
                 (opcode=LDO_OP and state(2)='1')
                 else '0';

  addr_dl_ld <= '1' when rst='1' or
                (opcode=INT_OP and state(5)='1') or
                (opcode=POP_OP and state(2)='1') or
                (opcode=STA_OP and state(1)='1') or
                (opcode=STO_OP and state(1)='1') or
                (opcode=LDI_OP and state(1)='1') or
                (opcode=LDA_OP and (state(1)='1' or state(3)='1')) or
                (opcode=LDX_OP and state(2)='1') or
                (opcode=LDO_OP and (state(1)='1' or state(3)='1')) or
                (inst=RTS_OP and state(2)='1') or
                (inst=RTI_OP and (state(2)='1' or state(4)='1')) or
                (inst=JMP_OP and state(1)='1') or
                (inst=JSR_OP and state(1)='1') or
                (inst=XSP_OP and (state(2)='1' or state(4)='1')) or
                (opcode=BR1_OP and state(1)='1') or
                (opcode=BR0_OP and state(1)='1')
                else '0';

  addr_pc_elr <= '1' when (opcode=INT_OP and state(4)='1')
                 else '0';

  addr_pch_ld <= '1' when       -- route DATAIN to PC_HI
                 (opcode=INT_OP and state(6)='1') or
                 (inst=RTS_OP and state(3)='1') or
                 (inst=RTI_OP and state(3)='1') or
                 (inst=JMP_OP and state(2)='1') or
                 (inst=JSR_OP and state(4)='1')
                 else '0';

  addr_pc_load <= '1' when ready='1' and
                  (-- increment the PC
                    (op_fetch='1' and not interrupt='1') or
                    -- inc on opcode fetch except interrupt
                    (opcode=INT_OP and (state(4)='1' or state(5)='1'
                                        or state(6)='1')) or
                    (opcode=BR1_OP and state(1)='1') or
                    (opcode=BR0_OP and state(1)='1') or
                    (opcode=BR1_OP and state(2)='1'
                     and alu2op0_f='0') or
                    (opcode=BR0_OP and state(2)='1'
                     and alu2op0_f='1') or
                    (inst=JSR_OP and
                     (state(1)='1' or state(4)='1')) or
                    (inst=RTS_OP and
                     (state(3)='1' or state(4)='1')) or
                    (inst=RTI_OP and state(3)='1') or
                    (inst=JMP_OP and
                     (state(1)='1' or state(2)='1')) or
                    (opcode=LDI_OP and state(1)='1') or
                    (opcode=LDA_OP and
                     (state(1)='1' or state(3)='1')) or
                    (opcode=LDO_OP and state(1)='1') or
                    (opcode=STA_OP and
                     (state(1)='1' or state(3)='1')) or
                    (opcode=STO_OP and state(1)='1'))
                  else '0';

  ---------------------------------------------------------------------
  write_nxt <= write_d_lcl; -- drive the port
  write_d_lcl <= '1' when -- we want to write data to RAM,
                          -- computed 1 cycle ahead so we can flop it
                 (opcode=INT_OP and
                  (state(1)='1' or state(2)='1' or state(3)='1')) or
                 (inst=JSR_OP and (state(1)='1' or state(2)='1')) or
                 (opcode=PSH_OP and state(1)='1') or
                 (opcode=STA_OP and state(2)='1') or
                 (opcode=STX_OP and state(1)='1') or
                 (opcode=STO_OP and state(2)='1')
                 else '0';

  read <= '0' when
          -- we are reading from memory. Some opcodes have internal
          -- cycles so external logic can "steal" these bus cycles
          -- without performance loss. Note that we are actually
          -- computing when we are NOT doing a read which is only in a
          -- very few cycles!
          writel='1' or
          (opcode=BR0_OP and state(2)='1') or
          (opcode=BR1_OP and state(2)='1') or
          (inst=RTS_OP and (state(1)='1' or state(4)='1')) or
          (inst=RTI_OP and state(1)='1') or
          (opcode=INT_OP and state(1)='1') or
          (opcode=PSH_OP and state(1)='1') or
          (opcode=UPP_OP and state(1)='1') or
          (opcode=POP_OP and state(1)='1') or
          (opcode=STX_OP and state(1)='1') or
          (opcode=STO_OP and state(2)='1') or
          (opcode=LDX_OP and state(1)='1') or
          (opcode=LDO_OP and state(2)='1')
          else '1';

  -- OP_FETCH indicates that an opcode is being fetched from RAM.
  -- The previous opcode is typically performing it's final
  -- cycle and writing data back to the REGF if needed.
  op_fetch <= '1' when rst_r1='1' or
              (opcode(7)='0') or
              -- The low 16 opcodes are all single cycle opcodes
              (opcode=UPP_OP and state(2)='1') or
              (opcode=INT_OP and state(7)='1') or
              (opcode=BR0_OP and state(3)='1') or
              (opcode=BR1_OP and state(3)='1') or
              -- All of the opcodes in the JMP group are all 5 clocks
              -- long except for the JMP opcode itself which is only 3
              -- clocks.
              (opcode=JMP_OP(7 downto 3) and state(5)='1') or
              (inst=JMP_OP and state(3)='1') or
              (opcode=PSH_OP and state(3)='1') or
              (opcode=POP_OP and state(3)='1') or
              (opcode=LDI_OP and state(2)='1') or
              (opcode=LDA_OP and state(4)='1') or
              (opcode=LDX_OP and state(3)='1') or
              (opcode=LDO_OP and state(4)='1') or
              (opcode=STA_OP and state(4)='1') or
              (opcode=STX_OP and state(3)='1') or
              (opcode=STO_OP and state(4)='1') or
              (opcode=USR_OP) or
              (opcode=USR2_OP)
              else '0';

  opcde <= inst;        -- drive the debugging port
  cycle <= state;       -- drive the debugging port
  opcode <= inst(7 downto 3);

  -- We force an INT opcode into the Instruction register when
  -- an interrupt is pending and interrupts are enabled
  -- otherwise we load a new opcode when OP_FETCH is active.
  inst_nxt <= INT_OP & int_encoded when interrupt='1' and op_fetch='1'
            else datain when op_fetch='1'
            else inst;

  int_encoded <= "000" when int(0)='1' else
                 "001" when int(1)='1' else
                 "010" when int(2)='1' else
                 "011" when int(3)='1' else
                 "100" when int(4)='1' else
                 "101" when int(5)='1' else
                 "110" when int(6)='1' else
                 "111" when int(7)='1' else
                 "XXX";
  interrupt <= '1' when (alu2op(1)='0' and -- Maskable interrupts
                         not (int(7 downto 1)="0000000"))
               or int(0)='1'    -- INT(0) is Nonmaskable
               else '0';

  i_proc:process(clk)    -- create the register
  begin
    if (clk'event and clk='1') then
      if (rst='1') then
        inst <= "11111111";     -- sync set
        -- we won't execute this opcode but we do need the INST
        -- register to be defined during reset to get the Xes out in
        -- simulation. all ones=LDO opcode which won't do anything in
        -- the first clock.
      elsif (ready='1') then
        inst <= inst_nxt;
      else
        inst <= inst;
      end if;
    end if;
  end process;

  state_nxt <= "00000001" when op_fetch='1' else -- reload on opcode fetch
             state(7 downto 1) & '0';   -- shift to next state (one-hot)

  s_proc:process(clk) -- create the register
  begin
    if (clk'event and clk='1') then
      if (rst='1') then
        state <= "00000001"; -- sync set
      else
        if (ready='1') then  -- clock enabled flop
          state <= state_nxt;
        else
          state <= state; -- else wait in the current state until ready
        end if;
      end if;
    end if;
  end process;

  write <= writel; -- drive the local version out the port.

  vauto_proc:process(clk) -- flop the result from the ALU for
    -- speed and the write signal
  begin
    if (clk'event and clk='1') then
      if (ready='1') then
        alu2op0_f <= alu2op(0);
        writel <= write_d_lcl;
        rst_r1 <= rst;
        -- we need a flopped version of reset to get things started
      end if;
      -- regb is often in the critical path. We can compute this part
      -- of the regb logic a cycle early which shortens the critical
      -- regb timing.
      if (ready='1') then
        if ((opcode=STX_OP and state(1)='1') or
            (opcode=STO_OP and state(2)='1')) then
          regb_force_zero<='1';
        else
          regb_force_zero<='0';
        end if;
      end if;
    end if;
  end process;

end rtl;
