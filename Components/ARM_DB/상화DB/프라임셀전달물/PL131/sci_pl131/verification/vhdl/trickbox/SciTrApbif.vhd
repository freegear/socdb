-- --=========================================================================--
--  This confidential and proprietary software may be used only as
--  authorised by a licensing agreement from ARM Limited
--    (C) COPYRIGHT 2001 ARM Limited
--        ALL RIGHTS RESERVED
--  The entire notice above must be reproduced on all authorised
--  copies and copies may only be made to the extent permitted
--  by a licensing agreement from ARM Limited.
--  ----------------------------------------------------------------------------
--
--  Version and Release Control Information:
--
--  File Name              : SciTrApbif.vhd.rcaS
--  File Revision          : 1.1
--
--  Release Information    : PrimeCell(TM)-PL131-REL1v0
--
--  ----------------------------------------------------------------------------
 
--  ----------------------------------------------------------------------------
--  Purpose : This block generates decodes for Register accesses
--
-- --=========================================================================--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

--------------------------------------------------------------------------------

entity SciTrApbif is
  port (PCLK             : in    std_logic;     -- APB Bus Clock 
        PRESETn          : in    std_logic;     -- Bus Reset 
        PSELT            : in    std_logic;     -- APB Peripheral Select
        PENABLE          : in    std_logic;     -- APB Peripheral Enable
        PWRITE           : in    std_logic;     -- APB Peripheral Write
        PADDR            : in    std_logic_vector(7 downto 2);  -- APB Addr Bus
        PWDATA           : in    std_logic_vector(15 downto 0); -- Wr  Data Bus
        RxFRdData        : in    std_logic_vector(8 downto 0);  -- Rx FIFO data
        SCITrCR          : in    std_logic_vector(15 downto 0); -- Control reg
        SCITrFiLCR       : in    std_logic_vector(7 downto 0);	-- FIFO level 
        SCITrCTRL        : in    std_logic_vector(7 downto 0);  -- Er massage 
        SCITrTXPC        : in    std_logic_vector(3 downto 0);  -- TX Retry reg
        SCITrRXPC        : in    std_logic_vector(3 downto 0);  -- RX Retry reg
        SCITrTFF         : in    std_logic;     -- TX Full Flag
        SCITrTFE         : in    std_logic;     -- TX Empty Flag
        SCITrTFR         : in    std_logic;     -- TX level Flag
        SCITrRFF         : in    std_logic;     -- RX Full Flag
        SCITrRFE         : in    std_logic;     -- RX Empty Flag
        SCITrRFR         : in    std_logic;     -- RX level Flag
        SCIDEACACK       : in    std_logic;     -- Data out enable
        SCITrAT          : in    std_logic_vector(15 downto 0); -- ACTtime reg
        SCITrDT          : in    std_logic_vector(15 downto 0); -- DEACTtim reg
        SCITrTXBLKG      : in    std_logic_vector(7 downto 0);  -- TXBLKGrd reg
        SCITrTXCHG       : in    std_logic_vector(7 downto 0);  -- TXCHGrd reg
        SCITrCKICC       : in    std_logic_vector(15 downto 0); -- Clk freq reg
        SCITrBAUD        : in    std_logic_vector(15 downto 0); -- Baud reg
        SCITrVALUE       : in    std_logic_vector(7 downto 0);  -- Value reg
        SCITrRXCHG       : in    std_logic_vector(7 downto 0);  -- RXCHGRD reg
        SCITrRXBLKG      : in    std_logic_vector(7 downto 0);  -- RXBGUrd reg
        SCITrRFCK        : in    std_logic_vector(15 downto 0); -- RXBLKGrd reg
        SCITrWV          : in    std_logic_vector(7 downto 0);  -- RFCLK reg
        SCITrJit         : in    std_logic_vector(15 downto 0); -- Jit Cnt reg
        SCITrJitPat      : in    std_logic_vector(9 downto 0);  -- Jit val reg
        PCLKOn           : in    std_logic;     -- PCLK on 
        REFCLKOn         : in    std_logic;     -- REFCLK on 
        SCICARDININTR    : in    std_logic;     -- CARDIN intr
        SCICARDOUTINTR   : in    std_logic;     -- CARDOUT intr
        SCICARDUPINTR    : in    std_logic;     -- CARDUP intr
        SCICARDDNINTR    : in    std_logic;     -- CARDDN intr
        SCITXERRINTR     : in    std_logic;     -- TXERR intrr
        SCIATRSTOUTINTR  : in    std_logic;     -- ATRSTOUT  intr
        SCIATRDTOUTINTR  : in    std_logic;     -- ATRDTOUT intr
        SCIBLKTOUTINTR   : in    std_logic;     -- BLKTIMEOUT intr
        SCICHTOUTINTR    : in    std_logic;     -- CHTIMEOUT intr
        SCITXTIDEINTR    : in    std_logic;     -- TXTIDE intr
        SCIRXTIDEINTR    : in    std_logic;     -- RXTIDE intr
        SCIRTOUTINTR     : in    std_logic;     -- Rx FIFO read timeout intr
        SCIRORINTR       : in    std_logic;     -- Rx OverRun Intr
        SCICLKSTPINTR    : in    std_logic;     -- Clock stopped intr
        SCICLKACTINTR    : in    std_logic;     -- Clock active intr
        SCIINTR          : in    std_logic;     -- Intr
        SCITXDMASREQ     : in    std_logic;     -- Transmit DMA single request
        SCITXDMABREQ     : in    std_logic;     -- Transmit DMA burst  request
        SCIRXDMASREQ     : in    std_logic;     -- Receive  DMA single request
        SCIRXDMABREQ     : in    std_logic;     -- Receive  DMA burst  request

        SCITrDATAWrEn    : out   std_logic;     -- Data Wr En
        SCITrCRWrEn      : out   std_logic;     -- Control Reg Wr En
        SCITrFiLCRWrEn   : out   std_logic;     -- FiFO level Reg Wr En
        SCITrTXPCWrEn    : out   std_logic;     -- TX Retray Cnt Wr En
        SCITrRXPCWrEn    : out   std_logic;     -- RX Retray Cnt Wr En
        SCITrCTRLWrEn    : out   std_logic;     -- Error massage enable Wr En
        SCITrATWrEn      : out   std_logic;     -- ATIME Wr En
        SCITrDTWrEn      : out   std_logic;     -- DTIME Wr En
        SCITrTXBLKGWrEn  : out   std_logic;     -- TXBLKGuard Wr En
        SCITrTXCHGWrEn   : out   std_logic;     -- TXCHTGuard Wr En
        SCITrCKICCWrEn   : out   std_logic;     -- CLKICC Wr En
        SCITrBAUDWrEn    : out   std_logic;     -- Baud Wr En
        SCITrVALUEWrEn   : out   std_logic;     -- Value Wr En
        SCITrRXCHGWrEn   : out   std_logic;     -- RXCHGuard Wr En
        SCITrRXBLKGWrEn  : out   std_logic;     -- RXBLKGuard Wr En
        SCITrRFCKWrEn    : out   std_logic;     -- REFCLK Wr En
        SCITrWVWrEn      : out   std_logic;     -- ErMargin Wr En
        SCITrJitWrEn     : out   std_logic;     -- Jit value Reg Wr En
        SCITrJitPatWrEn  : out   std_logic;     -- Jit Control Wr En
        SCITrRFCNTLWrEn  : out   std_logic;     -- REFCLK Gen Cnt Wr En
        RxFRdPtrInc      : out   std_logic;     -- Rx FIFO Rd ptr Inc
        PWDATAIn         : out   std_logic_vector(15 downto 0); -- Int PWDATA
        PRDATA           : out   std_logic_vector(15 downto 0); -- Read data
        SCITrDMAWr       : out   std_logic      -- Write Enable for SCITDMACR
        );
