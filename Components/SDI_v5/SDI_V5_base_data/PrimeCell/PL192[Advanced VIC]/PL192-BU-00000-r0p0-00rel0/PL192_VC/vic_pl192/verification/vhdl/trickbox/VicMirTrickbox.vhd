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
-- File Name              : VicMirTrickbox.vhd.rca
-- File Revision          : 1.4
--
-- Release Information    : PrimeCell(TM)-PL192-r0p0-00rel0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           Top level of the VIC Mirror Trick Box.
--
-- --=========================================================================--
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;


-- -----------------------------------------------------------------------------

entity VicMirTrickbox is
  port (
-- Inputs
        HCLK             : in std_logic;   --  AHB Clock
        HRESETn          : in std_logic;   --  AHB reset
        VicTrIntSource   : in std_logic_vector(31 downto 0);   
                                           --  Peripheral interrupt 
                                           --  source input
        nVicTrFiqIn      : in std_logic;   --  FIQ interrupt from 
                                           --  the daisy chain VIC
        nVicTrIrqIn      : in std_logic;   --  IRQ interrupt from 
                                           --  the daisy chain VIC
        VicTrVectAddrIn  : in std_logic_vector(31 downto 0);   
                                           --  Vector address from 
                                           --  the daisy chain VIC
        VicTrIrqInReg    : in std_logic;   --  Register enable signal 
                                           --  for VICIRQIN
        VicTrFiqInReg    : in std_logic;   --  Register enable signal 
                                           --  for VICFIQIN
        VicTrIrqAck      : in std_logic;   --  Acknowledge signal 
                                           --  from the CPU
        nVicTrSyncEn     : in std_logic;   --  Synchronous enable 
                                           --  signal for the vic port
        VicTrSoftInt     : in std_logic_vector(31 downto 0);   
                                           --  Software interrupt
        VicTrIntEn       : in std_logic_vector(31 downto 0);   
                                           --  Interrupt enable
        VicTrIntSelect   : in std_logic_vector(31 downto 0);   
                                           --  Interrupt type select
        VicTrSwPriMask   : in std_logic_vector(15 downto 0);   
                                         --  Software Priority Mask
        VicTrVectPriDsy  : in std_logic_vector(3 downto 0);   
                                           --  Vector priority 
                                           --  daisy chain interrupt
        VicTrVectPrity0  : in std_logic_vector(3 downto 0);   
                                           --  Vector priority for 0th 
                                           --  interrupt source
        VicTrVectPrity1  : in std_logic_vector(3 downto 0);
                                           --  Vector priority for 1st 
                                           --  interrupt source
        VicTrVectPrity2  : in std_logic_vector(3 downto 0);
                                           --  Vector priority for 2nd 
                                           --  interrupt source
        VicTrVectPrity3  : in std_logic_vector(3 downto 0);
                                           --  Vector priority for 3rd 
                                           --  interrupt source
        VicTrVectPrity4  : in std_logic_vector(3 downto 0);
                                           --  Vector priority for 4th 
                                           --  interrupt source
        VicTrVectPrity5  : in std_logic_vector(3 downto 0);
                                           --  Vector priority for 5th 
                                           --  interrupt source
        VicTrVectPrity6  : in std_logic_vector(3 downto 0);
                                           --  Vector priority for 6th 
                                           --  interrupt source
        VicTrVectPrity7  : in std_logic_vector(3 downto 0);
                                          --  Vector priority for 7th 
                                          --  interrupt source
        VicTrVectPrity8  : in std_logic_vector(3 downto 0);
                                           --  Vector priority for 8th 
                                           --  interrupt source
        VicTrVectPrity9  : in std_logic_vector(3 downto 0);
                                           --  Vector priority for 9th 
                                           --  interrupt source
        VicTrVectPrity10 : in std_logic_vector(3 downto 0);
                                           --  Vector priority for 10th 
                                           --  interrupt source
        VicTrVectPrity11 : in std_logic_vector(3 downto 0);
                                           --  Vector priority for 11th 
                                           --  interrupt source
        VicTrVectPrity12 : in std_logic_vector(3 downto 0);
                                           --  Vector priority for 12th 
                                           --  interrupt source
        VicTrVectPrity13 : in std_logic_vector(3 downto 0);
                                           --  Vector priority for 13th 
                                           --  interrupt source
        VicTrVectPrity14 : in std_logic_vector(3 downto 0);
                                           --  Vector priority for 14th 
                                           --  interrupt source
        VicTrVectPrity15 : in std_logic_vector(3 downto 0);
                                           --  Vector priority for 15th 
                                           --  interrupt source
        VicTrVectPrity16 : in std_logic_vector(3 downto 0);
                                           --  Vector priority for 16th 
                                           --  interrupt source
        VicTrVectPrity17 : in std_logic_vector(3 downto 0);
                                           --  Vector priority for 17th 
                                           --  interrupt source
        VicTrVectPrity18 : in std_logic_vector(3 downto 0);
                                           --  Vector priority for 18th 
                                           --  interrupt source
        VicTrVectPrity19 : in std_logic_vector(3 downto 0);
                                           --  Vector priority for 19th 
                                           --  interrupt source
        VicTrVectPrity20 : in std_logic_vector(3 downto 0);
                                           --  Vector priority for 20th 
                                           --  interrupt source
        VicTrVectPrity21 : in std_logic_vector(3 downto 0);
                                           --  Vector priority for 21st 
                                           --  interrupt source
        VicTrVectPrity22 : in std_logic_vector(3 downto 0);
                                           --  Vector priority for 22nd 
                                           --  interrupt source
        VicTrVectPrity23 : in std_logic_vector(3 downto 0);
                                           --  Vector priority for 23rd 
                                           --  interrupt source
        VicTrVectPrity24 : in std_logic_vector(3 downto 0);
                                           --  Vector priority for 24th 
                                           --  interrupt source
        VicTrVectPrity25 : in std_logic_vector(3 downto 0);
                                           --  Vector priority for 25th 
                                           --  interrupt source
        VicTrVectPrity26 : in std_logic_vector(3 downto 0);
                                           --  Vector priority for 26th 
                                           --  interrupt source
        VicTrVectPrity27 : in std_logic_vector(3 downto 0);
                                           --  Vector priority for 27th 
                                           --  interrupt source
        VicTrVectPrity28 : in std_logic_vector(3 downto 0);
                                           --  Vector priority for 28th 
                                           --  interrupt source
        VicTrVectPrity29 : in std_logic_vector(3 downto 0);
                                           --  Vector priority for 29th 
                                           --  interrupt source
        VicTrVectPrity30 : in std_logic_vector(3 downto 0);
                                           --  Vector priority for 30th 
                                           --  interrupt source
        VicTrVectPrity31 : in std_logic_vector(3 downto 0);
                                           --  Vector priority for 31st 
                                           --  interrupt source
        VicTrVectAddr0   : in std_logic_vector(31 downto 0);
                                           -- Vector address 
                                           -- 0th interrupt source
        VicTrVectAddr1   : in std_logic_vector(31 downto 0);
                                           -- Vector address for
                                           -- 1st interrupt source
        VicTrVectAddr2   : in std_logic_vector(31 downto 0);
                                           -- Vector address for
                                           -- 2nd interrupt source
        VicTrVectAddr3   : in std_logic_vector(31 downto 0);
                                           -- Vector address for
                                           -- 3rd interrupt source
        VicTrVectAddr4   : in std_logic_vector(31 downto 0);
                                           -- Vector address for
                                           -- 4th interrupt source
        VicTrVectAddr5   : in std_logic_vector(31 downto 0);
                                           -- Vector address for
                                           -- 5th interrupt source
        VicTrVectAddr6   : in std_logic_vector(31 downto 0);
                                           -- Vector address for
                                           -- 6th interrupt source
        VicTrVectAddr7   : in std_logic_vector(31 downto 0);
                                           -- Vector address for
                                           -- 7th interrupt source
        VicTrVectAddr8   : in std_logic_vector(31 downto 0);
                                           -- Vector address for
                                           -- 8th interrupt source
        VicTrVectAddr9   : in std_logic_vector(31 downto 0);
                                           -- Vector address for
                                           -- 9th interrupt source
        VicTrVectAddr10  : in std_logic_vector(31 downto 0); 
                                           -- Vector address for
                                           -- 10th interrupt source
        VicTrVectAddr11  : in std_logic_vector(31 downto 0);
                                           -- Vector address for
                                           -- 11th interrupt source
        VicTrVectAddr12  : in std_logic_vector(31 downto 0);
                                           -- Vector address for
                                           -- 12th interrupt source
        VicTrVectAddr13  : in std_logic_vector(31 downto 0);
                                           -- Vector address for
                                           -- 13th interrupt source
        VicTrVectAddr14  : in std_logic_vector(31 downto 0);
                                           -- Vector address for
                                           -- 14th interrupt source
        VicTrVectAddr15  : in std_logic_vector(31 downto 0);
                                           -- Vector address for
                                           -- 15th interrupt source
        VicTrVectAddr16  : in std_logic_vector(31 downto 0);
                                           -- Vector address for
                                           -- 16th interrupt source
        VicTrVectAddr17  : in std_logic_vector(31 downto 0);
                                           -- Vector address for
                                           -- 17th interrupt source
        VicTrVectAddr18  : in std_logic_vector(31 downto 0);
                                           -- Vector address for
                                           -- 18th interrupt source
        VicTrVectAddr19  : in std_logic_vector(31 downto 0);
                                           -- Vector address for
                                           -- 19th interrupt source
        VicTrVectAddr20  : in std_logic_vector(31 downto 0);
                                           -- Vector address for
                                           -- 20th interrupt source
        VicTrVectAddr21  : in std_logic_vector(31 downto 0);
                                           -- Vector address for
                                           -- 21st interrupt source
        VicTrVectAddr22  : in std_logic_vector(31 downto 0);
                                           -- Vector address for
                                           -- 22nd interrupt source
        VicTrVectAddr23  : in std_logic_vector(31 downto 0);
                                           -- Vector address for
                                           -- 23rd interrupt source
        VicTrVectAddr24  : in std_logic_vector(31 downto 0);
                                           -- Vector address for
                                           -- 24th interrupt source
        VicTrVectAddr25  : in std_logic_vector(31 downto 0);
                                           -- Vector address for
                                           -- 25th interrupt source
        VicTrVectAddr26  : in std_logic_vector(31 downto 0);
                                           -- Vector address for
                                           -- 26th interrupt source
        VicTrVectAddr27  : in std_logic_vector(31 downto 0);
                                           -- Vector address for
                                           -- 27th interrupt source
        VicTrVectAddr28  : in std_logic_vector(31 downto 0);
                                           -- Vector address for
                                           -- 28th interrupt source
        VicTrVectAddr29  : in std_logic_vector(31 downto 0);
                                           -- Vector address for
                                           -- 29th interrupt source
        VicTrVectAddr30  : in std_logic_vector(31 downto 0);
                                           -- Vector address for
                                           -- 30th interrupt source
        VicTrVectAddr31  : in std_logic_vector(31 downto 0);
                                           -- Vector address for
                                           -- 31st interrupt source
        VectAddrWrTrig   : in std_logic;   -- Indicates a write on 
                                           -- VICADDRESS register
        VectAddrRdTrig   : in std_logic;   -- Indicates a read 
                                           -- on VICADDRESS register
        AsyncRdEn        : in std_logic;   -- Asynchronous read enable 
                                           -- signal
  
-- Outputs
        VicTrRawIntr     : out std_logic_vector(31 downto 0);   
                                           -- Raw Interrupt source
        VicTrIrqStatus   : out std_logic_vector(31 downto 0);   
                                           -- IRQ Interrupt status
        VicTrFiqStatus   : out std_logic_vector(31 downto 0);   
                                           -- FIQ Interrupt status
        nVicTrFiq        : out std_logic;  -- FIQ Interrupt to CPU
        nVicTrIrq        : out std_logic;  -- IRQ Interrupt to CPU
        VicTrIrqAckOut   : out std_logic;  -- ACKOUT signal to Daisy 
                                           -- Chain Vic
        VicTrVectAddrv   : out std_logic;  -- Address valid signal
        VicTrVectAddr    : out std_logic_vector(31 downto 0));   
                                           -- Vector Address out line
