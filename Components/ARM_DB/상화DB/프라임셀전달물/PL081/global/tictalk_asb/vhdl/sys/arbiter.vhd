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
-- File Name              : arbiter.vhd.rca
-- File Revision          : 1.1
--
-- Release Information    : PrimeCell(TM)-GLOBAL-REL1v4
--
-- ---------------------------------------------------------------------
-- Purpose : Entity and architecture description for bus arbiter for 
--           AMBA (rev D)
--           The arbiter processes requests for ownership of the ASB 
--           and grants one ASB master according to the arbitration 
--           scheme. The arbitration scheme of this implementation is 
--           a simple priority encoded scheme where the highest 
--           priority master requesting the ASB is granted. The 
--           priority order is as follows:
--           1.) Async. Reset, TIC, Pause mode --> TIC granted
--           2.) ASB001
--           3.) ASB002
--           4.) ARM
--           5.) TIC (default bus master)
--
-- --=================================================================--

library ieee;
use     ieee.std_logic_1164.all;

--#synth off
library common;
use     common.params.all;
--#synth on
entity arbiter is

  port(
       AREQarm        : in     std_ulogic; -- Request from ARM
       AREQtic        : in     std_ulogic; -- Test Interface Controller
                                           -- request
       AREQ001        : in     std_ulogic; -- Request from ASB 
                                           -- master 001
       AREQ002        : in     std_ulogic; -- Request from ASB 
                                           -- master 002
       
       BCLK           : in     std_ulogic; -- ASB system clock
       BnRES          : in     std_ulogic; -- Bus reset
       Pause          : in     std_ulogic; -- Pause mode

       BWAIT          : in     std_logic;
       BLOK           : in     std_logic;
       
       AGNTARM        : out    std_ulogic; -- Grant ARM
       AGNTTic        : out    std_ulogic; -- Grant Test Interface 
                                           -- Controller
       AGNT001        : out    std_ulogic; -- Grant ASB master 001
       AGNT002        : out    std_ulogic  -- Grant ASB master 002
       );
end arbiter;

architecture synth of arbiter is
  
   signal AGNTARMi : std_ulogic;        -- internal value of AGNT
   signal AGNTTICi : std_ulogic;
   signal AGNT001i : std_ulogic;
   signal AGNT002i : std_ulogic;
   
   signal AGNTARMD1 : std_ulogic;       -- AGNTs based on AREQs
   signal AGNTTICD1 : std_ulogic;
   signal AGNT001D1 : std_ulogic;
   signal AGNT002D1 : std_ulogic;
   
   signal AGNTARMD2 : std_ulogic;       -- AGNTs registered on rising 
                                        -- BCLK
   signal AGNTTICD2 : std_ulogic;
   signal AGNT001D2 : std_ulogic;
   signal AGNT002D2 : std_ulogic;
   
   signal SelD1GntT1 : std_ulogic;       -- Select AGNTD1 as AGNT

   signal samplok   : std_ulogic;
   signal samplokD2 : std_ulogic;
   signal equal     : std_ulogic;