end SciTrApbif;

-------------------------------------------------------------------------------
--
--
--                         SciTrApbif
--                         ========== 
--
-------------------------------------------------------------------------------
--
-- Overview    
-- ========
-- This module decodes APB accesses and generates the read/write 
-- strobe to the appropriate registers.
--
-------------------------------------------------------------------------------
--                         SciTr Register Map
-------------------------------------------------------------------------------
-- Offset Register Type Width      Describtion   
-------------------------------------------------------------------------------
--
-------------------------------------------------------------------------------
--
--=============================== ARCHITECTURE ===============================--

architecture synth of SciTrApbif  is

--------------------------------------------------------------------------------
-- Component Declaration
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Constant declaration
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Trickbox registers address constants.Address decode is for
-- bits 2 to 7 (6 bits)
--------------------------------------------------------------------------------

constant ZERO             : std_logic_vector(11 downto 0) := "000000000000"; 
         
constant PADDR_SCITrDATA  : std_logic_vector(7 downto 2)  := "000000";
-- SCITrDATA at offset 0x00

constant PADDR_SCITrCR    : std_logic_vector(7 downto 2)  := "000001";
-- SCITrCR at offset 0x04

constant PADDR_SCITrFiLCR : std_logic_vector(7 downto 2)  := "000010";
-- SCITrFiLCR at offset 0x08

