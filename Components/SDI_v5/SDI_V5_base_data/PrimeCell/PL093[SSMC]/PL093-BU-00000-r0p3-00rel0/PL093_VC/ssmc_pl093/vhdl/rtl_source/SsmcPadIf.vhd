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
-- File Name              : SsmcPadIf.vhd.rca
-- File Revision          : 1.28
--
-- Release Information    : PrimeCell(TM)-PL093-r0p3-00rel0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           Clocking in the data from Memory and Routing out the Control and
--           Data signals from Core to Memory is the function of this block.
--
-- --=========================================================================--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

use work.SsmcPackage.all;

-- -----------------------------------------------------------------------------

entity SsmcPadIf is
  port (
-- Inputs
        SMFBCLK0         : in    std_logic; -- Fedback clock from output pad
                                            -- for Byte Lane0
        SMFBCLK1         : in    std_logic; -- Fedback clock from output pad
                                            -- for Byte Lane1
        SMFBCLK2         : in    std_logic; -- Fedback clock from output pad
                                            -- for Byte Lane2
        SMFBCLK3         : in    std_logic; -- Fedback clock from output pad
                                            -- for Byte Lane3
        SMMEMCLK         : in    std_logic; -- Memory Clock
        nSMMEMCLK        : in    std_logic; -- Inverted Memory Clock
        SMMEMCLKDELAY    : in    std_logic; -- Delayed Memory Clock
        HRESETn          : in    std_logic; -- AHB system level Reset
        nSMBURSTWAIT     : in    std_logic_vector(7 downto 0);
                                            -- Synchronous burst Wait signal
                                            -- from External Memory Controller
                                            -- to delay the transfer
        BIGENDIAN        : in    std_logic; -- Type of endianness of the system
        HsizeMemBufWr    : in    std_logic_vector(1 downto 0);
                                            -- Buffered HsizeMemBuf while
                                            -- writing
        MWWr             : in    std_logic_vector(1 downto 0);
                                            -- Buffered MW while writing
        RBLEWr           : in    std_logic; -- RBLE registered during write
                                            -- operation
        HwdataBuf        : in    std_logic_vector(31 downto 0);
                                            -- Buffered and Endianized HWDATASMC
        MemoryWrSt       : in    std_logic; -- Indication that Memory SM is in
                                            -- Write state
        nSMWENMC         : in    std_logic; -- Memory Write Enable, Active LOW
        SmAddrTSM        : in    std_logic_vector(1 downto 0);
                                            -- Memory Address from TSM module
        SMADDRMC         : in    std_logic_vector(25 downto 0);
                                            -- Memory address output when
                                            -- Asynchronous memory access is
                                            -- progressing
        nSMBLSMC         : in    std_logic_vector(3 downto 0);
                                            -- Byte Lane select when
                                            -- Asynchronous memory access is
                                            -- progressing

        SMDATAIN         : in    std_logic_vector(31 downto 0);
                                            -- Data from Memory to SSMC
        NextAsynAxs      : in   std_logic; -- Indication that Asynchronous
                                            -- memory access in progress
        NextSmOEn        : in  std_logic;
                                 -- Next state control outputs from MemTSM
        NxtSMADDRVALIDMC : in  std_logic;
                                 -- Next state control outputs from MemTSM
        NextSMBAAMC      : in  std_logic;
                                 -- Next state control outputs from MemTSM
        NextSMCSMC       : in  std_logic_vector(7 downto 0);
                                 -- Next state control outputs from MemTSM
        NextSMCSMCn      : in  std_logic_vector(7 downto 0);
                                 -- Next state control outputs from MemTSM
        NextSMDATAENMCn  : in  std_logic_vector(3 downto 0);
                                 -- Next state control outputs from MemTSM

-- Outputs
        SMADDR           : out   std_logic_vector(25 downto 0);
                                            -- External Memory Address Bus
        SmBurstWtFbClk   : out   std_logic; -- nSMBURSTWAIT registered on
                                            -- SMFBCLK
        SyncWtSingle     : out   std_logic; -- Single bit Synchronous Wait
        SmDataInFbClk    : out   std_logic_vector(31 downto 0);
                                            -- Data from Memory Banks
        SmDataEnCore     : out   std_logic_vector(3 downto 0);
                                            -- Data Enables when memory access
                                            -- is in progress
        SmDataOutCore    : out   std_logic_vector(31 downto 0);
                                            -- Data Bus output from SsmcCore
        SMCS             : out   std_logic_vector(7 downto 0);
                                            -- Chip Selects for external
                                            -- Memory, active HIGH
        nSMCS            : out   std_logic_vector(7 downto 0);
                                            -- Chip Selects for external
                                            -- Memory, active LOW
        SMBAA            : out   std_logic; -- External burst Address advance
                                            -- signal. Used to advance the
                                            -- address count in the external
                                            -- Memory device
        SMADDRVALID      : out   std_logic; -- External address valid output,
                                            -- used to indicate when the address
                                            -- output is stable during
                                            -- synchronous burst transfers
        nSMWEN           : out   std_logic; -- Memory Write Enable, Active LOW
        nSMOEN           : out   std_logic; -- Memory Output Enable, Active Low
        nSMBLS           : out   std_logic_vector(3 downto 0)
                                            -- Memory device Byte lane enables
       );
