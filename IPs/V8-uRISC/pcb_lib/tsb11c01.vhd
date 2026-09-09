--------------------------------------------------------------------------------
-- Copyright 1996 VAutomation Inc. Nashua NH USA ALL RIGHTS RESERVED.
-- This software is provided under license and contains proprietary and
-- confidential material which is the property of VAutomation Inc.
--
-- File: tsb11c01.vhd
--
-- Description:
--	VHDL entity for the TI TSB11C01 IEEE-1394 Physical Layer
--      transceiver. Only used for PCB generation and v1394 core verification.
--
--

--------------------------------------------------------------------------------
-- Revision History
-- $Log: tsb11c01.vhd,v $
-- Revision 1.3  1998/01/07 14:11:32  chris
-- Made changes to ease translation to verilog.
--
-- Revision 1.2  1997/09/29 13:50:17  chris
-- Added logic to emulate a PHY chip connected to a FireWire environment
-- within this component.
--
-- Revision 1.1  1996/11/11  19:56:47  eric
-- Initial revision
--
--------------------------------------------------------------------------------
library ieee, std;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
--use work.v8_pkg.ALL;
entity tsb11c01 is
  port (cps        : in  std_logic;    -- cable power status
	xi         : in  std_logic;    -- crystal input
	xo         : out std_logic;    -- crystal output
	pdout      : out std_logic;    -- Phase detector output to external filter
	vcoin      : in  std_logic;    -- VCO input from external filter
	reset_n    : in  std_logic;    -- Reset (active low)
	iso_n      : in  std_logic;    -- PHY-Link isolation enable (active low)
	lps        : in  std_logic;    -- link power status
	lreq       : in  std_logic;    -- link request input
	sysclk     : out std_logic;    -- serial clock to link
	ctl0       : inout std_logic;  -- link interface control 0
	ctl1       : inout std_logic;  -- link interface control 1
	d0         : inout std_logic;  -- link interface data 0
	d1         : inout std_logic;  -- link interface data 1
	c_lokon    : inout std_logic;  -- configuration maager contender input or link on output
	enclk100   : in  std_logic;    -- enable external oscilator
	clk100     : in  std_logic;    -- external oscilator input
	pc0        : in  std_logic;    -- power class programming input 0
	pc1        : in  std_logic;    -- power class programming input 1
	tpbias     : out std_logic;    -- bias voltage output
	pc2        : in  std_logic;    -- power class programming input 2
	r1         : in  std_logic;    -- external bias resistor pin
	r0         : out std_logic;    -- external bias resistor pin
                                       -- 1394 port 3 connections
	tpb3_n     : inout std_logic;  -- Port 3 B-
	tpb3       : inout std_logic;  -- Port 3 B+
	tpa3_n     : inout std_logic;  -- Port 3 A-
	tpa3	   : inout std_logic;  -- Port 3 A+
                                       -- 1394 port 2 connections
	tpb2_n     : inout std_logic;  -- Port 2 B-
	tpb2       : inout std_logic;  -- Port 2 B+
	tpa2_n     : inout std_logic;  -- Port 2 A-
	tpa2	   : inout std_logic;  -- Port 2 A+
                                       -- 1394 port 1 connections
	tpb1_n     : inout std_logic;  -- Port 1 B-
	tpb1       : inout std_logic;  -- Port 1 B+
	tpa1_n     : inout std_logic;  -- Port 1 A-
	tpa1	   : inout std_logic;  -- Port 1 A+
	vcca2      : in  std_logic;    -- power, usually power is from the
	vcca3      : in  std_logic;    -- power cable so we provide the pins
	vcca6      : in  std_logic;    -- power here for easy connection.
	vcca7      : in  std_logic;    -- power
	vccd23     : in  std_logic;    -- power
	vccd33     : in  std_logic;    -- power
	testm1     : in  std_logic;    -- connect to Vcc
	testm2     : in  std_logic     -- connect to Vcc
      );

TYPE string_array IS ARRAY (NATURAL RANGE <>, NATURAL RANGE <>) OF CHARACTER;
attribute pin_number : string;
attribute array_pin_number : string_array;

attribute package_type : string;
attribute package_type of tsb11c01 : ENTITY is "tsb11c01@SSOP56";

