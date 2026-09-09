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
-- File Name              : AaciTrRegBlk.vhd.rca
-- File Revision          : 1.3
--
-- Release Information    : PrimeCell(TM)-PL041-REL1v0
--
-- ---------------------------------------------------------------------
-- Purpose :
--           This block contains the Registers in the AACI Trickbox
--
-- --=================================================================--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

use work.AaciTrPackage.all;

-- ---------------------------------------------------------------------

entity AaciTrRegBlk is
  port (
-- Inputs
        PCLK             : in    std_logic; -- APB bus clock
        PRESETn          : in    std_logic; -- APB bus Reset
        PWDataIn         : in    std_logic_vector(31 downto 0);
                                            -- Int PWDATA
        AACITSYNCWr      : in    std_logic; -- WrEn for AACITrSYNC
        AACITRRESETWr    : in    std_logic; -- WrEn for AACITrRESET
        AACITRDMAWr      : in    std_logic; -- WrEn for AACITrDMAReg
        AACITRBTCLKWr    : in    std_logic; -- WrEn for AACITrBtClkPrd
        AACITRCLKWr      : in    std_logic; -- WrEn for AACITrClkReg
        AACITRCNTRLWr    : in    std_logic; -- WrEn for AACITrCntrlReg

-- Outputs
        -- Control outputs to other submodules
        AACITrEn         : out   std_logic; -- Trickbox enable
        AACITrWidChkEn   : out   std_logic; -- Data width Check enable
        AACITrTxEn       : out   std_logic; -- Transmission enable
        AACITrRxEn       : out   std_logic; -- Reception enable
        AACITrBtClkE     : out   std_logic; -- BITCLK enable
        AACITrBtClkRst   : out   std_logic; -- BITCLK domain reset
        AACITrWintGen    : out   std_logic; -- AACISDATAOUT line in 
                                            -- absense of BITCLK
        AACITrBtClkPrd   : out   std_logic_vector(15 downto 0);
                                            -- BITCLK Period
        AACITrClkReg     : out   std_logic_vector(2 downto 0);
                                            -- BITCLK clock control reg
        AACITrDMAReg     : out   std_logic_vector(6 downto 5);
                                            -- FIFO Status
        FORCEDRESET      : out   std_logic; -- Reset Register
        FORCEDSYNC       : out   std_logic; -- Sync Register

        AACIDMACLRRX     : out   std_logic; -- DMA Rx request clear
        AACIDMACLRTX     : out   std_logic  -- DMA Tx request clear
       );
end AaciTrRegBlk;

-- ---------------------------------------------------------------------
--
--                            AaciTrRegBlk
--                            ============
--
-- ---------------------------------------------------------------------
--
-- Overview
-- ========
--   This block contains the registers in the AACI Trickbox. The
-- writable registers are AACITrCntlReg, AACITrBtClkPrd, AACITrSYNC,
-- AACITrRESET, AACITrTxFIFO(AACITrTxWdata), AACITrRxCR1, AACITrRxCR2,
-- AACITrRxCR3 and AACITrRxCR4 and AACITrDMAReg. Out of these, writes
-- to AACITrTxWdata go to the Transmit FIFO register. The contents of
-- AACITrCntlReg which are used in the AC link side are double
-- synchronised to the BITCLK domain.
--   The write to these registers is done in this module and the
-- contents of the registers are made available to the APB interface for
-- register reads. The contents of the registers are routed to the
-- various modules in the trickbox.
--
-- ---------------------------------------------------------------------

-- --========================= ARCHITECTURE ==========================--

architecture behavioural of AaciTrRegBlk is

-- ---------------------------------------------------------------------
-- Constant declarations
-- ---------------------------------------------------------------------

-- ---------------------------------------------------------------------
-- Signal declarations
-- ---------------------------------------------------------------------
-- Internal versions of the registers
signal iAACITrCntlReg   : std_logic_vector(6 downto 0);
-- Control Register

signal iAACITrBClkPrd   : std_logic_vector(15 downto 0);
-- Bit clock period Reg.

signal iAACITrClkReg    : std_logic_vector(2 downto 0);
-- Bit clock control

signal iAACITrDMAReg    : std_logic_vector(6 downto 5);
-- DMA request capture & clear Reg

signal iAACITrRESET     : std_logic;
-- Reset Register

signal iAACITrSYNC      : std_logic;
-- Sync Register

-- D inputs for the above registers
signal NxtAACITrCntlReg : std_logic_vector(6 downto 0);
-- Control Register

signal NxtBtClkPrd  : std_logic_vector(15 downto 0);
-- Bit clock period Reg.

signal NxtAACITrClkReg  : std_logic_vector(2 downto 0);
-- Bit clock period Reg.

signal NxtAACITrDMAReg  : std_logic_vector(6 downto 5);
-- DMA clear bits of DMA reg

