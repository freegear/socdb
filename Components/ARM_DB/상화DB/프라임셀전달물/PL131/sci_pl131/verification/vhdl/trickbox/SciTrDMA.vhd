-- --=========================================================================--
--  This confidential and proprietary software may be used only as
--  authorised by a licensing agreement from ARM Limited
--    (C) COPYRIGHT 2001 ARM Limited
--        ALL RIGHTS RESERVED
--  The entire notice above must be reproduced on all authorised
--  copies and copies may only be made to the extent permitted
--  by a licensing agreement from ARM Limited.
--  ----------------------------------------------------------------------------
--
--  Version and Release Control Information:
--
--  File Name              : SciTrDMA.vhd.rcaS
--  File Revision          : 1.1
--
--  Release Information    : PrimeCell(TM)-PL131-REL1v0
--
--  ----------------------------------------------------------------------------
 
--  ----------------------------------------------------------------------------
--  Purpose : This block generates the SCIDMACLR signals
-- --=========================================================================--


library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;


entity SciTrDMA is
   port (
      PCLK              : in    std_logic; -- APB Clock
      PRESETn           : in    std_logic; -- Muxed Reset (from PRESETn)
      SCITXDMACLRStag1	: in    std_logic; -- 1st stage for SCITXDMACLR
      SCIRXDMACLRStag1	: in    std_logic; -- 1st stage for SCIRXDMACLR
      SCITXDMACLR	: out   std_logic; -- Transmit DMA request clear
      SCIRXDMACLR	: out   std_logic; -- Receive DMA request clear
      SCITXDMACLRStag2	: out   std_logic; -- For SCITXDMACLR
      SCIRXDMACLRStag2	: out   std_logic  -- For SCIRXDMACLR
   );
end SciTrDMA;

-- -----------------------------------------------------------------------------
--
--                   SciTrDMA
--                   =========
--
-- -----------------------------------------------------------------------------
-- Overview
-- ========
-- This module generates the SCITXDMACLR and SCIRXDMACLR signals.
-- These are used to test the Sci DMA interface.

architecture structural of SciTrDMA is
  
signal iSCITXDMACLRStag2 : std_logic;
signal iSCIRXDMACLRStag2 : std_logic;
signal TXDMACLRStag3	 : std_logic;
signal RXDMACLRStag3	 : std_logic;

begin

SCITXDMACLRStag2 <= iSCITXDMACLRStag2;
SCIRXDMACLRStag2 <= iSCIRXDMACLRStag2;

-- -----------------------------------------------------------------------------
-- Sequential process for registers/flip-flops in this block
-- -----------------------------------------------------------------------------
p_Seq : process (PCLK,PRESETn)
begin
   if PRESETn = '0' then
      iSCITXDMACLRStag2	 <= '0';
      TXDMACLRStag3	 <= '0';
      iSCIRXDMACLRStag2	 <= '0';
      RXDMACLRStag3	 <= '0';
   elsif PCLK'event and PCLK = '1' then
      iSCITXDMACLRStag2	 <= SCITXDMACLRStag1;
      TXDMACLRStag3	 <= iSCITXDMACLRStag2;
      iSCIRXDMACLRStag2	 <= SCIRXDMACLRStag1;
      RXDMACLRStag3	 <= iSCIRXDMACLRStag2;
   end if;
end process p_Seq;

-- ------------------------------------------------------------------
-- SCITXDMACLR is a two PCLK-wide pulse used to clear the
-- SCITXDMA requests.
-- ------------------------------------------------------------------

SCITXDMACLR	 <= (SCITXDMACLRStag1 and not iSCITXDMACLRStag2
                     and not TXDMACLRStag3)  or (SCITXDMACLRStag1 and
                     iSCITXDMACLRStag2 and not TXDMACLRStag3);

-- ------------------------------------------------------------------
-- SCIRXDMACLR is a two PCLK-wide pulse used to clear the
-- SCIRXDMA requests.
-- ------------------------------------------------------------------

SCIRXDMACLR	 <= (SCIRXDMACLRStag1 and not iSCIRXDMACLRStag2
                     and not RXDMACLRStag3)  or (SCIRXDMACLRStag1 and
                    iSCIRXDMACLRStag2 and not RXDMACLRStag3);

end structural;
