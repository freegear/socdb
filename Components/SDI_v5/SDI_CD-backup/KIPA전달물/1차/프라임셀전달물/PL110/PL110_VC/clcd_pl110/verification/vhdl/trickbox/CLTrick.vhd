-- --=========================================================================--
--  This confidential and proprietary software may be used only as
--  authorised by a licensing agreement from ARM Limited
--    (C) COPYRIGHT 1999 ARM Limited
--        ALL RIGHTS RESERVED
--  The entire notice above must be reproduced on all authorised
--  copies and copies may only be made to the extent permitted
--  by a licensing agreement from ARM Limited.
--  ----------------------------------------------------------------------------
--
--  Version and Release Control Information:
--
--  File Name              : CLTrick.vhd.rca
--  File Revision          : 1.3
--
--  Release Information    : PrimeCell(TM)-PL110-r1p2-00ltd0
--
--  ----------------------------------------------------------------------------

--  ----------------------------------------------------------------------------
--  Purpose : CLCD Trickbox Top Module
--
-- --=========================================================================--

library ieee;
use     ieee.std_logic_1164.all;
use     ieee.std_logic_arith.all;


-- -----------------------------------------------------------------------------

entity CLTrick is
generic (
         LCDPeriod : time := 10 ns
        );
port (
      HCLK             : in std_logic;
      -- AHB Bus Clock
      HRESETN          : in std_logic;      
      -- AHB Bus Reset

      -- Main Bus Slave AHB Signals connected to Slave Testbench
      HADDRB           : in std_logic_vector (9 downto 2);
      -- AHB (Bus) Address Bus
      HTRANSB          : in std_logic_vector (1 downto 0);
      -- AHB (Bus) Transfer Type
      HWRITEB          : in std_logic;
      -- AHB (Bus) Transfer Direction
      HSELB            : in std_logic;
      -- AHB (Bus) Slave Select
      HSELCom          : in std_logic;
      -- AHB Common Registers Select
      HSIZEB           : in std_logic_vector (2 downto 0);
      -- AHB (Bus) Transfer Size
      HBURSTB          : in std_logic_vector (2 downto 0);
      -- AHB (Bus) Burst Type
      HWDATAB          : in std_logic_vector (31 downto 0);
      -- AHB (Bus) Write Data Bus
      HREADYBIn        : in std_logic;
      -- AHB (Bus) Global Transfer Done
      HRDATAB          : out std_logic_vector (31 downto 0);
      -- AHB (Bus) Read  Data Bus
      HREADYBOut       : out std_logic;
      -- AHB (Bus) TrickBox Transfer Done
      HRESPB           : out std_logic_vector (1 downto 0);
      -- AHB (Bus) transfer Response

      -- CLCD AHB Signals
      HADDRC           : in std_logic_vector (31 downto 0);
      -- AHB (CLCD) Address Bus
      HTRANSC          : in std_logic_vector (1 downto 0);
      -- AHB (CLCD) Transfer Type
      HWRITEC          : in std_logic;
      -- AHB (CLCD) Transfer Direction
      HSIZEC           : in std_logic_vector (2 downto 0);
      -- AHB (CLCD) Transfer Size
      HBURSTC          : in std_logic_vector (2 downto 0);
      -- AHB (CLCD) Burst Type
      HREADYC          : out std_logic;
      -- AHB (CLCD) Transfer Done
      HPROTC           : in std_logic_vector (3 downto 0);
      -- AHB (CLCD) Protection Signal
      HLOCKC           : in std_logic;
      -- AHB (CLCD) Lock mode
      HRDATAC          : out std_logic_vector (31 downto 0);
      -- AHB (CLCD) Read  Data Bus
      HBUSREQC         : in std_logic;
      -- AHB (CLCD) Bus Request from CLCD Master
      HRESPC           : out std_logic_vector (1 downto 0);
      -- AHB (CLCD) Transfer Response
      HGRANTC          : out std_logic; 
      -- AHB (CLCD) Bus Grant for CLCD Master

      -- CLCD Panel Signals
      LCDCLK           : out std_logic;
      -- CLCD controller Clock
      nCLCLKRESET      : out std_logic;
      -- CLCD controller Clock domain reset
      CLPOWER          : in std_logic;
      -- LCD Power Panel Enable
      CLFP             : in std_logic;
      -- Frame Sync Pulse
      CLLP             : in std_logic;
      -- Line Sync Pulse
      CLCP             : in std_logic;
      -- Pixel Clock
      CLAC             : in std_logic;
      -- STN AC bias drive or TFT data Enable output
      CLD              : in std_logic_vector (23 downto 0);
      -- CLCD Panel Data
      CLLE             : in std_logic;
      -- Line End Signal
      CLCLKSEL         : in std_logic;
      -- CLCD Clock Souurce Select Signal

      -- Interrupt Signals
      BEINTTR          : in std_logic;
      -- CLCD Bus Error Interrupt
      FUFINTR          : in std_logic;
      -- CLCD DMA  FIFO Underflow Interrupt
      LNBUINTR         : in std_logic;
      -- CLCD Next Base Address Update Interrupt
      VCOMPINTR        : in std_logic;
      -- CLCD Vertical Compare Interrupt
      INTR             : in std_logic
      -- CLCD Combined Interrupt
     );
