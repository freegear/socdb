-- --=========================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 2001-2002 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
--
-- -----------------------------------------------------------------------------
-- Version and Release Control Information:
--
-- File Name              : EbiTrRegBlk.vhd.rca
-- File Revision          : 1.2
--
-- Release Information    : PrimeCell(TM)-PL220-r0p0-00ltd0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           This block implements the AHB read/write registers in the
--           EBI Trickbox
--
-- --=========================================================================--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

-- -----------------------------------------------------------------------------

entity EbiTrRegBlk is
  port (
-- Inputs
        -- AHB bus signals
        HCLK             : in    std_logic; -- AHB Bus Clock
        MEMCLK1          : in    std_logic; -- Memory Clock1
        MEMCLK2          : in    std_logic; -- Memory Clock2
        MEMCLK3          : in    std_logic; -- Memory Clock3
        HRESETn          : in    std_logic; -- Bus Reset
        HREADYIN         : in    std_logic; -- HREADYIN for AHB
        WriteData        : in    std_logic_vector(31 downto 0);
                                            -- Write Data bus to the Register
                                            -- Block
        EbiTrCntlWr      : in    std_logic; -- EbiTrCntl register write enable
        EbiTrClkWr       : in    std_logic; -- EbiTrClk Register Write Enable
        EbiTrAddr1Wr     : in    std_logic; -- EbiTrAddr1 Register
                                            -- Write Enable
        EbiTrAddr2Wr     : in    std_logic; -- EbiTrAddr2 Register Write
                                            -- Enable
        EbiTrAddr3Wr     : in    std_logic; -- EbiTrAddr3 Register Write
                                            -- Enable
        EbiTrData1Wr     : in    std_logic; -- EbiTrData1 Register Write
                                            -- Enable
        EbiTrData2Wr     : in    std_logic; -- EbiTrData2 Register Write
                                            -- Enable
        EbiTrData3Wr     : in    std_logic; -- EbiTrData3 Register Write
                                            -- Enable
        nEbiTrDataEn1Wr  : in    std_logic; -- nEbiTrDataEn1 Register Write
                                            -- Enable
        nEbiTrDataEn2Wr  : in    std_logic; -- nEbiTrDataEn2 Register Write
                                            -- Enable
        nEbiTrDataEn3Wr  : in    std_logic; -- nEbiTrDataEn3 Register Write
                                            -- Enable
        EbiTrExtDataInWr : in    std_logic; -- EbiTrExtDataIn Register Write
                                            -- Enable
        EbiTrTimeOut1Wr  : in    std_logic; -- EbiTrTimeOut1 Register Write
                                            -- Enable
        EbiTrTimeOut2Wr  : in    std_logic; -- EbiTrTimeOut2 Register Write
                                            -- Enable
        EbiTrTimeOut3Wr  : in    std_logic; -- EbiTrTimeOut3 Register Write
                                            -- Enable
        EBIGNT1          : in    std_logic; -- grant signal from port1
        EBIGNT2          : in    std_logic; -- grant signal from port2
        EBIGNT3          : in    std_logic; -- grant signal from port3
        EBIBACKOFF1      : in    std_logic; -- backoff signal from port1
        EBIBACKOFF2      : in    std_logic; -- backoff signal from port2
        EBIBACKOFF3      : in    std_logic; -- backoff signal from port3

-- Outputs
        EBIREQ1          : out   std_logic; -- EBI Request from port1
        EBIREQ2          : out   std_logic; -- EBI Request from port2
        EBIREQ3          : out   std_logic; -- EBI Request from port3
        ClkFlag          : out   std_logic; -- Indicates whether Request
                                            -- comparison is clk by clk
        EventFlag        : out   std_logic; -- Indicates whether Request
                                            -- comparison is on event basis
        EbiTrCntl        : out   std_logic_vector(7 downto 0);
                                            -- EbiTrCntl Register
        EbiTrStatus      : out   std_logic_vector(5 downto 0);
                                            -- EbiTrStatus Register
        EbiTrClk         : out   std_logic_vector(2 downto 0);
                                            -- MEMCLK frequency indicator
        EbiTrAddr1       : out   std_logic_vector(31 downto 0);
                                            -- EbiTrAddr1 Register
        EbiTrAddr2       : out   std_logic_vector(31 downto 0);
                                            -- EbiTrAddr2 Register
        EbiTrAddr3       : out   std_logic_vector(31 downto 0);
                                            -- EbiTrAddr3 Register
        EbiTrData1       : out   std_logic_vector(31 downto 0);
                                            -- EbiTrData1 Register
        EbiTrData2       : out   std_logic_vector(31 downto 0);
                                            -- EbiTrData2 Register
        EbiTrData3       : out   std_logic_vector(31 downto 0);
                                            -- EbiTrData3 Register
        nEbiTrDataEn1    : out   std_logic_vector(3 downto 0);
                                            -- nEbiTrDataEn1 Register
        nEbiTrDataEn2    : out   std_logic_vector(3 downto 0);
                                            -- nEbiTrDataEn2 Register
        nEbiTrDataEn3    : out   std_logic_vector(3 downto 0);
                                            -- nEbiTrData3 Register
        EbiTrExtDataIn   : out   std_logic_vector(31 downto 0);
                                            -- EbiTrExtDataIn Register
        EbiTrTimeOut1    : out   std_logic_vector(9 downto 0);
                                            -- EbiTrTimeOut1 Register
        EbiTrTimeOut2    : out   std_logic_vector(9 downto 0);
                                            -- EbiTrTimeOut2 Register
        EbiTrTimeOut3    : out   std_logic_vector(9 downto 0);
                                            -- EbiTrTimeOut3 Register
        EBIADDR1         : out   std_logic_vector(31 downto 0);
                                            -- Address bus from port 1
        EBIADDR2         : out   std_logic_vector(31 downto 0);
                                            -- Address bus from port 2
        EBIADDR3         : out   std_logic_vector(31 downto 0);
                                            -- Address bus from port 3
        EBIDATA1         : out   std_logic_vector(31 downto 0);
                                            -- Data bus from port 1
        EBIDATA2         : out   std_logic_vector(31 downto 0);
                                            -- Data bus from port 2
        EBIDATA3         : out   std_logic_vector(31 downto 0);
                                            -- Data bus from port 3
        nEBIDATAEN1      : out   std_logic_vector(3 downto 0);
                                            -- Data enable bus from port 1
        nEBIDATAEN2      : out   std_logic_vector(3 downto 0);
                                            -- Data enable bus from port 2
        nEBIDATAEN3      : out   std_logic_vector(3 downto 0);
                                            -- Data enable bus from port 3
        EBIEXTDATAIN     : out   std_logic_vector(31 downto 0);
                                            -- External DataIn from the memory
        EBITIMEOUTVALUE1 : out   std_logic_vector(9 downto 0);
                                            -- Tie up value for port 1
        EBITIMEOUTVALUE2 : out   std_logic_vector(9 downto 0);
                                            -- Tie up value for port 2
        EBITIMEOUTVALUE3 : out   std_logic_vector(9 downto 0)
                                            -- Tie up value for port 3
       );
