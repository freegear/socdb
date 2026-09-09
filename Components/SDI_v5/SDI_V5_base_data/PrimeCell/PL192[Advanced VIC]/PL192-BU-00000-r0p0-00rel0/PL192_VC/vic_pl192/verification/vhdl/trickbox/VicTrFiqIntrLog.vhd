-- --=========================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 2002 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
--
-- -----------------------------------------------------------------------------
-- Version and Release Control Information:
--
-- File Name              : VicTrFiqIntrLog.vhd.rca
-- File Revision          : 1.4
--
-- Release Information    : PrimeCell(TM)-PL192-r0p0-00rel0
--
-- -----------------------------------------------------------------------------
-- Purpose : The module generates the FIQ Interrupt.
--
-- --=========================================================================--
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

-- -----------------------------------------------------------------------------

entity VicTrFiqIntrLog is
  port (
-- Inputs
        HCLK             : in std_logic; -- AHB Clock
        HRESETn          : in std_logic; -- AHB Reset
        TrFiqStatus      : in std_logic_vector(31 downto 0);   
                                         -- Fiq Status from Interrupt 
                                         -- request block 
        nVicTrFiqIn      : in std_logic; -- Fiq Interrupt from daisy chain
        VicTrFiqInReg    : in std_logic; -- Enable bit to latch Fiq Interrupt
                                         -- from Daisy chain 

-- Outputs
      nVicTrFiq          : out std_logic -- FIQ Interrupt output
       );   
end VicTrFiqIntrLog;

-- -----------------------------------------------------------------------------
--
--                             VicTrFiqIntrLog
--                             ===============
--
-- -----------------------------------------------------------------------------
-- Overview
-- ========
-- -----------------------------------------------------------------------------
-- This module receives the TrFiqStatus and the Daisy FIQ Interrupt from the 
-- Interrupt Request block and generates the FIQ Interrupt nVicTrFiq.
-- -----------------------------------------------------------------------------

-- --============================= ARCHITECTURE ==============================--

architecture behavioural of VicTrFiqIntrLog is

-- -----------------------------------------------------------------------------
-- Component declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Constant declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Signal declarations
-- -----------------------------------------------------------------------------
signal InvnVicTrFiqIn   :  std_logic;   
-- Inverted version of VicTrFiqIn

signal DaisyFiqIn       :  std_logic;   
-- Daisy Fiq output

signal RegnVicTrFiq     :  std_logic;   
-- Registered Daisy chain Fiq Interrupt

signal iTrFiqStatus     :  std_logic;   
-- Internal TrFiqStatus

-- -----------------------------------------------------------------------------
-- Function declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Type declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
--
-- Main body of code
-- =================
--
-- -----------------------------------------------------------------------------

begin

-- -----------------------------------------------------------------------------
-- nVicTrFiq generation
-- -----------------------------------------------------------------------------
InvnVicTrFiqIn <= not nVicTrFiqIn ;

-- -----------------------------------------------------------------------------
-- Registering the FIQ Interrupt from Daisy chain if VicTrFiqInReg is
-- enabled.
-- -----------------------------------------------------------------------------
p_FiqDaisy : process (HCLK, HRESETn)
begin
  if (HRESETn = '0') then
    RegnVicTrFiq <= '0';    
  elsif (HCLK'EVENT and HCLK = '1') then
    RegnVicTrFiq <= InvnVicTrFiqIn;    
  end if;
end process p_FiqDaisy;

DaisyFiqIn <= RegnVicTrFiq when (VicTrFiqInReg = '1') 
            else 
              InvnVicTrFiqIn ;

iTrFiqStatus <= TrFiqStatus(31) or TrFiqStatus(30) or TrFiqStatus(29) or
                TrFiqStatus(28) or TrFiqStatus(27) or TrFiqStatus(26) or
                TrFiqStatus(25) or TrFiqStatus(24) or TrFiqStatus(23) or
                TrFiqStatus(22) or TrFiqStatus(21) or TrFiqStatus(20) or
                TrFiqStatus(19) or TrFiqStatus(18) or TrFiqStatus(17) or 
                TrFiqStatus(16) or TrFiqStatus(15) or TrFiqStatus(14) or 
                TrFiqStatus(13) or TrFiqStatus(12) or TrFiqStatus(11) or 
                TrFiqStatus(10) or TrFiqStatus(9)  or TrFiqStatus(8)  or 
                TrFiqStatus(7)  or TrFiqStatus(6)  or TrFiqStatus(5)  or 
                TrFiqStatus(4)  or TrFiqStatus(3)  or TrFiqStatus(2)  or 
                TrFiqStatus(1)  or TrFiqStatus(0); 
                 
nVicTrFiq <= not (DaisyFiqIn or iTrFiqStatus) ;

end behavioural;

-- --================================== End ==================================--
