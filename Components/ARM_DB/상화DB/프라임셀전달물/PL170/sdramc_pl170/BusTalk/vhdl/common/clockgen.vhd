-- -----------------------------------------------------------------------------
--  This confidential and proprietary software may be used only as
--  authorised by a licensing agreement from ARM Limited
--    (C) COPYRIGHT 1999 ARM Limited
--        ALL RIGHTS RESERVED
--  The entire notice above must be reproduced on all authorised
--  copies and copies may only be made to the extent permitted
--  by a licensing agreement from ARM Limited.
-- -----------------------------------------------------------------------------
--
--  Version and Release Control Information:
--
--  File Name              : clockgen.vhd,v
--  File Revision          : 1.1
--
--  Release Information    : PrimeCell(TM)-PL170-REL2v2
--
-- -----------------------------------------------------------------------------
--
-- Purpose   : This module generates the bus clock HCLK
--
-- -----------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
 
-- -----------------------------------------------------------------------------

library ieee;
use     ieee.std_logic_1164.all;

entity Clockgen is
  generic(
          Tclkl  : time;
          Tclkh  : time
          );          
  port(
       HCLK : out std_logic -- AHB bus Clock
       );
end Clockgen;
-- -----------------------------------------------------------------------------
--
--                             clockgen
--                             ========
--
-- -----------------------------------------------------------------------------
--
-- Overview
-- ========
--
-- This module generates the main busclock HCLK, by toggling the HCLK line after
-- a time periods tclkl(denoting low phase) and tclkh(denoting high phase). The
-- values of tclkl and tclkh are passed as generic parameters.
 
-- ================================ ARCHITECTURE ============================ --
architecture behavioural of Clockgen is
-- -----------------------------------------------------------------------------
-- Signal declarations
-- -----------------------------------------------------------------------------

signal iHCLK : std_logic := '0';
-- internal copy of the HCLK signal
 
-- -----------------------------------------------------------------------------
-- Main body of code
-- =================
-- -----------------------------------------------------------------------------
 
begin

-- -----------------------------------------------------------------------------
-- This block toggles the output line after a time determined by generic the
-- generic parameters, and HCLK is generated
-- -----------------------------------------------------------------------------
p_clock : process (iHCLK)
begin
  if iHCLK = '0' then
    iHCLK <= '1' after tclkl;
  else
    iHCLK <= '0' after tclkh;
  end if;
  HCLK <= iHCLK;
end process p_clock;

end behavioural;

-- ================================== End =================================== --
