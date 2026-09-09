-- --=========================================================================--
--  This confidential and proprietary software may be used only as
--  authorised by a licensing agreement from ARM Limited
--    (C) COPYRIGHT 1999 ARM Limited
--        ALL RIGHTS RESERVED
--  The entire notice above must be reproduced on all authorised
--  copies and copies may only be made to the extent permitted
--  by a licensing agreement from ARM Limited.
--
--  ----------------------------------------------------------------------------
--  Version and Release Control Information:
--
--  File Name              : SspTrCkRsCntlr.vhd.rca
--  File Revision          : 1.2
--
--  Release Information    : PrimeCell(TM)-PL022-REL1v2
--
-- -----------------------------------------------------------------------------
-- Purpose      : This generates the SSPCLK from either PCLK or an 
--                internally generated clock.It also has the RESET controller.
-- -----------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

-- -----------------------------------------------------------------------------

entity SspTrCkRsCntlr is
  port (
        PCLK         : in std_logic;  -- APB bus clock
        PRESETn      : in std_logic;  -- APB Reset
        SCANMODEIN   : in std_logic;  -- SSP TrickBox SCANMODE bit
        RSTMODE      : in std_logic;  -- SSP TrickBox RXTMODE bit
        SSPTBCLKREG  : in std_logic_vector(15 downto 0) := "0000000000000000";
                                      -- SSPCLK frequency value
        SSPTBCLKREG1 : in std_logic_vector(15 downto 0) := "0000000000000000";
                                      -- SSPCLK1 frequency value
        SSPTrCNTLR   : in std_logic_vector(4 downto 0);
                                      -- Clock Select
        SCANMODE     : out std_logic; -- SCANMODE output signal
        nSSPRST      : out std_logic; -- SSP reset signal
        SSPCLK       : out std_logic; -- SSP Reference Clock Signal
        SSPCLK1      : out std_logic; -- SSP Reference Clock Signal
        PCLKOn       : out std_logic; -- Indicates PCLK is routed to SSPCLK line
        REFCLKOn     : out std_logic; -- Indicates internally generated 
                                      -- SSPRefClk is routed to SSPCLK line
        REFCLK1On    : out std_logic  -- Indicates internally generated 
                                      -- SSPRefClk1 is routed to SSPCLK1 line
       );
end SspTrCkRsCntlr;

-- -----------------------------------------------------------------------------
--
--                               SspTrCkRsCntlr
--                               ==============
--
-- -----------------------------------------------------------------------------
--
-- Overview
-- ========
--
-- This Clock-Reset Controller provides the nSSPRST and SSPCLK signal to the
-- Ssp. The nSSPRST is derived from the RSTMODE bit of the TB_SET_PINS Register.
-- Whenever the RSTMODE bit is asserted, the nSSPRST is asserted asynchronously
-- but the deassertion is synchronized with respect to the SSPCLK.
-- The SSPRefClk generator generates a clock whose frequency is dependent on
-- the SCLKTBCLKREG.
-- The SSPRefClk1 generator generates a clock whose frequency is dependent on
-- the SCLKTBCLKREG1.
-- Depending on the state of SSPTrCNTLR SSPRefClk, SSPRefClk1 or PCLK is routed
-- as the final SSPCLK.
-- -----------------------------------------------------------------------------

-- --============================ ARCHITECTURE ===============================--

architecture behavioural of SspTrCkRsCntlr  is

-- -----------------------------------------------------------------------------
-- Signal declarations
-- -----------------------------------------------------------------------------
signal SSPRefClk        : std_logic := '0'; 
-- Generated as per SSPTBCLKREG

signal SSPRefClk1       : std_logic := '0'; 
-- Generated as per SSPTBCLKREG1

signal iSSPClk          : std_logic := '0'; 
-- Internal SSPClk

signal iSSPClk1         : std_logic := '0'; 
-- Internal SSPClk1

signal PCLKEnNegSync    : std_logic := '0'; 
-- PCLKEN bit synced to falling edge of PCLK

signal RCLKEnNegSync    : std_logic := '0';
-- RCLKEn bit synced to falling edge of SSPRefClk

signal RCLK1EnNegSync   : std_logic := '0';
-- RCLKEn1 bit synced to falling edge of SSPRefClk1

signal MuxInRCLK        : std_logic := '0';
-- RCLKEnNegSync anded with SSPRefClk

signal MuxInRCLK1       : std_logic := '0';
-- RCLK1EnNegSync anded with SSPRefClk1

