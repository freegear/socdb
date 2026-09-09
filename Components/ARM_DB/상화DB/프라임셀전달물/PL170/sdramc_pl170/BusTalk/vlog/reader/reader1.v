// --=========================================================================--
//  This confidential and proprietary software may be used only as
//  authorised by a licensing agreement from ARM Limited
//    (C) COPYRIGHT 1999 ARM Limited
//        ALL RIGHTS RESERVED
//  The entire notice above must be reproduced on all authorised
//  copies and copies may only be made to the extent permitted
//  by a licensing agreement from ARM Limited.
// -----------------------------------------------------------------------------
//
//  Version and Release Control Information:
//
//  File Name              : reader1.v,v
//  File Revision          : 1.2
//
//  Release Information    : PrimeCell(TM)-PL170-REL2v2
//
// -----------------------------------------------------------------------------
//
// Purpose   : This block reads infile.bif and drives the corresponding packets.
//
// -----------------------------------------------------------------------------

`timescale 1ns/1ps
`include "../common/defs.v"

// -----------------------------------------------------------------------------

module reader1 (
               HCLK,
               BidGetLine,
               VRGetLine,
               BidAddr,
               BidData,
               BidMask,
               BidExp,
               BidSize,
               BidProt,
               BidTrans,
               BidBurst,
               BidWrite,
               BidResp,
               BidNumcyc,
               BidLimit,
               BidMasnum,
               BidMaslock,
               BidIdlcyc,
               BidRslimit,
               BidSuppmsg,
               BidTag,
               ResPhase,
               ResDelay,
               ResNumcyc,
               VRVregno,
               VRData,
               VRMask,
               VRExp,
               VRWrite,
               VRPhase,
               VREdge,
               VRDelay,
               VRTag,
               EnEndian,
               SpExpmas,
               SpNumcyc0,
               SpNumcyc1,
               SpNumcyc2,
               SpNumcyc3,
               SpNumcyc4,
               SpNumcyc5,
               SpNumcyc6,
               SpNumcyc7,
               SpNumcyc8,
               SpNumcyc9,
               SpNumcyc10,
               SpNumcyc11,
               SpNumcyc12,
               SpNumcyc13,
               SpNumcyc14,
               SpNumcyc15,
               SpLimit,
               BidCycSel,
               VRCycSel,
               RCycSel,
               EnCycSel,
               SpCycSel,
               Last
              );

parameter
  Tclk = 100;

input                    HCLK;               
input                    BidGetLine;     
input                    VRGetLine;       
output [31:0]            BidAddr;
output [63:0]            BidData;
output [63:0]            BidMask;
output [63:0]            BidExp;
output [2:0]             BidSize;
output [3:0]             BidProt;
output [1:0]             BidTrans;
output [2:0]             BidBurst;
output                   BidWrite;
output [1:0]             BidResp;
output [7:0]             BidNumcyc;
output [31:0]            BidLimit;
output [3:0]             BidMasnum;
output                   BidMaslock;
output [31:0]            BidIdlcyc;
output [31:0]            BidRslimit;
output                   BidSuppmsg;
output [159:0]           BidTag;
output                   ResPhase;
output [7:0]             ResDelay;
output [7:0]             ResNumcyc;
output [(8 * 3 - 1):0]   VRVregno;
output [(8 * 32 - 1):0]  VRData;
output [(8 * 32 - 1):0]  VRMask;
output [(8 * 32 - 1):0]  VRExp;
output [(8 - 1):0]       VRWrite;
output [(8 - 1):0]       VRPhase;
output [(8 - 1):0]       VREdge;
output [(8 * 8 - 1):0]   VRDelay;
output [(8 * 160 - 1):0] VRTag;
output [1:0]             EnEndian;
output [15:0]            SpExpmas;
output [7:0]             SpNumcyc0;
output [7:0]             SpNumcyc1;
output [7:0]             SpNumcyc2;
output [7:0]             SpNumcyc3;
output [7:0]             SpNumcyc4;
output [7:0]             SpNumcyc5;
output [7:0]             SpNumcyc6;
output [7:0]             SpNumcyc7;
output [7:0]             SpNumcyc8;
output [7:0]             SpNumcyc9;
output [7:0]             SpNumcyc10;
output [7:0]             SpNumcyc11;
output [7:0]             SpNumcyc12;
output [7:0]             SpNumcyc13;
output [7:0]             SpNumcyc14;
output [7:0]             SpNumcyc15;
output [7:0]             SpLimit;
 
output [3:0]             BidCycSel;
output [(8 * 4 - 1):0]   VRCycSel;
output [3:0]             RCycSel;
output [3:0]             EnCycSel;
output [3:0]             SpCycSel;
input                    Last;                     

// -----------------------------------------------------------------------------
//
//                             reader
//                             ======
//
// -----------------------------------------------------------------------------
//
// Overview
// ========
//
// This block looks at get line requests and drives packets out at the correct
// time. Get line requests are issued from blocks when all elements in it are
// idle. The request stays high until idle once more. When the bid block
// requests a line, the assumption is that all vr commands have finished and
// therefore the next line will be a Bus command. However, when the VR block
// requests a line, it does not mean that the next line is a VR command - it
// could be bid and in this case the line is buffered until get_line = g_get.
// Buffering is also required in the case that a line from infile is read and
// there are no vr commands to execute in that cycle. The reader must look at
// the next line to see whether it is VR. If it isn't, it will be buffered.
// -----------------------------------------------------------------------------
// Wire declarations
// -----------------------------------------------------------------------------
wire ICLK;
// Internal version of HCLK
wire SimEnd;
// Denotes testing is over
// -----------------------------------------------------------------------------
// Register declarations
// -----------------------------------------------------------------------------
reg        BidStored;
// Indicates whether the bid_line is to be driven
reg [7:0]  VRStored;
// This flag indicates whether the vr line is to be driven or not
reg        ResStored;
// This flag indicates whether the reset line is to be driven or not
reg        EndianStored;
// This flag indicates whether the endianness line is to be driven or not
reg        SplitStored;
// This flag indicates whether the split line is to be checked or not

