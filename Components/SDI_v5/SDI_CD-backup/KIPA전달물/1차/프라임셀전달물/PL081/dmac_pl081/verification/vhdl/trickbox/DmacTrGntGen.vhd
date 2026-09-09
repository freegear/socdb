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
-- File Name              : DmacTrGntGen.vhd.rca
-- File Revision          : 1.5
--
-- Release Information    : PrimeCell(TM)-PL081-REL1v0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           This block is responsible for generating HGRANT to AHB Master
--
-- --=========================================================================--
 
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
 
use work.DmacTrPackage.all;
 
-- -----------------------------------------------------------------------------
 
entity DmacTrGntGen is
  port (
-- Inputs
        HCLK             : in    std_logic; -- AHB clock
        HRESETn          : in    std_logic; -- AHB reset
        HBUSREQDMAC      : in    std_logic; -- Bus request signal from AHB
        HREADYINM        : in    std_logic; -- Transfer done response on AHB
        HBURSTM          : in    std_logic_vector(2 downto 0);
                                            -- Burst length on AHB
        GrantCount       : in    std_logic_vector(31 downto 0);
                                            -- Burst length on AHB
-- Outputs
        HGRANTDMACM      : out   std_logic  -- AHB bus grant for master
       );
end DmacTrGntGen;
-- -----------------------------------------------------------------------------
--
--                              DmacTrGntGen
--                              ============
--
-- -----------------------------------------------------------------------------
--
-- Overview
-- ========
--   This block is responsible for driving out HGRANT for Master module.
--   The different Schemes used to generate the Grants are
--   a) Default Granted method.
--   b) Toggle method.
--   c) Request based method without count dependent.
--   d) Request based method with count dependent.
--   e) Break in the Middle of burst for fixed number of clock.
--   f) Break in the middle of the burst for 1HCLK
--
-- -----------------------------------------------------------------------------


-- --=========================== ARCHITECTURE ================================--

architecture behavioural of DmacTrGntGen is

-- -----------------------------------------------------------------------------
-- Component declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Constant declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Signal declarations
-- -----------------------------------------------------------------------------
signal ToggleMode       : std_logic;
-- This mode is used to toggle the Grant as programmed in GrantCount reg

signal DefGranted       : std_logic;
-- In this mode the Grant is always high

signal ReqBased         : std_logic;
-- In this mode the Grant is given after sampling the request

signal ReqBasedDel      : std_logic;
-- In this mode the Grant is given after sampling the request and count is 0

signal BreakMid         : std_logic;
-- In this mode the Grant is deasserted at the middle of the Burst

signal OneClkBreak      : std_logic;
-- In this mode the Grant is deasserted for 1HCLK in the middle of burst

signal ToggleST         : std_logic_vector(2 downto 0);
-- States for toggle mode

signal NextToggleST     : std_logic_vector(2 downto 0);
-- D-Input of ToggleST

signal OnCountValue     : std_logic_vector(3 downto 0);
-- Counter for counting number of Clocks HGRANT should be asserted

signal NextOnCount      : std_logic_vector(3 downto 0);
-- D-Input of OnCountValue

signal OffCountValue    : std_logic_vector(3 downto 0);
-- Counter for counting number of Clocks HGRANT should be de-asserted

signal NextOffCount     : std_logic_vector(3 downto 0);
-- D-Input of OffCountValue

signal Count4           : std_logic_vector(1 downto 0);
-- Burst4 Counter

signal NextCount4       : std_logic_vector(1 downto 0);
-- D-Input of Count4

signal Count8           : std_logic_vector(2 downto 0);
-- Burst4 Counter

signal NextCount8       : std_logic_vector(2 downto 0);
-- D-Input of Count8

signal Count16          : std_logic_vector(3 downto 0);
-- Burst16 Counter

signal NextCount16      : std_logic_vector(3 downto 0);
-- D-Input of Count16

signal ReqCount         : std_logic_vector(1 downto 0);
-- Counter to indicate as to how many clocks the HGRANT should be low

signal NextReqCount     : std_logic_vector(1 downto 0);
-- D-Input of ReqCount

signal HgrantReg        : std_logic;
-- Clocked HGRANT

signal NextHgrantReg    : std_logic;
-- D-Input of HgrantReg

signal iHGRANTDMACM     : std_logic;
-- Internal version of HGRANTDMACM

signal HgrantTog        : std_logic;
-- Toggle HGRANT

signal RemGrant         : std_logic;
-- Indication to deassert the grant

signal GrantAfterXClk   : std_logic;
-- Clocked HGRANT when the grant has to be set after X Clocks

