-- --=========================================================================--
--  This confidential and proprietary software may be used only as
--  authorised by a licensing agreement from ARM Limited
--    (C) COPYRIGHT 1999 ARM Limited
--        ALL RIGHTS RESERVED
--  The entire notice above must be reproduced on all authorised
--  copies and copies may only be made to the extent permitted
--  by a licensing agreement from ARM Limited.
--
--  ----------------------------------------------------------------------------
--  Version and Release Control Information:
--  
--  File Name              : SspTrTxFCntl.vhd.rca
--  File Revision          : 1.1
--  
--  Release Information    : PrimeCell(TM)-PL022-REL1v2
--  
-- -----------------------------------------------------------------------------
-- Purpose      : This module controls accesses to the Transmit FIFO 
-- -----------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

-- -----------------------------------------------------------------------------

entity SspTrTxFCntl is
  port (
        PCLK             : in    std_logic;  -- APB bus clock
        PRESETn          : in    std_logic;  -- APB bus Reset 
        SSPTBTDRWr       : in    std_logic;  -- TX FIFO Write enable
        TxFRdPtrIncSync  : in    std_logic;  -- TX FIFO Read Ptr Inc
        STxFRdPtrIncSync : in    std_logic;  -- TX FIFO Read Ptr Inc
        TxRxBSYSync      : in    std_logic;  -- Tx/Rx controller busy
        RegFileWrEn      : out   std_logic;  -- Register file write enable
        TxDataAvlbl      : out   std_logic;  -- TX Data available
        TNF              : out   std_logic;  -- TX FIFO not full
        TFE              : out   std_logic;  -- TX FIFO empty
        BSY              : out   std_logic;  -- SSPTB Busy
        WrPtr            : out   std_logic_vector(3 downto 0);
                                             -- Write pointer
        RdPtr            : out   std_logic_vector(3 downto 0) 
                                             -- Read pointer
       );
end SsptrTxFCntl;

-- -----------------------------------------------------------------------------
--
--                              SspTrTxFCntl
--                              ============
--
-- -----------------------------------------------------------------------------
--
-- Overview
-- ========
--
--   The control logic for the Transmit FIFO uses two pointers - a write 
-- pointer and a read pointer. The pointers are 3 bits wide. The write pointer 
-- points to the location to which the next write data will be written into. 
-- The read pointer points to the location whose contents are driven on the 
-- TxFRdData[15:0] Read data bus.
--   Both the pointers operate on PCLK so as not to miss any writes from the 
-- APB and to facilitate calculation of the FIFO fill level by finding the 
-- difference between the pointers. 
--   This module also contains logic to generate the TNF (Transmit FIFO Not 
-- Full) and TFE (Transmit FIFO Empty) status signals and the SSPTXINTR 
-- (Transmit FIFO Service Request) interrupt signal.
--
-- -----------------------------------------------------------------------------

-- --============================ ARCHITECTURE ===============================--
 
architecture behavioural of SspTrTxFCntl is

-- -----------------------------------------------------------------------------
-- Signal declarations 
-- -----------------------------------------------------------------------------
signal iRdPtr           : std_logic_vector(3 downto 0);
-- Read pointer

signal NextRdPtr        : std_logic_vector(3 downto 0);
-- D-input of iRdPtr

signal iWrPtr           : std_logic_vector(3 downto 0);
-- Write pointer

signal NextWrPtr        : std_logic_vector(3 downto 0);
-- D-input of iWrPtr

signal DelRdPtrInc      : std_logic;
-- Delayed version of TxFRdPtrIncSync - FIFO read pointer increment signal.
-- Used to convert the level on the TxFRdPtrIncSync signal to a 
-- one-PCLK wide pulse

signal Wrap             : std_logic;
-- Store the condition when the write pointer has rolled over (from '111' to 
-- '000') but the read pointer hasn't. The 'Wrap'signal is used in calculating
-- the FIFOFillLevel

signal NextWrap         : std_logic;
-- D-input of Wrap

signal TxFFillLevel     : std_logic_vector(4 downto 0);
-- FIFO Fill level indication