end EbiTrRegBlk;

-- -----------------------------------------------------------------------------
--
--                                 EbiTrRegBlk
--                                 ===========
--
-- -----------------------------------------------------------------------------
--
-- Overview
-- ========
-- EBI Tricbox is an AHB slave. This block performs the following operations:
--   - Implements EBI Trickbox registers
--   - Drives non-AMBA, non-memory related signals into the EBI
--
-- -----------------------------------------------------------------------------

-- --============================ ARCHITECTURE ===============================--

architecture behavioural of EbiTrRegBlk is

-- -----------------------------------------------------------------------------
-- Component declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Constant declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Signal declarations
-- -----------------------------------------------------------------------------

signal EbiTrCntlPos1    : std_logic;
-- Position of EBI Request1 indicator

signal EbiTrCntlPos2    : std_logic;
-- Position of EBI Request2 indicator

signal EbiTrCntlPos3    : std_logic;
-- Position of EBI Request3 indicator

signal iEBIREQ1         : std_logic := '0';
-- Internal version of EBIREQ1 Register

signal iEBIREQ2         : std_logic := '0';
-- Internal version of EBIREQ2 Register

signal iEBIREQ3         : std_logic := '0';
-- Internal version of EBIREQ3 Register

signal iEbiTrClk        : std_logic_vector(2 downto 0) := "000";
-- Internal version of EbiTrClk Register

signal iClkFlag         : std_logic := '0';
-- Internal version of ClkFlag