-- TI TSB11c01SSOP56 power and ground pin assignments
attribute GND_pins : string_array;

	--Analog and digital grounds combined
attribute GND_pins of tsb11c01 : entity is ("13","14","15","16","17","18","20",
					    "30","40","41","42","43","44");

-- I/O pin assignments
attribute pin_number of cps        : signal is  "1 ";
attribute pin_number of vcca2      : signal is  "2 ";
attribute pin_number of vcca3      : signal is  "3 ";
attribute pin_number of xi         : signal is  "4 ";
attribute pin_number of xo         : signal is  "5 ";
attribute pin_number of vcca6      : signal is  "6 ";
attribute pin_number of vcca7      : signal is  "7 ";
attribute pin_number of pdout      : signal is  "8 ";
attribute pin_number of vcoin      : signal is  "9 ";
attribute pin_number of testm2     : signal is  "10";
attribute pin_number of reset_n    : signal is  "11";
attribute pin_number of iso_n      : signal is  "12";
-- AGND						 13
-- AGND						 14
-- AGND						 15
-- AGND						 16
-- AGND						 17
-- DGND						 18
attribute pin_number of lps        : signal is  "19";
-- DGND						 20
attribute pin_number of lreq       : signal is  "21";
attribute pin_number of testm1     : signal is  "22";
attribute pin_number of vccd23     : signal is  "23";
attribute pin_number of sysclk     : signal is  "24";
attribute pin_number of ctl0       : signal is  "25";
attribute pin_number of ctl1       : signal is  "26";
attribute pin_number of d0         : signal is  "27";
attribute pin_number of d1         : signal is  "28";
attribute pin_number of c_lokon    : signal is  "29";
-- DGND 					 30
attribute pin_number of enclk100   : signal is  "31";
attribute pin_number of clk100     : signal is  "32";
attribute pin_number of vccd33     : signal is  "33";
attribute pin_number of pc0        : signal is  "34";
attribute pin_number of pc1        : signal is  "35";
attribute pin_number of tpbias     : signal is  "36";
attribute pin_number of pc2        : signal is  "37";
attribute pin_number of r1         : signal is  "38";
attribute pin_number of r0         : signal is  "39";
-- A GND					 40
-- A GND					 41
-- A GND					 42
-- A GND					 43
-- A GND					 44
attribute pin_number of tpb3_n     : signal is  "45";
attribute pin_number of tpb3       : signal is  "46";
attribute pin_number of tpa3_n     : signal is  "47";
attribute pin_number of tpa3       : signal is  "48";
attribute pin_number of tpb2_n     : signal is  "49";
attribute pin_number of tpb2       : signal is  "50";
attribute pin_number of tpa2_n     : signal is  "51";
attribute pin_number of tpa2       : signal is  "52";
attribute pin_number of tpb1_n     : signal is  "53";
attribute pin_number of tpb1       : signal is  "54";
attribute pin_number of tpa1_n     : signal is  "55";
attribute pin_number of tpa1       : signal is  "56";
end tsb11c01;

architecture behavioral of tsb11c01 is

SIGNAL terse : boolean := false;         -- when true turn off informational
                                         -- messages. 
  
TYPE BIG_END_BYTE_ARRAY IS ARRAY (INTEGER RANGE <>) OF STD_LOGIC_VECTOR(0 to 7);
TYPE PACKET IS ARRAY (0 to 512) OF STD_LOGIC_VECTOR(0 to 7);

type ctlst_type is (idle,tx_gnt0,tx_gnt1,tx_actv0, tx_actv, tx_hold, tx_ackw, tx_acks,rx_fill, rx_spd, rx_actv,rx_ackw,st_actv);
signal sclk_sig : std_logic;
signal phy_int     : std_logic_vector(0 TO 3) := "0000";
signal ctlst :ctlst_type;
signal d0i_rg,d1i_rg : std_logic;
signal lrst : integer := 0;
signal d0_sig, d1_sig, ctl0_sig, ctl1_sig : std_logic;
signal arb_reset_gap, rx_pkt_req, rx_cycst_req : boolean := false;
signal subaction_gap, subaction_gap_rg : boolean := false;

