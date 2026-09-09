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
--  File Name              : UartModem.vhd.rca
--  File Revision          : 1.8
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

entity UartModem is
  port (
        UARTCLK         : in  std_logic;      -- Main UART Clock
        nUARTRST        : in  std_logic;      -- Muxed reset (from nUARTRST)
        
        SIRENSync       : in  std_logic;      -- Inhibit MSINT if SIR enabled
        
        nDCDSyncUARTCLK : in  std_logic;      -- Sync'ed DCD
        nDSRSyncUARTCLK : in  std_logic;      -- Sync'ed DSR
        nCTSSyncUARTCLK : in  std_logic;      -- Sync'ed CTS
        nRISyncUARTCLK  : in  std_logic;      -- Sync'ed RI
        
        UARTDCDICSync   : in  std_logic;      -- For UARTDCDINTR Clear
        UARTDSRICSync   : in  std_logic;      -- For UARTDSRINTR Clear
        UARTCTSICSync   : in  std_logic;      -- For UARTCTSINTR Clear
        UARTRIICSync    : in  std_logic;      -- For UARTRIINTR Clear
        
        DCDIMSync       : in  std_logic;      -- DCD Interrupt enable
        DSRIMSync       : in  std_logic;      -- DSR Interrupt enable
        CTSIMSync       : in  std_logic;      -- CTS Interrupt enable
        RIIMSync        : in  std_logic;      -- RI Interrupt enable
        
        UARTMSINT       : out std_logic;      -- UART Modem Status interrupt
        UARTRISmod      : out std_logic_vector(3 downto 0);
                                              -- Raw modem interrupt status
        UARTMISmod      : out std_logic_vector(3 downto 0)
                                              -- Masked modem interrupt status
        );
end UartModem;
--------------------------------------------------------------------------------
-- Purpose     : This block generates the Modem status interrupt
--------------------------------------------------------------------------------
--
--------------------------------------------------------------------------------
--
--                     UartModem
--                     =========
--
--------------------------------------------------------------------------------
-- Overview
-- ========
--
-- This block asserts the Modem Status Interrupt (UARTMSINT) when any 
-- change in the modem input lines nDCDSyncUARTCLK, nDSRSyncUARTCLK,
-- nCTSSyncUARTCLK and nRISyncUARTCLK is detected.
-- The interrupt is cleared when a '1' is written to bit 1 of the
-- UARTICR register.
-- The UARTMSINTRClr signal is asserted for one UARTCLK period
-- whenever a '1' is written to bit 1 of the UARTICR register.
-- Change in the modem lines is detected by xoring the signal with
-- its delayed version. Once the interrupt is asserted, any further
-- changes in the modem lines have no effect on the interrupt status.
-- If an edge-detect and UARTMSINTRClr occur at the same time, the 
-- interrupt is de-asserted for one UARTCLK clock period and then
-- asserted again. This helps in systems with edge-triggered 
-- interrupt controllers.
--
--------------------------------------------------------------------------------
--
--=============================== ARCHITECTURE ===============================--
--
--------------------------------------------------------------------------------
-- Architecture Packages
--------------------------------------------------------------------------------

architecture synth of UartModem is

--------------------------------------------------------------------------------
-- Internal Constants
--------------------------------------------------------------------------------
  