signal MuxInPCLK        : std_logic := '0';
-- PCLKEnNegSync anded with PCLK

signal iSCANMODE        : std_logic;
-- Internal version of SCANMODE

-- -----------------------------------------------------------------------------
-- Function declarations
-- -----------------------------------------------------------------------------
function to_integer (val : std_logic_vector; x : integer := 0)
return integer is
variable returnint : integer;  -- Return integer from the function
variable xtmp      : integer;  -- Temporary variable
begin
  returnint := 0;
  xtmp := 0;
  if x /= 0 then
    xtmp := 1;
  end if;
  for i in val'range loop
    returnint := returnint + returnint;
    case val(i) is
      when '0' =>     null;
      when '1' =>     returnint := returnint + 1;
      when others =>  returnint := returnint + xtmp;
    end case;
  end loop;
  return returnint;
end to_integer;

function CONV_INTEGER(arg: std_logic_vector) return integer is
variable OutVal : integer;
begin
  if (arg = "UUUUUUUUUUUUUUUU") then
    OutVal := 2;
  else
    OutVal := CONV_INTEGER(arg);
  end if;
    return OutVal;
end CONV_INTEGER;

-- -----------------------------------------------------------------------------
--
-- Main body of code
-- =================
--
-- -----------------------------------------------------------------------------

begin

-- -----------------------------------------------------------------------------
-- Connect local copies to output ports
-- -----------------------------------------------------------------------------
SSPCLK   <= iSSPClk;
SSPCLK1  <= iSSPClk1;
SCANMODE <= iSCANMODE;

-- -----------------------------------------------------------------------------
-- SSPRefClk generation based on the value in SSPTBCLKREG
-- -----------------------------------------------------------------------------
p_SSPCLKGenSeq: process (SSPTBCLKREG, SSPRefClk)
  variable  Clk_low  : time := 10 ns ;  --Clock Width 
  variable  Clk_high : time := 10 ns ;  --Clock Width
begin
  if (SSPTBCLKREG /= "0000000000000000" and SSPTBCLKREG /= "UUUUUUUUUUUUUUUU")
     then
    if (SSPTBCLKREG(0) = '1') then
      Clk_low := (CONV_INTEGER(unsigned('0' & SSPTBCLKREG(15 downto 1))) + 1 )
                  * 1 ns;
    else
      Clk_low := CONV_INTEGER (unsigned('0' & SSPTBCLKREG(15 downto 1)))
                 * 1 ns;    
    end if;
    Clk_high := CONV_INTEGER(unsigned( '0' & SSPTBCLKREG(15 downto 1))) * 1 ns
                ;
    if (SSPRefClk = '1') then
      SSPRefClk <= '0' after Clk_high ;
    else
      SSPRefClk <= '1' after Clk_low ;
    end if;
  end if;
end process p_SSPCLKGenSeq; 

-- -----------------------------------------------------------------------------
-- SSPRefClk1 generation based on the value in SSPTBCLKREG1
-- -----------------------------------------------------------------------------
p_SSPCLKGenSeq1: process (SSPTBCLKREG1, SSPRefClk1)
  variable  Clk_low  : time := 10 ns ;  --Clock Width 
  variable  Clk_high : time := 10 ns ;  --Clock Width
begin
  if (SSPTBCLKREG1 /= "0000000000000000" and
      SSPTBCLKREG1 /= "UUUUUUUUUUUUUUUU") then
    if (SSPTBCLKREG1(0) = '1') then
      Clk_low := (CONV_INTEGER(unsigned('0' & 
                  SSPTBCLKREG1(15 downto 1))) + 1 )
                  * 1 ns;
    else
      Clk_low := CONV_INTEGER (unsigned('0' & SSPTBCLKREG1(15 downto 1)))
                 * 1 ns;    
    end if;
    Clk_high := CONV_INTEGER(unsigned( '0' & SSPTBCLKREG1(15 downto 1)))
                 * 1 ns ;
    if (SSPRefClk1 = '1') then
      SSPRefClk1 <= '0' after Clk_high ;
    else
      SSPRefClk1 <= '1' after Clk_low ;
    end if;
  end if;
end process p_SSPCLKGenSeq1; 

