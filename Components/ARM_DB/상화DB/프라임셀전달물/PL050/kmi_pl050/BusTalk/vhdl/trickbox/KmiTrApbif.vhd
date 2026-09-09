--  ----------------------------------------------------------------------------
--  This confidential and proprietary software may be used only
--  as authorised by a licensing agreement from ARM Limited
--  (C) COPYRIGHT 1998 ARM Limited
--  ALL RIGHTS RESERVED
--  The entire notice above must be reproduced on all authorised copies
--  and copies may only be made to the extent permitted by a
--  licensing agreement from ARM Limited.
--  ----------------------------------------------------------------------------
--
--  Version and Release Control Information :
--
--
--  Filename            : KmiTrApbif.vhd,v
--
--  File Revision       : 1.1
--
--  Release Information : PL050-REL1v1
--
--  ----------------------------------------------------------------------------
-- Purpose : This block implements the APB inteface for the Keyboard Mouse 
--           Inteface TrickBox. This block generates decodes for register 
--           accesses.
--
-- ---------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

entity KmiTrApbif is
  port (
        PCLK           : in std_logic;   -- APB Bus Clock
        BnRES          : in std_logic;   -- APB Reset(Active LOW)
        PADDR          : in std_logic_vector(7 downto 2); -- Address Bus
        PWDATA         : in std_logic_vector(15 downto 0); -- Data Input Bus
        PENABLE        : in std_logic; -- Access enable
        PWRITE         : in std_logic; -- Write/Read Signal
        PSEL           : in std_logic; -- Peripheral Select
        KmiTrRXREG     : in std_logic_vector(7 downto 0); -- Received Data
        KmiTrCnREG     : in std_logic_vector(4 downto 0); -- Control Register
        KmiTrREFCLKOn  : in std_logic; -- Data Width Error    (Status Bit 6)
        KmiTrPCLKOn    : in std_logic; -- TxBusy Signal       (Status Bit 5)
        KmiTrDWIDTHERR : in std_logic; -- Data Width Error    (Status Bit 4)
        KmiTrTXBUSY    : in std_logic; -- TxBusy Signal       (Status Bit 3)
        KmiTrRXBUSY    : in std_logic; -- RxBusy Signal       (Status Bit 2)
        KmiTrFRAMEERR  : in std_logic; -- Framing Error Signal(Status Bit 1)
        KmiTrPARITYERR : in std_logic; -- Parity Error Signal (Status Bit 0)
        KmiTrCLKL      : in std_logic_vector(8 downto 0); -- Clock Low Timing
        KmiTrCLKH      : in std_logic_vector(8 downto 0); -- Clock High Timing
        KmiTrDSI       : in std_logic_vector(15 downto 0); -- DSI Tim. Param. 
        KmiTrDHI       : in std_logic_vector(15 downto 0); -- DHI Tim. Param. 
        KmiTrDSO       : in std_logic_vector(15 downto 0); -- DSO Tim. Param. 
        KmiTrDHO       : in std_logic_vector(15 downto 0); -- DHO Tim. Param. 
        KmiTrREFCLK    : in std_logic_vector(7 downto 0); -- Reference Clock
        KmiTrRG        : in std_logic_vector(15 downto 0); -- RG Tim. Param. 
        KmiTrRXFF      : in std_logic; -- Receiver Fifo Full
        KmiTrRXFE      : in std_logic; -- Receiver Fifo Empty
        KmiTrRXFH      : in std_logic; -- Receiver Fifo More Than Half Full
        KmiTrTXFF      : in std_logic; -- Transmitter Fifo Full
        KmiTrTXFE      : in std_logic; -- Transmitter Fifo Empty
        KmiTrTXFH      : in std_logic; -- Transmitter Fifo Less Than Half Full 
        KmiINTR        : in std_logic; -- Kmi Interrupt Input 
        KmiRXINTR      : in std_logic; -- Kmi Receive Interrupt Input 
        KmiTXINTR      : in std_logic; -- Kmi Transmit Interrupt Input 
        KDATAIN        : in std_logic; -- Data Line Status 
        KCLKIN         : in std_logic; -- Clock Line Status
        KmiTrTIMOUT    : in std_logic_vector(4 downto 0); -- Time Out Value
        KmiTrCLKDIV    : in std_logic_vector(7 downto 0); -- Clock Divisor 
        KmiTrMODEREG   : in std_logic_vector(3 downto 0); -- Kmi Clock/Reset 
        KmiTrDSOErr    : in std_logic; -- DSO Error Signal
        KmiTrDHOErr    : in std_logic; -- DHO Error Signal
        WrenTXREG      : out std_logic; -- Transmitter Register Write Enable
        WrenCnREG      : out std_logic; -- Control Register Write Enable
        WrenSTAT       : out std_logic; -- Status Register Write Enable
        WrenCLKL       : out std_logic; -- Clock Low Time Value Write Enable
        WrenCLKH       : out std_logic; -- Clock High Time Value Write Enable
        WrenDSI        : out std_logic; -- DSI Register Write Enable
        WrenDHI        : out std_logic; -- DHI Register Write Enable
        WrenDSO        : out std_logic; -- DSO Register Write Enable
        WrenDHO        : out std_logic; -- DHO Register Write Enable
        WrenREFCLK     : out std_logic; -- Reference Clock Value Write Enable
        WrenRG         : out std_logic; -- RG Register Write Enable 
        WrenCLKDIV     : out std_logic; -- Reference Clock Divisor Write Enable
        WrenTIMOUT     : out std_logic; -- Time Out Value Write Enable
        WrenMODEREG    : out std_logic; -- Reset/Clock Mode Write Enable
        WrenTIMESTAT   : out std_logic; -- Timing Parameter Status Write Enable
        PRDATA         : out std_logic_vector(15 downto 0); -- Data o/p Bus
        RdUpdateRx     : out std_logic; -- Shift next data in Rx FF
        PWDataIn       : out std_logic_vector(15 downto 0) -- Muxed Data
        );
