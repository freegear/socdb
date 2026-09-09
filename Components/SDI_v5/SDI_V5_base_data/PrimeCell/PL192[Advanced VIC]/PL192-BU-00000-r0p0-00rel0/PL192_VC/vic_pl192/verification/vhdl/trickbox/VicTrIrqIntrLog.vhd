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
-- File Name              : VicTrIrqIntrLog.vhd.rca
-- File Revision          : 1.4
--
-- Release Information    : PrimeCell(TM)-PL192-r0p0-00rel0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           VIC IRQ Interrupt Logic Block
-- --=========================================================================--
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

-- -----------------------------------------------------------------------------

entity VicTrIrqIntrLog is
  port (
-- Inputs
        HCLK             : in std_logic;  -- AHB Clock
        HRESETn          : in std_logic;  -- AHB Reset
        nVicTrIrqIn      : in std_logic;  -- Irq Interrupt from daisy chain
        VicTrIrqInReg    : in std_logic;  -- Enable bit to latch Irq Interrupt
        IrqStatus        : in std_logic_vector(31 downto 0); 
                                          -- IRQ Status from Interrupt 
                                          -- request Logic Block from 
                                          -- Daisy chain
        VectAddrVld      : in std_logic;  -- Address Valid Indicator 
        nVicTrSyncEn     : in std_logic;  -- Sync Enable Input 
        VicTrSwPriMask   : in std_logic_vector(15 downto 0);
                                          -- Software priority mask register
        VicTrVectPriDsy  : in std_logic_vector(3 downto 0);
                                          -- Vector priority register 
                                          -- for Daisy chain port
        VicTrVectPrity0  : in std_logic_vector(3 downto 0);
                                          -- Vector priority register 0
        VicTrVectPrity1  : in std_logic_vector(3 downto 0);
                                          -- Vector priority register 1
        VicTrVectPrity2  : in std_logic_vector(3 downto 0);
                                          -- Vector priority register 2
        VicTrVectPrity3  : in std_logic_vector(3 downto 0);
                                          -- Vector priority register 3
        VicTrVectPrity4  : in std_logic_vector(3 downto 0);
                                          -- Vector priority register 4
        VicTrVectPrity5  : in std_logic_vector(3 downto 0);
                                          -- Vector priority register 5
        VicTrVectPrity6  : in std_logic_vector(3 downto 0);
                                          -- Vector priority register 6
        VicTrVectPrity7  : in std_logic_vector(3 downto 0);
                                          -- Vector priority register 7
        VicTrVectPrity8  : in std_logic_vector(3 downto 0);
                                          -- Vector priority register 8
        VicTrVectPrity9  : in std_logic_vector(3 downto 0);
                                          -- Vector priority register 9
        VicTrVectPrity10 : in std_logic_vector(3 downto 0);
                                          -- Vector priority register 10
        VicTrVectPrity11 : in std_logic_vector(3 downto 0);
                                          -- Vector priority register 11
        VicTrVectPrity12 : in std_logic_vector(3 downto 0);
                                          -- Vector priority register 12
        VicTrVectPrity13 : in std_logic_vector(3 downto 0);
                                          -- Vector priority register 13
        VicTrVectPrity14 : in std_logic_vector(3 downto 0);
                                          -- Vector priority register 14
        VicTrVectPrity15 : in std_logic_vector(3 downto 0);
                                          -- Vector priority register 15
        VicTrVectPrity16 : in std_logic_vector(3 downto 0);
                                          -- Vector priority register 16
        VicTrVectPrity17 : in std_logic_vector(3 downto 0);
                                          -- Vector priority register 17
        VicTrVectPrity18 : in std_logic_vector(3 downto 0);
                                          -- Vector priority register 18
        VicTrVectPrity19 : in std_logic_vector(3 downto 0);
                                          -- Vector priority register 19
        VicTrVectPrity20 : in std_logic_vector(3 downto 0);
                                          -- Vector priority register 20
        VicTrVectPrity21 : in std_logic_vector(3 downto 0);
                                          -- Vector priority register 21
        VicTrVectPrity22 : in std_logic_vector(3 downto 0);
                                          -- Vector priority register 22
        VicTrVectPrity23 : in std_logic_vector(3 downto 0);
                                          -- Vector priority register 23
        VicTrVectPrity24 : in std_logic_vector(3 downto 0);
                                          -- Vector priority register 24
        VicTrVectPrity25 : in std_logic_vector(3 downto 0);
                                          -- Vector priority register 25
        VicTrVectPrity26 : in std_logic_vector(3 downto 0);
                                          -- Vector priority register 26
        VicTrVectPrity27 : in std_logic_vector(3 downto 0);
                                          -- Vector priority register 27
        VicTrVectPrity28 : in std_logic_vector(3 downto 0);
                                          -- Vector priority register 28
        VicTrVectPrity29 : in std_logic_vector(3 downto 0);
                                          -- Vector priority register 29
        VicTrVectPrity30 : in std_logic_vector(3 downto 0);
                                          -- Vector priority register 30
        VicTrVectPrity31 : in std_logic_vector(3 downto 0);
                                          -- Vector priority register 31
        MaskPrityReg     : in std_logic_vector(15 downto 0);   
                                          -- Mask Level from the IRQ 
                                          -- Priority Block 
        nTrIrq           : in std_logic;  -- Inverted signal of IRQ Interrupt 
                                          -- signal 

-- Outputs
      TrVectIrq          : out std_logic_vector(32 downto 0);   
                                          -- IRQ signals 
      DaisyIrqOut        : out std_logic; -- Daisy Chain Interrupt to 
                                          -- IRQ Priority Block
      PPTable0           : out std_logic_vector(32 downto 0);   
                                          --  Priority Table 0 for PLevel 0
      PPTable1           : out std_logic_vector(32 downto 0);   
                                          --  Priority Table 1 for PLevel 1
      PPTable2           : out std_logic_vector(32 downto 0);   
                                          --  Priority Table 2 for PLevel 2
      PPTable3           : out std_logic_vector(32 downto 0);   
                                          --  Priority Table 3 for PLevel 3
      PPTable4           : out std_logic_vector(32 downto 0);   
                                          --  Priority Table 4 for PLevel 4
      PPTable5           : out std_logic_vector(32 downto 0);   
                                          --  Priority Table 5 for PLevel 5
      PPTable6           : out std_logic_vector(32 downto 0);   
                                          --  Priority Table 6 for PLevel 6
      PPTable7           : out std_logic_vector(32 downto 0);   
                                          --  Priority Table 7 for PLevel 7
      PPTable8           : out std_logic_vector(32 downto 0);   
                                          --  Priority Table 8 for PLevel 8
      PPTable9           : out std_logic_vector(32 downto 0);   
                                          --  Priority Table 9 for PLevel 9
      PPTable10          : out std_logic_vector(32 downto 0);   
                                          --  Priority Table 10 for PLevel 10
      PPTable11          : out std_logic_vector(32 downto 0);   
                                          --  Priority Table 11 for PLevel 11
      PPTable12          : out std_logic_vector(32 downto 0);
                                          --  Priority Table 12 for PLevel 12
      PPTable13          : out std_logic_vector(32 downto 0);
                                          --  Priority Table 13 for PLevel 13
      PPTable14          : out std_logic_vector(32 downto 0);
                                          --  Priority Table 14 for PLevel 14
      PPTable15          : out std_logic_vector(32 downto 0)
                                          --  Priority Table 15 for PLevel 15
     );   
