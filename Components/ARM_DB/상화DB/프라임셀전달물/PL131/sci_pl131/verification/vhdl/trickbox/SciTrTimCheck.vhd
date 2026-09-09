-- --=========================================================================--
--  This confidential and proprietary software may be used only as
--  authorised by a licensing agreement from ARM Limited
--    (C) COPYRIGHT 2001 ARM Limited
--        ALL RIGHTS RESERVED
--  The entire notice above must be reproduced on all authorised
--  copies and copies may only be made to the extent permitted
--  by a licensing agreement from ARM Limited.
--  ----------------------------------------------------------------------------
--
--  Version and Release Control Information:
--
--  File Name              : SciTrTimCheck.vhd.rcaS
--  File Revision          : 1.1
--
--  Release Information    : PrimeCell(TM)-PL131-REL1v0
--
--  ----------------------------------------------------------------------------
 
--  ----------------------------------------------------------------------------
--  Purpose : This block check the SCICLK width and assert Error message
--            if there is any violations happened. 
-- --=========================================================================--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

library Std_DevelopersKit;
use     std_DevelopersKit.Std_Regpak.all;
use     std_Developerskit.Std_IOpak.all;
 
--------------------------------------------------------------------------------

entity SciTrTimCheck is
  port (
        SCICLK        : in  std_logic; -- Referance clock 
        PRESETn       : in  std_logic; -- reset input
        SCIDATAOUT    : in  std_logic; -- SCI data out
        SCICLKIN      : in  std_logic; -- SCICLK input
        DeBugOn       : in  std_logic; -- Debug message on
        SCITrRFCK     : in  std_logic_vector(15 downto 0); -- RFCLK register    
        SCITrWV       : in  std_logic_vector(7 downto 0);  -- Error Margin Reg 
        SCITrCKICC    : in  std_logic_vector(15 downto 0) := "0000000000000000";
        SCICLKErEn    : in  std_logic; -- SCICLK Error  En
        TXPtimErEn    : in  std_logic; -- TX parity time Error En
        TXPErEn       : in  std_logic; -- TX parity Error En
        TXPtimWdErEn  : in  std_logic; -- TX P time width Error En
        RXPErEn       : in  std_logic; -- Receive parity Error En
        RXCtimErEn    : in  std_logic; -- RX charactor time Error En
        RXBtimErEn    : in  std_logic; -- RX Block time Error En
        StartBitErEn  : in  std_logic; -- Start Bit Error En
        TXPtimError   : in  std_logic; -- TX parity time Error
        TXPtimWdError : in  std_logic; -- TX parity time width Error
        TXPError      : in  std_logic; -- TX parity Error
        RXPError      : in  std_logic; -- Receive parity Error
        RXCtimError   : in  std_logic; -- RX charactor time Error
        RXBtimError   : in  std_logic; -- RX Block time Error 
        StartBitError : in  std_logic  -- Start Bit Error 
       );
end SciTrTimCheck;

--------------------------------------------------------------------------------
--
--                   SciTrTimCheck
--                   =============
--
--------------------------------------------------------------------------------
-- Overview
-- ========
--
-- This module Check SCICLK width and assert Error message if any violations    
-- happened. Depend on the mask bit condition this module generate other
-- error messages also 
--------------------------------------------------------------------------------

--=============================== ARCHITECTURE ===============================--

--------------------------------------------------------------------------------

architecture behavioural of SciTrTimCheck  is

--------------------------------------------------------------------------------
-- Signal declarations
--------------------------------------------------------------------------------

  signal  CheckStartTime   : time    := 200 ns; 
  signal  tSCICLKRiseEdge  : time    := 0 ns;
  signal  tSCICLKFallEdge  : time    := 0 ns;
  signal  SCICLKWPLUSE     : time    := 0 ns;  
  signal  SCICLKWMINUSE    : time    := 0 ns;  
  signal  SCICLKtime       : integer := 0 ;
  signal  SCICLKOuttime    : integer := 0 ;
  signal  Offset           : time    := 0 ns;


--------------------------------------------------------------------------------
--
-- Main VHDL code
-- ==============
--
--------------------------------------------------------------------------------

