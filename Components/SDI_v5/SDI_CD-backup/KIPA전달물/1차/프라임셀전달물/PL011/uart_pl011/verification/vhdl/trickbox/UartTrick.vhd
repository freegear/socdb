-- ========================================================================== 
--  This confidential and proprietary software may be used only as
--  authorised by a licensing agreement from ARM Limited
--    (C) COPYRIGHT 1998-2000 ARM Limited
--        ALL RIGHTS RESERVED
--  The entire notice above must be reproduced on all authorised
--  copies and copies may only be made to the extent permitted
--  by a licensing agreement from ARM Limited.
-----------------------------------------------------------------------------
--  
--  Version and Release Control Information:
--  
--  File Name              : UartTrick.vhd.rca
--  File Revision          : 1.8
--  
--  Release Information    : PrimeCell(TM)-PL011-REL1v3
--  
--------------------------------------------------------------------------------
--  Purpose  : This module is the top level entity of the VHDL  trickbox 
--
-- ========================================================================== --

library IEEE;
use     IEEE.STD_LOGIC_1164.all;

--- ----------------------------------------------------------------------------

entity UartTrick is
  port (
        PCLK          : in  std_logic;   -- APB bus signal
        PRESETn       : in  std_logic;   -- APB bus signal
        PENABLE       : in  std_logic;   -- APB bus signal
        PSELT         : in  std_logic;   -- APB bus signal
        PWRITE        : in  std_logic;   -- APB bus signal
        PADDR         : in  std_logic_vector(7 downto 2);  -- APB bus signal
        PWData        : in  std_logic_vector(7 downto 0);  -- APB bus signal
        UARTTXD       : in  std_logic;  -- UUT's TXD & Trickbox's RXD
        nSIROUT       : in  std_logic;  -- UUT's SIROUT & Trickbox's SIRIN
        nUARTOut2     : in  std_logic;  -- Modem signal
        nUARTOut1     : in  std_logic;  -- Modem signal
        nUARTRTS      : in  std_logic;  -- Modem signal
        nUARTDTR      : in  std_logic;  -- Modem signal
        UARTMSINTR    : in  std_logic;  -- UART Modem Status Interrupt Signal
        UARTRXINTR    : in  std_logic;  -- UART RX Interrupt Signal
        UARTTXINTR    : in  std_logic;  -- UART TX Interrupt Signal
        UARTRTINTR    : in  std_logic;  -- UART Timeout Interrupt Signal
        UARTINTR      : in  std_logic;  -- UART Combined Interrupt Signal
        UARTEINTR     : in  std_logic;  -- UART Error Combined Interrupt Signal
        UARTTXDMASREQ : in  std_logic;-- Transmit DMA single request
        UARTTXDMABREQ : in  std_logic; -- Transmit DMA burst request
        UARTRXDMASREQ : in  std_logic; -- Receive DMA single request
        UARTRXDMABREQ : in  std_logic; -- Receive DMA burst request
        UARTRXD       : out std_logic;  -- UUT's RXD & Trickbox's TXD
        SIRIN         : out std_logic;  -- UUT's SIRIN  & Trickbox's SIROUT
        PRData        : out std_logic_vector(7 downto 0);  -- APB bus signal
        nUARTRST      : out std_logic;   -- Uart Reset
        UARTCLK       : out std_logic;   -- Uart Clock
        nUARTRI       : out std_logic;   -- UART Modem Control Signal
        nUARTCTS      : out std_logic;   -- UART Modem Control Signal
        nUARTDCD      : out std_logic;   -- UART Modem Control Signal
        nUARTDSR      : out std_logic;   -- UART Modem Control Signal
        SCANMODE      : out std_logic;   -- SCAN-specific signal
        UARTTXDMACLR  : out std_logic;     -- Transmit DMA request clear
        UARTRXDMACLR  : out std_logic     -- Receive DMA request clear
       );
end UartTrick;

-- -----------------------------------------------------------------------------
--
--                                UartTrickbox
--                                ============
--
-- -----------------------------------------------------------------------------
--
--  Overview
--  ========
--
--    This block is the top level of the UART. This block instantiates the
-- functional sub-blocks in the UART.

--=============================== ARCHITECTURE ===============================--

architecture structural of UartTrick is

-- -----------------------------------------------------------------------------
-- Signal declarations
-- -----------------------------------------------------------------------------
-- UART Transmitter
signal PWDATAIn          : std_logic_vector(7 downto 0);
-- Input data from APB Bus

signal UTILPRWrEn        : std_logic; 
-- ILPR Reg Write Enable

signal UTLCRHWrEn        : std_logic; 
-- LCRH Reg Write Enable

signal UTLCRMWrEn        : std_logic; 
-- LCRM Reg Write Enable

signal UTLCRLWrEn        : std_logic;
-- LCRL Reg Write Enable

signal UTCRWrEn          : std_logic;
-- Control Reg Write Enable

signal UTFORCEDERRSWrEn  : std_logic;
-- FORCED Errors  Reg Write Enable

