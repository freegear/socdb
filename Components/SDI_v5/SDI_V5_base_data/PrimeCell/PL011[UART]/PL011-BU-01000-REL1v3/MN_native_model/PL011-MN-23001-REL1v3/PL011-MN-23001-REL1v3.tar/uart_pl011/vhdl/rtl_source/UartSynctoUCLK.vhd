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
--  File Name              : UartSynctoUCLK.vhd.rca
--  File Revision          : 1.9
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

entity UartSynctoUCLK is
  port (
        UARTCLK          : in  std_logic;      -- Main UART Clock
        nUARTRST         : in  std_logic;      -- Muxed reset (from nUARTRST)
        
        BRK              : in  std_logic;      -- Break bit
        SIRLP            : in  std_logic;      -- SIR Low power mode
        SIREN            : in  std_logic;      -- SIR Enabled
        UARTEN           : in  std_logic;      -- UART Enabled
        TXE              : in  std_logic;      -- TX Enabled
        RXE              : in  std_logic;      -- RX Enabled         
        TXDataAvlbl      : in  std_logic;      -- TX Data available
        RXFE             : in  std_logic;      -- RX FIFO Empty
        CTSEn            : in  std_logic;      -- CTS flow control enable
        LCRUpdate        : in  std_logic;      -- Sync control signal for LCR
        ILPRUpdate       : in  std_logic;      -- Sync ctrl signal for ILPR
        FBRDUpdate       : in  std_logic;      -- Sync control signal for FBRD
        UARTRXD          : in  std_logic;      -- UART Receive input
        SIRIN            : in  std_logic;      -- SIR Receive input
        RXFWrDone        : in  std_logic;      -- RX FIFO Wr Done
        RdPtrIncDone     : in  std_logic;      -- Read Pointer Inc Done
        
        DCDIM            : in  std_logic;      -- UARTDCDINTR Interrupt Enable
        DSRIM            : in  std_logic;      -- UARTDSRINTR Interrupt Enable
        CTSIM            : in  std_logic;      -- UARTCTSINTR Interrupt Enable
        RIIM             : in  std_logic;      -- UARTRIINTR Interrupt Enable
        RTIM             : in  std_logic;      -- UARTRTINTR Interrupt Enable        
        FEIM             : in  std_logic;      -- UARTFEINTR Interrupt Enable        
        PEIM             : in  std_logic;      -- UARTPEINTR Interrupt Enable        
        BEIM             : in  std_logic;      -- UARTBEINTR Interrupt Enable
            
        nDCD             : in  std_logic;      -- Modem signal
        nDSR             : in  std_logic;      -- Modem signal
        nCTS             : in  std_logic;      -- Modem signal
        nRI              : in  std_logic;      -- Modem signal     
        UARTDCDIC        : in  std_logic;      -- Modem DCD Intr Clear
        UARTDSRIC        : in  std_logic;      -- Modem DSR Intr Clear
        UARTCTSIC        : in  std_logic;      -- Modem CTS Intr Clear
        UARTRIIC         : in  std_logic;      -- Modem RI Intr Clear
        UARTFEIC         : in  std_logic;      -- For Framing Error Intr Clear   
        UARTPEIC         : in  std_logic;      -- For Parity Error Intr Clear   
        UARTBEIC         : in  std_logic;      -- For Break Error Intr Clear   
        UARTRTIC         : in  std_logic;      -- For Receive Timeout Intr Clear
        
        SIRLPSync        : out std_logic;      -- To IrDA block
        SIRENSync        : out std_logic;      -- To IrDA block
        UARTENSync       : out std_logic;      -- Sync'ed UART Eable
        TXESync          : out std_logic;      -- Sync'ed TX Eable
        RXESync          : out std_logic;      -- Sync'ed RX Enable         
        TXDataAvlblSync  : out std_logic;      -- To Transmit block
        RXFESync         : out std_logic;      -- To Receive block
        CTSEnSyncUCLK    : out std_logic;       -- To Transmit block
        LCRUpdateSync    : out std_logic;      -- To BaudGen
        ILPRUpdateSync   : out std_logic;      -- To BaudGen block
        FBRDUpdateSync   : out std_logic;      -- To BaudGen
        UARTRXDSync      : out std_logic;      -- To Receiver
        SIRINSync        : out std_logic;      -- To IrDA block
        RXFWrDoneSync    : out std_logic;      -- To Receiver
        RdPtrIncDoneSync : out std_logic;      -- To Transmitter
        
        DCDIMSync        : out std_logic;      -- To Modem block
        DSRIMSync        : out std_logic;      -- To Modem block
        CTSIMSync        : out std_logic;      -- To Modem block
        RIIMSync         : out std_logic;      -- To Modem block
        RTIMSync         : out std_logic;      -- To Receive block
        FEIMSync         : out std_logic;      -- To Receive block
        PEIMSync         : out std_logic;      -- To Receive block
        BEIMSync         : out std_logic;      -- To Receive block
        
        nDCDSyncUARTCLK  : out std_logic;      -- To Modem block
        nDSRSyncUARTCLK  : out std_logic;      -- To Modem block
        nCTSSyncUARTCLK  : out std_logic;      -- To Modem block
        nRISyncUARTCLK   : out std_logic;      -- To Modem block
        UARTDCDICSync    : out std_logic;      -- To Modem block
        UARTDSRICSync    : out std_logic;      -- To Modem block
        UARTCTSICSync    : out std_logic;      -- To Modem block
        UARTRIICSync     : out std_logic;      -- To Modem block
        UARTFEICSync     : out std_logic;      -- To UART Receiver
        UARTPEICSync     : out std_logic;      -- To UART Receiver
        UARTBEICSync     : out std_logic;      -- To UART Receiver
        UARTRTICSync     : out std_logic;      -- To UART Receiver
        BRKSync          : out std_logic       -- To UART Transmiter
        );
