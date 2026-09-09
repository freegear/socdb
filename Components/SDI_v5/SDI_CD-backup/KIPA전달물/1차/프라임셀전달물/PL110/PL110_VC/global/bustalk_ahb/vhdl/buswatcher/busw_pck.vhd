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
-- File Name              : busw_pck.vhd.rca
-- File Revision          : 1.1
--
-- Release Information    : PrimeCell(TM)-GLOBAL-REL1v6
--
-- ---------------------------------------------------------------------
-- Purpose :
--           Function/procedures package for buswatcher module
--
-- --=================================================================--

library ieee;
use     ieee.std_logic_1164.all;
use     ieee.std_logic_arith.all;

library common;
use     common.defs.all;
use     common.funcs.all;

-- ---------------------------------------------------------------------
package busw_pck is

  
procedure errhandler (
                      message  : in string;
                      strength : in severity_level
                     );

procedure errHandler_TV (
                         ErrMsg         : in string;
                         tim_param      : in time;
                         last_event_str : in string;
                         strength       : in severity_level
                        );
  
procedure hiZ_chk (
                   ip_sig  : in T_line;
                   err_msg : in string
                  );

procedure hiZ_chk (
                   ip_sig  : in std_logic_vector;
                   err_msg : in string
                  );

procedure X_chk (
                 ip_sig    : in T_Line;
                 err_msg   : in string
                );

procedure X_chk (
                 ip_sig    : in std_logic_vector;
                 err_msg   : in string
                );
procedure FlashHoldErr (
                        SigName : in string;
                        HADDR   : in std_logic_vector
                       );
procedure FlashHoldRdyErr (
                        SigName : in string;
                        HADDR   : in std_logic
                       ); 
 
procedure FlashValidErr (
                        SigName   : in string;
                        ExactEdge : in time
                       );

function IsZ(sig : std_logic) return boolean;
function IsZ(sig : std_logic_vector) return boolean;
function num_sel(sig : std_logic_vector) return integer;
  
-- ---------------------------------------------------------------------
--  AHB Output signals from the slave Error Messages
-- ---------------------------------------------------------------------
constant msg_Tovdr   : string
                            :="(Tovdr) HRDATA valid after rising HCLK";
constant msg_Tohdr   : string :="(Tohdr) HRDATA hold after rising HCLK";
constant msg_Tovresp : string
                          := "(Tovresp) HRESP valid after rising HCLK";
constant msg_Tohresp : string
                      := "(Tohresp) HRESP hold time after rising HCLK";
constant msg_Tovready: string
                        := "(Tovready) HREADY valid after rising HCLK";
constant msg_Tohready: string
                    := "(Tohready) HREADY hold time after rising HCLK";

-- ---------------------------------------------------------------------
--  Compliance Error messages
-- ---------------------------------------------------------------------
  
constant  msg_RespZ      : string :="HRESPZ: HRESP driven to Z" ;
constant  msg_ReadyZ     : string :="HREADYZ: HREADY driven to Z" ;
constant  msg_RdataZ     : string :="HRDATAZ: HRDATA driven to Z" ;
constant  msg_HSplitZ    : string :="HSPLITZ: HSPLIT driven to Z" ;

constant  msg_RespXrclk  : string
                               := "HRESPXR: HRESP unknown on rising " &
                                  "edge of HCLK";
constant  msg_ReadyXrclk : string
                             := "HREADYX: HREADY unknown on rising  " &
                                "edge of HCLK";
constant  msg_HSPXrclk   : string
                              := "HSPLTX: HSPLIT unknown on rising  " &
                                 "edge of HCLK";
constant  msg_HDreXrclk  : string :=
  "HRDATAX: HRDATA unknown on rising HCLK during last cycle of read operation";

end busw_pck;

-- ---------------------------------------------------------------------
--
--                             BuswPack
--                             ========
--
-- ---------------------------------------------------------------------
--
-- Overview
-- ========
--  This module contains  functions to check the timing protocols of AHB
-- Slave output signals. It also contains functions to print error
-- messages while checking the protocols. 

-- --============================ BODY ===============================--

package body busw_pck is

-- ---------------------------------------------------------------------
-- Checks for high-impedance in the signal at any time
-- ---------------------------------------------------------------------
procedure hiZ_chk (
                   ip_sig       : in T_line;
                    err_msg     : in string) is
begin
  if (IsZ(ip_sig)) then
    errhandler(err_msg, error);
  end if;
end   hiZ_chk;
-- ---------------------------------------------------------------------
-- Checks for high-impedance in the signal at any time
-- ---------------------------------------------------------------------
procedure hiZ_chk (
                   ip_sig   : in std_logic_vector;
                   err_msg  : in string) is
