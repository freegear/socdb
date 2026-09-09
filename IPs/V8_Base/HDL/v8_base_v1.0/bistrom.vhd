---------------------------------------------------------------------
--
-- File: BISTROM.VHD
-- Revision: $Name: REV9910 $
-- Description: Full Functional Model of a 512x8 ROM.
--      Initializes from an Intel Hex format file called bistrom.hex.
--
-- Copyright 1996 VAutomation Inc. Nashua NH. All rights reserved.
-- VAutomation Inc. 20 Trafalgar Sq. Nashua NH 03063 (603)882-2282.
-- This software is provided under license and contains proprietary
-- and confidential material which is the property of VAutomation Inc.
--

---------------------------------------------------------------------
-- $Log: bistrom.vhd,v $
-- Revision 1.7  1999/08/30 14:53:42  scott
-- Fixed bug in array indexing types driving signal romout
--
-- Revision 1.6  1999/08/25 17:55:14  scott
-- Modified the code to use std_ulogic(_vector) and
-- IEEE numeric_std package
--
-- Revision 1.5  1998/04/13 15:20:28  eric
-- added the Altera architecture.
--
-- Revision 1.4  1998/01/19 18:42:19  eric
-- fixed length of filename for Unix.
--
-- Revision 1.3  1998/01/19 17:50:00  eric
-- Changed to the new ROMBLDR ROM.
--
-- Revision 1.1  1996/11/11  15:07:39  eric
-- Initial revision
--
---------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.v8_pkg.all;

----------------- Entity declaration --------------------------------

entity bistrom is
  port(
    addr    : in  std_ulogic_vector(8 downto 0);  -- Address
    rom_enb : in  std_ulogic;                     -- enable the ROM
    rom_out : out std_ulogic_vector(7 downto 0)   -- Data port
    ); 
end bistrom;

architecture behavioral of bistrom is   ----------- Architecture-----
  signal romout : std_ulogic_vector(7 downto 0);
  signal data   : std_ulogic_vector(7 downto 0);
begin

  init:process
    variable ram_core : byte_array( 0 to (512)-1);  -- 512 bytes
    constant infile   : string(1 to 11) := "bistrom.hex";
-- but we just couldn't seem to get that to work...
  begin
    init_ramcore(ram_core,infile,"bistrom");
    loop
      wait on addr;
      romout <= to_stdulogicvector(
        ram_core(vec2int(to_stdlogicvector(addr))));
    end loop;
  end process;

  rom_out <=  romout after 5 ns when rom_enb='1' else
              "ZZZZZZZZ" after 5 ns;
end behavioral;

architecture altera of bistrom is       ------------ Architecture -----
  component lpm_rom
    generic(
      LPM_WIDTH           : positive;
      LPM_TYPE            : string := "L_ROM";
      LPM_WIDTHAD         : positive;
      LPM_NUMWORDS        : string := "UNUSED";
      LPM_FILE            : string;
      LPM_ADDRESS_CONTROL : string := "REGISTERED";
      LPM_OUTDATA         : string := "REGISTERED";
      LPM_HINT            : string := "UNUSED"
      );
    port(
      address  : in  std_ulogic_vector(LPM_WIDTHAD-1 downto 0);
      inclock  : in  std_ulogic := '1';
      outclock : in  std_ulogic := '1';
      memenab  : in  std_ulogic := '1';
      q        : out std_ulogic_vector(LPM_WIDTH-1 downto 0)
      );
  end component;
  constant LPM_WIDTH   : positive := 8;
  constant LPM_WIDTHAD : positive := 9;
begin
  bistrom_alt : lpm_rom
    generic map(
      LPM_WIDTH           => LPM_WIDTH,
      LPM_TYPE            => "L_ROM",
      LPM_WIDTHAD         => LPM_WIDTHAD,
      LPM_NUMWORDS        => "512",
      LPM_FILE            => "bistrom.hex",
      LPM_ADDRESS_CONTROL => "UNREGISTERED",
      LPM_OUTDATA         => "UNREGISTERED",
      LPM_HINT            => " ")
    port map(
      address => addr,
      q       => rom_out);
end altera;
