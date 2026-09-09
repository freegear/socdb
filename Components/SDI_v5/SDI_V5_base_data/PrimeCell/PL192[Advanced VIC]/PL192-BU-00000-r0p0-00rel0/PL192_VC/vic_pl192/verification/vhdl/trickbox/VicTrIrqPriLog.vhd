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
-- File Name              : VicTrIrqPriLog.vhd.rca
-- File Revision          : 1.4
--
-- Release Information    : PrimeCell(TM)-PL192-r0p0-00rel0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           VIC IRQ Priority Logic.
--
-- --=========================================================================--
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

-- -----------------------------------------------------------------------------

entity VicTrIrqPriLog is
   port (
-- Inputs
         HCLK             : in std_logic;  -- AHB Clock
         HRESETn          : in std_logic;  -- AHB Reset
         TrnIrq           : in std_logic;  -- Irq Signal
         IrqStatus        : in std_logic_vector(31 downto 0);   
                                           -- IRQ Status from Interrupt 
                                           -- request Logic Block
         DaisyIrqOut      : in std_logic;  -- Daisy Irq Interrupt  
         TrVectIrq        : in std_logic_vector(32 downto 0);   
                                           -- VectIRQ from IRQ Interrupt 
                                           -- Logic & Daisy Chain
         nVicTrSyncEn     : in std_logic;  --  Sync Enable Input 
         PPTable0         : in std_logic_vector(32 downto 0); 
                                           -- Priority Level 0    
         PPTable1         : in std_logic_vector(32 downto 0); 
                                           -- Priority Level 1 
         PPTable2         : in std_logic_vector(32 downto 0); 
                                           -- Priority Level 2 
         PPTable3         : in std_logic_vector(32 downto 0); 
                                           -- Priority Level 3 
         PPTable4         : in std_logic_vector(32 downto 0);
                                           -- Priority Level 4 
         PPTable5         : in std_logic_vector(32 downto 0); 
                                           -- Priority Level 5 
         PPTable6         : in std_logic_vector(32 downto 0); 
                                           -- Priority Level 6 
         PPTable7         : in std_logic_vector(32 downto 0); 
                                           -- Priority Level 7 
         PPTable8         : in std_logic_vector(32 downto 0); 
                                           -- Priority Level 8 
         PPTable9         : in std_logic_vector(32 downto 0); 
                                           -- Priority Level 9 
         PPTable10        : in std_logic_vector(32 downto 0); 
                                           -- Priority Level 10 
         PPTable11        : in std_logic_vector(32 downto 0); 
                                           -- Priority Level 11 
         PPTable12        : in std_logic_vector(32 downto 0); 
                                           -- Priority Level 12 
         PPTable13        : in std_logic_vector(32 downto 0); 
                                           -- Priority Level 13 
         PPTable14        : in std_logic_vector(32 downto 0); 
                                           -- Priority Level 14 
         PPTable15        : in std_logic_vector(32 downto 0); 
                                           -- Priority Level 15 
         VicTrVectAddr0   : in std_logic_vector(31 downto 0); 
                                           -- IRQ Vector Address register 0
         VicTrVectAddr1   : in std_logic_vector(31 downto 0); 
                                           -- IRQ Vector Address register 1
         VicTrVectAddr2   : in std_logic_vector(31 downto 0); 
                                           -- IRQ Vector Address register 2
         VicTrVectAddr3   : in std_logic_vector(31 downto 0); 
                                           -- IRQ Vector Address register 3
         VicTrVectAddr4   : in std_logic_vector(31 downto 0); 
                                           -- IRQ Vector Address register 4
         VicTrVectAddr5   : in std_logic_vector(31 downto 0); 
                                           -- IRQ Vector Address register 5
         VicTrVectAddr6   : in std_logic_vector(31 downto 0); 
                                           -- IRQ Vector Address register 6
         VicTrVectAddr7   : in std_logic_vector(31 downto 0); 
                                           -- IRQ Vector Address register 7
         VicTrVectAddr8   : in std_logic_vector(31 downto 0); 
                                           -- IRQ Vector Address register 8
         VicTrVectAddr9   : in std_logic_vector(31 downto 0); 
                                           -- IRQ Vector Address register 9
         VicTrVectAddr10  : in std_logic_vector(31 downto 0); 
                                           -- IRQ Vector Address register 10
         VicTrVectAddr11  : in std_logic_vector(31 downto 0); 
                                           -- IRQ Vector Address register 11
         VicTrVectAddr12  : in std_logic_vector(31 downto 0); 
                                           -- IRQ Vector Address register 12
         VicTrVectAddr13  : in std_logic_vector(31 downto 0); 
                                           -- IRQ Vector Address register 13
         VicTrVectAddr14  : in std_logic_vector(31 downto 0); 
                                           -- IRQ Vector Address register 14
         VicTrVectAddr15  : in std_logic_vector(31 downto 0); 
                                           -- IRQ Vector Address register 15
         VicTrVectAddr16  : in std_logic_vector(31 downto 0); 
                                           -- IRQ Vector Address register 16
         VicTrVectAddr17  : in std_logic_vector(31 downto 0); 
                                           -- IRQ Vector Address register 17
         VicTrVectAddr18  : in std_logic_vector(31 downto 0); 
                                           -- IRQ Vector Address register 18
         VicTrVectAddr19  : in std_logic_vector(31 downto 0); 
                                           -- IRQ Vector Address register 19
         VicTrVectAddr20  : in std_logic_vector(31 downto 0); 
                                           -- IRQ Vector Address register 20
         VicTrVectAddr21  : in std_logic_vector(31 downto 0); 
                                           -- IRQ Vector Address register 21
         VicTrVectAddr22  : in std_logic_vector(31 downto 0); 
                                           -- IRQ Vector Address register 22
         VicTrVectAddr23  : in std_logic_vector(31 downto 0); 
                                           -- IRQ Vector Address register 23
         VicTrVectAddr24  : in std_logic_vector(31 downto 0); 
                                           -- IRQ Vector Address register 24
         VicTrVectAddr25  : in std_logic_vector(31 downto 0); 
                                           -- IRQ Vector Address register 25
         VicTrVectAddr26  : in std_logic_vector(31 downto 0); 
                                           -- IRQ Vector Address register 26
         VicTrVectAddr27  : in std_logic_vector(31 downto 0); 
                                           -- IRQ Vector Address register 27
         VicTrVectAddr28  : in std_logic_vector(31 downto 0); 
                                           -- IRQ Vector Address register 28
         VicTrVectAddr29  : in std_logic_vector(31 downto 0); 
                                           -- IRQ Vector Address register 29
         VicTrVectAddr30  : in std_logic_vector(31 downto 0); 
                                           -- IRQ Vector Address register 30
         VicTrVectAddr31  : in std_logic_vector(31 downto 0); 
                                           -- IRQ Vector Address register 31
         VicTrVectAddrIn  : in std_logic_vector(31 downto 0); 
                                           -- IRQ Daisy Chain Address 
         VicTrIrqAck      : in std_logic;  -- Acknowledge from the CPU
         VectAddrWrTrigIn : in std_logic;  -- Write Trigger to indicate write 
                                           -- on VICADDRESS register of uut
         VectAddrRdTrigIn : in std_logic;  -- Read Trigger to indicate write 
                                           -- on VICADDRESS register of uut
         AsyncRdEn        : in std_logic;  -- Async Write enable

-- Outputs
         VicTrIrqOut      : out std_logic; -- IRQ Pulse to VIC in daisy chain
         nTrIrq           : out std_logic; -- IRQ Interrupt Output
                                           -- VICADDRESS register of uut  
         VectAddrVld      : out std_logic; -- Address Valid Indicator
         VicTrVectAddrv   : out std_logic; -- Address Valid Indicator
         MaskPrityReg     : out std_logic_vector(15 downto 0);
                                           -- Mask Value when a read on 
                                           -- vicaddress or acknowledge   
         VicTrVectAddr    : out std_logic_vector(31 downto 0)
                                           -- Local copy VicTrVectAddr register 
        );    
end VicTrIrqPriLog;

-- -----------------------------------------------------------------------------
--
--                             VicTrIrqPriLog 
--                             ===============
--
-- -----------------------------------------------------------------------------
--
-- Overview
-- ========
-- This module resolves the priority of interrupts and decodes the address
-- of the highest interrupt selected. Masking of the lower and equal priority
-- interrupts when a Read on vicaddress register or Acknowledge from the cpu.
-- Unmasking the equal and lower priority interrupts when a write on vicaddress
-- register. It also generates the VicTrVectAddrv signal for the VIC port.
--
-- -----------------------------------------------------------------------------

-- --============================= ARCHITECTURE ==============================--

architecture behavioural of VicTrIrqPriLog is

-- -----------------------------------------------------------------------------
-- Component declarations
-- -----------------------------------------------------------------------------
  
-- -----------------------------------------------------------------------------
-- Constant declarations
-- -----------------------------------------------------------------------------
constant SRC0   : std_logic_vector(32 downto 0) 
                               := "000000000000000000000000000000001";
