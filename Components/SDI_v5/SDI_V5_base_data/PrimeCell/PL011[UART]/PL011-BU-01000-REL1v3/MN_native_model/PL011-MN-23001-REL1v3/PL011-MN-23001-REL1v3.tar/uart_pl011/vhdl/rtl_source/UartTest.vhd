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
--  File Name              : UartTest.vhd.rca
--  File Revision          : 1.12
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

entity UartTest is
  port (
        PCLK            : in  std_logic;      -- APB Clock
        PRESETn         : in  std_logic;      -- AMBA Bus reset
        
        LBE             : in  std_logic;      -- Loop Back Enable
       
        UARTTCRWrEn     : in  std_logic;      -- Write enable for TCR
        UARTITIPWrEn    : in  std_logic;      -- Write enable for UARTITIP
        UARTITOPWrEn    : in  std_logic;      -- Write enable for UARTITOP
        UARTTDRrd       : in  std_logic;      -- Read enable for TDR
        
        PWDATAIn        : in  std_logic_vector(15 downto 0);
	                                      -- Wr DataBus
        UARTRXD         : in  std_logic;      -- Receive serial input
        SIRIN           : in  std_logic;      -- SIR serial input
        UARTTXDint      : in  std_logic;      -- TXD output read back
        nSIROUTint      : in  std_logic;      -- SIR output read back
        
        nUARTCTS        : in  std_logic;      -- Modem signal
        nUARTDSR        : in  std_logic;      -- Modem signal
        nUARTDCD        : in  std_logic;      -- Modem signal
        nUARTRI         : in  std_logic;      -- Modem signal
        nUARTRTSint     : in  std_logic;      -- Modem signal
        nUARTDTRint     : in  std_logic;      -- Modem signal
        nUARTOut2int    : in  std_logic;      -- Modem signal
        nUARTOut1int    : in  std_logic;      -- Modem signal
        
        UARTTXDMACLR    : in  std_logic;      -- Transmit DMACLR
        UARTRXDMACLR    : in  std_logic;      -- Receive DMACLR
        TXDMASREQ       : in  std_logic;      -- Transmit DMA single request
        TXDMABREQ       : in  std_logic;      -- Transmit DMA burst request
        RXDMASREQ       : in  std_logic;      -- Receive DMA single request
        RXDMABREQ       : in  std_logic;      -- Receive DMA burst request
        
        MSINTR          : in  std_logic;      --  Modem interrupt
        UARTRXMIS       : in  std_logic;      -- RX interrupt 
        UARTTXMIS       : in  std_logic;      -- TX interrupt 
        RTINTR          : in  std_logic;      -- RT interrupt
        EINTR           : in  std_logic;      -- Error interrupt
        UARTINT         : in  std_logic;      -- Uart interrupt
        
        UARTRXDint      : out std_logic;      -- To IrDA module
        SIRINint        : out std_logic;      -- Ti IrDA block
        UARTTCR         : out std_logic_vector(2 downto 0);
	                                      -- TCR
        UARTITOP        : out std_logic_vector(5 downto 0);
	                                      -- ITOP
        TestTXFInc      : out std_logic;      --  Read pointer increment signal for Tx fifo
        
        nUARTDSRint     : out std_logic;      -- To synchronisers
        nUARTCTSint     : out std_logic;      -- To synchronisers
        nUARTDCDint     : out std_logic;      -- To synchronisers
        nUARTRIint      : out std_logic;      -- To synchronisers
        
        IntUARTTXDMACLR : out std_logic;      -- Transmit DMACLR
        IntUARTRXDMACLR : out std_logic;      -- Receive DMACLR
        IntTXDMASREQ    : out std_logic;      -- Transmit DMA single request
        IntTXDMABREQ    : out std_logic;      -- Transmit DMA burst request
        IntRXDMASREQ    : out std_logic;      -- Receive DMA single request
        IntRXDMABREQ    : out std_logic;      -- Receive DMA burst request
        
        IntMSINTR       : out std_logic;      -- Modem status interrupt
        IntUARTRXMIS    : out std_logic;      -- RX Interrupt for int test
        IntUARTTXMIS    : out std_logic;      -- TX Interrupt for int test
        IntUARTRTRIS    : out std_logic;      -- RT Interrupt for int test
        IntUARTEINTR    : out std_logic;      -- Error Interrupt for int test
        IntUARTINTR     : out std_logic;      -- Uart Interrupt for int test
        
        nUARTOut2       : out std_logic;      -- Modem signal primary O/P
        nUARTOut1       : out std_logic;      -- Modem signal primary O/P
        nUARTRTS        : out std_logic;      -- Modem signal primary O/P
        nUARTDTR        : out std_logic;      -- Modem signal primary O/P
        nSIROUT         : out std_logic;      -- SIR primary O/P
        UARTTXD         : out std_logic       -- UART primary O/P
        );
