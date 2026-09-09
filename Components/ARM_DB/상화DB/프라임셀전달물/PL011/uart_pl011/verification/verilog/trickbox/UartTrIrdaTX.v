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
//  File Name              : UartTrIrdaTX.v.rca
//  File Revision          : 1.3
//
//  Release Information    : PrimeCell(TM)-PL011-REL1v3
//
// -----------------------------------------------------------------------------
// Purpose     : This block contains the control logic for the transmit
//               section of Irda 
//
// ===========================================================================--

`timescale 1ns/1ps

// -----------------------------------------------------------------------------
 
module UartTrIrdaTX (
// Inputs
                     UARTCLK,
                     nUARTRES,
                     TXDataAvlbl,
                     UTSETPINS,
                     UTLCRH,
                     IRDADEC,
                     UTBITSFTDATA,
                     UTBITSFTDATA2,
                     UARTEN,
                     WLEN,
                     EPS,
                     Mode,
                     Divisor,
                     IRLPDivisor,
                     TxJitterSign,
                     TxJitterFactor,
                     TXShiftData,
                     RdPtrIncDone,
                     PEEN,
                     FEEN,

// Outputs
                     SIROUT,
                     TXFRdPtrInc,
                     TXBUSY
                    );
 
// Inputs
input         UARTCLK;          // Main UART Clock
input         nUARTRES;         // Uart reset 
input         TXDataAvlbl;      // TX Data Available
input         UTSETPINS;        // Programmable TXD
input   [7:0] UTLCRH;           // Line ControlReg
input   [3:0] IRDADEC;          // Decrease Factor
input   [7:0] UTBITSFTDATA;     // Pulse Shift Reg
input   [5:0] UTBITSFTDATA2;    // Pulse ShiftReg
input         UARTEN;           // UART Enable
input   [1:0] WLEN;             // Bits per word
input         EPS;              // Even Parity Select
input   [1:0] Mode;             // Operation Mode
input  [15:0] Divisor;          // Baud Rate
input   [7:0] IRLPDivisor;      // Low Power Baud
input         TxJitterSign;     // TX Jitter Sign
input   [1:0] TxJitterFactor;   // TX JitterFactor
input   [7:0] TXShiftData;      // TX Data
input         RdPtrIncDone;     // Read Pointer Increment done
input         PEEN;             // Intoduce Parity Error
input         FEEN;             // Introduce Framing  Error

// Outputs
output        SIROUT;           // Irda Output Data bit
output        TXFRdPtrInc;      // TX FIFO Rd Ptr Inc
output        TXBUSY;           // Transmitter busy

// Inputs
wire          UARTCLK;          // Main UART Clock
wire          nUARTRES;         // Uart reset 
wire          TXDataAvlbl;      // TX Data Available
wire          UTSETPINS;        // Programmable TXD
wire    [7:0] UTLCRH;           // Line ControlReg
wire    [3:0] IRDADEC;          // Decrease Factor
wire    [7:0] UTBITSFTDATA;     // Pulse Shift Reg
wire    [5:0] UTBITSFTDATA2;    // Pulse ShiftReg
wire          UARTEN;           // UART Enable
wire    [1:0] WLEN;             // Bits per word
wire          EPS;              // Even Parity Select
wire    [1:0] Mode;             // Operation Mode
wire   [15:0] Divisor;          // Baud Rate
wire    [7:0] IRLPDivisor;      // Low Power Baud
wire          TxJitterSign;     // TX Jitter Sign
wire    [1:0] TxJitterFactor;   // TX JitterFactor
wire    [7:0] TXShiftData;      // TX Data
wire          RdPtrIncDone;     // Read Pointer Increment done
wire          PEEN;             // Intoduce Parity Error
wire          FEEN;             // Introduce Framing  Error

// Outputs
reg           SIROUT;           // Irda Output Data bit
reg           TXFRdPtrInc;      // TX FIFO Rd Ptr Inc
reg           TXBUSY;           // Transmitter busy

//------------------------------------------------------------------------------
//
//                   UartTrIrdaTX
//                   ===========
//
//------------------------------------------------------------------------------
//
// Overview
// ========
//
//  The control logic for the transmit block of Uart shifts out data according
//  to the parameters programmed in trickbox line control registers.
//
//------------------------------------------------------------------------------
 
//------------------------------------------------------------------------------
// Constant declarations
//------------------------------------------------------------------------------
`define IRDACON3 2'b11
// For Generating PW

