// --=========================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from ARM Limited
//   (C) COPYRIGHT 2000-2003 ARM Limited
//       ALL RIGHTS RESERVED
// The entire notice above must be reproduced on all authorised
// copies and copies may only be made to the extent permitted
// by a licensing agreement from ARM Limited.
//
// -----------------------------------------------------------------------------
// Version and Release Control Information:
//
// File Name              : SmcCore.v.rca
// File Revision          : 1.21
//
// Release Information    : PrimeCell(TM)-PL092-r1p3-01ltd0
//
// -----------------------------------------------------------------------------
// Purpose :
//           This is the top level structural module of the Static Memory
//           controller core.
//
// --=========================================================================--

`timescale 1ns/1ps

//Include Parameters File
`include "SmcParams.v"

// -----------------------------------------------------------------------------

module SmcCore (
// Inputs
                nHCLK,
                HCLK,
                HRESETn,
                HREADYIN,
                HADDR,
                HBURST,
                HTRANS,
                HSIZE,
                HWRITE,
                HWDATA,
                HSELSMC,
                HSELREG,
                BIGENDIAN,
                REMAP,
                Revision,
                SMWAIT,
                CANCELSMWAIT,
                SMMWCS7,
                SMRBLECS7,
                SMCDATAIN,
                SMBUSGNT,

// Outputs
                HRDATA,
                HREADYOUT,
                HRESP,
                nSMCDATAEN,
                nSMWEN,
                nSMOEN,
                SMBUSREQ,
                SMCDATAOUT,
                SMCS,
                nSMBLS,
                SMCADDR
                );

// Inputs
input         nHCLK;           // AHB Clock negative
input         HCLK;            // AHB Bus Clock
input         HRESETn;         // AHB Bus Reset Signal
input         HREADYIN;        // Multiplexed HREADY input from all
                               // slaves
input  [28:0] HADDR;           // AHB Address Bus
input   [2:0] HBURST;          // The burst transfer information from AHB
input   [1:0] HTRANS;          // AHB Bus Transfer type
input   [2:0] HSIZE;           // AHB Bus Transfer size
input         HWRITE;          // AHB Bus Transfer Direction
input  [31:0] HWDATA;          // AHB Write Data bus
input         HSELSMC;         // Device Select signal of Memory bank on
                               // AHB Bus
input         HSELREG;         // Device Select signal of Configuration
                               // registers on AHB Bus
input         BIGENDIAN;       // Type of endianness of the system
input         REMAP;           // Indicates the state of the Memory map
input   [3:0] Revision;        // Revision number setting
input         SMWAIT;          // Async Wait signal from external memory
                               // controller
input         CANCELSMWAIT;    // Asynchronous external input pin to
                               // signal that the SMWAIT has timed out
input   [1:0] SMMWCS7;         // Input pins used to program the memory
                               // width bit field of SMCBCR7 register
input         SMRBLECS7;       // Input pin to program the RBLE field of
                               // SMBCR7 register
input  [31:0] SMCDATAIN;       // Data from Memory to Smc
input         SMBUSGNT;        // Bus grant signal to Smc from DBI



// Outputs
output [31:0] HRDATA;          // Read Data bus to the AHB
output        HREADYOUT;       // Signal from the SMC to indicate the
                               // completion of the transfer
output  [1:0] HRESP;           // Response from the SMC regarding the
                               // status of the transfer
output  [3:0] nSMCDATAEN;      // Memory data bus driver enable from SMC
output        nSMWEN;          // Memory Write Enable
output        nSMOEN;          // Memory Output Enable
output        SMBUSREQ;        // Bus request signal from Smc to DBI
output [31:0] SMCDATAOUT;      // Data from Smc to Memory
output  [7:0] SMCS;            // Memory bank Chip Select output pins
output  [3:0] nSMBLS;          // Memory device Byte lane enables
output [25:0] SMCADDR;         // Memory address bus

