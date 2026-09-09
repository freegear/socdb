--============================================================================----  This confidential and proprietary software may be used only as
--  authorised by a licensing agreement from ARM Limited
--    (C) COPYRIGHT 1998-2000 ARM Limited
--        ALL RIGHTS RESERVED
--  The entire notice above must be reproduced on all authorised
--  copies and copies may only be made to the extent permitted
--  by a licensing agreement from ARM Limited.
--  ----------------------------------------------------------------------------
--  
--  Version and Release Control Information:
--  
--  File Name              : UartTrRXFCntl.vhd.rca
--  File Revision          : 1.4
--  
--  Release Information    : PrimeCell(TM)-PL011-REL1v3
--  
--------------------------------------------------------------------------------
-- Purpose     : This block contains the control logic for the receive
--               FIFO
--============================================================================--
 
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

--------------------------------------------------------------------------------

entity UartTrRXFCntl is
  port (
        PCLK        : in std_logic;	-- APB Clock
        PRESETn     : in std_logic;	-- AMBA Reset
        RXFWr       : in std_logic;	-- RX FIFO Write Enable
        UTCR        : in std_logic_vector(1 downto 0); -- Trickbox Control Reg
        IrdaRXFWr   : in std_logic;     -- Irda RX FIFO Write Enable
        RXFRdPtrInc : in std_logic;	-- RX FIFO Read Pointer Incr.
        FEN         : in std_logic;	-- FIFO Enable
        RegFileWrEn : out std_logic;	-- Write Enable to Register File
        RXFWrDone   : out std_logic;	-- RX FIFO Write Done
        WrPtr       : out std_logic_vector(3 downto 0);	-- Write Pointer
        RdPtr       : out std_logic_vector(3 downto 0);	-- Read Pointer
        RXFE        : out std_logic;	-- Receive FIFO Empty
        RXHF        : out std_logic;    -- RX FIFO more than half full
        RXFF        : out std_logic  	-- Receive FIFO Full
    );
end UartTrRXFCntl;

--------------------------------------------------------------------------------
--
--                   UartTrRXFCntl
--                   ===========
--                                                      
--------------------------------------------------------------------------------
--
-- Overview
-- ========
--  The control logic for the receive FIFO uses two pointers - a write pointer 
-- and a read pointer. The pointers are 4 bits wide. The write pointer points 
-- to the location to which the next write data will be written into. The read 
-- pointer points to the next location whose contents will be read out. Both 
-- the pointers operate on PCLK so as to serve data consistently to APB 
-- accesses and to conveniently calculate the FIFO fill level by finding the 
-- difference between the pointers.
--  When the FIFO is disabled, the pointers do not change and the fill status 
-- of the holding buffer is indicated by a separate bit 'HldBufValid'. 
--  The overrun condition is met when the receive logic attempts to write into 
-- the FIFO  when the FIFO is already full (if the FIFO is enabled) or if the 
-- holding buffer is already full (if the FIFO is disabled). Once the overrun 
-- condition is met, further writes to the FIFO are ignored.
--  When the UARTECRWrEn input is set, the overrun condition is cleared. 
--
--=============================== ARCHITECTURE ===============================--

architecture synth of UartTrRXFCntl  is

--------------------------------------------------------------------------------
-- Component declarations
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Constant declarations
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Signal declarations
--------------------------------------------------------------------------------

  signal iRdPtr           : std_logic_vector(3 downto 0);
  -- Internal version of Read pointer

  signal NextRdPtr        : std_logic_vector(3 downto 0);
  -- D-input for Read pointer vector
  
  signal RdPtrIncValid    : std_logic;
  -- Valid Read Pointer Increment condition detected

  signal iWrPtr           : std_logic_vector(3 downto 0);
  -- Internal version of Write pointer

  signal NextWrPtr        : std_logic_vector(3 downto 0);
  -- D-input for Write pointer vector

  signal WrPtrIncValid    : std_logic;
  -- Valid Write Pointer Increment condition detected

  signal NextDelRXFWrSync : std_logic;

  signal Wrap             : std_logic;
  -- Store the condition when the write pointer has rolled over (from
  -- '1111' to '0000') but the read pointer hasn't. This signal is
  -- used in calculating the FIFOFillLevel 

  signal NextWrap         : std_logic;
  -- D-input of Wrap bit

  signal iRXFE            : std_logic;
  -- Local copy of Receive FIFO empty signal, readable through 
  -- UARTFR register 

  signal iRXFF            : std_logic;
  -- Local copy of Receive FIFO full signal,readable through UARTFR 
  -- register and to detect FIFO Overrun

  signal DelRXFF          : std_logic;
  -- Delayed version of RXFF 

  signal RXFGTEHalfFull   : std_logic;
  -- Receive FIFO Greater Than or Equal to Half Full

  signal DelRXFWrSync     : std_logic;
  -- Delayed version of RXFWrSync - FIFO write enable signal
  -- Used to convert the level on the RXFWrEn signal to a one-clock
  -- wide pulse

  signal RXFFillLevel     : std_logic_vector(4 downto 0);
  -- Receive FIFO Fill level - can take values from 00000 to 10000

  signal HldBufValid      : std_logic;
  -- Fill status of the receive holding buffer when the FIFO is
  -- disabled

  signal NextHldBufValid  : std_logic;
  -- D-input of HldBufValid bit

  signal FIFOFull         : std_logic;
  -- Receive FIFO Full when the FIFO is enabled

  signal NextFIFOFull     : std_logic;
  -- D-input of FIFOFull bit

  signal FIFOEmpty        : std_logic;
  -- Receive FIFO empty when the FIFO is enabled

  signal NextFIFOEmpty    : std_logic;
  -- D-input of FIFOEmpty bit

  signal FIFOGTEHalfFull  : std_logic;
  -- FIFO Fill level compare result

  signal RXFWrSync        : std_logic;
  -- Multiplexed Uart and Irda RXFWr input
