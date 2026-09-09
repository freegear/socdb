-- ========================================================================== 
--  This confidential and proprietary software may be used only as
--  authorised by a licensing agreement from ARM Limited
--    (C) COPYRIGHT 2000 ARM Limited
--        ALL RIGHTS RESERVED
--  The entire notice above must be reproduced on all authorised
--  copies and copies may only be made to the extent permitted
--  by a licensing agreement from ARM Limited.
-----------------------------------------------------------------------------
--  
--  Version and Release Control Information:
--  
--  File Name              : UartTrickInteg.vhd.rca
--  File Revision          : 1.2
--  
--  Release Information    : PrimeCell(TM)-PL011-REL1v3
--  
--------------------------------------------------------------------------------
--  Purpose  : This module is the top level entity of the VHDL  trickbox 
--
-- ========================================================================== --

library IEEE;
use     IEEE.STD_LOGIC_1164.all;

--- ----------------------------------------------------------------------------
entity UartTrickInteg is
  port (
   );
end UartTrickInteg;


-- -----------------------------------------------------------------------------
--
--                                UartTrickInteg
--                                ==============
--
-- -----------------------------------------------------------------------------
--
--  Overview
--  ========
--
--    This block is the top level of the Integration test trickbox. This block
--  instantiates the functional sub-blocks in the trickbox.

--=============================== ARCHITECTURE ===============================--

architecture structural of UartTrickInteg is

-- -----------------------------------------------------------------------------
-- Signal declarations
-- -----------------------------------------------------------------------------

  
--------------------------------------------------------------------------------
-- Component declarations
--------------------------------------------------------------------------------

component UartTrClk
  port (
        PCLK        : in  std_logic;        
        BnRES       : in  std_logic;
        ClkPeriod   : in  std_logic_vector(7 downto 0);  
        UartClk     : out std_logic;        
        PCLKOn      : out std_logic;
        REFCLKOn    : out std_logic;
        RESETBIT    : in  std_logic;       
        RSTMODEREG  : in  std_logic_vector(3 downto 0);
        nUARTRST    : out std_logic       
       );
end  component;


  component UartTrIntLB
    port (
          UARTTXD  	: in   std_logic; 
          nSIROUT       : in   std_logic;
          nUARTOut2	: in   std_logic;
          nUARTOut1	: in   std_logic;
          nUARTRTS	: in   std_logic;
          nUARTDTR	: in   std_logic;
          UARTRXD 	: out  std_logic;
          SIRIN   	: out  std_logic;
          nUARTCTS	: out  std_logic;
          nUARTDCD	: out  std_logic;
          nUARTDSR	: out  std_logic;
          nUARTRI 	: out  std_logic	
          );
  end component;


  uUartTrClk : UartTrClk
  port map (

        PCLK        => PCLK,        
        BnRES       => BnRES,
        ClkPeriod   => ClkPeriod,  
        UartClk     => UartClk,        
        PCLKOn      => PCLKOn,
        REFCLKOn    => REFCLKOn,
        RESETBIT    => RESETBIT,       
        RSTMODEREG  => RSTMODEREG,
        nUARTRST    => nUARTRST
    );


  uUartTrIntLB : UartTrIntLB
  port map (

          UARTTXD  	=> UARTTXD, 
          nSIROUT       => nSIROUT,
          nUARTOut2	=> nUARTOut2,
          nUARTOut1	=> nUARTOut1,
          nUARTRTS	=> nUARTRTS,
          nUARTDTR	=> nUARTDTR,
          UARTRXD 	=> UARTRXD,
          SIRIN   	=> SIRIN,
          nUARTCTS	=> nUARTCTS,
          nUARTDCD	=> nUARTDCD,
          nUARTDSR	=> nUARTDSR,
          nUARTRI 	=> nUARTRI
    );
    
