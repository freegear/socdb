// --=========================================================================--
//  This confidential and proprietary software may be used only as
//  authorised by a licensing agreement from ARM Limited
//    (C) COPYRIGHT 2002 ARM Limited
//        ALL RIGHTS RESERVED
//  The entire notice above must be reproduced on all authorised
//  copies and copies may only be made to the extent permitted
//  by a licensing agreement from ARM Limited.
//  ----------------------------------------------------------------------------
//
//  Version and Release Control Information:
//
//  File Name              : ClcdTest.v.rca
//  File Revision          : 1.3
//
//  Release Information    : PrimeCell(TM)-PL110-r1p2-00ltd0
//
//  ----------------------------------------------------------------------------
//  ----------------------------------------------------------------------------
//  Purpose                :  Test integration testing
// --=========================================================================--

`timescale 1ns/1ps

// ----------------------------------------------------------------------------


module ClcdTest (    
//Inputs
                 HCLK,
                 HRESETn,
                 HWDATAS,
                 CLCDCLKSELint,
                 CLCDMBEINTRint,
                 CLCDFUFINTRint,
                 CLCDLNBUINTRint,
                 CLCDVCOMPINTRint,
                 CLCDINTRint,
                 CLPOWERint,
                 CLLPint,
                 CLCPint,
                 CLFPint,
                 CLACint,
                 CLLEint,
                 CLDint,
                 LCDTCRWen,
                 LCDITOP1Wen,
                 LCDITOP2Wen,
//Outputs
                 ITEN,
                 CLCDCLKSEL,
                 CLCDMBEINTR,
                 CLCDFUFINTR,
                 CLCDLNBUINTR,
                 CLCDVCOMPINTR,
                 CLCDINTR,
                 CLPOWER,
                 CLLP,
                 CLCP,
                 CLFP,
                 CLAC,
                 CLLE,
                 CLD 
                );

//Inputs
// Inputs: AHB interface
input         HCLK;             
// Inputs: AHB interface
input         HRESETn;          
// AMBA bus reset
input [29:0]  HWDATAS;          
// Slave HWDATA

// Inputs: Intra-Chip Outputs muxed with CLCDITOP1[5:0]   
input         CLCDCLKSELint;    
// Internal CLCDCLKSEL     muxed with CLCDITOP1 [5]
input         CLCDMBEINTRint;   
// Internal CLCDMBEINTR    muxed with CLCDITOP1 [4]
input         CLCDFUFINTRint;   
// Internal CLCDFUFINTR    muxed with CLCDITOP1 [3]
input         CLCDLNBUINTRint;  
// Internal CLCDLNBUINTR   muxed with CLCDITOP1 [2]
input         CLCDVCOMPINTRint; 
// Internal CLCDVCOMPINTR  muxed with CLCDITOP1 [1]
input         CLCDINTRint;      
// Internal CLCDINTR       muxed with CLCDITOP1 [0]

// Inputs: Primary outputs muxed with CLCDITOP2 [29:0]
input         CLPOWERint;       
// Internal CLPOWER        muxed with CLCDITOP2 [29]
input         CLLPint;          
// Internal CLLP           muxed with CLCDITOP2 [28]
input         CLCPint;          
// Internal CLCP           muxed with CLCDITOP2 [27]
input         CLFPint;          
// Internal CLFP           muxed with CLCDITOP2 [26]
input         CLACint;          
// Internal CLAC           muxed with CLCDITOP2 [25]
input         CLLEint;          
// Internal CLLE           muxed with CLCDITOP2 [24]
input [23:0]  CLDint;           
// Internal CLD            muxed with CLCDITOP2 [23:0]

// Inputs: Test register Write Enables 
input         LCDTCRWen;        
// LCDTCRWen Write Enable
input         LCDITOP1Wen;      
// LCDITOP1Wen Write Enable 
input         LCDITOP2Wen;      
// CLCDTOP2Write Enable 
     
//Outputs
output        ITEN;             
// Test Control Register ITEN bit

// Outputs: Multiplexed output of Intra-Chip Outputs and CLCDITOP1[5:0]
output        CLCDCLKSEL;       
// Output CLCDCLKSEL       muxed with CLCDITOP1 [5]
output        CLCDMBEINTR;      
// output CLCDMBEINTR      muxed with CLCDITOP1 [4]
output        CLCDFUFINTR;      
// output CLCDFUFINTR      muxed with CLCDITOP1 [3]
output        CLCDLNBUINTR;     
// output CLCDLNBUINTR     muxed with CLCDITOP1 [2]
output        CLCDVCOMPINTR;     
// output CLCDVCOMPINTR    muxed with CLCDITOP1 [1]
output        CLCDINTR;         
// Output CLCDINTR         muxed with CLCDITOP1 [0]

// Outputs: Multiplexed Primary outputs with CLCDITOP2[29:0]
output        CLPOWER;          
// Output CLPOWER          muxed with CLCDITOP2 [29]
output        CLLP;              
// Output CLLP             muxed with CLCDITOP2 [28]
output        CLCP;             
// Output CLCP             muxed with CLCDITOP2 [27]
output        CLFP;             
// Output CLFP             muxed with CLCDITOP2 [26]
output        CLAC;             
// Output CLAC             muxed with CLCDITOP2 [25]
output        CLLE;             
// Output CLLE             muxed with CLCDITOP2 [24]
output [23:0]  CLD;             
// output CLD              muxed with CLCDITOP2 [23:0]

// -----------------------------------------------------------------------------
//                               ClcdTest
//                               =======
// -----------------------------------------------------------------------------
// Overview
// ========
// This module contains the Test mode registers. It performs the following
// functions :
// -----------------------------------------------------------------------------
// Test control signals
// -----------------------------------------------------------------------------
// ITEN;
// Integration test enable. When set to 1, the CLCDITOP1 and CLCDITOP2
// registers are used to read/write values to the intra-chip and
// primary outputs.

wire HCLK;                 // AHB Bus Clk
wire HRESETn;              // AHB Bus Reset
wire [29:0] HWDATAS;       // AHB Write Data Slave
wire CLCDCLKSELint;        // Intermediate CLCDCLKSEL
wire CLCDMBEINTRint;       // Intermediate CLCDMBEINTR
wire CLCDFUFINTRint;       // Intermediate CLCDFUFINTR
wire CLCDLNBUINTRint;      // Intermediate CLCDLNBUINTR
wire CLCDVCOMPINTRint;     // Intermediate CLCDVCOMPINTR
wire CLCDINTRint;          // Intermediate CLCDINTR
wire CLPOWERint;           // Intermediate CLPOWER
wire CLLPint;              // Intermediate CLLP
wire CLCPint;              // Intermediate CLCP
wire CLFPint;              // Intermediate CLFP
wire CLACint;              // Intermediate CLAC
wire CLLEint;              // Intermediate CLLE
wire [23:0] CLDint;        // Intermediate CLD
wire LCDTCRWen;            // LCD Test Control Register Write Enable
wire LCDITOP1Wen;          // LCD Integration Output Register 1 Write Enable
wire LCDITOP2Wen;          // LCD Integration Output Register 2 Write Enable
wire ITEN;                 // Integration Test Enable
wire CLCDCLKSEL;           // CLCDCLKSEL    mux output
wire CLCDMBEINTR;          // CLCDMBEINTR   mux output
wire CLCDFUFINTR;          // CLCDFUFINTR   mux output
wire CLCDLNBUINTR;         // CLCDLNBUINTR  mux output
wire CLCDVCOMPINTR;        // CLCDVCOMPINTR mux output
wire CLCDINTR;             // CLCDINTR      mux output
wire CLPOWER;              // CLPOWER       mux output
wire CLLP;                 // CLLP          mux output
wire CLCP;                 // CLCP          mux output
wire CLFP;                 // CLFP          mux output
wire CLAC;                 // CLAC          mux output
wire CLLE;                 // CLLE          mux output
wire [23:0] CLD;           // CLD           mux output
wire iITEN;                // Local copy of ITEN

reg CLCDTCR;               // CLCD Test Control Register
reg [5:0] CLCDITOP1;       // CLCD Integration Test Output Register 1
reg [29:0] CLCDITOP2;      // CLCD Integration Test Output Register 2
reg NextCLCDTCR;           // D-input of iCLCDTCR
reg [5:0] NextCLCDITOP1;   // D-input of CLCDITOP1
reg [29:0] NextCLCDITOP2;  // D-input of CLCDITOP2

// Internal copy of Integration test enable
assign iITEN = CLCDTCR;
assign ITEN  = iITEN;

// -----------------------------------------------------------------------------
// Write interface for Test mode Registers
// -----------------------------------------------------------------------------
always@(LCDTCRWen or LCDITOP1Wen or LCDITOP2Wen or 
          CLCDTCR or CLCDITOP1 or CLCDITOP2 or HWDATAS)
begin : p_Comb

  if (LCDTCRWen)
    NextCLCDTCR    = HWDATAS[0];
  else
    NextCLCDTCR    = CLCDTCR;
 
  if (LCDITOP1Wen)
    NextCLCDITOP1  = HWDATAS [5:0];
  else
    NextCLCDITOP1  = CLCDITOP1;

  if  (LCDITOP2Wen)
    NextCLCDITOP2  = HWDATAS [29:0];
  else
     NextCLCDITOP2 = CLCDITOP2;
 end // p_Comb

// -----------------------------------------------------------------------------
// Test mode Registers
// -----------------------------------------------------------------------------
always@(posedge HCLK or negedge HRESETn)
begin : p_Seq
  if  (HRESETn == 1'b0)
    begin 
      CLCDTCR    <= 1'b0 ;
      CLCDITOP1  <= {6{1'b0}};
      CLCDITOP2  <= {30{1'b0}};
    end
  else
    begin
      CLCDTCR    <= NextCLCDTCR ;
      CLCDITOP1  <= NextCLCDITOP1;
      CLCDITOP2  <= NextCLCDITOP2;
    end 
end // p_Seq

// --------------------------------------------------------------------
// Intra-chip output mux
// If CLCDTCR[0] ITEN (Integration test enable bit) is high, the
// CLCDITOP1 register value is used; else the functional mode value
// is driven on to the port.
// --------------------------------------------------------------------
assign CLCDCLKSEL    = iITEN ? CLCDITOP1[5] : CLCDCLKSELint;
assign CLCDMBEINTR   = iITEN ? CLCDITOP1[4] : CLCDMBEINTRint;
assign CLCDFUFINTR   = iITEN ? CLCDITOP1[3] : CLCDFUFINTRint;
assign CLCDLNBUINTR  = iITEN ? CLCDITOP1[2] : CLCDLNBUINTRint;
assign CLCDVCOMPINTR = iITEN ? CLCDITOP1[1] : CLCDVCOMPINTRint;
assign CLCDINTR      = iITEN ? CLCDITOP1[0] : CLCDINTRint;

// --------------------------------------------------------------------
// Primary Output Mux
// If CLCDTCR[0] ITEN (Integration test enable bit) is high, the
// CLCDITOP2 register value is used; else the functional mode value is
// driven on to the pin.
// --------------------------------------------------------------------
assign CLPOWER       = iITEN ? CLCDITOP2[29]   : CLPOWERint;
assign CLLP          = iITEN ? CLCDITOP2[28]   : CLLPint;
assign CLCP          = iITEN ? CLCDITOP2[27]   : CLCPint;
assign CLFP          = iITEN ? CLCDITOP2[26]   : CLFPint;
assign CLAC          = iITEN ? CLCDITOP2[25]   : CLACint;
assign CLLE          = iITEN ? CLCDITOP2[24]   : CLLEint;
assign CLD           = iITEN ? CLCDITOP2[23:0] : CLDint;

endmodule
// --================================== End ==================================--