constant SRC1   : std_logic_vector(32 downto 0) 
                               := "000000000000000000000000000000010";
constant SRC2   : std_logic_vector(32 downto 0)
                               := "000000000000000000000000000000100";
constant SRC3   : std_logic_vector(32 downto 0) 
                               := "000000000000000000000000000001000";
constant SRC4   : std_logic_vector(32 downto 0) 
                               := "000000000000000000000000000010000";
constant SRC5   : std_logic_vector(32 downto 0) 
                               := "000000000000000000000000000100000";
constant SRC6   : std_logic_vector(32 downto 0) 
                               := "000000000000000000000000001000000";
constant SRC7   : std_logic_vector(32 downto 0) 
                               := "000000000000000000000000010000000";
constant SRC8   : std_logic_vector(32 downto 0) 
                               := "000000000000000000000000100000000";
constant SRC9   : std_logic_vector(32 downto 0) 
                               := "000000000000000000000001000000000";
constant SRC10  : std_logic_vector(32 downto 0) 
                               := "000000000000000000000010000000000";
constant SRC11  : std_logic_vector(32 downto 0) 
                               := "000000000000000000000100000000000";
constant SRC12  : std_logic_vector(32 downto 0) 
                               := "000000000000000000001000000000000";
constant SRC13  : std_logic_vector(32 downto 0) 
                               := "000000000000000000010000000000000";
constant SRC14  : std_logic_vector(32 downto 0) 
                               := "000000000000000000100000000000000";
constant SRC15  : std_logic_vector(32 downto 0) 
                               := "000000000000000001000000000000000";
constant SRC16  : std_logic_vector(32 downto 0) 
                               := "000000000000000010000000000000000";
constant SRC17  : std_logic_vector(32 downto 0) 
                               := "000000000000000100000000000000000";
constant SRC18  : std_logic_vector(32 downto 0) 
                               := "000000000000001000000000000000000";
constant SRC19  : std_logic_vector(32 downto 0) 
                               := "000000000000010000000000000000000";
constant SRC20  : std_logic_vector(32 downto 0) 
                               := "000000000000100000000000000000000";
constant SRC21  : std_logic_vector(32 downto 0) 
                               := "000000000001000000000000000000000";
constant SRC22  : std_logic_vector(32 downto 0) 
                               := "000000000010000000000000000000000";
constant SRC23  : std_logic_vector(32 downto 0) 
                               := "000000000100000000000000000000000";
constant SRC24  : std_logic_vector(32 downto 0) 
                               := "000000001000000000000000000000000";
constant SRC25  : std_logic_vector(32 downto 0) 
                               := "000000010000000000000000000000000";
constant SRC26  : std_logic_vector(32 downto 0) 
                               := "000000100000000000000000000000000";
constant SRC27  : std_logic_vector(32 downto 0) 
                               := "000001000000000000000000000000000";
constant SRC28  : std_logic_vector(32 downto 0) 
                               := "000010000000000000000000000000000";
constant SRC29  : std_logic_vector(32 downto 0) 
                               := "000100000000000000000000000000000";
constant SRC30  : std_logic_vector(32 downto 0) 
                               := "001000000000000000000000000000000";
constant SRC31  : std_logic_vector(32 downto 0) 
                               := "010000000000000000000000000000000";
constant SRC32  : std_logic_vector(32 downto 0) 
                               := "100000000000000000000000000000000";
constant NOSRC  : std_logic_vector(32 downto 0) 
                               := "000000000000000000000000000000000";
constant MASK0  : std_logic_vector(15 downto 0) 
                               := "0000000000000000";
constant MASK1  : std_logic_vector(15 downto 0) 
                               := "0000000000000001";
constant MASK2  : std_logic_vector(15 downto 0) 
                               := "0000000000000011";
constant MASK3  : std_logic_vector(15 downto 0) 
                               := "0000000000000111";
constant MASK4  : std_logic_vector(15 downto 0) 
                               := "0000000000001111";
constant MASK5  : std_logic_vector(15 downto 0) 
                               := "0000000000011111";
constant MASK6  : std_logic_vector(15 downto 0) 
                               := "0000000000111111";
constant MASK7  : std_logic_vector(15 downto 0) 
                               := "0000000001111111";
constant MASK8  : std_logic_vector(15 downto 0) 
                               := "0000000011111111";
constant MASK9  : std_logic_vector(15 downto 0) 
                               := "0000000111111111";
constant MASK10 : std_logic_vector(15 downto 0) 
                               := "0000001111111111";
constant MASK11 : std_logic_vector(15 downto 0) 
                               := "0000011111111111";
constant MASK12 : std_logic_vector(15 downto 0) 
                               := "0000111111111111";
constant MASK13 : std_logic_vector(15 downto 0) 
                               := "0001111111111111";
constant MASK14 : std_logic_vector(15 downto 0) 
                               := "0011111111111111";
constant MASK15 : std_logic_vector(15 downto 0) 
                               := "0111111111111111";
constant NOMASK : std_logic_vector(15 downto 0) 
                               := "1111111111111111";
constant LEVEL0  : std_logic_vector(15 downto 0) 
                               := "0000000000000001";
constant LEVEL1  : std_logic_vector(15 downto 0) 
                               := "0000000000000010";
constant LEVEL2  : std_logic_vector(15 downto 0) 
                               := "0000000000000100";
constant LEVEL3  : std_logic_vector(15 downto 0) 
                               := "0000000000001000";
constant LEVEL4  : std_logic_vector(15 downto 0) 
                               := "0000000000010000";
constant LEVEL5  : std_logic_vector(15 downto 0) 
                               := "0000000000100000";
constant LEVEL6  : std_logic_vector(15 downto 0) 
                               := "0000000001000000";
constant LEVEL7  : std_logic_vector(15 downto 0) 
                               := "0000000010000000";
constant LEVEL8  : std_logic_vector(15 downto 0) 
                               := "0000000100000000";
constant LEVEL9  : std_logic_vector(15 downto 0) 
                               := "0000001000000000";
constant LEVEL10 : std_logic_vector(15 downto 0) 
                               := "0000010000000000";
constant LEVEL11 : std_logic_vector(15 downto 0) 
                               := "0000100000000000";
constant LEVEL12 : std_logic_vector(15 downto 0) 
                               := "0001000000000000";
constant LEVEL13 : std_logic_vector(15 downto 0) 
                               := "0010000000000000";
constant LEVEL14 : std_logic_vector(15 downto 0) 
                               := "0100000000000000";
constant LEVEL15 : std_logic_vector(15 downto 0) 
                               := "1000000000000000";
-- -----------------------------------------------------------------------------
-- Signal declarations
-- -----------------------------------------------------------------------------
signal count            : integer;   -- Counter  
signal EnTrIrq          : std_logic; -- Indicates active interrupts 
signal EnTrIrqs         : std_logic; -- For synchronous input ie 
                                     -- nVICTrSyncEn high
signal IrqAckTrig       : std_logic; -- Acknowledge Trigger
signal IrqOut           : std_logic; -- Trigger for generating Address valid
signal PriCheck         : std_logic_vector(15 downto 0);
                                     -- Priority check gets updated on new 
                                     -- selected level
signal IrqMask          : std_logic; -- Mask Irq Out
signal ResTable0        : std_logic_vector(32 downto 0); 
                                     -- Result Table 0
signal ResTable1        : std_logic_vector(32 downto 0); 
                                     -- Result Table 1
signal ResTable2        : std_logic_vector(32 downto 0); 
                                     -- Result Table 2
signal ResTable3        : std_logic_vector(32 downto 0); 
                                     -- Result Table 3
signal ResTable4        : std_logic_vector(32 downto 0); 
                                     -- Result Table 4
signal ResTable5        : std_logic_vector(32 downto 0); 
                                     -- Result Table 5
signal ResTable6        : std_logic_vector(32 downto 0); 
                                     -- Result Table 6
signal ResTable7        : std_logic_vector(32 downto 0); 
                                     -- Result Table 7
signal ResTable8        : std_logic_vector(32 downto 0); 
                                     -- Result Table 8
signal ResTable9        : std_logic_vector(32 downto 0); 
                                     -- Result Table 9
signal ResTable10       : std_logic_vector(32 downto 0); 
                                     -- Result Table 10
signal ResTable11       : std_logic_vector(32 downto 0); 
                                     -- Result Table 11
signal ResTable12       : std_logic_vector(32 downto 0); 
                                     -- Result Table 12
signal ResTable13       : std_logic_vector(32 downto 0); 
                                     -- Result Table 13
signal ResTable14       : std_logic_vector(32 downto 0); 
                                     -- Result Table 14
signal ResTable15       : std_logic_vector(32 downto 0); 
                                     -- Result Table 15
signal EnIrqReg0        : std_logic_vector(32 downto 0); 
                                     -- Active interrupts at Priority Level 0
