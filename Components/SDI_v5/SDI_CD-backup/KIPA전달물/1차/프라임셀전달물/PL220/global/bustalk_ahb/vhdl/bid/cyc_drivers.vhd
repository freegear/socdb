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
-- File Name              : cyc_drivers.vhd.rca
-- File Revision          : 1.1
--
-- Release Information    : PrimeCell(TM)-GLOBAL-REL1v7
--
-- ---------------------------------------------------------------------
-- Purpose :
--           Drives AHB address, data and control signals 
--
-- --=================================================================--

library ieee;
use     ieee.std_logic_1164.all;
use     ieee.std_logic_arith.all;

library common;
use     common.defs.all;
use     common.funcs.all;
-- ---------------------------------------------------------------------
entity cyc_drivers is
  generic(
          tclkl           : time;     -- AHB Clock Period for low phase
          tclkh           : time;     -- AHB Clock Period for high phase
          tiha            : time;     -- AHB address bus hold time
          tisa            : time;     -- AHB address bus setup time
          tihctl          : time;     -- AHB write signal hold time
          tisctl          : time;     -- AHB write signal setup time
          tihwd           : time;     -- AHB HWDATA hold time
          tiswd           : time;     -- AHB HWDATA setup time
          tihtr           : time;     -- AHB HTRANS hold time
          tistr           : time;     -- AHB HTRANS setup time
          tihmst          : time;     -- AHB MASTER hold time
          tihmlck         : time;     -- AHB MASTERLOCK hold time
          tismst          : time;     -- AHB MASTER setup time
          tismlck         : time;     -- AHB MASTERLOCK setup time
          Verbosity       : boolean;  -- Enables messages
          HaltOnMismatch  : boolean;  -- Enables termination on mismatch
          XonSig          : boolean;  -- Drives X's in default state if
                                      -- enabled
          Databuswidth    : integer   -- AHB buswidth
         );
  port(
       HCLK           : in  T_line;    -- AHB Clock Signal
       HRESETn        : in  T_line;    -- AHB Reset Signal
       HADDR          : out T_addr;    -- AHB  Address Bus
       HTRANS         : out T_trans;   -- AHB Transfer Mode
       HWRITE         : out T_line;    -- AHB Read/Write Signal
       HSIZE          : out T_size;    -- AHB Data Transfer Size
       HBURST         : out T_burst;   -- AHB Burst type
       HPROT          : out T_prot;    -- AHB HPROT signal
       HWDATA         : out T_data;    -- AHB Write Data Bus
       HMASTER        : out T_master;  -- AHB MASTER driving the Bus
       HMASTLOCK      : out T_line;    -- Slave locked by Master
       HRDATA         : in  T_data;    -- AHB Read Data Bus
       HREADY         : in  T_line;    -- AHB HREADY signal
       HRESP          : in  T_resp;    -- AHB Response signal
       DelHWRITE      : out T_line;    -- HWRITE for previour transfer
       Bidpacket      : in  T_bid;     -- Packet having information
                                       -- about signals to driven
       Bidgetline     : out T_get;     -- Request for new packet
       Endiansel      : in T_cycle;    -- Endianness cycle
       Vendianpacket  : in T_endian;   -- Endianness packet
       TogEndian      : out std_logic_vector(1 downto 0); 
                                       -- Toggle endiannes
       Cycsel         : in  T_cycle;   -- Transfer type
       CycCount       : out T_int;     -- indicates
                                       -- 'current-cycle-number' of the
                                       -- transfer being driven
       Simend         : out T_line     -- End of Simulation
      );
  end cyc_drivers;

-- ---------------------------------------------------------------------
--
--                              cyc_drivers
--                              ===========
--
-- ---------------------------------------------------------------------
--
-- Overview
-- ========
--   This module drives out all the address and control signals of AHB. 
-- The function of this module can be classified into two. These are
-- as follows :-
-- o Issuing get_line requests to the reader module.
--   Whenever a new packet is driven, the num_cyc value of the packet is
-- loaded on a down_counter, which counts with every clock. When value
-- of the down_counter reaches 1, then a get_line request is issued,
-- otherwise it stays in Gidle state.
-- o Driving the data, address and control signals.
--   These are also driven on basis of the down_counter mentioned above.
-- When count reaches 1, it indicates that at the end of this count, the
-- signals are to be driven.
-- 
-- --========================== ARCHITECTURE =========================--

architecture behavioural of cyc_drivers is

-- ---------------------------------------------------------------------
-- Component declarations
-- ---------------------------------------------------------------------
component countdown
  port (
        HCLK       : in std_logic;  
        Val        : in T_int;      
        Last       : out T_int;    
        Rscyc      : in std_logic   
       );
end component;

-- ---------------------------------------------------------------------
-- Constant declarations
-- ---------------------------------------------------------------------
constant ZERO       : std_logic_vector(63 downto 0) 
                    := to_stdlogicvector(X"0000000000000000");

-- ---------------------------------------------------------------------
-- Signal declarations
-- ---------------------------------------------------------------------

signal Val            : T_int := 0;
-- Value loaded into downcounter

signal Last           : T_int := 0;
-- Denotes end of current transfer

signal Bufbidpacket   : T_bid;
-- Buffered bidpacket

signal Buf2bidpacket  : T_bid;
-- Bidpacket driven in the penultimate transfer

signal Rsbidpacket    : T_bid;
-- Bidpacket driven in Retry/Split cycle

signal Rsnextpacket   : T_bid;
-- Bidpacket driven after a Retry/Split cycle

signal iBidgetline    : T_get := Gget; 
-- Internal request signal for new packet
 
signal iHADDR         : T_addr;
-- Internal HADDR signal

signal iHPROT         : T_prot;
-- Internal HADDR signal

signal iHWRITE        : T_line;
-- Internal HWRITE signal
 
signal iHTRANS        : T_trans;
-- Internal HTRANS signal

signal iHBURST        : T_burst;
-- Internal HBURST signal

signal iHSIZE         : T_size;
-- Internal HSIZE signal

signal iDelHSIZE      : T_size;
-- Internal delayed HSIZE signal
 
signal iHMASTER       : T_master;
-- Internal HMASTER signal

signal iHMASTLOCK     : T_line;
-- Internal HMASTERLOCK signal
 
signal iTogEndian     : std_logic_vector(1 downto 0) := "00";   
-- Internal TogEndianness bit

signal iDelHWRITE     : T_line;
-- Internal delayed HWRITE signal

signal iDelHTRANS     : T_line;
-- Internal delayed HTRANS signal indicating a NSEQ or SEQ if set

signal DelHBURST      : T_burst;
-- Delayed HBURST signal

signal DefHADDR       : T_addr := (others => '0');
-- Default Address bus

signal DefHWRITE      : T_line := '0';
-- Default HWRITE signal

signal DefHTRANS      : T_trans := "00";
-- Default HTRANS signal

signal DefHBURST      : T_burst := "000";
-- Default HBURST signal

signal DefHWDATA      : T_data  := (others => '0');
-- Default Write data bus

signal DefHSIZE       : T_size;
-- Default HSIZE signal

signal DefHPROT       : T_prot;
-- Default HPROT signal

signal DefHMASTER     : T_master;
-- Default HMASTER signal

signal DefHMASTLOCK   : T_line;
-- Default HMASTLOCK signal

signal expresp        : std_logic_vector(1 downto 0):= "00";
-- Expected response generated by testbench

signal Beatcount      : std_logic_vector(4 downto 0):= "00000";
-- Beat Counter

signal WSCount        : std_logic_vector(31 downto 0):= (others => '0');
-- Wait State Counter

signal Newtran        : std_logic := '1';
-- Denotes a new transfer

signal Count          : integer := 0; 
-- Numcycle 0 Counter 

signal Maxflag        : boolean := FALSE;
-- Denotes limit for number of re-issues of a command has reached

signal Maxflagpoll    : boolean := FALSE;
-- Denotes limit for number of re-issues of a poll command has reached

signal delflagpoll    : std_logic:= '0';
-- Delayed version of Maxflagpoll signal 

signal limitflag      : std_logic:= '0';
-- Denotes limit for number of re-issues of a command has reached

signal Nextissue      : std_logic := '0';
-- Indicates start of a transfer

signal Resplit        : std_logic := '0';
-- Denotes Retry/Split transfer

signal Rsidle         : std_logic := '0';
-- Denotes Idle cycle transfer in progress after Split/Retry

signal Pidle          : std_logic := '0';
-- Denotes Idle cycle transfer in progress after Poll

