----------------------------------------------------------------------
-- Copyright 1998 VAutomation Inc. Nashua NH
-- HTTP://www.vautomation.com ALL RIGHTS RESERVED. This software is
-- provided under license and contains proprietary and confidential
-- material which is the property of VAutomation Inc.
--
-- File: v8_deice.vhd
-- Revision: $Name: REV9910 $
-- Description:
--      JTAG debugger for the V8-uRISC 8-bit microprocessor
--
--  This module provides a JTAG shell around the V8 which can both
--  control the V8 and can read or write to memory external to the V8.
--  Signals ending in _8 are to be connected to the V8.
--  Signals ending in _x are to be connected to logic external to V8.
-- 
--  This module has several architectures which allow easy selection
--  of various amounts of debugging control versus gate count.
--
-- EMPTY - 0 gates, no debug support.
--  The EMPTY architecture ssimply passes the various input signals
--  directly thru to their respective outputs.
-- BASIC - 3000 gates, basic debug support
--  The BASIC architecture provides the basic debug facilities of
--  single step, read/write external RAM, and a single hardware
--  breakpoint.
--
--  JTAG instructions:
--  HEX  Mnemonic       Scan chain selected     Description
--  00 = EXTEST         Required by IEEE 1149.1
--  11 = STOP           CTL     Stop the target uP by deasserting READY
--  21 = RUN            CTL     Resume processing, assert READY
--  31 = ENB_BKPT       STATUS  Search for the breakpoint
--  41 = STATUS         STATUS  Select the STATUS chain
--  51 = ONE_OP         CTL     Assert READY until the next opcode fetch
--  61 = ONE_CLK        CTL     Assert READY for one clock
--  71 = OP_ADDR        ADDR    Capture the ADDR chain on the
--                              next opcode fetch
--  81 = ADDR           ADDR    Select the ADDR chain
--  91 = DATA           DATA    Select the ADDR/DATA chain
--  A1 = CTL            CTL     Select the ADDR/DATA/CTL chain
--  B1 = BOUNDSCAN      EXTERNL Select the external boundary scan chain
--  C1 = BREAKPT        BREAKPT Select the breakpoint chain
--  05 = MEM_WRITE      DATA    Write to RAM
--  15 = MEM_READ       DATA    Read from RAM
--  45 = APPLY          CTL     Apply the scanned in vector for 1 clock
--  55 = APPLY_V8       CTL     Apply the scanned in vector for 1 clock
--                              only to the V8. Hold READ and WRITE to
--                              external logic inactive.
--  65 = APPLY_EXT      CTL     Apply the scanned in vector for 1 clock
--                              only to external logic. Hold READY to
--                              the V8 inactive.
--  FF = BYPASS         CTL     Required by IEEE 1149.1
--  Note that IEEE 1149.1 table 6-1 requires bits 1:0 to be reloaded
--  with 01 when the TAP controller is in the capture_IR state. In
--  order to retain the current instruction, all of our private
--  instructions have been chosen with the least significant 2
--  bits=01.