// Inputs
wire          nHCLK;           // AHB Clock negative
wire          HCLK;            // AHB Bus Clock
wire          HRESETn;         // AHB Bus Reset Signal
wire          HREADYIN;        // Multiplexed HREADY input from all
                               // slaves
wire   [28:0] HADDR;           // AHB Address Bus
wire    [2:0] HBURST;          // The burst transfer information from AHB
wire    [1:0] HTRANS;          // AHB Bus Transfer type
wire    [2:0] HSIZE;           // AHB Bus Transfer size
wire          HWRITE;          // AHB Bus Transfer Direction
wire   [31:0] HWDATA;          // AHB Write Data bus
wire          HSELSMC;         // Device Select signal of Memory bank on
                               // AHB Bus
wire          HSELREG;         // Device Select signal of Configuration
                               // registers on AHB Bus
wire          BIGENDIAN;       // Type of endianness of the system
wire          REMAP;           // Indicates the state of the Memory map
wire    [3:0] Revision;        // Revision number setting
wire          SMWAIT;          // Async Wait signal from external memory
                               // controller
wire          CANCELSMWAIT;    // Asynchronous external input pin to
                               // signal that the SMWAIT has timed out
wire    [1:0] SMMWCS7;         // Input pins used to program the memory
                               // width bit field of SMCBCR1 register
wire          SMRBLECS7;       // Input pin to program the RBLE field of
                               // SMBCR7 register
wire   [31:0] SMCDATAIN;       // Data from Memory to Smc
wire          SMBUSGNT;        // Bus grant signal to Smc from DBI

// Outputs
wire   [31:0] HRDATA;          // Read Data bus to the AHB
wire          HREADYOUT;       // Signal from the SMC to indicate the
                               // completion of the transfer
wire    [1:0] HRESP;           // Response from the SMC regarding the
                               // status of the transfer
wire    [3:0] nSMCDATAEN;      // Memory data bus driver enable from SMC
wire          nSMWEN;          // Memory Write Enable
wire          nSMOEN;          // Memory Output Enable
wire          SMBUSREQ;        // Bus request signal from Smc to DBI
wire   [31:0] SMCDATAOUT;      // Data from Smc to Memory
wire    [7:0] SMCS;            // Memory bank Chip Select output pins
wire    [3:0] nSMBLS;          // Memory device Byte lane enables
wire   [25:0] SMCADDR;         // Memory address bus

// -----------------------------------------------------------------------------
//
//                                   SmcCore
//                                   =======
//
// -----------------------------------------------------------------------------
//
// Overview
// ========
//         This is the top level structural module which interconnects the
// following sub-modules :
// 1. SmcSynchroniser - This sub-block is used to double synchronize the
//                      asynchronous external input signals
// 2. SmcAhbif - This sub-block interfaces with the AHB bus and contains all
//               the internal registers
// 3. SmcEIB - The interface to the external world is the function of this
//             sub-module
// 4. SmcTSM - The main SMC transfer state machine to control all the
//             transactions.
// 5. SmcTimerWaitCont - The read and write access timings and the external
//                       wait controlled operations are performed.
// 6. SmcWrEnGen - The appropriate routing of the positive clocked or negative
//                 clocked write enable signals is achieved in this block
//
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Constant declarations
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Wire declarations
// -----------------------------------------------------------------------------
wire        WaitToutErr;
// SMWAIT Timeout Error

wire        BufWrOver;
// Buffer storage completion signal during write transfers

wire        MemWrOver;
// Write completion signal to indicate that all data packets have been
// flushed to the device

wire        MemWrOverCo;
// Combinational version of the MemWrOver

wire        MemRdOver;
// This signal indicates that the all data packets are read from the memory
// device at the end of read access time

wire [31:0] RdWrBuf;
// Read data path from the EIB block to the HRDATA lines in the AHB
// interface block

wire        MemWrReq;
// Signal indicating the write transfer being initiated

wire        MemRdReq;
// Signal indicating the read transfer being initiated

wire        WtdWrReq;
// Signal indicating that write transfer is pending on the AHB

