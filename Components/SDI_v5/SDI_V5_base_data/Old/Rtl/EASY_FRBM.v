//  --========================================================================--
//  This confidential and proprietary software may be used only as
//  authorised by a licensing agreement from ARM Limited
//    (C) COPYRIGHT 2001 ARM Limited
//        ALL RIGHTS RESERVED
//  The entire notice above must be reproduced on all authorised
//  copies and copies may only be made to the extent permitted
//  by a licensing agreement from ARM Limited.
//  
//  ----------------------------------------------------------------------------
//  Version and Release Control Information:
//  
//  File Name           : EASY_FRBM.v,v
//  File Revision       : 1.19
//  
//  Release Information : ADK_REL1v1
//  
//  ----------------------------------------------------------------------------
//  Purpose             : Structural architecture of Example Amba SYstem (EASY)
//                        with File Reader Bus Master and EgMaster.
//  --========================================================================--

//------------------------------------------------------------------------------
// EASY_FRBM Address Map
//------------------------------------------------------------------------------
// Full Decoding of the Address Map is performed continuously as a function of
//  HADDR. All unused slots are connected to the Default Slave.
//
// AHB address map is:
//
// 0x00000000 - 0x000FFFFF Default Slave (Remap LOW)  (HSELS0B) (SMI alias)
// 0x00000000 - 0x000FFFFF IntMem alias  (Remap HIGH) (HSELS0R)
// 0x00100000 - 0x10000000 Default Slave              (HSELS0)  (SDRAM)
// 0x10000000 - 0x1FFFFFFF Default Slave              (HSELS1)
// 0x20000000 - 0x2FFFFFFF Default Slave              (HSELS2)
// 0x30000000 - 0x3FFFFFFF Default Slave              (HSELS3)  (SMI)
// 0x40000000 - 0x4FFFFFFF Default Slave              (HSELS4)
// 0x50000000 - 0x5FFFFFFF Default Slave              (HSELS5)
// 0x60000000 - 0x6FFFFFFF Default Slave              (HSELS6)
// 0x70000000 - 0x7FFFFFFF IntMem                     (HSELS7)
// 0x80000000 - 0x8FFFFFFF Default Slave              (HSELS8)
// 0x90000000 - 0x9FFFFFFF Default Slave              (HSELS9)
// 0xA0000000 - 0xAFFFFFFF Default Slave              (HSELS10)
// 0xB0000000 - 0xBFFFFFFF Default Slave              (HSELS11)
// 0xC0000000 - 0xCFFFFFFF APB Peripherals            (HSELS12)
// 0xD0000000 - 0xDFFFFFFF Retry Slave                (HSELS13)
// 0xE0000000 - 0xEFFFFFFF Default Slave              (HSELS14)
// 0xF0000000 - 0xFFFFFFFF Interrupt Controller       (HSELS15)
//
// APB address map is:
//
// 0xC0000000 - 0xC0FFFFFF Unused                     (PSELS0)  (System Control)
// 0xC1000000 - 0xC1FFFFFF Watchdog                   (PSELS1)
// 0xC2000000 - 0xC2FFFFFF Timers                     (PSELS2)
// 0xC3000000 - 0xC3FFFFFF Unused                     (PSELS3)  (Extra Timers)
// 0xC4000000 - 0xC4FFFFFF GPIO                       (PSELS4)
// 0xC5000000 - 0xC5FFFFFF Unused                     (PSELS5)  (Extra GPIO)
// 0xC6000000 - 0xC6FFFFFF Unused                     (PSELS6)  (Extra GPIO)
// 0xC7000000 - 0xC7FFFFFF Unused                     (PSELS7)  (Extra GPIO)
// 0xC8000000 - 0xC8FFFFFF Remap/Pause                (PSELS8)
// 0xC9000000 - 0xC9FFFFFF Unused                     (PSELS9)
// 0xCA000000 - 0xCAFFFFFF Unused                     (PSELS10)
// 0xCB000000 - 0xCBFFFFFF Unused                     (PSELS11)
// 0xCC000000 - 0xCCFFFFFF Unused                     (PSELS12)
// 0xCD000000 - 0xCDFFFFFF Unused                     (PSELS13)
// 0xCE000000 - 0xCEFFFFFF Unused                     (PSELS14)
// 0xCF000000 - 0xCFFFFFFF EgAPBSlave                 (PSELS15)
//
//------------------------------------------------------------------------------

