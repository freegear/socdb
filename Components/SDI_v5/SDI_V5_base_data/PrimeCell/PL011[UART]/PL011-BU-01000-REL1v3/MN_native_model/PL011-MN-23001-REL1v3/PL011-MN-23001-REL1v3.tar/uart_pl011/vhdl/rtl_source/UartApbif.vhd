--  ----------------------------------------------------------------------------
--  This confidential and proprietary software may be used only as
--  authorised by a licensing agreement from ARM Limited
--    (C) COPYRIGHT 1999-2000 ARM Limited
--        ALL RIGHTS RESERVED
--  The entire notice above must be reproduced on all authorised
--  copies and copies may only be made to the extent permitted
--  by a licensing agreement from ARM Limited.
--  ----------------------------------------------------------------------------
--  
--  Version and Release Control Information:
--  
--  File Name              : UartApbif.vhd.rca
--  File Revision          : 1.17
--  
--  Release Information    : PrimeCell(TM)-PL011-REL1v3
--  
--  ----------------------------------------------------------------------------
--  
--  
--  
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

entity UartApbif is
  port (
        PCLK            : in  std_logic;      -- APB Bus clock     
        PRESETn         : in  std_logic;      -- AMBA Reset
        
        PSEL            : in  std_logic;      -- APB Peripheral select
        PWRITE          : in  std_logic;      -- APB Write
        PENABLE         : in  std_logic;      -- APB Peripheral enable
        PADDR           : in  std_logic_vector(11 downto 2);  -- APB Addr bus
        PWDATA          : in  std_logic_vector(15 downto 0);  -- Wr databus
        
        RXFF            : in  std_logic;      -- RX FIFO Full
        TXFF            : in  std_logic;      -- TX FIFO Full
        RXFE            : in  std_logic;      -- RX FIFO Empty
        TXFE            : in  std_logic;      -- TX FIFO Empty
        BUSY            : in  std_logic;      -- UART Busy

        UARTTXRIS       : in  std_logic;      -- Transmit Raw Interrupt
        UARTTXMIS       : in  std_logic;      -- Transmit Masked Interrupt
        UARTRXRIS       : in  std_logic;      -- Receive Raw Interrupt
        UARTRXMIS       : in  std_logic;      -- Receive Masked Interrupt
        UARTOERIS       : in  std_logic;      -- Overrun error Raw Interrupt
        UARTOEMIS       : in  std_logic;      -- Overrun error Masked Interrupt
        UARTRTRIS       : in  std_logic;      -- Receive Timeout interrupt
        UARTRISmodSync  : in  std_logic_vector(3 downto 0);
                                              -- Raw  modem status
        UARTRISerrSync  : in  std_logic_vector(2 downto 0);
                                              -- Raw error interupts
        UARTMISerrSync  : in  std_logic_vector(2 downto 0);
                                              -- MAsked error interupts
        UARTMISmodSync  : in  std_logic_vector(3 downto 0);
                                              -- Masked modem status

        SIRIN           : in  std_logic;      -- SIR serial input
        UARTRXD         : in  std_logic;      -- Receive serial input

        RXFRdData       : in  std_logic_vector(11 downto 0);
                                              -- RX data
        TXFIFOData      : in  std_logic_vector(7 downto 0);
                                              -- TX data    
        RXSTATUS        : in  std_logic_vector(2 downto 0);
                                              -- RX status
        Revision        : in  std_logic_vector(3 downto 0);
                                              -- Revision number
        OverrunDet      : in  std_logic;      -- Overrun detected       
        TESTFIFO        : in  std_logic;      --  Test signal

        UARTLCRH        : in  std_logic_vector(7 downto 0);
                                              -- LCRH       
        UARTLCRM        : in  std_logic_vector(7 downto 0);
                                              -- LCRM
        UARTLCRL        : in  std_logic_vector(7 downto 0);
                                              -- LCRL
        UARTFBRD        : in  std_logic_vector(5 downto 0);
                                              -- FBRD
        UARTCR          : in  std_logic_vector(15 downto 0);
                                              -- CR
        UARTILPR        : in  std_logic_vector(7 downto 0);
                                              -- ILPR
        UARTTCR         : in  std_logic_vector(2 downto 0);
                                              -- TCR
        UARTIFLS        : in  std_logic_vector(5 downto 0);
                                              -- IFLS
        UARTIMSC        : in  std_logic_vector(10 downto 0);
                                              -- IMSC
        UARTDMACR       : in  std_logic_vector(2 downto 0);
                                              -- DMA
        UARTITOP        : in  std_logic_vector(5 downto 0);
                                              -- Primary o/p for int test
        nDCDSyncPCLK    : in  std_logic;      -- Sync'ed DCD
        nDSRSyncPCLK    : in  std_logic;      -- Sync'ed DSR
        nCTSSyncPCLK    : in  std_logic;      -- Sync'ed CTS
        nRISyncPCLK     : in  std_logic;      -- Sync'ed RI
        nUARTDCD        : in  std_logic;      -- Modem DCD
        nUARTDSR        : in  std_logic;      -- Modem DSR
        nUARTCTS        : in  std_logic;      -- Modem CTS
        nUARTRI	        : in  std_logic;      -- Modem RI
        
        UARTTXDMACLR    : in  std_logic;      -- Transmit DMACLR
        UARTRXDMACLR    : in  std_logic;      -- Transmit DMACLR
        
        IntTXDMASREQ    : in  std_logic;      -- Transmit DMA single request
        IntTXDMABREQ    : in  std_logic;      -- Transmit DMA single request
        IntRXDMASREQ    : in  std_logic;      -- Receive DMA single request
        IntRXDMABREQ    : in  std_logic;      -- Receive DMA burst request 
        IntMSINTR       : in  std_logic;      -- Modem interrupt for int test
        IntUARTRXMIS    : in  std_logic;      -- Rx Interrupt for int test
        IntUARTTXMIS    : in  std_logic;      -- Tx Interrupt for int test
        IntUARTRTRIS    : in  std_logic;      -- RT Interrupt for int test
        IntUARTEINTR    : in  std_logic;      -- Error interrupt for int test
        IntUARTINTR     : in  std_logic;      -- Uart interrupt for int test
        
        UARTDRWrEn      : out std_logic;      -- FIFO Write Enable
        UARTECRWrEn     : out std_logic;      -- Write Enable for ECR
        UARTLCRHnewWrEn : out std_logic;      -- Write Enable for LCRH_new     
        PWDATAIn        : out std_logic_vector(15 downto 0);
                                              -- Int PWDATA
        PRDATA          : out std_logic_vector(15 downto 0);
                                              -- Read databus
        
        UARTREINTR      : out std_logic;      -- Combined Raw Error interrupt
        RXFRdPtrInc     : out std_logic;      -- RX FIFO read
        
        UARTCRnewWrEn   : out std_logic;      -- Write Enable for UARTCR_new
        UARTICRWrEn     : out std_logic;      -- Write Enable for ICR
        UARTILPRWrEn    : out std_logic;      -- Write Enable for ILPR
        UARTTDRWrEn     : out std_logic;      -- Write Enable for TDR
        UARTIBRDWrEn    : out std_logic;      -- Write Enable for IBRD
        UARTFBRDWrEn    : out std_logic;      -- Write Enable for FBRD
        UARTIFLSWrEn    : out std_logic;      -- Write Enable for IFLS
        UARTIMSCWrEn    : out std_logic;      -- Write Enable for IMSC
        UARTDMACRWrEn   : out std_logic;      -- Write Enable for DMA
        UARTTDRrd       : out std_logic;      -- Test data register read
        UARTTCRWrEn     : out std_logic;      -- Write Enable for TCR
        UARTITIPWrEn    : out std_logic;      -- Write Enable for UARTITIP
        UARTITOPWrEn    : out std_logic       -- Write Enable for UARTITOP
        );
