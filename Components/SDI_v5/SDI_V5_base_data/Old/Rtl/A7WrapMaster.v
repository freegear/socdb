// --=================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from ARM Limited
//   (C) COPYRIGHT 2000-2001 ARM Limited
//       ALL RIGHTS RESERVED
// The entire notice above must be reproduced on all authorised
// copies and copies may only be made to the extent permitted
// by a licensing agreement from ARM Limited.
// 
// ---------------------------------------------------------------------
// Version and Release Control Information:
// 
// File Name           : A7WrapMaster.v,v
// File Revision       : 1.4
// 
// Release Information : CPU_AHB_Wrappers-RELv1r1
// 
// ---------------------------------------------------------------------
// Purpose             : Bus master interface to the AHB for the ARM7
//                       core.  Takes simplified AHB-like signals from
//                       A7WrapSM and adds the ability to deal with
//                       split/error/retry responses from slaves, plus
//                       the ability to deal with loss of grant
//                       
// --=================================================================--
 
`timescale 1ns/1ps
 
module A7WrapMaster (HCLK, HRESETn, HREADY, HRESP, HGRANT, HSELS, MADDR,
		     MTRANS, MWRITE, MSIZE, MBURST, MPROT, MLOCK,
		     MBUSREQ, HADDR, HTRANS, HWRITE, HSIZE,
		     HBURST, HPROT, HBUSREQ, HLOCK, MREADY,
		     MERROR);
 
// AHB input signals into wrapper 
  input HCLK;
  input HRESETn;
  input HREADY;
  input [1:0] HRESP;
  input HGRANT;
  input HSELS;
// Signals from A7WrapSM into bus master block to become AHB outputs
  input [31:0] MADDR;
  input [1:0] MTRANS;
  input MWRITE;
  input [2:0] MSIZE;
  input [2:0] MBURST;
  input [3:0] MPROT;
  input MLOCK;
  input MBUSREQ;
// AHB output signals from bus master block
  output [31:0] HADDR;
  output [1:0] HTRANS;
  output HWRITE;
  output [2:0] HSIZE;
  output [2:0] HBURST;
  output [3:0] HPROT;
  output HBUSREQ;
  output HLOCK;
// Signals to A7WrapSM from bus master block
  output MREADY;
  output MERROR;
 
//----------------------------------------------------------------------
// Constant declarations
//----------------------------------------------------------------------
// HTRANS transfer
  `define TRN_IDLE	 2'b00
  `define TRN_BUSY	 2'b01
  `define TRN_NONSEQ	 2'b10
  `define TRN_SEQ	 2'b11
 
// HBURST transfer type signal encoding
  `define BUR_SINGLE	 3'b000
  `define BUR_INCR	 3'b001
  `define BUR_WRAP4	 3'b010
  `define BUR_INCR4	 3'b011
  `define BUR_WRAP8	 3'b100
  `define BUR_INCR8	 3'b101
  `define BUR_WRAP16	 3'b110
  `define BUR_INCR16	 3'b111
 
// HRESP transfer response signal encoding
  `define RSP_OKAY	 2'b00
  `define RSP_ERROR	 2'b01
  `define RSP_RETRY	 2'b10
  `define RSP_SPLIT	 2'b11
 
//----------------------------------------------------------------------
// Signal declarations
//----------------------------------------------------------------------

  wire ForceIncrNext;
  wire SR1;
  wire DeGrantHold;
  wire HoldSet;
  wire HoldClr;
  wire HoldSelNext;
  reg  iMREADY;
  reg  MERROR;
  reg  DataGrant;
  reg  AddrGrant;
  wire iAddrGrant;
  reg  SR2;
  reg  HoldSel;
  reg  HlockHold;
  reg  [3:0] HprotHold;
  reg  [2:0] HsizeHold;
  reg  HwriteHold;
  reg  [31:0] HaddrHold;
  reg  HLOCK;
  reg  [2:0] HburstInt;
  reg  [3:0] HPROT;
  reg  [2:0] HSIZE;
  reg  HWRITE;
  reg  [1:0] HtransInt;
  reg  [31:0] HADDR;
  reg  ForceIncr;

//----------------------------------------------------------------------
// Beginning of main code
//----------------------------------------------------------------------

//----------------------------------------------------------------------
// Wait state detection
//----------------------------------------------------------------------
// The Ready input to the core is driven LOW:
//  - When a transfer is in the holding register waiting to complete
//  - When a transfer is waiting to complete on the bus (as indicated
//    by DataGrant = '1') and the HREADYin signal is low
// Under all other circumstances the core is not waited.
  always @(HoldSel or DataGrant or HREADY or SR2)
    begin
      if ((HoldSel))
	iMREADY = 1'b0;
      else if ((DataGrant))
	if ((HREADY && !SR2))
	  iMREADY = 1'b1;
	else
	  iMREADY = 1'b0;
      else
	iMREADY = 1'b1;
    end // always @ (HoldSel or DataGrant or HREADY or SR2)
 
  assign MREADY = iMREADY;
//----------------------------------------------------------------------
// Error detection
//----------------------------------------------------------------------
  always @(DataGrant or HRESP)
    begin
      if ((DataGrant && HRESP == `RSP_ERROR))
	MERROR = 1'b1;
      else
	MERROR = 1'b0;
    end // always @ (DataGrant or HRESP)
 
