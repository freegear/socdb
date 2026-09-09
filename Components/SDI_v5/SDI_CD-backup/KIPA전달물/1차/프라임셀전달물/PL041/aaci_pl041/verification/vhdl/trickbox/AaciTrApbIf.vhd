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
-- File Name              : AaciTrApbIf.vhd.rca
-- File Revision          : 1.3
--
-- Release Information    : PrimeCell(TM)-PL041-REL1v0
--
-- ---------------------------------------------------------------------
-- Purpose :
--           APB Interface to generate decodes for write and read
--           accesses to AACI Trickbox internal registers.
--
-- --=================================================================--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

use work.AaciTrPackage.all;

-- ---------------------------------------------------------------------

entity AaciTrApbIf is
  port (
-- Inputs
        PCLK             : in    std_logic; -- APB Bus Clock
        PRESETn          : in    std_logic; -- AMBA Bus Reset
        PSEL             : in    std_logic; -- AACI trickbox select
        PSELCOM          : in    std_logic; -- AACI select
        PWRITE           : in    std_logic; -- APB Peripheral Write
        PENABLE          : in    std_logic; -- APB Peripheral enable
        PADDR            : in    std_logic_vector(11 downto 2);
                                            -- APB Addr
        PWDATA           : in    std_logic_vector(31 downto 0);
                                            -- Write databus
        -- DMA request signals
        AACIDMASREQRX    : in    std_logic; -- AACI single transfer req
        AACIDMALSREQRX   : in    std_logic; -- AACI single last transfer
        AACIDMABREQRX    : in    std_logic; -- AACI burst transfer req
        AACIDMALBREQRX   : in    std_logic; -- AACI burst last transfer
        AACIDMABREQTX    : in    std_logic; -- AACI single transfer req

        -- Interrupt ports of the AACI controller
        AACIINTR         : in    std_logic; -- AACI combined interrupt
        AACITXINTR1      : in    std_logic; -- Channel 1 fifo Tx intr
        AACITXINTR2      : in    std_logic; -- Channel 2 fifo Tx intr
        AACITXINTR3      : in    std_logic; -- Channel 3 fifo Tx intr
        AACITXINTR4      : in    std_logic; -- Channel 4 fifo Tx intr
        AACIRXINTR1      : in    std_logic; -- Channel 1 fifo Rx intr
        AACIRXINTR2      : in    std_logic; -- Channel 2 fifo Rx intr
        AACIRXINTR3      : in    std_logic; -- Channel 3 fifo Rx intr
        AACIRXINTR4      : in    std_logic; -- Channel 4 fifo Rx intr
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
        AACIRXTOINTR1    : in    std_logic; -- Channel 1 Rx timeout Intr
        AACIRXTOINTR2    : in    std_logic; -- Channel 2 Rx timeout Intr
        AACIRXTOINTR3    : in    std_logic; -- Channel 3 Rx timeout Intr
        AACIRXTOINTR4    : in    std_logic; -- Channel 4 Rx timeout Intr
        AACIWINTR        : in    std_logic; -- Wakeup Interrupt
        AACIGPIOINTR     : in    std_logic; -- GPIO Interrupt
        AACIS1RXINTR     : in    std_logic; -- Slot1 recieve interrupt
        AACIS2RXINTR     : in    std_logic; -- Slot2 recieve interrupt
        AACIS12RXINTR    : in    std_logic; -- Slot12 recieve interrupt
        AACIS1TXINTR     : in    std_logic; -- Slot1 transmit interrupt
        AACIS2TXINTR     : in    std_logic; -- Slot2 transmit interrupt
        AACIS12TXINTR    : in    std_logic; -- Slot12 transmit interrupt
        AACIRXTOFEINTR1  : in    std_logic; -- Rx Timeout FIFO 1 Empty
        AACIRXTOFEINTR2  : in    std_logic; -- Rx Timeout FIFO 2 Empty
        AACIRXTOFEINTR3  : in    std_logic; -- Rx Timeout FIFO 3 Empty
        AACIRXTOFEINTR4  : in    std_logic; -- Rx Timeout FIFO 4 Empty

        TxFFillLevel     : in    std_logic_vector(POINTERWIDTH
                                                  downto 0);
                                            -- The Tx FIFO filllevel
        RxFFillLevel     : in    std_logic_vector(POINTERWIDTH
                                                  downto 0);
                                            -- The Rx FIFO filllevel
        PCLKOn           : in    std_logic; -- PCLK is routed to BITCLK
        BITCLKOn         : in    std_logic; -- Internal BITCLK is routed
                                            -- to BITCLK

        AACITrClkReg     : in    std_logic_vector(2 downto 0);
                                            -- Clock muxing register
        AACITrDMAReg     : in    std_logic_vector(6 downto 5);
                                            -- Clock muxing register
        AACITrBtClkPrd   : in    std_logic_vector(15 downto 0);
                                            -- BITCLK period
        RxFRData         : in    std_logic_vector(19 downto 0);
                                            -- Receive FIFO Data
-- Outputs
        AACITRCNTRLWr    : out   std_logic; -- WrEn to AACITrCntrlReg
        AACITRCLKWr      : out   std_logic; -- WrEn for AACITrClkReg
        AACITRBTCLKWr    : out   std_logic; -- WrEn for AACITrBtClkPrd
        AACITRDMAWr      : out   std_logic; -- WrEn for AACITrDMAReg
        AACITrTxFIFOWr   : out   std_logic; -- WrEn for Tx FIFO
        AACITRRESETWr    : out   std_logic; -- WrEn for AACITrRESET
        AACITSYNCWr      : out   std_logic; -- WrEn for AACITRSYNC

        RxFRdPtrInc      : out   std_logic; -- RxFIFO read ptr Increment
        PRDATA           : out   std_logic_vector(31 downto 0);
                                            -- Read Databus
        PWDataIn         : out   std_logic_vector(31 downto 0)
                                            -- Int PWDATA
       );