// These w signals are for IPC as write storage
reg [3:0]             WBCycSel;
reg [3:0]             WRCycSel;
reg [3:0]             WSpCycSel;
reg [3:0]             WEnCycSel;
reg [31:0]            WBidAddr;
reg [63:0]            WBidData;
reg [63:0]            WBidMask;
reg [63:0]            WBidExp;
reg [2:0]             WBidSize;
reg [3:0]             WBidProt;
reg [1:0]             WBidTrans;
reg [2:0]             WBidBurst;
reg                   WBidWrite;
reg [1:0]             WBidResp;
reg [7:0]             WBidNumcyc;
reg [31:0]            WBidLimit;
reg [3:0]             WBidMasnum;
reg                   WBidMaslock;
reg [31:0]            WBidIdlcyc;
reg [31:0]            WBidRslimit;
reg                   WBidSuppmsg;
reg [159:0]           WBidTag;
reg                   WResPhase;
reg [7:0]             WResDelay;
reg [7:0]             WResNumcyc;
reg [1:0]             WEnEndian;
reg [15:0]            WSpExpmas;
reg [7:0]             WSpNumcyc0;
reg [7:0]             WSpNumcyc1;
reg [7:0]             WSpNumcyc2;
reg [7:0]             WSpNumcyc3;
reg [7:0]             WSpNumcyc4;
reg [7:0]             WSpNumcyc5;
reg [7:0]             WSpNumcyc6;
reg [7:0]             WSpNumcyc7;
reg [7:0]             WSpNumcyc8;
reg [7:0]             WSpNumcyc9;
reg [7:0]             WSpNumcyc10;
reg [7:0]             WSpNumcyc11;
reg [7:0]             WSpNumcyc12;
reg [7:0]             WSpNumcyc13;
reg [7:0]             WSpNumcyc14;
reg [7:0]             WSpNumcyc15;
reg [7:0]             WSpLimit;

wire [(8 * 3 - 1):0]  VRVregno;
wire [(8 * 32 - 1):0] VRData;
wire [(8 * 32 - 1):0] VRMask;
wire [(8 * 32 - 1):0] VRExp;
wire [(8 - 1):0]      VRWrite;
wire [(8 - 1):0]      VRPhase;
wire [(8 - 1):0]      VREdge;
wire [(8 * 8 - 1):0]  VRDelay;
wire [(8 * 160 - 1):0] VRTag;
// packet containing info about values to be driven on virtual reg lines

wire [15:0]            SpExpmas;
wire [7:0]             SpNumcyc0;
wire [7:0]             SpNumcyc1;
wire [7:0]             SpNumcyc2;
wire [7:0]             SpNumcyc3;
wire [7:0]             SpNumcyc4;
wire [7:0]             SpNumcyc5;
wire [7:0]             SpNumcyc6;
wire [7:0]             SpNumcyc7;
wire [7:0]             SpNumcyc8;
wire [7:0]             SpNumcyc9;
wire [7:0]             SpNumcyc10;
wire [7:0]             SpNumcyc11;
wire [7:0]             SpNumcyc12;
wire [7:0]             SpNumcyc13;
wire [7:0]             SpNumcyc14;
wire [7:0]             SpNumcyc15;
wire [7:0]             SpLimit;
wire [3:0]             SpCycSel;

//internal signals 
reg [31:0]       IBidAddr;
reg [63:0]       IBidData;
reg [63:0]       IBidMask;
reg [63:0]       IBidExp;
reg [2:0]        IBidSize;
reg [3:0]        IBidProt;
reg [1:0]        IBidTrans;
reg [2:0]        IBidBurst;
reg              IBidWrite;
reg [1:0]        IBidResp;
reg [7:0]        IBidNumcyc;
reg [31:0]       IBidLimit;
reg [3:0]        IBidMasnum;
reg              IBidMaslock;
reg [31:0]       IBidIdlcyc;
reg [31:0]       IBidRslimit;
reg              IBidSuppmsg;
reg [159:0]      IBidTag;

// W packet containing info about values to be driven on virtual reg lines
reg [3:0]        WVCycSel [7:0];
reg [2:0]        WVRVregno [(8 - 1):0];
reg [(32 - 1):0] WVRData [(8 - 1):0];
reg [(32 - 1):0] WVRMask [(8 - 1):0];
reg [(32 - 1):0] WVRExp [(8 - 1):0];
reg [(8 - 1):0]  WVRWrite;
reg [(8 - 1):0]  WVRPhase;
reg [(8 - 1):0]  WVREdge;
reg [7:0]        WVRDelay [(8 - 1):0];
reg [159:0]      WVRTag [(8 - 1):0];
reg [2:0]        IVRVregno [(8 - 1):0];
reg [(32 - 1):0] IVRData [(8 - 1):0];
reg [(32 - 1):0] IVRMask [(8 - 1):0];
reg [(32 - 1):0] IVRExp [(8 - 1):0];

reg [(8 - 1):0]  IVRWrite;
reg [(8 - 1):0]  IVRPhase;
reg [(8 - 1):0]  IVREdge;
reg [7:0]        IVRDelay [(8 - 1):0];
reg [159:0]      IVRTag [(8 - 1):0];
reg [7:0]        IResNumcyc;
reg [7:0]        IResDelay;
reg              IResPhase;
reg [3:0]        IRCycSel;
reg [3:0]        IBidCycSel;
reg [3:0]        IVRCycSel [7:0];
reg [3:0]        IEnCycSel;
reg [3:0]        ISpCycSel;
reg [1:0]        IEnEndian;
reg [15:0]       ISpExpmas;
reg [7:0]        ISpNumcyc;
reg [7:0]        ISpNumcyc0;
reg [7:0]        ISpNumcyc1;
reg [7:0]        ISpNumcyc2;
reg [7:0]        ISpNumcyc3;
reg [7:0]        ISpNumcyc4;
reg [7:0]        ISpNumcyc5;
reg [7:0]        ISpNumcyc6;
reg [7:0]        ISpNumcyc7;
reg [7:0]        ISpNumcyc8;
reg [7:0]        ISpNumcyc9;
reg [7:0]        ISpNumcyc10;
reg [7:0]        ISpNumcyc11;
reg [7:0]        ISpNumcyc12;
reg [7:0]        ISpNumcyc13;
reg [7:0]        ISpNumcyc14;
reg [7:0]        ISpNumcyc15;
reg [7:0]        ISpLimit;
 
