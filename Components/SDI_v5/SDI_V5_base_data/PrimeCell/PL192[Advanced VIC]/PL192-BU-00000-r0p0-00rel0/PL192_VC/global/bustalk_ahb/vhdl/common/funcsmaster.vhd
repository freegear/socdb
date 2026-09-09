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
-- File Name              : funcsmaster.vhd.rca
-- File Revision          : 1.1
--
-- Release Information    : PrimeCell(TM)-GLOBAL-r8p0-00rel0
-- 
-- ---------------------------------------------------------------------
-- Purpose :
--           To describe procedures and functions, mainly for
--           buschecker/watcher
--
-- --=================================================================--

library IEEE;
use     IEEE.std_logic_1164.all;
use     ieee.std_logic_arith.all;

library common;
use     common.funcs.all;
use     common.defsmaster.all;
use     common.configmaster.all;

-- ---------------------------------------------------------------------

package funcsmaster is
function to_vec (
                 sig : std_logic
                ) return std_logic_vector;

function from_vec (
                   vec : std_logic_vector(0 downto 0)
                  ) return std_logic;

--function To_HexString (
--                       constant val : std_logic_vector
--                      ) return string;

function endianize (
                    data           : in T_data;
                    size           : in T_size;
                    address        : in T_addr;
                    ByteLaneDecidr : in std_logic_vector(2 downto 0);
                    Endianness     : in T_endian;
                    DATABUSWIDTH   : in integer
                   ) return T_data;

procedure Compare (
                   constant HaltOnMismatch : in boolean;
                   constant Verbosity      : in boolean;
                   constant strg1          : in string;
                   constant data1          : in std_logic_vector;
                   constant data2          : in std_logic_vector;
                   constant data3          : in std_logic_vector;
                   constant strg2          : in string;
                   constant strg3          : in string;
                   constant tag            : in string
                  );

procedure Compare (
                   constant HaltOnMismatch : in boolean;
                   constant Verbosity      : in boolean;
                   constant strg1          : in string;
                   constant data1          : in std_ulogic;
                   constant data2          : in std_ulogic;  
                   constant data3          : in std_logic_vector;  
                   constant strg2          : in string;
                   constant strg3          : in string;
                   constant tag            : in string
                  );

procedure ReportVirRead (
                         constant Verbosity      : in boolean;
                         constant HaltOnMismatch : in boolean;
                         constant data           : in std_logic_vector;
                         constant mask           : in std_logic_vector;
                         constant exp            : in std_logic_vector;
                         constant reg            : in integer;
                         constant tag            : in string(1 to 20)
                        );

procedure ReportVirWrite(
                         constant data : in std_logic_vector;
                         constant mask : in std_logic_vector;
                         constant reg  : in integer
                        );

procedure ReportReset (
                       constant nres : in std_logic
                      );

end funcsmaster;

-- ---------------------------------------------------------------------
--
--                             funcs
--                             =====
--
-- ---------------------------------------------------------------------
--
-- Overview
-- ========
--   This module describes some common functions and procedures, the
-- brief outline of which are given as follows :-
-- o Compare :-
--   This procedure is used in BusChecker and BusWatch module for
--   flashing suitable error messages. It takes as input the actual
--   signal to be checked, the value with which it is to be compared and
--   the present value of the
--   address line. If the values don't match it flashes an error along
--   with giving the address during which the error occurred.
-- o To_HexString :-
--   This function any std_logic_vector as input and returns the
--   corresponding hexadecimal string.
-- o Endianize :- 
--   This function drives data on appropriate bytelanes as per
--   endianness. It takes endianness and HADDR bits as input and on the
--   basis of that, "puts" data on the correct byte lane and drives the
--   other lanes to zero.
-- o to_vec :-
--   This function converts a bit to a std_logic_vector of length 1.
-- o from_vec :-
--   This function converts as std_logic_vector of length 1, to
--   std_logic.
-- o ReportVirRead :-
--   This function reports an error, if the value read from the VR
--   does not match with expected value. If HaltOnMismatch is set, then
--   it halts the simulation by giving a severity of failure. If
--   verbosity is set, it reports the event, even if the value matches
--   with the expected one.
-- o ReportVirWrite :-
--   This function reports the write value along with the mask, whenever
--   there is a virtual write.
-- o ReportReset :-
--   This function reports the assertion and deassertion of HRESETn.
--
-- --============================ BODY ===============================--

