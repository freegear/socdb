//  --========================================================================--
//  This confidential and proprietary software may be used only as
//  authorised by a licensing agreement from ARM Limited
//    (C) COPYRIGHT 1998-2001 ARM Limited
//        ALL RIGHTS RESERVED
//  The entire notice above must be reproduced on all authorised
//  copies and copies may only be made to the extent permitted
//  by a licensing agreement from ARM Limited.
//  
//  ----------------------------------------------------------------------------
//  Version and Release Control Information:
//  
//  File Name          : SmiCore.v,v
//  File Revision      : 1.3
//  
//  Release Information : ADK_REL1v1
//  
//  ----------------------------------------------------------------------------
//  Purpose            : Synthesizable demonstration of an AMBA static memory
//                        interface with configurable wait states (2-3 write
//                        wait and 1-3 read waits).
//                        Assumes external memory constructed from 8-bit devices
//                        that use the byte lane select instead of the dedicated
//                        write enable.
//  --========================================================================--

`timescale 1ns/1ps

module SmiCore (HCLK, HRESETn, HADDR, HTRANS, HWRITE, HSIZE, HWDATA, HSELSMC,
                HREADYIN, HRDATA, HREADYOUT, HRESP, REMAP, SMDATAIN, SMDATAOUT,
                nSMDATAEN, SMADDR, SMCS, nSMBLS, nSMOEN);

// Port definitions
  input        HCLK; 
  input        HRESETn;
  input [28:0] HADDR;
  input [1:0]  HTRANS;
  input        HWRITE;
  input [2:0]  HSIZE;
  input [31:0] HWDATA;
  input        HSELSMC;
  input        HREADYIN;
  input        REMAP;
  input [31:0] SMDATAIN;
  
  output [31:0] HRDATA;
  output        HREADYOUT;
  output [1:0]  HRESP;
  output [31:0] SMDATAOUT;
  output [3:0]  nSMDATAEN;
  output [25:0] SMADDR;
  output [7:0]  SMCS;
  output [3:0]  nSMBLS;
  output        nSMOEN;

//------------------------------------------------------------------------------
// Constant declarations
//------------------------------------------------------------------------------
// Used to set the number of wait states that are inserted for reads and writes
// Writes must have at least 2 wait states to avoid the use of a falling edge
//  register to generate the nSMBLS outputs.
  `define READWAIT 2'b01      // Range 1-3
  `define WRITEWAIT 2'b10     // Range 2-3
  `define ZERO 2'b00

// HTRANS transfer type signal encoding
  `define TRN_IDLE 2'b00
  `define TRN_BUSY 2'b01
  `define TRN_NONSEQ 2'b10
  `define TRN_SEQ 2'b11

