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
// File Name              : SmcAhbif.v.rca
// File Revision          : 1.22
//
// Release Information    : PrimeCell(TM)-PL092-r1p3-01ltd0
//
// -----------------------------------------------------------------------------
// Purpose :
//           This module interfaces with the AHB bus.
//
// --=========================================================================--

`timescale 1ns/1ps

//Include Parameters File
`include "SmcParams.v"

// -----------------------------------------------------------------------------

module SmcAhbif (
// Inputs
                 HCLK,
                 HRESETn,
                 SMMWCS7,
                 SMRBLECS7,
                 HREADYIN,
                 HSELSMC,
                 HSELREG,
                 HWRITE,
                 HADDR,
                 HWDATA,
                 HSIZE,
                 HTRANS,
                 HBURST,
                 REMAP,
                 Revision,

                 WaitToutErr,
                 MemWrOver,
                 MemWrOverCo,
                 MemRdOver,
                 RdWrBuf,
                 SmcAddrReg,
                 MemRdOverCo,
                 BMRdTrans,

// Outputs
                 HREADYOUT,
                 HRESP,
                 HRDATA,

                 BufWrOver,
                 BankCmpCo,
                 MemWrReq,
                 MemRdReq,
                 WtdWrReq,
                 WtdRdReq,
                 MwPgm,
                 MSize08,
                 MSize16,
                 MSize32,
                 MW,
                 HTransRegCo,
                 HSizeRegCo,
                 BM,
                 RBLE,
                 WaitEn,
                 WaitPol,
                 CSPol,
                 WST1,
                 WST2,
                 WSTOEN,
                 WSTWEN,
                 IDCY,
                 HAddrCrnt,
                 HAddrWtdCo,
                 BnkAddStrCo,
                 BufByPassCo,
                 HBurstRegCo,
                 RemapReg,
                 AhbRdOver,
                 MWCfgDone
                );

// Inputs
input         HCLK;            // AHB Bus Clock
input         HRESETn;         // AHB system level Reset
input   [1:0] SMMWCS7;         // Hardwired input pins for configuring the
                               // MW bits of SMCBCR7 register at reset
input         SMRBLECS7;       // Hardwired input pins for configuring
                               // RBLE bit of SMCBCR7 register at reset
input         HREADYIN;        // Transfer completion input signal
input         HSELSMC;         // Select signal for the memory transfer by
                               // the SmcCore
input         HSELREG;         // Select signal for accessing the SmcCore
                               // internal registers
input         HWRITE;          // Signal to indicate the direction of
                               // transfer (read or write)
input  [28:0] HADDR;           // The address bus input from AHB
input   [7:0] HWDATA;          // Slice of the Write data input bus from AHB
input   [2:0] HSIZE;           // Transfer size indication
input   [1:0] HTRANS;          // Signal to indicate the current transfer
                               // type
input   [2:0] HBURST;          // The burst transfer information
                               // from AHB 
input         REMAP;           // Indicates the state of the Memory map
input   [3:0] Revision;        // Revision number from SmcRevAnd

input         WaitToutErr;     // Signal indicating the timeout error on
                               // SMWAIT
input         MemWrOver;       // Memory device write completion signal
input         MemWrOverCo;     // This signal is the combinational version
                               // of the MemWrOver
input         MemRdOver;       // Data read completion from the memory
input  [31:0] RdWrBuf;         // The registered Read data bus from the
                               // EIB
input   [3:1] SmcAddrReg;      // Registered splice version of
                               // SMCADDR bus
input         MemRdOverCo;     // Combinational version of the
                               // MemRdOver
input         BMRdTrans;       // This signal indicates that
                               // current transfer status is burst
                               // mode reads

// Outputs
output        HREADYOUT;       // This signal is used to indicate the
                               // completion of transfer
output  [1:0] HRESP;           // SmcCore response ouput
output [31:0] HRDATA;          // AHB read data bus

output        BufWrOver;       // Signal to flag completion of the write
                               // operation in the internal buffer
output        BankCmpCo;       // Signal which checks if the successive
                               // transfers are to the same bank
output        MemWrReq;        // Signal indicating the write transfer has
                               // been initiated
output        MemRdReq;        // Signal indicating the read transfer
                               // being initiated
output        WtdWrReq;        // Signal indicating that write transfer is
                               // pending on the AHB
output        WtdRdReq;        // Signal indicating that read transfer is
                               // pending on the AHB
output        MwPgm;           // Indicates that the Waited Read or Write
                               // Request is due to MW programming
output        MSize08;         // Signal to indicate that a 8-bit memory
                               // device is being targeted
output        MSize16;         // Signal to indicate that a 16-bit memory
                               // device is being targeted
output        MSize32;         // Signal to indicate that a 32-bit memory
                               // device is being targeted
output  [1:0] MW;              // The memory width bits selection from one
                               // of the bank registers
output  [1:0] HTransRegCo;     // Registered HTRANS for a current or
                               // waited transfer
output  [1:0] HSizeRegCo;      // Registered HSIZE for a current waited
                               // transfer
output        BM;              // Burst Mode
output        RBLE;            // Byte lane enabled device
output        WaitEn;          // Enable signal for using SMWAIT input
output        WaitPol;         // Indication of the polarity of SMWAIT
output  [7:0] CSPol;           // Indication of chip select polarity
output  [4:0] WST1;            // Read access count value of the bank
                               // targeted currently
output  [4:0] WST2;            // Write access count or Burst read value
                               // of the bank targeted currently
output  [3:0] WSTOEN;          // Delay value for the assertion of the OEN
output  [3:0] WSTWEN;          // Delay value for the assertion of the WEN
                               // and BLS signals
output  [3:0] IDCY;            // Count value for the turnaround cycles
output [25:0] HAddrCrnt;       // The registered HADDR for a new memory
                               // transfer
output [25:0] HAddrWtdCo;      // The combinational version of HAddrCrnt for a
                               // waited memory transfer
output  [2:0] BnkAddStrCo;     // Stored value of the Bank Address
output        BufByPassCo;     // This signal is used to indicate that the
                               // HSIZE = MSIZE and the RdWrBuf can be
                               // bypassed during write transfers
output  [2:0] HBurstRegCo;     // Registered HBURST signal from
                               // AHB interface block
output        RemapReg;        // Registered version of REMAP      
output        AhbRdOver;       // Signal to indicate the completion
                               // of read by AHB
output        MWCfgDone;       // Register bit indicating the
                               // completion of the MW bits
                               // programming after reset

// Inputs
wire          HCLK;            // AHB Bus Clock
wire          HRESETn;         // AHB system level reset
wire    [1:0] SMMWCS7;         // Hardwired input pins for configuring the
                               // MW bits of SMCBCR7 register at reset
wire          SMRBLECS7;       // Hardwired input pins for configuring
                               // RBLE bit of SMCBCR7 register at reset
wire          HREADYIN;        // Transfer completion input signal
wire          HSELSMC;         // Select signal for the memory transfer by
                               // the SmcCore
wire          HSELREG;         // Select signal for accessing the SmcCore
                               // internal registers
wire          HWRITE;          // Signal to indicate the direction of
                               // transfer (read or write)
wire   [28:0] HADDR;           // The address bus input from AHB
wire    [7:0] HWDATA;          // Slice of the Write data input bus from AHB
wire    [2:0] HSIZE;           // Transfer size indication
wire    [1:0] HTRANS;          // Signal to indicate the current transfer
                               // type
wire    [2:0] HBURST;          // The burst transfer information
                               // from AHB
wire          REMAP;           // Indicates the state of the Memory map
wire    [3:0] Revision;        // Revision number from SmcRevAnd

wire          WaitToutErr;     // Signal indicating the timeout error on
                               // SMWAIT
wire          MemWrOver;       // Memory device write completion signal
wire          MemWrOverCo;     // This signal is the combinational version
                               // of the MemWrOver
wire          MemRdOver;       // Data read completion from the memory
wire   [31:0] RdWrBuf;         // The registered Read data bus from the EIB
wire    [3:1] SmcAddrReg;      // Registered splice version of SMCADDR bus
wire          MemRdOverCo;     // Combinational version of the MemRdOver
wire          BMRdTrans;       // This signal indicates that
                               // current transfer status is burst
                               // mode reads

// Outputs
reg           HREADYOUT;       // This signal is used to indicate the
                               // completion of transfer
reg    [1:0]  HRESP;           // SmcCore response output
reg    [31:0] HRDATA;          // AHB read data bus

wire          BufWrOver;       // Signal to flag completion of the write
                               // operation in the internal buffer
reg           BankCmpCo;       // Signal which checks if the successive
                               // transfers are to the same bank
wire          MemWrReq;        // Signal indicating the write transfer has
                               // been initiated
wire          MemRdReq;        // Signal indicating the read transfer
                               // being initiated
wire          WtdWrReq;        // Signal indicating that write transfer is
                               // pending on the AHB
wire          WtdRdReq;        // Signal indicating that read transfer is
                               // pending on the AHB
wire          MwPgm;           // Indicates that the Waited Read or Write
                               // Request is due to MW programming
wire          MSize08;         // Signal to indicate that a 8-bit memory
                               // device is being targeted
wire          MSize16;         // Signal to indicate that a 16-bit memory
                               // device is being targeted
wire          MSize32;         // Signal to indicate that a 32-bit memory
                               // device is being targeted
wire    [1:0] MW;              // The memory width bits selection from one
                               // of the bank registers
wire    [1:0] HTransRegCo;     // Registered HTRANS for a current or
                               // waited transfer
wire    [1:0] HSizeRegCo;      // Registered HSIZE for a current waited
                               // transfer
wire          WaitEn;          // Enable signal for using SMWAIT input
wire    [7:0] CSPol;           // Indication of chip select polarity
wire   [25:0] HAddrCrnt;       // The registered HADDR for a new memory
                               // transfer
wire   [25:0] HAddrWtdCo;      // The registered HADDR for a waited
                               // memory transfer
wire    [2:0] BnkAddStrCo;     // Stored value of the Bank Address
wire          BufByPassCo;     // This signal is used to indicate that the
                               // HSIZE = MSIZE and the RdWrBuf can be
                               // bypassed during transfers
wire    [2:0] HBurstRegCo;     // Registered HBURST signal from
                               // AHB interface block
wire          RemapReg;        // Registered version of  REMAP
reg           AhbRdOver;       // Signal to indicate the completion
                               // of read by AHB
wire          MWCfgDone;       // Register bit indicating the
                               // completion of the MW bits
                               // programming after reset

// -----------------------------------------------------------------------------
//
//                                  SmcAhbif
//                                  ========
//
// -----------------------------------------------------------------------------
//
// Overview
// ========
//           It consists of the AHB response generation logic, the memory
//           device parameter registers, control registers and status registers.
//
// -----------------------------------------------------------------------------
//                          SMC Control Register Map
// -----------------------------------------------------------------------------
// Offset  Read (Width)          Write (Width)       Description
// -----------------------------------------------------------------------------
//                              Memory Bank 0

// 0x000 SMBIDCYR0(4-bit)     SMCIDCYR0(4-bit)     Idle Cycle
// 0x004 SMBWST1R0(5-bit)     SMBWST1R0(5-bit)     Wait State 1
// 0x008 SMBWST2R0(5-bit)     SMBWST2R0(5-bit)     Wait State 2
// 0x00C SMBWSTOENR0(4-bit)   SMBWSTOENR0(4-bit)   OE Assertion Delay
// 0x010 SMBWSTWENR0(4-bit)   SMBWSTWENR0(4-bit)   WE Assertion Delay
// 0x014 SMBCR0(8-bit)        SMBCR0(8-bit)        Control Register
// 0x018 SMBSR0(4-bit)        SMBSR0(3-bit)        Status Register

//                              Memory Bank 1

// 0x01C SMBIDCYR1(4-bit)     SMCIDCYR1(4-bit)     Idle Cycle
// 0x020 SMBWST1R1(5-bit)     SMBWST1R1(5-bit)     Wait State 1
// 0x024 SMBWST2R1(5-bit)     SMBWST2R1(5-bit)     Wait State 2
// 0x028 SMBWSTOENR1(4-bit)   SMBWSTOENR1(4-bit)   OE Assertion Delay
// 0x02C SMBWSTWENR1(4-bit)   SMBWSTWENR1(4-bit)   WE Assertion Delay
// 0x030 SMBCR1(8-bit)        SMBCR1(8-bit)        Control Register
// 0x034 SMBSR1(4-bit)        SMBSR1(3-bit)        Status Register

//                              Memory Bank 2

// 0x038 SMBIDCYR2(4-bit)     SMCIDCYR2(4-bit)     Idle Cycle
// 0x03C SMBWST1R2(5-bit)     SMBWST1R2(5-bit)     Wait State 1
// 0x040 SMBWST2R2(5-bit)     SMBWST2R2(5-bit)     Wait State 2
// 0x044 SMBWSTOENR2(4-bit)   SMBWSTOENR2(4-bit)   OE Assertion Delay
// 0x048 SMBWSTWENR2(4-bit)   SMBWSTWENR2(4-bit)   WE Assertion Delay
// 0x04C SMBCR2(8-bit)        SMBCR2(8-bit)        Control Register
// 0x050 SMBSR2(4-bit)        SMBSR2(3-bit)        Status Register

//                              Memory Bank 3

// 0x054 SMBIDCYR3(4-bit)     SMCIDCYR3(4-bit)     Idle Cycle
// 0x058 SMBWST1R3(5-bit)     SMBWST1R3(5-bit)     Wait State 1
// 0x05C SMBWST2R3(5-bit)     SMBWST2R3(5-bit)     Wait State 2
// 0x060 SMBWSTOENR3(4-bit)   SMBWSTOENR3(4-bit)   OE Assertion Delay
// 0x064 SMBWSTWENR3(4-bit)   SMBWSTWENR3(4-bit)   WE Assertion Delay
// 0x068 SMBCR3(8-bit)        SMBCR3(8-bit)        Control Register
// 0x06C SMBSR3(4-bit)        SMBSR3(3-bit)        Status Register

//                              Memory Bank 4

// 0x070 SMBIDCYR4(4-bit)     SMCIDCYR4(4-bit)     Idle Cycle
// 0x074 SMBWST1R4(5-bit)     SMBWST1R4(5-bit)     Wait State 1
// 0x078 SMBWST2R4(5-bit)     SMBWST2R4(5-bit)     Wait State 2
// 0x07C SMBWSTOENR4(4-bit)   SMBWSTOENR4(4-bit)   OE Assertion Delay
// 0x080 SMBWSTWENR4(4-bit)   SMBWSTWENR4(4-bit)   WE Assertion Delay
// 0x084 SMBCR4(8-bit)        SMBCR4(8-bit)        Control Register
// 0x088 SMBSR4(4-bit)        SMBSR4(3-bit)        Status Register

//                              Memory Bank 5

// 0x08C SMBIDCYR5(4-bit)     SMCIDCYR5(4-bit)     Idle Cycle
// 0x090 SMBWST1R5(5-bit)     SMBWST1R5(5-bit)     Wait State 1
// 0x094 SMBWST2R5(5-bit)     SMBWST2R5(5-bit)     Wait State 2
// 0x098 SMBWSTOENR5(4-bit)   SMBWSTOENR5(4-bit)   OE Assertion Delay
// 0x09C SMBWSTWENR5(4-bit)   SMBWSTWENR5(4-bit)   WE Assertion Delay
// 0x0A0 SMBCR5(8-bit)        SMBCR5(8-bit)        Control Register
// 0x0A4 SMBSR5(4-bit)        SMBSR5(3-bit)        Status Register

//                              Memory Bank 6

// 0x0A8 SMBIDCYR6(4-bit)     SMCIDCYR6(4-bit)     Idle Cycle
// 0x0AC SMBWST1R6(5-bit)     SMBWST1R6(5-bit)     Wait State 1
// 0x0B0 SMBWST2R6(5-bit)     SMBWST2R6(5-bit)     Wait State 2
// 0x0B4 SMBWSTOENR6(4-bit)   SMBWSTOENR6(4-bit)   OE Assertion Delay
// 0x0B8 SMBWSTWENR6(4-bit)   SMBWSTWENR6(4-bit)   WE Assertion Delay
// 0x0BC SMBCR6(8-bit)        SMBCR6(8-bit)        Control Register
// 0x0C0 SMBSR6(4-bit)        SMBSR6(3-bit)        Status Register

//                              Memory Bank 7

// 0x0C4 SMBIDCYR7(4-bit)     SMCIDCYR7(4-bit)     Idle Cycle
// 0x0C8 SMBWST1R7(5-bit)     SMBWST1R7(5-bit)     Wait State 1
// 0x0CC SMBWST2R7(5-bit)     SMBWST2R7(5-bit)     Wait State 2
// 0x0D0 SMBWSTOENR7(4-bit)   SMBWSTOENR7(4-bit)   OE Assertion Delay
// 0x0D4 SMBWSTWENR7(4-bit)   SMBWSTWENR7(4-bit)   WE Assertion Delay
// 0x0D8 SMBCR7(8-bit)        SMBCR7(8-bit)        Control Register
// 0x0DC SMBSR7(4-bit)        SMBSR7(3-bit)        Status Register

//                        SMC Identification Registers

// 0xFE0 SMCPeriphID0(8-bit)          -            Peripheral Id register0
// 0xFE4 SMCPeriphID1(8-bit)          -            Peripheral Id register1
// 0xFE8 SMCPeriphID2(8-bit)          -            Peripheral Id register2
// 0xFEC SMCPeriphID3(8-bit)          -            Peripheral Id register3
// 0xFF0 SMCPCellID0(8-bit)           -            Prime Cell Id register0
// 0xFF4 SMCPCellID1(8-bit)           -            Prime Cell Id register1
// 0xFF8 SMCPCellID2(8-bit)           -            Prime Cell Id register2
// 0xFFC SMCPCellID3(8-bit)           -            Prime Cell Id register3
//
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Constant declarations
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Wire declarations
// -----------------------------------------------------------------------------
reg         HSizeErr;
// Signal indicating the transfer size error

wire        NextHSizeErr;
// D-input of HSizeErr

wire  [7:0] SMCPeriphID0;
// Peripheral ID Register0 Bits

