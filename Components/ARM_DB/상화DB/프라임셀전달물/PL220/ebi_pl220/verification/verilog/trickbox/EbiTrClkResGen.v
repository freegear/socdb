// --=========================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from ARM Limited
//   (C) COPYRIGHT 2001-2002 ARM Limited
//       ALL RIGHTS RESERVED
// The entire notice above must be reproduced on all authorised
// copies and copies may only be made to the extent permitted
// by a licensing agreement from ARM Limited.
//
// -----------------------------------------------------------------------------
// Version and Release Control Information:
//
// File Name              : EbiTrClkResGen.v.rca
// File Revision          : 1.2
//
// Release Information    : PrimeCell(TM)-PL220-r0p0-00ltd0
//
// -----------------------------------------------------------------------------
// Purpose :
//           This block generates the EBICLK, MEMCLK1, MEMCLK2, MEMCLK3 and
//           nPOR.
//
// --=========================================================================--

`timescale 1ns/1ps

// -----------------------------------------------------------------------------

module EbiTrClkResGen (
// Inputs
                       HCLK,
                       EbiTrClk,
                       HRESETn,
// Outputs
                       nPOR,
                       MEMCLK1,
                       MEMCLK2,
                       MEMCLK3,
                       EBICLK
                      );

parameter Tclkl = 10; // HCLK low time
parameter Tclkh = 10; // HCLK high time
parameter Tclks = 10; // EBICLK start delay

// Inputs
input       HCLK;      // AHB Bus clock
input [2:0] EbiTrClk;  // Indicates MEMCLK speed
input       HRESETn;   // Bus reset

// Outputs
output      nPOR;      // Power On Reset
output      MEMCLK1;   // Memory clock from Port1
output      MEMCLK2;   // Memory clock from Port2
output      MEMCLK3;   // Memory clock from Port3
output      EBICLK;    // EBICLK output to EBI

// Inputs
wire       HCLK;      // AHB Bus clock
wire [2:0] EbiTrClk;  // Indicates MEMCLK speed
wire       HRESETn;   // Bus reset

// Outputs
wire       nPOR;      // Power On Reset
reg        MEMCLK1;   // Memory clock from Port1
reg        MEMCLK2;   // Memory clock from Port2
reg        MEMCLK3;   // Memory clock from Port3
reg        EBICLK;    // EBICLK output to EBI

// -----------------------------------------------------------------------------
//
//                               EbiTrClkResGen
//                               ===============
//
// -----------------------------------------------------------------------------
//
// Overview
// ========
//   This block generates the EBICLK signal.
//
// -----------------------------------------------------------------------------

// ---------------------------------------------------------------------
// Constant declarations
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Wire declarations
// ---------------------------------------------------------------------
wire     StartMEMCLK1;
// Indicates the start of MEMCLK1

wire     StartMEMCLK2;
// Indicates the start of MEMCLK2

wire     StartMEMCLK3;
// Indicates the start of MEMCLK3

wire     StartEBICLK;
// Indicates the start of EBICLK

// -----------------------------------------------------------------------------
// Register declarations
// -----------------------------------------------------------------------------
reg       inPOR;
// Internal version of nPOR

reg [7:0] Tmclkh;
// EBICLK high time

reg [7:0] Tmclkl;
// EBICLK low time

reg [7:0] Tmclkh1;
// MEMCLK1 high time

reg [7:0] Tmclkl1;
// MEMCLK1 low time

reg [7:0] Tmclkh2;
// MEMCLK2 high time

reg [7:0] Tmclkl2;
// MEMCLK2 low time

reg [7:0] Tmclkh3;
// MEMCLK3 high time

reg [7:0] Tmclkl3;
// MEMCLK3 low time

// -----------------------------------------------------------------------------
// Function declarations
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
//
// Main body of code
// =================
//
// -----------------------------------------------------------------------------

initial
begin
  Tmclkh        <= (Tclkl + Tclkh)/2;
  Tmclkl        <= (Tclkl + Tclkh)/2;
  Tmclkh1       <= (Tclkl + Tclkh)/2;
  Tmclkl1       <= (Tclkl + Tclkh)/2;
  Tmclkh2       <= (Tclkl + Tclkh)/2;
  Tmclkl2       <= (Tclkl + Tclkh)/2;
  Tmclkh3       <= (Tclkl + Tclkh)/2;
  Tmclkl3       <= (Tclkl + Tclkh)/2;
  MEMCLK1       <= 1'b0;
  MEMCLK2       <= 1'b0;
  MEMCLK3       <= 1'b0;
  EBICLK        <= 1'b0;
end

// -----------------------------------------------------------------------------
//  MEMCLK1 Generation
// -----------------------------------------------------------------------------
assign #Tclks StartMEMCLK1     = 1'b1;

always @(MEMCLK1 or StartMEMCLK1)
begin : p_Clk1Seq
  // If StartMEMCLK1 is set allow the clock to toggle
  if (StartMEMCLK1 == 1'b1)
    begin
      if (MEMCLK1 == 1'b0)
        MEMCLK1         <= #Tmclkl1 1'b1;
      else
        MEMCLK1         <= #Tmclkh1 1'b0;
    end
  else
    begin
      // If StartMEMCLK1 is cleared, the clock line will be low
      MEMCLK1         <= 1'b0;
    end
end // p_Clk1Seq

// -----------------------------------------------------------------------------
//  MEMCLK2 Generation
// -----------------------------------------------------------------------------
assign #Tclks StartMEMCLK2     = 1'b1;

always @(MEMCLK2 or StartMEMCLK2)
begin : p_Clk2Seq
  // If StartMEMCLK2 is set allow the clock to toggle
  if (StartMEMCLK2 == 1'b1)
    begin
      if (MEMCLK2 == 1'b0)
        MEMCLK2         <= #Tmclkl2 1'b1;
      else
        MEMCLK2         <= #Tmclkh2 1'b0;
    end
  else
    begin
      // If StartMEMCLK2 is cleared, the clock line will be low
      MEMCLK2         <= 1'b0;
    end
end // p_Clk2Seq

// -----------------------------------------------------------------------------
//  MEMCLK3 Generation
// -----------------------------------------------------------------------------
assign #Tclks StartMEMCLK3     =  1'b1;

always @(MEMCLK3 or StartMEMCLK3)
begin : p_Clk3Seq
  // If StartMEMCLK3 is set allow the clock to toggle
  if (StartMEMCLK3 == 1'b1)
    begin
      if (MEMCLK3 == 1'b0)
        MEMCLK3         <= #Tmclkl3 1'b1;
      else
        MEMCLK3         <= #Tmclkh3 1'b0;
    end
  else
    begin
      // If StartMEMCLK3 is cleared, the clock line will be low
      MEMCLK3         <= 1'b0;
    end
end // p_Clk3Seq

// -----------------------------------------------------------------------------
//  EBICLK Generation
// -----------------------------------------------------------------------------
assign #Tclks StartEBICLK      =  1'b1;

always @(EBICLK or StartEBICLK)
begin : p_EbiClkSeq
  // If StartEBICLK is set allow the clock to toggle
  if (StartEBICLK == 1'b1)
    begin
      if (EBICLK == 1'b0)
        EBICLK          <= #Tmclkl 1'b1;
      else
        EBICLK          <= #Tmclkh 1'b0;
     end
  // If StartEBICLK is cleared, the clock line will be low
  else
    begin
      EBICLK          <= 1'b0;
    end
end // p_EbiClkSeq

// -----------------------------------------------------------------------------
// Determine the EBICLK frequency
// -----------------------------------------------------------------------------
always @(negedge EBICLK or EbiTrClk)
begin : p_ClkRatSeq
  if (EBICLK == 1'b0)
    begin
      if (EbiTrClk != 3'b000)
        begin
          Tmclkh           <= (Tclkl + Tclkh)/4;
          Tmclkl           <= (Tclkl + Tclkh)/4;
        end
      else
        begin
          Tmclkh           <= (Tclkl + Tclkh)/2;
          Tmclkl           <= (Tclkl + Tclkh)/2;
        end
    end
end // p_ClkRatSeq

// -----------------------------------------------------------------------------
// Determine the MEMCLK1 frequency
// -----------------------------------------------------------------------------
always @(negedge MEMCLK1 or EbiTrClk)
begin : p_MemClk1Seq
  if (MEMCLK1 == 1'b0)
    begin
      if (EbiTrClk[0] == 1'b1)
        begin
          Tmclkh1          <= (Tclkl + Tclkh)/4;
          Tmclkl1          <= (Tclkl + Tclkh)/4;
        end
      else
        begin
          Tmclkh1          <= (Tclkl + Tclkh)/2;
          Tmclkl1          <= (Tclkl + Tclkh)/2;
        end
    end
end // p_MemClk1Seq

// -----------------------------------------------------------------------------
// Determine the MEMCLK2 frequency
// -----------------------------------------------------------------------------
always @(negedge MEMCLK2 or EbiTrClk)
begin : p_MemClk2Seq
  if (MEMCLK2 == 1'b0)
    begin
      if (EbiTrClk[1] == 1'b1)
        begin
          Tmclkh2          <= (Tclkl + Tclkh)/4;
          Tmclkl2          <= (Tclkl + Tclkh)/4;
        end
      else
        begin
          Tmclkh2          <= (Tclkl + Tclkh)/2;
          Tmclkl2          <= (Tclkl + Tclkh)/2;
        end
    end
end // p_MemClk2Seq

// -----------------------------------------------------------------------------
// Determine the MEMCLK3 frequency
// -----------------------------------------------------------------------------
always @(negedge MEMCLK3 or EbiTrClk)
begin : p_MemClk3Seq
  if (MEMCLK3 == 1'b0)
    begin
      if (EbiTrClk[2] == 1'b1)
        begin
          Tmclkh3          <= (Tclkl + Tclkh)/4;
          Tmclkl3          <= (Tclkl + Tclkh)/4;
        end
      else
        begin
          Tmclkh3          <= (Tclkl + Tclkh)/2;
          Tmclkl3          <= (Tclkl + Tclkh)/2;
        end
    end
end // p_MemClk3Seq

// -----------------------------------------------------------------------------
// Generation of nPOR
// -----------------------------------------------------------------------------
always @(negedge HRESETn or posedge HCLK)
begin : p_PORGenSeq
  if (HRESETn == 1'b0)
    inPOR            <= 1'b0;
  else
    inPOR            <= 1'b1;
end // p_PORGenSeq

// -----------------------------------------------------------------------------
// Assigning internal copy of inPOR to output
// -----------------------------------------------------------------------------
assign #3 nPOR          = inPOR;

endmodule
// --================================== End ==================================--