end KmiTrApbif;

-- ---------------------------------------------------------------------------
--
--                           KmiTrApbif
--                           ==========
--
-- ---------------------------------------------------------------------------
--
-- Overview
-- ========
-- This module decodes the APB accesses and generates the Read/Write strobes
-- for the different registers This module also contains the output data
-- multiplexer and the output register that form the read interface. The
-- internal databus, for the TrickBox, PWDataIn[15:0], is also generated in this
-- module by gating the input data bus, PWDATA[15:0] with PSEL and PWRITE.
--
-- ---------------------------------------------------------------------------
--
-- ---------------------------------------------------------------------------
--                       TrickBox Register Map
-- ---------------------------------------------------------------------------
-- Offset     Read(Width)        Write(Width)      Description
-- ---------------------------------------------------------------------------
-- 0x00  KmiTrRXREG(8 bits)    KmiTrTXREG(8 bits)   TrickBox Data Register 
-- 0x04  KmiTrCnREG(5 bits)    KmiCnREG(5 bits)     TrickBox Control Register
-- 0x08  KmiTrSTAT(7 bits)     KmiTrSTAT(7 bits)    TrickBox Status  Register
-- 0x0C  KmiTrCLKL(9 bits)     KmiTrCLKL(9 bits)    TrickBox Low Clock Timing
-- 0x10  KmiTrCLKH(9 bits)     KmiTrCLKH(9 bits)    TrickBox High Clock Timing 
-- 0x14  KmiTrDSI(16 bits)     KmiTrDSI(16 bits)    TrickBox DSI Tim. Param.
-- 0x18  KmiTrDHI(16 bits)     KmiTrDHI(16 bits)    TrickBox DHI Tim. Param.
-- 0x1c  KmiTrDSO(16 bits)     KmiTrDSO(16 bits)    TrickBox DSO Tim. Param.
-- 0x20  KmiTrDHO(16 bits)     KmiTrDHO(16 bits)    TrickBox DHO Tim. Param.
-- 0x24  KmiTrREFCLK(8 bits)   KmiTrREFCLK(8 bits)  TrickBox REFCLK Timing 
-- 0x28  KmiTrRG(16 bits)      KmiTrRG(16 bits)     TrickBox RG Tim. Param.
-- 0x2c  KmiTrFFLAG(6 bits)    KmiTrFFLAG(6 bits)   TrickBox Fifo Flag Register
-- 0x30  KmiTrCHECKPIN(5 bits) KmiTrCHECKPIN(5 bits)TrickBox Pin Status
-- 0x34  KmiTrTIMOUT(5 bits)   KmiTrTIMOUT(5 bits)  TrickBox Timeout Value
-- 0x38  KmiTrCLKDIV(8 bits)   KmiTrCLKDIV(8 bits)  TrickBox Clock Divisor
-- 0x3c  KmiTrMODEREG(4 bits)  KmiTrMODEREG(4 bits) TrickBox Clock/Reset Value 
-- 0x40  KmiTrTIMESTAT(2 bits) KmiTrTIMESTAT(2 bits)TrickBox Timing Error Status
-- 
-- -----------------------------------------------------------------------------
--
-- ============================= ARCHITECTURE ================================--

architecture behavioural of KmiTrApbif is

-- ----------------------------------------------------------------------------
-- Constant declarations
-- ----------------------------------------------------------------------------
constant DREGADDR    : std_logic_vector(7 downto 2) := "000000"; 
-- Data Register Offset 0x00 from the Base Address

