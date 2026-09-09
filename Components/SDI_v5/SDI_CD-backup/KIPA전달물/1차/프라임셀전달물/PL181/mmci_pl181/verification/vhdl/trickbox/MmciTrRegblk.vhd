-- --=========================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 2000 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
--
-- -----------------------------------------------------------------------------
-- Version and Release Control Information:
--
-- File Name              : MmciTrRegblk.vhd.rca
-- File Revision          : 1.3
--
-- Release Information    : PrimeCell(TM)-PL181-REL1v0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           This block contains various registers of MMCI Trickbox
--           and the required logic to synchronise these registers
--           to the MMCICLK domain.
--
-- --=========================================================================--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

-- -----------------------------------------------------------------------------

entity MmciTrRegblk is
  port (
-- Inputs
        PCLK             : in    std_logic; -- APB Bus Clock
        PRESETn          : in    std_logic; -- APB Bus Reset
        MMCIPowerWr      : in    std_logic; -- WrEnable for MMCIPower
        MMCIClockWr      : in    std_logic; -- WrEnable for MMCIClock
        MMCICommandWr    : in    std_logic; -- WrEnable for MMCICommand
        MMCIDataLenWr    : in    std_logic; -- WrEnable for MMCIDatalen
        MMCIDataCntlWr   : in    std_logic; -- WrEnable for MMCIDataCntl
        MMCITBCntlWr     : in    std_logic; -- Wr enable for MMCITBCntl
        MMCITBRxdCIndS2  : in    std_logic_vector(5 downto 0);
                                            -- Stg2 buff i/p of
                                            -- RxdCmdInd
        MMCITBRxdCArgS2  : in    std_logic_vector(31 downto 0);
                                            -- Stage 2 buffer i/p of
                                            -- RxdCmdArg
        MTBCIUpdateSync  : in    std_logic; -- Syncd Updt sig for
                                            -- MMCITBRxdCInd
        MTBCAUpdateSync  : in    std_logic; -- Syncd Updt sig for
                                            -- MMCITBRxdCArg
        PWDATAIn         : in    std_logic_vector(31 downto 0);
                                            -- Gated PWDATA Bus of APB
-- Outputs
        MMCIPower        : out   std_logic_vector(7 downto 0);
                                            -- Stage 1 buffer o/p of
                                            -- MMCIPower
        MMCIClock        : out   std_logic_vector(10 downto 0);
                                            -- Stage 1 buffer o/p of
                                            -- MMCIClock
        MMCICommand      : out   std_logic_vector(10 downto 0);
                                            -- Stage 1 buffer o/p of
                                            -- MMCICommand
        MMCIDataLength   : out   std_logic_vector(15 downto 0);
                                            -- Stage 1 buffer o/p of
                                            -- MMCIDataLen
        MMCIDataCntl     : out   std_logic_vector(7 downto 0);
                                            -- Stage 1 buffer o/p of
                                            -- MMCIDatCntl
        MMCITBCntl       : out   std_logic_vector(13 downto 0);
                                            -- Stage 1 buffer o/p of
                                            -- MMCITBCtrl
        MPUpdate         : out   std_logic; -- Updt signal for MMCIPower
        MCUpdate         : out   std_logic; -- Updt sig for MMCIClock
        MCMUpdate        : out   std_logic; -- Updt sig for MMCICommand
        MDLUpdate        : out   std_logic; -- Updt sig for MMCIDataLen
        MDCUpdate        : out   std_logic; -- Updt sig for MMCIDataCntl
        MTBCUpdate       : out   std_logic; -- Updt sig for MMCITBCntl
        MMCITBRxdCInd    : out   std_logic_vector(5 downto 0);
                                            -- Stage 2 buffer o/p of
                                            -- RxdCmdInd
        MMCITBRxdCArg    : out   std_logic_vector(31 downto 0)
                                            -- Stage 2 buffer o/p of
                                            -- RxdCmdArg
       );

end MmciTrRegblk;

-- -----------------------------------------------------------------------------
--
--                                MmciTrRegblk
--                                ============
--
-- -----------------------------------------------------------------------------
--
-- Overview
-- ========
--
--   This block contains all the registers needed for the functionality
-- of the tricbox.Register that follow two buffer syncronization have
-- there first stage buffer in this block.
--
-- -----------------------------------------------------------------------------

-- --=========================== ARCHITECTURE ================================--

architecture behavioural of MmciTrRegblk is

-- -----------------------------------------------------------------------------
-- Component declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Constant declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Signal declarations
-- -----------------------------------------------------------------------------
signal iMMCIPower       : std_logic_vector(7 downto 0);
-- Stage 1 buffer for MMCIPower Register

