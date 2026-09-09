// --=================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from ARM Limited
//   (C) COPYRIGHT 2000 ARM Limited
//       ALL RIGHTS RESERVED
// The entire notice above must be reproduced on all authorised
// copies and copies may only be made to the extent permitted
// by a licensing agreement from ARM Limited.
//
// ---------------------------------------------------------------------
// Version and Release Control Information:
//
// File Name              : cyc_drivers.v.rca
// File Revision          : 1.1
//
// Release Information    : PrimeCell(TM)-GLOBAL-REL1v3
//
// ---------------------------------------------------------------------
// Purpose :
//           Drives AHB address, data and control signals 
//
// --=================================================================--

`timescale 1ns/1ps
`include "../common/defs.v"
`include "../tbench/timing.v"

// ---------------------------------------------------------------------

module cyc_drivers (
                    HCLK,           
                    HRESETn,       
                    HADDR,        
                    HTRANS,      
                    HWRITE,     
                    HSIZE,     
                    HBURST,   
                    HPROT,   
                    HWDATA, 
                    HMASTER,                         
                    HMASTLOCK,     
                    HRDATA,       
                    HREADY,      
                    HRESP,                       
                    DelHWRITE, 
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
                    BidTimeout,
                    BidSuppmsg,
                    BidTag,
                    BidGetLine,     
                    Endiansel,
                    VEnEndian,     
                    TogEndian,   
                    Cycsel,     
                    CycCount,  
                    Simend  
                   );

  parameter
    Verbosity       = 0,             // Enables messages
    HaltOnMismatch  = 0,             // Enables termination on mismatch
    XonSig          = 1,             // Drives X's in default state if
                                     // enabled
    TestMode        = 0,             // Enables running BigEndian Mode
                                     // Tests   
    Databuswidth    = 64;            // AHB buswidth


input          HCLK;           // AHB Clock Signal
input          HRESETn;        // AHB Reset Signal
input  [63:0]  HRDATA;         // AHB Read Data Bus
input          HREADY;         // AHB HREADY signal
input  [1:0]   HRESP;          // AHB Response signal
output         DelHWRITE;      // HWRITE for previour transfer
input  [31:0]  BidAddr;        // Address information in the packet
input  [63:0]  BidData;        // Data information in the packet
input  [63:0]  BidMask;        // Data Mask information in the packet
input  [63:0]  BidExp;         //  Expected data information in the
                               // packet
input  [2:0]   BidSize;        // Transfer size information in the
                               // packet
input  [3:0]   BidProt;        // HPROT information in the packet
input  [1:0]   BidTrans;       // TRANS type information in the packet
input  [2:0]   BidBurst;       // Burst information in the packet
input          BidWrite;       // Write information in the packet
input  [1:0]   BidResp;        // Expected response info. in the packet
input  [7:0]   BidNumcyc;      // Numcycle information in the packet
input  [31:0]  BidLimit;       // Clock cycle limit info. in the packet
input  [3:0]   BidMasnum;      // Master information in the packet
input          BidMaslock;     // Master lock informattion in the packet
input  [31:0]  BidIdlcyc;      // No. of idle cycles to be inserted
input  [31:0]  BidRslimit;     // Retry/Split reissue limit info. in
                               // the packet
input  [31:0]  BidTimeout;     // Poll Time out information in the
                               // packet
input          BidSuppmsg;     // Suppress msg. information in the
                               // packet
input  [159:0] BidTag;         // Tag informaiormation in the packet
output         BidGetLine;     // Request for new packet
input   [3:0]  Endiansel;      // Endianness cycle
input   [1:0]  VEnEndian;      // Endianness information in packet
output  [1:0]  TogEndian;      // Toggle endiannes
input   [3:0]  Cycsel;         // Command cycle type
output  [31:0] HADDR;          // AHB  Address Bus
output  [1:0]  HTRANS;         // AHB Transfer Mode
output         HWRITE;         // AHB Read/Write Signal
output  [2:0]  HSIZE;          // AHB Data Transfer Size
output  [2:0]  HBURST;         // AHB Burst type
output  [3:0]  HPROT;          // AHB HPROT signal
output  [63:0] HWDATA;         // AHB Write Data Bus
output  [3:0]  HMASTER;        // AHB MASTER driving the Bus
output         HMASTLOCK;      // Slave locked by Master
output  [7:0]  CycCount;       // indicates 'current-cycle-number' of
                               // transfer
output         Simend;         //End of simulation
// ---------------------------------------------------------------------
//
//                              cyc_drivers
//                              ===========
//
// ---------------------------------------------------------------------
//
// Overview
// ========
//   This module drives out all the address and control signals of AHB.
// The function of this module can be classified into two. These are
// as follows :-
// o Issuing get_line requests to the reader module.
//   Whenever a new packet is driven, the num_cyc value of the packet
//   is loaded on a down_counter, which counts with every clock. When
//   value of the down_counter reaches 1, then a get_line request is
//   issued, otherwise it stays in Gidle state.
// o Driving the data, address and control signals.
//   These are also driven on basis of the down_counter mentioned above.
//   When count reaches 1, it indicates that at the end of this count,
//   the signals are to be driven.
//  Note :- If the user needs a simulation period of more than 1 second,
//  then the time format has  to be increased.
//
// ---------------------------------------------------------------------

// ---------------------------------------------------------------------
// Constant declarations
// ---------------------------------------------------------------------
`define ZERO [63:0] = 64'h0000000000000000;

// ---------------------------------------------------------------------
// Signal declarations
// ---------------------------------------------------------------------

reg  [7:0]    Val;
// Value loaded into downcounter

wire [7:0]    Last;
// Denotes end of current transfer

wire  [31:0]  BidAddr;     
// Address information in the packet

wire  [63:0]  BidData;     
// Data information in the packet

wire  [63:0]  BidMask;     
// Data Mask information in the packet

wire  [63:0]  BidExp;      
//  Expected data information in the packet

wire  [2:0]   BidSize;     
// Transfer size information in the packet

wire  [3:0]   BidProt;     
// HPROT information in the packet

wire  [1:0]   BidTrans;    
// TRANS type information in the packet

wire  [2:0]   BidBurst;    
// Burst information in the packet

wire          BidWrite;    
// Write information in the packet

wire  [1:0]   BidResp;     
// Expected response info. in the packet

wire  [7:0]   BidNumcyc;   
// Numcycle information in the packet

wire  [31:0]  BidLimit;    
// Clock cycle limit info. in the packet

wire  [3:0]   BidMasnum;   
// Master information in the packet

wire          BidMaslock;  
// Master lock informattion in the packet

wire  [31:0]  BidIdlcyc;   
// No. of idle cycles to be inserted

wire  [31:0]  BidRslimit;  
// Retry/Split reissue limit info. in the packet

wire  [31:0]  BidTimeout;
// Poll time out info. in the packet

wire          BidSuppmsg;  
// Suppress msg. information in the packet

wire  [159:0] BidTag;      
// Tag informaiormation in the packet

reg  [31:0]   HADDR;          
// AHB  Address Bus

reg  [1:0]    HTRANS;         
// AHB Transfer Mode

reg           HWRITE;         
// AHB Read/Write Signal

reg  [2:0]    HSIZE;          
// AHB Data Transfer Size

reg  [2:0]    HBURST;         
// AHB Burst type

reg  [3:0]    HPROT;          
// AHB HPROT signal

reg  [63:0]   HWDATA;         
// AHB Write Data Bus

reg  [3:0]    HMASTER;        
// AHB MASTER driving the Bus

reg           HMASTLOCK;      
// Slave locked by Master

// Buffered   bidpacket
reg  [31:0]   BufbidAddr;
// Address information in the packet
 
reg  [63:0]   BufbidData;
// Data information in the packet
 
reg  [63:0]   BufbidMask;
// Data Mask information in the packet
 
reg  [63:0]   BufbidExp;      
//  Expected data information in the packet
 
reg  [2:0]    BufbidSize;     
// Transfer size information in the packet
 
reg  [3:0]    BufbidProt;     
// HPROT information in the packet
 
reg  [1:0]    BufbidTrans;    
// TRANS type information in the packet
 
reg  [2:0]    BufbidBurst;    
// Burst information in the packet
 
reg           BufbidWrite;    
// Write information in the packet
 
reg  [1:0]    BufbidResp;     
// Expected response info. in the packet
 
reg  [7:0]    BufbidNumcyc;   
// Numcycle information in the packet
 
reg  [31:0]   BufbidLimit;    
// Clock cycle limit info. in the packet
 
reg  [3:0]    BufbidMasnum;
// Master information in the packet
 
reg           BufbidMaslock;
// Master lock informattion in the packet
 
reg  [31:0]   BufbidIdlcyc;
// No. of idle cycles to be inserted
 
reg  [31:0]   BufbidRslimit;
// Retry/Split reissue limit info. in the packet
 
reg  [31:0]   BufbidTimeout;
// Poll time out info. in the packet

reg           BufbidSuppmsg;
// Suppress msg. information in the packet
 
reg  [159:0]  BufbidTag;
// Tag informaiormation in the packet
 

// Bidpacket driven in the penultimate transfer
reg  [31:0]   Buf2bidAddr;
// Address information in the packet
 
reg  [63:0]   Buf2bidData;
// Data information in the packet
 
reg  [63:0]   Buf2bidMask;
// Data Mask information in the packet
 
reg  [63:0]   Buf2bidExp;      
//  Expected data information in the packet
 
reg  [2:0]    Buf2bidSize;     
// Transfer size information in the packet
 
reg  [3:0]    Buf2bidProt;     
// HPROT information in the packet
 
reg  [1:0]    Buf2bidTrans;    
// TRANS type information in the packet
 
reg  [2:0]    Buf2bidBurst;    
// Burst information in the packet
 
reg           Buf2bidWrite;    
// Write information in the packet
 
reg  [1:0]    Buf2bidResp;     
// Expected response info. in the packet
 
reg  [7:0]    Buf2bidNumcyc;   
// Numcycle information in the packet
 
reg  [31:0]   Buf2bidLimit;    
// Clock cycle limit info. in the packet
 
reg  [3:0]    Buf2bidMasnum;
// Master information in the packet
 
reg           Buf2bidMaslock;
// Master lock informattion in the packet
 
reg  [31:0]   Buf2bidIdlcyc;
// No. of idle cycles to be inserted
 
reg  [31:0]   Buf2bidRslimit;
// Retry/Split reissue limit info. in the packet
 
reg  [31:0]   Buf2bidTimeout;
// Poll time out info. in the packet

reg           Buf2bidSuppmsg;
// Suppress msg. information in the packet
 
reg  [159:0]  Buf2bidTag;
// Tag informaiormation in the packet
 
// Bidpacket driven in Retry/Split cycle
reg  [31:0]   RsbidAddr;
// Address information in the packet
 
reg  [63:0]   RsbidData;
// Data information in the packet
 
reg  [63:0]   RsbidMask;
// Data Mask information in the packet
 
reg  [63:0]   RsbidExp;      
//  Expected data information in the packet
 
reg  [2:0]    RsbidSize;     
// Transfer size information in the packet
 
reg  [3:0]    RsbidProt;     
// HPROT information in the packet
 
reg  [1:0]    RsbidTrans;    
// TRANS type information in the packet
 
reg  [2:0]    RsbidBurst;    
// Burst information in the packet
 
reg           RsbidWrite;    
// Write information in the packet
 
reg  [1:0]    RsbidResp;     
// Expected response info. in the packet
 
reg  [7:0]    RsbidNumcyc;   
// Numcycle information in the packet
 
reg  [31:0]   RsbidLimit;    
// Clock cycle limit info. in the packet
 
reg  [3:0]    RsbidMasnum;
// Master information in the packet
 
reg           RsbidMaslock;
// Master lock informattion in the packet
 
reg  [31:0]   RsbidIdlcyc;
// No. of idle cycles to be inserted
 
reg  [31:0]   RsbidRslimit;
// Retry/Split reissue limit info. in the packet
 
reg           RsbidSuppmsg;
// Suppress msg. information in the packet
 
reg  [159:0]  RsbidTag;
// Tag informaiormation in the packet
// Bidpacket driven after a Retry/Split cycle

reg  [31:0]   RsnextAddr;
// Address information in the packet
 