constant PADDR_SCITrSR0   : std_logic_vector(7 downto 2)  := "000011";
-- SCITrSR0 at offset 0x0C

constant PADDR_SCITrSR1   : std_logic_vector(7 downto 2)  := "000100";
-- SCITrSR1 at offset 0x10

constant PADDR_SCITrSR2   : std_logic_vector(7 downto 2)  := "000101";
-- SCITrSR2 at offset 0x14

constant PADDR_SCITrTXPC  : std_logic_vector(7 downto 2)  := "000110";
-- SCITrTXPC at offset 0x18

constant PADDR_SCITrRXPC  : std_logic_vector(7 downto 2)  := "000111";
-- SCITrRXPC at offset 0x1C

constant PADDR_SCITrCTRL  : std_logic_vector(7 downto 2)  := "001000";
-- SCITrCTRL at offset 0x20

constant PADDR_SCITrAT    : std_logic_vector(7 downto 2)  := "001001";
-- SCITrAT at offset 0x24

constant PADDR_SCITrDT    : std_logic_vector(7 downto 2)  := "001010";
-- SCITrDT at offset 0x28

constant PADDR_SCITrCKICC : std_logic_vector(7 downto 2)  := "001011";
-- SCITrCKICC at offset 0x2C

constant PADDR_SCITrBAUD  : std_logic_vector(7 downto 2)  := "001100";
-- SCITrBAUD at offset 0x30

constant PADDR_SCITrVALUE : std_logic_vector(7 downto 2)  := "001101";
-- SCITrVALUE at offset 0x34

constant PADDR_SCITrTXCHG : std_logic_vector(7 downto 2)  := "001110";
-- SCITrTXCHG at offset 0x38

constant PADDR_SCITrTXBG  : std_logic_vector(7 downto 2)  := "001111";
-- SCITrTXBLKG at offset 0x3C

constant PADDR_SCITrRXCHG : std_logic_vector(7 downto 2)  := "010000";
-- SCITrRXCHG at offset 0x40

constant PADDR_SCITrRXBG  : std_logic_vector(7 downto 2)  := "010001";
-- SCITrRXBLKG at offset 0x44

constant PADDR_SCITrRFCK  : std_logic_vector(7 downto 2)  := "010010";
-- SCITrRFCK at offset 0x48

constant PADDR_SCITrWV    : std_logic_vector(7 downto 2)  := "010011";
-- SCITrWV at offset 0x4C

constant PADDR_SCITrJit   : std_logic_vector(7 downto 2)  := "010100";
-- SCITrJit at offset 0x50

constant PADDR_SCITrJitPt : std_logic_vector(7 downto 2)  := "010101";
-- SCITrJitPat at offset 0x54

constant PADDR_RFCNTL     : std_logic_vector(7 downto 2)  := "010110";
-- SCITrRFCNTLR at offset 0x58

