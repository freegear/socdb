-- --=================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 2000-2001 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
--
-- ---------------------------------------------------------------------
-- Version and Release Control Information:
--
-- File Name              : buswmaster_pck.vhd.rca
-- File Revision          : 1.9
--
-- Release Information    : PrimeCell(TM)-PL092-REL1v1
--
-- ---------------------------------------------------------------------
-- Purpose :
--           Function/procedures package for the Master buswatcher 
--
-- --=================================================================--
 
library IEEE;
use     IEEE.std_logic_1164.all;

library common;
use     common.defsmaster.all;
use     common.funcsmaster.all;
use     common.funcs.all;
 
-- ---------------------------------------------------------------------

package buswmaster_pck is
function IsX (
              sig : std_logic
             ) return boolean;

function IsX (
              sig : std_logic_vector
             ) return boolean;

function NoOfBeatsIn (
                      sig : std_logic_vector(2 downto 0)
                     ) return integer;

function NoOfBytesIn (
                      sig : std_logic_vector(2 downto 0)
                     ) return integer;

procedure CheckForX (
                     SigName      : in string;
                     constant sig : in std_logic
                    );

procedure CheckForX (
                     SigName      : in string;
                     constant sig : in std_logic_vector
                    );

procedure CheckAddress (
                        HBURST   : in T_burst;
                        HSIZE    : in T_size;
                        HADDR    : in T_addr;
                        PrevAddr : in T_addr
                       );

procedure FlashAlignErr (
                         HADDR : in T_addr;
                         HSIZE : in T_size
                        );

procedure FlashHoldErr (
                        SigName : in string;
                        HADDR   : in std_logic_vector;
                        str1    : in string
                       );

procedure FlashValidErr (
                        SigName   : in string;
                        ExactEdge : in time;
                        str1      : in string
                       );
end buswmaster_pck;

-- ---------------------------------------------------------------------
--
--                             buswmaster_pck
--                             ==============
--
-- ---------------------------------------------------------------------
--
-- Overview
-- ========
-- o IsX function :- This take std_logic or std_logic_vector as input
--   and returns "true" if the value of input is X.
-- o CheckForX :- This procedure "screams" error, if there is X on its
--   argument signal.
-- o NoOfBeatsIn :- This function returns the no. of beats (as integer
--   value) by taking HBURST as argument.
-- o NoOfBytesIn :- This function gives the no. of bytes (as integer
--   value) by taking HSIZE as argument.
-- o CheckAddress :- This is an "involved" procedure, which checks
--   whether the address is "proper" or not, by looking at HADDR,
--   PrevAddr and control signals. This uses two more
--   functions - FlashWrapErr and ChkAddrNormal.
-- o FlashAlignErr, FlashHoldErr and FlashValidErr :- These functions
--   display the corresponding error messages. These take HADDR and one
--   string as their input argument. All functions assert a severity of
--   error.
 
-- --=========================== BODY ================================--
 
package body buswmaster_pck is

-- ---------------------------------------------------------------------
-- This function takes std_logic or std_logic_vector as input and
-- returns "true" if the value of input is X.
-- ---------------------------------------------------------------------
function IsX(sig : std_logic) return boolean is
variable j : boolean := FALSE;
begin
  j := j or (sig = 'X') or (sig = 'U');
  return j;
end IsX;
 
function IsX(sig : std_logic_vector) return boolean is
variable j : boolean := FALSE;
begin
  for i in sig'range loop
    j := j or (sig(i) = 'X') or (sig(i) = 'U');
  end loop;
  return j;
end IsX;

-- ---------------------------------------------------------------------
-- This function returns the no. of beats (as integer value) by taking
-- HBURST as argument.
-- ---------------------------------------------------------------------
function NoOfBeatsIn (sig : std_logic_vector(2 downto 0)) return integer is
variable j : integer;
begin
  case sig is
    when "000" =>
      j := 1;
      return j;
    when "001" =>
      j := 1;
      return j;
    when "010" =>
      j := 4;
      return j;
    when "011" =>
      j := 4;
      return j;
    when "100" =>
      j := 8;
      return j;
    when "101" =>
      j := 8;
      return j;
    when "110" =>
      j := 16;
      return j;
    when "111" =>
      j := 16;
      return j;
    when others =>
      j := 1;
      return j;
  end case;
end NoOfBeatsIn;

-- ---------------------------------------------------------------------
-- This function gives the no. of bytes (as integer value) by taking
-- HSIZE as argument.
-- ---------------------------------------------------------------------
function NoOfBytesIn (sig : std_logic_vector(2 downto 0))
         return integer is
