--  ----------------------------------------------------------------------------
--  This confidential and proprietary software may be used only as
--  authorised by a licensing agreement from ARM Limited
--    (C) COPYRIGHT 1998-2000 ARM Limited
--        ALL RIGHTS RESERVED
--  The entire notice above must be reproduced on all authorised
--  copies and copies may only be made to the extent permitted
--  by a licensing agreement from ARM Limited.
--  ----------------------------------------------------------------------------
--  
--  Version and Release Control Information:
--  
--  File Name              : UartTrRegBlock.vhd.rca
--  File Revision          : 1.7
--  
--  Release Information    : PrimeCell(TM)-PL011-REL1v3
--  
--------------------------------------------------------------------------------
-- Purpose     : This block generates decodes for Register accesses
--------------------------------------------------------------------------------
  
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

--------------------------------------------------------------------------------

entity UartTrRegBlock is
  port (
        PCLK              : in  std_logic;  -- APB Bus Clock
        PRESETn           : in  std_logic;  -- Reset 
        UTILPRWrEn        : in  std_logic;  -- Write Enable for UTILPR
        UTLCRHWrEn        : in  std_logic;  -- Write Enable for LCRH
        UTLCRMWrEn        : in  std_logic;  -- Write Enable for LCRM
        UTLCRLWrEn        : in  std_logic;  -- Write Enable for LCRL
        UTCRWrEn          : in  std_logic;  -- Write Enable for UTCR
        UTFORCEDERRSWrEn  : in  std_logic;  -- Write Enable for UTFORCEDERRS
        UTSETPINSWrEn     : in  std_logic;  -- Write Enable for UTSETPINS
        UTBITSFTDATAWrEn  : in  std_logic;  -- Write Enable for UTBITSFTDATA
        UTSFTDATA2WrEn    : in  std_logic;  -- Write Enable for UTBITSFTDATA2
        UTCLKREGWrEn      : in  std_logic;  -- Write Enable for UTCLKREG
        RSTMODEREGWrEn    : in  std_logic;  -- Write Enable for UTRESETMODEREG 
        UTDMACRWrEn       : in  std_logic;  -- Write Enable for UTDMACR
        UTSTPARITYWrEn    : in  std_logic;  -- Write Enable for UTSTPARITY
        UTFBRDWrEn        : in  std_logic;  -- Write Enable for UTFBRD
        PWDATAIn          : in  std_logic_vector(7 downto 0); -- Data bus
        TXDMACLRStag4     : in  std_logic;  -- For UARTTXDMACLR
        RXDMACLRStag4     : in  std_logic;  -- For UARTRXDMACLR
        UTFORCEDERRS      : out std_logic_vector(7 downto 0); -- Forcing Errs 
        Mode              : out std_logic_vector(1 downto 0); -- Operation mode 
        UTLCRH            : out std_logic_vector(7 downto 0); -- 1st buffer
        UTLCRM            : out std_logic_vector(7 downto 0); -- 1st buffer
        UTLCRL            : out std_logic_vector(7 downto 0); -- 1st buffer
        UTILPR            : out std_logic_vector(7 downto 0); -- 1st buffer
        UTCR              : out std_logic_vector(7 downto 0); -- CR bits
        UTSTPARITY        : out std_logic_vector(7 downto 0); -- STPARITY bits
        UTFBRD            : out std_logic_vector(5 downto 0); -- FBRD bits
        UTSETPINS         : out std_logic_vector(7 downto 0); -- Set Pins Reg
        UTBITSFTDATA      : out std_logic_vector(7 downto 0); -- Shift pulses
        UTBITSFTDATA2     : out std_logic_vector(5 downto 0); -- Shift pulses 2
        UTCLKREG          : out std_logic_vector(7 downto 0); -- Clock Period
        RSTMODEREG        : out std_logic_vector(3 downto 0);  -- Reset Reg
        UTDMACR           : out std_logic_vector(1 downto 0)  -- DMACR bits
       );
end UartTrRegBlock;

--------------------------------------------------------------------------------
--
--                   UartTrRegBlock
--                   ============
--
--------------------------------------------------------------------------------
--
-- Overview
-- ========
--
--  This block contains the normal mode registers for the UT. Write data from
-- the PWDATAIn bus is clocked in when the appropriate write enable signal is
-- asserted. 
--  This block contains the first buffer in the 2-buffer synchronisation 
-- mechanism for the LCR. It also contains the first buffer for the
-- 2-buffer synchronisation mechanism for the ILPR.
--------------------------------------------------------------------------------

--=============================== ARCHITECTURE ===============================--

architecture synth of UartTrRegBlock  is