//----------------------------------------------------------------------
// Bus request generation
//----------------------------------------------------------------------
// Bus request is passed straight from core. HoldSel is also used to
//  ensure that the wrapper requests the bus when it has a valid
//  transfer in the holding registers, but the core has stopped
//  requesting the bus.
  assign HBUSREQ = MBUSREQ | HoldSel;

//----------------------------------------------------------------------
// Address and data grant signals
//----------------------------------------------------------------------
// The AddrGrant and DataGrant signals indicate when the master has
//  control of the address/control and data buses.

  // Prevent the AHB logic from accessing the bus whilst the core is selected
  // for TIC testing
  assign  iAddrGrant = HGRANT & (~HSELS);

  always @( negedge (HRESETn) or posedge (HCLK) )
    begin
      if (!HRESETn)
	begin
	  AddrGrant <= 1'b0;
	  DataGrant <= 1'b0;
	end
      else
	begin
	  if (HREADY)
	    begin
	      AddrGrant <= iAddrGrant;
	      DataGrant <= AddrGrant;
	    end // if (HREADY)
	end // else: !if(!HRESETn)
    end // always @ ( negedge (HRESETn) or posedge (HCLK) )
 
//----------------------------------------------------------------------
// Split/Retry detection
//----------------------------------------------------------------------
// SR1 is set HIGH during the first cycle of a split/retry response
//  (when HREADY is LOW). The registered SR2 is HIGH during the second
//  cycle of the response (when HREADY is HIGH), at which point the
//  transfer type must be forced to IDLE.
  assign SR1 = ((DataGrant == 1'b1 && HREADY == 1'b0 &&
		 (HRESP == `RSP_RETRY || HRESP == `RSP_SPLIT)) ? 1'b1 : 1'b0);

  always @( negedge (HRESETn) or posedge (HCLK) )
    begin
      if (!HRESETn)
	SR2 <= 1'b0;
      else
	SR2 <= SR1;
    end // always @ ( negedge (HRESETn) or posedge (HCLK) )
 
