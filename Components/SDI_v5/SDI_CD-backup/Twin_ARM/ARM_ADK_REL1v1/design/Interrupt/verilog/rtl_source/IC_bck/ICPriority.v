// --=========================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from ARM Limited
//   (C) COPYRIGHT 2001 ARM Limited
//       ALL RIGHTS RESERVED
// The entire notice above must be reproduced on all authorised
// copies and copies may only be made to the extent permitted
// by a licensing agreement from ARM Limited.
//
// -----------------------------------------------------------------------------
// Version and Release Control Information:
//
// File Name             : ICPriority.v,v
// File Revision         : 1.3
//
// Release Information   : ADK_REL1v1
//
// -----------------------------------------------------------------------------
// Purpose :
//           This block implements the Interrupt Priority Logic.
//
// --=========================================================================--

// -----------------------------------------------------------------------------
//
//                             ICPriority
//                            ===========
//
// -----------------------------------------------------------------------------
//
// Overview
// ========
// This module implements the priority scheme between internal and external
// (daisy-chain) interrupts. The internal interrupts have priority over external
// and a read from the ICVectAddr register with a pending internal interrupts
// will cause the NonVectIrqServ flag to be set, masking that and any external
// interrupts.
// A write to the ICVectAddr register will cause NonVectIrqServ flag to be
// cleared indicating that this Interrupt has been serviced.
//
// -----------------------------------------------------------------------------

`timescale 1ns/1ps

module ICPriority (HCLK, HRESETn, PriorWrEnCo, PriorRdEn, NonVectIrqCo,
                   ICDefVectAddr, nICIRQIN, ICVECTADDRIN, ICIRQCo, nICIRQ,
                   ICVECTADDROUTCo);

// -----------------------------------------------------------------------------
// Component declarations
// -----------------------------------------------------------------------------
  input          HCLK;             //  AHB Clock
  input          HRESETn;          //  AHB Reset
  input          PriorWrEnCo;      //  VectAddr Write Enable
  input          PriorRdEn;        //  VectAddr Read Enable from ICAhbif
  input          NonVectIrqCo;     //  Non-Vectored Interrupt
  input [31:0]   ICDefVectAddr;    //  Default vector address
  input          nICIRQIN;         //  Normal interrupt input
  input [31:0]   ICVECTADDRIN;     //  Interrupt vector input
  output         ICIRQCo;          //  IRQ interrupt status
  output         nICIRQ;           //  Normal interrupt output
  output [31:0]  ICVECTADDROUTCo;  //  Vector address output

// -----------------------------------------------------------------------------
// Signal declarations
// -----------------------------------------------------------------------------

// Input/Output Signals
  wire         HCLK;
  wire         HRESETn;
  wire         PriorWrEnCo;
  wire         PriorRdEn;
  wire         NonVectIrqCo;
  wire [31:0]  ICDefVectAddr;
  wire         nICIRQIN;
  wire [31:0]  ICVECTADDRIN;
  wire         ICIRQCo;
  wire         nICIRQ;

  reg [31:0]   ICVECTADDROUTCo;   //  Vector address output register

// Internal Signals
  reg          NonVectIrqServ;    //  NonVectored IRQ being serviced
  reg          NxtNonVectIrqServ; //  D-input of NonVectIrqServ
  reg          NonVectIrqActive;  //  Indicates NonVectIrq is active
  wire         iICIRQ;            //  Internal copy of ICIRQ
  wire [31:0]  NxtAddrOut;        //  D-input of ICVECTADDROUT

// -----------------------------------------------------------------------------
//
// Main body of code
// =================
//
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Combinational logic for generating ICVECTADDROUTCo
//
// The Output vector is selected based on the following priority
// Highest -> Non-Vectored Interrupt
// Lowest  -> External IRQ
//
// Note that the ICVECTADDRIN will be selected as the output
// vector only if the Non-Vectored interrupts have been serviced.
// If no interrupt is there then default Vector Address will be selected.
// -----------------------------------------------------------------------------
  assign NxtAddrOut = NonVectIrqCo ? ICDefVectAddr

                      : (nICIRQIN == 1'b0) ? ICVECTADDRIN

                      : ICDefVectAddr;

// -----------------------------------------------------------------------------
// Sequential process for generating the ICVECTADDROUT signal.
// Also registers the NonVectIrq signal
// -----------------------------------------------------------------------------
  always @ (posedge HCLK or negedge HRESETn)
  begin : p_VectAddrOutSeq
    if (!HRESETn)
      begin
        ICVECTADDROUTCo  <= {32{1'b0}};
        NonVectIrqActive <= 1'b0;
      end
    else
      begin
        ICVECTADDROUTCo  <= NxtAddrOut;
        NonVectIrqActive <= NonVectIrqCo;
      end
  end

// -----------------------------------------------------------------------------
// Generate the interrupt from either source, if the service flag is not set.
// -----------------------------------------------------------------------------
  assign iICIRQ = (NonVectIrqCo || !nICIRQIN) && !NonVectIrqServ ? 1'b1

                  : 1'b0;

// -----------------------------------------------------------------------------
// Create the active low version of the output interrupt
// -----------------------------------------------------------------------------
  assign nICIRQ = (~iICIRQ);

// -----------------------------------------------------------------------------
// Combinational logic for the NonVectIrq service register
// -----------------------------------------------------------------------------
  always @ (NonVectIrqActive or NonVectIrqServ or PriorRdEn or PriorWrEnCo)
  begin : p_NonVectIrqServComb
    // If a read is detected to the ICVectAddr register, set the NonVectIrqServ
    // signal, masking out the NonVect IRQ and daisy chain interrupts.
    if (PriorRdEn)
      NxtNonVectIrqServ = NonVectIrqActive;

    // If a write is detected to the ICVectAddr register, clear the
    // NonVectIrqServ signal, indicating that the ISR has finished servicing
    //  this interrupt.
    else
      begin
        if (PriorWrEnCo)
          NxtNonVectIrqServ = 1'b0;
        else
          NxtNonVectIrqServ = NonVectIrqServ;
      end
  end

// -----------------------------------------------------------------------------
// Sequential logic for the NonVectIrq Service register
// -----------------------------------------------------------------------------
  always @ (negedge HRESETn or posedge HCLK)
  begin : p_NonVectIrqServSeq
    if (!HRESETn)
      NonVectIrqServ <= 1'b0;
    else
      NonVectIrqServ <= NxtNonVectIrqServ;
  end

// -----------------------------------------------------------------------------
// Assign local copies of signals to the outputs
// -----------------------------------------------------------------------------
  assign ICIRQCo = iICIRQ;

endmodule
