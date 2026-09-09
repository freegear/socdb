//============================================================================--
//  This confidential and proprietary software may be used only as
//  authorised by a licensing agreement from ARM Limited
//    (C) COPYRIGHT 2001 ARM Limited
//        ALL RIGHTS RESERVED
//  The entire notice above must be reproduced on all authorised
//  copies and copies may only be made to the extent permitted
//  by a licensing agreement from ARM Limited.
//
//
//------------------------------------------------------------------------------
//  Version and Release Control Information:
//
//  File Name           : EgMasterCore.v,v
//  File Revision       : 1.10
//
//  Release Information : ADK_REL1v1
//
//------------------------------------------------------------------------------
//  Purpose           : This is an example AHB-Lite bus master core.
//                      When not in reset, the core repeats the process of a
//                      4 burst word read followed by 16 byte writes.
//                      These are separated by a fixed number of IDLE transfers.
//============================================================================--

//------------------------------------------------------------------------------
// The example AHB-Lite core is made up of the following parts:
//      Control and burst generation state machine
//      Counter
//      16 x 8 bit register block
//------------------------------------------------------------------------------

`timescale 1ns/1ps

module EgMasterCore
  (
   HCLK,
   HRESETn,

   MREADY,
   MERROR,
   MRDATA,

   MTRANS,
   MBURST,
   MPROT,
   MSIZE,
   MWRITE,
   MMASTLOCK,
   MADDR,
   MWDATA
   );

  // Global signals
  input         HCLK;      // System clock
  input         HRESETn;   // System reset

  // Signals from AHB-Lite
  input         MREADY;    // Slave ready signal
  input         MERROR;    // Slave error signal
  input [31:0]  MRDATA;    // Data from slave to master

  // Signals to AHB-Lite
  output [1:0]  MTRANS;    // Transfer type
  output [2:0]  MBURST;    // Burst type
  output [3:0]  MPROT;     // Transfer protection bits
  output [2:0]  MSIZE;     // Transfer size
  output        MWRITE;    // Transfer direction
  output        MMASTLOCK; // Transfer is a locked transfer
  output [31:0] MADDR;     // Transfer address
  output [31:0] MWDATA;    // Data from master to slave

//------------------------------------------------------------------------------
// Default settings for the Example master operation
//------------------------------------------------------------------------------
  // Block enable
  parameter EBMenable    = 1;
  
  // Read base address
  parameter EBMreadAddr  = 8'hD0;
  
  // Write base address
  parameter EBMwriteAddr = 8'hC4;
  
  // Delay between transactions
  parameter EBMinitCount = 10'h004;
  
//----------------------------------------------------------------------------
// Constant declarations
//----------------------------------------------------------------------------

  // Control FSM States
  `define ST_COUNT1      3'b000
  `define ST_READ_START  3'b001
  `define ST_READ_MID    3'b010
  `define ST_COUNT2      3'b100
  `define ST_WRITE_START 3'b101
  `define ST_WRITE_MID   3'b110

  // HTRANS transfer type
  `define TRN_IDLE   2'b00
  `define TRN_BUSY   2'b01
  `define TRN_NONSEQ 2'b10
  `define TRN_SEQ    2'b11

  // HBURST transfer type signal encoding
  `define BUR_SINGLE 3'b000
  `define BUR_INCR   3'b001
  `define BUR_WRAP4  3'b010
  `define BUR_INCR4  3'b011
  `define BUR_WRAP8  3'b100
  `define BUR_INCR8  3'b101
  `define BUR_WRAP16 3'b110
  `define BUR_INCR16 3'b111

  // HSIZE encoding
  `define SIZE_8    3'b000
  `define SIZE_16   3'b001
  `define SIZE_32   3'b010
  `define SIZE_64   3'b011
  `define SIZE_128  3'b100
  `define SIZE_256  3'b101
  `define SIZE_512  3'b110
  `define SIZE_1024 3'b111

  // HPROT encoding
  `define PROT_DATA  4'b0001
  `define PROT_PRIV  4'b0010
  `define PROT_BUFF  4'b0100
  `define PROT_CACHE 4'b1000

  // The protection level for these transfers is DATA and SUPERVISOR
  `define PROT_LEVEL (`PROT_DATA | `PROT_PRIV)

//----------------------------------------------------------------------------
// Signal declarations
//----------------------------------------------------------------------------