signal EnIrqReg1        : std_logic_vector(32 downto 0); 
                                     -- Active interrupts at Priority Level 1
signal EnIrqReg2        : std_logic_vector(32 downto 0); 
                                     -- Active interrupts at Priority Level 2
signal EnIrqReg3        : std_logic_vector(32 downto 0); 
                                     -- Active interrupts at Priority Level 3
signal EnIrqReg4        : std_logic_vector(32 downto 0); 
                                     -- Active interrupts at Priority Level 4
signal EnIrqReg5        : std_logic_vector(32 downto 0); 
                                     -- Active interrupts at Priority Level 5
signal EnIrqReg6        : std_logic_vector(32 downto 0); 
                                     -- Active interrupts at Priority Level 6
signal EnIrqReg7        : std_logic_vector(32 downto 0); 
                                     -- Active interrupts at Priority Level 7
signal EnIrqReg8        : std_logic_vector(32 downto 0); 
                                     -- Active interrupts at Priority Level 8
signal EnIrqReg9        : std_logic_vector(32 downto 0); 
                                     -- Active interrupts at Priority Level 9
signal EnIrqReg10       : std_logic_vector(32 downto 0); 
                                     -- Active interrupts at Priority Level 10
signal EnIrqReg11       : std_logic_vector(32 downto 0); 
                                     -- Active interrupts at Priority Level 11
signal EnIrqReg12       : std_logic_vector(32 downto 0); 
                                     -- Active interrupts at Priority Level 12
signal EnIrqReg13       : std_logic_vector(32 downto 0); 
                                     -- Active interrupts at Priority Level 13
signal EnIrqReg14       : std_logic_vector(32 downto 0); 
                                     -- Active interrupts at Priority Level 14
signal EnIrqReg15       : std_logic_vector(32 downto 0); 
                                     -- Active interrupts at Priority Level 15
signal VicTrIrqAck1     : std_logic; -- Acknowledge first latched version
signal VicTrIrqAck2     : std_logic; -- Acknowledge second latched version
signal VicTrIrqAck3     : std_logic; -- Acknowledge third latched version
signal VicTrIrqAckc     : std_logic; -- Acknowledge first latched version
signal AckHap           : std_logic; -- Trigger to disable nTrIrq line
signal EnTrIrqa         : std_logic; -- Asynchronous Acknowledge delayed version 
                                     -- of Sync one
signal EnTrIrqa1        : std_logic; -- Registered EnTrIrqs
signal AckTrig          : std_logic; -- Trigger for Acknowledge
signal AckTrigReg       : std_logic; -- Registered Trigger for Acknowledge
signal GenAck           : std_logic; -- Indicates new interrupts 
signal GenAckReg        : std_logic; -- Registered GenAck
signal PriCheckReg      : std_logic; -- Registered PriCheck
signal DaisySel         : std_logic; -- Daisy Interrupt Select
signal NxtVectAddrInt   : std_logic_vector(31 downto 0); 
                                     -- Decoded Priority Address
signal VicTrVectAddrInt : std_logic_vector(31 downto 0); 
                                     -- Decoded Priority Address
signal PrevVectAddr     : std_logic_vector(31 downto 0); 
                                     -- Decoded Priority Address
signal VectAddrOutReg   : std_logic_vector(31 downto 0); 
                                     -- Decoded Priority Address
signal DecodedAddr      : std_logic_vector(32 downto 0); 
                                     -- Selection for Decoding Address
signal NxtDecodedAddr   : std_logic_vector(32 downto 0); 
                                     -- Registered DecodedAddr
signal SelectdLevel     : std_logic_vector(15 downto 0); 
                                     -- Current Priority Level Selected
signal MaskReg          : std_logic_vector(15 downto 0); 
                                     -- Mask Value 15 levels to mask equal,
                                     -- lower priority interrupts
signal MaskRegArray0    : std_logic_vector(15 downto 0);   
                                     -- Register to mask equal and lower 
                                     -- priority interrupts
signal VectAddrWrTrig   : std_logic; -- Write Trigger to indicate write on 
                                     -- VICADDRESS register of uut
signal VectAddrRdTrig   : std_logic; -- Read Trigger to indicate write on
                                     -- VICADDRESS register of uut  
signal MaskRegArray1    : std_logic_vector(15 downto 0);
                                     -- Stack Array 1
signal MaskRegArray2    : std_logic_vector(15 downto 0);
                                     -- Stack Array 2
signal MaskRegArray3    : std_logic_vector(15 downto 0);
                                     -- Stack Array 3
signal MaskRegArray4    : std_logic_vector(15 downto 0);
                                     -- Stack Array 4
signal MaskRegArray5    : std_logic_vector(15 downto 0);
                                     -- Stack Array 5
signal MaskRegArray6    : std_logic_vector(15 downto 0);
                                     -- Stack Array 6
signal MaskRegArray7    : std_logic_vector(15 downto 0);
                                     -- Stack Array 7
signal MaskRegArray8    : std_logic_vector(15 downto 0);
                                     -- Stack Array 8
signal MaskRegArray9    : std_logic_vector(15 downto 0);
                                     -- Stack Array 9
signal MaskRegArray10   : std_logic_vector(15 downto 0);
                                     -- Stack Array 10
signal MaskRegArray11   : std_logic_vector(15 downto 0);
                                     -- Stack Array 11
signal MaskRegArray12   : std_logic_vector(15 downto 0);
                                     -- Stack Array 12
signal MaskRegArray13   : std_logic_vector(15 downto 0);
                                     -- Stack Array 13
signal MaskRegArray14   : std_logic_vector(15 downto 0);
                                     -- Stack Array 14
signal MaskRegArray15   : std_logic_vector(15 downto 0);
                                     -- Stack Array 15
signal nTrIrqReg0       : std_logic_vector(32 downto 0);
                                     -- Updated Priority Table Level 0 
signal nTrIrqReg1       : std_logic_vector(32 downto 0);
                                     -- Updated Priority Table Level 1
signal nTrIrqReg2       : std_logic_vector(32 downto 0);
                                     -- Updated Priority Table Level 2
signal nTrIrqReg3       : std_logic_vector(32 downto 0);
                                     -- Updated Priority Table Level 3
signal nTrIrqReg4       : std_logic_vector(32 downto 0);
                                     -- Updated Priority Table Level 4
signal nTrIrqReg5       : std_logic_vector(32 downto 0);
                                     -- Updated Priority Table Level 5
signal nTrIrqReg6       : std_logic_vector(32 downto 0);
                                     -- Updated Priority Table Level 6
signal nTrIrqReg7       : std_logic_vector(32 downto 0);
                                     -- Updated Priority Table Level 7
signal nTrIrqReg8       : std_logic_vector(32 downto 0);
                                     -- Updated Priority Table Level 8
signal nTrIrqReg9       : std_logic_vector(32 downto 0);
                                     -- Updated Priority Table Level 9
signal nTrIrqReg10      : std_logic_vector(32 downto 0);
                                     -- Updated Priority Table Level 10
signal nTrIrqReg11      : std_logic_vector(32 downto 0);
                                     -- Updated Priority Table Level 11
signal nTrIrqReg12      : std_logic_vector(32 downto 0);
                                     -- Updated Priority Table Level 12
signal nTrIrqReg13      : std_logic_vector(32 downto 0);
                                     -- Updated Priority Table Level 13
signal nTrIrqReg14      : std_logic_vector(32 downto 0);
                                     -- Updated Priority Table Level 14
signal nTrIrqReg15      : std_logic_vector(32 downto 0);
                                     -- Updated Priority Table Level 15
signal iVicTrVectAddr0  : std_logic_vector(31 downto 0);
                                     -- Internal IRQ Vector Address register 0
signal iVicTrVectAddr1  : std_logic_vector(31 downto 0);
                                     -- Internal IRQ Vector Address register 1
signal iVicTrVectAddr2  : std_logic_vector(31 downto 0);
                                     -- Internal IRQ Vector Address register 2
signal iVicTrVectAddr3  : std_logic_vector(31 downto 0);
                                     -- Internal IRQ Vector Address register 3
signal iVicTrVectAddr4  : std_logic_vector(31 downto 0);
                                     -- Internal IRQ Vector Address register 4
signal iVicTrVectAddr5  : std_logic_vector(31 downto 0);
                                     -- Internal IRQ Vector Address register 5
signal iVicTrVectAddr6  : std_logic_vector(31 downto 0);
                                     -- Internal IRQ Vector Address register 6
signal iVicTrVectAddr7  : std_logic_vector(31 downto 0);
                                     -- Internal IRQ Vector Address register 7
signal iVicTrVectAddr8  : std_logic_vector(31 downto 0);
                                     -- Internal IRQ Vector Address register 8
signal iVicTrVectAddr9  : std_logic_vector(31 downto 0);
                                     -- Internal IRQ Vector Address register 9
signal iVicTrVectAddr10 : std_logic_vector(31 downto 0);
                                     -- Internal IRQ Vector Address register 10
