-- ----------------------------------------------------------------------------
--  This confidential and proprietary software may be used only as
--  authorised by a licensing agreement from ARM Limited
--    (C) COPYRIGHT 1999 ARM Limited
--        ALL RIGHTS RESERVED
--  The entire notice above must be reproduced on all authorised
--  copies and copies may only be made to the extent permitted
--  by a licensing agreement from ARM Limited.
-- ----------------------------------------------------------------------------
--  
--  Version and Release Control Information:
--  
--  File Name              : SspTrick.vhd.rca
--  File Revision          : 1.2
--  
--  Release Information    : PrimeCell(TM)-PL022-REL1v2
--  
-- ----------------------------------------------------------------------------
--  Purpose          : This block is the top level of the SSPTRICKBox.
-- -----------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

-- -----------------------------------------------------------------------------

entity SspTrick is
  port (
        PCLK	     : in    std_logic;  -- APB Bus Clock
        PRESETn      : in    std_logic;  -- AMBA Bus Reset
        PSELT        : in    std_logic;  -- APB Peripheral select
        PENABLE      : in    std_logic;  -- APB Peripheral enable
        PWRITE       : in    std_logic;  -- APB Peripheral write
        PADDR        : in    std_logic_vector(7 downto 2); 
                                         -- APB High Addr
        PWDATA       : in    std_logic_vector(15 downto 0);
                                         -- APB Write databus
        SSPRXD       : in    std_logic;  -- SSPTB Receive input
        SCLKIN       : in    std_logic;  -- Serial Clock pin
        SFRMIN       : in    std_logic;  -- Serial Frame pin
        SSPINTR      : in    std_logic;  -- Combined Interrupt
        SSPRXINTR    : in    std_logic;  -- Receive FIFO Service Request
        SSPTXINTR    : in    std_logic;  -- Transmit FIFO Service Request
        SSPRORINTR   : in    std_logic;  -- Rx FIFO Overrun Interrupt
        SSPRTINTR    : in    std_logic;  -- Rx FIFO Timeout Interrupt
        SSPTXDMASREQ : in    std_logic;  -- Transmit DMA single request
        SSPTXDMABREQ : in    std_logic;  -- Transmit DMA burst request
        SSPRXDMASREQ : in    std_logic;  -- Receive DMA single request
        SSPRXDMABREQ : in    std_logic;  -- Receive DMA burst request
        SCANMODE     : out   std_logic;  -- Reset control on Scan
        nSSPRST      : out   std_logic;  -- Reset control on Scan
        SSPCLK       : out   std_logic;  -- Main SSP Clock
        SSPTXD       : out   std_logic;  -- SSP Serial Transmit output
        SCLKOUT      : out   std_logic;  -- Serial Clock out pin
        SFRMOUT      : out   std_logic;  -- Serial Frame out
        SSPTXDMACLR  : out   std_logic;  -- Transmit DMA request clear
        SSPRXDMACLR  : out   std_logic;  -- Receive DMA request clear
        PRDATA       : out   std_logic_vector(15 downto 0)
                                         -- Read databus
       );
end SspTrick;

-- -----------------------------------------------------------------------------
-- 
--                                  SspTrick
--                                  ========
-- 
-- -----------------------------------------------------------------------------
-- 
-- Overview
-- ========
-- 
-- This module instantiates the following sub-modules: 
-- 
-- 1. SspTrApbif         - APB Interface
-- 2. SspTrRegCore       - Register Block
-- 3. SspTrRxFIFO        - Receive FIFO
-- 4. SspTrTxFIFO        - Transmit FIFO
-- 5. SspTrMTxRxCntl     - Transmitter/Receiver
-- 6. SspTrSynctoPCLK    - Synchronisers for signals crossing into PCLK domain
-- 7. SspTrSynctoSSPCLK  - Synchronisers for signals crossing into SSPCLK domain
-- 8. SspTrCkRsCntlr     - Clock generation and RST Controller Block
-- 9. SspTrScaleCntr     - Sync block for control bits. 
-- 10.SspTrChecker       - Protocol Checker Block 
-- 11.SspTrSTxRxCntl     - Transmitter/Receiver for Testing Slave
-- 12.SspTrDMA           - DMA 
-- -----------------------------------------------------------------------------

-- --============================= ARCHITECTURE ==============================--

architecture structural of SspTrick is