end VicMirTrickbox;

-- -----------------------------------------------------------------------------
-- Overview
-- ========
-- This is the top level of Mirror Trickbox. It Instantiates the following
-- modules
-- a) VicTrIntReqLog  -- Interrupt Request Logic 
-- b) VicTrFiqIntrLog -- Fiq Interrupt Logic
-- c) VicTrIrqIntrLog -- IRQ Interrupt Logic
-- d) VicTrIrqPriLog  -- IRQ Priority Logic
--
-- -----------------------------------------------------------------------------
--
--                             VicMirTrickbox
--                             ==============
--
-- -----------------------------------------------------------------------------

-- ================================ ARCHITECTURE ============================ --

architecture behavioural of VicMirTrickbox is

-- -----------------------------------------------------------------------------
-- Component declarations
-- -----------------------------------------------------------------------------
-- -----------------------------------------------------------------------------
-- FIQ Interrupt Logic Block 
-- -----------------------------------------------------------------------------
component VicTrFiqIntrLog
  port (
        HCLK             : in std_logic;
        HRESETn          : in std_logic;
        TrFiqStatus      : in std_logic_vector(31 downto 0);
        nVicTrFiqIn      : in std_logic;
        VicTrFiqInReg    : in std_logic;
      nVicTrFiq          : out std_logic
       );