end SsmcPadIf;

-- -----------------------------------------------------------------------------
--
--                                  SsmcPadIf
--                                  =========
--
-- -----------------------------------------------------------------------------
--
-- Overview
-- ========
--           Clocking in the data from Memory and Routing out the Control and
--           Data signals from Core to Memory is the function of this block.
--           In this module SMDATAIN is clocked if it is from Synchronous
--           Memories. Also based on the System Endianness Data is routed out.
--           Logic to generate nSMBLS is also implemented in this module.
--
-- -----------------------------------------------------------------------------

-- --============================= ARCHITECTURE ==============================--

architecture synth of SsmcPadIf is

-- -----------------------------------------------------------------------------
-- Component declarations
-- -----------------------------------------------------------------------------

  component SsmcPadMux
    generic(
      WIDTH : integer := 0    -- I/P width
    );  
    port(
      SMMEMCLKDELAY   : in   std_logic;
      SMMEMCLK        : in   std_logic;
      HRESETn         : in   std_logic; 
      NextAsynAxs     : in   std_logic;
      SmCtrlIn        : in   std_logic_vector(WIDTH downto 0);
      SmCtrlInit      : in   std_logic;
      SmCtrlOut       : out  std_logic_vector(WIDTH downto 0)
    );
  end component;
    
-- -----------------------------------------------------------------------------
-- Constant declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Signal declarations
-- -----------------------------------------------------------------------------
signal SmDataInReg      : std_logic_vector(31 downto 0);
-- Registered SmDataIn for Synchronous Memory

signal SMADDRMCDel      : std_logic_vector(25 downto 0);
-- Memory address output when Synchronous memory access is progressing

signal nSMBLSMCDel      : std_logic_vector(3 downto 0);
-- Byte Lane select when Synchronous memory access is progressing

signal nSMBLSClkdInvMC  : std_logic_vector(3 downto 0);
-- Byte Lane select for asynchronous memories registered on nSMMEMCLK

signal nSMBLS4Async     : std_logic_vector(3 downto 0);
-- Byte Lane select multiplexed o/p between nSMBLSMC and nSMBLSClkdInvMC based
-- on RBLEWr setting

signal SMDATAOUTMC      : std_logic_vector(31 downto 0);
-- Data output when Asynchronous memory access is progressing

signal SMDATAOUTMCDel   : std_logic_vector(31 downto 0);
-- Data output when Synchronous memory access is progressing

signal nSMWENMCDel      : std_logic;
-- Write enable signal when Synchronous memory access is progressing

signal nSMWEN4Async     : std_logic;
-- Write enable signal for asynchronous memories registered on nSMMEMCLK

signal iSyncWtSingle    : std_logic;
-- Internal signal of SyncWtSingle

signal inSMCS       : std_logic_vector(7 downto 0);
-- Active low chip select when Synchronous memory access is progressing

signal AsynAxs    : std_logic;

signal InitCS      : std_logic;
-- Initial Value for control output

signal InitCSn     : std_logic;
-- Initial Value for control output

signal InitOEn     : std_logic;
-- Initial Value for control output

signal InitAddrV   : std_logic;
-- Initial Value for control output

signal InitDataEn  : std_logic;
-- Initial Value for control output

signal InitBAA     : std_logic;
-- Initial Value for control output

signal iNextSmOEn        : std_logic_vector(0 downto 0);
-- Internal signal used to connect to PadMux

signal iNxtSMADDRVALIDMC : std_logic_vector(0 downto 0);
-- Internal signal used to connect to PadMux

signal iNextSMBAAMC      : std_logic_vector(0 downto 0);
-- Internal signal used to connect to PadMux

