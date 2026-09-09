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
--  File Name              : UartTrIrdaTX.vhd.rca
--  File Revision          : 1.5
--
--  Release Information    : PrimeCell(TM)-PL011-REL1v3
--
-- -----------------------------------------------------------------------------
-- Purpose     : This block contains the control logic for the transmit
--               section of Irda 
--
-- ===========================================================================--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

-- -----------------------------------------------------------------------------
 
entity UartTrIrdaTX is
  port (
        UARTCLK         : in std_logic;  -- Main UART Clock
        nUARTRES        : in std_logic;  -- Uart reset 
        TXDataAvlbl     : in std_logic;  -- TX Data Available
        UTSETPINS       : in std_logic;        -- Programmable TXD
        UTLCRH          : in std_logic_vector(7 downto 0); -- Line ControlReg
        IRDADEC         : in std_logic_vector(3 downto 0); -- Decrease Factor
        UTBITSFTDATA    : in std_logic_vector(7 downto 0); -- Pulse Shift Reg
        UTBITSFTDATA2   : in std_logic_vector(5 downto 0); -- Pulse ShiftReg
        UARTEN          : in std_logic;  -- UART Enable
        WLEN            : in std_logic_vector(1 downto 0); -- Bits per word
        EPS             : in std_logic;  -- Even Parity Select
        Mode            : in std_logic_vector(1 downto 0); -- Operation Mode
        Divisor         : in std_logic_vector(15 downto 0); -- Baud Rate
        IRLPDivisor     : in std_logic_vector(7 downto 0);  -- Low Power Baud
        TxJitterSign    : in std_logic;   -- TX Jitter Sign
        TxJitterFactor  : in std_logic_vector(1 downto 0);  -- TX JitterFactor
        TXShiftData     : in std_logic_vector(7 downto 0);  -- TX Data
        RdPtrIncDone    : in std_logic;      -- Read Pointer Increment done
        PEEN            : in std_logic;      -- Intoduce Parity Error
        FEEN            : in std_logic;      -- Introduce Framing  Error
        SIROUT          : out std_logic;  -- Irda Output Data bit
        TXFRdPtrInc     : out std_logic;     -- TX FIFO Rd Ptr Inc
        TXBUSY          : out std_logic      -- Transmitter busy
       );
end UartTrIrdaTX;
 
--------------------------------------------------------------------------------
--
--                   UartTrIrdaTX
--                   ===========
--
--------------------------------------------------------------------------------
--
-- Overview
-- ========
--
--  The control logic for the transmit block of Uart shifts out data according
--  to the parameters programmed in trickbox line control registers.
--
--------------------------------------------------------------------------------
--=============================== ARCHITECTURE ===============================--

architecture synth of UartTrIrdaTX  is
 
--------------------------------------------------------------------------------
-- Constant declarations
--------------------------------------------------------------------------------
constant IRDACON3 : std_logic_vector(1 downto 0):="11";  -- For Generating PW

constant IRDACON13 : std_logic_vector(3 downto 0):="1101"; -- For Generating PW
--------------------------------------------------------------------------------
-- Signal declarations
--------------------------------------------------------------------------------
signal NextTXFRdPtrInc     : std_logic;
-- Combinational input for Incrementer

signal NextTXBUSY          : std_logic;
-- Combinational input for Transmit busy

signal NextTXData          : std_logic;
-- Combinational input for Data to be transmitted

signal NextSIROUT          : std_logic;
-- Combinational input for Data to be transmitted

signal iTXFRdPtrInc        : std_logic;
-- Internal transmit frame read ptr Increment synced signal

signal iTXBUSY             : std_logic;
-- Internal transmit busy signal

signal Parity              : std_logic;
-- Parity bit transmitted

signal  BITSFTEN           : std_logic;
-- Shifting pulses Enabled

signal Starttx             : std_logic;
-- Set while start bit transmission

signal NextStarttx         : std_logic;
-- D-input for Start transmission

signal TxData               : std_logic_vector(10 downto 0);
-- Actual data transmitted

signal TXDatabit            : std_logic;
-- Internal version of Data transmitted

signal iSIROUT              : std_logic;
-- Internal version of data transmitted

signal ActualBitPeriod      : std_logic_vector(19 downto 0);
-- Denotes Uart bit period

signal PaddedData           : std_logic_vector(7 downto 0 );
-- Concatenated TX Shift Reg data

