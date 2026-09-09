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
--  Filename            : KmiTrick.vhd,v
--
--  File Revision       : 1.3
--
--  Release Information : PL050-REL1v1
--
--  ----------------------------------------------------------------------------
--  Purpose: This file is top level for KMI TrickBox.
--
-- ----------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity KmiTrick is
  port (
        BnRES     : in  std_logic; -- APB Reset Signal
        PCLK      : in  std_logic; -- APB Clock
        PADDR     : in  std_logic_vector(7 downto 2); -- APB Address Bus
        PWDATA    : in  std_logic_vector(15 downto 0); -- APB Write Data Bus
        PSELT     : in  std_logic; -- APB Slave Select Signal
        PENABLE   : in  std_logic; -- APB Slave Enable
        PWRITE    : in  std_logic; -- Read/Write Signal
        PRDATA    : out std_logic_vector(15 downto 0); -- Read data Bus
        KDATAIN   : in  std_logic; -- Data input from PAD
        KDATAOUT  : out std_logic; -- Data output to PAD
        KMIRXINTR : in  std_logic; -- KMI Receive ierrupt
        KMITXINTR : in  std_logic; -- KMI transmit ierrupt
        KMIINTR   : in  std_logic; -- KMI Combined ierrupt 
        KCLKIN    : in  std_logic; -- Clock Input from PAD
        KCLKOUT   : out std_logic; -- Clock Output to the PAD
        SCANMODE  : out std_logic; -- SCANMODE Pin to KMI
        KMIREFCLK : out std_logic; -- KMI Refrence Clock Output
        nKMIRST   : out std_logic -- KMI Reset
       );
end KmiTrick; 
     
-- ---------------------------------------------------------------------------
--
--                               KmiTrick
--                               ========
--
-- ---------------------------------------------------------------------------
--
-- Overview
-- ========
-- This module is top level of KMI TrickBox. It instantiates different sub-
-- modules. It drives the non-AMBA inputs of KMI Controller and reads the 
-- non-AMBA outputs of the same. It also contains the synchronization 
-- mechanism for signals passing through one clock domain to another clock 
-- domain.
--
-- ---------------------------------------------------------------------------
--
-- ============================= ARCHITECTURE ================================
--

architecture behavioural of KmiTrick is

-- ---------------------------------------------------------------------------
-- Component declarations
-- ---------------------------------------------------------------------------
component KmiTrApbif 
  port(
       PCLK          : in std_logic;  
       BnRES         : in std_logic; 
       PADDR         : in std_logic_vector(7 downto 2); 
       PWDATA        : in std_logic_vector(15 downto 0);
       PENABLE       : in std_logic;
       PWRITE        : in std_logic;
       PSEL          : in std_logic;
       KmiTrRXREG    : in std_logic_vector(7 downto 0);
       KmiTrCnREG    : in std_logic_vector(4 downto 0);
       KmiTrREFCLKOn : in std_logic;
       KmiTrPCLKOn   : in std_logic;
       KmiTrDWIDTHERR: in std_logic;
       KmiTrTXBUSY   : in std_logic;
       KmiTrRXBUSY   : in std_logic;
       KmiTrFRAMEERR : in std_logic;
       KmiTrPARITYERR: in std_logic;
       KmiTrCLKL     : in std_logic_vector(8 downto 0);
       KmiTrCLKH     : in std_logic_vector(8 downto 0);
       KmiTrDSI      : in std_logic_vector(15 downto 0);
       KmiTrDHI      : in std_logic_vector(15 downto 0);
       KmiTrDSO      : in std_logic_vector(15 downto 0);
       KmiTrDHO      : in std_logic_vector(15 downto 0); 
       KmiTrREFCLK   : in std_logic_vector(7 downto 0); 
       KmiTrRG       : in std_logic_vector(15 downto 0);
       KmiTrRXFF     : in std_logic;
       KmiTrRXFE     : in std_logic;
       KmiTrRXFH     : in std_logic; 
       KmiTrTXFF     : in std_logic; 
       KmiTrTXFE     : in std_logic;
       KmiTrTXFH     : in std_logic;
       KMIINTR       : in std_logic; 
       KMIRXINTR     : in std_logic; 
       KMITXINTR     : in std_logic; 
       KDATAIN       : in std_logic; 
       KCLKIN        : in std_logic; 
       KmiTrTIMOUT   : in std_logic_vector(4 downto 0);
       KmiTrCLKDIV   : in std_logic_vector(7 downto 0);
       KmiTrMODEREG  : in std_logic_vector(3 downto 0);
       KmiTrDSOErr   : in std_logic;
       KmiTrDHOErr   : in std_logic;
       WrenTXREG     : out std_logic;
       WrenCnREG     : out std_logic;
       WrenSTAT      : out std_logic;
       WrenCLKL      : out std_logic;
       WrenCLKH      : out std_logic;
       WrenDSI       : out std_logic;
       WrenDHI       : out std_logic;
       WrenDSO       : out std_logic;
       WrenDHO       : out std_logic;
       WrenREFCLK    : out std_logic;
       WrenRG        : out std_logic;
       WrenCLKDIV    : out std_logic; 
       WrenTIMOUT    : out std_logic; 
       WrenMODEREG   : out std_logic;
       WrenTIMESTAT  : out std_logic; 
       PRDATA        : out std_logic_vector(15 downto 0); 
       RdUpdateRx    : out std_logic; 
       PWDataIn      : out std_logic_vector(15 downto 0) 
      );
