-- --=========================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 2000-2001 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
--
-- -----------------------------------------------------------------------------
-- Version and Release Control Information:
--
-- File Name              : DmacTrPackage.vhd.rca
-- File Revision          : 1.3
--
-- Release Information    : PrimeCell(TM)-PL081-REL1v0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           DMAC Trickbox Parameter definitions
--
-- --=========================================================================--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

library std;
use std.textio.all;

package DmacTrPackage is

constant ZEROFILL          : std_logic_vector(14 downto 0)
                                                := "000000000000000";
-- DMATCINTSTA at offset 0x008

constant NO_OF_REG         : integer := 64;
-- Number of register in memory or peripheral module.

constant MEMORYDEPTH       : integer := 16;
-- To define depth of LLI memory block

constant SLAVEADDRLB       : integer := 2;
-- Lower bit of Slave address used by memory or peripheral module.

constant SLAVEADDRHB       : integer := 9;
-- Higher bit of Slave address used by memory or peripheral module.

constant MASTERADDRLB      : integer := 0;
-- Lower bit of Slave address used by memory or peripheral module.

constant MASTERADDRHB      : integer := 26;
-- Higher bit of Slave address used by memory or peripheral module.

-- -----------------------------------------------------------------------------
-- Definitions for AHB slave reponses
-- -----------------------------------------------------------------------------
constant OKAY_RESP         : std_logic_vector(1 downto 0) := "00";
constant ERROR_RESP        : std_logic_vector(1 downto 0) := "01";
constant RETRY_RESP        : std_logic_vector(1 downto 0) := "10";
constant SPLIT_RESP        : std_logic_vector(1 downto 0) := "11";

-- -----------------------------------------------------------------------------
-- Definitions for different AHB HTRANS transactions
-- -----------------------------------------------------------------------------
constant IDLE              : std_logic_vector(1 downto 0) := "00";
constant BUSY              : std_logic_vector(1 downto 0) := "01";
constant NSEQ              : std_logic_vector(1 downto 0) := "10";
constant SEQ               : std_logic_vector(1 downto 0) := "11";
-- -----------------------------------------------------------------------------
-- Definitions for different size AHB accesses on HSIZE line
-- -----------------------------------------------------------------------------
constant BYTE              : std_logic_vector(2 downto 0) := "000";
constant HWORD             : std_logic_vector(2 downto 0) := "001";
constant WORD              : std_logic_vector(2 downto 0) := "010";

-- -----------------------------------------------------------------------------
-- Definitions for different AHB Burst accesses on HBURST lines
-- -----------------------------------------------------------------------------
constant UINCR             : std_logic_vector(2 downto 0) := "001";
constant WRAP4             : std_logic_vector(2 downto 0) := "010";
constant INCR4             : std_logic_vector(2 downto 0) := "011";
constant WRAP8             : std_logic_vector(2 downto 0) := "100";
constant INCR8             : std_logic_vector(2 downto 0) := "101";
constant WRAP16            : std_logic_vector(2 downto 0) := "110";
constant INCR16            : std_logic_vector(2 downto 0) := "111";
 
-- -----------------------------------------------------------------------------
-- Definitions for generation of data from address pattern
-- -----------------------------------------------------------------------------
constant INCREMENT         : std_logic_vector(1 downto 0) := "00";
constant DECREMENT         : std_logic_vector(1 downto 0) := "01";
constant ONESCOMP          : std_logic_vector(1 downto 0) := "10";
constant TWOSCOMP          : std_logic_vector(1 downto 0) := "11";

-- -----------------------------------------------------------------------------
-- Definitions for different data patterns
-- -----------------------------------------------------------------------------
constant RANDOM            : std_logic_vector(1 downto 0) := "00";
constant GRAYCODE          : std_logic_vector(1 downto 0) := "01";
constant ADDRESSBASED      : std_logic_vector(1 downto 0) := "10";
constant DATABASED         : std_logic_vector(1 downto 0) := "11";

constant max_string_len    : integer := 256;
-- Max length of string that can be handled by the To_String function

constant max_token_len     : integer := 32;
-- Max length of token that can be handled by the To_String function

-- -----------------------------------------------------------------------------
-- Function Definition
-- -----------------------------------------------------------------------------
function AddrBasedGen (Address : in std_logic_vector(7 downto 0);
                       Diff    : in std_logic_vector(3 downto 0);
                       method  : in std_logic_vector(1 downto 0)
                      )
                return std_logic_vector;  

