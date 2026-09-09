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
-- File Name              : AhbSlave.vhd.rca
-- File Revision          : 1.12
--
-- Release Information    : PrimeCell(TM)-PL092-r1p3-01ltd0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           Generic AHB Slave to test the TIC module
--
-- -----------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

-- --=========================================================================--

entity AhbSlave is
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
        HCLK             : in    std_logic; -- AHB Clock Signal
        HRESETn          : in    std_logic; -- AHB Reset Signal
        HADDR            : in    std_logic_vector(31 downto 0);
                                            -- AHB  Address Bus
        HTRANS           : in    std_logic_vector(1 downto 0);
                                            -- AHB Transfer Mode
        HWRITE           : in    std_logic; -- AHB Read/Write Signal
        HSIZE            : in    std_logic_vector(2 downto 0);
                                            -- AHB Data Transfer Size
        HBURST           : in    std_logic_vector(2 downto 0);
                                            -- AHB Burst type
        HWDATA           : in    std_logic_vector(63 downto 0);
                                            -- AHB Write Data Bus
        HRDATAIn         : in    std_logic_vector(63 downto 0);
                                            -- AHB Read Data Bus
        HREADYIn         : in    std_logic; -- AHB HREADY signal
        HSPLITIn         : in    std_logic_vector(15 downto 0);
                                            -- AHB Split Reply
        HSEL             : in    std_logic; -- Slave select signal
        HMASTER          : in    std_logic_vector(3 downto 0);
                                            -- MASTER driving the Bus
        HMASTLOCK        : in    std_logic; -- Slave locked by Master
        HRESPIn          : in    std_logic_vector(1 downto 0);
                                            -- Combined Response
        HRDATAdly        : out   std_logic_vector(63 downto 0);
                                            -- AHB Read Data Bus
        HREADYdly        : out   std_logic; -- AHB HREADY signal
        HRESPdly         : out   std_logic_vector(1 downto 0);
                                            -- AHB response signal
        HSPLITdly        : out   std_logic_vector(15 downto 0)
                                            -- AHB Splitx signal
       );
end AhbSlave;

-- -----------------------------------------------------------------------------
--
--                                 AHBSlave
--                                 ========
--
-- -----------------------------------------------------------------------------
--
-- Overview
-- ========
--   This module is the top level of AHB generic  Split-capable slave  device
-- that aids validation of the TIC module. Instantiates all the sub-modules.
--
-- -----------------------------------------------------------------------------

-- --============================= ARCHITECTURE ==============================--

architecture structural of AhbSlave is

-- -----------------------------------------------------------------------------
-- Signal declarations
-- -----------------------------------------------------------------------------
signal HSIZEdlyInt      : std_logic_vector(2 downto 0);
-- Internal Data Transfer Size

signal WSCReg1          : std_logic_vector(31 downto 0);
-- Wait State Register 1

signal WSCReg2          : std_logic_vector(31 downto 0);
-- Wait State Register 2

signal CR               : std_logic_vector(31 downto 0);
-- Control Register

signal HADDRdlyInt      : std_logic_vector(31 downto 0);
-- Internal Clocked Address Bus

signal HWRITEdlyInt     : std_logic;
-- Internal Clocked HWRITE signal

signal HSELdlyInt       : std_logic;
-- Internal Slave Select signal

signal WrEn             : std_logic;
-- Write Enable signal

signal RdEn             : std_logic;
-- Read Enable signal

signal WSCReg1Sel       : std_logic;
-- Wait State Register 1 Select signal

signal WSCReg2Sel       : std_logic;
-- Wait State Register 2 Select signal

signal CRSel            : std_logic;
-- Control Register Select signal

signal ARRAY1Sel        : std_logic;
-- ARRAY 1 Select signal

signal ARRAY2Sel        : std_logic;
-- ARRAY 2 Select signal

signal TMRegSel         : std_logic;
-- TimeOut Register Select signal

signal XRDlyRegSel      : std_logic;
-- Transfer Delay Register Select signal

signal HADDRdly         : std_logic_vector(31 downto 0);
-- Delayed Address Bus

signal HTRANSdly        : std_logic_vector(1 downto 0);
-- Delayed HTRANS Bus

signal TMReg            : std_logic_vector(31 downto 0);
-- TimeOut Register

signal XRDlyReg         : std_logic_vector(31 downto 0);
-- Transfer Delay Reg.

signal HWRITEdly        : std_logic;
-- Delayed HWRITE signal

signal HSELdly          : std_logic;
-- Delayed HSEL signal