end AaciTrApbIf;

-- ---------------------------------------------------------------------
--
--                             AaciTrApbIf
--                             ===========
--
-- ---------------------------------------------------------------------
--
-- Overview
-- ========
-- This module decodes APB accesses and generates the write strobes to
-- the appropriate registers. This module also contains the output data
-- multiplexer and the output register that form the read interface. The
-- internal databus, for the AACITrickbox, PWDataIn[31:0], is also
-- generated in this module, by gating the input data bus, PWDATA[31:0]
-- with PSEL (or PSELCOM) and PWRITE.
-- Reading and writing of data from the internal registers and the Tx
-- and Rx FIFO is done via the APB interface.
-- This block has 2 PSELs; one is PSELCOM which is the same as the PSEL
-- input to the AACI and the other is the trickbox-specific PSEL. The
-- use of PSELCOM allows the trickbox to detect writes to certain
-- AACI registers that are mirrored in the Trickbox. When these mirrored
-- registers are writen to, the data is captured by the Trickbox and
-- stored in the internal mirrored versions of the AACI registers.
-- This eliminates extra register writes since the programming of
-- the trickbox and the AACI happens in parallel. The PSEL is used for
-- writing in to the trickbox specific registers and the trickbox
-- transmit and receive FIFOs. The PSELCOM (PSEL of the AACI ) is used
-- for writing in to the registers, which are mirror images of the AACI
-- register (i.e. AACIRESET, AACISYNC). To avoid a conflict on the
-- databus during reads to these mirrired register, the Trickbox will
-- not respond reads to the morrored registers.
--
-- ---------------------------------------------------------------------
--                    AACI TrickBox Register Map
-- ---------------------------------------------------------------------
-- Base Addr     Offset Register          Read/Write     Description
-- ---------------------------------------------------------------------
-- Trickbox Base 0x000  AACITrCntrlReg    Write only  Control register
-- Trickbox Base 0x000  AACITrIntr1Reg    Read only   Interrupt Status
--                                                    register
-- Trickbox Base 0x004  AACITrBtClkPrd    Read-Write  BITCLK period in
--                                                    ns
-- Trickbox Base 0x008  AACITrDMAReg      Read-Write  DMA interface
--                                                    register
-- Trickbox Base 0x00C  AACITrFIFOStat    Read only
-- Trickbox Base 0x010  AACITrRxFIFO      Read only
-- Trickbox Base 0x014  AACITrTxFIFO      Write only
-- Trickbox Base 0x018  AACITrIntr2Reg    Read only   Interrupt Status
-- Trickbox Base 0x01C  AACITrClkReg      Read-Write  Muxing control
-- AACI Base     0x07C  AACITrRESET       Write only
-- AACI Base     0x080  AACITrSYNC        Write only
--
-- ---------------------------------------------------------------------

-- --========================= ARCHITECTURE ==========================--

architecture behavioural of AaciTrApbIf is

-- ---------------------------------------------------------------------
-- Constant declarations
-- ---------------------------------------------------------------------
constant ZEROFILL         : std_logic_vector(31 downto 0) :=
                           "00000000000000000000000000000000";
-- Zero Fill for reads to return zeros in unused bit positions

-- ---------------------------------------------------------------------
-- Signal declarations
-- ---------------------------------------------------------------------
signal PAddrGated       : std_logic_vector(11 downto 2);
-- Changing the PA bus only when the PSEL or PSELCOM is high for
-- power saving

-- Read Decodes for Register reads

signal AACITRINTRRd     : std_logic;
-- AACITRINTR read

signal AACITRINTR2Rd    : std_logic;
-- AACITRINTR2 read

