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
--  File Name              : SciTrRXCntl.vhd.rcaS
--  File Revision          : 1.1
--
--  Release Information    : PrimeCell(TM)-PL131-REL1v0
--
--  ----------------------------------------------------------------------------
 
--  ----------------------------------------------------------------------------
--  Purpose : This block performs reception of serial data
--               and performs parity check 
-- --=========================================================================--
  
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

library Std_DevelopersKit;
use     std_DevelopersKit.Std_Regpak.all;
use     std_Developerskit.Std_IOpak.all;
 
--  ----------------------------------------------------------------------------

entity SciTrRXCntl is
  port (
        SCICLK           : in std_logic;  -- Main SCI Clock
        PRESETn          : in std_logic;  -- Reset input
        TrRXEnSync       : in std_logic;  -- SCI Trickbox Receiver Enable
        TrRXPEnSync      : in std_logic;
                                -- SCI Trickbox Receiver Parity Error Enable
        TrRXPStSync      : in std_logic;  -- Receiver Parity State 
        TrRsyRXPC        : in std_logic_vector(3 downto 0); -- Parity Counter
        TrRsyCHG         : in std_logic_vector(7 downto 0); 
                                          -- Character Time counter  
        TrRsyBLKG        : in std_logic_vector(7 downto 0); 
                                          -- Block Time Counter
        SCIDATAIN        : in std_logic;  -- Receive Serial input
        SCIDATAOUT       : out std_logic; -- Receive serial output
        TrRXNAKSync      : in std_logic;  
                                     -- Enables character transmit handshaking 
        TrSENSE          : in  std_logic; -- Data line SENSE
        TrRSyBaud        : in std_logic_vector(15 downto 0); -- Baud value
        TrRSyValue       : in std_logic_vector(7 downto 0);  -- SCIVLUE    
        RXPError         : out std_logic; -- Receive parity error
        RXCtimError      : out std_logic; -- Receive character time erroe 
        RXBtimError      : out std_logic; -- Receive block time error 
        StartBitError    : out std_logic; -- Start bit time error 
        RXShiftData      : out std_logic_vector(8 downto 0); -- Received Data 
        RXFWr            : out std_logic  -- Receive FIFO Write 
       );
end SciTrRXCntl;


--------------------------------------------------------------------------------
--
--                   SciTrRXCntl
--                   =============
--
--------------------------------------------------------------------------------
--
-- Overview
-- ========
--
--  This block performs shifting-in of the serial bit stream and store the
--  received data in a register and perform parity error check on the received 
--  data.  Also if parity error bit is enabled this block will simulate the 
--  receive  parity Error condition and ask retransmission.
-- 
--------------------------------------------------------------------------------

--=============================== ARCHITECTURE ===============================--


architecture synth of SciTrRXCntl is

--------------------------------------------------------------------------------
-- Constant declarations
--------------------------------------------------------------------------------
constant ZERO : std_logic_vector(27 downto 0) := (others => '0');
 
constant ONE: std_logic_vector(27 downto 0)   :="0000000000000000000000000001";
 
--------------------------------------------------------------------------------
-- Signal declarations
--------------------------------------------------------------------------------
 
signal SciRXCntlSt       : std_logic_vector(2 downto 0);
signal NextSciRXCntlSt   : std_logic_vector(2 downto 0);
-- Receive State Register 

signal iRXFWr            : std_logic;
signal NextRXFWr         : std_logic;
-- Receive FIFO Write

signal RXPCnt            : std_logic_vector(3 downto 0);
signal NextRXPCnt        : std_logic_vector(3 downto 0);
-- Receive Parity Error Generate counter  

signal RXCHGCnt          : std_logic_vector(8 downto 0);
signal NextRXCHGCnt      : std_logic_vector(8 downto 0);
-- Character Guard time counter 
 
signal RXBLKGCnt         : std_logic_vector(8 downto 0);
signal NextRXBLKGCnt     : std_logic_vector(8 downto 0);
-- Block Guard time counter 
 
