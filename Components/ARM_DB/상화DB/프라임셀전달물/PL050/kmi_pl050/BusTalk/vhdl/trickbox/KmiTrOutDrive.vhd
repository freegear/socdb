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
--  Filename            : KmiTrOutDrive.vhd,v
--
--  File Revision       : 1.1
--
--  Release Information : PL050-REL1v1
--
--  ----------------------------------------------------------------------------
--  Purpose : This modules drives the Data and Clock on the KCLK and KDATA 
--            lines.
--  ---------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

entity KmiTrOutDrive is
  port (
       REFCLK         : in  std_logic; -- Reference Clock
       BnRES          : in  std_logic; -- APB Reset
       BitCount       : in  std_logic_vector(3 downto 0); -- Bit Counter Value
       FParErr        : in  std_logic; -- Forced Parity Error
       KCLK           : in  std_logic; -- KCLK input
       KmiTrTXREG     : in  std_logic_vector(7 downto 0); -- Tx Data Input
       CurrentState   : in  std_logic_vector(1 downto 0); -- Current State
       KmiTrDSI       : in  std_logic_vector(15 downto 0); -- DSI Tim. Param.
       KmiTrRG        : in  std_logic_vector(15 downto 0); -- RG Tim. Param.
       KDATAIn        : in  std_logic; -- Data line Input from PAD
       RTS            : in  std_logic; -- Request to Send Indication
       LegacyBit      : in  std_logic; -- Legacy Mode Bit
       PWDATAIN       : in  std_logic_vector(15 downto 0); -- APB Data Input 
       WrenSTAT       : in  std_logic; -- Status Register Write Enable
       FeedBackTx     : in  std_logic; -- Used as feedback for synchronization
       FeedBackRx     : in  std_logic; -- Used as feedback for synchronization
       KmiTrRXREG     : out std_logic_vector(7 downto 0); -- Received Data
       KmiTrPARITYERR : out std_logic; -- Parity Error Bit
       KmiTrFRAMEERR  : out std_logic; -- framing Error Bit
       DataAvl        : out std_logic; -- Data Available Indication to RX fifo
       RdUpdateTx     : out std_logic; -- Data Read signal to TX Fifo
       KCLKOut        : out std_logic; -- Clock Output to The PAD
       KDATAOut       : out std_logic; -- Data Output to The PAD
       EnableOut      : out std_logic  -- Enable signal to different modules
       );  
end KmiTrOutDrive;

-- ----------------------------------------------------------------------------
--
--                         KmiTrOutDrive
--                         =============
--
-- ----------------------------------------------------------------------------
--
-- Overview
-- ========
-- This module depending on the CurrentState, drives or recieves the data.
-- During Transmission it enables the KCLK generation and outputs the data
-- on the KDATAOut. During reception it samples the Data line at every 
-- Clock and assembles the input bits in a register. It also checks for
-- Parity Error and framing Error. After reception it stores the data into
-- the Rx fifo.
--
-- ----------------------------------------------------------------------------
--
-- ============================== ARCHITECTURE ==============================--
--

architecture behavioural of KmiTrOutDrive is

-------------------------------------------------------------------------------
-- Overloaded "=" operator
-------------------------------------------------------------------------------
function "="(L: std_logic_vector; R: std_logic_vector) return std_logic is
variable OutVal : std_logic;
begin
  if (L = R) then
    OutVal := '1';
  else
    OutVal := '0';
  end if;
  return OutVal;
end;

-------------------------------------------------------------------------------
-- to_integer
-------------------------------------------------------------------------------
function to_integer( arg: std_logic_vector(15 downto 0)) return integer is
variable OutVal : integer := 0;
begin
  if (arg = "UUUUUUUUUUUUUUUU") then
    OutVal := 0;
  else
    OutVal := CONV_INTEGER(unsigned(arg));
  end if;
  if (OutVal = 0) then
    OutVal := 1;
  end if;
  return OutVal;
end;

-- -----------------------------------------------------------------------------
-- Signal declarations
-- -----------------------------------------------------------------------------
signal TxFrame        : std_logic_vector(8 downto 0); 
-- Transmit frame Register 
 
signal TxParity       : std_logic; 
-- Transmit Data Parity Bit
 
signal RxParity       : std_logic; 
-- Receive Data Parity Bit
 
signal RxData         : std_logic_vector(7 downto 0); 
-- Received Data 
 
signal NextRxData     : std_logic_vector(7 downto 0); 
-- D-input for RxData
 
signal NextDataAvl    : std_logic; 
-- D-input for DataAvl
 
signal iDataAvl       : std_logic := '0'; 
-- Internal copy of DataAvl
 
signal NextRdUpdateTx : std_logic; 
-- D-input for iRdUpdateTx
 
signal iRdUpdateTx    : std_logic := '0'; 
-- Internal Copy of RdUpdateTx
 
