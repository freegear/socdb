-- --=========================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 1999 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
-- -----------------------------------------------------------------------------
--  
--  Version and Release Control Information:
--  
--  File Name              : smi.vhd,v
--  File Revision          : 1.2
--  
--  Release Information    : PL160-REL1v1
--  
-- --=========================================================================--

-- -----------------------------------------------------------------------------
-- Purpose : Synthesizable demonstration of an AMBA static memory
--           interface with configurable wait states (at least 1
--           write wait and up to four read or write waits).
--
-- -----------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;

-- include the Synopsys library when using Synopsys
--library synopsys;
--use     synopsys.attributes.all;

library common;
use common.defs.all;
--#synth off
use common.params.all;
--#synth on

entity smi is
  port (
        -- AMBA ASB signals
        BnRES    : in   std_ulogic;
        BA       : in   std_logic_vector(30 downto 0);
        BSIZE    : in   std_logic_vector(1 downto 0);
        BWRITE   : in   std_logic;
        DSEL     : in   std_ulogic;        
        BWAIT    : inout   std_logic;
        BLAST    : out   std_logic;
        BERROR   : out   std_logic;
        BCLK     : in    std_ulogic;
        
        BD       : inout std_logic_vector(31 downto 0);

        -- External memory map control
        Remap     : in   std_ulogic;

        -- Test Signals
        TestMode  : in std_ulogic;
        Ticinen   : in std_ulogic;
        Ticouten  : in std_ulogic; 
        TicoutLen : in std_ulogic; 

        -- External signals
        XWAIT        : in     std_logic;
        XnGBE        : in     std_logic;
       
        XA           : out    std_logic_vector(30 downto 0);
        XD           : inout  std_logic_vector(31 downto 0);
        XCLK         : out    std_logic;
        XCSN         : out    std_logic_vector(7 downto 0);
        XWEN         : out    std_ulogic_vector(3 downto 0);
        XOEN         : out    std_logic
        );
end smi;

architecture behavioral of smi is

-- include this attribute to get resettable latches when using Synopsys
--  attribute async_set_reset of BnRES : signal is "true";

  subtype t_csn   is std_logic_vector(7 downto 0);

  function decode ( A : std_logic_vector(30 downto 0) ) return
    t_csn is
  begin
    case A(30 downto 28) is
      when "000" =>  return "11111110";
      when "001" =>  return "11111101";
      when "010" =>  return "11111011";
      when "011" =>  return "11110111";
      when "100" =>  return "11101111";
      when "101" =>  return "11011111";
      when "110" =>  return "10111111";
      when "111" =>  return "01111111";
      when others => return "XXXXXXXX";
    end case;
  end decode;

-------------------------------------------------------------------------------
-- Clock signals
-------------------------------------------------------------------------------
  signal enclk       : std_ulogic;       -- Clock enable
  signal ctr_clk     : std_ulogic;       -- Gated clock

-------------------------------------------------------------------------------
-- Write control signals
-------------------------------------------------------------------------------
  signal iwen        : std_ulogic_vector(3 downto 0); -- internal write enable
  signal writectrl   : std_ulogic;                    -- enable iwen gen
  signal wenlen      : std_ulogic;                    -- enable iwen latch
  constant WNEN      : std_ulogic_vector(3 downto 0) := "1111";-- wen constants
  constant WW        : std_ulogic_vector(3 downto 0) := "0000";-- word
  constant WHWL      : std_ulogic_vector(3 downto 0) := "1100";-- half word
  constant WHWH      : std_ulogic_vector(3 downto 0) := "0011";
  constant WBLL      : std_ulogic_vector(3 downto 0) := "1110";-- byte
  constant WBL       : std_ulogic_vector(3 downto 0) := "1101";
  constant WBH       : std_ulogic_vector(3 downto 0) := "1011";
  constant WBHH      : std_ulogic_vector(3 downto 0) := "0111";
  constant WEX       : std_ulogic_vector(3 downto 0) := "XXXX";
  constant LOWLOW    : std_logic_vector(1 downto 0) := "00";
  constant LOW       : std_logic_vector(1 downto 0) := "01";
  constant HY        : std_logic_vector(1 downto 0) := "10";
  constant HYHY      : std_logic_vector(1 downto 0) := "11";