begin
  
 
--------------------------------------------------------------------------------
--  
-- Calculating the required SCICLK width range
--
--------------------------------------------------------------------------------
SCICLKtime    <= To_Integer(SCITrRFCK);
SCICLKOuttime <= To_Integer(SCITrCKICC + 1) * SCICLKtime; 
offset        <= To_Integer(SCITrWV) * 1 ns;  
SCICLKWPLUSE  <= SCICLKOuttime * 1 ns + Offset;
SCICLKWMINUSE <= SCICLKOuttime * 1 ns - Offset;

--------------------------------------------------------------------------------
-- Sampling the rising edge time of SCICLK  
--------------------------------------------------------------------------------
process (SCICLKIN) 
begin
  if (SCICLKIN = '1') then 
    tSCICLKRiseEdge <= now;
  end if;
end process;

--------------------------------------------------------------------------------
-- Sampling the falling edge time of SCICLK  
--------------------------------------------------------------------------------
process (SCICLKIN) 
begin
  if (SCICLKIN = '0') then
    tSCICLKfallEdge <= now;
  end if;
end process;

--------------------------------------------------------------------------------
-- Check the timing violations in the high phase of SCICLK  
--------------------------------------------------------------------------------
p_HCheck : process(tSCICLKFallEdge)
begin
  if ((DebugOn = '1') and (SCICLKErEn = '1') and (now > CheckStartTime)) then
    if ((tSCICLKFallEdge - tSCICLKRiseEdge) > SCICLKWPLUSE) then 
      assert false
        report "Pulse width violation in high phase: Max SCICLK"
      severity error;
    elsif ((tSCICLKFallEdge - tSCICLKRiseEdge) < SCICLKWMINUSE) then
      assert false
        report "Pulse width violation in high phase : Min SCICLK"
      severity error;
    end if;
  end if;
end process p_HCheck;
 
--------------------------------------------------------------------------------
-- Check the timing violations in the low phase of SCICLK  
--------------------------------------------------------------------------------
p_LCheck : process(tSCICLKRiseEdge)
begin
  if (DebugOn = '1') and (SCICLKErEn = '1') and (now > CheckStartTime) then
    if ((tSCICLKRiseEdge - tSCICLKFallEdge) > SCICLKWPLUSE) then 
      assert false
        report "Pulse width violation in low phase: Max SCICLK"
      severity error;
    elsif ((tSCICLKRiseEdge - tSCICLKFallEdge) < SCICLKWMINUSE) then
      assert false
        report "Pulse width violation in low phase : Min SCICLK"
      severity error;
    end if;
  end if;
end process p_LCheck;

--------------------------------------------------------------------------------
-- Assert Error messages depend on the mask bit conditions   
--------------------------------------------------------------------------------
p_ErrorMessage : process(TXPtimError,TXPError,TXPtimWdError,RXPError,
                         StartBitError,RXCtimError,RXBtimError,TXPtimErEn,
                         TXPErEn,TXPtimWdErEn,RXPErEn, StartBitErEn,
                         RXCtimErEn,RXBtimErEn)
begin
  if ((DebugOn = '1') and (now > CheckStartTime)) then
    if ((TXPtimError ='1') and (TXPtimErEn = '1')) then
      assert false
        report "Parity Error signal asserted at wrong time"
      severity error;
    end if;
   
    if ((TXPError = '1') and (TXPErEn = '1')) then
      assert false
        report "Transmit Parity data bit Error "
      severity error;
    end if; 
 
    if ((TXPtimWdError ='1') and (TXPtimWdErEn = '1')) then
      assert false
        report "Parity signal width is wrong"
      severity error;
    end if;
      
    if ((RXPError ='1') and (RXPErEn = '1')) then
      assert false
        report "Timing error between retransmssion"
      severity error;
    end if;
    
    if ((RXCtimError ='1') and (RXCtimErEn = '1')) then
      assert false
        report "CH time error"
      severity error;
    end if;
                           
    if ((RXBtimError ='1') and (RXBtimErEn = '1')) then
      assert false
        report "BLK time Error"
      severity error;
      end if;

    if ((StartBitError ='1') and (StartBitErEn = '1')) then
      assert false
        report "Start Bit Detect Error"
      severity error;
    end if;
  end if;

end process p_ErrorMessage; 

end behavioural;

--================================== End =====================================--
