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
//  File Name           : EgAPBSlave.v,v
//  File Revision       : 1.7
//  
//  Release Information : ADK_REL1v1
//  
//  ----------------------------------------------------------------------------
//  Purpose             : Example slave for the APB
//  --========================================================================--

`timescale 1ns/1ps

module EgAPBSlave (PCLK, PRESETn, PENABLE, PSEL, PWRITE, PADDR, PWDATA,
                   SCANENABLE, SCANINPCLK, SCANOUTPCLK, PRDATA);
    
  input         PCLK;                             // APB system clock
  input         PRESETn;                          // APB system reset
  input         PENABLE;                          // Data valid strobe 
  input         PSEL;                             // Module select signal
  input         PWRITE;                           // Write/nRead signal
  input  [11:2] PADDR;                            // Address (used bits only)
  input  [31:0] PWDATA;                           // Read data
  output [31:0] PRDATA;                           // Write data

  // Scan test dummy signals; not connected until scan insertion 
  input         SCANENABLE;                       // Scan Test Mode Enbl
  input         SCANINPCLK;                       // Scan Chain Input
  output        SCANOUTPCLK;                      // Scan Chain Output  

//------------------------------------------------------------------------------
//
//                       Example APB Slave
//                       =================
//
//------------------------------------------------------------------------------
//
// Overview
// ========
//
// The Example APB Slave (EgAPBSlave) provides the developer with
//  sample HDL code, which can be used as a basis for further
//  enhancement, to produce a slave on the Advanced Peripheral Bus.
//  The functionality of the slave is very simple - it contains:
//
//  * Four general-purpose registers (32-bit read-write).
//  * Seven read-only address locations, returning values of bitwise
//    logical operations on the registered data.
//  * PrimeCell and Peripheral ID registers.
//
//------------------------------------------------------------------------------

  
//------------------------------------------------------------------------------
// Constant declarations
//------------------------------------------------------------------------------

// Module Address Map:
// Read/write 32-bit registers:
//
// Address  Read      Write
// 0x00     0 = R0    R0
// 0x04     1 = R1    R1
// 0x08     2 = R2    R2
// 0x0C     3 = R3    R3

// Read only 32-bit logical combinations of read/write registers:
//
// Address  Read
// 0x10     A = not R0
// 0x14     B = R0 and R1
// 0x18     C = R1 or  R2
// 0x1C     D = R2 xor R3
// 0x20     E = R0 and R1 and R2 and R3
// 0x24     F = R0 or  R1 or  R2 or  R3
// 0x28     G = R0 xor R1 xor R2 xor R3

// PrimeCell and Peripheral ID register locations:
//
// 0xfe0    Peripheral ID register (Bits 7:0)
// 0xfe4    Peripheral ID register (Bits 15:8)
// 0xfe8    Peripheral ID register (Bits 23:16)
// 0xfec    Peripheral ID register (Bits 31:24)
// 0xff0    PrimeCell ID register (Bits 7:0)
// 0xff4    PrimeCell ID register (Bits 15:8)
// 0xff8    PrimeCell ID register (Bits 23:16)
// 0xffc    PrimeCell ID register (Bits 31:24)

// ExampleAPBSlave local registers
`define EGAPBSLVREG 6'b000000

`define ADDRREG0 4'b0000
`define ADDRREG1 4'b0001
`define ADDRREG2 4'b0010
`define ADDRREG3 4'b0011
`define ADDRREGA 4'b0100
`define ADDRREGB 4'b0101
`define ADDRREGC 4'b0110
`define ADDRREGD 4'b0111
`define ADDRREGE 4'b1000
`define ADDRREGF 4'b1001
`define ADDRREGG 4'b1010

// Peripheral and PrimeCell register base address
`define EASPA       6'b111111

// Peripheral and PrimeCell ID registers
`define PeriphID0A  4'b1000
`define PeriphID1A  4'b1001
`define PeriphID2A  4'b1010
`define PeriphID3A  4'b1011
`define PCellID0A   4'b1100
`define PCellID1A   4'b1101 
`define PCellID2A   4'b1110
`define PCellID3A   4'b1111

// Peripheral constant values

// EgAPBSlave part number = SP806
`define PARTNUMBER   12'b100000000110
// EgAPBSlave designer = 0x41 (ARM)
`define DESIGNER     8'b01000001
// EgAPBSlave configuration = 0
`define CONFIG       8'b00000000

// EgAPBSlave PrimeCell ID register value
`define iPRIMECELLID 32'hB105F00D

  
//------------------------------------------------------------------------------
// Signal declarations
//------------------------------------------------------------------------------

// Input/Output Signals
  wire        PCLK;
  wire        PRESETn;
  wire        PENABLE;
  wire        PSEL;
  wire        PWRITE;
  wire [11:2] PADDR;
  wire [31:0] PWDATA;
  wire        SCANENABLE;
  wire        SCANINPCLK;
  wire [31:0] PRDATA;
  wire        SCANOUTPCLK;

