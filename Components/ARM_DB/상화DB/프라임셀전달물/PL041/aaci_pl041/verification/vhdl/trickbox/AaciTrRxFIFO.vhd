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
-- File Name              : AaciTrRxFIFO.vhd.rca
-- File Revision          : 1.3
--
-- Release Information    : PrimeCell(TM)-PL041-REL1v0
--
-- ---------------------------------------------------------------------
-- Purpose :
--           This block contains the control logic for receive FIFO and
--           the receive FIFO array.
--
-- --=================================================================--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

use work.AaciTrPackage.all;

-- ---------------------------------------------------------------------

entity AaciTrRxFIFO is
  port (
-- Inputs
        PCLK             : in    std_logic; -- APB bus clock
        PRESETn          : in    std_logic; -- Reset from APB
        RxFWrSync        : in    std_logic; -- RX FIFO write enable
        RxFRdPtrInc      : in    std_logic; -- RX FIFO read ptr incr.
        RxFWrData        : in    std_logic_vector(19 downto 0);
                                            -- RX FIFO Wr data
-- Outputs
        RxFRdData        : out   std_logic_vector(19 downto 0);
                                            -- RX FIFO read data
        RxFFillLevel     : out   std_logic_vector(POINTERWIDTH downto 0)
                                            -- RX FIFO fill level
       );
end AaciTrRxFIFO;

-- ---------------------------------------------------------------------
--
--                            AaciTrRxFIFO
--                            ============
--
-- ---------------------------------------------------------------------
--
-- Overview
-- ========
--
-- Data on the RxFWrData bus is written into the location in the Receive
-- FIFO pointed to by the current value of the WrPtr[4:0] on the rising
-- edge of PCLK on when the RegFileWrEn signal is sampled high.
-- Data in the FIFO location pointed to by the RdPtr[4:0] signal is
-- always driven on the RxFRdData[19:0] output.
-- The Receive FIFO is implemented as a circular buffer.
-- FIFO fill level is calculated by finding the difference between the
-- pointers.
--
-- ---------------------------------------------------------------------
-- --========================= ARCHITECTURE ==========================--

architecture behavioral of AaciTrRxFIFO is

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

signal RxFIFO           : FIFO;
-- The receive FIFO

signal RegFileWrEn      : std_logic;
-- The write enable for receive FIFO

signal WrPtr            : std_logic_vector((POINTERWIDTH -1) downto 0);
-- The write pointer for receive FIFO

signal RdPtr            : std_logic_vector((POINTERWIDTH -1) downto 0);
-- The read pointer for receive FIFO

signal NextRdPtr        : std_logic_vector((POINTERWIDTH -1) downto 0);
-- D-input of RdPtr

signal NextWrPtr        : std_logic_vector((POINTERWIDTH -1) downto 0);
-- D-input of WrPtr

signal DelRxFWrSync     : std_logic;
-- Delayed version of RxFWr - Receive FIFO Write enable signal. Used to
-- convert the level on the RxFWr signal to a one-PCLK wide pulse.

signal Wrap             : std_logic;
-- Store the condition when the write pointer has rolled over
-- (from '11111' to '00000') but the read pointer hasn't. The 'Wrap'
-- signal is used in calculating the FIFOFillLevel

signal NextWrap         : std_logic;
-- D-input of Wrap

signal iRxFFillLevel    : std_logic_vector(POINTERWIDTH downto 0);
-- Receive FIFO Fill level indication

signal RNE              : std_logic;
-- Receive FIFO fill status indication (Receive FIFO not Empty)

signal NextRNE          : std_logic;
-- D-input of RNE

signal RFF              : std_logic;
-- Receive FIFO Full indication. Also used to prevent writes into the
-- FIFO when the FIFO is already full.

signal NextRFF          : std_logic;
-- D-input of RFF

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
  if x /= 0 then
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

-- ---------------------------------------------------------------------
--
-- Main body of code
-- =================
--
-- ---------------------------------------------------------------------

begin

-- ---------------------------------------------------------------------
-- Connect local copies to output ports
-- ---------------------------------------------------------------------
RxFFillLevel     <= iRxFFillLevel;

-- ---------------------------------------------------------------------
-- Allow writes to the Receive FIFO only if the FIFO is not already full
-- ---------------------------------------------------------------------
RegFileWrEn      <= WrPtrIncValid;