end component;

component KmiTrBitCounter 
  port (
        BnRES       : in  std_logic;
        KCLK        : in  std_logic; 
        CounterEn   : in  std_logic;
        BitCount    : out std_logic_vector(3 downto 0)
       );
end component;

component KmiTrController 
  port (
        REFCLK       : in  std_logic; 
        BnRES        : in  std_logic;
        nKMIRST      : in  std_logic;
        BitCount     : in  std_logic_vector(3 downto 0); 
        KmiTrTXFE    : in  std_logic;
        KmiTrTIMOUT  : in  std_logic_vector(4 downto 0);
        KmiTrCnREG   : in  std_logic_vector(4 downto 0);
        KDATAIn      : in  std_logic;
        KCLKIn       : in  std_logic;
        KDATAOut     : in  std_logic;
        KCLKOut      : in  std_logic;
        KCLK         : in  std_logic;
        EnableOut    : in  std_logic;
        RTS          : in  std_logic;
        CurrentState : out std_logic_vector(1 downto 0)
       );
end component;

component KmiTrDataWidth
  port (
        BnRES          : in  std_logic; 
        KmiTrCLKL      : in  std_logic_vector(8 downto 0); 
        KmiTrCLKH      : in  std_logic_vector(8 downto 0); 
        REFCLK         : in  std_logic; 
        Pulse8MHz      : in  std_logic; 
        WrenSTAT       : in  std_logic; 
        KDATAIn        : in  std_logic; 
        KDATAOut       : in  std_logic;
        WidthMsrEn     : in  std_logic;
        KCLKOut        : in  std_logic;
        WrenTIMESTAT   : in  std_logic;
        PWDataIn       : in  std_logic_vector(15 downto 0);
        BitCount       : in  std_logic_vector(3 downto 0);
        KmiTrDSO       : in  std_logic_vector(15 downto 0); 
        KmiTrDHO       : in  std_logic_vector(15 downto 0); 
        CurrentState   : in  std_logic_vector(1 downto 0);
        TdsoErr        : out std_logic;
        TdhoErr        : out std_logic; 
        KmiTrDWIDTHERR : out std_logic 
       );
end component;

component KmiTrKCLKGen 
  port (
        BnRES       : in  std_logic; 
        KmiTrCLKL   : in  std_logic_vector(8 downto 0); 
        KmiTrCLKH   : in  std_logic_vector(8 downto 0); 
        REFCLK      : in  std_logic; 
        Pulse8MHz   : in  std_logic; 
        CLKEn       : in  std_logic; 
        CurrentState: in std_logic_vector(1 downto 0); 
        KCLK        : out std_logic 
       );
end component;

