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
// File Name              : ahbslave_tb.v.rca
// File Revision          : 1.4
//
// Release Information    : PrimeCell(TM)-PL081-REL1v0
//
// ---------------------------------------------------------------------
//   Purpose :
//             AHB Slave Test Bench entity
//
// --=================================================================--

`timescale 1ns/1ps

// Include Timing Parameter File
`include "../tbench/timing.v"

// ---------------------------------------------------------------------

module ahbslave_tb (
                    HREADY,    
                    HRESP,     
                    HRDATA,    
                    HSPLIT,    
                    VRG0,     
                    VRG1,    
                    VRG2,   
                    VRG3,  
                    VRG4, 
                    VRG5,      
                    VRG6,     
                    VRG7,   
                    HCLK,    
                    HRESETn,   
                    HADDR,    
                    HTRANS,  
                    HWRITE, 
                    HSIZE, 
                    HBURST,    
                    HPROT,    
                    HMASTER, 
                    HMASTLOCK, 
                    HWDATA   
                   ); 
parameter
	INFILE                 = "", 
        Verbosity              = 0, 
        HaltOnMismatch         = 0, 
        XonSig                 = 0, 
        tclkl                  = 50, 
        tclkh                  = 50, 
        Databuswidth           = 64,
        TestMode               = 0,
        SuppressOnReset        = 0, 
        ahbslave_tb_TimingFile = "";

