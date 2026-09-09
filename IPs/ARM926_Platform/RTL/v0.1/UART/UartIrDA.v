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
//  File Name              : UartIrDA.v.rca
//  File Revision          : 1.4
//
//  Release Information    :  PrimeCell(TM)-PL011-REL1v3
//
// -----------------------------------------------------------------------------
// Purpose     : This block is the IrDA encoder/decoder
// --=========================================================================--

`timescale 1ns/1ps

module UartIrDA(
                UARTCLK,
                nUARTRST,
                Baud16,
                IrLPBaud16,
                SIRLPSync,
                SIRENSync,
                SIRTEST,
                StopBaudCnt,
                TXBUSY,
                RXBUSY,
                TXD,
                SIRINSync,
                UARTRXDSync,
                UARTTXDint,
                RXD,
                nSIROUTint
               );

input        UARTCLK;       // Main UART Clock
input        nUARTRST;      // Muxed reset (from nUARTRST)
input        Baud16;        // Bit Period reference
input        IrLPBaud16;    // Low Power pulse width ref
input        SIRLPSync;	    // Low power mode enable
input        SIRENSync;	    // SIR Enable
input        SIRTEST;	    // SIR duplex enabled
input        StopBaudCnt;   // Stop baud counter
input        TXBUSY;	    // UART Transmitter busy
input        RXBUSY;	    // UART Receiver busy
input        TXD;	    // From UART Transmitter
input        SIRINSync;	    // Sync'ed SIR serial input
input        UARTRXDSync;   // Synced serial receive input

output        UARTTXDint;   // Made inactive if SIR enabled
output        RXD;	    // Decoded signal to UART Receiver
output        nSIROUTint;   // SIR Encoded transmit bit stream

// -----------------------------------------------------------------------------
//
//                     UartIrDA
//                     ========
//
// -----------------------------------------------------------------------------
// Overview
// ========
//  This block contains the encoder and decoder required to encode
// and decode the bit stream into a stream compatible with IrDA
// standards. A 1'b0 is transmitted as a pulse while a 1'b1 is
// encoded as no pulse. In the normal mode, the pulse is 3 Baud16
// periods wide. In the low-power mode, the pulse is 3 IrLPBaud16
// periods wide. Glitches on the SIRIN line are rejected by oversampling
// Both in Normal and Low-Power modes, start bits which are less than
// one period of IrLPBaud16 are rejected by the glitch rejection logic.
// IrDA is a half-duplex protocol by specification. Although this
// implementation prevents simultaneous transmission and reception in
// normal mode, software has to ensure that no transmit data is present
// in the transmit FIFO when IrDA reception is in progress. This is
// because the UART receive state machine goes to the idle state at the
// end of every byte of data and there is no way of being sure that
// there is no further data to be received.
//
//
// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
// Wire declaration
// -----------------------------------------------------------------------------
wire        UARTCLK;
// Main UART Clock                                    (Module Input)

wire        nUARTRST;
// Muxed reset (from nUARTRST)                        (Module Input)

wire        Baud16;
// Bit Period reference                               (Module Input)

wire        IrLPBaud16;
// Low Power pulse width ref                          (Module Input)

wire        SIRLPSync;	
// Low power mode enable                              (Module Input)

wire        SIRENSync;	
// SIR Enable                                         (Module Input)

wire        TXBUSY;	
// UART Transmitter busy                              (Module Input)

wire        RXBUSY;	
// UART Receiver busy                                 (Module Input)

wire        SIRTEST;	
// SIR duplex enabled                                 (Module Input)

wire        TXD;	
// From UART Transmitter                              (Module Input)

wire        SIRINSync;	
// Sync'ed SIR serial input                           (Module Input)

wire        UARTRXDSync;
// Synced serial receive input                        (Module Input)

wire        StopBaudCnt;
// Stop baud counter                                  (Module Input)

wire   TCStartEn;
// Used to generate the TCStart signal

wire   SIRINStag2Final;
// Combined value of SIRINStag2

wire   IrRXBUSY;
wire   IrTXBUSY;
// Used to decide full or half duplex mode

// -----------------------------------------------------------------------------
// Register declaration
// -----------------------------------------------------------------------------
reg        UARTTXDint;	
// Made inactive if SIR enabled                       (Module Output)

reg        RXD;	
// Decoded signal to UART Receiver                    (Module Output)

reg        nSIROUTint;	
// SIR Encoded transmit bit stream                    (Module Output)

reg   NextSIROUT;
// D-input for Sirout

reg   NmSirout;
// normal mode output

reg   NextNmSirout;
// D-input for normal mode output

reg   PdSirout;
// low power mode output

reg   NextPdSirout;
// D-input for low power mode output

reg   NextUARTTXD;
// D-input for UARTTXDint

reg   NextRXD;
// D-input for RXD

reg   PdTCload;
// Enable reg for the counter PdTcount

reg   NextPdTCload;
// D-input for the  PdTcount reg

reg   TCStart;
// Enable reg for the counter Tcount

reg   NextTCStart;
// D-input for the Tcount signal

reg   Flag;
// Used to prevent more than one pulse in one bit time in low power mode

reg   NextFlag;
// D-input for the Flag signal

reg   Rload;
// enable signal for the counter Rcount

reg   NextRload;
// D-input for the Rload signal

reg   SIRINStag1;
// 1st sample of SIRINSync

reg   NextSIRINStag1;
// D-input for SIRINStag1 signal;

reg   SIRINStag1a;
// 1st A sample of SIRINSync

reg   NextSIRINStag1a;
// D-input for SIRINStag1a signal;

reg   SIRINStag2;
// 2ed sample of SIRINSync

reg   NextSIRINStag2;
// D-input for SIRINStag2 signal;

reg   SIRINStag2a;
// 2ed A sample of SIRINSync

reg   NextSIRINStag2a;
// D-input for SIRINStag2a signal;

reg   [3:0] Tcount;
// Used in transmitter module to determine one bit period

reg   [3:0] Rcount;
// Used in the receiver module to determine one bit period

reg   [3:0] NextTcount;
// D-input for the counter Tcount

reg   [3:0] NextRcount;
// D-input for the counter Rcount

reg   [1:0] PdTcount;
// Used in low power mode to determine pulse width

reg   [1:0] NextPdTcount;
// D-input for the counter PdTcount

reg   SIRENSyncEoc;
// SIR enable signal for end of Character

// -----------------------------------------------------------------------------
//
// Main Verilog code
// =================
//
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Output synchronising with UARTCLK
// -----------------------------------------------------------------------------
always @(posedge UARTCLK or negedge nUARTRST)
begin : p_SyncOut
  if (nUARTRST == 1'b0)
    begin
      UARTTXDint    <= 1'b1;
      nSIROUTint    <= 1'b0;
      RXD       <= 1'b1;
    end
  else
    begin
      UARTTXDint  <= NextUARTTXD;
      nSIROUTint  <= NextSIROUT;
      RXD     <= NextRXD;
    end
end // p_SyncOut;


always @(posedge UARTCLK or negedge nUARTRST)
begin : p_SIRENSyncEoc
  if (nUARTRST == 1'b0)
    SIRENSyncEoc <= 1'b0;
  else if (StopBaudCnt == 1'b1)
      SIRENSyncEoc <= SIRENSync;
end // p_SIRENSyncEoc;

// -----------------------------------------------------------------------------
// Output module // combining normal and powerdown modes
// -----------------------------------------------------------------------------
always @ (SIRENSyncEoc or SIRLPSync or PdSirout or TXD or  NmSirout)
begin : p_Out
  if (SIRENSyncEoc == 1'b0)
    begin
      NextUARTTXD  = TXD;
      NextSIROUT   = 1'b0;
    end
  else
    begin
      NextUARTTXD  = 1'b1;
      NextSIROUT   =  (((!SIRLPSync) & (NmSirout)) | ((SIRLPSync) &
                         (PdSirout)));
    end
end // p_Out;

assign TCStartEn =  ( !((Tcount == 4'b1111) && (TXD == 1'b1)));

// -----------------------------------------------------------------------------
// This always @ primarily implements the transmitter counter. It is a
// 4-bit counter enabled by the Baud16 and TCStart signals. When a low
// level is detected on the TXD line, the counter is loaded with 15 and
// the TCStart bit is set. As long as this bit is set, the counter
// decrements by 1 on sampling a Baud16 pulse. At the end of the bit
// period (counter == 15), if the TXD line is sampled low, the TCStart
// bit is maintained high. The counter decrements by 1 and the whole
// always @ repeats for the next bit. If the TXD line is sampled high,
// the TCStart bit is cleared. To support half duplex mode operation,
// the TCStart bit and the counter are reset when the IrRXBUSY signal
// becomes active.
// -----------------------------------------------------------------------------
always @(SIRENSyncEoc or Tcount or TCStart or TXD or Baud16 or
          IrRXBUSY or  TCStartEn)
begin : p_TransCountLoad
  NextTcount     = Tcount;
  NextTCStart    = TCStart;
  if (SIRENSyncEoc == 1'b0)
    begin
      NextTcount   = 4'b0000;
      NextTCStart  = 1'b0;
    end
  else if (IrRXBUSY == 1'b1)
    begin
      NextTcount   = 4'b0000;
      NextTCStart  = 1'b0;
    end
  else if ((TXD == 1'b0) && (TCStart == 1'b0))
    begin
      NextTcount   = 4'b1111;
      NextTCStart  = 1'b1;
    end
  else if ((TCStart == 1'b1) && (Baud16 == 1'b1))
    begin
      NextTcount   = ((Tcount) - 1'b1);
      NextTCStart  = TCStartEn;
    end
end // p_TransCountLoad;

// -----------------------------------------------------------------------------
// Set the transmitter output high for 3 Baud16 periods in normal mode
// -----------------------------------------------------------------------------
always @ (Tcount or SIRENSyncEoc or SIRLPSync or NmSirout)
begin : p_TransmitterOut1
  if (SIRENSyncEoc == 1'b0)
    NextNmSirout = 1'b0;
  else if ((SIRLPSync == 1'b0) &&
           ((Tcount == 4'b1010) || (Tcount == 4'b1001)
            || (Tcount == 4'b1000)))
    NextNmSirout = 1'b1;
  else if (SIRLPSync == 1'b0)
    NextNmSirout = 1'b0;
  else
    NextNmSirout = NmSirout;
end // p_TransmitterOut1;

always @ (posedge UARTCLK  or negedge nUARTRST)
begin : p_Transmitter_clk
  if (nUARTRST == 1'b0)
    begin
      Tcount        <= 4'b0000;
      NmSirout      <= 1'b0;
      TCStart       <= 1'b0;
    end
  else
     begin
        NmSirout    <= NextNmSirout;
        TCStart     <= NextTCStart;
        Tcount      <= NextTcount;
      end
  end // p_Transmitter_clk;

// -----------------------------------------------------------------------------
// This always @ implements the low power section of the transmitter.
// In the low power mode, bit period timing commences when the Tcount
// counter reaches a value of 10. At this count, the PdTCload is set
// high. When the next IrLPBaud16 pulse is sampled, the PdTcount counter
// is loaded with 3. The transmitter output is driven high and
// maintained for 3 IrLPBaud16 periods. The PdTCload bit is cleared
// along with the transmitter output. Simultaneously, a Flag bit is set
// to prevent reassertion of the transmitter output within the same bit
// period, in cases where the Baud16 frequency is much lower than the
// IrLPBaud16 frequency.
// -----------------------------------------------------------------------------
always @ ( SIRENSyncEoc or Tcount or SIRLPSync or PdTcount or
           IrLPBaud16 or Flag or  PdSirout or PdTCload)
begin : p_LowPtransCountLoad
  NextFlag         = Flag;
  NextPdSirout     = PdSirout;
  NextPdTcount     = PdTcount;
  NextPdTCload     = PdTCload;
  if (SIRENSyncEoc == 1'b0)
    begin
      NextPdTcount   = 2'b00;
      NextPdSirout   = 1'b0;
      NextFlag       = 1'b0;
      NextPdTCload   = 1'b0;
    end
  else if ((Tcount == 4'b1010) && (SIRLPSync == 1'b1) &&
         (PdTCload == 1'b0) && (Flag == 1'b0))
    NextPdTCload = 1'b1;
  else if ((PdTCload == 1'b1) && (IrLPBaud16 == 1'b1)
         && (PdSirout == 1'b0))
    begin
      NextPdTcount   = 2'b11;
      NextPdSirout   = 1'b1;
    end
  else if ((PdTCload == 1'b1) && (IrLPBaud16 == 1'b1)) begin
    if (PdTcount == 2'b01)
      begin
        NextPdSirout = 1'b0;
        NextFlag     = 1'b1;
        NextPdTCload = 1'b0;
      end
    else
      NextPdTcount = ((PdTcount) - 1'b1);
  end else if (Tcount == 4'b1111)
    NextFlag       = 1'b0;
end // p_LowPtransCountLoad;

always @(posedge UARTCLK or negedge nUARTRST)
begin : p_Transmitter_2mclk
  if (nUARTRST == 1'b0)
    begin
      PdTcount      <= 2'b00;
      PdSirout      <= 1'b0;
      PdTCload      <= 1'b0;
      Flag          <= 1'b0;
    end
  else
    begin
        PdSirout    <= NextPdSirout;
        PdTcount    <= NextPdTcount;
        PdTCload    <= NextPdTCload;
        Flag        <= NextFlag;
    end
end // p_Transmitter_2mclk;

// -----------------------------------------------------------------------------
// This always @ implements the glitch rejection logic in the receiver
// section of the IrDA.
// Glitch rejection is performed by sampling the SIRINsync line on the
// IrLPBaud16 clock using two pipeline stages. Glitches of width less
// than one period of IrLPBaud16 are rejected using this method.
// Signals of width more than one period of IrLPBaud16 but less than two
// periods of IrLPBaud16 may or may not be taken as a glitch. Signals of
// width more than two IrLPBaud16 periods are taken as valid signals.
// -----------------------------------------------------------------------------
always @(posedge UARTCLK or negedge nUARTRST)
begin : p_deglitcher_clk
  if (nUARTRST == 1'b0)
    begin
      SIRINStag1  <= 1'b1;
      SIRINStag2  <= 1'b1;
      SIRINStag1a <= 1'b1;
      SIRINStag2a <= 1'b1;
    end
  else
    begin
        SIRINStag1  <= NextSIRINStag1;
        SIRINStag2  <= NextSIRINStag2;
        SIRINStag1a <= NextSIRINStag1a;
        SIRINStag2a <= NextSIRINStag2a;
    end
end // p_deglitcher_clk;

// -----------------------------------------------------------------------------
// The following detects for a low on SIRINSync of at least 1IrLPBaud16 cycle
//  with the registers being updated based on IrLPBaud16 being equal to 1.
// -----------------------------------------------------------------------------
always @(SIRINSync or SIRINStag1 or IrLPBaud16)
begin : p_deglitcher1
  if(IrLPBaud16 == 1'b1)
    NextSIRINStag1 = SIRINSync;
  else
    NextSIRINStag1 = SIRINStag1;
end // p_deglitcher1;

always @(SIRINSync or SIRINStag1 or SIRINStag2 or IrLPBaud16)
begin : p_deglitcher2
  if ((IrLPBaud16 == 1'b1) && (SIRINStag1 == SIRINSync))
    NextSIRINStag2 = SIRINStag1;
  else
    NextSIRINStag2 = SIRINStag2;
end // p_deglitcher2;

// -----------------------------------------------------------------------------
// The following detects for a low on SIRINSync of at least 1IrLPBaud16 cycle
//  with the registers being updated based on IrLPBaud16 being equal to 0.
// -----------------------------------------------------------------------------
always @(SIRINSync or SIRINStag1a or IrLPBaud16)
begin : p_deglitcher1a
  if(IrLPBaud16 == 1'b0)
    NextSIRINStag1a = SIRINSync;
  else
    NextSIRINStag1a = SIRINStag1a;
end // p_deglitcher1a;

always @(SIRINSync or SIRINStag1a or SIRINStag2a or IrLPBaud16)
begin : p_deglitcher2a
  if ((IrLPBaud16 == 1'b0) && (SIRINStag1a == SIRINSync))
    NextSIRINStag2a = SIRINStag1a;
  else
    NextSIRINStag2a = SIRINStag2a;
end // p_deglitcher2a;

// -----------------------------------------------------------------------------
// With the above two detections, should catch all SIRINSync pulses which are
// at least 1 IrLPBaud16 pulse wide.
// -----------------------------------------------------------------------------
assign SIRINStag2Final = ((SIRINStag2 == 1'b0) || (SIRINStag2a == 1'b0))
                         ? 1'b0 : 1'b1;

// -----------------------------------------------------------------------------
// This always @ converts the valid input bit stream into a stream
// compatible with IrDA standards. The default value of SIRINStag2Final is 1.
// When a low is detected on this line, a 4 bit counter Rcount is
// loaded with a value of 12 and the RXD line is pulled low on the next
// Baud16 clock. The RXD line is held low until the counter rolls over
// from 1 to 0. To support half duplex mode of operation, the counters
// and control signals are reset on sampling the IrTXBUSY line high.
// The RXD line is also restored to its default value of high.
// -----------------------------------------------------------------------------
always @ (SIRENSyncEoc or SIRINStag2Final or Baud16 or  Rcount or Rload or
          RXD or IrTXBUSY or UARTRXDSync) 
begin : p_Receiver
  NextRXD              = RXD;
  NextRload            = Rload;
  NextRcount           = Rcount;
  if (SIRENSyncEoc == 1'b0)
    begin
      NextRXD          = UARTRXDSync;
      NextRload        = 1'b0;
      NextRcount       = 4'b0000;
    end
  else if (IrTXBUSY == 1'b1)
    begin
      NextRXD          = 1'b1;
      NextRload        = 1'b0;
      NextRcount       = 4'b0000;
    end
  else if ((SIRINStag2Final == 1'b0) && (Rload == 1'b0))
      NextRload      = 1'b1;
  else if ((Baud16 == 1'b1) && (Rload == 1'b1))
  begin
    if( Rcount == 4'b0000)
      begin
        NextRcount   = 4'b1100;
        NextRXD      = 1'b0;
        NextRload    = Rload;
      end
    else if (Rcount == 4'b0001)
      begin
        NextRcount   = 4'b0000;
        NextRload    = 1'b0;
        NextRXD      = 1'b1;
      end
    else
    NextRcount   = ((Rcount) - 1'b1);
  end
end // p_Receiver;

// -----------------------------------------------------------------------------
// The use of the SIRTEST signal in the following two
// equations enables full duplex operation in test mode.
// -----------------------------------------------------------------------------

assign  IrRXBUSY  = ( !(SIRTEST)) & (RXBUSY);
assign  IrTXBUSY  = ( !(SIRTEST)) & (TXBUSY);

always @(posedge UARTCLK or negedge nUARTRST)
begin : p_Receiver_clk
  if (nUARTRST == 1'b0)
    begin
      Rload     <= 1'b0;
      Rcount    <= 4'b0000;
    end
  else
    begin
      Rload     <= NextRload;
      Rcount    <= NextRcount;
    end
end // p_Receiver_clk;

endmodule

// -=========================== End of UartIrDA ==============================--