signal UTSETPINSWrEn     : std_logic;
-- SETPINS  Reg Write Enable

signal UTBITSFTDATAWrEn  : std_logic;
-- Shift Pulse Reg Write Enable

signal UTSFTDATA2WrEn    : std_logic;
-- Shift Pulse second  Reg Write Enable

signal UTCLKREGWrEn      : std_logic;
-- Uart Clock Reg Write Enable

signal RSTMODEREGWrEn    : std_logic;
-- Reset Reg Write Enable

signal UTDMACRWrEn       : std_logic;
-- UT DMA Control Reg Write Enable

signal UTSTPARITYWrEn    : std_logic;
-- UT STPARITY Reg Write Enable

signal UTFBRDWrEn        : std_logic;
-- UTFBRD Reg Write Enable

signal RXFRdData         : std_logic_vector(10 downto 0);
-- Data read out to APB bus from RX FIFO

signal UTFORCEDERRS      : std_logic_vector(7 downto 0); 
-- Forced Errors Register

signal UTLCRH            : std_logic_vector(7 downto 0);
-- Line Control Register

signal UTLCRM            : std_logic_vector(7 downto 0);
-- Line Control Register

signal UTLCRL            : std_logic_vector(7 downto 0);
-- Line Control Register

signal UTILPR            : std_logic_vector(7 downto 0);
-- Low Power Register

signal UTCR              : std_logic_vector(7 downto 0);
-- Trickbox Control Register

signal UTSETPINS         : std_logic_vector(7 downto 0);
-- Set Pins Register

signal UTBITSFTDATA      : std_logic_vector(7 downto 0);
-- Shift Pulse status register

signal UTBITSFTDATA2     : std_logic_vector(5 downto 0);
-- Shift Pulse status register 2

signal UTCLKREG          : std_logic_vector(7 downto 0);
-- Uart Clock Register

signal RSTMODEREG        : std_logic_vector(3 downto 0);
-- Resetmode Register

signal UTDMACR           : std_logic_vector(1 downto 0);
-- Trickbox DMA Control Register

signal UTSTPARITY        : std_logic_vector(7 downto 0);
-- Trickbox STPARITY  Register

signal UTFBRD            : std_logic_vector(5 downto 0);
-- Trickbox FBRD  Register

signal RXFIFOData        : std_logic_vector(10 downto 0);
-- Data written into RX FIFO

signal IrdaRXFWr         : std_logic;
-- Write to RX FIFO from Irda mode

signal IrdaRXFIFOData    : std_logic_vector(10 downto 0);
-- Data written into RX FIFO in Irda mode

signal RXFRdPtrInc       : std_logic;
-- Increment Read pointer

signal TXFRdPtrInc       : std_logic;
-- Increment TX FIFO Read Pointer

signal RdPtrIncDone      : std_logic;
-- Rd Ptr Inc done in TX FIFO

signal TXShiftData       : std_logic_vector(7 downto 0);
-- Transmit Shift Register data

signal nSIRIN            : std_logic;
-- Internal version of SIRIN

signal TXFF              : std_logic;
-- TX FIFO Full

signal TXFE              : std_logic;
-- TX FIFO Empty

signal TXDataAvlbl       : std_logic;
-- Transmit Data available in TX FIFO

signal TXD               : std_logic;
-- Transmitted Data

signal UartRXBUSY        : std_logic;
-- Reception in progress in normal mode

signal IrdaRXBUSY        : std_logic;
-- Reception in progress in Irda mode

signal nUARTRES          : std_logic;
-- Uart Reset

signal PCLKOn            : std_logic;
-- Routing PCLK

signal REFCLKOn          : std_logic;
-- Routing UartClk

signal ClkPeriod         : std_logic_vector(7 downto 0);        
-- Clock Width

signal RESETBIT          : std_logic;        
-- Uart Reset status

signal UTDRWrEn          : std_logic;
-- Trickbox DR Write Enable

signal IrdaRCVPE         : std_logic;
-- Parity Error in Irda mode

signal IrdaRCVFE         : std_logic;
-- Parity Error in Irda mode

signal RCVPE             : std_logic;
-- Parity Error in Normal  mode

signal RCVFE             : std_logic;
-- Parity Error in Normal  mode

signal TXHE              : std_logic;
-- TX FIFO Half Empty

signal RXHF              : std_logic;
-- RX FIFO Half Full

signal RXFF              : std_logic;
-- RX FIFO Full

signal RXFE              : std_logic;
-- RX FIFO Empty

signal RTIS              : std_logic;
-- Receive Timeout Interrupt Status

signal TIS               : std_logic;
-- Transmit Interrupt Status

signal RIS               : std_logic;
-- Receive Interrupt Status

signal MIS               : std_logic;
-- Modem Interrupt Status

signal SPNUM             : std_logic_vector(2 downto 0);
-- Starting Pulse to be jittered

signal EPNUM             : std_logic_vector(2 downto 0);
-- Last Pulse number upto which pulses are jittered