--------------Revision History---------------------------------------
-- $Log: v8_deice.vhd,v $
-- Revision 1.21  1999/09/14 16:20:00  eric
-- Very minor fix to OP_ADDR.
-- Histograms did not capture data properly because the IF
-- statement was clearing the latch on OP_FTCH before ever
-- being set. So no data was being captured until an
-- multicycle opcode came along where OP_FTCH is low
-- when we start the capture.
-- Also some RMM cleanups.
--
-- Revision 1.20  1999/08/25 19:32:52  scott
-- Modified the code to use std_ulogic(_vector) and
-- IEEE numeric_std package and shorten code width
--
-- Revision 1.19  1999/03/19 16:44:57  eric
-- Improved coding style to insure synopsys will use synchronous reset
-- DFFs.
--
-- Revision 1.18  1999/02/09 13:50:44  monika
-- Changed vjtag to be synchronous to processor clock
--
-- Revision 1.17  1998/11/13 21:06:21  eric
-- Fixed a metastablity problem with TCK_RISE. Sometimes in Xilinx
-- FPGAs TCK_RISE would not happen at all. Changed several of the
-- synchronizers to be more robust.
--
-- Revision 1.16  1998/10/23 15:18:03  eric
-- Fixed a bug when single stepping thru a WRITE. Was asserting WRITE
-- 1 clock too early.
--
-- Revision 1.15  1998/10/23 01:35:35  eric
-- added write_d.
--
-- Revision 1.14  1998/10/14 02:21:38  eric
-- fixed OP_ADDR so it only captures opcode fetches. was capturing all.
--
-- Revision 1.13  1998/09/13 12:24:43  eric
-- Fixed ONE_OP and single stepping when there are wait states.
--
-- Revision 1.12  1998/09/01 12:11:52  chris
-- Fixed Bypass intruction value (0xFF).
--
-- Revision 1.11  1998/08/31 19:58:08  eric
-- Fixed the shiftIR and shiftDR to match the new vjtag.vhd file.
--
-- Revision 1.10  1998/08/13 23:04:35  eric
-- Berakpoints work in simulation.
--
-- Revision 1.9  1998/07/01 23:31:45  eric
-- Fixed MEM_READ - we weren't latching the data at the right point.
--
-- Revision 1.8  1998/06/05  17:09:28  eric
-- Added the status chain so we can detect when a breakpoint has been
-- reached.
--
-- Revision 1.7  1998/06/02 14:12:07  eric
-- Pipelined the breakpoint chain otherwise it's always in the
-- critical path.
--
-- Revision 1.4  1998/04/22 18:55:07  eric
-- Reset is automatically cleared when doing mem_read or write.
--
-- Revision 1.3  1998/02/19 19:47:30  eric
-- Fixed the scan chains when doing APPLY instructions.
--
----------------------------------------------------------------------
--
library ieee;
use ieee.std_logic_1164.all; -- use the IEEE standard 1164 logic types.
use ieee.numeric_std.all;

entity v8_deice is      -------------------ENTITY---------------------
  port(
    clk : in std_ulogic; -- Processor clock
    reset_x : in std_ulogic; -- reset active high
    reset_8 : out std_ulogic; -- reset active high
    addr_8 : in std_ulogic_vector(15 downto 0); -- address bus out
    addr_x : out std_ulogic_vector(15 downto 0); -- address bus out
    clr_p_x : in std_ulogic_vector(7 downto 4); -- clear PSR flag bits
    clr_p_8 : out std_ulogic_vector(7 downto 4); -- clear PSR flag bits
    datain_x : in std_ulogic_vector(7 downto 0); -- data bus in
    datain_8 : out std_ulogic_vector(7 downto 0); -- data bus in
    dataout_8 : in std_ulogic_vector(7 downto 0); -- data bus out
    dataout_x : out std_ulogic_vector(7 downto 0); -- data bus out
    int_x : in std_ulogic_vector(7 downto 0);
    -- interrupt requests (level sensitive)
    int_8 : out std_ulogic_vector(7 downto 0);
    -- interrupt requests (level sensitive)
    op_ftch_8 : in std_ulogic; -- indicates an opcode fetch
    op_ftch_x : out std_ulogic; -- indicates an opcode fetch
    read_8 : in std_ulogic; -- 1=read cycle in progress
    read_x : out std_ulogic; -- 1=read cycle in progress
    ready_x : in std_ulogic; -- 0=insert wait states,1=run
    ready_8 : out std_ulogic; -- 0=insert wait states,1=run
    set_p_x : in std_ulogic_vector(7 downto 4); -- set PSR flag bits
    set_p_8 : out std_ulogic_vector(7 downto 4); -- set PSR flag bits
    write_d_8 : in std_ulogic; -- 1=write cycle next clock
    write_d_x : out std_ulogic; -- 1=write cycle next clock
    write_8 : in std_ulogic; -- 1=write cycle in progress
    write_x : out std_ulogic; -- 1=write cycle in progress
    spare1_i : in std_ulogic; -- extra external signals
    spare1_o : out std_ulogic; -- extra external signals
    spare2_i : in std_ulogic; -- extra external signals
    spare2_o : out std_ulogic; -- extra external signals
    spare3_i : in std_ulogic; -- extra external signals
    spare3_o : out std_ulogic; -- extra external signals
    -- JTAG signals
    TRST_N : in std_ulogic; -- JTAG active low async reset
    TCK : in std_ulogic; -- JTAG clock, must be > 1/2 FREQ of CLK
    TMS : in std_ulogic; -- JTAG mode
    TDI : in std_ulogic; -- JTAG datain
    TDO : out std_ulogic; -- JTAG dataout
    TDO_ENB : out std_ulogic -- JTAG dataout tristate enable
    );
