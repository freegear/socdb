-- ========================================================================== --
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
--  File Name              : UartTrApbif.vhd.rca
--  File Revision          : 1.7
--  
--  Release Information    : PrimeCell(TM)-PL011-REL1v3
--  
--------------------------------------------------------------------------------
-- Purpose     : This block generates decodes for Register accesses
--  
-- ========================================================================== --
--  
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

--  ----------------------------------------------------------------------------

entity UartTrApbif is
  port ( 
        PCLK              : in std_logic;  -- APB Bus clock
        PRESETn             : in std_logic;  -- AMBA Reset
        PSELT             : in std_logic;  -- APB Peripheral select
        PENABLE           : in std_logic;  -- APB Peripheral enable
        PWRITE            : in std_logic;  -- APB Write
        nSIROUT           : in std_logic;  -- SiR transmit output
        nUARTOut2         : in std_logic;  -- Modem signal
        nUARTOut1         : in std_logic;  -- Modem signal
        nUARTRTS          : in std_logic;  -- Modem signal
        nUARTDTR          : in std_logic;  -- Modem signal    
        UARTTXD           : in std_logic;  -- UT Transmit line
        RCVPE             : in std_logic;  -- UT Parity Error
        RCVFE             : in std_logic;  -- UT Frame Error
        IrdaRCVPE         : in std_logic;  -- Parity Error in Irda mode
        IrdaRCVFE         : in std_logic;  -- UT Irda Frame Error
        RXFF              : in std_logic;  -- RX FIFO Full
        TXFF              : in std_logic;  -- TX FIFO Full
        RXFE              : in std_logic;  -- RX FIFO Empty
        TXHE              : in std_logic;  -- TX FIFO LE Half Empty
        TXFE              : in std_logic;  -- TX FIFO Empty
        RXHF              : in std_logic;  -- RX FIFO GE Half Full
        PCLKOn            : in std_logic;  -- PCLK Routing Status
        REFCLKOn          : in std_logic;  -- UartClock Routing Status
        UartRXBUSY        : in std_logic;  -- Uart Reception in progress
        UartTXBUSY        : in std_logic;  -- UT Uart Transmission in progress
        IrdaRXBUSY        : in std_logic;  -- Irda Reception in progress
        IrdaTXBUSY        : in std_logic;  -- UT Irda Transmission in progress
        IrdaTXFRdPtrInc   : in std_logic;  -- Irda Read Ptr Inc
        UartTXFRdPtrInc   : in std_logic;  -- Uart Read Ptr Inc
        UARTINTR          : in std_logic;  -- Uart Interrupt from UUT
        UARTEINTR         : in std_logic;  -- Uart Error Interrupt from UUT
        UARTTXDMASREQ     : in std_logic; -- Transmit DMA single request
        UARTTXDMABREQ     : in std_logic; -- Transmit DMA burst request
        UARTRXDMASREQ     : in std_logic; -- Receive DMA single request
        UARTRXDMABREQ     : in std_logic; -- Receive DMA burst request
        RTIS              : in std_logic;  -- Timeout Interrupt from UUT
        TIS               : in std_logic;  -- Transmit Interrupt from UUT
        RIS               : in std_logic;  -- Receive Interrupt from UUT
        MIS               : in std_logic;  -- Modem Interrupt from UUT
        FREQERR           : in std_logic;  -- Error in baud rate
        PADDR             : in std_logic_vector(7 downto 2); -- APB Addr bus
        PWDATA            : in std_logic_vector(7 downto 0); -- Wr databus
        UTLCRH            : in std_logic_vector(7 downto 0); -- Trickbox LCRH
        UTLCRM            : in std_logic_vector(7 downto 0); -- Trickbox LCRM
        UTLCRL            : in std_logic_vector(7 downto 0); -- Trickbox LCRL
        SPNUM             : in std_logic_vector(2 downto 0); -- Start Pulse 
        EPNUM             : in std_logic_vector(2 downto 0); -- End Pulse No
        SHFT              : in std_logic_vector(1 downto 0); -- Shift factor
        PNUM              : in std_logic_vector(2 downto 0); -- Pulse No
        PSHFT             : in std_logic_vector(2 downto 0); -- Pulse Shift 
        RXFRdData         : in std_logic_vector(7 downto 0); -- FIFO Rd data 
        UTCR              : in std_logic_vector(7 downto 0); -- UTControl Reg
        UTILPR            : in std_logic_vector(7 downto 0); -- Irda LPR Reg
        UTFORCEDERRS      : in std_logic_vector(7 downto 0); -- Forcing Error
        UTSETPINS         : in std_logic_vector(7 downto 0); -- Setting Pins
        UTBITSFTDATA      : in std_logic_vector(7 downto 0); -- Shift Pulse Reg
        UTBITSFTDATA2     : in std_logic_vector(5 downto 0); -- Shift Pulse 2
        RSTMODEREG        : in std_logic_vector(3 downto 0); -- Reset Mode Reg
        UTSTPARITY        : in std_logic_vector(7 downto 0); -- STPARITY reg
        UTFBRD            : in std_logic_vector(5 downto 0); -- FBRD reg
        TXFRdPtrInc       : out std_logic;  -- Combined Read Ptr Inc
        TXBUSY            : out std_logic;  -- Transmission in progress
        UTDRWrEn          : out std_logic;  -- Trickbox Write Enable
        UTLCRHWrEn        : out std_logic;  -- Write Enable for LCRH
        UTLCRMWrEn        : out std_logic;  -- Write Enable for LCRM
        UTLCRLWrEn        : out std_logic;  -- Write Enable for LCRL
        UTCRWrEn          : out std_logic;  -- Write Enable for Trickbox CR
        UTILPRWrEn        : out std_logic;  -- Write Enable for ILPR
        UTFORCEDERRSWrEn  : out std_logic;  -- Write Enable for UTFORCEDERRS
        UTSETPINSWrEn     : out std_logic;  -- Write Enable for UTSETPINS
        UTBITSFTDATAWrEn  : out std_logic;  -- Write Enable for UTBITSFTDATA
        UTSFTDATA2WrEn    : out std_logic;  -- Write Enable for UTBITSFTDATA2
        UTCLKREGWrEn      : out std_logic;  -- Write Enable for UTCLKREG
        RSTMODEREGWrEn    : out std_logic;  -- Write Enable for UT Reset mode 
        UTDMACRWrEn       : out std_logic;  -- Write Enable for UTDMACR 
        UTSTPARITYWrEn    : out std_logic;  -- Write Enable for UTSTPARITY 
        UTFBRDWrEn        : out std_logic;  -- Write Enable for UTFBRD 
        RXFRdPtrInc       : out std_logic;  -- FIFO Read Ptr to be Incremented 
        PWDATAIn          : out std_logic_vector(7 downto 0); -- Int PWDATA
        PRDATA            : out std_logic_vector(7 downto 0)  -- Read databus
       );
