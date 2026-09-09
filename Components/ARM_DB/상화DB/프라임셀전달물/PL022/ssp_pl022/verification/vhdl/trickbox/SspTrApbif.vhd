-- --=========================================================================--
--  This confidential and proprietary software may be used only as
--  authorised by a licensing agreement from ARM Limited
--    (C) COPYRIGHT 1999 ARM Limited
--        ALL RIGHTS RESERVED
--  The entire notice above must be reproduced on all authorised
--  copies and copies may only be made to the extent permitted
--  by a licensing agreement from ARM Limited.
--
--  ----------------------------------------------------------------------------
--  Version and Release Control Information:
--  
--  File Name              : SspTrApbif.vhd.rca
--  File Revision          : 1.1
--  
--  Release Information    : PrimeCell(TM)-PL022-REL1v2
--  
-- -----------------------------------------------------------------------------
-- Purpose      : APB Interface to generate decodes for write and read
--                accesses to SSP Trickbox internal registers.
-- -----------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

-- -----------------------------------------------------------------------------

entity SspTrApbif is
  port (
        PRESETn          : in   std_logic;  -- AMBA Bus Reset
        PCLK             : in   std_logic;  -- APB Bus Clock
        PSEL             : in   std_logic;  -- APB Peripheral select
        PWRITE           : in   std_logic;  -- APB Peripheral Write
        PENABLE          : in   std_logic;  -- APB Peripheral enable
        PADDR            : in   std_logic_vector(7 downto 2);
                                            -- APB Addr
        PWDATA           : in   std_logic_vector(15 downto 0);
                                            -- Write databus
        SSPTBPRE         : in   std_logic_vector(3 downto 0);
                                            -- PreScale Reg 
        SSPTBCR0         : in   std_logic_vector(15 downto 0);
                                            -- Cntl Reg0 
        SSPTBCR1         : in   std_logic_vector(5 downto 0);
                                            -- Cntl Reg1 
        SSPTBCR2         : in   std_logic_vector(10 downto 0);
                                            -- Cntl Reg1
        RxFRdData        : in   std_logic_vector(15 downto 0);
                                            -- Rx Data
        TxFRdData        : in   std_logic_vector(15 downto 0);
                                            -- Tx Data
        RXFF             : in   std_logic;  -- Rx FIFO Full
        TXFF             : in   std_logic;  -- Tx FIFO Full
        RXFE             : in   std_logic;  -- Rx FIFO Empty 
        TXFE             : in   std_logic;  -- Tx FIFO Empty 
        BSY              : in   std_logic;  -- SSP Busy 
        SSPTBSETPINS     : in   std_logic_vector(6 downto 0);
                                            --Clk Cntl Reg. 
        SSPTBCLKREG      : in   std_logic_vector(15 downto 0);
                                            --SSP Clk Reg. 
        SSPTBCLKREG1     : in   std_logic_vector(15 downto 0);
                                            -- SSP Clk1 Reg
        SSPINTR          : in   std_logic;  -- SSP interrupt
        SSPTXINTR        : in   std_logic;  -- SSP TxFIFO interrupt 
        SSPRXINTR        : in   std_logic;  -- SSP RxFIFO interrupt
        SSPRORINTR       : in   std_logic;  -- SSP RxOverRUN interrupt 
        SSPRTINTR        : in   std_logic;  -- SSP RxTimeout interrupt 
        RXWFLG           : in   std_logic;  -- RxFIFO Water FLG 
        PCLKOn           : in   std_logic;  -- PCLK start 
        REFCLKOn         : in   std_logic;  -- SSPCLK start  
        REFCLK1On        : in   std_logic;  -- SSPCLK1 start
        SSPTXDMASREQ     : in   std_logic;  -- Transmit DMA single request
        SSPTXDMABREQ     : in   std_logic;  -- Transmit DMA burst request
        SSPRXDMASREQ     : in   std_logic;  -- Receive DMA single request
        SSPRXDMABREQ     : in   std_logic;  -- Receive DMA burst request
        RxFRdPtrInc      : out  std_logic;  -- RxFIFO read ptr Increment 
        SSPTBCR0Wr       : out  std_logic;  -- Write enable for SSPTBCR0
        SSPTBCR1Wr       : out  std_logic;  -- Write enable for SSPTBCR1
        SSPTBCR2Wr       : out  std_logic;  -- Write enable for SSPTBCR2
        SSPTBPREWr       : out  std_logic;  -- Write enable for SSPTBPRE
        SSPTBTDRWr       : out  std_logic;  -- Tx FIFO Write enable
        SSPTBRDRWr       : out  std_logic;  -- Rx FIFO Write enable
        SSPTBSRWr        : out  std_logic;  -- Write enable for SSPTBSR
        SSPTBSETPINSWr   : out  std_logic;  -- Write enable for SSPTBSETPINS
        SSPTBCLKREGWr    : out  std_logic;  -- Write enable for SSPTBCLKREG
        SSPTBCLKREG1Wr   : out  std_logic;  -- Write enable for SSPTBCLKREG1
        SSPTBDMACRWrEn   : out std_logic;   -- Write Enable for SSPTDMACR 
        PRDATA           : out  std_logic_vector(15 downto 0);
                                            -- Read Databus
        PWDATAIn         : out  std_logic_vector(15 downto 0)
                                            -- Int PWDATA
       );
