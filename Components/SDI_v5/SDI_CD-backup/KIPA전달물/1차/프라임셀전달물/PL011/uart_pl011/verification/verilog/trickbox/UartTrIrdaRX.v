//============================================================================--
//  This confidential and proprietary software may be used only as
//  authorised by a licensing agreement from ARM Limited
//    (C) COPYRIGHT 2000 ARM Limited
//        ALL RIGHTS RESERVED
//  The entire notice above must be reproduced on all authorised
//  copies and copies may only be made to the extent permitted
//  by a licensing agreement from ARM Limited.
//  ----------------------------------------------------------------------------
//
//  Version and Release Control Information:
//
//  File Name              : UartTrIrdaRX.v.rca
//  File Revision          : 1.2
//
//  Release Information    : PrimeCell(TM)-PL011-REL1v3
//
// -----------------------------------------------------------------------------
// Purpose     : This block contains the control logic for the transmit
//               section of Uart
//
// ===========================================================================--

`timescale 1ns/1ps
 
// ----------------------------------------------------------------------------- 
module UartTrIrdaRX (
// Inputs
                     UARTCLK,
                     nUARTRES,
                     FEN,
                     nSIRIN,
                     UARTEN,
                     RXFWrDone,
                     IRLPDivisor,
                     Mode,
                     Divisor,
                     FracDiv,
                     RxJitterSign,
                     RxJitterFactor,
                     WLEN,
                     STP2,
                     EPS,
                     PEN,

// Outputs
                     RXFIFOData,
                     RXBUSY,
                     RCVFE,
                     RCVPE,
                     RXFWr
                    );

// Inputs
input         UARTCLK;          // Uart Clock
input         nUARTRES;         // Uart Reset
input         FEN;              // FIFO Enable
input         nSIRIN;           // Irda Input
input         UARTEN;           // Trickbox Enable
input         RXFWrDone;        // RX FIFO Write Done
input   [7:0] IRLPDivisor;      // IRLP Pulse width
input   [1:0] Mode;             // Mode of Operation
input  [15:0] Divisor;          // Uart Baud
input   [5:0] FracDiv;          // fraction baud rate
input         RxJitterSign;     // Denotes Jitter Sign
input   [1:0] RxJitterFactor;   // Jitter Factor
input   [1:0] WLEN;             //Data bits per word
input         STP2;             // Stop bits per frame
input         EPS;              // Even Parity Select
input         PEN;              // Parity Enable

// Outputs
output [10:0] RXFIFOData;       // FIFO Write Data
output        RXBUSY;           // Reception Status
output        RCVFE;            // Frame Error
output        RCVPE;            // Parity Error
output        RXFWr;            // RXFIFO Write Enable

// Inputs
wire          UARTCLK;          // Uart Clock
wire          nUARTRES;         // Uart Reset
wire          FEN;              // FIFO Enable
wire          nSIRIN;           // Irda Input
wire          UARTEN;           // Trickbox Enable
wire          RXFWrDone;        // RX FIFO Write Done
wire    [7:0] IRLPDivisor;      // IRLP Pulse width
wire    [1:0] Mode;             // Mode of Operation
wire   [15:0] Divisor;          // Uart Baud
wire    [5:0] FracDiv;          // fraction baud rate
wire          RxJitterSign;     // Denotes Jitter Sign
wire    [1:0] RxJitterFactor;   // Jitter Factor
wire    [1:0] WLEN;             //Data bits per word
wire          STP2;             // Stop bits per frame
wire          EPS;              // Even Parity Select
wire          PEN;              // Parity Enable

// Outputs
reg    [10:0] RXFIFOData;       // FIFO Write Data
reg           RXBUSY;           // Reception Status
reg           RCVFE;            // Frame Error
reg           RCVPE;            // Parity Error
reg           RXFWr;            // RXFIFO Write Enable

//------------------------------------------------------------------------------
//
//                                 UartIrdaTrRX
//                                 ============
//
//------------------------------------------------------------------------------
//
// Overview
// ========
//   The control logic for the receive block of Irda recovers data according
// to the parameters programmed in trickbox line control registers.
//
//------------------------------------------------------------------------------
 
//------------------------------------------------------------------------------
// Constant declarations
//------------------------------------------------------------------------------
`define IRDACON3 2'b11
// For generating Irda Pulse

