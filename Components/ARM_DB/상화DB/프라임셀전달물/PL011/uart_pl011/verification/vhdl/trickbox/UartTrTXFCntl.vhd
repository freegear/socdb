--============================================================================--
--  This confidential and proprietary software may be used only as
--  authorised by a licensing agreement from ARM Limited
--    (C) COPYRIGHT 1998-2000 ARM Limited
--        ALL RIGHTS RESERVED
--  The entire notice above must be reproduced on all authorised
--  copies and copies may only be made to the extent permitted
--  by a licensing agreement from ARM Limited.
-- -----------------------------------------------------------------------------
--  
--  Version and Release Control Information:
--  
--  File Name              : UartTrTXFCntl.vhd.rca
--  File Revision          : 1.4
--  
--  Release Information    : PrimeCell(TM)-PL011-REL1v3
--  
-- ----------------------------------------------------------------------------
-- Purpose     : This block contains the control logic for the transmit
--               FIFO
--============================================================================--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

--  ----------------------------------------------------------------------------
entity UartTrTXFCntl is
  port (
        PCLK           : in    std_logic;	-- APB Clock
        PRESETn        : in    std_logic;	-- AMBA Reset
        TXBUSY         : in    std_logic;	-- Transmitter busy
        UARTDRWrEn     : in    std_logic;	-- TX FIFO Write enable
        TXFIFOData     : in    std_logic_vector(7 downto 0);	-- To Shft Reg
        PWDATAIn       : in    std_logic_vector(7 downto 0);	-- Data bus.
        TXFRdPtrInc    : in    std_logic;	-- TX FIFO Rd Ptr Inc
        FEN            : in    std_logic;	-- FIFO Enable
        UARTEN         : in    std_logic;	-- UART Enable
        TXDataAvlbl    : out   std_logic;	-- TX Data Available
        RdPtrIncDone   : out   std_logic;	-- Rd Ptr Inc done
        RegFileWrEn    : out   std_logic;	-- Register file write enable
        WrPtr          : out   std_logic_vector(3 downto 0);	-- Write pointer
        RdPtr          : out   std_logic_vector(3 downto 0);	-- Read pointer
        TXShiftData    : out   std_logic_vector(7 downto 0);	-- Xmit Data
        TXFF           : out   std_logic;	-- Transmit FIFO Full
        TXFE           : out   std_logic;	-- Transmit FIFO Empty
        TXFLTEHalfFull : out   std_logic        -- Transmit FIFO Half-Empty  
       );
end UartTrTXFCntl;

--------------------------------------------------------------------------------

--                   UartTrTXFCntl
--                   ===========

--------------------------------------------------------------------------------
--
-- Overview
-- ========
--
--  The control logic for the transmit FIFO uses two pointers - a write pointer
-- and a read pointer. The pointers are 4 bits wide. The write pointer points 
-- to the location to which the next write data will be written into. The read 
-- pointer points to the next location whose contents will be read out. Both 
-- the pointers operate on PCLK so as to not miss any writes from the APB and 
-- to conveniently calculate the FIFO fill level by finding the difference 
-- between the pointers.
--  When the FIFO is disabled, the pointers do not change and the fill status 
-- of the holding buffer is indicated by a separate bit 'HldBufValid'. 
--
--=============================== ARCHITECTURE ===============================--
 
architecture synth of UartTrTXFCntl  is

--------------------------------------------------------------------------------
-- Signal declarations
--------------------------------------------------------------------------------

signal    iRdPtr              : std_logic_vector(3 downto 0);
-- Internal version of Read pointer

signal    NextRdPtr           : std_logic_vector(3 downto 0);
-- D-input of Read pointer vector

signal    RdPtrIncValid       : std_logic;
-- Valid Read pointer increment 

signal    iWrPtr              : std_logic_vector(3 downto 0);
-- Internal version of Write Pointer

signal    NextWrPtr           : std_logic_vector(3 downto 0);
-- D-input of the write pointer vector

