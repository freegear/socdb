
library IEEE;
use IEEE.std_logic_1164.all;

-- This package directly links the C library calls with
-- VHDL procedure calls.

package SLM_PKG is

Constant SLM_APP_TYPE_ID_RESERVED: integer := 0;
Constant SLM_APP_TYPE_ID_MEMPRO: integer := 1;
Constant SLM_APP_TYPE_ID_ECLIPSE: integer := 2;
Constant SLM_APP_TYPE_ID_ESV: integer := 3;
Constant SLM_APP_TYPE_ID_TIMING_CORE : integer := 5;

Constant SLM_MAX_ARRAY_SIZE: integer := 2048;

type SLM_INT_ARRAY is array (NATURAL range <>) of INTEGER;

shared variable globCntArray : SLM_INT_ARRAY( 0 to 7 );
shared variable globIntArray : SLM_INT_ARRAY( 0 to SLM_MAX_ARRAY_SIZE );
shared variable globSlArray  : std_logic_vector( SLM_MAX_ARRAY_SIZE downto 0 );
shared variable globCharArray  : STRING( 1 to  SLM_MAX_ARRAY_SIZE );
shared variable strobeCounter: integer := 0;
shared variable intsize, slsize, chsize, globslsize, globintsize, globchsize: integer;

procedure slm_post_hdl(
	cntArray:  inout SLM_INT_ARRAY;
	intArray:  inout SLM_INT_ARRAY;
	slArray:   inout std_logic_vector;
	charArray: inout STRING );

-- This procedure is not used.
procedure slm_post(
        appTypeID: in integer;
        intMaxCnt: in integer; intActualCnt: inout integer; intArray: inout SLM_INT_ARRAY;
        slMaxCnt: in integer; slActualCnt: inout integer; slArray: inout std_logic_vector;
        charMaxCnt: in integer; charActualCnt: inout integer; charArray: inout STRING;
        status: out integer);  

end;

package body SLM_PKG is

-- This procedure is not used.
procedure slm_post(
        appTypeID: in integer;
        intMaxCnt: in integer; intActualCnt: inout integer; intArray: inout SLM_INT_ARRAY;
        slMaxCnt: in integer; slActualCnt: inout integer; slArray: inout std_logic_vector;
        charMaxCnt: in integer; charActualCnt: inout integer; charArray: inout STRING;
        status: out integer) is
begin
end;

procedure slm_post_hdl( 
	cntArray : inout SLM_INT_ARRAY; 
	intArray : inout SLM_INT_ARRAY;  
	slArray : inout std_logic_vector;
	charArray : inout STRING
	) is
begin

	if( slArray'ASCENDING ) then 
		slsize := slArray'RIGHT;
	else
		slsize := slArray'LEFT;
	end if;

	intsize := intArray'RIGHT;
	chsize := charArray'RIGHT;

	globCntArray := cntArray;
	globIntArray( 0 to intsize ) := intArray;
	globSlArray( slsize downto 0) := slArray;
	globCharArray( 1 to chsize ) := charArray;
	strobeCounter := strobeCounter + 1;

-- Return Data

	cntArray := globCntArray;

	if ( cntArray(2) = 0 ) then
		globintsize := 0;
	else
		globintsize := cntArray(2) - 1;
	end if;

	if ( cntArray(4) = 0 ) then
		globslsize := 0;
	else
		globslsize := cntArray(4) - 1;
	end if;

	if ( cntArray(6) = 0 ) then
		globchsize := 0;
	else
		globchsize := cntArray(6);
	end if;

	intArray( 0 to globintsize ) := globIntArray( 0 to globintsize );
	if ( slArray'ASCENDING ) then
		slArray( 0 to globslsize ) := globSlArray( globslsize downto 0 );
	else
		slArray( globslsize downto 0 ) := globSlArray( globslsize downto 0 );
	end if;
	charArray( 1 to globchsize ) := globCharArray( 1 to globchsize );
	
end;

end;


library IEEE;
use IEEE.std_logic_1164.all;

use STD.textio.all;

package SLM_UTIL_PKG is

-- VHDL utility functions

function slm_xor_reduce(arg: std_logic_vector) return std_logic;

function slm_to_string(ftime:time) return string;

function slm_to_string(v:std_logic_vector) return string;

function slm_to_stdlogic(value:integer;sz:integer) return std_logic_vector;

end;

package body SLM_UTIL_PKG is

function slm_xor_reduce(arg: std_logic_vector) return std_logic is
variable result: std_logic;
begin
    result := '0';
    for i in ARG'range loop
        result := result xor ARG(i);
    end loop;
    if result = 'U' then  -- Map 'U' state to 'X'
       return 'X';
    end if;
    return result;
end slm_xor_reduce;

-- Convert time to a string for use in assert statements
function slm_to_string(ftime:time) return string is
  variable aline : line;
  variable str   : string(1 to 30) := (others=>' ');
  variable ok    : boolean := true;
  constant tbase : time    := time'val(1);
  variable slen  : integer := str'length;
  variable tlen  : integer := 1;
begin
   write(aline,ftime,right,slen,TBASE);
   read(aline,str,ok);
   assert ok report " TO_STRING : bad time conversion" severity warning;
   for i in 1 to slen loop
     if str(i) /= ' ' then
        tlen := i;
        exit;
     end if;
   end loop;
   return (str(tlen to slen));
end slm_to_string;

-- Convert slm_std_logic_vector to a string for use in assert statementsfunction
function slm_to_string(v:std_logic_vector) return string is
variable res : string(v'length downto 1);
type tbl_of_char is array(std_logic) of character;
constant tbl : tbl_of_char := ('U','X','0','1','Z','W','L','H','-');
begin
    for i in 1 to res'length loop
       res(i) := tbl(v(i-1));
    end loop;
    return res;
end slm_to_string;

function slm_to_stdlogic(value:integer;sz:integer) return std_logic_vector is
variable val : std_logic_vector(31 downto 0):=(others=>'0');
variable tmp : integer := value;
variable minus : boolean := FALSE;

begin
  if value < 0 then
     minus := TRUE;
     tmp := integer'high + value + 1;
  end if;

  for i in 0 to 31 loop
    if (tmp rem 2) = 1 then
       val(i) := '1';
    else
       val(i) := '0';
    end if;
    tmp := tmp / 2;
    exit when tmp = 0;
  end loop;
  if minus then
     val(sz-1) := '1';
  end if;
  return val(sz-1 downto 0);
end slm_to_stdlogic;

end;


 
