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
-- File Name           : busw_pck.vhd.rca
-- File Revision       : 1.1 
-- 
-- Release Information : PrimeCell(TM)-GLOBAL-REL1v1 
-- 
-- ---------------------------------------------------------------------
-- Purpose             : Buswatcher Package for APB Slave
-- --=================================================================--

library ieee;
use     ieee.std_logic_1164.all;

library std;
use     std.textio.all;

library common;
use     common.defs.all;
use     common.funcs.all;

package busw_pck is

  
  procedure errhandler(message : in string;
                       strength : in severity_level);

  procedure errHandler_TV(ErrMsg : in string;
                          tim_param : in time;
                          last_event_str : in string;
                          strength : in severity_level);
  
  procedure tim_chk_tov(ip_sig_event : in boolean;
                           ref_sig      : in T_line;
                           ref_sig_le   : in time;
                           ref_edge     : in T_edge;
                           t_param      : in time;
                           err_msg      : in string);

  procedure tim_chk_toh(ip_sig_event : in boolean;
                           ref_sig      : in T_line;
                           ref_sig_le   : in time;
                           ref_edge     : in T_edge;
                           t_param      : in time;
                           err_msg      : in string);
    
  procedure hiZ_chk (ip_sig       : in T_line;
                     ip_sig_event : in boolean;
                     ref_sig      : in T_line;
                     ref_sig_event: in boolean;
                     ref_edge     : in T_edge;
                     err_msg      : in string);

  procedure hiZ_chk (ip_sig       : in T_data;
                     ip_sig_event : in boolean;
                     ref_sig      : in T_line;
                     ref_sig_event: in boolean;
                     ref_edge     : in T_edge;
                     err_msg      : in string);

  procedure valid_chk (ip_sig       : in T_data;
                       ip_sig_event : in boolean;
                       ref_sig      : in T_line;
                       ref_sig_event: in boolean;
                       ref_edge     : in T_edge;
                       err_msg      : in string);

  procedure X_chk   (ip_sig       : in T_Line;
                     err_msg      : in string);

  procedure X_chk   (ip_sig       : in T_data;
                     err_msg      : in string);

  function IsZ(sig : std_logic) return boolean;
  function IsZ(sig : std_logic_vector) return boolean;
  function num_sel(sig : std_logic_vector) return integer;
  function IsValid(sig : std_logic) return boolean;
  function IsValid(sig : std_logic_vector) return boolean;

   --------------------------------------------------------------
   --  Output Timing Error messages
   --------------------------------------------------------------

constant msg_Tovpdr : string :=
 "(Tovpdr) PRDATA valid after rising PCLK during read";
constant msg_Tohpdr : string :=
 "(Tohpdr) PRDATA hold after rising PCLK during read";
 
end busw_pck;