end SspTrApbif;

-- -----------------------------------------------------------------------------
--
--                               SspTrApbif
--                               ==========
--
-- -----------------------------------------------------------------------------
--
-- Overview
-- ========
-- This module decodes APB accesses and generates the write strobes to the 
-- appropriate registers. This module also contains the output data multiplexer
-- and the output register that form the read interface. The internal databus, 
-- for the SSPTrickbox, PWDATAIn[15:0], is also generated in this module, by 
-- gating the input data bus, PWDATA[15:0] with PSEL and PWRITE.
--
-- -----------------------------------------------------------------------------
--                    SspTB Register Map
-- -----------------------------------------------------------------------------
-- Offset Read (Width)              Write (Width)       Description
-- -----------------------------------------------------------------------------
-- 0x00   SSPTBPRE(4 bits)          SSPTBPRE(16 bits)    PREScale Register 
-- 0x04   SSPTBCR0(16 bits)         SSPTBCRO(16 bits)    Control Register 0
-- 0x08   SSPTBCR1(6 bits)          SSPTBCR1(6 bits)     Control Register 1
-- 0x0C   SSPTBTDR(16 bits)         SSPTBTDR(16 bits)    TxData Register
-- 0x10   SSPTBRDR(16 bits)         SSPTBRDR(16 bits)    RxData Register
-- 0x14   SSPTBSR(12 bits)              -                Status Register
-- 0x1C   SSPTBCLKREG  (16 bits)    SSPTBCLKREG          REFClk Register 
-- 0x20   SSPTBCR2 (11bits)         SSPTBCR2 (11bits)    Control Register 2
-- 0x24   SSPTBCLKREG1 (16 bits)    SSPTBCLKREG1(16bits) REFClk1 Register
-- 0x28   SSPTDMACR  (4 bits)       SSPTDMACR(2 bits)    DMACR Register
-- -----------------------------------------------------------------------------

-- ============================= ARCHITECTURE ================================--

architecture behavioural of SspTrApbif is

-- -----------------------------------------------------------------------------
-- Normal mode registers address constants
-- -----------------------------------------------------------------------------
constant PA_SSPTBPRE          : std_logic_vector(7 downto 2) := "000000";
-- SSPTBPRE at offset 0x00

constant PA_SSPTBCR0          : std_logic_vector(7 downto 2) := "000001";
-- SSPTBCR0 at offset 0x04