end component;

-- -----------------------------------------------------------------------------
-- Interrupt Request Logic Block 
-- -----------------------------------------------------------------------------
component VicTrIntReqLog
  port (
        HCLK             : in std_logic;
        HRESETn          : in std_logic;
        VicTrIntSource   : in std_logic_vector(31 downto 0);
        VicTrSoftInt     : in std_logic_vector(31 downto 0);
        VicTrIntEn       : in std_logic_vector(31 downto 0);
        VicTrIntSelect   : in std_logic_vector(31 downto 0);
        nVicTrIrqIn      : in std_logic;
        VicTrFiqStatus   : out std_logic_vector(31 downto 0);
        VicTrIrqStatus   : out std_logic_vector(31 downto 0);
        TrIrqStatus      : out std_logic_vector(31 downto 0);
        TrnIrq           : out std_logic;
        TrFiqStatus      : out std_logic_vector(31 downto 0);
        VicTrRawIntr     : out std_logic_vector(31 downto 0)
       );
end component;

-- -----------------------------------------------------------------------------
-- VIC IRQ Priority Logic Block 
-- -----------------------------------------------------------------------------
component VicTrIrqPriLog
   port (
         HCLK             : in std_logic;
         HRESETn          : in std_logic;
         TrnIrq           : in std_logic;
         IrqStatus        : in std_logic_vector(31 downto 0);
         DaisyIrqOut      : in std_logic;
         TrVectIrq        : in std_logic_vector(32 downto 0);
         nVicTrSyncEn     : in std_logic;
         PPTable0         : in std_logic_vector(32 downto 0);
         PPTable1         : in std_logic_vector(32 downto 0);
         PPTable2         : in std_logic_vector(32 downto 0);
         PPTable3         : in std_logic_vector(32 downto 0);
         PPTable4         : in std_logic_vector(32 downto 0);
         PPTable5         : in std_logic_vector(32 downto 0);
         PPTable6         : in std_logic_vector(32 downto 0);
         PPTable7         : in std_logic_vector(32 downto 0);
         PPTable8         : in std_logic_vector(32 downto 0);
         PPTable9         : in std_logic_vector(32 downto 0);
         PPTable10        : in std_logic_vector(32 downto 0);
         PPTable11        : in std_logic_vector(32 downto 0);
         PPTable12        : in std_logic_vector(32 downto 0);
         PPTable13        : in std_logic_vector(32 downto 0);
         PPTable14        : in std_logic_vector(32 downto 0);
         PPTable15        : in std_logic_vector(32 downto 0);
         VicTrVectAddr0   : in std_logic_vector(31 downto 0);
         VicTrVectAddr1   : in std_logic_vector(31 downto 0);
         VicTrVectAddr2   : in std_logic_vector(31 downto 0);
         VicTrVectAddr3   : in std_logic_vector(31 downto 0);
         VicTrVectAddr4   : in std_logic_vector(31 downto 0);
         VicTrVectAddr5   : in std_logic_vector(31 downto 0);
         VicTrVectAddr6   : in std_logic_vector(31 downto 0);
         VicTrVectAddr7   : in std_logic_vector(31 downto 0);
         VicTrVectAddr8   : in std_logic_vector(31 downto 0);
         VicTrVectAddr9   : in std_logic_vector(31 downto 0);
         VicTrVectAddr10  : in std_logic_vector(31 downto 0);
         VicTrVectAddr11  : in std_logic_vector(31 downto 0);
         VicTrVectAddr12  : in std_logic_vector(31 downto 0);
         VicTrVectAddr13  : in std_logic_vector(31 downto 0);
         VicTrVectAddr14  : in std_logic_vector(31 downto 0);
         VicTrVectAddr15  : in std_logic_vector(31 downto 0);
         VicTrVectAddr16  : in std_logic_vector(31 downto 0);
         VicTrVectAddr17  : in std_logic_vector(31 downto 0);
         VicTrVectAddr18  : in std_logic_vector(31 downto 0);
         VicTrVectAddr19  : in std_logic_vector(31 downto 0);
         VicTrVectAddr20  : in std_logic_vector(31 downto 0);
         VicTrVectAddr21  : in std_logic_vector(31 downto 0);
         VicTrVectAddr22  : in std_logic_vector(31 downto 0);
         VicTrVectAddr23  : in std_logic_vector(31 downto 0);
         VicTrVectAddr24  : in std_logic_vector(31 downto 0);
         VicTrVectAddr25  : in std_logic_vector(31 downto 0);
         VicTrVectAddr26  : in std_logic_vector(31 downto 0);
         VicTrVectAddr27  : in std_logic_vector(31 downto 0);
         VicTrVectAddr28  : in std_logic_vector(31 downto 0);
         VicTrVectAddr29  : in std_logic_vector(31 downto 0);
         VicTrVectAddr30  : in std_logic_vector(31 downto 0);
         VicTrVectAddr31  : in std_logic_vector(31 downto 0);
         VicTrVectAddrIn  : in std_logic_vector(31 downto 0);
         VicTrIrqAck      : in std_logic;
         VectAddrWrTrigIn : in std_logic;
         VectAddrRdTrigIn : in std_logic;
         AsyncRdEn        : in std_logic;
         VicTrIrqOut      : out std_logic;
         nTrIrq           : out std_logic;
         VectAddrVld      : out std_logic;
         VicTrVectAddrv   : out std_logic;
         MaskPrityReg     : out std_logic_vector(15 downto 0);
         VicTrVectAddr    : out std_logic_vector(31 downto 0)
        );