end CLTrick; 

-- -----------------------------------------------------------------------------
--
--                             CLTrick
--                             =======
--
-- -----------------------------------------------------------------------------
--
-- Overview
-- ========
-- This module is the top level of the CLCD Trickbox.
-- It includes the following:
--  1. Bus AHB Interface
--  2. Register Block
--  3. CLCD AHB Interface
--  4. CLCD Data Checker Module
--  5. CLCD Panel Protocol Checker
-- -----------------------------------------------------------------------------

--============================== ARCHITECTURE ================================--
--
--------------------------------------------------------------------------------
-- Architecture Packages
--------------------------------------------------------------------------------
 
architecture behavioural of CLTrick is
 
--------------------------------------------------------------------------------
-- Component declaration
--------------------------------------------------------------------------------
 
--------------------------------------------------------------------------------
-- Internal Constants
--------------------------------------------------------------------------------

 
-- -----------------------------------------------------------------------------
-- Signal declarations
-- -----------------------------------------------------------------------------
-- Internal Signals
-- ----------------
signal iHRDATAB        : std_logic_vector(31 downto 0);
-- AHB (Bus) Read  Data Bus
signal iHREADYBOut     : std_logic;
-- AHB (Bus) TrickBox Transfer Done
signal iHRESPB         : std_logic_vector(1 downto 0);
-- AHB (Bus) transfer Response
signal iHREADYC        : std_logic;
-- AHB (CLCD) Transfer Done
signal iHRDATAC        : std_logic_vector(31 downto 0);
-- AHB (CLCD) Read  Data Bus
signal iHRESPC         : std_logic_vector(31 downto 0);
-- AHB (CLCD) Transfer Response
signal iHGRANTC        : std_logic;
-- AHB (CLCD) Bus Grant for CLCD Master

