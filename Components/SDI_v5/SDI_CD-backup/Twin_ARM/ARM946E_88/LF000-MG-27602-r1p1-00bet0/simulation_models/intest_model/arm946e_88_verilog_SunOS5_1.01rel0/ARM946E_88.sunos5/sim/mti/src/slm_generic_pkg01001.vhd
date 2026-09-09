--------------------------------------------------------------------------------------------
-- 
-- Package    :		slm_generic_pkg
--
-- Description:		Definitions of all generic constants, cmds and functions that
--			are included by the user and the model(s).
--
--------------------------------------------------------------------------------------------



library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use std.textio.all;
use IEEE.std_logic_textio.all;
library slm_lib;
use slm_lib.slm_pkg.all;



package slm_generic_pkg is
    
-- generic cmd constants	    
    CONSTANT SLM_NULL_CMD                : natural := 0;
    CONSTANT SLM_SET_MSG_LEVEL_CMD       : natural := 100;
    CONSTANT SLM_PRINT_MESSAGE_CMD       : natural := 101;
    CONSTANT SLM_SYNCHRONIZE_CMD         : natural := 102;
    CONSTANT SLM_SWITCH_CMD_SRC_CMD      : natural := 103;
    CONSTANT SLM_CHECK_CMD_TAG_VALID_CMD : natural := 104;
    CONSTANT SLM_CLEAR_BFM_CMD           : natural := 105;

    CONSTANT WAIT_T        : boolean := true;
    CONSTANT WAIT_F        : boolean := false;

    CONSTANT SLM_ENABLE    : natural := 0;
    CONSTANT SLM_DISABLE   : natural := 1;

-- message constants	    
    CONSTANT SLM_ERROR     : integer := 16#1#;         -- b"00000000000000000000000000000001"
    CONSTANT SLM_WARNING   : integer := 16#2#;         -- b"00000000000000000000000000000010"
    CONSTANT SLM_TIMING    : integer := 16#4#;         -- b"00000000000000000000000000000100"
    CONSTANT SLM_XHANDLING : integer := 16#8#;         -- b"00000000000000000000000000001000"
    CONSTANT SLM_INFO      : integer := 16#10#;        -- b"00000000000000000000000000010000"
    CONSTANT SLM_ALL_MSGS  : integer := 16#0fffffff#;  -- b"00001111111111111111111111111111"
    CONSTANT SLM_NO_MSGS   : integer := 16#0#;         -- b"00000000000000000000000000000000"

-- timing options(MIN, TYP, MAX) for time_option generic
    CONSTANT MIN        : integer := 0;
    CONSTANT TYP        : integer := 1;
    CONSTANT MAX        : integer := 2;



--------------------------------------------------------------------------------------------
-- 
-- Procedures :		slm_synchronize, slm_switch_cmd_src, slm_print_message, slm_msg_level
--
-- Description:		Definitions of all generic model commands.
--
--------------------------------------------------------------------------------------------

   procedure slm_synchronize
    (
     id              : in    integer;
     sync_total      : in    integer;
     sync_tag        : in    string;
     sync_time_out   : in    integer 
    );
   
   procedure slm_switch_cmd_src
    (
     id		  : in integer;
     file_name       : in string
    );
   
   procedure slm_print_message
    (
     id         : in integer;
     text       : in string
    );

   procedure slm_set_msg_level
    (
     id         : in integer;
     mode       : in integer
    );

   procedure slm_check_cmd_tag_valid
    (
     id           : in    integer;
     command_tag  : in    integer;
     valid_f      : out   boolean 
    );

   procedure slm_clear_bfm         
    (
     id           : in integer; 
     queue_select : in integer
    );

   procedure slm_define_intr_signal
    (
     id       : in integer;
     sig_name : in string;
     status   : out integer
    );


