--  ----------------------------------------------------------------------------
--  This confidential and proprietary software may be used only as
--  authorised by a licensing agreement from ARM Limited
--    (C) COPYRIGHT 1999-2000 ARM Limited
--        ALL RIGHTS RESERVED
--  The entire notice above must be reproduced on all authorised
--  copies and copies may only be made to the extent permitted
--  by a licensing agreement from ARM Limited.
--  ----------------------------------------------------------------------------
--  
--  Version and Release Control Information:
--  
--  File Name              : UartSynctoPCLK.vhd.rca
--  File Revision          : 1.11
--  
--  Release Information    : PrimeCell(TM)-PL011-REL1v3
--  
--  ----------------------------------------------------------------------------
--  
--  
--  
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;


entity UartSynctoPCLK is
  port (
        PCLK             : in  std_logic;      -- APB Bus Clock
        PRESETn          : in  std_logic;      -- AMBA Bus reset
        
        TXBUSY           : in  std_logic;      -- Transmitter Busy
        TXFRdPtrInc      : in  std_logic;      -- TX FIFO Read pointer Incr.
        RXFWr            : in  std_logic;      -- RX FIFO Write enable
        Abort            : in  std_logic;      -- Abort transmission
        DataStp          : in  std_logic;      -- Receive line Idle
        
        nDCD             : in  std_logic;      -- Modem signal
        nDSR             : in  std_logic;      -- Modem Signal
        nCTS             : in  std_logic;      -- Modem Signal
        nRI              : in  std_logic;      -- Modem Signal
        UARTRISmod       : in  std_logic_vector(3 downto 0);
                                              -- Raw interrupt status
        UARTMISmod       : in  std_logic_vector(3 downto 0);
                                              -- Masked interrupt status
        UARTRISerr       : in  std_logic_vector(2 downto 0);
                                              -- Raw error interrupts
        UARTMISerr       : in  std_logic_vector(2 downto 0);
                                              -- Masked error interrupts
        
        IntUARTTXDMACLR  : in  std_logic;      -- DMA Tx Clear      
        IntUARTRXDMACLR  : in  std_logic;      -- DMA Rx Clear      
        CharTxComp       : in  std_logic;      -- Tx character Complete      
        
        TXBUSYSync       : out std_logic;      -- To TX FIFO
        TXFRdPtrIncSync  : out std_logic;      -- To TX FIFO
        RXFWrSync        : out std_logic;      -- To RX FIFO
        AbortSync        : out std_logic;      -- To TX FIFO
        
        nDCDSyncPCLK     : out std_logic;      -- Sync'ed DCD
        nDSRSyncPCLK     : out std_logic;      -- Sync'ed DSR
        nCTSSyncPCLK     : out std_logic;      -- Sync'ed CTS
        nRISyncPCLK      : out std_logic;      -- Sync'ed RI
        UARTRTRIS        : out std_logic;      -- Receive Timeout interrupt
        UARTRISmodSync   : out std_logic_vector(3 downto 0);
                                              --  Synchro Raw int status
        UARTMISmodSync   : out std_logic_vector(3 downto 0);
                                              --  Synchro Masked int status
        UARTRISerrSync   : out std_logic_vector(2 downto 0);
                                              -- Synchro raw error interrupts  
        UARTMISerrSync   : out std_logic_vector(2 downto 0);
                                              -- SynchroMasked error interrupts
        
        UARTTXDMACLRSync : out std_logic;     -- Sync'ed DMA TX Clear
        UARTRXDMACLRSync : out std_logic;     -- Sync'ed DMA RX Clear
        CharTxCompSync   : out std_logic      -- Sync'ed Tx character complete
        );
end UartSynctoPCLK;

--------------------------------------------------------------------------------
-- Purpose     : This block synchronises signals crossing over from
--               the UARTCLK domain into the PCLK domain.
--------------------------------------------------------------------------------
--
--------------------------------------------------------------------------------
--
--                   UartSynctoPCLK
--                   ==============
--
--------------------------------------------------------------------------------
--
-- Overview
-- ========
--
-- This module synchronises signals crossing over from the UARTCLK
-- domain into the PCLK domain. 
--------------------------------------------------------------------------------
--
--=============================== ARCHITECTURE ===============================--
--
--------------------------------------------------------------------------------
-- Architecture Packages
--------------------------------------------------------------------------------


architecture synth of UartSynctoPCLK  is

--------------------------------------------------------------------------------
-- Component Declaration
--------------------------------------------------------------------------------
  