signal iSMBAA            : std_logic_vector(0 downto 0);
-- Internal signal used to connect to PadMux

signal iSMADDRVALID      : std_logic_vector(0 downto 0);
-- Internal signal used to connect to PadMux

signal inSMOEN           : std_logic_vector(0 downto 0);
-- Internal signal used to connect to PadMux

-- -----------------------------------------------------------------------------
-- Function declarations
-- -----------------------------------------------------------------------------


-- synopsys translate_off
-- -----------------------------------------------------------------------------
-- Type declarations
-- -----------------------------------------------------------------------------



-- synopsys translate_on
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
SyncWtSingle <= iSyncWtSingle;

-- -----------------------------------------------------------------------------
--                              Assignments
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Write Data Path Logic
-- In this block the Data is Endianized before driving on SMDATAOUTMC line.
-- SMDATAOUTMC is driven out based on SmAddrTSM, MWWr and BIGENDIAN signals.
-- Initially the Data is collected from AHB in HwdataBuf[31:0] register.
-- When Memory Write is initiated based on the Memory Address, Memory Width and
-- Endianness of the system.
-- -----------------------------------------------------------------------------
p_WriteDataComb : process (MWWr, HsizeMemBufWr, MemoryWrSt, BIGENDIAN,
                           HwdataBuf, SmAddrTSM)
variable Concat           : std_logic_vector(3 downto 0);
begin
  Concat      := (MWWr & HsizeMemBufWr(1 downto 0));
  SMDATAOUTMC <= (others => '0');
  if (MemoryWrSt = '1') then
    if (BIGENDIAN = '0') then
      case Concat is

        -- Memory size is Byte, AHB Width can be Byte, HWord, or Word
        when "0000" | "0001" | "0010" =>
          -- SMDATAOUTMC is driven out based on SmAddrTSM, and System
          -- Endianness
          case SmAddrTSM(1 downto 0) is
            when "00" =>
              SMDATAOUTMC(7 downto 0) <= HwdataBuf(7 downto 0);

            when "01" =>
              SMDATAOUTMC(7 downto 0) <= HwdataBuf(15 downto 8);

            when "10" =>
              SMDATAOUTMC(7 downto 0) <= HwdataBuf(23 downto 16);

            when "11" =>
              SMDATAOUTMC(7 downto 0) <= HwdataBuf(31 downto 24);

            when others =>
              null;
          end case;

        -- Memory size is HWord, AHB Width is Byte
        when "0100" =>
          -- SMDATAOUTMC is driven out based on SmAddrTSM, and System
          -- Endianness
          case SmAddrTSM(1) is
            when '0' =>
              SMDATAOUTMC(15 downto 0) <= HwdataBuf(15 downto 0);

            when '1' =>
              SMDATAOUTMC(15 downto 0) <= HwdataBuf(31 downto 16);

            when others =>
              null;
          end case;

        -- Memory size is HWord, AHB Width can be HWord, or Word
        when "0101" | "0110" =>
          -- SMDATAOUTMC is driven out based on SmAddrTSM, and System
          -- Endianness
          case SmAddrTSM(1) is
            when '0' =>
              SMDATAOUTMC(15 downto 0) <= HwdataBuf(15 downto 0);

            when '1' =>
              SMDATAOUTMC(15 downto 0) <= HwdataBuf(31 downto 16);

            when others =>
              null;
          end case;

        -- Memory size is Word, AHB Width is Byte
        when "1000" =>
          SMDATAOUTMC <= HwdataBuf;

        -- Memory size is Word, AHB Width is HWord
        when "1001" =>
          SMDATAOUTMC <= HwdataBuf;

        -- Memory size is Word, AHB Width is Word
        when "1010" =>
          SMDATAOUTMC <= HwdataBuf;

        when others =>
          null;
      end case;

    -- System is Big Endian
    else
      case Concat is
        -- Memory size is Byte, AHB Width can be Byte, HWord, or Word
        when "0000" | "0001" | "0010" =>
          -- SMDATAOUTMC is driven out based on SmAddrTSM, and System
          -- Endianness
          case SmAddrTSM(1 downto 0) is
            when "11" =>
              SMDATAOUTMC(7 downto 0) <= HwdataBuf(7 downto 0);

            when "10" =>
              SMDATAOUTMC(7 downto 0) <= HwdataBuf(15 downto 8);

            when "01" =>
              SMDATAOUTMC(7 downto 0) <= HwdataBuf(23 downto 16);

            when "00" =>
              SMDATAOUTMC(7 downto 0) <= HwdataBuf(31 downto 24);

            when others =>
              null;
          end case;

        -- Memory size is HWord, AHB Width is Byte
        when "0100" =>
          -- SMDATAOUTMC is driven out based on SmAddrTSM, and System
          -- Endianness
          case SmAddrTSM(1) is
            when '1' =>
              SMDATAOUTMC(15 downto 0) <= HwdataBuf(15 downto 0);

            when '0' =>
              SMDATAOUTMC(15 downto 0) <= HwdataBuf(31 downto 16);

            when others =>
              null;
          end case;

        -- Memory size is HWord, AHB Width can be HWord, or Word
        when "0101" | "0110" =>
          -- SMDATAOUTMC is driven out based on SmAddrTSM, and System
          -- Endianness
          case SmAddrTSM(1) is
            when '1' =>
              SMDATAOUTMC(15 downto 0) <= HwdataBuf(15 downto 0);

            when '0' =>
              SMDATAOUTMC(15 downto 0) <= HwdataBuf(31 downto 16);

            when others =>
              null;
          end case;

        -- Memory size is Word, AHB Width is Byte
        when "1000" =>
          SMDATAOUTMC <= HwdataBuf;

        -- Memory size is Word, AHB Width is HWord
        when "1001" =>
          SMDATAOUTMC <= HwdataBuf;

        -- Memory size is Word, AHB Width is Word
        when "1010" =>
          SMDATAOUTMC  <= HwdataBuf;

        when others =>
          null;
      end case;
    end if;
  end if;