--------------------------------------------------------------------------------
-- Signal declarations
--------------------------------------------------------------------------------
  signal iUTLCRH               : std_logic_vector(7 downto 0);  
  -- 1st stage buffer for UTLCRH. 

  signal NextLCRH              : std_logic_vector(7 downto 0); 
  -- D-input of iUTLCRH

  signal iUTLCRM               : std_logic_vector(7 downto 0);  
  -- 1st stage buffer for UTLCRM

  signal NextLCRM              : std_logic_vector(7 downto 0);  
  -- D-input of iUTLCRM

  signal iUTLCRL               : std_logic_vector(7 downto 0);  
  -- 1st stage buffer for UTLCRL

  signal NextLCRL              : std_logic_vector(7 downto 0);  
  -- D-input of iUTLCRL

  signal iUTILPR               : std_logic_vector(7 downto 0);
  -- 1st stage buffer for UTILPR

  signal NextILPR              : std_logic_vector(7 downto 0);
  -- D-input of iUTILPR

  signal  iMode                :  std_logic_vector(1 downto 0) ;
  -- Internal mode signal

  signal iUTCR                 : std_logic_vector(7 downto 0);
  -- UTCR

  signal NextUTCR              : std_logic_vector(7 downto 0);
  -- D-input of UTCR
  
  signal iUTSTPARITY           : std_logic_vector(7 downto 0);
  -- UTSTPARITY

  signal NextUTSTPARITY        : std_logic_vector(7 downto 0);
  -- D-input of UTSTPARITY
  
  signal iUTFBRD               : std_logic_vector(5 downto 0);
  -- UTFBRD

  signal NextUTFBRD            : std_logic_vector(5 downto 0);
  -- D-input of UTFBRD
  
  signal iUTFORCEDERRS         : std_logic_vector(7 downto 0);
  -- UTFORCEDERRS

  signal NextUTFORCEDERRS      : std_logic_vector(7 downto 0);
  -- D-input of UTFORCEDERRS

  signal  NextUTSETPINS        : std_logic_vector(7 downto 0);
  -- D-input of UTSETPINS
 
  signal  NextBITSFTDATA       : std_logic_vector(7 downto 0);
  -- D-input for BITSFTDATA
 
  signal NextBITSFTDATA2       : std_logic_vector(5 downto 0);
  -- D-input for BITSFTDATA2
 
  signal  NextCLKREG           : std_logic_vector(7 downto 0);
  -- D-input for CLK REG 
  
  signal  NextRSTMODEREG       : std_logic_vector(3 downto 0);
  -- D-input for Reset  REG
 
  signal iTXDMACLR             : std_logic;
  -- Internal copy of TXDMACLR

  signal iRXDMACLR             : std_logic;
  -- Internal copy of RXDMACLR

 signal NextTXDMACLR           : std_logic;
  -- D-input of TXDMACLR
  
 signal NextRXDMACLR           : std_logic;
  -- D-input of RXDMACLR
    
  signal  iUTSETPINS           : std_logic_vector(7 downto 0);
  -- Internal copy of UTSETPINS

  signal  iUTBITSFTDATA        : std_logic_vector(7 downto 0);
  -- Internal copy of BITSFTDATA

  signal iUTBITSFTDATA2        : std_logic_vector(5 downto 0);
  -- Internal copy of BITSFTDATA2

  signal  iUTCLKREG            : std_logic_vector(7 downto 0);
  -- Internal copy of Trickbox Clock Reg
 
  signal  iRSTMODEREG          : std_logic_vector(3 downto 0);
  -- Internal copy of Reset Reg

  signal  nUTRST               : std_logic;
  -- Trickbox Reset
--------------------------------------------------------------------------------
--
-- Main body of  code
-- ==================
--
--------------------------------------------------------------------------------
   
begin
--------------------------------------------------------------------------------
-- Internal versions of output(s)...
--------------------------------------------------------------------------------
  nUTRST        <= iRSTMODEREG(0);
  Mode          <= iMode;
  UTLCRH        <= iUTLCRH;
  UTLCRM        <= iUTLCRM;
  UTLCRL        <= iUTLCRL;
  UTCR          <= iUTCR;
  UTSTPARITY    <= iUTSTPARITY;
  UTFBRD        <= iUTFBRD;
  UTILPR        <= iUTILPR;
  UTFORCEDERRS  <= iUTFORCEDERRS;
  UTSETPINS     <= iUTSETPINS;
  UTBITSFTDATA  <= iUTBITSFTDATA;
  UTBITSFTDATA2 <= iUTBITSFTDATA2;
  UTCLKREG      <= iUTCLKREG;
  RSTMODEREG    <= iRSTMODEREG;
  UTDMACR(0)    <= iTXDMACLR;
  UTDMACR(1)    <= iRXDMACLR;