end VicTrIrqIntrLog;

-- -----------------------------------------------------------------------------
--
--                             VicTrIrqIntrLog
--                             ===============
--
-- -----------------------------------------------------------------------------
--
-- Overview
-- ========
-- This block generates the active interrupts after masking the interrupts
-- by Software priority and the current priority level. The current priority
-- level is an input which is generated by IRQ Priority block.
-- -----------------------------------------------------------------------------

-- --============================= ARCHITECTURE ==============================--

architecture behavioural of VicTrIrqIntrLog is

-- -----------------------------------------------------------------------------
-- Component declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Constant declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Signal declarations
-- -----------------------------------------------------------------------------
signal InvnVicTrIrqIn  :  std_logic; -- Inverted Daisy Chain Interrupt
signal DaisyIrqIn      :  std_logic; -- Daisy Chain Interrupt Internal signal
signal MCheck0         :  std_logic_vector(15 downto 0); 
                                     -- Priority Level for Interrupt Source 0
signal MCheck1         :  std_logic_vector(15 downto 0); 
                                     -- Priority Level for Interrupt Source 1
signal MCheck2         :  std_logic_vector(15 downto 0); 
                                     -- Priority Level for Interrupt Source 2
signal MCheck3         :  std_logic_vector(15 downto 0); 
                                     -- Priority Level for Interrupt Source 3
signal MCheck4         :  std_logic_vector(15 downto 0); 
                                     -- Priority Level for Interrupt Source 4
signal MCheck5         :  std_logic_vector(15 downto 0); 
                                     -- Priority Level for Interrupt Source 5
signal MCheck6         :  std_logic_vector(15 downto 0); 
                                     -- Priority Level for Interrupt Source 6
signal MCheck7         :  std_logic_vector(15 downto 0); 
                                     -- Priority Level for Interrupt Source 7
signal MCheck8         :  std_logic_vector(15 downto 0); 
                                     -- Priority Level for Interrupt Source 8
signal MCheck9         :  std_logic_vector(15 downto 0); 
                                     -- Priority Level for Interrupt Source 9
signal MCheck10        :  std_logic_vector(15 downto 0); 
                                     -- Priority Level for Interrupt Source 10
signal MCheck11        :  std_logic_vector(15 downto 0); 
                                     -- Priority Level for Interrupt Source 11
signal MCheck12        :  std_logic_vector(15 downto 0); 
                                     -- Priority Level for Interrupt Source 12
signal MCheck13        :  std_logic_vector(15 downto 0); 
                                     -- Priority Level for Interrupt Source 13
signal MCheck14        :  std_logic_vector(15 downto 0); 
                                     -- Priority Level for Interrupt Source 14
