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
//  File Name              : UartTrRX.v.rca
//  File Revision          : 1.2
//
//  Release Information    : PrimeCell(TM)-PL011-REL1v3
//
// -----------------------------------------------------------------------------
// Purpose     : This block contains the control logic for the receive 
//               section of trickbox 
//
// ===========================================================================--

`timescale 1ns/1ps
 
//  --------------------------------------------------------------------------- 

module UartTrRX (
// Inputs
                 UARTCLK,
                 nUARTRES,
                 FEN,
                 RXD,
                 UARTEN,
                 RXFWrDone,
                 Mode,
                 Divisor,
                 FracDiv,
                 RxJitterSign,
                 RxJitterFactor,
                 WLEN,
                 STP2,
                 EPS,
                 PEN,
                 SPS,

// Outputs
                 RXFWr,
                 RXFIFOData,
                 RXBUSY,
                 RCVFE,
                 RCVPE
                );
 
// Inputs
input         UARTCLK;          // Uart Clock  
input         nUARTRES;         // Uart Reset
input         FEN;              // FIFO Enable
input         RXD;              // Received Data bit
input         UARTEN;           // Enable Trickbox
input         RXFWrDone;        // RX FIFO Write Done
input   [1:0] Mode;             // Trickbox Mode
input  [15:0] Divisor;          // Baud Rate value
input   [5:0] FracDiv;          // Fractional baud rate
input         RxJitterSign;     // Denotes Jitter Sign
input   [1:0] RxJitterFactor;   // Jitter Factor
input   [1:0] WLEN;             // Data bits per word
input         STP2;             // Stop bits per frame
input         EPS;              // Even Parity Select
input         PEN;              // Parity Enable
input         SPS;              // Stick Parity Select

// Outputs
output        RXFWr;            // RXFIFO Write Enable
output [10:0] RXFIFOData;       // FIFO Data
output        RXBUSY;           // Reception Status
output        RCVFE;            // Frame Error
output        RCVPE;            // Parity Error

// Inputs
wire          UARTCLK;          // Uart Clock  
wire          nUARTRES;         // Uart Reset
wire          FEN;              // FIFO Enable
wire          RXD;              // Received Data bit
wire          UARTEN;           // Enable Trickbox
wire          RXFWrDone;        // RX FIFO Write Done
wire    [1:0] Mode;             // Trickbox Mode
wire   [15:0] Divisor;          // Baud Rate value
wire    [5:0] FracDiv;          // Fractional baud rate
wire          RxJitterSign;     // Denotes Jitter Sign
wire    [1:0] RxJitterFactor;   // Jitter Factor
wire    [1:0] WLEN;             // Data bits per word
wire          STP2;             // Stop bits per frame
wire          EPS;              // Even Parity Select
wire          PEN;              // Parity Enable
wire          SPS;              // Stick Parity Select

// Outputs
reg           RXFWr;            // RXFIFO Write Enable
reg    [10:0] RXFIFOData;       // FIFO Data
reg           RXBUSY;           // Reception Status
reg           RCVFE;            // Frame Error
reg           RCVPE;            // Parity Error

//------------------------------------------------------------------------------
//
//                                 UartTrRX
//                                 ========
//
//------------------------------------------------------------------------------
//
// Overview
// ========
//  The control logic for the receive block of Uart recovers data according
//  to the parameters programmed in trickbox line control registers.
// 
//------------------------------------------------------------------------------
 
//------------------------------------------------------------------------------
// Constant declarations
//------------------------------------------------------------------------------
`define CON64 7'b1000000

//------------------------------------------------------------------------------
// Signal declarations
//------------------------------------------------------------------------------
reg    [10:0] RecvData;
// Internal temporary register for holding received data

reg     [7:0] Bitcount;
// Denotes the number of bits in the word being received 

reg           NextRXBUSY;
// Combinational input for Trickbox receive busy signal

reg           NextRXFWr;
// Combinational input for Receive FIFO frame write signal

reg    [19:0] NxtSamplingtime;
// Combinational input for sampling time

reg    [19:0] Samplingtime;
// Internal counter denoting the number of Uart clk cycles sampled

reg           StartRx;
// Denotes reception in progress

reg    [22:0] UartBaud;
// Internal register related with Uart bit width

reg    [19:0] ActualBitPeriod;
// Denotes actual Uart bit width

reg     [7:0] NextCount;
// Combinational input for counting the bit being received 

reg     [7:0] Count;
// Counter denoting the bit being received

reg     [7:0] NextActcount;
// Combinational input for the internal counter Actcount  
 
reg     [7:0] Actcount;
// To store the parity and stop bits in the higher order nibble

reg     [7:0] Wordcount;
// Internal register denoting data bits pre word

integer       ActBitPerInt;

wire          samplenow;

integer       i;