signal bitn_sig : integer;
signal pkt_count_sig : integer;
signal pkt_index_sig , tx_count_sig : integer;
signal echo_req_sig : boolean;
signal rx_req_sig, rx_end_sig : boolean;
signal current_byte : std_logic_vector(0 to 7);
signal status_count_sig : integer;
-- signal packet_data_sig : packet;
signal lreq_command_sig : std_logic_vector(0 TO 15);
signal new_req_sig    : boolean;
signal tx_req_sig     : boolean;
signal tx_ack_req_sig : boolean;
signal st_req_sig     : boolean;



function parallel_crc (crc_in : std_logic_vector(31 downto 0);
                       din :    std_logic_vector(7 downto 0)
	              ) return std_logic_vector IS

  variable crc_next, crc_out : std_logic_vector(31 downto 0);
  variable bit       : integer;

begin

  crc_next := crc_in;

  bit_nums : for bit_num in 7 downto 0 loop -- loop for the width of the parallel CRC

	-- compute the crc_next one bit_num at a time
    crc_out :=
	 crc_next(30) &	-- bit_num 31
	 crc_next(29) &	-- bit_num 30
	 crc_next(28) &	-- bit_num 29
	 crc_next(27) &	-- bit_num 28
	 crc_next(26) &	-- bit_num 27
	(crc_next(25) XOR crc_next(31) XOR din(bit_num)) &	-- bit_num 26
	 crc_next(24) &	-- bit_num 25
	 crc_next(23) &	-- bit_num 24
	(crc_next(22) XOR crc_next(31) XOR din(bit_num)) &	-- bit_num 23
	(crc_next(21) XOR crc_next(31) XOR din(bit_num)) &	-- bit_num 22
	 crc_next(20) &	-- bit_num 21
	 crc_next(19) &	-- bit_num 20
	 crc_next(18) &	-- bit_num 19
	 crc_next(17) &	-- bit_num 18
	 crc_next(16) &	-- bit_num 17
	(crc_next(15) XOR crc_next(31) XOR din(bit_num)) &	-- bit_num 16
	 crc_next(14) &	-- bit_num 15
	 crc_next(13) &	-- bit_num 14
	 crc_next(12) &	-- bit_num 13
	(crc_next(11) XOR crc_next(31) XOR din(bit_num)) &	-- bit_num 12
	(crc_next(10) XOR crc_next(31) XOR din(bit_num)) &	-- bit_num 11
	(crc_next(9) XOR crc_next(31) XOR din(bit_num)) &	-- bit_num 10
	 crc_next(8) &	-- bit_num 9
	(crc_next(7) XOR crc_next(31) XOR din(bit_num)) &	-- bit_num 8
	(crc_next(6) XOR crc_next(31) XOR din(bit_num)) &	-- bit_num 7
	 crc_next(5) &	-- bit_num 6
	(crc_next(4) XOR crc_next(31) XOR din(bit_num)) &	-- bit_num 5
	(crc_next(3) XOR crc_next(31) XOR din(bit_num)) &	-- bit_num 4
	 crc_next(2) &	-- bit_num 3
	(crc_next(1) XOR crc_next(31) XOR din(bit_num)) &	-- bit_num 2
	(crc_next(0) XOR crc_next(31) XOR din(bit_num)) &	-- bit_num 1
	(              crc_next(31) XOR din(bit_num));	-- bit_num 0

    crc_next := crc_out;

  end loop bit_nums;
  return(crc_out);

end parallel_crc;

--function crc32 (data : packet;
--                length : integer
--	              ) return std_logic_vector IS
--  variable crc_out  : std_logic_vector(31 downto 0);
--  variable i , width       : integer;

--begin
--  -- initialize crc
--  crc_out := "11111111" & "11111111" & "11111111" & "11111111";
--  width := 8;
--  -- for each byte update the crc value
--  bytes : for i in 0 TO length - 5 loop -- loop for each byte of data in the packet
--    crc_out := parallel_crc(crc_out,data(i),width); -- compute the new CRC on each byte
--  end loop bytes;
--  crc_out := not crc_out;
--  return(crc_out);

--end crc32;



BEGIN

sysclk <= sclk_sig;

d0     <= TRANSPORT d0_sig after 5 ns;
d1     <= TRANSPORT d1_sig after 5 ns;
ctl0   <= TRANSPORT ctl0_sig after 5 ns;
ctl1   <= TRANSPORT ctl1_sig after 5 ns;