end UartTrApbif;

--------------------------------------------------------------------------------
--
--                   UartTrickboxApbif
--                   =================
--
--------------------------------------------------------------------------------
--
-- Overview
-- ========
-- This module decodes APB accesses and generates the read/write 
-- strobes to the appropriate registers.

--=============================== ARCHITECTURE ===============================--
 
architecture synth of UartTrApbif  is

--------------------------------------------------------------------------------
-- Constant declarations
--------------------------------------------------------------------------------
-- Normal mode registers address constants.Address decode is for
-- bits 2 to 7 (6 bits)
--------------------------------------------------------------------------------
constant UTDR              : std_logic_vector(7 downto 2) := "000000";
-- UTDR at offset 0x00

constant UTRSRDec          : std_logic_vector(7 downto 2) := "000001";
-- UTRSR at offset 0x04

constant UTLCRHDec         : std_logic_vector(7 downto 2) := "000010";
-- UTLLCRH at offset 0x08

constant UTLCRMDec         : std_logic_vector(7 downto 2) := "000011";
-- UTLCRM at offset 0x0C

constant UTLCRLDec         : std_logic_vector(7 downto 2) := "000100";
-- UTLCRL at offset 0x10

constant UTCRDec           :  std_logic_vector(7 downto 2) := "000101";
-- UTCR at offset 0x14

constant UTINTRDec         : std_logic_vector(7 downto 2) := "000110";
-- UTINTR at offset 0x18

constant UTFRDec           : std_logic_vector(7 downto 2) := "000111";
-- UTFR at offset 0x1C

constant UTFREQCTRERRDec   : std_logic_vector(7 downto 2) := "001000";
--  UT_FREQ_CTR_ERRS at offset 0x20

constant UTFORCEDERRSDec   : std_logic_vector(7 downto 2) := "001001";
-- UTFORCEDERRS  at offset 0x24
 
constant UTSETPINSDec      : std_logic_vector(7 downto 2) := "001010";
-- UT_SET_PINS at offset 0x28
 
