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
//  File Name           : Outport1.v,v
//  File Revision       : 1.5
//  
//  Release Information : ADK_REL1v1
//  
//  ----------------------------------------------------------------------------
//  Purpose             : Structural sub-block architecture of Example Amba 
//                        SYstem Multi-layer (EASY-ML), connected to BusMatrix
//                        Outport 1. The module contains the following AHB 
//                        device:
//                      
//                          - Interrupt controller
//                        
//                        HREADYOUT is looped back to HREADY as the interrupt
//                        controller is the only slave in this module.
//  --========================================================================--

`timescale 1ns/1ps

module Outport1 (HCLK, HRESETn, HADDR, HBURST, HPROT, HREADYmtrx, HSELmtrx,
                 HSIZE, HTRANS, HWDATA, HWRITE, HRDATA, HREADYOUT, HRESP,
                 WDOGINT, TIMINTC, TIMINT2, TIMINT1, GPIOMIS, GPIOINTR,
                 nICFIQ, nICIRQ, SCANENABLE, SCANINHCLK, SCANOUTHCLK);

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

  // Peripheral interrupt sources
  input         WDOGINT;
  input         TIMINTC;
  input         TIMINT2;
  input         TIMINT1;
  input  [7:0]  GPIOMIS;
  input         GPIOINTR;

  // Processor interrupts
  output        nICFIQ;
  output        nICIRQ;

  // Scan test dummy signals; not connected until scan insertion
  input         SCANENABLE;  // Scan Test Mode Enbl
  input         SCANINHCLK;  // Scan Chain Input
  output        SCANOUTHCLK; // Scan Chain Output

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

  wire          WDOGINT;
  wire          TIMINTC;
  wire          TIMINT2;
  wire          TIMINT1;
  wire  [7:0]   GPIOMIS;
  wire          GPIOINTR;

  wire          nICFIQ;
  wire          nICIRQ;

  wire          SCANENABLE;
  wire          SCANINHCLK;
  wire          SCANOUTHCLK;

//------------------------------------------------------------------------------
// Signal declarations: Module specific and AHB
//------------------------------------------------------------------------------

  wire [31:0]   IntSource;
  wire [31:0]   ICVECTADDROUT;
  wire          iHREADYOUT;


//------------------------------------------------------------------------------
// Signal declarations: Scan chain
//------------------------------------------------------------------------------

  wire          SCANINic;
  wire          SCANOUTic;


//------------------------------------------------------------------------------
// Signal declarations: Tie-offs
//------------------------------------------------------------------------------

  wire          TieOffHi1;
  wire [31:0]   TieOffLo32;


//------------------------------------------------------------------------------
// Beginning of main code
//------------------------------------------------------------------------------

// The TieOff signals must be assigned explicitly within the body of the HDL.
// Using initial values (in the signal declaration, above) will not work in
//  Synopsys. Signals are used rather than constants as constants can not be 
//  connected directly to sub-component instantiations
  assign TieOffHi1 = 1'b1;
  assign TieOffLo32 = {32{1'b0}};


// Interrupt Controller instantiated as AHB slave 15
  Interrupt uInterrupt 
    (
     .HCLK          (HCLK),
     .HRESETn       (HRESETn),

     .HSELIC        (HSELmtrx),     // Active when module selected (slot 15)
     .HWRITE        (HWRITE),
     .HREADY        (iHREADYOUT),   // HREADYOUT is fed-back
     .HPROT         (HPROT[1]),     // Privileged access
     .HTRANS        (HTRANS[1]),
     .HSIZE         (HSIZE),
     .ICINTSOURCE   (IntSource),    // System interrupts
     .nICFIQIN      (TieOffHi1),    // Connect daisy-chained 
     .nICIRQIN      (TieOffHi1),    //  interrupt controllers here
     .ICVECTADDRIN  (TieOffLo32),
     .HWDATA        (HWDATA),
     .HADDR         (HADDR[11:2]),
     .HREADYOUT     (iHREADYOUT),
     .HRESP         (HRESP),
     .HRDATA        (HRDATA),
     .nICFIQ        (nICFIQ),
     .nICIRQ        (nICIRQ),
     .ICVECTADDROUT (ICVECTADDROUT),    // Not used

     // Scan test dummy signals; not connected until scan insertion 
     .SCANENABLE    (SCANENABLE), // Scan Test Mode Enbl 
     .SCANINHCLK    (SCANINic),   // Scan Chain Input
     .SCANOUTHCLK   (SCANOUTic)   // Scan Chain Output
    );


  // Concatenate individual interrupt lines to form one bus  
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


  // Connect internal signal to port
  assign HREADYOUT = iHREADYOUT;


endmodule

// --================================= End ===================================--

