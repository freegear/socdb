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
--  File Name              : UartTXFIFO.vhd.rca
--  File Revision          : 1.9
--  
--  Release Information    : PrimeCell(TM)-PL011-REL1v3
--  
--  ----------------------------------------------------------------------------
--  
--  
--  
-- -----------------------------------------------------------------------------
--  Purpose          : This block instantiates the UartTXFCntl (Transmit FIFO
--                    control)  and the UartTXRegFile (Register File) blocks.
-- -----------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

entity UartTXFIFO is
  port (
        PCLK    	: in  std_logic;      -- APB Clock
        PRESETn	        : in  std_logic;      -- AMBA Bus reset
        
        PWDATAIn	: in  std_logic_vector(7 downto 0);
                                              -- Data bus
        UARTEN  	: in  std_logic;      -- UART Enable
        TXE	        : in  std_logic;      -- TX Enable
        TXFRdPtrIncSync	: in  std_logic;      -- TX FIFO Rd Ptr Inc
        FEN	        : in  std_logic;      -- FIFO Enable
        BRK 	        : in  std_logic;      -- BRK request
        AbortSync	: in  std_logic;      -- Transmission aborted
        
        UARTDRWrEn	: in  std_logic;      -- TX FIFO Write enable
        TestTXFInc      : in  std_logic;      -- tx fifo rdptr inc
        TXBUSYSync	: in  std_logic;      -- Transmitter busy
        TESTFIFO        : in  std_logic;      -- Test signal
        CharTxCompSync  : in  std_logic;      -- Sync'ed Tx character complete
        
        UARTTXIC        : in  std_logic;      -- For Tx Interrupt clear
        TXIM            : in  std_logic;      -- Tx Interrupt Mask
        TXIFLSEL	: in  std_logic_vector(2 downto 0);
                                              -- fifo interrupt level select
        
        TXShiftData	: out std_logic_vector(7 downto 0);
                                              -- Xmit Data
        TXFF	        : out std_logic;      -- Transmit FIFO Full
        TXFE	        : out std_logic;      -- Transmit FIFO Empty
        TXDataAvlbl	: out std_logic;      -- TX Data Available
        RdPtrIncDone	: out std_logic;      -- Rd Ptr Inc done
        BUSY	        : out std_logic;      -- UART BUSY
        TXFIFOData      : out std_logic_vector(7 downto 0);
                                              -- TX fifo data
        TXFLTE15Full    : out std_logic;      --  To DMA block
        TXIntLevel      : out std_logic;      -- Programmable Interrupt Level
        
        UARTTXIClr      : out std_logic;      --  Tx Interrupt clear
        UARTTXRIS	: out std_logic;      -- Transmit Raw Interrupt
        UARTTXMIS	: out std_logic       -- Transmit Masked Interrupt
        );
end UartTXFIFO;

