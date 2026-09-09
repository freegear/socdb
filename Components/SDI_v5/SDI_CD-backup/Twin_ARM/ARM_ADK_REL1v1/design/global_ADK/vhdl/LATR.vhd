--  --========================================================================--
--  This confidential and proprietary software may be used only as
--  authorised by a licensing agreement from ARM Limited
--    (C) COPYRIGHT 2000-2001 ARM Limited
--        ALL RIGHTS RESERVED
--  The entire notice above must be reproduced on all authorised
--  copies and copies may only be made to the extent permitted
--  by a licensing agreement from ARM Limited.
--  
--  ----------------------------------------------------------------------------
--  Version and Release Control Information:
--  
--  File Name           : LATR.vhd,v
--  File Revision       : 1.1
--  
--  Release Information : ADK_REL1v1
--  
--  ----------------------------------------------------------------------------
--  Purpose             : Transparent latch with active-low asynchronous reset
--  --========================================================================--

library ieee;
use     ieee.std_logic_1164.all;

entity LATR is
  port(
       CLOCK   : in  std_logic;
       DATAIN  : in  std_logic;
       ARESETn : in  std_logic;
       DATAOUT : out std_logic
       );
end LATR;

architecture synth of LATR is
begin

  p_lat : process (CLOCK, DATAIN, ARESETn)
  begin
    if (ARESETn = '0') then
      DATAOUT <= '0';
    elsif CLOCK = '1' then
      DATAOUT <= DATAIN;
    end if;
  end process p_lat;

end synth;
