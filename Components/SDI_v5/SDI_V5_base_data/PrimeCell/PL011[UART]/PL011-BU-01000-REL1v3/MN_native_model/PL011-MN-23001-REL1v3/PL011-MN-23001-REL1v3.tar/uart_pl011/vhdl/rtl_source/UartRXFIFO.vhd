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
--  File Name              : UartRXFIFO.vhd.rca
--  File Revision          : 1.8
--  
--  Release Information    : PrimeCell(TM)-PL011-REL1v3
--  
--  ----------------------------------------------------------------------------
--  
--  
--  
-- -----------------------------------------------------------------------------
--  Purpose          : This block instantiates the UartRXFCntl (Receive FIFO
--                    control)  and the UartRXRegFile (Register File) blocks.
-- -----------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

entity UartRXFIFO is
  port (
        PCLK        : in  std_logic;      -- APB Clock
        PRESETn	    : in  std_logic;      -- AMBA Bus reset
        
        PWDATAIn    : in  std_logic_vector(11 downto 0);
                                          -- Write data bus
        RXFWrSync   : in  std_logic;	  -- RX FIFO Write Enable
        RXFRdPtrInc : in  std_logic;      -- RX FIFO Read Pointer Incr
        RXFIFOData  : in  std_logic_vector(10 downto 0);
                                          -- RX FIFO Write data
        UARTECRWrEn : in  std_logic;	  -- Overrun error Clear input
        UARTTDRWrEn : in  std_logic;	  -- Write enable for Rx fifo
        FEN	    : in  std_logic;	  -- FIFO Enable
        RTSEn       : in  std_logic;      -- RTS flow control enable
        TESTFIFO    : in  std_logic;	  -- Test signal
        nUARTRTScr  : in  std_logic;      -- from control register
        
        RXIFLSEL    : in  std_logic_vector(2 downto 0);
                                          -- fifo interrupt level select
        UARTRXIC    : in  std_logic;      -- For Rx Interrupt clear
        UARTOEIC    : in  std_logic;      -- For Overrun error Interrupt clear
        RXIM        : in  std_logic;      -- Tx Interrupt Mask
        OEIM        : in  std_logic;      -- Overrun error Interrupt Mask
        
        RXFRdData   : out std_logic_vector(11 downto 0);
                                          -- RX FIFO Read Data
        RXFWrDone   : out std_logic;      -- RX FIFO Write Done
        RXFE	    : out std_logic;	  -- Receive FIFO Empty
        RXFF	    : out std_logic;	  -- Receive FIFO Full
        OverrunDet  : out std_logic;	  -- Overrun Detected
        nUARTRTSint : out std_logic;      -- modem signal
        RXFGTE1Full : out std_logic;      -- To DMA block
        RXIntLevel  : out std_logic;      -- Programable Interrupt Level
        
        UARTRXIClr  : out std_logic;      -- Rx Interrupt clear
        UARTOEIClr  : out std_logic;      -- Rx Interrupt clear
        UARTRXRIS   : out std_logic;	  -- Receive Raw Interrupt
        UARTRXMIS   : out std_logic;	  -- Receive Masked Interrupt
        UARTOERIS   : out std_logic;	  -- Overrun error Raw Interrupt
        UARTOEMIS   : out std_logic 	  -- Overrun error Masked Interrupt
        );
end UartRXFIFO;

