-- --=================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 2000 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
--
-- ---------------------------------------------------------------------
-- Version and Release Control Information:
--
-- File Name              : AaciTrTxFIFO.vhd.rca
-- File Revision          : 1.3
--
-- Release Information    : PrimeCell(TM)-PL041-REL1v0
--
-- ---------------------------------------------------------------------
-- Purpose :
--           This module contains the all the logic for transmit FIFO
--           array and the associated control logic
--
-- --=================================================================--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

use work.AaciTrPackage.all;

-- ---------------------------------------------------------------------
entity AaciTrTxFIFO is
  port (
-- Inputs
        PCLK             : in    std_logic; -- APB bus clock
        PRESETn          : in    std_logic; -- APB bus reset
        AACITrTxFIFOWr   : in    std_logic; -- Tx FIFO write enable
        TxFRdPtrIncSync  : in    std_logic; -- TX FIFO read ptr incr.
        PWDataIn         : in    std_logic_vector(19 downto 0);
                                            -- Int PWDATA
-- Outputs
        TxFRdDataIn      : out   std_logic_vector(19 downto 0);
                                            -- Tx FIFO Rddata
        TxFFillLevel     : out   std_logic_vector(POINTERWIDTH downto 0)
                                            -- Tx FIFO fill level
       );
end AaciTrTxFIFO;

-- --======================== ARCHITECTURE ===========================--

architecture behavioural of AaciTrTxFIFO is

-- ---------------------------------------------------------------------
--
--                            AaciTrTxFIFO
--                            ============
--
-- ---------------------------------------------------------------------
--
-- Overview
-- ========
--                The Transmit FIFO is implemented as a circular buffer.
-- Data on the PWDataIn bus is written into the location in the Receive
-- FIFO pointed to by the current value of the WrPtr[4:0] (Write
-- pointer) signal on the rising edge of PCLK on when the RegFileWrEn
-- signal is sampled high. Data in the FIFO location pointed to by the
-- RdPtr[4:0] signal is always driven on the TxFRdData[19:0] output.
--
--   Both the pointers operate on PCLK so as not to miss any writes from
-- the APB and to facilitate calculation of the FIFO fill level by
-- finding the difference between the pointers.
--
-- ---------------------------------------------------------------------

-- ---------------------------------------------------------------------
-- Constant declarations
-- ---------------------------------------------------------------------
constant ONES             : std_logic_vector(31 downto 0)
                          := "11111111111111111111111111111111";
-- To fill with all the ones

constant ZEROS            : std_logic_vector(31 downto 0)
                          := "00000000000000000000000000000000";
-- To fill with all the zeros

-- ---------------------------------------------------------------------
-- Signal declarations
-- ---------------------------------------------------------------------
type FIFO is array ((FIFODEPTH - 1) downto 0) of
                         std_logic_vector(19 downto 0);
-- The FIFO of array type width is 20 and 'FIFODEPTH' entries

signal TxFIFO           : FIFO;
-- The receive FIFO

signal RegFileWrEn      : std_logic;
-- The write enable signal for transmit FIFO

signal RdPtr            : std_logic_vector((POINTERWIDTH -1) downto 0);
-- The read pointer for transmit FIFO

signal WrPtr            : std_logic_vector((POINTERWIDTH -1) downto 0);
-- The write pointer for transmit FIFO

signal NextRdPtr        : std_logic_vector((POINTERWIDTH -1) downto 0);
-- D-input of RdPtr

signal NextWrPtr        : std_logic_vector((POINTERWIDTH -1) downto 0);
-- D-input of WrPtr

signal DelRdPtrInc      : std_logic;
-- Delayed version of TxFRdPtrIncSync read pointer increment signal.
-- Used to convert the level on the TxFRdPtrIncSync signal to a one-PCLK
-- wide pulse

signal Wrap             : std_logic;
-- Store the condition when the write pointer has rolled over
-- (from '11111' to '00000') but the read pointer hasn't. The 'Wrap'
-- signal is used in calculating the FIFOFillLevel

signal NextWrap         : std_logic;
-- D-input of Wrap
signal iTxFFillLevel    : std_logic_vector(POINTERWIDTH downto 0);
-- FIFO Fill level indication

signal TNF              : std_logic;
-- Transmit FIFO not full