signal SHFT              : std_logic_vector(1 downto 0);
-- Shift factor

signal PSHFT             : std_logic_vector(2 downto 0);
-- Pulse Shift factor

signal PNUM              : std_logic_vector(2 downto 0);
-- Pulse number to be jittered

signal FREQERR           : std_logic;
-- Frequency Baud width in Error

signal Divisor           : std_logic_vector(15 downto 0); 
-- Uart baud Rate

signal FracDiv           : std_logic_vector(5 downto 0); 
-- Fractional part of Uart baud Rate

signal Mode              : std_logic_vector(1 downto 0);
-- Trickbox operation mode

signal iUARTCLK          : std_logic;
-- Internal version of UartClock

signal RXFWr             : std_logic;
-- RX FIFO Frame Write

signal RXFWrDone         : std_logic;
-- RX FIFO Frame write over

signal TXBUSY            : std_logic;
-- Transmission in Progress

signal UartTXBUSY        : std_logic;
-- Transmission in Progress in Normal mode

signal IrdaTXBUSY        : std_logic;
-- Transmission in Progress in Irda mode

signal UartTXFRdPtrInc   : std_logic;
-- TX FIFO ReadPtr to br incremented in Normal mode

signal IrdaTXFRdPtrInc   : std_logic;
-- TX FIFO ReadPtr to br incremented in Irda mode

signal TXDMACLRStag4     : std_logic;
 -- For generating UARTTXDMACLR

signal RXDMACLRStag4     : std_logic;
 -- For generating UARTRXDMACLR

--------------------------------------------------------------------------------
-- Component declarations
--------------------------------------------------------------------------------

component UartTrClk
  port (
        PCLK        : in  std_logic;        
        PRESETn     : in  std_logic;
        ClkPeriod   : in  std_logic_vector(7 downto 0);  
        UartClk     : out std_logic;        
        PCLKOn      : out std_logic;
        REFCLKOn    : out std_logic;
        RESETBIT    : in  std_logic;       
        RSTMODEREG  : in  std_logic_vector(3 downto 0);
        nUARTRST    : out std_logic       
       );
end  component;

component UartTrApbif 
  port (
        PCLK               : in  std_logic;      
        PRESETn            : in  std_logic;     
        PSELT              : in  std_logic;    
        PENABLE            : in  std_logic;   
        PWRITE             : in  std_logic; 
        PADDR              : in  std_logic_vector(7 downto 2);  
        PWDATA             : in  std_logic_vector(7 downto 0); 
        nSIROUT            : in  std_logic;
        nUARTOut2          : in  std_logic;
        nUARTOut1          : in  std_logic;
        nUARTRTS           : in  std_logic;
        nUARTDTR           : in  std_logic;
        UARTTXD            : in  std_logic;     
        UTLCRH             : in  std_logic_vector(7 downto 0);  
        UTLCRM             : in  std_logic_vector(7 downto 0); 
        UTLCRL             : in  std_logic_vector(7 downto 0); 
        UTBITSFTDATA       : in  std_logic_vector(7 downto 0);
        UTBITSFTDATA2      : in  std_logic_vector(5 downto 0);
        RCVPE              : in  std_logic;
        RCVFE              : in  std_logic;
        IrdaRCVPE          : in  std_logic;
        IrdaRCVFE          : in  std_logic;
        PCLKOn             : in  std_logic;
        REFCLKOn           : in  std_logic;
        TXFF               : in  std_logic;     
        RXFF               : in  std_logic;
        RXFE               : in  std_logic;    
        TXHE               : in  std_logic;
        TXFE               : in  std_logic;
        RXHF               : in  std_logic;
        TXBUSY             : out std_logic;
        UartRXBUSY         : in  std_logic;
        UartTXBUSY         : in  std_logic;  
        IrdaRXBUSY         : in  std_logic;
        IrdaTXBUSY         : in  std_logic; 
        TXFRdPtrInc        : out std_logic;
        IrdaTXFRdPtrInc    : in  std_logic;
        UartTXFRdPtrInc    : in  std_logic;
        UARTINTR           : in  std_logic;
        UARTEINTR          : in  std_logic;
        RTIS               : in  std_logic;
        TIS                : in  std_logic;
        RIS                : in  std_logic;
        MIS                : in  std_logic;
        SPNUM              : in  std_logic_vector(2 downto 0);
        EPNUM              : in  std_logic_vector(2 downto 0);
        SHFT               : in  std_logic_vector(1 downto 0);
        PNUM               : in  std_logic_vector(2 downto 0);
        PSHFT              : in  std_logic_vector(2 downto 0);
        RXFRdData          : in  std_logic_vector(7 downto 0);
        UTCR               : in  std_logic_vector(7 downto 0);
        UTSTPARITY         : in  std_logic_vector(7 downto 0);
        UTFBRD             : in  std_logic_vector(5 downto 0);
        UTILPR             : in  std_logic_vector(7 downto 0);   
        FREQERR            : in  std_logic;      
        UTFORCEDERRS       : in  std_logic_vector(7 downto 0); 
        UTSETPINS          : in  std_logic_vector(7 downto 0);    
        RSTMODEREG         : in  std_logic_vector(3 downto 0);
        UARTTXDMASREQ      : in   std_logic;
        UARTTXDMABREQ      : in   std_logic;
        UARTRXDMASREQ      : in   std_logic;
        UARTRXDMABREQ      : in   std_logic;
        UTDRWrEn           : out std_logic;       
        UTLCRHWrEn         : out std_logic;    
        UTLCRMWrEn         : out std_logic;   
        UTLCRLWrEn         : out std_logic;  
        UTCRWrEn           : out std_logic;      
        UTILPRWrEn         : out std_logic;   
        UTFORCEDERRSWrEn   : out std_logic;    
        UTSETPINSWrEn      : out std_logic;  
        UTBITSFTDATAWrEn   : out std_logic;     
        UTSFTDATA2WrEn     : out std_logic;  
        UTCLKREGWrEn       : out std_logic;        
        RSTMODEREGWrEn     : out std_logic;    
        UTDMACRWrEn        : out std_logic;  
        UTSTPARITYWrEn     : out std_logic;  
        UTFBRDWrEn         : out std_logic;  
        RXFRdPtrInc        : out std_logic;
        PWDATAIn           : out std_logic_vector(7 downto 0);  
        PRDATA             : out std_logic_vector(7 downto 0)  
       );
