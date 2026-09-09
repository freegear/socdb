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
//  File Name          : Outport2.v,v
//  File Revision      : 1.8
//  
//  Release Information : ADK_REL1v1
//  
//  ----------------------------------------------------------------------------
//  Purpose             : Structural sub-block architecture of Example Amba
//                        SYstem Multi-layer (EASY-ML), connected to BusMatrix
//                        Outport 2.
//
//                        The module contains the following AHB device:
//
//                          - APBif
//
//                        The module contains the following APB devices:
//
//                          - Peripheral to bridge mux (MuxP2B)
//                          - Watchdog
//                          - Timers
//                          - GPIO PrimeCell (PL061)
//                          - Remap and Pause controller
//                          - Example APB Slave
//
//                        HREADYOUT is looped back to HREADY as the APBif
//                        is the only AHB slave in this module.
//  --========================================================================--

`timescale 1ns/1ps

module Outport2 (HCLK, HRESETn, HADDR, HBURST, HPROT, HREADYmtrx, HSELmtrx, 
                 HSIZE, HTRANS, HWDATA, HWRITE, HRDATA, HREADYOUT, HRESP, 
                 TIMINT1, TIMINT2, TIMINTC, WDOGRESn, WDOGRES, WDOGINT, nFIQ,
                 nIRQ, Pause, Remap, GPIN, nGPAFEN, GPAFOUT, GPOUT,  nGPEN, 
                 GPAFIN, GPIOINTR, GPIOMIS, SCANENABLE, SCANINHCLK, 
                 SCANOUTHCLK, SCANINPCLK, SCANOUTPCLK);

  // Common AHB signals
  input         HCLK;
  input         HRESETn;

  // Matrix AHB connections
  input  [31:0] HADDR;
  input  [2:0]  HBURST;
  input  [3:0]  HPROT;
  input         HREADYmtrx;
  input         HSELmtrx;
  input  [2:0]  HSIZE;
  input  [1:0]  HTRANS;
  input  [31:0] HWDATA;
  input         HWRITE;

  output [31:0] HRDATA;
  output        HREADYOUT;
  output [1:0]  HRESP;

  // Timer signals 
  output        TIMINT1;
  output        TIMINT2;
  output        TIMINTC;

  // Watchdog signals
  input         WDOGRESn;
  output        WDOGRES;
  output        WDOGINT;

  // Processor interrupts
  input         nFIQ;
  input         nIRQ;

  // Remap/Pause control signals
  output        Pause;
  output        Remap;

  // GPIO signals
  input  [7:0]  GPIN;
  input  [7:0]  nGPAFEN;
  input  [7:0]  GPAFOUT;
  output [7:0]  GPOUT;
  output [7:0]  nGPEN;
  output [7:0]  GPAFIN;
  output        GPIOINTR;
  output [7:0]  GPIOMIS;

  // Scan test dummy signals; not connected until scan insertion 
  input         SCANENABLE;  // Scan Test Mode Enbl
  input         SCANINHCLK;  // Scan Chain Input (HCLK)
  output        SCANOUTHCLK; // Scan Chain Output (HCLK)
  input         SCANINPCLK;  // Scan Chain Input (PCLK)
  output        SCANOUTPCLK; // Scan Chain Output (PCLK)


  // Port wires
  wire          HCLK;
  wire          HRESETn;

  wire  [31:0]  HADDR;
  wire  [2:0]   HBURST;
  wire  [3:0]   HPROT;
  wire          HREADYmtrx;
  wire          HSELmtrx;
  wire  [2:0]   HSIZE;
  wire  [1:0]   HTRANS;
  wire  [31:0]  HWDATA;
  wire          HWRITE;

  wire  [31:0]  HRDATA;
  wire          HREADYOUT;
  wire  [1:0]   HRESP;

  wire          TIMINT1;
  wire          TIMINT2;
  wire          TIMINTC;

  wire          WDOGRESn;
  wire          WDOGRES;
  wire          WDOGINT;

  wire          nFIQ;
  wire          nIRQ;

  wire          Pause;
  wire          Remap;

  wire  [7:0]   GPIN;
  wire  [7:0]   nGPAFEN;
  wire  [7:0]   GPAFOUT;
  wire  [7:0]   GPOUT;
  wire  [7:0]   nGPEN;
  wire  [7:0]   GPAFIN;
  wire          GPIOINTR;
  wire  [7:0]   GPIOMIS;

  wire          SCANENABLE;
  wire          SCANINHCLK;
  wire          SCANOUTHCLK;
  wire          SCANINPCLK;
  wire          SCANOUTPCLK;


//------------------------------------------------------------------------------
// Signal declarations: AHB
//------------------------------------------------------------------------------

// AHB signal
  wire          iHREADYOUT;

//------------------------------------------------------------------------------
// Signal declarations: APB
//------------------------------------------------------------------------------

// APB backbone
  wire          PENABLE;
  wire  [23:0]  PADDR;
  wire          PWRITE;
  wire  [31:0]  PWDATA;
  wire  [31:0]  PRDATA;

// Slave-specific APB signals
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

  wire  [31:0]  PRDATAS0;
  wire  [31:0]  PRDATAS1;
  wire  [31:0]  PRDATAS2;
  wire  [31:0]  PRDATAS3;
  wire  [31:0]  PRDATAS4;
  wire  [31:0]  PRDATAS5;
  wire  [31:0]  PRDATAS6;
  wire  [31:0]  PRDATAS7;
  wire  [31:0]  PRDATAS8;
  wire  [31:0]  PRDATAS9;
  wire  [31:0]  PRDATAS10;
  wire  [31:0]  PRDATAS11;
  wire  [31:0]  PRDATAS12;
  wire  [31:0]  PRDATAS13;
  wire  [31:0]  PRDATAS14;
  wire  [31:0]  PRDATAS15;

//------------------------------------------------------------------------------
// Signal declarations: Scan chain
//------------------------------------------------------------------------------

  wire          SCANINtimers;
  wire          SCANOUTtimers;
  wire          SCANINwdog;
  wire          SCANOUTwdog;
  wire          SCANINgpio;
  wire          SCANOUTgpio;
  wire          SCANINegapb;
  wire          SCANOUTegapb;
  wire          SCANINrpc;
  wire          SCANOUTrpc;
  wire          SCANINapbif;
  wire          SCANOUTapbif;

//------------------------------------------------------------------------------
// Signal declarations: Tie-offs
//------------------------------------------------------------------------------

  wire          TieOffHi1;
  wire  [31:0]  TieOffLo32;


//------------------------------------------------------------------------------
// Beginning of main code
//------------------------------------------------------------------------------

// The TieOff signals must be assigned explicitly within the body of the VHDL.
// Using initial values (in the signal declaration, above) will not work in
//  Synopsys. Signals are used rather than constants as constants can not be 
//  connected directly to sub-component instantiations
  assign TieOffHi1 = 1'b1;
  assign TieOffLo32 = {32{1'b0}};

// AHB to APB Bridge instantiated as AHB slave 12
  APBif uAPBif 
    (
     .HCLK        (HCLK),
     .HRESETn     (HRESETn),

     .HADDR       (HADDR[27:0]),
     .HTRANS      (HTRANS),
     .HWRITE      (HWRITE),
     .HWDATA      (HWDATA),
     .HSEL        (HSELmtrx),     // Active when module selected (slot 12)
     .HREADY      (iHREADYOUT),   // HREADYOUT is fed-back

     .HRDATA      (HRDATA),       // Channel 1 of MuxS2M
     .HREADYOUT   (iHREADYOUT),
     .HRESP       (HRESP),

     .PRDATA      (PRDATA),       // From MuxP2B output

     .PWDATA      (PWDATA),
     .PADDR       (PADDR),
     .PWRITE      (PWRITE),
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
     .SCANENABLE  (SCANENABLE),  // Scan Test Mode Enbl
     .SCANINHCLK  (SCANINapbif), // Scan Chain Input
     .SCANOUTHCLK (SCANOUTapbif) // Scan Chain Output  
    );

  // Connect internal signal to port
  assign HREADYOUT = iHREADYOUT;

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
  // assign PRDATAS1  = TieOffLo32;    // Watchdog
  // assign PRDATAS2  = TieOffLo32;    // Timers
  assign PRDATAS3  = TieOffLo32;
  // assign PRDATAS4  = TieOffLo32;    // GPIO
  assign PRDATAS5  = TieOffLo32;
  assign PRDATAS6  = TieOffLo32;
  assign PRDATAS7  = TieOffLo32;
  // assign PRDATAS8  = TieOffLo32;    // Remap/Pause
  assign PRDATAS9  = TieOffLo32;
  assign PRDATAS10 = TieOffLo32;
  assign PRDATAS11 = TieOffLo32;
  assign PRDATAS12 = TieOffLo32;
  assign PRDATAS13 = TieOffLo32;
  assign PRDATAS14 = TieOffLo32;
  // assign PRDATAS15  = TieOffLo32;   // Example APB Slave

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

// General Purpose Input/Output module instantiated as APB slave 4
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

  // Drive unused output read data bits LOW.
  assign PRDATAS8[31:8] = {24{1'b0}};

// Example APB Slave instantiated as APB slave 15
  EgAPBSlave uEgAPBSlave 
    (
     .PCLK        (HCLK),
     .PRESETn     (HRESETn),

     .PENABLE     (PENABLE),
     .PSEL        (PSELS15),
     .PWRITE      (PWRITE),
     .PADDR       (PADDR[11:2]),
     .PRDATA      (PRDATAS15),
     .PWDATA      (PWDATA),

     // Scan test dummy signals; not connected until scan insertion 
     .SCANENABLE  (SCANENABLE),  // Scan Test Mode Enbl
     .SCANINPCLK  (SCANINegapb), // Scan Chain Input
     .SCANOUTPCLK (SCANOUTegapb) // Scan Chain Output
    );


endmodule

// --================================= End ===================================--