constant CNREGADDR   : std_logic_vector(7 downto 2) := "000001"; 
-- Control Register Offset 0x04 from the Base Address

constant STATREGADDR : std_logic_vector(7 downto 2) := "000010"; 
-- Status Register Offset 0x08 from the Base Address

constant CLKLADDR    : std_logic_vector(7 downto 2) := "000011"; 
-- CLKL Register Offset 0x0c from the Base Address

constant CLKHADDR    : std_logic_vector(7 downto 2) := "000100"; 
-- CLKH Register Offset 0x10 from the Base Address

constant DSIADDR     : std_logic_vector(7 downto 2) := "000101"; 
-- DSI Register Offset 0x14 from the Base Address

constant DHIADDR     : std_logic_vector(7 downto 2) := "000110"; 
-- DHI Register Offset 0x18 from the Base Address

constant DSOADDR     : std_logic_vector(7 downto 2) := "000111"; 
-- DSO Register Offset 0x1c from the Base Address

constant DHOADDR     : std_logic_vector(7 downto 2) := "001000"; 
-- DHO Register Offset 0x20 from the Base Address

constant REFCLKADDR  : std_logic_vector(7 downto 2) := "001001"; 
-- REFCLK Register Offset 0x24 from the Base Address

constant RGADDR      : std_logic_vector(7 downto 2) := "001010"; 
-- RG Register Offset 0x28 from the Base Address

constant FFLAGADDR   : std_logic_vector(7 downto 2) := "001011"; 
-- FFLAG Register Offset 0x2c from the Base Address

constant CHECKPINADDR: std_logic_vector(7 downto 2) := "001100"; 
-- CHECKPIN Register Offset 0x30 from the Base Address

constant TIMOUTADDR  : std_logic_vector(7 downto 2) := "001101"; 
-- TIMOUT Register Offset 0x34 from the Base Address

constant CLKDIVADDR  : std_logic_vector(7 downto 2) := "001110"; 
-- CLKDIV Register Offset 0x38 from the Base Address

constant MODEADDR    : std_logic_vector(7 downto 2) := "001111"; 
-- MODE Register Offset 0x3c from the Base Address

constant TIMESTATADDR: std_logic_vector(7 downto 2) := "010000"; 
-- TIMESTATUS Register Offset 0x40 from the Base Address

-- -----------------------------------------------------------------------------
-- Signal declarations
-- -----------------------------------------------------------------------------
signal GatedPADDR      : std_logic_vector(7 downto 2);
-- Gate PADDR with PSEL to save power

signal Wren            : std_logic; 
-- Write enable

signal Rden            : std_logic; 
-- Read enable

signal KmiTrSTAT       : std_logic_vector(6 downto 0); 
-- Status Register

signal KmiTrFFLAG      : std_logic_vector(5 downto 0); 
-- Flag Status Register

signal KmiTrTIMESTAT   : std_logic_vector(1 downto 0); 
-- Time Status Register

signal KmiTrCHECKPIN   : std_logic_vector(4 downto 0);
-- Kmi TrickBox CHECKPIN Register

-- -----------------------------------------------------------------------------
--
-- Main body of code
-- =================
--
-- -----------------------------------------------------------------------------
 
begin

-- -----------------------------------------------------------------------------
-- Create read vectors by concatenation
-- -----------------------------------------------------------------------------

KmiTrSTAT  <= (KmiTrREFCLKOn & KmiTrPCLKOn & KmiTrDWIDTHERR & KmiTrTXBUSY & 
               KmiTrRXBUSY & KmiTrFRAMEERR & KmiTrPARITYERR); 
                    
KmiTrFFLAG <= (KmiTrRXFF & KmiTrRXFE & KmiTrRXFH & KmiTrTXFF & KmiTrTXFE & 
               KmiTrTXFH); 
 
KmiTrTIMESTAT <= (KmiTrDSOErr & KmiTrDHOErr);
 
KmiTrCHECKPIN <= (KmiINTR & KmiRXINTR & KmiTXINTR & KDATAIN & KCLKIN); 
 
-- -----------------------------------------------------------------------------
-- Write Interface
-- -----------------------------------------------------------------------------
-- -----------------------------------------------------------------------------
-- Save power by preventing change in internal data bus and address bus when
-- the device is not selected.
-- -----------------------------------------------------------------------------
GatedPADDR   <= PADDR when (PSEL = '1') 
             else
                "000000";
    
PWDATAIN     <= PWDATA when ((PSEL = '1') and (PWRITE = '1')) 
             else 
                "0000000000000000";

Wren         <= PSEL and PENABLE and PWRITE;
   
WrenTXREG    <= '1' when ((Wren = '1') and (GatedPADDR = DREGADDR)) 
             else 
                '0';
 