constant UTCHECKPINSDec    : std_logic_vector(7 downto 2) := "001011";
-- UT_CHECK_PINS at offset 0x2C
 
constant UTILPRDec         : std_logic_vector(7 downto 2) := "001100";
-- UTILPR at offset 0x30
 
constant UTBITSFTDATADec   : std_logic_vector(7 downto 2) := "001101";
-- UT_BIT_SFT_DATA at offset 0x34
 
constant UTBITSFTDATA2Dec  : std_logic_vector(7 downto 2) := "001110";
-- UT_BIT_SFT_DATA_2 at offset 0x38

constant UTCLKREGDec       : std_logic_vector(7 downto 2) := "001111";
-- UTCLKREG at offset 0x3C
 
constant RSTMODEREGDec     : std_logic_vector(7 downto 2) := "010000";
-- UT Reset mode Reg  at offset 0x40

constant UTDMACRDec        : std_logic_vector(7 downto 2) := "010001";
-- UTDMACR at offset 0x44

constant UTSTPARITYDec     : std_logic_vector(7 downto 2) := "010010";
-- UTSTPARITY at offset 0x48

constant UTFBRDDec         : std_logic_vector(7 downto 2) := "010011";
-- UTFBRD at offset 0x4C


--------------------------------------------------------------------------------
-- Signal declarations
--------------------------------------------------------------------------------
signal GatedPADDR       : std_logic_vector(7 downto 2); 
-- Save power by gating PADDR internally with PSEL

--------------------------------------------------------------------------------
-- Read Decodes for Register reads
--------------------------------------------------------------------------------
signal NextUTRSR        : std_logic_vector(1 downto 0);
-- D-input for Receive Status reg
  
signal NextUTINTR       : std_logic_vector(7 downto 0);
-- D-input for Trickbox Interrupt Reg

signal NextUTFR         : std_logic_vector(7 downto 0);
-- D-input for Trickbox Flag Reg

 signal NextUTDMACR     : std_logic_vector(5 downto 0);
-- D-input for DMA  Reg
 
signal UTFREQCTRERR     : std_logic;
-- Trickbox Frequency Error Reg

signal NextUTCHECKPINS  : std_logic_vector(5 downto 0);
-- D-input for Trickbox Check pins Reg 
 
signal iTXBUSY          : std_logic;
-- Internal version of TXBUSY
  
signal RSTMODEREGrd     : std_logic;
-- Reset mode REG Read

signal UTDRrd           : std_logic;
-- UTDR Read

signal UTRSRrd          : std_logic;
-- UTRSR Read

signal UTLCRHrd         : std_logic;
-- LCRH Read

signal UTLCRMrd         : std_logic;
-- LCRM Read

signal UTLCRLrd         : std_logic;
-- LCRL Read

signal UTCRrd           : std_logic;
-- UTCR Read

signal UTFRrd           : std_logic;
-- Flag register Read

signal UTDMACRrd        : std_logic;
-- DMACR  Read

signal UTSTPARITYrd     : std_logic;
-- STPARITY  Read

signal UTFBRDrd         : std_logic;
-- FBRD  Read

signal ActualRCVFE      : std_logic;
-- Multiplexed Frame Error

signal ActualRCVPE      : std_logic;
-- Multiplexed Parity Error
 
signal UTINTRrd         : std_logic;                  
-- Interrupt Identification register Read

signal UTILPRrd         : std_logic;
-- ILPR Read

signal UTFREQCTRERRrd   : std_logic;
-- FREQ_CTR_ERR Read

signal UTFORCEDERRSrd   : std_logic;
-- FORCEDERRS Read
  
signal UTSETPINSrd      : std_logic;
-- SET_PINS Read

signal UTCHECKPINSrd    : std_logic;
-- CHECK_PINS Read

signal UTBITSFTDATArd   : std_logic;
-- TBITSFT_DATA Read

signal UTBITSFTDATA2rd  : std_logic;
-- BITSFT_DATA_2 Read

signal NextPRDATA       : std_logic_vector(7 downto 0);    
-- D-input of iPRDATA

signal UTINTR           : std_logic_vector(7 downto 0);
-- Trickbox INTR Reg

signal UTRSR            : std_logic_vector(1 downto 0);
-- RSR concatenation of bits

signal UTFR             : std_logic_vector(7 downto 0);
-- Flag register concatenation of bits

signal UTDMACR          : std_logic_vector(5 downto 0);
-- DMA register concatenation of bits

signal UTCHECKPINS      : std_logic_vector(5 downto 0); 
-- CHECK_PINS  concatenation of bits