// Internal Signals
  wire        Valid;         // Detect valid transfers

  wire        R0En;          // Register update enables
  wire        R1En;
  wire        R2En;
  wire        R3En;

  reg  [31:0] R0;            // Read/Write registers
  reg  [31:0] R1;
  reg  [31:0] R2;
  reg  [31:0] R3;

  wire [31:0] Read10;        // Read location generated values
  wire [31:0] Read14;
  wire [31:0] Read18;
  wire [31:0] Read1C;
  wire [31:0] Read20;
  wire [31:0] Read24;
  wire [31:0] Read28;

  reg  [31:0] nextPRDATA;    // Mux, Register and Enable for PRDATA
  reg  [31:0] ReadIDs;
  reg  [31:0] ReadRegs;
  reg  [31:0] iPRDATA;
  wire        ReadRegEn;  

  wire [31:0] PeripheralID;  // Peripheral ID register
  wire [3:0]  Revision;
  
  wire [31:0] PrimeCellID;   // PrimeCell ID register

  wire [3:0]  TieOff1;       //  RevAnd input 1 
  wire [3:0]  TieOff2;       //  RevAnd input 2 


//------------------------------------------------------------------------------
// Beginning of main code
//------------------------------------------------------------------------------

// Only respond to valid APB transfers
  assign Valid = (PSEL & (!PENABLE));
  
//------------------------------------------------------------------------------
// Internal register address decoding
//------------------------------------------------------------------------------
// The enables are set when the register is addressed and HWRITE is set.
//  By default, the register enables are all deselected.
  
  assign R0En = ((PADDR[5:2] == `ADDRREG0) && Valid && PWRITE) ? 1'b1
                : 1'b0;  // Offset 0x00

  assign R1En = ((PADDR[5:2] == `ADDRREG1) && Valid && PWRITE) ? 1'b1
                : 1'b0;  // Offset 0x04

  assign R2En = ((PADDR[5:2] == `ADDRREG2) && Valid && PWRITE) ? 1'b1
                : 1'b0;  // Offset 0x08

  assign R3En = ((PADDR[5:2] == `ADDRREG3) && Valid && PWRITE) ? 1'b1
                : 1'b0;  // Offset 0x0C
    
//------------------------------------------------------------------------------
// Read/write registers
//------------------------------------------------------------------------------
// When written to, these registers will hold their values.