--------------------------------------------------------------------------------
-- Component declarations
--------------------------------------------------------------------------------
component SspTrApbif 
port (  
       PRESETn          : in  std_logic;
       PCLK             : in  std_logic;
       PSEL             : in  std_logic;
       PWRITE           : in  std_logic;
       PENABLE          : in  std_logic;
       PADDR            : in  std_logic_vector(7 downto 2);
       PWDATA           : in  std_logic_vector(15 downto 0);
       SSPTBPRE         : in  std_logic_vector(3 downto 0);
       SSPTBCR0         : in  std_logic_vector(15 downto 0);
       SSPTBCR1         : in  std_logic_vector(5 downto 0);
       SSPTBCR2         : in  std_logic_vector(10 downto 0);
       RxFRdData        : in  std_logic_vector(15 downto 0);
       TxFRdData        : in  std_logic_vector(15 downto 0);
       RXFF             : in  std_logic;
       TXFF             : in  std_logic;
       RXFE             : in  std_logic;
       TXFE             : in  std_logic;
       BSY              : in  std_logic;
       SSPTBSETPINS     : in  std_logic_vector(6 downto 0);
       SSPTBCLKREG      : in  std_logic_vector(15 downto 0);
       SSPTBCLKREG1     : in  std_logic_vector(15 downto 0);
       SSPINTR          : in  std_logic;
       SSPTXINTR        : in  std_logic;
       SSPRXINTR        : in  std_logic;
       SSPRORINTR       : in  std_logic;
       SSPRTINTR        : in  std_logic;
       RXWFLG           : in  std_logic;
       PCLKOn           : in  std_logic;
       REFCLKOn         : in  std_logic;
       REFCLK1On        : in  std_logic;
       SSPTXDMASREQ     : in  std_logic;
       SSPTXDMABREQ     : in  std_logic;
       SSPRXDMASREQ     : in  std_logic;
       SSPRXDMABREQ     : in  std_logic;
       RxFRdPtrInc      : out std_logic;
       SSPTBCR0Wr       : out std_logic;
       SSPTBCR1Wr       : out std_logic;
       SSPTBCR2Wr       : out std_logic;
       SSPTBPREWr       : out std_logic;
       SSPTBTDRWr       : out std_logic;
       SSPTBRDRWr       : out std_logic;
       SSPTBSRWr        : out std_logic;
       SSPTBSETPINSWr   : out std_logic;
       SSPTBCLKREGWr    : out std_logic;
       SSPTBCLKREG1Wr   : out std_logic;
       SSPTBDMACRWrEn   : out std_logic;
       PRDATA           : out std_logic_vector(15 downto 0);
       PWDATAIn         : out std_logic_vector(15 downto 0)
     );
end component;


component SspTrTxFIFO 
port (
      PCLK             : in  std_logic;
      PRESETn	       : in  std_logic;
      SSPTBTDRWr       : in  std_logic;
      TxRxBSYSync      : in  std_logic;
      FRF              : in  std_logic_vector(1 downto 0);
      PWDATAIn         : in  std_logic_vector(15 downto 0);
      DSS              : in  std_logic_vector(3 downto 0);
      TxFRdPtrIncSync  : in  std_logic;
      STxFRdPtrIncSync : in  std_logic;
      MS               : in  std_logic;
      TxFRdDataIn      : out std_logic_vector(15 downto 0);
      TxDataAvlbl      : out std_logic;
      TNF              : out std_logic;
      TFE              : out std_logic;
      BSY              : out std_logic
     );
end component;

component SspTrRxFIFO 
port (
      PCLK     	       : in  std_logic;
      PRESETn          : in  std_logic;
      RxFWrSync        : in  std_logic;
      SRxFWrSync       : in  std_logic;
      RxFWrData        : in  std_logic_vector(15 downto 0);
      RxFRdPtrInc      : in  std_logic;
      RXW	       : in  std_logic_vector(1 downto 0);
      RxFRdData        : out std_logic_vector(15 downto 0);
      RNE              : out std_logic;
      RXWFLG           : out std_logic;
      RFF              : out std_logic
     );
end component;

component SspTrSynctoPCLK 
port (
      PCLK             : in  std_logic;
      PRESETn          : in  std_logic;
      TxRxBSY          : in  std_logic;
      TxFRdPtrInc      : in  std_logic;
      STxFRdPtrInc     : in  std_logic;
      RxFWr            : in  std_logic;
      SRxFWr           : in  std_logic;
      TxRxBSYSync      : out std_logic;
      TxFRdPtrIncSync  : out std_logic;
      STxFRdPtrIncSync : out std_logic;
      RxFWrSync        : out std_logic;
      SRxFWrSync       : out std_logic
     );
end component;

component SspTrRegCore 
port (
      PCLK             : in  std_logic;        
      PRESETn          : in  std_logic;       
      SSPTBCR0Wr       : in  std_logic;      
      SSPTBCR1Wr       : in  std_logic;    
      SSPTBCR2Wr       : in  std_logic;    
      SSPTBSRWr        : in  std_logic; 
      SSPTBPREWr       : in  std_logic;
      SSPTBTDRWr       : in  std_logic;      
      SSPTBRDRWr       : in  std_logic;       
      SSPTBSETPINSWr   : in  std_logic;
      SSPTBCLKREGWr    : in  std_logic;       
      SSPTBCLKREG1Wr   : in  std_logic;       
      SSPTBDMACRWrEn   : in  std_logic;
      PWDATAIn         : in  std_logic_vector(15 downto 0);   
      SSPTXDMACLRStag4 : in  std_logic;
      SSPRXDMACLRStag4 : in  std_logic;
      CR0Update        : out std_logic;
      CR1Update        : out std_logic;
      SSPTBCR0         : out std_logic_vector(15 downto 0);   
      SSPTBCR1         : out std_logic_vector(5 downto 0);  
      SSPTBCR2         : out std_logic_vector(10 downto 0);  
      SSPTBCLKREG      : out std_logic_vector(15 downto 0):="0000000000000001";
      SSPTBCLKREG1     : out std_logic_vector(15 downto 0):="0000000000000001";
      SSPTBSETPINS     : out std_logic_vector(6 downto 0);    
      SSPTBPRE         : out std_logic_vector(3 downto 0);    
      SSPTDMACR        : out std_logic_vector(1 downto 0)
     );
