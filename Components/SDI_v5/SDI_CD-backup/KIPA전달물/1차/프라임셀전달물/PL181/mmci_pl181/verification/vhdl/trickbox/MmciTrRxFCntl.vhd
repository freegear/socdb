-- --=========================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 2000 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
--
-- -----------------------------------------------------------------------------
-- Version and Release Control Information:
--
-- File Name              : MmciTrRxFCntl.vhd.rca
-- File Revision          : 1.3
--
-- Release Information    : PrimeCell(TM)-PL181-REL1v0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           This block controls accesses to the Receive FIFO.
--
-- --=========================================================================--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

-- -----------------------------------------------------------------------------

entity MmciTrRxFCntl is
  port (
-- Inputs
        PCLK             : in    std_logic; -- APB bus clock
        PRESETn          : in    std_logic; -- Bus reset
        FifoClearSync    : in    std_logic; -- Clear signal
        RxFWrSync        : in    std_logic; -- RX FIFO write enable
        RxFRdPtrInc      : in    std_logic; -- RX FIFO read ptr incr.
-- Outputs
        RegFileWrEn      : out   std_logic; -- Wr enable to reg file
        RNE              : out   std_logic; -- RX FIFO not empty
        RFF              : out   std_logic; -- RX FIFO full
        RFHF             : out   std_logic; -- RX FIFO Half full
        WrPtr            : out   std_logic_vector(4 downto 0);
                                            -- Write pointer
        RdPtr            : out   std_logic_vector(4 downto 0)
                                            -- Read pointer
       );
end MmciTrRxFCntl;

-- -----------------------------------------------------------------------------
--
--                                MmciTrRxFCntl
--                                =============
--
-- -----------------------------------------------------------------------------
--
-- Overview
-- ========
--
--   The control logic for the Receive FIFO uses two pointers - a write
-- pointer and a read pointer. Since the FIFO has 32 locations, the
-- pointers are 5 bits wide. The write pointer points to the location
-- to which the next write data will be written into. The read pointer
-- points to the location whose contents are driven on the
-- RxFRdData[31:0] Read data bus.Both the pointers operate on PCLK so
-- to serve data consistently to the APB and to facilitate calculation
-- of the FIFO fill level by finding the difference between the
-- pointers.
--   This module also contains logic to generate the RNE (Receive FIFO
-- Not Empty) status signal, the RFF (Receive FIFO Full) status signal.
--
-- -----------------------------------------------------------------------------

-- --============================ ARCHITECTURE ===============================--

architecture behavioural of MmciTrRxFCntl is

-- -----------------------------------------------------------------------------
-- Component declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Constant declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Signal declarations
-- -----------------------------------------------------------------------------
signal iRdPtr           : std_logic_vector(4 downto 0);
-- Read pointer

signal NextRdPtr        : std_logic_vector(4 downto 0);
-- D-input of iRdPtr

signal iWrPtr           : std_logic_vector(4 downto 0);
-- Write pointer

signal NextWrPtr        : std_logic_vector(4 downto 0);
-- D-input of iWrPtr

signal DelRxFWrSync     : std_logic;
-- Delayed version of RxFWr - Receive FIFO Write enable signal. Used to
-- convert the level on the RxFWr signal to a one-PCLK wide pulse.

signal Wrap             : std_logic;
-- Store the condition when the write pointer has rolled over (from
-- '11111' to '00000') but the read pointer hasn't. The 'Wrap' signal
-- is used in calculating the FIFOFillLevel.

signal NextWrap         : std_logic;
-- D-input of Wrap

signal RxFFillLevel     : std_logic_vector(5 downto 0);
-- Receive FIFO Fill level indication

signal iRNE             : std_logic;
-- Receive FIFO fill status indication (Receive FIFO not Empty)

signal NextRNE          : std_logic;
-- D-input of iRNE

signal iRFF             : std_logic;
-- Receive FIFO Full indication. Also used to prevent writes into the
-- FIFO when the FIFO is already full.

