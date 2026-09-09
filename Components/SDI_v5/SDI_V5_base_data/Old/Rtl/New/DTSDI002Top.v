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


module DTSDI002Top
(
//XCLKIN       , 
//nReset       , 
//Simulation

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

GPIN         , 
GPOUT        , 
nGPEN        , 
nGPAFEN      , 
GPAFOUT      , 
GPAFIN       , 

//DTSDI002
//Input

ARM_RESETi   ,
ARM_OSCi     ,
BOOT_MODE    ,
EINT         ,
AIN          ,

TCLK0        ,
TCLK1        ,
TCLK2        ,
TCLK3        ,
TCLK4        ,
TCLK5        ,
TCLK6        ,
TCLK7        ,
TCAP         ,
//I2C
I2C0_SCL     ,
I2C0_SDA     ,
EINT_Gpio0   ,
TCAP_Gpio1   ,
PWM_Gpio2    ,
UART_Gpio3   ,

//J-TAG
ARM_TRST     , 
ARM_TCK      , 
ARM_TDI      , 
ARM_TMS      , 
ARM_TDO      , 
//nTDOEN       , 
COMMRX       , 
COMMTX       , 

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
input [7:0]   EINT        ;  //External Interupt
input [7:0]   AIN         ;  //Analog Input[A/D-Converter]

input TCLK0                ;
input TCLK1                ;
input TCLK2                ;
input TCLK3                ;
input TCLK4                ;
input TCLK5                ;
input TCLK6                ;
input TCLK7                ;
input [7:0] TCAP           ;

inout [1:0]   I2C0_SCL     ;
inout [1:0]   I2C0_SDA     ;

inout [7:0]   EINT_Gpio0   ;
inout [7:0]   TCAP_Gpio1   ;
inout [7:0]   PWM_Gpio2    ;
inout [7:0]   UART_Gpio3   ;
 
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
  wire          TCLK0       ;
  wire          TCLK1       ;
  wire          TCLK2       ;
  wire          TCLK3       ;
  wire          TCLK4       ;
  wire          TCLK5       ;
  wire          TCLK6       ;
  wire          TCLK7       ;
  wire [7:0]    TCAP        ;
  
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
//APB[HSELS7]
  wire   [31:0] HRDATA1S7;
  wire          HREADY1S7;
  wire   [1:0]  HRESP1S7;

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
  //wire   [7:0] PADDR;
  wire  [11:0]  PADDR ;
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
  
  wire   [31:0] PRDATAS4   ;  //Timers
  wire   [31:0] PRDATAS5;
  wire   [31:0] PRDATAS6;
  wire   [31:0] PRDATAS7;
  wire   [31:0] PRDATAS8;
  wire   [31:0] PRDATAS9;
  wire   [31:0] PRDATAS10;
  wire   [31:0] PRDATAS11;
  wire   [31:0] PRDATAS12; //ADC
  wire   [31:0] PRDATAS13; //Power & Clock
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
  wire          SCANIN_APB_pwcl   ;
  wire          SCANOUT_APB_pwcl  ;
  wire          SCANIN_APB_adc    ;
  wire          SCANOUT_APB_adc   ;
  
  wire          SCANINtimersX0    ; //Timers
  wire          SCANOUTtimersX0   ;
  wire          SCANINtimersX1    ; 
  wire          SCANOUTtimersX1   ;
  wire          SCANINtimersX2    ;
  wire          SCANOUTtimersX2   ;
  wire          SCANINtimersX3    ; 
  wire          SCANOUTtimersX3   ;
  wire          SCANINtimersX4    ;
  wire          SCANOUTtimersX4   ;
  wire          SCANINtimersX5    ; 
  wire          SCANOUTtimersX5   ;
  wire          SCANINtimersX6    ;
  wire          SCANOUTtimersX6   ;
  wire          SCANINtimersX7    ; 
  wire          SCANOUTtimersX7   ;
  
  wire          SCANINPWM0_0      ; //PWM0_0 ~PWM0_7
  wire          SCANOUTPWM0_0     ;
  wire          SCANINPWM0_1      ; 
  wire          SCANOUTPWM0_1     ;
  wire          SCANINPWM0_2      ; 
  wire          SCANOUTPWM0_2     ;
  wire          SCANINPWM0_3      ; 
  wire          SCANOUTPWM0_3     ;
  wire          SCANINPWM0_4      ; 
  wire          SCANOUTPWM0_4     ;
  wire          SCANINPWM0_5      ; 
  wire          SCANOUTPWM0_5     ;
  wire          SCANINPWM0_6      ; 
  wire          SCANOUTPWM0_6     ;
  wire          SCANINPWM0_7      ; 
  wire          SCANOUTPWM0_7     ;
  
  wire          SCANINPWM1_0      ; //PWM1_0 ~PWM1_7
  wire          SCANOUTPWM1_0     ;
  wire          SCANINPWM1_1      ; 
  wire          SCANOUTPWM1_1     ;
  wire          SCANINPWM1_2      ; 
  wire          SCANOUTPWM1_2     ;
  wire          SCANINPWM1_3      ; 
  wire          SCANOUTPWM1_3     ;
  wire          SCANINPWM1_4      ; 
  wire          SCANOUTPWM1_4     ;
  wire          SCANINPWM1_5      ; 
  wire          SCANOUTPWM1_5     ;
  wire          SCANINPWM1_6      ; 
  wire          SCANOUTPWM1_6     ;
  wire          SCANINPWM1_7      ; 
  wire          SCANOUTPWM1_7     ;
  
  wire          SCANINPWM2_0      ; //PWM2_0 ~PWM2_7
  wire          SCANOUTPWM2_0     ;
  wire          SCANINPWM2_1      ; 
  wire          SCANOUTPWM2_1     ;
  wire          SCANINPWM2_2      ; 
  wire          SCANOUTPWM2_2     ;
  wire          SCANINPWM2_3      ; 
  wire          SCANOUTPWM2_3     ;
  wire          SCANINPWM2_4      ; 
  wire          SCANOUTPWM2_4     ;
  wire          SCANINPWM2_5      ; 
  wire          SCANOUTPWM2_5     ;
  wire          SCANINPWM2_6      ; 
  wire          SCANOUTPWM2_6     ;
  wire          SCANINPWM2_7      ; 
  wire          SCANOUTPWM2_7     ;
  
  wire          SCANINPWM3_0      ; //PWM3_0 ~PWM3_7
  wire          SCANOUTPWM3_0     ;
  wire          SCANINPWM3_1      ; 
  wire          SCANOUTPWM3_1     ;
  wire          SCANINPWM3_2      ; 
  wire          SCANOUTPWM3_2     ;
  wire          SCANINPWM3_3      ; 
  wire          SCANOUTPWM3_3     ;
  wire          SCANINPWM3_4      ; 
  wire          SCANOUTPWM3_4     ;
  wire          SCANINPWM3_5      ; 
  wire          SCANOUTPWM3_5     ;
  wire          SCANINPWM3_6      ; 
  wire          SCANOUTPWM3_6     ;
  wire          SCANINPWM3_7      ; 
  wire          SCANOUTPWM3_7     ;
  
  wire          SCANINwdog        ;
  wire          SCANOUTwdog       ;
      
  wire          SCANINa7tdmi;
  wire          SCANOUTa7tdmi;
  

  wire          SCANINrpc;
  wire          SCANOUTrpc;
  wire          SCANINic;
  wire          SCANOUTic;
  wire          SCANINgpio; //Gpio
  wire          SCANOUTgpio;
  
 
  
  wire          SCANINarb1;
  wire          SCANOUTarb1;
  wire          SCANINdefslv1;
  wire          SCANOUTdefslv1;
  wire          SCANINs2m1;
  wire          SCANOUTs2m1;
  
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
  wire        TieOffHi1  = 1'b1 ;
  wire        TieOffLo1  = 1'b0 ;
  wire [1:0]  TieOffLo2  = 2'b00;
  wire [3:0]  TieOffLo4  = 4'b0000;
  wire [25:0] TieOffLo26 = {26{1'b0}};
  wire [31:0] TieOffLo32 = {32{1'b0}};

//Fucntion Signal
//Power& Clock Mangement
  wire       Sys_CLK_O    ;
  wire       UART_CLK_O   ;
  wire       GIE_O        ;
  wire       UART_INT_SEL ;
  wire       AD_CLK_O     ;

//A/D-Converter
  wire       EOC          ;
  wire [9:0] AD_OUT       ;
  wire [2:0] AIN_SEL      ;
  wire       STC_O        ;
  wire       STBY         ;
//Timer & PWM
  wire [7:0]    INT_TPOUT        ;
  wire [7:0]    INT_TPOUT_PWM0   ;
  wire [7:0]    INT_TPOUT_PWM1   ;
  wire [7:0]    INT_TPOUT_PWM2   ;
  wire [7:0]    INT_TPOUT_PWM3   ;
  
  wire  [7:0]   INT_TOF_Timer    ;//Overflow[16'hFFFF Interrupt 
  wire  [7:0]   INT_TOF_PWM0     ;
  wire  [7:0]   INT_TOF_PWM1     ;
  wire  [7:0]   INT_TOF_PWM2     ;
  wire  [7:0]   INT_TOF_PWM3     ;

  wire  [7:0]   INT_TMC_Timer    ;//Match Interrupt To Interrupt 
  wire  [7:0]   INT_TMC_PWM0     ;
  wire  [7:0]   INT_TMC_PWM1     ;
  wire  [7:0]   INT_TMC_PWM2     ;
  wire  [7:0]   INT_TMC_PWM3     ;

  
  wire  [1:0]   I2C0_SCL         ;
  wire  [1:0]   I2C0_SDA         ;
  wire  [7:0]   EINT_Gpio0       ;
  wire  [7:0]   TCAP_Gpio1       ;
  wire  [7:0]   PWM_Gpio2        ;
  wire  [7:0]   UART_Gpio3       ;

//Gpio
  wire [7:0] Gpio_IN0            ;
  wire [7:0] Gpio_IN1            ;
  wire [7:0] Gpio_IN2            ;
  wire [7:0] Gpio_IN3            ;
  
  wire [7:0] GPIO_En0            ;
  wire [7:0] GPIO_En1            ;
  wire [7:0] GPIO_En2            ;
  wire [7:0] GPIO_En3            ;
  
  wire [7:0] Mux_Out0            ;
  wire [7:0] Mux_Out1            ;
  wire [7:0] Mux_Out2            ;
  wire [7:0] Mux_Out3            ;
  
//------------------------------------------------------------------------------
// Beginning of main code
//------------------------------------------------------------------------------

// Drive the AHB clock with the external clock input.
//assign HCLK = ARM_OSCi;
// Drive the AHB clock with the Internal clock input[APB_PowerManager].
  assign HCLK = Sys_CLK_O;
//assign HCLK = Test_Mode ? ARM_OSCi :Sys_CLK_O;


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
A7TDMI uA7TDMI
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

// APB peripherals instantiated as slave 12 on AHB
  APBif uAPBif
    (
     .HCLK        (HCLK),
     .HRESETn     (HRESETn),

     .HADDR       (HADDR1[11:0]),
     .HTRANS      (HTRANS1),
     .HWRITE      (HWRITE1),
     .HWDATA      (HWDATA1),
     .HSEL        (HSELS3),
     .HREADY      (HREADY1),

     .HRDATA      (HRDATA1S3), // Channel 0 of uMuxMtoS2
     .HREADYOUT   (HREADY1S3),
     .HRESP       (HRESP1S3),

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
     .PSELS10     (PSELS10),   //Gpio
     .PSELS11     (PSELS11),
     .PSELS12     (PSELS12),   //ADC
     .PSELS13     (PSELS13),   //Power&Clock
     //.PSELS14     (PSELS14),
     //.PSELS15     (PSELS15),
  
      // Scan test dummy signals; not connected until scan insertion 
     .SCANENABLE  (SCANENABLE), // Scan Test Mode Enbl
     .SCANINHCLK  (SCANINapb),  // Scan Chain Input
     .SCANOUTHCLK (SCANOUTapb)  // Scan Chain Output
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

// AHB System Infrastructure --------------------------------------------------

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
  //assign HBUSREQ1M0 = Pause;

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
  Decoder uDecoder
    (
     // Upper order bits of the address bus for the decode function
     .HADDR       (HADDR1[31:0] ),
     // Status of the system re-map
     .BootMode    (BOOT_MODE    ),
     .HSELS0      (HSELS0       ),
     .HSELS1      (HSELS1       ),
     .HSELS2      (HSELS2       ),
     .HSELS3      (HSELS3       ),

     .HSELS1_0    (HSELS1_0     ),
     .HSELS1_1    (HSELS1_1     ),
     .HSELS1_2    (HSELS1_2     ),
     .HSELS1_3    (HSELS1_3     ),
     .HSELSR 			(HSEL1DefSlv  )
    );

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
  MuxS2M uMuxS2M
    (
     .HCLK          (HCLK),
     .HRESETn       (HRESETn),

     .HSELS0        (HSELS0), // Flash
     .HSELS1        (HSELS1), // ESMC
     .HSELS2        (HSELS2), // ISMC
     .HSELS3        (HSELS3), // APB
     .HSELS4        (1'b0),
     .HSELS5        (1'b0),
     .HSELS6        (1'b0),
     .HSELS7        (1'b0),
     .HSELDefault   (HSEL1DefSlv),

     .HRDATAS0      (HRDATA1S0),
     .HREADYS0      (HREADY1S0),
     .HRESPS0       (HRESP1S0),

     .HRDATAS1      (HRDATA1S1),
     .HREADYS1      (HREADY1S1),
     .HRESPS1       (HRESP1S1),

     .HRDATAS2      (HRDATA1S2),
     .HREADYS2      (HREADY1S2),
     .HRESPS2       (HRESP1S2),

     .HRDATAS3      (HRDATA1S3),
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
  assign HRDATA1S0 = TieOffLo32;
  assign HRDATA1S1 = TieOffLo32;
  assign HRDATA1S2 = TieOffLo32;
//  assign HRDATA1S3 = TieOffLo32;
  assign HRDATA1S4 = TieOffLo32;
  assign HRDATA1S5 = TieOffLo32;
  assign HRDATA1S6 = TieOffLo32;
  assign HRDATA1S7 = TieOffLo32;

  // Tie off HREADY for unused slave ports
  assign HREADY1S0 = TieOffHi1;
  assign HREADY1S1 = TieOffHi1;
  assign HREADY1S2 = TieOffHi1;
//  assign HREADY1S3 = TieOffHi1;
  assign HREADY1S4 = TieOffHi1;
  assign HREADY1S5 = TieOffHi1;
  assign HREADY1S6 = TieOffHi1;
  assign HREADY1S7 = TieOffHi1;

  // Tie off HRESP for unused slave ports
  assign HRESP1S0 = TieOffLo2;
  assign HRESP1S1 = TieOffLo2;
  assign HRESP1S2 = TieOffLo2;
//  assign HRESP1S3 = TieOffLo2;
  assign HRESP1S4 = TieOffLo2;
  assign HRESP1S5 = TieOffLo2;
  assign HRESP1S6 = TieOffLo2;
  assign HRESP1S7 = TieOffLo2;

//------------------------------------------------------------------------------
// APB domain 
//------------------------------------------------------------------------------

// Power & Clock 
APB_PowerManager uAPB_PowerManager
    (
     //synopsy translate_off
     .Int_Clrn     (Int_Clrn     ),
     //synopsy translate_on
     .OSC_CLK      (ARM_OSCi     ),
     //Real
     //.EINT         (Gpio_IN0     ),
     //Sim
     .EINT         (EINT         ),
     .PCLK         (HCLK         ),
     .PRESETn      (HRESETn      ),
     .PENABLE      (PENABLE      ),
     .PSEL         (PSELS13      ),
     .PWRITE       (PWRITE       ),
     .PADDR        (PADDR[7:2]   ),
     .PRDATA       (PRDATAS13    ),
     .PWDATA       (PWDATA       ),
     
     .Sys_CLK_O    (Sys_CLK_O    ),  //AHB/APB CTS Point
     .UART_CLK_O   (UART_CLK_O   ),  //UART CTS point
     .GIE_O        (GIE_O        ),
     .UART_INT_SEL (UART_INT_SEL ),
     .AD_CLK_O     (AD_CLK_O     ),  //ADC Clock
     // Scan test dummy signals; not connected until scan insertion 
     .SCANENABLE   (SCANENABLE       ),  // Scan Test Mode Enbl
     .SCANINPCLK   (SCANIN_APB_pwcl  ),  // Scan Chain Input
     .SCANOUTPCLK  (SCANOUT_APB_pwcl )   // Scan Chain Output
    );

//A/D - Converter Control
APB_ADC_Ctrl uAPB_ADC_Ctrl
    (

     .PCLK         (HCLK            ), 
     .PRESETn      (HRESETn         ), 
     .PENABLE      (PENABLE         ), 
     .PSEL         (PSELS12         ), 
     .PWRITE       (PWRITE          ), 
     .PADDR        (PADDR[11:2]      ), 
     .PWDATA       (PWDATA          ),
     .PRDATA       (PRDATAS12       ),

     //Function
     .ADC_Flag     (EOC             ),
     .STBY         (STBY            ), 
     .AD_Data      (AD_OUT          ),
     .ADC_CKIN     (AD_CLK_O        ),
     .AIN_SEL      (AIN_SEL         ),
     .STC_O        (STC_O           ),

     .SCANENABLE   (SCANENABLE      ), 
     .SCANINPCLK   (SCANIN_APB_adc  ), 
     .SCANOUTPCLK  (SCANOUT_APB_adc )

     );

AD_Conv10 uAD_SS1395_px
    (
     .STBY        ( STBY            ),
     .AIN         ( AIN             ),
     .AD_CLK      ( AD_CLK_O        ),
     .ASEL        ( AIN_SEL         ),
     .STC         ( STC_O           ),
                                    
     .EOC         ( EOC             ),
     .AD_OUT	  ( AD_OUT          )
    );

/*
//Timers0~7

APB_Timers_EAX0 uAPB_Timers_EAX0 
(
//APB
     .PCLK         ( HCLK            ), 
     .PRESETn      ( HRESETn         ), 
     .PENABLE      ( PENABLE         ), 
     .PSEL         ( PSELS4X0        ), 
     .PWRITE       ( PWRITE          ), 
     .PADDR        ( PADDR[11:2]     ), 
     .PWDATA       ( PWDATA          ),
     .PRDATA       ( PRDATAS4X0      ),

//Function
//TCLK[7:0]
     .TCLK         ( TCLK0           ),
     .TCAP         ( TCAP            ),
     .INT_TPOUT    ( INT_TPOUT[0]    ),
     .INT_TOF      ( INT_TOF_Timer[0]),
     .INT_TMC      ( INT_TMC_Timer[0]),

    .SCANENABLE    (SCANENABLE       ), 
    .SCANINPCLK    (SCANINtimersX0   ), 
    .SCANOUTPCLK   (SCANOUTtimersX0  )
);


APB_Timers_EAX1 uAPB_Timers_EAX1 
(
//APB
     .PCLK         ( HCLK            ), 
     .PRESETn      ( HRESETn         ), 
     .PENABLE      ( PENABLE         ), 
     .PSEL         ( PSELS4X1        ), 
     .PWRITE       ( PWRITE          ), 
     .PADDR        ( PADDR[11:2]     ), 
     .PWDATA       ( PWDATA          ),
     .PRDATA       ( PRDATAS4X1      ),

//Function
//TCLK[7:0]
     .TCLK         ( TCLK1           ),
     .TCAP         ( TCAP            ),
     .INT_TPOUT    ( INT_TPOUT[1]    ),
     .INT_TOF      ( INT_TOF_Timer[1]),
     .INT_TMC      ( INT_TMC_Timer[1]),

    .SCANENABLE    (SCANENABLE       ), 
    .SCANINPCLK    (SCANINtimersX1   ), 
    .SCANOUTPCLK   (SCANOUTtimersX1  )
);


APB_Timers_EAX2 uAPB_Timers_EAX2 
(
//APB
     .PCLK         ( HCLK            ), 
     .PRESETn      ( HRESETn         ), 
     .PENABLE      ( PENABLE         ), 
     .PSEL         ( PSELS4X2        ), 
     .PWRITE       ( PWRITE          ), 
     .PADDR        ( PADDR[11:2]     ), 
     .PWDATA       ( PWDATA          ),
     .PRDATA       ( PRDATAS4X2      ),

//Function
//TCLK[7:0]
     .TCLK         ( TCLK2           ),
     .TCAP         ( TCAP            ),
     .INT_TPOUT    ( INT_TPOUT[2]    ),
     .INT_TOF      ( INT_TOF_Timer[2]),
     .INT_TMC      ( INT_TMC_Timer[2]),

    .SCANENABLE    (SCANENABLE       ), 
    .SCANINPCLK    (SCANINtimersX2   ), 
    .SCANOUTPCLK   (SCANOUTtimersX2  )
);

APB_Timers_EAX3 uAPB_Timers_EAX3 
(
//APB
     .PCLK         ( HCLK            ), 
     .PRESETn      ( HRESETn         ), 
     .PENABLE      ( PENABLE         ), 
     .PSEL         ( PSELS4X3        ), 
     .PWRITE       ( PWRITE          ), 
     .PADDR        ( PADDR[11:2]     ), 
     .PWDATA       ( PWDATA          ),
     .PRDATA       ( PRDATAS4X3      ),

//Function
//TCLK[7:0]
     .TCLK         ( TCLK3           ),
     .TCAP         ( TCAP            ),
     .INT_TPOUT    ( INT_TPOUT[3]    ),
     .INT_TOF      ( INT_TOF_Timer[3]),
     .INT_TMC      ( INT_TMC_Timer[3]),

    .SCANENABLE    (SCANENABLE       ), 
    .SCANINPCLK    (SCANINtimersX3   ), 
    .SCANOUTPCLK   (SCANOUTtimersX3  )
);

APB_Timers_EAX4 uAPB_Timers_EAX4 
(
//APB
     .PCLK         ( HCLK            ), 
     .PRESETn      ( HRESETn         ), 
     .PENABLE      ( PENABLE         ), 
     .PSEL         ( PSELS4X4        ), 
     .PWRITE       ( PWRITE          ), 
     .PADDR        ( PADDR[11:2]     ), 
     .PWDATA       ( PWDATA          ),
     .PRDATA       ( PRDATAS4X4      ),

//Function
//TCLK[7:0]
     .TCLK         ( TCLK4           ),
     .TCAP         ( TCAP            ),
     .INT_TPOUT    ( INT_TPOUT[4]    ),
     .INT_TOF      ( INT_TOF_Timer[4]),
     .INT_TMC      ( INT_TMC_Timer[4]),

    .SCANENABLE    (SCANENABLE       ), 
    .SCANINPCLK    (SCANINtimersX4   ), 
    .SCANOUTPCLK   (SCANOUTtimersX4  )
);

APB_Timers_EAX5 uAPB_Timers_EAX5 
(
//APB
     .PCLK         ( HCLK            ), 
     .PRESETn      ( HRESETn         ), 
     .PENABLE      ( PENABLE         ), 
     .PSEL         ( PSELS4X5        ), 
     .PWRITE       ( PWRITE          ), 
     .PADDR        ( PADDR[11:2]     ), 
     .PWDATA       ( PWDATA          ),
     .PRDATA       ( PRDATAS4X5      ),

//Function
//TCLK[7:0]
     .TCLK         ( TCLK1           ),
     .TCAP         ( TCAP            ),
     .INT_TPOUT    ( INT_TPOUT[5]    ),
     .INT_TOF      ( INT_TOF_Timer[5]),
     .INT_TMC      ( INT_TMC_Timer[5]),

    .SCANENABLE    (SCANENABLE       ), 
    .SCANINPCLK    (SCANINtimersX5   ), 
    .SCANOUTPCLK   (SCANOUTtimersX5  )
);


APB_Timers_EAX6 uAPB_Timers_EAX6 
(
//APB
     .PCLK         ( HCLK            ), 
     .PRESETn      ( HRESETn         ), 
     .PENABLE      ( PENABLE         ), 
     .PSEL         ( PSELS4X6        ), 
     .PWRITE       ( PWRITE          ), 
     .PADDR        ( PADDR[11:2]     ), 
     .PWDATA       ( PWDATA          ),
     .PRDATA       ( PRDATAS4X6      ),

//Function
//TCLK[7:0]
     .TCLK         ( TCLK1           ),
     .TCAP         ( TCAP            ),
     .INT_TPOUT    ( INT_TPOUT[6]    ),
     .INT_TOF      ( INT_TOF_Timer[6]),
     .INT_TMC      ( INT_TMC_Timer[6]),

    .SCANENABLE    (SCANENABLE       ), 
    .SCANINPCLK    (SCANINtimersX6   ), 
    .SCANOUTPCLK   (SCANOUTtimersX6  )
);

APB_Timers_EAX7 uAPB_Timers_EAX7 
(
//APB
     .PCLK         ( HCLK            ), 
     .PRESETn      ( HRESETn         ), 
     .PENABLE      ( PENABLE         ), 
     .PSEL         ( PSELS4X7        ), 
     .PWRITE       ( PWRITE          ), 
     .PADDR        ( PADDR[11:2]     ), 
     .PWDATA       ( PWDATA          ),
     .PRDATA       ( PRDATAS4X7      ),

//Function
//TCLK[7:0]
     .TCLK         ( TCLK7           ),
     .TCAP         ( TCAP            ),
     .INT_TPOUT    ( INT_TPOUT[7]    ),
     .INT_TOF      ( INT_TOF_Timer[7]),
     .INT_TMC      ( INT_TMC_Timer[7]),

    .SCANENABLE    (SCANENABLE       ), 
    .SCANINPCLK    (SCANINtimersX7   ), 
    .SCANOUTPCLK   (SCANOUTtimersX7  )
);

//=======================================================
//PWM0_0 ~ PWM0_7
//======================================================= 
  
APB_Timers_PWM0_0 uAPB_Timers_PWM0_0 
(
//APB
     .PCLK         ( HCLK              ), 
     .PRESETn      ( HRESETn           ), 
     .PENABLE      ( PENABLE           ), 
     .PSEL         ( PSELS5X0          ), 
     .PWRITE       ( PWRITE            ), 
     .PADDR        ( PADDR[11:2]       ), 
     .PWDATA       ( PWDATA            ),
     .PRDATA       ( PRDATAS5X0        ),

//Function
     .TCLK         ( TCLK0             ),
     .TCAP         ( TCAP              ),
     .INT_TPOUT    ( INT_TPOUT_PWM0[0] ),
     .INT_TOF      ( INT_TOF_PWM0[0]   ),
     .INT_TMC      ( INT_TMC_PWM0[0]   ),

    .SCANENABLE    (SCANENABLE         ), 
    .SCANINPCLK    (SCANINPWM0_0       ), 
    .SCANOUTPCLK   (SCANOUTPWM0_0      )
);


APB_Timers_PWM0_1 uAPB_Timers_PWM0_1 
(
//APB
     .PCLK         ( HCLK              ), 
     .PRESETn      ( HRESETn           ), 
     .PENABLE      ( PENABLE           ), 
     .PSEL         ( PSELS5X1          ), 
     .PWRITE       ( PWRITE            ), 
     .PADDR        ( PADDR[11:2]       ), 
     .PWDATA       ( PWDATA            ),
     .PRDATA       ( PRDATAS5X1        ),

//Function
     .TCLK         ( TCLK1             ),
     .TCAP         ( TCAP              ),
     .INT_TPOUT    ( INT_TPOUT_PWM0[1] ),
     .INT_TOF      ( INT_TOF_PWM0[1]   ),
     .INT_TMC      ( INT_TMC_PWM0[1]   ),

    .SCANENABLE    (SCANENABLE         ), 
    .SCANINPCLK    (SCANINPWM0_1       ), 
    .SCANOUTPCLK   (SCANOUTPWM0_1      )
);


APB_Timers_PWM0_2 uAPB_Timers_PWM0_2 
(
//APB
     .PCLK         ( HCLK              ), 
     .PRESETn      ( HRESETn           ), 
     .PENABLE      ( PENABLE           ), 
     .PSEL         ( PSELS5X2          ), 
     .PWRITE       ( PWRITE            ), 
     .PADDR        ( PADDR[11:2]       ), 
     .PWDATA       ( PWDATA            ),
     .PRDATA       ( PRDATAS5X2        ),

//Function
     .TCLK         ( TCLK2             ),
     .TCAP         ( TCAP              ),
     .INT_TPOUT    ( INT_TPOUT_PWM0[2] ),
     .INT_TOF      ( INT_TOF_PWM0[2]   ),
     .INT_TMC      ( INT_TMC_PWM0[2]   ),

    .SCANENABLE    (SCANENABLE         ), 
    .SCANINPCLK    (SCANINPWM0_2       ), 
    .SCANOUTPCLK   (SCANOUTPWM0_2      )
);


APB_Timers_PWM0_3 uAPB_Timers_PWM0_3 
(
//APB
     .PCLK         ( HCLK              ), 
     .PRESETn      ( HRESETn           ), 
     .PENABLE      ( PENABLE           ), 
     .PSEL         ( PSELS5X3          ), 
     .PWRITE       ( PWRITE            ), 
     .PADDR        ( PADDR[11:2]       ), 
     .PWDATA       ( PWDATA            ),
     .PRDATA       ( PRDATAS5X3        ),

//Function
     .TCLK         ( TCLK3             ),
     .TCAP         ( TCAP              ),
     .INT_TPOUT    ( INT_TPOUT_PWM0[3] ),
     .INT_TOF      ( INT_TOF_PWM0[3]   ),
     .INT_TMC      ( INT_TMC_PWM0[3]   ),

    .SCANENABLE    (SCANENABLE         ), 
    .SCANINPCLK    (SCANINPWM0_3       ), 
    .SCANOUTPCLK   (SCANOUTPWM0_3      )
);

APB_Timers_PWM0_4 uAPB_Timers_PWM0_4 
(
//APB
     .PCLK         ( HCLK              ), 
     .PRESETn      ( HRESETn           ), 
     .PENABLE      ( PENABLE           ), 
     .PSEL         ( PSELS5X4          ), 
     .PWRITE       ( PWRITE            ), 
     .PADDR        ( PADDR[11:2]       ), 
     .PWDATA       ( PWDATA            ),
     .PRDATA       ( PRDATAS5X4        ),

//Function
     .TCLK         ( TCLK4             ),
     .TCAP         ( TCAP              ),
     .INT_TPOUT    ( INT_TPOUT_PWM0[4] ),
     .INT_TOF      ( INT_TOF_PWM0[4]   ),
     .INT_TMC      ( INT_TMC_PWM0[4]   ),

    .SCANENABLE    (SCANENABLE         ), 
    .SCANINPCLK    (SCANINPWM0_4       ), 
    .SCANOUTPCLK   (SCANOUTPWM0_4      )
);


APB_Timers_PWM0_5 uAPB_Timers_PWM0_5 
(
//APB
     .PCLK         ( HCLK              ), 
     .PRESETn      ( HRESETn           ), 
     .PENABLE      ( PENABLE           ), 
     .PSEL         ( PSELS5X5          ), 
     .PWRITE       ( PWRITE            ), 
     .PADDR        ( PADDR[11:2]       ), 
     .PWDATA       ( PWDATA            ),
     .PRDATA       ( PRDATAS5X5        ),

//Function
     .TCLK         ( TCLK5             ),
     .TCAP         ( TCAP              ),
     .INT_TPOUT    ( INT_TPOUT_PWM0[5] ),
     .INT_TOF      ( INT_TOF_PWM0[5]   ),
     .INT_TMC      ( INT_TMC_PWM0[5]   ),

    .SCANENABLE    (SCANENABLE         ), 
    .SCANINPCLK    (SCANINPWM0_5       ), 
    .SCANOUTPCLK   (SCANOUTPWM0_5      )
);



APB_Timers_PWM0_6 uAPB_Timers_PWM0_6 
(
//APB
     .PCLK         ( HCLK              ), 
     .PRESETn      ( HRESETn           ), 
     .PENABLE      ( PENABLE           ), 
     .PSEL         ( PSELS5X6          ), 
     .PWRITE       ( PWRITE            ), 
     .PADDR        ( PADDR[11:2]       ), 
     .PWDATA       ( PWDATA            ),
     .PRDATA       ( PRDATAS5X6        ),

//Function
     .TCLK         ( TCLK6             ),
     .TCAP         ( TCAP              ),
     .INT_TPOUT    ( INT_TPOUT_PWM0[6] ),
     .INT_TOF      ( INT_TOF_PWM0[6]   ),
     .INT_TMC      ( INT_TMC_PWM0[6]   ),

    .SCANENABLE    (SCANENABLE         ), 
    .SCANINPCLK    (SCANINPWM0_6       ), 
    .SCANOUTPCLK   (SCANOUTPWM0_6      )
);

APB_Timers_PWM0_7 uAPB_Timers_PWM0_7 
(
//APB
     .PCLK         ( HCLK              ), 
     .PRESETn      ( HRESETn           ), 
     .PENABLE      ( PENABLE           ), 
     .PSEL         ( PSELS5X7          ), 
     .PWRITE       ( PWRITE            ), 
     .PADDR        ( PADDR[11:2]       ), 
     .PWDATA       ( PWDATA            ),
     .PRDATA       ( PRDATAS5X7        ),

//Function
     .TCLK         ( TCLK7             ),
     .TCAP         ( TCAP              ),
     .INT_TPOUT    ( INT_TPOUT_PWM0[7] ),
     .INT_TOF      ( INT_TOF_PWM0[7]   ),
     .INT_TMC      ( INT_TMC_PWM0[7]   ),

    .SCANENABLE    (SCANENABLE         ), 
    .SCANINPCLK    (SCANINPWM0_7       ), 
    .SCANOUTPCLK   (SCANOUTPWM0_7      )
);



//=======================================================
//PWM1_0 ~ PWM1_7
//=======================================================

  
APB_Timers_PWM1_0 uAPB_Timers_PWM1_0 
(
//APB
     .PCLK         ( HCLK              ), 
     .PRESETn      ( HRESETn           ), 
     .PENABLE      ( PENABLE           ), 
     .PSEL         ( PSELS6X0          ), 
     .PWRITE       ( PWRITE            ), 
     .PADDR        ( PADDR[11:2]       ), 
     .PWDATA       ( PWDATA            ),
     .PRDATA       ( PRDATAS6X0        ),

//Function
     .TCLK         ( TCLK0             ),
     .TCAP         ( TCAP              ),
     .INT_TPOUT    ( INT_TPOUT_PWM1[0] ),
     .INT_TOF      ( INT_TOF_PWM1[0]   ),
     .INT_TMC      ( INT_TMC_PWM1[0]   ),

    .SCANENABLE    (SCANENABLE         ), 
    .SCANINPCLK    (SCANINPWM1_0       ), 
    .SCANOUTPCLK   (SCANOUTPWM1_0      )
);


APB_Timers_PWM1_1 uAPB_Timers_PWM1_1 
(
//APB
     .PCLK         ( HCLK              ), 
     .PRESETn      ( HRESETn           ), 
     .PENABLE      ( PENABLE           ), 
     .PSEL         ( PSELS6X1          ), 
     .PWRITE       ( PWRITE            ), 
     .PADDR        ( PADDR[11:2]       ), 
     .PWDATA       ( PWDATA            ),
     .PRDATA       ( PRDATAS6X1        ),

//Function
     .TCLK         ( TCLK1             ),
     .TCAP         ( TCAP              ),
     .INT_TPOUT    ( INT_TPOUT_PWM1[1] ),
     .INT_TOF      ( INT_TOF_PWM1[1]   ),
     .INT_TMC      ( INT_TMC_PWM1[1]   ),

    .SCANENABLE    (SCANENABLE         ), 
    .SCANINPCLK    (SCANINPWM1_1       ), 
    .SCANOUTPCLK   (SCANOUTPWM1_1      )
);


APB_Timers_PWM1_2 uAPB_Timers_PWM1_2 
(
//APB
     .PCLK         ( HCLK              ), 
     .PRESETn      ( HRESETn           ), 
     .PENABLE      ( PENABLE           ), 
     .PSEL         ( PSELS6X2          ), 
     .PWRITE       ( PWRITE            ), 
     .PADDR        ( PADDR[11:2]       ), 
     .PWDATA       ( PWDATA            ),
     .PRDATA       ( PRDATAS6X2        ),

//Function
     .TCLK         ( TCLK2             ),
     .TCAP         ( TCAP              ),
     .INT_TPOUT    ( INT_TPOUT_PWM1[2] ),
     .INT_TOF      ( INT_TOF_PWM1[2]   ),
     .INT_TMC      ( INT_TMC_PWM1[2]   ),

    .SCANENABLE    (SCANENABLE         ), 
    .SCANINPCLK    (SCANINPWM1_2       ), 
    .SCANOUTPCLK   (SCANOUTPWM1_2      )
);


APB_Timers_PWM1_3 uAPB_Timers_PWM1_3 
(
//APB
     .PCLK         ( HCLK              ), 
     .PRESETn      ( HRESETn           ), 
     .PENABLE      ( PENABLE           ), 
     .PSEL         ( PSELS6X3          ), 
     .PWRITE       ( PWRITE            ), 
     .PADDR        ( PADDR[11:2]       ), 
     .PWDATA       ( PWDATA            ),
     .PRDATA       ( PRDATAS6X3        ),
//Function
     .TCLK         ( TCLK3             ),
     .TCAP         ( TCAP              ),
     .INT_TPOUT    ( INT_TPOUT_PWM1[3] ),
     .INT_TOF      ( INT_TOF_PWM1[3]   ),
     .INT_TMC      ( INT_TMC_PWM1[3]   ),

    .SCANENABLE    (SCANENABLE         ), 
    .SCANINPCLK    (SCANINPWM1_3       ), 
    .SCANOUTPCLK   (SCANOUTPWM1_3      )
);


APB_Timers_PWM1_4 uAPB_Timers_PWM1_4 
(
//APB
     .PCLK         ( HCLK              ), 
     .PRESETn      ( HRESETn           ), 
     .PENABLE      ( PENABLE           ), 
     .PSEL         ( PSELS6X4          ), 
     .PWRITE       ( PWRITE            ), 
     .PADDR        ( PADDR[11:2]       ), 
     .PWDATA       ( PWDATA            ),
     .PRDATA       ( PRDATAS6X4        ),
//Function
     .TCLK         ( TCLK4             ),
     .TCAP         ( TCAP              ),
     .INT_TPOUT    ( INT_TPOUT_PWM1[4] ),
     .INT_TOF      ( INT_TOF_PWM1[4]   ),
     .INT_TMC      ( INT_TMC_PWM1[4]   ),

    .SCANENABLE    (SCANENABLE         ), 
    .SCANINPCLK    (SCANINPWM1_4       ), 
    .SCANOUTPCLK   (SCANOUTPWM1_4      )
);


APB_Timers_PWM1_5 uAPB_Timers_PWM1_5 
(
//APB
     .PCLK         ( HCLK              ), 
     .PRESETn      ( HRESETn           ), 
     .PENABLE      ( PENABLE           ), 
     .PSEL         ( PSELS6X5          ), 
     .PWRITE       ( PWRITE            ), 
     .PADDR        ( PADDR[11:2]       ), 
     .PWDATA       ( PWDATA            ),
     .PRDATA       ( PRDATAS6X5        ),
//Function
     .TCLK         ( TCLK5             ),
     .TCAP         ( TCAP              ),
     .INT_TPOUT    ( INT_TPOUT_PWM1[5] ),
     .INT_TOF      ( INT_TOF_PWM1[5]   ),
     .INT_TMC      ( INT_TMC_PWM1[5]   ),

    .SCANENABLE    (SCANENABLE         ), 
    .SCANINPCLK    (SCANINPWM1_5       ), 
    .SCANOUTPCLK   (SCANOUTPWM1_5      )
);

APB_Timers_PWM1_6 uAPB_Timers_PWM1_6 
(
//APB
     .PCLK         ( HCLK              ), 
     .PRESETn      ( HRESETn           ), 
     .PENABLE      ( PENABLE           ), 
     .PSEL         ( PSELS6X6          ), 
     .PWRITE       ( PWRITE            ), 
     .PADDR        ( PADDR[11:2]       ), 
     .PWDATA       ( PWDATA            ),
     .PRDATA       ( PRDATAS6X6        ),
//Function
     .TCLK         ( TCLK6             ),
     .TCAP         ( TCAP              ),
     .INT_TPOUT    ( INT_TPOUT_PWM1[6] ),
     .INT_TOF      ( INT_TOF_PWM1[6]   ),
     .INT_TMC      ( INT_TMC_PWM1[6]   ),

     .SCANENABLE    (SCANENABLE         ), 
     .SCANINPCLK    (SCANINPWM1_6       ), 
     .SCANOUTPCLK   (SCANOUTPWM1_6      )
);


APB_Timers_PWM1_7 uAPB_Timers_PWM1_7 
(
//APB
     .PCLK         ( HCLK              ), 
     .PRESETn      ( HRESETn           ), 
     .PENABLE      ( PENABLE           ), 
     .PSEL         ( PSELS6X7          ), 
     .PWRITE       ( PWRITE            ), 
     .PADDR        ( PADDR[11:2]       ), 
     .PWDATA       ( PWDATA            ),
     .PRDATA       ( PRDATAS6X7        ),
//Function
     .TCLK         ( TCLK7             ),
     .TCAP         ( TCAP              ),
     .INT_TPOUT    ( INT_TPOUT_PWM1[7] ),
     .INT_TOF      ( INT_TOF_PWM1[7]   ),
     .INT_TMC      ( INT_TMC_PWM1[7]   ),

     .SCANENABLE    (SCANENABLE         ), 
     .SCANINPCLK    (SCANINPWM1_7       ), 
     .SCANOUTPCLK   (SCANOUTPWM1_7      )
);


//=======================================================
//PWM2_0 ~ PWM2_7
//=======================================================

  
APB_Timers_PWM2_0 uAPB_Timers_PWM2_0 
(
//APB
     .PCLK         ( HCLK              ), 
     .PRESETn      ( HRESETn           ), 
     .PENABLE      ( PENABLE           ), 
     .PSEL         ( PSELS7X0          ), 
     .PWRITE       ( PWRITE            ), 
     .PADDR        ( PADDR[11:2]       ), 
     .PWDATA       ( PWDATA            ),
     .PRDATA       ( PRDATAS7X0        ),

//Function
     .TCLK         ( TCLK0             ),
     .TCAP         ( TCAP              ),
     .INT_TPOUT    ( INT_TPOUT_PWM2[0] ),
     .INT_TOF      ( INT_TOF_PWM2[0]   ),
     .INT_TMC      ( INT_TMC_PWM2[0]   ),

    .SCANENABLE    (SCANENABLE         ), 
    .SCANINPCLK    (SCANINPWM2_0       ), 
    .SCANOUTPCLK   (SCANOUTPWM2_0      )
);


APB_Timers_PWM2_1 uAPB_Timers_PWM2_1 
(
//APB
     .PCLK         ( HCLK              ), 
     .PRESETn      ( HRESETn           ), 
     .PENABLE      ( PENABLE           ), 
     .PSEL         ( PSELS7X1          ), 
     .PWRITE       ( PWRITE            ), 
     .PADDR        ( PADDR[11:2]       ), 
     .PWDATA       ( PWDATA            ),
     .PRDATA       ( PRDATAS7X1        ),

//Function
     .TCLK         ( TCLK1             ),
     .TCAP         ( TCAP              ),
     .INT_TPOUT    ( INT_TPOUT_PWM2[1] ),
     .INT_TOF      ( INT_TOF_PWM2[1]   ),
     .INT_TMC      ( INT_TMC_PWM2[1]   ),

    .SCANENABLE    (SCANENABLE         ), 
    .SCANINPCLK    (SCANINPWM2_1       ), 
    .SCANOUTPCLK   (SCANOUTPWM2_1      )
);

APB_Timers_PWM2_2 uAPB_Timers_PWM2_2 
(
//APB
     .PCLK         ( HCLK              ), 
     .PRESETn      ( HRESETn           ), 
     .PENABLE      ( PENABLE           ), 
     .PSEL         ( PSELS7X2          ), 
     .PWRITE       ( PWRITE            ), 
     .PADDR        ( PADDR[11:2]       ), 
     .PWDATA       ( PWDATA            ),
     .PRDATA       ( PRDATAS7X2        ),

//Function
     .TCLK         ( TCLK2             ),
     .TCAP         ( TCAP              ),
     .INT_TPOUT    ( INT_TPOUT_PWM2[2] ),
     .INT_TOF      ( INT_TOF_PWM2[2]   ),
     .INT_TMC      ( INT_TMC_PWM2[2]   ),

    .SCANENABLE    (SCANENABLE         ), 
    .SCANINPCLK    (SCANINPWM2_2       ), 
    .SCANOUTPCLK   (SCANOUTPWM2_2      )
);

APB_Timers_PWM2_3 uAPB_Timers_PWM2_3 
(
//APB
     .PCLK         ( HCLK              ), 
     .PRESETn      ( HRESETn           ), 
     .PENABLE      ( PENABLE           ), 
     .PSEL         ( PSELS7X3          ), 
     .PWRITE       ( PWRITE            ), 
     .PADDR        ( PADDR[11:2]       ), 
     .PWDATA       ( PWDATA            ),
     .PRDATA       ( PRDATAS7X3        ),

//Function
     .TCLK         ( TCLK3             ),
     .TCAP         ( TCAP              ),
     .INT_TPOUT    ( INT_TPOUT_PWM2[3] ),
     .INT_TOF      ( INT_TOF_PWM2[3]   ),
     .INT_TMC      ( INT_TMC_PWM2[3]   ),

    .SCANENABLE    (SCANENABLE         ), 
    .SCANINPCLK    (SCANINPWM2_3       ), 
    .SCANOUTPCLK   (SCANOUTPWM2_3      )
);


APB_Timers_PWM2_4 uAPB_Timers_PWM2_4 
(
//APB
     .PCLK         ( HCLK              ), 
     .PRESETn      ( HRESETn           ), 
     .PENABLE      ( PENABLE           ), 
     .PSEL         ( PSELS7X4          ), 
     .PWRITE       ( PWRITE            ), 
     .PADDR        ( PADDR[11:2]       ), 
     .PWDATA       ( PWDATA            ),
     .PRDATA       ( PRDATAS7X4        ),

//Function
     .TCLK         ( TCLK4             ),
     .TCAP         ( TCAP              ),
     .INT_TPOUT    ( INT_TPOUT_PWM2[4] ),
     .INT_TOF      ( INT_TOF_PWM2[4]   ),
     .INT_TMC      ( INT_TMC_PWM2[4]   ),

    .SCANENABLE    (SCANENABLE         ), 
    .SCANINPCLK    (SCANINPWM2_4       ), 
    .SCANOUTPCLK   (SCANOUTPWM2_4      )
);


APB_Timers_PWM2_5 uAPB_Timers_PWM2_5 
(
//APB
     .PCLK         ( HCLK              ), 
     .PRESETn      ( HRESETn           ), 
     .PENABLE      ( PENABLE           ), 
     .PSEL         ( PSELS7X5          ), 
     .PWRITE       ( PWRITE            ), 
     .PADDR        ( PADDR[11:2]       ), 
     .PWDATA       ( PWDATA            ),
     .PRDATA       ( PRDATAS7X5        ),

//Function
     .TCLK         ( TCLK5             ),
     .TCAP         ( TCAP              ),
     .INT_TPOUT    ( INT_TPOUT_PWM2[5] ),
     .INT_TOF      ( INT_TOF_PWM2[5]   ),
     .INT_TMC      ( INT_TMC_PWM2[5]   ),

    .SCANENABLE    (SCANENABLE         ), 
    .SCANINPCLK    (SCANINPWM2_5       ), 
    .SCANOUTPCLK   (SCANOUTPWM2_5      )
);


APB_Timers_PWM2_6 uAPB_Timers_PWM2_6 
(
//APB
     .PCLK         ( HCLK              ), 
     .PRESETn      ( HRESETn           ), 
     .PENABLE      ( PENABLE           ), 
     .PSEL         ( PSELS7X6          ), 
     .PWRITE       ( PWRITE            ), 
     .PADDR        ( PADDR[11:2]       ), 
     .PWDATA       ( PWDATA            ),
     .PRDATA       ( PRDATAS7X6        ),

//Function
     .TCLK         ( TCLK6             ),
     .TCAP         ( TCAP              ),
     .INT_TPOUT    ( INT_TPOUT_PWM2[6] ),
     .INT_TOF      ( INT_TOF_PWM2[6]   ),
     .INT_TMC      ( INT_TMC_PWM2[6]   ),

    .SCANENABLE    (SCANENABLE         ), 
    .SCANINPCLK    (SCANINPWM2_6       ), 
    .SCANOUTPCLK   (SCANOUTPWM2_6      )
);

APB_Timers_PWM2_7 uAPB_Timers_PWM2_7 
(
//APB
     .PCLK         ( HCLK              ), 
     .PRESETn      ( HRESETn           ), 
     .PENABLE      ( PENABLE           ), 
     .PSEL         ( PSELS7X7          ), 
     .PWRITE       ( PWRITE            ), 
     .PADDR        ( PADDR[11:2]       ), 
     .PWDATA       ( PWDATA            ),
     .PRDATA       ( PRDATAS7X7        ),

//Function
     .TCLK         ( TCLK7             ),
     .TCAP         ( TCAP              ),
     .INT_TPOUT    ( INT_TPOUT_PWM2[7] ),
     .INT_TOF      ( INT_TOF_PWM2[7]   ),
     .INT_TMC      ( INT_TMC_PWM2[7]   ),

    .SCANENABLE    (SCANENABLE         ), 
    .SCANINPCLK    (SCANINPWM2_7       ), 
    .SCANOUTPCLK   (SCANOUTPWM2_7      )
);



//=======================================================
//PWM3_0 ~ PWM3_7
//=======================================================

  
APB_Timers_PWM3_0 uAPB_Timers_PWM3_0 
(
//APB
     .PCLK         ( HCLK              ), 
     .PRESETn      ( HRESETn           ), 
     .PENABLE      ( PENABLE           ), 
     .PSEL         ( PSELS8X0          ), 
     .PWRITE       ( PWRITE            ), 
     .PADDR        ( PADDR[11:2]       ), 
     .PWDATA       ( PWDATA            ),
     .PRDATA       ( PRDATAS8X0        ),

//Function
     .TCLK         ( TCLK0             ),
     .TCAP         ( TCAP              ),
     .INT_TPOUT    ( INT_TPOUT_PWM3[0] ),
     .INT_TOF      ( INT_TOF_PWM3[0]   ),
     .INT_TMC      ( INT_TMC_PWM3[0]   ),

    .SCANENABLE    (SCANENABLE         ), 
    .SCANINPCLK    (SCANINPWM3_0       ), 
    .SCANOUTPCLK   (SCANOUTPWM3_0      )
);


APB_Timers_PWM3_1 uAPB_Timers_PWM3_1 
(
//APB
     .PCLK         ( HCLK              ), 
     .PRESETn      ( HRESETn           ), 
     .PENABLE      ( PENABLE           ), 
     .PSEL         ( PSELS8X1          ), 
     .PWRITE       ( PWRITE            ), 
     .PADDR        ( PADDR[11:2]       ), 
     .PWDATA       ( PWDATA            ),
     .PRDATA       ( PRDATAS8X1        ),

//Function
     .TCLK         ( TCLK1             ),
     .TCAP         ( TCAP              ),
     .INT_TPOUT    ( INT_TPOUT_PWM3[1] ),
     .INT_TOF      ( INT_TOF_PWM3[1]   ),
     .INT_TMC      ( INT_TMC_PWM3[1]   ),

    .SCANENABLE    (SCANENABLE         ), 
    .SCANINPCLK    (SCANINPWM3_1       ), 
    .SCANOUTPCLK   (SCANOUTPWM3_1      )
);

APB_Timers_PWM3_2 uAPB_Timers_PWM3_2 
(
//APB
     .PCLK         ( HCLK              ), 
     .PRESETn      ( HRESETn           ), 
     .PENABLE      ( PENABLE           ), 
     .PSEL         ( PSELS8X2          ), 
     .PWRITE       ( PWRITE            ), 
     .PADDR        ( PADDR[11:2]       ), 
     .PWDATA       ( PWDATA            ),
     .PRDATA       ( PRDATAS8X2        ),

//Function
     .TCLK         ( TCLK2             ),
     .TCAP         ( TCAP              ),
     .INT_TPOUT    ( INT_TPOUT_PWM3[2] ),
     .INT_TOF      ( INT_TOF_PWM3[2]   ),
     .INT_TMC      ( INT_TMC_PWM3[2]   ),

    .SCANENABLE    (SCANENABLE         ), 
    .SCANINPCLK    (SCANINPWM3_2       ), 
    .SCANOUTPCLK   (SCANOUTPWM3_2      )
);


APB_Timers_PWM3_3 uAPB_Timers_PWM3_3 
(
//APB
     .PCLK         ( HCLK              ), 
     .PRESETn      ( HRESETn           ), 
     .PENABLE      ( PENABLE           ), 
     .PSEL         ( PSELS8X3          ), 
     .PWRITE       ( PWRITE            ), 
     .PADDR        ( PADDR[11:2]       ), 
     .PWDATA       ( PWDATA            ),
     .PRDATA       ( PRDATAS8X3        ),

//Function
     .TCLK         ( TCLK3             ),
     .TCAP         ( TCAP              ),
     .INT_TPOUT    ( INT_TPOUT_PWM3[3] ),
     .INT_TOF      ( INT_TOF_PWM3[3]   ),
     .INT_TMC      ( INT_TMC_PWM3[3]   ),

    .SCANENABLE    (SCANENABLE         ), 
    .SCANINPCLK    (SCANINPWM3_3       ), 
    .SCANOUTPCLK   (SCANOUTPWM3_3      )
);


APB_Timers_PWM3_4 uAPB_Timers_PWM3_4 
(
//APB
     .PCLK         ( HCLK              ), 
     .PRESETn      ( HRESETn           ), 
     .PENABLE      ( PENABLE           ), 
     .PSEL         ( PSELS8X4          ), 
     .PWRITE       ( PWRITE            ), 
     .PADDR        ( PADDR[11:2]       ), 
     .PWDATA       ( PWDATA            ),
     .PRDATA       ( PRDATAS8X4        ),

//Function
     .TCLK         ( TCLK4             ),
     .TCAP         ( TCAP              ),
     .INT_TPOUT    ( INT_TPOUT_PWM3[4] ),
     .INT_TOF      ( INT_TOF_PWM3[4]   ),
     .INT_TMC      ( INT_TMC_PWM3[4]   ),

    .SCANENABLE    (SCANENABLE         ), 
    .SCANINPCLK    (SCANINPWM3_4       ), 
    .SCANOUTPCLK   (SCANOUTPWM3_4      )
);


APB_Timers_PWM3_5 uAPB_Timers_PWM3_5 
(
//APB
     .PCLK         ( HCLK              ), 
     .PRESETn      ( HRESETn           ), 
     .PENABLE      ( PENABLE           ), 
     .PSEL         ( PSELS8X5          ), 
     .PWRITE       ( PWRITE            ), 
     .PADDR        ( PADDR[11:2]       ), 
     .PWDATA       ( PWDATA            ),
     .PRDATA       ( PRDATAS8X5        ),

//Function
     .TCLK         ( TCLK5             ),
     .TCAP         ( TCAP              ),
     .INT_TPOUT    ( INT_TPOUT_PWM3[5] ),
     .INT_TOF      ( INT_TOF_PWM3[5]   ),
     .INT_TMC      ( INT_TMC_PWM3[5]   ),

    .SCANENABLE    (SCANENABLE         ), 
    .SCANINPCLK    (SCANINPWM3_5       ), 
    .SCANOUTPCLK   (SCANOUTPWM3_5      )
);


APB_Timers_PWM3_6 uAPB_Timers_PWM3_6 
(
//APB
     .PCLK         ( HCLK              ), 
     .PRESETn      ( HRESETn           ), 
     .PENABLE      ( PENABLE           ), 
     .PSEL         ( PSELS8X6          ), 
     .PWRITE       ( PWRITE            ), 
     .PADDR        ( PADDR[11:2]       ), 
     .PWDATA       ( PWDATA            ),
     .PRDATA       ( PRDATAS8X6        ),

//Function
     .TCLK         ( TCLK6             ),
     .TCAP         ( TCAP              ),
     .INT_TPOUT    ( INT_TPOUT_PWM3[6] ),
     .INT_TOF      ( INT_TOF_PWM3[6]   ),
     .INT_TMC      ( INT_TMC_PWM3[6]   ),

    .SCANENABLE    (SCANENABLE         ), 
    .SCANINPCLK    (SCANINPWM3_6       ), 
    .SCANOUTPCLK   (SCANOUTPWM3_6      )
);


APB_Timers_PWM3_7 uAPB_Timers_PWM3_7 
(
//APB
     .PCLK         ( HCLK              ), 
     .PRESETn      ( HRESETn           ), 
     .PENABLE      ( PENABLE           ), 
     .PSEL         ( PSELS8X7          ), 
     .PWRITE       ( PWRITE            ), 
     .PADDR        ( PADDR[11:2]       ), 
     .PWDATA       ( PWDATA            ),
     .PRDATA       ( PRDATAS8X7        ),

//Function
     .TCLK         ( TCLK7             ),
     .TCAP         ( TCAP              ),
     .INT_TPOUT    ( INT_TPOUT_PWM3[7] ),
     .INT_TOF      ( INT_TOF_PWM3[7]   ),
     .INT_TMC      ( INT_TMC_PWM3[7]   ),

    .SCANENABLE    (SCANENABLE         ), 
    .SCANINPCLK    (SCANINPWM3_7       ), 
    .SCANOUTPCLK   (SCANOUTPWM3_7      )
);
*/     

APB_WDT      uAPB_WDT 
(
//APB
.PCLK         (HCLK            ), 
.PRESETn      (HRESETn         ), 
.PENABLE      (PENABLE         ), 
.PSEL         (PSELS9          ), 
.PWRITE       (PWRITE          ), 
.PADDR        (PADDR[7:2]     ), 
.PWDATA       (PWDATA          ),
.PRDATA       (PRDATAS9        ),

//Function
.WDOGRESn     (WDOGRESn        ),  // Watchdog clock reset  
.WDOGINT      (WDOGINT         ),  // Watchdog interrupt    
.WDOGRES      (WDOGRES         ),  // Watchdog timeout reset

.SCANENABLE   (SCANENABLE       ), 
.SCANINPCLK   (SCANINwdog       ), 
.SCANOUTPCLK  (SCANOUTwdog      )

);


 APB_Gpio  uAPB_Gpio
(
.PCLK         (HCLK           ), 
.PRESETn      (HRESETn        ), 
.PENABLE      (PENABLE        ), 
.PSEL         (PSELS10        ), 
.PWRITE       (PWRITE         ), 
.PADDR        (PADDR[11:2]    ), 
.PWDATA       (PWDATA         ),
.PRDATA       (PRDATAS10      ),

//Function
.Gpio_IN0     (Gpio_IN0       ),//From BI-PAD
.Gpio_IN1     (Gpio_IN1       ),//From BI-PAD
.Gpio_IN2     (Gpio_IN2       ),//From BI-PAD
.Gpio_IN3     (Gpio_IN3       ),//From BI-PAD

.Tout         (INT_TPOUT      ),//Fromm Timer
.MEM_ADR      (3'b001         ),//From Mem_Ctrl
.MEM_BE       (2'b10          ),//From Mem_Ctrl  
.POUT         (INT_TPOUT_PWM0 ),//From PWM0
.UART_RXD     (1'b1           ),//From UART
.UART_TXD     (1'b0           ),//From UART
.IrDA_RXD     (1'b0           ),//From UART
.IrDA_TXD     (1'b1           ),//From UART
.MEM_WBE      (2'b10          ),//From Mem_Ctrl
.MEM_CS       (2'b01          ),//From Mem_Ctrl

//output
.GPIO_En0     (GPIO_En0       ),//To BI-PAD 
.GPIO_En1     (GPIO_En1       ),//To BI-PAD 
.GPIO_En2     (GPIO_En2       ),//To BI-PAD 
.GPIO_En3     (GPIO_En3       ),//To BI-PAD 

.Mux_Out0     (Mux_Out0       ),//To BI-PAD
.Mux_Out1     (Mux_Out1       ),//To BI-PAD
.Mux_Out2     (Mux_Out2       ),//To BI-PAD
.Mux_Out3     (Mux_Out3       ),//To BI-PAD

.SCANENABLE   (SCANENABLE     ), 
.SCANINPCLK   (SCANINgpio     ), 
.SCANOUTPCLK  (SCANOUTgpio    )
);


IO_PAD uIO_PAD
(
.Dir_En0      (GPIO_En0   ),
.Dir_En1      (GPIO_En1   ),
.Dir_En2      (GPIO_En2   ),
.Dir_En3      (GPIO_En3   ),

.Data_Out0    (Mux_Out0   ),
.Data_Out1    (Mux_Out1   ),
.Data_Out2    (Mux_Out2   ),
.Data_Out3    (Mux_Out3   ),

.Data_In0     (Gpio_IN0   ),
.Data_In1     (Gpio_IN1   ),
.Data_In2     (Gpio_IN2   ),
.Data_In3     (Gpio_IN3   ),

.BI_PAD0      (EINT_Gpio0 ),
.BI_PAD1      (TCAP_Gpio1 ),
.BI_PAD2      (PWM_Gpio2  ),
.BI_PAD3      (UART_Gpio3 )
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
  assign PRDATAS4 = TieOffLo32;            //Timer
  assign PRDATAS5 = TieOffLo32;
  assign PRDATAS6 = TieOffLo32;
  assign PRDATAS7 = TieOffLo32;
  assign PRDATAS8 = TieOffLo32;            // Remap/Pause
  //assign PRDATAS9 = TieOffLo32;            //Watchdog
  //assign PRDATAS10 = TieOffLo32;           //Gpio
  assign PRDATAS11 = TieOffLo32;
 // assign PRDATAS12 = TieOffLo32;         //ADC
 // assign PRDATAS13 = TieOffLo32;         //POWER
  assign PRDATAS14 = TieOffLo32;
  assign PRDATAS15 = TieOffLo32;           // Example APB Slave


endmodule

// --================================= End ===================================--
