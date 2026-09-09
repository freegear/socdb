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
--  File Name              : UartRXFCntl.vhd.rca
--  File Revision          : 1.13
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

entity UartRXFCntl is
  port (
        PCLK           : in  std_logic;      -- APB Clock
        PRESETn        : in  std_logic;      -- AMBA Bus reset
        
        RXFWrSync      : in  std_logic;	     -- RX FIFO Write Enable
        RXFRdPtrInc    : in  std_logic;	     -- RX FIFO Read Pointer Incr.
        FEN            : in  std_logic;	     -- FIFO Enable
        TESTFIFO       : in  std_logic;      --  Test signal
        RTSEn          : in  std_logic;      -- RTS flow control enable
        nUARTRTScr     : in  std_logic;      --  from UARTCR
        
        UARTECRWrEn    : in  std_logic;	     -- Overrun error Clear input 
        UARTTDRWrEn    : in  std_logic;	     -- TDR write enable
        RXIFLSEL       : in  std_logic_vector(2 downto 0);
                                             --  Selected interrupt level
        RXIM           : in  std_logic;      --  RX Interrupt Mask
        OEIM           : in  std_logic;      --  Overrun Error Interrupt Mask
        UARTRXIC       : in  std_logic;      -- For RX Interrupt clear
        UARTOEIC       : in  std_logic;      -- For Overrun errot Interrupt clear

        WrPtr          : out std_logic_vector(3 downto 0);
                                             -- Write Pointer
        RdPtr          : out std_logic_vector(3 downto 0);
                                             -- Read Pointer
        RXFE           : out std_logic;	     -- Receive FIFO Empty
        RXFF           : out std_logic;	     -- Receive FIFO Full
        RXFGTE1Full    : out std_logic;      -- To DMA block
        RXIntLevel     : out std_logic;      --  Programable Interrupt Level
        RegFileWrEn    : out std_logic;	     -- Write Enable to Register File
        RXFWrDone      : out std_logic;	     -- RX FIFO Write Done
        OverrunDet     : out std_logic;	     -- Overrun Detected
        FIFOOverrunDet : out std_logic;	     -- Overrun Detected
        nUARTRTSint    : out std_logic;      -- modem signal
        
        UARTRXIClr     : out std_logic;      -- RX Interrupt clear
        UARTOEIClr     : out std_logic;      -- Overrun Error Interrupt Clear
        UARTRXRIS      : out std_logic;      -- Receive Raw Interrupt
        UARTRXMIS      : out std_logic;	     -- Receive Masked Interrupt
        UARTOERIS      : out std_logic;      -- Overrun Error Raw Int status
        UARTOEMIS      : out std_logic       -- Overrun Error Masked Int status
        );
end UartRXFCntl;

--------------------------------------------------------------------------------
-- Purpose     : This block contains the control logic for the receive
--               FIFO
--------------------------------------------------------------------------------
--
--------------------------------------------------------------------------------
--
--                   UartRXFCntl
--                   ===========
--                                                      
--------------------------------------------------------------------------------
--
-- Overview
-- ========
-- The control logic for the receive FIFO uses two pointers - a write pointer 
-- and a read pointer. The pointers are 4 bits wide. The write pointer points 
-- to the location to which the next write data will be written into. The read 
-- pointer points to the next location whose contents will be read out. Both 
-- the pointers operate on PCLK so as to serve data consistently to APB 
-- accesses and to conveniently calculate the FIFO fill level by finding the 
-- difference between the pointers.
-- When the FIFO is disabled, the pointers do not change and the fill status 
-- of the holding buffer is indicated by a separate bit 'HldBufValid'. 
-- The overrun condition is met when the receive logic attempts to write into 
-- the FIFO  when the FIFO is already full (if the FIFO is enabled) or if the 
-- holding buffer is already full (if the FIFO is disabled). Once the overrun 
-- condition is met, further writes to the FIFO are ignored.  Two
-- separate overrun signals are generated OverrunDet(which is copied
-- into the status register) and FIFOOverrunDet(which is copied into
-- the RXFIFO).
-- When the UARTECRWrEn input is set, the overrun OverrunDet
-- condition is cleared,  the FIFOOverrunDet is cleared on the next
-- successful write to the RXFIFO.
-- The fifo can be set to be in TESTFIFO mode which allows data to
-- be written directly into the Rx fifo.
--
--=============================== ARCHITECTURE ===============================--
--
--------------------------------------------------------------------------------
-- Architecture Packages
--------------------------------------------------------------------------------

