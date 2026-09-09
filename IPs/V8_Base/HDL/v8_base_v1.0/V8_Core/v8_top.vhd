----------------------------------------------------------------------
-- Copyright 1997 VAutomation Inc. Nashua NH (603) 882-2282 ALL RIGHTS
-- RESERVED. This software is provided under license and contains
-- proprietary and confidential material which is the property of
-- VAutomation Inc.
--
-- File: v8_top.vhd
-- Revision: $Name: REV9910 $
-- Description:
--      This is the top level for the V8 uProcessor
--
-- Crude block diagram:
-- 
--          +-----------------------------+
--          | Opcode Decode     OPDCD     |
--RST------->                             |
--SET_P[7:4]>                             |
--CLR_P[7:4]>                             |
--INT[7:0]-->                             >----->READ
--READY----->                             >----->WRITE
--DATAIN-+-->                             >----->OP_FETCH
--       |  +-----------------------------+
--       |
--       |                +---------------------------------+
--       |                |                                 |
--       |    +-----------v------------+                    |
--       |    |V8_REGS                 |                    |
--       |    |   2 port register file |                    |
--       |    |   1 R/W, 1 Read        |                    |
--       |    |   16x8                 |                    |
--       |    |REGF_A REGF_B           |                    |
--       |    +---v---v----------------+                    |
--       |        |   |                                     |
--       |        |   |                             +---+   |
--       |        |   |        +------------+       |   |   |
--       |        |   |        |V8_ADDR     |ADDR_NXT   |   |
--       +--------|---|-------->            >------->   >---|----->
--                |   |        | Address    |       |   |   |   ADDR
--                |   |        | generation |PC     |>  |   |
--                +---|-------->            >----+  +---+   |
--                |   |        | 16 bit PC  |    |          |
--                |   +--------> 16 bit SP  >-+  |          |
--                |   |        | 16 bit Dreg| |  |          |
--                |   |        +------------+ |  |   |\     |
--                |   |                       |  |   | \    |
--                |   |   +-------------------+  +--->  \   |
--                |   |   |                          |   \  |
--                |   +---|-------------------------->    >-|----->
--                |   |   |                          |   /  | DATAOUT
--                |   |   |             +------------>  /   |
--                |   |   |             |            | /    |
--                |   |   |             |            |/     |
--                |   |   |     ___ PSR |                   |
--                |   |   +---->   >----+                   |
--                |   |        |    \                       |
--                |   +-------->     \                      |
--                |            \V8_ALU\                     |
--                |             >      >--------------------+
--                |            /      /    
--                |            |     /    
--                +------------>    /                     
--                             |___/                     
--                                                      
-- Signals ending in _n are active low.


--------------Revision History---------------------------------------
-- $Log: v8_top.vhd,v $
-- Revision 1.16 2006/06/19 gtlee
-- Added clr_pc signal for remote rebooting
--
-- Revision 1.15  1999/09/13 19:21:24  eric
-- Added SP_OFLO stack overflow indicator.
--
-- Revision 1.14  1999/08/25 21:06:57  scott
-- Cleaned up code to shorten width in compliance with RMM
--
-- Revision 1.13  1999/08/25 13:49:41  scott
-- Modified the code to use std_ulogic(_vector) and IEEE numeric_std
-- package
--
-- Revision 1.12  1998/10/23 01:35:14  eric
-- added WRITE_D.
--
-- Revision 1.11  1997/10/24 17:31:02  eric
-- cleanups for verilog and timing improvements.
--
-- Revision 1.10  1997/06/27 18:47:03  eric
-- Major upgrade in performance. pipleined DATAIN and ADDR out.
--
-- Revision 1.9  1997/03/14 15:19:23  eric
-- changed the DATAOUT data path to come from the REGF instead of the
-- ALU for speed.
--
-- Revision 1.5  1996/12/23 17:58:56  eric
-- BETA Revision 0.9 release
--
-- Revision 1.4  1996/12/13  21:35:00  eric
-- Changed several opcodes. JMP and JSR share RTS and RTN.
-- CLR and SET replaced with BTT and ADD. Added UPP.
--
-- Revision 1.1  1995/11/24  18:30:32  eric
-- Initial revision
---------------------------------------------------------------------
--
library ieee;
use ieee.std_logic_1164.all; -- use the IEEE standard 1164 logic types.
use ieee.numeric_std.all;