signal iMMCIClock       : std_logic_vector(10 downto 0);
-- Stage 1 buffer for MMCIClock Register

signal iMMCICommand     : std_logic_vector(10 downto 0);
-- Stage 1 buffer for MMCICommand Register

signal iMMCIDataLength  : std_logic_vector(15 downto 0);
-- Stage 1 buffer for MMCIDataLength Register

signal iMMCIDataCntl    : std_logic_vector(7 downto 0);
-- Stage 1 buffer for -MMCIDataCntl Register

signal iMMCITBCntl      : std_logic_vector(13 downto 0);
-- Stage 1 buffer for MMCITBCntl Register

signal NextMMCIPower    : std_logic_vector(7 downto 0);
-- D-Input to MMCIPower

signal NextMMCIClock    : std_logic_vector(10 downto 0);
-- D-Input to MMCIClock

signal NextMMCICommand  : std_logic_vector(10 downto 0);
-- D-Input to MMCICommand

signal NextMMCIDataLen  : std_logic_vector(15 downto 0);
-- D-Input to MMCIDataLength

signal NextMMCIDataCntl : std_logic_vector(7 downto 0);
-- D-Input to MMCIDataCntl

signal NextMMCITBCntl   : std_logic_vector(13 downto 0);
-- D-Input to MMCITBCntl

signal iMPUpdate        : std_logic;
-- Local copy of Update signal to MMCIPower Register

signal NextMPUpdate     : std_logic;
-- D-Input to Update signal for MMCIPower Register

signal iMCUpdate        : std_logic;
-- Local copy of Update signal to MMCIClock Register

signal NextMCUpdate     : std_logic;
-- D-Input to Update signal for MMCIClock Register

signal iMDLUpdate       : std_logic;
-- Local copy of Update signal to MMCIDataLength Register

signal NextMDLUpdate    : std_logic;
-- D-Input to Update signal for MMCIDataLength Register

signal iMDCUpdate       : std_logic;
-- Local copy of Update signal to MMCIDataCntl Register

signal NextMDCUpdate    : std_logic;
-- D-Input to Update signal for MMCIDataCntl Register

signal iMCMUpdate       : std_logic;
-- Local copy of Update signal to MMCICommand Register

signal NextMCMUpdate    : std_logic;
-- D-Input to Update signal for MMCICommand Register

signal iMTBCUpdate      : std_logic;
-- Local copy of Update signal to MMCITBCntl Register

signal NextMTBCUpdate   : std_logic;
-- D-Input to Update signal for MMCITBCntl Register

signal MTBCI            : std_logic_vector(5 downto 0);
--  Second stage buffer for MMCITBRxdCInd register

signal MTBCA            : std_logic_vector(31 downto 0);
--  Second stage buffer for MMCITBRxdCArg register

signal NextMTBSS        : std_logic_vector(5 downto 0);
--  D-Input to MTBSS register

signal NextMTBCS        : std_logic_vector(3 downto 0);
--  D-Input to MTBCS register

signal NextMTBCI        : std_logic_vector(5 downto 0);
--  D-Input to MTBCI register

signal NextMTBCA        : std_logic_vector(31 downto 0);
--  D-Input to MTBCA register

signal DelMTBCIUpdate   : std_logic;
--  Delayed MTBCIUpdateSync

signal DelMTBCAUpdate   : std_logic;
--  Delayed MTBCAUpdateSync

signal MTBCIStg2WrEn    : std_logic;
--  Write enable to MTBCI buffer

signal MTBCAStg2WrEn    : std_logic;
--  Write enable to MTBCA buffer

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
-- Connect local copies to output signals
-- -----------------------------------------------------------------------------
-- MMCIPower
MMCIPower       <= iMMCIPower;

-- MMCIClock
MMCIClock       <= iMMCIClock;

-- MMCICommand
MMCICommand     <= iMMCICommand;

-- MMCIDataLength
MMCIDataLength  <= iMMCIDataLength;

-- MMCIDataCntl
MMCIDataCntl    <= iMMCIDataCntl;

-- MMCITBCntl
MMCITBCntl      <= iMMCITBCntl;


-- ----------------------------------------------------------------------------
--        Register Write Logic
-- ----------------------------------------------------------------------------

