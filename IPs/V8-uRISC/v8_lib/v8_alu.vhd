----------------------------------------------------------------------
-- Copyright 1995 VAutomation Inc. Nashua NH (603) 882-2282 ALL RIGHTS
-- RESERVED. This software is provided under license and contains
-- proprietary and confidential material which is the property of
-- VAutomation Inc. HTTP://www.vautomation.com
--
-- File: v8_alu.vhd
-- Revision: $Name: REV9910 $
-- Description:
--      This is the Arithmetic Logic Unit for the V8 uProcessor
--
-- The Processor Status Register (PSR) is located here.
-- PSR(0) = Zero flag
-- PSR(1) = Carry flag
-- PSR(2) = Negative flag
-- PSR(3) = Interrupt Mask bit
-- PSR(4) = flag4
-- PSR(5) = flag5
-- PSR(6) = flag6
-- PSR(7) = flag7
-- 
-- CTL bus definitions:
--   CTL[2:0]   = selects the mode:
--              00x = add
--              01x = OR
--              100 = AND
--              101 = XOR
--              110 = Rotate left
--              111 = Rotate right
--   CTL[3]     = Use the decoder value instead of b_in
--   CTL[4]     = Invert the input to the B side of the ALU (subtract)
--   CTL[5]     = B side of alu is zero
--   CTL[6]     = Use PSR[2] for carry in else ctl(7)
--   CTL[7]     = Carry in
--   CTL[9:8]   = ALU A select
--              00 = A_IN
--              01 = DATAIN
--              10 = PSR
--              11 = ZERO
--   CTL[10]    = Update the C bit (PSR(1))
--   CTL[11]    = Update the N&Z bits (PSR(3),PSR(0))
--   CTL[12]    = load the entire PSR from alu_out
--   CTL[13]    = Set the I bit (PSR(3))
--
-- Crude block diagram:
--
-- Signals ending in _n are active low.
---------------------------------------------------------------------
---Revision History--------------------------------------------------
-- $Log: v8_alu.vhd,v $
-- Revision 1.9  1999/09/13 19:20:30  eric
-- Just a few more RMM cleanups - no logic changes.
--
-- Revision 1.8  1999/08/25 18:56:13  scott
-- Modified the code to use std_ulogic(_vector) and
-- IEEE numeric_std package and shorten code width
--
-- Revision 1.7  1998/07/02 22:02:18  eric
-- added Synopsys attributes
--
-- Revision 1.6  1997/10/24  17:31:02  eric
-- cleanups for verilog and timing improvements.
--
-- Revision 1.5  1996/12/23 17:59:40  eric
-- BETA Revision 0.9 release
--
-- Revision 1.4  1996/11/12  18:07:08  eric
-- Fixed I bit of PSR which was not being set during reset (OP_DCD
-- does it).
--
-- Revision 1.1  1995/11/24  18:29:26  eric
-- Initial revision
----------------------------------------------------------------------
--
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity v8_alu is        -----------------------------ENTITY-----------
  port(
    clk    : in  std_ulogic; -- everything clocks on rising edge
    rst    : in  std_ulogic; -- reset

    a_in   : in  std_ulogic_vector(7 downto 0);  -- A port
    b_in   : in  std_ulogic_vector(7 downto 0);  -- B port
    clr_p  : in  std_ulogic_vector(7 downto 4);  -- PSR flag bit clear
    ctl    : in  std_ulogic_vector(13 downto 0);  -- control
    datain : in  std_ulogic_vector(7 downto 0);  -- data in
    dcd    : in  std_ulogic_vector(2 downto 0);  -- decode value
    set_p  : in  std_ulogic_vector(7 downto 4);  -- PSR flag bit set

    alu2op : out std_ulogic_vector(2 downto 0);  -- ALU flags
    y_out  : out std_ulogic_vector(7 downto 0);  -- ALU out port
    -- debugging signals
    psr    : out std_ulogic_vector(7 downto 0)  -- Flags register
    );
end v8_alu;

architecture rtl of v8_alu is ---------Architecture -----------

  signal alu_a, alu_b, decode, alu_out : std_ulogic_vector(7 downto 0);
  signal alu_control : std_ulogic_vector(2 downto 0);
  signal adder_out : std_ulogic_vector(9 downto 0);
  signal adder_a, adder_b : std_ulogic_vector(9 downto 0);
  signal b_in_decode_mux : std_ulogic_vector(7 downto 0);
  signal b_in_zero_mux : std_ulogic_vector(7 downto 0);
  signal carry_in, add_carry_out, carry_out : std_ulogic;
  signal psr_reg,psr_reg_d : std_ulogic_vector(7 downto 0);

  attribute sync_set_reset : string; -- required for synopsys
  attribute sync_set_reset of rst : signal is "true";
  -- required for synopsys

  signal zero_flag : std_ulogic;
  constant zero_byte : std_ulogic_vector(7 downto 0) := "00000000";

  -- The following line is used when translating to Verilog...
  -- synopsys sync_set_reset "rst"

  constant Xes : std_ulogic_vector(7 downto 0) := "XXXXXXXX";