signal    WrPtrIncValid       : std_logic;
-- Valid Write pointer increment 

signal    DelRdPtrIncStg1         : std_logic;
-- Delayed version of TXFRdPtrIncSync - FIFO read pointer increment signal
-- Used to convert the level on the TXFRdPtrIncSync signal to a one-clock
-- wide pulse

signal    Wrap                : std_logic;
-- Store the condition when the write pointer has rolled over (from
-- '1111' to '0000') but the read pointer hasn't. This signal is
-- used in calculating the FIFOFillLevel 

signal    NextWrap            : std_logic;
-- D-input of Wrap bit

signal    TXFNotEmpty         : std_logic;
-- Signal used to indicate whether any data is available in the FIFO
-- when the FIFO is enabled

signal    iTXFF               : std_logic;
-- Local copy of the output signal TXFF which indicates whether the
-- FIFO is full, readable through UARTFG register

signal    iTXFLTEHalfFull      : std_logic;
-- Signal to indicate if the transmit FIFO is less than or equal to 
-- half full. Used to generate the transmit interrupt UARTTXINTR

signal    TXFFillLevel        : std_logic_vector(4 downto 0);
-- FIFO Fill level indication

signal    HldBufValid         : std_logic;
-- Fill status of the holding register. Used in the case when the
-- FIFO is disabled

signal    NextHldBufValid     : std_logic;
-- D-input of HldBufValid bit

signal    iTXShiftData        : std_logic_vector(7 downto 0);
-- Local copy of the transmit shift register output. Data driven on
-- this output is used by the transmitter block as transmit data

signal    NextTXShiftData     : std_logic_vector(7 downto 0);
-- D-input of iTXShiftData vector

signal    TXShiftRegEmpty     : std_logic;
-- Fill status of the transmit Shift register
-- NOTE : The assertion of this signal does not directly mean that the shift 
-- register is empty. It only implies that the next write to the transmit 
-- FIFO should fill up the shift register directly instead of accumulating 
-- in the FIFO

signal    NxtTXShiftRegEmpty  : std_logic;
-- D-input of TXShiftRegEmpty bit 

signal    NextUARTTXINTR      : std_logic;
-- D-input of UARTTXINTR bit

signal    DelUARTEN           : std_logic;
-- Delayed version of the UARTEN signal. Used to detect a rising edge on this
-- signal

signal    FIFOFull            : std_logic;
-- FIFO full status indication when the FIFO is enabled

signal    NextFIFOFull        : std_logic;
-- D-input of FIFOFull bit

signal    FIFONotEmpty        : std_logic;
-- FIFO empty status indication when the FIFO is enabled

signal    DelRdPtrIncStg2     : std_logic;
-- Twice delayed Read Pointer Increment signal
 
signal    NextFIFONotEmpty    : std_logic;
-- D-input of FIFONotEmpty bit

signal    iTXDataAvlbl        : std_logic;
-- Internal copy of TXDataAvlbl output signal

signal    LoadShiftReg        : std_logic;
-- Shift register load trigger

signal    ShiftDataAvlbl      : std_logic;
-- Shift register contains valid data that is currently being transmitted
 
signal    NextShftDatAvlbl    : std_logic;
-- D-input of ShftDataAvlbl signal

signal    FIFOLTEHalfFull     : std_logic;
-- FIFO FillLevel compare result

--------------------------------------------------------------------------------
--
-- Main body of code
-- =================
--
--------------------------------------------------------------------------------

begin

--------------------------------------------------------------------------------
-- Connect local copies of signals to ports
--------------------------------------------------------------------------------
  WrPtr          <= iWrPtr;
  TXShiftData    <= iTXShiftData;
  TXFF           <= iTXFF;
  RdPtr          <= iRdPtr;
  TXDataAvlbl    <= iTXDataAvlbl;
  TXFLTEHalfFull <= iTXFLTEHalfFull;
