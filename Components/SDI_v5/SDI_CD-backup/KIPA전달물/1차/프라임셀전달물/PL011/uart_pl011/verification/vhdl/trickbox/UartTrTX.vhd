--============================================================================--
--  This confidential and proprietary software may be used only as
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
--  File Name              : UartTrTX.vhd.rca
--  File Revision          : 1.5
--
--  Release Information    : PrimeCell(TM)-PL011-REL1v3
--
--  ----------------------------------------------------------------------------
-- Purpose  : This block contains the control logic for the transmit
--            section of Trickbox  
--
-- ========================================================================== --

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

--  ----------------------------------------------------------------------------
 
entity UartTrTX is
  port (
        UARTCLK         : in std_logic;        -- Main UART Clock
        nUARTRES        : in std_logic;        -- Muxed reset (from nUARTRST)
        TXDataAvlbl     : in std_logic;        -- TX Data Available
        UTLCRH          : in std_logic_vector(7 downto 0); -- Line Control Reg
        UARTEN          : in std_logic;        -- UART Enable
        UTSETPINS       : in std_logic;        -- Programmable TXD
        WLEN            : in std_logic_vector(1 downto 0);  -- Bits per word
        EPS             : in std_logic;        -- Even Parity Select
        Mode            : in std_logic_vector(1 downto 0);  -- Operation Mode
        Divisor         : in std_logic_vector(15 downto 0); -- Baud Rate
        TxJitterSign    : in std_logic;        -- TX Jitter Sign
        TxJitterFactor  : in std_logic_vector(1 downto 0);  -- TX Jitter Factor
        TXShiftData     : in std_logic_vector(7 downto 0);  -- TX Data
        RdPtrIncDone    : in std_logic;        -- Read Pointer Increment done
        PEEN            : in std_logic;        -- Introduce Parity Error
        FEEN            : in std_logic;        -- Introduce Framing  Error
        SPS             : in std_logic;        -- Stick Parity Select
        TXD             : out std_logic;       -- Internal Transmit line
        TXBUSY          : out std_logic;       -- Transmitter busy
        TXFRdPtrInc     : out std_logic        -- TX FIFO Rd Ptr Inc
       );
end UartTrTX;
 
--------------------------------------------------------------------------------
--
--                   UartTrTXCntl
--                   ============
--
--------------------------------------------------------------------------------
--
-- Overview
-- ========
--
--  The control logic for the transmit block of Trickbox  shifts out data 
-- according  to the parameters programmed in trickbox line control registers. 

--=============================== ARCHITECTURE ===============================--

architecture synth of UartTrTX  is
 
--------------------------------------------------------------------------------
-- Signal declarations
--------------------------------------------------------------------------------
signal NextTXFRdPtrInc     : std_logic; 
-- Combinational input for TX FIFO Read Pointer Incrementer

signal NextTXBUSY          : std_logic; 
-- Combinational input for Transmit busy

signal NextTXData          : std_logic; 
-- Combinational input for Data to be transmitted

signal iTXBUSY             : std_logic; 
-- Internal transmit busy signal

signal Parity              : std_logic; 
-- Parity bit transmitted

signal Starttx             : std_logic; 
-- Set while start bit transmission

signal NextStarttx         : std_logic;
-- D-input for Start-tx

signal iTXD                : std_logic; 
-- Internal version of Data transmitted

signal TxData              : std_logic_vector(10 downto 0); 
-- Actual data transmitted

signal Wordcount           : std_logic_vector(7 downto 0);
-- bits per frame

signal Bitcount            : std_logic_vector(7 downto 0);
-- Internal counter denoting the bit being transmitted

signal Bitperiodcount      : std_logic_vector(19 downto 0);
-- Internal counter denoting the clock cycles for which the bit 
-- is being transmitted

signal Nextbitcount        : std_logic_vector(7 downto 0);
-- Combinational input for the bit counter

signal NxtBitperiodcnt     : std_logic_vector(19 downto 0);
--  Combinational input for the bitperiod counter

signal ActualBitPeriod     : std_logic_vector(19 downto 0);
-- Denotes Uart bit period

signal PaddedData          : std_logic_vector(7 downto 0 );
-- Concatenated TX Shift Reg data

signal Uartbaud            : std_logic_vector(15 downto 0);
-- Internal signal related to baud rate

signal FrameCtrl           : std_logic_vector(1 downto 0);
-- Concatenating Parity and STP2 enable

signal BitPerZero          : std_logic;

--------------------------------------------------------------------------------
--
-- Main body of code
-- =================
--
--------------------------------------------------------------------------------
 
begin