variable j : integer;
begin
  case sig is
    when "000" =>
      j := 1;
      return j;
    when "001" =>
      j := 2;
      return j;
    when "010" =>
      j := 4;
      return j;
    when "011" =>
      j := 8;
      return j;
    when "100" =>
      j := 16;
      return j;
    when "101" =>
      j := 32;
      return j;
    when "110" =>
      j := 64;
      return j;
    when "111" =>
      j := 128;
      return j;
    when others =>
      j := 1;
      return j;
  end case;
end NoOfBytesIn;
 
-- ---------------------------------------------------------------------
-- It checks whether HADDR is correct as per the PrevAddr and HSIZE.
-- ---------------------------------------------------------------------
procedure ChkAddrNormal (
                         HADDR    : in T_addr;
                         HSIZE    : in T_size;
                         PrevAddr : in T_addr
                        ) is
variable PrintStr : string (1 to 255);
-- used to flash the error message during simulation

begin
  fprint(PrintStr, "BWERRHA : HADDR not incremented properly according to " &
         "HSIZE at HADDR : %s TIME : %s", To_HexString(HADDR), to_string(now));
  assert(to_integer(HADDR) = to_integer(PrevAddr) + NoOfBytesIn(HSIZE))
  report PrintStr
  severity error;
end ChkAddrNormal;

-- --------------------------------------------------------------------
-- Flashes error message if there is a wrap-error
-- ---------------------------------------------------------------------
procedure FlashWrapErr (HADDR : in T_addr) is
variable PrintStr : string (1 to 255);
-- used to flash the error message during simulation

begin
  fprint(PrintStr, "BWERRHA : Address wrapping is not correct at HADDR : %s. " &
         "TIME : %s", To_HexString(HADDR), to_string(now));
  assert false
  report PrintStr
  severity error;
end FlashWrapErr;

-- ---------------------------------------------------------------------
-- This procedure "screams" error, if there is X on its argument signal.
-- ---------------------------------------------------------------------
procedure CheckForX (
                     constant SigName : in string;
                     constant sig     : in std_logic
                    ) is
variable printstr : string (1 to 255);
-- used to flash the error message during simulation

begin
  fprint(printstr, "%sU : %s is unknown at TIME : %s", SigName,
         SigName, to_string(now));
  assert not (IsX(sig))
  report printstr
  severity error;
end CheckForX;

-- ---------------------------------------------------------------------
-- This procedure "screams" error, if there is X on its argument signal.
-- ---------------------------------------------------------------------
procedure CheckForX (
                     constant SigName : in string;
                     constant sig : in std_logic_vector
                    ) is
variable printstr : string (1 to 255);
-- used to flash the error message during simulation

begin
  fprint(printstr, "%sU : %s is unknown at TIME : %s", SigName,
         SigName, to_string(now));
  assert not (IsX(sig))
  report printstr
  severity error;
end CheckForX;

-- ---------------------------------------------------------------------
-- This is an "involved" procedure, which checks whether the address is 
-- "proper" or not, by looking at HADDR, PrevAddr and control signals.
-- This uses two more functions - FlashWrapErr and ChkAddrNormal.
-- ---------------------------------------------------------------------
procedure CheckAddress (
                        HBURST   : in T_burst;
                        HSIZE    : in T_size;
                        HADDR    : in T_addr;
                        PrevAddr : in T_addr
                       ) is