signal  UartBaud           : std_logic_vector(15 downto 0);
-- Internal signal related to Uart baud rate

signal  BaudILPR           : std_logic_vector(15 downto 0);
-- Internal signal related to Irda low power pulse rate

signal  BaudIrda           : std_logic_vector(17 downto 0);
-- Internal signal related to Irda baud rate
 
signal  IrdaPW             : std_logic_vector(21 downto 0);
-- Denotes Irda pulse width

signal  IrdaLPRPW          : std_logic_vector(19 downto 0);
--Denotes Irda low power pulse width

signal  PWidth             : std_logic_vector(19 downto 0);
-- Actual pulse width of the bit

signal  BitJitter          : std_logic_vector(19 downto 0);
-- Bitperiod after considering jitter

signal  Count              : std_logic_vector(7 downto 0);
-- Internal counter for counting pulses

signal  Nextcount          : std_logic_vector(7 downto 0);
-- Combinational input for counter Count

signal  ActualPW           : std_logic_vector(19 downto 0);
-- Actual bit width

signal  StartPW            : std_logic_vector(19 downto 0);
-- Start bit pulse width

signal Wordcount           : std_logic_vector(7 downto 0);
-- bits per frame

signal Bitcount            : std_logic_vector(7 downto 0);
-- Internal counter denoting the bit being transmitted

signal Bitperiodcount      :std_logic_vector(19 downto 0);
-- Internal counter denoting the clock cycles for which the bit
-- is being transmitte

signal Nextbitcount        :std_logic_vector(7 downto 0);
-- Combinational input for the bit counter

signal NxtBitperiodcnt     :std_logic_vector(19 downto 0);
--  Combinational input for the bitperiod counter

signal  PULSENUM           : std_logic_vector(2 downto 0);
-- Pulse to be jittered

signal  PULSESHFT          : std_logic_vector(2 downto 0);
-- Shifting factor for the pulse

signal  SPNUM              : std_logic_vector(2 downto 0);
-- Starting pulse number from which it is to be jittered

signal  EPNUM              : std_logic_vector(2 downto 0);
-- Ending pulse number upto which it is to be jittered

signal  SHFT               : std_logic_vector(1 downto 0);
-- Number of baud periods by which pulse has to be jittered

signal Framesel            : std_logic_vector(1 downto 0);
-- Concatenated parity enable and STP2
--------------------------------------------------------------------------------
--
-- Main body of code
-- =================
--
--------------------------------------------------------------------------------
 
begin

--------------------------------------------------------------------------------
-- Expose internal register(s)...
--------------------------------------------------------------------------------
   TXBUSY      <= iTXBUSY;
   PULSENUM    <= UTBITSFTDATA2(5 downto 3);
   PULSESHFT   <= UTBITSFTDATA2(2 downto 0);
   SPNUM       <= UTBITSFTDATA(7 downto 5);
   EPNUM       <= UTBITSFTDATA(4 downto 2);
   SHFT        <= UTBITSFTDATA(1 downto 0);
   BITSFTEN    <= UTLCRH(7);
   TXFRdPtrInc <= iTXFRdPtrInc;
--------------------------------------------------------------------------------
-- Multiplexing Actual TXD and Programmable TXD
--------------------------------------------------------------------------------
p_modeComb : process (UARTEN, iSIROUT, UTSETPINS)
begin
  if (UARTEN = '1')then
    SIROUT  <= iSIROUT;
  else
    SIROUT <= UTSETPINS;
  end if;
end process p_modeComb;
 