--------------------------------------------------------------------------------
-- Indicate the availability of data to transmit to  the transmit logic. Data 
-- is said to be available if the FIFO contains valid data or if the Shift
-- Register contains valid data. 
--------------------------------------------------------------------------------
  iTXDataAvlbl   <= TXFNotEmpty or ShiftDataAvlbl;

--------------------------------------------------------------------------------
-- Ignore writes to FIFO if FIFO is already full. Use WrPtrIncValid signal 
-- as the Write enable. The Write pointer increment operation occurs only if
-- the FIFO is enabled, but the WrPtrIncValid signal is generated independent 
-- of whether the FIFO is enabled or not.
--------------------------------------------------------------------------------
  RegFileWrEn    <= WrPtrIncValid;

--------------------------------------------------------------------------------
-- Assert and De-assert Done signal the next clock after TXFRdPtrIncSync
-- is seen
--------------------------------------------------------------------------------
  RdPtrIncDone   <= DelRdPtrIncStg1;

--------------------------------------------------------------------------------
-- Sequential process for registers/flip-flops in this block
--------------------------------------------------------------------------------
  p_PtrsSeq : process (PCLK, PRESETn)
  begin
    if (PRESETn = '0') then
      iWrPtr          <= (others => '0');
      iRdPtr          <= (others => '0');
      DelRdPtrIncStg1 <= '1';
      DelRdPtrIncStg2 <= '1';
      Wrap            <= '0';
      HldBufValid     <= '0';
      iTXShiftData    <= (others => '0');
      TXShiftRegEmpty <= '1';
      DelUARTEN       <= '0';
      FIFOFull        <= '0';
      FIFONotEmpty    <= '0';
      ShiftDataAvlbl  <= '0';
    elsif (PCLK'event and PCLK = '1') then
        iWrPtr          <= NextWrPtr;
        iRdPtr          <= NextRdPtr;
        DelRdPtrIncStg1 <= DelRdPtrIncStg2;
        DelRdPtrIncStg2 <= TXFRdPtrInc;
        Wrap            <= NextWrap;
        HldBufValid     <= NextHldBufValid;
        iTXShiftData    <= NextTXShiftData;
        TXShiftRegEmpty <= NxtTXShiftRegEmpty;
        DelUARTEN       <= UARTEN;
        FIFOFull        <= NextFIFOFull;
        FIFONotEmpty    <= NextFIFONotEmpty;
        ShiftDataAvlbl  <= NextShftDatAvlbl;
    end if;
  end process p_PtrsSeq;

--------------------------------------------------------------------------------
-- Load the shift register with transmit data from the FIFO when either of the 
-- following conditions occur:
-- * The UART is just enabled, and there is no Abort condition
-- * The Abort condition is just removed and the UART is already enabled
-- * The Read pointer increment signal (TXFRdPtrInc) signal is just
--   asserted with the UART being enabled and there being no Abort condition.
--------------------------------------------------------------------------------
  LoadShiftReg <= UARTEN and 
                  (not(DelUARTEN) or (DelRdPtrIncStg2 and
                   not(DelRdPtrIncStg1)));

--------------------------------------------------------------------------------
-- Increment the write pointer when there is a write to the FIFO from the APB. 
-- The increment should be avoided if the transmit FIFO is already full or if 
-- the TXShiftRegEmpty signal is asserted indicating that the next write should
-- go to the shift register directly. If TXShiftRegEmpty is not already 
-- asserted and if it is about to be asserted on the next PCLK (as indicated
-- by the assertion of LoadShiftReg with the FIFO being empty), then the write
-- data is to be written into the Shift register and not into the FIFO. 
--------------------------------------------------------------------------------
  WrPtrIncValid <= UARTDRWrEn and (not(TXShiftRegEmpty or (not(TXShiftRegEmpty)
                   and LoadShiftReg and not(TXFNotEmpty)))) and
                   (not(iTXFF) or (iTXFF and LoadShiftReg));

--------------------------------------------------------------------------------
-- Freeze the Write pointer at zero when the FIFO is disabled. When the FIFO is
-- enabled and when the WrPtrIncValid signal is asserted, increment the Write 
-- pointer by 1.
--------------------------------------------------------------------------------
  p_WrPtrComb : process (iWrPtr, WrPtrIncValid, FEN)
  begin
    if (FEN = '0') then
      NextWrPtr <= (others => '0');
    elsif (WrPtrIncValid = '1') then
      NextWrPtr <= (unsigned(iWrPtr) + 1);
    else
      NextWrPtr <= iWrPtr;
    end if;
  end process p_WrPtrComb;

--------------------------------------------------------------------------------
-- Increment the read pointer when the FIFO is not already empty and when the
-- Shift register is loaded with the next transmit data byte.
--------------------------------------------------------------------------------
  RdPtrIncValid <= TXFNotEmpty and LoadShiftReg;

--------------------------------------------------------------------------------
-- Freeze the read pointer at zero when the FIFO is disabled. When the FIFO is 
-- enabled and the RdPtrIncValid signal is asserted, increment the Read pointer
-- by 1
--------------------------------------------------------------------------------
  p_RdPtrComb : process (iRdPtr, FEN, RdPtrIncValid)     
  begin
    if (FEN = '0') then
      NextRdPtr <= (others => '0');
    elsif (RdPtrIncValid = '1') then
      NextRdPtr <= (unsigned(iRdPtr) + 1);
    else
      NextRdPtr <= iRdPtr;
    end if;
  end process p_RdPtrComb;

--------------------------------------------------------------------------------
-- The 'Wrap' bit is used to keep track of the condition when the
-- write pointer has wrapped around from '1111' to '0000', but
-- the read pointer has not wrapped. This bit is used to calculate
-- the FIFOFillLevel. As with the pointers, 'Wrap' is kept
-- cleared when the FIFO is disabled.
--------------------------------------------------------------------------------
p_WrapComb : process (iWrPtr, iRdPtr, Wrap, FEN, RdPtrIncValid, WrPtrIncValid)
begin
  if (FEN = '0') then
    NextWrap <= '0';
  elsif (((iWrPtr = "1111") and (WrPtrIncValid = '1')) xor 
         ((iRdPtr = "1111") and (RdPtrIncValid = '1'))) then
    NextWrap <= not(Wrap);                    
  else
    NextWrap <= Wrap;                    
  end if;
end process p_WrapComb;

--------------------------------------------------------------------------------
-- The FIFOFull signal indicates the status of the FIFO when it is
-- enabled. When the FIFO is one less than full and there is
-- another write to the FIFO, the FIFOFull signal is set. When
-- the FIFO is already full and there is a read from the FIFO,
-- the FIFOFull signal is de-asserted
--------------------------------------------------------------------------------
p_FIFOFull : process (TXFFillLevel, FIFOFull, FEN, WrPtrIncValid, RdPtrIncValid)
begin
  if (FEN = '0') then
    NextFIFOFull <= '0';
  elsif ((TXFFillLevel = "01111") and (WrPtrIncValid = '1') and
         (RdPtrIncValid = '0')) then
    NextFIFOFull <= '1';
  elsif ((FIFOFull = '1') and (RdPtrIncValid = '1') and 
         (WrPtrIncValid = '0')) then
    NextFIFOFull <= '0';
  else
    NextFIFOFull <= FIFOFull;
  end if;
end process p_FIFOFull;

--------------------------------------------------------------------------------
-- The FIFONotEmpty signal indicates the status of the FIFO when it is
-- enabled. If the FIFO is empty and there is a write to the FIFO,
-- the FIFONotEmpty signal is asserted. If one location in the FIFO
-- is filled and there is a read from the FIFO, the FIFOEmpty
-- signal is asserted.
--------------------------------------------------------------------------------
p_FIFONotEmpty : process (TXFFillLevel, FIFONotEmpty, FEN, WrPtrIncValid, 
                          RdPtrIncValid)
begin
  if (FEN = '0') then
    NextFIFONotEmpty <= '0';
  elsif ((FIFONotEmpty = '0') and (WrPtrIncValid = '1')) then
    NextFIFONotEmpty <= '1';
  elsif ((TXFFillLevel = "00001") and (RdPtrIncValid = '1') and
         (WrPtrIncValid = '0')) then
    NextFIFONotEmpty <= '0';
  else
    NextFIFONotEmpty <= FIFONotEmpty;
  end if;
end process p_FIFONotEmpty;

--------------------------------------------------------------------------------
-- When the FIFO is disabled, have a single bit to indicate fill status
-- while the pointers are frozen at zero. The HldBufValid signal has a reset 
-- value of 0, toggles to 1 when there is a write and back to zero when there
-- is a read. The write and read requests can occur simultaneously. The two
-- cases to be considered are when HldBufValid is 1 and when it is 0. When a 
-- write and read occur simultaneously with a byte already in the holding 
-- buffer (HldBufValid = 1), the write is allowed and HldBufValid remains set
-- (untoggled). When HldBufValid is 0 (holding buffer empty), a read cannot 
-- occur because reads are from the Transmit section which reads data from the 
-- buffer only if valid data is available.
--------------------------------------------------------------------------------
p_BufValid : process (FEN, RdPtrIncValid, WrPtrIncValid, HldBufValid)
begin
  if (FEN = '1') then
    NextHldBufValid <= '0';
  elsif ((WrPtrIncValid = '1') xor (RdPtrIncValid = '1')) then
    NextHldBufValid <= not(HldBufValid);
  else
    NextHldBufValid <= HldBufValid;
  end if;
end process p_BufValid;

--------------------------------------------------------------------------------
-- Fill status of the transmit Shift register
-- NOTE : The assertion of this signal does not directly mean that
-- the shift register is empty. It only implies that the next write
-- to the transmit FIFO should fill up the shift register directly,
-- instead of accumulating in the FIFO
--------------------------------------------------------------------------------
p_ShiftRegEmpty : process (UARTEN, TXShiftRegEmpty, UARTDRWrEn,
                           LoadShiftReg, TXFNotEmpty)
begin
--------------------------------------------------------------------------------
-- If the UART is disabled, then writes should accumulate in the FIFO
-- without updating the transmit shift register
--------------------------------------------------------------------------------
  if ((UARTEN = '0') ) then
    NxtTXShiftRegEmpty <= '0';
--------------------------------------------------------------------------------
-- If the FIFO is already empty and the shift register has to be loaded with
-- transmit data and there is no write occuring to the FIFO, the 
-- TXShiftRegEmpty signal is set.
--------------------------------------------------------------------------------
  elsif ((LoadShiftReg = '1') and (TXFNotEmpty = '0') and
         (UARTDRWrEn = '0')) then
    NxtTXShiftRegEmpty <= '1';
--------------------------------------------------------------------------------
-- Else, if there is a write to the FIFO, the shift register is no 
-- longer empty
--------------------------------------------------------------------------------
  elsif (UARTDRWrEn = '1') then
    NxtTXShiftRegEmpty <= '0';
  else 
    NxtTXShiftRegEmpty <= TXShiftRegEmpty;
  end if;
end process p_ShiftRegEmpty;

--------------------------------------------------------------------------------
-- The TXShiftData register holds the transmit data byte.
--------------------------------------------------------------------------------
p_TXShiftData : process (iTXShiftData, TXFIFOData, UARTDRWrEn, TXShiftRegEmpty,
                         PWDATAIn, TXFNotEmpty, LoadShiftReg)
begin
--------------------------------------------------------------------------------
-- If the FIFO and the shift register are empty, then on the next write,
-- move the write data straight into the shift register.
-- If the TXShiftRegEmpty signal is already set or if the Shift register has to
-- be loaded with the next transmit byte with the transmit FIFO being empty,
-- and, if there is a write to the FIFO at the same time, the write data bus
-- contents are copied directly into the Shift register. 
--------------------------------------------------------------------------------
    if ((UARTDRWrEn = '1') and ((TXShiftRegEmpty = '1') or
        ((TXFNotEmpty = '0') and (LoadShiftReg = '1')))) then
      NextTXShiftData <= PWDATAIn;
--------------------------------------------------------------------------------
-- If the Shift register has to be loaded with the next transmit data byte and
-- the FIFO is not empty, then load the data in the FIFO pointed to by the
-- current value of the read pointer, into the shift register. 
--------------------------------------------------------------------------------
    elsif ((LoadShiftReg = '1') and (TXFNotEmpty = '1')) then
      NextTXShiftData <= TXFIFOData;
    else
      NextTXShiftData <= iTXShiftData;
    end if;
end process p_TXShiftData;

--------------------------------------------------------------------------------
-- The ShiftDataAvlbl signal indicates whether there is valid data present in 
-- the Transmit shift register. This signal is used to generate the TXDataAvlbl
-- output signal.
--------------------------------------------------------------------------------
p_ShiftDataAvlbl : process (ShiftDataAvlbl, LoadShiftReg, TXFNotEmpty,
                            UARTDRWrEn, TXShiftRegEmpty, UARTEN)
begin
  if ((UARTEN = '0') or ((LoadShiftReg = '1') and
      (TXFNotEmpty = '0') and (UARTDRWrEn = '0'))) then
    NextShftDatAvlbl <= '0';
  elsif (((LoadShiftReg = '1') and (TXFNotEmpty = '1')) or
        ((LoadShiftReg = '1') and (TXFNotEmpty = '0') and (UARTDRWrEn = '1')) or
        ((TXShiftRegEmpty = '1') and (UARTDRWrEn = '1'))) then
    NextShftDatAvlbl <= '1';
  else
    NextShftDatAvlbl <= ShiftDataAvlbl;
  end if;
end process p_ShiftDataAvlbl;

--------------------------------------------------------------------------------
-- Subtract the read pointer from the write pointer to calculate
-- the FIFO fill level. Use the Wrap bit to take into account
-- whether the write pointer has wrapped without the read pointer
-- not having wrapped
--------------------------------------------------------------------------------
    TXFFillLevel     <= (unsigned(Wrap & iWrPtr) - unsigned('0' & iRdPtr));
--------------------------------------------------------------------------------
-- When the FIFO is enabled, use the FIFOFull signal to indicate
-- FIFO fill status. When the FIFO is disabled, use the
-- HldBufValid signal to indicate FIFO fill status.
--------------------------------------------------------------------------------
iTXFF            <= FIFOFull     when (FEN = '1') 
                 else
                    HldBufValid ;
--------------------------------------------------------------------------------
-- When the FIFO is enabled, use the FIFONotEmpty signal to indicate
-- FIFO fill status. When the FIFO is disabled, use the
-- HldBufValid signal to indicate FIFO fill status.
--------------------------------------------------------------------------------
  TXFNotEmpty    <= FIFONotEmpty when (FEN = '1') 
                 else
                    HldBufValid; 
  TXFE           <= not TXFNotEmpty;
--------------------------------------------------------------------------------
-- When the FIFO is enabled, use the TXFFillLevel signal to
-- find whether the FIFO is less than or equal to half full. If the
-- FIFO is disabled, the HldBufValid signal will do the job.
--------------------------------------------------------------------------------
  FIFOLTEHalfFull <= '1'             when (unsigned(TXFFillLevel) <= 8)
                  else
                     '0';

  iTXFLTEHalfFull  <= FIFOLTEHalfFull when (FEN = '1') 
                  else
                     not HldBufValid;

end synth;

--========================== End of UartTrTXFCntl ==============================--











