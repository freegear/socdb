-- --=========================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 2000-2003 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
--
-- -----------------------------------------------------------------------------
-- Version and Release Control Information:
--
-- File Name              : DBI.vhd.rca
-- File Revision          : 1.23
--
-- Release Information    : PrimeCell(TM)-PL092-r1p3-01ltd0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           This block implements a dynamic priority arbitration logic for the
--           External Data Bus and Address Bus Interface between SmcCore,
--           TIC block and the Additional Memory Controller. A bypass logic 
--           is also implemented in the DBI which will enable the Smc to 
--           interface with EbiSdram
--
-- --=========================================================================--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

-- -----------------------------------------------------------------------------

entity DBI is
  port (
-- Inputs
        HCLK             : in    std_logic; -- AHB Clock
        HRESETn          : in    std_logic; -- AHB Reset

        TICBUSREQ        : in    std_logic; -- Internal Bus Request from TIC to
                                            -- DBI
        SMBUSREQ         : in    std_logic; -- Internal Bus Request from SmcCore
                                            -- to the DBI
        MCBUSREQ         : in    std_logic; -- Bus Request from the Additional
                                            -- Memory Controller
        TICBUSGNTEBI     : in    std_logic; -- Bus Grant input to TIC from
                                            -- external EbiSdram
        SMBUSGNTEBI      : in    std_logic; -- Bus Grant input to SmcCore from
                                            -- external EbiSdram
        nSMCDATAEN       : in    std_logic_vector(3 downto 0);
                                            -- Pad enables from SmcCore
        MCDATAEN         : in    std_logic_vector(3 downto 0);
                                            -- Pad enables from Additional
                                            -- Memory Controller
        TICREAD          : in    std_logic; -- Pad enable from TIC
        SMCDATAOUT       : in    std_logic_vector(31 downto 0);
                                            -- SmcCore Output Data bus
        MCDATAOUT        : in    std_logic_vector(31 downto 0);
                                            -- Additional Memory controller
                                            -- Output Data Bus
        TBUSOUT          : in    std_logic_vector(31 downto 0);
                                            -- TIC output Data bus
        SMCADDR          : in    std_logic_vector(25 downto 0);
                                            -- SmcCore Address Bus;
        MCADDR           : in    std_logic_vector(25 downto 0);
                                            -- Additional Memory Controller
                                            -- Address Bus
        EXTBUSMUX        : in    std_logic; -- This tied input will determine
                                            -- whether the internal DBI or
                                            -- external EbiSdram will be
                                            -- used for bus arbitration

-- Outputs
        TICBUSREQEBI     : out   std_logic; -- External Data bus request signal
                                            -- from TIC to the EbiSdram
        SMBUSREQEBI      : out   std_logic; -- External Data bus request signal
                                            -- from SmcCore to the EbiSdram
        TICBUSGNT        : out   std_logic; -- Bus Grant to TIC from either DBI
                                            -- or EbiSdram
        SMBUSGNT         : out   std_logic; -- Bus Grant to SmcCore from either
                                            -- DBI or EbiSdram
        MCBUSGNT         : out   std_logic; -- Bus Grant to Additional Memory
                                            -- Controller from DBI
        nSMDATAEN        : out   std_logic_vector(3 downto 0);
                                            -- Final Pad Enables of the
                                            -- SMC peripheral
        TICREADEBI       : out   std_logic; -- Pad Enable signal from TIC when
                                            -- EbiSdram is used
        SMDATAOUT        : out   std_logic_vector(31 downto 0);
                                            -- Data output bus of the
                                            -- SMC-peripheral
        TBUSOUTEBI       : out   std_logic_vector(31 downto 0);
                                            -- Data bus output from the TIC
                                            -- when EbiSdram is used
        SMADDR           : out   std_logic_vector(25 downto 0)
                                            -- Address bus of the SMC-
                                            -- peripheral
       );
end DBI;