wire        WtdRdReq;
// Signal indicating that read transfer is pending on the AHB

wire        MwPgm;
// Indicates that the Waited Read or Write Request
// is due to MW programming

wire        MSize08;
// Signal to indicate that a 8-bit memory device is being targeted

wire        MSize16;
// Signal to indicate that a 16-bit memory device is being targeted

wire        MSize32;
// Signal to indicate that a 32-bit memory device is being targeted

wire  [1:0] HTransRegCo;
// Registered HTRANS for other blocks

wire  [1:0] HSizeRegCo;
// Registered HSIZE for other blocks

wire        BM;
// Burst ROM device indication

wire        RBLE;
// Byte lane enabled device

wire  [7:0] CSPol;
// Chip Select polarity

wire  [4:0] WST1;
// Wait State count for single memory read or start of a burst read cycle

wire  [4:0] WST2;
// Wait State count for memory write or burst read cycle

wire  [3:0] WSTOEN;
// Chip select to Write enable assertion delay

wire  [3:0] WSTWEN;
// Chip select to Output enable assertion delay

wire  [3:0] IDCY;
// Turn around count value

wire [25:0] HAddrCrnt;
// Registered HADDR for a new transfer

wire  [2:0] BnkAddStrCo;
// Stored value of the current Bank Address

wire        AddrIncCo;
// Address increment signal from TSM

wire        XoutEnCo;
// Enable signal for the nSMOEN

wire        XoutDisCo;
// Disable signal for the nSMOEN

wire        RdXdatEnCo;
// Signal to assert the proper byte lanes of external data bus depending on
// memory width during reads

wire        WrXdatEnCo;
// Signal to assert all the byte lanes of external data bus during a write
// transfer and during Idle cycles

wire        BMlenEnd;
// Burst length termination signal during burst reads

wire [25:0] HAddrWtdCo;
// Registered HADDR for a waited transfer

wire        RdCntLdCo;
// Load normal read access delay

wire        WrCntLdCo;
// Load write delay

wire        TrArCntLdCo;
// Load Turn around delay

wire        ZeroIdleCo;
// 1 cycle Turn around delay

wire        RdBMcntLdCo;
// Load Burst read delay

wire        OEnCntLdCo;
// Load Output enable delay

wire        WEnCntLdCo;
// Load Write enable delay

wire        SmWaitS2;
// Double Synchronised External wait

wire        CnclSmWaitS2;
// Double synchronised External wait termination

wire        WaitEn;
// Enable for external wait mode

wire        WaitPol;
// External wait Polarity

wire        CntEnd;
// Access timer counter termination signal

wire        DelayEnd;
// Indicates completion of the enable delay {for WEN & OEN}

wire  [3:0] SmcState;
// The state machine's current state value

wire        ExtWrEnCo;
// enable signal for generation of write enable and bytelane select

wire        ExtWrDisCo;
// Disabling signal for the write enable and bytelane selects

wire        SMCsEnCo;
// Chip Select enable

wire        XdatDisCo;
// Signal to de-assert the SMCDATAEN output lines

wire        BankCmpCo;
// Signal which checks if the successive transfers are to the same bank

wire        PosSMWEN;
// Positive edge (HCLK) triggered Write Enable, SMWEN

wire  [3:0] PosSMBLS;
// Positive edge (HCLK) triggered byte lane select, SMBLS

wire  [1:0] MW;
// The registered memory width value of targeted bank

wire        BufByPassCo;
// This signal is used to indicate that the HSIZE = MSIZE and the
// RdWrBuf can be bypassed during transfers

wire        BrstAddIncCo;
// Signal for incrementing the SMADDR in advance during burst reads

wire        BMRdTrans;
// This signal indicates that current transfer status is burst mode reads

wire  [2:0] HBurstRegCo;
// Registered HBURST signal from AHB interface block

wire        RemapReg;
// Registered version of the REMAP input

wire        AhbRdEn;
// Enabling signal to route data to HRDATA bus on read completion

