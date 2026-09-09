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
-- File Name              : AaciTrick.vhd.rca
-- File Revision          : 1.3
--
-- Release Information    : PrimeCell(TM)-PL041-REL1v0
--
-- ---------------------------------------------------------------------
-- Purpose :
--           This block is the top level of the AACI TRICKBOX
--
-- --=================================================================--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

use work.AaciTrPackage.all;

-- ---------------------------------------------------------------------

entity AaciTrick is
  port (
-- Inputs
        -- APB bus signals
        PCLK             : in    std_logic; -- APB Bus Clock
        PRESETn          : in    std_logic; -- AMBA Bus Reset
        PSEL             : in    std_logic; -- APB Peripheral select for
                                            -- the trickbox
        PSELCOM          : in    std_logic; -- APB Peripheral select for
                                            -- the AACI
        PENABLE          : in    std_logic; -- APB Peripheral enable
        PWRITE           : in    std_logic; -- APB Peripheral write
        PADDR            : in    std_logic_vector(11 downto 2);
                                            -- APB Addr Slice
        PWDATA           : in    std_logic_vector(31 downto 0);
                                            -- APB Write databus
        -- DMA request signals
        AACIDMASREQRX    : in    std_logic; -- AACI RX single xfer req
        AACIDMALSREQRX   : in    std_logic; -- AACI RX single last xfer
        AACIDMABREQRX    : in    std_logic; -- AACI RX burst xfer req
        AACIDMALBREQRX   : in    std_logic; -- AACI RX burst last xfer
        AACIDMABREQTX    : in    std_logic; -- AACI TX single xfer req

        -- Interrupt signals
        AACIINTR         : in    std_logic; -- AACI combined interrupt
        AACITXINTR1      : in    std_logic; -- Ch1 fifo Tx intr
        AACITXINTR2      : in    std_logic; -- Ch2 fifo Tx intr
        AACITXINTR3      : in    std_logic; -- Ch3 fifo Tx intr
        AACITXINTR4      : in    std_logic; -- Ch4 fifo Tx intr
        AACIRXINTR1      : in    std_logic; -- Ch1 fifo Rx intr
        AACIRXINTR2      : in    std_logic; -- Ch2 fifo Rx intr
        AACIRXINTR3      : in    std_logic; -- Ch3 fifo Rx intr
        AACIRXINTR4      : in    std_logic; -- Ch4 fifo Rx intr
        AACIORINTR1      : in    std_logic; -- Ch1 fifo overrun Intr
        AACIORINTR2      : in    std_logic; -- Ch2 fifo overrun Intr
        AACIORINTR3      : in    std_logic; -- Ch3 fifo overrun Intr
        AACIORINTR4      : in    std_logic; -- Ch4 fifo overrun Intr
        AACITXCINTR1     : in    std_logic; -- Ch1 Tx complete Intr
        AACITXCINTR2     : in    std_logic; -- Ch2 Tx complete Intr
        AACITXCINTR3     : in    std_logic; -- Ch3 Tx complete Intr
        AACITXCINTR4     : in    std_logic; -- Ch4 Tx complete Intr
        AACIURINTR1      : in    std_logic; -- Ch1 Tx under run Intr
        AACIURINTR2      : in    std_logic; -- Ch2 Tx under run Intr
        AACIURINTR3      : in    std_logic; -- Ch3 Tx under run Intr
        AACIURINTR4      : in    std_logic; -- Ch4 Tx under run Intr
        AACIRXTOINTR1    : in    std_logic; -- Ch1 Rx timeout Intr
        AACIRXTOINTR2    : in    std_logic; -- Ch2 Rx timeout Intr
        AACIRXTOINTR3    : in    std_logic; -- Ch3 Rx timeout Intr
        AACIRXTOINTR4    : in    std_logic; -- Ch4 Rx timeout Intr
        AACIWINTR        : in    std_logic; -- Wakeup Interrupt
        AACIGPIOINTR     : in    std_logic; -- GPIO Interrupt
        AACIS1RXINTR     : in    std_logic; -- Slot1 receive interrupt
        AACIS2RXINTR     : in    std_logic; -- Slot2 receive interrupt
        AACIS12RXINTR    : in    std_logic; -- Slot12 receive interrupt
        AACIS1TXINTR     : in    std_logic; -- Slot1 transmit interrupt
        AACIS2TXINTR     : in    std_logic; -- Slot2 transmit interrupt
        AACIS12TXINTR    : in    std_logic; -- Slot12 transmit interrupt
        AACIRXTOFEINTR1  : in    std_logic; -- Rx Timeout FIFO 1 Empty
        AACIRXTOFEINTR2  : in    std_logic; -- Rx Timeout FIFO 2 Empty
        AACIRXTOFEINTR3  : in    std_logic; -- Rx Timeout FIFO 3 Empty
        AACIRXTOFEINTR4  : in    std_logic; -- Rx Timeout FIFO 4 Empty

        -- AC LINK related input signals
        AACIRESET        : in    std_logic; -- AACIRESET port from AACI
        AACISYNC         : in    std_logic; -- AACISYNC port from AACI
        AACISDATAIN      : in    std_logic; -- AACISDATAIN port from
                                            -- AACI Serial data input
-- Outputs
        AACIBITCLK       : out   std_logic; -- BITCLK output to AACI
        -- Reset outputs
        nAACIBITCLKRST   : out   std_logic; -- Reset to AACI
                                            -- AACIBITCLK domain
        nFAACIBITCLKRST  : out   std_logic; -- Reset to AACI
                                            -- nAACIBITCLK domain
        AACISDATAOUT     : out   std_logic; -- AACISDATAIN port of AACI
                                            -- Serial data output
        -- DMA request clear signals
        AACIDMACLRRX     : out   std_logic; -- DMA receive request clr
        AACIDMACLRTX     : out   std_logic; -- DMA transmit request clr
        -- APB o/p signal
        PRDATA           : out   std_logic_vector(31 downto 0)
                                            -- Read databus
       );
