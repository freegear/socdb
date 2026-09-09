//  --=======================================================================--
//  This confidential and proprietary software may be used only as
//  authorised by a licensing agreement from ARM Limited
//    (C) COPYRIGHT 2001 ARM Limited
//        ALL RIGHTS RESERVED
//  The entire notice above must be reproduced on all authorised
//  copies and copies may only be made to the extent permitted
//  by a licensing agreement from ARM Limited.
//
//  ---------------------------------------------------------------------------
//  Version and Release Control Information:
//
//  File Name           : FileReadCore.v,v
//  File Revision       : 1.10
//
//  Release Information : ADK_REL1v1
//
//  ---------------------------------------------------------------------------
//  Purpose             : The AHB-Lite file reader bus master reads in a file
//                        and decodes it into AHB-Lite bus transfers.
//  --=======================================================================--

`timescale 1ns/1ps

module FileReadCore
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

  parameter      InputFileName = "filestim.frd"; // Default stimulus file name

  input          HCLK;      // System clock
  input          HRESETn;   // System reset

  input          MREADY;    // Slave ready signal
  input          MERROR;    // Slave response signal
  input [31:0]   MRDATA;    // Data from slave to master
  output [1:0]   MTRANS;    // Transfer type
  output [2:0]   MBURST;    // Burst type
  output [3:0]   MPROT;     // Transfer protection bits
  output [2:0]   MSIZE;     // Transfer size
  output         MWRITE;    // Transfer direction
  output         MMASTLOCK; // Transfer is a locked transfer
  output [31:0]  MADDR;     // Transfer address
  output [31:0]  MWDATA;    // Data from master to slave

  //----------------------------------------------------------------------------
  // Constant declarations
  //----------------------------------------------------------------------------

  // Max number of lines in the frd stimulus file.
  //  Increase this for larger files
  `define FILEARRAY_LENGTH 2000

  `define UNDEF32       32'hx

  // HTRANS transfer type signal encoding
  `define TRN_IDLE      2'b00
  `define TRN_BUSY      2'b01
  `define TRN_NONSEQ    2'b10
  `define TRN_SEQ       2'b11

  // HSIZE transfer type sgnal encoding
  `define SZ_BYTE       3'b000
  `define SZ_HALF       3'b001
  `define SZ_WORD       3'b010

  // HBURST transfer type signal encoding
  `define BUR_SINGLE    3'b000
  `define BUR_INCR      3'b001
  `define BUR_WRAP4     3'b010
  `define BUR_INCR4     3'b011
  `define BUR_WRAP8     3'b100
  `define BUR_INCR8     3'b101
  `define BUR_WRAP16    3'b110
  `define BUR_INCR16    3'b111
  `define NOBOUND       3'b000

  // Wrap boundary limits
  `define BOUND4        3'b001
  `define BOUND8        3'b010
  `define BOUND16       3'b011
  `define BOUND32       3'b100
  `define BOUND64       3'b101

  // Commands
  `define CMD_WRITE     3'b000
  `define CMD_READ      3'b001
  `define CMD_SEQ       3'b010
  `define CMD_BUSY      3'b011
  `define CMD_IDLE      3'b100
  `define CMD_POLL      3'b101
  `define CMD_LOOP      3'b110

  // Poll Command states
  `define NO_POLL       2'b00
  `define READ_DATA     2'b01
  `define TEST_DATA     2'b10
  `define NEXT_POLL     2'b11

//---------------------------------------------------------------------------
// Signal declarations
//---------------------------------------------------------------------------

  // Input/Output Signals
  wire           HCLK;
  wire           HRESETn;
  wire           MREADY;
  wire           MERROR;
  wire [31:0]    MRDATA;
  wire  [1:0]    MTRANS;
  wire           MWRITE;
  wire           MMASTLOCK;
  wire  [31:0]   MADDR;
  wire  [31:0]   MWDATA;

  reg [2:0]      MBURST;    // Burst type
  reg [3:0]      MPROT;     // Transfer protection bits
  reg [2:0]      MSIZE;     // Transfer size


  // File read controls
  wire           NotValid;
  wire           RdNext;

  // Signals from file data
  reg [2:0]      Cmd;
  reg [31:0]     Addr;
  reg [31:0]     Data;
  reg [31:0]     Mask;
  reg [2:0]      Burst;
  reg [2:0]      Size;
  reg            Lock;
  reg [3:0]      Prot;
  reg            Dir;

  // Registered signals
  reg [2:0]      CmdReg;
  reg [31:0]     AddrReg;
  reg [31:0]     DataReg;
  reg [31:0]     MaskReg;
  reg [2:0]      BurstReg;
  reg [2:0]      SizeReg;
  reg [3:0]      ProtReg;
  reg            DirReg;

  // Address calculation signals
  wire           NonZero;
  reg [2:0]      AddValue;
  reg [2:0]      Boundary;
  wire [31:0]    CalcAddr;
  reg [31:0]     ResultAddr;

  // Error signals
  reg            SlaveError;
  reg            DataError;
  wire           NextDataError;

  // Internal signals
  wire [31:0]    iMADDR;
  wire [31:0]    iMWDATA;
  reg [1:0]      iMTRANS;
  wire           iMMLOCK;
  wire           iMWRITE;

  // Registered internal signals
  reg [31:0]     iMADDRReg;
  reg [31:0]     iMWDATAReg;
  reg [1:0]      iMTRANSReg;
  reg            iMMLOCKReg;
  reg            iMWRITEReg;
  wire           EnableReg;

  // Poll command state machine
  wire           PollActive;
  reg [1:0]      NextPollState;
  reg [1:0]      CurrPollState;

  // Compared read data
  reg [31:0]     DataCompare;

//---------------------------------------------------------------------------
// START OF BEHAVIOURAL CODE
//---------------------------------------------------------------------------
// synopsys translate_off

  reg [31:0]     FileArray [0:`FILEARRAY_LENGTH];  // Stimulus file data
  reg [31:0]     FileArray_2d_0;                    

  reg [9:0]      LoopNumber;                  // Count looping commands
  integer        ArrayPt;                     // Pointer to stimulus file data


