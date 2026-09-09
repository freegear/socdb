--  --========================================================================--
--  This confidential and proprietary software may be used only as
--  authorised by a licensing agreement from ARM Limited
--    (C) COPYRIGHT 1998-2001 ARM Limited
--        ALL RIGHTS RESERVED
--  The entire notice above must be reproduced on all authorised
--  copies and copies may only be made to the extent permitted
--  by a licensing agreement from ARM Limited.
--  
--  ----------------------------------------------------------------------------
--  Version and Release Control Information:
--  
--  File Name           : LatencyMonitor.vhd,v
--  File Revision       : 1.0
--  
--  Release Information : ADK_REL1v1
--  
--  ----------------------------------------------------------------------------
--  Purpose             : Monitors bus transfers
--                       
--  --========================================================================--

    
library ieee;
use     ieee.std_logic_1164.all;
use     std.textio.all;

entity LatencyMonitor is
  generic(
    ID : string := "AHBx"      -- AHB identity tag
    );
  port(
    HCLK       : in  std_logic;
    HRESETn    : in  std_logic;
    HWRITE     : in  std_logic;
    HTRANS     : in  std_logic_vector(1 downto 0);
    HSIZE      : in  std_logic_vector(2 downto 0);
    HBURST     : in  std_logic_vector(2 downto 0);
    HSEL       : in  std_logic; --  select line
    HMASTLOCK  : in  std_logic;
    HADDR      : in  std_logic_vector(31 downto 0);
    HWDATA     : in  std_logic_vector(31 downto 0);
    HREADY     : in  std_logic
 
    );

end LatencyMonitor;

architecture behavioural of LatencyMonitor is

--------------------------------------------------------------------------------
-- Constant and type declarations
--------------------------------------------------------------------------------
-- HTRANS transfer type signal encoding
  constant TRN_IDLE   : std_logic_vector(1 downto 0) := "00";
  constant TRN_BUSY   : std_logic_vector(1 downto 0) := "01";
  constant TRN_NONSEQ : std_logic_vector(1 downto 0) := "10";
  constant TRN_SEQ    : std_logic_vector(1 downto 0) := "11";

-- States
--  type states is (RESET, IDLE, STORE, INC);
  constant RESET  : std_logic_vector(1 downto 0) := "00";
  constant IDLE   : std_logic_vector(1 downto 0) := "01";
  constant STORE  : std_logic_vector(1 downto 0) := "10";
  constant INC    : std_logic_vector(1 downto 0) := "11";

  constant HB_SINGLE   : std_logic_vector(2 downto 0) := "000";
  constant HB_INCR     : std_logic_vector(2 downto 0) := "001";
  constant HB_WRAP4    : std_logic_vector(2 downto 0) := "010";
  constant HB_INCR4    : std_logic_vector(2 downto 0) := "011";
  constant HB_WRAP8    : std_logic_vector(2 downto 0) := "100";
  constant HB_INCR8    : std_logic_vector(2 downto 0) := "101";
  constant HB_WRAP16   : std_logic_vector(2 downto 0) := "110";
  constant HB_INCR16   : std_logic_vector(2 downto 0) := "111";

  constant HS_BYTE    : std_logic_vector(2 downto 0) := "000";
  constant HS_HWORD   : std_logic_vector(2 downto 0) := "001";
  constant HS_WORD    : std_logic_vector(2 downto 0) := "010";
  constant HS_2WORD   : std_logic_vector(2 downto 0) := "011";
  constant HS_4WORD   : std_logic_vector(2 downto 0) := "100";
  constant HS_8WORD   : std_logic_vector(2 downto 0) := "101";
  constant HS_HK  : std_logic_vector(2 downto 0) := "110";
  constant HS_1K      : std_logic_vector(2 downto 0) := "111";
  
--------------------------------------------------------------------------------
-- Signal declarations
--------------------------------------------------------------------------------


-- Transfer State machine signals
--  signal TState, TNextState  : states;

  signal TState : std_logic_vector(1 downto 0);
  signal TNextState : std_logic_vector(1 downto 0);
  
-- Integers for statistics purposes
  signal Waits : integer;
  signal Transfers : integer;
  signal Writes : integer;
  signal Reads : integer;
  signal TotalWaits : integer;
  signal NonSeq : integer;
  signal Seq : integer;
  signal WorstWaitR : integer; 
  signal WorstWaitRTransfer : integer;
  signal WorstWaitW : integer; 
  signal WorstWaitWTransfer : integer;
  signal BestWait : integer; 
  signal BestWaitTransfer : integer;
  
-- Transfer details registers
  signal ACRegEn   : std_logic;      -- Enable for address and control registers
  signal HaddrReg  : std_logic_vector(31 downto 0);
  signal HtransReg : std_logic_vector(1 downto 0);
  signal HwriteReg : std_logic;
  signal HsizeReg  : std_logic_vector(2 downto 0);
  signal HburstReg  : std_logic_vector(2 downto 0);

-- worst case transfer details
  signal HaddrWorstR  : std_logic_vector(31 downto 0);
  signal HtransWorstR : std_logic_vector(1 downto 0);
  signal HsizeWorstR  : std_logic_vector(2 downto 0);
  signal TimeWorstR : time := 0 ns;
  signal HaddrWorstW  : std_logic_vector(31 downto 0);
  signal HtransWorstW : std_logic_vector(1 downto 0);
  signal HsizeWorstW  : std_logic_vector(2 downto 0);
  signal TimeWorstW : time := 0 ns;  
  signal HaddrBest  : std_logic_vector(31 downto 0);
  signal HtransBest : std_logic_vector(1 downto 0);
  signal HwriteBest : std_logic;
  signal HsizeBest  : std_logic_vector(2 downto 0);
  signal TimeBest : time := 0 ns; 

-- Burst State machine signals
--  signal BState, BNextState : states;
  signal BState : std_logic_vector(1 downto 0);
  signal BNextState : std_logic_vector(1 downto 0);
  
-- burst type counters
  signal BurstLatency : integer;
  signal Bursts : integer;
  signal WBursts : integer;
  signal RBursts : integer;
  signal Singles : integer;
  signal INCRs : integer;
  signal WRAP4s : integer;
  signal INCR4s : integer;
  signal WRAP8s : integer;
  signal INCR8s : integer;
  signal WRAP16s : integer;
  signal INCR16s : integer;

  signal BurstTime : time := 0 ns;


  
-------------------------------------------------------------------------------
-- Worst case storage registers
  -----------------------------------------------------------------------------

  -- Worst Read Burst
  signal WorstRBTime : time;  
  signal WorstRBLat : integer; 
  signal WorstRBDetails : string(1 to 82);
  
  -- Worst Write Burst
  signal WorstWBTime : time;
  signal WorstWBLat : integer; 
  signal WorstWBDetails : string(1 to 82);

    -- Worst Single R Burst
  signal WorstSRTime : time;
  signal WorstSRLat : integer; 
  signal WorstSRDetails : string(1 to 82);
  
  -- Worst Single W Burst
  signal WorstSWTime : time;
  signal WorstSWLat : integer; 
  signal WorstSWDetails : string(1 to 82);

-- Worst INCR R Burst
  signal WorstIRTime : time;
  signal WorstIRLat : integer; 
  signal WorstIRDetails : string(1 to 82);

-- Worst INCR W Burst
  signal WorstIWTime : time;
  signal WorstIWLat : integer; 
  signal WorstIWDetails : string(1 to 82);

-- Worst WRAP4 R Burst
  signal WorstW4RTime : time;
  signal WorstW4RLat : integer; 
  signal WorstW4RDetails : string(1 to 82);

-- Worst WRAP4 W Burst
  signal WorstW4WTime : time;
  signal WorstW4WLat : integer; 
  signal WorstW4WDetails : string(1 to 82);

-- Worst INCR4 R Burst
  signal WorstI4RTime : time;
  signal WorstI4RLat : integer; 
  signal WorstI4RDetails : string(1 to 82);

-- Worst INCR4 W Burst
  signal WorstI4WTime : time;
  signal WorstI4WLat : integer; 
  signal WorstI4WDetails : string(1 to 82);

-- Worst WRAP8 R Burst
  signal WorstW8RTime : time;
  signal WorstW8RLat : integer; 
  signal WorstW8RDetails : string(1 to 82);
  
-- Worst WRAP8 W Burst
  signal WorstW8WTime : time;
  signal WorstW8WLat : integer; 
  signal WorstW8WDetails : string(1 to 82);
  