end process p_WriteDataComb;

-- -----------------------------------------------------------------------------
-- Mux to select between SMDATAIN or SmDataInReg(registered SMDATAIN), depending
-- on Asynchronous or Synchronous Memories.
-- -----------------------------------------------------------------------------
SmDataInFbClk <= SMDATAIN when (AsynAxs = '1')
              else
                 SmDataInReg;

----------------------------------------------------------------------------
-- Macro containing AsynAxs plus the control signal registers
----------------------------------------------------------------------------
nSMCS <= inSMCS;

-- Initial values for control outputs
InitCS               <= '0';
InitCSn              <= '1';
InitOEn              <= '1';
InitAddrV            <= '1';
InitDataEn           <= '1';
InitBAA              <= '1';

-- Assign internal signals to IO
iNextSmOEn(0)        <= NextSmOEn;
iNxtSMADDRVALIDMC(0) <= NxtSMADDRVALIDMC;
iNextSMBAAMC(0)      <= NextSMBAAMC;
nSMOEN               <= inSMOEN(0);
SMADDRVALID          <= iSMADDRVALID(0);
SMBAA                <= iSMBAA(0);

uSsmcPadMuxCS : SsmcPadMux
    generic map (
                 WIDTH => 7     -- AHB identity tag
                 )
    port map (
              SMMEMCLKDELAY => SMMEMCLKDELAY,
              SMMEMCLK      => SMMEMCLK,
              HRESETn       => HRESETn,
              NextAsynAxs   => NextAsynAxs,
              SmCtrlIn      => NextSMCSMC,
              SmCtrlInit    => InitCS,
              SmCtrlOut     => SMCS
              );

uSsmcPadMuxCSn : SsmcPadMux
    generic map (
                 WIDTH => 7     -- AHB identity tag
                 )
    port map (
              SMMEMCLKDELAY => SMMEMCLKDELAY,
              SMMEMCLK      => SMMEMCLK,
              HRESETn       => HRESETn,
              NextAsynAxs   => NextAsynAxs,
              SmCtrlIn      => NextSMCSMCn,
              SmCtrlInit    => InitCSn,
              SmCtrlOut     => inSMCS
              );

uSsmcPadMuxOEn : SsmcPadMux
    generic map (
                 WIDTH => 0     -- AHB identity tag
                 )
    port map (
              SMMEMCLKDELAY => SMMEMCLKDELAY,
              SMMEMCLK      => SMMEMCLK,
              HRESETn       => HRESETn,
              NextAsynAxs   => NextAsynAxs,
              SmCtrlIn      => iNextSmOEn,
              SmCtrlInit    => InitOEn,
              SmCtrlOut     => inSMOEN
              );

