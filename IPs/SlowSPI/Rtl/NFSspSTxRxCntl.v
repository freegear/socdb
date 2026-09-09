// --=========================================================================--
//  This confidential and proprietary software may be used only as
//  authorised by a licensing agreement from ARM Limited
//    (C) COPYRIGHT 2000-2001 ARM Limited
//        ALL RIGHTS RESERVED
//  The entire notice above must be reproduced on all authorised
//  copies and copies may only be made to the extent permitted
//  by a licensing agreement from ARM Limited.
//  ----------------------------------------------------------------------------
//
//  Version and Release Control Information:
//
//  File Name              : SspSTxRxCntl.v.rca
//  File Revision          : 1.3
//
//  Release Information    : PrimeCell(TM)-PL022-REL1v2
//
//  ----------------------------------------------------------------------------
 
//  ----------------------------------------------------------------------------
// Purpose          : This block consists of the SSP Slave's Transmit/Receive
//                    control state machine.
//
// --=========================================================================--
 
`timescale 1ns/1ps
 
// -----------------------------------------------------------------------------

module NFSspSTxRxCntl ( 
// Inputs              
                     PCLK, 
                     PRESETn, 
                     TXD,
                     nOE, 
                     DSS, 
                     SPO, 
                     SPH,
                     CLKINSync , 
                     FSSINSync, 
                     SSESync, 
                     MSSync, 
                     SODSync, 
                     TxFRdDataIn, 
                     TxFRdPtrInc,
                     RxFWr, 
                     TxRxBSY,
                     IntSSPRXD , 
// Outputs
                     NxtSTxFRdPtrInc,
                     NextSTxRxBSY,
                     NextSRxFWr, 
                     NextnSOE, 
                     NextSTXD, 
                     SRxFWrData,
                     SRxRT
                    );

// Include Defs file
`include "NFSspDefs.v"

// Inputs
input         PCLK;                   // Main SSP clock
input         PRESETn;                  // Muxed reset (from PRESETn)
input         TXD;                      // Serial transmit output
input         nOE;                      // Output enable for TXD
input   [3:0] DSS;                      // Bits per frame
input         SPO;                      // SCLK polarity
input         SPH;                      // SCLK phase
input         CLKINSync;                // Serial clock input
input         FSSINSync;                // Serial frame input
input         SSESync;                  // SSP enable
input         MSSync;                   // Master/Slave Select bit
input         SODSync;                  // Serial Output Disable bit 
input  [15:0] TxFRdDataIn;              // Lft justified TxData
input         TxFRdPtrInc;              // Tx FIFO read ptr incr.
input         RxFWr;                    // Rx FIFO write enable
input         TxRxBSY;                  // SSP Tx/Rx controller busy
input         IntSSPRXD;                // Loopback muxed SSPRXD

// Outputs
output        NxtSTxFRdPtrInc;          // D-input of Slave's Tx FIFO read ptr 
                                        // increment signal
output        NextSTxRxBSY;             // D-input of Slave's TX - RX busy 
                                        // signal
output        NextSRxFWr;               // D-input of Slave's Rx FIFO write 
                                        // enable
output        NextnSOE;                 // D-input of Output enable for TXD
output        NextSTXD;                 // D-input of Serial transmit output
output [15:0] SRxFWrData;               // Rx FIFO write data
output        SRxRT;                    // Slave Rx Reload Timeout
                                        // counter  signal