begin
  if (HBURST = "010") then
    case HSIZE is
      when "000" =>
        if ((PrevAddr(1 downto 0) = "11")) then
          if ((HADDR(10 downto 2) /= PrevAddr(10 downto 2)) or
              (HADDR(1 downto 0) /= "00")) then
            FlashWrapErr(HADDR);
          end if;
        else
          ChkAddrNormal(HADDR, HSIZE, PrevAddr);
        end if;
      when "001" =>
        if ((PrevAddr(2 downto 1) = "11")) then
          if (HADDR(10 downto 3) /= PrevAddr(10 downto 3)) or
              (HADDR(2 downto 1) /= "00") then
            FlashWrapErr(HADDR);
          end if;
        else
          ChkAddrNormal(HADDR, HSIZE, PrevAddr);
        end if;
      when "010" =>
        if ((PrevAddr(3 downto 2) = "11")) then
          if (HADDR(10 downto 4) /= PrevAddr(10 downto 4)) or
              (HADDR(3 downto 2) /= "00") then
            FlashWrapErr(HADDR);
          end if;
        else
          ChkAddrNormal(HADDR, HSIZE, PrevAddr);
        end if;
      when "011" =>
        if ((PrevAddr(4 downto 3) = "11")) then
          if ((HADDR(10 downto 5) /= PrevAddr(10 downto 5)) or
              (HADDR(4 downto 3) /= "00")) then
            FlashWrapErr(HADDR);
          end if;
        else
          ChkAddrNormal(HADDR, HSIZE, PrevAddr);
        end if;
      when "100" =>
        if ((PrevAddr(5 downto 4) = "11")) then
          if ((HADDR(10 downto 6) /= PrevAddr(10 downto 6)) or
              (HADDR(5 downto 4) /= "00")) then
            FlashWrapErr(HADDR);
          end if;
        else
          ChkAddrNormal(HADDR, HSIZE, PrevAddr);
        end if;
      when "101" =>
        if ((PrevAddr(6 downto 5) = "11")) then
          if ((HADDR(10 downto 7) /= PrevAddr(10 downto 7)) or
              (HADDR(6 downto 5) /= "00")) then
            FlashWrapErr(HADDR);
          end if;
        else
          ChkAddrNormal(HADDR, HSIZE, PrevAddr);
        end if;
      when "110" =>
        if ((PrevAddr(7 downto 6) = "11")) then
          if ((HADDR(10 downto 8) /= PrevAddr(10 downto 8)) or
              (HADDR(7 downto 6) /= "00")) then
            FlashWrapErr(HADDR);
          end if;
        else
          ChkAddrNormal(HADDR, HSIZE, PrevAddr);
        end if;
      when "111" =>
        if ((PrevAddr(8 downto 7) = "11")) then
          if ((HADDR(10 downto 9) /= PrevAddr(10 downto 9)) or
              (HADDR(8 downto 7) /= "00")) then
            FlashWrapErr(HADDR);
          end if;
        else
          ChkAddrNormal(HADDR, HSIZE, PrevAddr);
        end if;
      when others =>
        null;
    end case;
  elsif (HBURST = "100") then
        case HSIZE is
          when "000" =>
            if ((PrevAddr(2 downto 0) = "111")) then
              if ((PrevAddr(10 downto 3) /= HADDR(10 downto 3)) or
                  (HADDR(2 downto 0) /= "000")) then
                FlashWrapErr(HADDR);
              end if;
            else
              ChkAddrNormal(HADDR, HSIZE, PrevAddr);
            end if;
          when "001" =>
            if ((PrevAddr(3 downto 1) = "111")) then
              if ((PrevAddr(10 downto 4) /= HADDR(10 downto 4)) or
                  (HADDR(3 downto 1) /= "000")) then
                FlashWrapErr(HADDR);
              end if;
            else
              ChkAddrNormal(HADDR, HSIZE, PrevAddr);
            end if;
          when "010" =>
            if ((PrevAddr(4 downto 2) = "111")) then
              if ((PrevAddr(10 downto 5) /= HADDR(10 downto 5)) or
                  (HADDR(4 downto 2) /= "000")) then
                FlashWrapErr(HADDR);
              end if;
            else
              ChkAddrNormal(HADDR, HSIZE, PrevAddr);
            end if;
          when "011" =>
            if ((PrevAddr(5 downto 3) = "111")) then
              if ((PrevAddr(10 downto 6) /= HADDR(10 downto 6)) or
                  (HADDR(5 downto 3) /= "000")) then
                FlashWrapErr(HADDR);
              end if;
            else
              ChkAddrNormal(HADDR, HSIZE, PrevAddr);
            end if;
          when "100" =>
            if ((PrevAddr(6 downto 4) = "111")) then
              if ((PrevAddr(10 downto 7) /= HADDR(10 downto 7)) or
                  (HADDR(6 downto 4) /= "000")) then
                FlashWrapErr(HADDR);
              end if;
            else
              ChkAddrNormal(HADDR, HSIZE, PrevAddr);
            end if;
          when "101" =>
            if ((PrevAddr(7 downto 5) = "111")) then
              if ((PrevAddr(10 downto 8) /= HADDR(10 downto 8)) or
                  (HADDR(7 downto 5) /= "000")) then
                FlashWrapErr(HADDR);
              end if;
            else
              ChkAddrNormal(HADDR, HSIZE, PrevAddr);
            end if;
          when "110" =>
            if ((PrevAddr(8 downto 6) = "111")) then
              if ((PrevAddr(10 downto 9) /= HADDR(10 downto 9)) or
                  (HADDR(8 downto 6) /= "000")) then
                FlashWrapErr(HADDR);
              end if;
            else
              ChkAddrNormal(HADDR, HSIZE, PrevAddr);
            end if;
          when "111" =>
            if ((PrevAddr(9 downto 7) = "111")) then
              if ((PrevAddr(10) /= HADDR(10)) or
                  (HADDR(9 downto 7) /= "000")) then
                FlashWrapErr(HADDR);
              end if;
            else
              ChkAddrNormal(HADDR, HSIZE, PrevAddr);
            end if;
          when others =>
            null;
        end case;
  elsif (HBURST = "110") then
        case HSIZE is
          when "000" =>
            if ((PrevAddr(3 downto 0) = "1111")) then
              if ((PrevAddr(10 downto 4) /= HADDR(10 downto 4)) or
                  (HADDR(3 downto 0) /= "0000")) then
                FlashWrapErr(HADDR);
              end if;
            else
              ChkAddrNormal(HADDR, HSIZE, PrevAddr);
            end if;
          when "001" =>
            if ((PrevAddr(4 downto 1) = "1111")) then
              if ((PrevAddr(10 downto 5) /= HADDR(10 downto 5)) or
                  (HADDR(4 downto 1) /= "0000")) then
                FlashWrapErr(HADDR);
              end if;
            else
              ChkAddrNormal(HADDR, HSIZE, PrevAddr);
            end if;
          when "010" =>
            if ((PrevAddr(5 downto 2) = "1111")) then
              if ((PrevAddr(10 downto 6) /= HADDR(10 downto 6)) or
                  (HADDR(5 downto 2) /= "0000")) then
                FlashWrapErr(HADDR);
              end if;
            else
              ChkAddrNormal(HADDR, HSIZE, PrevAddr);
            end if;
          when "011" =>
            if ((PrevAddr(6 downto 3) = "1111")) then
              if ((PrevAddr(10 downto 7) /= HADDR(10 downto 7)) or
                  (HADDR(6 downto 3) /= "0000")) then
                FlashWrapErr(HADDR);
              end if;
            else
              ChkAddrNormal(HADDR, HSIZE, PrevAddr);
            end if;
          when "100" =>
            if ((PrevAddr(7 downto 4) = "1111")) then
              if ((PrevAddr(10 downto 8) /= HADDR(10 downto 8)) or
                  (HADDR(7 downto 4) /= "0000")) then
                FlashWrapErr(HADDR);
              end if;
            else
              ChkAddrNormal(HADDR, HSIZE, PrevAddr);
            end if;
          when "101" =>
            if ((PrevAddr(8 downto 5) = "1111")) then
              if ((PrevAddr(10 downto 9) /= HADDR(10 downto 9)) or
                  (HADDR(8 downto 5) /= "0000")) then
                FlashWrapErr(HADDR);
              end if;
            else
              ChkAddrNormal(HADDR, HSIZE, PrevAddr);
            end if;
          when "110" =>
            if ((PrevAddr(9 downto 6) = "1111")) then
              if ((PrevAddr(10) /= HADDR(10)) or
                  (HADDR(9 downto 6) /= "0000")) then
                FlashWrapErr(HADDR);
              end if;
            else
              ChkAddrNormal(HADDR, HSIZE, PrevAddr);
            end if;
          when "111" =>
            -- illegal stage, however the address-checking is done
            if ((PrevAddr(10 downto 7) = "1111")) then
              if ((HADDR(10 downto 7) /= "0000")) then
                FlashWrapErr(HADDR);
              end if;
            else
              ChkAddrNormal(HADDR, HSIZE, PrevAddr);
            end if;
          when others =>
            null;
        end case;
  else
    ChkAddrNormal(HADDR, HSIZE, PrevAddr);
  end if;
