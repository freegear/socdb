----------------------------------------------------------------------
-- Copyright 1995-1998 VAutomation Inc. Nashua NH USA. ALL RIGHTS
-- RESERVED. This software is provided under license and contains
-- proprietary and confidential material which is the property of
-- VAutomation Inc.
--
-- File: v8_regs.vhd
-- Description:
--      This is the 16x8 dual port (2 read, 1 write) register file for
--      the V8 microprocessor.
-- 	Note that in this implementation there are actually 2 banks of 
--	8x8 registers. One for regular computing and one for interrupts.
--	The second bank significantly reduces the interrupt latency as
--	registers don't have to be pushed on the stack.
-- 
--	Two different architectures are provided. 

-- 1) The rtl architecture can be synthesized into a bank of DFFs
-- and muxes. While somewhat expensive in gates, this architecture is
-- recommended for ASICs as it is easy to use. Gates can be saved by
-- using a synchronous dual port RAM with charateristics similar to the
-- Xilinx RAMD cell.
-- 2) The xilinx architecture is optimized for Xilinx FPGAs and uses
-- the xilinx RAMD primitive.
--


--------------Revision History---------------------------------------
-- $Log: v8_regs.vhd,v $
-- Revision 1.8  1999/12/16 16:58:23  mark
-- * removed 'type regtype' use of integer range <>.  This
--   won't translate into Verilog.  Replaced with '0 to 15'.
--
-- Revision 1.7  1999/09/10 01:29:17  eric
-- Just changed the architecture to RTL to match the RMM.
--
-- Revision 1.6  1999/08/25 20:33:23  scott
-- Modified the code to use std_ulogic(_vector) and
-- IEEE numeric_std package and shorten code width
--
-- Revision 1.5  1999/03/31 22:03:14  eric
-- Improved codign style for Verilog translation.
--
-- Revision 1.4  1998/04/22 15:55:05  eric
-- Removed the xrm16x8.vhd submodule.
--
-- Revision 1.3  1996/12/23  17:58:56  eric
-- BETA Revision 0.9 release
--
-- Revision 1.2  1996/11/11  15:08:49  eric
-- Changed the heirarchy so the simulation database is under the
-- Xilinx compatible RAM.
--
-- Revision 1.1  1995/11/24  18:29:43  eric
-- Initial revision
--
---------------------------------------------------------------------
--
library ieee;
use ieee.std_logic_1164.all; -- use the IEEE standard 1164 logic types.
use ieee.numeric_std.all;

entity v8_regs is	-----------------------------ENTITY----------
  port(
    clk     : in  std_ulogic; -- everything clocks on rising edge

    addr_a  : in  std_ulogic_vector(3 downto 0); -- address for port A
    addr_b  : in  std_ulogic_vector(3 downto 0); -- address for port B
    data_in : in  std_ulogic_vector(7 downto 0); -- data bus in
    write   : in  std_ulogic; -- write enable

    data_a  : out std_ulogic_vector(7 downto 0); -- Port A out
    data_b  : out std_ulogic_vector(7 downto 0)  -- Port B out
    );
end v8_regs;

architecture rtl of v8_regs is ------------ Architecture synth -----

-- Define a Type for the register file
  type reg_type is array (0 to 15)
    of std_ulogic_vector(7 downto 0);
  signal regfile : reg_type;

  signal reg_load : std_ulogic_vector(15 downto 0);
begin

  G1: for i in 0 to 15 generate
    regs:process(clk) ----- Create the registers (with load enable)-----
    begin
      if (clk'event and clk='1') then
        if (reg_load(i)='1') then
          regfile(i) <= data_in;
          -- create 16 banks of 8 bit clock enabled registers
        end if;
      end if;
    end process;
  end generate;

  G2: for i in 0 to 15 generate	-- create the 15 register clock enables
    reg_load(i) <= write when to_integer(unsigned(addr_a)) = i
                   else '0';
  end generate;

  data_a <= regfile(to_integer(unsigned(addr_a))); -- read muxes

  data_b <= regfile(to_integer(unsigned(addr_b))); -- read muxes

end rtl;

--architecture xilinx of v8_regs is ---------- Architecture Xilinx ----
--
--  -- The XILINX architecture is optimal for Xilinx XC4000 FPGA
--  -- families as the register file is built out of dual port RAMs.
--  -- This requires only 8 CLBs compared to over 64 CLBs if you
--  -- synthesize the rtl architecture into xilinx fpgas. When
--  -- synthesizing, you may need to dont_touch or noopt the RAMD cell.
--
--  component RAM16X1D
--    port(
--      SPO   : out std_ulogic;
--      DPO   : out std_ulogic;
--      A0    : in  std_ulogic;
--      A1    : in  std_ulogic;
--      A2    : in  std_ulogic;
--      A3    : in  std_ulogic;
--      WE    : in  std_ulogic;
--      D     : in  std_ulogic;
--      WCLK  : in  std_ulogic;
--      DPRA0 : in  std_ulogic;
--      DPRA1 : in  std_ulogic;
--      DPRA2 : in  std_ulogic;
--      DPRA3 : in  std_ulogic
--      );
--  end component;
--begin
--  G1: for i in 0 to 7 generate
--    -- The RAM16X1D cell is a basic cell in Xilinx. There is a
--    -- simulation model in xil_io.vhd
--    DPRAM : RAM16X1D
--      port map(
--        SPO   => data_a(i),
--        DPO   => data_b(i),
--        A0    => addr_a(0),
--        A1    => addr_a(1),
--        A2    => addr_a(2),
--        A3    => addr_a(3),
--        WE    => write,
--        D     => data_in(i),
--        WCLK  => clk,
--        DPRA0 => addr_b(0),
--        DPRA1 => addr_b(1),
--        DPRA2 => addr_b(2),
--        DPRA3 => addr_b(3)
--        );
--  end generate;
--end xilinx;
