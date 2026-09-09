-------------------------------------------------------------------------------
-- Copyright 1995 VAutomation Inc. Nashua NH (603) 882-2282 ALL RIGHTS RESERVED.
-- This software is provided under license and contains proprietary and
-- confidential material which is the property of VAutomation Inc.
--
-- File: vpc_term.vhd
-- Description:
-- 	Crude PC terminal model for simulation.  This model provides a mechanism
--  to input characters to the simulation and to see strings writen out over the
--  serial port in the simulation transcript window.
--
-- Signals ending in _n are active low.
--
--  Serial port description
--
--  Signal D-25  D-9  Source   Description
--  Name   pin   pin
--  ====   ====  ===  ======   ================================================
--  SHLD    1                  Chasis Ground
--  Txd     2     3   Comp     Serial transmit data line from computer
--  Rxd     3     2   Term     Serial receive data line to computer
--  RTS     4     7   Comp     Request to Send
--  CTS     5     8   Term     Clear to Send
--  DSR     6     6   Term     Data Set Ready
--  GND     7     5            Signal Ground
--  DCD     8     1   Term     Data Carrier Detect
--  DTR    20     4   Comp     Data Terminal Ready
--  RI     22     9   Term     Ring indicator
--
--  Because we are modeling a PC based terminal emulation program we will be
--  driving the signals that are sourced by compute equipement.
--
-- This terminal implement 8 bit data, 1 stop bit, no parity
-- the Baud rate is set by setting the Bit Time Signal.  Uf autobaud is enabled
-- in the code then the terminal will attempt to increase the baud rate to match
-- the baud rate of the recieved data. Some common values of
-- bit time are :
-- Baud Rate  Bit Time
-- =========  ========
--   6.0M      160 ns  (maximum rate using 48MHz base clock to vuart)
--   1.5M      672 ns  (maximum rate using 12MHz base clock to vuart)
-- 115200     8680 ns
--  38400       26 us
--   9600      104 us
--   1200      833 us
--
--------------Revision History--------------------------------------------------
-- $Log: vpc_term.vhd,v $
-- Revision 1.9  1999/03/31 15:59:44  unknown
-- default print_every_char_upon_receipt set to false
-- only print line_buf if there is something in it upon <CR> or <LF>
--
-- Revision 1.8  1999/03/30 20:05:11  unknown
-- added print_char_upon_receipt switch
-- either <CR> or <LF> will cause assert to print line buffer
--
-- Revision 1.7  1998/10/20 15:15:36  chris
-- Added line wrap prior to overflowing the line buffer.
--
-- Revision 1.6  1998/04/22 21:16:26  eric
-- Made it more forgiving when auto-bauding.
--
-- Revision 1.5  1998/03/12 13:42:50  chris
-- Changed wait time in script file to 1usec units.
-- Added special characters, and added script file echo on line read.
--
-- Revision 1.4  1998/02/18 12:23:53  gregg
-- Added generics for input filename and terminal name
--
-- Revision 1.3  1997/11/20 15:29:15  chris
-- Added a crude autobaud generator process.
--
-- Revision 1.1  1997/10/15 13:17:10  chris
-- Initial revision
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;	-- we use the IEEE standard 1164 logic types.
USE ieee.std_logic_arith.ALL;	-- conversion routines
USE std.textio.ALL;     -- IO routines.
--USE work.v8_pkg.ALL;    -- useful routines.

ENTITY vpc_term IS	------------------------------ENTITY--------------------
  GENERIC (
        input_fname : string := "vpc_term.dat";
        term_label  : string := "default terminal");
  PORT (
        dsub9_M_J2_1  : INOUT std_logic; --dcd data carrier detect RS232 signal
        dsub9_M_J2_2  : INOUT std_logic; --rxd Receive data output RS232 signal from computer
        dsub9_M_J2_3  : INOUT std_logic; --txd Transmit data input RS232 signal to computer
        dsub9_M_J2_4  : INOUT std_logic; --dtr data terminal ready RS232 signal
        dsub9_M_J2_5  : INOUT std_logic; --gnd
        dsub9_M_J2_6  : INOUT std_logic; --dsr data set ready RS232 signal
        dsub9_M_J2_8  : INOUT std_logic; --rts request to send RS232 signal
        dsub9_M_J2_7  : INOUT std_logic; --cts clear to send RS232 signal
        dsub9_M_J2_9  : INOUT std_logic);--ri  ring indicator RS232 signal

END vpc_term;

