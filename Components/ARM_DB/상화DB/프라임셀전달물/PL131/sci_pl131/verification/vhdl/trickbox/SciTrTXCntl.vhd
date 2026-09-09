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
--  File Name              : SciTrTXCntl.vhd.rcaS
--  File Revision          : 1.1
--
--  Release Information    : PrimeCell(TM)-PL131-REL1v0
--
--  ----------------------------------------------------------------------------
 
--  ----------------------------------------------------------------------------
--  Purpose : This module contain transmit state machine.
-- --=========================================================================--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
 
library Std_DevelopersKit;
use     std_DevelopersKit.Std_Regpak.all;
use     std_Developerskit.Std_IOpak.all;
 
--------------------------------------------------------------------------------

entity SciTXCntl is
  port (
        SCICLK           : in   std_logic; -- RFCLK input	
        PRESETn          : in   std_logic; -- Reset input
        TrTxEnSync       : in   std_logic; -- Transmitter enabled
        TrTxPEnSync      : in   std_logic; -- Transmiter parity Error enabled
        TrTXPStSync      : in   std_logic; -- Parity state 
        TrTXNAKSync      : in   std_logic; -- T0 mode 
        TrSENSE          : in   std_logic; -- Data line sense
        TrRSyTXPC        : in   std_logic_vector(3 downto 0);  -- TX retray cnt 
        TrRsyCHG         : in   std_logic_vector(7 downto 0);  -- TX CHG
        TrRsyBLKG        : in   std_logic_vector(7 downto 0);  -- TX BLKG 
        TrRSyBAUD        : in   std_logic_vector(15 downto 0); -- Baud value 
        TrRSyVALUE       : in   std_logic_vector(7 downto 0);  -- SCIVALUE 
        TrRSyJit         : in   std_logic_vector(15 downto 0); -- Jit value
        TrRsyJitPat      : in   std_logic_vector(9 downto 0);  -- Jit Patern
        TXDataAvlblSync  : in   std_logic; -- Data level of FIFO
        TXShiftData      : in   std_logic_vector(7 downto 0); -- Transmit DATA
        TXFRdPtrInc      : out  std_logic; -- TX FIFO read pointer Increment
        SCIDATAOUT       : out  std_logic; -- Serial dada out put
        SCIDATAIN        : in   std_logic; -- Serial data in put
        TXPtimError      : out  std_logic; -- Parity tim Error
        TXPtimWdError    : out  std_logic; -- Parity width Error 
        TXPError         : out  std_logic  -- Parity Error
       );
end SciTXCntl;

--------------------------------------------------------------------------------
--
--                   SciTrTXCntl
--                   =============
--
--------------------------------------------------------------------------------
--
-- Overview
-- ========
--
--  The transmit state machine shifts out transmit data according to the
--  programmed frequency. After one FRAM transmission pull the out put line   
--  HIGH and check the input line. If the receiver pull the line low with  
--  in a valid time period it will retransmit the same data again else   
--  increment the FIFO pointer and transmit the next data in the FIFO  
-------------------------------------------------------------------------------

--=============================== ARCHITECTURE ===============================--
 
 
architecture synth of SciTXCntl is
 
--------------------------------------------------------------------------------
-- Constant declarations
--------------------------------------------------------------------------------
constant ZERO : std_logic_vector(27 downto 0) := (others => '0');
 
constant ONE: std_logic_vector(27 downto 0)   :="0000000000000000000000000001";
 
-------------------------------------------------------------------------------
-- Signal declarations
-------------------------------------------------------------------------------

signal SciTXCntlSt       : std_logic_vector(2 downto 0);
signal NextSciTXCntlSt   : std_logic_vector(2 downto 0);
-- Transmit State Register

signal iTXFRdPtrInc      : std_logic;
signal NextTXFRdPtrInc   : std_logic;
-- Transmit FIFO read pointer Increment

signal iSCIDATAOUT       : std_logic;
signal NextSCIDATAOUT    : std_logic;
-- Serial out put data line

signal BitCount          : std_logic_vector(2 downto 0);
signal NextBitCount      : std_logic_vector(2 downto 0);
-- Bit count. Determine the FRAM width

