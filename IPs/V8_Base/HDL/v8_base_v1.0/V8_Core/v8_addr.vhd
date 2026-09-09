----------------------------------------------------------------------
-- Copyright 1997 VAutomation Inc. Nashua NH (603) 882-2282 ALL RIGHTS
-- RESERVED. This software is provided under license and contains
-- proprietary and confidential material which is the property of
-- VAutomation Inc.
--
-- File: v8_addr.vhd
-- Revision: $Name: REV9910 $
-- Description:
--      Address Generation Unit for the V8 uRISC microprocesor
--
-- Address sources are: Program Counter, Stack Pointer, indexed and
-- absolute addressing modes.
--
--  Operations performed are:
--  ADDR = PC [+1]      - normal program opcode fetches
--         {PCH[+-1],PCL+DL}    - Relative Branch calculations
--         SP [+-1]     - Stack accesses (overlaps with PC incrementing)
--         {DH,DL}      - Absolute addressing
--         {REGB,REGA}  - Indexed addressing
--         {REGB[+1],REGA+DL}   - Indexed offset addressing
--
-- The size of the stack can be selected by changing the SP_LENGTH 
-- constant define below.
--
-- CTL bus definitions:
-- 0 = update PC
-- 1 = load PCH from DATAIN
-- 2 = load PCH from interrupt vector
-- 3 = Load SP from the reg file - XSP
-- 4 = load DL from datain
-- 5 = offset addressing computations
-- 6 = Indexed addressing computations
-- 7 = absolute addressing computations
-- 8 = branch computations
-- 9 = increment the low 8 bits
-- 10= select the stack register onto the addr bus
-- 11= stack dec, both dec and inc=1 indicates a reset
-- 12= stack inc
-- Signals ending in _n are active low.
--------------Revision History---------------------------------------
-- $Log: v8_addr.vhd,v $
-- Revision 1.11  1999/09/13 19:20:52  eric
-- Added the SP_OFLO stack overflow indicator.
-- More RMM cleanups too.
--
-- Revision 1.10  1999/08/25 18:48:32  scott
-- Modified the code to use std_ulogic(_vector) and
-- IEEE numeric_std package and shorten code width
--
-- Revision 1.9  1999/01/29 02:00:02  eric
-- The STACK_D signal MUST also be shortened to the desired length
-- otherwise when the stack pointer wraps, a push to the stack will
-- write to the wrong address (IE: 0x2FF instead of 0x3FF with an 8 bit
-- stack with the upper 8 bits always 03).
--
-- Revision 1.8  1999/01/26 13:25:26  eric
-- Changed RSP to XSP.
--
-- Revision 1.7  1998/11/20 14:33:50  eric
-- Just fixed a few comments so synopsys doesn't think they're PRAGMAS.
--
-- Revision 1.6  1998/11/19 02:13:18  eric
-- Reverted back to the simple ripple adder as it is just about as fast.
--
-- Revision 1.5  1998/10/22 17:04:49  eric
-- Changed one of the adders to have Synopsys attributes for a CLA
-- adder. This adder is often in the critical path and the CLA will
-- result in a slightly faster implementation.
--
-- Revision 1.4  1998/02/18 23:35:34  eric
-- Added the RSP opcode required for the C compiler.
--
-- Revision 1.3  1997/11/07 17:18:53  eric
-- moved stack back to page 3.
--
-- Revision 1.2  1997/10/24 17:31:02  eric
-- cleanups for verilog and timing improvements.
--
-- Revision 1.1  1997/06/27 18:47:03  eric
-- Initial revision
----------------------------------------------------------------------
--
library ieee;
use ieee.std_logic_1164.all; -- use the IEEE standard 1164 logic types.
use ieee.numeric_std.all;	-- + and - operators

entity v8_addr is       -----------------------------ENTITY-----------
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
    pc      : out std_ulogic_vector(15 downto 0); -- debug only
    sp      : out std_ulogic_vector(15 downto 0); -- debug only
    sp_oflo : out std_ulogic -- stack pointer overflow
    );
end v8_addr;