signal RXBUSY           : std_logic;
-- Reception in Progress

signal WrEn             : std_logic;
-- Write enable signal common to all addresses in the APB interface

signal RdEn             : std_logic;
-- Read enable signal common to all addresses in the APB interface

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
 TXBUSY          <= iTXBUSY;
--------------------------------------------------------------------------------
-- Write Interface
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Save power by preventing change in internal data bus and 
-- address bus when the device is not selected
--------------------------------------------------------------------------------
  PWDATAIn           <= PWDATA when ((PSELT =  '1') and (PWRITE = '1'))  
                     else
                        (others  => '0');
  
  GatedPADDR         <= PADDR  when (PSELT = '1') 
                     else 
                        (others => '0'); 

  WrEn               <= PENABLE and PSELT and PWRITE;


  UTLCRHWrEn         <= '1'    when ((WrEn = '1') and (GatedPADDR = UTLCRHDec))
                     else
                        '0';

  UTLCRMWrEn         <= '1'    when ((WrEn = '1') and (GatedPADDR = UTLCRMDec))
                     else
                        '0';

  UTLCRLWrEn         <= '1'    when ((WrEn = '1') and (GatedPADDR = UTLCRLDec))
                     else
                        '0';
 
  UTDRWrEn           <= '1'    when ((WrEn = '1') and (GatedPADDR = UTDR))
                     else
                        '0';
  
 
  UTCRWrEn           <= '1'    when ((WrEn = '1') and (GatedPADDR = UTCRDec))
                     else
                        '0';

  UTILPRWrEn         <=  '1'   when ((WrEn = '1') and (GatedPADDR = UTILPRDec))
                     else
                        '0';

  UTFORCEDERRSWrEn   <= '1'    when ((WrEn = '1') and 
                                        (GatedPADDR = UTFORCEDERRSDec))
                     else
                        '0';

  UTSETPINSWrEn      <= '1'    when ((WrEn = '1') and 
                                       (GatedPADDR = UTSETPINSDec))
                     else
                        '0';
  
  UTBITSFTDATAWrEn   <= '1'    when ((WrEn = '1') and 
                                       (GatedPADDR = UTBITSFTDATADec))
                     else
                        '0';
  UTSFTDATA2WrEn  <= '1'       when ((WrEn = '1') and 
                                       (GatedPADDR = UTBITSFTDATA2Dec))
                     else
                        '0';
 
  UTCLKREGWrEn       <= '1'    when ((WrEn = '1') and 
                                       (GatedPADDR = UTCLKREGDec))
                     else
                        '0';
 
  RSTMODEREGWrEn    <= '1'     when ((WrEn = '1') and
                                       (GatedPADDR = RSTMODEREGDec))
                     else
                        '0';
 
  UTDMACRWrEn    <= '1'        when ((WrEn = '1') and
                                       (GatedPADDR = UTDMACRDec))
                     else
                        '0';
 
  UTSTPARITYWrEn    <= '1'     when ((WrEn = '1') and
                                       (GatedPADDR = UTSTPARITYDec))
                     else
                       '0';
 
  UTFBRDWrEn    <= '1'         when ((WrEn = '1') and
                                       (GatedPADDR = UTFBRDDec))
                     else
                        '0';
 
