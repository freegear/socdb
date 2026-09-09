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
-- File Name              : DmacTrPackage.vhd.rca
-- File Revision          : 1.5
--
-- Release Information    : PrimeCell(TM)-PL081-REL1v0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           DMAC Trickbox Parameter definitions
--
-- --=========================================================================--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

library std;
use     std.textio.all;

package DmacTrPackage is

constant ZEROFILL          : std_logic_vector(14 downto 0)
                                                := "000000000000000";
-- Constant which is filled with ZERO's

constant NO_OF_REG         : integer := 64;
-- Number of register in memory or peripheral module.

constant MEMORYDEPTH       : integer := 16;
-- To define depth of LLI memory block

constant SLAVEADDRLB       : integer := 2;
-- Lower bit of Slave address used by memory or peripheral module.

constant SLAVEADDRHB       : integer := 9;
-- Higher bit of Slave address used by memory or peripheral module.

constant MASTERADDRLB      : integer := 0;
-- Lower bit of Slave address used by memory or peripheral module.

constant MASTERADDRHB      : integer := 26;
-- Higher bit of Slave address used by memory or peripheral module.

-- -----------------------------------------------------------------------------
-- Definitions for AHB slave reponses
-- -----------------------------------------------------------------------------
constant OKAY_RESP         : std_logic_vector(1 downto 0) := "00";
constant ERROR_RESP        : std_logic_vector(1 downto 0) := "01";
constant RETRY_RESP        : std_logic_vector(1 downto 0) := "10";
constant SPLIT_RESP        : std_logic_vector(1 downto 0) := "11";

-- -----------------------------------------------------------------------------
-- Definitions for different AHB HTRANS transactions
-- -----------------------------------------------------------------------------
constant IDLE              : std_logic_vector(1 downto 0) := "00";
constant BUSY              : std_logic_vector(1 downto 0) := "01";
constant NSEQ              : std_logic_vector(1 downto 0) := "10";
constant SEQ               : std_logic_vector(1 downto 0) := "11";

-- -----------------------------------------------------------------------------
-- Definitions for different size AHB accesses on HSIZE line
-- -----------------------------------------------------------------------------
constant BYTE              : std_logic_vector(2 downto 0) := "000";
constant HWORD             : std_logic_vector(2 downto 0) := "001";
constant WORD              : std_logic_vector(2 downto 0) := "010";

-- -----------------------------------------------------------------------------
-- Definitions for different AHB Burst accesses on HBURST lines
-- -----------------------------------------------------------------------------
constant UINCR             : std_logic_vector(2 downto 0) := "001";
constant WRAP4             : std_logic_vector(2 downto 0) := "010";
constant INCR4             : std_logic_vector(2 downto 0) := "011";
constant WRAP8             : std_logic_vector(2 downto 0) := "100";
constant INCR8             : std_logic_vector(2 downto 0) := "101";
constant WRAP16            : std_logic_vector(2 downto 0) := "110";
constant INCR16            : std_logic_vector(2 downto 0) := "111";
 
-- -----------------------------------------------------------------------------
-- AHB Lite SM's state constants
-- -----------------------------------------------------------------------------
constant ST_AHBM_INIT      : std_logic_vector(3 downto 0) := "0001";
constant ST_AHBM_STARTIDLE : std_logic_vector(3 downto 0) := "0010";
constant ST_AHBM_ADDRXFR   : std_logic_vector(3 downto 0) := "0100";
constant ST_AHBM_ACTIVE    : std_logic_vector(3 downto 0) := "1000";

-- -----------------------------------------------------------------------------
-- AHB Slave SM's state constants
-- -----------------------------------------------------------------------------
constant ST_DMAC_SLAVE_IDLE     : std_logic_vector(3 downto 0) := "0001";
constant ST_DMAC_SLAVE_WRITE    : std_logic_vector(3 downto 0) := "0010";
constant ST_DMAC_SLAVE_WRITE_TR : std_logic_vector(3 downto 0) := "0100";
constant ST_DMAC_SLAVE_ERROR    : std_logic_vector(3 downto 0) := "1000";

-- -----------------------------------------------------------------------------
-- Channel SM's state constants
-- -----------------------------------------------------------------------------
constant ST_IDLE           : std_logic_vector(4 downto 0) := "00001";
-- SM's Idle state indicating no data transfer
 
constant ST_SRC_DMA_XFER   : std_logic_vector(4 downto 0) := "00010";
-- SM"s source transfer state when peripheral is on same bus
 
constant ST_DMA_DST_XFER   : std_logic_vector(4 downto 0) := "00100";
-- SM"s destination transfer state when peripheral is on same bus
 
constant ST_LLI_LOAD       : std_logic_vector(4 downto 0) := "01000";
-- SM's LLILoading state
 
