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
//  File Name           : IntMem.v,v
//  File Revision       : 1.7
//  
//  Release Information : ADK_REL1v1
//
//  ----------------------------------------------------------------------------
//  Purpose             : Internal memory, 32 bits wide, little endian,
//                        configurable size (default 1Kbyte), no wait state.
//                        This is a behavioral Verilog model, and not
//                        representative of a real on-chip SRAM.
//                        Reads in a Verilog $readmemh format intram.dat file.
//  --========================================================================--

`timescale 1ns / 1ps

module IntMem(HCLK, HRESETn, HADDR, HTRANS, HWRITE, HSIZE, HWDATA, HSELIntMem,
              HREADY, HRDATA, HREADYOUT, HRESP);

  input         HCLK;
  input         HRESETn;
  input  [31:0] HADDR;
  input   [1:0] HTRANS;
  input         HWRITE;
  input   [2:0] HSIZE;
  input  [31:0] HWDATA;
  input         HSELIntMem;
  input         HREADY;

  output [31:0] HRDATA;
  output        HREADYOUT;
  output  [1:0] HRESP;


//------------------------------------------------------------------------------
// Default memory size and input filename settings
//------------------------------------------------------------------------------
  parameter MemBits  = 10;           // Memory size in address bits, 1kB default
  parameter FileName = "intram.dat"; // Input filename

//------------------------------------------------------------------------------
//  Constant declarations
//------------------------------------------------------------------------------
// HTRANS transfer type signal encoding
  `define TRN_IDLE   2'b00
  `define TRN_BUSY   2'b01
  `define TRN_NONSEQ 2'b10
  `define TRN_SEQ    2'b11

// HSIZE transfer type signal encoding
  `define SZ_BYTE 3'b000
  `define SZ_HALF 3'b001
  `define SZ_WORD 3'b010

// HRESP transfer response signal encoding
  `define RSP_OKAY   2'b00
  `define RSP_ERROR  2'b01
  `define RSP_RETRY  2'b10
  `define RSP_SPLIT  2'b11

// Number of memory locations
  `define MEM_ARRAY_MAX ((1 << MemBits - 2) -1)
  
//------------------------------------------------------------------------------
// Signal declarations
//------------------------------------------------------------------------------

// Input/Output Signals
  wire        HCLK;
  wire        HRESETn;
  wire [31:0] HADDR;
  wire  [1:0] HTRANS;
  wire        HWRITE;
  wire  [2:0] HSIZE;
  wire [31:0] HWDATA;
  wire        HSELIntMem;
  wire        HREADY;
  wire        HREADYOUT;
  wire  [1:0] HRESP;

  reg  [31:0] HRDATA;

// Internal Signals
  reg  [31:0] Mem [0:`MEM_ARRAY_MAX]; // Memory register array

  reg         HselReg;               // HSELIntMem register
  wire        ValidReg;              // in data phase of a valid IntMem transfer

  wire        ACRegEn;               // Enable for address and control registers
  reg  [31:0] HaddrReg;
  reg   [1:0] HtransReg;
  reg         HwriteReg;
  reg   [2:0] HsizeReg;
  

  reg  [31:0] Data;                  // Output data

  integer     MemAddr;               // Memory address being accessed
   
  integer     i;                     // Loop counter for memory initialisation

//------------------------------------------------------------------------------
// Initialise Memory (only once)
//------------------------------------------------------------------------------

  initial
  begin
    for (i = 0; i <= `MEM_ARRAY_MAX; i = i + 1)
      Mem[i] = 32'h0000_0000;
    if (FileName != "")
    begin
      $display("### Loading internal memory ###");
      $readmemh(FileName, Mem);
    end
  end


//------------------------------------------------------------------------------
// Beginning of main code
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// Valid transfer detection
//------------------------------------------------------------------------------
// The slave must only respond to a valid transfer, so this must be detected.
 
  always @(negedge (HRESETn) or posedge (HCLK))
  begin
    if (!HRESETn)
      HselReg <= 1'b0;
    else
    begin
      if (HREADY)
        HselReg <= HSELIntMem;
    end
  end
 
// Valid AHB transfers only take place when a non-sequential or sequential
// transfer is shown on HTRANS - an idle or busy transfer should be ignored.

  assign ValidReg = (HselReg == 1'b1 && (HtransReg == `TRN_NONSEQ ||
                                         HtransReg == `TRN_SEQ)) ? 1'b1 :
                    1'b0;

//------------------------------------------------------------------------------
// Address and control registers
//------------------------------------------------------------------------------
// Registers are used to store the address and control signals from the address
//  phase for use in the data phase of the transfer.
// Only enabled when the HREADY input is HIGH and the module is addressed.

  assign ACRegEn = HSELIntMem & HREADY;

  always @(negedge (HRESETn) or posedge (HCLK))
  begin
    if (!HRESETn)
    begin
      HaddrReg  <= 32'h0000_0000;
      HtransReg <= 2'b00;
      HwriteReg <= 1'b0;
      HsizeReg  <= 3'b000;
    end
    else
    begin
      if (ACRegEn)
      begin
        HaddrReg  <= HADDR;
        HtransReg <= HTRANS;
        HwriteReg <= HWRITE;
        HsizeReg  <= HSIZE;
      end
    end
  end

//------------------------------------------------------------------------------
//  Memory read and write
//------------------------------------------------------------------------------
// The read data is generated by converting the current byte address into a word
//  address, and then reading the data value from Mem at that address.
// A write is performed by first reading the entire word from memory. Then the
//  appropriate bytes of the word are changed before writing back the entire 
//  word.
// Since both a memory read and write operation require the data at the current
//  address to be read from the memory, then this common section of code can be
//  used by both operations.

// NOTE - this module is little endian and must be modified for a big endian
//        system.

  always @(ValidReg or HaddrReg or HCLK)
  begin
    if (ValidReg)                        // Common to read and write operations
    begin
      MemAddr = HaddrReg[MemBits-1 : 2]; // Memory address for this transfer
      Data = Mem[MemAddr];               // Data from addressed location

      @(posedge HCLK)   // Write-only section performed on the rising clock edge
      if (HwriteReg && ValidReg)
      begin
        case (HsizeReg)

          `SZ_BYTE :                // Byte access
            case (HaddrReg[1:0])
              2'b00   : Data[7:0]   = HWDATA[7:0];
              2'b01   : Data[15:8]  = HWDATA[15:8];
              2'b10   : Data[23:16] = HWDATA[23:16];
              default : Data[31:24] = HWDATA[31:24];
            endcase

          `SZ_HALF :                // Halfword access
            case (HaddrReg[1])
              1'b0    : Data[15:0]  = HWDATA[15:0];
              default : Data[31:16] = HWDATA[31:16];
            endcase
          `SZ_WORD :
            Data = HWDATA;
          
          default :                // Word access
            Data = HWDATA;

        endcase
        Mem[MemAddr] = Data;
      end
    end
  end

//------------------------------------------------------------------------------
// Output Drivers
//------------------------------------------------------------------------------
// Drive output data bus during read operation

  always @(ValidReg or HwriteReg or Data)
  begin
    if (ValidReg && !HwriteReg) // Valid read transfer
      HRDATA = Data;
    else
      HRDATA = 32'h0000_0000;
  end

// No wait states are inserted by this memory model, so HREADYOUT can be driven
//  HIGH all of the time.

  assign HREADYOUT = 1'b1;

// The response will always be OKAY to show that the transfer has been performed
//  successfully.

  assign HRESP = `RSP_OKAY;


endmodule

// --================================= End ===================================--