signal iRXShiftReg       : std_logic_vector(8 downto 0);
signal NextRXShiftReg    : std_logic_vector(8 downto 0);
-- Receive Shift Register 
 
signal iRXPError         : std_logic;
signal NextRXPError      : std_logic;
-- Receive parity Error  
 
signal iRXCtimError      : std_logic;
signal NextRXCtimError   : std_logic;
-- Receive Character time Error  
 
signal iRXBtimError      : std_logic;
signal NextRXBtimError   : std_logic;
-- Receive Block time Error  
 
signal iStartBitError    : std_logic;
signal NextStBitError : std_logic;
-- Receive Block time Error  
 
signal iSCIDATAOUT       : std_logic;
signal NextSCIDATAOUT    : std_logic;
-- Serial output signal   

signal BitPeriodCnt      : std_logic_vector(27 downto 0);
signal NextBitPeriodCnt  : std_logic_vector(27 downto 0);
-- Counter that is used to generate the Baud10 signal

signal BitCnt            : std_logic_vector(3 downto 0);
signal NextBitCnt        : std_logic_vector(3 downto 0);
-- Counter that is used to generate data frame over condition 

signal Delay             : std_logic;
signal NextDelay         : std_logic;
-- Used to produce one etu delay

  
-- Comparators
signal BitPeriodCmp : std_logic;
signal BitCmp : std_logic;
signal TrRXFError : std_logic;
signal BitPeriodRvalue : std_logic_vector(27 downto 0);
signal TrRSyBAUDMul : std_logic_vector(27 downto 0);

--------------------------------------------------------------------------------
--
-- Main boday of  code
-- ===================
--
--------------------------------------------------------------------------------
    
begin

--------------------------------------------------------------------------------
-- Assign local copy to the output signal
-------------------------------------------------------------------------------

RXPError      <= iRXPError;
RXCtimError   <= iRXCtimError;
RXBtimError   <= iRXBtimError;
StartBitError <= iStartBitError;
RXShiftData   <= iRXShiftReg;
SCIDATAOUT    <= iSCIDATAOUT;
RXFWr         <= iRXFWr;

-------------------------------------------------------------------------------
-- Expansion of comparators...
-------------------------------------------------------------------------------

BitPeriodCmp <= '1' when BitPeriodCnt(27 downto 0) = ONE else '0';
BitCmp       <= '1' when BitCnt(3 downto 0) = "0000" else '0';
TrRXFError   <= '1' when ((RXPCnt >= "0001") and (TrRXPEnSync ='1')) else '0';

