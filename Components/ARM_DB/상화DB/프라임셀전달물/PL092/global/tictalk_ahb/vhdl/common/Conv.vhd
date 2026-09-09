-- --=================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 2000 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
--
-- ---------------------------------------------------------------------
-- Version and Release Control Information:
--
-- File Name              : Conv.vhd.rca
-- File Revision          : 1.1
--
-- Release Information    : PrimeCell(TM)-GLOBAL-REL1v3
--
-- ---------------------------------------------------------------------
-- Purpose :
--           Type conversion functions used with textio modules
--
-- --=================================================================--

library IEEE;
use     IEEE.std_logic_1164.all;

package Conv is

  function Hex2StdVec (HexString: string) return std_logic_vector;
  function StdVec2Int (StdVec : std_logic_vector) return integer;

end Conv;

package body Conv is

-- ---------------------------------------------------------------------
-- Hex2StdVec converts a hex string to a std_logic_vector
-- ---------------------------------------------------------------------
  function Hex2StdVec (HexString : string) return std_logic_vector is

-- StdVec is the output data vector with length set according to
-- the length of the input hex data string. Each character in the
-- input string becomes four std_logic_vector bits
  variable StdVec :
               std_logic_vector(((HexString'length * 4)-1) downto 0);
-- j is used to select each four bit range of StdVec accoring to the
-- input string character being conveted
  variable j      : integer;

  begin                               -- Loop for each character
                                      -- in the string
    for i in 1 to HexString'length loop
      j := (i-1)*4;                   -- Generate address slice values
      case (HexString(i)) is
        when '0'       => StdVec(j+3 downto j) := "0000";
        when '1'       => StdVec(j+3 downto j) := "0001";
        when '2'       => StdVec(j+3 downto j) := "0010";
        when '3'       => StdVec(j+3 downto j) := "0011";
        when '4'       => StdVec(j+3 downto j) := "0100";
        when '5'       => StdVec(j+3 downto j) := "0101";
        when '6'       => StdVec(j+3 downto j) := "0110";
        when '7'       => StdVec(j+3 downto j) := "0111";
        when '8'       => StdVec(j+3 downto j) := "1000";
        when '9'       => StdVec(j+3 downto j) := "1001";
        when 'A' | 'a' => StdVec(j+3 downto j) := "1010";
        when 'B' | 'b' => StdVec(j+3 downto j) := "1011";
        when 'C' | 'c' => StdVec(j+3 downto j) := "1100";
        when 'D' | 'd' => StdVec(j+3 downto j) := "1101";
        when 'E' | 'e' => StdVec(j+3 downto j) := "1110";
        when 'F' | 'f' => StdVec(j+3 downto j) := "1111";
        when others    => StdVec(j+3 downto j) := "XXXX";
          assert (false) report "Invalid character in memory file"
            severity warning;	
      end case;
    end loop;
    return StdVec;
  end Hex2StdVec;

-- ---------------------------------------------------------------------
-- StdVec2Int converts a std_logic_vec to an integer
-- ---------------------------------------------------------------------
  function StdVec2Int (StdVec : std_logic_vector) return integer is

-- Integer value of the input vector to be returned by function
  variable IntVal : integer := 0;

  begin
    for i in StdVec'low to StdVec'high loop
      if StdVec(i) = '1' then
        IntVal := IntVal + (2 ** i);
      end if;
    end loop;
    return IntVal;
  end StdVec2Int;

end Conv;

-- --============================== End ==============================--