signal iKCLKOut       : std_logic; 
-- Internal copy of KCLKOut
 
signal iKDATAOut      : std_logic; 
-- Internal copy of KDATAOut
 
signal DelayRTS       : std_logic; 
-- Delayed version of RTS
 
signal Tdsi           : time; 
-- DSI Timing Parameter
 
signal Tkrg           : time; 
-- Tkrg Timing Parameter
 
signal iEnableOut     : std_logic; 
-- Internal EnableOut
 
signal TimeOutTr      : std_logic; 
-- Indicates the transition to Timeout State
 
signal DelayTimeOutTr : std_logic; 
-- Delayed version of DelayTimeOutTr
 
signal TimeOutStrt    : std_logic; 
-- Indicates the Start of TimeOut

-- -----------------------------------------------------------------------------
--
-- Main body of code
-- =================
--
-- -----------------------------------------------------------------------------

begin

Tdsi  <= to_integer(KmiTrDSI) * 1 ns;
Tkrg  <= to_integer(KmiTrRG) * 1 ns;

TxParity <= KmiTrTXREG(0) xor KmiTrTXREG(1) xor KmiTrTXREG(2) xor KmiTrTXREG(3)
            xor KmiTrTXREG(4) xor KmiTrTXREG(5) xor KmiTrTXREG(6) xor 
            KmiTrTXREG(7) xor not(FParErr); 

KmiTrRXREG  <= RxData;
DataAvl     <= iDataAvl;
RdUpdateTx  <= iRdUpdateTx;
EnableOut   <= iEnableOut;
TimeOutTr   <= CurrentState(0) and CurrentState(1);
TimeOutStrt <= not(DelayTimeOutTr) and TimeOutTr;

