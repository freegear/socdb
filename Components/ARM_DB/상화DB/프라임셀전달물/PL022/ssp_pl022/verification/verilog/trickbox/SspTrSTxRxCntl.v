//  ----------------------------------------------------------------------------
//  This confidential and proprietary software may be used only as
//  authorised by a licensing agreement from ARM Limited
//    (C) COPYRIGHT 1999 ARM Limited
//        ALL RIGHTS RESERVED
//  The entire notice above must be reproduced on all authorised
//  copies and copies may only be made to the extent permitted
//  by a licensing agreement from ARM Limited.
//  ----------------------------------------------------------------------------
//  
//  Version and Release Control Information:
//  
//  File Name              : SspTrSTxRxCntl.v.rca
//  File Revision          : 1.1
//  
//  Release Information    : PrimeCell(TM)-PL022-REL1v2
//  
//  ----------------------------------------------------------------------------
//  
`timescale 1ns/1ps



module SspTrSTxRxCntl (
                       SSPCLK,
                       nSSPRES,
                       ClkEnable,
                       SSESync,
                       SSPCLKDIV,
                       TxDataAvlblSync,
                       Nibmode,
                       DSS,
                       FRF,
                       SCR,
                       SPO,
                       SPH,
                       SPISFRMEn,
                       ESFRM,
                       FRC,
                       TxFRdDataIn,
                       SSPRXD,
                       OD,
                       STxFRdPtrInc,
                       SRxFWr,
                       STxRxBSY,
                       SSPOE,
                       SSPTXD,
                       SCLK,
                       SFRM,
                       RxFWrData
                      );




input         SSPCLK;	        // Main SSP clock
input         nSSPRES;	        // Muxed reset (from nSSPRST)
input         ClkEnable;        // Clock enable
input         SSESync;	        // SSP enable
input         SSPCLKDIV;        // Pre-scaler output
input         TxDataAvlblSync;  // Tx data available
input         Nibmode;	        // Nibble mode count
input   [3:0] DSS;	        // Bits per frame
input   [1:0] FRF;              // Frame format
input   [7:0] SCR;              // Serial clock rate
input         SPO;              // SCLK polarity
input         SPH;	        // SCLK phase
input         SPISFRMEn;        // SFRM de-assertion Enable bit 
                                // in SPI(SPH = 1) continous mode
input   [7:0] ESFRM;            // For Extended SFRM Test
input         FRC;              // For Free running SCLK Test
input  [15:0] TxFRdDataIn;      // Lft justified
input         SSPRXD;	        // Input data from uut  
input         OD;               // Out put disable bit
output        STxFRdPtrInc;     // Tx FIFO read ptr incr.
output        SRxFWr;	        // Rx FIFO write enable
output        STxRxBSY;	        // SSP Tx/Rx controller busy
output        SSPOE;	        // Output enable for SSPTXD
output        SSPTXD;	        // Serial transmit output
output        SCLK;             // Serial clock
output        SFRM;             // Serial frame
output [15:0] RxFWrData;        // Rx FIFO write data
    
// Embedded Verilog declarations...
//--------------------------------------------------------------------------
// Purpose          : This block consists of the main Transmit/Receive
//                    control state machine.
//--------------------------------------------------------------------------
//
//--------------------------------------------------------------------------
//
//                              SspTrSTxRxCntl
//                              ==============
//
//--------------------------------------------------------------------------
//
// Overview
// ========
//
//  This block constitutes the main transmit / receive control logic to test
// the slave logic in the SSP.
// Transmit data is first loaded into a 16-bit Transmit Shift Register
// and bits are shifted out onto the SSPTXD output line (MSBit first).
//  Receive data sampled on the RXDSSIn input is shifted into an internal
// shift register and when a complete frame is received, received data is
// copied into a receive buffer from the shift register. When the last data
// bit is sampled on the RXDSSIn input, it is copied into the Receive
// Buffer along with the contents of the receive shift register. Thus, the
// receive shift register is 15 bits wide and the receive buffer is 16 bits
// wide.
//  Interaction with the Transmit FIFO occurs through the TxFRdPtrInc
// signal.This signal is asserted at the beginning of the frame after the
// transmit data has been copied into the Transmit Shift register.
//  Interaction with the Receive FIFO occurs through the SRxFWr signal which
// is also asserted and de-asserted for the same time duration as the
// TxFRdPtrInc signal.
//  The BitPeriodCnt counter in this module is an 8-bit down counter that
// is used to time the phase duration of SCLK. This counter is clocked by
// SSPCLK and counts down with every SSPCLKDIV pulse. To time one SCLK
// phase duration, this counter is loaded with the SCR value and when the
// count reaches zero, one SCLK phase duration is said to have elapsed.
// When the Nibmode input is asserted,this counter counts down by 17 (0x11)
// with every SSPCLKDIV pulse. Thus in the nibble mode, the 8-bit counter
// counts down as two 4-bit counters.
//  The BitCnt counter counts the number of bits that have been transmitted
// and received. For the TI Synchronous serial frame format and the
// Motorola SPI frame format, this counter is initially loaded with DSS and
// is decremented by 1 after one bit has been transmitted and received. In
// the National Microwire frame format, this counter is loaded with 7 at
// the start of transmission and is loaded with DSS at the start of
// reception.
//  The SSPOE output signal is the output enable signal for the SSPTXD
// output.
// -------------------------------------------------------------------------


// -----------------------------------------------------------------------------
// Parameter declarations
// -----------------------------------------------------------------------------
    parameter [5:0] 
        ST_TIIDLE        = 6'b000000,
        ST_TISFRM2       = 6'b000001,
        ST_TISHIFT1      = 6'b000011,
        ST_TISTG2        = 6'b000010,
        ST_TISHIFT2      = 6'b000110,
        ST_TISSPOE1      = 6'b000111,
        ST_TILASTBIT     = 6'b000101,
        ST_TITXFNE       = 6'b000100,
        ST_TISFRM1       = 6'b001100,
        ST_TIDATAAVLBL   = 6'b001101,
        ST_TISSPOE2      = 6'b001111,
        ST_NMIDLE        = 6'b001110,
        ST_NMDATAAVLBL   = 6'b001010,
        ST_NMSFRM        = 6'b001011,
        ST_NMTXBIT       = 6'b001001,
        ST_NMTXBIT2      = 6'b001000,
        ST_NMWAIT1       = 6'b011000,
        ST_NMWAIT2       = 6'b011001,
        ST_NMRX1         = 6'b011011,
        ST_NMRX2         = 6'b011010,
        ST_NMSFRMLAST    = 6'b011110,
        ST_NMRXLAST      = 6'b011111,
        ST_NMTXFNE       = 6'b011101,
        ST_SPIIDLE       = 6'b011100,
        ST_SPIDATAAVLBL  = 6'b010100,
        ST_SPISFRM       = 6'b010101,
        ST_SPITX1        = 6'b010111,
        ST_SPIRX1        = 6'b010110,
        ST_SPITX2        = 6'b010010,
        ST_SPIRX2        = 6'b010011,
        ST_SPISFRMEND    = 6'b010001,
        ST_SPILASTTX     = 6'b010000,
        ST_SPILASTRX     = 6'b110000,
        ST_SPISD1        = 6'b110001,
        ST_SPISD2        = 6'b110011,
        ST_RESET         = 6'b110010,
        ST_TISFRM3       = 6'b100000;

// -----------------------------------------------------------------------------
// Wire Declarations
// -----------------------------------------------------------------------------

wire        SSPCLK;
// Main SSP clock

wire        nSSPRES;
// Muxed reset (from nSSPRST)

wire        ClkEnable;
// Clock enable

wire        SSESync;
// SSP enable

wire        SSPCLKDIV;
// Pre-scaler output

wire        TxDataAvlblSync;
// Tx data available

wire        Nibmode;
// Nibble mode count

wire  [3:0] DSS;
// Bits per frame

wire  [1:0] FRF;
// Frame format

wire  [7:0] SCR;
// Serial clock rate

wire        SPO;
// SCLK polarity

wire        SPH;
// SCLK phase

wire        SPISFRMEn;
// SFRM de-assertion Enable bit in SPI(SPH = 1) continous mode

wire  [7:0] ESFRM;
// For Extended SFRM Test

wire        FRC;
// For Free running SCLK Test

wire [15:0] TxFRdDataIn;
// Lft justified

wire        SSPRXD;
// Input data from uut  

wire        OD;
// Out put disable bit

wire        BitPeriodCmp;
// bit period comparator

wire        BitCmpHalf;
// bit period half comparator

wire        BitCmp;
// Bit comparator

wire        SSPRXDIn;
// Internal Input data line

// -----------------------------------------------------------------------------
// Register declarations
// -----------------------------------------------------------------------------

reg        STxFRdPtrInc;
// Tx FIFO read ptr incr.

reg        SRxFWr;
// Rx FIFO write enable

reg        STxRxBSY;
// SSP Tx/Rx controller busy

reg        SSPOE;
// Output enable for SSPTXD

reg        SSPTXD;
// Serial transmit reg

reg        SCLK;
// Serial clock

reg        SFRM;
// Serial frame

reg [15:0] RxFWrData;
// Rx FIFO write data

reg  [5:0] SspTxRxCntlState;
// Slave State Register

reg  [5:0] SspTxRxCntlNextState;
// Slave State Register

reg        NextSTxRxBSY;
// TxRxBSY signal in Slave mode

reg        NextSSPOE;
// SSPOE signal in Slave mode

reg        NextSSPTXD;
// D-input of SSPTXD signal in Slave mode

reg        NextSCLK;
// D-input of SCLK output signal

reg        NextSFRM;
// D-input of SFRM Output signal

reg        NextSTxFRdPtrInc;
// D-input of TXFIFO Read Pointer Increment signal in Slave mode

reg        NextSRxFWr;
// RXFIFO Write signal in Slave mode

reg [15:0] NextRxFWrData;
// D-input of RXFIFO Write data bus in to test Slave

reg [7:0]  BitPeriodCnt;
// Bit Period Counter

reg [7:0]  NextBitPeriodCnt;
// D-input of Bit Period Counter

reg [3:0]  BitCnt;
// BitCounter

reg [3:0]  NextBitCnt;
// D-input of Bit Counter

reg [7:0]  SCLKCnt;
// It counts the SCLK during Extended SFRM

reg [7:0]  NextSCLKCnt;
// D - input of SCLKCnt;

reg [15:0] TxShft;
// TX Shift Register

reg [15:0] NextTxShft;
// D-input of TX Shift Register

reg [14:0] RxShft;
// RX Shift Register

reg [14:0] NextRxShft;
// D-input of RX Shift Register

assign BitPeriodCmp = (BitPeriodCnt[7:0] == 8'b00000000);
assign BitCmpHalf   = (BitCnt[3:0] == {1'b0,DSS[3:1]});
assign BitCmp       = (BitCnt[3:0] == 4'b0000);
assign SSPRXDIn     = (OD == 1'b1) ? 1'b0 : SSPRXD; 

// State transition
always @(posedge SSPCLK or negedge nSSPRES)
 begin   // When nSSPRES is asserted, transition to the ST_RESET state and
         // wait for the SSP to be enabled.
   if (~nSSPRES)
     begin
       SspTxRxCntlState <= ST_RESET;
       STxRxBSY         <= 1'd0;
       SSPOE            <= 1'd0;
       SSPTXD           <= 1'd0;
       SCLK             <= 1'd0;
       SFRM             <= 1'd1;
       SCLKCnt          <= 8'd0;
       STxFRdPtrInc     <= 1'd0;
       SRxFWr           <= 1'd0;
       RxFWrData        <= 16'h0000;
     end
   else if (ClkEnable)
     begin
       SspTxRxCntlState <= SspTxRxCntlNextState;
       STxRxBSY         <= NextSTxRxBSY;
       SSPOE            <= NextSSPOE;
       SSPTXD           <= NextSSPTXD;
       SCLK             <= NextSCLK;
       SFRM             <= NextSFRM;
       SCLKCnt          <= NextSCLKCnt;
       STxFRdPtrInc     <= NextSTxFRdPtrInc;
       SRxFWr           <= NextSRxFWr;
       RxFWrData        <= NextRxFWrData;
     end
end
// Output and next state logic generation
always @(SspTxRxCntlState or Nibmode or DSS or FRF or SCR or SPO or SPH or 
         SSESync or TxDataAvlblSync or TxFRdDataIn or SSPRXDIn or SSPCLKDIV 
         or BitPeriodCnt or BitCnt or TxShft or RxShft or BitPeriodCmp or
         BitCmpHalf or BitCmp or STxRxBSY or SSPOE or SSPTXD or SCLK or SFRM 
         or STxFRdPtrInc or SRxFWr or RxFWrData or SCLKCnt or FRC)
begin
// Default assignments
  SspTxRxCntlNextState = SspTxRxCntlState;
  NextSTxRxBSY         = STxRxBSY;
  NextSSPOE            = SSPOE;
  NextSSPTXD           = SSPTXD;
  NextSCLK             = SCLK;
  NextSFRM             = SFRM;
  NextSCLKCnt          = SCLKCnt;
  NextSTxFRdPtrInc     = STxFRdPtrInc;
  NextSRxFWr           = SRxFWr;
  NextRxFWrData        = RxFWrData;
  NextBitPeriodCnt     = BitPeriodCnt;
  NextBitCnt           = BitCnt;
  NextTxShft           = TxShft;
  NextRxShft           = RxShft;
// If the SSP is disabled, then the state machine should terminate
// transmission / reception,  initialise the outputs and the 
// internal variables and transition to the ST_RESET state.
        
  if (~SSESync)
     begin
       NextSTxRxBSY         = 1'd0;
       NextSSPOE            = 1'd0;
       NextSSPTXD           = 1'd0;
       NextSCLK             = (~FRF[1] & ~FRF[0] & SPO);
       NextSFRM             = ~FRF[0];
       NextSCLKCnt          = 8'd0;
       NextSTxFRdPtrInc     = 1'd0;
       NextSRxFWr           = 1'd0;
       NextRxFWrData        = 16'h0000;
       NextBitPeriodCnt     = SCR[7:0];
       NextBitCnt           = 4'b1111;
       NextTxShft           = 16'b0000000000000000;
       NextRxShft           = 15'b000000000000000;
       SspTxRxCntlNextState = ST_RESET;
     end
  else
    begin
      case (SspTxRxCntlState)
      // Wait for data to be available in the transmit FIFO provided the
      // frame format is not changed.
        
        ST_TIIDLE:
          begin  // Texas Instruments' Synchronous Serial Frame format is no
                 // longer the programmed format.
                
            if (~(~FRF[1] & FRF[0]))
              begin
                    // National Microwire Frame format selected.
                    
                if (FRF[1] & ~FRF[0])
                  begin
                        // Initialise the outputs to their inactive values.
                        
                    NextSTxRxBSY = 1'd0;
                    NextSSPOE    = 1'd0;
                    NextSSPTXD   = 1'd0;
                    NextSCLK     = 1'd0;
                    NextSFRM     = 1'd1;
                    SspTxRxCntlNextState = ST_NMIDLE;
                  end
                    // Motorola SPI Frame format selected.
                    
                else if (~FRF[1] & ~FRF[0])
                  begin
                        // Initialise the outputs to their inactive values.
                        
                    NextSTxRxBSY         = 1'd0;
                    NextSSPOE            = 1'd0;
                    NextSSPTXD           = 1'd0;
                    NextSCLK             = SPO;
                    NextSFRM             = 1'd1;
                    SspTxRxCntlNextState = ST_SPIIDLE;
                  end
              end
                // Transmit data available in the Transmit FIFO.
                
            else if (~FRF[1] & FRF[0] & TxDataAvlblSync & ~SCLK & BitPeriodCmp)
              begin
                NextSTxRxBSY = 1'd1;
                NextSSPOE = 1'd0;
                // SSPCLKDIV asserted, so start frame now. Load transmit
                // data into the transmit shift register, initialise
                // the BitPeriodCnt and BitCnt counters and assert the
                // STxFRdPtrInc signal for the Transmit FIFO.
                 
                if (SSPCLKDIV)
                  begin
                    NextSCLK             = 1'd1;
                    NextSFRM             = 1'd1;
                    NextSTxFRdPtrInc     = 1'd1;
                    NextBitPeriodCnt     = SCR[7:0];
                    NextBitCnt           = DSS[3:0];
                    NextTxShft           = TxFRdDataIn[15:0];
                    NextSCLKCnt          = ESFRM;
                    SspTxRxCntlNextState = ST_TISFRM1;
                  end
                  // SSPCLKDIV is not currently asserted, so wait for the next
                  // SSPCLKDIV pulse.

                else if (~SSPCLKDIV)
                  begin
                    SspTxRxCntlNextState = ST_TIDATAAVLBL;
                  end
              end

            else if (~FRF[1] & FRF[0] & FRC)
              begin
              // If FRC bit is set, SCLK is free running even if the Tx FIFO 
              // contains no data
                if (SSPCLKDIV & BitPeriodCmp )
                  begin
                    NextSCLK         = ~SCLK;
                    NextBitPeriodCnt = SCR[7:0];
                  end
                else if (SSPCLKDIV & ~BitPeriodCmp)
                  begin
                    NextBitPeriodCnt     = BitPeriodCnt - 1;
                    SspTxRxCntlNextState = ST_TIIDLE;
                  end
              end
          end
    // Wait for a time duration corresponding to one SCLK phase.
        
        ST_TISFRM2:
          begin
          // One phase of SCLK elapsed, so pull SCLK high and SFRM low.
          // Clock out the MSBit of the transmit Shift register into
          // SSPTXD and shift the contents of the shift register left
          // by one bit position. Also, reload the BitPeriodCnt counter.
                
            if (SSPCLKDIV & BitPeriodCmp & ~BitCmpHalf & (SCLKCnt == 8'b0))
              begin
                NextSSPTXD           = TxShft[15];
                NextSCLK             = 1'd1;
                NextSFRM             = 1'd0;
                NextBitPeriodCnt     = SCR[7:0];
                NextTxShft           = TxShft << 1;
                SspTxRxCntlNextState = ST_TISHIFT1;
              end
              // One half of the frame has elapsed, so deassert STxFRdPtrInc
              // and SRxFWr. Shift out the next Transmit bit and reload the
              // BitPeriodCnt counter.
                
            else if (SSPCLKDIV & BitPeriodCmp & BitCmpHalf & (SCLKCnt == 8'b0))
              begin
                NextSSPTXD           = TxShft[15];
                NextSCLK             = 1'd1;
                NextSTxFRdPtrInc     = 1'd0;
                NextSRxFWr           = 1'd0;
                NextTxShft           = TxShft << 1;
                NextBitPeriodCnt     = SCR[7:0];
                NextSCLKCnt          = ESFRM;
                SspTxRxCntlNextState = ST_TISTG2;
              end
              // When not in nibble mode decrement the BitPeriodCnt
              // counter by 1 on every SSPCLKDIV pulse.
                
            else if (SSPCLKDIV & BitPeriodCmp & (SCLKCnt > 8'b0))
              begin
              // If SCLKCnt is greater than zero then this block will transmit
              // 'x' on the SSPTXD. This will help to ESFRM Test
                NextSSPTXD           = 1'bx;
                NextSCLK             = 1'b1;
                NextSFRM             = 1'b1;
                NextBitPeriodCnt     = SCR[7:0];
                NextSCLKCnt          = SCLKCnt - 1'b1;
                SspTxRxCntlNextState = ST_TISFRM3;
              end
            else if (SSPCLKDIV & ~BitPeriodCmp & ~Nibmode)
              begin
                NextBitPeriodCnt     = BitPeriodCnt - 1;
                SspTxRxCntlNextState = ST_TISFRM2;
              end
              // In the Nibble mode, decrement the BitPeriodCnt counter
              // by 0x11 i.e. decimal 17 on every SSPCLKDIV pulse.
                
            else if (SSPCLKDIV & ~BitPeriodCmp & Nibmode)
              begin
                NextBitPeriodCnt     = BitPeriodCnt - 17;
                SspTxRxCntlNextState = ST_TISFRM2;
              end
          end
       // Wait in this state for a time period corresponding to the high phase 
       // of SCLK after a bit has been shifted out onto the SSPTXD line.
        
        ST_TISHIFT1:
          begin
          // Time duration, corresponding to the High phase of SCLK after
          // a bit has been shifted out on the SSPTXD line, has elapsed.
          // Sample the SSPRXDIn input and shift it into the Receive
          // shift register. Pull SCLK low and reload BitPeriodCnt.
          // Decrement the BitCnt counter by 1.
                
            if (SSPCLKDIV & BitPeriodCmp)
              begin
                NextSCLK             = 1'd0;
                NextBitCnt           = BitCnt - 1;
                NextBitPeriodCnt     = SCR[7:0];
                NextRxShft           = {RxShft[13:0],SSPRXDIn};
                SspTxRxCntlNextState = ST_TISFRM2;
              end
              // When not in nibble mode decrement the BitPeriodCnt
              // counter by 1 on every SSPCLKDIV pulse.
                
            else if (SSPCLKDIV & ~BitPeriodCmp & ~Nibmode)
              begin
                NextBitPeriodCnt     = BitPeriodCnt - 1;
                SspTxRxCntlNextState = ST_TISHIFT1;
              end
                // In the Nibble mode, decrement the BitPeriodCnt counter
                // by 0x11 i.e. decimal 17 on every SSPCLKDIV pulse.
                
             else if (SSPCLKDIV & ~BitPeriodCmp & Nibmode)
               begin
                 NextBitPeriodCnt     = BitPeriodCnt - 17;
                 SspTxRxCntlNextState = ST_TISHIFT1;
               end
          end
    // Wait for a period of time corresponding to one phase of SCLK.
        
        ST_TISTG2:
          begin
          // Time duration, corresponding to the High phase of SCLK after
          // a bit has been shifted out on the SSPTXD line, has elapsed.
          // Sample the SSPRXDIn input and shift it into the Receive
          // shift register. Pull SCLK low and reload BitPeriodCnt.
          // Decrement the BitCnt counter by 1.
                
            if (SSPCLKDIV & BitPeriodCmp)
              begin
                NextSCLK             = 1'd0;
                NextBitPeriodCnt     = SCR[7:0];
                NextRxShft           = {RxShft[13:0],SSPRXDIn};
                NextBitCnt           = BitCnt - 1;
                SspTxRxCntlNextState = ST_TISHIFT2;
              end
              // When not in nibble mode decrement the BitPeriodCnt
              // counter by 1 on every SSPCLKDIV pulse.
                
            else if (SSPCLKDIV & ~BitPeriodCmp & ~Nibmode)
              begin
                NextBitPeriodCnt     = BitPeriodCnt - 1;
                SspTxRxCntlNextState = ST_TISTG2;
              end
              // In the Nibble mode, decrement the BitPeriodCnt counter
              // by 0x11 i.e. decimal 17 on every SSPCLKDIV pulse.
                
            else if (SSPCLKDIV & ~BitPeriodCmp & Nibmode)
              begin
                NextBitPeriodCnt     = BitPeriodCnt - 17;
                SspTxRxCntlNextState = ST_TISTG2;
              end
          end
    // Wait for a period of time corresponding to one SCLK phase.
        
        ST_TISHIFT2:
          begin
          // All data bits except the last bit have been 
          // shifted out/sampled.
             
            if (SSPCLKDIV & BitPeriodCmp & BitCmp)
              begin
              // More transmit data is available in the Transmit FIFO, so
              // generate an SFRM pulse during the last bit of the
              // previous frame, to signal the beginning of the next data
              // frame. Shift out the last data bit and load the Transmit
              // shift register with the next transmit data. Also, reload
              // the BitCnt counter with DSS and the BitPeriodCnt 
              // counter with SCR.
                    
                if (TxDataAvlblSync)
                  begin
                    NextSSPTXD           = TxShft[15];
                    NextSCLK             = 1'd1;
                    NextSFRM             = 1'd1;
                    NextSTxFRdPtrInc     = 1'd1;
                    NextBitPeriodCnt     = SCR[7:0];
                    NextTxShft           = TxFRdDataIn[15:0];
                    NextBitCnt           = DSS[3:0];
                    NextSCLKCnt          = ESFRM;
                    SspTxRxCntlNextState = ST_TITXFNE;
                  end
                  // No more transmit data available in the transmit FIFO, so
                  // keep SFRM unchanged (low) and shift out the last Transmit
                  // bit onto the SSPTXD line.
                    
                else if (~TxDataAvlblSync)
                  begin
                    NextSSPTXD           = TxShft[15];
                    NextSCLK             = 1'd1;
                    NextBitPeriodCnt     = SCR[7:0];
                    SspTxRxCntlNextState = ST_TILASTBIT;
                  end
              end
                // When not in nibble mode decrement the BitPeriodCnt
                // counter by 1 on every SSPCLKDIV pulse.
                
            else if (SSPCLKDIV & ~BitPeriodCmp & ~Nibmode)
              begin
                NextBitPeriodCnt     = BitPeriodCnt - 1;
                SspTxRxCntlNextState = ST_TISHIFT2;
              end
              // One phase of SCLK elapsed, so pull SCLK high and SFRM low.
              // Clock out the MSBit of the transmit Shift register into
              // SSPTXD and shift the contents of the shift register left
              // by one bit position. Also, reload the BitPeriodCnt counter.
                
            else if (SSPCLKDIV & BitPeriodCmp & ~BitCmp)
              begin
                NextSSPTXD           = TxShft[15];
                NextSCLK             = 1'd1;
                NextBitPeriodCnt     = SCR[7:0];
                NextTxShft           = TxShft << 1;
                SspTxRxCntlNextState = ST_TISTG2;
              end
              // In the Nibble mode, decrement the BitPeriodCnt counter
              // by 0x11 i.e. decimal 17 on every SSPCLKDIV pulse.
                
            else if (SSPCLKDIV & ~BitPeriodCmp & Nibmode)
              begin
                NextBitPeriodCnt     = BitPeriodCnt - 17;
                SspTxRxCntlNextState = ST_TISHIFT2;
              end
          end
    // Wait for the first SCLK phase time after SCLK has been pulled low
    // for the last time.
        
        ST_TISSPOE1:
          begin
          // When not in nibble mode decrement the BitPeriodCnt
          // counter by 1 on every SSPCLKDIV pulse.
                
            if (SSPCLKDIV & ~BitPeriodCmp & ~Nibmode)
              begin
                NextBitPeriodCnt     = BitPeriodCnt - 1;
                SspTxRxCntlNextState = ST_TISSPOE1;
              end
              // In the Nibble mode, decrement the BitPeriodCnt counter
              // by 0x11 i.e. decimal 17 on every SSPCLKDIV pulse.
                
            else if (SSPCLKDIV & ~BitPeriodCmp & Nibmode)
              begin
                NextBitPeriodCnt     = BitPeriodCnt - 17;
                SspTxRxCntlNextState = ST_TISSPOE1;
              end
              // Reload the BitPeriodCnt counter to wait for one more
              // SCLK phase time.
                
            else if (SSPCLKDIV & BitPeriodCmp)
              begin
                if (FRC)
                  NextSCLK           = 1'b1;
                NextBitPeriodCnt     = SCR[7:0];
                SspTxRxCntlNextState = ST_TISSPOE2;
              end
          end
    // Transmit the last data bit.
        
        ST_TILASTBIT:
          begin
          // Pull SCLK low and then wait for one SCLK period i.e. 2 SCLK
          // phase times before deasserting SSPOE.
                
            if (SSPCLKDIV & BitPeriodCmp)
              begin
                NextSCLK             = 1'd0;
                NextSRxFWr           = 1'd1;
                NextRxFWrData        = {RxShft[14:0],SSPRXDIn};
                NextBitPeriodCnt     = SCR[7:0];
                SspTxRxCntlNextState = ST_TISSPOE1;
              end
              // When not in nibble mode decrement the BitPeriodCnt
              // counter by 1 on every SSPCLKDIV pulse.
                
            else if (SSPCLKDIV & ~BitPeriodCmp & ~Nibmode)
              begin
                NextBitPeriodCnt     = BitPeriodCnt - 1;
                SspTxRxCntlNextState = ST_TILASTBIT;
              end
              // In the Nibble mode, decrement the BitPeriodCnt counter
              // by 0x11 i.e. decimal 17 on every SSPCLKDIV pulse.
                
            else if (SSPCLKDIV & ~BitPeriodCmp & Nibmode)
              begin
                NextBitPeriodCnt     = BitPeriodCnt - 17;
                SspTxRxCntlNextState = ST_TILASTBIT;
              end
          end
    // While in this state, wait for a time duration corresponding to the
    // high phase of SCLK after the last bit of the previous frame has been 
    // shifted out.
        
        ST_TITXFNE:
          begin
          // Sample the last Rx data bit and load the sampled bit and the
          // contents of the Receive shift register into the Receive
          // buffer. Clear the receive shift register and assert the
          // SRxFWr write enable output to the receive FIFO.
                
            if (SSPCLKDIV & BitPeriodCmp)
              begin
                NextSRxFWr    = 1'd1;
                NextRxFWrData = {RxShft[14:0],SSPRXDIn};
                NextRxShft    = 15'b000000000000000;
                // Reload the BitPeriodCnt counter and pull SCLK low for the
                // second SCLK phase during which SFRM is to be pulled high.
                    
                 NextSCLK = 1'd0;
                 NextBitPeriodCnt = SCR[7:0];
                 SspTxRxCntlNextState = ST_TISFRM2;
              end
              // When not in nibble mode decrement the BitPeriodCnt
              // counter by 1 on every SSPCLKDIV pulse.
                
            else if (SSPCLKDIV & ~BitPeriodCmp & ~Nibmode)
              begin
                NextBitPeriodCnt     = BitPeriodCnt - 1;
                SspTxRxCntlNextState = ST_TITXFNE;
              end
              // In the Nibble mode, decrement the BitPeriodCnt counter
              // by 0x11 i.e. decimal 17 on every SSPCLKDIV pulse.
                
            else if (SSPCLKDIV & ~BitPeriodCmp & Nibmode)
              begin
                NextBitPeriodCnt     = BitPeriodCnt - 17;
                SspTxRxCntlNextState = ST_TITXFNE;
              end
          end
    // Stay in this state for the first SCLK phase during which SFRM is
    // to be driven high.
        
        ST_TISFRM1:
          begin
          // In the normal mode i.e. when Nibmode is not asserted,
          // decrement the BitPeriodCnt counter by 1 on every
          // SSPCLKDIV pulse.
                
            if (SSPCLKDIV & ~BitPeriodCmp & ~Nibmode)
              begin
                NextBitPeriodCnt     = BitPeriodCnt - 1;
                SspTxRxCntlNextState = ST_TISFRM1;
              end
              // The BitPeriodCnt counter has counted down to 0 i.e. one half
              // period of SCLK has elapsed. Assert SSPOE one half SCLK
              // earlier than the time at which SSPTXD is supposed to be
              // driven with valid data. This is done to account for pad
              // delays.
                
            else if (SSPCLKDIV & BitPeriodCmp)
              begin
                NextSSPOE            = 1'd1;
                    
                // Reload the BitPeriodCnt counter and pull SCLK low for the
                // second SCLK phase during which SFRM is to be pulled high.
                    
                NextSCLK             = 1'd0;
                NextBitPeriodCnt     = SCR[7:0];
                SspTxRxCntlNextState = ST_TISFRM2;
              end
              // In the Nibble mode i.e. when Nibmode is asserted, decrement 
              // the BitPeriodCnt counter by 17 on every SSPCLKDIV pulse.
                
              else if (SSPCLKDIV & ~BitPeriodCmp & Nibmode)
                begin
                  NextBitPeriodCnt     = BitPeriodCnt - 17;
                  SspTxRxCntlNextState = ST_TISFRM1;
                end
          end
    // Transmit Data is available in the transmit FIFO. Wait for the next
    // pulse on SSPCLKDIV to start the frame.
        
        ST_TIDATAAVLBL:
          begin
          // SSPCLKDIV asserted, so start frame now. Load transmit
          // data into the transmit shift register, initialise
          // the BitPeriodCnt and BitCnt counters and assert the
          // STxFRdPtrInc signal for the Transmit FIFO.
                
            if (SSPCLKDIV)
              begin
                NextSCLK             = 1'd1;
                NextSFRM             = 1'd1;
                NextSTxFRdPtrInc     = 1'd1;
                NextBitPeriodCnt     = SCR[7:0];
                NextBitCnt           = DSS[3:0];
                NextTxShft           = TxFRdDataIn[15:0];
                NextSCLKCnt          = ESFRM;
                SspTxRxCntlNextState = ST_TISFRM1;
              end
          end
    // Wait for one last SCLK phase time before de-asserting SSPOE.
        
        ST_TISSPOE2:
          begin
          // De-assert SSPOE and return to idle state.
                
            if (SSPCLKDIV & BitPeriodCmp)
              begin
                NextSTxRxBSY = 1'd0;
                NextSSPOE    = 1'd0;
                if (FRC)
                  begin
                    NextSCLK         = 1'b0;
                    NextBitPeriodCnt = SCR[7:0];
                  end
                SspTxRxCntlNextState = ST_TIIDLE;
              end
              // When not in nibble mode decrement the BitPeriodCnt
              // counter by 1 on every SSPCLKDIV pulse.
                
            else if (SSPCLKDIV & ~BitPeriodCmp & ~Nibmode)
              begin
                NextBitPeriodCnt     = BitPeriodCnt - 1;
                SspTxRxCntlNextState = ST_TISSPOE2;
              end
              // In the Nibble mode, decrement the BitPeriodCnt counter
              // by 0x11 i.e. decimal 17 on every SSPCLKDIV pulse.
                
            else if (SSPCLKDIV & ~BitPeriodCmp & Nibmode)
              begin
                NextBitPeriodCnt     = BitPeriodCnt - 17;
                SspTxRxCntlNextState = ST_TISSPOE2;
              end
          end
    // Wait for data to be available in the transmit FIFO provided the
    // frame format is not changed.
        
        ST_NMIDLE:
          begin
            // National Microwire frame format is no longer the programmed
            // frame format.
              
            if (~(FRF[1] & ~FRF[0]))
              begin
              // Motorola SPI Frame format selected.
                    
                if (~FRF[1] & ~FRF[0])
                  begin
                  // Initialise the outputs to their inactive values.
                        
                    NextSTxRxBSY         = 1'd0;
                    NextSSPOE            = 1'd0;
                    NextSSPTXD           = 1'd0;
                    NextSCLK             = SPO;
                    NextSFRM             = 1'd1;
                    SspTxRxCntlNextState = ST_SPIIDLE;
                  end
                  // Texas Instruments' Synchronous Serial frame format
                  // selected.
                    
                else if (~FRF[1] & FRF[0])
                  begin
                  // Initialise the outputs to their inactive values.
                        
                    NextSTxRxBSY         = 1'd0;
                    NextSSPOE            = 1'd0;
                    NextSSPTXD           = 1'd0;
                    NextSCLK             = 1'd0;
                    NextSFRM             = 1'd0;
                    SspTxRxCntlNextState = ST_TIIDLE;
                  end
              end
              // Transmit Data available in the transmit FIFO.
                
            else if (FRF[1] & ~FRF[0] & TxDataAvlblSync & (~FRC | SCLK) 
                                                        & BitPeriodCmp)
              begin
                NextSTxRxBSY = 1'd1;
                // SSPCLKDIV is not currently asserted, so wait for the next
                // SSPCLKDIV pulse.
                    
                if (~SSPCLKDIV)
                  begin
                    SspTxRxCntlNextState = ST_NMDATAAVLBL;
                  end
                  // SSPCLKDIV asserted, so start frame now. Load transmit
                  // data into the transmit shift register, initialise
                  // the BitPeriodCnt and BitCnt counters and assert the
                  // STxFRdPtrInc signal for the Transmit FIFO.
                    
                else if (SSPCLKDIV)
                  begin
                    NextSSPOE            = 1'd1;
                    NextSFRM             = 1'd0;
                    NextSTxFRdPtrInc     = 1'd1;
                    NextBitPeriodCnt     = SCR[7:0];
                    NextTxShft           = TxFRdDataIn[15:0];
                    NextRxShft           = 15'b000000000000000;
                    NextSCLK             = 1'b0;
                    SspTxRxCntlNextState = ST_NMSFRM;
                  end
              end
            else if (FRF[1] & ~FRF[0] & FRC)
              begin
              // If FRC bit is set, SCLK is Free running even when the Tx FIFO 
              // contains no data
                if (SSPCLKDIV & BitPeriodCmp )
                  begin
                    NextSCLK         = ~SCLK;
                    NextBitPeriodCnt = SCR[7:0];
                  end
                else if (SSPCLKDIV & ~BitPeriodCmp)
                  begin
                    NextBitPeriodCnt     = BitPeriodCnt - 1;
                    SspTxRxCntlNextState = ST_NMIDLE;
                  end
              end
          end
        
        ST_NMDATAAVLBL:
          begin
          // SSPCLKDIV asserted, so start frame now. Load transmit
          // data into the transmit shift register, initialise
          // the BitPeriodCnt and BitCnt counters and assert the
          // STxFRdPtrInc signal for the Transmit FIFO.
                
            if (SSPCLKDIV)
              begin
                NextSSPOE            = 1'd1;
                NextSFRM             = 1'd0;
                NextSTxFRdPtrInc     = 1'd1;
                NextBitPeriodCnt     = SCR[7:0];
                NextTxShft           = TxFRdDataIn[15:0];
                NextRxShft           = 15'b000000000000000;
                NextSCLK             = 1'b0;
                SspTxRxCntlNextState = ST_NMSFRM;
              end
          end
    // Stay in this state for the first state of SCLK.
        
        ST_NMSFRM:
          begin
          // One SCLK phase elapsed after SFRM was first asserted. Shift
          // out the MSBit of the transmit data onto the SSPTXD line
          // and shift the transmit shift register left by one bit
          // position.
                
            if (SSPCLKDIV & BitPeriodCmp)
              begin
                NextSSPTXD = TxShft[15];
                NextTxShft = TxShft << 1;
                    
                // Load 7 into the BitCnt counter because the transmit data
                // size is always 8 bits in this frame format.
                    
                NextSCLK             = 1'b1;
                NextBitPeriodCnt     = SCR[7:0];
                NextBitCnt           = 4'b0111;
                SspTxRxCntlNextState = ST_NMTXBIT;
              end
              // In the normal mode i.e. when Nibmode is not asserted,
              // decrement  the BitPeriodCnt counter by 1 on every
              // SSPCLKDIV pulse.
                
            else if (SSPCLKDIV & ~BitPeriodCmp & ~Nibmode)
              begin
                NextBitPeriodCnt     = BitPeriodCnt - 1;
                SspTxRxCntlNextState = ST_NMSFRM;
              end
              // In the Nibble mode i.e. when Nibmode is asserted, decrement 
              // the BitPeriodCnt counter by 17 on every SSPCLKDIV pulse.
                
            else if (SSPCLKDIV & ~BitPeriodCmp & Nibmode)
              begin
                NextBitPeriodCnt     = BitPeriodCnt - 17;
                SspTxRxCntlNextState = ST_NMSFRM;
              end
          end
    // Wait for a time duration corresponding to one phase of SCLK.
        
        ST_NMTXBIT:
          begin
          // In the normal mode i.e. when Nibmode is not asserted,
          // decrement  the BitPeriodCnt counter by 1 on every
          // SSPCLKDIV pulse.
                
            if (SSPCLKDIV & ~BitPeriodCmp & ~Nibmode)
              begin
                NextBitPeriodCnt     = BitPeriodCnt - 1;
                SspTxRxCntlNextState = ST_NMTXBIT;
              end
              // Pull SCLK high and reload the BitPeriodCnt counter.
                
            else if (SSPCLKDIV & BitPeriodCmp)
              begin
                NextSCLK             = ~SCLK;
                NextBitPeriodCnt     = SCR[7:0];
                NextSSPTXD           = TxShft[15];
                NextTxShft           = TxShft << 1;
                SspTxRxCntlNextState = ST_NMTXBIT2;
              end
              // In the Nibble mode i.e. when Nibmode is asserted, decrement 
              // the BitPeriodCnt counter by 17 on every SSPCLKDIV pulse.
                
            else if (SSPCLKDIV & ~BitPeriodCmp & Nibmode)
              begin
                NextBitPeriodCnt     = BitPeriodCnt - 17;
                SspTxRxCntlNextState = ST_NMTXBIT;
              end
          end
    // Wait for a time duration corresponding to one phase of SCLK.
        
        ST_NMTXBIT2:
          begin
          // Clock out the MSBit from the Transmit shift register onto
          // the SSPTXD output line and shift the contents of the
          // Transmit shift register left by one bit position.
                
            if (SSPCLKDIV & BitPeriodCmp & ~BitCmp)
              begin
                NextSCLK             = ~SCLK;
                NextBitPeriodCnt     = SCR[7:0];
                NextBitCnt           = BitCnt - 1;
                SspTxRxCntlNextState = ST_NMTXBIT;
              end
              // In the normal mode i.e. when Nibmode is not asserted,
              // decrement  the BitPeriodCnt counter by 1 on every
              // SSPCLKDIV pulse.
                
            else if (SSPCLKDIV & ~BitPeriodCmp & ~Nibmode)
              begin
                NextBitPeriodCnt     = BitPeriodCnt - 1;
                SspTxRxCntlNextState = ST_NMTXBIT2;
              end
              // All bits in the transmit data have been shifted out.
                
            else if (SSPCLKDIV & BitPeriodCmp & BitCmp)
              begin
                NextSSPTXD = 1'd0;
                  
                // Pull SCLK low and reload the BitPeriodCnt counter.
                  
                NextSCLK             = ~SCLK;
                NextBitPeriodCnt     = SCR[7:0];
                SspTxRxCntlNextState = ST_NMWAIT1;
              end
              // In the Nibble mode i.e. when Nibmode is asserted, decrement 
              // the BitPeriodCnt counter by 17 on every SSPCLKDIV pulse.
                
            else if (SSPCLKDIV & ~BitPeriodCmp & Nibmode)
              begin
                NextBitPeriodCnt     = BitPeriodCnt - 17;
                SspTxRxCntlNextState = ST_NMTXBIT2;
              end
          end
    // Wait for a time duration corresponding to one phase time of SCLK.
        
        ST_NMWAIT1:
          begin
          // In the normal mode i.e. when Nibmode is not asserted,
          // decrement  the BitPeriodCnt counter by 1 on every
          // SSPCLKDIV pulse.
                
            if (SSPCLKDIV & ~BitPeriodCmp & ~Nibmode)
              begin
                NextBitPeriodCnt     = BitPeriodCnt - 1;
                SspTxRxCntlNextState = ST_NMWAIT1;
              end
              // De-assert SSPOE, pull SCLK high and reload the BitPeriodCnt
              // counter.
                
            else if (SSPCLKDIV & BitPeriodCmp)
              begin
                NextSSPOE            = 1'd0;
                NextSCLK             = ~SCLK;
                NextBitPeriodCnt     = SCR[7:0];
                SspTxRxCntlNextState = ST_NMWAIT2;
              end
              // In the Nibble mode i.e. when Nibmode is asserted, decrement 
              // the BitPeriodCnt counter by 17 on every SSPCLKDIV pulse.
                
            else if (SSPCLKDIV & ~BitPeriodCmp & Nibmode)
              begin
                NextBitPeriodCnt     = BitPeriodCnt - 17;
                SspTxRxCntlNextState = ST_NMWAIT1;
              end
          end
    // Wait for a time duration corresponding to one phase of SCLK.
        
        ST_NMWAIT2:
          begin
          // In the normal mode i.e. when Nibmode is not asserted,
          // decrement  the BitPeriodCnt counter by 1 on every
          // SSPCLKDIV pulse.
                
            if (SSPCLKDIV & ~BitPeriodCmp & ~Nibmode)
              begin
                NextBitPeriodCnt     = BitPeriodCnt - 1;
                SspTxRxCntlNextState = ST_NMWAIT2;
              end
              // One SCLK wait period completed between transmission and 
              // reception. De-assert TxFRdPrtInc and SRxFWr output signals.
                
            else if (SSPCLKDIV & BitPeriodCmp)
              begin
                NextSTxFRdPtrInc = 1'd0;
                NextSRxFWr       = 1'd0;
                    
                // Clear the Receive shift register to start reception. Load
                // the BitCnt counter with DSS and the BitPeriodCnt counter
                // with SCR.
                    
                NextSCLK             = ~SCLK;
                NextBitPeriodCnt     = SCR[7:0];
                NextBitCnt           = DSS[3:0];
                NextRxShft           = 15'b000000000000000;
                SspTxRxCntlNextState = ST_NMRX1;
              end
              // In the Nibble mode i.e. when Nibmode is asserted, decrement 
              // the BitPeriodCnt counter by 17 on every SSPCLKDIV pulse.
                
            else if (SSPCLKDIV & ~BitPeriodCmp & Nibmode)
              begin
                NextBitPeriodCnt     = BitPeriodCnt - 17;
                SspTxRxCntlNextState = ST_NMWAIT2;
              end
          end
    // Wait for a time duration corresponding to one SCLK phase.
        
        ST_NMRX1:
          begin
          // In the normal mode i.e. when Nibmode is not asserted,
          // decrement  the BitPeriodCnt counter by 1 on every
          // SSPCLKDIV pulse.
                
            if (SSPCLKDIV & ~BitPeriodCmp & ~Nibmode)
              begin
                NextBitPeriodCnt     = BitPeriodCnt - 1;
                SspTxRxCntlNextState = ST_NMRX1;
              end
              // Sample the next bit on the SSPRXDIn line and shift it into
              // the receive shift register.
                
            else if (SSPCLKDIV & BitPeriodCmp & ~BitCmp)
              begin
                NextSCLK             = ~SCLK;
                NextBitPeriodCnt     = SCR[7:0];
                NextRxShft           = {RxShft[13:0],SSPRXDIn};
                SspTxRxCntlNextState = ST_NMRX2;
              end
              // In the Nibble mode i.e. when Nibmode is asserted, decrement 
              // the BitPeriodCnt counter by 17 on every SSPCLKDIV pulse.
                
            else if (SSPCLKDIV & ~BitPeriodCmp & Nibmode)
              begin
                NextBitPeriodCnt     = BitPeriodCnt - 17;
                SspTxRxCntlNextState = ST_NMRX1;
              end
              // Sample the last bit on the SSPRXDIn input and load it into
              // the Receive buffer along with the contents of the Receive
              // shift register.
                
            else if (SSPCLKDIV & BitPeriodCmp & BitCmp)
              begin
                NextSCLK      = ~SCLK;
                NextSRxFWr    = 1'd1;
                NextRxFWrData = {RxShft[14:0],SSPRXDIn};
                // No more data available for transmission.
                    
                if (~TxDataAvlblSync)
                  begin
                    NextBitPeriodCnt     = SCR[7:0];
                    SspTxRxCntlNextState = ST_NMRXLAST;
                  end
                  // More transmit data is available in the Transmit FIFO, so
                  // reload the BitPeriodCnt counter with SCR.
                    
                else if (TxDataAvlblSync)
                  begin
                    NextSSPOE            = 1'd1;
                    NextBitPeriodCnt     = SCR[7:0];
                    SspTxRxCntlNextState = ST_NMTXFNE;
                  end
              end
          end
    // Wait for a time duration corresponding to one SCLK phase.
        
        ST_NMRX2:
          begin
          // In the normal mode i.e. when Nibmode is not asserted,
          // decrement  the BitPeriodCnt counter by 1 on every
          // SSPCLKDIV pulse.
                
            if (SSPCLKDIV & ~BitPeriodCmp & ~Nibmode)
              begin
                NextBitPeriodCnt     = BitPeriodCnt - 1;
                SspTxRxCntlNextState = ST_NMRX2;
              end
              // Toggle SCLK and reload the BitPeriodCnt counter.
                
            else if (SSPCLKDIV & BitPeriodCmp)
              begin
                NextSCLK             = ~SCLK;
                NextBitPeriodCnt     = SCR[7:0];
                NextBitCnt           = BitCnt - 1;
                SspTxRxCntlNextState = ST_NMRX1;
              end
              // In the Nibble mode i.e. when Nibmode is asserted, decrement 
              // the BitPeriodCnt counter by 17 on every SSPCLKDIV pulse.
                
            else if (SSPCLKDIV & ~BitPeriodCmp & Nibmode)
              begin
                NextBitPeriodCnt     = BitPeriodCnt - 17;
                SspTxRxCntlNextState = ST_NMRX2;
              end
          end
    // Wait for a period of time corresponding to one SCLK phase.
        
        ST_NMSFRMLAST:
          begin
          // In the normal mode i.e. when Nibmode is not asserted,
          // decrement  the BitPeriodCnt counter by 1 on every
          // SSPCLKDIV pulse.
                
            if (SSPCLKDIV & ~BitPeriodCmp & ~Nibmode)
              begin
                NextBitPeriodCnt     = BitPeriodCnt - 1;
                SspTxRxCntlNextState = ST_NMSFRMLAST;
              end
              // In the Nibble mode i.e. when Nibmode is asserted, decrement 
              // the BitPeriodCnt counter by 17 on every SSPCLKDIV pulse.
                
            else if (SSPCLKDIV & ~BitPeriodCmp & Nibmode)
              begin
                NextBitPeriodCnt     = BitPeriodCnt - 17;
                SspTxRxCntlNextState = ST_NMSFRMLAST;
              end
              // End of frame reached.
                
            else if (SSPCLKDIV & BitPeriodCmp)
              begin
              // End of Frame reached, so pull SFRM high.
                    
                NextSTxRxBSY         = 1'd0;
                NextSFRM             = 1'd1;
                SspTxRxCntlNextState = ST_NMIDLE;
              end
          end
    // Wait for a time duration corresponding to one SCLK phase.
        
        ST_NMRXLAST:
          begin
          // Pull SCLK low and reload the BitPeriodCnt counter.
                
            if (SSPCLKDIV & BitPeriodCmp)
              begin
                NextSCLK             = ~SCLK;
                NextBitPeriodCnt     = SCR[7:0];
                SspTxRxCntlNextState = ST_NMSFRMLAST;
              end
              // In the normal mode i.e. when Nibmode is not asserted,
              // decrement  the BitPeriodCnt counter by 1 on every
              // SSPCLKDIV pulse.
                
            else if (SSPCLKDIV & ~BitPeriodCmp & ~Nibmode)
              begin
                NextBitPeriodCnt     = BitPeriodCnt - 1;
                SspTxRxCntlNextState = ST_NMRXLAST;
              end
              // In the Nibble mode i.e. when Nibmode is asserted, decrement 
              // the BitPeriodCnt counter by 17 on every SSPCLKDIV pulse.
                
            else if (SSPCLKDIV & ~BitPeriodCmp & Nibmode)
              begin
                NextBitPeriodCnt     = BitPeriodCnt - 17;
                SspTxRxCntlNextState = ST_NMRXLAST;
              end
          end
    // Wait for one SCLK phase time before shifting out the next transmit
    // data.
        
        ST_NMTXFNE:
          begin
          // Clock out the MSBit of the next transmit data onto the SSPTXD
          // line. Load the transmit shift register with the remaining 15
          // bits in the transmit data appended with a 0.
             
            if (SSPCLKDIV & BitPeriodCmp)
              begin
                NextSSPTXD           = TxFRdDataIn[15];
                NextSTxFRdPtrInc     = 1'd1;
                NextTxShft           = {TxFRdDataIn[14:0],1'b0};
                // Load 7 into the BitCnt counter because the transmit data
                // size is always 8 bits in this frame format.
                
                NextSCLK             = ~SCLK;
                NextBitPeriodCnt     = SCR[7:0];
                NextBitCnt           = 4'b0111;
                SspTxRxCntlNextState = ST_NMTXBIT;
              end
              // In the normal mode i.e. when Nibmode is not asserted,
              // decrement  the BitPeriodCnt counter by 1 on every
              // SSPCLKDIV pulse.
                
            else if (SSPCLKDIV & ~BitPeriodCmp & ~Nibmode)
              begin
                NextBitPeriodCnt     = BitPeriodCnt - 1;
                SspTxRxCntlNextState = ST_NMTXFNE;
              end
              // In the Nibble mode i.e. when Nibmode is asserted, decrement 
              // the BitPeriodCnt counter by 17 on every SSPCLKDIV pulse.
                
            else if (SSPCLKDIV & ~BitPeriodCmp & Nibmode)
              begin
                NextBitPeriodCnt     = BitPeriodCnt - 17;
                SspTxRxCntlNextState = ST_NMTXFNE;
              end
          end
    // Wait for data to be available in the transmit FIFO provided the
    // frame format is not changed.
        
        ST_SPIIDLE:
          begin
          // Motorola's SPI Frame Format is no longer the programmed frame
          // format.
                
            if (~(~FRF[1] & ~FRF[0]))
              begin
              // Texas Instruments' Synchronous Serial Frame format
              // selected.
                  
                if (~FRF[1] & FRF[0])
                  begin
                  // Initialise the outputs to their inactive values.
                    
                    NextSTxRxBSY         = 1'd0;
                    NextSSPOE            = 1'd0;
                    NextSSPTXD           = 1'd0;
                    NextSCLK             = 1'd0;
                    NextSFRM             = 1'd0;
                    SspTxRxCntlNextState = ST_TIIDLE;
                  end
                  // National Microwire Frame format selected.
                    
                else if (FRF[1] & ~FRF[0])
                  begin
                  // Initialise the outputs to their inactive values.
                    
                    NextSTxRxBSY         = 1'd0;
                    NextSSPOE            = 1'd0;
                    NextSSPTXD           = 1'd0;
                    NextSCLK             = 1'd0;
                    NextSFRM             = 1'd1;
                    SspTxRxCntlNextState = ST_NMIDLE;
                  end
              end
                // Transmit data available in the Transmit FIFO.
                
            else if (~FRF[1] & ~FRF[0] & TxDataAvlblSync)
              begin
                NextSTxRxBSY            = 1'd1;
                // SSPCLKDIV is not currently asserted, so wait for the next
                // SSPCLKDIV pulse.
                    
                if (~SSPCLKDIV)
                  begin
                    SspTxRxCntlNextState = ST_SPIDATAAVLBL;
                  end
                  // SSPCLKDIV asserted, so start frame now. Load transmit
                  // data into the transmit shift register, initialise
                  // the BitPeriodCnt and BitCnt counters and assert the
                  // STxFRdPtrInc signal for the Transmit FIFO.
                    
                else if (SSPCLKDIV)
                  begin
                    NextSSPOE            = 1'd1;
                    NextSFRM             = 1'd0;
                    NextSTxFRdPtrInc     = 1'd1;
                    NextBitPeriodCnt     = SCR[7:0];
                    NextBitCnt           = DSS[3:0];
                    NextTxShft           = TxFRdDataIn[15:0];
                    NextRxShft           = 15'b000000000000000;
                    SspTxRxCntlNextState = ST_SPISFRM;
                  end
              end
          end
    // Transmit Data is available in the transmit FIFO. Wait for the next
    // pulse on SSPCLKDIV to start the frame.
        
        ST_SPIDATAAVLBL:
          begin
          // SSPCLKDIV asserted, so start frame now. Load transmit
          // data into the transmit shift register, initialise
          // the BitPeriodCnt and BitCnt counters and assert the
          // STxFRdPtrInc signal for the Transmit FIFO.
                
            if (SSPCLKDIV)
              begin
                NextSSPOE            = 1'd1;
                NextSFRM             = 1'd0;
                NextSTxFRdPtrInc     = 1'd1;
                NextBitPeriodCnt     = SCR[7:0];
                NextBitCnt           = DSS[3:0];
                NextTxShft           = TxFRdDataIn[15:0];
                NextRxShft           = 15'b000000000000000;
                SspTxRxCntlNextState = ST_SPISFRM;
              end
          end
    // Stay in this state for the first phase of SCLK.
        
        ST_SPISFRM:
          begin
          // One SCLK phase elapsed after SFRM was first asserted.
                
            if (SSPCLKDIV & BitPeriodCmp)
              begin
                NextSSPTXD = TxShft[15];
                NextTxShft = TxShft << 1;
                    
                // Drive the XOR of SPO and SPH on the SCLK line.
                // Shift the Transmit shift register left by one bit 
                // position and reload the BitPeriodCnt counter
                // with SCR.
                    
                NextSCLK             = (SPO ^ SPH);
                NextBitPeriodCnt     = SCR[7:0];
                SspTxRxCntlNextState = ST_SPITX1;
              end
              // In the normal mode i.e. when Nibmode is not asserted,
              // decrement  the BitPeriodCnt counter by 1 on every
              // SSPCLKDIV pulse.
                
            else if (SSPCLKDIV & ~BitPeriodCmp & ~Nibmode)
              begin
                NextBitPeriodCnt     = BitPeriodCnt - 1;
                SspTxRxCntlNextState = ST_SPISFRM;
              end
              // In the Nibble mode i.e. when Nibmode is asserted, decrement 
              // the BitPeriodCnt counter by 17 on every SSPCLKDIV pulse.
              
            else if (SSPCLKDIV & ~BitPeriodCmp & Nibmode)
              begin
                NextBitPeriodCnt     = BitPeriodCnt - 17;
                SspTxRxCntlNextState = ST_SPISFRM;
              end
          end
    // Wait for an SCLK phase after shifting out a bit onto the
    // SSPTXD line.
        
        ST_SPITX1:
          begin
          // Sample SSPRXDIn and shift the sampled data bit into the
          // receive shift register. Toggle SCLK and decrement the
          // BitCnt counter by 1.
              
            if (SSPCLKDIV & BitPeriodCmp)
              begin
                NextSCLK             = (~(SPO ^ SPH));
                NextRxShft           = {RxShft[13:0],SSPRXDIn};
                NextBitPeriodCnt     = SCR[7:0];
                NextBitCnt           = BitCnt - 1;
                SspTxRxCntlNextState = ST_SPIRX1;
              end
              // In the normal mode i.e. when Nibmode is not asserted,
              // decrement  the BitPeriodCnt counter by 1 on every
              // SSPCLKDIV pulse.
                
            else if (SSPCLKDIV & ~BitPeriodCmp & ~Nibmode)
              begin
                NextBitPeriodCnt     = BitPeriodCnt - 1;
                SspTxRxCntlNextState = ST_SPITX1;
              end
              // In the Nibble mode i.e. when Nibmode is asserted, decrement 
              // the BitPeriodCnt counter by 17 on every SSPCLKDIV pulse.
              
            else if (SSPCLKDIV & ~BitPeriodCmp & Nibmode)
              begin
                NextBitPeriodCnt     = BitPeriodCnt - 17;
                SspTxRxCntlNextState = ST_SPITX1;
              end
          end
    // Wait for an SCLK phase after sampling one bit on the SSPRXDIn
    // input line.
        
        ST_SPIRX1:
          begin
            // One half phase of SCLK elapsed, so toggle SCLK.
            // Clock out the MSBit of the transmit Shift register into
            // SSPTXD and shift the contents of the shift register left by
            // one bit position. Also, reload the BitPeriodCnt
            // counter.
                
            if (SSPCLKDIV & BitPeriodCmp & ~BitCmpHalf)
              begin
                NextSSPTXD           = TxShft[15];
                NextSCLK             = (SPO ^ SPH);
                NextTxShft           = TxShft << 1;
                NextBitPeriodCnt     = SCR[7:0];
                SspTxRxCntlNextState = ST_SPITX1;
              end
              // In the normal mode i.e. when Nibmode is not asserted,
              // decrement  the BitPeriodCnt counter by 1 on every
              // SSPCLKDIV pulse.
                
            else if (SSPCLKDIV & ~BitPeriodCmp & ~Nibmode)
              begin
                NextBitPeriodCnt     = BitPeriodCnt - 1;
                SspTxRxCntlNextState = ST_SPIRX1;
              end
              // One half of the frame has elapsed, so deassert STxFRdPtrInc
              // and SRxFWr. Shift out the next Transmit bit and reload the
              // BitPeriodCnt counter.
                
            else if (SSPCLKDIV & BitPeriodCmp & BitCmpHalf)
              begin
                NextSSPTXD           = TxShft[15];
                NextSCLK             = (SPO ^ SPH);
                NextSTxFRdPtrInc     = 1'd0;
                NextSRxFWr           = 1'd0;
                NextBitPeriodCnt     = SCR[7:0];
                NextTxShft           = TxShft << 1;
                SspTxRxCntlNextState = ST_SPITX2;
              end
              // In the Nibble mode i.e. when Nibmode is asserted, decrement 
              // the BitPeriodCnt counter by 17 on every SSPCLKDIV pulse.
                
            else if (SSPCLKDIV & ~BitPeriodCmp & Nibmode)
              begin
                NextBitPeriodCnt     = BitPeriodCnt - 17;
                SspTxRxCntlNextState = ST_SPIRX1;
              end
          end
    // Wait for an SCLK phase after shifting out a bit onto the
    // SSPTXD line.
        
        ST_SPITX2:
          begin
          // Sample SSPRXDIn and shift the sampled data bit into the
          // receive shift register. Toggle SCLK and decrement the
          // BitCnt counter by 1.
                
            if (SSPCLKDIV & BitPeriodCmp)
              begin
                NextSCLK             = (~(SPO ^ SPH));
                NextBitPeriodCnt     = SCR[7:0];
                NextRxShft           = {RxShft[13:0],SSPRXDIn};
                NextBitCnt           = BitCnt - 1;
                SspTxRxCntlNextState = ST_SPIRX2;
              end
              // In the normal mode i.e. when Nibmode is not asserted,
              // decrement  the BitPeriodCnt counter by 1 on every
              // SSPCLKDIV pulse.
                
            else if (SSPCLKDIV & ~BitPeriodCmp & ~Nibmode)
              begin
                NextBitPeriodCnt     = BitPeriodCnt - 1;
                SspTxRxCntlNextState = ST_SPITX2;
              end
            // In the Nibble mode i.e. when Nibmode is asserted, decrement 
            // the BitPeriodCnt counter by 17 on every SSPCLKDIV pulse.
                
            else if (SSPCLKDIV & ~BitPeriodCmp & Nibmode)
              begin
                NextBitPeriodCnt     = BitPeriodCnt - 17;
                SspTxRxCntlNextState = ST_SPITX2;
              end
          end
    // Wait for an SCLK phase after sampling one bit on the SSPRXDIn
    // input line.
        
        ST_SPIRX2:
          begin
          // In the normal mode i.e. when Nibmode is not asserted,
          // decrement  the BitPeriodCnt counter by 1 on every
          // SSPCLKDIV pulse.
                
            if (SSPCLKDIV & ~BitPeriodCmp & ~Nibmode)
              begin
                NextBitPeriodCnt     = BitPeriodCnt - 1;
                SspTxRxCntlNextState = ST_SPIRX2;
              end
              // One half phase of SCLK elapsed, so toggle SCLK.
              // Clock out the MSBit of the transmit Shift register into
              // SSPTXD and shift the contents of the shift register left
              // by one bit position. Also, reload the BitPeriodCnt
              // counter.
                
            else if (SSPCLKDIV & BitPeriodCmp & ~BitCmp)
              begin
                NextSSPTXD           = TxShft[15];
                NextSCLK             = (SPO ^ SPH);
                NextBitPeriodCnt     = SCR[7:0];
                NextTxShft           = TxShft << 1;
                SspTxRxCntlNextState = ST_SPITX2;
              end
              // In the Nibble mode i.e. when Nibmode is asserted, decrement 
              // the BitPeriodCnt counter by 17 on every SSPCLKDIV pulse.
                
            else if (SSPCLKDIV & ~BitPeriodCmp & Nibmode)
              begin
                NextBitPeriodCnt     = BitPeriodCnt - 17;
                SspTxRxCntlNextState = ST_SPIRX2;
              end
                
            else if (SSPCLKDIV & BitPeriodCmp & BitCmp)
              begin
                    
              // Shift out the last bit onto the SSPTXD line.
                  
                NextSSPTXD           = TxShft[15];
                NextSCLK             = (SPO ^ SPH);
                NextBitPeriodCnt     = SCR[7:0];
                SspTxRxCntlNextState = ST_SPILASTTX;
              end
          end
    // Wait for one SCLK phase beforepulling SFRM high again.
        
        ST_SPISFRMEND:
          begin
          // In the normal mode i.e. when Nibmode is not asserted,
          // decrement  the BitPeriodCnt counter by 1 on every
          // SSPCLKDIV pulse.
                
            if (SSPCLKDIV & ~BitPeriodCmp & ~Nibmode)
              begin
                NextBitPeriodCnt     = BitPeriodCnt - 1;
                SspTxRxCntlNextState = ST_SPISFRMEND;
              end
              // End of frame reached, so pull SFRM high and de-assert
              // STxFRdPtrInc and SRxFWr.
                
            else if (SSPCLKDIV & BitPeriodCmp)
              begin
                NextSTxRxBSY         = 1'd0;
                NextSSPOE            = 1'd0;
                NextSFRM             = 1'd1;
                NextSTxFRdPtrInc     = 1'd0;
                NextSRxFWr           = 1'd0;
                SspTxRxCntlNextState = ST_SPIIDLE;
              end
              // In the Nibble mode i.e. when Nibmode is asserted, decrement 
              // the BitPeriodCnt counter by 17 on every SSPCLKDIV pulse.
                
            else if (SSPCLKDIV & ~BitPeriodCmp & Nibmode)
              begin
                NextBitPeriodCnt     = BitPeriodCnt - 17;
                SspTxRxCntlNextState = ST_SPISFRMEND;
              end
          end
    // Wait for a time duration corresponding to the SCLK phase
    // after the last Tx bit has been shifted out.
        
        ST_SPILASTTX:
          begin
          // Sample the last Rx bit from the SSPRXD input and clock it
          // into the receive buffer along with the contents of the
          // receive shift register.
                
            if (SSPCLKDIV & BitPeriodCmp)
              begin
                NextSCLK             = (~(SPO ^ SPH));
                NextSRxFWr           = 1'd1;
                NextRxFWrData        = {RxShft[14:0],SSPRXDIn};
                NextBitPeriodCnt     = SCR[7:0];
                SspTxRxCntlNextState = ST_SPILASTRX;
              end
              // In the normal mode i.e. when Nibmode is not asserted,
              // decrement  the BitPeriodCnt counter by 1 on every
              // SSPCLKDIV pulse.
                
            else if (SSPCLKDIV & ~BitPeriodCmp & ~Nibmode)
              begin
                NextBitPeriodCnt     = BitPeriodCnt - 1;
                SspTxRxCntlNextState = ST_SPILASTTX;
              end
              // In the Nibble mode i.e. when Nibmode is asserted, decrement 
              // the BitPeriodCnt counter by 17 on every SSPCLKDIV pulse.
                
            else if (SSPCLKDIV & ~BitPeriodCmp & Nibmode)
              begin
                NextBitPeriodCnt     = BitPeriodCnt - 17;
                SspTxRxCntlNextState = ST_SPILASTTX;
              end
          end
    // Wait for a time duration corresponding to one SCLK phase duration
    // after the last Rx bit has been sampled from SSPRXD.
        
        ST_SPILASTRX:
          begin
          // All bits shifted out/sampled.
            
            if (SSPCLKDIV & BitPeriodCmp)
              begin
              // No more transmit data available, so set SSPTXD and
              // SCLK to their default values.
                    
                if (~TxDataAvlblSync)
                  begin
                    NextSSPTXD           = 1'd0;
                    NextSCLK             = SPO;
                    NextBitPeriodCnt     = SCR[7:0];
                    SspTxRxCntlNextState = ST_SPISFRMEND;
                  end
                  // More transmit data available in the Transmit FIFO
                  // and SPH is programmed to a value of 0,
                  // so deassert SFRM for one SCLK phase time.
                  
                else if (TxDataAvlblSync & ~SPH)
                  begin
                    NextSSPTXD           = 1'd0;
                    NextSCLK             = SPO;
                    
                    NextBitPeriodCnt     = SCR[7:0];
                    SspTxRxCntlNextState = ST_SPISD1;
                  end

                // SPISFRMEn bit is set, so SFRM needs to be deactivated for
                // one SCLK phase time.
                else if (TxDataAvlblSync & (SPH & SPISFRMEn))
                  begin
                    NextSSPTXD           = 1'd0;
                    NextSCLK             = SPO;
                    NextSFRM             = 1'b1;
 
                    NextBitPeriodCnt     = SCR[7:0];
                    SspTxRxCntlNextState = ST_SPISD2;
                  end
                  // More transmit data available in the Transmit FIFO
                  // and the value of SPH is programmed to 1,
                  // so clock in the MSBit of Transmit data onto the TXDSS
                  // line and load the shift register with the next 15 bits
                  // in the Transmit Data, appended with a 0. SFRM
                  // does not need to be de-asserted between 
                  // successive data characters.
                    
                else if (TxDataAvlblSync & SPH & ~SPISFRMEn)
                  begin
                    NextSSPTXD          = TxFRdDataIn[15];
                    NextSTxFRdPtrInc    = 1'd1;
                    NextTxShft          = {TxFRdDataIn[14:0],1'b0};
                    NextBitCnt          = DSS[3:0];
                    NextRxShft          = 15'b000000000000000;
                    // Drive the XOR of SPO and SPH on the SCLK line.
                    // Shift the Transmit shift register left by one bit 
                    // position and reload the BitPeriodCnt counter
                    // with SCR.
                        
                    NextSCLK             = (SPO ^ SPH);
                    NextBitPeriodCnt     = SCR[7:0];
                    SspTxRxCntlNextState = ST_SPITX1;
                  end
              end
              // In the normal mode i.e. when Nibmode is not asserted,
              // decrement  the BitPeriodCnt counter by 1 on every
              // SSPCLKDIV pulse.
                
            else if (SSPCLKDIV & ~BitPeriodCmp & ~Nibmode)
              begin
                NextBitPeriodCnt     = BitPeriodCnt - 1;
                SspTxRxCntlNextState = ST_SPILASTRX;
              end
              // In the Nibble mode i.e. when Nibmode is asserted, decrement 
              // the BitPeriodCnt counter by 17 on every SSPCLKDIV pulse.
                
            else if (SSPCLKDIV & ~BitPeriodCmp & Nibmode)
              begin
                NextBitPeriodCnt     = BitPeriodCnt - 17;
                SspTxRxCntlNextState = ST_SPILASTRX;
              end
          end
        
        ST_SPISD1:
          begin
          // In the normal mode i.e. when Nibmode is not asserted,
          // decrement  the BitPeriodCnt counter by 1 on every
          // SSPCLKDIV pulse.
            
            if (SSPCLKDIV & ~BitPeriodCmp & ~Nibmode)
              begin
                NextBitPeriodCnt     = BitPeriodCnt - 1;
                SspTxRxCntlNextState = ST_SPISD1;
              end
              // In the Nibble mode i.e. when Nibmode is asserted, decrement 
              // the BitPeriodCnt counter by 17 on every SSPCLKDIV pulse.
                
            else if (SSPCLKDIV & ~BitPeriodCmp & Nibmode)
              begin
                NextBitPeriodCnt     = BitPeriodCnt - 17;
                SspTxRxCntlNextState = ST_SPISD1;
              end
              // After one SCLK phase time, de-assert SFRM and pull
              // SCLK to its inactive level.
                
            else if (SSPCLKDIV & BitPeriodCmp)
              begin
                NextSCLK             = SPO;
                NextSFRM             = 1'd1;
                NextBitPeriodCnt     = SCR[7:0];
                SspTxRxCntlNextState = ST_SPISD2;
              end
          end
        
        ST_TISFRM3 :
          begin
          // This state produces a High phase on SCLK when SCLKcnt is greater 
          // than 0. This is used in the Extended Frame Test
            if (SSPCLKDIV & BitPeriodCmp)
              begin
                NextSCLK             = 1'b0;
                NextBitPeriodCnt     = SCR[7:0];
                SspTxRxCntlNextState = ST_TISFRM2;
              end
            else if (SSPCLKDIV & ~BitPeriodCmp)
              begin
                NextBitPeriodCnt     = BitPeriodCnt - 1;
                SspTxRxCntlNextState = ST_TISFRM3;
              end 
          end 
           
        ST_SPISD2:
          begin
          // In the normal mode i.e. when Nibmode is not asserted,
          // decrement  the BitPeriodCnt counter by 1 on every
          // SSPCLKDIV pulse.
                
            if (SSPCLKDIV & ~BitPeriodCmp & ~Nibmode)
              begin
                NextBitPeriodCnt     = BitPeriodCnt - 1;
                SspTxRxCntlNextState = ST_SPISD2;
              end
              // In the Nibble mode i.e. when Nibmode is asserted, decrement 
              // the BitPeriodCnt counter by 17 on every SSPCLKDIV pulse.
                
            else if (SSPCLKDIV & ~BitPeriodCmp & Nibmode)
              begin
                NextBitPeriodCnt     = BitPeriodCnt - 17;
                SspTxRxCntlNextState = ST_SPISD2;
              end
                
            else if (BitPeriodCmp)
              begin
                    
              // SSPCLKDIV is not currently asserted, so wait for the next
              // SSPCLKDIV pulse.
                    
                if (~SSPCLKDIV)
                  begin
                    SspTxRxCntlNextState = ST_SPIDATAAVLBL;
                  end
                  // SSPCLKDIV asserted, so start frame now. Load transmit
                  // data into the transmit shift register, initialise
                  // the BitPeriodCnt and BitCnt counters and assert the
                  // STxFRdPtrInc signal for the Transmit FIFO.
                    
                else if (SSPCLKDIV)
                  begin
                    NextSSPOE            = 1'd1;
                    NextSFRM             = 1'd0;
                    NextSTxFRdPtrInc     = 1'd1;
                    NextBitPeriodCnt     = SCR[7:0];
                    NextBitCnt           = DSS[3:0];
                    NextTxShft           = TxFRdDataIn[15:0];
                    NextRxShft           = 15'b000000000000000;
                    SspTxRxCntlNextState = ST_SPISFRM;
                  end
              end
          end
        
        ST_RESET:
          begin
          // Texas Instruments' Synchronous Serial frame format
          // selected and the SSP is enabled.
                
            if (~FRF[1] & FRF[0] & SSESync)
              begin
              // Initialise the outputs to their inactive values.
                    
                NextSTxRxBSY         = 1'd0;
                NextSSPOE            = 1'd0;
                NextSSPTXD           = 1'd0;
                NextSCLK             = 1'd0;
                NextSFRM             = 1'd0;
                SspTxRxCntlNextState = ST_TIIDLE;
              end
              // Motorola SPI Frame format selected and the SSP is enabled.
                
            else if (~FRF[1] & ~FRF[0] & SSESync)
              begin
              // Initialise the outputs to their inactive values.
                    
                NextSTxRxBSY         = 1'd0;
                NextSSPOE            = 1'd0;
                NextSSPTXD           = 1'd0;
                NextSCLK             = SPO;
                NextSFRM             = 1'd1;
                SspTxRxCntlNextState = ST_SPIIDLE;
              end
              // National Microwire Frame format selected and the
              // SSP is enabled.
                
            else if (FRF[1] & ~FRF[0] & SSESync)
              begin
              // Initialise the outputs to their inactive values.
                  
                NextSTxRxBSY         = 1'd0;
                NextSSPOE            = 1'd0;
                NextSSPTXD           = 1'd0;
                NextSCLK             = 1'd0;
                NextSFRM             = 1'd1;
                SspTxRxCntlNextState = ST_NMIDLE;
              end
          end
        default:
          begin
            NextSTxRxBSY         = 1'd0;
            NextSSPOE            = 1'd0;
            NextSSPTXD           = 1'd0;
            NextSCLK             = (~FRF[1] & ~FRF[0] & SPO);
            NextSFRM             = ~FRF[0];
            NextSTxFRdPtrInc     = 1'd0;
            NextSRxFWr           = 1'd0;
            NextRxFWrData        = 16'h0000;
            SspTxRxCntlNextState = ST_RESET;
          end
      endcase
    end
        // Any state overrides...
end

always @(posedge SSPCLK or negedge nSSPRES)
begin
// When nSSPRES is asserted, transition to the ST_RESET state and
// wait for the SSP to be enabled.
        
  if (~nSSPRES)
    begin
      BitPeriodCnt <= 8'b11111111;
    end
  else if (ClkEnable)
    begin
      BitPeriodCnt <= NextBitPeriodCnt;
    end
end

always @(posedge SSPCLK or negedge nSSPRES)
begin
// When nSSPRES is asserted, transition to the ST_RESET state and
// wait for the SSP to be enabled.
        
  if (~nSSPRES)
    begin
      BitCnt <= 4'b1111;
    end
  else if (ClkEnable)
    begin
      BitCnt <= NextBitCnt;
    end
end

always @(posedge SSPCLK or negedge nSSPRES)
begin
// When nSSPRES is asserted, transition to the ST_RESET state and
// wait for the SSP to be enabled.
        
  if (~nSSPRES)
    begin
      TxShft <= 16'b0000000000000000;
    end
  else if (ClkEnable)
    begin
      TxShft <= NextTxShft;
    end
end

always @(posedge SSPCLK or negedge nSSPRES)
begin
// When nSSPRES is asserted, transition to the ST_RESET state and
// wait for the SSP to be enabled.
        
  if (~nSSPRES)
    begin
      RxShft <= 15'b000000000000000;
    end
  else if (ClkEnable)
    begin
      RxShft <= NextRxShft;
    end
end

endmodule
//  Signals: SspTxRxCntlState<5:0> SspTxRxCntlNextState<5:0> 
//    ST_TIIDLE	000000
//    ST_TISFRM2	000001
//    ST_TISHIFT1	000011
//    ST_TISTG2	000010
//    ST_TISHIFT2	000110
//    ST_TISSPOE1	000111
//    ST_TILASTBIT	000101
//    ST_TITXFNE	000100
//    ST_TISFRM1	001100
//    ST_TIDATAAVLBL	001101
//    ST_TISSPOE2	001111
//    ST_NMIDLE	001110
//    ST_NMDATAAVLBL	001010
//    ST_NMSFRM	001011
//    ST_NMTXBIT	001001
//    ST_NMTXBIT2	001000
//    ST_NMWAIT1	011000
//    ST_NMWAIT2	011001
//    ST_NMRX1	011011
//    ST_NMRX2	011010
//    ST_NMSFRMLAST	011110
//    ST_NMRXLAST	011111
//    ST_NMTXFNE	011101
//    ST_SPIIDLE	011100
//    ST_SPIDATAAVLBL	010100
//    ST_SPISFRM	010101
//    ST_SPITX1	010111
//    ST_SPIRX1	010110
//    ST_SPITX2	010010
//    ST_SPIRX2	010011
//    ST_SPISFRMEND	010001
//    ST_SPILASTTX	010000
//    ST_SPILASTRX	110000
//    ST_SPISD1	110001
//    ST_SPISD2	110011
//    ST_RESET	110010