signal CLTrWrite       : std_logic;
-- CLCD Trickbox Write
signal CLTrWDATA       : std_logic_vector(31 downto 0);
-- CLCD Trickbox Write Data
signal CLTrRDATA       : std_logic_vector(31 downto 0);
-- CLCD Trickbox Read  Data
signal CLTrControlSel  : std_logic;
-- CLCD Trickbox Control Reg Select
signal CLTrRegSel      : std_logic;
-- CLCD Trickbox Register Select
signal CLTrTiming0Sel  : std_logic;
-- CLCD Trickbox Timing 0 Reg Select
signal CLTrTiming1Sel  : std_logic;
-- CLCD Trickbox Timing 1 Reg Select
signal CLTrTiming2Sel  : std_logic;
-- CLCD Trickbox Timing 2 Reg Select
signal CLTrTiming3Sel  : std_logic;
-- CLCD Trickbox Timing 3 Reg Select
signal CLTrUPBASESel   : std_logic;
-- CLCD Trickbox Upper Panel Base Select
signal CLTrLPBASESel   : std_logic;
-- CLCD Trickbox Lower Panel Base Select
signal CLTrPalSel      : std_logic;
-- CLCD Trickbox Palette Select
signal CLTrPalAddr     : std_logic_vector(6 downto 0);
-- CLCD Trickbox Palette Offset Address
signal CLTrUPBASE      : std_logic_vector(31 downto 0);
-- CLCD Data Base Address for Upper Panel
signal CLTrLPBASE      : std_logic_vector(31 downto 0);
-- CLCD Data Base Address for Lower Panel
signal Delay           : std_logic_vector(31 downto 0);
-- Trickbox delay counter value
signal CLTrIntrTest    : std_logic;
-- CLCD Trickbox interupt test bit
signal CLTrFUFIntrTst  : std_logic;
-- CLCD Trickbox FIFO underflow interupt test bit
signal CLTrRand        : std_logic;
-- CLCD Trickbox random responce test bit

signal CLTrError       : std_logic;
-- CLCD Trickbox ERROR Response bit
signal CLTrPanel       : std_logic;
-- Indicates active panel
signal CLTrGrant       : std_logic;
-- CLCD Dual Panel Mode Bit
signal DataAvail       : std_logic;
-- Indicate that Master is sampling data
signal SlaveState      : std_logic_vector(2 downto 0);
-- Slave condition to Reg Block for CLTrError
signal CLTrEn          : std_logic;
-- CLCD Trickbox Enable
signal CLTrReset       : std_logic;
-- CLCD Trickbox clock domain reset

signal BPP             : std_logic_vector(2 downto 0);
-- Bits per pixel
signal TFT             : std_logic;
-- Indicates TFT or STN Mode
signal BW              : std_logic;
-- Black-White mode in STN mode 
signal Mono8           : std_logic;
-- Indicates TFT or STN Mode
signal Dual            : std_logic;
-- Indicates Single or Dual Panel STN mode
signal BGR             : std_logic;
-- Indicates BGR or RGB format
signal BEBO            : std_logic;
-- Indicates Byte order
signal BEPO            : std_logic;
-- Indicates Pixel order within Byte
signal VCOMPINTRout    : std_logic;
-- To protcolcheck module
signal LNBUINTRout     : std_logic;
-- To protcolcheck module

signal VComp : std_logic_vector(1 downto 0);
-- VComp Interrupt Control bit
signal PPL             : std_logic_vector(5 downto 0);
-- Pixel Per Line
signal HSW             : std_logic_vector(7 downto 0);
-- Horizontal Sync Pulse Width
signal HFP             : std_logic_vector(7 downto 0);
-- Horizontal Front Porch
signal HBP             : std_logic_vector(7 downto 0);
-- Horizontal Back Porch
signal LPP             : std_logic_vector(9 downto 0);
-- Line Per Panel
signal VSW             : std_logic_vector(5 downto 0);
-- Vertical Sync Pulse Width
signal VFP             : std_logic_vector(7 downto 0);
-- Vertical Front Porch
signal VBP             : std_logic_vector(7 downto 0);
-- Vertical Back Porch
signal PCD             : std_logic_vector(9 downto 0);
-- Panel Clock Divisor
signal ACB             : std_logic_vector(4 downto 0);
-- AC Bias Pin Frequency
signal IVS             : std_logic;
-- Invert VSync
signal IHS             : std_logic;
-- Invert HSync
signal IPC             : std_logic;
-- Invert Panel Clock
signal IEO             : std_logic;
-- Invert Output Enable
signal CPL             : std_logic_vector(9 downto 0);
-- Clocks Per Line
signal BCD             : std_logic;
-- ByPass Pixel Clock Divisor
signal LED             : std_logic_vector(6 downto 0);
-- Line End Delay
signal LEE             : std_logic;
-- Line End Select
signal Check           : std_logic;
-- Check CLD
signal CLTrBaseUpdate  : std_logic;
-- CLCD Trickbox Base Update Request Signal
signal ResetWritePtrs  : std_logic;
-- CLCD Trickbox initialise write pointers
signal VSYNCState      : std_logic_vector(2 downto 0);
-- Vertical sync pulse
signal DelayRegSel     : std_logic;
signal iLCDCLK         : std_logic;
-- Internal version of the device clock
signal RefClk          : std_logic;
-- Internal version of the device clock
signal IntCLTrReset    : std_logic;
-- internal copy of device-reset