wire        AhbRdOver;
// Signal to indicate the completion of read by AHB

wire  [3:1] SmcAddrReg;
// Registered version of SMCADDR bus

wire        MWCfgDone;
// Register bit indicating the completion of the MW bits
// programming after reset

wire        CntEZEnd;
// Timer counter expiry signal when count values are zero

wire        MemRdOverCo;
// Combinational version of the MemRdOver

wire        FastRdOp;
// In case of Burst reads when the buffer has more data than required by current
// AHB transfer, it is possible to provide the subsequent data from the
// internal buffer if the next sequential addresses are in the same field in
// zero cycles. So speculative advance reads are not done

wire        OEnCntEZ;
// This signal is generated to determine whether the OEnCount delay value is
// equal to zero

wire        WEnCntEZ;
// This signal is generated to determine whether the WrEnCount delay value is
// equal to zero

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

// -----------------------------------------------------------------------------
// Instantiation of SmcSynchroniser
// -----------------------------------------------------------------------------
SmcSynchroniser uSmcSynchroniser (
        .HCLK            (HCLK),
        .HRESETn         (HRESETn),
        .SMWAIT          (SMWAIT),
        .CANCELSMWAIT    (CANCELSMWAIT),

        .SmWaitS2        (SmWaitS2),
        .CnclSmWaitS2    (CnclSmWaitS2)
           );

// -----------------------------------------------------------------------------
// Instantiation of SmcAhbif
// -----------------------------------------------------------------------------
SmcAhbif uSmcAhbif (
// Inputs
        .HCLK            (HCLK),
        .HRESETn         (HRESETn),
        .SMMWCS7         (SMMWCS7),
        .SMRBLECS7       (SMRBLECS7),
        .HREADYIN        (HREADYIN),
        .HSELSMC         (HSELSMC),
        .HSELREG         (HSELREG),
        .HWRITE          (HWRITE),
        .HADDR           (HADDR),
        .HWDATA          (HWDATA[7:0]),
        .HSIZE           (HSIZE),
        .HTRANS          (HTRANS),
        .HBURST          (HBURST),
        .REMAP           (REMAP),
        .Revision        (Revision),
        .WaitToutErr     (WaitToutErr),
        .MemWrOver       (MemWrOver),
        .MemWrOverCo     (MemWrOverCo),
        .MemRdOver       (MemRdOver),
        .RdWrBuf         (RdWrBuf),
        .SmcAddrReg      (SmcAddrReg),
        .MemRdOverCo     (MemRdOverCo),
        .BMRdTrans       (BMRdTrans),
// Outputs
        .BufWrOver       (BufWrOver),
        .BankCmpCo       (BankCmpCo),
        .MemWrReq        (MemWrReq),
        .MemRdReq        (MemRdReq),
        .WtdWrReq        (WtdWrReq),
        .WtdRdReq        (WtdRdReq),
        .MwPgm           (MwPgm),
        .MSize08         (MSize08),
        .MSize16         (MSize16),
        .MSize32         (MSize32),
        .MW              (MW),
        .HTransRegCo     (HTransRegCo),
        .HSizeRegCo      (HSizeRegCo),
        .BM              (BM),
        .RBLE            (RBLE),
        .WaitEn          (WaitEn),
        .WaitPol         (WaitPol),
        .CSPol           (CSPol),
        .WST1            (WST1),
        .WST2            (WST2),
        .WSTOEN          (WSTOEN),
        .WSTWEN          (WSTWEN),
        .IDCY            (IDCY),
        .HAddrCrnt       (HAddrCrnt),
        .HAddrWtdCo      (HAddrWtdCo),
        .BnkAddStrCo     (BnkAddStrCo),
        .HREADYOUT       (HREADYOUT),
        .HRESP           (HRESP),
        .HRDATA          (HRDATA),
        .BufByPassCo     (BufByPassCo),
        .HBurstRegCo     (HBurstRegCo),
        .RemapReg        (RemapReg),
        .AhbRdOver       (AhbRdOver),
        .MWCfgDone       (MWCfgDone)
           );

