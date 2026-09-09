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
--  File Name           : ClockOr.vhd,v
--  File Revision       : 1.1
--  
--  Release Information : ADK_REL1v1
--  
--  --------------------------------------------------------------------
--  Purpose             : Clock gating OR gate.
--  --================================================================--

library ieee;
use     ieee.std_logic_1164.all;

entity ClockOr is
  port(
    InClock  : in  std_logic;
    Enable   : in  std_logic;
    OutClock : out std_logic
    );
end ClockOr;

architecture synth of ClockOr is

begin

 OutClock <= InClock or Enable;

end synth;
  
-- --============================== End ==============================--
