-- --=================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 2000 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
--
-- ---------------------------------------------------------------------
-- Version and Release Control Information:
--
-- File Name              : apbmux.vhd.rca
-- File Revision          : 1.1
--
-- Release Information    : PrimeCell(TM)-GLOBAL-REL1v3
--
-- ---------------------------------------------------------------------
-- Purpose : APB Data bus multiplexer
--
-- --=================================================================--

library ieee;
use     ieee.std_logic_1164.all;

--#Synth off
library common;
use     common.params.all;
--#Synth on

library sys;
use     sys.all;

entity APBMux is
    port(

         PRDATA      : out   std_ulogic_vector(31 downto 0);

         PWRITE      : in    std_ulogic;
           
         PSELRPC     : in    std_ulogic; -- Reset & Halt
         PSELUUT     : in    std_ulogic; -- Unit Under Test

         PRDATARPC   : in    std_ulogic_vector(15 downto 0);
         PRDATAUUT   : in    std_ulogic_vector(31 downto 0)

         ) ;

end APBMux ;

architecture synth of APBMux is

begin

    PRDATA <= "0000000000000000" & PRDATARPC when 
                            (PSELRPC = '1' and PWRITE = '0') else
              PRDATAUUT when 
                            (PSELUUT = '1' and PWRITE = '0') else
              (others => '0');

               
end synth;

-- --============================== End ==============================--