constant ST_PER_DUAL_BUS   : std_logic_vector(4 downto 0) := "10000";
-- This state indicates that the peripheral are on different bus

-- -----------------------------------------------------------------------------
-- Constants used for Error SM in Channel Block
-- -----------------------------------------------------------------------------
constant ST_ERROR_INIT     : std_logic_vector(4 downto 0) := "00001";
-- SM's Idle state indicating no Error

constant ST_ERROR_SINGLE   : std_logic_vector(4 downto 0) := "00010";
-- SM"s Error state indicating Error on Single Bus

constant ST_ERROR_DUAL     : std_logic_vector(4 downto 0) := "00100";
-- SM"s Error state indicating Error on Dual Bus

constant ST_ERROR_SOURCE   : std_logic_vector(4 downto 0) := "01000";
-- SM's Error state when Error happens on source bus but not on Destination bus

constant ST_ERROR_DEST     : std_logic_vector(4 downto 0) := "10000";
-- SM's Error state when Error happens on destination bus but not on source bus

-- -----------------------------------------------------------------------------
-- Constants used for HWDATA Generation SM in Channel Block
-- -----------------------------------------------------------------------------
constant ST_DST_HWDATA_IDLE : std_logic_vector(2 downto 0) := "001";
-- Destination SM's Initial state

constant ST_DST_ADDR_PHASE  : std_logic_vector(2 downto 0) := "010";
-- Destination SM's Address Phase state

constant ST_DST_DATA_PHASE  : std_logic_vector(2 downto 0) := "100";
-- Destination SM's Data state

-- -----------------------------------------------------------------------------
-- Constants used for Prediction Factor Generation SM in Channel Block
-- -----------------------------------------------------------------------------
constant ST_SRC_PREDICT_IDLE : std_logic_vector(2 downto 0) := "001";
-- Source SM's Initial state

constant ST_SRC_ADDR_PHASE   : std_logic_vector(2 downto 0) := "010";
-- Source SM's Address Phase state

constant ST_SRC_DATA_PHASE   : std_logic_vector(2 downto 0) := "100";
-- Source SM's Data state

-- -----------------------------------------------------------------------------
-- Constants used for Generating 'NotValidData' signals for
-- Source/Destination/LLI
-- -----------------------------------------------------------------------------
constant ST_NOTVALIDSRC_IDLE    : std_logic_vector(2 downto 0) := "001";
-- NotValidData for Source, SM's Initial state

constant ST_NOTVALIDSRC_1MREADY : std_logic_vector(2 downto 0) := "010";
-- NotValidData for Source, SM's 1 MREADY State

constant ST_NOTVALIDSRC_2MREADY : std_logic_vector(2 downto 0) := "100";
-- NotValidData for Source, SM's 2 MREADY State

constant ST_NOTVALIDDST_IDLE    : std_logic_vector(2 downto 0) := "001";
-- NotValidData for Destination, SM's Initial state

constant ST_NOTVALIDDST_1MREADY : std_logic_vector(2 downto 0) := "010";
-- NotValidData for Destination, SM's 1 MREADY State

constant ST_NOTVALIDDST_2MREADY : std_logic_vector(2 downto 0) := "100";
-- NotValidData for Destination, SM"s 2 MREADY State

constant ST_NOTVALIDLLI_IDLE    : std_logic_vector(2 downto 0) := "001";
-- NotValidData for LLI, SM's Initial state

constant ST_NOTVALIDLLI_1MREADY : std_logic_vector(2 downto 0) := "010";
-- NotValidData for LLI, SM's 1 MREADY State

constant ST_NOTVALIDLLI_2MREADY : std_logic_vector(2 downto 0) := "100";
-- NotValidData for LLI, SM's 2 MREADY State

-- -----------------------------------------------------------------------------
-- Constants used for Disable SM in Channel Block
-- -----------------------------------------------------------------------------
constant ST_DISABLE_IDLE        : std_logic_vector(3 downto 0) := "0001";
-- Disable SM's Initial state

constant ST_DISABLE_OCCRD       : std_logic_vector(3 downto 0) := "0010";
-- Disable SM's Disabled state

constant ST_DISABLE_SRCACK_RXD  : std_logic_vector(3 downto 0) := "0100";
-- Disable SM's Source Acknowledge received state

constant ST_DISABLE_DSTACK_RXD  : std_logic_vector(3 downto 0) := "1000";
-- Disable SM's Destination Acknowledge received state

-- -----------------------------------------------------------------------------
-- Constants used in Channel Logic module
-- -----------------------------------------------------------------------------
constant ZERO_30           : std_logic_vector(29 downto 0) := (others => '0');
-- 30 bit constant indicating all zero's
 
constant ZERO_14           : std_logic_vector(13 downto 0) := (others => '0');
-- 14 bit constant indicating all zero's
 
