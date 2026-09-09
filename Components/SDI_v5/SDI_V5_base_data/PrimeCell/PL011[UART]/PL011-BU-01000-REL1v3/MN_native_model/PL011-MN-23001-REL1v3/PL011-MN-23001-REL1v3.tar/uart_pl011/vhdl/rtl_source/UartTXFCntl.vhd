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
--  File Name              : UartTXFCntl.vhd.rca
--  File Revision          : 1.18
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


entity UartTXFCntl is
  port (
        PCLK            : in  std_logic;      -- APB Clock
        PRESETn         : in  std_logic;      -- AMBA Bus reset
        
        TXFRdPtrIncSync : in  std_logic;      -- TX FIFO Rd Ptr Inc
        FEN             : in  std_logic;      -- FIFO Enable
        UARTEN          : in  std_logic;      -- UART Enable
        TXE             : in  std_logic;      -- TX Enable         
        TESTFIFO        : in  std_logic;      -- Test signal
        AbortSync       : in  std_logic;      -- Transmission aborted
        BRK             : in  std_logic;      -- BRK requested
        CharTxCompSync  : in  std_logic;      -- Character Tx complete
        
        UARTDRWrEn      : in  std_logic;      -- TX FIFO Write enable
        iTXFIFOData     : in  std_logic_vector(7 downto 0);
                                              -- To Shft Reg
        PWDATAIn        : in  std_logic_vector(7 downto 0);
                                              -- Data bus.
        TXIFLSEL        : in  std_logic_vector(2 downto 0);
                                              --  Selected interrupt level
        TestTXFInc      : in  std_logic;      -- read pointer inc for Tx fifo
        TXIM            : in  std_logic;      --  TX Interrupt Mask
        UARTTXIC        : in  std_logic;      -- For TX Interrupt clear
        TXBUSYSync      : in  std_logic;      -- Transmitter busy
        
        WrPtr           : out std_logic_vector(3 downto 0);
                                              -- Write pointer
        RdPtr           : out std_logic_vector(3 downto 0);
                                              -- Read pointer
        TXFF            : out std_logic;      -- Transmit FIFO Full
        TXFE            : out std_logic;      -- Transmit FIFO Empty
        BUSY            : out std_logic;      -- UART BUSY
        TXDataAvlbl     : out std_logic;      -- TX Data Available
        RegFileWrEn     : out std_logic;      -- Register file write enable
        TXShiftData     : out std_logic_vector(7 downto 0);
                                              -- Xmit Data
        TXFLTE15Full    : out std_logic;      -- To DMA block
        TXIntLevel      : out std_logic;      --  Programmable Interrupt Level
        RdPtrIncDone    : out std_logic;      -- Rd Ptr Inc done
        
        UARTTXIClr      : out std_logic;      --  TX Interrupt clear
        UARTTXRIS       : out std_logic;      -- Transmit Raw Interrupt
        UARTTXMIS       : out std_logic	      -- Transmit Masked Interrupt
        );
end UartTXFCntl;


--------------------------------------------------------------------------------
-- Purpose     : This block contains the control logic for the transmit
--               FIFO
--------------------------------------------------------------------------------
--
--------------------------------------------------------------------------------
--
--                   UartTXFCntl
--                   ===========
--
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
--
--------------------------------------------------------------------------------
-- Architecture Packages
--------------------------------------------------------------------------------

architecture synth of UartTXFCntl  is

--------------------------------------------------------------------------------
-- Component Declaration
--------------------------------------------------------------------------------
  
--------------------------------------------------------------------------------
-- Internal Constants
--------------------------------------------------------------------------------
  