signal iEventFlag       : std_logic := '0';
-- Internal version of EventFlag

signal iEbiTrAddr1      : std_logic_vector(31 downto 0) := (others => '0');
-- Internal version of EbiTrAddr1 Register

signal iEbiTrAddr2      : std_logic_vector(31 downto 0) := (others => '0');
-- Internal version of EbiTrAddr2 Register

signal iEbiTrAddr3      : std_logic_vector(31 downto 0) := (others => '0');
-- Internal version of EbiTrAddr3 Register

signal iEbiTrData1      : std_logic_vector(31 downto 0) := (others => '0');
-- Internal version of EbiTrData1 Register

signal iEbiTrData2      : std_logic_vector(31 downto 0) := (others => '0');
-- Internal version of EbiTrData2 Register

signal iEbiTrData3      : std_logic_vector(31 downto 0) := (others => '0');
-- Internal version of EbiTrData3 Register

signal inEbiTrDataEn1   : std_logic_vector(3 downto 0) := (others => '0');
-- Internal version of nEbiTrDataEn1 Register

signal inEbiTrDataEn2   : std_logic_vector(3 downto 0) := (others => '0');
-- Internal version of nEbiTrDataEn2 Register

signal inEbiTrDataEn3   : std_logic_vector(3 downto 0) := (others => '0');
-- Internal version of nEbiTrDataEn3 Register

signal iEbiTrExtDataIn  : std_logic_vector(31 downto 0) := (others => '0');
-- Internal version of EbiTrExtDataIn Register

signal iEbiTrTimeOut1   : std_logic_vector(9 downto 0) := (others => '0');
-- Internal version of EbiTrTimeOut1 Register

signal iEbiTrTimeOut2   : std_logic_vector(9 downto 0) := (others => '0');
-- Internal version of EbiTrTimeOut2 Register

signal iEbiTrTimeOut3   : std_logic_vector(9 downto 0) := (others => '0');
-- Internal version of EbiTrTimeOut3 Register

signal NxtEBIREQ1       : std_logic := '0';
-- D-input for the EBIREQ1Q Register

signal NxtEBIREQ2       : std_logic := '0';
-- D-input for the EBIREQ2Q Register

signal NxtEBIREQ3       : std_logic := '0';
-- D-input for the EBIREQ3Q Register

signal NxtClkFlag       : std_logic  :=  '0';
-- D-input for the ClkFlag

signal NxtEventFlag     : std_logic  :=  '0';
-- D-input for the EventFlag

signal NxtEbiTrAddr1    : std_logic_vector(31 downto 0)  := (others => '0');
-- D-input for the EbiTrAddr1Q Register

signal NxtEbiTrAddr2    : std_logic_vector(31 downto 0) := (others => '0');
-- D-input for the EbiTrAddr2Q Register

signal NxtEbiTrAddr3    : std_logic_vector(31 downto 0) := (others => '0');
-- D-input for the EbiTrAddr3Q Register

signal NxtEbiTrData1    : std_logic_vector(31 downto 0) := (others => '0');
-- D-input for the EbiTrData1Q Register

signal NxtEbiTrData2    : std_logic_vector(31 downto 0) := (others => '0');
-- D-input for the EbiTrData2Q Register

signal NxtEbiTrData3    : std_logic_vector(31 downto 0) := (others => '0');
-- D-input for the EbiTrData3Q Register

signal NxtnEbiTrDataEn1 : std_logic_vector(3 downto 0) := (others => '0');
-- D-input for the nEbiTrDataEn1Q Register

signal NxtnEbiTrDataEn2 : std_logic_vector(3 downto 0) := (others => '0');
-- D-input for the nEbiTrDataEn2Q Register

signal NxtnEbiTrDataEn3 : std_logic_vector(3 downto 0) := (others => '0');
-- D-input for the nEbiTrDataEn3Q Register

signal NxtEbiTrExDataIn : std_logic_vector(31 downto 0) := (others => '0');
-- D-input for the EbiTrExtDataIn Register

signal NxtEbiTrTimeOut1 : std_logic_vector(9 downto 0) := (others => '0');
-- D-input for the EbiTrTimeOut1Q Register

signal NxtEbiTrTimeOut2 : std_logic_vector(9 downto 0) := (others => '0');
-- D-input for the EbiTrTimeOut2Q Register