signal MCheck15        :  std_logic_vector(15 downto 0); 
                                     -- Priority Level for Interrupt Source 15
signal MCheck16        :  std_logic_vector(15 downto 0); 
                                     -- Priority Level for Interrupt Source 16
signal MCheck17        :  std_logic_vector(15 downto 0); 
                                     -- Priority Level for Interrupt Source 17
signal MCheck18        :  std_logic_vector(15 downto 0); 
                                     -- Priority Level for Interrupt Source 18
signal MCheck19        :  std_logic_vector(15 downto 0); 
                                     -- Priority Level for Interrupt Source 19
signal MCheck20        :  std_logic_vector(15 downto 0); 
                                     -- Priority Level for Interrupt Source 20
signal MCheck21        :  std_logic_vector(15 downto 0); 
                                     -- Priority Level for Interrupt Source 21
signal MCheck22        :  std_logic_vector(15 downto 0); 
                                     -- Priority Level for Interrupt Source 22
signal MCheck23        :  std_logic_vector(15 downto 0); 
                                     -- Priority Level for Interrupt Source 23
signal MCheck24        :  std_logic_vector(15 downto 0); 
                                     -- Priority Level for Interrupt Source 24
signal MCheck25        :  std_logic_vector(15 downto 0); 
                                     -- Priority Level for Interrupt Source 25
signal MCheck26        :  std_logic_vector(15 downto 0); 
                                     -- Priority Level for Interrupt Source 26
signal MCheck27        :  std_logic_vector(15 downto 0); 
                                     -- Priority Level for Interrupt Source 27
signal MCheck28        :  std_logic_vector(15 downto 0); 
                                     -- Priority Level for Interrupt Source 28
signal MCheck29        :  std_logic_vector(15 downto 0); 
                                     -- Priority Level for Interrupt Source 29
signal MCheck30        :  std_logic_vector(15 downto 0); 
                                     -- Priority Level for Interrupt Source 30
signal MCheck31        :  std_logic_vector(15 downto 0); 
                                     -- Priority Level for Interrupt Source 31
signal MCheck32        :  std_logic_vector(15 downto 0); 
                                     -- Priority Level for Daisy IRQ Interrupt 
signal IrqStatusReg1   :  std_logic_vector(32 downto 0);
                                     -- First latched version of IRQStatus
signal IrqStatusReg2   :  std_logic_vector(32 downto 0); 
                                     -- Second latched version of IRQStatus
signal RegnVicTrIrq    :  std_logic; -- Registered IRQ Daisy Interrupt
                                     -- IRQ signals latched   
-- -----------------------------------------------------------------------------
-- Function declarations
-- -----------------------------------------------------------------------------
-- -----------------------------------------------------------------------------
-- 16 bits Or Reduce function
-- -----------------------------------------------------------------------------
function ReduceOr ( ToOrReduce : in std_logic_vector(15 downto 0))   
                                               return std_logic is
  variable ReduceOr : std_logic;
begin
 ReduceOr :=  ToOrReduce(15) or ToOrReduce(14) or ToOrReduce(13) or 
              ToOrReduce(12) or ToOrReduce(11) or ToOrReduce(10) or 
              ToOrReduce(9)  or ToOrReduce(8)  or ToOrReduce(7)  or 
              ToOrReduce(6)  or ToOrReduce(5)  or ToOrReduce(4)  or 
              ToOrReduce(3)  or ToOrReduce(2)  or ToOrReduce(1)  or 
              ToOrReduce(0);
  return(ReduceOr);
end ReduceOr;
-- -----------------------------------------------------------------------------
--  Priority Level for each interrupt source
-- -----------------------------------------------------------------------------
function Decode4 ( PLevel : in std_logic_vector(3 downto 0))   
                                               return std_logic_vector is
variable Decode4  : std_logic_vector(15 downto 0);
begin
  case PLevel is
    when "0000" =>
      Decode4 := "0000000000000001";    
    when "0001" =>
      Decode4 := "0000000000000010";    
    when "0010" =>
      Decode4 := "0000000000000100";    
    when "0011" =>
      Decode4 := "0000000000001000";    
    when "0100" =>
      Decode4 := "0000000000010000";    
    when "0101" =>
      Decode4 := "0000000000100000";    
    when "0110" =>
      Decode4 := "0000000001000000";    
    when "0111" =>
      Decode4 := "0000000010000000";    
    when "1000" =>
      Decode4 := "0000000100000000";    
    when "1001" =>
      Decode4 := "0000001000000000";    
    when "1010" =>
      Decode4 := "0000010000000000";    
    when "1011" =>
      Decode4 := "0000100000000000";    
    when "1100" =>
      Decode4 := "0001000000000000";    
    when "1101" =>
      Decode4 := "0010000000000000";    
    when "1110" =>
      Decode4 := "0100000000000000";    
    when "1111" =>
      Decode4 := "1000000000000000";    
    when others  =>
      Decode4 := "0000000000000000";    
  end case;
  return(Decode4);
end Decode4;
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
-- Processing Daisy Chain Interrupt 
-- -----------------------------------------------------------------------------
InvnVicTrIrqIn <= '0' when (HRESETn = '0') 
                else 
                  not nVicTrIrqIn ;