signal LcdEn           : std_logic;
-- Enable signal for LCD controller
signal LcdPwr          : std_logic;
-- Panel Power

-- -----------------------------------------------------------------------------
-- Component declarations
-- -----------------------------------------------------------------------------
component CLTrAHBIf
port (
      -- Inputs
      -- AHB Inputs
      HCLK           : in std_logic;
      HRESETN        : in std_logic;
      HADDR          : in std_logic_vector(9 downto 2);
      HTRANS         : in std_logic_vector(1 downto 0);
      HWRITE         : in std_logic;
      HSEL           : in std_logic;
      HSELCom        : in std_logic;
      HSIZE          : in std_logic_vector(2 downto 0);
      HBURST         : in std_logic_vector(2 downto 0);
      HWDATA         : in std_logic_vector(31 downto 0);
      HREADYIn       : in std_logic;

      -- Other Inputs
      CLTrRDATA      : in std_logic_vector(31 downto 0);

      -- Outputs
      -- AHB Outputs
      HRDATA         : out std_logic_vector(31 downto 0);
      HREADYOut      : out std_logic;
      HRESP          : out std_logic_vector(1 downto 0);

      -- Other Outputs
      CLTrWRITE      : out std_logic;
      CLTrWDATA      : out std_logic_vector(31 downto 0);
      CLTrRegSel     : out std_logic;
      CLTrControlSel : out std_logic;
      CLTrTiming0Sel : out std_logic;
      CLTrTiming1Sel : out std_logic;
      CLTrTiming2Sel : out std_logic;
      CLTrTiming3Sel : out std_logic;
      CLTrUPBASESel  : out std_logic;
      CLTrLPBASESel  : out std_logic;
      CLTrPalSel     : out std_logic;
      DelayRegSel    : out std_logic;
      Delay          : in std_logic_vector(31 downto 0);
      CLTrPalAddr    : out std_logic_vector(6 downto 0)
    );
end component;

component CLTrCLCDIf
port (
      HCLK           : in std_logic;
      HRESETN        : in std_logic;
      HADDR          : in std_logic_vector(31 downto 0);
      HTRANS         : in std_logic_vector(1 downto 0);
      HWRITE         : in std_logic;
      HSIZE          : in std_logic_vector(2 downto 0);
      HBURST         : in std_logic_vector(2 downto 0);
      HRDATA         : out std_logic_vector(31 downto 0);
      HREADY         : out std_logic;
      HPROT          : in std_logic_vector(3 downto 0);
      HLOCK          : in std_logic;
      HRESP          : out std_logic_vector(1 downto 0);
      HBUSREQ        : in std_logic;
      HGRANT         : out std_logic;

      CLTrEn         : in std_logic;
      CLTrUPBASE     : in std_logic_vector(31 downto 0);
      CLTrLPBASE     : in std_logic_vector(31 downto 0);
      CLTrError      : in std_logic;
      CLTrGrant      : in std_logic;
      CLTrRand       : in std_logic;
      CLTrPanel      : out std_logic;
      ResetWritePtrs : out std_logic;
      Dual           : in std_logic;
      PPL            : in std_logic_vector(5 downto 0);
      LPP            : in std_logic_vector(9 downto 0);
      BPP            : in std_logic_vector(2 downto 0);
      DataAvail      : out std_logic;
      SlaveState     : out std_logic_vector(2 downto 0);
      CLTrBaseUpdate : in std_logic
     );
