// --=========================================================================--
//  ----------------------------------------------------------------------------
//  Purpose                : This module double synchronises the signals
//                           entering the SysClk clock domain from LCDCLK clock
//                           domains.
//
// --=========================================================================--
 
`timescale 1ns/1ps
 
//  ----------------------------------------------------------------------------
 
module LcdSyncSysClk (
			SysClk,
			nRST,
			SWReset,
			
			FrameStart,
			FrameRst,
			VCompStat,
			PlaneMixerEn,

			FrStSyncSysClk,
			FrRstSyncSysClk,
			VCStatSyncSysClk,
			PlaneMixerEnSyncSysClk
);

input   	SysClk;
input   	nRST;
input		SWReset;

input   	FrameRst;        	// End of frame signal
input   	FrameStart;      	// Start of frame signal to start DMA transfer
input   	VCompStat;       	// Vertical compare status
input   	PlaneMixerEn;       // DMA fifo read pointer increment enable
        	
output  	FrStSyncSysClk;     // Frame start signal synchronised to SysClk
output  	FrRstSyncSysClk;    // Frame reset signal synchronised to SysClk
output  	VCStatSyncSysClk;   // VCompstat signal synchronised to SysClk
output  	PlaneMixerEnSyncSysClk;   // PlaneMixerEn signal synchronised to SysClk 

// -----------------------------------------------------------------------------
//
// Overview
// ========
// This module contains D-type registers for the synchronisation of signals
// coming to the SysClk clock domain.
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Register declaration
// -----------------------------------------------------------------------------
reg            FrStSyncSysClk0;     
reg            FrRstSyncSysClk0;    
reg            VCStatSyncSysClk;   
reg            PlaneMixerEnSyncSysClk;  

reg            FrStSyncInt;
reg            FrRstSyncInt;
reg            PlaneMixerEnSyncInt;
reg            VCStatSyncInt;

//------------------------------------------------------------------------------
//
// Main body of code
// =================
//
//------------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Synchronisation of signals coming to SysClk - first level
// -----------------------------------------------------------------------------
always @(posedge SysClk or negedge nRST)
begin : p_SyncSysClk1Seq
  if (nRST == 1'b0)
    begin
      FrStSyncInt    <=  1'b0;
      FrRstSyncInt   <=  1'b0;
      VCStatSyncInt  <=  1'b0;
      PlaneMixerEnSyncInt   <=  1'b0;
    end
  else
    begin
      FrStSyncInt    <=  FrameStart;
      FrRstSyncInt   <=  FrameRst;
      VCStatSyncInt  <=  VCompStat;
      PlaneMixerEnSyncInt   <=  PlaneMixerEn;
    end
end // p_SyncSysClk1Seq

// -----------------------------------------------------------------------------
// Synchronisation of signals coming to SysClk - second level
// -----------------------------------------------------------------------------
always @(posedge SysClk or negedge nRST)
begin : p_SyncSysClk2Seq
  if (nRST == 1'b0)
    begin
      FrStSyncSysClk0   <=  1'b0;
      FrRstSyncSysClk0  <=  1'b0;
      VCStatSyncSysClk  <=  1'b0;
      PlaneMixerEnSyncSysClk  <=  1'b0;
    end
  else
    begin
      FrStSyncSysClk0   <=  FrStSyncInt;
      FrRstSyncSysClk0  <=  FrRstSyncInt;
      VCStatSyncSysClk  <=  VCStatSyncInt;
      PlaneMixerEnSyncSysClk  <=  PlaneMixerEnSyncInt;
    end
end // p_SyncSysClk2Seq

assign FrStSyncSysClk  = FrStSyncInt & ~FrStSyncSysClk0;
assign FrRstSyncSysClk = FrRstSyncSysClk0 | SWReset;

endmodule

// --================================== End ==================================--