end component;

component UartTrRegBlock 
  port (
        PCLK               : in  std_logic;        
        PRESETn            : in  std_logic; 
        Mode               : out std_logic_vector(1 downto 0);     
        UTILPRWrEn         : in  std_logic;       
        UTLCRHWrEn         : in  std_logic;       
        UTLCRMWrEn         : in  std_logic;     
        UTLCRLWrEn         : in  std_logic;       
        UTCRWrEn           : in  std_logic;       
        UTFORCEDERRSWrEn   : in  std_logic;  
        UTSETPINSWrEn      : in  std_logic;
        UTBITSFTDATAWrEn   : in  std_logic;       
        UTSFTDATA2WrEn     : in  std_logic;        
        UTCLKREGWrEn       : in  std_logic;       
        RSTMODEREGWrEn     : in  std_logic;       
        UTDMACRWrEn        : in  std_logic;
        UTSTPARITYWrEn     : in  std_logic;
        UTFBRDWrEn         : in  std_logic;
        PWDATAIn           : in  std_logic_vector(7 downto 0);    
        TXDMACLRStag4      : in  std_logic; 
        RXDMACLRStag4      : in  std_logic; 
        UTFORCEDERRS       : out std_logic_vector(7 downto 0);       
        UTLCRH             : out std_logic_vector(7 downto 0); 
        UTLCRM             : out std_logic_vector(7 downto 0);    
        UTLCRL             : out std_logic_vector(7 downto 0);    
        UTILPR             : out std_logic_vector(7 downto 0);    
        UTCR               : out std_logic_vector(7 downto 0);    
        UTSETPINS          : out std_logic_vector(7 downto 0);
        UTBITSFTDATA       : out std_logic_vector(7 downto 0);
        UTBITSFTDATA2      : out std_logic_vector(5 downto 0);
        UTCLKREG           : out std_logic_vector(7 downto 0);
        RSTMODEREG         : out std_logic_vector(3 downto 0);
        UTDMACR            : out std_logic_vector(1 downto 0);
        UTSTPARITY         : out std_logic_vector(7 downto 0);
        UTFBRD             : out std_logic_vector(5 downto 0)
       );
end component;
 
component UartTrBaud 
  port (
        UARTCLK      : in  std_logic;  
        Mode         : in  std_logic_vector(1 downto 0);
        RXD          : in  std_logic;
        SIRIN        : in  std_logic;
        CLKPERIOD    : in  std_logic_vector(7 downto 0);
        Divisor      : in  std_logic_vector(15 downto 0);
        FracDiv      : in  std_logic_vector(5 downto 0);
        IRLPDivisor  : in  std_logic_vector(7 downto 0);
        FRENABLE     : in  std_logic;
        FREQERR      : out std_logic
       );
end component;
 
component UartTrRX
  port (
        UARTCLK        : in  std_logic;
        nUARTRES       : in  std_logic;
        RXD            : in  std_logic;
        UARTEN         : in  std_logic;
        RXFWrDone      : in  std_logic;
        RXBUSY         : out std_logic;
        RXFWr          : out std_logic;
        RXFIFOData     : out std_logic_vector(10 downto 0);
        RCVFE          : out std_logic;
        RCVPE          : out std_logic;
        FEN            : in  std_logic;
        WLEN           : in  std_logic_vector(1 downto 0);
        STP2           : in  std_logic;
        EPS            : in  std_logic;
        PEN            : in  std_logic;
        SPS            : in  std_logic;
        Mode           : in  std_logic_vector(1 downto 0);
        Divisor        : in  std_logic_vector(15 downto 0);
        FracDiv        : in  std_logic_vector(5 downto 0);
        RxJitterSign   : in  std_logic;
        RxJitterFactor : in  std_logic_vector(1 downto 0)
       );