signal iTNF             : std_logic;
-- FIFO fill status indication (Transmit FIFO not full)

signal NextTNF          : std_logic;
-- D-input of iTNF

signal iTxDataAvlbl     : std_logic;
-- FIFO Fill status indication (Transmit Data Available in FIFO)

signal NextDatAvlbl     : std_logic;
-- D-input of iTxDataAvlbl

signal WrPtrIncValid    : std_logic;
-- Valid Write pointer increment

signal RdPtrIncValid    : std_logic;
-- Valid Read Pointer Increment

-- ---------------------------------------------------------------------------
--
-- Main body of code
-- =================
--
-- -----------------------------------------------------------------------------

begin

-- -----------------------------------------------------------------------------
-- Connect local copies of signals to ports
-- -----------------------------------------------------------------------------
WrPtr       <= iWrPtr;
RdPtr       <= iRdPtr;
TNF         <= iTNF;
TxDataAvlbl <= iTxDataAvlbl;

-- -----------------------------------------------------------------------------
-- Generate the TFE (Transmit FIFO Empty) signal by inverting the TxDataAvlbl
-- signal. When the TxDataAvlbl signal is asserted, it implies that the transmit
-- FIFO has atleast one byte of data and hence the FIFO is not empty (TFE to be
-- de-asserted). When the TxDataAvlbl signal is not asserted, it implies that 
-- there is no data in the Transmit FIFO and hence the FIFO is empty (TFE to be 
-- asserted)
-- -----------------------------------------------------------------------------
TFE <= not(iTxDataAvlbl);

-- -----------------------------------------------------------------------------
-- Allow writes to the Transmit FIFO only if the FIFO is not already full
-- -----------------------------------------------------------------------------
RegFileWrEn <= SSPTBTDRWr and iTNF;

-- ----------------------------------------------------------------------------
-- The SSP is BUSY when there is valid data available in the Transmit FIFO or
-- when the Transmitter/Receiver is busy.
-- -----------------------------------------------------------------------------
BSY <= iTxDataAvlbl or TxRxBSYSync;