end v8_deice;

architecture empty of v8_deice is  ---------Architecture Empty  -------
-- this architecture completely removes the V8_DEICE module.
begin
  write_d_x <= write_d_8;
  write_x   <= write_8;
  set_p_8   <= set_p_x;
  ready_8   <= ready_x;
  read_x    <= read_8;
  op_ftch_x <= op_ftch_8;
  int_8     <= int_x;
  dataout_x <= dataout_8;
  datain_8  <= datain_x;
  clr_p_8   <= clr_p_x;
  addr_x    <= addr_8;
  reset_8   <= reset_x;
  tdo       <= '0';
  tdo_enb   <= '0'; -- always tristate
  spare1_o  <= spare1_i;
  spare2_o  <= spare2_i;
  spare3_o  <= spare3_i;
end empty;

architecture basic of v8_deice is -----------------Architecture -----
  component vjtag
    port(
      tck     : in  std_ulogic; -- clock input
      trst_n  : in  std_ulogic; -- optional async reset active low
      tms     : in  std_ulogic; -- Test Mode Select
      tdi     : in  std_ulogic; -- Test Data In
      tdo     : out std_ulogic; -- Test Data Out
      tdo_enb : out std_ulogic; -- Test Data Out tristate enable
      -- internal connections
      clk      : in  std_ulogic; -- Processor clock
      tdo_mux  : in  std_ulogic; -- TDO before the negative edge flop
      bypass   : in  std_ulogic; -- JTAG instruction=BYPASS
      tdi_r1   : out std_ulogic; -- TDI flopped on TCK.
      tck_rise : out std_ulogic; -- clock enable
      captureDR: out std_ulogic; -- JTAG state=CAPTURE_DR
      shiftDR  : out std_ulogic; -- JTAG state=SHIFT_DR
      updateDR : out std_ulogic; -- JTAG state=UPDATE_DR
      captureIR: out std_ulogic; -- JTAG state=CAPTURE_IR
      shiftIR  : out std_ulogic; -- JTAG state=SHIFT_IR
      updateIR : out std_ulogic); -- JTAG state=UPDATE_IR
  end component;

  signal captureDR: std_ulogic;   -- capture data register
  signal shiftDR  : std_ulogic;   -- shift data register
  signal updateDR : std_ulogic;   -- update data register
  signal captureIR: std_ulogic;   -- capture INST register
  signal shiftIR  : std_ulogic;   -- shift INST register
  signal updateIR : std_ulogic;   -- update INST register
  signal bypass   : std_ulogic;
  signal DR_shift_enb : std_ulogic;
  signal IR_shift_enb : std_ulogic;
  signal IR_shift_reg : std_ulogic_vector(7 downto 0);
  signal addr_chain : std_ulogic_vector(15 downto 0); -- addr chain
  signal addr_chain_d : std_ulogic_vector(15 downto 0); -- D input
  signal addr_chain_enb : std_ulogic; -- CTL chain clock enable
  signal addr_chain_sel : std_ulogic; -- select the control chain 
  signal addr_reg : std_ulogic_vector(15 downto 0); -- control chain reg
  signal addr_reg_enb : std_ulogic; -- CTL chain clock enable
  signal addr_reg_sel : std_ulogic; -- use the JTAG regs instead of V8
  signal apply_vector_d : std_ulogic; -- 1 clock early
  signal apply_vector_elr : std_ulogic; -- drive with the vector in regs
  signal breakpt_now : std_ulogic; -- breakpoint condition found now
  signal breakpt_now_data : std_ulogic; -- breakpoint conditn found now
  signal breakpt_now_addr : std_ulogic; -- breakpoint conditn found now
  signal breakpt_now_ctl : std_ulogic; -- breakpoint conditn found now
  signal breakpt_run : std_ulogic; -- searching for breakpoints
  signal breakpt_chain : std_ulogic_vector(55 downto 0);
  -- breakpoint chain
  signal breakpt_chain_d : std_ulogic_vector(55 downto 0);
  -- D input to flops
  signal breakpt_chain_enb : std_ulogic; -- clock enable
  signal breakpt_chain_sel : std_ulogic; -- select the breakpoint chain
  signal ctl_chain : std_ulogic_vector(23 downto 0); -- control chain
  signal ctl_chain_d : std_ulogic_vector(23 downto 0); -- D input
  signal ctl_chain_enb : std_ulogic; -- CTL chain clock enable
  signal ctl_chain_sel : std_ulogic; -- select the control chain 
  signal ctl_reg : std_ulogic_vector(23 downto 0); -- control chain reg
  signal ctl_reg_enb : std_ulogic; -- CTL chain clock enable
  signal ctl_reg_sel : std_ulogic; -- use the JTAG regs instead of V8
  signal data_chain : std_ulogic_vector(15 downto 0); -- control chain
  signal data_chain_d : std_ulogic_vector(15 downto 0); -- D input
  signal data_chain_enb : std_ulogic; -- CTL chain clock enable
  signal data_chain_sel : std_ulogic; -- select the control chain 
  signal data_reg : std_ulogic_vector(15 downto 0); -- control chain reg
  signal data_reg_enb : std_ulogic; -- CTL chain clock enable
  signal data_reg_sel : std_ulogic; -- use the JTAG regs instead of V8
  signal get_opcode_now : std_ulogic;
  signal inst : std_ulogic_vector(7 downto 0);
  signal jtag_halt : std_ulogic; -- stop the V8, deassert ready
  signal jtag_halt_d : std_ulogic; -- one clock early
  signal ready_local,ready_pre : std_ulogic; -- local version of ready
  signal reset : std_ulogic;
  signal single_step_proc,single_step_1st : std_ulogic;
  signal stat_chain : std_ulogic_vector(7 downto 0); -- status chain
  signal stat_chain_d : std_ulogic_vector(7 downto 0); -- status chain
  signal stat_chain_sel, stat_chain_enb : std_ulogic; -- status chain
  signal stop_proc : std_ulogic;
  signal tck_rise : std_ulogic;
  signal tdo_mux : std_ulogic;
  signal write_x_d : std_ulogic; -- one clock early - D input to DFF
  signal write_x_lcl : std_ulogic; -- local version
  signal write_save : std_ulogic; -- temporary holding reg

  -- The following line is used when translating to Verilog...
  -- synopsys sync_set_reset "reset_x"

  constant STOP     : std_ulogic_vector(7 downto 0) := "00010001";
  constant RUN      : std_ulogic_vector(7 downto 0) := "00100001";
  constant ENB_BKPT : std_ulogic_vector(7 downto 0) := "00110001";
  constant STATUS   : std_ulogic_vector(7 downto 0) := "01000001";
  constant ONE_OP   : std_ulogic_vector(7 downto 0) := "01010001";
  constant ONE_CLK  : std_ulogic_vector(7 downto 0) := "01100001";
  constant OP_ADDR  : std_ulogic_vector(7 downto 0) := "01110001";
  constant ADDR     : std_ulogic_vector(7 downto 0) := "10000001";
  constant DATA     : std_ulogic_vector(7 downto 0) := "10010001";
  constant CTL      : std_ulogic_vector(7 downto 0) := "10100001";
  constant BOUNDSCAN: std_ulogic_vector(7 downto 0) := "10110001";
  constant BREAKPT  : std_ulogic_vector(7 downto 0) := "11000001";
  constant MEM_WRITE: std_ulogic_vector(7 downto 0) := "00000101";
  constant MEM_READ : std_ulogic_vector(7 downto 0) := "00010101";
  constant APPLY    : std_ulogic_vector(7 downto 0) := "01000101";
  constant APPLY_V8 : std_ulogic_vector(7 downto 0) := "01010101";
  constant APPLY_EXT: std_ulogic_vector(7 downto 0) := "01100101";

  attribute sync_set_reset : string;      -- required for synopsys
  attribute sync_set_reset of reset_x : signal is "true";
  -- required for synopsys