entity v8_top is -----------------------------ENTITY-----------------
  port(
    clk     : in  std_ulogic; -- everything clocks on rising edge
    rst     : in  std_ulogic; -- reset active high
	-- inputs
	clr_pc  : in  std_ulogic; -- clear PC for Remote restart
    clr_p   : in  std_ulogic_vector(7 downto 4);  -- clear PSR flag bits
    datain  : in  std_ulogic_vector(7 downto 0);  -- data bus in
    int     : in  std_ulogic_vector(7 downto 0);  -- interrupt requests
                                                  -- (level sensitive)
    ready   : in  std_ulogic; -- 0=insert wait states,1=run
    set_p   : in  std_ulogic_vector(7 downto 4); -- set PSR flag bits
	-- outputs
    write   : out std_ulogic; -- 1=write cycle in progress
    addr    : out std_ulogic_vector(15 downto 0); -- address bus out
    dataout : out std_ulogic_vector(7 downto 0);  -- data bus out
    op_ftch : out std_ulogic; -- indicates an opcode fetch
    read    : out std_ulogic; -- 1=read cycle in progress
    -- debugging signals
    cycle   : out std_ulogic_vector(8 downto 1); -- current state vector
    opcde   : out std_ulogic_vector(7 downto 0); -- current opcode
    write_nxt: out std_ulogic; -- WRITE one cycle early
    pc      : out std_ulogic_vector(15 downto 0); -- program counter
    psr     : out std_ulogic_vector(7 downto 0); -- PSR flag register
    sp_oflo : out std_ulogic	-- stack pointer overflow
    );
end v8_top;

architecture rtl of v8_top is ---------Architecture rtl-----------
  component v8_alu
    port(
      clk    : in  std_ulogic; -- everything clocks on rising edge
      rst    : in  std_ulogic; -- reset
      datain : in  std_ulogic_vector(7 downto 0);  -- data in
      a_in   : in  std_ulogic_vector(7 downto 0);  -- A port
      b_in   : in  std_ulogic_vector(7 downto 0);  -- B port
      ctl    : in  std_ulogic_vector(13 downto 0);  -- control
      set_p  : in  std_ulogic_vector(7 downto 4);  -- PSR flag set
      clr_p  : in  std_ulogic_vector(7 downto 4);  -- PSR flag clear
      dcd    : in  std_ulogic_vector(2 downto 0);  -- decode value
      y_out  : out std_ulogic_vector(7 downto 0);  -- ALU out port
      alu2op : out std_ulogic_vector(2 downto 0);  -- flags
      -- debugging signals
      psr    : out std_ulogic_vector(7 downto 0));  -- Flags register
  end component;
  component op_dcd
    port(
      clk      : in  std_ulogic; -- everything clocks on rising edge
      rst      : in  std_ulogic; -- synchronous reset active high
      --
      alu2op   : in  std_ulogic_vector(2 downto 0); -- alu flags
      alu_ctl  : out std_ulogic_vector(13 downto 0); -- ALU control
      data_sel : out std_ulogic_vector(1 downto 0);
      -- DATA mux select lines
      datain   : in  std_ulogic_vector(7 downto 0); -- data bus in
      int      : in  std_ulogic_vector(7 downto 0);
      -- interrupt requests (level sensitive)
      op_ftch  : out std_ulogic; -- indicates an opcode fetch
      addr_ctl : out std_ulogic_vector(12 downto 0); -- control
      read     : out std_ulogic; -- 1=read cycle in progress
      ready    : in  std_ulogic; -- 0=insert wait states,1=run
      rega     : out std_ulogic_vector(2 downto 0);
      -- REG field of the Instruction
      regb     : out std_ulogic_vector(2 downto 0);
      -- Register File b addr
      reg_wrt  : out std_ulogic; -- register file write enable
      write    : out std_ulogic; -- 1=write cycle in progress
      -- debugging signals
      write_nxt: out std_ulogic; 
      opcde    : out std_ulogic_vector(7 downto 0);
      -- current opcode
      cycle    : out std_ulogic_vector(8 downto 1)
      -- current state vector
      );
  end component;
  component v8_addr
    port(
      clk     : in  std_ulogic; -- everything clocks on rising edge
      rst     : in  std_ulogic; -- reset

	  clr_pc  : in  std_ulogic; -- Clear PC for remote restart
      datain  : in  std_ulogic_vector(7 downto 0); -- data bus in
      vec     : in  std_ulogic_vector(2 downto 0); -- Interrupt vector
      ctl     : in  std_ulogic_vector(12 downto 0); -- control signals
      regf_a  : in  std_ulogic_vector(7 downto 0); -- reg file A data
      regf_b  : in  std_ulogic_vector(7 downto 0); -- reg file B data

      addr_nxt: out std_ulogic_vector(15 downto 0); -- pre Address
      dataout : out std_ulogic_vector(7 downto 0); -- dataout
      sp      : out std_ulogic_vector(15 downto 0); -- debug
      sp_oflo : out std_ulogic;
      pc      : out std_ulogic_vector(15 downto 0)  -- debug
      ); 
  end component;
  component v8_regs
    port(
      clk     : in  std_ulogic; -- everything clocks on rising edge
      write   : in  std_ulogic; -- write enable
      data_in : in  std_ulogic_vector(7 downto 0); -- data bus in
      addr_a  : in  std_ulogic_vector(3 downto 0); -- address for port A
      addr_b  : in  std_ulogic_vector(3 downto 0); -- address for port B
      data_a  : out std_ulogic_vector(7 downto 0); -- Port A out
      data_b  : out std_ulogic_vector(7 downto 0)  -- Port B out
      );
  end component;

  signal addr_a : std_ulogic_vector(3 downto 0);
  -- ADDR to the register file
  signal addr_b : std_ulogic_vector(3 downto 0);
  -- ADDR to the register file
  signal alu2op : std_ulogic_vector(2 downto 0);
  -- alu flags
  signal alu_ctl : std_ulogic_vector(13 downto 0);
  -- ALU control
  signal alu_out : std_ulogic_vector(7 downto 0);
  -- output of the ALU
  signal data_sel : std_ulogic_vector(1 downto 0);
  -- DATA mux select lines
  signal pcl : std_ulogic_vector(15 downto 0);
  -- Program Counter local version
  signal psrl : std_ulogic_vector(7 downto 0);
  -- local copy of the PSR
  signal rega : std_ulogic_vector(2 downto 0);
  -- REG field of the Instruction
  signal reg_wrt : std_ulogic;
  -- register file write enable
  signal regf_a,regf_b : std_ulogic_vector(7 downto 0);
  -- Register File outputs
  signal regb : std_ulogic_vector(2 downto 0);
  -- Register File b addr
  signal sp : std_ulogic_vector(15 downto 0);
  -- stack pointer
  signal addr_ctl : std_ulogic_vector(12 downto 0);
  -- address control
  signal addr_nxt : std_ulogic_vector(15 downto 0);
  -- address
  signal addr_dataout : std_ulogic_vector(7 downto 0);
  -- SP/DL to regf