// Input/Output Signals
  wire          HCLK;      //  System clock
  wire          HRESETn;   //  System reset

  wire          MREADY;    //  Slave ready signal
  wire          MERROR;    //  Slave error signal
  wire [31:0]   MRDATA;    //  Data slave to master

  wire [1:0]    MTRANS;    //  Transfer type
  wire [2:0]    MBURST;    //  Burst type
  wire [3:0]    MPROT;     //  Transfer protection bits
  wire [2:0]    MSIZE;     //  Transfer size
  wire          MWRITE;    //  Transfer direction
  wire          MMASTLOCK; //  Transfer is a locked transfer
  wire [31:0]   MADDR;     //  Transfer address
  reg [31:0]    MWDATA;    //  Data master to slave

// Internal Signals
  // Register block signals
  reg [3:0]     MemAddr;
  reg           MemWrite;

  // Registered versions of control signals
  reg [3:0]     MemAddrReg;
  reg           MemWriteReg;
  reg [2:0]     iMSIZEReg;

  // Counter signals
  reg [9:0]     Count;
  wire          CountZero;
  reg [9:0]     CountNext;
  wire          ResetCounter;

  // State machine signals
  reg [2:0]     State;

  // Internal copies of outputs
  reg [1:0]     iMTRANS;
  reg           iMWRITE;
  reg [2:0]     iMSIZE;
  reg [2:0]     iMBURST;
  reg [3:0]     iMPROT;
  reg [31:0]    iMADDR;
  reg           iMMASTLOCK;
  
  // Combinatorial versions of registered signals
  wire [3:0]    NextMemAddr;
  wire          NextMemWrite;
  reg [2:0]     NextState;
  wire [1:0]    NextMTRANS;
  wire          NextMWRITE;
  wire [2:0]    NextMSIZE;
  wire [2:0]    NextMBURST;
  wire [3:0]    NextMPROT;
  wire [31:0]   NextMADDR;
  reg [31:0]    NextMWDATA;
  wire          NextMMASTLOCK;
  
  // Internal register Signals
  wire          R0En;             //  Register enables
  wire          R1En;
  wire          R2En;
  wire          R3En;
  wire [31:0]   NextR0;
  wire [31:0]   NextR1;
  wire [31:0]   NextR2;
  wire [31:0]   NextR3;
  reg [31:0]    R0;
  reg [31:0]    R1;
  reg [31:0]    R2;
  reg [31:0]    R3;
  reg [31:0]    RegData;

  // Write data mask
  reg [31:0]    Mask;

//----------------------------------------------------------------------------
// Beginning of main code
//----------------------------------------------------------------------------