signal TXShiftReg        : std_logic_vector(6 downto 0);
signal NextTXShiftReg    : std_logic_vector(6 downto 0);
-- Transmit shift register

signal TXPCnt            : std_logic_vector(3 downto 0);
signal NextTXPCnt        : std_logic_vector(3 downto 0);
-- Transmit retray counter

signal TXCHGCnt          : std_logic_vector(7 downto 0);
signal NextTXCHGCnt      : std_logic_vector(7 downto 0);
-- Charactor Guard register 

signal TXBLKGCnt         : std_logic_vector(7 downto 0);
signal NextTXBLKGCnt     : std_logic_vector(7 downto 0);
-- Block Guard register 

signal BitJitCnt         : std_logic_vector(27 downto 0);
signal NextBitJitCnt     : std_logic_vector(27 downto 0);
-- Bit period register
 
signal JitPat            : std_logic_vector(9 downto 0);
signal NextJitPat        : std_logic_vector(9 downto 0);
-- Jitter value register

signal JitCorrCnt        : std_logic_vector(3 downto 0);
signal NextJitCorrCnt    : std_logic_vector(3 downto 0);
-- Jitter correction register

signal iTXPtimError      : std_logic; 
signal NextTXPtimError   : std_logic; 
-- TX parity time error ( retransission hand shaking asserter at wrong time)

signal iTXPtimWdError    : std_logic; 
signal NextTXPtimWError : std_logic; 
-- TX parity time width error

signal iTXPError         : std_logic; 
signal NextTXPError      : std_logic; 
-- TX parity error

signal ParityBit         : std_logic; 
signal NextParityBit     : std_logic;
--  parity bit
    
-- Comparators
signal BitCountComp      : std_logic;
signal BitCountHalf      : std_logic;
signal BitJitCmp         : std_logic;
signal TXCHGCountCmp     : std_logic;
signal TXBLKGCountCmp    : std_logic;
signal TrTXFError        : std_logic;

signal JitEn             : std_logic;
-- Jitter enable   

signal JitDir            : std_logic;
-- Jitter direction
   
signal BitJitRvalue      : std_logic_vector(27 downto 0);
-- Bit width in RFCLK value
 
signal JitCorrVALUE      : std_logic_vector(27 downto 0);
-- Jitter correction value 

signal TrRSyBAUDMul      : std_logic_vector(27 downto 0);
--  Baud value

signal TrRSyJitMul       : std_logic_vector(27 downto 0);
-- Jitter value 
   
--------------------------------------------------------------------------------
--
-- Main body of  code
-- ==================
--
-------------------------------------------------------------------------------
    
begin

--------------------------------------------------------------------------------
-- Assign local copy to the output signal
-------------------------------------------------------------------------------
SCIDATAOUT       <=  iSCIDATAOUT;
TXFRdPtrInc      <=  iTXFRdPtrInc;
TXPtimError      <=  iTXPtimError; 
TXPtimWdError    <=  iTXPtimWdError; 
TXPError         <=  iTXPError; 

-------------------------------------------------------------------------------
-- Expansion of comparators...
-------------------------------------------------------------------------------
BitCountComp   <= '1' when BitCount(2 downto 0) = "000" else '0';
BitCountHalf   <= '1' when BitCount(2 downto 0) = "100" else '0';
TXCHGCountCmp  <= '1' when TXCHGCnt(7 downto 0) = "00000001"  else '0';
TXBLKGCountCmp <= '1' when TXBLKGCnt(7 downto 0) = "00000001"  else '0';
TrTXFError     <= '1' when ((TXPCnt >= "0001") and (TrTXPEnSync ='1')) else '0';
BitJitCmp      <= '1' when BitJitCnt(27 downto 0) = ONE else '0';
JitEn          <= JitPat(0);
JitDir         <= JitPat(9);