--------------------------------------------------------------------------------
-- Internal Signals
--------------------------------------------------------------------------------

  signal iRdPtr              : std_logic_vector(3 downto 0);
  -- Internal version of Read pointer

  signal NextRdPtr           : std_logic_vector(3 downto 0);
  -- D-input of Read pointer vector

  signal RdPtrIncValid       : std_logic;
  -- Valid Read pointer increment 

  signal iWrPtr              : std_logic_vector(3 downto 0);
  -- Internal version of Write Pointer

  signal NextWrPtr           : std_logic_vector(3 downto 0);
  -- D-input of the write pointer vector

  signal WrPtrIncValid       : std_logic;
  -- Valid Write pointer increment 

  signal DelRdPtrInc         : std_logic;
  -- Delayed version of TXFRdPtrIncSync - FIFO read pointer increment signal
  -- Used to convert the level on the TXFRdPtrIncSync signal to a one-clock
  -- wide pulse

  signal Wrap                : std_logic;
  -- Store the condition when the write pointer has rolled over (from
  -- '1111' to '0000') but the read pointer hasn't. This signal is
  -- used in calculating the FIFOFillLevel 

  signal NextWrap            : std_logic;
  -- D-input of Wrap bit

  signal TXFNotE         : std_logic;
  -- Signal used to indicate whether any data is available in the FIFO
  -- when the FIFO is enabled

  signal iTXFF               : std_logic;
  -- Local copy of the output signal TXFF which indicates whether the
  -- FIFO is full, readable through UARTFG register

  signal iTXFE               : std_logic;
  -- Local copy of the output signal TXFE which indicates whether the
  -- FIFO is empty, readable through UARTFR register

  signal TXFLTE8Full         : std_logic;
  -- Signal to indicate if the transmit FIFO is less than or equal to 
  -- an eighth full. Used to generate the transmit interrupt UARTTXINTR
  
  signal TXFLTEHalfFull      : std_logic;
  -- Signal to indicate if the transmit FIFO is less than or equal to 
  -- half full. Used to generate the transmit interrupt UARTTXINTR

  signal TXFLTEQFull         : std_logic;
  -- Signal to indicate if the transmit FIFO is less than or equal to 
  -- a quarter full. Used to generate the transmit interrupt UARTTXINTR
  
  signal TXFLTE3QFull        : std_logic;
  -- Signal to indicate if the transmit FIFO is less than or equal to 
  -- three quarters full. Used to generate the transmit interrupt UARTTXINTR

  signal TXFLTE78Full        : std_logic;
  -- Signal to indicate if the transmit FIFO is less than or equal to 
  -- seven eighth full. Used to generate the transmit interrupt UARTTXINTR
  
  signal WrPtrLevel          : std_logic_vector(4 downto 0);
  -- Signal used to calculate the Tx Fifo fill level

  signal RdPtrLevel          : std_logic_vector(4 downto 0);
  -- Signal used to calculate the Tx Fifo fill level

  signal TXFFillLevel        : std_logic_vector(4 downto 0);
  -- FIFO Fill level indication

  signal HldBufValid         : std_logic;
  -- Fill status of the holding register. Used in the case when the
  -- FIFO is disabled
  
  signal DelHldBufValid      : std_logic;
  -- delayed version of HldBufValid

  signal NextHldBufValid     : std_logic;
  -- D-input of HldBufValid bit

  signal iTXShiftData        : std_logic_vector(7 downto 0);
  -- Local copy of the transmit shift register output. Data driven on
  -- this output is used by the transmitter block as transmit data

  signal NextTXShiftData     : std_logic_vector(7 downto 0);
  -- D-input of iTXShiftData vector

  signal TXShiftRegE1        : std_logic;
  -- Fill status of the transmit Shift register
  -- NOTE : The assertion of this signal does not directly mean that the shift 
  -- register is empty. It only implies that the next write to the transmit 
  -- FIFO should fill up the shift register directly instead of accumulating 
  -- in the FIFO

  signal NxtTXShiftRegE  : std_logic;
  -- D-input of TXShiftRegE1 bit 
  
  signal TXShiftRegEDel  : std_logic;
  -- Delayed version of TXShiftRegE
  
  signal TXShiftRegEFE : std_logic;
  -- Is there a falling edge on the TXShiftRegE?
  
  signal NextUARTTXRIS       : std_logic;
  -- D-input of UARTTXRIS 
  
  signal iUARTTXRIS          : std_logic;
  -- Internal version of UARTTXRIS 
  

  signal DelUARTEN           : std_logic;
  -- Delayed version of the UARTEN signal. Used to detect a rising edge on this
  -- signal

  signal DelTXE              : std_logic;
  -- Delayed version of the TXE signal. Used to detect a rising edge on this
  -- signal

  signal FIFOFull            : std_logic;
  -- FIFO full status indication when the FIFO is enabled

  signal NextFIFOFull        : std_logic;
  -- D-input of FIFOFull bit

  signal FIFONotE        : std_logic;
  -- FIFO empty status indication when the FIFO is enabled
  
  signal NextFIFONotE    : std_logic;
  -- D-input of FIFONotE bit

  signal iTXDataAvlbl        : std_logic;
  -- Internal copy of TXDataAvlbl output signal.

  signal DelAbort            : std_logic;
  -- Delayed version of Abort input signal

  signal LoadShiftReg        : std_logic;
  -- Shift register load trigger

  signal ShiftDataAvlbl      : std_logic;
  -- Shift register contains valid data that is currently being transmitted
  
  signal NextShftDatAvlbl    : std_logic;
  -- D-input of ShftDataAvlbl signal

  signal FIFOLTE8Full        : std_logic;
  -- FIFO Fill level compare result
  
  signal FIFOLTEHalfFull     : std_logic;
  -- FIFO FillLevel compare result
  
  signal FIFOLTEQFull        : std_logic;
  -- FIFO Fill level compare result
  
  signal FIFOLTE3QFull       : std_logic;
  -- FIFO Fill level compare result
  
  signal FIFOLTE78Full       : std_logic;
  -- FIFO Fill level compare result
  
  signal iTXIntLevel         : std_logic;
  -- Internal version of Programmable interrupt level

  signal NextTXIntLevel      : std_logic;
  -- D-input for Programmable interrupt level
  
  signal iRdPtrIncDone       : std_logic;
  -- Internal copy of RdPtrIncDone signal

  signal DelUARTTXIC         : std_logic;
  -- Delayed version of UARTTXIC signal

  signal iUARTTXIClr         : std_logic;
  -- Internal version of UARTTXIClr

  signal DelTXIntLevel       : std_logic;
  -- Delayed version of TxIntLevel

  signal TXEdge              : std_logic;
  -- Detects edge in TXIntLevel

  signal HldBufValidEdge     : std_logic;
  -- Detects edge in HldBufValid

  signal FIFOLTE15Full       : std_logic;
  -- FIFO Fill level compare result
  
  signal Enabled             : std_logic;
  -- Is the UART Enabled?
  
  signal TXShiftRegE         : std_logic;
  -- TXShiftRegE1 masked by the enable signals

  signal CharTxCompDel       : std_logic;
  -- Delayed version of CharTxCompSync signal

  signal DelFEN              : std_logic;
  -- Delayed version of FEN

  signal FlushFifo           : std_logic;
  -- Used for Flush the data from the shift register data buffer