signal AACITRBTCLKRd    : std_logic;
-- AACITRBTCLK read

signal AACITRCLKRd      : std_logic;
-- AACITRCLK read

signal AACITRFSTRd      : std_logic;
-- AACITRFST read

signal AACITRDMARd      : std_logic;
-- AACITRDMA read

signal AACITRRFRd       : std_logic;
-- AACITRRF read

signal NextPRDATA       : std_logic_vector(31 downto 0);
-- D input of PRDATA reg

signal WrEn             : std_logic;
-- Write enable for trickbox specific registers

signal WrEnCom          : std_logic;
-- Enable for AACI mirrored registers.

signal RdEn             : std_logic;
-- Read enable signal for the readable registers.

signal IntDMAReg        : std_logic_vector(4 downto 0);
-- The DMA register capturing the DMA signals.

signal AACITrIntr1Reg   : std_logic_vector(31 downto 0);
-- The interrupt register capturing the DMA signals.

signal AACITrIntr2Reg   : std_logic_vector(4 downto 0);
-- The interrupt register 2 capturing the DMA signals.

signal AACITrFIFOStat   : std_logic_vector(31 downto 0);
-- The interrupt register 2 capturing the DMA signals.

-- ---------------------------------------------------------------------
--
-- Main body of code
-- =================
--
-- ---------------------------------------------------------------------

begin

-- ---------------------------------------------------------------------
-- Write Interface
-- ---------------------------------------------------------------------
-- ---------------------------------------------------------------------
-- Latch the data bus and address bus when the device is selected.
-- ---------------------------------------------------------------------
PAddrGated       <= PADDR when (PSEL = '1' or PSELCOM = '1')
                 else
                    (others => '0');

PWDataIn         <= PWDATA when ((PSEL = '1' or PSELCOM = '1') and
                                 (PWRITE = '1'))
                 else
                    (others  => '0');

WrEn             <= PENABLE and PSEL and PWRITE;
WrEnCom          <= PENABLE and PSELCOM and PWRITE;

-- ---------------------------------------------------------------------
-- Register Write Decodes for common as well as trickbox specific
-- registers
-- ---------------------------------------------------------------------
-- AACITrCntrlReg
AACITRCNTRLWr    <= '1' when ((WrEn = '1') and
                              (PAddrGated = PA_AACITRCNTRL))
                 else
                    '0';
-- AACITrBtClkPrd
AACITRBTCLKWr    <= '1' when ((WrEn = '1') and
                               (PAddrGated = PA_AACITRBTCLK))
                 else
                    '0';
-- AACITrClkReg
AACITRCLKWr      <= '1' when ((WrEn = '1') and
                               (PAddrGated = PA_AACITRCLKREG))
                 else
                    '0';
-- AACITrDMAReg
AACITRDMAWr      <= '1' when ((WrEn = '1') and
                               (PAddrGated = PA_AACITRDMAREG))
                 else
                    '0';
-- AACITrTxFIFO
AACITrTxFIFOWr   <= '1' when ((WrEn = '1') and
                               (PAddrGated = PA_AACITRTF))
                 else
                    '0';

-- Common registers write enable generation

-- AACITrRESET
AACITRRESETWr    <= '1' when ((WrEnCom = '1') and
                               (PAddrGated = PA_AACITRRESET))
                 else
                    '0';
-- AACITrSYNC
AACITSYNCWr      <= '1' when ((WrEnCom = '1') and
                               (PAddrGated = PA_AACITSYNC))
                 else
                    '0';

-- ---------------------------------------------------------------------
-- Read Interface enable for reading the trickbox specific registers
-- ---------------------------------------------------------------------
RdEn <= PSEL and (not PWRITE) and (not PENABLE);

-- ---------------------------------------------------------------------
-- Register Read Decodes for the trickbox specific registers
-- ---------------------------------------------------------------------
-- AACITrIntr1Reg
AACITRINTRRd     <= '1' when ((RdEn = '1') and
                               (PAddrGated = PA_AACITRINTR1))
                 else
                    '0';
-- AACITrIntr2Reg
AACITRINTR2Rd    <= '1' when ((RdEn = '1') and
                               (PAddrGated = PA_AACITRINTR2))
                 else
                    '0';
-- AACITrClkReg
AACITRCLKRd      <= '1' when ((RdEn = '1') and
                               (PAddrGated = PA_AACITRCLKREG))
                 else
                    '0';
-- AACITrBtClkPrd
AACITRBTCLKRd    <= '1' when ((RdEn = '1') and
                              (PAddrGated = PA_AACITRBTCLK))
                 else
                    '0';
-- AACITrDMAReg
AACITRDMARd      <= '1' when ((RdEn = '1') and
                               (PAddrGated = PA_AACITRDMAREG))
                 else
                    '0';