function DataBasedGen (Data    : in std_logic_vector(7 downto 0);
                       Diff    : in std_logic_vector(3 downto 0);
                       method  : in std_logic_vector(1 downto 0)
                      )
                return std_logic_vector;  

function GrayDataGen (PreviousData   : in std_logic_vector(7 downto 0)
                      )
                return std_logic_vector;  

function PRBSDataGen (PRBSData   : in std_logic_vector(7 downto 0)
                      )
                return std_logic_vector;  

function to_integer (
         val : std_logic_vector;
         x   : integer := 0
                    ) return integer;

function To_HexString(
         constant val : in std_logic_vector
                      ) return string;

procedure fprint (
                  variable string_buf    : out string;
                  constant format        : in string;
                  constant arg1          : in string := "";
                  constant arg2          : in string := "";
                  constant arg3          : in string := "";
                  constant arg4          : in string := "";
                  constant arg5          : in string := "";
                  constant arg6          : in string := "";
                  constant arg7          : in string := "";
                  constant arg8          : in string := "";
                  constant arg9          : in string := "";
                  constant arg10         : in string := ""
                 );
end DmacTrPackage; 

package body DmacTrPackage is

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
-- Function to generate address based data. 
-- -----------------------------------------------------------------------------
  function AddrBasedGen (Address : in std_logic_vector(7 downto 0);
                         Diff    : in std_logic_vector(3 downto 0);
                         method  : in std_logic_vector(1 downto 0)
                        )
                return std_logic_vector is 
  variable Result : std_logic_vector(7 downto 0);
  begin
    case method is
      when INCREMENT =>
            Result := (Address + Diff);
      when DECREMENT =>
            Result := (Address - Diff);
      when ONESCOMP  =>
            Result := (not Address);
      when TWOSCOMP  =>
            Result := ((not Address)+1);
      when others    =>
            Result := ((others => '0'));
    end case;
    return Result;
  end AddrBasedGen;
  
-- -----------------------------------------------------------------------------
-- Function to generate data using input data passed to function. 
-- -----------------------------------------------------------------------------
  function DataBasedGen (Data    : in std_logic_vector(7 downto 0);
                         Diff    : in std_logic_vector(3 downto 0);
                         method  : in std_logic_vector(1 downto 0)
                        )
                return std_logic_vector is
  variable Result : std_logic_vector(7 downto 0);
  begin
    case method is
      when INCREMENT =>
            Result := unsigned(Data) + unsigned(Diff);
      when DECREMENT =>
            Result := unsigned(Data) - unsigned(Diff);
      when others    =>
            Result := ((others => '0'));
    end case;
    return Result;
  end DataBasedGen;

-- -----------------------------------------------------------------------------
-- function to generate gray code data. 
-- -----------------------------------------------------------------------------
  function GrayDataGen (PreviousData : in std_logic_vector(7 downto 0)
                       )
                return std_logic_vector is 
  variable width             : integer := 8; 
  variable temp              : std_logic_vector(7 downto 0);
  variable Hold              : std_logic_vector(7 downto 0) := (others =>'0');
  begin
    temp              :=  PreviousData;
    Hold(width - 1)   := temp(width -1); 
    P1 :  for i in (width - 2) downto 0 loop
            Hold(i) := temp(i+1) xor temp(i);
          end loop P1;

   return Hold;
   end GrayDataGen;

-- -----------------------------------------------------------------------------
-- function to generate PRBS data. 
-- -----------------------------------------------------------------------------
  function PRBSDataGen (PRBSData   : in std_logic_vector(7 downto 0)
                     )
                return std_logic_vector is 
  variable Result : std_logic_vector(7 downto 0);
  variable RndBit : std_logic;
  begin
    RndBit            := PRBSData(7) xor PRBSData(4) xor PRBSData(1);
    Result            := PRBSData(6 downto 0) & RndBit;
    return Result;
  end PRBSDataGen;          

