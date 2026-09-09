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
-- File Name              : buswatch.vhd.rca
-- File Revision          : 1.1
--
-- Release Information    : PrimeCell(TM)-GLOBAL-REL1v5
--
-- ---------------------------------------------------------------------
-- Purpose :
--           Protocol checker for AHB Slave testbench
--
-- --=================================================================--

library IEEE;
use     IEEE.std_logic_1164.all;
use     IEEE.std_logic_arith.all;

library common;
use     common.defs.all;

library buswatcher;
use buswatcher.busw_pck.all;

-- ---------------------------------------------------------------------

entity buswatch is
  generic (
           Tclkl           : time;
           Tclkh           : time;
           tovdr           : time;
           tohdr           : time;
           tovrsp          : time;
           tohrsp          : time;
           tovrdy          : time;
           tohrdy          : time;
           tovsplt         : time;
           tohsplt         : time;
           Verbosity       : boolean;
           SuppressOnReset : boolean
          );
  port (
        HADDR       : in T_addr;
        -- AHB Address bus
        HRESETn     : in T_line;
        -- Active low system reset 
        HCLK        : in std_logic;
        -- The main bus clock
        HRDATA      : in T_data;
        -- AHB Read Data 
        DelHWRITE   : in T_line;
        -- Delayed AHB Write
        HTRANS      : in T_trans;
        -- AHB Transfer type signal 
        HMASTER     : in T_master;
        -- AHB Master 
        HSPLIT      : in std_logic_vector(15 downto 0);
        -- AHB HSPLIT bus 
        HREADY      : in T_line;
        -- AHB Transfer done signal
        HRESP       : in T_resp
        -- AHB Response 
       );  
end buswatch;
-- ---------------------------------------------------------------------
--
--                               Bus_watch
--                               =========
--
-- ---------------------------------------------------------------------
--
-- Overview
-- ========
-- This module implements the protocol checks for the AHB slave's
-- output signals and will provide warnings and error messages if
-- it finds some mismatch.
-- It will continously check the signals for high impedance state and
-- will check for unknown condition at the posedge of each clock.
-- It ensures the slave's zero wait state OK  response for BUSY and
-- IDLE cycle.
-- HSPLITx lines are continously polled and if it is driven then it
-- will ensure that it is driven only for one clock and that particular
-- master has been given a split response before.
 
-- --========================== ARCHITECTURE =========================--
--
architecture behavioural of buswatch is
--
-- ---------------------------------------------------------------------
-- Constant declarations
-- ---------------------------------------------------------------------
-- Ensures 2 cycle ERROR, SPLIT or RETRY response
constant  readyerr0_msg      : string
                             :="BUSWHREADY2: HREADY not asserted in " &
                               "second cycle of ERROR, RETRY or" & 
                               " SPLIT response";

constant  readyerr1_msg      : string
                             :="BUSHREADY1: HREADY not de-asserted in" 
                               & "first cycle of ERROR, RETRY or" &
                               "SPLIT response";

constant  readyerr_msg       : string
                             := "BUSWIBOWS : HREADY not asserted in a "
                                & "BUSY or IDLE transfer";

constant  resperr_msg        : string
                             := "BUSWIBOK : HRESP not driven to OK in "
                                & "a BUSY or IDLE transfer";

constant  ready_msg          : string
                             := "HSIBC : Correct execution of IDLE "
                                & "or BUSY transfer";
 
-- Ensures HRESP remains same in last 2 cycles of ERROR, RETRY or SPLIT 
constant  resperr1_msg       : string
                             :="BUSWHRESP1: HRESP not driven to " &
                               "ERROR, RETRY or SPLIT response in the"
                               &" previous cycle of transfer";

-- Ensures HRESP remains same as in previous cycle of ERROR, RETRY or
-- SPLIT 
constant  resperr2_msg      : string :="BUSWHRESP2: HRESP changed in " &
                                       "second cycle of " &
                                       "ERROR, RETRY or SPLIT response";
-- Correct execution of HSP transfer
constant  split_msg         : string
                            :="BUSWSPC : Correct assertion of " &
                              "HSPLIT for HMASTER who got SPLIT";

-- Ensures Master has been given a split response 
constant  spliterr_msg      : string
                            :="BUSWSPERR : Master is not given " &
                              "SPLIT, but it's HSPLIT is asserted";

-- Ensures HSPLIT is driven for only 1 clock
constant  splitsameerr_msg  : string
                            := "BUSWSPSM :Same HSPLIT lines driven" & 
                               " consecutively";

-- ---------------------------------------------------------------------
-- Signal declarations
-- ---------------------------------------------------------------------
signal Write       : boolean := FALSE; -- Denotes Write transfer
signal Waited      : boolean := FALSE; -- Wait for end of transfer 
signal Resetover   : boolean := FALSE; -- Reset cycle over
signal Resetstrd   : std_logic;        -- Latch reset status;
signal Startcheck  : std_logic := '0'; -- Denotes HRESP =/ OK 
signal DelHREADY   : std_logic;        -- Delayed HREADY signal
signal SPLIT       : std_logic_vector(15 downto 0)
                                                 := "0000000000000000"; 
                                       -- Storing SPLIT status
