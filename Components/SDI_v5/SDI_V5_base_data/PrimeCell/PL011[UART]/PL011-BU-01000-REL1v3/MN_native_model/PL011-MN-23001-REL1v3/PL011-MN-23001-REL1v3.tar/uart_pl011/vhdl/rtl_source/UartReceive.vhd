--  ----------------------------------------------------------------------------
--  This confidential and proprietary software may be used only as
--  authorised by a licensing agreement from ARM Limited
--    (C) COPYRIGHT 1999-2001 ARM Limited
--        ALL RIGHTS RESERVED
--  The entire notice above must be reproduced on all authorised
--  copies and copies may only be made to the extent permitted
--  by a licensing agreement from ARM Limited.
--  ----------------------------------------------------------------------------
--  
--  Version and Release Control Information:
--  
--  File Name              : UartReceive.vhd.rca
--  File Revision          : 1.14
--  
--  Release Information    : PrimeCell(TM)-PL011-REL1v3
--  
--  ----------------------------------------------------------------------------
--  
--  
--  
-- -----------------------------------------------------------------------------
--  Purpose          : This block instantiates the UartRXCntl state machine,
--                     the UartRXParity block and the UartDataStp state m/c.
-- -----------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

entity UartReceive is
  port (
        UARTCLK	        : in  std_logic;      -- Main UART Clock
        nUARTRST        : in  std_logic;      -- Muxed reset (from nUARTRST)
        
        UARTENSync      : in  std_logic;      -- UART Enable
        SIRENSync       : in  std_logic;      -- SIR Enable
        RXESync	        : in  std_logic;      -- RX Enable
        Baud16	        : in  std_logic;      -- Bit Period Reference   
        WLEN	        : in  std_logic_vector(1 downto 0);
	                                      -- Data bits per word
        STP2	        : in  std_logic;      -- 2 stop bits
        EPS             : in  std_logic;      -- Even Parity Select
        PEN             : in  std_logic;      -- Parity enable
        SPS             : in  std_logic;      -- Stick Parity Select
        RXFWrDoneSync   : in  std_logic;      -- RX FIFO Write Done
        Zerobaud        : in  std_logic;      -- Baud Divisor set to 0
        RXFESync        : in  std_logic;      -- Receive FIFO Empty
        RXD	        : in  std_logic;      -- Receive serial input
        
        RTIMSync        : in  std_logic;      -- RX Timeout interrupt Mask 
        FEIMSync        : in  std_logic;      -- Framing Error interrupt Mask 
        PEIMSync        : in  std_logic;      -- Parity Error Interrupt Mask 
        BEIMSync        : in  std_logic;      -- Break Error Interrupt Mask 
        UARTRTICSync    : in  std_logic;      -- For RX Timeout interrupt Clear
        UARTFEICSync    : in  std_logic;      -- For Framing Error interrupt Clear
        UARTPEICSync    : in  std_logic;      -- For Parity Error interrupt Clear
        UARTBEICSync    : in  std_logic;      -- For Break Error interrupt Clear
        
        RXFWr	        : out std_logic;      -- Receive FIFO Write (level)
        RXFIFOData      : out std_logic_vector(10 downto 0);
	                                      -- Received Data
        DataStp	        : out std_logic;      -- Receive line Idle
        RXBUSY	        : out std_logic;      -- Receiver Busy
        RXEnable        : out std_logic;      -- Rx Enable
        UartRXCntlState : out std_logic_vector(2 downto 0);
                                              -- Rx state
        UARTRISerr      : out std_logic_vector(2 downto 0);
                                              -- Raw interrupt status, error signals
        UARTMISerr      : out std_logic_vector(2 downto 0);
                                              -- Masked Int status, error signals
        UARTEINTRfbp    : out std_logic;      -- Combined int for break,frame,parity
        CharRxComp      : out std_logic       -- Rx character complete

        );
end UartReceive;