constant PA_SSPTBCR1          : std_logic_vector(7 downto 2) := "000010";
-- SSPTBCR1 at offset 0x08

constant PA_SSPTBTDR          : std_logic_vector(7 downto 2) := "000011";
-- SSPTBTDR at offset 0x0C

constant PA_SSPTBRDR          : std_logic_vector(7 downto 2) := "000100";
-- SSPTBRDR at offset 0x10

constant PA_SSPTBSR           : std_logic_vector(7 downto 2) := "000101";
-- SSPTBSR at offset 0x14

constant PA_SSPTBSETPINS      : std_logic_vector(7 downto 2) := "000110";
-- SSPTBSETPINS at offset 0x18

constant PA_SSPTBCLKREG       : std_logic_vector(7 downto 2) := "000111";
-- SSPTBCLKREG at offset 0x1C

constant PA_SSPTBCR2          : std_logic_vector(7 downto 2) := "001000";
-- SSPTBCR2 at offset 0x20

constant PA_SSPTBCLKREG1      : std_logic_vector(7 downto 2) := "001001";
-- SSPTBCLKREG at offset 0x24

constant SSPTBDMACRDec         : std_logic_vector(7 downto 2) := "001010";
-- SSPTBDMACR at offset 0x28

signal SSPTBDMACRrd            : std_logic;
-- DMACR  Read


-- -----------------------------------------------------------------------------
-- Other constants
-- -----------------------------------------------------------------------------
constant ZEROFILL             : std_logic_vector(15 downto 0) := 
                                "0000000000000000";
-- Zero Fill for reads to return zeros in unused bit positions 

-- -----------------------------------------------------------------------------
-- Signal declarations
-- -----------------------------------------------------------------------------
signal GatedPA                : std_logic_vector(7 downto 2);
-- Gate PA with PSEL to save power 

-- -----------------------------------------------------------------------------
-- Read Decodes for Register reads
-- -----------------------------------------------------------------------------
signal SSPTBPRERd            : std_logic;
-- SSPTB PRESCALE read

signal SSPTBCR0Rd            : std_logic;
-- SSPTBCR0 read

signal SSPTBCR1Rd            : std_logic;
-- SSPTBCR1 read
  
signal SSPTBCR2Rd            : std_logic;
-- SSPTBCR2 read
  
signal SSPTBTDRRd            : std_logic;
-- SSPTBTDR read

signal SSPTBRDRRd            : std_logic;
-- SSPTBRDR read
  
signal SSPTBSRRd             : std_logic;
-- SSPTBSR read

signal SSPTBSETPINSRd        : std_logic;
-- SSPTBSETPINS read

signal SSPTBCLKREGRd         : std_logic;
-- SSPTBCLKREG read

signal SSPTBCLKREG1Rd        : std_logic;
-- SSPTBCLKREG1 read

signal SSPTBSR               : std_logic_vector(12 downto 0);
-- SSPTB status register 

signal SSPTBDMACR             : std_logic_vector(5 downto 0);
-- DMA register concatenation of bits

signal NextPRDATA            : std_logic_vector(15 downto 0);
-- D-input of PRDATA output register

signal WrEn                  : std_logic;
-- Write enable signal common to all addresses in the APB interface

signal RdEn                  : std_logic;
-- Read enable signal common to all addresses in the APB interface

-- -----------------------------------------------------------------------------
--
-- Main body of code
-- =================
--
-- -----------------------------------------------------------------------------

begin

-- -----------------------------------------------------------------------------
-- Write Interface
-- -----------------------------------------------------------------------------
-- -----------------------------------------------------------------------------
-- Latch the  data bus and address bus when the device is  selected.
-- -----------------------------------------------------------------------------
GatedPA        <= PADDR when (PSEL = '1') 
               else
                  (others => '0');

PWDATAIn       <= PWDATA when ((PSEL =  '1') and (PWRITE = '1')) 
               else
                  (others  => '0');