reg  [63:0]   RsnextData;
// Data information in the packet
 
reg  [63:0]   RsnextMask;
// Data Mask information in the packet
 
reg  [63:0]   RsnextExp;      
//  Expected data information in the packet
 
reg  [2:0]    RsnextSize;     
// Transfer size information in the packet
 
reg  [3:0]    RsnextProt;     
// HPROT information in the packet
 
reg  [1:0]    RsnextTrans;    
// TRANS type information in the packet
 
reg  [2:0]    RsnextBurst;    
// Burst information in the packet
 
reg           RsnextWrite;    
// Write information in the packet
 
reg  [1:0]    RsnextResp;     
// Expected response info. in the packet
 
reg  [7:0]    RsnextNumcyc;   
// Numcycle information in the packet
 
reg  [31:0]   RsnextLimit;    
// Clock cycle limit info. in the packet
 
reg  [3:0]    RsnextMasnum;
// Master information in the packet
 
reg           RsnextMaslock;
// Master lock informattion in the packet
 
reg  [31:0]   RsnextIdlcyc;
// No. of idle cycles to be inserted
 
reg  [31:0]   RsnextRslimit;
// Retry/Split reissue limit info. in the packet
 
reg  [31:0]   RsnextTimeout;
// Retry/Split reissue limit info. in the packet

reg           RsnextSuppmsg;
// Suppress msg. information in the packet
 
reg  [159:0]  RsnextTag;
// Tag informaiormation in the packet
 
reg           BidGetLine; 
// Internal request signal for new packet

reg           DelHWRITE;
// Delayed HWRITE signal

reg   [2:0]   DelHBURST;
// Delayed HBURST signal
 
 wire [31:0]  DefHADDR;
// Default Address bus

wire          DefHWRITE;
// Default HWRITE signal

wire  [1:0]   DefHTRANS;
// Default HTRANS signal

wire  [2:0]   DefHBURST;
// Default HBURST signal

wire  [63:0]  DefHWDATA;
// Default Write data bus

wire  [2:0]   DefHSIZE;
// Default HSIZE signal

wire  [3:0]   DefHPROT;
// Default HPROT signal

wire  [3:0]   DefHMASTER;
// Default HMASTER signal

wire          DefHMASTLOCK;
// Default HMASTLOCK signal

reg [2:0]     DelHSIZE;
// Delayed HSIZE signal

reg           DelHTRANS;
// Delayed HTRANS signal

reg [1:0]     Expresp;
// Expected response generated by testbench

reg [4:0]     Beatcount;
// Beat Counter

reg           Newtran;
// Denotes a new transfer

integer       Count; 
// Numcycle 0 Counter 

reg           Maxflag;
// Denotes limit for number of re-issues of a command has reached

reg           Maxflagpoll; 
// Denotes limit for number of re-issues of a poll command has reached

reg           delflagpoll;
// Delayed version of Maxflagpoll  

reg           Nextissue;
// Indicates start of a transfer

reg           Resplit;
// Denotes Retry/Split transfer

reg           DelResplit;
// Denotes Retry/Split transfer

reg           Rsidle;
// Denotes Idle cycle transfer in progress after Split/Retry

reg           Pidle;
// Denotes Idle cycle transfer in progress after Poll

reg           Idleflag;
// Denotes limit  for number of re-issues of an idle  command has
// reached

integer       Idlecount;
// Indicates number of idle cycles to be inserted

reg           Idledone;
// Indicates end of idle cycle transfer in SPLIT/Retry transfer

reg           Rsflag;
// Indicates Retry/Split transfer reissue limit has reached

integer       Rscount;
// Reissue counter value in Split/Retry

reg           Rsdone;
// Retry/Split transfer over

reg           Rslast;
// Last transfer in SPLIT/RETRY

reg           Resetover;
// Denotes first reset is over

reg           Resetstrd; 
// Reset Status

wire          Rscyc;
// Retry/SPlit cycle

reg           Oners;
// Non-reissueable Split/Retry

reg           DelOners;
// Non-reissueable Split/Retry

reg [31:0]     WSCount;
// Wait state counter 

reg [7:0]     CycCount;
// No of clock cycles elapsed after thepresent transfer has started 

wire [31:0]   Limit;
// Denotes limit of reissue of a command

wire [31:0]   Limitrs;
// Denotes limit of reissue of a command in Split/Retry

reg [2:0]     Writeaddr;
// intermediate signal used for getting properly "endianized" data
// from packet

reg [63:0]    ExpData;
// Actual expected data depending on endianness

reg [63:0]    ActMask;
// Writing data on appropriate lines

reg [63:0]    Mask;
// Mask bits in any transfer 
 
reg [63:0]    ReadMask;
// Actual mask in read cycle 

reg [1:0]     iHTRANS;
// Internal HTRANS signal

reg [63:0]    iHWDATA;
// Internal   HWDATA BUS
 
//reg [63:0]  endnizedata;
// Endianized Data 

reg [2:0]     ByteLaneDecidr;
// Internal signal for Endianizing data

reg [63:0]    iExpData;
// Internal Expected Read  DATA BUS

reg [63:0]    WriteData;
// Internal Expected Read  DATA BUS

reg [1:0]     TogEndian;
//Toggles Endianness of the testbench

reg           Pollstart;
// Indicates that the poll has started

reg           delrsdone;
// Delayed version of Rsdone signal
 
reg           blockidle ;
// Indicates that the poll transfer is in progress
 
reg           delblockidle;
// Delayed version of blockidle

reg           del1blockidle;
// Delayed version of delblockidle

reg           Pollstartctl;
// Control signal used to generate pollstart signal

reg           delPollstart;
// Delayed version of Pollstart signal

reg           del1Pollstart;
// Delayed version of delPollstart signal

reg           Pollend;
// Indicates the end of poll command

reg [31:0]    pocount;        
// Poll counter

reg [31:0]    nextcount;     
// Combination logic for poll counter

reg [31:0]    time_out;     
// timeout for poll command

reg           countflag;
// Indicates that the poll command is terminated due to timeout

integer        i;
// For loop variable

// ---------------------------------------------------------------------
//
// Main body of code
// =================
//
// ---------------------------------------------------------------------

// ---------------------------------------------------------------------
// Component declarations
// ---------------------------------------------------------------------
countdown U_countdown (
                       .HCLK(HCLK),
                       .VAL(Val),
                       .LAST(Last),
                       .Rscyc(Rscyc)
                      );

