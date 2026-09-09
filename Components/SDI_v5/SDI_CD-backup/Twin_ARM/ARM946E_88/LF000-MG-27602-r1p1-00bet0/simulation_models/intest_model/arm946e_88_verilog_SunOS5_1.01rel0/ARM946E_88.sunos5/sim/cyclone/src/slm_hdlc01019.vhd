
library IEEE;
use IEEE.std_logic_1164.all;

-- This package directly links the C library calls with
-- VHDL procedure calls.

package SLM_PKG is

Constant SLM_APP_TYPE_ID_RESERVED: integer := 0;
Constant SLM_APP_TYPE_ID_MEMPRO: integer := 1;
Constant SLM_APP_TYPE_ID_ECLIPSE: integer := 2;
Constant SLM_APP_TYPE_ID_ESV: integer := 3;

Constant SLM_MAX_ARRAY_SIZE: integer := 2048;

type SLM_INT_ARRAY is array (NATURAL range <>) of INTEGER;

procedure slm_post(
	appTypeID: in integer;
	intMaxCnt: in integer; intActualCnt: inout integer; intArray: inout SLM_INT_ARRAY;
	slMaxCnt: in integer; slActualCnt: inout integer; slArray: inout std_logic_vector;
	charMaxCnt: in integer; charActualCnt: inout integer; charArray: inout STRING;
	status: out integer);  

procedure slm_post_hdl(
	cntArray:  inout SLM_INT_ARRAY;
        intArray:  inout SLM_INT_ARRAY;
        slArray:   inout std_logic_vector;
        charArray: inout STRING );  
attribute FOREIGN of slm_post_hdl : procedure is "lm_sw_slm_post";

end;

-- The following package body is required, but with the
-- FOREIGN attribute specified, package body is not
-- elaborated, as per LCS 0026, entitled "Foreign Interface".

package body SLM_PKG is

procedure slm_post(
	appTypeID: in integer;
	intMaxCnt: in integer; intActualCnt: inout integer; intArray: inout SLM_INT_ARRAY;
	slMaxCnt: in integer; slActualCnt: inout integer; slArray: inout std_logic_vector;
	charMaxCnt: in integer; charActualCnt: inout integer; charArray: inout STRING;
	status: out integer) is  

variable cntArray: SLM_INT_ARRAY(0 to 7);

begin
	cntArray(0) := appTypeID;
	cntArray(1) := intMaxCnt;
	cntArray(2) := intActualCnt;
	cntArray(3) := slMaxCnt;
	cntArray(4) := slActualCnt;
	cntArray(5) := charMaxCnt;
	cntArray(6) := charActualCnt;

        slm_post_hdl( cntArray, intArray, slArray, charArray );

        intActualCnt  := cntArray(2);
        slActualCnt   := cntArray(4);
        charActualCnt := cntArray(6);
        status        := cntArray(7);

end;  

procedure slm_post_hdl(
	cntArray:  inout SLM_INT_ARRAY;
        intArray:  inout SLM_INT_ARRAY;
        slArray:   inout std_logic_vector;
        charArray: inout STRING ) is
begin
end;  

end;


library IEEE;
use IEEE.std_logic_1164.all;

use STD.textio.all;

package SLM_UTIL_PKG is

-- VHDL utility functions

function slm_to_string(v:std_logic_vector) return string;

function slm_to_stdlogic(value:integer;sz:integer) return std_logic_vector;

end;


package body SLM_UTIL_PKG is

-- Convert std_logic_vector to a string for use in assert statements
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