end component;

-- -----------------------------------------------------------------------------
--  VIC IRQ Interrupt Logic Block 
-- -----------------------------------------------------------------------------
component VicTrIrqIntrLog
  port (
        HCLK             : in  std_logic;
        HRESETn          : in  std_logic;
        nVicTrIrqIn      : in  std_logic;
        VicTrIrqInReg    : in  std_logic;
        IrqStatus        : in  std_logic_vector(31 downto 0);
        VectAddrVld      : in  std_logic;
        nVicTrSyncEn     : in  std_logic;
        VicTrSwPriMask   : in  std_logic_vector(15 downto 0);
        VicTrVectPriDsy  : in  std_logic_vector(3 downto 0);
        VicTrVectPrity0  : in  std_logic_vector(3 downto 0);
        VicTrVectPrity1  : in  std_logic_vector(3 downto 0);
        VicTrVectPrity2  : in  std_logic_vector(3 downto 0);
        VicTrVectPrity3  : in  std_logic_vector(3 downto 0);
        VicTrVectPrity4  : in  std_logic_vector(3 downto 0);
        VicTrVectPrity5  : in  std_logic_vector(3 downto 0);
        VicTrVectPrity6  : in  std_logic_vector(3 downto 0);
        VicTrVectPrity7  : in  std_logic_vector(3 downto 0);
        VicTrVectPrity8  : in  std_logic_vector(3 downto 0);
        VicTrVectPrity9  : in  std_logic_vector(3 downto 0);
        VicTrVectPrity10 : in  std_logic_vector(3 downto 0);
        VicTrVectPrity11 : in  std_logic_vector(3 downto 0);
        VicTrVectPrity12 : in  std_logic_vector(3 downto 0);
        VicTrVectPrity13 : in  std_logic_vector(3 downto 0);
        VicTrVectPrity14 : in  std_logic_vector(3 downto 0);
        VicTrVectPrity15 : in  std_logic_vector(3 downto 0);
        VicTrVectPrity16 : in  std_logic_vector(3 downto 0);
        VicTrVectPrity17 : in  std_logic_vector(3 downto 0);
        VicTrVectPrity18 : in  std_logic_vector(3 downto 0);
        VicTrVectPrity19 : in  std_logic_vector(3 downto 0);
        VicTrVectPrity20 : in  std_logic_vector(3 downto 0);
        VicTrVectPrity21 : in  std_logic_vector(3 downto 0);
        VicTrVectPrity22 : in  std_logic_vector(3 downto 0);
        VicTrVectPrity23 : in  std_logic_vector(3 downto 0);
        VicTrVectPrity24 : in  std_logic_vector(3 downto 0);
        VicTrVectPrity25 : in  std_logic_vector(3 downto 0);
        VicTrVectPrity26 : in  std_logic_vector(3 downto 0);
        VicTrVectPrity27 : in  std_logic_vector(3 downto 0);
        VicTrVectPrity28 : in  std_logic_vector(3 downto 0);
        VicTrVectPrity29 : in  std_logic_vector(3 downto 0);
        VicTrVectPrity30 : in  std_logic_vector(3 downto 0);
        VicTrVectPrity31 : in  std_logic_vector(3 downto 0);
        MaskPrityReg     : in  std_logic_vector(15 downto 0);
        nTrIrq           : in  std_logic;
        TrVectIrq        : out std_logic_vector(32 downto 0);
        DaisyIrqOut      : out std_logic;
        PPTable0         : out std_logic_vector(32 downto 0);
        PPTable1         : out std_logic_vector(32 downto 0);
        PPTable2         : out std_logic_vector(32 downto 0);
        PPTable3         : out std_logic_vector(32 downto 0);
        PPTable4         : out std_logic_vector(32 downto 0);
        PPTable5         : out std_logic_vector(32 downto 0);
        PPTable6         : out std_logic_vector(32 downto 0);
        PPTable7         : out std_logic_vector(32 downto 0);
        PPTable8         : out std_logic_vector(32 downto 0);
        PPTable9         : out std_logic_vector(32 downto 0);
        PPTable10        : out std_logic_vector(32 downto 0);
        PPTable11        : out std_logic_vector(32 downto 0);
        PPTable12        : out std_logic_vector(32 downto 0);
        PPTable13        : out std_logic_vector(32 downto 0);
        PPTable14        : out std_logic_vector(32 downto 0);
        PPTable15        : out std_logic_vector(32 downto 0));
