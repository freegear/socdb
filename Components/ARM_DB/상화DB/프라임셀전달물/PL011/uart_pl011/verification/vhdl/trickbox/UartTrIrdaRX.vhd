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
--  File Name              : UartTrIrdaRX.vhd.rca
--  File Revision          : 1.5
--
--  Release Information    : PrimeCell(TM)-PL011-REL1v3
--
-- -----------------------------------------------------------------------------
-- Purpose     : This block contains the control logic for the transmit
--               section of Uart
--
-- ===========================================================================--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
 
-- ----------------------------------------------------------------------------- 
entity UartTrIrdaRX is
  port (
        UARTCLK        : in std_logic;  -- Uart Clock
        nUARTRES       : in std_logic;  -- Uart Reset
        FEN            : in std_logic;  -- FIFO Enable
        nSIRIN         : in std_logic;  -- Irda Input
        UARTEN         : in std_logic;  -- Trickbox Enable
        RXFWrDone      : in std_logic;  -- RX FIFO Write Done
        IRLPDivisor    : in std_logic_vector(7 downto 0);  -- IRLP Pulse width
        Mode           : in std_logic_vector(1 downto 0);  -- Mode of Operation
        Divisor        : in std_logic_vector(15 downto 0); -- Uart Baud
        FracDiv        : in std_logic_vector(5 downto 0); -- fraction baud rate
        RxJitterSign   : in std_logic;  -- Denotes Jitter Sign
        RxJitterFactor : in std_logic_vector(1 downto 0); -- Jitter Factor
        WLEN           : in std_logic_vector(1 downto 0); --Data bits per word
        STP2           : in std_logic;  -- Stop bits per frame
        EPS            : in std_logic;  -- Even Parity Select
        PEN            : in std_logic;   -- Parity Enable
        RXFIFOData     : out std_logic_vector(10 downto 0); -- FIFO Write Data
        RXBUSY         : out std_logic; -- Reception Status
        RCVFE          : out std_logic; -- Frame Error
        RCVPE          : out std_logic; -- Parity Error
        RXFWr          : out std_logic -- RXFIFO Write Enable
       );
end UartTrIrdaRX;
--------------------------------------------------------------------------------
--
--                   UartIrdaTrRX
--                   ============
--
--------------------------------------------------------------------------------
--
-- Overview
-- ========
--
--  The control logic for the receive block of Irda recovers data according
--  to the parameters programmed in trickbox line control registers.
--
--=============================== ARCHITECTURE ===============================--
 
architecture synth of UartTrIrdaRX  is
 
--------------------------------------------------------------------------------
-- Constant declarations
--------------------------------------------------------------------------------
constant IRDACON3 : std_logic_vector(1 downto 0):="11";
-- For generating Irda Pulse

constant CON64  : std_logic_vector(6 downto 0) := "1000000";
constant CON128  : std_logic_vector(7 downto 0) := "10000000";
constant CON2  : std_logic_vector(1 downto 0) := "10";
--------------------------------------------------------------------------------
-- Signal declarations
--------------------------------------------------------------------------------

signal RecvData          : std_logic_vector(10 downto 0);
-- Internal temporary register for holding received data

signal Bitcount          :  std_logic_vector(7 downto 0);
-- Denotes the number of bits in the word being received

signal iRXBUSY           : std_logic;
-- Internal version of Trickbox receive busy signal

signal NextRXBUSY        : std_logic;
-- Combinational input for Trickbox receive busy signal

signal NextRXFWr         : std_logic;
-- Combinational input for Receive FIFO frame write signal

signal iRXFWr            : std_logic;
-- Internal version for Receive FIFO frame write signal

signal  NextSamplingtime : std_logic_vector(19 downto 0);
-- Combinational input for sampling time

signal  Samplingtime     : std_logic_vector(19 downto 0);
-- Internal counter denoting the number of Uart clk cycles sampled

signal  Startrx          : std_logic;
-- Denotes reception in progress