signal iVicTrVectAddr11 : std_logic_vector(31 downto 0);
                                     -- Internal IRQ Vector Address register 11
signal iVicTrVectAddr12 : std_logic_vector(31 downto 0);
                                     -- Internal IRQ Vector Address register 12
signal iVicTrVectAddr13 : std_logic_vector(31 downto 0);
                                     -- Internal IRQ Vector Address register 13
signal iVicTrVectAddr14 : std_logic_vector(31 downto 0);
                                     -- Internal IRQ Vector Address register 14
signal iVicTrVectAddr15 : std_logic_vector(31 downto 0);
                                     -- Internal IRQ Vector Address register 15
signal iVicTrVectAddr16 : std_logic_vector(31 downto 0);
                                     -- Internal IRQ Vector Address register 16
signal iVicTrVectAddr17 : std_logic_vector(31 downto 0);
                                     -- Internal IRQ Vector Address register 17
signal iVicTrVectAddr18 : std_logic_vector(31 downto 0);
                                     -- Internal IRQ Vector Address register 18
signal iVicTrVectAddr19 : std_logic_vector(31 downto 0);
                                     -- Internal IRQ Vector Address register 19
signal iVicTrVectAddr20 : std_logic_vector(31 downto 0);
                                     -- Internal IRQ Vector Address register 20
signal iVicTrVectAddr21 : std_logic_vector(31 downto 0);
                                     -- Internal IRQ Vector Address register 21
signal iVicTrVectAddr22 : std_logic_vector(31 downto 0);
                                     -- Internal IRQ Vector Address register 22
signal iVicTrVectAddr23 : std_logic_vector(31 downto 0);
                                     -- Internal IRQ Vector Address register 23
signal iVicTrVectAddr24 : std_logic_vector(31 downto 0);
                                     -- Internal IRQ Vector Address register 24
signal iVicTrVectAddr25 : std_logic_vector(31 downto 0);
                                     -- Internal IRQ Vector Address register 25
signal iVicTrVectAddr26 : std_logic_vector(31 downto 0);
                                     -- Internal IRQ Vector Address register 26
signal iVicTrVectAddr27 : std_logic_vector(31 downto 0);
                                     -- Internal IRQ Vector Address register 27
signal iVicTrVectAddr28 : std_logic_vector(31 downto 0);
                                     -- Internal IRQ Vector Address register 28
signal iVicTrVectAddr29 : std_logic_vector(31 downto 0);
                                     -- Internal IRQ Vector Address register 29
signal iVicTrVectAddr30 : std_logic_vector(31 downto 0);
                                     -- Internal IRQ Vector Address register 30
signal iVicTrVectAddr31 : std_logic_vector(31 downto 0);
                                     -- Internal IRQ Vector Address register 31
signal inTrIrq             :  std_logic;   
signal iVicTrVectAddr      :  std_logic_vector(31 downto 0);   
signal MaskPrityReg_xhdl6       :  std_logic_vector(15 downto 0);   

-- -----------------------------------------------------------------------------
-- Function declarations
-- -----------------------------------------------------------------------------
-- -----------------------------------------------------------------------------
-- 4 bits Or Reduce function
-- -----------------------------------------------------------------------------
function ReduceOr4 ( ToOrReduce4 : in std_logic_vector(3 downto 0))
                                               return std_logic is
  variable ReduceOr4 : std_logic;
begin
  ReduceOr4 := ToOrReduce4(3) or ToOrReduce4(2) or 
               ToOrReduce4(1) or ToOrReduce4(0);
  return(ReduceOr4);
end ReduceOr4;
-- -----------------------------------------------------------------------------
-- 32 bits Or Reduce function
-- -----------------------------------------------------------------------------
function ReduceOr ( ToOrReduce : in std_logic_vector(32 downto 0))
                                               return std_logic is
  variable ReduceOr : std_logic;
begin
  ReduceOr := ToOrReduce(32) or ToOrReduce(31) or ToOrReduce(30) or 
              ToOrReduce(29) or ToOrReduce(28) or ToOrReduce(27) or 
              ToOrReduce(26) or ToOrReduce(25) or ToOrReduce(24) or 
              ToOrReduce(23) or ToOrReduce(22) or ToOrReduce(21) or 
              ToOrReduce(20) or ToOrReduce(19) or ToOrReduce(18) or 
              ToOrReduce(17) or ToOrReduce(16) or ToOrReduce(15) or 
              ToOrReduce(14) or ToOrReduce(13) or ToOrReduce(12) or 
              ToOrReduce(11) or ToOrReduce(10) or ToOrReduce(9)  or 
              ToOrReduce(8)  or ToOrReduce(7)  or ToOrReduce(6)  or 
              ToOrReduce(5)  or ToOrReduce(4)  or ToOrReduce(3)  or 
              ToOrReduce(2)  or ToOrReduce(1)  or ToOrReduce(0);
  return(ReduceOr);
end ReduceOr;
-- -----------------------------------------------------------------------------
-- This function decodes the Hardware priority and returns a value.
-- The the resloved priority interrupts source address can be decoded
-- from the returned value.
-- -----------------------------------------------------------------------------
function PriAddrDecode ( Dcode : in std_logic_vector(32 downto 0))   
                                                 return std_logic_vector is
