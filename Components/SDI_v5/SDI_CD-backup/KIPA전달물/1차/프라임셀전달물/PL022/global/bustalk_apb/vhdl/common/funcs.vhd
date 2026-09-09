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
-- File Name           : funcs.vhd.rca 
-- File Revision       : 1.2 
-- 
-- Release Information : PrimeCell(TM)-GLOBAL-REL1v5 
-- 
-- ---------------------------------------------------------------------
-- Purpose : This contains the functions to_vec and from_vec.
--           It also contains the procedures ReportRead,
--           ReportVirRead, ReportVirWrite, ReportP_Cycle 
--           and ReportReset.
-- --=================================================================--

library ieee;
use     ieee.std_logic_1164.all;
use     std.textio.all;

library common;
use     common.defs.all;

package funcs is
  
  function to_vec(sig : std_logic) return std_logic_vector;
  function from_vec(vec : std_logic_vector(0 downto 0)) return std_logic;
  function From_HexString(constant str : in string) return bit_vector;
  function From_String(constant str : in string) return integer;
  function To_Integer(constant SrcReg : in bit_vector;
                      constant SrcRegMode : in regmode_type := normal
                     ) return integer; 
  function To_String ( constant val    : in time) return string;
   
  procedure ReportRead(
                       constant Verbosity      : in boolean;
                       constant HaltOnMismatch : in boolean;
                       constant data           : in std_logic_vector;
                       constant mask           : in std_logic_vector;
                       constant exp            : in std_logic_vector;
                       constant tag            : in string(1 to 20);
                       signal postatI          : in std_logic;
                       signal postatO          : out std_logic;
                       signal countflag        : in boolean 
                      );
  procedure ReportVirRead(
                          constant Verbosity      : in boolean;
                          constant HaltOnMismatch : in boolean;
                          constant data           : in std_logic_vector;
                          constant mask           : in std_logic_vector;
                          constant exp            : in std_logic_vector;
                          constant reg            : in integer;
                          constant tag            : in string(1 to 20)
                          );
  procedure ReportVirWrite(constant data : in std_logic_vector;
                           constant mask : in std_logic_vector;
                           constant reg  : in integer);
  procedure ReportP_Cycle(
                          constant sel       : in T_cycle;
                          constant exp       : in std_logic_vector;
                          constant mask      : in std_logic_vector;
                          constant addr      : in std_logic_vector;
                          constant data      : in std_logic_vector;
                          constant tag       : in string(1 to 20);
                          constant num_cyc   : in T_int);
  procedure ReportReset(   constant nres : in std_logic);
  
  procedure fgetline  ( variable l_str   : out string;
                        variable stream  : in ascii_text
                      ); 
  procedure StrCpy    ( variable l_str : out string;
                        constant r_str : in  string
                      );
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
                         constant arg9          : in string := "";
                         constant arg10         : in string := "" 
                        ); 
  procedure fscan ( constant string_buf     : in string;
                    constant format         : in string;
                    variable arg1           : out string;
                    variable arg2           : out string;
                    variable arg3           : out string;
                    variable arg4           : out string;
                    variable arg5           : out string;
                    variable arg6           : out string;
                    variable arg7           : out string;
                    constant arg_count      : in integer := 7
                  );
  procedure fscan ( constant string_buf     : in string;
                    constant format         : in string;
                    variable arg1           : out string;
                    variable arg2           : out string;
                    variable arg3           : out string;
                    variable arg4           : out string;
                    variable arg5           : out string;
                    variable arg6           : out string
                  );
  procedure fscan ( constant string_buf     : in string;
                    constant format         : in string;
                    variable arg1           : out string;
                    variable arg2           : out string;
                    variable arg3           : out string;
                    variable arg4           : out string;
                    variable arg5           : out string
                  );
  procedure fscan ( constant string_buf     : in string;
                    constant format         : in string;
                    variable arg1           : out string;
                    variable arg2           : out string;
                    variable arg3           : out string;
                    variable arg4           : out string
                  );
  procedure fscan ( constant string_buf     : in string;
                    constant format         : in string;
                    variable arg1           : out string;
                    variable arg2           : out string;
                    variable arg3           : out string
                  );
  procedure fscan ( constant string_buf     : in string;
                    constant format         : in string;
                    variable arg1           : out string;
                    variable arg2           : out string
                  );
  procedure fscan ( constant string_buf     : in string;
                    constant format         : in string;
                    variable arg1           : out string
                  );

end funcs;