architecture synth of UartRXFCntl  is

--------------------------------------------------------------------------------
-- Component Declaration
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Internal Constants
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Internal Signals
--------------------------------------------------------------------------------

  signal iRdPtr             : std_logic_vector(3 downto 0);
  -- Internal version of Read pointer

  signal NextRdPtr          : std_logic_vector(3 downto 0);
  -- D-input for Read pointer vector

  signal RdPtrIncValid      : std_logic;
  -- Valid Read Pointer Increment condition detected

  signal iWrPtr             : std_logic_vector(3 downto 0);
  -- Internal version of Write pointer

  signal NextWrPtr          : std_logic_vector(3 downto 0);
  -- D-input for Write pointer vector

  signal WrPtrIncValid      : std_logic;
  -- Valid Write Pointer Increment condition detected

  signal Wrap               : std_logic;
  -- Store the condition when the write pointer has rolled over (from
  -- '1111' to '0000') but the read pointer hasn't. This signal is
  -- used in calculating the FIFOFillLevel 

  signal NextWrap           : std_logic;
  -- D-input of Wrap bit

  signal iRXFE              : std_logic;
  -- Local copy of Receive FIFO empty signal, readable through 
  -- UARTFR register 

  signal iRXFF              : std_logic;
  -- Local copy of Receive FIFO full signal,readable through UARTFR 
  -- register and to detect FIFO Overrun

  signal iOverrunDet        : std_logic;
  -- Local copy of OverrunDet signal, to denote Overrun detection
  
  signal iFIFOOverrunDet    : std_logic;
  -- Local copy of FIFOOverrunDet signal, to denote Overrun detection
  
  signal NextOverrunDet     : std_logic;
  -- D-input of iOverrunDet bit

  signal DelOverrunDet      : std_logic;
  -- Delayed version of OverrunDet bit

  signal NextFIFOOverrunDet : std_logic;
  -- D-input of iFIFOOverrunDet bit

  signal RXFGTEHalfFull     : std_logic;
  -- Receive FIFO Greater Than or Equal to Half Full
  
  signal RXFGTEQFull        : std_logic;
  -- Receive FIFO Greater Than or Equal to Quarter Full
  
  signal RXFGTE3QFull       : std_logic;
  -- Receive FIFO Greater Than or Equal to Three Quarters Full
  
  signal RXFGTE8Full        : std_logic;
  -- Receive FIFO Greater Than or Equal to One Eighth Full

  signal RXFGTE78Full       : std_logic;
  -- Receive FIFO Greater Than or Equal to Seven Eighth Full

  signal DelRXFWrSync       : std_logic;
  -- Delayed version of RXFWrSync - FIFO write enable signal
  -- Used to convert the level on the RXFWrEn signal to a one-clock
  -- wide pulse

  signal WrPtrLevel         : std_logic_vector(4 downto 0);
  -- Signal used to calculate the Rx Fifo fill level

  signal RdPtrLevel         : std_logic_vector(4 downto 0);
  -- Signal used to calculate the Rx Fifo fill level

  signal RXFFillLevel       : std_logic_vector(4 downto 0);
  -- Receive FIFO Fill level - can take values from 00000 to 10000

  signal HldBufValid        : std_logic;
  -- Fill status of the receive holding buffer when the FIFO is
  -- disabled

  signal DelHldBufValid     : std_logic;
  -- delayed version of HldBufValid

  signal NextHldBufValid    : std_logic;
  -- D-input of HldBufValid bit
  
  signal NextUARTRXRIS      : std_logic;
  -- D-input of UARTRXRIS 
  
  signal NextUARTOERIS      : std_logic;
  -- D-input of UARTOERIS 
  
  signal iUARTRXRIS         : std_logic;
  -- Internal version of UARTRXRIS 

  signal iUARTOERIS         : std_logic;
  -- Internal version of UARTOERIS 

  signal FIFOFull           : std_logic;
  -- Receive FIFO Full when the FIFO is enabled

  signal NextFIFOFull       : std_logic;
  -- D-input of FIFOFull bit

  signal FIFOEmpty          : std_logic;
  -- Receive FIFO empty when the FIFO is enabled

  signal NextFIFOEmpty      : std_logic;
  -- D-input of FIFOEmpty bit

  signal FIFOGTE8Full       : std_logic;
  -- FIFO Fill level compare result
  
  signal FIFOGTEHalfFull    : std_logic;
  -- FIFO Fill level compare result
  
  signal FIFOGTEQFull       : std_logic;
  -- FIFO Fill level compare result
  
  signal FIFOGTE3QFull      : std_logic;
  -- FIFO Fill level compare result
  
  signal FIFOGTE78Full      : std_logic;
  -- FIFO Fill level compare result
  
  signal iRXIntLevel        : std_logic;
  -- internal version of Programmable interrupt level

  signal NextRXIntLevel     : std_logic;
  -- D-input for Programmable interrupt level

  signal DelUARTRXIC        : std_logic;
  -- Delayed version of UARTRXIC signal

  signal DelUARTOEIC        : std_logic;
  -- Delayed version of UARTRXIC signal

  signal iUARTRXIClr        : std_logic;
  -- Internal version of UARTRXIClr

  signal DelRXIntLevel      : std_logic;
  -- Delayed version of RXIntLevel

  signal RXEdge             : std_logic;
  -- Detects edge in RXIntLevel
  
  signal HldBufValidEdge    : std_logic;
  -- Detects edge in HldBufValid
  
  signal OverrunEdge        : std_logic;
  -- Detects edge in Overrun
  
  signal iUARTOEIClr        : std_logic;
  -- Internal version of UARTOEIClr
  
  signal FIFOGTE1Full       : std_logic;
  -- FIFO Fill level compare result

  signal NextnUARTRTSint    : std_logic;
  -- D-input for nUARTRTSint

  signal inUARTRTSint       : std_logic;
  -- internal version of nUARTRTSint