`define CON64    7'b1000000

`define CON128   8'b80

`define CON2     2'b10

//------------------------------------------------------------------------------
// Wire declarations
//------------------------------------------------------------------------------
reg    [10:0] RecvData;
// Internal temporary register for holding received data

reg     [7:0] Bitcount;
// Denotes the number of bits in the word being received

reg           NextRXBUSY;
// Combinational input for Trickbox receive busy signal

reg           NextRXFWr;
// Combinational input for Receive FIFO frame write signal

reg     [19:0] NextSamplingtime;
// Combinational input for sampling time

reg     [19:0] Samplingtime;
// Internal counter denoting the number of Uart clk cycles sampled

reg            StartRx;
// Denotes reception in progress

reg     [22:0] UartBaud;
// Internal register related with Uart bit width

reg     [15:0] BaudILPR;
// Internal register related with Low power pulse baud rate

reg     [19:0] ActualBitPeriod;
// Denotes actual Uart bit width

reg     [19:0] Jitter;
// Bit width considering RX jitter

reg      [7:0] NextCount;
// Combinational input for counting the bit being received
 
reg      [7:0] Count;
// Counter denoting the bit being received

reg      [7:0] NextActcount;
// Combinational input for the internal counter Actcount
 
reg      [7:0] Actcount;
// To store the parity and stop bits in the higher order nibble

reg      [7:0] Wordcount;
// Internal register denoting data bits pre word

integer        ActBitPerInt;
integer        i;

wire           samplenowIrda;

// -----------------------------------------------------------------------------
// Function declarations
// -----------------------------------------------------------------------------
//function to_integerr;
//val : std_logic_vector; x : integer := 0)
//variable return_int, x_tmp : integer;
//
//begin
//  return_int := 0;
//  x_tmp := 0;
//  if x /= 0 then
//    x_tmp := 1;
//  end if;
//  for i in val'range loop
//    return_int := return_int + return_int;
//    case (val[i])
//      when 1'b0 =>     null;
//      when 1'b1 =>     return_int := return_int + 1;
//      when others =>  return_int := return_int + x_tmp;
//    end case;
//  end loop;
//  to_integerr =  return_int;
//endfunction

//------------------------------------------------------------------------------
//
// Main body of  code
// ==================
//
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// State transition process
//------------------------------------------------------------------------------
always @(posedge UARTCLK or negedge nUARTRES) 
begin : p_StateSeq
  if (nUARTRES == 1'b0)
    begin
      Count        = 8'h00;
      Actcount     = 8'h00;
      Samplingtime = 20'h00000;
      RXFWr        = 1'b0;
      RXBUSY       = 1'b0;
    end
  else
    begin
      Samplingtime = NextSamplingtime;
      RXFWr        = NextRXFWr;
      RXBUSY       = NextRXBUSY;
      Count        = NextCount;
      Actcount     = NextActcount;
    end
end // p_StateSeq

assign samplenowIrda    = (Samplingtime == 20'h00000) ? 1'b1 : 1'b0;

//------------------------------------------------------------------------------
// Output and next state logic generation
//------------------------------------------------------------------------------
always @(UARTEN or Mode or Samplingtime or nSIRIN or Divisor or IRLPDivisor or
                       WLEN or EPS or STP2 or FracDiv or UartBaud or BaudILPR)
begin : p_StateCombo
//------------------------------------------------------------------------------
// Default assignments
// Determining Actual Uart bit width, Irda pulse widths
//------------------------------------------------------------------------------
  if (Divisor !== 16'hXXXX)
    begin
      UartBaud     <= (`CON64)*(Divisor) + (FracDiv);
      ActBitPerInt <= (((UartBaud)) * 16) / 64;
    end

  if (IRLPDivisor !== 8'hXX)
    BaudILPR <= ((`IRDACON3) *(({6'b000000, IRLPDivisor})));

  ActualBitPeriod <= (ActBitPerInt);

  // Write to FIFO signal asserted till the write is over
  if ((RXFWrDone == 1'b1) && (RXFWr == 1'b1))
    NextRXFWr <= 1'b0;
  else
    NextRXFWr <= RXFWr;

  if ((UARTEN == 1'b1) && ((Mode == 2'b01) || (Mode == 2'b10)))
    begin
      // Checking for Start bit once trickbox is enabled in Normal mode 
      if ((nSIRIN == 1'b1) && (StartRx == 1'b1))
        begin
          if (RxJitterSign == 1'b0)
            Jitter <= (ActualBitPeriod) + ({6'b000000, RxJitterFactor}) - 1;
          else
            Jitter <= (ActualBitPeriod) - ({6'b000000, RxJitterFactor}) + 1;

          // Determining bits per word and assigning initial conditions 
          case (WLEN)
            2'b00 : Wordcount <= 8'h05;
            2'b01 : Wordcount <= 8'h06;
            2'b10 : Wordcount <= 8'h07;
            2'b11 : Wordcount <= 8'h08;
            default : Wordcount <= 8'h00;
          endcase

          Bitcount     <= 8'h00;
          NextCount    <= 8'h00;
          NextActcount <= 8'h00; 
          NextRXBUSY   <= 1'b1; 
          StartRx      <= 1'b0;
          RecvData     <= 11'b00000000000;
        end
      else if (StartRx == 1'b1)
        NextRXBUSY <= 1'b0;

      // Reception in progress
      if (StartRx == 1'b0)
        begin
        // Receiving data bits
        // Increment bit count,assign the received data according to the
        // bit received
        // Initialising next bitperiod counter
        if (Count < Wordcount)
          if (Samplingtime == 20'h00000)
            begin
              RecvData[((Count))] <= ~(nSIRIN);
              NextCount <= (Count) + 1;
              NextSamplingtime <= (ActualBitPeriod) - 1;
            end
          // Increment bit period counter 
          else if (Bitcount == 8'h00)
            begin
              if (Mode == 2'b01)
                begin
                  // my version
                  NextSamplingtime <= (Jitter) - 
                                      ({8'h00, ActualBitPeriod[19:8]})
                  - ({9'b000000000, ActualBitPeriod[19:9]}) -1;
                end
              else
                NextSamplingtime <= (Jitter) - ({4'h0, BaudILPR[7:0]});
              Bitcount <= (Wordcount) + STP2 + PEN;
            end
          else
            NextSamplingtime <= (Samplingtime) - 1;

        // Receive Parity bit and Stop bit, if they are enabled 
        else if (Bitcount > Count)
          if (Samplingtime == 20'h00000)
            begin
              RecvData[((Actcount))] <= ~(nSIRIN); 
              NextSamplingtime <= (ActualBitPeriod) - 1;
              NextCount        <= (Count) + 1;
              NextActcount     <= (Actcount) + 1;
            end
          else
            begin
              if ((Count == Wordcount) && (Actcount <= 8'h07))
                NextActcount <= 8'h08;
              NextSamplingtime <= (Samplingtime) - 1;
            end

        // Receiving Stop bit
        else if (Bitcount == Count)
          // Assign received data to RXFIFO
          if (Samplingtime == 20'h00000)
            begin
              for (i = ((Actcount) - 1); i >= 0; i = i - 1)
                RXFIFOData[i] <= RecvData[i];
              RXFIFOData[((Actcount))] <= ~(nSIRIN);  
              if (Actcount < 8'h0A)
                for (i = ((Actcount) + 1); i <= 10; i = i + 1)
                  RXFIFOData[i] <= RecvData[i];

              // Determining Frame Error
              RCVFE <= nSIRIN | (~(RecvData[((Actcount)-1)])
                       & STP2);
              NextSamplingtime <= (ActualBitPeriod) - 1;
              NextRXFWr        <= 1'b1;
              StartRx          <= 1'b1;
            end
          else
            begin
              // Determining Parity Error
              RCVPE <= PEN & (RecvData[0] ^ RecvData[1] ^
                       RecvData[2] ^ RecvData[3] ^ RecvData[4] 
                       ^ RecvData[5] ^ RecvData[6] ^ 
                       RecvData[7] ^ RecvData[8] ^ ~(EPS));
                    
              if ((Count == Wordcount) && (Actcount <= 8'h07))
                NextActcount <= 8'h08;

              NextSamplingtime <= (Samplingtime) - 1;
            end
        end
    end
  else
    begin
      NextRXBUSY <= 1'b1;
      StartRx    <= 1'b1;
    end
end // p_StateCombo

endmodule

// ============================== End ==========================================
