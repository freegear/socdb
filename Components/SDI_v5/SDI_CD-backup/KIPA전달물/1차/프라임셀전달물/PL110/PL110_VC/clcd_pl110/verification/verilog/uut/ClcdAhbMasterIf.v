//===========================================================================--
//  This confidential and proprietary software may be used only as
//  authorised by a licensing agreement from ARM Limited
//    (C) COPYRIGHT 2002 ARM Limited
//        ALL RIGHTS RESERVED
//  The entire notice above must be reproduced on all authorised
//  copies and copies may only be made to the extent permitted
//  by a licensing agreement from ARM Limited.
//
//
//-----------------------------------------------------------------------------
//  
//  Version and Release Control Information:
//  
//  File Name              : ClcdAhbMasterIf.v.rca
//  File Revision          : 1.2
//  
//  Release Information    : PrimeCell(TM)-PL110-r1p2-00ltd0
//  
//------------------------------------------------------------------------------
//  Purpose                : AhbMaster module of Colour LCD Controller.
//============================================================================--
 
`timescale 1ns/1ps

`include "ClcdDefine.v"

module ClcdAhbMasterIf (
          // Input ports         
                         // Bus side signals
                         HCLK,
                         HRESETn,
                         HGRANTM,
                         HRESPM,
                         HREADYINM,
                         HRDATAM,

                         // Slave side signals
                         ClrLNBU,
                         LCDLPBASE,
                         LCDUPBASE,
                         ClrAhbMasterErr,
                         LcdDual,   

                         // Fifo side signals
                         UFWatermark,
                         LFWatermark,
                         FrameRst,
                         FrameStart,
                         LFifoAck,
                         UFifoAck,
                         

         // Output ports
                         // Bus side signals
                         HWRITEM,
                         HSIZEM,
                         HBURSTM,
                         HADDRM,
                         HTRANSM,
                         HPROTM,
                         HLOCKM,
                         HBUSREQM,

                         // Slave side signals
                         
                         LCDLPCURR,
                         LCDUPCURR,
                         AhbMError,

                         LNBU,

                         // Fifo side signals
                         UFDataValid,
                         LFDataValid,
                         FifoWData,
                         LowerDmaFlag,
                         WordCount,
                         FrameRstAck
                        );

// Input ports
input           HCLK ;            // AHB Clock
input           HRESETn;          // AHB Bus Reset signal - HCLK domain
input           HGRANTM;          // Request granted from Arbiter
input  [01:00]  HRESPM;           // AHB Master responsew for Slave
input           HREADYINM;        // Ready signal for AHB Master
input  [31:00]  HRDATAM;          // Read data bus for AHB Master

input           ClrLNBU;          // Clear operation signal from slave side
input  [29:00]  LCDUPBASE;        // Base Address from Slave
input  [29:00]  LCDLPBASE;        // Base Address from Slave
input           ClrAhbMasterErr;  // Signal to indicate error has been cleared 

input  [01:00]  UFWatermark;      // Request from Upper fifo to start asking
                                  //   for bus
input  [01:00]  LFWatermark;      // Request from Lower fifo to start asking 
                                  //   for bus
input           FrameRst;         // End   of Frame Indication
input           FrameStart;       // Start of Frame Indication
input           LFifoAck;         // Data Acknowledge signal from FIFO 
input           UFifoAck;         // Data Acknowledge signal from FIFO 

input           LcdDual;          // Signal to indicate  Dual or single panel

// Output ports
output          HWRITEM;          // Write or Read signal for Master
output [02:00]  HSIZEM;           // Size of the data transfer for AHB Master
output [02:00]  HBURSTM;          // Size of the burst for AHB Master
output [31:00]  HADDRM;           // Address bus for AHB Master
output [01:00]  HTRANSM;          // Transfer response signal for AHB Master
output          HBUSREQM;         // Request signal to the arbiter from master
output [03:00]  HPROTM;           // Protection signal output for user access
output          HLOCKM;           // Signal is driven low for non locking mode

output          UFDataValid;      // Data Ready signal  to upper fifo
output          LFDataValid;      // Data Ready signal  to lower fifo
output [31:00]  FifoWData;        // Fifo Write Data bus
output          FrameRstAck;      // Ack signal indicating frame start is accpt

output [29:00]  LCDLPCURR;        // Current Address status for Slave
output [29:00]  LCDUPCURR;        // Current Address status for Slave
output          AhbMError;        // Error status for Slave
output          LowerDmaFlag;     // Flag to indicate upper or lower panel fifo
output [4:0]    WordCount;        // Counter to hold the no of datavalid's  

output          LNBU;             // LNBU Status information output