signal NxtEbiTrTimeOut3 : std_logic_vector(9 downto 0) := (others => '0');
-- D-input for the EbiTrTimeOut3Q Register

signal NxtEbiTrClk      : std_logic_vector(2 downto 0);
-- D-input for the EbiTrClk

signal NxtEbiTrCntlPos1 : std_logic;
-- D-input for the EbiTrCntlPos1

signal NxtEbiTrCntlPos2 : std_logic;
-- D-input for the EbiTrCntlPos1

signal NxtEbiTrCntlPos3 : std_logic;
-- D-input for the EbiTrCntlPos1

signal EBIREQ1QQ        : std_logic := '0';
-- Clocked version of the EBIREQ1Q Register

signal EBIREQ2QQ        : std_logic := '0';
-- Clocked version of the EBIREQ2Q Register

signal EBIREQ3QQ        : std_logic := '0';
-- Clocked version of the EBIREQ3Q Register

signal EbiTrAddr1QQ     : std_logic_vector(31 downto 0)  := (others => '0');
-- Clocked version of the EbiTrAddr1Q Register

signal EbiTrAddr2QQ     : std_logic_vector(31 downto 0) := (others => '0');
-- Clocked version of the EbiTrAddr2Q Register

signal EbiTrAddr3QQ     : std_logic_vector(31 downto 0) := (others => '0');
-- Clocked version of the EbiTrAddr3Q Register

signal EbiTrData1QQ     : std_logic_vector(31 downto 0) := (others => '0');
-- Clocked version of the EbiTrData1Q Register

signal EbiTrData2QQ     : std_logic_vector(31 downto 0) := (others => '0');
-- Clocked version of the EbiTrData2Q Register

signal EbiTrData3QQ     : std_logic_vector(31 downto 0) := (others => '0');
-- Clocked version of the EbiTrData3Q Register

signal nEbiTrDataEn1QQ  : std_logic_vector(3 downto 0) := (others => '0');
-- Clocked version of the nEbiTrDataEn1Q Register

signal nEbiTrDataEn2QQ  : std_logic_vector(3 downto 0) := (others => '0');
-- Clocked version of the nEbiTrDataEn2Q Register

signal nEbiTrDataEn3QQ  : std_logic_vector(3 downto 0) := (others => '0');
-- Clocked version of the nEbiTrDataEn3Q Register

signal EbiTrTimeOut1QQ  : std_logic_vector(9 downto 0) := (others => '0');
-- Clocked version of the EbiTrTimeOut1Q Register

signal EbiTrTimeOut2QQ  : std_logic_vector(9 downto 0) := (others => '0');
-- Clocked version of the EbiTrTimeOut2Q Register

signal EbiTrTimeOut3QQ  : std_logic_vector(9 downto 0) := (others => '0');
-- Clocked version of the EbiTrTimeOut3Q Register

signal EBIREQ1Q         : std_logic := '0';
-- Clocked version of the NxtEBIREQ1 signal

signal EBIREQ2Q         : std_logic := '0';
-- Clocked version of the NxtEBIREQ2 signal

signal EBIREQ3Q         : std_logic := '0';
-- Clocked version of the NxtEBIREQ3 signal

signal EbiTrAddr1Q      : std_logic_vector(31 downto 0)  := (others => '0');
-- Clocked version of the NxtEbiTrAddr1 signal

signal EbiTrAddr2Q      : std_logic_vector(31 downto 0) := (others => '0');
-- Clocked version of the NxtEbiTrAddr2 signal

signal EbiTrAddr3Q      : std_logic_vector(31 downto 0) := (others => '0');
-- Clocked version of the NxtEbiTrAddr3 signal

signal EbiTrData1Q      : std_logic_vector(31 downto 0) := (others => '0');
-- Clocked version of the NxtEbiTrData1 signal

signal EbiTrData2Q      : std_logic_vector(31 downto 0) := (others => '0');
-- Clocked version of the NxtEbiTrData2 signal

signal EbiTrData3Q      : std_logic_vector(31 downto 0) := (others => '0');
-- Clocked version of the NxtEbiTrData3 signal

signal nEbiTrDataEn1Q   : std_logic_vector(3 downto 0) := (others => '0');
-- Clocked version of the NxtnEbiTrDataEn1 signal