// ---------------------------------------------------------------------
initial
begin
  $timeformat(-9, 0, " ns", 13);
  Val        = 8'b00000000;
  BidGetLine = `T_GET_G_GET;
  iHTRANS    = 2'b00;
  HWRITE     = 1'b0;
  Expresp    = 2'b00;
  Beatcount  = 5'b00000;
  Newtran    = 1'b1;
  Count      = 0;
  Maxflag    = 1'b0;
  Nextissue  = 1'b0;
  Resplit    = 1'b0;
  DelResplit = 1'b0;
  DelOners   = 1'b0;
  Rsidle     = 1'b0;
  Idleflag   = 1'b0;
  Idlecount  = 0;
  Idledone   = 1'b0;
  Rsflag     = 1'b0;
  Rscount    = 1;
  Rsdone     = 1'b0;
  Rslast     = 1'b0;
  Resetover  = 1'b0;
  Pollstart  = 1'b0;
  blockidle  = 1'b1;
  delblockidle = 1'b1;
end
// ---------------------------------------------------------------------
// This block counts cycle-number of the ongoing transfer
// ---------------------------------------------------------------------
always @ (posedge HCLK)
begin : p_counter
  if (Val != 8'b00000000 | HREADY == 1'b1 | Last == 1 | Maxflag)
    CycCount = 0;
  else 
    if (((Last != 1) | (HREADY == 1'b0))  & (CycCount < 255)) 
      CycCount = CycCount + 1;
end // p_counter;
// ---------------------------------------------------------------------
// Assigning Default values to AHB Signals
// ---------------------------------------------------------------------
  assign DefHADDR     = (XonSig) ? 32'hXXXXXXXX : 32'h00000000; 
  
  assign DefHWDATA    = (XonSig) ?
                        64'hXXXXXXXXXXXXXXXX : 64'h0000000000000000;
  
  assign DefHTRANS    = (XonSig) ? 4'bXXXX : 4'b0000;

  assign DefHBURST    = (XonSig) ? 4'hX : 4'h0;

  assign DefHWRITE    = (XonSig) ? 1'bX: 1'b0;
  
  assign DefHSIZE     = (XonSig) ? 4'hX : 4'h0;

  assign DefHPROT     = (XonSig) ? 4'hX : 4'h0;

  assign DefHMASTER   = (XonSig) ? 4'hX : 4'h0;

  assign DefHMASTLOCK = (XonSig) ? 1'bX: 1'b0;

  assign Simend       = Nextissue;

// ---------------------------------------------------------------------
// Retry/Split with no re-issue (when numcyc /= 0 or expected response
// is a Retry or a Split)
// ---------------------------------------------------------------------
  always @ (posedge HCLK or Buf2bidNumcyc or Resplit or Rsidle or
            HRESP or RsbidResp or Oners)
  begin
    if (Rsidle) 
      Oners = 1'b0;
    else
    begin
      if ((Buf2bidNumcyc != 0  & Resplit == 1'b1)
          | (((RsbidResp == 2'b10 &  HRESP == 2'b10) 
          |(RsbidResp == 2'b11 & HRESP == 2'b11)) & 
          Rsidle != 1'b1))
        Oners = 1'b1;
      else
      begin
        if (((RsbidResp != 2'b10 & HRESP == 2'b10) |
            (RsbidResp != 2'b11 & HRESP == 2'b11))
            & Buf2bidNumcyc == 0) 
          Oners = 1'b0;
        else
          Oners = Oners;
      end
    end
  end

// ---------------------------------------------------------------------
// RETRY/SPLIT cycle
// ---------------------------------------------------------------------
  assign Rscyc       = (HRESP == 2'b10 | HRESP == 2'b11) ? 1'b1 : 1'b0;

// ---------------------------------------------------------------------
// HTRANS driven to idle during reset and iHTRANS otherwise
// ---------------------------------------------------------------------
  always @(HRESETn or iHTRANS)
  begin
    if (!HRESETn)
      HTRANS = iHTRANS;
    else
    begin
      if (HRESETn == 1'b0 & (((iHTRANS !== 2'bXX) & XonSig)  | 
                              ((iHTRANS != 2'b00) & !XonSig)))
        HTRANS = 2'b00;
      else
        HTRANS = iHTRANS;
    end
  end
         
// ---------------------------------------------------------------------
// store the Bid that got a retry or a Split response
// ---------------------------------------------------------------------
  always @(HRESP or Resplit or RsbidAddr or RsbidData or
           RsbidMask or RsbidExp or RsbidSize or RsbidProt
           or RsbidTrans or RsbidBurst or RsbidWrite or 
           RsbidResp or RsbidNumcyc or RsbidLimit or    
           RsbidMasnum or RsbidMaslock or RsbidIdlcyc or 
           RsbidRslimit or RsbidSuppmsg or RsbidTag 
           or Buf2bidAddr or Buf2bidData or
           Buf2bidMask or Buf2bidExp or Buf2bidSize or Buf2bidProt
           or Buf2bidTrans or Buf2bidBurst or Buf2bidWrite or
           Buf2bidResp or Buf2bidNumcyc or Buf2bidLimit or
           Buf2bidMasnum or Buf2bidMaslock or Buf2bidIdlcyc or
           Buf2bidRslimit or Buf2bidSuppmsg or Buf2bidTag or
           Pollstart or delPollstart or del1Pollstart or delrsdone )
  begin : p_Rs
    if (((HRESP == 2'b10 | HRESP == 2'b11) & Resplit != 1'b1 & 
          blockidle == 1'b1)  | (del1blockidle == 1'b1 &
          delblockidle == 1'b0) | (delrsdone == 1'b1))
    begin
      RsbidAddr    = Buf2bidAddr;
      RsbidData    = Buf2bidData;
      RsbidMask    = Buf2bidMask;
      RsbidExp     = Buf2bidExp;
      RsbidSize    = Buf2bidSize;
      RsbidProt    = Buf2bidProt;
      RsbidTrans   = Buf2bidTrans;
      RsbidBurst   = Buf2bidBurst;
      RsbidWrite   = Buf2bidWrite ;
      RsbidResp    = Buf2bidResp ;
      RsbidNumcyc  = Buf2bidNumcyc;
      RsbidLimit   = Buf2bidLimit;
      RsbidMasnum  = Buf2bidMasnum;
      RsbidMaslock = Buf2bidMaslock;
      RsbidIdlcyc  = Buf2bidIdlcyc;
      RsbidRslimit = Buf2bidRslimit;
      RsbidSuppmsg = Buf2bidSuppmsg;
      RsbidTag     = Buf2bidTag;
    end
    else
    begin
      RsbidAddr    = RsbidAddr;
      RsbidData    = RsbidData;
      RsbidMask    = RsbidMask;
      RsbidExp     = RsbidExp;
      RsbidSize    = RsbidSize;
      RsbidProt    = RsbidProt;
      RsbidTrans   = RsbidTrans;
      RsbidBurst   = RsbidBurst;
      RsbidWrite   = RsbidWrite ;
      RsbidResp    = RsbidResp ;
      RsbidNumcyc  = RsbidNumcyc;
      RsbidLimit   = RsbidLimit;
      RsbidMasnum  = RsbidMasnum;
      RsbidMaslock = RsbidMaslock;
      RsbidIdlcyc  = RsbidIdlcyc;
      RsbidRslimit = RsbidRslimit;
      RsbidSuppmsg = RsbidSuppmsg;
      RsbidTag     = RsbidTag;
    end
  end  // p_Rs

  // store the next command's Bidpacket when a Retry or Split response
  // is got
  always @(HRESP or Resplit or RsnextAddr or RsnextData or
           RsnextMask or RsnextExp or RsnextSize or 
           RsnextProt or RsnextTrans or RsnextBurst or 
           RsnextWrite or RsnextResp or RsnextNumcyc or 
           RsnextLimit or RsnextMasnum or RsnextMaslock or 
           RsnextIdlcyc or RsnextRslimit or RsnextSuppmsg 
           or RsnextTag 
           or BufbidAddr or BufbidData or Pollstart or
           BufbidMask or BufbidExp or BufbidSize or BufbidProt
           or BufbidTrans or BufbidBurst or BufbidWrite or
           BufbidResp or BufbidNumcyc or BufbidLimit or
           BufbidMasnum or BufbidMaslock or BufbidIdlcyc or
           BufbidTimeout or BufbidRslimit or BufbidSuppmsg or BufbidTag)
  begin : p_Rsnext
    if (((HRESP == 2'b10 | HRESP == 2'b11) & Resplit != 1'b1) || 
          Pollstart == 1'b1 )
    begin
      RsnextAddr    = BufbidAddr;
      RsnextData    = BufbidData;
      RsnextMask    = BufbidMask;
      RsnextExp     = BufbidExp;
      RsnextSize    = BufbidSize;
      RsnextProt    = BufbidProt;
      RsnextTrans   = BufbidTrans;
      RsnextBurst   = BufbidBurst;
      RsnextWrite   = BufbidWrite ;
      RsnextResp    = BufbidResp ;
      RsnextNumcyc  = BufbidNumcyc;
      RsnextLimit   = BufbidLimit;
      RsnextMasnum  = BufbidMasnum;
      RsnextMaslock = BufbidMaslock;
      RsnextIdlcyc  = BufbidIdlcyc;
      RsnextRslimit = BufbidRslimit;
      RsnextTimeout = BufbidTimeout;
      RsnextSuppmsg = BufbidSuppmsg;
      RsnextTag     = BufbidTag;
    end
    else
    begin
      RsnextAddr    = RsnextAddr;
      RsnextData    = RsnextData;
      RsnextMask    = RsnextMask;
      RsnextExp     = RsnextExp;
      RsnextSize    = RsnextSize;
      RsnextProt    = RsnextProt;
      RsnextTrans   = RsnextTrans;
      RsnextBurst   = RsnextBurst;
      RsnextWrite   = RsnextWrite ;
      RsnextResp    = RsnextResp ;
      RsnextNumcyc  = RsnextNumcyc;
      RsnextLimit   = RsnextLimit;
      RsnextMasnum  = RsnextMasnum;
      RsnextMaslock = RsnextMaslock;
      RsnextIdlcyc  = RsnextIdlcyc;
      RsnextRslimit = RsnextRslimit;
      RsnextTimeout = RsnextTimeout;
      RsnextSuppmsg = RsnextSuppmsg;
      RsnextTag     = RsnextTag;

    end
  end  // p_Rsnext

// ---------------------------------------------------------------------
// indicate the end of an issued numcyc == 0 command
// ---------------------------------------------------------------------
always @(posedge HCLK)
begin
  if (Maxflag == 1'b1 & HRESP != 2'b10 & HRESP != 2'b11 &
      Pollstart == 1'b0)
    Newtran <= 1'b1;
  else if(Pollstart == 1'b0 & ((Resplit != 1'b1 & (!(Rsflag) |
          (HRESP == 2'b00 |
        HRESP == 2'b01)))) | (Resplit == 1'b1 & BufbidNumcyc > 0))
    Newtran <= HREADY;
end

always @(Pollstart or Pollend)
begin : p_Newtran
  if (Pollstart == 1'b1 & Pollend != 1'b1)
    Newtran <= 1'b0;  
  else if (Pollstart == 1'b0 & Pollend == 1'b1)
    Newtran <= 1'b1;
  else
    Newtran <= Newtran;
end // p_Newtran

// ---------------------------------------------------------------------
// Delayed version of the HWRITE signal status during the address phase
// to be used at the end of the data phase
// ---------------------------------------------------------------------
always @(posedge HCLK)
begin : p_DelHWRITE
  if (HWRITE == 1'b0 & (Last == 1 | (HREADY == 1'b1) | Maxflag))
    DelHWRITE <= 1'b0;
  else
    if (HWRITE == 1'b1 & (Last == 1 | (HREADY == 1'b1 | Maxflag))) 
      DelHWRITE <= 1'b1;
end // p_DelHWRITE

// ---------------------------------------------------------------------
// Delayed version of the HSIZE signal during address phase to be used 
// at the end of data phase
// ---------------------------------------------------------------------
always @(posedge HCLK)
begin : p_DelHSIZE
  if ((Last == 1 | (HREADY == 1'b1 | Maxflag)))
    DelHSIZE <= HSIZE;
end // p_DelHSIZE

// ---------------------------------------------------------------------
// Delayed version of the HTRANS signal during address phase to be used
// at the end of data phase
// ---------------------------------------------------------------------
always @(posedge HCLK)
begin : p_DelHTRANS
  if ((Last == 1 | (HREADY == 1'b1 | Maxflag)))
    DelHTRANS <= HTRANS[1];
end // p_DelHTRANS
 
// ---------------------------------------------------------------------
// if the limit parameter in a Bid has the default value of 0, 
// load maximum value of integer
// ---------------------------------------------------------------------
  assign Limit = (Buf2bidLimit != 32'd0) ? Buf2bidLimit : `MAXINT;
                                         // 7FFFFFFF;