--------------------------------------------------------------------------------------------
-- 
-- Procedure  :		slm_printf
--
-- Description:		The following procedures are utility print routines to print messages 
--                      to stdout for debugging
--
--------------------------------------------------------------------------------------------

  procedure slm_printf 
    ( 
     in_string    : in string
    );

  procedure slm_printf
    (
     str_name     : in string;
     value        : in integer
    );

  procedure slm_printf 
    ( 
     id           : in integer;
     in_string    : in string;
     log_mode     : in std_logic;
     out_line     : inout line
    );

  procedure slm_printf
    (
     id           : in integer;
     str_name     : in string;
     value        : in integer;
     log_mode     : in std_logic;
     out_line     : inout line
    );

  procedure slm_printf
    (
     id           : in integer;
     str_name     : in string;
     value_stdvh  : in std_logic_vector;
     log_mode     : in std_logic;
     out_line     : inout line
    );

   procedure slm_printf
    (
     id           : in integer;
     str_name1    : in string;
     value_int1   : in integer;
     str_name2    : in string;
     value_int2   : in integer;
     log_mode     : in std_logic;
     out_line     : inout line
    );

   procedure slm_printf
    (
     id           : in integer;
     str_name1    : in string;
     value_int    : in integer;
     str_name2    : in string;
     value_stdvh  : in std_logic_vector;
     log_mode     : in std_logic;
     out_line     : inout line
    );

   procedure slm_printf
    (
     id           : in integer;
     str_name1    : in string;
     value_stdvh  : in std_logic_vector;
     str_name2    : in string;
     value_int    : in integer;
     log_mode     : in std_logic;
     out_line     : inout line
    );

   procedure slm_printf
    (
     id           : in integer;
     str_name1    : in string;
     value_stdvh1 : in std_logic_vector;
     str_name2    : in string;
     value_stdvh2 : in std_logic_vector;
     log_mode     : in std_logic;
     out_line     : inout line
    );

   procedure slm_printf
    (
     id           : in integer;
     str_name1    : in string;
     value_int1   : in integer;
     str_name2    : in string;
     log_mode     : in std_logic;
     out_line     : inout line
    );

   procedure slm_printf
    (
     id           : in integer;
     str_name1    : in string;
     value_stdvh  : in std_logic_vector;
     str_name2    : in string;
     log_mode     : in std_logic;
     out_line     : inout line
    );

end slm_generic_pkg;








package body slm_generic_pkg is

--------------------------------------------------------------------------------------------
-- 
-- Procedure  :		slm_synchronize
--
-- Description:		Synchronize multiple instances.
--
--------------------------------------------------------------------------------------------

procedure slm_synchronize
 (
  id            : in    integer;
  sync_total    : in    integer;
  sync_tag      : in    string;
  sync_time_out : in    integer 
 ) is

CONSTANT INTMAXCNT     : natural := 10;
CONSTANT SLMAXCNT      : natural := 128;
CONSTANT CHARMAXCNT    : natural := 256;

variable intArray      : SLM_INT_ARRAY (0 to INTMAXCNT-1);
variable emptySlArray  : std_logic_vector(0 to 0) := "X";
variable charArray   : string (1 to CHARMAXCNT);
--variable emptyCharArray: string (1 to 1);
variable statRet       : integer;

variable intActualCnt  : integer := 0;
variable slActualCnt   : integer := 0;
variable charActualCnt : integer := 0;

variable command_tag   : integer;
variable timeOutCnt    : integer := 0;
variable done          : boolean := false;

begin


    -- Fill up intArray
    intActualCnt:= 3;
    intArray(0) := 108;        -- cc_synchBfm
    intArray(1) := id;   
    intArray(2) := sync_total; -- number of models to sync

    -- Deal with the tag string
    charActualCnt := sync_tag'LENGTH;
    charArray (1 to charActualCnt) := sync_tag;
    
    -- Post the command
    slm_post(SLM_APP_TYPE_ID_ECLIPSE, 
             INTMAXCNT, intActualCnt, intArray, 
             SLMAXCNT, slActualCnt, emptySlArray,
             CHARMAXCNT, charActualCnt, charArray, 
             statRet);
    
    command_tag := intArray(1);   -- save tag for subsequent accesses

    -- loop until the sync command is executed, then proceed to load the next 
    -- command.  Without this loop, the command core will load the sync command,
    -- and then proceed to load anything else up to the point when it reaches 
    -- the next multi-cycle command for the same instance.

    while not done loop
        wait for 30 ns; -- CLK_PERIOD

        -- reinitialize count variables 
        slActualCnt     := 0;
        charActualCnt   := 0;
	
        -- Fill up intArray
        intActualCnt:= 3;  
        intArray(0) := 111;  -- cc_validCmdTag
        intArray(1) := id; -- instance id
        intArray(2) := command_tag;
    
        -- Post the function
        slm_post(SLM_APP_TYPE_ID_ECLIPSE, 
                 INTMAXCNT, intActualCnt, intArray, 
                 SLMAXCNT, slActualCnt, emptySlArray,
    	         CHARMAXCNT, charActualCnt, CharArray, 
                 statRet);
 	
        -- if null command returned, queue is empty signaling that the synchronize 
        -- command has been executed.

        -- if the synchronize command has not been executed, the slm_synchronize
        -- procedure will wait until the command completes if the sync_time_out
        -- is zero, or until the sync_time_out count is reached if the sync_time_out 
        -- is greater than zero.

        if (intArray(1) = 0) then
            done := true;
        elsif ( sync_time_out > 0 ) then
            if ( timeOutCnt >= sync_time_out ) then
                done := true;
            else
        	    timeOutCnt := timeOutCnt + 1;
            end if;
        end if;
    end loop;