-- -----------------------------------------------------------------------------
--
--                                     DBI
--                                     ===
--
-- -----------------------------------------------------------------------------
--
-- Overview
-- ========
--   The feature of the DBI is that it supports dynamic priority arbitration.
-- The TIC has the highest priority followed by the Additional Memory Controller
-- and the SmcCore has the lowest priority. If a lower priority master is
-- doing transfers on the bus and a higher priority master requests for the bus
-- then the DBI de-asserts the bus grant line of the lower priority master
-- indicating it should leave control of the bus. Once the bus request line is
-- de-asserted by the lower priority master, the DBI then grants the control of
-- the bus to the higher priority master.
-- The Data Bus Interface implements the following functions:
-- o  Multiplexes the Data lines and data bus byte lane enable lines from the
--    TIC, Additional Memory Controller and the SmcCore on to the common Data
--    pins of the chip.
-- o  Arbitrates between the SmcCore and Additional Memory Controller for the
--    control of the address lines
-- o  Implements the Arbiter state machine to regulate access requests from the
--    SmcCore block, TIC and Additional Memory Controller.
--
--   A bypass logic has been implemented which will cater to the requirement
-- when the SMC needs to interface with the EbiSdram. In this scenario the DBI
-- becomes redundant as the External BusReq and BusGnt pins become active and
-- these get connected to the SmcCore block. During synthesis the redundant DBI
-- can get optimized out.
--
-- -----------------------------------------------------------------------------

-- --============================== ARCHITECTURE =============================--

architecture synth of DBI is

-- -----------------------------------------------------------------------------
-- Component declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Constant declarations
-- -----------------------------------------------------------------------------

-- State encoding for the DBI state machine

constant ST_DBI_IDLE      : std_logic_vector(3 downto 0) := "0001";
-- Idle state

constant ST_DBI_GNT_TIC   : std_logic_vector(3 downto 0) := "0010";
-- Grant state for the TIC

constant ST_DBI_GNT_MC    : std_logic_vector(3 downto 0) := "0100";
-- Grant state for the Memory Controller

constant ST_DBI_GNT_SMC   : std_logic_vector(3 downto 0) := "1000";
-- Grant state for the SmcCore

-- -----------------------------------------------------------------------------
-- Bit encoding for the DBI State machine
-- -----------------------------------------------------------------------------
constant DBI_IDLE         : integer range 0 to 3 := 0;
constant DBI_GNT_TIC      : integer range 0 to 3 := 1;
constant DBI_GNT_MC       : integer range 0 to 3 := 2;
constant DBI_GNT_SMC      : integer range 0 to 3 := 3;

-- -----------------------------------------------------------------------------
-- Signal declarations
-- -----------------------------------------------------------------------------
signal TICBUSGNTdbi     : std_logic;
-- Internal version of TIC bus grant signal

signal iMCBUSGNT        : std_logic;
-- Internal version of Additional Memory Controller Bus Grant signal

signal SMBUSGNTdbi      : std_logic;
-- Internal version of SmcCore Bus Grant signals

signal ArbState         : std_logic_vector(3 downto 0);
-- DBI Arbiter state register

signal NextArbState     : std_logic_vector(3 downto 0);
-- D-input of DBI Arbiter state register

signal McBusDrive       : std_logic;
-- BusDrive signal for Additional Memory Controller Bus

signal MCBUSREQdbi      : std_logic;
-- Gated MCBUSREQ which will be active only when the DBI is used

signal SMBUSGNTEBIInt   : std_logic;
-- SMBUSGNTEBI qualified with SMBUSREQ

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
-- Multiplexer to choose between the DBI and the external EbiSdram for bus
-- arbitration
-- -----------------------------------------------------------------------------

SMBUSGNTEBIInt   <= SMBUSGNTEBI and SMBUSREQ;

SMBUSREQEBI      <= SMBUSREQ     when (EXTBUSMUX = '1')
                 else
                    '0';

TICBUSREQEBI     <= TICBUSREQ    when (EXTBUSMUX = '1')
                 else
                    '0';

SMBUSGNT         <= SMBUSGNTEBIInt  when (EXTBUSMUX = '1')
                 else
                    SMBUSGNTdbi;

TICBUSGNT        <= TICBUSGNTEBI when (EXTBUSMUX = '1')
                 else
                    TICBUSGNTdbi;

TICREADEBI       <= TICREAD      when (EXTBUSMUX = '1')
                 else
                    '0';

TBUSOUTEBI       <= TBUSOUT      when (EXTBUSMUX = '1')
                 else
                    (others => '0');

MCBUSREQdbi      <= MCBUSREQ     when (EXTBUSMUX = '0')
                 else
                    '0';

-- -----------------------------------------------------------------------------
-- DBI Arbiter State Machine - Next state Computation
-- A Dynamic priority arbitration scheme is implemented with TIC
-- having the highest priority followed by the Additional Memory Controller and
-- SmcCore having least priority.
-- The EXTBUSMUX is the tied input pad, input value on which determines if the
-- DBI needs to do the arbitration
-- -----------------------------------------------------------------------------
p_ArbSmComb : process (ArbState, EXTBUSMUX, SMBUSREQ, TICBUSREQ, MCBUSREQdbi)
begin
  NextArbState     <= ArbState;

