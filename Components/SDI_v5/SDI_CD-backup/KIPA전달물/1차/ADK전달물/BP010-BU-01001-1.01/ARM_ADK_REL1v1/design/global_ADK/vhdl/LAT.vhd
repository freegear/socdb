--  --========================================================================--
--  This confidential and proprietary software may be used only as
--  authorised by a licensing agreement from ARM Limited
--    (C) COPYRIGHT 2001 ARM Limited
--        ALL RIGHTS RESERVED
--  The entire notice above must be reproduced on all authorised
--  copies and copies may only be made to the extent permitted
--  by a licensing agreement from ARM Limited.
--  
--  ----------------------------------------------------------------------------
--  Version and Release Control Information:
--  
--  File Name           : LAT.vhd,v
--  File Revision       : 1.1
--  
--  Release Information : ADK_REL1v1
--  
--  ----------------------------------------------------------------------------
--  Purpose             : Transparent latch
--  --========================================================================--

library ieee;
use     ieee.std_logic_1164.all;

entity LAT is
  port(
       CLOCK   : in  std_logic;
       DATAIN  : in  std_logic;
       DATAOUT : out std_logic
       );
end LAT;

architecture synth of LAT is
begin

  p_lat : process (CLOCK, DATAIN)
  begin
    if CLOCK = '1' then
      DATAOUT <= DATAIN;
    end if;
  end process p_lat;

end synth;