constant ALLONE_14         : std_logic_vector(13 downto 0) := (others => '1');
-- 14 bit constant indicating all One's
 
constant ONE_14            : std_logic_vector(13 downto 0) := "00000000000001";
-- 14 bit constant indicating 1
 
constant TWO_14            : std_logic_vector(13 downto 0) := "00000000000010";
-- 14 bit constant indicating 2
 
constant FOUR_14           : std_logic_vector(13 downto 0) := "00000000000100";
-- 14 bit constant indicating 4
 
constant EIGHT_14          : std_logic_vector(13 downto 0) := "00000000001000";
-- 14 bit constant indicating 8
 
constant SIXTEEN_14        : std_logic_vector(13 downto 0) := "00000000010000";
-- 14 bit constant indicating 16
 
constant THIRTYTWO_14      : std_logic_vector(13 downto 0) := "00000000100000";
-- 14 bit constant indicating 32
 
constant SIXTYFOUR_14      : std_logic_vector(13 downto 0) := "00000001000000";
-- 14 bit constant indicating 64
 
constant ONETWOEIGHT_14    : std_logic_vector(13 downto 0) := "00000010000000";
-- 14 bit constant indicating 128
 
constant TWOFIVESIX_14     : std_logic_vector(13 downto 0) := "00000100000000";
-- 14 bit constant indicating 256

-- -----------------------------------------------------------------------------
-- Constants used in Grant generation module
-- -----------------------------------------------------------------------------
constant GRANT_IDLE        : std_logic_vector(2 downto 0) := "001";
constant GRANT_ON          : std_logic_vector(2 downto 0) := "010";
constant GRANT_OFF         : std_logic_vector(2 downto 0) := "100";
 
-- -----------------------------------------------------------------------------
-- Definitions for generation of data from address pattern
-- -----------------------------------------------------------------------------
constant INCREMENT         : std_logic_vector(1 downto 0) := "00";
constant DECREMENT         : std_logic_vector(1 downto 0) := "01";
constant ONESCOMP          : std_logic_vector(1 downto 0) := "10";
constant TWOSCOMP          : std_logic_vector(1 downto 0) := "11";

-- -----------------------------------------------------------------------------
-- Definitions for different data patterns
-- -----------------------------------------------------------------------------
constant RANDOM            : std_logic_vector(1 downto 0) := "00";
constant GRAYCODE          : std_logic_vector(1 downto 0) := "01";
constant ADDRESSBASED      : std_logic_vector(1 downto 0) := "10";
constant DATABASED         : std_logic_vector(1 downto 0) := "11";

-- -----------------------------------------------------------------------------
-- Memory and Peripheral Address range Definitions
-- -----------------------------------------------------------------------------
constant M0LOWADDRRANGE   : std_logic_vector(31 downto 0) :=
                                      to_stdlogicvector(X"08000000");
constant M1LOWADDRRANGE   : std_logic_vector(31 downto 0) :=
                                      to_stdlogicvector(X"10000000");
constant P0LOWADDRRANGE   : std_logic_vector(31 downto 0) :=
                                      to_stdlogicvector(X"18000000");
constant P1LOWADDRRANGE   : std_logic_vector(31 downto 0) :=
                                      to_stdlogicvector(X"20000000");
constant P2LOWADDRRANGE   : std_logic_vector(31 downto 0) :=
                                      to_stdlogicvector(X"28000000");
constant P3LOWADDRRANGE   : std_logic_vector(31 downto 0) :=
                                      to_stdlogicvector(X"30000000");
constant P4LOWADDRRANGE   : std_logic_vector(31 downto 0) :=
                                      to_stdlogicvector(X"38000000");
constant P5LOWADDRRANGE   : std_logic_vector(31 downto 0) :=
                                      to_stdlogicvector(X"40000000");
constant P6LOWADDRRANGE   : std_logic_vector(31 downto 0) :=
                                      to_stdlogicvector(X"48000000");
constant P7LOWADDRRANGE   : std_logic_vector(31 downto 0) :=
                                      to_stdlogicvector(X"50000000");
constant P8LOWADDRRANGE   : std_logic_vector(31 downto 0) :=
                                      to_stdlogicvector(X"58000000");
constant P9LOWADDRRANGE   : std_logic_vector(31 downto 0) :=
                                      to_stdlogicvector(X"60000000");
constant P10LOWADDRRANGE  : std_logic_vector(31 downto 0) :=
                                      to_stdlogicvector(X"68000000");
constant P11LOWADDRRANGE  : std_logic_vector(31 downto 0) :=
                                      to_stdlogicvector(X"70000000");
constant P12LOWADDRRANGE  : std_logic_vector(31 downto 0) :=
                                      to_stdlogicvector(X"78000000");