//----------------------------------------------------------------------------
// Main state machine
//----------------------------------------------------------------------------
// The main state machine controls the action of the core. The reset state
// is ST_COUNT1 where the core waits for the counter to decrement to zero
// before commencing with the read burst.
//
// The transfer begins in ST_READ_START. A separate start state is included
// as MTRANS is NONSEQ for the start of the transfer and SEQ for the
// remainder.
//
// The burst continues in ST_READ_MID, where MADDR and MemAddr are
// incremented on each cycle. The read burst ends when the target MemAddr
// is reached.
//
// A further count delay is introduced in ST_COUNT2 before the write burst
// is entered in ST_WRITE_START.
// The write burst is performed using a similar set of states to the read
// burst.

  always @ (State or CountZero or MemAddr)
    begin : p_StateComb
      case (State)

        `ST_COUNT1 :
          if (CountZero)
            NextState = `ST_READ_START;
          else
            NextState = `ST_COUNT1;
        
        `ST_READ_START :
          NextState = `ST_READ_MID;
        
        `ST_READ_MID :
          if (MemAddr == 4'b1100)
            NextState = `ST_COUNT2;
          else
            NextState = `ST_READ_MID;

        `ST_COUNT2 :
          if (CountZero)
            NextState = `ST_WRITE_START;
          else
            NextState = `ST_COUNT2;

        `ST_WRITE_START :
          NextState = `ST_WRITE_MID;
        
        `ST_WRITE_MID :
          if (MemAddr == 4'b1111)
            NextState = `ST_COUNT1;
          else
            NextState = `ST_WRITE_MID;
        
        default :
          NextState = `ST_COUNT1;                    // Illegal state transition

      endcase
    end // block: p_StateComb


  // State register
  always @ (negedge HRESETn or posedge HCLK)
    begin : p_ChangeStateSeq
      if (!HRESETn)
        State <= `ST_COUNT1;  // Reset values
      else
        State <= NextState;
    end

//----------------------------------------------------------------------------
// MADDR generation
//----------------------------------------------------------------------------
// MADDR is initialised at the start of the READ cycle and incremented
// during the transfer until 4 cycles have been tranferred
// During wait and all other states, the address is unchanged
// The write transfers are all to a single address.

  assign NextMADDR = NextState == `ST_READ_START ? {EBMreadAddr, 24'h000000}

                     : NextState == `ST_READ_MID ? iMADDR + 32'h00000004

                     : (NextState == `ST_WRITE_START ||
                        NextState == `ST_WRITE_MID) ? {EBMwriteAddr, 24'h000000}

                     : iMADDR;

//----------------------------------------------------------------------------
// AHB-Lite control signals
//----------------------------------------------------------------------------
// MTRANS is NONSEQ at the start of the read burst and SEQ during the
// remaining transfers.
// Set to NONSEQ throughout the 16 single write transfers.
// MTRANS is IDLE at all other times.
// Note that a BUSY transfer is not used in this design.

  assign NextMTRANS = (NextState == `ST_READ_START ||
                       NextState == `ST_WRITE_START ||
                       NextState == `ST_WRITE_MID) ? `TRN_NONSEQ

                      : NextState == `ST_READ_MID ? `TRN_SEQ
                      
                      : `TRN_IDLE;

  // MWRITE is asserted throughout the write transfers

  assign NextMWRITE = (NextState == `ST_WRITE_START ||
                       NextState == `ST_WRITE_MID) ? 1'b1

                      : 1'b0;

  // MSIZE is set to 8 bits during write transfers, 32 bit at other times

  assign NextMSIZE = (NextState == `ST_WRITE_START ||
                      NextState == `ST_WRITE_MID) ? `SIZE_8

                     : `SIZE_32;

  // MBURST is INCR4 during the read burst, SINGLE at other times

  assign NextMBURST = (NextState == `ST_READ_START ||
                       NextState == `ST_READ_MID) ? `BUR_INCR4

                      : `BUR_SINGLE;

  // MPROT is set to PROT_LEVEL at all times

  assign  NextMPROT = `PROT_LEVEL;


  // MMASTLOCK is asserted for the write cycles
  assign NextMMASTLOCK = (NextState == `ST_WRITE_START ||
                          NextState == `ST_WRITE_MID) ? 1'b1
                         : 1'b0;
  
//--------------------------------------------------------------------------
// Register bank control signals
//--------------------------------------------------------------------------
// MemAddr is synchronised with MADDR, initialised in START and incremented
// during MID and END states
// During other states, the previous value is held

  assign NextMemAddr = (NextState == `ST_READ_START ||
                        NextState == `ST_WRITE_START) ? 4'b0000

                       : NextState == `ST_READ_MID ? MemAddr + 4'b0100

                       : NextState == `ST_WRITE_MID ? MemAddr + 4'b0001

                       : MemAddr;

  // MemWrite is high during READ states

  assign NextMemWrite = (NextState == `ST_READ_START ||
                         NextState == `ST_READ_MID) ? 1'b1

                        : 1'b0;

//----------------------------------------------------------------------------
// Update registered signals
//----------------------------------------------------------------------------

  always @ (negedge HRESETn or posedge HCLK)
    begin : p_StateBurstSeq
      if (!HRESETn)
        begin
          // Reset values
          iMTRANS    <= `TRN_IDLE;
          iMWRITE    <= 1'b0;
          iMSIZE     <= `SIZE_8;
          iMBURST    <= `BUR_SINGLE;
          iMPROT     <= 4'h0;
          iMADDR     <= 32'h00000000;
          iMMASTLOCK <= 1'b0;
          MemAddr    <= 4'b0000;
          MemWrite   <= 1'b0;
        end
      else
        if (MREADY)
          begin
            iMTRANS <= NextMTRANS;
            iMWRITE <= NextMWRITE;
            iMSIZE  <= NextMSIZE;
            iMBURST <= NextMBURST;
            iMPROT <= NextMPROT;
            iMADDR <= NextMADDR;
            iMMASTLOCK <= NextMMASTLOCK;
            MemAddr <= NextMemAddr;
            MemWrite <= NextMemWrite;
          end
    end

//----------------------------------------------------------------------------
// Decrementing Counter - used to count IDLE transfers between bursts
//----------------------------------------------------------------------------
// if ResetCounter is set, then initial value is loaded
// else if count is non-zero and MREADY is HIGH then decrement it.
// MREADY is included to stop the counter whilst waiting for the last
// data transfer to complete.
// The CountZero flag is set when the counter is zero.

  always @ (Count or ResetCounter)
    begin : p_CounterComb
      if (ResetCounter || (EBMenable == 0))
        CountNext = EBMinitCount;
      else
        begin
          if (Count == 10'b0000000000)
            CountNext = 10'b0000000000;
          else
            CountNext = (Count - 10'b0000000001);
        end
    end

  always @ (negedge HRESETn or posedge HCLK)
    begin : p_CounterReg
      if (!HRESETn)
        Count <= EBMinitCount;
      else
        if (MREADY)
          Count <= CountNext;
    end

  // update CountZero flag

  assign CountZero = Count == 10'b0000000000 ? 1'b1

                     : 1'b0;

  // Reset counter logic
  // Counter is held in reset except when entering counting states

  assign ResetCounter = (NextState == `ST_COUNT1 ||
                         NextState == `ST_COUNT2) ? 1'b0

                        : 1'b1;

//----------------------------------------------------------------------------
// Register Block 4 x 32 bit
//----------------------------------------------------------------------------
// The register block is accessed in a pipelined fashion with interface:
//   MemAddr
//   MemWrite
//   MRDATA
//   MWDATA

//----------------------------------------------------------------------------
// Data mask generation
//----------------------------------------------------------------------------
// The data written to the registers depends on the transfer size.
// Unchanging bits of the write data are set HIGH in the mask.
// Changing   bits of the write data are set LOW  in the mask.
// The mask is used to allow the use of one set of size decoding logic
// for all registers in the system.
// NOTE - this module is little endian, and must be modified for a big
//        endian system.

  always @ (iMSIZEReg or MemAddrReg)
    begin : p_SizeComb

      if (iMSIZEReg == `SIZE_8)  // Byte read
        case (MemAddrReg [1:0])
          
          2'b00 : begin
            Mask [7:0]  = 8'h00;
            Mask [31:8] = {24{1'b1}};
          end // case: 2'b00
          
          2'b01 : begin
            Mask [7:0]   = {8{1'b1}};
            Mask [15:8]  = 8'h00;
            Mask [31:16] = {16{1'b1}};
          end // case: 2'b01
          
          2'b10   : begin
            Mask [15:0]  = {16{1'b1}};
            Mask [23:16] = 8'h00;
            Mask [31:24] = {8{1'b1}};
          end // case: 2'b10
          
          2'b11   : begin
            Mask [23:0]  = {24{1'b1}};
            Mask [31:24] = 8'h00;
          end // case: 2'b11
          
          default : Mask [31:0] = 32'h00000000;
          
        endcase
      
      else
        Mask = 32'h00000000;  // Word read
    end

//----------------------------------------------------------------------------
// Address and control registers
//----------------------------------------------------------------------------
// Registers are used to store the address and control signals from the
// address phase for use in the data phase of the transfer.
// Signals only change when MREADY is HIGH

  always @ (negedge HRESETn or posedge HCLK)
    begin : p_MemACRegSeq
      if (!HRESETn)
        begin
          MemAddrReg  <= 4'b0000;
          MemWriteReg <= 1'b0;
          iMSIZEReg   <= 3'b000;
        end
      else
        if (MREADY)
          begin
            MemAddrReg  <= MemAddr;
            MemWriteReg <= MemWrite;
            iMSIZEReg   <= iMSIZE;
          end
    end

//----------------------------------------------------------------------------
// Internal register address decoding
//----------------------------------------------------------------------------
// The relevant enables are set when MemWrite is set for this data phase and 
// MERROR is LOW

  assign R0En = MemWriteReg && !MERROR && (MemAddrReg[3:2] == 2'b00) ? 1'b1
                
                : 1'b0;
  
  assign R1En = MemWriteReg && !MERROR && (MemAddrReg[3:2] == 2'b01) ? 1'b1
                
                : 1'b0;

  assign R2En = MemWriteReg && !MERROR && (MemAddrReg[3:2] == 2'b10) ? 1'b1
                
                : 1'b0;

  assign R3En = MemWriteReg && !MERROR && (MemAddrReg[3:2] == 2'b11) ? 1'b1
                
                : 1'b0;

//----------------------------------------------------------------------------
// Read/write registers
//----------------------------------------------------------------------------
// These registers hold their values when written to.
// The current register data has a mask applied that is set according to the 
// size of the current write transfer, and the masked bits are then set with
// the input write data from MRDATA.

  assign NextR0 = R0En ? ((R0 & Mask) | (MRDATA & ~Mask)) : R0;

  assign NextR1 = R1En ? ((R1 & Mask) | (MRDATA & ~Mask)) : R1;

  assign NextR2 = R2En ? ((R2 & Mask) | (MRDATA & ~Mask)) : R2;

  assign NextR3 = R3En ? ((R3 & Mask) | (MRDATA & ~Mask)) : R3;

  always @ (negedge HRESETn or posedge HCLK)
    begin : p_R0Seq
      if (!HRESETn)
        R0 <= 32'h00000000;
      else
        if (R0En)
          R0 <= NextR0;
    end // block: p_R0Seq

  always @ (negedge HRESETn or posedge HCLK)
    begin : p_R1Seq
      if (!HRESETn)
        R1 <= 32'h00000000;
      else
        if (R1En)
          R1 <= NextR1;
    end // block: p_R1Seq

  always @ (negedge HRESETn or posedge HCLK)
    begin : p_R2Seq
      if (!HRESETn)
        R2 <= 32'h00000000;
      else
        if (R2En)
          R2 <= NextR2;
    end // block: p_R2Seq

  always @ (negedge HRESETn or posedge HCLK)
    begin : p_R3Seq
      if (!HRESETn)
        R3 <= 32'h00000000;
      else
        if (R3En)
          R3 <= NextR3;
    end // block: p_R3Seq

//----------------------------------------------------------------------------
// MWDATA generation
//----------------------------------------------------------------------------
// Generates the write data directly from the internal register values.
// Data is driven if MemWrite is LOW for this data transfer otherwise, data is
// driven LOW. For byte writes, the byte is replicated throughout the word.

  always @ (MemAddr or R0 or R1 or R2 or R3)
    begin : p_RegSelectComb
      // Get the correct register data
      case (MemAddr [3:2])
        2'b00:   RegData = R0;
        2'b01:   RegData = R1;
        2'b10:   RegData = R2;
        2'b11:   RegData = R3;
        default: RegData = 32'h00000000;
      endcase
    end

  always @ (MemWrite or MemAddr or iMSIZE or RegData)
    begin : p_NextMWDATAComb
      if (!MemWrite)
        begin // read from registers
          if (iMSIZE == `SIZE_8)
            begin
              case (MemAddr [1:0])
                2'b00: begin
                  NextMWDATA [7:0]   = RegData [7:0];
                  NextMWDATA [15:8]  = RegData [7:0];
                  NextMWDATA [23:16] = RegData [7:0];
                  NextMWDATA [31:24] = RegData [7:0];
                end

                2'b01: begin
                  NextMWDATA [7:0]   = RegData [15:8];
                  NextMWDATA [15:8]  = RegData [15:8];
                  NextMWDATA [23:16] = RegData [15:8];
                  NextMWDATA [31:24] = RegData [15:8];
                end

                2'b10: begin
                  NextMWDATA [7:0]   = RegData [23:16];
                  NextMWDATA [15:8]  = RegData [23:16];
                  NextMWDATA [23:16] = RegData [23:16];
                  NextMWDATA [31:24] = RegData [23:16];
                end

                2'b11: begin
                  NextMWDATA [7:0]   = RegData [31:24];
                  NextMWDATA [15:8]  = RegData [31:24];
                  NextMWDATA [23:16] = RegData [31:24];
                  NextMWDATA [31:24] = RegData [31:24];
                end

                default: NextMWDATA  = 32'h00000000;
              endcase // case(MemAddrReg [1:0])
            end
          else // all other sizes
            NextMWDATA = RegData;
        end // if (!MemWriteReg)
      else
        NextMWDATA = 32'h00000000;
    end // block: p_NextMWDATAComb

  // MWDATA register
  always @ (negedge HRESETn or posedge HCLK)
    begin : p_MWDATASeq
      if (!HRESETn)
        MWDATA <= 32'h00000000; // Reset value
      else
        if (MREADY)
          MWDATA <= NextMWDATA;
    end

//----------------------------------------------------------------------------
// Output drivers
//----------------------------------------------------------------------------
// Drive the output ports with the internal versions.

  assign MTRANS    = iMTRANS;
  assign MWRITE    = iMWRITE;
  assign MSIZE     = iMSIZE;
  assign MBURST    = iMBURST;
  assign MPROT     = iMPROT;
  assign MADDR     = iMADDR;
  assign MMASTLOCK = iMMASTLOCK;
  

endmodule

//================================= End ======================================--