-- ---------------------------------------------------------------------
-- Clocked process for flip-flops in this module.
-- ---------------------------------------------------------------------
p_Seq: process (PCLK, PRESETn)
begin
  if (PRESETn = '0') then
    WrPtr        <= (others => '0');
    RdPtr        <= (others => '0');
    Wrap         <= '0';
    RNE          <= '0';
    RFF          <= '0';
    DelRxFWrSync <= '0';
  elsif (PCLK'event and PCLK = '1') then
    WrPtr        <= NextWrPtr;
    RdPtr        <= NextRdPtr;
    Wrap         <= NextWrap;
    RNE          <= NextRNE;
    RFF          <= NextRFF;
    DelRxFWrSync <= RxFWrSync;
  end if;
end process p_Seq;

-- ---------------------------------------------------------------------
-- Increment the write pointer when there is a write to the FIFO from
-- the Receive logic. The increment should be avoided if the receive
-- FIFO is already full. If the FIFO is already full and there is a
-- simultaneous read and a write, the write should be allowed to
-- complete and the write pointer should be incremented.
-- ---------------------------------------------------------------------
WrPtrIncValid <= ((RxFWrSync xor DelRxFWrSync) and
                  (not(RFF) or (RFF and RxFRdPtrInc)));

-- ---------------------------------------------------------------------
-- Increment the write pointer when the WrPtrIncValid signal is asserted
-- ---------------------------------------------------------------------
p_WrPtrComb : process (WrPtr, WrPtrIncValid)
begin
  if (WrPtrIncValid = '1') then
    NextWrPtr <= unsigned(WrPtr) + 1;
  else
    NextWrPtr <= WrPtr;
  end if;
end process p_WrPtrComb;

-- ---------------------------------------------------------------------
-- Increment the read pointer when the FIFO is not already empty and
-- when there is a read from the FIFO i.e. when the RxFRdPtrInc signal
-- from the APB interface, is asserted.
-- ---------------------------------------------------------------------
RdPtrIncValid <= RxFRdPtrInc and RNE;

-- ---------------------------------------------------------------------
-- Increment the read pointer when the RdPtrIncValid signal is asserted
-- ---------------------------------------------------------------------
p_RdPtrComb : process (RdPtr, RdPtrIncValid)
begin
  if (RdPtrIncValid = '1') then
    NextRdPtr <= unsigned(RdPtr) + 1;
  else
    NextRdPtr <= RdPtr;

  end if;
end process p_RdPtrComb;

-- ---------------------------------------------------------------------
-- The 'Wrap' bit is used to keep track of the condition when the write
-- pointer has wrapped around from '11111' to '00000', but the read
-- pointer has not wrapped. This bit is used to calculate the value of
-- iRxFFillLevel. Toggle the 'Wrap' bit whenever the read pointer wraps
-- around or the write pointer wraps around. When both the pointers wrap
-- around simultaneously, the 'Wrap' bit should not toggle.
-- ---------------------------------------------------------------------
p_WrapComb : process (WrPtr, WrPtrIncValid, RdPtr, Wrap,
                      RdPtrIncValid)
begin
  if (((WrPtr = ONES((POINTERWIDTH -1) downto 0))
       and (WrPtrIncValid = '1')) xor
       ((RdPtr = ONES((POINTERWIDTH -1) downto 0))
       and (RdPtrIncValid = '1'))) then
    NextWrap <= not(Wrap);
  else
    NextWrap <= Wrap;
  end if;
end process p_WrapComb;

-- ---------------------------------------------------------------------
-- Use the iRxFFillLevel (Receive FIFO Fill Level) signal to detect
-- whether the receive FIFO is not empty. If the FIFO is empty and there
-- is a valid write detected, then the FIFO is no longer empty. If the
-- FIFO has one valid entry and there is a valid read detected, without
-- a simultaneous write, the Receive FIFO is empty.
-- ---------------------------------------------------------------------
p_RNE : process (iRxFFillLevel, WrPtrIncValid, RdPtrIncValid, RNE)
begin
  if ((iRxFFillLevel = ZEROS(POINTERWIDTH downto 0))
       and (WrPtrIncValid = '1')) then
    NextRNE <= '1';
  elsif ((iRxFFillLevel = (ZEROS((POINTERWIDTH - 1) downto 0) & '1'))
          and (RdPtrIncValid = '1') and (WrPtrIncValid = '0')) then
    NextRNE <= '0';
  else
    NextRNE <= RNE;
  end if;
end process p_RNE;

-- ---------------------------------------------------------------------
-- RFF (Receive FIFO Full) generation. When the FIFO has seven entries
-- and and there is another write without a simultaneous read, the FIFO
-- is said to be Full. When the FIFO is already full and there is a read
-- from the FIFO without a simultaneous write, the FIFO is said to be
-- 'Not Full'
-- ---------------------------------------------------------------------
p_RFF : process (iRxFFillLevel, RFF, WrPtrIncValid, RdPtrIncValid)
begin
  if ((iRxFFillLevel = ('0' & ONES((POINTERWIDTH -1) downto 0)))
       and (WrPtrIncValid = '1') and (RdPtrIncValid = '0')) then
    NextRFF <= '1';
  elsif ((iRxFFillLevel = ('1' & ZEROS((POINTERWIDTH -1) downto 0)))
          and (RdPtrIncValid = '1') and
         (WrPtrIncValid = '0')) then
    NextRFF <= '0';
  else
    NextRFF <= RFF;
  end if;
end process p_RFF;

-- ---------------------------------------------------------------------
-- Subtract the write pointer from the read pointer to calculate the
-- FIFO fill level. Use the Wrap bit to take into account the case when
-- the write pointer has wrapped without the read pointer having wrapped
-- ---------------------------------------------------------------------
iRxFFillLevel <= (unsigned(Wrap & WrPtr) - unsigned('0' & RdPtr));

-- ---------------------------------------------------------------------
-- Register array.
-- ---------------------------------------------------------------------
p_FifoWriteSeq: process (PCLK)
begin
  if (PCLK'event and PCLK = '1') then
    if (RegFileWrEn = '1') then
      RxFIFO(to_integer(WrPtr)) <= RxFWrData;
    end if;
  end if;
end process p_FifoWriteSeq;

-- ---------------------------------------------------------------------
-- Read Mux. The contents of the location pointed to by the current
-- value of the read pointer RdPtr, is driven onto the read databus,
-- RxFRdData.
-- ---------------------------------------------------------------------
RxFRdData        <= RxFIFO(to_integer(RdPtr)) when
                    (iRxFFillLevel /= ZEROS(POINTERWIDTH downto 0))
                 else
                    (others => '0');

end behavioral;

-- --============================ End ================================--