--------------------------------------------------------------------------------
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

--------------------------------------------------------------------------------
-- Generate a one-PCLK wide write enable pulse for the Register File on every
-- rising edge on the RXFWrSync signal. Mask writes to the Register File if FIFO
-- is full
--------------------------------------------------------------------------------
  RegFileWrEn <= (RXFWrSync and not(DelRXFWrSync) and not(DelRXFF));

--------------------------------------------------------------------------------
-- Assert and De-assert RXFWrDone signal the next clock after RXFRdPtrInc
-- is asserted or de-asserted.
--------------------------------------------------------------------------------
  RXFWrDone   <= DelRXFWrSync;

--------------------------------------------------------------------------------
-- Sequential process to infer registers in this block
--------------------------------------------------------------------------------
  p_PtrsSeq : process (PCLK, PRESETn)
  begin
    if (PRESETn = '0') then
      iWrPtr        <= (others => '0');
      iRdPtr        <= (others => '0');
      Wrap          <= '0';
      HldBufValid   <= '0';
      DelRXFWrSync  <= '0';
      FIFOFull      <= '0';
      FIFOEmpty     <= '1';
      DelRXFF       <= '0'; 
    elsif (PCLK'event and PCLK = '1') then
      iWrPtr        <= NextWrPtr;
      iRdPtr        <= NextRdPtr;
      Wrap          <= NextWrap;
      HldBufValid   <= NextHldBufValid;
      DelRXFWrSync  <= RXFWrSync;
      DelRXFF       <= iRXFF;
      FIFOFull      <= NextFIFOFull;
      FIFOEmpty     <= NextFIFOEmpty;
    end if;
  end process p_PtrsSeq;

--------------------------------------------------------------------------------
-- Combinational process to multiplex RX FIFO Frame Write signals  
--------------------------------------------------------------------------------
p_modeComb : process(UTCR,IrdaRXFWr,RXFWr)
begin
 
  if(UTCR(0) = '1')then
    if(UTCR(1) = '1') then
      RXFWrSync <= IrdaRXFWr;
    else
      RXFWrSync <= RXFWr;
    end if;
  end if;
end process p_modeComb;

--------------------------------------------------------------------------------
-- Increment the write pointer when there is a rising edge on RXFWrSync (FIFO 
-- write enable) signal. Don't allow write pointer to increment if the FIFO is 
-- already Full.
-- If the FIFO is full and there is a simultaneous write and read, the write 
-- pointer should be incremented.
--------------------------------------------------------------------------------
  WrPtrIncValid <= RXFWrSync and not(DelRXFWrSync) and 
                   (not(FIFOFull) or (FIFOFull and RXFRdPtrInc));

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
      NextWrPtr <= (unsigned(iWrPtr) + 1);
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
      NextRdPtr <= (unsigned(iRdPtr) + 1);
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
                        RXFRdPtrInc) 
  begin
    if (FEN = '0') then
      NextFIFOFull <= '0';
    elsif ((RXFFillLevel = "01111") and (RXFWrSync = '1') 
            and (DelRXFWrSync = '0') and (RXFRdPtrInc = '0')) then
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
                         RXFRdPtrInc) 
  begin
    if (FEN = '0') then
      NextFIFOEmpty <= '1';
    elsif ((FIFOEmpty = '1') and (RXFWrSync = '1') and 
            (DelRXFWrSync = '0')) then
      NextFIFOEmpty <= '0';
    elsif ((RXFFillLevel = "00001") and (RXFRdPtrInc = '1') and
            not ((RXFWrSync = '1') and (DelRXFWrSync = '0'))) then
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
-- Subtract the read pointer from the write pointer to calculate the FIFO fill 
-- level. Use the Wrap bit to take into account whether the write pointer has 
-- wrapped without the read pointer not having wrapped.
--------------------------------------------------------------------------------
  RXFFillLevel   <= (unsigned(Wrap & iWrPtr) - unsigned('0' & iRdPtr));
                                                        
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
-- FIFO is greater than or equal to half full. If the FIFO is disabled, the 
-- HldBufValid signal will indicate whether the FIFO is filled. 
--------------------------------------------------------------------------------
  FIFOGTEHalfFull <= '1' when (unsigned(RXFFillLevel) >= 8)
                  else
                     '0';

  RXFGTEHalfFull  <=  FIFOGTEHalfFull when (FEN = '1') 
                  else
                     HldBufValid;

   RXHF <= RXFGTEHalfFull;
end synth;

--========================== End of UartTrRXFCntl ==============================--























