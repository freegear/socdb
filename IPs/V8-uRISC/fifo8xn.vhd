--------------------------------------------------------------------------------
-- Copyright 1997 VAutomation Inc. Nashua NH (603) 882-2282 ALL RIGHTS RESERVED.
-- This software is provided under license and contains proprietary and
-- confidential material which is the property of VAutomation Inc.
--
-- Revision: $Name: REV9911b $
--
-- File: fifo8xn.vhd
-- Description:
-- 	This is an 8 by 2 to 16 byte FIFO core. Since it is so small, it is
-- 	built out of clock enabled DFFs. This results in more gates than using
--	a Dual Port RAM architecture, but it is much easier to synthesize.
--	The FIFO has a latency of DEPTH clocks where DEPTH is the depth of the
--	FIFO.
--
--	The constant DEPTH should be set to 2-16 and must be even. DEPTH could be
--	more than 16 but you'd be better off using a DPRAM.
--
--	Note that there is a seperate EMPTY and OUT_VALID flags. The FIFO can be
--	not EMPTY but OUT_VALID is low indicating that a byte has been loaded into
--	the FIFO but it's still rippling down the pipeline.
--
-- Signals ending in _n are active low.
-- Revision History
-- $Log: fifo8xn.vhd,v $
-- Revision 1.12  1999/11/10 15:25:21  gregg
-- Removed ^M's
--
-- Revision 1.11  1999/11/09 14:14:38  mark
-- ulogicified source - no functional changes
--
-- Revision 1.10  1998/11/20 15:22:22  chris
-- Changed synopsys comment placement so it would survive translation to verilog.
--
-- Revision 1.9  1998/11/17 21:42:34  chris
-- Fixed vasync marker comment on vauto_rst process.
--
-- Revision 1.8  1998/11/09 13:55:04  chris
-- Added gate on data_in to cut setup and hold checks when the fifo is not being loaded.
--
-- Revision 1.7  1998/06/15 22:08:38  chris
--  Added syntax for Async or Sync reset inference.
--
-- Revision 1.6  1998/04/24 14:18:58  eric
-- Verilog translation fixes.
--
-- Revision 1.5  1998/04/24  00:58:37  gregg
-- Added Synopsys reset attributes
--
-- Revision 1.4  1998/03/13 20:11:07  chris
-- Added Revision name.
--
-- Revision 1.3  1997/02/28 16:47:11  eric
-- Missed a term in the fifo load.
--
-- Revision 1.2  1997/02/28 15:13:27  eric
-- Unrolled the Generate statement.
--
-- Revision 1.1  1997/02/27 02:07:44  gregg
-- Initial revision
--
--------------------------------------------------------------------------------
--
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;	-- we use the IEEE standard 1164 logic types.
use ieee.numeric_std.all;

ENTITY fifo8xn IS	-----------------------------ENTITY---------------------
  PORT(clk	: IN  std_ulogic;	-- everything clocks on rising edge
       reset	: IN  std_ulogic;	-- reset active high
       load	: IN  std_ulogic;	-- write a byte
       unload	: IN  std_ulogic;	-- read a byte
       full	: OUT std_ulogic;	-- 1=FIFO is full
       full_1	: OUT std_ulogic;	-- 1=FIFO is almost full (1 byte free)
       empty	: OUT std_ulogic;	-- 1=FIFO is empty
       out_valid: OUT std_ulogic;	-- 1=DATA_OUT has valid data in it
       out_val_1: OUT std_ulogic;	-- 1=OUT_VALID 1 byte from the bottom
       data_in	: IN  std_ulogic_vector(7 DOWNTO 0); -- data bus in
       data_out	: OUT std_ulogic_vector(7 DOWNTO 0)); -- data bus in
END fifo8xn;

ARCHITECTURE synth OF fifo8xn IS