signal NextTNF          : std_logic;
-- D-input of TNF

signal TxDataAvlbl      : std_logic;
-- Transmit Data Available in FIFO

signal NextDatAvlbl     : std_logic;
-- D-input of TxDataAvlbl

signal WrPtrIncValid    : std_logic;
-- Valid Write pointer increment

signal RdPtrIncValid    : std_logic;
-- Valid Read Pointer Increment

-- ---------------------------------------------------------------------
-- Function declarations
-- ---------------------------------------------------------------------
function to_integer (
         val : std_logic_vector;
         x   : integer := 0
                    ) return integer is
  variable returnint : integer;
  -- Return variable from the function

  variable xtmp      : integer;
  -- Temporary variable

begin
  returnint := 0;
  xtmp := 0;
  if (x /= 0) then
    xtmp := 1;
  end if;
  for i in val'range loop
    returnint := returnint + returnint;
      case val(i) is
        when '0'    => null;
        when '1'    => returnint := returnint + 1;
        when others => returnint := returnint + xtmp;
      end case;
  end loop;
  return returnint;
end to_integer;

-- -------------------------------------------------------------------
--
-- Main body of code
-- =================
--
-- ---------------------------------------------------------------------

begin

-- ---------------------------------------------------------------------
-- Connect local copies of signals to ports
-- ---------------------------------------------------------------------
TxFFillLevel     <= iTxFFillLevel;

-- ---------------------------------------------------------------------
-- Allow writes to the Transmit FIFO only if the FIFO is not full
-- ---------------------------------------------------------------------
RegFileWrEn      <= WrPtrIncValid;