-- -----------------------------------------------------------------------------
-- Clocked process for flip-flops in this module
-- -----------------------------------------------------------------------------
p_Seq: process (PCLK, PRESETn)
begin
  if (PRESETn = '0') then
    iWrPtr       <= (others => '0');
    iRdPtr       <= (others => '0');
    Wrap         <= '0';
    iTNF         <= '1';
    iTxDataAvlbl <= '0';
    DelRdPtrInc  <= '0';
  elsif (PCLK'event and PCLK = '1') then
    iWrPtr       <= NextWrPtr;
    iRdPtr       <= NextRdPtr;
    Wrap         <= NextWrap;
    iTNF         <= NextTNF;
    iTxDataAvlbl <= NextDatAvlbl;
    DelRdPtrInc  <= TxFRdPtrIncSync or STxFRdPtrIncSync;
  end if;
end process p_Seq;

-- -----------------------------------------------------------------------------
-- Increment the write pointer when there is a write to the FIFO from the APB.
-- The increment should be avoided if the transmit FIFO is already full. If
-- when the FIFO is full, there is a write and a simultaneous read, the write
-- should be allowed.
-- -----------------------------------------------------------------------------
WrPtrIncValid <= (SSPTBTDRWr and (iTNF or (not(iTNF) and 
                  (TxFRdPtrIncSync or STxFRdPtrIncSync)
                  and not(DelRdPtrInc))));
 
-- -----------------------------------------------------------------------------
-- Increment the Write pointer when the WrPtrIncValid signal is asserted.
-- -----------------------------------------------------------------------------
p_WrPtrComb: process (iWrPtr, WrPtrIncValid)
begin
  if (WrPtrIncValid = '1') then
    NextWrPtr <= unsigned(iWrPtr) + 1;
  else
    NextWrPtr <= iWrPtr;
  end if;
end process p_WrPtrComb;
 
-- -----------------------------------------------------------------------------
-- Increment the read pointer when the FIFO is not already empty and when there
-- is a read from the FIFO i.e. a rising edge is detected on the TxFRdPtrIncSync
-- signal or the STxFRdPtrIncSync signal.
-- -----------------------------------------------------------------------------
RdPtrIncValid <= (iTxDataAvlbl and (TxFRdPtrIncSync or STxFRdPtrIncSync)
                  and not(DelRdPtrInc));
 
-- -----------------------------------------------------------------------------
-- Increment the read pointer when the RdPtrIncValid signal is asserted.
-- -----------------------------------------------------------------------------
p_RdPtrComb: process (iRdPtr, RdPtrIncValid)
begin
  if (RdPtrIncValid = '1') then
    NextRdPtr <= unsigned(iRdPtr) + 1;
  else
    NextRdPtr <= iRdPtr;
  end if;
end process p_RdPtrComb;

-- -----------------------------------------------------------------------------
-- The 'Wrap' bit is used to keep track of the condition when the write pointer
-- has wrapped around from '111' to '000', but the read pointer has not wrapped.
-- This bit is used to calculate the value of TxFFillLevel. Toggle the 'Wrap'
-- bit whenever the read pointer wraps around or the write pointer wraps
-- around. When both the pointers wrap around simultaneously, the 'Wrap' bit
-- should not toggle.
-- -----------------------------------------------------------------------------
p_WrapComb: process (iWrPtr, iRdPtr, Wrap, WrPtrIncValid, RdPtrIncValid)
begin
  if (((iWrPtr = "1111") and (WrPtrIncValid = '1')) xor
      ((iRdPtr = "1111") and (RdPtrIncValid = '1'))) then
    NextWrap <= not(Wrap);
  else
    NextWrap <= Wrap;
  end if;
end process p_WrapComb;

-- -----------------------------------------------------------------------------
-- The iTNF (Transmit FIFO not Full) signal indicates the status of the Transmit
-- FIFO. When the FIFO is one less than full and there is another write to the
-- FIFO without a simultaneous read, the iTNF signal is cleared. 
-- When the FIFO is already full and there is a read from the FIFO, without a 
-- simultaneous write, the iTNF signal is set.
-- -----------------------------------------------------------------------------
p_TNF: process (TxFFillLevel, iTNF, WrPtrIncValid, RdPtrIncValid)
begin
  if ((TxFFillLevel = "01111") and (WrPtrIncValid = '1') and
      (RdPtrIncValid = '0')) then
    NextTNF <= '0';
  elsif ((TxFFillLevel = "10000") and (RdPtrIncValid = '1') and 
         (WrPtrIncValid = '0')) then
    NextTNF <= '1';
  else
    NextTNF <= iTNF;
  end if;
end process p_TNF;
 
-- -----------------------------------------------------------------------------
-- Use the TxFFillLevel (Transmit FIFO Fill Level) signal to indicate that
-- data is available for transmission. The result of the comparison is clocked
-- out onto the TxDataAvlbl signal.
-- -----------------------------------------------------------------------------
p_DataAvlbl: process(TxFFillLevel, WrPtrIncValid, RdPtrIncValid, iTxDataAvlbl)
begin
  if ((TxFFillLevel = "00000") and (WrPtrIncValid = '1')) then
    NextDatAvlbl <= '1';
  elsif ((TxFFillLevel = "00001") and (RdPtrIncValid = '1') and 
         (WrPtrIncValid = '0')) then
    NextDatAvlbl <= '0';
  else
    NextDatAvlbl <= iTxDataAvlbl;
  end if;
end process p_DataAvlbl;

-- -----------------------------------------------------------------------------
-- Subtract the write pointer from the read pointer to calculate the FIFO fill 
-- level. Use the Wrap bit to take into account the case when the write pointer
-- has wrapped without the read pointer having wrapped
-- -----------------------------------------------------------------------------
TxFFillLevel   <= (unsigned(Wrap & iWrPtr) - unsigned('0' & iRdPtr));

end behavioural;

-- --=========================== End =========================================--