constant PADDR_SCITrDMA   : std_logic_vector(7 downto 2)  := "010111";
-- SCITrDMA at offset 0x5C

  
--------------------------------------------------------------------------------
-- Signal declarations
--------------------------------------------------------------------------------
signal GatedPADDR : std_logic_vector(7 downto 2);
-- Save power by gating PADDR internally with PSEL

--------------------------------------------------------------------------------
-- Read Decodes for Register reads
--------------------------------------------------------------------------------
signal SCITrDATArd        : std_logic;  
-- SCITrDATA Read

signal SCITrCRrd          : std_logic;
-- SCITrCR Read 

signal SCITrFiLCRrd       : std_logic;
-- SCITrFiL Read 

signal SCITrSR0rd         : std_logic;
-- SCITrSR0 Read 

signal SCITrSR1rd         : std_logic;
-- SCITrSR1 Read 

signal SCITrSR2rd         : std_logic;
-- SCITrSR2 Read 

signal SCITrTXPCrd        : std_logic;
-- SCITrTXPC Read 

signal SCITrRXPCrd        : std_logic;
-- SCITrRXPC Read 

signal SCITrCTRLrd        : std_logic;
-- SCITrCTRL Read 

signal SCITrATrd          : std_logic;
-- SCITrAT Read 

signal SCITrDTrd          : std_logic;
-- SCITrDT Read 

signal SCITrTXBLKGrd      : std_logic;
-- SCITrTXBLKG Read 

signal SCITrTXCHGrd       : std_logic;
-- SCITrTXCHG Read 

signal SCITrCKICCrd       : std_logic;
-- SCITrCKICC Read 

signal SCITrBAUDrd        : std_logic;
-- SCITrBAUD Read 

signal SCITrVALUErd       : std_logic;
-- SCITrVALUE Read 

signal SCITrRXCHGrd       : std_logic;
-- SCITrRXCHG Read 

signal SCITrRXBLKGrd      : std_logic;
-- SCITrRXBLKG Read 

signal SCITrRFCKrd        : std_logic;
-- SCITrRFCK Read
 
signal SCITrWVrd          : std_logic;
-- SCITrWV Read
 
signal SCITrJitrd         : std_logic;
-- SCITrJit Read
 
signal SCITrJitPatrd      : std_logic;
-- SCITrJitPat Read

signal SCITrRFCNTLrd      : std_logic;
-- SCITrRFCNTRL Read
 
signal NextPRDATA         : std_logic_vector(15 downto 0);
-- D-input of iPRDATA

signal WrEn               : std_logic;
-- Write enable signal common to all addresses in the APB interface

signal RdEn               : std_logic;
-- Read enable signal common to all addresses in the APB interface

signal SCITrDMArd         : std_logic;
-- SCITrDMA read

signal SCITrDMA           : std_logic_vector(5 downto 0);
-- DMA register concatenation of bits

signal SCIINTERRUPTS      : std_logic_vector(15 downto 0);
-- Interrupts register concatenation of bits

signal TrFIFOSTATUS       : std_logic_vector(5 downto 0);
-- DMA register concatenation of bits


--------------------------------------------------------------------------------
--
-- Main body of  code
-- ==================
--
--------------------------------------------------------------------------------

begin

--------------------------------------------------------------------------------
-- Write Interface
-- Save power by preventing change in internal data bus and
-- address bus when the device is not selected
--------------------------------------------------------------------------------

PWDATAIn          <= PWDATA   when ((PSELT =  '1') and (PWRITE = '1'))
                  else
                  "0000000000000000";

GatedPADDR        <= PADDR    when (PSELT = '1')
                  else
                  "000000";

WrEn              <= PENABLE and PSELT and PWRITE;

   
-- Write enable for registers 
 
SCITrDATAWrEn     <= '1'      when ((WrEn = '1') and 
                                    (GatedPADDR = PADDR_SCITrDATA))
                  else
                     '0';

SCITrCRWrEn       <= '1'      when ((WrEn = '1') and 
                                    (GatedPADDR = PADDR_SCITrCR))
                  else
                     '0';

