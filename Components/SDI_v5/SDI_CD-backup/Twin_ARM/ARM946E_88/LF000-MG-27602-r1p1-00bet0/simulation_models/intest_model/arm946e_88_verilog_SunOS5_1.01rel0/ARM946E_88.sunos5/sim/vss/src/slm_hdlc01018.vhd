
library IEEE;
use IEEE.std_logic_1164.all;

library SYNOPSYS;
use SYNOPSYS.ATTRIBUTES.all;

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

-- Constants and types for getting back the return data on VSS
Constant SLM_STATUS_SLOT: integer := 0;
Constant SLM_INT_CNT_SLOT: integer := 1;
Constant SLM_SL_CNT_SLOT: integer := 2;
Constant SLM_CHAR_CNT_SLOT: integer := 3;

type SLM_RET_STAT_INFO_ARRAY is array (SLM_STATUS_SLOT to SLM_CHAR_CNT_SLOT) of INTEGER;

procedure slm_post(
	appTypeID: in integer;
	intMaxCnt: in integer; intActualCnt: inout integer; intArray: inout SLM_INT_ARRAY;
	slMaxCnt: in integer; slActualCnt: inout integer; slArray: inout std_logic_vector;
	charMaxCnt: in integer; charActualCnt: inout integer; charArray: inout STRING;
	status: out integer);  

procedure slm_post_hdl(
	cntArray: inout SLM_INT_ARRAY;
	intArray: inout SLM_INT_ARRAY;
	slArray: inout std_logic_vector;
	charArray: inout STRING);  

-- Utility functions required by the VSS implementation

function slm_post_internal( packedIntArray: SLM_INT_ARRAY; intArray: SLM_INT_ARRAY;
	slArray: std_logic_vector; charArray: STRING
) return SLM_RET_STAT_INFO_ARRAY;  
attribute FOREIGN of slm_post_internal : function is "Synopsys:CLI";
attribute CLI_FUNCTION of slm_post_internal : function is "cli_slm_post";

-- NOTE: Need to use 'string' as dummy to avoid VSS error condition
function slm_get_int_array(dummy: STRING) return SLM_INT_ARRAY;
attribute FOREIGN of slm_get_int_array : function is "Synopsys:CLI";
attribute CLI_FUNCTION of slm_get_int_array : function is "cli_slm_get_int_array";

-- NOTE: Need to use 'string' as dummy to avoid VSS error condition
function slm_get_sl_array(dummy: STRING) return std_logic_vector;
attribute FOREIGN of slm_get_sl_array : function is "Synopsys:CLI";
attribute CLI_FUNCTION of slm_get_sl_array : function is "cli_slm_get_sl_array";

-- NOTE: Need to use 'string' as dummy to avoid VSS error condition
function slm_get_char_array(dummy: STRING) return STRING;
attribute FOREIGN of slm_get_char_array : function is "Synopsys:CLI";
attribute CLI_FUNCTION of slm_get_char_array : function is "cli_slm_get_char_array";

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
variable arrRetStatInfo: SLM_RET_STAT_INFO_ARRAY;
variable dummyParam: STRING (1 to 1);
variable dummySlArray: std_logic_vector((slMaxCnt-1) downto 0);
variable dummyIntArray: SLM_INT_ARRAY(0 to (intMaxCnt-1));

variable packedIntArray: SLM_INT_ARRAY(0 to 6);

begin

        packedIntArray(0) := appTypeID;
        packedIntArray(1) := intMaxCnt;
        packedIntArray(2) := intActualCnt;
        packedIntArray(3) := slMaxCnt;
        packedIntArray(4) := slActualCnt;
        packedIntArray(5) := charMaxCnt;
        packedIntArray(6) := charActualCnt;

	-- Call the most routine to send the basic request across
        arrRetStatInfo := slm_post_internal( packedIntArray, intArray, slArray, charArray );

	-- Set the return status
	status := arrRetStatInfo(SLM_STATUS_SLOT);

	-- See if we need to pull back any return data
	intActualCnt := arrRetStatInfo(SLM_INT_CNT_SLOT);
	if (intActualCnt > 0) then
		dummyIntArray(0 to (intActualCnt-1)) := slm_get_int_array(dummyParam);
		intArray := dummyIntArray(intArray'RANGE);
	end if;
	slActualCnt := arrRetStatInfo(SLM_SL_CNT_SLOT);
	if (slActualCnt > 0) then
		dummySlArray((slActualCnt-1) downto 0) := slm_get_sl_array(dummyParam);
                slArray := dummySlArray(slArray'RANGE);
	end if;
	charActualCnt := arrRetStatInfo(SLM_CHAR_CNT_SLOT);
	if (charActualCnt > 0) then
		charArray := slm_get_char_array(dummyParam);
	end if;

end;  

procedure slm_post_hdl(
	cntArray: inout SLM_INT_ARRAY;
	intArray: inout SLM_INT_ARRAY;
	slArray: inout std_logic_vector;
	charArray: inout STRING) is  
variable arrRetStatInfo: SLM_RET_STAT_INFO_ARRAY;
variable dummyParam: STRING (1 to 1);
variable dummySlArray: std_logic_vector((cntArray(3)-1) downto 0);
variable dummyIntArray: SLM_INT_ARRAY(0 to (cntArray(1)-1));

begin

	-- Call the most routine to send the basic request across
        arrRetStatInfo := slm_post_internal( cntArray, intArray, slArray, charArray );

	-- Set the return status
	cntArray(7) := arrRetStatInfo(SLM_STATUS_SLOT);

	-- See if we need to pull back any return data
	cntArray(2) := arrRetStatInfo(SLM_INT_CNT_SLOT);
	if (cntArray(2) > 0) then
		dummyIntArray(0 to (cntArray(2)-1)) := slm_get_int_array(dummyParam);
		intArray := dummyIntArray(intArray'RANGE);
	end if;
	cntArray(4) := arrRetStatInfo(SLM_SL_CNT_SLOT);
	if (cntArray(4) > 0) then
	   dummySlArray((cntArray(4)-1) downto 0) := slm_get_sl_array(dummyParam)((cntArray(4)-1) downto 0);
           slArray((cntArray(4)-1) downto 0) := dummySlArray((cntArray(4)-1) downto 0);
	end if;
	cntArray(6) := arrRetStatInfo(SLM_CHAR_CNT_SLOT);
	if (cntArray(6) > 0) then
		charArray := slm_get_char_array(dummyParam);
	end if;

end;

function slm_post_internal( packedIntArray: SLM_INT_ARRAY; intArray: SLM_INT_ARRAY;
slArray: STD_LOGIC_VECTOR; charArray: STRING ) return SLM_RET_STAT_INFO_ARRAY is  
variable dummyRet: SLM_RET_STAT_INFO_ARRAY;
begin
	return dummyRet;
end;

function slm_get_int_array(dummy: STRING) return SLM_INT_ARRAY is
variable dummyRet: SLM_INT_ARRAY(0 to 0);
begin
	return dummyRet;
end;

function slm_get_sl_array(dummy: STRING) return std_logic_vector is
variable dummyRet: std_logic_vector(0 downto 0);
begin
	return dummyRet;
end;

function slm_get_char_array(dummy: STRING) return STRING is
variable dummyRet: STRING (1 to 1);
begin
	return dummyRet;
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

-- Convert std_logic_vector to a string for use in assert statementsfunction
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