// temporary registers for holding packet values returned from READCOMMAND task
reg [3:0]             VCycSel;
reg [31:0]            VBidAddr;
reg [63:0]            VBidData;
reg [63:0]            VBidMask;
reg [63:0]            VBidExp;
reg [2:0]             VBidSize;
reg [3:0]             VBidProt;
reg [1:0]             VBidTrans;
reg [2:0]             VBidBurst;
reg                   VBidWrite;
reg [1:0]             VBidResp;
reg [7:0]             VBidNumcyc;
reg [31:0]            VBidLimit;
reg [3:0]             VBidMasnum;
reg                   VBidMaslock;
reg [31:0]            VBidIdlcyc;
reg [31:0]            VBidRslimit;
reg                   VBidSuppmsg;
reg [159:0]           VBidTag;
reg                   VResPhase;
reg [7:0]             VResDelay;
reg [7:0]             VResNumcyc;
reg [2:0]             VVRVregno;
reg [31:0]            VVRData;
reg [31:0]            VVRMask;
reg [31:0]            VVRExp;
reg                   VVRWrite;
reg                   VVRPhase;
reg                   VVREdge;
reg [7:0]             VVRDelay;
reg [(8 * 160 - 1):0] VVRTag;
reg [1:0]             VEnEndian;
reg [15:0]            VSpExpmas;
reg [7:0]             VSpNumcyc0;
reg [7:0]             VSpNumcyc1;
reg [7:0]             VSpNumcyc2;
reg [7:0]             VSpNumcyc3;
reg [7:0]             VSpNumcyc4;
reg [7:0]             VSpNumcyc5;
reg [7:0]             VSpNumcyc6;
reg [7:0]             VSpNumcyc7;
reg [7:0]             VSpNumcyc8;
reg [7:0]             VSpNumcyc9;
reg [7:0]             VSpNumcyc10;
reg [7:0]             VSpNumcyc11;
reg [7:0]             VSpNumcyc12;
reg [7:0]             VSpNumcyc13;
reg [7:0]             VSpNumcyc14;
reg [7:0]             VSpNumcyc15;
reg [7:0]             VSpLimit;
 

//  buffer variables
reg [3:0]             BCycSel;
reg [3:0]             BVCycSel;
reg [31:0]            BBidAddr;
reg [63:0]            BBidData;
reg [63:0]            BBidMask;
reg [63:0]            BBidExp;
reg [2:0]             BBidSize;
reg [3:0]             BBidProt;
reg [1:0]             BBidTrans;
reg [2:0]             BBidBurst;
reg                   BBidWrite;
reg [1:0]             BBidResp;
reg [7:0]             BBidNumcyc;
reg [31:0]            BBidLimit;
reg [3:0]             BBidMasnum;
reg                   BBidMaslock;
reg [31:0]            BBidIdlcyc;
reg [31:0]            BBidRslimit;
reg                   BBidSuppmsg;
reg [159:0]           BBidTag;
reg [2:0]             BVRVregno;
reg [31:0]            BVRData;
reg [31:0]            BVRMask;
reg [31:0]            BVRExp;
reg                   BVRWrite;
reg                   BVRPhase;
reg                   BVREdge;
reg [63:0]            BVRDelay;
reg [159:0]           BVRTag;
reg                   BidBuffered;
reg                   EndBuffered;
reg                   VRBuffered;
reg                   ReadAnother;
reg [7:0]             StoredDelay;
reg [7:0]             VRStoredVar;
reg [3:0]             VRIndex, VRIndex2;

reg                   TestEnd; 
// Denoting end of simulation