--------------------------------------------------------------------------------
-- Internal versions of output(s)...
--------------------------------------------------------------------------------
 TXBUSY          <= iTXBUSY;
--------------------------------------------------------------------------------
-- Multiplexing Actual TXD and Programmable TXD 
--------------------------------------------------------------------------------
p_modeComb : process (UARTEN, iTXD, UTSETPINS)
begin
  if (UARTEN = '1')then
    TXD   <= iTXD;
  else
    TXD <= UTSETPINS;
  end if;
end process p_modeComb; 

--------------------------------------------------------------------------------
-- State transition process
--------------------------------------------------------------------------------
p_StateSeq : process(UARTCLK, nUARTRES) 
begin
  if (nUARTRES = '0') then
    TXFRdPtrInc      <= '0';
    Starttx          <= '1';
    iTXBUSY          <= '0';
    Bitcount         <= "00000000";
    Bitperiodcount   <= "00000000000000000000";
    iTXD             <= '0';
  elsif (UARTCLK'event and UARTCLK = '1') then
    TXFRdPtrInc      <= NextTXFRdPtrInc;      
    Starttx          <= NextStarttx;
    iTXBUSY          <= NextTXBUSY;
    Bitcount         <= Nextbitcount;
    Bitperiodcount   <= NxtBitperiodcnt;
    iTXD             <= NextTXData;
  end if;
end process p_StateSeq;

BitPerZero <= '1' when Bitperiodcount = "00000000000000000000" else '0';

--------------------------------------------------------------------------------
-- Output and next state logic generation
--------------------------------------------------------------------------------
p_StateCombo : process(iTXD, Bitcount, Divisor, Bitperiodcount, iTXBUSY,
                       TXShiftData, PaddedData, Starttx, UARTEN, 
                       Mode, TXDataAvlbl)
begin
--------------------------------------------------------------------------------
-- Default assignments
-- Calculating Actual Uart bit width and concatenating PEN and STP2
--------------------------------------------------------------------------------
  if (Divisor /=  "UUUUUUUUUUUUUUUU")then
     Uartbaud <= Divisor; 
  end if;
  ActualBitPeriod <= Uartbaud & "0000";
  FrameCtrl       <= UTLCRH(1) & UTLCRH(3);
 
  if (((UARTEN ='1') and (Mode = "00"))) then 
--------------------------------------------------------------------------------
     
-- Transmission in progress, if Trickbox is enabled in Normal mode and data
-- is available in shift register or until the last data's stop bit
-- is fully transmitted
--------------------------------------------------------------------------------
    if ((TXDataAvlbl = '1') or ((RdPtrIncDone = '1') and 
                              (iTXBUSY = '1'))) then
--------------------------------------------------------------------------------
      -- Transmit start bit
--------------------------------------------------------------------------------
      if (Starttx = '1') then 

        -- Setting the initial conditions   
        if ((Bitcount = "00000000") and 
           ( Bitperiodcount = "00000000000000000000")) then 
          NextTXData          <= '0';
          NextTXBUSY          <= '1';
          NextTXFRdPtrInc     <= '0';
            
          -- Process the startbit period if jitter is enabled             
          if (TxJitterSign = '1') then
             NxtBitperiodcnt <= unsigned(ActualBitPeriod)  
                                + unsigned( TxJitterFactor) - 1;
          else 
             NxtBitperiodcnt <= unsigned( ActualBitPeriod)  
                                - unsigned( TxJitterFactor) - 1 ; 
          end if;
          
          -- Determining transmit parameters during Start bit transmission 
        else
          -- Regrouping the data bits to be transmitted
          case WLEN is
            when "00" => 
              PaddedData <= "000" & TXShiftData(0) & TXShiftData(1) 
                             & TXShiftData(2) & TXShiftData(3) 
                             & TXShiftData(4) ;
              Wordcount  <= "00000101";
            when "01" => 
              PaddedData <= "00" &  TXShiftData(0) & TXShiftData(1) 
                             & TXShiftData(2) & TXShiftData(3) 
                             & TXShiftData(4) & TXShiftData(5);
              Wordcount  <= "00000110";
            when "10" => 
              PaddedData <= "0" & TXShiftData(0) & TXShiftData(1) 
                             & TXShiftData(2) & TXShiftData(3) 
                             & TXShiftData(4) & TXShiftData(5) 
                             & TXShiftData(6);
              Wordcount  <= "00000111";
            when "11" => 
              PaddedData <= TXShiftData(0) & TXShiftData(1) 
                            & TXShiftData(2) & TXShiftData(3) 
                            & TXShiftData(4) & TXShiftData(5) 
                            & TXShiftData(6) & TXShiftData(7) ;
              Wordcount  <= "00001000";
            when others => 
              PaddedData <= "00000000";
              Wordcount  <= "00000000";
          end case;
            
          -- Generating Parity bit
          if (SPS = '1') then
            if (PEEN = '1') then
              Parity <= EPS;
              else
                Parity <= not(EPS);
              end if;
            else
              Parity <= ((((((PaddedData(0) xor PaddedData(1)) xor 
                             (PaddedData(2) xor PaddedData(3))) xor 
                            (PaddedData(4) xor PaddedData(5)))xor 
                           (PaddedData(6) xor PaddedData(7)))xor 
                          not(EPS)) xor ((PEEN)));
            end if;
           
          -- Concatenating Parity and Stop bit(s)
          case FrameCtrl is
            when "00" =>
              TxData       <= "00" & PaddedData & not(FEEN);
              if (Wordcount /= "UUUUUUUU") then
                Nextbitcount <= unsigned(Wordcount) + 1;
              end if;
            when "01" => 
              TxData       <= '0' & PaddedData & not(FEEN) & not(FEEN);
              if (Wordcount /= "UUUUUUUU") then
                Nextbitcount <= unsigned(Wordcount) + 2;
              end if;
            when "10" => 
              TxData       <= '0' & PaddedData & Parity & not(FEEN);
              if (Wordcount /= "UUUUUUUU") then
                Nextbitcount <= unsigned(Wordcount) + 2;
              end if;
            when "11" => 
              TxData       <= PaddedData & Parity & not(FEEN) & not(FEEN);
              if (Wordcount /= "UUUUUUUU") then
                Nextbitcount <= unsigned(Wordcount) + 3;
              end if;
            when others => 
               TxData      <= "00000000000";
              Nextbitcount <= "00000000";
          end case;
            
          -- Transmiting Startbit in progress
          -- Initialising bitperiod counter and decrement bit count
          -- Assign Next Data bit 
          if (Bitperiodcount = "00000000000000000000")then
            NextStarttx      <= '0';
            Nextbitcount     <= unsigned(Bitcount) -1 ;
            NxtBitperiodcnt  <= unsigned(ActualBitPeriod)  - 1;
            NextTXData       <= TxData(CONV_INTEGER(unsigned(Bitcount) -1 ));
            
          -- Decrement bitperiod counter 
          else
            NextTXData         <= '0';
            NxtBitperiodcnt <= unsigned(Bitperiodcount) - 1 ;
          end if;
        end if;
       
      -- Start transmiting Data bits, as well as, Parity and Stopbit if
      -- they are enabled 
      elsif (Bitcount /= "00000000") then 
           
       -- Transmitting data bits
       -- Initialising bitperiod counter and increment bit count
       -- Assign Next Data bit
         if (Bitperiodcount = "00000000000000000000") then
           Nextbitcount    <= unsigned(Bitcount) - 1;
           NxtBitperiodcnt <= unsigned(ActualBitPeriod)  -  1;
           NextTXData      <= TxData(CONV_INTEGER(unsigned(Bitcount) -1 ));
           
         -- Decrement bitperiod counter
         else 
           NxtBitperiodcnt <= unsigned(Bitperiodcount) - 1 ;
         end if;
      
       -- Start transmiting Stopbit
       else
         -- Stoptbit transmitted fully
         -- Deassert Next Frame Read Pointer increment enable signal
         if (Bitperiodcount = "00000000000000000000") then
           NextStarttx     <= '1';
           NextTXFRdPtrInc <= '0';
           NextTXData      <= '1';

         -- Increment bitperiod counter
         -- Assert Next Frame Read Pointer Increment enable signal
         else
           NextTXData       <= TxData(CONV_INTEGER(unsigned(Bitcount)));
           NxtBitperiodcnt  <= unsigned(Bitperiodcount) - 1 ;
           NextTXFRdPtrInc  <= '1';
         end if;
       end if;
     -- Reinitialize Idle State Settings
     else 
       Nextbitcount     <= "00000000";
       NxtBitperiodcnt  <= "00000000000000000000";
       NextStarttx      <= '1';
       NextTXData       <= '1';
       NextTXBUSY       <= '0';
    end if;
  -- Reinitialize Idle State Settings
  else
    Nextbitcount       <= "00000000";
    NxtBitperiodcnt    <="00000000000000000000" ;
    NextStarttx        <= '1';
    NextTXData         <='1';
    NextTXBUSY         <='0';
    NextTXFRdPtrInc    <= '0';
  end if;
  
end process p_StateCombo;
--------------------------------------------------------------------------------

end synth;

-- ============================== End  =========================================



