-- --=========================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 1998 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
-- 
-- -----------------------------------------------------------------------------
-- Version and Release Control Information:
-- 
-- File Name           : funcs.vhd,v 
-- File Revision       : 1.2 
-- 
-- Release Information : PL050-REL1v1 
-- 
-- -----------------------------------------------------------------------------
-- Purpose             : This contains the functions to_vec and from_vec.
--                       It also contains the procedures ReportRead,
--                       ReportVirRead, ReportVirWrite, ReportP_Cycle 
--                       and ReportReset.
-- --=========================================================================--

library ieee;
use     ieee.std_logic_1164.all;

library Std_DevelopersKit;
use     std_DevelopersKit.Std_Regpak.all;
use     std_developerskit.std_IOpak.all;

library common;
use     common.defs.all;

package funcs is
  
  function to_vec(sig : std_logic) return std_logic_vector;
  function from_vec(vec : std_logic_vector(0 downto 0)) return std_logic;
    
  procedure ReportRead(
                       constant Verbosity      : in boolean;
                       constant HaltOnMismatch : in boolean;
                       constant data           : in std_logic_vector;
                       constant mask           : in std_logic_vector;
                       constant exp            : in std_logic_vector;
                       constant tag            : in string(1 to 20);
                       signal postatI          : in std_logic;
                       signal postatO          : out std_logic;
                       signal countflag        : in boolean 
                      );
  procedure ReportVirRead(
                          constant Verbosity      : in boolean;
                          constant HaltOnMismatch : in boolean;
                          constant data           : in std_logic_vector;
                          constant mask           : in std_logic_vector;
                          constant exp            : in std_logic_vector;
                          constant reg            : in integer;
                          constant tag            : in string(1 to 20)
                          );
  procedure ReportVirWrite(constant data : in std_logic_vector;
                           constant mask : in std_logic_vector;
                           constant reg  : in integer);
  procedure ReportP_Cycle(
                          constant sel       : in T_cycle;
                          constant exp       : in std_logic_vector;
                          constant mask      : in std_logic_vector;
                          constant addr      : in std_logic_vector;
                          constant data      : in std_logic_vector;
                          constant tag       : in string(1 to 20);
                          constant num_cyc   : in T_int);
  procedure ReportReset(   constant nres : in std_logic);
  
end funcs;