end CheckAddress;

-- ---------------------------------------------------------------------
-- Flashes if there is an address misalignment error.
-- ---------------------------------------------------------------------
procedure FlashAlignErr (
                         HADDR : in T_addr;
                         HSIZE : in T_size
                        ) is
variable PrintStr : string(1 to 255);
-- used to flash the error message during simulation

begin
  fprint(PrintStr, "BWERRHAM : Address is misaligned for HSIZE %s at HADDR :" &
         " %s at TIME : %s",
         To_HexString(HSIZE), To_HexString(HADDR), to_string(now));
  assert false
  report PrintStr
  severity error;
end FlashAlignErr;

-- ---------------------------------------------------------------------
-- Flashes the error for hold time violation.
-- ---------------------------------------------------------------------
procedure FlashHoldErr (
                        SigName : in string;
                        HADDR   : in std_logic_vector;
                        str1    : in string
                       ) is
variable PrintStr : string(1 to 255);
-- used to flash the error message during simulation

begin
  fprint(PrintStr, "(%s) : Hold time violation on %s signal. HADDR : " &
         "%s. TIME : %s", str1, SigName, To_HexString(HADDR), to_string(now));
  assert false
  report PrintStr
  severity error;
end FlashHoldErr;
                        
-- ---------------------------------------------------------------------
-- Flashes the error for valid time violation.
-- ---------------------------------------------------------------------
procedure FlashValidErr (
                         SigName   : in string;
                         ExactEdge : in time;
                         str1      : in string
                        ) is
variable PrintStr : string(1 to 255);
-- used to flash the error message during simulation

begin
  fprint(PrintStr, "(%s) : Valid time violation on %s at TIME  %s",
         str1, SigName,  to_string(ExactEdge));
  assert false
  report PrintStr
  severity error;
end FlashValidErr;

end buswmaster_pck;

-- --============================= End ===============================--