end component;

-- -----------------------------------------------------------------------------
-- Constant declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Signal declarations
-- -----------------------------------------------------------------------------
signal TrnIrq          :  std_logic; -- IRQ Interrupts from VicTrIntReqLog 
                                     -- Block 
signal TrIrqStatus     :  std_logic_vector(31 downto 0);   
                                     --  IRQStatus output
signal TrFiqStatus     :  std_logic_vector(31 downto 0);   
                                     --  IRQStatus output
signal VectAddrVld     :  std_logic; --  Address Valid Indicator
signal TrVectIrq       :  std_logic_vector(32 downto 0);   
                                     --  VectIRQ from IRQ Interrupt Logic
signal PPTable0        :  std_logic_vector(32 downto 0); 
                                     --  Priority Level 0
signal PPTable1        :  std_logic_vector(32 downto 0); 
                                     --  Priority Level 1
signal PPTable2        :  std_logic_vector(32 downto 0); 
                                     --  Priority Level 2
signal PPTable3        :  std_logic_vector(32 downto 0);
                                     --  Priority Level 3
signal PPTable4        :  std_logic_vector(32 downto 0);
                                     --  Priority Level 4
signal PPTable5        :  std_logic_vector(32 downto 0);
                                     --  Priority Level 5
signal PPTable6        :  std_logic_vector(32 downto 0);
                                     --  Priority Level 6