variable PriAddrDecode        : std_logic_vector(32 downto 0);
begin
  if ((ReduceOr4(Dcode(3 downto 0))) = '1') then
     case Dcode(3 downto 0) is
       when "0001" =>
         PriAddrDecode := SRC0; 
       when "0010" =>
         PriAddrDecode := SRC1; 
       when "0100" =>
         PriAddrDecode := SRC2; 
       when "1000" =>
         PriAddrDecode := SRC3; 
       when "0011" =>
         PriAddrDecode := SRC0; 
       when "0101" =>
         PriAddrDecode := SRC0; 
       when "0111" =>
         PriAddrDecode := SRC0; 
       when "1001" =>
         PriAddrDecode := SRC0; 
       when "1011" =>
         PriAddrDecode := SRC0; 
       when "1101" =>
         PriAddrDecode := SRC0; 
       when "1110" =>
         PriAddrDecode := SRC0; 
       when "1111" =>
         PriAddrDecode := SRC0; 
       when "0110" =>
         PriAddrDecode := SRC1; 
       when "1010" =>
         PriAddrDecode := SRC1; 
       when "1100" =>
         PriAddrDecode := SRC2; 
       when others  =>
         PriAddrDecode := NOSRC; 
     end case;
  elsif ((ReduceOr4(Dcode(7 downto 4))) = '1') then
     case Dcode(7 downto 4) is
       when "0001" =>
         PriAddrDecode := SRC4; 
       when "0010" =>
         PriAddrDecode := SRC5; 
       when "0100" =>
         PriAddrDecode := SRC6; 
       when "1000" =>
         PriAddrDecode := SRC7; 
       when "0011" =>
         PriAddrDecode := SRC4; 
       when "0101" =>
         PriAddrDecode := SRC4; 
       when "0111" =>
         PriAddrDecode := SRC4; 
       when "1001" =>
         PriAddrDecode := SRC4; 
       when "1011" =>
         PriAddrDecode := SRC4; 
       when "1101" =>
         PriAddrDecode := SRC4; 
       when "1110" =>
         PriAddrDecode := SRC4; 
       when "1111" =>
         PriAddrDecode := SRC4; 
       when "0110" =>
         PriAddrDecode := SRC5; 
       when "1010" =>
         PriAddrDecode := SRC5; 
       when "1100" =>
         PriAddrDecode := SRC6; 
       when others  =>
         PriAddrDecode := NOSRC; 
     end case;
  elsif ((ReduceOr4(Dcode(11 downto 8))) = '1') then
    case Dcode(11 downto 8) is
      when "0001" =>
        PriAddrDecode := SRC8; 
      when "0010" =>
        PriAddrDecode := SRC9; 
      when "0100" =>
        PriAddrDecode := SRC10; 
      when "1000" =>
        PriAddrDecode := SRC11; 
      when "0011" =>
        PriAddrDecode := SRC8; 
      when "0101" =>
        PriAddrDecode := SRC8; 
      when "0111" =>
        PriAddrDecode := SRC8; 
      when "1001" =>
        PriAddrDecode := SRC8; 
      when "1011" =>
        PriAddrDecode := SRC8; 
      when "1101" =>
        PriAddrDecode := SRC8; 
      when "1110" =>
        PriAddrDecode := SRC8; 
      when "1111" =>
        PriAddrDecode := SRC8; 
      when "0110" =>
        PriAddrDecode := SRC9; 
      when "1010" =>
        PriAddrDecode := SRC9; 
      when "1100" =>
        PriAddrDecode := SRC10; 
      when others  =>
        PriAddrDecode := NOSRC; 
    end case;
  elsif ((ReduceOr4(Dcode(15 downto 12))) = '1') then
    case Dcode(15 downto 12) is
       when "0001" =>
         PriAddrDecode := SRC12; 
       when "0010" =>
         PriAddrDecode := SRC13; 
       when "0100" =>
         PriAddrDecode := SRC14; 
       when "1000" =>
         PriAddrDecode := SRC15; 
       when "0011" =>
         PriAddrDecode := SRC12; 
       when "0101" =>
         PriAddrDecode := SRC12; 
       when "0111" =>
         PriAddrDecode := SRC12; 
       when "1001" =>
         PriAddrDecode := SRC12; 
       when "1011" =>
         PriAddrDecode := SRC12; 
       when "1101" =>
         PriAddrDecode := SRC12; 
       when "1110" =>
         PriAddrDecode := SRC12; 
       when "1111" =>
         PriAddrDecode := SRC12; 
       when "0110" =>
         PriAddrDecode := SRC13; 
       when "1010" =>
         PriAddrDecode := SRC13; 
       when "1100" =>
         PriAddrDecode := SRC14; 
       when others  =>
         PriAddrDecode := NOSRC; 
    end case;
  elsif ((ReduceOr4(Dcode(19 downto 16))) = '1') then
    case Dcode(19 downto 16) is
      when "0001" =>
        PriAddrDecode := SRC16; 
      when "0010" =>
        PriAddrDecode := SRC17; 
      when "0100" =>
        PriAddrDecode := SRC18; 
      when "1000" =>
        PriAddrDecode := SRC19; 
      when "0011" =>
        PriAddrDecode := SRC16; 
      when "0101" =>
        PriAddrDecode := SRC16; 
      when "0111" =>
        PriAddrDecode := SRC16; 
      when "1001" =>
        PriAddrDecode := SRC16; 
      when "1011" =>
        PriAddrDecode := SRC16; 
      when "1101" =>
        PriAddrDecode := SRC16; 
      when "1110" =>
        PriAddrDecode := SRC16; 
      when "1111" =>
        PriAddrDecode := SRC16; 
      when "0110" =>
        PriAddrDecode := SRC17; 
      when "1010" =>
        PriAddrDecode := SRC17; 
      when "1100" =>
        PriAddrDecode := SRC18; 
      when others  =>
        PriAddrDecode := NOSRC; 
    end case;
  elsif ((ReduceOr4(Dcode(23 downto 20))) = '1') then
    case Dcode(23 downto 20) is
      when "0001" =>
        PriAddrDecode := SRC20; 
      when "0010" =>
        PriAddrDecode := SRC21; 
      when "0100" =>
        PriAddrDecode := SRC22; 
      when "1000" =>
        PriAddrDecode := SRC23; 
      when "0011" =>
        PriAddrDecode := SRC20; 
      when "0101" =>
        PriAddrDecode := SRC20; 
      when "0111" =>
        PriAddrDecode := SRC20; 
      when "1001" =>
        PriAddrDecode := SRC20; 
      when "1011" =>
        PriAddrDecode := SRC20; 
      when "1101" =>
        PriAddrDecode := SRC20; 
      when "1110" =>
        PriAddrDecode := SRC20; 
      when "1111" =>
        PriAddrDecode := SRC20; 
      when "0110" =>
        PriAddrDecode := SRC21; 
      when "1010" =>
        PriAddrDecode := SRC21; 
      when "1100" =>
        PriAddrDecode := SRC22; 
      when others  =>
        PriAddrDecode := NOSRC; 
    end case;
  elsif ((ReduceOr4(Dcode(27 downto 24))) = '1') then
    case Dcode(27 downto 24) is
      when "0001" =>
        PriAddrDecode := SRC24; 
      when "0010" =>
        PriAddrDecode := SRC25; 
      when "0100" =>
        PriAddrDecode := SRC26; 
      when "1000" =>
        PriAddrDecode := SRC27; 
      when "0011" =>
        PriAddrDecode := SRC24; 
      when "0101" =>
        PriAddrDecode := SRC24; 
      when "0111" =>
        PriAddrDecode := SRC24; 
      when "1001" =>
        PriAddrDecode := SRC24; 
      when "1011" =>
        PriAddrDecode := SRC24; 
      when "1101" =>
        PriAddrDecode := SRC24; 
      when "1110" =>
        PriAddrDecode := SRC24; 
      when "1111" =>
        PriAddrDecode := SRC24; 
      when "0110" =>
        PriAddrDecode := SRC25; 
      when "1010" =>
        PriAddrDecode := SRC25; 
      when "1100" =>
        PriAddrDecode := SRC26; 
      when others  =>
        PriAddrDecode := NOSRC; 
    end case;
  elsif ((ReduceOr4(Dcode(31 downto 28))) = '1') then
    case Dcode(31 downto 28) is
      when "0001" =>
        PriAddrDecode := SRC28; 
      when "0010" =>
        PriAddrDecode := SRC29; 
      when "0100" =>
        PriAddrDecode := SRC30; 
      when "1000" =>
        PriAddrDecode := SRC31; 
      when "0011" =>
        PriAddrDecode := SRC28; 
      when "0101" =>
        PriAddrDecode := SRC28; 
      when "0111" =>
        PriAddrDecode := SRC28; 
      when "1001" =>
        PriAddrDecode := SRC28; 
      when "1011" =>
        PriAddrDecode := SRC28; 
      when "1101" =>
        PriAddrDecode := SRC28; 
      when "1110" =>
        PriAddrDecode := SRC28; 
      when "1111" =>
        PriAddrDecode := SRC28; 
      when "0110" =>
        PriAddrDecode := SRC29; 
      when "1010" =>
        PriAddrDecode := SRC29; 
      when "1100" =>
        PriAddrDecode := SRC30; 
      when others  =>
        PriAddrDecode := NOSRC; 
    end case;
  else
    if (Dcode(32) = '1') then
      PriAddrDecode := SRC32; 
    end if;
  end if;
  return(PriAddrDecode);
end PriAddrDecode;

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
-- Local copies assignment
-- -----------------------------------------------------------------------------
nTrIrq        <= inTrIrq;
VicTrVectAddr <= iVicTrVectAddr;

-- -----------------------------------------------------------------------------
-- Generation of nVICIrq siganl. AckTrig signal is triggered when the interrupt
-- is acknowledge by the processor by either a read on vicaddress register or
-- by vicirqack signal. TrnIrq is the ored version of all interrupt sources. 
-- -----------------------------------------------------------------------------
inTrIrq <= TrnIrq when (AckTrig = '0') 
         else 
           EnTrIrq;

-- -----------------------------------------------------------------------------
-- Resultant table which indicates the active interrupts. TrvectIrq is the 
-- double synchronised version of the vicintsource. Resultant table is used to
-- resolve the software priority from 0 to 15.
-- -----------------------------------------------------------------------------
ResTable0 <= PPTable0 and TrVectIrq;
ResTable1 <= PPTable1 and TrVectIrq;
ResTable2 <= PPTable2 and TrVectIrq;
ResTable3 <= PPTable3 and TrVectIrq;
ResTable4 <= PPTable4 and TrVectIrq;
ResTable5 <= PPTable5 and TrVectIrq;
ResTable6 <= PPTable6 and TrVectIrq;
ResTable7 <= PPTable7 and TrVectIrq;
ResTable8 <= PPTable8 and TrVectIrq;
ResTable9 <= PPTable9 and TrVectIrq;
ResTable10 <= PPTable10 and TrVectIrq;
ResTable11 <= PPTable11 and TrVectIrq;
ResTable12 <= PPTable12 and TrVectIrq;
ResTable13 <= PPTable13 and TrVectIrq;
ResTable14 <= PPTable14 and TrVectIrq;
ResTable15 <= PPTable15 and TrVectIrq;
-- -----------------------------------------------------------------------------
-- This EnIrqReg tables from 0 to 15 is used to generate the EnTrIrqs signal.
-- nTrIrqReg is the local version of PPTable 0 to 15.If EnTrIrqs is one 
-- indicates an active interrupt even after the equal and lower interrupts
-- masked.
-- -----------------------------------------------------------------------------
EnIrqReg0 <= nTrIrqReg0 and (DaisyIrqOut & IrqStatus);
EnIrqReg1 <= nTrIrqReg1 and (DaisyIrqOut & IrqStatus);
EnIrqReg2 <= nTrIrqReg2 and (DaisyIrqOut & IrqStatus);
EnIrqReg3 <= nTrIrqReg3 and (DaisyIrqOut & IrqStatus);
EnIrqReg4 <= nTrIrqReg4 and (DaisyIrqOut & IrqStatus);
EnIrqReg5 <= nTrIrqReg5 and (DaisyIrqOut & IrqStatus);
EnIrqReg6 <= nTrIrqReg6 and (DaisyIrqOut & IrqStatus);
EnIrqReg7 <= nTrIrqReg7 and (DaisyIrqOut & IrqStatus);
EnIrqReg8 <= nTrIrqReg8 and (DaisyIrqOut & IrqStatus);
EnIrqReg9 <= nTrIrqReg9 and (DaisyIrqOut & IrqStatus);
EnIrqReg10 <= nTrIrqReg10 and (DaisyIrqOut & IrqStatus);
EnIrqReg11 <= nTrIrqReg11 and (DaisyIrqOut & IrqStatus);
EnIrqReg12 <= nTrIrqReg12 and (DaisyIrqOut & IrqStatus);
EnIrqReg13 <= nTrIrqReg13 and (DaisyIrqOut & IrqStatus);
EnIrqReg14 <= nTrIrqReg14 and (DaisyIrqOut & IrqStatus);
EnIrqReg15 <= nTrIrqReg15 and (DaisyIrqOut & IrqStatus);
-- -----------------------------------------------------------------------------
-- Mux to generate the EnTrIrq signal based on nVicTrSyncEn signal.
-- If nVicTrSyncEn is zero the deassertion of EnTrIrq is delayed by 2 clocks 
-- for synchronization. This is because the address valid signal is generated
-- after 2 clocks of synchronizaton
-- -----------------------------------------------------------------------------
EnTrIrq <= EnTrIrqs when (nVicTrSyncEn = '1') 
         else 
           (EnTrIrqa or EnTrIrqa1 or EnTrIrqs);