p_RegWriteSeq : process (PCLK, PRESETn)
begin
  if (PRESETn = '0') then
    iMMCIPower       <= (others => '0');
    iMMCIClock       <= (others => '0');
    iMMCICommand     <= (others => '0');
    iMMCIDataLength  <= (others => '0');
    iMMCIDataCntl    <= (others => '0');
    iMMCITBCntl      <= (others => '0');
  elsif (PCLK'event and PCLK = '1') then
    iMMCIPower       <= NextMMCIPower;
    iMMCIClock       <= NextMMCIClock;
    iMMCICommand     <= NextMMCICommand;
    iMMCIDataLength  <= NextMMCIDataLen;
    iMMCIDataCntl    <= NextMMCIDataCntl;
    iMMCITBCntl      <= NextMMCITBCntl;
  end if;
end process p_RegWriteSeq;

-- ----------------------------------------------------------------------------
-- Write interface for First stage buffer.
-- Write into the First stage buffers from the Data bus when the
-- corresponding write enable signal is asserted.
-- ----------------------------------------------------------------------------

p_RegComb : process (iMMCIPower, iMMCIClock, iMMCICommand, iMMCIDataLength,
                     iMMCIDataCntl, iMMCITBCntl, MMCIPowerWr,
                     MMCIClockWr, MMCICommandWr, MMCIDataLenWr,
                     MMCIDataCntlWr, MMCITBCntlWr)
begin
  if (MMCIPowerWr = '1') then
    NextMMCIPower       <= PWDATAIn(7 downto 0);
  else
    NextMMCIPower       <= iMMCIPower;
  end if;

  if (MMCIClockWr = '1') then
    NextMMCIClock       <= PWDATAIn(10 downto 0);
  else
    NextMMCIClock       <= iMMCIClock;
  end if;

  if (MMCICommandWr = '1') then
    NextMMCICommand     <= PWDATAIn(10 downto 0);
  else
    NextMMCICommand     <= iMMCICommand;
  end if;

  if (MMCIDataLenWr = '1') then
    NextMMCIDataLen     <= PWDATAIn(15 downto 0);
  else
    NextMMCIDataLen     <= iMMCIDataLength;
  end if;

  if (MMCIDataCntlWr = '1') then
    NextMMCIDataCntl    <= PWDATAIn(7 downto 0);
  else
    NextMMCIDataCntl    <= iMMCIDataCntl;
  end if;

  if (MMCITBCntlWr = '1') then
    NextMMCITBCntl      <= PWDATAIn(13 downto 0);
  else
    NextMMCITBCntl      <= iMMCITBCntl;
  end if;
end process p_RegComb;


-- ----------------------------------------------------------------------------
--   Update Siganals for Register Writes used for synchronisations
-- ----------------------------------------------------------------------------

p_UpdtMPComb : process (iMPUpdate, MMCIPowerWr)
begin
  NextMPUpdate   <= iMPUpdate;
  if (MMCIPowerWr = '1') then
    NextMPUpdate <= not(iMPUpdate);
  end if;
end process p_UpdtMPComb;

p_UpdtMPSeq : process (PCLK, PRESETn)
begin
  if (PRESETn = '0') then
    iMPUpdate <= '0';
  elsif (PCLK'event and PCLK = '1') then
    iMPUpdate <= NextMPUpdate;
  end if;
end process p_UpdtMPSeq;

p_UpdtMCComb : process (iMCUpdate, MMCIClockWr)
begin
  NextMCUpdate   <= iMCUpdate;
  if (MMCIClockWr = '1') then
    NextMCUpdate <= not(iMCUpdate);
  end if;
end process p_UpdtMCComb;

p_UpdtMCSeq : process (PCLK, PRESETn)
begin
  if (PRESETn = '0') then
    iMCUpdate <= '0';
  elsif (PCLK'event and PCLK = '1') then
    iMCUpdate <= NextMCUpdate;
  end if;
end process p_UpdtMCSeq;

p_UpdtMCMComb : process (iMCMUpdate, MMCICommandWr)
begin
  NextMCMUpdate   <= iMCMUpdate;
  if (MMCICommandWr = '1') then
    NextMCMUpdate <= not(iMCMUpdate);
  end if;
end process p_UpdtMCMComb;

p_UpdtMCMSeq : process (PCLK, PRESETn)
begin
  if (PRESETn = '0') then
    iMCMUpdate <= '0';
  elsif (PCLK'event and PCLK = '1') then
    iMCMUpdate <= NextMCMUpdate;
  end if;
end process p_UpdtMCMSeq;

p_UpdtMDLComb : process (iMDLUpdate, MMCIDataLenWr)
begin
  NextMDLUpdate   <= iMDLUpdate;
  if (MMCIDataLenWr = '1') then
    NextMDLUpdate <= not(iMDLUpdate);
  end if;
end process p_UpdtMDLComb;

p_UpdtMDLSeq : process (PCLK, PRESETn)
begin
  if (PRESETn = '0') then
    iMDLUpdate <= '0';
  elsif (PCLK'event and PCLK = '1') then
    iMDLUpdate <= NextMDLUpdate;
  end if;
end process p_UpdtMDLSeq;

p_UpdtMDCComb : process (iMDCUpdate, MMCIDataCntlWr)
begin
  NextMDCUpdate   <= iMDCUpdate;
  if (MMCIDataCntlWr = '1') then
    NextMDCUpdate <= not(iMDCUpdate);
  end if;
end process p_UpdtMDCComb;

p_UpdtMDCSeq : process (PCLK, PRESETn)
begin
  if (PRESETn = '0') then
    iMDCUpdate <= '0';
  elsif (PCLK'event and PCLK = '1') then
    iMDCUpdate <= NextMDCUpdate;
  end if;
end process p_UpdtMDCSeq;

p_UpdtMTBCComb : process (iMTBCUpdate, MMCITBCntlWr)
begin
  NextMTBCUpdate   <= iMTBCUpdate;
  if (MMCITBCntlWr = '1') then
    NextMTBCUpdate <= not(iMTBCUpdate);
  end if;
end process p_UpdtMTBCComb;

p_UpdtMTBCSeq : process (PCLK, PRESETn)
begin
  if (PRESETn = '0') then
    iMTBCUpdate <= '0';
  elsif (PCLK'event and PCLK = '1') then
    iMTBCUpdate <= NextMTBCUpdate;
  end if;
end process p_UpdtMTBCSeq;

-- -----------------------------------------------------------------------------
-- Connect local copies to output ports
-- -----------------------------------------------------------------------------
MPUpdate   <= iMPUpdate;
MCUpdate   <= iMCUpdate;
MDLUpdate  <= iMDLUpdate;
MDCUpdate  <= iMDCUpdate;
MCMUpdate  <= iMCMUpdate;
MTBCUpdate <= iMTBCUpdate;

-- -----------------------------------------------------------------------------
-- Generation of delayed versions of the Update trigger inputs.
-- -----------------------------------------------------------------------------
p_UpdtSyncDel : process (PCLK, PRESETn)
begin
  if (PRESETn = '0') then
    DelMTBCIUpdate <= '0';
    DelMTBCAUpdate <= '0';
  elsif (PCLK'event and PCLK = '1') then
    DelMTBCIUpdate <= MTBCIUpdateSync;
    DelMTBCAUpdate <= MTBCAUpdateSync;
  end if;
end process p_UpdtSyncDel;

-- -----------------------------------------------------------------------------
-- Generation of load signals for second stage buffers.
-- -----------------------------------------------------------------------------
MTBCIStg2WrEn <= MTBCIUpdateSync xor DelMTBCIUpdate;
MTBCAStg2WrEn <= MTBCAUpdateSync xor DelMTBCAUpdate;

-- -----------------------------------------------------------------------------
-- MTBSSStg2WrEn is used to enable the clocking of MMCISIGSTATS2 Input
-- into MTBSS buffer
-- -----------------------------------------------------------------------------

p_MTBCIComb : process (MTBCIStg2WrEn, MMCITBRxdCIndS2, MTBCI)
begin
  if (MTBCIStg2WrEn = '1') then
    NextMTBCI <= MMCITBRxdCIndS2;
  else
    NextMTBCI <= MTBCI;
  end if;
end process p_MTBCIComb;

p_MTBCAComb : process (MTBCAStg2WrEn, MMCITBRxdCArgS2, MTBCA)
begin
  if (MTBCAStg2WrEn = '1') then
    NextMTBCA <= MMCITBRxdCArgS2;
  else
    NextMTBCA <= MTBCA;
  end if;
end process p_MTBCAComb;

-- -----------------------------------------------------------------------------
-- Second stage buffers for the registers.
-- -----------------------------------------------------------------------------
p_Stg2BufSeq : process (PCLK, PRESETn)
begin
  if (PRESETn = '0') then
    MTBCI <= (others => '0');
    MTBCA <= (others => '0');
  elsif (PCLK'event and PCLK = '1') then
    MTBCI <= MMCITBRxdCIndS2;
    MTBCA <= MMCITBRxdCArgS2;
  end if;
end process p_Stg2BufSeq;

-- -----------------------------------------------------------------------------
-- Driving the outputs from the second stage buffers
-- -----------------------------------------------------------------------------
-- MMCITBRxdCInd
MMCITBRxdCInd <= MTBCI;

-- MMCITBRxdCArg
MMCITBRxdCArg <= MTBCA;

end behavioural;

-- --================================== End ==================================--