end slm_synchronize;






--------------------------------------------------------------------------------------------
-- 
-- Procedure  :     slm_switch_cmd_src
--
-- Description:     Switch command source.
--
--------------------------------------------------------------------------------------------

procedure slm_switch_cmd_src
 (
  id          : in integer;
  file_name   : in string
 ) is

CONSTANT INTMAXCNT     : natural := 10;
CONSTANT SLMAXCNT      : natural := 128;
CONSTANT CHARMAXCNT    : natural := 256;

variable intArray      : SLM_INT_ARRAY (0 to INTMAXCNT-1);
variable emptySlArray  : std_logic_vector(0 to 0) := "X";
variable charArray     : string (1 to CHARMAXCNT);
variable statRet       : integer;

variable intActualCnt  : integer := 0;
variable slActualCnt   : integer := 0;
variable charActualCnt : integer := 0;

begin

    -- Fill up intArray
    intActualCnt:= 3;
    intArray(0) := 105;  -- cc_newBFM (can be cc_switchcmdsrc also model_id =105)
    intArray(1) := id;
    intArray(2) := 1;

    -- Deal with the text string
    charActualCnt := file_name'LENGTH;
    charArray (1 to charActualCnt) := file_name;
    
    -- Post the command
    slm_post(SLM_APP_TYPE_ID_ECLIPSE, 
             INTMAXCNT, intActualCnt, intArray, 
             SLMAXCNT, slActualCnt, emptySlArray,
             CHARMAXCNT, charActualCnt, charArray, 
             statRet);
    

    if (intArray(1) = 0) then
        assert (false) report "INVALID command source" severity WARNING;
    elsif (intArray(2) = 1) then
        assert (false) report "HDL Control" severity NOTE;
    else
        assert (false) report "File based Control" severity NOTE;
    end if;

    if (intArray(0) = 0) then
        assert (false) report "Call returned successfully" severity NOTE;
    else
        assert (false) report "Call returned unsuccessfully" severity WARNING;
    end if;

end slm_switch_cmd_src;






--------------------------------------------------------------------------------------------
-- 
-- Procedure  :     slm_print_message
--
-- Description:     Print a message from the model.
--
--------------------------------------------------------------------------------------------

procedure slm_print_message
 (
  id         : in integer;
  text       : in string
 ) is

CONSTANT INTMAXCNT     : natural := 10;
CONSTANT SLMAXCNT      : natural := 128;
CONSTANT CHARMAXCNT    : natural := 256;

variable intArray      : SLM_INT_ARRAY (0 to INTMAXCNT-1);
variable emptySlArray  : std_logic_vector(0 to 0) := "X";
variable charArray     : string (1 to CHARMAXCNT);
variable statRet       : integer;

variable intActualCnt  : integer := 0;
variable slActualCnt   : integer := 0;
variable charActualCnt : integer := 0;

begin


    -- Fill up intArray
    intActualCnt:= 3;
    intArray(0) := 101;  -- cc_postCmd
    intArray(1) := id;
    intArray(2) := SLM_PRINT_MESSAGE_cmd;

    -- Deal with the text string
    charActualCnt := text'LENGTH;
--    charArray (1 to charActualCnt) := text;
    charArray (1 to 256) := text;
    
    -- Post the command
    slm_post(SLM_APP_TYPE_ID_ECLIPSE, 
             INTMAXCNT, intActualCnt, intArray, 
             SLMAXCNT, slActualCnt, emptySlArray,
	     CHARMAXCNT, charActualCnt, charArray, 
             statRet);
    

