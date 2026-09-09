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
-- File Name              : MuxM2S.vhd.rca
-- File Revision          : 1.1
--
-- Release Information    : PrimeCell(TM)-GLOBAL-REL1v5
--
-- ---------------------------------------------------------------------
-- Purpose :
--           Central multiplexer - signals from masters to slaves.
--           Also generates the default master outputs when no
--           other masters are selected.
--           Stand-alone module to allow ease of removal if an
--           alternative interconnection scheme is to be used.
--
-- --=================================================================--

library IEEE;
use     IEEE.std_logic_1164.all;

entity MuxM2S is
  port(
    HCLK      : in  std_logic;
    HRESETn   : in  std_logic;
    HMASTER   : in  std_logic_vector(3 downto 0);
    HREADY    : in  std_logic;

    HADDRarm  : in  std_logic_vector(31 downto 0);
    HTRANSarm : in  std_logic_vector(1 downto 0);
    HWRITEarm : in  std_logic;
    HSIZEarm  : in  std_logic_vector(2 downto 0);
    HBURSTarm : in  std_logic_vector(2 downto 0);
    HPROTarm  : in  std_logic_vector(3 downto 0);
    HWDATAarm : in  std_logic_vector(31 downto 0);

    HADDRtic  : in  std_logic_vector(31 downto 0);
    HTRANStic : in  std_logic_vector(1 downto 0);
    HWRITEtic : in  std_logic;
    HSIZEtic  : in  std_logic_vector(2 downto 0);
    HBURSTtic : in  std_logic_vector(2 downto 0);
    HPROTtic  : in  std_logic_vector(3 downto 0);
    HWDATAtic : in  std_logic_vector(31 downto 0);

    HADDR003  : in  std_logic_vector(31 downto 0);
    HTRANS003 : in  std_logic_vector(1 downto 0);
    HWRITE003 : in  std_logic;
    HSIZE003  : in  std_logic_vector(2 downto 0);
    HBURST003 : in  std_logic_vector(2 downto 0);
    HPROT003  : in  std_logic_vector(3 downto 0);
    HWDATA003 : in  std_logic_vector(31 downto 0);

    HADDR004  : in  std_logic_vector(31 downto 0);
    HTRANS004 : in  std_logic_vector(1 downto 0);
    HWRITE004 : in  std_logic;
    HSIZE004  : in  std_logic_vector(2 downto 0);
    HBURST004 : in  std_logic_vector(2 downto 0);
    HPROT004  : in  std_logic_vector(3 downto 0);
    HWDATA004 : in  std_logic_vector(31 downto 0);

    HADDR     : out std_logic_vector(31 downto 0);
    HTRANS    : out std_logic_vector(1 downto 0);
    HWRITE    : out std_logic;
    HSIZE     : out std_logic_vector(2 downto 0);
    HBURST    : out std_logic_vector(2 downto 0);
    HPROT     : out std_logic_vector(3 downto 0);
    HWDATA    : out std_logic_vector(31 downto 0)
    );
end MuxM2S;

architecture synth of MuxM2S is

-- ---------------------------------------------------------------------
-- Constant declarations
-- ---------------------------------------------------------------------
-- HMASTER output encoding
  constant MST_DEF : std_logic_vector(3 downto 0) := "0000";
  constant MST_ARM : std_logic_vector(3 downto 0) := "0001";
  constant MST_TIC : std_logic_vector(3 downto 0) := "0010";
  constant MST_003 : std_logic_vector(3 downto 0) := "0011";
  constant MST_004 : std_logic_vector(3 downto 0) := "0100";

-- ---------------------------------------------------------------------
-- Signal declaration
-- ---------------------------------------------------------------------
  signal HmasterPrev  : std_logic_vector(3 downto 0);
  -- Previous HMASTER value

-- ---------------------------------------------------------------------
-- Beginning of main code
-- ---------------------------------------------------------------------
  begin