clk_src: PROCESS

  BEGIN -- clk_src
    WAIT FOR 10 ns;                 -- sclk_sig period over 2 (50Mhz)

    IF NOT (sclk_sig = '1') THEN
      sclk_sig <= '1';
    ELSE
      sclk_sig <= '0';
    END IF;
  end process;                           -- clk_src


sclk_proc : process
variable registers : big_end_byte_array( 0 to 15); -- 16 8-bit registers
variable cmd_register : std_logic_vector(0 to 7);
variable addr : std_logic_vector(0 to 3);  -- register address
variable new_req, tx_req, rx_req, st_req, hold_req, tx_ack_req:boolean := false;
variable tx_ack_active, restart_req, tx_end, rx_end, st_end       : boolean := false;
variable rx_ack_req, rx_ack_active, cmd_req :boolean := false;
variable echo_cmd, echo_req, cont_rx_cmd ,subaction_int_cmd :boolean := false;
variable lreq_command :std_logic_vector(0 TO 15);
variable status_data : std_logic_vector(0 TO 15);
variable status_count: integer := 0;
variable packet_data : packet;
variable packet_byte : std_logic_vector(0 to 7);
variable crc_out     : std_logic_vector(31 downto 0);
variable byte, width : integer;
                                
variable quad        : std_logic_vector(0 TO 31);
variable pkt_index,  pkt_count, tx_count, ack_wait_count: integer := 0;
variable bitn : integer := 0;
variable i : integer;
variable rx_pkt_sel : std_logic_vector(0 to 3);
variable cycle_master : boolean := false;
variable cyc_start_interval : time := 125 us ;
variable bcast_packet : boolean := false; -- the rx packet is a broadcast and
                                          -- no ack is expected.
variable iso_packet : boolean := false; -- the rx packet is a broadcast and
                                        -- no ack is expected.
variable cyc_strt_packet : boolean := false; -- the rx packet is a broadcast and
                                             -- no ack is expected.

