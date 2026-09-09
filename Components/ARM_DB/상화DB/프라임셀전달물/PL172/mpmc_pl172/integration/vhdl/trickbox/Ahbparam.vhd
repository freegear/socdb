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
-- File Name              : Ahbparam.vhd.rca
-- File Revision          : 1.6
--
-- Release Information    : PrimeCell(TM)-PL172-r2p3-00rel0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           This module introduces proper delays to all signals of the
--           AhbSlave
--
-- -----------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

-- --=========================================================================--

entity Ahbparam is
  generic (
           tclkl       : time;
           tclkh       : time;
           tovrdy      : time;
           tohrdy      : time;
           tovrsp      : time;
           tohrsp      : time;
           tovsplt     : time;
           tohsplt     : time;
           tovdr       : time;
           tohdr       : time
          );
  port (
        HCLK             : in    std_logic; -- AHB Clock
        HADDR            : in    std_logic_vector(31 downto 0);
                                            -- AHB Address Bus
        HTRANS           : in    std_logic_vector(1 downto 0);
                                            -- AHB Transfer type
        HSIZE            : in    std_logic_vector(2 downto 0);
                                            -- AHB Transfer size
        HBURST           : in    std_logic_vector(2 downto 0);
                                            -- AHB Burst Control
        DelayEn          : in    std_logic; -- Delay Enable bit
        HWRITE           : in    std_logic; -- AHB Read/Write Signal
        HSEL             : in    std_logic; -- Slave Selected
        HMASTER          : in    std_logic_vector(3 downto 0);
                                            -- Master owning AHB
        HMASTLOCK        : in    std_logic; -- Master locks Slave for current
                                            -- transaction
        HREADYOut        : in    std_logic; -- AHB Ready signal generated
                                            -- by slave
        HWDATA           : in    std_logic_vector(63 downto 0);
                                            -- AHB Write Data Bus
        HSPLITOut        : in    std_logic_vector(15 downto 0);
                                            -- SPLIT Reply to MASTER
        HRDATAOut        : in    std_logic_vector(63 downto 0);
                                            -- Internal Read Data Bus
        HRESPOut         : in    std_logic_vector(1 downto 0);
                                            -- Internal HRESP signal
        HSELdly          : out   std_logic; -- Delayed HSEL signal
        HMASTLOCKdly     : out   std_logic; -- Delayed HMASTLOCK signal
        HADDRdly         : out   std_logic_vector(31 downto 0);
                                            -- Delayed AHB Address bus
        HTRANSdly        : out   std_logic_vector(1 downto 0);
                                            -- Delayed AHB Transfer
        HSIZEdly         : out   std_logic_vector(2 downto 0);
                                            -- Delayed AHB size signal
        HBURSTdly        : out   std_logic_vector(2 downto 0);
                                            -- Delayed AHB Burst
        HWRITEdly        : out   std_logic; -- Delayed AHB Read/Write signal
        HREADYdly        : out   std_logic; -- AHB Ready signal ouput from slave
        HWDATAdly        : out   std_logic_vector(63 downto 0);
                                            -- Delayed AHB Write Data
        HRDATAdly        : out   std_logic_vector(63 downto 0);
                                            -- AHB Read Data Bus
        HSPLITdly        : out   std_logic_vector(15 downto 0);
                                            -- Delayed HSPLIT lines
        HMASTERdly       : out   std_logic_vector(3 downto 0);
                                            -- Delayed HMASTER
        HRESPdly         : out   std_logic_vector(1 downto 0)
                                            -- AHB response signal
       );
end Ahbparam;

-- -----------------------------------------------------------------------------
--
--                                 Ahbparam
--                                 ========
--
-- -----------------------------------------------------------------------------
--
-- Overview
-- ========
--   This module introduces delays to AHB signals.
--
-- -----------------------------------------------------------------------------

-- --============================== ARCHITECTURE =============================--

architecture behavioural of Ahbparam is

-- -----------------------------------------------------------------------------
-- Constant declarations
-- -----------------------------------------------------------------------------
constant HADDR_DLY_VALUE     : time := 0 ns;
-- Delay time for HADDR signal

constant HSEL_DLY_VALUE      : time := 0 ns;
-- Delay time for HSEL signal