wire  [7:0] SMCPeriphID1;
// Peripheral ID Register1 Bits

wire  [3:0] SMCPeriphID2;
// Peripheral ID Register2 Bits

wire  [7:0] SMCPeriphID3;
// Peripheral ID Register3 Bits

wire  [7:0] SMCPCellID0;
// Prime Cell ID Register0 Bits

wire  [7:0] SMCPCellID1;
// Prime Cell ID Register1 Bits

wire  [7:0] SMCPCellID2;
// Prime Cell ID Register2 Bits

wire  [7:0] SMCPCellID3;
// Prime Cell ID Register3 Bits

wire        SMBCR7WrEn;
// SMBCR7 Write Enable signal

wire [11:2] HAddrGated;
// Gated HADDR to reduce the power comsumption

wire  [7:0] HWdataGtd;
// Gated HWDATA to reduce the power comsumption

wire  [1:0] HAddrSel;
// The lower order of registered address selected, depending on whether transfer
// is a new transfer or a waited transfer

wire        NextCrntMemWr;
// D-input of CrntMemWr

wire        NextWtdMemWr;
// D-input of WtdMemWr

wire        NextBufWrOvStr;
// D-input of BufWrOvStr

wire        NextMemRdTrans;
// D-input of MemRdTrans

wire        NextWtdRegWr;
// D-input of WtdRegWr

wire        NextWtdRegRd;
// D-input of WtdRegRd

wire        NextWtdRegRdEn;
// D-input of WtdRegRdEn

wire        NextRegWrEn;
// D-input of RegWrEn

wire        NextRegRdEn;
// D-input of RegRdEn

wire  [1:0] HSizeSel;
// One of the HSizeReg or HSizeWtd is selected, depending on whether transfer
// is a new transfer or a waited transfer

wire        NextWtdWrReq;
// D-input of the WtdWrReq

wire        NxtAddrContStr;
// D-input of AddrContStr

wire        NextMemWrReq;
// D-input of the MemWrReq

wire        NextMemRdReq;
// D-input of the MemRdReq

wire        NextWtdRdReq;
// D-input of the WtdRdReq

wire        NextWpErrTmp;
// D-input of the WpErrTmp

wire        NextNewTrans;
// D-input of the NewTrans

wire        NextCrntMemWrBa;
// D-input of CrntMemWrBa

wire        NextPartWtdWr;
// D-input of PartWtdWr

wire        NextBusyInBM;
// D-input of BusyInBM

wire  [2:0] NextBankAddr;
// D-input of BankAddr

wire        HSelRegCo;
// HSELREG qualified with HREADYIN

// -----------------------------------------------------------------------------
// Zero fill for register reads to return zeros in unused bit positions
// -----------------------------------------------------------------------------
wire [31:0] ZEROFILL;

// -----------------------------------------------------------------------------
// Register declarations
// -----------------------------------------------------------------------------
reg         AddrContStr;
// Combinational signal used to store the HADDR for waited/pending
// write or read transfer

reg         BM;
// Burst Mode

reg         RBLE;
// Byte lane enabled device

reg         WaitPol;
// Indication of the polarity of SMWAIT

reg   [4:0] WST1;
// Read access count value of the bank
// targeted currently

reg   [4:0] WST2;
// Write access count or Burst read value
// of the bank targeted currently

reg   [3:0] WSTOEN;
// Delay value for the assertion of the OEN

reg   [3:0] WSTWEN;
// Delay value for the assertion of the WEN
// and BLS signals

reg   [3:0] IDCY;
 // Count value for the turnaround cycles

reg         iMWCfgDone;
// Register bit indicating the completion of the MW bits programming after
// reset

reg         NextMWCfgDone;
// D-input of the MWCfgDone signal

reg         HResetDet1;
reg         HResetDet2;
// Signals to detect the reset condition on the HRESETn input pin

reg         WP;
// Local Copy of Write Protect bit

reg  [11:2] HAddrReg;
// The HAddr slice used during Internal register read & write

reg  [11:2] NextHAddrReg;
// D-input of HAddrReg

reg   [1:0] HTransCrnt;
// Internal version of HTransCrnt

reg   [1:0] NextHTransCrnt;
// D-input of HTransCrnt

reg   [1:0] HTransWtd;
// Internal version of HTransWtd

reg   [1:0] NextHTransWtd;
// D-input of HTransWtd

reg   [1:0] iHTransReg;
// Internal version of HTransReg

reg   [1:0] NextHTransReg;
// D-input of HTransReg

reg         HWriteReg;
// Internally registered HWRITE

reg         NextHWriteReg;
// D-input of HWriteReg

reg   [3:0] SMBIDCYR0;
// Idle cycle Control Register for Bank 0

reg   [4:0] SMBWST1R0;
// Wait State 1 Control Register for Bank

reg   [4:0] SMBWST2R0;
// Wait State 2 control Register for Bank 0

reg   [3:0] SMBWSTOENR0;
// OE Assertion Delay Control Register for Bank 0

reg   [3:0] SMBWSTWENR0;
// WE Assertion Delay Control Register for Bank 0

reg   [7:0] SMBCR0;
// Control Register for Bank 0

reg   [3:0] SMBIDCYR1;
// Idle cycle Control Register for Bank 1

reg   [4:0] SMBWST1R1;
// Wait State 1 Control Register for Bank 1

reg   [4:0] SMBWST2R1;
// Wait State 2 control Register for Bank 1

reg   [3:0] SMBWSTOENR1;
// OE Assertion Delay Control Register for Bank 1

reg   [3:0] SMBWSTWENR1;
// WE Assertion Delay Control Register for Bank 1

reg   [7:0] SMBCR1;
// Control Register for Bank 1

reg   [3:0] SMBIDCYR2;
// Idle cycle Control Register for Bank 2

reg   [4:0] SMBWST1R2;
// Wait State 1 Control Register for Bank 2

reg   [4:0] SMBWST2R2;
// Wait State 2 control Register for Bank 2

reg   [3:0] SMBWSTOENR2;
// OE Assertion Delay Control Register for Bank 2

reg   [3:0] SMBWSTWENR2;
// WE Assertion Delay Control Register for Bank 2

reg   [7:0] SMBCR2;
// Control Register for Bank 2

reg   [3:0] SMBIDCYR3;
// Idle cycle Control Register for Bank 3

reg   [4:0] SMBWST1R3;
// Wait State 1 Control Register for Bank 3

reg   [4:0] SMBWST2R3;
// Wait State 2 control Register for Bank 3

reg   [3:0] SMBWSTOENR3;
// OE Assertion Delay Control Register for Bank 3

reg   [3:0] SMBWSTWENR3;
// WE Assertion Delay Control Register for Bank 3

reg   [7:0] SMBCR3;
// Control Register for Bank 3

reg   [3:0] SMBIDCYR4;
// Idle cycle Control Register for Bank 4

reg   [4:0] SMBWST1R4;
// Wait State 1 Control Register for Bank 4

reg   [4:0] SMBWST2R4;
// Wait State 2 control Register for Bank 4

reg   [3:0] SMBWSTOENR4;
// OE Assertion Delay Control Register for Bank 4

reg   [3:0] SMBWSTWENR4;
// WE Assertion Delay Control Register for Bank 4

reg   [7:0] SMBCR4;
// Control Register for Bank 4

reg   [3:0] SMBIDCYR5;
// Idle cycle Control Register for Bank 5

reg   [4:0] SMBWST1R5;
// Wait State 1 Control Register for Bank 5

reg   [4:0] SMBWST2R5;
// Wait State 2 control Register for Bank 5

reg   [3:0] SMBWSTOENR5;
// OE Assertion Delay Control Register for Bank 5

reg   [3:0] SMBWSTWENR5;
// WE Assertion Delay Control Register for Bank 5

reg   [7:0] SMBCR5;
// Control Register for Bank 5

reg   [3:0] SMBIDCYR6;
// Idle cycle Control Register for Bank 6

reg   [4:0] SMBWST1R6;
// Wait State 1 Control Register for Bank 6

reg   [4:0] SMBWST2R6;
// Wait State 2 control Register for Bank 6

reg   [3:0] SMBWSTOENR6;
// OE Assertion Delay Control Register for Bank 6

reg   [3:0] SMBWSTWENR6;
// WE Assertion Delay Control Register for Bank 6

reg   [7:0] SMBCR6;
// Control Register for Bank 6

reg   [3:0] SMBIDCYR7;
// Idle cycle Control Register for Bank 7

reg   [4:0] SMBWST1R7;
// Wait State 1 Control Register for Bank 7

reg   [4:0] SMBWST2R7;
// Wait State 2 control Register for Bank 7

reg   [3:0] SMBWSTOENR7;
// OE Assertion Delay Control Register for Bank 7

reg   [3:0] SMBWSTWENR7;
// WE Assertion Delay Control Register for Bank 7

reg   [7:0] SMBCR7;
// Control Register for Bank 7

reg   [3:0] NextSMBIDCYR0;
// D-input of Idle cycle Control Register for Bank 0

reg   [4:0] NextSMBWST1R0;
// D-input of Wait State 1 Control Register for Bank

reg   [4:0] NextSMBWST2R0;
// D-input of Wait State 2 control Register for Bank 0

reg   [3:0] NextSMBWSTOENR0;
// D-input of OE Assertion Delay Control Register for Bank 0

reg   [3:0] NextSMBWSTWENR0;
// D-input of WE Assertion Delay Control Register for Bank 0

reg   [7:0] NextSMBCR0;
// D-input of Control Register for Bank 0

reg   [3:0] NextSMBIDCYR1;
// D-input of Idle cycle Control Register for Bank 1

reg   [4:0] NextSMBWST1R1;
// D-input of Wait State 1 Control Register for Bank 1

reg   [4:0] NextSMBWST2R1;
// D-input of Wait State 2 control Register for Bank 1

reg   [3:0] NextSMBWSTOENR1;
// D-input of OE Assertion Delay Control Register for Bank 1

reg   [3:0] NextSMBWSTWENR1;
// D-input of WE Assertion Delay Control Register for Bank 1

reg   [7:0] NextSMBCR1;
// D-input of Control Register for Bank 1

reg   [3:0] NextSMBIDCYR2;
// D-input of Idle cycle Control Register for Bank 2

reg   [4:0] NextSMBWST1R2;
// D-input of Wait State 1 Control Register for Bank 2

reg   [4:0] NextSMBWST2R2;
// D-input of Wait State 2 control Register for Bank 2

reg   [3:0] NextSMBWSTOENR2;
// D-input of OE Assertion Delay Control Register for Bank 2

reg   [3:0] NextSMBWSTWENR2;
// D-input of WE Assertion Delay Control Register for Bank 2

reg   [7:0] NextSMBCR2;
// D-input of Control Register for Bank 2

reg   [3:0] NextSMBIDCYR3;
// D-input of Idle cycle Control Register for Bank 3

reg   [4:0] NextSMBWST1R3;
// D-input of Wait State 1 Control Register for Bank 3

reg   [4:0] NextSMBWST2R3;
// D-input of Wait State 2 control Register for Bank 3

reg   [3:0] NextSMBWSTOENR3;
// D-input of OE Assertion Delay Control Register for Bank 3

reg   [3:0] NextSMBWSTWENR3;
// D-input of WE Assertion Delay Control Register for Bank 3

reg   [7:0] NextSMBCR3;
// D-input of Control Register for Bank 3

reg   [3:0] NextSMBIDCYR4;
// D-input of Idle cycle Control Register for Bank 4

reg   [4:0] NextSMBWST1R4;
// D-input of Wait State 1 Control Register for Bank 4

reg   [4:0] NextSMBWST2R4;
// D-input of Wait State 2 control Register for Bank 4

reg   [3:0] NextSMBWSTOENR4;
// D-input of OE Assertion Delay Control Register for Bank 4

reg   [3:0] NextSMBWSTWENR4;
// D-input of WE Assertion Delay Control Register for Bank 4

reg   [7:0] NextSMBCR4;
// D-input of Control Register for Bank 4

reg   [3:0] NextSMBIDCYR5;
// D-input of Idle cycle Control Register for Bank 5

reg   [4:0] NextSMBWST1R5;
// D-input of Wait State 1 Control Register for Bank 5

reg   [4:0] NextSMBWST2R5;
// D-input of Wait State 2 control Register for Bank 5

reg   [3:0] NextSMBWSTOENR5;
// D-input of OE Assertion Delay Control Register for Bank 5

reg   [3:0] NextSMBWSTWENR5;
// D-input of WE Assertion Delay Control Register for Bank 5

reg   [7:0] NextSMBCR5;
// D-input of Control Register for Bank 5

reg   [3:0] NextSMBIDCYR6;
// D-input of Idle cycle Control Register for Bank 6

reg   [4:0] NextSMBWST1R6;
// D-input of Wait State 1 Control Register for Bank 6

reg   [4:0] NextSMBWST2R6;
// D-input of Wait State 2 control Register for Bank 6

reg   [3:0] NextSMBWSTOENR6;
// D-input of OE Assertion Delay Control Register for Bank 6

reg   [3:0] NextSMBWSTWENR6;
// D-input of WE Assertion Delay Control Register for Bank 6

reg   [7:0] NextSMBCR6;
// D-input of Control Register for Bank 6

reg   [3:0] NextSMBIDCYR7;
// D-input of Idle cycle Control Register for Bank 7

reg   [4:0] NextSMBWST1R7;
// D-input of Wait State 1 Control Register for Bank 7

reg   [4:0] NextSMBWST2R7;
// D-input of Wait State 2 control Register for Bank 7

reg   [3:0] NextSMBWSTOENR7;
// D-input of OE Assertion Delay Control Register for Bank 7

reg   [3:0] NextSMBWSTWENR7;
// D-input of WE Assertion Delay Control Register for Bank 7

reg         RegWrEn;
// Write enable signal for the internal registers

reg         WtdRegWr;
// Waited WR to register if transfer is attempted when MWCfgDone=0

reg         RegRdEn;
// Read enable signal from the internal registers

reg         WtdRegRd;
// Waited RD to register if transfer is attempted when MWCfgDone=0

reg         WtdRegRdEn;
// Waited read enable after the MWCfgDone becomes 1

reg         HSelREGD1;
// One clock delayed version of HSELREG

reg   [1:0] iHRESPMem;
// Internal version of the HRESPMem

reg   [1:0] iHRESPReg;
// Internal version of the HRESPReg

reg   [1:0] NextHRESPMem;
//D-input of the HRESPMem

reg   [1:0] NextHRESPReg;
// D-input of the HRESPReg

reg         iHREADYOUTMem;
// Internal version of the HREADYOUTMem 

reg         iHREADYOUTReg;
// Internal version of the HREADYOUTReg 

reg         NextHREADYOUTMem;
// D-input of the HREADYOUTMem

reg         NextHREADYOUTReg;
// D-input of the HREADYOUTReg

reg         iMemWrReq;
// Internal version of the MemWrReq signal

reg         iWtdWrReq;
// Internal version of the WtdWrReq signal

reg         iWtdRdReq;
// Internal version of the WtdRdReq signal

reg         iMwPgm;
// Internal version of the MwPgm signal

reg         NextMwPgm;
// D-input of the MwPgm

reg         WpErrTmp;
// temporary combinational signal to flag the write protect error

reg         iWaitEn;
// Internal version of WaitEn

reg         NextWaitEn;
// D-input of the WaitEn

reg         Wait1Cyc;
// Signal used for inserting 1 wait cycle

reg         NextWait1Cyc;
// D-input of the Wait1Cyc

reg         IntHSelReg;
// Internal registered version of HSELREG

reg         NextIntHSelReg;
// D-input of the IntHSelReg

reg   [7:0] iCSPol;
// Internal copy of CSPol

reg   [7:0] NextCSPol;
// D-input of CSPol

reg         iMSize08;
// Internal copy of MSize08

reg         iMSize16;
// Internal copy of MSize16

reg         iMSize32;
// Internal copy of MSize32

reg  [28:0] iHAddrCrnt;
// Internal version of HAddrCrnt

reg  [28:0] NextHAddrCrnt;
// D-input of HAddrCrnt

reg  [25:0] iHAddrWtd;
// Internal version of HAddrWtd

reg  [25:0] NextHAddrWtd;
// D-input of HAddrWtd

reg   [1:0] HSizeCrnt;
// Internal copy of HSizeCrnt

reg   [1:0] NextHSizeCrnt;
// D-input of HSizeCrnt

reg   [1:0] HSizeWtd;
// Internal copy of HSizeWtd

reg   [1:0] NextHSizeWtd;
// D-input of HSizeWtd

reg   [1:0] iHSizeReg;
// Internal copy of HSizeReg

reg   [1:0] NextHSizeReg;
// D-input of HSizeReg

reg   [1:0] iMW;
// The memory width bits selection from one of the bank registers

reg   [1:0] NextMW;
// D-input of MW

reg   [7:0] NextSMBCR7;
// D-input of Control Register for Bank 7

reg         iMemRdReq;
// Internal version of the MemRdReq signal

reg         ToutErrClr0;
reg         ToutErrClr1;
reg         ToutErrClr2;
reg         ToutErrClr3;
reg         ToutErrClr4;
reg         ToutErrClr5;
reg         ToutErrClr6;
reg         ToutErrClr7;
// Signals to clear the WaitToutErr status flag bit

reg         WPErrClr0;
reg         WPErrClr1;
reg         WPErrClr2;
reg         WPErrClr3;
reg         WPErrClr4;
reg         WPErrClr5;
reg         WPErrClr6;
reg         WPErrClr7;
// Signals to clear the WrProtErr status flag bit

reg         HSizeErrClr0;
reg         HSizeErrClr1;
reg         HSizeErrClr2;
reg         HSizeErrClr3;
reg         HSizeErrClr4;
reg         HSizeErrClr5;
reg         HSizeErrClr6;
reg         HSizeErrClr7;
// Signals to clear the HSizeErr status flag bit

reg   [2:0] iBnkAddStr;
// Internal copy of BnkAddStr

reg   [2:0] NextBnkAddStr;
// D-input of BnkAddStr

reg   [2:0] BnkAddWtd;
// Internal copy of BnkAddWtd

reg   [2:0] NextBnkAddWtd;
// D-input of BnkAddWtd