end AaciTrick;

-- ---------------------------------------------------------------------
--
--                           AaciTrick
--                           =========
--
-- ---------------------------------------------------------------------
--
-- Overview
-- ========
--
-- This module instantiates the following sub-modules:
--
-- 1. AaciTrApbIf        - APB Interface
-- 2. AaciTrRegBlk       - Register Block
-- 3. AaciTrRxFIFO       - Receive FIFO
-- 4. AaciTrTxFIFO       - Transmit FIFO
-- 5. AaciTrMainCntl     - Transmitter/Receiver main state machine
-- 6. AaciTrSnc2PClk     - Synchronisers for signals crossing into PCLK
--                         domain
-- 7. AaciTrSnc2BtClk    - Synchronisers for signals crossing into 
--                         AACIBITCLK domain
-- 8. AaciTrClkGen       - Clock generation Block
-- 9. AaciTrProtChk      - Protocol Checker Block 
--
-- ---------------------------------------------------------------------

-- --========================= ARCHITECTURE ==========================--

architecture structural of AaciTrick is

-- ---------------------------------------------------------------------
-- Component declarations
-- ---------------------------------------------------------------------
component AaciTrApbIf 
  port (
        PCLK             : in    std_logic;
        PRESETn          : in    std_logic;
        PSEL             : in    std_logic;
        PSELCOM          : in    std_logic;
        PWRITE           : in    std_logic;
        PENABLE          : in    std_logic;
        PADDR            : in    std_logic_vector(11 downto 2);
        PWDATA           : in    std_logic_vector(31 downto 0);

        AACIDMASREQRX    : in    std_logic;
        AACIDMALSREQRX   : in    std_logic;
        AACIDMABREQRX    : in    std_logic;
        AACIDMALBREQRX   : in    std_logic;
        AACIDMABREQTX    : in    std_logic;

        AACIINTR         : in    std_logic;
        AACITXINTR1      : in    std_logic;
        AACITXINTR2      : in    std_logic;
        AACITXINTR3      : in    std_logic;
        AACITXINTR4      : in    std_logic;
        AACIRXINTR1      : in    std_logic;
        AACIRXINTR2      : in    std_logic;
        AACIRXINTR3      : in    std_logic;
        AACIRXINTR4      : in    std_logic;
        AACIORINTR1      : in    std_logic;
        AACIORINTR2      : in    std_logic;
        AACIORINTR3      : in    std_logic;
        AACIORINTR4      : in    std_logic;
        AACITXCINTR1     : in    std_logic;
        AACITXCINTR2     : in    std_logic;
        AACITXCINTR3     : in    std_logic;
        AACITXCINTR4     : in    std_logic;
        AACIURINTR1      : in    std_logic;
        AACIURINTR2      : in    std_logic;
        AACIURINTR3      : in    std_logic;
        AACIURINTR4      : in    std_logic;
        AACIRXTOINTR1    : in    std_logic;
        AACIRXTOINTR2    : in    std_logic;
        AACIRXTOINTR3    : in    std_logic;
        AACIRXTOINTR4    : in    std_logic;
        AACIWINTR        : in    std_logic;
        AACIGPIOINTR     : in    std_logic;
        AACIS1RXINTR     : in    std_logic;
        AACIS2RXINTR     : in    std_logic;
        AACIS12RXINTR    : in    std_logic;
        AACIS1TXINTR     : in    std_logic;
        AACIS2TXINTR     : in    std_logic;
        AACIS12TXINTR    : in    std_logic;
        AACIRXTOFEINTR1  : in    std_logic;
        AACIRXTOFEINTR2  : in    std_logic;
        AACIRXTOFEINTR3  : in    std_logic;
        AACIRXTOFEINTR4  : in    std_logic;

        TxFFillLevel     : in    std_logic_vector(POINTERWIDTH
                                                  downto 0);
        RxFFillLevel     : in    std_logic_vector(POINTERWIDTH
                                                  downto 0);

        PCLKOn           : in    std_logic;
        BITCLKOn         : in    std_logic;

        AACITrClkReg     : in    std_logic_vector(2 downto 0);
        AACITrBtClkPrd   : in    std_logic_vector(15 downto 0);
        AACITrDMAReg     : in    std_logic_vector(6 downto 5);
        RxFRData         : in    std_logic_vector(19 downto 0);

        AACITRCNTRLWr    : out   std_logic;
        AACITRCLKWr      : out   std_logic;
        AACITRBTCLKWr    : out   std_logic;
        AACITRDMAWr      : out   std_logic;
        AACITrTxFIFOWr   : out   std_logic;
        AACITRRESETWr    : out   std_logic;
        AACITSYNCWr      : out   std_logic;

        RxFRdPtrInc      : out   std_logic;
        PRDATA           : out   std_logic_vector(31 downto 0);
        PWDataIn         : out   std_logic_vector(31 downto 0)
       );