constant HMASTLOCK_DLY_VALUE : time := 0 ns;
-- Delay time for HMASTLOCK signal

constant HTRANS_DLY_VALUE    : time := 0 ns;
-- Delay time for HTRANS signal

constant HSIZE_DLY_VALUE     : time := 0 ns;
-- Delay time for HSIZE signal

constant HBURST_DLY_VALUE    : time := 0 ns;
-- Delay time for HBURST signal

constant HWRITE_DLY_VALUE    : time := 0 ns;
-- Delay time for HWRITE signal

constant HREADY_DLY_VALUE    : time := 2 ns;
-- Delay time for HREADY signal

constant HWDATA_DLY_VALUE    : time := 0 ns;
-- Delay time for HWDATA signal

constant HRDATA_DLY_VALUE    : time := 2 ns;
-- Delay time for HRDATA signal

constant HRESP_DLY_VALUE     : time := 2 ns;
-- Delay time for HRESP signal

constant HSPLIT_DLY_VALUE    : time := 2 ns;
-- Delay time for HSPLIT signal

constant HMASTER_DLY_VALUE   : time := 0 ns;
-- Delay time for HMASTER signal

-- -----------------------------------------------------------------------------
-- Signal declarations
-- -----------------------------------------------------------------------------
signal HREADYX          : std_logic;
-- For timing protocol checks of HREADY signal, this signal is paased out
-- after making it unknown for a certain duration

signal HRESPX           : std_logic_vector(1 downto 0);
-- For timing protocol checks of HRESP signal, this signal is paased out
-- after making it unknown for a certain duration

signal HSPLITX          : std_logic_vector(15 downto 0);
-- For timing protocol checks of HSPLITx signal, this signal is paased out
-- after making it unknown for a certain duration

-- -----------------------------------------------------------------------------
--
-- Main body of code
-- =================
--
-- -----------------------------------------------------------------------------

begin

-- -----------------------------------------------------------------------------
-- Introducing delays
-- -----------------------------------------------------------------------------
HADDRdly         <= HADDR after HADDR_DLY_VALUE;

HSELdly          <= HSEL  after HSEL_DLY_VALUE;

HTRANSdly        <= HTRANS after HTRANS_DLY_VALUE;

HSIZEdly         <= HSIZE after HSIZE_DLY_VALUE;

HBURSTdly        <= HBURST after HBURST_DLY_VALUE;

HWRITEdly        <= HWRITE after HWRITE_DLY_VALUE;

HWDATAdly        <= HWDATA after HWDATA_DLY_VALUE;

HMASTERdly       <= HMASTER after HMASTER_DLY_VALUE;

HMASTLOCKdly     <= HMASTLOCK after HMASTLOCK_DLY_VALUE;

HRDATAdly        <= HRDATAOut after HRDATA_DLY_VALUE;

HREADYdly        <= HREADYX when DelayEn = '1'
                 else
                    HREADYOut after HREADY_DLY_VALUE;

HRESPdly         <= HRESPX when DelayEn = '1'
                 else
                    HRESPOut after HRESP_DLY_VALUE;

HSPLITdly        <= HSPLITX when DelayEn = '1'
                 else
                    HSPLITOut after HSPLIT_DLY_VALUE;

-- -----------------------------------------------------------------------------
-- For timing violation checking of Slave's  Output Signals, this signal is
-- made to go to an unknown state for a predetermined duration and then passed
-- out as the actual output signal.
-- -----------------------------------------------------------------------------
p_SlaveSeq : process (HCLK)
begin
  if (HCLK'event and HCLK = '1' and DelayEn = '1') then
    HREADYX <= 'X' after 10 ps,
               HREADYOut after HREADY_DLY_VALUE  * 48;

    HRESPX  <= "XX" after 10 ps,
               HRESPOut  after HRESP_DLY_VALUE  * 48;

    HSPLITX <= "XXXXXXXXXXXXXXXX" after 10 ps,
               HSPLITOut after HSPLIT_DLY_VALUE  * 48;
  elsif (HCLK'event and HCLK = '1') then
    HREADYX <= '0';

    HRESPX  <= "00";

    HSPLITX <= "0000000000000000";
  end if;
end process p_SlaveSeq;

end behavioural;

-- --================================= END ===================================--