constant P13LOWADDRRANGE  : std_logic_vector(31 downto 0) :=
                                      to_stdlogicvector(X"80000000");
constant P14LOWADDRRANGE  : std_logic_vector(31 downto 0) :=
                                      to_stdlogicvector(X"88000000");
constant P15LOWADDRRANGE  : std_logic_vector(31 downto 0) :=
                                      to_stdlogicvector(X"90000000");

constant M0HIGHADDRRANGE  : std_logic_vector(31 downto 0) :=
                                      to_stdlogicvector(X"0FFFFFFF");
constant M1HIGHADDRRANGE  : std_logic_vector(31 downto 0) :=
                                      to_stdlogicvector(X"17FFFFFF");
constant P0HIGHADDRRANGE  : std_logic_vector(31 downto 0) :=
                                      to_stdlogicvector(X"1FFFFFFF");
constant P1HIGHADDRRANGE  : std_logic_vector(31 downto 0) :=
                                      to_stdlogicvector(X"27FFFFFF");
constant P2HIGHADDRRANGE  : std_logic_vector(31 downto 0) :=
                                      to_stdlogicvector(X"2FFFFFFF");
constant P3HIGHADDRRANGE  : std_logic_vector(31 downto 0) :=
                                      to_stdlogicvector(X"37FFFFFF");
constant P4HIGHADDRRANGE  : std_logic_vector(31 downto 0) :=
                                      to_stdlogicvector(X"3FFFFFFF");
constant P5HIGHADDRRANGE  : std_logic_vector(31 downto 0) :=
                                      to_stdlogicvector(X"47FFFFFF");
constant P6HIGHADDRRANGE  : std_logic_vector(31 downto 0) :=
                                      to_stdlogicvector(X"4FFFFFFF");
constant P7HIGHADDRRANGE  : std_logic_vector(31 downto 0) :=
                                      to_stdlogicvector(X"57FFFFFF");
constant P8HIGHADDRRANGE  : std_logic_vector(31 downto 0) :=
                                      to_stdlogicvector(X"5FFFFFFF");
constant P9HIGHADDRRANGE  : std_logic_vector(31 downto 0) :=
                                      to_stdlogicvector(X"67FFFFFF");
constant P10HIGHADDRRANGE : std_logic_vector(31 downto 0) :=
                                      to_stdlogicvector(X"6FFFFFFF");
constant P11HIGHADDRRANGE : std_logic_vector(31 downto 0) :=
                                      to_stdlogicvector(X"77FFFFFF");
constant P12HIGHADDRRANGE : std_logic_vector(31 downto 0) :=
                                      to_stdlogicvector(X"7FFFFFFF");
constant P13HIGHADDRRANGE : std_logic_vector(31 downto 0) :=
                                      to_stdlogicvector(X"87FFFFFF");
constant P14HIGHADDRRANGE : std_logic_vector(31 downto 0) :=
                                      to_stdlogicvector(X"8FFFFFFF");
constant P15HIGHADDRRANGE : std_logic_vector(31 downto 0) :=
                                      to_stdlogicvector(X"A7FFFFFF");

-- -----------------------------------------------------------------------------
-- ADDRESS Definitions for peripheral register
-- -----------------------------------------------------------------------------
constant ADDR_DMACTRREQREG : std_logic_vector(9 downto 2) := "00000010";
-- DMACTrReqReg at offset 0x004
constant ADDR_DMACTRCLRREG : std_logic_vector(9 downto 2) := "00000011";
-- DMACTrCLRReg at offset 0x008
constant ADDR_DMACTRTCREG  : std_logic_vector(9 downto 2) := "00000100";
-- DMACTrTCReg at offset 0x00C

-- -----------------------------------------------------------------------------
-- The Address definitions for the registers in the DMA controller
-- -----------------------------------------------------------------------------
constant ADDR_DMACTCCLR       : std_logic_vector(11 downto 2) := "0000000010";
-- DMATCINTSTA at offset 0x008

constant ADDR_DMACERRCLR      : std_logic_vector(11 downto 2) := "0000000100";
-- DMAERRINTSTAT at offset 0x010

constant ADDR_DMACSOFTBREQ    : std_logic_vector(11 downto 2) := "0000001000";
-- DMASOFTBREQ at offset 0x020

constant ADDR_DMACSOFTSREQ    : std_logic_vector(11 downto 2) := "0000001001";
-- DMASOFTSREQ at offset 0x024

constant ADDR_DMACSOFTLBREQ   : std_logic_vector(11 downto 2) := "0000001010";
-- DMASOFTBREQ at offset 0x028

constant ADDR_DMACSOFTLSREQ   : std_logic_vector(11 downto 2) := "0000001011";
-- DMASOFTSREQ at offset 0x02C