-- -----------------------------------------------------------------------------
-- Registering the FIQ Interrupt from Daisy chain if VicTrIrqInReg is
-- enabled.
-- -----------------------------------------------------------------------------
p_IrqDaisy : process (HCLK, HRESETn)
begin
  if (HRESETn = '0') then
    RegnVicTrIrq <= '0';    
  elsif (HCLK'event and HCLK = '1') then
    RegnVicTrIrq <= InvnVicTrIrqIn;    
  end if;
end process p_IrqDaisy;

DaisyIrqIn <= RegnVicTrIrq when (VicTrIrqInReg = '1') else InvnVicTrIrqIn ;
DaisyIrqOut <= RegnVicTrIrq when (VicTrIrqInReg = '1') else InvnVicTrIrqIn ;
-- -----------------------------------------------------------------------------
-- Registering the IRQ Status Signals
-- -----------------------------------------------------------------------------
p_Irqlatch : process (HCLK, HRESETn)
begin
   if (HRESETn = '0') then
      IrqStatusReg1 <= (others => '0');    
      IrqStatusReg2 <= (others => '0');    
   elsif (HCLK'event and HCLK = '1') then
      IrqStatusReg1 <= DaisyIrqIn & IrqStatus;    
      IrqStatusReg2 <= IrqStatusReg1;    
   end if;
end process p_Irqlatch;

-- -----------------------------------------------------------------------------
-- Programmable Priority Table Update
-- MCheck 0 - 15 are the outputs of the priority level, Software priority mask
-- current masking value. At the reset all interrupts are not masked.
-- -----------------------------------------------------------------------------
p_pptgencomb : process (HRESETn, VicTrSwPriMask, MaskPrityReg, 
                        VicTrVectPrity0, VicTrVectPrity1, VicTrVectPrity2, 
                        VicTrVectPrity3, VicTrVectPrity4, VicTrVectPrity5, 
                        VicTrVectPrity6, VicTrVectPrity7, VicTrVectPrity8, 
                        VicTrVectPrity9, VicTrVectPrity10, VicTrVectPrity11, 
                        VicTrVectPrity12, VicTrVectPrity13, VicTrVectPrity14, 
                        VicTrVectPrity15, VicTrVectPrity16, VicTrVectPrity17, 
                        VicTrVectPrity18, VicTrVectPrity19, VicTrVectPrity20, 
                        VicTrVectPrity21, VicTrVectPrity22, VicTrVectPrity23, 
                        VicTrVectPrity24, VicTrVectPrity25, VicTrVectPrity26, 
                        VicTrVectPrity27, VicTrVectPrity28, VicTrVectPrity29, 
                        VicTrVectPrity30, VicTrVectPrity31, VicTrVectPriDsy)
begin
  if (HRESETn = '0') then
    MCheck0 <= "1000000000000000";    
    MCheck1 <= "1000000000000000";    
    MCheck2 <= "1000000000000000";    
    MCheck3 <= "1000000000000000";    
    MCheck4 <= "1000000000000000";    
    MCheck5 <= "1000000000000000";    
    MCheck6 <= "1000000000000000";    
    MCheck7 <= "1000000000000000";    
    MCheck8 <= "1000000000000000";    
    MCheck9 <= "1000000000000000";    
    MCheck10 <= "1000000000000000";    
    MCheck11 <= "1000000000000000";    
    MCheck12 <= "1000000000000000";    
    MCheck13 <= "1000000000000000";    
    MCheck14 <= "1000000000000000";    
    MCheck15 <= "1000000000000000";    
    MCheck16 <= "1000000000000000";    
    MCheck17 <= "1000000000000000";    
    MCheck18 <= "1000000000000000";    
    MCheck19 <= "1000000000000000";    
    MCheck20 <= "1000000000000000";    
    MCheck21 <= "1000000000000000";    
    MCheck22 <= "1000000000000000";    
    MCheck23 <= "1000000000000000";    
    MCheck24 <= "1000000000000000";    
    MCheck25 <= "1000000000000000";    
    MCheck26 <= "1000000000000000";    
    MCheck27 <= "1000000000000000";    
    MCheck28 <= "1000000000000000";    
    MCheck29 <= "1000000000000000";    
    MCheck30 <= "1000000000000000";    
    MCheck31 <= "1000000000000000";    
    MCheck32 <= "1000000000000000";    
  else
    MCheck0 <= (Decode4(VicTrVectPrity0) and VicTrSwPriMask) and MaskPrityReg;  
    MCheck1 <= (Decode4(VicTrVectPrity1) and VicTrSwPriMask) and MaskPrityReg;  
    MCheck2 <= (Decode4(VicTrVectPrity2) and VicTrSwPriMask) and MaskPrityReg;  
    MCheck3 <= (Decode4(VicTrVectPrity3) and VicTrSwPriMask) and MaskPrityReg;  
    MCheck4 <= (Decode4(VicTrVectPrity4) and VicTrSwPriMask) and MaskPrityReg;  
    MCheck5 <= (Decode4(VicTrVectPrity5) and VicTrSwPriMask) and MaskPrityReg;  
    MCheck6 <= (Decode4(VicTrVectPrity6) and VicTrSwPriMask) and MaskPrityReg;  
    MCheck7 <= (Decode4(VicTrVectPrity7) and VicTrSwPriMask) and MaskPrityReg;  
    MCheck8 <= (Decode4(VicTrVectPrity8) and VicTrSwPriMask) and MaskPrityReg;  
    MCheck9 <= (Decode4(VicTrVectPrity9) and VicTrSwPriMask) and MaskPrityReg;  
    MCheck10 <= (Decode4(VicTrVectPrity10) and VicTrSwPriMask) and MaskPrityReg;
    MCheck11 <= (Decode4(VicTrVectPrity11) and VicTrSwPriMask) and MaskPrityReg;
    MCheck12 <= (Decode4(VicTrVectPrity12) and VicTrSwPriMask) and MaskPrityReg;
    MCheck13 <= (Decode4(VicTrVectPrity13) and VicTrSwPriMask) and MaskPrityReg;
    MCheck14 <= (Decode4(VicTrVectPrity14) and VicTrSwPriMask) and MaskPrityReg;
    MCheck15 <= (Decode4(VicTrVectPrity15) and VicTrSwPriMask) and MaskPrityReg;
    MCheck16 <= (Decode4(VicTrVectPrity16) and VicTrSwPriMask) and MaskPrityReg;
    MCheck17 <= (Decode4(VicTrVectPrity17) and VicTrSwPriMask) and MaskPrityReg;
    MCheck18 <= (Decode4(VicTrVectPrity18) and VicTrSwPriMask) and MaskPrityReg;
    MCheck19 <= (Decode4(VicTrVectPrity19) and VicTrSwPriMask) and MaskPrityReg;
    MCheck20 <= (Decode4(VicTrVectPrity20) and VicTrSwPriMask) and MaskPrityReg;
    MCheck21 <= (Decode4(VicTrVectPrity21) and VicTrSwPriMask) and MaskPrityReg;
    MCheck22 <= (Decode4(VicTrVectPrity22) and VicTrSwPriMask) and MaskPrityReg;
    MCheck23 <= (Decode4(VicTrVectPrity23) and VicTrSwPriMask) and MaskPrityReg;
    MCheck24 <= (Decode4(VicTrVectPrity24) and VicTrSwPriMask) and MaskPrityReg;
    MCheck25 <= (Decode4(VicTrVectPrity25) and VicTrSwPriMask) and MaskPrityReg;
    MCheck26 <= (Decode4(VicTrVectPrity26) and VicTrSwPriMask) and MaskPrityReg;
    MCheck27 <= (Decode4(VicTrVectPrity27) and VicTrSwPriMask) and MaskPrityReg;
    MCheck28 <= (Decode4(VicTrVectPrity28) and VicTrSwPriMask) and MaskPrityReg;
    MCheck29 <= (Decode4(VicTrVectPrity29) and VicTrSwPriMask) and MaskPrityReg;
    MCheck29 <= (Decode4(VicTrVectPrity29) and VicTrSwPriMask) and MaskPrityReg;
    MCheck30 <= (Decode4(VicTrVectPrity30) and VicTrSwPriMask) and MaskPrityReg;
    MCheck31 <= (Decode4(VicTrVectPrity31) and VicTrSwPriMask) and MaskPrityReg;
    MCheck32 <= (Decode4(VicTrVectPriDsy) and VicTrSwPriMask) and MaskPrityReg; 
  end if;
end process p_pptgencomb;

-- -----------------------------------------------------------------------------
-- Assigning MCheck signals to PPTable output registers
-- Each PPTable represents priority level for example PPTable0 represents
-- priority level 0 of all interrupts sources(31+Daisy Interrupts).
-- -----------------------------------------------------------------------------
PPTable0 <= MCheck32(0) & MCheck31(0) & MCheck30(0) & MCheck29(0) & 
            MCheck28(0) & MCheck27(0) & MCheck26(0) & MCheck25(0) & 
            MCheck24(0) & MCheck23(0) & MCheck22(0) & MCheck21(0) & 
            MCheck20(0) & MCheck19(0) & MCheck18(0) & MCheck17(0) & 
            MCheck16(0) & MCheck15(0) & MCheck14(0) & MCheck13(0) & 
            MCheck12(0) & MCheck11(0) & MCheck10(0) & MCheck9(0) & 
            MCheck8(0) & MCheck7(0) & MCheck6(0) & MCheck5(0) & 
            MCheck4(0) & MCheck3(0) & MCheck2(0) & MCheck1(0) & MCheck0(0) ;

PPTable1 <= MCheck32(1) & MCheck31(1) & MCheck30(1) & MCheck29(1) & 
            MCheck28(1) & MCheck27(1) & MCheck26(1) & MCheck25(1) & 
            MCheck24(1) & MCheck23(1) & MCheck22(1) & MCheck21(1) & 
            MCheck20(1) & MCheck19(1) & MCheck18(1) & MCheck17(1) & 
            MCheck16(1) & MCheck15(1) & MCheck14(1) & MCheck13(1) & 
            MCheck12(1) & MCheck11(1) & MCheck10(1) & MCheck9(1) & 
            MCheck8(1) & MCheck7(1) & MCheck6(1) & MCheck5(1) & 
            MCheck4(1) & MCheck3(1) & MCheck2(1) & MCheck1(1) & MCheck0(1) ;

PPTable2 <= MCheck32(2) & MCheck31(2) & MCheck30(2) & MCheck29(2) & 
            MCheck28(2) & MCheck27(2) & MCheck26(2) & MCheck25(2) & 
            MCheck24(2) & MCheck23(2) & MCheck22(2) & MCheck21(2) & 
            MCheck20(2) & MCheck19(2) & MCheck18(2) & MCheck17(2) & 
            MCheck16(2) & MCheck15(2) & MCheck14(2) & MCheck13(2) & 
            MCheck12(2) & MCheck11(2) & MCheck10(2) & MCheck9(2) & 
            MCheck8(2) & MCheck7(2) & MCheck6(2) & MCheck5(2) & 
            MCheck4(2) & MCheck3(2) & MCheck2(2) & MCheck1(2) & MCheck0(2) ;

PPTable3 <= MCheck32(3) & MCheck31(3) & MCheck30(3) & MCheck29(3) & 
            MCheck28(3) & MCheck27(3) & MCheck26(3) & MCheck25(3) & 
            MCheck24(3) & MCheck23(3) & MCheck22(3) & MCheck21(3) & 
            MCheck20(3) & MCheck19(3) & MCheck18(3) & MCheck17(3) & 
            MCheck16(3) & MCheck15(3) & MCheck14(3) & MCheck13(3) & 
            MCheck12(3) & MCheck11(3) & MCheck10(3) & MCheck9(3) & 
            MCheck8(3) & MCheck7(3) & MCheck6(3) & MCheck5(3) & 
            MCheck4(3) & MCheck3(3) & MCheck2(3) & MCheck1(3) & MCheck0(3) ;

PPTable4 <= MCheck32(4) & MCheck31(4) & MCheck30(4) & MCheck29(4) & 
            MCheck28(4) & MCheck27(4) & MCheck26(4) & MCheck25(4) & 
            MCheck24(4) & MCheck23(4) & MCheck22(4) & MCheck21(4) & 
            MCheck20(4) & MCheck19(4) & MCheck18(4) & MCheck17(4) & 
            MCheck16(4) & MCheck15(4) & MCheck14(4) & MCheck13(4) & 
            MCheck12(4) & MCheck11(4) & MCheck10(4) & MCheck9(4) & 
            MCheck8(4) & MCheck7(4) & MCheck6(4) & MCheck5(4) & 
            MCheck4(4) & MCheck3(4) & MCheck2(4) & MCheck1(4) & MCheck0(4) ;

PPTable5 <= MCheck32(5) & MCheck31(5) & MCheck30(5) & MCheck29(5) & 
            MCheck28(5) & MCheck27(5) & MCheck26(5) & MCheck25(5) & 
            MCheck24(5) & MCheck23(5) & MCheck22(5) & MCheck21(5) & 
            MCheck20(5) & MCheck19(5) & MCheck18(5) & MCheck17(5) & 
            MCheck16(5) & MCheck15(5) & MCheck14(5) & MCheck13(5) & 
            MCheck12(5) & MCheck11(5) & MCheck10(5) & MCheck9(5) & 
            MCheck8(5) & MCheck7(5) & MCheck6(5) & MCheck5(5) & 
            MCheck4(5) & MCheck3(5) & MCheck2(5) & MCheck1(5) & MCheck0(5) ;

PPTable6 <= MCheck32(6) & MCheck31(6) & MCheck30(6) & MCheck29(6) & 
            MCheck28(6) & MCheck27(6) & MCheck26(6) & MCheck25(6) & 
            MCheck24(6) & MCheck23(6) & MCheck22(6) & MCheck21(6) & 
            MCheck20(6) & MCheck19(6) & MCheck18(6) & MCheck17(6) & 
            MCheck16(6) & MCheck15(6) & MCheck14(6) & MCheck13(6) & 
            MCheck12(6) & MCheck11(6) & MCheck10(6) & MCheck9(6) & 
            MCheck8(6) & MCheck7(6) & MCheck6(6) & MCheck5(6) & 
            MCheck4(6) & MCheck3(6) & MCheck2(6) & MCheck1(6) & MCheck0(6) ;

PPTable7 <= MCheck32(7) & MCheck31(7) & MCheck30(7) & MCheck29(7) & 
            MCheck28(7) & MCheck27(7) & MCheck26(7) & MCheck25(7) & 
            MCheck24(7) & MCheck23(7) & MCheck22(7) & MCheck21(7) & 
            MCheck20(7) & MCheck19(7) & MCheck18(7) & MCheck17(7) & 
            MCheck16(7) & MCheck15(7) & MCheck14(7) & MCheck13(7) & 
            MCheck12(7) & MCheck11(7) & MCheck10(7) & MCheck9(7) & 
            MCheck8(7) & MCheck7(7) & MCheck6(7) & MCheck5(7) & 
            MCheck4(7) & MCheck3(7) & MCheck2(7) & MCheck1(7) & MCheck0(7) ;

PPTable8 <= MCheck32(8) & MCheck31(8) & MCheck30(8) & MCheck29(8) & 
            MCheck28(8) & MCheck27(8) & MCheck26(8) & MCheck25(8) & 
            MCheck24(8) & MCheck23(8) & MCheck22(8) & MCheck21(8) & 
            MCheck20(8) & MCheck19(8) & MCheck18(8) & MCheck17(8) & 
            MCheck16(8) & MCheck15(8) & MCheck14(8) & MCheck13(8) & 
            MCheck12(8) & MCheck11(8) & MCheck10(8) & MCheck9(8) & 
            MCheck8(8) & MCheck7(8) & MCheck6(8) & MCheck5(8) & 
            MCheck4(8) & MCheck3(8) & MCheck2(8) & MCheck1(8) & MCheck0(8) ;

PPTable9 <= MCheck32(9) & MCheck31(9) & MCheck30(9) & MCheck29(9) & 
            MCheck28(9) & MCheck27(9) & MCheck26(9) & MCheck25(9) & 
            MCheck24(9) & MCheck23(9) & MCheck22(9) & MCheck21(9) & 
            MCheck20(9) & MCheck19(9) & MCheck18(9) & MCheck17(9) & 
            MCheck16(9) & MCheck15(9) & MCheck14(9) & MCheck13(9) & 
            MCheck12(9) & MCheck11(9) & MCheck10(9) & MCheck9(9) & 
            MCheck8(9) & MCheck7(9) & MCheck6(9) & MCheck5(9) & 
            MCheck4(9) & MCheck3(9) & MCheck2(9) & MCheck1(9) & MCheck0(9) ;

PPTable10 <= MCheck32(10) & MCheck31(10) & MCheck30(10) & 
             MCheck29(10) & MCheck28(10) & MCheck27(10) & 
             MCheck26(10) & MCheck25(10) & MCheck24(10) & 
             MCheck23(10) & MCheck22(10) & MCheck21(10) & 
             MCheck20(10) & MCheck19(10) & MCheck18(10) & 
             MCheck17(10) & MCheck16(10) & MCheck15(10) & 
             MCheck14(10) & MCheck13(10) & MCheck12(10) & 
             MCheck11(10) & MCheck10(10) & MCheck9(10) & 
             MCheck8(10) & MCheck7(10) & MCheck6(10) & 
             MCheck5(10) & MCheck4(10) & MCheck3(10) & 
             MCheck2(10) & MCheck1(10) & MCheck0(10) ;

PPTable11 <= MCheck32(11) & MCheck31(11) & MCheck30(11) & 
             MCheck29(11) & MCheck28(11) & MCheck27(11) & 
             MCheck26(11) & MCheck25(11) & MCheck24(11) & 
             MCheck23(11) & MCheck22(11) & MCheck21(11) & 
             MCheck20(11) & MCheck19(11) & MCheck18(11) & 
             MCheck17(11) & MCheck16(11) & MCheck15(11) & 
             MCheck14(11) & MCheck13(11) & MCheck12(11) & 
             MCheck11(11) & MCheck10(11) & MCheck9(11) & 
             MCheck8(11) & MCheck7(11) & MCheck6(11) & 
             MCheck5(11) & MCheck4(11) & MCheck3(11) & 
             MCheck2(11) & MCheck1(11) & MCheck0(11) ;

PPTable12 <= MCheck32(12) & MCheck31(12) & MCheck30(12) & 
             MCheck29(12) & MCheck28(12) & MCheck27(12) & 
             MCheck26(12) & MCheck25(12) & MCheck24(12) & 
             MCheck23(12) & MCheck22(12) & MCheck21(12) & 
             MCheck20(12) & MCheck19(12) & MCheck18(12) & 
             MCheck17(12) & MCheck16(12) & MCheck15(12) & 
             MCheck14(12) & MCheck13(12) & MCheck12(12) & 
             MCheck11(12) & MCheck10(12) & MCheck9(12) & 
             MCheck8(12) & MCheck7(12) & MCheck6(12) & 
             MCheck5(12) & MCheck4(12) & MCheck3(12) & 
             MCheck2(12) & MCheck1(12) & MCheck0(12) ;

PPTable13 <= MCheck32(13) & MCheck31(13) & MCheck30(13) & 
             MCheck29(13) & MCheck28(13) & MCheck27(13) & 
             MCheck26(13) & MCheck25(13) & MCheck24(13) & 
             MCheck23(13) & MCheck22(13) & MCheck21(13) & 
             MCheck20(13) & MCheck19(13) & MCheck18(13) & 
             MCheck17(13) & MCheck16(13) & MCheck15(13) & 
             MCheck14(13) & MCheck13(13) & MCheck12(13) & 
             MCheck11(13) & MCheck10(13) & MCheck9(13) & 
             MCheck8(13) & MCheck7(13) & MCheck6(13) & 
             MCheck5(13) & MCheck4(13) & MCheck3(13) & 
             MCheck2(13) & MCheck1(13) & MCheck0(13) ;

PPTable14 <= MCheck32(14) & MCheck31(14) & MCheck30(14) & 
             MCheck29(14) & MCheck28(14) & MCheck27(14) & 
             MCheck26(14) & MCheck25(14) & MCheck24(14) & 
             MCheck23(14) & MCheck22(14) & MCheck21(14) & 
             MCheck20(14) & MCheck19(14) & MCheck18(14) & 
             MCheck17(14) & MCheck16(14) & MCheck15(14) & 
             MCheck14(14) & MCheck13(14) & MCheck12(14) & 
             MCheck11(14) & MCheck10(14) & MCheck9(14) & 
             MCheck8(14) & MCheck7(14) & MCheck6(14) & 
             MCheck5(14) & MCheck4(14) & MCheck3(14) & 
             MCheck2(14) & MCheck1(14) & MCheck0(14) ;

PPTable15 <= MCheck32(15) & MCheck31(15) & MCheck30(15) & 
             MCheck29(15) & MCheck28(15) & MCheck27(15) & 
             MCheck26(15) & MCheck25(15) & MCheck24(15) & 
             MCheck23(15) & MCheck22(15) & MCheck21(15) & 
             MCheck20(15) & MCheck19(15) & MCheck18(15) & 
             MCheck17(15) & MCheck16(15) & MCheck15(15) & 
             MCheck14(15) & MCheck13(15) & MCheck12(15) & 
             MCheck11(15) & MCheck10(15) & MCheck9(15) & 
             MCheck8(15) & MCheck7(15) & MCheck6(15) & 
             MCheck5(15) & MCheck4(15) & MCheck3(15) & 
             MCheck2(15) & MCheck1(15) & MCheck0(15) ;

-- -----------------------------------------------------------------------------
-- VectIRQx signals
-- Active interrupts Generation 
-- -----------------------------------------------------------------------------
TrVectIrq(0) <= ReduceOr(MCheck0) and IrqStatusReg2(0);
TrVectIrq(1) <= ReduceOr(MCheck1) and IrqStatusReg2(1);
TrVectIrq(2) <= ReduceOr(MCheck2) and IrqStatusReg2(2);
TrVectIrq(3) <= ReduceOr(MCheck3) and IrqStatusReg2(3);
TrVectIrq(4) <= ReduceOr(MCheck4) and IrqStatusReg2(4);
TrVectIrq(5) <= ReduceOr(MCheck5) and IrqStatusReg2(5);
TrVectIrq(6) <= ReduceOr(MCheck6) and IrqStatusReg2(6);
TrVectIrq(7) <= ReduceOr(MCheck7) and IrqStatusReg2(7);
TrVectIrq(8) <= ReduceOr(MCheck8) and IrqStatusReg2(8);
TrVectIrq(9) <= ReduceOr(MCheck9) and IrqStatusReg2(9);
TrVectIrq(10) <= ReduceOr(MCheck10) and IrqStatusReg2(10);
TrVectIrq(11) <= ReduceOr(MCheck11) and IrqStatusReg2(11);
TrVectIrq(12) <= ReduceOr(MCheck12) and IrqStatusReg2(12);
TrVectIrq(13) <= ReduceOr(MCheck13) and IrqStatusReg2(13);
TrVectIrq(14) <= ReduceOr(MCheck14) and IrqStatusReg2(14);
TrVectIrq(15) <= ReduceOr(MCheck15) and IrqStatusReg2(15);
TrVectIrq(16) <= ReduceOr(MCheck16) and IrqStatusReg2(16);
TrVectIrq(17) <= ReduceOr(MCheck17) and IrqStatusReg2(17);
TrVectIrq(18) <= ReduceOr(MCheck18) and IrqStatusReg2(18);
TrVectIrq(19) <= ReduceOr(MCheck19) and IrqStatusReg2(19);
TrVectIrq(20) <= ReduceOr(MCheck20) and IrqStatusReg2(20);
TrVectIrq(21) <= ReduceOr(MCheck21) and IrqStatusReg2(21);
TrVectIrq(22) <= ReduceOr(MCheck22) and IrqStatusReg2(22);
TrVectIrq(23) <= ReduceOr(MCheck23) and IrqStatusReg2(23);
TrVectIrq(24) <= ReduceOr(MCheck24) and IrqStatusReg2(24);
TrVectIrq(25) <= ReduceOr(MCheck25) and IrqStatusReg2(25);
TrVectIrq(26) <= ReduceOr(MCheck26) and IrqStatusReg2(26);
TrVectIrq(27) <= ReduceOr(MCheck27) and IrqStatusReg2(27);
TrVectIrq(28) <= ReduceOr(MCheck28) and IrqStatusReg2(28);
TrVectIrq(29) <= ReduceOr(MCheck29) and IrqStatusReg2(29);
TrVectIrq(30) <= ReduceOr(MCheck30) and IrqStatusReg2(30);
TrVectIrq(31) <= ReduceOr(MCheck31) and IrqStatusReg2(31);
TrVectIrq(32) <= ReduceOr(MCheck32) and IrqStatusReg2(32);

end behavioural;

-- --================================== End ==================================--