uSsmcPadMuxAddrV : SsmcPadMux
    generic map (
                 WIDTH => 0     -- AHB identity tag
                 )
    port map (
              SMMEMCLKDELAY => SMMEMCLKDELAY,
              SMMEMCLK      => SMMEMCLK,
              HRESETn       => HRESETn,
              NextAsynAxs   => NextAsynAxs,
              SmCtrlIn      => iNxtSMADDRVALIDMC,
              SmCtrlInit    => InitAddrV,
              SmCtrlOut     => iSMADDRVALID
              );

uSsmcPadMuxDataEn : SsmcPadMux
    generic map (
                 WIDTH => 3     -- AHB identity tag
                 )
    port map (
              SMMEMCLKDELAY => SMMEMCLKDELAY,
              SMMEMCLK      => SMMEMCLK,
              HRESETn       => HRESETn,
              NextAsynAxs   => NextAsynAxs,
              SmCtrlIn      => NextSMDATAENMCn,
              SmCtrlInit    => InitDataEn,
              SmCtrlOut     => SmDataEnCore
              );

uSsmcPadMuxBAA : SsmcPadMux
    generic map (
                 WIDTH => 0     -- AHB identity tag
                 )
    port map (
              SMMEMCLKDELAY => SMMEMCLKDELAY,
              SMMEMCLK      => SMMEMCLK,
              HRESETn       => HRESETn,
              NextAsynAxs   => NextAsynAxs,
              SmCtrlIn      => iNextSMBAAMC,
              SmCtrlInit    => InitBAA,
              SmCtrlOut     => iSMBAA
              );

-- -----------------------------------------------------------------------------
-- The following block generates the SMMEMCLKDELAYed version of the output
-- signals. SMMEMCLKDELAYed version is used for Synchronous static memory
-- accesses.
-- -----------------------------------------------------------------------------