end UartSynctoUCLK;

--------------------------------------------------------------------------------
-- Purpose     : This block synchronises signals crossing over from
--               the PCLK domain into the UARTCLK domain.
--------------------------------------------------------------------------------
--
--------------------------------------------------------------------------------
--
--                   UartSynctoUCLK
--                   ==============
--
--------------------------------------------------------------------------------
-- Overview
-- ========
--
-- This module synchronises signals crossing over from the PCLK
-- domain into the UARTCLK domain.
--------------------------------------------------------------------------------
--
--=============================== ARCHITECTURE ===============================--
--
--------------------------------------------------------------------------------
-- Architecture Packages
--------------------------------------------------------------------------------

architecture synth of UartSynctoUCLK  is

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
  signal UARTRXDSync1         : std_logic;
  -- 1st stage synchronised version of UARTRXD input
  
  signal SIRINSync1           : std_logic;
  -- 1st stage synchronised version of SIRIN input

  signal RXFWrDoneSync1       : std_logic;
  -- 1st stage synchronised version of RXFWrDone input

  signal RPtrInDnSync1        : std_logic;
  -- 1st stage synchronised version of RdPtrIncDone input

  signal nDCDSync1            : std_logic;
  -- 1st stage synchronised version of nDCD input

  signal nDSRSync1            : std_logic;
  -- 1st stage synchronised version of nDSR input

  signal nCTSSync1            : std_logic;
  -- 1st stage synchronised version of nCTS input

  signal nRISync1             : std_logic;
  -- 1st stage synchronised version of nRI input

  signal TXDataAvlblSync1     : std_logic;
  -- 1st stage synchronised version of TXDataAvlbl input

  signal RXFESync1            : std_logic;
  -- 1st stage synchronised version of RXFE input

  signal DCDIMSync1           : std_logic;
  -- 1st stage synchronised version of DCDIM input

  signal DSRIMSync1           : std_logic;
  -- 1st stage synchronised version of DSRIM input

  signal CTSIMSync1           : std_logic;
  -- 1st stage synchronised version of CTSIM input

  signal RIIMSync1            : std_logic;
  -- 1st stage synchronised version of RIIM input
  
  signal RTIMSync1            : std_logic;
  -- 1st stage synchronised version of RTIM input

  signal FEIMSync1            : std_logic;
  -- 1st stage synchronised version of FEIM input

  signal PEIMSync1            : std_logic;
  -- 1st stage synchronised version of PEIM input

  signal BEIMSync1            : std_logic;
  -- 1st stage synchronised version of BEIM input

  signal SIRLPSync1           : std_logic;
  -- 1st stage synchronised version of SIRLP input

  signal SIRENSync1           : std_logic;
  -- 1st stage synchronised version of SIREN input

  signal UARTENSync1          : std_logic;
  -- 1st stage synchronised version of UARTEN input

  signal  TXESync1            : std_logic;
  -- 1st stage synchronised version of TXE input

  signal  RXESync1            : std_logic;
  -- 1st stage synchronised version of RXE input 

  signal LCRUpdateSync1       : std_logic;
  -- 1st stage synchronised version of LCRUpdate input

  signal ILPRUpdateSync1      : std_logic;
  -- 1st stage synchronised version of ILPRUpdate input

  signal FBRDUpdateSync1      : std_logic;
  -- 1st stage synchronised version of FBRDUpdate input

  signal UARTFEICSync1        : std_logic;
  -- 1st stage synchronised version of UARTFEIC input
  
  signal UARTPEICSync1        : std_logic;
  -- 1st stage synchronised version of UARTPEIC input
  
  signal UARTBEICSync1        : std_logic;
  -- 1st stage synchronised version of UARTBEIC input
  
  signal UARTRTICSync1        : std_logic;
  -- 1st stage synchronised version of UARTRTIC input
  
  signal UARTDCDICSync1       : std_logic;
  -- 1st stage synchronised version of DCDIC input
  
  signal UARTDSRICSync1       : std_logic;
  -- 1st stage synchronised version of DSRIC input
  
  signal UARTCTSICSync1       : std_logic;
  -- 1st stage synchronised version of CTSIC input
  
  signal UARTRIICSync1        : std_logic;
  -- 1st stage synchronised version of RIIC input

  signal CTSEnSync1           : std_logic;
  -- 1st stage synchronised version of CTSEn

  signal BRKSync1             : std_logic;
  -- 1st stage synchronised version of BRK