package body funcsmaster is

function StrLengthHex (
                       constant x : in integer
                      ) return integer is
variable result : integer;
begin
  if (x mod 4 = 0) then
    result := (x / 4) ; 
  else
    result := (x/4) + 1 ;
  end if ;
  return (result) ;
end StrLengthHex ;
  
--function To_HexString (
--                       constant val : in std_logic_vector
--                      ) return string is
--constant ResLength : integer := StrLengthHex(val'length);
--variable result    : string (1 to ResLength);
--variable temp      : std_logic_vector(3 downto 0);
--begin
--  for i in (ResLength-1) downto 0 loop
--    result(ResLength-i) := ' ';
--    for j in 3 downto 0 loop
--      if (i = (ResLength-1)) then
--        if (i*4)+j >= val'length then
--          temp(j) := '0' ;
--        else
--          temp(j) := val( (i*4)+j ) ;
--        end if ;
--      else
--        temp(j) := val( (i*4)+j ) ;
--      end if ;
--    end loop ;
--    case temp(3 downto 0) is
--      when "0000" => 
--        result(ResLength-i) := '0'; 
--      when "0001" =>
--        result(ResLength-i) := '1'; 
--      when "0010" =>
--        result(ResLength-i) := '2'; 
--      when "0011" =>
--        result(ResLength-i) := '3'; 
--      when "0100" =>
--        result(ResLength-i) := '4'; 
--      when "0101" => 
--        result(ResLength-i) := '5'; 
--      when "0110" =>
--        result(ResLength-i) := '6'; 
--      when "0111" => 
--        result(ResLength-i) := '7'; 
--      when "1000" => 
--        result(ResLength-i) := '8'; 
--      when "1001" => 
--        result(ResLength-i) := '9'; 
--      when "1010" => 
--        result(ResLength-i) := 'A'; 
--      when "1011" => 
--        result(ResLength-i) := 'B'; 
--      when "1100" => 
--        result(ResLength-i) := 'C'; 
--      when "1101" => 
--        result(ResLength-i) := 'D'; 
--      when "1110" => 
--        result(ResLength-i) := 'E'; 
--      when "1111" => 
--        result(ResLength-i) := 'F';
--      when others  => 
--        result(ResLength-i) := 'X';
--    end case;
--  end loop;
--  return result;
--end To_HexString;

procedure Compare (
                   constant HaltOnMismatch : in boolean;
                   constant Verbosity      : in boolean;
                   constant strg1          : in string;
                   constant data1          : in std_logic_vector;
                   constant data2          : in std_logic_vector;
                   constant data3          : in std_logic_vector;
                   constant strg2          : in string;
                   constant strg3          : in string;
                   constant tag            : in string
                  ) is
variable PrintStr : string(1 to 255);
begin
  if (data1 /= data2) then
    fprint(PrintStr,
           "%s : %s Error on %s at address %s. Expected: %s" &
           " Actual: %s, TAG: %s",
           strg3,
           strg2,
           strg1,
           To_HexString(data3),
           To_HexString(data2),
           To_HexString(data1),
           tag
          );
    if HaltOnMismatch then
      assert false
      report printstr
      severity failure;
    else
      assert false
      report printstr
      severity warning;
    end if;
  end if;
  if (data1 = data2) then
    if (Verbosity) then
      fprint(PrintStr, "%s : Correct value expected for %s = %s",
             to_string(now), strg1, To_HexString(data1));
      assert false
      report PrintStr
      severity note;
    end if;
  end if;
end Compare;

procedure Compare (
                   constant HaltOnMismatch : in boolean;
                   constant Verbosity      : in boolean;
                   constant strg1          : in string;
                   constant data1          : in std_ulogic;
                   constant data2          : in std_ulogic;
                   constant data3          : in std_logic_vector;
                   constant strg2          : in string;
                   constant strg3          : in string;
                   constant tag            : in string
                  ) is
variable printstr  : string(1 to 255);
begin
  if (data1 /= data2) then
    fprint(printstr,
           "%s : %s Error on %s at address %s. Expected: %s" &
           " Actual: %s, TAG: %s",
           strg3,
           strg2,
           strg1,
           To_HexString(data3),
           To_String(data2),
           To_String(data1),
           tag
          );
    if HaltOnMismatch then
      assert false
      report printstr
      severity failure;
    else
      assert false
      report printstr
      severity warning;
    end if;
  end if;
  if (data1 = data2) then
    if (Verbosity) then
      fprint(PrintStr, "%s : Correct value expected for %s = %s",
             to_string(now), strg1, To_String(data1));
      assert false
      report PrintStr
      severity note;
    end if;
  end if;
end Compare;

procedure ReportVirRead (
                         constant Verbosity      : in boolean;
                         constant HaltOnMismatch : in boolean;
                         constant data           : in std_logic_vector;
                         constant mask           : in std_logic_vector;
                         constant exp            : in std_logic_vector;
                         constant reg            : in integer;
                         constant tag            : in string (1 to 20)
                        ) is
variable printstr  : string(1 to 255);
begin
  if ((mask and data) /= (mask and exp)) then
    fprint(printstr,
           "VRE%s: Error on vector read from R%s. Expected: %s " &
           "Actual: %s Mask: %s, TAG: %s", 
           To_String(reg),
           To_String(reg),
           To_HexString(exp),
           To_HexString(data),
           To_HexString(mask),
           tag);
    if HaltOnMismatch then
      assert false
      report printstr
      severity failure;
    else
      assert false
      report printstr
      severity warning;
    end if;
  elsif Verbosity then 
    fprint(printstr,
           "VRC%s: Correct read value of %s with mask %s from R%s," & 
           "TAG:%s",
           To_String(reg),
           To_HexString(data),
           To_HexString(mask),
           To_String(reg),
           tag);
    assert false
    report printstr
    severity note;
  end if;
end ReportVirRead;

procedure ReportVirWrite (
                          constant data : in std_logic_vector;
                          constant mask : in std_logic_vector;
                          constant reg  : in integer
                         ) is
variable printstr  : string(1 to 255);
begin
  fprint(printstr, "VWI%s: Vector write of %s with mask %s to  R%s",
         To_String(reg),
         To_HexString(data),
         To_HexString(mask),
         To_String(reg)
        );
  assert false
  report printstr
  severity note;
end ReportVirWrite;

procedure ReportReset (
                       constant nres : in std_logic
                      ) is
begin
  if (nres = '0') then
    assert false
    report "RESL: HRESETn asserted (LOW)"
    severity note;
  elsif nres = '1' then
    assert false
    report "RESH: HRESETn deasserted (HIGH)"
    severity note;
  end if;
end ReportReset;

function to_vec (
                 sig : std_logic
                ) return std_logic_vector is
begin
  case sig is
    when '1' =>
      return ("1");
    when '0' =>
      return ("0");
    when 'Z' =>
      return ("Z");
    when others =>
      return ("X");
  end case;
end to_vec;

function from_vec (
                   vec : std_logic_vector(0 downto 0)
                  ) return std_logic is
begin
  case vec is
    when "1" =>
      return ('1');
    when "0" =>
      return ('0');
    when "Z" =>
      return ('Z');
    when others =>
      return ('X');
  end case;
end from_vec;
     
-- ---------------------------------------------------------------------
-- This block is responsible for driving data on appropriate bytelanes
-- as per the endianness. It takes endianness and HADDR bits as input
-- and on the basis of that, "puts" the data on the correct byte lane
-- and drives the other lanes to zero.
-- ---------------------------------------------------------------------
function endianize (
                    data           : in T_data;
                    size           : in T_size;
                    address        : in T_addr;
                    ByteLaneDecidr : in std_logic_vector(2 downto 0);
                    Endianness     : in T_endian;
                    DATABUSWIDTH   : in integer
                   ) return T_data is
variable EndnzdData : T_data;
begin
  if ((Endianness = little) or (Endianness = big)) then
    if (DATABUSWIDTH = 32) then
      if (size = "000") then
        case ByteLaneDecidr(1 downto 0) is
          when "00" =>
            EndnzdData := ALLZEROES(63 downto 32) &
                          ALLZEROES(31 downto 8) &
                          data(7 downto 0);
          when "01" =>
            EndnzdData := ALLZEROES(63 downto 32) &
                          ALLZEROES(31 downto 16) &
                          data(7 downto 0) & ALLZEROES(7 downto 0);
          when "10" =>
            EndnzdData := ALLZEROES(63 downto 32) &
                          ALLZEROES(31 downto 24) &
                          data(7 downto 0) & ALLZEROES(15 downto 0);
          when "11" =>
            EndnzdData := ALLZEROES(63 downto 32) & data(7 downto 0) &
                          ALLZEROES(23 downto 0);
          when others =>
            null;
        end case;
      elsif (size = "001") then
        case ByteLaneDecidr(1) is
          when '0' =>
            EndnzdData := ALLZEROES(63 downto 32) &
                          ALLZEROES(31 downto 16) &
                          data(15 downto 0);
          when '1' =>
            EndnzdData := ALLZEROES(63 downto 32) & data(15 downto 0) &
                          ALLZEROES(15 downto 0);
          when others =>
            null;
        end case;
      elsif (size = "010") then
        EndnzdData := ALLZEROES(63 downto 32) & data(31 downto 0);
      else
        -- although this is an illegal clause, still for correct
        -- behaviour of expected data, here data is assigned to
        -- EndnzdData
        EndnzdData := data;
      end if;
    elsif (DATABUSWIDTH = 64) then
      if (size = "000") then
      -- transfer size is byte-size
        case ByteLaneDecidr(2 downto 0) is
          when "000" =>
            EndnzdData := ALLZEROES(63 downto 8) & data(7 downto 0);
          when "001" =>
            EndnzdData := ALLZEROES(63 downto 16) & data(7 downto 0) &
                          ALLZEROES(7 downto 0);
          when "010" =>
            EndnzdData := ALLZEROES(63 downto 24) & data(7 downto 0) &
                          ALLZEROES(15 downto 0);
          when "011" =>
            EndnzdData := ALLZEROES(63 downto 32) & data(7 downto 0) &
                          ALLZEROES(23 downto 0);
          when "100" =>
            EndnzdData := ALLZEROES(63 downto 40) & data(7 downto 0) &
                          ALLZEROES(31 downto 0);
          when "101" =>
            EndnzdData := ALLZEROES(63 downto 48) & data(7 downto 0) &
                          ALLZEROES(39 downto 0);
          when "110" =>
            EndnzdData := ALLZEROES(63 downto 56) & data(7 downto 0) &
                          ALLZEROES(47 downto 0);
          when "111" =>
            EndnzdData := data(7 downto 0) & ALLZEROES(55 downto 0);
          when others =>
            null;
        end case;
      elsif (size = "001") then
      -- transfer size is halfword-size
        case ByteLaneDecidr(2 downto 1) is
          when "00" =>
            EndnzdData := ALLZEROES(63 downto 16) & data(15 downto 0);
          when "01" =>
            EndnzdData := ALLZEROES(63 downto 32) & data(15 downto 0)
                          & ALLZEROES(15 downto 0);
          when "10" =>
            EndnzdData := ALLZEROES(63 downto 48) & data(15 downto 0)
                          & ALLZEROES(31 downto 0);
          when "11" =>
            EndnzdData := data(15 downto 0) & ALLZEROES(47 downto 0);
          when others =>
            null;
        end case;
      elsif (size = "010") then
      -- transfer size is word-size
        case ByteLaneDecidr(2) is
          when '0' =>
            EndnzdData := ALLZEROES(63 downto 32) & data(31 downto 0);
          when '1' =>
            EndnzdData := data(31 downto 0) & ALLZEROES(31 downto 0);
          when others =>
            null;
        end case;
      elsif (size = "011") then
      -- transfer size is doubleword-size
        EndnzdData := data;
      else
        -- although this is an illegal clause, still for correct
        -- behaviour of expected data, here data is assigned to
        -- EndnzdData
        EndnzdData := data;
      end if;
    end if;
  elsif (Endianness = no) then
    EndnzdData := data;
  end if;
  return EndnzdData;
end endianize;

end funcsmaster;

-- --============================= End ===============================--
