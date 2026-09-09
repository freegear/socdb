// --=========================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from SANGHWA MICRO Technology
// ALL RIGHTS RESERVED SANGHWA MICRO Technology      
// -----------------------------------------------------------------------------
// Version and Release information:
// 
// File Name           : Top_DTSDI002.v
// File Revision       : 1.0
//  ----------------------------------------------------------------------------
//  Purpose             : Structural architecture of Example Amba SYstem (EASY)
//                        with File Reader Bus Master and EgMaster.
//  --========================================================================--


`timescale 1ns/1ps

//------------------------------------------------------------------------------
// DTSDI002[ARM7] Address Map
//------------------------------------------------------------------------------
// Full Decoding of the Address Map is performed continuously as a function of
//  HADDR. All unused slots are connected to a Default Slave.

//(Boot mode LOW)
// 0x0000_0000 - 0x0010_0000  Internal FLASH               (HSELS0B    )(SMC alias/Internal Flash) 
// 0x0000_0000 - 0x0010_0000  External SRAM0               (HSELS0R    )

//(Boot mode High )
// 0x0010_0000 - 0x0020_0000  External SRAM0               (HSELS0EM   )
// 0x0010_0000 - 0x0020_0000  Internal Flash               (HSELS0IF   )          

// 0x0020_0000 - 0x0010_0000  External SRAM1               (HSELS0     )
// 0x0030_0000 - 0x0020_0000  External SRAM2               (HSELS1     )
// 0x0040_0000 - 0x0050_0000  External SRAM3               (HSELS2     ) 
// 0x01F0_0000 - 0x01F4_0000  Internal FLASH mirror        (HSELS3     ) 
// 0x01FF_0000 - 0x01FF_8000  Internal 24KB SRAM           (HSELS4     ) 
// 0x01FF_8000 - 0x01FF_8100  Internal FLASH Control       (HSELS5     ) 
// 0x01FF_8100 - 0x01FF_8200  External SRAM Bank Control   (HSELS6     ) 
// 0x01FF_8200 - 0x01FF_8E00  APB                          (HSELS7     ) 
// 0x0050_0000 - 0x1F00_0000  Reserve1                     (HSELS_Resv1) 
// 0x01F4_0000 - 0x01FF_0000  Reserve2                     (HSELS_Resv2) 
// 0x01FF_8E00 - 0x0200_0000  Reserve3                     (HSELS_Resv3) 
// 0x0200_0000 - 0xFFFF_FFFF  Abort                        (HSELS_Abort ) 

// APB address map is:
//
// 0x01FF_8200 - 0x01FF_8300 UART                          (PSELS2)  
// 0x01FF_8300 - 0x01FF_8400 I2C0~1                        (PSELS3)
// 0x01FF_8400 - 0x01FF_8500 Timer 0  ~ 7                  (PSELS4)
// 0x01FF_8500 - 0x01FF_8600 PWM   0  ~ 7                  (PSELS5)  
// 0x01FF_8600 - 0x01FF_8700 PWM   8  ~ 15                 (PSELS6)
// 0x01FF_8700 - 0x01FF_8800 PWM   16 ~ 23                 (PSELS7)  
// 0x01FF_8800 - 0x01FF_8900 PWM   24 ~ 31                 (PSELS8) 
// 0x01FF_8900 - 0x01FF_8A00 WDT                           (PSELS9)
// 0x01FF_8A00 - 0x01FF_8B00 GPIO                          (PSELS10)
// 0x01FF_8B00 - 0x01FF_8C00 VIV                           (PSELS11)
// 0x01FF_8C00 - 0x01FF_8D00 ADC IF                        (PSELS12)
// 0x01FF_8D00 - 0x01FF_8E00 Power manager                 (PSELS13)
//------------------------------------------------------------------------------                                                                                                


module Top_DTSDI002 
(
//XCLKIN       , 
//nReset       , 
SMDATAIN     , 
SMDATAOUT    , 
nSMDATAEN    , 
SMADDR       , 
SMCS         , 
nSMBLS       , 
nSMOEN       , 
TESTREQA     , 
TESTREQB     , 
TESTACK      , 

//nTRST        , 
//TCK          , 
//TDI          , 
//TMS          , 
//TDO          , 
//nTDOEN       , 

COMMRX       , 
COMMTX       , 

GPIN         , 
GPOUT        , 
nGPEN        , 
nGPAFEN      , 
GPAFOUT      , 
GPAFIN       , 

//DTSDI002
//Input
//Test

ARM_RESETi   ,
ARM_OSCi     ,
BOOT_MODE    ,
EINT         ,

//I2C
I2C0_SCL     ,
I2C0_SDA     ,


//J-TAG
ARM_TRST     , 
ARM_TCK      , 
ARM_TDI      , 
ARM_TMS      , 
ARM_TDO      , 
//nTDOEN       , 

//DFT
TEST_MODE    ,
SCANENABLE   , 
SCANINHCLK   , 
SCANOUTHCLK  , 
SCANINPCLK   , 
SCANOUTPCLK
);

// input         nReset;      // Power on reset in
//input         XCLKIN;      // External clock in,    

input         ARM_RESETi  ;  //System Initialization 1us Hel Low
input         ARM_OSCi    ;  // External clock in, System Clock
input         BOOT_MODE   ; 
input [7:0]   EINT        ;

inout [1:0]   I2C0_SCL    ;
inout [1:0]   I2C0_SDA    ;

 
  input  [31:0] SMDATAIN;    // Data from Memory to SMC
  output [31:0] SMDATAOUT;   // Data Bus output from SMC to Memory
  output [3:0]  nSMDATAEN;   // Tri-state I/O pad enable for the byte lanes of
                             //  external memory data bus
  output [25:0] SMADDR;      // External Memory address bus
  output [7:0]  SMCS;        // Memory bank Chip Select output pins
  output [3:0]  nSMBLS;      // Memory device Byte lane enables
  output        nSMOEN;      // Memory Output Enable 
                             //  (complement serves as Write-Enable)
                           
  // TIC test command signals
  input         TESTREQA;    // Test bus request A
  input         TESTREQB;    // Test bus request B
  output        TESTACK;     // Test acknowledge
    

  // ARM7TDMI comms channel debug lines
  output        COMMRX;
  output        COMMTX;

  // GPIO lines
  input  [7:0]  GPIN;        // Inputs
  input  [7:0]  nGPAFEN;     // Outputs
  input  [7:0]  GPAFOUT;     // Output ctrl enables
  output [7:0]  GPOUT;       // H/w ctrl enables
  output [7:0]  nGPEN;       // H/w ctrl inputs
  output [7:0]  GPAFIN;      // H/w ctrl outputs

  // Scan test dummy signals; not connected until scan insertion 
  input         TEST_MODE   ;  //Test
  input         SCANENABLE  ;  // Scan Test Mode Enable   : test_se
  input         SCANINHCLK  ;  // Scan Chain Input (HCLK) : test_si1
  input         SCANINPCLK  ;  // Scan Chain Output(PCLK) : test_si2
  output        SCANOUTHCLK ;  // Scan Chain Input (HCLK) : test_so1
  output        SCANOUTPCLK ;  // Scan Chain Output(PCLK) : test_so2


// JTAG connections
//output        nTDOEN;
input         ARM_TRST ;
input         ARM_TCK  ;
input         ARM_TDI  ;
input         ARM_TMS  ;
output        ARM_TDO  ;

  // Port wires
  wire          TEST_MODE   ;  
  wire          ARM_OSCi    ;
  wire          ARM_RESETi  ;
  wire  [7:0]   EINT        ;
  wire  [1:0]   I2C0_SCL    ;
  wire  [1:0]   I2C0_SDA    ;

  wire   [31:0] SMDATAIN;
  wire   [31:0] SMDATAOUT;
  wire   [3:0]  nSMDATAEN;
  wire   [25:0] SMADDR;
  wire   [7:0]  SMCS;
  wire   [3:0]  nSMBLS;
  wire          nSMOEN;

  wire          TESTREQA;
  wire          TESTREQB;
  wire          TESTACK;


  wire          nTDOEN;

  
  //JTAG
  wire          ARM_TRST ;
  wire          ARM_TCK  ;
  wire          ARM_TDI  ;
  wire          ARM_TMS  ;
  wire          ARM_TDO  ;
  
  

  wire          COMMRX;
  wire          COMMTX;

  wire   [7:0]  GPIN;    
  wire   [7:0]  GPOUT;   
  wire   [7:0]  nGPEN;   
  wire   [7:0]  nGPAFEN; 
  wire   [7:0]  GPAFOUT; 
  wire   [7:0]  GPAFIN;  

  wire          SCANENABLE; 
  wire          SCANINHCLK; 
  wire          SCANOUTHCLK;
  wire          SCANINPCLK; 
  wire          SCANOUTPCLK;

  
//------------------------------------------------------------------------------
// Signal declarations: AHB Common
//------------------------------------------------------------------------------

  wire          HCLK;
  wire          HRESETn;

//------------------------------------------------------------------------------
// Signal declarations: AHB1
//------------------------------------------------------------------------------

// AHB1 backbone 
  wire   [1:0]  HTRANS1;
  wire   [31:0] HADDR1;
  wire          HWRITE1;
  wire   [2:0]  HSIZE1;
  wire   [2:0]  HBURST1;
  wire   [3:0]  HPROT1;
  wire   [31:0] HWDATA1;
  wire   [3:0]  HMASTER1;
  wire   [3:0]  HMASTERD1;
  wire          HMASTLOCK1;
  wire   [15:0] HSPLIT1;

// Multiplexed slave output signals
  wire   [31:0] HRDATA1;
  wire          HREADY1;
  wire   [1:0]  HRESP1;

// Slave specific output signals
  wire          HSELS0B     ;
  wire          HSELS0R     ;
  wire          HSELS0EM    ;
  wire          HSELS0IF    ;
  
  wire          HSELS0      ;
  wire          HSELS1      ;
  wire          HSELS2      ;
  wire          HSELS3      ;
  wire          HSELS4      ;
  wire          HSELS5      ;
  wire          HSELS6      ;
  wire          HSELS7      ;  
  
  wire          HSELS_Resv1 ;
  wire          HSELS_Resv2 ;
  wire          HSELS_Resv3 ;
  wire          HSELS_Abort  ;

  
  wire   [31:0] HRDATA1S0;
  wire          HREADY1S0;
  wire   [1:0]  HRESP1S0;

 
  wire   [31:0] HRDATA1S1;
  wire          HREADY1S1;
  wire   [1:0]  HRESP1S1;


  wire   [31:0] HRDATA1S2;
  wire          HREADY1S2;
  wire   [1:0]  HRESP1S2;


  wire   [31:0] HRDATA1S3;
  wire          HREADY1S3;
  wire   [1:0]  HRESP1S3;

 
  wire   [31:0] HRDATA1S4;
  wire          HREADY1S4;
  wire   [1:0]  HRESP1S4;

 
  wire   [31:0] HRDATA1S5;
  wire          HREADY1S5;
  wire   [1:0]  HRESP1S5;

  
  wire   [31:0] HRDATA1S6;
  wire          HREADY1S6;
  wire   [1:0]  HRESP1S6;

//  wire          HSEL1S7;
  wire   [31:0] HRDATA1S7;
  wire          HREADY1S7;
  wire   [1:0]  HRESP1S7;

  wire          HREADY1DefSlv;
  wire   [1:0]  HRESP1DefSlv;

// Miscellaneous AHB select lines
  wire          HSEL1DefSlv;
  wire          HSELExtSRAM0;
  wire          HSEL_SMC_Flash;
  wire          HSEL1bridge;

// Master specific signals
  wire          HBUSREQ1M0;
  wire          HLOCK1M0;
  wire          HGRANT1M0;

  wire   [31:0] HADDR1M1;
  wire   [1:0]  HTRANS1M1;
  wire          HWRITE1M1;
  wire   [2:0]  HSIZE1M1;
  wire   [2:0]  HBURST1M1;
  wire   [3:0]  HPROT1M1;
  wire   [31:0] HWDATA1M1;
  wire          HBUSREQ1M1;
  wire          HLOCK1M1;
  wire          HGRANT1M1;

  wire   [31:0] HADDR1M2;
  wire   [1:0]  HTRANS1M2;
  wire          HWRITE1M2;
  wire   [2:0]  HSIZE1M2;
  wire   [2:0]  HBURST1M2;
  wire   [3:0]  HPROT1M2;
  wire   [31:0] HWDATA1M2;
  wire          HBUSREQ1M2;
  wire          HLOCK1M2;
  wire          HGRANT1M2;

  wire   [31:0] HADDR1M3;
  wire   [1:0]  HTRANS1M3;
  wire          HWRITE1M3;
  wire   [2:0]  HSIZE1M3;
  wire   [2:0]  HBURST1M3;
  wire   [3:0]  HPROT1M3;
  wire   [31:0] HWDATA1M3;
  wire          HBUSREQ1M3;
  wire          HLOCK1M3;
  wire          HGRANT1M3;

//------------------------------------------------------------------------------
// Signal declarations: AHB2
//------------------------------------------------------------------------------

// AHB2 backbone 
  wire   [1:0]  HTRANS2;
  wire   [31:0] HADDR2;
  wire          HWRITE2;
  wire   [2:0]  HSIZE2;
  wire   [2:0]  HBURST2;
  wire   [3:0]  HPROT2;
  wire   [31:0] HWDATA2;
  wire   [3:0]  HMASTER2;
  wire   [3:0]  HMASTERD2;
  wire          HMASTLOCK2;
  wire   [15:0] HSPLIT2;

// Multiplexed slave output signals
  wire   [31:0] HRDATA2;
  wire          HREADY2;
  wire   [1:0]  HRESP2;

// Slave specific output signals
  wire          HSEL2S0B;
  wire          HSEL2S0R;

  wire          HSEL2S0;
  wire   [31:0] HRDATA2S0;
  wire          HREADY2S0;
  wire   [1:0]  HRESP2S0;

  wire          HSEL2S1;
  wire   [31:0] HRDATA2S1;
  wire          HREADY2S1;
  wire   [1:0]  HRESP2S1;

  wire          HSEL2S2;
  wire   [31:0] HRDATA2S2;
  wire          HREADY2S2;
  wire   [1:0]  HRESP2S2;

  wire          HSEL2S3;
  wire   [31:0] HRDATA2S3;
  wire          HREADY2S3;
  wire   [1:0]  HRESP2S3;

  wire          HSEL2S4;
  wire   [31:0] HRDATA2S4;
  wire          HREADY2S4;
  wire   [1:0]  HRESP2S4;

  wire          HSEL2S5;
  wire   [31:0] HRDATA2S5;
  wire          HREADY2S5;
  wire   [1:0]  HRESP2S5;

  wire          HSEL2S6;
  wire   [31:0] HRDATA2S6;
  wire          HREADY2S6;
  wire   [1:0]  HRESP2S6;

  wire          HSEL2S7;
  wire   [31:0] HRDATA2S7;
  wire          HREADY2S7;
  wire   [1:0]  HRESP2S7;

  wire          HSEL2S8;
  wire          HSEL2S9;
  wire          HSEL2S10;
  wire          HSEL2S11;
  wire          HSEL2S12;
  wire          HSEL2S13;
  wire          HSEL2S14;
  wire          HSEL2S15;

  wire          HREADY2DefSlv;
  wire   [1:0]  HRESP2DefSlv;

// Miscellaneous AHB select lines
  wire          HSEL2DefSlv;

// Master specific signals
  wire          HBUSREQ2M0;
  wire          HLOCK2M0;
  wire          HGRANT2M0;

  wire   [31:0] HADDR2M1;
  wire   [1:0]  HTRANS2M1;
  wire          HWRITE2M1;
  wire   [2:0]  HSIZE2M1;
  wire   [2:0]  HBURST2M1;
  wire   [3:0]  HPROT2M1;
  wire   [31:0] HWDATA2M1;
  wire          HBUSREQ2M1;
  wire          HLOCK2M1;
  wire          HGRANT2M1;

  wire   [31:0] HADDR2M2;
  wire   [1:0]  HTRANS2M2;
  wire          HWRITE2M2;
  wire   [2:0]  HSIZE2M2;
  wire   [2:0]  HBURST2M2;
  wire   [3:0]  HPROT2M2;
  wire   [31:0] HWDATA2M2;
  wire          HBUSREQ2M2;
  wire          HLOCK2M2;
  wire          HGRANT2M2;

  wire   [31:0] HADDR2M3;
  wire   [1:0]  HTRANS2M3;
  wire          HWRITE2M3;
  wire   [2:0]  HSIZE2M3;
  wire   [2:0]  HBURST2M3;
  wire   [3:0]  HPROT2M3;
  wire   [31:0] HWDATA2M3;
  wire          HBUSREQ2M3;
  wire          HLOCK2M3;
  wire          HGRANT2M3;

//------------------------------------------------------------------------------
// Signal declarations: APB
//------------------------------------------------------------------------------

// APB backbone
  wire          PENABLE;
 // wire   [23:0] PADDR;
  wire   [7:0] PADDR;
  wire          PWRITE;
  wire   [31:0] PWDATA;
  wire   [31:0] PRDATA;

// Slave-select lines
  wire          PSELS0;
  wire          PSELS1;
  wire          PSELS2;
  wire          PSELS3;
  wire          PSELS4;
  wire          PSELS5;
  wire          PSELS6;
  wire          PSELS7;
  wire          PSELS8;
  wire          PSELS9;
  wire          PSELS10;
  wire          PSELS11;
  wire          PSELS12;
  wire          PSELS13;
  wire          PSELS14;
  wire          PSELS15;

// Slave read-data outputs
  wire   [31:0] PRDATAS0;
  wire   [31:0] PRDATAS1;
  wire   [31:0] PRDATAS2;
  wire   [31:0] PRDATAS3;
  wire   [31:0] PRDATAS4;
  wire   [31:0] PRDATAS5;
  wire   [31:0] PRDATAS6;
  wire   [31:0] PRDATAS7;
  wire   [31:0] PRDATAS8;
  wire   [31:0] PRDATAS9;
  wire   [31:0] PRDATAS10;
  wire   [31:0] PRDATAS11;
  wire   [31:0] PRDATAS12;
  wire   [31:0] PRDATAS13;
  wire   [31:0] PRDATAS14;
  wire   [31:0] PRDATAS15;

//------------------------------------------------------------------------------
// Signal declarations: System specific
//------------------------------------------------------------------------------

// Timer interrupt lines
  wire          TIMINT1;    // Timer interrupt 1 
  wire          TIMINT2;    // Timer interrupt 2 
  wire          TIMINTC;    // Combined timer interrupt 

// Watchdog interrupt line
  wire          WDOGINT;

// Watchdog reset lines
  wire          WDOGRESn;   // Input   
  wire          WDOGRES;    // Output 

// GPIO signals
  wire          GPIOINTR;   // GPIO interrupt 
  wire   [7:0]  GPIOMIS;    // GPIO interrupt bus 

// System interrupt bus
  wire   [31:0] IntSource;

// Fast interrupt request output from Interrupt Controller
  wire          nFIQ;

// Interrupt request output from Interrupt Controller
  wire          nIRQ;

// Interrupt controller vector address
  wire   [31:0] ICVECTADDROUT;

// Remap and Pause controller
//  wire          Remap;
    wire          Pause;
    wire          BOOT_MODE;

// Unused SMI outputs
  wire          TICBUSREQEBI;
  wire          SMBUSREQEBI;
  wire          MCBUSGNT;
  wire          nSMWEN;
  wire          TICREADEBI;
  wire   [31:0] TBUSOUTEBI;

// Test bus signals
  wire          HSELtst;
  wire          HBUSREQtst;
  reg           HGRANTtst;
  wire   [31:0] HADDRtst;
  wire   [1:0]  HTRANStst;
  wire   [2:0]  HBURSTtst;
  wire   [2:0]  HSIZEtst;
  wire          HWRITEtst;
  wire   [31:0] HWDATAtst;
  wire   [3:0]  HPROTtst;
  wire          HLOCKtst;
  wire          HREADYtst;
  wire   [1:0]  HRESPtst;
  wire   [31:0] HRDATAtst;

//------------------------------------------------------------------------------
// Signal declarations: Scan chain
//------------------------------------------------------------------------------
  wire          SCANINa7tdmi;
  wire          SCANOUTa7tdmi;
  wire          SCANINtimers;
  wire          SCANOUTtimers;
  wire          SCANINwdog;
  wire          SCANOUTwdog;
  wire          SCANINrpc;
  wire          SCANOUTrpc;
  wire          SCANINic;
  wire          SCANOUTic;
  wire          SCANINgpio;
  wire          SCANOUTgpio;
  wire          SCANINegapb;
  wire          SCANOUTegapb;
  wire          SCANINarb1;
  wire          SCANOUTarb1;
  wire          SCANINdefslv1;
  wire          SCANOUTdefslv1;
  wire          SCANINs2m1;
  wire          SCANOUTs2m1;
  wire          SCANINarb2;
  wire          SCANOUTarb2;
  wire          SCANINdefslv2;
  wire          SCANOUTdefslv2;
  wire          SCANINs2m2;
  wire          SCANOUTs2m2;
  wire          SCANINegmst;
  wire          SCANOUTegmst;
  wire          SCANINretry;
  wire          SCANOUTretry;
  wire          SCANINapb;
  wire          SCANOUTapb;
  wire          SCANINahbbr;
  wire          SCANOUTahbbr;
  wire          SCANINsmi;
  wire          SCANOUTsmi;
  wire          SCANINnsmi;
  wire          SCANOUTnsmi;

//------------------------------------------------------------------------------
// Signal declarations: Tie-offs
//------------------------------------------------------------------------------
// The TieOff signals must be assigned explicitly within the body of the RTL.
// Using initial values (in the signal declaration, above) will not work in
// Synopsys. Signals are used rather than constants as constants can not be 
// connected directly to sub-component instantiations
  wire          TieOffHi1  = 1'b1 ;
  wire          TieOffLo1  = 1'b0 ;
  wire   [1:0]  TieOffLo2  = 2'b00;
  wire   [3:0]  TieOffLo4  = 4'b0000;
  wire   [25:0] TieOffLo26 = {26{1'b0}};
  wire   [31:0] TieOffLo32 = {32{1'b0}};

//Fucntion Signal
//Power& Clock Mangement
  wire           Sys_CLK_O    ;
  wire           UART_CLK_O   ;
  wire           GIE_O        ;
  wire           UART_INT_SEL ;
  wire           AD_CLK_O     ;
  
//------------------------------------------------------------------------------
// Beginning of main code
//------------------------------------------------------------------------------


// Drive the AHB clock with the external clock input.
//assign HCLK = ARM_OSCi;
// Drive the AHB clock with the Internal clock input[APB_PowerManager].
  assign HCLK = Sys_CLK_O;

// Common reset controller
  Reset_Controller uResetCntl
    (
     .HCLK     (HCLK),
    // .nPOReset (nReset),
     .nPOReset (ARM_RESETi),
     .WDOGRES  (WDOGRES),
     .HRESETn  (HRESETn),
     .WDOGRESn (WDOGRESn)
    );

//------------------------------------------------------------------------------
// AHB System 
//------------------------------------------------------------------------------

// ARM7TDMI core wrapper, instantiated as master 1 on AHB1 (lowest priority).
// The Test interface is connected to the TIC via a separate AHB test bus
/*  A7TDMI uA7TDMI
    (
     // Common AHB Signals
     .HCLK       (HCLK),
     .HRESETn    (HRESETn),

     // Signals to AMBA bus used during normal operation
     .HBUSREQM   (HBUSREQ1M1),
     .HGRANTM    (HGRANT1M1),
     .HADDRM     (HADDR1M1),
     .HTRANSM    (HTRANS1M1),
     .HWRITEM    (HWRITE1M1),
     .HSIZEM     (HSIZE1M1),
     .HBURSTM    (HBURST1M1),
     .HPROTM     (HPROT1M1),
     .HWDATAM    (HWDATA1M1),
     .HLOCKM     (HLOCK1M1),

     // Signals from AMBA bus used during normal operation
     .HRDATAM    (HRDATA1),
     .HREADYM    (HREADY1),
     .HRESPM     (HRESP1),

     // Signals from AMBA bus used during test mode
     .HSELS      (HSELtst),
     .HTRANS1S   (HTRANStst[1]),
     .HWRITES    (HWRITEtst),
     .HWDATAS    (HWDATAtst),
     .HREADYS    (HREADYtst), // HREADYOUT (test) is fed-back  


     // Signals to AMBA bus used during test mode
     .HRDATAS    (HRDATAtst),
     .HREADYOUTS (HREADYtst),
     .HRESPS     (HRESPtst),

     // ARM7TDMI interrupts
     .ARMNFIQ    (nFIQ),
     .ARMNIRQ    (nIRQ),

     // Comms channel signals
     .COMMRX     (COMMRX),
     .COMMTX     (COMMTX),

      // J-TAG connections
     .nTRST      (ARM_TRST),
     .TCK        (ARM_TCK),
     .TDI        (ARM_TDI),
     .TMS        (ARM_TMS),
     .TDO        (ARM_TDO),
     .nTDOEN     (nTDOEN),
    
     
      // Scan test dummy signals; not connected until scan insertion 
     .SCANENABLE    (SCANENABLE),     // Scan Test Mode Enbl
     .SCANINHCLK    (SCANINa7tdmi),       // Scan Chain Input
     .SCANOUTHCLK   (SCANOUTa7tdmi)       // Scan Chain Output
    );
*/
  // File Reader Bus Master instantiated as AHB master 1 (lowest priority)
  FileReader_DTS
  // synopsys translate_off
    // Parameter:
    //   Default file name: InputFileName = "filestim.frd"
    //#("filestim.frd")
     #("DTSD_Filestim.frd")
  // synopsys translate_on
  uFileReader 
    (
     .HCLK    (HCLK),
     .HRESETn (WDOGRESn),  // Not reset via HRESETn, to allow Reset test
     
     .HGRANT  (HGRANT1M1),
     //.HREADY  (HREADY1),
     //.HRESP   (HRESP1),
    
     .HREADY  (TieOffHi1),
     .HRESP   (TieOffLo2),
     .HRDATA  (HRDATA1),

     .HBUSREQ (HBUSREQ1M1),
     .HTRANS  (HTRANS1M1),
     .HBURST  (HBURST1M1),
     .HPROT   (HPROT1M1),
     .HSIZE   (HSIZE1M1),
     .HWRITE  (HWRITE1M1),
     .HLOCK   (HLOCK1M1),
     .HADDR   (HADDR1M1),
     .HWDATA  (HWDATA1M1)
    );
// The Static Memory Interface, instantiated as slave 3 on AHB1 (aliased to 
//  Slot 0 at boot). Also incorporates the Test Interface Controller (master
//  on separate AHBtst bus)
//SMC replace
  SMI uSMI
    (
     // Common AHB signals
     .HCLK         (HCLK),
     .HRESETn      (HRESETn),

     .nHCLK        (TieOffLo1),         // Not used

     // SMI slave interface signals (AHB)
     .HADDR        (HADDR1[28:0]),
     .HBURST       (HBURST1),           // Not used
     .HTRANS       (HTRANS1),
     .HWRITE       (HWRITE1),
     .HSIZE        (HSIZE1),
     .HWDATA       (HWDATA1),
     .HREADYIN     (HREADY1),

     .HSELSMC      (HSEL_SMC_Flash),          // Decoder slots 0 (boot) and 3
     .HSELREG      (TieOffLo1),         // Not used

     .HRDATA       (HRDATA1S1),         // Channel 1 of uMuxMtoS1
     .HREADYOUT    (HREADY1S1),
     .HRESP        (HRESP1S1),

     .BIGENDIAN    (TieOffLo1),         // Not used
    // .REMAP        (Remap),
     .REMAP        (BOOT_MODE),
      
     .MCBUSREQ     (TieOffLo1),         // Not used
     .MCBUSGNT     (MCBUSGNT),          // Not used
     .MCADDR       (TieOffLo26),        // Not used
     .MCDATAOUT    (TieOffLo32),        // Not used
     .MCDATAEN     (TieOffLo4),         // Not used

     .EXTBUSMUX    (TieOffLo1),         // Not used

     // Top-level interface signals
     .SMBUSREQEBI  (SMBUSREQEBI),       // Not used
     .SMBUSGNTEBI  (TieOffLo1),         // Not used
     .SMDATAIN     (SMDATAIN),          // Data from Memory to SMI
     .SMDATAOUT    (SMDATAOUT),         // Data from SMI to Memory
     .nSMDATAEN    (nSMDATAEN),         // Data tri-state pad en
     .SMADDR       (SMADDR),            // External address bus
     .SMCS         (SMCS),              // External chip selects
     .nSMBLS       (nSMBLS),            // External byte lane write en
     .nSMWEN       (nSMWEN),            // Not used
     .nSMOEN       (nSMOEN),            // External read enable
     .SMWAIT       (TieOffLo1),         // Not used
     .CANCELSMWAIT (TieOffLo1),         // Not used
     .SMMWCS7      (TieOffLo2),         // Not used

     // TIC test command signals
     .TESTREQA     (TESTREQA),
     .TESTREQB     (TESTREQB),
     .TESTACK      (TESTACK),

     // TIC master interface signals (AHBtst)
     .HBUSREQTIC   (HBUSREQtst),
     .HGRANTTIC    (HGRANTtst),

     .HADDRTIC     (HADDRtst),
     .HTRANSTIC    (HTRANStst),
     .HWRITETIC    (HWRITEtst),
     .HSIZETIC     (HSIZEtst),
     .HBURSTTIC    (HBURSTtst),
     .HPROTTIC     (HPROTtst),
     .HWDATATIC    (HWDATAtst),
     .HLOCKTIC     (HLOCKtst),

     .HREADYINTIC  (HREADYtst),
     .HRESPTIC     (HRESPtst),
     .HRDATATIC    (HRDATAtst),

     .TICBUSREQEBI (TICBUSREQEBI),      // Not used
     .TICBUSGNTEBI (TieOffLo1),         // Not used
     .TICREADEBI   (TICREADEBI),        // Not used
     .TBUSOUTEBI   (TBUSOUTEBI),        // Not used

      // Scan test dummy signals; not connected until scan insertion 
     .SCANENABLE   (SCANENABLE),        
     .SCANINHCLK   (SCANINsmi),         // Rising edge sample
     .SCANINnHCLK  (SCANINnsmi),        // Falling edge sample
     .SCANOUTHCLK  (SCANOUTsmi),        // Rising edge update
     .SCANOUTnHCLK (SCANOUTnsmi)        // Falling edge update
    );

// Internal Memory instantiated as AHB slave 7 and 0 (after re-map)
  IntMem     
  // synopsys translate_off
    // Parameters:
    //   Memory size in address bits: MemBits = 10
    //   Memory initialisation file name: FileName = "intram.dat"     
    #(10, "intram.dat")
  // synopsys translate_on
  uIntMem 
    (
     .HCLK       (HCLK),
     .HRESETn    (HRESETn),

     .HADDR      (HADDR1),
     .HTRANS     (HTRANS1),
     .HWRITE     (HWRITE1),
     .HSIZE      (HSIZE1),
     .HWDATA     (HWDATA1),

     .HSELIntMem (HSELExtSRAM0),
     .HREADY     (HREADY1),

     .HRDATA     (HRDATA1S0), // Channel 0 of uMuxMtoS1
     .HREADYOUT  (HREADY1S0),
     .HRESP      (HRESP1S0)
    );

// Interrupt Controller instantiated as AHB slave 15
  Interrupt uInterrupt
    (
     .HCLK          (HCLK),
     .HRESETn       (HRESETn),

     .HADDR         (HADDR1[11:2]),
     .HTRANS        (HTRANS1[1]),
     .HWRITE        (HWRITE1),
     .HSIZE         (HSIZE1),
     .HPROT         (HPROT1[1]),      // Privileged access
     .HWDATA        (HWDATA1),
     .HREADY        (HREADY1),

     .HSELIC        (HSEL1S15),
     .HRDATA        (HRDATA1S3),      // Channel 3 of uMuxMtoS1
     .HRESP         (HRESP1S3),
     .HREADYOUT     (HREADY1S3),

     .ICINTSOURCE   (IntSource),      // System interrupts
     .nICFIQIN      (TieOffHi1),      // Connect daisy-chained
     .nICIRQIN      (TieOffHi1),      //  interrupt controllers here
     .ICVECTADDRIN  (TieOffLo32),
     .nICFIQ        (nFIQ),
     .nICIRQ        (nIRQ),
     .ICVECTADDROUT (ICVECTADDROUT),  // Not used

      // Scan test dummy signals; not connected until scan insertion 
     .SCANENABLE    (SCANENABLE),     // Scan Test Mode Enbl
     .SCANINHCLK    (SCANINic),       // Scan Chain Input
     .SCANOUTHCLK   (SCANOUTic)       // Scan Chain Output
    );

  assign IntSource = 
    {GPIOMIS,        // 31:24 GPIO Masked interrupts
     4'b0000,        // 23:20
     4'b0000,        // 19:16
     4'b0000,        // 15:12
     3'b000,         // 11:9
     GPIOINTR,       // 8     GPIO Combined interrupt
     WDOGINT,        // 7     Watchdog
     TIMINTC,        // 6     Counter combined
     TIMINT2,        // 5     Counter 2
     TIMINT1,        // 4     Counter 1
     1'b0,           // 3     Undefined (ARM Comms Tx)
     1'b0,           // 2     Undefined (ARM Comms Rx)
     1'b0,           // 1     Software interrupt
     1'b0};          // 0     Undefined



//------------------------------------------------------------------------------
// AHB System 2
//------------------------------------------------------------------------------

// Example Bus Master instantiated as master 2 on AHB2
 EgMaster     
  // synopsys translate_off
    // Parameters:
    //   Block enable: EBMenable = 1, 
    //   Base address read: EBMreadAddr = 0xD0000000 (RetrySlave),
    //   Base address write: EBMwriteAddr = 0xD0000000 (RetrySlave),
    //   Delay between transactions: EBMinitCount = 4
    #(1, 8'hD0, 8'hD0, 10'h004)
  // synopsys translate_on
 uEgMaster 
    (
     .HCLK        (HCLK),
     .HRESETn     (HRESETn),

     .HBUSREQ     (HBUSREQ2M2),
     .HGRANT      (HGRANT2M2),

     .HADDR       (HADDR2M2),
     .HTRANS      (HTRANS2M2),
     .HWRITE      (HWRITE2M2),
     .HSIZE       (HSIZE2M2),
     .HBURST      (HBURST2M2),
     .HPROT       (HPROT2M2),
     .HWDATA      (HWDATA2M2),
     .HLOCK       (HLOCK2M2),

     .HRDATA      (HRDATA2),
     .HREADY      (HREADY2),
     .HRESP       (HRESP2),

      // Scan test dummy signals; not connected until scan insertion 
     .SCANENABLE  (SCANENABLE),  // Scan Test Mode Enbl
     .SCANINHCLK  (SCANINegmst), // Scan Chain Input
     .SCANOUTHCLK (SCANOUTegmst) // Scan Chain Output
    );

// APB peripherals instantiated as slave 12 on AHB
  APBif_DST uAPBif
    (
     .HCLK        (HCLK),
     .HRESETn     (HRESETn),

     //.HADDR       (HADDR2[27:0]),
     .HADDR       (HADDR1[31:0]),
     .HTRANS      (HTRANS1),
     .HWRITE      (HWRITE1),
     .HWDATA      (HWDATA1),
     //.HSEL        (HSEL2S12),
     .HSEL        (HSELS7),
     .HREADY      (HREADY1),

     .HRDATA      (HRDATA2S0), // Channel 0 of uMuxMtoS2
     .HREADYOUT   (HREADY2S0),
     .HRESP       (HRESP2S0),

     .PRDATA      (PRDATA),    // From MuxP2B output

     .PWDATA      (PWDATA),
     .PADDR       (PADDR),
     .PWRITE      (PWRITE),
     .PENABLE     (PENABLE),
     .PSELS0      (PSELS0),    // To APB slaves and MuxP2B
     .PSELS1      (PSELS1),
     .PSELS2      (PSELS2),
     .PSELS3      (PSELS3),
     .PSELS4      (PSELS4),
     .PSELS5      (PSELS5),
     .PSELS6      (PSELS6),
     .PSELS7      (PSELS7),
     .PSELS8      (PSELS8),
     .PSELS9      (PSELS9),
     .PSELS10     (PSELS10),
     .PSELS11     (PSELS11),
     .PSELS12     (PSELS12),
     .PSELS13     (PSELS13),
     .PSELS14     (PSELS14),
     .PSELS15     (PSELS15),
  
      // Scan test dummy signals; not connected until scan insertion 
     .SCANENABLE  (SCANENABLE), // Scan Test Mode Enbl
     .SCANINHCLK  (SCANINapb),  // Scan Chain Input
     .SCANOUTHCLK (SCANOUTapb)  // Scan Chain Output
    );

// Retry Slave instantiated as slave 13 on AHB2
  RetrySlave uRetrySlave
    (
     .HCLK        (HCLK),
     .HRESETn     (HRESETn),

     .HADDR       (HADDR2),
     .HTRANS      (HTRANS2),
     .HWRITE      (HWRITE2),
     .HSIZE       (HSIZE2),
     .HWDATA      (HWDATA2),
     .HSELRetry   (HSEL2S13),
     .HREADY      (HREADY2),

     .HRDATA      (HRDATA2S1),   // Channel 1 of uMuxMtoS2
     .HREADYOUT   (HREADY2S1),
     .HRESP       (HRESP2S1),

      // Scan test dummy signals; not connected until scan insertion 
     .SCANENABLE  (SCANENABLE),  // Scan Test Mode Enbl
     .SCANINHCLK  (SCANINretry), // Scan Chain Input
     .SCANOUTHCLK (SCANOUTretry) // Scan Chain Output
    );

//------------------------------------------------------------------------------
// AHB Infrastructure
//------------------------------------------------------------------------------

// TIC control logic -----------------------------------------------------------

  // Since TIC is the only master on the test bus, it can be granted as soon
  //  as a request is asserted. Note that HGRANTtst is not constantly asserted
  //  for power reasons
  always @ (negedge HRESETn or posedge HCLK)
    begin : p_HGRANTtstSeq
      if  (!HRESETn)
        HGRANTtst <= 1'b0;
      else
        HGRANTtst <= HBUSREQtst;
    end 

  // Decode TIC address to create slave select signal to ARM core. Note that
  //  TIC tests from ARM will assume a base address of either 0xC0000000 or
  //  0x50000000 - the following is therefore a generic solution
  assign HSELtst = ((HADDRtst [31:28] != 4'b0000) ? 1'b1 : 1'b0);

// AHB1 System Infrastructure --------------------------------------------------

// AHB1 system Arbiter
  Arbiter3 uArbiterBus1
    (
     .HCLK        (HCLK),
     .HRESETn     (HRESETn),

     .HTRANS      (HTRANS1),
     .HBURST      (HBURST1),
     .HREADY      (HREADY1),
     .HRESP       (HRESP1),

     .HBUSREQM3   (HBUSREQ1M3),
     .HBUSREQM2   (HBUSREQ1M2),
     .HBUSREQM1   (HBUSREQ1M1),
     .HBUSREQM0   (HBUSREQ1M0),

     .HLOCKM3     (HLOCK1M3),
     .HLOCKM2     (HLOCK1M2),
     .HLOCKM1     (HLOCK1M1),
     .HLOCKM0     (HLOCK1M0),

     .HSPLIT      (HSPLIT1[3:0]),

     .HGRANTM3    (HGRANT1M3),
     .HGRANTM2    (HGRANT1M2),
     .HGRANTM1    (HGRANT1M1),
     .HGRANTM0    (HGRANT1M0),

     .HMASTER     (HMASTER1),
     .HMASTERD    (HMASTERD1),
     .HMASTLOCK   (HMASTLOCK1),
      
      // Scan test dummy signals; not connected until scan insertion 
     .SCANENABLE  (SCANENABLE), // Scan Test Mode Enbl
     .SCANINHCLK  (SCANINarb1), // Scan Chain Input
     .SCANOUTHCLK (SCANOUTarb1) // Scan Chain Output
    );

  // Pause requests Master 0 (2nd highest priority)
  assign HBUSREQ1M0 = Pause;

  // Unconnected Arbiter inputs driven LOW
  assign HBUSREQ1M0 = 1'b0;
  assign HBUSREQ1M2 = 1'b0;
  assign HBUSREQ1M3  = 1'b0;
  
  assign HLOCK1M3   = 1'b0;
  assign HLOCK1M2   = 1'b0;
  assign HLOCK1M0   = 1'b0;
  
  assign HSPLIT1    = {16{1'b0}};

   // Unconnected Arbiter inputs driven LOW
  assign HBUSREQM3 = 1'b0;
  assign HLOCKM3   = 1'b0;
  assign HLOCKM0   = 1'b0;
  assign HSPLIT    = {16{1'b0}};

// AHB system Address Decoder 
  System_Decoder uDecoder
    (
     // Upper order bits of the address bus for the decode function
     //.HADDR   (HADDR1[31:20]),
     .HADDR       (HADDR1[31:0] ),
     // Status of the system re-map
     .Remap       (BOOT_MODE    ),
     // Select lines produced by Boot Mode :0x0000_0000 ~ 0x0010_0000
     .HSELS0B     (HSELS0B      ),   // Internal Flash  :0x0000_0000 ~ 0x0010_0000    
     .HSELS0R     (HSELS0R      ),   // External SRAM   :0x0000_0000 ~ 0x0010_0000
     .HSELS0EM    (HSELS0EM     ),   // External SRAM   :0x0010_0000 ~ 0x0020_0000
     .HSELS0IF    (HSELS0IF     ),   // Internal Flash  :0x0010_0000 ~ 0x0020_0000                  
     
     .HSELS0      (HSELS0       ),   // External SRAM1                   : 0x0020_0000 ~ 0x0010_0000
     .HSELS1      (HSELS1       ),   // External SRAM2                   : 0x0030_0000 ~ 0x0020_0000
     .HSELS2      (HSELS2       ),   // External SRAM3                   : 0x0040_0000 ~ 0x0050_0000
     .HSELS3      (HSELS3       ),   //Internal FLASH mirror             : 0x01F0_0000 ~ 0x01F4_0000
     .HSELS4      (HSELS4       ),   //Internal 24KB SRAM                : 0x01FF_0000 ~ 0x01FF_8000
     .HSELS5      (HSELS5       ),   //Internal FLASH Control            : 0x01FF_8000 ~ 0x01FF_8100
     .HSELS6      (HSELS6       ),   //External SRAM Bank Control        : 0x01FF_8100 ~ 0x01FF_8200
     .HSELS7      (HSELS7       ),   //APB                               : 0x01FF_8200 ~ 0x01FF_8E00
     .HSELS_Resv1 (HSELS_Resv1  ),   //Reserve1                          : 0x0050_0000 ~ 0x1F00_0000
     .HSELS_Resv2 (HSELS_Resv2  ),   //Reserve2                          : 0x01F4_0000 ~ 0x01FF_0000
     .HSELS_Resv3 (HSELS_Resv3  ),   //Reserve3                          : 0x01FF_8E00 ~ 0x0200_0000
     .HSELS_Abort (HSELS_Abort   )    //Abort                             : 0x0200_0000 ~ 0xFFFF_FFFF
    );

// Default Slave selected by all unused HSEL lines                       
  assign HSEL1DefSlv = 
    HSELS_Resv1 |  //Reserve1                          
    HSELS_Resv2 |  //Reserve2                          
    HSELS_Resv3 |  //Reserve3                          
    HSELS_Abort     //Abort      
    ;

  // SMI occupies Slot 3 or Slot 0 (at boot) 
  //assign HSEL1Smi = (HSEL1S0B | HSEL1S3);
  // [FLASH SMC] occupies FLASH mirror, Flash Control, HSELS0B (Boot mode=0), HSELOIF(Boot mode = 1) 
  assign HSEL_SMC_Flash = (HSELS0B | HSELS3 | HSELS5 | HSELS0IF);
  
  // Internal Memory occupies Slot 7 and Slot 0 (after re-map)
  // assign HSEL1IntMem = (HSEL1S7 | HSEL1S0R);
  // [External SRAM0] occupies External HSELOR(Boot mode = 1),HSELS0EM(Boot mode =0 )
  assign HSELExtSRAM0 =  ( HSELS0R | HSELS0EM );

// Default Slave 1 (selected when no other slaves are accessed on AHB1)
  DefaultSlave uDefaultSlave1
    (
     .HCLK        (HCLK),
     .HRESETn     (HRESETn),

     .HTRANS      (HTRANS1),
     .HSEL        (HSEL1DefSlv),
     .HREADY      (HREADY1),

     .HREADYOUT   (HREADY1DefSlv),
     .HRESP       (HRESP1DefSlv),

      // Scan test dummy signals; not connected until scan insertion 
     .SCANENABLE  (SCANENABLE),    // Scan Test Mode Enbl
     .SCANINHCLK  (SCANINdefslv1), // Scan Chain Input
     .SCANOUTHCLK (SCANOUTdefslv1) // Scan Chain Output
    );

// Central multiplexer - masters to slaves on AHB
  MuxM2S uMuxM2S
    (
     .HMASTER  (HMASTER1),
     .HMASTERD (HMASTERD1),
      
     .HADDRM1  (HADDR1M1),
     .HTRANSM1 (HTRANS1M1),
     .HWRITEM1 (HWRITE1M1),
     .HSIZEM1  (HSIZE1M1),
     .HBURSTM1 (HBURST1M1),
     .HPROTM1  (HPROT1M1),
     .HWDATAM1 (HWDATA1M1),
      
     .HADDRM2  (HADDR1M2),
     .HTRANSM2 (HTRANS1M2),
     .HWRITEM2 (HWRITE1M2),
     .HSIZEM2  (HSIZE1M2),
     .HBURSTM2 (HBURST1M2),
     .HPROTM2  (HPROT1M2),
     .HWDATAM2 (HWDATA1M2),
      
     .HADDRM3  (HADDR1M3),
     .HTRANSM3 (HTRANS1M3),
     .HWRITEM3 (HWRITE1M3),
     .HSIZEM3  (HSIZE1M3),
     .HBURSTM3 (HBURST1M3),
     .HPROTM3  (HPROT1M3),
     .HWDATAM3 (HWDATA1M3),
      
     .HADDR    (HADDR1),
     .HTRANS   (HTRANS1),
     .HWRITE   (HWRITE1),
     .HSIZE    (HSIZE1),
     .HBURST   (HBURST1),
     .HPROT    (HPROT1),
     .HWDATA   (HWDATA1)
    );

  // Unconnected MUX inputs
 assign HADDR1M3  = {32{1'b0}};
  assign HTRANS1M3 = 2'b00;
  assign HWRITE1M3 = 1'b0;
  assign HSIZE1M3  = 3'b000;
  assign HBURST1M3 = 3'b000;
  assign HPROT1M3  = 4'b0000;
  assign HWDATA1M3 = {32{1'b0}};
  
//TIC Master
  assign HADDR1M2  = {32{1'b0}};
  assign HTRANS1M2 = 2'b00;
  assign HWRITE1M2 = 1'b0;
  assign HSIZE1M2  = 3'b000;
  assign HBURST1M2 = 3'b000;
  assign HPROT1M2  = 4'b0000;
  assign HWDATA1M2 = {32{1'b0}};


// Local multiplexer - slaves to masters on AHB1
//  This 8-input multiplexor is used in place of the 16-input version 
//  because it is faster to synthesise. However, in this application,
//  the input channel names do not always match the names of the signals
//  they are assigned to, though the multiplexor operation is unaffected.
  MuxS2M uMuxStoM1
    (
     .HCLK          (HCLK),
     .HRESETn       (HRESETn),

     .HSELS0        (HSELExtSRAM0),  // Decoder slots 7 and 0 (after re-map)
     .HSELS1        (HSEL_SMC_Flash),     // Decoder slots 3 and 0 (at boot)
     .HSELS2        (HSEL1bridge),  // Decoder slots 12 and 13
     .HSELS3        (HSEL1S15),     // Decoder slot 15
     .HSELS4        (HSELS4),
     .HSELS5        (HSELS5),
     .HSELS6        (HSELS6),
     .HSELS7        (HSELS7),
     .HSELDefault   (HSEL1DefSlv),

     .HRDATAS0      (HRDATA1S0),    // IntMem
     .HREADYS0      (HREADY1S0),
     .HRESPS0       (HRESP1S0),

     .HRDATAS1      (HRDATA1S1),    // SMI
     .HREADYS1      (HREADY1S1),
     .HRESPS1       (HRESP1S1),

     .HRDATAS2      (HRDATA1S2),    // AHB-AHB Bridge (Retry Slave and
     .HREADYS2      (HREADY1S2),    //  APB Peripherals)
     .HRESPS2       (HRESP1S2),

     .HRDATAS3      (HRDATA1S3),    // Interrupt
     .HREADYS3      (HREADY1S3),
     .HRESPS3       (HRESP1S3),

     .HRDATAS4      (HRDATA1S4),
     .HREADYS4      (HREADY1S4),
     .HRESPS4       (HRESP1S4),

     .HRDATAS5      (HRDATA1S5),
     .HREADYS5      (HREADY1S5),
     .HRESPS5       (HRESP1S5),

     .HRDATAS6      (HRDATA1S6),
     .HREADYS6      (HREADY1S6),
     .HRESPS6       (HRESP1S6),

     .HRDATAS7      (HRDATA1S7),
     .HREADYS7      (HREADY1S7),
     .HRESPS7       (HRESP1S7),

     .HREADYDefault (HREADY1DefSlv),
     .HRESPDefault  (HRESP1DefSlv),

     .HRDATA        (HRDATA1),
     .HREADY        (HREADY1),
     .HRESP         (HRESP1),
      
      // Scan test dummy signals; not connected until scan insertion 
     .SCANENABLE    (SCANENABLE),  // Scan Test Mode Enbl
     .SCANINHCLK    (SCANINs2m1),  // Scan Chain Input
     .SCANOUTHCLK   (SCANOUTs2m1)  // Scan Chain Output
    );

  // Tie off HRDATA for unused slave ports
  //  assign HRDATA1S0 = TieOffLo32;  // IntMem
  //  assign HRDATA1S1 = TieOffLo32;  // SMI
  //  assign HRDATA1S2 = TieOffLo32;  // Retry Slave and APB Peripherals
  //  assign HRDATA1S3 = TieOffLo32;  // Interrupt
  assign HRDATA1S4 = TieOffLo32;
  assign HRDATA1S5 = TieOffLo32;
  assign HRDATA1S6 = TieOffLo32;
  assign HRDATA1S7 = TieOffLo32;

  // Tie off HREADY for unused slave ports
  //  assign HREADY1S0 = TieOffHi1;   // IntMem
  //  assign HREADY1S1 = TieOffHi1;   // SMI
  //  assign HREADY1S2 = TieOffHi1;   // Retry Slave and APB Peripherals
  //  assign HREADY1S3 = TieOffHi1;   // Interrupt
  assign HREADY1S4 = TieOffHi1;
  assign HREADY1S5 = TieOffHi1;
  assign HREADY1S6 = TieOffHi1;
  assign HREADY1S7 = TieOffHi1;

  // Tie off HRESP for unused slave ports
  //  assign HRESP1S0 = TieOffLo2;    // IntMem
  //  assign HRESP1S1 = TieOffLo2;    // SMI
  //  assign HRESP1S2 = TieOffLo2;    // Retry Slave and APB Peripherals
  //  assign HRESP1S3 = TieOffLo2;    // Interrupt
  assign HRESP1S4 = TieOffLo2;
  assign HRESP1S5 = TieOffLo2;
  assign HRESP1S6 = TieOffLo2;
  assign HRESP1S7 = TieOffLo2;





//------------------------------------------------------------------------------
// APB domain on AHB2
//------------------------------------------------------------------------------

// Watchdog instantiated as APB slave 1
/*  Watchdog uWatchdog
    (
     .PCLK        (HCLK),
     .PRESETn     (HRESETn),

     .PENABLE     (PENABLE),
     .PSEL        (PSELS1),
     .PADDR       (PADDR[11:2]),
     .PWRITE      (PWRITE),
     .PWDATA      (PWDATA),
     .PRDATA      (PRDATAS1),

     .WDOGCLK     (HCLK),
     .WDOGCLKEN   (TieOffHi1),
     .WDOGRESn    (WDOGRESn),
     .WDOGINT     (WDOGINT),
     .WDOGRES     (WDOGRES),

     // Scan test dummy signals; not connected until scan insertion 
     .SCANENABLE  (SCANENABLE), // Scan Test Mode Enbl
     .SCANINPCLK  (SCANINwdog), // Scan Chain Input
     .SCANOUTPCLK (SCANOUTwdog) // Scan Chain Output
    );
*/
// Timers instantiated as APB slave 2
/*  Timers uTimers
    (
     .PCLK        (HCLK),
     .PRESETn     (HRESETn),

     .PENABLE     (PENABLE),
     .PSEL        (PSELS2),
     .PADDR       (PADDR[11:2]),
     .PWRITE      (PWRITE),
     .PWDATA      (PWDATA),
     .PRDATA      (PRDATAS2),

     .TIMCLK      (HCLK),
     .TIMCLKEN1   (TieOffHi1),
     .TIMCLKEN2   (TieOffHi1),
     .TIMINT1     (TIMINT1),
     .TIMINT2     (TIMINT2),
     .TIMINTC     (TIMINTC),

     // Scan test dummy signals; not connected until scan insertion 
     .SCANENABLE  (SCANENABLE),   // Scan Test Mode Enbl
     .SCANINPCLK  (SCANINtimers), // Scan Chain Input
     .SCANOUTPCLK (SCANOUTtimers) // Scan Chain Output
    );
*/
// General Purpose Input/Output module as APB slave 4
/*  Gpio uGpio
    (
     .PCLK        (HCLK),
     .PRESETn     (HRESETn),

     .PSEL        (PSELS4),
     .PENABLE     (PENABLE),
     .PWRITE      (PWRITE),
     .PWDATA      (PWDATA[7:0]),
     .PADDR       (PADDR[11:2]),

     .GPIN        (GPIN),
     .nGPAFEN     (nGPAFEN),
     .GPAFOUT     (GPAFOUT),
     .PRDATA      (PRDATAS4[7:0]),
     .nGPEN       (nGPEN),
     .GPOUT       (GPOUT),
     .GPAFIN      (GPAFIN),
     .GPIOINTR    (GPIOINTR),
     .GPIOMIS     (GPIOMIS),

     // Scan test dummy signals; not connected until scan insertion 
     .SCANENABLE  (SCANENABLE), // Scan Test Mode Enbl
     .SCANINPCLK  (SCANINgpio), // Scan Chain Input
     .SCANOUTPCLK (SCANOUTgpio) // Scan Chain Output
    );
*/
// Drive unused output read-data bits LOW.
     assign PRDATAS4[31:8] = {24{1'b0}};


// Remap/Pause controller instantiated as APB slave 8
/*  RemapPause uRemapPause
    (
     .PCLK        (HCLK),
     .PRESETn     (HRESETn),

     .PENABLE     (PENABLE),
     .PSELRPC     (PSELS8),
     .PADDR       (PADDR[5:2]),
     .PWRITE      (PWRITE),
     .PWDATA      (PWDATA[7:0]),
     .PRDATA      (PRDATAS8[7:0]),

     .nFIQ        (nFIQ),
     .nIRQ        (nIRQ),

     .Pause       (Pause),
     .Remap       (Remap),

     // Scan test dummy signals; not connected until scan insertion 
     .SCANENABLE  (SCANENABLE), // Scan Test Mode Enbl
     .SCANINPCLK  (SCANINrpc),  // Scan Chain Input
     .SCANOUTPCLK (SCANOUTrpc)  // Scan Chain Output
    );
*/
// Drive unused output read-data bits LOW.
     assign PRDATAS8[31:8] = {24{1'b0}};


// Example APB Slave instantiated as APB slave 15
  APB_PowerManager uAPB_PowerManager
    (
     .OSC_CLK      (ARM_OSCi     ),
     .EINT         (EINT         ),
     .PCLK         (HCLK         ),
     .PRESETn      (HRESETn      ),

     .PENABLE      (PENABLE      ),
     .PSEL         (PSELS13      ),
     .PWRITE       (PWRITE       ),
     .PADDR        (PADDR        ),
     .PRDATA       (PRDATAS13    ),
     .PWDATA       (PWDATA       ),
     .Sys_CLK_O    (Sys_CLK_O    ),  //AHB/APB CTS Point
     .UART_CLK_O   (UART_CLK_O   ),  //UART CTS point
     .GIE_O        (GIE_O        ),
     .UART_INT_SEL (UART_INT_SEL ),
     .AD_CLK_O     (AD_CLK_O     ),  //ADC Clock
     // Scan test dummy signals; not connected until scan insertion 
     .SCANENABLE   (SCANENABLE   ),  // Scan Test Mode Enbl
     .SCANINPCLK   (SCANINegapb  ),  // Scan Chain Input
     .SCANOUTPCLK  (SCANOUTegapb )   // Scan Chain Output
    );

// Peripheral read-data multiplexor
  MuxP2B uMuxP2B
    (
     .PSELS0    (PSELS0),    // Select lines from APB Bridge
     .PSELS1    (PSELS1),
     .PSELS2    (PSELS2),
     .PSELS3    (PSELS3),
     .PSELS4    (PSELS4),
     .PSELS5    (PSELS5),
     .PSELS6    (PSELS6),
     .PSELS7    (PSELS7),
     .PSELS8    (PSELS8),
     .PSELS9    (PSELS9),
     .PSELS10   (PSELS10),
     .PSELS11   (PSELS11),
     .PSELS12   (PSELS12),
     .PSELS13   (PSELS13),
     .PSELS14   (PSELS14),
     .PSELS15   (PSELS15),

     .PRDATAS0  (PRDATAS0),  // APB Slave read-data
     .PRDATAS1  (PRDATAS1),
     .PRDATAS2  (PRDATAS2),
     .PRDATAS3  (PRDATAS3),
     .PRDATAS4  (PRDATAS4),
     .PRDATAS5  (PRDATAS5),
     .PRDATAS6  (PRDATAS6),
     .PRDATAS7  (PRDATAS7),
     .PRDATAS8  (PRDATAS8),
     .PRDATAS9  (PRDATAS9),
     .PRDATAS10 (PRDATAS10),
     .PRDATAS11 (PRDATAS11),
     .PRDATAS12 (PRDATAS12),
     .PRDATAS13 (PRDATAS13),
     .PRDATAS14 (PRDATAS14),
     .PRDATAS15 (PRDATAS15),

     .PRDATA    (PRDATA)     // To APB Bridge
    );

// Tie off unused APB slave data paths
  assign PRDATAS0 = TieOffLo32;
  assign PRDATAS1 = TieOffLo32;            // Watchdog
  assign PRDATAS2 = TieOffLo32;            // Timers
  assign PRDATAS3 = TieOffLo32;
  assign PRDATAS4 = TieOffLo32;            // GPIO
  assign PRDATAS5 = TieOffLo32;
  assign PRDATAS6 = TieOffLo32;
  assign PRDATAS7 = TieOffLo32;
  assign PRDATAS8 = TieOffLo32;            // Remap/Pause
  assign PRDATAS9 = TieOffLo32;
  assign PRDATAS10 = TieOffLo32;
  assign PRDATAS11 = TieOffLo32;
  assign PRDATAS12 = TieOffLo32;
 // assign PRDATAS13 = TieOffLo32;
  assign PRDATAS14 = TieOffLo32;
  assign PRDATAS15 = TieOffLo32;           // Example APB Slave


endmodule

// --================================= End ===================================--