component KmiTrPulseGen
  port (
        BnRES        : in  std_logic; 
        PCLK         : in  std_logic; 
        KmiTrREFCLK  : in  std_logic_vector(7 downto 0); 
        KmiTrCLKDIV  : in  std_logic_vector(7 downto 0); 
        KmiTrMODEREG : in  std_logic_vector(3 downto 0); 
        WrenMREG     : in  std_logic; 
        Pulse8MHz    : out std_logic; 
        REFCLK       : out std_logic; 
        nKMIRST      : out std_logic;
        REFCLKOn     : out std_logic;
        PCLKOn       : out std_logic 
       );
end component;
 
component KmiTrOutDrive 
  port (
        REFCLK         : in  std_logic;
        BnRES          : in  std_logic;
        BitCount       : in  std_logic_vector(3 downto 0);
        FParErr        : in  std_logic;
        KCLK           : in  std_logic;
        KmiTrTXREG     : in  std_logic_vector(7 downto 0);
        CurrentState   : in  std_logic_vector(1 downto 0);
        KmiTrDSI       : in  std_logic_vector(15 downto 0); 
        KmiTrRG        : in  std_logic_vector(15 downto 0); 
        KDATAIn        : in  std_logic;
        RTS            : in  std_logic;
        LegacyBit      : in  std_logic;
        WrenSTAT       : in  std_logic;
        PWDataIn       : in  std_logic_vector(15 downto 0);
        FeedBackRx     : in  std_logic;
        FeedBackTx     : in  std_logic;
        KmiTrRXREG     : out std_logic_vector(7 downto 0);
        KmiTrPARITYERR : out std_logic;
        KmiTrFRAMEERR  : out std_logic;
        DataAvl        : out std_logic;
        RdUpdateTx     : out std_logic;
        KCLKOut        : out std_logic;
        KDATAOut       : out std_logic;
        EnableOut      : out std_logic
       );  
end component;

component KmiTrTimer
  port (
        REFCLK      : in  std_logic; 
        BnRES       : in  std_logic; 
        Pulse8MHz   : in  std_logic; 
        nKMIRST     : in  std_logic; 
        KDATAIn     : in  std_logic; 
        KCLKIn      : in  std_logic; 
        KDATAOut    : in  std_logic;
        KCLKOut     : in  std_logic;
        RTS         : out std_logic
       );
end component;

component KmiTrRegFile
  port (
        WrenTXREG      : in std_logic; 
        WrenCnREG      : in std_logic; 
        WrenCLKL       : in std_logic; 
        WrenCLKH       : in std_logic; 
        WrenDSI        : in std_logic; 
        WrenDHI        : in std_logic; 
        WrenDSO        : in std_logic; 
        WrenDHO        : in std_logic; 
        WrenREFCLK     : in std_logic; 
        WrenRG         : in std_logic; 
        WrenCLKDIV     : in std_logic; 
        WrenTIMOUT     : in std_logic; 
        WrenMODEREG    : in std_logic; 
        DataAvl        : in std_logic; 
        RdUpdateRx     : in std_logic; 
        RdUpdateTx     : in std_logic; 
        PWDataIn       : in std_logic_vector(15 downto 0); 
        RXDATAIN       : in std_logic_vector(7 downto 0); 
        PCLK           : in std_logic;   
        BnRES          : in std_logic;   
        KmiTrRXFF      : out std_logic; 
        KmiTrRXFE      : out std_logic; 
        KmiTrRXFH      : out std_logic; 
        KmiTrTXFF      : out std_logic; 
        KmiTrTXFE      : out std_logic; 
        KmiTrTXFH      : out std_logic; 
        KmiTrRXREG     : out std_logic_vector(7 downto 0); 
        KmiTrTXREG     : out std_logic_vector(7 downto 0); 
        KmiTrCnREG     : out std_logic_vector(4 downto 0); 
        KmiTrCLKL      : out std_logic_vector(8 downto 0); 
        KmiTrCLKH      : out std_logic_vector(8 downto 0); 
        KmiTrDSI       : out std_logic_vector(15 downto 0); 
        KmiTrDHI       : out std_logic_vector(15 downto 0); 
        KmiTrDSO       : out std_logic_vector(15 downto 0); 
        KmiTrDHO       : out std_logic_vector(15 downto 0); 
        KmiTrREFCLK    : out std_logic_vector(7 downto 0); 
        KmiTrRG        : out std_logic_vector(15 downto 0); 
        KmiTrCLKDIV    : out std_logic_vector(7 downto 0); 
        KmiTrTIMOUT    : out std_logic_vector(4 downto 0); 
        KmiTrMODEREG   : out std_logic_vector(3 downto 0)  
       );