begin

  wait until sclk_sig'event and sclk_sig = '1';

  --  register the input data
  d0i_rg <= d0;
  d1i_rg <= d1;

                                         -- link request state machine
  if reset_n = '0' then
    lrst <= 0;
    new_req := false;
  else
    if lrst = 0 then                     -- wait for the start bit
      if lreq = '1' then lrst <= 1; end if;
      new_req := false;
    elsif lrst = 15 then
      lrst <= 0;
      new_req := true;
    else
      lrst <= lrst + 1;
      new_req := false;
    end if;
  end if;

                                         -- lreq input shift register
  lreq_command := lreq_command(1 to 15) & lreq;

                                         --  lreq input decode
  if new_req then
    if lreq_command(1 TO 3) = "000" then -- imediate transmit request (used for acks)
      rx_ack_req := true;
    elsif lreq_command(1) = '0' then     -- some other type of transmit packet request
      tx_req := true;
    end if;
    if lreq_command(1 to 3) = "100" then -- register read request
      st_req := true;
      addr := lreq_command(4 to 7);
      status_data := phy_int & addr & registers(conv_integer(unsigned(addr)));
    end if;
    if lreq_command(1 to 3) = "101" then --  register write request
      addr := lreq_command(4 to 7);
      registers(conv_integer(unsigned(addr))) :=lreq_command(8 to 15);
      IF addr = "1000" then
        cmd_req := true;
      end if;
    end if;
  end if;

  ----------------------------------------------------------------------------------
  -- Register 8 is the model control command register.
  -- when written it accepts the following commands.
  --    xxxx0000 - cancel all operations
  --    nnnn0001 - send rx packet number nnnn once
  --    nnnn0010 - send rx packet number nnnn repeatedly
  --    xxxx0011 - loop back any transmitted packets.
  --    xxxx0100 - turn on subaction gap interrupts
  --    xxxx0101 - turn on cycle master cycle starts
  --    all others codes have no effect.
  ----------------------------------------------------------------------------------

  IF cmd_req then
    cmd_req := false;
    cmd_register := registers(8);
    case cmd_register(4 TO 7) is
      when "0000" =>                     -- turn off all the requests
        echo_cmd := false;
        cont_rx_cmd := false;
        subaction_int_cmd := false;
        cycle_master := false;
      when "0001" =>
        rx_pkt_req <= true;
        rx_pkt_sel := cmd_register(0 TO 3);
      when "0010" =>
        cont_rx_cmd := true;
        rx_pkt_sel := cmd_register(0 TO 3);
      when "0011" =>
        echo_cmd := true;
      when "0100" =>
        subaction_int_cmd := true;        
      when "0101" =>
        cycle_master := true;
        cyc_start_interval := 125 us/(1 + (conv_integer(unsigned(cmd_register(0 TO 3)))));
        rx_cycst_req <= true after cyc_start_interval;
      when others =>
        echo_cmd := echo_cmd;            -- do nothing
    end case;
  end if;

  if  cont_rx_cmd then
    IF ctlst = idle then
      rx_pkt_req <= true after 3 us;    -- request another rx packet
    else
      rx_pkt_req <= false;               -- cancel any pending request
    end if;
  end if;

  if (ctlst = tx_actv or ctlst = tx_hold) then
    if ctl0 = '0' AND ctl1 = '1' then
      hold_req := true;
    ELSE
      hold_req := false;
    end if;

    if ctl0 = '1' AND ctl1 = '0' then
      restart_req := true;
    ELSE
      restart_req := false;
    end if;

    if ctl0 = '0' AND ctl1 = '0' then
      tx_end := true;
    end IF;
  else
    hold_req := false;
    tx_end := false;
    restart_req := false;
  end if;

  if ctlst = tx_ackw then
    if ack_wait_count = 0 then
      tx_ack_req := true;
    else
      ack_wait_count := ack_wait_count - 1;
    end if;
  else
    ack_wait_count := 7;
  end if;

  if ctlst = rx_actv and bitn = 6 and
    pkt_count = 1 then
    rx_end := true;
  end if;

  IF ctlst = idle AND rx_cycst_req then
    pkt_count := 20;              -- length of packet in bytes
    -- build a quadlet write packet
    packet_data (0)  := "11111111";  -- Quad 1 destid and tcode
    packet_data (1)  := "11111111";
    packet_data (2)  := "01000000";
    packet_data (3)  := "10000000";  --  tcode 8 - cycle start
    packet_data (4)  := "00000001";  -- Quad 2 source Id and offset high
    packet_data (5)  := "00100011";
    packet_data (6)  := "01000101";
    packet_data (7)  := "01100111";
    packet_data (8)  := "10001001";  -- Quad 3 offset low
    packet_data (9)  := "10101011";
    packet_data (10) := "11001101";
    packet_data (11) := "11101111";
    packet_data (12) := "11110001";  -- Quad 4 Cycle Count f1
    packet_data (13) := "10101011";  --                    ab
    packet_data (14) := "10111010";  --                    ba
    packet_data (15) := "00010001";  --                    11

    -- initialize crc
    crc_out := "11111111" & "11111111" & "11111111" & "11111111";
    width := 8;
    -- for each byte update the crc value
    for byte in 0 TO pkt_count - 5 loop -- loop for each byte of data in the packet
      crc_out := parallel_crc(crc_out,packet_data(byte)); -- compute the new CRC on each byte
    end loop ;
    quad := not crc_out;

    packet_data (16) := quad (0  TO  7);
    packet_data (17) := quad (8  TO 15);
    packet_data (18) := quad (16 TO 23);
    packet_data (19) := quad (24 TO 31);
    
    bcast_packet    := false;
    cyc_strt_packet := true;
    iso_packet     := false;
    pkt_index := 0;
    bitn := 0;
    rx_cycst_req <= false;
    wait for 1 ns;                           -- to allow signal to propogate
    IF cycle_master then
      rx_cycst_req <= true after cyc_start_interval;
    end IF;
    
    rx_req := true;
    
  elsif ctlst = idle AND rx_pkt_req then

    bcast_packet    := false;
    cyc_strt_packet := false;
    iso_packet     := false;

    case rx_pkt_sel is
      when "0000" =>
        -- send a simple write packet
        pkt_count := 8;              -- length of packet in bytes
        -- build a phy self id packet
        packet_data (0)  := "10000001";  -- ID
        packet_data (1)  := "01111111";  -- Gap count
        packet_data (2)  := "00000000";  -- Assorted bits
        packet_data (3)  := "00000000";  -- 
        packet_data (4)  := "01111110";  -- Complement of first 4 bytes
        packet_data (5)  := "10000000";
        packet_data (6)  := "11111111";
        packet_data (7)  := "11111111";

        bcast_packet := true;            -- we don't expect an ack on this packet.

      when "0001" =>
        -- send a simple write packet
        pkt_count := 20;              -- length of packet in bytes
        -- build a quadlet write packet
        packet_data (0)  := "00000000";  -- Quad 1 destid and tcode
        packet_data (1)  := "00000000";
        packet_data (2)  := "00000000";
        packet_data (3)  := "00000000";  --  tcode 0 - write quad
        packet_data (4)  := "00000001";  -- Quad 2 source Id and offset high
        packet_data (5)  := "00100011";
        packet_data (6)  := "01000101";
        packet_data (7)  := "01100111";
        packet_data (8)  := "10001001";  -- Quad 3 offset low
        packet_data (9)  := "10101011";
        packet_data (10) := "11001101";
        packet_data (11) := "11101111";
        packet_data (12) := "11011110";  -- Quad 4 write data de
        packet_data (13) := "10101101";  --                   ad
        packet_data (14) := "10111110";  --                   be
        packet_data (15) := "11101111";  --                   ef

        -- initialize crc
        crc_out := "11111111" & "11111111" & "11111111" & "11111111";
        width := 8;
        -- for each byte update the crc value
        for byte in 0 TO pkt_count - 5 loop  -- loop for each byte of data in the packet
          crc_out := parallel_crc(crc_out,packet_data(byte)); -- compute the new CRC on each byte
        end loop ;
        quad := not crc_out;

        packet_data (16) := quad (0  TO  7);
        packet_data (17) := quad (8  TO 15);
        packet_data (18) := quad (16 TO 23);
        packet_data (19) := quad (24 TO 31);

        bcast_packet := false;

      when others =>
        -- send a simple write packet
        pkt_count := 16;              -- length of packet in bytes
        -- build a quadlet write packet
        pkt_count := 20;              -- length of packet in bytes
        -- build a quadlet write packet
        packet_data (0)  := "00000000";  -- Quad 1 destid and tcode
        packet_data (1)  := "00000000";
        packet_data (2)  := "00000000";
        packet_data (3)  := "00000000";  --  tcode 0 - write quad
        packet_data (4)  := "00000001";  -- Quad 2 source Id and offset high
        packet_data (5)  := "00100011";
        packet_data (6)  := "01000101";
        packet_data (7)  := "01100111";
        packet_data (8)  := "10001001";  -- Quad 3 offset low
        packet_data (9)  := "10101011";
        packet_data (10) := "11001101";
        packet_data (11) := "11101111";
        packet_data (12) := "11011110";  -- Quad 4 write data de
        packet_data (13) := "10101101";  --                   ad
        packet_data (14) := "10111110";  --                   be
        packet_data (15) := "11101111";  --                   ef
                                
        -- initialize crc
        crc_out := "11111111" & "11111111" & "11111111" & "11111111";
        width := 8;
        -- for each byte update the crc value
        for byte in 0 TO pkt_count - 5 loop  -- loop for each byte of data in the packet
          crc_out := parallel_crc(crc_out,packet_data(byte)); -- compute the new CRC on each byte
        end loop;
        quad := not crc_out;

        packet_data (16) := quad (0  TO  7);
        packet_data (17) := quad (8  TO 15);
        packet_data (18) := quad (16 TO 23);
        packet_data (19) := quad (24 TO 31);
        
        bcast_packet := false;


    end case;

    pkt_index := 0;
    bitn := 0;
    rx_pkt_req <= false;
    rx_req := true;
  end if;

  subaction_gap_rg <= subaction_gap;

  if reset_n = '0' then                  -- control output state machine
    ctlst <= idle;
  else
    case ctlst is
      when idle    =>
        subaction_gap <= true after 3 us;