p_SmClkDelPadSeq : process (SMMEMCLKDELAY, HRESETn)
begin
  if (HRESETn = '0') then
    nSMBLSMCDel      <= (others => '1');
    nSMWENMCDel      <= '1';
    SMADDRMCDel      <= (others => '0');
    SMDATAOUTMCDel   <= (others => '0');
  elsif (SMMEMCLKDELAY'event and SMMEMCLKDELAY = '1') then
    nSMBLSMCDel      <= nSMBLSMC;
    nSMWENMCDel      <= nSMWENMC;
    SMADDRMCDel      <= SMADDRMC;
    SMDATAOUTMCDel   <= SMDATAOUTMC;
  end if;
end process p_SmClkDelPadSeq;

p_AsynAxsSeq : process (SMMEMCLK, HRESETn)
begin
  if (HRESETn = '0') then
    AsynAxs   <= '1';
  elsif (SMMEMCLK'event and SMMEMCLK = '1') then
    AsynAxs   <= NextAsynAxs;
  end if;
end process p_AsynAxsSeq;

-- -----------------------------------------------------------------------------
-- Sequential logic for Clocking in nSMWENMC and nSMBLSMC w.r.t nSMMEMCLK
-- -----------------------------------------------------------------------------
p_InvClkSeq : process (nSMMEMCLK, HRESETn)
begin
  if (HRESETn = '0') then
    nSMWEN4Async    <= '1';
    nSMBLSClkdInvMC <= "1111";
  elsif (nSMMEMCLK'event and nSMMEMCLK = '1') then
    nSMWEN4Async    <= nSMWENMC;
    nSMBLSClkdInvMC <= nSMBLSMC;
  end if;
end process p_InvClkSeq;

-- -----------------------------------------------------------------------------
-- BLS for Asynchronous memories is selected based on RBLE setting.
-- -----------------------------------------------------------------------------
nSMBLS4Async <= nSMBLSMC when ((RBLEWr or
                                (AsynAxs and (not MemoryWrSt))) = '1')
             else
                nSMBLSClkdInvMC;


-- -----------------------------------------------------------------------------
-- The following mux muxes out one among the SMMEMCLK version and SMMEMCLKDELAY
-- version as the final output. The Memory State information qualified with the
-- bit indicating Asynchronous or Synchronous memories is used for mux select.
-- -----------------------------------------------------------------------------
p_OutputMuxComb : process (AsynAxs, nSMBLS4Async, nSMWEN4Async,
                           SMADDRMC, SMDATAOUTMC, nSMBLSMCDel,
                           nSMWENMCDel, SMADDRMCDel,SMDATAOUTMCDel)
begin
  if (AsynAxs = '1') then
    nSMBLS        <= nSMBLS4Async;
    nSMWEN        <= nSMWEN4Async;
    SMADDR        <= SMADDRMC;
    SmDataOutCore <= SMDATAOUTMC;
  else
    nSMBLS        <= nSMBLSMCDel;
    nSMWEN        <= nSMWENMCDel;
    SMADDR        <= SMADDRMCDel;
    SmDataOutCore <= SMDATAOUTMCDel;
  end if;
end process p_OutputMuxComb;

-- -----------------------------------------------------------------------------
-- Logic to make nSMBURSTWAIT as single bit
-- -----------------------------------------------------------------------------
iSyncWtSingle <= (nSMBURSTWAIT(0) or inSMCS(0)) and
                 (nSMBURSTWAIT(1) or inSMCS(1)) and
                 (nSMBURSTWAIT(2) or inSMCS(2)) and
                 (nSMBURSTWAIT(3) or inSMCS(3)) and
                 (nSMBURSTWAIT(4) or inSMCS(4)) and
                 (nSMBURSTWAIT(5) or inSMCS(5)) and
                 (nSMBURSTWAIT(6) or inSMCS(6)) and
                 (nSMBURSTWAIT(7) or inSMCS(7));

-- -----------------------------------------------------------------------------
-- Sequential logic for Clocking in SmBurstWtFbClk
-- -----------------------------------------------------------------------------
p_SmBrstWtSeq : process (SMFBCLK0, HRESETn)
begin
  if (HRESETn = '0') then
    SmBurstWtFbClk          <= '1';
  elsif (SMFBCLK0'event and SMFBCLK0 = '1') then
    SmBurstWtFbClk          <= iSyncWtSingle;
  end if;
end process p_SmBrstWtSeq;

-- -----------------------------------------------------------------------------
-- Sequential logic for Clocking in SMDATAIN[7:0]
-- -----------------------------------------------------------------------------
p_SmDatByte0Seq : process (SMFBCLK0, HRESETn)
begin
  if (HRESETn = '0') then
    SmDataInReg(7 downto 0)   <= (others => '0');
  elsif (SMFBCLK0'event and SMFBCLK0 = '1') then
    if (AsynAxs = '0') then
      SmDataInReg(7 downto 0) <= SMDATAIN(7 downto 0);
    end if;
  end if;
end process p_SmDatByte0Seq;

-- -----------------------------------------------------------------------------
-- Sequential logic for Clocking in SMDATAIN[15:8]
-- -----------------------------------------------------------------------------
p_SmDatByte1Seq : process (SMFBCLK1, HRESETn)
begin
  if (HRESETn = '0') then
    SmDataInReg(15 downto 8)   <= (others => '0');
  elsif (SMFBCLK1'event and SMFBCLK1 = '1') then
    if (AsynAxs = '0') then
      SmDataInReg(15 downto 8) <= SMDATAIN(15 downto 8);
    end if;
  end if;
end process p_SmDatByte1Seq;

-- -----------------------------------------------------------------------------
-- Sequential logic for Clocking in SMDATAIN[23:16]
-- -----------------------------------------------------------------------------
p_SmDatByte2Seq : process (SMFBCLK2, HRESETn)
begin
  if (HRESETn = '0') then
    SmDataInReg(23 downto 16)   <= (others => '0');
  elsif (SMFBCLK2'event and SMFBCLK2 = '1') then
    if (AsynAxs = '0') then
      SmDataInReg(23 downto 16) <= SMDATAIN(23 downto 16);
    end if;
  end if;
end process p_SmDatByte2Seq;

-- -----------------------------------------------------------------------------
-- Sequential logic for Clocking in SMDATAIN[31:24]
-- -----------------------------------------------------------------------------
p_SmDatByte3Seq : process (SMFBCLK3, HRESETn)
begin
  if (HRESETn = '0') then
    SmDataInReg(31 downto 24)   <= (others => '0');
  elsif (SMFBCLK3'event and SMFBCLK3 = '1') then
    if (AsynAxs = '0') then
      SmDataInReg(31 downto 24) <= SMDATAIN(31 downto 24);
    end if;
  end if;
end process p_SmDatByte3Seq;

-- synopsys translate_off
-- -----------------------------------------------------------------------------
-- START OF PROTOCOL CHECKERS
-- -----------------------------------------------------------------------------


-- Protocol checkers can be used for debugging purposes.


-- -----------------------------------------------------------------------------
-- END OF PROTOCOL CHECKERS
-- -----------------------------------------------------------------------------
-- synopsys translate_on

end synth;

-- --================================== End ==================================--