end UartApbif;
--------------------------------------------------------------------------------
-- Purpose     : This block generates decodes for Register accesses
--------------------------------------------------------------------------------
--
--------------------------------------------------------------------------------
--
--                   UartApbif
--                   =========
--
--------------------------------------------------------------------------------
--
-- Overview
-- ========
-- This module decodes APB accesses and generates the read/write 
-- strobes to the appropriate registers.

--
--------------------------------------------------------------------------------
--                    Uart Register Map
--------------------------------------------------------------------------------
-- Offset Read (Width)         Write (Width)          Description
--------------------------------------------------------------------------------
-- 0x00   UARTDR (12bit)       UARTDR (8-bit)         UART Data register
-- 0x04   UARTRSR(4bit)        UARTECR                Receive Status (Rd)
--                                                    Error Clr (Wr)
-- 0x08   UARTLCR_H(7bit)      UARTLCR_H(7bit)        Line Control register, High byte
-- 0x0C   UARTLCR_M(8bit)      UARTLCR_M(8bit)        Line Control register, Middle byte
-- 0x10   UARTLCR_L(8bit)      UARTLCR_L(8bit)        Line Control register, Low byte
-- 0x14   UARTCR (16bit)       UARTCR (16bit)         UART Control Register
-- 0x18   UARTFR (9bit)        -                      UART Flag register
-- 0x1C   RESERVED
--                                                    Interrupt Clear register (Write)
-- 0x20   UARTILPR(8bit)       UARTILPR(8bit)         UART low power counter register
-- 0x24   UARTIBRD(16bit)      UARTBRD(16bit)         Integer Baud Rate Divisor Register
-- 0x28   UARTFBRD(6bit)       UARTFBRD(6bit)         Fractional Baud Rate Divisor  Register
-- 0x2C   UARTLCR_H_new(12bit) UARTLCR_H_new(12bit)   Line Control register, High byte
-- 0x30   UARTCR_new(16bit)    UARTCR_new(16bit)      Control register(new)
-- 0x34   UARTIFLS(6 bit)      UARTIFLS(6 bit)        Interrupt fifo level select register
-- 0x38   UARTIMSC(11bit)      UARTIMSC(11bit)        Interrupt Mask Set/Clear
-- 0x3C   UARTRIS(11bit)       -                      Raw Interrupt Status
-- 0x40   UARTMIS(11bit)       -                      Masked Interrupt Status
-- 0x44     -                  UARTICR(11bit)         Interrupt Clear Register
-- 0x48   UARTDMACR(3bit)      UARTDMACR(3bit)        DMA Control Register

