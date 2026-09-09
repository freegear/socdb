-------------------------------------------------------------------
--
-- Description: VHDL package of various functions needed for the V8
-- uProc
--


-------------------------------------------------------------------
-- $Log: v8_pkg.vhd,v $
-- Revision 1.8  1999/08/26 15:56:53  scott
-- Undid the std_ulogic'ing but left numeric_std.
--
-- Revision 1.7  1999/08/25 20:18:35  scott
-- Modified the code to use std_ulogic(_vector) and
-- IEEE numeric_std package and shorten code width
--
-- Revision 1.6  1997/11/07 17:19:41  eric
-- added conversion for ,.
--
-- Revision 1.5  1996/12/23 18:41:39  eric
-- Fixed end of file check in init_core.
--
-- Revision 1.4  1996/12/23  17:58:56  eric
-- BETA Revision 0.9 release
--
-- Revision 1.3  1996/11/11  14:55:39  eric
-- added vec2asci
--
-- Revision 1.1  1995/11/24  18:29:35  eric
-- Initial revision
--
-------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

package v8_pkg is

  type BYTE_ARRAY is array (integer range <>) of
    std_logic_vector(7 downto 0);

  procedure init_ramcore(variable ram_core : inout BYTE_ARRAY;
                         constant fname    : in    string;
                         constant partname : in    string);

  procedure hstr2int(variable instr   : in    string(1 to 2);
                     variable n       : inout integer;
                     variable errcode : out   boolean);

  function vec2int(v : std_logic_vector)
    return integer;

  function int2vec(i : integer)
    return std_logic_vector;

  function vec2asci(v : std_logic_vector(7 downto 0))
    return character;

end v8_pkg;