`define IRDACON13 4'hD
// For Generating PW

//-----------------------------------------------------------------------------
// Wire declarations
//-----------------------------------------------------------------------------
reg           NextTXFRdPtrInc;
// Combinational input for Incrementer

reg           NextTXBUSY;
// Combinational input for Transmit busy

reg           NextTXData;
// Combinational input for Data to be transmitted

reg           NextSIROUT;
// Combinational input for Data to be transmitted

reg           Parity;
// Parity bit transmitted

wire           BITSFTEN;
// Shifting pulses Enabled

reg           Starttx;
// Set while start bit transmission

reg           NextStarttx;
// D-input for Start transmission

reg    [10:0] TxData;
// Actual data transmitted

reg           TXDatabit;
// Internal version of Data transmitted

reg           iSIROUT;
// Internal version of data transmitted

reg    [19:0] ActualBitPeriod;
// Denotes Uart bit period

reg     [7:0] PaddedData;
// Concatenated TX Shift Reg data

reg    [15:0] UartBaud;
// Internal signal related to Uart baud rate

reg    [15:0] BaudILPR;
// Internal signal related to Irda low power pulse rate

reg    [17:0] BaudIrda;
// Internal signal related to Irda baud rate
 
reg    [21:0] IrdaPW;
// Denotes Irda pulse width

reg    [19:0] IrdaLPRPW;
//Denotes Irda low power pulse width

reg    [19:0] PWidth;
// Actual pulse width of the bit

reg    [19:0] BitJitter;
// Bitperiod after considering jitter

reg     [7:0] Count;
// Internal counter for counting pulses

reg     [7:0] Nextcount;
// Combinational input for counter Count

reg    [19:0] ActualPW;
// Actual bit width

reg    [19:0] StartPW;
// Start bit pulse width

reg     [7:0] Wordcount;
// bits per frame

reg     [7:0] Bitcount;
// Internal counter denoting the bit being transmitted

reg    [19:0] Bitperiodcount;
// Internal counter denoting the clock cycles for which the bit
// is being transmitte

reg     [7:0] Nextbitcount;
// Combinational input for the bit counter

reg    [19:0] NxtBitperiodcnt;
//  Combinational input for the bitperiod counter

wire    [2:0] PULSENUM;
// Pulse to be jittered

wire    [2:0] PULSESHFT;
// Shifting factor for the pulse

wire    [2:0] SPNUM;
// Starting pulse number from which it is to be jittered

wire    [2:0] EPNUM;
// Ending pulse number upto which it is to be jittered

wire    [1:0] SHFT;
// Number of baud periods by which pulse has to be jittered

reg     [1:0] Framesel;
// Concatenated parity enable and STP2

//-----------------------------------------------------------------------------
//
// Main body of code
// =================
//
//------------------------------------------------------------------------------
 
//------------------------------------------------------------------------------
// Expose internal register(s)...
//------------------------------------------------------------------------------
assign PULSENUM         = UTBITSFTDATA2[5:3];
assign PULSESHFT        = UTBITSFTDATA2[2:0];
assign SPNUM            = UTBITSFTDATA[7:5];
assign EPNUM            = UTBITSFTDATA[4:2];
assign SHFT             = UTBITSFTDATA[1:0];
assign BITSFTEN         = UTLCRH[7];

//------------------------------------------------------------------------------
// Multiplexing Actual TXD and Programmable TXD
//------------------------------------------------------------------------------
always @(UARTEN or iSIROUT or UTSETPINS)
begin : p_modeComb
  if (UARTEN == 1'b1)
    SIROUT  <= iSIROUT;
  else
    SIROUT <= UTSETPINS;
end // p_modeComb
 
//------------------------------------------------------------------------------
// State transition process
//------------------------------------------------------------------------------
always @(posedge UARTCLK or negedge nUARTRES) 
begin : p_StateSeq
  if (nUARTRES == 1'b0)
    begin
      TXFRdPtrInc    <= 1'b0;
      TXBUSY         <= 1'b0;
      Bitcount       <= 8'h00;
      Count          <= 8'h00;
      iSIROUT        <= 1'b1;
      Bitperiodcount <= 20'h00000;
      TXDatabit      <= 1'b1;
      Starttx        <= 1'b1;
    end
  else
    begin
      Starttx        <= NextStarttx;
      TXFRdPtrInc    <= NextTXFRdPtrInc;
      TXBUSY         <= NextTXBUSY;
      Bitcount       <= Nextbitcount;
      Count          <= Nextcount;
      Bitperiodcount <= NxtBitperiodcnt ;
      TXDatabit      <= NextTXData;
      iSIROUT        <= NextSIROUT;
    end
end // p_StateSeq

//------------------------------------------------------------------------------
// Output and next state logic generation
//------------------------------------------------------------------------------
always @(Count or TXBUSY or RdPtrIncDone or Bitcount or BITSFTEN or
         Divisor or Bitperiodcount or TXShiftData or PaddedData or
         TXDatabit or UARTEN or Mode or TXDataAvlbl)
begin : p_StateCombo

//------------------------------------------------------------------------------
// Default assignments
// Determining Actual Uart bit width, Irda Pulse width and Low Power Pulse width
//------------------------------------------------------------------------------
//  if ((IRLPDivisor !=  8'hUU) && (IRLPDivisor !== 8'hXX))
  if (IRLPDivisor !== 8'hXX)
    begin
//      BaudILPR  <= (`IRDACON3) * (("000000"& IRLPDivisor)+ 1);
      BaudILPR  <= (`IRDACON3) * (({6'b000000, IRLPDivisor}));
    end
//  if ((Divisor != 16'hUUUU) && (Divisor !== 16'hXXXX))
  if (Divisor !== 16'hXXXX)
    begin
//    UartBaud        <= (Divisor) + 1;
      UartBaud        <= Divisor;
      BaudIrda        <= (`IRDACON3) * (UartBaud);
    end

  ActualBitPeriod <= {UartBaud, 4'h0};   
  Framesel        <= {UTLCRH[1], UTLCRH[3]};

  // Determining actual pulse widths 
  if (IRDADEC > 4'h0)
    begin
      IrdaLPRPW <= (BaudILPR) * (IRDADEC);
      IrdaPW    <= ((BaudIrda)) * ( IRDADEC);
    end
  else
    begin
      IrdaLPRPW <= {4'h0, BaudILPR};
      IrdaPW    <= {4'h0, BaudIrda};
    end

  // Determining Start Pulse width and Start bit width considering jitter
  if ((UARTEN == 1'b1) && ((Mode == 2'b01) || (Mode == 2'b10)))
    begin
      if (Mode == 2'b10)
        PWidth <= IrdaLPRPW;
      else
        if (IRDADEC > 4'h0)
          if (Divisor == 16'h0001)
            PWidth <= {1'b0, IrdaPW[21:3]};
          else
            PWidth <= {2'b00, IrdaPW[21:4]};
        else
          PWidth <= IrdaPW[19:0];

      if (TxJitterSign == 1'b1)
        BitJitter <= (ActualBitPeriod) + (TxJitterFactor);
      else
        BitJitter <= (ActualBitPeriod) - (TxJitterFactor);

      if (BITSFTEN == 1'b1)
        begin
          if (((PULSENUM == 3'b000) && (PULSESHFT != 3'b000)))
            StartPW <= (BitJitter) - (PULSESHFT) 
                       * (UartBaud);
          else if (((SPNUM == 3'b000) && (SHFT != 2'b00)))
            StartPW <= (BitJitter) - (SHFT) * 
                       ({1'b0, UartBaud[15:1]});
        end
      else
        StartPW <= BitJitter;

      // Transmission in progress, if Trickbox is enabled in Normal mode and
      // data is available in shift register or until the last data's stop bit
      // is fully transmitted 
      if ((TXDataAvlbl == 1'b1) || ((RdPtrIncDone == 1'b1) && 
          (TXBUSY == 1'b1)))
        
        // Transmit start bit 
        if (Starttx == 1'b1)

          // Setting the initial conditions     
          if ((Bitcount == 8'h00) && 
              (Bitperiodcount == 20'h00000))
            begin
              NextTXData <= 1'b1;
              NextSIROUT <= 1'b0;
              NextTXBUSY <= 1'b1;
              NextTXFRdPtrInc <= 1'b0;
              NxtBitperiodcnt <= 20'h00001;
            end 
          // Determining transmit parameters during Start bit transmission
          else 
            begin
              // Regrouping the data bits to be transmitted
              case (WLEN)
                2'b00 : begin
                          PaddedData <= {3'b000, TXShiftData[0],
                                         TXShiftData[1], TXShiftData[2],
                                         TXShiftData[3], TXShiftData[4]};
                          Wordcount  <= 8'h05;
                        end
                2'b01 : begin
                          PaddedData <= {2'b00, TXShiftData[0],
                                         TXShiftData[1], TXShiftData[2],
                                         TXShiftData[3], TXShiftData[4],
                                         TXShiftData[5]};
                          Wordcount  <= 8'h06;
                        end
                2'b10 : begin
                          PaddedData <= {1'b0, TXShiftData[0],
                                         TXShiftData[1], TXShiftData[2],
                                         TXShiftData[3], TXShiftData[4],
                                         TXShiftData[5], TXShiftData[6]};
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
                
              // Transmiting Startbit in progress
              // Initialising bitperiod counter and increment bit count
              // Assign Next SIROUT bit 
              if (((Bitperiodcount)) ==
                  (((StartPW))+1))
                begin
                  NextStarttx     <= 1'b0;
                  Nextbitcount    <= Bitcount ;
                  NxtBitperiodcnt <= 20'h00001;
                  Nextcount       <= 8'h01;
                  NextTXData      <= TxData[((Bitcount))];
                  if (TxData[((Bitcount))] == 1'b1)
                    NextSIROUT <= 1'b1;
                  else
                    NextSIROUT <= 1'b0;
                end
              // SIROUT held low till bitperiodcount becomes Pulse width
              else if (Bitperiodcount == PWidth)
                begin
                  NextSIROUT      <= 1'b1;
                  NxtBitperiodcnt <= (Bitperiodcount) + 1 ;
                  
                  // Concatenating Parity and Stop bit(s) 
                  case (Framesel)
                    2'b00 : begin
                              TxData       <= {2'b00, PaddedData, !(FEEN)};
                              Nextbitcount <= Wordcount;
                            end
                    2'b01 : begin
                              TxData       <= {1'b0, PaddedData, !(FEEN),
                                               !(FEEN)};
                              Nextbitcount <= (Wordcount) + 1;
                            end
                    2'b10 : begin
                              TxData       <= {1'b0, PaddedData, Parity,
                                               !(FEEN)};
                              Nextbitcount <= (Wordcount) + 1;
                            end
                    2'b11 : begin
                              TxData       <= {PaddedData, Parity, !(FEEN),
                                               !(FEEN)};
                              Nextbitcount <= (Wordcount) + 2;
                            end
                    default : begin
                                TxData       <= 11'b00000000000;
                                Nextbitcount <= 8'h00;
                              end
                  endcase
                end
              // Generating Parity bit
              // Increment bitperiod counter
              else
                begin
                  Parity <= ((((((PaddedData[0] ^ PaddedData[1]) ^ 
                             (PaddedData[2] ^ PaddedData[3])) ^ 
                             (PaddedData[4] ^ PaddedData[5])) ^ 
                             (PaddedData[6] ^ PaddedData[7])) ^ 
                             (!(EPS))) ^ ((PEEN)));
     
                  NxtBitperiodcnt <= (Bitperiodcount) + 1 ;
                end
            end

        // Start transmiting Data bits, as well as, Parity and Stopbit if
        // they are enabled 
        else if  (Bitcount != 8'h00)
          begin
            // Determining actual pulse width for the bit
            if (BITSFTEN == 1'b1)
              begin
                if (((Count == {5'b00000, PULSENUM}) && 
                   (PULSESHFT != 3'b000)))
                  ActualPW <= (ActualBitPeriod) -
                              (PULSESHFT) * (UartBaud);
                else if ((((Count >= {5'b00000, SPNUM}) && (Count <= EPNUM)) &&
                        (SHFT != 2'b00)))
                  ActualPW <= (ActualBitPeriod) - (SHFT) 
                              * ({1'b0, UartBaud[15:1]});
              end
            else
              ActualPW <= ActualBitPeriod;
           
            // Initialising bitperiod counter and increment bit count
            // Assign Next SIROUT bit 
            if (Bitperiodcount == ActualPW)
              begin
                Nextbitcount <= (Bitcount) - 1;
                if (TxData[((Bitcount) - 1)] == 1)
                  NextSIROUT <= 1'b1;
                else
                  NextSIROUT <= 1'b0;

                NxtBitperiodcnt <= 20'h00001;
                Nextcount       <= (Count) +1;
                NextTXData      <= TxData[((Bitcount) - 1)];
              end 
            // Increment bitperiod counter
            else 
      
              // SIROUT held low till Pulse width if data bit is zero
              if (TXDatabit == 1'b0)
                if (Bitperiodcount == PWidth)
                  begin
                    NextSIROUT <= 1'b1;
                    NxtBitperiodcnt <= (Bitperiodcount) + 1;
                  end
                else
                  NxtBitperiodcnt <= (Bitperiodcount) + 1;
              else    
                begin
                  NextSIROUT <= 1'b1;
                  NxtBitperiodcnt <= (Bitperiodcount) + 1;
                end

          end
        // Transmit Stop bit
        else
          begin
            // Determining actual pulse width for the Stop bit
            if (BITSFTEN == 1'b1)
              begin
                if (((Count == {5'b00000, PULSENUM}) && 
                   (PULSESHFT != 3'b000)))
                  ActualPW <= (ActualBitPeriod) - 
                              (PULSESHFT) * (UartBaud);
                else if ((((Count == {5'b00000, EPNUM})) && (SHFT != 2'b00)))
                  ActualPW <= (ActualBitPeriod) - (SHFT) 
                             * ({1'b0, UartBaud[15:1]});
              end
            else
              ActualPW <= ActualBitPeriod;

            if (Bitperiodcount == ActualPW)
              begin 
                // Stoptbit transmitted fully
                // Deassert Next Frame Read Pointer increment enable signal
                // Start Next transmission only if data is available in FIFO
                // or Read Pointer increment is done
                if ((RdPtrIncDone == 1'b0) || ((TXDataAvlbl == 1'b1) 
                    && (TXFRdPtrInc == 1'b1)))
                  begin
                    NextStarttx     <= 1'b1;
                    NxtBitperiodcnt <= 20'h00000;
                  end
                else
                  NextTXBUSY <= 1'b0; 

                Nextcount       <= 8'h00;
                NextTXFRdPtrInc <= 1'b0;
                NextSIROUT      <= 1'b1;
              end

            // Increment bitperiod counter
            // Assert Next Frame Read Pointer Increment enable signal
            else
              begin
                if (TXDatabit == 1'b0)
                  
                  // SIROUT held low till Pulse width if data bit is zero 
                  if (Bitperiodcount == PWidth)
                    begin
                      NextSIROUT      <= 1'b1;
                      NxtBitperiodcnt <= (Bitperiodcount) + 1 ;
                    end
                  else
                    NxtBitperiodcnt <= (Bitperiodcount) + 1 ;
                else
                  begin
                    NextSIROUT      <= 1'b1;
                    NxtBitperiodcnt <= (Bitperiodcount) + 1 ;
                  end

                // Assert Next Frame Read Pointer Increment enable signal
                // after Stopbit pulse is transmitted
                if (Bitperiodcount == PWidth)
                  NextTXFRdPtrInc <= 1'b1;
              end
          end

      // Reinitialize Idle State Settings
      else 
        begin
          Nextbitcount    <= 8'h00;
          Nextcount       <= 8'h00;
          NxtBitperiodcnt <= 20'h00000;
          NextStarttx     <= 1'b1;
          NextTXData      <= 1'b1;
          NextSIROUT      <= 1'b1;
          NextTXBUSY      <= 1'b0;
        end
    end

  // Reinitialize Idle State Settings
  else
    begin
      Nextbitcount    <= 8'h00;
      NxtBitperiodcnt <= 20'h00000;
      Nextcount       <= 8'h00;
      NextStarttx     <= 1'b1;
      NextTXData      <= 1'b1;
      NextSIROUT      <= 1'b1;
      NextTXBUSY      <= 1'b0;
      NextTXFRdPtrInc <= 1'b0;
    end
  
end // p_StateCombo

endmodule

// ============================== End  =========================================
