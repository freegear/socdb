// --=========================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from ARM Limited
//   (C) COPYRIGHT 2000 ARM Limited
//       ALL RIGHTS RESERVED
// The entire notice above must be reproduced on all authorised
// copies and copies may only be made to the extent permitted
// by a licensing agreement from ARM Limited.
//
// -----------------------------------------------------------------------------
// Version and Release Control Information:
//
// File Name              : SspDummyPad.v.rca
// File Revision          : 1.1
//
// Release Information    : PrimeCell(TM)-PL022-REL1v2
//
// -----------------------------------------------------------------------------
// Purpose :
//          Dummy pad between SSP and Integration Trickbox
// --=========================================================================--

`timescale 1ns/1ps

// -----------------------------------------------------------------------------

module SspDummyPad (
// Inputs
        SSPTXDpadin,
        nSSPOEpaden,
        SSPCLKOUTpadin,
        nSSPCTLOEpaden,
        SSPFSSOUTpadin,
        

// Outputs 
        SSPTXDpadout,
        SSPCLKOUTpadout,
        SSPFSSOUTpadout
                    );

// Inputs
input       SSPTXDpadin;     //  Transmit Data input
input       nSSPOEpaden;     //  Tranmit Data enable input
input       SSPCLKOUTpadin;  //  Serial Clock input
input       nSSPCTLOEpaden;  //  Clock enable input
input       SSPFSSOUTpadin;  //  Frame/SlaveSelect input
        

// Outputs 
output      SSPTXDpadout;    //  Transmit Data output
output      SSPCLKOUTpadout; //  Serial Clock output
output      SSPFSSOUTpadout; //  Frame/SlaveSelect output
 

// -----------------------------------------------------------------------------
//
//                             SspDummyPad
//                             ===========
//
// -----------------------------------------------------------------------------
//
// Overview
// ========
//   SSPTXDpadin is fed by SSPTXD, buffered to become SSPTXDPadout.
//   nSSPOEpaden is fed by nSSPOE and is the enable control for SSPTXDpadout.
//   SSPCLKOUTpadin is fed by SSPCLKOUT, buffered to become SSPCLKOUTpadout.
//   nSSPCTLOEpaden is fed by nSSPCTLOE and is the enable control for 
//   SSPTXDpadout.
//   SSPFSOUTpadin is fed by SSPFSSOUT, buffered to become SSPFSSOUTpadout.
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Constant declarations
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Wire declarations
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Register declarations
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Function declarations
// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
//
// Main body of code
// =================
//
// -----------------------------------------------------------------------------


assign SSPTXDpadout    = (nSSPOEpaden == 1'b0) ? SSPTXDpadin : 1'bz;

assign SSPCLKOUTpadout = (nSSPCTLOEpaden == 1'b0) ? SSPCLKOUTpadin : 1'bz;

assign SSPFSSOUTpadout = SSPFSSOUTpadin;

endmodule
// --================================== End ==================================--