end component;

component SspTrSynctoSSPCLK 
port (
      SSPCLK           : in  std_logic;
      nSSPRES          : in  std_logic;
      TxDataAvlbl      : in  std_logic;
      CR0Update        : in  std_logic;
      CR1Update        : in  std_logic;
      SSE              : in  std_logic;
      TxDataAvlblSync  : out std_logic;
      CR0UpdateSync    : out std_logic;
      CR1UpdateSync    : out std_logic;
      SSESync          : out std_logic
     );
end component;

component  SspTrCkRsCntlr
port ( 
      PCLK             : in  std_logic;
      PRESETn          : in  std_logic;
      SCANMODEIN       : in  std_logic;
      RSTMODE          : in  std_logic;
      SSPTrCNTLR       : in  std_logic_vector(4 downto 0);
      SSPTBCLKREG      : in  std_logic_vector(15 downto 0):="0000000000000001";
      SSPTBCLKREG1     : in  std_logic_vector(15 downto 0):="0000000000000001";
      SSPCLK           : out std_logic;
      SSPCLK1          : out std_logic;
      PCLKOn           : out std_logic;
      REFCLKOn         : out std_logic;
      REFCLK1On        : out std_logic;
      nSSPRST          : out std_logic;
      SCANMODE         : out std_logic
     );
end component;

component SspTrScaleCntr
port (
      SSPCLK           : in  std_logic;
      nSSPRES          : in  std_logic;
      SSESync          : in  std_logic;
      CR0UpdateSync    : in  std_logic;
      CR1UpdateSync    : in  std_logic;
      SSPTBCR0         : in  std_logic_vector(15 downto 0);
      SSPTBCR1         : in  std_logic_vector(5 downto 0);
      SSPTBPRE         : in  std_logic_vector(3 downto 0);
      DSS              : out std_logic_vector(3 downto 0);
      FRF              : out std_logic_vector(1 downto 0);
      SSPCLKDIV        : out std_logic;
      SCR              : out std_logic_vector(7 downto 0);
      SPO              : out std_logic;
      SPH              : out std_logic
     );
end component;

component SspTrChecker 
port ( 
      PCLK             : in std_logic; 
      SSPCLK           : in std_logic; 
      PRESETn          : in std_logic;
      SCLK             : in std_logic;
      SFRM             : in std_logic;       
      SCLKOUT          : in std_logic;
      SFRMOUT          : in std_logic;       
      SSPRXD           : in std_logic;  
      SPO              : in std_logic;    
      SPH              : in std_logic; 
      SSESync          : in std_logic;
      TxRxBSY          : in std_logic;
      STxRxBSY         : in std_logic;
      chkTxBSY         : in std_logic;
      MS               : in std_logic;
      OD               : in std_logic;
      TiDASFRM         : in std_logic;
      SSPOE            : in std_logic;
      GENCLK1          : in std_logic;
      DSS              : in std_logic_vector(3 downto 0);
      FRF              : in std_logic_vector(1 downto 0);
      SCR              : in std_logic_vector(7 downto 0);
      PRESCALE         : in std_logic_vector(3 downto 0);
      SSPTBCLKREG      : in std_logic_vector(15 downto 0);
      SSPTBCLKREG1     : in std_logic_vector(15 downto 0)     
     );
end component;
 
component SspTrMTxRxCntl 
port (
      PRESETn         : in  std_logic;
      SSTBESync       : in  std_logic;     
      TxDataAvlblSync : in  std_logic;   
      DSS             : in  std_logic_vector(3 downto 0);     
      FRF             : in  std_logic_vector(1 downto 0);   
      SCR             : in  std_logic_vector(7 downto 0);    
      SPO             : in  std_logic;
      SPH             : in  std_logic; 
      TxFRdDataIn     : in  std_logic_vector(15 downto 0);
      SSPRXD          : in  std_logic;    
      OD              : in  std_logic;
      SCLK            : in  std_logic;    
      SFRM            : in  std_logic;   
      TxFRdPtrInc     : out std_logic;       
      RxFWr           : out std_logic;    
      TxRxBSY         : out std_logic;  
      ChkTxBSY        : out std_logic;  
      SSPTXD          : out std_logic;  
      RxFWrData       : out std_logic_vector(15 downto 0) 
     );
end component;

component SspTrSTxRxCntl
port (
      SSPCLK          : in  std_logic;
      nSSPRES         : in  std_logic;
      ClkEnable       : in  std_logic;
      SSESync         : in  std_logic;
      SSPCLKDIV       : in  std_logic;
      TxDataAvlblSync : in  std_logic;
      Nibmode         : in  std_logic;
      DSS             : in  std_logic_vector(3 downto 0);
      FRF             : in  std_logic_vector(1 downto 0);
      SCR             : in  std_logic_vector(7 downto 0);
      SPO             : in  std_logic;
      SPH             : in  std_logic;
      SPISFRMEn       : in  std_logic;
      ESFRM           : in  std_logic_vector(7 downto 0);
      FRC             : in  std_logic;
      TxFRdDataIn     : in  std_logic_vector(15 downto 0);
      SSPRXD          : in  std_logic;
      OD              : in  std_logic;
      STxFRdPtrInc    : out std_logic;
      SRxFWr          : out std_logic;
      STxRxBSY        : out std_logic;
      SSPOE           : out std_logic;
      SSPTXD          : out std_logic;
      SCLK            : out std_logic;
      SFRM            : out std_logic;
      RxFWrData       : out std_logic_vector(15 downto 0)
     );