signal PPTable7        :  std_logic_vector(32 downto 0);
                                     --  Priority Level 7
signal PPTable8        :  std_logic_vector(32 downto 0);
                                     --  Priority Level 8
signal PPTable9        :  std_logic_vector(32 downto 0);
                                     --  Priority Level 9
signal PPTable10       :  std_logic_vector(32 downto 0);
                                     --  Priority Level 10
signal PPTable11       :  std_logic_vector(32 downto 0);
                                     --  Priority Level 11
signal PPTable12       :  std_logic_vector(32 downto 0);
                                     --  Priority Level 12
signal PPTable13       :  std_logic_vector(32 downto 0);
                                     --  Priority Level 13
signal PPTable14       :  std_logic_vector(32 downto 0);
                                     --  Priority Level 14
signal PPTable15       :  std_logic_vector(32 downto 0);
                                     --  Priority Level 15
signal nTrIrq          :  std_logic; --  Irq Interrupt
signal MaskPrityReg    :  std_logic_vector(15 downto 0);
                                     --  Mask updated value
signal inVicTrFiq      :  std_logic; -- Fiq Internal signal  
signal inVicTrIrq      :  std_logic; -- Irq Internal signal  
signal DaisyIrqOut     :  std_logic; -- Daisy Input  

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
-- ---------------------------------------------------------------------------

begin

-- -----------------------------------------------------------------------------
-- Local copies assignment
-- -----------------------------------------------------------------------------
nVicTrIrq      <= inVicTrIrq;
   