end component;

component CLTrRegBlock
port (
      HCLK            : in std_logic;
      HRESETN         : in std_logic;
      CLTrWRITE       : in std_logic;
      CLTrWDATA       : in std_logic_vector(31 downto 0);
      CLTrRegSel      : in std_logic;
      DelayRegSel     : in std_logic;
      CLTrControlSel  : in std_logic;
      CLTrTiming0Sel  : in std_logic;
      CLTrTiming1Sel  : in std_logic;
      CLTrTiming2Sel  : in std_logic;
      CLTrTiming3Sel  : in std_logic;
      CLTrUPBASESel   : in std_logic;
      CLTrLPBASESel   : in std_logic;
      CLTrUPBASE      : out std_logic_vector(31 downto 0);
      CLTrLPBASE      : out std_logic_vector(31 downto 0);
      SlaveState      : in std_logic_vector(2 downto 0);

      BEINTTR         : in std_logic;
      FUFINTR         : in std_logic;
      LNBUINTR        : in std_logic;
      VCOMPINTR       : in std_logic;
      VCOMPINTRout    : out std_logic;
      INTR            : in std_logic;

      -- Outputs
      CLTrRDATA       : out std_logic_vector(31 downto 0);
      CLTrEn          : out std_logic;
      CLTrGrant       : out std_logic;
      CLTrRand        : out std_logic;
      CLTrError       : out std_logic;
      CLTrIntrTest    : out std_logic;
      CLTrFUFIntrTst  : out std_logic;
      CLTrReset       : out std_logic;

      LcdEn           : out std_logic;
      LcdPwr          : out std_logic;

      BPP             : out std_logic_vector(2 downto 0);
      BW              : out std_logic;
      TFT             : out std_logic;
      Mono8           : out std_logic;
      Dual            : out std_logic;
      BGR             : out std_logic;
      BEBO            : out std_logic;
      BEPO            : out std_logic;
      VComp           : out std_logic_vector(1 downto 0);
      PPL             : out std_logic_vector(5 downto 0);
      HSW             : out std_logic_vector(7 downto 0);
      HFP             : out std_logic_vector(7 downto 0);
      HBP             : out std_logic_vector(7 downto 0);
      LPP             : out std_logic_vector(9 downto 0);
      VSW             : out std_logic_vector(5 downto 0);
      VFP             : out std_logic_vector(7 downto 0);
      VBP             : out std_logic_vector(7 downto 0);
      PCD             : out std_logic_vector(9 downto 0);
      ACB             : out std_logic_vector(4 downto 0);
      IVS             : out std_logic;
      IHS             : out std_logic;
      IPC             : out std_logic;
      IEO             : out std_logic;
      CPL             : out std_logic_vector(9 downto 0);
      BCD             : out std_logic;
      LED             : out std_logic_vector(6 downto 0);
      LEE             : out std_logic;
      Delay           : out std_logic_vector(31 downto 0)
     );
end component;

component CLTrDataCheck
port (
      HCLK            : in std_logic;
      VSYNCState      : in std_logic_vector(2 downto 0);
      CLCLK           : in std_logic;
      HRESETn         : in std_logic;
 
      CLTrEn          : in std_logic;
      CLTrIntrTest    : in std_logic;
      CLTrFUFIntrTst  : in std_logic;
      CLPOWER         : in std_logic;

      DataAvail       : in std_logic;
      Check           : in std_logic;
      DataIn          : in std_logic_vector(31 downto 0);
      PPL             : in std_logic_vector(5 downto 0);
      LPP             : in std_logic_vector(9 downto 0);
      CLD             : in std_logic_vector(23 downto 0);
      BPP             : in std_logic_vector(2 downto 0);
 
      BW              : in std_logic;
      TFT             : in std_logic;
      Mono8           : in std_logic;
      Dual            : in std_logic;
      BGR             : in std_logic;
      BEBO            : in std_logic;
      BEPO            : in std_logic;
      CLTrPanel       : in std_logic;
      ResetWritePtrs  : in std_logic;
 
 
      -- Palette RAM Signals
      PalSelect       : in std_logic;
      PalWrite        : in std_logic;
      PalData         : in std_logic_vector(31 downto 0);
      PalAddr         : in std_logic_vector(6 downto 0)
     );