// -----------------------------------------------------------------------------
//
//                             SspSTxRxCntl 
//                             ============
//
// -----------------------------------------------------------------------------
//
// Overview                           
// ========
//
//  This block constitutes the main transmit / receive control logic in the
// SSP Slave. Transmit data is first loaded into a 15-bit Transmit Shift 
// Register and bits are shifted out onto the TXD output line (MSBit first).
// The MSB of TxFRdDataIn is transmitted as the first bit of the frame and at 
// the same time, the other 15 bits are loaded into the transmit shift register.
// Receive data sampled on the IntSSPRXD input is shifted into an internal RX
// shift register. When the last data bit is sampled on the IntSSPRXD input, 
// it is copied into the Receive Buffer along with the contents of the receive 
// shift register. Thus, the receive shift register is 15 bits wide and the 
// receive buffer is 16 bits wide.
//
//  Interaction with the Transmit FIFO occurs through the TxFRdPtrIncSync 
// signal. 
// The NxtSTxFRdPtrInc signal is toggled at the beginning of the frame 
// after the transmit data has been copied into the Transmit Shift register.
// The combined TxFRdPtrInc signal from both master and slave is double-
// synchronised to the PCLK domain and then fed to the TxFIFO. In
// order to ensure that the signal gets synchronised to PCLK and is seen by the
// Transmit FIFO, the signal is kept stable for one frame duration. As the 
// frequency of PCLK is equal to or greater than that of PCLK, this 
// signal is assured to be seen in the PCLK domain.
//
//  In the TI mode, NxtSTxFRdPtrInc signal is toggled at the first rising edge 
// of SCLKIN after the SFSSIN pulse as it denotes the start of a new frame of 
// data. In the NM mode, this signal is toggled when the slave transmits the MSB
// of the transmit data to the master. In the SPI mode, the NxtSTxFRdPtrInc 
// signal is toggled on detecting the next edge of SCLKIN after the MSB of a new
// frame of data has been transmitted. 
//
//  Interaction with the Receive FIFO occurs through the RxFWr signal which
// is toggled when the last bit of a data frame is being received. 
//
//  The BitPeriodCnt counter in this module is an 8-bit down counter that
// is used to time the phase duration of SCLK. This counter is clocked by
// PCLK and counts down with every SSPCLKDIV pulse. To time one SCLK
// phase duration, this counter is loaded with the SCR value and when the
// count reaches zero, one SCLK phase duration is said to have elapsed.
// The BitCnt counter counts the number of bits that have been transmitted
// and received. For the TI Synchronous serial frame format and the
// Motorola SPI frame format, this counter is initially loaded with DSS and
// is decremented by 1 after one bit has been transmitted and received. In
// the National Microwire frame format, this counter is loaded with 7 at the 
// start of reception and with DSS at the start of transmission.
//
//  The nOE output signal is the output enable signal for the TXD
// output.  This signal is meant to drive the output enable pin of the pad
// to which TXD is connected. To account for pad delays, nOE is
// asserted one SCLK phase time  before and after TXD is supposed to be
// valid. While de-asserting nOE, it is done only after the last bit has been 
// fully transmitted. Any change in SOD in the middle of a transmission will
// affect the transmit line only when the SSP slave starts transmitting the next
// frame.

// -----------------------------------------------------------------------------
// Register declarations
// -----------------------------------------------------------------------------
reg        NextSTxRxBSY;
// D-input for TxRxBSY signal

reg        NextnSOE;
// D-input for nOE

reg        NextSTXD;
// D-input for TXD signal
 
reg        NxtSTxFRdPtrInc;
// D-input for TXFIFO's Read Ptr Increment Signal when the SSP is in Slave Mode 

reg        NextSRxFWr;
// D-input for RXFIFO's Write Ptr Increment Signal when the SSP is in Slave Mode
 
reg        DelCLKINSync;
// Delayed version of synchronised SCLK signal

reg        IntSOD;
// SOD value applicable to the current frame 

reg        NextIntSOD;
// D-input for IntSOD 

/*reg  [7:0] BitPeriodCnt;
// Bit Period Counter 

reg  [7:0] NextBitPeriodCnt;
// D-input for BitPeriodCnt
*/
reg  [3:0] BitCnt; 
// Bit Counter to track the number of bits transmitted/received

reg  [3:0] NextBitCnt;
// D-input for Bit Counter

reg [15:0] SRxFWrData;
// Data to be written to Rx FIFO 

reg  [4:0] SspSTxRxState;
// State Register for the SSP Slave state machine 
 
reg  [4:0] NxtSspSTxRxState;
// D-input of SspSTxRxState

reg [15:0] NextRxFWrData;
// D-input for Data to be written to Rx FIFO
 
reg [14:0] TxShft;
// Transmit Shift Register

reg [14:0] NextTxShft;
// D-input for Transmit Shift Register

reg [14:0] RxShft;
// Receive Shift Register

reg [14:0] NextRxShft;
// D-input for Receive Shift Register

// -----------------------------------------------------------------------------
// Wire declarations
// -----------------------------------------------------------------------------
wire TxFRdPtrInc;
// TxFIFO Read Ptr Increment signal

wire RxFWr;
// RxFIFO Write Ptr Increment signal

wire TxRxBSY;
// Busy bit denoting that SSP Slave block is transmitting or receiving

