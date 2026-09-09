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
--  File Name              : UartTrRX.vhd.rca
--  File Revision          : 1.6
--
--  Release Information    : PrimeCell(TM)-PL011-REL1v3
--
-- -----------------------------------------------------------------------------
-- Purpose     : This block contains the control logic for the receive 
--               section of trickbox 
--
-- ===========================================================================--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
 
--  --------------------------------------------------------------------------- 

entity UartTrRX is
  port (
        UARTCLK        : in std_logic;  -- Uart Clock  
        nUARTRES       : in std_logic;  -- Uart Reset
        FEN            : in std_logic;  -- FIFO Enable
        RXD            : in std_logic;  -- Received Data bit
        UARTEN         : in std_logic;  -- Enable Trickbox
        RXFWrDone      : in std_logic;  -- RX FIFO Write Done
        Mode           : in std_logic_vector(1 downto 0); -- Trickbox Mode
        Divisor        : in std_logic_vector(15 downto 0); -- Baud Rate value
        FracDiv        : in std_logic_vector(5 downto 0); -- Fractional baud rate
        RxJitterSign   : in std_logic;  -- Denotes Jitter Sign
        RxJitterFactor : in std_logic_vector(1 downto 0); -- Jitter Factor
        WLEN           : in std_logic_vector(1 downto 0); --Data bits per word
        STP2           : in std_logic;  -- Stop bits per frame
        EPS            : in std_logic;  -- Even Parity Select
        PEN            : in std_logic;  -- Parity Enable
        SPS            : in std_logic;  -- Stick Parity Select
        RXFWr          : out std_logic; -- RXFIFO Write Enable
        RXFIFOData     : out std_logic_vector(10 downto 0);  -- FIFO Data
        RXBUSY         : out std_logic; -- Reception Status
        RCVFE          : out std_logic; -- Frame Error
        RCVPE          : out std_logic  -- Parity Error
       );
end UartTrRX;
 
--------------------------------------------------------------------------------
--
--                   UartTrRX
--                   ========
--
--------------------------------------------------------------------------------
--
-- Overview
-- ========
--
--  The control logic for the receive block of Uart recovers data according
--  to the parameters programmed in trickbox line control registers.
 
--
--=============================== ARCHITECTURE ===============================--
 
architecture synth of UartTrRX  is
 
--------------------------------------------------------------------------------
-- Signal declarations
--------------------------------------------------------------------------------

  constant CON64             : std_logic_vector(6 downto 0) := "1000000";
  -- value 64

  signal RecvData          : std_logic_vector(10 downto 0);
  -- Internal temporary register for holding received data

  signal Bitcount          :  std_logic_vector(7 downto 0);
  -- Denotes the number of bits in the word being received 

  signal iRXFWr            : std_logic;
  -- Internal version for Receive FIFO frame write signal

  signal iRXBUSY           : std_logic;
  -- Internal version of Trickbox receive busy signal

  signal NextRXBUSY        : std_logic;
  -- Combinational input for Trickbox receive busy signal

  signal NextRXFWr         : std_logic;
  -- Combinational input for Receive FIFO frame write signal

  signal  NxtSamplingtime  : std_logic_vector(19 downto 0);
  -- Combinational input for sampling time

  signal  Samplingtime     : std_logic_vector(19 downto 0);
  -- Internal counter denoting the number of Uart clk cycles sampled

  signal  StartRx          : std_logic;
  -- Denotes reception in progress

  signal  UartBaud         : std_logic_vector(22 downto 0);
  -- Internal register related with Uart bit width

  signal  ActualbitPeriod  : std_logic_vector(19 downto 0);
  -- Denotes actual Uart bit width

  signal  NextCount        : std_logic_vector(7 downto 0);
  -- Combinational input for counting the bit being received 
  
  signal  Count            : std_logic_vector(7 downto 0);
  -- Counter denoting the bit being received

  signal  NextActcount     : std_logic_vector(7 downto 0);
  -- Combinational input for the internal counter Actcount  
 
  signal  Actcount         : std_logic_vector(7 downto 0);
  -- To store the parity and stop bits in the higher order nibble

  signal Wordcount         : std_logic_vector(7 downto 0);
  -- Internal register denoting data bits pre word

  signal ActBitPerInt      : integer;
  -- Used in bit period calculation

  signal samplenow         : std_logic;
  -- Signal to show when sampling time is 0

  
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
    RXBUSY <= iRXBUSY;
    RXFWr  <= iRXFWr;
