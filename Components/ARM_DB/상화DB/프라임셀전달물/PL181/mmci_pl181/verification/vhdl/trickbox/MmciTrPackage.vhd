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
-- File Name              : MmciTrPackage.vhd.rca
-- File Revision          : 1.3
--
-- Release Information    : PrimeCell(TM)-PL181-REL1v0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           This file contains the address offset of all the
--           registers in trickbox defined as constants to enchance
--           readability.
--
-- --=========================================================================--

library IEEE;
use IEEE.std_logic_1164.all;
-- -----------------------------------------------------------------------------

package MmciTrPackage is

-- -----------------------------------------------------------------------------
--             Register Offsets
-- -----------------------------------------------------------------------------
constant PA_MMCIPOWER     : std_logic_vector(11 downto 2) :=
                                                       "0000000000";
-- MMCIPower offset

constant PA_MMCICLOCK     : std_logic_vector(11 downto 2) :=
                                                       "0000000001";
-- MMCIClock offset

constant PA_MMCICMD       : std_logic_vector(11 downto 2) :=
                                                       "0000000011";
-- MMCICommand offset

constant PA_MMCIDATALEN   : std_logic_vector(11 downto 2) :=
                                                       "0000001010";
-- MMCIDataLength offset

constant PA_MMCIDATACNTL  : std_logic_vector(11 downto 2) :=
                                                       "0000001011";
-- MMCIDataCntl offset

constant PA_MMCICMDRESP   : std_logic_vector(11 downto 2) :=
                                                       "0000000000";
-- MMCITBCmdResponse offset

constant PA_MMCIRESP0     : std_logic_vector(11 downto 2) :=
                                                       "0000000001";
-- MMCITBResponse0 offset

constant PA_MMCIRESP1     : std_logic_vector(11 downto 2) :=
                                                       "0000000010";
-- MMCITBResponse1 offset

constant PA_MMCIRESP2     : std_logic_vector(11 downto 2) :=
                                                       "0000000011";
-- MMCITBResponse2 offset

constant PA_MMCIRESP3     : std_logic_vector(11 downto 2) :=
                                                       "0000000100";
-- MMCITBResponse3 offset

constant PA_MMCIDTIMER    : std_logic_vector(11 downto 2) :=
                                                       "0000000101";
-- MMCITBDataTimer offset

constant PA_MMCIDATACNT   : std_logic_vector(11 downto 2) :=
                                                       "0000000110";
-- MMCITBDataCnt offset

constant PA_MMCIMCLK      : std_logic_vector(11 downto 2) :=
                                                       "0000000111";
-- MMCITBMCLKPeriod offset

constant PA_MMCICONTROL   : std_logic_vector(11 downto 2) :=
                                                       "0000001000";
-- MMCITBControl offset

constant PA_MMCIRETIMER   : std_logic_vector(11 downto 2) :=
                                                       "0000001001";
-- MMCITBRespTimer offset

constant PA_MMCISIGSTAT   : std_logic_vector(11 downto 2) :=
                                                       "0000001010";
-- MMCITBSIGSTAT offset

constant PA_MMCITBCARDSEL : std_logic_vector(11 downto 2) :=
                                                       "0000001011";
-- MMCITBRecdCardSel offset

constant PA_MMCITBCMDIND  : std_logic_vector(11 downto 2) :=
                                                       "0000001100";
-- MMCITBRecdCmdInd offset

constant PA_MMCITBCMDARG  : std_logic_vector(11 downto 2) :=
                                                       "0000001101";
-- MMCITBRecdCmdArg offset

constant PA_MMCITBFIFOSTAT: std_logic_vector(11 downto 2) :=
                                                       "0000001110";
-- MMCITBFifoStat offset

constant PA_MMCITOKTIMER  : std_logic_vector(11 downto 2) :=
                                                       "0000001111";
-- MMCITBTokenTimer offset

constant PA_MMCIBSYTIMER  : std_logic_vector(11 downto 2) :=
                                                       "0000010000";
-- MMCITBBusyTimer offset

constant PA_MMCIPCDISABLE : std_logic_vector(11 downto 2) :=
                                                       "0000010001";
-- MMCITBPCDisable offset

constant PA_MMCISTTIMEOUT : std_logic_vector(11 downto 2) :=
                                                       "0000010010";
-- MMCITBStTimeout offset

constant PA_MMCICLKRST    : std_logic_vector(11 downto 2) :=
                                                       "0000010011";
-- MMCITBCLKRSTCntl offset

constant PA_MMCITXFIFO    : std_logic_vector(11 downto 2) :=
                                                       "0000010100";
-- MMCITBFIFOReg offset

constant PA_MMCITBRXFIFO  : std_logic_vector(11 downto 2) :=
                                                       "0000010100";
-- MMCITBFIFOReg offset

constant PA_MMCITBCRCSTAT : std_logic_vector(11 downto 2) :=
                                                       "0000010101";
-- MMCITBCrcErrStat offset

end MmciTrPackage;