wire nOE;
// TXD Output Enable Signal

wire TXD;
// Transmit Data bit

//wire BitPeriodCmp;
// Bit Period Comparator

wire BitCmp;
// Bit Comparator

wire SCLKINPosTrigger;
// Set when a rising edge is detected on SCLKIN

wire SCLKINNegTrigger;
// Set when a falling edge is detected on SCLKIN

wire SCLKINEdgeTrigger;
// Set when it detects either rising or falling SCLK edges

wire TIXmitEn;
// TI Transmit Enable Signal

wire TISampleEn;
// TI Receive Enable Signal

wire NMXmitEn;
// NM Transmit Enable Signal

wire NMSampleEn;
// NM Receive Enable Signal

wire SPIXmitEn;
// SPI Transmit Enable Signal

wire SPISampleEn;
// SPI Receive Enable Signal

// -----------------------------------------------------------------------------
//
// Main body of code
// =================
//
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Comparators for Bit Period counter and Bit counter
// -----------------------------------------------------------------------------
//assign BitPeriodCmp   = (BitPeriodCnt[7:0] == 8'b00000000);
assign BitCmp         = (BitCnt[3:0] == 4'b0000);

// -----------------------------------------------------------------------------
// Detection of edges on SCLKIN
// -----------------------------------------------------------------------------
assign SCLKINPosTrigger  =  CLKINSync & ~DelCLKINSync;
assign SCLKINNegTrigger  = ~CLKINSync & DelCLKINSync;
assign SCLKINEdgeTrigger =  SCLKINPosTrigger | SCLKINNegTrigger;

// -----------------------------------------------------------------------------
// Slave Rx Reload Timeout counter signal
// -----------------------------------------------------------------------------
assign SRxRT = SCLKINEdgeTrigger;

// -----------------------------------------------------------------------------
// Assigning XmitEn and SampleEn signals in TI, NM and Motorola Modes   
// -----------------------------------------------------------------------------
assign TIXmitEn       = SCLKINPosTrigger;
assign TISampleEn     = SCLKINNegTrigger; 
assign NMXmitEn       = SCLKINNegTrigger;
assign NMSampleEn     = SCLKINPosTrigger;
assign SPIXmitEn      = ((SCLKINNegTrigger & (SPO ^~ SPH)) | 
                         (SCLKINPosTrigger & (SPO ^ SPH)));
assign SPISampleEn    = ((SCLKINPosTrigger & (SPO ^~ SPH)) | 
                         (SCLKINNegTrigger & (SPO ^ SPH)));

// -----------------------------------------------------------------------------
// State register and outputs
// -----------------------------------------------------------------------------
always @(posedge PCLK or negedge PRESETn) 
begin : p_SlaveFSMSeq
  if (~PRESETn) 
    begin
      SspSTxRxState <= `ST_SSPIIDLE;
      SRxFWrData    <= 16'h0000;
      IntSOD        <= 1'b0;
    end
  else
    begin
      SspSTxRxState <= NxtSspSTxRxState;
      SRxFWrData    <= NextRxFWrData;
      IntSOD        <= NextIntSOD;
    end
end // p_SlaveFSMSeq

// -----------------------------------------------------------------------------
// Output and next state logic generation
// -----------------------------------------------------------------------------
always @(SspSTxRxState or DSS or SPH or SSESync or SODSync or 
         TxFRdDataIn or IntSSPRXD or /*BitPeriodCnt or*/ BitCnt or 
         TxShft or RxShft or/* BitPeriodCmp or*/ BitCmp or TxRxBSY
         or nOE or TXD or FSSINSync or TxFRdPtrInc or RxFWr or SRxFWrData
         or IntSOD or TISampleEn or TIXmitEn or NMXmitEn or NMSampleEn or 
         SPIXmitEn or SPISampleEn or MSSync) 
begin : p_SlaveComb

  // Default assignments
  NxtSspSTxRxState  = SspSTxRxState;
  NextSTxRxBSY      = TxRxBSY;
  NextnSOE          = nOE;
  NextSTXD          = TXD;
  NxtSTxFRdPtrInc   = TxFRdPtrInc;
  NextSRxFWr        = RxFWr;
  NextRxFWrData     = SRxFWrData;
  //NextBitPeriodCnt  = BitPeriodCnt;
  NextBitCnt        = BitCnt;
  NextTxShft        = TxShft;
  NextRxShft        = RxShft;
  NextIntSOD        = IntSOD;

  // If the SSP is disabled, then the SSP should terminate
  // transmission / reception,  initialise the outputs and the 
  // internal variables and transition to the corresponding IDLE state. 

  case (SspSTxRxState)
     // SSP is disabled and FRF is programmed for SPI mode (default mode)
    `ST_SSPIIDLE : 
       begin
         if (MSSync & SSESync & ~FSSINSync) 
           begin
             // Motorola SPI Frame format selected
             // SFRM low when SSP is enabled in slave mode; Transit to NMRXCONT
             // state.
             // Load DSS into the BitCnt counter.
             // Clock-in SOD status in IDLE state into IntSOD signal.
             // Assert OE, if SOD is cleared.
             // Clear the Rx Shift register to start receiving new data.
             // Assert TxRxBSY as a transfer is in progress.
             // Load data into TxShift register and transmit the MSB of the new
             // data.
             // TxFIFO Read Pointer is not incremented, as SFRM can
             // remain low (default value for a Master in TI mode), on a slave 
             // to Master transition.
             NextSTxRxBSY     = 1'b1;
             NextIntSOD       = SODSync;
             NextnSOE         = SODSync;
             NextTxShft       = TxFRdDataIn[14:0];
             NextRxShft       = 15'b000000000000000;
             NextSTXD         = TxFRdDataIn[15];
             NextBitCnt       = DSS[3:0];
             NxtSspSTxRxState = `ST_SSPIRXCONT;
           end
       end

    // Wait for the Sample Enable signal and if synchronised SFRM signal is not
    // set, then sample the IntSSPRXD input and shift it into the Receive shift
    // register. When the last bit is being received or when the Bit Counter
    // is cleared then sample the IntSSPRXD input and latch it into the
    // Receive FIFO write data register. 
    `ST_SSPIRX :
       begin
         if (~SSESync | FSSINSync)
           begin
             // Assign default values to all signals as the SSP is disabled 
             // or SFSSIN is negated midway through a frame.
             NextSTxRxBSY     = 1'b0;
             NextSTXD         = 1'b0;
             NextnSOE         = 1'b1;
             NxtSspSTxRxState = `ST_SSPIIDLE;
           end
         else if (SPISampleEn & BitCmp)
           begin
             // LSB of the data to be received.
             // Clock it into the RX FIFO and increment its write pointer
             // Clear the Rx Shift register to receive the next frame.
             // Sample SODSync as a new frame is about to be transmitted
             // If SOD is cleared, then nOE has to be asserted at the
             // negedge of SCLK.
             if (~SODSync)
               begin
                 NextnSOE   = 1'b0;
               end
             NextIntSOD       = SODSync;
             NextSRxFWr       = ~RxFWr;
             NextRxFWrData    = {RxShft[14:0],IntSSPRXD};
             NextRxShft       = 15'b000000000000000;
             NxtSspSTxRxState = `ST_SSPIFRMCHK;
           end
         else if (SPISampleEn & ~BitCmp)
           begin
             // Receive the next bit of data and decrement bit count
             // Transit to the TX state to transmit next bit
             NextRxShft       = {RxShft[13:0],IntSSPRXD};
             NextBitCnt       = BitCnt - 4'h1;
             NxtSspSTxRxState = `ST_SSPITX;
            end
       end

    // Wait for the TIXmitEn signal and start transmitting the next bit of 
    // the transmit shift register and shift to SPIRX state.
    // If the SSP is disabled, transit to the IDLE state.
    `ST_SSPITX :
       begin
         if (~SSESync | FSSINSync)
           begin
             // Assign default values to all signals as the SSP is disabled 
             // or SFSSIN is negated midway through a frame.
             NextSTxRxBSY     = 1'b0;
             NextSTXD         = 1'b0;
             NextnSOE         = 1'b1;
             NxtSspSTxRxState = `ST_SSPIIDLE;
           end
         else if (SPIXmitEn)
           begin
             // Transmit next bit of data.
             // Shift Tx Shift Register.
             // Transit to RX state to receive next bit.
             NextSTXD         = TxShft[14];
             NextTxShft       = TxShft << 1;
             NxtSspSTxRxState = `ST_SSPIRX;
           end 
       end  

     // Wait for SFRM negation in SPH = 0 mode or else
     // wait for XmitEn in SPH = 1 mode and start transmitting next data.
    `ST_SSPIFRMCHK :
       begin
         if (~SSESync | FSSINSync)
           begin
             // Assign default values to all signals as the SSP is disabled 
             // or SFSSIN is negated midway through a frame.
             NextSTxRxBSY     = 1'b0;
             NextSTXD         = 1'b0;
             NextnSOE         = 1'b1;
             NxtSspSTxRxState = `ST_SSPIIDLE;
           end
         else if (SPIXmitEn & SPH)
           begin
             // Assert nOE, if IntSOD is cleared, else de-assert OE.
             // Load TxShift register and DSS into bitcounter and 
             // transmit MSB of new frame.
             NextnSOE         = IntSOD;
             NextTxShft       = TxFRdDataIn[14:0];
             NextSTXD         = TxFRdDataIn[15];
             NextBitCnt       = DSS[3:0];
             NxtSspSTxRxState = `ST_SSPIRXCONT;  
           end
       end
  
     // Wait for the SampleEn signal with SFRM low to receive the first bit of 
     // data and then increment TXFIFO read pointer. If SFRM is de-asserted
     // transit to IDLE state. 
    `ST_SSPIRXCONT :
       begin
         if (~SSESync | FSSINSync)
           begin
             // Assign default values to all signals as the SSP is disabled 
             // or SFSSIN is negated midway through a frame.
             NextSTxRxBSY     = 1'b0;
             NextSTXD         = 1'b0;
             NextnSOE         = 1'b1;
             NxtSspSTxRxState = `ST_SSPIIDLE;
           end
         else if (SPISampleEn)
           begin
             // Increment the TXFIFO's read pointer as the slave has started 
             // transmitting valid data and receive the first bit of the new 
             // data.
             // Decrement the bit counter and transit to the TX state.
             NxtSTxFRdPtrInc  = TxFRdPtrInc ^ (~IntSOD);
             NextRxShft       = {RxShft[13:0],IntSSPRXD};
             NextBitCnt       = BitCnt - 4'h1;
             NxtSspSTxRxState = `ST_SSPITX;
           end
       end    
    
    // Default values as in SPI state
    default : 
      begin
        NextSTxRxBSY     = 1'b0;
        NextnSOE         = 1'b1;
        NextSTXD         = 1'b0;
        NextRxFWrData    = 16'h0000;
        NxtSspSTxRxState = 5'b00000;
      end
  endcase
end // process p_SlaveComb;

// -----------------------------------------------------------------------------
// BitPeriod Counter
// -----------------------------------------------------------------------------
/*
always @(posedge PCLK or negedge PRESETn) 
begin : p_BitPeriodCntSeq
  if (~PRESETn) 
    BitPeriodCnt <= 8'b00000000;
  else 
    BitPeriodCnt <= NextBitPeriodCnt;
end // p_BitPeriodCntSeq
*/
// -----------------------------------------------------------------------------
// Bit Counter
// -----------------------------------------------------------------------------
always @(posedge PCLK or negedge PRESETn) 
begin : p_BitCntSeq
  if (~PRESETn) 
    BitCnt <= 4'b0000;
  else
    BitCnt <= NextBitCnt;
end // p_BitCntSeq

// -----------------------------------------------------------------------------
// Slave's Transmit Shift Register 
// -----------------------------------------------------------------------------
always @(posedge PCLK or negedge PRESETn) 
begin : p_SSPTXSeq
  if (~PRESETn) 
    TxShft <= 15'b000000000000000;
  else
    TxShft <= NextTxShft;
end // p_SSPTXSeq

// -----------------------------------------------------------------------------
// Receive Shift Register
// -----------------------------------------------------------------------------
always @(posedge PCLK or negedge PRESETn) 
begin : p_RXShftSeq
  if (~PRESETn) 
    RxShft <= 15'b000000000000000;
  else
    RxShft <= NextRxShft;
end // p_RXShftSeq

// -----------------------------------------------------------------------------
// Delayed version of synchronised SCLKIN signal
// -----------------------------------------------------------------------------
always @(posedge PCLK or negedge PRESETn) 
begin : p_DelSCLKSeq
  if (~PRESETn) 
    DelCLKINSync <= 1'b0; 
  else
    DelCLKINSync <= CLKINSync;
end // p_DelSCLKSeq
endmodule

// --================================== End ==================================--
