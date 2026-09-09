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
//  File Name              : UartTrTX.v.rca
//  File Revision          : 1.2
//
//  Release Information    : PrimeCell(TM)-PL011-REL1v3
//
//  ----------------------------------------------------------------------------
// Purpose  : This block contains the control logic for the transmit
//            section of Trickbox  
//
// ========================================================================== --

`timescale 1ns/1ps

//  ----------------------------------------------------------------------------
 
module UartTrTX (
// Inputs
                 UARTCLK,
                 nUARTRES,
                 TXDataAvlbl,
                 UTLCRH,
                 UARTEN,
                 UTSETPINS,
                 WLEN,
                 EPS,
                 Mode,
                 Divisor,
                 TxJitterSign,
                 TxJitterFactor,
                 TXShiftData,
                 RdPtrIncDone,
                 PEEN,
                 FEEN,
                 SPS,

// Outputs
                 TXD,
                 TXBUSY,
                 TXFRdPtrInc
                );
 
// Inputs
input         UARTCLK;          // Main UART Clock
input         nUARTRES;         // Muxed reset (from nUARTRST)
input         TXDataAvlbl;      // TX Data Available
input   [7:0] UTLCRH;           // Line Control Reg
input         UARTEN;           // UART Enable
input         UTSETPINS;        // Programmable TXD
input   [1:0] WLEN;             // Bits per word
input         EPS;              // Even Parity Select
input   [1:0] Mode;             // Operation Mode
input  [15:0] Divisor;          // Baud Rate
input         TxJitterSign;     // TX Jitter Sign
input   [1:0] TxJitterFactor;   // TX Jitter Factor
input   [7:0] TXShiftData;      // TX Data
input         RdPtrIncDone;     // Read Pointer Increment done
input         PEEN;             // Introduce Parity Error
input         FEEN;             // Introduce Framing  Error
input         SPS;              // Stick Parity Select

// Outputs
output        TXD;              // Internal Transmit line
output        TXBUSY;           // Transmitter busy
output        TXFRdPtrInc;      // TX FIFO Rd Ptr Inc

// Inputs
wire          UARTCLK;          // Main UART Clock
wire          nUARTRES;         // Muxed reset (from nUARTRST)
wire          TXDataAvlbl;      // TX Data Available
wire    [7:0] UTLCRH;           // Line Control Reg
wire          UARTEN;           // UART Enable
wire          UTSETPINS;        // Programmable TXD
wire    [1:0] WLEN;             // Bits per word
wire          EPS;              // Even Parity Select
wire    [1:0] Mode;             // Operation Mode
wire   [15:0] Divisor;          // Baud Rate
wire          TxJitterSign;     // TX Jitter Sign
wire    [1:0] TxJitterFactor;   // TX Jitter Factor
wire    [7:0] TXShiftData;      // TX Data
wire          RdPtrIncDone;     // Read Pointer Increment done
wire          PEEN;             // Introduce Parity Error
wire          FEEN;             // Introduce Framing  Error
wire          SPS;              // Stick Parity Select

// Outputs
reg           TXD;              // Internal Transmit line
reg           TXBUSY;           // Transmitter busy
reg           TXFRdPtrInc;      // TX FIFO Rd Ptr Inc

//------------------------------------------------------------------------------
//
//                                   UartTrTXCntl
//                                   ============
//
//------------------------------------------------------------------------------
//
// Overview
// ========
//  The control logic for the transmit block of Trickbox  shifts out data 
// according  to the parameters programmed in trickbox line control registers. 
//
//------------------------------------------------------------------------------
 
//------------------------------------------------------------------------------
// Wire declarations
//------------------------------------------------------------------------------
reg           NextTXFRdPtrInc; 
// Combinational input for TX FIFO Read Pointer Incrementer

reg           NextTXBUSY; 
// Combinational input for Transmit busy

reg           NextTXData; 
// Combinational input for Data to be transmitted

reg           Parity; 
// Parity bit transmitted

reg           Starttx; 
// Set while start bit transmission

reg           NextStarttx;
// D-input for Start-tx

reg           iTXD; 
// Internal version of Data transmitted

reg    [10:0] TxData; 
// Actual data transmitted

reg     [7:0] Wordcount;
// bits per frame

reg     [7:0] Bitcount;
// Internal counter denoting the bit being transmitted

reg    [19:0] Bitperiodcount;
// Internal counter denoting the clock cycles for which the bit 
// is being transmitted

reg     [7:0] Nextbitcount;
// Combinational input for the bit counter

reg    [19:0] NxtBitperiodcnt;
//  Combinational input for the bitperiod counter

reg    [19:0] ActualBitPeriod;
// Denotes Uart bit period

reg     [7:0] PaddedData;
// Concatenated TX Shift Reg data

reg    [15:0] Uartbaud;
// Internal signal related to baud rate

reg     [1:0] FrameCtrl;
// Concatenating Parity and STP2 enable

wire          BitPerZero;

//------------------------------------------------------------------------------
//
// Main body of code
// =================
//
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// Multiplexing Actual TXD and Programmable TXD 
//------------------------------------------------------------------------------
always @(UARTEN or iTXD or UTSETPINS)
begin : p_modeComb
  if (UARTEN == 1'b1)
    TXD <= iTXD;
  else
    TXD <= UTSETPINS;
end // p_modeComb

//------------------------------------------------------------------------------
// State transition process
//------------------------------------------------------------------------------
always @(posedge UARTCLK or negedge nUARTRES) 
begin : p_StateSeq
  if (nUARTRES == 1'b0)
    begin
      TXFRdPtrInc    = 1'b0;
      Starttx        = 1;
      TXBUSY         = 1'b0;
      Bitcount       = 8'h00;
      Bitperiodcount = 20'h00000;
      iTXD           = 1'b0;
    end
  else
    begin
      TXFRdPtrInc    = NextTXFRdPtrInc;      
      Starttx        = NextStarttx;
      TXBUSY         = NextTXBUSY;
      Bitcount       = Nextbitcount;
      Bitperiodcount = NxtBitperiodcnt;
      iTXD           = NextTXData;
    end
end // p_StateSeq

assign BitPerZero       = (Bitperiodcount == 20'h00000) ? 1'b1 : 1'b0;

//------------------------------------------------------------------------------
// Output and next state logic generation
//------------------------------------------------------------------------------
always @(iTXD or Bitcount or Divisor or Bitperiodcount or TXBUSY or
         TXShiftData or PaddedData or Starttx or UARTEN or Mode or TXDataAvlbl)
begin : p_StateCombo
//------------------------------------------------------------------------------
// Default assignments
// Calculating Actual Uart bit width and concatenating PEN and STP2
//------------------------------------------------------------------------------
  if (Divisor !== 16'hXXXX)
    begin
//     Uartbaud <= (Divisor) + 1; 
      Uartbaud <= Divisor; 
    end

  ActualBitPeriod = {Uartbaud, 4'h0};
  FrameCtrl       = {UTLCRH[1], UTLCRH[3]};
 
  if (((UARTEN == 1'b1) && (Mode == 2'b00)))
//------------------------------------------------------------------------------
// Transmission in progress, if Trickbox is enabled in Normal mode and data
// is available in shift register or until the last data's stop bit
// is fully transmitted
//------------------------------------------------------------------------------
    if ((TXDataAvlbl == 1'b1) || ((RdPtrIncDone == 1'b1) && 
                              (TXBUSY == 1'b1)))
//------------------------------------------------------------------------------
      // Transmit start bit
//------------------------------------------------------------------------------
      if (Starttx == 1'b1)

        // Setting the initial conditions   
        if ((Bitcount == 8'h00) && (Bitperiodcount == 20'h00000))
          begin
            NextTXData      <= 1'b0;
            NextTXBUSY      <= 1'b1;
            NextTXFRdPtrInc <= 1'b0;
            
            // Process the startbit period if jitter is enabled             
            if (TxJitterSign == 1'b1)
              NxtBitperiodcnt <= (ActualBitPeriod)  
                                 + ( TxJitterFactor) - 1;
            else 
              NxtBitperiodcnt <= ( ActualBitPeriod)  
                                 - ( TxJitterFactor) - 1 ; 
          end 
          // Determining transmit parameters during Start bit transmission 
        else
          begin
          // Regrouping the data bits to be transmitted
            case (WLEN)
              2'b00 : begin
                        PaddedData <= {3'b000, TXShiftData[0], TXShiftData[1],
                                       TXShiftData[2], TXShiftData[3],
                                       TXShiftData[4]};
                        Wordcount  <= 8'h05;
                      end
              2'b01 : begin
                        PaddedData <= {2'b00, TXShiftData[0], TXShiftData[1],
                                       TXShiftData[2], TXShiftData[3],
                                       TXShiftData[4], TXShiftData[5]};
                        Wordcount  <= 8'h06;
                      end
              2'b10 : begin
                        PaddedData <= {1'b0, TXShiftData[0], TXShiftData[1],
                                       TXShiftData[2], TXShiftData[3],
                                       TXShiftData[4], TXShiftData[5],
                                       TXShiftData[6]};
                        Wordcount  <= 8'h07;
                      end
              2'b11 : begin
                        PaddedData <= {TXShiftData[0], TXShiftData[1],
                                       TXShiftData[2], TXShiftData[3],
                                       TXShiftData[4], TXShiftData[5],
                                       TXShiftData[6], TXShiftData[7]};
                        Wordcount  <= 8'h08;
                      end
              default : begin
                          PaddedData <= 8'h00;
                          Wordcount  <= 8'h00;
                        end
            endcase
            
            // Generating Parity bit
            if (SPS == 1'b1)
              if (PEEN == 1'b1)
                Parity <= EPS;
              else
                Parity <= !(EPS);
            else
              Parity <= ((((((PaddedData[0] ^ PaddedData[1]) ^
                         (PaddedData[2] ^ PaddedData[3])) ^
                         (PaddedData[4] ^ PaddedData[5])) ^
                         (PaddedData[6] ^ PaddedData[7])) ^
                         !(EPS)) ^ ((PEEN)));
           
            // Concatenating Parity and Stop bit(s)
            case (FrameCtrl)
              2'b00 : begin
                        TxData <= {2'b00, PaddedData, !(FEEN)};
                        if (Wordcount !== 8'hXX)
                          Nextbitcount <= (Wordcount) + 1;
                      end
              2'b01 : begin
                        TxData <= {1'b0, PaddedData, !(FEEN), !(FEEN)};
                        if (Wordcount !== 8'hXX)
                          Nextbitcount <= (Wordcount) + 2;
                      end
              2'b10 : begin
                        TxData <= {1'b0, PaddedData, Parity, !(FEEN)};
                        if (Wordcount !== 8'hXX)
                          Nextbitcount <= (Wordcount) + 2;
                      end
              2'b11 : begin
                        TxData <= {PaddedData, Parity, !(FEEN), !(FEEN)};
                        if (Wordcount !== 8'hXX)
                          Nextbitcount <= (Wordcount) + 3;
                      end
              default : begin
                          TxData <= 11'b00000000000;
                          Nextbitcount <= 8'h00;
                        end
            endcase
            
            // Transmiting Startbit in progress
            // Initialising bitperiod counter and decrement bit count
            // Assign Next Data bit 
            if (Bitperiodcount == 20'h00000)
              begin
                NextStarttx     <= 1'b0;
                Nextbitcount    <= (Bitcount) -1 ;
                NxtBitperiodcnt <= (ActualBitPeriod)  - 1;
                NextTXData      <= TxData[((Bitcount) -1 )];
              end 
            // Decrement bitperiod counter 
            else
              begin
                NextTXData      <= 1'b0;
                NxtBitperiodcnt <= (Bitperiodcount) - 1 ;
              end
          end
       
      // Start transmiting Data bits, as well as, Parity and Stopbit if
      // they are enabled 
      else if (Bitcount != 8'h00)
           
       // Transmitting data bits
       // Initialising bitperiod counter and increment bit count
       // Assign Next Data bit
         if (Bitperiodcount == 20'h00000)
           begin
             Nextbitcount    <= (Bitcount) - 1;
             NxtBitperiodcnt <= (ActualBitPeriod)  -  1;
             NextTXData      <= TxData[((Bitcount) -1 )];
           end
         // Decrement bitperiod counter
         else 
           NxtBitperiodcnt <= (Bitperiodcount) - 1 ;
      
       // Start transmiting Stopbit
      else
         // Stoptbit transmitted fully
         // Deassert Next Frame Read Pointer increment enable signal
         if (Bitperiodcount == 20'h00000)
           begin
             NextStarttx     <= 1'b1;
             NextTXFRdPtrInc <= 1'b0;
             NextTXData      <= 1'b1;
           end
         // Increment bitperiod counter
         // Assert Next Frame Read Pointer Increment enable signal
         else
           begin
             NextTXData       <= TxData[((Bitcount))];
             NxtBitperiodcnt  <= (Bitperiodcount) - 1 ;
             NextTXFRdPtrInc  <= 1'b1;
           end

     // Reinitialize Idle State Settings
    else 
      begin
        Nextbitcount     <= 8'h00;
        NxtBitperiodcnt  <= 20'h00000;
        NextStarttx      <= 1'b1;
        NextTXData       <= 1'b1;
        NextTXBUSY       <= 1'b0;
      end
  // Reinitialize Idle State Settings
  else
    begin
      Nextbitcount       <= 8'h00;
      NxtBitperiodcnt    <= 20'h00000;
      NextStarttx        <= 1'b1;
      NextTXData         <= 1'b1;
      NextTXBUSY         <= 1'b0;
      NextTXFRdPtrInc    <= 1'b0;
    end
  
end // p_StateCombo

endmodule

// ============================== End  =========================================