signal NextGrantXClk    : std_logic;
-- D-Input of GrantAfterXClk

signal Count16Down      : std_logic_vector(3 downto 0);
-- Burst16 Down Counter

signal NextCount16Down  : std_logic_vector(3 downto 0);
-- D-Input of Count16Down

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

ToggleMode   <= GrantCount(4);
DefGranted   <= GrantCount(5);
ReqBased     <= GrantCount(6);
BreakMid     <= GrantCount(7);
OneClkBreak  <= GrantCount(8);
ReqBasedDel  <= GrantCount(11);

-- -----------------------------------------------------------------------------
-- This process is responsible for generating the grant for Toggle mode
-- Here the grant remains set till the Count value goes to 0. This is coded as
-- a small SM where the GRANT_ON and GRANT_OFF state controls the toggling of
-- grant.
-- -----------------------------------------------------------------------------
p_CountComb : process (ToggleST, OnCountValue, OffCountValue, GrantCount)
begin
  NextToggleST <= ToggleST;
  NextOnCount  <= OnCountValue;
  NextOffCount <= OffCountValue;
  case ToggleST is
    when GRANT_IDLE =>
      if (GrantCount(3 downto 0) /= "0000") then
        NextToggleST <= GRANT_ON;
        NextOnCount  <= GrantCount(3 downto 0);
      end if;

    when GRANT_ON =>
      NextOnCount <= OnCountValue - "0001";
      if (OnCountValue = "0001") then
        if (GrantCount(3 downto 0) /= "0000") then
          NextToggleST <= GRANT_OFF;
          NextOffCount <= GrantCount(3 downto 0);
        else
          NextToggleST <= GRANT_IDLE;
          NextOffCount <= (others => '0');
          NextOnCount  <= (others => '0');
        end if;
      end if;

    when GRANT_OFF =>
      NextOffCount <= OffCountValue - "0001";
      if (OffCountValue = "0001") then
        if (GrantCount(3 downto 0) /= "0000") then
          NextToggleST <= GRANT_ON;
          NextOnCount  <= GrantCount(3 downto 0);
        else
          NextToggleST <= GRANT_IDLE;
          NextOffCount <= (others => '0');
          NextOnCount  <= (others => '0');
        end if;
      end if;

    when others =>
      null;
  end case;
end process p_CountComb;

-- -----------------------------------------------------------------------------
-- This process gives an indication as to from where the Grant has to be
-- removed(which is from the middle of burst) till the count value programmed.
-- But for OneClkBreak the Grant is removed for only one clock in the middle of
-- the burst.
-- -----------------------------------------------------------------------------
p_BurstMidComb : process (Count4, Count8, Count16, ReqCount, HBURSTM, HREADYINM,
                          iHGRANTDMACM, BreakMid, OneClkBreak, GrantCount)
begin
  NextCount4   <= Count4;
  NextCount8   <= Count8;
  NextCount16  <= Count16;
  NextReqCount <= ReqCount;
  case HBURSTM is
    when INCR4 =>
      if ((HREADYINM = '1') and (iHGRANTDMACM = '1')) then
        if (Count4 = "00") then
          NextReqCount <= GrantCount(10 downto 9);
        end if;
        NextCount4 <= Count4 + "01";
        if ((Count4 = "01") and (BreakMid = '1') and (ReqCount /= "00")) then
          RemGrant <= '1';
        elsif ((Count4 = "01") and (OneClkBreak = '1')) then
          RemGrant <= '1';
        end if;
      elsif (HREADYINM = '1') then
        NextReqCount <= ReqCount - "01";
        if ((Count4 = "01") and (BreakMid = '1') and (ReqCount = "00")) then
          RemGrant <= '0';
        elsif ((Count4 = "01") and (OneClkBreak = '1')) then
          RemGrant <= '0';
        end if;
      end if;

    when INCR8 =>
      if ((HREADYINM = '1') and (iHGRANTDMACM = '1')) then
        if (Count8 = "000") then
          NextReqCount <= GrantCount(10 downto 9);
        end if;
        NextCount8 <= Count8 + "001";
        if ((Count8 = "011") and (BreakMid = '1') and (ReqCount /= "00")) then
          RemGrant <= '1';
        elsif ((Count8 = "011") and (OneClkBreak = '1')) then
          RemGrant <= '1';
        end if;
      elsif (HREADYINM = '1') then
        NextReqCount <= ReqCount - "01";
        if ((Count8 = "011") and (BreakMid = '1') and (ReqCount = "00")) then
          RemGrant <= '0';
        elsif ((Count8 = "011") and (OneClkBreak = '1')) then
          RemGrant <= '0';
        end if;
      end if;

    when INCR16 =>
      if ((HREADYINM = '1') and (iHGRANTDMACM = '1')) then
        if (Count16 = "0000") then
          NextReqCount <= GrantCount(10 downto 9);
        end if;
        NextCount16 <= Count16 + "0001";
        if ((Count16 = "0111") and (BreakMid = '1') and (ReqCount /= "00")) then
          RemGrant <= '1';
        elsif ((Count16 = "0111") and (OneClkBreak = '1')) then
          RemGrant <= '1';
        end if;
      elsif (HREADYINM = '1') then
        NextReqCount <= ReqCount - "01";
        if ((Count16 = "0111") and (BreakMid = '1') and (ReqCount = "00")) then
          RemGrant <= '0';
        elsif ((Count16 = "0111") and (OneClkBreak = '1')) then
          RemGrant <= '0';
        end if;
      end if;

    when others =>
      RemGrant     <= '0';
  end case;