--------------------------------------------------------------------------------
--
-- Main VHDL code
-- ==============
--
--------------------------------------------------------------------------------

begin

--------------------------------------------------------------------------------
-- Synchronisers for Modem-related signals.
--------------------------------------------------------------------------------
  p_Modem : process (UARTCLK, nUARTRST)
  begin
    if (nUARTRST = '0') then
      nDCDSync1       <= '0';
      nDCDSyncUARTCLK <= '0';
      nDSRSync1       <= '0';
      nDSRSyncUARTCLK <= '0';
      nCTSSync1       <= '0';
      nCTSSyncUARTCLK <= '0';
      nRISync1        <= '0';
      nRISyncUARTCLK  <= '0';    
    elsif (UARTCLK'event and UARTCLK = '1') then
      nDCDSync1       <= nDCD;
      nDCDSyncUARTCLK <= nDCDSync1;

      nDSRSync1       <= nDSR;
      nDSRSyncUARTCLK <= nDSRSync1;

      nCTSSync1       <= nCTS;
      nCTSSyncUARTCLK <= nCTSSync1;

      nRISync1        <= nRI;
      nRISyncUARTCLK  <= nRISync1;  
    end if;
  end process p_Modem;

--------------------------------------------------------------------------------
-- Synchronisers for Serial data input signals
--------------------------------------------------------------------------------
  p_Receive : process (UARTCLK, nUARTRST)
  begin
    if (nUARTRST = '0') then
      SIRINSync1   <= '0';
      SIRINSync    <= '0';
      UARTRXDSync1 <= '0';
      UARTRXDSync  <= '0';
    elsif (UARTCLK'event and UARTCLK = '1') then
      SIRINSync1   <= SIRIN;
      SIRINSync    <= SIRINSync1;

      UARTRXDSync1 <= UARTRXD;
      UARTRXDSync  <= UARTRXDSync1;
    end if;
  end process p_Receive;

--------------------------------------------------------------------------------
-- Synchronisers for FIFO-related signals
--------------------------------------------------------------------------------
  p_FIFOs : process (UARTCLK, nUARTRST)
  begin
    if (nUARTRST = '0') then    
      RXFWrDoneSync1   <= '0';
      RXFWrDoneSync    <= '0';
      RPtrInDnSync1    <= '0';
      RdPtrIncDoneSync <= '0';
      RXFESync1        <= '0';
      RXFESync         <= '0';
      CTSEnSync1       <= '0';
      CTSEnSyncUCLK    <= '0';
    elsif (UARTCLK'event and UARTCLK = '1') then
      RXFWrDoneSync1   <= RXFWrDone;
      RXFWrDoneSync    <= RXFWrDoneSync1;

      RPtrInDnSync1    <= RdPtrIncDone;
      RdPtrIncDoneSync <= RPtrInDnSync1;

      RXFESync1        <= RXFE;
      RXFESync         <= RXFESync1;

      CTSEnSync1       <= CTSEn;
      CTSEnSyncUCLK    <= CTSEnSync1;
    end if;
  end process p_FIFOs;

--------------------------------------------------------------------------------
-- Synchronisers for the LCRUpdate signal,the ILPRUpdate 
-- signaland the FBRDUpdate signal.
--------------------------------------------------------------------------------
  p_Update : process (UARTCLK, nUARTRST)
  begin
    if (nUARTRST = '0') then
      LCRUpdateSync1  <= '0';
      LCRUpdateSync   <= '0';
      ILPRUpdateSync1 <= '0';
      ILPRUpdateSync  <= '0';
      FBRDUpdateSync1 <= '0';
      FBRDUpdateSync  <= '0';
    elsif (UARTCLK'event and UARTCLK = '1') then
      LCRUpdateSync1  <= LCRUpdate;
      LCRUpdateSync   <= LCRUpdateSync1;

      ILPRUpdateSync1 <= ILPRUpdate;
      ILPRUpdateSync  <= ILPRUpdateSync1;
      
      FBRDUpdateSync1 <= FBRDUpdate;
      FBRDUpdateSync  <= FBRDUpdateSync1;
    end if;
  end process p_Update;

--------------------------------------------------------------------------------
-- Synchroniser for the TXDataAvlbl signal.
--------------------------------------------------------------------------------
  p_TXDataAvlbl: process (UARTCLK, nUARTRST)
  begin
    if (nUARTRST = '0') then
      TXDataAvlblSync1 <= '0';
      TXDataAvlblSync  <= '0';
    elsif (UARTCLK'event and UARTCLK = '1') then
      TXDataAvlblSync1 <= TXDataAvlbl;
      TXDataAvlblSync  <= TXDataAvlblSync1;
    end if;
  end process p_TXDataAvlbl;

--------------------------------------------------------------------------------
-- Synchronisers for 'Enable' signals and other related signals.
--------------------------------------------------------------------------------
  p_CntlSig: process (UARTCLK, nUARTRST)
  begin
    if (nUARTRST = '0') then
      DCDIMSync1     <= '0'; 
      DCDIMSync      <= '0'; 

      DSRIMSync1     <= '0'; 
      DSRIMSync      <= '0'; 

      CTSIMSync1     <= '0'; 
      CTSIMSync      <= '0'; 

      RIIMSync1      <= '0'; 
      RIIMSync       <= '0'; 

      RTIMSync1      <= '0'; 
      RTIMSync       <= '0'; 

      FEIMSync1      <= '0'; 
      FEIMSync       <= '0'; 

      PEIMSync1      <= '0'; 
      PEIMSync       <= '0'; 

      BEIMSync1      <= '0'; 
      BEIMSync       <= '0'; 

      SIRLPSync1     <= '0'; 
      SIRLPSync      <= '0'; 

      SIRENSync1     <= '0'; 
      SIRENSync      <= '0'; 

      UARTENSync1    <= '0'; 
      UARTENSync     <= '0';

      TXESync1       <= '1'; 
      TXESync        <= '1';

      RXESync1       <= '1'; 
      RXESync        <= '1';

      UARTFEICSync1  <= '0';
      UARTFEICSync   <= '0';
      
      UARTPEICSync1  <= '0';
      UARTPEICSync   <= '0';
      
      UARTBEICSync1  <= '0';
      UARTBEICSync   <= '0';
      
      UARTRTICSync1  <= '0';
      UARTRTICSync   <= '0';
      
      UARTDCDICSync1 <= '0';
      UARTDCDICSync  <= '0';
      
      UARTDSRICSync1 <= '0';
      UARTDSRICSync  <= '0';
      
      UARTCTSICSync1 <= '0';
      UARTCTSICSync  <= '0';
      
      UARTRIICSync1  <= '0';
      UARTRIICSync   <= '0';

      BRKSync1       <= '0';      
      BRKSync        <= '0';      
      
    elsif (UARTCLK'event and UARTCLK = '1') then
      DCDIMSync1     <= DCDIM;
      DCDIMSync      <= DCDIMSync1;

      DSRIMSync1     <= DSRIM;
      DSRIMSync      <= DSRIMSync1;

      CTSIMSync1     <= CTSIM;
      CTSIMSync      <= CTSIMSync1;

      RIIMSync1      <= RIIM;
      RIIMSync       <= RIIMSync1;

      RTIMSync1      <= RTIM;
      RTIMSync       <= RTIMSync1;

      FEIMSync1      <= FEIM;
      FEIMSync       <= FEIMSync1;

      PEIMSync1      <= PEIM;
      PEIMSync       <= PEIMSync1;

      BEIMSync1      <= BEIM;
      BEIMSync       <= BEIMSync1;

      SIRLPSync1     <= SIRLP;  
      SIRLPSync      <= SIRLPSync1;  

      SIRENSync1     <= SIREN;  
      SIRENSync      <= SIRENSync1;  

      UARTENSync1    <= UARTEN;  
      UARTENSync     <= UARTENSync1;

      TXESync1       <= TXE;  
      TXESync        <= TXESync1;

      RXESync1       <= RXE;  
      RXESync        <= RXESync1;
      
      UARTFEICSync1  <= UARTFEIC;
      UARTFEICSync   <= UARTFEICSync1;
      
      UARTPEICSync1  <= UARTPEIC;
      UARTPEICSync   <= UARTPEICSync1;
      
      UARTBEICSync1  <= UARTBEIC;
      UARTBEICSync   <= UARTBEICSync1;
      
      UARTDCDICSync1 <= UARTDCDIC;
      UARTDCDICSync  <= UARTDCDICSync1;
      
      UARTDSRICSync1 <= UARTDSRIC;
      UARTDSRICSync  <= UARTDSRICSync1;
      
      UARTCTSICSync1 <= UARTCTSIC;
      UARTCTSICSync  <= UARTCTSICSync1;
      
      UARTRIICSync1  <= UARTRIIC;
      UARTRIICSync   <= UARTRIICSync1;

      UARTRTICSync1  <= UARTRTIC;
      UARTRTICSync   <= UARTRTICSync1;

      BRKSync1       <= BRK;      
      BRKSync        <= BRKSync1;      
      
    end if;
  end process p_CntlSig;
end synth;

--========================== End of UartSynctoUCLK ===========================--