BEGIN------------------------------------------------------------------

  tap_proc : vjtag
    port map(
      tck       => tck,
      trst_n    => trst_n,
      tms       => tms,
      tdi       => tdi,
      tdo       => tdo,
      tdo_enb   => tdo_enb,
      -- internal connections
      clk       => clk,
      tdo_mux   => tdo_mux,
      bypass    => bypass,
      tck_rise  => tck_rise,
      captureDR => captureDR,
      shiftDR   => shiftDR,
      updateDR  => updateDR,
      captureIR => captureIR,
      shiftIR   => shiftIR,
      updateIR  => updateIR );

  IR_shift_enb <= shiftIR and tck_rise; -- shift the INST register
  DR_shift_enb <= shiftDR and tck_rise; -- shift the DATA register
  bypass <= '1' when inst="11111111"
            else '0'; -- bypass instruction (FF)

  tdo_mux <= ctl_chain(0)          when ctl_chain_sel = '1'
             else data_chain(0)    when data_chain_sel = '1'
             else addr_chain(0)    when addr_chain_sel = '1'
             else breakpt_chain(0) when breakpt_chain_sel = '1'
             else stat_chain(0)    when stat_chain_sel = '1'
             else IR_shift_reg(0);

  reset <= reset_x;

  -----------------Create the INSTRUCTION register-------------------
  i_proc: process(clk)
  begin 
    if (clk'event and clk='1') then
      if (reset_x='1') then
        IR_shift_reg <= "00000000";
      elsif (captureIR='1') then
        IR_shift_reg <= IR_shift_reg(7 downto 2) &
                        '0' & '1'; -- 1149.1 table 6-1,
                                   -- LS 2 bits must be 01
      elsif (IR_shift_enb='1') then
        IR_shift_reg <= tdi & IR_shift_reg(7 downto 1);
      end if;
      if (reset_x='1') then
        inst <= "00000000";
      elsif (updateIR='1') then
        inst <= IR_shift_reg;
      end if;
      
      -----------------Create the STATUS chain clock enabled flops-----
      if (stat_chain_enb='1') then
        stat_chain <= stat_chain_d;
      end if;

      -----------------Create the ADDRESS chain clock enabled flops----
      if (addr_chain_enb='1') then
        addr_chain <= addr_chain_d;
      end if;

      if (addr_reg_enb='1') then -- load
        addr_reg <= addr_chain;
      end if;

      -----------------Create the CONTROL chain clock enabled flops----
      if (ctl_reg_enb='1') then
        ctl_reg(23 downto 21) <= ctl_chain(23 downto 21);
        ctl_reg(16 downto 0)  <= ctl_chain(16 downto 0);
      end if;

      -- Special logic for RESET, READY, READ and WRITE here.
      -- It allows special instructions to manipulate only the V8, only
      -- external logic, both or to do Memory read/writes quickly.
      if (ctl_reg_enb='1') then
        ctl_reg(20) <= ctl_chain(20); -- reset to the V8
        ctl_reg(19) <= ctl_chain(19); -- ready to the V8
        ctl_reg(18) <= ctl_chain(18); -- write to RAM
        ctl_reg(17) <= ctl_chain(17); -- read to RAM
      elsif (inst=mem_read) then
        ctl_reg(20) <= '0'; -- reset to the V8
        ctl_reg(19) <= '0'; -- ready to the V8
        ctl_reg(18) <= '0'; -- write to RAM
        ctl_reg(17) <= '1'; -- read to RAM
      elsif (inst=mem_write) then
        ctl_reg(20) <= '0'; -- reset to the V8
        ctl_reg(19) <= '0'; -- ready to the V8
        ctl_reg(18) <= '1'; -- write to RAM
        ctl_reg(17) <= '0'; -- read to RAM
      elsif (inst=apply_v8) then
        ctl_reg(20) <= ctl_reg(20); -- reset to the V8
        ctl_reg(19) <= ctl_reg(19); -- ready to the V8
        ctl_reg(18) <= '0'; -- write to RAM
        ctl_reg(17) <= '0'; -- read to RAM
      elsif (inst=apply_ext) then
        ctl_reg(20) <= ctl_reg(20); -- reset to the V8
        ctl_reg(19) <= '0'; -- ready to the V8
        ctl_reg(18) <= ctl_reg(18); -- write to RAM
        ctl_reg(17) <= ctl_reg(17); -- read to RAM
      end if;

      if (ctl_chain_enb='1') then -- load
        ctl_chain <= ctl_chain_d;
      end if;

      -----------------Create the DATA chain clock enabled flops------
      if (data_chain_enb='1') then
        data_chain <= data_chain_d;
      end if;

      if (data_reg_enb='1') then -- load
        data_reg <= data_chain;
      end if;
      
      -----------------Create the breakpoint chain clock enabled flops
      if (breakpt_chain_enb='1') then
        breakpt_chain <= breakpt_chain_d;
      end if;
    end if;
  end process;

  ----------------Create the processor hold logic---------------------
  sp_proc: process(clk)
  begin 
    if (clk'event and clk='1') then
      if (reset_x='1') then
        stop_proc<='0'; -- sync reset
      else
        if (inst = RUN and updateIR='1' and tck_rise='1') then
          stop_proc<='0';
        elsif (inst = STOP or breakpt_now='1') then
          stop_proc<='1';
        end if;
      end if;
    end if;
  end process;

  ssp_proc: process(clk)
  begin 
    if (clk'event and clk='1') then
      if (reset_x='1') then
        single_step_proc<='0';
        single_step_1st<='0';
        breakpt_run<='0';
        jtag_halt<='0';
      else
        if (inst = ONE_OP and updateIR='1' and tck_rise='1') then
          single_step_proc<='1';
        elsif (op_ftch_8 = '1' and single_step_1st='0') then
          single_step_proc<='0';
        end if;
        if (inst = ONE_OP and updateIR='1' and
            tck_rise='1' and op_ftch_8='1') then
          single_step_1st<='1';
          -- step off of the current opcode fetch
          -- if we op_ftch is already a one
        elsif (op_ftch_8 = '1' and ready_local='1') then
          single_step_1st<='0';
        end if;
        if (inst=ENB_BKPT) then
          breakpt_run<='1';
        elsif (breakpt_now = '1') then
          breakpt_run<='0';
        end if;
        jtag_halt <= jtag_halt_d; -- create the flop here
      end if;
    end if;
  end process;

  op_proc: process(clk)
  begin 
    if (clk'event and clk='1') then
      -- get_opcode_now is active when we want to latch an opcode --
      if (inst=OP_ADDR and updateDR='1') then
        get_opcode_now <= '1';
      elsif (op_ftch_8='1') then
        get_opcode_now <= '0';
      end if;

      if (ready_local='1') then
        write_save <= write_d_8; -- save the state of write
                                 -- when JTAG_HALT is active
      end if;

      write_x_lcl <= write_x_d;

    end if;
  end process;

  apl_proc: process(clk)
  begin 
    if (clk'event and clk='1') then
      if (reset_x='1') then 
        apply_vector_elr <= '0'; -- async reset
      else 
        apply_vector_elr <= apply_vector_d;
      end if;
    end if;
  end process;

  -------------------Create the logic for the STATUS CHAIN--------------
  stat_chain_d <= tdi & stat_chain(7 downto 1)
                  when DR_shift_enb='1' and stat_chain_sel='1'
                  else "000000" & breakpt_run & jtag_halt;

  -- clock enable for loading the shift register
  stat_chain_enb <= '1' when (captureDR='1' and stat_chain_sel='1') or
                    (DR_shift_enb='1' and stat_chain_sel='1') or
                    -- shift the chain
                    reset='1' -- load on reset to initialize
                    else '0';

  stat_chain_sel <= '1' when inst=ENB_BKPT or inst=STATUS else '0';

  -------------------Create the logic for the ADDR CHAIN----------------
  -- Mux for the addr_chain shift register
  addr_chain_d <= tdi & addr_chain(15 downto 1)
                  when DR_shift_enb='1' and addr_chain_sel='1'
                  else addr_8;

  -- Mux for the addr out to the rest of the system
  addr_x <= addr_reg when addr_reg_sel='1' else addr_8;
  -- use the JTAG chain for the addr bus

  -- clock enable for loading the addr_chain shift register
  addr_chain_enb <= '1' when (captureDR='1' and addr_chain_sel='1' 
                              and inst/=OP_ADDR) or
                    -- capture the current addr in the SR except
                    -- when doing histograms
                    get_opcode_now='1' or
                    -- capture the current opcode addr
                    (DR_shift_enb='1' and addr_chain_sel='1') or
                    -- shift the chain
                    breakpt_run='1' or
                    -- constantly load while breakpoint is enabled.
                    reset='1' -- load on reset to initialize
                    else '0';

  -- clock enable for the loading the ADDR register
  addr_reg_enb <= '1' when (updateDR='1' and addr_chain_sel='1')
                  or reset='1'
                  else '0';

  addr_chain_sel <= '1' when inst/=BREAKPT and inst/="00000000" and
                    stat_chain_sel='0'
                    else '0';

  addr_reg_sel <= '1' when apply_vector_elr='1'
                  else '0';

  --------------------Create the logic for the DATA CHAIN--------------
  -- Mux for the data_chain shift register
  data_chain_d <= addr_chain(0) & data_chain(15 downto 1)
                  when DR_shift_enb='1' and data_chain_sel='1'
                  else datain_x & dataout_8;

  -- Mux for the data busses out to the rest of the system
  datain_8 <= data_reg(15 downto 8) when data_reg_sel='1' else datain_x;
  dataout_x <= data_reg(7 downto 0)  when data_reg_sel='1'
               else dataout_8;

  -- clock enable for loading the shift register
  data_chain_enb <= '1' when (captureDR='1' and data_chain_sel='1' and
                              inst/=MEM_READ) or
                    -- capture the current values in the SR
                    (apply_vector_elr='1' and inst=MEM_READ) or
                    -- capture busses on mem read
                    (DR_shift_ENB='1' and data_chain_sel='1') or
                    -- shift the chain
                    breakpt_run='1' or
                    -- constantly load while breakpoint is enabled.
                    reset='1' -- load on reset to initialize
                    else '0';

  -- clock enable for the loading the DATA register
  data_reg_enb <= '1' when (updateDR='1' and data_chain_sel='1')
                  or reset='1'
                  else '0';

  data_chain_sel <= '1' when INST=DATA or INST=CTL or INST=MEM_READ 
                    or INST=MEM_WRITE or ctl_chain_sel='1'
                    else '0';

  data_reg_sel <= '1' when apply_vector_elr='1'
                  else '0';


  ----------------Create the logic for the CONTROL CHAIN----------------
  -- Mux for the CTL_chain shift register
  ctl_chain_d <= data_chain(0) & ctl_chain(23 downto 1)
                 when DR_shift_enb='1' and ctl_chain_sel='1'
                 else spare1_i & spare2_i & spare3_i & reset_x &
                      ready_x & write_8 & read_8 & op_ftch_8 & 
                      clr_p_x & set_p_x & int_x ;

  -- Mux for the signals in or out to the rest of the system
  int_8 <= ctl_reg(7 downto 0)  when ctl_reg_sel='1' else int_x;
  -- use the JTAG chain for the control sigs
  set_p_8 <= ctl_reg(11 downto 8) when ctl_reg_sel='1' else set_p_x;
  clr_p_8 <= ctl_reg(15 downto 12) when ctl_reg_sel='1' else clr_p_x;
  op_ftch_x <= ctl_reg(16) when ctl_reg_sel='1' else op_ftch_8;
  -- Both read and write are disabled when we stop the V8
  read_x <= ctl_reg(17) when apply_vector_elr='1'
            else read_8 and not jtag_halt;

  -- The logic below for WRITE ends up putting a MUX and quite a bit
  -- of logic into the path for generating WE_N. WE_N is often a
  -- critical signal and must not have any delay on it or we might
  -- violate the address hold time for external memory devices. Thus,
  -- the WRITE signal is coded a clock ahead and comes directly from a
  -- flop here in the deice core.

  -- write_x <= ctl_reg(18) when apply_vector_elr='1'
  --            else write_8 AND NOT jtag_halt;

  -- The signals below compute the desired WRITE_D which is input into
  -- a DFF above.
  write_x_d <= ctl_reg(18) when apply_vector_d='1' else
               '0' when jtag_halt_d='1' else
               -- force write inactive when stopped
               write_save when jtag_halt='1' else
               -- return to the value we want
               write_d_8 when ready_local='1' else
               -- ready active, load the next value
               write_x_lcl; -- retain the current state
  write_x <= write_x_lcl; -- drive the port
  write_d_x <= write_x_d; -- drive the port

  -------------Create the logic to apply a vector for 1 cycle----------
  apply_vector_d <= '1' when 
                    (updateIR='1' and tck_rise='1') and
                    -- executing a JTAG instruction
                    (inst=APPLY or inst=APPLY_V8 or inst=APPLY_EXT or
                     -- or a vector
                     inst=MEM_READ or inst=MEM_WRITE) else
                     -- or a memory cycle
                    '0' when (ready_x='1') else
                    -- wait until the cycle completes
                    apply_vector_elr; -- no change

  ----------Create the logic for JTAG_HALT------------------------------
  jtag_halt_d <= '0' when 
                 (stop_proc='0' or
                  ((updateIR='1' and tck_rise='1') and
                   (inst=APPLY or inst=APPLY_V8 or inst=APPLY_EXT or
                    inst=ONE_CLK)) or
                  (single_step_proc='1' and jtag_halt='1' and
                  -- step every other clock until an opcode is found
                   (op_ftch_8='0' or single_step_1st='1')))
                   -- skip over the first opcode fetch though
                 else '1' when
                 ((stop_proc='1' or breakpt_now='1') and ready_x='1')
                 else jtag_halt;        -- no change

  ready_pre <= ctl_reg(19) when ctl_reg_sel = '1' else ready_x;
  reset_8   <= ctl_reg(20) when ctl_reg_sel = '1' else reset_x;
  spare3_o  <= ctl_reg(21) when ctl_reg_sel = '1' else spare3_i;
  spare2_o  <= ctl_reg(22) when ctl_reg_sel = '1' else spare2_i;
  spare1_o  <= ctl_reg(23) when ctl_reg_sel = '1' else spare1_i;

  ready_local <= ready_pre and not jtag_halt;
  ready_8 <= ready_local;

  -- clock enable for loading the CTL_CHAIN shift register
  ctl_chain_enb <= '1' when (captureDR='1' and ctl_chain_sel='1') or
                   -- capture the current values in the SR
                   (DR_shift_ENB='1' and ctl_chain_sel='1') or
                   -- shift the chain
                   breakpt_run='1' or
                   -- constantly load while breakpoint is enabled.
                   reset='1' -- load on reset to initialize
                   else '0';

  -- clock enable for the loading the ADDR register
  ctl_reg_enb <= '1' when (updateDR='1' and ctl_chain_sel='1')
                 or reset='1'
                 else '0';

  ctl_reg_sel <= '1' when apply_vector_elr='1'
                 else '0';

  ctl_chain_sel <= '1' when INST=CTL or INST=APPLY or INST=APPLY_V8
                            or INST=APPLY_EXT
                   else '0';

  ----------------Create the logic for the BREAKPOINT CHAIN------------
  -- mux for the chain
  breakpt_chain_d <= (others => '0') when reset='1' 
                     else tdi & breakpt_chain(55 downto 1);

  breakpt_chain_enb <= '1' when (captureDR='1' and
                                 breakpt_chain_sel='1') or
                           -- capture the current values in the SR
                       (DR_shift_enb='1' and breakpt_chain_sel='1') or
                       -- shift the chain
                       reset='1' -- load on reset to initialize
                       else '0';

  breakpt_chain_sel <= '1' when INST=BREAKPT
                       else '0';

  -- we have to be searching for a breakpoint and the bits we are
  -- looking for have to match, then we will assert breakpt_now and
  -- stop the processor.

  breakpt_now <= breakpt_run and breakpt_now_addr and
                 breakpt_now_data and breakpt_now_ctl;

  breakpt_now_addr <= '1' when 
                      ((((addr_chain xor addr_reg)) and 
                        breakpt_chain(55 downto 40))
                       = "0000000000000000") else '0';

  breakpt_now_data <= '1' when 
                      ((((data_chain xor data_reg)) and 
                        breakpt_chain(39 downto 24))
                       = "0000000000000000") else '0';

  breakpt_now_ctl <= '1' when 
                     ((((ctl_chain xor ctl_reg)) and
                       breakpt_chain(23 downto 0))
                      = "000000000000000000000000")
                     else '0';
  
end basic;