end process p_BurstMidComb;

-- -----------------------------------------------------------------------------
-- HGRANT generation block. Here except for Toggle mode HGRANT is clocked out.
-- -----------------------------------------------------------------------------
p_GrantComb : process (ToggleMode, ToggleST, DefGranted, ReqBased, HBUSREQDMAC,
                       BreakMid, RemGrant, OneClkBreak, HgrantReg, Count16Down,
                       GrantAfterXClk, ReqBasedDel, GrantCount)
begin
  NextHgrantReg <= HgrantReg;
  NextCount16Down <= Count16Down;
  NextGrantXClk <= GrantAfterXClk;
  if (ToggleMode = '1') then
    if (ToggleST = GRANT_ON) then
      HgrantTog <= '1';
    elsif (ToggleST = GRANT_OFF) then
      HgrantTog <= '0';
    else
      HgrantTog <= '0';
    end if;
  elsif (DefGranted = '1') then
    NextHgrantReg <= '1';
  elsif (ReqBased = '1') then
    if (HBUSREQDMAC = '1') then
      NextHgrantReg <= '1';
      if (BreakMid = '1') then
        if (RemGrant = '1') then
          NextHgrantReg <= '0';
        else
          NextHgrantReg <= '1';
        end if;
      elsif (OneClkBreak = '1') then
        if (RemGrant = '1') then
          NextHgrantReg <= '0';
        else
          NextHgrantReg <= '1';
        end if;
      end if;
    else
      NextHgrantReg <= '0';
    end if;
  elsif (ReqBasedDel = '1') then
    if ((Count16Down = "0000") and (GrantAfterXClk = '0')) then
      NextCount16Down <= GrantCount(3 downto 0);
    elsif (GrantAfterXClk = '0') then
      NextCount16Down <= Count16Down - "0001"; 
    else
      NextCount16Down <= (others => '0');
    end if;

    if (HBUSREQDMAC = '1') then
      if ((Count16Down = "0000") and (GrantAfterXClk = '0')) then
        NextGrantXClk <= '1';
      end if;
    else
      NextGrantXClk <= '0';
    end if;
  end if;
end process p_GrantComb;

iHGRANTDMACM <= HgrantTog when (ToggleMode = '1')
             else
                HgrantReg when ((DefGranted = '1') or (ReqBased = '1'))
             else
                GrantAfterXClk when (ReqBasedDel = '1')
             else
                '1';

HGRANTDMACM <= iHGRANTDMACM;
-- -----------------------------------------------------------------------------
-- Registering all the next state signals
-- -----------------------------------------------------------------------------
p_GrantSeq : process (HRESETn, HCLK)
begin
  if (HRESETn = '0') then
    ToggleST         <= GRANT_IDLE;
    OnCountValue     <= (others => '0');
    OffCountValue    <= (others => '0');
    Count4           <= (others => '0');
    Count8           <= (others => '0');
    Count16          <= (others => '0');
    ReqCount         <= (others => '0');
    HgrantReg        <= '0';
    GrantAfterXClk   <= '0';
    Count16Down      <= (others => '0');
  elsif (HCLK'event and HCLK = '1') then
    ToggleST         <= NextToggleST;
    OnCountValue     <= NextOnCount;
    OffCountValue    <= NextOffCount;
    Count4           <= NextCount4;
    Count8           <= NextCount8;
    Count16          <= NextCount16;
    ReqCount         <= NextReqCount;
    HgrantReg        <= NextHgrantReg;
    GrantAfterXClk   <= NextGrantXClk;
    Count16Down      <= NextCount16Down;
  end if;
end process p_GrantSeq;

end behavioural;

-- --================================== End ==================================--