-------------------------------------------------------------------------------
-- Chip select constants
-------------------------------------------------------------------------------
  signal icsn       : std_logic_vector(7 downto 0);-- internal cs
  constant BOOTROM  : std_logic_vector(7 downto 0) := "01111111";-- ROM bank
  constant NOSELCT  : std_logic_vector(7 downto 0) := "11111111";-- no bank sel
 
-------------------------------------------------------------------------------
-- Counter signals
-------------------------------------------------------------------------------
  signal StLatchin  : std_ulogic;                      -- latch input
  signal StLatch    : std_ulogic;                      -- Phase delayed
  signal WaitCycles  : std_ulogic_vector(1 downto 0);  -- Wait counter
  signal NextWait    : std_ulogic_vector(1 downto 0);  -- Wait counter
  signal iwait       : std_ulogic;                     -- Internal wait signal
  constant ZERO : std_ulogic_vector(1 downto 0) := "00";
  constant ReadWaits : std_ulogic_vector(1 downto 0) := "00";  -- wait states
  constant WriteWaits : std_ulogic_vector(1 downto 0) := "01"; -- must be >0

-------------------------------------------------------------------------------
-- Bus signals
-------------------------------------------------------------------------------
  signal lbwrite     : std_ulogic;                      -- latched BWRITE
  signal lbsize      : std_logic_vector(1 downto 0);    -- latched BSIZE
  signal lba         : std_logic_vector(30 downto 0);   -- Latched address
  signal nOE         : std_ulogic;                      -- Output enable
  signal doutl       : std_logic_vector(31 downto 0);   -- Data out latch
  signal douten      : std_ulogic;                      -- Data out enable
  signal ddriveen    : std_ulogic;                      -- D_B drive enable
  signal wlaten      : std_ulogic;                      -- Data latch enable
  signal wlatcom     : std_ulogic;                      -- Data latch enable

  begin

-------------------------------------------------------------------------------
-- Cycle start detection and wait cycle control (zero wait allowed for reads)
-------------------------------------------------------------------------------