end component;

component CLTrProtCheck
port (
      CLCLK             : in std_logic;
      HRESETN           : in std_logic;
      CLTrEn            : in std_logic;
      CLTrIntrTest      : in std_logic;
      CLTrFUFIntrTst    : in std_logic;
      CLPOWER           : in std_logic;
      LcdEn             : in std_logic;
      CLFP              : in std_logic;
      CLLP              : in std_logic;
      CLCP              : in std_logic;
      CLAC              : in std_logic;
      CLLE              : in std_logic;
      TFT               : in std_logic;
      PCD               : in std_logic_vector(9 downto 0);
      HSW               : in std_logic_vector(7 downto 0);
      HFP               : in std_logic_vector(7 downto 0);
      HBP               : in std_logic_vector(7 downto 0);
      LPP               : in std_logic_vector(9 downto 0);
      VSW               : in std_logic_vector(5 downto 0);
      VFP               : in std_logic_vector(7 downto 0);
      VBP               : in std_logic_vector(7 downto 0);

      ACB               : in std_logic_vector(4 downto 0);
      IVS               : in std_logic;
      IHS               : in std_logic;
      IPC               : in std_logic;
      IEO               : in std_logic;
      CPL               : in std_logic_vector(9 downto 0);
      BCD               : in std_logic;
      LED               : in std_logic_vector(6 downto 0);
      LEE               : in std_logic;
      Check             : out std_logic;
      CLTrBaseUpdate    : out std_logic;
      VCOMPINTRout      : in std_logic;
      LNBUINTRout       : in std_logic;
      VSYNCState        : out std_logic_vector(2 downto 0);
      VComp             : in std_logic_vector(1 downto 0)
     );
end component;
-- -----------------------------------------------------------------------------
-- Main body of code
-- =================
-- -----------------------------------------------------------------------------

begin

LCDCLK  <= iLCDCLK;
HRDATAC <= iHRDATAC;

-- -----------------------------------------------------------------------------
-- Instantiation of CLTrAHBIf
-- -----------------------------------------------------------------------------
u_CLTrAHBIf  : CLTrAHBIf 
                     -- Inputs

  port map (         HCLK                 => HCLK,
                     HRESETN              => HRESETN,
                     HADDR                => HADDRB,
                     HTRANS               => HTRANSB,
                     HWRITE               => HWRITEB,
                     HSEL                 => HSELB,
                     HSELCom              => HSELCom,
                     HSIZE                => HSIZEB,
                     HBURST               => HBURSTB,
                     HWDATA               => HWDATAB,
                     HREADYIn             => HREADYBIn,

                     CLTrRDATA            => CLTrRDATA,

                     -- Outputs
                     HRDATA               => HRDATAB,
                     HREADYOut            => HREADYBOut,
                     HRESP                => HRESPB,

                     CLTrWRITE            => CLTrWRITE,
                     CLTrWDATA            => CLTrWDATA,
                     CLTrRegSel           => CLTrRegSel,
                     CLTrControlSel       => CLTrControlSel,
                     CLTrTiming0Sel       => CLTrTiming0Sel,
                     CLTrTiming1Sel       => CLTrTiming1Sel,
                     CLTrTiming2Sel       => CLTrTiming2Sel,
                     CLTrTiming3Sel       => CLTrTiming3Sel,
                     CLTrUPBASESel        => CLTrUPBASESel,
                     CLTrLPBASESel        => CLTrLPBASESel,
                     CLTrPalSel           => CLTrPalSel,
                     DelayRegSel          => DelayRegSel,
                     Delay                => Delay,
                     CLTrPalAddr          => CLTrPalAddr
                    );