end component;

-- ----------------------------------------------------------------------------
-- Signal declarations
-- ----------------------------------------------------------------------------
signal  WrenTXREG       : std_logic;
-- Tx Fifo Write Enable from APB Interface to KmiTrRegfile
 
signal  WrenCnREG       : std_logic;
-- Control Register Write Enable from APB Interface to KmiTrRegfile
 
signal  WrenSTAT        : std_logic;
-- Status Register Write Enable 
 
signal  WrenCLKL        : std_logic;
-- CLKL Write Enable from APB Interface to KmiTrRegfile
 
signal  WrenCLKH        : std_logic;
-- CLKH Write Enable from APB Interface to KmiTrRegfile
 
signal  WrenDSI         : std_logic;
-- DSI Write Enable from APB Interface to KmiTrRegfile
 
signal  WrenDHI         : std_logic;
-- DHI Write Enable from APB Interface to KmiTrRegfile
 
signal  WrenDSO         : std_logic;
-- DSO Write Enable from APB Interface to KmiTrRegfile
 
signal  WrenDHO         : std_logic;
-- DHO Write Enable from APB Interface to KmiTrRegfile
 
signal  WrenREFCLK      : std_logic;
-- REFCLK Write Enable from APB Interface to KmiTrRegfile
 
signal  WrenRG          : std_logic;
-- RG Write Enable from APB Interface to KmiTrRegfile
 
signal  WrenCLKDIV      : std_logic;
-- CLKDIV Write Enable from APB Interface to KmiTrRegfile
 
signal  WrenTIMOUT      : std_logic;
-- TIMOUT Write Enable from APB Interface to KmiTrRegfile
 
signal  WrenMODEREG     : std_logic;
-- MODEREG Write Enable from APB Interface to KmiTrRegfile
 
signal  WrenTIMESTAT    : std_logic;
-- TIMESTAT Write Enable 
 
signal  DataAvl         : std_logic;
-- Rx Fifo Write Enable from Receiver Block
 
signal  RdUpdateRx      : std_logic;
-- Rx Fifo Read from APB Interface 
 
signal  RdUpdateTx      : std_logic;
-- Tx Fifo Read from Transmitter Block
 
signal  WriteRxFF       : std_logic;
-- Synchronized Rx Fifo Write 
 
signal  ReadTxFF        : std_logic;
-- Synchronized Tx Fifo Read
 
signal  FeedBackTx      : std_logic;
-- Feedback signal to Transmitter Block for sunchronization
 
signal  FeedBackRx      : std_logic;
-- Feedback signal to Receiver block for sunchronization
 
signal  PWDataIn        : std_logic_vector(15 downto 0);
-- Gated Write Data Bus
 
signal  RXDATAIN        : std_logic_vector(7 downto 0);
-- Received Data
 
signal  KmiTrRXFF       : std_logic;
-- Receive Fifo Full flag
 
signal  KmiTrRXFE       : std_logic;
-- Receive Fifo empty flag

signal  KmiTrRXFH       : std_logic;
-- Receive Fifo more then Half Full flag
 
signal  KmiTrTXFF       : std_logic;
-- Transmit Fifo Full flag
 
signal  KmiTrTXFE       : std_logic;
-- Transmit Fifo empty flag
 
signal  KmiTrTXFH       : std_logic;
-- Transmit Fifo Less then Half Full flag
 
signal  KmiTrRXREG      : std_logic_vector(7 downto 0);
-- Receive Data Register 
 
signal  KmiTrTXREG      : std_logic_vector(7 downto 0);
-- Transmit Data Register
 