--------------------------------------------------------------------------------
--                Uart Test Register Map
--------------------------------------------------------------------------------
-- Offset Read (Width)         Write (Width)          Description
--------------------------------------------------------------------------------
-- 0x80   UARTTCR(3bit)        UARTTCR (3bit)         Test control register
-- 0x84   UARTITIP(8bit)       UARTITIP (8bit)        Integration Test input register
-- 0x88   UARTITOP(14bit)      UARTITOP (14bit)       Integration Test output register
-- 0x8C   UARTTDR(11bit)       UARTTDR(11bit)         Test data register

---------------------------------------------------------------------
-- Identification Registers
---------------------------------------------------------------------
-- 0xFE0  UARTPeriphID0(8 bits)                       PID0 register
-- 0xFE4  UARTPeriphID1(8 bits)                       PID1 register
-- 0xFE8  UARTPeriphID2(8 bits)                       PID2 register
-- 0xFEC  UARTPeriphID3(8 bits)                       PID3 register
-- 0xFF0  UARTPCellID0(8 bits)                        PCID0 register
-- 0xFF4  UARTPCellID1(8 bits)                        PCID1 register
-- 0xFF8  UARTPCellID2(8 bits)                        PCID2 register
-- 0xFFC  UARTPCellID3(8 bits)                        PCID3 register



--------------------------------------------------------------------------------
--
--=============================== ARCHITECTURE ===============================--
--
--------------------------------------------------------------------------------
-- Architecture Packages
--------------------------------------------------------------------------------

architecture synth of UartApbif  is