-- ---------------------------------------------------------------------
-- HMASTER register for write data multiplexer
-- ---------------------------------------------------------------------
-- HREADY is used as an enable so that if the previous transfer is
-- waited, then the bus master number for that transfer is still stored.

  p_HmasterPrevSeq : process (HRESETn, HCLK)
  begin
    if HRESETn = '0' then
      HmasterPrev <= (others => '0');
    elsif (HCLK'event and HCLK = '1') then
      if HREADY = '1' then
        HmasterPrev <= HMASTER;
      end if;
    end if;
  end process p_HmasterPrevSeq;

-- ---------------------------------------------------------------------
-- Multiplexers
-- ---------------------------------------------------------------------
-- Multiplexers controlling address, control and write data to the
-- slaves.

-- When no masters are granted the Default Master settings are selected
-- by the muxes. This sets all outputs to zero, performing IDLE
-- transfers.
-- The HTRANS output is the only one required to be driven LOW when no
-- masters are selected - it is possible to drive all other outputs
-- with values from one of the masters that is not selected, removing
-- the need for driving wide buses LOW.

  p_HADDRComb : process (HMASTER, HADDRarm, HADDRtic, HADDR003,
                         HADDR004)
  begin
    case HMASTER is
      when MST_ARM => HADDR <= HADDRarm;
      when MST_TIC => HADDR <= HADDRtic;
      when MST_003 => HADDR <= HADDR003;
      when MST_004 => HADDR <= HADDR004;
      when others  => HADDR <= "0000"&"0000"&"0000"&"0000"&
                               "0000"&"0000"&"0000"&"0000";
    end case;
  end process p_HADDRComb;

  p_HTRANSComb : process (HMASTER, HTRANSarm, HTRANStic, HTRANS003,
                          HTRANS004)
  begin
    case HMASTER is
      when MST_ARM => HTRANS <= HTRANSarm;
      when MST_TIC => HTRANS <= HTRANStic;
      when MST_003 => HTRANS <= HTRANS003;
      when MST_004 => HTRANS <= HTRANS004;
      when others  => HTRANS <= "00";
    end case;
  end process p_HTRANSComb;

  p_HWRITEComb : process (HMASTER, HWRITEarm, HWRITEtic, HWRITE003,
                          HWRITE004)
  begin
    case HMASTER is
      when MST_ARM => HWRITE <= HWRITEarm;
      when MST_TIC => HWRITE <= HWRITEtic;
      when MST_003 => HWRITE <= HWRITE003;
      when MST_004 => HWRITE <= HWRITE004;
      when others  => HWRITE <= '0';
    end case;
  end process p_HWRITEComb;

  p_HSIZEComb : process (HMASTER, HSIZEarm, HSIZEtic, HSIZE003,
                         HSIZE004)
  begin
    case HMASTER is
      when MST_ARM => HSIZE <= HSIZEarm;
      when MST_TIC => HSIZE <= HSIZEtic;
      when MST_003 => HSIZE <= HSIZE003;
      when MST_004 => HSIZE <= HSIZE004;
      when others  => HSIZE <= "000";
    end case;
  end process p_HSIZEComb;

  p_HBURSTComb : process (HMASTER, HBURSTarm, HBURSTtic, HBURST003,
                          HBURST004)
  begin
    case HMASTER is
      when MST_ARM => HBURST <= HBURSTarm;
      when MST_TIC => HBURST <= HBURSTtic;
      when MST_003 => HBURST <= HBURST003;
      when MST_004 => HBURST <= HBURST004;
      when others  => HBURST <= "000";
    end case;
  end process p_HBURSTComb;

  p_HPROTComb : process (HMASTER, HPROTarm, HPROTtic, HPROT003,
                         HPROT004)
  begin
    case HMASTER is
      when MST_ARM => HPROT <= HPROTarm;
      when MST_TIC => HPROT <= HPROTtic;
      when MST_003 => HPROT <= HPROT003;
      when MST_004 => HPROT <= HPROT004;
      when others  => HPROT <= "0000";
    end case;
  end process p_HPROTComb;

  p_HWDATAComb : process (HmasterPrev, HWDATAarm, HWDATAtic, HWDATA003,
                          HWDATA004)
  begin
    case HmasterPrev is
      when MST_ARM => HWDATA <= HWDATAarm;
      when MST_TIC => HWDATA <= HWDATAtic;
      when MST_003 => HWDATA <= HWDATA003;
      when MST_004 => HWDATA <= HWDATA004;
      when others  => HWDATA <= "0000"&"0000"&"0000"&"0000"&
                                "0000"&"0000"&"0000"&"0000";
    end case;
  end process p_HWDATAComb;


end synth;

-- --============================== End ==============================--
