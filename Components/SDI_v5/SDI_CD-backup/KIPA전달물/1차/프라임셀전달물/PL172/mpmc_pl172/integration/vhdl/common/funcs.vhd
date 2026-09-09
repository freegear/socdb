-- --=========================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 2001-2002 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
--
-- -----------------------------------------------------------------------------
-- Version and Release Control Information:
--
-- File Name              : funcs.vhd.rca
-- File Revision          : 1.6
--
-- Release Information    : PrimeCell(TM)-PL172-r2p3-00rel0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           This contains the functions/procedures (except readline,
--           which I deemed important enough to have its own file).
--           to_vec and from_vec convert length 1 std_logic_vectors to
--           std_logic and vice-versa for use in the generic width
--           addr_driver.
--
-- --=========================================================================--

library IEEE;
use     IEEE.std_logic_1164.all;
use     IEEE.std_logic_arith.all;

library std;
use     std.textio.all;

library common;
use     common.defs.all;

-- -----------------------------------------------------------------------------

package funcs is
function to_vec(sig : std_logic) return std_logic_vector;
function from_vec(vec : std_logic_vector(0 downto 0)) return std_logic;
function To_HexString(constant val : in std_logic_vector) return string;
function From_HexString(constant str : in string) return bit_vector;
function From_String(constant str : in string) return integer;
function To_Integer(constant SrcReg : in bit_vector;
                    constant SrcRegMode : in regmode_type := normal
                   ) return integer;
function To_Integer(constant SrcReg : in std_logic_vector;
                    constant SrcRegMode : in regmode_type := normal
                   ) return integer;
function endianize (
                    data           : in T_data;
                    Endianness     : in std_logic_vector(1 downto 0);
                    size           : in T_size;
                    Databuswidth   : in integer;
                    address        : in T_addr;
                    ByteLaneDecidr : in std_logic_vector(2 downto 0)
                   ) return T_data;
function To_String ( constant val    : in time) return string;
function To_String (
                    constant val    : in integer;
                    constant format : in string := "%d"
                   ) return string;
function To_String ( constant val    : in std_ulogic) return string;
 