signal DelHTRANS   : std_logic_vector(1 downto 0);  -- Delayed HTRANS
signal Expresponse : std_logic_vector(1 downto 0);  -- Expected response
signal Delresponse : std_logic_vector(1 downto 0);  -- Delayed response
signal DelMASTER   : std_logic_vector(3 downto 0)  := "1111";
                                                    -- Delayed HMASTER
signal DelHSPLIT   : std_logic_vector(15 downto 0); -- Delayed HSPLIT 

-- ---------------------------------------------------------------------
-- Main body of code
-- =================
-- ---------------------------------------------------------------------

begin

-- ---------------------------------------------------------------------
-- Latching when first HRESETn is over
-- Protocol checking enabled after first reset is over
-- ---------------------------------------------------------------------
p_resetstore : process (HCLK, HRESETn)
begin
  if (HCLK'event and HCLK = '1' and HRESETn = '0') then
    Resetstrd <= '1';
  end if;
  if (HRESETn = '1' and Resetstrd = '1') then
    Resetover <= TRUE;
  end if;
end process p_resetstore;

-- ---------------------------------------------------------------------
--  HRESP checking
--  Checks for timing parameters of HRESP and also whether it goes to
-- high impedance state or to unknown condition at positive edge of
-- HCLK.
-- ---------------------------------------------------------------------
p_CheckHRESP : process (HCLK, HRESETn, HRESP)
begin
  --  Check HRESP is valid at rising clock edge
  if (HCLK'event and HCLK = '1' and Resetover) then
    if (HRESETn = '1' or SuppressOnReset = FALSE) then
      X_chk(HRESP, msg_RespXrclk );
    end if;
  end if;

  hiZ_chk (HRESP, msg_RespZ); 
  --  Timing Checks
  if (HRESETn = '1' or SuppressOnReset = FALSE) then
    --  Check HRESP hold from falling clock edge
    if HRESP'event then
      if ((HCLK = '1') and (HCLK'last_event < tohrsp)) then
        FlashHoldErr("HRESP", HADDR);
      end if;
    end if;
  end if;
end process p_CheckHRESP;

-- ---------------------------------------------------------------------
-- The following block does the valid checks on the
-- master-output-signals.
-- ---------------------------------------------------------------------
p_vldchk : process (HCLK)
begin
  if (HCLK'event and (HCLK = '1') and ResetOver) then
    --  Check HRESP valid from falling clock edge 
    if (not(HRESP'stable(Tclkl + Tclkh-tovrsp))) then
      FlashValidErr("HRESP", (now - Tclkl - Tclkh));
    end if;
 
    if (not(HREADY'stable(Tclkl + Tclkh-tovrdy))) then
      FlashValidErr("HREADY", (now - Tclkl - Tclkh));
    end if;
 
    if (not(HRDATA'stable(Tclkl + Tclkh-Tovdr)) and not(Write)) then
      FlashValidErr("HRDATA", (now - Tclkl - Tclkh));
    end if;
    
    if (not(HSPLIT'stable(Tclkl + Tclkh-tovsplt))) then
      FlashValidErr("HSPLIT", (now - Tclkl - Tclkh));
    end if;

  end if;
end process p_vldchk;
 
-- ---------------------------------------------------------------------
--  HREADY checking
--  Checks for timing parameters of HREADY and also whether it goes to
-- high impedance state or to unknown condition at pos-edge of HCLK.
-- ---------------------------------------------------------------------
p_Check_HREADY : process (HCLK, HRESETn, HREADY)
begin
  --  Check HREADY is valid at rising clock edge
  if (HCLK'event and HCLK = '1'and Resetover) then
    if (HRESETn = '1' or SuppressOnReset = FALSE) then
      X_chk(HREADY, msg_ReadyXrclk );
    end if;
  end if;

  hiZ_chk (HREADY, msg_ReadyZ); 

  --  Timing Checks
  if (HRESETn = '1' or SuppressOnReset = FALSE) then
  -- Check HREADY hold time from rising clock edge
    if HREADY'event then
      if ((HCLK = '1') and (HCLK'last_event < tohrdy)) then
        FlashHoldErr("HREADY", HADDR);
      end if;
    end if; 
  end if;
end process p_Check_HREADY;

-- ---------------------------------------------------------------------
--  HSPLITx checking
--  Checks for timing parameters of HSPLITx and also whether it goes to 
-- high impedance state or to unknown condition at pos-edge of HCLK.
-- ---------------------------------------------------------------------
p_Check_HSPLIT : process (HCLK, HSPLIT)
begin
  if (HCLK'event and HCLK = '1'and Resetover) then
    if ((HRESETn = '1' or SuppressOnReset = FALSE)) then
      X_chk(HSPLIT,msg_HSPXrclk);
    end if;
  end if;

  hiZ_chk (HSPLIT,  msg_HSplitZ);
       
  --  Timing Checks (only on reads)
  if (HRESETn = '1' or SuppressOnReset = FALSE) then
    if HSPLIT'event then
      if ((HCLK = '1') and (HCLK'last_event < tohsplt)) then
        FlashHoldErr("HSPLIT", HADDR);
      end if;
    end if;
  end if;
end process p_Check_HSPLIT;

-- ---------------------------------------------------------------------
--  HRDATA checking
--  Checks for timing parameters of HRDATA and also whether it goes to
-- high impedance state or to unknown condition at pos-edge of HCLK.
-- ---------------------------------------------------------------------
p_Check_HRDATA : process (HCLK, HRDATA, DelHWRITE)
begin
  Write    <= (To_X01(DelHWRITE) = '1');
  Waited   <= (To_X01(HREADY) = '0');
  if (HCLK'event and HCLK = '1'and Resetover) then
    if (not Write and (DelHTRANS(1) = '1') and (not Waited) and
      (HRESETn = '1' or SuppressOnReset = FALSE)) then
      X_chk(HRDATA,msg_HDreXrclk);
    end if;
  end if;
 
  hiZ_chk (HRDATA,  msg_RdataZ);
 
  --  Timing Checks (only on reads)
  if (not Write and (HRESETn = '1' or SuppressOnReset = FALSE)) then
    if HRDATA'event then
      if ((HCLK = '1') and (HCLK'last_event < Tohdr)) then
        FlashHoldErr("HRDATA", HADDR);
      end if;
    end if;
  end if;
end process p_Check_HRDATA;

-- ---------------------------------------------------------------------
--  BUSY & IDLE Cycle Checking
--  Ensures a zero wait state OK response
-- ---------------------------------------------------------------------
p_Chk0WSC : process (HCLK, HTRANS, Resetover)
begin
  if (HCLK'event and HCLK = '1' and Resetover and HRESETn /= '0') then
    if (HREADY = '1') then
      DelHTRANS <= HTRANS;
    end if;
    if (DelHTRANS(1) = '0') then
      if (HREADY = '0') then
        errhandler(readyerr_msg, error);
      end if;
      if (HRESP /= "00") then
        errhandler(resperr_msg, error);
      end if;
      if (Verbosity) then
        if (HREADY = '1' and HRESP = "00") then
          errhandler(ready_msg, note);
        end if;
      end if;
    end if;
  end if;
end process p_Chk0WSC;

-- ---------------------------------------------------------------------
--  SPLITx Checking
--  Splitstatus of masters stored and then checks whether only the
-- masters which have been split are only given HSPLITx and it should
-- be active for only one clock cycle. 
-- ---------------------------------------------------------------------
p_ChkSPLIT : process (HCLK, HREADY, HRESP, HMASTER, HSPLIT, Resetover, 
                      DelMASTER)
begin
  if (HCLK'event and HCLK = '1' and Resetover) then
    DelHSPLIT  <= HSPLIT;
    if (HREADY = '1') then
      DelMASTER  <= HMASTER;
    end if;
    if (HSPLIT /= "0000000000000000" and
        HSPLIT /= "XXXXXXXXXXXXXXXX") then
      if (DelHSPLIT = HSPLIT) then
        errhandler(splitsameerr_msg, error);
      end if;
      for i in 15 downto 0 loop
        if (HSPLIT(i) /= SPLIT(i)) then
          errhandler(spliterr_msg,error);
        else
          if (Verbosity) then
            if (DelHSPLIT /= HSPLIT) then
              errhandler(split_msg,note);
            end if;
          end if;
        end if;
        if HSPLIT(i) = '1' then 
          SPLIT(i) <= '0';
        end if;
      end loop;
    end if;
  end if;
  if (HRESP = "11" and HREADY = '0') then
    SPLIT(CONV_INTEGER(unsigned(DelMASTER))) <= '1';
  end if;
end process p_ChkSPLIT; 

-- ---------------------------------------------------------------------
--  Response Checking
--  HRESP if it is not OK and HREADY is low, then in next cycle HRESP
--  should be same and HREADY HIGH.
--  HRESP if it is not OK and HREADY is HIGH, then in previous cycle
--  HRESP should be same and HREADY LOW. 
-- ---------------------------------------------------------------------
p_CheckResponse : process (HCLK, HRESP, HREADY, Resetover)
begin
  if (HCLK'event and HCLK = '1' and Resetover and HRESETn /= '0') then
    DelResponse <= HRESP;
    DelHREADY   <= HREADY;

    if (HRESP /= "00" and HREADY = '0' and Startcheck = '0') then
      Startcheck  <= '1';
      Expresponse <= HRESP;
    else
      Startcheck <= '0';
    end if;
    
    if (Startcheck = '1' and HREADY = '0') then
      errhandler(readyerr0_msg,error);
    end if;
    if (Expresponse /= HRESP and Startcheck = '1') then
      errhandler (resperr2_msg, error);
    end if;
   
    if (HRESP /= "00" and HREADY = '1') then
      if (Delresponse /= HRESP) then
        errhandler (resperr1_msg, error);
      end if;
      if(DelHREADY = '1') then
      errhandler(readyerr1_msg,error);
      end if;
    end if; 
  end if;
end process p_CheckResponse;
-- ---------------------------------------------------------------------
end behavioural;

-- --============================= END ===============================--
