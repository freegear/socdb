-- --=========================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 2000-2001 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
--
-- -----------------------------------------------------------------------------
-- Version and Release Control Information:
--
-- File Name              : DmacTrIntArb.vhd.rca
-- File Revision          : 1.5
--
-- Release Information    : PrimeCell(TM)-PL081-REL1v0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           This module is responsible for generating Grant signal for Channels
--
-- --=========================================================================--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

-- -----------------------------------------------------------------------------

entity DmacTrIntArb is
  port (
-- Inputs
        HCLK             : in    std_logic; -- AHB clock
        HRESETn          : in    std_logic; -- AHB reset
        Ch0Req           : in    std_logic; -- Channel0 req to Arbiter
        Ch1Req           : in    std_logic; -- Channel1 req to Arbiter
        Ch2Req           : in    std_logic; -- Channel2 req to Arbiter
        Ch3Req           : in    std_logic; -- Channel3 req to Arbiter
        Ch4Req           : in    std_logic; -- Channel4 req to Arbiter
        Ch5Req           : in    std_logic; -- Channel5 req to Arbiter
        Ch6Req           : in    std_logic; -- Channel6 req to Arbiter
        Ch7Req           : in    std_logic; -- Channel7 req to Arbiter
        StopArb          : in    std_logic; -- Stop Arb indication from Master
        Ch0HWDATA        : in    std_logic_vector(31 downto 0);
                                            -- AHB Write Data from Ch0
        Ch1HWDATA        : in    std_logic_vector(31 downto 0);
                                            -- AHB Write Data from Ch1
        Ch2HWDATA        : in    std_logic_vector(31 downto 0);
                                            -- AHB Write Data from Ch2
        Ch3HWDATA        : in    std_logic_vector(31 downto 0);
                                            -- AHB Write Data from Ch3
        Ch4HWDATA        : in    std_logic_vector(31 downto 0);
                                            -- AHB Write Data from Ch4
        Ch5HWDATA        : in    std_logic_vector(31 downto 0);
                                            -- AHB Write Data from Ch5
        Ch6HWDATA        : in    std_logic_vector(31 downto 0);
                                            -- AHB Write Data from Ch6
        Ch7HWDATA        : in    std_logic_vector(31 downto 0);
                                            -- AHB Write Data from Ch7
-- Outputs
        ReqForAhbBus     : out   std_logic; -- Indication for Master Interface
                                            -- to put request on Bus
        HWDATA           : out   std_logic_vector(31 downto 0);
                                            -- AHB Write Data bus
        Ch0Comb          : out   std_logic; -- Channel0 selected
        Ch1Comb          : out   std_logic; -- Channel1 selected
        Ch2Comb          : out   std_logic; -- Channel2 selected
        Ch3Comb          : out   std_logic; -- Channel3 selected
        Ch4Comb          : out   std_logic; -- Channel4 selected
        Ch5Comb          : out   std_logic; -- Channel5 selected
        Ch6Comb          : out   std_logic; -- Channel6 selected
        Ch7Comb          : out   std_logic  -- Channel7 selected
       );
end DmacTrIntArb;

-- -----------------------------------------------------------------------------
--
--                           DmacTrIntArb
--                           ============
--
-- -----------------------------------------------------------------------------
--
-- Overview
-- ========
-- This module is responsible for giving the Grants to the different channels
-- based on the Fixed Priority Scheme(Channel0 Highest Priority and Channel7
-- Lowest Priority). This scheme is applicable only in the window when StopArb
-- signal is sampled low.
--
-- -----------------------------------------------------------------------------

-- --=========================== ARCHITECTURE ================================--

architecture behavioural of DmacTrIntArb is

-- -----------------------------------------------------------------------------
-- Component declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Constant declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Signal declarations
-- -----------------------------------------------------------------------------
signal iReqForAhbBus    : std_logic;
-- Request for AHB Bus

signal iCh0Comb         : std_logic;
-- 1 HCLK window indicating Ch0 selected

signal Ch0Sel           : std_logic;
-- Channel0 selected

signal iCh1Comb         : std_logic;
-- 1 HCLK window indicating Ch1 selected

signal Ch1Sel           : std_logic;
-- Channel1 selected

signal iCh2Comb         : std_logic;
-- 1 HCLK window indicating Ch2 selected