end component;

component AaciTrRegBlk
  port (
        PCLK             : in    std_logic;
        PRESETn          : in    std_logic;
        PWDataIn         : in    std_logic_vector(31 downto 0);

        AACITSYNCWr      : in    std_logic;
        AACITRRESETWr    : in    std_logic;
        AACITRDMAWr      : in    std_logic;
        AACITRBTCLKWr    : in    std_logic;
        AACITRCLKWr      : in    std_logic;
        AACITRCNTRLWr    : in    std_logic;

        AACITrEn         : out   std_logic;
        AACITrWidChkEn   : out   std_logic;
        AACITrTxEn       : out   std_logic;
        AACITrRxEn       : out   std_logic;
        AACITrBtClkE     : out   std_logic;
        AACITrBtClkRst   : out   std_logic;
        AACITrWintGen    : out   std_logic;

        AACITrBtClkPrd   : out   std_logic_vector(15 downto 0);
        AACITrClkReg     : out   std_logic_vector(2 downto 0);
        AACITrDMAReg     : out   std_logic_vector(6 downto 5);

        FORCEDRESET      : out   std_logic;
        FORCEDSYNC       : out   std_logic;
        AACIDMACLRRX     : out   std_logic;
        AACIDMACLRTX     : out   std_logic
       );
end component;