package body funcs is
     FUNCTION To_Integer_FromUnsign   ( CONSTANT ARG    : IN BIT_VECTOR
                                       ) return INTEGER IS
        VARIABLE reg_copy       : BIT_VECTOR(ARG'LENGTH - 1 DOWNTO 0);
        VARIABLE result         : INTEGER;
        -- synopsys built_in SYN_UNSIGNED_TO_INTEGER
    BEGIN
        -- synopsys synthesis_off
        -- initializations
        reg_copy := ARG;
        result   := 0;
        --  Check for null input
        IF (ARG'LENGTH = 0) THEN
          ASSERT false
          REPORT " To_Integer (Bit_Vector case) --- input register has null range, " & "  returning zero  result  "
          SEVERITY ERROR;
          RETURN result;
        END IF;
        -- if the input vector is unsigned, the leading bit is data.
        -- Now convert the magnitude part of the bit vector to a positive integer.
        -- Convert Unsigned
           FOR i IN ARG'LENGTH DOWNTO 1 LOOP
              IF ((i>=IntegerBitLength) AND (reg_copy(i-1)='1'))   THEN -- number too big
                 assert false
                 report " To_Integer (BitVector case) -- attempt to convert a vector " & "larger than or 32 bit  "
                 severity error;
                return 0;
              END IF;
--              result := result + result + BIT'POS(reg_copy(i-1));  -- shift and add
                if (reg_copy(i-1)='0') then
                        result := result + result + 0;  -- shift and add
                elsif (reg_copy(i-1)='1') then
                        result := result + result + 1;  -- shift and add
                end if;
           END LOOP;
                return result;
        -- synopsys synthesis_on
    END To_Integer_FromUnsign;

     FUNCTION To_Integer  ( CONSTANT SrcReg     : IN BIT_VECTOR;
                            CONSTANT SrcRegMode : IN regmode_type := normal
                          ) return INTEGER IS
     BEGIN
        if (SrcRegMode = normal) then
                return(To_Integer_FromUnsign(SrcReg));
        end if;
    END To_Integer;

     FUNCTION  Is_Space  ( CONSTANT c    : IN CHARACTER
                         ) RETURN BOOLEAN IS
         VARIABLE result : BOOLEAN;
     BEGIN
        IF (c = ' ' OR   c = HT ) THEN
             result := TRUE;
        ELSE
             result := FALSE;
        END IF;
        RETURN result;
     END Is_Space;

     FUNCTION  Is_White  ( CONSTANT c    : IN CHARACTER
                         ) RETURN BOOLEAN IS
         VARIABLE result : BOOLEAN;
     BEGIN
        IF ( (c = ' ') OR (c = HT)  OR (c = CR) OR (c=LF) ) THEN
             result := TRUE;
        ELSE
             result := FALSE;
        END IF;
        RETURN result;
     END;

     FUNCTION  Is_Digit  ( CONSTANT c    : IN CHARACTER
                         ) RETURN BOOLEAN IS
         VARIABLE result : BOOLEAN;
     BEGIN
        IF (c >= '0' and c <= '9') THEN
             result := TRUE;
        ELSE
             result := FALSE;
        END IF;
        RETURN result;
     END Is_Digit;

   FUNCTION Find_NonBlank  ( CONSTANT str_in   : IN STRING;
                             CONSTANT index    : IN NATURAL
                           ) RETURN NATURAL IS
      VARIABLE ch       :  character;
      VARIABLE indx     :  integer := index;
    BEGIN
          loop
            EXIT WHEN ( (indx > str_in'LENGTH) or (str_in(indx) = NUL) );
            if Is_White(str_in(indx)) then
                indx := indx + 1;
            else
                EXIT;
            end if;
          end loop;
          return indx;
    END;

    FUNCTION  To_Upper  ( CONSTANT  val    : IN String
                         ) RETURN STRING IS
        VARIABLE result   : string (1 TO val'LENGTH) := val;
        VARIABLE ch       : character;
    BEGIN
        FOR i IN 1 TO val'LENGTH LOOP
            ch := result(i);
            EXIT WHEN ((ch = NUL) OR (ch = nul));
            IF ( ch >= 'a' and ch <= 'z') THEN
                  result(i) := CHARACTER'VAL( CHARACTER'POS(ch)
                                       - CHARACTER'POS('a')
                                       + CHARACTER'POS('A') );
            END IF;
        END LOOP;
        RETURN result;
    END To_Upper;

     PROCEDURE ffgetc    ( VARIABLE result : OUT CHARACTER;
                           VARIABLE eof    : OUT BOOLEAN;
                           VARIABLE stream : IN STRING;
                           VARIABLE ptr    : INOUT INTEGER
                         ) IS
        VARIABLE end_file : BOOLEAN;  -- refers to end of string
     BEGIN
        end_file := ( (ptr > stream'LENGTH) or (stream(ptr) = NUL) );
        if (not end_file) then
           result := stream(ptr);
           ptr := ptr + 1;
        end if;
        eof := end_file;
        return;
     END;

   procedure scan_for_match ( VARIABLE str        : IN STRING;
                              VARIABLE ptr        : INOUT INTEGER;
                              CONSTANT match_char : IN CHARACTER;
                              VARIABLE eof        : INOUT BOOLEAN;
                              VARIABLE mismatch   : OUT BOOLEAN ) is
      VARIABLE ch : CHARACTER;
      VARIABLE cont : BOOLEAN;
   begin
      if ( END_OF_LINE_MARKER = (LF, ' ') ) then
         mismatch := FALSE;
         ffgetc (ch, eof, str, ptr);
         while ( (is_space(ch) or ( (ch = LF) and (match_char /= LF) ) ) and (not eof) ) loop
            ffgetc (ch, eof, str, ptr);
         end loop;
         if (not eof) then
            mismatch := (ch /= match_char);
         end if;
      elsif ( END_OF_LINE_MARKER = (CR, ' ') ) then
         mismatch := FALSE;
         ffgetc (ch, eof, str, ptr);
         while ( (is_space(ch) or ( (ch = CR) and (match_char /= CR) ) ) and (not eof) ) loop
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
            while ( (is_space(ch) or ( ( (ch = CR) or (ch = LF) ) and (match_char /= CR) ) ) and (not eof) ) loop
               ffgetc (ch, eof, str, ptr);
            end loop;
            CONT := FALSE;
            if ( (match_char = CR) and (ch = CR) ) then
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

   PROCEDURE fprint    ( VARIABLE string_buf    : OUT STRING;    
                         CONSTANT format        : IN STRING;
                         CONSTANT arg1          : IN STRING := "";
                         CONSTANT arg2          : IN STRING := "";
                         CONSTANT arg3          : IN STRING := "";
                         CONSTANT arg4          : IN STRING := "";
                         CONSTANT arg5          : IN STRING := "";
                         CONSTANT arg6          : IN STRING := "";
                         CONSTANT arg7          : IN STRING := "";
                         CONSTANT arg8          : IN STRING := "";
                         CONSTANT arg9          : IN STRING := "" ;
                         CONSTANT arg10         : IN STRING := ""
                        ) IS
        VARIABLE tempbuf    : STRING(1 TO string_buf'LENGTH); 
        VARIABLE rbuf       : LINE; 
        VARIABLE arg        : STRING(1 TO max_string_len); 
        VARIABLE fmt        : STRING(1 TO format'LENGTH) := format;
        VARIABLE index      : INTEGER := 0;
        VARIABLE buf_indx   : INTEGER := 0;
        VARIABLE ch         : CHARACTER;
	VARIABLE lookahead  : CHARACTER;
	VARIABLE tokn       : STRING(1 TO max_token_len);
	VARIABLE ArgNum     : INTEGER RANGE 1 TO 11;

     BEGIN
     -- check for null format string
       IF (format'LENGTH = 0) THEN
	  assert false
  	  report " fprint --- format string is null "
          severity ERROR;
          return;
       END IF;
       index := 0;
       ArgNum := 1;
       WHILE (true) LOOP
           index := index + 1;
           buf_indx := buf_indx + 1;
           ch := fmt(index);
           IF (index < format'LENGTH) THEN
               lookahead := fmt(index+1);
           ELSE
                lookahead := ' ';
           END IF;
           IF (( ch = '%') AND (lookahead = '%'))  THEN   
               WRITE(rbuf,ch);
           	index := index + 1;            -- print % character
           ELSIF ((ch = '\') AND (lookahead ='n')) THEN   -- new line
                ch := LF;
               WRITE(rbuf,ch);
                index := index + 1;            
           ELSIF (ch = '%') AND (lookahead /= '%') THEN  
                                                      -- format %s expected
                EXIT WHEN (ArgNum > 10); -- only first 10 argments will be printed
                tokn := (OTHERS => ' ');     -- fill token with blank space

               --   select argument number 1 to 10

                Case ArgNum IS
                    WHEN 1 =>
                             IF (arg1 /= "") THEN
                                    WRITE(rbuf,arg1);
                index := index + 1;            
                             ELSE 
                                EXIT;
                             END IF;
                    WHEN 2 =>
                             IF (arg2 /= "") THEN
                                    WRITE(rbuf,arg2);
                index := index + 1;            
                             ELSE 
                                EXIT;
                             END IF;
                    WHEN 3 =>
                             IF (arg3 /= "") THEN
                                    WRITE(rbuf,arg3);
                index := index + 1;            
                             ELSE 
                                EXIT;
                             END IF;
                    WHEN 4 =>
                             IF (arg4 /= "") THEN
                                    WRITE(rbuf,arg4);
                index := index + 1;            
                             ELSE 
                                EXIT;
                             END IF;
                    WHEN 5 =>
                             IF (arg5 /= "") THEN
                                    WRITE(rbuf,arg5);
                index := index + 1;            
                             ELSE 
                                EXIT;
                             END IF;
                    WHEN 6 =>
                             IF (arg6 /= "") THEN
                                   WRITE(rbuf,arg6);
                index := index + 1;            
                             ELSE 
                                EXIT;
                             END IF;
                    WHEN 7 =>
                             IF (arg7 /= "") THEN
                                   WRITE(rbuf,arg7);
                index := index + 1;            
                             ELSE 
                                EXIT;
                             END IF;
                    WHEN 8 =>
                             IF (arg8 /= "") THEN
                                   WRITE(rbuf,arg8);
                index := index + 1;            
                             ELSE 
                                EXIT;
                             END IF;
                    WHEN 9 =>
                             IF (arg9 /= "") THEN
                                   WRITE(rbuf,arg9);
                index := index + 1;            
                             ELSE 
                                EXIT;
                             END IF;
                    WHEN 10 =>
                             IF (arg10 /= "") THEN
                                   WRITE(rbuf,arg10);
                index := index + 1;            
                             ELSE 
                                EXIT;
                             END IF;

                    WHEN 11 => -- should not happen
                               Assert false
                               Report "fprint -- String buffer, arguments > 10 "
                               SEVERITY ERROR;                             
                END CASE;     
              -- increment the argument number
                ArgNum := ArgNum + 1;
                
           ELSIF (ch /= '%') THEN        -- printable characters
               WRITE(rbuf,ch);
           END IF;
           EXIT WHEN ((index >= format'LENGTH) OR ( buf_indx >= string_buf'LENGTH)) ;    
         END LOOP;                                --  end of while true loop

         IF (buf_indx > string_buf'LENGTH) THEN
		string_buf := rbuf.all;
         ELSIF (buf_indx = string_buf'LENGTH) THEN
		string_buf := rbuf.all;
	 ELSE	
                buf_indx := rbuf'LENGTH;
		string_buf(1 TO buf_indx) := rbuf.all;
         END IF;
         deallocate(rbuf);
         return;
      END fprint;

   PROCEDURE fgetline  ( VARIABLE l_str   : OUT STRING;
                         VARIABLE stream  : IN ASCII_TEXT
                       ) IS
        VARIABLE ch        : character := ' ';
        VARIABLE indx      : integer := 0;
        VARIABLE str_copy  : STRING(1 TO max_string_len);
   BEGIN
     IF ENDFILE(stream) THEN
        assert false 
           report " fgetline (ASCII_TEXT)  --- end of file, nothing to read."
           severity WARNING;
        if (l_str'LENGTH > 0 ) then
           l_str(l_str'LEFT) := NUL;
        end if;
        return;
      ELSE
        while ( (not ENDFILE(stream)) and (ch /= END_OF_LINE_MARKER(1)) ) loop
           READ(stream, ch);
           indx := indx + 1;
           str_copy(indx) := ch;
        end loop;
        -- determine the length and place characters
        IF (l_str'LENGTH <=  indx) THEN
                l_str := str_copy(1 TO l_str'LENGTH);
        ELSE
                l_str(1 TO indx) := str_copy(1 TO indx);
                l_str(indx+1) := NUL;
        END IF;
        RETURN;
     END IF;

   END;

    PROCEDURE StrCpy   ( VARIABLE l_str : OUT STRING;
                         CONSTANT r_str : IN  STRING) IS
       VARIABLE  l_len     : integer := l_str'LENGTH;
       VARIABLE  r_len     : integer := r_str'LENGTH;
       VARIABLE  r         : STRING ( 1 to r_len) := r_str;
       VARIABLE result     : STRING (1 to l_len);
       VARIABLE indx       : integer := 1;
    BEGIN

       while ( (indx <= r_len) and (indx <= l_len) and (r(indx) /= NUL) ) loop
          result(indx) := r(indx);
          indx := indx + 1;
       end loop;
       if (indx <= l_len) then
          result(indx) := NUL;
       end if;
       l_str := result;
       return;
    END StrCpy;

   FUNCTION To_String ( CONSTANT val    : in TIME) RETURN STRING IS
   
  variable temp    : line;
  variable temptime    : time;
  variable txt     : string (1 to 20);
  
  BEGIN
    temptime := val; 
    WRITE(temp,temptime);
    txt := (others => ' ');
    txt(1 to temp'length) := temp.all;
    deallocate(temp);
    return txt;
  END;
                      
        FUNCTION To_String ( CONSTANT val    : IN INTEGER;
                             CONSTANT format : IN STRING := "%d"
                           ) RETURN STRING IS
                VARIABLE buf        : STRING(max_string_len DOWNTO 1) ; -- implicitly == NUL
            VARIABLE rbuf       : STRING(max_string_len DOWNTO 1) ;
            VARIABLE str_index  : INTEGER := 0;
            VARIABLE ival       : INTEGER;
            VARIABLE format_cpy : STRING(1 TO format'LENGTH) := format;
            VARIABLE fw         : INTEGER;  -- field width
            VARIABLE precis     : INTEGER;
            VARIABLE justy      : BIT := '0';

        BEGIN
        -- convert to positive number
          ival := ABS(val);
          IF ival = 0 THEN
        str_index := str_index + 1;
            buf(str_index) := '0';
          ELSE
        int_loop : LOOP
                str_index := str_index + 1;
                CASE (ival MOD 10) IS
                         WHEN 0 => buf (str_index) := '0';
                         WHEN 1 => buf (str_index) := '1';
                         WHEN 2 => buf (str_index) := '2';
                         WHEN 3 => buf (str_index) := '3';
                         WHEN 4 => buf (str_index) := '4';
                         WHEN 5 => buf (str_index) := '5';
                         WHEN 6 => buf (str_index) := '6';
                         WHEN 7 => buf (str_index) := '7';
                         WHEN 8 => buf (str_index) := '8';
                         WHEN 9 => buf (str_index) := '9';
                         WHEN OTHERS => NULL; -- do nothing
                END CASE;
                    ival := ival / 10;
                    EXIT int_loop WHEN ival=0;
        END LOOP;
          END IF;

            -- Handle the negative numbers here...
            IF val < 0 THEN
                str_index := str_index + 1;
                buf (str_index) := '-';
            END IF;

            RETURN buf(str_index DOWNTO 1);
        END;

    FUNCTION From_HexString   ( CONSTANT str   : IN STRING
                               ) RETURN bit_vector IS

      CONSTANT len          : Integer := 4 * str'LENGTH;
      CONSTANT hex_dig_len  : Integer := 4;
      VARIABLE str_copy     : STRING (1 TO str'LENGTH) := To_Upper(str);
      VARIABLE index        : Natural;
      VARIABLE ch           : character;
      VARIABLE i, idx       : Integer;
      VARIABLE invalid      : boolean := false;
      VARIABLE r            : bit_vector(1 TO len) ;
      VARIABLE result       : bit_vector(len - 1 DOWNTO 0);
      CONSTANT bin_zero     : bit_vector(1 to 4) := "0000";  -- this done for Mentor unsupported feature
      CONSTANT bin_one      : bit_vector(1 to 4) := "0001";
      CONSTANT bin_two      : bit_vector(1 to 4) := "0010";
      CONSTANT bin_three    : bit_vector(1 to 4) := "0011";
      CONSTANT bin_four     : bit_vector(1 to 4) := "0100";
      CONSTANT bin_five     : bit_vector(1 to 4) := "0101";
      CONSTANT bin_six      : bit_vector(1 to 4) := "0110";
      CONSTANT bin_seven    : bit_vector(1 to 4) := "0111";
      CONSTANT bin_eight    : bit_vector(1 to 4) := "1000";
      CONSTANT bin_nine     : bit_vector(1 to 4) := "1001";
      CONSTANT bin_ten      : bit_vector(1 to 4) := "1010";
      CONSTANT bin_eleven   : bit_vector(1 to 4) := "1011";
      CONSTANT bin_twelve   : bit_vector(1 to 4) := "1100";
      CONSTANT bin_thirteen : bit_vector(1 to 4) := "1101";
      CONSTANT bin_fourteen : bit_vector(1 to 4) := "1110";
      CONSTANT bin_fifteen  : bit_vector(1 to 4) := "1111";

    BEGIN
      -- Check for null input
        IF (str'LENGTH = 0) THEN
                assert false
                report " From_HexString  --- input string has zero length ";
                RETURN "";

        ELSIF  (str(str'LEFT) = NUL) THEN
                assert false
                report " From_HexString  --- input string has nul character"
                        & " at the LEFT position "
                severity ERROR;
                RETURN "";  -- null  bit_vector
        END IF;
        -- find the position of the first non_white character
        index := Find_NonBlank(str_copy,1);
        IF (index > str'length) THEN
                assert false
                report " From_HexString  --- input string is empty  ";
                RETURN "";
        ELSIF (str_copy(index)=NUL) THEN
                assert false report " From_HexString  -- first non_white character is a NUL ";
                RETURN "";
        END IF;

        i := 0;
        FOR idx IN index TO  str'length LOOP
                ch := str_copy(idx);
                EXIT WHEN ((Is_White(ch)) OR (ch = NUL));
                CASE ch IS
                  WHEN '0'        => r(i+1 TO i+ hex_dig_len) := bin_zero;
                  WHEN '1'        => r(i+1 TO i+ hex_dig_len) := bin_one;
                  WHEN '2'        => r(i+1 TO i+ hex_dig_len) := bin_two;
                  WHEN '3'        => r(i+1 TO i+ hex_dig_len) := bin_three;
                  WHEN '4'        => r(i+1 TO i+ hex_dig_len) := bin_four;
                  WHEN '5'        => r(i+1 TO i+ hex_dig_len) := bin_five;
                  WHEN '6'        => r(i+1 TO i+ hex_dig_len) := bin_six;
                  WHEN '7'        => r(i+1 TO i+ hex_dig_len) := bin_seven;
                  WHEN '8'        => r(i+1 TO i+ hex_dig_len) := bin_eight;
                  WHEN '9'        => r(i+1 TO i+ hex_dig_len) := bin_nine;
                  WHEN 'A' | 'a'  => r(i+1 TO i+ hex_dig_len) := bin_ten;
                  WHEN 'B' | 'b'  => r(i+1 TO i+ hex_dig_len) := bin_eleven;
                  WHEN 'C' | 'c'  => r(i+1 TO i+ hex_dig_len) := bin_twelve;
                  WHEN 'D' | 'd'  => r(i+1 TO i+ hex_dig_len) := bin_thirteen;
                  WHEN 'E' | 'e'  => r(i+1 TO i+ hex_dig_len) := bin_fourteen;
                  WHEN 'F' | 'f'  => r(i+1 TO i+ hex_dig_len) := bin_fifteen;
                  WHEN NUL        => exit;
                  WHEN OTHERS     => -- a non  binary value was passed
                    ASSERT (invalid)
                      REPORT "From_HexString(str(" & To_String(idx) & ")) is an invalid character"
                        SEVERITY ERROR;
                          invalid := TRUE;
                END CASE;
                i := i + hex_dig_len;
        END LOOP;
     -- check for invalid character in the string
        if ( invalid ) THEN
           r(1 TO i) := (OTHERS => '0');
        end if;
        result(i - 1 DOWNTO 0) := r(1 TO i);
        return result(i - 1 DOWNTO 0);     -- return slice of result

    END;

    FUNCTION From_String   ( CONSTANT str   : IN STRING
                           ) RETURN INTEGER IS
      VARIABLE str_copy : STRING (1 TO str'LENGTH) := str;
      VARIABLE index    : Natural;
      VARIABLE ch       : character;
      VARIABLE result   : INTEGER := 0;
      VARIABLE neg_sign : boolean := false;
      VARIABLE invalid  : boolean := false;

    BEGIN
      -- Check for null input
        IF (str'LENGTH = 0) THEN
                assert false
                report " From_String  --- input string has zero length "
                severity ERROR;
                RETURN INTEGER'LEFT;
        END IF;
        -- find the position of the first non_white character
        index := Find_NonBlank(str_copy,1);
        IF (index > str'length) THEN
                assert false
                report " From_String  --- input string is empty  ";
                RETURN INTEGER'LEFT;
        ELSIF (str_copy(index)=NUL) THEN
                assert false report " From_String  -- first non_white character is a NUL ";
                RETURN INTEGER'LEFT;
        END IF;
        ch := str_copy(index);
       -- check for - sign or + sign
        IF (ch = '-') Then
            neg_sign := NOT neg_sign;
            index := index + 1;
            ch := str_copy(index);      -- get_char
        elsif (ch = '+') then
            index := index + 1;
            ch := str_copy(index);      -- get_char
        END IF;

      -- Strip off leading zero's
        While ( (ch = '0')  AND (index < str'LENGTH)) LOOP
              index := index + 1;
              ch := str_copy(index);     -- get_char
        END LOOP;
        For i in index TO str'LENGTH LOOP
               ch := str_copy(i);
               if (Is_Digit(ch)) then
                    result := result * 10 + ( CHARACTER'POS(ch)
                                              - CHARACTER'POS('0') );  -- to digit
               elsif ((Is_White(ch))  OR (ch = NUL)) THEN
                    exit;
               else
                    invalid := TRUE;
                    result := INTEGER'LEFT;
                    ASSERT FALSE
                    REPORT "From_String(str(" & To_String(i) & ")) is an invalid character "
                    SEVERITY ERROR;
                    exit;
               end if;
        end loop;
        if ( neg_sign  AND (not invalid) )THEN
            result := - result;
        END IF;
        return result;

    END;

       PROCEDURE fscan ( CONSTANT string_buf     : IN STRING;
                         CONSTANT format         : IN STRING;
                         VARIABLE arg1           : OUT STRING;
                         VARIABLE arg2           : OUT STRING;
                         VARIABLE arg3           : OUT STRING;
                         VARIABLE arg4           : OUT STRING;
                         VARIABLE arg5           : OUT STRING;
                         VARIABLE arg6           : OUT STRING;
                         VARIABLE arg7           : OUT STRING;
                         CONSTANT arg_count       : IN INTEGER := 7
                        ) IS
           VARIABLE str_buffer  : STRING(1 TO string_buf'LENGTH) := string_buf;
 -- hold string buffer
           VARIABLE fmt         : STRING(1 TO format'LENGTH) := format;
 -- hold format
           VARIABLE index       : INTEGER := 1;
 -- index into fmt
           VARIABLE str_indx    : INTEGER := 1;
 -- index into str_buffer
           VARIABLE fmt_len     : INTEGER;
 -- length of format
           VARIABLE ch          : CHARACTER;
 -- present character read from string buffer
           VARIABLE fchar       : CHARACTER;
 -- present format character
           VARIABLE look_ahead  : CHARACTER;
 -- next format character
           VARIABLE mismatch    : BOOLEAN := FALSE;
 -- TRUE if mismatch between format literal

 --    and string buffer character
           VARIABLE eof         : BOOLEAN := FALSE;
 -- TRUE if end of string buffer
           VARIABLE field_width : integer;
 -- field width
           VARIABLE string_type : CHARACTER;
 -- type of string specified by format
           VARIABLE arg_num     : INTEGER := 0;
 -- number of argument currently being read
           VARIABLE arg         : string(1 to MAX_STRING_LEN+1);
 -- used to temporarily hold argument
           VARIABLE premature_end : BOOLEAN := FALSE;
 -- true if end of string buffer reached prematurely
           VARIABLE t_follow      : string(1 to 5);
 -- used to check for time unit following %t
           VARIABLE ii, jj        : INTEGER;

    BEGIN
       -- make return strings empty
       arg1(arg1'left)   := NUL;
       arg2(arg2'left)   := NUL;
       arg3(arg3'left)   := NUL;
       arg4(arg4'left)   := NUL;
       arg5(arg5'left)   := NUL;
       arg6(arg6'left)   := NUL;
       arg7(arg7'left)   := NUL;

       index := Find_NonBlank(fmt, index);
       fmt_len := fmt'LENGTH;
       if ( index > fmt_len ) then
          assert FALSE
             report "fscan (String Buffer)  -- empty format string."
             severity ERROR;
          return;
       end if;

       eof := ( (str_indx > str_buffer'length) or (str_buffer(str_indx) = NUL));
       while ( (not eof) and (index <= fmt_len) ) loop

          fchar := fmt(index);
          look_ahead := NUL;
          mismatch := FALSE;
          if (index < fmt_len) then
             look_ahead := fmt(index+1);
          else
             look_ahead := ' ';
          end if;


          if ( (fchar = '%') and (look_ahead = '%') ) then -- check for literal%
             index := index + 2;
          elsif (fchar = '%') then
             if (arg_num = arg_count) then
                assert FALSE
                   report "fscan (String Buffer)  -- number of format specifications exceed argument count"
                   severity ERROR;
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
                   severity ERROR;
                   return;
             end if;

             case string_type is
                when 'd' | 'f' | 's' |
                     'o' | 'x' | 'X'   =>  if ( field_width = 0 ) then
                                              field_width := MAX_STRING_LEN + 1;
                                           end if;
                                           ffgetc (ch, eof, str_buffer, str_indx); -- skip over carrage return and line feed and spaces
                                           while ( (is_space(ch) or (ch = LF) or (ch = CR) ) and (not eof) ) loop
                                              ffgetc(ch, eof, str_buffer, str_indx);
                                           end loop;
                                           ii := 1;
                                           loop
                                              exit when ( eof or is_space(ch) or (ch = LF) or (ch = CR) );
                                              arg(ii) := ch;
                                              ii := ii + 1;
                                              field_width := field_width - 1;
                                              exit when (field_width = 0);
                                              ffgetc(ch, eof, str_buffer, str_indx);
                                           end loop;
                                           if ( (string_type = 't') and (not eof) and (field_width > 1) and (ch /= LF) and (ch /= CR) ) then
                                              arg(ii) := ' ';
                                              ii := ii + 1;
                                              field_width := field_width - 1;
                                              ffgetc(ch, eof, str_buffer, str_indx);
                                              loop
                                                 exit when ( eof or is_space(ch) or (ch = LF) or (ch = CR) );
                                                 arg(ii) := ch;
                                                 ii := ii + 1;
                                                 field_width := field_width - 1;
                                                 exit when (field_width = 0);
                                                 ffgetc(ch, eof, str_buffer, str_indx);
                                              end loop;
                                           end if;
                                           arg(ii) := NUL;
                                           premature_end := ( eof and (ii = 1));
                when others            =>  assert FALSE
                                              report "fscan (String Buffer)  -- error in format specification"
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
                when others  => assert FALSE
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

    END fscan;

PROCEDURE fscan ( CONSTANT string_buf     : IN STRING;
                         CONSTANT format         : IN STRING;
                         VARIABLE arg1           : OUT STRING;
                         VARIABLE arg2           : OUT STRING;
                         VARIABLE arg3           : OUT STRING;
                         VARIABLE arg4           : OUT STRING;
                         VARIABLE arg5           : OUT STRING;
                         VARIABLE arg6           : OUT STRING
                        ) IS
        VARIABLE dummy_arg7         :  STRING(1 TO 10);  -- dummy string;
   BEGIN
     -- call procedure fscan with 7 arguments
          fscan(string_buf, format, arg1, arg2, arg3, arg4,  arg5, arg6,
                dummy_arg7,6);
          return;
   END;

PROCEDURE fscan ( CONSTANT string_buf     : IN STRING;
                         CONSTANT format         : IN STRING;
                         VARIABLE arg1           : OUT STRING;
                         VARIABLE arg2           : OUT STRING;
                         VARIABLE arg3           : OUT STRING;
                         VARIABLE arg4           : OUT STRING;
                         VARIABLE arg5           : OUT STRING
                        ) IS
        VARIABLE dummy_arg6         :  STRING(1 TO 10);  -- dummy string;
        VARIABLE dummy_arg7         :  STRING(1 TO 10);  -- dummy string;
   BEGIN
     -- call procedure fscan with 7 arguments
          fscan(string_buf, format, arg1, arg2, arg3, arg4,  arg5, 
                dummy_arg6, dummy_arg7,5);
          return;
   END;

PROCEDURE fscan ( CONSTANT string_buf     : IN STRING;
                         CONSTANT format         : IN STRING;
                         VARIABLE arg1           : OUT STRING;
                         VARIABLE arg2           : OUT STRING;
                         VARIABLE arg3           : OUT STRING;
                         VARIABLE arg4           : OUT STRING
                        ) IS
        VARIABLE dummy_arg5         :  STRING(1 TO 10);  -- dummy string;
        VARIABLE dummy_arg6         :  STRING(1 TO 10);  -- dummy string;
        VARIABLE dummy_arg7         :  STRING(1 TO 10);  -- dummy string;
   BEGIN
     -- call procedure fscan with 7 arguments
          fscan(string_buf, format, arg1, arg2, arg3, arg4,
               dummy_arg5, dummy_arg6, dummy_arg7,4);
          return;
   END;

PROCEDURE fscan ( CONSTANT string_buf     : IN STRING;
                         CONSTANT format         : IN STRING;
                         VARIABLE arg1           : OUT STRING;
                         VARIABLE arg2           : OUT STRING;
                         VARIABLE arg3           : OUT STRING
                        ) IS
        VARIABLE dummy_arg4         :  STRING(1 TO 10);  -- dummy string;
        VARIABLE dummy_arg5         :  STRING(1 TO 10);  -- dummy string;
        VARIABLE dummy_arg6         :  STRING(1 TO 10);  -- dummy string;
        VARIABLE dummy_arg7         :  STRING(1 TO 10);  -- dummy string;
   BEGIN
     -- call procedure fscan with 7 arguments
          fscan(string_buf, format, arg1, arg2, arg3,
               dummy_arg4, dummy_arg5, dummy_arg6, dummy_arg7,3);
          return;
   END;

PROCEDURE fscan ( CONSTANT string_buf     : IN STRING;
                         CONSTANT format         : IN STRING;
                         VARIABLE arg1           : OUT STRING;
                         VARIABLE arg2           : OUT STRING
                        ) IS
        VARIABLE dummy_arg3         :  STRING(1 TO 10);  -- dummy string;
        VARIABLE dummy_arg4         :  STRING(1 TO 10);  -- dummy string;
        VARIABLE dummy_arg5         :  STRING(1 TO 10);  -- dummy string;
        VARIABLE dummy_arg6         :  STRING(1 TO 10);  -- dummy string;
        VARIABLE dummy_arg7         :  STRING(1 TO 10);  -- dummy string;
   BEGIN
     -- call procedure fscan with 7 arguments
          fscan(string_buf, format, arg1, arg2,
               dummy_arg3, dummy_arg4, dummy_arg5, dummy_arg6, dummy_arg7,2);
          return;
   END;

PROCEDURE fscan ( CONSTANT string_buf     : IN STRING;
                         CONSTANT format         : IN STRING;
                         VARIABLE arg1           : OUT STRING
                        ) IS
        VARIABLE dummy_arg2         :  STRING(1 TO 10);  -- dummy string;
        VARIABLE dummy_arg3         :  STRING(1 TO 10);  -- dummy string;
        VARIABLE dummy_arg4         :  STRING(1 TO 10);  -- dummy string;
        VARIABLE dummy_arg5         :  STRING(1 TO 10);  -- dummy string;
        VARIABLE dummy_arg6         :  STRING(1 TO 10);  -- dummy string;
        VARIABLE dummy_arg7         :  STRING(1 TO 10);  -- dummy string;
   BEGIN
     -- call procedure fscan with 7 arguments
          fscan(string_buf, format, arg1, dummy_arg2,
               dummy_arg3, dummy_arg4, dummy_arg5, dummy_arg6, dummy_arg7,1);
          return;
   END;

  function StrLengthHex( constant x : in integer )
    return integer is
      variable result : integer ;
  begin
    if (x mod 4 = 0) then
      result := (x / 4) ; 
    else
      result := (x/4) + 1 ;
    end if ;
    return (result) ;
  end StrLengthHex ;
  
  function To_HexString( constant val : in std_logic_vector )
    return string is
    constant ResLength : integer := StrLengthHex(val'length) ;
    variable result    : string (1 to ResLength) ;
    variable temp      : std_logic_vector(3 downto 0) ;
  begin
    for i in (ResLength-1) downto 0 loop
      result(ResLength-i) := ' ' ;
      for j in 3 downto 0 loop
        if (i = (ResLength-1)) then
          if (i*4)+j >= val'length then
            temp(j) := '0' ;
          else
            temp(j) := val( (i*4)+j ) ;
          end if ;
        else
          temp(j) := val( (i*4)+j ) ;
        end if ;
      end loop ;
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
      end case ;
    end loop ;
    return result ;
  end To_HexString ; 
  
  procedure ReportRead(
                       constant Verbosity      : in boolean;
                       constant HaltOnMismatch : in boolean;
                       constant data           : in std_logic_vector;
                       constant mask           : in std_logic_vector;
                       constant exp            : in std_logic_vector;
                       constant tag            : in string(1 to 20);
                       signal postatI          : in std_logic;
                       signal postatO          : out std_logic;
                       signal countflag        : in boolean  
                      ) is
        variable printstr  : string(1 to 255);
        
  begin
    if (((mask and data) /= (mask and exp)) and (postatI = '0')) then
      fprint(printstr,
             "PSRE: Error on data read. Expected:%s Actual:%s Mask:%s, TAG: %s",
              To_HexString(exp),
              To_HexString(data),
              To_HexString(mask),
              tag);
      postatO <= '0'; -- indicates that it is not a Poll command.
      if HaltOnMismatch then
        assert false report printstr severity failure;
      else
        assert false report printstr  severity warning;
      end if;
    elsif (postatI ='0') then
      postatO <= '0'; -- indicates that it is not a poll command.
      if Verbosity then
        fprint(printstr,"PSRC: Correct read value of %s with mask %s, TAG:%s",
               To_HexString(data),
               To_HexString(mask),
               tag);
        assert false
        report printstr
        severity note;
      end if;
    elsif ( ((mask and data) = (mask and exp)) and (postatI = '1') ) then
      if (Verbosity) then
        fprint(printstr,
            "POC: Correct value of %s polled, TAG:%s", To_HexString(exp), tag);
        assert false
        report printstr
        severity note;
      end if;
      postatO <= '0'; -- stop polling since correct value is sampled.
    elsif (((mask and data) /= (mask and exp)) and (postatI = '1'))then 
      if (countflag) then 
        if (Verbosity) then
          fprint(printstr,
                 "PO: Polling for value %s, TAG:%s ", To_HexString(exp), tag);
          assert false
          report printstr
          severity note;
        end if;
        postatO <= '1'; -- continue polling as maximum number of Polls is
                        -- not reached (countflag is TRUE). 
      else 
        fprint(printstr,
              "POE: Maximum number of Polls for value %s reached. TAG:%s ",
              To_HexString(exp), tag);
        postatO <= '0';
        assert false
        report printstr
        severity note;
      end if;
    end if;
  end ReportRead;

  procedure ReportVirRead(
                          constant Verbosity      : in boolean;
                          constant HaltOnMismatch : in boolean;
                          constant data           : in std_logic_vector;
                          constant mask           : in std_logic_vector;
                          constant exp            : in std_logic_vector;
                          constant reg            : in integer;
                          constant tag            : in string (1 to 20) ) is
        variable printstr  : string(1 to 255);
  begin
    if ((mask and data) /= (mask and exp)) then
      fprint(printstr,
             "VRE%s: Error on vector read from R%s. Expected: %s Actual: %s Mask: %s, TAG:%s", 
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
            "VRC%s :Correct read value of %s with mask %s from R%s, TAG:%s",
             To_String(reg),
             To_HexString(exp),
             To_HexString(mask),
             To_String(reg),
             tag);
      assert false
      report printstr
      severity note;
    end if;
  end ReportVirRead;

  procedure ReportVirWrite(constant data : in std_logic_vector;
                           constant mask : in std_logic_vector;
                           constant reg  : in integer) is
        variable printstr  : string(1 to 255);
  begin
    fprint(printstr, "VWI%s: Vector write of %s with mask %s to  R%s",
           To_String(reg),
           To_HexString(data),
           To_HexString(mask),
           To_String(reg));
    assert false
    report printstr
    severity note;
  end ReportVirWrite;

  procedure ReportP_Cycle(
                          constant sel       : in T_cycle;
                          constant exp       : in std_logic_vector;
                          constant mask      : in std_logic_vector;
                          constant addr      : in std_logic_vector;
                          constant data      : in std_logic_vector;
                          constant tag       : in string(1 to 20);
                          constant num_cyc   : in T_int) is
    
        variable printstr  : string(1 to 255);
        variable cyclestr  : string(1 to 14);
        variable strength  : severity_level;
  begin
    case sel is 
      when c_pnr =>
        fprint(printstr, "PNRI: Started PNR transfer at address %s, TAG:%s",
               To_HexString(addr),
               tag);
        assert false
        report printstr
        severity note;
      when c_psr =>
        fprint(printstr,
               "PSRI: Started PSR of expected data %s with mask %s from address %s, TAG:%s", 
               To_HexString(exp),
               To_HexString(mask),
               To_HexString(addr),
               tag);
         assert false
         report printstr
         severity note;
       when c_po =>
         fprint(printstr,
                "POI: Started PO of expected data %s  from address %s, TAG:%s",
                 To_HexString(exp),
                 To_HexString(addr),
                 tag);
         assert false
         report printstr
         severity note;
       when c_pnw =>
         fprint(printstr,
               "PNWI: Started PNW with data %s at address %s, TAG:%s",
                To_HexString(data),
                To_HexString(addr),
                tag);
         assert false
         report printstr
         severity note;
       when c_psw =>
         fprint(printstr,
                "PSWI: Started PSW with data %s at address %s, TAG:%s",
                To_HexString(data),
                To_HexString(addr),
                tag);
         assert false
         report printstr
         severity note;
       when c_pi =>
         fprint(printstr,
               "PII: Started PI for %s cycles, TAG:%s",
                To_String(num_cyc),
                tag);
         assert false
         report printstr
         severity note;
       when others => null;
      end case;
  end ReportP_Cycle;

  procedure ReportReset(constant nres : in std_logic) is
  begin
     if nres = '0' then
       assert false report "RESL: PRESETn asserted (LOW)" severity note;
     elsif nres = '1' then
       assert false report "RESH: PRESETn deasserted (HIGH)" severity note;
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

  function from_vec(vec : std_logic_vector(0 downto 0)) return std_logic is
  begin
    case vec is
      when "1" => return ('1');
      when "0" => return ('0');
      when "Z" => return ('Z');
      when others => return ('X');
    end case;
  end from_vec;
      
end funcs;

-- --============================= End ===============================--
