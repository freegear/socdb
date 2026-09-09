--  ----------------------------------------------------------------------------
--  This confidential and proprietary software may be used only
--  as authorised by a licensing agreement from ARM Limited
--  (C) COPYRIGHT 1998 ARM Limited
--  ALL RIGHTS RESERVED
--  The entire notice above must be reproduced on all authorised copies
--  and copies may only be made to the extent permitted by a
--  licensing agreement from ARM Limited.
--  ----------------------------------------------------------------------------
--
--  Version and Release Control Information :
--
--
--  Filename             : $RCSfile :  $
--
--  File Revision        : $Revision : $
--
--  Release Information  : $State : $
--
--  ----------------------------------------------------------------------------
--  Purpose : 
--          This state machine implements the KMI controller.
--
-- -------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

entity KmiTrController is
  port (
        REFCLK       : in std_logic; -- Reference Clock
        BnRES        : in std_logic; -- APB Reset
        nKMIRST      : in std_logic; -- KMI Reset 
        BitCount     : in std_logic_vector(3 downto 0); -- Bit Counter Value
        KmiTrTXFE    : in std_logic; -- Transmit Fifo Status
        KmiTrTIMOUT  : in std_logic_vector(4 downto 0); -- TimeOut Value
        KmiTrCnREG   : in std_logic_vector(4 downto 0); -- Control Register
        KDATAIn      : in std_logic; -- Data Input from PAD
        KCLKIn       : in std_logic; -- Clock Input from PAD
        KDATAOut     : in std_logic; -- Data Output to PAD 
        KCLKOut      : in std_logic; -- Clock Output to PAD 
        KCLK         : in std_logic; -- Clock Input from the KCLKGen Module
        EnableOut    : in std_logic; -- Enable Signal from KmiTrOutDrive module
        RTS          : in std_logic; -- Request To Send Indication 
        CurrentState : out std_logic_vector(1 downto 0) -- Current State Output
      );
end KmiTrController;

-- -------------------------------------------------------------------------
--
--                                KmiTrController
--                                ===============
--
-- -------------------------------------------------------------------------
--
-- Overview
-- =======
--
-- This state machine controls the overall transmit and request operation
-- of the KMI. If simultaneous request for transmission and reception occur,
-- the reception is given priority. If during transmission, there is a request 
-- for reception before the 10th bit, it will abort transmission and will start
-- the recieve cycle. If there is a timeout request then the controller aborts
-- the transmit or receive in progress. If at any time the TrickBox is disabled
-- then the controller goes to the Reset state.
-- The controller in the PS2/AT mode interface sends an acknowledge pulse
-- at the end of every transmit process. In the LEGACY mode there is no 
-- acknowledge pulse.
--
-- -------------------------------------------------------------------------
--
-- ====================== ARCHITECTURE ===================================--

architecture behavioural of KmiTrController is

-- ----------------------------------------------------------------------------
-- Overloaded "=" Operator
-- ----------------------------------------------------------------------------
function "="(L : std_logic_vector; R : std_logic_vector) return std_logic is
variable OutVal  : std_logic;
begin
  if (L = R) then
    OutVal := '1';
  else
    OutVal := '0';
  end if;
  return OutVal;   
end;

-- ----------------------------------------------------------------------------
-- Overloaded "/=" Operator
-- ----------------------------------------------------------------------------
function "/="(L : std_logic_vector; R : std_logic_vector) return std_logic is
variable OutVal  : std_logic;
begin
  if (L /= R) then
    OutVal := '1';
  else
    OutVal := '0';
  end if;
  return OutVal;   
end;
 
-- -----------------------------------------------------------------------------
-- Signal declarations
-- -----------------------------------------------------------------------------
signal iCurrentState  : std_logic_vector(1 downto 0); 
-- Internal Copy of Current State

signal NextState      : std_logic_vector(1 downto 0); 
-- D-Input for iCurrentState

signal TOutBit        : std_logic_vector(3 downto 0); 
-- TimeOut Bit

signal Inhibit        : std_logic; 

signal DelayEn        : std_logic; 
-- Delayed version of EnableOut signal

