-- --=========================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 2001-2002 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
--
-- -----------------------------------------------------------------------------
-- Version and Release Control Information:
--
-- File Name              : EbiTrArbtCtl.vhd.rca
-- File Revision          : 1.2
--
-- Release Information    : PrimeCell(TM)-PL220-r0p0-00ltd0
--
-- -----------------------------------------------------------------------------
-- Purpose : 
--           This block implements the arbitration and control logic for
--           the Ebi Mirror Trick Box.
-- --=========================================================================--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity EbiTrArbtCtl is
  port (
-- Inputs 
        EBICLK            : in    std_logic; -- External Bus Interface Clock
        nPOR              : in    std_logic; -- Power On Reset
        EBIREQ1           : in    std_logic; -- EBI request for Port 1,
                                             -- Active high
        EBIREQ2           : in    std_logic; -- EBI request for Port 2,
                                             -- Active high
        EBIREQ3           : in    std_logic; -- EBI request for Port 3,
                                             -- Active high
        EBITIMEOUTVALUE1  : in    std_logic_vector(9 downto 0);
                                             -- Gives the value to be loaded
                                             -- into timeout counter for port 1
        EBITIMEOUTVALUE2  : in    std_logic_vector(9 downto 0);
                                             -- Gives the value to be loaded
                                             -- into timeout counter for port 2
        EBITIMEOUTVALUE3  : in    std_logic_vector(9 downto 0);
                                             -- Gives the value to be loaded
                                             -- into timeout counter for port 3
-- Outputs  
        EbiTrBackoff      : out   std_logic_vector(2 downto 0);
                                             -- EBIBACKOFF signals 
                                             -- EbiTrBackoff(0) -- Port 1
                                             -- EbiTrBackoff(1) -- Port 2
                                             -- EbiTrBackoff(2) -- Port 3
        EbiTrGnt          : out   std_logic_vector(2 downto 0) 
                                             -- EBI Grant signals 
                                             -- EbiTrGnt(0) -- Port 1
                                             -- EbiTrGnt(1) -- Port 2
                                             -- EbiTrGnt(2) -- Port 3
       );
end EbiTrArbtCtl;

-- -----------------------------------------------------------------------------
--
--                           EbiTrArbtCtl
--                           =============
--
-- -----------------------------------------------------------------------------
--
-- Overview
-- ========
-- o Control and Arbitration Block 
--    This is Arbitration Block in Ebi Mirror Trick Box that arbitrates
--    between the requested ports.Each port has a 10 bits counter which 
--    will be loaded with a value from EBITimeOut[9:0] input whenever a
--    request is made for the bus.If the signal EBITimeOut[9:0] is zero
--    then the counter will not be started for the port.When the 
--    counter reaches zero then the port currently granted the bus,will
--    be requested to release the bus by asserting the EBIBackOff signal.
--    The first port counter to reach zero will be given the highest 
--    priority for the bus,followed by the second device.If more than
--    one port issues a request for the bus at the same time then a 
--    round robin arbitration scheme will be used to decide which port 
--    should be granted the bus.
-- -----------------------------------------------------------------------------

-- --============================= ARCHITECTURE ==============================--

architecture behaviour of EbiTrArbtCtl is

-- -----------------------------------------------------------------------------
-- Component declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Constant declarations
-- -----------------------------------------------------------------------------
-- Type Declarations
type t_PTable is array(1 downto 0) of std_logic_vector(2 downto 0);

-- -----------------------------------------------------------------------------
-- Signal Declarations
-- -----------------------------------------------------------------------------
signal CounterOne  : std_logic_vector(9 downto 0);
-- Port 1 Time Out Counter Internal.

signal CounterTwo  : std_logic_vector(9 downto 0);
-- Port 2 Time Out Counter Internal.

signal CounterThr  : std_logic_vector(9 downto 0);
-- Port 3 Time Out Counter Internal.

signal EbiTrGntint : std_logic_vector(2 downto 0); 
-- Internal copy of Grant signal
-- EbiTrGntint(0) Port 1
-- EbiTrGntint(1) Port 2
-- EbiTrGntint(2) Port 3

signal DcrCnt1     : std_logic;
-- Signal Indicating the Port 1 Time Out Value has reached zero.

signal DcrCnt2     : std_logic;
-- Signal Indicating the Port 2 Time Out Value has reached zero.

signal DcrCnt3     : std_logic;
-- Signal Indicating the Port 3 Time Out Value has reached zero.

signal PTable      : t_PTable;
-- Priority Table which is used as reference for selecting a port to be
-- granted.Priority Table is has 2 locations each of 3 bits wide.
-- The port that is curently granted is written to location 0.
-- The port at location 0 is copied to location 1.The priority issue
-- is resolved by referencing to this table.

signal TriSim31    : std_logic;
-- Tigger signal indicating simultaneous request form port 1 and port 3

signal TriSim21    : std_logic;
-- Tigger signal indicating simultaneous request form port 2 and port 1

signal TriSim32    : std_logic;
-- Tigger signal indicating simultaneous request form port 3 and port 2

signal CState      : natural;
-- Current State Signal

signal NState      : natural;
-- Next State Signal

signal BackOffReg  : std_logic_vector(1 downto 0);
-- This Backoff register contains a port id whose time out counter 
-- has reached zero first.This helps in generating the grant signal
-- when more than one counter reaches time out zero.

signal Flag3To1    : std_logic;
-- A intenal flag which is used to control the updating of Priority
-- table in State 3

signal Flag3To2    : std_logic;
-- A intenal flag which is used to control the updating of Priority
-- table in State 3

signal Flag5To1    : std_logic;
-- A intenal flag which is used to control the updating of Priority
-- table in State 5

signal Flag5To4    : std_logic;
-- A intenal flag which is used to control the updating of Priority
-- table in State 5

signal Flag6To4    : std_logic;
-- A intenal flag which is used to control the updating of Priority
-- table in State 6

signal Flag6To2    : std_logic;
-- A intenal flag which is used to control the updating of Priority
-- table in State 6

-- -----------------------------------------------------------------------------
-- Function declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
--
-- Main body of code
-- =================
--
-- -----------------------------------------------------------------------------

begin

-- -----------------------------------------------------------------------------
-- Main Process 
-- Request State Machine 
-- -----------------------------------------------------------------------------
--
-- This state machine makes states transitions based on the requests from
-- Port 1,Port 2 and Port 3.At every positive clock edge the requests
-- from all the three ports are sampled and depending upon the requests
-- state transitions is made.
--
-- -----------------------------------
-- Table Showing the State Transitions.
-- -----------------------------------
-- |--------------|------------|----------|------------|------------------|
-- |    State     |  Port3Req  | Port2Req |  Port1Req  |     Comment      |
-- |--------------|------------|----------|------------|------------------|
-- |      1       |      0     |    0     |     1      | Port 1 Only      |
-- |--------------|------------|----------|------------|------------------|
-- |      2       |      0     |    1     |     0      | Port 2 Only      |
-- |--------------|------------|----------|------------|------------------|
-- |      3       |      0     |    1     |     1      | Port 1 & Port 2  |
-- |--------------|------------|----------|------------|------------------|
-- |      4       |      1     |    0     |     0      | Port 3 Only      |
-- |--------------|------------|----------|------------|------------------|
-- |      5       |      1     |    0     |     1      | Port 3 & Port 1  |
-- |--------------|------------|----------|------------|------------------|
-- |      6       |      1     |    1     |     0      | Port 3 & Port 2  |
-- |--------------|------------|----------|------------|------------------|
-- |      7       |      1     |    1     |     1      | All Port Request |
-- |--------------|------------|----------|------------|------------------|
-- |      8       |      0     |    0     |     0      | No Request       |
-- |--------------|------------|----------|------------|------------------|
-- The transitions to state 3, state 5,state 7 and state 6 could be due to 
-- simultaneous requests from respective ports or one after the other in
-- any sequence.
-- State 8 is an idle state when there is no request.
-- In each state eight transitions are possible.
-- Priotity Table is used to resolve priority among two ports.The priority
-- table is illustarted below.Three bits are used for Port Id.
--
-- ------
-- PTable
-- ------
-- |----------|------|------|------|     
-- | Location | Bit2 | Bit1 | Bit0 |    001 -> Port 1  
-- |----------|------|------|------|    010 -> Port 2
-- |     0    |      |      |      |    100 -> Port 3
-- |----------|------|------|------|
-- |     1    |      |      |      |
-- |----------|------|------|------|
-- When a port is granted its id is written at location 0 and the contents
-- of location 0 is pushed to location 1.In this manner the priority table 
-- is updated and when a priority needs to be resolved the contents of
-- these locations are checked to know the least granted port. 
--
-- ----------
-- BackoffReg
-- ----------
-- This Backoff register contains a port id whose time out counter 
-- has reached zero first.This helps in generating the grant signal
-- when more than one counter reaches time out value zero.
-- The 2 bits port id is shown below:
--   01 -> Port 1
--   10 -> Port 2
--   11 -> Port 3
--
-- -----------------------------------------------------------------------------

p_main : process(nPOR,EBICLK)
variable EbiReqv       : std_logic_vector(2 downto 0);
-- Internal Request variable 

variable EbiTrGntv     : std_logic_vector(2 downto 0);
-- Internal Grant variable 

variable EbiTrBackoffv : std_logic_vector(2 downto 0);
-- Internal Backoff variable 

variable BackOffRegv   : std_logic_vector(1 downto 0);
-- Internal BackoffReg variable 

variable TrigCnt1      : std_logic; 
-- Trigger for decrementing Internal Time Out Counter for Port 1

variable TrigCnt2      : std_logic; 
-- Trigger for decrementing Internal Time Out Counter for Port 2

variable TrigCnt3      : std_logic; 
-- Trigger for decrementing Internal Time Out Counter for Port 3