signal Ch2Sel           : std_logic;
-- Channel2 selected

signal iCh3Comb         : std_logic;
-- 1 HCLK window indicating Ch3 selected

signal Ch3Sel           : std_logic;
-- Channel3 selected

signal iCh4Comb         : std_logic;
-- 1 HCLK window indicating Ch4 selected

signal Ch4Sel           : std_logic;
-- Channel4 selected

signal iCh5Comb         : std_logic;
-- 1 HCLK window indicating Ch5 selected

signal Ch5Sel           : std_logic;
-- Channel5 selected

signal iCh6Comb         : std_logic;
-- 1 HCLK window indicating Ch6 selected

signal Ch6Sel           : std_logic;
-- Channel6 selected

signal iCh7Comb         : std_logic;
-- 1 HCLK window indicating Ch7 selected

signal Ch7Sel           : std_logic;
-- Channel7 selected

signal ChArbMaskOn      : std_logic;
-- Combinational signal to indicate that Further arbitration is masked off

signal ChMaskReg        : std_logic;
-- Register to hold the combination grant select signal

signal NextChMaskReg    : std_logic;
-- D-Input of ChMaskReg

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
-- Assigning internal signals to the outputs
-- -----------------------------------------------------------------------------
ReqForAhbBus     <= iReqForAhbBus;
Ch0Comb          <= iCh0Comb;
Ch1Comb          <= iCh1Comb;
Ch2Comb          <= iCh2Comb;
Ch3Comb          <= iCh3Comb;
Ch4Comb          <= iCh4Comb;
Ch5Comb          <= iCh5Comb;
Ch6Comb          <= iCh6Comb;
Ch7Comb          <= iCh7Comb;


iReqForAhbBus    <= Ch0Sel or Ch1Sel or Ch2Sel or Ch3Sel or Ch4Sel or Ch5Sel or
                    Ch6Sel or Ch7Sel;

-- -----------------------------------------------------------------------------
-- This combinational process is responsible for generating the grant signal
-- for the DMAC Channels. The request lines are sampled based on the priority.
-- Once the channel is selected, it remains selected till the address of the
-- last beat is put on the bus. This signal is indicated by the StopArb signal.
-- Till this interval the mask is on.
-- The request to the Master is generated by ORing the select lines of each
-- channel.
-- -----------------------------------------------------------------------------
p_ArbComb : process (StopArb, ChArbMaskOn, Ch0Req, Ch1Req, Ch2Req, Ch3Req,
                     Ch4Req, Ch5Req, Ch6Req, Ch7Req, iCh0Comb, iCh1Comb,
                     iCh2Comb, iCh3Comb, iCh4Comb, iCh5Comb, iCh6Comb,
                     iCh7Comb, ChMaskReg)