-- -----------------------------------------------------------------------------
--
-- Main body of code
-- =================
--
-- -----------------------------------------------------------------------------

begin

TOutBit <= KmiTrTIMOUT(3 downto 0); -- Bit Number for timeout

-- ---------------------------------------------------------------------------
-- Delayed Version of EnableOut
-- ---------------------------------------------------------------------------
p_DelayEnSeq : process (REFCLK, BnRES)
begin
  if (BnRES = '0') then
    DelayEn <= '0';
  elsif (REFCLK'event and REFCLK = '1') then
    DelayEn <= EnableOut;
  end if;
end process p_DelayEnSeq;

-- ---------------------------------------------------------------------------
-- Delayed Version of EnableOut
-- ---------------------------------------------------------------------------
p_InhibitSeq : process (REFCLK, BnRES)
begin
  if (BnRES = '0') then
    Inhibit <= '0';
  elsif (REFCLK'event and REFCLK = '1') then
    Inhibit <= KCLKOut and not(KCLKIn);
  end if;
end process p_InhibitSeq;

-- ---------------------------------------------------------------------------
-- Next State Generation
-- ---------------------------------------------------------------------------
p_NextStateComb : process (iCurrentState, BitCount, KmiTrTXFE, KmiTrTIMOUT, 
                          KmiTrCnREG, TOutBit, KDATAIn, KCLKIn, KDATAOut, 
                          KCLKOut, RTS) 
begin
  if ((Inhibit and not(RTS))  = '1') then
    NextState <= "00";
  elsif (((BitCount /= "1010") and RTS) = '1') then
    NextState <= "01";
  else
    NextState <= iCurrentState;
    case iCurrentState is
      -- If TrickBox is enabled and Request to Send is there, state will go 
      -- to receive state. In case of KCLK and KDATA line HIGH and if some data
      -- is available in the Transmit FIFO, NextState will be Transmit State.
      -- Otherwise it will remain in the Idle State.  
      when "00" =>
        if ((KmiTrCnREG(0) and RTS) = '1') then
          NextState <= "01";
        elsif ((KCLKIn and KDATAIn and KmiTrCnREG(0) and not(KmiTrTXFE)) = 
                                                           '1') then
          NextState <= "10";
        else
          NextState <= "00";
        end if;
        
      -- If Timeout is enabled, State will go to TIMEOUT state. If EnableOut 
      -- goes LOW, State will go to Idle State. Otherwise it will remain in 
      -- the Receive State.  
      when "01" =>
        if (((BitCount = TOutBit) and KmiTrTIMOUT(4) and not(KCLK) and 
             not(KCLKOut)) = '1') then
          NextState <= "11";
        elsif ((not(EnableOut) and DelayEn) = '1') then
          NextState <= "00";
        else
          NextState <= "01";
        end if;
        
      -- If Timeout is enabled, State will go to TIMEOUT state. It will remain 
      -- in the current state i.e. Transmit state till all bytes has been 
      -- transmitted.
      when "10" =>
        if (((BitCount = TOutBit) and KmiTrTIMOUT(4)) = '1') then
          NextState <= "11";
        elsif (((BitCount = "1011") and KCLKIn) = '1') then
          NextState <= "00";
        else
          NextState <= "10";
        end if;
        
      -- If Timeout is enabled, State will remain in the TIMEOUT state. 
      -- Otherwise it will go to Idle State.
      when "11" =>
        if (KmiTrTIMOUT(4) = '0') then
          NextState <= "00";
        else
          NextState <= "11";
        end if;
    
      when others =>
        null;
    end case;
  end if;
end process p_NextStateComb;

-- ---------------------------------------------------------------------------
-- iCurrentState update with every positive edge of REFCLK.
-- ---------------------------------------------------------------------------
p_CurrentStateSeq : process (REFCLK, nKMIRST)
begin
  if (nKMIRST = '0') then
    iCurrentState <= "00";
  elsif (REFCLK'event and REFCLK = '1') then
    iCurrentState <= NextState;
  end if;
end process p_CurrentStateSeq;

CurrentState <= iCurrentState;

end behavioural;

-- ========================End of KmiTrController ==========================--