SCITrFiLCRWrEn    <= '1'      when ((WrEn = '1') and 
                                    (GatedPADDR = PADDR_SCITrFiLCR))
                  else
                     '0';

SCITrTXPCWrEn     <= '1'      when ((WrEn = '1') and 
                                    (GatedPADDR = PADDR_SCITrTXPC))
                  else
                     '0';

SCITrRXPCWrEn     <= '1'      when ((WrEn = '1') and 
                                    (GatedPADDR = PADDR_SCITrRXPC))
                  else
                     '0';

SCITrCTRLWrEn     <= '1'      when ((WrEn = '1') and 
                                    (GatedPADDR = PADDR_SCITrCTRL))
                  else
                     '0';

SCITrATWrEn       <= '1'     when ((WrEn = '1') and 
                                   (GatedPADDR = PADDR_SCITrAT))
                  else
                     '0';

SCITrDTWrEn       <= '1'     when ((WrEn = '1') and 
                                   (GatedPADDR = PADDR_SCITrDT))
                  else
                     '0';

SCITrTXBLKGWrEn   <= '1'     when ((WrEn = '1') and 
                                   (GatedPADDR = PADDR_SCITrTXBG))
                  else
                     '0';

SCITrTXCHGWrEn    <= '1'     when ((WrEn = '1') and 
                                   (GatedPADDR = PADDR_SCITrTXCHG))
                  else
                     '0';

SCITrCKICCWrEn    <= '1'     when ((WrEn = '1') and 
                                   (GatedPADDR = PADDR_SCITrCKICC))
                  else
                     '0';

SCITrBAUDWrEn     <= '1'     when ((WrEn = '1') and 
                                   (GatedPADDR = PADDR_SCITrBAUD))
                  else
                     '0';

SCITrVALUEWrEn    <= '1'     when ((WrEn = '1') and 
                                   (GatedPADDR = PADDR_SCITrVALUE))
                  else
                     '0';

SCITrRXCHGWrEn    <= '1'     when ((WrEn = '1') and 
                                   (GatedPADDR = PADDR_SCITrRXCHG))
                  else
                     '0';

SCITrRXBLKGWrEn   <= '1'     when ((WrEn = '1') and 
                                   (GatedPADDR = PADDR_SCITrRXBG))
                  else
                     '0';

SCITrRFCKWrEn     <= '1'     when ((WrEn = '1') and
                                   (GatedPADDR = PADDR_SCITrRFCK))
                  else 
                     '0';

SCITrWVWrEn       <= '1'     when ((WrEn = '1') and
                                   (GatedPADDR = PADDR_SCITrWV))
                  else 
                     '0';

SCITrJitWrEn      <= '1'     when ((WrEn = '1') and
                                   (GatedPADDR = PADDR_SCITrJit))
                  else 
                     '0';

SCITrJitPatWrEn   <= '1'     when ((WrEn = '1') and
                                   (GatedPADDR = PADDR_SCITrJitPt))
                  else 
                     '0';

SCITrRFCNTLWrEn   <= '1'     when ((WrEn = '1') and
                                   (GatedPADDR = PADDR_RFCNTL))
                  else 
                     '0';

SCITrDMAWr        <= '1'     when ((WrEn = '1') and
                                   (GatedPADDR = PADDR_SCITrDMA))
                  else 
                     '0';

--------------------------------------------------------------------------------
-- Read interface
--------------------------------------------------------------------------------

RdEn              <= PSELT and (not PENABLE) and (not PWRITE);
-- Read enable for registers 
 
SCITrDATArd       <= '1'     when ((RdEn = '1') and 
                                   (GatedPADDR = PADDR_SCITrDATA))
                  else
                     '0';

SCITrCRrd         <= '1'     when ((RdEn = '1') and 
                                   (GatedPADDR = PADDR_SCITrCR))
                  else
                     '0';

SCITrFiLCRrd      <= '1'     when ((RdEn = '1') and 
                                   (GatedPADDR = PADDR_SCITrFiLCR))
                  else
                     '0';