constant ADDR_DMACCONFIG      : std_logic_vector(11 downto 2) := "0000001100";
-- DMACONFIG at offset 0x030

constant ADDR_DMACSYNC        : std_logic_vector(11 downto 2) := "0000001101";
-- DMACONFIG at offset 0x034

constant ADDR_DMACC0SRCADDR   : std_logic_vector(11 downto 2) := "0001000000";
-- DMAC0SRCADDR at offset 0x100

constant ADDR_DMACC0DSTADDR  : std_logic_vector(11 downto 2) := "0001000001";
-- DMAC0DESTADDR at offset 0x104

constant ADDR_DMACC0LLIReg    : std_logic_vector(11 downto 2) := "0001000010";
-- DMAC0LLIREG offset 0x108

constant ADDR_DMACC0CONTROL   : std_logic_vector(11 downto 2) := "0001000011";
-- DMAC0CONTROL at offset 0x10C

constant ADDR_DMACC0CONFIG    : std_logic_vector(11 downto 2) := "0001000100";
-- DMAC0CONFIG at offset 0x110

constant ADDR_DMACC1SRCADDR   : std_logic_vector(11 downto 2) := "0001001000";
-- DMAC1SRCADDR at offset 0x120

constant ADDR_DMACC1DSTADDR  : std_logic_vector(11 downto 2) := "0001001001";
-- DMAC1DESTADDR at offset 0x124

constant ADDR_DMACC1LLIReg    : std_logic_vector(11 downto 2) := "0001001010";
-- DMAC1LLIREG offset 0x128

constant ADDR_DMACC1CONTROL   : std_logic_vector(11 downto 2) := "0001001011";
-- DMAC1CONTROLat offset 0x12C

constant ADDR_DMACC1CONFIG    : std_logic_vector(11 downto 2) := "0001001100";
-- DMAC1CONFIG at offset 0x130

constant ADDR_DMACC2SRCADDR   : std_logic_vector(11 downto 2) := "0001010000";
-- DMAC2SRCADDR at offset 0x140

constant ADDR_DMACC2DSTADDR  : std_logic_vector(11 downto 2) := "0001010001";
-- DMAC2DESTADDR at offset 0x144

constant ADDR_DMACC2LLIReg    : std_logic_vector(11 downto 2) := "0001010010";
-- DMAC2LLIREG offset 0x148

constant ADDR_DMACC2CONTROL   : std_logic_vector(11 downto 2) := "0001010011";
-- DMAC2CONTROLat offset 0x14C

constant ADDR_DMACC2CONFIG    : std_logic_vector(11 downto 2) := "0001010100";
-- DMAC2CONFIG at offset 0x150

constant ADDR_DMACC3SRCADDR   : std_logic_vector(11 downto 2) := "0001011000";
-- DMAC3SRCADDR at offset 0x160

constant ADDR_DMACC3DSTADDR  : std_logic_vector(11 downto 2) := "0001011001";
-- DMAC3DESTADDR at offset 0x164

constant ADDR_DMACC3LLIReg    : std_logic_vector(11 downto 2) := "0001011010";
-- DMAC3LLIREG offset 0x168

constant ADDR_DMACC3CONTROL   : std_logic_vector(11 downto 2) := "0001011011";
-- DMAC3CONTROLat offset 0x16C

constant ADDR_DMACC3CONFIG    : std_logic_vector(11 downto 2) := "0001011100";
-- DMAC3CONFIG at offset 0x170

constant ADDR_DMACC4SRCADDR   : std_logic_vector(11 downto 2) := "0001100000";
-- DMAC4SRCADDR at offset 0x180

constant ADDR_DMACC4DSTADDR  : std_logic_vector(11 downto 2) := "0001100001";
-- DMAC4DESTADDR at offset 0x184

constant ADDR_DMACC4LLIReg    : std_logic_vector(11 downto 2) := "0001100010";
-- DMAC4LLIREG offset 0x188

constant ADDR_DMACC4CONTROL   : std_logic_vector(11 downto 2) := "0001100011";
-- DMAC4CONTROLat offset 0x18C

constant ADDR_DMACC4CONFIG    : std_logic_vector(11 downto 2) := "0001100100";
-- DMAC4CONFIG at offset 0x190

constant ADDR_DMACC5SRCADDR   : std_logic_vector(11 downto 2) := "0001101000";
-- DMAC5SRCADDR at offset 0x1A0

constant ADDR_DMACC5DSTADDR  : std_logic_vector(11 downto 2) := "0001101001";
-- DMAC5DESTADDR at offset 0x1A4

constant ADDR_DMACC5LLIReg    : std_logic_vector(11 downto 2) := "0001101010";
-- DMAC5LLIREG offset 0x1A8

constant ADDR_DMACC5CONTROL   : std_logic_vector(11 downto 2) := "0001101011";
-- DMAC5CONTROLat offset 0x1AC