architecture rtl of v8_addr is ----------Architecture ----------

  attribute sync_set_reset : string;      -- required for synopsys
  attribute sync_set_reset of rst : signal is "true";
  -- required for synopsys
  --
  -- The following line is used when translating to Verilog...
  -- synopsys sync_set_reset "rst"

  signal abs_addr : std_ulogic;
  -- absolute address computation in progress
  signal add_a,add_b,add_out : std_ulogic_vector(8 downto 0); -- adder
  signal branch : std_ulogic; -- Branch opcode being executed
  signal d_lo : std_ulogic_vector(7 downto 0); -- DL and DH registers
  signal dec_hi,inc_hi : std_ulogic; -- control signals
  signal hi_in,hi_sum : std_ulogic_vector(7 downto 0);
  -- 8 bit inc/dec datapaths
  signal index_addr : std_ulogic;
  -- indexed address computation in progress
  signal inc_lo : std_ulogic; -- increment low 8 bits
  signal offset_addr : std_ulogic;
  -- offset address computation in progress
  signal pc_hi,pc_hi_nxt,pc_lo,pc_lo_nxt : std_ulogic_vector(7 downto 0);
  -- Program counter
  signal sel_sp, sp_dec, sp_inc : std_ulogic; -- stack control signals
  -- stack pointers
  signal stack_reg : std_ulogic_vector(15 downto 0);
  signal stack : std_ulogic_vector(15 downto 0);
  signal stack_dec : std_ulogic_vector(15 downto 0);
  signal stack_inc : std_ulogic_vector(15 downto 0);
  signal stack_incdec : std_ulogic_vector(15 downto 0);
  signal stack_new : std_ulogic_vector(15 downto 0);
  signal stack_nxt : std_ulogic_vector(15 downto 0);
  signal stack_nxt_nxt: std_ulogic_vector(15 downto 0);
  signal stack_pre : std_ulogic_vector(15 downto 0);
  signal stack_xsp : std_ulogic_vector(15 downto 0);

  CONSTANT ZERO : std_ulogic_vector(15 downto 0) := "0000000000000000";

  -- The INTERRUPT_VECTOR constant is how you define where you want the
  -- interrupt vectors to live in memory. Typically they are placed at
  -- 0x2000.
  constant INTERRUPT_VECTOR : std_ulogic_vector(15 downto 0) := 
    --CONV_std_ulogic_VECTOR(16#2000#,16); -- must be even
    --CONV_std_ulogic_VECTOR(16#0400#,16); -- must be even
    std_ulogic_vector(to_unsigned(16#0400#,16)); -- must be even

  -- The STACK_INIT constant determines the value of the STACK pointer
  -- when reset is asserted
  constant STACK_INIT : std_ulogic_vector(15 downto 0) := 
    --CONV_std_ulogic_VECTOR(16#03ff#,16);
    std_ulogic_vector(to_unsigned(16#03ff#,16));

  -- The number of bits in the stack pointer is defined with the 
  -- following constant. It must be set to a value from 1 to 15.
  -- The default value of 8 provides an 8-bit stack pointer where
  -- bits (15:8) are fixed at the STACK_INIT value and (7:0)
  -- are a counter. Note that a full 16 bit stack pointer can be
  -- built but it requires changes to the source code itself.
  constant SP_LENGTH : integer := 8;

begin   --------------------------------------------------------------

  -- break out the control bus into meaningful names
  offset_addr   <= ctl(5);
  index_addr    <= ctl(6);
  abs_addr      <= ctl(7);
  branch        <= ctl(8);
  inc_lo        <= ctl(9);
  sel_sp        <= ctl(10);
  sp_dec        <= ctl(11);
  sp_inc        <= ctl(12);

  sp <= stack;  -- drive the debug port
  pc <= pc_hi & pc_lo;  -- drive the debug port

  dataout <=   d_lo;

  -- 2:1 mux for the SP and other address sources
  addr_nxt <= stack_nxt when sel_sp='1' -- output stack pointer
            else pc_hi_nxt & pc_lo_nxt;

  -------low adder and muxes on the inputs-----------------
  add_a <= "000000000" when abs_addr='1'
           else '0' & regf_a when index_addr='1' or offset_addr='1'
           else '0' & pc_lo;

  add_b <= '0' & d_lo when branch='1' or offset_addr='1' or abs_addr='1'
           else "000000001" when inc_lo='1'
           else "000000000";

  -- The following lines show two different ways to implement an
  -- adder. The following line is by far the simplest and works for
  -- any synthesizer.
  add_out <= std_ulogic_vector(unsigned(add_a) + unsigned(add_b));

  -- 9 bit adder (bit 9=carry) The following process and all of the
  -- various attributes will force synopsys (9808) to use a
  -- carry-look-ahead adder instead of a ripple carry adder. This
  -- adder is often in the critical path so a carry look-ahead will
  -- reduce the total delay time. Synopsys generally will decide to
  -- switch to a CLA adder if given a tight timing spec, however it
  -- often requires several hours of CPU time before it switches. This
  -- version is commented out however because generally a 9 bit ripple
  -- adder is just about as fast as a CLA adder.

  --cla_adder: process (add_a, add_b)
  -- subtype resource is integer; 
  -- attribute ops : string; 
  -- attribute map_to_module : string; 
  -- attribute implementation : string; 
  -- constant r0 : resource := 0;
  -- attribute ops of r0 : constant is "A1";
  -- attribute map_to_module of r0 : constant is "DW01_add";
  -- attribute implementation of r0 : constant is "cla";
  --begin
  --  add_out <= UNSIGNED(add_a) + UNSIGNED(add_b); -- pragma label A1
  --  -- don't put () around the equation or synopsys
  --  -- won't recognize the pragma
  --  -- 9 bit adder
  --end process;  ---------End of carry-look-ahead adder--------

  pc_lo_nxt <= "00000000" when clr_pc='1'  -- remote restart
	         else INTERRUPT_VECTOR(7 downto 4) & vec & '0' when 
             ctl(2)='1' -- interrupt vector
             else add_out(7 downto 0);

  -- decrement the upper 8 bits on a negative branch that crosses a page
  dec_hi <= not add_out(8) and branch and d_lo(7);
  -- increment the upper 8 bits when carry from the low 8 bits unless we
  -- are doing a negative branch.
  inc_hi <= add_out(8) and (not branch or not (branch and d_lo(7)));

  -- 2:1 mux in front of incrementer/decrementer
  hi_in <= regf_b when index_addr='1' or offset_addr='1'
           -- indexed/offset addressing
           else pc_hi;

  -- incrementer/decrementer
  hi_sum <= std_ulogic_vector(unsigned(hi_in) - 1) when dec_hi='1'
            else std_ulogic_vector(unsigned(hi_in) + 1) when inc_hi='1'
            else hi_in;        

  -- 3:1 mux in front of the upper 8 bits of the PC
  pc_hi_nxt <= "00000000" when clr_pc='1'  -- remote restart
	         else INTERRUPT_VECTOR(15 downto 8) when ctl(2)='1'
             -- interrupt vector
             else datain   when ctl(1)='1' or abs_addr='1'
             -- load from data bus
             else hi_sum; -- Branch or inc

  pc_proc:process(clk) -- create the flops for the PC.
  begin
    if (clk'event and clk='1') then
      if (rst='1') then -- at reset we begin executing from zero
        pc_lo <= "00000000"; -- Coding style insures sync reset FFs
        pc_hi <= "00000000";
      elsif(clr_pc='1') then -- remote restart
        pc_lo <= "00000000";
        pc_hi <= "00000000";
      elsif (ctl(0)='1') then -- update the PC
        pc_lo <= pc_lo_nxt;
        pc_hi <= pc_hi_nxt;
      end if;
    end if;
  end process;

  d_lo_proc:process(clk)
  begin
    if(clk'event and clk='1') then
      if (ctl(4)='1') then
        if (ctl(3)='1' and sp_inc='1') then
          d_lo <= stack(15 downto 8);   -- XSP only
        elsif (ctl(3)='1' and sp_dec='1') then
          d_lo <= stack(7 downto 0);    -- XSP only
        else
          d_lo <= datain;
        end if;
      end if;
    end if;
  end process;

  -------------------Stack pointer logic-------------------------------
  -- Note that since we need to output the address of the next clock,
  -- we actually need to compute the SP in 2 clocks. We can do this
  -- because stack operations take several clocks anyway.
  -- Below is a 5:1 mux which is broken up to make sure we don't
  -- end up with a priority encoder.
  -- Starting from the output of the mux and working to the source...
  -- the last stage selects either the current value or the new
  stack_nxt_nxt <= stack_new when (sp_dec='1' or sp_inc='1') else stack;

  -- next is the mux for XSP and the INC DEC
  stack_new <= stack_xsp when ctl(3)='1' else
	stack_incdec;
  -- and finally the last 2:1 muxes
  stack_xsp <= stack(15 downto 8) & regf_a when sp_dec='1' else
        regf_a & stack(7 downto 0);
  stack_incdec <= 
    stack_init(15 downto SP_LENGTH) & 
     stack_inc(SP_LENGTH-1 downto 0) when sp_inc='1' else
    stack_init(15 downto SP_LENGTH) & 
	stack_dec(SP_LENGTH-1 downto 0);

  stack_inc <= std_ulogic_vector(unsigned(stack_pre) + 1);
  stack_dec <= std_ulogic_vector(unsigned(stack_pre) - 1);
  stack_pre <= ZERO(15 downto SP_LENGTH) & stack(SP_LENGTH-1 downto 0);

  sp_oflo <= NOT ctl(3) and (	-- ignore XSP operations
       (stack_inc(SP_LENGTH) AND sp_inc) -- signal a stack overflow
	OR (stack_dec(SP_LENGTH) AND sp_dec));

  sp_proc:process(clk)
  begin
    if (clk'event and clk='1') then
      if (rst='1') then       -- synchronous set/clear
        stack_reg <= STACK_INIT;
      elsif (clr_pc='1') then  -- remote restart
	    stack_reg <= STACK_INIT;
	  else
        stack_reg <= stack_nxt_nxt;
      end if;
    end if;
  end process;

  -- Note that making the SP more than 15 bits is a bit difficult
  -- and requires actually changing the constructs below.
  stack <= stack_init(15 downto SP_LENGTH) & 
	   stack_reg(SP_LENGTH-1 downto 0);

  stack_nxt <= stack_init(15 downto SP_LENGTH) & 
	       stack_nxt_nxt(SP_LENGTH-1 downto 0); 

  -- The synthesizer should remove all of the logic associated with the
  -- upper bits of the stack that are not used.

end rtl;