begin
  iCh0Comb <= '0';
  iCh1Comb <= '0';
  iCh2Comb <= '0';
  iCh3Comb <= '0';
  iCh4Comb <= '0';
  iCh5Comb <= '0';
  iCh6Comb <= '0';
  iCh7Comb <= '0';
  NextChMaskReg <= ChMaskReg;
  if ((StopArb = '0') and (ChArbMaskOn = '0')) then
    if (Ch0Req = '1') then
      iCh0Comb <= '1';
    elsif (Ch1Req = '1') then
      iCh1Comb <= '1';
    elsif (Ch2Req = '1') then
      iCh2Comb <= '1';
    elsif (Ch3Req = '1') then
      iCh3Comb <= '1';
    elsif (Ch4Req = '1') then
      iCh4Comb <= '1';
    elsif (Ch5Req = '1') then
      iCh5Comb <= '1';
    elsif (Ch6Req = '1') then
      iCh6Comb <= '1';
    elsif (Ch7Req = '1') then
      iCh7Comb <= '1';
    end if;
  end if;

  if ((iCh0Comb or iCh1Comb or iCh2Comb or iCh3Comb or iCh4Comb or
       iCh5Comb or iCh6Comb or iCh7Comb) = '1') then
    NextChMaskReg <= '1';
  elsif ((ChMaskReg = '1') and (StopArb = '0')) then
    NextChMaskReg <= '0';
  end if;

  if (StopArb = '0') then
    ChArbMaskOn <= StopArb;
  else
    ChArbMaskOn <= ChMaskReg;
  end if;

  if (iCh0Comb = '1') then
    Ch0Sel <= '1';
  elsif (((iCh1Comb or iCh2Comb or iCh3Comb or iCh4Comb or iCh5Comb or
           iCh6Comb or iCh7Comb) = '0') and (ChArbMaskOn = '1')) then
    Ch0Sel <= ChArbMaskOn;
  else
    Ch0Sel <= '0';
  end if;

  if (iCh1Comb = '1') then
    Ch1Sel <= '1';
  elsif (((iCh0Comb or iCh2Comb or iCh3Comb or iCh4Comb or iCh5Comb or
           iCh6Comb or iCh7Comb) = '0') and (ChArbMaskOn = '1')) then
    Ch1Sel <= ChArbMaskOn;
  else
    Ch1Sel <= '0';
  end if;

  if (iCh2Comb = '1') then
    Ch2Sel <= '1';
  elsif (((iCh0Comb or iCh1Comb or iCh3Comb or iCh4Comb or iCh5Comb or
           iCh6Comb or iCh7Comb) = '0') and (ChArbMaskOn = '1')) then
    Ch2Sel <= ChArbMaskOn;
  else
    Ch2Sel <= '0';
  end if;

  if (iCh3Comb = '1') then
    Ch3Sel <= '1';
  elsif (((iCh0Comb or iCh1Comb or iCh2Comb or iCh4Comb or iCh5Comb or
           iCh6Comb or iCh7Comb) = '0') and (ChArbMaskOn = '1')) then
    Ch3Sel <= ChArbMaskOn;
  else
    Ch3Sel <= '0';
  end if;

  if (iCh4Comb = '1') then
    Ch4Sel <= '1';
  elsif (((iCh0Comb or iCh1Comb or iCh2Comb or iCh3Comb or iCh5Comb or
           iCh6Comb or iCh7Comb) = '0') and (ChArbMaskOn = '1')) then
    Ch4Sel <= ChArbMaskOn;
  else
    Ch4Sel <= '0';
  end if;

  if (iCh5Comb = '1') then
    Ch5Sel <= '1';
  elsif (((iCh0Comb or iCh1Comb or iCh2Comb or iCh3Comb or iCh4Comb or
           iCh6Comb or iCh7Comb) = '0') and (ChArbMaskOn = '1')) then
    Ch5Sel <= ChArbMaskOn;
  else
    Ch5Sel <= '0';
  end if;

  if (iCh6Comb = '1') then
    Ch6Sel <= '1';
  elsif (((iCh0Comb or iCh1Comb or iCh2Comb or iCh3Comb or iCh4Comb or
           iCh5Comb or iCh7Comb) = '0') and (ChArbMaskOn = '1')) then
    Ch6Sel <= ChArbMaskOn;
  else
    Ch6Sel <= '0';
  end if;

  if (iCh7Comb = '1') then
    Ch7Sel <= '1';
  elsif (((iCh0Comb or iCh1Comb or iCh2Comb or iCh3Comb or iCh4Comb or
           iCh5Comb or iCh7Comb) = '0') and (ChArbMaskOn = '1')) then
    Ch7Sel <= ChArbMaskOn;
  else
    Ch7Sel <= '0';
  end if;

end process p_ArbComb;

-- -----------------------------------------------------------------------------
-- Sequential process for ChMaskReg register
-- -----------------------------------------------------------------------------
p_ArbSeq : process (HRESETn, HCLK)
begin
  if (HRESETn = '0') then
    ChMaskReg    <= '0';
  elsif (HCLK'event and HCLK = '1') then
    ChMaskReg    <= NextChMaskReg;
  end if;
end process p_ArbSeq;

-- -----------------------------------------------------------------------------
-- Logic to Route HWDATA Lines on the Bus 
-- -----------------------------------------------------------------------------
p_HWDATAComb : process (Ch0HWDATA, Ch1HWDATA, Ch2HWDATA, Ch3HWDATA,
                        Ch4HWDATA, Ch5HWDATA, Ch6HWDATA, Ch7HWDATA)
begin
  HWDATA <= Ch0HWDATA or Ch1HWDATA or Ch2HWDATA or Ch3HWDATA or
            Ch4HWDATA or Ch5HWDATA or Ch6HWDATA or Ch7HWDATA;
end process p_HWDATAComb;

end behavioural;

-- --================================= End ===================================--
