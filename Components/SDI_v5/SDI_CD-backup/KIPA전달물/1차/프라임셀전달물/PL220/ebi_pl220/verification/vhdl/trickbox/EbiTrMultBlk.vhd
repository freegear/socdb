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
-- File Name              : EbiTrMultBlk.vhd.rca
-- File Revision          : 1.2
--
-- Release Information    : PrimeCell(TM)-PL220-r0p0-00ltd0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           This block implements the multiplexers for the address, data and
--           data enable signals
--
-- --=========================================================================--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

entity EbiTrMultBlk is
  port (
-- Inputs
        EBICLK           : in    std_logic; -- External Bus Interface Clock
        nPOR             : in    std_logic; -- Power On Reset
        EbiTrGnt         : in    std_logic_vector(2 downto 0);
                                            -- EbiTrGnt(0) EBI Grant for Port 1
                                            -- EbiTrGnt(1) EBI Grant for Port 2
                                            -- EbiTrGnt(2) EBI Grant for Port 3
        EBIADDR1         : in    std_logic_vector(31 downto 0);
                                            -- EBI Address for Port 1
        EBIADDR2         : in    std_logic_vector(31 downto 0);
                                            -- EBI Address for Port 2
        EBIADDR3         : in    std_logic_vector(31 downto 0);
                                            -- EBI Address for Port 3
        nEBIDATAEN1      : in    std_logic_vector(3 downto 0);
                                            -- EBI Data Enable for port 1
        nEBIDATAEN2      : in    std_logic_vector(3 downto 0);
                                            -- EBI Data Enable for port 2
        nEBIDATAEN3      : in    std_logic_vector(3 downto 0);
                                            -- EBI Data Enable for port 3
        EBIDATA1         : in    std_logic_vector(31 downto 0);
                                            -- EBI Data for Port 1
        EBIDATA2         : in    std_logic_vector(31 downto 0);
                                            -- EBI Data for Port 2
        EBIDATA3         : in    std_logic_vector(31 downto 0);
                                            -- EBI Data for Port 3
        EBIEXTDATAIN     : in    std_logic_vector(31 downto 0);
                                            -- EBI External Data In

-- Outputs
        EbiTrDataIn      : out   std_logic_vector(31 downto 0);
                                            -- Data input connected to all the
                                            -- Controllers
        EbiTrExtAddrOut  : out   std_logic_vector(31 downto 0);
                                            -- Address output to the pads
        EbiTrExtDataOut  : out   std_logic_vector(31 downto 0);
                                            -- Data output to the pads
        nEbiTrExtDataEn  : out   std_logic_vector(3 downto 0)
                                            -- Data Enable to the pads
       );
end EbiTrMultBlk;

-- -----------------------------------------------------------------------------
--
--                                EbiTrMultBlk
--                                ============
--
-- -----------------------------------------------------------------------------
--
-- Overview
-- ========
-- o Multiplexer block
--     The multiplexer block multiplexes the address, data and data enable lines
--     from three separate controllers on to the common address, data and
--     data enable pins of the chip.
--
-- -----------------------------------------------------------------------------

-- --============================= ARCHITECTURE ==============================--

architecture behavioural of EbiTrMultBlk is

-- -----------------------------------------------------------------------------
-- Component declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Constant declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Signal declarations
-- -----------------------------------------------------------------------------
signal iEbiTrExtDataOut : std_logic_vector(31 downto 0) := (others => '0');
-- Latched version of the EbiTrExtDataOut signal

signal iEbiTrExtAddrOut : std_logic_vector(31 downto 0) := (others => '0');
-- Latched version of the EbiTrExtAddrOut signal

signal inEbiTrExtDataEn : std_logic_vector(3 downto 0)  := (others => '1');
-- Latched version of the nEbiTrExtDataEn signal

signal EbiTrExtDataOutl : std_logic_vector(31 downto 0) := (others => '0');
-- Internal version of the EbiTrExtDataOut signal

signal EbiTrExtAddrOutl : std_logic_vector(31 downto 0) := (others => '0');
-- Internal version of the EbiTrExtAddrOut signal