-------------------------------------------------------------------------------
-- State transition process
-------------------------------------------------------------------------------
p_ReceSeq : process(SCICLK, PRESETn) 
begin
  if (PRESETn = '0') then
    SciRXCntlSt      <= "000";
    iRXFWr           <= '0';
    BitPeriodCnt     <= ZERO;
    BitCnt           <= "0000";
    RXCHGCnt         <= "000000000";
    RXBLKGCnt        <= "000000000";
    iRXShiftReg      <=  "000000000";
    RXPCnt           <= "0000";
    iRXPError        <= '0';
    iRXCtimError     <= '0';
    iRXBtimError     <= '0';
    iStartBitError   <= '0';
    iSCIDATAOUT      <= '1';
    Delay            <= '0';
  elsif (SCICLK'event and SCICLK = '1') then
    SciRXCntlSt      <= NextSciRXCntlSt;
    iRXFWr           <= NextRXFWr;
    BitPeriodCnt     <= NextBitPeriodCnt;
    BitCnt           <= NextBitCnt;
    RXCHGCnt         <= NextRXCHGCnt;
    RXBLKGCnt        <= NextRXBLKGCnt;
    iRXShiftReg      <= NextRXShiftReg;
    RXPCnt           <= NextRXPCnt;
    iRXPError        <= NextRXPError;
    iRXCtimError     <= NextRXCtimError;
    iRXBtimError     <= NextRXBtimError;
    iStartBitError   <= NextStBitError;
    iSCIDATAOUT      <= NextSCIDATAOUT;
    Delay            <= NextDelay;
  end if;
end process p_ReceSeq;

-- Output and next state logic generation
p_ReceComb : process (SciRXCntlSt, BitPeriodCnt, BitCnt, BitPeriodCmp, BitCmp, 
                      iRXCtimError,iRXBtimError,SCIDATAIN, iSCIDATAOUT,iRXFWr, 
                      RXCHGCnt, RXBLKGCnt,RXPCnt,TrRXEnSync,TrRXNAKSync,
                      iRXShiftReg,TrRsyCHG, TrRsyBLKG,TrRsyRXPC,iStartBitError,
                      TrRXFError,Delay,iRXPError)

begin
-- Default assignments
NextSciRXCntlSt   <= SciRXCntlSt;
NextBitPeriodCnt  <= BitPeriodCnt;
NextBitCnt        <= BitCnt;
NextRXCHGCnt      <= RXCHGCnt;
NextRXBLKGCnt     <= RXBLKGCnt;
NextRXPCnt        <= RXPCnt;
NextRXCtimError   <= '0';
NextRXBtimError   <= '0';
NextStBitError    <= '0';
NextRXPError      <= '0'; 
NextRXFWr         <= iRXFWr;
NextSCIDATAOUT    <= iSCIDATAOUT;
NextRXShiftReg    <=  iRXShiftReg;
NextDelay         <= Delay;

  case SciRXCntlSt is

    -- RESET state
    when "000" =>
     --  Receiver not enabled 
      if (TrRXEnSync ='0') then
        NextSciRXCntlSt     <= "000";
        NextBitPeriodCnt    <= ZERO;

      -- Receiver is enabled and SCIDATAIN is high
      elsif (SCIDATAIN = '1') then
        NextBitPeriodCnt    <= BitPeriodRvalue + TrRSyBaud;
        NextRXBLKGCnt       <= ('0' & TrRsyBLKG);
        NextSciRXCntlSt     <= "001";

      -- SCIDATAIN low detected 
      elsif (SCIDATAIN ='0') then
        if (TrRsyBLKG = "00000000") then
          NextBitPeriodCnt  <= BitPeriodRvalue/2 + TrRSyBaud + 1;
          NextSciRXCntlSt   <= "011";
        else
          NextRXBtimError   <= '1';
          NextBitPeriodCnt  <= BitPeriodRvalue/2 + TrRSyBaud + 1;
          NextSciRXCntlSt   <= "011";
        end if;
      end if;


    -- BLKG time State
    when "001" =>
      if (TrRXEnSync ='0') then
        NextSciRXCntlSt     <= "000";
        NextBitPeriodCnt    <= ZERO;
        NextRXBLKGCnt       <= "000000000";
      -- Star bit detected
      elsif (SCIDATAIN ='0') then
        if ((BitPeriodCnt <= 2 * TrRSyBaud) and (RXBLKGCnt ="000000001"))  then
          NextSciRXCntlSt   <= "011";
          NextBitPeriodCnt  <= BitPeriodRvalue/2 + TrRSyBaud + 1;
          NextRXBLKGCnt     <= "000000000";
        -- Start bit detected before the block time completion
        else
          NextSciRXCntlSt   <= "011";
          NextBitPeriodCnt  <= BitPeriodRvalue/2 + TrRSyBaud + 1;
          NextRXBtimError   <= '1';
          NextRXBLKGCnt     <= "000000000";
        end if;
      -- RX block Guard time over. Back to idle state 
      elsif ((BitPeriodCmp ='1') and (RXBLKGCnt ="000000001")) then
        NextSciRXCntlSt     <= "000";
        NextBitPeriodCnt    <= ZERO;
        NextRXBLKGCnt       <= "000000000";
      -- Bit period over. Reload the counter  
      elsif (BitPeriodCmp ='1') then
        NextRXBLKGCnt       <= RXBLKGCnt -1;
        NextBitPeriodCnt    <= BitPeriodRvalue;
        NextSciRXCntlSt     <= "001";
      else
        NextSciRXCntlSt     <= "001";
        NextBitPeriodCnt    <= BitPeriodCnt -1;   
      end if;

    -- If at any time the SCIDATAIN line goes HIGH, invalidate  the
    -- start bit .
    when "011" =>
      -- Trick box disabled. Back to reset  state 
      if (TrRXEnSync ='0') then
        NextSciRXCntlSt     <= "000";
        NextBitPeriodCnt    <= ZERO;
      --Invalid start bit detected. Back to reset state
      elsif (BitPeriodCmp = '1') then
        NextSciRXCntlSt     <= "000";
        NextBitPeriodCnt    <= ZERO;
        NextBitCnt          <= "0000";
        NextRXShiftReg      <= "000000000";
        NextStBitError   <= '1';
      --Invalid start bit detected. Back to reset state
      elsif (SCIDATAIN = '1') then
        NextSciRXCntlSt     <= "000";
        NextBitPeriodCnt    <= ZERO;
        NextBitCnt          <= "0000";
        NextRXShiftReg      <=  "000000000";
        NextStBitError   <= '1';
      elsif (SCIDATAIN = '0') then
       --Valid start bit detected. Go to Receive state
       if ((BitPeriodCnt    <= 2 * (TrRSyBaud )) = '1') then 
          NextSciRXCntlSt   <= "010";
          NextRXShiftReg    <=  "000000000";
          NextBitPeriodCnt  <= BitPeriodRvalue;
          NextBitCnt        <= "1000";
          NextRXPCnt        <= TrRsyRXPC;
        else 
          NextSciRXCntlSt   <= "011";
          NextBitPeriodCnt  <= BitPeriodCnt -1;
        end if;  
      end if;

    -- Receive State  
    when "010" =>
      -- Trick box disabled. Back to reset  state 
      if (TrRXEnSync ='0') then
        NextSciRXCntlSt      <= "000";
        NextBitPeriodCnt     <= ZERO;
        NextBitCnt           <= "0000";
      -- Reception completed. Go to receive GUARD state
      elsif (((BitCmp) and (BitPeriodCmp)) = '1') then
        -- T0 mode. Parity error enabled
        if (((TrRXNAKSync ) and (TrRXFError)) ='1') then
          NextSciRXCntlSt    <= "110";
          NextSCIDATAOUT     <= '1';
          NextDelay          <= '1';
          NextBitPeriodCnt   <= BitPeriodRvalue;
          NextRXCHGCnt       <= ( '0' & (TrRsyCHG + 7));
          NextRXFWr          <= not(iRXFWr);
          NextRXShiftReg     <=  SCIDATAIN & iRXShiftReg(8 downto 1);
          NextRXPError       <=  SCIDATAIN xor iRXShiftReg(1)
                                 xor iRXShiftReg(2) xor iRXShiftReg(3)
                                 xor iRXShiftReg(4) xor iRXShiftReg(5)
                                 xor iRXShiftReg(6) xor iRXShiftReg(7)
                                 xor iRXShiftReg(8) xor TrRXPStSync 
                                 xor TrSENSE;
        -- T0 mode. Parity error disabled  
        elsif (TrRXNAKSync ='1') then
          NextBitPeriodCnt   <= BitPeriodRvalue;
          NextSciRXCntlSt    <= "110";
          NextRXCHGCnt       <= ( '0' & (TrRsyCHG + 2));
          NextRXFWr          <= not(iRXFWr);
          NextSCIDATAOUT     <= '1';
          NextRXShiftReg     <=  SCIDATAIN & iRXShiftReg(8 downto 1);
          NextRXPError       <=  SCIDATAIN xor iRXShiftReg(1)
                                 xor iRXShiftReg(2) xor iRXShiftReg(3)
                                 xor iRXShiftReg(4) xor iRXShiftReg(5)
                                 xor iRXShiftReg(6) xor iRXShiftReg(7)
                                 xor iRXShiftReg(8) xor TrRXPStSync 
                                 xor TrSENSE;
        -- T1 mode. 
        else
          NextBitPeriodCnt   <= BitPeriodRvalue;
          NextSciRXCntlSt    <= "110";
          NextRXCHGCnt       <= ('0' & (TrRsyCHG + 2));
          NextRXFWr          <= not(iRXFWr);
          NextSCIDATAOUT     <= '1';
          NextRXShiftReg     <=  SCIDATAIN & iRXShiftReg(8 downto 1);
          NextRXPError       <=  SCIDATAIN xor iRXShiftReg(1)
                                 xor iRXShiftReg(2) xor iRXShiftReg(3)
                                 xor iRXShiftReg(4) xor iRXShiftReg(5)
                                 xor iRXShiftReg(6) xor iRXShiftReg(7)
                                 xor iRXShiftReg(8) xor TrRXPStSync 
                                 xor TrSENSE;
        end if;
      -- one bit time(etu) completed 
      elsif (BitPeriodCmp = '1') then
        NextRXShiftReg       <=  SCIDATAIN & iRXShiftReg(8 downto 1);
        NextBitCnt           <= BitCnt -1;
        NextBitPeriodCnt     <= BitPeriodRvalue;
        NextSCIDATAOUT       <= '1';
        NextSciRXCntlSt      <= "010";
      else
        NextBitPeriodCnt     <= BitPeriodCnt -1;
        NextSciRXCntlSt      <= "010";
      end if;
   
    -- Receive GUARGD state 
    when "110" =>
    -- Trick box disabled. Back to reset  state 
      if (TrRXEnSync ='0') then
        NextSciRXCntlSt      <= "000";
        NextBitPeriodCnt     <= ZERO;
        NextRXCHGCnt         <= "000000000";
        NextRXPCnt           <= "0000"; 
        NextSCIDATAOUT       <= '1';
      -- RX block Guard time over. Back to idle state 
      elsif ((RXCHGCnt = "000000001") and (BitPeriodCmp = '1')) then
        NextSciRXCntlSt      <= "000";
        NextBitPeriodCnt     <= ZERO;
        NextRXCHGCnt         <= "000000000";
        NextRXPCnt           <= "0000";
        NextSCIDATAOUT       <= '1';
     -- Start bit detected
      elsif ((SCIDATAIN = '0') and (RXCHGCnt = "000000001")) then  
        -- Charactor Guard time satisfied. 
        if (((BitPeriodCnt <= (BitPeriodRvalue/2 + TrRSyBaud + 2)) and
            (BitPeriodCnt >= (BitPeriodRvalue/2 - TrRSyBaud - 2))) = '1' ) then
          -- Parity error enabled. Go to re_receive state
          if (((TrRXNAKSync ) and (TrRXFError)) ='1') then
            NextRXPCnt       <= RXPCnt -1; 
            NextBitPeriodCnt <= BitPeriodRvalue/2 + TrRSyBaud;
            NextSciRXCntlSt  <= "111";
            NextSCIDATAOUT   <= '1';
          -- Parity error disabled. Go to receive state 
          else 
            NextBitPeriodCnt <= BitPeriodRvalue/2 + TrRSyBaud;
            NextSciRXCntlSt  <= "011";
            NextSCIDATAOUT   <= '1';
          end if;
        -- Charactor Guard time error. 
        else
          -- Parity error enabled. Go to re_receive state
          if (((TrRXNAKSync) and (TrRXFError)) ='1') then
            NextRXPCnt <= RXPCnt -1; 
            NextBitPeriodCnt <= BitPeriodRvalue/2 + TrRSyBaud;
            NextSciRXCntlSt  <= "111";
            NextRXCtimError  <= '1';
            NextSCIDATAOUT   <= '1';
          -- Parity error disabled. Go to receive state 
          else
            NextBitPeriodCnt <= BitPeriodRvalue/2 + TrRSyBaud;
            NextSciRXCntlSt  <= "011";
            NextRXCtimError  <= '1';
            NextSCIDATAOUT   <= '1';
          end if;
        end if;
      -- One bit period over(etu). Decrement the NextBitPeriod counter 
      elsif (BitPeriodCmp ='1') then
        -- Asking for the retransmission by making the SCIDATAOUT signal
        -- low for one etu after the parity bit detection   
        if (Delay ='1') then
          NextDelay          <= '0';
          NextSCIDATAOUT     <= '0';
          NextRXCHGCnt       <= RXCHGCnt -1;
          NextBitPeriodCnt   <= BitPeriodRvalue;
          NextSciRXCntlSt    <= "110";
        -- make the SCIDATAOUT signal high after one etu
        else
          NextSCIDATAOUT     <= '1';
          NextRXCHGCnt       <= RXCHGCnt -1;
          NextBitPeriodCnt   <= BitPeriodRvalue;
          NextSciRXCntlSt    <= "110";
        end if;
      else 
        NextSciRXCntlSt      <= "110";
        NextBitPeriodCnt     <= BitPeriodCnt -1;
      end if;

    -- Re_Receive state 
    when "111" =>
    -- Trick box disabled. Back to reset  state 
      if (TrRXEnSync ='0') then
        NextSciRXCntlSt      <= "000";
        NextBitPeriodCnt     <= ZERO;
      --Invalid start bit detected
      elsif (BitPeriodCmp = '1') then
        NextSciRXCntlSt      <= "000";
        NextBitPeriodCnt     <= ZERO;
        NextBitCnt           <= "0000";
        NextRXShiftReg       <=  "000000000";
        NextStBitError     <= '1';
      --Invalid start bit detected
      elsif (SCIDATAIN = '1') then
        NextSciRXCntlSt      <= "000";
        NextBitPeriodCnt     <= ZERO;
        NextBitCnt           <= "0000";
        NextRXShiftReg       <=  "000000000";
        NextStBitError    <= '1';
      --Valid start bit detected.
      elsif (SCIDATAIN = '0') then
        if ((BitPeriodCnt     <=  2 * (TrRSyBaud + 1)) = '1' ) then 
          NextSciRXCntlSt     <= "010";
          NextRXShiftReg      <=  "000000000";
          NextBitPeriodCnt    <= BitPeriodRvalue;
          NextBitCnt          <= "1000";
        else
          NextBitPeriodCnt    <= BitPeriodCnt - 1;
          NextSciRXCntlSt     <= "111";
        end if;
      end if;
 

    when others =>
      NextSciRXCntlSt         <= "000";

  end case;
end process p_ReceComb;

-------------------------------------------------------------------------------
-- Parity error check 
-------------------------------------------------------------------------------
-- p_RXperrorComb : process (iRXFWr)
-- begin
--   if (((iRXFWr) and (iRXShiftReg(0) xor iRXShiftReg(1) xor 
--                      iRXShiftReg(2) xor iRXShiftReg(3) xor 
--                      iRXShiftReg(4) xor iRXShiftReg(4) xor 
--                      iRXShiftReg(6) xor iRXShiftReg(7) xor 
--                      iRXShiftReg(8) xor TrRXPStSync xor TrSENSE )) = '1') then 
--     NextRXPError <= '1';  
--   else
--     NextRXPError <= '0';
--   end if;
-- end process p_RXperrorComb; 

-------------------------------------------------------------------------------
-- Calculating the Bit period time from Baud and SCIVALUE 
-------------------------------------------------------------------------------
TrRSyBAUDMul    <= "000000000000" & TrRSyBAUD;
BitPeriodRvalue <=  (TrRSyBAUDMul + 1) * TrRSyVALUE;

end synth;

--  Signals: SciRXCntlSt<2:0> NextSciRXCntlSt<2:0> 
--    ST_IDLE	   000
--    ST_BLKG      001 
--    ST_STARTBIT  011
--    ST_RECEIVE   010
--    ST_RCHUARD   110
--    ST_RERECEIVE 111

--=============================== End =======================================--