-- Instantiation of CLTrCLCDIf
u_CLTrCLCDIf  : CLTrCLCDIf
  port map (         HCLK                  => HCLK,
                     HRESETN               => HRESETN,
                     HADDR                 => HADDRC,
                     HTRANS                => HTRANSC,
                     HWRITE                => HWRITEC,
                     HSIZE                 => HSIZEC,
                     HBURST                => HBURSTC,
                     HRDATA                => iHRDATAC,
                     HREADY                => HREADYC,
                     HPROT                 => HPROTC,
                     HLOCK                 => HLOCKC,
                     HRESP                 => HRESPC,
                     HBUSREQ               => HBUSREQC,
                     HGRANT                => HGRANTC,
                     CLTrEn                => CLTrEn,
                     CLTrUPBASE            => CLTrUPBASE,
                     CLTrLPBASE            => CLTrLPBASE,
                     CLTrError             => CLTrError,
                     CLTrPanel             => CLTrPanel,
                     Dual                  => Dual,
                     PPL                   => PPL,
                     LPP                   => LPP,
                     BPP                   => BPP,
                     CLTrRand              => CLTrRand,
                     CLTrGrant             => CLTrGrant,
                     DataAvail             => DataAvail,
                     SlaveState            => SlaveState,
                     ResetWritePtrs        => ResetWritePtrs,
                     CLTrBaseUpdate        => CLTrBaseUpdate
                    );

-- Instantiation of CLTrRegBlock
u_CLTrRegBlock : CLTrRegBlock

  port map (         
                     HCLK                  => HCLK,
                     HRESETN               => HRESETN,
                     CLTrWRITE             => CLTrWRITE,
                     CLTrWDATA             => CLTrWDATA,
                     CLTrRDATA             => CLTrRDATA,
                     CLTrRegSel            => CLTrRegSel,
                     CLTrControlSel        => CLTrControlSel,
                     CLTrTiming0Sel        => CLTrTiming0Sel,
                     CLTrTiming1Sel        => CLTrTiming1Sel,
                     CLTrTiming2Sel        => CLTrTiming2Sel,
                     CLTrTiming3Sel        => CLTrTiming3Sel,
                     CLTrUPBASESel         => CLTrUPBASESel,
                     CLTrLPBASESel         => CLTrLPBASESel,
                     CLTrUPBASE            => CLTrUPBASE,
                     CLTrLPBASE            => CLTrLPBASE,
                     DelayRegSel           => DelayRegSel,
                     SlaveState            => SlaveState,
 
                     -- Interrupt Lines
                     BEINTTR               => BEINTTR,
                     FUFINTR               => FUFINTR,
                     LNBUINTR              => LNBUINTR,
                     VCOMPINTR             => VCOMPINTR,
                     VCOMPINTRout          => VCOMPINTRout,
                     INTR                  => INTR,
 
                     -- Control bit fields
                     CLTrEn                => CLTrEn,
                     LcdEn                 => LcdEn,
                     LcdPwr                => LcdPwr,
                     BPP                   => BPP,

                     BW                    => BW,
                     TFT                   => TFT,
                     Mono8                 => Mono8,
                     Dual                  => Dual,
                     BGR                   => BGR,
                     BEBO                  => BEBO,
                     BEPO                  => BEPO,
                     VComp                 => VComp,
                     CLTrGrant             => CLTrGrant,
                     CLTrReset             => CLTrReset,
                     CLTrError             => CLTrError,
                     CLTrIntrTest          => CLTrIntrTest,
                     CLTrFUFIntrTst        => CLTrFUFIntrTst,
                     CLTrRand              => CLTrRand,
                     PPL                   => PPL,
                     HSW                   => HSW,
                     HFP                   => HFP,
                     HBP                   => HBP,
                     LPP                   => LPP,
                     VSW                   => VSW,
                     VFP                   => VFP,
                     VBP                   => VBP,
                     PCD                   => PCD,
                     ACB                   => ACB,
                     IVS                   => IVS,
                     IHS                   => IHS,
                     IPC                   => IPC,
                     IEO                   => IEO,
                     CPL                   => CPL,
                     BCD                   => BCD,
                     LED                   => LED,
                     LEE                   => LEE,
                     Delay                 => Delay
                    ) ;