-- AACITrFIFOStat
AACITRFSTRd      <= '1' when ((RdEn = '1') and
                               (PAddrGated = PA_AACITRFST))
                 else
                    '0';
-- AACITrRxFIFO
AACITRRFRd       <= '1' when ((RdEn = '1') and
                               (PAddrGated = PA_AACITRRF))
                 else
                    '0';

-- ---------------------------------------------------------------------
-- Increment the Read pointer in the Receive FIFO after every read from
-- the Receive FIFO i.e. After every read from the AACITBRDR Register
-- ---------------------------------------------------------------------
RxFRdPtrInc      <= '1' when ((PENABLE = '1') and (PSEL = '1') and
                              (PWRITE = '0') and
                              (PAddrGated = PA_AACITRRF))
                 else
                    '0';

-- ---------------------------------------------------------------------
-- Output Mux.
-- When the peripheral trickbox is not being accessed, '0's are driven
-- on the Read Databus (PRDATA) so as not to place any restrictions on
-- the method of external bus connection. The external data buses of the
-- peripherals on the APB may then be connected to the ASB-to-APB bridge
-- using Muxed or ORed bus connection method.
-- ---------------------------------------------------------------------
NextPRDATA       <= AACITrIntr1Reg when (AACITRINTRRd = '1')
                 else
                    ZEROFILL(31 downto 5) & AACITrIntr2Reg
                                   when (AACITRINTR2Rd = '1')
                 else
                    ZEROFILL(31 downto 16) & AACITrBtClkPrd
                                   when (AACITRBTCLKRd = '1')
                 else
                    ZEROFILL(31 downto 5) & BITCLKOn & PCLKOn &
                    AACITrClkReg
                                   when (AACITRCLKRd = '1')
                 else
                    ZEROFILL(31 downto 7) & AACITrDMAReg & IntDMAReg
                                   when (AACITRDMARd = '1')
                 else
                    AACITrFIFOStat
                                   when (AACITRFSTRd = '1')
                 else
                    ZEROFILL(31 downto 20) & RxFRData
                                   when (AACITRRFRd = '1')
                 else
                    ZEROFILL;

-- ---------------------------------------------------------------------
-- Output Data register for sequential data driving on the rising edges
-- of the PCLK
-- ---------------------------------------------------------------------
p_Seq : process (PCLK, PRESETn)
begin
  if (PRESETn = '0') then
    PRDATA <= (others => '0');
  elsif (PCLK'event and PCLK = '1') then
    PRDATA <= NextPRDATA;
  end if;
end process p_Seq;

-- ---------------------------------------------------------------------
-- The AACITrIntr1Reg assignment from the occurence of the interrupts.
-- ---------------------------------------------------------------------
AACITrIntr1Reg   <= (AACIURINTR4 & AACIORINTR4 & AACIRXINTR4 &
                     AACITXINTR4 & AACIRXTOINTR4 & AACITXCINTR4 &
                     AACIURINTR3 & AACIORINTR3 & AACIRXINTR3 &
                     AACITXINTR3 & AACIRXTOINTR3 & AACITXCINTR3 &
                     AACIURINTR2 & AACIORINTR2 & AACIRXINTR2 &
                     AACITXINTR2 & AACIRXTOINTR2 & AACITXCINTR2 &
                     AACIURINTR1 & AACIORINTR1 & AACIRXINTR1 &
                     AACITXINTR1 & AACIRXTOINTR1 & AACITXCINTR1 &
                     AACIWINTR & AACIGPIOINTR & AACIS12TXINTR &
                     AACIS12RXINTR & AACIS2TXINTR &
                     AACIS2RXINTR & AACIS1TXINTR &
                     AACIS1RXINTR);

-- ---------------------------------------------------------------------
-- The AACITrIntr2Reg assignment from the occurence of the interrupts.
-- ---------------------------------------------------------------------
AACITrIntr2Reg   <= (AACIRXTOFEINTR4 & AACIRXTOFEINTR3 &
                     AACIRXTOFEINTR2 & AACIRXTOFEINTR1 & AACIINTR);

-- ---------------------------------------------------------------------
-- The Internal DMA register assignment from the DMA requests from AACI
-- ---------------------------------------------------------------------
IntDMAReg        <= AACIDMABREQTX & AACIDMALBREQRX & AACIDMABREQRX &
                    AACIDMALSREQRX & AACIDMASREQRX;

-- ---------------------------------------------------------------------
-- The AACITRFIFOStat assignment from the condition of the FIFO's.
-- ---------------------------------------------------------------------
AACITrFIFOStat   <= ZEROFILL(15 downto (POINTERWIDTH +1)) & TxFFillLevel
                    & ZEROFILL(15 downto (POINTERWIDTH +1)) &
                    RxFFillLevel;

end behavioural;

-- =========================== End ===================================--