//----------------------------------------------------------------------------
// Open Command File
//----------------------------------------------------------------------------
// Read the command file into an array, this process is only executed once

  initial
    $readmemh(InputFileName, FileArray);

//----------------------------------------------------------------------------
// Read Command
//----------------------------------------------------------------------------
// Reads next command from the array, if the previous one has completed,
// indicated by RdNext. If a looped command is being executed, then the
// command is not updated, if no more commands are available, default signal
// values are used.

  always @ (posedge HCLK or negedge HRESETn)
    begin : p_CmdRead_bhav

      if  (!HRESETn)
        begin
          // Default signal assignments
          Cmd   <= `CMD_IDLE;
          Addr  <= {32{1'b0}};
          Data  <= {32{1'b0}};
          Mask  <= {32{1'b0}};
          Size  <= `SZ_WORD;
          Burst <= `BUR_INCR;
          Prot  <= 4'b0000;
          Dir   <= 1'b0;
          Lock  <= 1'b0;

          LoopNumber <= 10'b0000000000;
          ArrayPt   <= 1'b0;                // Go to beginning of command array
          FileArray_2d_0 <= {32{1'b0}};
        end // if (!HRESETn)
      else
        begin
          if (FileArray[ArrayPt] !== 32'hx && RdNext) // Valid command in array
            begin
              if (LoopNumber != 10'b0000000000) 
                // A command is currently looping
                LoopNumber <= (LoopNumber - 1'b1);
              else
                begin

                  FileArray_2d_0 = FileArray [ArrayPt];

                  case (FileArray_2d_0 [2:0])

                    `CMD_WRITE : begin
                      // Get each write command field
                      Cmd            <= FileArray_2d_0 [2:0];
                      ArrayPt         = (ArrayPt + 1);
                      Addr           <= FileArray [ArrayPt];
                      ArrayPt         = (ArrayPt + 1);
                      Data           <= FileArray [ArrayPt];
                      ArrayPt         = (ArrayPt + 1);
                      FileArray_2d_0  = FileArray [ArrayPt];
                      Size           <= FileArray_2d_0 [2:0];
                      ArrayPt         = (ArrayPt + 1);
                      FileArray_2d_0  = FileArray [ArrayPt];
                      Burst          <= FileArray_2d_0 [2:0];
                      ArrayPt         = (ArrayPt + 1);
                      FileArray_2d_0  = FileArray [ArrayPt];
                      Prot           <= FileArray_2d_0 [3:0];
                      ArrayPt         = (ArrayPt + 1);
                      FileArray_2d_0  = FileArray [ArrayPt];
                      Lock           <= FileArray_2d_0 [0];
                      ArrayPt         = (ArrayPt + 1);
                    end // case: `CMD_WRITE

                    `CMD_READ : begin
                      // Get each read command field
                      Cmd            <= FileArray_2d_0 [2:0];
                      ArrayPt         = (ArrayPt + 1);
                      Addr           <= FileArray [ArrayPt];
                      ArrayPt         = (ArrayPt + 1);
                      Data           <= FileArray [ArrayPt];
                      ArrayPt         = (ArrayPt + 1);
                      Mask           <= FileArray [ArrayPt];
                      ArrayPt         = (ArrayPt + 1);
                      FileArray_2d_0  = FileArray [ArrayPt];
                      Size           <= FileArray_2d_0 [2:0];
                      ArrayPt         = (ArrayPt + 1);
                      FileArray_2d_0  = FileArray [ArrayPt];
                      Burst          <= FileArray_2d_0 [2:0];
                      ArrayPt         = (ArrayPt + 1);
                      FileArray_2d_0  = FileArray [ArrayPt];
                      Prot           <= FileArray_2d_0 [3:0];
                      ArrayPt         = (ArrayPt + 1);
                      FileArray_2d_0  = FileArray [ArrayPt];
                      Lock           <= FileArray_2d_0 [0];
                      ArrayPt         = (ArrayPt + 1);
                    end // case: `CMD_READ

                    `CMD_SEQ : begin
                      // Get each sequential command field
                      Cmd       <= FileArray_2d_0 [2:0];
                      ArrayPt    = (ArrayPt + 1);
                      Data      <= FileArray [ArrayPt];
                      ArrayPt    = (ArrayPt + 1);
                      Mask      <= FileArray [ArrayPt];
                      ArrayPt    = (ArrayPt + 1);
                    end // case: `CMD_SEQ

                    `CMD_BUSY : begin
                      // Set busy command field
                      Cmd       <= FileArray_2d_0 [2:0];
                      ArrayPt    = (ArrayPt + 1);
                      Lock      <= 1'b0;
                    end // case: `CMD_BUSY

                    `CMD_IDLE : begin
                      // Get each idle command field
                      Cmd            <= FileArray_2d_0 [2:0];
                      ArrayPt         = (ArrayPt + 1);
                      Addr           <= FileArray [ArrayPt];
                      ArrayPt         = (ArrayPt + 1);
                      FileArray_2d_0  = FileArray [ArrayPt];
                      Dir            <= FileArray_2d_0 [0];
                      ArrayPt         = (ArrayPt + 1);
                      FileArray_2d_0  = FileArray [ArrayPt];
                      Size           <= FileArray_2d_0 [2:0];
                      ArrayPt         = (ArrayPt + 1);
                      FileArray_2d_0  = FileArray [ArrayPt];
                      Burst          <= FileArray_2d_0 [2:0];
                      ArrayPt         = (ArrayPt + 1);
                      FileArray_2d_0  = FileArray [ArrayPt];
                      Prot           <= FileArray_2d_0 [3:0];
                      ArrayPt         = (ArrayPt + 1);
                      FileArray_2d_0  = FileArray [ArrayPt];
                      Lock           <= FileArray_2d_0 [0];
                      ArrayPt         = (ArrayPt + 1);
                    end // case: `CMD_IDLE

                    `CMD_POLL : begin
                      // Get each poll command field
                      Cmd            <= FileArray_2d_0 [2:0];
                      ArrayPt         = (ArrayPt + 1);
                      Addr           <= FileArray [ArrayPt];
                      ArrayPt         = (ArrayPt + 1);
                      Data           <= FileArray [ArrayPt];
                      ArrayPt         = (ArrayPt + 1);
                      Mask           <= FileArray [ArrayPt];
                      ArrayPt         = (ArrayPt + 1);
                      FileArray_2d_0  = FileArray [ArrayPt];
                      Size           <= FileArray_2d_0 [2:0];
                      ArrayPt         = (ArrayPt + 1);
                      FileArray_2d_0  = FileArray [ArrayPt];
                      Burst          <= FileArray_2d_0 [2:0];
                      ArrayPt         = (ArrayPt + 1);
                      FileArray_2d_0  = FileArray [ArrayPt];
                      Prot           <= FileArray_2d_0 [3:0];
                      ArrayPt         = (ArrayPt + 1);
                      FileArray_2d_0  = FileArray [ArrayPt];
                      Lock           <= 1'b0;
                    end // case: `CMD_POLL

                    `CMD_LOOP : begin
                      // Loops are counted from X to 0 so the loop number is
                      //  reduced by 1.
                      ArrayPt          = (ArrayPt + 1);
                      FileArray_2d_0   = FileArray [ArrayPt];
                      LoopNumber      <= (FileArray_2d_0[9:0] - 1'b1);
                      ArrayPt          = (ArrayPt + 1);
                    end // case: `CMD_LOOP

                    default : $display ("ERROR: Unknown command value in file");

                  endcase // case(FileArray_2d_0 [2:0])
                end // else: !if(LoopNumber != 10'b0000000000)
            end // if (FileArray[ArrayPt] !== 32'hx && RdNext)
          else
            if (RdNext)  // Command signals can change
              begin
                // Set defaults as file stimulus exhausted
                Cmd   <= `CMD_IDLE;
                Addr  <= {32{1'b0}};
                Data  <= {32{1'b0}};
                Mask  <= {32{1'b0}};
                Size  <= `SZ_WORD;
                Burst <= `BUR_INCR;
                Prot  <= 4'b0000;
                Dir   <= 1'b0;
                Lock  <= 1'b0;
              end // if (RdNext)
        end // else: !if(!HRESETn)
    end // block: p_CmdRead_bhav


//---------------------------------------------------------------------------
// Report error to simulation environment
//---------------------------------------------------------------------------
// This process responds to error signals with an acknowledge signal and
//  reports the error to the simulation environment

  always @ (posedge HCLK or negedge HRESETn)
    begin : p_ReportErrors_bhav
      if (!HRESETn)
        begin
        end
      else
        if (MREADY)
          // Report error responce from slave
          if (MERROR)
            begin
   $display ("%d #ERROR# AHB FileReader: Slave responded with an ERROR", $time);
   $display ("Address = %h", iMADDRReg);
            end
          else
            if (NextDataError && !PollActive)
              begin
              // Report data error
   $display ("%d #ERROR# AHB FileReader: Read data did not match data in file",
             $time);
   $display ("Address = %h, Actual data = %h, Expected data = %h, Mask = %h",
             iMADDRReg, MRDATA, DataReg, MaskReg);
              end
    end // block: p_ReportErrors_bhav

// synopsys translate_on
//---------------------------------------------------------------------------
// END OF BEHAVIOURAL CODE
//---------------------------------------------------------------------------

//---------------------------------------------------------------------------
// Register Current Command
//---------------------------------------------------------------------------
// The current command is registered when a new command is read from the file

  assign EnableReg = (MREADY && !PollActive) ? 1'b1
                     : 1'b0;

  always @ (posedge HCLK or negedge HRESETn)
    begin : p_RegFileSeq
      if  (!HRESETn)
        begin
          CmdReg   <= 3'b000;
          AddrReg  <= {32{1'b0}};
          DataReg  <= {32{1'b0}};
          MaskReg  <= {32{1'b0}};
          SizeReg  <= 3'b000;
          BurstReg <= 3'b000;
          ProtReg  <= 4'b0000;
          DirReg   <= 1'b0;
        end // if (!HRESETn)
      else
        if  (EnableReg)
          begin
            CmdReg   <= Cmd;
            AddrReg  <= Addr;
            DataReg  <= Data;
            MaskReg  <= Mask;
            SizeReg  <= Size;
            BurstReg <= Burst;
            ProtReg  <= Prot;
            DirReg   <= Dir;
          end // if (EnableReg)
    end // block: p_RegFileSeq

//---------------------------------------------------------------------------
// Register Output values
//---------------------------------------------------------------------------

// The output address, write signal and transfer type are registered when
//  MREADY is asserted.


  always @ (posedge HCLK or negedge HRESETn)
    begin : p_RegOutputsSeq
      if  (!HRESETn)
        begin
          iMADDRReg   <= {32{1'b0}};
          iMTRANSReg  <= {2{1'b0}};
          iMMLOCKReg  <= 1'b0;
          iMWRITEReg  <= 1'b0;
        end // if (!HRESETn)
      else
        if (MREADY)
          begin
            iMTRANSReg  <= iMTRANS;
            iMADDRReg   <= iMADDR;
            iMMLOCKReg  <= iMMLOCK;
            iMWRITEReg  <= iMWRITE;
          end // if (MREADY)
    end // block: p_regOutputsSeq


//---------------------------------------------------------------------------
// Determine AddValue and calculate address
//---------------------------------------------------------------------------

// The value to be added to the address is based on the current command, the
//  previous command and the width of the data.
//
// The address should be incremented when:
//   MTRANS is sequential or busy and previous Cmd is sequential or read
//   or write (NONSEQ).

  assign NonZero = (Cmd == `CMD_SEQ  && CmdReg == `CMD_SEQ)   ||
                   (Cmd == `CMD_SEQ  && CmdReg == `CMD_WRITE) ||
                   (Cmd == `CMD_SEQ  && CmdReg == `CMD_READ)  ||
                   (Cmd == `CMD_BUSY && CmdReg == `CMD_SEQ)   ||
                   (Cmd == `CMD_BUSY && CmdReg == `CMD_WRITE) ||
                   (Cmd == `CMD_BUSY && CmdReg == `CMD_READ) ? 1'b1
                   : 1'b0;

  always @ (Size or NonZero)
    begin : p_CalcAddValueComb
      if (NonZero)
        begin
          case (Size)
            `SZ_BYTE : AddValue = 3'b001;
            `SZ_HALF : AddValue = 3'b010;
            `SZ_WORD : AddValue = 3'b100;
            default  : AddValue = 3'b000;
          endcase // case(Size)
        end // if NonZero
      else
        AddValue = 3'b000;
    end // block: p_CalcAddValueComb


