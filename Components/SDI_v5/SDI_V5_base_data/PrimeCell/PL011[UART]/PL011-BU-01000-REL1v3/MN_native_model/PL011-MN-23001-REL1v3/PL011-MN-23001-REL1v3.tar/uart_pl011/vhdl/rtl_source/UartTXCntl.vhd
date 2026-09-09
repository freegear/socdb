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
--  File Name              : UartTXCntl.vhd.rca
--  File Revision          : 1.16
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



entity UartTXCntl is
  port (
        UARTCLK          : in  std_logic;      -- Main UART Clock
        nUARTRST         : in  std_logic;      -- Muxed reset (from nUARTRST)
        
        RXEnable         : in  std_logic;      -- Rx Enable
        UartRXCntlState  : in  std_logic_vector(2 downto 0);
                                               -- RX state
        CTSEn            : in  std_logic;      -- CTS flow control enable
        
        nCTSSyncUARTCLK  : in  std_logic;      -- modem signal
        Baud16           : in  std_logic;      -- Bit Period ref
        TXDataAvlblSync  : in  std_logic;      -- TX Data Available
        RdPtrIncDoneSync : in  std_logic;      -- TX FIFO Rd pointer Inc done
        UARTENSync       : in  std_logic;      -- UART Enable
        TXESync          : in  std_logic;      -- TX Enable
        
        TXShiftData      : in  std_logic_vector(7 downto 0);
	                                       -- TX Data
        WLEN             : in  std_logic_vector(1 downto 0);
	                                       -- Bits per word
        STP2             : in  std_logic;      -- 2 stop bits
        PEN              : in  std_logic;      -- Parity enabled
        EPS              : in  std_logic;      -- Even Parity Select
        BRK              : in  std_logic;      -- Transmit Break 
        Zerobaud         : in  std_logic;      -- Baud divisor set to 0
        SPS              : in  std_logic;      -- Stick Parity Select bit
        
        TXFRdPtrInc      : out std_logic;      -- TX FIFO Rd Ptr Inc
        TXD              : out std_logic;      -- Internal Transmit line
        TXBUSY           : out std_logic;      -- Transmitter busy
        StopBaudCnt      : out std_logic;      -- Stop Baud Counter
        CharTxComp       : out std_logic      -- Character Tx complete
        );
end UartTXCntl;

architecture synth of UartTXCntl is
--  Encoding style: Gray
  signal UartTXCntlState, UartTXCntlNext : std_logic_vector(3 downto 0);
  signal NextTXFRdPtrInc : std_logic;
  signal NextTXBUSY      : std_logic;

-- Aliases
  signal AbortTransmit   : std_logic;
  signal TXEnable        : std_logic;
  signal nBreak          : std_logic;
  signal LEN5            : std_logic;
  signal LEN6            : std_logic;
  signal LEN7            : std_logic;
  signal LEN8            : std_logic;
  signal Parity          : std_logic;

-- Registers
  signal TXDReg, NextTXDReg     : std_logic;
  signal BitCount, NextBitCount : std_logic_vector(2 downto 0);
  signal BitPeriodCnt, NextBitPeriodCnt  : std_logic_vector(3 downto 0);
  signal TXShiftReg, NextTXShiftReg      : std_logic_vector(6 downto 0);

  signal NextCharTxComp         : std_logic;
  signal iCharTxComp            : std_logic;
  
-- Comparators
  signal BitCountComp           : std_logic;
  signal BitPeriodCmp           : std_logic;

  signal iStopBaudCnt           : std_logic;
  
  -- Embedded VHDL declarations...
  ----------------------------------------------------------------------------
  --  Purpose            : This state machine is the main TX state machine.
  ----------------------------------------------------------------------------
  --
  ----------------------------------------------------------------------------
  --
  --                             UartTXCntl
  --                             =========
  --
  ----------------------------------------------------------------------------
  -- 
  -- Overview
  -- ========
  --
  --  The transmit state machine shifts out transmit data according to the
  -- parameters programmed in the LCR_H register. When a Break is to be 
  -- transmitted, the transmit line is pulled LOW. The duration for which
  -- the TXD line remains low is directly dependent on the duration for
  -- which the Break bit is set. After break bit is set to 1, the TX line 
  -- is pulled high and for 1 bit time, data transmission is stopped 
  -- to avoid potential glitches in the SIROUT line.  If the Uart is
  -- disabled during transmision the current word will be transmitted and
  -- then transmission will stop.
  ----------------------------------------------------------------------------
  