--------------------------------------------------------------------------------
-- Internal Signals
--------------------------------------------------------------------------------
  signal nDCDd1           : std_logic; 
  -- Delayed version of nDCDSyncUARTCLK

  signal nDSRd1           : std_logic; 
  -- Delayed version of nDSRSyncUARTCLK

  signal nCTSd1           : std_logic; 
  -- Delayed version of nCTSSyncUARTCLK

  signal nRId1            : std_logic; 
  -- Delayed version of nRISyncUARTCLK

  signal NextUARTDCDRIS   : std_logic;     
  -- D-input of raw iUARTDCDINTR

  signal NextUARTDSRRIS   : std_logic;     
  -- D-input of raw iUARTDSRINTR
  
  signal NextUARTCTSRIS   : std_logic;     
  -- D-input of raw iUARTCTSINTR

  signal NextUARTRIRIS    : std_logic;     
  -- D-input of raw iUARTRIINTR

  signal iUARTRIRIS       : std_logic;     
  -- Internal copy of RI raw status

  signal iUARTDCDRIS      : std_logic;     
  -- Internal copy of DCD raw status

  signal iUARTDSRRIS      : std_logic;     
  -- Internal copy of DSR raw status

  signal iUARTCTSRIS      : std_logic;     
  -- Internal copy of CTS raw status

  signal iUARTRIMIS       : std_logic;     
  -- Internal copy of RI  masked status

  signal iUARTDCDMIS      : std_logic;     
  -- Internal copy of DCD masked status

  signal iUARTDSRMIS      : std_logic;     
  -- Internal copy of DSR masked status

  signal iUARTCTSMIS      : std_logic;     
  -- Internal copy of CTS masked status
  
  signal DCDEdge          : std_logic;     
  -- Indicates that an edge has been detected in the DCD Modem signal
  
  signal DSREdge          : std_logic;     
  -- Indicates that an edge has been detected in the DSR Modem signal
  
  signal CTSEdge          : std_logic;     
  -- Indicates that an edge has been detected in the CTS Modem signal
  
  signal RIEdge           : std_logic;     
  -- Indicates that an edge has been detected in the RI Modem signal
  
  signal DSREdged1        : std_logic;     
  -- Delayed version of DSREdge

  signal DCDEdged1        : std_logic;     
  -- Delayed version of DCDEdge

  signal CTSEdged1        : std_logic;     
  -- Delayed version of CTSEdge
  
  signal RIEdged1         : std_logic;     
  -- Delayed version of RIEdge
  
  signal DelUARTDCDICSync : std_logic;
  -- Delayed version of UARTDCDICSync. Used to detect edge on UARTDCDICSync

  signal DelUARTDSRICSync : std_logic;
  -- Delayed version of UARTDSRICSync. Used to detect edge on UARTDSRICSync

  signal DelUARTCTSICSync : std_logic;
  -- Delayed version of UARTCTSICSync. Used to detect edge on UARTCTSICSync

  signal DelUARTRIICSync  : std_logic;
  -- Delayed version of UARTRIICSync. Used to detect edge on UARTRIICSync

  signal UARTDCDIClr      : std_logic; 
  -- Clear signal for UARTDCDINTR interrupt

  signal UARTDSRIClr      : std_logic; 
  -- Clear signal for UARTDSRINTR interrupt

  signal UARTCTSIClr      : std_logic; 
  -- Clear signal for UARTCTSINTR interrupt

  signal UARTRIIClr       : std_logic; 
  -- Clear signal for UARTRIINTR interrupt

  

--------------------------------------------------------------------------------
--
-- Main VHDL code
-- ==============
--
--------------------------------------------------------------------------------