end UartTest;

--------------------------------------------------------------------------------
-- Purpose     : This block contains the test logic for the UART.
--------------------------------------------------------------------------------
--
--------------------------------------------------------------------------------
--
--                   UartTest
--                   ========
--
--------------------------------------------------------------------------------
--
-- Overview
-- ========
--  This block contains the Test registers in the UART. It includes
--  the  logic for the loopback function, and the logic for the
--  integration tests.
--------------------------------------------------------------------------------
--
--=============================== ARCHITECTURE ===============================--
--
--------------------------------------------------------------------------------
-- Architecture Packages
--------------------------------------------------------------------------------

architecture synth of UartTest is

--------------------------------------------------------------------------------
-- Component Declaration
--------------------------------------------------------------------------------
  
--------------------------------------------------------------------------------
-- Internal Constants
--------------------------------------------------------------------------------
  
--------------------------------------------------------------------------------
-- Internal Signals
--------------------------------------------------------------------------------
  signal iUARTTCR       : std_logic_vector(2 downto 0); 
  -- UART Test Control Register

  signal iUARTITIP      : std_logic_vector(7 downto 6); 
  -- UART Integration test input Register

  signal iUARTITOP      : std_logic_vector(15 downto 0); 
  -- UART Integration test output Register

  signal NextUARTTCR    : std_logic_vector(2 downto 0); 
  -- D-input of iUARTTCR

  signal NextUARTITIP   : std_logic_vector(7 downto 6); 
  -- D-input of iUARTITIP

  signal NextUARTITOP   : std_logic_vector(15 downto 0); 
  -- D-input of iUARTITOP

  signal delUARTTDRrd   : std_logic;
  -- delayed version of UARTTDRrd

  signal iTESTFIFO      : std_logic;
  -- Test Signal to enable writing into Rx fifo and read from Tx fifo
  -- Test Fifo signal allows data to be written to the Rx fifo and
  -- read  from the Tx fifo.  When set to 0 the Tx fifo can only be
  -- written to and the Rx fifo read from.
  
--------------------------------------------------------------------------------
-- Test control signals
--------------------------------------------------------------------------------
  signal ITEN           : std_logic;
  -- Integration test enable. When set to 1, the UARTITIP and
  -- UARTITOP registers are used to read/write values to the inputs
  -- and outputs.
  
--------------------------------------------------------------------------------
--
-- Main VHDL code
-- ==============
--
--------------------------------------------------------------------------------

begin