--------------------------------------------------------------------------------
--
-- Main VHDL code
-- ==============
--
--------------------------------------------------------------------------------

begin

--------------------------------------------------------------------------------
-- FlushFifo signal is used for flusing the data from the shift-regieter buffer.
-- Software has to disable the UART to flush the FIFO.
--------------------------------------------------------------------------------
FlushFifo   <= not(UARTEN) and not(FEN) and (DelFEN);

--------------------------------------------------------------------------------
-- Connect local copies of signals to ports
--------------------------------------------------------------------------------
  WrPtr        <= iWrPtr;
  TXShiftData  <= iTXShiftData;
  TXFF         <= iTXFF;
  TXFE         <= iTXFE;
  RdPtr        <= iRdPtr;
  TXDataAvlbl  <= iTXDataAvlbl;
  RdPtrIncDone <= iRdPtrIncDone;
  UARTTXRIS    <= iUARTTXRIS;
  UARTTXIClr   <= iUARTTXIClr;
  TXIntLevel   <= iTXIntLevel;
  
--------------------------------------------------------------------------------
-- Indicate the availability of data to transmit to  the transmit logic. Data 
-- is said to be available if the FIFO contains valid data or if the Shift
-- Register contains valid data. 
--------------------------------------------------------------------------------
  iTXDataAvlbl <= TXFNotE or ShiftDataAvlbl;

--------------------------------------------------------------------------------
-- The UART is BUSY when there is valid data available in the Transmit FIFO or
-- when the Transmitter is busy transmitting.
--------------------------------------------------------------------------------
  BUSY <= iTXDataAvlbl or TXBUSYSync;

--------------------------------------------------------------------------------
-- Ignore writes to FIFO if FIFO is already full. Use WrPtrIncValid signal 
-- as the Write enable. The Write pointer increment operation occurs only if
-- the FIFO is enabled, but the WrPtrIncValid signal is generated independent 
-- of whether the FIFO is enabled or not.
--------------------------------------------------------------------------------
  RegFileWrEn   <= WrPtrIncValid;