signal nEbiTrDataEn2Q   : std_logic_vector(3 downto 0) := (others => '0');
-- Clocked version of the NxtnEbiTrDataEn2 signal

signal nEbiTrDataEn3Q   : std_logic_vector(3 downto 0) := (others => '0');
-- Clocked version of the NxtnEbiTrDataEn3 signal

signal EbiTrTimeOut1Q   : std_logic_vector(9 downto 0) := (others => '0');
-- Clocked version of the NxtEbiTrTimeOut1 signal

signal EbiTrTimeOut2Q   : std_logic_vector(9 downto 0) := (others => '0');
-- Clocked version of the NxtEbiTrTimeOut2 signal

signal EbiTrTimeOut3Q   : std_logic_vector(9 downto 0) := (others => '0');
-- Clocked version of the NxtEbiTrTimeOut3 signal

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
-- Combinational logic for all functional registers. When the respective
-- write enable input is asserted, copy the contents of the HWDATA Bus into
-- the corresponding registers.
-- -----------------------------------------------------------------------------
NxtEBIREQ1       <= WriteData(0) when (EbiTrCntlWr = '1')
                 else
                    EBIREQ1Q;

NxtEBIREQ2       <= WriteData(1) when (EbiTrCntlWr = '1')
                 else
                    EBIREQ2Q;

NxtEBIREQ3       <= WriteData(2) when (EbiTrCntlWr = '1')
                 else
                    EBIREQ3Q;

NxtEbiTrCntlPos1 <= WriteData(3) when (EbiTrCntlWr = '1')
                 else
                    EbiTrCntlPos1;

NxtEbiTrCntlPos2 <= WriteData(4) when (EbiTrCntlWr = '1')
                 else
                    EbiTrCntlPos2;

NxtEbiTrCntlPos3 <= WriteData(5) when (EbiTrCntlWr = '1')
                else
                    EbiTrCntlPos3;

NxtClkFlag       <= WriteData(6) when (EbiTrCntlWr = '1')
                 else
                    iClkFlag;

NxtEventFlag     <= WriteData(7) when (EbiTrCntlWr = '1')
                 else
                    iEventFlag;

NxtEbiTrClk      <= WriteData(2 downto 0) when (EbiTrClkWr = '1')
                 else
                    iEbiTrClk;

NxtEbiTrAddr1    <= WriteData(31 downto 0) when (EbiTrAddr1Wr = '1')
                 else
                    EbiTrAddr1Q;

NxtEbiTrAddr2    <= WriteData(31 downto 0) when (EbiTrAddr2Wr = '1')
                 else
                    EbiTrAddr2Q;

NxtEbiTrAddr3    <= WriteData(31 downto 0) when (EbiTrAddr3Wr = '1')
                 else
                    EbiTrAddr3Q;

NxtEbiTrData1    <= WriteData(31 downto 0) when (EbiTrData1Wr = '1')
                 else
                    EbiTrData1Q;

NxtEbiTrData2    <= WriteData(31 downto 0) when (EbiTrData2Wr = '1')
                 else
                    EbiTrData2Q;

NxtEbiTrData3    <= WriteData(31 downto 0) when (EbiTrData3Wr = '1')
                 else
                    EbiTrData3Q;

NxtnEbiTrDataEn1  <= WriteData(3 downto 0) when (nEbiTrDataEn1Wr = '1')
                 else
                    nEbiTrDataEn1Q;

NxtnEbiTrDataEn2  <= WriteData(3 downto 0) when (nEbiTrDataEn2Wr = '1')
                 else
                    nEbiTrDataEn2Q;

NxtnEbiTrDataEn3  <= WriteData(3 downto 0) when (nEbiTrDataEn3Wr = '1')
                 else
                    nEbiTrDataEn3Q;

NxtEbiTrExDataIn <= WriteData(31 downto 0) when (EbiTrExtDataInWr = '1')
                 else
                    iEbiTrExtDataIn;

NxtEbiTrTimeOut1 <= WriteData(9 downto 0) when (EbiTrTimeOut1Wr = '1')
                 else
                    EbiTrTimeOut1Q;

NxtEbiTrTimeOut2 <= WriteData(9 downto 0) when (EbiTrTimeOut2Wr = '1')
                 else
                    EbiTrTimeOut2Q;