package body funcs is

  function StrLengthHex( constant x : in integer )
    return integer is
      variable result : integer ;
  begin
    if (x mod 4 = 0) then
      result := (x / 4) ; 
    else
      result := (x/4) + 1 ;
    end if ;
    return (result) ;
  end StrLengthHex ;
  
  function To_HexString( constant val : in std_logic_vector )
    return string is
    constant ResLength : integer := StrLengthHex(val'length) ;
    variable result    : string (1 to ResLength) ;
    variable temp      : std_logic_vector(3 downto 0) ;
  begin
    for i in (ResLength-1) downto 0 loop
      result(ResLength-i) := ' ' ;
      for j in 3 downto 0 loop
        if (i = (ResLength-1)) then
          if (i*4)+j >= val'length then
            temp(j) := '0' ;
          else
            temp(j) := val( (i*4)+j ) ;
          end if ;
        else
          temp(j) := val( (i*4)+j ) ;
        end if ;
      end loop ;
      case temp(3 downto 0) is
        when "0000" => result(ResLength-i) := '0'; 
        when "0001" => result(ResLength-i) := '1'; 
        when "0010" => result(ResLength-i) := '2'; 
        when "0011" => result(ResLength-i) := '3'; 
        when "0100" => result(ResLength-i) := '4'; 
        when "0101" => result(ResLength-i) := '5'; 
        when "0110" => result(ResLength-i) := '6'; 
        when "0111" => result(ResLength-i) := '7'; 
        when "1000" => result(ResLength-i) := '8'; 
        when "1001" => result(ResLength-i) := '9'; 
        when "1010" => result(ResLength-i) := 'A'; 
        when "1011" => result(ResLength-i) := 'B'; 
        when "1100" => result(ResLength-i) := 'C'; 
        when "1101" => result(ResLength-i) := 'D'; 
        when "1110" => result(ResLength-i) := 'E'; 
        when "1111" => result(ResLength-i) := 'F';
        when others  => result(ResLength-i) := 'X';
      end case ;
    end loop ;
    return result ;
  end To_HexString ; 
  
  procedure ReportRead(
                       constant Verbosity      : in boolean;
                       constant HaltOnMismatch : in boolean;
                       constant data           : in std_logic_vector;
                       constant mask           : in std_logic_vector;
                       constant exp            : in std_logic_vector;
                       constant tag            : in string(1 to 20);
                       signal postatI          : in std_logic;
                       signal postatO          : out std_logic;
                       signal countflag        : in boolean  
                      ) is
        variable printstr  : string(1 to 255);
        
  begin
    if (((mask and data) /= (mask and exp)) and (postatI = '0')) then
      fprint(printstr,
             "PSRE: Error on data read. Expected:%s Actual:%s Mask:%s, TAG: %s",
              To_HexString(exp),
              To_HexString(data),
              To_HexString(mask),
              tag);
      postatO <= '0'; -- indicates that it is not a Poll command.
      if HaltOnMismatch then
        assert false report printstr severity failure;
      else
        assert false report printstr  severity warning;
      end if;
    elsif (postatI ='0') then
      postatO <= '0'; -- indicates that it is not a poll command.
      if Verbosity then
        fprint(printstr,"PSRC: Correct read value of %s with mask %s, TAG:%s",
               To_HexString(data),
               To_HexString(mask),
               tag);
        assert false
        report printstr
        severity note;
      end if;
    elsif ( ((mask and data) = (mask and exp)) and (postatI = '1') ) then
      if (Verbosity) then
        fprint(printstr,
            "POC: Correct value of %s polled, TAG:%s", To_HexString(exp), tag);
        assert false
        report printstr
        severity note;
      end if;
      postatO <= '0'; -- stop polling since correct value is sampled.
    elsif (((mask and data) /= (mask and exp)) and (postatI = '1'))then 
      if (countflag) then 
        if (Verbosity) then
          fprint(printstr,
                 "PO: Polling for value %s, TAG:%s ", To_HexString(exp), tag);
          assert false
          report printstr
          severity note;
        end if;
        postatO <= '1'; -- continue polling as maximum number of Polls is
                        -- not reached (countflag is TRUE). 
      else 
        fprint(printstr,
              "POE: Maximum number of Polls for value %s reached. TAG:%s ",
              To_HexString(exp), tag);
        postatO <= '0';
        assert false
        report printstr
        severity note;
      end if;
    end if;
  end ReportRead;

  procedure ReportVirRead(
                          constant Verbosity      : in boolean;
                          constant HaltOnMismatch : in boolean;
                          constant data           : in std_logic_vector;
                          constant mask           : in std_logic_vector;
                          constant exp            : in std_logic_vector;
                          constant reg            : in integer;
                          constant tag            : in string (1 to 20) ) is
        variable printstr  : string(1 to 255);
  begin
    if ((mask and data) /= (mask and exp)) then
      fprint(printstr,
             "VRE%s: Error on vector read from R%s. Expected: %s Actual: %s Mask: %s, TAG:%s", 
             To_String(reg),
             To_String(reg),
             To_HexString(exp),
             To_HexString(data),
             To_HexString(mask),
             tag);
      if HaltOnMismatch then
        assert false
        report printstr
        severity failure;
      else
        assert false
        report printstr
        severity warning;
      end if;
    elsif Verbosity then 
      fprint(printstr,
            "VRC%s :Correct read value of %s with mask %s from R%s, TAG:%s",
             To_String(reg),
             To_HexString(exp),
             To_HexString(mask),
             To_String(reg),
             tag);
      assert false
      report printstr
      severity note;
    end if;
  end ReportVirRead;

  procedure ReportVirWrite(constant data : in std_logic_vector;
                           constant mask : in std_logic_vector;
                           constant reg  : in integer) is
        variable printstr  : string(1 to 255);
  begin
    fprint(printstr, "VWI%s: Vector write of %s with mask %s to  R%s",
           To_String(reg),
           To_HexString(data),
           To_HexString(mask),
           To_String(reg));
    assert false
    report printstr
    severity note;
  end ReportVirWrite;

  procedure ReportP_Cycle(
                          constant sel       : in T_cycle;
                          constant exp       : in std_logic_vector;
                          constant mask      : in std_logic_vector;
                          constant addr      : in std_logic_vector;
                          constant data      : in std_logic_vector;
                          constant tag       : in string(1 to 20);
                          constant num_cyc   : in T_int) is
    
        variable printstr  : string(1 to 255);
        variable cyclestr  : string(1 to 14);
        variable strength  : severity_level;
  begin
    case sel is 
      when c_pnr =>
        fprint(printstr, "PNRI: Started PNR transfer at address %s, TAG:%s",
               To_HexString(addr),
               tag);
        assert false
        report printstr
        severity note;
      when c_psr =>
        fprint(printstr,
               "PSRI: Started PSR of expected data %s with mask %s from address %s, TAG:%s", 
               To_HexString(exp),
               To_HexString(mask),
               To_HexString(addr),
               tag);
         assert false
         report printstr
         severity note;
       when c_po =>
         fprint(printstr,
                "POI: Started PO of expected data %s  from address %s, TAG:%s",
                 To_HexString(exp),
                 To_HexString(addr),
                 tag);
         assert false
         report printstr
         severity note;
       when c_pnw =>
         fprint(printstr,
               "PNWI: Started PNW with data %s at address %s, TAG:%s",
                To_HexString(data),
                To_HexString(addr),
                tag);
         assert false
         report printstr
         severity note;
       when c_psw =>
         fprint(printstr,
                "PSWI: Started PSW with data %s at address %s, TAG:%s",
                To_HexString(data),
                To_HexString(addr),
                tag);
         assert false
         report printstr
         severity note;
       when c_pi =>
         fprint(printstr,
               "PII: Started PI for %s cycles, TAG:%s",
                To_String(num_cyc),
                tag);
         assert false
         report printstr
         severity note;
       when others => null;
      end case;
  end ReportP_Cycle;

  procedure ReportReset(constant nres : in std_logic) is
  begin
     if nres = '0' then
       assert false report "RESL: BnRES asserted (LOW)" severity note;
     elsif nres = '1' then
       assert false report "RESH: BnRES deasserted (HIGH)" severity note;
     end if;
  end ReportReset;

  function to_vec(sig : std_logic) return std_logic_vector is
  begin
    case sig is
      when '1' => return ("1");
      when '0' => return ("0");
      when 'Z' => return ("Z");
      when others => return ("X");
    end case;
  end to_vec;

  function from_vec(vec : std_logic_vector(0 downto 0)) return std_logic is
  begin
    case vec is
      when "1" => return ('1');
      when "0" => return ('0');
      when "Z" => return ('Z');
      when others => return ('X');
    end case;
  end from_vec;
      
end funcs;

-- --================================= End ===================================--