begin
  if (nPOR = '0') then
    -- Intialise all the signals to the default values
    NState        <= 8;     -- Initial State value is 8(Init State)
    EbiTrGnt      <= "000"; -- After Reset No Ports are granted 
    EbiTrBackoff  <= "000";
    EbiTrGntint   <= "001";
    PTable(1)     <= "010"; -- PTable Location 1 is loaded with Port 3
    PTable(0)     <= "100"; -- PTable Location 0 is loaded with Port 1
    TriSim31      <= '0';
    TriSim21      <= '0';
    TriSim32      <= '0';
    BackOffReg    <= "00"; 
    Flag3To1      <= '0';
    Flag3To2      <= '0';
    Flag5To1      <= '0';
    Flag5To4      <= '0';
    Flag6To4      <= '0';
    Flag6To2      <= '0';
    CounterOne    <= "0000000000";
    CounterTwo    <= "0000000000";
    CounterThr    <= "0000000000";
    DcrCnt1       <= '0';
    DcrCnt2       <= '0';
    DcrCnt3       <= '0';
    EbiTrGntv     := "000";
    EbiTrBackoffv := "000";
    EbiReqv       := "000";
    TrigCnt1      := '0';
    TrigCnt2      := '0';
    TrigCnt3      := '0';
    BackOffRegv   := "00"; 
  elsif (EBICLK'event and EBICLK = '1') then
    EbiReqv := EBIREQ3 & EBIREQ2 & EBIREQ1;
    -- ------------------------------------------------------------------
    -- All three request are assigned to Ebireq variable for making state
    -- transitions.
    -- ------------------------------------------------------------------
    case CState is
    -- ------------------------------------------------------------------
    -- Current State Decoding
    -- ------------------------------------------------------------------
      when 1 =>
        -- -------------------------------------------------------------
        -- STATE 1
        -- In this state there is only one request from Port 1.
        -- -------------------------------------------------------------
        -- |------------|-----------------------------------------------
        -- | Next State |            Comments                        
        -- |------------|-----------------------------------------------
        -- |    000     | When fsm is in state one and goes back to init
        -- |            | state(state 8) indicates that Port 1 has             
        -- |            | released its request. 
        -- |------------|-----------------------------------------------
        -- |    001     | Port 1 maintains the Request.
        -- |------------|-----------------------------------------------
        -- |    010     | Port 1 has released the request and Port 2
        -- |            | has requested.Grant has to given to Port 2
        -- |            | updating the PTable(priority table).
        -- |------------|-----------------------------------------------
        -- |    011     | Port 1 continues to maitain the request and 
        -- |            | Port 2 has requested.If Port 2 Time Out 
        -- |            | Counter value is zero then Backoff for Port 1 
        -- |            | is raised on the next clock else TrigCnt2 
        -- |            | signal is raised for decrementing the Port 2
        -- |            | Time Out Counter.
        -- |------------|-----------------------------------------------
        -- |    100     | Port 1 has released the request and Port 3
        -- |            | has requested.Grant has to given to Port 3
        -- |            | updating the PTable(priority table).
        -- |------------|-----------------------------------------------
        -- |    101     | Port 1 continues to maitain the request and 
        -- |            | Port 3 has requested.If Port 3 Time Out 
        -- |            | Counter value is zero then Backoff for Port 1 
        -- |            | is raised on the next clock else TrigCnt3 
        -- |            | signal is raised for decrementing the Port 3
        -- |            | Time Out Counter.
        -- |------------|-----------------------------------------------
        -- |    110     | Port 1 has released the request and Port 2
        -- |            | and Port 3 has requested simultaneously.
        -- |            | Based on PTbale either Port 2 or Port 3 is
        -- |            | granted.
        -- |            | If Port 2 is Granted, Port 3 Time Out 
        -- |            | Counter is Triggered after checking for non
        -- |            | zero value.If the Port 3 Time Out Counter
        -- |            | value is zero then back off for Port 2 
        -- |            | is given on next clock in state 6.This is 
        -- |            | because Grant and Backoff should not be given 
        -- |            | on the same clock. 
        -- |            | If Port 3 is Granted, Port 2 Time Out 
        -- |            | Counter is Triggered after checking for non
        -- |            | zero value.If the Port 2 Time Out Counter
        -- |            | value is zero then back off for Port 3 
        -- |            | is given on next clock in state 6.This is 
        -- |            | because Grant and Backoff should not be given 
        -- |            | on the same clock. 
        -- |            | TrigSim32 signal is raised.
        -- |------------|-----------------------------------------------
        -- |    111     | Here Port 1 continues to hold the request and
        -- |            | port 2 and 3 simultaneously request.
        -- |            | TriSim32 signal is raised.
        -- |            | Backoff signal for Port 1 is generated 
        -- |            | on the next clock by checking for zero value 
        -- |            | of Time Out Counter of Port 2 or Port 3.
        -- |            | If Time Out Counter values of Port 2 or 
        -- |            | Port 3 are non zeros then Trigger signals
        -- |            | for appropriate Time Out Counter is raised
        -- |            | to decrement. 
        -- |------------|-----------------------------------------------
        ----------------------------------------------------------------
        case EbiReqv is
          when "000" => 
            NState <= 8;
            EbiTrGntv     := "000"; 
            EbiTrBackoffv := "000";
            BackOffRegv   := "00"; 
          when "001" => 
            NState <= 1;
          when "010" => 
            NState <= 2;
            EbiTrGntv  := "010";
            PTable(1)  <= PTable(0);
            PTable(0)  <= "010";   
          when "011" => 
            NState <= 3;
            EbiTrGntv := "001"; 
            if (EBITIMEOUTVALUE2 = "0000000000") then
              EbiTrBackoffv := "001";
              BackOffRegv   := "10"; 
            else
              TrigCnt2 := '1'; 
            end if; 
          when "100" => 
            NState <= 4;
            EbiTrGntv := "100";
            PTable(1) <= PTable(0);
            PTable(0) <= "100";   
          when "101" => 
            NState <= 5;
            EbiTrGntv := "001"; 
            if (EBITIMEOUTVALUE3 = "0000000000") then
              EbiTrBackoffv := "001";
              BackOffRegv   := "11"; 
            else
              TrigCnt3 := '1'; 
            end if; 
          when "110" => 
            NState <= 6;
            TriSim32 <= '1'; 
            if (PTable(0) = "010" or PTable(1) = "010") then 
              if (TrigCnt3 = '0') then
                EbiTrGntv := "100";
                PTable(1) <= PTable(0);
                PTable(0) <= "100";   
                if (EBITIMEOUTVALUE2 /= "0000000000") then
                  TrigCnt2 := '1'; 
                end if; 
              end if; 
            elsif (PTable(0) = "100" or PTable(1) = "100") then   
              if (TrigCnt2 = '0') then
                EbiTrGntv := "010";
                PTable(1) <= PTable(0);
                PTable(0) <= "010";  
                if (EBITIMEOUTVALUE3 /= "0000000000") then
                  TrigCnt3 := '1'; 
                end if; 
              end if; 
            end if; 
          when "111" => 
            NState <= 7;
            TriSim32 <= '1';
            if (EBITIMEOUTVALUE2 = "0000000000") then
              EbiTrBackoffv := "001";
              BackOffRegv   := "00"; 
            else
              TrigCnt2 := '1'; 
            end if; 
            if (EBITIMEOUTVALUE3 = "0000000000") then
              EbiTrBackoffv := "001";
              BackOffRegv   := "00"; 
            else
              TrigCnt3 := '1'; 
            end if; 
          when others => 
            null;
        end case;  
      when 3 => 
        -- -------------------------------------------------------------
        -- STATE 3
        -- In this State there is Request from Port 2 and Port 1.
        -- -------------------------------------------------------------
        -- |------------|-----------------------------------------------
        -- | Next State |            Comments                        
        -- |------------|-----------------------------------------------
        -- |    000     | From state three if Port 2 and Port 1 requests 
        -- |            | are deasserted then next state is init state
        -- |            | (state eight).
        -- |------------|-----------------------------------------------
        -- |    001     | In this case Port 2 has deasserted the 
        -- |            | requested clear backoffreg and Grant is given
        -- |            | to Port 1.The Priority Table is update only
        -- |            | if the previous granted Port is not 1 ie 
        -- |            | Port 2.
        -- |------------|-----------------------------------------------
        -- |    010     | In this case Port 1 has deasserted the
        -- |            | requested clear backoffreg and Grant is given
        -- |            | to Port 1.The Priority Table is update only
        -- |            | if the previous granted Port is not 2 ie
        -- |            | Port 1.
        -- |------------|-----------------------------------------------
        -- |    011     | In this case if TrigSim21 flag is raised
        -- |            | then is is clear that Port 2 and Port 1 has
        -- |            | requested simultaneously.Time Out Counter
        -- |            | values are check for zero value and a backoff 
        -- |            | is raised to the port that was granted and
        -- |            | backoffreg is update with port id.
        -- |            | Four condition are checked in this case:
        -- |            | 1. DcrCnt2 = '1' and DcrCnt1 = '0'
        -- |            |    which indicates that Time out value of 
        -- |            |    counter 2 has reached zero.Backoff signal
        -- |            |    is raised to Port 1 and Backoffreg register
        -- |            |    is updated with Port 2 id.
        -- |            | 2. DcrCnt2 = '0' and DcrCnt1 = '1'
        -- |            |    which indicates that Time out value of 
        -- |            |    counter 1 has reached zero.Backoff signal
        -- |            |    is raised for Port 2 and Backoffreg
        -- |            |    register is updated with Port 1 id.
        -- |            | 3. DcrCnt2 = '1' and DcrCnt1 = '1'
        -- |            |    which indicates that Time out value of 
        -- |            |    counter 1 has reached zero and also
        -- |            |    Time out value of counter 2 has reached
        -- |            |    reached zero.This case can happen only
        -- |            |    when Port 3 has released the request and
        -- |            |    both the ports Time Out Counter value has
        -- |            |    reached zero.Now the Grant is given to 
        -- |            |    the Port whose id is in Backoffreg register.    
        -- |            |    The Backoffreg register contains the port 
        -- |            |    id whose Time Out Counter has reached zero 
        -- |            |    first.
        -- |------------|-----------------------------------------------
        -- |    100     | In this case both Port 2 and Port 1 requests
        -- |            | are deasserted and Port 3 has made a request.
        -- |            | The grant is given to Port 3.Backoffreg is 
        -- |            | cleared.PTable is updated.
        -- |------------|-----------------------------------------------
        -- |    101     | In this case clear the Trigger for Time Out
        -- |            | Counter for Port 2.Port 3 has raised the 
        -- |            | raised the request.If previously granted
        -- |            | port was 2 then Port 1 has to be granted and
        -- |            | Trigger has to raised for decrementing the
        -- |            | Time Out Counter of Port 3.If none of the 
        -- |            | above condition is true then a priority 
        -- |            | table decides which Port needs to be granted.
        -- |            | Ptbale is updated in either case.
        -- |------------|-----------------------------------------------
        -- |    110     | In this case clear the Trigger for Time Out
        -- |            | Counter for Port 1.Port 3 has raised the 
        -- |            | raised the request.If previously granted
        -- |            | port was 1 then Port 2 has to be granted and
        -- |            | Trigger has to raised for decrementing the
        -- |            | Time Out Counter of Port 3.If none of the 
        -- |            | above condition is true then a priority 
        -- |            | table decides which Port needs to be granted.
        -- |            | Ptbale is updated in either case.
        -- |------------|-----------------------------------------------
        -- |    111     | In this case Port 3 has raised the request
        -- |            | while Port 2 and Port 1 already have their 
        -- |            | requests raised.If Port 3 Time Out Counter 
        -- |            | value is zero and no backoff signal is 
        -- |            | generated then backoff signal is raised to
        -- |            | the Port that has been granted.Else Port 3
        -- |            | Time Out Counter is Triggered for 
        -- |            | decrementing.Also If Time Out Counter for 
        -- |            | port 2 or Port 1 has reached zero backoff 
        -- |            | is generated for the Port currently granted.
        -- |            | Backoffreg register is update with the port
        -- |            | id which determines Port to be grantied next.
        -- |------------|-----------------------------------------------
        ----------------------------------------------------------------
        case EbiReqv is
          when "000" =>
            NState <= 8;
            EbiTrBackoffv := "000";
            BackOffRegv   := "00"; 
            EbiTrGntv     := "000";  
            TrigCnt1      := '0';
            TrigCnt2      := '0';
            TrigCnt3      := '0';
            Flag3To1      <= '0';
            Flag3To2      <= '0';
          when "001" => 
            NState <= 1;
            EbiTrGntv     := "001";   
            EbiTrBackoffv := "000";
            BackOffRegv   := "00"; 
            if (EbiTrGntint /= "001") then
              PTable(1) <= PTable(0);
              PTable(0) <= "001";
            end if; 
            Flag3To1  <= '0';
            Flag3To2  <= '0';
            TrigCnt2  := '0';
          when "010" =>
            NState <= 2; 
            EbiTrGntv     := "010";
            EbiTrBackoffv := "000";
            BackOffRegv   := "00"; 
            if (EbiTrGntint /= "010") then
              PTable(1) <= PTable(0);
              PTable(0) <= "010";
            end if; 
            Flag3To1 <= '0';
            Flag3To2 <= '0';
            TrigCnt1 := '0';
          when "011" =>
            NState <= 3;
            if (TriSim21 = '1') then 
              if (EBITIMEOUTVALUE1 = "0000000000" and EbiTrGntint = "010") then
                EbiTrBackoffv := "010";
                BackOffRegv   := "01";
              end if;
              if (EBITIMEOUTVALUE2 = "0000000000" and EbiTrGntint = "001") then
                EbiTrBackoffv := "001";
                BackOffRegv   := "10";
              end if;
            end if;
            if (DcrCnt2 = '1' and DcrCnt1 = '0') then
              if (BackOffReg = "10" and Flag3To2 = '0' and 
                                                       Flag3To1 = '0') then 
                -- EbiTrBackoffv := "010";
                -- BackOffRegv   := "01";
                -- Flag3To2      <= '1'; 
                EbiTrBackoffv := "001";
                BackOffRegv   := "10";
                Flag3To1      <= '1'; 
              elsif (BackOffReg = "01" and Flag3To2 = '0' and 
                                                       Flag3To1 = '0') then
                -- EbiTrBackoffv := "001";
                -- BackOffRegv   := "10";
                -- Flag3To1      <= '1'; 
                EbiTrBackoffv := "010";
                BackOffRegv   := "01";
                Flag3To2      <= '1'; 
              else 
                if (Flag3To2 = '0' and Flag3To1 = '0')then
                  EbiTrBackoffv := "001";
                  BackOffRegv   := "10"; 
                  Flag3To2  <= '1'; 
                  Flag3To1  <= '1'; 
                  TriSim21  <= '0';
                end if;
              end if;
            elsif (DcrCnt2 = '0' and DcrCnt1 = '1') then
              if (BackOffReg = "10" and Flag3To2 = '0' and 
                                                       Flag3To1 = '0') then 
                -- EbiTrBackoffv := "010";
                -- BackOffRegv   := "01";
                -- Flag3To2      <= '1'; 
                EbiTrBackoffv := "001";
                BackOffRegv   := "10";
                Flag3To1      <= '1'; 
              elsif (BackOffReg = "01" and Flag3To2 = '0' and 
                                                       Flag3To1 = '0')then
                -- EbiTrBackoffv := "001";
                -- BackOffRegv   := "10";
                -- Flag3To1      <= '1'; 
                EbiTrBackoffv := "010";
                BackOffRegv   := "01";
                Flag3To2      <= '1'; 
              else 
                if (Flag3To2 = '0' and Flag3To1 = '0' )then
                  EbiTrBackoffv := "010";
                  BackOffRegv   := "01"; 
                  Flag3To2  <= '1'; 
                  Flag3To1  <= '1'; 
                  TriSim21  <= '0';
                end if;
              end if;
            elsif (DcrCnt2 = '1' and DcrCnt1 = '1') then
              if (BackOffReg = "10") then 
                EbiTrGntv     := "010";
                EbiTrBackoffv := "010";
                BackOffRegv   := "01";
              elsif (BackOffReg = "01")then   
                EbiTrGntv     := "001";
                EbiTrBackoffv := "001";
                BackOffRegv   := "10";
              end if;
            end if;  
          when "100" => 
            NState <= 4;
            EbiTrGntv     := "100";
            EbiTrBackoffv := "000";
            BackOffRegv   := "00";
            PTable(1)     <= PTable(0);
            PTable(0)     <= "100";
            TrigCnt2      := '0';
            TrigCnt1      := '0';
          when "101" =>
            NState <= 5;
            TrigCnt2      := '0';
            TrigCnt3      := '1';
            EbiTrBackoffv := "000";
            BackOffRegv   := "00";  
            if (EbiTrGntint = "010") then
              if (DcrCnt1 = '1') then
                EbiTrGntv := "001";
                PTable(1) <= PTable(0);
                PTable(0) <= "001"; 
                TrigCnt3  := '1';
              else
                if (PTable(0) = "001" or PTable(1) = "001") then
                  EbiTrGntv  := "100";
                  PTable(1)  <= PTable(0);
                  PTable(0)  <= "100";
                  TrigCnt1   := '1';
                elsif (PTable(0) = "100" or PTable(1) = "100") then
                  EbiTrGntv  := "001";
                  PTable(1)  <= PTable(0);
                  PTable(0)  <= "001";
                  TrigCnt3   := '1';
                end if;
              end if;
            end if; 
          when "110" =>
            NState <= 6;
            TrigCnt1      := '0';
            TrigCnt3      := '1';
            EbiTrBackoffv := "000";
            BackOffRegv   := "00";  
            if (EbiTrGntint = "001") then
              if (DcrCnt2 = '1') then
                EbiTrGntv := "010";
                PTable(1) <= PTable(0);
                PTable(0) <= "010"; 
                TrigCnt3  := '1';
              else
                if (PTable(0) = "100" or PTable(1) = "100") then
                  EbiTrGntv  := "010";
                  PTable(1)  <= PTable(0);
                  PTable(0)  <= "010";
                  TrigCnt3   := '1';
                elsif (PTable(0) = "010" or PTable(1) = "010") then
                  EbiTrGntv  := "100";
                  PTable(1)  <= PTable(0);
                  PTable(0)  <= "100";
                  TrigCnt2   := '1';
                end if;
              end if;
            end if; 
          when "111" => 
            NState  <= 7;
            if (EBITIMEOUTVALUE3 = "0000000000") then
              EbiTrBackoffv := PTable(0);
              BackOffRegv   := "11"; 
              DcrCnt3       <= '1';
            else
              TrigCnt3 := '1'; 
            end if; 
            if (DcrCnt2 = '1') then
              EbiTrBackoffv := PTable(0);
              BackOffRegv   := "10";
            elsif (DcrCnt1 = '1') then
              EbiTrBackoffv := PTable(0);
              BackOffRegv   := "01";
            end if;     
            Flag3To1 <= '0';
            Flag3To2 <= '0';
          when others =>
            null;
        end case;
      when 5 => 
        -- -------------------------------------------------------------
        -- STATE 5
        -- In this State there is Request from Port 3 and Port 1.
        -- -------------------------------------------------------------
        -- |------------|-----------------------------------------------
        -- | Next State |            Comments                        
        -- |------------|-----------------------------------------------
        -- |    000     | From state five if Port 3 and Port 1 requests 
        -- |            | are deasserted then next state is init state
        -- |            | (state eight).
        -- |------------|-----------------------------------------------
        -- |    001     | In this case Port 3 has deasserted the 
        -- |            | requested clear backoffreg and Grant is given
        -- |            | to Port 1.The Priority Table is update only
        -- |            | if the previous granted Port is not 1 ie 
        -- |            | Port 3.
        -- |------------|-----------------------------------------------
        -- |    100     | In this case Port 1 has deasserted the
        -- |            | requested clear backoffreg and Grant is given
        -- |            | to Port 1.The Priority Table is update only
        -- |            | if the previous granted Port is not 3 ie
        -- |            | Port 1.
        -- |------------|-----------------------------------------------
        -- |    101     | In this case if TrigSim31 flag is raised
        -- |            | then it is clear that Port 3 and Port 1 has
        -- |            | requested simultaneously.Time Out Counter
        -- |            | values are check for zero value and a backoff 
        -- |            | is raised to the port that was granted and
        -- |            | backoffreg is update with port id.
        -- |            | Four condition are checked in this case:
        -- |            | 1. DcrCnt3 = '1' and DcrCnt1 = '0'
        -- |            |    which indicates that Time out value of 
        -- |            |    counter 3 has reached zero.Backoff signal
        -- |            |    is raised to Port 1 and Backoffreg register
        -- |            |    is updated with Port 3 id.
        -- |            | 2. DcrCnt3 = '0' and DcrCnt1 = '1'
        -- |            |    which indicates that Time out value of 
        -- |            |    counter 1 has reached zero.Backoff signal
        -- |            |    is raised for Port 3 and Backoffreg
        -- |            |    register is updated with Port 3 id.
        -- |            | 3. DcrCnt3 = '1' and DcrCnt1 = '1'
        -- |            |    which indicates that Time out value of 
        -- |            |    counter 1 has reached zero and also
        -- |            |    Time out value of counter 3 has reached
        -- |            |    reached zero.This case can happen only
        -- |            |    when Port 2 has released the request and
        -- |            |    both the ports Time Out Counter value has
        -- |            |    reached zero.Now the Grant is given to 
        -- |            |    the Port whose id is in Backoffreg register.    
        -- |            |    The Backoffreg register contains the port 
        -- |            |    id whose Time Out Counter has reached zero 
        -- |            |    first.
        -- |------------|-----------------------------------------------
        -- |    010     | In this case both Port 3 and Port 1 requests
        -- |            | are deasserted and Port 2 has made a request.
        -- |            | The grant is given to Port 2.Backoffreg is 
        -- |            | cleared.PTable is updated.
        -- |------------|-----------------------------------------------
        -- |    110     | In this case clear the Trigger for Time Out
        -- |            | Counter for Port 1.Port 2 has raised the 
        -- |            | raised the request.If previously granted
        -- |            | port was 1 then Port 3 has to be granted and
        -- |            | Trigger has to raised for decrementing the
        -- |            | Time Out Counter of Port 2.If none of the 
        -- |            | above condition is true then a priority 
        -- |            | table decides which Port needs to be granted.
        -- |            | Ptbale is updated in either case.
        -- |------------|-----------------------------------------------
        -- |    011     | In this case clear the Trigger for Time Out
        -- |            | Counter for Port 3.Port 2 has raised the 
        -- |            | raised the request.If previously granted
        -- |            | port was 3 then Port 1 has to be granted and
        -- |            | Trigger has to raised for decrementing the
        -- |            | Time Out Counter of Port 2.If none of the 
        -- |            | above condition is true then a priority 
        -- |            | table decides which Port needs to be granted.
        -- |            | Ptbale is updated in either case.
        -- |------------|-----------------------------------------------
        -- |    111     | In this case Port 2 has raised the request
        -- |            | while Port 3 and Port 1 already have their 
        -- |            | requests raised.If Port 2 Time Out Counter 
        -- |            | value is zero and no backoff signal is 
        -- |            | generated then backoff signal is raised to
        -- |            | the Port that has been granted.Else Port 2
        -- |            | Time Out Counter is Triggered for 
        -- |            | decrementing.Also If Time Out Counter for 
        -- |            | port 3 or Port 1 has reached zero backoff 
        -- |            | is generated for the Port currently granted.
        -- |            | Backoffreg register is update with the port
        -- |            | id which determines Port to be grantied next.
        -- |------------|-----------------------------------------------
        ----------------------------------------------------------------
        case EbiReqv is
          when "000" =>
            NState  <= 8;
            EbiTrBackoffv := "000";
            BackOffRegv   := "00"; 
            EbiTrGntv     := "000";  
            TrigCnt3      := '0';
            TrigCnt2      := '0';
            TrigCnt1      := '0';
            Flag5To1      <= '0';
            Flag5To4      <= '0';
          when "001" =>
            NState   <= 1;
            EbiTrGntv     := "001";   
            EbiTrBackoffv := "000";
            BackOffRegv   := "00"; 
            if (EbiTrGntint /= "001") then  
              PTable(1) <= PTable(0);
              PTable(0) <= "001";
            end if; 
            Flag5To1 <= '0';
            Flag5To4 <= '0';
            TrigCnt3 := '0';
          when "010" =>
            NState <= 2;
            EbiTrGntv     := "010";   
            EbiTrBackoffv := "000";
            BackOffRegv   := "00"; 
            TrigCnt3      := '0';
            TrigCnt2      := '0';
            PTable(1)     <= PTable(0);
            PTable(0)     <= "010";
          when "011" => 
            NState <= 3;
            TrigCnt3      := '0';
            TrigCnt2      := '1';
            EbiTrBackoffv := "000";
            BackOffRegv   := "00"; 
            if (EbiTrGntint = "100") then
              if (DcrCnt1 = '1') then
                EbiTrGntv := "001";
                PTable(1) <= PTable(0);
                PTable(0) <= "001"; 
                TrigCnt2  := '1';
              else
                if (PTable(0) = "001" or PTable(1) = "001") then
                  EbiTrGntv  := "010";
                  PTable(1)  <= PTable(0);
                  PTable(0)  <= "010";
                  TrigCnt1   := '1';
                elsif (PTable(0) = "010" or PTable(1) = "010") then
                  EbiTrGntv  := "001";
                  PTable(1)  <= PTable(0);
                  PTable(0)  <= "001";
                  TrigCnt2   := '1';
                end if;
              end if;
            end if; 
          when "100" => 
            NState  <= 4;
            EbiTrGntv     := "100";   
            EbiTrBackoffv := "000";
            BackOffRegv   := "00"; 
            if (EbiTrGntint /= "100") then  
              PTable(1) <= PTable(0);
              PTable(0) <= "100";
            end if; 
            Flag5To1  <= '0';
            Flag5To4  <= '0';
            TrigCnt1  := '0';
          when "101" => 
            NState  <= 5;
            if (TriSim31 = '1') then
              if (EBITIMEOUTVALUE1 = "0000000000" and EbiTrGntint = "100") then
                EbiTrBackoffv := "100";
                BackOffRegv  := "01";
              end if;
              if (EBITIMEOUTVALUE3 = "0000000000" and EbiTrGntint = "001") then
                EbiTrBackoffv := "001";
                BackOffRegv  := "11";
              end if;
            end if;
            if (DcrCnt3 = '1' and DcrCnt1 = '0') then
              if (BackOffReg = "11" and Flag5To4 = '0' and 
                                                       Flag5To1 = '0') then 
                -- EbiTrBackoffv := "100";
                -- BackOffRegv   := "01";
                -- Flag5To4      <= '1'; 
                EbiTrBackoffv := "001";
                BackOffRegv   := "11";
                Flag5To1      <= '1'; 
              elsif (BackOffReg = "01" and Flag5To4 = '0' and 
                                                       Flag5To1 = '0')then
                -- EbiTrBackoffv := "001";
                -- BackOffRegv   := "11";
                -- Flag5To1      <= '1'; 
                EbiTrBackoffv := "100";
                BackOffRegv   := "01";
                Flag5To4      <= '1'; 
              else
                if (Flag5To4 = '0' and Flag5To1 = '0') then
                  EbiTrBackoffv := "001";
                  BackOffRegv   := "11"; 
                  Flag5To4  <= '1';
                  Flag5To1  <= '1';
                  TriSim31  <= '0';
                end if;
              end if;
            elsif (DcrCnt3 = '0' and DcrCnt1 = '1') then
              if (BackOffReg = "11" and Flag5To4 = '0' and 
                                                       Flag5To1 = '0') then 
                -- EbiTrBackoffv := "100";
                -- BackOffRegv   := "01";
                -- Flag5To4      <= '1';
                EbiTrBackoffv := "001";
                BackOffRegv   := "11";
                Flag5To1      <= '1';
              elsif (BackOffReg = "01" and Flag5To1 = '0' and 
                                                       Flag5To1 = '0')then
                -- EbiTrBackoffv := "001";
                -- BackOffRegv   := "11";
                -- Flag5To1      <= '1';
                EbiTrBackoffv := "100";
                BackOffRegv   := "01";
                Flag5To4      <= '1';
              else
                if (Flag5To4 = '0' and Flag5To1 = '0') then
                  EbiTrBackoffv := "100";
                  BackOffRegv   := "01"; 
                  Flag5To4      <= '1';
                  Flag5To1      <= '1';
                  TriSim31      <= '0';
                end if;
              end if;
            elsif (DcrCnt3 = '1' and DcrCnt1 = '1') then
              if (BackOffReg = "11") then 
                 EbiTrGntv     := "100";
                 EbiTrBackoffv := "100";
                 BackOffRegv := "01";
              elsif (BackOffReg = "01")then   
                 EbiTrGntv     := "001";
                 EbiTrBackoffv := "001";
                 BackOffRegv   := "11";
              end if;
            end if;  
          when "110" => 
            NState <= 6;
            TrigCnt1      := '0';
            TrigCnt2      := '1';
            EbiTrBackoffv := "000";
            BackOffRegv   := "00"; 
            if (EbiTrGntint = "001") then
              if (DcrCnt3 = '1') then
                EbiTrGntv := "100";
                PTable(1) <= PTable(0);
                PTable(0) <= "100"; 
                TrigCnt2  := '1';
              else
                if (PTable(0) = "100" or PTable(1) = "100") then
                  EbiTrGntv  := "010";
                  PTable(1)  <= PTable(0);
                  PTable(0)  <= "010";
                  TrigCnt3   := '1';
                elsif (PTable(0) = "010" or PTable(1) = "010") then
                  EbiTrGntv  := "100";
                  PTable(1)  <= PTable(0);
                  PTable(0)  <= "100";
                  TrigCnt2   := '1';
                end if;
              end if;
            end if; 
          when "111" =>
            NState <= 7;
            if (EBITIMEOUTVALUE2 = "0000000000") then
              EbiTrBackoffv := "010";
              BackOffRegv   := "01"; 
              DcrCnt2       <= '1';
            else
              TrigCnt2 := '1'; 
            end if; 
            if (DcrCnt3 = '1') then
              EbiTrBackoffv := PTable(0);
              BackOffRegv   := "11";
            elsif (DcrCnt1 = '1') then
              EbiTrBackoffv := PTable(0);
              BackOffRegv   := "01";
            end if;     
            Flag5To1 <= '0';
            Flag5To4 <= '0';
          when others =>
            null;
        end case;
      when 7 =>
        -- -------------------------------------------------------------
        -- STATE 7
        -- In this state Port 1,Port 2 and Port 3 has requested.These
        -- requests could be simultaneous requests or raised in
        -- any order.
        -- -------------------------------------------------------------
        -- |------------|-----------------------------------------------
        -- | Next State |            Comments
        -- |------------|-----------------------------------------------
        -- |    000     | When in State seven if all requests are 
        -- |            | deasserted next state will be state eight
        -- |            | (init state).
        -- |------------|-----------------------------------------------
        -- |    001     | In this case Port 3 and Port 2 has deasserted
        -- |            | the request.Port 1 is granted.Ptable is
        -- |            | updated is the previous port granted was not
        -- |            | Port 1.
        -- |------------|-----------------------------------------------
        -- |    010     | In this case Port 3 and Port 1 has deasserted
        -- |            | the request.Port 2 is granted.Ptable is
        -- |            | updated is the previous port granted was not
        -- |            | Port 2.
        -- |------------|-----------------------------------------------
        -- |    011     | Port 3 has released the request.The following
        -- |            | checks are made in order to grant either
        -- |            | Port 2 or Port 1.
        -- |            | 1. Check if Previous granted port was 3. 
        -- |            | 2. If true then check for Time Out counter 
        -- |            |    values of Port 1 and Port 2.If simultaneous
        -- |            |    request is raised from Port 1 and Port 2
        -- |            |    then select the port to be granted by 
        -- |            |    PTable.If not simultaneous triggred
        -- |            |    check which Port Time Out Counter has  
        -- |            |    reached zero and generate the grant.
        -- |            |    If none of the counter has reached 
        -- |            |    zero then PTable is used to decide
        -- |            |    which port needs to be granted.
        -- |            |    If Time Out Counter values of Port 1 and 
        -- |            |    Port 2 are not equal then check which 
        -- |            |    Ports time out counter has reached zero
        -- |            |    and generate the grant.If both Port 1 and 
        -- |            |    Port 2 Counter has reached zero then PTbale
        -- |            |    is again used to generate the grant.
        -- |            | 3. If previously granted port is not Port 3
        -- |            |    based on Backoffreg register value 
        -- |            |    generate backoff signal.
        -- |------------|-----------------------------------------------
        -- |    100     | In this case Port 2 and Port 1 has deasserted
        -- |            | the request.Port 3 is granted.Ptable is
        -- |            | updated is the previous port granted was not
        -- |            | Port 3.
        -- |------------|-----------------------------------------------
        -- |    101     | Port 2 has released the request.The following
        -- |            | checks are made in order to grant either
        -- |            | Port 3 or Port 1.
        -- |            | 1. Check if Previous granted port was 2. 
        -- |            | 2. If true then check for Time Out counter 
        -- |            |    values of Port 3 and Port 1.If simultaneous
        -- |            |    request is raised from Port 3 and Port 1
        -- |            |    then select the port to be granted by 
        -- |            |    PTable.If not simultaneous triggred
        -- |            |    check which Port Time Out Counter has  
        -- |            |    reached zero and generate the grant.
        -- |            |    If none of the counter has reached 
        -- |            |    zero then PTable is used to decide
        -- |            |    which port needs to be granted.
        -- |            |    If Time Out Counter values of Port 3 and 
        -- |            |    Port 1 are not equal then check which 
        -- |            |    Ports time out counter has reached zero
        -- |            |    and generate the grant.If both Port 3 and 
        -- |            |    Port 1 Counter has reached zero then PTbale
        -- |            |    is again used to generate the grant.
        -- |            | 3. If previously granted port is not Port 2
        -- |            |    based on Backoffreg register value 
        -- |            |    generate backoff signal.
        -- |------------|-----------------------------------------------
        -- |    110     | Port 1 has released the request.The following
        -- |            | checks are made in order to grant either
        -- |            | Port 3 or Port 2.
        -- |            | 1. Check if Previous granted port was 1. 
        -- |            | 2. If true then check for Time Out counter 
        -- |            |    values of Port 3 and Port 2.If simultaneous
        -- |            |    request is raised from Port 3 and Port 2
        -- |            |    then select the port to be granted by 
        -- |            |    PTable.If not simultaneous triggred
        -- |            |    check which Port Time Out Counter has  
        -- |            |    reached zero and generate the grant.
        -- |            |    If none of the counter has reached 
        -- |            |    zero then PTable is used to decide
        -- |            |    which port needs to be granted.
        -- |            |    If Time Out Counter values of Port 3 and 
        -- |            |    Port 2 are not equal then check which 
        -- |            |    Ports time out counter has reached zero
        -- |            |    and generate the grant.If both Port 3 and 
        -- |            |    Port 2 Counter has reached zero then PTbale
        -- |            |    is again used to generate the grant.
        -- |            | 3. If previously granted port is not Port 1
        -- |            |    based on Backoffreg register value 
        -- |            |    generate backoff signal.
        -- |------------|-----------------------------------------------
        -- |    111     | In this case following signals DcrCnt2,DcrCnt3
        -- |            | and DcrCnt1 are polled which when raised 
        -- |            | indicates that the Time Out Counter value 
        -- |            | has reached zero.If any of these signals
        -- |            | are high the backoff signal is raised to
        -- |            | the Port granted and the port id which has 
        -- |            | raised backoff is stored in Backoffreg.
        -- |------------|-----------------------------------------------
        ----------------------------------------------------------------
        case EbiReqv is
          when "000" =>
            NState  <= 8;
            EbiTrBackoffv := "000";
            BackOffRegv   := "00"; 
            EbiTrGntv     := "000";  
            TrigCnt1      := '0'; 
            TrigCnt2      := '0'; 
            TrigCnt3      := '0'; 
          when "001" =>
            NState  <= 1;
            TrigCnt3      := '0'; 
            TrigCnt2      := '0'; 
            EbiTrBackoffv := "000";
            BackOffRegv   := "00"; 
            EbiTrGntv     := "001";
            if (EbiTrGntint /= "001") then
              PTable(1) <= PTable(0);
              PTable(0) <= "001";
            end if;
          when "010" =>
            NState  <= 2;
            TrigCnt3      := '0'; 
            TrigCnt1      := '0'; 
            EbiTrBackoffv := "000";
            BackOffRegv   := "00"; 
            EbiTrGntv     := "010";  
            if (EbiTrGntint /= "010") then
              PTable(1) <= PTable(0);
              PTable(0) <= "010";
            end if; 
          when "100" =>
            NState  <= 4;
            TrigCnt2      := '0'; 
            TrigCnt1      := '0'; 
            EbiTrBackoffv := "000";
            BackOffRegv   := "00"; 
            EbiTrGntv     := "100";  
            if (EbiTrGntint /= "100") then
              PTable(1) <= PTable(0);
              PTable(0) <= "100";
            end if; 
          when "101" =>
            NState <= 5;
            if (EbiTrGntint = "010") then
              if (EBITIMEOUTVALUE3 = EBITIMEOUTVALUE1) then
                if (TriSim31 = '1') then
                  TriSim31 <= '0';
                  if (PTable(0) = "001" or PTable(1) = "001") then
                     EbiTrGntv     := "100";
                     EbiTrBackoffv := "000";
                     BackOffRegv   := "00"; 
                     PTable(1)     <= PTable(0);
                     PTable(0)     <= "100";
                     TrigCnt1      := '1';
                  elsif (PTable(0) = "100" or PTable(1) = "100") then
                     EbiTrGntv     := "001";
                     EbiTrBackoffv := "000";
                     BackOffRegv   := "00"; 
                     PTable(1)     <= PTable(0);
                     PTable(0)     <= "001";
                     TrigCnt3      := '1';
                  end if;
                else
                  if (DcrCnt3 = '1' and DcrCnt1 = '0') then
                    EbiTrGntv     := "100";
                    EbiTrBackoffv := "000";
                    BackOffRegv   := "00"; 
                    PTable(1) <= PTable(0);
                    PTable(0) <= "100";
                  elsif (DcrCnt3 = '0' and DcrCnt1 = '1') then
                    EbiTrGntv     := "001";
                    EbiTrBackoffv := "000";
                    BackOffRegv   := "00"; 
                    PTable(1) <= PTable(0);
                    PTable(0) <= "001";
                  elsif (DcrCnt3 = '0' and DcrCnt1 = '0') then
                    if (PTable(0) = "001" or PTable(1) = "001") then
                       EbiTrGntv     := "100";
                       -- EbiTrBackoffv := "000";
                       -- BackOffRegv   := "00"; 
                       PTable(1) <= PTable(0);
                       PTable(0) <= "100";
                    elsif (PTable(0) = "100" or PTable(1) = "100") then
                       EbiTrGntv   := "001";
                       -- EbiTrBackoffv := "000";
                       -- BackOffRegv   := "00"; 
                       PTable(1) <= PTable(0);
                       PTable(0) <= "001";
                    end if;
                  elsif (DcrCnt3 = '1' and DcrCnt1 = '1') then
                    if (PTable(0) = "001" or PTable(1) = "001") then
                       EbiTrGntv     := "100";
                       EbiTrBackoffv := "000";
                       BackOffRegv   := "00"; 
                       PTable(1) <= PTable(0);
                       PTable(0) <= "100";
                    elsif (PTable(0) = "100" or PTable(1) = "100") then
                       EbiTrGntv     := "001";
                       EbiTrBackoffv := "000";
                       BackOffRegv   := "00"; 
                       PTable(1) <= PTable(0);
                       PTable(0) <= "001";
                    end if;
                  end if;  
                end if;
              else
                if (DcrCnt3 = '1' and DcrCnt1 = '0') then
                  EbiTrGntv     := "100";
                  EbiTrBackoffv := "000";
                  BackOffRegv   := "00"; 
                  PTable(1) <= PTable(0);
                  PTable(0) <= "100";
                elsif (DcrCnt3 = '0' and DcrCnt1 = '1') then
                  EbiTrGntv     := "001";
                  EbiTrBackoffv := "000";
                  BackOffRegv   := "00"; 
                  PTable(1) <= PTable(0);
                  PTable(0) <= "001";
                elsif (DcrCnt3 = '0' and DcrCnt1 = '0') then
                  if (PTable(0) = "001" or PTable(1) = "001") then
                     EbiTrGntv   := "100";
                     PTable(1)   <= PTable(0);
                     PTable(0)   <= "100";
                  elsif (PTable(0) = "100" or PTable(1) = "100") then
                     EbiTrGntv   := "001";
                     PTable(1)   <= PTable(0);
                     PTable(0)   <= "001";
                  end if;
                elsif (DcrCnt3 = '1' and DcrCnt1 = '1') then
                  if (BackOffReg = "11") then 
                     EbiTrGntv     := "100";
                     EbiTrBackoffv := "000";
                     BackOffRegv   := "01";
                     PTable(1)     <= PTable(0);
                     PTable(0)     <= "100";   
                  elsif (BackOffReg = "01")then   
                     EbiTrGntv     := "001";
                     EbiTrBackoffv := "000";
                     BackOffRegv   := "11";
                     PTable(1)     <= PTable(0);
                     PTable(0)     <= "001";  
                  end if;
                end if;
              end if;  
            else
              TrigCnt2  := '0';
              if (BackOffRegv = "11") then
                EbiTrBackoffv := "001";
                BackOffRegv   := "00";
              elsif (BackOffRegv = "01") then
                EbiTrBackoffv := "100";
                BackOffRegv   := "00";
              elsif (BackOffRegv = "10") then
                if (DcrCnt3 = '1') then
                  EbiTrBackoffv := "001";
                  BackOffRegv   := "11" ;
                elsif (DcrCnt1 = '1') then
                  EbiTrBackoffv := "100";
                  BackOffRegv   := "01" ;
                else
                  EbiTrBackoffv := "000";
                  BackOffRegv   := "00" ;
                end if;
              end if;  
            end if; 
          when "011" =>
            NState    <= 3;
            if (EbiTrGntint = "100") then
              if (EBITIMEOUTVALUE2 = EBITIMEOUTVALUE1) then
                if (TriSim21 = '1') then
                  TriSim21 <= '0';
                  if (PTable(0) = "001" or PTable(1) = "001") then
                     EbiTrGntv     := "010";
                     EbiTrBackoffv := "000";
                     BackOffRegv   := "00"; 
                     PTable(1)     <= PTable(0);
                     PTable(0)     <= "010";
                     TrigCnt1      := '1';
                  elsif (PTable(0) = "010" or PTable(1) = "010") then
                     EbiTrGntv     := "001";
                     EbiTrBackoffv := "000";
                     BackOffRegv   := "00"; 
                     PTable(1)     <= PTable(0);
                     PTable(0)     <= "001";
                     TrigCnt2      := '1';
                  end if;
                else
                  if (DcrCnt2 = '1' and DcrCnt1 = '0') then
                    EbiTrGntv     := "010";
                    EbiTrBackoffv := "000";
                    BackOffRegv   := "00"; 
                    PTable(1)     <= PTable(0);
                    PTable(0)     <= "010";
                  elsif (DcrCnt2 = '0' and DcrCnt1 = '1') then
                    EbiTrGntv     := "001";
                    EbiTrBackoffv := "000";
                    BackOffRegv   := "00"; 
                    PTable(1)     <= PTable(0);
                    PTable(0)     <= "001";
                  elsif (DcrCnt2 = '0' and DcrCnt1 = '0') then
                    if (PTable(0) = "001" or PTable(1) = "001") then
                       EbiTrGntv     := "010";
                       PTable(1)     <= PTable(0);
                       PTable(0)     <= "010";
                    elsif (PTable(0) = "010" or PTable(1) = "010") then
                       EbiTrGntv     := "001";
                       PTable(1)     <= PTable(0);
                       PTable(0)     <= "001";
                    end if;
                  elsif (DcrCnt2 = '1' and DcrCnt1 = '1') then
                    if (PTable(0) = "001" or PTable(1) = "001") then
                       EbiTrGntv     := "010";
                       EbiTrBackoffv := "000";
                       BackOffRegv   := "00"; 
                       PTable(1)     <= PTable(0);
                       PTable(0)     <= "010";
                    elsif (PTable(0) = "010" or PTable(1) = "010") then
                       EbiTrGntv     := "001";
                       EbiTrBackoffv := "000";
                       BackOffRegv   := "00"; 
                       PTable(1)     <= PTable(0);
                       PTable(0)     <= "001";
                    end if;
                  end if;  
                end if;
              else
                if (DcrCnt2 = '1' and DcrCnt1 = '0') then
                  EbiTrGntv := "010";
                  if (DcrCnt3 = '1') then
                    EbiTrBackoffv := "010";
                  else
                    EbiTrBackoffv := "000";
                  end if;  
                  PTable(1) <= PTable(0);
                  PTable(0) <= "010";
                elsif (DcrCnt2 = '0' and DcrCnt1 = '1') then
                  EbiTrGntv     := "001";
                  EbiTrBackoffv := "000";
                  PTable(1)     <= PTable(0);
                  PTable(0)     <= "001";
                elsif (DcrCnt2 = '0' and DcrCnt1 = '0') then
                  if (PTable(0) = "001" or PTable(1) = "001") then
                     EbiTrGntv   := "010";
                     PTable(1)   <= PTable(0);
                     PTable(0)   <= "010";
                  elsif (PTable(0) = "010" or PTable(1) = "010") then
                     EbiTrGntv   := "001";
                     PTable(1)   <= PTable(0);
                     PTable(0)   <= "001";
                  end if;
                elsif (DcrCnt2 = '1' and DcrCnt1 = '1') then
                  if (BackOffReg = "10") then 
                     EbiTrGntv     := "010";
                     EbiTrBackoffv := "000";
                     BackOffRegv   := "01";
                     PTable(1)     <= PTable(0);
                     PTable(0)     <= "010";   
                  elsif (BackOffReg = "01")then   
                     EbiTrGntv     := "001";
                     EbiTrBackoffv := "000";
                     BackOffRegv   := "10";
                     PTable(1)     <= PTable(0);
                     PTable(0)     <= "001";  
                  end if;
                end if;
              end if;  
            else
              TrigCnt3      := '0';
              if (BackOffRegv = "10") then
                EbiTrBackoffv := "001";
                BackOffRegv   := "00";
              elsif (BackOffRegv = "01") then
                EbiTrBackoffv := "010";
                BackOffRegv   := "00";
              elsif (BackOffRegv = "11") then
                if (DcrCnt2 = '1') then
                  EbiTrBackoffv := "001";
                  BackOffRegv   := "10" ;
                elsif (DcrCnt1 = '1') then
                  EbiTrBackoffv := "010";
                  BackOffRegv   := "01" ;
                else
                  EbiTrBackoffv := "000";
                  BackOffRegv   := "00" ;
                end if;
              end if;  
            end if; 
          when "110" => 
            NState  <= 6;
            if (EbiTrGntint = "001") then
              if (EBITIMEOUTVALUE2 = EBITIMEOUTVALUE3) then 
                if (TriSim32 = '1') then
                  TriSim32 <= '0';
                  if (PTable(0) = "010" or PTable(1) = "010") then 
                     EbiTrGntv     := "100";
                     EbiTrBackoffv := "000";
                     BackOffRegv   := "00"; 
                     PTable(1)     <= PTable(0);
                     PTable(0)     <= "100";   
                     TrigCnt2      := '1';
                  elsif (PTable(0) = "100" or PTable(1) = "100") then   
                     EbiTrGntv     := "010";
                     EbiTrBackoffv := "000";
                     BackOffRegv   := "00"; 
                     PTable(1)     <= PTable(0);
                     PTable(0)     <= "010";  
                     TrigCnt3      := '1';
                  end if; 
                else
                  if (DcrCnt2 = '1' and DcrCnt3 = '0') then
                    EbiTrGntv     := "010";
                    EbiTrBackoffv := "000";
                    BackOffRegv   := "00"; 
                    PTable(1) <= PTable(0);
                    PTable(0) <= "010";  
                  elsif (DcrCnt2 = '0' and DcrCnt3 = '1') then
                    EbiTrGntv     := "100";
                    EbiTrBackoffv := "000";
                    BackOffRegv   := "00"; 
                    PTable(1)     <= PTable(0);
                    PTable(0)     <= "100";   
                  elsif (DcrCnt2 = '0' and DcrCnt3 = '0') then
                    if (PTable(0) = "010" or PTable(1) = "010") then 
                       EbiTrGntv     := "100";
                       PTable(1)     <= PTable(0);
                       PTable(0)     <= "100";   
                    elsif (PTable(0) = "100" or PTable(1) = "100") then   
                       EbiTrGntv     := "010";
                       PTable(1)     <= PTable(0);
                       PTable(0)     <= "010";  
                    end if; 
                  elsif (DcrCnt2 = '1' and DcrCnt3 = '1') then
                    if (PTable(0) = "010" or PTable(1) = "010") then 
                       EbiTrGntv     := "100";
                       EbiTrBackoffv := "000";
                       BackOffRegv   := "00"; 
                       PTable(1)     <= PTable(0);
                       PTable(0)     <= "100";   
                    elsif (PTable(0) = "100" or PTable(1) = "100") then   
                       EbiTrGntv     := "010";
                       EbiTrBackoffv := "000";
                       BackOffRegv   := "00"; 
                       PTable(1)     <= PTable(0);
                       PTable(0)     <= "010";  
                    end if; 
                  end if;   
                end if;
              else
                if (DcrCnt2 = '1' and DcrCnt3 = '0') then
                  EbiTrGntv     := "010";
                  EbiTrBackoffv := "000";
                  PTable(1)     <= PTable(0);
                  PTable(0)     <= "010";  
                elsif (DcrCnt2 = '0' and DcrCnt3 = '1') then
                  EbiTrGntv     := "100";
                  EbiTrBackoffv := "000";
                  PTable(1)     <= PTable(0);
                  PTable(0)     <= "100";   
                elsif (DcrCnt2 = '0' and DcrCnt3 = '0') then
                  if (PTable(0) = "010" or PTable(1) = "010") then 
                    EbiTrGntv := "100";
                    PTable(1) <= PTable(0);
                    PTable(0) <= "100";   
                  elsif (PTable(0) = "100" or PTable(1) = "100") then   
                    EbiTrGntv := "010";
                    PTable(1) <= PTable(0);
                    PTable(0) <= "010";  
                  end if; 
                elsif (DcrCnt2 = '1' and DcrCnt3 = '1') then
                  if (BackOffReg = "10") then 
                    EbiTrGntv     := "010";
                    EbiTrBackoffv := "000";
                    BackOffRegv   := "11";
                    PTable(1)     <= PTable(0);
                    PTable(0)     <= "010"; 
                  elsif (BackOffReg = "11")then   
                    EbiTrGntv     := "100";
                    EbiTrBackoffv := "000";
                    BackOffRegv   := "10";
                    PTable(1)     <= PTable(0);
                    PTable(0)     <= "100";  
                  end if;
                end if;
              end if;  
            else
              TrigCnt1      := '0';
              if (BackOffRegv = "10") then
                EbiTrBackoffv := "100";
                BackOffRegv   := "00";
              elsif (BackOffRegv = "11") then
                EbiTrBackoffv := "010";
                BackOffRegv   := "00";
              elsif (BackOffRegv = "01") then
                if (DcrCnt2 = '1') then
                  EbiTrBackoffv := "100";
                  BackOffRegv   := "10" ;
                elsif (DcrCnt3 = '1') then
                  EbiTrBackoffv := "010";
                  BackOffRegv   := "11" ;
                else
                  EbiTrBackoffv := "000";
                  BackOffRegv   := "00" ;
                end if;
              end if;  
            end if; 
          when "111" => 
            NState  <= 7;
            if (DcrCnt2 = '1' and EbiTrBackoffv /= PTable(0)) then
              EbiTrBackoffv := PTable(0);
              BackOffRegv   := "10";
              TriSim32      <= '0';
              TriSim21      <= '0';
            elsif (DcrCnt3 = '1' and EbiTrBackoffv /= PTable(0)) then
              EbiTrBackoffv := PTable(0);
              BackOffRegv   := "11";
              TriSim31      <= '0';
              TriSim32      <= '0';
            elsif (DcrCnt1 = '1' and EbiTrBackoffv /= PTable(0)) then
              EbiTrBackoffv := PTable(0);
              BackOffRegv   := "01";
              TriSim21      <= '0';
              TriSim31      <= '0';
            end if;     
          when others => 
            null;
        end case;
      when 2 => 
        -- -------------------------------------------------------------
        -- STATE 2
        -- In this state there is only one request from Port 2.
        -- -------------------------------------------------------------
        -- |------------|-----------------------------------------------
        -- | Next State |            Comments                        
        -- |------------|-----------------------------------------------
        -- |    000     | When fsm is in state two and goes back to init
        -- |            | state(state 8) indicates that Port 2 has             
        -- |            | released its request. 
        -- |------------|-----------------------------------------------
        -- |    001     | Port 2 has released the request and Port 1
        -- |            | has requested.Grant has to given to Port 1
        -- |            | updating the PTable(priority table).
        -- |------------|-----------------------------------------------
        -- |    010     | Port 2 maintains the Request.
        -- |------------|-----------------------------------------------
        -- |    011     | Port 2 continues to maitain the request and 
        -- |            | Port 1 has requested.If Port 1 Time Out 
        -- |            | Counter value is zero then Backoff for Port 2 
        -- |            | is raised on the next clock else TrigCnt1 
        -- |            | signal is raised for decrementing the Port 1
        -- |            | Time Out Counter.
        -- |------------|-----------------------------------------------
        -- |    100     | Port 2 has released the request and Port 3
        -- |            | has requested.Grant has to given to Port 3
        -- |            | updating the PTable(priority table).
        -- |------------|-----------------------------------------------
        -- |    110     | Port 2 continues to maitain the request and 
        -- |            | Port 3 has requested.If Port 3 Time Out 
        -- |            | Counter value is zero then Backoff for Port 2 
        -- |            | is raised on the next clock else TrigCnt3 
        -- |            | signal is raised for decrementing the Port 3
        -- |            | Time Out Counter.
        -- |------------|-----------------------------------------------
        -- |    101     | Port 2 has released the request and Port 1
        -- |            | and Port 3 has requested simultaneously.
        -- |            | Based on PTbale either Port 1 or Port 3 is
        -- |            | granted.
        -- |            | If Port 1 is Granted, Port 3 Time Out 
        -- |            | Counter is Triggered after checking for non
        -- |            | zero value.If the Port 3 Time Out Counter
        -- |            | value is zero then back off for Port 2 
        -- |            | is given on next clock in state 5.This is 
        -- |            | because Grant and Backoff should not be given 
        -- |            | on the same clock. 
        -- |            | If Port 3 is Granted, Port 1 Time Out 
        -- |            | Counter is Triggered after checking for non
        -- |            | zero value.If the Port 1 Time Out Counter
        -- |            | value is zero then back off for Port 3 
        -- |            | is given on next clock in state 5.This is 
        -- |            | because Grant and Backoff should not be given 
        -- |            | on the same clock. 
        -- |            | TrigSim31 signal is raised.
        -- |------------|-----------------------------------------------
        -- |    111     | Here Port 2 continues to hold the request and
        -- |            | port 1 and 3 simultaneously request.
        -- |            | TriSim31 signal is raised.
        -- |            | Backoff signal for Port 2 is generated 
        -- |            | on the next clock by checking for zero value 
        -- |            | of Time Out Counter of Port 1 or Port 3.
        -- |            | If Time Out Counter values of Port 1 or 
        -- |            | Port 3 are non zeros then Trigger signals
        -- |            | for appropriate Time Out Counter is raised
        -- |            | to decrement. 
        -- |------------|-----------------------------------------------
        ----------------------------------------------------------------
        case EbiReqv is
          when "000" => 
            NState  <= 8;
            EbiTrGntv     := "000";  
            EbiTrBackoffv := "000";
            BackOffRegv   := "00"; 
          when "001" => 
            NState  <= 1;
            EbiTrGntv := "001";
            PTable(1) <= PTable(0);
            PTable(0) <= "001";   
          when "010" =>
            NState  <= 2;
          when "011" => 
            NState  <= 3;
            EbiTrGntv := "010";  
            if (EBITIMEOUTVALUE1 = "0000000000") then
              EbiTrBackoffv := "010";
              BackOffRegv  := "01"; 
            else
              TrigCnt1 := '1'; 
            end if; 
          when "100" => 
            NState  <= 4;
            EbiTrGntv := "100";
            PTable(1) <= PTable(0);
            PTable(0) <= "100";   
          when "101" =>
            NState  <= 5;
            TriSim31 <= '1';
            if (PTable(0) = "001" or PTable(1) = "001") then
              if (TrigCnt3 = '0') then
                EbiTrGntv := "100";
                PTable(1) <= PTable(0);
                PTable(0) <= "100";
                if (EBITIMEOUTVALUE1 /= "0000000000") then
                  TrigCnt1 := '1'; 
                end if; 
              end if; 
            elsif (PTable(0) = "100" or PTable(1) = "100") then
              if (TrigCnt1 = '0') then
                EbiTrGntv := "001";
                PTable(1) <= PTable(0);
                PTable(0) <= "001";
                if (EBITIMEOUTVALUE3 /= "0000000000") then
                  TrigCnt3 := '1'; 
                end if; 
              end if; 
            end if;
          when "110" => 
            NState  <= 6;
            EbiTrGntv := "010";  
            if (EBITIMEOUTVALUE3 = "0000000000") then
              EbiTrBackoffv := "010";
              BackOffRegv   := "11"; 
            else
              TrigCnt3 := '1'; 
            end if; 
          when "111" => 
            NState  <= 7;   
            TriSim31  <= '1';
            if (EBITIMEOUTVALUE3 = "0000000000") then
              EbiTrBackoffv := "010";
              BackOffRegv   := "00"; 
            else
              TrigCnt3 := '1'; 
            end if; 
            if (EBITIMEOUTVALUE1 = "0000000000") then
              EbiTrBackoffv := "010";
              BackOffRegv   := "00"; 
            else
              TrigCnt1 := '1'; 
            end if; 
          when others => 
            null;
        end case;
      when 4 => 
        -- -------------------------------------------------------------
        -- STATE 4
        -- In this state there is only one request from Port 4.
        -- -------------------------------------------------------------
        -- |------------|-----------------------------------------------
        -- | Next State |            Comments                        
        -- |------------|-----------------------------------------------
        -- |    000     | When fsm is in state four and goes back to 
        -- |            | init state(state 8) indicates that Port 3 has
        -- |            | released its request.
        -- |------------|-----------------------------------------------
        -- |    100     | Port 3 maintains the Request.
        -- |------------|-----------------------------------------------
        -- |    010     | Port 3 has released the request and Port 2
        -- |            | has requested.Grant has to given to Port 2
        -- |            | updating the PTable(priority table).
        -- |------------|-----------------------------------------------
        -- |    110     | Port 3 continues to maitain the request and 
        -- |            | Port 2 has requested.If Port 2 Time Out 
        -- |            | Counter value is zero then Backoff for Port 3 
        -- |            | is raised on the next clock else TrigCnt2 
        -- |            | signal is raised for decrementing the Port 2
        -- |            | Time Out Counter.
        -- |------------|-----------------------------------------------
        -- |    001     | Port 3 has released the request and Port 1
        -- |            | has requested.Grant has to given to Port 1
        -- |            | updating the PTable(priority table).
        -- |------------|-----------------------------------------------
        -- |    101     | Port 3 continues to maitain the request and 
        -- |            | Port 1 has requested.If Port 1 Time Out 
        -- |            | Counter value is zero then Backoff for Port 3 
        -- |            | is raised on the next clock else TrigCnt1 
        -- |            | signal is raised for decrementing the Port 1
        -- |            | Time Out Counter.
        -- |------------|-----------------------------------------------
        -- |    011     | Port 3 has released the request and Port 2
        -- |            | and Port 1 has requested simultaneously.
        -- |            | Based on PTbale either Port 2 or Port 1 is
        -- |            | granted.
        -- |            | If Port 2 is Granted, Port 1 Time Out 
        -- |            | Counter is Triggered after checking for non
        -- |            | zero value.If the Port 1 Time Out Counter
        -- |            | value is zero then back off for Port 2 
        -- |            | is given on next clock in state 3.This is 
        -- |            | because Grant and Backoff should not be given 
        -- |            | on the same clock. 
        -- |            | If Port 1 is Granted, Port 2 Time Out 
        -- |            | Counter is Triggered after checking for non
        -- |            | zero value.If the Port 2 Time Out Counter
        -- |            | value is zero then back off for Port 1 
        -- |            | is given on next clock in state 3.This is 
        -- |            | because Grant and Backoff should not be given 
        -- |            | on the same clock. 
        -- |            | TrigSim21 signal is raised.
        -- |------------|-----------------------------------------------
        -- |    111     | Here Port 3 continues to hold the request and
        -- |            | port 2 and 1 simultaneously request.
        -- |            | TriSim21 signal is raised.
        -- |            | Backoff signal for Port 3 is generated 
        -- |            | on the next clock by checking for zero value 
        -- |            | of Time Out Counter of Port 2 or Port 1.
        -- |            | If Time Out Counter values of Port 2 or 
        -- |            | Port 1 are non zeros then Trigger signals
        -- |            | for appropriate Time Out Counter is raised
        -- |            | to decrement. 
        -- |------------|-----------------------------------------------
        ----------------------------------------------------------------
        case EbiReqv is
          when "000" => 
            NState <= 8;
            EbiTrGntv     := "000";  
            EbiTrBackoffv := "000";
            BackOffRegv   := "00"; 
          when "001" => 
            NState <= 1;
            EbiTrGntv := "001";
            PTable(1) <= PTable(0);
            PTable(0) <= "001";   
          when "010" => 
            NState <= 2;
            EbiTrGntv := "010";
            PTable(1) <= PTable(0);
            PTable(0) <= "010";   
          when "011" => 
            NState <= 3; 
            TriSim21  <= '1'; 
            if (PTable(0) = "001" or PTable(1) = "001") then
              if (TrigCnt2 = '0') then
                EbiTrGntv := "010";
                PTable(1) <= PTable(0);
                PTable(0) <= "010";
                if (EBITIMEOUTVALUE1 /= "0000000000") then
                  TrigCnt1  := '1';
                end if;
              end if;
            elsif (PTable(0) = "010" or PTable(1) = "010") then
              if (TrigCnt1 = '0') then
                EbiTrGntv := "001";
                PTable(1) <= PTable(0);
                PTable(0) <= "001";
                if (EBITIMEOUTVALUE2 /= "0000000000") then
                  TrigCnt2  := '1';
                end if;
              end if;
            end if;
          when "100" => 
            NState <= 4;
          when "101" =>
            NState <= 5;
            EbiTrGntv := "100";  
            if (EBITIMEOUTVALUE1 = "0000000000") then
              EbiTrBackoffv := "100";
              BackOffRegv   := "01"; 
            else
              TrigCnt1 := '1'; 
            end if; 
          when "110" => 
            NState <= 6;
            EbiTrGntv := "100";  
            if (EBITIMEOUTVALUE2 = "0000000000") then
              EbiTrBackoffv := "100";
              BackOffRegv   := "10"; 
            else
              TrigCnt2 := '1'; 
            end if; 
          when "111" => 
            NState <= 7;   
            TriSim21  <= '1';
            if (EBITIMEOUTVALUE2 = "0000000000") then
              EbiTrBackoffv := "100";
              BackOffRegv   := "00"; 
            else
              TrigCnt2 := '1'; 
            end if; 
            if (EBITIMEOUTVALUE1 = "0000000000") then
              EbiTrBackoffv := "100";
              BackOffRegv   := "00"; 
            else
              TrigCnt1 := '1'; 
            end if; 
          when others => 
            null;
        end case;
      when 6 => 
        -- -------------------------------------------------------------
        -- STATE 6
        -- In this State there is Request from Port 3 and Port 2.
        -- -------------------------------------------------------------
        -- |------------|-----------------------------------------------
        -- | Next State |            Comments                        
        -- |------------|-----------------------------------------------
        -- |    000     | From state six if Port 3 and Port 2 requests 
        -- |            | are deasserted then next state is init state
        -- |            | (state eight).Clear BackoffReg and all Trigger
        -- |            | counter signals.
        -- |------------|-----------------------------------------------
        -- |    010     | In this case Port 3 has deasserted the 
        -- |            | requested clear backoffreg and Grant is given
        -- |            | to Port 2.The Priority Table is update only
        -- |            | if the previous granted Port is not 2 ie 
        -- |            | Port 3.
        -- |------------|-----------------------------------------------
        -- |    100     | In this case Port 2 has deasserted the
        -- |            | requested clear backoffreg and Grant is given
        -- |            | to Port 3.The Priority Table is update only
        -- |            | if the previous granted Port is not 3 ie
        -- |            | Port 2.
        -- |------------|-----------------------------------------------
        -- |    110     | In this case if TrigSim32 flag is raised
        -- |            | then it is clear that Port 3 and Port 2 has
        -- |            | requested simultaneously.Time Out Counter
        -- |            | values are check for zero value and a backoff 
        -- |            | is raised to the port that was granted and
        -- |            | backoffreg is update with port id.
        -- |            | Four condition are checked in this case:
        -- |            | 1. DcrCnt2 = '1' and DcrCnt3 = '0'
        -- |            |    which indicates that Time out value of 
        -- |            |    counter 2 has reached zero.Backoff signal
        -- |            |    is raised to Port 3 and Backoffreg register
        -- |            |    is updated with Port 3 id.
        -- |            | 2. DcrCnt2 = '0' and DcrCnt3 = '1'
        -- |            |    which indicates that Time out value of 
        -- |            |    counter 3 has reached zero.Backoff signal
        -- |            |    is raised for Port 2 and Backoffreg
        -- |            |    register is updated with Port 3 id.
        -- |            | 3. DcrCnt2 = '1' and DcrCnt3 = '1'
        -- |            |    which indicates that Time out value of 
        -- |            |    counter 3 has reached zero and also
        -- |            |    Time out value of counter 2 has reached
        -- |            |    reached zero.This case can happen only
        -- |            |    when Port 1 has released the request and
        -- |            |    both the ports Time Out Counter value has
        -- |            |    reached zero.Now the Grant is given to 
        -- |            |    the Port whose id is in Backoffreg register.    
        -- |            |    The Backoffreg register contains the port 
        -- |            |    id whose Time Out Counter has reached zero 
        -- |            |    first.
        -- |------------|-----------------------------------------------
        -- |    001     | In this case both Port 3 and Port 2 requests
        -- |            | are deasserted and Port 1 has made a request.
        -- |            | The grant is given to Port 1.Backoffreg is 
        -- |            | cleared.PTable is updated.
        -- |------------|-----------------------------------------------
        -- |    101     | In this case clear the Trigger for Time Out
        -- |            | Counter for Port 2.Port 1 has raised the 
        -- |            | raised the request.If previously granted
        -- |            | port was 2 then Port 3 has to be granted and
        -- |            | Trigger has to raised for decrementing the
        -- |            | Time Out Counter of Port 3.If none of the 
        -- |            | above condition is true then a priority 
        -- |            | table decides which Port needs to be granted.
        -- |            | Ptbale is updated in either case.
        -- |------------|-----------------------------------------------
        -- |    011     | In this case clear the Trigger for Time Out
        -- |            | Counter for Port 3.Port 1 has raised the 
        -- |            | raised the request.If previously granted
        -- |            | port was 3 then Port 2 has to be granted and
        -- |            | Trigger has to raised for decrementing the
        -- |            | Time Out Counter of Port 2.If none of the 
        -- |            | above condition is true then a priority 
        -- |            | table decides which Port needs to be granted.
        -- |            | Ptbale is updated in either case.
        -- |------------|-----------------------------------------------
        -- |    111     | In this case Port 1 has raised the request
        -- |            | while Port 3 and Port 2 already have their 
        -- |            | requests raised.If Port 1 Time Out Counter 
        -- |            | value is zero and no backoff signal is 
        -- |            | generated then backoff signal is raised to
        -- |            | the Port that has been granted.Else Port 1
        -- |            | Time Out Counter is Triggered for 
        -- |            | decrementing.Also If Time Out Counter for 
        -- |            | port 3 or Port 2 has reached zero backoff 
        -- |            | is generated for the Port currently granted.
        -- |            | Backoffreg register is update with the port
        -- |            | id which determines Port to be grantied next.
        -- |------------|-----------------------------------------------
        ----------------------------------------------------------------
        case EbiReqv is
          when "000" =>
            NState <= 8;
            EbiTrBackoffv := "000";
            BackOffRegv   := "00"; 
            EbiTrGntv     := "000";  
            TrigCnt2      := '0';
            TrigCnt3      := '0';
            TrigCnt1      := '0';
            Flag6To4      <= '0';
            Flag6To2      <= '0';
          when "001" =>
            NState <= 1;
            EbiTrBackoffv := "000";
            BackOffRegv   := "00"; 
            EbiTrGntv     := "001";  
            PTable(1)     <= PTable(0);
            PTable(0)     <= "001";
            TrigCnt3      := '0';
            TrigCnt2      := '0';
          when "010" =>
            NState <= 2;
            EbiTrGntv     := "010";   
            EbiTrBackoffv := "000";
            BackOffRegv   := "00";
            if (EbiTrGntint /= "010") then  
              PTable(1)     <= PTable(0);
              PTable(0)     <= "010";
            end if;
            Flag6To4      <= '0';
            Flag6To2      <= '0';
            TrigCnt3      := '0';
          when "011" =>
            NState <= 3;
            TrigCnt1      := '1';
            TrigCnt3      := '0';
            EbiTrBackoffv := "000";
            BackOffRegv   := "00"; 
            if (EbiTrGntint = "100") then
              if (DcrCnt2 = '1') then
                EbiTrGntv := "010";
                PTable(1) <= PTable(0);
                PTable(0) <= "010"; 
                TrigCnt1  := '1';
              else
                if (PTable(0) = "001" or PTable(1) = "001") then
                  EbiTrGntv  := "010";
                  PTable(1)  <= PTable(0);
                  PTable(0)  <= "010";
                  TrigCnt1   := '1';
                elsif (PTable(0) = "010" or PTable(1) = "010") then
                  EbiTrGntv  := "001";
                  PTable(1)  <= PTable(0);
                  PTable(0)  <= "001";
                  TrigCnt2   := '1';
                end if;
              end if;
            end if; 
          when "100" => 
            NState <= 4;
            EbiTrGntv     := "100";
            EbiTrBackoffv := "000";
            BackOffRegv   := "00"; 
            if (EbiTrGntint /= "100") then  
              PTable(1) <= PTable(0);
              PTable(0) <= "100";
            end if;
            Flag6To4 <= '0';
            Flag6To2 <= '0';
            TrigCnt2 := '0';
          when "101" =>
            NState <= 5;
            TrigCnt1      := '1';
            TrigCnt2      := '0';
            EbiTrBackoffv := "000";
            BackOffRegv   := "00"; 
            if (EbiTrGntint = "010") then
              if (DcrCnt3 = '1') then
                EbiTrGntv := "100";
                PTable(1) <= PTable(0);
                PTable(0) <= "100"; 
                TrigCnt1  := '1';
              else
                if (PTable(0) = "001" or PTable(1) = "001") then
                  EbiTrGntv  := "100";
                  PTable(1)  <= PTable(0);
                  PTable(0)  <= "100";
                  TrigCnt1   := '1';
                elsif (PTable(0) = "100" or PTable(1) = "100") then
                  EbiTrGntv  := "001";
                  PTable(1)  <= PTable(0);
                  PTable(0)  <= "001";
                  TrigCnt3   := '1';
                end if;
              end if;
            end if; 
          when "110" => 
            NState  <= 6;
            if (TriSim32 = '1') then
              if (EBITIMEOUTVALUE2 = "0000000000" and EbiTrGntint = "100") then
                EbiTrBackoffv := "100";
                BackOffRegv   := "10";
              end if;
              if (EBITIMEOUTVALUE3 = "0000000000" and EbiTrGntint = "010") then
                EbiTrBackoffv := "010";
                BackOffRegv   := "11";
              end if;
            end if;
            if (DcrCnt2 = '1' and DcrCnt3 = '0') then
              if (BackOffReg = "10" and Flag6To4 = '0' and 
                                                       Flag6To2 = '0') then 
                -- EbiTrBackoffv := "010";
                -- BackOffRegv   := "11";
                -- Flag6To2      <= '1';
                EbiTrBackoffv := "100";
                BackOffRegv   := "10";
                Flag6To2      <= '1';
              elsif (BackOffReg = "11" and Flag6To4 = '0' and 
                                                       Flag6To2 = '0')then
                -- EbiTrBackoffv := "100";
                -- BackOffRegv   := "10";
                -- Flag6To4      <= '1';
                EbiTrBackoffv := "010";
                BackOffRegv   := "11";
                Flag6To4      <= '1';
              else 
                if (Flag6To4 = '0' and Flag6To2 = '0') then 
                  EbiTrBackoffv := "100";
                  BackOffRegv   := "10"; 
                  Flag6To2      <= '1';
                  Flag6To4      <= '1';
                  TriSim32      <= '0';
                end if;
              end if;
            elsif (DcrCnt2 = '0' and DcrCnt3 = '1') then
              if (BackOffReg = "10" and Flag6To4 = '0' and 
                                                       Flag6To2 = '0') then 
                -- EbiTrBackoffv := "010";
                -- BackOffRegv   := "11";
                -- Flag6To2      <= '1';
                EbiTrBackoffv := "100";
                BackOffRegv   := "10";
                Flag6To4      <= '1';
              elsif (BackOffReg = "11" and Flag6To4 = '0' and 
                                                       Flag6To2 = '0')then
                -- EbiTrBackoffv := "100";
                -- BackOffRegv   := "10";
                -- Flag6To4      <= '1';
                EbiTrBackoffv := "010";
                BackOffRegv   := "11";
                Flag6To2      <= '1';
              else
                if (Flag6To4 = '0' and Flag6To2 = '0') then 
                  EbiTrBackoffv := "010";
                  BackOffRegv   := "11"; 
                  Flag6To2      <= '1';
                  Flag6To4      <= '1';
                  TriSim32      <= '0';
                end if;
              end if;
            elsif (DcrCnt2 = '1' and DcrCnt3 = '1') then
              if (BackOffReg = "10") then 
                 EbiTrGntv     := "010";
                 EbiTrBackoffv := "010";
                 BackOffRegv   := "11";
              elsif (BackOffReg = "11")then   
                 EbiTrGntv     := "100";
                 EbiTrBackoffv := "100";
                 BackOffRegv   := "10";
              end if;
            end if;   
          when "111" => 
            NState  <= 7;   
            if (EBITIMEOUTVALUE1 = "0000000000") then
              EbiTrBackoffv := PTable(0);
              BackOffRegv   := "01"; 
              DcrCnt1       <= '1';
            else
              TrigCnt1 := '1'; 
            end if; 
            if (DcrCnt2 = '1') then
              EbiTrBackoffv := PTable(0);
              BackOffRegv := "10";
            elsif (DcrCnt3 = '1') then
              EbiTrBackoffv := PTable(0);
              BackOffRegv := "11";
            end if;     
            Flag6To4 <= '0';
            Flag6To2 <= '0';
          when others => 
            null;
        end case;
      when 8 => 
        -- -------------------------------------------------------------
        -- STATE 8
        -- In this state all the requests are deasserted.
        -- -------------------------------------------------------------
        -- In this state there is no requsets and the state machine 
        -- continues to be in this state until any one of the ports
        -- request.The table below illustrates the logic implemented
        -- depending on the requests from Port 1,Port 2 and Port 3.
        -- |------------|-----------------------------------------------
        -- | Next State |            Comments                           
        -- |------------|-----------------------------------------------
        -- |    000     | When there are no request no port are granted 
        -- |------------|-----------------------------------------------
        -- |    001     | When there is a request from Port 1 if the  
        -- |            | if the previous port granted is not Port 1 
        -- |            | the priority table is update.Grant is given
        -- |            | to Port 1.
        -- |------------|-----------------------------------------------
        -- |    010     | When there is a request from Port 2 if the 
        -- |            | if the previous port granted is not Port 2
        -- |            | the priority table is update.Grant is given
        -- |            | to Port 2.
        -- |------------|-----------------------------------------------
        -- |    011     | In this case there is a simulatneous request
        -- |            | from Port 1 and Port 2.Based on the Priority
        -- |            | table either Port 1 or Port 2 is granted.
        -- |            | If Port 1 is granted,Port 2 Internal Time Out
        -- |            | Counter is Triggered for decrementing if its
        -- |            | value is not zero.
        -- |            | If Port 2 is granted,Port 1 Internal Time Out
        -- |            | Counter is Triggered for decrementing if its
        -- |            | value is not zero.
        -- |            | TrigSim21 Flag is raised to indicate it is 
        -- |            | simultaneous request from Port 1 and Port 2
        -- |            | This signal is used in other state.
        -- |------------|-----------------------------------------------
        -- |    100     | When there is a request from Port 3 if the
        -- |            | if the previous port granted is not Port 3
        -- |            | the priority table is update.Grant is given
        -- |            | to Port 3.
        -- |------------|-----------------------------------------------
        -- |    101     | In this case there is a simulatneous request
        -- |            | from Port 3 and Port 1.Based on the Priority
        -- |            | table either Port 3 or Port 1 is granted.
        -- |            | If Port 3 is granted,Port 1 Internal Time Out
        -- |            | Counter is Triggered for decrementing if its
        -- |            | value is not zero.
        -- |            | If Port 1 is granted,Port 3 Internal Time Out
        -- |            | Counter is Triggered for decrementing if its
        -- |            | value is not zero.
        -- |            | TrigSim31 Flag is raised to indicate it is 
        -- |            | simultaneous request from Port 3 and Port 1
        -- |            | This signal is used in other state.
        -- |------------|-----------------------------------------------
        -- |    110     | In this case there is a simulatneous request
        -- |            | from Port 3 and Port 2.Based on the Priority
        -- |            | table either Port 3 or Port 2 is granted.
        -- |            | If Port 3 is granted,Port 2 Internal Time Out
        -- |            | Counter is Triggered for decrementing if its
        -- |            | value is not zero.
        -- |            | If Port 2 is granted,Port 3 Internal Time Out
        -- |            | Counter is Triggered for decrementing if its
        -- |            | value is not zero.
        -- |            | TrigSim32 Flag is raised to indicate it is 
        -- |            | simultaneous request from Port 3 and Port 2
        -- |            | This signal is used in other state.
        -- |------------|-----------------------------------------------
        -- |    111     | In this case there is simultaneous request
        -- |            | from Port 1,Port 2 and Port 3.Based on the 
        -- |            | priority table one of the ports is granted
        -- |            | (least used) is granted.
        -- |            | If Port 1 Granted:
        -- |            | Port 2 and Port 3 Time Out Counter is checked
        -- |            | for non zero value and Triggred for 
        -- |            | decrementing.
        -- |            | If Port 2 Granted:
        -- |            | Port 1 and Port 3 Time Out Counter is checked
        -- |            | for non zero value and Triggred for 
        -- |            | decrementing.
        -- |            | If Port 3 Granted:
        -- |            | Port 2 and Port 1 Time Out Counter is checked
        -- |            | for non zero value and Triggred for 
        -- |            | decrementing.
        ----------------------------------------------------------------
        case EbiReqv is
          when "000" => 
            NState  <= 8;
            TriSim32  <= '0'; 
            TriSim31  <= '0'; 
            TriSim21  <= '0'; 
          when "001" =>
            NState    <= 1;
            EbiTrGntv := "001";
            if (PTable(0) /= "001") then
              PTable(1) <= PTable(0);
              PTable(0) <= "001";
            end if;
          when "010" => 
            NState    <= 2;
            EbiTrGntv := "010";
            if (PTable(0) /= "010") then
              PTable(1) <= PTable(0);
              PTable(0) <= "010";
            end if;
          when "100" =>
            NState    <= 4;
            EbiTrGntv := "100";
            if (PTable(0) /= "100") then
              PTable(1) <= PTable(0);
              PTable(0) <= "100";
            end if;
          when "011" => 
            NState   <= 3;
            TriSim21 <= '1';
            if (PTable(0) = "100") then
              if (PTable(0) = "001" or PTable(1) = "001") then
                if (TrigCnt2 = '0') then
                  EbiTrGntv := "010";
                  PTable(1) <= PTable(0);
                  PTable(0) <= "010";
                  if (EBITIMEOUTVALUE1 /= "0000000000") then
                    TrigCnt1 := '1';
                  end if;
                end if;
              elsif (PTable(0) = "010" or PTable(1) = "010") then
                if (TrigCnt1 = '0') then
                  EbiTrGntv := "001";
                  PTable(1) <= PTable(0);
                  PTable(0) <= "001";
                  if (EBITIMEOUTVALUE2 /= "0000000000") then
                    TrigCnt2 := '1';
                  end if;
                end if;
              end if;
            else
              if (PTable(0) = "001") then
                EbiTrGntv := "010";
                PTable(1) <= PTable(0);
                PTable(0) <= "010";
                if (EBITIMEOUTVALUE1 /= "0000000000") then
                  TrigCnt1 := '1';
                end if;
              elsif (PTable(0) = "010") then
                EbiTrGntv := "001";
                PTable(1) <= PTable(0);
                PTable(0) <= "001";
                if (EBITIMEOUTVALUE2 /= "0000000000") then
                  TrigCnt2 := '1';
                end if;
              end if;
            end if;
          when "101" => 
            NState  <= 5;
            TriSim31 <= '1';
            if (PTable(0) = "010") then
              if (PTable(0) = "001" or PTable(1) = "001") then
                if (TrigCnt3 = '0') then
                  EbiTrGntv := "100";
                  PTable(1) <= PTable(0);
                  PTable(0) <= "100";
                  if (EBITIMEOUTVALUE1 /= "0000000000") then
                    TrigCnt1 := '1';
                  end if;
                end if;
              elsif (PTable(0) = "100" or PTable(1) = "100") then
                if (TrigCnt1 = '0') then
                  EbiTrGntv := "001";
                  PTable(1) <= PTable(0);
                  PTable(0) <= "001";
                  if (EBITIMEOUTVALUE3 /= "0000000000") then
                    TrigCnt3 := '1';
                  end if;
                end if;
              end if;
            else
              if (PTable(0) = "001") then
                EbiTrGntv := "100";
                PTable(1) <= PTable(0);
                PTable(0) <= "100";
                if (EBITIMEOUTVALUE1 /= "0000000000") then
                  TrigCnt1 := '1';
                end if;
              elsif (PTable(0) = "100") then
                EbiTrGntv := "001";
                PTable(1) <= PTable(0);
                PTable(0) <= "001";
                if (EBITIMEOUTVALUE3 /= "0000000000") then
                  TrigCnt3 := '1';
                end if;
              end if;
            end if;
          when "110" => 
            NState  <= 6;
            TriSim32 <= '1';
            if (PTable(0) = "001") then
              if (PTable(0) = "010" or PTable(1) = "010") then
                if (TrigCnt3 = '0') then
                  EbiTrGntv := "100";
                  PTable(1) <= PTable(0);
                  PTable(0) <= "100";
                  if (EBITIMEOUTVALUE2 /= "0000000000") then
                    TrigCnt2 := '1';
                  end if;
                end if;
              elsif (PTable(0) = "100" or PTable(1) = "100") then
                if (TrigCnt2 = '0') then
                  EbiTrGntv := "010";
                  PTable(1) <= PTable(0);
                  PTable(0) <= "010";
                  if (EBITIMEOUTVALUE3 /= "0000000000") then
                    TrigCnt3 := '1';
                  end if;
                end if;
              end if;
            else
              if (PTable(0) = "100") then
                EbiTrGntv := "010";
                PTable(1) <= PTable(0);
                PTable(0) <= "010";
                if (EBITIMEOUTVALUE3 /= "0000000000") then
                  TrigCnt3 := '1';
                end if;
              elsif (PTable(0) = "010") then
                EbiTrGntv := "100";
                PTable(1) <= PTable(0);
                PTable(0) <= "100";
                if (EBITIMEOUTVALUE2 /= "0000000000") then
                  TrigCnt2 := '1';
                end if;
              end if;
            end if;
          when "111" =>
            NState  <= 7;
            TriSim32  <= '1'; 
            TriSim31  <= '1'; 
            TriSim21  <= '1'; 
            case PTable(0) is
              when "001" =>
                case PTable(1) is
                  when "001" =>
                  when "010" =>
                    TrigCnt1 := '1';
                    TrigCnt2 := '1';
                    EbiTrGntv := "100";
                    PTable(1) <= PTable(0);
                    PTable(0) <= "100";
                    if (EBITIMEOUTVALUE2 = "0000000000") then
                      EbiTrBackoffv := "100";
                      BackOffRegv  := "10";
                    end if;
                    if (EBITIMEOUTVALUE1 = "0000000000") then
                      EbiTrBackoffv := "100";
                      BackOffRegv  := "01";
                    end if;
                  when "100" =>
                    TrigCnt1 := '1';
                    TrigCnt3 := '1';
                    EbiTrGntv := "010";
                    PTable(1) <= PTable(0);
                    PTable(0) <= "010";
                    if (EBITIMEOUTVALUE1 = "0000000000") then
                      EbiTrBackoffv := "010";
                      BackOffRegv  := "01";
                    end if;
                    if (EBITIMEOUTVALUE3 = "0000000000") then
                      EbiTrBackoffv := "010";
                      BackOffRegv  := "11";
                    end if;
                  when others =>
                    null;
                end case;  
              when "010" =>
                case PTable(1) is
                  when "001" =>
                    TrigCnt1 := '1';
                    TrigCnt2 := '1';
                    EbiTrGntv := "100";
                    PTable(1) <= PTable(0);
                    PTable(0) <= "100";
                    if (EBITIMEOUTVALUE2 = "0000000000") then
                      EbiTrBackoffv := "100";
                      BackOffRegv  := "10";
                    end if;
                    if (EBITIMEOUTVALUE1 = "0000000000") then
                      EbiTrBackoffv := "100";
                      BackOffRegv  := "01";
                    end if;
                  when "010" =>
                  when "100" =>
                    TrigCnt2 := '1';
                    TrigCnt3 := '1';
                    EbiTrGntv := "001";
                    PTable(1) <= PTable(0);
                    PTable(0) <= "001";
                    if (EBITIMEOUTVALUE2 = "0000000000") then
                      EbiTrBackoffv := "001";
                      BackOffRegv  := "10";
                    end if;
                    if (EBITIMEOUTVALUE3 = "0000000000") then
                      EbiTrBackoffv := "001";
                      BackOffRegv  := "11";
                    end if;
                  when others =>
                    null;
                end case;  
              when "100" =>
                case PTable(1) is
                  when "001" =>
                    TrigCnt1 := '1';
                    TrigCnt3 := '1';
                    EbiTrGntv := "010";
                    PTable(1) <= PTable(0);
                    PTable(0) <= "010";
                    if (EBITIMEOUTVALUE1 = "0000000000") then
                      EbiTrBackoffv := "010";
                      BackOffRegv  := "01";
                    end if;
                    if (EBITIMEOUTVALUE3 = "0000000000") then
                      EbiTrBackoffv := "010";
                      BackOffRegv  := "11";
                    end if;
                  when "010" =>
                    TrigCnt2 := '1';
                    TrigCnt3 := '1';
                    EbiTrGntv := "001";
                    PTable(1) <= PTable(0);
                    PTable(0) <= "001";
                    if (EBITIMEOUTVALUE2 = "0000000000") then
                      EbiTrBackoffv := "001";
                      BackOffRegv  := "10";
                    end if;
                    if (EBITIMEOUTVALUE3 = "0000000000") then
                      EbiTrBackoffv := "001";
                      BackOffRegv  := "11";
                    end if;
                  when "100" =>
                  when others =>
                    null;
                end case;  
              when others =>
                null ;
            end case;
          when others =>
            null;
        end case; 
      when others => 
        null;  
    end case;
    -- -----------------------------------------------------------------
    -- Assiging Local variable to Signals
    -- ------------------------------------------------------------------
    EbiTrGnt     <= EbiTrGntv;
    EbiTrBackoff <= EbiTrBackoffv;
    BackOffReg   <= BackOffRegv;  
    EbiTrGntint  <= EbiTrGntv;
    -- -----------------------------------------------------------------
    -- Condition to Clear the Trigger to Internal Time Out Counter Port 2
    -- -----------------------------------------------------------------
    if (EbiTrGntv(1) = TrigCnt2) then
      TrigCnt2 := '0';
    end if;
    -- -----------------------------------------------------------------
    -- Condition to Clear the Trigger to Internal Time Out Counter Port 1
    -- -----------------------------------------------------------------
    if (EbiTrGntv(0) = TrigCnt1) then
      TrigCnt1 := '0';
    end if;
    -- -----------------------------------------------------------------
    -- Condition to Clear the Trigger to Internal Time Out Counter Port 3
    -- -----------------------------------------------------------------
    if (EbiTrGntv(2) = TrigCnt3) then
      TrigCnt3 := '0';
    end if;
    -- -----------------------------------------------------------------
    -- Enabling Logic for Decrementing Internal Time Out Counter Port 1
    -- and raising the DcrCnt1 signal when the counter reaches 0 for
    -- generating the Backoff signal.The Counter gets reloaded under the 
    -- following conditions:
    -- 1. When the previously granted port releases the request before
    --    the Time Out Counter has reached zero
    -- 2. When the Port that has generated the Backoff signal is granted.
    -- -----------------------------------------------------------------
    if (TrigCnt1 = '1') then
      if (CounterOne = "0000000001") then
        DcrCnt1 <= '1';
        CounterOne <= CounterOne;
      else
        CounterOne <= CounterOne - '1';
      end if;
    else
      CounterOne <= EBITIMEOUTVALUE1;
      DcrCnt1 <= '0';
    end if;
    -- -----------------------------------------------------------------
    -- Enabling Logic for Decrementing Internal Time Out Counter Port 2
    -- and raising the DcrCnt1 signal when the counter reaches 0 for
    -- generating the Backoff signal.The Counter gets reloaded under the
    -- following conditions:
    -- 1. When the previously granted port releases the request before
    --    the Time Out Counter has reached zero
    -- 2. When the Port that has generated the Backoff signal is granted.
    -- -----------------------------------------------------------------
    if (TrigCnt2 = '1') then
      if (CounterTwo = "0000000001") then
        DcrCnt2 <= '1';
        CounterTwo <= CounterTwo;
      else
        CounterTwo <= CounterTwo - '1';
      end if;
    else
      CounterTwo <= EBITIMEOUTVALUE2;
      DcrCnt2 <= '0';
    end if;
    -- -----------------------------------------------------------------
    -- Enabling Logic for Decrementing Internal Time Out Counter Port 3
    -- and raising the DcrCnt1 signal when the counter reaches 0 for
    -- generating the Backoff signal.The Counter gets reloaded under the
    -- following conditions:
    -- 1. When the previously granted port releases the request before
    --    the Time Out Counter has reached zero
    -- 2. When the Port that has generated the Backoff signal is granted.
    -- -----------------------------------------------------------------
    if (TrigCnt3 = '1') then
      if (CounterThr = "0000000001") then
        DcrCnt3 <= '1';
        CounterThr <= CounterThr;
      else
        CounterThr <= CounterThr - '1';
      end if;
    else
      CounterThr <= EBITIMEOUTVALUE3;
      DcrCnt3 <= '0';
    end if;
  end if;
end process p_main;
-- -----------------------------------------------------------------------------
-- Next State Assignment 
-- -----------------------------------------------------------------------------
CState <= NState;    

end behaviour;

-- --================================== End ==================================--