constant ADDR_DMACC5CONFIG    : std_logic_vector(11 downto 2) := "0001101100";
-- DMAC5CONFIG at offset 0x1B0

constant ADDR_DMACC6SRCADDR   : std_logic_vector(11 downto 2) := "0001110000";
-- DMAC6SRCADDR at offset 0x1C0

constant ADDR_DMACC6DSTADDR  : std_logic_vector(11 downto 2) := "0001110001";
-- DMAC6DESTADDR at offset 0x1C4

constant ADDR_DMACC6LLIReg    : std_logic_vector(11 downto 2) := "0001110010";
-- DMAC6LLIREG offset 0x1C8

constant ADDR_DMACC6CONTROL   : std_logic_vector(11 downto 2) := "0001110011";
-- DMAC6CONTROLat offset 0x1CC

constant ADDR_DMACC6CONFIG    : std_logic_vector(11 downto 2) := "0001110100";
-- DMAC6CONFIG at offset 0x1D0

constant ADDR_DMACC7SRCADDR   : std_logic_vector(11 downto 2) := "0001111000";
-- DMAC7SRCADDR at offset 0x1E0

constant ADDR_DMACC7DSTADDR  : std_logic_vector(11 downto 2) := "0001111001";
-- DMAC7DESTADDR at offset 0x1E4

constant ADDR_DMACC7LLIReg    : std_logic_vector(11 downto 2) := "0001111010";
-- DMAC7LLIREG offset 0x1E8

constant ADDR_DMACC7CONTROL   : std_logic_vector(11 downto 2) := "0001111011";
-- DMAC7CONTROLat offset 0x1E8

constant ADDR_DMACC7CONFIG    : std_logic_vector(11 downto 2) := "0001111100";
-- DMAC7CONFIG at offset 0x1EC

constant ADDR_DMACTCR         : std_logic_vector(11 downto 2) := "0101000000";
-- DMACTCR at offset 0x500

-- -----------------------------------------------------------------------------
-- Address declaration for Grant control, Trickbox enable, and Requestors
-- -----------------------------------------------------------------------------
constant ADDR_DMACTRREQCFG    : std_logic_vector(20 downto 2)
                                                  := "0000000000000000000";
-- DMACTRREQCFG at offset 0x00

constant ADDR_DMACTRGRANTCNT0 : std_logic_vector(20 downto 2)
                                                  := "0000000000000000001";
-- DMACTRGNTCNT at offset 0x04

constant ADDR_DMACTRGRANTCNT1 : std_logic_vector(20 downto 2)
                                                  := "0000000000000000010";
-- DMACTRGNTCNT at offset 0x08

constant ADDR_DMACTRENB       : std_logic_vector(20 downto 2)
                                                  := "0000000000000000011";
-- DMACTRENB at offset 0x0C

constant max_string_len       : integer           := 256;
-- Max length of string that can be handled by the To_String function 

constant max_token_len      : integer := 32;
-- Max length of token that can be handled by the To_String function

-- -----------------------------------------------------------------------------
-- Function Definition
-- -----------------------------------------------------------------------------
function AddrBasedGen (Address : in std_logic_vector(7 downto 0);
                       Diff    : in std_logic_vector(3 downto 0);
                       method  : in std_logic_vector(1 downto 0)
                      )
                return std_logic_vector;  

function DataBasedGen (Data    : in std_logic_vector(7 downto 0);
                       Diff    : in std_logic_vector(3 downto 0);
                       method  : in std_logic_vector(1 downto 0)
                      )
                return std_logic_vector;  

function GrayDataGen (PreviousData   : in std_logic_vector(7 downto 0)
                      )
                return std_logic_vector;  

function PRBSDataGen (PRBSData   : in std_logic_vector(7 downto 0)
                      )
                return std_logic_vector;  

function to_integer (
         val : std_logic_vector;
         x   : integer := 0
                    ) return integer;

function To_HexString(
         constant val : in std_logic_vector
                      ) return string;

procedure fprint (
                  variable string_buf    : out string;
                  constant format        : in string;
                  constant arg1          : in string := "";
                  constant arg2          : in string := "";
                  constant arg3          : in string := "";
                  constant arg4          : in string := "";
                  constant arg5          : in string := "";
                  constant arg6          : in string := "";
                  constant arg7          : in string := "";
                  constant arg8          : in string := "";
                  constant arg9          : in string := "";
                  constant arg10         : in string := ""
                 );

end DmacTrPackage; 

package body DmacTrPackage is

-- -----------------------------------------------------------------------------
-- This function returns the length of the string
-- -----------------------------------------------------------------------------
function StrLengthHex(constant x : in integer)
  return integer is
    variable result : integer ;
