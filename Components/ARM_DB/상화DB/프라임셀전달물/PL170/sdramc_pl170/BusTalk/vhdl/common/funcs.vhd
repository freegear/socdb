-- --=========================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 1999 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
--
-- -----------------------------------------------------------------------------
-- Version and Release Control Information:
--
-- File Name           : funcs.vhd,v
-- File Revision       : 1.3
--
-- Release Information : Rev1-3
--
-- ----------------------------------------------------------------------------
--   Purpose : This contains the functions/procedures (except readline, which
--             I deemed important enough to have its own file).  to_vec and
--             from_vec convert length 1 std_logic_vectors to std_logic and
--             vice-versa for use in the generic width addr_driver.
-- ----------------------------------------------------------------------------

library ieee;
use     ieee.std_logic_1164.all;

library Std_DevelopersKit;
use     std_DevelopersKit.Std_Regpak.all;
use     std_developerskit.std_IOpak.all;

library common;
use     common.defs.all;

-- ----------------------------------------------------------------------------

package funcs is
function to_vec(sig : std_logic) return std_logic_vector;
function from_vec(vec : std_logic_vector(0 downto 0)) return std_logic;
function To_HexString(constant val : std_logic_vector) return string;
function endianize (
                    data           : in T_data;
                    Endianness     : in std_logic_vector(1 downto 0);
                    size           : in T_size;
                    Databuswidth   : in integer;
                    address        : in T_addr;
                    ByteLaneDecidr : in std_logic_vector(2 downto 0)
                   ) return T_data;
 
procedure ReportRead(
                     constant Verbosity      : in boolean;
                     constant HaltOnMismatch : in boolean;
                     constant data           : in std_logic_vector;
                     constant mask           : in std_logic_vector;
                     constant address        : in T_addr; 
                     constant exp            : in std_logic_vector;
                     constant tag            : in string(1 to 20)
                    );
procedure ReportExtra(
                      constant count         : in T_int;
                      constant addr          : in T_addr;
                      constant tag           : in string(1 to 20)
                     );

procedure ReportWrite(
                      constant Verbosity      : in boolean;
                      constant data           : in std_logic_vector;
                      constant address        : in T_addr;
                      constant tag            : in string(1 to 20)
                     );