begin   ------------------------------------------------------------

  -- break out the control lines into more meaningfull names
  alu_control   <= ctl(2 downto 0);

  psr <= psr_reg;       -- drive the port

  y_out <= alu_out;     -- drive the port with the results

  alu2op <= carry_out & psr_reg(3) & zero_flag; -- drive the port

  -- carry in mux select. Use the PSR or the value from the OP_DCD
  carry_in <= psr_reg(1) when ctl(6)='1' else ctl(7);
  -- use PSR(1) or not carry out is the adder or the bit when doing a
  -- rotate
  carry_out <= alu_a(7) when alu_control="110" else 
               alu_a(0) when alu_control="111" else 
               add_carry_out;

  zero_flag <= '1' when alu_out = "00000000" else '0';

  alu_a <= a_in         when ctl(9 downto 8) = "00"
           else datain  when ctl(9 downto 8) = "01"
           else psr_reg when ctl(9 downto 8) = "10"
           else zero_byte;

  b_in_decode_mux <= decode when ctl(3)='1' else b_in;
  b_in_zero_mux <= zero_byte when ctl(5)='1' else b_in_decode_mux;
  alu_b <= not b_in_zero_mux when ctl(4)='1' else b_in_zero_mux;

  with dcd select
    decode <= -- 3 to 8 line decoder
      "00000001" when "000",
      "00000010" when "001",
      "00000100" when "010",
      "00001000" when "011",
      "00010000" when "100",
      "00100000" when "101",
      "01000000" when "110",
      "10000000" when "111",
      "XXXXXXXX" when others;

  ---------------------------------------------------------------
  -- Create the adder. The trick here is to get the synthesizer to
  -- recognize that we want an adder with carry in and out and to use
  -- module generation (DesignWare in synopsys) for an efficient and
  -- fast adder. We do this trick by adding 2 bits to the vectors, 1 bit
  -- at the LSB for the carry in and 1 bit at the top for the carry out.
  adder_a <= '0' & alu_a & '1';
  adder_b <= '0' & alu_b & carry_in;
  adder_out <= std_ulogic_vector(unsigned(adder_a) + unsigned(adder_b));
  -- adder with carry in and out
  add_carry_out <= adder_out(9);

  -------- create the Logical part of the ALU here -----------------
  alu_proc:process(alu_a, alu_b, adder_out, carry_in, alu_control)
  begin
    case alu_control is
      when "000" => alu_out <= adder_out(8 downto 1);
      when "001" => alu_out <= adder_out(8 downto 1);
      when "010" => alu_out <= alu_a or  alu_b;
      when "011" => alu_out <= alu_a or  alu_b;
      when "100" => alu_out <= alu_a and alu_b;
      when "101" => alu_out <= alu_a xor alu_b;
      when "110" => alu_out <= alu_a(6 downto 0) & carry_in;
      when "111" => alu_out <= carry_in & alu_a(7 downto 1);
      when others=> alu_out <= Xes;
    end case;
  end process;

  --------------Create the Processor Status Word----------------------
  -- Each bit has it's own special conditions so they are each created
  -- seperately.
  psr_reg_d(0) <= zero_flag when ctl(11)='1' else       -- Zero Flag
                  alu_out(0) when ctl(12)='1' else
                  psr_reg(0);
  psr_reg_d(1) <= carry_out when ctl(10)='1' else -- Carry Flag
                  alu_out(1) when ctl(12)='1' else
                  psr_reg(1);
  psr_reg_d(2) <= alu_out(7) when ctl(11)='1' else -- Negative Flag
                  alu_out(2) when ctl(12)='1' else
                  psr_reg(2);
  psr_reg_d(3) <= '1' when ctl(13)='1' else -- Interrupt Mask
                  alu_out(3) when ctl(12)='1' else
                  psr_reg(3);
  psr_reg_d(4) <= '0' when clr_p(4)='1' else -- FLAG 4
                  '1' when set_p(4)='1' else
                  alu_out(4) when ctl(12)='1' else
                  psr_reg(4);
  psr_reg_d(5) <= '0' when clr_p(5)='1' else -- FLAG 5
                  '1' when set_p(5)='1' else
                  alu_out(5) when ctl(12)='1' else
                  psr_reg(5);
  psr_reg_d(6) <= '0' when clr_p(6)='1' else -- FLAG 6
                  '1' when set_p(6)='1' else
                  alu_out(6) when ctl(12)='1' else
                  psr_reg(6);
  psr_reg_d(7) <= '0' when clr_p(7)='1' else -- FLAG 7
                  '1' when set_p(7)='1' else
                  alu_out(7) when ctl(12)='1' else
                  psr_reg(7);

  vauto_proc: process(clk)   -- create the PSR register here
  begin
    if (clk'event and clk='1') then
      if (rst='1') then
        psr_reg <= "00001000"; -- sync set/reset
      else
        psr_reg <= psr_reg_d;
      end if;
    end if;
  end process;

end rtl;