-------------------------------------------------------------------------------
-- State transition process
-------------------------------------------------------------------------------
p_TranSeq : process(SCICLK, PRESETn) 
begin
  if (PRESETn = '0') then
    SciTXCntlSt      <= "000";
    iSCIDATAOUT      <= '1';
    iTXFRdPtrInc     <= '0';
    iTXPtimError     <= '0'; 
    iTXPtimWdError   <= '0';
    iTXPError        <= '0';
    BitCount         <= "000";
    BitJitCnt        <= ZERO;
    JitPat           <= "0000000000";
    JitCorrCnt       <= "0000";
    TXPCnt           <= "0000";
    TXCHGCnt         <= "00000000";
    TXBLKGCnt        <= "00000000";
    TXShiftReg       <= "0000000";
    ParityBit        <= '0';
  elsif (SCICLK'event and SCICLK = '1') then
    SciTXCntlSt      <= NextSciTXCntlSt;
    iTXFRdPtrInc     <= NextTXFRdPtrInc;
    iSCIDATAOUT      <= NextSCIDATAOUT;
    iTXPtimError     <= NextTXPtimError; 
    iTXPtimWdError   <= NextTXPtimWError; 
    iTXPError        <= NextTXPError;
    BitCount         <= NextBitCount;
    BitJitCnt        <= NextBitJitCnt;
    JitPat           <= NextJitPat;
    JitCorrCnt       <= NextJitCorrCnt;
    TXPCnt           <= NextTXPCnt;
    TXCHGCnt         <= NextTXCHGCnt;
    TXBLKGCnt        <= NextTXBLKGCnt;
    TXShiftReg       <= NextTXShiftReg;
    ParityBit        <= NextParityBit;
  end if;
end process p_TranSeq;

-------------------------------------------------------------------------------
-- Output and next state logic generation
-------------------------------------------------------------------------------
p_TranCombo : process(SciTXCntlSt, iSCIDATAOUT, SCIDATAIN, BitCount, BitJitCnt,
                      TXPCnt, TXCHGCnt, TXBLKGCnt,TXShiftReg, TXDataAvlblSync,
                      TrTXEnSync, TrRsyBLKG,TXBLKGCountCmp,BitJitCmp,
                      BitCountComp,BitCountHalf,TrRsyCHG, TXCHGCountCmp,
                      ParityBit,iTXFRdPtrInc,iTXPtimError,iTXPtimWdError,
                      JitPat, JitCorrCnt)
begin
-- Default assignments
NextSciTXCntlSt   <= SciTXCntlSt;
NextTXFRdPtrInc   <= iTXFRdPtrInc;
NextTXPtimError   <= '0'; 
NextTXPtimWError <= '0'; 
NextSCIDATAOUT    <= iSCIDATAOUT;
NextBitCount      <= BitCount;
NextBitJitCnt     <= BitJitCnt;
NextJitPat        <= JitPat;
NextJitCorrCnt    <= JitCorrCnt;
NextTXPCnt        <= TXPCnt;
NextTXCHGCnt      <= TXCHGCnt;
NextTXBLKGCnt     <= TXBLKGCnt;
NextTXShiftReg    <= TXShiftReg;
NextParityBit     <= ParityBit;

  case SciTXCntlSt is

    -- RESET state 
    when "000" =>
    
      -- Transmiter enabled and data available in the FIFO. 
      -- Go to START bit state  
      if (((TXDataAvlblSync) and (TrTXEnSync)) ='1') then
        NextSCIDATAOUT    <= '1';
        NextBitJitCnt     <= BitJitRvalue;
        NextJitPat        <= TrRSyJitPat;
        NextSciTXCntlSt   <= "001";
        NextJitCorrCnt    <= "0000";
        NextTXBLKGCnt     <= TrRsyBLKG;
        NextTXPCnt        <= TrRSyTXPC;
      else
        NextSCIDATAOUT    <= '1';
        NextBitJitCnt     <= ZERO;
        NextSciTXCntlSt   <= "000";
      end if;

    -- BLKGUARD state 
    when "001" =>

      -- Transmitter is disabled. Go to RESET state 
      if (TrTXEnSync = '0') then  
        NextSCIDATAOUT    <= '1';
        NextBitJitCnt     <= ZERO;
        NextSciTXCntlSt   <= "000";
        NextTXBLKGCnt     <= "00000000";
      -- Transmit Guard time completed. Go to START BIT state
      elsif ((((BitJitCmp) and (TXBLKGCountCmp)) or
               (TrRSyBLKG = "00000000")) ='1') then
        NextSCIDATAOUT    <= '0';
        NextBitJitCnt     <= BitJitRvalue;
        NextBitCount      <= "111";
        NextSciTXCntlSt   <= "011";
        NextTXBLKGCnt     <= "00000000";
        NextJitPat <= JitPat(9) & '0' & JitPat(8 downto 1);
        -- Jitter enabled. Increment the Jitter correction counter. If JitDir
        -- signal is high add the jitter value else subtract the jitter 
        -- value     
        if (JitEn = '1') then
          NextJitCorrCnt  <= JitCorrCnt + 1;
          if (JitDir ='1') then
            NextBitJitCnt <= BitJitRvalue + TrRSyJit;
          else
            NextBitJitCnt <= BitJitRvalue - TrRSyJit;
          end if;
        -- jitter is not enabled
        else
          NextBitJitCnt   <= BitJitRvalue;
        end if;
      -- Bit preiod over. Reload the BitPeriod counter
      elsif (BitJitCmp ='1') then
        NextSCIDATAOUT    <= '1';
        NextBitJitCnt     <= BitJitRvalue;
        NextTXBLKGCnt     <= TXBLKGCnt -1;
        NextSciTXCntlSt   <= "001";
      else
        NextSCIDATAOUT    <= '1';
        NextBitJitCnt     <= BitJitCnt -1;
        NextSciTXCntlSt   <= "001";
      end if;

 
    -- START bit state 
    when "011" =>

      -- Transmitter is disabled. Go to RESET state 
      if (TrTXEnSync = '0') then
        NextSCIDATAOUT    <= '1';
        NextBitJitCnt     <= ZERO;
        NextSciTXCntlSt   <= "000";
      -- Transmit FIFO becomes empty. Go to RESET state 
      elsif (TXDataAvlblSync = '0') then
        NextSCIDATAOUT    <= '1';
        NextBitJitCnt     <= ZERO;
        NextSciTXCntlSt   <= "000";
        NextTXCHGCnt <= "00000000";
      -- Start bit transmission completed. Go to DATA TRANSMIT state
      elsif (BitJitCmp = '1') then
        NextParityBit     <= ((TXShiftData(0)) xor (TXShiftData(1)) xor
                              (TXShiftData(2)) xor (TXShiftData(3)) xor
                              (TXShiftData(4)) xor (TXShiftData(5)) xor
                              (TXShiftData(6)) xor (TXShiftData(7)) xor
                              (TrTXPStSync) xor (TrTXFError) xor
                              (TrSENSE));  
        NextSCIDATAOUT    <= TXShiftData(0);
        NextBitCount      <= "111";
        NextTXShiftReg(6 downto 0) <= TXShiftData(7 downto 1);
        NextSciTXCntlSt   <= "010";
        NextJitPat        <= JitPat(9) & '0' & JitPat(8 downto 1);
        -- Jitter enabled. Increment the Jitter correction counter. If JitDir
        -- signal is high add the jitter value else subtract the jitter 
        -- value     
        if (JitEn = '1') then
          NextJitCorrCnt  <= JitCorrCnt + 1;
          if (JitDir ='1') then
            NextBitJitCnt <= BitJitRvalue + TrRSyJit;
          else
            NextBitJitCnt <= BitJitRvalue - TrRSyJit;
          end if;
        -- jitter is not enabled
        else
           NextBitJitCnt  <= BitJitRvalue;
        end if;
      else 
        NextBitJitCnt     <= BitJitCnt -1;
        NextSciTXCntlSt   <= "011";
      end if;
   

    -- DATA TRANSMIT state
    when "010" =>

      -- Transmitter is disabled. Go to RESET state 
      if (TrTXEnSync = '0') then
        NextSCIDATAOUT    <= '1';
        NextBitJitCnt     <= ZERO;
        NextBitCount      <= "000";
        NextSciTXCntlSt   <= "000";
     -- All data bits transmitted. Go to PARITY BIT state.
      elsif (((BitJitCmp) and (BitCountComp)) = '1') then
        NextSCIDATAOUT    <= ParityBit;
        NextSciTXCntlSt   <= "110";
        NextJitPat        <= JitPat(9) & '0' & JitPat(8 downto 1);
        -- Jitter enabled. Increment the Jitter correction counter. If JitDir
        -- signal is high add the jitter value else subtract the jitter
        -- value    
        if (JitEn = '1') then
          NextJitCorrCnt  <= JitCorrCnt + 1;
          if (JitDir ='1') then
            NextBitJitCnt <= BitJitRvalue + TrRSyJit;
          else
            NextBitJitCnt <= BitJitRvalue - TrRSyJit;
          end if;
        -- jitter is not enabled
        else
          NextBitJitCnt   <= BitJitRvalue;
        end if;
      --  At the end of a bit period, shift in the next bit and reload the
      --  BitJitCnt counter
      elsif (BitJitCmp = '1') then
        NextSCIDATAOUT             <= TXShiftReg(0);
        NextBitCount               <= BitCount -1;
        NextTXShiftReg(5 downto 0) <= TXShiftReg(6 downto 1); 
        NextTXShiftReg(6)          <= '0'; 
        NextSciTXCntlSt            <= "010";
        NextJitPat                 <= JitPat(9) & '0' & JitPat(8 downto 1);
        -- Jitter enabled. Increment the Jitter correction counter. If JitDir
        -- signal is high add the jitter value else subtract the jitter
        -- value    
        if (JitEn = '1') then
          NextJitCorrCnt  <= JitCorrCnt + 1;
          if(JitDir ='1') then
            NextBitJitCnt <= BitJitRvalue + TrRSyJit;
          else
            NextBitJitCnt <= BitJitRvalue - TrRSyJit;
          end if;
        else
          -- jitter is not enabled
          NextBitJitCnt   <= BitJitRvalue;
        end if;
      else 
        NextBitJitCnt     <= BitJitCnt -1;
        NextSciTXCntlSt   <= "010";
      end if;
       

    -- PARITY BIT state.
    when "110" =>


      -- Transmitter is disabled. Go to RESET state 
      if (TrTXEnSync = '0') then
        NextSCIDATAOUT        <= '1';
        NextBitJitCnt         <= ZERO;
        NextSciTXCntlSt       <= "000";
      -- Parity bit transmission completed. Go to TRANSMIT GUARD state
      elsif (BitJitCmp = '1') then
        NextSCIDATAOUT        <= '1';
        NextSciTXCntlSt       <= "111";
        NextJitPat            <= TrRSyJitPat;
        NextJitCorrCnt        <= "0000";
        -- Make the FRAM width constant by giving the inverse jitter
        -- in transmit charactor guard time  
        if (JitDir = '1') then
          NextBitJitCnt       <= BitJitRvalue  - JitCorrVALUE;
        else 
          NextBitJitCnt       <= BitJitRvalue  + JitCorrVALUE;
        end if;
        -- T0 mode
        if (TrTXNAKSync ='1') then
          NextTXCHGCnt        <= TrRsyCHG +2; 
          NextTXBLKGCnt       <= "00000010";
        -- T1 mode
        else
          NextTXCHGCnt        <= TrRsyCHG +1; 
          NextTXFRdPtrInc     <= not(iTXFRdPtrInc); 
          NextTXBLKGCnt       <= "00000010";
        end if;
      else 
        NextBitJitCnt         <= BitJitCnt -1;
        NextSciTXCntlSt       <= "110";
      end if;


    -- TRANSMIT GUARD state
    when "111" =>

      -- Transmitter is disabled. Go to RESET state 
      if (TrTXEnSync = '0') then
        NextSCIDATAOUT        <= '1';
        NextBitJitCnt         <= ZERO;
        NextSciTXCntlSt       <= "000";
        NextTXCHGCnt <= "00000000";
      -- Charactor Guard time over. 
      elsif (((BitJitCmp) and (TXCHGCountCmp)) = '1') then
        -- Transmiter FIFO empty. Go to RESET state
        if (TXDataAvlblSync = '0') then
          NextSCIDATAOUT      <= '1';
          NextBitJitCnt       <= ZERO;
          NextSciTXCntlSt     <= "000";
          NextTXCHGCnt        <= "00000000";
        -- Transmiter FIFO not empty. Go to START BIT state
        else
          NextSCIDATAOUT      <= '0';
          NextBitJitCnt       <= BitJitRvalue;
          NextSciTXCntlSt     <= "011";
          NextTXPCnt          <= TrRSyTXPC;
          NextJitPat          <= JitPat(9) & '0' & JitPat(8 downto 1);
          -- Jitter enabled. Increment the Jitter correction counter. If JitDir
          -- signal is high add the jitter value else subtract the jitter
          -- value
          if (JitEn = '1') then
            NextJitCorrCnt    <= JitCorrCnt + 1;
            if (JitDir ='1') then
              NextBitJitCnt   <= BitJitRvalue + TrRSyJit;
            else
              NextBitJitCnt   <= BitJitRvalue - TrRSyJit;
            end if;
          else
            NextBitJitCnt     <= BitJitRvalue;
          end if;
        end if;
      -- Parity Error detected. Go to PARITY_WIDTH state. SCIDATIN should
      -- remain low for 2 etu time 
      elsif (SCIDATAIN ='0') then
        -- Parity error asserted with in the valid time period  
        if ((BitJitCnt <= ((BitJitRvalue/2) + (TrRSyBAUD +3))) and
            (BitJitCnt >= ((BitJitRvalue/2) - (TrRSyBAUD +1)))) then
          NextBitJitCnt       <= BitJitRvalue + TrRSyBAUD;
          NextSciTXCntlSt     <= "101";
          NextTXBLKGCnt       <= "00000010";
        else
          NextBitJitCnt       <= BitJitRvalue + TrRSyBAUD;
          NextSciTXCntlSt     <= "101";
          NextTXPtimError     <= '1'; 
          NextTXBLKGCnt       <= "00000010";
        end if;
      -- Bit Period over. Reload the Bitperiod counter  
      elsif (BitJitCmp ='1' ) then
        -- Increment the transmit FIFO.  
        if ((TrTXNAKSync ='1') and (TXCHGCnt = "00000010" )) then
          NextBitJitCnt       <= BitJitRvalue;
          NextSciTXCntlSt     <= "111";
          NextTXCHGCnt        <= TXCHGCnt -1;
          NextTXBLKGCnt       <= TXBLKGCnt -1;
          NextTXFRdPtrInc     <= not(iTXFRdPtrInc); 
        else
          NextBitJitCnt       <= BitJitRvalue;
          NextSciTXCntlSt     <= "111";
          NextTXCHGCnt        <= TXCHGCnt -1;
          NextTXBLKGCnt       <= TXBLKGCnt -1;
        end if;
      else
        NextBitJitCnt         <= BitJitCnt -1;
        NextSciTXCntlSt       <= "111";
      end if;


    -- PARITY_WIDTH state    
    when "101" =>

      -- Transmitter is disabled. Go to RESET state 
      if (TrTXEnSync = '0') then
        NextSCIDATAOUT     <= '1';
        NextBitJitCnt      <= ZERO;
        NextSciTXCntlSt    <= "000";
        NextTXCHGCnt       <= "00000000";
      -- Width 2 etu over. If SCIDATAIN still remain low Go to RESET state.
      -- Otherwise dataclash may happen.      
      elsif (((BitJitCmp) and (TXBLKGCountCmp)) = '1') then
        NextBitJitCnt      <= BitJitRvalue - TrRSyBAUD;
        NextSciTXCntlSt    <= "100";
        NextTXCHGCnt       <= TrRsyCHG; 
        NextTXBLKGCnt      <= "00000000";
        NextTXPtimWError   <= '1';
      -- SCIDATAIN become high with in the valid time period.  
      elsif (SCIDATAIN ='1') then
        if ((TXBLKGCnt = "00000001") and
            (BitJitCnt <= (2 * (TrRSyBAUD+1) + 2))) then
          NextBitJitCnt    <= BitJitRvalue;
          NextSciTXCntlSt  <= "100";
          NextTXCHGCnt     <= TrRsyCHG +2; 
          NextTXBLKGCnt    <= "00000000";
        else 
          NextBitJitCnt     <= BitJitRvalue;
          NextSciTXCntlSt   <= "100";
          NextTXCHGCnt      <= TrRsyCHG +2; 
          NextTXBLKGCnt     <= "00000000";
          NextTXPtimWError  <= '1';
        end if;
      elsif (BitJitCmp ='1') then
        NextBitJitCnt   <= BitJitRvalue;
        NextTXBLKGCnt   <= TXBLKGCnt -1;
        NextSciTXCntlSt <= "101";
      else
        NextBitJitCnt   <= BitJitCnt -1;
        NextSciTXCntlSt <= "101";
      end if;


    -- RE_TRANSMIT state 
    when "100" =>

      -- Transmitter is disabled. Go to RESET state 
      if(TrTXEnSync = '0') then
        NextSCIDATAOUT     <= '1';
        NextBitJitCnt      <= ZERO;
        NextSciTXCntlSt    <= "000";
        NextTXCHGCnt       <= "00000000";
      -- In 2 etu time over.    
      elsif (((BitJitCmp) and (TXCHGCountCmp)) = '1') then
        -- Transmit FIFO become empty. Go to RESET state 
        if (TXDataAvlblSync = '0') then
          NextSCIDATAOUT   <= '1';
          NextBitJitCnt    <= ZERO;
          NextSciTXCntlSt  <= "000";
          NextTXCHGCnt     <= "00000000";
        -- Transmit FIFO not empty. Go to START BIT state 
        else 
          NextSCIDATAOUT   <= '0';
          NextBitJitCnt    <= BitJitRvalue;
          NextSciTXCntlSt  <= "011";
          NextTXCHGCnt     <= "00000000";
          NextTXBLKGCnt    <= "00000000";
          NextTXPCnt       <= TXPCnt -1;
          NextJitPat       <= JitPat(9) & '0' & JitPat(8 downto 1);
          -- Jitter enabled. Increment the Jitter correction counter. If JitDir
          -- signal is high add the jitter value else subtract the jitter
          -- value
          if (JitEn = '1') then
            NextJitCorrCnt  <= JitCorrCnt + 1;
            if (JitDir ='1') then
              NextBitJitCnt <= BitJitRvalue + TrRSyJit;
            else
              NextBitJitCnt <= BitJitRvalue - TrRSyJit;
            end if;
          else
             NextBitJitCnt  <= BitJitRvalue;
          end if;
        end if;
      elsif (BitJitCmp  ='1') then
        NextBitJitCnt   <= BitJitRvalue;
        NextTXCHGCnt    <= TXCHGCnt -1;
        NextSciTXCntlSt <= "100";
      else 
        NextBitJitCnt   <= BitJitCnt -1;
        NextSciTXCntlSt <= "100";
      end if;
         
    when others =>
      NextSciTXCntlSt <= "000";
  end case;
end process p_TranCombo;

-------------------------------------------------------------------------------
-- Transmit Error enable. It is used for sending wrong parity and check  
-- whether the receiver ask for retransmission 
-------------------------------------------------------------------------------
p_TXPRErrorComb : process(SciTXCntlSt)
begin
  if ((SciTXCntlSt ="101") and (TrTXFError = '0')) then
    NextTXPError <= '1';
  else 
    NextTXPError <= '0';
  end if;
end process p_TXPRErrorComb;  

-------------------------------------------------------------------------------
-- Calculating the Bit period time from Baud and SCIVALUE
-------------------------------------------------------------------------------
TrRSyBAUDMul    <= "000000000000" & TrRSyBAUD; 
TrRSyJitMul     <= "000000000000" & TrRSyJit; 

BitJitRvalue    <=  (TrRSyBAUDMul + 1) * TrRSyVALUE;
JitCorrVALUE    <= JitCorrCnt * TrRSyJitMul when SciTXCntlSt = "110"
                else 
                   (others => '0');

end synth;

--  Signals: SciTXCntlSt<3:0> SciTXCntlNextSt<3:0> 
--    ST_IDLE	000
--    ST_BLKGUARD 001
--    ST_STARTBIT 011
--    ST_TRDATA 010
--    ST_PARITY 110
--    ST_CHGUARD 111
--    ST_WIDTH 101
--    ST_RETRANSMIT 100
--=============================== End =======================================--