architecture structural of UartTXFIFO is
-- 
-- -----------------------------------------------------------------------------
-- 
--                                 UartTXFIFO
--                                 ==========
-- 
-- -----------------------------------------------------------------------------
-- 
-- Overview
-- ========
-- 
--   Writes to the transmit FIFO occur through the APB interface from the PCLK 
-- domain. Reads from the transmit FIFO occur from the transmit block which 
-- falls in the UARTCLK clock domain. The FIFO is 8-bit wide and 16-deep. 
--   The UartTXFCntl module contains the control logic for the FIFO. It contains
-- a write pointer, a read pointer and a transmit shift register. Writes from 
-- the APB can occur as close as every two PCLK periods. So as to ensure that 
-- no writes are missed, the write pointer operates on PCLK.
--  To facilitate FIFO fill level calculation, the read pointer is also operated
-- on PCLK. 
--   Write data from the APB is written into the location pointed to by the 
-- current value of the write pointer. If a write occurs to the FIFO when it is
-- already full, the write is ignored.
--   The TXDataAvlbl output signal is asserted when there is data available to 
-- be transmitted. Upon detecting this signal, the transmitter commences
-- transmission. At the end of transmission of one data byte, the transmitter 
-- asserts the RdPtrInc signal.
-- The fifo can be set to be in TESTFIFO mode which allows data to
-- be read out of theTx fifo.
  -- -----------------------------------------------------------------------------
  signal WrPtr	      : std_logic_vector(3 downto 0); 
  signal RdPtr        : std_logic_vector(3 downto 0); 
  signal RegFileWrEn  : std_logic;
  signal iTXFIFOData  : std_logic_vector(7 downto 0); 


  component UartTXRegFile 
    port (
          PCLK	      : in    std_logic;
          PRESETn     : in    std_logic;
          
          RegFileWrEn : in    std_logic;
          WrPtr	      : in    std_logic_vector(3 downto 0);
          RdPtr       : in    std_logic_vector(3 downto 0);
          PWDATAIn    : in    std_logic_vector(7 downto 0);
          
          iTXFIFOData : out   std_logic_vector(7 downto 0)
          );
  end component;


  component UartTXFCntl 
    port (
          PCLK            : in  std_logic;  
          PRESETn         : in  std_logic;  
        
          TXFRdPtrIncSync : in  std_logic;  
          FEN             : in  std_logic;  
          UARTEN          : in  std_logic;  
          TXE             : in  std_logic;  
          TESTFIFO        : in  std_logic; 
          AbortSync       : in  std_logic; 
          BRK             : in  std_logic;   
          CharTxCompSync  : in  std_logic; 
          
          UARTDRWrEn      : in  std_logic; 
          iTXFIFOData     : in  std_logic_vector(7 downto 0);
          PWDATAIn        : in  std_logic_vector(7 downto 0);
          TXIFLSEL        : in  std_logic_vector(2 downto 0);
          TestTXFInc      : in  std_logic; 
          TXIM            : in  std_logic; 
          UARTTXIC        : in  std_logic; 
          TXBUSYSync      : in  std_logic; 
        
          WrPtr           : out std_logic_vector(3 downto 0);
          RdPtr           : out std_logic_vector(3 downto 0);
          TXFF            : out std_logic;
          TXFE            : out std_logic;
          BUSY            : out std_logic;
          TXDataAvlbl     : out std_logic;
          RegFileWrEn     : out std_logic;
          TXShiftData     : out std_logic_vector(7 downto 0);
          TXFLTE15Full    : out std_logic;  
          TXIntLevel      : out std_logic;   
          RdPtrIncDone    : out std_logic; 
        
          UARTTXIClr      : out std_logic; 
          UARTTXRIS       : out std_logic; 
          UARTTXMIS       : out std_logic  
          );
  end component;


begin



-- The UartTXRegFile is a data buffer implemented using D-types.
  uUartTXRegFile : UartTXRegFile
  port map (
            PCLK        => PCLK,
            PRESETn     => PRESETn,
          
            RegFileWrEn => RegFileWrEn,
            WrPtr       => WrPtr,
            RdPtr       => RdPtr,
            PWDATAIn    => PWDATAIn,
          
            iTXFIFOData => iTXFIFOData
            );
  


-- The UartTXFCntl block controls accesses to the FIFO register file.
  uUartTXFCntl : UartTXFCntl
  port map (
            PCLK            => PCLK,  
            PRESETn         => PRESETn,  
        
            TXFRdPtrIncSync => TXFRdPtrIncSync,  
            FEN             => FEN,  
            UARTEN          => UARTEN,  
            TXE             => TXE,  
            TESTFIFO        => TESTFIFO, 
            AbortSync       => AbortSync,
            BRK             => BRK, 
            CharTxCompSync  => CharTxCompSync, 
          
            UARTDRWrEn      => UARTDRWrEn, 
            iTXFIFOData     => iTXFIFOData,
            PWDATAIn        => PWDATAIn,
            TXIFLSEL        => TXIFLSEL,
            TestTXFInc      => TestTXFInc, 
            TXIM            => TXIM, 
            UARTTXIC        => UARTTXIC, 
            TXBUSYSync      => TXBUSYSync, 
        
            WrPtr           => WrPtr,
            RdPtr           => RdPtr,
            TXFF            => TXFF,
            TXFE            => TXFE,
            BUSY            => BUSY,
            TXDataAvlbl     => TXDataAvlbl,
            RegFileWrEn     => RegFileWrEn,
            TXShiftData     => TXShiftData,
            TXFLTE15Full    => TXFLTE15Full,  
            TXIntLevel      => TXIntLevel,   
            RdPtrIncDone    => RdPtrIncDone, 
        
            UARTTXIClr      => UARTTXIClr, 
            UARTTXRIS       => UARTTXRIS, 
            UARTTXMIS       => UARTTXMIS
            );
   
  TXFIFOData <= iTXFIFOData;
  
end structural;
