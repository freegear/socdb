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
//  File Name           : ArbSchm3.v,v
//  File Revision       : 1.5
// 
//  Release Information : ADK_REL1v1
// 
//  ----------------------------------------------------------------------------
//  Purpose             : AHB System Arbitration Scheme.
//                        The arbiter processes requests for ownership of the
//                        bus and grants one bus master according to the
//                        arbitration scheme.
//                        The arbitration scheme of this implementation is a
//                        simple priority encoded scheme where the highest
//                        priority master requesting the bus is granted.
//  --========================================================================--

`timescale 1ns/1ps

module ArbSchm3 
  (
   // Bused collection of all incoming requests
   Request,
   // Indicates whether the default master has been split
   SplitMaskDefault,
   // Indicates that an un-split defined length burst is in progress
   BurstInProgress,
   // Currently granted master
   AddrMaster,
   // Master to be granted next
   TopRequest
   );

  input  [3:0] Request;
  input        SplitMaskDefault;
  input        BurstInProgress;
  input  [3:0] AddrMaster;
  output [3:0] TopRequest;


//------------------------------------------------------------------------------
// Signal declarations
//------------------------------------------------------------------------------
  
// Input/Output Signals
  wire  [3:0] Request;
  wire        SplitMaskDefault;
  wire        BurstInProgress;
  wire  [3:0] AddrMaster;
  reg   [3:0] TopRequest;

//----------------------------------------------------------------------------
// Arbitration Priority Scheme
//----------------------------------------------------------------------------
// This section contains the arbitration priority algorithm and should be
//  changed if a different arbitration scheme is required. At this point in
//  the arbiter the individual requests (upto 15) are combined to give a 
//  single master which is highest priority and is encoded in a 4-bit 
//  number.
//
// The default scheme is:
//
//   HBUSREQ3 is the highest priority
//   HBUSREQ0 is the second highest priority - This must only be connected to
//            a Pause input.
//   HBUSREQ2 is the middle priority.
//   HBUSREQ1 is the lowest priority and default bus master - This input is
//              usually used for an uncached ARM core.
//
//  Bus master 0 is reserved for the dummy bus master, which never performs
//   real transfers. This master is granted when the default master is
//   performing a locked transfer which has received a split response.

  always @ (Request or SplitMaskDefault or BurstInProgress or AddrMaster)
    begin : p_TopRequestComb
      // If a burst is in progress then keep the current master granted
      // as it may have de-asserted its request line
      if (BurstInProgress)
        begin 
          TopRequest = AddrMaster;
        end
      else if (Request[3])
        begin 
          TopRequest = 4'b0011;
        end
      else if (Request[0])
        begin 
          TopRequest = 4'b0000;
        end
      else if (Request[2])
        begin 
          TopRequest = 4'b0010;
        end
      else if (Request[1])
        begin 
          TopRequest = 4'b0001;
        end

        // If no request then check that the default master has not
        // received a Split response. If the default master is changed
        // then it is important that appropriate bit of SplitMask is used.

      else if ((!SplitMaskDefault))
        begin 
          TopRequest = 4'b0001;
        end
      else
        begin
          TopRequest = 4'b0000;  // Dummy master          
        end 
    end 

endmodule

// --================================= End ===================================--

