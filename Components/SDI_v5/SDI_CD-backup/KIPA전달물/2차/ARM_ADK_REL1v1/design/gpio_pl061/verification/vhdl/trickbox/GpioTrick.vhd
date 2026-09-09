------------------------------------------------------------------------
--  This confidential and proprietary software may be used only as
--  authorised by a licensing agreement from ARM Limited
--    (C) COPYRIGHT 2000 ARM Limited
--        ALL RIGHTS RESERVED
--  The entire notice above must be reproduced on all authorised
--  copies and copies may only be made to the extent permitted
--  by a licensing agreement from ARM Limited.
------------------------------------------------------------------------
--  
--  Version and Release Control Information:
--  
--  File Name              : GpioTrick.vhd.rca
--  File Revision          : 1.2 
--  
--  Release Information    : PrimeCell(TM)-PL061-REL1v0
--  
------------------------------------------------------------------------

------------------------------------------------------------------------
-- Purpose : The Gpio trickbox module performs the following functions:
--           - Generates the input signals for the pins of the Gpio 
--           - Generates the input signals for the Alt. Funct. on-chip
--             signals
--           - Reads the status of the output pins and the output enable
--             pins of the Gpio
--           - Reads the status of the output pins and the output enable
--             pins of the Alt. Funct. on-chip signals       
--           - Reads the combined and individual interrupt outpus from
--             the Gpio.
------------------------------------------------------------------------

library ieee;
use     ieee.std_logic_1164.all;

entity GpioTrick is
  port (
    -- Inputs
    -- APB bus signals
    PCLK      : in   std_logic;                    -- APB Clock
    PRESETn   : in   std_logic;                    -- AMBA reset
    PENABLE   : in   std_logic;                    -- APB enable 
    PSELT     : in   std_logic;                    -- Trickbox select 
    PWRITE    : in   std_logic;                    -- APB write
    PA        : in   std_logic_vector(7 downto 2); -- APB address bus
    PWData    : in   std_logic_vector(7 downto 0); -- APB write databus
    
    -- GPIO lines onto the Pads
    nGPEN     : in   std_logic_vector(7 downto 0); -- GPIO o/p enables
    GPOUT     : in   std_logic_vector(7 downto 0); -- GPIO outputs
    
    -- Alternate functionality lines
    GPAFIN    : in   std_logic_vector(7 downto 0); -- Alt F. inputs
    
    -- Interrupt output to the Interrupt controller
    GPIOINTR  : in   std_logic;                    -- Interrupt output
    GPIOMIS   : in   std_logic_vector(7 downto 0); -- Masked Int Status
    
    -- Outputs
    -- APB bus Output signals
    PRData    : out  std_logic_vector(7 downto 0); -- APB read databus
    
    -- GPIO lines onto the Pads
    GPIN      : out  std_logic_vector(7 downto 0); -- GPIO inputs
    
    -- Alternate functionality lines
    nGPAFEN   : out  std_logic_vector(7 downto 0); -- Alt F. o/p enables
    GPAFOUT   : out  std_logic_vector(7 downto 0)  -- Alt F. outputs
    );
end GpioTrick;

-- ---------------------------------------------------------------------
--
--                             GpioTrick
--                             =========
--
-- ---------------------------------------------------------------------
--
-- Overview
-- ========
-- The external inputs to the GPIO are generated in this module.
-- Inputs to the GPIO are controlled via writes to the appropriate
-- registers within the TrickBox.
-- The Status of the GPIO Outputs are read through the appropriate
-- registers within the TrickBox.
--
-- GTENR   : Represents the status of the GPIO Output Enables  :nGPEN
-- GTOUT   : Represents the status of the GPIO Outputs         :GPOUT
-- GTINR   : Controls via writes the GPIO Inputs               :GPIN
--
-- GTAENR  : Controls the GPIO Alt. Funct. Output Enables      :nGPAFEN
-- GTAOUTR : Controls the GPIO Alt. Funct. Outputs             :GPAFOUT
-- GTAINR  : Represents the status of GPIO Alt. Funct. Inputs  :GPAFIN
--
-- GTINT(0): Represents the status of the Interrupt Output     :GPIOINTR
-- GTMIS   : Represents the status of the Masked Int. Outputs  :GPIOMIS
--
--===========================ARCHITECTURE=============================--
------------------------------------------------------------------------
-- Architecture Packages
------------------------------------------------------------------------

