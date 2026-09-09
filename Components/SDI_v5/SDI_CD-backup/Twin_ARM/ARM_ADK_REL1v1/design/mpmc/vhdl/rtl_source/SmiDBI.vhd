--  --========================================================================--
--  This confidential and proprietary software may be used only as
--  authorised by a licensing agreement from ARM Limited
--    (C) COPYRIGHT 1998-2001 ARM Limited
--        ALL RIGHTS RESERVED
--  The entire notice above must be reproduced on all authorised
--  copies and copies may only be made to the extent permitted
--  by a licensing agreement from ARM Limited.
--  
--  ----------------------------------------------------------------------------
--  Version and Release Control Information:
--  
--  File Name           : SmiDBI.vhd,v
--  File Revision       : 1.3
--
--  Release Information : ADK_REL1v1
--
--  ----------------------------------------------------------------------------
--  Purpose             : External data bus multiplexer between Smi and TIC.
--  --========================================================================--

library ieee;
use     ieee.std_logic_1164.all;
use     ieee.std_logic_arith.all;

-- -----------------------------------------------------------------------------

entity SmiDBI is
  port(
    nSMCDATAEN : in  std_logic_vector(3 downto 0);
    TICREAD    : in  std_logic;
    SMCDATAOUT : in  std_logic_vector(31 downto 0);
    HRDATATIC  : in  std_logic_vector(31 downto 0);

    nSMDATAEN  : out std_logic_vector(3 downto 0);
    SMDATAOUT  : out std_logic_vector(31 downto 0)
    );
end SmiDBI;

architecture synth of SmiDBI is

--------------------------------------------------------------------------------
-- Beginning of main code
--------------------------------------------------------------------------------
  begin

--------------------------------------------------------------------------------
-- Data bus multiplexing
--------------------------------------------------------------------------------
-- The data bus and data bus enable outputs are switched between the TIC and
--  SmiCore values according to the status of the TIC. When the TIC is granted
--  control of the AHB data bus, the TIC outputs are driven onto the external
--  bus, and the SmiCore outputs are used at all other times.

  nSMDATAEN <= "0000"    when TICREAD = '1' else nSMCDATAEN;
  SMDATAOUT <= HRDATATIC when TICREAD = '1' else SMCDATAOUT;


end synth;

-- --================================== End ==================================--