component AaciTrTxFIFO
  port (
        PCLK             : in    std_logic;
        PRESETn          : in    std_logic;
        AACITrTxFIFOWr   : in    std_logic;
        TxFRdPtrIncSync  : in    std_logic;
        PWDataIn         : in    std_logic_vector(19 downto 0);
        TxFRdDataIn      : out   std_logic_vector(19 downto 0);
        TxFFillLevel     : out   std_logic_vector(POINTERWIDTH downto 0)
       );
end component;

component AaciTrRxFIFO
  port (
        PCLK             : in    std_logic;
        PRESETn          : in    std_logic;
        RxFWrSync        : in    std_logic;
        RxFRdPtrInc      : in    std_logic;
        RxFWrData        : in    std_logic_vector(19 downto 0);
        RxFRdData        : out   std_logic_vector(19 downto 0);
        RxFFillLevel     : out   std_logic_vector(POINTERWIDTH downto 0)
       );
end component;

component AaciTrSnc2PClk
  port (
        PCLK             : in    std_logic;
        PRESETn          : in    std_logic;
        TxFRdPtrInc      : in    std_logic;
        RxFWr            : in    std_logic;
        TxFRdPtrIncSync  : out   std_logic;
        RxFWrSync        : out   std_logic
       );
end component;

component AaciTrSnc2BtClk
  port (
        BITCLKIn         : in    std_logic;
        nAACIBITCLKRST   : in    std_logic;
        AACITrTxEn       : in    std_logic;
        AACITrRxEn       : in    std_logic;
        AACITrEn         : in    std_logic;
        AACITrBtClkE     : in    std_logic;
        AACITrWintGen    : in    std_logic;
        AACITrWidChkEn   : in    std_logic;
        AACITrEnBSync    : out   std_logic;
        TxEnSync         : out   std_logic;
        RxEnSync         : out   std_logic;
        BtClkESync       : out   std_logic;
        WintGenSync      : out   std_logic;
        WidChkEnSync     : out   std_logic
       );
end component;

component AaciTrClkGen
  port (
        PCLK             : in    std_logic;
        PRESETn          : in    std_logic;
        AACITrBtClkE     : in    std_logic;
        AACITrBtClkRst   : in    std_logic;
        AACITrBtClkPrd   : in    std_logic_vector(15 downto 0);
        AACITrClkReg     : in    std_logic_vector(2 downto 0);
        PCLKOn           : out   std_logic;
        BITCLKOn         : out   std_logic;
        AACIBITCLK       : out   std_logic;
        BITCLKIn         : out   std_logic;
        nAACIBITCLKRST   : out   std_logic;
        nFAACIBITCLKRST  : out   std_logic
       );
end component;

component AaciTrProtChk
  port (
        PCLK             : in    std_logic;
        PRESETn          : in    std_logic;
        BITCLKIn         : in    std_logic;
        AACITrEnBSync    : in    std_logic;
        BtClkESync       : in    std_logic;
        AACITrEn         : in    std_logic;
        AACISDATAIN      : in    std_logic;
        SlotState        : in    std_logic_vector(3 downto 0);
        AACITrBtClkPrd   : in    std_logic_vector(15 downto 0);
        AACISYNC         : in    std_logic;
        AACIRESET        : in    std_logic;
        FORCEDRESET      : in    std_logic;
        FORCEDSYNC       : in    std_logic;
        WidChkEnSync     : in    std_logic
       );
end component;

component AaciTrMainCntl
  port (
        BITCLKIn         : in    std_logic;
        nAACIBITCLKRST   : in    std_logic;
        AACITrEnBSync    : in    std_logic;
        TxEnSync         : in    std_logic;
        RxEnSync         : in    std_logic;
        BtClkESync       : in    std_logic;
        WintGenSync      : in    std_logic;
        AACISYNC         : in    std_logic;
        AACISDATAIN      : in    std_logic;
        TxFRdDataIn      : in    std_logic_vector(19 downto 0);
        AACITrBtClkPrd   : in    std_logic_vector(15 downto 0);
        TxFRdPtrInc      : out   std_logic;
        RxFWr            : out   std_logic;
        AACISDATAOUT     : out   std_logic;

        RxFWrData        : out   std_logic_vector(19 downto 0);
        SlotState        : out   std_logic_vector(3 downto 0)
       );
