--  ----------------------------------------------------------------------------
--  This confidential and proprietary software may be used only as
--  authorised by a licensing agreement from ARM Limited
--    (C) COPYRIGHT 1999 ARM Limited
--        ALL RIGHTS RESERVED
--  The entire notice above must be reproduced on all authorised
--  copies and copies may only be made to the extent permitted
--  by a licensing agreement from ARM Limited.
--  ----------------------------------------------------------------------------
--
--  Version and Release Control Information:
--
--  File Name              : $RCS: $
--  File Revision          : 1.3
--
--  Release Information    : PrimeCell(TM)-PL170-REL2v2
--
--  ----------------------------------------------------------------------------
--   Purpose      : Contains Header Information for the TrickBox
--  ----------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

package SdramTrDefs is

--  ----------------------------------------------------------------------------
--  Define the Bus Width 
--  ----------------------------------------------------------------------------
constant BusWidth          : integer := 32;

--  ----------------------------------------------------------------------------
--  Range and Width Definitions
--  ----------------------------------------------------------------------------
constant Width          : integer := BusWidth;

constant ADDMSB         : integer := 7  + BusWidth/64;
constant ADDLSB         : integer := 2  + BusWidth/64;
constant ADDWIDTH       : integer := 10 + BusWidth/64;

constant PORDelay       : time    := 1 ns;

end SdramTrDefs;