-- Worst INCR8 R Burst
  signal WorstI8RTime : time;
  signal WorstI8RLat : integer; 
  signal WorstI8RDetails : string(1 to 82);
  
-- Worst INCR8 W Burst
  signal WorstI8WTime : time;
  signal WorstI8WLat : integer; 
  signal WorstI8WDetails : string(1 to 82);
  
-- Worst WRAP16 R Burst
  signal WorstW16RTime : time;
  signal WorstW16RLat : integer; 
  signal WorstW16RDetails : string(1 to 82);
  
-- Worst WRAP16 W Burst
  signal WorstW16WTime : time;
  signal WorstW16WLat : integer; 
  signal WorstW16WDetails : string(1 to 82); 
  
-- Worst INCR16 R Burst
  signal WorstI16RTime : time;
  signal WorstI16RLat : integer; 
  signal WorstI16RDetails : string(1 to 82);
  
-- Worst INCR16 W Burst
  signal WorstI16WTime : time;
  signal WorstI16WLat : integer; 
  signal WorstI16WDetails : string(1 to 82);
  
-- AD State machine signals
--  signal ADState, ADNextState : states;
  signal ADState : std_logic_vector(1 downto 0);
  signal ADNextState : std_logic_vector(1 downto 0);
  signal ADCount : integer;
  signal AD : integer;

-- FDAT register
  signal FDAT : integer;  -- stores the value of the last non seq transfer

-- Broken Burst Signals

  signal TIB : integer;                 -- Transfers In Burst
  

-- Busy States indicate and count 
  signal Busys : std_logic;             -- indicates if busy states were present
  signal BusyCount : integer;           -- counts busy states inserted

  signal Lock : std_logic;              -- indicates if transfer is locked
  
--------------------------------------------------------------------------------
-- Trans2Char converts the Trans signal to a character
--------------------------------------------------------------------------------

  function Trans2Char (Trans : std_logic_vector(1 downto 0)) return character is
    variable char : character;
  begin 
    if Trans = TRN_NONSEQ then char := 'N';
    elsif Trans = TRN_SEQ then char :='S';
    else char := 'X';
    end if;
    return char;
  end Trans2Char;


--------------------------------------------------------------------------------
-- Write2Char converts the Write signal to a character
--------------------------------------------------------------------------------
 
  function Write2Char (Write : std_logic) return character is
  variable char : character;
  begin
    case Write is
      when '0' => char := 'R';
      when '1' => char := 'W';
      when others => char := 'X';
    end case;
    return char;
  end Write2Char;

--------------------------------------------------------------------------------
-- Size2Str converts the Size signal to a string
--------------------------------------------------------------------------------

  function Size2Str (Size : std_logic_vector(2 downto 0)) return string is

  variable str : string(1 to 4);
  begin
    case Size is
      when HS_BYTE  => str := "BYTE";
      when HS_HWORD => str := "HWRD";
      when HS_WORD  => str := "WORD";
      when HS_2WORD => str := "2WRD";
      when HS_4WORD => str := "4WRD";
      when HS_8WORD => str := "8WRD";
      when HS_HK    => str := "HKBT";
      when HS_1K    => str := "KBIT";
      when others   => str := "XXXX";
    end case;
    return str;
  end Size2Str;

--------------------------------------------------------------------------------
-- Burst2Str converts the Burst signal to a string
--------------------------------------------------------------------------------

  function Burst2Str (Burst : std_logic_vector(2 downto 0)) return string is

  variable str : string(1 to 6);
  begin
    case Burst is
      when HB_SINGLE => str := "Single";
      when HB_INCR => str := "INCR  ";
      when HB_WRAP4 => str := "WRAP4 ";
      when HB_INCR4 => str := "INCR4 ";
      when HB_WRAP8 => str := "WRAP8 ";
      when HB_INCR8 => str := "INCR8 ";
      when HB_WRAP16 => str := "WRAP16";
      when HB_INCR16 => str := "INCR16";
      when others => str := "XXXXXX";
    end case;
    return str;
  end Burst2Str;

 
--------------------------------------------------------------------------------
-- Int2HexChar converts an integer (0-15) to a hex char
--------------------------------------------------------------------------------

  function Int2HexChar (Int : integer) return character is

  variable Char : character;
  begin
    if Int<16 then  
      if Int<10 then
        Char := character'val(Int + 48);
      else
        Char := character'val(Int + 55);  
      end if;
    else
      Char := 'X';
    end if; 
    return Char;

  end Int2HexChar;


--------------------------------------------------------------------------------
-- Int2HexStr converts an integer to a hex string
--------------------------------------------------------------------------------

  function Int2HexStr (Int : integer) return string is

  variable str : string(1 to 8);
  begin
    if Int<0 then
      str := "Negative";
    else
      str(1) := Int2HexChar((Int / 268435456) MOD 16);
      str(2) := Int2HexChar((Int / 16777216) MOD 16);
      str(3) := Int2HexChar((Int / 1048576) MOD 16);  
      str(4) := Int2HexChar((Int / 65536) MOD 16);
      str(5) := Int2HexChar((Int / 4096) MOD 16);
      str(6) := Int2HexChar((Int / 256) MOD 16);
      str(7) := Int2HexChar((Int / 16) MOD 16);
      str(8) := Int2HexChar(Int MOD 16);
    end if;
    return str;

  end Int2HexStr;


--------------------------------------------------------------------------------
-- Nibble2Char converts a 4 bit std_logic_vector to a character
--------------------------------------------------------------------------------

  function Nibble2Char (Nibble : std_logic_vector(3 downto 0)) return character is

  variable char : character;
  begin
    case Nibble is
      when "0000" => char := '0';
      when "0001" => char := '1';
      when "0010" => char := '2';
      when "0011" => char := '3';
      when "0100" => char := '4';
      when "0101" => char := '5';
      when "0110" => char := '6';
      when "0111" => char := '7';
      when "1000" => char := '8';
      when "1001" => char := '9';
      when "1010" => char := 'A';
      when "1011" => char := 'B';
      when "1100" => char := 'C';
      when "1101" => char := 'D';
      when "1110" => char := 'E';
      when "1111" => char := 'F';
      when others => char := 'X';
    end case;
    return char;
  end Nibble2Char;

--------------------------------------------------------------------------------
-- Addr2Str converts a 32 bit std_logic_vector to an 8 character string
--------------------------------------------------------------------------------

  function Addr2Str (Addr : std_logic_vector(31 downto 0)) return string is
  variable Str : string(1 to 8);
  begin
    Str(1) := Nibble2Char(Addr(31 downto 28));
    Str(2) := Nibble2Char(Addr(27 downto 24));
    Str(3) := Nibble2Char(Addr(23 downto 20));
    Str(4) := Nibble2Char(Addr(19 downto 16)); 
    Str(5) := Nibble2Char(Addr(15 downto 12));
    Str(6) := Nibble2Char(Addr(11 downto 8));
    Str(7) := Nibble2Char(Addr(7 downto 4));
    Str(8) := Nibble2Char(Addr(3 downto 0)); 
    return str;
  end Addr2Str;


-------------------------------------------------------------------------------
-- TIB2Str works out if the burst was broken using TIB and HburstReg
-------------------------------------------------------------------------------

  function TIB2Str (TIB : integer; HBurst : std_logic_vector(2 downto 0))
                                                             return string is
    variable str : string(1 to 2);
  begin
    case HBurst is
      when HB_SINGLE => if TIB = 1 then
                      str := "BC";
                    else
                      str := "BB";
                    end if;
      when HB_INCR =>   str := "BI";      -- INCR's have undefined burst length

      when HB_WRAP4 => if TIB = 4 then
                      str := "BC";
                    else
                      str := "BB";
                    end if;
      when HB_INCR4 => if TIB = 4 then
                      str := "BC";
                    else
                      str := "BB";
                    end if;
      when HB_WRAP8 => if TIB = 8 then
                      str := "BC";
                    else
                      str := "BB";
                    end if;
      when HB_INCR8 => if TIB = 8 then
                      str := "BC";
                    else
                      str := "BB";
                    end if;
      when HB_WRAP16 => if TIB = 16 then
                      str := "BC";
                    else
                      str := "BB";
                    end if;
      when HB_INCR16 => if TIB = 16 then
                      str := "BC";
                    else
                      str := "BB";
                    end if;
      when others => str := "XX";  
    end case;
    return str;
  end TIB2Str;
  