begin
  if (x mod 4 = 0) then
    result := (x / 4);
  else
    result := (x/4) + 1;
  end if ;
  return (result);
end StrLengthHex;

-- -----------------------------------------------------------------------------
-- Function to generate address based data. 
-- -----------------------------------------------------------------------------
  function AddrBasedGen (Address : in std_logic_vector(7 downto 0);
                         Diff    : in std_logic_vector(3 downto 0);
                         method  : in std_logic_vector(1 downto 0)
                        )
                return std_logic_vector is 
  variable Result : std_logic_vector(7 downto 0);
  begin
    case method is
      when INCREMENT =>
            Result := (Address + Diff);
      when DECREMENT =>
            Result := (Address - Diff);
      when ONESCOMP  =>
            Result := (not Address);
      when TWOSCOMP  =>
            Result := ((not Address)+1);
      when others    =>
            Result := ((others => '0'));
    end case;
    return Result;
  end AddrBasedGen;
  
-- -----------------------------------------------------------------------------
-- Function to generate data using input data passed to function. 
-- -----------------------------------------------------------------------------
  function DataBasedGen (Data    : in std_logic_vector(7 downto 0);
                         Diff    : in std_logic_vector(3 downto 0);
                         method  : in std_logic_vector(1 downto 0)
                        )
                return std_logic_vector is
  variable Result : std_logic_vector(7 downto 0);
  begin
    case method is
      when INCREMENT =>
            Result := unsigned(Data) + unsigned(Diff);
      when DECREMENT =>
            Result := unsigned(Data) - unsigned(Diff);
      when others    =>
            Result := ((others => '0'));
    end case;
    return Result;
  end DataBasedGen;

-- -----------------------------------------------------------------------------
-- function to generate gray code data. 
-- -----------------------------------------------------------------------------
  function GrayDataGen (PreviousData : in std_logic_vector(7 downto 0)
                       )
                return std_logic_vector is 
  variable width             : integer := 8; 
  variable temp              : std_logic_vector(7 downto 0);
  variable Hold              : std_logic_vector(7 downto 0) := (others =>'0');
  begin
    temp              :=  PreviousData;
    Hold(width - 1)   := temp(width -1); 
    P1 :  for i in (width - 2) downto 0 loop
            Hold(i) := temp(i+1) xor temp(i);
          end loop P1;

   return Hold;
   end GrayDataGen;

-- -----------------------------------------------------------------------------
-- function to generate PRBS data. 
-- -----------------------------------------------------------------------------
  function PRBSDataGen (PRBSData   : in std_logic_vector(7 downto 0)
                     )
                return std_logic_vector is 
  variable Result : std_logic_vector(7 downto 0);
  variable RndBit : std_logic;
  begin
    RndBit            := PRBSData(7) xor PRBSData(4) xor PRBSData(1);
    Result            := PRBSData(6 downto 0) & RndBit;
    return Result;
  end PRBSDataGen;          

-- -----------------------------------------------------------------------------
-- function to convert vector to integer.
-- -----------------------------------------------------------------------------
function to_integer (
         val : std_logic_vector;
         x   : integer := 0
                    ) return integer is
  variable returnint : integer;
  -- Return variable from the function
  variable xtmp      : integer;
  -- Temporary variable
 begin
  returnint := 0;
  xtmp := 0;
  if x /= 0 then
    xtmp := 1;
  end if;
  for i in val'range loop
    returnint := returnint + returnint;
      case val(i) is
        when '0'    => null;
        when '1'    => returnint := returnint + 1;
        when others => returnint := returnint + xtmp;
      end case;
  end loop;
  return returnint;
 end to_integer;