//----------------------------------------------------------------------
// Holding register selection
//----------------------------------------------------------------------
// When the processor loses ownership of the bus it is possible to keep
//  clocking the core until the point where a real address has not been
//  accepted on to the bus. The DeGrantHold signal is set when the core
//  is clocked, but the address which it was presenting was not clocked
//  onto the bus (as indicated by AddrGrant being low).
  assign DeGrantHold = ((iMREADY == 1'b1 &&
			 (AddrGrant == 1'b0 || HREADY == 1'b0)
			 && HtransInt[1] == 1'b1) ? 1'b1 : 1'b0);

// HoldSet is used to set HoldSel when the holding registers need to
//  be used. Set HIGH when the core requests an access and is not
//  currently granted control of the bus, or has received a split or
//  retry response. Set LOW at all other times.
  assign HoldSet = (((DataGrant == 1'b1 && SR1 == 1'b1) ||
		     DeGrantHold == 1'b1) ? 1'b1 : 1'b0);

// HoldClr is used to clear HoldSel when the holding registers have
//  been used. Set HIGH when the holding registers are in use and the
//  address has been  sucessfully clocked on to the bus.
  assign HoldClr = ((HoldSel == 1'b1 && AddrGrant == 1'b1 &&
		     HREADY == 1'b1 && SR2 == 1'b0) ? 1'b1 : 1'b0);

// HoldSet and HoldClr are used to set and clear HoldSelNext, which
//  is then passed into a register.
  assign HoldSelNext = (HoldSet == 1'b1 ? 1'b1 :
			(HoldClr == 1'b1 ? 1'b0 : HoldSel));

  always @( negedge (HRESETn) or posedge (HCLK) )
    begin
      if (!HRESETn)
	HoldSel <= 1'b0;
      else
	HoldSel <= HoldSelNext;
    end // always @ ( negedge (HRESETn) or posedge (HCLK) )
 
//----------------------------------------------------------------------
// Address and control holding registers
//----------------------------------------------------------------------
// These registers are used to hold the previous cycle's address and
//  control signals for use in regenerating the transfer if the master
//  lost ownership of the bus, or if the current slave has generated a
//  Split/Retry response.
  always @( negedge (HRESETn) or posedge (HCLK) )
    begin
      if (!HRESETn)
	begin
	  HaddrHold <= 32'h0000_0000;
	  HwriteHold <= 1'b0;
	  HsizeHold <= 3'b000;
	  HprotHold <= 4'h0;
	  HlockHold <= 1'b0;
	end
      else
	begin
	  if (iMREADY)
	    begin
	      HaddrHold <= MADDR;
	      HwriteHold <= MWRITE;
	      HsizeHold <= MSIZE;
	      HprotHold <= MPROT;
	      HlockHold <= MLOCK;
	    end // if (iMREADY)
	end // else: !if(!HRESETn)
    end // always @ ( negedge (HRESETn) or posedge (HCLK) )
 
//----------------------------------------------------------------------
// Holding register multiplexer
//----------------------------------------------------------------------
// Selects between the core outputs or the holding registers for
// generation of the AHB outputs.
  always @(HoldSel or MADDR or HaddrHold or MTRANS or MWRITE or
	   HwriteHold or MSIZE or HsizeHold or MBURST or MPROT or
	   HprotHold or MLOCK or HlockHold)
    begin
      if (HoldSel)
	begin
	  HADDR = HaddrHold;
	  HtransInt = `TRN_NONSEQ;
	  HWRITE = HwriteHold;
	  HSIZE = HsizeHold;
	  HPROT = HprotHold;
	  HburstInt = `BUR_INCR;
	  HLOCK = HlockHold;
	end // if (HoldSel)
      else
	begin
	  HADDR = MADDR;
	  HtransInt = MTRANS;
	  HWRITE = MWRITE;
	  HSIZE = MSIZE;
	  HPROT = MPROT;
	  HburstInt = MBURST;
	  HLOCK = MLOCK;
	end // else: !if(HoldSel)
    end // always @ (HoldSel or MADDR or HaddrHold or MTRANS or MWRITE or...
 
//----------------------------------------------------------------------
// HTRANS output modification
//----------------------------------------------------------------------
// The HTRANS output must be changed to IDLE during the second cycle of
//  a split/retry transfer.
  assign HTRANS = (SR2 == 1'b1 ? `TRN_IDLE : HtransInt);

//----------------------------------------------------------------------
// Burst Override
//----------------------------------------------------------------------
// When the holding registers have been used it is necessary to
//  override the Burst type with type INCR. This is required until the
//  burst has completed.
  assign ForceIncrNext = (HoldSel == 1'b1 ? 1'b1 :
			  (MTRANS == `TRN_IDLE ? 1'b0 : ForceIncr));

  always @( negedge (HRESETn) or posedge (HCLK) )
    begin
      if (!HRESETn)
	ForceIncr <= 1'b0;
      else
	ForceIncr <= ForceIncrNext;
    end // always @ ( negedge (HRESETn) or posedge (HCLK) )
  
  assign HBURST = (ForceIncr == 1'b0 ? HburstInt : `BUR_INCR);
 
endmodule

// --============================= End ===============================--