-- ---------------------------------------------------------------------------
-- Synchronized KDATAOut 
-- ---------------------------------------------------------------------------
p_KDATAOutSeq : process (REFCLK, BnRES)
begin
  if (BnRES = '0') then
    KDATAOut <= '0';
  elsif (REFCLK'event and REFCLK = '1') then
    KDATAOut <= iKDATAOut;
  end if;
end process p_KDATAOutSeq;
    
-- ---------------------------------------------------------------------------
-- Synchronized KCLKOut 
-- ---------------------------------------------------------------------------
p_KCLKOutSeq : process (REFCLK, BnRES)
begin
  if (BnRES = '0') then
    KCLKOut <= '0';
  elsif (REFCLK'event and REFCLK = '1') then
    KCLKOut <= iKCLKOut;
  end if;
end process p_KCLKOutSeq;
    
-- ---------------------------------------------------------------------------
-- Delayed version of TimeOutTr to generate pulse at TimeOut start.
-- ---------------------------------------------------------------------------
p_DelayTimeOutTrSeq : process (REFCLK, BnRES)
begin
  if (BnRES = '0') then
    DelayTimeOutTr <= '0';
  elsif (REFCLK'event and REFCLK = '1') then
    DelayTimeOutTr <= TimeOutTr;
  end if;
end process p_DelayTimeOutTrSeq;
    
-- ---------------------------------------------------------------------------
-- NextRxData is being updated at negetive edge of KCLK. At negative edge 
-- of KCLK, NextRxData will be used for shifting data into RxData.
-- ---------------------------------------------------------------------------
p_RxDataSeq : process (KCLK) 
begin
  if (KCLK = '0') then
     NextRxData <= RxData;
  end if;
end process p_RxDataSeq;    

-- ---------------------------------------------------------------------------
-- Delayed version of RTS for starting the reception. 
-- ---------------------------------------------------------------------------
p_DelayRTSSeq : process (BnRES, REFCLK)
begin
  if (BnRES = '0') then
     DelayRTS <= '0';
  elsif (REFCLK'event and REFCLK = '1') then
     DelayRTS <= RTS;
  end if;
end process p_DelayRTSSeq;

-- ---------------------------------------------------------------------------
-- Data Available Signal to Receive FIFO. Synchronization procedure has been
-- used since this is going to PCLK domain.
-- ---------------------------------------------------------------------------
p_NextDataAvlComb : process (KCLK, FeedBackRx)
begin
  if (FeedBackRx = '1') then
    iDataAvl <= '0';
  elsif (KCLK'event and KCLK = '0') then
    if ((BitCount = "1001") and (CurrentState="01")) then
      iDataAvl <= '1';
    end if;
  end if;
end process p_NextDataAvlComb; 

-- ---------------------------------------------------------------------------
-- NextRdUpdateTx signal is being generated for Reading the TX Fifo.
-- ---------------------------------------------------------------------------
p_NextRdUpdateTxComb : process (KCLK, TimeOutStrt, FeedBackTx)
begin
  if (FeedBackTx = '1') then
    iRdUpdateTx <= '0';
  elsif (KCLK'event and KCLK = '0') then
    if ((BitCount = "1010") and (CurrentState = "10")) then
      iRdUpdateTx <= '1';
    end if;
  elsif (TimeOutStrt = '1') then
    iRdUpdateTx <= '1';
  end if; 
end process p_NextRdUpdateTxComb; 
 
-- ---------------------------------------------------------------------------
-- Parity Error Check is being done here. This bit can be cleared by 
-- writing to the corresponding bit in the Status Register.
-- ---------------------------------------------------------------------------
p_ParityErrComb : process (BnRES, KCLK, WrenSTAT, PWDATAIN)
begin
  if (BnRES = '0') then
    KmiTrPARITYERR <= '0';
  elsif ((WrenSTAT and PWDATAIN(0)) = '1') then
    KmiTrPARITYERR <= '0';
  elsif (KCLK'event and KCLK = '1') then
    if (CurrentState = "01") then
      if ((BitCount = "1000") and (RxParity /= KDATAIN)) then
        KmiTrPARITYERR <= '1';
      end if;
    end if;
  end if;
end process p_ParityErrComb; 

-- ---------------------------------------------------------------------------
-- Stop Bit Test
-- ---------------------------------------------------------------------------
p_FrameErrComb : process (BnRES, CurrentState, RxParity, KDATAIn, BitCount,
                          KCLK, WrenSTAT, PWDATAIN)
begin
  if (BnRES = '0') then
    KmiTrFRAMEERR <= '0';
  elsif (CurrentState = "01") then
    if (KCLK'event and KCLK = '1') then
      if (((BitCount = "1001") and not(KDATAIn) and iKDATAOut) = '1') then
        KmiTrFRAMEERR <= '1';
      end if;
    end if;
  elsif ((WrenSTAT and PWDATAIN(1)) = '1') then
    KmiTrFRAMEERR <= '0';
  end if;
end process p_FrameErrComb;
 
-- ---------------------------------------------------------------------------
-- This process generates different signals and outputs for other modules. 
-- In this process, depending on the CurrentState various operations are 
-- performed. In case of Transmit State and Receive state, KCLKOut is being
-- generated. Data is being output in case of Transmit State. When module
-- is in receive state, KDATAIn Line is being sampled for receive data.  
-- Enable signal for different modules is also being generated here.
-- ---------------------------------------------------------------------------
p_UpdateComb : process (BitCount, KCLK, CurrentState, KDATAIn, iKCLKOut, 
                        DelayRTS)
begin
  case CurrentState is
    when "00" =>
      iKCLKOut  <= '1';
      iKDATAOut <= '1';
      iEnableOut <= '0';
      RxParity <= '1';
      RxData <= "00000000";
       
    when "01" =>
      if (((BitCount = "1010") and not(LegacyBit)) = '1') then 
        iKDATAOut <= '0';
      elsif (KCLK'event and KCLK = '0') then
        iKDATAOut <= '1';
      end if;
      if (DelayRTS = '1') then
        iKCLKOut <= '0' after Tkrg;
      elsif (KCLK'event) then
        if (BitCount <= "1001") then
          iKCLKOut <= KCLK;
        elsif (BitCount = "1010") then
          if (LegacyBit = '0') then
            iKCLKOut <= KCLK;
          else
            iKCLKOut <= '1';
          end if;
        elsif (BitCount = "1011") then
          iKCLKOut <= '1';
        end if;
      end if;
      if (DelayRTS = '1') then
        iEnableOut <= '1' after Tkrg;
      elsif (KCLK'event and KCLK = '0') then
        if (((BitCount = "1010") and LegacyBit) = '1') then 
          iEnableOut <= '0';
        elsif (((BitCount = "1011") and not(LegacyBit)) = '1') then
          iEnableOut <= '0';
        end if;
      end if;
      if (KCLK'event and KCLK = '1') then
        if (BitCount < "1000") then
          RxData <= (KDATAIn & NextRxData(7 downto 1));
          RxParity <= RxParity xor KDATAIn;
        end if;
      end if;
         
     when "10" =>
       iKCLKOut  <= KCLK after Tdsi;
       if (BitCount = "0000") then
         iKDATAOut <= '0';
         iEnableOut <= '1';
         TxFrame <= TxParity & KmiTrTXREG;
       elsif (KCLK'event and KCLK = '0') then
         if (BitCount < "1010") then
           iKDATAOut <= TxFrame(0);
           TxFrame <= ('0' & TxFrame(8 downto 1));
         elsif (BitCount = "1010") then
           iKDATAOut <= '1';
         elsif (BitCount = "1011") then
           iEnableOut <= '0';
           iKCLKOut <= '1' after Tdsi;
         end if;
      end if;

     when "11" =>
         iEnableOut <= '0'; 
     
     when others =>
       iKDATAOut <= '1';
       iKCLKOut <= '1';
   end case;
 end process p_UpdateComb;

end behavioural;

--=========================== End of KmiTrOutDrive =========================--