-- -----------------------------------------------------------------------------
-- Converts to hexadecimal string
-- -----------------------------------------------------------------------------
function To_HexString(constant val : in std_logic_vector)
  return string is
  constant ResLength : integer := StrLengthHex(val'length);
  variable result    : string (1 to ResLength);
  variable temp      : std_logic_vector(3 downto 0);
begin
  for i in (ResLength-1) downto 0 loop
    result(ResLength-i) := ' ';
    for j in 3 downto 0 loop
      if (i = (ResLength-1)) then
        if (i*4)+j >= val'length then
          temp(j) := '0';
        else
          temp(j) := val((i*4)+j);
        end if;
      else
        temp(j) := val((i*4)+j);
      end if;
    end loop;
    case temp(3 downto 0) is
      when "0000" => result(ResLength-i) := '0';
      when "0001" => result(ResLength-i) := '1';
      when "0010" => result(ResLength-i) := '2';
      when "0011" => result(ResLength-i) := '3';
      when "0100" => result(ResLength-i) := '4';
      when "0101" => result(ResLength-i) := '5';
      when "0110" => result(ResLength-i) := '6';
      when "0111" => result(ResLength-i) := '7';
      when "1000" => result(ResLength-i) := '8';
      when "1001" => result(ResLength-i) := '9';
      when "1010" => result(ResLength-i) := 'A';
      when "1011" => result(ResLength-i) := 'B';
      when "1100" => result(ResLength-i) := 'C';
      when "1101" => result(ResLength-i) := 'D';
      when "1110" => result(ResLength-i) := 'E';
      when "1111" => result(ResLength-i) := 'F';
      when others  => result(ResLength-i) := 'X';
    end case;
  end loop;
  return result;
end To_HexString;

-- -----------------------------------------------------------------------------
-- Function to display text messages
-- -----------------------------------------------------------------------------
procedure fprint    ( variable string_buf    : out string;
                      constant format        : in string;
                      constant arg1          : in string := "";
                      constant arg2          : in string := "";
                      constant arg3          : in string := "";
                      constant arg4          : in string := "";
                      constant arg5          : in string := "";
                      constant arg6          : in string := "";
                      constant arg7          : in string := "";
                      constant arg8          : in string := "";
                      constant arg9          : in string := "" ;
                      constant arg10         : in string := ""
                     ) is
  variable tempbuf    : string(1 to string_buf'length);
  variable rbuf       : line;
  variable arg        : string(1 to max_string_len);
  variable fmt        : string(1 to format'length) := format;
  variable index      : integer := 0;
  variable buf_indx   : integer := 0;
  variable ch         : character;
  variable lookahead  : character;
  variable tokn       : string(1 to max_token_len);
  variable ArgNum     : integer range 1 to 11;

begin
-- check for null format string
  if (format'length = 0) then
     assert false
     report " fprint --- format string is null "
     severity Error;
     return;
  end if;
  index := 0;
  ArgNum := 1;
  while (true) loop
    index := index + 1;
    buf_indx := buf_indx + 1;
    ch := fmt(index);
    if (index < format'length) then
      lookahead := fmt(index+1);
    else
      lookahead := ' ';
    end if;
    if (( ch = '%') and (lookahead = '%'))  then
      write(rbuf,ch);
      index := index + 1;            -- print % character
    elsif ((ch = '\') and (lookahead ='n')) then   -- new line
      ch := LF;
      write(rbuf,ch);
      index := index + 1;
    elsif (ch = '%') and (lookahead /= '%') then
                                                 -- format %s expected
      exit when (ArgNum > 10); -- only first 10 argments will be printed
      tokn := (others => ' ');     -- fill token with blank space
               --   select argument number 1 to 10
      case ArgNum IS
        when 1 =>
          if (arg1 /= "") then
            write(rbuf,arg1);
            index := index + 1;
          else
            exit;
          end if;
        when 2 =>
          if (arg2 /= "") then
            write(rbuf,arg2);
            index := index + 1;
          else
            exit;
          end if;
        when 3 =>
          if (arg3 /= "") then
            write(rbuf,arg3);
            index := index + 1;
          else
            exit;
          end if;
        when 4 =>
          if (arg4 /= "") then
            write(rbuf,arg4);
            index := index + 1;
          else
            exit;
          end if;
        when 5 =>
          if (arg5 /= "") then
            write(rbuf,arg5);
            index := index + 1;
          else
            exit;
          end if;
        when 6 =>
          if (arg6 /= "") then
            write(rbuf,arg6);
            index := index + 1;
          else
            exit;
          end if;
        when 7 =>
          if (arg7 /= "") then
            write(rbuf,arg7);
            index := index + 1;
          else
            exit;
          end if;
        when 8 =>
          if (arg8 /= "") then
            write(rbuf,arg8);
            index := index + 1;
          else
            exit;
          end if;
        when 9 =>
          if (arg9 /= "") then
            write(rbuf,arg9);
            index := index + 1;
          else
            exit;
          end if;
        when 10 =>
          if (arg10 /= "") then
            write(rbuf,arg10);
            index := index + 1;
          else
            exit;
          end if;
        when 11 => -- should not happen
          assert false
            report "fprint -- String buffer, arguments > 10 "
            severity error;
      end case;
-- increment the argument number
      ArgNum := ArgNum + 1;

    elsif (ch /= '%') then        -- printable characters
      write(rbuf,ch);
    end if;
    exit when ((index >= format'length) or
               ( buf_indx >= string_buf'length)) ;
  end loop;                                --  end of while true loop
  if (buf_indx > string_buf'length) then
    string_buf := rbuf.all;
  elsif (buf_indx = string_buf'length) then
    string_buf := rbuf.all;
  else
    buf_indx := rbuf'length;
    string_buf(1 TO buf_indx) := rbuf.all;
  end if;
  deallocate(rbuf);
  return;
end fprint;

end DmacTrPackage; 

-- --====================================== End ==============================--