end component;

-- ---------------------------------------------------------------------
-- Constant declarations
-- ---------------------------------------------------------------------

-- ---------------------------------------------------------------------
-- Signal declarations
-- ---------------------------------------------------------------------
signal PWDataIn         : std_logic_vector(31 downto 0);
-- Pheripharal input data

signal RxFRdPtrInc      : std_logic;
-- Receive FIFO read pointer increment

signal AACITrEn         : std_logic;
-- trickbox enable

signal AACITrWidChkEn   : std_logic;
-- Data width Check enable

-- AACIBITCLK synchronised signals
signal TxEnSync         : std_logic;
-- Trickbox Transmit Enable

signal RxEnSync         : std_logic;
-- Trickbox Receive Enable

signal BtClkESync       : std_logic;
-- Trickbox Enable

signal WintGenSync      : std_logic;
-- Wake up interrupt generate signal

signal WidChkEnSync     : std_logic;
-- Width check enable

signal AACITrTxEn       : std_logic;
-- Transmit FIFO enable

signal AACITrRxEn       : std_logic;
-- Receive FIFO enable

signal AACITrBtClkE     : std_logic;
-- AACIBITCLK enable

signal AACITrBtClkRst   : std_logic;
-- AACIBITCLK domain reset bit

signal AACITrWintGen    : std_logic;
-- AACISDATAOUT in absense of AACIBITCLK for Wake Interrupt generate
-- signal Muxing register bits

signal PCLKOn           : std_logic;
-- The PCLK is driven on AACIBITCLK

signal BITCLKOn         : std_logic;
-- The PCLK is driven on AACIBITCLK

signal AACITrBtClkPrd   : std_logic_vector(15 downto 0);
-- AACIBITCLK Period

signal AACITrClkReg     : std_logic_vector(2 downto 0);
-- Clock muxing control register

signal AACITrDMAReg     : std_logic_vector(6 downto 5);
-- DMA interfacing register

signal FORCEDRESET      : std_logic;
-- Reset Register

signal FORCEDSYNC       : std_logic;
-- Sync Register

signal RxFRData         : std_logic_vector(19 downto 0);
-- Control Reg 4

signal AACITrTxFIFOWr   : std_logic;
-- The transmit FIFO write signal

signal AACITSYNCWr      : std_logic;
-- The WrEn for AACITrSYNC

signal AACITRRESETWr    : std_logic;
-- The WrEn for AACITrRESET

signal AACITRDMAWr      : std_logic;
-- The WrEn for AACITrDMAReg

signal AACITRBTCLKWr    : std_logic;
-- The WrEn for AACITrBtClkPrd

signal AACITRCLKWr      : std_logic;
-- The WrEn for AACITrClkReg

signal AACITRCNTRLWr    : std_logic;
-- The WrEn for AACITrCntrlReg

signal inAACIBITCLKRST      : std_logic;
-- AACIBITCLK domain reset

signal inFAACIBITCLKRST     : std_logic;
-- nAACIBITCLK domain reset

signal SlotState        : std_logic_vector(3 downto 0);
-- Slot number in progress

signal BITCLKIn         : std_logic;
-- Internal version of AACIBITCLK to AACI

signal TxFRdPtrInc      : std_logic;
-- Transmit FIFO read pointer increment signal

signal TxFRdPtrIncSync  : std_logic;
-- Transmit FIFO read pointer increment signal sync to PCLK

signal TxFRdDataIn      : std_logic_vector(19 downto 0);
-- Transmit FIFO read data

signal TxFFillLevel     : std_logic_vector(POINTERWIDTH downto 0);
-- Transmit FIFO fill level

signal AACITrEnBSync    : std_logic;
-- Trickbox enable on AACIBITCLK domain

signal RxFWr            : std_logic;
-- Receive FIFO write signal

signal RxFWrSync        : std_logic;
-- Receive FIFO write signal sync to PCLK