signal  UartBaud         : std_logic_vector(22 downto 0);
-- Internal register related with Uart bit width

signal  BaudILPR         : std_logic_vector(15 downto 0);
-- Internal register related with Low power pulse baud rate

signal  ActualbitPeriod  : std_logic_vector(19 downto 0);
-- Denotes actual Uart bit width

signal  Jitter           : std_logic_vector(19 downto 0);
-- Bit width considering RX jitter

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

 signal ActBitPerInt : integer;

signal samplenowIrda : std_logic;

-- -----------------------------------------------------------------------------
-- Function declarations
-- -----------------------------------------------------------------------------
function to_integer (val : std_logic_vector; x : integer := 0)
return integer is
variable return_int, x_tmp : integer;
begin
  return_int := 0;
  x_tmp := 0;
  if x /= 0 then
    x_tmp := 1;
  end if;
  for i in val'range loop
    return_int := return_int + return_int;
    case val(i) is
      when '0' =>     null;
      when '1' =>     return_int := return_int + 1;
      when others =>  return_int := return_int + x_tmp;
    end case;
  end loop;
  return return_int;
end to_integer;
--------------------------------------------------------------------------------
--
-- Main body of  code
-- ==================
--
--------------------------------------------------------------------------------
 
begin

RXBUSY <= iRXBUSY;
RXFWr  <= iRXFWr;