signal  KmiTrCnREG      : std_logic_vector(4 downto 0);
-- Control Register
 
signal  KmiTrCLKL       : std_logic_vector(8 downto 0);
-- Clock Low Value Register
 
signal  KmiTrCLKH       : std_logic_vector(8 downto 0);
-- Clock High Value Register
 
signal  KmiTrDSI        : std_logic_vector(15 downto 0);
-- DSI Timing Register
 
signal  KmiTrDHI        : std_logic_vector(15 downto 0);
-- DHI Timing Register
 
signal  KmiTrDSO        : std_logic_vector(15 downto 0);
-- DSO Timing Register
 
signal  KmiTrDHO        : std_logic_vector(15 downto 0);
-- DHO Timing Register
 
signal  KmiTrREFCLK     : std_logic_vector(7 downto 0);
-- REFCLK Period
 
signal  KmiTrRG         : std_logic_vector(15 downto 0);
-- RG Timing Register
 
signal  KmiTrCLKDIV     : std_logic_vector(7 downto 0);
-- Clock Divisor for Pulse8MHz
 
signal  KmiTrTIMOUT     : std_logic_vector(4 downto 0);
-- Time Out Value Register
 
signal  KmiTrMODEREG    : std_logic_vector(3 downto 0); 
-- Mode Register
 
signal  KmiTrDWIDTHERR  : std_logic;
-- Data Width Error Signal
 
signal  KmiTrTXBUSY     : std_logic;
-- Transmit Busy Signal
 
signal  KmiTrRXBUSY     : std_logic;
-- Receive Busy Signal
 
signal  KmiTrFRAMEERR   : std_logic;
-- Framing Error Signal
 
signal  KmiTrPARITYERR  : std_logic;
-- Parity Error Signal
 
signal  KmiTrDSOErr     : std_logic;
-- DSO Timing Error Signal
 
signal  KmiTrDHOErr     : std_logic;
-- DHO Timing Error Signal
 
signal  KCLK            : std_logic;
-- Internal KCLK
 
signal  CounterEn       : std_logic;
-- Counter Enable for Clock

signal  BitCount        : std_logic_vector(3 downto 0);
-- Number of Bits being transmitted/received.
 
signal  iKMIRST         : std_logic;
-- Internal Copy of KMI Reset
 
signal  RTS             : std_logic;
-- Request to send signal
 
signal  CurrentState    : std_logic_vector(1 downto 0);
-- Current State of TrickBox Controller
 
signal  Pulse8MHz       : std_logic;
-- 8 MHz signal 
 
signal  iREFCLK         : std_logic; 
-- Internal copy of REFCLK
 
signal  KmiTrREFCLKOn   : std_logic;
-- Internal Copy of KCLKOut
  
signal  KmiTrPCLKOn     : std_logic;
-- Internal Copy of KDATAOut

signal  iKMICLKOUT      : std_logic;
-- Internal Copy of KCLKOut
  
signal  iKDATAOUT       : std_logic;
-- Internal Copy of KDATAOut

signal  iFeedBackRx     : std_logic;
-- Internal Copy of FeedBackRx

signal  iFeedBackTx     : std_logic;
-- Internal Copy of FeedBackTx

-- ---------------------------------------------------------------------------
--
--   Main body of code
--   =================
--
-- ---------------------------------------------------------------------------

begin

KMIREFCLK   <= iREFCLK;
KCLKOUT     <= iKMICLKOUT;
KDATAOUT    <= iKDATAOUT;
nKMIRST     <= iKMIRST;
SCANMODE    <= KmiTrCnREG(4);

KmiTrTXBUSY <= '1' when CurrentState = "10" 
            else
               '0'; 
             
KmiTrRXBUSY <= '1' when CurrentState = "01" 
            else
               '0';  

WriteRxFF   <= not(iFeedBackRx) and DataAvl;
ReadTxFF    <= not(iFeedBackTx) and RdUpdateTx;

