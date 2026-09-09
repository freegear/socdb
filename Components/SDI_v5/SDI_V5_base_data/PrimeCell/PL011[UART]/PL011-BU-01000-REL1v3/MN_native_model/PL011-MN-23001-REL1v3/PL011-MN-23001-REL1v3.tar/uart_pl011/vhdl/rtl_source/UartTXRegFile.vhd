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
--  File Name              : UartTXRegFile.vhd.rca
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

entity UartTXRegFile is
  port (
        PCLK	    : in  std_logic;      -- APB Clock
        PRESETn     : in  std_logic;      -- AMBA bus reset
        
        RegFileWrEn : in  std_logic;      -- Register file write enable
        WrPtr	    : in  std_logic_vector(3 downto 0);
                                          -- Write pointer
        RdPtr       : in  std_logic_vector(3 downto 0);
                                          -- Read pointer
        PWDATAIn    : in  std_logic_vector(7 downto 0);
                                          -- Data bus
        
        iTXFIFOData : out std_logic_vector(7 downto 0)
                                          -- Read data
        );
end UartTXRegFile;

--------------------------------------------------------------------------------
-- Purpose     : This block contains the Register file for the Transmit FIFO
--------------------------------------------------------------------------------
--
--------------------------------------------------------------------------------
--
--                   UartTXRegFile
--                   =============
--
--------------------------------------------------------------------------------
--
-- Overview
-- ========
--
--  This block contains an array of flipflops that serve as the storage register
-- file for the transmit FIFO.
--
--=============================== ARCHITECTURE ===============================--
--
--------------------------------------------------------------------------------
-- Architecture Packages
--------------------------------------------------------------------------------

architecture synth of UartTXRegFile  is

--------------------------------------------------------------------------------
-- Component Declaration
--------------------------------------------------------------------------------
  
--------------------------------------------------------------------------------
-- Internal Constants
--------------------------------------------------------------------------------
  
--------------------------------------------------------------------------------
-- Internal Types
--------------------------------------------------------------------------------
  type t_RegFile is array ( 15 downto 0) of std_logic_vector(7 downto 0);
  -- Array of 8-bit wide elements, 16-deep

--------------------------------------------------------------------------------
-- Internal Signals
--------------------------------------------------------------------------------
  signal TXRegFile       : t_RegFile;
  -- Register File 8-bits wide, 16-deep

  signal NextTXRegFile   : t_RegFile;
  -- D-inputs of Register File 8-bits wide, 16-deep

--------------------------------------------------------------------------------
--
-- Main VHDL code
-- ==============
--
--------------------------------------------------------------------------------

begin

  p_Seq : process(PCLK, PRESETn)
  begin
    if (PRESETn = '0') then
      TXRegFile <= (others => (others => '0'));
    elsif (PCLK'event and PCLK = '1') then
      TXRegFile <= NextTXRegFile;
    end if;
  end process p_Seq;

--------------------------------------------------------------------------------
-- Write logic
--------------------------------------------------------------------------------
  p_WrPtrComb : process(WrPtr,PWDATAIn,RegFileWrEn,TXRegFile)
  begin
    NextTXRegFile <= TXRegFile; 
    
    if(RegFileWrEn = '1') then
      case WrPtr is
        when "0000" =>     
          NextTXRegFile(0)  <= PWDATAIn;
        when "0001" =>     
          NextTXRegFile(1)  <= PWDATAIn;
        when "0010" =>
          NextTXRegFile(2)  <= PWDATAIn;
        when "0011" =>
          NextTXRegFile(3)  <= PWDATAIn;
        when "0100" =>
          NextTXRegFile(4)  <= PWDATAIn;
        when "0101" =>
          NextTXRegFile(5)  <= PWDATAIn;
        when "0110" =>
          NextTXRegFile(6)  <= PWDATAIn;
        when "0111" =>
          NextTXRegFile(7)  <= PWDATAIn;
        when "1000" =>
          NextTXRegFile(8)  <= PWDATAIn;
        when "1001" =>
          NextTXRegFile(9)  <= PWDATAIn;
        when "1010" =>
          NextTXRegFile(10) <= PWDATAIn;
        when "1011" =>
          NextTXRegFile(11) <= PWDATAIn;
        when "1100" =>
          NextTXRegFile(12) <= PWDATAIn;
        when "1101" =>
          NextTXRegFile(13) <= PWDATAIn;
        when "1110" =>
          NextTXRegFile(14) <= PWDATAIn;
        when "1111" =>
          NextTXRegFile(15) <= PWDATAIn;
        when others =>
          null;    
      end case;
    end if;
  end process p_WrPtrComb;

--------------------------------------------------------------------------------
-- Read Mux
--------------------------------------------------------------------------------
  iTXFIFOData <= TXRegFile(0)  when (RdPtr = "0000") 
                 else
                 TXRegFile(1)  when (RdPtr = "0001") 
                 else
                 TXRegFile(2)  when (RdPtr = "0010") 
                 else
                 TXRegFile(3)  when (RdPtr = "0011") 
                 else
                 TXRegFile(4)  when (RdPtr = "0100") 
                 else
                 TXRegFile(5)  when (RdPtr = "0101") 
                 else
                 TXRegFile(6)  when (RdPtr = "0110") 
                 else
                 TXRegFile(7)  when (RdPtr = "0111") 
                 else
                 TXRegFile(8)  when (RdPtr = "1000") 
                 else
                 TXRegFile(9)  when (RdPtr = "1001") 
                 else
                 TXRegFile(10) when (RdPtr = "1010") 
                 else
                 TXRegFile(11) when (RdPtr = "1011") 
                 else
                 TXRegFile(12) when (RdPtr = "1100") 
                 else
                 TXRegFile(13) when (RdPtr = "1101") 
                 else
                 TXRegFile(14) when (RdPtr = "1110") 
                 else
                 TXRegFile(15) when (RdPtr = "1111") 
                 else
                 (others => '0');
end synth;

--========================== End of UartTXRegFile ============================--