architecture structural of UartReceive is
-- 
-- -----------------------------------------------------------------------------
-- Purpose : This block is the receive section of the UART
-- -----------------------------------------------------------------------------
-- 
--                                  UartReceive
--                                  ===========
-- Overview
-- ========
-- 
-- The receive section instantiates three sub-modules - UartRXParShft,UartRXCntl
-- and UartDataStp. The UartRXCntl block is the main control state machine. The 
-- UartRXParshft block contains the receive shift register and performs parity 
-- error checking and frame error checking on the received data bit stream.
-- The UartDataStp block detects the condition when there is some data in the 
-- receive FIFO but there has been no activity on the receive line for a 32-bit 
-- period.
--  When the RXD input line goes low, the receive state machine  starts 
-- synchronising to the middle of the start bit. Thereafter, the RXD line is 
-- sampled at the middle of every bit period. The ShiftEn signal from the 
-- Control state machine to the UartRXParShft block shifts data into a shift 
-- register in the UartRXParShft block. The SampleStopBit, SampleParity and 
-- ClearShiftReg signals indicate when the stop bit is to be sampled, when the 
-- Parity bit is to be sampled and when the Shift register is to be cleared to 
-- the UartRXParShft block.
--  The contents of the shift register in the UartRXParShft block is made 
-- available as the FIFOData signal.
--  The control state machine also puts out a ReloadWD signal whenever a start 
-- bit is detected or whenever the last stop bit is detected for the UartDataStp
-- state machine to reload its internal watchdog counter. This counter is a 9 
-- bit counter which counts down on every Baud16. The Zerobaud input signal is 
-- asserted if the illegal divisor value of 0 is written to the Bit rate divisor
-- -----------------------------------------------------------------------------
--  
  signal SampleParity	: std_logic; 
  signal ShiftEn	: std_logic; 
  signal ReloadWD	: std_logic; 
  signal ClearShiftReg	: std_logic; 
  signal DtPrZero	: std_logic; 
  signal RXDsampled	: std_logic; 
  signal iUARTBERIS	: std_logic; 
  signal iUARTPERIS	: std_logic; 
  signal iUARTFERIS	: std_logic; 
  signal iUARTBEMIS	: std_logic; 
  signal iUARTPEMIS	: std_logic; 
  signal iUARTFEMIS	: std_logic; 

  component UartRXCntl 
    port (
          UARTCLK         : in  std_logic;
          nUARTRST        : in  std_logic;
        
          Baud16          : in  std_logic;
          UARTENSync      : in  std_logic;
          SIRENSync       : in  std_logic;
          RXESync         : in  std_logic;
          RXD             : in  std_logic;
        
          WLEN            : in  std_logic_vector(1 downto 0);
                                          
          STP2            : in  std_logic;
          PEN             : in  std_logic;
          Zerobaud        : in  std_logic;
          RXFWrDoneSync   : in  std_logic;   
          DtPrZero        : in  std_logic;   
        
          UARTFEICSync    : in  std_logic; 
          UARTBEICSync    : in  std_logic; 
          FEIMSync        : in  std_logic; 
          BEIMSync        : in  std_logic; 
        
          ShiftEn         : out std_logic; 
          SampleParity    : out std_logic; 
          RXEnable        : out std_logic; 
          UartRXCntlState : out std_logic_vector(2 downto 0);
                      
          RXDsampled      : out std_logic; 
          ClearShiftReg   : out std_logic;
          RXFWr           : out std_logic; 
          ReloadWD        : out std_logic; 
          FramingError    : out std_logic; 
          Break           : out std_logic; 
          RXBUSY          : out std_logic;
          CharRxComp      : out std_logic;
        
          UARTFERIS       : out std_logic; 
          UARTBERIS       : out std_logic; 
          UARTFEMIS       : out std_logic; 
          UARTBEMIS       : out std_logic  
          );
  end component;


  component UartRXParShft 
    port (
          UARTCLK       : in  std_logic;
          nUARTRST      : in  std_logic;
        
          RXDsampled    : in  std_logic;
          ShiftEn       : in  std_logic;
          SampleParity  : in  std_logic;
          ClearShiftReg : in  std_logic; 
          SPS           : in  std_logic; 
          EPS           : in  std_logic; 
          PEN           : in  std_logic; 
          WLEN          : in  std_logic_vector(1 downto 0);
                                         
          PEIMSync      : in  std_logic; 
          UARTPEICSync  : in  std_logic; 
        
          RecdDATA      : out std_logic_vector(7 downto 0);
          DtPrZero      : out std_logic;
        
          ParityError   : out std_logic;
          UARTPERIS     : out std_logic;
          UARTPEMIS     : out std_logic 
          );
  end component;


  component UartDataStp 
    port (
          UARTCLK      : in  std_logic; 
          nUARTRST     : in  std_logic; 
        
          Baud16       : in  std_logic; 
          ReloadWD     : in  std_logic; 
        
          RXFESync     : in  std_logic; 
          RTIMSync     : in  std_logic; 
          UARTRTICSync : in  std_logic; 
        
          DataStp      : out std_logic
          );
  end component;