end slm_print_message;







--------------------------------------------------------------------------------------------
-- 
-- Procedure  :     slm_set_msg_level
--
-- Description:     Set debug level for model messages.
--
--------------------------------------------------------------------------------------------


procedure slm_set_msg_level
 (
  id         : in integer;
  mode       : in integer
 )is 

CONSTANT INTMAXCNT     : natural := 10;
CONSTANT SLMAXCNT      : natural := 128;
CONSTANT CHARMAXCNT    : natural := 256;

variable intArray      : SLM_INT_ARRAY (0 to INTMAXCNT-1);
variable emptySlArray  : std_logic_vector(0 to 0) := "X";
variable emptycharArray : string (1 to CHARMAXCNT);
variable statRet       : integer;

variable intActualCnt  : integer := 0;
variable slActualCnt   : integer := 0;
variable charActualCnt : integer := 0;

begin


    -- Fill up intArray
    intActualCnt:= 4;
    intArray(0) := 101;  -- cc_postCmd
    intArray(1) := id;
    intArray(2) := SLM_SET_MSG_LEVEL_cmd;
    intArray(3) := mode;

    
    -- Post the command
    slm_post(SLM_APP_TYPE_ID_ECLIPSE, 
             INTMAXCNT, intActualCnt, intArray, 
             SLMAXCNT, slActualCnt, emptySlArray,
	     CHARMAXCNT, charActualCnt, emptycharArray, 
             statRet);
    
end slm_set_msg_level;





--------------------------------------------------------------------------------------------
-- 
-- Procedure  :     slm_check_cmd_tag_valid
--
-- Description:     
--
--------------------------------------------------------------------------------------------
procedure slm_check_cmd_tag_valid
 (
  id           : in integer; 
  command_tag  : in integer;
  valid_f      : out boolean 
 ) is

CONSTANT INTMAXCNT     : natural := 10;
CONSTANT SLMAXCNT      : natural := 128;
CONSTANT CHARMAXCNT    : natural := 256;

variable intArray      : SLM_INT_ARRAY (0 to INTMAXCNT-1);
variable emptySlArray  : std_logic_vector(0 to 0) := "X";
variable emptyCharArray: string (1 to 1);
variable statRet       : integer;

variable intActualCnt  : integer := 0;
variable slActualCnt   : integer := 0;
variable charActualCnt : integer := 0;

begin

    -- initialize count variables 
    slActualCnt     := 0;
    charActualCnt   := 0;
    
    -- Fill up intArray
    intActualCnt:= 3;  
    intArray(0) := 111;  -- cc_validCmdTag
    intArray(1) := id; -- instance id
    intArray(2) := command_tag;
    
    -- Post the function
    slm_post(SLM_APP_TYPE_ID_ECLIPSE, 
             INTMAXCNT, intActualCnt, intArray, 
             SLMAXCNT, slActualCnt, emptySlArray,
             CHARMAXCNT, charActualCnt, emptyCharArray, 
             statRet);
    
    -- if null command returned, queue is empty
    if (intArray(1) = 1) then
        valid_f := true;
    else
        valid_f := false;
    end if;

end slm_check_cmd_tag_valid;


--------------------------------------------------------------------------------------------
-- 
-- Procedure  :     slm_clear_bfm 
--
-- Description:     
--
--------------------------------------------------------------------------------------------
procedure slm_clear_bfm         
 (
  id           : in integer; 
  queue_select : in integer
 ) is

CONSTANT INTMAXCNT     : natural := 10;
CONSTANT SLMAXCNT      : natural := 128;
CONSTANT CHARMAXCNT    : natural := 256;

variable intArray      : SLM_INT_ARRAY (0 to INTMAXCNT-1);
variable emptySlArray  : std_logic_vector(0 to 0) := "X";
variable emptyCharArray: string (1 to 1);
variable statRet       : integer;

variable intActualCnt  : integer := 0;
variable slActualCnt   : integer := 0;
variable charActualCnt : integer := 0;