procedure ReportRead(
                     constant Verbosity      : in boolean;
                     constant HaltOnMismatch : in boolean;
                     constant data           : in std_logic_vector;
                     constant mask           : in std_logic_vector;
                     constant address        : in T_addr; 
                     signal Pollstart        : in std_logic;
                     signal delPollstart     : in std_logic;
                     signal Pollend          : inout std_logic;
                     signal Pidle            : in std_logic;
                     signal Maxflagpoll      : in boolean;
                     signal pocount          : in std_logic_vector;
                     signal countflag        : in boolean;
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
procedure fgetline (
                    variable l_str   : out string;
                    variable stream  : in ascii_text
                   );
procedure StrCpy (
                  variable l_str : out string;
                  constant r_str : in  string
                 );
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
procedure fscan (
                 constant string_buf     : in string;
                 constant format         : in string;
                 variable arg1           : out string;
                 variable arg2           : out string;
                 variable arg3           : out string;
                 variable arg4           : out string;
                 variable arg5           : out string;
                 variable arg6           : out string;
                 variable arg7           : out string;
                 variable arg8           : out string;
                 variable arg9           : out string;
                 variable arg10          : out string;
                 variable arg11          : out string;
                 variable arg12          : out string;
                 variable arg13          : out string;
                 variable arg14          : out string;
                 variable arg15          : out string;
                 variable arg16          : out string;
                 variable arg17          : out string;
                 variable arg18          : out string;
                 variable arg19          : out string;
                 constant arg_count      : in integer := 19
                );
procedure fscan (
                 constant string_buf     : in string;
                 constant format         : in string;
                 variable arg1           : out string;
                 variable arg2           : out string;
                 variable arg3           : out string;
                 variable arg4           : out string;
                 variable arg5           : out string;
                 variable arg6           : out string;
                 variable arg7           : out string;
                 variable arg8           : out string;
                 variable arg9           : out string;
                 variable arg10          : out string;
                 variable arg11          : out string;
                 variable arg12          : out string;
                 variable arg13          : out string;
                 variable arg14          : out string;
                 variable arg15          : out string;
                 variable arg16          : out string;
                 variable arg17          : out string;
                 variable arg18          : out string
                );
procedure fscan (
                 constant string_buf     : in string;
                 constant format         : in string;
                 variable arg1           : out string;
                 variable arg2           : out string;
                 variable arg3           : out string;
                 variable arg4           : out string;
                 variable arg5           : out string;
                 variable arg6           : out string;
                 variable arg7           : out string;
                 variable arg8           : out string;
                 variable arg9           : out string;
                 variable arg10          : out string;
                 variable arg11          : out string;
                 variable arg12          : out string;
                 variable arg13          : out string;
                 variable arg14          : out string;
                 variable arg15          : out string;
                 variable arg16          : out string;
                 variable arg17          : out string
                );
procedure fscan (
                 constant string_buf     : in string;
                 constant format         : in string;
                 variable arg1           : out string;
                 variable arg2           : out string;
                 variable arg3           : out string;
                 variable arg4           : out string;
                 variable arg5           : out string;
                 variable arg6           : out string;
                 variable arg7           : out string;
                 variable arg8           : out string;
                 variable arg9           : out string;
                 variable arg10          : out string;
                 variable arg11          : out string;
                 variable arg12          : out string;
                 variable arg13          : out string;
                 variable arg14          : out string;
                 variable arg15          : out string;
                 variable arg16          : out string
                );
procedure fscan (
                 constant string_buf     : in string;
                 constant format         : in string;
                 variable arg1           : out string;
                 variable arg2           : out string;
                 variable arg3           : out string;
                 variable arg4           : out string;
                 variable arg5           : out string;
                 variable arg6           : out string;
                 variable arg7           : out string
                );
procedure fscan (
                 constant string_buf     : in string;
                 constant format         : in string;
                 variable arg1           : out string;
                 variable arg2           : out string;
                 variable arg3           : out string;
                 variable arg4           : out string;
                 variable arg5           : out string;
                 variable arg6           : out string
                );
procedure fscan (
                 constant string_buf     : in string;
                 constant format         : in string;
                 variable arg1           : out string;
                 variable arg2           : out string;
                 variable arg3           : out string;
                 variable arg4           : out string
                ); 
procedure fscan (
                 constant string_buf     : in string;
                 constant format         : in string;
                 variable arg1           : out string;
                 variable arg2           : out string
                );
procedure fscan (
                 constant string_buf     : in string;
                 constant format         : in string;
                 variable arg1           : out string
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
--   This module contains some functions for checking the data in the
-- read bus as well as for driving the data according to the endianness
-- of the system it is driving. It also have some functions for
-- printing out any string.d
-- 
-- --================================ BODY ===================================--
 
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
function To_String ( constant val    : in time) return string is
  variable temp    : line;
  variable temptime    : time;
begin
  temptime := val;
  write(temp,temptime);
  return temp.all;
end;

-- -----------------------------------------------------------------------------
function To_String ( constant val    : in std_ulogic) return string is
  variable temp          : line;
  variable tempvector    : bit;
begin
  tempvector := To_bit(val);
  write(temp,tempvector);
  return temp.all;
end;

-- -----------------------------------------------------------------------------
function To_String ( constant val    : in integer;
                     constant format : in string := "%d"
                   ) return string is
  variable buf        : string(max_string_len downto 1) ;
                                                  -- implicitly == NUL
  variable rbuf       : string(max_string_len downto 1) ;
  variable str_index  : integer := 0;
  variable ival       : integer;
  variable format_cpy : string(1 to format'length) := format;
  variable fw         : integer;  -- field width
  variable precis     : integer;
  variable justy      : bit := '0';
begin
-- convert to positive number
  ival := ABS(val);
  if (ival = 0) then
    str_index := str_index + 1;
    buf(str_index) := '0';
  else
    int_loop : loop
      str_index := str_index + 1;
      case (ival mod 10) is
        when 0 => buf (str_index) := '0';
        when 1 => buf (str_index) := '1';
        when 2 => buf (str_index) := '2';
        when 3 => buf (str_index) := '3';
        when 4 => buf (str_index) := '4';
        when 5 => buf (str_index) := '5';
        when 6 => buf (str_index) := '6';
        when 7 => buf (str_index) := '7';
        when 8 => buf (str_index) := '8';
        when 9 => buf (str_index) := '9';
        when others => null; -- do nothing
      end case;
      ival := ival / 10;
      exit int_loop when ival=0;
    end loop;
  end if;
-- Handle the negative numbers here...
  if val < 0 then
    str_index := str_index + 1;
    buf (str_index) := '-';
  end if;
  return buf(str_index downto 1);
end;

-- -----------------------------------------------------------------------------
function  Is_Space (constant c    : in character
                   ) return boolean is
  variable result : boolean;
begin
  if (c = ' ' or   c = HT ) then
    result := TRUE;
  else
    result := FALSE;
  end if;
  return result;
end;

-- -----------------------------------------------------------------------------
function  Is_White(constant c    : in character
                  ) return boolean is
  variable result : boolean;
begin
  if ( (c = ' ') or (c = HT)  or (c = CR) or (c=LF) ) then
    result := TRUE;
  else
    result := FALSE;
  end if;
  return result;
end;

-- -----------------------------------------------------------------------------
function  Is_Digit( constant c    : in character
                  ) return boolean is
  variable result : boolean;
begin
  if (c >= '0' and c <= '9') then
    result := TRUE;
  else
    result := FALSE;
  end if;
  return result;
end;

-- -----------------------------------------------------------------------------
function Find_NonBlank(constant str_in   : in string;
                       constant index    : in natural
                      ) return natural is
  variable ch       :  character;
  variable indx     :  integer := index;
begin
  loop
    exit when ( (indx > str_in'length) or (str_in(indx) = NUL) );
    if Is_White(str_in(indx)) then
      indx := indx + 1;
    else
      exit;
    end if;
  end loop;
  return indx;
end;

-- -----------------------------------------------------------------------------
function  To_Upper( constant  val    : in string
                  ) return string is
  variable result   : string (1 to val'length) := val;
  variable ch       : character;
begin
  for i in 1 to val'length loop
    ch := result(i);
    exit when ((ch = NUL) or (ch = nul));
    if ( ch >= 'a' and ch <= 'z') then
      result(i) := character'val( character'pos(ch) -
                   character'pos('a') + character'pos('A') );
    end if;
  end loop;
  return result;
end;

-- -----------------------------------------------------------------------------
function From_HexString( constant str   : in string)
                        return bit_vector is
  constant len          : Integer := 4 * str'length;
  constant hex_dig_len  : Integer := 4;
  variable str_copy     : string (1 to str'length) := To_Upper(str);
  variable index        : Natural;
  variable ch           : character;
  variable i, idx       : Integer;
  variable invalid      : boolean := false;
  variable r            : bit_vector(1 to len) ;
  variable result       : bit_vector(len - 1 downto 0);
  constant bin_zero     : bit_vector(1 to 4) := "0000";
  constant bin_one      : bit_vector(1 to 4) := "0001";
  constant bin_two      : bit_vector(1 to 4) := "0010";
  constant bin_three    : bit_vector(1 to 4) := "0011";
  constant bin_four     : bit_vector(1 to 4) := "0100";
  constant bin_five     : bit_vector(1 to 4) := "0101";
  constant bin_six      : bit_vector(1 to 4) := "0110";
  constant bin_seven    : bit_vector(1 to 4) := "0111";
  constant bin_eight    : bit_vector(1 to 4) := "1000";
  constant bin_nine     : bit_vector(1 to 4) := "1001";
  constant bin_ten      : bit_vector(1 to 4) := "1010";
  constant bin_eleven   : bit_vector(1 to 4) := "1011";
  constant bin_twelve   : bit_vector(1 to 4) := "1100";
  constant bin_thirteen : bit_vector(1 to 4) := "1101";
  constant bin_fourteen : bit_vector(1 to 4) := "1110";
  constant bin_fifteen  : bit_vector(1 to 4) := "1111";
begin
-- Check for null input
  if (str'length = 0) then
    assert false
    report " From_HexString  --- input string has zero length ";
    return "";
  elsif  (str(str'left) = NUL) then
    assert false
    report " From_HexString  --- input string has nul character"
           & " at the LEFT position "
    severity ERROR;
    return "";  -- null  bit_vector
  end if;
-- find the position of the first non_white character
  index := Find_NonBlank(str_copy,1);
  if (index > str'length) then
    assert false
    report " From_HexString  --- input string is empty  ";
    return "";
  elsif (str_copy(index)=NUL) then
    assert false
         report " From_HexString -- first non_white character is a NUL";
    return "";
  end if;
  i := 0;
  for idx in index to  str'length loop
    ch := str_copy(idx);
    exit when ((Is_White(ch)) or (ch = NUL));
    case ch IS
      when '0'        => r(i+1 TO i+ hex_dig_len) := bin_zero;
      when '1'        => r(i+1 TO i+ hex_dig_len) := bin_one;
      when '2'        => r(i+1 TO i+ hex_dig_len) := bin_two;
      when '3'        => r(i+1 TO i+ hex_dig_len) := bin_three;
      when '4'        => r(i+1 TO i+ hex_dig_len) := bin_four;
      when '5'        => r(i+1 TO i+ hex_dig_len) := bin_five;
      when '6'        => r(i+1 TO i+ hex_dig_len) := bin_six;
      when '7'        => r(i+1 TO i+ hex_dig_len) := bin_seven;
      when '8'        => r(i+1 TO i+ hex_dig_len) := bin_eight;
      when '9'        => r(i+1 TO i+ hex_dig_len) := bin_nine;
      when 'A' | 'a'  => r(i+1 TO i+ hex_dig_len) := bin_ten;
      when 'B' | 'b'  => r(i+1 TO i+ hex_dig_len) := bin_eleven;
      when 'C' | 'c'  => r(i+1 TO i+ hex_dig_len) := bin_twelve;
      when 'D' | 'd'  => r(i+1 TO i+ hex_dig_len) := bin_thirteen;
      when 'E' | 'e'  => r(i+1 TO i+ hex_dig_len) := bin_fourteen;
      when 'F' | 'f'  => r(i+1 TO i+ hex_dig_len) := bin_fifteen;
      when NUL        => exit;
      when others     => -- a non  binary value was passed
        assert (invalid)
        report "From_HexString(str(" & To_String(idx) & ")) is an invalid character"
        severity error;
        invalid := TRUE;
    end case;
    i := i + hex_dig_len;
  end loop;
-- check for invalid character in the string
  if ( invalid ) then
    r(1 to i) := (otherS => '0');
  end if;
  result(i - 1 downto 0) := r(1 to i);
  return result(i - 1 downto 0);     -- return slice of result
end;

-- -----------------------------------------------------------------------------
function From_String (constant str   : in string
                     ) return integer is
  variable str_copy : string (1 to str'length) := str;
  variable index    : Natural;
  variable ch       : character;
  variable result   : integer := 0;
  variable neg_sign : boolean := false;
  variable invalid  : boolean := false;
begin
-- Check for null input
  if (str'length = 0) then
    assert false
    report " From_String  --- input string has zero length "
    severity Error;
    return integer'left;
  end if;
-- find the position of the first non_white character
  index := Find_NonBlank(str_copy,1);
  if (index > str'length) then
    assert false
    report " From_String  --- input string is empty  ";
    return integer'left;
  elsif (str_copy(index)=NUL) then
    assert false
    report " From_String  -- first non_white character is a NUL ";
    return integer'left;
  end if;
  ch := str_copy(index);
-- check for - sign or + sign
  if (ch = '-') Then
    neg_sign := NOT neg_sign;
    index := index + 1;
    ch := str_copy(index);      -- get_char
    elsif (ch = '+') then
    index := index + 1;
    ch := str_copy(index);      -- get_char
  end if;

-- Strip off leading zero's
  while ( (ch = '0')  and (index < str'length)) loop
    index := index + 1;
    ch := str_copy(index);     -- get_char
  end loop;
  for i in index to str'length loop
    ch := str_copy(i);
    if (Is_Digit(ch)) then
      result := result * 10 + (CHARACTER'POS(ch) - CHARACTER'POS('0'));
-- to digit
    elsif ((Is_White(ch))  or (ch = NUL)) then
      exit;
    else
      invalid := true;
      result := integer'left;
      assert false
      report "From_String(str(" & To_String(i) & ")) is an invalid character "
      severity error;
      exit;
    end if;
  end loop;
  if ( neg_sign  and (not invalid) )then
    result := - result;
  end if;
  return result;
end;

-- -----------------------------------------------------------------------------
function To_Integer_FromUnsign (constant ARG    : in bit_vector
                               ) return integer is
  variable reg_copy       : bit_vector(ARG'length - 1 downto 0);
  variable result         : integer;
begin
-- initializations
  reg_copy := ARG;
  result   := 0;
--  Check for null input
  if (ARG'length = 0) then
    assert false
    report " To_Integer (Bit_Vector case) --- input register has null range, "
            & "  returning zero  result  "
    severity Error;
    return result;
  end if;
-- if the input vector is unsigned, the leading bit is data.
-- Now convert the magnitude part of the bit vector to a positive
-- integer. Convert Unsigned
  for i in ARG'length downto 1 loop
    if ((i>=IntegerBitLength) and (reg_copy(i-1)='1'))   then
                                               -- number too big
      assert false
      report " To_Integer (BitVector case) -- attempt to convert a vector "
              & "larger than or 32 bit  "
      severity error;
      return 0;
    end if;
--  result := result + result + BIT'POS(reg_copy(i-1)); -- shift and add
    if (reg_copy(i-1)='0') then
      result := result + result + 0;  -- shift and add
    elsif (reg_copy(i-1)='1') then
      result := result + result + 1;  -- shift and add
    end if;
  end loop;
  return result;
end;

-- -----------------------------------------------------------------------------
function To_Integer (constant SrcReg     : in bit_vector;
                     constant SrcRegMode : in regmode_type := normal
                    ) return integer is
begin
  if (SrcRegMode = normal) then
    return(To_Integer_FromUnsign(SrcReg));
  end if;
end;

-- -----------------------------------------------------------------------------
function To_Integer_FromUnsign (constant ARG    : in std_logic_vector
                               ) return integer is
  variable reg_copy       : std_logic_vector(ARG'length - 1 downto 0);
  variable result         : integer;
begin
-- initializations
  reg_copy := ARG;
  result   := 0;
--  Check for null input
  if (ARG'length = 0) then
    assert false
    report " To_Integer (Std_Logic_Vector case) -- input register has null"
             & " range, returning zero  result "
    severity error;
    return result;
  end if;
-- if the input vector is unsigned, the leading bit is data.
-- now convert the magnitude part of the logic vector to a positive
-- integer. if the magnitude part is positive convert with this loop
  for i in ARG'Length downto 1 loop
    if ((i>=IntegerBitLength) and (reg_copy(i-1)='1')) then
-- number too big
      assert false
      report " To_Integer (Std_logic_vector case) -- attempt to convert a "
               & " vector larger than or 32 bit  "
      severity error;
      return 0;
    end if;
    if ((reg_copy(i-1)='0') or (reg_copy(i-1)='L')) then
      result := result + result + 2 - 2;  -- shift and add
    elsif ((reg_copy(i-1)='1') or (reg_copy(i-1)='H')) then
      result := result + result + 3 - 2;  -- shift and add
    else
      assert false
      report " To_Integer (Std_Logic_Vector case) -- input vector has element "
               & "other than 0, 1, L, H "
      severity error;
      result := 0;
      return result;
    end if;
  end loop;
  return result;
end;

-- -----------------------------------------------------------------------------
function To_Integer (constant SrcReg     : in std_logic_vector;
                     constant SrcRegMode : in regmode_type := normal
                    ) return integer is
begin
  if (SrcRegMode = normal) then
    return(To_Integer_FromUnsign(SrcReg));
  end if;
end;

-- -----------------------------------------------------------------------------
-- Checking read data bus for the expected value
-- -----------------------------------------------------------------------------
procedure ReportRead(
                     constant Verbosity      : in boolean;
                     constant HaltOnMismatch : in boolean;
                     constant data           : in std_logic_vector;
                     constant mask           : in std_logic_vector;
                     constant address        : in T_addr;
                     signal Pollstart        : in std_logic;
                     signal delPollstart     : in std_logic;
                     signal Pollend          : inout std_logic;
                     signal Pidle            : in std_logic;
                     signal Maxflagpoll      : in boolean;
                     signal pocount          : in std_logic_vector;
                     signal countflag        : in boolean;
                     constant exp            : in std_logic_vector;
                     constant tag            : in string(1 to 20)
                    ) is
      variable printstr  : string(1 to 255);
begin
      if (((mask and data) /= (mask and exp)) and
            delPollstart = '0' and Pidle /= '1') then
        fprint(printstr,
          "%s: SRE: Error on data read from %s. Expected: %s Actual: %s"
                & " Mask: %s TAG: %s",
               to_string(now),
               To_HexString(address),
               To_HexString(exp),
               To_HexString(data),
               To_HexString(mask),
               tag);
               Pollend <= '0';
          if HaltOnMismatch then
            assert false
              report printstr
              severity failure;
          else
             assert false
              report printstr
              severity warning;
          end if;
      elsif (delPollstart = '0' and Pidle /= '1') then
        Pollend <= '0';
         if Verbosity then
          fprint(printstr, 
         "%s: SRC: Correct read value of %s with mask %s from %s TAG; "
                    & "%s",
                 to_string(now),
                 To_HexString(data),
                 To_HexString(mask),
                 To_HexString(address),
                 tag);
          assert false
          report printstr
          severity note;
        end if;
      elsif (Maxflagpoll = TRUE) then
        Pollend <= '1';
          fprint(printstr,
          "SPE: Limit has reached when numcycle is zero");  
          assert false
          report printstr
          severity note;
      elsif ( ((mask and data) = (mask and exp)) and
               (delPollstart = '1') and Pidle /= '1') then
        if (Verbosity) then
          fprint(printstr,
          "SPC: Correct value of %s polled, Count:%s, TAG:%s",
          To_HexString(exp), To_HexString(pocount), tag);
          assert false
          report printstr
          severity note;
        end if;
        Pollend <= '1'; -- stop polling since correct value is sampled.
      elsif (((mask and data) /= (mask and exp)) and
              (delPollstart = '1') and Pidle /= '1' and countflag) then
          if (Verbosity) then
            fprint(printstr,
            "SO: Polling for value %s, Count:%s, TAG:%s ",
            To_HexString(exp), To_HexString(pocount), tag);
            assert false
            report printstr
            severity note;
          end if;
          Pollend <= '0'; 
      elsif (countflag = FALSE and delPollstart = '1' and
             Pollend /= '1') then
          fprint(printstr,
 "SPE: Maximum number of Polls for value %s reached.Count:%s, TAG:%s ",
          To_HexString(exp), To_HexString(unsigned(pocount) - 1), tag);
          assert false
          report printstr
          severity note;
      else
        Pollend <= '0'; 
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
    fprint(printstr,
           " %s: HSWC: Executed write transfer of %s at address %s"
           & " TAG : %s",
           to_string(now),
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
        to_string(now),
        To_HexString(addr),
        tag);
  elsif (count = 8) then
    fprint(printstr,
   "%s: Extra: Extra transfer for eight-beat burst Address: %s TAG: %s",
        to_string(now),
        To_HexString(addr),
        tag);
  elsif (count = 16) then
    fprint(printstr,
 "%s: Extra: Extra transfer for sixteen-beat burst Address: %s TAG: %s",
        to_string(now),
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
procedure ffgetc (variable result : out character;
                  variable eof    : out boolean;
                  variable stream : in string;
                  variable ptr    : inout integer
                 ) is
  variable end_file : boolean;  -- refers to end of string
begin
  end_file := ( (ptr > stream'LENGTH) or (stream(ptr) = NUL) );
  if (not end_file) then
    result := stream(ptr);
    ptr := ptr + 1;
  end if;
  eof := end_file;
  return;
end;

-- -----------------------------------------------------------------------------
procedure scan_for_match (variable str        : in string;
                          variable ptr        : inout integer;
                          constant match_char : in character;
                          variable eof        : inout boolean;
                          variable mismatch   : out boolean 
                         ) is
  variable ch   : character;
  variable cont : boolean;
begin
  if ( END_OF_LINE_MARKER = (LF, ' ') ) then
    mismatch := FALSE;
    ffgetc (ch, eof, str, ptr);
    while ((is_space(ch) or ((ch = LF)and(match_char /= LF))) and
           (not eof)) loop
      ffgetc (ch, eof, str, ptr);
    end loop;
    if (not eof) then
      mismatch := (ch /= match_char);
    end if;
  elsif ( END_OF_LINE_MARKER = (CR, ' ') ) then
    mismatch := FALSE;
    ffgetc (ch, eof, str, ptr);
    while ((is_space(ch) or ((ch = CR)and(match_char /= CR))) and
           (not eof)) loop
      ffgetc (ch, eof, str, ptr);
    end loop;
    if (not eof) then
      mismatch := (ch /= match_char);
    end if;
  else  -- END_OF_LINE_MARKER = CR & LF
    mismatch := FALSE;
    cont := TRUE;
    ffgetc (ch, eof, str, ptr);
    while ( cont ) loop
      while ((is_space(ch) or (((ch = CR) or (ch = LF)) and
             (match_char /= CR))) and (not eof)) loop
        ffgetc (ch, eof, str, ptr);
      end loop;
      cont := FALSE;
      if ((match_char = CR) and (ch = CR)) then
        ffgetc(ch, eof, str, ptr);
        cont := (ch /= LF);
        if (not cont) then
          return;
        end if;
      end if;
    end loop;
    if (not eof) then
      mismatch := (ch /= match_char);
    end if;
  end if;
  return;
end;
-- -----------------------------------------------------------------------------
procedure fgetline(variable l_str   : out string;
                   variable stream  : in ascii_text
                  ) is
  variable ch        : character := ' ';
  variable indx      : integer := 0;
  variable str_copy  : string(1 to max_string_len);
begin
  if ENDFILE(stream) then
    assert false
      report " fgetline (ASCII_TEXT)  -- end of file, nothing to read."
      severity WARNING;
    if (l_str'length > 0 ) then
      l_str(l_str'left) := NUL;
    end if;
    return;
  else
    while ( (not ENDFILE(stream)) and
            (ch /= END_OF_LINE_MARKER(1)) ) loop
      read(stream, ch);
      indx := indx + 1;
      str_copy(indx) := ch;
    end loop;
-- determine the length and place characters
    if (l_str'length <=  indx) then
      l_str := str_copy(1 to l_str'length);
    else
      l_str(1 to indx) := str_copy(1 to indx);
      l_str(indx+1) := NUL;
    end if;
    return;
  end if;
end;

-- -----------------------------------------------------------------------------
procedure StrCpy( variable l_str : out string;
                  constant r_str : in  string) is
  variable  l_len     : integer := l_str'length;
  variable  r_len     : integer := r_str'length;
  variable  r         : string ( 1 to r_len) := r_str;
  variable result     : string (1 to l_len);
  variable indx       : integer := 1;
begin
  while ((indx <= r_len) and (indx <= l_len) and
         (r(indx) /= NUL) ) loop
    result(indx) := r(indx);
    indx := indx + 1;
  end loop;
  if (indx <= l_len) then
    result(indx) := NUL;
  end if;
  l_str := result;
  return;
end;

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
  return;
end fprint;

-- -----------------------------------------------------------------------------
procedure fscan ( constant string_buf     : in string;
                  constant format         : in string;
                  variable arg1           : out string;
                  variable arg2           : out string;
                  variable arg3           : out string;
                  variable arg4           : out string;
                  variable arg5           : out string;
                  variable arg6           : out string;
                  variable arg7           : out string;
                  variable arg8           : out string;
                  variable arg9           : out string;
                  variable arg10          : out string;
                  variable arg11          : out string;
                  variable arg12          : out string;
                  variable arg13          : out string;
                  variable arg14          : out string;
                  variable arg15          : out string;
                  variable arg16          : out string;
                  variable arg17          : out string;
                  variable arg18          : out string;
                  variable arg19          : out string;
                  constant arg_count      : in integer := 19
                 ) is
  variable str_buffer  : string(1 to string_buf'length) := string_buf;
-- hold string buffer
  variable fmt         : string(1 to format'length) := format;
-- hold format
  variable index       : integer := 1;
-- index into fmt
  variable str_indx    : integer := 1;
-- index into str_buffer
  variable fmt_len     : integer;
-- length of format
  variable ch          : character;
-- present character read from string buffer
  variable fchar       : character;
-- present format character
  variable look_ahead  : character;
-- next format character
  variable mismatch    : boolean := FALSE;
-- true if mismatch between format literal and string buffer character
  variable eof         : boolean := FALSE;
-- true if end of string buffer
  variable field_width : integer;
-- field width
  variable string_type : character;
-- type of string specified by format
  variable arg_num     : integer := 0;
-- number of argument currently being read
  variable arg         : string(1 to MAX_STRING_LEN+1);
-- used to temporarily hold argument
  variable premature_end : boolean := FALSE;
-- true if end of string buffer reached prematurely
  variable t_follow      : string(1 to 5);
-- used to check for time unit following %t
  variable ii, jj        : integer;
begin
-- make return strings empty
  arg1(arg1'left)   := NUL;
  arg2(arg2'left)   := NUL;
  arg3(arg3'left)   := NUL;
  arg4(arg4'left)   := NUL;
  arg5(arg5'left)   := NUL;
  arg6(arg6'left)   := NUL;
  arg7(arg7'left)   := NUL;
  arg8(arg8'left)   := NUL;
  arg9(arg9'left)   := NUL;
  arg10(arg10'left) := NUL;
  arg11(arg11'left) := NUL;
  arg12(arg12'left) := NUL;
  arg13(arg13'left) := NUL;
  arg14(arg14'left) := NUL;
  arg15(arg15'left) := NUL;
  arg16(arg16'left) := NUL;
  arg17(arg17'left) := NUL;
  arg18(arg18'left) := NUL;
  arg19(arg19'left) := NUL;
  index := Find_NonBlank(fmt, index);
  fmt_len := fmt'length;
  if ( index > fmt_len ) then
    assert FALSE
    report "fscan (String Buffer)  -- empty format string."
    severity Error;
    return;
  end if;
  eof := ( (str_indx > str_buffer'length) or
           (str_buffer(str_indx) = NUL));
  while ( (not eof) and (index <= fmt_len) ) loop
    fchar := fmt(index);
    look_ahead := NUL;
    mismatch := FALSE;
    if (index < fmt_len) then
      look_ahead := fmt(index+1);
    else
      look_ahead := ' ';
    end if;
    if ( (fchar = '%') and (look_ahead = '%') ) then
                                 -- check for literal%
      index := index + 2;
    elsif (fchar = '%') then
      if (arg_num = arg_count) then
        assert FALSE
        report "fscan (String Buffer) -- number of format specifications exceed argument count"
        severity Error;
        return;
      end if;
      arg_num := arg_num + 1;
      field_width := 0;
      index := index + 1;
      if (index <= fmt_len) then
        string_type := fmt(index);
        index := index + 1;
      else
        assert FALSE
        report "fscan (String Buffer)  -- error in format specification"
        severity Error;
        return;
      end if;
      case string_type is
        when 'd' | 'f' | 's' | 'o' | 'x' | 'X' =>
          if ( field_width = 0 ) then
            field_width := MAX_STRING_LEN + 1;
          end if;
          ffgetc (ch, eof, str_buffer, str_indx); -- skip over carrage
                                    -- return and line feed and spaces
          while ((is_space(ch) or (ch = LF) or (ch = CR)) and
                 (not eof)) loop
            ffgetc(ch, eof, str_buffer, str_indx);
          end loop;
          ii := 1;
          loop
            exit when ( eof or is_space(ch) or (ch = LF) or (ch = CR));
            arg(ii) := ch;
            ii := ii + 1;
            field_width := field_width - 1;
            exit when (field_width = 0);
            ffgetc(ch, eof, str_buffer, str_indx);
          end loop;
          if ((string_type = 't') and (not eof) and
               (field_width > 1) and (ch /= LF) and (ch /= CR) ) then
            arg(ii) := ' ';
            ii := ii + 1;
            field_width := field_width - 1;
            ffgetc(ch, eof, str_buffer, str_indx);
            loop
             exit when ( eof or is_space(ch) or (ch = LF) or (ch = CR));
              arg(ii) := ch;
              ii := ii + 1;
              field_width := field_width - 1;
              exit when (field_width = 0);
              ffgetc(ch, eof, str_buffer, str_indx);
            end loop;
          end if;
          arg(ii) := NUL;
          premature_end := ( eof and (ii = 1));
        when others =>
          assert FALSE
          report "fscan (String Buffer) --error in format specification"
          severity ERROR;
          return;
      end case;
      case arg_num is
        when 1       => strcpy(arg1,  arg);
        when 2       => strcpy(arg2,  arg);
        when 3       => strcpy(arg3,  arg);
        when 4       => strcpy(arg4,  arg);
        when 5       => strcpy(arg5,  arg);
        when 6       => strcpy(arg6,  arg);
        when 7       => strcpy(arg7,  arg);
        when 8       => strcpy(arg8,  arg);
        when 9       => strcpy(arg9,  arg);
        when 10      => strcpy(arg10,  arg);
        when 11      => strcpy(arg11,  arg);
        when 12      => strcpy(arg12,  arg);
        when 13      => strcpy(arg13,  arg);
        when 14      => strcpy(arg14,  arg);
        when 15      => strcpy(arg15,  arg);
        when 16      => strcpy(arg16,  arg);
        when 17      => strcpy(arg17,  arg);
        when 18      => strcpy(arg18,  arg);
        when 19      => strcpy(arg19,  arg);
        when others  =>
          assert FALSE
          report "fscan (String Buffer)  -- internal error"
          severity ERROR;
          return;
      end case;
    else                     -- compare for literal
      scan_for_match (str_buffer, str_indx, fchar, eof, mismatch);
      index := index + 1;
    end if;
    if (mismatch) then
      assert false
      report "fscan (String Buffer)  -- format string literal mismatch"
      severity WARNING;
      return;
    end if;
    index := Find_NonBlank(fmt, index);
  end loop;
  index := Find_NonBlank(fmt, index);
  assert ( not (( (eof and (index <= fmt_len)) or premature_end) ) )
  report "fscan (String BUffer)  -- unexpected end of string"
  severity WARNING;
end;

-- -----------------------------------------------------------------------------
procedure fscan (constant string_buf     : in string;
                 constant format         : in string;
                 variable arg1           : out string;
                 variable arg2           : out string;
                 variable arg3           : out string;
                 variable arg4           : out string;
                 variable arg5           : out string;
                 variable arg6           : out string;
                 variable arg7           : out string;
                 variable arg8           : out string;
                 variable arg9           : out string;
                 variable arg10          : out string;
                 variable arg11          : out string;
                 variable arg12          : out string;
                 variable arg13          : out string;
                 variable arg14          : out string;
                 variable arg15          : out string;
                 variable arg16          : out string;
                 variable arg17          : out string;
                 variable arg18          : out string
                ) is
  variable dummy_arg19        :  string(1 to 10);  -- dummy string;
begin
-- call procedure fscan with 19 arguments
  fscan(string_buf, format, arg1, arg2, arg3, arg4,  arg5, arg6, arg7,
        arg8, arg9, arg10, arg11, arg12, arg13, arg14, arg15, arg16,
        arg17, arg18, dummy_arg19,18);
  return;
END;

-- -----------------------------------------------------------------------------
procedure fscan (constant string_buf     : in string;
                 constant format         : in string;
                 variable arg1           : out string;
                 variable arg2           : out string;
                 variable arg3           : out string;
                 variable arg4           : out string;
                 variable arg5           : out string;
                 variable arg6           : out string;
                 variable arg7           : out string;
                 variable arg8           : out string;
                 variable arg9           : out string;
                 variable arg10          : out string;
                 variable arg11          : out string;
                 variable arg12          : out string;
                 variable arg13          : out string;
                 variable arg14          : out string;
                 variable arg15          : out string;
                 variable arg16          : out string;
                 variable arg17          : out string
                ) is
  variable dummy_arg18        :  string(1 to 10);  -- dummy string;
  variable dummy_arg19        :  string(1 to 10);  -- dummy string;
begin
-- call procedure fscan with 19 arguments
  fscan(string_buf, format, arg1, arg2, arg3, arg4,  arg5, arg6, arg7,
        arg8, arg9, arg10, arg11, arg12, arg13, arg14, arg15, arg16,
        arg17, dummy_arg18, dummy_arg19,17);
  return;
END;

--------------------------------------------------------------------------------
procedure fscan (constant string_buf     : in string;
                 constant format         : in string;
                 variable arg1           : out string;
                 variable arg2           : out string;
                 variable arg3           : out string;
                 variable arg4           : out string;
                 variable arg5           : out string;
                 variable arg6           : out string;
                 variable arg7           : out string;
                 variable arg8           : out string;
                 variable arg9           : out string;
                 variable arg10          : out string;
                 variable arg11          : out string;
                 variable arg12          : out string;
                 variable arg13          : out string;
                 variable arg14          : out string;
                 variable arg15          : out string;
                 variable arg16          : out string
                ) is
 variable dummy_arg17        :  string(1 to 10);  -- dummy string;
 variable dummy_arg18        :  string(1 to 10);  -- dummy string;
 variable dummy_arg19        :  string(1 to 10);  -- dummy string;
begin
-- call procedure fscan with 19 arguments
  fscan(string_buf, format, arg1, arg2, arg3, arg4,  arg5, arg6, arg7,
        arg8, arg9, arg10, arg11, arg12, arg13, arg14, arg15, arg16,
        dummy_arg17, dummy_arg18, dummy_arg19,16);
  return;
end;

--------------------------------------------------------------------------------
procedure fscan (constant string_buf     : in string;
                 constant format         : in string;
                 variable arg1           : out string;
                 variable arg2           : out string;
                 variable arg3           : out string;
                 variable arg4           : out string;
                 variable arg5           : out string;
                 variable arg6           : out string;
                 variable arg7           : out string
                ) is
  variable dummy_arg8         :  string(1 to 10);  -- dummy string;
  variable dummy_arg9         :  string(1 to 10);  -- dummy string;
  variable dummy_arg10        :  string(1 to 10);  -- dummy string;
  variable dummy_arg11        :  string(1 to 10);  -- dummy string;
  variable dummy_arg12        :  string(1 to 10);  -- dummy string;
  variable dummy_arg13        :  string(1 to 10);  -- dummy string;
  variable dummy_arg14        :  string(1 to 10);  -- dummy string;
  variable dummy_arg15        :  string(1 to 10);  -- dummy string;
  variable dummy_arg16        :  string(1 to 10);  -- dummy string;
  variable dummy_arg17        :  string(1 to 10);  -- dummy string;
  variable dummy_arg18        :  string(1 to 10);  -- dummy string;
  variable dummy_arg19        :  string(1 to 10);  -- dummy string;
begin
-- call procedure fscan with 19 arguments
  fscan(string_buf, format, arg1, arg2, arg3, arg4,  arg5, arg6, arg7,
        dummy_arg8, dummy_arg9, dummy_arg10, dummy_arg11, dummy_arg12,
        dummy_arg13, dummy_arg14, dummy_arg15, dummy_arg16, dummy_arg17,
        dummy_arg18, dummy_arg19,7);
  return;
end;

--------------------------------------------------------------------------------
procedure fscan (constant string_buf     : in string;
                 constant format         : in string;
                 variable arg1           : out string;
                 variable arg2           : out string;
                 variable arg3           : out string;
                 variable arg4           : out string;
                 variable arg5           : out string;
                 variable arg6           : out string
                ) is
  variable dummy_arg7         :  string(1 to 10);  -- dummy string;
  variable dummy_arg8         :  string(1 to 10);  -- dummy string;
  variable dummy_arg9         :  string(1 to 10);  -- dummy string;
  variable dummy_arg10        :  string(1 to 10);  -- dummy string;
  variable dummy_arg11        :  string(1 to 10);  -- dummy string;
  variable dummy_arg12        :  string(1 to 10);  -- dummy string;
  variable dummy_arg13        :  string(1 to 10);  -- dummy string;
  variable dummy_arg14        :  string(1 to 10);  -- dummy string;
  variable dummy_arg15        :  string(1 to 10);  -- dummy string;
  variable dummy_arg16        :  string(1 to 10);  -- dummy string;
  variable dummy_arg17        :  string(1 to 10);  -- dummy string;
  variable dummy_arg18        :  string(1 to 10);  -- dummy string;
  variable dummy_arg19        :  string(1 to 10);  -- dummy string;
begin
-- call procedure fscan with 19 arguments
  fscan(string_buf, format, arg1, arg2, arg3, arg4,  arg5, arg6,
        dummy_arg7, dummy_arg8, dummy_arg9, dummy_arg10, dummy_arg11,
        dummy_arg12, dummy_arg13, dummy_arg14, dummy_arg15, dummy_arg16,
        dummy_arg17, dummy_arg18, dummy_arg19,6);
  return;
end;

-- -----------------------------------------------------------------------------
procedure fscan (constant string_buf     : in string;
                 constant format         : in string;
                 variable arg1           : out string;
                 variable arg2           : out string;
                 variable arg3           : out string;
                 variable arg4           : out string
                ) is
  variable dummy_arg5         :  string(1 to 10);  -- dummy string;
  variable dummy_arg6         :  string(1 to 10);  -- dummy string;
  variable dummy_arg7         :  string(1 to 10);  -- dummy string;
  variable dummy_arg8         :  string(1 to 10);  -- dummy string;
  variable dummy_arg9         :  string(1 to 10);  -- dummy string;
  variable dummy_arg10        :  string(1 to 10);  -- dummy string;
  variable dummy_arg11        :  string(1 to 10);  -- dummy string;
  variable dummy_arg12        :  string(1 to 10);  -- dummy string;
  variable dummy_arg13        :  string(1 to 10);  -- dummy string;
  variable dummy_arg14        :  string(1 to 10);  -- dummy string;
  variable dummy_arg15        :  string(1 to 10);  -- dummy string;
  variable dummy_arg16        :  string(1 to 10);  -- dummy string;
  variable dummy_arg17        :  string(1 to 10);  -- dummy string;
  variable dummy_arg18        :  string(1 to 10);  -- dummy string;
  variable dummy_arg19        :  string(1 to 10);  -- dummy string;
begin
-- call procedure fscan with 19 arguments
  fscan(string_buf, format, arg1, arg2, arg3, arg4,dummy_arg5,
        dummy_arg6, dummy_arg7, dummy_arg8, dummy_arg9, dummy_arg10,
        dummy_arg11, dummy_arg12, dummy_arg13, dummy_arg14, dummy_arg15,
        dummy_arg16, dummy_arg17, dummy_arg18, dummy_arg19,4);
  return;
end;

-- -----------------------------------------------------------------------------
procedure fscan (constant string_buf     : in string;
                 constant format         : in string;
                 variable arg1           : out string;
                 variable arg2           : out string
                ) is
  variable dummy_arg3         :  string(1 to 10);  -- dummy string;
  variable dummy_arg4         :  string(1 to 10);  -- dummy string;
  variable dummy_arg5         :  string(1 to 10);  -- dummy string;
  variable dummy_arg6         :  string(1 to 10);  -- dummy string;
  variable dummy_arg7         :  string(1 to 10);  -- dummy string;
  variable dummy_arg8         :  string(1 to 10);  -- dummy string;
  variable dummy_arg9         :  string(1 to 10);  -- dummy string;
  variable dummy_arg10        :  string(1 to 10);  -- dummy string;
  variable dummy_arg11        :  string(1 to 10);  -- dummy string;
  variable dummy_arg12        :  string(1 to 10);  -- dummy string;
  variable dummy_arg13        :  string(1 to 10);  -- dummy string;
  variable dummy_arg14        :  string(1 to 10);  -- dummy string;
  variable dummy_arg15        :  string(1 to 10);  -- dummy string;
  variable dummy_arg16        :  string(1 to 10);  -- dummy string;
  variable dummy_arg17        :  string(1 to 10);  -- dummy string;
  variable dummy_arg18        :  string(1 to 10);  -- dummy string;
  variable dummy_arg19        :  string(1 to 10);  -- dummy string;
begin
-- call procedure fscan with 19 arguments
  fscan(string_buf, format, arg1, arg2, dummy_arg3, dummy_arg4,
        dummy_arg5, dummy_arg6, dummy_arg7, dummy_arg8, dummy_arg9,
        dummy_arg10, dummy_arg11, dummy_arg12, dummy_arg13, dummy_arg14,
        dummy_arg15, dummy_arg16, dummy_arg17, dummy_arg18,
        dummy_arg19,2);
  return;
end;

-- -----------------------------------------------------------------------------
procedure fscan (constant string_buf     : in string;
                 constant format         : in string;
                 variable arg1           : out string
                ) is
  variable dummy_arg2         :  string(1 to 10);  -- dummy string;
  variable dummy_arg3         :  string(1 to 10);  -- dummy string;
  variable dummy_arg4         :  string(1 to 10);  -- dummy string;
  variable dummy_arg5         :  string(1 to 10);  -- dummy string;
  variable dummy_arg6         :  string(1 to 10);  -- dummy string;
  variable dummy_arg7         :  string(1 to 10);  -- dummy string;
  variable dummy_arg8         :  string(1 to 10);  -- dummy string;
  variable dummy_arg9         :  string(1 to 10);  -- dummy string;
  variable dummy_arg10        :  string(1 to 10);  -- dummy string;
  variable dummy_arg11        :  string(1 to 10);  -- dummy string;
  variable dummy_arg12        :  string(1 to 10);  -- dummy string;
  variable dummy_arg13        :  string(1 to 10);  -- dummy string;
  variable dummy_arg14        :  string(1 to 10);  -- dummy string;
  variable dummy_arg15        :  string(1 to 10);  -- dummy string;
  variable dummy_arg16        :  string(1 to 10);  -- dummy string;
  variable dummy_arg17        :  string(1 to 10);  -- dummy string;
  variable dummy_arg18        :  string(1 to 10);  -- dummy string;
  variable dummy_arg19        :  string(1 to 10);  -- dummy string;
begin
-- call procedure fscan with 19 arguments
  fscan(string_buf, format, arg1, dummy_arg2, dummy_arg3, dummy_arg4,
        dummy_arg5, dummy_arg6, dummy_arg7, dummy_arg8, dummy_arg9,
        dummy_arg10, dummy_arg11, dummy_arg12, dummy_arg13, dummy_arg14,
        dummy_arg15, dummy_arg16, dummy_arg17, dummy_arg18,
        dummy_arg19,1);
  return;
end;

-- -----------------------------------------------------------------------------
-- This block is responsible for driving data on appropriate bytelanes
-- as per the endianness. It takes endianness and HADDR bits as input
-- and on the basis of that, "puts" the data on the correct byte lane
-- and drives the other lanes to zero. Currently implemented for 64 bit
-- wide data buses.
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
function from_vec(vec : std_logic_vector(0 downto 0))
         return std_logic is
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
  variable errorstr : string(1 to 255);
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
      if (num_cyc > 0)  or (num_cyc = 0 and ((supp_msg and
        (( resp /= "00") or (resp = "00" and HRESP = "01"))) or
           not(supp_msg)) and HREADY = '1') then
      fprint (errorstr,
              "RSPERR%s%s: Response error at address %s. Expected: %s,"
              & " Actual: %s, TAG: %s",To_HexString(resp),
              To_HexString(HRESP), To_HexString(addr),expstr, actstr,
              tag);  
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
    fprint(printstr,
           "VRE%s: Error on vector read from R%s. Expected: %s" &
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
    fprint(printstr,
           "VRC%s: Correct read value of %s with mask %s from R%s, "
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

-- --================================ End ====================================--
