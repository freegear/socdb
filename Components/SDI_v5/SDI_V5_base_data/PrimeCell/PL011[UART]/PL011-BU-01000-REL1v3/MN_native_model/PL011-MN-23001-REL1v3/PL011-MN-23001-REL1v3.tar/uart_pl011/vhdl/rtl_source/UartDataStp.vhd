--  ----------------------------------------------------------------------------
--  This confidential and proprietary software may be used only as
--  authorised by a licensing agreement from ARM Limited
--    (C) COPYRIGHT 2000 ARM Limited
--        ALL RIGHTS RESERVED
--  The entire notice above must be reproduced on all authorised
--  copies and copies may only be made to the extent permitted
--  by a licensing agreement from ARM Limited.
--  ----------------------------------------------------------------------------
--  
--  Version and Release Control Information:
--  
--  File Name              : UartDataStp.vhd.rca
--  File Revision          : 1.8
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



entity UartDataStp is
  port (
        UARTCLK      : in  std_logic;      -- Main UART Clock
        nUARTRST     : in  std_logic;	   -- Muxed reset (from nUARTRST)
        
        Baud16       : in  std_logic;	   -- Stream of UARTCLK-wide pulses
        ReloadWD     : in  std_logic;	   -- Control input from Receiver
        
        RXFESync     : in  std_logic;	   -- RX FIFO Empty
        RTIMSync     : in  std_logic;	   -- RX Timeout Intr. Mask
        UARTRTICSync : in  std_logic;	   -- RX Timeout Intr. Clear
        
        DataStp      : out std_logic	   -- Receive Idle detected
        );
end UartDataStp;

architecture synth of UartDataStp is
--  Encoding style: Gray
  signal UartDataStpState, UartDataStpNextState : std_logic_vector(0 downto 0);
  signal NextDataStp     : std_logic;
  signal delUARTRTICSync : std_logic;
  signal UARTRTIClr      : std_logic;
  signal iDataStp        : std_logic;
  
-- Aliases
  signal ReloadCounter   : std_logic;

-- Registers
  signal WDCount, NextWDCount : std_logic_vector(8 downto 0);

-- Comparators
  signal WDCmp           : std_logic;
    
  -- Embedded VHDL declarations...
  ----------------------------------------------------------------------------
  --  Purpose            : This state machine detects an idle on the RX input.
  ----------------------------------------------------------------------------
  --
  ----------------------------------------------------------------------------
  --
  --                             UartDataStp
  --                             ===========
  --
  ----------------------------------------------------------------------------
  -- 
  -- Overview
  -- ========
  --
  -- This block detects the RX line going idle. If the Receive line goes to
  -- HIGH state for more than a 32-bit period and if the Receive FIFO is 
  -- not empty, the receive line is said to have gone idle. This is signalled
  -- by the block output, DataStp. Once set, the DataStp signal goes low
  -- only after the Receive FIFO is empty or the RX line goes active again.
  -- To time the 32-bit period, the watchdog counter, that counts down 
  -- with every Baud16 pulse, is initially loaded with a value of 
  -- (32 * 16) -1 = 511. This uses the fact that one bit period is equal to
  -- 16 times the period of the Baud16 signal.
  ----------------------------------------------------------------------------
begin

-- Expansion of aliases...
  ReloadCounter <= ReloadWD or RXFESync or not(RTIMSync);

-- Expansion of comparators...
  WDCmp <= '1' when WDCount(8 downto 0) = "000000000" else '0';

-- State transition process
  seq : process(UARTCLK, nUARTRST)
  begin
    
-- Set the WDCount to its maximum value of all ones on Reset.
    
    if ((not(nUARTRST)) = '1') then
      UartDataStpState <= "0";
      iDataStp <= '0';
      delUARTRTICSync <= '0';
    elsif (UARTCLK'event and UARTCLK = '1') then
      UartDataStpState <= UartDataStpNextState;
      iDataStp <= NextDataStp;
      delUARTRTICSync <= UARTRTICSync;
    end if;
  end process seq;


  -- Receive timeout interrupt clear signal
  -- signal to clear the interrupt
  UARTRTIClr <= (UARTRTICSync) and not(delUARTRTICSync);

  
-- Output and next state logic generation
  combo : process(UartDataStpState, RXFESync, Baud16, ReloadCounter,
                  WDCount, WDCmp, RTIMSync, UARTRTIClr, iDataStp)
  begin 
    -- Default assignments
    UartDataStpNextState <= UartDataStpState;
    NextDataStp          <= '0';
    NextWDCount          <= WDCount;
    case UartDataStpState is
      -- This is the reset state of this machine. The DataStp signal is
      -- not asserted and the WDCount counter counts down on  every
      -- Baud16 pulse.
      
      when "0" =>

        if ((ReloadCounter) = '1') then
          -- Reload the watchdog counter whenever there is activity on the 
          -- Receive line or when the Receive FIFO is empty.
          NextWDCount          <= "111111111";
          UartDataStpNextState <= "0";

        elsif ((not(ReloadCounter) and Baud16 and not(WDCmp)) = '1')
        then 
          -- Keep the watchdog counter counting down so long as the Receive
          -- FIFO is not empty.
          NextWDCount          <= UNSIGNED(WDCount) - 1;
          UartDataStpNextState <= "0";
          
        elsif ((Baud16 and WDCmp and not(ReloadCounter)) = '1') then
          -- If the watchdog counter has counted down to zero, then assert the
          -- DataStp output signal.
          UartDataStpNextState <= "1";
          NextDataStp          <= '1';
        end if;
        
      when "1" =>
        -- Remain in the S_TRIGGER state till the Receive FIFO contents have been 
        -- read out or until there is activity on the receive line.
        -- If there is a write to the UARTICR or if the RX FIFO is
        -- empty, reload the watchdog counter.
        
        if (UARTRTIClr = '1' or RXFESync = '1' or RTIMSync = '0') then
          NextWDCount          <= "111111111";
          UartDataStpNextState <= "0";
          NextDataStp          <= '0';
        else
          UartDataStpNextState <= UartDataStpState;
          NextDataStp          <= iDataStp;
        end if;
        
      when others =>
        UartDataStpNextState   <= "0";
    end case;
  end process combo;
  
  WDCount_seq : process(UARTCLK, nUARTRST)
  begin
    -- Set the WDCount to its maximum value of all ones on Reset.
    
    if ((not(nUARTRST)) = '1') then
      WDCount <= "111111111";
    elsif (UARTCLK'event and UARTCLK = '1') then
      WDCount <= NextWDCount;
    end if;
  end process WDCount_seq;

  DataStp <= iDataStp;
  
end synth;
--  Signals: UartDataStpState<0:0> UartDataStpNextState<0:0> 
--    ST_ARMED   	0
--    ST_TRIGGER	1