--------------------------------------------------------------------------------
-- State transition process
--------------------------------------------------------------------------------
p_StateSeq : process(UARTCLK, nUARTRES) 
begin
 
  if ((not(nUARTRES)) = '1') then
    Count        <= "00000000";
    Actcount     <= "00000000";
    Samplingtime <= "00000000000000000000";
    iRXFWr       <= '0';
    iRXBUSY      <= '0';
  elsif (UARTCLK'event and UARTCLK = '1') then
    Samplingtime <= NxtSamplingtime;
    iRXFWr       <= NextRXFWr;
    iRXBUSY      <= NextRXBUSY;
    Count        <= NextCount;
    Actcount     <= NextActcount;
  end if;
end process p_StateSeq;

samplenow <= '1' when (Samplingtime = "00000000000000000000")
             else
             '0';

--------------------------------------------------------------------------------
-- Output and next state logic generation
--------------------------------------------------------------------------------
p_StateComb : process(UARTEN, Mode, UartBaud, Samplingtime, RXD, Divisor, 
                       WLEN, EPS, STP2,FracDiv,ActBitPerInt)
begin

--------------------------------------------------------------------------------
-- Default assignments
-- Determining Actual Uart bit width
--------------------------------------------------------------------------------
  if (Divisor /= "UUUUUUUUUUUUUUUU") then
    UartBaud     <= unsigned(CON64)*unsigned(Divisor) + unsigned(FracDiv);
    ActBitPerInt <= (CONV_INTEGER(unsigned(UartBaud)) * 16) / 64;
  end if;
   ActualBitPeriod <= CONV_STD_LOGIC_VECTOR(ActBitPerInt, 20);


  -- Write to FIFO signal asserted till the write is over
  if ((RXFWrDone = '1') and (iRXFWr = '1'))then
    NextRXFWr <= '0';
  else
    NextRXFWr <= iRXFWr;
  end if;

  if (( (UARTEN ='1') and (Mode = "00") ) ) then 
       
    -- Checking for Start bit once trickbox is enabled in Normal mode 
    if ((RXD'event and   RXD = '0' ) and (StartRx = '1')) then 

      -- Determining the sampling time of first data bit 
      if (RxJitterSign = '0') then
        NxtSamplingtime <= unsigned(ActualBitPeriod) + 
                           unsigned('0' & ActualBitPeriod(19 downto 1)) 
                           + unsigned( "000000" & RxJitterFactor)
                             - unsigned("0000" & ActualBitPeriod(19 downto 4)) - 1 ;
      else
        NxtSamplingtime <= unsigned(ActualBitPeriod) + 
                            unsigned('0' & ActualBitPeriod(19 downto 1)) 
                            - unsigned( "000000" & RxJitterFactor)
                            - unsigned("0000" & ActualBitPeriod(19 downto 4)) - 1 ;
      end if;

      -- Determining bits per word and assigning initial conditions 
      case WLEN is
        when "00" => 
          Wordcount <= "00000101";
        when "01" => 
          Wordcount <= "00000110";
        when "10" => 
          Wordcount <= "00000111";
        when "11" => 
          Wordcount <= "00001000";
        when others => 
          Wordcount <= "00000000";
      end case;
      NextCount    <="00000000";
      NextActcount <= "00000000"; 
      NextRXBUSY   <= '1'; 
      StartRx      <= '0';
      RecvData     <= "00000000000";
    elsif (StartRx = '1') then
      NextRXBUSY   <= '0';
    end if;
    -- Reception in progress 
    if (StartRx = '0') then
         
      -- Receiving data bits
      -- Increment bit count,assign the received data according to the
      -- bit received
      -- Initialising next bitperiod counter 
      if (Count < Wordcount ) then 
        if (Samplingtime = "00000000000000000000")then   
          RecvData(CONV_INTEGER(unsigned(Count))) <= RXD ;
          NextCount       <= unsigned(Count)  + 1;
          NxtSamplingtime <= unsigned(ActualBitPeriod) - 1;
        -- Increment bit period counter 
        else
          Bitcount        <= unsigned(Wordcount) + STP2 + PEN ;
          NxtSamplingtime <= unsigned(Samplingtime) - 1;
        end if;
          
      -- Receive Parity bit and Stop bit, if they are enabled 
      elsif (Bitcount > Count) then  
        if (Samplingtime = "00000000000000000000")then
          RecvData(CONV_INTEGER(unsigned(Actcount))) <= RXD  ;
          NxtSamplingtime <= unsigned(ActualBitPeriod)  - 1;
          NextCount       <= unsigned(Count) +1;
          NextActcount    <= unsigned(Actcount) +1;
      -- Store the incoming bits from the 8th position onwards 
        else
          if ((Count = Wordcount) and (Actcount <= "00000111")) then
            NextActcount <= "00001000";
          end if; 
          NxtSamplingtime <= unsigned(Samplingtime) - 1;
        end if;
        -- Receiving Stop bit
      elsif (Bitcount = Count)then
             
        -- Assign received data to RXFIFO
        if (Samplingtime = "00000000000000000000")then
          RXFIFOData(CONV_INTEGER(unsigned(Actcount)- 1)downto 0) <= 
          RecvData(CONV_INTEGER(unsigned(Actcount)- 1)downto 0) ;
          RXFIFOData(CONV_INTEGER(unsigned(Actcount))) <= RXD;
          if (Actcount < "00001010")then
            RXFIFOData(10 downto CONV_INTEGER(unsigned(Actcount)+ 1)) 
                 <= RecvData(10 downto CONV_INTEGER(unsigned(Actcount)+ 1));
          end if;

          -- Determining Frame Error
          RCVFE <= not(RXD) or 
                 (not(RecvData(CONV_INTEGER(unsigned(Actcount) -1)))and STP2);
          NxtSamplingtime <= unsigned(ActualBitPeriod)  - 1;
          NextRXFWr <= '1';
          StartRx <= '1';
        else
          -- Determining Parity Error
          if(SPS= '1') then
            RCVPE <= RecvData(8) xor (not(EPS));
          else
            RCVPE <= PEN and (RecvData(0) xor RecvData(1) xor 
                              RecvData(2) xor RecvData(3) xor RecvData(4) 
                              xor RecvData(5) xor RecvData(6) xor RecvData(7) 
                              xor RecvData(8)  xor not(EPS)) ;
          end if;
          -- Store the incoming bits from the 8th position onwards
          if ((Count = Wordcount) and (Actcount <= "00000111")) then
            NextActcount <= "00001000";
          end if; 
          NxtSamplingtime <= unsigned(Samplingtime) - 1;
        end if;
      end if;
    end if;
  -- Initialise idle stata settings
  else
    NextRXBUSY <='0';
    StartRx <= '1';
  end if;

end process p_StateComb;
--------------------------------------------------------------------------------

end synth;

-- ============================== End  =========================================
