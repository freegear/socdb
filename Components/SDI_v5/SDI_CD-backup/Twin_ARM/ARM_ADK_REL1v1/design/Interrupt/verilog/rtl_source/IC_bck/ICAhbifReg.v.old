// --=================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from ARM Limited
//   (C) COPYRIGHT 2001 ARM Limited
//       ALL RIGHTS RESERVED
// The entire notice above must be reproduced on all authorised
// copies and copies may only be made to the extent permitted
// by a licensing agreement from ARM Limited.
//
// ---------------------------------------------------------------------
// Version and Release Control Information:
//
// File Name             : ICAhbifReg.v,v
// File Revision         : 1.4
//
// Release Information   : ADK_REL1v1
//
// ---------------------------------------------------------------------
// Purpose :
//           AHB Interface block
//
// --=================================================================--

// ---------------------------------------------------------------------
//
//                             ICAhbifReg
//                            ===========
//
// ---------------------------------------------------------------------
//
// Overview
// ========
//
//   This module decodes AHB accesses and generates the write strobes to
// the appropriate registers. This module also contains the output read
// data multiplexer.
//
// ---------------------------------------------------------------------
//                    IC Functional Mode Register Map
// ---------------------------------------------------------------------
// Offset  Read (Width)          Write (Width)       Description
// ---------------------------------------------------------------------
//
// 0x00 ICIRQStatus(32-bit)       -                  IRQ Status
// 0x04 ICFIQStatus(32-bit)       -                  FIQ Status
// 0x08 ICRawIntr(32-bit)         -                  Status before mask
// 0x0C ICIntSelect(32-bit)   ICIntSelect(32-bit)    Select IRQ or FIQ
// 0x10 ICIntEnable(32-bit)   ICIntEnable(32-bit)    Intr Enable
// 0x14      -                ICIntEnClear(32-bit)   Intr Enable Clear
// 0x18 ICSoftInt(32-bit)     ICSoftInt(32-bit)      Generate S/W Intr
// 0x1C      -                ICSoftIntClear(32-bit) S/W Intr Clear
// 0x20 ICProtection(1-bit)   ICProtection(1-bit)    Protection Enable
// 0x30 ICVectAddr(32-bit)    ICVectAddr(32-bit)     Intr Vector Address
// 0x34 ICDefVectAddr(32-bit) ICDefVectAddr(32-bit)  Default Vector Addr
//
// ---------------------------------------------------------------------
//                 IC Identification Register Map
// ---------------------------------------------------------------------
// Offset Read (Width)           Write (Width)       Description
// ---------------------------------------------------------------------
// 0xFE0 ICPeriphID0(8-bit)       -                  Peripheral ID 0
// 0xFE4 ICPeriphID1(8-bit)       -                  Peripheral ID 1
// 0xFE8 ICPeriphID2(4-bit)       -                  Peripheral ID 2
// 0xFEC ICPeriphID3(8-bit)       -                  Peripheral ID 3
// 0xFF0 ICPCellID0(8-bit)        -                  PrimeCell ID 0
// 0xFF4 ICPCellID1(8-bit)        -                  PrimeCell ID 1
// 0xFF8 ICPCellID2(8-bit)        -                  PrimeCell ID 2
// 0xFFC ICPCellID3(8-bit)        -                  PrimeCell ID 3
// ---------------------------------------------------------------------
//                 IC Test Mode Register Map
// ---------------------------------------------------------------------
// Offset Read (Width)         Write (Width)         Description
// ---------------------------------------------------------------------
// 0x300 ICITCR(1-bit)       ICITCR(1-bit)           Test Control
// 0x304 ICITIP1(2-bit)      ICITIP1(2-bit)          Input Read/Set
// 0x308 ICITIP2(32-bit)     ICITIP2(32-bit)         Input Read/Set
// 0x30C ICITOP1(2-bit)         -                    Output Set/Read
// 0x310 ICITOP2(32-bit)        -                    Output Set/Read
//
// ---------------------------------------------------------------------