-- -----------------------------------------------------------------------------
-- Reset signal generator.The Reset is done asynchronously but the deassertion
-- is done synchronous to the SSPClk clock.
-- -----------------------------------------------------------------------------
p_RstCtrlSeq: process (RSTMODE, iSSPClk, PRESETn)
begin
  if (PRESETn = '0' ) then
    nSSPRST <= '0';
  elsif (iSSPClk'event and iSSPClk = '0') then
      nSSPRST <= RSTMODE;
  end if;
end process p_RstCtrlSeq;

-- -----------------------------------------------------------------------------
-- This process generates the SCANMODE signal.
-- -----------------------------------------------------------------------------
p_SMGenComb: process (SCANMODEIN)
begin
  if (SCANMODEIN = '1') then
    iSCANMODE <= '1';
  else
    iSCANMODE <='0';
  end if;
end process p_SMGenComb;

-- -----------------------------------------------------------------------------
-- Synchronize the Enable of the PCLK to the PCLK domain.
-- -----------------------------------------------------------------------------
p_PCLKEnSyncSeq: process (PCLK, SSPTrCNTLR)
begin
  if (PCLK'event and PCLK = '0') then
    PCLKEnNegSync <= SSPTrCNTLR(1);
  end if;
end process p_PCLKEnSyncSeq;

-- -----------------------------------------------------------------------------
-- Synchronize the Enable of the SSPRefClk to the SSPRefClk domain.
-- -----------------------------------------------------------------------------
p_RCLKEnSyncSeq: process (SSPRefClk, SSPTrCNTLR)
begin
  if (SSPRefClk'event and SSPRefClk = '0') then
    RCLKEnNegSync <= SSPTrCNTLR(2);
  end if;
end process p_RCLKEnSyncSeq;

-- -----------------------------------------------------------------------------
-- Synchronize the Enable of the SSPRefClk1 to the SSPRefClk1 domain.
-- -----------------------------------------------------------------------------
p_RCLK1EnSyncSeq: process (SSPRefClk1, SSPTrCNTLR)
begin
  if (SSPRefClk1'event and SSPRefClk1 = '0') then
    RCLK1EnNegSync <= SSPTrCNTLR(3);
  end if;
end process p_RCLK1EnSyncSeq;

-- -----------------------------------------------------------------------------
-- Writes the Status Bits PCLKOn and REFCLKOn into the Status Register of the 
-- TrickBox and the write is done on seeing the positive edge of the PCLK  
-- -----------------------------------------------------------------------------
p_StatGenSeq: process (PCLK, PCLKEnNegSync, RCLKEnNegSync)
begin
  if (PCLK'event and PCLK = '1') then
    PCLKOn    <= PCLKEnNegSync;
    REFCLKOn  <= RCLKEnNegSync;
    REFCLK1On <= RCLK1EnNegSync;
  end if;
end process p_StatGenSeq;

-- ----------------------------------------------------------------------------
-- Derive intermediate clock signals by gating the clocks with the respective
-- enable signals synchronised to the corresponding clock domain.
-- ----------------------------------------------------------------------------
MuxInRCLK  <= SSPRefClk and RCLKEnNegSync;
MuxInPCLK  <= PCLK      and PCLKEnNegSync;
MuxInRCLK1 <= SSPRefClk1 and RCLK1EnNegSync;

-- ----------------------------------------------------------------------------
-- This process routes either MuxInPCLK or MuxInRCLK to SSPCLK and also routes
-- MuxInPCLK or MuxInRCLK1 to SSPCLK1 with respect to SSPTrCNTLR reg
-- ----------------------------------------------------------------------------
p_RoutComp : process (SSPTrCNTLR, MuxInPCLK, MuxInRCLK, MuxInRCLK1 )
begin
  if (SSPTrCNTLR(4) = '0') then
    if (SSPTrCNTLR(0) /= 'X') then
      if (SSPTrCNTLR(0) = '1') then
        iSSPCLK1 <= MuxInPCLK;
        iSSPCLK  <= MuxInPCLK;
      else
        iSSPCLK1 <= MuxInRCLK;
        iSSPCLK  <= MuxInRCLK;
      end if;
    end if;
  elsif (SSPTrCNTLR(4) = '1') then
    if (SSPTrCNTLR(0) /= 'X') then
      if (SSPTrCNTLR(0) = '1') then
        iSSPCLK1 <= MuxInRCLK1;
        iSSPCLK  <= MuxInPCLK;
      else
        iSSPCLK1 <= MuxInRCLK1;
        iSSPCLK  <= MuxInRCLK;
      end if;
    end if;
  end if;
end process p_RoutComp;
end behavioural;

-- --================================ End ====================================--