--------------------------------------------------------------------------------
-- Component Declaration
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Internal Constants
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Normal mode registers address constants.Address decode is for
-- bits 2 to 7 (6 bits)
--------------------------------------------------------------------------------
  constant PADDR_UARTDR       : std_logic_vector(11 downto 2)  := "0000000000";
  -- UARTDR at offset 0x00

  constant PADDR_UARTRSR      : std_logic_vector(11 downto 2)  := "0000000001";
  -- UARTRSR at offset 0x04

  constant PADDR_UARTECR      : std_logic_vector(11 downto 2)  := "0000000001";
  -- UARTECR at offset 0x04

  constant PADDR_UARTLCRM     : std_logic_vector(11 downto 2)  := "0000000011";
  -- UARTLCRM at offset 0x0C

  constant PADDR_UARTLCRL     : std_logic_vector(11 downto 2)  := "0000000100";
  -- UARTLCRL at offset 0x10

  constant PADDR_UARTFR       : std_logic_vector(11 downto 2)  := "0000000110";
  -- UARTFR at offset 0x18

  constant PADDR_UARTILPR     : std_logic_vector(11 downto 2)  := "0000001000";
  -- UARTILPR at offset 0x20
  
  constant PADDR_UARTIBRD     : std_logic_vector(11 downto 2)  := "0000001001";
  -- UARTIBRD at offset 0x24

  constant PADDR_UARTFBRD     : std_logic_vector(11 downto 2)  := "0000001010";
  -- UARTFBRD at offset 0x28

  constant PADDR_UARTLCRH_new : std_logic_vector(11 downto 2)  := "0000001011";
  -- UARTLCRH_new at offset 0x2C
  
  constant PADDR_UARTCR_new   : std_logic_vector(11 downto 2)  := "0000001100";
  -- UARTCR_new at offset 0x30
  
  constant PADDR_UARTIFLS     : std_logic_vector(11 downto 2)  := "0000001101";
  -- UARTIFLS at offset 0x34
  
  constant PADDR_UARTIMSC     : std_logic_vector(11 downto 2)  := "0000001110";
  -- UARTIMSC at offset 0x38
  
  constant PADDR_UARTRIS      : std_logic_vector(11 downto 2)   := "0000001111";
  -- UARTRIS at offset 0x3C
  
  constant PADDR_UARTMIS      : std_logic_vector(11 downto 2)   := "0000010000";
  -- UARTMIS at offset 0x40
  
  constant PADDR_UARTICR      : std_logic_vector(11 downto 2)   := "0000010001";
  -- UARTICR at offset 0x44

  constant PADDR_UARTDMACR    : std_logic_vector(11 downto 2)   := "0000010010";
  -- UARTDMACR at offset 0x48

  
--------------------------------------------------------------------------------
-- Test register's address constants 
--------------------------------------------------------------------------------
  constant PADDR_UARTTCR     : std_logic_vector(11 downto 2) := "0000100000";
  -- UARTTCR at offset 0x80

  constant PADDR_UARTITIP     : std_logic_vector(11 downto 2) := "0000100001";
  -- UARTITIP at offset 0x84

  constant PADDR_UARTITOP     : std_logic_vector(11 downto 2) := "0000100010";
  -- UARTITOP at offset 0x88

  constant PADDR_UARTTDR      : std_logic_vector(11 downto 2) := "0000100011";
  -- UARTTDR at offset 0x8C

  constant PADDR_PERIPHID0    : std_logic_vector(11 downto 2) := "1111111000";
  -- PERIPHERALID0 at offset 0xFE0
  
  constant PADDR_PERIPHID1    : std_logic_vector(11 downto 2) := "1111111001";
  -- PERIPHERALID1 at offset 0xFE4
  
  constant PADDR_PERIPHID2    : std_logic_vector(11 downto 2) := "1111111010";
  -- PERIPHERALID2 at offset 0xFE8
  
  constant PADDR_PERIPHID3    : std_logic_vector(11 downto 2) := "1111111011";
  -- PERIPHERALID3 at offset 0xFEC
  
  constant PADDR_PRIMECELLID0 : std_logic_vector(11 downto 2) := "1111111100";
  -- PRIMECELLID0 at offset 0xFF0
  
  constant PADDR_PRIMECELLID1 : std_logic_vector(11 downto 2) := "1111111101";
  -- PRIMECELLID1 at offset 0xFF4
  
  constant PADDR_PRIMECELLID2 : std_logic_vector(11 downto 2) := "1111111110";
  -- PRIMECELLID2 at offset 0xFF8
  
  constant PADDR_PRIMECELLID3 : std_logic_vector(11 downto 2) := "1111111111";
  -- PRIMECELLID3 at offset 0xFFC
  