-- -----------------------------------------------------------------------------
-- function to convert vector to integer.
-- -----------------------------------------------------------------------------
function to_integer (
         val : std_logic_vector;
         x   : integer := 0
                    ) return integer is
  variable returnint : integer;
  -- Return variable from the function
  variable xtmp      : integer;
  -- Temporary variable
 begin
  returnint := 0;
  xtmp := 0;
  if x /= 0 then
    xtmp := 1;
  end if;
  for i in val'range loop
    returnint := returnint + returnint;
      case val(i) is
        when '0'    => null;
        when '1'    => returnint := returnint + 1;
        when others => returnint := returnint + xtmp;
      end case;
  end loop;
  return returnint;
 end to_integer;

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
-- Function to display text messages
-- -----------------------------------------------------------------------------
procedure fprint    ( variable string_buf    : out string;
                      constant format        : in string;
                      constant arg1          : in string := "";
                      constant arg2          : in string := "";
                      constant arg3          : in string := "";
                      constant arg4          : in string := "";
                      constant arg5          : in string := "";
                      constant arg6          : in string := "";
                      constant arg7          : in string := "";
                      constant arg8          : in string := "";
                      constant arg9          : in string := "" ;
                      constant arg10         : in string := ""
                     ) is
  variable tempbuf    : string(1 to string_buf'length);
  variable rbuf       : line;
  variable arg        : string(1 to max_string_len);
  variable fmt        : string(1 to format'length) := format;
  variable index      : integer := 0;
  variable buf_indx   : integer := 0;
  variable ch         : character;
  variable lookahead  : character;
  variable tokn       : string(1 to max_token_len);
  variable ArgNum     : integer range 1 to 11;

begin
-- check for null format string
  if (format'length = 0) then
     assert false
     report " fprint --- format string is null "
     severity Error;
     return;
  end if;
  index := 0;
  ArgNum := 1;
  while (true) loop
    index := index + 1;
    buf_indx := buf_indx + 1;
    ch := fmt(index);
    if (index < format'length) then
      lookahead := fmt(index+1);
    else
      lookahead := ' ';
    end if;
    if (( ch = '%') and (lookahead = '%'))  then
      write(rbuf,ch);
      index := index + 1;            -- print % character
    elsif ((ch = '\') and (lookahead ='n')) then   -- new line
      ch := LF;
      write(rbuf,ch);
      index := index + 1;
    elsif (ch = '%') and (lookahead /= '%') then
                                                 -- format %s expected
      exit when (ArgNum > 10); -- only first 10 argments will be printed
      tokn := (others => ' ');     -- fill token with blank space
               --   select argument number 1 to 10
      case ArgNum IS
        when 1 =>
          if (arg1 /= "") then
            write(rbuf,arg1);
            index := index + 1;
          else
            exit;
          end if;
        when 2 =>
          if (arg2 /= "") then
            write(rbuf,arg2);
            index := index + 1;
          else
            exit;
          end if;
        when 3 =>
          if (arg3 /= "") then
            write(rbuf,arg3);
            index := index + 1;
          else
            exit;
          end if;
        when 4 =>
          if (arg4 /= "") then
            write(rbuf,arg4);
            index := index + 1;
          else
            exit;
          end if;
        when 5 =>
          if (arg5 /= "") then
            write(rbuf,arg5);
            index := index + 1;
          else
            exit;
          end if;
        when 6 =>
          if (arg6 /= "") then
            write(rbuf,arg6);
            index := index + 1;
          else
            exit;
          end if;
        when 7 =>
          if (arg7 /= "") then
            write(rbuf,arg7);
            index := index + 1;
          else
            exit;
          end if;
        when 8 =>
          if (arg8 /= "") then
            write(rbuf,arg8);
            index := index + 1;
          else
            exit;
          end if;
        when 9 =>
          if (arg9 /= "") then
            write(rbuf,arg9);
            index := index + 1;
          else
            exit;
          end if;
        when 10 =>
          if (arg10 /= "") then
            write(rbuf,arg10);
            index := index + 1;
          else
            exit;
          end if;
        when 11 => -- should not happen
          assert false
            report "fprint -- String buffer, arguments > 10 "
            severity error;
      end case;
-- increment the argument number
      ArgNum := ArgNum + 1;

    elsif (ch /= '%') then        -- printable characters
      write(rbuf,ch);
    end if;
    exit when ((index >= format'length) or
               ( buf_indx >= string_buf'length)) ;
  end loop;                                --  end of while true loop
  if (buf_indx > string_buf'length) then
    string_buf := rbuf.all;
  elsif (buf_indx = string_buf'length) then
    string_buf := rbuf.all;
  else
    buf_indx := rbuf'length;
    string_buf(1 TO buf_indx) := rbuf.all;
  end if;
  deallocate(rbuf);
  return;
end fprint;

end DmacTrPackage; 
-- --====================================== End ==============================--