NxtEbiTrTimeOut3 <= WriteData(9 downto 0) when (EbiTrTimeOut3Wr = '1')
                 else
                    EbiTrTimeOut3Q;

-- -----------------------------------------------------------------------------
-- Sequential process for functional registers on HCLK
-- -----------------------------------------------------------------------------
p_HclkSeq : process (HRESETn, HCLK)
begin
   if (HRESETn = '0') then
     EBIREQ1Q         <= '0';
     EbiTrAddr1Q      <= (others => '0');
     EbiTrData1Q      <= (others => '0');
     nEbiTrDataEn1Q   <= (others => '0');
     EbiTrTimeOut1Q   <= (others => '0');
     EBIREQ2Q         <= '0';
     EbiTrAddr2Q      <= (others => '0');
     EbiTrData2Q      <= (others => '0');
     nEbiTrDataEn2Q   <= (others => '0');
     EbiTrTimeOut2Q   <= (others => '0');
     EBIREQ3Q         <= '0';
     EbiTrAddr3Q      <= (others => '0');
     EbiTrData3Q      <= (others => '0');
     nEbiTrDataEn3Q   <= (others => '0');
     EbiTrTimeOut3Q   <= (others => '0');
     iClkFlag         <= '0';
     iEventFlag       <= '0';
     EbiTrCntlPos1    <= '0';
     EbiTrCntlPos2    <= '0';
     EbiTrCntlPos3    <= '0';
     iEbiTrClk        <= "000";
     iEbiTrExtDataIn  <= (others => '0');
   elsif (HCLK'event and HCLK = '1') then
     EBIREQ1Q         <= NxtEBIREQ1;
     EbiTrAddr1Q      <= NxtEbiTrAddr1;
     EbiTrData1Q      <= NxtEbiTrData1;
     nEbiTrDataEn1Q   <= NxtnEbiTrDataEn1;
     EbiTrTimeOut1Q   <= NxtEbiTrTimeOut1;
     EBIREQ2Q         <= NxtEBIREQ2;
     EbiTrAddr2Q      <= NxtEbiTrAddr2;
     EbiTrData2Q      <= NxtEbiTrData2;
     nEbiTrDataEn2Q   <= NxtnEbiTrDataEn2;
     EbiTrTimeOut2Q   <= NxtEbiTrTimeOut2;
     EBIREQ3Q         <= NxtEBIREQ3;
     EbiTrAddr3Q      <= NxtEbiTrAddr3;
     EbiTrData3Q      <= NxtEbiTrData3;
     nEbiTrDataEn3Q   <= NxtnEbiTrDataEn3;
     EbiTrTimeOut3Q   <= NxtEbiTrTimeOut3;
     iClkFlag         <= NxtClkFlag;
     iEventFlag       <= NxtEventFlag;
     EbiTrCntlPos1    <= NxtEbiTrCntlPos1;
     EbiTrCntlPos2    <= NxtEbiTrCntlPos2;
     EbiTrCntlPos3    <= NxtEbiTrCntlPos3;
     iEbiTrClk        <= NxtEbiTrClk;
     iEbiTrExtDataIn  <= NxtEbiTrExDataIn;
   end if;
end process p_HclkSeq;

-- -----------------------------------------------------------------------------
-- Sequential process for functional registers writes for Port1.
-- -----------------------------------------------------------------------------
p_MemClk1Seq : process (MEMCLK1, HRESETn)
begin
  if (HRESETn = '0') then
    EBIREQ1QQ         <= '0';
    EbiTrAddr1QQ      <= (others => '0');
    EbiTrData1QQ      <= (others => '0');
    nEbiTrDataEn1QQ   <= (others => '0');
    EbiTrTimeOut1QQ   <= (others => '0');
  elsif (MEMCLK1'event and MEMCLK1 = '1') then
    EBIREQ1QQ         <= EBIREQ1Q;
    EbiTrAddr1QQ      <= EbiTrAddr1Q;
    EbiTrData1QQ      <= EbiTrData1Q;
    nEbiTrDataEn1QQ   <= nEbiTrDataEn1Q;
    EbiTrTimeOut1QQ   <= EbiTrTimeOut1Q;
  end if;
end process p_MemClk1Seq;

-- -----------------------------------------------------------------------------
-- Mux to select between clocked or delayed request, address and data lines
-- for Port1
-- -----------------------------------------------------------------------------
p_EbiRePos1Comb : process (EbiTrCntlPos1,EBIREQ1QQ, EbiTrAddr1QQ,
                           EbiTrData1QQ, nEbiTrDataEn1QQ, EbiTrTimeOut1QQ,
                           EBIREQ1Q, EbiTrAddr1Q, EbiTrData1Q, nEbiTrDataEn1Q,
                           EbiTrTimeOut1Q)
begin
   if (EbiTrCntlPos1 = '0') then
      iEBIREQ1        <= EBIREQ1Q;
      iEbiTrAddr1     <= EbiTrAddr1Q;
      iEbiTrData1     <= EbiTrData1Q;
      inEbiTrDataEn1  <= nEbiTrDataEn1Q;
      iEbiTrTimeOut1  <= EbiTrTimeOut1Q;
   else
      iEBIREQ1        <= EBIREQ1QQ;
      iEbiTrAddr1     <= EbiTrAddr1QQ;
      iEbiTrData1     <= EbiTrData1QQ;
      inEbiTrDataEn1  <= nEbiTrDataEn1QQ;
      iEbiTrTimeOut1  <= EbiTrTimeOut1QQ;
   end if;
end process p_EbiRePos1Comb;

-- -----------------------------------------------------------------------------
-- Sequential process for all functional registers writes for Port2.
-- -----------------------------------------------------------------------------
p_MemClk2Seq : process (MEMCLK2, HRESETn)
begin
  if (HRESETn = '0') then
    EBIREQ2QQ         <= '0';
    EbiTrAddr2QQ      <= (others => '0');
    EbiTrData2QQ      <= (others => '0');
    nEbiTrDataEn2QQ   <= (others => '0');
    EbiTrTimeOut2QQ   <= (others => '0');

  elsif (MEMCLK2'event and MEMCLK2 = '1') then
    EBIREQ2QQ         <= EBIREQ2Q;
    EbiTrAddr2QQ      <= EbiTrAddr2Q;
    EbiTrData2QQ      <= EbiTrData2Q;
    nEbiTrDataEn2QQ   <= nEbiTrDataEn2Q;
    EbiTrTimeOut2QQ   <= EbiTrTimeOut2Q;
  end if;
end process p_MemClk2Seq;

-- -----------------------------------------------------------------------------
-- Mux to select between clocked or Delayed request, address and data lines
-- for Port2
-- -----------------------------------------------------------------------------
p_EbiRePos2Comb : process (EbiTrCntlPos2,EBIREQ2QQ, EbiTrAddr2QQ,
                           EbiTrData2QQ, nEbiTrDataEn2QQ, EbiTrTimeOut2QQ,
                           EBIREQ2Q, EbiTrAddr2Q, EbiTrData2Q, nEbiTrDataEn2Q,
                           EbiTrTimeOut2Q)
begin
   if (EbiTrCntlPos2 = '0') then
      iEBIREQ2        <= EBIREQ2Q;
      iEbiTrAddr2     <= EbiTrAddr2Q;
      iEbiTrData2     <= EbiTrData2Q;
      inEbiTrDataEn2  <= nEbiTrDataEn2Q;
      iEbiTrTimeOut2  <= EbiTrTimeOut2Q;
   else
      iEBIREQ2        <= EBIREQ2QQ;
      iEbiTrAddr2     <= EbiTrAddr2QQ;
      iEbiTrData2     <= EbiTrData2QQ;
      inEbiTrDataEn2  <= nEbiTrDataEn2QQ;
      iEbiTrTimeOut2  <= EbiTrTimeOut2QQ;
   end if;
end process p_EbiRePos2Comb;

-- -----------------------------------------------------------------------------
-- Sequential process for all functional registers writes for Port3.
-- -----------------------------------------------------------------------------
p_MemClk3Seq : process (MEMCLK3, HRESETn)
begin
  if (HRESETn = '0') then
    EBIREQ3QQ         <= '0';
    EbiTrAddr3QQ      <= (others => '0');
    EbiTrData3QQ      <= (others => '0');
    nEbiTrDataEn3QQ   <= (others => '0');
    EbiTrTimeOut3QQ   <= (others => '0');
  elsif (MEMCLK3'event and MEMCLK3 = '1') then
    EBIREQ3QQ         <= EBIREQ3Q;
    EbiTrAddr3QQ      <= EbiTrAddr3Q;
    EbiTrData3QQ      <= EbiTrData3Q;
    nEbiTrDataEn3QQ   <= nEbiTrDataEn3Q;
    EbiTrTimeOut3QQ   <= EbiTrTimeOut3Q;
  end if;
end process p_MemClk3Seq;

-- -----------------------------------------------------------------------------
-- Mux to select between clocked or delayed request, address and data lines
-- for Port3
-- -----------------------------------------------------------------------------
p_EbiRePos3Comb : process (EbiTrCntlPos3,EBIREQ3QQ, EbiTrAddr3QQ,
                           EbiTrData3QQ, nEbiTrDataEn3QQ, EbiTrTimeOut3QQ,
                           EBIREQ3Q, EbiTrAddr3Q, EbiTrData3Q, nEbiTrDataEn3Q,
                           EbiTrTimeOut3Q)
begin
   if (EbiTrCntlPos3 = '0') then
      iEBIREQ3         <= EBIREQ3Q;
      iEbiTrAddr3      <= EbiTrAddr3Q;
      iEbiTrData3      <= EbiTrData3Q;
      inEbiTrDataEn3   <= nEbiTrDataEn3Q;
      iEbiTrTimeOut3   <= EbiTrTimeOut3Q;
   else
      iEBIREQ3         <= EBIREQ3QQ;
      iEbiTrAddr3      <= EbiTrAddr3QQ;
      iEbiTrData3      <= EbiTrData3QQ;
      inEbiTrDataEn3   <= nEbiTrDataEn3QQ;
      iEbiTrTimeOut3   <= EbiTrTimeOut3QQ;
   end if;
end process p_EbiRePos3Comb;

-- -----------------------------------------------------------------------------
-- Assign register value to its corresponding port
-- -----------------------------------------------------------------------------
EBIREQ1          <= iEBIREQ1;
EBIREQ2          <= iEBIREQ2;
EBIREQ3          <= iEBIREQ3;
EBIADDR1         <= iEbiTrAddr1;
EBIADDR2         <= iEbiTrAddr2;
EBIADDR3         <= iEbiTrAddr3;
EBIDATA1         <= iEbiTrData1;
EBIDATA2         <= iEbiTrData2;
EBIDATA3         <= iEbiTrData3;
nEBIDATAEN1      <= inEbiTrDataEn1;
nEBIDATAEN2      <= inEbiTrDataEn2;
nEBIDATAEN3      <= inEbiTrDataEn3;
EBIEXTDATAIN     <= iEbiTrExtDataIn;
EBITIMEOUTVALUE1 <= iEbiTrTimeOut1;
EBITIMEOUTVALUE2 <= iEbiTrTimeOut2;
EBITIMEOUTVALUE3 <= iEbiTrTimeOut3;

-- -----------------------------------------------------------------------------
-- Assign local copies of signals to the outputs
-- -----------------------------------------------------------------------------
ClkFlag          <= iClkFlag;
EventFlag        <= iEventFlag;
EbiTrClk         <= iEbiTrClk;
EbiTrAddr1       <= iEbiTrAddr1;
EbiTrAddr2       <= iEbiTrAddr2;
EbiTrAddr3       <= iEbiTrAddr3;
EbiTrData1       <= iEbiTrData1;
EbiTrData2       <= iEbiTrData2;
EbiTrData3       <= iEbiTrData3;
nEbiTrDataEn1    <= inEbiTrDataEn1;
nEbiTrDataEn2    <= inEbiTrDataEn2;
nEbiTrDataEn3    <= inEbiTrDataEn3;
EbiTrExtDataIn   <= iEbiTrExtDataIn;
EbiTrTimeOut1    <= iEbiTrTimeOut1;
EbiTrTimeOut2    <= iEbiTrTimeOut2;
EbiTrTimeOut3    <= iEbiTrTimeOut3;
EbiTrCntl        <= iEventFlag & iClkFlag & EbiTrCntlPos3 & EbiTrCntlPos2 &
                    EbiTrCntlPos1 & iEBIREQ3 & iEBIREQ2 & iEBIREQ1;
EbiTrStatus      <= EBIBACKOFF3 & EBIBACKOFF2 & EBIBACKOFF1 &
                    EBIGNT3 & EBIGNT2 & EBIGNT1;

end behavioural;

-- --================================== End ==================================--