begin
  if (IsZ(ip_sig)) then
    errhandler(err_msg, error);
  end if;
end   hiZ_chk;
-- ---------------------------------------------------------------------
-- Checks for signal going to unknown state at positive edge of clock
-- ---------------------------------------------------------------------
procedure X_chk (
                 ip_sig   : in T_Line;
                 err_msg  : in string) is
begin
  if (Is_X(ip_sig)) then errhandler(err_msg, error);
  end if;
end X_chk;
-- ---------------------------------------------------------------------
-- Checks for signal going to unknown state at positive edge of clock
-- ---------------------------------------------------------------------
procedure X_chk (
                 ip_sig   : in std_logic_vector;
                 err_msg  : in string) is
begin
  if (Is_X(ip_sig)) then errhandler(err_msg, error);
  end if;
end X_chk;
  
-- --------------------------------------------------------------------- 
-- To print error messages
-- ---------------------------------------------------------------------
procedure errhandler(message : in string; strength : in severity_level)
                   is
variable printstr : string(1 to 255);
begin
  fprint(printstr,"Time: %s:  %s", to_string(now), message);
  assert (now = 0 ns)
  report printstr
  severity strength;
end errhandler;

-- ---------------------------------------------------------------------
-- To print error messages during timing violations
-- ---------------------------------------------------------------------
procedure errHandler_TV (ErrMsg : in string;
                          tim_param : in time;
                          last_event_str : in string;
                          strength : in severity_level) is
    variable printstr : string(1 to 255);
    begin
      fprint(printstr,
            "Timing Violation: at time:%s %s Spec:%s Actual:%s",
            to_string(now),ErrMsg,to_string(tim_param), last_event_str);
      assert (now = 0 ns)
        report printstr
        severity strength;
  end errhandler_TV;
   
-- ---------------------------------------------------------------------
-- Checking whether signal is in high impedance state
-- ---------------------------------------------------------------------
function IsZ(sig : std_logic) return boolean is
variable j : boolean := TRUE;
begin
  j := j and (sig = 'Z' or sig = 'L' or sig = 'H');
  return j;
end IsZ;
  
-- ---------------------------------------------------------------------
-- Checking whether signal is in high impedance state
-- ---------------------------------------------------------------------
function IsZ(sig : std_logic_vector) return boolean is
variable j : boolean := TRUE;
begin
  for i in sig'range loop
      j := j and (sig(i) = 'Z' or sig(i) = 'L' or sig(i) = 'H');
  end loop;
  return j;
end IsZ;

-- ---------------------------------------------------------------------
--  Function to evaluate how many signals are active on a bus.
-- ---------------------------------------------------------------------
function num_sel(sig : std_logic_vector) return integer is
variable j : integer := 0;
begin
  for i in sig'range loop
      if sig(i) = '1' then
        j := j+1;
      end if;
     end loop;
     return j;
end num_sel;

-- ---------------------------------------------------------------------
-- Function to check the hold time protocols of a signal
-- ---------------------------------------------------------------------
procedure FlashHoldErr (
                        SigName : in string;
                        HADDR   : in std_logic_vector
                       ) is
variable PrintStr : string(1 to 255);
-- used to flash the error message during simulation
begin
  fprint(PrintStr,
        "ERROR : Hold time violation on %s signal. HADDR : " &
        "%s. TIME : %s", SigName,  To_HexString(HADDR), to_string(now));
  assert false
  report PrintStr
  severity error;
end FlashHoldErr;

-- ---------------------------------------------------------------------
-- Function to check hold time violation of HREADY signal
-- ---------------------------------------------------------------------
procedure FlashHoldRdyErr (
                           SigName : in string;
                           HADDR   : in std_logic
                          ) is
variable PrintStr : string(1 to 255);
-- used to flash the error message during simulation
begin
  fprint(PrintStr,
         "ERROR : Hold time violation on %s signal. HADDR : " &
         "%s. TIME : %s", SigName, to_string(HADDR), to_string(now));
  assert false
  report PrintStr
  severity error;
end FlashHoldRdyErr;
 
-- ---------------------------------------------------------------------
-- Function to check valid time violations of AHB Slave signals
-- ---------------------------------------------------------------------
procedure FlashValidErr (
                         SigName   : in string;
                         ExactEdge : in time
                        ) is
variable PrintStr : string(1 to 255);
-- used to flash the error message during simulation
begin
  fprint(PrintStr, "ERROR : %s not driven to valid value within the " &
      "specified valid time. TIME  %s", SigName,  to_string(ExactEdge));
  assert false
  report PrintStr
  severity error;
end FlashValidErr;

end busw_pck;

-- --============================= End ===============================--