--------------------------------------------------------------------------------
-- Generating Mode signal of Trickbox 
--------------------------------------------------------------------------------
p_ModeComb : process (iUTCR)
begin

   if (iUTCR(1) = '1')then
     if (iUTCR(2) = '0') then
        iMode <= "01";
     else
        iMode <= "10";
     end if;
   else
     iMode <= "00";
   end if;
end process p_ModeComb;
 
-------------------------------------------------------------------------------
-- Combinational process for 1st stage buffers for LCR. When the respective
-- write enable input is asserted, copy the contents of the PWDATAIn bus into
-- the corresponding 1st stage buffer.
-------------------------------------------------------------------------------
p_LCRComb: process (PWDATAIn,UTLCRHWrEn,UTLCRMWrEn,UTLCRLWrEn,
                   iUTLCRH,iUTLCRM,iUTLCRL) 
begin
  NextLCRH     <= iUTLCRH;
  NextLCRM     <= iUTLCRM;
  NextLCRL     <= iUTLCRL;

  if (UTLCRHWrEn = '1') then
    NextLCRH     <= PWDATAIn(7 downto 1) & "0";
  end if;

  if (UTLCRMWrEn = '1') then
    NextLCRM   <= PWDATAIn;
  end if;

  if (UTLCRLWrEn = '1') then
    NextLCRL   <= PWDATAIn;
  end if;
end process p_LCRComb;