--------------------------------------------------------------------------------
-- Internal Signals
--------------------------------------------------------------------------------
  signal GatedPADDR     : std_logic_vector(11 downto 2); 
  -- Save power by gating PADDR internally with PSEL

--------------------------------------------------------------------------------
-- Read Decodes for Register reads
--------------------------------------------------------------------------------
  signal UARTDRrd       : std_logic;
  -- UARTDR Read

  signal UARTRSRrd      : std_logic;
  -- UARTSR Read

  signal UARTLCRHnewrd  : std_logic;
  -- LCRH_new Read

  signal UARTCRnewrd    : std_logic;
  -- UARTCR_new Read

  signal UARTFRrd       : std_logic;
  -- UARTFR Read
  
  signal UARTILPRrd     : std_logic;
  -- ILPR Read

  signal UARTIBRDrd     : std_logic;
  -- UARTIBRD Read 

  signal UARTFBRDrd     : std_logic;
  -- UARTFBRD Read 

  signal UARTTCRrd      : std_logic;
  -- TCR Read

  signal UARTITIPrd     : std_logic;
  -- UARTITIP Read
  
  signal UARTITOPrd     : std_logic;
  -- UARTITOP Read
  
  signal UARTIFLSrd     : std_logic;
  -- IFLS Read
  
  signal UARTIMSCrd     : std_logic;
  -- IMSC Read

  signal UARTRISrd      : std_logic;
  -- RIS Read
  
  signal UARTMISrd      : std_logic;
  -- MIS Read
  
  signal UARTDMACRrd    : std_logic;
  -- DMA Read
  
  signal iUARTTDRrd     : std_logic;
  -- TDR Read

  signal PERIPHID0rd    : std_logic;
  -- PeripheralID0 read

  signal PERIPHID1rd    : std_logic;
  -- PeripheralID1 read

  signal PERIPHID2rd    : std_logic;
  -- PeripheralID2 read

  signal PERIPHID3rd    : std_logic;
  -- PeripheralID3 read

  signal PRIMECELLID0rd : std_logic;
  -- PrimeCellID0 read

  signal PRIMECELLID1rd : std_logic;
  -- PrimeCellID1 read

  signal PRIMECELLID2rd : std_logic;
  -- PrimeCellID2 read

  signal PRIMECELLID3rd : std_logic;
  -- PrimeCellID3 read

  signal NextPRDATA     : std_logic_vector(15 downto 0);    
  -- D-input of iPRDATA
  
  signal NextUARTREINTR : std_logic;
  -- D-input of UARTREINTR
  
  signal UARTRSR        : std_logic_vector(3 downto 0);
  -- RSR concatenation of bits

  signal UARTFR         : std_logic_vector(8 downto 0);
  -- Flag register concatenation of bits
  
  signal UARTRIS        : std_logic_vector(10 downto 0);
  -- Raw interrupt status register concatenation of modem bits
  
  signal UARTMIS        : std_logic_vector(10 downto 0);
  -- Masked interrupt status register concatenation of bits
  
  signal IntraIP        : std_logic_vector(1 downto 0);
  -- Intra chip input

  signal PrimaryIP      : std_logic_vector(5 downto 0);
  -- Primary Input

  signal IntraOP        : std_logic_vector(9 downto 0);
  -- Intra chip Output

  signal PrimaryOP      : std_logic_vector(5 downto 0);
  -- Primary Output
  
  signal WrEn           : std_logic;
  -- Write enable signal common to all addresses in the APB interface

  signal RdEn           : std_logic;
  -- Read enable signal common to all addresses in the APB interface

--------------------------------------------------------------------------------
--
-- Main VHDL code
-- ==============
--
--------------------------------------------------------------------------------

begin