--------------------------------------------------------------------------------
-- Busys2Str converts the Busys signal to a string
--------------------------------------------------------------------------------
 
  function Busys2Str (Busys : std_logic) return string is
  variable str : string(1 to 5);
  begin
    case Busys is
      when '0' => str := "CLEAN";
      when '1' => str := "BUSYS";
      when others => str := "XXXXX";
    end case;
    return str;
  end Busys2Str;
  
--------------------------------------------------------------------------------
-- Lock2Str converts the Lock signal to a string
--------------------------------------------------------------------------------
 
  function Lock2Str (Lock : std_logic) return string is
  variable str : string(1 to 4);
  begin
    case Lock is
      when '0' => str := "OPEN";
      when '1' => str := "LOCK";
      when others => str := "XXXX";
    end case;
    return str;
  end Lock2Str;





  
-------------------------------------------------------------------------------
-- Beginning of main code
--------------------------------------------------------------------------------
begin

--------------------------------------------------------------------------------
-- Address and control registers
--------------------------------------------------------------------------------
-- Registers are used to store the address and control signals from the address
--  phase for use in the data phase of the transfer.
-- Only enabled when the HREADY input is HIGH and the module is addressed.

  ACRegEn <= HREADY and HSEL and HTRANS(1);

  p_ACRegSeq : process (HRESETn, HCLK)
  begin
    if (HRESETn = '0') then
      HaddrReg  <= (others => '0');
      HtransReg <= (others => '0');
      HwriteReg <= '0';
      HsizeReg  <= (others => '0');
      HburstReg <= (others => '0');
      
    elsif (HCLK'event and HCLK = '1') then
      if ACRegEn = '1' then
        HaddrReg  <= HADDR;
        HtransReg <= HTRANS;
        HwriteReg <= HWRITE;
        HsizeReg  <= HSIZE;
        HburstReg  <= HBURST;
      end if;
    end if;
  end process p_ACRegSeq;


-------------------------------------------------------------------------------
-- TStateSet the combinational process that determines the next state of the
-- LatencyMonitor transfer state machine
-----------------------------------------------------------------------------
  
  TStateSet : process(HTRANS, HSEL, TState, HREADY)
  begin
    TNextState <= TState;
    case TState is
      when RESET => TNextState <= IDLE;

      when IDLE => if HREADY = '0' then TNextState <= IDLE;
                   elsif ((HTRANS = TRN_NONSEQ or HTRANS = TRN_SEQ) and HSEL = '1') then
                     TNextState <= STORE; 
                   else
                     TNextState <= IDLE;
                   end if;

      when STORE => 
                    if HREADY = '0' then TNextState <= INC;
                    elsif ((HTRANS = TRN_NONSEQ or HTRANS = TRN_SEQ) and HSEL = '1') then
                      TNextState <= STORE; 
                    else
                      TNextState <= IDLE;
                    end if;

      when INC =>   if HREADY = '0' then TNextState <= INC;
                    elsif ((HTRANS = TRN_NONSEQ or HTRANS = TRN_SEQ) and HSEL = '1') then
                      TNextState <= STORE; 
                    else
                      TNextState <= IDLE;
                    end if;
      when others => TNextState <= IDLE;
    end case;    
  end process TStateSet;

-------------------------------------------------------------------------------
-- TStateChange implements the transfer state transition on rising clock edge
-------------------------------------------------------------------------------  
  
  TStateChange : process(HCLK, HRESETn)
  begin
    if HRESETn = '0' then
      TState <= RESET;
    elsif (HCLK'event and HCLK = '1') then
      TState <= TNextState;
    end if;
  end process TStateChange;

-------------------------------------------------------------------------------
-- WaitCount counts the number of waits for the current transfer
-------------------------------------------------------------------------------  
  
  WaitCount : process(HCLK)
  begin
    if (HCLK'event and HCLK = '1') then
      case TNextState is
        when RESET => Waits <= 0;
        when IDLE => Waits <= 0;
        when STORE => Waits <= 0;
        when INC => Waits <= Waits + 1;
        when others => Waits <= 0;
      end case;
    end if;
  end process WaitCount;

-------------------------------------------------------------------------------
-- TOutput outputs the raw transfer data to modelsim log and text file
-------------------------------------------------------------------------------  

  TOutput : process (HCLK)
    file Outfile  : text is out (ID & "_TransferLatency.txt"); -- output file
    variable L    : line;
    variable LL : line;
  begin
    if (HCLK'event and HCLK = '1') then
      if ((TState = STORE or TState = INC) and TNextState /= INC) then
        -- this condition indicates that the transfer is completed
        write (L, NOW, RIGHT, 14, NS);
        write (L,(" " & Int2HexStr(Transfers+1) & " " & Addr2Str(HaddrReg)
                  & " " & Write2Char(HwriteReg) & " " &
                  Trans2Char(HtransReg) & " " & Size2Str(HsizeReg) &
                  " " & Int2HexStr(Waits))); 

        -- file output
        writeline (Outfile, L);

      end if;
    end if;
  end process TOutput;

----------------------------------------------------------------
-- TStats a process to gather transfer statistics
----------------------------------------------------------------

  TStats : process (HCLK, HRESETn)
    variable L : line;
  begin 
    if HRESETn = '0' then
      Transfers <= 0;  -- initialize all counters on reset
      Reads <= 0;
      Writes <= 0;
      TotalWaits <= 0;
      NonSeq <= 0;
      Seq <= 0;
      WorstWaitR <= 0;
      WorstWaitRTransfer <=0;
      HaddrWorstR  <= (others => '0');
      HtransWorstR <= (others => '0');
      HsizeWorstR  <= (others => '0');
      TimeWorstR   <= 0 ns;
      WorstWaitW <= 0;
      WorstWaitWTransfer <=0;
      HaddrWorstW  <= (others => '0');
      HtransWorstW <= (others => '0');
      HsizeWorstW  <= (others => '0');
      TimeWorstW   <= 0 ns;     
      BestWait <= 1000000;
      BestWaitTransfer <=0;
      HaddrBest  <= (others => '0');
      HtransBest <= (others => '0');
      HwriteBest <= 'X';
      HsizeBest  <= (others => '0');
      TimeBest   <= 0 ns;
      FDAT <= 0;
    else
      if (HCLK'event and HCLK = '1') then
        if ((TState = STORE or TState = INC) and TNextState /= INC) then
          -- Here all transfer details are registered and waits counted
          -- so any stats can be gathered to be output at the end
          Transfers <= Transfers + 1;
          TotalWaits <= TotalWaits + Waits;
          
          if HwriteReg = '1' then
            Writes <= Writes + 1;
          else
            Reads <= Reads + 1;
          end if;
          if HtransReg = "10" then
            NonSeq <= NonSeq + 1;
          else
            Seq <= Seq + 1;
          end if;

          if HwriteReg ='0' then
            if Waits > WorstWaitR then
              -- here a new worst case is identified so store and output
              WorstWaitR <= Waits;
              WorstWaitRTransfer <= Transfers;
              HaddrWorstR <= HaddrReg;
              HtransWorstR <= HtransReg;
              HsizeWorstR <= HsizeReg;
              TimeWorstR <= NOW;
              write(L,string'("********************   New Worst Case "));
              write(L,string'("  ********************"));
              writeline(OUTPUT, L);
              write(L,("WT      " & ID & " New Worst Case Read Latency  = "));
              write(L,string'(Int2HexStr(Waits)& "      **"));
              writeline(OUTPUT, L);             
              write(L,string'("WT   "));
              write(L, NOW, RIGHT, 14, NS);
              write(L,(" " & Int2HexStr(Transfers+1) & " " & Addr2Str(HaddrReg)
                       & " " & Write2Char(HwriteReg) & " " &
                       Trans2Char(HtransReg) & " " & Size2Str(HsizeReg) &
                       " " & Int2HexStr(Waits) & "   **")); 
              writeline(OUTPUT, L);
              write(L,string'("**************************************"));
              write(L,string'("**********************"));
              writeline(OUTPUT, L);  
           end if;
          else
            if Waits > WorstWaitW then
              -- here a new worst case is identified so store and output
              WorstWaitW <= Waits;
              WorstWaitWTransfer <= Transfers;
              HaddrWorstW <= HaddrReg;
              HtransWorstW <= HtransReg;
              HsizeWorstW <= HsizeReg;
              TimeWorstW <= NOW;
              write(L,string'("********************   New Worst Case "));
              write(L,string'("  ********************"));
              writeline(OUTPUT, L);
              write(L,("WT      " & ID & " New Worst Case Write Latency = "));
              write(L,string'(Int2HexStr(Waits)& "      **"));
              writeline(OUTPUT, L);             
              write(L,string'("WT   "));
              write(L, NOW, RIGHT, 14, NS);
              write(L,(" " & Int2HexStr(Transfers+1) & " " & Addr2Str(HaddrReg)
                       & " " & Write2Char(HwriteReg) & " " &
                       Trans2Char(HtransReg) & " " & Size2Str(HsizeReg) &
                       " " & Int2HexStr(Waits) & "   **")); 
              writeline(OUTPUT, L);
              write(L,string'("**************************************"));
              write(L,string'("**********************"));
              writeline(OUTPUT, L);  
            end if;          
          end if;

          if Waits < BestWait then
              BestWait <= Waits;
              BestWaitTransfer <= Transfers;
              HaddrBest <= HaddrReg;
              HtransBest <= HtransReg;
              HwriteBest <= HwriteReg;
              HsizeBest <= HsizeReg;
              TimeBest <= NOW;
              write(L,string'("********************   New Best Case  "));
              write(L,string'("  ********************"));
              writeline(OUTPUT, L);
              write(L,("BT      " & ID & " New Best Case Latency        = "));
              write(L, (Int2HexStr(Waits)& "      **"));
              writeline(OUTPUT, L);
              write(L,string'("BT   "));
              write(L, NOW, RIGHT, 14, NS);
              write(L,(" " & Int2HexStr(Transfers+1) & " " & Addr2Str(HaddrReg)
                       & " " & Write2Char(HwriteReg) & " " &
                       Trans2Char(HtransReg) & " " & Size2Str(HsizeReg) &
                       " " & Int2HexStr(Waits) & "   **")); 
              writeline(OUTPUT, L);
              write(L,string'("**************************************"));
              write(L,string'("**********************"));
              writeline(OUTPUT, L);  
          end if;

          -- if the transfer was non sequential store transfer latency as FDAT
          if HtransReg = TRN_NONSEQ then
            FDAT <= Waits;
          end if;

          
        end if;
      end if;
    end if;
  end process Tstats;

-------------------------------------------------------------------------------
-- Regular output of Transfer statistics when Transfers count gets to 256
-------------------------------------------------------------------------------
  
  TRegularOutput : process (Transfers)
    variable L : line;
  begin 
      if (Transfers > 0 and (Transfers MOD 256 = 0)) then
         -- output stats every 100 transfers
        write(L,string'("TS******************  "& ID));
        write(L,string'(" Statistics   ********************"));
        writeline(OUTPUT, L); 
        write(L,string'("TS   Time = "));
        write(L, NOW, RIGHT, 14, NS);                    
        write(L,string'("   Total Transfers = " & Int2HexStr(Transfers)));
        write(L,string'("   **"));
        writeline(OUTPUT, L); 
        write(L,string'("**------------------------------------------------"));
        write(L,string'("--------**"));
        writeline(OUTPUT, L); 
        write(L,string'("TS   Reads   = " & Int2HexStr(Reads)));
        write(L,("      Sequential      = " & Int2HexStr(Seq) & "   **"));
        writeline(OUTPUT, L); 
        write(L,string'("TS   Writes  = " & Int2HexStr(Writes)));
        write(L,("      Non-Sequential  = " & Int2HexStr(NonSeq) & "   **"));
        writeline(OUTPUT, L); 
        write(L,string'("**------------------------------------------------"));
        write(L,string'("--------**"));
        writeline(OUTPUT, L); 
        write(L,"**        " & ID & " Worst Case Read Latency  = ");
        write(L,string'(Int2HexStr(WorstWaitR)& "        **"));
        writeline(OUTPUT, L);
        write(L,string'("**   "));
        write(L, TimeWorstR, RIGHT, 14, NS);
        write(L,(" " & Int2HexStr(WorstWaitRTransfer+1) & " "));
        write(L,(Addr2Str(HaddrWorstR) & " R " & Trans2Char(HtransWorstR)));
        write(L,(" " & Size2Str(HsizeWorstR) & " " & Int2HexStr(WorstWaitR)));
        write(L,string'("   **")); 
        writeline(OUTPUT, L);
        write(L,string'("**------------------------------------------------"));
        write(L,string'("--------**"));
        writeline(OUTPUT, L);
        write(L,"**        " & ID & " Worst Case Write Latency = ");
        write(L,(Int2HexStr(WorstWaitW)& "        **"));
        writeline(OUTPUT, L);
        write(L,string'("**   "));
        write(L, TimeWorstW, RIGHT, 14, NS);
        write(L,(" " & Int2HexStr(WorstWaitWTransfer+1) & " "));
        write(L,(Addr2Str(HaddrWorstW) & " W " & Trans2Char(HtransWorstW)));
        write(L,(" " & Size2Str(HsizeWorstW) & " " & Int2HexStr(WorstWaitW)));
        write(L,string'("   **")); 
        writeline(OUTPUT, L);
        write(L,string'("**------------------------------------------------"));
        write(L,string'("--------**"));
        writeline(OUTPUT, L);
        write(L,"**        " & ID & " Best Case Latency        = ");
        write(L,(Int2HexStr(BestWait)& "        **"));
        writeline(OUTPUT, L);
        write(L,string'("**   "));
        write(L, TimeBest, RIGHT, 14, NS);
        write(L,(" " & Int2HexStr(BestWaitTransfer+1) & " "));
        write(L,(Addr2Str(HaddrBest) & " " & Write2Char(HwriteBest) & " "));
        write(L,(Trans2Char(HtransBest) & " " & Size2Str(HsizeBest)));
        write(L,(" " & Int2HexStr(BestWait) & "   **")); 
        writeline(OUTPUT, L);
        write(L,string'("**------------------------------------------------"));
        write(L,string'("--------**"));
        writeline(OUTPUT, L);               
        write(L,string'("TS                 Total Waits = "));
        write(L,(Int2HexStr(TotalWaits) & "                 **"));
        writeline(OUTPUT, L); 
        write(L,string'("**************************************************"));
        write(L,string'("**********"));
        writeline(OUTPUT, L);       
          
      end if;
  end process TRegularOutput;

  
-------------------------------------------------------------------------------  
-------------------------------------------------------------------------------
  -- Burst Latency Section
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------


-------------------------------------------------------------------------------
-- BStateSet the combinational process that determines the next state of the
-- LatencyMonitor burst state machine
-----------------------------------------------------------------------------
  
  BStateSet : process(HTRANS, HSEL, BState, HREADY)
  begin
    BNextState <= BState;
    case BState is
      when RESET => BNextState <= IDLE;

      when IDLE => if (HTRANS = TRN_NONSEQ and HSEL = '1' and HREADY = '1') then
                     BNextState <= STORE; 
                   else
                     BNextState <= IDLE;
                   end if;

      when STORE => if (HREADY = '0' or HTRANS = TRN_SEQ or HTRANS = TRN_BUSY) then
                        BNextState <= INC;
                    elsif (HTRANS = TRN_NONSEQ and HSEL = '1') then
                      BNextState <= STORE; 
                    else
                      BNextState <= IDLE;
                    end if;

      when INC =>   if (HREADY = '0' or HTRANS = TRN_SEQ or HTRANS = TRN_BUSY) then 
                         BNextState <= INC;
                    elsif (HTRANS = TRN_NONSEQ and HSEL = '1') then
                      BNextState <= STORE; 
                    else
                      BNextState <= IDLE;
                    end if;
      when others => BNextState <= IDLE;
    end case;
  end process BStateSet;

-------------------------------------------------------------------------------
-- BStateChange implements the burst state transition on the rising clock edge
-------------------------------------------------------------------------------  
  
  BStateChange : process(HCLK, HRESETn)
  begin
    if HRESETn = '0' then
      BState <= RESET;
    elsif (HCLK'event and HCLK = '1') then
      BState <= BNextState;
    end if;
  end process BStateChange;

-------------------------------------------------------------------------------
-- BurstLat counts the number of cycles it takes for the burst to complete
-------------------------------------------------------------------------------  
  
  BurstLat : process(HCLK)
  begin
    if (HCLK'event and HCLK = '1') then
      case BNextState is
        when RESET => BurstLatency <= 0;
        when IDLE => BurstLatency <= 0;
        when STORE => BurstLatency <= 1;
        when INC => BurstLatency <= BurstLatency + 1;
        when others => BurstLatency <= 0;
      end case;
    end if;
  end process BurstLat;

----------------------------------------------------------------
-- BStats a process to gather burst statistics
----------------------------------------------------------------

  BStats : process (HCLK, HRESETn)
    variable L : line;
    variable Details    : string(1 to 82);
    variable Blank : string(1 to 82);
    variable Title : string(1 to 100);
    variable Stars : string(1 to 100);
    variable Line2A : string(1 to 42);
 



    
    variable TrueFDAT : integer;  -- required because of single transfer bursts    
  begin 
    if HRESETn = '0' then
      Bursts  <= 0;  -- initialize all frequency counters on reset
      RBursts <= 0;
      WBursts <= 0;
      Singles <= 0;
      INCRs   <= 0;
      WRAP4s  <= 0;
      INCR4s  <= 0;
      WRAP8s  <= 0;
      INCR8s  <= 0;
      WRAP16s <= 0;
      INCR16s <= 0;

      -- initialise all 18 sets of worst case registers

      WorstRBTime <= 0 ns; 
      WorstWBTime <= 0 ns; 
      WorstSRTime <= 0 ns; 
      WorstSWTime <= 0 ns; 
      WorstIRTime <= 0 ns; 
      WorstIWTime <= 0 ns; 
      WorstW4RTime <= 0 ns; 
      WorstW4WTime <= 0 ns; 
      WorstI4RTime <= 0 ns; 
      WorstI4WTime <= 0 ns; 
      WorstW8RTime <= 0 ns; 
      WorstW8WTime <= 0 ns; 
      WorstI8RTime <= 0 ns; 
      WorstI8WTime <= 0 ns; 
      WorstW16RTime <= 0 ns; 
      WorstW16WTime <= 0 ns; 
      WorstI16RTime <= 0 ns; 
      WorstI16WTime <= 0 ns;
 
      WorstRBLat <= 0; 
      WorstWBLat <= 0; 
      WorstSRLat <= 0; 
      WorstSWLat <= 0; 
      WorstIRLat <= 0; 
      WorstIWLat <= 0; 
      WorstW4RLat <= 0; 
      WorstW4WLat <= 0; 
      WorstI4RLat <= 0; 
      WorstI4WLat <= 0; 
      WorstW8RLat <= 0; 
      WorstW8WLat <= 0; 
      WorstI8RLat <= 0; 
      WorstI8WLat <= 0; 
      WorstW16RLat <= 0; 
      WorstW16WLat <= 0; 
      WorstI16RLat <= 0; 
      WorstI16WLat <= 0;

      Blank := "                  No burst of this type has occured" &
                                            "                               ";
      WorstRBDetails <= Blank; 
      WorstWBDetails <= Blank;
      WorstSRDetails <= Blank;
      WorstSWDetails <= Blank;
      WorstIRDetails <= Blank;
      WorstIWDetails <= Blank;
      WorstW4RDetails <= Blank;
      WorstW4WDetails <= Blank;
      WorstI4RDetails <= Blank;
      WorstI4WDetails <= Blank;
      WorstW8RDetails <= Blank;
      WorstW8WDetails <= Blank;
      WorstI8RDetails <= Blank;
      WorstI8WDetails <= Blank;
      WorstW16RDetails <= Blank;
      WorstW16WDetails <= Blank;
      WorstI16RDetails <= Blank;
      WorstI16WDetails <= Blank;
  

    else
      if (HCLK'event and HCLK = '1') then
        if ((BState = STORE or BState = INC) and BNextState /= INC) then
          -- Here all burst details are registered and waits counted
          -- so any stats can be gathered to be output at the end

          -- first frequency counts
          Bursts <= Bursts + 1;          
          if HwriteReg = '1' then
            WBursts <= WBursts + 1;
          else
            RBursts <= RBursts + 1;
          end if;

          case HburstReg is
            when HB_SINGLE => Singles <= Singles + 1 ;
            when HB_INCR => INCRs <= INCRs + 1;
            when HB_WRAP4 => WRAP4s <= WRAP4s + 1;
            when HB_INCR4 => INCR4s <= INCR4s + 1;
            when HB_WRAP8 => WRAP8s <= WRAP8s + 1;
            when HB_INCR8 => INCR8s <= INCR8s + 1;
            when HB_WRAP16 => WRAP16s <= WRAP16s + 1;
            when HB_INCR16 => INCR16s <= INCR16s + 1;
            when others => null;
          end case;

          -- followed by worst cases
          
          -- compile the current burst details to a line
          if HtransReg = TRN_NONSEQ then
            TrueFDAT := Waits;            -- if the burst was a single transfer
          else          
            TrueFDAT := FDAT;
          end if;
          
          
          Details := (" " & Int2HexStr(Bursts+1) & " " & Addr2Str(HaddrReg) &
               " " & Write2Char(HwriteReg) & " " & Size2Str(HsizeReg) &
               " " & Burst2Str(HburstReg) & " " & Int2HexStr(BurstLatency) &
               " " & Int2HexStr(AD) & " " & Int2HexStr(TrueFDAT) &
               " " & TIB2Str(TIB, HburstReg) & " " & Busys2Str(Busys) &
               " " & Int2HexStr(BusyCount) & " " & Lock2Str(Lock));
         

          -- compile the title line
          Title := ("******************************" &
                    "      New Worst Case Burst Latency      " &
                    "******************************");
        
          -- compile the stars line
          Stars := ("******************************" &
                    "****************************************" &
                    "******************************");
         
          Line2A := ("WB                    " & ID & " New worst case ");  
   
          
          -- Check overall worst case read and write
          if HwriteReg = '0' then
            if BurstLatency > WorstRBLat then
              WorstRBTime <= NOW;
              WorstRBLat <= BurstLatency;
              WorstRBDetails <= Details;
              write(L, Title);
              writeline(OUTPUT, L);
              write(L, Line2A);
              write(L, ("Read burst latency = " & Int2HexStr(BurstLatency)));
              write(L, string'("                           **"));
              writeline(OUTPUT, L);
              write(L, string'("WB"));
              write(L, NOW, RIGHT, 14, NS); 
              write(L, Details & "**");
              writeline(OUTPUT, L);
              write(L, Stars);
              writeLine(OUTPUT, L);
            end if;
          else  
            if BurstLatency > WorstWBLat then
              WorstWBTime <= NOW;
              WorstWBLat <= BurstLatency;
              WorstWBDetails <= Details;
              write(L, Title);
              writeline(OUTPUT, L);
              write(L, Line2A);
              write(L, ("Write burst latency = " & Int2HexStr(BurstLatency)));
              write(L, string'("                          **"));
              writeline(OUTPUT, L);
              write(L, string'("WB"));
              write(L, NOW, RIGHT, 14, NS); 
              write(L, Details & "**");
              writeline(OUTPUT, L);
              write(L, Stars);
              writeLine(OUTPUT, L);
            end if;
          end if;
          
          
          -- Decide which type of burst (1 of 16) has occured and check worst case
          if HwriteReg = '0' then
            case HburstReg is
              when HB_SINGLE => if BurstLatency > WorstSRLat then
                  WorstSRLat <= BurstLatency;
                  WorstSRTime <= NOW;
                  WorstSRDetails <= Details;
                  write(L, Title);
                  writeline(OUTPUT, L);
                  write(L, Line2A);
                  write(L, string'("Read Single burst latency = "));
                  write(L,(Int2HexStr(BurstLatency) & "                    **"));
                  writeline(OUTPUT, L);
                  write(L, string'("WB"));
                  write(L, NOW, RIGHT, 14, NS); 
                  write(L, Details & "**");
                  writeline(OUTPUT, L);
                  write(L, Stars);
                  writeLine(OUTPUT, L);
                end if;
              when HB_INCR => if BurstLatency > WorstIRLat then
                  WorstIRTime <= NOW;
                  WorstIRLat <= BurstLatency;
                  WorstIRDetails <= Details;
                  write(L, Title);
                  writeline(OUTPUT, L);
                  write(L, Line2A);
                  write(L,string'("Read INCR burst latency = "));
                  write(L,(Int2HexStr(BurstLatency)));
                  write(L,string'("                      **"));
                  writeline(OUTPUT, L);
                  write(L, string'("WB"));
                  write(L, NOW, RIGHT, 14, NS); 
                  write(L, Details & "**");
                  writeline(OUTPUT, L);
                  write(L, Stars);
                  writeLine(OUTPUT, L);  
                end if;
              when HB_WRAP4 => if BurstLatency > WorstW4RLat then
                  WorstW4RTime <= NOW;
                  WorstW4RLat <= BurstLatency;
                  WorstW4RDetails <= Details;
                  write(L, Title);
                  writeline(OUTPUT, L);
                  write(L, Line2A);
                  write(L, string'("Read WRAP4 burst latency = "));
                  write(L, Int2HexStr(BurstLatency));
                  write(L, string'("                     **"));
                  writeline(OUTPUT, L);
                  write(L, string'("WB"));
                  write(L, NOW, RIGHT, 14, NS); 
                  write(L, Details & "**");
                  writeline(OUTPUT, L);
                  write(L, Stars);
                  writeLine(OUTPUT, L);   
                end if;
              when HB_INCR4 => if BurstLatency > WorstI4RLat then
                  WorstI4RTime <= NOW;
                  WorstI4RLat <= BurstLatency;
                  WorstI4RDetails <= Details;
                  write(L, Title);
                  writeline(OUTPUT, L);
                  write(L, Line2A);
                  write(L, string'("Read INCR4 burst latency = "));
                  write(L, Int2HexStr(BurstLatency));
                  write(L, string'("                     **"));
                  writeline(OUTPUT, L);
                  write(L, string'("WB"));
                  write(L, NOW, RIGHT, 14, NS); 
                  write(L, Details & "**");
                  writeline(OUTPUT, L);
                  write(L, Stars);
                  writeLine(OUTPUT, L);  
                end if;
              when HB_WRAP8 => if BurstLatency > WorstW8RLat then
                  WorstW8RTime <= NOW;
                  WorstW8RLat <= BurstLatency;
                  WorstW8RDetails <= Details;
                  write(L, Title);
                  writeline(OUTPUT, L);
                  write(L, Line2A);
                  write(L, string'("Read WRAP8 burst latency = "));
                  write(L, Int2HexStr(BurstLatency));
                  write(L, string'("                     **"));
                  writeline(OUTPUT, L);
                  write(L, string'("WB"));
                  write(L, NOW, RIGHT, 14, NS); 
                  write(L, Details & "**");
                  writeline(OUTPUT, L);
                  write(L, Stars);
                  writeLine(OUTPUT, L);                  
                end if;
              when HB_INCR8 => if BurstLatency > WorstI8RLat then
                  WorstI8RTime <= NOW;
                  WorstI8RLat <= BurstLatency;
                  WorstI8RDetails <= Details;
                  write(L, Title);
                  writeline(OUTPUT, L);
                  write(L, Line2A);
                  write(L, string'("Read INCR8 burst latency = "));
                  write(L, Int2HexStr(BurstLatency));
                  write(L, string'("                     **"));
                  writeline(OUTPUT, L);
                  write(L, string'("WB"));
                  write(L, NOW, RIGHT, 14, NS); 
                  write(L, Details & "**");
                  writeline(OUTPUT, L);
                  write(L, Stars);
                  writeLine(OUTPUT, L);     
                end if;
              when HB_WRAP16 => if BurstLatency > WorstW16RLat then
                  WorstW16RTime <= NOW;
                  WorstW16RLat <= BurstLatency;
                  WorstW16RDetails <= Details;
                  write(L, Title);
                  writeline(OUTPUT, L);
                  write(L, Line2A);
                  write(L, string'("Read WRAP16 burst latency = "));
                  write(L, Int2HexStr(BurstLatency));
                  write(L, string'("                    **"));
                  writeline(OUTPUT, L);
                  write(L, string'("WB"));
                  write(L, NOW, RIGHT, 14, NS); 
                  write(L, Details & "**");
                  writeline(OUTPUT, L);
                  write(L, Stars);
                  writeLine(OUTPUT, L);    
                end if;
              when HB_INCR16 => if BurstLatency > WorstI16RLat then
                  WorstI16RTime <= NOW;
                  WorstI16RLat <= BurstLatency;
                  WorstI16RDetails <= Details;
                  write(L, Title);
                  writeline(OUTPUT, L);
                  write(L, Line2A);
                  write(L, string'("Read INCR16 burst latency = "));
                  write(L, Int2HexStr(BurstLatency));
                  write(L, string'("                    **"));
                  writeline(OUTPUT, L);
                  write(L, string'("WB"));
                  write(L, NOW, RIGHT, 14, NS); 
                  write(L, Details & "**");
                  writeline(OUTPUT, L);
                  write(L, Stars);
                  writeLine(OUTPUT, L);    
                end if;                          
              when others => null;
            end case;

          else    
            case HburstReg is
              when HB_SINGLE => if BurstLatency > WorstSWLat then
                  WorstSWTime <= NOW;
                  WorstSWLat <= BurstLatency; 
                  WorstSWDetails <= Details;
                  write(L, Title);
                  writeline(OUTPUT, L);
                  write(L, Line2A);
                  write(L, string'("Write Single burst latency = "));
                  write(L, Int2HexStr(BurstLatency));
                  write(L, string'("                   **"));
                  writeline(OUTPUT, L);
                  write(L, string'("WB"));
                  write(L, NOW, RIGHT, 14, NS); 
                  write(L, Details & "**");
                  writeline(OUTPUT, L);
                  write(L, Stars);
                  writeLine(OUTPUT, L);  
                end if;
              when HB_INCR => if BurstLatency > WorstIWLat then
                  WorstIWTime <= NOW;
                  WorstIWLat <= BurstLatency; 
                  WorstIWDetails <= Details;
                  write(L, Title);
                  writeline(OUTPUT, L);
                  write(L, Line2A);
                  write(L, string'("Write INCR burst latency = "));
                  write(L, Int2HexStr(BurstLatency));
                  write(L, string'("                     **"));
                  writeline(OUTPUT, L);
                  write(L, string'("WB"));
                  write(L, NOW, RIGHT, 14, NS); 
                  write(L, Details & "**");
                  writeline(OUTPUT, L);
                  write(L, Stars);
                  writeLine(OUTPUT, L);    
                end if;
              when HB_WRAP4 => if BurstLatency > WorstW4WLat then
                  WorstW4WTime <= NOW;
                  WorstW4WLat <= BurstLatency; 
                  WorstW4WDetails <= Details;
                  write(L, Title);
                  writeline(OUTPUT, L);
                  write(L, Line2A);
                  write(L, string'("Write WRAP4 burst latency = "));
                  write(L, Int2HexStr(BurstLatency));
                  write(L, string'("                    **"));
                  writeline(OUTPUT, L);
                  write(L, string'("WB"));
                  write(L, NOW, RIGHT, 14, NS); 
                  write(L, Details & "**");
                  writeline(OUTPUT, L);
                  write(L, Stars);
                  writeLine(OUTPUT, L);         
                end if;
              when HB_INCR4 => if BurstLatency > WorstI4WLat then
                  WorstI4WTime <= NOW;
                  WorstI4WLat <= BurstLatency; 
                  WorstI4WDetails <= Details;
                  write(L, Title);
                  writeline(OUTPUT, L);
                  write(L, Line2A);
                  write(L, string'("Write INCR4 burst latency = "));
                  write(L, Int2HexStr(BurstLatency));
                  write(L, string'("                    **"));
                  writeline(OUTPUT, L);
                  write(L, string'("WB"));
                  write(L, NOW, RIGHT, 14, NS); 
                  write(L, Details & "**");
                  writeline(OUTPUT, L);
                  write(L, Stars);
                  writeLine(OUTPUT, L);    
                end if;
              when HB_WRAP8 => if BurstLatency > WorstW8WLat then
                  WorstW8WTime <= NOW;
                  WorstW8WLat <= BurstLatency; 
                  WorstW8WDetails <= Details;
                  write(L, Title);
                  writeline(OUTPUT, L);
                  write(L, Line2A);
                  write(L, string'("Write WRAP8 burst latency = "));
                  write(L, Int2HexStr(BurstLatency));
                  write(L, string'("                    **"));
                  writeline(OUTPUT, L);
                  write(L, string'("WB"));
                  write(L, NOW, RIGHT, 14, NS); 
                  write(L, Details & "**");
                  writeline(OUTPUT, L);
                  write(L, Stars);
                  writeLine(OUTPUT, L);       
                end if;
              when HB_INCR8 => if BurstLatency > WorstI8WLat then
                  WorstI8WTime <= NOW;
                  WorstI8WLat <= BurstLatency; 
                  WorstI8WDetails <= Details;
                  write(L, Title);
                  writeline(OUTPUT, L);
                  write(L, Line2A);
                  write(L, string'("Write INCR8 burst latency = "));
                  write(L, Int2HexStr(BurstLatency));
                  write(L, string'("                    **"));
                  writeline(OUTPUT, L);
                  write(L, string'("WB"));
                  write(L, NOW, RIGHT, 14, NS); 
                  write(L, Details & "**");
                  writeline(OUTPUT, L);
                  write(L, Stars);
                  writeLine(OUTPUT, L);      
                end if;
              when HB_WRAP16 => if BurstLatency > WorstW16WLat then
                  WorstW16WTime <= NOW;
                  WorstW16WLat <= BurstLatency; 
                  WorstW16WDetails <= Details;
                  write(L, Title);
                  writeline(OUTPUT, L);
                  write(L, Line2A);
                  write(L, string'("Write WRAP16 burst latency = "));
                  write(L, Int2HexStr(BurstLatency));
                  write(L, string'("                   **"));
                  writeline(OUTPUT, L);
                  write(L, string'("WB"));
                  write(L, NOW, RIGHT, 14, NS); 
                  write(L, Details & "**");
                  writeline(OUTPUT, L);
                  write(L, Stars);
                  writeLine(OUTPUT, L);    
                end if;
              when HB_INCR16 => if BurstLatency > WorstI16WLat then
                  WorstI16WTime <= NOW;
                  WorstI16WLat <= BurstLatency; 
                  WorstI16WDetails <= Details;
                  write(L, Title);
                  writeline(OUTPUT, L);
                  write(L, Line2A);
                  write(L, string'("Write INCR16 burst latency = "));
                  write(L, Int2HexStr(BurstLatency));
                  write(L, string'("                   **"));
                  writeline(OUTPUT, L);
                  write(L, string'("WB"));
                  write(L, NOW, RIGHT, 14, NS); 
                  write(L, Details & "**");
                  writeline(OUTPUT, L);
                  write(L, Stars);
                  writeLine(OUTPUT, L);    
                end if;                          
              when others => null;
            end case;           
          end if;
        end if;
      end if;
    end if;
  end process Bstats;

-------------------------------------------------------------------------------
-- BOutput outputs the raw transfer data to modelsim log and text file
-------------------------------------------------------------------------------  

  BOutput : process (HCLK)
    file Outfile  : text is out (ID & "_BurstLatency.txt"); -- output file
    variable L    : line;
    variable TrueFDAT : integer;  -- required because of single transfer bursts
  begin
    if HCLK = '1' then
      if ((BState = STORE or BState = INC) and BNextState /= INC) then
        -- here the burst is complete

        if HtransReg = TRN_NONSEQ then
          TrueFDAT := Waits;       -- if the last transfer was a non sequential
        else                       -- this catches singles and INCR with
                                   -- one transfer
          TrueFDAT := FDAT;
        end if;
        
        BurstTime <= NOW;
        write(L, NOW, RIGHT, 14, NS);
        write(L, (" " & Int2HexStr(Bursts+1) & " " & Addr2Str(HaddrReg)));
        write(L, (" " & Write2Char(HwriteReg) & " " & Size2Str(HsizeReg)));
        write(L, (" " & Burst2Str(HburstReg) & " " & Int2HexStr(BurstLatency)));
        write(L, (" " & Int2HexStr(AD) & " " & Int2HexStr(TrueFDAT)));
        write(L, (" " & TIB2Str(TIB, HburstReg) & " " & Busys2Str(Busys)));
        write(L, (" " & Int2HexStr(BusyCount) & " " & Lock2Str(Lock)));
    
        -- file output
        writeline (Outfile, L);


      end if;
    end if;
  end process BOutput;

-------------------------------------------------------------------------------
-- Regular output of Burst statistics when Bursts count gets to 256
-------------------------------------------------------------------------------
  
  BRegularOutput : process (Bursts)
    variable stars : string(1 to 20) := "********************";
    variable spcs : string(1 to 29) := "                             ";
    variable L : line;
  begin
      if (Bursts > 0 and (Bursts MOD 256 = 0)) then
         -- output stats every 256 bursts
        write(L, ("BS******************" & Stars));
        write(L, ("  " & ID & " Statistics   " & Stars & Stars));
        writeline(OUTPUT, L);
        write(L, string'("BS                 Time = "));
        write(L, NOW, RIGHT, 14, NS);
        write(L, string'("                    Total Bursts = "));
        write(L, (Int2HexStr(Bursts) & "               **"));
        writeline(OUTPUT, L);
        write(L, string'("**------------------------------------------------"));
        write(L, string'("------------------------------------------------**"));
        writeline(OUTPUT, L);
        write(L, ("BS  Reads  = " & Int2HexStr(RBursts)));
        write(L, ("  SINGLE = " & Int2HexStr(Singles)));
        write(L, ("  WRAP4 = " & Int2HexStr(WRAP4s)));
        write(L, ("  WRAP8 = " & Int2HexStr(WRAP8s)));
        write(L, ("  WRAP16 = " & Int2HexStr(WRAP16s) & "   **"));
        writeline(OUTPUT, L);
        write(L, ("BS  Writes = " & Int2HexStr(WBursts)));
        write(L, ("  INCR   = " & Int2HexStr(INCRs)));
        write(L, ("  INCR4 = " & Int2HexStr(INCR4s)));
        write(L, ("  INCR8 = " & Int2HexStr(INCR8s)));
        write(L, ("  INCR16 = " & Int2HexStr(INCR16s) & "   **"));
        writeline(OUTPUT, L);                
        write(L, string'("**------------------------------------------------"));
        write(L, string'("------------------------------------------------**"));
        writeline(OUTPUT, L);
        write(L, ("**" & Spcs & "Worst Read Burst Latency   = "));
        write(L, (Int2HexStr(WorstRBLat) & Spcs & " **"));
        writeline(OUTPUT, L);
        write(L, string'("**"));
        write(L, WorstRBTime, RIGHT, 14, NS);
        write(L, (WorstRBDetails & "**"));
        writeline(OUTPUT, L);
        write(L, ("**" & Spcs & "Worst Write Burst Latency  = "));
        write(L, (Int2HexStr(WorstWBLat) & Spcs & " **"));
        writeline(OUTPUT, L);
        write(L, string'("**"));
        write(L, WorstWBTime, RIGHT, 14, NS);
        write(L, (WorstWBDetails & "**"));
        writeline(OUTPUT, L);
        write(L, ("**" & Spcs & "Worst SINGLE Read Latency  = "));
        write(L, (Int2HexStr(WorstSRLat) & Spcs & " **"));
        writeline(OUTPUT, L);
        write(L, string'("**"));
        write(L, WorstSRTime, RIGHT, 14, NS);
        write(L, (WorstSRDetails & "**"));
        writeline(OUTPUT, L);
        write(L, ("**" & Spcs & "Worst SINGLE Write Latency = "));
        write(L, (Int2HexStr(WorstSWLat) & Spcs & " **"));
        writeline(OUTPUT, L);
        write(L, string'("**"));
        write(L, WorstSWTime, RIGHT, 14, NS);
        write(L, (WorstSWDetails & "**"));
        writeline(OUTPUT, L);
        write(L, ("**" & Spcs & "Worst INCR Read Latency    = "));
        write(L, (Int2HexStr(WorstIRLat) & Spcs & " **"));
        writeline(OUTPUT, L);
        write(L, string'("**"));
        write(L, WorstIRTime, RIGHT, 14, NS);
        write(L, (WorstIRDetails & "**"));
        writeline(OUTPUT, L);
        write(L, ("**" & Spcs & "Worst INCR Write Latency   = "));
        write(L, (Int2HexStr(WorstIWLat) & Spcs & " **"));
        writeline(OUTPUT, L);
        write(L, string'("**"));
        write(L, WorstIWTime, RIGHT, 14, NS);
        write(L, (WorstIWDetails & "**"));
        writeline(OUTPUT, L);
        write(L, ("**" & Spcs & "Worst WRAP4 Read Latency   = "));
        write(L, (Int2HexStr(WorstW4RLat) & Spcs & " **"));
        writeline(OUTPUT, L);
        write(L, string'("**"));
        write(L, WorstW4RTime, RIGHT, 14, NS);
        write(L, (WorstW4RDetails & "**"));
        writeline(OUTPUT, L);
        write(L, ("**" & Spcs & "Worst WRAP4 Write Latency  = "));
        write(L, (Int2HexStr(WorstW4WLat) & Spcs & " **"));
        writeline(OUTPUT, L);
        write(L, string'("**"));
        write(L, WorstW4WTime, RIGHT, 14, NS);
        write(L, (WorstW4WDetails & "**"));
        writeline(OUTPUT, L);
        write(L, ("**" & Spcs & "Worst INCR4 Read Latency   = "));
        write(L, (Int2HexStr(WorstI4RLat) & Spcs & " **"));
        writeline(OUTPUT, L);
        write(L, string'("**"));
        write(L, WorstI4RTime, RIGHT, 14, NS);
        write(L, (WorstI4RDetails & "**"));
        writeline(OUTPUT, L);
        write(L, ("**" & Spcs & "Worst INCR4 Write Latency  = "));
        write(L, (Int2HexStr(WorstI4WLat) & Spcs & " **"));
        writeline(OUTPUT, L);
        write(L, string'("**"));
        write(L, WorstI4WTime, RIGHT, 14, NS);
        write(L, (WorstI4WDetails & "**"));
        writeline(OUTPUT, L);
        write(L, ("**" & Spcs & "Worst WRAP8 Read Latency   = "));
        write(L, (Int2HexStr(WorstW8RLat) & Spcs & " **"));
        writeline(OUTPUT, L);
        write(L, string'("**"));
        write(L, WorstW8RTime, RIGHT, 14, NS);
        write(L, (WorstW8RDetails & "**"));
        writeline(OUTPUT, L);
        write(L, ("**" & Spcs & "Worst WRAP8 Write Latency  = "));
        write(L, (Int2HexStr(WorstW8WLat) & Spcs & " **"));
        writeline(OUTPUT, L);
        write(L, string'("**"));
        write(L, WorstW8WTime, RIGHT, 14, NS);
        write(L, (WorstW8WDetails & "**"));
        writeline(OUTPUT, L);
        write(L, ("**" & Spcs & "Worst INCR8 Read Latency   = "));
        write(L, (Int2HexStr(WorstI8RLat) & Spcs & " **"));
        writeline(OUTPUT, L);
        write(L, string'("**"));
        write(L, WorstI8RTime, RIGHT, 14, NS);
        write(L, (WorstI8RDetails & "**"));
        writeline(OUTPUT, L);
        write(L, ("**" & Spcs & "Worst INCR8 Write Latency  = "));
        write(L, (Int2HexStr(WorstI8WLat) & Spcs & " **"));
        writeline(OUTPUT, L);
        write(L, string'("**"));
        write(L, WorstI8WTime, RIGHT, 14, NS);
        write(L, (WorstI8WDetails & "**"));
        writeline(OUTPUT, L);
        write(L, ("**" & Spcs & "Worst WRAP16 Read Latency  = "));
        write(L, (Int2HexStr(WorstW16RLat) & Spcs & " **"));
        writeline(OUTPUT, L);
        write(L, string'("**"));
        write(L, WorstW16RTime, RIGHT, 14, NS);
        write(L, (WorstW16RDetails & "**"));
        writeline(OUTPUT, L);
        write(L, ("**" & Spcs & "Worst WRAP16 Write Latency = "));
        write(L, (Int2HexStr(WorstW16WLat) & Spcs & " **"));
        writeline(OUTPUT, L);
        write(L, string'("**"));
        write(L, WorstW16WTime, RIGHT, 14, NS);
        write(L, (WorstW16WDetails & "**"));
        writeline(OUTPUT, L);
        write(L, ("**" & Spcs & "Worst INCR16 Read Latency  = "));
        write(L, (Int2HexStr(WorstI16RLat) & Spcs & " **"));
        writeline(OUTPUT, L);
        write(L, string'("**"));
        write(L, WorstI16RTime, RIGHT, 14, NS);
        write(L, (WorstI16RDetails & "**"));
        writeline(OUTPUT, L);
        write(L, ("**" & Spcs & "Worst INCR16 Write Latency = "));
        write(L, (Int2HexStr(WorstI16WLat) & Spcs & " **"));
        writeline(OUTPUT, L);
        write(L, string'("**"));
        write(L, WorstI16WTime, RIGHT, 14, NS);
        write(L, (WorstI16WDetails & "**"));
        writeline(OUTPUT, L);
        write(L, (Stars & Stars & Stars & Stars & Stars));
        writeline(OUTPUT, L);

    end if;
  end process BRegularOutput;

-----------------------------------------------------------------------------
-- ADStateSet the combinational process that determines the next state of the
-- LatencyMonitor Arbitration Delay state machine
-----------------------------------------------------------------------------
  
  ADStateSet : process(HTRANS, HSEL, ADState, HREADY)
  begin
    ADNextState <= ADState;
    case ADState is
      when RESET => ADNextState <= IDLE;

      when IDLE => if (HTRANS = TRN_NONSEQ and HSEL = '1'and HREADY = '0') then
                     ADNextState <= INC; 
                   else
                     ADNextState <= IDLE;
                   end if;

      when STORE =>   ADNextState <= IDLE;  -- not using this state

      when INC =>   if HREADY = '0' then 
                      ADNextState <= INC; 
                    else
                      ADNextState <= IDLE;
                    end if;
      when others => ADNextState <= IDLE;
    end case;
  end process ADStateSet;

-------------------------------------------------------------------------------
-- ADStateChange implements the SAL state transition on the rising clock edge
-------------------------------------------------------------------------------  
  
  ADStateChange : process(HCLK, HRESETn)
  begin
    if HRESETn = '0' then
      ADState <= RESET;
    elsif (HCLK'event and HCLK = '1') then
      ADState <= ADNextState;
    end if;
  end process ADStateChange;

-------------------------------------------------------------------------------
-- P_ADCount counts the number of cycles it takes for the burst to complete
-------------------------------------------------------------------------------  
  
  P_ADCount : process(HCLK)
  begin
    if (HCLK'event and HCLK = '1') then
      case ADNextState is
        when RESET  => ADCount <= 0;
        when IDLE   => ADCount <= 0;
        when STORE  => ADCount <= 0;
        when INC    => ADCount <= ADCount + 1;
        when others => ADCOunt <= 0;
      end case;
    end if;
  end process P_ADCount;

-------------------------------------------------------------------------------
-- ADReg registers te current bursts AD
-------------------------------------------------------------------------------

  ADReg : process(HCLK, HRESETn)
  begin
    if HRESETn = '0' then
      AD <= 0;  -- initialize on reset
    else
      if (HCLK'event and HCLK = '1') then
        if (HTRANS = TRN_NONSEQ and HSEL = '1'and HREADY = '1') then
          AD <= ADCount;
        end if;
      end if;  
    end if;  
  end process ADReg;



-------------------------------------------------------------------------------
-- TIBSet Sets the Transfers In Burst counter to watch for broken bursts
-------------------------------------------------------------------------------


  TIBSet : process(HCLK, HRESETn)
  begin
    if HRESETn = '0' then
      TIB <= 0;
    else
      if (HCLK'event and HCLK = '1') then
        if (BNextState = Store and HREADY = '1') then
          TIB <= 1;
        elsif (TNextState = Store and HREADY = '1') then
          TIB <= TIB + 1;
        end if;
      end if;        
    end if;
  end process TIBSet;

  

-------------------------------------------------------------------------------
-- BusysIndicator
-------------------------------------------------------------------------------

  BusysIndicator : process(HCLK, HRESETn)
  begin
    if HRESETn = '0' then
      Busys <= '0';  -- initialize on reset
      BusyCount <= 0;
    else
      if (HCLK'event and HCLK = '1') then
        case BNextState is
          when Reset => Busys <= '0';
                        BusyCount <= 0;
          when Idle => Busys <= '0';
                       BusyCount <= 0;
          when Store => Busys <= '0';
                        BusyCount <= 0;            
          when INC =>
            if (HTRANS = TRN_BUSY and HREADY = '1') then
              Busys <= '1';
              BusyCount <= BusyCount + 1;
            end if;
          when others => Busys <= '0';
                         BusyCount <= 0;
        end case;
      end if;  
    end if;
  end process BusysIndicator;


-------------------------------------------------------------------------------
  -- LockReg sets the lock signal if a transfer in a burst is locked
-------------------------------------------------------------------------------  

  LockReg : process(HCLK, HRESETn)
  begin
    if HRESETn = '0' then
      Lock <= '0';  -- initialize on reset
    else
      if (HCLK'event and HCLK = '1') then
        case BNextState is
          when Reset => Lock <= '0';
          when Idle => Lock <= '0';
          when Store =>
            if HMASTLOCK = '1' then
              Lock <= '1';
            else
              Lock <= '0';
            end if;
          when INC =>
            if HMASTLOCK = '1' then
              Lock <= '1';
            end if;
          when others => Lock <= '0';
        end case;
      end if;  
    end if;  
  end process LockReg;
  
  
end behavioural;



-- --================================= End ===================================--