SCITrSR0rd        <= '1'     when ((RdEn = '1') and 
                                   (GatedPADDR = PADDR_SCITrSR0))
                  else
                     '0';

SCITrSR1rd        <= '1'     when ((RdEn = '1') and 
                                   (GatedPADDR = PADDR_SCITrSR1))
                  else
                     '0';

SCITrSR2rd        <= '1'     when ((RdEn = '1') and 
                                   (GatedPADDR = PADDR_SCITrSR2))
                  else
                     '0';

SCITrTXPCrd       <= '1'     when ((RdEn = '1') and 
                                   (GatedPADDR = PADDR_SCITrTXPC))
                  else
                    '0';

SCITrRXPCrd       <= '1'     when ((RdEn = '1') and 
                                   (GatedPADDR = PADDR_SCITrRXPC))
                  else
                    '0';

SCITrCTRLrd       <= '1'     when ((RdEn = '1') and 
                                   (GatedPADDR = PADDR_SCITrCTRL))
                  else
                     '0';

SCITrATrd         <= '1'     when ((RdEn = '1') and 
                                   (GatedPADDR = PADDR_SCITrAT))
                  else
                     '0';

SCITrDTrd         <= '1'     when ((RdEn = '1') and 
                                   (GatedPADDR = PADDR_SCITrDT))
                  else
                     '0';

SCITrTXBLKGrd     <= '1'     when ((RdEn = '1') and 
                                   (GatedPADDR = PADDR_SCITrTXBG))
                  else
                     '0';

SCITrTXCHGrd      <= '1'     when ((RdEn = '1') and 
                                   (GatedPADDR = PADDR_SCITrTXCHG))
                  else
                     '0';

SCITrCKICCrd      <= '1'     when ((RdEn = '1') and 
                                   (GatedPADDR = PADDR_SCITrCKICC))
                  else
                     '0';

SCITrBAUDrd       <= '1'     when ((RdEn = '1') and 
                                   (GatedPADDR = PADDR_SCITrBAUD))
                  else
                     '0';

SCITrVALUErd      <= '1'     when ((RdEn = '1') and 
                                   (GatedPADDR = PADDR_SCITrVALUE))
                  else
                     '0';

SCITrRXCHGrd      <= '1'     when ((RdEn = '1') and 
                                   (GatedPADDR = PADDR_SCITrRXCHG))
                  else
                     '0';

SCITrRXBLKGrd     <= '1'     when ((RdEn = '1') and 
                                   (GatedPADDR = PADDR_SCITrRXBG))
                  else
                     '0';

SCITrRFCKrd       <= '1'     when ((RdEn = '1') and 
                                   (GatedPADDR = PADDR_SCITrRFCK))
                  else
                     '0';

SCITrWVrd         <= '1'     when ((RdEn = '1') and 
                                   (GatedPADDR = PADDR_SCITrWV))
                  else
                     '0';

SCITrJitrd        <= '1'     when ((RdEn = '1') and 
                                   (GatedPADDR = PADDR_SCITrJit))
                  else
                     '0';

SCITrJitPatrd     <= '1'     when ((RdEn = '1') and 
                                   (GatedPADDR = PADDR_SCITrJitPt))
                  else
                     '0';

SCITrRFCNTLrd     <= '1'     when ((RdEn = '1') and 
                                   (GatedPADDR = PADDR_RFCNTL))
                  else
                     '0';

SCITrDMArd        <= '1'     when ((RdEn = '1') and 
                                   (GatedPADDR = PADDR_SCITrDMA))
                  else
                     '0';

--------------------------------------------------------------------------------
-- Increment the Read pointer in the RX FIFO after every read from
-- the SCIDATA register i.e.  after every read from the Receive FIFO
--------------------------------------------------------------------------------

RxFRdPtrInc       <= '1' when ((PSELT = '1') and (PENABLE = '1') and
                               (PWRITE = '0') and
                               (GatedPADDR = PADDR_SCITrDATA))
                  else
                     '0';

-- -----------------------------------------------------------------------------
-- Assign individual DMA status bits  to SCITrDMA  
-- -----------------------------------------------------------------------------