reg         ToutErrGen0;
reg         ToutErrGen1;
reg         ToutErrGen2;
reg         ToutErrGen3;
reg         ToutErrGen4;
reg         ToutErrGen5;
reg         ToutErrGen6;
reg         ToutErrGen7;
// Generation of the WaitToutErr for different banks

reg         WPErrGen0;
reg         WPErrGen1;
reg         WPErrGen2;
reg         WPErrGen3;
reg         WPErrGen4;
reg         WPErrGen5;
reg         WPErrGen6;
reg         WPErrGen7;
// Generation of the WrProtErr for different banks

reg         HSizeErrGen0;
reg         HSizeErrGen1;
reg         HSizeErrGen2;
reg         HSizeErrGen3;
reg         HSizeErrGen4;
reg         HSizeErrGen5;
reg         HSizeErrGen6;
reg         HSizeErrGen7;
// Generation of the HSizeErr for different banks

reg         ToutErrR0;
reg         ToutErrR1;
reg         ToutErrR2;
reg         ToutErrR3;
reg         ToutErrR4;
reg         ToutErrR5;
reg         ToutErrR6;
reg         ToutErrR7;
// The WaitToutErr storage flag register

reg         NextToutErrR0;
reg         NextToutErrR1;
reg         NextToutErrR2;
reg         NextToutErrR3;
reg         NextToutErrR4;
reg         NextToutErrR5;
reg         NextToutErrR6;
reg         NextToutErrR7;
// D-input of ToutErrR0 to ToutErrR7

reg         WPErrReg0;
reg         WPErrReg1;
reg         WPErrReg2;
reg         WPErrReg3;
reg         WPErrReg4;
reg         WPErrReg5;
reg         WPErrReg6;
reg         WPErrReg7;
// The WrProtErr storage flag register

reg         NextWPErrReg0;
reg         NextWPErrReg1;
reg         NextWPErrReg2;
reg         NextWPErrReg3;
reg         NextWPErrReg4;
reg         NextWPErrReg5;
reg         NextWPErrReg6;
reg         NextWPErrReg7;
// D-input of NextWPErrReg0 to NextWPErrReg7

reg         HSizeErrR0;
reg         HSizeErrR1;
reg         HSizeErrR2;
reg         HSizeErrR3;
reg         HSizeErrR4;
reg         HSizeErrR5;
reg         HSizeErrR6;
reg         HSizeErrR7;
// The HSizeErr storage flag register

reg         NextHSizeErrR0;
reg         NextHSizeErrR1;
reg         NextHSizeErrR2;
reg         NextHSizeErrR3;
reg         NextHSizeErrR4;
reg         NextHSizeErrR5;
reg         NextHSizeErrR6;
reg         NextHSizeErrR7;
// D-input of NextHSizeErrR0 to NextHSizeErrR7

reg         iBufWrOver;
// Local copy of BufWrOver

reg         NextBufWrOver;
// D-input of BufWrOver

reg         CrntMemWr;
// This signal indicates the status of the WR transaction in process

reg         WtdMemWr;
// This signal indicates the status of the waited WR transaction

reg         BufWrOvStr;
// The buffer WR completion signal is stored till the MemWrOverCo is asserted

reg         MemRdTrans;
// Signal which indicates that the Memory read is in progress

reg         WaitStatus;
// The external wait timeout error status storage flag register.
// This is a Read-Only register bit and common for all banks.

reg         NextWaitStatus;
// D-input of WaitStatus

reg   [2:0] HBurstCrnt;
// The registered HBURST signal related to the current transfer

reg   [2:0] NextHBurstCrnt;
// D-input of HBurstCrnt

reg   [2:0] HBurstWtd;
// The registered HBURST signal related to the waited transfer

reg   [2:0] NextHBurstWtd;
// D-input of HBurstWtd

reg   [2:0] iHBurstReg;
// Internal copy of HBurstReg

reg   [2:0] NextHBurstReg;
// D-input of HBurstReg

reg         iRemapReg;
// Internal copy of RemapReg

reg         HSelSmcD1;
// One clock delayed version of HSELSMC

reg         AhbRdEnStr;
// Registered version of the AhbRdEn for fast reads from internal buffer

reg         NextAhbRdEnStr;
// D-input of AhbRdEnStr

reg         NextAhbRdOver;
// D-input of AhbRdOver

reg         NewTrans;
// Signal to store a fresh new transfer status to break the zero cycle
// speculative burst reads. Can be a new RD or a WR transaction.

reg         CrntMemWrBa;
// This is similar to the CrntMemWr but is deasserted one clock cycle
// earlier so that Bank address is generated properly.

reg         BusyInBM;
// Detect Busy Insertion during Burst Mode Read transfers

reg         PartWtdWr;
// Signal indicating partial Write operation with HSIZE < MSIZE

reg   [2:0] BankAddr;
// The bank address to be selected depending on whether its a waited transfer
// or current transfer

// -----------------------------------------------------------------------------
// Function declarations
// -----------------------------------------------------------------------------
//
// Main body of code
// =================
//
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Assign ZEROFILL
// -----------------------------------------------------------------------------
assign ZEROFILL         = 32'h00000000;

// -----------------------------------------------------------------------------
// Assign the SMC Peripheral ID
//
// The SMC Peripheral ID is a 32-bit value composed of the
// following 4 fields:
// Bits [11:0] -> Part Number used to identify the peripheral
//                For the SMC this is 0x092
// Bits[19:12] -> Designer ID (ARM)
//                ARM is designated 0x41
// Bits[23:20] -> Peripheral Revision Number
//                For the SMC this is 0x00
// Bits[31:24] -> Peripheral Configuration Options
//                For the SMC this is 0x00
//
// The 32-bits are readable via 4 separate address locations with
// each location returning 8 valid bits at positions [7:0]. The
// values returned by the 4 Peripheral ID registers are given below:
//
// SMCPeriphID0 = 0x92
// SMCPeriphID1 = 0x10
// SMCPeriphID2 = 0x04
// SMCPeriphID3 = 0x00
// -----------------------------------------------------------------------------
assign SMCPeriphID0     = 8'b10010010;
assign SMCPeriphID1     = 8'b00010000;
assign SMCPeriphID2     = 4'b0100;
assign SMCPeriphID3     = 8'b00000000;

// -----------------------------------------------------------------------------
// Assign the SMC PrimeCell ID
//
// SMCPCellID0 = 0x0D
// SMCPCellID1 = 0xF0
// SMCPCellID2 = 0x05
// SMCPCellID3 = 0xB1
// These PrimeCell ID values should not be changed.
// -----------------------------------------------------------------------------
assign SMCPCellID0      = 8'b00001101;
assign SMCPCellID1      = 8'b11110000;
assign SMCPCellID2      = 8'b00000101;
assign SMCPCellID3      = 8'b10110001;