// HSIZE transfer type signal encoding
  `define SZ_BYTE 3'b000
  `define SZ_HALF 3'b001
  `define SZ_WORD 3'b010

// HRESP transfer response signal encoding
  `define RSP_OKAY 2'b00
  `define RSP_ERROR 2'b01
  `define RSP_RETRY 2'b10
  `define RSP_SPLIT 2'b11

// nSMBLS output signal encoding
  `define NONE 4'b1111
  `define WORD 4'b0000
  `define HALF1 4'b0011
  `define HALF0 4'b1100
  `define BYTE3 4'b0111
  `define BYTE2 4'b1011
  `define BYTE1 4'b1101
  `define BYTE0 4'b1110
  
//------------------------------------------------------------------------------
// Signal declarations
//------------------------------------------------------------------------------

// Input/Output Signals
  wire        HCLK;
  wire        HRESETn;
  wire [28:0] HADDR;
  wire [1:0]  HTRANS;
  wire        HWRITE;
  wire [2:0]  HSIZE;
  wire [31:0] HWDATA;
  wire        HSELSMC;
  wire        HREADYIN;
  wire [31:0] HRDATA;
  wire        HREADYOUT;
  wire [1:0]  HRESP;
  wire        REMAP;       //  Reset memory map in use 
  wire [31:0] SMDATAIN;    //  Data from Memory to Smi 
  wire [31:0] SMDATAOUT;   //  Data from Smi to Memory 
  wire [3:0]  nSMDATAEN;   //  Data tri-state pad enable 
  wire [25:0] SMADDR;      //  External address bus 
  reg [7:0]   SMCS;        //  External chip selects 
  reg [3:0]   nSMBLS;      //  External byte lane enables 
  wire        nSMOEN;      //  External read enable

// Internal Signals
  reg         HselReg;     //  HSELSMC register 
  wire        Valid;       //  Module currently selected and valid 
  wire        ValidReg;    //  Module was selected with valid transfer 
  wire        ACRegEn;     //  Enable for holding registers 
  reg [28:0]  HaddrReg;
  reg [1:0]   HtransReg;
  reg         HwriteReg;
  reg [2:0]   HsizeReg;
  wire [1:0]  NextWait;    //  Wait counter 
  reg [1:0]   CurrentWait;
  wire        HreadyNext;  //  HREADYOUT register input 
  reg         iHREADYOUT;  //  HREADYOUT register 
  wire        nSMBLSEn;    //  Enable for nSMBLSNext 
  wire [3:0]  nSMBLSNext;  //  nSMBLS register input 
  wire        inSMOEN;     //  Output enable 
  reg [7:0]   SMCSNext;    //  SMCS register input 

//------------------------------------------------------------------------------
// Beginning of main code
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// Valid transfer detection
//------------------------------------------------------------------------------
// The slave must only respond to a valid transfer, so this must be detected.
  always @ (negedge HRESETn or posedge HCLK)
  begin : p_HselRegSeq
    if (!HRESETn)
      HselReg <= 1'b0;
    else
      if (HREADYIN)
        HselReg <= HSELSMC;
  end
  
// Valid AHB transfers only take place when a non-sequential or sequential
//  transfer is shown on HTRANS - an idle or busy transfer should be ignored.
  assign Valid = ((((HSELSMC) & (HREADYIN)) & 
                   ((HTRANS == `TRN_NONSEQ) |
                    (HTRANS == `TRN_SEQ))) ? 1'b1 : (1'b0));
  
  assign ValidReg = (((HselReg) & ((HtransReg == `TRN_NONSEQ) | 
                                   (HtransReg == `TRN_SEQ))) ? 1'b1 : (1'b0));
  
//------------------------------------------------------------------------------
// Address and control registers
//------------------------------------------------------------------------------
// Registers are used to store the address and control signals from the address
//  phase for use in the data phase of the transfer.
// Only enabled when the HREADYIN input is HIGH and the module is addressed.
  assign ACRegEn = (HSELSMC & HREADYIN);
  
  always @ (negedge HRESETn or posedge HCLK)
  begin : p_ACRegSeq
    if (!HRESETn)
      begin
        HaddrReg <= {29{1'b0}};
        HtransReg <= {2{1'b0}};
        HwriteReg <= 1'b0;
        HsizeReg <= {3{1'b0}};
      end
    else
      if (ACRegEn)
        begin 
          HaddrReg <= HADDR;
          HtransReg <= HTRANS;
          HwriteReg <= HWRITE;
          HsizeReg <= HSIZE;
        end 
  end // block: p_ACRegSeq
  
//------------------------------------------------------------------------------
// Wait state counter
//------------------------------------------------------------------------------
// Generates count signal depending on the values set in the constants
//  READWAIT and WRITEWAIT, which are decremented to zero.
// Wait states are inserted when CurrentWait is not equal to ZERO.
  
  assign NextWait = ((((iHREADYOUT) & 
                       (Valid)) & 
                       (HWRITE == 1'b0)) ? `READWAIT :
                         ((((iHREADYOUT) & 
                            (Valid)) & 
                            (HWRITE)) ? `WRITEWAIT :
                              ((CurrentWait == `ZERO) ? `ZERO : 
                                ((CurrentWait  - 1'b1)))));
  
  always @ (negedge HRESETn or posedge HCLK)
  begin : p_WaitCounterSeq
    if (!HRESETn)
      CurrentWait <= `ZERO;
    else
      CurrentWait <= NextWait;
  end
  
//------------------------------------------------------------------------------
// Output data bus generation
//------------------------------------------------------------------------------
// HRDATA driven to SMDATAIN during a read transfer, and to zero at all other
//  times.
  assign HRDATA = ((inSMOEN == 1'b0) ? SMDATAIN : {32{1'b0}});
  