//------------------------------------------------------------------------------
//
// Main body of code
// =================
//
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// State transition process
//------------------------------------------------------------------------------
always @(posedge UARTCLK or negedge nUARTRES) 
begin : p_StateSeq
  if (nUARTRES == 1'b0)
    begin
      Count        <= 8'h00;
      Actcount     <= 8'h00;
      Samplingtime <= 20'h00000;
      RXFWr        <= 1'b0;
      RXBUSY       <= 1'b0;
    end
  else
    begin
      Samplingtime <= NxtSamplingtime;
      RXFWr        <= NextRXFWr;
      RXBUSY       <= NextRXBUSY;
      Count        <= NextCount;
      Actcount     <= NextActcount;
    end
end // p_StateSeq

assign samplenow        = (Samplingtime == 20'h00000) ? 1'b1 : 1'b0;

//------------------------------------------------------------------------------
// Output and next state logic generation
//------------------------------------------------------------------------------
always @(UARTEN or Mode or UartBaud or Samplingtime or RXD or Divisor or 
                       WLEN or EPS or STP2 or FracDiv or ActBitPerInt)
begin : p_StateComb

//------------------------------------------------------------------------------
// Default assignments
// Determining Actual Uart bit width
//------------------------------------------------------------------------------
  if (Divisor !== 16'hXXXX)
    begin
//     UartBaud <= (Divisor) + 1;
      UartBaud     <= (`CON64)*(Divisor) + (FracDiv);
      ActBitPerInt <= (((UartBaud)) * 16) / 64;
    end
//   ActualBitPeriod <= UartBaud & "0000";
  ActualBitPeriod <= (ActBitPerInt);


  // Write to FIFO signal asserted till the write is over
  if ((RXFWrDone == 1'b1) && (RXFWr == 1'b1))
    NextRXFWr <= 1'b0;
  else
    NextRXFWr <= RXFWr;

  if (((UARTEN == 1'b1) && (Mode == 2'b00)))
    begin
      // Checking for Start bit once trickbox is enabled in Normal mode 
      // if ((negedge RXD ) && (StartRx == 1'b1))
      if ((RXD == 1'b0 ) && (StartRx == 1'b1))
        begin
          // Determining the sampling time of first data bit 
          if (RxJitterSign == 1'b0)
            NxtSamplingtime <= (ActualBitPeriod) + 
                               ({1'b0, ActualBitPeriod[19:1]})
                               + ({6'b000000, RxJitterFactor})
                               - ({4'h0, ActualBitPeriod[19:4]}) - 1;
    //                         - (Divisor) - 1;
          else
            NxtSamplingtime <= (ActualBitPeriod) + 
                              ({1'b0, ActualBitPeriod[19:1]})
                              - ({6'b000000, RxJitterFactor})
                              - ({4'h0, ActualBitPeriod[19:4]}) - 1;
  //                          - (Divisor) - 1;

          // Determining bits per word and assigning initial conditions 
          case (WLEN)
            2'b00 : Wordcount <= 8'h05;
            2'b01 : Wordcount <= 8'h06;
            2'b10 : Wordcount <= 8'h07;
            2'b11 : Wordcount <= 8'h08;
            default : Wordcount <= 8'h00;
          endcase

          NextCount    <= 8'h00;
          NextActcount <= 8'h00; 
          NextRXBUSY   <= 1'b1; 
          StartRx      <= 1'b0;
          RecvData     <= 11'b00000000000;
        end
      else if (StartRx == 1'b1)
        NextRXBUSY   <= 1'b0;

      // Reception in progress 
      if (StartRx == 1'b0)
         
        // Receiving data bits
        // Increment bit count,assign the received data according to the
        // bit received
        // Initialising next bitperiod counter 
        if (Count < Wordcount )
          if (Samplingtime == 20'h00000)
            begin
              RecvData[((Count))] <= RXD ;
              NextCount       <= (Count)  + 1;
              NxtSamplingtime <= (ActualBitPeriod) - 1;
            end
          // Increment bit period counter 
          else
            begin
              Bitcount        <= (Wordcount) + STP2 + PEN ;
              NxtSamplingtime <= (Samplingtime) - 1;
            end
          
        // Receive Parity bit and Stop bit, if they are enabled 
        else if (Bitcount > Count)
          if (Samplingtime == 20'h00000)
            begin
              RecvData[((Actcount))] <= RXD;
              NxtSamplingtime <= (ActualBitPeriod) - 1;
              NextCount       <= (Count) +1;
              NextActcount    <= (Actcount) +1;
            end
          // Store the incoming bits from the 8th position onwards 
          else
            begin
              if ((Count == Wordcount) && (Actcount <= 8'h07))
                NextActcount <= 8'h08;
              NxtSamplingtime <= (Samplingtime) - 1;
            end
        // Receiving Stop bit
        else if (Bitcount == Count)
             
          // Assign received data to RXFIFO
          if (Samplingtime == 20'h00000)
            begin
              for (i = ((Actcount)- 1); i >= 0; i = i-1)
                RXFIFOData[i] <= RecvData[i];
              RXFIFOData[((Actcount))] <= RXD;
              if (Actcount < 8'h0A)
                for (i = ((Actcount)+ 1); i <= 10; i = i+1)
                  RXFIFOData[i] <= RecvData[i];

              // Determining Frame Error
              RCVFE <= !(RXD) | 
                 (!(RecvData[((Actcount) -1)]) & STP2);
              NxtSamplingtime <= (ActualBitPeriod) - 1;
              NextRXFWr <= 1'b1;
              StartRx <= 1'b1;
            end
          else
            begin
              // Determining Parity Error
              if(SPS == 1'b1)
                RCVPE <= RecvData[8] ^ (!(EPS));
              else
                RCVPE <= PEN & (RecvData[0] ^ RecvData[1] ^ 
                                  RecvData[2] ^ RecvData[3] ^ RecvData[4] 
                                  ^ RecvData[5] ^ RecvData[6] ^ RecvData[7] 
                                  ^ RecvData[8]  ^ !(EPS)) ;

              // Store the incoming bits from the 8th position onwards
              if ((Count == Wordcount) && (Actcount <= 8'h07))
                NextActcount <= 8'h08;
              NxtSamplingtime <= (Samplingtime) - 1;
            end
    end
  // Initialise idle stata settings
  else
    begin
      NextRXBUSY <= 1'b0;
      StartRx    <= 1'b1;
    end
end // p_StateComb

endmodule

// ============================== End  =========================================
