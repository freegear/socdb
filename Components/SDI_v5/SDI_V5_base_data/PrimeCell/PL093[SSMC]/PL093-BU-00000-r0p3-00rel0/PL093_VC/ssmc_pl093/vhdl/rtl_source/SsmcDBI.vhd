-- --=========================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 2003 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
--
-- -----------------------------------------------------------------------------
-- Version and Release Control Information:
--
-- File Name              : SsmcDBI.vhd.rca
-- File Revision          : 1.8
--
-- Release Information    : PrimeCell(TM)-PL093-r0p3-00rel0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           This block does arbitration between TIC request and SsmcCore
--           request.
--
-- --=========================================================================--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

-- -----------------------------------------------------------------------------

entity SsmcDBI is
  port (
-- Inputs
        HCLK             : in    std_logic; -- AHB Clock
        HRESETn          : in    std_logic; -- AHB system level Reset
        SMTICBUSGNTExt   : in    std_logic; -- External bus granted for TIC
                                            -- Transfer
        SMBUSGNTExt      : in    std_logic; -- External bus granted for Memory
                                            -- Transfer
        SmBusBackOffExt  : in    std_logic; -- BackOff indication from EBI
        BUSMUXEXT        : in    std_logic; -- Indication to either use Internal
                                            -- DBI or External EBI
        SMBUSREQ         : in    std_logic; -- Internal Bus Request from Memory
                                            -- TSM to DBI
        TICBUSREQ        : in    std_logic; -- Internal Bus Request from TIC to
                                            -- DBI
        TBUSOUT          : in    std_logic_vector(31 downto 0);
                                            -- TIC output Data bus
        TICREAD          : in    std_logic; -- Pad enable from TIC
        SmDataEnCore     : in    std_logic_vector(3 downto 0);
                                            -- Data Enables when Write is
                                            -- progressing
        SmDataOutCore    : in    std_logic_vector(31 downto 0);
                                            -- Data Bus output from SSMC
-- Outputs
        SMBUSREQExt      : out   std_logic; -- Request EBI for Memory Transfer
        SMTICBUSREQExt   : out   std_logic; -- Request EBI for TIC Transfer
        SMDATAOUT        : out   std_logic_vector(31 downto 0);
                                            -- Data Bus output from SSMC
                                            -- to Memory
        nSMDATAEN        : out   std_logic_vector(3 downto 0);
                                            -- Tri-state I/O pad enable for
                                            -- the byte lanes of external
                                            -- memory data bus
        TICBUSGNT        : out   std_logic; -- Bus Grant to TIC from DBI
        SMBUSGNT         : out   std_logic  -- Bus Grant to SsmcCore from DBI
       );
end SsmcDBI;

-- -----------------------------------------------------------------------------
--
--                                   SsmcDBI
--                                   =======
--
-- -----------------------------------------------------------------------------
--
-- Overview
-- ========
--          This module is responsible for carrying out Arbitration between
--          TIC and SsmcCore modules. The control signals are appropriately
--          multiplexed based on whether TIC or SsmcCore is granted.
--
-- -----------------------------------------------------------------------------

-- --============================== ARCHITECTURE =============================--

architecture synth of SsmcDBI is

-- -----------------------------------------------------------------------------
-- Component declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Constant declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Signal declarations
-- -----------------------------------------------------------------------------
signal TICBUSGNTdbi     : std_logic;
-- TIC is granted when using DBI

signal NextTICBUSGNT    : std_logic;
-- D-Input of TICBUSGNTdbi register

signal SMBUSGNTdbi      : std_logic;
-- SSMCCore is granted when using DBI

signal iSMBUSGNT        : std_logic;
-- Internal version of SMBUSGNT

signal NextSMBUSGNT     : std_logic;
-- D-Input of iSMBUSGNT register

signal iTICBUSGNT       : std_logic;
-- Internal version of TICBUSGNT

-- -----------------------------------------------------------------------------
-- Function declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
--
-- Main body of code
-- =================
--
-- -----------------------------------------------------------------------------

begin

-- -----------------------------------------------------------------------------
-- Internal Signal Assignments
-- -----------------------------------------------------------------------------
SMBUSGNT  <= iSMBUSGNT;
TICBUSGNT <= iTICBUSGNT;

-- -----------------------------------------------------------------------------
-- Multiplexer to choose between the internal DBI and the external EBI for bus
-- arbitration. When External EBI is used then this Mux selects the Grant from
-- external EBI. If internal DBI is used then the Grant is selected from this
-- module.
-- -----------------------------------------------------------------------------
SMBUSREQExt      <= SMBUSREQ when (BUSMUXEXT = '1')
                 else
                    '0';

SMTICBUSREQExt   <= TICBUSREQ when (BUSMUXEXT = '1')
                 else
                    '0';

iTICBUSGNT       <= SMTICBUSGNTExt when (BUSMUXEXT = '1')
                 else
                    TICBUSGNTdbi;

iSMBUSGNT        <= (SMBUSGNTExt and (not SmBusBackOffExt) and SMBUSREQ)
                                 when (BUSMUXEXT = '1')
                 else
                    SMBUSGNTdbi;

-- -----------------------------------------------------------------------------
-- Grant generation logic.
-- By default DBI grants to SsmcCore. But when TIC is requesting grant is
-- switched to TIC. Switching of grant to TIC usually happens on Reset.
-- -----------------------------------------------------------------------------
p_GntComb : process (SMBUSGNTdbi, TICBUSGNTdbi, TICBUSREQ)
begin
  NextSMBUSGNT  <= SMBUSGNTdbi;
  NextTICBUSGNT <= TICBUSGNTdbi;
  if (TICBUSREQ = '1') then
    NextSMBUSGNT  <= '0';
    NextTICBUSGNT <= '1';
  end if;
end process p_GntComb;

-- -----------------------------------------------------------------------------
-- Mux to select between SsmcCore or TIC Data, before driving out on SMDATAOUT.
-- -----------------------------------------------------------------------------
SMDATAOUT <= TBUSOUT when (iTICBUSGNT = '1')
          else
             SmDataOutCore;

-- -----------------------------------------------------------------------------
-- Mux to select between SsmcCore or TIC Data Enables, before driving out on
-- nSMDATAEN.
-- -----------------------------------------------------------------------------
nSMDATAEN <= "0000" when ((iTICBUSGNT = '1') and (TICREAD = '1'))
          else
             SmDataEnCore;

-- -----------------------------------------------------------------------------
-- Registering all Next state signals
-- -----------------------------------------------------------------------------
p_GntSeq : process (HCLK, HRESETn)
begin
  if (HRESETn = '0') then
    SMBUSGNTdbi      <= '1';
    TICBUSGNTdbi     <= '0';
  elsif (HCLK'event and HCLK = '1') then
    SMBUSGNTdbi      <= NextSMBUSGNT;
    TICBUSGNTdbi     <= NextTICBUSGNT;
  end if;
end process p_GntSeq;

end synth;

-- --================================== End ==================================--