//------------------------------------------------------------------------------
// iHREADYOUT generation
//------------------------------------------------------------------------------
// HREADYOUT is generated from the value of NextWait, and is stored in a
//  register to improve the output timing.
  assign HreadyNext = ((NextWait == `ZERO) ? 1'b1 : (1'b0));
  
  always @ (negedge HRESETn or posedge HCLK)
  begin : p_iHREADYOUTSeq
    if (!HRESETn)
      iHREADYOUT <= 1'b1;
    else
      iHREADYOUT <= HreadyNext;
  end
  
//------------------------------------------------------------------------------
// SMDATAOUT generation
//------------------------------------------------------------------------------
// Directly driven by HWDATA during a normal write transfer.
  assign SMDATAOUT = ((HwriteReg) ? HWDATA : {32{1'b0}});

//------------------------------------------------------------------------------
// nSMDATAEN generation
//------------------------------------------------------------------------------
// The full data bus is enabled during a write transfer, and disabled during a
//  read.
  assign nSMDATAEN = (((inSMOEN) & (HwriteReg)) ? 4'b0000 : (4'b1111));

//------------------------------------------------------------------------------
// SMCSNext generation
//------------------------------------------------------------------------------
// Decodes the chip enable signals from the current transfer address. Before
//  the system memory is remapped, the boot ROM (at address 0x30000000) is also
//  mapped at address 0x00000000. RAM is accessed as normal.
// Extra banks of memory can be added by increasing the size of the XCSN output
//  and altering the address decoding to select the new memory.
  always @ (Valid or REMAP or HADDR)
  begin : p_SMCSComb
    if ((Valid && (REMAP == 1'b0)))
      case (HADDR[28:26])
        3'b000:  SMCSNext = 8'b01111111;  // 0x1C000000
        3'b001:  SMCSNext = 8'b11111101;  // 0x04000000
        3'b010:  SMCSNext = 8'b11111011;  // 0x08000000
        3'b011:  SMCSNext = 8'b11110111;  // 0x0C000000
        3'b100:  SMCSNext = 8'b11101111;  // 0x10000000
        3'b101:  SMCSNext = 8'b11011111;  // 0x14000000
        3'b110:  SMCSNext = 8'b10111111;  // 0x18000000
        3'b111:  SMCSNext = 8'b01111111;  // 0x1C000000
        default: SMCSNext = 8'b11111111;
      endcase
    else if (Valid)
      case (HADDR[28:26])
        3'b000:  SMCSNext = 8'b11111110;  // 0x??000000
        3'b001:  SMCSNext = 8'b11111101;  // 0x??100000
        3'b010:  SMCSNext = 8'b11111011;  // 0x??200000
        3'b011:  SMCSNext = 8'b11110111;  // 0x??300000
        3'b100:  SMCSNext = 8'b11101111;  // 0x??400000
        3'b101:  SMCSNext = 8'b11011111;  // 0x??500000
        3'b110:  SMCSNext = 8'b10111111;  // 0x??600000
        3'b111:  SMCSNext = 8'b01111111;  // 0x??700000
        default: SMCSNext = 8'b11111111;
      endcase
    else
      SMCSNext = 8'b11111111;
  end // block: p_SMCSComb
  
//------------------------------------------------------------------------------
// inSMOEN generation
//------------------------------------------------------------------------------
// Output enable generated during reads from memory.
  assign inSMOEN = ((((ValidReg == 1'b1) & 
                      (HwriteReg == 1'b0)) & 
                      (CurrentWait == `ZERO)) ? 1'b0 : (1'b1));
  
//------------------------------------------------------------------------------
// nSMBLS generation
//------------------------------------------------------------------------------
// Memory write enables generated from registered HSIZE and address. Enabled
//  while the external memory is addressed and when no more wait states are to
//  be inserted. Deasserted when transfer sizes greater than 32-bit (word) are
//  performed.
  assign nSMBLSEn = ((((ValidReg) & 
                       (HwriteReg)) & 
                      (NextWait == 2'b01)) ? 1'b1 : (1'b0));

        
  assign nSMBLSNext = 
    (((nSMBLSEn) & 
      (HsizeReg == `SZ_WORD)) ? `WORD :
        ((((nSMBLSEn) & 
           (HsizeReg == `SZ_HALF)) &
          (HaddrReg[1])) ? `HALF1 : 
             ((((nSMBLSEn) & 
                (HsizeReg == `SZ_HALF)) & 
               (HaddrReg[1]== 1'b0)) ? `HALF0 : 
                 ((((nSMBLSEn) & 
                    (HsizeReg == `SZ_BYTE)) &
                   (HaddrReg[1:0]== 2'b11)) ? `BYTE3 : 
                     ((((nSMBLSEn) & 
                        (HsizeReg == `SZ_BYTE)) & 
                       (HaddrReg[1:0]== 2'b10)) ? `BYTE2 : 
                          ((((nSMBLSEn) & 
                             (HsizeReg == `SZ_BYTE)) & 
                            (HaddrReg[1:0]== 2'b01)) ? `BYTE1 : 
                              ((((nSMBLSEn) & 
                                 (HsizeReg == `SZ_BYTE)) & 
                                (HaddrReg[1:0]== 2'b00)) ? `BYTE0 : 
                                  (`NONE))))))));
  
//------------------------------------------------------------------------------
// External bus output port drivers
//------------------------------------------------------------------------------
// SMADDR is always driven with the previous value of HADDR stored in HaddrReg.
  assign SMADDR = HaddrReg[25:0];
  
// Output port driven with internal value.
  assign nSMOEN = inSMOEN;
  
// Registered output chip select lines
  always @ (negedge HRESETn or posedge HCLK)
  begin : p_SMCSSeq
    if (!HRESETn)
      SMCS <= {8{1'b1}};
    else
      if (HREADYIN)
        SMCS <= SMCSNext;
  end
    
// Registered nSMBLS to avoid glitches on the outputs
  always @ (negedge HRESETn or posedge HCLK)
  begin : p_nSMBLSSeq
    if (!HRESETn)
      nSMBLS <= `NONE;
    else
      nSMBLS <= nSMBLSNext;
  end
  
//------------------------------------------------------------------------------
// Slave response output drivers
//------------------------------------------------------------------------------
// Drive the output ports with the internal versions.
  assign HREADYOUT = iHREADYOUT;
  
  assign HRESP = `RSP_OKAY;
  
endmodule