end component;

component SspTrDMA
port (PCLK             : in  std_logic;
      PRESETn          : in  std_logic;
      SSPTXDMACLRStag1 : in  std_logic;
      SSPRXDMACLRStag1 : in  std_logic;
      SSPTXDMACLR      : out std_logic;
      SSPRXDMACLR      : out std_logic;
      SSPTXDMACLRStag4 : out std_logic;
      SSPRXDMACLRStag4 : out std_logic
      );
end component;

-- -----------------------------------------------------------------------------
-- Signal declarations 
-- -----------------------------------------------------------------------------
signal PWDATAIn         : std_logic_vector(15 downto 0); 
-- Pheripharal input data

signal RNE              : std_logic;
-- Reciever not empty
 
signal RxFRdData        : std_logic_vector(15 downto 0); 
-- Reciever FIFO Read Data

signal RxFRdPtrInc      : std_logic;
-- Reciever FIFO pointer increament
 
signal TNF              : std_logic;
-- Transmiter not full flag
 
signal TxFRdPtrInc      : std_logic;
-- Transmiter FIFO Read pointer
 
signal TxFRdPtrIncSync  : std_logic;
-- Transmiter FIFO Read pointer increament sync signal
 
signal TxDataAvlbl      : std_logic;
-- Transmiter data available
 
signal SPH              : std_logic;
-- Indicates phase of SCLK in SPI mode
 
signal SPO              : std_logic;
-- Indicates polarity of SCLK in SPI mode
 
signal SCR              : std_logic_vector(7 downto 0);
-- Serial clock rate
 
signal FRF              : std_logic_vector(1 downto 0);
-- Fram format
 
signal DSS              : std_logic_vector(3 downto 0);
-- Specifies Datasize to be transmited
 
signal SSPCLKDIV        : std_logic;
-- SSPCLOCK Division signal
 
signal SSPCLK0          : std_logic;
-- Internal SSPCLK
 
signal SSPCLK1          : std_logic;
-- Internal SSPCLK1
 
signal TxDataAvlblSync  : std_logic;
-- Transmiter data available synchronised singnal
  
signal RxFWrSync        : std_logic; 
-- Reciever Fifo write sync signal

signal RxFWr            : std_logic;
--  Reciever Fifo write signal
 
signal RxFWrData        : std_logic_vector(15 downto 0);
-- Reciever fifo data write enable
 
signal SRxFWrData       : std_logic_vector(15 downto 0);
-- Reciever fifo write data in testing slave
 
signal MRxFWrData       : std_logic_vector(15 downto 0);
--  Reciever fifo write data for master
 
signal TFE              : std_logic;
-- Transmiter fifo empty
 
signal RFF              : std_logic;
-- Reciever fifo full
 
signal SSESync          : std_logic;
-- Trickbox enable signal
 
signal nSSPRES          : std_logic;
-- SSP reset signal
 
signal SelSSPRXD        : std_logic;
-- SelSSPRXD
 
signal TxRxBSY          : std_logic;
-- Tx/Rx Busy signal
 
signal TxRxBSYSync      : std_logic;
-- Snchronized TxRxBSY
 
signal BSY              : std_logic;
-- Busy signal
 
signal ClrRORINTR       : std_logic;
-- ClrRORINTR
 
signal ClrRTINTR       : std_logic;
-- ClrRTINTR
 
signal CR0UpdateSync    : std_logic;
-- Snchronized CR0 update
 
signal CR0Update        : std_logic;
-- CR0Update
 
signal CPSRUpdateSync   : std_logic;
-- Clock prescale sync signal
 
signal CR1UpdateSync    : std_logic;
-- CR1 
 
signal CR1Update        : std_logic;
-- Control register update signal
 
signal CPSRUpdate       : std_logic;
--  Clock prescale update signal
 
signal SSPTBCR1         : std_logic_vector(5 downto 0);
-- SSPTBCR1
 
signal SSPTBCR0Wr       : std_logic;
-- Write signal to SSPTBCR0
 
signal SSPTBCR1Wr       : std_logic; 
-- Write signal to SSPTBCR1
 
signal SSPTBSRWr        : std_logic; 
-- Write signal to SSPTBSR
 
signal SSPTBTDRWr1      : std_logic; 
-- Write signal to SSPTBTDR
 
signal SSPTBTDRWr       : std_logic; 
-- Write signal to SSPTBCR0
 
signal SSPTBRDRWr       : std_logic; 
-- Write signal to SSPTBCR0
 
signal TxFRdDataIn      : std_logic_vector(15 downto 0);
-- Internal TxFRdData
 
