//  ----------------------------------------------------------------------------
//  This confidential & proprietary software may be used only
//  as authorised by a licensing agreement from ARM Limited
//  (C) COPYRIGHT 1998 ARM Limited
//  ALL RIGHTS RESERVED
//  The entire notice above must be reproduced on all authorised copies
//  & copies may only be made to the extent permitted by a
//  licensing agreement from ARM Limited.
//  ----------------------------------------------------------------------------
//
//  Version & Release Control Information :
//
//
//  Filename            : KmiTrPulseGen.v,v
//
//  File Revision       : 1.1
//
//  Release Information : PL050-REL1v1
//
//  ----------------------------------------------------------------------------
//  Purpose : this module generates the REFCLK & Pulse8MHz signal.
//
//  ---------------------------------------------------------------------------

`timescale 1ns/1ps

// ---------------------------------------------------------------------------

module KmiTrPulseGen (
                      BnRES,
                      PCLK,
                      KmiTrREFCLK,
                      KmiTrCLKDIV,
                      KmiTrMODEREG,
                      WrenMREG,
                      Pulse8MHz,
                      REFCLK,
                      nKMIRST,
                      PCLKOn,
                      REFCLKOn  
                     );

input       BnRES;        // APB Reset 
input       PCLK;         // APB Clock
input [7:0] KmiTrREFCLK;  // Reference Clock Value
input [7:0] KmiTrCLKDIV;  // Clock Divisor Value
input [3:0] KmiTrMODEREG; // Clock/Reset mode 
input       WrenMREG;     // Indicates the write status to MODEREG.
output      Pulse8MHz;    // 8MHz Pulse Output
output      REFCLK;       // Reference Clock Output
output      nKMIRST;      // KMI Reset Output 
output      PCLKOn;       // PCLK Enable Status
output      REFCLKOn;     // REFCLK Enable Status 

// ---------------------------------------------------------------------------
//
//                           KmiTrPulseGen
//                           =============
//
// ----------------------------------------------------------------------------
//
// Overview
// ========
// The block generates the REFCLK & Pulse8MHz based on the programmed value
// in the registers.
// ----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// wire declarations
// -----------------------------------------------------------------------------
wire iREFCLK;
// Internal Copy of REFCLK.

wire REFCLK;       
// Reference Clock Output

wire [7:0] NextCountReg;
// D-Input to Counter

wire NextPulse8MHz ;   
// D-Input of Pulse8MHz Signal

wire MuxInREFCLK;
// Gated REFCLK signal

wire MuxInPCLK;
// Gated PCLK signal

// -----------------------------------------------------------------------------
// Register declarations
// -----------------------------------------------------------------------------
reg FreeREFCLK;
// Free running REFCLK.

reg Pulse8MHz;    
// 8MHz Pulse Output

reg nKMIRST;      
// KMI Reset Output 

reg PCLKOn;       
// PCLK Enable Status

reg REFCLKOn;     
// REFCLK Enable Status 

reg [7:0] CountReg;
// Counter Value 

time ClockLow;
// Clock Low Time

time ClockHigh;
// Clock High Time 

reg PCLKEn;
// Clocked PCLK Enable Bit in MODE Register

reg REFCLKEn;
// Clocked REFCLK Enable Bit in MODE Register

// -----------------------------------------------------------------------------
//
// Main body of code
// =================
//
// -----------------------------------------------------------------------------

initial  //Default Value
begin
  ClockLow  = 10;
  ClockHigh = 10;
end
  
// ----------------------------------------------------------------------------
// Generation of KMI Reset.
// ----------------------------------------------------------------------------
always @ (posedge iREFCLK or BnRES)
begin : p_nKMIRSTSeq
  if (BnRES == 1'b0) 
    nKMIRST <= 1'b0;
  else
    nKMIRST <= KmiTrMODEREG[0];
end  // p_nKMIRSTSeq

// ----------------------------------------------------------------------------
// Register values are being converted into time.
// ----------------------------------------------------------------------------
always @ (KmiTrREFCLK)
begin : p_Time
  if (KmiTrREFCLK > 8'b00000000) 
    if (KmiTrREFCLK[0] == 1'b1) 
      ClockLow = {1'b0, KmiTrREFCLK[7:1]} + 1'b1;
    else
      ClockLow = {1'b0, KmiTrREFCLK[7:1]};
  ClockHigh = {1'b0, KmiTrREFCLK[7:1]};
end  // p_Time

// ----------------------------------------------------------------------------
// Free running REFCLK generation
// ----------------------------------------------------------------------------
always 
begin : p_FreeREFCLK
  FreeREFCLK = 1'b0;
  #ClockLow;
  FreeREFCLK = 1'b1; 
  #ClockHigh;
end  // p_FreeREFCLK

// -----------------------------------------------------------------------------
// This process generates synchronized PCLKEn bit from KmiTrMODEREG(2) with 
// falling edge of PCLK
// -----------------------------------------------------------------------------
always @ (negedge PCLK or BnRES)
begin : p_PCLKEnSeq
  if (BnRES == 1'b0) 
    PCLKEn <= 1'b0;
  else
    PCLKEn <= KmiTrMODEREG[2];
end  // p_PCLKEnSeq
 
// -----------------------------------------------------------------------------
// This process generates synchronized REFCLKEn bit from KmiTrMODEREG(3) with 
// falling edge of REFCLK
// -----------------------------------------------------------------------------
always @ (negedge FreeREFCLK or BnRES)
begin : p_REFCLKEnSeq 
  if (BnRES == 1'b0) 
    REFCLKEn <= 1'b0;
  else 
    REFCLKEn <= KmiTrMODEREG[3];
end  // p_REFCLKEnSeq

// The MuxInREFCLK signal is freeREFCLK gated with REFCLKEn signal
assign MuxInREFCLK   = FreeREFCLK & REFCLKEn;

// The MuxInPCLK signal is PCLK gated with PCLKEn signal
assign MuxInPCLK     = PCLK & PCLKEn;

// REFCLK is being routed according to programmed value.
assign iREFCLK       = KmiTrMODEREG[1] ? MuxInPCLK :
                       MuxInREFCLK;

assign REFCLK        = iREFCLK;

// -----------------------------------------------------------------------------
// This process generates the out version of PCLKEn & REFCLKEn with falling
// edge of RCLK
// -----------------------------------------------------------------------------
always @ (posedge PCLK or BnRES)
begin : p_StatGenSeq 
  if(BnRES == 1'b0) 
  begin
    PCLKOn   <= 1'b0;
    REFCLKOn <= 1'b0;
  end
  else
  begin
    PCLKOn   <= PCLKEn;
    REFCLKOn <= REFCLKEn;
  end
end  // p_StatGenSeq

// ----------------------------------------------------------------------------
// Generation of Pulse8MHz Signal
// ----------------------------------------------------------------------------
assign NextPulse8MHz = (CountReg == 9'b00000000) ? 1'b1 : 
                       1'b0;

assign NextCountReg  = (CountReg == 9'b00000000) ? KmiTrCLKDIV :
                       CountReg - 1'b1; 

// ----------------------------------------------------------------------------
// This process updates the CountReg at the positive edge of REFCLK.
// ----------------------------------------------------------------------------
always @ (posedge iREFCLK or BnRES)
begin : p_CountRegSeq
  if (BnRES == 1'b0) 
    CountReg  <= 9'b00000000;
  else
    CountReg  <= NextCountReg;
end  // p_CountRegSeq

// ----------------------------------------------------------------------------
// Pulse8MHz signal is being generated.
// ----------------------------------------------------------------------------
always @ (posedge iREFCLK or BnRES)
begin : p_Pulse8MHzSeq
  if (BnRES == 1'b0) 
    Pulse8MHz <= 1'b0;
  else 
    Pulse8MHz <= NextPulse8MHz;
end  // p_Pulse8MHzSeq

endmodule

//========================== End of KmiTrPulseGen  ============================
