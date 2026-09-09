-- ========================================================================== --
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
--  File Name              : UartTrBaud.vhd.rca
--  File Revision          : 1.5
--  
--  Release Information    : PrimeCell(TM)-PL011-REL1v3
--  
--- -----------------------------------------------------------------------------
-- Purpose     : This block checks the baud width in different modes 
--
-- ========================================================================== --
  
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

--  ----------------------------------------------------------------------------
entity UartTrBaud is
  port (
        UARTCLK     : in  std_logic;   -- APB Clock
        Mode        : in  std_logic_vector(1 downto 0);  -- Operation Mode
        RXD         : in  std_logic;   -- Receive Data line
        SIRIN       : in  std_logic;   -- Receive data line in Irda mode
        CLKPERIOD   : in  std_logic_vector(7 downto 0);  -- Uart Clk Period
        Divisor     : in  std_logic_vector(15 downto 0); -- Uart Baud rate
        FracDiv     : in  std_logic_vector(5 downto 0); -- Fractional baud rate 
        IRLPDivisor : in  std_logic_vector(7 downto 0);  -- Irda Baud Rate
        FRENABLE    : in  std_logic;   -- Freq Measure Enable 
        FREQERR     : out std_logic   -- Baud  Width in Error
       );
end UartTrBaud;


--------------------------------------------------------------------------------
--
--                   UartTrBaud
--                   ==========
--
--------------------------------------------------------------------------------
--
-- Overview
-- ========
--
--=============================== ARCHITECTURE ===============================-- 
architecture behavioural of UartTrBaud  is

--------------------------------------------------------------------------------
-- Constant declarations
--------------------------------------------------------------------------------
signal JITTER          : time := 2 ns;
-- Allowable jitter in bitwidth

signal CON16           : std_logic_vector(4 downto 0) := "10000";
-- Multiplication Factor for 16 pulses

signal IRDACON3        : std_logic_vector(1 downto 0) := "11";
-- Multiplication Factor fot Irda bitwidth

signal IRDACON13       : std_logic_vector(3 downto 0) := "1101"; 
-- Miltiplication Factor for remaining bit width

signal CON64           : std_logic_vector(6 downto 0) := "1000000";
--------------------------------------------------------------------------------
-- Signal declarations
--------------------------------------------------------------------------------
signal Bitwidth        : time := 0 ns;
-- Acyual Uart bit width

signal TNegEdge        : time := 0 ns;
-- Negedge of Data

signal TPosEdge        : time := 0 ns;
-- Posedge of Data
   
signal LowPulsewidth   : time := 0 ns;
-- Negedge of Data

signal HighPulsewidth  : time := 0 ns;  
-- Pulsewidth of higher level


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
-- Main body of code
-- =================
--
--------------------------------------------------------------------------------

begin
--------------------------------------------------------------------------------
-- This process measures the baud widths in all the modes and sets the  
-- frequency baud error bit. 
--------------------------------------------------------------------------------
  p_Chkcomb : process (RXD, SIRIN, FRENABLE, Mode)
  begin
    -- Calculating Uart bit width 
    if (Divisor /= "UUUUUUUUUUUUUUUU") then
       
       Bitwidth <= (to_integer(unsigned(CON16) * ((unsigned(Divisor) * unsigned(CON64))
                                                         + CONV_INTEGER(unsigned(FracDiv)))  
                * unsigned(CLKPERIOD)) * 1 ns)/64;
    end if;
    -- Checking for baud measure enable
    if (FRENABLE = '1') then

      -- Compare with Uart baud if Trickbox is in normal mode
      -- Checking width of data bit '1' 
      if (Mode = "00")then
        if (RXD'event and RXD = '0') then
          TNegEdge <= now;

          -- Checking whether bitwidth is within the limits allowed 
          -- from actual Uart bitwidth
          if ((TNegEdge > 0 ns) and ( TPosEdge > 0 ns) and
             ((Bitwidth - JITTER) < ( TNegEdge - TPosEdge )) and 
             ((TNegEdge - TPosEdge ) > ( Bitwidth + JITTER)))then
             FREQERR <= '1';
          else
             FREQERR <= '0';
          end if;

        -- Checking width of data bit '0'
        elsif (RXD'event and RXD = '1')then
          TPosEdge <= now;

          -- Checking whether bitwidth is within the limits allowed 
          -- from actual Uart bitwidth
          if ((TNegEdge > 0 ns) and ( TPosEdge> 0 ns) and
             ((Bitwidth - JITTER) <(TPosEdge - TNegEdge )) and 
             ((TPosEdge - TNegEdge ) > ( Bitwidth + JITTER))) then
            FREQERR <= '1';
          else
            FREQERR <= '0';
          end if;
        end if;
      end if;

      -- Compare with Irda baud if Trickbox is in Irda mode 
      if (Mode = "01" or (Mode = "10"))then
        if (Mode = "01") then
          LowPulsewidth <= to_integer(unsigned(IRDACON13) * 
                            (unsigned(Divisor)) * unsigned(CLKPERIOD)) * 1 ns;
          HighPulsewidth <= to_integer(  unsigned(IRDACON3) * 
                            (unsigned(Divisor)) * unsigned(CLKPERIOD)) * 1 ns;
        else
          LowPulsewidth <= Bitwidth -to_integer( unsigned(IRDACON3) 
                    * (unsigned(IRLPDivisor)) * unsigned(CLKPERIOD)) * 1 ns;
          HighPulsewidth <= to_integer( unsigned(IRDACON3) * 
                      (unsigned(IRLPDivisor)) * unsigned(CLKPERIOD)) * 1 ns;
        end if;
        
         -- Checking width of positive pulse 
        if (SIRIN'event and SIRIN = '0') then
          TNegEdge <= now;
          if ((TNegEdge > 0 ns) and ( TPosEdge > 0 ns) and
             ((HighPulsewidth - JITTER) < ( TNegEdge - TPosEdge )) and 
             (( TNegEdge - TPosEdge ) > ( HighPulsewidth + JITTER))) then
            FREQERR <= '1';
          else
            FREQERR <= '0';
          end if;

        -- Checking width of negative pulse 
        elsif (SIRIN'event and SIRIN = '1')then
          TPosEdge <= now;
          if ((TNegEdge > 0 ns) and ( TPosEdge> 0 ns) and
             ((LowPulsewidth - JITTER) <( TPosEdge - TNegEdge )) and 
             ((TPosEdge - TNegEdge ) > ( LowPulsewidth + JITTER))) then
            FREQERR <= '1';
          else
            FREQERR <= '0';
          end if;
        end if;
      end if;
    else 
      TNegEdge <= 0 ns;
      TPosEdge <= 0 ns;
    end if; 

  end process p_ChkComb;         
-------------------------------------------------------------------------------- 
end behavioural;

--========================== End of UartTrBaud  ================================
