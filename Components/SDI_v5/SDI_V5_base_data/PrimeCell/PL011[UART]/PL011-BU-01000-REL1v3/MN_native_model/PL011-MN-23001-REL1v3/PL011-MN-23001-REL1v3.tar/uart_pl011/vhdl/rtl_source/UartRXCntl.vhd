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
--  File Name              : UartRXCntl.vhd.rca
--  File Revision          : 1.17
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



entity UartRXCntl is
  port (
        UARTCLK         : in  std_logic;      -- Main UART Clock
        nUARTRST        : in  std_logic;      -- Muxed reset (from nUARTRST)
        
        Baud16          : in  std_logic;      -- Bit Period Reference
        UARTENSync      : in  std_logic;      -- UART Enable
        SIRENSync       : in  std_logic;      -- SIR Enable
        RXESync         : in  std_logic;      -- RXE Enable
        RXD             : in  std_logic;      -- Receive serial input
        
        WLEN            : in  std_logic_vector(1 downto 0);
                                                 -- Data bits per word
        STP2            : in  std_logic;      -- 2 stop bits
        PEN             : in  std_logic;      -- Parity enable
        Zerobaud        : in  std_logic;      -- Baud Divisor set to 0
        RXFWrDoneSync   : in  std_logic;      -- RX FIFO Write Done
        DtPrZero        : in  std_logic;      -- Data bits and Parity bit zero
        
        UARTFEICSync    : in  std_logic;      -- For Framing Error interrupt clear
        UARTBEICSync    : in  std_logic;      -- For Framing Error interrupt clear
        FEIMSync        : in  std_logic;      --  Framing Error interrupt mask
        BEIMSync        : in  std_logic;      --  Break Error Interrupt mask
        
        ShiftEn         : out std_logic;      -- Shift next bit
        SampleParity    : out std_logic;      -- Enable Parity sample
        RXEnable        : out std_logic;      -- Rx enable
        UartRXCntlState : out std_logic_vector(2 downto 0);
                                              -- Rx state
        
        RXDsampled      : out std_logic;      -- Sampled Rx data stream
        ClearShiftReg   : out std_logic;      -- Clear receive shifter
        RXFWr           : out std_logic;      -- Receive FIFO Write (level)
        ReloadWD        : out std_logic;      -- Restart watchdog counter
        FramingError    : out std_logic;      -- Framing error detected
        Break           : out std_logic;      -- Break detected
        RXBUSY          : out std_logic;      -- RX machine busy
        CharRxComp      : out std_logic;      -- Character Rx complete
        
        UARTFERIS       : out std_logic;      -- Framing Error Raw status
        UARTBERIS       : out std_logic;      -- Break Error Raw status
        UARTFEMIS       : out std_logic;      -- Framing Error Masked status
        UARTBEMIS       : out std_logic       -- Break Error Masked status
        );
end UartRXCntl;

architecture synth of UartRXCntl is
--  Encoding style: Gray
  signal iUartRXCntlState, UartRXCntlNextState : std_logic_vector(2 downto 0);
  signal NextSampleParity  : std_logic;
  signal NextRXFWr         : std_logic;
  signal NextShiftEn       : std_logic;
  signal NextReloadWD      : std_logic;
  signal NextClearShiftReg : std_logic;
  signal NextRXBUSY        : std_logic;
  signal NextUARTFERIS     : std_logic;
  signal NextUARTBERIS     : std_logic;
  signal iRXEnable         : std_logic;
  signal RXD1              : std_logic;
  signal RXD2              : std_logic;
  signal RXD3              : std_logic;
  signal iRXDsampled       : std_logic;
  signal DelFramingError   : std_logic;
  signal DelBreakError     : std_logic;
  signal FramingEdge       : std_logic;
  signal BreakEdge         : std_logic;
  signal DelUARTFEICSync   : std_logic;
  signal DelUARTBEICSync   : std_logic;
  signal UARTFEIClr        : std_logic;
  signal UARTBEIClr        : std_logic;
  signal iUARTFERIS        : std_logic;
  signal iUARTBERIS        : std_logic;