-- -----------------------------------------------------------------------------
-- Detarmines the active interrupts for EnTrIrq signal generation
-- -----------------------------------------------------------------------------
EnTrIrqs <= (ReduceOr(EnIrqReg15)) or (ReduceOr(EnIrqReg14)) or 
            (ReduceOr(EnIrqReg13)) or (ReduceOr(EnIrqReg12)) or 
            (ReduceOr(EnIrqReg11)) or (ReduceOr(EnIrqReg10)) or 
            (ReduceOr(EnIrqReg9)) or (ReduceOr(EnIrqReg8)) or 
            (ReduceOr(EnIrqReg7)) or (ReduceOr(EnIrqReg6)) or 
            (ReduceOr(EnIrqReg5)) or (ReduceOr(EnIrqReg4)) or 
            (ReduceOr(EnIrqReg3)) or (ReduceOr(EnIrqReg2)) or 
            (ReduceOr(EnIrqReg1)) or (ReduceOr(EnIrqReg0));

-- -----------------------------------------------------------------------------
-- PriCheck signal is used for resolving the software priority. A high in any of
-- 15 bits of PriCheck indicates that an active interrupt present at that level.
-- Example: PriCheck[0] -> For Priority Level 0
-- -----------------------------------------------------------------------------
PriCheck(0) <= (ReduceOr(PPTable0 and TrVectIrq)) and MaskRegArray0(0);
PriCheck(1) <= (ReduceOr(PPTable1 and TrVectIrq)) and MaskRegArray0(1);
PriCheck(2) <= (ReduceOr(PPTable2 and TrVectIrq)) and MaskRegArray0(2);
PriCheck(3) <= (ReduceOr(PPTable3 and TrVectIrq)) and MaskRegArray0(3);
PriCheck(4) <= (ReduceOr(PPTable4 and TrVectIrq)) and MaskRegArray0(4);
PriCheck(5) <= (ReduceOr(PPTable5 and TrVectIrq)) and MaskRegArray0(5);
PriCheck(6) <= (ReduceOr(PPTable6 and TrVectIrq)) and MaskRegArray0(6);
PriCheck(7) <= (ReduceOr(PPTable7 and TrVectIrq)) and MaskRegArray0(7);
PriCheck(8) <= (ReduceOr(PPTable8 and TrVectIrq)) and MaskRegArray0(8);
PriCheck(9) <= (ReduceOr(PPTable9 and TrVectIrq)) and MaskRegArray0(9);
PriCheck(10) <= (ReduceOr(PPTable10 and TrVectIrq)) and MaskRegArray0(10);
PriCheck(11) <= (ReduceOr(PPTable11 and TrVectIrq)) and MaskRegArray0(11);
PriCheck(12) <= (ReduceOr(PPTable12 and TrVectIrq)) and MaskRegArray0(12);
PriCheck(13) <= (ReduceOr(PPTable13 and TrVectIrq)) and MaskRegArray0(13);
PriCheck(14) <= (ReduceOr(PPTable14 and TrVectIrq)) and MaskRegArray0(14);
PriCheck(15) <= (ReduceOr(PPTable15 and TrVectIrq)) and MaskRegArray0(15);

