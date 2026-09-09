-- --=================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 2000 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
--
-- ---------------------------------------------------------------------
-- Version and Release Control Information:
--
-- File Name              : DefaultSlave.vhd.rca
-- File Revision          : 1.1
--
-- Release Information    : PrimeCell(TM)-GLOBAL-REL1v3
--
-- ---------------------------------------------------------------------
-- Purpose :
--           Default slave used to drive the slave response signals
--           when there are no other slaves selected.
--
-- --=================================================================--

library ieee;
use     ieee.std_logic_1164.all;

entity DefaultSlave is
  port(
    HCLK        : in  std_logic;
    HRESETn     : in  std_logic;
    HTRANS      : in  std_logic_vector(1 downto 0);
    HSELDefault : in  std_logic;
    HREADYin    : in  std_logic;

    HREADYout   : out std_logic;
    HRESP       : out std_logic_vector(1 downto 0)
    );
end DefaultSlave;

architecture synth of DefaultSlave is

-- ---------------------------------------------------------------------
-- Constant declarations
-- ---------------------------------------------------------------------
-- HTRANS transfer type signal encoding
  constant TRN_IDLE   : std_logic_vector(1 downto 0) := "00";
  constant TRN_BUSY   : std_logic_vector(1 downto 0) := "01";
  constant TRN_NONSEQ : std_logic_vector(1 downto 0) := "10";
  constant TRN_SEQ    : std_logic_vector(1 downto 0) := "11";

-- HRESP transfer response signal encoding
  constant RSP_OKAY  : std_logic_vector(1 downto 0) := "00";
  constant RSP_ERROR : std_logic_vector(1 downto 0) := "01";
  constant RSP_RETRY : std_logic_vector(1 downto 0) := "10";
  constant RSP_SPLIT : std_logic_vector(1 downto 0) := "11";

-- ---------------------------------------------------------------------
-- Signal declarations
-- ---------------------------------------------------------------------
  signal Invalid    : std_logic; -- Set during invalid transfer
  signal HreadyNext : std_logic; -- Controls generation of HREADYout
                                 -- output
  signal iHREADYout : std_logic; -- HREADYout register
  signal HrespNext  : std_logic_vector(1 downto 0);
                                 -- Generated response

-- ---------------------------------------------------------------------
-- Beginning of main code
-- ---------------------------------------------------------------------
begin

-- ---------------------------------------------------------------------
-- Invalid transfer detection
-- ---------------------------------------------------------------------
-- Set HIGH during the address phase of an invalid transfer, and is
-- used to control the generation of the response outputs.

  Invalid <= '1' when (HREADYin = '1' and HSELDefault = '1' and
                       (HTRANS = TRN_NONSEQ or HTRANS = TRN_SEQ))
             else '0';

-- ---------------------------------------------------------------------
-- Default slave output drivers
-- ---------------------------------------------------------------------
-- When an undefined area of the memory map is accessed, or an invalid
-- address is driven onto the address bus, the default slave outputs
-- are selected and passed to the current bus master.

-- For the two cycle error response, HREADY is set LOW during the first
-- cycle and HIGH during the second cycle.

  HreadyNext <= '1' when iHREADYout = '0' else
                '0' when Invalid = '1' else
                '1';

  p_HREADYoutSeq : process (HRESETn, HCLK)
  begin
    if (HRESETn = '0') then
      iHREADYout <= '1';
    elsif (HCLK'event and HCLK = '1') then
      iHREADYout <= HreadyNext;
    end if;
  end process p_HREADYoutSeq;

  HREADYout <= iHREADYout;

-- An OKAY response is generated for IDLE or BUSY transfers to
-- undefined locations, but a two cycle ERROR response is generated if
-- a non-sequential or sequential transfer is attempted.

  HrespNext <= RSP_ERROR when Invalid = '1' else RSP_OKAY;

  p_HRESPSeq : process (HRESETn, HCLK)
  begin
    if (HRESETn = '0') then
      HRESP <= RSP_OKAY;
    elsif (HCLK'event and HCLK = '1') then
      if iHREADYout = '1' then
        HRESP <= HrespNext;
      end if;
    end if;
  end process p_HRESPSeq;


end synth;

-- --============================== End ==============================--
