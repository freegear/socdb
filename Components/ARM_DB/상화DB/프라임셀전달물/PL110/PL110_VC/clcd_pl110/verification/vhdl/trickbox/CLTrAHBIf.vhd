-- --=========================================================================--
--  This confidential and proprietary software may be used only as
--  authorised by a licensing agreement from ARM Limited
--    (C) COPYRIGHT 1999 ARM Limited
--        ALL RIGHTS RESERVED
--  The entire notice above must be reproduced on all authorised
--  copies and copies may only be made to the extent permitted
--  by a licensing agreement from ARM Limited.
--  ----------------------------------------------------------------------------
--
--  Version and Release Control Information:
--
--  File Name              : CLTrAHBIf.vhd.rca
--  File Revision          : 1.3
--
--  Release Information    : PrimeCell(TM)-PL110-r1p2-00ltd0
--
--  ----------------------------------------------------------------------------

--  ----------------------------------------------------------------------------
--  Purpose : CLCD Trickbox Bus AHB Interface
--
-- --=========================================================================--

library ieee;
use     ieee.std_logic_1164.all;
use     ieee.std_logic_arith.all;


-- -----------------------------------------------------------------------------

entity CLTrAHBIf is
  port (
         -- Inputs
         -- AHB Inputs
         HCLK           : in std_logic;
         HRESETN        : in std_logic;
         HADDR          : in std_logic_vector(9 downto 2);
         HTRANS         : in std_logic_vector(1 downto 0);
         HWRITE         : in std_logic;
         HSEL           : in std_logic;
         HSELCom        : in std_logic;
         HSIZE          : in std_logic_vector(2 downto 0);
         HBURST         : in std_logic_vector(2 downto 0);
         HWDATA         : in std_logic_vector(31 downto 0);
         HREADYIn       : in std_logic;

         -- Other Inputs
         CLTrRDATA      : in std_logic_vector(31 downto 0);
         Delay          : in std_logic_vector(31 downto 0);

         -- Outputs
         -- AHB Outputs
         HRDATA         : out std_logic_vector(31 downto 0);
         HREADYOut      : out std_logic;
         HRESP          : out std_logic_vector(1 downto 0);

         -- Other Outputs
         CLTrWRITE      : out std_logic;
         CLTrWDATA      : out std_logic_vector(31 downto 0);
         CLTrRegSel     : out std_logic;
         DelayRegSel    : out std_logic;
         CLTrControlSel : out std_logic;
         CLTrTiming0Sel : out std_logic;
         CLTrTiming1Sel : out std_logic;
         CLTrTiming2Sel : out std_logic;
         CLTrTiming3Sel : out std_logic;
         CLTrUPBASESel  : out std_logic;
         CLTrLPBASESel  : out std_logic;
         CLTrPalSel     : out std_logic;
         CLTrPalAddr    : out std_logic_vector(6 downto 0)
       );
end CLTrAHBIf;
 
-- -----------------------------------------------------------------------------
--
--                             CLTrAHBIf
--                             =========
--
-- -----------------------------------------------------------------------------
--
-- Overview
-- ========
-- This module is to interface with AHB Bus to talk to AHB Slave Testbench.
-- This module includes :
-- - Latching Block of Address & Control Signals
-- - Generation of HRESP, HREADYOut, HRDATA Block
-- - Address Decode Block
-- -----------------------------------------------------------------------------

--============================== ARCHITECTURE ================================--
--
--------------------------------------------------------------------------------
-- Architecture Packages
--------------------------------------------------------------------------------
 
architecture behavioural of CLTrAHBIf is
 
-- -----------------------------------------------------------------------------
-- Constant declarations
-- -----------------------------------------------------------------------------
constant CLTrTime0   : std_logic_vector(7 downto 0) :="00000000";
constant CLTrTime1   : std_logic_vector(7 downto 0) :="00000001";
constant CLTrTime2   : std_logic_vector(7 downto 0) :="00000010";
constant CLTrTime3   : std_logic_vector(7 downto 0) :="00000011";
constant CLTrUPBase  : std_logic_vector(7 downto 0) :="00000100";
constant CLTrLPBase  : std_logic_vector(7 downto 0) :="00000101";
constant CLTrCtrl    : std_logic_vector(7 downto 0) :="00000111";
constant CLTrPal     : std_logic_vector(7 downto 0) :="1XXXXXXX";
constant DelayReg    : std_logic_vector(7 downto 0) :="00000001";
constant CLTrReg     : std_logic_vector(7 downto 0) :="00000000";
 