signal SSPCPSR          : std_logic_vector(7 downto 0); 
-- SSP Clock prescale reg

signal SSPCPSC          : std_logic_vector(6 downto 0);
-- SSPCPSC
 
signal SSPTXD0          : std_logic; 
-- internal SSPTXD

signal SSPTXD1          : std_logic; 
-- internal SSPTXD

signal SSPTBPREWr       : std_logic;        
-- Write enable for SSPTBPRE

signal SSPTBSETPINSWr   : std_logic; 
-- Write enable for SSPTBSETPIN

signal SSPTBCLKREGWr    : std_logic;   
-- Write enable for SSPTBCLKREG

signal SSPTBCLKREG1Wr   : std_logic;   
-- Write enable for SSPTBCLKREG1

signal SSPTBPRE         : std_logic_vector(3 downto 0);    
-- Reg SSPTBPRE

signal SSPTBCR0         : std_logic_vector(15 downto 0);    
-- Reg  SSPTBCR0

signal TxFRdData        : std_logic_vector(15 downto 0);  
-- Transmiter FIFO Read data

signal RXFE             : std_logic;      
-- Status flag

signal RXWFLG           : std_logic;
-- Water mark status flag

signal RXW              : std_logic_vector(1 downto 0);
-- Status flag
 
signal SSPTBSETPINS     : std_logic_vector(6 downto 0); 
-- reg SSPTBSETPINS

signal SSPTBCLKREG      : std_logic_vector(15 downto 0);    
-- Specifies SSPCLK period

signal SSPTBCLKREG1     : std_logic_vector(15 downto 0);    
-- Specifies SSPCLK1 period

signal TXFF             : std_logic;       
-- Status flag

signal RXFF             : std_logic;       
-- Reciever fifo full flag

signal TXFE             : std_logic;
-- Transmiter fifo empty flag

signal PCLKOn           : std_logic;
-- To switch on PCLK

signal REFCLKOn         : std_logic;
-- To Switch on REFCLK

signal REFCLK1On        : std_logic;
-- To Switch on REFCLK1

signal MS               : std_logic;
-- Master/Slave selection

signal SSEMaster        : std_logic;
-- SSP Enable signal for master

signal SSESlave         : std_logic;
-- SSP enable signal for in slave testing 

signal SSPTBCR2         : std_logic_vector(10 downto 0);
-- CR2 Reg

signal SSPTBCR2Wr       : std_logic;
-- Write enable signal for SSPTBCR2

signal SSPOEOUT         : std_logic;
-- Data output enable from the SSP's slave testing block 
 
signal ChkTxBSY         : std_logic;
-- Check Transmiter busy

signal STxFRdPtrIncSync : std_logic;
-- Transmiter FIFO Read pointer increament sync signal

signal SRxFWrSync       : std_logic;
-- Reciever Fifo write sync signal 

signal STxRxBSY         : std_logic;
-- Tx/Rx Busy signal
 
signal STxRxBSYSync     : std_logic;
-- Snchronized TxRxBSY
 
signal SRxFWr           : std_logic;
--  Reciever Fifo write signal
 
signal STxFRdPtrInc     : std_logic;
-- Transmiter FIFO Read pointer
 
signal CombTxRxBSY      : std_logic;
-- ORed version of TxRxBSY and STxRxBSY

signal iSCLKOUT         : std_logic;
-- Internal SCLKOUT

signal iSFRMOUT         : std_logic;
-- Internal SFRMOUT

signal Nibmode          : std_logic := '0';
-- for indicating Nibmode

signal ClkEnable        : std_logic := '1';
-- Clock Enable

signal SSPTXDMACLRStag4 : std_logic;
 -- For generating SSPTXDMACLR

signal SSPRXDMACLRStag4 : std_logic;
-- For generating SSPRXDMACLR

signal SSPTBDMACRWrEn   : std_logic;
-- SSP DMA Control Reg Write Enable

signal SSPTDMACR        : std_logic_vector(1 downto 0);
-- Trickbox DMA Control Register

-- -----------------------------------------------------------------------------
--
-- Main body of code
-- =================
--
-- -----------------------------------------------------------------------------

begin

-- -----------------------------------------------------------------------------
-- Extract MS bit from SSPTBCR1 register.
-- -----------------------------------------------------------------------------
MS <= SSPTBCR1(4);
 
-- -----------------------------------------------------------------------------
-- Route the relevant Transmit data line to the SSPTXD output based on whether
-- the SSP is in the Master mode or the Slave mode.
-- -----------------------------------------------------------------------------
SSPTXD <= SSPTXD1 when (MS = '1')
       else
          SSPTXD0;
 
-- -----------------------------------------------------------------------------
-- Route SSPCLK1 to the SSP
-- -----------------------------------------------------------------------------
SSPCLK <= SSPCLK1;
 
-- -----------------------------------------------------------------------------
-- FIFO Fill level status signals.
-- -----------------------------------------------------------------------------
TXFF <= not TNF;
RXFE <= not RNE;
 
-- -----------------------------------------------------------------------------
-- Route the relevant Receive data to the Receive FIFO based on whether
-- the SSP is in the Master mode or the Slave mode.
-- -----------------------------------------------------------------------------
RxFWrData <= SRxFWrData when (MS = '1') 
          else
             MRxFWrData;
 