end component;

component UartTrRXFIFO
  port(
       PCLK           : in  std_logic;     
       PRESETn        : in  std_logic;     
       IrdaRXFWr      : in std_logic;
       IrdaRXFIFOData : in  std_logic_vector(10 downto 0);
       RXFWr          : in  std_logic;      
       RXFRdPtrInc    : in  std_logic;     
       RXFIFOData     : in  std_logic_vector(10 downto 0);  
       FEN            : in  std_logic;     
       RXFWrDone      : out std_logic;      
       RXHF           : out std_logic;
       UTCR           : in  std_logic_vector(1 downto 0);
       RXFE           : out std_logic;      
       RXFF           : out std_logic;     
       RXFRdData      : out std_logic_vector(10 downto 0)  
      );
end component;
 
component UartTrIrdaRX
  port (
        UARTCLK        : in  std_logic;
        nUARTRES       : in  std_logic;
        nSIRIN         : in  std_logic;
        IRLPDivisor    : in  std_logic_vector(7 downto 0);
        UARTEN         : in  std_logic;
        RXFWr          : out std_logic;
        RXFIFOData     : out std_logic_vector(10 downto 0);
        RXFWrDone      : in  std_logic;
        RXBUSY         : out std_logic;
        RCVFE          : out std_logic;
        RCVPE          : out std_logic;
        FEN            : in  std_logic;
        WLEN           : in  std_logic_vector(1 downto 0);
        STP2           : in  std_logic;
        EPS            : in  std_logic;
        PEN            : in  std_logic;
        Mode           : in  std_logic_vector(1 downto 0);
        Divisor        : in  std_logic_vector(15 downto 0);
        RxJitterSign   : in  std_logic;
        RxJitterFactor : in  std_logic_vector(1 downto 0);
        FracDiv        : in  std_logic_vector(5 downto 0)
       );
end component;

component UartTrIrdaTX 
  port (
        UARTCLK        : in  std_logic; 
        nUARTRES       : in  std_logic;
        TXDataAvlbl    : in  std_logic;     
        UTSETPINS      : in  std_logic;
        UTLCRH         : in  std_logic_vector(7 downto 0);
        IRDADEC        : in  std_logic_vector(3 downto 0);
        UTBITSFTDATA   : in  std_logic_vector(7 downto 0);
        UTBITSFTDATA2  : in  std_logic_vector(5 downto 0);
        UARTEN         : in  std_logic;  
        WLEN           : in  std_logic_vector(1 downto 0);     
        EPS            : in  std_logic; 
        Mode           : in  std_logic_vector(1 downto 0);
        Divisor        : in  std_logic_vector(15 downto 0);
        RdPtrIncDone   : in  std_logic;
        SIROUT         : out std_logic;
        IRLPDivisor    : in  std_logic_vector(7 downto 0);
        TxJitterSign   : in  std_logic;
        TxJitterFactor : in  std_logic_vector(1 downto 0);
        TXShiftData    : in  std_logic_vector(7 downto 0);     
        TXFRdPtrInc    : out std_logic;    
        PEEN           : in  std_logic;
        FEEN           : in  std_logic;
        TXBUSY         : out std_logic      
       ); 
end component;

component UartTrTXFIFO
  port (
       PCLK         : in  std_logic;     
       PRESETn      : in  std_logic;    
       UARTEN       : in  std_logic;   
       UARTDRWrEn   : in  std_logic; 
       TXFRdPtrInc  : in  std_logic;
       RdPtrIncDone : out std_logic;
       FEN          : in  std_logic;    
       TXBUSY       : in  std_logic;   
       PWDATAIn     : in  std_logic_vector(7 downto 0); 
       TXFF         : out std_logic;      
       TXFE         : out std_logic;    
       TXHE         : out std_logic;   
       TXShiftData  : out std_logic_vector(7 downto 0);  
       TXDataAvlbl  : out std_logic    
       );
end component;
 
component UartTrTX
  port (
        UARTCLK        : in  std_logic;
        nUARTRES       : in  std_logic;
        UTSETPINS      : in  std_logic;
        TXDataAvlbl    : in  std_logic;
        TXD            : out std_logic;
        TXFRdPtrInc    : out std_logic;
        UTLCRH         : in  std_logic_vector(7 downto 0);
        Mode           : in  std_logic_vector(1 downto 0);
        Divisor        : in  std_logic_vector(15 downto 0);
        TxJitterSign   : in  std_logic;
        TxJitterFactor : in  std_logic_vector(1 downto 0);
        UARTEN         : in  std_logic;
        WLEN           : in  std_logic_vector(1 downto 0);
        EPS            : in  std_logic;
        TXBUSY         : out std_logic;
        RdPtrIncDone   : in  std_logic;
        PEEN           : in  std_logic;
        FEEN           : in  std_logic;
        SPS            : in  std_logic;
        TXShiftData    : in  std_logic_vector(7 downto 0)
       );