package body v8_pkg is

  -------------------------------------------------------------------
  --
  --   Procedure: init_ramcore
  --
  --  Parameters: ram_core -- The actual RAM core to be initialized
  --              fname    -- Name of file to initialize RAM from
  --              partname -- Name of part
  --
  -- Description: Initializes memory array from a file.  This routine 
  --              understands the following file formats:
  --
  --                      1) INTEL INTELLEC 8/MDS FORMAT
  --
  -------------------------------------------------------------------

  procedure init_ramcore(variable ram_core: inout BYTE_ARRAY;
                         constant fname:    in    string;
                         constant partname: in    string) is

    variable dummy: std_logic_vector(7 downto 0); -- Define RAM core
    variable line_buf: string(1 to 80) ;
    variable n: integer; -- n the number of data bytes in record
    variable waddr: integer; -- Word address
    variable i: integer; -- Integer variable
    variable max_addr: integer; -- Maximum address variable
    variable temp: integer; -- temp variable
    variable chardata: string(1 to 2); -- Byte of character data
    variable schar: character; -- Contains starting character
    variable inchar: character; -- Contains starting character
    variable good : boolean := false; -- read successfull
    file file_ptr : text is fname;
    variable l: line;
    variable line_num: integer := 0; -- Line number counter
    variable last_line_num: integer := 0; -- flag...

  begin
    max_addr := ram_core'high; -- Compute maximum array address
    readline(file_ptr, l);  -- Get a line
    for i in 1 to 80 loop
      read(l,inchar,good);
      exit when not good;
      exit when inchar=NUL;
      line_buf(i) := inchar;
    end loop;
    good := true;
    line_num := line_num+1; -- Increment line number

    if good then -- Process if errcd is true
      write(l,string'("Initializing "));
      write(l,partname);
      write(l,string'(" from file ==> "));
      write(l,fname);
      write(l,'.');
      writeline(output,l); -- End with period
      if line_buf(1) = ':' then -- Check if INTEL hex format
        schar := line_buf(1);
        write(l,string'("File "));
        write(l,fname);
        write(l,string'(" is in INTEL Hex format."));
        writeline(output,l);
        write(l,string'("Initializing, Please wait..."));
        writeline(output,l);

        main:loop -- Start main loop
          if line_buf(8)='0' and line_buf(9)='1' then
            -- INTEL hex file termination code
            exit; -- Exit main loop
          elsif line_buf(8 to 9) = "00" then
            -- Make sure this line is a data line
            chardata(1 to 2) := line_buf(2 to 3);
            -- Get number of data bytes in record
            hstr2int(chardata,n,good); -- Convert string to integer
            exit when not good; -- Exit loop if error
            n:=n*2; -- Up n by 2 to account for byte wide memory
            chardata(1 to 2) := line_buf(4 to 5);
            -- Get first byte of word address
            hstr2int(chardata,temp,good); -- Convert string to integer
            exit when not good; -- Exit loop if error
            chardata(1 to 2) := line_buf(6 to 7);
            -- Get second byte of word address
            hstr2int(chardata,waddr,good); -- Convert string to integer
            exit when not good; -- Exit loop if error
            waddr := temp*256+waddr; -- Convert to 16-bit number
            i:=0; -- Initalize i for loop
            -- Check array bounds here
            
            load: while i < n loop
              case line_buf(11+i) is
                when '0' =>
                  dummy(3 downto 0) := ('0','0','0','0');
                when '1' =>
                  dummy(3 downto 0) := ('0','0','0','1');
                when '2' =>
                  dummy(3 downto 0) := ('0','0','1','0');
                when '3' =>
                  dummy(3 downto 0) := ('0','0','1','1');
                when '4' =>
                  dummy(3 downto 0) := ('0','1','0','0');
                when '5' =>
                  dummy(3 downto 0) := ('0','1','0','1');
                when '6' =>
                  dummy(3 downto 0) := ('0','1','1','0');
                when '7' =>
                  dummy(3 downto 0) := ('0','1','1','1');
                when '8' =>
                  dummy(3 downto 0) := ('1','0','0','0');
                when '9' =>
                  dummy(3 downto 0) := ('1','0','0','1');
                when 'A' =>
                  dummy(3 downto 0) := ('1','0','1','0');
                when 'B' =>
                  dummy(3 downto 0) := ('1','0','1','1');
                when 'C' =>
                  dummy(3 downto 0) := ('1','1','0','0');
                when 'D' =>
                  dummy(3 downto 0) := ('1','1','0','1');
                when 'E' =>
                  dummy(3 downto 0) := ('1','1','1','0');
                when 'F' =>
                  dummy(3 downto 0) := ('1','1','1','1');
                when 'a' =>
                  dummy(3 downto 0) := ('1','0','1','0');
                when 'b' =>
                  dummy(3 downto 0) := ('1','0','1','1');
                when 'c' =>
                  dummy(3 downto 0) := ('1','1','0','0');
                when 'd' =>
                  dummy(3 downto 0) := ('1','1','0','1');
                when 'e' =>
                  dummy(3 downto 0) := ('1','1','1','0');
                when 'f' =>
                  dummy(3 downto 0) := ('1','1','1','1');
                when others =>
                  dummy(3 downto 0) := ('X','X','X','X');
                  write(l,partname);
                  write(l,string'(" ERROR: Unrecognized character "));
                  write(l,line_buf(11+i));
                  write(l,string'(" in file ==> "));
                  write(l,fname);
                  write(l,string'(", line # "));
                  write(l,line_num);
                  write(l,'.'); -- End with period
                  writeline(output,l);
                  write(l,string'("Setting memory location to X's."));
                  writeline(output,l);
              end case;
              
              case line_buf(10+i) is
                when '0' =>
                  dummy(7 downto 4) := ('0','0','0','0');
                when '1' =>
                  dummy(7 downto 4) := ('0','0','0','1');
                when '2' =>
                  dummy(7 downto 4) := ('0','0','1','0');
                when '3' =>
                  dummy(7 downto 4) := ('0','0','1','1');
                when '4' =>
                  dummy(7 downto 4) := ('0','1','0','0');
                when '5' =>
                  dummy(7 downto 4) := ('0','1','0','1');
                when '6' =>
                  dummy(7 downto 4) := ('0','1','1','0');
                when '7' =>
                  dummy(7 downto 4) := ('0','1','1','1');
                when '8' =>
                  dummy(7 downto 4) := ('1','0','0','0');
                when '9' =>
                  dummy(7 downto 4) := ('1','0','0','1');
                when 'A' =>
                  dummy(7 downto 4) := ('1','0','1','0');
                when 'B' =>
                  dummy(7 downto 4) := ('1','0','1','1');
                when 'C' =>
                  dummy(7 downto 4) := ('1','1','0','0');
                when 'D' =>
                  dummy(7 downto 4) := ('1','1','0','1');
                when 'E' =>
                  dummy(7 downto 4) := ('1','1','1','0');
                when 'F' =>
                  dummy(7 downto 4) := ('1','1','1','1');
                when 'a' =>
                  dummy := ('1','0','1','0') & dummy(3 downto 0);
                when 'b' =>
                  dummy := ('1','0','1','1') & dummy(3 downto 0);
                when 'c' =>
                  dummy := ('1','1','0','0') & dummy(3 downto 0);
                when 'd' =>
                  dummy := ('1','1','0','1') & dummy(3 downto 0);
                when 'e' =>
                  dummy := ('1','1','1','0') & dummy(3 downto 0);
                when 'f' =>
                  dummy := ('1','1','1','1') & dummy(3 downto 0);
                when others =>
                  dummy(7 downto 4) := ('X','X','X','X');
                  write(l,partname);
                  write(l,string'(" ERROR: Unrecognized character "));
                  write(l,line_buf(10+i));
                  write(l,string'(" in file ==> "));
                  write(l,fname);
                  write(l,string'(", line # "));
                  write(l,line_num);
                  write(l,'.'); -- End with period
                  writeline(output,l);
                  write(l,string'("Setting memory location to X's."));
                  writeline(output,l);
              end case;
              temp := waddr + (i/2);
              if temp > max_addr then
                -- Issue a warning if outside memory size
                temp := temp mod (max_addr+1);
                if (line_num /= last_line_num) then
                  write(l,partname);
                  write(l,string'(" ERROR: Address in line # "));
                  write(l,line_num);
                  write(l,string'(" out of memory range."));
                  write(l,string'("Writting data anyway."));
                  writeline(output,l);
                end if;
                last_line_num := line_num;
              end if;
              if (not Is_X(ram_core(temp))) then
                -- we are overwritting something in ram???
                write(l,partname);
                write(l,string'(" Warning: Overwriting data in RAM@"));
                write(l,temp);
                writeline(output,l);
              end if;
              ram_core(temp) := dummy; -- Write slice to RAM core
              i:=i+2;
            end loop load;
          end if;

          readline(file_ptr, l);  -- Read next line
          for i in 1 to 80 loop
            read(l,inchar,good);
            exit when not good;
            exit when inchar=NUL;
            line_buf(i) := inchar;
          end loop;
          good := true;
          line_num := line_num+1; -- Increment line number

          if line_buf(1) /= schar then
            write(l,partname);
            write(l,string'(" ERROR: Expecting start character '"));
            write(l,schar);
            write(l,string'("' received character '"));
            write(l,line_buf(1));
            write(l,string'("' in line # "));
            write(l,line_num);
            write(l,'.'); -- End with period
            writeline(output,l);
            write(l,string'("Aborting initialization."));
            writeline(output,l);
            exit; -- Exit main loop aborted init
          end if;
        end loop main; -- End of main loop
        write(l,string'("Total lines read:"));
        write(l,line_num);
        write(l,'.');
        writeline(output,l);
      else
        write(l,partname);
        write(l,string'(" ERROR: Unrecognized file format."));
        write(l,string'("Aborting initialization."));
        writeline(output,l);
      end if;
    else -- File error reading first line
      write(l,partname);
      write(l,string'(" ERROR: Cannot read file ==> "));
      write(l,fname);
      write(l,'.'); -- End with period
      write(l,string'("Aborting initialization."));
      writeline(output,l);
    end if;
  end init_ramcore;

  -------------------------------------------------------------------
  --
  --   Procedure: hstr2int
  --
  --  Parameters: instr   -- Input string to be converted
  --              n       -- Integer output
  --              errcode -- Boolean error code variable
  --
  -- Description: Converts a hex byte input string to integer.
  --              Variable errcode is set to TRUE unless conversion 
  --              failed, in which case it is set to FALSE.
  --
  -------------------------------------------------------------------

  procedure hstr2int(variable instr:   in    string(1 to 2);
                     variable n:       inout integer;
                     variable errcode: out   boolean) is

    variable temp1: integer; -- Temporary variable
    variable temp2: integer; -- Temporary variable

  begin -- Convert string to integer

    errcode := true;

    case instr(2) is
      when '0' => temp2:=0;
      when '1' => temp2:=1;
      when '2' => temp2:=2;
      when '3' => temp2:=3;
      when '4' => temp2:=4;
      when '5' => temp2:=5;
      when '6' => temp2:=6;
      when '7' => temp2:=7;
      when '8' => temp2:=8;
      when '9' => temp2:=9;
      when 'A' => temp2:=10;
      when 'B' => temp2:=11;
      when 'C' => temp2:=12;
      when 'D' => temp2:=13;
      when 'E' => temp2:=14;
      when 'F' => temp2:=15;
      when 'a' => temp2:=10;
      when 'b' => temp2:=11;
      when 'c' => temp2:=12;
      when 'd' => temp2:=13;
      when 'e' => temp2:=14;
      when 'f' => temp2:=15;
      when others =>
        temp2:=0;
        errcode := false;
    end case;

    case instr(1) is
      when '0' => temp1:=0;
      when '1' => temp1:=16;
      when '2' => temp1:=32;
      when '3' => temp1:=48;
      when '4' => temp1:=64;
      when '5' => temp1:=80;
      when '6' => temp1:=96;
      when '7' => temp1:=112;
      when '8' => temp1:=128;
      when '9' => temp1:=144;
      when 'A' => temp1:=160;
      when 'B' => temp1:=176;
      when 'C' => temp1:=192;
      when 'D' => temp1:=208;
      when 'E' => temp1:=224;
      when 'F' => temp1:=240;
      when 'a' => temp1:=160;
      when 'b' => temp1:=176;
      when 'c' => temp1:=192;
      when 'd' => temp1:=208;
      when 'e' => temp1:=224;
      when 'f' => temp1:=240;
      when others =>
        temp1:=0;
        errcode := false;
    end case;

    n:=temp1+temp2; -- Compute result and end

  end hstr2int;

  --------------------------------------------------------------
  -- This function will convert an integer into a vector up to 32
  -- bits. If the vector is less bits than is needed for the integer,
  -- the upper bits are truncated. this function assumes that the
  -- vector is declared v'high downto v'low There is some tricky stuff
  -- if the vector is 32 bits and the MSB is 1. but it does convert
  -- properly.
  function vec2int(v: std_logic_vector) return integer is
    variable vec: std_logic_vector(v'range) := v;
    variable result: integer := 0;
    variable addition: integer := 1;
    variable high: integer := v'high;
    variable neg: boolean := false;
  begin
    if v'length=32 then
      high := v'high-1;
      if v(v'high)='1'then  -- invert if negative
        vec := not vec;
        neg := true;
      end if;
    end if;
    if vec(v'low) = '1' then -- we do the first bit outside the loop
      result := result + addition; -- so that the addition is done
    end if; -- for the current bit so it won't overflow.
    for b in v'low+1 to high loop
      addition := addition * 2;
      if vec(b) = '1' then
        result := result + addition;
      end if;
    end loop;
    if neg then
      result := -result-1;
    end if; --take the 2's compl to set MSB
    return result;
  end;
  
  --------------------------------------------------------------------
  function int2vec(i: integer)
    return std_logic_vector is
    variable temp: integer := i;
    variable result: std_logic_vector (31 downto 0) :=
      ('0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0',
       '0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0');
  begin
    if temp < 0 then  -- do the MSB first since it's tricky
      result(31) := '1';
      temp := -(temp+1);
    end if;
    for b in 0 to 30 loop -- rest is easy
      if temp rem 2 = 1 then
        result (b) := '1';
      end if;
      temp := temp / 2;
    end loop;
    if result(31)='1' then
      result(30 downto 0) := not result(30 downto 0); -- ones complement
    end if;
    return result;
  end;

  function vec2asci (v: std_logic_vector(7 downto 0))
    return character is
  begin
    case v is
      when "00001101"              => return (' '); -- CR
      when "01000001" | "01100001" => return ('A');
      when "01000010" | "01100010" => return ('B');
      when "01000011" | "01100011" => return ('C');
      when "01000100" | "01100100" => return ('D');
      when "01000101" | "01100101" => return ('E');
      when "01000110" | "01100110" => return ('F');
      when "01000111" | "01100111" => return ('G');
      when "01001000" | "01101000" => return ('H');
      when "01001001" | "01101001" => return ('I');
      when "01001010" | "01101010" => return ('J');
      when "01001011" | "01101011" => return ('K');
      when "01001100" | "01101100" => return ('L');
      when "01001101" | "01101101" => return ('M');
      when "01001110" | "01101110" => return ('N');
      when "01001111" | "01101111" => return ('O');
      when "01010000" | "01110000" => return ('P');
      when "01010001" | "01110001" => return ('Q');
      when "01010010" | "01110010" => return ('R');
      when "01010011" | "01110011" => return ('S');
      when "01010100" | "01110100" => return ('T');
      when "01010101" | "01110101" => return ('U');
      when "01010110" | "01110110" => return ('V');
      when "01010111" | "01110111" => return ('W');
      when "01011000" | "01111000" => return ('X');
      when "01011001" | "01111001" => return ('Y');
      when "01011010" | "01111010" => return ('Z');
      when "00100000"              => return (' ');
      when "00100001"              => return ('!');
      when "00101000"              => return ('(');
      when "00101001"              => return (')');
      when "00101100"              => return (',');
      when "00101110"              => return ('.');
      when "00111111"              => return ('?');
      when "00110000"              => return ('0');
      when "00110001"              => return ('1');
      when "00110010"              => return ('2');
      when "00110011"              => return ('3');
      when "00110100"              => return ('4');
      when "00110101"              => return ('5');
      when "00110110"              => return ('6');
      when "00110111"              => return ('7');
      when "00111000"              => return ('8');
      when "00111001"              => return ('9');
      when "00111101"              => return ('=');
      when "01011011"              => return ('[');
      when "01011101"              => return (']');
      when others => return ('?');
    end case;
  end;
end v8_pkg;