-- -----------------------------------------------------------------------------
-- Generate individual enable signals for the Master-testing block and the
-- Slave-testing block.
-- -----------------------------------------------------------------------------
SSEMaster <= '1'         when ((MS = '0') and  (SSESync = '1'))
          else
             '0';

SSESlave  <= '1'         when ((MS = '1') and  (SSESync = '1'))
          else
             '0'; 

-- -----------------------------------------------------------------------------
-- Master TxRxBSY and Slave TxRxBSY are ORed
-- -----------------------------------------------------------------------------
CombTxRxBSY  <= TxRxBSY or STxRxBSY;

-- -----------------------------------------------------------------------------
-- Connects the internal signal to output
-- -----------------------------------------------------------------------------
SCLKOUT <= iSCLKOUT;
SFRMOUT <= iSFRMOUT;

-- -----------------------------------------------------------------------------
-- The APB Interface contains the Write interface and the Read interface
-- for registers in the SSPTrickbox.
-- -----------------------------------------------------------------------------
uSspTrApbif: SspTrApbif
port map (
          PRESETn          => PRESETn,
          PCLK             => PCLK,
          PSEL             => PSELT,
          PWRITE           => PWRITE,
          PENABLE          => PENABLE,
          PADDR            => PADDR,
          PWDATA           => PWDATA,
          SSPTBPRE         => SSPTBPRE, 
          SSPTBCR0         => SSPTBCR0,
          SSPTBCR1         => SSPTBCR1,
          SSPTBCR2         => SSPTBCR2,
          RxFRdData        => RxFRdData,
          TxFRdData        => TxFRdData,
          RxFRdPtrInc      => RxFRdPtrInc,
          TXFF             => TXFF,
          TXFE             => TFE,
          RXFE             => RXFE, 
          RXFF             => RFF,
          BSY              => TxRxBSYSync,  
          SSPTBSETPINS     => SSPTBSETPINS, 
          SSPTBCLKREG      => SSPTBCLKREG, 
          SSPTBCLKREG1     => SSPTBCLKREG1, 
          SSPINTR          => SSPINTR, 
          SSPTXINTR        => SSPTXINTR, 
          SSPRXINTR        => SSPRXINTR, 
          SSPRORINTR       => SSPRORINTR,
          SSPRTINTR        => SSPRTINTR,
          RXWFLG           => RXWFLG,  
          PCLKOn           => PCLKOn,  
          REFCLKOn         => REFCLKOn , 
          REFCLK1On        => REFCLK1On , 
          SSPTXDMASREQ     => SSPTXDMASREQ,
          SSPTXDMABREQ     => SSPTXDMABREQ,
          SSPRXDMASREQ     => SSPRXDMASREQ,
          SSPRXDMABREQ     => SSPRXDMABREQ,
          SSPTBCR0Wr       => SSPTBCR0Wr, 
          SSPTBCR1Wr       => SSPTBCR1Wr, 
          SSPTBCR2Wr       => SSPTBCR2Wr, 
          SSPTBPREWr       => SSPTBPREWr, 
          SSPTBTDRWr       => SSPTBTDRWr,
          SSPTBRDRWr       => SSPTBRDRWr, 
          SSPTBSRWr        => SSPTBSRWr,
          SSPTBSETPINSWr   => SSPTBSETPINSWr, 
          SSPTBCLKREGWr    => SSPTBCLKREGWr,
          SSPTBCLKREG1Wr   => SSPTBCLKREG1Wr,
          SSPTBDMACRWrEn   => SSPTBDMACRWrEn,
          PRDATA           => PRDATA, 
          PWDATAIn         => PWDATAIn 
         );

-- -----------------------------------------------------------------------------
-- The SspTrTxFIFO block contains the Transmit FIFO and the control logic
-- required to regulate accesses to the FIFO.
-- -----------------------------------------------------------------------------
uSspTrTxFIFO: SspTrTxFIFO
port map (
          PCLK             => PCLK,
          PRESETn          => PRESETn,
          SSPTBTDRWr       => SSPTBTDRWr,
          PWDATAIn         => PWDATAIn,
          TxFRdPtrIncSync  => TxFRdPtrIncSync,
          STxFRdPtrIncSync => STxFRdPtrIncSync,
          MS               => MS,
          TxFRdDataIn      => TxFRdDataIn,
          TxDataAvlbl      => TxDataAvlbl,
          TNF              => TNF,
          TFE              => TFE,
          TxRxBSYSync      => TxRxBSYSync,
          BSY              => BSY,
          FRF              => SSPTBCR0(5 downto 4),
          DSS              => SSPTBCR0(3 downto 0)
         );

-- -----------------------------------------------------------------------------
-- The SspTrRxFIFO block contains the Receive FIFO and the control logic
-- required to regulate accesses to the FIFO.
-- -----------------------------------------------------------------------------
uSspTrRxFIFO: SspTrRxFIFO
port map (
          PCLK        => PCLK,
          PRESETn     => PRESETn,
          RxFWrSync   => RxFWrSync,
          SRxFWrSync  => SRxFWrSync,
          RxFWrData   => RxFWrData,
          RxFRdPtrInc => RxFRdPtrInc,
          RxFRdData   => RxFRdData,
          RNE         => RNE,
          RXWFLG      => RXWFLG, 
          RFF         => RFF,
          RXW         => SSPTBCR1(3 downto 2)
         );