begin   ------------------------------------------------------------

  -------------Create the DATAOUT mux ------------------------------
  dataout <= pcl(15 downto 8) when data_sel = "11" else  -- JSR and INT
             pcl(7 downto 0)  when data_sel = "10" else  -- JSR and INT
             psrl             when data_sel = "01" else  -- INT
             regf_b;                                     -- Store opcode

  -----------Create the ADDR mux-----------------------------------

  pc <= pcl;    -- drive the debugging port out

  u_v8_alu : v8_alu -----Create the ALU--------------------------------
    port map(
      clk       => clk,
      rst       => rst,
      datain    => addr_dataout,
      a_in      => regf_a,
      b_in      => regf_b,
      ctl       => alu_ctl,
      set_p     => set_p,
      clr_p     => clr_p,
      dcd       => regb,
      y_out     => alu_out,
      alu2op    => alu2op,
      psr       => psrl);
  psr <= psrl;  -- drive the local version out the port.

  u_v8_addr: v8_addr -------create the address generation unit -------
    port map(
      clk     => clk,
      rst     => rst,

	  clr_pc  => clr_pc,
      datain  => datain,
      vec     => rega,
      ctl     => addr_ctl,
      regf_a  => regf_a,
      regf_b  => regf_b,
      addr_nxt=> addr_nxt,
      dataout => addr_dataout,
      pc      => pcl,
      sp_oflo => sp_oflo,
      sp      => sp);

  addr_a <= psrl(3) & rega; -- use the other bank of regs
  addr_b <= psrl(3) & regb; -- when interrupt processing.

  u_v8_regs:v8_regs ----------Create the register file-------------------
    port map(
      clk     => clk,
      write   => reg_wrt,
      data_in => alu_out,
      addr_a  => addr_a,
      addr_b  => addr_b,
      data_a  => regf_a,
      data_b  => regf_b);

  u_op_dcd: op_dcd 
    port map(
      clk      => clk,
      rst      => rst,
      datain   => datain,
      int      => int,
      ready    => ready,
      op_ftch  => op_ftch,
      write    => write,
      read     => read,
      alu2op   => alu2op,
      alu_ctl  => alu_ctl,
      data_sel => data_sel,
      addr_ctl => addr_ctl,
      rega     => rega,
      reg_wrt  => reg_wrt,
      regb     => regb,
      -- debugging signals
      write_nxt=> write_nxt,
      opcde    => opcde,
      cycle    => cycle);

  addr_proc:process	---------------create pipeline registers
  begin
    wait until clk'event and clk='1';
    if (ready='1') then
      addr <= addr_nxt;		-- address is pipelined for speed
    end if;
  end process;

end rtl;