signal Idleflag       : boolean := FALSE;
-- Denotes limit  for number of re-issues of an idle  command has
-- reached

signal Idlecount      : integer := 0;
-- Indicates number of idle cycles to be inserted

signal Idledone       : boolean := FALSE;
-- Indicates end of idle cycle transfer in SPLIT/Retry transfer

signal Rsflag         : boolean := FALSE;
-- Indicates Retry/Split transfer reissue limit has reached

signal Rscount        : integer := 1;
-- Reissue counter value in Split/Retry

signal Rsdone         : std_logic := '0';
-- Retry/Split transfer over

signal delrsdone      : std_logic := '0';
-- Delayed version of Rsdone 

signal Rslast         : std_logic := '0';
-- Last transfer in SPLIT/RETRY

signal Resetover      : boolean := FALSE;
-- Denotes first reset is over

signal Resetstrd      : std_logic := '0'; 
-- Reset Status

signal Rscyc          : std_logic;
-- Retry/SPlit cycle

signal Oners          : std_logic;
-- Non-reissueable Split/Retry

signal Limit          : integer;
-- Denotes limit of reissue of a command

signal Limitrs        : integer;
-- Denotes limit of reissue of a command in Split/Retry

signal Writeaddr      : std_logic_vector(2 downto 0);
-- Actual address for which the data is being driven

signal ByteLaneDecidr : std_logic_vector(2 downto 0);
-- intermediate signal used for getting properly "endianized" data from
-- packet

signal iCycCount      : T_int := 1;
-- internal copy of the CycCount signal

signal iExpdata       : std_logic_vector(63 downto 0);
-- Expected data in the packet

signal Expdata        : std_logic_vector(63 downto 0);
-- Actual expected data depending on endianness

signal WriteData      : std_logic_vector(63 downto 0);
-- Actual data to be driven on bus 

signal blockidle      : std_logic := '1';
-- Indicates that a poll transfer is in progress 

signal delblockidle      : std_logic := '1';
-- Delayed version of blockidle 

signal del1blockidle      : std_logic := '1';
-- Delayed version of delblockidle

signal ActMask        : std_logic_vector(63 downto 0);
-- Writing data on appropriate lines

signal Mask           : std_logic_vector(63 downto 0);
-- Mask bits in any transfer 
 
signal ReadMask       : std_logic_vector(63 downto 0);
-- Actual mask in read cycle 

signal Pollstart      : std_logic;  
-- Indicates that the poll has started

signal Pollstartctl   : std_logic;  
-- control signal for poll start signal
 
signal delPollstart   : std_logic;  
-- Delayed version of Pollstart signal 

signal del1Pollstart  : std_logic;  
-- Delayed version of Pollstart signal 

signal Pollend        : std_logic;  
-- Indicates end of poll command

signal pocount        : std_logic_vector(31 downto 0)
                                      := (others => '0');
-- Poll counter
 
signal nextcount      : std_logic_vector(31 downto 0)
                                     := (others => '0');
-- Combinational logic for poll counter
 
signal time_out       : std_logic_vector(31 downto 0);
-- Time out for poll command

signal countflag      : boolean;
-- Control signal which indicates end of poll command due to timeout

constant ONE          : std_logic_vector(31 downto 0)
                       := "00000000000000000000000000000001";

constant ZEROFILL     : std_logic_vector(31 downto 0)
                       := "00000000000000000000000000000000";

-- ---------------------------------------------------------------------
--
-- Main body of code
-- =================
--
-- ---------------------------------------------------------------------
 
begin

-- ---------------------------------------------------------------------
  u_countdown : countdown
  port map (
       HCLK       => HCLK,
       Val        => Val,
       Last       => Last,
       Rscyc      => Rscyc
     );

-- ---------------------------------------------------------------------
-- Assigning the local copy to output
-- ---------------------------------------------------------------------
CycCount  <= iCycCount;
 
-- ---------------------------------------------------------------------
-- This block counts cycle-number of the ongoing transfer
-- ---------------------------------------------------------------------
p_counter : process (HCLK)
begin
  if HCLK'event and HCLK = '1' then
    if (Last = 1 or Maxflag or HREADY = '1') then              
      iCycCount <= 1;
    elsif last /= 1 and iCycCount < Maxint then     
      iCycCount <= iCycCount + 1;
    end if;
  end if;
end process p_counter;