--        if rx_cycst_req and subaction_gap then
--          ctlst <= rx_fill;
--          rx_cycst_req <=  false;
--          subaction_gap <= false;
--        elsif rx_req and subaction_gap then
        if rx_req and subaction_gap then
          ctlst <= rx_fill;
          rx_req := false;
          subaction_gap <= false;
        elsif tx_req and subaction_gap then
          ctlst <= tx_gnt0;
          tx_req := false;
          subaction_gap <= false;
        elsif st_req then
          ctlst <= st_actv;
          st_req := false;
          status_count := 8;
        elsif subaction_gap AND NOT subaction_gap_rg then
          if subaction_int_cmd then
            ctlst <= st_actv;
            status_data := "0100" & "0000" & registers(0);
            status_count := 2;           -- just send 2 cycles more (4-bits)
          end if;
        end if;
      when tx_gnt0  =>
        ctlst <= tx_gnt1;
      when tx_gnt1  =>
        ctlst <= tx_actv0;
      when tx_actv0  =>
        ctlst <= tx_actv;
      when tx_actv  =>
        if    tx_end   then
          if rx_ack_active then
            rx_ack_active := false;
            ctlst <= idle;
          elsif ((packet_data(2) AND "00111111") = "00111111") then
            assert terse report "Tx Broadcast packet forwarded by TSB11c01"
              severity NOTE;
            ctlst <= idle;
            arb_reset_gap <= false;
          elsif ((packet_data(4) AND "11110000") = "10000000") then -- cycle start echo
            assert terse report "Tx Cycle Start packet forwarded by TSB11c01"
              severity NOTE;
            ctlst <= idle;
            arb_reset_gap <= false;
          elsif ((packet_data(4) AND "11110000") = "10100000") then -- iso packet echo
            assert terse report "Tx Isochronous packet forwarded by TSB11c01"
              severity NOTE;
            ctlst <= idle;
            arb_reset_gap <= false;
          else
            ctlst <= tx_ackw;
            assert terse report "Tx Asynchronous packet forwarded by TSB11c01"
              severity NOTE;
          end IF;
        elsif hold_req then ctlst <= tx_hold;
        end if;
      when tx_hold  =>
        if restart_req then ctlst <= tx_actv; end if;
        if    tx_end   then ctlst <= idle; end if;
      when tx_ackw  =>		-- tx acknoledge wait
        if tx_ack_req  then
          ctlst <= rx_fill;
       end if;
      when rx_fill  =>
        ctlst <= rx_spd;
      when rx_spd   =>
        ctlst <= rx_actv;
      when rx_actv  =>
        if rx_end then
          if tx_ack_active then          --  if this was an ack for a tx packet
            ctlst <= idle;               -- go to idle
            tx_ack_active := false;
          else                           -- otherwise wait for an rx ack from the v1394
            ctlst <= rx_ackw;
            arb_reset_gap <= true after 170 ns;
          end if;
          rx_end := false;
        end if;
      when rx_ackw  =>		-- rx acknoledge wait
        if rx_ack_req  then
          rx_ack_req := false;
          ctlst <= tx_gnt0;
          rx_ack_active := true;
          arb_reset_gap <= false;
        elsif (bcast_packet) then
          assert terse report "Rx Broadcast packet forwarded by TSB11c01"
            severity NOTE;
          ctlst <= idle;
          arb_reset_gap <= false;
        elsif (iso_packet) then
          assert terse report "Rx Isochronous packet forwarded by TSB11c01"
            severity NOTE;
          ctlst <= idle;
          arb_reset_gap <= false;
        elsif (cyc_strt_packet) then
          assert terse report "Rx Cycle Start packet forwarded by TSB11c01"
            severity NOTE;
          ctlst <= idle;
          arb_reset_gap <= false;
        elsif arb_reset_gap then
          assert now < 1 ns report "Receive Ack timeout detected by TSB11c01"
            severity FAILURE;
          ctlst <= idle;
          arb_reset_gap <= false;
        end if;

      when st_actv  =>
        if st_end then ctlst <= idle; end if;
      when others   => ctlst <= idle;
    end CASE;
  end if;


                                         -- control outputs
  ctl0_sig <= 'Z'; ctl1_sig <= 'Z';
  case ctlst is
    when idle         => ctl0_sig <= '0'; ctl1_sig <= '0';
    when tx_gnt0      => ctl0_sig <= '1'; ctl1_sig <= '1';
    when tx_gnt1      => ctl0_sig <= '0'; ctl1_sig <= '0';
    when tx_actv0     => ctl0_sig <= 'Z'; ctl1_sig <= 'Z';
    when tx_actv      => ctl0_sig <= 'Z'; ctl1_sig <= 'Z';
    when tx_hold      => ctl0_sig <= 'Z'; ctl1_sig <= 'Z';
    when tx_ackw      => ctl0_sig <= '0'; ctl1_sig <= '0';
    when tx_acks      => ctl0_sig <= '1'; ctl1_sig <= '0';
    when rx_fill      => ctl0_sig <= '1'; ctl1_sig <= '0';
    when rx_spd       => ctl0_sig <= '1'; ctl1_sig <= '0';
    when rx_actv      => ctl0_sig <= '1'; ctl1_sig <= '0';
    when rx_ackw      => ctl0_sig <= '0'; ctl1_sig <= '0';
    when st_actv      => ctl0_sig <= '0'; ctl1_sig <= '1';
  end case;

  if tx_ack_req then
    packet_data(0) := "00011110"; --0x1e	 -- send a ack_complete code.
    pkt_count := 1;
    pkt_index := 0;
    bitn := 0;
    tx_ack_req := false;
    tx_ack_active := true;
  end if;

                                         -- data output
  d0_sig <= 'Z';
  d1_sig <= 'Z';
                                         -- status data output
  if ctlst = st_actv then
    status_count := status_count - 1;
    IF status_count = 1 then
      st_end := true;
    else
      st_end := false;
    end if;
    d0_sig <= status_data(0);
    d1_sig <= status_data(1);
    status_data := status_data(2 to 15) & "00";
  end if;

                                         -- data packet output
  if ctlst = rx_fill then      d0_sig <= '1'; d1_sig <= '1'; end IF;
  if ctlst = rx_spd  then      d0_sig <= '0'; d1_sig <= '0'; end IF;
  if ctlst = rx_actv then
    packet_byte := packet_data(pkt_index);
    d0_sig <= packet_byte(bitn);
    d1_sig <= packet_byte(bitn+1);
    bitn := (bitn + 2) mod 8;
    if bitn = 0 then
      IF pkt_count = 1 then