package body busw_pck is

  procedure tim_chk_tov( ip_sig_event : in boolean;
                            ref_sig      : in T_line;
                            ref_sig_le   : in time;
                            ref_edge     : in T_edge;
                            t_param      : in time;
                            err_msg      : in string) is

  begin 
      if ref_edge = falling then
        if ip_sig_event and  ref_sig = '0' and (ref_sig_le > (t_param))
                                                                    then
          errHandler_TV(err_msg,t_param,  to_string(ref_sig_le),error);
        end if;
      end if;
      if ref_edge = rising then
        if ip_sig_event and  ref_sig = '1' and (ref_sig_le > (t_param))
                                                                    then
          errHandler_TV(err_msg,t_param,  to_string(ref_sig_le),error);
        end if;
      end if;
   end tim_chk_tov;
    
  procedure tim_chk_toh( ip_sig_event : in boolean;
                            ref_sig      : in T_line;
                            ref_sig_le   : in time;
                            ref_edge     : in T_edge;
                            t_param      : in time;
                            err_msg      : in string) is
  begin 
      if ref_edge = rising then
        if ip_sig_event and  ref_sig = '1' and (ref_sig_le < (t_param))
                                                                    then
          errHandler_TV(err_msg,t_param,  to_string(ref_sig_le),error);
        end if;
      end if;
      if ref_edge = falling then
        if ip_sig_event and  ref_sig = '0' and (ref_sig_le < (t_param))
                                                                    then
          errHandler_TV(err_msg,t_param,  to_string(ref_sig_le),error);
        end if;
      end if;
  end tim_chk_toh;        
  
  procedure hiZ_chk (ip_sig       : in T_line;
                       ip_sig_event : in boolean;
                       ref_sig      : in T_line;
                       ref_sig_event: in boolean;
                       ref_edge     : in T_edge;
                       err_msg      : in string) is
  begin
    if (ref_edge = falling and ((ref_sig = '1' and ip_sig_event) or 
         (ref_sig = '0' and ref_sig_event ))) then
      if(not IsZ(ip_sig)) then
        --  driven when ref is high
        errhandler(err_msg, error);
      end if;
    end if;
    if (ref_edge = rising and ((ref_sig = '0' and ip_sig_event) or 
         (ref_sig = '1' and ref_sig_event ))) then
      if(not IsZ(ip_sig)) then
        --  driven when ref is low
        errhandler(err_msg, error);
      end if;
    end if;
  end   hiZ_chk;
  
  procedure hiZ_chk (ip_sig       : in T_data;
                     ip_sig_event : in boolean;
                     ref_sig      : in T_line;
                     ref_sig_event: in boolean;
                     ref_edge     : in T_edge;
                     err_msg      : in string) is
  begin
    if (ref_edge = falling and ((ref_sig = '1' and ip_sig_event) or 
         (ref_sig = '0' and ref_sig_event ))) then
      if(not IsZ(ip_sig)) then
        --  driven when ref is high
        errhandler(err_msg, error);
      end if;
    end if;
    if (ref_edge = rising and ((ref_sig = '0' and ip_sig_event) or 
         (ref_sig = '1' and ref_sig_event ))) then
      if(not IsZ(ip_sig)) then
        --  driven when ref is low
        errhandler(err_msg, error);
      end if;
    end if;
  end   hiZ_chk;

  procedure valid_chk (ip_sig       : in T_data;
                       ip_sig_event : in boolean;
                       ref_sig      : in T_line;
                       ref_sig_event: in boolean;
                       ref_edge     : in T_edge;
                       err_msg      : in string) is
  begin
    if (ref_edge = falling and (ref_sig = '0' and ref_sig_event)) then
      if(not IsValid(ip_sig)) then
        errhandler(err_msg, error);
      end if;
    end if;
    if (ref_edge = rising and (ref_sig = '0' and ref_sig_event)) then
      if(not IsValid(ip_sig)) then
        errhandler(err_msg, error);
      end if;
    end if;
  end   Valid_chk;

  procedure X_chk   (ip_sig       : in T_Line;
                     err_msg      : in string) is
  begin
     if(Is_X(ip_sig)) then errhandler(err_msg, error);
     end if;
  end X_chk;
  procedure X_chk   (ip_sig       : in T_data;
                     err_msg      : in string) is
  begin
     if(Is_X(ip_sig)) then errhandler(err_msg, error);
     end if;
  end X_chk;
  
  procedure 
    errhandler(message : in string; strength : in severity_level) is
    variable printstr : string(1 to 255);
  begin
    fprint(printstr,"Time: %s:  %s", to_string(now), message);
    assert (now = 0 ns)
      report printstr
      severity strength;
  end errhandler;

  procedure errHandler_TV(ErrMsg : in string;
                          tim_param : in time;
                          last_event_str : in string;
                          strength : in severity_level) is
    variable printstr : string(1 to 255);
    begin
      fprint(printstr, "Timing Violation: at time:%s %s Spec:%s "
              & "Actual:%s", to_string(now),ErrMsg,to_string(tim_param),
              last_event_str);
      assert (now = 0 ns)
        report printstr
        severity strength;
  end errhandler_TV;
   
  function IsZ(sig : std_logic) return boolean is
    variable j : boolean := TRUE;
  begin
      j := j and (sig = 'Z' or sig = 'L' or sig = 'H');
    return j;
  end IsZ;
  
  function IsZ(sig : std_logic_vector) return boolean is
    variable j : boolean := TRUE;
  begin
    for i in sig'range loop
      j := j and (sig(i) = 'Z' or sig(i) = 'L' or sig(i) = 'H');
    end loop;
    return j;
  end IsZ;
  
  function IsValid(sig : std_logic) return boolean is
    variable j : boolean := TRUE;
  begin
      j := j and (sig = '1' or sig = '0');
    return j;
  end IsValid;
  
  function IsValid(sig : std_logic_vector) return boolean is
    variable j : boolean := TRUE;
  begin
--    for i in 5 downto 0 loop
    for i in sig'range loop
      j := j and (sig(i) = '1' or sig(i) = '0');
    end loop;
    return j;
  end IsValid;

--  Function to evaluate how many signals are active on a bus.

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

end busw_pck;

-- --============================= End ===============================--