-- The Arbiter state machine is active only if the EXTBUSMUX tied to '0'
  if (EXTBUSMUX = '0') then
    case ArbState is

-- This is the state, the state machine moves into after reset. If TIC requests
-- for the bus, the state machine grants the bus to it even if other bus
-- requests are simlutaneously asserted. The next in priority is the Additional
-- Memory Controller which gets control of the bus if its request is detected
-- when the TIC is not requesting. The SmcCore is granted the bus when it
-- asserts its request lines and the other masters are not contesting for the 
-- control of the bus. 
-- This is the default state when none of the masters are active
      when ST_DBI_IDLE =>
        if (TICBUSREQ = '1') then
          NextArbState     <= ST_DBI_GNT_TIC;
        elsif (MCBUSREQdbi = '1') then
          NextArbState     <= ST_DBI_GNT_MC;
        elsif (SMBUSREQ = '1') then
          NextArbState     <= ST_DBI_GNT_SMC;
        else
          NextArbState     <= ST_DBI_IDLE;
        end if;

-- When the TIC is active, the DBI gives control of the Bus to TIC while its
-- BusReq is asserted {the DBI resides in this state}. Once TIC completes its
-- operation and de-asserts the BusReq, the DBI considers the requests from the
-- other masters with the same priority logic. 
      when ST_DBI_GNT_TIC =>
        if (TICBUSREQ = '0') then
          if (MCBUSREQdbi = '1') then
            NextArbState     <= ST_DBI_GNT_MC;
          elsif (SMBUSREQ = '1') then
            NextArbState     <= ST_DBI_GNT_SMC;
          else
            NextArbState     <= ST_DBI_IDLE;
          end if;
        else
          NextArbState     <= ST_DBI_GNT_TIC;
        end if;

-- This is the state when the Additional Memory Controller is active and has the
-- control of the bus. In this situation if the TIC requests for the Bus then
-- the DBI de-asserts the MCBUSGNT. The AMC is then expected to complete its
-- current operation and de-assert its BusReq
-- If the lower priority master {SmcCore} requests for the bus then the DBI
-- gives grant only after the AMC completes all its operation indicated by
-- de-assertion on the MCBUSREQ input
      when ST_DBI_GNT_MC =>
        if (TICBUSREQ = '1' and MCBUSREQdbi = '0') then
          NextArbState     <= ST_DBI_GNT_TIC;
        elsif (MCBUSREQdbi = '0') then
          if (SMBUSREQ = '1') then
            NextArbState     <= ST_DBI_GNT_SMC;
          else
            NextArbState     <= ST_DBI_IDLE;
          end if;
        else
          NextArbState     <= ST_DBI_GNT_MC;
        end if;

-- This state indicates that the SmcCore is active and has the control of the
-- bus. Whenever any of the higher priority master request for the bus, the DBI
-- de-asserts the SMBUSGNT and waits for the SmcCore to complete its current
-- operation and de-assert SMBUSREQ. Depending on the priority the corresponding
-- master is given the control of the bus
      when ST_DBI_GNT_SMC =>
        if (TICBUSREQ = '1' and SMBUSREQ = '0') then
          NextArbState     <= ST_DBI_GNT_TIC;
        elsif (MCBUSREQdbi = '1' and SMBUSREQ = '0') then
          NextArbState     <= ST_DBI_GNT_MC;
        elsif (SMBUSREQ = '0') then
          NextArbState     <= ST_DBI_IDLE;
        else
          NextArbState     <= ST_DBI_GNT_SMC;
        end if;

      when others =>
        NextArbState     <= ST_DBI_IDLE;

    end case;
  end if;
end process p_ArbSmComb;