signal NextRFF          : std_logic;
-- D-input of iRFF

signal iRFHF            : std_logic;
-- Receive FIFO Half Full indication.

signal NextRFHF         : std_logic;
-- D-input of iRFHF

signal WrPtrIncValid    : std_logic;
-- Valid Write pointer increment

signal RdPtrIncValid    : std_logic;
-- Valid Read Pointer Increment

-- -----------------------------------------------------------------------------
-- Function declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
--
-- Main body of code
-- =================
--
-- -----------------------------------------------------------------------------

begin

-- -----------------------------------------------------------------------------
-- Connect local copies to output ports
-- -----------------------------------------------------------------------------
WrPtr      <= iWrPtr;
RdPtr      <= iRdPtr;
RNE        <= iRNE;
RFF        <= iRFF;
RFHF       <= iRFHF;

-- -----------------------------------------------------------------------------
-- Allow writes to the Receive FIFO only if the FIFO is not already full
-- -----------------------------------------------------------------------------
RegFileWrEn <= WrPtrIncValid;

-- -----------------------------------------------------------------------------
-- Clocked process for flip-flops in this module.
-- -----------------------------------------------------------------------------
p_Seq : process (PCLK, PRESETn)
begin
  if (PRESETn = '0' or FifoClearSync = '1') then
    iWrPtr       <= (others => '0');
    iRdPtr       <= (others => '0');
    Wrap         <= '0';
    iRNE         <= '0';
    iRFF         <= '0';
    iRFHF        <= '0';
    DelRxFWrSync <= RxFWrSync;
  elsif (PCLK'event and PCLK = '1') then
    iWrPtr       <= NextWrPtr;
    iRdPtr       <= NextRdPtr;
    Wrap         <= NextWrap;
    iRNE         <= NextRNE;
    iRFF         <= NextRFF;
    iRFHF        <= NextRFHF;
    DelRxFWrSync <= RxFWrSync;
  end if;
end process p_Seq;

-- -----------------------------------------------------------------------------
-- Increment the write pointer when there is a write to the FIFO from
-- the Receive logic. The increment should be avoided if the receive
-- FIFO is already full. If the FIFO is already full and there is a
-- simultaneous read and a write, the write should be allowed to
-- complete and the write pointer should be incremented.
-- -----------------------------------------------------------------------------
WrPtrIncValid <= ((RxFWrSync xor DelRxFWrSync) and
                  (not(iRFF) or (iRFF and RxFRdPtrInc)))
                                    when (FifoClearSync = '0')
              else
                 '0';

-- -----------------------------------------------------------------------------
-- Increment the write pointer when the WrPtrIncValid signal is asserted
-- -----------------------------------------------------------------------------
p_WrPtrComb : process (iWrPtr, WrPtrIncValid)
begin
  if (WrPtrIncValid = '1') then
    NextWrPtr <= unsigned(iWrPtr) + 1;
  else
    NextWrPtr <= iWrPtr;
  end if;
end process p_WrPtrComb;

-- -----------------------------------------------------------------------------
-- Increment the read pointer when the FIFO is not already empty and
-- when there is a read from the FIFO i.e. when the RxFRdPtrInc signal
-- from the APB interface, is asserted.
-- -----------------------------------------------------------------------------
RdPtrIncValid <= (RxFRdPtrInc and iRNE);

-- -----------------------------------------------------------------------------
-- Increment the read pointer when the RdPtrIncValid signal is asserted
-- -----------------------------------------------------------------------------
p_RdPtrComb : process (iRdPtr, RdPtrIncValid)
begin
  if (RdPtrIncValid = '1') then
    NextRdPtr <= unsigned(iRdPtr) + 1;
  else
    NextRdPtr <= iRdPtr;
  end if;
end process p_RdPtrComb;

-- -----------------------------------------------------------------------------
-- The 'Wrap' bit is used to keep track of the condition when the write
-- pointer has wrapped around from '11111' to '00000', but the read
-- pointer hasn't.This bit is used to calculate the value of
-- RxFFillLevel. Toggle the 'Wrap' bit whenever the read pointer wraps
-- around or the write pointer wraps around. When both the pointers wrap
-- around simultaneously, the 'Wrap' bit should not toggle.
-- -----------------------------------------------------------------------------
p_WrapComb : process (iWrPtr, WrPtrIncValid, iRdPtr, Wrap,
                      RdPtrIncValid)
begin
  if (((iWrPtr = "11111") and (WrPtrIncValid = '1')) xor
      ((iRdPtr = "11111") and (RdPtrIncValid = '1'))) then
    NextWrap <= not(Wrap);
  else
    NextWrap <= Wrap;
  end if;
end process p_WrapComb;

-- -----------------------------------------------------------------------------
-- Use the RxFFillLevel (Receive FIFO Fill Level) signal to detect
-- whether the receive FIFO is not empty. If the FIFO is empty and
-- there is a valid write detected, then the FIFO is no longer empty.
-- If the FIFO has one valid entry and there is a valid read detected,
-- without a simultaneous write, the Receive FIFO is empty.
-- -----------------------------------------------------------------------------
p_RNE : process (RxFFillLevel, WrPtrIncValid, RdPtrIncValid, iRNE)
begin
  if ((RxFFillLevel = "000000") and (WrPtrIncValid = '1')) then
    NextRNE <= '1';
  elsif ((RxFFillLevel = "000001") and (RdPtrIncValid = '1')
         and (WrPtrIncValid = '0')) then
    NextRNE <= '0';
  else
    NextRNE <= iRNE;
  end if;
end process p_RNE;

-- -----------------------------------------------------------------------------
-- RFF (Receive FIFO Full) generation. When the FIFO has 31 entries and
-- and there is another write without a simultaneous read, the FIFO is
-- said to be Full. When the FIFO is already full and there is a read
-- from the FIFO without a simultaneous write, the FIFO is said
-- to be 'Not Full'
-- -----------------------------------------------------------------------------
p_RFF : process (RxFFillLevel, iRFF, WrPtrIncValid, RdPtrIncValid)
begin
  if ((RxFFillLevel = "011111") and (WrPtrIncValid = '1') and
      (RdPtrIncValid = '0')) then
    NextRFF <= '1';
  elsif ((RxFFillLevel = "100000") and (RdPtrIncValid = '1') and
         (WrPtrIncValid = '0')) then
    NextRFF <= '0';
  else
    NextRFF <= iRFF;
  end if;
end process p_RFF;

-- -----------------------------------------------------------------------------
-- RFHF (Receive FIFO Half Full) generation. When the FIFO has 15
-- entries and there is another write without a simultaneous read, the
-- FIFO is said to be Half Full. When the FIFO is already Half full
-- and there is a read from the without a simultaneous write, the FIFO
-- is said to be 'Not Full'
-- -----------------------------------------------------------------------------
p_RFHF : process (RxFFillLevel, iRFHF, WrPtrIncValid, RdPtrIncValid)
begin
  if ((RxFFillLevel = "001111") and (WrPtrIncValid = '1') and
      (RdPtrIncValid = '0')) then
    NextRFHF <= '1';
  elsif ((RxFFillLevel = "010000") and (RdPtrIncValid = '1') and
         (WrPtrIncValid = '0')) then
    NextRFHF <= '0';
  else
    NextRFHF <= iRFHF;
  end if;
end process p_RFHF;

-- -----------------------------------------------------------------------------
-- Subtract the write pointer from the read pointer to calculate the
-- FIFO fill level. Use the Wrap bit to take into account the case
-- when the write pointer has wrapped without the read pointer having
-- wrapped
-- -----------------------------------------------------------------------------
RxFFillLevel <= (unsigned(Wrap & iWrPtr) - unsigned('0' & iRdPtr));

end behavioural;

-- --================================== End ==================================--