end component;

component UartTrDMA
  port (
        PCLK          :	in  std_logic; 
        PRESETn       :	in  std_logic;
        TXDMACLRStag1 : in  std_logic; 
        RXDMACLRStag1 : in  std_logic; 
        UARTTXDMACLR  : out std_logic;
        UARTRXDMACLR  : out std_logic;
        TXDMACLRStag4 : out std_logic; 
        RXDMACLRStag4 : out std_logic 
       );
end component;

--------------------------------------------------------------------------------
--
-- Main body of code
-- =================
--
--------------------------------------------------------------------------------

begin
--------------------------------------------------------------------------------
-- Internal versions of output(s)...
 UARTCLK  <= iUARTCLK;
 nUARTRST <= nUARTRES;
 nUARTCTS <= UTSETPINS(0);
 nUARTDCD <= UTSETPINS(1);
 nUARTDSR <= UTSETPINS(2);
 nUARTRI  <= UTSETPINS(5);
 SCANMODE <= UTSETPINS(7);
 Divisor  <= UTLCRM & UTLCRL;
 FracDiv  <= UTFBRD;
 UARTRXD  <= TXD;
 SIRIN    <= nSIRIN;
--------------------------------------------------------------------------------

--Generating Uart Clock
 uUartTrClk : UartTrClk
 port map (
   PCLK       => PCLK,
   PRESETn    => PRESETn,
   ClkPeriod  => UTCLKREG,
   RSTMODEREG => RSTMODEREG,
   UartClk    => iUARTCLK,
   PCLKOn     => PCLKOn,
   REFCLKOn   => REFCLKOn,
   RESETBIT   => RSTMODEREG(0),
   nUARTRST   => nUARTRES 
  );
 
-- Register block for normal mode registers
 uUartTrRegBlock: UartTrRegBlock
 port map (
     PCLK                => PCLK
     , PRESETn           => PRESETn
     , Mode              => Mode
     , UTILPRWrEn        => UTILPRWrEn
     , UTLCRHWrEn        => UTLCRHWrEn
     , UTLCRMWrEn        => UTLCRMWrEn 
     , UTLCRLWrEn        => UTLCRLWrEn 
     , UTCRWrEn          => UTCRWrEn 
     , UTFORCEDERRSWrEn  => UTFORCEDERRSWrEn
     , UTSETPINSWrEn     => UTSETPINSWrEn
     , UTBITSFTDATAWrEn  => UTBITSFTDATAWrEn 
     , UTSFTDATA2WrEn    => UTSFTDATA2WrEn
     , UTCLKREGWrEn      => UTCLKREGWrEn
     , RSTMODEREGWrEn    => RSTMODEREGWrEn
     , UTDMACRWrEn       => UTDMACRWrEn
     , UTSTPARITYWrEn    => UTSTPARITYWrEn
     , UTFBRDWrEn        => UTFBRDWrEn
     , PWDATAIn          => PWDATAIn
     , TXDMACLRStag4     => TXDMACLRStag4
     , RXDMACLRStag4     => RXDMACLRStag4
     , UTFORCEDERRS      => UTFORCEDERRS
     , UTLCRH            => UTLCRH 
     , UTLCRM            => UTLCRM 
     , UTLCRL            => UTLCRL 
     , UTILPR            => UTILPR 
     , UTCR              => UTCR
     , UTSETPINS         => UTSETPINS
     , UTBITSFTDATA      => UTBITSFTDATA
     , UTBITSFTDATA2     => UTBITSFTDATA2 
     , UTCLKREG          => UTCLKREG 
     , RSTMODEREG        => RSTMODEREG 
     , UTDMACR           => UTDMACR
     , UTSTPARITY        => UTSTPARITY
     , UTFBRD            => UTFBRD
   );
 
 