procedure ReportReset(constant nres : in std_logic);
procedure Response (
                    HaltOnMismatch : boolean;
                    tag            : string(1 to 20);
                    addr           : T_addr;
                    resp           : std_logic_vector(1 downto 0);
                    HRESP          : std_logic_vector(1 downto 0);
                    num_cyc        : T_int;
                    HREADY         : std_logic;
                    supp_msg       : boolean 
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
 

end funcs;
-- -----------------------------------------------------------------------------
--
--                                  funcs
--                                  =====
--
-- -----------------------------------------------------------------------------
--
-- Overview
-- ========
-- This module contains some functions for checking the data in the read bus
-- as well as for driving the data according to the endianness of the system
-- it is driving. It also have some functions for printing out any string.d
 
-- ================================= BODY =================================== --
 
package body funcs is

-- -----------------------------------------------------------------------------
-- This function returns the length of the string
-- -----------------------------------------------------------------------------
function StrLengthHex(constant x : in integer)
  return integer is
    variable result : integer ;
begin
  if (x mod 4 = 0) then
    result := (x / 4); 
  else
    result := (x/4) + 1;
  end if ;
  return (result);
end StrLengthHex;

-- -----------------------------------------------------------------------------
-- Converts to hexadecimal string
-- -----------------------------------------------------------------------------
function To_HexString(constant val : in std_logic_vector)
  return string is
  constant ResLength : integer := StrLengthHex(val'length);
  variable result    : string (1 to ResLength);
  variable temp      : std_logic_vector(3 downto 0);
begin
  for i in (ResLength-1) downto 0 loop
    result(ResLength-i) := ' ';
    for j in 3 downto 0 loop
      if (i = (ResLength-1)) then
        if (i*4)+j >= val'length then
          temp(j) := '0';
        else
          temp(j) := val((i*4)+j);
        end if;
      else
        temp(j) := val((i*4)+j);
      end if;
    end loop;
    case temp(3 downto 0) is
      when "0000" => result(ResLength-i) := '0'; 
      when "0001" => result(ResLength-i) := '1'; 
      when "0010" => result(ResLength-i) := '2'; 
      when "0011" => result(ResLength-i) := '3'; 
      when "0100" => result(ResLength-i) := '4'; 
      when "0101" => result(ResLength-i) := '5'; 
      when "0110" => result(ResLength-i) := '6'; 
      when "0111" => result(ResLength-i) := '7'; 
      when "1000" => result(ResLength-i) := '8'; 
      when "1001" => result(ResLength-i) := '9'; 
      when "1010" => result(ResLength-i) := 'A'; 
      when "1011" => result(ResLength-i) := 'B'; 
      when "1100" => result(ResLength-i) := 'C'; 
      when "1101" => result(ResLength-i) := 'D'; 
      when "1110" => result(ResLength-i) := 'E'; 
      when "1111" => result(ResLength-i) := 'F';
      when others  => result(ResLength-i) := 'X';
    end case;
  end loop;
  return result;
end To_HexString;

-- -----------------------------------------------------------------------------
-- Checking read data bus for the expected value
-- -----------------------------------------------------------------------------
procedure ReportRead(
                     constant Verbosity      : in boolean;
                     constant HaltOnMismatch : in boolean;
                     constant data           : in std_logic_vector;
                     constant mask           : in std_logic_vector;
                     constant address        : in T_addr;
                     constant exp            : in std_logic_vector;
                     constant tag            : in string(1 to 20)
                    ) is
      variable printstr  : string(1 to 255);
begin
      if ((mask and data) /= (mask and exp)) then
        fprint(printstr,
               "%s: SRE: Error on data read from %s. Expected: %s Actual: %s"
                & " Mask: %s TAG: %s",
               to_string(now,"%6.1t ns"),
               To_HexString(address),
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
                 "%s: SRC: Correct read value of %s with mask %s from %s TAG; "
                    & "%s",
                 to_string(now,"%6.1t ns"),
                 To_HexString(data),
                 To_HexString(mask),
                 To_HexString(address),
                 tag);
         assert false
         report printstr
         severity note;
      end if;
end ReportRead;

-- -----------------------------------------------------------------------------
-- Writing into Slave through write data bus 
-- -----------------------------------------------------------------------------
procedure ReportWrite (
                       constant Verbosity : in boolean;
                       constant data      : in std_logic_vector;
                       constant address   : in T_addr;
                       constant tag       : in string(1 to 20) 
                      ) is
variable printstr  : string(1 to 255);
begin
  if Verbosity then
    fprint(printstr, " %s: HSWC: Executed write transfer of %s at address %s"
           & " TAG : %s",
           to_string(now,"%6.1t ns"),
           To_HEXString(data),
           To_HexString(address),
           tag 
           );
    assert false
    report printstr
    severity note;
  end if;
end ReportWrite;

-- -----------------------------------------------------------------------------
-- Checks for extra transfers in a beat
-- -----------------------------------------------------------------------------
procedure ReportExtra(constant count: in T_int;
                      constant addr : in T_addr;
                      constant tag  : in string(1 to 20)) is 
  variable printstr  : string(1 to 255);
begin
  if (count = 4) then
    fprint(printstr,
        "%s: Extra: Extra transfer for four-beat burst Address: %s TAG: %s",
        to_string(now,"%6.1t ns"),
        To_HexString(addr),
        tag);
  elsif (count = 8) then
    fprint(printstr,
        "%s: Extra: Extra transfer for eight-beat burst Address: %s TAG: %s",
        to_string(now,"%6.1t ns"),
        To_HexString(addr),
        tag);
  elsif (count = 16) then
    fprint(printstr,
        "%s: Extra: Extra transfer for sixteen-beat burst Address: %s TAG: %s",
        to_string(now,"%6.1t ns"),
        To_HexString(addr),
        tag);
  end if;
  assert false
  report printstr
  severity note;
end ReportExtra; 

-- -----------------------------------------------------------------------------
-- Checks for reset getting asserted and deasserted
-- -----------------------------------------------------------------------------
procedure ReportReset(constant nres : in std_logic) is
begin
  if nres = '0' then
    assert false report "RESL: HRESETn asserted (LOW)" severity note;
  elsif nres = '1' then
    assert false report "RESH: HRESETn deasserted (HIGH)" severity note;
  end if;
end ReportReset;

function to_vec(sig : std_logic) return std_logic_vector is
begin
  case sig is
    when '1' => return ("1");
    when '0' => return ("0");
    when 'Z' => return ("Z");
    when others => return ("X");
  end case;
end to_vec;

-- -----------------------------------------------------------------------------
-- This block is responsible for driving data on appropriate bytelanes as
-- per the endianness. It takes endianness and HADDR bits as input and on the
-- basis of that, "puts" the data on the correct byte lane and drives the other
-- lanes to zero. Currently implemented for 64 bit wide data buses.
-- -----------------------------------------------------------------------------
function endianize (
                    data           : in T_data;
                    Endianness     : in std_logic_vector(1 downto 0);
                    size           : in T_size;
                    Databuswidth   : in integer;
                    address        : in T_addr;
                    ByteLaneDecidr : in std_logic_vector(2 downto 0)
                   ) return T_data is
variable EndnzdData : T_data;
begin
  if (Endianness = "10") then
    EndnzdData := data;
  -- if 64 bit data width then
  elsif (Databuswidth = 64) then  
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
          EndnzdData := ALLZEROES(63 downto 32) & data(15 downto 0) & 
                        ALLZEROES(15 downto 0);
        when "10" =>
          EndnzdData := ALLZEROES(63 downto 48) & data(15 downto 0) & 
                        ALLZEROES(31 downto 0);
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
      null;
    end if;
  --  else if 32 bit wide data bus
  elsif (Databuswidth = 32) then 
    if (size = "000") then
      -- transfer size is byte-size
      case ByteLaneDecidr(1 downto 0) is
        when "00" =>
          EndnzdData := ALLZEROES(63 downto 8) & data(7 downto 0);
        when "01" =>
          EndnzdData := ALLZEROES(63 downto 16) & data(7 downto 0) &
                        ALLZEROES(7 downto 0);
        when "10" =>
          EndnzdData := ALLZEROES(63 downto 24) & data(7 downto 0) &
                        ALLZEROES(15 downto 0);
        when "11" =>
          EndnzdData := ALLZEROES(63 downto 32) & data(7 downto 0) &
                        ALLZEROES(23 downto 0);
        when others =>
          null;
      end case;
    elsif (size = "001") then
    -- transfer size is halfword-size
      case ByteLaneDecidr(1) is
        when '0' =>
          EndnzdData := ALLZEROES(63 downto 16) & data(15 downto 0);
        when '1' =>
          EndnzdData := ALLZEROES(63 downto 32) & data(15 downto 0)
                        & ALLZEROES(15 downto 0);
        when others =>
          null;
      end case;
    elsif (size = "010") then
    -- transfer size is word-size
      EndnzdData := ALLZEROES(63 downto 32) & data(31 downto 0);
    else
      null;
    end if;
  end if;
  return EndnzdData;
end endianize;

-- -----------------------------------------------------------------------------
-- Returns std_logic values
-- -----------------------------------------------------------------------------
function from_vec(vec : std_logic_vector(0 downto 0)) return std_logic is
begin
  case vec is
    when "1" => return ('1');
    when "0" => return ('0');
    when "Z" => return ('Z');
    when others => return ('X');
  end case;
end from_vec;
    
-- -----------------------------------------------------------------------------
-- Checking response obtained from Slave with the expected response
-- -----------------------------------------------------------------------------
procedure Response (
                    HaltOnMismatch : boolean;
                    tag            : string(1 to 20);
                    addr           : T_addr;
                    resp           : std_logic_vector(1 downto 0);
                    HRESP          : std_logic_vector(1 downto 0);
                    num_cyc        : T_int;
                    HREADY         : std_logic;
                    supp_msg       : boolean
                    ) is
  variable errorstr : string(1 to 100);
  variable expstr   : string(1 to 10);
  variable actstr   : string(1 to 10);
begin
  
if (resp /= HRESP) then
  case HRESP is
      when "00" =>
        fprint (actstr,"OK");
      when "01" =>
        fprint (actstr,"ERROR");
      when "10" =>
        fprint (actstr,"RETRY");
      when "11" =>
        fprint (actstr,"SPLIT"); 
      when others =>
          fprint (actstr,"UNKNOWN"); 
      end case;
      case resp is
      when "00" =>
        fprint (expstr,"OK");
      when "01" =>
        fprint (expstr,"ERROR");
      when "10" =>
        fprint (expstr,"RETRY");
      when "11" =>
        fprint (expstr,"SPLIT");
      when others =>
        fprint (expstr,"UNKNOWN"); 
      end case;
      if (num_cyc > 0)  or (num_cyc = 0 and
         ((supp_msg and (( resp /= "00") or (resp = "00" and HRESP = "01"))) 
          or not(supp_msg)) and HREADY = '1') then
      fprint (errorstr,"RSPERR%s%s: Response error at address %s. Expected: %s,"
               & " Actual: %s, TAG: %s",To_HexString(resp),To_HexString(HRESP),
               To_HexString(addr),expstr,actstr, tag);  
      if HaltOnMismatch then
        assert false
        report errorstr
        severity failure;
      else
        assert false
        report errorstr
        severity warning;
      end if;
   end if;
  end if;
end Response;

-- -----------------------------------------------------------------------------
-- Checks VR read data bus for expected data
-- -----------------------------------------------------------------------------
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
    fprint(printstr, "VRE%s: Error on vector read from R%s. Expected: %s" &
           " Actual:"
          & " %s Mask: %s, TAG: %s",
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
    fprint(printstr, "VRC%s: Correct read value of %s with mask %s from R%s, "
          & "TAG :%s",
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

-- -----------------------------------------------------------------------------
-- Writing into VR
-- -----------------------------------------------------------------------------
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
end funcs;

-- ================================== End =================================== --
