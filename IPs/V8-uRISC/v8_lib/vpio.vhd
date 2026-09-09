--------------------------------------------------------------------------------
-- Copyright 1997-1998 VAutomation Inc. Nashua NH HTTP://WWW.VAutomation.com 
-- ALL RIGHTS RESERVED.
-- This software is provided under license and contains proprietary and
-- confidential material which is the property of VAutomation Inc.
--
-- File: vpio.vhd
-- Revision: $Name: REV9910 $
-- Gate Count:  about 400 gates
-- Description:
--      Simple 8 bit programmable parallel IO port
--      The CPU interface is fully synchronous. The control signals are
--      active high and are expected to be active for only 1 CLK.
--      Tristate IO cells are expected to be added in a module above this one.
--      An example of how to connect these is shown below.
--
-- Register Definition:
-- addr Name    R/W     Description
--  0   DataIN  R       Data IN register
--  0   DataOUT W       Data OUT register
--  1   DATADIR R/W     Data direction register.
--                      1=Tristate driver is enabled (driving out)
--                      0=Tristate driver is off (input only)
--
-- 
-- Block Diagram:
--
--                  +-----------+           PORT_ENB  |       IO cells which
--  DATAIN>----8-+--> DATADIR   >-8----+--------------------+ must be connected
--  CHIP_SEL>+---|-->           |      |              |     | External to this
--  WRITE   >&   |  +-----------+      |                  |\| Module.
--  ADDR    >+-+ |  +-----------+      |    PORT_OUT  |   | \
--             | +--> DATA      >-8----|------------------>  >---+
--             +---->           |      |              |   | /    |
--                  +-----------+      |                  |/     | PORT[7:0]
--                                     |              |          +<--->
--                        _            |                    /|   |
--                       / |           |    PORT_IN   |    / |   |
--                      /  <-----------|------------------<  <---+
--  DATAOUT<-------8---<   |           |              |    \ |   
--                      \  <-----------+                    \|
--                       \_|                          |


--------------------------------------------------------------------------------
-- Revision History
-- $Log: vpio.vhd,v $
-- Revision 1.6  1999/10/07 19:43:56  mark
-- removed blank lines in entity to allow vhdl2v conversion
--
-- Revision 1.5  1999/09/13 20:59:35  eric
-- no logic changes - RMM style updates.
--
-- Revision 1.4  1999/08/24 20:09:10  scott
-- Modified the code to use std_ulogic(_vector) and IEEE numeric_std package
--
-- Revision 1.3  1999/04/20 21:26:36  mark
-- added 'empty' architecture
--
-- Revision 1.2  1998/04/23 01:31:01  eric
-- Minor fix for verilog translation.
--
-- Revision 1.1  1997/10/21 19:06:15  eric
-- Initial revision
--
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity vpio is
  port (
    clk         : in  std_ulogic;                     -- clock input
    rst         : in  std_ulogic;                     -- reset
    addr        : in  std_ulogic;                         -- address
    chip_sel    : in  std_ulogic;                     -- Chip select 
    datain      : in  std_ulogic_vector(7 downto 0);  -- DATA bus in
    port_in     : in  std_ulogic_vector(7 downto 0);  -- IO Port in
    write       : in  std_ulogic;                     -- uP write 
    dataout     : out std_ulogic_vector(7 downto 0);  -- DATA bus out
    port_out    : out std_ulogic_vector(7 downto 0);  -- IO Port out
    port_enb    : out std_ulogic_vector(7 downto 0)); -- IO Port tristate enb
end vpio;

architecture empty of vpio is
begin
  dataout <= (others => '0');
  port_out <= (others => '0');
  port_enb <= (others => '0');
end empty;


architecture rtl of vpio is
  signal datadir,data   : std_ulogic_vector(7 downto 0); -- registers

begin

  gjr:process(clk)      ------Create the registers-------------------
  begin
    if (clk'event and clk='1') then
      if (rst='1') then       
        datadir <= "00000000";          -- synchronous reset
      elsif (chip_sel='1' and write='1' and addr='1')  then -- load
        datadir <= datain;
      else
        datadir <= datadir;
      end if;

      if (rst='1') then                       -- synchronous reset
        data <= "00000000";
      elsif (chip_sel='1' and write='1' and addr='0')  then -- load
        data <= datain;
      else
        data <= data;
      end if;
    end if;
  end process;

  port_out <= data;	-- drive the Port out
  port_enb <= datadir;	-- drive the tristate enables out

  dataout <= port_in when addr='0' else datadir; -- mux the readback data

end rtl;