-- This block provides the interface to the APB bus
 uUartTrApbif: UartTrApbif
 port map (
     PCLK               => PCLK
     , PRESETn          => PRESETn
     , PENABLE          => PENABLE
     , PSELT            => PSELT
     , PWRITE           => PWRITE
     , PADDR            => PADDR
     , PWDATA           => PWDATA
     , UTLCRHWrEn       => UTLCRHWrEn
     , UTLCRMWrEn       => UTLCRMWrEn
     , UTLCRLWrEn       => UTLCRLWrEn
     , PWDATAIn         => PWDATAIn
     , UTDRWrEn         => UTDRWrEn
     , UTCRWrEn         => UTCRWrEn
     , UTSETPINSWrEn    => UTSETPINSWrEn
     , RSTMODEREGWrEn   => RSTMODEREGWrEn
     , UTDMACRWrEn      => UTDMACRWrEn
     , UTSTPARITYWrEn   => UTSTPARITYWrEn
     , UTFBRDWrEn       => UTFBRDWrEn
     , UTCLKREGWrEn     => UTCLKREGWrEn
     , UTFORCEDERRSWrEn => UTFORCEDERRSWrEn
     , UTBITSFTDATAWrEn => UTBITSFTDATAWrEn
     , UTSFTDATA2WrEn   => UTSFTDATA2WrEn
     , UTLCRH           => UTLCRH
     , UTLCRM           => UTLCRM
     , PRDATA           => PRDATA
     , PCLKOn           => PCLKOn
     , REFCLKOn         => REFCLKOn
     , UTLCRL           => UTLCRL
     , UTBITSFTDATA     => UTBITSFTDATA
     , UTBITSFTDATA2    => UTBITSFTDATA2
     , RSTMODEREG       => RSTMODEREG
     , RCVPE            => RCVPE
     , RCVFE            => RCVFE
     , IrdaRCVFE        => IrdaRCVFE
     , IrdaRCVPE        => IrdaRCVPE
     , TXHE             => TXHE
     , RXHF             => RXHF
     , UTCR             => UTCR
     , TXFE             => TXFE
     , RXFF             => RXFF
     , TXFF             => TXFF
     , RXFE             => RXFE
     , TXFRdPtrInc      => TXFRdPtrInc
     , UartTXFRdPtrInc  => UartTXFRdPtrInc
     , IrdaTXFRdPtrInc  => IrdaTXFRdPtrInc
     , TXBUSY           => TXBUSY
     , UartRXBUSY       => UartRXBUSY 
     , UartTXBUSY       => UartTXBUSY
     , IrdaRXBUSY       => IrdaRXBUSY    
     , IrdaTXBUSY       => IrdaTXBUSY
     , UARTINTR         => UARTINTR
     , UARTEINTR        => UARTEINTR
     , RTIS             => UARTRTINTR 
     , TIS              => UARTTXINTR 
     , RIS              => UARTRXINTR 
     , MIS              => UARTMSINTR 
     , UARTTXDMASREQ    => UARTTXDMASREQ
     , UARTTXDMABREQ    => UARTTXDMABREQ
     , UARTRXDMASREQ    => UARTRXDMASREQ
     , UARTRXDMABREQ    => UARTRXDMABREQ
     , SPNUM            => SPNUM
     , EPNUM            => EPNUM
     , SHFT             => SHFT
     , PSHFT            => PSHFT
     , PNUM             => PNUM
     , RXFRdData        => RXFRdData(7 downto 0)
     , RXFRdPtrInc      => RXFRdPtrInc  
     , nSIROUT          => nSIROUT
     , nUARTOut2        => nUARTOut2
     , nUARTOut1        => nUARTOut1
     , nUARTRTS         => nUARTRTS
     , nUARTDTR         => nUARTDTR
     , UARTTXD          => UARTTXD 
     , UTILPRWrEn       => UTILPRWrEn
     , UTILPR           => UTILPR
     , FREQERR          => FREQERR 
     , UTFORCEDERRS     => UTFORCEDERRS 
     , UTSETPINS        => UTSETPINS
     , UTSTPARITY       => UTSTPARITY
     , UTFBRD           => UTFBRD
     );

 -- Uart Baudwidth Checker
 uUartTRBaud : UartTrBaud 
 port map (
     UARTCLK     => iUARTCLK      
   , Mode        => Mode 
   , RXD         => UARTTXD   
   , SIRIN       => nSIROUT  
   , CLKPERIOD   => UTCLKREG 
   , Divisor     => Divisor
   , FracDiv     => FracDiv  
   , IRLPDivisor => UTILPR 
   , FRENABLE    => UTCR(7) 
   , FREQERR     => FREQERR   
   );
 
 -- UART Receiver
 uUartTrRX : UartTrRX
 port map (
           RXD              => UARTTXD 
           , UARTCLK        => iUARTCLK
           , nUARTRES       => nUARTRES
           , RXBUSY         => UartRXBUSY
           , RXFWr          => RXFWr
           , RXFWrDone      => RXFWrDone
           , RXFIFOData     => RXFIFOData
           , WLEN           => UTLCRH(6 downto 5)
           , STP2           => UTLCRH(3)
           , EPS            => UTLCRH(2)
           , PEN            => UTLCRH(1)
           , SPS            => UTSTPARITY(7)
           , UARTEN         => UTCR(0)
           , RCVFE          => RCVFE 
           , RCVPE          => RCVPE 
           , Mode           => Mode 
           , Divisor        => Divisor
           , FracDiv        => FracDiv
           , RxJitterSign   => UTFORCEDERRS(7) 
           , RxJitterFactor => UTFORCEDERRS(6 downto 5)
           , FEN            => UTLCRH(4)
           );

 uUartTrRXFIFO: UartTrRXFIFO
 port map (
           PCLK           => PCLK ,
           PRESETn        => PRESETn ,
           RXFWr          => RXFWr ,
           IrdaRXFWr      => IrdaRXFWr ,
           IrdaRXFIFOData => IrdaRXFIFOData,
           RXFRdPtrInc    => RXFRdPtrInc ,
           RXFIFOData     => RXFIFOData ,
           FEN            => UTLCRH(4) ,
           UTCR           => UTCR(1 downto 0),
           RXFWrDone      => RXFWrDone ,
           RXFE           => RXFE ,
           RXFF           => RXFF ,
           RXHF           => RXHF,
           RXFRdData      => RXFRdData
           );
  