// -----------------------------------------------------------------------------
// Instantiation of SmcEIB
// -----------------------------------------------------------------------------
SmcEIB uSmcEIB (
        .HCLK            (HCLK),
        .HRESETn         (HRESETn),
        .HWDATA          (HWDATA),
        .HSizeRegCo      (HSizeRegCo),
        .MSize08         (MSize08),
        .MSize16         (MSize16),
        .MSize32         (MSize32),
        .BIGENDIAN       (BIGENDIAN),
        .RemapReg        (RemapReg),
        .RBLE            (RBLE),
        .BM              (BM),
        .CSPol           (CSPol),
        .SMCsEnCo        (SMCsEnCo),
        .SMCDATAIN       (SMCDATAIN),
        .SmcState        (SmcState),
        .CntEnd          (CntEnd),
        .HAddrCrnt       (HAddrCrnt),
        .HAddrWtdCo      (HAddrWtdCo),
        .BnkAddStrCo     (BnkAddStrCo),
        .AddrIncCo       (AddrIncCo),
        .MemWrReq        (MemWrReq),
        .MemRdReq        (MemRdReq),
        .WtdWrReq        (WtdWrReq),
        .WtdRdReq        (WtdRdReq),
        .MwPgm           (MwPgm),
        .BufWrOver       (BufWrOver),
        .ExtWrEnCo       (ExtWrEnCo),
        .ExtWrDisCo      (ExtWrDisCo),
        .RdCntLdCo       (RdCntLdCo),
        .XoutEnCo        (XoutEnCo),
        .XoutDisCo       (XoutDisCo),
        .XdatDisCo       (XdatDisCo),
        .RdXdatEnCo      (RdXdatEnCo),
        .WrXdatEnCo      (WrXdatEnCo),
        .BufByPassCo     (BufByPassCo),
        .BrstAddIncCo    (BrstAddIncCo),
        .BMRdTrans       (BMRdTrans),
        .HBurstRegCo     (HBurstRegCo),
        .CntEZEnd        (CntEZEnd),
        .MW              (MW),
        .HTransRegCo     (HTransRegCo),
        .FastRdOp        (FastRdOp),
        .WaitToutErr     (WaitToutErr),

        .PosSMWEN        (PosSMWEN),
        .PosSMBLS        (PosSMBLS),
        .SMCS            (SMCS),
        .SMCDATAOUT      (SMCDATAOUT),
        .SMCADDR         (SMCADDR),
        .nSMOEN          (nSMOEN),
        .nSMCDATAEN      (nSMCDATAEN),
        .MemWrOver       (MemWrOver),
        .MemWrOverCo     (MemWrOverCo),
        .MemRdOver       (MemRdOver),
        .MemRdOverCo     (MemRdOverCo),
        .BMlenEnd        (BMlenEnd),
        .RdWrBuf         (RdWrBuf),
        .AhbRdEn         (AhbRdEn),
        .SmcAddrReg      (SmcAddrReg)
           );