-- -----------------------------------------------------------------------------
-- This block contains synchronisers for signals crossing into the PCLK
-- domain.
-- -----------------------------------------------------------------------------
uSspTrSynctoPCLK: SspTrSynctoPCLK
port map (
          PCLK             => PCLK,
          PRESETn          => PRESETn,
          TxRxBSY          => CombTxRxBSY,
          TxRxBSYSync      => TxRxBSYSync,
          TxFRdPtrInc      => TxFRdPtrInc,
          STxFRdPtrInc     => STxFRdPtrInc,
          TxFRdPtrIncSync  => TxFRdPtrIncSync,
          STxFRdPtrIncSync => STxFRdPtrIncSync,
          RxFWr            => RxFWr,
          SRxFWr           => SRxFWr,
          RxFWrSync        => RxFWrSync,
          SRxFWrSync       => SRxFWrSync
         );

-- -----------------------------------------------------------------------------
-- The SspTrRegCore Block contains all the read/writable  registers
-- in the SSPTrickbox. It also contains the PCLK-domain part of the control
-- logic required to synchronise the contents of SSPTBCR0 and SSPTBCR1 to the 
-- SSPCLK domain.
-- -----------------------------------------------------------------------------
uSspTrRegCore: SspTrRegCore
port map (
          PCLK             => PCLK,
          PRESETn          => PRESETn,
          SSPTBCR0Wr       => SSPTBCR0Wr,
          SSPTBCR1Wr       => SSPTBCR1Wr,
          SSPTBCR2Wr       => SSPTBCR2Wr,
          SSPTBCR0         => SSPTBCR0,
          CR0Update        => CR0Update,
          SSPTBCR1         => SSPTBCR1,
          SSPTBCR2         => SSPTBCR2,
          CR1Update        => CR1Update,
          SSPTBSRWr        => SSPTBSRWr,   
          SSPTBPREWr       => SSPTBPREWr,
          SSPTBTDRWr       => SSPTBTDRWr, 
          SSPTBRDRWr       => SSPTBRDRWr,
          SSPTBSETPINSWr   => SSPTBSETPINSWr,
          SSPTBCLKREGWr    => SSPTBCLKREGWr, 
          SSPTBCLKREG1Wr   => SSPTBCLKREG1Wr, 
          SSPTBDMACRWrEn   => SSPTBDMACRWrEn,
          PWDATAIn         => PWDATAIn,
          SSPTXDMACLRStag4 => SSPTXDMACLRStag4,
          SSPRXDMACLRStag4 => SSPRXDMACLRStag4,
          SSPTBCLKREG      => SSPTBCLKREG,
          SSPTBCLKREG1     => SSPTBCLKREG1,
          SSPTBSETPINS     => SSPTBSETPINS, 
          SSPTBPRE         => SSPTBPRE,
          SSPTDMACR        => SSPTDMACR
          );

-- -----------------------------------------------------------------------------
-- The SspTrSynctoSSPCLK block contains synchronisers for signals crossing
-- into the SSPCLK domain. 
-- -----------------------------------------------------------------------------
uSspTrSynctoSSPCLK: SspTrSynctoSSPCLK
port map (
          SSPCLK          => SSPCLK0,
          nSSPRES         => PRESETn, 
          TxDataAvlbl     => TxDataAvlbl,
          TxDataAvlblSync => TxDataAvlblSync,
          CR0Update       => CR0Update,
          CR0UpdateSync   => CR0UpdateSync,
          CR1Update       => CR1Update,
          CR1UpdateSync   => CR1UpdateSync,
          SSESync         => SSESync,
          SSE             => SSPTBCR0(6)
         );

-- -----------------------------------------------------------------------------
-- The SspTrSynctoSSPCLK block contains synchronisers for signals crossing
-- into the SSPCLK domain. 
-- -----------------------------------------------------------------------------
uSspTrCkRsCntlr: SspTrCkRsCntlr
port map(
         PCLK         => PCLK,        
         PRESETn      => PRESETn,    
         SCANMODEIN   => SSPTBSETPINS(0), 
         RSTMODE      => SSPTBSETPINS(1),  
         SSPTrCNTLR   => SSPTBSETPINS(6 downto 2 ),  
         SSPTBCLKREG  => SSPTBCLKREG, 
         SSPTBCLKREG1 => SSPTBCLKREG1, 
         SSPCLK       => SSPCLK0,     
         SSPCLK1      => SSPCLK1,     
         PCLKOn       => PCLKOn,     
         REFCLKOn     => REFCLKOn,     
         REFCLK1On    => REFCLK1On,     
         nSSPRST      => nSSPRST,    
         SCANMODE     => SCANMODE 
        );