WrEn           <= PENABLE and PSEL and PWRITE;

-- -----------------------------------------------------------------------------
--  Register Write Decodes
-- -----------------------------------------------------------------------------
-- SSPTBPRE
SSPTBPREWr        <= '1'   when ((WrEn = '1') and (GatedPA = PA_SSPTBPRE))
                  else
                     '0';
-- SSPTBCRO
SSPTBCR0Wr        <= '1'   when ((WrEn = '1') and (GatedPA = PA_SSPTBCR0))
                  else
                     '0';
-- SSPTBCR1
SSPTBCR1Wr        <= '1'   when ((WrEn = '1') and (GatedPA = PA_SSPTBCR1))
                  else
                     '0';
-- SSPTBCR2
SSPTBCR2Wr        <= '1'   when ((WrEn = '1') and (GatedPA = PA_SSPTBCR2))
                  else
                     '0';
-- SSPTBTDR
SSPTBTDRWr        <= '1'   when ((WrEn = '1') and (GatedPA = PA_SSPTBTDR))
                  else
                     '0';
-- SSPTBRDR
SSPTBRDRWr        <= '1'   when ((WrEn = '1') and (GatedPA = PA_SSPTBRDR))
                  else
                     '0';
-- SSPTBSR
SSPTBSRWr         <= '1'   when ((WrEn = '1') and (GatedPA = PA_SSPTBSR))
                  else
                     '0';

-- SSPTBSETPIN
SSPTBSETPINSWr  <= '1'   when ((WrEn = '1') and (GatedPA = PA_SSPTBSETPINS))
                  else
                     '0';
-- SSPTBCLKREG
SSPTBCLKREGWr    <= '1'   when ((WrEn = '1') and (GatedPA = PA_SSPTBCLKREG))
                  else
                     '0';
-- SSPTBCLKREG1
SSPTBCLKREG1Wr   <= '1'   when ((WrEn = '1') and (GatedPA = PA_SSPTBCLKREG1))
                  else
                     '0';
-- SSPTBDMACR
SSPTBDMACRWrEn   <= '1'        when ((WrEn = '1') and
                                       (GatedPA = SSPTBDMACRDec))
                     else
                        '0';

-- -----------------------------------------------------------------------------
-- Read Interface
-- -----------------------------------------------------------------------------
RdEn <= PSEL and (not PWRITE) and (not PENABLE);

-- -----------------------------------------------------------------------------
-- Normal mode Register Read Decodes
-- -----------------------------------------------------------------------------
-- SSPTBCR0
SSPTBCR0Rd        <= '1'   when ((RdEn = '1') and (GatedPA = PA_SSPTBCR0))
                  else
                     '0';
-- SSPTBCR1
SSPTBCR1Rd        <= '1'   when ((RdEn = '1') and (GatedPA = PA_SSPTBCR1))
                  else
                     '0';
-- SSPTBCR2
SSPTBCR2Rd        <= '1'   when ((RdEn = '1') and (GatedPA = PA_SSPTBCR2))
                  else
                     '0';
-- SSPTBTDR
SSPTBTDRRd        <= '1'   when ((RdEn = '1') and (GatedPA = PA_SSPTBTDR))
                  else
                     '0';
-- SSPTBRDR
SSPTBRDRRd        <= '1'   when ((RdEn = '1') and (GatedPA = PA_SSPTBRDR))
                  else
                     '0';
-- SSPTBSR
SSPTBSRRd         <= '1'   when ((RdEn = '1') and (GatedPA = PA_SSPTBSR))
                  else
                     '0';
-- SSPTBSETPINS
SSPTBSETPINSRd  <= '1'   when ((RdEn = '1') and (GatedPA = PA_SSPTBSETPINS))
                  else
                     '0';