--------------------------------------------------------------------------------
-- Write Interface
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Save power by preventing change in internal data bus and 
-- address bus when the device is not selected
--------------------------------------------------------------------------------
  PWDATAIn        <= PWDATA   when ((PSEL =  '1') and (PWRITE = '1'))  
                     else
                     (others  => '0');
  
  GatedPADDR      <= PADDR    when (PSEL = '1') 
                     else 
                     (others => '0'); 

  WrEn            <= PENABLE and PSEL and PWRITE;

  -- UARTLCR

  UARTLCRHnewWrEn <= '1'      when ((WrEn = '1') and (GatedPADDR = PADDR_UARTLCRH_new))
                     else
                     '0';                

  -- UARTDR
  
  UARTDRWrEn      <= '1'      when ((WrEn = '1') and (GatedPADDR = PADDR_UARTDR))
                     else
                     '0';
  --UARTECR 
  
  UARTECRWrEn     <= '1'      when ((WrEn = '1') and (GatedPADDR = PADDR_UARTECR))
                     else
                     '0';
  -- UARTCR

  UARTCRnewWrEn   <= '1'      when ((WrEn = '1') and (GatedPADDR = PADDR_UARTCR_new))
                     else
                     '0';  
  -- UARTILPR

  UARTILPRWrEn    <= '1'      when ((WrEn = '1') and 
                                    (GatedPADDR = PADDR_UARTILPR))
                     else
                     '0';
  -- UARTIBRD

  UARTIBRDWrEn    <= '1'      when ((WrEn = '1') and 
                                    (GatedPADDR = PADDR_UARTIBRD))
                     else
                     '0';
  -- UARTFBRD

  UARTFBRDWrEn    <= '1'      when ((WrEn = '1') and 
                                    (GatedPADDR = PADDR_UARTFBRD))
                     else
                     '0';

  -- UARTIMSC

  UARTIMSCWrEn    <= '1'      when ((WrEn = '1') and 
                                    (GatedPADDR = PADDR_UARTIMSC))
                     else
                     '0';
  
  -- UARTICR

  UARTICRWrEn     <= '1'      when ((WrEn = '1') and 
                                    (GatedPADDR = PADDR_UARTICR))
                     else
                     '0';
  
  -- UARTDMACR

  UARTDMACRWrEn   <= '1'      when ((WrEn = '1') and 
                                    (GatedPADDR = PADDR_UARTDMACR))
                     else
                     '0';
  
  -- UARTTCR

  UARTTCRWrEn     <= '1'      when ((WrEn = '1') and (GatedPADDR = PADDR_UARTTCR))
                     else
                     '0';
  
  -- UARTITIP

  UARTITIPWrEn    <= '1'      when ((WrEn = '1') and (GatedPADDR = PADDR_UARTITIP))
                     else
                     '0';
  
  -- UARTITOP

  UARTITOPWrEn    <= '1'      when ((WrEn = '1') and (GatedPADDR = PADDR_UARTITOP))
                     else
                     '0';
  
  -- UARTTDR
  
  UARTTDRWrEn     <= '1'      when ((WrEn = '1') and (GatedPADDR = PADDR_UARTTDR))
                     else
                     '0';

  -- UARTIFLS
  
  UARTIFLSWrEn    <= '1'      when ((WrEn = '1') and (GatedPADDR = PADDR_UARTIFLS))
                     else
                     '0';
  