-------------------------------------------------------------------------------
-- Sequential process for first stage buffers for LCR 
-------------------------------------------------------------------------------
p_LCRSeq : process (PCLK, PRESETn) 
begin
  if (PRESETn = '0') then
    iUTLCRH    <= (others => '0');
    iUTLCRM    <= (others => '0');
    iUTLCRL    <= (others => '0');
  elsif (PCLK'event and PCLK = '1') then
      iUTLCRH    <= NextLCRH;
      iUTLCRM    <= NextLCRM;
      iUTLCRL    <= NextLCRL;
  end if;
end process p_LCRSeq;

-------------------------------------------------------------------------------
-- Clock in PWDATAIn into ILPR when UTILPRWrEn is asserted.
-------------------------------------------------------------------------------
p_ILPRComb : process (UTILPRWrEn, iUTILPR, PWDATAIn)
begin
  NextILPR   <= iUTILPR;
  if (UTILPRWrEn = '1') then
    NextILPR <= PWDATAIn(7 downto 0);
  end if;
end process p_ILPRComb;

-------------------------------------------------------------------------------
-- Sequential process for ILPR first stage buffer
-------------------------------------------------------------------------------
p_ILPSeq : process(PCLK, PRESETn)
begin
  if (PRESETn = '0') then
    iUTILPR    <= (others => '0');
  elsif (PCLK'event and PCLK = '1') then
      iUTILPR  <= NextILPR;
  end if;
end process p_ILPSeq;

-------------------------------------------------------------------------------
-- Clock PWDATAIn into UTCR when UTCRWrEn is asserted. 
-------------------------------------------------------------------------------
p_CRComb : process (UTCRWrEn,iUTCR,PWDATAIn) 
begin
  NextUTCR <= iUTCR;
 
  if (UTCRWrEn = '1') then
    NextUTCR <= PWDATAIn;
  end if;

end process p_CRComb;

-------------------------------------------------------------------------------
-- Sequential process for UTCR
-------------------------------------------------------------------------------
p_CRSeq :  process(PCLK, PRESETn) 
begin
  if (PRESETn = '0') then
    iUTCR <= (others => '0');
  elsif (PCLK'event and PCLK = '1') then
      iUTCR <= NextUTCR;
  end if;
end process p_CRSeq;
-------------------------------------------------------------------------------
-- Clock PWDATAIn into UTUTFORCEDERRS when UTUTFORCEDERRSWrEn is asserted.
-------------------------------------------------------------------------------
p_FORComb : process (UTFORCEDERRSWrEn, iUTFORCEDERRS) 
begin
  NextUTFORCEDERRS <= iUTFORCEDERRS;

  if (UTFORCEDERRSWrEn = '1') then
    NextUTFORCEDERRS <=  PWDATAIn;
  end if;
end process p_FORComb;
-------------------------------------------------------------------------------
-- Sequential process for UTFORCEDERRS 
-------------------------------------------------------------------------------

p_FORSeq : process (PCLK, PRESETn)
begin
  if (PRESETn = '0') then
    iUTFORCEDERRS <= "00000000";
  elsif (PCLK'event and PCLK = '1') then
      iUTFORCEDERRS <= NextUTFORCEDERRS;
  end if;
end process p_FORSeq; 
-------------------------------------------------------------------------------
-- Clock in PWDATAIn into SET_PINS when UTSETPINSWrEn is asserted.
-------------------------------------------------------------------------------
p_UTSETPINSComb : process (UTSETPINSWrEn, iUTSETPINS, PWDATAIn)
begin
  NextUTSETPINS   <= iUTSETPINS;
  if (UTSETPINSWrEn = '1') then
    NextUTSETPINS <= PWDATAIn(7 downto 0);
  end if;
end process p_UTSETPINSComb;
 
-------------------------------------------------------------------------------
-- Sequential process for UTSETPINS first stage buffer
-------------------------------------------------------------------------------
p_SETSeq : process (PCLK, PRESETn)
begin
  if (PRESETn = '0') then
    iUTSETPINS  <=  "00111111";
  elsif (PCLK'event and PCLK = '1') then
      iUTSETPINS  <= NextUTSETPINS;
  end if;
end process p_SETSeq;
 
-------------------------------------------------------------------------------
-- Clock in PWDATAIn into BITSFTDATA when UTBITSFTDATAWrEn is asserted.
-------------------------------------------------------------------------------
p_BITSFTDATAComb : process (UTBITSFTDATAWrEn, iUTBITSFTDATA, PWDATAIn)
begin
  NextBITSFTDATA   <= iUTBITSFTDATA;
  if (UTBITSFTDATAWrEn = '1') then
    NextBITSFTDATA <= PWDATAIn;
  end if;
end process p_BITSFTDATAComb;
 
-------------------------------------------------------------------------------
-- Sequential process for BITSFTDATA first stage buffer
-------------------------------------------------------------------------------
p_BITSFTSeq : process (PCLK, PRESETn)
begin
  if (PRESETn = '0') then
    iUTBITSFTDATA    <= (others => '0');
  elsif (PCLK'event and PCLK = '1') then
      iUTBITSFTDATA  <= NextBITSFTDATA;
  end if;
end process p_BITSFTSeq;
 
-------------------------------------------------------------------------------
-- Clock in PWDATAIn into BITSFTDATA2 when UTSFTDATA2WrEn is asserted.
-------------------------------------------------------------------------------
p_BITSFTDATA2Comb : process (UTSFTDATA2WrEn, iUTBITSFTDATA2, PWDATAIn)
begin
  NextBITSFTDATA2   <= iUTBITSFTDATA2;
  if (UTSFTDATA2WrEn = '1') then
    NextBITSFTDATA2 <= PWDATAIn(5 downto 0);
  end if;
end process p_BITSFTDATA2Comb;
 
-------------------------------------------------------------------------------
-- Sequential process for BITSFTDATA2 first stage buffer
-------------------------------------------------------------------------------
p_BITSFTDATA2Seq : process (PCLK, PRESETn)
begin
  if (PRESETn = '0') then
    iUTBITSFTDATA2    <= (others => '0');
  elsif (PCLK'event and PCLK = '1') then
      iUTBITSFTDATA2  <= NextBITSFTDATA2;
  end if;
end process p_BITSFTDATA2Seq;
 
-------------------------------------------------------------------------------
-- Clock in PWDATAIn into CLKREG when UTCLKREGWrEn is asserted.
-------------------------------------------------------------------------------
p_CLKREGComb : process (UTCLKREGWrEn, iUTCLKREG, PWDATAIn)
begin
  NextCLKREG <= iUTCLKREG;
  if (UTCLKREGWrEn = '1') then
    NextCLKREG <= PWDATAIn;
  end if;
end process p_CLKREGComb;
 
-------------------------------------------------------------------------------
-- Sequential process for CLKREG first stage buffer
-------------------------------------------------------------------------------
p_CLKREGSeq : process(PCLK, PRESETn)
begin
  if (PRESETn = '0') then
    iUTCLKREG    <= (others => '0');
  elsif (PCLK'event and PCLK = '1') then
    iUTCLKREG  <= NextCLKREG;
  end if;
end process p_CLKREGSeq;
 
-------------------------------------------------------------------------------
-- Clock in PWDATAIn into CLKREG when UTCLKREGWrEn is asserted.
-------------------------------------------------------------------------------
p_RSTMODEREGComb : process (RSTMODEREGWrEn, iRSTMODEREG, PWDATAIn)
begin
  NextRSTMODEREG   <= iRSTMODEREG;
  if (RSTMODEREGWrEn = '1') then
    NextRSTMODEREG <= PWDATAIn(3 downto 0);
  end if;
end process p_RSTMODEREGComb;
 
-------------------------------------------------------------------------------
-- Sequential process for RSTMODEREG first stage buffer
-------------------------------------------------------------------------------
p_RSTMODESeq : process (PCLK, PRESETn)
begin
  if (PRESETn = '0') then
    iRSTMODEREG    <= (others => '0');
  elsif (PCLK'event and PCLK = '1') then
      iRSTMODEREG  <= NextRSTMODEREG;
  end if;
end process p_RSTMODESeq;


-------------------------------------------------------------------------------
-- Clock PWDATAIn into UTDMACR when UTDMACRWrEn is asserted, TX
-------------------------------------------------------------------------------
p_TXDMAComb : process (UTDMACRWrEn,iTXDMACLR,PWDATAIn,TXDMACLRStag4) 
begin
  NextTXDMACLR <= iTXDMACLR;
 
  if (UTDMACRWrEn = '1') then
    NextTXDMACLR <= PWDATAIn(0);
  elsif(TXDMACLRStag4 = '1') then
    NextTXDMACLR <= '0';
  end if;
end process p_TXDMAComb;

-------------------------------------------------------------------------------
-- Sequential process for UTDMACR
-------------------------------------------------------------------------------
p_TXDMASeq :  process(PCLK, PRESETn) 
begin
  if (PRESETn = '0') then
    iTXDMACLR <=  '0';
  elsif (PCLK'event and PCLK = '1') then
    iTXDMACLR <= NextTXDMACLR;
  end if;
end process p_TXDMASeq;


-------------------------------------------------------------------------------
-- Clock PWDATAIn into UTDMACR when UTDMACRWrEn is asserted, RX
-------------------------------------------------------------------------------
p_RXDMAComb : process (UTDMACRWrEn,iRXDMACLR,PWDATAIn,RXDMACLRStag4) 
begin
  NextRXDMACLR <= iRXDMACLR;
 
  if (UTDMACRWrEn = '1') then
    NextRXDMACLR <= PWDATAIn(1);
  elsif(RXDMACLRStag4 = '1') then
    NextRXDMACLR <= '0';
  end if;
end process p_RXDMAComb;

-------------------------------------------------------------------------------
-- Sequential process for UTDMACR
-------------------------------------------------------------------------------
p_RXDMASeq :  process(PCLK, PRESETn) 
begin
  if (PRESETn = '0') then
    iRXDMACLR <= '0';
  elsif (PCLK'event and PCLK = '1') then
    iRXDMACLR <= NextRXDMACLR;
  end if;
end process p_RXDMASeq;


-------------------------------------------------------------------------------
-- Clock PWDATAIn into UTSTPARITY when UTSTPARITYWrEn is asserted. 
-------------------------------------------------------------------------------
p_STPARITYComb : process (UTSTPARITYWrEn,iUTSTPARITY,PWDATAIn) 
begin
  NextUTSTPARITY <= iUTSTPARITY;
 
  if (UTSTPARITYWrEn = '1') then
    NextUTSTPARITY <= PWDATAIn(7 downto 7) & "0000000";
  end if;

end process p_STPARITYComb;

-------------------------------------------------------------------------------
-- Sequential process for UTSTPARITY
-------------------------------------------------------------------------------
p_STPARITYSeq :  process(PCLK, PRESETn) 
begin
  if (PRESETn = '0') then
    iUTSTPARITY <= (others => '0');
  elsif (PCLK'event and PCLK = '1') then
      iUTSTPARITY <= NextUTSTPARITY;
  end if;
end process p_STPARITYSeq;


-------------------------------------------------------------------------------
-- Clock PWDATAIn into UTFBRD when UTFBRDWrEn is asserted. 
-------------------------------------------------------------------------------
p_FBRDComb : process (UTFBRDWrEn,iUTFBRD,PWDATAIn) 
begin
  NextUTFBRD<= iUTFBRD;
 
  if (UTFBRDWrEn = '1') then
    NextUTFBRD <= PWDATAIn(5 downto 0);
  end if;

end process p_FBRDComb;

-------------------------------------------------------------------------------
-- Sequential process for UTFBRD
-------------------------------------------------------------------------------
p_FBRDSeq :  process(PCLK, PRESETn) 
begin
  if (PRESETn = '0') then
    iUTFBRD <= (others => '0');
  elsif (PCLK'event and PCLK = '1') then
      iUTFBRD <= NextUTFBRD;
  end if;
end process p_FBRDSeq;



end synth;



--========================== End of UartTrRegBlock =============================