CONSTANT DEPTH	: integer := 4;	-- standard depth is 4 bytes.
-- NOTE! you cannot just change this CONSTANT to get a new depth!
-- See below...
type reg_type is array (1 to DEPTH) of std_ulogic_vector(7 downto 0);
SIGNAL flops	: reg_type;
SIGNAL full_local, empty_local : std_ulogic;
SIGNAL valid : std_ulogic_vector(1 to DEPTH);

-- Requires the sync_set/reset attribute to insure no Xes in simulation
-- The following line is used when translating to Verilog...
-- synopsys sync_set_reset "reset"

attribute sync_set_reset : string;  -- Required for Synopsys
attribute sync_set_reset of reset : signal is "true";  -- Required for synopsys

BEGIN

-- This was originally done with a FOR-GENERATE loop but it's easier
-- to do unrolled. Translates to verilog easier too...
-- But if you want to expand the size of the FIFO, you have to
-- duplicate sections in the obvious manner.

----- Create the registers (with load enable)-----
--vasync_rst vauto_rst : PROCESS (clk,reset)
vauto_rst:PROCESS (clk) --vsync_rst
BEGIN
--vasync_rst  if reset = '1' then
if clk'event AND clk='1' then --vsync_rst
  if reset = '1' then --vsync_rst
    valid(1) <= '0';
    valid(2) <= '0';
    valid(3) <= '0';
    valid(4) <= '0';
    -- the data registers are not reset, but clear out in 4 clocks
    -- if the valid bit are cleared.
  else --vsync_rst
--vasync_rst   elsif clk'event and clk = '1' then

    if (unload='1' OR 	----FIFO register 1
	-- always load the register with data_in when we unload or on reset
	-- or when there is room further on in the fifo.
	valid(1)='0' OR valid(1+1)='0' OR valid(2+1)='0' OR valid(3+1)='0') then
	-- the term above must be expanded if the depth is increased.
      -- gate the input to the first register, so that X will not be propogated.
      if load = '1' THEN
        flops(1) <= data_in;
      else
        flops(1) <= (OTHERS => '0');
      end if;
      valid(1) <= load;
    else
      flops(1) <= flops(1);
      valid(1) <= valid(1);
    end if;
    if (unload='1' OR 	---- FIFO register 2
	valid(2)='0' OR                   valid(2+1)='0' OR valid(3+1)='0') then
      flops(2) <= flops(2-1);
      valid(2) <= valid(2-1);
    else
      flops(2) <= flops(2);
      valid(2) <= valid(2);
    end if;
    if (unload='1' OR 	---- FIFO register 3
	valid(3)='0' OR                                     valid(3+1)='0') then
      flops(3) <= flops(3-1);
      valid(3) <= valid(3-1);
    else
      flops(3) <= flops(3);
      valid(3) <= valid(3);
    end if;
    if (unload='1' OR  valid(4)='0') then 	---- FIFO register 4
      flops(4) <= flops(4-1);
      valid(4) <= valid(4-1);
    else
      flops(4) <= flops(4);
      valid(4) <= valid(4);
    end if;
  end if; -- reset  --vsync_rst
end if; -- clk / reset
END PROCESS vauto_rst;


data_out <= flops(DEPTH);
out_valid <= valid(DEPTH);

full <= valid(1) AND valid(2) AND valid(3) AND valid(4);
-- full_1 indicates that there is only 1  byte available in the fifo and
-- you probably need to stop the DMA.
full_1 <= (    valid(1) AND     valid(2) AND     valid(3) AND NOT valid(4)) OR
          (    valid(1) AND     valid(2) AND NOT valid(3) AND     valid(4)) OR
          (    valid(1) AND NOT valid(2) AND     valid(3) AND     valid(4)) OR
          (NOT valid(1) AND     valid(2) AND     valid(3) AND     valid(4));

empty <= NOT (valid(1) OR valid(2) OR valid(3) OR valid(4));
out_val_1 <= valid(DEPTH-1);
-- out_val_1 indicates that there is only 1 byte left in the fifo (if out_valid
-- is 1) and it is probably time to stop the DMA.

END synth;