-- -----------------------------------------------------------------------------
-- Registerin AckTrig signal
-- -----------------------------------------------------------------------------
p_AckTrigGenReg : process (HCLK, HRESETn)
begin
   if (HRESETn = '0') then
      AckTrigReg <= '0';    
   elsif (HCLK'event and HCLK = '1') then
      AckTrigReg <= AckTrig;    
   end if;
end process p_AckTrigGenReg;
   
-- -----------------------------------------------------------------------------
-- Registerin Read and Write signal 
-- -----------------------------------------------------------------------------
p_RegRdWr : process (HCLK, HRESETn)
begin
   if (HRESETn = '0') then
      VectAddrRdTrig <= '0';    
      VectAddrWrTrig <= '0';    
   elsif (HCLK'event and HCLK = '1') then
      VectAddrRdTrig <= VectAddrRdTrigIn;    
      VectAddrWrTrig <= VectAddrWrTrigIn;    
   end if;
end process p_RegRdWr;
   
-- -----------------------------------------------------------------------------
-- Generation of AckTrig signal. Counter is incremented if a read on vicaddress 
-- register or upon ack(vic port) from cpu. Counter is decremented when a write 
-- on vicaddress register. If counter is not zero indicates that a interrupts is
-- acknowledge and lower and equal priority interrupts are masked
-- -----------------------------------------------------------------------------
p_AckTrigGen : process (HRESETn, count)
begin
  if (HRESETn = '0') then
     AckTrig <= '0';    
  else
    if (count /= 0) then
      AckTrig <= '1';    
    else
      AckTrig <= '0';    
    end if;
  end if;
end process p_AckTrigGen;
   
-- -----------------------------------------------------------------------------
-- Counter incrementing and decrementing
-- -----------------------------------------------------------------------------
p_CountGen : process (HRESETn, VectAddrRdTrig, VectAddrWrTrig, VicTrIrqAck)
begin
  if (HRESETn = '0') then
     count <= 0;    
  else
     if (VectAddrRdTrig = '1' or VicTrIrqAck = '1') then
        count <= count + 1;    
     else
        if (VectAddrWrTrig = '1') then
           if (count /= 0) then
              count <= count - 1;    
           end if;
        end if;
     end if;
  end if;
end process p_CountGen;
   
-- -----------------------------------------------------------------------------
-- Resolving the software priority based on pricheck signal.
-- Priority level 0 has the highest priority. 
-- -----------------------------------------------------------------------------
p_PriDecode : process(PriCheck, HRESETn, ResTable0, ResTable1, ResTable2, 
                      ResTable3, ResTable4, ResTable5, ResTable6, ResTable7, 
                      ResTable8, ResTable9, ResTable10, ResTable11, ResTable12, 
                      ResTable13, ResTable14, ResTable15)
begin
  if (HRESETn = '0') then
    DecodedAddr  <= (others => '0');    
    SelectdLevel <= (others => '0');    
  else
    if (PriCheck(0) = '1') then
      DecodedAddr  <= PriAddrDecode(ResTable0);    
      SelectdLevel <= Level0; 
    elsif (PriCheck(1) = '1') then
      DecodedAddr  <= PriAddrDecode(ResTable1);    
      SelectdLevel <= Level1;
    elsif (PriCheck(2) = '1') then
      DecodedAddr  <= PriAddrDecode(ResTable2);    
      SelectdLevel <= Level2;
    elsif (PriCheck(3) = '1') then
      DecodedAddr  <= PriAddrDecode(ResTable3);    
      SelectdLevel <= Level3;
    elsif (PriCheck(4) = '1') then
      DecodedAddr  <= PriAddrDecode(ResTable4);    
      SelectdLevel <= Level4;
    elsif (PriCheck(5) = '1') then
      DecodedAddr  <= PriAddrDecode(ResTable5);    
      SelectdLevel <= Level5;
    elsif (PriCheck(6) = '1') then
      DecodedAddr  <= PriAddrDecode(ResTable6);    
      SelectdLevel <= Level6;
    elsif (PriCheck(7) = '1') then
      DecodedAddr  <= PriAddrDecode(ResTable7); 
      SelectdLevel <= Level7;
    elsif (PriCheck(8) = '1') then
      DecodedAddr  <= PriAddrDecode(ResTable8); 
      SelectdLevel <= Level8;
    elsif (PriCheck(9) = '1') then
      DecodedAddr  <= PriAddrDecode(ResTable9); 
      SelectdLevel <= Level9;
    elsif (PriCheck(10) = '1') then
      DecodedAddr  <= PriAddrDecode(ResTable10); 
      SelectdLevel <= Level10;
    elsif (PriCheck(11) = '1') then
      DecodedAddr  <= PriAddrDecode(ResTable11); 
      SelectdLevel <= Level11;
    elsif (PriCheck(12) = '1') then
      DecodedAddr  <= PriAddrDecode(ResTable12); 
      SelectdLevel <= Level12;
    elsif (PriCheck(13) = '1') then
      DecodedAddr  <= PriAddrDecode(ResTable13); 
      SelectdLevel <= Level13;
    elsif (PriCheck(14) = '1') then
      DecodedAddr  <= PriAddrDecode(ResTable14); 
      SelectdLevel <= Level14;
    elsif (PriCheck(15) = '1') then
      DecodedAddr  <= PriAddrDecode(ResTable15);
      SelectdLevel <= Level15;
    end if;
  end if;
end process p_PriDecode;
   
-- -----------------------------------------------------------------------------
-- Address decoding mux
-- -----------------------------------------------------------------------------
p_AddrSelect : process (DecodedAddr,VicTrVectAddr0,VicTrVectAddr1, 
                        VicTrVectAddr2,VicTrVectAddr3,VicTrVectAddr4, 
                        VicTrVectAddr5,VicTrVectAddr6,VicTrVectAddr7, 
                        VicTrVectAddr8,VicTrVectAddr9,VicTrVectAddr10,
                        VicTrVectAddr11,VicTrVectAddr12,VicTrVectAddr13,
                        VicTrVectAddr14,VicTrVectAddr15,VicTrVectAddr16,
                        VicTrVectAddr17,VicTrVectAddr18,VicTrVectAddr19,
                        VicTrVectAddr20,VicTrVectAddr21,VicTrVectAddr22,
                        VicTrVectAddr23,VicTrVectAddr24,VicTrVectAddr25,
                        VicTrVectAddr26,VicTrVectAddr27,VicTrVectAddr28,
                        VicTrVectAddr29,VicTrVectAddr30,VicTrVectAddr31)
begin
   if (HRESETn = '0') then
      VicTrVectAddrInt <= (others => '0');    
   else
     case DecodedAddr is
       when SRC0 =>
         VicTrVectAddrInt <= VicTrVectAddr0;    
       when SRC1 =>
         VicTrVectAddrInt <= VicTrVectAddr1;    
       when SRC2 =>
         VicTrVectAddrInt <= VicTrVectAddr2;    
       when SRC3 =>
         VicTrVectAddrInt <= VicTrVectAddr3;    
       when SRC4 =>
         VicTrVectAddrInt <= VicTrVectAddr4;    
       when SRC5 =>
         VicTrVectAddrInt <= VicTrVectAddr5;    
       when SRC6 =>
         VicTrVectAddrInt <= VicTrVectAddr6;    
       when SRC7 =>
         VicTrVectAddrInt <= VicTrVectAddr7;    
       when SRC8 =>
         VicTrVectAddrInt <= VicTrVectAddr8;    
       when SRC9 =>
         VicTrVectAddrInt <= VicTrVectAddr9;    
       when SRC10 =>
         VicTrVectAddrInt <= VicTrVectAddr10;    
       when SRC11 =>
         VicTrVectAddrInt <= VicTrVectAddr11;    
       when SRC12 =>
         VicTrVectAddrInt <= VicTrVectAddr12;    
       when SRC13 =>
         VicTrVectAddrInt <= VicTrVectAddr13;    
       when SRC14 =>
         VicTrVectAddrInt <= VicTrVectAddr14;    
       when SRC15 =>
         VicTrVectAddrInt <= VicTrVectAddr15;    
       when SRC16 =>
         VicTrVectAddrInt <= VicTrVectAddr16;    
       when SRC17 =>
         VicTrVectAddrInt <= VicTrVectAddr17;    
       when SRC18 =>
         VicTrVectAddrInt <= VicTrVectAddr18;    
       when SRC19 =>
         VicTrVectAddrInt <= VicTrVectAddr19;    
       when SRC20 =>
         VicTrVectAddrInt <= VicTrVectAddr20;    
       when SRC21 =>
         VicTrVectAddrInt <= VicTrVectAddr21;    
       when SRC22 =>
         VicTrVectAddrInt <= VicTrVectAddr22;    
       when SRC23 =>
         VicTrVectAddrInt <= VicTrVectAddr23;    
       when SRC24 =>
         VicTrVectAddrInt <= VicTrVectAddr24;    
       when SRC25 =>
         VicTrVectAddrInt <= VicTrVectAddr25;    
       when SRC26 =>
         VicTrVectAddrInt <= VicTrVectAddr26;    
       when SRC27 =>
         VicTrVectAddrInt <= VicTrVectAddr27;    
       when SRC28 =>
         VicTrVectAddrInt <= VicTrVectAddr28;    
       when SRC29 =>
         VicTrVectAddrInt <= VicTrVectAddr29;    
       when SRC30 =>
         VicTrVectAddrInt <= VicTrVectAddr30;    
       when SRC31 =>
         VicTrVectAddrInt <= VicTrVectAddr31;    
       when others =>
         null;
      end case;
   end if;
end process p_AddrSelect;

-- -----------------------------------------------------------------------------
-- Store the previous address 
-- -----------------------------------------------------------------------------
p_PrevAddrReg : process (iVicTrVectAddr, GenAckReg, VectAddrOutReg)
begin 
  if (GenAckReg = '0') then
    PrevVectAddr <= iVicTrVectAddr;
  else 
    PrevVectAddr <= VectAddrOutReg;
  end if;
end process p_PrevAddrReg; 
  
-- -----------------------------------------------------------------------------
-- Muxing the Vector address
-- -----------------------------------------------------------------------------
p_VicAddrGen : process (PriCheckReg, NxtVectAddrInt, VectAddrOutReg,
                        VicTrVectAddrIn, DaisySel)
begin 
  if(PriCheckReg = '0') then
    iVicTrVectAddr <= VectAddrOutReg; 
  elsif (DaisySel = '1') then
    iVicTrVectAddr <= VicTrVectAddrIn;
  else
    iVicTrVectAddr <= NxtVectAddrInt;
  end if;
end process p_VicAddrGen;

-- -----------------------------------------------------------------------------
-- Registering of DecodedAddr signal
-- -----------------------------------------------------------------------------
p_ClockDecodeAddr : process (HCLK, HRESETn)
begin
  if (HRESETn = '0') then
     NxtDecodedAddr <= (others => '0');    
     VectAddrOutReg <= (others => '0');    
     NxtVectAddrInt <= (others => '0');    
  elsif (HCLK'event and HCLK = '1') then
     NxtDecodedAddr <= DecodedAddr;    
     VectAddrOutReg <= PrevVectAddr;
     NxtVectAddrInt <= VicTrVectAddrInt;
  end if;
end process p_ClockDecodeAddr;

-- -----------------------------------------------------------------------------
-- Registering of VicTrIrqAck signals used for synchronization purpose 
-- when nVicTrSyncEn is zero.
-- -----------------------------------------------------------------------------
p_SampleAck : process (HCLK, HRESETn)
begin
   if (HRESETn = '0') then
      VicTrIrqAckc <= '0';    
      VicTrIrqAck1 <= '0';    
      VicTrIrqAck2 <= '0';    
      VicTrIrqAck3 <= '0';    
      GenAckReg    <= '0';    
      PriCheckReg  <= '0';    
      AckHap       <= '0';    
      EnTrIrqa1    <= '0';    
      EnTrIrqa     <= '0';    
      DaisySel     <= '0';    
   elsif (HCLK'event and HCLK = '1') then
      VicTrIrqAckc <= VicTrIrqAck;    
      VicTrIrqAck1 <= VicTrIrqAck;    
      VicTrIrqAck2 <= VicTrIrqAck1;    
      VicTrIrqAck3 <= VicTrIrqAck2;    
      EnTrIrqa1    <= EnTrIrqs;    
      EnTrIrqa     <= EnTrIrqa1;    
      GenAckReg    <= GenAck;    
      PriCheckReg  <= PriCheck(15) or PriCheck(14) or PriCheck(13) or
                      PriCheck(12) or PriCheck(11) or PriCheck(10) or
                      PriCheck(9)  or PriCheck(8)  or PriCheck(7)  or
                      PriCheck(6)  or PriCheck(5)  or PriCheck(4)  or
                      PriCheck(3)  or PriCheck(2)  or PriCheck(1)  or    
                      PriCheck(0);    
      if (VicTrIrqAck1 = '1' and VicTrIrqAck = '0') then
         AckHap <= '1';    
      else
         AckHap <= '0';    
      end if;
      if (DecodedAddr = SRC32) then
         DaisySel <= '1';    
      else
         DaisySel <= '0';    
      end if;
   end if;
end process p_SampleAck;
   
-- -----------------------------------------------------------------------------
-- Trigger for generating the GenAck.GenAck signal is used for generating
-- the address valid signal
-- -----------------------------------------------------------------------------
IrqAckTrig <= PriCheckReg or GenAckReg or VicTrIrqAck3;

-- -----------------------------------------------------------------------------
-- GenAck signal generation
-- -----------------------------------------------------------------------------
p_AckGen : process (IrqAckTrig, VicTrIrqAck, VicTrIrqAck2, nVicTrSyncEn)
begin
   if (IrqAckTrig = '1') then
      if (nVicTrSyncEn = '0') then
         GenAck <= VicTrIrqAck2;    
      else
         GenAck <= VicTrIrqAck;    
      end if;
   else
      GenAck <= '0';    
   end if;
end process p_AckGen;
   
-- -----------------------------------------------------------------------------
-- Vic Vector Address valid signal
-- -----------------------------------------------------------------------------
VicTrVectAddrv <= GenAckReg;
   
-- -----------------------------------------------------------------------------
-- Interal copy Vic Vector Address valid signal
-- -----------------------------------------------------------------------------
VectAddrVld <= (GenAckReg or PriCheckReg) and VicTrIrqAckc;

-- -----------------------------------------------------------------------------
-- Determing the Mask Level based on the selected priority level
-- -----------------------------------------------------------------------------
p_MaskDecode : process (HCLK, HRESETn)
begin
  if (HRESETn = '0') then
     MaskReg <= (others => '1');    
  elsif (HCLK'event and HCLK = '1') then
    case SelectdLevel is
      when "0000000000000001" =>
        MaskReg <= MASK0;    
      when "0000000000000010" =>
        MaskReg <= MASK1;    
      when "0000000000000100" =>
        MaskReg <= MASK2;    
      when "0000000000001000" =>
        MaskReg <= MASK3;    
      when "0000000000010000" =>
        MaskReg <= MASK4;    
      when "0000000000100000" =>
        MaskReg <= MASK5;    
      when "0000000001000000" =>
        MaskReg <= MASK6;    
      when "0000000010000000" =>
        MaskReg <= MASK7;    
      when "0000000100000000" =>
        MaskReg <= MASK8;    
      when "0000001000000000" =>
        MaskReg <= MASK9;    
      when "0000010000000000" =>
        MaskReg <= MASK10;    
      when "0000100000000000" =>
        MaskReg <= MASK11;    
      when "0001000000000000" =>
        MaskReg <= MASK12;    
      when "0010000000000000" =>
        MaskReg <= MASK13;    
      when "0100000000000000" =>
        MaskReg <= MASK14;    
      when "1000000000000000" =>
        MaskReg <= MASK15;    
      when others  =>
        MaskReg <= NOMASK;    
    end case;
  end if;
end process p_MaskDecode;
   
-- -----------------------------------------------------------------------------
-- Mask used for masking the equal and lower priority interrupts
-- -----------------------------------------------------------------------------
MaskPrityReg <= MaskRegArray0;
-- -----------------------------------------------------------------------------
-- Internal VicTrIrqOut signal generation
-- -----------------------------------------------------------------------------
IrqOut <= ((AsyncRdEn and IrqMask) or (GenAck and not (GenAckReg)));

-- -----------------------------------------------------------------------------
-- Trigger to generate VicTrIrqOut Signal for software acknowledge
-- -----------------------------------------------------------------------------
IrqMask <= NxtDecodedAddr(32) and DecodedAddr(32);

-- -----------------------------------------------------------------------------
-- VicTrIrqOut signal generation when Daisy Chain interrupt is decoded as 
-- highest priority
-- -----------------------------------------------------------------------------
VicTrIrqOut <= IrqOut when (NxtDecodedAddr = SRC32) 
             else 
               '0';

-- -----------------------------------------------------------------------------
-- Making local copy of PPTable 0 to 15 based on counter value. 
-- -----------------------------------------------------------------------------
p_IrqAsycGen : process (HRESETn, PPTable0, PPTable1, PPTable2, PPTable3, 
                        PPTable4, PPTable5, PPTable6, PPTable7, PPTable8, 
                        PPTable9, PPTable10, PPTable11, PPTable12, PPTable13, 
                        PPTable14, PPTable15, count)
begin
  if (HRESETn = '0') then
     nTrIrqReg0  <= (others => '0');    
     nTrIrqReg1  <= (others => '0');    
     nTrIrqReg2  <= (others => '0');    
     nTrIrqReg3  <= (others => '0');    
     nTrIrqReg4  <= (others => '0');    
     nTrIrqReg5  <= (others => '0');    
     nTrIrqReg6  <= (others => '0');    
     nTrIrqReg7  <= (others => '0');    
     nTrIrqReg8  <= (others => '0');    
     nTrIrqReg9  <= (others => '0');    
     nTrIrqReg10 <= (others => '0');    
     nTrIrqReg11 <= (others => '0');    
     nTrIrqReg12 <= (others => '0');    
     nTrIrqReg13 <= (others => '0');    
     nTrIrqReg14 <= (others => '0');    
     nTrIrqReg15 <= (others => '0');    
  else
    if (count /= 0) then
      nTrIrqReg0  <= PPTable0;    
      nTrIrqReg1  <= PPTable1;    
      nTrIrqReg2  <= PPTable2;    
      nTrIrqReg3  <= PPTable3;    
      nTrIrqReg4  <= PPTable4;    
      nTrIrqReg5  <= PPTable5;    
      nTrIrqReg6  <= PPTable6;    
      nTrIrqReg7  <= PPTable7;    
      nTrIrqReg8  <= PPTable8;    
      nTrIrqReg9  <= PPTable9;    
      nTrIrqReg10 <= PPTable10;    
      nTrIrqReg11 <= PPTable11;    
      nTrIrqReg12 <= PPTable12;    
      nTrIrqReg13 <= PPTable13;    
      nTrIrqReg14 <= PPTable14;    
      nTrIrqReg15 <= PPTable15;    
    end if;
  end if;
end process p_IrqAsycGen;

-- -----------------------------------------------------------------------------
-- Stack used for pushing and popping the priority level selected.
-- A push is done when there is a read on vicaddress register or vicirqack 
-- signal is asserted by the cpu. A pop is done when there is a write on the
-- vicaddress register. MaskRegArray0-15 is used as stack.
-- -----------------------------------------------------------------------------
p_Stack : process (HRESETn, VectAddrRdTrig, VectAddrWrTrig, AckHap)
begin
  if (HRESETn = '0') then
     MaskRegArray0 <= (others => '1');    
     MaskRegArray1 <= (others => '1');    
     MaskRegArray2 <= (others => '1');    
     MaskRegArray3 <= (others => '1');    
     MaskRegArray4 <= (others => '1');    
     MaskRegArray5 <= (others => '1');    
     MaskRegArray6 <= (others => '1');    
     MaskRegArray7 <= (others => '1');    
     MaskRegArray8 <= (others => '1');    
     MaskRegArray9 <= (others => '1');    
     MaskRegArray10 <= (others => '1');    
     MaskRegArray11 <= (others => '1');    
     MaskRegArray12 <= (others => '1');    
     MaskRegArray13 <= (others => '1');    
     MaskRegArray14 <= (others => '1');    
     MaskRegArray15 <= (others => '1');    
  else
    if ((VicTrIrqAck2 = '1') or 
       (VectAddrRdTrig = '1' and inTrIrq = '1')) then
      MaskRegArray0 <= MaskReg;    
      MaskRegArray1 <= MaskRegArray0;    
      MaskRegArray2 <= MaskRegArray1;    
      MaskRegArray3 <= MaskRegArray2;    
      MaskRegArray4 <= MaskRegArray3;    
      MaskRegArray5 <= MaskRegArray4;    
      MaskRegArray6 <= MaskRegArray5;    
      MaskRegArray7 <= MaskRegArray6;    
      MaskRegArray8 <= MaskRegArray7;    
      MaskRegArray9 <= MaskRegArray8;    
      MaskRegArray10 <= MaskRegArray9;    
      MaskRegArray11 <= MaskRegArray10;    
      MaskRegArray12 <= MaskRegArray11;    
      MaskRegArray13 <= MaskRegArray12;    
      MaskRegArray14 <= MaskRegArray13;    
      MaskRegArray15 <= MaskRegArray14;    
    else
      if (VectAddrWrTrig = '1') then
        MaskRegArray0 <= MaskRegArray1;    
        MaskRegArray1 <= MaskRegArray2;    
        MaskRegArray2 <= MaskRegArray3;    
        MaskRegArray3 <= MaskRegArray4;    
        MaskRegArray4 <= MaskRegArray5;    
        MaskRegArray5 <= MaskRegArray6;    
        MaskRegArray6 <= MaskRegArray7;    
        MaskRegArray7 <= MaskRegArray8;    
        MaskRegArray8 <= MaskRegArray9;    
        MaskRegArray9 <= MaskRegArray10;    
        MaskRegArray10 <= MaskRegArray11;    
        MaskRegArray11 <= MaskRegArray12;    
        MaskRegArray12 <= MaskRegArray13;    
        MaskRegArray13 <= MaskRegArray14;    
        MaskRegArray14 <= MaskRegArray15;    
        MaskRegArray15 <= (others => '1');    
      end if;
    end if;
  end if;
end process p_Stack;

end behavioural;

-- --================================== End ==================================--
