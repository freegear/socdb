// --=========================================================================--
//  This confidential and proprietary software may be used only as
//  authorised by a licensing agreement from ARM Limited
//    (C) COPYRIGHT 2000 ARM Limited
//        ALL RIGHTS RESERVED
//  The entire notice above must be reproduced on all authorised
//  copies and copies may only be made to the extent permitted
//  by a licensing agreement from ARM Limited.
// -----------------------------------------------------------------------------
//
//  Version and Release Control Information:
//
//  File Name              : UartDataStp.v.rca
//  File Revision          : 1.4
//
//  Release Information    : PrimeCell(TM)-PL011-REL1v3
//
// -----------------------------------------------------------------------------
//  Purpose    : This state machine detects an idle on the RX input.
// --=========================================================================--

`timescale 1ns/1ps

module UartDataStp (
                     UARTCLK,
                     nUARTRST,
                     Baud16,
                     ReloadWD,
                     RXFESync,
                     RTIMSync,
                     UARTRTICSync,
                     DataStp
                   );

input        UARTCLK;      // Main UART Clock
input        nUARTRST;     // Muxed reset (from nUARTRST)
input        Baud16;       // Stream of UARTCLK-wide pulses
input        ReloadWD;     // Control input from Receiver
input        RXFESync;     // RX FIFO Empty
input        RTIMSync;     // RX Timeout Intr. Mask
input        UARTRTICSync; // RX Timeout Intr. Clear

output       DataStp;      // Receive Idle detected

// -----------------------------------------------------------------------------
//                             UartDataStp
//                             ===========
// -----------------------------------------------------------------------------
//
// Overview
// ========
// This block detects the RX line going idle. If the Receive line goes
// to HIGH state for more than a 32-bit period and if the Receive FIFO
// is not empty, the receive line is said to have gone idle. This is
// signalled by the block output, DataStp. Once set, the DataStp signal
// goes low only after the Receive FIFO is empty or the RX line goes
// active again.
// To time the 32-bit period, the watchdog counter, that counts down
// with every Baud16 pulse, is initially loaded with a value of
// [32 * 16) -1 == 511. This uses the fact that one bit period is equal
//  to 16 times the period of the Baud16 signal.
// -----------------------------------------------------------------------------

`define    ST_ARMED    1'b0
// Idle state

`define    ST_TRIGGER  1'b1
// Run state


// -----------------------------------------------------------------------------
// Encoding style: Gray
// -----------------------------------------------------------------------------
reg  UartDataStpState;
reg  UartDataStpNextState;
reg  NextDataStp;
reg  delUARTRTICSync;
reg  DataStp;

// Registers
reg [8:0] WDCount;
reg [8:0] NextWDCount;

// Comparators
wire WDCmp;

// Aliases
wire ReloadCounter;

wire UARTRTIClr;

// -----------------------------------------------------------------------------
//
// Main Verilog code
// =================
//
// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
// Expansion of aliases...
// -----------------------------------------------------------------------------
assign ReloadCounter = ReloadWD | RXFESync | !(RTIMSync);

// -----------------------------------------------------------------------------
// Expansion of comparators...
// -----------------------------------------------------------------------------
assign WDCmp = (WDCount[8:0] == 9'b000000000) ? 1'b1 : 1'b0;

// -----------------------------------------------------------------------------
// State transition process
// -----------------------------------------------------------------------------
always @(posedge UARTCLK or negedge nUARTRST)
begin : seq

// Set the WDCount to its maximum value of all ones on Reset.

 if (nUARTRST == 1'b0)
   begin
     UartDataStpState <= 1'b0;
     DataStp          <= 1'b0;
     delUARTRTICSync  <= 1'b0;
   end
 else
   begin
     UartDataStpState <= UartDataStpNextState;
     DataStp          <= NextDataStp;
     delUARTRTICSync  <= UARTRTICSync;
   end
end // seq;


// -----------------------------------------------------------------------------
// Receive timeout interrupt clear signal
// signal to clear the interrupt
// -----------------------------------------------------------------------------
assign UARTRTIClr = (UARTRTICSync) &  !(delUARTRTICSync);

// -----------------------------------------------------------------------------
// Output and next state logic generation
// -----------------------------------------------------------------------------
always @(UartDataStpState or RXFESync or Baud16 or ReloadCounter or WDCount
         or WDCmp or RTIMSync or UARTRTIClr or DataStp)
begin : combo
// Default assignments
  UartDataStpNextState = UartDataStpState;
  NextDataStp = 1'b0;
  NextWDCount = WDCount;
  case (UartDataStpState)

     `ST_ARMED :
      // This is the reset state of this machine. The DataStp signal is
      // not asserted and the WDCount counter counts down on  every
      // Baud16 pulse.

      // Reload the watchdog counter whenever there is activity on the
      // Receive line or when the Receive FIFO is empty.
      if ((ReloadCounter) == 1'b1)
          begin
            NextWDCount = 9'b111111111;
            UartDataStpNextState = 1'b0;
          end

      // Keep the watchdog counter counting down so long as the Receive
      // FIFO is not empty.
      else if (( !(ReloadCounter) & Baud16 &  !(WDCmp)) == 1'b1)
         begin
           NextWDCount = (WDCount) - 1'b1;
           UartDataStpNextState = 1'b0;
         end

      // If the watchdog counter has counted down to zero, then assert
      // the DataStp output signal.

       else if ((Baud16 & WDCmp &  !(ReloadCounter)) == 1'b1)
         begin
           UartDataStpNextState = 1'b1;
           NextDataStp = 1'b1;
         end

      // Remain in the S_TRIGGER state till the Receive FIFO contents
      // have been read out or until there is activity on the receive
      // line.

      `ST_TRIGGER :
       // If there is a write to the UARTICR or if the RX FIFO is
       // empty, reload the watchdog counter.

        if ((RXFESync == 1'b1) || (UARTRTIClr == 1'b1) || (RTIMSync == 1'b0))
          begin
            NextWDCount = 9'b111111111;
            UartDataStpNextState = 1'b0;
            NextDataStp = 1'b0;
          end
        else
          begin
            UartDataStpNextState = UartDataStpState;
            NextDataStp = DataStp;
          end
      default :
           UartDataStpNextState = 1'b0;
    endcase
end // combo;

always @(posedge UARTCLK or negedge nUARTRST)
begin : WDCount_seq
  // Set the WDCount to its maximum value of all ones on Reset.

    if (nUARTRST == 1'b0)
      WDCount <= 9'b111111111;
    else
      WDCount <= NextWDCount;
end // WDCount_seq;

endmodule
// --========================== End of UartDataStp ===========================--