-- Aliases
  signal AbortReceive  : std_logic;
  signal BreakDetStop  : std_logic;
  signal BreakDetXStop : std_logic;

-- Registers
  signal BitPeriodCnt, NextBitPeriodCnt   : std_logic_vector(3 downto 0);
  signal BitCnt, NextBitCnt : std_logic_vector(2 downto 0);
  signal iBreak, NextiBreak : std_logic;
  signal iFramingError, NextiFramingError : std_logic;
  
  signal NextCharRxComp     : std_logic;
  signal iCharRxComp        : std_logic;

-- Comparators
  signal BitPeriodCmp : std_logic;
  signal BitCmp       : std_logic;
  signal FrmErrCmp    : std_logic;
  signal BreakErrCmp  : std_logic;
  
  -- Embedded VHDL declarations...
  ----------------------------------------------------------------------------
  --  Purpose            : This state machine is the main Receive state m/c.
  ----------------------------------------------------------------------------
  --
  ----------------------------------------------------------------------------
  --
  --                             UartRXCntl
  --                             =========
  --
  ----------------------------------------------------------------------------
  -- 
  -- Overview
  -- ========
  --
  -- The receive state machine controls the timing of sampling the input
  -- receive bit stream. It detects framing, parity errors. The parameters
  -- programmed into the LCR_H register are used to interpret the
  -- receive bit stream.
  ----------------------------------------------------------------------------    
  
begin

-- Expose internal register(s)...
  Break           <= iBreak;
  FramingError    <= iFramingError;
  UartRXCntlState <= iUartRXCntlState;
  RXEnable        <= iRXEnable;
  RXDsampled      <= iRXDsampled;
  UARTFERIS       <= iUARTFERIS;
  UARTBERIS       <= iUARTBERIS;
  CharRxComp      <= iCharRxComp;
  
-- Expansion of aliases...
  AbortReceive    <= Zerobaud;
  iRXEnable       <= (UARTENSync and RXESync);
  
  BreakDetStop    <= not(iRXDsampled) and DtPrZero;
  BreakDetXStop   <= not(iRXDsampled) and FrmErrCmp and DtPrZero;

-- Expansion of comparators...
  BitPeriodCmp    <= '1' when BitPeriodCnt(3 downto 0) = "0000" else '0';
  BitCmp          <= '1' when BitCnt(2 downto 0) = "000" else '0';
  FrmErrCmp       <= '1' when iFramingError = '1' else '0';
  BreakErrCmp     <= '1' when iBreak = '1' else '0';