// ---------------------------------------------------------------------
// if the limit parameter in a Bidpacket that got a retry/split response
// has the default value of 0, 
// load maximum value of integer
// ---------------------------------------------------------------------
  assign Limitrs = (RsbidRslimit != 32'd0) ? RsbidRslimit : `MAXINT;
                                         //7FFFFFFF;

// ---------------------------------------------------------------------
// Maxflag becomes true when limit for number of re-issues of a command 
// when numcyc == 0
// Set when count exceeds limit in any transfer or in reset or
// idle cycles
// ---------------------------------------------------------------------
always @(Count or Limit or HREADY or HRESP or Limitrs or Resplit or
         Rsidle or Buf2bidTrans or countflag or Pollstart)
begin
  Maxflag = (((Count > Limit - 1) & HREADY == 1'b0 
               & Resplit == 1'b0 & HRESP[1] == 1'b0 &
               Pollstart == 1'b0) | ((Count > (Limitrs - 1)) &
               HREADY == 1'b0 & Resplit == 1'b1) |
               (((Buf2bidTrans == 2'b00 & HREADY == 1'b1
               & Resplit != 1'b1)
               | HRESETn == 1'b0) & (Count > 1))) |
               (Resplit == 1'b1 & Rsidle == 1'b1 & (Count > 1)) |
               (countflag == 1'b0 & Pollstart == 1'b1) ? 
               1'b1 : 1'b0;
end

// ---------------------------------------------------------------------
// Maxflag becomes true when limit for number of re-issues of a command
// when numcyc == 0
// Set when count exceeds limit in any transfer or in reset or idle
// cycles
// ---------------------------------------------------------------------
always @(Count or Limit or HREADY or HRESP or Limitrs or Resplit or
         Rsidle or Buf2bidTrans or Pollend or Pollstart)
begin
  if  ((Count > Limit - 1) & HREADY == 1'b0
        & Resplit == 1'b0 & HRESP[1] == 1'b0 & 
        Pollstart == 1'b1 & Pollend == 1'b0)  
    Maxflagpoll <= 1'b1;
  else if (Pollend == 1'b1)
    Maxflagpoll <= 1'b0; 
  else 
    Maxflagpoll <= Maxflagpoll;  
end

// ---------------------------------------------------------------------
// Signal to indicate the start of a new transfer
// ---------------------------------------------------------------------
always @(Last or HREADY or HRESP or Buf2bidNumcyc or Maxflag or
         Buf2bidTrans or HRESETn)
begin
   Nextissue = (((Last == 1 | HREADY == 1'b1 | (HREADY == 1'b0 &
               (HRESP == 2'b10 | HRESP == 2'b11))) &
               Buf2bidNumcyc != 0) |
               ((Maxflag | HREADY == 1'b1 | (HREADY == 1'b0 &
               (HRESP == 2'b10 | HRESP == 2'b11))) &
               ((Last <= 1 & Buf2bidNumcyc == 0) |
               (Buf2bidTrans == 2'b00 & HREADY == 1'b1) 
               | (HRESETn == 1'b0)))) ? 1'b1 : 1'b0; 
end

// ---------------------------------------------------------------------
// Signal to indicate that the required number of idle cycles between 
// re-issues of a retry/split transfer have been issued 
// ---------------------------------------------------------------------
always @(Idlecount or RsbidIdlcyc or iHTRANS or HREADY or HRESP)
begin
  Idleflag = (((Idlecount >= (RsbidIdlcyc - 1)) & (RsbidIdlcyc > 1)) |
             ((RsbidIdlcyc == 1 & 
              (((HRESP[1] == 1'b1 & RsnextTrans == 2'b00 ) | 
              (RsnextTrans != 2'b00 & iHTRANS == 2'b00)) &
               Resplit == 1'b1  & HREADY == 1'b1) |
              (Oners == 1'b1 & HREADY == 1'b0)))) 
             ? 1'b1 : 1'b0; 
end

// ---------------------------------------------------------------------
// Signal to indicate that the limit for the number of re-issues of a 
// retried/split transfer is reached
// ---------------------------------------------------------------------
always @(Rscount or Buf2bidRslimit or Oners)
begin
  Rsflag = ((Rscount > (Buf2bidRslimit - 1)) & 
            Buf2bidRslimit != 0) | (Rscount == `MAXINT) |
            Oners == 1'b1     // indicates a non-reissuable  retry/split
            ? 1'b1 : 1'b0;
end

// ---------------------------------------------------------------------
// Indicates the end of a retry/split command
// ---------------------------------------------------------------------
always @(negedge Resplit)
begin
  Rsdone <= 1'b1;
end
always @(posedge HCLK)
begin
  DelResplit <= Resplit;
  DelOners   <= Oners;
  if (Rsdone == 1'b1)
    Rsdone <= 1'b0;
end
// ---------------------------------------------------------------------
// Indicates the last transfer in a retry/split  
// ---------------------------------------------------------------------
always @(posedge Rsdone)
begin
  Rslast <= 1'b1;
end

always @(BidGetLine or HCLK)
begin
  if (BidGetLine ==`T_GET_G_GET) 
    Rslast <= 1'b0;
  else if(HCLK == 1'b0) 
    if (delrsdone == 1'b1 & Pollstart == 1'b1)
      Rslast <= 1'b0;
end
// ---------------------------------------------------------------------
// Assigning the state of Idle cycle transfer 
// ---------------------------------------------------------------------
always @(posedge HCLK)
begin : p_endidle
  if (Idleflag == 1'b1)
    Idledone = 1'b1;
  else
    Idledone = 1'b0;
end // p_endidle;

// ---------------------------------------------------------------------
// Delayed version of Rsdone signal
// ---------------------------------------------------------------------
always @(posedge HCLK)
begin : p_delrsdone
    delrsdone = Rsdone;
end // p_delrsdone;

// ---------------------------------------------------------------------
// Generation of control signal which indicates that the poll command
// is in progress
// ---------------------------------------------------------------------
always @(HCLK)
begin : p_blk
  if (HCLK == 1'b1)
    begin
      if (Pollstart == 1'b0) 
        blockidle <= 1'b1;
      else
        blockidle <= blockidle; 
    end
  else if (HCLK == 1'b0)
    begin
      if (HREADY == 1'b1 & HRESP == 2'b00 & Rsidle != 1'b1 &
          Pollstart == 1'b1)
        blockidle <= 1'b0; 
      else 
        blockidle <= blockidle;
    end
end // p_blk;

// ---------------------------------------------------------------------
// Delayed version of blockidle signal
// ---------------------------------------------------------------------
always @(negedge HCLK)
begin : p_delblk
    delblockidle <= blockidle;
    del1blockidle <= delblockidle;
end // p_delblk;


// ---------------------------------------------------------------------
// Latching reset status 
// ---------------------------------------------------------------------
// indicate the end of the first reset in the simulation
always @(posedge HCLK or HRESETn)
begin : p_resetstore
  if ((HCLK == 1'b1) & (HRESETn == 1'b0))
    Resetstrd = 1'b1;
  if ((Resetstrd == 1'b1) & (HRESETn == 1'b1))
    Resetover = 1'b1;
end // p_resetstore;

// ---------------------------------------------------------------------
// Generation of delayed  Maxflagpoll signal
// ---------------------------------------------------------------------
// indicate the end of the idle cycles between re-issues of a
// retried/split command
always @ (posedge HCLK or negedge HRESETn)
begin : p_delflagpoll
  if (HRESETn == 1'b0) 
     delflagpoll <= 1'b0;
  else if (Maxflagpoll == 1'b1) 
    delflagpoll <= 1'b1;
 else
    delflagpoll <= 1'b0;
end

// ---------------------------------------------------------------------
// Generation of control signal for Pollstart signal
// ---------------------------------------------------------------------
always @ (posedge HCLK or negedge HRESETn)
begin
  if (HRESETn == 1'b0) 
    Pollstartctl <= 1'b0;
  else if (Cycsel == `T_CYCLE_C_PO) 
    Pollstartctl <= 1'b1;
  else
    Pollstartctl <= 1'b0;
end

// ---------------------------------------------------------------------
// Generation of Pollstart signal
// ---------------------------------------------------------------------
always @ (Pollstartctl or Pollend or countflag)
begin
  if (Pollstartctl == 1'b1)
    Pollstart <= 1'b1;
  else if (Pollend == 1'b1 || countflag == 1'b0)
    Pollstart <= 1'b0;
end 


// ---------------------------------------------------------------------
// Generation of delayed  Pollstart signal
// ---------------------------------------------------------------------
// indicate the end of the idle cycles between re-issues of a
// retried/split command
always @ (posedge HCLK or negedge HRESETn)
begin
  if (HRESETn == 1'b0) 
    begin
      delPollstart <= 1'b0;
      del1Pollstart <= 1'b0;
    end
  else 
    begin
      delPollstart <= Pollstart;
      del1Pollstart <= delPollstart;
    end
end

// ---------------------------------------------------------------------
// Poll Counter
// ---------------------------------------------------------------------
always @ (posedge Pollstart)
begin
                      // Initialise count and countflag at
                      // the start of every command
  pocount <= 32'h00000000;
  countflag <= 1'b1;
end

always @(posedge HCLK)
                      // increment count at every poll
begin
  if (iHTRANS == 2'b00 & HREADY == 1'b1) 
    pocount <= nextcount;
  if ((pocount == (time_out - 1'b1)) & HREADY == 1'b1 & Pidle != 1'b1
     & delblockidle == 1'b0 & HRESP == 2'b00) 
    countflag <= 1'b0;
end

// ---------------------------------------------------------------------
// Time out signal
// ---------------------------------------------------------------------
always @ (negedge HRESETn or posedge HCLK)
begin
  if (HRESETn == 1'b0) 
    time_out <= 32'h00000000;
  else 
          // Initialise time_out
    if (Pollstart == 1'b1 && delPollstart == 1'b0) 
      time_out <= BufbidTimeout;
end

// ---------------------------------------------------------------------
// Control logic for poll counter
// ---------------------------------------------------------------------
always @ (negedge HCLK)
begin
    if ((Pollstart == 1'b1) & (HREADY == 1'b1) & HRESP == 2'b00 & 
         Pidle  != 1'b1 & blockidle == 1'b0) 
            // increment nextcount before a poll
      nextcount <= pocount + 1'b1;
    else
      nextcount <= pocount; 
end

// ---------------------------------------------------------------------
// Loading Numcycle Counter 
// ---------------------------------------------------------------------
always @(HCLK or Rscyc or Rsidle or Rsdone or Last or Rslast or
        Resplit or Rsflag or HREADY or Maxflag or Idledone or
        BufbidNumcyc or Pollstart)
begin : p_loader
  if (Pollstart == 1'b1)
    Val = 8'b00000000; 
  else if (HCLK == 1'b0 & Rslast != 1'b1 & ((Last == 1) |
     ((Maxflag | HREADY == 1'b1) & Last == 0))) 
    Val <= # 1 BufbidNumcyc;
  else
  begin 
    if (HCLK == 1'b0 & Last == 1 & Resplit == 1'b1)
    begin
      if (Idledone)
        Val <= RsbidNumcyc; // re-issue of retried/split transfer
      else   
        Val <= 8'b00000001; // idle cycles between retries/splits 
    end
    else 
    begin
      if (Rslast == 1'b1 & HCLK == 1'b0 & Rsidle == 1'b1) 
        Val <= RsnextNumcyc; // re-issue of command after the 
                                // retried/split command
      else
      begin 
        if (Last == 1 & Rslast == 1'b1 & HREADY == 1'b1 & 
            HCLK == 1'b0 & Rsidle != 1'b1)
          Val <= BufbidNumcyc; 
        else
        begin 
          if (Rsdone == 1'b1 & HCLK == 1'b0 & Rsflag)
            Val <= 8'b00000001; 
                     // end of retried/split command due to Rsflag
                     // being reached
          else
            Val <= 8'b00000000;
        end
      end
    end
  end 
end // p_loader;
 
// ---------------------------------------------------------------------
// Assigning Request for new  and buffering old packets 
// get next command from reader and store Bidpacket in Bufbidpacket and
// Bufbidpacket in Buf2bidpacket
// ---------------------------------------------------------------------
always @(HCLK)
begin : p_bidget
  if (HCLK == 1'b0)
    begin
      if ((Last == 1 & Resplit != 1'b1 & (!(Idledone) & (Oners != 1'b1)
          & (!(Rsflag) | (Rsflag & Rsidle != 1'b1)))) | 
          (Last == 0 & (Newtran == 1'b1 || (Pollstart == 1'b1 & 
           delPollstart == 1'b0)) & ((Oners == 1'b1 & DelOners == 1'b0 
           & Rscyc == 1'b1) | Oners == 1'b0 & Resplit == 1'b0 
           & DelResplit == 1'b0 & !(Resplit == 1'b0 & Rsidle == 1'b1 & 
           !(Rsflag)))))
        BidGetLine    <= `T_GET_G_GET;
    end
  else
    BidGetLine     <= `T_GET_G_IDLE;
end // bidget;


always @(HCLK)
begin : p_lineget
  if (HCLK == 1'b0)
    begin
      if (((Last == 1 & Resplit != 1'b1 & (!(Idledone) & (Oners != 1'b1)
          & (!(Rsflag) | (Rsflag & Rsidle != 1'b1)))) | 
          (Last == 0 & (Newtran == 1'b1 || (Pollstart == 1'b1 & 
           delPollstart == 1'b0) | 
           (delblockidle == 1'b1 & blockidle == 1'b0)) &
           ((Oners == 1'b1 & DelOners == 1'b0 
           & Rscyc == 1'b1) | Oners == 1'b0 & Resplit == 1'b0 
           & DelResplit == 1'b0 & !(Resplit == 1'b0 & Rsidle == 1'b1 & 
           !(Rsflag))))) | (Rslast == 1'b1 & pocount == 32'h00000000 
           & Pollstart == 1'b1))
        begin 
          BufbidAddr    <= BidAddr;
          BufbidData    <= BidData;
          BufbidMask    <= BidMask;
          BufbidExp     <= BidExp;
          BufbidSize    <= BidSize;
          BufbidProt    <= BidProt;
          BufbidTrans   <= BidTrans;
          BufbidBurst   <= BidBurst;
          BufbidWrite   <= BidWrite ;
          BufbidResp    <= BidResp ;
          BufbidNumcyc  <= BidNumcyc;
          BufbidLimit   <= BidLimit;
          BufbidMasnum  <= BidMasnum;
          BufbidMaslock <= BidMaslock;
          BufbidIdlcyc  <= BidIdlcyc;
          BufbidRslimit <= BidRslimit;
          BufbidTimeout <= BidTimeout;
          BufbidSuppmsg <= BidSuppmsg;
          BufbidTag     <= BidTag;

          Buf2bidAddr    <= BufbidAddr;
          Buf2bidData    <= BufbidData;
          Buf2bidMask    <= BufbidMask;
          Buf2bidExp     <= BufbidExp;
          Buf2bidSize    <= BufbidSize;
          Buf2bidProt    <= BufbidProt;
          Buf2bidTrans   <= BufbidTrans;
          Buf2bidBurst   <= BufbidBurst;
          Buf2bidWrite   <= BufbidWrite ;
          Buf2bidResp    <= BufbidResp ;
          Buf2bidNumcyc  <= BufbidNumcyc;
          Buf2bidLimit   <= BufbidLimit;
          Buf2bidMasnum  <= BufbidMasnum;
          Buf2bidMaslock <= BufbidMaslock;
          Buf2bidIdlcyc  <= BufbidIdlcyc;
          Buf2bidRslimit <= BufbidRslimit;
          Buf2bidTimeout <= BufbidTimeout;
          Buf2bidSuppmsg <= BufbidSuppmsg;
          Buf2bidTag     <= BufbidTag;
        end
    end
  else
    begin
      BufbidAddr    <= BufbidAddr;
      BufbidData    <= BufbidData;
      BufbidMask    <= BufbidMask;
      BufbidExp     <= BufbidExp;
      BufbidSize    <= BufbidSize;
      BufbidProt    <= BufbidProt;
      BufbidTrans   <= BufbidTrans;
      BufbidBurst   <= BufbidBurst;
      BufbidWrite   <= BufbidWrite ;
      BufbidResp    <= BufbidResp ;
      BufbidNumcyc  <= BufbidNumcyc;
      BufbidLimit   <= BufbidLimit;
      BufbidMasnum  <= BufbidMasnum;
      BufbidMaslock <= BufbidMaslock;
      BufbidIdlcyc  <= BufbidIdlcyc;
      BufbidRslimit <= BufbidRslimit;
      BufbidTimeout <= BufbidTimeout;
      BufbidSuppmsg <= BufbidSuppmsg;
      BufbidTag     <= BufbidTag;
   
      Buf2bidAddr    <= Buf2bidAddr;
      Buf2bidData    <= Buf2bidData;
      Buf2bidMask    <= Buf2bidMask;
      Buf2bidExp     <= Buf2bidExp;
      Buf2bidSize    <= Buf2bidSize;
      Buf2bidProt    <= Buf2bidProt;
      Buf2bidTrans   <= Buf2bidTrans;
      Buf2bidBurst   <= Buf2bidBurst;
      Buf2bidWrite   <= Buf2bidWrite ;
      Buf2bidResp    <= Buf2bidResp ;
      Buf2bidNumcyc  <= Buf2bidNumcyc;
      Buf2bidLimit   <= Buf2bidLimit;
      Buf2bidMasnum  <= Buf2bidMasnum;
      Buf2bidMaslock <= Buf2bidMaslock;
      Buf2bidIdlcyc  <= Buf2bidIdlcyc;
      Buf2bidRslimit <= Buf2bidRslimit;
      Buf2bidTimeout <= Buf2bidTimeout;
      Buf2bidSuppmsg <= Buf2bidSuppmsg;
      Buf2bidTag     <= Buf2bidTag;
    end   
end // lineget;

// ---------------------------------------------------------------------
// Driving address and control signals 
// ---------------------------------------------------------------------
always @(posedge HCLK)
begin : p_drive
  if (Nextissue == 1'b1)
  begin 
    // Issue commands other than idle cycle 
    if (BidTrans != 2'b00 | (BidTrans == 2'b00 & (Resplit != 1'b0 |
        Pollstart != 1'b0)))
    begin
      // indicates that a re-issuable retry/split is in progress 
      if (Resplit == 1'b1 || (Pollstart == 1'b1 & HREADY == 1'b1 &
           (iHTRANS != 2'b00 || (iHTRANS == 2'b00 &
           (pocount != time_out - 1'b1) &
           ((HRDATA & ReadMask) != (ExpData & ReadMask)))))) 
      begin
      // Reissue Xr at the end of idle cycle between retry/split
      // re-issues
        if (iHTRANS == 2'b00 & ((Idleflag == 1'b1 & RsbidNumcyc != 0) ||
            (Pollstart == 1'b1 & Resplit == 1'b0)))   
        begin
          HADDR     <= # `Tiha DefHADDR; 
          HADDR     <= # (`Tclkh + `Tclkl - `Tisa) RsbidAddr;
          HWRITE    <= # `Tihctl DefHWRITE;
          HWRITE    <= # (`Tclkh + `Tclkl - `Tisctl) RsbidWrite;
          HSIZE     <= # `Tihctl DefHSIZE;
          HSIZE     <= # (`Tclkh + `Tclkl - `Tisctl) RsbidSize;
          HPROT     <= # `Tihctl DefHPROT;
          HPROT     <= # (`Tclkl + `Tclkh - `Tisctl) RsbidProt;
          iHTRANS   <= # `Tihtr DefHTRANS;
          iHTRANS   <= # (`Tclkh + `Tclkl - `Tistr) RsbidTrans;
          HBURST    <= # `Tihctl DefHBURST;
          HBURST    <= # (`Tclkh + `Tclkl - `Tisctl) RsbidBurst;
          HMASTER   <= # `Tihmst DefHMASTER;
          HMASTER   <= # (`Tclkh + `Tclkl - `Tismst) RsbidMasnum;
          HMASTLOCK <= # `Tihmlck DefHMASTLOCK;
          HMASTLOCK <= # (`Tclkh + `Tclkl - `Tismlck) RsbidMaslock; 
        end
        else if (iHTRANS == 2'b00 & Idleflag == 1'b1 & RsbidNumcyc == 0)
        begin
          HADDR     <= # `Tiha DefHADDR;
          HADDR     <= # (`Tclkh + `Tclkl - `Tisa) RsbidAddr;
          HWRITE    <= # `Tihctl DefHWRITE;
          HWRITE    <= # (`Tclkh + `Tclkl - `Tisctl) RsbidWrite;
          HSIZE     <= # `Tihctl DefHSIZE;
          HSIZE     <= # (`Tclkh + `Tclkl - `Tisctl) RsbidSize;
          HPROT     <= # `Tihctl DefHPROT;
          HPROT     <= # (`Tclkl + `Tclkh - `Tisctl) RsbidProt;
          iHTRANS   <= # `Tihtr DefHTRANS;
          iHTRANS   <= # (`Tclkh + `Tclkl - `Tistr) 2'b10;
          HBURST    <= # `Tihctl DefHBURST;
          HBURST    <= # (`Tclkh + `Tclkl - `Tisctl) RsbidBurst;
          HMASTER   <= # `Tihmst DefHMASTER;
          HMASTER   <= # (`Tclkh + `Tclkl - `Tismst) RsbidMasnum;
          HMASTLOCK <= # `Tihmlck DefHMASTLOCK;
          HMASTLOCK <= # (`Tclkh + `Tclkl - `Tismlck) RsbidMaslock;
        end
        // idle cycles between retry/split re-issues or 
        // idle cycle after a split/retry response 
        else 
        begin
          if ((iHTRANS == 2'b00 &  !(Idleflag)) | (HREADY == 1'b0 & 
             (HRESP == 2'b10 | HRESP == 2'b11)) | (Pollstart == 1'b1 & 
              HREADY == 1'b1 & blockidle == 1'b0))
          begin 
            HADDR     <= # `Tiha DefHADDR;
            HADDR     <= # (`Tclkh + `Tclkl - `Tisa) 32'b0;
            HWRITE    <= # `Tihctl DefHWRITE;
            HWRITE    <= # (`Tclkh + `Tclkl - `Tisctl) 1'b0;
            HSIZE     <= # `Tihctl DefHSIZE;
            HSIZE     <= #(`Tclkh + `Tclkl - `Tisctl) 3'b0;
            HPROT     <= # `Tihctl DefHPROT;
            HPROT     <= # (`Tclkl + `Tclkh - `Tisctl) 1'b0;
            iHTRANS   <= # `Tihtr DefHTRANS;
            iHTRANS   <= # (`Tclkh + `Tclkl - `Tistr) 2'b00;
            HBURST    <= # `Tihctl DefHBURST;
            HBURST    <= # (`Tclkh + `Tclkl - `Tisctl) 3'b0;
            HMASTER   <= # `Tihmst DefHMASTER;
            HMASTER   <= # (`Tclkh + `Tclkl - `Tismst) 3'b0;
            HMASTLOCK <= # `Tihmlck DefHMASTLOCK;
            HMASTLOCK <= # (`Tclkh + `Tclkl - `Tismlck) 1'b0;
          end
          // re-issue the command after the retried/split command
          else 
          begin
            if (Rsidle == 1'b1 & (HRESP == 2'b00 | HRESP == 2'b01))
            begin
              HADDR     <= # `Tiha DefHADDR;
              HADDR     <= # (`Tclkh + `Tclkl - `Tisa) RsnextAddr;
              HWRITE    <= # `Tihctl DefHWRITE;
              HWRITE    <= # (`Tclkh + `Tclkl - `Tisctl) RsnextWrite;
              HSIZE     <= # `Tihctl DefHSIZE;
              HSIZE     <= # (`Tclkh + `Tclkl - `Tisctl) RsnextSize;
              HPROT     <= # `Tihctl DefHPROT;
              HPROT     <= # (`Tclkl + `Tclkh - `Tisctl) RsnextProt;
              iHTRANS   <= # `Tihtr DefHTRANS;
              iHTRANS   <= # (`Tclkh + `Tclkl - `Tistr)  RsnextTrans;
              HBURST    <= # `Tihctl DefHBURST;
              HBURST    <= # (`Tclkh + `Tclkl - `Tisctl) RsnextBurst;
              HMASTER   <= # `Tihmst DefHMASTER;
              HMASTER   <= # (`Tclkh + `Tclkl - `Tismst) RsnextMasnum;
              HMASTLOCK <= # `Tihmlck DefHMASTLOCK;
              HMASTLOCK <= # (`Tclkh + `Tclkl - `Tismlck) RsnextMaslock;
            end
   
            // end of numcyc == 0 command due to limit
            else
            begin
              if (Maxflag) 
              begin  
                HADDR     <= # `Tiha DefHADDR;
                HADDR     <= # (`Tclkh + `Tclkl - `Tisa) BidAddr;
                HWRITE    <= # `Tihctl DefHWRITE;
                HWRITE    <= # (`Tclkh + `Tclkl - `Tisctl) BidWrite;
                HSIZE     <= # `Tihctl DefHSIZE;
                HSIZE     <= # (`Tclkh + `Tclkl - `Tisctl) BidSize;
                HPROT     <= # `Tihctl DefHPROT;
                HPROT     <= # (`Tclkl + `Tclkh - `Tisctl) BidProt;
                iHTRANS   <= # `Tihtr DefHTRANS;
                iHTRANS   <= # (`Tclkh + `Tclkl - `Tistr) BidTrans;
                HBURST    <= # `Tihctl DefHBURST;
                HBURST    <= # (`Tclkh + `Tclkl - `Tisctl) BidBurst;
                HMASTER   <= # `Tihmst DefHMASTER;
                HMASTER   <= # (`Tclkh + `Tclkl - `Tismst) BidMasnum;
                HMASTLOCK <= # `Tihmlck DefHMASTLOCK;
                HMASTLOCK <= # (`Tclkh + `Tclkl - `Tismlck) BidMaslock;
              end
            end
          end
        end
      end
      // idle_cyc after last retry/split command or
      // if it is a non-reissuable retry/split 
      else
      begin
        if (Rscount == 1 & (((iHTRANS != 2'b00 | Idlecount == 0) &  
           (HRESP[1] == 1'b1 ) | (Rsflag & Idlecount == 0))))  
        begin
          HADDR     <= # `Tiha DefHADDR;
          HADDR     <= # (`Tclkh + `Tclkl - `Tisa) 32'b0;
          HWRITE    <= # `Tihctl DefHWRITE;
          HWRITE    <= # (`Tclkh + `Tclkl - `Tisctl) 1'b0; 
          HSIZE     <= # `Tihctl DefHSIZE;
          HSIZE     <= # (`Tclkh + `Tclkl - `Tisctl) 3'b0;
          HPROT     <= # `Tihctl DefHPROT;
          HPROT     <= # (`Tclkl + `Tclkh - `Tisctl) 2'b0;
          iHTRANS   <= # `Tihtr DefHTRANS;
          iHTRANS   <= # (`Tclkh + `Tclkl - `Tistr) 2'b00;
          HBURST    <= # `Tihctl DefHBURST;
          HBURST    <= # (`Tclkh + `Tclkl - `Tisctl) 3'b0;
          HMASTER   <= # `Tihmst DefHMASTER;
          HMASTER   <= # (`Tclkh + `Tclkl - `Tismst) 3'b0;
          HMASTLOCK <= # `Tihmlck DefHMASTLOCK;
          HMASTLOCK <= # (`Tclkh + `Tclkl - `Tismlck) 1'b0;
        end 
        // next command re-issue after the retry/split command ends
        else
        begin
          if (Rsflag & ((HRESP != 2'b00 & HRESP != 2'b01)| 
             (Rsflag & Idlecount == 1)))
          begin
            HADDR     <= # `Tiha DefHADDR;
            HADDR     <= # (`Tclkh + `Tclkl - `Tisa) RsnextAddr;
            HWRITE    <= # `Tihctl DefHWRITE;
            HWRITE    <= # (`Tclkh + `Tclkl - `Tisctl) RsnextWrite;
            HSIZE     <= # `Tihctl DefHSIZE;
            HSIZE     <= #(`Tclkh + `Tclkl - `Tisctl) RsnextSize;
            HPROT     <= # `Tihctl DefHPROT;
            HPROT     <= # (`Tclkl + `Tclkh - `Tisctl) RsnextProt;
            iHTRANS   <= # `Tihtr DefHTRANS;
            iHTRANS   <= # (`Tclkh + `Tclkl - `Tistr) RsnextTrans;
            HBURST    <= # `Tihctl DefHBURST;
            HBURST    <= # (`Tclkh + `Tclkl - `Tisctl) RsnextBurst;
            HMASTER   <= # `Tihmst DefHMASTER;
            HMASTER   <= # (`Tclkh + `Tclkl - `Tismst) RsnextMasnum;
            HMASTLOCK <= # `Tihmlck DefHMASTLOCK;
            HMASTLOCK <= # (`Tclkh + `Tclkl - `Tismlck) RsnextMaslock;
          end
          // NSEQ or SEQ or BUSY transfer
          else
          begin 
            if (Pollstart == 1'b1 & HREADY == 1'b0) 
              begin 
                HADDR     <= HADDR;
                HWRITE    <= HWRITE;
                HSIZE     <= HSIZE;
                HPROT     <= HPROT;
                HTRANS    <= HTRANS;
                HBURST    <= HBURST;
                HMASTER   <= HMASTER;
              end
            else 
            begin
              HADDR     <= # `Tiha DefHADDR;
              HADDR     <= # (`Tclkh + `Tclkl - `Tisa) BidAddr;
              HWRITE    <= # `Tihctl DefHWRITE;
              HWRITE    <= # (`Tclkh + `Tclkl - `Tisctl) BidWrite;
              HSIZE     <= # `Tihctl DefHSIZE;
              HSIZE     <= #(`Tclkh + `Tclkl - `Tisctl) BidSize;
              HPROT     <= # `Tihctl DefHPROT;
              HPROT     <= # (`Tclkl + `Tclkh - `Tisctl) BidProt;
              iHTRANS   <= # `Tihtr DefHTRANS;
              iHTRANS   <= #(`Tclkh + `Tclkl - `Tistr) BidTrans;
              HBURST    <= # `Tihctl DefHBURST;
              HBURST    <= # (`Tclkh + `Tclkl - `Tisctl) BidBurst;
              HMASTER   <= # `Tihmst DefHMASTER;
              HMASTER   <= # (`Tclkh + `Tclkl - `Tismst) BidMasnum;
              HMASTLOCK <= # `Tihmlck DefHMASTLOCK;
              HMASTLOCK <= # (`Tclkh + `Tclkl - `Tismlck) BidMaslock;
            end
          end
        end
      end
    end
    // issue idle cycle 
    else
    begin              
      HADDR     <= # `Tiha DefHADDR;
      HADDR     <= # (`Tclkh + `Tclkl - `Tisa) BidAddr;
      HWRITE    <= # `Tihctl DefHWRITE;
      HWRITE    <= # (`Tclkh + `Tclkl - `Tisctl) BidWrite;
      HSIZE     <= # `Tihctl DefHSIZE;
      HSIZE     <= # (`Tclkh + `Tclkl - `Tisctl) BidSize;
      HPROT     <= # `Tihctl DefHPROT;
      HPROT     <= # (`Tclkl + `Tclkh - `Tisctl) BidProt;
      iHTRANS   <= # `Tihtr DefHTRANS;
      iHTRANS   <= # (`Tclkh + `Tclkl - `Tistr) BidTrans;
      HBURST    <= # `Tihctl DefHBURST;
      HBURST    <= # (`Tclkh + `Tclkl - `Tisctl) BidBurst;
      HMASTER   <= # `Tihmst DefHMASTER;
      HMASTER   <= # (`Tclkh + `Tclkl - `Tismst) BidMasnum;
      HMASTLOCK <= # `Tihmlck DefHMASTLOCK;
      HMASTLOCK <= # (`Tclkh + `Tclkl - `Tismlck) BidMaslock;
    end
  end
end // p_drive;

// ---------------------------------------------------------------------
// This block "processes" the lower order bits of HADDR on basis of
// endianness. When little-endian, it passes the lower HADDR bits as it
// is otherwise it inverts the bits. This helps in keeping the previous
// block(p_endianize) simple.
// ---------------------------------------------------------------------
always @(TogEndian or Writeaddr)
begin : p_optimizer
  if (TogEndian == 2'b01) 
    ByteLaneDecidr =  ~(Writeaddr[2:0]);
  else
    ByteLaneDecidr = Writeaddr[2:0];
end // p_optimizer;

// ---------------------------------------------------------------------
// Write cycle address 
// ---------------------------------------------------------------------
always @(Nextissue or  Resplit or  HWRITE or  BufbidAddr or RsbidAddr or
         BufbidData or RsbidData)
begin : p_AddrComb 
  if (Nextissue == 1'b1 & Resplit != 1'b1 &  HWRITE == 1'b1) 
  begin
    Writeaddr = BufbidAddr[2:0];
    WriteData = BufbidData;
  end
  // drive data from Rsbid during a re-issuable retry/split
  else 
    if (Nextissue == 1'b1 &  Resplit == 1'b1 & HWRITE == 1'b1)
    begin
      Writeaddr = RsbidAddr[2:0];
      WriteData = RsbidData;
    end
end // p_AddrComb;

// ---------------------------------------------------------------------
// Stores the Endianness of the system
// ---------------------------------------------------------------------
always @(HCLK or Endiansel)
begin : p_endian
  if (Endiansel == `T_CYCLE_C_ENDIAN)
    TogEndian = VEnEndian;
end // p_endian;

// ---------------------------------------------------------------------
// Data made according to little endian mode even if test is in
// bigendian mode
// ---------------------------------------------------------------------
always @ (WriteData or DelHSIZE)
begin : p_TestComb
/*  if (TestMode == 1 & DelHSIZE != 3'bXXX) 
  begin
    if (Databuswidth == 64) 
      case (DelHSIZE[1 : 0]) 
        2'b00 : 
          iHWDATA = WriteData[7 : 0] & WriteData[15 : 8] &
                    WriteData[23 : 16] & WriteData[31 : 24] &
                    WriteData[39 : 32] & WriteData[47 : 40] &
                    WriteData[55 : 48] & WriteData[63 : 56];
        2'b01 :
          iHWDATA = WriteData[15 : 8] & WriteData[7 : 0] &
                    WriteData[31 : 24] & WriteData[23 : 16] &
                    WriteData[47 : 40] & WriteData[39 : 32] &
                    WriteData[63 : 56] & WriteData[55 : 48];
        2'b10 :
          iHWDATA = WriteData[31 : 0] & WriteData[63 : 32];
        2'b11 :
          iHWDATA = WriteData;
        default : 
          iHWDATA =  WriteData;
      endcase
    else 
      if (Databuswidth == 32)
      case (DelHSIZE[2 : 0]) 
        2'b00 :
          iHWDATA = "00000000000000000000000000000000" &
                     WriteData[7 : 0] & WriteData[15 : 8] &
                     WriteData[23 : 16] & WriteData[31 : 24];
        2'b01 :
          iHWDATA = "00000000000000000000000000000000" &
                     WriteData[15 : 8] & WriteData[7 : 0] &
                     WriteData[31 : 24] & WriteData[23 : 16];
        2'b10 :
          iHWDATA = "00000000000000000000000000000000" &
                     WriteData[31 : 0];
        default : 
          iHWDATA =  WriteData;
      endcase
  end
  else
*/
    iHWDATA = WriteData;
end //process p_TestComb;

// ---------------------------------------------------------------------
// Driving Write data bus 
// ---------------------------------------------------------------------
always @(posedge HCLK)
begin : wdata
// drive data from Bufbid when a non_retry/split transfer in progress
  if (Nextissue == 1'b1 &  Resplit != 1'b1 &  HWRITE == 1'b1) 
  begin
    HWDATA <= # `Tihwd 64'hXXXXXXXXXXXXXXXX;
    HWDATA <= # (`Tclkh + `Tclkl - `Tiswd) endnizedata (iHWDATA,
                  TogEndian, BufbidSize,  BufbidAddr, ByteLaneDecidr);
  end
  // drive data from Rsbidpacket during a re-issuable retry/split
  else
  begin
    if (Nextissue == 1'b1 &  Resplit == 1'b1 &  HWRITE == 1'b1)
    begin
      HWDATA <= # `Tihwd 64'hXXXXXXXXXXXXXXXX; 
      HWDATA <= # (`Tclkh + `Tclkl - `Tiswd) endnizedata (iHWDATA,
                    TogEndian, RsbidSize, RsbidAddr, ByteLaneDecidr);
    end
    // dont drive the HWDATA during read
    else
    begin
      if (Nextissue == 1'b1 &  DelHWRITE == 1'b0 &  Resplit != 1'b1)
        HWDATA = # `Tihwd DefHWDATA; 
      // dont drive data during a  retry/split read 
      else 
        if (Nextissue == 1'b1 &  DelHWRITE == 1'b0 
            &  Resplit == 1'b1 &  (HRESP == 2'b11  | HRESP == 2'b10)
            &  HREADY == 1'b1)
          HWDATA = # `Tihwd DefHWDATA;
    end 
  end
end

// ---------------------------------------------------------------------
// Checking writing into slave 
// ---------------------------------------------------------------------
always @(posedge HCLK)
begin : p_wdata
 // check data during non-idle/busy transfer when response indicates OK
 if (DelHWRITE == 1'b1 & Nextissue == 1'b1  & HRESETn != 1'b0)
 begin
   if (HRESP == 2'b00  & HREADY == 1'b1  & Buf2bidTrans != 2'b00 &
       Resplit != 1'b1 & Rsidle != 1'b1 & Buf2bidTrans != 2'b01)
     ReportWrite(Verbosity, HWDATA, Buf2bidAddr, Buf2bidTag);
   // transfer which gets an OK response
   else
     if (HRESP == 2'b00 & HREADY == 1'b1 & (Resplit == 1'b1 |
         Rsdone == 1'b1) & Rsidle != 1'b1)
       ReportWrite(Verbosity, HWDATA, RsbidAddr, RsbidTag );
 end
end // p_wdata;

// ---------------------------------------------------------------------
// Read cycle Mask value depending on transfer 
// ---------------------------------------------------------------------
always @(DelHWRITE or Nextissue or HRESETn or HREADY or HRESP or
         DelHTRANS or Resplit or Rsidle or Buf2bidMask or Buf2bidExp or
         RsbidMask or Rsdone or Buf2bidTrans)
begin : p_MaskComb
  if (DelHWRITE == 1'b0 & Nextissue == 1'b1 & HRESETn != 1'b0 & 
      DelHTRANS == 1'b1)
  begin
    if (HRESP == 2'b00 & HREADY == 1'b1 & Buf2bidTrans != 2'b00 &
        Resplit != 1'b1 & Rsidle != 1'b1 & Buf2bidTrans != 2'b01) 
    begin
      Mask     <= Buf2bidMask;
      iExpData <= Buf2bidExp;
    end
     // transfer which gets an OK response
    // read data check at the end of a retried/split
    else
    begin
      if (HRESP == 2'b00 &  HREADY == 1'b1 & (Resplit == 1'b1 |  
          Rsdone == 1'b1) & Rsidle != 1'b1)
      begin 
        Mask     <= RsbidMask;
        iExpData <= RsbidExp;
      end
    end
  end
end // p_MaskComb;

// ---------------------------------------------------------------------
// Driving Write data bus
// ---------------------------------------------------------------------
always @(iExpData or TogEndian or DelHSIZE)
begin : p_ExpDATA
  if (TogEndian == 2'b01 & DelHSIZE !== 3'bXXX)
  begin
    if (Databuswidth == 64)
    begin
      case (DelHSIZE[2:0])
        3'b000 :
          ExpData = {iExpData[7:0], iExpData[15:8],
                    iExpData[23:16], iExpData[31:24],
                    iExpData[39:32], iExpData[47:40],
                    iExpData[55:48], iExpData[63:56]};
        3'b001 :
          ExpData = {iExpData[15:8], iExpData[7:0],
                    iExpData[31:24], iExpData[23:16],
                    iExpData[47:40], iExpData[39:32],
                    iExpData[63:56], iExpData[55:48]};
        3'b010 :
          ExpData = {iExpData[31:0], iExpData[63:32]};
        3'b011 :
          ExpData = iExpData;
        default :
          ExpData = iExpData;
      endcase
    end
    else
    begin
      if (Databuswidth == 32)
      begin
        case (DelHSIZE[2:0])
          3'b000 :
            ExpData = {32'b00000000000000000000000000000000,
                      iExpData[7:0], iExpData[15:8],
                      iExpData[23:16], iExpData[31:24]};
          3'b001 :
            ExpData = {32'b00000000000000000000000000000000,
                      iExpData[15:8], iExpData[7:0],
                      iExpData[31:24], iExpData[23:16]};
          3'b010 :
            ExpData = {32'b00000000000000000000000000000000,
                       iExpData[31:0]};
          default :
            ExpData = iExpData;
      endcase
      end
    end
  end
  else
  begin
    ExpData = iExpData;
  end
end // p_ExpDATA;

// ---------------------------------------------------------------------
// Assigning Mask value depending on Endianness
// ---------------------------------------------------------------------
always @(TogEndian or Mask)
begin : p_ReadMaskComb
  if (TogEndian == 2'b01)
  begin
    for (i = 0; i <= (Databuswidth -1); i = i + 1)
      ReadMask[i] = Mask[Databuswidth - i - 1];
  end
  else
    ReadMask    = Mask;
end // p_ReadMaskComb;

// ---------------------------------------------------------------------
// Checking Read data bus 
// ---------------------------------------------------------------------
always @(posedge HCLK)
begin : p_rdata
 // check data during non-idle/busy transfer when response indicates OK
 if (DelHWRITE == 1'b0 & Nextissue == 1'b1  & HRESETn != 1'b0)
 begin
   if (HRESP == 2'b00  & HREADY == 1'b1  & Buf2bidTrans != 2'b00 & 
       Resplit != 1'b1 & Rsidle != 1'b1 & Buf2bidTrans != 2'b01)
     ReportRead(Verbosity, HaltOnMismatch, HRDATA, ReadMask,
                Buf2bidAddr, Pollstart, delPollstart, Pollend, Pidle,
                Maxflagpoll, pocount, countflag,ExpData, Buf2bidTag );
   // transfer which gets an OK response
   // read data check at the end of a retried/split
   else 
     if (HRESP == 2'b00 & HREADY == 1'b1 & (Resplit == 1'b1 | 
         delPollstart == 1'b1 | Rsdone == 1'b1) & Rsidle != 1'b1)
       ReportRead(Verbosity, HaltOnMismatch, HRDATA, ReadMask,
                  RsbidAddr, Pollstart, delPollstart, Pollend,
                  Pidle, Maxflagpoll, pocount, countflag,
                  ExpData, RsbidTag ); 
 end
end // p_rdata;

// ---------------------------------------------------------------------
// Generating Expected Response 
// ---------------------------------------------------------------------
always @(posedge HCLK) 
begin : p_respcheck
  if (Resplit != 1'b1)
  begin
    if (HRESETn == 1'b0)
      Expresp <= 2'b00;
    else
    begin
      if ((HRESP[1] == 1'b1) & (Oners == 1'b1))
        Expresp <= RsbidResp;
      else
      begin
        if (Buf2bidNumcyc == 0 & HREADY != 1'b1)
          Expresp <= Buf2bidResp;
        else
        begin
          if (Pollstart == 1'b1 & delflagpoll == 1'b1 & HREADY == 1'b1) 
            Expresp <= 2'b00;
          else
          begin
            if (HREADY == 1'b1 & BufbidNumcyc == 0)
             Expresp <= BufbidResp;
            else
            begin
              if (BufbidResp == 2'b01)
              begin
                if (Last == 1 & Val == 8'b00000001)
                  Expresp <= BufbidResp;
                else
                begin
                  if (Last == 2  & Val == 8'b00000000)
                    Expresp <= BufbidResp;
                  else
                  begin
                    if (Last == 0)
                      Expresp <= BufbidResp;
                    else
                      Expresp <= 2'b00;
                  end 
                end
              end
            else
              begin
                if (BufbidResp == 2'b10 | BufbidResp == 2'b11)
                begin
                  if (Last == 2 & Val == 8'b00000000)
                    Expresp <= BufbidResp;
                  else
                    Expresp <= 2'b00;
                end
                else 
                  Expresp <= BufbidResp;
              end 
            end
          end
        end
      end
    end
  end
  else
  begin
    if (Resplit == 1'b1)
      Expresp <= RsbidResp;
    else
    begin
      if (Rslast == 1'b1)
        Expresp <= RsbidResp;
    end
  end
end // p_respcheck;

always @(posedge Newtran)
begin
  Expresp <= BufbidResp;
end

always @(posedge HRESETn)
begin
   if (Resetstrd == 1'b0)
     Expresp <= 2'b00;
end
// ---------------------------------------------------------------------
// Response checking 
// ---------------------------------------------------------------------
always @(posedge HCLK)
begin : p_respcall
  if ((Resetstrd != 1'b0) & Resetover & (Rsidle != 1'b1) &
      (HREADY == 1'b1))
  begin
    if ((Resplit == 1'b1) | (Rsdone == 1'b1)) 
        Response(HaltOnMismatch, RsbidTag, RsbidAddr,
                 Expresp, HRESP, RsbidNumcyc, HREADY,
                 RsbidSuppmsg);
    else
        Response(HaltOnMismatch, BufbidTag, BufbidAddr,
                 Expresp, HRESP, BufbidNumcyc, HREADY,
                 BufbidSuppmsg);
  end
  else
    if ((Resetstrd != 1'b0) & Resetover & (Rsidle == 1'b1) &
        (HREADY == 1'b1))
      Response(HaltOnMismatch, BufbidTag, BufbidAddr,
               2'b00, HRESP, BufbidNumcyc, HREADY,
               BufbidSuppmsg );
end // p_respcall; 

// ---------------------------------------------------------------------
// Counter for the number of wait states in the transfer 
// Loaded when a new transfer occurs
// ---------------------------------------------------------------------
always @(posedge HCLK)
begin : p_WSCcount
  if (HREADY == 1'b1)
    WSCount <= 32'd0;
  else
  begin
    if ((WSCount < 32'hFFFFFFFF) & (HREADY === 1'b0)) 
      WSCount <= WSCount + 1'b1;
    if ((WSCount == `MAX_WAIT_STATE) & (HREADY === 1'b0))
      $display("%t:WSCLIMIT: Warning : Wait states exceeded ", $time,
               "buswatch limit %d ", `MAX_WAIT_STATE);
  end
end // p_WSCcount;
 
// ---------------------------------------------------------------------
// Counter for the number of beats in the burst
// Loaded when a new transfer occurs or when rsidle is high and a new
// burst starts in the case of split and retry cycles 
// ---------------------------------------------------------------------
always @(posedge HCLK)
begin : p_burstcount
  if ((Newtran == 1'b1 | Rsidle == 1'b1 ))
  begin
    if (iHTRANS == 2'b00 | iHTRANS == 2'b10 | HRESETn == 1'b0)
        Beatcount <= 5'b00001;
    else if ((iHTRANS == 2'b11 | (Beatcount >= 5'b00100 &
              iHTRANS == 2'b01)) & (Rsidle == 1'b0)  &
              (HRESETn != 1'b0))
      Beatcount <= Beatcount + 1'b1;
  end
end // p_burstcount;

// ---------------------------------------------------------------------
// Checker to indicate that the Beatcount is exceeded for a burst
// ---------------------------------------------------------------------
always @(posedge HCLK)
begin : p_burstcheck 
    DelHBURST <= HBURST;
    if (DelHBURST[2] == 1'b1  & DelHTRANS != 1'b1)
    begin
      if (DelHBURST[1] == 1'b0 & Beatcount > 5'b01000)
        ReportExtra(8, Buf2bidAddr, Buf2bidTag);
      else 
        if (DelHBURST[1] == 1'b1 & Beatcount > 5'b10000)
          ReportExtra(16, Buf2bidAddr, Buf2bidTag);
    end
    else 
      if (DelHBURST[1] == 1'b1 & Beatcount > 5'b00100 &
          DelHTRANS != 1'b1)
        ReportExtra(4, Buf2bidAddr, Buf2bidTag);
end // p_burstcheck;    

// ---------------------------------------------------------------------
// HREADY check for numcyc > 0
// ---------------------------------------------------------------------
always @(posedge HCLK)
begin : p_hreadycheck
  if (Last > 1 & HREADY == 1'b1)
  begin
    if (HaltOnMismatch)
      $finish;  
    $display ("%t ERRNC :Error : HREADY asserted when wait-state",$time,
              "(HREADY LOW) is expected");
  end
end // p_hreadycheck;
 
// ---------------------------------------------------------------------
// Counter for re-issue of a numcyc == 0 command
// ---------------------------------------------------------------------
always @(HCLK or Newtran)
begin : p_count_reissue 
  if (Newtran == 1'b1 | HREADY == 1'b1 | 
     (Resplit == 1'b1 & Idledone)) 
    Count <= 0;
  else 
    if (HCLK == 1'b1 & Last == 0 & HREADY != 1'b1)
      Count <= Count + 1;
end // p_count_reissue;

// ---------------------------------------------------------------------
// Message to indicate that a numcyc zero limit is exceeded
// ---------------------------------------------------------------------
always @(posedge HCLK)
begin : p_limcount_max
  if (Maxflag |  (Maxflagpoll == 1'b1 &
      delflagpoll == 1'b0) & HRESP != 2'b10 & HRESP != 2'b11)
  begin
    $display("%t: WARNRE: Warning: Maximum limit reached for number of",
             $time, " reissues in a numcycle  zero command");
  end
end // p_limcount_max;

// ---------------------------------------------------------------------
// Message to indicate that the limit for the re-issue of a retry/split 
// transfer is reached
// ---------------------------------------------------------------------
always @(posedge HCLK)
begin : p_rslimcount_max
  if (Rsflag & Rsdone == 1'b1 & 
      (HRESP == 2'b10 | HRESP == 2'b11) & Oners != 1'b1)
  begin
    $display("%t :WARNRSRE :  Maximum limit for number of retry/split ",
             $time, "reissues reached TAG : %0s ",RsbidTag);
  end
end // p_rslimcount_max;

// ---------------------------------------------------------------------
// HREADY check for the last cycle of a read or write
// ---------------------------------------------------------------------
always @( posedge HCLK)
begin : p_hready_check
  if (Nextissue == 1'b1 & HREADY != 1'b1 & (HRESP != 2'b10 &
      HRESP != 2'b11))
  begin
    if (DelHWRITE == 1'b1)
      $display("%t :ERRRDYW: Error : HREADY not asserted on expected",
               $time, " num_cyc clock cycle during write transfer");
    else 
      if (DelHWRITE == 1'b0)
        $display("%t: ERRRDYR: Error: HREADY not asserted on expected",
                 $time, " num_cyc clock cycle during read transfer");
  end
end // p_hready_check;

// ---------------------------------------------------------------------
// HREADY check if asserted prior to the last cycle of a read or write
// ---------------------------------------------------------------------
always @(posedge HCLK)
begin : p_hreadyprior_check
  if (Nextissue == 1'b1 & (Val != 8'h01 & Last != 1) &
      Buf2bidNumcyc != 8'h00 & (HRESP != 2'b10 & HRESP != 2'b11))
  begin
    if (DelHWRITE == 1'b1)
      $display("%t:WARNRDYW : HREADY asserted prior to expected",$time,
               " num_cyc clock cycle during write transfer");
    else 
      if (DelHWRITE == 1'b0)
        $display ("%t: WARNRDYR: HREADY asserted prior to expected",
                  $time, " num_cyc clock cycle during read transfer");
  end
end // p_hreadyprior_check;

// ---------------------------------------------------------------------
// Signal to indicate a retry/split transfer in progress
// ---------------------------------------------------------------------
always @(HCLK)
begin : p_retrysplit
  if (HCLK == 1'b1 & (HRESP == 2'b10 | HRESP == 2'b11)
      & Rsdone != 1'b1 & Rslast != 1'b1 & Oners != 1'b1)
# 0 Resplit = 1'b1;
  else 
    if (Rsidle != 1'b1 & HREADY == 1'b1 & 
        (HRESP == 2'b00 | HRESP == 2'b01 | 
        (Rsflag & Oners != 1'b1)))
      Resplit = 1'b0;
end // p_retrysplit;

// ---------------------------------------------------------------------
// Signal to indicate idle cycles between retry/split transfers in
// progress
// ---------------------------------------------------------------------
always @(posedge HCLK)
begin : p_retspl_idle
    if ((Resplit == 1'b1 | Rsflag) & iHTRANS == 2'b00 & HREADY == 1'b1 &
       ((                             //RsnextTrans != 2'b00  & 
        (HRESP == 2'b10 | HRESP == 2'b11)) | RsnextTrans != 2'bXX))
      Rsidle <= 1'b1;
    else 
      if (iHTRANS != 2'b00)
        Rsidle <= 1'b0;
end // p_retspl_idle;

// ---------------------------------------------------------------------
// Signal to indicate idle cycles between Poll transfers in progress
// ---------------------------------------------------------------------
always @ (posedge HCLK)
begin
  if ((Pollstart == 1'b1 | delPollstart == 1'b1) & iHTRANS == 2'b00 &
         HREADY == 1'b1) 
    Pidle <= 1'b1;
  else if (iHTRANS != 2'b00) 
    Pidle <= 1'b0;
end

// ---------------------------------------------------------------------
// Counter to count the number of idle cycles between retry/split
// re-issues
// ---------------------------------------------------------------------
always @(posedge HCLK)
begin : p_idle_counter
    if ((iHTRANS == 2'b00 & Resplit == 1'b1 & HREADY == 1'b1) |
        (Oners == 1'b1 & HREADY == 1'b0)) 
      Idlecount <= Idlecount + 1;
    else 
      Idlecount <= 0;
end // p_idle_counter;

// ---------------------------------------------------------------------
// Counter to count the number of retry/ split responses
// ---------------------------------------------------------------------
always @(HCLK or BidAddr or BidData or
           BidMask or BidExp or BidSize or BidProt
           or BidTrans or BidBurst or BidWrite or
           BidResp or BidNumcyc or BidLimit or
           BidMasnum or BidMaslock or BidIdlcyc or
           BidRslimit or BidSuppmsg or BidTag or BidGetLine)
begin : p_rscounter
  if (BidGetLine == `T_GET_G_GET)        
    Rscount <= 1;
  else if (Resplit == 1'b1 & HREADY == 1'b1 & 
         HCLK == 1'b1 &  Rsidle == 1'b1 & 
         iHTRANS != 'b00)
    Rscount <= Rscount + 1;
end // p_rscounter;

// ---------------------------------------------------------------------
initial
begin
  Oners          = 1'b0;
  BufbidLimit    = 32'd0;
  Buf2bidLimit   = 32'd0;
  RsbidTrans     = 2'b10;
  RsbidResp      = 2'b00; 
  Buf2bidResp    = 2'b00;
  RsbidNumcyc    = 32'd0; 
  RsbidLimit     = 32'd0;
  Buf2bidLimit   = 32'd0;
  RsbidRslimit   = 32'd0;
  BufbidTrans    = 2'b10;
  Buf2bidTrans   = 2'b10;
  BufbidRslimit  = 32'd0;
  Buf2bidRslimit = 32'd0;
  BufbidNumcyc   = 8'd0;
  Buf2bidNumcyc  = 8'd0;
end

// ---------------------------------------------------------------------
// Checking read data bus for the expected value
// ---------------------------------------------------------------------
task ReportWrite;
    input         Verbosity;
    input [63:0]  DATA;
    input [31:0]  ADDRESS;
    input [159:0] TAG;
  begin
    if (Verbosity)
      $display("%t: HSWC: Executed write transfer of %h ",$time,DATA,
               "at address %h TAG: %0s", ADDRESS, TAG);
  end
endtask

// ---------------------------------------------------------------------
// Checking read data bus for the expected value
// ---------------------------------------------------------------------
task ReportRead;
    input         Verbosity;
    input         HaltOnMismatch;
    input [63:0]  DATA;
    input [63:0]  MASK;
    input [31:0]  ADDRESS;
    input         Pollstart;
    input         delPollstart; 
    output        Pollend;
    input         Pidle; 
    input         Maxflagpoll;
    input [31:0]  pocount; 
    input         countflag;    
    input [63:0]  EXP;
    input [159:0] TAG;
begin
  if ((MASK & DATA) !== (MASK & EXP) & delPollstart == 1'b0 &
       Pidle != 1'b1)
    begin
      $display( "%t: HSRE: Error on data read from %h. Expected: %h",
                $time, ADDRESS,EXP, " Actual: %h Mask: %h TAG: %0s",
                DATA, MASK, TAG);
       Pollend = 1'b0;
      if (HaltOnMismatch)
        $finish;
    end
    else if (delPollstart == 1'b0 & Pidle != 1'b1) 
    begin
      if (Verbosity)
      $display("%t: HSRC:Correct read value of %h from %h ",
               $time,DATA,ADDRESS,
               "with mask %h, TAG: %0s", MASK, TAG);
    Pollend = 1'b0;
    end
    else if (Maxflagpoll == 1'b1) 
    begin
      Pollend = 1'b1;
      $display("SPE: Limit has reached when numcycle is zero");
    end
    else if (((MASK & DATA) == (MASK & EXP)) & (delPollstart == 1'b1)
                & Pidle != 1'b1) 
    begin 
      if (Verbosity) 
      $display( 
          "SPC: Correct value of %h polled, Count:%h, TAG: %0s",
          EXP,pocount, TAG);
      Pollend = 1'b1;
    end 
    else if (((MASK & DATA) !== (MASK & EXP)) & (delPollstart == 1'b1) &
             Pidle != 1'b1 & countflag == 1'b1) 
          begin
            if (Verbosity) 
            $display (
              "SO: Polling for value %h, Count:%h, TAG:%0s",
              EXP, pocount, TAG);
            Pollend = 1'b0;
          end
    else if (countflag == 1'b0 && delPollstart == 1'b1 &&
             Pollend != 1'b1)
      $display("SPE: Maximum number of Polls for value %h reached.Count:%h, TAG:%0s", EXP, (pocount - 1'b1), TAG);
     else
        Pollend = 1'b0;
end
endtask
 

// ---------------------------------------------------------------------
// Checks for extra transfers in a beat
// ---------------------------------------------------------------------
task ReportExtra;
  input         count;
  input [63:0]  ADDRESS;
  input [159:0] TAG;
begin
  if (count == 4)
    $display("%t: Extra: Extra transfer for four-beat burst", $time, 
              " Address: %h TAG: %0s", ADDRESS, TAG);
  else
  begin
    if (count == 8)
        $display("%t: Extra: Extra transfer for eight-beat burst ",
                 $time, "Address:  %h TAG: %0s", ADDRESS, TAG); 
    else 
    begin
      if (count == 16)
        $display("%t: Extra: Extra transfer for sixteen-beat burst ",
                 $time, "Address: %h TAG: %0s", ADDRESS, TAG);
    end 
  end
end
endtask // ReportExtra; 

// ---------------------------------------------------------------------
// This block is responsible for driving data on appropriate bytelanes
// as per the endianness. It takes endianness and HADDR bits as input
// and on the basis of that, "puts" the data on the correct byte lane
// and drives the other lanes to zero. Currently implemented for 64 bit
// wide data buses.
// ---------------------------------------------------------------------
function [63:0] endnizedata;
input [63:0] data;
input [1:0]  TogEndian;
input [2:0]  size;
input [31:0] address;
input [2:0]  ByteLaneDecidr;
reg [63:0]   ALLZEROES;
begin
  assign ALLZEROES = 64'h0000000000000000;

  if (TogEndian == 2'b10)
    endnizedata = data;
  else
  begin
    // if 64 bit data width
    if (Databuswidth == 64)
    begin
      if (size == 3'b000)
      begin
        // transfer size is byte-size
        case (ByteLaneDecidr[2:0])
          3'b000  :
            endnizedata = {ALLZEROES[63:8], data[7:0]};
          3'b001  :
            endnizedata = {ALLZEROES[63:16], data[7:0],
                          ALLZEROES[7:0]};
          3'b010  :
            endnizedata = {ALLZEROES[63:24], data[7:0],
                          ALLZEROES[15:0]};
          3'b011  :
            endnizedata = {ALLZEROES[63:32], data[7:0],
                        ALLZEROES[23:0]};
          3'b100  :
            endnizedata = {ALLZEROES[63:40], data[7:0],
                          ALLZEROES[31:0]};
          3'b101  :
            endnizedata = {ALLZEROES[63:48], data[7:0],
                          ALLZEROES[39:0]};
          3'b110  :
            endnizedata = {ALLZEROES[63:56], data[7:0],
                          ALLZEROES[47:0]};
          3'b111  :
            endnizedata = {data[7:0], ALLZEROES[55:0]};
          default : 
            endnizedata = data; 
        endcase
      end
      else 
      begin
        if (size == 3'b001)
        begin
          // transfer size is halfword-size
          case (ByteLaneDecidr[2:1])
            3'b00  :
              endnizedata = {ALLZEROES[63:16], data[15:0]};
            3'b01  :
              endnizedata = {ALLZEROES[63:32], data[15:0]
                            , ALLZEROES[15:0]};
            3'b10  :
              endnizedata = {ALLZEROES[63:48], data[15:0]
                             , ALLZEROES[31:0]};
            3'b11  :
              endnizedata = {data[15:0], ALLZEROES[47:0]};
            default  :
             endnizedata = data;
          endcase
      end
        else
        begin
          if (size == 3'b010) 
          // transfer size is word-size
          begin
            case (ByteLaneDecidr[2])
              1'b0  : 
                endnizedata = {ALLZEROES[63:32], data[31:0]};
              1'b1  :
                endnizedata = {data[31:0], ALLZEROES[31:0]};
              default  :
                 endnizedata = data;
          endcase
          end
          else 
          begin
            if (size == 3'b011) 
            // transfer size is doubleword-size
              endnizedata = data;
            else
               endnizedata = data;
          end
        end
      end
    end
    //  else if 32 bit wide data bus
    else 
    begin
      if (Databuswidth == 32)
      begin
        if (size == 3'b000)
        // transfer size is byte-size
        begin
          case (ByteLaneDecidr[1:0]) 
            2'b00 : 
              endnizedata = {ALLZEROES[63:8], data[7:0]};
            2'b01  :
              endnizedata = {ALLZEROES[63:16], data[7:0],
                            ALLZEROES[7:0]};
            2'b10  :
              endnizedata = {ALLZEROES[63:24], data[7:0],
                            ALLZEROES[15:0]};
            2'b11  :
              endnizedata = {ALLZEROES[63:32], data[7:0],
                            ALLZEROES[23:0]};
            default : 
                 endnizedata = data;
          endcase
        end
        else
        begin
            if (size == 3'b001)
          // transfer size is halfword-size
            begin
              case (ByteLaneDecidr[1])
                1'b0 :
                  endnizedata = {ALLZEROES[63:16], data[15:0]};
                1'b1 :
                  endnizedata = {ALLZEROES[63:32], data[15:0]
                               ,ALLZEROES[15:0]};
                default : 
                   endnizedata = data;
              endcase
            end
            else
            begin
              if (size == 3'b010) 
              // transfer size is word-size
                endnizedata = {ALLZEROES[63:32], data[31:0]};
              else
                endnizedata = data;
            end
          end
        end
      end
    end
  end
endfunction

// ---------------------------------------------------------------------
// Checking response obtained from Slave with the expected response
// ---------------------------------------------------------------------
task Response;
input         HaltOnMismatch;
input [159:0] TAG;
input [31:0]  ADDRESS;
input [1:0]   resp;
input [1:0]   HRESP;
input         num_cyc;
input         HREADY;
input         supp_msg;
 
reg [8 * 8 : 1] actstr;
reg [8 * 8 : 1] expstr;
 
begin
 
if (resp != HRESP)
begin
  case (HRESP)
    2'b00 :
       actstr = "OK";
    2'b01 :
       actstr = "ERROR";
    2'b10 :
       actstr = "RETRY";
    2'b11 :
       actstr = "SPLIT";
    default  :
       actstr = "UNKNOWN";
  endcase
  case (resp)
     2'b00   :
       expstr = "OK";
     2'b01   :
       expstr = "ERROR";
     2'b10   :
       expstr = "RETRY";
     2'b11   :
       expstr = "SPLIT";
     default :
       expstr = "UNKNOWN";
  endcase
  if ((num_cyc > 0) | (num_cyc == 0 &
     ((supp_msg  & (( resp != 2'b00) |
      (resp == 2'b00 & HRESP == 2'b01))) |
       !(supp_msg))  & HREADY == 1'b1))
    $display ("%t : RSPERR%h%h: Error : Response error at ",
              $time,resp, HRESP,
              " address %h Expected: %s Actual: %s, TAG: %s",
              ADDRESS, expstr, actstr, TAG);
  if (HaltOnMismatch)
    $finish;
  end
end
endtask  // Response;
 

endmodule

// --============================= End ===============================--