--        rx_end := true; -- moved above
      else
        pkt_count :=  pkt_count - 1;
        pkt_index :=  pkt_index + 1;
      end IF;
    end IF;
  end IF;

  if ctlst = tx_gnt1  then      pkt_index := 1; bitn := 0; end if;
  IF ctlst = idle AND echo_req then
    rx_req := true;
    pkt_count := tx_count;
    bcast_packet    := false;
    cyc_strt_packet := false;
    iso_packet     := false;

    if ((packet_data(2) AND "00111111") = "00111111") then -- broadcast echo
      bcast_packet := true;   end IF;                      -- no ack is expected
    if ((packet_data(4) AND "11110000") = "10000000") then -- cycle start echo
      cyc_strt_packet := true; end if;                     -- no ack is expected
    if ((packet_data(4) AND "11110000") = "10100000") then -- iso packet echo
      iso_packet := true; end if;                          -- no ack is expected

    pkt_index := 1;
    bitn := 0;
    echo_req := false;
  end if;

  if ctlst = tx_hold then
    echo_req := echo_cmd and not rx_ack_active;
  end if;

  if ctlst = tx_hold then
   bitn := 0;
    tx_count  :=  0;
    pkt_index :=  1;
    packet_byte(bitn) := d0i_rg;
    packet_byte(bitn+1) := d1i_rg;
   end IF;

  if ctlst = tx_actv then
    packet_byte(bitn) := d0i_rg;
    packet_byte(bitn+1) := d1i_rg;
    bitn := (bitn + 2) mod 8;
    if bitn = 0 then
      packet_data(pkt_index) := packet_byte;
      tx_count  :=  tx_count + 1;
      pkt_index :=  pkt_index + 1;
    end IF;
  end IF;

bitn_sig <= bitn;
pkt_count_sig <= pkt_count;
pkt_index_sig <= pkt_index;
echo_req_sig <= echo_req;
rx_req_sig <= rx_req;
rx_end_sig <= rx_end;
tx_count_sig <= tx_count;
current_byte <= packet_data( pkt_index);
--packet_data_sig <= packet_data;
status_count_sig <= status_count;
lreq_command_sig <= lreq_command;
new_req_sig <= new_req;
tx_req_sig <= tx_req;
tx_ack_req_sig <= tx_ack_req;
st_req_sig <= st_req;
  
end process;                             -- sclk_proc

end;