begin


  -------------------------------------------------------------------
  -- Detect an edge in any of the modem control lines
  -------------------------------------------------------------------
  DCDEdge <= nDCDd1 xor nDCDSyncUARTCLK;
  DSREdge <= nDSRd1 xor nDSRSyncUARTCLK; 
  CTSEdge <= nCTSd1 xor nCTSSyncUARTCLK;
  RIEdge  <= nRId1  xor nRISyncUARTCLK;
  
  -------------------------------------------------------------------
  -- The UARTDCDIClr, UARTDSRIClr, UARTCTSIClr and UARTRIIClr signals
  -- are one UARTCLK-wide pulses used to clear the UARTDCDINTR,
  -- UARTDSRINTR, UARTCTSINTR and the UARTRIINTR interrupts.
  -------------------------------------------------------------------

  UARTDCDIClr <= UARTDCDICSync and not(DelUARTDCDICSync);
  UARTDSRIClr <= UARTDSRICSync and not(DelUARTDSRICSync);
  UARTCTSIClr <= UARTCTSICSync and not(DelUARTCTSICSync);
  UARTRIIClr  <= UARTRIICSync  and not(DelUARTRIICSync);

  -------------------------------------------------------------------
  -- Clear the relevant interrupt on a write to that bit in the
  -- UARTICR register.  If there is another edge detected at the same
  --  clock, then latch this information in the relevant Edged1 flip-flop
  --  and assert the interrupt after one UARTCLK clock so as to support
  --  edge-triggered interrupt controllers.

  -------------------------------------------------------------------
  p_UARTDCDINTR : process (UARTDCDIClr, DCDEdge, DCDEdged1, SIRENSync,
                           iUARTDCDRIS)
  begin
    NextUARTDCDRIS     <= iUARTDCDRIS;
    if (((DCDEdge = '1') or (DCDEdged1 = '1')) and (SIRENSync = '0')) then
      NextUARTDCDRIS <= '1';
    elsif ((UARTDCDIClr = '1') or (SIRENSync = '1')) then
      NextUARTDCDRIS <= '0';
    end if;
  end process p_UARTDCDINTR;
  
  iUARTDCDMIS <= (iUARTDCDRIS and DCDIMSync);
  
  
  
  p_UARTDSRINTR : process (UARTDSRIClr, DSREdge,DSREdged1, SIRENSync,
                           iUARTDSRRIS)
  begin
    NextUARTDSRRIS     <= iUARTDSRRIS;
    if (((DSREdge = '1') or (DSREdged1 = '1')) and (SIRENSync = '0')) then
      NextUARTDSRRIS <= '1';
    elsif ((UARTDSRIClr = '1') or (SIRENSync = '1')) then
      NextUARTDSRRIS <= '0';
    end if;
  end process p_UARTDSRINTR;
  
  iUARTDSRMIS <= iUARTDSRRIS and DSRIMSync;

  
  
  p_UARTCTSINTR : process (UARTCTSIClr, CTSEdge,CTSEdged1, SIRENSync,
                           iUARTCTSRIS)
  begin
    NextUARTCTSRIS     <= iUARTCTSRIS;
    if (((CTSEdge = '1') or (CTSEdged1 = '1')) and (SIRENSync = '0')) then
      NextUARTCTSRIS <= '1';
    elsif ((UARTCTSIClr = '1') or (SIRENSync = '1')) then
      NextUARTCTSRIS <= '0';
    end if;
  end process p_UARTCTSINTR;
  
  iUARTCTSMIS <= iUARTCTSRIS and CTSIMSync;

  
  
  p_UARTRIINTR : process (UARTRIIClr, RIEdge,RIEdged1, SIRENSync,
                          iUARTRIRIS)
  begin
    NextUARTRIRIS     <= iUARTRIRIS;
    if (((RIEdge = '1') or (RIEdged1 = '1')) and (SIRENSync = '0')) then
      NextUARTRIRIS <= '1';
    elsif ((UARTRIIClr = '1') or (SIRENSync = '1')) then
      NextUARTRIRIS <= '0';
    end if;
  end process p_UARTRIINTR;
  
  iUARTRIMIS <= iUARTRIRIS and RIIMSync;


  UARTRISmod(2) <= iUARTDCDRIS;
  UARTRISmod(3) <= iUARTDSRRIS;
  UARTRISmod(1) <= iUARTCTSRIS;
  UARTRISmod(0) <= iUARTRIRIS;

  UARTMISmod(2) <= iUARTDCDMIS;
  UARTMISmod(3) <= iUARTDSRMIS;
  UARTMISmod(1) <= iUARTCTSMIS;
  UARTMISmod(0) <= iUARTRIMIS;


---------------------------------------------------------------------
-- The combined Modem interrupt UARTMSINT is asserted when any if
-- the individual modem interrupts are asserted.
---------------------------------------------------------------------
  UARTMSINT <= iUARTDCDMIS or iUARTDSRMIS or iUARTCTSMIS or iUARTRIMIS;
  

  p_MSIntReg : process (UARTCLK, nUARTRST)
  begin  
    if (nUARTRST = '0') then
      nDCDd1           <= '0';
      nDSRd1           <= '0';
      nCTSd1           <= '0';
      nRId1            <= '0';
      iUARTRIRIS       <= '0';
      iUARTDCDRIS      <= '0';
      iUARTDSRRIS      <= '0';
      iUARTCTSRIS      <= '0';
      DSREdged1        <= '0';
      DCDEdged1        <= '0';
      CTSEdged1        <= '0';
      RIEdged1         <= '0';
      DelUARTRIICSync  <= '0';
      DelUARTDCDICSync <= '0';
      DelUARTDSRICSync <= '0';      
      DelUARTCTSICSync <= '0';
    elsif (UARTCLK'event and UARTCLK = '1') then
      nDCDd1           <= nDCDSyncUARTCLK;
      nDSRd1           <= nDSRSyncUARTCLK;
      nCTSd1           <= nCTSSyncUARTCLK;
      nRId1            <= nRISyncUARTCLK;
      iUARTRIRIS       <= NextUARTRIRIS;
      iUARTDCDRIS      <= NextUARTDCDRIS;
      iUARTDSRRIS      <= NextUARTDSRRIS;
      iUARTCTSRIS      <= NextUARTCTSRIS;
      DSREdged1        <= DSREdge;
      DCDEdged1        <= DCDEdge;
      CTSEdged1        <= CTSEdge;
      RIEdged1         <= RIEdge;
      DelUARTRIICSync  <= UARTRIICSync;
      DelUARTDCDICSync <= UARTDCDICSync;
      DelUARTDSRICSync <= UARTDSRICSync;
      DelUARTCTSICSync <= UARTCTSICSync;
    end if;
  end process p_MSIntReg;    

end synth; 

--========================== End of UartModem ================================--