// -----------------------------------------------------------------------------
// Overview
// ========
// This module contains
// - AHB Master Interface which generates the necessary control signal on
//   the bus
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Defines
// -----------------------------------------------------------------------------
`define ST_STRTFRAME 8'b0000_0001 // State Start of Frame
`define ST_STRTCYC   (|(LcdMasterState & 8'b0000_0001)) // Combinatorial Logic
`define ST_INIT      8'b0000_0010 // State Initial
`define ST_ADDRXFER  8'b0000_0100 // State Address Transfer
`define ADDRCYC      (|(LcdMasterState & 8'b0000_0100)) // Combinatorial Logic
`define ST_ACTIVE    8'b0000_1000 // State Active
`define ACTVCYC      (|(LcdMasterState & 8'b0000_1000)) // Combinatorial Logic
`define ST_RETRYST   8'b0001_0000 // State Retry
`define ST_ERROR     8'b0010_0000 // State Error
`define ST_FIFBUSY   8'b0100_0000 // State Fifo Busy
`define ST_TMPIDLE   8'b1000_0000 // State Temp Idle

`define Norequest    2'b00 // Fifo Watermark level
`define Burst4       2'b01 // Fifo Watermark level for a burst of 4 words
`define Burst8       2'b10 // Fifo Watermark level for a burst of 8 words
`define Burst16      2'b11 // Fifo Watermark level for a burst of 16 words

`define INCR4        3'b011 // 4 beat incrementing burst
`define INCR8        3'b101 // 8 beat incrementing burst
`define INCR16       3'b111 // 16 beat incrementing burst
`define UINCR        3'b001 // Incrementing burst of unspecified length

// ----------------------------------------------------------------------------
// Wire declaration
// ----------------------------------------------------------------------------
wire           HCLK ;
// AHB Clock                                           (Module Input)
 
wire           HRESETn;
// AHB Bus Reset signal - HCLK domain                  (Module Input)
 
wire           HGRANTM;
// Request granted from Arbiter                        (Module Input)
 
wire  [01:00]  HRESPM;
// AHB Master responsew for Slave                      (Module Input)
 
wire           HREADYINM;
// Ready signal for AHB Master                         (Module Input)
 
wire  [31:00]  HRDATAM;
// Read data bus for AHB Master                        (Module Input)
 
wire           ClrLNBU;
// Clear operation signal from slave side              (Module Input)
 
wire  [29:00]  LCDUPBASE;
// Base Address from Slave                             (Module Input)
 
wire  [29:00]  LCDLPBASE;
// Base Address from Slave                             (Module Input)
 
wire           ClrAhbMasterErr;
// Signal to indicate error has been cleared           (Module Input)
 
wire  [01:00]  UFWatermark;
// Request from Upper fifo to start asking for bus     (Module Input)
 
wire  [01:00]  LFWatermark;
// Request from Lower fifo to start asking for bus     (Module Input)
 
wire           FrameRst;
// End   of Frame Indication                           (Module Input)
 
wire           FrameStart;
// Start of Frame Indication                           (Module Input)
 
wire           LFifoAck;
// Data Acknowledge signal from FIFO                   (Module Input)
 
wire           UFifoAck;
// Data Acknowledge signal from FIFO                   (Module Input)
 
wire           LcdDual;
// Signal to indicate  Dual or single panel            (Module Input)
 
wire [03:00] HPROTM = 4'b0001;
// Protection signal output for user access            (Module Output)
 
wire         HLOCKM = 1'b0;
// Signal is driven low for non locking mode           (Module Output)
 
wire         HWRITEM = 1'b0;
// Write signal for AHB Bus 0 - indicates read         (Module Output)
 
wire [02:00] HSIZEM = 3'b010;
// Word size access output on the bus                  (Module Output)
 
wire [31:00]  HADDRM;
// Address which is put on the AHB Bus                 (Module Output)
 
wire          FrameRstAck ;
// Ack signal from master for FrameRst                 (Module Output)
  
 
//-----------------------------------------------------------------------------
// Register declaration
//-----------------------------------------------------------------------------

reg          AhbMError;
// AHB Master Error signal                             (Module Output)

reg  [29:00]  LCDLPCURR;
// Lower Panel Current Address Register                (Module Output)

reg  [29:00]  LCDUPCURR;
// Upper Panel Current Address Register                (Module Output)

reg  [02:00]  HBURSTM;
// AHB Burst information which is put on the bus       (Module Output)

reg  [01:00]  HTRANSM;
// Transfer response signal for AHB Master             (Module Output)

reg           HBUSREQM;
// Request signal to the arbiter from master           (Module Output)

reg           LFDataValid;
// Data Ready signal  to lower fifo                    (Module Output)

reg           UFDataValid;
// Data Ready signal  to upper fifo                    (Module Output)

reg  [31:00]  FifoWData;
// Fifo Write Data bus                                 (Module Output)

reg  [4:0]    WordCount;
// Counter which gives the number of datavalid         (Module Output)

reg           LNBU;
// LNBU Status information output                      (Module Output)

reg          NextAhbMError;
// D input of AHB Master Error reg 
 
reg  [29:00]  NextLCDLPCURR;
// Lower Panel Current Address Register input       

reg  [29:00]  NextLCDUPCURR;
// Upper Panel Current Address Register input      

reg  [02:00]  NextHBURSTM;
// D-input of AHB Burst flip flop
 
wire  [29:0]   NewPanelAddr;
// temporary register to hold 8 bit address
 
wire  [29:0]   WordIncr;
// temporary register to hold 8 bit address 
 
reg  [01:00]  NextHTRANSM;
// D-input of AHB HTRANSM flip flop
 
reg           NextHBUSREQM;
// D-input of AHB HBUSREQM flip flop
 
reg           NextLFDataValid;
// D-input of LFDataValid flip flop

reg           NextUFDataValid;
// D-input of UFDataValid flip flop

reg  [31:00]  NextFifoWData;
// D-input of FifoWData flip flop
 
reg  [07:00]  LcdMasterState;
// LCD Master state flip flop
 
reg  [07:00]  NextMasterState;
// D-input of LcdMasterState flip flop
 
reg  [04:00]  BeatCount;
// Counter to count the ongoing burst value
 
reg  [04:00]  NextBeatCount;
// D-input of BeatCount flip flop
 
reg  [04:00]  NumOfWords;
// Counter to hold the value of the burst requested from fifo
 
reg  [04:00]  NextNumOfWords;
// D-input of NumOfWords flip flop
 
reg  [29:00]  AhbAddr;
// Register to hold the upper 30 bit address
 
reg  [29:00]  NextAhbAddr;
// D-input of AhbAddr flip flop
 
reg  [04:00]  PrevNumOfWords;
// Register to hold the previous NumOfWords value
 
reg  [04:00]  NextPrevWords;
// D-input of PrevNumOfWords flip flop
 
reg           LowerDmaFlag;
// Flag to indicate the fifo panel
 
reg           NextLowerDmaFlag;
// D-input of LowerDmaFlag flip flop
 
reg           PrevLowPFlag;
// Register to hold the previous LowerDmaFlag
 
reg           NextPrevLowPFlag;
// D-input of PrevLowPFlag flip flop
 
reg           PrevLowPFlag2;
// Delayed version of PrevLowPFlag
 
reg           NextPrevPFlag2;
// D-input of PrevLowPFlag2 flip flop
 
reg           AckOccurred;
// Register to indicate the occurence of ack from fifo when not in active state
 
reg           NextAckOccurred;
// D-input of AckOccurred flip flop
 
reg  [4:0]    NextWordCount;
// D-input of WordCount flip flop

reg           NextLNBU;
// D-input of LNBU flip flop
 
//-----------------------------------------------------------------------------
//
// Main body of code
// =================
//
//-----------------------------------------------------------------------------

assign HADDRM    = {AhbAddr,2'b00};
assign FrameRstAck  = `ST_STRTCYC;
assign NewPanelAddr = StrtAdr(~LowerDmaFlag, LCDLPCURR, LCDUPCURR);
assign WordIncr = Incr30(AhbAddr);

// ----------------------------------------------------------------------------
// The Load Next Base Address Update Interrupt is generated here. The 
//  interrupt is generated whenever the Master State machine receives
//  FrameStart signal in ST_STRTFRAME state. The logic loads the base addresses
//  into the Current Address registers and Ahb Address counter/register
//  whenever Frame Start is received in the ST_STRTFRAME state.
//
// The flag is cleared by a Write operation to Interrupt Clear Register.
// ----------------------------------------------------------------------------

 always @ (LcdMasterState or ClrLNBU or FrameStart or LNBU) 
 begin : p_LNBUComb
     NextLNBU = LNBU;
     if (ClrLNBU) 
       NextLNBU = 1'b0;
     else if (`ST_STRTCYC && FrameStart) 
       NextLNBU = 1'b1;
 end // block: p_LNBUComb
  
// ----------------------------------------------------------------------------
// This function is provided to increment the 30 bit AHB Address (last two
//  bits are always zero), in terms of nibble counter. This function is 
//  provided so that the synthesis tool does not blow up the counter logic.
//  This function can be easily changed to suit any particular tool.
// ----------------------------------------------------------------------------

function [29:00] Incr30;  
input [29:00] Address; 
reg [29:00] Result; 
begin
  Result[29:04] = Address[29:04];
  Result[03:00] = Address[03:00] + 4'b0001;
  if (& Address[03:00]) 
    begin
      Result[07:04] = Address[07:04] + 4'b0001;
      if (& Address[07:04]) 
        begin
          Result[11:08] = Address[11:08] + 4'b0001;
          if (& Address[11:08]) 
            begin
              Result[15:12] = Address[15:12] + 4'b0001;
              if (& Address[15:12]) 
                begin
                  Result[19:16] = Address[19:16] + 4'b0001;
                  if (& Address[19:16]) 
                    begin
                      Result[23:20] = Address[23:20] + 4'b0001;
                      if (& Address[23:20])  
                        begin
                          Result[27:24] = Address[27:24] + 4'b0001;
                            if (& Address[27:24])
                              Result[29:28] = Address[29:28] + 2'b01;
                        end
                    end
                end
            end
        end
    end
       Incr30 = Result;
end
endfunction 


// ----------------------------------------------------------------------------
// The Function FifoAck is used to select between Upper or LowerFifoAck
// depending on the LowerPanelFlag. This is required for Dual Panel mode.
// ----------------------------------------------------------------------------

function FifoAck;
  input LowerPanelFlag;
  input LFifoAck;
  input UFifoAck;
  reg Result;
  begin
    Result = LowerPanelFlag ? LFifoAck : UFifoAck;
    FifoAck = Result;
  end
endfunction

// ----------------------------------------------------------------------------
// The Function DataValid is used to select between Upper or Lower Panel
// data valid generated by the AHB Master state machine depending upon the
// the LowerPanelFlag. This is required for Dual Panel mode.
// ----------------------------------------------------------------------------

function DataValid;
  input LowerPanelFlag;
  input LFDataValid;
  input UFDataValid;
  reg Result;
  begin
    Result = LowerPanelFlag ? LFDataValid : UFDataValid;
    DataValid = Result;
  end
endfunction

// ----------------------------------------------------------------------------
// The Function FifoWaterMark is used select between Upper Fifo or Lower Fifo
// depending on the LowerPanelFlag. This is required for Dual Panel Mode.
// ----------------------------------------------------------------------------

function [01:00] FifoWaterMark;
  input LowerPanelFlag;
  input [1:0] LFWatermark;
  input [1:0] UFWatermark;
  reg [01:00] Result;
  begin
    Result = LowerPanelFlag ? LFWatermark : UFWatermark;
    FifoWaterMark = Result;
  end
endfunction

// ----------------------------------------------------------------------------
// The Function StrtAddr outputs Next AHB master bus access Address to ouput.
// This selects between Increment of Lower Panel current address or Increment
// of Upper panel current address depending on the LowerPanelFlag. The current
// address registers always point to last data transfer address for that
// panel, hence the next address must be put as an Increment of the current
// address. This is required for Dual Panel Mode.
// ----------------------------------------------------------------------------

function [29:00] StrtAdr;
  input LowerPanelFlag;
  input [29:00] LCDLPCURR;
  input [29:00] LCDUPCURR;
  reg [29:00] Result;
  begin
    Result = LowerPanelFlag ? Incr30(LCDLPCURR) : Incr30(LCDUPCURR);
    StrtAdr = Result;
  end
endfunction

// ----------------------------------------------------------------------------
// The function below decides the Number of Words to be committed for a given
// Water Mark FIFO request.
// ----------------------------------------------------------------------------

function [4:0] StartNum;
  input [01:00] FifoWaterMark;
  reg [4:0] Result;
  begin
    Result = 5'b0;
    case (FifoWaterMark) 
      `Burst4    : Result = 5'b00100; 
      `Burst8    : Result = 5'b01000; 
      `Burst16   : Result = 5'b10000; 
      `Norequest : Result = 5'b0; 
      default    : Result = 5'b0;
    endcase
    StartNum = Result;
  end
endfunction

// ----------------------------------------------------------------------------
// The function OneKbChk is used to find out whether the address is in
// the 1KB Range at the start of data phase and it is used to find out whether
// the burst is about to cross the 1KB boundhary. Based on this information 
// the HBURST value and Beat Counter are loaded appropriately.
//
// This function is executed at the time of sampling the FIFO request in 
// terms of FifoWaterMark. This function basically decides depending on the
// acutal AHB Bus output address bits [9:2] what kind of Increment burst
// can be performed so that the 1KB boundary is not jumped over in a burst
// sequence.
// ----------------------------------------------------------------------------

function [7:0] OneKbChk;
  reg [2:0] HburstVal;
  reg [4:0] beatVal;
  input [1:0] FifoWaterMark;
  input [7:0] Address;
  begin
    beatVal = 5'b0;
    HburstVal = 3'b0;
    case (FifoWaterMark)
      `Burst4 : 
        begin
          beatVal = 5'b00100;
          if (& Address[7:2]) 
            begin
              if (| Address[1:0]) 
                HburstVal = `UINCR;
              else 
                HburstVal = `INCR4;
            end 
          else 
            HburstVal = `INCR4;
        end // case: `Burst4
      
      `Burst8 : 
        begin
          beatVal = 5'b01000;
          if (& Address[7:3]) 
            begin
              if (Address[2]) 
                begin
                  if (| Address[1:0]) 
                    HburstVal = `UINCR; 
                  else 
                    begin
                      HburstVal = `INCR4;
                      beatVal = 5'b00100;
                    end
                end // if (Address[2])
              else 
                begin
                  if(| Address[1:0]) 
                    begin
                      HburstVal  = `INCR4; 
                      beatVal = 5'b00100;
                    end
                  else 
                    HburstVal  = `INCR8;
                end // else: !if(Address[2])
            end // if (& Address[7:3])
          else 
            HburstVal    = `INCR8;
        end // case: `Burst8

      `Burst16 : 
        begin
          beatVal = 5'b10000;
          if (& Address[7:4]) 
            begin
              if (Address[3]) 
                begin
                  if (Address[2]) 
                    begin
                      if (| Address[1:0]) 
                        HburstVal = `UINCR; 
                      else 
                        begin
                          HburstVal = `INCR4;
                          beatVal = 5'b00100;
                        end
                    end // if (Address[2])
                  else 
                    begin
                      if (| Address[1:0]) 
                        begin
                          HburstVal    = `INCR4; 
                          beatVal = 5'b00100;
                        end // if (| Address[1:0])
                      else 
                        begin
                          HburstVal = `INCR8;
                          beatVal = 5'b01000;
                        end 
                    end
                end // if (Address[3])
              else 
                begin
                  if (| Address[2:0]) 
                    begin
                      HburstVal = `INCR8; 
                      beatVal = 5'b01000;
                    end // if (| Address[2:0])
                  else 
                    HburstVal = `INCR16;
                end 
            end // if (& Address[7:4])
          else 
            HburstVal = `INCR16;
        end // case: `Burst16

      `Norequest : 
        begin
          HburstVal  = 3'b0;
          beatVal = 5'b0;    
        end // case: `Norequest

      default    : 
        begin
          HburstVal  = 3'b0;
          beatVal = 5'b0;    
        end // case: default
      
    endcase // case(FifoWaterMark)
    
    OneKbChk = {beatVal,HburstVal};
  end
endfunction // OneKbChk

// ----------------------------------------------------------------------------
// This function is invoked at the end of every burst in case the committed
// amount of data has not yet been fetched completely. This function decides
// the HBURST and Beat Count values for the next burst, depending upon the
// outstanding number of words.
// ----------------------------------------------------------------------------

function [7:0] NewBurstRetry ;
  input [4:0] NumOfWords;
  input [7:0] Address;
  reg [2:0] HburstVal;
  reg [4:0] beatVal;
  begin
    HburstVal = `UINCR;
    beatVal = NumOfWords;
    case (NumOfWords)
      5'b01000,5'b01001,5'b01010,5'b01011,5'b01100,5'b01101,5'b01110,5'b01111 :
        begin
          if (&Address[7:3]) 
            begin
              if (Address[2]) 
                HburstVal = `UINCR;
              else
                begin
                  HburstVal = `INCR4;
                  //BNT
                  beatVal   = 5'b00100;
                  //BNT
                end // else: !if(Address[2])
            end // if (&Address[7:3])
          else
            begin
              HburstVal = `INCR8;
              //BNT
              beatVal = 5'b01000;
            end 
        end // case: 5'b01000,5'b01001,...

      5'b00100,5'b00101,5'b00110,5'b00111 :
        begin
          if (&Address[7:2] && |Address[1:0])
            HburstVal = `UINCR;
          else
            begin
              HburstVal = `INCR4;
              //BNT
              beatVal = 5'b01000;
              //BNT
            end // else: !if(&Address[7:2] && |Address[1:0])
        end // case: 5'b00100,5'b00101,5'b00110,5'b00111

      default : ;

    endcase // case(NumOfWords)
    NewBurstRetry = {beatVal,HburstVal};
  end
endfunction // NewBurstRetry

// -----------------------------------------------------------------------------
//   A H B     M A S T E R    I N T E R F A C E    S T A T E   M A C H I N E 
// -----------------------------------------------------------------------------
// ----------------------------------------------------------------------------
// This main state machine controls all the data transfers,pipelining of
// addresses ,error state , fifobusy state,and retry conditions.
// The state machine consists of following states
//
// ST_STRTFRAME --> 
//          This state is the starting state. SM moves from this state to
//          the ST_INIT state on receiving the start of frame signal. The 
//          Next Base Address update occurs when the state machine transitions
//          from this to the ST_INIT state. The Lower Current Address is 
//          deliberately loaded with a value one less than the Base address
//          programmed. This is done because in Dual Panel Mode the State
//          machine switches to Lower Panel image DMA after a committed
//          number of words are transferred in the Upper panel DMA FIFO.
//          Now when the state machine switches to the new address in the
//          ST_ACTIVE state it always loads the Increment of current address
//          rather than the current address itself because the current
//          address points to last location accessed. Hence had this
//          deliberate decrement of the base address not done in this 
//          state then when the State Machine would have put increment
//          of the base address programmed when it switching to the Lower
//          Panel FIFO DMA for the first time after a Frame Start had 
//          been received.
//
//          The consequence of this is that the Lower Current Address
//          register in the Slave register map would read one less than
//          the Lower Base address for a very brief duration immediately
//          after new frame starts.
//          
// ST_INIT --> 
//          The Fifo Water Mark (also referred as FIFO request) is sampled
//          in this state. If the FIFO is requesting for the data the
//          BUS request is asserted right away. The transfer starts when 
//          the BUS grant is sampled asserted. Here check is also done for
//          feasibility of doing fixed increment transfers depending upon
//          the Address CrossOver of 1 KByte boundary and FifoWaterMark
//          level. The State Machine moves to Address Transfer State 
//          (ST_ADDRXFER) once the HTRANS are put as Non-Sequential.
//
// ST_ADDRXFER --> 
//          This state is used for pipelining the address for next cycle.
//          The HTRANS put while in this state always indicate a data
//          transfer (i.e. HTRANS are always Nseq or Seq for this state).
//          Hence The Next State after this one is always the ST_ACTIVE state.
//          Quite a bit of logic is common to this and ST_ACTIVE state. And
//          the logic may alternate between this and the ST_ACTIVE state
//          a comitted amout of transfer. A CrossOver of 1KByte range is
//          also checked in this state. The next access is pipelined so
//          that either a new burst is piplined or the next transfer of
//          same burst is piplined.
//          
//          The detection of new burst is as follows :
//
//          -- AHB 32 bit Address Output bits 9:2 are all 1's indicating
//             1KB boundary cross over.
//          -- Beat Count for current burst becomes = 1 indicating that
//             current transfer is last being pipelined for the current
//             ongoing burst.
//
// ST_ACTIVE --> 
//          In this state valid data transfer takes place. After every
//          HREADY received with an OKAY response, the data valid for
//          that particular panel FIFO is asserted. And unless the FIFO
//          comes back with an acknowledge the new cycle is not started
//          rather the State Machine continues to put BUSY cycles. Whenever
//          the HREADY is expected for a busy cycle the statemachine
//          moves to FIFO BUSY (ST_FIFBUSY) state. The state machine comes
//          back to this state from the BUSY state only through the
//          ST_ADDRXFER state. In fact the state machine always comes to the
//          ST_ACTIVE state after ST_ADDRXFER state only.
//          
//          In this state the HTRANS are changed for new burst only if
//          -- AHB 32 bit Address Output bits 9:2 are all 1's indicating
//             1KB boundary cross over.
//          -- Beat Count for current burst becomes = 1 indicating that
//             current transfer is last being pipelined for the current
//             ongoing burst, but given that the Number of Words committed
//             for transfer are greater than 1.
//          -- The HTRAN put for the previous cycle was IDLE, this may
//             occur because of momentary loss of Bus Grant or the FIFO 
//             did not acknowledge the last transfer which was the ultimate
//             transfer of last burst.
//        
//          When in this state the Number of Words committed for previous
//          Fifo Request become equal to 1 and the HTRANS are put for
//          a valid data transfer value (NSeq or Seq), indicating that the
//          last of committed Number of Words is being piped onto the AHB
//          bus, the Statemachine again samples the Fifo Request (Fifo
//          Water Mark level) and it may reinitiate the new committed 
//          transfer if FIFO continues to request for more data at this
//          instant of sampling. For Dual Panel Mode at this instant of
//          sampling the Fifo Request the State machine selects the other
//          panel than the current one. The flag LowerPanelFlag is toggeled
//          at every such instant. If the sampled Fifo Water Mark does not
//          indicate any request for data transfer the state machine goes
//          to ST_INIT state where it waits for the Fifo Water Mark level to
//          go active.
//
//          While in this state if the response is received as ERROR then
//          the statemachine locks to ST_ERROR and generates the 
//          "AHB Master Bus Error" interrupt. 
//
//          While in this state if the response is received as RETRY then
//          The state machine goes to ST_RETRYST state with restoring the 
//          retried cycle's address and control parameters and HTRANS as
//          IDLE. 
//
//          While in this state if a BUSY or IDLE cycle is piped onto the
//          bus just for one clock (either due to Fifo Ack received a clock
//          later or the Bus Grant goes off for just one bus cycle), the
//          state machine goes to ST_ADDRXFER state before coming back to the
//          ST_ACTIVE state.
//
//          While in this state if the grant goes off for more than 2 bus
//          cycles the state machine goes to ST_TMPIDLE a temporary state for
//          bus idling.
//            
//          While in this state if End Of Frame is received the state
//          machine goes back to ST_STRTFRAME state at the end of current bus
//          cycle.
//          
// ST_RETRYST --> 
//          In this state the state machine goes to the ST_ADDRXFER state with
//          HTRANS as Non-Sequential and HGRANT is active. The New burst
//          is started because it has put an IDLE cycle while coming back
//          from the ST_ACTIVE state. If the grant is not available the state
//          machine moves to TEMPIDLE state.
//
// ST_ERROR -->
//          The state machine sits in this state unless the software does
//          a "Clear AHB Master Error Interrupt" opertion. After which the
//          state machine goes to ST_STRTFRAME state.
//
// ST_TMPIDLE -->
//          The state machine continues to be in this state as long as
//          the Bus Grant is not available or Frame End does not occur.
//          If grant is received the state machine goes to ST_ADDRXFER state
//          with Non-sequential cycle piped onto the bus and recalculating
//          the parameters for the new burst going to be started, provided
//          the FIFO has acknowledged the previous data transfer, otherwise
//          the state machine goes to FIFO BUSY state.
//
//          On receiving the Frame End in this state the state machine
//          moves to ST_STRTFRAME state.
//
// ST_FIFBUSY -->
//          The state machine continues to be in this state unless an
//          acknowledge is received for the previous data transfer from
//          the FIFO. After which if the grant is available the state
//          machine goes to ST_ADDRXFER state with generally sequential cucle
//          piped on to the bus. If the grant is not available the state
//          machine goes to ST_TMPIDLE state.
//            
// ----------------------------------------------------------------------------

always@(LcdMasterState or LFDataValid or UFDataValid or FifoWData or
        LCDLPCURR or LCDUPCURR or HBUSREQM or HTRANSM or BeatCount or
        HBURSTM or AhbAddr or LowerDmaFlag or NumOfWords or 
        PrevNumOfWords or PrevLowPFlag or PrevLowPFlag2 or AckOccurred or 
        FrameStart or LCDLPBASE or LCDUPBASE or LFifoAck or UFifoAck or 
        HREADYINM or HGRANTM or FrameRst or HRESPM or LcdDual or UFWatermark or
        ClrAhbMasterErr or HRDATAM or LFWatermark or WordCount or
        AhbMError or NewPanelAddr or WordIncr) 
begin : p_AhbMStateComb
    
  NextMasterState   = LcdMasterState;
  NextLFDataValid   = LFDataValid;
  NextUFDataValid   = UFDataValid;
  NextFifoWData     = FifoWData;
  NextLCDLPCURR     = LCDLPCURR;
  NextLCDUPCURR     = LCDUPCURR;
  NextHBUSREQM      = HBUSREQM;     
  NextHTRANSM       = HTRANSM;     
  NextBeatCount     = BeatCount; 
  NextHBURSTM       = HBURSTM;  
  NextAhbAddr       = AhbAddr; 
  NextLowerDmaFlag  = LowerDmaFlag; 
  NextNumOfWords    = NumOfWords; 
  NextPrevWords     = PrevNumOfWords;
  NextPrevLowPFlag  = PrevLowPFlag;
  NextPrevPFlag2    = PrevLowPFlag2;
  NextAckOccurred   = AckOccurred; 
  NextWordCount     = WordCount; 
  NextAhbMError     = AhbMError;

  case (LcdMasterState)
    `ST_STRTFRAME : 
      begin
        if (FrameStart) 
          begin
            NextMasterState    = `ST_INIT;
                           // The Lower Current Address is deliberately
                           // initialized with a value one less than the
                           // Lower Base address. This is done because the
                           // ST_ACTIVE state does not need to invest in more
                           // logic if it wants to start the Lower Panel
                           // DMA for the first time after a frame start
                           // has occurred. Otherwise in the Active State we
                           // would be needing to load from the Lower base
                           // address register as well.
            NextLCDLPCURR     = LCDLPBASE - 30'h0000001;
                           // This subtraction is not needed for the upper
                           // current address because the Upper Panel DMA
                           // always starts immediately after passing through
                           // this ST_STRTFRAME state.
            NextLCDUPCURR     = LCDUPBASE;
            NextLowerDmaFlag  = 1'b0;
            NextBeatCount     = 5'b00000;
            NextNumOfWords    = 5'b00000;
            NextHTRANSM       = `IDLE;
            NextLFDataValid   = 1'b0;
            NextUFDataValid   = 1'b0;
            NextFifoWData     = 32'h00000000;
            NextHBURSTM       = `INCR4;
            NextAhbAddr       = LCDUPBASE;
            NextPrevWords     = 5'b00000;
            NextPrevLowPFlag  = 1'b0;
            NextPrevPFlag2    = 1'b0;
            NextAckOccurred   = 1'b0;
            NextAhbMError     = 1'b0;
          end // if (FrameStart)
        else 
          begin
            NextMasterState    = `ST_STRTFRAME; 
            NextLFDataValid    = 1'b0;
            NextUFDataValid    = 1'b0;
            NextFifoWData      = 32'h00000000;
            NextLCDLPCURR      = 30'b0;
            NextLCDUPCURR      = 30'b0;
            NextHTRANSM        = `IDLE;
            NextBeatCount      = 5'b00000;
            NextHBURSTM        = `INCR4;
            NextAhbAddr        = 30'b0;
            NextLowerDmaFlag   = 1'b0;
            NextNumOfWords     = 5'b0;
            NextPrevWords      = 5'b0;
            NextPrevLowPFlag   = 1'b0;
            NextPrevPFlag2     = 1'b0;
            NextAckOccurred    = 1'b0;
          end
      end // case: `ST_STRTFRAME

    `ST_INIT : 
      begin
        NextAckOccurred = 1'b0;
        if (!FrameRst || HBUSREQM) 
          begin
            NextHBUSREQM  = (| FifoWaterMark(LowerDmaFlag,
                                                    LFWatermark, UFWatermark));
            if (| FifoWaterMark(LowerDmaFlag, LFWatermark, UFWatermark)) 
              begin
                if (FifoAck(PrevLowPFlag, LFifoAck, UFifoAck) ||
                    (!DataValid(PrevLowPFlag, LFDataValid, UFDataValid)))
                  NextHBUSREQM  = (| FifoWaterMark(LowerDmaFlag,
                                                    LFWatermark, UFWatermark));
                {NextBeatCount,NextHBURSTM} =
                                  OneKbChk(FifoWaterMark(LowerDmaFlag,
                                                   LFWatermark, UFWatermark),
                                                                 AhbAddr[7:0]);
                NextNumOfWords = StartNum(FifoWaterMark(LowerDmaFlag,
                                                    LFWatermark, UFWatermark));
                NextWordCount = StartNum(FifoWaterMark(LowerDmaFlag,
                                                    LFWatermark, UFWatermark));
              end 
            if (LFifoAck)
              NextLFDataValid = 1'b0;
            if (UFifoAck)
              NextUFDataValid = 1'b0;
            if (HREADYINM) 
              begin
                if (HGRANTM) 
                  begin
                   if (!DataValid(PrevLowPFlag, LFDataValid, UFDataValid)) 
                     begin
                       if ((FrameRst && HBUSREQM) || (!FrameRst)) 
                         begin
                           if (| FifoWaterMark(LowerDmaFlag, 
                                            LFWatermark, UFWatermark)) 
                             begin
                               NextMasterState    = `ST_ADDRXFER;
                               NextHTRANSM        = `NSEQ;
                             end // if (| FifoWaterMark(LowerDmaFlag,...
                           else 
                             begin
                               NextHTRANSM        = `IDLE;
                               if (FrameRst)
                                 begin
                                   NextMasterState    = `ST_STRTFRAME;
                                   NextHBUSREQM       = 1'b0;
                                 end // if (FrameRst)
                               else
                                 NextMasterState  = `ST_INIT;
                             end // else: !if(| FifoWaterMark(LowerDmaFlag,...
                         end // if ((FrameRst && HBUSREQM)|| (!FrameRst))
                     end // if (!DataValid(PrevLowPFlag, LFDataValid,...
                  end // if (HGRANTM)
              end // if (HREADYINM)
          end // if (!FrameRst || HBUSREQM)
        else 
          begin
            NextHTRANSM        = `IDLE;
            if (FrameRst)
              NextMasterState = `ST_STRTFRAME;
            else
              NextMasterState = `ST_INIT;
          end
      end // case: `ST_INIT

    `ST_ACTIVE, `ST_ADDRXFER : 
      begin
        if (((HRESPM == `RETRY) || (HRESPM == `SPLIT)) && `ACTVCYC) 
          begin
            NextMasterState    = `ST_RETRYST;
            NextHTRANSM        = `IDLE;
            NextHBUSREQM       = 1'b1;
            NextAhbAddr        = PrevLowPFlag ? LCDLPCURR : LCDUPCURR;
            NextHBURSTM        = `INCR4;
            NextNumOfWords     = PrevNumOfWords;
            NextLowerDmaFlag   = PrevLowPFlag;
            if (LFifoAck)
               NextLFDataValid  = 1'b0;
            if (UFifoAck)
              NextUFDataValid  = 1'b0;
            if (FifoAck(PrevLowPFlag2, LFifoAck, UFifoAck))
              NextAckOccurred  = 1'b1;
          end // if (((HRESPM == `RETRY) || (HRESPM == `SPLIT)) && `ACTVCYC)
        
        if ((HRESPM == `ERRR) && `ACTVCYC) 
          begin
            NextMasterState    = `ST_ERROR; 
            NextHBUSREQM       = 1'b0;
            NextAhbMError      = 1'b1;
            NextHTRANSM        = `IDLE;
            NextFifoWData      = 32'b0;
            NextLFDataValid    = 1'b0;
            NextUFDataValid    = 1'b0;
            NextNumOfWords     = 5'b0;
          end // if ((HRESPM == `ERRR) && `ACTVCYC)
        
        if (((HRESPM == `OKAY) && `ACTVCYC) || `ADDRCYC) 
          begin
            if (HREADYINM) 
              begin
                if (`ACTVCYC) 
                  begin
                    NextFifoWData    = HRDATAM ;
                    if (WordCount != 5'b00000)
                      NextWordCount  = WordCount - 5'b00001;
                    else
                      NextWordCount = StartNum(FifoWaterMark(LowerDmaFlag, 
                                      LFWatermark, UFWatermark)) - 5'b00001;
                    
                    if (PrevLowPFlag) 
                      begin
                        NextLFDataValid     = 1'b1;
                        NextUFDataValid     = 1'b0;
                      end // if (PrevLowPFlag)
                    else 
                      begin
                        NextLFDataValid     = 1'b0;
                        NextUFDataValid     = 1'b1;
                      end // else: !if(PrevLowPFlag)
                  end // if (`ACTVCYC)
                else 
                  begin
                    NextLFDataValid     = 1'b0;
                    NextUFDataValid     = 1'b0;
                  end // else: !if(`ACTVCYC)
                
                if ((HTRANSM == `SEQ) || (HTRANSM == `NSEQ)) 
                  begin
                    if (LowerDmaFlag)
                      NextLCDLPCURR = AhbAddr;
                    else
                      NextLCDUPCURR = AhbAddr;
                    NextPrevWords     = NumOfWords;
                    NextPrevLowPFlag  = LowerDmaFlag;
                    NextPrevPFlag2    = PrevLowPFlag;
                  end // if ( (HTRANSM ==  `SEQ) || (HTRANSM == `NSEQ))
                
                if (HGRANTM ) 
                  begin
                    if (!((PrevNumOfWords == 5'b00001) && 
                                    FifoAck(PrevLowPFlag, LFifoAck, UFifoAck)
                                              && FrameRst && !HBUSREQM)) 
                      begin
                        if (NumOfWords != 5'b00001) 
                          begin
                            if (| NumOfWords) 
                              begin
                                if ((& AhbAddr[7:0]) || (HTRANSM == `IDLE) ||
                                    (BeatCount == 5'b00001) ) 
                                  begin
                                    if (FifoAck(PrevLowPFlag, LFifoAck,
                                               UFifoAck) || AckOccurred) 
                                      begin
                                        NextHTRANSM     = `NSEQ;
                                        NextAckOccurred = 1'b0; 
                                      end 
                                    else
                                      NextHTRANSM  = `IDLE;
                                  end 
                                else 
                                  begin
                                    if (FifoAck(PrevLowPFlag, LFifoAck, 
                                        UFifoAck) || AckOccurred) 
                                      begin
                                        NextHTRANSM     = `SEQ;
                                        NextAckOccurred = 1'b0;
                                      end 
                                    else
                                      NextHTRANSM  = `BUSY;
                                  end 
                              end // if (| NumOfWords)
                            else 
                              begin
                                NextHTRANSM   = `IDLE;
                                NextHBUSREQM  = 1'b0;
                              end
                          end // if (NumOfWords != 5'b00001)
                        else 
                          begin
                            if ((HTRANSM == `SEQ) || (HTRANSM == `NSEQ)) 
                              begin
                                if (|(FifoWaterMark(~LowerDmaFlag & LcdDual,
                                                    LFWatermark, UFWatermark))) 
                                  begin
                                    NextHBUSREQM  = 1'b1;
                                    if (FifoAck(LowerDmaFlag, LFifoAck, 
                                                UFifoAck) || AckOccurred) 
                                      begin
                                        NextHTRANSM     = `NSEQ;
                                        NextAckOccurred = 1'b0;
                                      end 
                                    else
                                      NextHTRANSM  = `IDLE;
                                  end
                                else 
                                  begin
                                    NextHBUSREQM = 1'b0;
                                    NextHTRANSM  = `IDLE;
                                  end 
                              end 
                            else 
                              begin
                               if ((& AhbAddr[7:0]) || (HTRANSM == `IDLE))
                                 if (HTRANSM == `IDLE) 
                                   begin
                                     NextHTRANSM     = `NSEQ;
                                     NextAckOccurred = 1'b0;
                                   end // if (HTRANSM == `IDLE)
                                 else if ((FifoAck(LowerDmaFlag, LFifoAck, 
                                          UFifoAck) || AckOccurred) && 
                                          `ACTVCYC)
                                   begin
                                     NextHTRANSM     = `SEQ;
                                     NextAckOccurred = 1'b0;
                                   end 
                                 else
                                   NextHTRANSM = `IDLE;
                               else 
                                 begin
                                   if (FifoAck(LowerDmaFlag, LFifoAck, 
                                       UFifoAck) || AckOccurred) 
                                     begin
                                       NextHTRANSM     = `SEQ;
                                       NextAckOccurred = 1'b0;
                                     end 
                                   else
                                     NextHTRANSM = `BUSY;
                                 end 
                              end 
                          end 
                      end // if (!((PrevNumOfWords == 5'b00001) &&...
                    else 
                      begin
                        NextHTRANSM = `IDLE;
                        if (FifoAck(PrevLowPFlag, LFifoAck, UFifoAck))
                          NextAckOccurred = 1'b1;
                      end // else: !if(!((PrevNumOfWords == 5'b00001) &&...
                  end // if (HGRANTM )
                else 
                  begin
                    NextHTRANSM = `IDLE;
                    if (FifoAck(PrevLowPFlag, LFifoAck, UFifoAck))
                      NextAckOccurred = 1'b1;
                  end // else: !if(HGRANTM )
                if (NumOfWords != 5'b00001) 
                  begin
                    if (| NumOfWords) 
                      begin
                        if ((HTRANSM == `SEQ) || (HTRANSM == `NSEQ)) 
                          begin
                            NextAhbAddr    = Incr30(AhbAddr);
                            NextNumOfWords = NumOfWords - 5'b00001;
                            if (BeatCount == 5'b00001)
                              {NextBeatCount,NextHBURSTM} = NewBurstRetry(
                                                    (NumOfWords - 5'b00001),
                                                    (AhbAddr[7:0] + 8'h01));
                            else
                              NextBeatCount  = BeatCount - 5'b00001;
                          end // if ((HTRANSM == `SEQ) || (HTRANSM == `NSEQ))
                        else if ((& AhbAddr[7:0]) || (HTRANSM == `IDLE) ||
                                 (BeatCount == 5'b00001) )
                          {NextBeatCount,NextHBURSTM} = NewBurstRetry(
                                                      NumOfWords, AhbAddr[7:0]);
                      end // if (| NumOfWords)
                  end // if (NumOfWords != 5'b00001)
                else 
                  begin
                    if ((HTRANSM == `SEQ) || (HTRANSM == `NSEQ)) 
                      begin
                        if (LcdDual) 
                          begin
                            NextLowerDmaFlag = ~LowerDmaFlag;
                            NextAhbAddr = StrtAdr(~LowerDmaFlag, LCDLPCURR, 
                                                  LCDUPCURR);
                            if (| FifoWaterMark(~LowerDmaFlag, LFWatermark, 
                                                UFWatermark)) 
                              begin
                                {NextBeatCount, NextHBURSTM} = OneKbChk(
                                     FifoWaterMark(~LowerDmaFlag, LFWatermark,
                                            UFWatermark), NewPanelAddr[7:0] );
                                NextNumOfWords = StartNum(FifoWaterMark(
                                                      ~LowerDmaFlag,
                                                       LFWatermark,
                                                       UFWatermark));
                              end 
                            else 
                              begin
                                NextBeatCount = 5'b00000;
                                NextNumOfWords = 5'b0;
                              end 
                          end // if (LcdDual)
                        else 
                          begin
                            NextLowerDmaFlag = 1'b0;
                            NextAhbAddr      = Incr30(AhbAddr);
                            if (| UFWatermark) 
                              begin
                                {NextBeatCount, NextHBURSTM} = 
                                                 OneKbChk( UFWatermark,
                                                               WordIncr[7:0]);
                               NextNumOfWords = StartNum(UFWatermark);
                              end // if (| UFWatermark)
                            else 
                              begin
                                NextBeatCount  = 5'b0;
                                NextNumOfWords = 5'b0;
                              end 
                          end // else: !if(LcdDual)
                      end // if ((HTRANSM == `SEQ) || (HTRANSM == `NSEQ))
                  end // else: !if(NumOfWords != 5'b00001)
                case (HTRANSM)
                  `NSEQ, `SEQ : 
                    NextMasterState = `ST_ACTIVE;

                  `BUSY :
                    if ((FifoAck(PrevLowPFlag, LFifoAck, UFifoAck) ||
                         AckOccurred) && HGRANTM)
                      NextMasterState = `ST_ADDRXFER;
                    else
                      NextMasterState = `ST_FIFBUSY;

                  `IDLE :
                    if ((FrameRst) && (NumOfWords == 5'b00000))
                      NextMasterState = `ST_STRTFRAME;
                    else if (NumOfWords == 5'b00000)
                      NextMasterState = `ST_INIT;
                    else if ((FifoAck(PrevLowPFlag, LFifoAck, UFifoAck) ||
                                      AckOccurred) && HGRANTM)
                      NextMasterState = `ST_ADDRXFER;
                    else
                      NextMasterState = `ST_TMPIDLE;

                  default : ;

                endcase // case(HTRANSM)
              end // if (HREADYINM)
            else
              begin
                if (FifoAck(PrevLowPFlag,LFifoAck, UFifoAck))
                  NextAckOccurred   = 1'b1;
                if (LFifoAck) 
                  NextLFDataValid = 1'b0;
                if (UFifoAck) 
                  NextUFDataValid = 1'b0;
              end // else: !if(HREADYINM)
          end // if (((HRESPM == `OKAY) && `ACTVCYC) || `ADDRCYC)
      end // case: `ST_ACTIVE, `ST_ADDRXFER

    `ST_TMPIDLE : 
      begin
        if (LFifoAck)
          NextLFDataValid = 1'b0;
        if (UFifoAck)
          NextUFDataValid = 1'b0;
        if (HREADYINM) 
          begin
            if (HGRANTM) 
              begin
                if (FifoAck(PrevLowPFlag, LFifoAck, UFifoAck) || AckOccurred)
                  begin
                    NextHTRANSM     = `NSEQ;
                    NextAckOccurred = 1'b0;
                    NextMasterState = `ST_ADDRXFER;
                    {NextBeatCount,NextHBURSTM} = NewBurstRetry(NumOfWords,
                                                                AhbAddr[7:0]);
                  end 
              end // if (HGRANTM)
            else
              begin
                NextHTRANSM = `IDLE;
                if (FifoAck(PrevLowPFlag, LFifoAck, UFifoAck))
                  NextAckOccurred = 1'b1;
              end // else: !if(HGRANTM)
          end // if (HREADYINM)
        else if (FifoAck(PrevLowPFlag, LFifoAck, UFifoAck))
          NextAckOccurred = 1'b1;
      end // case: `ST_TMPIDLE

    `ST_RETRYST : 
      begin
        if (LFifoAck)
          NextLFDataValid = 1'b0;
        if (UFifoAck) 
          NextUFDataValid = 1'b0;
        if (HREADYINM)
          begin
            if (HGRANTM) 
              begin
                if (FifoAck(PrevLowPFlag, LFifoAck, UFifoAck) || AckOccurred)
                  begin
                    NextHTRANSM        = `NSEQ;
                    NextMasterState = `ST_ADDRXFER;
                    NextAckOccurred    = 1'b0;
                    {NextBeatCount,NextHBURSTM} = NewBurstRetry(NumOfWords,
                                                                AhbAddr[7:0]);
                  end 
                else
                  if (!DataValid (PrevLowPFlag, LFDataValid, UFDataValid))
                    begin
                      NextHTRANSM                 = `NSEQ;
                      NextMasterState             = `ST_ADDRXFER;
                      {NextBeatCount,NextHBURSTM} = NewBurstRetry(NumOfWords,
                                                                  AhbAddr[7:0]);
                    end 
              end // if (HGRANTM)
            else
              begin
                NextHTRANSM        = `IDLE;
                if (FifoAck(PrevLowPFlag, LFifoAck, UFifoAck))
                  NextAckOccurred = 1'b1;
              end 
          end // if (HREADYINM)
        else if (FifoAck(PrevLowPFlag, LFifoAck, UFifoAck))
          NextAckOccurred = 1'b1;
      end // case: `ST_RETRYST

    `ST_ERROR : 
      begin
        NextHTRANSM   = `IDLE;
        NextHBUSREQM  = 1'b0; 
        if (ClrAhbMasterErr) 
          NextAhbMError = 1'b0;
        if (AhbMError == 1'b0 )
          NextMasterState = `ST_STRTFRAME;
      end // case: `ST_ERROR

    `ST_FIFBUSY : 
      begin
        if (LFifoAck)
          NextLFDataValid = 1'b0;
        if (UFifoAck) 
          NextUFDataValid = 1'b0;
        if (HREADYINM) 
          begin
            if (HGRANTM)
              begin
                if (FifoAck(PrevLowPFlag, LFifoAck, UFifoAck))
                  begin
                    NextMasterState = `ST_ADDRXFER;
                    if (NumOfWords == 5'b00001) NextHBUSREQM = 1'b0;
                      NextAckOccurred = 1'b0;
                    if ((& AhbAddr[7:0]) || (HTRANSM == `IDLE))
                      begin
                        NextHTRANSM = `NSEQ;
                        {NextBeatCount,NextHBURSTM} = NewBurstRetry(
                                                               NumOfWords,
                                                               AhbAddr[7:0]);
                      end // if ((& AhbAddr[7:0]) || (HTRANSM == `IDLE))
                    else
                      NextHTRANSM = `SEQ ;
                  end // if (FifoAck(PrevLowPFlag, LFifoAck, UFifoAck))
              end // if (HGRANTM)
            else
              begin
                NextHTRANSM = `IDLE;
                NextMasterState = `ST_TMPIDLE;
                if (FifoAck(PrevLowPFlag, LFifoAck, UFifoAck))
                  NextAckOccurred = 1'b1;
              end 
          end // if (HREADYINM)
        
                       // else not present because HREADY response for
                       //  BUSY cycles is without any wait states.
      end // case: `ST_FIFBUSY

    default : 
      begin
        NextMasterState    = `ST_STRTFRAME; 
        NextFifoWData      = 32'h00000000;
        NextHBUSREQM       = 1'b0;  
        NextHTRANSM        = `IDLE;
        NextNumOfWords     = 5'b00000;
        NextBeatCount      = 5'b00000;
        NextHBURSTM        = `INCR4;
        NextAhbAddr        = 30'h00000000;
        NextLFDataValid    = 1'b0;
        NextUFDataValid    = 1'b0;
        NextLowerDmaFlag   = 1'b0;
        NextAckOccurred    = 1'b0;
        NextAhbMError      = 1'b0;
      end // case: default
  endcase // case(LcdMasterState)
end // block: p_AhbMStateComb
  
// ----------------------------------------------------------------------------
// Registering all the next state signals
// ----------------------------------------------------------------------------
always @ (posedge HCLK or negedge HRESETn) 
begin : p_AhbMStateSeq
  if (!HRESETn) 
    begin
      LcdMasterState <= `ST_STRTFRAME; 
      LFDataValid    <= 1'b0;
      UFDataValid    <= 1'b0;
      FifoWData      <= 32'b0;
      LCDLPCURR      <= 30'b0;
      LCDUPCURR      <= 30'b0;
      HBUSREQM       <= 1'b0;  
      HTRANSM        <= `IDLE;
      BeatCount      <= 5'b0;
      HBURSTM        <= `INCR4;
      AhbAddr        <= 30'b0;
      LowerDmaFlag   <= 1'b0;
      NumOfWords     <= 5'b0;
      PrevNumOfWords <= 5'b0;
      PrevLowPFlag   <= 1'b0;
      PrevLowPFlag2  <= 1'b0;
      AckOccurred    <= 1'b0;
      LNBU           <= 1'b0;
      WordCount      <= 5'b0;
      AhbMError      <= 1'b0;
    end // if (!HRESETn)
  else
    begin
      LcdMasterState <= NextMasterState;
      LFDataValid    <= NextLFDataValid;   
      UFDataValid    <= NextUFDataValid;  
      FifoWData      <= NextFifoWData ;
      LCDLPCURR      <= NextLCDLPCURR;
      LCDUPCURR      <= NextLCDUPCURR;
      HBUSREQM       <= NextHBUSREQM;     
      HTRANSM        <= NextHTRANSM;     
      BeatCount      <= NextBeatCount; 
      HBURSTM        <= NextHBURSTM;  
      AhbAddr        <= NextAhbAddr; 
      LowerDmaFlag   <= NextLowerDmaFlag; 
      NumOfWords     <= NextNumOfWords; 
      PrevNumOfWords <= NextPrevWords;
      PrevLowPFlag   <= NextPrevLowPFlag;
      PrevLowPFlag2  <= NextPrevPFlag2;
      AckOccurred    <= NextAckOccurred; 
      LNBU           <= NextLNBU;
      WordCount      <= NextWordCount;
      AhbMError      <= NextAhbMError;
    end // else: !if(!HRESETn)
end // block: p_AhbMStateSeq
  
endmodule 
// --=========================================================================--