signal NxtAACITrRESET   : std_logic;
-- Reset Register

signal NxtAACITrSYNC    : std_logic;
-- Sync Register

-- ---------------------------------------------------------------------
-- Function declarations
-- ---------------------------------------------------------------------

-- ---------------------------------------------------------------------
--
-- Main body of code
-- =================
--
-- ---------------------------------------------------------------------

begin

-- ---------------------------------------------------------------------
-- The DMA ports are assigned with the values written to the DMA
-- register.
-- ---------------------------------------------------------------------
AACIDMACLRRX     <= iAACITrDMAReg(5) after Tdclrrx;
AACIDMACLRTX     <= iAACITrDMAReg(6) after Tdclrtx;

-- ---------------------------------------------------------------------
-- The following block assigns the different bits in the control reg
-- ---------------------------------------------------------------------
AACITrEn         <= iAACITrCntlReg(0);
AACITrWidChkEn   <= iAACITrCntlReg(1);
AACITrTxEn       <= iAACITrCntlReg(2);
AACITrRxEn       <= iAACITrCntlReg(3);
AACITrBtClkE     <= iAACITrCntlReg(4);
AACITrBtClkRst   <= iAACITrCntlReg(5);
AACITrWintGen    <= iAACITrCntlReg(6);

-- ---------------------------------------------------------------------
-- Connect local copies to output signals
-- ---------------------------------------------------------------------
AACITrBtClkPrd   <= iAACITrBClkPrd;
AACITrClkReg     <= iAACITrClkReg;
AACITrDMAReg     <= iAACITrDMAReg;

-- ---------------------------------------------------------------------
-- Drive the values written into the AACITrRESET register and the
-- AACITrSYNC register onto the FORCEDRESET, FORCEDSYNC outputs.
-- ---------------------------------------------------------------------
FORCEDRESET      <= iAACITrRESET;
FORCEDSYNC       <= iAACITrSYNC;

-- ---------------------------------------------------------------------
-- Clocked process for the registers in this block.
-- ---------------------------------------------------------------------
p_RegSeq: process (PCLK, PRESETn)
begin
  if (PRESETn = '0') then
    iAACITrCntlReg   <= "0100000";
    iAACITrBClkPrd   <= (others => '0');
    iAACITrClkReg    <= (others => '0');
    iAACITrDMAReg    <= (others => '0');
    iAACITrRESET     <= '1';
    iAACITrSYNC      <= '0';
  elsif (PCLK'event and PCLK = '1') then
    iAACITrCntlReg   <= NxtAACITrCntlReg;
    iAACITrBClkPrd   <= NxtBtClkPrd;
    iAACITrClkReg    <= NxtAACITrClkReg;
    iAACITrDMAReg    <= NxtAACITrDMAReg;
    iAACITrRESET     <= NxtAACITrRESET;
    iAACITrSYNC      <= NxtAACITrSYNC;
  end if;
end process p_RegSeq;

-- ---------------------------------------------------------------------
-- Write interface for First stage buffer.
-- Write into the First stage buffers from the Data bus when the
-- corresponding write enable signal is asserted.
-- ---------------------------------------------------------------------
p_RegComb: process (AACITSYNCWr, AACITRRESETWr, AACITRDMAWr,
                    AACITRBTCLKWr, AACITRCLKWr, AACITRCNTRLWr,
                    iAACITrCntlReg, iAACITrBClkPrd, iAACITrClkReg,
                    iAACITrDMAReg, iAACITrRESET, iAACITrSYNC,
                    PWDataIn)
begin
  if (AACITRCNTRLWr = '1') then
    NxtAACITrCntlReg <= PWDataIn(6 downto 0);
  else
    NxtAACITrCntlReg <= iAACITrCntlReg;
  end if;

  if (AACITRDMAWr = '1') then
    NxtAACITrDMAReg  <= PWDataIn(6 downto 5);
  else
    NxtAACITrDMAReg  <= iAACITrDMAReg(6 downto 5);
  end if;

  if (AACITRBTCLKWr = '1') then
    NxtBtClkPrd      <= PWDataIn(15 downto 0);
  else
    NxtBtClkPrd      <= iAACITrBClkPrd;
  end if;

  if (AACITRCLKWr = '1') then
    NxtAACITrClkReg  <= PWDataIn(2 downto 0);
  else
    NxtAACITrClkReg  <= iAACITrClkReg(2 downto 0);
  end if;

  if (AACITRRESETWr = '1') then
    NxtAACITrRESET   <= PWDataIn(0);
  else
    NxtAACITrRESET   <= iAACITrRESET;
  end if;

  if (AACITSYNCWr = '1') then
    NxtAACITrSYNC    <= PWDataIn(0);
  else
    NxtAACITrSYNC    <= iAACITrSYNC;
  end if;

end process p_RegComb;

end behavioural;

-- --=========================== End =================================--