-- -----------------------------------------------------------------------------
-- Interrupt Request Logic Block instantiation
-- -----------------------------------------------------------------------------
uVicTrIntReqLog : VicTrIntReqLog 
  port map (
            HCLK              => HCLK,       
            HRESETn           => HRESETn,
            VicTrIntSource    => VicTrIntSource,
            VicTrSoftInt      => VicTrSoftInt,
            VicTrIntEn        => VicTrIntEn,
            VicTrIntSelect    => VicTrIntSelect,
            nVicTrIrqIn       => nVicTrIrqIn,
            VicTrFiqStatus    => VicTrFiqStatus,
            VicTrIrqStatus    => VicTrIrqStatus,
            TrIrqStatus       => TrIrqStatus,
            TrnIrq            => TrnIrq,
            TrFiqStatus       => TrFiqStatus,
            VicTrRawIntr      => VicTrRawIntr
           );   

-- -----------------------------------------------------------------------------
-- FIQ Interrupt Logic Block instantiation
-- -----------------------------------------------------------------------------
uVicTrFiqIntrLog : VicTrFiqIntrLog 
  port map (
            HCLK              => HCLK,
            HRESETn           => HRESETn,
            TrFiqStatus       => TrFiqStatus,
            nVicTrFiqIn       => nVicTrFiqIn,
            VicTrFiqInReg     => VicTrFiqInReg,
            nVicTrFiq         => nVicTrFiq
           );   

-- -----------------------------------------------------------------------------
--  VIC IRQ Interrupt Logic Block instantiation
-- -----------------------------------------------------------------------------
uVicTrIrqIntrLog : VicTrIrqIntrLog 
  port map (
            HCLK              => HCLK,
            HRESETn           => HRESETn,
            nVicTrIrqIn       => nVicTrIrqIn,
            VicTrIrqInReg     => VicTrIrqInReg,
            IrqStatus         => TrIrqStatus,
            VectAddrVld       => VectAddrVld,
            nVicTrSyncEn      => nVicTrSyncEn,
            VicTrSwPriMask    => VicTrSwPriMask,
            VicTrVectPriDsy   => VicTrVectPriDsy,
            VicTrVectPrity0   => VicTrVectPrity0,
            VicTrVectPrity1   => VicTrVectPrity1,
            VicTrVectPrity2   => VicTrVectPrity2,
            VicTrVectPrity3   => VicTrVectPrity3,
            VicTrVectPrity4   => VicTrVectPrity4,
            VicTrVectPrity5   => VicTrVectPrity5,
            VicTrVectPrity6   => VicTrVectPrity6,
            VicTrVectPrity7   => VicTrVectPrity7,
            VicTrVectPrity8   => VicTrVectPrity8,
            VicTrVectPrity9   => VicTrVectPrity9,
            VicTrVectPrity10  => VicTrVectPrity10,
            VicTrVectPrity11  => VicTrVectPrity11,
            VicTrVectPrity12  => VicTrVectPrity12,
            VicTrVectPrity13  => VicTrVectPrity13,
            VicTrVectPrity14  => VicTrVectPrity14,
            VicTrVectPrity15  => VicTrVectPrity15,
            VicTrVectPrity16  => VicTrVectPrity16,
            VicTrVectPrity17  => VicTrVectPrity17,
            VicTrVectPrity18  => VicTrVectPrity18,
            VicTrVectPrity19  => VicTrVectPrity19,
            VicTrVectPrity20  => VicTrVectPrity20,
            VicTrVectPrity21  => VicTrVectPrity21,
            VicTrVectPrity22  => VicTrVectPrity22,
            VicTrVectPrity23  => VicTrVectPrity23,
            VicTrVectPrity24  => VicTrVectPrity24,
            VicTrVectPrity25  => VicTrVectPrity25,
            VicTrVectPrity26  => VicTrVectPrity26,
            VicTrVectPrity27  => VicTrVectPrity27,
            VicTrVectPrity28  => VicTrVectPrity28,
            VicTrVectPrity29  => VicTrVectPrity29,
            VicTrVectPrity30  => VicTrVectPrity30,
            VicTrVectPrity31  => VicTrVectPrity31,
            MaskPrityReg      => MaskPrityReg,
            nTrIrq            => nTrIrq,
            TrVectIrq         => TrVectIrq,
            DaisyIrqOut       => DaisyIrqOut,
            PPTable0          => PPTable0,
            PPTable1          => PPTable1,
            PPTable2          => PPTable2,
            PPTable3          => PPTable3,
            PPTable4          => PPTable4,
            PPTable5          => PPTable5,
            PPTable6          => PPTable6,
            PPTable7          => PPTable7,
            PPTable8          => PPTable8,
            PPTable9          => PPTable9,
            PPTable10         => PPTable10,
            PPTable11         => PPTable11,
            PPTable12         => PPTable12,
            PPTable13         => PPTable13,
            PPTable14         => PPTable14,
            PPTable15         => PPTable15
           );   