begin


---------------------------------------------------------------------
-- Combine the 3 error related signals generated in this block
---------------------------------------------------------------------
  UARTRISerr   <=  iUARTBERIS & iUARTPERIS & iUARTFERIS;
  UARTMISerr   <=  iUARTBEMIS & iUARTPEMIS & iUARTFEMIS;

-------------------------------------------------------------------
-- Combine the 3 error interrupts to form the combined error
-- interrupt for frame, break and parity. The overrun error interrupt
-- will be added to form the UARTEINTR signal.
-------------------------------------------------------------------
  UARTEINTRfbp <= iUARTBEMIS or iUARTPEMIS or iUARTFEMIS;

  
-- The Receive control state machine						 
  uUartRXCntl : UartRXCntl
  port map (
            UARTCLK         => UARTCLK,
            nUARTRST        => nUARTRST,
        
            Baud16          => Baud16,
            UARTENSync      => UARTENSync,
            SIRENSync       => SIRENSync,
            RXESync         => RXESync,
            RXD             => RXD,
        
            WLEN            => WLEN,
                                          
            STP2            => STP2,
            PEN             => PEN,
            Zerobaud        => Zerobaud,
            RXFWrDoneSync   => RXFWrDoneSync,   
            DtPrZero        => DtPrZero,   
        
            UARTFEICSync    => UARTFEICSync, 
            UARTBEICSync    => UARTBEICSync, 
            FEIMSync        => FEIMSync, 
            BEIMSync        => BEIMSync, 
        
            ShiftEn         => ShiftEn, 
            SampleParity    => SampleParity, 
            RXEnable        => RXEnable, 
            UartRXCntlState => UartRXCntlState,
                      
            RXDsampled      => RXDsampled, 
            ClearShiftReg   => ClearShiftReg,
            RXFWr           => RXFWr, 
            ReloadWD        => ReloadWD, 
            FramingError    => RXFIFOData(8), 
            Break           => RXFIFOData(10), 
            RXBUSY          => RXBUSY,
            CharRxComp      => CharRxComp,
        
            UARTFERIS       => iUARTFERIS, 
            UARTBERIS       => iUARTBERIS, 
            UARTFEMIS       => iUARTFEMIS, 
            UARTBEMIS       => iUARTBEMIS
            );
  
-- This block contains the receive shift register.
  uUartRXParShft : UartRXParShft
  port map (
            UARTCLK       => UARTCLK,
            nUARTRST      => nUARTRST,
        
            RXDsampled    => RXDsampled,
            ShiftEn       => ShiftEn,
            SampleParity  => SampleParity,
            ClearShiftReg => ClearShiftReg, 
            SPS           => SPS, 
            EPS           => EPS, 
            PEN           => PEN, 
            WLEN          => WLEN,
                                         
            PEIMSync      => PEIMSync, 
            UARTPEICSync  => UARTPEICSync, 
        
            RecdDATA      => RXFIFOData(7 downto 0),
            DtPrZero      => DtPrZero,
        
            ParityError   => RXFIFOData(9),
            UARTPERIS     => iUARTPERIS,
            UARTPEMIS     => iUARTPEMIS
            );
  

-- This state mcahine detects idle on the receive line
  uUartDataStp : UartDataStp
  port map (
            UARTCLK      => UARTCLK, 
            nUARTRST     => nUARTRST, 
        
            Baud16       => Baud16, 
            ReloadWD     => ReloadWD, 
        
            RXFESync     => RXFESync, 
            RTIMSync     => RTIMSync, 
            UARTRTICSync => UARTRTICSync, 
        
            DataStp      => DataStp
            );    
  end structural;
