----------------------------------------------------------------------
--
-- File: alt_cfg_BISTROM.VHD	-- altera version...
-- Revision: $Name: REV9910 $
-- Description: Full Functional Model of a 512x8 ROM.
--	Initializes from an Intel Hex format file called bistrom.hex.
--
-- Copyright 1996 VAutomation Inc. Nashua NH. All rights reserved.
-- VAutomation Inc.                  Nashua NH 03063 (603)882-2282.
-- This software is provided under license and contains proprietary
-- and confidential material which is the property of VAutomation Inc.
-- HTTP://www.vautomation.com

-----------------------------------------------------------------------
-- $Log: alt_cfg_bistrom.vhd,v $
-- Revision 1.3  1999/09/17 12:08:10  eric
-- updated with the latest tools. The entity name has changed to just bistrom.
--
-- Revision 1.2  1998/10/19 22:02:30  eric
-- Directly point to the _hw bistrom file so the version compiled for hardware is picked up properly.
--
-- Revision 1.1  1998/08/04 20:45:10  eric
-- Initial revision
--
-----------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
LIBRARY lpm;
use lpm.lpm_components.ALL;

----------------- Entity declaration ---------------------------------

ENTITY bistrom IS
  PORT (SIGNAL addr:  IN    std_logic_vector(8 downto 0); -- Address
        SIGNAL rom_enb:  IN    std_logic; -- enable the ROM
        SIGNAL rom_out:  OUT   std_logic_vector(7 downto 0)); -- Data port
END bistrom;

ARCHITECTURE altera of bistrom is---------------------Architecture-----
COMPONENT lpm_rom
   GENERIC (LPM_WIDTH: POSITIVE;
      LPM_TYPE: STRING := "L_ROM";
      LPM_WIDTHAD: POSITIVE;
      LPM_NUMWORDS: STRING := "UNUSED";
      LPM_FILE: STRING;
      LPM_ADDRESS_CONTROL: STRING := "REGISTERED";
      LPM_OUTDATA: STRING := "REGISTERED";
      LPM_HINT: STRING := "UNUSED");
   PORT (address: IN STD_LOGIC_VECTOR(LPM_WIDTHAD-1 DOWNTO 0);
      inclock: IN STD_LOGIC := '1';
      outclock: IN STD_LOGIC := '1';
      memenab: IN STD_LOGIC := '1';

      q: OUT STD_LOGIC_VECTOR(LPM_WIDTH-1 DOWNTO 0));
END COMPONENT;
CONSTANT LPM_WIDTH : POSITIVE := 8;
CONSTANT LPM_WIDTHAD : POSITIVE := 9;
BEGIN
u_rom: lpm_rom
   GENERIC MAP (LPM_WIDTH => LPM_WIDTH,
      LPM_TYPE => "L_ROM",
      LPM_WIDTHAD => LPM_WIDTHAD,
      LPM_NUMWORDS => "512",
      LPM_FILE => "software/bistrom_hw.ihx",
      LPM_ADDRESS_CONTROL => "UNREGISTERED",
      LPM_OUTDATA         => "UNREGISTERED",
      LPM_HINT => " ")
   PORT MAP (address => addr,
      q=> rom_out);
end altera;