-------------------------------------------------------------------------------
-- 
-- Main VHDL code
-- ==============
--
--------------------------------------------------------------------------------

begin

--------------------------------------------------------------------------------
-- Connect local copies of signals to ports
--------------------------------------------------------------------------------
  WrPtr          <= iWrPtr;
  RXFE           <= iRXFE;
  RXFF           <= iRXFF;
  RdPtr          <= iRdPtr;
  OverrunDet     <= iOverrunDet;
  FIFOOverrunDet <= iFIFOOverrunDet;
  UARTRXRIS      <= iUARTRXRIS;
  UARTRXIClr     <= iUARTRXIClr;
  UARTOERIS      <= iUARTOERIS;
  UARTOEIClr     <= iUARTOEIClr;
  RXIntLevel     <= iRXIntLevel;
  nUARTRTSint    <= inUARTRTSint;
--------------------------------------------------------------------------------
-- Generate a one-PCLK wide write enable pulse for the Register File on every
-- rising edge on the RXFWrSync signal or when in TESTFIFO mode and
-- there is a write to the fifo. Mask writes to the Register File if FIFO 
-- is full
--------------------------------------------------------------------------------
  RegFileWrEn    <= (((RXFWrSync and not(DelRXFWrSync)) or
                      (UARTTDRWrEn and TESTFIFO)) and not(iRXFF));

--------------------------------------------------------------------------------
-- Assert and De-assert RXFWrDone signal the next clock after RXFRdPtrInc
-- is asserted or de-asserted.
--------------------------------------------------------------------------------
  RXFWrDone      <= DelRXFWrSync;