--------------------------------------------------------------------------------
-- Read interface
--------------------------------------------------------------------------------
  RdEn            <= PSEL and (not PWRITE); 
  
  UARTLCRHnewrd   <= '1' when ((RdEn = '1') and (GatedPADDR = PADDR_UARTLCRH_new))
                     else
                     '0';                

  UARTDRrd        <= '1' when ((RdEn = '1') and (GatedPADDR = PADDR_UARTDR))
                     else
                     '0';

  UARTRSRrd       <= '1' when ((RdEn = '1') and (GatedPADDR = PADDR_UARTRSR))
                     else
                     '0';

  UARTCRnewrd     <= '1' when ((RdEn = '1') and (GatedPADDR = PADDR_UARTCR_new))
                     else
                     '0';

  UARTFRrd        <= '1' when ((RdEn = '1') and (GatedPADDR = PADDR_UARTFR))
                     else
                     '0';

  UARTILPRrd      <= '1' when ((RdEn = '1') and (GatedPADDR = PADDR_UARTILPR))
                     else
                     '0';
  
  UARTIBRDrd      <= '1' when ((RdEn = '1') and (GatedPADDR = PADDR_UARTIBRD))
                     else
                     '0';

  UARTFBRDrd      <= '1' when ((RdEn = '1') and (GatedPADDR = PADDR_UARTFBRD))
                     else
                     '0';

  UARTIMSCrd      <= '1' when ((RdEn = '1') and (GatedPADDR = PADDR_UARTIMSC))
                     else
                     '0';
  
  UARTRISrd       <= '1' when ((RdEn = '1') and (GatedPADDR = PADDR_UARTRIS))
                     else
                     '0';
  
  UARTMISrd       <= '1' when ((RdEn = '1') and (GatedPADDR = PADDR_UARTMIS))
                     else
                     '0';
  
  UARTDMACRrd     <= '1' when ((RdEn = '1') and (GatedPADDR = PADDR_UARTDMACR))
                     else
                     '0';
  
  UARTTCRrd       <= '1' when ((RdEn = '1') and (GatedPADDR = PADDR_UARTTCR))
                     else
                     '0';

  UARTITIPrd      <= '1' when ((RdEn = '1') and (GatedPADDR = PADDR_UARTITIP))
                     else
                     '0';

  UARTITOPrd      <= '1' when ((RdEn = '1') and (GatedPADDR = PADDR_UARTITOP))
                     else
                     '0';
  
  UARTIFLSrd      <= '1' when ((RdEn = '1') and (GatedPADDR = PADDR_UARTIFLS))
                     else
                     '0';
  
  iUARTTDRrd      <= '1' when ((RdEn = '1') and (GatedPADDR = PADDR_UARTTDR))
                     else
                     '0';

  PERIPHID0rd     <= '1' when ((RdEn = '1') and (GatedPADDR = PADDR_PERIPHID0))
                     else
                     '0';

  PERIPHID1rd     <= '1' when ((RdEn = '1') and (GatedPADDR = PADDR_PERIPHID1))
                     else
                     '0';

  PERIPHID2rd     <= '1' when ((RdEn = '1') and (GatedPADDR = PADDR_PERIPHID2))
                     else
                     '0';

  PERIPHID3rd     <= '1' when ((RdEn = '1') and (GatedPADDR = PADDR_PERIPHID3))
                     else
                     '0';

  PRIMECELLID0rd  <= '1' when ((RdEn = '1') and (GatedPADDR = PADDR_PRIMECELLID0))
                     else
                     '0';

  PRIMECELLID1rd  <= '1' when ((RdEn = '1') and (GatedPADDR = PADDR_PRIMECELLID1))
                     else
                     '0';

  PRIMECELLID2rd  <= '1' when ((RdEn = '1') and (GatedPADDR = PADDR_PRIMECELLID2))
                     else
                     '0';

  PRIMECELLID3rd  <= '1' when ((RdEn = '1') and (GatedPADDR = PADDR_PRIMECELLID3))
                     else
                     '0';
  
  UARTRSR         <= OverrunDet & RXSTATUS; 

  UARTFR          <= (not nRISyncPCLK) & TXFE & RXFF & TXFF & RXFE & BUSY
                     & (not nDCDSyncPCLK) & (not nDSRSyncPCLK)
                     & (not nCTSSyncPCLK); 
  
  
  UARTRIS         <=  UARTOERIS & UARTRISerrSync & UARTRTRIS & UARTTXRIS & UARTRXRIS &
                      UARTRISmodSync;
  
  
  -- The Receive timeout masked and raw interrupts are the same
  
  UARTMIS         <=  UARTOEMIS &  UARTMISerrSync & UARTRTRIS & UARTTXMIS & UARTRXMIS &
                      UARTMISmodSync;
  
  PrimaryIP       <= nUARTRI & nUARTDCD & nUARTCTS & nUARTDSR &
                     SIRIN & UARTRXD;

  PrimaryOP       <= UARTITOP(5 downto 0);
  
  IntraIP         <= UARTTXDMACLR & UARTRXDMACLR;

  IntraOP         <= IntTXDMASREQ & IntTXDMABREQ & IntRXDMASREQ &
                     IntRXDMABREQ & IntMSINTR & IntUARTRXMIS &
                     IntUARTTXMIS & IntUARTRTRIS & IntUARTEINTR &
                     IntUARTINTR;   
  
  