`timescale 1ns/1ps

module EASY_FRBM (XCLKIN, nReset, GPIN, GPOUT, nGPEN, nGPAFEN, GPAFOUT, 
                  GPAFIN, SCANENABLE, SCANINHCLK, SCANOUTHCLK, SCANINPCLK, 
                  SCANOUTPCLK);

  input         XCLKIN;   // External clock in
  input         nReset;   // Power on reset in

  // GPIO lines
  input   [7:0] GPIN;     // Inputs
  output  [7:0] GPOUT;    // Outputs
  output  [7:0] nGPEN;    // Output ctrl enable
  input   [7:0] nGPAFEN;  // H/w ctrl enable
  input   [7:0] GPAFOUT;  // H/w ctrl inputs
  output  [7:0] GPAFIN;   // H/w ctrl outputs

  // Scan test dummy signals; not connected until scan insertion 
  input         SCANENABLE;  // Scan Test Mode Enbl
  input         SCANINHCLK;  // Scan Chain Input (HCLK)
  output        SCANOUTHCLK; // Scan Chain Output (HCLK)
  input         SCANINPCLK;  // Scan Chain Input (PCLK)
  output        SCANOUTPCLK; // Scan Chain Output (PCLK)


//------------------------------------------------------------------------------
// Signal declarations
//------------------------------------------------------------------------------

  // Input/Output Signals
  wire         XCLKIN;
  wire         nReset;
  wire   [7:0] GPIN;
  wire   [7:0] GPOUT;
  wire   [7:0] nGPEN;
  wire   [7:0] nGPAFEN;
  wire   [7:0] GPAFOUT;
  wire   [7:0] GPAFIN;
  wire         SCANENABLE;
  wire         SCANINHCLK;
  wire         SCANOUTHCLK;
  wire         SCANINPCLK;
  wire         SCANOUTPCLK;

//--------------------------------------
// AHB Signals
//--------------------------------------

  // AHB common
  wire         HCLK;
  wire         HRESETn;

  // AHB backbone
  wire [1:0]   HTRANS;
  wire [31:0]  HADDR;
  wire         HWRITE;
  wire [2:0]   HSIZE;
  wire [2:0]   HBURST;
  wire [3:0]   HPROT;
  wire [31:0]  HWDATA;
  wire [3:0]   HMASTER;
  wire [3:0]   HMASTERD;
  wire         HMASTLOCK;
  wire [15:0]  HSPLIT;

  // Multiplexed slave output signals
  wire [31:0]  HRDATA;
  wire         HREADY;
  wire [1:0]   HRESP;

  // Slave specific output signal
  wire         HSELS0B;
  wire         HSELS0R;

  wire         HSELS0;
  wire [31:0]  HRDATAS0;
  wire         HREADYS0;
  wire [1:0]   HRESPS0;

  wire         HSELS1;
  wire [31:0]  HRDATAS1;
  wire         HREADYS1;
  wire [1:0]   HRESPS1;

  wire         HSELS2;
  wire [31:0]  HRDATAS2;
  wire         HREADYS2;
  wire [1:0]   HRESPS2;

  wire         HSELS3;
  wire [31:0]  HRDATAS3;
  wire         HREADYS3;
  wire [1:0]   HRESPS3;

  wire         HSELS4;
  wire [31:0]  HRDATAS4;
  wire         HREADYS4;
  wire [1:0]   HRESPS4;

  wire         HSELS5;
  wire [31:0]  HRDATAS5;
  wire         HREADYS5;
  wire [1:0]   HRESPS5;

  wire         HSELS6;
  wire [31:0]  HRDATAS6;
  wire         HREADYS6;
  wire [1:0]   HRESPS6;

  wire         HSELS7;
  wire [31:0]  HRDATAS7;
  wire         HREADYS7;
  wire [1:0]   HRESPS7;

  wire         HSELS8;
  wire         HSELS9;
  wire         HSELS10;
  wire         HSELS11;
  wire         HSELS12;
  wire         HSELS13;
  wire         HSELS14;
  wire         HSELS15;

  wire         HSELDefault;
  wire         HREADYDefault;
  wire [1:0]   HRESPDefault;

  // Combined AHB select lines
  wire         HSELIntMem;

  // Master specific signals
  wire         HBUSREQM0;
  wire         HLOCKM0;
  wire         HGRANTM0;

  wire [31:0]  HADDRM1;
  wire [1:0]   HTRANSM1;
  wire         HWRITEM1;
  wire [2:0]   HSIZEM1;
  wire [2:0]   HBURSTM1;
  wire [3:0]   HPROTM1;
  wire [31:0]  HWDATAM1;
  wire         HBUSREQM1;
  wire         HLOCKM1;
  wire         HGRANTM1;

  wire [31:0]  HADDRM2;
  wire [1:0]   HTRANSM2;
  wire         HWRITEM2;
  wire [2:0]   HSIZEM2;
  wire [2:0]   HBURSTM2;
  wire [3:0]   HPROTM2;
  wire [31:0]  HWDATAM2;
  wire         HBUSREQM2;
  wire         HLOCKM2;
  wire         HGRANTM2;

  wire [31:0]  HADDRM3;
  wire [1:0]   HTRANSM3;
  wire         HWRITEM3;
  wire [2:0]   HSIZEM3;
  wire [2:0]   HBURSTM3;
  wire [3:0]   HPROTM3;
  wire [31:0]  HWDATAM3;
  wire         HBUSREQM3;
  wire         HLOCKM3;
  wire         HGRANTM3;

//--------------------------------------
// APB Signals
//--------------------------------------

  // APB backbone
  wire         PENABLE;
  wire [23:0]  PADDR;
  wire         PWRITE;
  wire [31:0]  PWDATA;
  wire [31:0]  PRDATA;

  // Slave-specific APB signals
  wire         PSELS0;
  wire         PSELS1;
  wire         PSELS2;
  wire         PSELS3;
  wire         PSELS4;
  wire         PSELS5;
  wire         PSELS6;
  wire         PSELS7;
  wire         PSELS8;
  wire         PSELS9;
  wire         PSELS10;
  wire         PSELS11;
  wire         PSELS12;
  wire         PSELS13;
  wire         PSELS14;
  wire         PSELS15;

  wire [31:0]  PRDATAS0;
  wire [31:0]  PRDATAS1;
  wire [31:0]  PRDATAS2;
  wire [31:0]  PRDATAS3;
  wire [31:0]  PRDATAS4;
  wire [31:0]  PRDATAS5;
  wire [31:0]  PRDATAS6;
  wire [31:0]  PRDATAS7;
  wire [31:0]  PRDATAS8;
  wire [31:0]  PRDATAS9;
  wire [31:0]  PRDATAS10;
  wire [31:0]  PRDATAS11;
  wire [31:0]  PRDATAS12;
  wire [31:0]  PRDATAS13;
  wire [31:0]  PRDATAS14;
  wire [31:0]  PRDATAS15;

  // Interrupt lines
  wire [31:0]  IntSource;     //  System interrupt bus 
  wire         TIMINT1;       //  Timer interrupt 1 
  wire         TIMINT2;       //  Timer interrupt 2 
  wire         TIMINTC;       //  Combined timer interrupt 
  wire         WDOGINT;       //  Watchdog interrupt 
  wire         GPIOINTR;      //  GPIO interrupt 
  wire [7:0]   GPIOMIS;       //  GPIO interrupt bus 
  wire         nFIQ;          //  Fast interrupt request output from the
                              //   interrupt controller 
  wire         nIRQ;          //  Interrupt request output from the
                              //   interrupt controller 
  wire [31:0]  ICVECTADDROUT; //  Interrupt controller vector address

//--------------------------------------
// Example System Signals
//--------------------------------------  

  wire         Remap;
  wire         Pause;

  wire         WDOGRESn;
  wire         WDOGRES;

//--------------------------------------
// Scan Signals
//--------------------------------------  

  wire         SCANINtimers;
  wire         SCANOUTtimers;
  wire         SCANINwdog;
  wire         SCANOUTwdog;
  wire         SCANINrpc;
  wire         SCANOUTrpc;
  wire         SCANINic;
  wire         SCANOUTic;
  wire         SCANINgpio;
  wire         SCANOUTgpio;
  wire         SCANINdefslv;
  wire         SCANOUTdefslv;
  wire         SCANINs2m;
  wire         SCANOUTs2m;
  wire         SCANINarb;
  wire         SCANOUTarb;
  wire         SCANINegapb;
  wire         SCANOUTegapb;
  wire         SCANINegmst;
  wire         SCANOUTegmst;
  wire         SCANINretry;
  wire         SCANOUTretry;
  wire         SCANINapb;
  wire         SCANOUTapb;

//--------------------------------------
// Tie-off Signals
//--------------------------------------  

  wire         TieOffHi1;
  wire         TieOffLo1;
  wire [1:0]   TieOffLo2;
  wire [31:0]  TieOffLo32;


//------------------------------------------------------------------------------
// Beginning of main code
//------------------------------------------------------------------------------

  // The TieOff signals must be assigned explicitly within the body of the
  //  Verilog. Using initial values will not work in Synopsys.
  // Signals are used rather than constants as constants can not be connected
  //  directly to sub-component instantiations
  assign TieOffHi1  = 1'b1;
  assign TieOffLo1  = 1'b0;
  assign TieOffLo2  = 2'b00;
  assign TieOffLo32 = 1'b0;

  // Drive the AHB clock with the external clock input.
  assign HCLK = XCLKIN;

  // Bus reset controller
  ResetCntl uResetCntl 
    (
     .HCLK     (HCLK),
     .nPOReset (nReset),
     .WDOGRES  (WDOGRES),
     .HRESETn  (HRESETn),
     .WDOGRESn (WDOGRESn)
    );

  // File Reader Bus Master instantiated as AHB master 1 (lowest priority)
  FileReader
  // synopsys translate_off
    // Parameter:
    //   Default file name: InputFileName = "filestim.frd"
    #("filestim.frd")
  // synopsys translate_on
  uFileReader 
    (
     .HCLK    (HCLK),
     .HRESETn (WDOGRESn),  // Not reset via HRESETn, to allow Reset test

     .HGRANT  (HGRANTM1),
     .HREADY  (HREADY),
     .HRESP   (HRESP),
     .HRDATA  (HRDATA),

     .HBUSREQ (HBUSREQM1),
     .HTRANS  (HTRANSM1),
     .HBURST  (HBURSTM1),
     .HPROT   (HPROTM1),
     .HSIZE   (HSIZEM1),
     .HWRITE  (HWRITEM1),
     .HLOCK   (HLOCKM1),
     .HADDR   (HADDRM1),
     .HWDATA  (HWDATAM1)
    );

  // Example Bus Master instantiated as AHB master 2
  EgMaster 
  // synopsys translate_off
    // Parameters:
    //   Block enable: EBMenable = 1, 
    //   Base address read: EBMreadAddr = 0xD0000000 (RetrySlave),
    //   Base address write: EBMwriteAddr = 0xC4000000 (GPIO),
    //   Delay between transactions: EBMinitCount = 4
    #(1, 8'hD0, 8'hC4, 10'h004)
  // synopsys translate_on
  uEgMaster 
    (
     .HCLK        (HCLK),
     .HRESETn     (HRESETn),

     .HRDATA      (HRDATA),
     .HREADY      (HREADY),
     .HRESP       (HRESP),
     .HGRANT      (HGRANTM2),

     .HADDR       (HADDRM2),
     .HTRANS      (HTRANSM2),
     .HWRITE      (HWRITEM2),
     .HSIZE       (HSIZEM2),
     .HBURST      (HBURSTM2),
     .HPROT       (HPROTM2),
     .HWDATA      (HWDATAM2),
     .HBUSREQ     (HBUSREQM2),
     .HLOCK       (HLOCKM2),

     // Scan test dummy signals; not connected until scan insertion
     .SCANENABLE  (SCANENABLE),  // Scan Test Mode Enbl
     .SCANINHCLK  (SCANINegmst), // Scan Chain Input
     .SCANOUTHCLK (SCANOUTegmst) // Scan Chain Output    
    );

  // Internal Memory instantiated as AHB slave 0
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

     .HADDR      (HADDR),
     .HTRANS     (HTRANS),
     .HWRITE     (HWRITE),
     .HSIZE      (HSIZE),
     .HWDATA     (HWDATA),
     .HSELIntMem (HSELIntMem), // Decoder slots 0 (re-map) and 7
     .HREADY     (HREADY),

     .HRDATA     (HRDATAS0),   // Channel 0 of MuxS2M
     .HREADYOUT  (HREADYS0),
     .HRESP      (HRESPS0)
    );

  // AHB to APB Bridge instantiated as AHB slave 12
  APBif uAPBif 
    (
     .HCLK        (HCLK),
     .HRESETn     (HRESETn),

     .HADDR       (HADDR[27:0]),
     .HTRANS      (HTRANS),
     .HWRITE      (HWRITE),
     .HWDATA      (HWDATA),
     .HSEL        (HSELS12),   // Decoder slot 12
     .HREADY      (HREADY),
     .HRDATA      (HRDATAS1),  // Channel 1 of MuxS2M
     .HREADYOUT   (HREADYS1),
     .HRESP       (HRESPS1),

     .PRDATA      (PRDATA),    // From MuxP2B output

     .PADDR       (PADDR),
     .PWRITE      (PWRITE),
     .PWDATA      (PWDATA),
     .PENABLE     (PENABLE),
     .PSELS0      (PSELS0),
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

  // Retry Slave (example code template) instantiated as AHB slave 13
  RetrySlave uRetrySlave 
    (
     .HCLK        (HCLK),
     .HRESETn     (HRESETn),

     .HADDR       (HADDR),
     .HTRANS      (HTRANS),
     .HWRITE      (HWRITE),
     .HSIZE       (HSIZE),
     .HWDATA      (HWDATA),
     .HSELRetry   (HSELS13),     // Decoder slot 13
     .HREADY      (HREADY),

     .HRDATA      (HRDATAS2),    // Channel 2 of MuxS2M
     .HREADYOUT   (HREADYS2),
     .HRESP       (HRESPS2),

     // Scan test dummy signals; not connected until scan insertion 
     .SCANENABLE  (SCANENABLE),  // Scan Test Mode Enbl
     .SCANINHCLK  (SCANINretry), // Scan Chain Input
     .SCANOUTHCLK (SCANOUTretry) // Scan Chain Output    
    );

  // Interrupt Controller instantiated as AHB slave 15
  Interrupt uInterrupt 
    (
     .HCLK          (HCLK),
     .HRESETn       (HRESETn),
    
     .HSELIC        (HSELS15),       // Decoder slot 15
     .HWRITE        (HWRITE),
     .HREADY        (HREADY),
     .HPROT         (HPROT[1]),      // Privileged access
     .HTRANS        (HTRANS[1]),
     .HSIZE         (HSIZE),
     .ICINTSOURCE   (IntSource),     // System interrupts
     .nICFIQIN      (TieOffHi1),     // Connect daisy-chained 
     .nICIRQIN      (TieOffHi1),     //  interrupt controllers here
     .ICVECTADDRIN  (TieOffLo32),
     .HWDATA        (HWDATA),
     .HADDR         (HADDR[11:2]),
     .HREADYOUT     (HREADYS3),      // Channel 3 of MuxS2M
     .HRESP         (HRESPS3),
     .HRDATA        (HRDATAS3),
     .nICFIQ        (nFIQ),          // Interrupt outputs only connected
     .nICIRQ        (nIRQ),          //  to Remap/Pause controller
     .ICVECTADDROUT (ICVECTADDROUT),
  
     // Scan test dummy signals; not connected until scan insertion 
     .SCANENABLE    (SCANENABLE), // Scan Test Mode Enbl
     .SCANINHCLK    (SCANINic),   // Scan Chain Input
     .SCANOUTHCLK   (SCANOUTic)   // Scan Chain Output    
    );

  assign IntSource = {
    GPIOMIS,  // 31:24 GPIO Masked interrupts
    4'b0000,  // 23:20
    4'b0000,  // 19:16
    4'b0000,  // 15:12
    3'b000,   // 11:9
    GPIOINTR, // 8     GPIO Combined interrupt
    WDOGINT,  // 7     Watchdog
    TIMINTC,  // 6     Counter combined
    TIMINT2,  // 5     Counter 2
    TIMINT1,  // 4     Counter 1
    1'b0,     // 3     Undefined (ARM Comms Tx)
    1'b0,     // 2     Undefined (ARM Comms Rx)
    1'b0,     // 1     Software interrupt
    1'b0};    // 0     Undefined

  // AHB system Arbiter
  Arbiter3 uArbiter3 
    (
     .HCLK        (HCLK),
     .HRESETn     (HRESETn),

     .HTRANS      (HTRANS),
     .HBURST      (HBURST),
     .HREADY      (HREADY),
     .HRESP       (HRESP),

     .HBUSREQM3   (HBUSREQM3),
     .HBUSREQM2   (HBUSREQM2),
     .HBUSREQM1   (HBUSREQM1),
     .HBUSREQM0   (HBUSREQM0),

     .HLOCKM3     (HLOCKM3),
     .HLOCKM2     (HLOCKM2),
     .HLOCKM1     (HLOCKM1),
     .HLOCKM0     (HLOCKM0),

     .HSPLIT      (HSPLIT[3:0]),

     .HGRANTM3    (HGRANTM3),
     .HGRANTM2    (HGRANTM2),
     .HGRANTM1    (HGRANTM1),
     .HGRANTM0    (HGRANTM0),

     .HMASTER     (HMASTER),
     .HMASTERD    (HMASTERD),
     .HMASTLOCK   (HMASTLOCK),

     // Scan test dummy signals; not connected until scan insertion 
     .SCANENABLE  (SCANENABLE), // Scan Test Mode Enbl
     .SCANINHCLK  (SCANINarb),  // Scan Chain Input
     .SCANOUTHCLK (SCANOUTarb)  // Scan Chain Output    
    );

  // Pause requests Master 0 (2nd highest priority)
  assign HBUSREQM0 = Pause;

  // Unconnected Arbiter inputs driven LOW
  assign HBUSREQM3 = 1'b0;
  assign HLOCKM3   = 1'b0;
  assign HLOCKM0   = 1'b0;
  assign HSPLIT    = {16{1'b0}};

  // AHB system Address Decoder
  Decoder uDecoder 
    (
     .HADDR   (HADDR[31:20]),

     .Remap   (Remap),

     .HSELS0B (HSELS0B),
     .HSELS0R (HSELS0R),
     .HSELS0  (HSELS0),
     .HSELS1  (HSELS1),
     .HSELS2  (HSELS2),
     .HSELS3  (HSELS3),
     .HSELS4  (HSELS4),
     .HSELS5  (HSELS5),
     .HSELS6  (HSELS6),
     .HSELS7  (HSELS7),
     .HSELS8  (HSELS8),
     .HSELS9  (HSELS9),
     .HSELS10 (HSELS10),
     .HSELS11 (HSELS11),
     .HSELS12 (HSELS12),
     .HSELS13 (HSELS13),
     .HSELS14 (HSELS14),
     .HSELS15 (HSELS15)
    );

  // Default Slave selected by all unused HSEL lines
  assign HSELDefault = 
    HSELS0B |
    // HSELS0R |            // IntMem alias
    HSELS0  |
    HSELS1  |
    HSELS2  |
    HSELS3  |
    HSELS4  |
    HSELS5  |
    HSELS6  |
    // HSELS7  |            // IntMem
    HSELS8  |
    HSELS9  |
    HSELS10 |
    HSELS11 | 
    // HSELS12 |            // APB Peripherals
    // HSELS13 |            // Retry Slave
    HSELS14 
    // | HSELS15            // Interrupt Controller
    ;

  // Combined AHB select lines
  assign HSELIntMem = (HSELS0R | HSELS7);

  // Default Slave (selected when no other slaves are accessed)
  DefaultSlave uDefaultSlave 
    (
     .HCLK        (HCLK),
     .HRESETn     (HRESETn),

     .HTRANS      (HTRANS),
     .HSEL        (HSELDefault),
     .HREADY      (HREADY),
     .HREADYOUT   (HREADYDefault),
     .HRESP       (HRESPDefault),

     // Scan test dummy signals; not connected until scan insertion 
     .SCANENABLE  (SCANENABLE),   // Scan Test Mode Enbl
     .SCANINHCLK  (SCANINdefslv), // Scan Chain Input
     .SCANOUTHCLK (SCANOUTdefslv) // Scan Chain Output    
    );

  // Central multiplexer - masters to slaves
  MuxM2S uMuxM2S 
    (
     .HMASTER  (HMASTER),
     .HMASTERD (HMASTERD),

     .HADDRM1  (HADDRM1),
     .HTRANSM1 (HTRANSM1),
     .HWRITEM1 (HWRITEM1),
     .HSIZEM1  (HSIZEM1),
     .HBURSTM1 (HBURSTM1),
     .HPROTM1  (HPROTM1),
     .HWDATAM1 (HWDATAM1),

     .HADDRM2  (HADDRM2),
     .HTRANSM2 (HTRANSM2),
     .HWRITEM2 (HWRITEM2),
     .HSIZEM2  (HSIZEM2),
     .HBURSTM2 (HBURSTM2),
     .HPROTM2  (HPROTM2),
     .HWDATAM2 (HWDATAM2),

     .HADDRM3  (HADDRM3),
     .HTRANSM3 (HTRANSM3),
     .HWRITEM3 (HWRITEM3),
     .HSIZEM3  (HSIZEM3),
     .HBURSTM3 (HBURSTM3),
     .HPROTM3  (HPROTM3),
     .HWDATAM3 (HWDATAM3),

     .HADDR    (HADDR),
     .HTRANS   (HTRANS),
     .HWRITE   (HWRITE),
     .HSIZE    (HSIZE),
     .HBURST   (HBURST),
     .HPROT    (HPROT),
     .HWDATA   (HWDATA)
    );

  // Unconnected MUX inputs
  assign HADDRM3  = {32{1'b0}};
  assign HTRANSM3 = 2'b00;
  assign HWRITEM3 = 1'b0;
  assign HSIZEM3  = 3'b000;
  assign HBURSTM3 = 3'b000;
  assign HPROTM3  = 4'b0000;
  assign HWDATAM3 = {32{1'b0}};

  // Central multiplexer - slaves to masters
  //  This 8-input multiplexor is used in place of the 16-input version 
  //  because it is faster to synthesise. However, in this application,
  //  the input channel names do not always match the names of the signals
  //  they are assigned to, though the multiplexor operation is unaffected.
  MuxS2M uMuxS2M 
    (
     .HCLK          (HCLK),
     .HRESETn       (HRESETn),

     .HSELS0        (HSELIntMem),  // Decoder slots 0 (re-map) and 7
     .HSELS1        (HSELS12),     // Decoder slot 12
     .HSELS2        (HSELS13),     // Decoder slot 13
     .HSELS3        (HSELS15),     // Decoder slot 15
     .HSELS4        (TieOffLo1),
     .HSELS5        (TieOffLo1),
     .HSELS6        (TieOffLo1),
     .HSELS7        (TieOffLo1),
     .HSELDefault   (HSELDefault),

     .HRDATAS0      (HRDATAS0),    // Internal Memory
     .HREADYS0      (HREADYS0),
     .HRESPS0       (HRESPS0),

     .HRDATAS1      (HRDATAS1),    // AHB to APB Bridge
     .HREADYS1      (HREADYS1),
     .HRESPS1       (HRESPS1),

     .HRDATAS2      (HRDATAS2),    // Retry Slave
     .HREADYS2      (HREADYS2),
     .HRESPS2       (HRESPS2),

     .HRDATAS3      (HRDATAS3),    // Interrupt Controller
     .HREADYS3      (HREADYS3),
     .HRESPS3       (HRESPS3),

     .HRDATAS4      (HRDATAS4),
     .HREADYS4      (HREADYS4),
     .HRESPS4       (HRESPS4),

     .HRDATAS5      (HRDATAS5),
     .HREADYS5      (HREADYS5),
     .HRESPS5       (HRESPS5),

     .HRDATAS6      (HRDATAS6),
     .HREADYS6      (HREADYS6),
     .HRESPS6       (HRESPS6),

     .HRDATAS7      (HRDATAS7),
     .HREADYS7      (HREADYS7),
     .HRESPS7       (HRESPS7),

     .HREADYDefault (HREADYDefault),
     .HRESPDefault  (HRESPDefault),

     .HRDATA        (HRDATA),
     .HREADY        (HREADY),
     .HRESP         (HRESP),

     // Scan test dummy signals; not connected until scan insertion 
     .SCANENABLE    (SCANENABLE), // Scan Test Mode Enbl
     .SCANINHCLK    (SCANINs2m),  // Scan Chain Input
     .SCANOUTHCLK   (SCANOUTs2m)  // Scan Chain Output    
    );

  // Tie off HRDATA for unused slave ports
  // assign HRDATAS0 = TieOffLo32;     // IntMem
  // assign HRDATAS1 = TieOffLo32;     // APB Peripherals
  // assign HRDATAS2 = TieOffLo32;     // Retry Slave
  // assign HRDATAS3 = TieOffLo32;     // Interrupt Controller
  assign HRDATAS4 = TieOffLo32;
  assign HRDATAS5 = TieOffLo32;
  assign HRDATAS6 = TieOffLo32;
  assign HRDATAS7 = TieOffLo32;

  // Tie off HREADY for unused slave ports
  // assign HREADYS0 = TieOffHi1;      // IntMem
  // assign HREADYS1 = TieOffHi1;      // APB Peripherals
  // assign HREADYS2 = TieOffHi1;      // Retry Slave
  // assign HREADYS3 = TieOffHi1;      // Interrupt Controller
  assign HREADYS4 = TieOffHi1;
  assign HREADYS5 = TieOffHi1;
  assign HREADYS6 = TieOffHi1;
  assign HREADYS7 = TieOffHi1;      

  // Tie off HRESP for unused slave ports
  // assign HRESPS0 = TieOffLo2;       // IntMem 
  // assign HRESPS1 = TieOffLo2;       // APB Peripherals
  // assign HRESPS2 = TieOffLo2;       // Retry Slave
  // assign HRESPS3 = TieOffLo2;       // Interrupt Controller
  assign HRESPS4 = TieOffLo2;
  assign HRESPS5 = TieOffLo2;
  assign HRESPS6 = TieOffLo2;
  assign HRESPS7 = TieOffLo2;       

  // Central multiplexer - peripherals to bridge
  MuxP2B uMuxP2B 
    (
     .PSELS0    (PSELS0),
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
    
     .PRDATAS0  (PRDATAS0),
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
    
     .PRDATA    (PRDATA)
    );

  // Tie off unused APB slave data paths
  assign PRDATAS0  = TieOffLo32;
  // assign PRDATAS1  = TieOffLo32;           // Watchdog
  // assign PRDATAS2  = TieOffLo32;           // Timers
  assign PRDATAS3  = TieOffLo32;
  // assign PRDATAS4  = TieOffLo32;           // GPIO
  assign PRDATAS5  = TieOffLo32;
  assign PRDATAS6  = TieOffLo32;
  assign PRDATAS7  = TieOffLo32;
  // assign PRDATAS8  = TieOffLo32;           // Remap/Pause
  assign PRDATAS9  = TieOffLo32;
  assign PRDATAS10 = TieOffLo32;
  assign PRDATAS11 = TieOffLo32;
  assign PRDATAS12 = TieOffLo32;
  assign PRDATAS13 = TieOffLo32;
  assign PRDATAS14 = TieOffLo32;
  // assign PRDATAS15 = TieOffLo32;           // EgAPBSlave

  // Watchdog timer module instantiated as APB slave 1
  Watchdog uWatchdog 
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

  // Timers module instantiated as APB slave 2
  Timers uTimers 
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

  // General Purpose Input/Output module as APB slave 4
  Gpio uGpio 
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

  // Drive unused output read-data bits LOW.
  assign PRDATAS4[31:8] = {24{1'b0}};

  // Remap and Pause controller instantiated as APB slave 8
  RemapPause uRemapPause 
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

  // Drive unused output read-data bits LOW.
  assign PRDATAS8[31:8] = {24{1'b0}};

  // Example APB Slave instantiated as APB slave 15
  EgAPBSlave uEgAPBSlave
    (
     .PCLK        (HCLK),
     .PRESETn     (HRESETn),

     .PENABLE     (PENABLE),
     .PSEL        (PSELS15),
     .PADDR       (PADDR[11:2]),
     .PWRITE      (PWRITE),
     .PWDATA      (PWDATA),
     .PRDATA      (PRDATAS15),

     // Scan test dummy signals; not connected until scan insertion 
     .SCANENABLE  (SCANENABLE),  // Scan Test Mode Enbl
     .SCANINPCLK  (SCANINegapb), // Scan Chain Input
     .SCANOUTPCLK (SCANOUTegapb) // Scan Chain Output    
    );


endmodule

// --================================= End ===================================--