--------------------------------------------------------------------------------
-- Test Registers
--------------------------------------------------------------------------------
  p_TestRegComb : process (UARTTCRWrEn,UARTITIPWrEn,UARTITOPWrEn,
                           iUARTTCR,iUARTITIP,iUARTITOP,PWDATAIn)
  begin
    NextUARTTCR    <= iUARTTCR;
    NextUARTITIP   <= iUARTITIP;
    NextUARTITOP   <= iUARTITOP;

    if(UARTTCRWrEn = '1') then
      NextUARTTCR  <= PWDATAIn(2 downto 0);
    end if;

    if(UARTITIPWrEn = '1') then
      NextUARTITIP <= PWDATAIn(7 downto 6);
    end if;

    if(UARTITOPWrEn = '1') then
      NextUARTITOP <= PWDATAIn(15 downto 0);
    end if;
  end process p_TestRegComb;

  p_TestRegSeq : process(PCLK, PRESETn) 
  begin
    if(PRESETn = '0') then
      iUARTTCR   <= (others => '0');
      iUARTITIP  <= (others => '0');
      iUARTITOP  <= (others => '0');
    elsif(PCLK'event and PCLK = '1') then
      iUARTTCR   <= NextUARTTCR;
      iUARTITIP  <= NextUARTITIP;
      iUARTITOP  <= NextUARTITOP;
    end if;
  end process p_TestRegSeq;
  

---------------------------------------------------------------------
-- Generate Read pointer Increment signals for TestFifo
-- mode when  reading from the Tx fifo.
---------------------------------------------------------------------

  p_RXTestFptrInc : process (PRESETn, PCLK)
  begin
    if(PRESETn = '0') then
      delUARTTDRrd   <= '0';
    elsif(PCLK'event and PCLK = '1') then
      if(iTESTFIFO = '1')  then
        delUARTTDRrd <= UARTTDRrd;
      end if;
    end if;
  end process p_RXTestFptrInc;    


  TestTXFInc <= (UARTTDRrd) and delUARTTDRrd;


-- Local copy to external port
  
  UARTTCR    <= iUARTTCR; 
  UARTITOP   <= iUARTITOP(5 downto 0); 
  ITEN       <= iUARTTCR(0);
  iTESTFIFO  <= iUARTTCR(1);
  

--------------------------------------------------------------------------------
-- If the LBE input is asserted, UARTTXDint is connected to UARTRXDInt and
-- nSIROUTint is connected through an inverter to SIRINInt to implement
-- loopback.  The modem signals are also connected nUARTRTSint to
-- nUARTCTSint, nUARTDTRint to nUARTDSRint, nUARTOut2int to  nUARTRIint
-- and nUARTOut1int to nUARTDCDint to implement loopback.
--------------------------------------------------------------------------------

  UARTRXDint    <= UARTTXDint      when (LBE = '1')
                   else
                   UARTRXD;
  SIRINint      <= not(nSIROUTint) when (LBE = '1')
                   else
                   SIRIN;

  nUARTCTSint   <= nUARTRTSint     when (LBE = '1')
                   else
                   nUARTCTS;

  nUARTDSRint   <= nUARTDTRint     when (LBE = '1')
                   else
                   nUARTDSR;

  nUARTRIint    <= nUARTOut2int    when (LBE = '1')
                   else
                   nUARTRI;

  nUARTDCDint   <= nUARTOut1int    when (LBE = '1')
                   else
                   nUARTDCD;

-- --------------------------------------------------------------------
-- Intra chip inputs.
-- If ITEN (Integration test enable bit) is high, the UARTITIP
-- register value is used; else the functional mode input is driven on
-- the DMACLR signals.
-- --------------------------------------------------------------------
  IntUARTTXDMACLR  <= iUARTITIP(7) when (ITEN = '1')
                      else
                      UARTTXDMACLR;

  IntUARTRXDMACLR  <= iUARTITIP(6) when (ITEN = '1')
                      else
                      UARTRXDMACLR;


-- --------------------------------------------------------------------
-- Intra chip outputs.
-- If ITEN (Integration test enable bit) is high, the UARTITOP
-- register value is used; else the functional mode value is driven
-- on to the port.
-- --------------------------------------------------------------------
  IntTXDMASREQ   <= iUARTITOP(15) when (ITEN = '1')
                    else
                    TXDMASREQ;

  IntTXDMABREQ   <= iUARTITOP(14) when (ITEN = '1')
                    else
                    TXDMABREQ;

  IntRXDMASREQ   <= iUARTITOP(13) when (ITEN = '1')
                    else
                    RXDMASREQ;

  IntRXDMABREQ   <= iUARTITOP(12) when (ITEN = '1')
                    else
                    RXDMABREQ;

  IntMSINTR      <= iUARTITOP(11) when (ITEN = '1')
                    else
                    MSINTR;

  IntUARTRXMIS   <= iUARTITOP(10) when (ITEN = '1')
                    else
                    UARTRXMIS;

  IntUARTTXMIS   <= iUARTITOP(9) when (ITEN = '1')
                    else
                    UARTTXMIS;

  IntUARTRTRIS   <= iUARTITOP(8) when (ITEN = '1')
                    else
                    RTINTR;
  
  IntUARTEINTR   <= iUARTITOP(7) when (ITEN = '1')
                    else
                    EINTR;
  
  IntUARTINTR    <= iUARTITOP(6) when (ITEN = '1')
                    else
                    UARTINT;


-- --------------------------------------------------------------------
-- Primary Output Mux
-- If ITEN (Integration test enable bit) is high, the UARTITOP
-- register value is used; else the functional mode value is driven
-- on to the pin.
-- --------------------------------------------------------------------
  nUARTOut2      <= iUARTITOP(5) when (ITEN = '1')
                    else
                    nUARTOut2int;
  
  nUARTOut1      <= iUARTITOP(4) when (ITEN = '1')
                    else
                    nUARTOut1int;
  
  nUARTRTS       <= iUARTITOP(3) when (ITEN = '1')
                    else
                    nUARTRTSint;
  
  nUARTDTR       <= iUARTITOP(2) when (ITEN = '1')
                    else
                    nUARTDTRint;
  
  nSIROUT        <= iUARTITOP(1) when (ITEN = '1')
                    else
                    nSIROUTint;
  
  UARTTXD        <= iUARTITOP(0) when (ITEN = '1')
                    else
                    UARTTXDint;
  
end synth;          

--========================== End of UartTest =================================--






