-- SSPTBCLKREG
SSPTBCLKREGRd    <= '1'   when ((RdEn = '1') and (GatedPA = PA_SSPTBCLKREG))
                  else
                     '0';
-- SSPTBCLKREG1
SSPTBCLKREG1Rd   <= '1'   when ((RdEn = '1') and (GatedPA = PA_SSPTBCLKREG1))
                  else
                     '0';
-- SSPTBPRE
SSPTBPRERd        <= '1'   when ((RdEn = '1') and (GatedPA = PA_SSPTBPRE))
                  else
                     '0';
 -- SSPTBDMACR
SSPTBDMACRrd       <= '1' when ((RdEn = '1') and
                                (GatedPA = SSPTBDMACRDec))
                  else
                     '0';
-- -----------------------------------------------------------------------------
-- Increment the Read pointer in the Receive FIFO after every read from
-- the Receive FIFO i.e.  after every read from the SSPTBRDR Register
-- -----------------------------------------------------------------------------
RxFRdPtrInc       <= '1' when ((PENABLE = '1') and (PSEL = '1') and 
                               (PWRITE = '0')  and (GatedPA = PA_SSPTBRDR))
                  else 
                     '0'; 

-- -----------------------------------------------------------------------------
-- Assign individual status bits  to SSPTBSR  
-- -----------------------------------------------------------------------------
SSPTBSR      <= (SSPRTINTR &
                 REFCLKOn & PCLKOn & SSPRORINTR & SSPTXINTR &
                 SSPRXINTR & RXWFLG & SSPINTR & BSY &
                 TXFF & TXFE & RXFF & RXFE );

-- -----------------------------------------------------------------------------
-- Assign individual DMA status bits  to SSPTBDMACR  
-- -----------------------------------------------------------------------------
SSPTBDMACR      <= (SSPRXDMASREQ & SSPRXDMABREQ & SSPTXDMASREQ & SSPTXDMABREQ & "00");
-- -----------------------------------------------------------------------------
-- Output Mux.
-- When the peripheral is not being accessed, '0's are driven on the Read 
-- Databus (PRDATA) so as not to place any restrictions on the method of 
-- external bus connection. The external data buses of the peripherals on the 
-- APB may then be connected to the ASB-to-APB bridge using Muxed or ORed bus 
-- connection method.
-- -----------------------------------------------------------------------------
NextPRDATA <= SSPTBCR0                             when (SSPTBCR0Rd = '1')   
           else
             ZEROFILL(15 downto 6) & SSPTBCR1      when (SSPTBCR1Rd = '1')
           else
             ZEROFILL(15 downto 11) & SSPTBCR2     when (SSPTBCR2Rd = '1')
           else
             TxFRdData                             when (SSPTBTDRRd = '1')
           else
             RxFRdData                             when (SSPTBRDRRd = '1')
           else
             ZEROFILL(15 downto 13) & SSPTBSR      when (SSPTBSRRd = '1')
           else
             ZEROFILL(15 downto 6) & SSPTBSETPINS  when (SSPTBSETPINSRd = '1')  
           else
             SSPTBCLKREG                           when (SSPTBCLKREGRd = '1')
           else
             SSPTBCLKREG1                          when (SSPTBCLKREG1Rd = '1')
           else
             ZEROFILL(15 downto 4) & SSPTBPRE      when (SSPTBPRERd = '1')    
           else 
             ZEROFILL(15 downto 6)  & SSPTBDMACR   when (SSPTBDMACRrd = '1')
           else  
             ZEROFILL;

-- -----------------------------------------------------------------------------
-- Output Data register. 
-- -----------------------------------------------------------------------------
p_Seq : process (PCLK, PRESETn)
begin
  if (PRESETn = '0') then
    PRDATA  <= (others => '0');
  elsif (PCLK'event and PCLK = '1') then
    PRDATA  <= NextPRDATA;
  end if;
end process p_Seq;
end behavioural;

-- =============================== End =======================================--