--------------------------------------------------------------------------------
-- Sequential process to infer registers in this block
--------------------------------------------------------------------------------
  p_PtrsSeq : process (PCLK, PRESETn)
  begin
    if (PRESETn = '0') then
      iWrPtr          <= (others => '0');
      iRdPtr          <= (others => '0');
      Wrap            <= '0';
      HldBufValid     <= '0';
      iOverrunDet     <= '0';
      iFIFOOverrunDet <= '0';
      DelRXFWrSync    <= '0';
      iUARTRXRIS      <= '0';
      iUARTOERIS      <= '0';
      FIFOFull        <= '0';
      FIFOEmpty       <= '1';
      DelUARTRXIC     <= '0';
      DelUARTOEIC     <= '0';
      DelRXIntLevel   <= '0';
      DelHldBufValid  <= '0';
      DelOverrunDet   <= '0';
      inUARTRTSint    <= '1';
      iRXIntLevel     <= '0';
    elsif (PCLK'event and PCLK = '1') then
      iWrPtr          <= NextWrPtr;
      iRdPtr          <= NextRdPtr;
      Wrap            <= NextWrap;
      HldBufValid     <= NextHldBufValid;
      iOverrunDet     <= NextOverrunDet;
      iFIFOOverrunDet <= NextFIFOOverrunDet;       
      DelRXFWrSync    <= RXFWrSync;
      iUARTRXRIS      <= NextUARTRXRIS;
      iUARTOERIS      <= NextUARTOERIS;
      FIFOFull        <= NextFIFOFull;
      FIFOEmpty       <= NextFIFOEmpty;
      DelUARTRXIC     <= UARTRXIC;
      DelUARTOEIC     <= UARTOEIC;
      iRXIntLevel     <= NextRXIntLevel;
      DelRXIntLevel   <= iRXIntLevel;
      DelHldBufValid  <= HldBufValid;
      DelOverrunDet   <= iOverrunDet;
      inUARTRTSint    <= NextnUARTRTSint;
    end if;
  end process p_PtrsSeq;

--------------------------------------------------------------------------------
-- Increment the write pointer when there is a rising edge on RXFWrSync (FIFO 
-- write enable) signal. Don't allow write pointer to increment if the FIFO is 
-- already Full.
-- If the FIFO is full and there is a simultaneous write and read, the write 
-- pointer should be incremented.
-- In TESTFIFO mode the write pointer should be incremented when
-- there is a write to the test data register.
--------------------------------------------------------------------------------
  WrPtrIncValid <= (RXFWrSync and not(DelRXFWrSync) and 
                    (not(FIFOFull) or (FIFOFull and RXFRdPtrInc))) or
                   (UARTTDRWrEn and TESTFIFO); 

--------------------------------------------------------------------------------
-- Freeze the Write pointer at Zero when the FIFO is disabled. When the FIFO is
-- enabled and when the WrPtrIncValid signal is asserted, increment the Write
-- pointer by 1.
--------------------------------------------------------------------------------
  p_WrPtrComb : process (iWrPtr, FEN, WrPtrIncValid)
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
-- Increment the read pointer when there is a read from the APB interface. For 
-- safety, inhibit reads from having any effect if the FIFO is already empty. 
--------------------------------------------------------------------------------
  RdPtrIncValid <= RXFRdPtrInc and not(FIFOEmpty);

--------------------------------------------------------------------------------
-- Freeze the Read pointer at Zero when the FIFO is disabled. When the FIFO is
-- enabled and when the RdPtrIncValid signal is asserted, increment the Read
-- pointer by 1.
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
-- The 'Wrap' bit is used to keep track of the condition when the write pointer
-- has wrapped around from '1111' to '0000', but the read pointer has not 
-- wrapped. This bit is used to calculate the FIFOFillLevel. As with the 
-- pointers, the wrap is kept cleared when the FIFO is disabled. When both the 
-- pointers wrap around from '1111' to '0000' simultaneously, the Wrap bit 
-- remains unchanged.
--------------------------------------------------------------------------------
  p_WrapComb : process (iWrPtr, iRdPtr, Wrap, FEN, WrPtrIncValid, RdPtrIncValid)
  begin
    if (FEN = '0') then
      NextWrap <= '0';
    elsif (((iWrPtr = "1111") and (WrPtrIncValid = '1')) xor
           ((iRdPtr = "1111") and (RdPtrIncValid = '1'))) then
      NextWrap <= not (Wrap);
    else
      NextWrap <= Wrap;                    
    end if;
  end process p_WrapComb;

--------------------------------------------------------------------------------
-- The FIFOFull signal indicates the status of the FIFO when it is enabled. 
-- When the FIFO is one less than full and there is another write to the FIFO, 
-- the FIFOFull signal is set. When the FIFO is already full and there is a 
-- read from the FIFO without a simultaneous write, the FIFOFull signal is 
-- de-asserted
--------------------------------------------------------------------------------
  p_FIFOFull : process (FEN, RXFFillLevel, RXFWrSync, DelRXFWrSync, FIFOFull, 
                        RXFRdPtrInc, UARTTDRWrEn, TESTFIFO) 
  begin
    if (FEN = '0') then
      NextFIFOFull <= '0';
    elsif ((RXFFillLevel = "01111") and
           (((RXFWrSync = '1') and (DelRXFWrSync = '0')) or
            (UARTTDRWrEn = '1' and TESTFIFO = '1')) and (RXFRdPtrInc = '0')) then 
      NextFIFOFull <= '1';
    elsif ( (FIFOFull = '1') and (RXFRdPtrInc = '1') and 
            not((RXFWrSync = '1') and (DelRXFWrSync = '0'))) then
      NextFIFOFull <= '0';
    else
      NextFIFOFull <= FIFOFull;
    end if;
  end process p_FIFOFull;
  
--------------------------------------------------------------------------------
-- The FIFOEmpty signal indicates the status of the FIFO when it is enabled. If
-- the FIFO is empty and there is a write to the FIFO, the FIFOEmpty signal is 
-- deasserted. If one location in the FIFO is filled and there is a read from 
-- the FIFO, the FIFOEmpty signal is asserted.
--------------------------------------------------------------------------------
  p_FIFOEmpty : process (FEN, RXFFillLevel, RXFWrSync, DelRXFWrSync, FIFOEmpty,
                         RXFRdPtrInc,UARTTDRWrEn, TESTFIFO) 
  begin
    if (FEN = '0') then
      NextFIFOEmpty <= '1';
    elsif ((FIFOEmpty = '1') and
           (((RXFWrSync = '1') and (DelRXFWrSync = '0')) or
            (UARTTDRWrEn = '1' and TESTFIFO = '1'))) then 
      NextFIFOEmpty <= '0';
    elsif ((RXFFillLevel = "00001") and (RXFRdPtrInc = '1') and
           not (((RXFWrSync = '1') and (DelRXFWrSync = '0')) or
                (UARTTDRWrEn = '1' and TESTFIFO = '1'))) then 
      NextFIFOEmpty <= '1';
    else
      NextFIFOEmpty <= FIFOEmpty;
    end if;
  end process p_FIFOEmpty;

--------------------------------------------------------------------------------
-- When the FIFO is disabled, have a single bit to indicate fill status while 
-- the pointers are frozen at zero. Set the HldBufValid signal when a rising 
-- edge is detected on the RXFWrSync signal. Clear the HldBufValid signal when
-- there is a write and a simultaneous read.
--------------------------------------------------------------------------------
  p_BufValid : process (FEN, RXFWrSync, RXFRdPtrInc, HldBufValid, DelRXFWrSync)
  begin
    if (FEN = '1') then
      NextHldBufValid <= '0';
    elsif ((RXFWrSync = '1') and (DelRXFWrSync = '0')) then
      NextHldBufValid <= '1';
    elsif ((RXFRdPtrInc = '1') and 
           not((RXFWrSync = '1') and (DelRXFWrSync = '0'))) then
      NextHldBufValid <= '0';
    else
      NextHldBufValid <= HldBufValid;
    end if;
  end process p_BufValid;

--------------------------------------------------------------------------------
-- Overrun is set when the FIFO is full and there is another attempt to write 
-- and there is no simultaneous read from the FIFO. OverrunDet is cleared when 
-- there is a write to the UARTECR register and FIFOOverrunDet is
-- cleared on the next successful write to the RXFIFO.
--------------------------------------------------------------------------------
  p_Overrun : process (iRXFF, RXFWrSync, RXFRdPtrInc, iOverrunDet, iFIFOOverrunDet, 
                       DelRXFWrSync, UARTECRWrEn)
  begin
    if ((iRXFF = '1') and (RXFWrSync = '1') and (DelRXFWrSync = '0')
        and (RXFRdPtrInc = '0')) then
      NextOverrunDet     <= '1';
      NextFIFOOverrunDet <= '1';      
    elsif (UARTECRWrEn = '1') then
      NextOverrunDet     <= '0';
      NextFIFOOverrunDet <= iFIFOOverrunDet;   
    elsif (RXFWrSync = '1') and (DelRXFWrSync = '0') and (iRXFF = '0')
    then
      NextFIFOOverrunDet <= '0';
      NextOverrunDet     <= iOverrunDet;
    else
      NextOverrunDet     <= iOverrunDet;
      NextFIFOOverrunDet <= iFIFOOverrunDet;   
    end if;
  end process p_Overrun;


-------------------------------------------------------------------
-- Generate an Overrun Interrupt (UARTOEINTR) when there is a rising
-- edge on the OverrunDet line.  Clear the interrupt on a write to
-- bit 10 of the interrupt clear register, using the UARTOEIClr
-- signal.  The rising edge is detected using the OverrunEdge signal.
-------------------------------------------------------------------
  OverrunEdge <= iOverrunDet and not(DelOverrunDet);

  -------------------------------------------------------------------
  -- UARTOEIClr is a one PCLK-wide pulse used to clear the UARTOEINTR. 
  -------------------------------------------------------------------
  iUARTOEIClr <= UARTOEIC and not(DelUARTOEIC); 
  
  
  p_UARTOEINTR : process (iUARTOERIS, OverrunEdge, iUARTOEIClr)
  begin
    NextUARTOERIS   <= iUARTOERIS;
    if(OverrunEdge = '1') then
      NextUARTOERIS <= '1';
    elsif (iUARTOEIClr = '1') then
      NextUARTOERIS <= '0';
    end if;
  end process p_UARTOEINTR;  

  UARTOEMIS <= iUARTOERIS and OEIM;


---------------------------------------------------------------------
-- The interrupt fifo level is programmable, it can be either at the
-- one eighth, quarter, half, three quarter or seven eighth level.
---------------------------------------------------------------------

  p_RXIntLevel : process (iRXIntLevel,RXIFLSEL,RXFGTE8Full,RXFGTEQFull,
                          RXFGTEHalfFull, RXFGTE3QFull,RXFGTE78Full)
  begin
    NextRXIntLevel     <= iRXIntLevel;
    case RXIFLSEL is
      when "000"  =>
        NextRXIntLevel <= RXFGTE8Full;
      when "001"  =>
        NextRXIntLevel <= RXFGTEQFull;
      when "010"  =>
        NextRXIntLevel <= RXFGTEHalfFull;
      when "011"  =>
        NextRXIntLevel <= RXFGTE3QFull;
      when "100"  =>
        NextRXIntLevel <= RXFGTE78Full;
      when others => 
        NextRXIntLevel <= '0';
    end case;        
  end process p_RXIntLevel;

  
  -------------------------------------------------------------------
  -- UARTRXIClr is a one PCLK-wide pulse used to clear the UARTRXINTR. 
  -------------------------------------------------------------------

  iUARTRXIClr <= UARTRXIC and not(DelUARTRXIC);


  ---------------------------------------------------------------------
  -- Detect an edge in the interrupt level line and HldBufValid line.
  ---------------------------------------------------------------------

  RXEdge          <= iRXIntLevel xor DelRXIntLevel;
  HldBufValidEdge <= HldBufValid xor DelHldBufValid;
  

--------------------------------------------------------------------------------
-- The UARTRXINTR receive interrupt is set if one of the following conditions 
-- is met :
-- * FIFO enabled and FIFO filled to the programmed level
-- * FIFO disabled and the holding register is full
-- The interrupt is cleared when either the contents of the Receive FIFO are read
-- out such that there are the programmed level or more valid entries in
-- the FIFO, or when bit 4 of the Interrupt Clear register is written
-- to.
--------------------------------------------------------------------------------
  p_UARTRXINTR : process (FEN, iRXIntLevel, HldBufValid, HldBufValidEdge, RXEdge,
                          iUARTRXIClr, iUARTRXRIS)
  begin
    NextUARTRXRIS   <= iUARTRXRIS;
    if (((FEN = '1') and (iRXIntLevel = '1') and (RXEdge = '1')) or 
        ((FEN = '0') and (HldBufValid = '1') and
         (HldBufValidEdge = '1'))) then
      NextUARTRXRIS <= '1';
    elsif(((FEN = '1') and (iRXIntLevel = '0') and (RXEdge = '1')) or 
          ((FEN = '0') and (HldBufValid = '0') and
           (HldBufValidEdge = '1'))) then
      NextUARTRXRIS <= '0';
    elsif (iUARTRXIClr = '1') then
      NextUARTRXRIS <= '0';
    end if;
  end process p_UARTRXINTR;

  UARTRXMIS <= iUARTRXRIS and RXIM;

  --------------------------------------------------------------------
  -- The multiplexor determines the assignment of nUARTRTSint.  When RTS
  -- flow control is enabled nUARTRTSint is asserted, (logic 0), when there
  -- is space in the fifo indicated by RXIntLevel,
  -- otherwise nUARTRTSint takes the value of bit 11 in the UARTCR.
  -------------------------------------------------------------------- 

  p_nUARTRTSint : process (inUARTRTSint, RTSEn, iRXIntLevel, nUARTRTScr)
  begin
    NextnUARTRTSint   <= inUARTRTSint;
    if ((RTSEn = '1') and (iRXIntLevel = '0')) then
      NextnUARTRTSint <= '0';
    elsif((RTSEn = '1') and (iRXIntLevel = '1')) then
      NextnUARTRTSint <= '1';
    elsif (RTSEn = '0') then
      NextnUARTRTSint <= nUARTRTScr;
    end if;
  end process p_nUARTRTSint;
  

  
--------------------------------------------------------------------------------
-- Subtract the read pointer from the write pointer to calculate the FIFO fill 
-- level. Use the Wrap bit to take into account whether the write pointer has 
-- wrapped without the read pointer not having wrapped.
--------------------------------------------------------------------------------
   WrPtrLevel     <= (Wrap & iWrPtr);
   RdPtrLevel     <= ('0' & iRdPtr);

   RXFFillLevel   <= (UNSIGNED(WrPtrLevel) - UNSIGNED(RdPtrLevel));
  
--------------------------------------------------------------------------------
-- When the FIFO is enabled, use the FIFOFull signal to indicate FIFO fill 
-- status. When the FIFO is disabled, use the HldBufValid signal to indicate 
-- FIFO fill status.
--------------------------------------------------------------------------------
  iRXFF          <= FIFOFull when (FEN = '1') 
                    else
                    HldBufValid ;

--------------------------------------------------------------------------------
-- When the FIFO is enabled, use the FIFOEmpty signal to indicate FIFO fill 
-- status. When the FIFO is disabled, use the HldBufValid signal to indicate 
-- FIFO fill status.
--------------------------------------------------------------------------------
  iRXFE          <= FIFOEmpty when (FEN = '1') 
                    else
                    not(HldBufValid); 

--------------------------------------------------------------------------------
-- When the FIFO is enabled, use the RXFFillLevel signal to find whether the 
-- FIFO is greater than or equal to an eighth, quarter, half, three
-- quarters or seven eighth full. If the FIFO is disabled, the 
-- HldBufValid signal will indicate whether the FIFO is filled. 
--------------------------------------------------------------------------------
  FIFOGTE8Full    <= '1' when (UNSIGNED(RXFFillLevel) >= 2)
                     else
                     '0';

  RXFGTE8Full     <=  FIFOGTE8Full when (FEN = '1') 
                      else
                      HldBufValid;


  FIFOGTEQFull    <= '1' when (UNSIGNED(RXFFillLevel) >= 4)
                     else
                     '0';

  RXFGTEQFull     <=  FIFOGTEQFull when (FEN = '1') 
                      else
                      HldBufValid;

  FIFOGTEHalfFull <= '1' when (UNSIGNED(RXFFillLevel) >= 8)
                     else
                     '0';

  RXFGTEHalfFull  <=  FIFOGTEHalfFull when (FEN = '1') 
                      else
                      HldBufValid;

  
  FIFOGTE3QFull   <= '1' when (UNSIGNED(RXFFillLevel) >= 12)
                     else
                     '0';

  RXFGTE3QFull    <=  FIFOGTE3QFull when (FEN = '1') 
                      else
                      HldBufValid;

  FIFOGTE78Full   <= '1' when (UNSIGNED(RXFFillLevel) >= 14)
                     else
                     '0';

  RXFGTE78Full    <=  FIFOGTE78Full when (FEN = '1') 
                      else
                      HldBufValid;

---------------------------------------------------------------------
-- When the FIFO is enabled, use the RXFFillLevel signal to find
-- whether the Receive FIFO contains at least one word. If the
-- FIFO is disabled, the HldBufValid signal will do the job. When the
-- receive FIFO contains at least one word the RXFGTE1Full
-- signal is asserted.
---------------------------------------------------------------------

  FIFOGTE1Full    <= '1' when (UNSIGNED(RXFFillLevel) >= 1)
                     else
                     '0';

  RXFGTE1Full     <=  FIFOGTE1Full when (FEN = '1') 
                      else
                      HldBufValid;

  
end synth;

--========================== End of UartRXFCntl ==============================--