begin

-- Expose internal register(s)...
  TXD         <= TXDReg;
  CharTxComp  <= iCharTxComp;
  
-- Expansion of aliases...
  AbortTransmit <=  BRK or Zerobaud;
  TXEnable      <= (UARTENSync and TXESync);
  nBreak        <= not(BRK);
  LEN5          <= not(WLEN(1)) and not(WLEN(0)) and
                   (not(EPS) xor TXShiftData(4) xor TXShiftData(3) xor
                    TXShiftData(2) xor TXShiftData(1) xor TXShiftData(0));  
  LEN6          <= not(WLEN(1)) and WLEN(0) and
                   (not(EPS) xor TXShiftData(5) xor TXShiftData(4) xor
                    TXShiftData(3) xor TXShiftData(2) xor TXShiftData(1) xor
                    TXShiftData(0));  
  LEN7          <= WLEN(1) and not(WLEN(0)) and
                   (not(EPS) xor TXShiftData(6) xor TXShiftData(5) xor
                    TXShiftData(4) xor TXShiftData(3) xor TXShiftData(2) xor
                    TXShiftData(1) xor TXShiftData(0));  
  LEN8          <= WLEN(1) and WLEN(0) and
                   (not(EPS) xor TXShiftData(7) xor TXShiftData(6) xor
                    TXShiftData(5) xor TXShiftData(4) xor TXShiftData(3) xor
                    TXShiftData(2) xor TXShiftData(1) xor TXShiftData(0));  
  Parity        <= LEN5 or LEN6 or LEN7 or LEN8;

