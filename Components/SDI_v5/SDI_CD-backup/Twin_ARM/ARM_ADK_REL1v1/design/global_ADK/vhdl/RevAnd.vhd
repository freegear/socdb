--  --==============================================================--
--  This confidential and proprietary software may be used only as
--  authorised by a licensing agreement from ARM Limited
--    (C) COPYRIGHT 2001 ARM Limited
--        ALL RIGHTS RESERVED
--  The entire notice above must be reproduced on all authorised
--  copies and copies may only be made to the extent permitted
--  by a licensing agreement from ARM Limited.
--  
--  ------------------------------------------------------------------
--  Version and Release Control Information:
--  
--  File Name           : RevAnd.vhd,v
--  File Revision       : 1.1
--  
--  Release Information : ADK_REL1v1
--  
--  ------------------------------------------------------------------
--  Purpose             : Revision Designator Module
--  --==============================================================--

library ieee;
use     ieee.std_logic_1164.all;
use     ieee.std_logic_arith.all;

-- -------------------------------------------------------------------

entity RevAnd is
  port(
    TieOff1  : in  std_logic; -- Tieoff input 1
    TieOff2  : in  std_logic; -- Tieoff input 2
    Revision : out std_logic  -- TieOff1 and TieOff2 ANDed
    );
end RevAnd;

-- -------------------------------------------------------------------
--
--                                  RevAnd
--                                 =========
--
-- -------------------------------------------------------------------
--
-- Overview
-- ========
--   This module contains a single AND gate to be used as a
-- place-holder cell to mark the Revision Number of the controller.
-- The 2 input pins will be tied-off at the top level of the
-- hierarchy. These "TieOffs" can be identified during layout
-- and re-wired to "VDD" or "VSS" if needed.
--
-- -------------------------------------------------------------------

-- --=================== ARCHITECTURE ==============================--

architecture synth of RevAnd is

-- -------------------------------------------------------------------
--
-- Main body of code
-- =================
--
-- -------------------------------------------------------------------

begin

-- -------------------------------------------------------------------
-- The inputs TieOff1 and TieOff2 are ANDed to generate the Revision
-- number bit.
-- -------------------------------------------------------------------
  Revision <= TieOff1 and TieOff2;

end synth;

-- --============================= End =============================--