signal HMASTLOCKdly     : std_logic;
-- Delayed HMASTLOCK signal

signal HSIZEdly         : std_logic_vector(2 downto 0);
-- Delayed HSIZE signal

signal HBURSTdly        : std_logic_vector(2 downto 0);
-- Delayed Burst mode signal

signal HWDATAdly        : std_logic_vector(63 downto 0);
-- Delayed  Write Data Bus

signal HRDATAOut        : std_logic_vector(63 downto 0);
-- Data Output bus

signal HREADYOut        : std_logic;
-- HREADY signal

signal HSPLITOut        : std_logic_vector(15 downto 0);
-- SPLIT Reply to the Master

signal HMASTERdly       : std_logic_vector(3 downto 0);
-- Master owning the AHB

signal HRESPOut         : std_logic_vector(1 downto 0);
-- HRESP signal

signal BYTE0En          : std_logic;
-- Enable signal for 0th Byte in a Double Word

signal BYTE1En          : std_logic;
-- Enable signal for 1st Byte in a Double Word

signal BYTE2En          : std_logic;
-- Enable signal for 2nd Byte in a Double Word

signal BYTE3En          : std_logic;
-- Enable signal for 3rd Byte in a Double Word

signal BYTE4En          : std_logic;
-- Enable signal for 4th Byte in a Double Word

signal BYTE5En          : std_logic;
-- Enable signal for 5th Byte in a Double Word

signal BYTE6En          : std_logic;
-- Enable signal for 6th Byte in a Double Word

signal BYTE7En          : std_logic;
-- Enable signal for 7th Byte in a Double Word

-- -----------------------------------------------------------------------------
-- Component declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Ahbif Module
-- -----------------------------------------------------------------------------
component Ahbif
  port (
        HCLK             : in    std_logic;
        HRESETn          : in    std_logic;
        HADDRdly         : in    std_logic_vector(31 downto 0);
        HTRANSdly        : in    std_logic_vector(1 downto 0);
        HWRITEdly        : in    std_logic;
        HMASTLOCKdly     : in    std_logic;
        HSELdly          : in    std_logic;
        HSIZEdly         : in    std_logic_vector(2 downto 0);
        HBURSTdly        : in    std_logic_vector(2 downto 0);
        HWDATAdly        : in    std_logic_vector(63 downto 0);
        WSCReg1          : in    std_logic_vector(31 downto 0);
        WSCReg2          : in    std_logic_vector(31 downto 0);
        CR               : in    std_logic_vector(31 downto 0);
        TMReg            : in    std_logic_vector(31 downto 0);
        XRDlyReg         : in    std_logic_vector(31 downto 0);
        HMASTERdly       : in    std_logic_vector(3 downto 0);
        HSPLITIn         : in    std_logic_vector(15 downto 0);
        HREADYIn         : in    std_logic;
        HRESPIn          : in    std_logic_vector(1 downto 0);
        HSELdlyInt       : out   std_logic;
        HWRITEdlyInt     : out   std_logic;
        HADDRdlyInt      : out   std_logic_vector(31 downto 0);
        HSIZEdlyInt      : out   std_logic_vector(2 downto 0);
        ARRAY1Sel        : out   std_logic;
        ARRAY2Sel        : out   std_logic;
        RdEn             : out   std_logic;
        WrEn             : out   std_logic;
        WSCReg1Sel       : out   std_logic;
        WSCReg2Sel       : out   std_logic;
        CRSel            : out   std_logic;
        XRDlyRegSel      : out   std_logic;
        TMRegSel         : out   std_logic;
        BYTE0En          : out   std_logic;
        BYTE1En          : out   std_logic;
        BYTE2En          : out   std_logic;
        BYTE3En          : out   std_logic;
        BYTE4En          : out   std_logic;
        BYTE5En          : out   std_logic;
        BYTE6En          : out   std_logic;
        BYTE7En          : out   std_logic;
        HREADYOut        : out   std_logic;
        HSPLITOut        : out   std_logic_vector(15 downto 0);
        HRESPOut         : out   std_logic_vector(1 downto 0)
       );
end component;