WrenCnREG    <= '1' when ((Wren = '1') and (GatedPADDR = CNREGADDR)) 
             else 
                '0';
   
WrenSTAT     <= '1' when ((Wren = '1') and (GatedPADDR = STATREGADDR)) 
             else 
                '0';
  
WrenCLKL     <= '1' when ((Wren = '1') and (GatedPADDR = CLKLADDR)) 
             else 
                '0';
          
WrenCLKH     <= '1' when ((Wren = '1') and (GatedPADDR = CLKHADDR)) 
             else 
                '0';
          
WrenDSI      <= '1' when ((Wren = '1') and (GatedPADDR = DSIADDR)) 
             else 
                '0';
          
WrenDHI      <= '1' when ((Wren = '1') and (GatedPADDR = DHIADDR)) 
             else 
                '0';
         
WrenDSO      <= '1' when ((Wren = '1') and (GatedPADDR = DSOADDR)) 
             else 
                '0';
          
WrenDHO      <= '1' when ((Wren = '1') and (GatedPADDR = DHOADDR)) 
             else 
                '0';
   
WrenREFCLK   <= '1' when ((Wren = '1') and (GatedPADDR = REFCLKADDR)) 
             else 
                '0';
            
WrenRG       <= '1' when ((Wren = '1') and (GatedPADDR = RGADDR)) 
             else 
                '0';
          
WrenCLKDIV   <= '1' when ((Wren = '1') and (GatedPADDR = CLKDIVADDR)) 
             else 
                '0';

WrenTIMOUT   <= '1' when ((Wren = '1') and (GatedPADDR = TIMOUTADDR)) 
             else
                '0';

WrenMODEREG  <= '1' when ((Wren = '1') and (GatedPADDR = MODEADDR)) 
             else
                '0';
   
WrenTIMESTAT <= '1' when ((Wren = '1') and (GatedPADDR = TIMESTATADDR)) 
             else
                '0';

-- -----------------------------------------------------------------------------
-- Read Interface
-- -----------------------------------------------------------------------------
Rden       <= PSEL and not(PWRITE) and PENABLE;
 
RdUpdateRX <= '1' when ((Rden = '1') and (GatedPADDR = DREGADDR)) 
           else
              '0';

-- -----------------------------------------------------------------------------
-- Output Mux for selecting Data from different registers
-- -----------------------------------------------------------------------------
PRDATA <= ("00000000" & KmiTrRXREG)          when (Rden = '1') and 
                                              (GatedPADDR = DREGADDR)
        else
          ("00000000000" & KmiTrCnREG)       when (Rden = '1') and 
                                              (GatedPADDR = CNREGADDR)
        else
          ("000000000" & KmiTrSTAT)          when (Rden = '1') and 
                                              (GatedPADDR = STATREGADDR)
        else
          ("0000000" & KmiTrCLKL)            when (Rden = '1') and 
                                              (GatedPADDR = CLKLADDR) 
        else
          ("0000000" & KmiTrCLKH)            when (Rden = '1') and 
                                              (GatedPADDR = CLKHADDR) 
        else
          KmiTrDSI                           when (Rden = '1') and 
                                              (GatedPADDR = DSIADDR) 
        else
          KmiTrDHI                           when (Rden = '1') and 
                                              (GatedPADDR = DHIADDR) 
        else
          KmiTrDSO                           when (Rden = '1') and 
                                              (GatedPADDR = DSOADDR) 
        else
          KmiTrDHO                           when (Rden = '1') and 
                                              (GatedPADDR = DHOADDR) 
        else
          ("0000000000" & KmiTrFFLAG)        when (Rden = '1') and 
                                              (GatedPADDR = FFLAGADDR) 
        else
          KmiTrRG                            when (Rden = '1') and 
                                              (GatedPADDR = RGADDR) 
        else
          ("00000000" & KmiTrREFCLK)         when (Rden = '1') and 
                                              (GatedPADDR = REFCLKADDR) 
        else
          ("00000000000" & KmiTrTIMOUT)      when (Rden = '1') and 
                                              (GatedPADDR = TIMOUTADDR)
        else
          ("00000000" & KmiTrCLKDIV)         when (Rden = '1') and 
                                              (GatedPADDR = CLKDIVADDR) 
        else
          ("000000000000" & KmiTrMODEREG)    when (Rden = '1') and 
                                              (GatedPADDR = MODEADDR)
        else
          ("00000000000000" & KmiTrTIMESTAT) when (Rden = '1') and 
                                              (GatedPADDR = TIMESTATADDR)
        else
          ("00000000000" & KmiTrCHECKPIN)    when (Rden = '1') and 
                                              (GatedPADDR =CHECKPINADDR)
        else
          "0000000000000000" ; 
      
end behavioural;

-- ========================= End of KmiTrApbIf ==============================--