-- Instantiation of CLTrDataCheck
u_CLTrDataCheck : CLTrDataCheck

  port map (         HCLK                  => HCLK,
                     VSYNCState            => VSYNCState,
                     CLCLK                 => iLCDCLK,
                     HRESETN               => HRESETN,
                     CLTrEn                => CLTrEn,
                     CLTrIntrTest          => CLTrIntrTest,
                     CLTrFUFIntrTst        => CLTrFUFIntrTst,
                     CLPOWER               => CLPOWER,
                     DataAvail             => DataAvail,
                     Check                 => Check,
                     DataIn                => iHRDATAC,
                     PPL                   => PPL,
                     LPP                   => LPP,
                     CLD                   => CLD,
                     BPP                   => BPP,
                     BW                    => BW,
                     TFT                   => TFT,
                     Mono8                 => Mono8,
                     Dual                  => Dual,
                     BGR                   => BGR,
                     BEBO                  => BEBO,
                     BEPO                  => BEPO,
                     CLTrPanel             => CLTrPanel,
                     ResetWritePtrs        => ResetWritePtrs,
 
                     -- Palette RAM Signals
                     PalSelect             => CLTrPalSel,
                     PalWrite              => CLTrWRITE,
                     PalData               => CLTrWDATA,
                     PalAddr               => CLTrPalAddr
                    );

-- Instantiation of CLTrProtCheck
u_CLTrProtCheck : CLTrProtCheck 
  port map ( 
                     CLCLK                 => iLCDCLK,
                     HRESETN               => HRESETN,
                     CLTrEn                => CLTrEn,
                     CLTrIntrTest          => CLTrIntrTest,
                     CLTrFUFIntrTst        => CLTrFUFIntrTst,
                     CLPOWER               => CLPOWER,
                     LcdEn                 => LcdEn,
                     CLFP                  => CLFP,
                     CLLP                  => CLLP,
                     CLCP                  => CLCP,
                     CLAC                  => CLAC,
                     CLLE                  => CLLE,
                     TFT                   => TFT,
                     PCD                   => PCD,
                     HSW                   => HSW,
                     HFP                   => HFP,
                     HBP                   => HBP,
                     LPP                   => LPP,
                     VSW                   => VSW,
                     VFP                   => VFP,
                     VBP                   => VBP,
                     ACB                   => ACB,
                     IVS                   => IVS,
                     IHS                   => IHS,
                     IPC                   => IPC,
                     IEO                   => IEO,
                     CPL                   => CPL,
                     BCD                   => BCD,
                     LED                   => LED,
                     LEE                   => LEE,
                     Check                 => Check,
                     CLTrBaseUpdate        => CLTrBaseUpdate,
                     VCOMPINTRout          => VCOMPINTRout,
                     LNBUINTRout           => LNBUINTRout,
                     VComp                 => VComp,
                     VSYNCState            => VSYNCState
                    );

-- -----------------------------------------------------------------------------
-- The Reference Clock is generated in the following process
-- -----------------------------------------------------------------------------
p_REFClKGen : process
begin
  RefClk <= '0';
  wait for (LCDPeriod/2);
  RefClk <= '1';
  wait for (LCDPeriod/2);
end process p_REFClKGen;

iLCDCLK <= RefClk when (CLCLKSEL = '1')
        else
           HCLK;

p_ResetApply : process (HCLK)
begin
  if (HCLK'event and HCLK = '1') then
    IntCLTrReset <= not(CLTrReset);
  end if;
end process p_ResetApply;

nCLCLKRESET <= IntCLTrReset when (CLCLKSEL = '1')
            else
               HRESETN;

end behavioural; 
 
-- --================================== End ==================================--