-- -----------------------------------------------------------------------------
-- AhbRegBlock Module
-- -----------------------------------------------------------------------------
component AhbRegBlock
  port (
        HCLK             : in    std_logic;
        HRESETn          : in    std_logic;
        HADDRdlyInt      : in    std_logic_vector(31 downto 0);
        HWRITEdlyInt     : in    std_logic;
        HSELdlyInt       : in    std_logic;
        HREADYIn         : in    std_logic;
        HSIZEdlyInt      : in    std_logic_vector(2 downto 0);
        HWDATAdly        : in    std_logic_vector(63 downto 0);
        ARRAY1Sel        : in    std_logic;
        ARRAY2Sel        : in    std_logic;
        RdEn             : in    std_logic;
        WrEn             : in    std_logic;
        WSCReg1Sel       : in    std_logic;
        WSCReg2Sel       : in    std_logic;
        CRSel            : in    std_logic;
        XRDlyRegSel      : in    std_logic;
        TMRegSel         : in    std_logic;
        BYTE0En          : in    std_logic;
        BYTE1En          : in    std_logic;
        BYTE2En          : in    std_logic;
        BYTE3En          : in    std_logic;
        BYTE4En          : in    std_logic;
        BYTE5En          : in    std_logic;
        BYTE6En          : in    std_logic;
        BYTE7En          : in    std_logic;
        WSCReg1          : out   std_logic_vector(31 downto 0);
        WSCReg2          : out   std_logic_vector(31 downto 0);
        CR               : out   std_logic_vector(31 downto 0);
        TMReg            : out   std_logic_vector(31 downto 0);
        XRDlyReg         : out   std_logic_vector(31 downto 0);
        HRDATAOut        : out   std_logic_vector(63 downto 0)
       );
end component;

-- -----------------------------------------------------------------------------
-- Ahbparam Module
-- -----------------------------------------------------------------------------
component Ahbparam
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
        HCLK             : in    std_logic;
        HADDR            : in    std_logic_vector(31 downto 0);
        HTRANS           : in    std_logic_vector(1 downto 0);
        HSIZE            : in    std_logic_vector(2 downto 0);
        HBURST           : in    std_logic_vector(2 downto 0);
        DelayEn          : in    std_logic;
        HWRITE           : in    std_logic;
        HMASTLOCK        : in    std_logic;
        HSEL             : in    std_logic;
        HREADYOut        : in    std_logic;
        HMASTER          : in    std_logic_vector(3 downto 0);
        HWDATA           : in    std_logic_vector(63 downto 0);
        HRDATAOut        : in    std_logic_vector(63 downto 0);
        HSPLITOut        : in    std_logic_vector(15 downto 0);
        HRESPOut         : in    std_logic_vector(1 downto 0);
        HWRITEdly        : out   std_logic;
        HREADYdly        : out   std_logic;
        HMASTLOCKdly     : out   std_logic;
        HSELdly          : out   std_logic;
        HWDATAdly        : out   std_logic_vector(63 downto 0);
        HRDATAdly        : out   std_logic_vector(63 downto 0);
        HSPLITdly        : out   std_logic_vector(15 downto 0);
        HMASTERdly       : out   std_logic_vector(3 downto 0);
        HADDRdly         : out   std_logic_vector(31 downto 0);
        HTRANSdly        : out   std_logic_vector(1 downto 0);
        HSIZEdly         : out   std_logic_vector(2 downto 0);
        HBURSTdly        : out   std_logic_vector(2 downto 0);
        HRESPdly         : out   std_logic_vector(1 downto 0)
       );
end component;

-- -----------------------------------------------------------------------------
--
-- Main body of code
-- =================
--
-- -----------------------------------------------------------------------------

begin

-- -----------------------------------------------------------------------------
-- Signal Mapping
-- -----------------------------------------------------------------------------
-- -----------------------------------------------------------------------------
-- Ahbif Module Instantiation
-- -----------------------------------------------------------------------------
uAhbif : Ahbif
  port map (
            HCLK             => HCLK,
            HRESETn          => HRESETn,
            HADDRdly         => HADDRdly,
            HADDRdlyInt      => HADDRdlyInt,
            HSELdlyInt       => HSELdlyInt,
            HSIZEdlyInt      => HSIZEdlyInt,
            HWRITEdlyInt     => HWRITEdlyInt,
            HTRANSdly        => HTRANSdly,
            HWRITEdly        => HWRITEdly,
            HSIZEdly         => HSIZEdly,
            HBURSTdly        => HBURSTdly,
            HWDATAdly        => HWDATAdly,
            HSELdly          => HSELdly,
            WSCReg1          => WSCReg1,
            WSCReg2          => WSCReg2,
            CR               => CR,
            TMReg            => TMReg,
            XRDlyReg         => XRDlyReg,
            HMASTERdly       => HMASTERdly,
            HMASTLOCKdly     => HMASTLOCKdly,
            HSPLITIn         => HSPLITIn,
            HREADYIn         => HREADYIn,
            HRESPIn          => HRESPIn,
            ARRAY1Sel        => ARRAY1Sel,
            ARRAY2Sel        => ARRAY2Sel,
            WrEn             => WrEn,
            RdEn             => RdEn,
            WSCReg1Sel       => WSCReg1Sel,
            WSCReg2Sel       => WSCReg2Sel,
            CRSel            => CRSel,
            TMRegSel         => TMRegSel,
            XRDlyRegSel      => XRDlyRegSel,
            BYTE0En          => BYTE0En,
            BYTE1En          => BYTE1En,
            BYTE2En          => BYTE2En,
            BYTE3En          => BYTE3En,
            BYTE4En          => BYTE4En,
            BYTE5En          => BYTE5En,
            BYTE6En          => BYTE6En,
            BYTE7En          => BYTE7En,
            HREADYOut        => HREADYOut,
            HSPLITOut        => HSPLITOut,
            HRESPOut         => HRESPOut
           );