`include "../reader/command_reader1.v"
// -----------------------------------------------------------------------------
//
// Main body of code
// =================
//
// -----------------------------------------------------------------------------
 
assign BidAddr    = IBidAddr;
assign BidData    = IBidData;
assign BidMask    = IBidMask;
assign BidExp     = IBidExp;
assign BidSize    = IBidSize;
assign BidProt    = IBidProt;
assign BidTrans   = IBidTrans;
assign BidBurst   = IBidBurst;
assign BidWrite   = IBidWrite;
assign BidResp    = IBidResp;
assign BidNumcyc  = IBidNumcyc;
assign BidLimit   = IBidLimit;
assign BidMasnum  = IBidMasnum;
assign BidMaslock = IBidMaslock;
assign BidIdlcyc  = IBidIdlcyc;
assign BidRslimit = IBidRslimit;
assign BidSuppmsg = IBidSuppmsg;
assign BidTag     = IBidTag;
assign VRVregno = {IVRVregno[7],
                   IVRVregno[6],
                   IVRVregno[5],
                   IVRVregno[4],
                   IVRVregno[3],
                   IVRVregno[2],
                   IVRVregno[1],
                   IVRVregno[0]};
 
assign VRData = {IVRData[7],
                 IVRData[6],
                 IVRData[5],
                 IVRData[4],
                 IVRData[3],
                 IVRData[2],
                 IVRData[1],
                 IVRData[0]};
assign VRMask = {IVRMask[7],
                 IVRMask[6],
                 IVRMask[5],
                 IVRMask[4],
                 IVRMask[3],
                 IVRMask[2],
                 IVRMask[1],
                 IVRMask[0]};

assign VRExp = {IVRExp[7],
                IVRExp[6],
                IVRExp[5],
                IVRExp[4],
                IVRExp[3],
                IVRExp[2],
                IVRExp[1],
                IVRExp[0]};

// Edge, phase, and write mode data stored in simple register arrays
 
assign VRWrite = IVRWrite;
 
assign VRPhase = IVRPhase;
 
assign VREdge  = IVREdge;
 
assign VRDelay = {IVRDelay[7],
                  IVRDelay[6],
                  IVRDelay[5],
                  IVRDelay[4],
                  IVRDelay[3],
                  IVRDelay[2],
                  IVRDelay[1],
                  IVRDelay[0]};

assign VRTag = {IVRTag[7],
                IVRTag[6],
                IVRTag[5],
                IVRTag[4],
                IVRTag[3],
                IVRTag[2],
                IVRTag[1],
                IVRTag[0]};
 
assign ResNumcyc = IResNumcyc;
 
assign ResDelay  = IResDelay;
 
assign ResPhase  = IResPhase;

assign RCycSel   = IRCycSel;
 
assign BidCycSel = IBidCycSel;

assign VRCycSel = {IVRCycSel[7],
                   IVRCycSel[6],
                   IVRCycSel[5],
                   IVRCycSel[4],
                   IVRCycSel[3],
                   IVRCycSel[2],
                   IVRCycSel[1],
                   IVRCycSel[0]};                    

assign EnCycSel   = IEnCycSel;

assign EnEndian   = IEnEndian;

assign SpCycSel   = ISpCycSel;

assign SpExpmas   = ISpExpmas;

assign SpNumcyc0  = ISpNumcyc0;

assign SpNumcyc1  = ISpNumcyc1;

assign SpNumcyc2  = ISpNumcyc2;

assign SpNumcyc3  = ISpNumcyc3;

assign SpNumcyc4  = ISpNumcyc4;

assign SpNumcyc5  = ISpNumcyc5;

assign SpNumcyc6  = ISpNumcyc6;

assign SpNumcyc7  = ISpNumcyc7;

assign SpNumcyc8  = ISpNumcyc8;

assign SpNumcyc9  = ISpNumcyc9;

assign SpNumcyc10 = ISpNumcyc10;

assign SpNumcyc11 = ISpNumcyc11;

assign SpNumcyc12 = ISpNumcyc12;

assign SpNumcyc13 = ISpNumcyc13;

assign SpNumcyc14 = ISpNumcyc14;

assign SpNumcyc15 = ISpNumcyc15;

assign SpLimit    = ISpLimit;

// Delayed HCLK is necessary as Bidgetline is assigned  at negedge HCLK
assign #1  ICLK = HCLK;

assign SimEnd = ((Last == 1'b1) && (HCLK == 1'b0)) ? 1'b1 : 1'b0;

// Insert hand written Verilog for reading modified BIF file here.
 

// -----------------------------------------------------------------------------
// The read process does the clever scheduling.  It shouldn't be neccessary
// to change any of this when porting to other test benches.
// -----------------------------------------------------------------------------
initial
begin
  VCycSel        = 4'd0;
  BidStored      = `FALSE;
  ResStored      = `FALSE;
  EndianStored   = `FALSE;
  SplitStored    = `FALSE;
  ReadAnother    = 1'b0;
  TestEnd        = 1'b0;
  BidBuffered    = 1'b0;
  EndBuffered    = `FALSE;
  VRBuffered     = `FALSE;
  StoredDelay    = 8'b00000001;
end

// -----------------------------------------------------------------------------
// If bidbuffered then the active packet is bbidpacket
// else, read a new packet from infile.bif
// -----------------------------------------------------------------------------
always @(ICLK)
begin
  if (!(ICLK)) 
    begin
      if (BidStored == 1'b1) 
        BidStored <= `FALSE;

      if (ResStored == 1'b1) 
        ResStored <= `FALSE;

      for (VRIndex = 0; VRIndex < 8; VRIndex = VRIndex + 1)
        if (VRStored[VRIndex] === 1'b1)
          VRStored[VRIndex] <= 1'b0;
      if (EndianStored == 1'b1)
        EndianStored <= `FALSE;

      if (SplitStored == 1'b1) 
        SplitStored   <= `FALSE;

    // Fetching data to drive signals in nxt pos-edge 
      if (BidGetLine == `T_GET_G_GET) 
        begin
        // Checking whether simulation is over
          if (EndBuffered == 1'b1) 
            begin
              VCycSel = `T_CYCLE_C_END;
            end
        // Checking whether any packet is bufferred
          else if (!(BidBuffered))
            begin
            READCOMMAND ;
            end
          else 
            begin
              VBidAddr    = BBidAddr;
              VBidData    = BBidData;
              VBidMask    = BBidMask;
              VBidExp     = BBidExp;
              VBidSize    = BBidSize;
              VBidProt    = BBidProt;
              VBidTrans   = BBidTrans;
              VBidBurst   = BBidBurst;
              VBidWrite   = BBidWrite ;
              VBidResp    = BBidResp ;
              VBidNumcyc  = BBidNumcyc;
              VBidLimit   = BBidLimit;
              VBidMasnum  = BBidMasnum;
              VBidMaslock = BBidMaslock;
              VBidIdlcyc  = BBidIdlcyc;
              VBidRslimit = BBidRslimit;
              VBidSuppmsg = BBidSuppmsg;
              VBidTag     = BBidTag;
              VCycSel     = BCycSel;
              BidBuffered = 1'b0;
            end 
 
          if (VRBuffered)
            begin
              WVRVregno[BVRVregno]   <= BVRVregno;
              WVRData[BVRVregno]     <= BVRData;
              WVRMask[BVRVregno]     <= BVRMask;
              WVRExp[BVRVregno]      <= BVRExp;
              WVRWrite[BVRVregno]    <= BVRWrite;
              WVRPhase[BVRVregno]    <= BVRPhase;
              WVREdge[BVRVregno]     <= BVREdge;
              WVRDelay[BVRVregno]    <= BVRDelay;
              WVRTag[BVRVregno]      <= BVRTag;
              VRStored[BVRVregno]    <= 1'b1;
              VRStoredVar[BVRVregno] = 1'b1;
              WVCycSel[BVRVregno]    <= BVCycSel;
              VRBuffered             = 1'b0;
            end
          else
            begin
              for (VRIndex = 0; VRIndex < 8; VRIndex = VRIndex +1)
                VRStoredVar[VRIndex] = 1'b0;
            end
          case (VCycSel) 
          // Storing the packet to be driven 
          `T_CYCLE_C_SW, `T_CYCLE_C_SR :
            begin
              WBidAddr    <= VBidAddr;
              WBidData    <= VBidData;
              WBidMask    <= VBidMask;
              WBidExp     <= VBidExp;
              WBidSize    <= VBidSize;
              WBidProt    <= VBidProt;
              WBidTrans   <= VBidTrans;
              WBidBurst   <= VBidBurst;
              WBidWrite   <= VBidWrite ;
              WBidResp    <= VBidResp ;
              WBidNumcyc  <= VBidNumcyc;
              WBidLimit   <= VBidLimit;
              WBidMasnum  <= VBidMasnum;
              WBidMaslock <= VBidMaslock;
              WBidIdlcyc  <= VBidIdlcyc;
              WBidRslimit <= VBidRslimit;
              WBidSuppmsg <= VBidSuppmsg;
              WBidTag     <= VBidTag;
              WBCycSel    <= VCycSel;
              BidStored   <= `TRUE;
              ReadAnother = 1'b1;
              // Fetching next packet to bbid_packet if it is a read/write op.
              // Else perform virtual register operations/reset parallely 
              // If it's reset/VW/VR, then get the next bid packet also 
              while (ReadAnother == 1'b1)
                begin
                  READCOMMAND;
                  case (VCycSel)
                  `T_CYCLE_C_SW, `T_CYCLE_C_SR :
                    begin
                      BBidAddr    = VBidAddr;
                      BBidData    = VBidData;
                      BBidMask    = VBidMask;
                      BBidExp     = VBidExp;
                      BBidSize    = VBidSize;
                      BBidProt    = VBidProt;
                      BBidTrans   = VBidTrans;
                      BBidBurst   = VBidBurst;
                      BBidWrite   = VBidWrite ;
                      BBidResp    = VBidResp ;
                      BBidNumcyc  = VBidNumcyc;
                      BBidLimit   = VBidLimit;
                      BBidMasnum  = VBidMasnum;
                      BBidMaslock = VBidMaslock;
                      BBidIdlcyc  = VBidIdlcyc;
                      BBidRslimit = VBidRslimit;
                      BBidSuppmsg = VBidSuppmsg;
                      BBidTag     = VBidTag;
                      BCycSel     = VCycSel;
                      BidBuffered = 1'b1;
                      StoredDelay = 8'b00000001;
                      ReadAnother = 1'b0;
                    end
                  `T_CYCLE_C_VR,`T_CYCLE_C_VW :
                    begin
                      if ((!(VRStoredVar[VVRVregno]))
                           && (VVRDelay === StoredDelay))
                        begin
                          WVRVregno[VVRVregno]   <= VVRVregno;
                          WVRData[VVRVregno]     <= VVRData;
                          WVRMask[VVRVregno]     <= VVRMask;
                          WVRExp[VVRVregno]      <= VVRExp;
                          WVRWrite[VVRVregno]    <= VVRWrite;
                          WVRPhase[VVRVregno]    <= VVRPhase;
                          WVREdge[VVRVregno]     <= VVREdge;
                          WVRDelay[VVRVregno]    <= VVRDelay;
                          WVRTag[VVRVregno]      <= VVRTag;
                          VRStored[VVRVregno]    <= 1'b1;
                          VRStoredVar[VVRVregno] = 1'b1;
                          StoredDelay            = VVRDelay;
                          WVCycSel[VVRVregno]    <= VCycSel;
                        end
                      else
                        begin
                          BVRVregno   = VVRVregno;
                          BVRData     = VVRData;
                          BVRMask     = VVRMask;
                          BVRExp      = VVRExp;
                          BVRWrite    = VVRWrite;
                          BVRPhase    = VVRPhase;
                          BVREdge     = VVREdge;
                          BVRDelay    = VVRDelay;
                          BVRTag      = VVRTag;
                          BVCycSel    = VCycSel;
                          VRBuffered  = 1'b1;
                          StoredDelay = VVRDelay;
                          for (VRIndex = 0; VRIndex < 8; VRIndex = VRIndex +1)
                            VRStoredVar[VRIndex] = 1'b0;
                          ReadAnother = 1'b0; 
                        end
                    end
                  `T_CYCLE_C_ENDIAN :
                    begin
                      WEnEndian       <= VEnEndian;
                      WEnCycSel       <= VCycSel;
                      EndianStored    <= 1'b1;
                    end
                  `T_CYCLE_C_SPLIT :
                    begin
                      WSpExpmas    <= VSpExpmas;
                      WSpNumcyc0   <= VSpNumcyc0;
                      WSpNumcyc1   <= VSpNumcyc1;
                      WSpNumcyc2   <= VSpNumcyc2;
                      WSpNumcyc3   <= VSpNumcyc3;
                      WSpNumcyc4   <= VSpNumcyc4;
                      WSpNumcyc5   <= VSpNumcyc5;
                      WSpNumcyc6   <= VSpNumcyc6;
                      WSpNumcyc7   <= VSpNumcyc7;
                      WSpNumcyc8   <= VSpNumcyc8;
                      WSpNumcyc9   <= VSpNumcyc9;
                      WSpNumcyc10  <= VSpNumcyc10;
                      WSpNumcyc11  <= VSpNumcyc11;
                      WSpNumcyc10  <= VSpNumcyc12;
                      WSpNumcyc10  <= VSpNumcyc13;
                      WSpNumcyc10  <= VSpNumcyc14;
                      WSpNumcyc10  <= VSpNumcyc15;
                      WSpLimit     <= VSpLimit;
                      WSpCycSel    <= VCycSel;
                      SplitStored  <= 1'b1;  
                    end
                  `T_CYCLE_C_RES :
                    begin
                      WRCycSel   <= VCycSel;
                      WResPhase  <= VResPhase;
                      WResDelay  <= VResDelay;
                      WResNumcyc <= VResNumcyc;
                      ResStored  <= 1'b1;
                    end
                  `T_CYCLE_C_END :
                    begin
                      BCycSel     <= VCycSel;
                      EndBuffered  = 1'b1;
                      ReadAnother  = 1'b0;
                    end
                  default  :
                    ReadAnother = 1'b0;
                  endcase
                end // while ReadAnother
            end
          `T_CYCLE_C_END :
           begin
            TestEnd   = 1'b1;
            WBCycSel <= VCycSel;                 // Extra command than in APB
           end
          default : ;
          endcase
        end
    // VR block issues a get next command
      else if (VRGetLine == `T_GET_G_GET)
        begin
          if (VRBuffered == 1'b1)
            begin
              WVRVregno[BVRVregno]  <= BVRVregno;
              WVRData[BVRVregno]    <= BVRData;
              WVRMask[BVRVregno]    <= BVRMask;
              WVRExp[BVRVregno]     <= BVRExp;
              WVRWrite[BVRVregno]   <= BVRWrite;
              WVRPhase[BVRVregno]   <= BVRPhase;
              WVREdge[BVRVregno]    <= BVREdge;
              WVRDelay[BVRVregno]   <= BVRDelay;
              WVRTag[BVRVregno]     <= BVRTag;
              VRStored[BVRVregno]   <= 1'b1;
              VRStoredVar[BVRVregno] = 1'b1;
              WVCycSel[BVRVregno]   <= BVCycSel;
              VRBuffered             = 1'b0;
            end
          if (!(BidBuffered))
            begin
              ReadAnother = 1'b1;
              while ((ReadAnother))
                begin
                  READCOMMAND;
                  case (VCycSel)
                  `T_CYCLE_C_SW, `T_CYCLE_C_SR :
                    begin
                      BBidAddr    = VBidAddr;
                      BBidData    = VBidData;
                      BBidMask    = VBidMask;
                      BBidExp     = VBidExp;
                      BBidSize    = VBidSize;
                      BBidProt    = VBidProt;
                      BBidTrans   = VBidTrans;
                      BBidBurst   = VBidBurst;
                      BBidWrite   = VBidWrite;
                      BBidResp    = VBidResp;
                      BBidNumcyc  = VBidNumcyc;
                      BBidLimit   = VBidLimit;
                      BBidMasnum  = VBidMasnum;
                      BBidMaslock = VBidMaslock;
                      BBidIdlcyc  = VBidIdlcyc;
                      BBidRslimit = VBidRslimit;
                      BBidSuppmsg = VBidSuppmsg;
                      BBidTag     = VBidTag;
                      BCycSel     = VCycSel;
                      BidBuffered = 1'b1;
                      StoredDelay = 8'b00000001;
                      ReadAnother = 1'b0;
                    end
                  `T_CYCLE_C_VR,`T_CYCLE_C_VW :
                    begin
                      if ((!(VRStoredVar[VVRVregno] === 1'b1))
                           && VVRDelay === StoredDelay)
                        begin
                          WVRVregno[VVRVregno]   <= VVRVregno;
                          WVRData[VVRVregno]     <= VVRData;
                          WVRMask[VVRVregno]     <= VVRMask;
                          WVRExp[VVRVregno]      <= VVRExp;
                          WVRWrite[VVRVregno]    <= VVRWrite;
                          WVRPhase[VVRVregno]    <= VVRPhase;
                          WVREdge[VVRVregno]     <= VVREdge;
                          WVRDelay[VVRVregno]    <= VVRDelay;
                          WVRTag[VVRVregno]      <= VVRTag;
                          VRStored[VVRVregno]    <= 1'b1;
                          VRStoredVar[VVRVregno]  = 1'b1;
                          StoredDelay             = VVRDelay;
                          WVCycSel[VVRVregno]    <= VCycSel;
                        end
                      else
                        begin
                          BVRVregno   = VVRVregno;
                          BVRData     = VVRData;
                          BVRMask     = VVRMask;
                          BVRExp      = VVRExp;
                          BVRWrite    = VVRWrite;
                          BVRPhase    = VVRPhase;
                          BVREdge     = VVREdge;
                          BVRDelay    = VVRDelay;
                          BVRTag      = VVRTag;
                          BVCycSel    = VCycSel;
                          VRBuffered  = 1'b1;
                          StoredDelay = VVRDelay;
                          for (VRIndex = 0; VRIndex < 8; VRIndex = VRIndex +1)
                            VRStoredVar[VRIndex] = 1'b0;
                          ReadAnother = 1'b0;
                        end
                    end
                  `T_CYCLE_C_ENDIAN :
                    begin
                      WEnEndian       <= VEnEndian;
                      WEnCycSel       <= VCycSel;
                      EndianStored    <= 1'b1;
                    end
                  `T_CYCLE_C_SPLIT :
                    begin
                      WSpExpmas    <= VSpExpmas;
                      WSpNumcyc0   <= VSpNumcyc0;
                      WSpNumcyc1   <= VSpNumcyc1;
                      WSpNumcyc2   <= VSpNumcyc2;
                      WSpNumcyc3   <= VSpNumcyc3;
                      WSpNumcyc4   <= VSpNumcyc4;
                      WSpNumcyc5   <= VSpNumcyc5;
                      WSpNumcyc6   <= VSpNumcyc6;
                      WSpNumcyc7   <= VSpNumcyc7;
                      WSpNumcyc8   <= VSpNumcyc8;
                      WSpNumcyc9   <= VSpNumcyc9;
                      WSpNumcyc10  <= VSpNumcyc10;
                      WSpNumcyc11  <= VSpNumcyc11;
                      WSpNumcyc10  <= VSpNumcyc12;
                      WSpNumcyc10  <= VSpNumcyc13;
                      WSpNumcyc10  <= VSpNumcyc14;
                      WSpNumcyc10  <= VSpNumcyc15;
                      WSpLimit     <= VSpLimit;
                      WSpCycSel    <= VCycSel;
                      SplitStored  <= 1'b1;
                    end
                  `T_CYCLE_C_RES :
                    begin
                      TestEnd     = 1'b1;
                      WRCycSel   <= VCycSel;
                      WResPhase  <= VResPhase;
                      WResDelay  <= VResDelay;
                      WResNumcyc <= VResNumcyc;
                      ResStored  <= 1'b1;
                    end
                  `T_CYCLE_C_END :
                    begin
                      BCycSel      <= VCycSel;
                      EndBuffered  = 1'b1;
                      TestEnd      <= 1'b1;
                    end
                  default  :
                    ReadAnother = 1'b0;
                  endcase
                end // while ReadAnother
            end
        end
    end
end

// -----------------------------------------------------------------------------
// This drive process looks at the stored flags and then drives the w
// signals onto the output in the high phase of HCLK.
// Note that info is only reliably sampled in the first high phase
// since the cycle select signals will go to idle in the low phase.
// -----------------------------------------------------------------------------
always @(HCLK or WBidAddr or WBidData or
           WBidMask or WBidExp or WBidSize or WBidProt
           or WBidTrans or WBidBurst or WBidWrite or
           WBidResp or WBidNumcyc or WBidLimit or
           WBidMasnum or WBidMaslock or WBidIdlcyc or
           WBidRslimit or WBidSuppmsg or WBidTag or WResPhase
           or WResDelay or WResNumcyc) 
begin : p_drive
  if (HCLK == 1'b0) 
    begin
      if (BidStored == 1'b1)
        begin
          IBidAddr    <= WBidAddr;
          IBidData    <= WBidData;
          IBidMask    <= WBidMask;
          IBidExp     <= WBidExp;
          IBidSize    <= WBidSize;
          IBidProt    <= WBidProt;
          IBidTrans   <= WBidTrans;
          IBidBurst   <= WBidBurst;
          IBidWrite   <= WBidWrite ;
          IBidResp    <= WBidResp ;
          IBidNumcyc  <= WBidNumcyc;
          IBidLimit   <= WBidLimit;
          IBidMasnum  <= WBidMasnum;
          IBidMaslock <= WBidMaslock;
          IBidIdlcyc  <= WBidIdlcyc;
          IBidRslimit <= WBidRslimit;
          IBidSuppmsg <= WBidSuppmsg;
          IBidTag     <= WBidTag;
          IBidCycSel  <= WBCycSel;
        end
      else
        begin
          IBidCycSel <= `T_CYCLE_C_IDLE;
        end
      if (ResStored == 1'b1) 
        begin
          IResPhase  <= WResPhase;
          IResDelay  <= WResDelay;
          IResNumcyc <= WResNumcyc;
          IRCycSel   <= WRCycSel;
        end
      for (VRIndex2 = 0; VRIndex2 < 8; VRIndex2 = VRIndex2 + 1)
      begin
        if (VRStored[VRIndex2] === 1'b1)
          begin
            IVRVregno[VRIndex2] <= WVRVregno[VRIndex2];
            IVRData[VRIndex2]   <= WVRData[VRIndex2];
            IVRMask[VRIndex2]   <= WVRMask[VRIndex2];
            IVRExp[VRIndex2]    <= WVRExp[VRIndex2];
            IVRWrite[VRIndex2]  <= WVRWrite[VRIndex2];
            IVRPhase[VRIndex2]  <= WVRPhase[VRIndex2];
            IVREdge[VRIndex2]   <= WVREdge[VRIndex2];
            IVRDelay[VRIndex2]  <= WVRDelay[VRIndex2];
            IVRTag[VRIndex2]    <= WVRTag[VRIndex2];
            IVRCycSel[VRIndex2] <= WVCycSel[VRIndex2];
          end
      end
      if (EndianStored == 1'b1) 
        begin
          IEnEndian       <= WEnEndian;
          IEnCycSel       <= WEnCycSel;
        end

      if (SplitStored == 1'b1) 
        begin
          ISpExpmas    <= WSpExpmas;
          ISpNumcyc0   <= WSpNumcyc0;
          ISpNumcyc1   <= WSpNumcyc1;
          ISpNumcyc2   <= WSpNumcyc2;
          ISpNumcyc3   <= WSpNumcyc3;
          ISpNumcyc4   <= WSpNumcyc4;
          ISpNumcyc5   <= WSpNumcyc5;
          ISpNumcyc6   <= WSpNumcyc6;
          ISpNumcyc7   <= WSpNumcyc7;
          ISpNumcyc8   <= WSpNumcyc8;
          ISpNumcyc9   <= WSpNumcyc9;
          ISpNumcyc10  <= WSpNumcyc10;
          ISpNumcyc11  <= WSpNumcyc11;
          ISpNumcyc10  <= WSpNumcyc12;
          ISpNumcyc10  <= WSpNumcyc13;
          ISpNumcyc10  <= WSpNumcyc14;
          ISpNumcyc10  <= WSpNumcyc15;
          ISpLimit     <= WSpLimit;
          ISpCycSel    <= WSpCycSel;
        end
    end
  else if (HCLK == 1'b1) 
    begin
      IBidCycSel  <= `T_CYCLE_C_IDLE;
      IRCycSel    <= `T_CYCLE_C_IDLE;
      IEnCycSel   <= `T_CYCLE_C_IDLE;
      ISpCycSel   <= `T_CYCLE_C_IDLE;
      for (VRIndex2 = 0; VRIndex2 < 8; VRIndex2 = VRIndex2 + 1)
        IVRCycSel[VRIndex2] <= `T_CYCLE_C_IDLE;
    end
end // p_drive;

always @(HCLK)
begin
  if (HCLK == 1'b0)
  begin
    if (ResStored == 1'b0)
      IRCycSel <= `T_CYCLE_C_IDLE;
    for (VRIndex2 = 0; VRIndex2 < 8; VRIndex2 = VRIndex2 + 1)
      begin
        if (VRStored[VRIndex2] === 1'b0)
            IVRCycSel[VRIndex2] <= `T_CYCLE_C_IDLE;
       end
    if (EndianStored == 1'b0)
          IEnCycSel <= `T_CYCLE_C_IDLE;
 
      if (SplitStored == 1'b0)
          ISpCycSel <= `T_CYCLE_C_IDLE;
  end
end
// -----------------------------------------------------------------------------
// Simulation completion when test ends
// -----------------------------------------------------------------------------
always
begin : p_finish
  wait (TestEnd);
  wait (SimEnd);
  #Tclk;  //  Wait for one clock period
  // $display("End of Test");
  // $finish;
end   // p_finish

// -----------------------------------------------------------------------------
// Hand coding of VHDL initialisation values
// -----------------------------------------------------------------------------
initial
begin

  VBidAddr    = 32'd0;
  VBidData    = 64'd0;
  VBidMask    = 64'd0;
  VBidExp     = 64'd0;
  VBidSize    = 3'b000;
  VBidProt    = 4'b0000;
  VBidTrans   = 2'b00;
  VBidBurst   = 3'b000;
  VBidWrite   = 1'b0;
  VBidResp    = 2'b00;
  VBidNumcyc  = 8'b00000000;
  VBidLimit   = 32'h00000000;
  VBidMasnum  = 4'b0000;
  VBidMaslock = 1'b0;
  VBidIdlcyc  = 32'h00000000;
  VBidRslimit = 32'h00000000;
  VBidSuppmsg = 1'b0;
 
  VVRVregno   = 24'h000000;
  VVRData     = 256'd0;
  VVRMask     = 256'd0;
  VVRExp      = 256'd0;
  VVRWrite    = 8'h00;
  VVRPhase    = 8'h00;
  VVREdge     = 8'h00;
  VVRDelay    = 8'h00;

  VRStored    = 8'b00000000;
  BVRVregno   = 24'h000000;
  BVRData     = 256'd0;
  BVRMask     = 256'd0;
  BVRExp      = 256'd0;
  BVRWrite    = 8'h00;
  BVRPhase    = 8'h00;
  BVREdge     = 8'h00;
  BVRDelay    = 64'h0000000000000000;
 
  for (VRIndex2 = 0; VRIndex2 < 8; VRIndex2 = VRIndex2 + 1)
  begin
            WVRVregno[VRIndex2] = 3'b000; 
            WVRData[VRIndex2]   = 32'd0; 
            WVRMask[VRIndex2]   = 32'd0; 
            WVRExp[VRIndex2]    = 32'd0;
            WVRWrite[VRIndex2]  = 1'b0; 
            WVRPhase[VRIndex2]  = 1'b0; 
            WVREdge[VRIndex2]   = 1'b0;
            WVRDelay[VRIndex2]  = 8'd0;
            WVRTag[VRIndex2]    = 160'd0; 
            WVCycSel[VRIndex2]  = 3'b000; 
  end

  for (VRIndex2 = 0; VRIndex2 < 8; VRIndex2 = VRIndex2 + 1)
  begin
            IVRVregno[VRIndex2] = 3'b000; 
            IVRData[VRIndex2]   = 32'd0; 
            IVRMask[VRIndex2]   = 32'd0; 
            IVRExp[VRIndex2]    = 32'd0;
            IVRWrite[VRIndex2]  = 1'b0; 
            IVRPhase[VRIndex2]  = 1'b0; 
            IVREdge[VRIndex2]   = 1'b0;
            IVRDelay[VRIndex2]  = 8'd0;
            IVRTag[VRIndex2]    = 160'd0; 
            IVRCycSel[VRIndex2] = 3'b000; 
  end
  VEnEndian    = 2'b00;
  VSpExpmas    = 4'b0000;
  VSpNumcyc0   = 8'h00;
  VSpNumcyc1   = 8'h00;
  VSpNumcyc2   = 8'h00;
  VSpNumcyc3   = 8'h00;
  VSpNumcyc4   = 8'h00;
  VSpNumcyc5   = 8'h00;
  VSpNumcyc6   = 8'h00;
  VSpNumcyc7   = 8'h00;
  VSpNumcyc8   = 8'h00;
  VSpNumcyc9   = 8'h00;
  VSpNumcyc10  = 8'h00;
  VSpNumcyc11  = 8'h00;
  VSpNumcyc12  = 8'h00;
  VSpNumcyc13  = 8'h00;
  VSpNumcyc14  = 8'h00;
  VSpNumcyc15  = 8'h00;
  VSpLimit     = 8'h00;

  VResPhase   = 1'b0;
  VResDelay   = 8'h00;
  VResNumcyc  = 8'h00;

  BBidAddr    = 32'd0;
  BBidData    = 64'd0;
  BBidMask    = 64'd0;
  BBidExp     = 64'd0;
  BBidSize    = 3'b000;
  BBidProt    = 4'b0000;
  BBidTrans   = 2'b00;
  BBidBurst   = 3'b000;
  BBidWrite   = 1'b0;
  BBidResp    = 2'b00;
  BBidNumcyc  = 8'b00000000;
  BBidLimit   = 32'h00000000;
  BBidMasnum  = 4'b0000;
  BBidMaslock = 1'b0;
  BBidIdlcyc  = 32'h00000000;
  BBidRslimit = 32'h00000000;
  BBidSuppmsg = 1'b0;

  IBidAddr    = 32'd0;
  IBidData    = 64'd0;
  IBidMask    = 64'd0;
  IBidExp     = 64'd0;
  IBidSize    = 3'b000;
  IBidProt    = 4'b0000;
  IBidTrans   = 2'b00;
  IBidBurst   = 3'b000;
  IBidWrite   = 1'b0;
  IBidResp    = 2'b00;
  IBidNumcyc  = 8'b00000000;
  IBidLimit   = 32'h00000000;
  IBidMasnum  = 4'b0000;
  IBidMaslock = 1'b0;
  IBidIdlcyc  = 32'h00000000;
  IBidRslimit = 32'h00000000;
  IBidSuppmsg = 1'b0;

  BVCycSel    = 4'b0000;
  BVRVregno   = 24'h000000;
  BVRData     = 256'd0;
  BVRMask     = 256'd0;
  BVRExp      = 256'd0;
  BVRWrite    = 8'h00;
  BVRPhase    = 8'h00;
  BVREdge     = 8'h00;
  BVRDelay    = 64'h0000000000000000;

  WRCycSel   <= 4'b0000; 
  WResPhase  <= 1'b0;
  WResDelay  <= 8'h00;
  WResNumcyc <= 8'h00; 
end
endmodule

// ================================== End =================================== --