ARCHITECTURE behav OF vpc_term IS ------------------ARCHITECTURE---------------
  SIGNAL bit_time : time := 104 us; -- 1200 baud to start then autobaud up
  SIGNAL autobaud_in_progress : boolean := false; -- autobaud in progress
  SIGNAL autobaud_enabled : boolean := true; -- set this to false to disable
                                             -- auto baud
  SIGNAL autobaud_blocked : boolean := true;
  SIGNAL rs232_cts, rs232_dsr, rs232_dcd, rs232_ri, rs232_rts, rs232_dtr,
         rs232_rxd, rs232_txd      : std_logic;
  SIGNAL   rts, dtr, txd, rxd, gnd : std_logic;
  CONSTANT print_every_char_upon_receipt : boolean := false;
  
COMPONENT dsub9
  port (pin1 : inout std_logic;
        pin2 : inout std_logic;
        pin3 : inout std_logic;
        pin4 : inout std_logic;
        pin5 : inout std_logic;
        pin6 : inout std_logic;
        pin7 : inout std_logic;
        pin8 : inout std_logic;
        pin9 : inout std_logic;
        contact1 : inout std_logic;
        contact2 : inout std_logic;
        contact3 : inout std_logic;
        contact4 : inout std_logic;
        contact5 : inout std_logic;
        contact6 : inout std_logic;
        contact7 : inout std_logic;
        contact8 : inout std_logic;
        contact9 : inout std_logic);
 