//---------------------------------------------------------------------------
// Calculate new address value
//---------------------------------------------------------------------------

  assign  CalcAddr = (iMADDRReg + {29'b00000000000000000000000000000,AddValue});

//---------------------------------------------------------------------------
// Trap wrapping burst boundaries
//---------------------------------------------------------------------------

// When the burst is a wrapping burst the calculated address must not cross
//  the boundary (size(bytes) x beats in burst).
// The boundary value is set based on the Burst and Size values

  always @ (Size or Burst)
    begin : p_BoundaryValueComb
      case (Size)

        `SZ_BYTE :
          case (Burst)
            `BUR_WRAP4  : Boundary  = `BOUND4;
            `BUR_WRAP8  : Boundary  = `BOUND8;
            `BUR_WRAP16 : Boundary  = `BOUND16;
            `BUR_SINGLE,
            `BUR_INCR,
            `BUR_INCR4,
            `BUR_INCR8,
            `BUR_INCR16 : Boundary  = `NOBOUND;
            default     : Boundary  = `NOBOUND;
          endcase // case (Burst)

        `SZ_HALF :
          case (Burst)
            `BUR_WRAP4  : Boundary  = `BOUND8;
            `BUR_WRAP8  : Boundary  = `BOUND16;
            `BUR_WRAP16 : Boundary  = `BOUND32;
            `BUR_SINGLE,
            `BUR_INCR,
            `BUR_INCR4,
            `BUR_INCR8,
            `BUR_INCR16 : Boundary  = `NOBOUND;
            default     : Boundary  = `NOBOUND;
          endcase // case (Burst)

        `SZ_WORD :
          case (Burst)
            `BUR_WRAP4  : Boundary  = `BOUND16;
            `BUR_WRAP8  : Boundary  = `BOUND32;
            `BUR_WRAP16 : Boundary  = `BOUND64;
            `BUR_SINGLE,
            `BUR_INCR,
            `BUR_INCR4,
            `BUR_INCR8,
            `BUR_INCR16 : Boundary  = `NOBOUND;
            default     : Boundary  = `NOBOUND;
          endcase // case (Burst)

        default         : Boundary  = `NOBOUND;
      endcase // case (Size)
    end // block: p_BoundaryValueComb

// The calculated address is checked to see if it has crossed the boundary.
//  If it has the result address is wrapped otherwise it is equal to the
//  calcualted address.

  always @ (Boundary or CalcAddr or iMADDRReg)
    begin : p_ResultAddrComb
      case (Boundary)
        `NOBOUND : ResultAddr = CalcAddr;

        `BOUND4  :
          if  (CalcAddr [1:0] == 2'b00)
            begin
              ResultAddr [31:2] = iMADDRReg [31:2];
              ResultAddr [1:0] = 2'b00;
            end // if (CalcAddr [1:0] == 2'b00)
          else
            ResultAddr = CalcAddr;

        `BOUND8 :
          if  (CalcAddr [2:0]==3'b000)
            begin
              ResultAddr [31:3] = iMADDRReg [31:3];
              ResultAddr [2:0] = 3'b000;
            end // if (CalcAddr [2:0]==3'b000)
          else
            ResultAddr = CalcAddr;

        `BOUND16 :
          if  (CalcAddr [3:0] == 4'b0000)
            begin
              ResultAddr [31:4] = iMADDRReg [31:4];
              ResultAddr [3:0] = 4'b0000;
            end // if (CalcAddr [3:0] == 4'b0000)
          else
            ResultAddr = CalcAddr;

        `BOUND32 :
          if  (CalcAddr [4:0] == 5'b00000)
            begin
              ResultAddr [31:5] = iMADDRReg [31:5];
              ResultAddr [4:0] = 5'b00000;
            end // if (CalcAddr [4:0] == 5'b00000)
          else
            ResultAddr = CalcAddr;

        `BOUND64 :
          if  (CalcAddr [5:0] == 6'b000000)
            begin
              ResultAddr [31:6] = iMADDRReg [31:6];
              ResultAddr [5:0] = 6'b000000;
            end // if (CalcAddr [5:0] == 6'b000000)
          else
            ResultAddr = CalcAddr;

        default : ResultAddr = {32{1'b0}};
      endcase // case(Boundary)
    end // block: p_ResultAddrComb

//---------------------------------------------------------------------------
// Address Output
//---------------------------------------------------------------------------
// Address is calculated when there is a busy or sequential command otherwise
//  the value from the input file is used. The registered address is used for
//  poll commands.

  assign iMADDR  = (Cmd ==`CMD_SEQ || Cmd ==`CMD_BUSY) ? ResultAddr
                   : (PollActive) ? AddrReg
                   : Addr;

  assign  MADDR  = iMADDR;

//---------------------------------------------------------------------------
// Next Line File Read Control
//---------------------------------------------------------------------------

// Read from file control
// If a transfer is "not valid" ie the master is not attempting a transfer
//  that will result in data transfer, the master can continue to read
//  commands from the file when MREADY is low.
//  The exception is when the command being executed is a poll command

  assign NotValid  = (Cmd == `CMD_BUSY ||
                      (Cmd == `CMD_IDLE && CmdReg != `CMD_POLL)) ? 1'b1
                     : 1'b0;

  assign RdNext = ((!MREADY && !NotValid) || PollActive) ? 1'b0
                  : 1'b1;

//---------------------------------------------------------------------------
// Transfer Type Control
//---------------------------------------------------------------------------
// Transfer type output, when executing a poll command MTRANS can only be
// set to NONSEQ or IDLE, depending on the poll state. For the other commands
// MTRANS is set to NONSEQ for read and write commands, SEQ for sequential
// and BUSY for busy commands.

  always @ (Cmd or PollActive or CurrPollState)
    begin : p_MTransControlComb
      if  (PollActive)
        begin
          if (CurrPollState == `TEST_DATA)
            iMTRANS  = `TRN_NONSEQ;
          else
            iMTRANS  = `TRN_IDLE;
        end // if (PollActive)
      else
        case (Cmd)
          `CMD_WRITE : iMTRANS = `TRN_NONSEQ;
          `CMD_READ  : iMTRANS = `TRN_NONSEQ;
          `CMD_POLL  : iMTRANS = `TRN_NONSEQ;
          `CMD_SEQ   : iMTRANS = `TRN_SEQ;
          `CMD_BUSY  : iMTRANS = `TRN_BUSY;
          `CMD_IDLE  : iMTRANS = `TRN_IDLE;
          default    : iMTRANS = `TRN_IDLE;
        endcase // case(Cmd)
    end // block: p_MTransControlComb

  assign  MTRANS  = iMTRANS;

//---------------------------------------------------------------------------
// Direction Control
//---------------------------------------------------------------------------
// MWRITE is only asserted for a write command or the idle command, when dir
// set. MWRITE retains its value until the end of the burst.

  assign iMWRITE  = (PollActive ||
                     Cmd == `CMD_BUSY ||
                     Cmd == `CMD_SEQ) ? iMWRITEReg

                    : (Cmd == `CMD_WRITE ||
                       (Cmd == `CMD_IDLE && Dir)) ? 1'b1

                    : 1'b0;

  assign  MWRITE  = iMWRITE;

//---------------------------------------------------------------------------
// Locked Transfers
//---------------------------------------------------------------------------
// MMASTLOCK is only asserted on a read or write command, and retains its
// value until the end of the burst.

  assign iMMLOCK  = (Cmd == `CMD_BUSY || Cmd == `CMD_SEQ) ? iMMLOCKReg
                    : Lock == 1'b1 ? 1'b1
                    : 1'b0;

  assign  MMASTLOCK  = iMMLOCK;

//---------------------------------------------------------------------------
// Other Transfer Control Information
//---------------------------------------------------------------------------
// Transfer output mux, the registered values are used when a busy,
// sequential or poll commands are being executed. Otherwise the values
// directly from the file are used.

  always @ (Cmd or Size or SizeReg or Prot or ProtReg or
            Burst or BurstReg or PollActive)
    begin : p_ContolInfoComb
      if  (((Cmd ==`CMD_BUSY  || Cmd ==`CMD_SEQ) || PollActive))
        begin
          MSIZE  = SizeReg;
          MBURST = BurstReg;
          MPROT  = ProtReg;
        end // if (((Cmd ==`CMD_BUSY  || Cmd ==`CMD_SEQ) || PollActive))
      else
        begin
          MSIZE  = Size;
          MBURST = Burst;
          MPROT  = Prot;
        end // else: !if(((Cmd ==`CMD_BUSY  || Cmd ==`CMD_SEQ) || PollActive))
    end // block: p_ContolInfoComb


//---------------------------------------------------------------------------
// Data Control and Compare
//---------------------------------------------------------------------------
// When the transfer type from the previous address cycle was TRN_NONSEQ or
//  TRN_SEQ then either the read or write data bus will be active in the
//  next cycle.
// write data is recorded in the address cycle

  assign iMWDATA = (iMWRITE && MREADY &&
                    (iMTRANS == `TRN_NONSEQ || iMTRANS == `TRN_SEQ)) ? Data
                   : 32'h00000000;

  // The write data is registered when HREADY is asserted
  always @ (posedge HCLK or negedge HRESETn)
    begin : p_regWDataSeq
      if (!HRESETn)
        iMWDATAReg <= {32{1'b0}};
      else
        if (MREADY)
          iMWDATAReg <= iMWDATA;
    end // block: p_regWDataSeq

  // The registered value is output on the AHB-Lite interface
  assign  MWDATA = iMWDATAReg;

  // Read data is recorded in the cycle after the address and compared with
  // the expected data value after applying the mask

  always @ (MRDATA or iMTRANSReg or iMWRITEReg or MaskReg or DataReg)
    begin : p_DataCompareComb
      if  (!iMWRITEReg && (iMTRANSReg ==`TRN_NONSEQ || iMTRANSReg ==`TRN_SEQ))
        DataCompare = ((DataReg & MaskReg) ^ (MRDATA & MaskReg));
      else
        DataCompare = {32{1'b0}};
    end // block: p_DataCompareComb

  // If DataCompare is non-zero, flag an error
  assign NextDataError = (DataCompare !== {32{1'b0}}) ? 1'b1
                         : 1'b0;

  // Errors are only flaged when MREADY is asserted
  always @ (posedge HCLK or negedge HRESETn)
    begin : p_DataCompareSeq
      if  (!HRESETn)
        begin
          DataError  <= 1'b0;
          SlaveError <= 1'b0;
        end // if (!HRESETn)
      else
        // At the end of the data cycle
        if  (MREADY)
          begin
            // Record any AHB slave errors
            SlaveError <= MERROR;
            DataError  <= NextDataError;
          end // if (MREADY)
    end // block: p_DataCompareSeq


//---------------------------------------------------------------------------
// Poll Command State
//---------------------------------------------------------------------------
// The poll command requires two AHB transfers: a read followed by an idle
// to get the data from the read transfer. This command will contimue until
// the data read matches the expected data. The state machine is used to
// control the read and idle transfers, and the completion of the poll
// command
//
// when (Cmd = CMD_POLL) or (CmdReg = CMD_POLL and NextPollState = TEST_DATA)
//  a read transfer is performed.
// when CmdReg = CMD_POLL and NextPollState = READ_DATA
//  MTRANS is forced to TRN_IDLE to read in data

  always @ (CurrPollState or Cmd or DataError or SlaveError)
    begin : p_PollStateComb
      case (CurrPollState)
        `NO_POLL : begin
          if  (Cmd == `CMD_POLL)
            // Poll command will take place in this cycle so the transfer
            // is an idle transfer
            NextPollState  = `READ_DATA;
          else
            NextPollState  = `NO_POLL;
        end // case: `NO_POLL

        `READ_DATA :
          // Next state is always to test the data
          NextPollState  = `TEST_DATA;

        `TEST_DATA :
          if  (!DataError && !SlaveError)
            begin
              if  (Cmd == `CMD_POLL)
                // A new poll command
                NextPollState  = `NEXT_POLL;
              else
                NextPollState  = `NO_POLL;
            end
        else
          // If the data does not match then the command does not complete
          NextPollState  = `READ_DATA;

        `NEXT_POLL :
          NextPollState  = `TEST_DATA;

        default:
          NextPollState  = `NO_POLL;
      endcase // case(CurrPollState)
    end // block: p_PollStateComb

  always @ (posedge HCLK or negedge HRESETn)
    begin : p_PollStateSeq
      if  (!HRESETn)
        CurrPollState <= `NO_POLL;
      else
        if  (MREADY)
          CurrPollState <= NextPollState;
    end // block: p_PollStateSeq

//---------------------------------------------------------------------------
// Poll State Decode
//---------------------------------------------------------------------------
// Flag indicates when poll command is being executed, note poll active goes
// low for a single transfer when a poll command is followed by another poll
// command, this allows for new control information to be presented.

  assign PollActive =  CurrPollState == `NEXT_POLL ||
                       CurrPollState == `READ_DATA ||
                       (CurrPollState == `TEST_DATA &&
                        NextPollState == `READ_DATA) ? 1'b1
                       : 1'b0;

endmodule // FileReadCore