-- -----------------------------------------------------------------------------
-- AhbRegBlock Module Instantiation
-- -----------------------------------------------------------------------------
uAhbRegBlock : AhbRegBlock
  port map (
            HCLK             => HCLK,
            HRESETn          => HRESETn,
            HADDRdlyInt      => HADDRdlyInt,
            HWRITEdlyInt     => HWRITEdlyInt,
            HSIZEdlyInt      => HSIZEdlyInt,
            HSELdlyInt       => HSELdlyInt,
            HWDATAdly        => HWDATAdly,
            ARRAY1Sel        => ARRAY1Sel,
            ARRAY2Sel        => ARRAY2Sel,
            WrEn             => WrEn,
            RdEn             => RdEn,
            WSCReg1Sel       => WSCReg1Sel,
            WSCReg2Sel       => WSCReg2Sel,
            CRSel            => CRSel,
            TMRegSel         => TMRegSel,
            XRDlyRegSel      => XRDlyRegSel,
            BYTE0En          => BYTE0En,
            BYTE1En          => BYTE1En,
            BYTE2En          => BYTE2En,
            BYTE3En          => BYTE3En,
            BYTE4En          => BYTE4En,
            BYTE5En          => BYTE5En,
            BYTE6En          => BYTE6En,
            BYTE7En          => BYTE7En,
            WSCReg1          => WSCReg1,
            WSCReg2          => WSCReg2,
            CR               => CR,
            TMReg            => TMReg,
            XRDlyReg         => XRDlyReg,
            HREADYIn         => HREADYIn,
            HRDATAOut        => HRDATAOut
           );

-- -----------------------------------------------------------------------------
-- Ahbparam Module Instantiation
-- -----------------------------------------------------------------------------
uAhbparam : Ahbparam
  generic map (
               tclkl   => tclkl,
               tclkh   => tclkh,
               tovrdy  => tovrdy,
               tohrdy  => tohrdy,
               tovrsp  => tovrsp,
               tohrsp  => tohrsp,
               tovsplt => tovsplt,
               tohsplt => tohsplt,
               tovdr   => tovdr,
               tohdr   => tohdr
              )
  port map (
            HCLK             => HCLK,
            HADDR            => HADDR,
            HTRANS           => HTRANS,
            HSIZE            => HSIZE,
            HBURST           => HBURST,
            DelayEn          => CR(5),
            HWRITE           => HWRITE,
            HMASTER          => HMASTER,
            HMASTERdly       => HMASTERdly,
            HMASTLOCK        => HMASTLOCK,
            HMASTLOCKdly     => HMASTLOCKdly,
            HSEL             => HSEL,
            HSELdly          => HSELdly,
            HADDRdly         => HADDRdly,
            HTRANSdly        => HTRANSdly,
            HSIZEdly         => HSIZEdly,
            HBURSTdly        => HBURSTdly,
            HWRITEdly        => HWRITEdly,
            HREADYOut        => HREADYOut,
            HREADYdly        => HREADYDly,
            HWDATA           => HWDATA,
            HRDATAOut        => HRDATAOut,
            HWDATAdly        => HWDATADly,
            HRDATAdly        => HRDATAdly,
            HSPLITOut        => HSPLITOut,
            HSPLITdly        => HSPLITdly,
            HRESPOut         => HRESPOut,
            HRESPdly         => HRESPdly
           );

end structural;

-- --================================ END ====================================--