--------------------------------------------------------------------------------
-- Read interface
--------------------------------------------------------------------------------
  RdEn           <= PSELT and (not PWRITE); 
  
  UTLCRHrd       <= '1' when ((RdEn = '1') and (GatedPADDR = UTLCRHDec))
                 else
                    '0';

  UTLCRMrd       <= '1' when ((RdEn = '1') and (GatedPADDR = UTLCRMDec))
                 else
                    '0';

  UTLCRLrd       <= '1' when ((RdEn = '1') and (GatedPADDR = UTLCRLDec))
                 else
                    '0';

  UTDRrd         <= '1' when ((RdEn = '1') and (GatedPADDR = UTDR))
                 else
                    '0';

  UTRSRrd         <= '1' when ((RdEn = '1') and (GatedPADDR = UTRSRDec))
                  else
                     '0';

  UTCRrd          <= '1' when ((RdEn = '1') and (GatedPADDR = UTCRDec))
                  else
                     '0';

  UTFRrd          <= '1' when ((RdEn = '1') and (GatedPADDR = UTFRDec))
                  else
                     '0';

  UTINTRrd        <= '1' when ((RdEn = '1') and (GatedPADDR = UTINTRDec))
                  else
                     '0';

  UTILPRrd        <= '1' when ((RdEn = '1') and (GatedPADDR = UTILPRDec))
                  else
                     '0';

  UTFREQCTRERRrd  <= '1' when ((RdEn = '1') and (GatedPADDR = UTFREQCTRERRDec))
                  else
                     '0';

  UTFORCEDERRSrd  <= '1' when ((RdEn = '1') and (GatedPADDR = UTFORCEDERRSDec))
                  else
                     '0';

  UTSETPINSrd     <= '1' when ((RdEn = '1') and (GatedPADDR = UTSETPINSDec))
                  else
                     '0';

  UTCHECKPINSrd   <= '1' when ((RdEn = '1') and (GatedPADDR = UTCHECKPINSDec))
                  else
                     '0';

  UTBITSFTDATArd  <= '1' when ((RdEn = '1') and 
                               (GatedPADDR = UTBITSFTDATADec))
                  else
                     '0';

  UTBITSFTDATA2rd <= '1' when ((RdEn = '1') and 
                                (GatedPADDR = UTBITSFTDATA2Dec))
                  else
                     '0';
  
  RSTMODEREGrd    <= '1' when ((RdEn = '1') and
                                (GatedPADDR = RSTMODEREGDec))
                  else
                     '0';

  UTDMACRrd       <= '1' when ((RdEn = '1') and
                                (GatedPADDR = UTDMACRDec))
                  else
                     '0';

  UTSTPARITYrd    <= '1' when ((RdEn = '1') and
                                (GatedPADDR = UTSTPARITYDec))
                  else
                     '0';

  UTFBRDrd        <= '1' when ((RdEn = '1') and
                                (GatedPADDR = UTFBRDDec))
                  else
                     '0';

  NextUTRSR       <= ActualRCVFE & ActualRCVPE; 

  NextUTFR        <= RXBUSY & iTXBUSY & TXFF & TXHE & TXFE & RXFF & RXHF & RXFE;


  NextUTINTR      <=  ((RTIS or TIS or RIS or MIS or UARTEINTR) xor  UARTINTR)  & "0" 
                      & UARTEINTR & UARTINTR & RTIS & TIS & RIS & MIS;

  NextUTCHECKPINS <=  nUARTOut2 & nUARTOut1 & nUARTRTS & nUARTDTR & nSIROUT & UARTTXD;
 

  NextUTDMACR     <=  UARTRXDMABREQ & UARTTXDMABREQ & UARTRXDMASREQ &
                      UARTTXDMASREQ & "00";
 
--------------------------------------------------------------------------------
-- Increment the Read pointer in the RX FIFO after every read from
-- the UTDR register i.e.  after every read from the Receive FIFO
--------------------------------------------------------------------------------
  RXFRdPtrInc <= PENABLE and UTDRrd;

-- Output Mux     
  NextPRDATA <=  RXFRdData                   when (UTDRrd = '1') 
             else 
                 "000000" & UTRSR            when (UTRSRrd = '1') 
             else 
                 UTLCRH                      when (UTLCRHrd = '1') 
             else
                 UTLCRM                      when (UTLCRMrd = '1') 
             else
                 UTLCRL                      when (UTLCRLrd = '1') 
             else
                 UTCR                        when (UTCRrd = '1') 
             else
                 UTFR                        when (UTFRrd = '1') 
             else
                 UTINTR                      when (UTINTRrd = '1') 
             else
                 UTILPR                      when (UTILPRrd = '1') 
             else
                 "0000000" & UTFREQCTRERR    when (UTFREQCTRERRrd = '1') 
             else
                 UTFORCEDERRS                when (UTFORCEDERRSrd = '1') 
             else
                  UTSETPINS                  when (UTSETPINSrd = '1') 
             else
                 "00" & UTCHECKPINS          when (UTCHECKPINSrd = '1') 
             else
                 UTBITSFTDATA                when (UTBITSFTDATArd = '1') 
             else
                 "00" & UTBITSFTDATA2        when (UTBITSFTDATA2rd = '1')
             else
                 "00" & PCLKOn & REFCLKOn & RSTMODEREG
                                             when (RSTMODEREGrd = '1')
             else
                 "00" & UTDMACR              when (UTDMACRrd = '1') 
             else
                  UTSTPARITY                 when (UTSTPARITYrd = '1') 
              else
                  "00" & UTFBRD              when (UTFBRDrd = '1') 
            else
                 "00000000";