-- Start transfer latch
  StLatchin <= DSEL and iwait;
  start : process( BCLK )
  begin
    if (BCLK'event) and (BCLK = '1') then
      StLatch <= StLatchin;
    end if;
  end process start;             -- Single D-type latch

--Counter
  NextWait <= ZERO when BnRES = '0' else
              ReadWaits when StLatch = '0' and 
                               DSEL = '1' and BWRITE = '0' else
              WriteWaits when StLatch = '0' and 
                               DSEL = '1' and BWRITE = '1' else
              ZERO when WaitCycles = ZERO else
              (WaitCycles(0) and WaitCycles(1)) &
              ((not WaitCycles(0)) and WaitCycles(1)); -- Decrementor
  Counter : process( BCLK )
  begin
     if (BCLK'event) and (BCLK = '0') then
         WaitCycles <= NextWait after GAT3;
    end if;
  end process Counter;           -- Two D-type latches

  iwait <= XWAIT when WaitCycles = ZERO else
           '1';

-------------------------------------------------------------------------------
-- External signal drivers
-------------------------------------------------------------------------------

-- Memory write control
  writectrl <= enclk and lbwrite after GAT1;
  iwen <= WNEN after GAT3 when BnRES = '0' else
          WW   after GAT3 when writectrl = '1' and 
                               lBSize = SIZE_WORD else
          WHWH after GAT3 when writectrl = '1' and 
                               lBSize = SIZE_HALF and 
                               lba(1) = '1' else
          WHWL after GAT3 when writectrl = '1' and 
                               lBSize = SIZE_HALF and 
                               lba(1) = '0' else
          WBHH after GAT3 when writectrl = '1' and 
                               lBSize = SIZE_BYTE and 
                               lba(1 downto 0) = HYHY else
          WBH  after GAT3 when writectrl = '1' and 
                               lBSize = SIZE_BYTE and 
                               lba(1 downto 0) = HY else
          WBL  after GAT3 when writectrl = '1' and 
                               lBSize = SIZE_BYTE and 
                                lba(1 downto 0) = LOW else
          WBLL after GAT3 when writectrl = '1' and 
                               lBSize = SIZE_BYTE and 
                               lba(1 downto 0) = LOWLOW else
          WEX  after GAT3 when writectrl = '1' else -- show simulation errors
          WNEN after GAT3;

  wenlen <= stlatch after GAT1;  -- only for waited writes
  XWEN <= iwen after GAT1 when wenlen = '1' else
          WNEN after GAT1;

-- Memory select control
  icsn <= NOSELCT after GAT3 when BnRES = '0' else
          BOOTROM after GAT3 when DSEL = '1' and Remap = '0' else
          decode( BA ) after GAT3 when DSEL = '1' else
          NOSELCT after GAT3;
  csnlat : process (BCLK)
  begin
    if (BCLK'event) and (BCLK = '0') then
      XCSN <= icsn after DLPG;
    end if;
  end process csnlat;            -- Eight D-type latchs

-- Memory output enable control
  nOE     <= not (enclk and (not lbWrite)) after GAT2;

-- data out latch (designed to only drive valid data off chip)
-- ######## CRITICAL TIMING ON LATCH CLOCK ########
-- This needs to be taken into account in synthesis
-- bclk --> claten.
 wlatcom <= (enclk and (iwait or (not lbwrite))) or (not TicoutLen) after GAT3;
  wlaten <= BCLK and wlatcom after GAT1;
  wlat : process (wlaten, BD, BnRES)
  begin
    if BnRES = '0' then
      doutl <= (others => '0') after DLPG; 
    elsif wlaten = '1' then
      doutl <= BD after DLPG;
    end if;
  end process wlat;              -- 32 transparent latches

-- Output bus drivers
  douten <= (((nOE and not TestMode) or (not Ticouten)) and
            (not XnGBE)) after GAT3;
  XD <= doutl after BUSE when douten = '1' else
        (others => 'Z') after BUSD;

  XA <= lba after BUSE when (not XnGBE) = '1' else
        (others => 'Z') after BUSD;

  XOEN <= nOE after GAT3;        -- Delay in getting off chip
    
-------------------------------------------------------------------------------
-- Internal signal drivers
-------------------------------------------------------------------------------

  ddriveen <= (ctr_clk and (not Stlatch) and (not Stlatchin) and 
              (not lbwrite)) or (not Ticinen) after GAT3;
  BD <= XD after BUSE when ddriveen = '1' else
         (others => 'Z') after BUSD;

-- Slave response generation
  response : process (BCLK, DSEL, iwait)
  begin
    if (DSEL and (not BCLK)) = '1' then
      BWAIT  <= iwait after BUSE;
      BERROR <= '0' after BUSE;
      BLAST  <= '0' after BUSE;
    else
      BWAIT  <= 'Z' after BUSD;
      BERROR <= 'Z' after BUSD;
      BLAST  <= 'Z' after BUSD;
    end if;
  end process response;

-------------------------------------------------------------------------------
-- Control and clock generation
-------------------------------------------------------------------------------

-- selected `statemachine' (selected when enclk is '1')
   selector : process (BCLK)
   begin
    if (BCLK'event) and (BCLK = '0') then
        enclk <= DSEL after DLPG;
    end if;
  end process selector;             -- One D-type latch


-- address timing latches
   addrl : process (BCLK, BnRES)
   begin
    if BnRES = '0' then
        lbwrite <= '0' after DLPG;
        lba <= (others => '0') after DLPG;
        lbsize <= (others => '0') after DLPG;
    elsif (BCLK'event) and (BCLK = '0') then
        lbwrite <= BWRITE after DLPG;
        lba <= BA after DLPG;
        lbsize <= BSIZE after DLPG;
    end if;
  end process addrl;             -- 1 + 31 + 2 = 34 D-type latches

-- Clock generation 
  ctr_clk <= BCLK and enclk after GAT1;

  -- propagate clocks outside of this module
  XCLK  <= BCLK;

  
end behavioral;

-- --================================= End ===================================--