// Register 0
   always @ (posedge PCLK or negedge PRESETn)
     begin : p_Reg0Seq
       if ((!PRESETn))
         R0 <= {32{1'b0}};
       else
         if (R0En)
           R0 <= PWDATA;
     end 

// Register 1
  always @ (posedge PCLK or negedge PRESETn)
    begin : p_Reg1Seq
      if ((!PRESETn))
        R1 <= {32{1'b0}};
      else
        if (R1En)
          R1 <= PWDATA;
    end

// Register 2
  always @ (posedge PCLK or negedge PRESETn)
    begin : p_Reg2Seq
      if  ((!PRESETn))
        R2 <= {32{1'b0}};
      else
        if (R2En)
          R2 <= PWDATA;
    end 

// Register 3
  always @ (posedge PCLK or negedge PRESETn)
    begin : p_Reg3Seq
      if ((!PRESETn))
        R3 <= {32{1'b0}};
      else
        if (R3En)
          R3 <= PWDATA;
    end 

  
//------------------------------------------------------------------------------
// Read-only register values
//------------------------------------------------------------------------------
// These values are generated from the four read/write registers

  assign  Read10 = (~R0);
  assign  Read14 = (R0 & R1);
  assign  Read18 = (R1 | R2);
  assign  Read1C = (R2 ^ R3);
  assign  Read20 = (((R0 & R1) & R2) & R3);
  assign  Read24 = (((R0 | R1) | R2) | R3);
  assign  Read28 = (((R0 ^ R1) ^ R2) ^ R3);

  
//------------------------------------------------------------------------------
// PRDATA generation
//------------------------------------------------------------------------------
// Generates the read data from the internal register values.
//  Uses combinational logic to select the read data from the current data
//  held in the registers and passes this to the output register.
// Selection of read data from Peripheral and PrimeCell ID registers is 
//  separated from the nextPRDATA mux to reduce the depth of mux needed for
//  the registered data.

  always @ (PADDR or ReadRegs or ReadIDs)
    begin : p_ReadMuxComb
      // Determine the next value of nextPRDATA
      case (PADDR[11:6])
        `EGAPBSLVREG : nextPRDATA = ReadRegs;
        `EASPA       : nextPRDATA = ReadIDs;
        default      : nextPRDATA = {32{1'b0}};  // Read as zero default
      endcase
    end

  always @ (PADDR or R0 or R1 or R2 or R3 or
            Read10 or Read14 or Read18 or Read1C or
            Read20 or Read24 or Read28)
    begin : p_RdRegMuxComb
      // Determine the next value of ReadRegs
      case (PADDR[5:2])
        `ADDRREG0 : ReadRegs = R0;
        `ADDRREG1 : ReadRegs = R1;
        `ADDRREG2 : ReadRegs = R2;
        `ADDRREG3 : ReadRegs = R3;
        `ADDRREGA : ReadRegs = Read10;
        `ADDRREGB : ReadRegs = Read14;
        `ADDRREGC : ReadRegs = Read18;
        `ADDRREGD : ReadRegs = Read1C;
        `ADDRREGE : ReadRegs = Read20;
        `ADDRREGF : ReadRegs = Read24;
        `ADDRREGG : ReadRegs = Read28;
        default   : ReadRegs = {32{1'b0}};  // Read as zero default
      endcase
    end 

  always @ (PADDR or PeripheralID or PrimeCellID)
    begin : p_ReadIDsMuxComb
      // Determine the next value of ReadIDs
      case (PADDR[5:2])
        `PeriphID0A : ReadIDs = {{24{1'b0}}, PeripheralID[7:0]};
        `PeriphID1A : ReadIDs = {{24{1'b0}}, PeripheralID[15:8]};
        `PeriphID2A : ReadIDs = {{24{1'b0}}, PeripheralID[23:16]};
        `PeriphID3A : ReadIDs = {{24{1'b0}}, PeripheralID[31:24]};
        `PCellID0A  : ReadIDs = {{24{1'b0}}, PrimeCellID[7:0]};
        `PCellID1A  : ReadIDs = {{24{1'b0}}, PrimeCellID[15:8]};
        `PCellID2A  : ReadIDs = {{24{1'b0}}, PrimeCellID[23:16]};
        `PCellID3A  : ReadIDs = {{24{1'b0}}, PrimeCellID[31:24]};
        default     : ReadIDs = {32{1'b0}};
      endcase
    end
     

// The data presented on PRDATA is registered to reduce output delay.
//  Register contents are retained when the slave is not selected and also
//  when not being read.
  assign ReadRegEn = (Valid & (~PWRITE));

// APB Read Data Register
  always @ (posedge PCLK or negedge PRESETn)
    begin : p_PrdataSeq
      if ((!PRESETn))
        iPRDATA <= {32{1'b0}};
      else
        if (ReadRegEn)
          iPRDATA <= nextPRDATA; 
    end
 
// Drive output from internal register
  assign PRDATA = iPRDATA;


//-----------------------------------------------------------------------------
// Assign the EgAPBSlave Peripheral ID
//
// The EgAPBSlave Peripheral ID is a 32-bit value composed of the
// following 4 fields:
// Bits [11:0] -> Part Number used to identify the peripheral
//                For the EgAPBSlave this is 0x806
// Bits[19:12] -> Designer ID (ARM)
//                ARM is designated 0x41
// Bits[23:20] -> Peripheral Revision Number
//                For the EgAPBSlave this is 0x00
// Bits[31:24] -> Peripheral Configuration Options
//                For the EgAPBSlave this is 0x00
//
// The 32-bits are readable via 4 separate address locations with
// each location returning 8 valid bits at positions [7:0]. The
// values returned by the 4 Peripheral ID registers are given below:
//---------------------------------------------------------------------------
  assign PeripheralID = {`CONFIG, Revision, `DESIGNER, `PARTNUMBER};
  
  assign PrimeCellID = `iPRIMECELLID;

  //------------------------------------------------------------------
  // Assign values to inputs of RevAnd
  //------------------------------------------------------------------
  assign TieOff1 = 4'b0000;
  assign TieOff2 = 4'b0000;

  //------------------------------------------------------------------
  // Instantiation of RevAnd for bit 0 of Revision
  //------------------------------------------------------------------
  RevAnd  u0RevAnd 
    (.TieOff1  (TieOff1[0]),
     .TieOff2  (TieOff2[0]),
     .Revision (Revision[0])
    );

  //------------------------------------------------------------------
  // Instantiation of RevAnd for bit 1 of Revision
  //------------------------------------------------------------------
  RevAnd  u1RevAnd 
    (.TieOff1(TieOff1[1]),
     .TieOff2(TieOff2[1]),
     .Revision(Revision[1])
    );

  //------------------------------------------------------------------
  // Instantiation of RevAnd for bit 2 of Revision
  //------------------------------------------------------------------
  RevAnd  u2RevAnd 
    (.TieOff1(TieOff1[2]),
     .TieOff2(TieOff2[2]),
     .Revision(Revision[2])
    );

  //------------------------------------------------------------------
  // Instantiation of RevAnd for bit 3 of Revision
  //------------------------------------------------------------------
  RevAnd  u3RevAnd 
    (.TieOff1(TieOff1[3]),
     .TieOff2(TieOff2[3]),
     .Revision(Revision[3])
    );
  
endmodule

// --================================= End ===================================--