-- Expansion of comparators...
  BitCountComp  <= '1' when BitCount(2 downto 0) = "000" else '0';
  BitPeriodCmp  <= '1' when BitPeriodCnt(3 downto 0) = "0000" else '0';

  p_StopBaudCnt : process (nUARTRST, UARTCLK)
  begin
    if ((not(nUARTRST)) = '1') then
      iStopBaudCnt   <= '1';
    elsif (UARTCLK'event and UARTCLK = '1') then
      if ((UartTXCntlState = "0000") and (TXEnable = '0')) and
        ((UartRXCntlState = "000") and (RXEnable = '0')) then 
        iStopBaudCnt <= '1';
      else
        iStopBaudCnt <= '0';
      end if;
    end if;
  end process p_StopBaudCnt;

  StopBaudCnt <= iStopBaudCnt;


  
-- State transition process
  seq : process(UARTCLK, nUARTRST)
  begin
    
    if ((not(nUARTRST)) = '1') then
      UartTXCntlState <= "0000";
      TXFRdPtrInc     <= '0';
      TXBUSY          <= '0';
      iCharTxComp     <= '1';
    elsif (UARTCLK'event and UARTCLK = '1') then
      UartTXCntlState <= UartTXCntlNext;
      TXFRdPtrInc     <= NextTXFRdPtrInc;
      TXBUSY          <= NextTXBUSY;
      iCharTxComp     <= NextCharTxComp;
    end if;
  end process seq;
  
-- Output and next state logic generation
  combo : process(UartTXCntlState, TXShiftData, WLEN, BRK, PEN,
                  STP2, RdPtrIncDoneSync, TXDataAvlblSync,
                  Baud16, AbortTransmit, nBreak, 
                  Parity, TXDReg, BitCount, BitPeriodCnt, 
                  TXShiftReg, BitCountComp, BitPeriodCmp, iCharTxComp,
                  TXEnable, CTSEn, nCTSSyncUARTCLK, EPS, SPS) 
                    
  begin 
    -- Default assignments
    UartTXCntlNext <= UartTXCntlState;
    NextTXFRdPtrInc     <= '0';
    NextTXBUSY          <= '0';
    NextTXDReg          <= TXDReg;
    NextBitCount        <= BitCount;
    NextBitPeriodCnt    <= BitPeriodCnt;
    NextTXShiftReg      <= TXShiftReg;
    NextCharTxComp      <= iCharTxComp;
    
    case UartTXCntlState is
      
      when "0000" =>

        -- Transmit data is available and Baud16 is also asserted, so shift out
        -- the start bit

        
        if ((TXDataAvlblSync and Baud16 and TXEnable and
             not(AbortTransmit)) = '1') then
          --  Transmit data available in the FIFO, so wait for the next Baud16
          --  before shifting out the start bit.
          --
          -- The following has a priority for CTS. If CTS is enabled
          -- then transmission can only proceed when nUARTCTS is low.
          -- Else wait for it to be low before proceeding.
          --
          -- If CTS is not enabled, then proceed as normal.
          if (CTSEn = '1') then
            if (nCTSSyncUARTCLK = '0') then
              NextTXDReg               <= '0';
              NextBitPeriodCnt         <= "1111";
              NextBitCount(2 downto 0) <= ('1' & WLEN(1 downto 0));
              UartTXCntlNext      <= "0001";
              NextCharTxComp           <= '0';
              NextTXBUSY               <= '1';
            else
              UartTXCntlNext      <= "0000";
            end if;
          else
            NextTXDReg               <= '0';
            NextBitPeriodCnt         <= "1111";
            NextBitCount(2 downto 0) <= ('1' & WLEN(1 downto 0));
            UartTXCntlNext      <= "0001";
            NextCharTxComp           <= '0';
            NextTXBUSY               <= '1';            
          end if;
          
        elsif ((not(AbortTransmit) and not(Baud16) and TXEnable and
                TXDataAvlblSync) = '1') then
          -- Priority for CTS included below. If enabled then
          -- nUARTCTS has to be asserted to proceed. Else continue as
          -- normal.
          if (CTSEn = '1') then
            if (nCTSSyncUARTCLK = '0') then
              UartTXCntlNext <= "0101";
              NextTXBUSY          <= '1';
            else
              UartTXCntlNext <= "0000";
            end if;
          else
            UartTXCntlNext   <= "0101";
            NextTXBUSY            <= '1';
          end if;
          
        elsif (not(TXEnable) = '1') then
          NextTXDReg          <= TXDReg;
          NextBitPeriodCnt    <= "1111";
          NextBitCount        <= "000";
          UartTXCntlNext <= UartTXCntlState;
          NextTXShiftReg      <= "0000000";
          NextTXFRdPtrInc     <= '0';
          NextTXBUSY          <= '0';
          
          
        elsif ((BRK) = '1') then
          -- Break to be transmitted, so pull the TXD line low
          NextTXDReg          <= '0';
          NextBitPeriodCnt    <= "1111";
          UartTXCntlNext <= "0100";
          NextCharTxComp      <= '1';
          NextTXBUSY          <= '1';
          
        else
          NextTXFRdPtrInc     <= '0';
          NextTXBUSY          <= '0';
        end if;
        
      when "0001" =>
        
        --  Shift out the first data bit , increment BitCnt, reload the 
        --  BitPeriodCnt counter and load the transmit shift
        -- register.        
        if ((Baud16 and BitPeriodCmp) = '1') then
          NextTXDReg                 <= TXShiftData(0);
          NextBitPeriodCnt           <= "1111";
          NextTXShiftReg(6 downto 0) <= TXShiftData(7 downto 1);
          UartTXCntlNext        <= "0011";
          NextCharTxComp             <= '0';            
          NextTXBUSY                 <= '1';
          
          --  Decrement the BitPeriodCnt counter with Baud16 as the count
          --  enable to time the start bit.          
        elsif ((Baud16 and not(BitPeriodCmp)) = '1') then
          NextBitPeriodCnt           <= UNSIGNED(BitPeriodCnt) - 1;
          UartTXCntlNext        <= "0001";
          NextTXBUSY                 <= '1';
        else
          NextTXBUSY                 <= '1';
        end if;
        
      when "0011" =>
        
        --  At the end of a bit period, shift in the next bit and reload the
        --  BitPeriodCnt counter
        
        if ((not(BitCountComp) and BitPeriodCmp and Baud16) = '1') then 
          NextTXDReg                 <= TXShiftReg(0);
          NextBitCount               <= UNSIGNED(BitCount) - 1;
          NextBitPeriodCnt           <= "1111";
          NextTXShiftReg(5 downto 0) <= TXShiftReg(6 downto 1);
          NextTXShiftReg(6 downto 6) <= "0"; 
          UartTXCntlNext        <= "0011";
          NextTXBUSY <= '1';
          --  With Baud16 as the count enable, decrement the BitPeriodCnt
          
        elsif ((Baud16 and not(BitPeriodCmp)) = '1') then
          NextBitPeriodCnt           <= UNSIGNED(BitPeriodCnt) - 1;
          UartTXCntlNext        <= "0011";
          NextTXBUSY <= '1';
          -- All data bits transmitted, parity bit next.
          
        elsif ((Baud16 and BitPeriodCmp and PEN and BitCountComp) = '1') then 
          NextBitPeriodCnt            <= "1111";
          UartTXCntlNext         <= "0010";
          NextCharTxComp              <= '0';                        
          NextTXBUSY                  <= '1';
          if ((SPS and EPS) = '1') then
            NextTXDReg                <= '0';
          elsif ((SPS and not(EPS)) = '1') then
            NextTXDReg                <= '1';
          else
            NextTXDReg                <= Parity;
          end if;
          
          
          -- All data bits transmitted. No parity bit
          -- programmed, but extra stop bit required.
          
        elsif ((Baud16 and BitPeriodCmp and BitCountComp and not(PEN) and
            STP2) = '1') then 
          NextTXDReg          <= '1';
          NextBitPeriodCnt    <= "1111";
          UartTXCntlNext <= "0110";
          NextCharTxComp      <= '1';                            
          NextTXBUSY          <= '1';
          -- All data bits transmitted. No parity bit
          -- programmed, one stop bit programmed.
          
        elsif ((Baud16 and BitPeriodCmp and BitCountComp and not(PEN) and
            not(STP2)) = '1') then 
          NextTXDReg          <= '1';
          NextBitPeriodCnt    <= "1111";
          UartTXCntlNext <= "0111";
          NextCharTxComp      <= '1';                            
          NextTXFRdPtrInc     <= '1';
          NextTXBUSY          <= '1';
        else
          NextTXBUSY          <= '1';
        end if;
        
      when "0010" =>
        
        -- 2 stop bits programmed, so transmit additional stop bit first
        
        if ((Baud16 and BitPeriodCmp and STP2) = '1') then
          NextTXDReg          <= '1';
          NextBitPeriodCnt    <= "1111";
          UartTXCntlNext <= "0110";
          NextCharTxComp      <= '1';                            
          NextTXBUSY          <= '1';
          
        elsif ((Baud16 and not(BitPeriodCmp)) = '1') then
          NextBitPeriodCnt    <= UNSIGNED(BitPeriodCnt) - 1;
          UartTXCntlNext <= "0010";
          NextTXBUSY          <= '1';
          -- Only one stop bit
          
        elsif ((Baud16 and BitPeriodCmp and not(STP2)) = '1') then
          NextTXDReg <= '1';
          NextBitPeriodCnt    <= "1111";
          UartTXCntlNext <= "0111";
          NextCharTxComp      <= '1';                            
          NextTXFRdPtrInc     <= '1';
          NextTXBUSY          <= '1';
        else
          NextTXBUSY          <= '1';
        end if;
        
      when "0110" =>
        
        
        if ((Baud16 and not(BitPeriodCmp)) = '1') then
          NextBitPeriodCnt    <= UNSIGNED(BitPeriodCnt) - 1;
          UartTXCntlNext <= "0110";
          NextTXBUSY          <= '1';
          -- One stop bit shifted out, now move to the stop state to shift out the
          -- next stop bit
          
        elsif ((Baud16 and BitPeriodCmp) = '1') then
          NextTXDReg          <= '1';
          NextBitPeriodCnt    <= "1111";
          UartTXCntlNext <= "0111";
          NextCharTxComp      <= '1';                            
          NextTXFRdPtrInc     <= '1';
          NextTXBUSY          <= '1';
        else
          NextTXBUSY          <= '1';
        end if;
        
      when "0111" =>
        --  If the FIFO has completed the write and there is no more
        --  data available to be transmitted, then wait for transmit
        --  data

        if ((((AbortTransmit and BitPeriodCmp and Baud16) or
            (BitPeriodCmp and Baud16 and not(TXDataAvlblSync))) and
            RdPtrIncDoneSync) = '1') then  
          NextTXDReg          <= nBreak;
          NextBitCount        <= "000";
          NextBitPeriodCnt    <= "1111";
          NextTXShiftReg      <= "0000000";
          UartTXCntlNext <= "0000";
          NextCharTxComp      <= '1';                            
          NextTXFRdPtrInc     <= '0';
          NextTXBUSY          <= '0';
          
          
--  If the FIFO has completed the write and the last stop bit is complete
          --  and there is more data available for transmission, then
          --  if Transmit is enabled proceed with the transmission of
          --  the next data, otherwise go to the idle state and wait
          --  for an enable signal
          
        elsif ((not(AbortTransmit) and TXDataAvlblSync and Baud16 and
                BitPeriodCmp and RdPtrIncDoneSync) = '1') then 
          NextBitCount(2 downto 0) <= ('1' & WLEN(1 downto 0));
          NextBitPeriodCnt         <= "1111";
          NextCharTxComp           <= '1';                            
          NextTXBUSY               <= '1';

          -----------------------------------------------------------
          -- For Flow Control need to check whether it is still okay
          -- to send further data (CTSEn = '1' and nCTSSyncUARTCLK =
          -- '0'). Otherwise normal operation resumes.
          -----------------------------------------------------------
          if (CTSEn = '1') then
            if (nCTSSyncUARTCLK = '0' and TXEnable = '1') then
              UartTXCntlNext <= "0001";
              NextTXDReg          <= '0';
              NextCharTxComp     <= '0';
            else
              UartTXCntlNext <= "0000";
              NextTXDReg          <= '1';
            end if;
          elsif (TXEnable = '1') then
            UartTXCntlNext   <= "0001";
            NextTXDReg            <= '0';
            NextCharTxComp     <= '0';
          else
            UartTXCntlNext   <= "0000";
            NextTXDReg            <= '1';
          end if;
          
        elsif ((Baud16 and not(BitPeriodCmp)) = '1') then 
          NextBitPeriodCnt        <= UNSIGNED(BitPeriodCnt) - 1;
          UartTXCntlNext          <= "0111";
          NextTXFRdPtrInc         <= '1';
          NextTXBUSY              <= '1';     
        else
          NextTXFRdPtrInc         <= '1';
          NextTXBUSY              <= '1';
        end if;
        
        
      when "0101" =>
        --  Transmit the start bit when the next Baud16 pulse is seen.
        --  Load BitPeriodCnt with '1111' to count 16 Baud16  pulses before
        --  the next bit. Also clear the BitCnt counter (which indicates
        --  the number of bits currently shifted out
        
        if (Baud16 and not(AbortTransmit)) = '1'  then
          NextTXDReg               <= '0';
          NextBitCount(2 downto 0) <= ('1' & WLEN(1 downto 0));
          NextBitPeriodCnt         <= "1111";
          UartTXCntlNext      <= "0001";
          NextCharTxComp           <= '0';
          NextTXBUSY               <= '1';
          
          --  If an illegal value is written in the 
          --  bit rate divisor  then pull the transmit output line HIGH.         
        elsif ((AbortTransmit) = '1') then
          NextTXDReg          <= nBreak;
          NextBitCount        <= "000";
          NextBitPeriodCnt    <= "1111";
          UartTXCntlNext <= "0000";
          NextTXFRdPtrInc     <= '0';
          NextTXBUSY          <= '0';
        else
          NextTXBUSY          <= '1';
        end if;
        
      when "0100" =>
        -- Break cleared, wait for a bit time, to avoid potential glitches on
        -- nSIROUT line
        
        if ((not(BRK)) = '1') then
          NextBitPeriodCnt    <= "1111";
          NextTXDReg          <= '1';
          UartTXCntlNext      <= "1100";
          NextCharTxComp      <= '1';
        else
          NextTXBUSY          <= '1';
        end if;
        
      when "1100" =>
        
        if ((Baud16 and BitPeriodCmp and not(BRK)) = '1') then
          NextTXDReg          <= '1';
          NextBitCount        <= "000";
          NextBitPeriodCnt    <= "1111";
          NextTXShiftReg      <= "0000000";
          UartTXCntlNext <= "0000";
          NextCharTxComp      <= '1';   
          NextTXFRdPtrInc     <= '0';
          NextTXBUSY          <= '0';

        elsif ((Baud16 and not(BitPeriodCmp) and not(BRK)) = '1') then
          NextBitPeriodCnt    <= UNSIGNED(BitPeriodCnt) - 1;
          UartTXCntlNext <= "1100";

        elsif ((BRK) = '1') then
          UartTXCntlNext      <= "0100";
          NextTXBUSY          <= '1';
          NextCharTxComp      <= '1';
        end if;

      when others =>
        UartTXCntlNext   <= "0000";
    end case;
  end process combo;

  TXDReg_seq : process(UARTCLK, nUARTRST)
  begin
    
    if ((not(nUARTRST)) = '1') then
      TXDReg <= '1';
    elsif (UARTCLK'event and UARTCLK = '1') then
      TXDReg <= NextTXDReg;
    end if;
  end process TXDReg_seq;

  BitCount_seq : process(UARTCLK, nUARTRST)
  begin
    
    if ((not(nUARTRST)) = '1') then
      BitCount <= "000";
    elsif (UARTCLK'event and UARTCLK = '1') then
      BitCount <= NextBitCount;
    end if;
  end process BitCount_seq;

  BitPeriodCnt_seq : process(UARTCLK, nUARTRST)
  begin
    
    if ((not(nUARTRST)) = '1') then
      BitPeriodCnt <= "1111";
    elsif (UARTCLK'event and UARTCLK = '1') then
      BitPeriodCnt <= NextBitPeriodCnt;
    end if;
  end process BitPeriodCnt_seq;

  TXShiftReg_seq : process(UARTCLK, nUARTRST)
  begin
    
    if ((not(nUARTRST)) = '1') then
      TXShiftReg <= "0000000";
    elsif (UARTCLK'event and UARTCLK = '1') then
      TXShiftReg <= NextTXShiftReg;
    end if;
  end process TXShiftReg_seq;
  
end synth;
--  Signals: UartTXCntlState<3:0> UartTXCntlNext<3:0> 
--    ST_IDLE   	0000
--    ST_STARTBIT	0001
--    ST_SHIFT  	0011
--    ST_PARITY 	0010
--    ST_XSTOP	        0110
--    ST_STPRDPTRINC	0111
--    ST_DATAAVLBL	0101
--    ST_BREAK  	0100
--    ST_EXITBREAK	1100