--------------------------------------------------------------------------------
-- State transition process
--------------------------------------------------------------------------------
p_StateSeq : process (UARTCLK, nUARTRES) 
begin
 
  if (nUARTRES = '0') then
    iTXFRdPtrInc     <= '0';
    iTXBUSY          <= '0';
    Bitcount         <= "00000000";
    Count            <= "00000000";
    iSIROUT          <= '1';
    Bitperiodcount   <= "00000000000000000000";
    TXDatabit        <= '1';
    Starttx          <= '1';
  elsif  (UARTCLK'event and UARTCLK = '1') then
    Starttx          <= NextStarttx;
    iTXFRdPtrInc     <= NextTXFRdPtrInc;
    iTXBUSY          <= NextTXBUSY;
    Bitcount         <= Nextbitcount;
    Count            <= Nextcount;
    Bitperiodcount   <= NxtBitperiodcnt ;
    TXDatabit        <= NextTXData;
    iSIROUT          <= NextSIROUT;
  end if;
end process p_StateSeq;

--------------------------------------------------------------------------------
-- Output and next state logic generation
--------------------------------------------------------------------------------
p_StateCombo : process (Count, iTXBUSY, RdPtrIncDone, Bitcount, BITSFTEN,
                        Divisor, Bitperiodcount, TXShiftData, PaddedData,
                        TXDatabit, UARTEN, Mode, TXDataAvlbl)
begin

--------------------------------------------------------------------------------
-- Default assignments
-- Determining Actual Uart bit width, Irda Pulse width and Low Power Pulse width
--------------------------------------------------------------------------------
if ((IRLPDivisor /=  "UUUUUUUU") and (IRLPDivisor /= "XXXXXXXX"))then
      BaudILPR  <= unsigned(IRDACON3) * (unsigned("000000" & IRLPDivisor));
end if; 
if ((Divisor /=  "UUUUUUUUUUUUUUUU") and (Divisor /= "XXXXXXXXXXXXXXXX"))then
    UartBaud        <= Divisor;
    BaudIrda        <= unsigned(IRDACON3) * unsigned(UartBaud);
end if;

ActualBitPeriod <= UartBaud & "0000";   
Framesel        <= UTLCRH(1) & UTLCRH(3);

-- Determining actual pulse widths 
  if (IRDADEC > "0000")then
    IrdaLPRPW <= unsigned(BaudILPR) * unsigned(IRDADEC);
    IrdaPW    <= (unsigned(BaudIrda)) * unsigned( IRDADEC);
  else
    IrdaLPRPW <= "0000" & BaudILPR ;
    IrdaPW    <= "0000" & BaudIrda  ;
  end if;

  -- Determining Start Pulse width and Start bit width considering jitter
  if ((UARTEN ='1') and ((Mode = "01") or (Mode = "10" ))) then 
    if (Mode = "10") then
      PWidth <= IrdaLPRPW;
    else
      if (IRDADEC > "0000")then
        if (Divisor = "0000000000000001") then
          PWidth <= "0" & IrdaPW(21 downto 3);
        else
          PWidth <= "00" & IrdaPW(21 downto 4);
        end if;
      else
        PWidth <= IrdaPW(19 downto 0);
      end if;
    end if;
    if (TxJitterSign = '1') then
      BitJitter <= unsigned(ActualBitperiod) + unsigned(TxJitterFactor) ;
    else
      BitJitter <= unsigned(ActualBitPeriod) - unsigned(TxJitterFactor)  ;
    end if;
    if (BITSFTEN = '1')then
      if (((PULSENUM = "000" ) and (PULSESHFT /= "000" )) ) then
        StartPW <= unsigned(BitJitter) - unsigned(PULSESHFT) 
                    * unsigned(UartBaud)   ;
      elsif (((SPNUM = "000" ) and (SHFT /= "00")) )then
        StartPW <= unsigned(BitJitter) -  unsigned(SHFT) * 
                    unsigned('0' & UartBaud(15 downto 1))  ;
      end if;
    else
      StartPW <= BitJitter ;
    end if;

    -- Transmission in progress, if Trickbox is enabled in Normal mode and data
    -- is available in shift register or until the last data's stop bit
    -- is fully transmitted 
    if ((TXDataAvlbl = '1' ) or ((RdPtrIncDone = '1') and 
        (iTXBUSY = '1'))) then
        
      -- Transmit start bit 
      if (Starttx = '1') then

        -- Setting the initial conditions     
        if ((Bitcount = "00000000") and 
            (Bitperiodcount = "00000000000000000000")) then 
          NextTXData <= '1';
          NextSIROUT <= '0';
          NextTXBUSY <= '1';
          NextTXFRdPtrInc <= '0';
          NxtBitperiodcnt <= "00000000000000000001";
 
        -- Determining transmit parameters during Start bit transmission
        else 
          -- Regrouping the data bits to be transmitted
          case WLEN is
            when "00" => 
              PaddedData <= "000" & TXShiftData(0) 
                            & TXShiftData(1) & TXShiftData(2) 
                            & TXShiftData(3) & TXShiftData(4) ;
              Wordcount <= "00000101";
            when "01" => 
              PaddedData <= "00" &  TXShiftData(0) & 
                            TXShiftData(1) & TXShiftData(2) 
                            & TXShiftData(3) & TXShiftData(4) 
                            & TXShiftData(5);
              Wordcount <= "00000110";
            when "10" => 
              PaddedData <= "0" & TXShiftData(0) & 
                             TXShiftData(1)& TXShiftData(2) 
                             & TXShiftData(3) & TXShiftData(4) 
                             & TXShiftData(5) & TXShiftData(6);
              Wordcount <= "00000111";
            when "11" => 
              PaddedData <= TXShiftData(0) & TXShiftData(1) & 
                            TXShiftData(2) & TXShiftData(3) & 
                            TXShiftData(4) & TXShiftData(5) & 
                            TXShiftData(6) & TXShiftData(7) ;
              Wordcount <= "00001000";
            when others => 
              PaddedData <= "00000000";
              Wordcount <= "00000000";
          end case;
                
          -- Transmiting Startbit in progress
          -- Initialising bitperiod counter and increment bit count
          -- Assign Next SIROUT bit 
--           if (CONV_INTEGER(unsigned(Bitperiodcount)) = (CONV_INTEGER(unsigned(StartPW))+1)) then
          if (CONV_INTEGER(unsigned(Bitperiodcount)) = (CONV_INTEGER(unsigned(StartPW)))) then
            NextStarttx     <= '0';
            Nextbitcount    <= Bitcount ;
            NxtBitperiodcnt <= "00000000000000000001" ;
            Nextcount       <= "00000001";
            NextTXData      <= TxData(CONV_INTEGER(unsigned(Bitcount)));
            if (TxData(CONV_INTEGER(unsigned(Bitcount))) = '1')then
              NextSIROUT <= '1';
            else
              NextSIROUT <= '0';
            end if;

          -- SIROUT held low till bitperiodcount becomes Pulse width
          elsif (Bitperiodcount = PWidth) then 
            NextSIROUT      <= '1';
            NxtBitperiodcnt <= unsigned(Bitperiodcount) + 1 ;
                  
            -- Concatenating Parity and Stop bit(s) 
            case Framesel is
              when "00" =>
                TxData       <= "00" & PaddedData & not(FEEN);
                Nextbitcount <= Wordcount ;
              when "01" => 
                TxData       <=  '0' & PaddedData & not(FEEN) 
                                 &  not(FEEN);
                Nextbitcount <= unsigned(Wordcount) + 1;
              when "10" => 
                TxData       <=  '0' & PaddedData & Parity 
                                  & not(FEEN);
                Nextbitcount <= unsigned(Wordcount) + 1;
              when "11" => 
                TxData       <=  PaddedData & Parity  & not(FEEN) 
                                 & not(FEEN);
                Nextbitcount <= unsigned(Wordcount) + 2;
             when others => 
                TxData       <= "00000000000";
                Nextbitcount <= "00000000";
            end case;

            -- Generating Parity bit
            -- Increment bitperiod counter
          else
            Parity <= ((((((PaddedData(0) xor PaddedData(1)) xor 
                           (PaddedData(2) xor PaddedData(3))) xor 
                           (PaddedData(4) xor PaddedData(5)))xor 
                           (PaddedData(6) xor PaddedData(7)))xor 
                           (not(EPS))) xor ((PEEN)));
     
            NxtBitperiodcnt <= unsigned(Bitperiodcount) + 1 ;
          end if;
        end if;  

      -- Start transmiting Data bits, as well as, Parity and Stopbit if
      -- they are enabled 
      elsif  (Bitcount /= "00000000" ) then

        -- Determining actual pulse width for the bit
        if (BITSFTEN = '1')then
          if (((Count = "00000" & PULSENUM ) and 
             (PULSESHFT /= "000"))) then
            ActualPW <= unsigned(ActualBitPeriod) - 
                          unsigned(PULSESHFT) * unsigned(UartBaud) ;
          elsif ((((Count >= "00000" & SPNUM ) and (Count <= EPNUM)) 
                   and (SHFT /= "00")) )then
            ActualPW <= unsigned(ActualBitPeriod) -  unsigned(SHFT) 
                        * unsigned('0' & UartBaud(15 downto 1));
          end if;
        else
          ActualPW <= ActualBitPeriod;
        end if; 
           
        -- Initialising bitperiod counter and increment bit count
        -- Assign Next SIROUT bit 
        if (Bitperiodcount = ActualPW) then
          Nextbitcount <= unsigned(Bitcount) - 1;
          if (TxData(CONV_INTEGER(unsigned(Bitcount) - 1)) = '1')then
             NextSIROUT <= '1';
          else
             NextSIROUT <= '0';
          end if;
          NxtBitperiodcnt <= "00000000000000000001";
          Nextcount       <= unsigned(Count) +1;
          NextTXData      <= TxData(CONV_INTEGER(unsigned(Bitcount) - 1));
            
        -- Increment bitperiod counter
        else 
      
          -- SIROUT held low till Pulse width if data bit is zero
          if (TXDatabit = '0')then  
             if (Bitperiodcount = PWidth)then
                NextSIROUT <= '1';
                NxtBitperiodcnt <= unsigned(Bitperiodcount) + 1 ;
             else
                NxtBitperiodcnt <= unsigned(Bitperiodcount) + 1 ;
             end if; 
          else    
             NextSIROUT <= '1';
             NxtBitperiodcnt <= unsigned(Bitperiodcount) + 1 ;
          end if; 
        end if;

      -- Transmit Stop bit
      else
        -- Determining actual pulse width for the Stop bit
        if (BITSFTEN = '1')then
          if (((Count = "00000" & PULSENUM  ) and 
             (PULSESHFT /= "000" )) ) then
            ActualPW <= unsigned(ActualBitPeriod) - 
                          unsigned(PULSESHFT) *unsigned(UartBaud) ;
          elsif ((((Count = "00000" & EPNUM)) and (SHFT /= "00")) )then
            ActualPW <= unsigned(ActualBitPeriod) -  unsigned(SHFT) 
                         * unsigned('0' & UartBaud(15 downto 1));
          end if;
        else
          ActualPW <= ActualBitPeriod;
        end if; 

        if (Bitperiodcount = ActualPW) then
                
          -- Stoptbit transmitted fully
          -- Deassert Next Frame Read Pointer increment enable signal
          -- Start Next transmission only if data is available in FIFO
          -- or Read Pointer increment is done
          if ((RdPtrIncDone = '0') or ((TxDataAvlbl = '1') 
              and (iTXFRdPtrInc = '1'))  ) then
            NextStarttx     <= '1';
            NxtBitperiodcnt <= "00000000000000000000";
          else
            NextTXBUSY <= '0'; 
          end if;
          Nextcount       <= "00000000";
          NextTXFRdPtrInc <= '0';
          NextSIROUT      <= '1';

          -- Increment bitperiod counter
          -- Assert Next Frame Read Pointer Increment enable signal
        else
          if (TXDatabit = '0')then
                  
            -- SIROUT held low till Pulse width if data bit is zero 
            if (Bitperiodcount = PWidth)then
              NextSIROUT      <= '1';
              NxtBitperiodcnt <= unsigned(Bitperiodcount) + 1 ;
            else
              NxtBitperiodcnt <= unsigned(Bitperiodcount) + 1 ;
            end if;
          else
            NextSIROUT      <= '1';
            NxtBitperiodcnt <= unsigned(Bitperiodcount) + 1 ;
          end if;

          -- Assert Next Frame Read Pointer Increment enable signal
          -- after Stopbit pulse is transmitted
          if (Bitperiodcount = PWidth)then
            NextTXFRdPtrInc <= '1';
          end if;
        end if;
      end if;

      -- Reinitialize Idle State Settings
    else 
      Nextbitcount    <= "00000000";
      Nextcount       <= "00000000";
      NxtBitperiodcnt <= "00000000000000000000";
      NextStarttx     <= '1';
      NextTXData      <='1';
      NextSIROUT      <= '1';
      NextTXBUSY      <='0';
    end if;
  -- Reinitialize Idle State Settings
  else
    Nextbitcount    <= "00000000";
    NxtBitperiodcnt <="00000000000000000000" ;
    Nextcount       <= "00000000";
    NextStarttx     <= '1';
    NextTXData      <='1';
    NextSIROUT      <= '1';
    NextTXBUSY      <='0';
    NextTXFRdPtrInc <= '0';
  end if;
  
end process p_StateCombo;
--------------------------------------------------------------------------------

end synth;

-- ============================== End  =========================================