-- Transmit FIFO
 uUartTrTXFIFO: UartTrTXFIFO
 port map (
           UARTDRWrEn   => UTDRWrEn
         , PCLK         => PCLK
         , PWDATAIn     => PWDATAIn
         , TXFRdPtrInc  => TXFRdPtrInc
         , PRESETn      => PRESETn
         , FEN          => UTLCRH(4)
         , TXFF         => TXFF
         , TXHE         => TXHE
         , RdPtrIncDone => RdPtrIncDone
         , TXShiftData  => TXShiftData
         , TXDataAvlbl  => TXDataAvlbl
         , UARTEN       => UTCR(0)
         , TXFE         => TXFE
         , TXBUSY       => TXBUSY
         );

-- Irda Receiver
 uUartTrIrdaRX : UartTrIrdaRX
 port map (
           UARTCLK        => iUARTCLK
         , nUARTRES       => nUARTRES
         , RXBUSY         => IrdaRXBUSY
         , nSIRIN         => nSIROUT 
         , IRLPDivisor    => UTILPR
         , WLEN           => UTLCRH(6 downto 5)
         , EPS            => UTLCRH(2)
         , PEN            => UTLCRH(1)
         , STP2           => UTLCRH(3)
         , UARTEN         => UTCR(0)
         , RXFWr          => IrdaRXFWr
         , RXFWrDone      => RXFWrDone
         , RXFIFOData     => IrdaRXFIFOData
         , RCVFE          => IrdaRCVFE
         , RCVPE          => IrdaRCVPE
         , Mode           => Mode
         , Divisor        => Divisor
         , RxJitterSign   => UTFORCEDERRS(7)
         , RxJitterFactor => UTFORCEDERRS(6 downto 5)
         ,  FEN           => UTLCRH(4)
         , FracDiv      => FracDiv
        );
 
-- IRDA Transmitter
 uUartTrIrdaTX : UartTrIrdaTX
 port map (
           UartClk         => iUARTCLK
          , nUARTRES       => nUARTRES
          , TXDataAvlbl    => TXDataAvlbl
          , TXFRdPtrInc    => IrdaTXFRdPtrInc
          , TXBUSY         => IrdaTXBUSY
          , RdPtrIncDone   => RdPtrIncDone
          , UARTEN         => UTCR(0)
          , UTSETPINS      => UTSETPINS(4)
          , PEEN           => UTFORCEDERRS(0)
          , FEEN           => UTFORCEDERRS(1)
          , UTLCRH         => UTLCRH
          , IRDADEC        => UTCR(6 downto 3)
          , IRLPDivisor    => UTILPR
          , UTBITSFTDATA   =>  UTBITSFTDATA
          , UTBITSFTDATA2  => UTBITSFTDATA2
          , Mode           => Mode
          , Divisor        => Divisor
          , TxJitterSign   => UTFORCEDERRS(4)
          , TxJitterFactor =>  UTFORCEDERRS(3 downto 2)
          , SIROUT         => nSIRIN
          , WLEN           => UTLCRH(6 downto 5)
          , EPS            => UTLCRH(2)
          , TXShiftData    => TXShiftData
          );
 
-- UART Transmitter
 uUartTrTX : UartTrTX
 port map (
           UartClk          => iUARTCLK
           , nUARTRES       => nUARTRES
           , TXDataAvlbl    => TXDataAvlbl
           , TXD            => TXD
           , TXFRdPtrInc    => UartTXFRdPtrInc
           , TXBUSY         => UartTXBUSY
           , RdPtrIncDone   => RdPtrIncDone 
           , UARTEN         => UTCR(0)
           , UTSETPINS      => UTSETPINS(3)
           , UTLCRH         => UTLCRH
           , Mode           => Mode 
           , PEEN           => UTFORCEDERRS(0)   
           , FEEN           => UTFORCEDERRS(1)
           , SPS            => UTSTPARITY(7)
           , Divisor        => Divisor
           , TxJitterSign   => UTFORCEDERRS(4) 
           , TxJitterFactor => UTFORCEDERRS(3 downto 2)
           , WLEN           => UTLCRH(6 downto 5)
           , EPS            => UTLCRH(2)
           , TXShiftData    => TXShiftData
           );
 
 -- UART DMA Interface
  uUartTrDMA : UartTrDMA
  port map (
            PCLK            => PCLK
            , PRESETn       => PRESETn
            , TXDMACLRStag1 => UTDMACR(0) 
            , RXDMACLRStag1 => UTDMACR(1) 
            , UARTTXDMACLR  => UARTTXDMACLR
            , UARTRXDMACLR  => UARTRXDMACLR
            , TXDMACLRStag4 => TXDMACLRStag4
            , RXDMACLRStag4 => RXDMACLRStag4

            );
   
end structural;