-- -----------------------------------------------------------------------------
-- This block performs division of the SSPCLK by the Prescale value and
-- generates the SSPCLKDIV signal.
-- -----------------------------------------------------------------------------
uSspTrScaleCntr: SspTrScaleCntr
port map (
          SSPCLK         => SSPCLK0,
          nSSPRES        => PRESETn,
          SSPTBCR0       => SSPTBCR0,
          SSPTBCR1       => SSPTBCR1,
          SSPTBPRE       => SSPTBPRE,
          DSS            => DSS,
          FRF            => FRF,
          SCR            => SCR,
          SPO            => SPO,
          SPH            => SPH,
          SSESync        => SSESync,
          CR0UpdateSync  => CR0UpdateSync,
          CR1UpdateSync  => CR1UpdateSync,
          SSPCLKDIV      => SSPCLKDIV
         );

-- -----------------------------------------------------------------------------
-- The SspTrChecker block contains protocol checkers that monitor the SSP's
-- non-AMBA outputs. 
-- -----------------------------------------------------------------------------
uSspTrChecker:SspTrChecker
port map ( 
          PCLK         => PCLK,   
          SSPCLK       => SSPCLK1, 
          PRESETn      => PRESETn, 
          SCLK         => SCLKIN,    
          SFRM         => SFRMIN,   
          SCLKOUT      => iSCLKOUT,    
          SFRMOUT      => iSFRMOUT,   
          SSPRXD       => SSPRXD,   
          SPO          => SSPTBCR1(0),        
          SPH          => SSPTBCR1(1),     
          SSESync      => SSPTBCR0(6), 
          TxRxBSY      => TxRxBSY,
          STxRxBSY     => STxRxBSY,
          ChkTxBSY     => ChkTxBSY,
          MS           => SSPTBCR1(4),
          OD           => SSPTBCR1(5),
          TiDASFRM     => SSPTBCR2(10),
          SSPOE        => SSPOEOUT,
          GENCLK1      => SSPTBSETPINS(6),
          FRF          => FRF,   
          DSS          => DSS,   
          SCR          => SCR,
          PRESCALE     => SSPTBPRE, 
          SSPTBCLKREG  => SSPTBCLKREG,
          SSPTBCLKREG1 => SSPTBCLKREG1
         );
 
-- -----------------------------------------------------------------------------
-- The SspMTxRxCntl block contains the main Transmit/Receive control logic in
-- the trickbox that verifies the Master mode functionality of the SSP.
-- -----------------------------------------------------------------------------
uSspTrMTxRxCntl: SspTrMTxRxCntl
port map (
          PRESETn         => PRESETn, 
          DSS             => DSS,
          FRF             => FRF,
          SCR             => SCR,
          SPO             => SPO,
          SPH             => SPH,
          SSTBESync       => SSEMaster,
          TxDataAvlblSync => TxDataAvlblSync,
          TxFRdDataIn     => TxFRdDataIn,
          SSPRXD          => SSPRXD, 
          OD              => SSPTBCR1(5),
          TxRxBSY         => TxRxBSY,
          ChkTxBSY        => ChkTxBSY,
          SSPTXD          => SSPTXD0,
          SCLK            => SCLKIN,
          SFRM            => SFRMIN,
          TxFRdPtrInc     => TxFRdPtrInc,
          RxFWr           => RxFWr,
          RxFWrData       => MRxFWrData
         ); 

-- -----------------------------------------------------------------------------
-- The SspSTxRxCntl block contains the main Transmit/Receive control logic in
-- the trickbox that verifies the Slave mode functionality of the SSP.
-- -----------------------------------------------------------------------------
uSspTrSTxRxCntl : SspTrSTxRxCntl
port map (
          SSPCLK            => SSPCLK0,
          nSSPRES           => PRESETn,
          ClkEnable         => ClkEnable,
          SSESync           => SSESlave,
          SSPCLKDIV         => SSPCLKDIV,
          TxDataAvlblSync   => TxDataAvlblSync,
          Nibmode           => Nibmode,
          DSS               => DSS,
          FRF               => FRF,
          SCR               => SCR,
          SPO               => SPO,
          SPH               => SPH,
          SPISFRMEn         => SSPTBCR2(9),
          ESFRM             => SSPTBCR2(7 downto 0),
          FRC               => SSPTBCR2(8),
          TxFRdDataIn       => TxFRdDataIn,
          SSPRXD            => SSPRXD,
          OD                => SSPTBCR1(5),
          STxFRdPtrInc      => STxFRdPtrInc,
          SRxFWr            => SRxFWr,
          STxRxBSY          => STxRxBSY,
          SSPOE             => SSPOEOUT,
          SSPTXD            => SSPTXD1,
          SCLK              => iSCLKOUT,
          SFRM              => iSFRMOUT,
          RxFWrData         => SRxFWrData
         );

uSspTrDMA : SspTrDMA
port map (
          PCLK             => PCLK,
          PRESETn          => PRESETn,
          SSPTXDMACLRStag1 => SSPTDMACR(0),
          SSPRXDMACLRStag1 => SSPTDMACR(1),
          SSPTXDMACLR      => SSPTXDMACLR,
          SSPRXDMACLR      => SSPRXDMACLR,
          SSPTXDMACLRStag4 => SSPTXDMACLRStag4,
          SSPRXDMACLRStag4 => SSPRXDMACLRStag4
    );
  
end structural;

-- --============================ End ========================================--
