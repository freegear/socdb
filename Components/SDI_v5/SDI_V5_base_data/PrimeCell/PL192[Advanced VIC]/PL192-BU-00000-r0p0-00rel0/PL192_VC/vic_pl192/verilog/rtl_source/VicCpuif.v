// --=========================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from ARM Limited
//   (C) COPYRIGHT 2002 ARM Limited
//       ALL RIGHTS RESERVED
// The entire notice above must be reproduced on all authorised
// copies and copies may only be made to the extent permitted
// by a licensing agreement from ARM Limited.
//
// -----------------------------------------------------------------------------
// Version and Release Control Information:
//
// File Name              : VicCpuif.v.rca
// File Revision          : 1.15
//
// Release Information    : PrimeCell(TM)-PL192-r0p0-00rel0
//
// -----------------------------------------------------------------------------
// Purpose :
//           This block generates the handshaking signals to the CPU and
//           generates the signals to control the priority logic
//
// --=========================================================================--

`timescale 1ns/1ps

// -----------------------------------------------------------------------------

module VicCpuif (
// Inputs
                 HCLK,
                 HRESETn,
                 VectAddr0,
                 VectAddr1,
                 VectAddr2,
                 VectAddr3,
                 VectAddr4,
                 VectAddr5,
                 VectAddr6,
                 VectAddr7,
                 VectAddr8,
                 VectAddr9,
                 VectAddr10,
                 VectAddr11,
                 VectAddr12,
                 VectAddr13,
                 VectAddr14,
                 VectAddr15,
                 VectAddr16,
                 VectAddr17,
                 VectAddr18,
                 VectAddr19,
                 VectAddr20,
                 VectAddr21,
                 VectAddr22,
                 VectAddr23,
                 VectAddr24,
                 VectAddr25,
                 VectAddr26,
                 VectAddr27,
                 VectAddr28,
                 VectAddr29,
                 VectAddr30,
                 VectAddr31,
                 VICVECTADDRIN,
                 IRQRequest,
                 IRQReqLevel,
                 IRQPort,
                 IRQSWAck,
                 IRQSWClear,
                 nVICSYNCEN,
                 VICIRQACK,
                 ITEN,
                 IRQACKForceVal,
                 VADDRINForceVal,
                 VADDRVForceVal,
                 ACKOUTForceVal,
                 VADDRForceVal,
// Outputs
                 VICIRQACKOUT,
                 CurrentPriority,
                 VICVectAddrVal,
                 VICVECTADDRV,
                 VICVECTADDROUT,
                 IRQACKTestVal,
                 VADDRINTestVal,
                 VADDRVTestVal,
                 ACKOUTTestVal,
                 VADDRTestVal
                 );

// Inputs
input        HCLK;             // Bus Clock
input        HRESETn;          // AHB Reset

// Vector address from VicAHBif
input  [31:0] VectAddr0;       // Vector address for interrupt source 0
input  [31:0] VectAddr1;       // Vector address for interrupt source 1
input  [31:0] VectAddr2;       // Vector address for interrupt source 2
input  [31:0] VectAddr3;       // Vector address for interrupt source 3
input  [31:0] VectAddr4;       // Vector address for interrupt source 4
input  [31:0] VectAddr5;       // Vector address for interrupt source 5
input  [31:0] VectAddr6;       // Vector address for interrupt source 6
input  [31:0] VectAddr7;       // Vector address for interrupt source 7
input  [31:0] VectAddr8;       // Vector address for interrupt source 8
input  [31:0] VectAddr9;       // Vector address for interrupt source 9
input  [31:0] VectAddr10;      // Vector address for interrupt source 10
input  [31:0] VectAddr11;      // Vector address for interrupt source 11
input  [31:0] VectAddr12;      // Vector address for interrupt source 12
input  [31:0] VectAddr13;      // Vector address for interrupt source 13
input  [31:0] VectAddr14;      // Vector address for interrupt source 14
input  [31:0] VectAddr15;      // Vector address for interrupt source 15
input  [31:0] VectAddr16;      // Vector address for interrupt source 16
input  [31:0] VectAddr17;      // Vector address for interrupt source 17
input  [31:0] VectAddr18;      // Vector address for interrupt source 18
input  [31:0] VectAddr19;      // Vector address for interrupt source 19
input  [31:0] VectAddr20;      // Vector address for interrupt source 20
input  [31:0] VectAddr21;      // Vector address for interrupt source 21
input  [31:0] VectAddr22;      // Vector address for interrupt source 22
input  [31:0] VectAddr23;      // Vector address for interrupt source 23
input  [31:0] VectAddr24;      // Vector address for interrupt source 24
input  [31:0] VectAddr25;      // Vector address for interrupt source 25
input  [31:0] VectAddr26;      // Vector address for interrupt source 26
input  [31:0] VectAddr27;      // Vector address for interrupt source 27
input  [31:0] VectAddr28;      // Vector address for interrupt source 28
input  [31:0] VectAddr29;      // Vector address for interrupt source 29
input  [31:0] VectAddr30;      // Vector address for interrupt source 30
input  [31:0] VectAddr31;      // Vector address for interrupt source 31
input  [31:0] VICVECTADDRIN;   // Vector address for Daisy chained interrupt
// Signals from interrupt processing
input         IRQRequest;      // IRQ interrupt request
input   [3:0] IRQReqLevel;     // Priority level of the interrupt request
input   [5:0] IRQPort;         // Source of new interrupt request. Binary coded
                               // 0 to 31, VICINTSOURCE(0 to 31), 32 is the
                               // Daisy chain input
// Interrupt handling control from AHB interface
input         IRQSWAck;        // Software interrupt acknowledgement
input         IRQSWClear;      // Software interrupt clear
// Vic handshaking inputs
input         nVICSYNCEN;      // Synchronous setting of handshaking
input         VICIRQACK;       // IRQ acknowledge from CPU
// Test logic control
input         ITEN;            // Integration test enable
// Force signal values when ITEN is high
input         IRQACKForceVal;  // Force value for IRQACK
input  [31:0] VADDRINForceVal; // Force value for daisy chain address input
input         VADDRVForceVal;  // Force value for VICVECTADDRV
input         ACKOUTForceVal;  // Force value for IRQACKOUT
input  [31:0] VADDRForceVal;   // Force value for vector address output

// Outputs

output        VICIRQACKOUT;    // Vic handshaking output for cascaded
                               // interrupt controller
// Signals to Interrupt processing
output [15:0] CurrentPriority; // Current interrupt priority
output [31:0] VICVectAddrVal;  // Address value for software read

// Vic handshaking outputs
output        VICVECTADDRV;    // Address valid signal
output [31:0] VICVECTADDROUT;  // Vectored address out line

// Read back value for integration test
output        IRQACKTestVal;   // Integration test value of VICIRQACK
output [31:0] VADDRINTestVal;  // Integration test value of VICVECTADDRIN
output        VADDRVTestVal;   // Integration test value of VICVECTADDRV
output        ACKOUTTestVal;   // Integration test value of VICIRQACKOUT
output [31:0] VADDRTestVal;    // Integration test value of VICVECTADDROUT

// Inputs

// Clocks and reset values
wire          HCLK;            // AHB Clock
wire          HRESETn;         // AHB Reset

// Vector address from VicAHBif
wire   [31:0] VectAddr0;       // Vector address for interrupt source 0
wire   [31:0] VectAddr1;       // Vector address for interrupt source 1
wire   [31:0] VectAddr2;       // Vector address for interrupt source 2
wire   [31:0] VectAddr3;       // Vector address for interrupt source 3
wire   [31:0] VectAddr4;       // Vector address for interrupt source 4
wire   [31:0] VectAddr5;       // Vector address for interrupt source 5
wire   [31:0] VectAddr6;       // Vector address for interrupt source 6
wire   [31:0] VectAddr7;       // Vector address for interrupt source 7
wire   [31:0] VectAddr8;       // Vector address for interrupt source 8
wire   [31:0] VectAddr9;       // Vector address for interrupt source 9
wire   [31:0] VectAddr10;      // Vector address for interrupt source 10
wire   [31:0] VectAddr11;      // Vector address for interrupt source 11
wire   [31:0] VectAddr12;      // Vector address for interrupt source 12
wire   [31:0] VectAddr13;      // Vector address for interrupt source 13
wire   [31:0] VectAddr14;      // Vector address for interrupt source 14
wire   [31:0] VectAddr15;      // Vector address for interrupt source 15
wire   [31:0] VectAddr16;      // Vector address for interrupt source 16
wire   [31:0] VectAddr17;      // Vector address for interrupt source 17
wire   [31:0] VectAddr18;      // Vector address for interrupt source 18
wire   [31:0] VectAddr19;      // Vector address for interrupt source 19
wire   [31:0] VectAddr20;      // Vector address for interrupt source 20
wire   [31:0] VectAddr21;      // Vector address for interrupt source 21
wire   [31:0] VectAddr22;      // Vector address for interrupt source 22
wire   [31:0] VectAddr23;      // Vector address for interrupt source 23
wire   [31:0] VectAddr24;      // Vector address for interrupt source 24
wire   [31:0] VectAddr25;      // Vector address for interrupt source 25
wire   [31:0] VectAddr26;      // Vector address for interrupt source 26
wire   [31:0] VectAddr27;      // Vector address for interrupt source 27
wire   [31:0] VectAddr28;      // Vector address for interrupt source 28
wire   [31:0] VectAddr29;      // Vector address for interrupt source 29
wire   [31:0] VectAddr30;      // Vector address for interrupt source 30
wire   [31:0] VectAddr31;      // Vector address for interrupt source 31
wire   [31:0] VICVECTADDRIN;   // Vector address for Daisy chained interrupt

// Signals from interrupt processing
wire          IRQRequest;      // IRQ interrupt request
wire    [3:0] IRQReqLevel;     // Priority level of the interrupt request
wire    [5:0] IRQPort;         // Source of new interrupt request. Binary coded
                               // 0 to 31, VICINTSOURCE(0 to 31), 32 is the
                               // Daisy chain wire

// Interrupt handling control from AHB interface
wire          IRQSWAck;        // Software interrupt acknowledgement
wire          IRQSWClear;      // Software interrupt clear

// Vic handshaking wire s
wire          nVICSYNCEN;      // Synchronous setting of handshaking
wire          VICIRQACK;       // IRQ acknowledge from CPU

// Test logic control
wire          ITEN;            // Integration test enable

// Force signal values when ITEN is high
wire          IRQACKForceVal;  // Force value for IRQACK
wire   [31:0] VADDRINForceVal; // Force value for daisy chain address wire
wire          VADDRVForceVal;  // Force value for VICVECTADDRV
wire          ACKOUTForceVal;  // Force value for IRQACKOUT
wire   [31:0] VADDRForceVal;   // Force value for vector address output


// Outputs

wire        VICIRQACKOUT;      // Vic handshaking wire for cascaded
                               // interrupt controller

// Signals to Interrupt processing
wire [15:0] CurrentPriority;   // Current interrupt priority
wire [31:0] VICVectAddrVal;    // Address for software read

// Vic handshaking wires
wire        VICVECTADDRV;      // Connect to VICVECTADDRV
wire [31:0] VICVECTADDROUT;    // Vectored address out line

// Read back value for integration test
wire        IRQACKTestVal;     // Integration test value of VICIRQACK
wire [31:0] VADDRINTestVal;    // Integration test value of VICVECTADDRIN
wire        VADDRVTestVal;     // Integration test value of VICVECTADDRV
wire        ACKOUTTestVal;     // Integration test value of VICIRQACKOUT
wire [31:0] VADDRTestVal;      // Integration test value of VICVECTADDROUT
// -----------------------------------------------------------------------------
//
//                              VicCpuif
//                              ========
//
// -----------------------------------------------------------------------------
//
// Overview
// ========
// This block has the following functionality,
//
// - It generates the handshake signals for CPU and daisy chain VIC.
//   When the CPU acknowledges the interrupt by VICIRQACK, the VIC generates the
//   VICVECTADDRV stable when the address is stable on the VICVECTADDROUT line.
//   When VICIRQACK is asserted this module generates its IrqAck signal when
//   it is ready to accept the acknowledgement. Once the address is stable,
//   VICVECTADDRV is asserted. When VICIRQACK is deasserted, VICVECTADDRV and
//   nVICIRQ are deasserted.
//   VICIRQACKOUT is generated to inform the cascaded VIC that its interrupt is
//   being serviced. This is done by ORing the software ACK and the accepted
//   VICIRQACK.
// - Generates the control signals to control priority logic.
//   This block traces the interrupts which are there in the pipeline and are
//   not completely serviced. When the ISR address is read by the CPU, the
//   currently being serviced interrupt is pushed to the stack and the masking
//   is generated. This will mask the other equal and lower priority interrupts.
//   when the interrupt is being serviced. Once the interrupt service is
//   completed, presently serviced priority is cleared and new mask value is
//   generated.
// - It generates the address to be put on VICVECTADDROUT line.
//   Depending on the interrupt the address is placed on VICVECTADDROUT line.
//   If the daisy chain interrupt is selected then the address on VICVECTADDRIN
//   is placed on VICVECTADDROUT line.
//
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Constant declarations
// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
// Wire declarations
// -----------------------------------------------------------------------------
wire        IRQACKtmux;        // Test mux signal for VICIRQACK
wire [31:0] VADDRINtmux;       // Test mux signal for VECTADDRIN
wire        VADDRVtmux;        // Test mux signal for VICVECTADDRV
wire        ReadyForAck;       // Signal to ensure VIC has been clocked
                               // for acknowledge
wire        StackPush;         // Signal to indicate the stack push
wire        StackPop;          // Signal to indicate the stack pop

// -----------------------------------------------------------------------------
// Register declarations
// -----------------------------------------------------------------------------
reg  [31:0] VADDRtmux;         // Test mux for VICVECTADDROUT
reg         ACKOUTtmux;        // Test mux for VICIRQACKOUT
reg         Sync1IRQACK;       // synchronisation logic for IrqAck
reg         Sync2IRQACK;       // 2nd synchronisation flip-flop
reg         Sync3IRQACK;       // IRQACK delayed by 3 clock edges
reg         IrqAck;            // Validated IRQ acknowledgement
reg         LastIrqAck;        // Clocked IrqAck
reg  [31:0] ElyVecAddrMux;     // Mux of Vector address for local IRQs
reg  [31:0] VectAddrMux;       // Mux of final Vector address register
reg  [31:0] LastVectAddr;      // Register to hold vector address stable
reg         IRQPortBit5Q;      // 5th bit of Registered IRQ port number
reg         IRQRequestQ;       // Registered IRQ request
reg   [3:0] IRQRLevelQ;        // Registered level
reg  [15:0] NewLevelEncoded;   // One hot representation of interrupt
                               // priority level of interrupt request
reg  [15:0] NxtNewLvlEncoded;  // D-input of NewLevelEncoded
reg  [15:0] PriorityStack;     // Priority level stack
reg  [15:0] NxtPriorityStk;    // D-input of Priority Stack flip flop
reg  [15:0] NxtPriorityStk2;   // D-input of Priority Stack flip flop
reg  [31:0] NxtElyVecAddrMux;  // D-input of ElyVecAddrMux
reg  [31:0] NxtLastVectAddr;   // D-input of the LastVectAddr

reg         LastIrqAckQ;       // Clocked LastIrqAck
reg         IRQSWAckQ;         // Clocked IRQSWAck
reg  [31:0] VICVECTADDRINQ;    // Clocked VICVECTADDRIN
reg  [31:0] VADDRtmuxQ;        // Clocked VADDRtmux
// -----------------------------------------------------------------------------
// Function declarations
// -----------------------------------------------------------------------------

// synopsys translate_off
// -----------------------------------------------------------------------------
// Type declarations
// -----------------------------------------------------------------------------

// synopsys translate_on
// -----------------------------------------------------------------------------
//
// Main body of code
// =================
//
// -----------------------------------------------------------------------------


// -----------------------------------------------------------------------------
// Test mux to force input value for IRQACK and VADDRIN signal
// -----------------------------------------------------------------------------
assign IRQACKtmux  = (ITEN ? IRQACKForceVal  : VICIRQACK);
assign VADDRINtmux = (ITEN ? VADDRINForceVal : VICVECTADDRIN);

// -----------------------------------------------------------------------------
// Connect the Muxed IRQACK and VADDRIN to top level
// -----------------------------------------------------------------------------
assign IRQACKTestVal  = IRQACKtmux;

assign VADDRINTestVal = (ITEN ? VADDRINForceVal : VICVECTADDRINQ);

// -----------------------------------------------------------------------------
// Clock the inputs from VicInterrupt block
// -----------------------------------------------------------------------------
always @(negedge HRESETn or posedge HCLK)
begin : p_RegVicIntSeq
  if (HRESETn == 1'b0)
    begin
      IRQPortBit5Q   <= 1'b0;
      IRQRequestQ    <= 1'b0;
      IRQRLevelQ     <= {4{1'b0}};
    end
  else
    begin
      IRQPortBit5Q   <= IRQPort[5];
      IRQRequestQ    <= IRQRequest;
      IRQRLevelQ     <= IRQReqLevel;
    end
end // p_RegVicIntSeq

// -----------------------------------------------------------------------------
// Generate one-hot representation of new priority level.
// If there is no new interrupt value initialise the level to zero.
// -----------------------------------------------------------------------------
always @(IRQRLevelQ or IRQRequestQ)
begin : p_NewLevelComb
  if (IRQRequestQ)
    begin
      case (IRQRLevelQ)
        4'b0000: NxtNewLvlEncoded  = 16'b0000000000000001;
        4'b0001: NxtNewLvlEncoded  = 16'b0000000000000010;
        4'b0010: NxtNewLvlEncoded  = 16'b0000000000000100;
        4'b0011: NxtNewLvlEncoded  = 16'b0000000000001000;
        4'b0100: NxtNewLvlEncoded  = 16'b0000000000010000;
        4'b0101: NxtNewLvlEncoded  = 16'b0000000000100000;
        4'b0110: NxtNewLvlEncoded  = 16'b0000000001000000;
        4'b0111: NxtNewLvlEncoded  = 16'b0000000010000000;
        4'b1000: NxtNewLvlEncoded  = 16'b0000000100000000;
        4'b1001: NxtNewLvlEncoded  = 16'b0000001000000000;
        4'b1010: NxtNewLvlEncoded  = 16'b0000010000000000;
        4'b1011: NxtNewLvlEncoded  = 16'b0000100000000000;
        4'b1100: NxtNewLvlEncoded  = 16'b0001000000000000;
        4'b1101: NxtNewLvlEncoded  = 16'b0010000000000000;
        4'b1110: NxtNewLvlEncoded  = 16'b0100000000000000;
        default: NxtNewLvlEncoded  = 16'b1000000000000000;
     endcase
    end
  else
    begin
     NxtNewLvlEncoded = {16{1'b0}};
    end
 end // p_NewLevelComb

// -----------------------------------------------------------------------------
// Clock the one-hot representation of priority level.
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_NewLevelSeq
  if (HRESETn==1'b0)
    begin
      NewLevelEncoded <= 16'b0000000000000000;
    end
  else
    begin
      NewLevelEncoded <= NxtNewLvlEncoded;
    end
end // p_NewLevelSeq
  
// -----------------------------------------------------------------------------
// Clock the VICVECTADDRIN
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_VicAddrVectInSeq
  if (HRESETn==1'b0)
    begin
      VICVECTADDRINQ <= {32{1'b0}};
    end
  else
    begin
      VICVECTADDRINQ <= VICVECTADDRIN;
    end
end // p_VicAddrVectInSeq

// -----------------------------------------------------------------------------
// Clock the VADDRtmux
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_VADDRtmuxSeq
  if (HRESETn==1'b0)
    begin
      VADDRtmuxQ <= {32{1'b0}};
    end
  else
    begin
      VADDRtmuxQ <= VADDRtmux;
    end
end // p_VADDRtmuxSeq

// -----------------------------------------------------------------------------
// Ensure VIC is clocked once before switching IrqAck from 0 to 1
// If IrqAck was already '1' (LastIrqAck='1'), then ignore. Sync3IRQACK makes
// sure that the handshaking mechanism going without holding up because of the
// absent of the interrupt source.
// -----------------------------------------------------------------------------
assign ReadyForAck  = (IRQRequestQ | LastIrqAck | Sync3IRQACK);

// -----------------------------------------------------------------------------
// Registering the priority stack
// -----------------------------------------------------------------------------
always @(negedge HRESETn or posedge HCLK)
begin : p_PriorityStackSeq
  if (HRESETn == 1'b0)
    begin
      PriorityStack  <= {16{1'b0}};
    end
  else
    begin
      PriorityStack <= NxtPriorityStk2;
    end
end // p_PriorityStackSeq

// -----------------------------------------------------------------------------
// Priority Stack
// When there is write acknowledge then clear the highest interrupt priority
// indicating that the present interrupt service is completed. And the other
// interrupt of same priority can be serviced if asserted.
// -----------------------------------------------------------------------------
always @(StackPop or PriorityStack)
begin : p_PriorityStkComb1
  if (StackPop)
    begin
      if (PriorityStack[0])
        begin
          NxtPriorityStk = PriorityStack & 16'b1111111111111110;
        end
      else if (PriorityStack[1])
        begin
          NxtPriorityStk = PriorityStack & 16'b1111111111111101;
        end
      else if (PriorityStack[2])
        begin
          NxtPriorityStk = PriorityStack & 16'b1111111111111011;
        end
      else if (PriorityStack[3])
        begin
          NxtPriorityStk = PriorityStack & 16'b1111111111110111;
        end
      else if (PriorityStack[4])
        begin
          NxtPriorityStk = PriorityStack & 16'b1111111111101111;
        end
      else if (PriorityStack[5])
        begin
          NxtPriorityStk = PriorityStack & 16'b1111111111011111;
        end
      else if (PriorityStack[6])
        begin
          NxtPriorityStk = PriorityStack & 16'b1111111110111111;
        end
      else if (PriorityStack[7])
        begin
          NxtPriorityStk = PriorityStack & 16'b1111111101111111;
        end
      else if (PriorityStack[8])
        begin
          NxtPriorityStk = PriorityStack & 16'b1111111011111111;
        end
      else if (PriorityStack[9])
        begin
          NxtPriorityStk = PriorityStack & 16'b1111110111111111;
        end
      else if (PriorityStack[10])
        begin
          NxtPriorityStk = PriorityStack & 16'b1111101111111111;
        end
      else if (PriorityStack[11])
        begin
          NxtPriorityStk = PriorityStack & 16'b1111011111111111;
        end
      else if (PriorityStack[12])
        begin
          NxtPriorityStk = PriorityStack & 16'b1110111111111111;
        end
      else if (PriorityStack[13])
        begin
          NxtPriorityStk = PriorityStack & 16'b1101111111111111;
        end
      else if (PriorityStack[14])
        begin
          NxtPriorityStk = PriorityStack & 16'b1011111111111111;
        end
      else if (PriorityStack[15])
        begin
          NxtPriorityStk = PriorityStack & 16'b0111111111111111;
        end
      else
        begin
          NxtPriorityStk = PriorityStack;
        end
    end
  else
    begin
      NxtPriorityStk = PriorityStack;
    end
end // p_PriorityStkComb1

// -----------------------------------------------------------------------------
// Combinatorial logic for pushing the priority to the stack
// -----------------------------------------------------------------------------
always @(StackPush or NewLevelEncoded or NxtPriorityStk)
begin : p_PriorityStkComb2
  if (StackPush == 1'b1)
    begin
      NxtPriorityStk2 = (NxtPriorityStk | NewLevelEncoded);
    end
  else
    begin
      NxtPriorityStk2 = NxtPriorityStk;
    end
end // p_PriorityStkComb2

// -----------------------------------------------------------------------------
// Connect the priority stack to the CurrentPriority which will be used in the
// VicInterrupt block. When Address valid is high, set the current priority to
// zero so that nVICIRQ will be de asserted along with the de assertion
// of the ADDRV.
// -----------------------------------------------------------------------------
assign CurrentPriority  = (LastIrqAck == 1'b0) ? PriorityStack : {16{1'b0}};

// -----------------------------------------------------------------------------
// Control for Priority stack.
// Stack push will be either by AHB read from the VICADDRESS or by Vic port
// handshaking.
// Stack pop is by writing to the VICADDRESS by the CPU at end of interrupt
// service routine.
// -----------------------------------------------------------------------------
assign StackPush  = (IRQSWAckQ | (~(LastIrqAckQ) & LastIrqAck));
assign StackPop   = IRQSWClear;

// -----------------------------------------------------------------------------
// Acknowledge synchronisation logic
// 3rd flip-flop is used to ensure handshaking going without holding up by
// the absent of interrupt source
// -----------------------------------------------------------------------------
always @(negedge HRESETn or posedge HCLK)
begin : p_AckSyncLogicSeq
  if (HRESETn == 1'b0)
    begin
      Sync1IRQACK  <= 1'b0;
      Sync2IRQACK  <= 1'b0;
      Sync3IRQACK  <= 1'b0;
    end
  else
    begin
      Sync1IRQACK  <= IRQACKtmux;
      Sync2IRQACK  <= Sync1IRQACK;
      Sync3IRQACK  <= Sync2IRQACK;
    end
end // p_AckSyncLogicSeq

// -----------------------------------------------------------------------------
// Decide if double flip-flop synchronisation logic is used
// When nVICSYNCEN is low, use the clocked VICIRQACK else use the direct
// VICIRQACK.
// -----------------------------------------------------------------------------
always @(ReadyForAck or Sync2IRQACK or nVICSYNCEN or IRQACKtmux)
begin : p_IrqAckComb
  if (ReadyForAck)
    begin
      if (nVICSYNCEN == 1'b0)
        begin
          IrqAck  = Sync2IRQACK;
        end
      else
        begin
          IrqAck  = IRQACKtmux;
        end
    end
  else
    begin
      IrqAck  = 1'b0;
    end
end // p_IrqAckComb

// -----------------------------------------------------------------------------
// Create delay version of IrqAck for edge detection
// -----------------------------------------------------------------------------
always @(negedge HRESETn or posedge HCLK)
begin : p_DelayIrqAckSeq
  if (HRESETn == 1'b0)
    begin
      LastIrqAck  <= 1'b0;
    end
  else
    begin
      LastIrqAck  <= IrqAck;
    end
end // p_DelayIrqAckSeq

// -----------------------------------------------------------------------------
// Create delay version of LastIrqAck for pushing the stack
// -----------------------------------------------------------------------------
always @(negedge HRESETn or posedge HCLK)
begin : p_LastIrqAckSeq
  if (HRESETn == 1'b0)
    begin
      LastIrqAckQ  <= 1'b0;
    end
  else
    begin
      LastIrqAckQ  <= LastIrqAck;
    end
end // p_LastIrqAckSeq

// -----------------------------------------------------------------------------
// Generate VICVECTADDRV and connect it to the top level
// -----------------------------------------------------------------------------
assign VADDRVtmux   = (ITEN  ? VADDRVForceVal : LastIrqAck);
assign VICVECTADDRV = VADDRVtmux;

// -----------------------------------------------------------------------------
// For Software read back
// -----------------------------------------------------------------------------
assign  VADDRVTestVal  = VADDRVtmux;

// -----------------------------------------------------------------------------
// Clocking the software acknowledge signal
// -----------------------------------------------------------------------------
always @(negedge HRESETn or posedge HCLK)
begin : p_IRQSWAckSeq
  if (HRESETn == 1'b0)
    begin
      IRQSWAckQ  <= 1'b0;
    end
  else
    begin
      IRQSWAckQ  <= IRQSWAck;
    end
end // p_IRQSWAckSeq

// -----------------------------------------------------------------------------
// Cascaded interrupt controller feedback. If the local interrupt is inactive
// then feedback the VICIRQACKOUT to daisy chained interrupt controller.
// -----------------------------------------------------------------------------
always @(ITEN or IRQPortBit5Q or IRQSWAck or IrqAck or LastIrqAck or
          ACKOUTForceVal)
begin : p_IrqAckmuxComb
  if (ITEN)
    begin
      ACKOUTtmux  = ACKOUTForceVal;
    end
  else
    begin
      ACKOUTtmux = (IRQSWAck | (IrqAck & ~(LastIrqAck))) & IRQPortBit5Q;
    end
end // p_IrqAckmuxComb

// -----------------------------------------------------------------------------
// Connect to AhbIf for read back in the integration test mode
// -----------------------------------------------------------------------------
assign  ACKOUTTestVal  = ACKOUTtmux ;

// -----------------------------------------------------------------------------
// Connect the ACKOUTtmux to top level output
// -----------------------------------------------------------------------------
assign  VICIRQACKOUT  = ACKOUTtmux ;

// -----------------------------------------------------------------------------
// Register the vector address
// -----------------------------------------------------------------------------
always @(negedge HRESETn or posedge HCLK)
begin : p_EarlyAddrMuxSeq
  if (HRESETn == 1'b0)
    begin
      ElyVecAddrMux <= {32{1'b0}};
    end
  else
    begin
      ElyVecAddrMux <= NxtElyVecAddrMux;
    end
end // p_EarlyAddrMuxSeq

// -----------------------------------------------------------------------------
// VIC vector address mux
// Addresses for local IRQ are muxed during priority encoding stage to improve
// timing of HRDATA
// -----------------------------------------------------------------------------
always @(IRQPort or VectAddr0 or VectAddr1 or VectAddr2 or VectAddr3 or
         VectAddr4 or VectAddr5 or VectAddr6 or VectAddr7 or VectAddr8 or
         VectAddr9 or VectAddr10 or VectAddr11 or VectAddr12 or VectAddr13 or
         VectAddr14 or VectAddr15 or VectAddr16 or VectAddr17 or VectAddr18 or
         VectAddr19 or VectAddr20 or VectAddr21 or VectAddr22 or VectAddr23 or
         VectAddr24 or VectAddr25 or VectAddr26 or VectAddr27 or VectAddr28 or
         VectAddr29 or VectAddr30 or VectAddr31)
begin : p_EarlyAddrMuxComb
  case (IRQPort[4:0])
    5'b00000: NxtElyVecAddrMux  = VectAddr0;
    5'b00001: NxtElyVecAddrMux  = VectAddr1;
    5'b00010: NxtElyVecAddrMux  = VectAddr2;
    5'b00011: NxtElyVecAddrMux  = VectAddr3;
    5'b00100: NxtElyVecAddrMux  = VectAddr4;
    5'b00101: NxtElyVecAddrMux  = VectAddr5;
    5'b00110: NxtElyVecAddrMux  = VectAddr6;
    5'b00111: NxtElyVecAddrMux  = VectAddr7;
    5'b01000: NxtElyVecAddrMux  = VectAddr8;
    5'b01001: NxtElyVecAddrMux  = VectAddr9;
    5'b01010: NxtElyVecAddrMux  = VectAddr10;
    5'b01011: NxtElyVecAddrMux  = VectAddr11;
    5'b01100: NxtElyVecAddrMux  = VectAddr12;
    5'b01101: NxtElyVecAddrMux  = VectAddr13;
    5'b01110: NxtElyVecAddrMux  = VectAddr14;
    5'b01111: NxtElyVecAddrMux  = VectAddr15;
    5'b10000: NxtElyVecAddrMux  = VectAddr16;
    5'b10001: NxtElyVecAddrMux  = VectAddr17;
    5'b10010: NxtElyVecAddrMux  = VectAddr18;
    5'b10011: NxtElyVecAddrMux  = VectAddr19;
    5'b10100: NxtElyVecAddrMux  = VectAddr20;
    5'b10101: NxtElyVecAddrMux  = VectAddr21;
    5'b10110: NxtElyVecAddrMux  = VectAddr22;
    5'b10111: NxtElyVecAddrMux  = VectAddr23;
    5'b11000: NxtElyVecAddrMux  = VectAddr24;
    5'b11001: NxtElyVecAddrMux  = VectAddr25;
    5'b11010: NxtElyVecAddrMux  = VectAddr26;
    5'b11011: NxtElyVecAddrMux  = VectAddr27;
    5'b11100: NxtElyVecAddrMux  = VectAddr28;
    5'b11101: NxtElyVecAddrMux  = VectAddr29;
    5'b11110: NxtElyVecAddrMux  = VectAddr30;
    default:  NxtElyVecAddrMux  = VectAddr31;
  endcase
end // p_EarlyAddrMuxComb

// -----------------------------------------------------------------------------
// Store the LastVectAddr after IrqAck is deasserted
// -----------------------------------------------------------------------------
always @(VectAddrMux or LastIrqAck or LastVectAddr)
begin : p_LastVAddrStComb
  if (LastIrqAck == 1'b0)
    begin
      NxtLastVectAddr = VectAddrMux;
    end
  else
    begin
      NxtLastVectAddr = LastVectAddr;
    end
end // p_LastVAddrStComb

// -----------------------------------------------------------------------------
// Feedback VIC address for SW read (acknowledge)
// -----------------------------------------------------------------------------
assign  VICVectAddrVal  = VectAddrMux;

// -----------------------------------------------------------------------------
// Circuit to hold VICVECTADDROUT stable
// -----------------------------------------------------------------------------
always @(negedge HRESETn or posedge HCLK)
begin : p_VectAddrRegSeq
  if (HRESETn == 1'b0)
    begin
      LastVectAddr <= {32{1'b0}};
    end
  else
    begin
      LastVectAddr <= NxtLastVectAddr;
    end
end // p_VectAddrRegSeq

// -----------------------------------------------------------------------------
// Mux Output for read by software and to VIC handshaking port
// If there is no IRQ request keep the address unchanged. If the daisy chain
// interrupt is active then, select the VICADDRIN. If the interrupt is a local
// one then select the corresponding address.
// -----------------------------------------------------------------------------
always @(IRQPortBit5Q or IRQRequestQ or VADDRINtmux or ElyVecAddrMux or
         LastVectAddr)
begin : p_VicAddrMuxComb
  if (IRQRequestQ == 1'b0)
    begin
      VectAddrMux  = LastVectAddr;
    end
  else if (IRQPortBit5Q)
    begin
      VectAddrMux = VADDRINtmux;
    end
  else
    begin
      VectAddrMux = ElyVecAddrMux;
    end
end // p_VicAddrMuxComb

// -----------------------------------------------------------------------------
// Select Vector address output
// If the ACK was already asserted the output address should keep the same
// address else select the latest address. If the ITEN is enabled in test mode,
// then select the content of the VICITOP2 address.
// -----------------------------------------------------------------------------
always @(ITEN or VectAddrMux or LastVectAddr or VADDRForceVal or LastIrqAck)
begin : p_AddrOutComb
  if (ITEN)
    begin
      VADDRtmux  = VADDRForceVal;
    end
  else
    begin
    if (LastIrqAck)
       begin
         VADDRtmux  = LastVectAddr;
       end
     else
       begin
         VADDRtmux  = VectAddrMux;
       end
    end
end // p_AddrOutComb

// -----------------------------------------------------------------------------
// Connect to top level
// -----------------------------------------------------------------------------
assign  VICVECTADDROUT  = VADDRtmux;

// -----------------------------------------------------------------------------
// Connect to VicAHBif for integration test read back.
// -----------------------------------------------------------------------------
assign  VADDRTestVal  = VADDRtmuxQ;

// synopsys translate_off
// -----------------------------------------------------------------------------
// START OF PROTOCOL CHECKERS
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// END OF PROTOCOL CHECKERS
// -----------------------------------------------------------------------------
// synopsys translate_on

endmodule
// --================================== End ==================================--