begin

    -- initialize count variables 
    slActualCnt     := 0;
    charActualCnt   := 0;
    
    -- Fill up intArray
    intActualCnt:= 3;  
    intArray(0) := 104;  -- cc_clearBFM    
    intArray(1) := id; -- instance id
    intArray(2) := queue_select;
    
    -- Post the function
    slm_post(SLM_APP_TYPE_ID_ECLIPSE, 
             INTMAXCNT, intActualCnt, intArray, 
             SLMAXCNT, slActualCnt, emptySlArray,
             CHARMAXCNT, charActualCnt, emptyCharArray, 
             statRet);
    
    -- if null command returned, queue is empty
    if (intArray(1) = 0) then
    else
        --error
    end if;

end slm_clear_bfm;

-----------------------------------------------------------------------------
-- Procedure:		slm_printf
--
-- Description   :	Print string
--
-----------------------------------------------------------------------------
procedure slm_printf
 (
  in_string:	in string
 ) is

    variable buf:	line;

begin
 
    write(buf, NOW);
    write(buf, string'("    "));
    write(buf, in_string);
    writeline(output, buf);

end slm_printf;

-----------------------------------------------------------------------------
-- Procedure:		slm_printf
--
-- Description   :	Print string and integer
--
-----------------------------------------------------------------------------
procedure slm_printf
 (
  str_name    : in string;
  value       : in integer
 ) is

    variable buf:	line;
begin	
    write(buf, NOW);
    write(buf, string'("    "));
    write(buf, str_name);
    write(buf, value);
    writeline(output, buf);
end slm_printf;

-----------------------------------------------------------------------------
-- Procedure:		slm_printf
--
-- Description   :	Print id snd string
--
-----------------------------------------------------------------------------
procedure slm_printf
 (
  id           : in integer;
  in_string    : in string;
  log_mode     : in std_logic;
  out_line     : inout line
 ) is

    variable buf:	line;

begin
 
    write(buf, NOW);
    write(buf, string'("    "));
    write(buf, string'("INSTANCE "));
    write(buf, id);
    write(buf, string'(". "));
    write(buf, in_string);
    writeline(output, buf);
    if (log_mode = '1') then
        write(out_line, NOW);
        write(out_line, string'("    "));
        write(out_line, string'("INSTANCE "));
        write(out_line, id);
        write(out_line, string'(". "));
        write(out_line, in_string);
    end if;

end slm_printf;

-----------------------------------------------------------------------------
-- Procedure:		slm_printf
--
-- Description   :	Print id, string and integer
--
-----------------------------------------------------------------------------
procedure slm_printf
 (
  id           : in integer;
  str_name     : in string;
  value        : in integer;
  log_mode     : in std_logic;
  out_line     : inout line
 ) is

    variable buf:	line;
begin	
    write(buf, NOW);
    write(buf, string'("    "));
    write(buf, string'("INSTANCE "));
    write(buf, id);
    write(buf, string'(". "));
    write(buf, str_name);
    write(buf, value);
    writeline(output, buf);
    if (log_mode = '1') then
        write(out_line, NOW);
        write(out_line, string'("    "));
        write(out_line, string'("INSTANCE "));
        write(out_line, id);
        write(out_line, string'(". "));
        write(out_line, str_name);
        write(out_line, value);
    end if;
end slm_printf;

-----------------------------------------------------------------------------
-- Procedure:		slm_printf
--
-- Description   :	Print id, string and std_logic_vector in hex
--
-----------------------------------------------------------------------------
procedure slm_printf
 (
  id           : in integer;
  str_name     : in string;
  value_stdvh  : in std_logic_vector;
  log_mode     : in std_logic;
  out_line     : inout line
 ) is

variable buf:	line;

begin	
    write(buf, NOW);
    write(buf, string'("    "));
    write(buf, string'("INSTANCE "));
    write(buf, id);
    write(buf, string'(". "));
    write(buf, str_name);
    hwrite(buf, value_stdvh, RIGHT, 0);
    writeline(output, buf);

    if (log_mode = '1') then
	write(out_line, NOW);
	write(out_line, string'("    "));
        write(out_line, string'("INSTANCE "));
        write(out_line, id);
        write(out_line, string'(". "));
	write(out_line, str_name);
        hwrite(out_line, value_stdvh, RIGHT, 0);
    end if;
end slm_printf;

-----------------------------------------------------------------------------
-- Procedure:		slm_printf
--
-- Description   :	Print id, string, integer, string, integer
--
-----------------------------------------------------------------------------
procedure slm_printf
 (
  id           : in integer;
  str_name1    : in string;
  value_int1   : in integer;
  str_name2    : in string;
  value_int2   : in integer;
  log_mode     : in std_logic;
  out_line     : inout line
  ) is

  variable buf:	line;
  variable tmp_vec : std_logic_vector (31 downto 0);
    
begin
     
    write(buf, NOW);
    write(buf, string'("    "));
    write(buf, string'("INSTANCE "));
    write(buf, id);
    write(buf, string'(". "));
    write(buf, str_name1);
    write(buf, value_int1);

    write(buf, str_name2);
    write(buf, value_int2);
    writeline(output, buf);

    if (log_mode = '1') then
	  write(out_line, NOW);
	  write(out_line, string'("    "));
          write(out_line, string'("INSTANCE "));
          write(out_line, id);
          write(out_line, string'(". "));
	  write(out_line, str_name1);
	  write(out_line, value_int1);
    
	  write(out_line, str_name2);
	  write(out_line, value_int2);
    end if;
end slm_printf;

-----------------------------------------------------------------------------
-- Procedure:		slm_printf
--
-- Description	 :	Print id, string, integer, string, std_logic_vector in hex
--
-----------------------------------------------------------------------------
procedure slm_printf
 (
  id           : in integer;
  str_name1    : in string;
  value_int    : in integer;
  str_name2    : in string;
  value_stdvh  : in std_logic_vector;
  log_mode     : in std_logic;
  out_line     : inout line
 ) is
 
  variable buf:	line;
  variable tmp_vec : std_logic_vector (31 downto 0);

begin

    write(buf, NOW);
    write(buf, string'("    "));
    write(buf, string'("INSTANCE "));
    write(buf, id);
    write(buf, string'(". "));
    write(buf, str_name1);
    write(buf, value_int);
    write(buf, str_name2);
    hwrite(buf, value_stdvh, RIGHT, 0);

    writeline(output, buf);

    if (log_mode = '1') then
	  write(out_line, NOW);
	  write(out_line, string'("    "));
          write(out_line, string'("INSTANCE "));
          write(out_line, id);
          write(out_line, string'(". "));
          write(out_line, str_name1);
          write(out_line, value_int);
	  write(out_line, str_name2);
	  hwrite(out_line, value_stdvh, RIGHT, 0);
    end if;

end slm_printf;

-----------------------------------------------------------------------------
-- Procedure:		slm_printf
--
-- Description	 :	Print id, string, std_logic_vector in hex, string, integer
--
-----------------------------------------------------------------------------
procedure slm_printf
 (
  id           : in integer;
  str_name1    : in string;
  value_stdvh  : in std_logic_vector;
  str_name2    : in string;
  value_int    : in integer;
  log_mode     : in std_logic;
  out_line     : inout line
 ) is
 
  variable buf:	line;
  variable tmp_vec : std_logic_vector (31 downto 0);

begin

    write(buf, NOW);
    write(buf, string'("    "));
    write(buf, string'("INSTANCE "));
    write(buf, id);
    write(buf, string'(". "));
    write(buf, str_name1); 
    hwrite(buf, value_stdvh, RIGHT, 0);
    write(buf, str_name2);
    write(buf, value_int);

    writeline(output, buf);

    if (log_mode = '1') then
        write(out_line, NOW);
        write(out_line, string'("    "));
        write(out_line, string'("INSTANCE "));
        write(out_line, id);
        write(out_line, string'(". "));
        write(out_line, str_name1); 
        hwrite(out_line, value_stdvh, RIGHT, 0);
        write(out_line, str_name2);
        write(out_line, value_int);
    end if;

end slm_printf;

-----------------------------------------------------------------------------
-- Procedure:		slm_printf
--
-- Description	 :	Print id, string, std_logic_vector in hex, string, std_logic_vector in hex
--
-----------------------------------------------------------------------------
procedure slm_printf
 (
  id           : in integer;
  str_name1    : in string;
  value_stdvh1 : in std_logic_vector;
  str_name2    : in string;
  value_stdvh2 : in std_logic_vector;
  log_mode     : in std_logic;
  out_line     : inout line
  ) is
 
  variable buf:	line;
  variable tmp_vec : std_logic_vector (31 downto 0);

begin

    write(buf, NOW);
    write(buf, string'("    "));
    write(buf, string'("INSTANCE "));
    write(buf, id);
    write(buf, string'(". "));
    write(buf, str_name1);
    hwrite(buf, value_stdvh1, RIGHT, 0);
    write(buf, str_name2);
    hwrite(buf, value_stdvh2, RIGHT, 0);

    writeline(output, buf);
    if (log_mode = '1') then
        write(out_line, NOW);
        write(out_line, string'("    "));
        write(out_line, string'("INSTANCE "));
        write(out_line, id);
        write(out_line, string'(". "));
        write(out_line, str_name1);
        hwrite(out_line, value_stdvh1, RIGHT, 0);
        write(out_line, str_name2);
        hwrite(out_line, value_stdvh2, RIGHT, 0);
    end if;

end slm_printf;

-----------------------------------------------------------------------------
-- Procedure:		slm_printf
--
-- Description	 :	Print id, string, int, string
--
-----------------------------------------------------------------------------
procedure slm_printf
 (
  id           : in integer;
  str_name1    : in string;
  value_int1   : in integer;
  str_name2    : in string;
  log_mode     : in std_logic;
  out_line     : inout line
 ) is

  variable buf:	line;

begin

    write(buf, NOW);
    write(buf, string'("    "));
    write(buf, string'("INSTANCE "));
    write(buf, id);
    write(buf, string'(". "));
    write(buf, str_name1);
    write(buf, value_int1);
    write(buf, str_name2);
    writeline(output, buf);
    if (log_mode = '1') then
        write(out_line, NOW);
        write(out_line, string'("    "));
        write(out_line, string'("INSTANCE "));
        write(out_line, id);
        write(out_line, string'(". "));
        write(out_line, str_name1);
        write(out_line, value_int1);
        write(out_line, str_name2);
    end if;
end slm_printf;

-----------------------------------------------------------------------------
-- Procedure:   	slm_printf
--
-- Description	 :	Print id, string, std_logic_vector, string
--
-----------------------------------------------------------------------------
procedure slm_printf
 (
  id           : in integer;
  str_name1    : in string;
  value_stdvh  : in std_logic_vector;
  str_name2    : in string;
  log_mode     : in std_logic;
  out_line     : inout line
 ) is

  variable buf:	line;

begin

    write(buf, NOW);
    write(buf, string'("    "));
    write(buf, string'("INSTANCE "));
    write(buf, id);
    write(buf, string'(". "));
    write(buf, str_name1);
    hwrite(buf, value_stdvh, RIGHT, 0);
    write(buf, str_name2);
    
    writeline(output, buf);
    if (log_mode = '1') then
        write(out_line, NOW);
        write(out_line, string'("    "));
        write(out_line, string'("INSTANCE "));
        write(out_line, id);
        write(out_line, string'(". "));
        write(out_line, str_name1);
        hwrite(out_line, value_stdvh, RIGHT, 0);
        write(out_line, str_name2);
    end if;
end slm_printf;

----------------------------------------------------------------------------------
--
-- Procedure   : 	slm_define_intr_signal
--
-- Description :	Define the name of the interrupt signal with the command core
--
----------------------------------------------------------------------------------
procedure slm_define_intr_signal
    (
     id       : in integer;
     sig_name : in string;
     status   : out integer
    ) is 

CONSTANT INTMAXCNT     : natural := 10;
CONSTANT SLMAXCNT      : natural := 128;
CONSTANT CHARMAXCNT    : natural := 256;

variable intArray     : SLM_INT_ARRAY(0 to INTMAXCNT-1);
variable slVector     : std_logic_vector(SLMAXCNT-1 downto 0);
variable charArray    : string (1 to 256);
variable intCnt       : integer;
variable slCnt        : integer;
variable charCnt      : integer;
variable statRet      : integer;

begin
    -- int array
    intArray(0) := 504; --cc_defineIntrSignal
    intArray(1) := id;
    intCnt  := 2;

    -- sl array
    slCnt   := 0;

    -- char array
    charCnt := sig_name'LENGTH; 
    charArray(1 to charCnt) := sig_name;

    slm_post(SLM_APP_TYPE_ID_ECLIPSE, 
              INTMAXCNT, intCnt, intArray, 
              SLMAXCNT, slCnt, slVector, 
              CHARMAXCNT, charCnt, charArray, 
              statRet);

    -- Still need to add logging

end slm_define_intr_signal;

end slm_generic_pkg;