signal RxFFillLevel     : std_logic_vector(POINTERWIDTH downto 0);
-- Receive FIFO fill level

signal RxFWrData        : std_logic_vector(19 downto 0);
-- Receive FIFO write signal sync to PCLK

-- ---------------------------------------------------------------------
--
-- Main body of code
-- =================
--
-- ---------------------------------------------------------------------

begin

-- ---------------------------------------------------------------------
-- Connects the internal signal to output
-- ---------------------------------------------------------------------
nAACIBITCLKRST       <= inAACIBITCLKRST;
nFAACIBITCLKRST      <= inFAACIBITCLKRST;

-- ---------------------------------------------------------------------
-- The APB Interface contains the Write interface and the Read interface
-- for registers in the AaciTrickbox.
-- ---------------------------------------------------------------------
uAaciTrApbIf : AaciTrApbIf
  port map (
            PRESETn          => PRESETn,
            PCLK             => PCLK,
            PSEL             => PSEL,
            PSELCOM          => PSELCOM,
            PWRITE           => PWRITE,
            PENABLE          => PENABLE,
            PADDR            => PADDR,
            PWDATA           => PWDATA,
            -- DMA request signals
            AACIDMASREQRX    => AACIDMASREQRX,
            AACIDMALSREQRX   => AACIDMALSREQRX,
            AACIDMABREQRX    => AACIDMABREQRX,
            AACIDMALBREQRX   => AACIDMALBREQRX,
            AACIDMABREQTX    => AACIDMABREQTX,
            -- Interrupt ports of the AACI controller
            AACIINTR         => AACIINTR,
            AACITXINTR1      => AACITXINTR1,
            AACITXINTR2      => AACITXINTR2,
            AACITXINTR3      => AACITXINTR3,
            AACITXINTR4      => AACITXINTR4,
            AACIRXINTR1      => AACIRXINTR1,
            AACIRXINTR2      => AACIRXINTR2,
            AACIRXINTR3      => AACIRXINTR3,
            AACIRXINTR4      => AACIRXINTR4,
            AACIORINTR1      => AACIORINTR1,
            AACIORINTR2      => AACIORINTR2,
            AACIORINTR3      => AACIORINTR3,
            AACIORINTR4      => AACIORINTR4,
            AACITXCINTR1     => AACITXCINTR1,
            AACITXCINTR2     => AACITXCINTR2,
            AACITXCINTR3     => AACITXCINTR3,
            AACITXCINTR4     => AACITXCINTR4,
            AACIURINTR1      => AACIURINTR1,
            AACIURINTR2      => AACIURINTR2,
            AACIURINTR3      => AACIURINTR3,
            AACIURINTR4      => AACIURINTR4,
            AACIRXTOINTR1    => AACIRXTOINTR1,
            AACIRXTOINTR2    => AACIRXTOINTR2,
            AACIRXTOINTR3    => AACIRXTOINTR3,
            AACIRXTOINTR4    => AACIRXTOINTR4,
            AACIWINTR        => AACIWINTR,
            AACIGPIOINTR     => AACIGPIOINTR,
            AACIS1RXINTR     => AACIS1RXINTR,
            AACIS2RXINTR     => AACIS2RXINTR,
            AACIS12RXINTR    => AACIS12RXINTR,
            AACIS1TXINTR     => AACIS1TXINTR,
            AACIS2TXINTR     => AACIS2TXINTR,
            AACIS12TXINTR    => AACIS12TXINTR,
            AACIRXTOFEINTR1  => AACIRXTOFEINTR1,
            AACIRXTOFEINTR2  => AACIRXTOFEINTR2,
            AACIRXTOFEINTR3  => AACIRXTOFEINTR3,
            AACIRXTOFEINTR4  => AACIRXTOFEINTR4,

            TxFFillLevel     => TxFFillLevel,
            RxFFillLevel     => RxFFillLevel,
            PCLKOn           => PCLKOn,
            BITCLKOn         => BITCLKOn,

            AACITrClkReg     => AACITrClkReg,
            AACITrBtClkPrd   => AACITrBtClkPrd,
            AACITrDMAReg     => AACITrDMAReg,
            RxFRData         => RxFRData,

            AACITRCNTRLWr    => AACITRCNTRLWr,
            AACITRCLKWr      => AACITRCLKWr,
            AACITRBTCLKWr    => AACITRBTCLKWr,
            AACITRDMAWr      => AACITRDMAWr,
            AACITrTxFIFOWr   => AACITrTxFIFOWr,
            AACITRRESETWr    => AACITRRESETWr,
            AACITSYNCWr      => AACITSYNCWr,

            RxFRdPtrInc      => RxFRdPtrInc,
            PRDATA           => PRDATA,
            PWDataIn         => PWDataIn
           );