--------------------------------------------------------------------------------
-- Assert and De-assert Done signal the next clock after TXFRdPtrIncSync
-- is seen
--------------------------------------------------------------------------------
  iRdPtrIncDone <= DelRdPtrInc;
 
-----------------------------------------------------------------------------
--   Generate enabled signal for UARTEN and TXE
-----------------------------------------------------------------------------
   Enabled <= UARTEN and TXE;


--------------------------------------------------------------------------------
-- Sequential process for registers/flip-flops in this block
--------------------------------------------------------------------------------
  p_PtrsSeq : process (PCLK, PRESETn)
  begin
    if (PRESETn = '0') then
      iWrPtr             <= (others => '0');
      iRdPtr             <= (others => '0');
      DelRdPtrInc        <= '0';
      Wrap               <= '0';
      HldBufValid        <= '0';
      iTXShiftData       <= (others => '0');
      TXShiftRegE1       <= '1';
      TXShiftRegEDel     <= '1';
      iUARTTXRIS         <= '0';
      DelUARTEN          <= '0';
      DelTXE             <= '1';    
      FIFOFull           <= '0';
      FIFONotE           <= '0';
      DelAbort           <= '0';
      ShiftDataAvlbl     <= '0';
      iTXIntLevel        <= '0';
      DelUARTTXIC        <= '0';
      DelTXIntLevel      <= '0';
      DelHldBufValid     <= '0';
      CharTxCompDel      <= '0';
      DelFEN             <= '0';
    elsif (PCLK'event and PCLK = '1') then
      iWrPtr             <= NextWrPtr;
      iRdPtr             <= NextRdPtr;
      DelRdPtrInc        <= TXFRdPtrIncSync;
      Wrap               <= NextWrap;
      HldBufValid        <= NextHldBufValid;
      iTXShiftData       <= NextTXShiftData;
      TXShiftRegE1       <= NxtTXShiftRegE;
      TXShiftRegEDel     <= TXShiftRegE;
      iUARTTXRIS         <= NextUARTTXRIS;
      DelUARTEN          <= UARTEN;
      DelTXE             <= TXE;      
      FIFOFull           <= NextFIFOFull;
      FIFONotE           <= NextFIFONotE;
      DelAbort           <= AbortSync;
      ShiftDataAvlbl     <= NextShftDatAvlbl;
      iTXIntLevel        <= NextTXIntLevel;
      DelUARTTXIC        <= UARTTXIC;
      DelTXIntLevel      <= iTXIntLevel;
      DelHldBufValid     <= HldBufValid;
      CharTxCompDel      <= CharTxCompSync;
      DelFEN             <= FEN;
    end if;
  end process p_PtrsSeq;

--------------------------------------------------------------------------------
-- Load the shift register with transmit data from the FIFO when either of the 
-- following conditions occur:
-- * The UART is just enabled, and there is no Abort condition
-- * The Abort condition is just removed and the UART is already enabled
-- * The Read pointer increment signal (TXFRdPtrIncSync) signal is just
--   asserted with the UART being enabled and there being no Abort condition.
-- Add BRK, to prevent action when break is about to be asserted.
-- -----------------------------------------------------------------------------

-- Load ShiftReg if previous abort didn't overlap a stop bit
-- and shift reg data has been read, or on normal enabled read pointer
-- increment request
--------------------------------------------------------------------------------
  LoadShiftReg <= (Enabled) and not(AbortSync) and not(BRK) and
                  ((((DelAbort) or (not(DelUARTEN)) or (not(DelTXE)))
                    and (not(ShiftDataAvlbl))) or 
                   (TXFRdPtrIncSync and not(DelRdPtrInc)));

--------------------------------------------------------------------------------
-- Increment the write pointer when there is a write to the FIFO from the APB. 
-- The increment should be avoided if the transmit FIFO is already full or if 
-- the TXShiftRegE signal is asserted indicating that the next write should
-- go to the shift register directly. If TXShiftRegE is not already 
-- asserted and if it is about to be asserted on the next PCLK (as indicated
-- by the assertion of LoadShiftReg with the FIFO being empty), then the write
-- data is to be written into the Shift register and not into the FIFO. 
--------------------------------------------------------------------------------
  WrPtrIncValid <= UARTDRWrEn and (not(TXShiftRegE or (not(TXShiftRegE)
                    and LoadShiftReg and not(TXFNotE)))) and
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
      NextWrPtr <= (UNSIGNED(iWrPtr) + 1);
    else
      NextWrPtr <= iWrPtr;
    end if;
  end process p_WrPtrComb;

--------------------------------------------------------------------------------
-- Increment the read pointer when the FIFO is not already empty and either the
-- Shift register is loaded with the next transmit data byte or if
-- the fifo is in testmode and there is a read from the fifo.
--------------------------------------------------------------------------------
  RdPtrIncValid <= (TXFNotE and (LoadShiftReg or (TestTXFInc and TESTFIFO)));

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
      NextRdPtr <= (UNSIGNED(iRdPtr) + 1);
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
  p_FIFOFull : process (TXFFillLevel, FIFOFull, FEN, WrPtrIncValid,
                        RdPtrIncValid) 
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
-- The FIFONotE signal indicates the status of the FIFO when it is
-- enabled. If the FIFO is empty and there is a write to the FIFO,
-- the FIFONotE signal is asserted. If one location in the FIFO
-- is filled and there is a read from the FIFO, the FIFOEmpty
-- signal is asserted.
--------------------------------------------------------------------------------
  p_FIFONotE : process (TXFFillLevel, FIFONotE, FEN, WrPtrIncValid, 
                            RdPtrIncValid)
  begin
    if (FEN = '0') then
      NextFIFONotE <= '0';
    elsif ((FIFONotE = '0') and (WrPtrIncValid = '1')) then
      NextFIFONotE <= '1';
    elsif ((TXFFillLevel = "00001") and (RdPtrIncValid = '1') and
           (WrPtrIncValid = '0')) then
      NextFIFONotE <= '0';
    else
      NextFIFONotE <= FIFONotE;
    end if;
  end process p_FIFONotE;

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
  p_ShiftRegE1 : process (TXShiftRegE1, UARTDRWrEn,
                             LoadShiftReg, TXFNotE)
  begin
---------------------------------------------------------------------------------
-- If the FIFO is already empty and the shift register has to be loaded with
-- transmit data and there is no write occuring to the FIFO, the 
-- TXShiftRegE signal is set.
--------------------------------------------------------------------------------
    if ((LoadShiftReg = '1') and (TXFNotE = '0') and
           (UARTDRWrEn = '0')) then
      NxtTXShiftRegE <= '1';
      
--------------------------------------------------------------------------------
-- Else, if there is a write to the FIFO, the shift register is no 
-- longer empty
--------------------------------------------------------------------------------
    elsif (UARTDRWrEn = '1') then
      NxtTXShiftRegE <= '0';
    else 
      NxtTXShiftRegE <= TXShiftRegE1;
    end if;
  end process p_ShiftRegE1;

-- -----------------------------------------------------------------------------
-- If the UART is disabled, then writes should accumulate in the FIFO
-- without updating the transmit shift register
-- -----------------------------------------------------------------------------
  TXShiftRegE <= TXShiftRegE1 and (DelUARTEN) and 
                      not(DelAbort) and (DelTXE);

-- TXShiftRegE Fallingedges are only signalled when the UART is enabled.
  TXShiftRegEFE <= (Enabled) and not(TXShiftRegE) and
                       (TXShiftRegEDel);

--------------------------------------------------------------------------------
-- The TXShiftData register holds the transmit data byte.
--------------------------------------------------------------------------------
  p_TXShiftData : process (iTXShiftData, iTXFIFOData, UARTDRWrEn, TXShiftRegE,
                           PWDATAIn, TXFNotE, LoadShiftReg)
  begin
--------------------------------------------------------------------------------
-- If the FIFO and the shift register are empty, then on the next write,
-- move the write data straight into the shift register.
-- If the TXShiftRegE signal is already set or if the Shift register has to
-- be loaded with the next transmit byte with the transmit FIFO being empty,
-- and, if there is a write to the FIFO at the same time, the write data bus
-- contents are copied directly into the Shift register. 
--------------------------------------------------------------------------------
    if ((UARTDRWrEn = '1') and ((TXShiftRegE = '1') or
                          ((TXFNotE = '0') and (LoadShiftReg = '1')))) then
      NextTXShiftData <= PWDATAIn;
      
--------------------------------------------------------------------------------
-- If the Shift register has to be loaded with the next transmit data byte and
-- the FIFO is not empty, then load the data in the FIFO pointed to by the
-- current value of the read pointer, into the shift register. 
--------------------------------------------------------------------------------
    elsif ((LoadShiftReg = '1') and (TXFNotE = '1')) then
      NextTXShiftData <= iTXFIFOData;
    else
      NextTXShiftData <= iTXShiftData;
    end if;
  end process p_TXShiftData;

--------------------------------------------------------------------------------
-- The ShiftDataAvlbl signal indicates whether there is valid data present in 
-- the Transmit shift register. This signal is used to generate the TXDataAvlbl
-- output signal.
--------------------------------------------------------------------------------
  p_ShiftDataAvlbl : process (ShiftDataAvlbl, LoadShiftReg, TXFNotE,
                              UARTDRWrEn, TXShiftRegE, Enabled, BRK,
                              TXE, CharTxCompSync, CharTxCompDel, FlushFifo)
  begin
    if (FlushFifo = '1') then
      NextShftDatAvlbl <= '0';

    elsif (((Enabled = '0') or (BRK = '1')) and
           ((CharTxCompSync = '1') and (CharTxCompDel = '0'))) then
      NextShftDatAvlbl <= '0';   

    elsif ((TXFNotE = '0') and (UARTDRWrEn = '0')) then
      -- Fifo Empty, and no write to it but data read out
      if (LoadShiftReg = '1') then
        NextShftDatAvlbl <= '0';
      else
        NextShftDatAvlbl <= ShiftDataAvlbl;
      end if;

    elsif (((LoadShiftReg = '1') and (TXFNotE = '1') and (TXE = '1')) or
           ((LoadShiftReg = '1') and (TXFNotE = '0') and (TXE = '1')
            and (UARTDRWrEn = '1')) or
           ((TXShiftRegE = '1') and (UARTDRWrEn = '1') and (TXE = '1'))) then
      NextShftDatAvlbl <= '1';
    else
      NextShftDatAvlbl <= ShiftDataAvlbl;
    end if;
  end process p_ShiftDataAvlbl;

---------------------------------------------------------------------
-- The interrupt fifo level is programmable, it can be either at the
-- one eighth, quarter, half, three quarter or seven eighth level.
---------------------------------------------------------------------

  p_TXIntLevel : process (iTXIntLevel,TXIFLSEL,TXFLTE8Full,TXFLTEQFull,
                          TXFLTEHalfFull,TXFLTE3QFull,TXFLTE78Full)
  begin
    NextTXIntLevel     <= iTXIntLevel;

    case TXIFLSEL is
      when "000" =>
        NextTXIntLevel <= TXFLTE8Full;
      when "001" =>
        NextTXIntLevel <= TXFLTEQFull;
      when "010" =>
        NextTXIntLevel <= TXFLTEHalfFull;
      when "011" =>
        NextTXIntLevel <= TXFLTE3QFull;
      when "100" =>
        NextTXIntLevel <= TXFLTE78Full;
      when others => 
        NextTXIntLevel <= '0';
    end case;        
  end process p_TXIntLevel;

-------------------------------------------------------------------
-- UARTTXIClr is a one PCLK-wide pulse used to clear the UARTTXINTR. 
-------------------------------------------------------------------
  iUARTTXIClr <= UARTTXIC and not(DelUARTTXIC);


---------------------------------------------------------------------
-- Detect an edge in the interrupt level line and HldBufValid line.
---------------------------------------------------------------------
  TXEdge <= iTXIntLevel xor DelTXIntLevel;
  HldBufValidEdge <= HldBufValid xor DelHldBufValid;
  
--------------------------------------------------------------------------------
-- Assert the transmit interrupt when either of the following
-- conditions are met :
-- * The FIFO is enabled and is emptied such that its fill level 
--   is equal to or below its programmed level 
-- * The FIFO is disabled and the holding register is empty  
-- The transmit interrupt is de-asserted when the condition which
-- led to its assertion is no longer met.  It can also be cleared by
-- a write to bit 5 of the Interrupt Clear register.
--------------------------------------------------------------------------------
  p_UARTTXINTR : process (FEN, iTXIntLevel, HldBufValid, HldBufValidEdge, TXEdge,
                          iUARTTXIClr, iUARTTXRIS, 
                          TXShiftRegEFE)
  begin
    NextUARTTXRIS   <= iUARTTXRIS;
    if ((FEN = '1') and (iTXIntLevel = '1') and (TXEdge = '1')) then
      NextUARTTXRIS <= '1';
    elsif ((FEN = '0') and (HldBufValid = '0') and (HldBufValidEdge = '1')) then
      NextUARTTXRIS <= '1';
    elsif (((FEN = '0') and (HldBufValid = '0') and (iUARTTXRIS = '0') and 
            (TXShiftRegEFE = '1'))) then
      NextUARTTXRIS <= '1';
    elsif(((FEN = '1') and (iTXIntLevel = '0') and (TXEdge = '1')) or 
          ((FEN = '0') and (HldBufValid = '1') and (HldBufValidEdge = '1'))) then
      NextUARTTXRIS <= '0';    
    elsif (iUARTTXIClr = '1') then
      NextUARTTXRIS <= '0';
    end if;
  end process p_UARTTXINTR;

  UARTTXMIS <= iUARTTXRIS and TXIM;

--------------------------------------------------------------------------------
-- Subtract the read pointer from the write pointer to calculate
-- the FIFO fill level. Use the Wrap bit to take into account
-- whether the write pointer has wrapped without the read pointer
-- not having wrapped
--------------------------------------------------------------------------------
  WrPtrLevel     <= (Wrap & iWrPtr);
  RdPtrLevel     <= ('0' & iRdPtr);
 
  TXFFillLevel    <= (UNSIGNED(WrPtrLevel) - UNSIGNED(RdPtrLevel));

--------------------------------------------------------------------------------
-- When the FIFO is enabled, use the FIFOFull signal to indicate
-- FIFO fill status. When the FIFO is disabled, use the
-- HldBufValid signal to indicate FIFO fill status.
--------------------------------------------------------------------------------
  iTXFF           <= FIFOFull when (FEN = '1') 
                     else
                     HldBufValid ;
  
--------------------------------------------------------------------------------
-- When the FIFO is enabled, use the FIFONotE signal to indicate
-- FIFO fill status. When the FIFO is disabled, use the
-- HldBufValid signal to indicate FIFO fill status.
--------------------------------------------------------------------------------
  TXFNotE     <= FIFONotE when (FEN = '1') 
                     else
                     HldBufValid; 
  iTXFE           <= not TXFNotE;
  
--------------------------------------------------------------------------------
-- When the FIFO is enabled, use the TXFFillLevel signal to
-- find whether the FIFO is less than or equal to an eighth full, quarter full,
-- half full, three quarters full or seven eighth full. If the 
-- FIFO is disabled, the HldBufValid signal will do the job.
--------------------------------------------------------------------------------
  FIFOLTE8Full    <= '1'  when (UNSIGNED(TXFFillLevel) <= 2)
                     else
                     '0';

  TXFLTE8Full     <= FIFOLTE8Full when (FEN = '1') 
                     else
                     not HldBufValid;
  
  FIFOLTEQFull    <= '1' when (UNSIGNED(TXFFillLevel) <= 4)
                     else
                     '0';

  TXFLTEQFull     <=  FIFOLTEQFull when (FEN = '1') 
                      else
                      not HldBufValid;
  
  FIFOLTEHalfFull <= '1'  when (UNSIGNED(TXFFillLevel) <= 8)
                     else
                     '0';

  TXFLTEHalfFull  <= FIFOLTEHalfFull when (FEN = '1') 
                     else
                     not HldBufValid;


  FIFOLTE3QFull   <= '1' when (UNSIGNED(TXFFillLevel) <= 12)
                     else
                     '0';

  TXFLTE3QFull    <=  FIFOLTE3QFull when (FEN = '1') 
                      else
                      not  HldBufValid;

  FIFOLTE78Full   <= '1' when (UNSIGNED(TXFFillLevel) <= 14)
                     else
                     '0';

  TXFLTE78Full    <=  FIFOLTE78Full when (FEN = '1') 
                      else
                      not HldBufValid;

---------------------------------------------------------------------
-- When the FIFO is enabled, use the TXFFillLevel signal to find
-- whether the Transmit FIFO has at least one empty location. If the
-- FIFO is disabled, the HldBufValid signal will do the job. When the
-- transmit FIFO has at least one empty location the TXFLE15Full
-- signal is asserted.
---------------------------------------------------------------------
  FIFOLTE15Full <= '1' when (UNSIGNED(TXFFillLevel) <= 15)
                   else
                   '0';

  TXFLTE15Full  <=  FIFOLTE15Full when (FEN = '1') 
                    else
                    not HldBufValid;

end synth;

--========================== End of UartTXFCntl ==============================--











