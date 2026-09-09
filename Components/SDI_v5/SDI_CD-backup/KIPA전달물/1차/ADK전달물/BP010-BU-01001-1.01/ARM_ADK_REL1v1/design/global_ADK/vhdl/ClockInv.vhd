--  --================================================================--
--  This confidential and proprietary software may be used only as
--  authorised by a licensing agreement from ARM Limited
--    (C) COPYRIGHT 1999-2001 ARM Limited
--        ALL RIGHTS RESERVED
--  The entire notice above must be reproduced on all authorised
--  copies and copies may only be made to the extent permitted
--  by a licensing agreement from ARM Limited.
--  
--  --------------------------------------------------------------------
--  Version and Release Control Information:
--  
--  File Name           : ClockInv.vhd,v
--  File Revision       : 1.1
--  
--  Release Information : ADK_REL1v1
--  
--  --------------------------------------------------------------------
--  Purpose             : Clock gating inverter.
--  --================================================================--

library ieee;
use     ieee.std_logic_1164.all;

entity ClockInv is
  port(
    InClock  : in  std_logic;
    OutClock : out std_logic
    );
end ClockInv;

architecture synth of ClockInv is

begin

  OutClock <= not InClock;

end synth;
  
-- --============================== End ==============================--