--------------------------------------------------------------------------------
-- Increment the Read pointer in the RX FIFO after every read from
-- the UARTDR register i.e.  after every read from the Receive FIFO
--------------------------------------------------------------------------------
  RXFRdPtrInc     <= PENABLE and UARTDRrd;


-- Output Mux     
  NextPRDATA <=  "0000" & RXFRdData                when (UARTDRrd = '1') 
                 else 
                 "000000000000" & UARTRSR          when (UARTRSRrd = '1') 
                 else 
                 "00000000" & UARTLCRH             when (UARTLCRHnewrd = '1') 
                 else
                 UARTCR                            when (UARTCRnewrd = '1')            
                 else
                 "0000000" & UARTFR                when (UARTFRrd = '1')
                 else
                 "00000000" & UARTILPR             when (UARTILPRrd = '1')
                 else
                 UARTLCRM &  UARTLCRL              when (UARTIBRDrd = '1')
                 else
                 "0000000000" & UARTFBRD           when (UARTFBRDrd = '1')
                 else
                 "00000" & UARTIMSC                when (UARTIMSCrd = '1')
                 else
                 "00000" & UARTRIS                 when (UARTRISrd = '1')
                 else
                 "00000" & UARTMIS                 when (UARTMISrd = '1')
                 else
                 "0000000000000" & UARTDMACR       when (UARTDMACRrd = '1')
                 else
                 "0000000000000" & UARTTCR         when (UARTTCRrd = '1') 
                 else
                 "00000000" & IntraIP & PrimaryIP  when (UARTITIPrd = '1') 
                 else
                 IntraOP & PrimaryOP               when (UARTITOPrd = '1') 
                 else
                 "00000000" & TXFIFOData           when (iUARTTDRrd = '1'
                                                         and TESTFIFO = '1')  
                 else
                 "0000000000" & UARTIFLS           when (UARTIFLSrd = '1')  
                 else
                 "00000000" & "00010001"           when (PERIPHID0rd = '1')  
                 else
                 "00000000" & "00010000"           when (PERIPHID1rd = '1')  
                 else
                 "00000000" & Revision & "0100"    when (PERIPHID2rd = '1')  
                 else
                 "00000000" & "00000000"           when (PERIPHID3rd = '1')  
                 else
                 "00000000" & "00001101"           when (PRIMECELLID0rd = '1')  
                 else
                 "00000000" & "11110000"           when (PRIMECELLID1rd = '1')  
                 else
                 "00000000" & "00000101"           when (PRIMECELLID2rd = '1')  
                 else
                 "00000000" & "10110001"           when (PRIMECELLID3rd = '1')  
                 else
                 "0000000000000000";

--------------------------------------------------------------------------------
-- When the peripheral is not being accessed, '0's are driven
-- on the Read Databus (PRDATA) so as not to place any restrictions
-- on the method of external bus connection. The external data buses of the
-- peripherals on the APB may then be connected to the ASB-to-APB bridge using
-- Muxed or ORed bus connection method.
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Output register . This register is not reset by the TESTRST bit in the
-- UARTTCR register. If it were, it would not be possible to read the internal
-- registers with the TESTRST bit set.
--------------------------------------------------------------------------------
  p_RdSeq : process (PCLK, PRESETn)
  begin
    if (PRESETn = '0') then
      PRDATA  <= (others => '0');
    elsif (PCLK'event and PCLK = '1') then
      PRDATA  <= NextPRDATA;
    end if;
  end process p_RdSeq;
  
-------------------------------------------------------------------
-- Combine all raw error interrupts to generate UARTREINTR
-------------------------------------------------------------------
  NextUARTREINTR <= UARTRISerrSync(0) or UARTRISerrSync(1) or
                    UARTRISerrSync(2) or UARTOERIS;   

  p_REIntSeq : process (PCLK, PRESETn)
  begin
    if(PRESETn = '0') then
      UARTREINTR <= '0'; 
    elsif(PCLK'event and PCLK = '1') then
      UARTREINTR <= NextUARTREINTR;
    end if;
  end process p_REIntSeq;

  
-- Assign the local copy to external port 
  UARTTDRrd <= iUARTTDRrd ;

end synth;

--========================== End of UartApbif ================================--