-- ---------------------------------------------------------------------
-- Clocked process for flip-flops in this module
-- ---------------------------------------------------------------------
p_Seq: process (PCLK, PRESETn)
begin
  if (PRESETn = '0') then
    WrPtr            <= (others => '0');
    RdPtr            <= (others => '0');
    Wrap             <= '0';
    TNF              <= '1';
    TxDataAvlbl      <= '0';
    DelRdPtrInc      <= '0';
  elsif (PCLK'event and PCLK = '1') then
    WrPtr            <= NextWrPtr;
    RdPtr            <= NextRdPtr;
    Wrap             <= NextWrap;
    TNF              <= NextTNF;
    TxDataAvlbl      <= NextDatAvlbl;
    DelRdPtrInc      <= TxFRdPtrIncSync;
  end if;
end process p_Seq;

-- ---------------------------------------------------------------------
-- Increment the write pointer when there is a write to the FIFO from
-- the APB. The increment should be avoided if the transmit FIFO is
-- already full. If when the FIFO is full, there is a write and a
-- simultaneous read, the write should be allowed.
-- ---------------------------------------------------------------------
WrPtrIncValid    <= (AACITrTxFIFOWr and (TNF or (not TNF and
                     (TxFRdPtrIncSync xor DelRdPtrInc))));

-- ---------------------------------------------------------------------
-- Increment the Write pointer when the WrPtrIncValid sig is asserted.
-- ---------------------------------------------------------------------
p_WrPtrComb: process (WrPtr, WrPtrIncValid)
begin
  if (WrPtrIncValid = '1') then
    NextWrPtr        <= unsigned(WrPtr) + 1;
  else
    NextWrPtr        <= WrPtr;
  end if;
end process p_WrPtrComb;

-- ---------------------------------------------------------------------
-- Increment the read pointer when the FIFO is not already empty and
-- when there is a read from the FIFO i.e. a rising edge is detected on
-- the TxFRdPtrIncSync signal.
-- ---------------------------------------------------------------------
RdPtrIncValid <= (TxDataAvlbl and (TxFRdPtrIncSync xor DelRdPtrInc));

-- ---------------------------------------------------------------------
-- Increment the read pointer when the RdPtrIncValid signal is asserted.
-- ---------------------------------------------------------------------
p_RdPtrComb: process (RdPtr, RdPtrIncValid)
begin
  if (RdPtrIncValid = '1') then
    NextRdPtr        <= unsigned(RdPtr) + 1;
  else
    NextRdPtr        <= RdPtr;
  end if;
end process p_RdPtrComb;

-- ---------------------------------------------------------------------
-- The 'Wrap' bit is used to keep track of the condition when the write
-- pointer has wrapped around from '11111' to '00000', but the read
-- pointer has not wrapped. This bit is used to calculate the value of
-- iTxFFillLevel. Toggle the 'Wrap' bit whenever the read pointer wraps
-- around or the write pointer wraps around. When both the pointers wrap
-- around simultaneously, the 'Wrap' bit should not toggle.
-- ---------------------------------------------------------------------
p_WrapComb: process (WrPtr, RdPtr, Wrap, WrPtrIncValid, RdPtrIncValid)
begin
  if (((WrPtr = ONES((POINTERWIDTH -1) downto 0))
       and (WrPtrIncValid = '1')) xor
      ((RdPtr = ONES((POINTERWIDTH -1) downto 0))
       and (RdPtrIncValid = '1'))) then
    NextWrap         <= not(Wrap);
  else
    NextWrap         <= Wrap;
  end if;
end process p_WrapComb;

-- ---------------------------------------------------------------------
-- The TNF (Transmit FIFO not Full) signal indicates the status of the
-- Transmit FIFO. When the FIFO is one less than full and there is
-- another write to the FIFO without a simultaneous read, the TNF
-- signal is cleared. When the FIFO is already full and there is a read
-- from the FIFO, without a simultaneous write, the TNF signal is set.
-- ---------------------------------------------------------------------
p_TNF: process (iTxFFillLevel, TNF, WrPtrIncValid, RdPtrIncValid)
begin
  if ((iTxFFillLevel = ('0' & ONES((POINTERWIDTH -1) downto 0)))
      and (WrPtrIncValid = '1') and (RdPtrIncValid = '0')) then
    NextTNF          <= '0';
  elsif ((iTxFFillLevel = ('1' & ZEROS((POINTERWIDTH - 1) downto 0)))
         and (RdPtrIncValid = '1') and (WrPtrIncValid = '0')) then
    NextTNF          <= '1';
  else
    NextTNF          <= TNF;
  end if;
end process p_TNF;

-- ---------------------------------------------------------------------
-- Use the iTxFFillLevel (Transmit FIFO Fill Level) signal to indicate
-- that data is available for transmission. The result of the comparison
-- is clocked out onto the TxDataAvlbl signal.
-- ---------------------------------------------------------------------
p_DataAvlbl: process (iTxFFillLevel, WrPtrIncValid, RdPtrIncValid,
                      TxDataAvlbl)
begin
  if ((iTxFFillLevel = (ZEROS(POINTERWIDTH downto 0)))
       and (WrPtrIncValid = '1')) then
    NextDatAvlbl     <= '1';
  elsif ((iTxFFillLevel = (ZEROS((POINTERWIDTH - 1) downto 0) & '1'))
          and (RdPtrIncValid = '1') and
         (WrPtrIncValid = '0')) then
    NextDatAvlbl     <= '0';

  else
    NextDatAvlbl     <= TxDataAvlbl;
  end if;
end process p_DataAvlbl;

-- ---------------------------------------------------------------------
-- Subtract the write pointer from the read pointer to calculate the
-- FIFO fill level. Use the Wrap bit to take into account the case when
-- the write pointer has wrapped without the read pointer having wrapped
-- ---------------------------------------------------------------------
iTxFFillLevel    <= (unsigned(Wrap & WrPtr) - unsigned('0' & RdPtr));

-- ---------------------------------------------------------------------
-- Register array.
-- ---------------------------------------------------------------------
p_FifoWriteSeq: process (PCLK)
begin
  if (PCLK'event and PCLK = '1') then
    if (RegFileWrEn = '1') then
      TxFIFO(to_integer(WrPtr)) <= PWDataIn;
    end if;
  end if;
end process p_FifoWriteSeq;

-- ---------------------------------------------------------------------
-- Read Mux. The contents of the location pointed to by the current
-- value of the read pointer RdPtr, is driven onto the read databus,
-- TxFRdData.
-- ---------------------------------------------------------------------
TxFRdDataIn      <= TxFIFO(to_integer(RdPtr)) when
                    (iTxFFillLevel /= ZEROS(POINTERWIDTH downto 0))
                 else
                   (others => '0');

end behavioural;

-- --=========================== End =================================--