architecture synth of GpioTrick is

------------------------------------------------------------------------
-- Signal declarations
------------------------------------------------------------------------

--======================================= Decodes for internal registers
    
signal GTENRdec       : std_logic;
-- Decode for GTENR register

signal GTOUTdec       : std_logic;
-- Decode for GTOUT register

signal GTINRdec       : std_logic;
-- Decode for GTINR  register

signal GTAENRdec      : std_logic;
-- Decode for GTAENR register

signal GTAOUTRdec     : std_logic;
-- Decode for GTAOUTR register

signal GTAINRdec      : std_logic;
-- Decode for GTAINR register

signal GTMISdec       : std_logic;
-- Decode for GTINT register

signal GTINTdec       : std_logic;
-- Decode for GTINT register


--=========================== Read enable strobes for internal registers

signal GTENRrd        : std_logic;
-- Read enable for GTENR register

signal GTOUTrd        : std_logic;
-- Read enable for GTOUT register

signal GTINRrd        : std_logic;
-- Read enable for GTINR  register

signal GTAENRrd       : std_logic;
-- Read enable for GTAENR register

signal GTAOUTRrd      : std_logic;
-- Read enable for GTAOUTR register

signal GTAINRrd       : std_logic;
-- Read enable for GTAINR register

signal GTMISrd        : std_logic;
-- Read enable for GTINT register

signal GTINTrd        : std_logic;
-- Read enable for GTINT register


--========================== Write enable strobes for internal registers

signal GTINRwr        : std_logic;
-- Write enable for GTINR register

signal GTAENRwr       : std_logic;
-- Write enable for GTAENR register

signal GTAOUTRwr      : std_logic;
-- Write enable for GTAOUTR register


--======================================= D-input for internal registers

signal nextGTINR      : std_logic_vector(7 downto 0);
-- D-input for GTINR register

signal nextGTAENR     : std_logic_vector(7 downto 0);
-- D-input for GTAENR register

signal nextGTAOUTR    : std_logic_vector(7 downto 0);
-- D-input for GTAOUTR register


--===================================================== Internal signals

signal GTINR          : std_logic_vector(7 downto 0);
-- GPIO inputs  

signal GTAENR         : std_logic_vector(7 downto 0);
-- GPIO Alt F. o/p enables 

signal GTAOUTR        : std_logic_vector(7 downto 0);
-- GPIO Alt F. outputs


-- Read Fill Vector
signal ReadFill       : std_logic_vector(7 downto 0);

------------------------------------------------------------------------
--
-- Main body of code
-- =================
--
------------------------------------------------------------------------

begin

-- Assign Read Fill Vector
ReadFill <= (others => '0');

------------------------------------------------------------------------
-- Address Decodes
------------------------------------------------------------------------


GTENRdec  <= '1' when (PA(4 downto 2) = "000") 
          else
             '0';
GTOUTdec  <= '1' when (PA(4 downto 2) = "001") 
          else
             '0';
GTINRdec  <= '1' when (PA(4 downto 2) = "010") 
          else
             '0';
GTAENRdec <= '1' when (PA(4 downto 2) = "011") 
          else
             '0';
GTAOUTRdec<= '1' when (PA(4 downto 2) = "100") 
          else
             '0';
GTAINRdec <= '1' when (PA(4 downto 2) = "101") 
          else
             '0';
GTINTdec  <= '1' when (PA(4 downto 2) = "110") 
          else
             '0';
GTMISdec  <= '1' when (PA(4 downto 2) = "111") 
          else
             '0';