-- ---------------------------------------------------------------------
-- The AaciTrRegBlk Block contains all the read/writable registers
-- in the AaciTrickbox. It also contains the PCLK-domain part of the
-- control logic required to synchronise the contents of AACITrCNTRL
-- register to the AACIBITCLK domain.
-- ---------------------------------------------------------------------
uAaciTrRegBlk : AaciTrRegBlk
  port map (
            PCLK             => PCLK,
            PRESETn          => PRESETn,
            PWDataIn         => PWDataIn,

            AACITSYNCWr      => AACITSYNCWr,
            AACITRRESETWr    => AACITRRESETWr,
            AACITRDMAWr      => AACITRDMAWr,
            AACITRBTCLKWr    => AACITRBTCLKWr,
            AACITRCLKWr      => AACITRCLKWr,
            AACITRCNTRLWr    => AACITRCNTRLWr,

            -- Control outputs to other submodules
            AACITrEn         => AACITrEn,
            AACITrWidChkEn   => AACITrWidChkEn,
            AACITrTxEn       => AACITrTxEn,
            AACITrRxEn       => AACITrRxEn,
            AACITrBtClkE     => AACITrBtClkE,
            AACITrBtClkRst   => AACITrBtClkRst,
            AACITrWintGen    => AACITrWintGen,
            -- Register outputs to other submodules
            AACITrBtClkPrd   => AACITrBtClkPrd,
            AACITrClkReg     => AACITrClkReg,
            AACITrDMAReg     => AACITrDMAReg,

            FORCEDRESET      => FORCEDRESET,
            FORCEDSYNC       => FORCEDSYNC,
            AACIDMACLRRX     => AACIDMACLRRX,
            AACIDMACLRTX     => AACIDMACLRTX
           );

-- ---------------------------------------------------------------------
-- The AaciTrTxFIFO block contains the Transmit FIFO and the control
-- logic required to regulate accesses to the FIFO.
-- ---------------------------------------------------------------------
uAaciTrTxFIFO : AaciTrTxFIFO
  port map (
            PCLK             => PCLK,
            PRESETn          => PRESETn,
            AACITrTxFIFOWr   => AACITrTxFIFOWr,
            TxFRdPtrIncSync  => TxFRdPtrIncSync,
            PWDataIn         => PWDataIn(19 downto 0),
            TxFRdDataIn      => TxFRdDataIn,
            TxFFillLevel     => TxFFillLevel
           );

-- ---------------------------------------------------------------------
-- The AaciTrRxFIFO block contains the Receive FIFO and the control
-- logic required to regulate accesses to the FIFO.
-- ---------------------------------------------------------------------
uAaciTrRxFIFO : AaciTrRxFIFO
  port map (
            PCLK             => PCLK,
            PRESETn          => PRESETn,
            RxFWrSync        => RxFWrSync,
            RxFRdPtrInc      => RxFRdPtrInc,
            RxFWrData        => RxFWrData,
            RxFRdData        => RxFRData,
            RxFFillLevel     => RxFFillLevel
           );

-- ---------------------------------------------------------------------
-- This block contains synchronisers for signals crossing into the PCLK
-- domain.
-- ---------------------------------------------------------------------
uAaciTrSnc2PClk : AaciTrSnc2PClk
  port map (
            PCLK             => PCLK,
            PRESETn          => PRESETn,
            TxFRdPtrInc      => TxFRdPtrInc,
            RxFWr            => RxFWr,
            TxFRdPtrIncSync  => TxFRdPtrIncSync,
            RxFWrSync        => RxFWrSync
           );