// -----------------------------------------------------------------------------
// Instantiation of SmcTSM
// -----------------------------------------------------------------------------
SmcTSM uSmcTSM (
        .HCLK            (HCLK),
        .HRESETn         (HRESETn),
        .HTransRegCo     (HTransRegCo),
        .BM              (BM),
        .MemWrReq        (MemWrReq),
        .MemRdReq        (MemRdReq),
        .WtdWrReq        (WtdWrReq),
        .WtdRdReq        (WtdRdReq),
        .SMBUSGNT        (SMBUSGNT),
        .CntEnd          (CntEnd),
        .DelayEnd        (DelayEnd),
        .WaitEn          (WaitEn),
        .BankCmpCo       (BankCmpCo),
        .WaitToutErr     (WaitToutErr),
        .BMlenEnd        (BMlenEnd),
        .BufWrOver       (BufWrOver),
        .MemWrOver       (MemWrOver),
        .MemRdOver       (MemRdOver),
        .MemRdOverCo     (MemRdOverCo),
        .BufByPassCo     (BufByPassCo),
        .HBurstRegCo     (HBurstRegCo),
        .AhbRdEn         (AhbRdEn),
        .AhbRdOver       (AhbRdOver),
        .HSizeRegCo      (HSizeRegCo),
        .MW              (MW),
        .MWCfgDone       (MWCfgDone),
        .OEnCntEZ        (OEnCntEZ),
        .WEnCntEZ        (WEnCntEZ),
        .CntEZEnd        (CntEZEnd),
        .RBLE            (RBLE),
        .BnkAddStrCo     (BnkAddStrCo),

        .SmcState        (SmcState),
        .SMBUSREQ        (SMBUSREQ),
        .RdCntLdCo       (RdCntLdCo),
        .RdBMcntLdCo     (RdBMcntLdCo),
        .WrCntLdCo       (WrCntLdCo),
        .TrArCntLdCo     (TrArCntLdCo),
        .ZeroIdleCo      (ZeroIdleCo),
        .OEnCntLdCo      (OEnCntLdCo),
        .WEnCntLdCo      (WEnCntLdCo),
        .ExtWrEnCo       (ExtWrEnCo),
        .ExtWrDisCo      (ExtWrDisCo),
        .XoutEnCo        (XoutEnCo),
        .XoutDisCo       (XoutDisCo),
        .XdatDisCo       (XdatDisCo),
        .RdXdatEnCo      (RdXdatEnCo),
        .WrXdatEnCo      (WrXdatEnCo),
        .AddrIncCo       (AddrIncCo),
        .BrstAddIncCo    (BrstAddIncCo),
        .BMRdTrans       (BMRdTrans),
        .SMCsEnCo        (SMCsEnCo),
        .FastRdOp        (FastRdOp)
           );

// -----------------------------------------------------------------------------
// Instantiation of SmcTimerWaitCont
// -----------------------------------------------------------------------------
SmcTimerWaitCont uSmcTimerWaitCont (
        .HCLK            (HCLK),
        .HRESETn         (HRESETn),
        .WST1            (WST1),
        .WST2            (WST2),
        .IDCY            (IDCY),
        .SmcState        (SmcState),
        .WSTWEN          (WSTWEN),
        .WSTOEN          (WSTOEN),
        .RdCntLdCo       (RdCntLdCo),
        .WrCntLdCo       (WrCntLdCo),
        .TrArCntLdCo     (TrArCntLdCo),
        .ZeroIdleCo      (ZeroIdleCo),
        .RdBMcntLdCo     (RdBMcntLdCo),
        .OEnCntLdCo      (OEnCntLdCo),
        .WEnCntLdCo      (WEnCntLdCo),
        .SmWaitS2        (SmWaitS2),
        .CnclSmWaitS2    (CnclSmWaitS2),
        .BM              (BM), 
        .WaitEn          (WaitEn),
        .WaitPol         (WaitPol),

        .CntEnd          (CntEnd),
        .DelayEnd        (DelayEnd),
        .WaitToutErr     (WaitToutErr),
        .OEnCntEZ        (OEnCntEZ),
        .WEnCntEZ        (WEnCntEZ),
        .CntEZEnd        (CntEZEnd)
           );

// -----------------------------------------------------------------------------
// Instantiation of SmcWrEnGen
// -----------------------------------------------------------------------------
SmcWrEnGen uSmcWrEnGen (
        .nHCLK           (nHCLK),
        .HCLK            (HCLK),
        .HRESETn         (HRESETn),
        .RBLE            (RBLE),
        .PosSMWEN        (PosSMWEN),
        .PosSMBLS        (PosSMBLS),
        .ExtWrEnCo       (ExtWrEnCo),
        .XoutEnCo        (XoutEnCo),

        .nSMWEN          (nSMWEN),
        .nSMBLS          (nSMBLS)
           );

endmodule
// --================================= End ===================================--