SCITrDMA             <=  SCITXDMASREQ & SCITXDMABREQ &
                         SCIRXDMASREQ & SCIRXDMABREQ & "00";

SCIINTERRUPTS        <=  SCICLKACTINTR   & SCICLKSTPINTR  & SCIRORINTR      &
                         SCICARDININTR   & SCICARDOUTINTR & SCICARDUPINTR   & 
                         SCICARDDNINTR   & SCITXERRINTR   & SCIATRSTOUTINTR &
                         SCIATRDTOUTINTR & SCIBLKTOUTINTR & SCICHTOUTINTR   &
                         SCITXTIDEINTR   & SCIRXTIDEINTR  & SCIRTOUTINTR    &
                         SCIINTR;

TrFIFOSTATUS         <=  SCITrRFF & SCITrRFE & SCITrRFR & 
                         SCITrTFF & SCITrTFE  & SCITrTFR;
-- Output Mux
NextPRDATA   <= "0000000"    & RXFRdData        when (SCITrDATArd = '1')
             else            
                SCITrCR                         when (SCITrCRrd   = '1')      
             else
                "00000000"   & SCITrFiLCR       when (SCITrCRrd   = '1')      
             else
                "0000000000" & TrFIFOSTATUS  
                                                when (SCITrSR0rd   = '1')      
             else
                SCIINTERRUPTS
                                                when (SCITrSR1rd   = '1')      
             else
                "000000000000000" & SCIDEACACK 
                                                when (SCITrSR2rd   = '1')      
             else
                "000000000000" & SCITrTXPC      when (SCITrTXPCrd = '1')   
             else
                "000000000000" & SCITrRXPC      when (SCITrRXPCrd = '1')      
             else
                "00000000"     & SCITrCTRL      when (SCITrCTRLrd = '1')    
             else
                SCITrAT                         when (SCITrATrd = '1')
             else
                SCITrDT                         when (SCITrDTrd = '1')
             else
                "00000000"     & SCITrTXBLKG    when (SCITrTXBLKGrd = '1')
             else
                "00000000"     & SCITrTXCHG     when (SCITrTXCHGrd = '1')
             else
                SCITrCKICC                      when (SCITrCKICCrd = '1')
             else
                SCITrBAUD                       when (SCITrBAUDrd = '1')
             else
                "00000000"     & SCITrVALUE     when (SCITrVALUErd  = '1')
             else
                "00000000"     & SCITrRXCHG     when (SCITrRXCHGrd = '1')
             else
                "00000000"     & SCITrRXBLKG    when (SCITrRXBLKGrd = '1')
             else
                 SCITrRFCK                      when (SCITrRFCKrd = '1')
             else
                "00000000"     & SCITrWV        when (SCITrWVrd = '1')
             else
                 SCITrJit                       when (SCITrJitrd = '1')
             else
                "000000"       & SCITrJitPat    when (SCITrJitPatrd = '1')
             else
                "00000000000000"
                               & PCLKOn & REFCLKOn 
                                                when (SCITrRFCNTLrd = '1')
             else
                "0000000000"   & SCITrDMA       when (SCITrDMArd = '1')
             else
                "0000000000000000" ; 

--------------------------------------------------------------------------------
-- When the peripheral is not being accessed, '0's are driven
-- on the Read Databus (PRDATA) so as not to place any restrictions
-- on the method of external bus connection. The external data buses of the
-- peripherals on the APB may then be connected to the ASB-to-APB bridge using
-- Muxed or ORed bus connection method.
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Output register . This register is not reset by the TESTRST bit in the
-- SCITCR register. If it were, it would not be possible to read the internal
-- registers with the TESTRST bit set.
--------------------------------------------------------------------------------
p_RdSeq : process (PCLK, PRESETn)
begin
  if (PRESETn = '0') then
    PRDATA  <= "0000000000000000";
  elsif (PCLK'event and PCLK = '1') then
    PRDATA  <= NextPRDATA;
  end if;
end process p_RdSeq;

end synth;

--====================================  End  =================================--



























