--------------------------------------------------------------------------------
-- Internal Constants
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Internal Signals
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Intermediate first stage and second stage synchronised signals 
-- corresponding to each input
--------------------------------------------------------------------------------
  signal DataStpSy1          : std_logic;
  -- 1st stage synchronised version of DataStp input

  signal RXFWrSy1            : std_logic;
  -- 1st stage synchronised version of RXFWr input

  signal TXBUSYSy1           : std_logic;
  -- 1st stage synchronised version of TXBUSY input

  signal TXFRPtrIncSy1       : std_logic;
  -- 1st stage synchronised version of TXFRdPtrInc input

  signal AbortSy1            : std_logic;
  -- 1st stage synchronised version of Abort input

  signal nDCDSy1             : std_logic;
  -- 1st stage synchronised version of nDCD input

  signal nDSRSy1             : std_logic;
  -- 1st stage synchronised version of nDSR input

  signal nCTSSy1             : std_logic;
  -- 1st stage synchronised version of nCTS input

  signal nRISy1              : std_logic;
  -- 1st stage synchronised version of nRI input
  
  signal UARTRISmodSy1       : std_logic_vector(3 downto 0);
  -- 1st stage synchronised version of UARTRISmod
  
  signal UARTMISmodSy1       : std_logic_vector(3 downto 0);
  -- 1st stage synchronised version of UARTMISmod

  signal UARTRISerrSy1       : std_logic_vector(2 downto 0);
  -- 1st stage synchronised version of UARTRISerrSync
  
  signal UARTMISerrSy1       : std_logic_vector(2 downto 0);
  -- 1st stage synchronised version of UARTMISerrSync
  
  signal UARTTXDMACLRSy1     : std_logic;
  -- 1st stage synchronised version of IntUARTTXDMACLR
  
  signal UARTRXDMACLRSy1     : std_logic;
  -- 1st stage synchronised version of IntUARTRXDMACLR
  
  signal CharTxCompSy1       : std_logic;
  -- 1st stage synchronised version of CharTxComp
--------------------------------------------------------------------------------
--
-- Main VHDL code
-- ==============
--
--------------------------------------------------------------------------------

begin

--------------------------------------------------------------------------------
-- Synchronisers for FIFO-related signals, interrupts and DMA signals 
--------------------------------------------------------------------------------

  p_FIFOs : process (PCLK, PRESETn)
  begin
    if (PRESETn = '0') then
      DataStpSy1      <= '0';
      UARTRTRIS         <= '0';
      RXFWrSy1        <= '0';
      RXFWrSync         <= '0';
      TXFRPtrIncSy1   <= '0';
      TXFRdPtrIncSync   <= '0';
      AbortSy1        <= '0';
      AbortSync         <= '0';
      UARTRISmodSync    <= "0000";
      UARTRISmodSy1   <= "0000";
      UARTMISmodSync    <= "0000";
      UARTMISmodSy1   <= "0000";
      UARTRISerrSync    <= "000";
      UARTRISerrSy1   <= "000";
      UARTMISerrSync    <= "000";
      UARTMISerrSy1   <= "000";
      UARTTXDMACLRSy1 <= '0';
      UARTTXDMACLRSync  <= '0';
      UARTRXDMACLRSy1 <= '0';
      UARTRXDMACLRSync  <= '0';
      CharTxCompSy1  <= '0';
      CharTxCompSync <= '0';
    elsif ((PCLK'event) and (PCLK = '1')) then
      DataStpSy1      <= DataStp;
      UARTRTRIS         <= DataStpSy1;

      RXFWrSy1        <= RXFWr;
      RXFWrSync         <= RXFWrSy1;

      TXFRPtrIncSy1   <= TXFRdPtrInc;
      TXFRdPtrIncSync   <= TXFRPtrIncSy1;

      AbortSy1        <= Abort;
      AbortSync         <= AbortSy1;

      UARTRISmodSy1   <= UARTRISmod;
      UARTRISmodSync    <= UARTRISmodSy1;
      
      UARTMISmodSy1   <= UARTMISmod;
      UARTMISmodSync    <= UARTMISmodSy1;
      
      UARTRISerrSy1   <= UARTRISerr;
      UARTRISerrSync    <= UARTRISerrSy1;
      
      UARTMISerrSy1   <= UARTMISerr;
      UARTMISerrSync    <= UARTMISerrSy1;

      UARTTXDMACLRSy1 <= IntUARTTXDMACLR;
      UARTTXDMACLRSync  <= UARTTXDMACLRSy1;
      
      UARTRXDMACLRSy1 <= IntUARTRXDMACLR;
      UARTRXDMACLRSync  <= UARTRXDMACLRSy1;  
      
      CharTxCompSy1   <= CharTxComp;
      CharTxCompSync  <= CharTxCompSy1;  
         
    end if;
  end process p_FIFOs;


--------------------------------------------------------------------------------
-- Synchroniser for TXBUSY signal.
--------------------------------------------------------------------------------
  p_TXBUSY : process (PCLK, PRESETn)
  begin
    if (PRESETn = '0') then
      TXBUSYSy1 <= '0';
      TXBUSYSync  <= '0';
    elsif (PCLK'event and PCLK = '1' ) then
      TXBUSYSy1 <= TXBUSY;
      TXBUSYSync  <= TXBUSYSy1;
    end if;
  end process p_TXBUSY;

--------------------------------------------------------------------------------
-- Synchronisers for Modem-related signals.
--------------------------------------------------------------------------------
  p_Modem : process (PCLK, PRESETn)
  begin
    if (PRESETn = '0') then
      nDCDSyncPCLK  <= '0';
      nDCDSy1     <= '0';
      nDSRSyncPCLK  <= '0';
      nDSRSy1     <= '0';
      nCTSSyncPCLK  <= '0';
      nCTSSy1     <= '0';
      nRISyncPCLK   <= '0';
      nRISy1      <= '0';    
    elsif (PCLK'event and PCLK = '1') then
      nDCDSy1     <= nDCD;
      nDCDSyncPCLK  <= nDCDSy1;
      nDSRSy1     <= nDSR;
      nDSRSyncPCLK  <= nDSRSy1;
      nCTSSy1     <= nCTS;
      nCTSSyncPCLK  <= nCTSSy1;
      nRISy1      <= nRI;
      nRISyncPCLK   <= nRISy1;      
    end if;
  end process p_Modem;

end synth;

--========================== End of UartSynctoPCLK ===========================--