signal nEbiTrExtDataEnl : std_logic_vector(3 downto 0)  := (others => '1');
-- Internal version of the nEbiTrExtDataEn signal

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
-- This process latches the previous values of EbiTrExtDataOutl,
-- EbiTrExtAddrOutl and nEbiTrExtDataEnl which is set as default
-- on common address, data and data enable pins of the chip.
-- -----------------------------------------------------------------------------
p_latchSeq : process (EBICLK, nPOR)
begin
  if (nPOR = '0') then
    iEbiTrExtDataOut <= (others => '0');
    iEbiTrExtAddrOut <= (others => '0');
    inEbiTrExtDataEn <= "1111";
  elsif (EBICLK'event and EBICLK = '1') then
    iEbiTrExtDataOut <= EbiTrExtDataOutl;
    iEbiTrExtAddrOut <= EbiTrExtAddrOutl;
    inEbiTrExtDataEn <= nEbiTrExtDataEnl;
  end if;
end process p_latchSeq;
-- -----------------------------------------------------------------------------
-- Mux the EBIDATA signals which is sent out as EbiTrExtDataOut
-- based on the EbiTrGnt signal .
-- -----------------------------------------------------------------------------
EbiTrExtDataOut <= EBIDATA1 when EbiTrGnt = "001"
                 else
                   EBIDATA2 when EbiTrGnt = "010"
                 else
                   EBIDATA3 when EbiTrGnt = "100"
                 else
                   iEbiTrExtDataOut;
-- -----------------------------------------------------------------------------
-- Mux the EBIDATA signals which is used for internal latching
-- based on the EbiTrGnt signal .
-- -----------------------------------------------------------------------------
EbiTrExtDataOutl <= EBIDATA1 when EbiTrGnt = "001"
                  else
                    EBIDATA2 when EbiTrGnt = "010"
                  else
                    EBIDATA3 when EbiTrGnt = "100"
                  else
                    iEbiTrExtDataOut;
-- -----------------------------------------------------------------------------
-- Mux the EBIADDR signals which is sent out as EbiTrExtAddrOut
-- based on the EbiTrGnt signal.
-- -----------------------------------------------------------------------------
EbiTrExtAddrOut <= EBIADDR1 when EbiTrGnt = "001"
                 else
                   EBIADDR2 when EbiTrGnt = "010"
                 else
                   EBIADDR3 when EbiTrGnt = "100"
                 else
                   iEbiTrExtAddrOut;
-- -----------------------------------------------------------------------------
-- Mux the EBIADDR signals which is used for internal latching
-- based on the EbiTrGnt signal.
-- -----------------------------------------------------------------------------
EbiTrExtAddrOutl <= EBIADDR1 when EbiTrGnt = "001"
                  else
                    EBIADDR2 when EbiTrGnt = "010"
                  else
                    EBIADDR3 when EbiTrGnt = "100"
                  else
                    iEbiTrExtAddrOut;
-- -----------------------------------------------------------------------------
-- Mux the nEBIDATAEN signals which is sent out as nEbiTrExtDataEn
-- based on the EbiTrGnt signal.
-- -----------------------------------------------------------------------------
nEbiTrExtDataEn <= nEBIDATAEN1 when EbiTrGnt = "001"
                 else
                   nEBIDATAEN2 when EbiTrGnt = "010"
                 else
                   nEBIDATAEN3 when EbiTrGnt = "100"
                 else
                   inEbiTrExtDataEn;
-- -----------------------------------------------------------------------------
-- Mux the nEBIDATAEN signals which is used for internal latching
-- based on the EbiTrGnt signal.
-- -----------------------------------------------------------------------------
nEbiTrExtDataEnl <= nEBIDATAEN1 when EbiTrGnt = "001"
                  else
                    nEBIDATAEN2 when EbiTrGnt = "010"
                  else
                    nEBIDATAEN3 when EbiTrGnt = "100"
                  else
                    inEbiTrExtDataEn;
-- -----------------------------------------------------------------------------
-- The value on EBIEXTDATAIN signal is passed on EbiTrDataIn
-- signal.
-- -----------------------------------------------------------------------------
EbiTrDataIn <= EBIEXTDATAIN;

end behavioural;

-- --================================== End ==================================--