-- ----------------------------------------------------------------------------
-- iFeedBack signal generation for Receiver Fifo Write synchronization
-- ----------------------------------------------------------------------------
p_iFeedBackRxSeq : process(PCLK, BnRES)
begin
  if (BnRES = '0') then
    iFeedBackRx <= '0';
  elsif (PCLK'event and PCLK = '1') then
    iFeedBackRx <= DataAvl;
  end if;
end process p_iFeedBackRxSeq;

-- ----------------------------------------------------------------------------
-- FeedBack signal generation for Receiver Fifo Write synchronization
-- ----------------------------------------------------------------------------
p_FeedBackRxSeq : process(iREFCLK, BnRES)
begin
  if (BnRES = '0') then
    FeedBackRx <= '0';
  elsif (iREFCLK'event and iREFCLK = '0') then
    FeedBackRx <= iFeedBackRx;
  end if;
end process p_FeedBackRxSeq;

-- ----------------------------------------------------------------------------
-- iFeedBack signal generation for Transmit Fifo Read synchronization
-- ----------------------------------------------------------------------------
p_iFeedBackTxSeq : process(PCLK, BnRES)
begin
  if (BnRES = '0') then
    iFeedBackTx <= '0';
  elsif (PCLK'event and PCLK = '1') then
    iFeedBackTx <= RdUpdateTx;
  end if;
end process p_iFeedBackTxSeq;
 
-- ----------------------------------------------------------------------------
-- FeedBack signal generation for Transmit Fifo Read synchronization
-- ----------------------------------------------------------------------------
p_FeedBackTxSeq : process(iREFCLK, BnRES)
begin
  if (BnRES = '0') then
    FeedBackTx <= '0';
  elsif (iREFCLK'event and iREFCLK = '0') then
    FeedBackTx <= iFeedBackTx;
  end if;
end process p_FeedBackTxSeq;
  
-- ----------------------------------------------------------------------------
-- Component Instantiations
-- ----------------------------------------------------------------------------
uKmiTrApbif: KmiTrApbif 
port map (
          PCLK            => PCLK,       
          BnRES           => BnRES,       
          PADDR           => PADDR,         
          PWDATA          => PWDATA,      
          PRDATA          => PRDATA,     
          PENABLE         => PENABLE,    
          PWRITE          => PWRITE,     
          PSEL            => PSELT,        
          KmiTrRXREG      => KmiTrRXREG,    
          KmiTrCnREG      => KmiTrCnREG, 
          KmiTrREFCLKOn   => KmiTrREFCLKOn,
          KmiTrPCLKOn     => KmiTrPCLKOn,  
          KmiTrDWIDTHERR  => KmiTrDWIDTHERR,  
          KmiTrTXBUSY     => KmiTrTXBUSY,  
          KmiTrRXBUSY     => KmiTrRXBUSY,  
          KmiTrFRAMEERR   => KmiTrFRAMEERR,  
          KmiTrPARITYERR  => KmiTrPARITYERR, 
          KmiTrCLKL       => KmiTrCLKL,    
          KmiTrCLKH       => KmiTrCLKL,    
          KmiTrDSI        => KmiTrDSI, 
          KmiTrDHI        => KmiTrDHI,     
          KmiTrDSO        => KmiTrDSO,    
          KmiTrDHO        => KmiTrDHO,   
          KmiTrREFCLK     => KmiTrREFCLK,   
          KmiTrRG         => KmiTrRG,      
          KmiTrRXFF       => KmiTrRXFF,    
          KmiTrRXFE       => KmiTrRXFE,    
          KmiTrRXFH       => KmiTrRXFH,    
          KmiTrTXFF       => KmiTrTXFF,    
          KmiTrTXFE       => KmiTrTXFE,    
          KmiTrTXFH       => KmiTrTXFH,     
          KMIINTR         => KMIINTR,    
          KMIRXINTR       => KMIRXINTR,  
          KMITXINTR       => KMITXINTR, 
          KDATAIN         => KDATAIN,    
          KCLKIN          => KCLKIN,     
          KmiTrTIMOUT     => KmiTrTIMOUT,   
          KmiTrCLKDIV     => KmiTrCLKDIV,   
          KmiTrMODEREG    => KmiTrMODEREG, 
          KmiTrDSOErr     => KmiTrDSOErr, 
          KmiTrDHOErr     => KmiTrDHOErr,  
          WrenTXREG       => WrenTXREG,   
          WrenCnREG       => WrenCnREG,  
          WrenSTAT        => WrenSTAT,    
          WrenCLKL        => WrenCLKL,    
          WrenCLKH        => WrenCLKH,    
          WrenDSI         => WrenDSI,     
          WrenDHI         => WrenDHI,     
          WrenDSO         => WrenDSO,     
          WrenDHO         => WrenDHO,     
          WrenREFCLK      => WrenREFCLK,  
          WrenRG          => WrenRG,      
          WrenCLKDIV      => WrenCLKDIV,  
          WrenTIMOUT      => WrenTIMOUT,  
          WrenMODEREG     => WrenMODEREG, 
          WrenTIMESTAT    => WrenTIMESTAT,
          RdUpdateRx      => RdUpdateRx,  
          PWDataIn        => PWDataIn   
         );

uKmiTrBitCounter: KmiTrBitCounter 
port map (
          BnRES     => BnRES,       
          KCLK      => KCLK,        
          CounterEn => CounterEn,   
          BitCount  => BitCount   
         );

uKmiTrController: KmiTrController 
port map (
          REFCLK       => iREFCLK,       
          BnRES        => BnRES,       
          nKMIRST      => iKMIRST,       
          BitCount     => BitCount,     
          KmiTrTXFE    => KmiTrTXFE,      
          KmiTrTIMOUT  => KmiTrTIMOUT,     
          KmiTrCnREG   => KmiTrCnREG,     
          KDATAIn      => KDATAIN,      
          KCLKIn       => KCLKIN,       
          KDATAOut     => iKDATAOUT,    
          KCLKOut      => iKMICLKOUT,     
          KCLK         => KCLK,     
          EnableOut    => CounterEn,
          RTS          => RTS,        
          CurrentState => CurrentState 
         );

uKmiTrDataWidth: KmiTrDataWidth
port map (
          BnRES           => BnRES,        
          KmiTrCLKL       => KmiTrCLKL,       
          KmiTrCLKH       => KmiTrCLKH,      
          REFCLK          => iREFCLK,      
          Pulse8MHz       => Pulse8MHz,    
          WrenSTAT        => WrenSTAT,     
          KDATAIn         => KDATAIN,     
          KDATAOut        => iKDATAOUT,     
          WidthMsrEn      => KmiTrCnREG(2),   
          KCLKOut         => iKMICLKOUT,      
          WrenTIMESTAT    => WrenTIMESTAT, 
          PWDataIn        => PWDataIn,
          KmiTrDSO        => KmiTrDSO,       
          KmiTrDHO        => KmiTrDHO, 
          BitCount        => BitCount,     
          CurrentState    => CurrentState, 
          TdsoErr         => KmiTrDSOErr,     
          TdhoErr         => KmiTrDHOErr,     
          KmiTrDWIDTHERR  => KmiTrDWIDTHERR   
         );

uKmiTrKCLKgen: KmiTrKCLKGen
port map (
          BnRES        => BnRES,     
          KmiTrCLKL    => KmiTrCLKL,    
          KmiTrCLKH    => KmiTrCLKH,   
          REFCLK       => iREFCLK,  
          Pulse8MHz    => Pulse8MHz, 
          CLKEn        => CounterEn, 
          CurrentState => CurrentState,   
          KCLK         => KCLK     
         );
 
uKmiTrOutDrive: KmiTrOutDrive
port map (
          REFCLK         => iREFCLK,       
          BnRES          => BnRES,        
          BitCount       => BitCount,     
          FParErr        => KmiTrCnREG(1),      
          KCLK           => KCLK,         
          KmiTrTXREG     => KmiTrTXREG,     
          CurrentState   => CurrentState,
          KmiTrDSI       => KmiTrDSI,        
          KmiTrRG        => KmiTrRG,         
          KDATAIn        => KDATAIN,     
          RTS            => RTS,        
          WrenSTAT       => WrenSTAT,
          PWDataIn       => PWDataIn, 
          LegacyBit      => KmiTrCnREG(3),    
          FeedBackRx     => FeedBackRx,
          FeedBackTx     => FeedBackTx, 
          KmiTrRXREG     => RXDATAIN,      
          KmiTrParityErr => KmiTrPARITYERR,    
          KmiTrFRAMEERR  => KmiTrFRAMEERR,    
          DataAvl        => DataAvl,     
          RdUpdateTx     => RdUpdateTx,    
          KCLKOut        => iKMICLKOUT,     
          KDATAOut       => iKDATAOUT,     
          EnableOut      => CounterEn    
         );
  
uKmiTrPulseGen: KmiTrPulseGen
port map (
          BnRES        => BnRES,      
          PCLK         => PCLK,      
          KmiTrREFCLK  => KmiTrREFCLK,   
          KmiTrCLKDIV  => KmiTrCLKDIV,   
          KmiTrMODEREG => KmiTrMODEREG,  
          WrenMREG     => WrenMODEREG,   
          Pulse8MHz    => Pulse8MHz,  
          REFCLK       => iREFCLK,    
          nKMIRST      => iKMIRST,
          REFCLKOn     => KmiTrREFCLKOn,
          PCLKOn       => KmiTrPCLKOn
         );

uKmiTrRegFile: KmiTrRegFile
port map (
          WrenTXREG     => WrenTXREG,
          WrenCnREG     => WrenCnREG,
          WrenCLKL      => WrenCLKL, 
          WrenCLKH      => WrenCLKH,   
          WrenDSI       => WrenDSI,    
          WrenDHI       => WrenDHI,    
          WrenDSO       => WrenDSO,    
          WrenDHO       => WrenDHO,    
          WrenREFCLK    => WrenREFCLK, 
          WrenRG        => WrenRG,     
          WrenCLKDIV    => WrenCLKDIV, 
          WrenTIMOUT    => WrenTIMOUT, 
          WrenMODEREG   => WrenMODEREG,
          DataAvl       => WriteRxFF,    
          RdUpdateRx    => RdUpdateRx, 
          RdUpdateTx    => ReadTxFF, 
          PWDataIn      => PWDataIn,   
          RXDATAIN      => RXDATAIN,   
          PCLK          => PCLK,       
          BnRES         => BnRES,      
          KmiTrRXFF     => KmiTrRXFF,     
          KmiTrRXFE     => KmiTrRXFE,     
          KmiTrRXFH     => KmiTrRXFH,     
          KmiTrTXFF     => KmiTrTXFF,     
          KmiTrTXFE     => KmiTrTXFE,     
          KmiTrTXFH     => KmiTrTXFH,     
          KmiTrRXREG    => KmiTrRXREG,    
          KmiTrTXREG    => KmiTrTXREG,    
          KmiTrCnREG    => KmiTrCnREG,    
          KmiTrCLKL     => KmiTrCLKL,     
          KmiTrCLKH     => KmiTrCLKH,     
          KmiTrDSI      => KmiTrDSI,      
          KmiTrDHI      => KmiTrDHI,      
          KmiTrDSO      => KmiTrDSO,      
          KmiTrDHO      => KmiTrDHO,      
          KmiTrREFCLK   => KmiTrREFCLK,   
          KmiTrRG       => KmiTrRG,       
          KmiTrCLKDIV   => KmiTrCLKDIV,   
          KmiTrTIMOUT   => KmiTrTIMOUT,   
          KmiTrMODEREG  => KmiTrMODEREG  
         );
   
uKmiTrTimer: KmiTrTimer
port map (
          REFCLK    => iREFCLK,     
          BnRES     => BnRES,      
          Pulse8MHz => Pulse8MHz,  
          nKMIRST   => iKMIRST,      
          KDATAIn   => KDATAIN,    
          KCLKIn    => KCLKIN,     
          KDATAOut  => iKDATAOUT,   
          KCLKOut   => iKMICLKOUT,    
          RTS       => RTS       
         );
   
end behavioural;

-- ======================== End of KmiTrick =================================--