--------------------------------------------------------------------------------
-- State transition process
--------------------------------------------------------------------------------
p_StateSeq : process (UARTCLK, nUARTRES) 
begin
 
  if ((not(nUARTRES)) = '1') then
     Count        <= "00000000";
     Actcount     <= "00000000";
     Samplingtime <= "00000000000000000000";
     iRXFWr       <= '0';
     iRXBUSY      <= '0';
  elsif (UARTCLK'event and UARTCLK = '1') then
    Samplingtime <= NextSamplingtime;
    iRXFWr       <= NextRXFWr ;
    iRXBUSY      <= NextRXBUSY;
    Count        <= NextCount;
    Actcount     <= NextActcount;
  end if;
end process p_StateSeq;

samplenowIrda <= '1' when (Samplingtime = "00000000000000000000")
             else
             '0';

--------------------------------------------------------------------------------
-- Output and next state logic generation
--------------------------------------------------------------------------------
p_StateCombo : process(UARTEN, Mode, Samplingtime, nSIRIN, Divisor, IRLPDivisor,
                       WLEN, EPS, STP2,FracDiv, UartBaud, BaudILPR)
begin
--------------------------------------------------------------------------------
-- Default assignments
-- Determining Actual Uart bit width, Irda pulse widths
--------------------------------------------------------------------------------
 if (Divisor /= "XXXXXXXXXXXXXXXX")then
      UartBaud     <= unsigned(CON64)*unsigned(Divisor) + unsigned(FracDiv);
      ActBitPerInt <= (CONV_INTEGER(unsigned(UartBaud)) * 16) / 64;
 end if;
 if (IRLPDivisor /= "XXXXXXXX")then
    BaudILPR <= (unsigned(IRDACON3) *( unsigned("000000" & IRLPDivisor)));
 end if;
   ActualBitPeriod <= CONV_STD_LOGIC_VECTOR(ActBitPerInt, 20);

 -- Write to FIFO signal asserted till the write is over
 if ((RXFWrDone = '1') and (iRXFWr = '1'))then
    NextRXFWr <= '0';
 else
    NextRXFWr <= iRXFWr;
 end if;

 if ((UARTEN ='1') and ((Mode = "01") or (Mode = "10" ) ) ) then 

   -- Checking for Start bit once trickbox is enabled in Normal mode 
   if ((nSIRIN ='1' ) and (Startrx = '1')) then 
 
     if (RxJitterSign = '0') then
       Jitter <= unsigned(ActualBitPeriod) + 
                 unsigned( "000000" & RxJitterFactor) - 1  ;
     else
       Jitter <=  unsigned(ActualBitPeriod) -  
                  unsigned( "000000" & RxJitterFactor) + 1    ;
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
     Bitcount     <= "00000000";
     NextCount    <="00000000";
     NextActcount <= "00000000"; 
     NextRXBUSY   <= '1'; 
     Startrx      <= '0';
     RecvData     <= "00000000000";
   elsif (StartRx = '1') then
     NextRXBUSY   <= '0';
   end if;
 

   -- Reception in progress
   if (Startrx = '0') then
         
     -- Receiving data bits
     -- Increment bit count,assign the received data according to the
     -- bit received
     -- Initialising next bitperiod counter
     if (Count < Wordcount ) then 
       if (Samplingtime = "00000000000000000000")then   
         RecvData(CONV_INTEGER(unsigned(Count))) <= not(nSIRIN) ;
         NextCount <= unsigned(Count)  + 1;
         NextSamplingtime <= unsigned(ActualBitPeriod) - 1;
     
       -- Increment bit period counter 
       else
         if (Bitcount = "00000000")then
           if (Mode = "01") then
           NextSamplingtime <= unsigned(Jitter) - 
                 unsigned("00000000" & ActualBitPeriod(19 downto 8)) 
                 -  unsigned("000000000" & ActualBitPeriod(19 downto 9)) -1;
             

           else
             NextSamplingtime <= unsigned(Jitter) - 
                                 unsigned("0000" & BaudILPR(7 downto 0)) ;
           end if; 
           Bitcount <= unsigned(Wordcount) + STP2 + PEN ;
         else
           NextSamplingtime <= unsigned(Samplingtime) - 1;
         end if;
       end if;

     -- Receive Parity bit and Stop bit, if they are enabled 
     elsif (Bitcount > Count  ) then  
       if (Samplingtime = "00000000000000000000")then
         RecvData(CONV_INTEGER(unsigned(Actcount))) <= not(nSIRIN); 
         NextSamplingtime <= unsigned(ActualBitPeriod)  - 1;
         NextCount        <= unsigned(Count) + 1;
         NextActcount     <= unsigned(Actcount) +1;
       else
         if ((Count = Wordcount) and (Actcount <= "00000111")) then
           NextActcount <= "00001000";
         end if; 
         NextSamplingtime <= unsigned(Samplingtime) - 1;
       end if;

     -- Receiving Stop bit
     elsif (Bitcount = Count)then
       -- Assign received data to RXFIFO
       if (Samplingtime = "00000000000000000000")then
         RXFIFOData(to_integer(unsigned(Actcount) - 1)downto 0) 
                     <= RecvData(to_integer(unsigned(Actcount)- 1)downto 0);
         RXFIFOData(CONV_INTEGER(unsigned(Actcount))) <= not(nSIRIN);  
         if (Actcount < "00001010")then
           RXFIFOData(10 downto to_integer(unsigned(Actcount)+1)) 
                  <= RecvData(10 downto to_integer(unsigned(Actcount) + 1));
         end if;

         -- Determining Frame Error
         RCVFE <= nSIRIN or (not(RecvData(to_integer(unsigned(Actcount)-1)))
                  and STP2);
         NextSamplingtime <= unsigned(ActualBitPeriod)  - 1;
         NextRXFWr        <= '1';
         Startrx          <= '1';
       else

         -- Determining Parity Error
         RCVPE <= PEN and (RecvData(0) xor  RecvData(1) xor
                  RecvData(2) xor RecvData(3) xor RecvData(4) 
                  xor RecvData(5) xor RecvData(6) xor 
                  RecvData(7) xor RecvData(8)  xor not(EPS)) ;
                    
         if ((Count = Wordcount) and (Actcount <= "00000111")) then
           NextActcount <= "00001000";
         end if; 
         NextSamplingtime <= unsigned(Samplingtime) - 1;
       end if;
     end if;
   end if;
 else
   NextRXBUSY <='1';
   Startrx    <= '1';
 end if;


end process p_StateCombo;
--------------------------------------------------------------------------------
end synth;

-- ============================== End ==========================================

