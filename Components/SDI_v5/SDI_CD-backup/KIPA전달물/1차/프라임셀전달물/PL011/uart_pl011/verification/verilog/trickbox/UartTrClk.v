// --=========================================================================--
//  This confidential and proprietary software may be used only as
//  authorised by a licensing agreement from ARM Limited
//    (C) COPYRIGHT 2000 ARM Limited
//        ALL RIGHTS RESERVED
//  The entire notice above must be reproduced on all authorised
//  copies and copies may only be made to the extent permitted
//  by a licensing agreement from ARM Limited.
//
//  ----------------------------------------------------------------------------
//  Version and Release Control Information:
//
//  File Name              : UartTrClk.v.rca
//  File Revision          : 1.4
//
//  Release Information    : PrimeCell(TM)-PL011-REL1v3
//
// -----------------------------------------------------------------------------
// Purpose      : This generates the UartCLK from either PCLK or an 
//                internally generated clock.It also has the RESET controller.
// -----------------------------------------------------------------------------

`timescale 1ns/1ps

// -----------------------------------------------------------------------------

module UartTrClk (
// Inputs
                  PCLK,
                  PRESETn,
                  RESETBIT,
                  ClkPeriod,
                  RSTMODEREG,
// Outputs
                  UartClk,
                  PCLKOn,
                  REFCLKOn,
                  nUARTRST
                 );

// Inputs
input         PCLK;             // APB bus clock
input         PRESETn;            // APB Reset
input         RESETBIT;         // Uart Reset status
input   [7:0] ClkPeriod;        // Clock Width
input   [3:0] RSTMODEREG;       // Clock and RST Cntlr 
// Outputs
output        UartClk;          // Uart Clock
output        PCLKOn;           // PCLK is routed to UartCLK line
output        REFCLKOn;         // UartRefCLK routed to UartClk 
output        nUARTRST;         // Uart reset                      

// Inputs
wire          PCLK;             // APB bus clock
wire          PRESETn;            // APB Reset
wire          RESETBIT;         // Uart Reset status
wire    [7:0] ClkPeriod;        // Clock Width
wire    [3:0] RSTMODEREG;       // Clock and RST Cntlr 
// Outputs
reg           UartClk;          // Uart Clock
reg           PCLKOn;           // PCLK is routed to UartCLK line
reg           REFCLKOn;         // UartRefCLK routed to UartClk 
reg           nUARTRST;         // Uart reset                      

// -----------------------------------------------------------------------------
//
//                               UartTrClk 
//                               =========
//
// -----------------------------------------------------------------------------
//
// Overview
// ========
//
// This Clock-Reset Controller provides the nUartRST and UartCLK signal to the 
// UUT. The nUartRST is derived from the RSTMODE bit of the TB_SET_PINS Register.
// Whenever the RSTMODE bit is asserted. The nUartRST is asserted asynchronously 
// but the deassertion is synchronized with respect to the UartCLK.
// The UartRefClk generator generates a clock whose frequency is dependent on 
// the SCLKTBCLKREG.  
// Depending on the state of RSTMODEREG either UartRefClk or PCLK is routed 
// as the final UartCLK.
//
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Signal declarations
// -----------------------------------------------------------------------------
reg           UartRefClk; 
// generated as per ClkPeriod

reg           PCLKEnNegSync; 
// PCLKEN bit synced to falling edge of PCLK

reg           RCLKEnNegSync;
// RCLKEn bit synced to falling edge of UartRefClk

wire          MuxInRCLK;
// RCLKEnNegSync anded with UartRefClk

wire          MuxInPCLK;
// PCLKEnNegSync anded with PCLK

reg [31:0] Clk_low;  // Clock Width 
reg [31:0] Clk_high;  // Clock Width

// -----------------------------------------------------------------------------
// Function declarations
// -----------------------------------------------------------------------------
//function CONV_INTEGER;
//input         arg: std_logic_vector
//variable OutVal : integer;
//begin
//  if (arg == 16'hUUUU)
//    OutVal := 2;
//  else
//    OutVal := CONV_INTEGER(arg);
//  end if;
//    CONV_INTEGER = OutVal;
//endfunction

// -----------------------------------------------------------------------------
//
// Main body of code
// =================
//
// -----------------------------------------------------------------------------
initial
begin
  UartRefClk = 1'b0;
  PCLKEnNegSync = 1'b0;
  RCLKEnNegSync = 1'b0;
  Clk_low = 32'h00000001;
  Clk_high = 32'h00000001;
end

// -----------------------------------------------------------------------------
// UartRefClk generation based on the value in UTCLKREG
// -----------------------------------------------------------------------------
always @(ClkPeriod or UartRefClk)
begin : p_UartCLKGenSeq
  if (ClkPeriod != 8'h00 && ClkPeriod !== 8'hXX)
    begin
      if (ClkPeriod[0] == 1'b1)
        Clk_low = ((({24'h000000, ClkPeriod[7:1]})) + 32'h00000001);
      else
        Clk_low = (({24'h000000, ClkPeriod[7:1]}));    

      Clk_high = (({24'h000000, ClkPeriod[7:1]}));

      if (UartRefClk == 1'b1)
        # Clk_high UartRefClk <= 1'b0;
      else
        # Clk_low UartRefClk <= 1'b1;
    end
end // p_UartCLKGenSeq

// -----------------------------------------------------------------------------
// Reset signal generator.The Reset is done asynchronously but the deassertion
// is done synchronous to the UartClk clock.
// -----------------------------------------------------------------------------
always @(negedge PRESETn or negedge UartClk)
begin : p_RstCntrlSeq
  if (PRESETn == 1'b0)
    nUARTRST <= 1'b0;
  else
    nUARTRST <= RESETBIT;
end // p_RstCntrlSeq

// -----------------------------------------------------------------------------
// Synchronize the Enable of the PCLK to the PCLK domain.
// -----------------------------------------------------------------------------
always @(negedge PCLK)
begin : p_PCLKEnSynczrSeq
  PCLKEnNegSync <= RSTMODEREG[2];
end // p_PCLKEnSynczrSeq

// -----------------------------------------------------------------------------
// Synchronize the Enable of the UartRefClk to the UartRefClk domain.
// -----------------------------------------------------------------------------
always @(negedge UartRefClk)
begin : p_RCLKEnSynczrSeq
  RCLKEnNegSync <= RSTMODEREG[3];
end // p_RCLKEnSynczrSeq

// -----------------------------------------------------------------------------
// Writes the Status Bits PCLKOn and REFCLKOn into the Status Register of the 
// TrickBox and the write is done on seeing the positive edge of the PCLK  
// -----------------------------------------------------------------------------
always @(posedge PCLK)
begin : p_StatGeneratorSeq
  PCLKOn   <= PCLKEnNegSync;
  REFCLKOn <= RCLKEnNegSync;
end // p_StatGeneratorSeq

assign MuxInRCLK        = UartRefClk & RCLKEnNegSync;

assign MuxInPCLK        = PCLK & PCLKEnNegSync;

// -----------------------------------------------------------------------------
// This process routes either the UartRefClk or the PCLK clock to the UartCLK
// line based on the value of the Select Bit of the RSTMODEREG Register.
// -----------------------------------------------------------------------------
always @(RSTMODEREG or MuxInPCLK or MuxInRCLK)
begin
  if (RSTMODEREG[1] == 1'b1)
    UartClk <= MuxInPCLK;
  else
    UartClk <= MuxInRCLK;
end // p_MuxComb

endmodule

// ========================== End of UartTrClk ==============================--