GTENRrd    <= PSELT and PENABLE and (not PWRITE) and GTENRdec;
GTOUTrd    <= PSELT and PENABLE and (not PWRITE) and GTOUTdec;
GTINRrd    <= PSELT and PENABLE and (not PWRITE) and GTINRdec;
GTAENRrd   <= PSELT and PENABLE and (not PWRITE) and GTAENRdec;
GTAOUTRrd  <= PSELT and PENABLE and (not PWRITE) and GTAOUTRdec;
GTAINRrd   <= PSELT and PENABLE and (not PWRITE) and GTAINRdec;
GTINTrd    <= PSELT and PENABLE and (not PWRITE) and GTINTdec;
GTMISrd    <= PSELT and PENABLE and (not PWRITE) and GTMISdec;

GTINRwr    <= PSELT and PENABLE and PWRITE and GTINRdec;
GTAENRwr   <= PSELT and PENABLE and PWRITE and GTAENRdec;
GTAOUTRwr  <= PSELT and PENABLE and PWRITE and GTAOUTRdec;

  
------------------------------------------------------------------------
-- Implementation of TrickBox Input Register GTINR
------------------------------------------------------------------------
p_GTINRComb : process (GTINR, PWData, GTINRwr)
begin
  if (GTINRwr = '1') then
    NextGTINR <= PWData;
  else
    NextGTINR <= GTINR;
  end if;
end process p_GTINRComb;

p_GTINRSeq : process (PCLK, PRESETn)
begin
  if (PRESETn = '0') then
    GTINR <= (others => '0');
  elsif (PCLK'event and PCLK = '1') then
    GTINR <= NextGTINR;
  end if;
end process p_GTINRSeq;

------------------------------------------------------------------------
-- Implementation of TrickBox Input Register GTAENR
------------------------------------------------------------------------
p_GTAENRComb : process (GTAENR, PWData, GTAENRwr)
begin
  if (GTAENRwr = '1') then
    NextGTAENR <= PWData;
  else
    NextGTAENR <= GTAENR ;
  end if;
end process p_GTAENRComb;

p_GTAENRSeq : process (PCLK, PRESETn)
begin
  if (PRESETn = '0') then
    GTAENR <= (others => '0');
  elsif (PCLK'event and PCLK = '1') then
    GTAENR <= NextGTAENR;
  end if;
end process p_GTAENRSeq;

------------------------------------------------------------------------
-- Implementation of TrickBox Input Register GTAOUTR
------------------------------------------------------------------------

p_GTAOUTRComb : process (GTAOUTR, PWData, GTAOUTRwr)
begin
  if (GTAOUTRwr = '1') then
    NextGTAOUTR <= PWData;
  else
    NextGTAOUTR <= GTAOUTR;
  end if;
end process p_GTAOUTRComb;

p_GTAOUTRSeq : process (PCLK, PRESETn)
begin
  if (PRESETn = '0') then
    GTAOUTR <= (others => '0');
  elsif (PCLK'event and PCLK = '1') then
    GTAOUTR <= NextGTAOUTR;
  end if;
end process p_GTAOUTRSeq;

------------------------------------------------------------------------
-- Mux out Read Data onto the APB
------------------------------------------------------------------------
PRData  <= nGPEN                              when (GTENRrd = '1') 
        else
           GPOUT                              when (GTOUTrd = '1')
        else 
           GTINR                              when (GTINRrd = '1')
        else 
           GTAENR                             when (GTAENRrd = '1')
        else 
           GTAOUTR                            when (GTAOUTRrd = '1')
        else
           GPAFIN                             when (GTAINRrd = '1')
        else 
           (ReadFill (7 downto 1) & GPIOINTR) when (GTINTrd = '1')
        else 
           GPIOMIS                            when (GTMISrd = '1')
        else
           ReadFill;



------------------------------------------------------------------------
-- The inputs to the GPIO GPIN are controlled via writes to the GTINR
-- register 
------------------------------------------------------------------------
GPIN     <= GTINR;

------------------------------------------------------------------------
-- The inputs to the GPIO Alt. Funct. Output Enable are controlled via
-- writes to the GTAENR register 
------------------------------------------------------------------------

nGPAFEN  <= GTAENR;

------------------------------------------------------------------------
-- The inputs to the GPIO Alt. Funct. Output are controlled via writes
-- to the GTAOUTR register 
------------------------------------------------------------------------

GPAFOUT  <= GTAOUTR;

end synth;