// -----------------------------------------------------------------------------
// Detection of the system reset by the HRESETn input
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_HResetDetSeq
  if (HRESETn == 1'b0)
    begin
      HResetDet1       <= 1'b0;
      HResetDet2       <= 1'b0;
    end
  else
    begin
     HResetDet1       <= 1'b1;
     HResetDet2       <= HResetDet1;
   end
end // p_HResetDetSeq

// -----------------------------------------------------------------------------
// NOTE: The SMBCR7(7 downto 6) - the MW bits - are programmed differently
// because these MW bits are configurable at reset based on the state of the
// SMMWCS7 input pins. The memory device at this bank is used for the boot
// code read. If the SMMWCS7 pins are tied to "11", then the MW bits defaults to
// "00".
// -----------------------------------------------------------------------------
always @(HResetDet1 or HResetDet2 or SMBCR7WrEn or SMBCR7 or
         HWdataGtd or SMMWCS7 or iMWCfgDone or SMRBLECS7)
begin : p_MWconfComb
   NextMWCfgDone    = iMWCfgDone;
   NextMwPgm        = 1'b0;
   NextSMBCR7[7:6]  = SMBCR7[7:6];
   NextSMBCR7[0]    = SMBCR7[0];

  // The system reset has got completed in the previous clock cycle
  // and the MW bits of the SMBCR7 reg. are configured based on SMMWCS7 pins
  if (HResetDet1 == 1'b1 && HResetDet2 == 1'b0)
    begin
      NextMWCfgDone    = 1'b1;
      NextMwPgm        = 1'b1;
      NextSMBCR7[0]    = SMRBLECS7; 
      case (SMMWCS7)
        2'b00, 2'b11 :
          begin
            NextSMBCR7[7:6]  = 2'b00;
          end
        2'b01 :
          begin
            NextSMBCR7[7:6]  = 2'b01;
          end
        2'b10 :
          begin
            NextSMBCR7[7:6]  = 2'b10;
          end
        default :
          begin
            NextSMBCR7[7:6]  = 2'b00;
          end
      endcase
    end
  else if (SMBCR7WrEn == 1'b1)
    begin
      NextSMBCR7[7:6]  = HWdataGtd[7:6];
      NextSMBCR7[0]  = HWdataGtd[0];
    end
end // p_MWconfComb

// -----------------------------------------------------------------------------
// Clocked process for storing the MWCfgDone signal
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_MWconfSeq
  if (HRESETn == 1'b0)
    begin
      iMWCfgDone       <= 1'b0;
      iMwPgm           <= 1'b0;
    end
  else
    begin
      iMWCfgDone       <= NextMWCfgDone;
      iMwPgm           <= NextMwPgm;
    end
end // p_MWconfSeq

// -----------------------------------------------------------------------------
// Generation of BCR7 WrEn signal for writing MW bits
// -----------------------------------------------------------------------------
assign SMBCR7WrEn       = (RegWrEn == 1'b1 && (HAddrReg == `HADDR_SMBCR7))
                          ? 1'b1 : 1'b0;

// -----------------------------------------------------------------------------
// Generation of HSelRegCo qualifying HSELREG with HREADYIN 
// -----------------------------------------------------------------------------
assign HSelRegCo        = (HREADYIN == 1'b1) ? HSELREG : HSelREGD1;

// -----------------------------------------------------------------------------
// Delay the control signals for required amount of clocks
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_Dly1ClkSeq
  if (HRESETn == 1'b0)
    begin
      HSelREGD1        <= 1'b0;
    end
  else
    begin
      HSelREGD1        <= HSelRegCo;
    end
end // p_Dly1ClkSeq

// -----------------------------------------------------------------------------
// Save power by preventing change in internal data bus and address bus
// when the device is not selected.
// -----------------------------------------------------------------------------
assign HAddrGated       = (HSELREG == 1'b1) ? HADDR[11:2] : ZEROFILL[11:2];

assign HWdataGtd        = (HSelREGD1 == 1'b1 && HWriteReg == 1'b1)
                           ? HWDATA[7:0] : ZEROFILL[7:0];

assign HAddrSel         = (iMemWrReq == 1'b1) ?  iHAddrCrnt[1:0]    :
                          ((iWtdWrReq == 1'b1 &&
                            (MemWrOver == 1'b1 || iMwPgm == 1'b1)) ?
                          NextHAddrWtd[1:0] : 2'b00);

assign HSizeSel         = (iMemWrReq == 1'b1) ? HSizeCrnt :
                          ((iWtdWrReq == 1'b1 &&
                            (MemWrOver == 1'b1 || iMwPgm == 1'b1)) ?
                          NextHSizeWtd : 2'b00);

// -----------------------------------------------------------------------------
// Logic to determine the completion of writing/storing data into the
// internal Rd-Wr buffer. It depends on the HSIZE and MSIZE values.
// It also depends on the WaitEn for the bank. If WaitEn=1 then each
// WR from the AHB will be processed individually.
// During a WR transaction if the HSIZE < MSIZE and if there is an IDLE
// or NSEQ, then the Buffer write is completed. The packets are expected to
// follow N-S-S sequence and it is broken if an I or N is issued.
// -----------------------------------------------------------------------------
always @(iMemWrReq or MemWrOver or iMSize32 or iWtdWrReq or iWaitEn or
         HTRANS or iMSize16 or iMSize08 or iMwPgm or HSizeSel or HAddrSel or
         CrntMemWrBa or BufWrOvStr or PartWtdWr)
begin : p_BufWrComb
  NextBufWrOver    = 1'b0;

  if ((iMemWrReq == 1'b1 ||
       ((CrntMemWrBa == 1'b1 || (PartWtdWr == 1'b1 && MemWrOver == 1'b0)) &&
        BufWrOvStr == 1'b0) ||
       ((MemWrOver == 1'b1 || iMwPgm == 1'b1) && iWtdWrReq == 1'b1))
     &&
      (HSizeSel == 2'b10 || iWaitEn == 1'b1 || HTRANS[0] == 1'b0 
      ||
       ((HSizeSel == 2'b01 &&
         (iMSize08 == 1'b1 || iMSize16 == 1'b1 ||
          (iMSize32 == 1'b1 && HAddrSel[1] == 1'b1))) ||
        (HSizeSel == 2'b00 &&
         (iMSize08 == 1'b1 ||
          (iMSize16 == 1'b1 && HAddrSel[0] == 1'b1) ||
          (iMSize32 == 1'b1 && HAddrSel == 2'b11)))
       )
      )
     )
    begin
      NextBufWrOver    = 1'b1;
    end
end // p_BufWrComb

// -----------------------------------------------------------------------------
// Logic for storing the BufWrOver signal in cases when a NS(WR) is followed
// by B-I-I or I-I-I etc.
// -----------------------------------------------------------------------------
assign NextBufWrOvStr   = (NextBufWrOver == 1'b1) ? 1'b1 :
                          ((MemWrOverCo == 1'b1 || WaitToutErr == 1'b1) ? 1'b0 :
                           BufWrOvStr);

// -----------------------------------------------------------------------------
// Logic to generate the signal which is used to bypass the internal buffer
// -----------------------------------------------------------------------------
assign BufByPassCo      = ((NextHSizeReg == NextMW) && iMWCfgDone == 1'b1) ?
                           1'b1 : 1'b0;

// -----------------------------------------------------------------------------
// Storing the register WR and RD signals requests which were attempted when
// the configuration of the MW bits of SMBCR7 is still in progress. The
// transfers are carried out once the MWCfgDone is asserted
// -----------------------------------------------------------------------------
assign NextWtdRegWr     = ((HSELREG == 1'b1 && HTRANS[1] == 1'b1 &&
                           HREADYIN == 1'b1) && HWRITE == 1'b1 &&
                           iMWCfgDone == 1'b0) ? 1'b1 :
                           ((iMWCfgDone == 1'b1 && WtdRegWr == 1'b1) ? 1'b0 :
                            WtdRegWr);

assign NextWtdRegRd     = ((HSELREG == 1'b1 && HTRANS[1] == 1'b1 &&
                           HREADYIN == 1'b1) && HWRITE == 1'b0 &&
                           iMWCfgDone == 1'b0) ? 1'b1 :
                           ((iMWCfgDone == 1'b1 && WtdRegRd == 1'b1) ? 1'b0 :
                            WtdRegRd);

assign NextWtdRegRdEn   = (iMWCfgDone == 1'b1 && WtdRegRd == 1'b1)
                          ? 1'b1 : 1'b0;
                        

assign NextRegWrEn      = ((HSELREG == 1'b1 && HTRANS[1] == 1'b1 &&
                           HREADYIN == 1'b1) && HWRITE == 1'b1 &&
                           iMWCfgDone == 1'b1)
                           ? 1'b1 : 1'b0;

assign NextRegRdEn      = ((HSELREG == 1'b1 && HTRANS[1] == 1'b1 &&
                           HREADYIN == 1'b1) && HWRITE == 1'b0 &&
                           iMWCfgDone == 1'b1)
                           ? 1'b1 : 1'b0;

// -----------------------------------------------------------------------------
// Signals used to indicate the status of ongoing current WR or waited WR
// transactions and the progress of the read transactions
// CrntMemWrBa status signal is used to prevent the BankAddr from unnecessary
// toggling. Has the same behaviour as CrntMemWr but gets de-asserted one HCLK
// early.
// -----------------------------------------------------------------------------
assign NextCrntMemWr    = (iMemWrReq == 1'b1)   ? 1'b1 :
                          ((MemWrOver == 1'b1 || WaitToutErr == 1'b1) ? 1'b0 :
                           CrntMemWr);

assign NextWtdMemWr     = (((MemWrOver == 1'b1 && NextBufWrOver == 1'b1) ||
                            iMwPgm == 1'b1) && iWtdWrReq == 1'b1) ? 1'b1 :
                          ((MemWrOver == 1'b1 || WaitToutErr == 1'b1) ? 1'b0 :
                           WtdMemWr);

assign NextMemRdTrans   = (iMemRdReq == 1'b1 ||
                           ((MemWrOver == 1'b1 || iMwPgm == 1'b1) &&
                            iWtdRdReq == 1'b1)) ? 1'b1 :
                          ((MemRdOver == 1'b1 || WaitToutErr == 1'b1) ? 1'b0 :
                           MemRdTrans);

assign NextCrntMemWrBa  = (iMemWrReq == 1'b1)   ? 1'b1 :
                          (MemWrOverCo == 1'b1 || WaitToutErr == 1'b1) ?
                          1'b0 : CrntMemWrBa;

assign NextPartWtdWr    = (MemWrOver == 1'b1 && (NextHSizeReg < iMW) &&
                           iWtdWrReq == 1'b1 && PartWtdWr == 1'b0) ?  1'b1 :
                          ((MemWrOver == 1'b1 && PartWtdWr == 1'b1) ||
                           WaitToutErr == 1'b1 || iMemWrReq == 1'b1) ? 1'b0 :
                          PartWtdWr;

// -----------------------------------------------------------------------------
// Clocked process to register temporary signals and status signals
// -----------------------------------------------------------------------------
always  @(posedge HCLK or negedge HRESETn)
begin : p_TmpStatComb 
  if (HRESETn == 1'b0)
    begin
      RegWrEn          <= 1'b0;
      RegRdEn          <= 1'b0;
      WtdRegWr         <= 1'b0;
      WtdRegRd         <= 1'b0;
      WtdRegRdEn       <= 1'b0;
      iBufWrOver       <= 1'b0;
      BufWrOvStr       <= 1'b0;
      CrntMemWr        <= 1'b0;
      CrntMemWrBa      <= 1'b0;
      WtdMemWr         <= 1'b0;
      MemRdTrans       <= 1'b0;
      AhbRdEnStr       <= 1'b0;
      AhbRdOver        <= 1'b0;
      PartWtdWr        <= 1'b0;
    end
  else
    begin
      RegWrEn          <= NextRegWrEn;
      RegRdEn          <= NextRegRdEn;
      WtdRegWr         <= NextWtdRegWr;
      WtdRegRd         <= NextWtdRegRd;
      WtdRegRdEn       <= NextWtdRegRdEn;
      iBufWrOver       <= NextBufWrOver;
      BufWrOvStr       <= NextBufWrOvStr;
      CrntMemWr        <= NextCrntMemWr;
      CrntMemWrBa      <= NextCrntMemWrBa;
      WtdMemWr         <= NextWtdMemWr;
      MemRdTrans       <= NextMemRdTrans;
      AhbRdEnStr       <= NextAhbRdEnStr;
      AhbRdOver        <= NextAhbRdOver;
      PartWtdWr        <= NextPartWtdWr;
    end
end // p_TmpStatComb;

// -----------------------------------------------------------------------------
// Storing the AhbRdEn signal for the read cases when the HSIZE < MSize and
// subsequent datas can be given from the internal buffer, RdWrBuf with zero
// wait cycles and without extra memory accesses
// -----------------------------------------------------------------------------
always @(AhbRdEnStr or MemRdOver or iHREADYOUTMem or HTRANS or iHSizeReg or
         NextMW or SmcAddrReg or HADDR)
begin : p_AhbRdStr 
  NextAhbRdEnStr   = AhbRdEnStr;
  NextAhbRdOver    = 1'b0;

  if (MemRdOver == 1'b1 || AhbRdEnStr == 1'b1)
    begin
      if (iHREADYOUTMem == 1'b1 && HTRANS == `T_SEQ)
        begin
          if ((((iHSizeReg == 2'b00 || iHSizeReg == 2'b01) &&
                NextMW == 2'b10) &&
               (SmcAddrReg[3:2] == HADDR[3:2])) ||
              ((iHSizeReg == 2'b00 && NextMW == 2'b01) &&
               (SmcAddrReg[3:1] == HADDR[3:1])))
            begin
              NextAhbRdEnStr   = 1'b1;
            end
          else
            begin
              NextAhbRdOver    = 1'b1;
              NextAhbRdEnStr   = 1'b0;
            end
        end
      else
        begin
          NextAhbRdOver    = 1'b1;
          NextAhbRdEnStr   = 1'b0;
        end
    end
end // p_AhbRdStr;

// -----------------------------------------------------------------------------
// 1. Logic to store the memory write attempt before completion of the current
//    write in progress OR when the MW bits of the SMBCR7 are still being
//    programmed.
//    When the waited write transfer is being serviced [on the completion of the
//    previous write transfer], then the status is stored in the WtdMemWr
//    register. The WtdWrReq signal can then be de-asserted.
// 2. Logic to store the memory read attempt before completion of the current
//    write in progress OR when the MW bits of the SMBCR7 are still being
//    programmed.
//    The MemRdReq and WtdRdReq will not be generated simultaneously, they are
//    mutually exclusive events.
// -----------------------------------------------------------------------------
assign NextWtdWrReq     = (((MemWrOver == 1'b0 &&
                            (((iMemWrReq == 1'b1 || PartWtdWr == 1'b1 ||
                               CrntMemWr == 1'b1) &&
                              NextBufWrOver == 1'b1) ||
                             ((CrntMemWr == 1'b1 || PartWtdWr == 1'b1) &&
                              BufWrOvStr == 1'b1)) &&
                            ((HSELSMC == 1'b1 && HREADYIN == 1'b1 &&
                              HTRANS[1] == 1'b1) && HWRITE == 1'b1 &&
                             WP == 1'b0))
                          ||
                            ((HSELSMC == 1'b1 && HTRANS[1] == 1'b1 &&
                              HREADYIN == 1'b1) && iMWCfgDone == 1'b0 &&
                             HWRITE == 1'b1)
                           )
                          && NextHSizeErr == 1'b0
                          ) ? 1'b1 :
                          (((NextBufWrOver == 1'b0 &&
                             (MemWrOver == 1'b1 && iWtdWrReq == 1'b1)) ||
                            WtdMemWr == 1'b1) ? 1'b0 : iWtdWrReq);

assign NextWtdRdReq     = (((MemWrOver == 1'b0 &&
                            (((iMemWrReq == 1'b1 || PartWtdWr == 1'b1 ||
                               CrntMemWr == 1'b1) && NextBufWrOver == 1'b1) ||
                             ((CrntMemWr == 1'b1 || PartWtdWr == 1'b1) &&
                              BufWrOvStr == 1'b1)) &&
                            ((HSELSMC == 1'b1 && HREADYIN == 1'b1 &&
                              HTRANS[1] == 1'b1) && HWRITE == 1'b0))
                          ||
                            ((HSELSMC == 1'b1 && HTRANS[1] == 1'b1 &&
                              HREADYIN == 1'b1) && iMWCfgDone == 1'b0 &&
                             HWRITE == 1'b0)
                           )
                          && NextHSizeErr == 1'b0 
                          ) ? 1'b1 :
                          (
                           (MemRdOver == 1'b1) ? 1'b0 : iWtdRdReq);

// -----------------------------------------------------------------------------
// Register a fresh valid read request
// 1. MemRdReq : Memory Read request generation. 
//    For a NSEQ or SEQ Read transaction from AHB [with SMC selected], the 
//    following conditions are evaluated
//    - A Read request during a Burst Read operation, when the Burst is not
//      broken. Condition checked at the end of current read access.
//    - A Read request is detected, in the condition when previous Reads are
//      completed and followed by a Write request which is given a Zero Wait 
//      DONE response and this Write is completed. For the Write Not completed
//      condition, the Read request should be registered as a Waited transaction
//      by enabling WtdRdReq 
//    - A new valid Read request is detected, without any error conditions, 
//      after individual Read transactions or when previous Write operation has
//      been completed.
//    The MemRdReq and WtdRdReq will not be generated at the same time, they are
//    mutually exclusive events
// -----------------------------------------------------------------------------
assign NextMemRdReq     = ((HSELSMC == 1'b1 && HWRITE == 1'b0 &&
                           HTRANS[1] == 1'b1 && WaitToutErr == 1'b0)
                          &&
                           ((MemRdOverCo == 1'b1 && NewTrans == 1'b0 &&
                             iHREADYOUTMem == 1'b1)
                           ||
                            ((MemRdOver == 1'b1 || AhbRdEnStr == 1'b1) &&
                             NextAhbRdOver == 1'b1 &&
                             (!(iMemWrReq == 1'b1 && NextBufWrOver == 1'b1)) &&
                             (!(MemRdOverCo == 1'b1 && NewTrans == 1'b0))) 
                           ||
                            (HREADYIN == 1'b1 && iMWCfgDone == 1'b1 &&
                             WaitToutErr == 1'b0 && NextHSizeErr == 1'b0 &&
                             (!((MemRdOver == 1'b1 || AhbRdEnStr == 1'b1) &&
                                NextAhbRdOver == 1'b0)) &&
                             (!(MemWrOver == 1'b0 &&
                                (((iMemWrReq == 1'b1 || PartWtdWr == 1'b1 ||
                                   CrntMemWr == 1'b1) &&
                                  NextBufWrOver == 1'b1) ||
                                 ((CrntMemWr == 1'b1 || PartWtdWr == 1'b1) &&
                                  BufWrOvStr == 1'b1))))
                            )
                           )
                          )
                          ? 1'b1 : 1'b0;

// -----------------------------------------------------------------------------
// Register a fresh valid write request
// - At the end of a Read transaction, a Write request is detected to a 
//   writable memory.
// - When the HSIZE < MSIZE and buffer can collect the data to construct a 
//   larger data. 
// -----------------------------------------------------------------------------
assign NextMemWrReq     = ((MemRdOverCo == 1'b1 && NewTrans == 1'b0 &&
                            iHREADYOUTMem == 1'b1 && HSELSMC == 1'b1 &&
                            HTRANS[1] == 1'b1 &&
                            HWRITE == 1'b1 && WP == 1'b0 && WaitToutErr == 1'b0)
                          ||
                           ((HSELSMC == 1'b1 && HTRANS[1] == 1'b1 &&
                             HREADYIN == 1'b1) && iMWCfgDone == 1'b1 &&
                            HWRITE == 1'b1 && WP == 1'b0 &&
                            WaitToutErr == 1'b0 && NextHSizeErr == 1'b0 &&
                            (!(MemWrOver == 1'b0 &&
                               (((iMemWrReq == 1'b1 || PartWtdWr == 1'b1 ||
                                  CrntMemWr == 1'b1) &&
                                 NextBufWrOver == 1'b1) ||
                                ((CrntMemWr == 1'b1 || PartWtdWr == 1'b1) &&
                                  BufWrOvStr == 1'b1))))
                           )
                          )
                          ? 1'b1 : 1'b0;

// -----------------------------------------------------------------------------
// Setting a temporary error signal when a write is attempted to a write
// protected memory
// -----------------------------------------------------------------------------
assign NextWpErrTmp      = ((MemWrOver == 1'b0 &&
                             ((iMemWrReq == 1'b1 && NextBufWrOver == 1'b1) ||
                              ((CrntMemWr == 1'b1 || PartWtdWr == 1'b1) &&
                               BufWrOvStr == 1'b1)) &&
                             (HSELSMC == 1'b1 && iHREADYOUTMem == 1'b1 &&
                              HTRANS[1] == 1'b1 && HWRITE == 1'b1 
                              && WP == 1'b1))
                           ||
                            (MemRdOverCo == 1'b1 && NewTrans == 1'b0 && 
                             iHREADYOUTMem == 1'b1 && HSELSMC == 1'b1 &&
                             HWRITE == 1'b1 && WP == 1'b1)
                           ||
                            ((HSELSMC == 1'b1 && HTRANS[1] == 1'b1 &&
                              HREADYIN == 1'b1) && iMWCfgDone == 1'b1 &&
                             HWRITE == 1'b1 && WP == 1'b1)
                           )
                           ? 1'b1 : 1'b0;

// -----------------------------------------------------------------------------
// Register a fresh NONSEQ read or write transfer which aborts the BM reads
// with zero wait access time
// -----------------------------------------------------------------------------
assign NextNewTrans     = (MemRdOverCo == 1'b1 && NewTrans == 1'b0 &&
                           iHREADYOUTMem == 1'b1 && HSELSMC == 1'b1 &&
                           HTRANS == `T_NONSEQ)
                          ? 1'b1 : 1'b0;

// -----------------------------------------------------------------------------
// During Burst Read transfer when speculative/predictive Reads are performed
// if there is a BUSY transfer then, speculative/predictive Read operations 
// will be terminated so as to synchronize with the AHB. This signal is used to
// to detect this condition.
// -----------------------------------------------------------------------------
assign NextBusyInBM    = (BMRdTrans == 1'b1 && HTRANS == `T_BUSY) ? 1'b1 :
                         ((iMemRdReq == 1'b1 || iMemWrReq == 1'b1) ? 1'b0 :
                         BusyInBM);

// -----------------------------------------------------------------------------
// Generation of the SMC's response signals
// This block generates the respone output for the memory transactions.
// -----------------------------------------------------------------------------
always @(iHRESPMem or iHREADYOUTMem or WaitToutErr or NextHSizeErr or
         iMemWrReq or iWtdWrReq or iWtdRdReq or iMWCfgDone or
         NextWaitEn or HTRANS or HWRITE or HREADYIN or MemRdTrans or
         MemWrOver or MemRdOverCo or HSELSMC or WP or BusyInBM or
         NextBufWrOver or CrntMemWr or BufWrOvStr or MemRdOver or
         AhbRdEnStr or WtdMemWr or NextAhbRdOver or NewTrans or PartWtdWr) 
begin : p_MemRespGenComb

  NextHRESPMem     = iHRESPMem;
  NextHREADYOUTMem = iHREADYOUTMem;

  // Check if the previous cycle was the first cycle of the ERROR response
  // by looking for the condition when the HRESP drives ERROR and HREADYOUT
  // is low. If this condition is true then drive HREADYOUT high maintaining
  // ERROR response. This gives the two cycle ERROR response.
  if (iHRESPMem == `H_ERROR && iHREADYOUTMem == 1'b0)
    begin
      NextHREADYOUTMem = 1'b1;
      NextHRESPMem     = `H_ERROR;
    end

  // Generate ERROR response when following conditions are satisfied
  // 1. Unsupported transfer size
  // 2. Check for WaitToutErr condition so as to drive the ERROR
  //    response. If the AHB tries to initiate transfer when the SMWAIT input is
  //    still asserted due to previous transfer, then SMC will keep giving ERROR
  //    response
  else if (NextHSizeErr == 1'b1 || 
           (WaitToutErr == 1'b1 &&
            ((HSELSMC == 1'b1 && HTRANS[1] == 1'b1) ||
             MemRdTrans == 1'b1 || CrntMemWr == 1'b1 || WtdMemWr == 1'b1)))
    begin
      NextHREADYOUTMem = 1'b0;
      NextHRESPMem     = `H_ERROR;
    end

  // 1. If the master drives either an IDLE or a BUSY, then respond by driving
  //    OKAY/DONE response
  // 2. During WR transaction due to HSIZE < MSIZE difference, if the internal
  //    RD-WR buffer is not filled with all sub pkts of data then, drive OKAY
  //    response till the buffer is filled and then only one access to memory
  //    is needed to write the data out. For eg. HSIZE = 8 & MSIZE = 32, and
  //    if the 1st address is aligned and the WaitEn = 0, then upto 4 bytes
  //    can be collected into the buffer before flushing out the data.
  //    This check condition caters to the Waited write transfer
  else if (((HTRANS == `T_IDLE || HTRANS == `T_BUSY) && HREADYIN == 1'b1) ||
           (NextBufWrOver == 1'b0 && (MemWrOver == 1'b1 && iWtdWrReq == 1'b1)))
    begin
      NextHREADYOUTMem = 1'b1;
      NextHRESPMem     = `H_OKAY;
    end

  // if a write or a read transaction is initiated on the bus before the
  // completion of the ongoing write transfer, then register the request
  // and insert wait cycles on the AHB. The status of the waited transfer is
  // stored as waited read or waited write pending request. In case of writes
  // check is performed to determine if the device is write protected, before
  // committing to the write operation.
  else if (MemWrOver == 1'b0 &&
           (((iMemWrReq == 1'b1 || PartWtdWr == 1'b1 || CrntMemWr == 1'b1) &&
             NextBufWrOver == 1'b1) ||
            ((CrntMemWr == 1'b1 || PartWtdWr == 1'b1) && BufWrOvStr == 1'b1)) &&
           (HSELSMC == 1'b1 && HREADYIN == 1'b1 && HTRANS[1] == 1'b1))
    begin
      NextHREADYOUTMem  = 1'b0;
      if (HWRITE == 1'b1)
        begin
          if (WP == 1'b1)
            begin
              NextHRESPMem     = `H_ERROR;
            end
          else
            begin
              NextHRESPMem     = `H_OKAY;
            end
        end
      else
        begin
          NextHRESPMem     = `H_OKAY;
        end
    end

  // If the external read data from the memory is ready to be given to the
  // the AHB then generate the enable signal and assert the HREADYOUT with
  // OKAY response. The transfer was successful for either the initial
  // read transaction or the waited read transaction.
  // During BM reads if the Access count = 0 that is WST1/2=0, then data
  // streams in each cycle. The SmcCore would already have started the
  // subsequent reads in advance and as read finishes in 1 clock, it is
  // important to check when the burst is terminated or gets aborted. These
  // checking basically for the a new NONSEQ read or a new write is done
  // before giving out the next DONE response {by driving HREADYOUT=1}
  // The new read or write transfers requests are registered appropriately
  else if (MemRdOverCo == 1'b1 && NewTrans == 1'b0)
    begin
      NextHREADYOUTMem = 1'b1;
      NextHRESPMem     = `H_OKAY;
      if (HREADYIN == 1'b1 && HSELSMC == 1'b1)
        begin
          if (HWRITE == 1'b0 && (HTRANS == `T_NONSEQ || BusyInBM == 1'b1))
            begin
              NextHREADYOUTMem   = 1'b0;
            end
          else if (HWRITE == 1'b1)
            begin
              if (WP == 1'b1)
                begin
                  NextHREADYOUTMem = 1'b0;
                  NextHRESPMem     = `H_ERROR;
                end
              else
                begin
                  NextHRESPMem     = `H_OKAY;
                  if (NextWaitEn == 1'b1)
                    begin
                      NextHREADYOUTMem   = 1'b0;
                    end
                end
            end
        end
    end

  // In the case of read transfer when the HSIZE < MSize, one memory access
  // can fetch more data than required by the current transfer. In this
  // scenario, if the next sequential AHB address falls in the address space
  // of the larger data held by the internal buffer, then the data is returned
  // with zero wait cycles to the AHB from the buffer itself and no extra
  // memory accesses are required.
  else if ((MemRdOver == 1'b1 || AhbRdEnStr == 1'b1) && HWRITE == 1'b0 &&
           HSELSMC == 1'b1)
    begin
      NextHRESPMem      = `H_OKAY;
      if (NextAhbRdOver == 1'b1)
        begin
          NextHREADYOUTMem = 1'b0;
        end
      else
        begin
          NextHREADYOUTMem = 1'b1;
        end
    end

  // if the external memory device is being targeted with a NONSEQ or SEQ,
  // then check if the MW bits programming of the SMBCR7 is complete. If the
  // programming is not complete, insert waits on AHB. If the programming
  // is complete then * if it is a write transfer then check if the WP bit is
  // active. If write protect bit is asserted, then drive ERROR response.
  // If WP bit is inactive then register the write request. If the WaitEn
  // is '0' then for this first write request drive OKAY response, otherwise
  // drive waits on the AHB (so that SMC has a chance to flag error due
  // to Wait Time out).
  // * if it is a read transfer, then register the request and drive waits
  // on the AHB.
  else if (HSELSMC == 1'b1 && HTRANS[1] == 1'b1 && HREADYIN == 1'b1)
    begin
      if (iMWCfgDone == 1'b1)
        begin
          if (HWRITE == 1'b1)
            begin
              if (WP == 1'b1)
                begin
                  NextHREADYOUTMem  = 1'b0;
                  NextHRESPMem      = `H_ERROR;
                end
              else
                begin
                  NextHRESPMem      = `H_OKAY;
                  if (NextWaitEn == 1'b1)
                    begin
                      NextHREADYOUTMem  = 1'b0;
                    end
                end
            end
          else
            begin
              NextHREADYOUTMem    = 1'b0;
              NextHRESPMem        = `H_OKAY;
            end
        end
      else
        begin
          NextHREADYOUTMem = 1'b0;
          NextHRESPMem     = `H_OKAY;
        end
    end

  // 1. If the error response was already generated in the previous cycle and
  //    there are no more transfers performed, then OKAY response is driven
  // 2. If the ongoing external WR to the memory device is complete then drive
  //    OKAY response. This is for the cases when each WR is completed
  //    individually, when WaitEn=1 and in case of WtdWrReq=1.
  else if ((iHRESPMem == `H_ERROR && iHREADYOUTMem == 1'b1) ||
           (MemWrOver == 1'b1 &&
            ((CrntMemWr == 1'b1 && (iWtdWrReq == 1'b0 && iWtdRdReq == 1'b0)) ||
             (WtdMemWr == 1'b1))))
        begin
          NextHREADYOUTMem = 1'b1;
          NextHRESPMem     = `H_OKAY;
        end
end // p_MemRespGenComb

// -----------------------------------------------------------------------------
// 1. Wait for one cycle before driving the OKAY/DONE response. This is used
//    after any internal register WR, so that the parameters get updated
//    in the register, before using them.
// 2. If the internal registers are being targeted for a write or read with
//    a NONSEQ or SEQ transfer, then
//    check if the MW bits programming of the SMBCR7 is complete. If the
//    programming is not complete, register the request and insert waits on AHB.
//    This request will be serviced after the programming is complete.
//    If the programming is complete then give an OKAY response and
//    enable the register access.
// 3. On the completion of the configuration of the MW bits after reset, the
//    pending read or write transfers to the registers are completed
// -----------------------------------------------------------------------------
always @(Wait1Cyc or iMWCfgDone or HTRANS or HWRITE or HREADYIN or HSELREG or
         iHRESPReg or iHREADYOUTReg or WtdRegWr or WtdRegRd) 
begin : p_RegRespGenComb

  NextHRESPReg     = iHRESPReg;
  NextHREADYOUTReg = iHREADYOUTReg;
  NextWait1Cyc     = Wait1Cyc;

  if (Wait1Cyc == 1'b1 
     || 
      ((HTRANS == `T_IDLE || HTRANS == `T_BUSY) && HREADYIN == 1'b1)) 
    begin
      NextHRESPReg     = `H_OKAY;
      NextHREADYOUTReg = 1'b1;
      NextWait1Cyc      = 1'b0;
    end

  else if (HSELREG == 1'b1 && HTRANS[1] == 1'b1 && HREADYIN == 1'b1) 
    begin
      NextHRESPReg     = `H_OKAY;
      if (iMWCfgDone == 1'b1) 
        begin
          if(HWRITE == 1'b1) 
            begin
              NextHREADYOUTReg = 1'b0;
              NextWait1Cyc      = 1'b1;
            end
          else 
            begin
              NextHREADYOUTReg = 1'b1;
            end
        end
      else
          NextHREADYOUTReg = 0;
    end 
  else if (iMWCfgDone == 1'b1 && (WtdRegWr == 1'b1 || WtdRegRd == 1'b1)) 
    begin
      NextHREADYOUTReg = 1'b1;
      NextHRESPReg     = `H_OKAY;
    end
end //p_RegRespGenComb

// -----------------------------------------------------------------------------
// Multiplexer which selects either the memory response or the register response
// depending on HSelSmcD1 and HSelREGD1.
// 1. When HSelSmcD1 is 1 , if waited register write transaction is going on
//    then the register response is driven else the memory response is routed.
// 2. When HSelSmcD1 is 0, if some transaction is going on (read or write)
//    the memory response is routed else if HSelREGD1 is 1 then register
//    response is routed, otherwise if none of memory or register is selected
//    for transaction, HREADYOUT is asserted and OKAY response is driven.
// -----------------------------------------------------------------------------
always @ (iHREADYOUTReg or iHRESPReg or iHREADYOUTMem or iHRESPMem or
          CrntMemWr  or WtdRegWr  or MemRdTrans or WtdMemWr or HSelSmcD1 or
          HSelREGD1 or iWtdWrReq or iWtdRdReq or WtdRegRd)
begin : p_RespSelComb

  case (HSelSmcD1)
   1'b1 :
     begin
       if (WtdRegWr == 1'b1 || WtdRegRd == 1'b1) 
         begin
           HREADYOUT        = iHREADYOUTReg;
           HRESP            = iHRESPReg;
         end
       else
         begin
           HREADYOUT        = iHREADYOUTMem;
           HRESP            = iHRESPMem;
         end
     end
   1'b0 :
     if (MemRdTrans == 1'b1  || (CrntMemWr == 1'b1 && HSelREGD1 == 1'b0) ||
         WtdMemWr == 1'b1 || iHRESPMem == `H_ERROR || iWtdRdReq == 1'b1 ||
         iWtdWrReq == 1'b1) 
       begin
         HREADYOUT       = iHREADYOUTMem ;
         HRESP           = iHRESPMem;
       end
     else if (HSelREGD1 == 1'b1)
       begin
         HREADYOUT       = iHREADYOUTReg;
         HRESP           = iHRESPReg;
       end
     else
       begin
         HREADYOUT       = 1'b1;
         HRESP           = `H_OKAY;
       end

   default :
     begin
       HREADYOUT        = 1'b1;
       HRESP            = `H_OKAY;
     end

  endcase
end //p_RespSelComb

// -----------------------------------------------------------------------------
// Clocked process to register the response & control signals
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_RespGenSeq
  if (HRESETn == 1'b0)
    begin
      iHRESPMem        <= `H_OKAY;
      iHRESPReg        <= `H_OKAY;
      iHREADYOUTMem    <= 1'b1;
      iHREADYOUTReg    <= 1'b1;
      iMemWrReq        <= 1'b0;
      iMemRdReq        <= 1'b0;
      iWtdWrReq        <= 1'b0;
      iWtdRdReq        <= 1'b0;
      Wait1Cyc         <= 1'b0;
      AddrContStr      <= 1'b0;
      NewTrans         <= 1'b0;
      BusyInBM         <= 1'b0;
    end
  else
    begin
      iHRESPMem        <= NextHRESPMem;
      iHRESPReg        <= NextHRESPReg;
      iHREADYOUTMem    <= NextHREADYOUTMem;
      iHREADYOUTReg    <= NextHREADYOUTReg;
      iMemWrReq        <= NextMemWrReq;
      iMemRdReq        <= NextMemRdReq;
      iWtdWrReq        <= NextWtdWrReq;
      iWtdRdReq        <= NextWtdRdReq;
      Wait1Cyc         <= NextWait1Cyc;
      AddrContStr      <= NxtAddrContStr;
      NewTrans         <= NextNewTrans;
      BusyInBM         <= NextBusyInBM; 
    end
end // p_RespGenSeq

// -----------------------------------------------------------------------------
// This signal is generated to store the address and controls for
// waited/pending write or read transfer
// -----------------------------------------------------------------------------
assign NxtAddrContStr   = (NextHSizeErr == 1'b0 && (HSELSMC == 1'b1 &&
                            HTRANS[1] == 1'b1 && HREADYIN == 1'b1) &&
                            ((MemWrOver == 1'b0 &&
                              (((iMemWrReq == 1'b1 || PartWtdWr == 1'b1 ||
                                 CrntMemWr == 1'b1) && NextBufWrOver == 1'b1) ||
                               ((CrntMemWr == 1'b1 || PartWtdWr == 1'b1) &&
                                BufWrOvStr == 1'b1)) &&
                              ((HWRITE == 1'b1 && WP == 1'b0) ||
                               HWRITE == 1'b0)) ||
                             iMWCfgDone == 1'b0)) ? 1'b1 : 1'b0;

// -----------------------------------------------------------------------------
// In the CLK when a new memory/SMC transfer is requested, register all the
// AHB control signals and the address for the current transfer.
// -----------------------------------------------------------------------------
always @(iHAddrCrnt or HSELSMC or HREADYIN or HADDR or HTransCrnt or
         HTRANS or HSizeCrnt or HSIZE or HBurstCrnt or HBURST)
begin : p_StrHaContComb
  NextHAddrCrnt    = iHAddrCrnt;
  NextHTransCrnt   = HTransCrnt;
  NextHSizeCrnt    = HSizeCrnt;
  NextHBurstCrnt   = HBurstCrnt;

  if (HSELSMC == 1'b1 && HREADYIN == 1'b1)
    begin
      NextHAddrCrnt    = HADDR;
      NextHTransCrnt   = HTRANS;
      NextHSizeCrnt    = HSIZE[1:0];
      NextHBurstCrnt   = HBURST;
    end
end // p_StrHaContComb

// -----------------------------------------------------------------------------
// Store the address and controls of the next Write or a Read transfer which
// is requested before the completion of the current write.
// [For the first write transfer the HREADYIN
// is given immediately making use of the internal buffer, in the non-SMWAIT
// controlled mode]
// -----------------------------------------------------------------------------
always @(iHAddrWtd or AddrContStr or BnkAddWtd or iHAddrCrnt or
         HTransCrnt or HSizeCrnt or HTransWtd or HSizeWtd or
         HBurstWtd or HBurstCrnt)
begin : p_WtdHaContComb
  NextHAddrWtd     = iHAddrWtd;
  NextHTransWtd    = HTransWtd;
  NextHSizeWtd     = HSizeWtd;
  NextHBurstWtd    = HBurstWtd;
  NextBnkAddWtd    = BnkAddWtd;

  if (AddrContStr == 1'b1)
    begin
      NextHAddrWtd     = iHAddrCrnt[25:0];
      NextHTransWtd    = HTransCrnt;
      NextHSizeWtd     = HSizeCrnt;
      NextHBurstWtd    = HBurstCrnt;
      NextBnkAddWtd    = iHAddrCrnt[28:26];
    end
end // p_WtdHaContCo

// -----------------------------------------------------------------------------
// The relevant HTRANS, HSIZE and HBURST control informations are routed
// The Bank address is generated for a valid transfer to memory
// -----------------------------------------------------------------------------
always @(iHTransReg or iHSizeReg or iHBurstReg or iMemWrReq or
         iMemRdReq or HTransCrnt or HSizeCrnt or HBurstCrnt or
         MemWrOver or iMwPgm or iWtdWrReq or iWtdRdReq or
         NextHTransWtd or NextHSizeWtd or NextHBurstWtd or iBnkAddStr or
         iHAddrCrnt or NextBnkAddWtd)
begin : p_ContSelComb
  NextHTransReg    = iHTransReg;
  NextHSizeReg     = iHSizeReg;
  NextHBurstReg    = iHBurstReg;
  NextBnkAddStr    = iBnkAddStr;

  if (iMemWrReq == 1'b1 || iMemRdReq == 1'b1)
    begin
      NextHTransReg    = HTransCrnt;
      NextHSizeReg     = HSizeCrnt;
      NextHBurstReg    = HBurstCrnt;
      NextBnkAddStr    = iHAddrCrnt[28:26];
    end
  else if ((MemWrOver == 1'b1 || iMwPgm == 1'b1) &&
           (iWtdRdReq == 1'b1 || iWtdWrReq == 1'b1))
    begin
      NextHTransReg    = NextHTransWtd;
      NextHSizeReg     = NextHSizeWtd;
      NextHBurstReg    = NextHBurstWtd;
      NextBnkAddStr    = NextBnkAddWtd;
    end
end // p_ContSelComb

// -----------------------------------------------------------------------------
// Check performed to ascertain if subsequent bank addresses are same
// -----------------------------------------------------------------------------
always @(iMemRdReq or iBnkAddStr or iHAddrCrnt or MemWrOver or
         iWtdWrReq)
begin : p_BnkCmpComb
  BankCmpCo        = 1'b0;

  if (iMemRdReq == 1'b1)
    begin
      if (iBnkAddStr == iHAddrCrnt[28:26])
        begin
          BankCmpCo        = 1'b1;
        end
    end
  else if (MemWrOver == 1'b1 && iWtdWrReq == 1'b1)
    begin
      if (iBnkAddStr == iHAddrCrnt[28:26])
        begin
          BankCmpCo        = 1'b1;
        end
    end
end // p_BnkCmpComb

// -----------------------------------------------------------------------------
// Store the AHB input control signals - combinational process
// -----------------------------------------------------------------------------
always @(HWRITE or HSELREG or HREADYIN or HWriteReg or
         IntHSelReg or HAddrGated or HAddrReg)
begin : p_StrAhbContComb
  NextHWriteReg    = HWriteReg;
  NextIntHSelReg   = IntHSelReg;
  NextHAddrReg     = HAddrReg;

  if (HREADYIN == 1'b1 && HSELREG == 1'b1)
    begin
      NextHWriteReg    = HWRITE;
      NextIntHSelReg   = HSELREG;
      NextHAddrReg     = HAddrGated;
    end
end // p_StrAhbContComb

// -----------------------------------------------------------------------------
// Store the AHB input control signals - clocked process
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_StrAhbContSeq
  if (HRESETn == 1'b0)
    begin
      HTransCrnt       <= 2'b00;
      HTransWtd        <= 2'b00;
      iHTransReg       <= 2'b00;
      HWriteReg        <= 1'b0;
      IntHSelReg       <= 1'b0;
      HSizeCrnt        <= 2'b00;
      HSizeWtd         <= 2'b00;
      iHSizeReg        <= 2'b00;
      iHAddrCrnt       <= {24'h000000, 5'b00};
      iHAddrWtd        <= {24'h000000, 2'b00};
      HAddrReg         <= 10'b0000000000;
      BnkAddWtd        <= 3'b000;
      iBnkAddStr       <= 3'b000;
      HBurstCrnt       <= 3'b000;
      HBurstWtd        <= 3'b000;
      iHBurstReg       <= 3'b000;
      WpErrTmp         <= 1'b0;
      HSizeErr         <= 1'b0;
    end
  else
    begin
      HTransCrnt       <= NextHTransCrnt;
      HTransWtd        <= NextHTransWtd;
      iHTransReg       <= NextHTransReg;
      HWriteReg        <= NextHWriteReg;
      IntHSelReg       <= NextIntHSelReg;
      HSizeCrnt        <= NextHSizeCrnt;
      HSizeWtd         <= NextHSizeWtd;
      iHSizeReg        <= NextHSizeReg;
      iHAddrCrnt       <= NextHAddrCrnt;
      iHAddrWtd        <= NextHAddrWtd;
      HAddrReg         <= NextHAddrReg;
      BnkAddWtd        <= NextBnkAddWtd;
      iBnkAddStr       <= NextBnkAddStr;
      HBurstCrnt       <= NextHBurstCrnt;
      HBurstWtd        <= NextHBurstWtd;
      iHBurstReg       <= NextHBurstReg;
      WpErrTmp         <= NextWpErrTmp;
      HSizeErr         <= NextHSizeErr;
    end
end // p_StrAhbContSeq

// -----------------------------------------------------------------------------
// HSIZE error detection logic.
// 1. The external memory transfer size cannot be greater than 32-bits
// 2. For the internal registers, only 32-bit transfer size is allowed
// -----------------------------------------------------------------------------
assign NextHSizeErr     = (HREADYIN == 1'b1 &&
                           ((HSELSMC == 1'b1 &&
                             (HSIZE[2] == 1'b1 || HSIZE[1:0] == 2'b11))
                           )
                          ) ? 1'b1 : 1'b0;

// -----------------------------------------------------------------------------
// Read Data Output Multiplexer
// -----------------------------------------------------------------------------
always @(RegRdEn or HAddrReg or SMBIDCYR0 or SMBWST1R0 or SMBWST2R0 or
         SMBWSTOENR0 or SMBWSTWENR0 or SMBCR0 or SMBIDCYR1 or SMBWST1R1 or
         SMBWST2R1 or SMBWSTOENR1 or SMBWSTWENR1 or SMBCR1 or SMBIDCYR2 or
         SMBWST1R2 or SMBWST2R2 or SMBWSTOENR2 or SMBWSTWENR2 or SMBCR2 or
         SMBIDCYR3 or SMBWST1R3 or SMBWST2R3 or SMBWSTOENR3 or SMBWSTWENR3 or
         SMBCR3 or SMBIDCYR4 or SMBWST1R4 or SMBWST2R4 or SMBWSTOENR4 or
         SMBWSTWENR4 or SMBCR4 or SMBIDCYR5 or SMBWST1R5 or SMBWST2R5 or
         SMBWSTOENR5 or SMBWSTWENR5 or SMBCR5 or SMBIDCYR6 or SMBWST1R6 or
         SMBWST2R6 or SMBWSTOENR6 or SMBWSTWENR6 or SMBCR6 or SMBIDCYR7 or
         SMBWST1R7 or SMBWST2R7 or SMBWSTOENR7 or SMBWSTWENR7 or SMBCR7 or
         SMCPeriphID0 or SMCPeriphID1 or SMCPeriphID2 or SMCPeriphID3 or
         SMCPCellID0 or SMCPCellID1 or SMCPCellID2 or SMCPCellID3 or
         RdWrBuf or ToutErrR0 or ToutErrR1 or ToutErrR2 or
         ToutErrR3 or ToutErrR4 or ToutErrR5 or ToutErrR6 or ToutErrR7 or
         HSizeErrR0 or HSizeErrR1 or HSizeErrR2 or HSizeErrR3 or HSizeErrR4 or
         HSizeErrR5 or HSizeErrR6 or HSizeErrR7 or WPErrReg0 or WPErrReg1 or
         WPErrReg2 or WPErrReg3 or WPErrReg4 or WPErrReg5 or WPErrReg6 or
         WPErrReg7 or WtdRegRdEn or WaitStatus or Revision or MemRdOver or
         AhbRdEnStr)
begin : p_AhbRdComb
  HRDATA           = 32'h00000000;

  if (RegRdEn == 1'b1 || WtdRegRdEn == 1'b1)
    begin
      case (HAddrReg)
        `HADDR_SMBIDCYR0    :
           HRDATA[3:0]      = SMBIDCYR0;

        `HADDR_SMBWST1R0    :
           HRDATA[4:0]      = SMBWST1R0;

        `HADDR_SMBWST2R0    :
           HRDATA[4:0]      = SMBWST2R0;

        `HADDR_SMBWSTOENR0  :
           HRDATA[3:0]      = SMBWSTOENR0;

        `HADDR_SMBWSTWENR0  :
           HRDATA[3:0]      = SMBWSTWENR0;

        `HADDR_SMBCR0       :
           HRDATA[7:0]      = SMBCR0;

        `HADDR_SMBSR0       :
           HRDATA[2:0]      = {ToutErrR0, WPErrReg0, HSizeErrR0};

        `HADDR_SMBIDCYR1    :
           HRDATA[3:0]      = SMBIDCYR1;

        `HADDR_SMBWST1R1    :
           HRDATA[4:0]      = SMBWST1R1;

        `HADDR_SMBWST2R1    :
           HRDATA[4:0]      = SMBWST2R1;

        `HADDR_SMBWSTOENR1  :
           HRDATA[3:0]      = SMBWSTOENR1;

        `HADDR_SMBWSTWENR1  :
           HRDATA[3:0]      = SMBWSTWENR1;

        `HADDR_SMBCR1       :
           HRDATA[7:0]      = SMBCR1;

        `HADDR_SMBSR1       :
           HRDATA[2:0]      = {ToutErrR1, WPErrReg1, HSizeErrR1};

        `HADDR_SMBIDCYR2    :
           HRDATA[3:0]      = SMBIDCYR2;

        `HADDR_SMBWST1R2    :
           HRDATA[4:0]      = SMBWST1R2;

        `HADDR_SMBWST2R2    :
           HRDATA[4:0]      = SMBWST2R2;

        `HADDR_SMBWSTOENR2  :
           HRDATA[3:0]      = SMBWSTOENR2;

        `HADDR_SMBWSTWENR2  :
           HRDATA[3:0]      = SMBWSTWENR2;

        `HADDR_SMBCR2       :
           HRDATA[7:0]      = SMBCR2;

        `HADDR_SMBSR2       :
           HRDATA[2:0]      = {ToutErrR2, WPErrReg2, HSizeErrR2};

        `HADDR_SMBIDCYR3    :
           HRDATA[3:0]      = SMBIDCYR3;

        `HADDR_SMBWST1R3    :
           HRDATA[4:0]      = SMBWST1R3;

        `HADDR_SMBWST2R3    :
           HRDATA[4:0]      = SMBWST2R3;

        `HADDR_SMBWSTOENR3  :
           HRDATA[3:0]      = SMBWSTOENR3;

        `HADDR_SMBWSTWENR3  :
           HRDATA[3:0]      = SMBWSTWENR3;

        `HADDR_SMBCR3       :
           HRDATA[7:0]      = SMBCR3;

        `HADDR_SMBSR3       :
           HRDATA[2:0]      = {ToutErrR3, WPErrReg3, HSizeErrR3};

        `HADDR_SMBIDCYR4    :
           HRDATA[3:0]      = SMBIDCYR4;

        `HADDR_SMBWST1R4    :
           HRDATA[4:0]      = SMBWST1R4;

        `HADDR_SMBWST2R4    :
           HRDATA[4:0]      = SMBWST2R4;

        `HADDR_SMBWSTOENR4  :
           HRDATA[3:0]      = SMBWSTOENR4;

        `HADDR_SMBWSTWENR4  :
           HRDATA[3:0]      = SMBWSTWENR4;

        `HADDR_SMBCR4       :
           HRDATA[7:0]      = SMBCR4;

        `HADDR_SMBSR4       :
           HRDATA[2:0]      = {ToutErrR4, WPErrReg4, HSizeErrR4};

        `HADDR_SMBIDCYR5    :
           HRDATA[3:0]      = SMBIDCYR5;

        `HADDR_SMBWST1R5    :
           HRDATA[4:0]      = SMBWST1R5;

        `HADDR_SMBWST2R5    :
           HRDATA[4:0]      = SMBWST2R5;

        `HADDR_SMBWSTOENR5  :
           HRDATA[3:0]      = SMBWSTOENR5;

        `HADDR_SMBWSTWENR5  :
           HRDATA[3:0]      = SMBWSTWENR5;

        `HADDR_SMBCR5       :
           HRDATA[7:0]      = SMBCR5;

        `HADDR_SMBSR5       :
           HRDATA[2:0]      = {ToutErrR5, WPErrReg5, HSizeErrR5};

        `HADDR_SMBIDCYR6    :
           HRDATA[3:0]      = SMBIDCYR6;

        `HADDR_SMBWST1R6    :
           HRDATA[4:0]      = SMBWST1R6;

        `HADDR_SMBWST2R6    :
           HRDATA[4:0]      = SMBWST2R6;

        `HADDR_SMBWSTOENR6  :
           HRDATA[3:0]      = SMBWSTOENR6;

        `HADDR_SMBWSTWENR6  :
           HRDATA[3:0]      = SMBWSTWENR6;

        `HADDR_SMBCR6       :
           HRDATA[7:0]      = SMBCR6;

        `HADDR_SMBSR6       :
           HRDATA[2:0]      = {ToutErrR6, WPErrReg6, HSizeErrR6};

        `HADDR_SMBIDCYR7    :
           HRDATA[3:0]      = SMBIDCYR7;

        `HADDR_SMBWST1R7    :
           HRDATA[4:0]      = SMBWST1R7;

        `HADDR_SMBWST2R7    :
           HRDATA[4:0]      = SMBWST2R7;

        `HADDR_SMBWSTOENR7  :
           HRDATA[3:0]      = SMBWSTOENR7;

        `HADDR_SMBWSTWENR7  :
           HRDATA[3:0]      = SMBWSTWENR7;

        `HADDR_SMBCR7       :
           HRDATA[7:0]      = SMBCR7;

        `HADDR_SMBSR7       :
           HRDATA[2:0]      = {ToutErrR7, WPErrReg7, HSizeErrR7};
        
        `HADDR_SMBEWS       :
           HRDATA[0]        = WaitStatus;

        `HADDR_SMCPeriphID0 :
           HRDATA[7:0]      = SMCPeriphID0;

        `HADDR_SMCPeriphID1 :
           HRDATA[7:0]      = SMCPeriphID1;

        `HADDR_SMCPeriphID2 :
           HRDATA[7:0]      = {Revision, SMCPeriphID2};

        `HADDR_SMCPeriphID3 :
           HRDATA[7:0]      = SMCPeriphID3;

        `HADDR_SMCPCellID0  :
           HRDATA[7:0]      = SMCPCellID0;

        `HADDR_SMCPCellID1  :
           HRDATA[7:0]      = SMCPCellID1;

        `HADDR_SMCPCellID2  :
           HRDATA[7:0]      = SMCPCellID2;

        `HADDR_SMCPCellID3  :
           HRDATA[7:0]      = SMCPCellID3;

        default             :
           HRDATA           = 32'h00000000;
      endcase
    end
  else if (MemRdOver == 1'b1 || AhbRdEnStr == 1'b1)
    begin
      HRDATA           = RdWrBuf;
    end
  else
    begin
      HRDATA           = 32'h00000000;
    end
end // p_AhbRdComb

// -----------------------------------------------------------------------------
// logic for associating the errors generated to the particular bank
// -----------------------------------------------------------------------------
always @(iBnkAddStr or WaitToutErr or WaitStatus)
begin : p_BSRerrComb 

  ToutErrGen0      = 1'b0;
  ToutErrGen1      = 1'b0;
  ToutErrGen2      = 1'b0;
  ToutErrGen3      = 1'b0;
  ToutErrGen4      = 1'b0;
  ToutErrGen5      = 1'b0;
  ToutErrGen6      = 1'b0;
  ToutErrGen7      = 1'b0;
  NextWaitStatus   = WaitStatus;

  case (iBnkAddStr)
    3'b000 :
      begin
        ToutErrGen0      = WaitToutErr;
        NextWaitStatus   = WaitToutErr;
      end
    3'b001 :
      begin
        ToutErrGen1      = WaitToutErr;
        NextWaitStatus   = WaitToutErr;
      end
    3'b010 :
      begin
        ToutErrGen2      = WaitToutErr;
        NextWaitStatus   = WaitToutErr;
      end
    3'b011 :
      begin
        ToutErrGen3      = WaitToutErr;
        NextWaitStatus   = WaitToutErr;
      end
    3'b100 :
      begin
        ToutErrGen4      = WaitToutErr;
        NextWaitStatus   = WaitToutErr;
      end
    3'b101 :
      begin
        ToutErrGen5      = WaitToutErr;
        NextWaitStatus   = WaitToutErr;
      end
    3'b110 :
      begin
        ToutErrGen6      = WaitToutErr;
        NextWaitStatus   = WaitToutErr;
      end
    3'b111 :
      begin
        ToutErrGen7      = WaitToutErr;
        NextWaitStatus   = WaitToutErr;
      end
    default : ;
      
  endcase
end // p_BSRerrComb

// -----------------------------------------------------------------------------
// Delay the control signals for required amount of clocks
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_HSelDly1ClkSeq 
  if (HRESETn == 1'b0)
    begin
      HSelSmcD1        <= 1'b0;
    end
  else
    begin
      HSelSmcD1        <= HSELSMC;
    end
end // p_HSelDly1ClkSeq;

// -----------------------------------------------------------------------------
// logic for associating the Write protect errors generated to the
// particular bank
// -----------------------------------------------------------------------------
always @(WpErrTmp or HSelSmcD1 or HSizeErr or iHAddrCrnt)
begin : p_WPerrComb 

  WPErrGen0        = 1'b0;
  HSizeErrGen0     = 1'b0;
  WPErrGen1        = 1'b0;
  HSizeErrGen1     = 1'b0;
  WPErrGen2        = 1'b0;
  HSizeErrGen2     = 1'b0;
  WPErrGen3        = 1'b0;
  HSizeErrGen3     = 1'b0;
  WPErrGen4        = 1'b0;
  HSizeErrGen4     = 1'b0;
  WPErrGen5        = 1'b0;
  HSizeErrGen5     = 1'b0;
  WPErrGen6        = 1'b0;
  HSizeErrGen6     = 1'b0;
  WPErrGen7        = 1'b0;
  HSizeErrGen7     = 1'b0;

  if (HSelSmcD1 == 1'b1)
    begin
      case (iHAddrCrnt[28:26])
        3'b000 :
          begin
            WPErrGen0        = WpErrTmp;
            HSizeErrGen0     = HSizeErr;
          end
        3'b001 :
          begin
            WPErrGen1        = WpErrTmp;
            HSizeErrGen1     = HSizeErr;
          end
        3'b010 :
          begin
            WPErrGen2        = WpErrTmp;
            HSizeErrGen2     = HSizeErr;
          end
        3'b011 :
          begin
            WPErrGen3        = WpErrTmp;
            HSizeErrGen3     = HSizeErr;
          end
        3'b100 :
          begin
            WPErrGen4        = WpErrTmp;
            HSizeErrGen4     = HSizeErr;
          end
        3'b101 :
          begin
            WPErrGen5        = WpErrTmp;
            HSizeErrGen5     = HSizeErr;
          end
        3'b110 :
          begin
            WPErrGen6        = WpErrTmp;
            HSizeErrGen6     = HSizeErr;
          end
        3'b111 :
          begin
            WPErrGen7        = WpErrTmp;
            HSizeErrGen7     = HSizeErr;
          end
        default : ;
          
      endcase
    end
end // p_WPerrComb

// -----------------------------------------------------------------------------
// Write Data Output Multiplexer
// -----------------------------------------------------------------------------
always @(RegWrEn or HAddrReg or SMBIDCYR0 or SMBWST1R0 or SMBWST2R0 or
         SMBWSTOENR0 or SMBWSTWENR0 or SMBCR0 or
         SMBIDCYR1 or SMBWST1R1 or SMBWST2R1 or SMBWSTOENR1 or
         SMBWSTWENR1 or SMBCR1 or SMBIDCYR2 or SMBWST1R2 or
         SMBWST2R2 or SMBWSTOENR2 or SMBWSTWENR2 or SMBCR2 or
         SMBIDCYR3 or SMBWST1R3 or SMBWST2R3 or
         SMBWSTOENR3 or SMBWSTWENR3 or SMBCR3 or
         SMBIDCYR4 or SMBWST1R4 or SMBWST2R4 or SMBWSTOENR4 or
         SMBWSTWENR4 or SMBCR4 or SMBIDCYR5 or SMBWST1R5 or
         SMBWST2R5 or SMBWSTOENR5 or SMBWSTWENR5 or SMBCR5 or
         SMBIDCYR6 or SMBWST1R6 or SMBWST2R6 or
         SMBWSTOENR6 or SMBWSTWENR6 or SMBCR6 or
         SMBIDCYR7 or SMBWST1R7 or SMBWST2R7 or SMBWSTOENR7 or
         SMBWSTWENR7 or SMBCR7 or HWdataGtd or iMWCfgDone or WtdRegWr)
begin : p_RegWrComb 

  NextSMBIDCYR0    = SMBIDCYR0;
  NextSMBWST1R0    = SMBWST1R0;
  NextSMBWST2R0    = SMBWST2R0;
  NextSMBWSTOENR0  = SMBWSTOENR0;
  NextSMBWSTWENR0  = SMBWSTWENR0;
  NextSMBCR0       = SMBCR0;
  NextSMBIDCYR1    = SMBIDCYR1;
  NextSMBWST1R1    = SMBWST1R1;
  NextSMBWST2R1    = SMBWST2R1;
  NextSMBWSTOENR1  = SMBWSTOENR1;
  NextSMBWSTWENR1  = SMBWSTWENR1;
  NextSMBCR1       = SMBCR1;
  NextSMBIDCYR2    = SMBIDCYR2;
  NextSMBWST1R2    = SMBWST1R2;
  NextSMBWST2R2    = SMBWST2R2;
  NextSMBWSTOENR2  = SMBWSTOENR2;
  NextSMBWSTWENR2  = SMBWSTWENR2;
  NextSMBCR2       = SMBCR2;
  NextSMBIDCYR3    = SMBIDCYR3;
  NextSMBWST1R3    = SMBWST1R3;
  NextSMBWST2R3    = SMBWST2R3;
  NextSMBWSTOENR3  = SMBWSTOENR3;
  NextSMBWSTWENR3  = SMBWSTWENR3;
  NextSMBCR3       = SMBCR3;
  NextSMBIDCYR4    = SMBIDCYR4;
  NextSMBWST1R4    = SMBWST1R4;
  NextSMBWST2R4    = SMBWST2R4;
  NextSMBWSTOENR4  = SMBWSTOENR4;
  NextSMBWSTWENR4  = SMBWSTWENR4;
  NextSMBCR4       = SMBCR4;
  NextSMBIDCYR5    = SMBIDCYR5;
  NextSMBWST1R5    = SMBWST1R5;
  NextSMBWST2R5    = SMBWST2R5;
  NextSMBWSTOENR5  = SMBWSTOENR5;
  NextSMBWSTWENR5  = SMBWSTWENR5;
  NextSMBCR5       = SMBCR5;
  NextSMBIDCYR6    = SMBIDCYR6;
  NextSMBWST1R6    = SMBWST1R6;
  NextSMBWST2R6    = SMBWST2R6;
  NextSMBWSTOENR6  = SMBWSTOENR6;
  NextSMBWSTWENR6  = SMBWSTWENR6;
  NextSMBCR6       = SMBCR6;
  NextSMBIDCYR7    = SMBIDCYR7;
  NextSMBWST1R7    = SMBWST1R7;
  NextSMBWST2R7    = SMBWST2R7;
  NextSMBWSTOENR7  = SMBWSTOENR7;
  NextSMBWSTWENR7  = SMBWSTWENR7;
  NextSMBCR7[5:1]  = SMBCR7[5:1];
  ToutErrClr0      = 1'b0;
  WPErrClr0        = 1'b0;
  HSizeErrClr0     = 1'b0;
  ToutErrClr1      = 1'b0;
  WPErrClr1        = 1'b0;
  HSizeErrClr1     = 1'b0;
  ToutErrClr2      = 1'b0;
  WPErrClr2        = 1'b0;
  HSizeErrClr2     = 1'b0;
  ToutErrClr3      = 1'b0;
  WPErrClr3        = 1'b0;
  HSizeErrClr3     = 1'b0;
  ToutErrClr4      = 1'b0;
  WPErrClr4        = 1'b0;
  HSizeErrClr4     = 1'b0;
  ToutErrClr5      = 1'b0;
  WPErrClr5        = 1'b0;
  HSizeErrClr5     = 1'b0;
  ToutErrClr6      = 1'b0;
  WPErrClr6        = 1'b0;
  HSizeErrClr6     = 1'b0;
  ToutErrClr7      = 1'b0;
  WPErrClr7        = 1'b0;
  HSizeErrClr7     = 1'b0;

  if (RegWrEn == 1'b1 || (iMWCfgDone == 1'b1 && WtdRegWr == 1'b1))
    begin
      case (HAddrReg)
        `HADDR_SMBIDCYR0   :
          NextSMBIDCYR0    = HWdataGtd[3:0];

        `HADDR_SMBWST1R0   :
          NextSMBWST1R0    = HWdataGtd[4:0];

        `HADDR_SMBWST2R0   :
          NextSMBWST2R0    = HWdataGtd[4:0];

        `HADDR_SMBWSTOENR0 :
          NextSMBWSTOENR0  = HWdataGtd[3:0];

        `HADDR_SMBWSTWENR0 :
          NextSMBWSTWENR0  = HWdataGtd[3:0];

        `HADDR_SMBCR0      :
          NextSMBCR0       = HWdataGtd[7:0];

        `HADDR_SMBSR0      :
          begin
            ToutErrClr0      = HWdataGtd[2];
            WPErrClr0        = HWdataGtd[1];
            HSizeErrClr0     = HWdataGtd[0];
          end

        `HADDR_SMBIDCYR1   :
          NextSMBIDCYR1    = HWdataGtd[3:0];

        `HADDR_SMBWST1R1   :
          NextSMBWST1R1    = HWdataGtd[4:0];

        `HADDR_SMBWST2R1   :
          NextSMBWST2R1    = HWdataGtd[4:0];

        `HADDR_SMBWSTOENR1 :
          NextSMBWSTOENR1  = HWdataGtd[3:0];

        `HADDR_SMBWSTWENR1 :
          NextSMBWSTWENR1  = HWdataGtd[3:0];

        `HADDR_SMBCR1      :
          NextSMBCR1       = HWdataGtd[7:0];

        `HADDR_SMBSR1      :
          begin
            ToutErrClr1      = HWdataGtd[2];
            WPErrClr1        = HWdataGtd[1];
            HSizeErrClr1     = HWdataGtd[0];
          end

        `HADDR_SMBIDCYR2   :
          NextSMBIDCYR2    = HWdataGtd[3:0];

        `HADDR_SMBWST1R2   :
          NextSMBWST1R2    = HWdataGtd[4:0];

        `HADDR_SMBWST2R2   :
          NextSMBWST2R2    = HWdataGtd[4:0];

        `HADDR_SMBWSTOENR2 :
          NextSMBWSTOENR2  = HWdataGtd[3:0];

        `HADDR_SMBWSTWENR2 :
          NextSMBWSTWENR2  = HWdataGtd[3:0];

        `HADDR_SMBCR2      :
          NextSMBCR2       = HWdataGtd[7:0];

        `HADDR_SMBSR2      :
          begin
            ToutErrClr2      = HWdataGtd[2];
            WPErrClr2        = HWdataGtd[1];
            HSizeErrClr2     = HWdataGtd[0];
          end

        `HADDR_SMBIDCYR3   :
          NextSMBIDCYR3    = HWdataGtd[3:0];

        `HADDR_SMBWST1R3   :
          NextSMBWST1R3    = HWdataGtd[4:0];

        `HADDR_SMBWST2R3   :
          NextSMBWST2R3    = HWdataGtd[4:0];

        `HADDR_SMBWSTOENR3 :
          NextSMBWSTOENR3  = HWdataGtd[3:0];

        `HADDR_SMBWSTWENR3 :
          NextSMBWSTWENR3  = HWdataGtd[3:0];

        `HADDR_SMBCR3      :
          NextSMBCR3       = HWdataGtd[7:0];

        `HADDR_SMBSR3      :
          begin
            ToutErrClr3      = HWdataGtd[2];
            WPErrClr3        = HWdataGtd[1];
            HSizeErrClr3     = HWdataGtd[0];
          end

        `HADDR_SMBIDCYR4   :
          NextSMBIDCYR4    = HWdataGtd[3:0];

        `HADDR_SMBWST1R4   :
          NextSMBWST1R4    = HWdataGtd[4:0];

        `HADDR_SMBWST2R4   :
          NextSMBWST2R4    = HWdataGtd[4:0];

        `HADDR_SMBWSTOENR4 :
          NextSMBWSTOENR4  = HWdataGtd[3:0];

        `HADDR_SMBWSTWENR4 :
          NextSMBWSTWENR4  = HWdataGtd[3:0];

        `HADDR_SMBCR4      :
          NextSMBCR4       = HWdataGtd[7:0];

        `HADDR_SMBSR4      :
          begin
            ToutErrClr4      = HWdataGtd[2];
            WPErrClr4        = HWdataGtd[1];
            HSizeErrClr4     = HWdataGtd[0];
          end

        `HADDR_SMBIDCYR5   :
          NextSMBIDCYR5    = HWdataGtd[3:0];

        `HADDR_SMBWST1R5   :
          NextSMBWST1R5    = HWdataGtd[4:0];

        `HADDR_SMBWST2R5   :
          NextSMBWST2R5    = HWdataGtd[4:0];

        `HADDR_SMBWSTOENR5 :
          NextSMBWSTOENR5  = HWdataGtd[3:0];

        `HADDR_SMBWSTWENR5 :
          NextSMBWSTWENR5  = HWdataGtd[3:0];

        `HADDR_SMBCR5      :
          NextSMBCR5       = HWdataGtd[7:0];

        `HADDR_SMBSR5      :
          begin
            ToutErrClr5      = HWdataGtd[2];
            WPErrClr5        = HWdataGtd[1];
            HSizeErrClr5     = HWdataGtd[0];
          end

        `HADDR_SMBIDCYR6   :
          NextSMBIDCYR6    = HWdataGtd[3:0];

        `HADDR_SMBWST1R6   :
          NextSMBWST1R6    = HWdataGtd[4:0];

        `HADDR_SMBWST2R6   :
          NextSMBWST2R6    = HWdataGtd[4:0];

        `HADDR_SMBWSTOENR6 :
          NextSMBWSTOENR6  = HWdataGtd[3:0];

        `HADDR_SMBWSTWENR6 :
          NextSMBWSTWENR6  = HWdataGtd[3:0];

        `HADDR_SMBCR6      :
          NextSMBCR6       = HWdataGtd[7:0];

        `HADDR_SMBSR6      :
          begin
            ToutErrClr6      = HWdataGtd[2];
            WPErrClr6        = HWdataGtd[1];
            HSizeErrClr6     = HWdataGtd[0];
          end

        `HADDR_SMBIDCYR7   :
          NextSMBIDCYR7    = HWdataGtd[3:0];

        `HADDR_SMBWST1R7   :
          NextSMBWST1R7    = HWdataGtd[4:0];

        `HADDR_SMBWST2R7   :
          NextSMBWST2R7    = HWdataGtd[4:0];

        `HADDR_SMBWSTOENR7 :
          NextSMBWSTOENR7  = HWdataGtd[3:0];

        `HADDR_SMBWSTWENR7 :
          NextSMBWSTWENR7  = HWdataGtd[3:0];

        `HADDR_SMBCR7      :
          NextSMBCR7[5:1] = HWdataGtd[5:1];

        `HADDR_SMBSR7      :
          begin
            ToutErrClr7      = HWdataGtd[2];
            WPErrClr7        = HWdataGtd[1];
            HSizeErrClr7     = HWdataGtd[0];
          end

        default            : ;
        endcase
    end
end // p_RegWrComb;

// -----------------------------------------------------------------------------
// Sequential Process for Writeable Registers
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_RegWrSeq 
  if (HRESETn == 1'b0)
    begin
      SMBIDCYR0        <= 4'b1111;
      SMBWST1R0        <= 5'b11111;
      SMBWST2R0        <= 5'b11111;
      SMBWSTOENR0      <= 4'b0000;
      SMBWSTWENR0      <= 4'b0001;
      SMBCR0           <= 8'b10000000;
      SMBIDCYR1        <= 4'b1111;
      SMBWST1R1        <= 5'b11111;
      SMBWST2R1        <= 5'b11111;
      SMBWSTOENR1      <= 4'b0000;
      SMBWSTWENR1      <= 4'b0001;
      SMBCR1           <= 8'b00000000;
      SMBIDCYR2        <= 4'b1111;
      SMBWST1R2        <= 5'b11111;
      SMBWST2R2        <= 5'b11111;
      SMBWSTOENR2      <= 4'b0000;
      SMBWSTWENR2      <= 4'b0001;
      SMBCR2           <= 8'b01000000;
      SMBIDCYR3        <= 4'b1111;
      SMBWST1R3        <= 5'b11111;
      SMBWST2R3        <= 5'b11111;
      SMBWSTOENR3      <= 4'b0000;
      SMBWSTWENR3      <= 4'b0001;
      SMBCR3           <= 8'b00000000;
      SMBIDCYR4        <= 4'b1111;
      SMBWST1R4        <= 5'b11111;
      SMBWST2R4        <= 5'b11111;
      SMBWSTOENR4      <= 4'b0000;
      SMBWSTWENR4      <= 4'b0001;
      SMBCR4           <= 8'b10000000;
      SMBIDCYR5        <= 4'b1111;
      SMBWST1R5        <= 5'b11111;
      SMBWST2R5        <= 5'b11111;
      SMBWSTOENR5      <= 4'b0000;
      SMBWSTWENR5      <= 4'b0001;
      SMBCR5           <= 8'b10000000;
      SMBIDCYR6        <= 4'b1111;
      SMBWST1R6        <= 5'b11111;
      SMBWST2R6        <= 5'b11111;
      SMBWSTOENR6      <= 4'b0000;
      SMBWSTWENR6      <= 4'b0001;
      SMBCR6           <= 8'b01000000;
      SMBIDCYR7        <= 4'b1111;
      SMBWST1R7        <= 5'b11111;
      SMBWST2R7        <= 5'b11111;
      SMBWSTOENR7      <= 4'b0000;
      SMBWSTWENR7      <= 4'b0001;
      SMBCR7           <= 8'b00000000;
    end
  else
    begin
      SMBIDCYR0        <= NextSMBIDCYR0;
      SMBWST1R0        <= NextSMBWST1R0;
      SMBWST2R0        <= NextSMBWST2R0;
      SMBWSTOENR0      <= NextSMBWSTOENR0;
      SMBWSTWENR0      <= NextSMBWSTWENR0;
      SMBCR0           <= NextSMBCR0;
      SMBIDCYR1        <= NextSMBIDCYR1;
      SMBWST1R1        <= NextSMBWST1R1;
      SMBWST2R1        <= NextSMBWST2R1;
      SMBWSTOENR1      <= NextSMBWSTOENR1;
      SMBWSTWENR1      <= NextSMBWSTWENR1;
      SMBCR1           <= NextSMBCR1;
      SMBIDCYR2        <= NextSMBIDCYR2;
      SMBWST1R2        <= NextSMBWST1R2;
      SMBWST2R2        <= NextSMBWST2R2;
      SMBWSTOENR2      <= NextSMBWSTOENR2;
      SMBWSTWENR2      <= NextSMBWSTWENR2;
      SMBCR2           <= NextSMBCR2;
      SMBIDCYR3        <= NextSMBIDCYR3;
      SMBWST1R3        <= NextSMBWST1R3;
      SMBWST2R3        <= NextSMBWST2R3;
      SMBWSTOENR3      <= NextSMBWSTOENR3;
      SMBWSTWENR3      <= NextSMBWSTWENR3;
      SMBCR3           <= NextSMBCR3;
      SMBIDCYR4        <= NextSMBIDCYR4;
      SMBWST1R4        <= NextSMBWST1R4;
      SMBWST2R4        <= NextSMBWST2R4;
      SMBWSTOENR4      <= NextSMBWSTOENR4;
      SMBWSTWENR4      <= NextSMBWSTWENR4;
      SMBCR4           <= NextSMBCR4;
      SMBIDCYR5        <= NextSMBIDCYR5;
      SMBWST1R5        <= NextSMBWST1R5;
      SMBWST2R5        <= NextSMBWST2R5;
      SMBWSTOENR5      <= NextSMBWSTOENR5;
      SMBWSTWENR5      <= NextSMBWSTWENR5;
      SMBCR5           <= NextSMBCR5;
      SMBIDCYR6        <= NextSMBIDCYR6;
      SMBWST1R6        <= NextSMBWST1R6;
      SMBWST2R6        <= NextSMBWST2R6;
      SMBWSTOENR6      <= NextSMBWSTOENR6;
      SMBWSTWENR6      <= NextSMBWSTWENR6;
      SMBCR6           <= NextSMBCR6;
      SMBIDCYR7        <= NextSMBIDCYR7;
      SMBWST1R7        <= NextSMBWST1R7;
      SMBWST2R7        <= NextSMBWST2R7;
      SMBWSTOENR7      <= NextSMBWSTOENR7;
      SMBWSTWENR7      <= NextSMBWSTWENR7;
      SMBCR7           <= NextSMBCR7;
    end
end // p_RegWrSeq;

// -----------------------------------------------------------------------------
// Updating or clearing the WaitToutErr flag registers
// -----------------------------------------------------------------------------
always @(ToutErrGen0 or ToutErrGen1 or ToutErrGen2 or ToutErrGen3 or
         ToutErrGen4 or ToutErrGen5 or ToutErrGen6 or ToutErrGen7 or
         ToutErrClr0 or ToutErrClr1 or ToutErrClr2 or ToutErrClr3 or
         ToutErrClr4 or ToutErrClr5 or ToutErrClr6 or ToutErrClr7 or
         ToutErrR0 or ToutErrR1 or ToutErrR2 or ToutErrR3 or
         ToutErrR4 or ToutErrR5 or ToutErrR6 or ToutErrR7)
begin : p_ToutErRComb 

  NextToutErrR0    = ToutErrR0;
  NextToutErrR1    = ToutErrR1;
  NextToutErrR2    = ToutErrR2;
  NextToutErrR3    = ToutErrR3;
  NextToutErrR4    = ToutErrR4;
  NextToutErrR5    = ToutErrR5;
  NextToutErrR6    = ToutErrR6;
  NextToutErrR7    = ToutErrR7;

  if (ToutErrGen0 == 1'b1)
    begin
      NextToutErrR0    = 1'b1;
    end
  else if (ToutErrClr0 == 1'b1)
    begin
      NextToutErrR0    = 1'b0;
    end

  if (ToutErrGen1 == 1'b1)
    begin
      NextToutErrR1    = 1'b1;
    end
  else if (ToutErrClr1 == 1'b1)
    begin
      NextToutErrR1    = 1'b0;
    end

  if (ToutErrGen2 == 1'b1)
    begin
      NextToutErrR2    = 1'b1;
    end
  else if (ToutErrClr2 == 1'b1)
    begin
      NextToutErrR2    = 1'b0;
    end
  
  if (ToutErrGen3 == 1'b1)
    begin
      NextToutErrR3    = 1'b1;
    end
  else if (ToutErrClr3 == 1'b1)
    begin
      NextToutErrR3    = 1'b0;
    end
  
  if (ToutErrGen4 == 1'b1)
    begin
      NextToutErrR4    = 1'b1;
    end
  else if (ToutErrClr4 == 1'b1)
    begin
      NextToutErrR4    = 1'b0;
    end
  
  if (ToutErrGen5 == 1'b1)
    begin
      NextToutErrR5    = 1'b1;
    end
  else if (ToutErrClr5 == 1'b1)
    begin
      NextToutErrR5    = 1'b0;
    end

  if (ToutErrGen6 == 1'b1)
    begin
      NextToutErrR6    = 1'b1;
    end
  else if (ToutErrClr6 == 1'b1)
    begin
      NextToutErrR6    = 1'b0;
    end

  if (ToutErrGen7 == 1'b1)
    begin
      NextToutErrR7    = 1'b1;
    end
  else if (ToutErrClr7 == 1'b1)
    begin
      NextToutErrR7    = 1'b0;
    end

end // p_ToutErRComb;

// -----------------------------------------------------------------------------
// Updating or clearing the WrProtErr flag registers
// -----------------------------------------------------------------------------
always @(WPErrReg0 or WPErrReg1 or WPErrReg2 or WPErrReg3 or
         WPErrReg4 or WPErrReg5 or WPErrReg6 or WPErrReg7 or
         WPErrGen0 or WPErrGen1 or WPErrGen2 or WPErrGen3 or
         WPErrGen4 or WPErrGen5 or WPErrGen6 or WPErrGen7 or
         WPErrClr0 or WPErrClr1 or WPErrClr2 or WPErrClr3 or
         WPErrClr4 or WPErrClr5 or WPErrClr6 or WPErrClr7)
begin : p_WrProtErrComb 

  NextWPErrReg0    = WPErrReg0;
  NextWPErrReg1    = WPErrReg1;
  NextWPErrReg2    = WPErrReg2;
  NextWPErrReg3    = WPErrReg3;
  NextWPErrReg4    = WPErrReg4;
  NextWPErrReg5    = WPErrReg5;
  NextWPErrReg6    = WPErrReg6;
  NextWPErrReg7    = WPErrReg7;

  if (WPErrGen0 == 1'b1)
    begin
      NextWPErrReg0    = 1'b1;
    end
  else if (WPErrClr0 == 1'b1)
    begin
      NextWPErrReg0    = 1'b0;
    end

  if (WPErrGen1 == 1'b1)
    begin
      NextWPErrReg1    = 1'b1;
    end
  else if (WPErrClr1 == 1'b1)
    begin
      NextWPErrReg1    = 1'b0;
    end

  if (WPErrGen2 == 1'b1)
    begin
      NextWPErrReg2    = 1'b1;
    end
  else if (WPErrClr2 == 1'b1)
    begin
      NextWPErrReg2    = 1'b0;
    end
  
  if (WPErrGen3 == 1'b1)
    begin
      NextWPErrReg3    = 1'b1;
    end
  else if (WPErrClr3 == 1'b1)
    begin
      NextWPErrReg3    = 1'b0;
    end
  
  if (WPErrGen4 == 1'b1)
    begin
      NextWPErrReg4    = 1'b1;
    end
  else if (WPErrClr4 == 1'b1)
    begin
      NextWPErrReg4    = 1'b0;
    end
  
  if (WPErrGen5 == 1'b1)
    begin
      NextWPErrReg5    = 1'b1;
    end
  else if (WPErrClr5 == 1'b1)
    begin
      NextWPErrReg5    = 1'b0;
    end
  
  if (WPErrGen6 == 1'b1)
    begin
      NextWPErrReg6    = 1'b1;
    end
  else if (WPErrClr6 == 1'b1)
    begin
      NextWPErrReg6    = 1'b0;
    end

  if (WPErrGen7 == 1'b1)
    begin
      NextWPErrReg7    = 1'b1;
    end
  else if (WPErrClr7 == 1'b1)
    begin
      NextWPErrReg7    = 1'b0;
    end

end // p_WrProtErrComb;

// -----------------------------------------------------------------------------
// Updating or clearing the HSizeErr flag registers
// -----------------------------------------------------------------------------
always @(HSizeErrR0 or HSizeErrR1 or HSizeErrR2 or HSizeErrR3 or
         HSizeErrR4 or HSizeErrR5 or HSizeErrR6 or HSizeErrR7 or
         HSizeErrGen0 or HSizeErrGen1 or HSizeErrGen2 or
         HSizeErrGen3 or HSizeErrGen4 or HSizeErrGen5 or
         HSizeErrGen6 or HSizeErrGen7 or
         HSizeErrClr0 or HSizeErrClr1 or HSizeErrClr2 or
         HSizeErrClr3 or HSizeErrClr4 or HSizeErrClr5 or
         HSizeErrClr6 or HSizeErrClr7)
begin : p_HSizeErrRegComb 

  NextHSizeErrR0   = HSizeErrR0;
  NextHSizeErrR1   = HSizeErrR1;
  NextHSizeErrR2   = HSizeErrR2;
  NextHSizeErrR3   = HSizeErrR3;
  NextHSizeErrR4   = HSizeErrR4;
  NextHSizeErrR5   = HSizeErrR5;
  NextHSizeErrR6   = HSizeErrR6;
  NextHSizeErrR7   = HSizeErrR7;

  if (HSizeErrGen0 == 1'b1)
    begin
      NextHSizeErrR0   = 1'b1;
    end
  else if (HSizeErrClr0 == 1'b1)
    begin
      NextHSizeErrR0   = 1'b0;
    end

  if (HSizeErrGen1 == 1'b1)
    begin
      NextHSizeErrR1   = 1'b1;
    end
  else if (HSizeErrClr1 == 1'b1)
    begin
      NextHSizeErrR1   = 1'b0;
    end

  if (HSizeErrGen2 == 1'b1)
    begin
      NextHSizeErrR2   = 1'b1;
    end
  else if (HSizeErrClr2 == 1'b1)
    begin
      NextHSizeErrR2   = 1'b0;
    end

  if (HSizeErrGen3 == 1'b1)
    begin
      NextHSizeErrR3   = 1'b1;
    end
  else if (HSizeErrClr3 == 1'b1)
    begin
      NextHSizeErrR3   = 1'b0;
    end

  if (HSizeErrGen4 == 1'b1)
    begin
      NextHSizeErrR4   = 1'b1;
    end
  else if (HSizeErrClr4 == 1'b1)
    begin
      NextHSizeErrR4   = 1'b0;
    end

  if (HSizeErrGen5 == 1'b1)
    begin
      NextHSizeErrR5   = 1'b1;
    end
  else if (HSizeErrClr5 == 1'b1)
    begin
      NextHSizeErrR5   = 1'b0;
    end
  
  if (HSizeErrGen6 == 1'b1)
    begin
      NextHSizeErrR6   = 1'b1;
    end
  else if (HSizeErrClr6 == 1'b1)
    begin
      NextHSizeErrR6   = 1'b0;
    end

  if (HSizeErrGen7 == 1'b1)
    begin
      NextHSizeErrR7   = 1'b1;
    end
  else if (HSizeErrClr7 == 1'b1)
    begin
      NextHSizeErrR7   = 1'b0;
    end

end // p_HSizeErrRegComb;

// -----------------------------------------------------------------------------
// Sequential Process for storing the error status flag registers
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_ErrFlgRegSeq 
  if (HRESETn == 1'b0)
    begin
      ToutErrR0        <= 1'b0;
      ToutErrR1        <= 1'b0;
      ToutErrR2        <= 1'b0;
      ToutErrR3        <= 1'b0;
      ToutErrR4        <= 1'b0;
      ToutErrR5        <= 1'b0;
      ToutErrR6        <= 1'b0;
      ToutErrR7        <= 1'b0;
      WPErrReg0        <= 1'b0;
      WPErrReg1        <= 1'b0;
      WPErrReg2        <= 1'b0;
      WPErrReg3        <= 1'b0;
      WPErrReg4        <= 1'b0;
      WPErrReg5        <= 1'b0;
      WPErrReg6        <= 1'b0;
      WPErrReg7        <= 1'b0;
      HSizeErrR0       <= 1'b0;
      HSizeErrR1       <= 1'b0;
      HSizeErrR2       <= 1'b0;
      HSizeErrR3       <= 1'b0;
      HSizeErrR4       <= 1'b0;
      HSizeErrR5       <= 1'b0;
      HSizeErrR6       <= 1'b0;
      HSizeErrR7       <= 1'b0;
      WaitStatus       <= 1'b0;
    end
  else
    begin
      ToutErrR0        <= NextToutErrR0;
      ToutErrR1        <= NextToutErrR1;
      ToutErrR2        <= NextToutErrR2;
      ToutErrR3        <= NextToutErrR3;
      ToutErrR4        <= NextToutErrR4;
      ToutErrR5        <= NextToutErrR5;
      ToutErrR6        <= NextToutErrR6;
      ToutErrR7        <= NextToutErrR7;
      WPErrReg0        <= NextWPErrReg0;
      WPErrReg1        <= NextWPErrReg1;
      WPErrReg2        <= NextWPErrReg2;
      WPErrReg3        <= NextWPErrReg3;
      WPErrReg4        <= NextWPErrReg4;
      WPErrReg5        <= NextWPErrReg5;
      WPErrReg6        <= NextWPErrReg6;
      WPErrReg7        <= NextWPErrReg7;
      HSizeErrR0       <= NextHSizeErrR0;
      HSizeErrR1       <= NextHSizeErrR1;
      HSizeErrR2       <= NextHSizeErrR2;
      HSizeErrR3       <= NextHSizeErrR3;
      HSizeErrR4       <= NextHSizeErrR4;
      HSizeErrR5       <= NextHSizeErrR5;
      HSizeErrR6       <= NextHSizeErrR6;
      HSizeErrR7       <= NextHSizeErrR7;
      WaitStatus       <= NextWaitStatus;
    end

end // p_ErrFlgRegSeq;

// -----------------------------------------------------------------------------
// Registering the REMAP input after reset
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_StrRmpSeq 
  if (HRESETn == 1'b0)
    begin
      iRemapReg        <= 1'b0;
    end
  else
    begin
      iRemapReg        <= REMAP;
    end
end // p_StrRmpSeq;

// -----------------------------------------------------------------------------
// Bank specific parameter selection logic for WST1, WST2, WSTWEN, WSTOEN, RBLE,
// BM, CSPol, WaitPol and MW
// -----------------------------------------------------------------------------
always @(SMBWST1R0 or SMBWST2R0 or
         SMBWSTOENR0 or SMBWSTWENR0 or SMBCR0 or
         SMBWST1R1 or SMBWST2R1 or SMBWSTOENR1 or
         SMBWSTWENR1 or SMBCR1 or SMBWST1R2 or
         SMBWST2R2 or SMBWSTOENR2 or SMBWSTWENR2 or SMBCR2 or
         SMBWST1R3 or SMBWST2R3 or
         SMBWSTOENR3 or SMBWSTWENR3 or SMBCR3 or
         SMBWST1R4 or SMBWST2R4 or SMBWSTOENR4 or
         SMBWSTWENR4 or SMBCR4 or SMBWST1R5 or
         SMBWST2R5 or SMBWSTOENR5 or SMBWSTWENR5 or SMBCR5 or
         SMBWST1R6 or SMBWST2R6 or
         SMBWSTOENR6 or SMBWSTWENR6 or SMBCR6 or
         SMBWST1R7 or SMBWST2R7 or SMBWSTOENR7 or
         SMBWSTWENR7 or SMBCR7 or iCSPol or NextBnkAddStr or iRemapReg or iMW)
begin : p_ParaSelComb 

  WST1             = 5'b11111;
  WST2             = 5'b11111;
  WSTOEN           = 4'b1111;
  WSTWEN           = 4'b1111;
  RBLE             = 1'b0;
  WaitPol          = 1'b0;
  BM               = 1'b0;
  NextCSPol        = iCSPol;
  NextMW           = iMW;

  case (NextBnkAddStr)
    3'b000 :
      begin
        if (iRemapReg == 1'b1)
          begin
            WST1             = SMBWST1R0;
            WST2             = SMBWST2R0;
            WSTOEN           = SMBWSTOENR0;
            WSTWEN           = SMBWSTWENR0;
            RBLE             = SMBCR0[0];
            WaitPol          = SMBCR0[1];
            BM               = SMBCR0[5];
            NextMW           = SMBCR0[7:6];
          end
        else
          begin
            WST1             = SMBWST1R7;
            WST2             = SMBWST2R7;
            WSTOEN           = SMBWSTOENR7;
            WSTWEN           = SMBWSTWENR7;
            RBLE             = SMBCR7[0];
            WaitPol          = SMBCR7[1];
            BM               = SMBCR7[5];
            NextMW           = SMBCR7[7:6];
          end
      end
    3'b001 :
      begin
        WST1             = SMBWST1R1;
        WST2             = SMBWST2R1;
        WSTOEN           = SMBWSTOENR1;
        WSTWEN           = SMBWSTWENR1;
        RBLE             = SMBCR1[0];
        WaitPol          = SMBCR1[1];
        BM               = SMBCR1[5];
        NextMW           = SMBCR1[7:6];
      end
    3'b010 :
      begin
        WST1             = SMBWST1R2;
        WST2             = SMBWST2R2;
        WSTOEN           = SMBWSTOENR2;
        WSTWEN           = SMBWSTWENR2;
        RBLE             = SMBCR2[0];
        WaitPol          = SMBCR2[1];
        BM               = SMBCR2[5];
        NextMW           = SMBCR2[7:6];
      end
    3'b011 :
      begin
        WST1             = SMBWST1R3;
        WST2             = SMBWST2R3;
        WSTOEN           = SMBWSTOENR3;
        WSTWEN           = SMBWSTWENR3;
        RBLE             = SMBCR3[0];
        WaitPol          = SMBCR3[1];
        BM               = SMBCR3[5];
        NextMW           = SMBCR3[7:6];
      end
    3'b100 :
      begin
        WST1             = SMBWST1R4;
        WST2             = SMBWST2R4;
        WSTOEN           = SMBWSTOENR4;
        WSTWEN           = SMBWSTWENR4;
        RBLE             = SMBCR4[0];
        WaitPol          = SMBCR4[1];
        BM               = SMBCR4[5];
        NextMW           = SMBCR4[7:6];
      end
    3'b101 :
      begin
        WST1             = SMBWST1R5;
        WST2             = SMBWST2R5;
        WSTOEN           = SMBWSTOENR5;
        WSTWEN           = SMBWSTWENR5;
        RBLE             = SMBCR5[0];
        WaitPol          = SMBCR5[1];
        BM               = SMBCR5[5];
        NextMW           = SMBCR5[7:6];
      end
    3'b110 :
      begin
        WST1             = SMBWST1R6;
        WST2             = SMBWST2R6;
        WSTOEN           = SMBWSTOENR6;
        WSTWEN           = SMBWSTWENR6;
        RBLE             = SMBCR6[0];
        WaitPol          = SMBCR6[1];
        BM               = SMBCR6[5];
        NextMW           = SMBCR6[7:6];
      end
    3'b111 :
      begin
        WST1             = SMBWST1R7;
        WST2             = SMBWST2R7;
        WSTOEN           = SMBWSTOENR7;
        WSTWEN           = SMBWSTWENR7;
        RBLE             = SMBCR7[0];
        WaitPol          = SMBCR7[1];
        BM               = SMBCR7[5];
        NextMW           = SMBCR7[7:6];
      end
    default : ;
      
    endcase

  NextCSPol        =  {SMBCR7[3], SMBCR6[3], SMBCR5[3], SMBCR4[3],
                       SMBCR3[3], SMBCR2[3], SMBCR1[3], SMBCR0[3]};

end // p_ParaSelComb;

// -----------------------------------------------------------------------------
// Bank specific parameter selection logic for IDCY
// -----------------------------------------------------------------------------
always @(SMBIDCYR0 or SMBIDCYR1 or SMBIDCYR2 or SMBIDCYR3 or
         SMBIDCYR4 or SMBIDCYR5 or SMBIDCYR6 or SMBIDCYR7 or
         iBnkAddStr or iRemapReg)
begin : p_IdcySelComb 

  IDCY             = 4'b1111;

  case (iBnkAddStr)
    3'b000 :
      begin
        if (iRemapReg == 1'b1)
          begin
            IDCY             = SMBIDCYR0;
          end
        else
          begin
            IDCY             = SMBIDCYR7;
          end
      end
    3'b001 :
      begin
        IDCY             = SMBIDCYR1;
      end
    3'b010 :
      begin
        IDCY             = SMBIDCYR2;
      end
    3'b011 :
      begin
        IDCY             = SMBIDCYR3;
      end
    3'b100 :
      begin
        IDCY             = SMBIDCYR4;
      end
    3'b101 :
      begin
        IDCY             = SMBIDCYR5;
      end
    3'b110 :
      begin
        IDCY             = SMBIDCYR6;
      end
    3'b111 :
      begin
        IDCY             = SMBIDCYR7;
      end
    default : ;
      
    endcase
end // p_IdcySelComb;

// -----------------------------------------------------------------------------
// Bank address selection
// -----------------------------------------------------------------------------
assign NextBankAddr     = ((CrntMemWrBa == 1'b0 && iMemWrReq == 1'b0) &&
                           HSELSMC == 1'b1 && HREADYIN == 1'b1 &&
                           HTRANS[1] == 1'b1) ?
                          HADDR[28:26]        :
                          ((MemWrOver == 1'b1 &&
                            (iWtdWrReq == 1'b1 || iWtdRdReq == 1'b1)) ?
                           NextBnkAddWtd : BankAddr);

// -----------------------------------------------------------------------------
// Selection logic for WaitEn parameter
// -----------------------------------------------------------------------------
always @(SMBCR0 or SMBCR1 or SMBCR2 or SMBCR3 or SMBCR4 or SMBCR5 or
         SMBCR6 or SMBCR7 or iWaitEn or NextBankAddr or iRemapReg)
begin : p_WaitEnSelComb

  NextWaitEn       = iWaitEn;

  case (NextBankAddr)
    3'b000 :
      begin
        if (iRemapReg == 1'b1)
          begin
            NextWaitEn       = SMBCR0[2];
          end
        else
          begin
            NextWaitEn      = SMBCR7[2];
          end
      end
    3'b001 :
      begin
        NextWaitEn       = SMBCR1[2];
      end
    3'b010 :
      begin
        NextWaitEn       = SMBCR2[2];
      end
    3'b011 :
      begin
        NextWaitEn       = SMBCR3[2];
      end
    3'b100 :
      begin
        NextWaitEn       = SMBCR4[2];
      end
    3'b101 :
      begin
        NextWaitEn       = SMBCR5[2];
      end
    3'b110 :
      begin
        NextWaitEn       = SMBCR6[2];
      end
    3'b111 :
      begin
        NextWaitEn       = SMBCR7[2];
      end
    default : ;
      
  endcase
end // p_WaitEnSelComb;

// -----------------------------------------------------------------------------
// Bank specific WP selection logic
// -----------------------------------------------------------------------------
always @(SMBCR0 or SMBCR1 or SMBCR2 or SMBCR3 or SMBCR4 or
         SMBCR5 or SMBCR6 or SMBCR7 or HADDR or HSELSMC or
         HREADYIN or HTRANS or iRemapReg)
begin : p_WPSelComb 
  WP               = 1'b0;

  if (HSELSMC == 1'b1 && HREADYIN == 1'b1 && HTRANS[1] == 1'b1)
    begin
      case (HADDR[28:26])
        3'b000 :
          begin
            if (iRemapReg == 1'b1)
              begin
                WP              = SMBCR0[4];
              end
            else
              begin
                WP              = SMBCR7[4];
              end
          end
        3'b001 :
          begin
            WP               = SMBCR1[4];
          end
        3'b010 :
          begin
            WP               = SMBCR2[4];
          end
        3'b011 :
          begin
            WP               = SMBCR3[4];
          end
        3'b100 :
          begin
            WP               = SMBCR4[4];
          end
        3'b101 :
          begin
            WP               = SMBCR5[4];
          end
        3'b110 :
          begin
            WP               = SMBCR6[4];
          end
        3'b111 :
          begin
            WP               = SMBCR7[4];
          end
        default : ;
          
        endcase
    end
end // p_WPSelComb;

// -----------------------------------------------------------------------------
// Sequential Process for Writeable Registers
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_ParamSelSeq 
  if (HRESETn == 1'b0)
    begin
      iWaitEn          <= 1'b0;
      iCSPol           <= 8'b00000000;
      iMW              <= 2'b10;
      BankAddr         <= 3'b000;
    end
  else
    begin
      iWaitEn          <= NextWaitEn;
      iCSPol           <= NextCSPol;
      iMW              <= NextMW;
      BankAddr         <= NextBankAddr;
    end
end // p_ParamSelSeq;

// -----------------------------------------------------------------------------
// The memory size generation logic.
// -----------------------------------------------------------------------------
always @(NextMW)
begin : p_MSizeSelComb 
  iMSize08         = 1'b0;
  iMSize16         = 1'b0;
  iMSize32         = 1'b0;

  case (NextMW)
    2'b00 :
      begin
        iMSize08         = 1'b1;
      end
    2'b01 :
      begin
        iMSize16         = 1'b1;
      end
    2'b10 :
      begin
        iMSize32         = 1'b1;
      end
    default : ;
      
    endcase
end // p_MSizeSelComb;

// -----------------------------------------------------------------------------
// Connecting the local copies to the respective outputs
// -----------------------------------------------------------------------------
assign MSize08          = iMSize08;
assign MSize16          = iMSize16;
assign MSize32          = iMSize32;
assign MW               = NextMW;
assign WaitEn           = iWaitEn;
assign CSPol            = iCSPol;
assign HAddrCrnt        = iHAddrCrnt[25:0];
assign HAddrWtdCo       = NextHAddrWtd;
assign HTransRegCo      = NextHTransReg;
assign MemWrReq         = iMemWrReq;
assign MemRdReq         = iMemRdReq;
assign WtdRdReq         = iWtdRdReq;
assign WtdWrReq         = iWtdWrReq;
assign HSizeRegCo       = NextHSizeReg;
assign BnkAddStrCo      = NextBnkAddStr;
assign BufWrOver        = iBufWrOver;
assign MwPgm            = iMwPgm;
assign HBurstRegCo      = NextHBurstReg;
assign RemapReg         = iRemapReg;
assign MWCfgDone        = iMWCfgDone;

endmodule

// --================================== End ==================================--