-- -----------------------------------------------------------------------------
-- Signal declarations
-- -----------------------------------------------------------------------------
signal iHADDR          : std_logic_vector(9 downto 2);
signal iHWRITE         : std_logic;
signal iHTRANS         : std_logic_vector(1 downto 0);
signal iHSEL           : std_logic;
signal iHSELCom        : std_logic;
 
-- -----------------------------------------------------------------------------
-- Main body of code
-- =================
-- -----------------------------------------------------------------------------
begin
-- -----------------------------------------------------------------------------
-- Latching of Address & Control Signals.
-- -----------------------------------------------------------------------------
p_LatchSeq : process (HCLK, HRESETN) 
begin
  if (HRESETn'event and HRESETN = '0') then
    iHADDR     <= "00000000";
    iHSEL      <= '0';
    iHSELCom   <= '0';
    iHWRITE    <= '0';
    iHTRANS    <= "00";
  elsif (HCLK'event and HCLK = '1' and HREADYIn = '1') then
    iHSEL      <= HSEL;
    iHSELCom   <= HSELCom;
    if (HSEL = '1' or HSELCom = '1') then
      iHADDR     <= HADDR;
      iHWRITE    <= HWRITE;
      iHTRANS    <= HTRANS;
    end if;
  end if;
end process p_LatchSeq;
 
-- -----------------------------------------------------------------------------
-- CLCD HREADYOut Signal Generation:
-- When the slave is selected i.e. HSEL is high HREADYOut will be high.
-- -----------------------------------------------------------------------------
 HREADYOut <= '0' when ((Delay /= "00000000000000000000000000000000") 
                        and (iHSEL = '1'))
           else
              '1';
 
-- -----------------------------------------------------------------------------
-- CLCD HRESP Signal Generation:  Will be always OKAY.
-- -----------------------------------------------------------------------------
 HRESP     <= "00";
 
-- -----------------------------------------------------------------------------
-- CLCD Write Signal to CLCD Trickbox RegBlock
-- -----------------------------------------------------------------------------
 CLTrWRITE <= (iHSEL or iHSELCom ) and iHWRITE ;
 
-- -----------------------------------------------------------------------------
-- CLCD CLTrRegSel Signal to CL RegBlock
-- -----------------------------------------------------------------------------
 CLTrRegSel <= iHSEL;
p_Decodetrick : process (iHSEL, iHTRANS, iHADDR)
begin
  -- Default Values
  CLTrRegSel  <= '0';
  DelayRegSel <= '0';
  if ((iHSEL = '1') and (iHTRANS(1) = '1')) then
    case iHADDR is
      when CLTrReg =>
        CLTrRegSel <= '1';
      when DelayReg =>
        DelayRegSel <= '1';
      when others => 
        null;
    end case;
  end if;
end process p_Decodetrick;

 
-- -----------------------------------------------------------------------------
-- CLCD Register Write Data
-- -----------------------------------------------------------------------------
 CLTrWDATA <= HWDATA;
  
-- -----------------------------------------------------------------------------
-- CLCD Register Read  Data
-- -----------------------------------------------------------------------------
 HRDATA   <= CLTrRDATA;
 
-- -----------------------------------------------------------------------------
-- CLCD Register Address Decode
-- -----------------------------------------------------------------------------
p_DecodeComb : process (iHSELCom, iHTRANS, iHADDR) 
begin
  -- Default Values
  CLTrControlSel <= '0';
  CLTrTiming0Sel <= '0';
  CLTrTiming1Sel <= '0';
  CLTrTiming2Sel <= '0';
  CLTrTiming3Sel <= '0';
  CLTrUPBASESel  <= '0';
  CLTrLPBASESel  <= '0';
  CLTrPalSel     <= '0';
  CLTrPalAddr    <= "0000000";
  if (iHSELCom = '1' and iHTRANS(1) = '1') then 
    case iHADDR is
      when CLTrCtrl    => CLTrControlSel  <= '1';
      when CLTrTime0   => CLTrTiming0Sel  <= '1';
      when CLTrTime1   => CLTrTiming1Sel  <= '1';
      when CLTrTime2   => CLTrTiming2Sel  <= '1';
      when CLTrTime3   => CLTrTiming3Sel  <= '1';
      when CLTrUPBase  => CLTrUPBASESel   <= '1';
      when CLTrLPBase  => CLTrLPBASESel   <= '1';
      when others      =>
                          if (iHADDR(9) = '1') then
                            CLTrPalSel      <= '1';
                            CLTrPalAddr     <= iHADDR(8 downto 2);
                          end if;
    end case;
  end if;
end process p_DecodeComb;
 
end behavioural;
 
-- --================================== End ==================================--