-- State transition process
  seq : process(UARTCLK, nUARTRST)
  begin
    
    if ((not(nUARTRST)) = '1') then
      iUartRXCntlState <= "000";
      SampleParity     <= '0';
      RXFWr            <= '0';
      ShiftEn          <= '0';
      ReloadWD         <= '0';
      ClearShiftReg    <= '1';
      RXBUSY           <= '0';
      DelFramingError  <= '0';
      DelUARTFEICSync  <= '0';
      iUARTFERIS       <= '0';
      DelBreakError    <= '0';
      DelUARTBEICSync  <= '0';
      iUARTBERIS       <= '0';
      iCharRxComp      <= '1';
    elsif (UARTCLK'event and UARTCLK = '1') then
      iUartRXCntlState <= UartRXCntlNextState;
      SampleParity     <= NextSampleParity;
      RXFWr            <= NextRXFWr;
      ShiftEn          <= NextShiftEn;
      ReloadWD         <= NextReloadWD;
      ClearShiftReg    <= NextClearShiftReg;
      RXBUSY           <= NextRXBUSY;
      DelFramingError  <= iFramingError;
      DelUARTFEICSync  <= UARTFEICSync;
      iUARTFERIS       <= NextUARTFERIS;
      DelBreakError    <= iBreak;
      DelUARTBEICSync  <= UARTBEICSync;
      iUARTBERIS       <= NextUARTBERIS;
      iCharRxComp      <= NextCharRxComp;
    end if;
  end process seq;

  p_SampleRXD : process (nUARTRST, UARTCLK)
  begin
    if (nUARTRST = '0') then
      RXD1 <= '1';
      RXD2 <= '1';
      RXD3 <= '1';    
    elsif (UARTCLK'event and UARTCLK = '1') then
      if (Baud16 = '1') then
        RXD1 <= RXD;
        RXD2 <= RXD1;
        RXD3 <= RXD2;
      end if;
    end if;
  end process p_SampleRXD;  

  p_vote : process (RXD1, RXD2, RXD3)
  begin
    if (((RXD1 = '1') and (RXD2 = '1')) or ((RXD1 = '1') and (RXD3 = '1'))
        or ((RXD2 = '1') and (RXD3 = '1'))) then
      iRXDsampled <= '1';
    else
      iRXDsampled <= '0';
    end if;
  end process p_vote;
  
  
-- Output and next state logic generation
  combo : process(iUartRXCntlState,
                  PEN, STP2, Baud16, WLEN, RXFWrDoneSync,
                  AbortReceive, BreakDetStop,
                  BreakDetXStop, BitPeriodCnt, BitCnt, iBreak,
                  iFramingError, BitPeriodCmp, BitCmp, FrmErrCmp,
                  BreakErrCmp, iRXEnable, iRXDsampled, iCharRxComp, SIRENSync)
  begin 
    -- Default assignments
    UartRXCntlNextState <= iUartRXCntlState;
    NextSampleParity    <= '0';
    NextRXFWr           <= '0';
    NextShiftEn         <= '0';
    NextReloadWD        <= '0';
    NextClearShiftReg   <= '0';
    NextRXBUSY          <= '0';
    NextBitPeriodCnt    <= BitPeriodCnt;
    NextBitCnt          <= BitCnt;
    NextiBreak          <= iBreak;
    NextiFramingError   <= iFramingError;
    NextCharRxComp      <= iCharRxComp;
    case iUartRXCntlState is
      
      when "000" =>
        -- Detect RXD low. The BitPeriodCnt counter is reloaded with
        -- 8 for normal uart mode or 4 for IrDa mode. This ensures
        -- that the sampling takes place in the middle of the pulse.
        
        if ((not(iRXDsampled) and not(AbortReceive) and iRXEnable) = '1') then
          if (SIRENSync = '1') then
            NextBitPeriodCnt(3 downto 0) <= "0100";
          else
            NextBitPeriodCnt(3 downto 0) <= "1000";
          end if;
          UartRXCntlNextState          <= "001";
          NextRXBUSY                   <= '1';
          NextCharRxComp               <= '0';
        else
          NextClearShiftReg <= '1';
        end if;
        
      when "001" =>
        -- If at any time the RXD line goes HIGH, invalidate  the
        -- start bit .
        if (((Baud16 and iRXDsampled) or AbortReceive) = '1')
        then
          UartRXCntlNextState <= "000";
          NextClearShiftReg   <= '1';
          NextCharRxComp      <= '1';
          
          -- Valid start bit detected         
        elsif ((Baud16 and BitPeriodCmp and not(AbortReceive) and
                not(iRXDsampled)) = '1') then
          NextReloadWD           <= '1';
          NextBitPeriodCnt       <= "1111";
          NextBitCnt(2 downto 0) <= ('1' & WLEN(1 downto 0));
          UartRXCntlNextState    <= "011";
          NextRXBUSY             <= '1';
          NextCharRxComp         <= '0';


          -- Count down from 8 to 0 with Baud16 as the count enable
          -- to find the middle of the start bit
          
        elsif ((Baud16 and not(BitPeriodCmp) and not(AbortReceive)) = '1') then
          NextBitPeriodCnt    <= UNSIGNED(BitPeriodCnt) - 1;
          UartRXCntlNextState <= "001";
          NextRXBUSY          <= '1';
        else
          NextRXBUSY          <= '1';
        end if;
        
      when "011" =>
        -- Decrement BitPeriodCnt with Baud16 as the count enable        
        if ((Baud16 and not(BitPeriodCmp) and not(AbortReceive)) = '1') then
          NextBitPeriodCnt    <= UNSIGNED(BitPeriodCnt) - 1;
          UartRXCntlNextState <= "011";
          NextRXBUSY          <= '1';
          NextCharRxComp      <= '0';
          
          -- Shift in next bit          
        elsif ((Baud16 and BitPeriodCmp and not(BitCmp) and not(AbortReceive)) = '1') then
          NextShiftEn         <= '1';
          NextBitCnt          <= UNSIGNED(BitCnt) - 1;
          NextBitPeriodCnt    <= "1111";
          UartRXCntlNextState <= "011";
          NextRXBUSY          <= '1';
          NextCharRxComp      <= '0';
          
          -- Parity enabled          
        elsif ((Baud16 and BitCmp and BitPeriodCmp and PEN and not(AbortReceive)) = '1') then
          NextShiftEn <= '1';
          NextBitPeriodCnt <= "1111";
          UartRXCntlNextState <= "010";
          NextRXBUSY <= '1';
          NextCharRxComp      <= '0';
          
          -- Parity disabled          
        elsif ((Baud16 and BitCmp and BitPeriodCmp and not(PEN) and not(AbortReceive)) = '1') then
          NextShiftEn         <= '1';
          NextBitPeriodCnt    <= "1111";
          UartRXCntlNextState <= "101";
          NextRXBUSY          <= '1';
          NextCharRxComp      <= '0';
          
        elsif ((AbortReceive) = '1') then
          UartRXCntlNextState <= "000";
          NextClearShiftReg   <= '1';
          NextCharRxComp      <= '1';
        else
          NextRXBUSY          <= '1';
        end if;
        
      when "010" =>
        -- Decrement BitperiodCnt counter to reach the middle of the next bit
        
        if ((Baud16 and not(BitPeriodCmp) and not(AbortReceive)) = '1') then
          NextBitPeriodCnt    <= UNSIGNED(BitPeriodCnt) - 1;
          UartRXCntlNextState <= "010";
          NextRXBUSY          <= '1';
          NextCharRxComp      <= '0';
          
          -- Sample Parity bit          
        elsif ((Baud16 and BitPeriodCmp and not(AbortReceive)) = '1') then
          NextSampleParity    <= '1';
          NextBitPeriodCnt    <= "1111";
          UartRXCntlNextState <= "101";
          NextRXBUSY          <= '1';
          NextCharRxComp      <= '0';
          
        elsif ((AbortReceive) = '1') then
          UartRXCntlNextState <= "000";
          NextClearShiftReg   <= '1'; 
          NextCharRxComp      <= '1';
      else
          NextRXBUSY          <= '1';
        end if;
        
      when "110" =>
        -- Decrement BitPeriodCnt
        
        if ((Baud16 and not(BitPeriodCmp) and not(AbortReceive)) = '1') then
          NextBitPeriodCnt    <= UNSIGNED(BitPeriodCnt) - 1;
          UartRXCntlNextState <= "110";
          NextRXBUSY          <= '1';
          NextCharRxComp      <= '0';
          
        elsif ((AbortReceive) = '1') then
          UartRXCntlNextState <= "000";
          NextClearShiftReg   <= '1';
          
          -- Wait complete for additional stop bit time          
        elsif ((Baud16 and BitPeriodCmp and not(AbortReceive)) = '1') then
          NextReloadWD        <= '1';
          NextBitPeriodCnt    <= "1111";
          NextiBreak          <= BreakDetXStop;
          UartRXCntlNextState <= "111";
          NextRXFWr           <= '1';
          NextRXBUSY          <= '1';
          NextCharRxComp      <= '1';
        else
          NextRXBUSY          <= '1';
        end if;
        
      when "111" =>
        if ((not(BreakErrCmp) and RXFWrDoneSync and
             (not(FrmErrCmp) or iRXDsampled or AbortReceive)) = '1') then
          -- If the FIFOWrDone signal is asserted and if there was no framing error or
          -- Abort condition or if the RXD line went HIGH then wait for the next start bits
          NextiBreak          <= '0';
          NextiFramingError   <= '0';
          UartRXCntlNextState <= "000"; 
          NextClearShiftReg   <= '1';
          NextCharRxComp      <= '1';
          
        elsif ((Baud16 and not(BitPeriodCmp) and FrmErrCmp and not(AbortReceive)
                and not(iRXDsampled) and not(BreakErrCmp)) = '1') then
          -- If there was a framing error, then decrement the BitPeriodCnt
          -- counter to detect the middle of the next start bit
          NextBitPeriodCnt    <= UNSIGNED(BitPeriodCnt) - 1;
          UartRXCntlNextState <= "111";
          NextRXFWr           <= '1';   
          NextRXBUSY          <= '1';
          NextCharRxComp      <= '1';
          
        elsif ((RXFWrDoneSync and not(BreakErrCmp) and BitPeriodCmp
                and Baud16 and not(iRXDsampled) and not(AbortReceive) and
                FrmErrCmp and iRXEnable) = '1') then  
          -- Framing error detected in previous byte; next bit low - taken as start bit
          -- for next byte.
          NextReloadWD           <= '1';
          NextClearShiftReg      <= '1';
          NextBitPeriodCnt       <= "1111";
          NextBitCnt(2 downto 0) <= ('1' & WLEN(1 downto 0));
          NextiBreak             <= '0';
          NextiFramingError      <= '0';
          UartRXCntlNextState    <= "011";
          NextRXBUSY             <= '1';
          NextCharRxComp         <= '0';
        elsif ((BreakErrCmp and RXFWrDoneSync) = '1') then
          -- Break detected
          UartRXCntlNextState <= "100";
          NextRXBUSY          <= '1';
        else
          NextRXFWr  <= '1';
          NextRXBUSY <= '1';
        end if;
        
      when "101" =>
        -- 2 stop bits programmed
        
        if ((Baud16 and BitPeriodCmp and STP2 and not(AbortReceive)) = '1') then
          NextBitPeriodCnt    <= "1111";
          NextiFramingError   <= not(iRXDsampled);
          UartRXCntlNextState <= "110";
          NextRXBUSY          <= '1';
          NextCharRxComp      <= '0';
          
          -- Decrement BitPeriodCnt counter to reach the middle of the next bit          
        elsif ((Baud16 and not(BitPeriodCmp) and not(AbortReceive)) = '1') then
          NextBitPeriodCnt    <= UNSIGNED(BitPeriodCnt) - 1;
          UartRXCntlNextState <= "101"; 
          NextRXBUSY          <= '1';
          
        elsif ((AbortReceive) = '1') then
          UartRXCntlNextState <= "000";
          NextClearShiftReg   <= '1';
          
          -- Only one stop bit          
        elsif ((Baud16 and BitPeriodCmp and not(STP2) and not(AbortReceive)) = '1') then
          NextReloadWD        <= '1';
          NextBitPeriodCnt    <= "1111";
          NextiBreak          <= BreakDetStop;
          NextiFramingError   <= not(iRXDsampled);
          UartRXCntlNextState <= "111";
          NextRXFWr           <= '1';
          NextRXBUSY          <= '1';
          NextCharRxComp      <= '1';
        else
          NextRXBUSY          <= '1';
        end if;
        
      when "100" =>
        -- Break released; RXD line high again
        
        if ((iRXDsampled) = '1') then
          UartRXCntlNextState <= "000";
          NextClearShiftReg   <= '1';
          NextCharRxComp      <= '1';
        else
          NextRXBUSY          <= '1';
        end if;
      when others =>
        UartRXCntlNextState   <= "000";
    end case;
  end process combo;



  -------------------------------------------------------------------
  -- Detect rising edge in Framing Error and Break Error
  -------------------------------------------------------------------

  BreakEdge   <= iBreak and not(DelBreakError);
  FramingEdge <= iFramingError and not(DelFramingError);

  -------------------------------------------------------------------
  -- UARTFEIClr is a one UART-wide pulse used to clear the UARTFEINTR. 
  -- UARTBEIClr is a one UART-wide pulse used to clear the UARTBEINTR. 
  -------------------------------------------------------------------
  UARTFEIClr <= UARTFEICSync and not(DelUARTFEICSync);
  UARTBEIClr <= UARTBEICSync and not(DelUARTBEICSync);
  

  -------------------------------------------------------------------
  -- Generate a framing error interrupt when there is a rising edge
  -- on the framing error line. Clear the error when there is a write
  -- to bit 7 of the Interrupt clear register.
  -------------------------------------------------------------------

  p_UARTFEINTR : process (iUARTFERIS, FramingEdge, UARTFEIClr)
  begin
    NextUARTFERIS <= iUARTFERIS;
    if(FramingEdge = '1') then
      NextUARTFERIS <= '1';
    elsif (UARTFEIClr = '1') then
      NextUARTFERIS <= '0';
    end if;
  end process p_UARTFEINTR;  

  UARTFEMIS <= iUARTFERIS and FEIMSync;
  
  -------------------------------------------------------------------
  -- Generate a break error interrupt when there is a rising edge
  -- on the break error line. Clear the error when there is a write
  -- to bit 7 of the Interrupt clear register.
  -------------------------------------------------------------------

  p_UARTBEINTR : process (iUARTBERIS, BreakEdge, UARTBEIClr)
  begin
    NextUARTBERIS <= iUARTBERIS;
    if(BreakEdge = '1') then
      NextUARTBERIS <= '1';
    elsif (UARTBEIClr = '1') then
      NextUARTBERIS <= '0';
    end if;
  end process p_UARTBEINTR;  

  UARTBEMIS <= iUARTBERIS and BEIMSync;
  

  BitPeriodCnt_seq : process(UARTCLK, nUARTRST)
  begin
    
    if ((not(nUARTRST)) = '1') then
      BitPeriodCnt <= "0000";
    elsif (UARTCLK'event and UARTCLK = '1') then
      BitPeriodCnt <= NextBitPeriodCnt;
    end if;
  end process BitPeriodCnt_seq;

  BitCnt_seq : process(UARTCLK, nUARTRST)
  begin
    
    if ((not(nUARTRST)) = '1') then
      BitCnt <= "000";
    elsif (UARTCLK'event and UARTCLK = '1') then
      BitCnt <= NextBitCnt;
    end if;
  end process BitCnt_seq;

  iBreak_seq : process(UARTCLK, nUARTRST)
  begin
    
    if ((not(nUARTRST)) = '1') then
      iBreak <= '0';
    elsif (UARTCLK'event and UARTCLK = '1') then
      iBreak <= NextiBreak;
    end if;
  end process iBreak_seq;

  iFramingError_seq : process(UARTCLK, nUARTRST)
  begin
    
    if ((not(nUARTRST)) = '1') then
      iFramingError <= '0';
    elsif (UARTCLK'event and UARTCLK = '1') then
      iFramingError <= NextiFramingError;
    end if;
  end process iFramingError_seq;


end synth;
--  Signals: UartRXCntlState<2:0> UartRXCntlNextState<2:0> 
--    ST_IDLE        000
--    ST_STARTBIT    001
--    ST_SHIFT       011
--    ST_PARITY      010
--    ST_XSTOP       110
--    ST_FIFOWRITE   111
--    ST_STOPBIT     101
--    ST_BREAK       100
