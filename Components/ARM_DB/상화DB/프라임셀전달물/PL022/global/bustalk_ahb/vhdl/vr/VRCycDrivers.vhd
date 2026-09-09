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
-- File Name              : VRCycDrivers.vhd.rca
-- File Revision          : 1.1
--
-- Release Information    : PrimeCell(TM)-GLOBAL-REL1v5
--
-- ---------------------------------------------------------------------
-- Purpose :
--           This module will generate the requests for a new command as
--           well as initiates actions depending on whether it is a VR 
--           or VW command 
--
-- --=================================================================--

library IEEE;
use     IEEE.std_logic_1164.all;

library common;
use     common.defs.all;

-- ---------------------------------------------------------------------

entity VRCycDrivers is
  port (
        HCLK      : in std_logic;
        -- The main bus clock
        CycSel    : in T_cyclebus;
        -- the cycle type driven out by the reader, c_vw, c_vr etc.
        Vrpacket  : in T_vrbus;
        -- packet containing info about values to be driven on virtual
        -- reg lines
        CycCount  : in T_int;
        -- indicates the 'current-cycle-number' of the transfer being
        -- driven
        VRGetLine : out T_get;
        -- get_line request issued by the vr_block
        VIOSel    : out T_v_drv_selbus
        -- indicates the current vr cycle e.g Vwrite, Vread, v_count or
        -- Vidle
       );
end VRCycDrivers;

-- ---------------------------------------------------------------------
--
--                             VRCycDrivers
--                             ============
--
-- ---------------------------------------------------------------------
--
-- Overview
-- ========
--   This module request packets by generating Gget and selects the
-- appropriate VR registers for a read or write operation. It always
-- checks for a VR or VW command and becomes active till it gets a new
-- bid command from reader module  
--
-- ---------------------------------------------------------------------
 
-- --========================= ARCHITECTURE ==========================--

architecture behavioural of VRCycDrivers is
 
-- ---------------------------------------------------------------------
-- Signal declarations
-- ---------------------------------------------------------------------
signal MaxVal   : T_int := 0;
-- indicates the highest delay amongst the seven VRegisters in the
-- Vrpacket

signal VRActive : T_boolbus := (others => FALSE);
-- indicates if any VR read or write is to take place in current clock
-- cycle

signal iVIOSel  : T_v_drv_selbus := (0 => Vread, 1 => Vread, 2 => Vread,
                                     3 => Vread, 4 => Vread, 5 => Vread,
                                     6 => Vread, 7 => Vread);
-- indicates the current vr cycle e.g Vwrite, Vread, v_count or Vidle

-- ---------------------------------------------------------------------
--
-- Main body of code
-- =================
--
-- ---------------------------------------------------------------------

begin

-- ---------------------------------------------------------------------
-- Assigning the local copy to output
-- ---------------------------------------------------------------------
VIOSel <= iVIOSel;
    
-- ---------------------------------------------------------------------
-- This process determines the particular register to be read or written
-- into as well as to ensure that it will happen only if the delay is
-- less than that for the delay taken by bid command
-- ---------------------------------------------------------------------
p_loader : process (CycSel, HCLK)            
variable TempVal : T_int := 0;
begin
  if (HCLK = '0') then
    for i in 0 to 7 loop
      if ((CycSel(i) = Cvr) or (CycSel(i) = Cvw)) then
        VRActive(i) <= TRUE;
        if TempVal < Vrpacket(i).delay then
          TempVal := Vrpacket(i).delay;
        end if;
        MaxVal <= TempVal;
      elsif CycSel(i) = Cidle then
        VRActive(i) <= FALSE;
      end if;
    end loop;
  end if;
  TempVal := 0;
end process p_loader;

-- ---------------------------------------------------------------------
-- Generates a read or write signal to the particular VR
-- ---------------------------------------------------------------------
p_VTiming : process (CycCount, HCLK, VRActive)
begin
  if (HCLK = '1') then
    for i in 0 to 7 loop
      if VRActive(i) then
        if (CycCount = Vrpacket(i).delay) then
          if Vrpacket(i).write = '1' then
            iVIOSel(i) <= Vwrite;
          else
            iVIOSel(i) <= Vread;
          end if;
        elsif (CycCount < Vrpacket(i).delay) then
          iVIOSel(i) <= Vcount;
        end if;
      elsif (iVIOSel(i) = Vcount) then
        if (CycCount = Vrpacket(i).delay) then
          if (Vrpacket(i).write = '1') then
            iVIOSel(i) <= Vwrite;
          else
            iVIOSel(i) <= Vread;
          end if;
        end if;
      elsif (iVIOSel(i) = Vwrite or iVIOSel(i) = Vread) then
        iVIOSel(i) <= Vidle;
      else
        iVIOSel(i) <= Vidle;
      end if;
    end loop;
  end if;
end process p_VTiming;

-- ---------------------------------------------------------------------
-- Generates request to reader for a new VR command
-- ---------------------------------------------------------------------
p_LineOutput : process (CycCount)  
begin
  if MaxVal = CycCount or CycCount = 1 then
    VRGetLine <= Gget;
  else
    VRGetLine <= Gidle;
  end if;
end process;

end behavioural;

-- --============================== End ==============================--