-- ---------------------------------------------------------------------
  HADDR        <= iHADDR;
  HPROT        <= iHPROT;
  HWRITE       <= iHWRITE;
  HSIZE        <= iHSIZE;
  HMASTER      <= iHMASTER;
  HMASTLOCK    <= iHMASTLOCK;
  TogEndian    <= iTogEndian;

  DefHADDR     <= (others => 'X') when (XonSig = TRUE)
               else
                  (others => '0');
  DefHWDATA    <= (others => 'X') when (XonSig = TRUE)
               else
                  (others => '0');
  DefHTRANS    <= (others => 'X') when (XonSig = TRUE)
               else
                  (others => '0');
  DefHBURST    <= (others => 'X') when (XonSig = TRUE)
               else
                  (others => '0');
  DefHSIZE     <= (others => 'X') when (XonSig = TRUE)
               else
                  (others => '0');
  DefHWRITE    <= 'X'             when (XonSig = TRUE)
               else
                  '0';
  DefHPROT     <= (others => 'X') when (XonSig = TRUE)
               else
                  (others => '0');
  DefHMASTER   <= (others => 'X') when (XonSig = TRUE)
               else
                 (others => '0');
  DefHMASTLOCK <= 'X' when (XonSig = TRUE)
               else
                  '0';
 
  HTRANS       <= iHTRANS when (HRESETn /= '0') 
               else
                  "00" when (HRESETn = '0' and iHTRANS'event 
                             and iHTRANS /= "XX" and XonSig)
                                      -- idle cycle
                                      -- during reset
               else 
                  "00" when (HRESETn = '0' and iHTRANS'event 
                             and iHTRANS /= "00" and not(XonSig))
                                      --idle cycle
                                      -- during reset
               else
                  iHTRANS;

  HBURST      <= iHBURST;

  DelHWRITE   <= iDelHWRITE;

  Bidgetline  <= iBidgetline;

  Simend      <= Nextissue;

  -- Retry/Split with no re-issue (when numcyc /= 0 or expected
  -- response is a Retry or a Split)
  Oners       <= '0' when (HCLK'event and HCLK = '1' and Rsidle = '1')
              else
                 '1' after 1 ns when   ((Buf2bidpacket.numcyc /= 0 and
                                         Resplit = '1') 
                             or (((Rsbidpacket.resp = "10" and
                                   HRESP = "10") or
                                  (Rsbidpacket.resp = "11" and
                                   HRESP = "11")) and Rsidle /= '1')) 
              else
                 '0' when   (((Rsbidpacket.resp /= "10" and
                               HRESP = "10") or
                              (Rsbidpacket.resp /= "11" and
                               HRESP = "11")) and
                               Buf2bidpacket.numcyc = 0)
              else
                 Oners;
  -- RETRY/SPLIT cycle
  Rscyc       <= '1' when (HRESP = "10" or HRESP = "11")
                                                   -- Retry or Split
               else 
                  '0';

  -- store the Bidpacket that got a retry or a Split response
  -- store the Bidpacket that got a Poll command  
  Rsbidpacket <= Buf2bidpacket when (((HRESP = "10" or HRESP = "11") and
                                       Resplit /= '1' and
                                       Blockidle = '1') or
                                      (del1blockidle = '1' and
                                       delblockidle = '0') or
                                      (delRsdone = '1')) 
              else
                 Rsbidpacket;

  -- store the next command's Bidpacket when a Retry or Split response
  -- is got
  Rsnextpacket <= Bufbidpacket when ((HRESP = "10" or HRESP = "11") 
                                      and Resplit /= '1')
               else
                  Rsnextpacket;

  -- indicate the end of an issued numcyc = 0 command
  -- During a Poll command, Newtran should not be issued and should be
  -- issued only when the poll command is terminated
  Newtran        <= '1' when (HCLK'event and HCLK = '1' and Maxflag and
                              HRESP /= "10" and HRESP /= "11" and 
                              Pollstart = '0')
                 else
                    '0' when (Pollstart = '1' and Pollend /= '1' )
                 else
                    '1' when (Pollstart = '0' and Pollend = '1')
                 else 
                    HREADY when (HCLK'event and HCLK = '1' and
                                 Pollstart = '0' and
                               ((Resplit /= '1' and (not(Rsflag) or 
                               ((HRESP = "00" or HRESP = "01")))) or
                                (Resplit = '1' and
                                 Bufbidpacket.numcyc > 0))) 
                 else
                    Newtran;

  -- delayed version of the HWRITE signal status during the address
  -- phase to be used at the end of the data phase
  iDelHWRITE <= '0' when (HCLK'event and HCLK = '1' and
                          iHWRITE = '0' and
                         (Last = 1 or HREADY = '1' or Maxflag))
             else
                '1' when (HCLK'event and HCLK = '1' and
                          iHWRITE = '1' and
                         (Last = 1 or (HREADY = '1' or Maxflag)))
             else
                iDelHWRITE;

  -- delayed version of the HWRITE signal status during the address
  -- phase to be used at the end of the data phase
  iDelHTRANS <= '1' when (HCLK'event and HCLK = '1' and
                          iHTRANS(1) = '1' and
                         (Last = 1 or (HREADY = '1' or Maxflag)))
             else
                '0' when (HCLK'event and HCLK = '1' and
                          iHTRANS(1) = '0' and
                         (Last = 1 or (HREADY = '1' or Maxflag)))
             else
                iDelHTRANS;

  -- delayed version of the HSIZE signal during address phase to be used
  -- at the end of data phase
  iDelHSIZE <= iHSIZE when (HCLK'event and HCLK = '1' and
                           (Last = 1 or (HREADY = '1' or Maxflag)))
             else
                iDelHSIZE; 
  -- if the limit parameter in a Bidpacket has the default value of 0, 
  -- load maximum value of integer
  Limit        <= Buf2bidpacket.limit when Buf2bidpacket.limit /= 0
               else
                  Maxint; -- 7FFFFFFF;

  -- if the limit parameter in a Bidpacket that got a retry/split
  -- response has the default value of 0, load maximum value of integer
  Limitrs     <= Rsbidpacket.limit when Rsbidpacket.limit /= 0
              else
                 Maxint; -- 7FFFFFFF;

  -- Maxflag becomes true when limit for number of re-issues of a
  -- command when numcyc = 0
  -- Set when count exceeds limit in any transfer or in reset or idle
  -- cycles Set when the pollcommand timeout is reached
  Maxflag      <= TRUE when (((count > Limit - 1) and HREADY = '0' 
                             and Resplit = '0' and HRESP(1) = '0' 
                             and Pollstart = '0') or 
                             ((count > (Limitrs - 1)) and HREADY = '0' 
                             and Resplit = '1') or
                             (((Buf2bidpacket.trans = "00" and
                                HREADY = '1' and Resplit /= '1') or
                                HRESETn = '0') and (count > 1))) or
                               (Resplit = '1' and Rsidle = '1' and
                               (count > 1)) or (countflag = FALSE and
                                Pollstart = '1')
               else
                  FALSE;

-- Control signal which indicates that the limit for number of re-issues
-- is reached during a poll command and is deasserted at the end of poll
-- command
  Maxflagpoll <= TRUE when ((count > Limit - 1) and HREADY = '0'
                             and Resplit = '0' and HRESP(1) = '0'
                             and Pollstart = '1' and Pollend = '0') 
                 else 
                   FALSE when (Pollend = '1') 
                 else 
                   Maxflagpoll;      
    
  -- signal to indicate the start of a new transfer
  Nextissue   <= '1' when (((Last = 1 or HREADY = '1'or
                            (HREADY = '0' and
                            (HRESP="10" or HRESP="11"))) and 
                             Buf2bidpacket.numcyc /= 0) or
                           ((Maxflag or HREADY = '1' or
                            (HREADY = '0' and
                            (HRESP = "10" or HRESP="11"))) and
                            ((Last <= 1 and Buf2bidpacket.numcyc = 0) or
                            (Buf2bidpacket.trans = "00" and
                             HREADY = '1') or (HRESETn = '0'))))
              else
                 '0'; 
  -- signal to indicate that the required number of idle cycles between 
  -- re-issues of a retry/split transfer have been issued 
  Idleflag     <= TRUE when (((Idlecount >= (Rsbidpacket.idlcyc - 1))
                               and (Rsbidpacket.idlcyc > 1)) or 
                             ((Rsbidpacket.idlcyc = 1 and
                             ((iHTRANS = "00" and Resplit = '1' and
                               HREADY = '1') or (Oners = '1' and
                               HREADY = '0'))))) 
               else
                  FALSE;
 
  -- signal to indicate that the limit for the number of re-issues of a 
  -- retried/split transfer is reached
  Rsflag       <= TRUE when ((Rscount > (Buf2bidpacket.rslimit - 1)) and
                            Buf2bidpacket.rslimit /= 0) or
                            (Rscount = Maxint) or
                            (Oners = '1') -- indicates a non-reissuable 
                                          -- retry/split
               else
                  FALSE;

  -- indicates the end of a retry/split command
  Rsdone       <= '1' when Resplit'event and Resplit = '0' 
               else
                  '0' when Rsdone = '1' and HCLK'event and HCLK = '1'
               else
                  Rsdone;

  -- indicates the last transfer in a retry/split and poll command 
   
  Rslast       <= '1' when Rsdone'event and Rsdone ='1'
               else 
                  '0' when iBidgetline = Gget
               else
                  '0' when (delrsdone = '1' and HCLK'event and
                            HCLK = '0' and Pollstart = '1')
               else 
                  Rslast;

-- ---------------------------------------------------------------------
-- Assigning the state of Idle cycle transfer 
-- ---------------------------------------------------------------------
-- indicate the end of the idle cycles between re-issues of a
-- retried/split command
p_endidle : process (HCLK)
begin
  if (HCLK'event and HCLK = '1' and Idleflag) then
    Idledone <= TRUE;
  elsif (not(Idleflag)) then
    Idledone <= FALSE;
  end if;
end process p_endidle;

-- ---------------------------------------------------------------------
-- Delayed version of Rsdone signal 
-- ---------------------------------------------------------------------
p_delrsdone : process (HCLK)
begin
  if (HCLK'event and HCLK = '1') then
    delrsdone <= Rsdone;
  end if;
end process p_delrsdone;

-- ---------------------------------------------------------------------
-- Generation of Pollstart signal
-- ---------------------------------------------------------------------
-- inidicates that the poll command cycle is started 
p_pollstart : process (Pollstartctl, countflag, Pollend)
begin
    if (Pollstartctl = '1') then
      Pollstart <= '1';
    elsif (Pollend = '1' or (countflag = FALSE)) then
      Pollstart <= '0';
    end if;
end process p_pollstart;

-- ---------------------------------------------------------------------
-- Generation of delayed  Maxflagpoll signal
-- ---------------------------------------------------------------------
p_delflagpoll : process (HCLK,HRESETn)
begin
  if (HRESETn = '0') then
     delflagpoll <= '0';
  elsif (HCLK'event and HCLK = '1') then
    if (Maxflagpoll = TRUE) then
      delflagpoll <= '1';
    else
      delflagpoll <= '0';
    end if;
  end if;
end process p_delflagpoll;

-- ---------------------------------------------------------------------
-- Generation of control signal for Pollstart signal
-- ---------------------------------------------------------------------
p_pollstartctl : process (HCLK,HRESETn)
begin
  if (HRESETn = '0') then
     Pollstartctl <= '0';
  elsif (HCLK'event and HCLK = '1') then
    if (Cycsel = Csp) then
      Pollstartctl <= '1';
    else
      Pollstartctl <= '0';
    end if;
  end if;
end process p_pollstartctl;

-- ---------------------------------------------------------------------
-- Generation of control signal which indicates that the poll command
-- is in progress 
-- ---------------------------------------------------------------------
blockidle <= '1' when (HCLK'event and HCLK = '1' and Pollstart = '0') 
            else 
            '0' when (HREADY = '1' and HRESP = "00" and
                      Rsidle /= '1' and
                      HCLK'event and HCLK = '0' and Pollstart = '1') 
            else
            blockidle;  

-- ---------------------------------------------------------------------
-- Delayed version of blockidle signal   
-- ---------------------------------------------------------------------
delblockidle <= blockidle when (HCLK'event and HCLK = '0')
                else  
                delblockidle;
-- ---------------------------------------------------------------------
-- Delayed version of delblockidle signal 
-- ---------------------------------------------------------------------
del1blockidle <= delblockidle when (HCLK'event and HCLK = '0')
                 else
                 del1blockidle;

-- ---------------------------------------------------------------------
-- Generation of delayed  Pollstart signal
-- ---------------------------------------------------------------------
p_delpollstart : process (HCLK,HRESETn)
begin
  if (HRESETn = '0') then
     delPollstart <= '0';
     del1Pollstart <= '0';
  elsif (HCLK'event and HCLK = '1') then
      delPollstart <= Pollstart;
      del1Pollstart <= delPollstart;
  end if;
end process p_delpollstart;

-- ---------------------------------------------------------------------
-- Poll Counter
-- ---------------------------------------------------------------------
-- The countflag indicates that the time out has been reached
-- pocount is the counter which is incremented for every re-issue during
-- a poll command 
count_seq : process (Pollstart, HCLK)
begin
  if (Pollstart'event and Pollstart = '1')  then
                      -- Initialise count and countflag at
                      -- the start of every command
    pocount <= (others => '0');
    countflag <= TRUE;
  elsif (HCLK'event and HCLK = '1') then  
                      -- increment count at every poll
    if (iHTRANS = "00" and HREADY = '1') then
      pocount <= nextcount;
    end if;
    if ((unsigned(pocount) = (unsigned(time_out) - 1)) and
         HREADY = '1' and Pidle /= '1'
         and delblockidle = '0' and HRESP = "00") then
      countflag <= FALSE;
    end if;
  end if;
end process;

-- ---------------------------------------------------------------------
-- Time out signal 
-- ---------------------------------------------------------------------
-- Timeout is the variable which indicates that the timeout for the poll
-- command has been reached. 
p_timeout : process (HRESETn, HCLK, Pollstart)
begin
  if (HRESETn = '0' or (Pollstart'event and Pollstart = '1')) then
    time_out <= (others => '0');
  elsif (HCLK'event and HCLK = '1')  then
                      -- Initialise time_out
    if (Pollstart = '1' and delPollstart = '0') then  
      time_out <= Bufbidpacket.timeout;
    end if;
  end if;
end process p_timeout;

-- ---------------------------------------------------------------------
-- Control logic for poll counter 
-- ---------------------------------------------------------------------
count_comb : process (Pollstart, HREADY, HRESP, blockidle, HCLK, Pidle)
begin
    if ((Pollstart = '1') and (HREADY = '1') and
        (HCLK'event and HCLK = '0') and
         HRESP = "00" and Pidle  /= '1' and blockidle = '0') then
                       -- increment nextcount before a poll
      nextcount <= (unsigned(pocount) + 1);
    else
      nextcount <= pocount;
    end if;
end process;

-- ---------------------------------------------------------------------
-- Latching reset status 
-- ---------------------------------------------------------------------
-- indicate the end of the first reset in the simulation
p_ResetStore : process (HCLK, HRESETn)
begin
  if (HCLK'event and HCLK = '1') then
    if (HRESETn = '0') then
      Resetstrd <= '1';
    end if;
  end if;
  if ((Resetstrd = '1') and (HRESETn = '1')) then
    Resetover <= TRUE;
  end if;
end process p_ResetStore;

-- ---------------------------------------------------------------------
-- Loading Numcycle Counter 
-- ---------------------------------------------------------------------
p_loader : process (HCLK,Rsdone, Rscyc, Last, Rslast, Rsidle, Resplit,
                    Rsflag, Bufbidpacket, HREADY, Maxflag, Idledone,
                    Pollstart)
begin
  if (Pollstart = '1') then
    Val <= 0;
  elsif (HCLK = '0' and Rslast /= '1' and ((Last = 1) or
     ((Maxflag or (HREADY = '1')) and Last = 0))) then 
    Val <= Bufbidpacket.numcyc;
  elsif (HCLK = '0' and Last = 1 and Resplit = '1') then
    if (Idledone) then
      Val <= Rsbidpacket.numcyc; -- re-issue of retried/split transfer
    else   
      Val <= 1; -- idle cycles between retries/splits 
    end if;
  elsif (Rslast = '1' and HCLK = '0' and Rsidle = '1') then 
    Val <= Rsnextpacket.numcyc; -- re-issue of command after the 
                                -- retried/split command
  elsif (Last = 1 and Rslast = '1' and HREADY = '1' and 
         HCLK = '0' and Rsidle /= '1') then
    Val <= Bufbidpacket.numcyc; 
  elsif (Rsdone = '1' and HCLK = '0' and Rsflag) then
    Val <= 1; -- end of retried/split command due to Rsflag being
              -- reached
  else
    Val <= 0;
  end if; 
end process p_loader;
 
-- ---------------------------------------------------------------------
-- Assigning Request for new packet and buffering old packets 
-- ---------------------------------------------------------------------
-- get next command from reader and store Bidpacket in Bufbidpacket and
-- Bufbidpacket in Buf2bidpacket
lineget : process (HCLK)
begin
  if (HCLK'event and HCLK = '0') then      
    if  ((Last = 1 and Resplit /= '1' and not(Idledone) and
          Oners /= '1' and
          (not(rsflag) or (rsflag and rsidle /= '1'))) or
         ((Newtran = '1' or (Pollstart = '1' and delPollstart = '0')) 
           and (last = 0) and  
          not(Resplit = '0' and Rsidle = '1' and not(Rsflag)))) then
      iBidgetline   <= Gget;
    end if;
  elsif (HCLK'event and HCLK = '1') then
    iBidgetline <= Gidle;
  end if;
end process lineget;

-- ---------------------------------------------------------------------
-- Assigning Request for new packet and buffering old packets
-- ---------------------------------------------------------------------
-- get next command from reader and store Bidpacket in Bufbidpacket and
-- Bufbidpacket in Buf2bidpacket
Bufferbid : process (HCLK)
begin
  if (HCLK'event and HCLK = '0') then
    if (((Last = 1 and Resplit /= '1' and not(Idledone) and
          Oners /= '1' and
         (not(rsflag) or (rsflag and rsidle /= '1'))) or
        ((Newtran = '1' or (Pollstart = '1' and delPollstart = '0') or 
         (delblockidle = '1' and blockidle = '0'))
          and (last = 0) and
          not(Resplit = '0' and Rsidle = '1' and not(Rsflag)))) or
         (Rslast = '1' and pocount = ZEROFILL and Pollstart = '1')) then
      Bufbidpacket  <= Bidpacket;
      Buf2bidpacket <= Bufbidpacket;
    end if;
  end if;
end process Bufferbid;

-- ---------------------------------------------------------------------
-- Driving address and control signals 
-- ---------------------------------------------------------------------
p_drive : process (HCLK)
begin
  if (HCLK'event and HCLK = '1' and Nextissue = '1') then
    -- Issue commands other than idle cycle 
    if (Bidpacket.trans /= "00" or (Bidpacket.trans = "00" 
          and (Resplit /= '0' or Pollstart /= '0'))) then
      -- indicates that a re-issuable retry/split is in progress 
       if (Resplit = '1' or (Pollstart = '1' and HREADY = '1'  and 
           (iHTRANS /= "00" or (iHTRANS = "00" and   
           (unsigned(pocount) /= unsigned(time_out) - 1) and
           ((HRDATA and ReadMask) /= (Expdata and ReadMask)))))) then 
        -- Reissue Xr at the end of idle cycle between retry/split
        -- re-issues in a non-zero num-cycle mode
        if (iHTRANS = "00" and
          ((Idleflag and Rsbidpacket.numcyc /= 0) or
           (Pollstart ='1' and Resplit = '0'))) then
          iHADDR     <= DefHADDR after Tiha, 
                        Rsbidpacket.addr after Tclkh + Tclkl - Tisa;
          iHWRITE    <= DefHWRITE after tihctl,
                        Rsbidpacket.write after Tclkh + Tclkl - tisctl;
          iHSIZE     <= DefHSIZE after tihctl,
                        Rsbidpacket.size after Tclkh + Tclkl - tisctl;
          iHPROT      <= DefHPROT after tihctl ,
                        Rsbidpacket.prot after Tclkh + Tclkl - tisctl;
          iHTRANS    <= DefHTRANS after tihtr,
                        Rsbidpacket.trans after Tclkh + Tclkl - tistr;
          iHBURST    <= DefHBURST after tihctl,
                        Rsbidpacket.burst after Tclkh + Tclkl - tisctl;
          iHMASTER   <= DefHMASTER after tihmst,
                        Rsbidpacket.masternum
                                          after Tclkh + Tclkl - tismst;
          iHMASTLOCK <= DefHMASTLOCK after tihmlck,
                        Rsbidpacket.masterlock
                                         after Tclkh + Tclkl - tismlck;
        -- Re-issue transfer and re-built burst at the time of re-issue
        elsif (iHTRANS = "00" and Idleflag and Rsbidpacket.numcyc = 0)
               then
          iHADDR     <= DefHADDR after Tiha,
                        Rsbidpacket.addr after Tclkh + Tclkl - Tisa;
          iHWRITE    <= DefHWRITE after tihctl,
                        Rsbidpacket.write after Tclkh + Tclkl - tisctl;
          iHSIZE     <= DefHSIZE after tihctl,
                        Rsbidpacket.size after Tclkh + Tclkl - tisctl;
          iHPROT      <= DefHPROT after tihctl ,
                        Rsbidpacket.prot after Tclkh + Tclkl - tisctl;
          iHTRANS    <= DefHTRANS after tihtr,
                        "10" after Tclkh + Tclkl - tistr;
          iHBURST    <= DefHBURST after tihctl,
                        Rsbidpacket.burst after Tclkh + Tclkl - tisctl;
          iHMASTER   <= DefHMASTER after tihmst,
                        Rsbidpacket.masternum
                                          after Tclkh + Tclkl - tismst;
          iHMASTLOCK <= DefHMASTLOCK after tihmlck,
                        Rsbidpacket.masterlock
                                          after Tclkh + Tclkl - tismlck;
        -- idle cycles between retry/split re-issues or 
        -- idle cycle after a split/retry response 
        elsif (iHTRANS = "00" and not(Idleflag)) or (HREADY = '0' and
              (HRESP = "10" or HRESP = "11")) or (Pollstart = '1' and
               HREADY = '1' and blockidle = '0') then 
          iHADDR     <= DefHADDR after Tiha,
                        (others => '0') after Tclkh + Tclkl -Tisa;
          iHWRITE    <= DefHWRITE after tihctl,
                       '0' after Tclkh + Tclkl - tisctl;
          iHSIZE     <= DefHSIZE after tihctl,
                        (others => '0') after Tclkh + Tclkl - tisctl;
          iHPROT      <= DefHPROT after tihctl,
                        (others => '0') after Tclkh + Tclkl - tisctl;
          iHTRANS    <= DefHTRANS after tihtr,
                        "00" after Tclkl + Tclkh - tistr;
          iHBURST    <= DefHBURST after tihctl,
                        (others => '0') after Tclkl + Tclkh - tisctl;
          iHMASTER   <= DefHMASTER after tihmst,
                        (others => '0') after Tclkh + Tclkl - tismst;
          iHMASTLOCK <= DefHMASTLOCK after tihmlck,
                        '0' after Tclkh + Tclkl - tismlck;
        -- re-issue the command after the retried/split command
        elsif (Rsidle = '1' and (HRESP = "00" or HRESP = "01")) then
          iHADDR     <= DefHADDR  after Tiha,
                        Rsnextpacket.addr after Tclkh + Tclkl - Tisa;
          iHWRITE    <= DefHWRITE after tihctl,
                        Rsnextpacket.write after Tclkh + Tclkl - tisctl;
          iHSIZE     <= DefHSIZE after tihctl,
                        Rsnextpacket.size after Tclkh + Tclkl - tisctl;
          iHPROT      <= DefHPROT after tihctl,
                        Rsnextpacket.prot after Tclkh + Tclkl - tisctl;
          iHTRANS    <= DefHTRANS after tihtr,
                        Rsnextpacket.trans after Tclkl + Tclkh - tistr;
          iHBURST    <= DefHBURST after tihctl,
                        Rsnextpacket.burst after Tclkh + Tclkl - tisctl;
          iHMASTER   <= DefHMASTER after tihmst,
                        Rsnextpacket.masternum
                                          after Tclkh + Tclkl - tismst;
          iHMASTLOCK <= DefHMASTLOCK after tihmlck,
                        Rsnextpacket.masterlock
                                          after Tclkh + Tclkl - tismlck;
        -- end of numcyc = 0 command due to limit
        elsif (Maxflag) then  
          iHADDR     <= DefHADDR after Tiha,
                        Bidpacket.addr after Tclkl + Tclkh - Tisa;
          iHWRITE    <= DefHWRITE after tihctl,
                        Bidpacket.write after Tclkl + Tclkh - tisctl;
          iHSIZE     <= DefHSIZE after tihctl,
                        Bidpacket.size after Tclkl + Tclkh - tisctl;
          iHPROT      <= DefHPROT after tihctl,
                        Bidpacket.prot after Tclkl + Tclkh - tisctl;
          iHTRANS    <= DefHTRANS after tihtr,
                        Bidpacket.trans after Tclkl + Tclkh - tistr;
          iHBURST    <= DefHBURST after tihctl,
                        Bidpacket.burst after Tclkl + Tclkh - tisctl;
          iHMASTER   <= DefHMASTER after tihmst,
                        Bidpacket.masternum
                                          after Tclkh + Tclkl - tismst;
          iHMASTLOCK <= DefHMASTLOCK after tihmlck,
                        Bidpacket.masterlock
                                         after Tclkh + Tclkl - tismlck;
        end if;
      -- idle_cyc after last retry/split command or
      -- if it is a non-reissuable retry/split 
      elsif (Rscount = 1 and (((iHTRANS /= "00" or Idlecount = 0) and 
             HRESP /= "00" and HRESP /= "01" and HRESP /= "XX") or 
             (Rsflag and (Idlecount = 0)))) then
        iHADDR     <= DefHADDR after Tiha,
                      (others => '0') after Tclkh + Tclkl - Tisa;
        iHWRITE    <= DefHWRITE after tihctl,
                      '0' after Tclkh + Tclkl - tisctl;
        iHSIZE     <= DefHSIZE after tihctl,
                     (others => '0') after Tclkh + Tclkl - tisctl;
        iHPROT      <= DefHPROT after tihctl,
                      (others => '0') after Tclkh + Tclkl - tisctl;
        iHTRANS    <= DefHTRANS after tihtr,
                      "00" after Tclkh + Tclkl - tistr;
        iHBURST    <= DefHBURST after tihctl,
                      (others => '0') after Tclkh + Tclkl - tisctl;
        iHMASTER   <= DefHMASTER after tihmst,
                      (others => '0') after Tclkh + Tclkl - tismst;
        iHMASTLOCK <= DefHMASTLOCK after tihmlck,
                      '0' after Tclkh + Tclkl - tismlck; 
      -- next command re-issue after the retry/split command ends
      elsif (Rsflag and ((HRESP /= "00" and HRESP /= "01") or
            (Idlecount = 1))) then
        iHADDR     <= DefHADDR after Tiha,
                      Rsnextpacket.addr after Tclkh + Tclkl - Tisa;
        iHWRITE    <= DefHWRITE after tihctl,
                      Rsnextpacket.write after Tclkh + Tclkl - tisctl;
        iHSIZE     <= DefHSIZE after tihctl,
                      Rsnextpacket.size after Tclkh + Tclkl - tisctl;
        iHPROT      <= DefHPROT after tihctl,
                      Rsnextpacket.prot after Tclkh + Tclkl - tisctl;
        iHTRANS    <= DefHTRANS after tihtr,
                      Rsnextpacket.trans after Tclkh + Tclkl - tistr;
        iHBURST    <= DefHBURST after tihctl,
                      Rsnextpacket.burst after Tclkh + Tclkl - tisctl;
        iHMASTER   <= DefHMASTER after tihmst,
                      Rsnextpacket.masternum
                                          after Tclkh + Tclkl - tismst;
        iHMASTLOCK <= DefHMASTLOCK after tihmlck,
                      Rsnextpacket.masterlock
                                         after Tclkh + Tclkl - tismlck;
      -- Retain the same value during a poll command when HREADY is low
      elsif (Pollstart = '1' and HREADY = '0') then 
        iHADDR     <= iHADDR; 
        iHWRITE    <= iHWRITE; 
        iHSIZE     <= iHSIZE; 
        iHPROT     <= iHPROT;  
        iHTRANS    <= iHTRANS; 
        iHBURST    <= iHBURST; 
        iHMASTER   <= iHMASTER; 
        iHMASTLOCK <= iHMASTLOCK; 
      -- NSEQ or SEQ or BUSY transfer
      else
        iHADDR     <= DefHADDR after Tiha,
                      Bidpacket.addr after Tclkh + Tclkl - Tisa;
        iHWRITE    <= DefHWRITE after tihctl,
                      Bidpacket.write after Tclkh + Tclkl - tisctl;
        iHSIZE     <= DefHSIZE after tihctl,
                      Bidpacket.size after Tclkh + Tclkl - tisctl;
        iHPROT      <= DefHPROT after tihctl,
                      Bidpacket.prot after Tclkh + Tclkl - tisctl;
        iHTRANS    <= DefHTRANS after tihtr,
                      Bidpacket.trans after Tclkh + Tclkl - tistr;
        iHBURST    <= DefHBURST after tihctl,
                      Bidpacket.burst after Tclkh + Tclkl - tisctl;
        iHMASTER   <= DefHMASTER after tihmst,
                      Bidpacket.masternum after Tclkh + Tclkl - tismst;
        iHMASTLOCK <= DefHMASTLOCK after tihmlck,
                      Bidpacket.masterlock
                                         after Tclkh + Tclkl - tismlck;
      end if;
    else
      iHADDR     <= DefHADDR after Tiha,
                    Bidpacket.addr after Tclkl + Tclkh - Tisa;
      iHWRITE    <= DefHWRITE after tihctl,
                    Bidpacket.write after Tclkl + Tclkh - tisctl;
      iHSIZE     <= DefHSIZE after tihctl,
                    Bidpacket.size after Tclkh + Tclkl - tisctl;
      iHPROT      <= DefHPROT after tihctl,
                    Bidpacket.prot after Tclkl + Tclkh - tisctl;
      iHTRANS    <= DefHTRANS after tihtr,
                    Bidpacket.trans after Tclkl + Tclkh - tistr;
      iHBURST    <= DefHBURST after tihctl,
                    Bidpacket.burst after Tclkl + Tclkh - tisctl;
      iHMASTER   <= DefHMASTER after tihmst,
                    Bidpacket.masternum after Tclkh + Tclkl - tismst;
      iHMASTLOCK <= DefHMASTLOCK after tihmlck,
                    Bidpacket.masterlock after Tclkh + Tclkl - tismlck;
    end if;
  end if;
end process p_drive;

-- ---------------------------------------------------------------------
-- Write cycle address 
-- ---------------------------------------------------------------------
p_AddrComb : process (Nextissue, Resplit, iHWRITE, Bufbidpacket,
                      Rsbidpacket)
begin
  if (Nextissue = '1' and Resplit /= '1' and iHWRITE = '1') then
    Writeaddr <= Bufbidpacket.addr(2 downto 0);
    WriteData <= Bufbidpacket.data;
  -- drive data from Rsbidpacket during a re-issuable retry/split
  elsif (Nextissue = '1' and Resplit = '1' and iHWRITE = '1') then
    Writeaddr <= Rsbidpacket.addr(2 downto 0);
    WriteData <= Rsbidpacket.data;
  end if;
end process p_AddrComb;

-- ---------------------------------------------------------------------
-- This block "processes" the lower order bits of HADDR on basis of
-- endianness.
-- When little-endian, it passes the lower HADDR bits as it is
-- otherwise it inverts the bits. This helps in keeping the previous
-- block(p_endianize) simple.
-- ---------------------------------------------------------------------
p_optimizer : process (Writeaddr, iTogEndian)
begin
  if (iTogendian = "00" or iTogendian = "10") then
    ByteLaneDecidr <= Writeaddr;
  elsif (iTogendian = "01") then
    ByteLaneDecidr <= not (Writeaddr);
  end if;
end process p_optimizer;

-- ---------------------------------------------------------------------
-- Stores the Endianness of the system
-- ---------------------------------------------------------------------
p_endian : process (HCLK, Endiansel)
  begin
    if (HCLK'event and Endiansel = Cendian) then
      iTogEndian <= Vendianpacket.endian;
    end if;
end process p_endian;

-- ---------------------------------------------------------------------
-- Driving Write data bus 
-- ---------------------------------------------------------------------
wdata : process (HCLK)
begin
  -- drive data from Bufbidpacket when a non_retry/split transfer in
  -- progress
  if (HCLK'event and HCLK = '1') then
    if (Nextissue = '1' and Resplit /= '1' and iHWRITE = '1') then
      HWDATA <= (others => 'X') after tihwd,
                  endianize (WriteData, iTogEndian, Bufbidpacket.size, 
                             Databuswidth, Bufbidpacket.addr,
                             ByteLaneDecidr)
                             after Tclkh + Tclkl - tiswd;
    -- drive data from Rsbidpacket during a re-issuable retry/split
    elsif (Nextissue = '1' and Resplit = '1' and iHWRITE = '1') then 
      HWDATA <= (others => 'X') after tihwd, 
                 endianize (WriteData, iTogEndian, Rsbidpacket.size, 
                            Databuswidth, Rsbidpacket.addr,
                            ByteLaneDecidr)
                            after Tclkh + Tclkl - tiswd;
    -- dont drive the HWDATA during read
    elsif (Nextissue = '1' and iDelHWRITE = '0' and Resplit /= '1') then
      HWDATA <= DefHWDATA after tihwd; 
    -- dont drive data during a  retry/split read 
    elsif (Nextissue = '1' and iDelHWRITE = '0' 
           and Resplit = '1' and (HRESP = "11" or HRESP = "10")
           and HREADY = '1') then 
      HWDATA <= DefHWDATA after tihwd; 
    end if;
  end if;
end process wdata;

-- ---------------------------------------------------------------------
-- Checking writing into slave
-- ---------------------------------------------------------------------
p_wdata : process (HCLK)
begin 
  -- check data during non-idle/busy transfer when response indicates OK
  if (HCLK'event and HCLK = '1') then
    if (iDelHWRITE = '1' and Nextissue = '1' and HRESETn /= '0') then
      if (HRESP = "00" and HREADY = '1' and
          Buf2bidpacket.trans /= "00" and
          Resplit /= '1' and Rsidle /= '1' and 
          Buf2bidpacket.trans /= "01") then
        ReportWrite(Verbosity, WriteData, Buf2bidpacket.addr,
                    Buf2bidpacket.tag);
      -- transfer which gets an OK response
      elsif (HRESP = "00" and HREADY = '1' and (Resplit = '1' or
             Rsdone = '1') and Rsidle /= '1' ) then
        ReportWrite(Verbosity, WriteData, Rsbidpacket.addr,
                    Rsbidpacket.tag );
      end if;
    end if;
  end if;
end process p_wdata;

-- ---------------------------------------------------------------------
-- Read cycle Mask value depending on transfer 
-- ---------------------------------------------------------------------
p_MaskComb : process(iDelHWRITE, Nextissue, HRESETn, HREADY, HRESP,
                     Resplit, Rsidle, Buf2bidpacket, Rsbidpacket.mask,
                     Rsdone, iDelHTRANS)
begin
if (iDelHWRITE = '0' and iDelHTRANS = '1' and Nextissue = '1' and 
    HRESETn /= '0') then
   if (HRESP = "00" and HREADY = '1' and Buf2bidpacket.trans /= "00" and
       Resplit /= '1' and Rsidle /= '1' and
       Buf2bidpacket.trans /= "01") then
     Mask     <= Buf2bidpacket.mask;
     iExpData <= Buf2bidpacket.exp;
    -- transfer which gets an OK response
   -- read data check at the end of a retried/split
   elsif (HRESP = "00"  and HREADY = '1' and
         (Resplit = '1'  or Rsdone = '1') and Rsidle /= '1') then
     Mask     <= Rsbidpacket.mask;
     iExpData <= Rsbidpacket.exp;
   end if;
end if;
end process p_MaskComb;

-- ---------------------------------------------------------------------
-- Driving Write data bus
-- ---------------------------------------------------------------------
p_ExpDATA : process(iExpData, iTogEndian, iDelHSIZE)
begin
  if (iTogEndian = "01" and iDelHSIZE /= "XXX") then
    if (Databuswidth = 64) then 
      case iDelHSIZE(2 downto 0) is
        when "000" =>
          ExpData <= iExpData(7 downto 0) & iExpData(15 downto 8) &
                     iExpData(23 downto 16) & iExpData(31 downto 24) &
                     iExpData(39 downto 32) & iExpData(47 downto 40) &
                     iExpData(55 downto 48) & iExpData(63 downto 56);
        when "001" =>
          ExpData <= iExpData(15 downto 8) & iExpData(7 downto 0) &
                     iExpData(31 downto 24) & iExpData(23 downto 16) &
                     iExpData(47 downto 40) & iExpData(39 downto 32) &
                     iExpData(63 downto 56) & iExpData(55 downto 48);
        when "010" =>
          ExpData <= iExpData(31 downto 0) & iExpData(63 downto 32);
        when "011" =>
          ExpData <= iExpData;
        when others =>
          null;
      end case;
    elsif (Databuswidth = 32) then
      case iDelHSIZE(2 downto 0) is
        when "000" =>
          ExpData <= "00000000000000000000000000000000" & 
                     iExpData(7 downto 0) & iExpData(15 downto 8) &
                     iExpData(23 downto 16) & iExpData(31 downto 24);
        when "001" =>
          ExpData <= "00000000000000000000000000000000" & 
                     iExpData(15 downto 8) & iExpData(7 downto 0) &
                     iExpData(31 downto 24) & iExpData(23 downto 16);
        when "010" =>
          ExpData <= "00000000000000000000000000000000" & 
                     iExpData(31 downto 0); 
        when others =>
          null;
      end case;
    end if;
  else
    ExpData <= iExpData;
  end if;
end process p_ExpDATA;

-- ---------------------------------------------------------------------
-- Assigning Mask value depending on Endianness
-- ---------------------------------------------------------------------
p_ReadMaskComb : process (iTogEndian, Mask)
begin
  if (iTogEndian = "01") then
    for i in (Databuswidth -1) downto 0 loop
      ReadMask(i) <= Mask(Databuswidth - i -1);
    end loop;
  else
    ReadMask    <= Mask;
  end if;
end process p_ReadMaskComb;

-- ---------------------------------------------------------------------
-- Checking Read data bus 
-- ---------------------------------------------------------------------
p_rdata : process (HCLK)
variable printstr  : string(1 to 255);
begin
 -- check data during non-idle/busy transfer when response indicates OK
 if (iDelHWRITE = '0' and HCLK'event and HCLK = '1' and 
     Nextissue = '1' and HRESETn /= '0') then 
   if (HRESP = "00" and HREADY = '1' and Buf2bidpacket.trans /= "00" and
       Resplit /= '1' and Rsidle /= '1' and
       Buf2bidpacket.trans /= "01") then
     ReportRead(Verbosity, HaltOnMismatch, HRDATA, ReadMask,
                Buf2bidpacket.addr, Pollstart, delPollstart, Pollend,
                Pidle, Maxflagpoll, pocount, countflag,Expdata,
                Buf2bidpacket.tag );
   -- transfer which gets an OK response
   -- read data check at the end of a retried/split
   elsif (HRESP = "00"  and HREADY = '1' and
         (Resplit = '1'  or Rsdone = '1' or
          delPollstart = '1') and Rsidle /= '1') then
     ReportRead(Verbosity, HaltOnMismatch, HRDATA, ReadMask,
                Rsbidpacket.addr, Pollstart,delPollstart, Pollend,
                Pidle, Maxflagpoll, pocount, countflag, Expdata,
                Rsbidpacket.tag ); 
   end if; 
 end if;
end process p_rdata;

-- ---------------------------------------------------------------------
-- Generating Expected Response 
-- ---------------------------------------------------------------------
p_respcheck : process (HCLK, HRESETn, Newtran)
variable PrintStr     : string (1 to 255);
begin
  if (HCLK'event and HCLK = '1' and Resplit /= '1' ) then
    if (HRESETn = '0') then
      Expresp <= "00";
    elsif (HRESP(1) = '1' and Oners = '1') then
      Expresp <= Rsbidpacket.resp;
    elsif (Buf2bidpacket.numcyc = 0 and HREADY/= '1') then
      Expresp <= Buf2bidpacket.resp;
    elsif (Pollstart = '1' and Delflagpoll = '1' and HREADY = '1') then 
      Expresp <= "00";
    elsif (HREADY = '1' and Bufbidpacket.numcyc = 0) then
      Expresp <= BufBidpacket.resp;
    elsif (Bufbidpacket.resp = "01") then
      if (Last = 1 and Val = 1) then
        Expresp <= Bufbidpacket.resp;
      elsif (Last = 2  and Val = 0) then 
        Expresp <= Bufbidpacket.resp;
      elsif (Last = 0) then
        Expresp <= Bufbidpacket.resp;
      else
        Expresp <= "00";
      end if; 
    elsif (Bufbidpacket.resp = "10" or Bufbidpacket.resp = "11") then
      if (Last = 2 and Val = 0) then
        Expresp <= Bufbidpacket.resp;
      else
        Expresp <= "00";
      end if;
    else
      Expresp <= Bufbidpacket.resp;
    end if;
  elsif (Resplit = '1' and HCLK'event and HCLK = '1') then
    Expresp <= Rsbidpacket.resp;
  elsif (Rslast = '1' and HCLK'event and HCLK = '1') then
    Expresp <= Rsbidpacket.resp;
  elsif (Newtran'event and Newtran = '1' and Pollend /= '1') then
    Expresp <= Bufbidpacket.resp;
  elsif (HRESETn'event and HRESETn = '1' and Resetstrd = '1') then   
    Expresp <= "00";
  end if;
end process p_respcheck;

-- ---------------------------------------------------------------------
-- Response checking 
-- ---------------------------------------------------------------------
p_respcall : process (HCLK)
begin
  if (HCLK'event and HCLK = '1' and Resetstrd /= '0' and Resetover and 
      Rsidle /= '1' and HREADY = '1') then
    if (Resplit = '1' or Rsdone = '1') then
        Response(HaltOnMismatch, Rsbidpacket.tag, Rsbidpacket.addr,
                 Expresp, HRESP, Rsbidpacket.numcyc, HREADY,
                 Rsbidpacket.suppmsg);
    else
        Response(HaltOnMismatch, Bufbidpacket.tag, Bufbidpacket.addr,
                 Expresp, HRESP, Bufbidpacket.numcyc, HREADY,
                 Bufbidpacket.suppmsg);
    end if;
  elsif (HCLK'event and HCLK = '1' and Resetstrd /= '0' and
         Resetover and 
         Rsidle = '1' and HREADY = '1') then
      Response(HaltOnMismatch, Bufbidpacket.tag, Bufbidpacket.addr,
               "00", HRESP, Bufbidpacket.numcyc, HREADY,
               Bufbidpacket.suppmsg );
  end if;
end process p_respcall; 

-- ---------------------------------------------------------------------
-- Counter for the number of wait states in the burst
-- Loaded when a new transfer occurs 
-- ---------------------------------------------------------------------
p_WSCount : process (HCLK)
-- ---------------------------------------------------------------------
-- Variable declarations
-- ---------------------------------------------------------------------
variable PrintStr     : string (1 to 255);
-- used to flash the error message during simulation
-- ---------------------------------------------------------------------
begin
  if (HCLK'event and HCLK = '1') then
    if (HREADY = '1') then
      WSCount <= (others => '0');
    elsif (WSCount < to_stdlogicvector(X"FFFFFFFF") and
          (HREADY = '0')) then
      WSCount <= (unsigned(WSCount) + 1);
      if ((unsigned(WSCount) = MaxWaitState) and HREADY = '0') then
        fprint(printstr,
               "%s:WSCLIMIT : Wait states exceeded buswatch limit %s",
               to_string(now), to_string(MaxWaitState));
        assert false
        report printstr
        severity warning;
      end if;
    end if;
  end if;
end process p_WSCount;
 
-- ---------------------------------------------------------------------
-- Counter for the number of beats in the burst
-- Loaded when a new transfer occurs or when rsidle is high and a new
-- burst starts in the case of split and retry cycles 
-- ---------------------------------------------------------------------
p_burstcount : process (HCLK)
begin
  if (HCLK'event and HCLK = '1' and (Newtran = '1' or
      Rsidle = '1' )) then
    if (iHTRANS = "00" or iHTRANS = "10" or HRESETn = '0') then
        Beatcount <= "00001";
    elsif (iHTRANS = "11" or 
          (Beatcount >= "00100" and iHTRANS = "01")) and Rsidle = '0' 
           and (HRESETn /= '0') then
      Beatcount <= (unsigned(Beatcount) + 1);
    end if;
  end if;
end process p_burstcount;

-- ---------------------------------------------------------------------
-- Checker to indicate that the Beatcount is exceeded for a burst
-- ---------------------------------------------------------------------
p_burstcheck : process (HCLK)
begin
  if (HCLK'event and HCLK = '1') then
    DelHBURST <= iHBURST;
    if (DelHBURST(2) = '1' and iDelHTRANS /= '0' ) then
      if (DelHBURST(1) = '0' and Beatcount > "01000") then
        ReportExtra(8, Buf2bidpacket.addr, Buf2bidpacket.tag);
      elsif (DelHBURST(1) = '1' and Beatcount > "10000") then
        ReportExtra(16, Buf2bidpacket.addr, Buf2bidpacket.tag);
      end if;
    else 
      if (DelHBURST(1) = '1' and Beatcount > "00100" and 
          iDelHTRANS /= '0') then
        ReportExtra(4, Buf2bidpacket.addr, Buf2bidpacket.tag);
      end if;
    end if;
  end if;
end process p_burstcheck;    

-- ---------------------------------------------------------------------
-- HREADY check for numcyc > 0
-- ---------------------------------------------------------------------
p_hreadycheck : process (HCLK)
-- ---------------------------------------------------------------------
-- Variable declarations
-- ---------------------------------------------------------------------
variable PrintStr     : string (1 to 255);
-- used to flash the error message during simulation
-- ---------------------------------------------------------------------
begin
  if (HCLK'event and HCLK = '1' and Last > 1 and 
       HREADY = '1') then
    fprint(printstr,
           "%s :ERRNC : HREADY asserted when wait-state(HREADY LOW) is"
           & " expected",
           to_string(now));
    assert false
    report printstr 
    severity error;
  end if;
end process p_hreadycheck;
 
-- ---------------------------------------------------------------------
-- Counter for re-issue of a numcyc = 0 command
-- ---------------------------------------------------------------------
p_count_reissue : process (HCLK, Newtran)
begin 
  if (Newtran = '1' or HREADY = '1' or 
     (Resplit = '1' and Idledone)) then
    Count <= 0;
  elsif (HCLK'event and HCLK = '1' and Last = 0 and HREADY /= '1') then
    Count <= Count + 1;
  end if;
end process p_count_reissue;

-- ---------------------------------------------------------------------
-- Message to indicate that a numcyc zero limit is exceeded
-- ---------------------------------------------------------------------
p_limcount_max : process (HCLK)
-- ---------------------------------------------------------------------
-- Variable declarations
-- ---------------------------------------------------------------------
variable PrintStr     : string (1 to 255);
-- used to flash the error message during simulation
-- ---------------------------------------------------------------------
begin
  if (HCLK'event and HCLK = '1' and (Maxflag or (Maxflagpoll = TRUE and 
      delflagpoll = '0')) and HRESP /= "10" and HRESP /= "11") then
    fprint(printstr,
           "%s :WARNRE : Maximum limit reached for number of reissues"
           & " in a numcycle zero command", 
           to_string(now));
  assert false
  report printstr 
  severity warning;
  end if;
end process p_limcount_max;

-- ---------------------------------------------------------------------
-- Message to indicate that the limit for the re-issue of a retry/split 
-- transfer is reached
-- ---------------------------------------------------------------------
p_rslimcount_max : process (HCLK)
-- ---------------------------------------------------------------------
-- Variable declarations
-- ---------------------------------------------------------------------
variable PrintStr     : string (1 to 255);
-- used to flash the error message during simulation
-- ---------------------------------------------------------------------
begin
  if (HCLK'event and HCLK = '1' and Rsflag and Rsdone = '1' and 
      (HRESP = "10" or HRESP = "11") and Oners /= '1') then
    fprint(printstr,"%s :WARNRSRE : Maximum limit for number of "
           & "retry/split reissues reached TAG : %s",
           to_string(now),
           Rsbidpacket.tag);
    assert false
    report printstr 
    severity warning;
  end if;
end process p_rslimcount_max;

-- ---------------------------------------------------------------------
-- HREADY check for the last cycle of a read or write
-- ---------------------------------------------------------------------
p_hready_check : process (HCLK)
-- ---------------------------------------------------------------------
-- Variable declarations
-- ---------------------------------------------------------------------
variable PrintStr     : string (1 to 255);
-- used to flash the error message during simulation
-- ---------------------------------------------------------------------
begin
  if (HCLK'event and HCLK = '1' and Nextissue = '1' and
      HREADY /= '1' and 
     (HRESP /= "10" and HRESP /= "11")) then
    if (iDelHWRITE = '1') then
      fprint(printstr,"%s :ERRRDYW : HREADY not asserted on expected "
             & " num_cyc clock cycle during write transfer", 
           to_string(now)); 
      assert false
      report printstr 
      severity error; 
    elsif (iDelHWRITE = '0') then
      fprint(printstr,"%s :ERRRDYR : HREADY not asserted on expected "
             & "num_cyc clock cycle during read transfer",
           to_string(now));
      assert false
      report printstr 
      severity error;
    end if;
  end if;
end process p_hready_check;

-- ---------------------------------------------------------------------
-- HREADY check if asserted prior to the last cycle of a read or write
-- ---------------------------------------------------------------------
p_hreadyprior_check : process (HCLK)
-- ---------------------------------------------------------------------
-- Variable declarations
-- ---------------------------------------------------------------------
variable PrintStr     : string (1 to 255);
-- used to flash the error message during simulation
-- ---------------------------------------------------------------------
begin
  if (HCLK'event and HCLK = '1' and Nextissue = '1' and (Val /= 1 and 
      Last /= 1) and Buf2bidpacket.numcyc /= 0 and (HRESP /= "10" and 
      HRESP /= "11")) then
    if (iDelHWRITE = '1') then
      fprint(printstr,"%s :WARNDYW : HREADY asserted prior to expected "
             & "num_cyc clock cycle during write transfer",
           to_string(now));
      assert false
      report printstr 
      severity error;
    elsif (iDelHWRITE = '0') then
      fprint(printstr,"%s :WARNDYR : HREADY asserted prior to expected "
             & "num_cyc clock cycle during read transfer",
           to_string(now));
      assert false
      report printstr 
      severity error;
    end if;
  end if;
end process p_hreadyprior_check;

-- ---------------------------------------------------------------------
-- Signal to indicate a retry/split transfer in progress
-- ---------------------------------------------------------------------
p_retrysplit : process (HCLK)
begin
  if (HCLK = '1' and HCLK'event and (HRESP = "10" or HRESP = "11")
      and Rsdone /= '1' and Rslast /= '1' and Oners /= '1') then
    Resplit <= '1';
  elsif (Rsidle /= '1' and HREADY = '1' and (HRESP = "00" or
         HRESP = "01" or (Rsflag and Oners /= '1'))) then 
    Resplit <= '0';
  end if;
end process p_retrysplit;

-- ---------------------------------------------------------------------
-- Signal to indicate idle cycles between retry/split transfers in
-- progress
-- ---------------------------------------------------------------------
p_retspl_idle : process (HCLK)
begin
  if (HCLK'event and HCLK = '1') then
    if ((Resplit = '1' or Rsflag) and iHTRANS = "00" and
         HREADY = '1' and ((Rsnextpacket.trans /= "00"  and
        (HRESP = "10" or HRESP = "11")) or
         Rsnextpacket.trans /= "XX")) then
      Rsidle <= '1';
    elsif (iHTRANS /= "00") then
      Rsidle <= '0';
    end if;
  end if;
end process p_retspl_idle;

-- ---------------------------------------------------------------------
-- Signal to indicate idle cycles when Poll transfer is in progress
-- ---------------------------------------------------------------------
p_poll_idle : process (HCLK)
begin
  if (HCLK'event and HCLK = '1') then
    if ((Pollstart = '1' or delPollstart = '1') and iHTRANS = "00" and 
         HREADY = '1') then
      Pidle <= '1';
    elsif (iHTRANS /= "00") then
      Pidle <= '0';
    end if;
  end if;
end process p_poll_idle;

-- ---------------------------------------------------------------------
-- Counter to count the number of idle cycles between retry/split
-- re-issues
-- ---------------------------------------------------------------------
p_idle_counter : process (HCLK)
begin
  if (HCLK'event and HCLK = '1') then
    if ((iHTRANS = "00" and (Resplit = '1')  and HREADY = '1') 
        or  (Oners = '1' and HREADY = '0')) then 
      Idlecount <= Idlecount + 1;
    else 
      Idlecount <= 0;
    end if;
  end if;
end process p_idle_counter;

-- ---------------------------------------------------------------------
-- Counter to count the number of retry/ split responses
-- ---------------------------------------------------------------------
p_rscounter : process (HCLK, Bidpacket)
begin
  if (Bidpacket'event) then
    Rscount <= 1;
  elsif (Resplit = '1' and HREADY='1' and 
         HCLK'event and HCLK = '1' and  Rsidle = '1' and 
         iHTRANS /= "00") then
    Rscount <= Rscount + 1;
  end if;
end process p_rscounter;

end behavioural;

-- --============================== End ==============================--
