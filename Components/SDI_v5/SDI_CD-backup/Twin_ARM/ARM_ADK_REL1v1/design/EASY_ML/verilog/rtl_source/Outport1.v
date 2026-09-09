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

module Outport1 (
	HCLK, 
	HRESETn, 
	HADDR, 
	HBURST, 
	HPROT, 
	HREADYmtrx, 
	HSELmtrx,
        HSIZE, 
	HTRANS, 
	HWDATA, 
	HWRITE, 
	HRDATA, 
	HREADYOUT, 
	HRESP,
        WDOGINT, 
	TIMINTC, 
	TIMINT2, 
	TIMINT1, 
	GPIOMIS, 
	GPIOINTR,
        nICFIQ, 
	nICIRQ, 
      // Interrupt
        UARTINTR,      //     Combined interrupt
        DMACINTR,       //     Combined interrupt
 	MMCIINTR0,
     	MMCIINTR1,
     	SCIINTR,  
     	RTCINTR,  
     	AACIINTR, 

	SCANENABLE, 
	SCANINHCLK, 
	SCANOUTHCLK
	);

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
  input         UARTINTR;      //     Combined interrupt
  input         DMACINTR;       //      Combined interrupt
  input		MMCIINTR0;
  input    	MMCIINTR1;
  input    	SCIINTR;  
  input    	RTCINTR;  
  input    	AACIINTR; 

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
  Vic uVic(
     .HCLK          (HCLK),          
     .HRESETn       (HRESETn),       
                                    
     .HSELVIC       (HSELmtrx),      
     .HWRITE        (HWRITE),        
     .HREADYIN      (iHREADYOUT),    
     .HPROT         (HPROT[1]),      
     .HTRANS        (HTRANS[1]),     
     .HSIZE         (HSIZE),         
     .VICINTSOURCE  (IntSource),     
     .nVICFIQIN     (TieOffHi1),     
     .nVICIRQIN     (TieOffHi1),     
     .VICVECTADDRIN (TieOffLo32),    
     .HWDATA        (HWDATA),        
     .HADDR         (HADDR[11:2]),   
     .HREADYOUT     (iHREADYOUT),    
     .HRESP         (HRESP),         
     .HRDATA        (HRDATA),        
     .nVICFIQ       (nICFIQ),        
     .nVICIRQ       (nICIRQ),        
     .VICVECTADDROUT(ICVECTADDROUT), 
                       
     .SCANENABLE    (SCANENABLE),    
     .SCANINHCLK    (SCANINic),      
     .SCANOUTHCLK   (SCANOUTic)      
);

  // Concatenate individual interrupt lines to form one bus  
  assign IntSource = {
    GPIOMIS,        
    4'b0000,        
    4'b0000,        
    4'b0000,        
    4'b0000, 
    3'b000,       
    GPIOINTR,       
    WDOGINT,        
    TIMINTC,        
    TIMINT2,        
    TIMINT1,        
    1'b0,           
    1'b0,           
    1'b0,           
    1'b0};          

  // Connect internal signal to port
  assign HREADYOUT = iHREADYOUT;


endmodule

// --================================= End ===================================--