--------------------------------------------------------------------------------
-- Multiplexing Parity and Frame Errors of the Uart and Irda modules in 
-- trickbox
--------------------------------------------------------------------------------
p_modeComb : process(UTCR, IrdaRCVPE, IrdaRCVFE, RCVFE, RCVPE, IrdaRXBUSY,
            IrdaTXBUSY,IrdaTXFRdPtrInc, UartRXBUSY, UartTXBUSY, UartTXFRdPtrInc)
begin
  if (UTCR(0) = '1')then
    if (UTCR(1) = '1') then
      RXBUSY      <= IrdaRXBUSY;
      iTXBUSY     <= IrdaTXBUSY;
      TXFRdPtrInc <= IrdaTXFRdPtrInc; 
      ActualRCVFE <= IrdaRCVFE;
      ActualRCVPE <= IrdaRCVPE;
    else
      RXBUSY      <= UartRXBUSY;
      iTXBUSY     <= UartTXBUSY;
      TXFRdPtrInc <= UartTXFRdPtrInc;
      ActualRCVPE <= RCVPE;
      ActualRCVFE <= RCVFE;
     end if;
   else
     ActualRCVFE  <= '0';
     ActualRCVPE  <= '0';
   end if;
end process p_modeComb;
 
--------------------------------------------------------------------------------
-- Output register . This register is the APB data register from which all
-- the other registers can be read 
--------------------------------------------------------------------------------
  p_RdSeq : process (PCLK, PRESETn)
  begin
    if (PRESETn = '0') then
      PRDATA  <= (others => '0');
    elsif (PCLK'event and PCLK = '1') then
      PRDATA  <= NextPRDATA;
    end if;
  end process p_RdSeq;
   
--------------------------------------------------------------------------------
-- Output register . This register stores  the current status of UUT
-- interrupt pins and also stores the combined interrupt generated from
-- the other UUT interrupts 
--------------------------------------------------------------------------------
  p_IntSeq : process (PCLK, PRESETn)
  begin
    if(PRESETn = '0') then
      UTINTR   <= "00000000";
    elsif(PCLK'event and PCLK = '1') then
        UTINTR <= NextUTINTR;
    end if;
  end process p_IntSeq;
 
--------------------------------------------------------------------------------
-- Output register . This register stores the status of trickbox flags 
--------------------------------------------------------------------------------
  p_FRSeq : process (PCLK, PRESETn)
  begin
    if (PRESETn = '0') then
      UTFR  <= (others => '0');
    elsif (PCLK'event and PCLK = '1') then
      UTFR  <= NextUTFR;
    end if;
  end process p_FRSeq;
 
--------------------------------------------------------------------------------
-- Output register . This register stores the status of errors during 
-- baud rate measurement 
--------------------------------------------------------------------------------
  p_CTRSeq : process (PCLK, PRESETn)
  begin
    if (PRESETn = '0') then
      UTFREQCTRERR  <=  '0';
    elsif (PCLK'event and PCLK = '1') then
      UTFREQCTRERR  <= FREQERR;
    end if;
  end process p_CTRSeq;
 
--------------------------------------------------------------------------------
-- Output register . This register stores the status of Trickbox transmitted 
-- data in all the modes  
--------------------------------------------------------------------------------
  p_PINSSeq : process (PCLK, PRESETn)
  begin
    if (PRESETn = '0') then
      UTCHECKPINS  <= (others => '0');
    elsif (PCLK'event and PCLK = '1') then
      UTCHECKPINS  <= NextUTCHECKPINS;
    end if;
  end process p_PINSSeq;
 
--------------------------------------------------------------------------------
-- Output register . This register stores the parity and stop bit errors 
-- in the received data in all the modes 
--------------------------------------------------------------------------------
  p_RXSSeq : process (PCLK, PRESETn)
  begin
    if (PRESETn = '0') then
      UTRSR  <=  (others => '0');
    elsif (PCLK'event and PCLK = '1') then
      UTRSR  <= NextUTRSR;
    end if;
  end process p_RXSSeq;
 
--------------------------------------------------------------------------------
-- Output register . This register stores the DMA request signals and
-- the DMA clear signals.
--------------------------------------------------------------------------------
  p_DMASeq : process (PCLK, PRESETn)
  begin
    if (PRESETn = '0') then
      UTDMACR  <=  (others => '0');
    elsif (PCLK'event and PCLK = '1') then
      UTDMACR  <= NextUTDMACR;
    end if;
  end process p_DMASeq;
 
--------------------------------------------------------------------------------

end synth;

--========================== End of UartTrApbif ================================--




