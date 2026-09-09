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
-- File Name              : AaciTrPackage.vhd.rca
-- File Revision          : 1.3
--
-- Release Information    : PrimeCell(TM)-PL041-REL1v0
--
-- ---------------------------------------------------------------------
-- Purpose :
--           Trickbox Parameter definitions
--
-- --=================================================================--

library IEEE;
use IEEE.std_logic_1164.all;

package AaciTrPackage is

-- ---------------------------------------------------------------------
-- Constant declarations used in AaciTrRxFIFO and AaciTrTxFIFO
-- ---------------------------------------------------------------------
constant FIFODEPTH        : integer := 128;
-- To define the FIFO depth for receive and transmit FIFO

constant POINTERWIDTH     : integer := 7;
-- To define the FIFO depth this should be defined according to
-- FIFO depth

-- ---------------------------------------------------------------------
-- Constant declarations used in AaciTrProtChk
-- ---------------------------------------------------------------------
constant OFFSET          : time      := 1 ns;
-- Data width tolerence from the full clock period

constant MAXSYNCDELAY    : time      := 2 ns;
-- Maximum SYNC port delay allowed after posedge of BITCLK

constant MAXSDATADELAY   : time      := 2 ns;
-- Maximum AACISDATAOUT port delay allowed after posedge of BITCLK

-- ---------------------------------------------------------------------
-- Constant declarations for the states in the state machine in
-- AaciTrMainCntl
-- ---------------------------------------------------------------------
-- The state declarations for the main transmit/receive state machine.
-- ---------------------------------------------------------------------
constant ST_INITIAL       : std_logic_vector(3 downto 0) := "0000";
constant ST_SYNC          : std_logic_vector(3 downto 0) := "0001";
constant ST_SLOT1         : std_logic_vector(3 downto 0) := "0010";
constant ST_SLOT2         : std_logic_vector(3 downto 0) := "0011";
constant ST_SLOT3         : std_logic_vector(3 downto 0) := "0100";
constant ST_SLOT4         : std_logic_vector(3 downto 0) := "0101";
constant ST_SLOT5         : std_logic_vector(3 downto 0) := "0110";
constant ST_SLOT6         : std_logic_vector(3 downto 0) := "0111";
constant ST_SLOT7         : std_logic_vector(3 downto 0) := "1000";
constant ST_SLOT8         : std_logic_vector(3 downto 0) := "1001";
constant ST_SLOT9         : std_logic_vector(3 downto 0) := "1010";
constant ST_SLOT10        : std_logic_vector(3 downto 0) := "1011";
constant ST_SLOT11        : std_logic_vector(3 downto 0) := "1100";
constant ST_SLOT12        : std_logic_vector(3 downto 0) := "1101";

-- ---------------------------------------------------------------------
-- Constant declarations used in AaciTrClkGen
-- ---------------------------------------------------------------------
constant BtClkSkew        : time      := 3 ns;
-- Skew for the BITCLK generated with respect to PCLK when PCLK is
-- routed to BITCLK

-- ---------------------------------------------------------------------
-- Constant declarations used in AaciTrRegBlk
-- ---------------------------------------------------------------------
constant PCLK_PERIOD      : integer := 10;
-- The PCLK period for the simulation.. it should be same as in
-- timing.v in the testbench 

constant Tdclrrx          : time := PCLK_PERIOD * 0.6 ns;
-- The delay from rising edge of the the PCLK for AACIDMACLRRX signal
-- from the trickbox

constant Tdclrtx          : time := PCLK_PERIOD * 0.6 ns;
-- The delay from rising edge of the the PCLK for AACIDMACLRTX signal
-- from the trickbox

-- ---------------------------------------------------------------------
-- AACI Trickbox registers' addresses constant defs used in AaciTrApbIf
-- ---------------------------------------------------------------------
-- Registers at trickbox base
-- --------------------------
constant PA_AACITRCNTRL   : std_logic_vector(11 downto 2)
                             := "0000000000";
-- AACITrCntrlReg at offset 0x00

constant PA_AACITRINTR1   : std_logic_vector(11 downto 2)
                            := "0000000000";
-- AACITrIntr1Reg at offset 0x00

constant PA_AACITRBTCLK   : std_logic_vector(11 downto 2)
                            := "0000000001";
-- AACITrBtClkPrd at offset 0x04

constant PA_AACITRDMAREG  : std_logic_vector(11 downto 2)
                            := "0000000010";
-- AACITrBtClkPrd at offset 0x08

constant PA_AACITRFST     : std_logic_vector(11 downto 2)
                            := "0000000011";
-- AACITrFIFOStat at offset 0x0C

constant PA_AACITRRF      : std_logic_vector(11 downto 2)
                            := "0000000100";
-- AACITrRxFIFO at offset 0x10

constant PA_AACITRTF      : std_logic_vector(11 downto 2)
                            := "0000000101";
-- AACITrTxFIFO at offset 0x14

constant PA_AACITRINTR2   : std_logic_vector(11 downto 2)
                            := "0000000110";
-- AACITrIntr2Reg at offset 0x18

constant PA_AACITRCLKREG  : std_logic_vector(11 downto 2)
                            := "0000000111";
-- AACITrClkreg at offset 0x1C

-- Common registers at the AACI base
-- ---------------------------------

constant PA_AACITRRESET   : std_logic_vector(11 downto 2)
                            := "0000011111";
-- AACITrRESET at offset 0x7C

constant PA_AACITSYNC     : std_logic_vector(11 downto 2)
                            := "0000100000";
-- AACITrSYNC at offset 0x80

end AaciTrPackage;

-- --============================== End ==============================--