-- -----------------------------------------------------------------------------
-- VIC IRQ Priority Logic Block instantiation
-- -----------------------------------------------------------------------------
uVicTrIrqPriLog : VicTrIrqPriLog 
  port map (
            HCLK             => HCLK,
            HRESETn          => HRESETn,
            TrnIrq           => TrnIrq,
            IrqStatus        => TrIrqStatus,
            DaisyIrqOut      => DaisyIrqOut,
            TrVectIrq        => TrVectIrq,
            nVicTrSyncEn     => nVicTrSyncEn,
            PPTable0         => PPTable0,
            PPTable1         => PPTable1,
            PPTable2         => PPTable2,
            PPTable3         => PPTable3,
            PPTable4         => PPTable4,
            PPTable5         => PPTable5,
            PPTable6         => PPTable6,
            PPTable7         => PPTable7,
            PPTable8         => PPTable8,
            PPTable9         => PPTable9,
            PPTable10        => PPTable10,
            PPTable11        => PPTable11,
            PPTable12        => PPTable12,
            PPTable13        => PPTable13,
            PPTable14        => PPTable14,
            PPTable15        => PPTable15,
            VicTrVectAddr0   => VicTrVectAddr0,
            VicTrVectAddr1   => VicTrVectAddr1,
            VicTrVectAddr2   => VicTrVectAddr2,
            VicTrVectAddr3   => VicTrVectAddr3,
            VicTrVectAddr4   => VicTrVectAddr4,
            VicTrVectAddr5   => VicTrVectAddr5,
            VicTrVectAddr6   => VicTrVectAddr6,
            VicTrVectAddr7   => VicTrVectAddr7,
            VicTrVectAddr8   => VicTrVectAddr8,
            VicTrVectAddr9   => VicTrVectAddr9,
            VicTrVectAddr10  => VicTrVectAddr10,
            VicTrVectAddr11  => VicTrVectAddr11,
            VicTrVectAddr12  => VicTrVectAddr12,
            VicTrVectAddr13  => VicTrVectAddr13,
            VicTrVectAddr14  => VicTrVectAddr14,
            VicTrVectAddr15  => VicTrVectAddr15,
            VicTrVectAddr16  => VicTrVectAddr16,
            VicTrVectAddr17  => VicTrVectAddr17,
            VicTrVectAddr18  => VicTrVectAddr18,
            VicTrVectAddr19  => VicTrVectAddr19,
            VicTrVectAddr20  => VicTrVectAddr20,
            VicTrVectAddr21  => VicTrVectAddr21,
            VicTrVectAddr22  => VicTrVectAddr22,
            VicTrVectAddr23  => VicTrVectAddr23,
            VicTrVectAddr24  => VicTrVectAddr24,
            VicTrVectAddr25  => VicTrVectAddr25,
            VicTrVectAddr26  => VicTrVectAddr26,
            VicTrVectAddr27  => VicTrVectAddr27,
            VicTrVectAddr28  => VicTrVectAddr28,
            VicTrVectAddr29  => VicTrVectAddr29,
            VicTrVectAddr30  => VicTrVectAddr30,
            VicTrVectAddr31  => VicTrVectAddr31,
            VicTrVectAddrIn  => VicTrVectAddrIn,
            VicTrIrqAck      => VicTrIrqAck,
            VectAddrWrTrigIn => VectAddrWrTrig,
            VectAddrRdTrigIn => VectAddrRdTrig,
            AsyncRdEn        => AsyncRdEn,
            VicTrIrqOut      => VicTrIrqAckOut,
            nTrIrq           => nTrIrq,
            VectAddrVld      => VectAddrVld,
            MaskPrityReg     => MaskPrityReg,
            VicTrVectAddrv   => VicTrVectAddrv,
            VicTrVectAddr    => VicTrVectAddr
           );   

-- -----------------------------------------------------------------------------
-- Inverted version of Irq Interrupt
-- -----------------------------------------------------------------------------
inVicTrIrq <= not nTrIrq ;

end behavioural;

-- --================================== End ==================================--