-- -----------------------------------------------------------------------------
-- Sequential process for ArbState
-- -----------------------------------------------------------------------------
p_ArbSmSeq : process (HCLK, HRESETn)
begin
  if (HRESETn = '0') then
    ArbState         <= ST_DBI_IDLE;
  elsif (HCLK'event and HCLK = '1') then
    ArbState         <= NextArbState;
  end if;
end process p_ArbSmSeq;

-- -----------------------------------------------------------------------------
-- Generation of grant signal to the TIC. It is generated if TICBUSREQ
-- is asserted and if the states are DBI_IDLE or DBI_GNT_TIC. It is taken
-- care in the state machine that if TICBUSREQ is asserted during a
-- DBI_GNT_SMC or DBI_GNT_MC state, once the corresponding bus requests
-- are deasserted, it switches to DBI_GNT_TIC state.
-- -----------------------------------------------------------------------------
TICBUSGNTdbi     <= (((ArbState(DBI_IDLE) or ArbState(DBI_GNT_TIC)) and
                      TICBUSREQ) and (not EXTBUSMUX));

-- -----------------------------------------------------------------------------
-- Generation of grant signal to the Additional Memory Controller. It is
-- generated only if MCBUSREQ is asserted and TICBUSREQ is deasserted and if the
-- states are DBI_IDLE or DBI_GNT_MC. It is taken care in the state
-- machine that if MCBUSREQ is asserted during a DBI_GNT_SMC state, once the
-- corresponding bus request is deasserted, it switches to DBI_GNT_MC state.
-- -----------------------------------------------------------------------------
iMCBUSGNT        <= (((ArbState(DBI_IDLE) or ArbState(DBI_GNT_MC)) and
                      MCBUSREQdbi and not(TICBUSREQ)) and (not EXTBUSMUX));

-- -----------------------------------------------------------------------------
-- Generation of grant signal to the SmcCore. It is generated only if
-- SMCBUSREQ is asserted and all other bus requests are deasserted.
-- -----------------------------------------------------------------------------
SMBUSGNTdbi      <= (((ArbState(DBI_IDLE) or SMBUSREQ) and (not(TICBUSREQ)) and
                      (not(MCBUSREQdbi))) and (not EXTBUSMUX));

-- -----------------------------------------------------------------------------
-- Generation of Bus drive signal for Additional Memory Controller. This signal
-- will ensure that the bus is driven with MCDATAOUT and MCADDR till
-- MCBUSREQ is deasserted.
-- -----------------------------------------------------------------------------
p_DriveMcComb : process (MCBUSREQdbi, iMCBUSGNT, ArbState)
begin
  McBusDrive       <= '0';

  if ((MCBUSREQdbi = '1' and iMCBUSGNT = '1') or
      (MCBUSREQdbi = '1' and iMCBUSGNT = '0' and ArbState = ST_DBI_GNT_MC)) then
    McBusDrive       <= '1';
  else
    McBusDrive       <= '0';
  end if;
end process p_DriveMcComb;

-- -----------------------------------------------------------------------------
-- Multiplex the data to the Data Bus Interface output. The data bus
-- output is multiplexed between the SmcCore, Additional Memory Controller
-- and TIC
-- -----------------------------------------------------------------------------
p_DataGenComb : process (SMCDATAOUT, TBUSOUT, MCDATAOUT, TICBUSGNTdbi,
                         McBusDrive)
begin
  if (TICBUSGNTdbi = '1') then
    SMDATAOUT        <= TBUSOUT;
  elsif (McBusDrive = '1') then
    SMDATAOUT        <= MCDATAOUT;
  else
    SMDATAOUT        <= SMCDATAOUT;
  end if;
end process p_DataGenComb;

-- -----------------------------------------------------------------------------
-- Multiplex the Address to the Address Bus Interface. This Address Bus
-- output is multiplexed between SmcCore and Additional Memory Controller core.
-- -----------------------------------------------------------------------------
p_AddrGenComb : process (McBusDrive, SMCADDR, MCADDR)
begin
  if (McBusDrive = '1') then
    SMADDR           <= MCADDR;
  else
    SMADDR           <= SMCADDR;
  end if;
end process p_AddrGenComb;

-- -----------------------------------------------------------------------------
-- Pad Control Logic:
-- o If the SmcCore data enables or Additional Memory
--   Controller data enables are asserted, then irrespective of whether the
--   SmcCore or Additional Memory Controller is granted bus or not, the final
--   pads should be enabled.  This is due to the recirculation logic support.
-- o Whenever the TICREAD is asserted & TIC is granted, then the final pad will
--   be enabled.
-- -----------------------------------------------------------------------------
p_PadEnComb : process (nSMCDATAEN, MCDATAEN, TICREAD, TICBUSGNTdbi, McBusDrive)
begin
  nSMDATAEN    <= nSMCDATAEN;
  if (TICBUSGNTdbi = '1') then
    nSMDATAEN  <= not (TICREAD & TICREAD & TICREAD & TICREAD);
  elsif (McBusDrive = '1') then
    nSMDATAEN  <= MCDATAEN;
  end if;
end process p_PadEnComb;

-- -----------------------------------------------------------------------------
-- Connect local copies to the outputs
-- -----------------------------------------------------------------------------
MCBUSGNT         <= iMCBUSGNT;

end synth;

-- --================================== End ==================================--