begin 

  -- select provisional new or previous grant 
  p_SelD1GntT1 : process(BCLK, BLOK, BnRES, samplokD2)
  begin
    if (BCLK = '0') then
      SelD1GntT1 <= (not(BLOK and samplokD2)) or (not BnRES) after TLPG;
    end if;
  end process p_SelD1GntT1;

  
  GRANT : process (BnRES, BCLK)
  begin
     if (BnRES) = '0' then           -- asynchronous reset
      -- do not grant any master, grant the TIC
      -- when BnRES = POR or INI
      AGNTARMD1    <= '0' after DLPG;
      AGNT001D1    <= '0' after DLPG;
      AGNT002D1    <= '0' after DLPG;
      AGNTTicD1    <= '1' after DLPG;
    elsif falling_edge(BCLK) then       -- clock off falling edge
      if AREQtic = '1' then             -- Test Interface controller
        AGNTARMD1     <= '0' after DLPG;
        AGNT001D1     <= '0' after DLPG;
        AGNT002D1     <= '0' after DLPG;
        AGNTTicD1     <= '1' after DLPG;
      elsif Pause = '1' then            -- Pause mode
        AGNTARMD1     <= '0' after DLPG;
        AGNT001D1     <= '0' after DLPG;
        AGNT002D1     <= '0' after DLPG;
        AGNTTicD1     <= '1' after DLPG;
      elsif AREQ001 = '1' then          -- Bus master #001
        AGNTARMD1     <= '0' after DLPG;
        AGNT001D1     <= '1' after DLPG;
        AGNT002D1     <= '0' after DLPG;
        AGNTTicD1     <= '0' after DLPG;
      elsif AREQ002 = '1' then         -- Bus master #002
        AGNTARMD1     <= '0' after DLPG;
        AGNT001D1     <= '0' after DLPG;
        AGNT002D1     <= '1' after DLPG;
        AGNTTicD1     <= '0' after DLPG;
      elsif AREQarm = '1' then         -- Bus Model master
        AGNTARMD1     <= '1' after DLPG;
        AGNT001D1     <= '0' after DLPG;
        AGNT002D1     <= '0' after DLPG;
        AGNTTicD1     <= '0' after DLPG;
      else                               -- Default bus master
        AGNTARMD1     <= '0' after DLPG;
        AGNT001D1     <= '0' after DLPG;
        AGNT002D1     <= '0' after DLPG;
        AGNTTicD1     <= '1' after DLPG;
      end if;
    end if;
  end process GRANT;

  -- Save actual value of AGNT on rising BCLK
  p_GntD2 : process (BCLK, BnRES)
  begin
    if (BnRES = '0') then
      AGNTARMD2    <= '0' after DLPG;
      AGNT001D2    <= '0' after DLPG;
      AGNT002D2    <= '0' after DLPG;
      AGNTTicD2    <= '1' after DLPG;
    elsif (rising_edge(BCLK)) then
      AGNTARMD2    <=  AGNTARMi after DLPG;
      AGNT001D2    <=  AGNT001i after DLPG;
      AGNT002D2    <=  AGNT002i after DLPG;
      AGNTTicD2    <=  AGNTTici after DLPG;
    end if;
  end process p_GntD2;

  --  Logic to determine when a turnaround cycle is happening and hence
  --  BLOK shouldn't be sampled.

--  Four bit comparator
  equal <= '1' after GAT3 when ((AGNTarmD1 = AGNTarmD2) and
                                (AGNTticD1 = AGNTticD2) and
                                (AGNT001D1 = AGNT001D2) and
                                (AGNT002D1 = AGNT002D2)) else '0' 
                                                             after GAT3;
                     
--  Handover cycle :AGNT changes and both BLOK and BWAIT are driven 
--  LOW. When this happens BLOK should be ignored on the next cycle:

  samplok <= equal or BWAIT or BLOK after GAT1;

--  Latch samplok in order to evaluate on next cycle

  l_samplok : process (BnRES, BCLK)
  begin
     if (BnRES) = '0' then              -- asynchronous reset
      samplokD2    <= '1' after DLPG;
     elsif rising_edge(BCLK) then       -- clock off rising edge
      samplokD2    <= samplok after DLPG;
     end if;
  end process l_samplok;

  -- Select actual AGNT
  AGNTARMi <= AGNTARMD1 after GAT1 when (SelD1GntT1 = '1') else
               AGNTARMD2 after GAT1;
  AGNT001i <= AGNT001D1 after GAT1 when (SelD1GntT1 = '1') else
               AGNT001D2 after GAT1;
  AGNT002i <= AGNT002D1 after GAT1 when (SelD1GntT1 = '1') else
               AGNT002D2 after GAT1;
  AGNTTici <= AGNTTicD1 after GAT1 when (SelD1GntT1 = '1') else
               AGNTTicD2 after GAT1;
  
  -- propagate internal signals to ports
  AGNTarm <= AGNTARMi;
  AGNTtic <= AGNTTici;
  AGNT001 <= AGNT001i;
  AGNT002 <= AGNT002i;
  
end synth;

-- --============================== End ==============================--