-- ---------------------------------------------------------------------
-- The AaciTrSynctoAaciCLK block contains synchronisers for signals
-- crossing into the AaciCLK domain.
-- ---------------------------------------------------------------------
uAaciTrSnc2BtClk : AaciTrSnc2BtClk
  port map (
            BITCLKIn         => BITCLKIn,
            nAACIBITCLKRST   => inAACIBITCLKRST,
            AACITrTxEn       => AACITrTxEn,
            AACITrRxEn       => AACITrRxEn,
            AACITrEn         => AACITrEn,
            AACITrBtClkE     => AACITrBtClkE,
            AACITrWintGen    => AACITrWintGen,
            AACITrWidChkEn   => AACITrWidChkEn,
            AACITrEnBSync    => AACITrEnBSync,
            TxEnSync         => TxEnSync,
            RxEnSync         => RxEnSync,
            BtClkESync       => BtClkESync,
            WintGenSync      => WintGenSync,
            WidChkEnSync     => WidChkEnSync
           );

-- ---------------------------------------------------------------------
-- The AaciTrClkGen block generates AACIBITCLK and nAACIBITCLKRST.
-- ---------------------------------------------------------------------
uAaciTrClkGen : AaciTrClkGen
  port map (
            PCLK             => PCLK,
            PRESETn          => PRESETn,
            AACITrBtClkE     => AACITrBtClkE,
            AACITrBtClkRst   => AACITrBtClkRst,
            AACITrBtClkPrd   => AACITrBtClkPrd,
            AACITrClkReg     => AACITrClkReg(2 downto 0),
            PCLKOn           => PCLKOn,
            BITCLKOn         => BITCLKOn,
            AACIBITCLK       => AACIBITCLK,
            BITCLKIn         => BITCLKIn,
            nAACIBITCLKRST   => inAACIBITCLKRST,
            nFAACIBITCLKRST  => inFAACIBITCLKRST
           );

-- ---------------------------------------------------------------------
-- The AaciTrChecker block contains protocol checkers that monitor the
-- Aaci's non-AMBA outputs.
-- ---------------------------------------------------------------------
uAaciTrProtChk : AaciTrProtChk
  port map (
            PCLK             => PCLK,
            PRESETn          => PRESETn,
            BITCLKIn         => BITCLKIn,
            AACITrEnBSync    => AACITrEnBSync,
            BtClkESync       => BtClkESync,
            AACITrEn         => AACITrEn,
            AACISDATAIN      => AACISDATAIN,
            SlotState        => SlotState,
            AACITrBtClkPrd   => AACITrBtClkPrd,
            AACISYNC         => AACISYNC,
            AACIRESET        => AACIRESET,
            FORCEDRESET      => FORCEDRESET,
            FORCEDSYNC       => FORCEDSYNC,
            WidChkEnSync     => WidChkEnSync
           );

-- ---------------------------------------------------------------------
-- The AaciTrMainCntl block contains the main Transmit/Receive control
-- logic in the trickbox that verifies the functionality of the Aaci.
-- ---------------------------------------------------------------------
uAaciTrMainCntl : AaciTrMainCntl
  port map (
            BITCLKIn         => BITCLKIn,
            nAACIBITCLKRST   => inAACIBITCLKRST,
            AACITrEnBSync    => AACITrEnBSync,
            TxEnSync         => TxEnSync,
            RxEnSync         => RxEnSync,
            BtClkESync       => BtClkESync,
            WintGenSync      => WintGenSync,
            AACISYNC         => AACISYNC,
            AACISDATAIN      => AACISDATAIN,
            TxFRdDataIn      => TxFRdDataIn,
            AACITrBtClkPrd   => AACITrBtClkPrd,
            TxFRdPtrInc      => TxFRdPtrInc,
            RxFWr            => RxFWr,
            AACISDATAOUT     => AACISDATAOUT,
            RxFWrData        => RxFWrData,
            SlotState        => SlotState
           );

end structural;

-- --============================ End ================================--