`uselib lib=common lib=reader lib=buswatch lib=bid lib=vr 
       
input         HREADY;
// AHB HREADY Signal
input [1:0]   HRESP;
// AHB HRESP Signal
input [63:0]  HRDATA;
// AHB Read Data bus
input [15:0]  HSPLIT;
// AHB Splitx Signal
 
inout [31:0]  VRG0;
inout [31:0]  VRG1;
inout [31:0]  VRG2;
inout [31:0]  VRG3;
inout [31:0]  VRG4;
inout [31:0]  VRG5;
inout [31:0]  VRG6;
inout [31:0]  VRG7;
//Virtual Registers
 
output        HCLK;
// AHB Clock Signal
 
output        HRESETn;
// AHB Reset signal
 
output [31:0] HADDR;
// AHB Address bus
 
output [1:0]  HTRANS;
// AHB HTRANS Signal
 
output        HWRITE;
// AHB HWRITE Signal
 
output [2:0]  HSIZE;
// AHB HSIZE Signal
 
output [2:0]  HBURST;
// AHB HBURST Signal
 
output [3:0]  HPROT;
// AHB HPROT Signal
 
output [3:0]  HMASTER;
// AHB HMASTER Signal
 
output        HMASTLOCK;
// AHB HMASTERLOCK Signal
 
output [63:0] HWDATA;
// AHB HWDATA Signal
 
// ---------------------------------------------------------------------
//
//                             ahbslave_tb 
//                             ===========
//
// ---------------------------------------------------------------------
//
// Overview
// ========
//   This module is the toplevel of Slave test bench and instantiates
// the modules as well as define the generics of testbench.
//  
// ---------------------------------------------------------------------

// ---------------------------------------------------------------------
// Signal Declarations
// ---------------------------------------------------------------------
// The get line signals come from the ahb and vr blocks, but one in not
// needed for the reset line, as this operates on its own.  It is
// implicitly assumed the user will not issue another reset until the
// Last one has finished.  The reader samples these in the low phase and
// decides on this whether to drive signals in the high phase.
// ---------------------------------------------------------------------

wire                   BidGetLine;
wire                   VRGetLine;

wire                   Last;
// Last transfer

wire                   DelHWRITE;
// Delayed HWRITE signal

wire                   iHCLK;
// Internal HCLK

wire                   iHRESETn;
// Internal HRESETn

wire                   iHWRITE;
// Internal HWRITE

wire [3:0]             HMASTER;
// HMASTER signal

wire [31:0]            BidAddr;
wire [63:0]            BidData;
wire [63:0]            BidMask;
wire [63:0]            BidExp;
wire [2:0]             BidSize;
wire [3:0]             BidProt;
wire [1:0]             BidTrans;
wire [2:0]             BidBurst;
wire                   BidWrite;
wire [1:0]             BidResp;
wire [7:0]             BidNumcyc;
wire [31:0]            BidLimit;
wire [3:0]             BidMasnum;
wire                   BidMaslock;
wire [31:0]            BidIdlcyc;
wire [31:0]            BidRslimit;
wire                   BidSuppmsg;
wire [159:0]           BidTag;
// packet containing info about values to be driven on busIF lines

wire                   ResPhase;
wire [7:0]             ResDelay;
wire [7:0]             ResNumcyc;
// packet containing info about values to be driven on the HRESETn line

wire [(8 * 3 - 1):0]   VRVregno;
wire [(8 * 32 - 1):0]  VRData;
wire [(8 * 32 - 1):0]  VRMask;
wire [(8 * 32 - 1):0]  VRExp;
wire [(8 - 1):0]       VRWrite;
wire [(8 - 1):0]       VRPhase;
wire [(8 - 1):0]       VREdge;
wire [(8 * 8 - 1):0]   VRDelay;
wire [(8 * 160 - 1):0] VRTag;
// packet containing info about values to be driven on virtual reg lines

wire [1:0]             TogEndian;
//  determining  endianness

wire [1:0]             EnEndian;
// Determines Endianness of the system

wire [15:0]            SpExpmas;
wire [7:0]             SpNumcyc;
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
// Packet determining expected split master

// ---------------------------------------------------------------------
// These Cycsel signals are passed to the ahb, vr and res blocks. There
// are three because a VR, BnRES and ASB signal may have to be driven
// in the same cycle.
// ---------------------------------------------------------------------
wire [3:0]             BidCycSel;
// indicates type of bus-cycle being driven e.g, c_idle,c_mw,c_mr etc.

wire [(8 * 4 - 1):0]   VRCycSel;
// indicates type of virtualreg-cycle being driven e.g, c_vr,c_vw,c_idle

wire [3:0]             RCycSel;
// indicates type of reset-cycle being driven e.g, c_res or c_idle.

wire [31:0]            BidTimeout;

wire [3:0]             EnCycSel;
// Endianness cycle

wire [3:0]             SpCycSel;
// Split cycle

wire [7:0]             CycCount;
// No of cycles elapsed in the current transfer

wire [(8 * 2 - 1):0]   VIOSel;
// Virtual Register Select

wire [15:0]            HSPLIT;
// HSPLITx lines

defparam ubuswatch.SuppressOnReset = SuppressOnReset;
defparam ubuswatch.Verbosity       = Verbosity;
defparam ubuswatch.HaltOnMismatch  = HaltOnMismatch;
// ---------------------------------------------------------------------
// AHB Slave BusWatcher Instantiation
// ---------------------------------------------------------------------
buswatch ubuswatch                    (
                    .HRESETn          (HRESETn),
                    .HCLK             (HCLK),       
                    .HRDATA           (HRDATA),     
                    .DelHWRITE        (DelHWRITE), 
                    .HTRANS           (HTRANS),   
                    .HMASTER          (HMASTER),  
                    .HSPLIT           (HSPLIT),
                    .HREADY           (HREADY),
                    .HRESP            (HRESP)
                    );

// ---------------------------------------------------------------------
// INFILE Reader Instantiation
// ---------------------------------------------------------------------
reader ureader                        (
                    .HCLK             (HCLK),
                    .BidGetLine       (BidGetLine),
                    .VRGetLine        (VRGetLine),
                    .BidAddr          (BidAddr),
                    .BidData          (BidData),
                    .BidMask          (BidMask),
                    .BidExp           (BidExp),
                    .BidSize          (BidSize),
                    .BidProt          (BidProt),
                    .BidTrans         (BidTrans),
                    .BidBurst         (BidBurst),
                    .BidWrite         (BidWrite),
                    .BidResp          (BidResp),
                    .BidNumcyc        (BidNumcyc),
                    .BidLimit         (BidLimit),
                    .BidMasnum        (BidMasnum),
                    .BidMaslock       (BidMaslock),
                    .BidIdlcyc        (BidIdlcyc),
                    .BidRslimit       (BidRslimit),
                    .BidTimeout       (BidTimeout),
                    .BidSuppmsg       (BidSuppmsg),
                    .BidTag           (BidTag),
                    .ResPhase         (ResPhase),
                    .ResDelay         (ResDelay),
                    .ResNumcyc        (ResNumcyc),
                    .VRVregno         (VRVregno),
                    .VRData           (VRData),
                    .VRMask           (VRMask),
                    .VRExp            (VRExp),
                    .VRWrite          (VRWrite),
                    .VRPhase          (VRPhase),
                    .VREdge           (VREdge),
                    .VRDelay          (VRDelay),
                    .VRTag            (VRTag),
                    .EnEndian         (EnEndian),
                    .SpExpmas         (SpExpmas),
                    .SpNumcyc0        (SpNumcyc0),
                    .SpNumcyc1        (SpNumcyc1),
                    .SpNumcyc2        (SpNumcyc2),
                    .SpNumcyc3        (SpNumcyc3),
                    .SpNumcyc4        (SpNumcyc4),
                    .SpNumcyc5        (SpNumcyc5),
                    .SpNumcyc6        (SpNumcyc6),
                    .SpNumcyc7        (SpNumcyc7),
                    .SpNumcyc8        (SpNumcyc8),
                    .SpNumcyc9        (SpNumcyc9),
                    .SpNumcyc10       (SpNumcyc10),
                    .SpNumcyc11       (SpNumcyc11),
                    .SpNumcyc12       (SpNumcyc12),
                    .SpNumcyc13       (SpNumcyc13),
                    .SpNumcyc14       (SpNumcyc14),
                    .SpNumcyc15       (SpNumcyc15),
                    .SpLimit          (SpLimit),
                    .BidCycSel        (BidCycSel),
                    .VRCycSel         (VRCycSel),
                    .RCycSel          (RCycSel),
                    .EnCycSel         (EnCycSel),
                    .SpCycSel         (SpCycSel),
                    .Last             (Last)
                    );
   
defparam ureset_driver.Verbosity = Verbosity;

// ---------------------------------------------------------------------
// AHB Reset Driver Instantiation
// ---------------------------------------------------------------------
reset_driver ureset_driver            (
                    .RCycSel          (RCycSel),
                    .HCLK             (HCLK),
                    .ResPhase         (ResPhase),
                    .ResDelay         (ResDelay),
                    .ResNumcyc        (ResNumcyc),
                    .HRESETn          (HRESETn)
                    );

defparam ucyc_drivers.Verbosity      = Verbosity;
defparam ucyc_drivers.HaltOnMismatch = HaltOnMismatch;
defparam ucyc_drivers.XonSig         = XonSig;
defparam ucyc_drivers.TestMode       = TestMode;
defparam ucyc_drivers.Databuswidth   = Databuswidth;

// ---------------------------------------------------------------------
// AHB Cycle Driver Instantiation
// ---------------------------------------------------------------------
cyc_drivers ucyc_drivers              (
                    .HCLK             (HCLK),
                    .HRESETn          (HRESETn),
                    .HADDR            (HADDR),
                    .HTRANS           (HTRANS),
                    .HWRITE           (HWRITE),
                    .HSIZE            (HSIZE),
                    .HBURST           (HBURST),
                    .HPROT            (HPROT),
                    .HWDATA           (HWDATA),
                    .HMASTER          (HMASTER),
                    .HMASTLOCK        (HMASTLOCK),
                    .HRDATA           (HRDATA),
                    .HREADY           (HREADY),
                    .HRESP            (HRESP),
                    .DelHWRITE        (DelHWRITE),
                    .BidAddr          (BidAddr),
                    .BidData          (BidData),
                    .BidMask          (BidMask),
                    .BidExp           (BidExp),
                    .BidSize          (BidSize),
                    .BidProt          (BidProt),
                    .BidTrans         (BidTrans),
                    .BidBurst         (BidBurst),
                    .BidWrite         (BidWrite),
                    .BidResp          (BidResp),
                    .BidNumcyc        (BidNumcyc),
                    .BidLimit         (BidLimit),
                    .BidMasnum        (BidMasnum),
                    .BidMaslock       (BidMaslock),
                    .BidIdlcyc        (BidIdlcyc),
                    .BidRslimit       (BidRslimit),
                    .BidTimeout       (BidTimeout),
                    .BidSuppmsg       (BidSuppmsg),
                    .BidTag           (BidTag),
                    .BidGetLine       (BidGetLine),
                    .Endiansel        (EnCycSel),
                    .VEnEndian        (EnEndian),
                    .TogEndian        (TogEndian),
                    .Cycsel           (BidCycSel),
                    .CycCount         (CycCount),
                    .Simend           (Last)
                    );
  
// ---------------------------------------------------------------------
// HCLK Generator Instantiation
// ---------------------------------------------------------------------
Clockgen uClockgen                    (
                    .HCLK             (HCLK)
                    );
                    
// ---------------------------------------------------------------------
// VR Cycle Driver Instantiation
// ---------------------------------------------------------------------
VRCycDrivers uVRCycDrivers            (
                    .HCLK             (HCLK),
                    .CycSel           (VRCycSel),
                    .VRPacketWrite    (VRWrite),
                    .VRPacketDelay    (VRDelay),
                    .CycCount         (CycCount),
                    .VRGetLine        (VRGetLine),
                    .VIOSel           (VIOSel)
                    );

defparam uVIODriver.Verbosity = Verbosity;
defparam uVIODriver.HaltOnMismatch = HaltOnMismatch;

// ---------------------------------------------------------------------
// VIO Driver Instantiation
// ---------------------------------------------------------------------
VIODriver #(`vrg0_del, `vrg1_del, `vrg2_del, `vrg3_del,
             `vrg4_del, `vrg5_del, `vrg6_del, `vrg7_del) 
            uVIODriver                (
                    .HCLK             (HCLK),
                    .VIOSel           (VIOSel),
                    .VRPacketVregno   (VRVregno),
                    .VRPacketData     (VRData),
                    .VRPacketMask     (VRMask),
                    .VRPacketExp      (VRExp),
                    .VRPacketWrite    (VRWrite),
                    .VRPacketPhase    (VRPhase),
                    .VRPacketEdge     (VREdge),
                    .VRPacketDelay    (VRDelay),
                    .VRPacketTag      (VRTag),
                    .VRG0             (VRG0),
                    .VRG1             (VRG1),
                    .VRG2             (VRG2),
                    .VRG3             (VRG3),
                    .VRG4             (VRG4),
                    .VRG5             (VRG5),
                    .VRG6             (VRG6),
                    .VRG7             (VRG7)
                    );

// ---------------------------------------------------------------------
// HSPLITx Checker Instantiation
// ---------------------------------------------------------------------
split usplit                          (
                .HCLK                 (HCLK),
                .HSPLIT               (HSPLIT),
                .SpCycSel             (SpCycSel),
                .SpExpmas             (SpExpmas),
                .SpNumcyc0            (SpNumcyc0),
                .SpNumcyc1            (SpNumcyc1),
                .SpNumcyc2            (SpNumcyc2),
                .SpNumcyc3            (SpNumcyc3),
                .SpNumcyc4            (SpNumcyc4),
                .SpNumcyc5            (SpNumcyc5),
                .SpNumcyc6            (SpNumcyc6),
                .SpNumcyc7            (SpNumcyc7),
                .SpNumcyc8            (SpNumcyc8),
                .SpNumcyc9            (SpNumcyc9),
                .SpNumcyc10           (SpNumcyc10),
                .SpNumcyc11           (SpNumcyc11),
                .SpNumcyc12           (SpNumcyc12),
                .SpNumcyc13           (SpNumcyc13),
                .SpNumcyc14           (SpNumcyc14),
                .SpNumcyc15           (SpNumcyc15),
                .SpLimit              (SpLimit)
               );


endmodule
    
// --============================= End ===============================--