`timescale 1ns/1ps

module ICAhbifReg (

// Inputs
    // AHB signals
    HCLK,             // AHB Clock
    HRESETn,          // AHB Reset
    HSELIC,           // IC select
    HWRITE,           // AHB Write
    HREADY,           // Shared HREADY line
    HPROT,            // Protection mode
    HTRANS,           // Bit 1 of HTRANS
    HSIZE,            // AHB transfer size
    HWDATA,           // AHB write data bus
    HADDR,            // AHB address bus
    Revision,         // Revision number from RevAnd
    ICINTSOURCE,      // Interrupt source

    // Daisy chain signals
    nICFIQIN,         // Fast interrupt input
    nICIRQIN,         // Normal interrupt input
    ICIRQCo,          // Normal IRQ
    ICVECTADDRIN,     // Vector Address input

    // Priority logic signals
    ICVECTADDROUTCo,  // Vector Address output
    ICRawIntrSync,    // Synced ICRawIntr
    ICIRQStatusSync,  // Synced ICIRQStatus
    ICFIQStatusSync,  // Synced ICFIQStatus

// Outputs
    PriorWrEnCo,      // VectAddr Write signal to priority logic
    PriorRdEn,        // VectAddr Read signal to priority logic
    HREADYOUT,        // IC ready signal
    HRESP,            // AHB transfer response
    NonVectIrqCo,     // Non-Vectored Interrupt
    ICDefVectAddr,    // Default Vector address
    nICFIQ,           // Fast Interrupt request
    ICIRQStatusCo,    // Normal IRQ status
    ICFIQStatusCo,    // FIQ status
    ICRawIntrCo,      // IC Raw Interrupt

    HRDATA);          // Read data bus
           
// ---------------------------------------------------------------------
// Port declarations
// ---------------------------------------------------------------------

  input          HCLK;
  input          HRESETn;
  input          HSELIC;
  input          HWRITE;
  input          HREADY;
  input          HPROT;
  input          HTRANS;
  input [2:0]    HSIZE;
  input [31:0]   HWDATA;
  input [11:2]   HADDR;
  input [3:0]    Revision;
  input [31:0]   ICINTSOURCE;
  input          nICFIQIN;
  input          nICIRQIN;
  input          ICIRQCo;
  input [31:0]   ICVECTADDRIN;
  input [31:0]   ICVECTADDROUTCo;
  input [31:0]   ICRawIntrSync;
  input [31:0]   ICIRQStatusSync;
  input [31:0]   ICFIQStatusSync;

  output         PriorWrEnCo;
  output         PriorRdEn;
  output         HREADYOUT;
  output [1:0]   HRESP;
  output         NonVectIrqCo;
  output [31:0]  ICDefVectAddr;
  output         nICFIQ;
  output [31:0]  ICIRQStatusCo;
  output [31:0]  ICFIQStatusCo;
  output [31:0]  ICRawIntrCo;
  output [31:0]  HRDATA;

// ---------------------------------------------------------------------
// Constant declarations
// ---------------------------------------------------------------------

`define ZEROFILL {32{1'b0}}

// AHB HRESP constant definitions
`define H_OKAY 2'b00
`define H_ERROR 2'b01

// AHB HREADYOUT constant definitions
`define H_WAIT 1'b0
`define H_READY 1'b1

// Register address definitions
`define HADDR_ICIRQSTATUS    10'b0000000000 //  ICIRQStatus    at offset 0x000
`define HADDR_ICFIQSTATUS    10'b0000000001 //  ICFIQStatus    at offset 0x004
`define HADDR_ICRAWINTR      10'b0000000010 //  ICRawIntr      at offset 0x008
`define HADDR_ICINTSELECT    10'b0000000011 //  ICIntSelect    at offset 0x00C
`define HADDR_ICINTENABLE    10'b0000000100 //  ICIntEnable    at offset 0x010
`define HADDR_ICINTENCLEAR   10'b0000000101 //  ICIntEnClear   at offset 0x014
`define HADDR_ICSOFTINT      10'b0000000110 //  ICSoftInt      at offset 0x018
`define HADDR_ICSOFTINTCLEAR 10'b0000000111 //  ICSoftIntClear at offset 0x01C
`define HADDR_ICPROTECTION   10'b0000001000 //  ICProtection   at offset 0x020
`define HADDR_ICVECTADDR     10'b0000001100 //  ICVectAddr     at offset 0x030
`define HADDR_ICDEFVECTADDR  10'b0000001101 //  ICDefVectAddr  at offset 0x034

`define HADDR_ICITCR         10'b0011000000 //  ICITCR  at offset 0x300
`define HADDR_ICITIP1        10'b0011000001 //  ICITIP1 at offset 0x304
`define HADDR_ICITIP2        10'b0011000010 //  ICITIP2 at offset 0x308
`define HADDR_ICITOP1        10'b0011000011 //  ICITOP1 at offset 0x30C
`define HADDR_ICITOP2        10'b0011000100 //  ICITOP2 at offset 0x310

`define HADDR_ICPERIPHID0    10'b1111111000 //  ICPeriphID0 at offset 0xFE0
`define HADDR_ICPERIPHID1    10'b1111111001 //  ICPeriphID1 at offset 0xFE4
`define HADDR_ICPERIPHID2    10'b1111111010 //  ICPeriphID2 at offset 0xFE8
`define HADDR_ICPERIPHID3    10'b1111111011 //  ICPeriphID3 at offset 0xFEC

`define HADDR_ICPCELLID0     10'b1111111100 //  ICPCellID0 at offset 0xFF0
`define HADDR_ICPCELLID1     10'b1111111101 //  ICPCellID1 at offset 0xFF4
`define HADDR_ICPCELLID2     10'b1111111110 //  ICPCellID2 at offset 0xFF8
`define HADDR_ICPCELLID3     10'b1111111111 //  ICPCellID3 at offset 0xFFC

// ---------------------------------------------------------------------
// Signal declarations
// ---------------------------------------------------------------------

// Input/Output Signals
  wire         HCLK;
  wire         HRESETn;
  wire         HSELIC;
  wire         HWRITE;
  wire         HREADY;
  wire         HPROT;
  wire         HTRANS;
  wire [2:0]   HSIZE;
  wire [31:0]  HWDATA;
  wire [11:2]  HADDR;
  wire [3:0]   Revision;
  wire [31:0]  ICINTSOURCE;
  wire         nICFIQIN;
  wire         nICIRQIN;
  wire         ICIRQCo;
  wire [31:0]  ICVECTADDRIN;
  wire [31:0]  ICVECTADDROUTCo;
  wire [31:0]  ICRawIntrSync;
  wire [31:0]  ICIRQStatusSync;
  wire [31:0]  ICFIQStatusSync;
  wire         PriorWrEnCo;
  wire         PriorRdEn;
  wire         NonVectIrqCo;
  wire [31:0]  ICDefVectAddr;
  wire         nICFIQ;
  wire [31:0]  ICIRQStatusCo;
  wire [31:0]  ICFIQStatusCo;
  wire [31:0]  ICRawIntrCo;

// Internal Signals
  // registered versions of output ports
  reg          HREADYOUT;
  reg   [1:0]  HRESP;
  reg  [31:0]  HRDATA;

  reg          NxtAccessEn;       // D-input of AccessEn
  reg          NxtHTrans;         // D-input of IntHTrans
  reg  [11:2]  NxtHAddr;          // D-input of IntHAddr
  reg          NxtHWrite;         // D-input of IntHWrite

  wire         ICFIQ;             // IC FIQ interrupt
  wire         iPriorRdEn;        // Internal copy of PriorRdEn
  reg          NxtHREADYOUT;      // D-input of HREADYOUT
  reg   [1:0]  NxtHRESP;          // D-input of HRESP
  reg          AccessEn;          // Access Enable for user and privilege mode

  reg  [11:2]  IntHAddr;          // Clocked HADDR
  reg          IntHTrans;         // Clocked HTRANS
  reg          HReadyD1;          // Delayed HREADY
  reg          IntHWrite;         // Clocked HWRITE
  reg          HSELICD1;          // Delayed HSELIC
  wire [11:2]  HAddrGated;        // Gated version of HADDR

  wire         ICVectAddrdec;     // ICVectAddr decode
  wire         ICIntSelectdec;    // ICIntSelect decode
  wire         ICIntEnabledec;    // ICIntEnable decode
  wire         ICIntEnCleardec;   // ICIntEnClear decode
  wire         ICSoftIntdec;      // ICSoftInt decode
  wire         ICSoftIntClrdec;   // ICSoftIntClear decode
  wire         ICProtectiondec;   // ICProtection decode
  wire         ICDefAddrdec;      // ICDefVectAddr decode
  wire         ICITCRdec;         // ICITCR decode
  wire         ICITIP1dec;        // ICITIP1 decode
  wire         ICITIP2dec;        // ICITIP2 decode

  wire         WrEn;              // Register Write enable
  wire         RdEn;              // Register Read enable
  reg  [31:0]  NxtICIRQStatus;    // D-input of ICIRQStatus
  reg  [31:0]  NxtICFIQStatus;    // D-input of ICFIQStatus
  wire [31:0]  NxtICRawIntr;      // D-input of ICRawIntr
  reg  [31:0]  ICIntSelect;       // Interrupt select
  reg  [31:0]  ICIntEnable;       // Interrupt Enable
  reg  [31:0]  ICSoftInt;         // Software Interrupt
  reg          ICProtection;      // Protection bit
  reg  [31:0]  iICDefVectAddr;    // Internal copy of ICDefVectAddr
  reg          ICITCR;            // Integration test control register
  reg   [7:6]  ICITIP1;           // Integration test input register 1
  reg  [31:0]  ICITIP2;           // Integration test input register 2

  wire  [7:0]  ICPeriphID0;       // Peripheral ID 0
  wire  [7:0]  ICPeriphID1;       // Peripheral ID 1
  wire  [3:0]  ICPeriphID2;       // Peripheral ID 2
  wire  [7:0]  ICPeriphID3;       // Peripheral ID 3
  wire  [7:0]  ICPCellID0;        // PrimeCell ID register 0
  wire  [7:0]  ICPCellID1;        // PrimeCell ID register 1
  wire  [7:0]  ICPCellID2;        // PrimeCell ID register 2
  wire  [7:0]  ICPCellID3;        // PrimeCell ID register 3

  wire         ICIntSelectWr;     // Write enable for ICIntSelect
  wire         ICIntEnableWr;     // Write enable for ICIntEnable
  wire         ICIntEnClearWr;    // Write enable for ICIntEnClear
  wire         ICSoftIntWr;       // Write enable for ICSoftInt
  wire         ICSoftIntClrWr;    // Write enable for ICSoftIntClear
  wire         ICProtectionWr;    // Write enable for ICProtection
  wire         ICDefVectAddrWr;   // Write enable for ICDefVectAddr
  wire         ICITCRWr;          // Write enable for ICITCR
  wire         ICITIP1Wr;         // Write enable for ICITIP1
  wire         ICITIP2Wr;         // Write enable for ICITIP2

  wire [31:0]  NxtICIntSelect;    // D-input of ICIntSelect
  reg  [31:0]  NxtICIntEnable;    // D-input of ICIntEnable
  reg  [31:0]  NxtICSoftInt;      // D-input of ICSoftInt
  wire         NxtICProtection;   // D-input of ICProtection
  wire [31:0]  NxtICDefAddr;      // D-input of ICDefVectAddr
  wire         NxtICITCR;         // D-input of ICITCR
  wire  [7:6]  NxtICITIP1;        // D-input of ICITIP1
  wire [31:0]  NxtICITIP2;        // D-input of ICITIP2

  wire [31:0]  iHWDataIn;         // Internal copy of HWDATA
  wire [31:0]  ICStatus;          // Status of IRQ and FIQ
  reg          ErrorResp;         // Flag for returning ERROR response
  reg          NxtErrorResp;      // D-input of ErrorResp
  wire         ITEN;              // Integration test enable
  wire [31:0]  IntICIntSource;    // Internal Interrupt source
  wire [31:0]  IcTip1Read;        // Integration test mux output for ITIP1
  wire [31:0]  IcTip2Read;        // Integration test mux output for ITIP2

// ---------------------------------------------------------------------
//
// Main body of code
// =================
//
// ---------------------------------------------------------------------
// Assign the IC Peripheral ID
//
// The IC Peripheral ID is a 32-bit value composed of the
// following 4 fields:
// Bits[11:0] -> Part Number used to identify the peripheral
//                For the IC this is 0x808
// Bits[19:12] -> Designer ID (ARM)
//                ARM is designated 0x41
// Bits[23:20] -> Peripheral Revision Number
//                For the IC this is 0x00
// Bits[31:24] -> Peripheral Configuration Options
//                For the IC this is 0x00
//
// The 32-bits are readable via 4 separate address locations with
// each location returning 8 valid bits at positions[7:0]. The
// values returned by the 4 Peripheral ID registers are given below:
//
// ICPeriphID0 = 0x08
// ICPeriphID1 = 0x18
// ICPeriphID2 = 0x4
// ICPeriphID3 = 0x00
// ---------------------------------------------------------------------
  assign ICPeriphID0 = 8'b00001000;
  assign ICPeriphID1 = 8'b00011000;
  assign ICPeriphID2 = 4'b0100;
  assign ICPeriphID3 = 8'b00000000;

// ---------------------------------------------------------------------
// Assign the IC PrimeCell ID
//
// ICPCellID0 = 0x0D
// ICPCellID1 = 0xF0
// ICPCellID2 = 0x05
// ICPCellID3 = 0xB1
// These PrimeCell ID values should not be changed.
// ---------------------------------------------------------------------
  assign ICPCellID0 = 8'b00001101;
  assign ICPCellID1 = 8'b11110000;
  assign ICPCellID2 = 8'b00000101;
  assign ICPCellID3 = 8'b10110001;

// ---------------------------------------------------------------------
// Gate the HWDATA bus to minimise toggling.
// ---------------------------------------------------------------------
  assign iHWDataIn = (((HSELICD1) & (IntHWrite)) ? HWDATA : (`ZEROFILL));

// ---------------------------------------------------------------------
// Combinational process for generating the AccessEn signal.
// Set the Access signal if
// 1. The incoming access is a 32-bit privilege mode access and the
// Protection bit is set.
// 2. The incoming access is any 32-bit access and the Protection bit is
// cleared.
//
// ---------------------------------------------------------------------
  always @ (ICProtection or HPROT or HSELIC or HREADY or AccessEn or HSIZE)
  begin : p_SetAccessEnComb
    if (HSELIC && HREADY)
      begin
        if ((!ICProtection || (ICProtection && HPROT)) && (HSIZE == 3'b010))
          NxtAccessEn = 1'b1;
        else
          NxtAccessEn = 1'b0;
      end
    else
      begin
        NxtAccessEn = AccessEn;
      end
  end

// ---------------------------------------------------------------------
// Sequential process for generating the AccessEn signal.
// ---------------------------------------------------------------------
  always @ (posedge HCLK or negedge HRESETn)
  begin : p_SetAccessEnSeq
    if (!HRESETn)
      AccessEn <= 1'b0;
    else
      AccessEn <= NxtAccessEn;
  end

// ---------------------------------------------------------------------
// Combinational process for generation of Responses.
// ---------------------------------------------------------------------
  always @ (HSIZE or HSELIC or HREADY or ErrorResp or HTRANS)
  begin : p_ResponseComb
    // If the ErrorResp flag is set, terminate the 2-cycle
    // ERROR response by driving HREADYOUT high.
    if (ErrorResp)
      begin
        NxtHREADYOUT = `H_READY;
        NxtHRESP     = `H_ERROR;
        NxtErrorResp = 1'b0;
      end
    else if (HSELIC && HREADY)
      begin
        // If the incoming access is an NSEQ or a SEQ transaction
        // and the transfer size is not 32-bits, initiate the
        // first cycle of the 2-cycle ERROR response.
        if ((HSIZE != 3'b010) && HTRANS)
          begin
            NxtHREADYOUT = `H_WAIT;
            NxtHRESP     = `H_ERROR;
            NxtErrorResp = 1'b1;
            // Return a 0-Wait state OK response if the incoming
            // transaction is an NSEQ or a SEQ transaction and the
            // transfer size is 32-bits
            // OR
            // If the incoming access indicates an IDLE or BUSY
            // transaction.
          end
        else
          begin
            NxtHREADYOUT = `H_READY;
            NxtHRESP     = `H_OKAY;
            NxtErrorResp = 1'b0;
          end
        // Drive HREADYOUT high if the access is not to the IC.
      end
         else
           begin
             NxtHREADYOUT = `H_READY;
             NxtHRESP     = `H_OKAY;
             NxtErrorResp = 1'b0;
           end
  end

// ---------------------------------------------------------------------
// Sequential process for generation of Responses.
// ---------------------------------------------------------------------
  always @ (posedge HCLK or negedge HRESETn)
  begin : p_ResponseSeq
    if (!HRESETn)
      begin
        HREADYOUT <= `H_READY;
        HRESP     <= `H_OKAY;
        ErrorResp <= 1'b0;
      end
    else
      begin
        HREADYOUT <= NxtHREADYOUT;
        HRESP     <= NxtHRESP;
        ErrorResp <= NxtErrorResp;
      end
  end

// ---------------------------------------------------------------------
// Combinational process to write into and clear the
// ICSoftInt register.
// Writes to the ICSoftInt address location will set only those bits
// for which the HWDATAIn[i] is high. All other bits retain their
// previous value.
// Writes to the ICSoftIntClear address location will clear only
// those bits for which the HWDATAIn[i] is high. All other bits remain
// unaffected.
// ---------------------------------------------------------------------
  always @ (ICSoftIntWr or ICSoftIntClrWr or iHWDataIn or ICSoftInt)
  begin : p_SetSoftIntComb
    NxtICSoftInt = ICSoftInt;
    if (ICSoftIntWr)
      begin : SoftIntSet_loop
        integer i;
        for (i = 0; i <= 31; i = i + 1)
          begin
            if (iHWDataIn[i])
              NxtICSoftInt[i] = 1'b1;
          end
      end // if (ICSoftIntWr)
    else if (ICSoftIntClrWr)
      begin : SoftIntClr_loop
        integer i;
        for (i = 0; i <= 31; i = i + 1)
          begin
            if (iHWDataIn[i])
              NxtICSoftInt[i] = 1'b0;
          end
      end // if (ICSoftIntClrWr)
  end


// ---------------------------------------------------------------------
// Combinational process to write into and clear the
// ICIntEnable register.
// Writes to the ICIntEnable address location will set only those bits
// for which the HWDATAIn[i] is high. All other bits retain their
// previous value.
// Writes to the ICIntEnClear address location will clear only
// those bits for which the HWDATAIn[i] is high. All other bits remain
// unaffected.
// ---------------------------------------------------------------------
  always @ (ICIntEnableWr or ICIntEnClearWr or iHWDataIn or ICIntEnable)
  begin : p_SetIntEnComb
    NxtICIntEnable = ICIntEnable;
    if (ICIntEnableWr)
      begin : IntEnSet_loop
        integer i;
        for (i = 0; i <= 31;i = i + 1)
          begin
            if (iHWDataIn[i])
              NxtICIntEnable[i] = 1'b1;
          end
      end // if (ICIntEnableWr)
    else if (ICIntEnClearWr)
      begin : IntEnClr_loop
        integer i;
        for (i = 0; i <= 31;i = i + 1)
          begin
            if (iHWDataIn[i])
              NxtICIntEnable[i] = 1'b0;
          end
      end // if (ICIntEnClearWr)
  end

// ---------------------------------------------------------------------
// Save power by preventing change in internal address bus when the
// device is not selected.
// ---------------------------------------------------------------------
  assign HAddrGated = HSELIC ? HADDR : 10'b0000000000;

// ---------------------------------------------------------------------
// Combinational process for generation of clocked input AHB signals
// (HTRANS, HWRITE, HADDR) which will be used for generation of
// read and write enables.
// ---------------------------------------------------------------------
  always @ (HSELIC or HREADY or HTRANS or HAddrGated or HWRITE or IntHTrans or
            IntHAddr or IntHWrite)
  begin : p_IntCntlComb
    if (HSELIC && HREADY)
      begin
        NxtHTrans = HTRANS;
        NxtHAddr  = HAddrGated;
        NxtHWrite = HWRITE;
      end
    else
      begin
        NxtHTrans = IntHTrans;
        NxtHAddr  = IntHAddr;
        NxtHWrite = IntHWrite;
      end
  end

// ---------------------------------------------------------------------
// Sequential process for generation of clocked HTRANS, HWRITE, HADDR.
// ---------------------------------------------------------------------
  always @ (posedge HCLK or negedge HRESETn)
  begin : p_IntCntlSeq
    if (!HRESETn)
      begin
        IntHTrans <= 1'b0;
        IntHAddr  <= 10'b0000000000;
        IntHWrite <= 1'b0;
      end
    else
      begin
        IntHTrans <= NxtHTrans;
        IntHAddr  <= NxtHAddr;
        IntHWrite <= NxtHWrite;
      end
  end

// ---------------------------------------------------------------------
// Sequential process for generation of one clock delayed HREADY
// and HSELIC.
// ---------------------------------------------------------------------
  always @ (posedge HCLK or negedge HRESETn)
  begin : p_DelHSigSeq
    if (!HRESETn)
      begin
        HReadyD1 <= 1'b0;
        HSELICD1 <= 1'b0;
      end
    else
      begin
        HReadyD1 <= HREADY;
        HSELICD1 <= HSELIC;
      end
  end // block: p_DelHSigSeq

// ---------------------------------------------------------------------
// Generate combinational decodes from IntHADDR for register accesses.
// ---------------------------------------------------------------------
// ---------------------------------------------------------------------
//  Functional Mode Registers.
// ---------------------------------------------------------------------
// ICVectAddr
  assign ICVectAddrdec   = (IntHAddr == `HADDR_ICVECTADDR)     ? 1'b1 : 1'b0;

// ICIntSelect
  assign ICIntSelectdec  = (IntHAddr == `HADDR_ICINTSELECT)    ? 1'b1 : 1'b0;

// ICIntEnable
  assign ICIntEnabledec  = (IntHAddr == `HADDR_ICINTENABLE)    ? 1'b1 : 1'b0;

// ICIntEnClear
  assign ICIntEnCleardec = (IntHAddr == `HADDR_ICINTENCLEAR)   ? 1'b1 : 1'b0;

// ICSoftInt
  assign ICSoftIntdec    = (IntHAddr == `HADDR_ICSOFTINT)      ? 1'b1 : 1'b0;

// ICSoftIntClear
  assign ICSoftIntClrdec = (IntHAddr == `HADDR_ICSOFTINTCLEAR) ? 1'b1 : 1'b0;

// ICProtection
  assign ICProtectiondec = (IntHAddr == `HADDR_ICPROTECTION)   ? 1'b1 : 1'b0;

// ICDefVectAddr
  assign ICDefAddrdec    = (IntHAddr == `HADDR_ICDEFVECTADDR)  ? 1'b1 : 1'b0;

// ---------------------------------------------------------------------
// Test Register decodes
// ---------------------------------------------------------------------
// ICITCR
  assign ICITCRdec  = (IntHAddr == `HADDR_ICITCR)  ? 1'b1 : 1'b0;

// ICITIP1
  assign ICITIP1dec = (IntHAddr == `HADDR_ICITIP1) ? 1'b1 : 1'b0;

// ICITIP2
  assign ICITIP2dec = (IntHAddr == `HADDR_ICITIP2) ? 1'b1 : 1'b0;


// ---------------------------------------------------------------------
// Write Interface
// ---------------------------------------------------------------------
// Combinational logic for WrEn.
  assign WrEn = HSELICD1 & IntHTrans & IntHWrite & HReadyD1 & AccessEn;

// ---------------------------------------------------------------------
// Functional Mode Registers
// ---------------------------------------------------------------------
// ICIntSelect
  assign ICIntSelectWr   = WrEn & ICIntSelectdec;

// ICIntEnable
  assign ICIntEnableWr   = WrEn & ICIntEnabledec;

// ICIntEnClear
  assign ICIntEnClearWr  = WrEn & ICIntEnCleardec;

// ICSoftInt
  assign ICSoftIntWr     = WrEn & ICSoftIntdec;

// ICSoftIntClear
  assign ICSoftIntClrWr  = WrEn & ICSoftIntClrdec;

// ICProtection
  assign ICProtectionWr  = WrEn & ICProtectiondec;

// ICVectAddr
  assign PriorWrEnCo     = WrEn & ICVectAddrdec;

// ICDefVectAddr
  assign ICDefVectAddrWr = WrEn & ICDefAddrdec;

// -------------------------------------------------------------------
// Test Registers
// ---------------------------------------------------------------------
// ICITCR
  assign ICITCRWr  = WrEn & ICITCRdec;

// ICITIP1
  assign ICITIP1Wr = WrEn & ICITIP1dec;

// ICITIP2
  assign ICITIP2Wr = WrEn & ICITIP2dec;


// ---------------------------------------------------------------------
// Read interface
// ---------------------------------------------------------------------
// Combinational logic for creating Register Read enables.
  assign RdEn = HSELICD1 & IntHTrans & (~IntHWrite) & HReadyD1 & AccessEn;

// ---------------------------------------------------------------------
// Functional mode registers
// ---------------------------------------------------------------------
// ICVectAddr
  assign iPriorRdEn = RdEn & ICVectAddrdec;

// ---------------------------------------------------------------------
// Combinational logic for all writeable registers.
//
// When the respective write enable input is asserted, copy the contents
// of the HWDataIn bus into the corresponding registers.
// ---------------------------------------------------------------------
  assign NxtICIntSelect  = ICIntSelectWr   ? iHWDataIn[31:0] : ICIntSelect;
  assign NxtICProtection = ICProtectionWr  ? iHWDataIn[0]    : ICProtection;
  assign NxtICDefAddr    = ICDefVectAddrWr ? iHWDataIn[31:0] : iICDefVectAddr;

// ---------------------------------------------------------------------
// Test Registers
// ---------------------------------------------------------------------
  assign NxtICITCR  = ICITCRWr  ? iHWDataIn[0]   : ICITCR;
  assign NxtICITIP1 = ICITIP1Wr ? iHWDataIn[7:6] : ICITIP1;
  assign NxtICITIP2 = ICITIP2Wr ? iHWDataIn      : ICITIP2;

// ---------------------------------------------------------------------
// Sequential process for writeable registers
// ---------------------------------------------------------------------
  always @ (posedge HCLK or negedge HRESETn)
  begin : p_RegSeq
    if (!HRESETn)
      begin
        ICIntSelect    <= `ZEROFILL;
        ICIntEnable    <= `ZEROFILL;
        ICSoftInt      <= `ZEROFILL;
        ICProtection   <= 1'b0;
        iICDefVectAddr <= `ZEROFILL;
        ICITCR         <= 1'b0;
        ICITIP1        <= 2'b00;
        ICITIP2        <= `ZEROFILL;
      end
    else
      begin
        ICIntSelect    <= NxtICIntSelect;
        ICIntEnable    <= NxtICIntEnable;
        ICSoftInt      <= NxtICSoftInt;
        ICProtection   <= NxtICProtection;
        iICDefVectAddr <= NxtICDefAddr;
        ICITCR         <= NxtICITCR;
        ICITIP1        <= NxtICITIP1;
        ICITIP2        <= NxtICITIP2;
      end
  end

// ---------------------------------------------------------------------
// Combinational logic for generation of ITEN, Test Interrupt Source,
// Raw interrupt and vector status.
// ITEN bit will contol IntICIntSource. If ITEN is deasserted then
// IntIcIntSource will contain ICINTSOURCE, else Zero
// ---------------------------------------------------------------------
  assign ITEN = ICITCR;
  assign IntICIntSource = (ITEN == 1'b0) ? ICINTSOURCE : `ZEROFILL;
  assign NxtICRawIntr   = (IntICIntSource | ICSoftInt);
  assign ICStatus       = (NxtICRawIntr & ICIntEnable);

// ---------------------------------------------------------------------
// Combinational logic for generation of IRQ and FIQ status.
// ---------------------------------------------------------------------
  always @ (ICStatus or ICIntSelect)
  begin : p_SetStatusComb
    integer i;
    for (i = 0; i <= 31;i = i + 1)
      begin
        if (ICIntSelect[i])
          begin
            NxtICFIQStatus[i] = ICStatus[i];
            NxtICIRQStatus[i] = 1'b0;
          end
        else
          begin
            NxtICFIQStatus[i] = 1'b0;
            NxtICIRQStatus[i] = ICStatus[i];
          end
      end
  end

// ---------------------------------------------------------------------
// Raise the FIQ interrupt if any of the NxtICFIQStatus bits are set
// or if the external FIQ interrupt is active.
// ---------------------------------------------------------------------
  assign ICFIQ = NxtICFIQStatus[0]  | NxtICFIQStatus[1]  | NxtICFIQStatus[2]  |
                 NxtICFIQStatus[3]  | NxtICFIQStatus[4]  | NxtICFIQStatus[5]  |
                 NxtICFIQStatus[6]  | NxtICFIQStatus[7]  | NxtICFIQStatus[8]  |
                 NxtICFIQStatus[9]  | NxtICFIQStatus[10] | NxtICFIQStatus[11] |
                 NxtICFIQStatus[12] | NxtICFIQStatus[13] | NxtICFIQStatus[14] |
                 NxtICFIQStatus[15] | NxtICFIQStatus[16] | NxtICFIQStatus[17] |
                 NxtICFIQStatus[18] | NxtICFIQStatus[19] | NxtICFIQStatus[20] |
                 NxtICFIQStatus[21] | NxtICFIQStatus[22] | NxtICFIQStatus[23] |
                 NxtICFIQStatus[24] | NxtICFIQStatus[25] | NxtICFIQStatus[26] |
                 NxtICFIQStatus[27] | NxtICFIQStatus[28] | NxtICFIQStatus[29] |
                 NxtICFIQStatus[30] | NxtICFIQStatus[31] | (~nICFIQIN);

// ---------------------------------------------------------------------
// Generation of nICFIQ.
// ---------------------------------------------------------------------
  assign nICFIQ = (~ICFIQ);

// ---------------------------------------------------------------------
// Raise a non-Vectored interrupt if any of the NxtICIRQStatus bits
// are set.
// ---------------------------------------------------------------------
  assign NonVectIrqCo = NxtICIRQStatus[0]  | NxtICIRQStatus[1]  |
                        NxtICIRQStatus[2]  | NxtICIRQStatus[3]  |
                        NxtICIRQStatus[4]  | NxtICIRQStatus[5]  |
                        NxtICIRQStatus[6]  | NxtICIRQStatus[7]  |
                        NxtICIRQStatus[8]  | NxtICIRQStatus[9]  |
                        NxtICIRQStatus[10] | NxtICIRQStatus[11] |
                        NxtICIRQStatus[12] | NxtICIRQStatus[13] |
                        NxtICIRQStatus[14] | NxtICIRQStatus[15] |
                        NxtICIRQStatus[16] | NxtICIRQStatus[17] |
                        NxtICIRQStatus[18] | NxtICIRQStatus[19] |
                        NxtICIRQStatus[20] | NxtICIRQStatus[21] |
                        NxtICIRQStatus[22] | NxtICIRQStatus[23] |
                        NxtICIRQStatus[24] | NxtICIRQStatus[25] |
                        NxtICIRQStatus[26] | NxtICIRQStatus[27] |
                        NxtICIRQStatus[28] | NxtICIRQStatus[29] |
                        NxtICIRQStatus[30] | NxtICIRQStatus[31];

// ---------------------------------------------------------------------
// Integration test mux for ITIP1
// ---------------------------------------------------------------------
  assign IcTip1Read = (ITEN == 1'b0) ?

                      {24'h000000, nICIRQIN, nICFIQIN, 6'b000000} :

                      {24'h000000, ICITIP1, 6'b000000};

// ---------------------------------------------------------------------
// Integration test mux for ITIP1
// ---------------------------------------------------------------------
     assign IcTip2Read = (ITEN == 1'b0) ? ICVECTADDRIN : ICITIP2;

// ---------------------------------------------------------------------
// Read Data Output Multiplexer.
// When the peripheral is not being accessed, '0's are driven on the
// Read Databus (HRDATA) so as not to place any restrictions on the
// method of external bus connection. The external data buses of the
// peripherals on the AHB may then be connected using Muxed or Ored
// bus connection method.
// ---------------------------------------------------------------------
  always @ (RdEn or IntHAddr or ICIRQCo or ICFIQ or IcTip2Read or IcTip1Read or
            ICVECTADDROUTCo or ICIRQStatusSync or ICFIQStatusSync or
            ICRawIntrSync or ICITCR or ICIntSelect or ICIntEnable or
            ICSoftInt or ICProtection or iICDefVectAddr or ICPeriphID0 or
            ICPeriphID1 or Revision or ICPeriphID2 or ICPeriphID3 or
            ICPCellID0 or ICPCellID1 or ICPCellID2 or ICPCellID3)
  begin : p_RdDataOutComb
    if (RdEn)
      begin
        case (IntHAddr)
          `HADDR_ICITOP1       : HRDATA = {24'h000000,ICIRQCo,ICFIQ,6'b000000};
          `HADDR_ICITIP2       : HRDATA = IcTip2Read;
          `HADDR_ICITIP1       : HRDATA = IcTip1Read;
          `HADDR_ICITOP2       : HRDATA = ICVECTADDROUTCo;
          `HADDR_ICVECTADDR    : HRDATA = ICVECTADDROUTCo;
          `HADDR_ICIRQSTATUS   : HRDATA = ICIRQStatusSync;
          `HADDR_ICFIQSTATUS   : HRDATA = ICFIQStatusSync;
          `HADDR_ICRAWINTR     : HRDATA = ICRawIntrSync;
          `HADDR_ICITCR        : HRDATA = {{31{1'b0}}, ICITCR};
          `HADDR_ICINTSELECT   : HRDATA = ICIntSelect;
          `HADDR_ICINTENABLE   : HRDATA = ICIntEnable;
          `HADDR_ICSOFTINT     : HRDATA = ICSoftInt;
          `HADDR_ICPROTECTION  : HRDATA = {{31{1'b0}}, ICProtection};
          `HADDR_ICDEFVECTADDR : HRDATA = iICDefVectAddr;
          `HADDR_ICPERIPHID0   : HRDATA = {24'h000000, ICPeriphID0};
          `HADDR_ICPERIPHID1   : HRDATA = {24'h000000, ICPeriphID1};
          `HADDR_ICPERIPHID2   : HRDATA = {24'h000000, Revision, ICPeriphID2};
          `HADDR_ICPERIPHID3   : HRDATA = {24'h000000, ICPeriphID3} ;
          `HADDR_ICPCELLID0    : HRDATA = {24'h000000, ICPCellID0} ;
          `HADDR_ICPCELLID1    : HRDATA = {24'h000000, ICPCellID1} ;
          `HADDR_ICPCELLID2    : HRDATA = {24'h000000, ICPCellID2} ;
          `HADDR_ICPCELLID3    : HRDATA = {24'h000000, ICPCellID3} ;
          default              : HRDATA = `ZEROFILL;
        endcase
      end
    else
      HRDATA = `ZEROFILL;
  end

// ---------------------------------------------------------------------
// Assign local copies of signals to the outputs.
// ---------------------------------------------------------------------
  assign ICDefVectAddr = iICDefVectAddr;
  assign ICIRQStatusCo = NxtICIRQStatus;
  assign ICFIQStatusCo = NxtICFIQStatus;
  assign ICRawIntrCo   = NxtICRawIntr;
  assign PriorRdEn     = iPriorRdEn;

endmodule