architecture synth of UartRXFIFO is
-- 
-- -----------------------------------------------------------------------------
--                                 UartRXFIFO
--                                 ==========
-- Overview
-- ========
-- 
-- The receive FIFO is a 11-bit wide 16-deep FIFO. It instantiates two 
-- submodules - UartRXFCntl (which performs the FIFO control function and the
-- UartRXRegFile (which is the register file). The receive FIFO is implemented
-- as a circular buffer with read and write pointers. The pointers operate on
-- PCLK to facilitate APB accesses and calculation of FIFO fill level.
-- 
  signal RegFileWrEn	: std_logic; 
  signal WrPtr	        : std_logic_vector(3 downto 0); 
  signal RdPtr          : std_logic_vector(3 downto 0);
  signal FIFOOverrunDet : std_logic;
  signal muxRXFIFOData  : std_logic_vector(11 downto 0);

  component UartRXFCntl 
    port (
          PCLK           : in  std_logic; 
          PRESETn        : in  std_logic; 
          
          RXFWrSync      : in  std_logic; 
          RXFRdPtrInc    : in  std_logic; 
          FEN            : in  std_logic; 
          TESTFIFO       : in  std_logic; 
          RTSEn          : in  std_logic; 
          nUARTRTScr     : in  std_logic; 
          
          UARTECRWrEn    : in  std_logic; 
          UARTTDRWrEn    : in  std_logic; 
          RXIFLSEL       : in  std_logic_vector(2 downto 0);
          RXIM           : in  std_logic; 
          OEIM           : in  std_logic; 
          UARTRXIC       : in  std_logic; 
          UARTOEIC       : in  std_logic; 

          WrPtr          : out std_logic_vector(3 downto 0);
          RdPtr          : out std_logic_vector(3 downto 0);
          RXFE           : out std_logic;
          RXFF           : out std_logic;
          RXFGTE1Full    : out std_logic;
          RXIntLevel     : out std_logic;
          RegFileWrEn    : out std_logic;
          RXFWrDone      : out std_logic;
          OverrunDet     : out std_logic;
          FIFOOverrunDet : out std_logic;
          nUARTRTSint    : out std_logic;
          
          UARTRXIClr     : out std_logic;
          UARTOEIClr     : out std_logic;
          UARTRXRIS      : out std_logic;
          UARTRXMIS      : out std_logic;
          UARTOERIS      : out std_logic;
          UARTOEMIS      : out std_logic 
          );
  end component;


  component UartRXRegFile 
    port (
          PCLK  	 : in  std_logic;
          PRESETn	 : in  std_logic;
          
          RegFileWrEn	 : in  std_logic;
          WrPtr	         : in  std_logic_vector(3 downto 0);
          RdPtr	         : in  std_logic_vector(3 downto 0);
          RXFIFOData	 : in  std_logic_vector(11 downto 0);
          
          RXFRdData	 : out std_logic_vector(11 downto 0)
          );
  end component;


begin
  
---------------------------------------------------------------------
-- In TESTFIFO mode use testdata written straight to the fifo instead
-- of waiting for it to be transmited and received.
---------------------------------------------------------------------


  p_RXTestdata : process (PWDATAIn,TESTFIFO, RXFIFOData,FIFOOverrunDet)
  begin                                            
    if (TESTFIFO = '1') then
      muxRXFIFOData <= PWDATAIn(11 downto 0);
    else 
      muxRXFIFOData <= FIFOOverrunDet & RXFIFOData;
    end if;
  end process p_RXTestdata;

  
-- The UartRXFCntl block controls accesses to the FIFO register file.
  uUartRXFCntl : UartRXFCntl
    port map (
              PCLK           => PCLK, 
              PRESETn        => PRESETn, 
              
              RXFWrSync      => RXFWrSync, 
              RXFRdPtrInc    => RXFRdPtrInc, 
              FEN            => FEN, 
              TESTFIFO       => TESTFIFO, 
              RTSEn          => RTSEn, 
              nUARTRTScr     => nUARTRTScr, 
              
              UARTECRWrEn    => UARTECRWrEn, 
              UARTTDRWrEn    => UARTTDRWrEn, 
              RXIFLSEL       => RXIFLSEL,
              RXIM           => RXIM, 
              OEIM           => OEIM, 
              UARTRXIC       => UARTRXIC, 
              UARTOEIC       => UARTOEIC, 

              WrPtr          => WrPtr,
              RdPtr          => RdPtr,
              RXFE           => RXFE,
              RXFF           => RXFF,
              RXFGTE1Full    => RXFGTE1Full,
              RXIntLevel     => RXIntLevel,
              RegFileWrEn    => RegFileWrEn,
              RXFWrDone      => RXFWrDone,
              OverrunDet     => OverrunDet,
              FIFOOverrunDet => FIFOOverrunDet,
              nUARTRTSint    => nUARTRTSint,
              
              UARTRXIClr     => UARTRXIClr,
              UARTOEIClr     => UARTOEIClr,
              UARTRXRIS      => UARTRXRIS,
              UARTRXMIS      => UARTRXMIS,
              UARTOERIS      => UARTOERIS,
              UARTOEMIS      => UARTOEMIS
              );
  

-- The UartRXRegFile is a data buffer implemented using D-types.
  uUartRXRegFile : UartRXRegFile
    port map (
              PCLK        => PCLK,
              PRESETn	  => PRESETn,
              
              RegFileWrEn => RegFileWrEn,
              WrPtr       => WrPtr,
              RdPtr       => RdPtr,
              RXFIFOData  => muxRXFIFOData,
              
              RXFRdData	  => RXFRdData
              );
end synth;



