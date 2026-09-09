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
-- File Name              : split.vhd.rca
-- File Revision          : 1.1
--
-- Release Information    : PrimeCell(TM)-GLOBAL-REL1v1
--
-- ---------------------------------------------------------------------
-- Purpose :
--           Checks HSPLITx lines for numcycles specified 
--
-- --=================================================================--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

library common;
use     common.defs.all;
use     common.funcs.all;

-- ---------------------------------------------------------------------
entity Split is
  generic (
           Verbosity      : boolean;
           HaltOnMismatch : boolean
          );
  port(
       HCLK         : in std_logic; -- AHB Clock
       HSPLIT       : in std_logic_vector(15 downto 0); -- HSPLITx lines
       Splitsel     : in T_cycle;   -- HSP command active 
       Vsplitpacket : in T_split    -- HSP command packet
       );
end Split;
-- ---------------------------------------------------------------------
--
--                           Split
--                           =====
--
-- ---------------------------------------------------------------------
--
-- Overview :
-- ==========
--   This module checks the HSPLITx lines for the numcycle clocks
-- mentioned and reports an error if the slave fails to do so.
--
-- ---------------------------------------------------------------------
architecture behavioural of Split is
-- ---------------------------------------------------------------------
-- Constant declarations
-- ---------------------------------------------------------------------
constant splitstr : string
                         := "Limit exceeded for HSPLIT to be asserted";
-- Warning if the protocol fails
-- ---------------------------------------------------------------------
-- Signal declarations
-- ---------------------------------------------------------------------
signal Splitcntren    : std_logic := '0'; -- HSP is active and checking

signal CntrloadEn     : std_logic := '0'; -- HSP is active and a new one

signal Splitcount     : T_int;      -- Counter which runs when HSP is
                                    -- active

type T_numcyc      is  array (0 to 15) of T_int;

signal Numcyclebus    : T_numcyc;
-- Bus of 16 Numcycle count of 16 Masters

signal ExpSplit       : std_logic_vector(15 downto 0);
-- Expected Masters to be asserted in HSPLITx bus  
-- ---------------------------------------------------------------------

begin

-- ---------------------------------------------------------------------
-- Counter for the SPLITx check 
-- ---------------------------------------------------------------------
p_Splitcounter : process (HCLK)
begin
  if (HCLK'event and HCLK = '1') then
    if (Splitcntren = '1' and Splitsel /= Csplit and
        CntrloadEn = '0') then
      Splitcount <= Splitcount + 1;
    else
      Splitcount <= 1;
    end if;
  end if;
end process p_Splitcounter;

-- ---------------------------------------------------------------------
-- Checking whether the limit has exceeded expected numcycle value
-- ---------------------------------------------------------------------
reportsplit : process (HCLK)
variable PrintStr : string(1 to 255);
begin

-- Whenever an HSP is issued, the previous command is terminated, if
-- necessary, with warnings, and the new parameters are loaded 
  if (HCLK'event and HCLK = '1' and Splitsel = Csplit) then
    CntrloadEn <= not(CntrloadEn);
    if (Splitcntren = '1' and CntrloadEn = '0') then
      for i in 15 downto 0 loop
        if ((ExpSplit(i) = '1') and HSPLIT(i) /= '1') then
           ExpSplit(i) <= '0';
           fprint(PrintStr, "WARNHSP : HMASTER %s not yet asserted " &
             "on HSPLITx and execution of command is broken" &
             " TIME : %s",
              to_string(i), to_string(now));
          assert false
            report PrintStr
            severity error;
        end if;
      end loop;
    end if; 
     
    Splitcntren     <= '1';
    ExpSplit        <= Vsplitpacket.Exphsplit;
    Numcyclebus(0)  <= Vsplitpacket.Numcyc0;
    Numcyclebus(1)  <= Vsplitpacket.Numcyc1;
    Numcyclebus(2)  <= Vsplitpacket.Numcyc2;
    Numcyclebus(3)  <= Vsplitpacket.Numcyc3;
    Numcyclebus(4)  <= Vsplitpacket.Numcyc4;
    Numcyclebus(5)  <= Vsplitpacket.Numcyc5;
    Numcyclebus(6)  <= Vsplitpacket.Numcyc6;
    Numcyclebus(7)  <= Vsplitpacket.Numcyc7;
    Numcyclebus(8)  <= Vsplitpacket.Numcyc8;
    Numcyclebus(9)  <= Vsplitpacket.Numcyc9;
    Numcyclebus(10) <= Vsplitpacket.Numcyc10;
    Numcyclebus(11) <= Vsplitpacket.Numcyc11;
    Numcyclebus(12) <= Vsplitpacket.Numcyc12;
    Numcyclebus(13) <= Vsplitpacket.Numcyc13;
    Numcyclebus(14) <= Vsplitpacket.Numcyc14;
    Numcyclebus(15) <= Vsplitpacket.Numcyc15;
-- If HSP is active, it checks whether each of the master's HSPLIT is
-- asserted on the expected num_cycle
  elsif(HCLK'event and HCLK = '1' and Splitcntren = '1') then
    if (Splitcount > Vsplitpacket.limit) then
      for i in 15 downto 0 loop
        if ((ExpSplit(i) = '1') and (HSPLIT(i) /= '1')) then
           ExpSplit(i) <= '0';
           fprint(PrintStr, "ERRHSPLT : HMASTER %s not yet asserted " &
             "on HSPLITx within the  expected number of clock cycles" &
             " TIME : %s", 
              to_string(i), to_string(now));
          assert false
            report PrintStr
            severity error;
        end if;
      end loop;
      Splitcntren <= '0';
    end if;
    for i in 15 downto 0 loop
      if (HSPLIT(i) = '1' and Splitcount <= Numcyclebus(i) and 
          Numcyclebus(i) /= 0) then
        ExpSplit(i) <= '0';
        fprint(PrintStr, "ERRHSPLTP : HMASTER %s asserted " &
      "on HSPLITx prior to the expected numcyc number of clocks TIME " &
             ": %s",
              to_string(i), to_string(now));
          assert false
            report PrintStr
            severity error;
      end if;
      if (HSPLIT(i) = '1' and Splitcount >= Numcyclebus(i) and 
          Numcyclebus(i) /= 0) then
        ExpSplit(i) <= '0';
        fprint(PrintStr, "ERRHSPLTL : HMASTER %s asserted " &
         "on HSPLITx after the expected numcyc number of clocks TIME " &
             ": %s",
              to_string(i), to_string(now));
          assert false
            report PrintStr
            severity error;
      end if;
      if (HSPLIT(i) = '1' and ((Splitcount = Numcyclebus(i) and 
          Numcyclebus(i) /= 0) or Numcyclebus(i) = 0)) then
        ExpSplit(i) <= '0';
        if (Verbosity) then
          fprint(PrintStr, "HSPC : HMASTER %s correctly asserted " &
         "on HSPLITx on the expected numcyc number of clocks TIME " &
             ": %s",
              to_string(i), to_string(now));
          assert false
            report PrintStr
            severity note;
        end if;
      end if;
    end loop; 
  end if;
end process;

end behavioural;

-- --============================= End ===============================--
