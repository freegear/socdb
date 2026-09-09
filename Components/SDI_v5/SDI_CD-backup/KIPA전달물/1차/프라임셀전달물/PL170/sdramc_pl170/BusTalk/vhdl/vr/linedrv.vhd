-- -----------------------------------------------------------------------------
--  This confidential and proprietary software may be used only as
--  authorised by a licensing agreement from ARM Limited
--    (C) COPYRIGHT 1999 ARM Limited
--        ALL RIGHTS RESERVED
--  The entire notice above must be reproduced on all authorised
--  copies and copies may only be made to the extent permitted
--  by a licensing agreement from ARM Limited.
-- -----------------------------------------------------------------------------
--
--  Version and Release Control Information:
--
--  File Name              : linedrv.vhd,v
--  File Revision          : 1.1
--
--  Release Information    : PrimeCell(TM)-PL170-REL2v2
--
-- -----------------------------------------------------------------------------
--
-- Purpose   : Drives all the signals to virtual registers and checks for 
--             correct data during read cycle 
--
-- -----------------------------------------------------------------------------

library IEEE;
use     IEEE.std_logic_1164.all;
library common;
use     common.defs.all;
use     common.funcs.all;

entity linedrv is
  generic (
           Verbosity      : boolean;
           HaltOnMismatch : boolean
          );
  port (
        HCLK     : in std_logic;
        -- main system bus clock
        VIOSel   : in T_v_drv_sel;
        -- indicates the current vr cycle e.g Vwrite, Vread, v_count or v_idle
        VRPacket : in T_vr;
        -- packet containing info about values to be driven on virtual reg lines
        RegEn    : out std_ulogic;
        -- when high, indicates that the Virtual Register can be written into
        DataBus  : inout T_vreg;
        -- internal i/o between linedriver and vregbank module
        MaskBus  : out T_vreg
        -- 32 bit mask used for reading and comparing data from virtual register
       );
end linedrv;

-- -----------------------------------------------------------------------------
--
--                             linedrv
--                             =======
--
-- -----------------------------------------------------------------------------
--
-- Overview
-- ========
-- This module drives all the signal to virtual registers and checks the read 
-- data bus for the expected data.
--  
 
-- ================================ ARCHITECTURE ============================ --

architecture behavioural of linedrv is

-- -----------------------------------------------------------------------------
-- Signal declarations
-- -----------------------------------------------------------------------------
signal iRegSel : integer range 0 to 7;
-- indicates the virtual-register-number under consideration

signal iData   : T_vreg;
-- if it is VW command then iData is intermediate storage for data to be written

signal iMask   : T_vreg;
-- it is the 32bit mask used for both VR and VW

signal iPhase  : T_line;
-- in case of VW, this signal indicates the clock phase when write is to occur

signal iEdge   : T_line;
-- if VR, this signal indicates the clock edge, when the data is to be read

signal iTag    : string(1 to 20);
-- the tag to be flashed

signal iExp    : T_vreg;
-- in case of VR, this stores the data which is to be compared with VR value

signal iRegEn  : std_ulogic;
-- acts as latching signal, to latch the VWrite data into the Virtual Register

-- -----------------------------------------------------------------------------
-- Main body of code
-- =================
-- -----------------------------------------------------------------------------

begin

-- -----------------------------------------------------------------------------
-- Assigning the local copy to output
-- -----------------------------------------------------------------------------
RegEn    <= iRegEn;
MaskBus  <= iMask;

-- -----------------------------------------------------------------------------
-- The VRpacket values are latched, because by the time these values will be 
-- driven in/from virtual registers, a different packet might have been driven.
-- -----------------------------------------------------------------------------
p_LatchWVal : process (VIOSel, HCLK)
begin
  if ((VIOSel = Vwrite) or (VIOSel = Vread)) then
    iRegSel <= VRPacket.vregno;
    iData   <= VRPacket.data;
    iMask   <= VRPacket.mask;
    iPhase  <= VRPacket.phase;
    iExp    <= VRPacket.exp;
    iEdge   <= VRPacket.edge;
    iTag    <= VRPacket.tag;
  end if;
end process p_LatchWVal;

iRegEn <= '1' when ((iPhase = HCLK) and VIOSel = Vwrite) else '0';


-- -----------------------------------------------------------------------------
-- If there is a read cycle, no values should be driven on the data bus, thus it
-- is tristated. But if it is a write cycle, then latched VRpacket.data value
-- is driven on the data line, which is to be stored by vregbank.
-- -----------------------------------------------------------------------------
p_dbdriv : process (HCLK, VIOSel, iPhase, iData)
  begin
    if VIOSel = Vread then
      DataBus <= (others => 'Z');
    elsif VIOSel = Vwrite and iPhase = HCLK then
      DataBus <= iData;  
    end if;
end process p_dbdriv;

-- -----------------------------------------------------------------------------
-- Whenever there is a write to a virtual register, it is reported during the 
-- simulation if the parameter Verbosity is switched on.
-- -----------------------------------------------------------------------------
p_reportwr : process (DataBus)
begin 
  if DataBus'event  and VIOSel = Vwrite and Verbosity then
    ReportVirWrite(iData,iMask,iRegSel);
  end if;
end process p_reportwr;

-- -----------------------------------------------------------------------------
-- The following block reads the specified virtual register and compares it with
-- expected value. If it does not match then it "screams".
-- -----------------------------------------------------------------------------
p_reportrd : process (HCLK)
begin
  if (HCLK'event and (HCLK = iEdge)) and VIOSel = Vread then
    ReportVirRead(Verbosity, HaltOnMismatch, DataBus,iMask,iExp,iRegSel,iTag);
  end if;
end process;
    
end behavioural;

-- --================================= End ===================================--