END COMPONENT;


    -----------------------------------------------------------------
    -- STRING reading
    -----------------------------------------------------------------

    procedure Preview_string(L:inout LINE; VALUE: out string; GOOD : out BOOLEAN)
    is
	alias    val  : string(1 to VALUE'length) is VALUE;
	variable vpos : integer := 0;	-- Index of last valid character in val.
	variable lpos : integer;	-- Index of next unused char in L.
    begin
	if L /= NULL then
	    lpos := L'left;
	    while lpos <= L'right and vpos < VALUE'length loop
		vpos := vpos + 1;
		val(vpos) := L(lpos);
		lpos := lpos + 1;
	    end loop;
            vpos := vpos + 1;            
            val(vpos) := NUL;
	end if;

	if vpos = VALUE'length then
	    GOOD := TRUE;
	else
	    GOOD := FALSE;
	end if;
    end;

 function vec2asci      (v: std_logic_vector(7 downto 0))  return character is
   begin
      CASE v is
	WHEN "00001101"              => return (' '); -- CR
	WHEN "01000001" | "01100001" => return ('A');
	WHEN "01000010" | "01100010" => return ('B');
	WHEN "01000011" | "01100011" => return ('C');
	WHEN "01000100" | "01100100" => return ('D');
	WHEN "01000101" | "01100101" => return ('E');
	WHEN "01000110" | "01100110" => return ('F');
	WHEN "01000111" | "01100111" => return ('G');
	WHEN "01001000" | "01101000" => return ('H');
	WHEN "01001001" | "01101001" => return ('I');
	WHEN "01001010" | "01101010" => return ('J');
	WHEN "01001011" | "01101011" => return ('K');
	WHEN "01001100" | "01101100" => return ('L');
	WHEN "01001101" | "01101101" => return ('M');
	WHEN "01001110" | "01101110" => return ('N');
	WHEN "01001111" | "01101111" => return ('O');
	WHEN "01010000" | "01110000" => return ('P');
	WHEN "01010001" | "01110001" => return ('Q');
	WHEN "01010010" | "01110010" => return ('R');
	WHEN "01010011" | "01110011" => return ('S');
	WHEN "01010100" | "01110100" => return ('T');
	WHEN "01010101" | "01110101" => return ('U');
	WHEN "01010110" | "01110110" => return ('V');
	WHEN "01010111" | "01110111" => return ('W');
	WHEN "01011000" | "01111000" => return ('X');
	WHEN "01011001" | "01111001" => return ('Y');
	WHEN "01011010" | "01111010" => return ('Z');
	WHEN "00100000"              => return (' ');
	WHEN "00100001"              => return ('!');
--	WHEN "00100010"              => return ('"');
	WHEN "00100011"              => return ('#');
	WHEN "00100100"              => return ('$');
	WHEN "00100101"              => return ('%');
	WHEN "00100110"              => return ('&');
	WHEN "00100111"              => return (''');
	WHEN "00101000"              => return ('(');
	WHEN "00101001"              => return (')');
	WHEN "00101010"              => return ('*');
	WHEN "00101011"              => return ('+');
	WHEN "00101100"              => return (',');
	WHEN "00101101"              => return ('-');
	WHEN "00101110"              => return ('.');
	WHEN "00101111"              => return ('/');
	WHEN "00110000"              => return ('0');
	WHEN "00110001"              => return ('1');
	WHEN "00110010"              => return ('2');
	WHEN "00110011"              => return ('3');
	WHEN "00110100"              => return ('4');
	WHEN "00110101"              => return ('5');
	WHEN "00110110"              => return ('6');
	WHEN "00110111"              => return ('7');
	WHEN "00111000"              => return ('8');
	WHEN "00111001"              => return ('9');
	WHEN "00111010"              => return (':');
	WHEN "00111011"              => return (';');
	WHEN "00111100"              => return ('<');
	WHEN "00111101"              => return ('=');
	WHEN "00111110"              => return ('>');
	WHEN "00111111"              => return ('?');
	WHEN "01000000"              => return ('@');
	WHEN "01011011"              => return ('[');
	WHEN "01011100"              => return ('\');
	WHEN "01011101"              => return (']');
	WHEN "01011110"              => return ('^');
	WHEN "01011111"              => return ('_');
	WHEN "01100000"              => return ('`');
	WHEN "01111011"              => return ('{');
	WHEN "01111100"              => return ('|');
	WHEN "01111101"              => return ('}');
	WHEN "01111110"              => return ('~');
	WHEN "01111111"              => return ('?');
	WHEN others => return ('?');
      END CASE;
   end;

BEGIN

J2: dsub9 port map ( 	        -------- The RS232 connector is a Male 9 pin D---
	pin1 => rs232_dcd, -- in
        pin2 => rs232_rxd, -- in
        pin3 => rs232_txd, -- out
        pin4 => rs232_dtr, -- out
        pin5 => gnd,       --
        pin6 => rs232_dsr, -- in
        pin7 => rs232_rts, -- out
        pin8 => rs232_cts, -- in
        pin9 => rs232_ri,  -- in
        contact1 => dsub9_M_J2_1, --
        contact2 => dsub9_M_J2_2, --
        contact3 => dsub9_M_J2_3, --
        contact4 => dsub9_M_J2_4, --
        contact5 => dsub9_M_J2_5, --
        contact6 => dsub9_M_J2_6, --
        contact7 => dsub9_M_J2_7, --
        contact8 => dsub9_M_J2_8, --
        contact9 => dsub9_M_J2_9);

  -- inputs that are not modeled.
  -- hardware flow control signals from the terminal/modem equipment are
  -- ignored.
  rs232_cts <= 'Z';-- Clear To Send is an indication from the data terminal device
              -- that it is ready for the compute device to send data.
  rs232_dsr <= 'Z';-- Data Set Ready is an indication from the data terminal device
              -- to the compute device that the terminal is powered on and
              -- ready for communications.
  rs232_dcd <= 'Z';-- Data Carrier Detect is a modem indication that it has
              -- established a link with another modem.
  rs232_ri <= 'Z'; -- Ring Indicator is a modem indication that the phone line
              -- attached to the modem is ringing.
  gnd <= 'Z';

  -- hardware flow control is not modeled.
  rts <= '1'; -- Request to Send is and indicatio from the computer that it is
              -- ready to receive data (Hey, I didn't write the standard)
  dtr <= '1'; -- Data Terminal Ready is and indication from the computer that
              -- it is powered and ready to communicate.

  -- RS232 signals are transmitted active low.
  rs232_rts <= NOT rts;
  rs232_dtr <= NOT dtr;
  rs232_txd <= NOT txd;
  rxd <= NOT rs232_rxd;

-- This process sends any characters from the compute device to the
-- simulation transcript window.
print: PROCESS
VARIABLE data : std_logic_vector(7 DOWNTO 0);
VARIABLE index    : INTEGER := 1; -- Need initial value for first time through
VARIABLE line_buf : string(1 to 1024); -- Maximum line size
BEGIN
  WAIT UNTIL rxd'event AND rxd='0'; -- start bit
  WAIT FOR bit_time/2;	-- 1/2 bit
  FOR i IN 0 TO 7 LOOP
    WAIT FOR bit_time;	-- 1st bit of data
    data(i) := rxd;
  END LOOP;
  WAIT FOR bit_time;	-- 1st bit of data
  ASSERT rxd='1' OR autobaud_in_progress
    REPORT "UART STOP bit expected" SEVERITY NOTE;

  -- linefeed or carriage return tells us to display the line...
  --        LF 0a                CR 13
  IF (data="00001010") OR (data="00001101") THEN
    ASSERT index < 2                    -- only print if something in line_buf
      REPORT term_label & ": " & line_buf
        SEVERITY NOTE;
    index := 1; -- Reset index
  ELSE
      IF (index = 1024) THEN
        ASSERT false
          REPORT term_label & ": " & line_buf
          SEVERITY NOTE;
        index := 1; -- Reset index
      END IF;
      line_buf(index) := vec2asci(data);
      index := index + 1;
      line_buf(index) := NUL; -- Must terminate the line_buf
      --
      -- switch to allow every character be sent to transcript window
      -- upon receipt
      --
      IF (print_every_char_upon_receipt) THEN
        ASSERT false
          REPORT term_label & ": " & line_buf
          SEVERITY NOTE;
        index := 1; -- Reset index
      END IF;
  END IF;
END PROCESS;

script:PROCESS -------------Script reading process---------------------
-- This process will read and parse the input_fname file and send the
-- the characters to the (computer's)read data port.
FILE file_ptr : TEXT IS input_fname;
VARIABLE L : line;
VARIABLE L_buf : string(1 to 1024);
VARIABLE line_count : integer := 0;
VARIABLE char : character;
VARIABLE temp : integer;
VARIABLE ok : boolean;
VARIABLE data : std_logic_vector(7 DOWNTO 0);
BEGIN
  txd <= '1';	-- initial condition.
  WHILE (NOT endfile(file_ptr)) LOOP	-- read each line of the file
    line_count := line_count +1;
    readline(file_ptr, L);
    preview_string(L,L_buf,ok);
    ASSERT false REPORT "reading next line of " & input_fname & " > " & L_buf
      SEVERITY NOTE;
    read(L, char , ok);
    WHILE (ok) LOOP		-- process each character on a line
      CASE char IS
      WHEN '#' =>       -- the rest of the line is a comment
	ok := false;
      WHEN '@' =>       -- This is a script command
        read(L, temp , ok); -- read in the number of micro seconds (usec) to wait.
        WHILE (temp >=0 AND ok) LOOP
          WAIT FOR 1 us;
          temp := temp -1;
        END LOOP;
	ok := false;	-- skip the rest of the line
      WHEN '!' =>       -- send a CRLF
        data := "00001101";   -- CR
        txd <= '0';             -- start bit
        FOR i IN 0 TO 7 LOOP
          WAIT FOR bit_time;
          txd <= data(i);     -- data
        END LOOP;
        WAIT FOR bit_time;
        txd <= '1';             -- stop bit
        WAIT FOR bit_time;
        data := "00001101";   -- LF
        txd <= '0';             -- start bit
        FOR i IN 0 TO 7 LOOP
          WAIT FOR bit_time;
          txd <= data(i);     -- data
        END LOOP;
        WAIT FOR bit_time;
        txd <= '1';             -- stop bit
        WAIT FOR bit_time;
        ok := false;    -- skip the rest of the line
      WHEN OTHERS =>    -- send the character to the processor
        data := CONV_STD_LOGIC_VECTOR(character'pos(char),8);
	txd <= '0';		-- start bit
        FOR i IN 0 TO 7 LOOP
          WAIT FOR bit_time;
          txd <= data(i);	-- data
        END LOOP;
	WAIT FOR bit_time;
	txd <= '1';		-- stop bit
	WAIT FOR bit_time;
        read(L, char, ok);
      END CASE;
    END LOOP;
  END LOOP;
  ASSERT false REPORT "End of " & input_fname & " reached" SEVERITY NOTE;
  WAIT; -- script file is done.
END PROCESS;

--------------------------------------------------------------------------------
-- The auto baud process attempts to sense the baud rate of the incoming data
-- and set the bit time to the appropriate length.  The baud rate is determined
-- by looking at the minimum low going pulse width, and assuming that over a few
-- samples this will be equal to a single bit time.
--
-- At present the baud rate is only adjusted up, so it does not support dynamic
-- changes to the baud rate within the simulation.  If this was desired, you
-- might start by resetting the baud rate down to 1200 baud (or the lowest rate
-- you anticipate in your system) when you get a stop bit expected error.
--------------------------------------------------------------------------------
autobaud_blocked<= false after 10 us;  -- this is intended to disable autobaud
                         -- during the unpredicable system initialization time.
autobaud : process (rxd)
variable t_start, t_end, t_width : time := 0 ns;
  begin
  if autobaud_enabled and not autobaud_blocked then
    if rxd'event and rxd'last_value='1' and rxd='0' and autobaud_enabled then
      t_start := now;
    end if;
    if rxd'event and rxd'last_value='0' and rxd='1' and autobaud_enabled then
      t_width := now - t_start;
    end if;
    if (t_width < bit_time) and (t_width > 50 ns) then  -- the 50 ns is
                         -- there for glitch rejection.  If you expect to
                         -- operate at a rate or greater than 20Mbaud you will
                         -- need to adjust this.
      bit_time <= t_width;
      autobaud_in_progress <= true,false after bit_time * 9; -- ignore characters until baud locked.
      assert false report "VPC_TERM adjusting baud rate" severity note;
    end if;
  end if; -- enabled
end process autobaud;

END behav;




