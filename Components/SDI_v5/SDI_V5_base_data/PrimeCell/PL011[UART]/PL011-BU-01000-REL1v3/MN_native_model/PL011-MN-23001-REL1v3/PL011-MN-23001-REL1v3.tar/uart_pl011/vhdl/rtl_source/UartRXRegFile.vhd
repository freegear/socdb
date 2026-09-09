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
--  File Name              : UartRXRegFile.vhd.rca
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


entity UartRXRegFile is
  port (
        PCLK        : in  std_logic;      -- APB Clock
        PRESETn     : in  std_logic;      -- AMBA Bus reset
        
        RegFileWrEn : in  std_logic;      -- Write Enable
        WrPtr       : in  std_logic_vector(3 downto 0);
	                                  -- Write Pointer
        RdPtr       : in  std_logic_vector(3 downto 0);
                                          -- Read Pointer
        RXFIFOData  : in  std_logic_vector(11 downto 0);
	                                  -- Write data
        
        RXFRdData   : out std_logic_vector(11 downto 0)
                                          -- Read data
        );
end UartRXRegFile;

--------------------------------------------------------------------------------
-- Purpose     : This block contains the Register file for the Receive FIFO
--------------------------------------------------------------------------------
--
--------------------------------------------------------------------------------
--
--                   UartRXRegFile
--                   =============
--
--------------------------------------------------------------------------------
--
-- Overview
-- ========
--
--  This block contains an array of flipflops that serve as the storage register
-- file for the receive FIFO. 
--
--=============================== ARCHITECTURE ===============================--
--
--------------------------------------------------------------------------------
-- Architecture Packages
--------------------------------------------------------------------------------

architecture synth of UartRXRegFile  is

--------------------------------------------------------------------------------
-- Component Declaration
--------------------------------------------------------------------------------
  
--------------------------------------------------------------------------------
-- Internal Constants
--------------------------------------------------------------------------------
  
--------------------------------------------------------------------------------
-- Internal Types
--------------------------------------------------------------------------------
  type t_RegFile is array (15 downto 0)  of std_logic_vector(11 downto 0);
  -- Array of 12-bit wide elements, 16-deep

--------------------------------------------------------------------------------
-- Internal Signals
--------------------------------------------------------------------------------
  signal RXRegFile     :  t_RegFile;
  -- Register File 12-bits wide, 16-deep

  signal NextRXRegFile :  t_RegFile;
  -- D-inputs of Register File 12-bits wide, 16-deep

--------------------------------------------------------------------------------
--
-- Main VHDL code
-- ==============
--
--------------------------------------------------------------------------------

begin
--------------------------------------------------------------------------------
-- Register array
--------------------------------------------------------------------------------
  p_Seq : process(PCLK, PRESETn)
  begin
    if (PRESETn = '0') then
      RXRegFile <= (others => (others => '0'));
    elsif(PCLK'event and PCLK = '1') then
        RXRegFile  <= NextRXRegFile ;
    end if;
  end process p_Seq;


--------------------------------------------------------------------------------
-- Write logic
--------------------------------------------------------------------------------

  p_WrComb : process(RXRegFile,RegFileWrEn,RXFIFOData,WrPtr) 
  begin
    NextRXRegFile <= RXRegFile;

    if(RegFileWrEn = '1') then                
      case WrPtr is
        when "0000" => 
          NextRXRegFile(0)  <= RXFIFOData;
        when "0001" => 
          NextRXRegFile(1)  <= RXFIFOData;
        when "0010" => 
          NextRXRegFile(2)  <= RXFIFOData;
        when "0011" => 
          NextRXRegFile(3)  <= RXFIFOData;
        when "0100" => 
          NextRXRegFile(4)  <= RXFIFOData;
        when "0101" => 
          NextRXRegFile(5)  <= RXFIFOData;
        when "0110" => 
          NextRXRegFile(6)  <= RXFIFOData;
        when "0111" => 
          NextRXRegFile(7)  <= RXFIFOData;
        when "1000" => 
          NextRXRegFile(8)  <= RXFIFOData;
        when "1001" => 
          NextRXRegFile(9)  <= RXFIFOData;
        when "1010" => 
          NextRXRegFile(10) <= RXFIFOData;
        when "1011" => 
          NextRXRegFile(11) <= RXFIFOData;
        when "1100" => 
          NextRXRegFile(12) <= RXFIFOData;
        when "1101" => 
          NextRXRegFile(13) <= RXFIFOData;  
        when "1110" => 
          NextRXRegFile(14) <= RXFIFOData;  
        when "1111" => 
          NextRXRegFile(15) <= RXFIFOData;
        when others => 
          null; 
      end case;
    end if;
  end process p_WrComb;

--------------------------------------------------------------------------------
-- Read Mux
--------------------------------------------------------------------------------
  RXFRdData <= RXRegFile(0)  when (RdPtr = "0000") 
               else
               RXRegFile(1)  when (RdPtr = "0001") 
               else
               RXRegFile(2)  when (RdPtr = "0010") 
               else
               RXRegFile(3)  when (RdPtr = "0011") 
               else
               RXRegFile(4)  when (RdPtr = "0100") 
               else
               RXRegFile(5)  when (RdPtr = "0101") 
               else
               RXRegFile(6)  when (RdPtr = "0110") 
               else
               RXRegFile(7)  when (RdPtr = "0111") 
               else
               RXRegFile(8)  when (RdPtr = "1000") 
               else
               RXRegFile(9)  when (RdPtr = "1001") 
               else
               RXRegFile(10) when (RdPtr = "1010") 
               else
               RXRegFile(11) when (RdPtr = "1011") 
               else
               RXRegFile(12) when (RdPtr = "1100") 
               else
               RXRegFile(13) when (RdPtr = "1101") 
               else
               RXRegFile(14) when (RdPtr = "1110") 
               else
               RXRegFile(15) when (RdPtr = "1111") 
               else
               (others => '0');
end synth;

--========================== End of UartRXRegFile ============================--











