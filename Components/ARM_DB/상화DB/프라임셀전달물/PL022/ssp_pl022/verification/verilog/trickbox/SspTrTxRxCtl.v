// --=========================================================================--
//  This confidential  &&  proprietary software may be used only as
//  authorised by a licensing agreement from ARM Limited
//    (C) COPYRIGHT 1999 ARM Limited
//        ALL RIGHTS RESERVED
//  The entire notice above must be reproduced on all authorised
//  copies  &&  copies may only be made to the extent permitted
//  by a licensing agreement from ARM Limited.
//
// -----------------------------------------------------------------------------
//  Version  &&  Release Control Information:
//
//  File Name              : SspTrTxRxCtl.v.rca
//  File Revision          : 1.1
//
//  Release Information    : PrimeCell(TM)-PL022-REL1v2
//
// -----------------------------------------------------------------------------
// Purpose          : This block consists of the main Transmit/Receive
//                    control Logic.
// -----------------------------------------------------------------------------

`timescale 1ns/1ps
 
// -----------------------------------------------------------------------------
 
module SspTrTxRxCtl( 
                    PRESETn, 
                    SCLK,  
                    SFRM,  
                    SSTBESync,
                    TxDataAvlblSync,
                    DSS,
                    FRF,
                    SCR,
                    SPO,
                    SPH,
                    TxFRdDataIn,
                    SSPRXDIn , 
                    TxFRdPtrInc,
                    RxFWr,  
                    TxRxBSY,
                    ChkTxBSY,
                    SSPTXD,
                    RxFWrData 
                   );

input         PRESETn;           // APB Bus Reset 
input         SCLK;            // Serial clock
input         SFRM;            // Serial frame
input         SSTBESync;       // SSPTB enable
input         TxDataAvlblSync; // Tx data available
input   [3:0] DSS;             // Bits per frame
input   [1:0] FRF;             // Frame format
input   [7:0] SCR;             // Serial clock rate
input         SPO;             // SCLK polarity
input         SPH;             // SCLK phase
input  [15:0] TxFRdDataIn;     // Left justified
input         SSPRXDIn;        // Loopback muxed SSPRXD
output        TxFRdPtrInc;     // Tx FIFO read ptr incr.
output        RxFWr;           // Rx FIFO write enable
output        TxRxBSY;         // SSP Tx/Rx controller busy
output        ChkTxBSY;        // SSP Tx/Rx controller busy
output        SSPTXD;          // Serial transmit output
output [15:0] RxFWrData;       // Rx FIFO write data

// -----------------------------------------------------------------------------
//
//                            SspTrTxRxCtl
//                            ============
//
// ----------------------------------------------------------------------------- 
// Overview
// ========
//
//  This block constitutes the main transmit / receive control logic in the
// SSPtickbox. Transmit data is first loaded into a 16-bit Transmit Shift 
// Register  &&  bits are shifted out onto the SSPTXD output line (MSBit first).
//  Receive data sampled on the RXDSSIn input is shifted into an internal
// shift register  &&  when a complete frame is received, received data is
// copied into a receive buffer from the shift register. When the last data
// bit is sampled on the RXDSSIn input, it is copied into the Receive
// Buffer along with the contents of the receive shift register. Thus, the
// receive shift register is 15 bits wide  &&  the receive buffer is 16 bits
// wide.
//  Interaction with the Transmit FIFO occurs through the TxFRdPtrInc
// signal.This signal is asserted when half the number of the bits of a frame 
// are transmitted. In order to ensure that the signal gets synchronised to PCLK
//  &&  is seen by the Transmit FIFO, the signal is kept asserted for multiple 
// clocks.
// The deassertion of the TxFRdPtrInc signal is done, when the TxData is loaded
// into the shift register. 
// Thus the TxFRdPtrInc signal is kept asserted for 4 SSPCLK periods. Since
// the assumption is that the frequency of PCLK is equal to or greater than
// that of SSPCLK, this signal is assured to be seen in the PCLK domain.
// This corresponds to a worst case minimum of one half of 4 bits i.e. 2
// bit periods.This corresponds to 4 SSPCLK periods.
//  Interaction with the Receive FIFO occurs through the RxFWr signal which
// is also asserted for two SCLK periods. 
//
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
//  Constant declarations
// -----------------------------------------------------------------------------
`define NWDSS   4'b1000
// DSS for National Microwire Mode Transmission 
  
// -----------------------------------------------------------------------------
// Wire  declarations
// -----------------------------------------------------------------------------

wire        PRESETn;
// APB Bus Reset 

wire        SCLK;
// Serial clock

wire        SFRM;
// Serial frame

wire        SSTBESync;
// SSPTB enable

wire        TxDataAvlblSync; 
// Tx data available

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

wire [15:0] TxFRdDataIn;
// Left justified

wire        SSPRXDIn;
// Loopback muxed SSPRXD


// -----------------------------------------------------------------------------
// Register declarations
// -----------------------------------------------------------------------------

reg LocalTxRxBSY;
// Internal SspTrickbox busy 

reg ChkTxBSY;
// Internal SspTrickbox Tx busy 

reg LocalSSPTXD;
// Internal SspTrickbox Transmit signal

reg LocalTxFRdPtrInc;
// Internal TxFIFO Pointer increment signal 

reg LocalRxFWr;
// Internal RxFIFO Write signal 

reg DelayRxFWr;
//  Delayed RxFIFO Write signal 

reg [15:0] LocalRxFWrData;
// Internal  RxFIFO Write Data  

reg DelayTxFRdPtrInc;
// Delayed TxFIFO Pointer increment signal 

wire LocalSFRM;
// Internal Serial Frame

reg NEWTITxEn;
// New TI Transmit  Serial Frame

reg NEWTIRxEn;
// New TI receive  Serial Frame

reg [15:0] TxShft;
// Transmit Shift register 

reg [15:0]TxMShft;

reg [15:0]RxShft;
// receive Shift register 

reg [3:0]TxCount;       
// Transmit Data  counter 

reg [3:0]RxCount;       
// Receive  Data  counter 

reg NWTXEn;  
// National microwire Transmit enable 

reg NWRXEn;  
// National microwire Receive enable 

reg NewMSFRM;  
// New Motorola Mode SFRM 

reg NewMRST ;  
// Reset for NewMSRM 

reg NewTXF;   
// New Nmicrowire TXFlag 

wire[3:0] HDSS ;
// DSS divide by 2 value 

wire[3:0] NWRDSS;

// -----------------------------------------------------------------------------
//
// Main body of code
// =================
//
// -----------------------------------------------------------------------------

// ----------------------------------------------------------------------------
// Local signal assignment
// -----------------------------------------------------------------------------
assign TxRxBSY      = LocalTxRxBSY  &&  SSTBESync ;
assign TxFRdPtrInc  = LocalTxFRdPtrInc;
assign RxFWr        = LocalRxFWr;
assign RxFWrData    = LocalRxFWrData;
assign HDSS         = {1'b0, DSS[3:1]}; 
assign NWRDSS       = (DSS - 1); 
assign #3 LocalSFRM = SFRM;

// -----------------------------------------------------------------------------
// Tristate the TXD line, when there is no Transmission 
// -----------------------------------------------------------------------------
assign  SSPTXD  = (((TxRxBSY == 1'b1) &(~(FRF == 2'b10))) || 
                   ((TxRxBSY == 1'b1) & (NWTXEn == 1'b1))) ? 
                   LocalSSPTXD : 1'bz; 

// ---------------------------------------------------------------------------- 
// Combinational always @ for SSPTrickbox BSY signal generation      
// ----------------------------------------------------------------------------
always @(NEWTITxEn or NEWTIRxEn or  FRF or LocalSFRM or SSPRXDIn)
begin : p_BsyCombo
  if (FRF == 2'b01) 
    begin 
      LocalTxRxBSY = NEWTITxEn  &&  NEWTIRxEn;
      ChkTxBSY  = NEWTITxEn  &&  NEWTIRxEn; 
   end 
  else if (FRF == 2'b00 || FRF == 2'b10) 
    begin 
      LocalTxRxBSY = !((LocalSFRM) & (SSPRXDIn === 1'bz));
      ChkTxBSY  = !(LocalSFRM); 
    end 
  else
    begin 
      LocalTxRxBSY = 1'b0;
      ChkTxBSY  = 1'b0;
    end 
end   // p_BsyCombo; 

// -----------------------------------------------------------------------------
// Combinational always @ for SSPTXD  
// -----------------------------------------------------------------------------
always @(TxShft or TxFRdDataIn or NewMSFRM)
begin : p_TxdCombo
  if (NewMSFRM == 1'b1) 
    LocalSSPTXD = TxFRdDataIn[15];
  else
    LocalSSPTXD = TxShft[15];
end   // p_TxdCombo; 

// ---------------------------------------------------------------------------- 
//  Main Transmission Logic . This always @ is senstised to SCLK.  
// ----------------------------------------------------------------------------
always @(SCLK or  negedge PRESETn or SSTBESync) 
begin : p_TxLogicSeq
  if (PRESETn == 1'b0) 
    begin
      LocalTxFRdPtrInc <= 1'b0;
      DelayTxFRdPtrInc <= 1'b0;
      NEWTITxEn        <= 1'b0;
      NewMRST          <= 1'b0; 
      TxCount          <= 4'b0000;
      TxShft           <= 16'b0000000000000000;
      NWRXEn           <= 1'b0;  
      NewTXF           <= 1'b0;   
    end   
  // When SSPTrickBox is disabled, Reset the all output signals. 
  else if (SSTBESync == 1'b0) 
    begin
      TxShft           <= 16'b0000000000000000;
      TxCount          <= 4'b0000;
      LocalTxFRdPtrInc <= 1'b0;
      DelayTxFRdPtrInc <= 1'b0;
      NEWTITxEn        <= 1'b0;
      NWRXEn           <= 1'b0;  
      NewTXF           <= 1'b0;
    end   
  else
    begin 
  //  Transmission Logic 
      if (FRF == 2'b01) 
        begin
    // when Frame Format is TI Mode
          if (SCLK == 1'b1) 
            begin
              if ((LocalSFRM == 1'b1)  &&  (TxCount == 4'b0000)) 
                begin
         // when SFRM is high, load the Tx Data into the TX shift Register 
                  NEWTITxEn <= 1'b1;
                  TxShft[15:0] <= TxFRdDataIn[15:0];
                end 
              else if (TxCount == DSS) 
                begin
          // when Tx Counter value equals DSS value  &&  SFRM is high  &&  load 
          // Next Tx Data into Tx shift register.otherwise reset the Tx shift
          // register.    
                  if (LocalSFRM == 1'b1) 
                    begin
                      NEWTITxEn <= 1'b1; 
                      TxCount <= 4'b0000;
                      LocalTxFRdPtrInc <= 1'b1;
                      TxShft[15:0] <= TxFRdDataIn[15:0]; 
                    end 
                  else
                    begin
                      NEWTITxEn <= 1'b0; 
                      TxShft[15:0] <= 16'b0000000000000000 ; 
                      TxCount <= 4'b0000;
                      LocalTxFRdPtrInc <= 1'b1;
                    end 
                end 
        // when Tx counter is half the DSS vaule ,then TxFiFO Read Ptr is set  
              else if (TxCount == HDSS) 
                begin 
                  TxCount <= (TxCount + 1);
                  TxShft[15:1] <= TxShft[14:0]; 
                  TxShft[0] <= 1'b0;
                  LocalTxFRdPtrInc <= 1'b1;
                end 
              else if ( NEWTITxEn == 1'b1) 
                begin
                  TxCount <= (TxCount + 1);
                  TxShft[15:1] <= TxShft[14:0]; 
                  TxShft[0] <= 1'b0;
                end
            end
        end 
      // when frame Format is  Motorola Mode.
      // In this mode, first bit is transmitted ,Immmediately when SFRM 
      // becomes low.   
      if (FRF == 2'b00) 
        begin
      // SPI -"00"-mode 
          if ((SPH == 1'b0)  &&  (SPO == 1'b0)) 
            begin   
              if (SCLK == 1'b0) 
                begin
                  if (LocalSFRM == 1'b0) 
                    begin
           // When Tx counter becomes the DSS value, reset the Tx counter    
                      if (TxCount == DSS) 
                        begin
                          TxCount <= 4'b0000; 
                          TxShft[15:0] <= TxFRdDataIn[15:0]; 
              // TxShft  <= 16'b0000000000000000;
                        end 
            // when Tx counter is half the DSS vaule, TxFiFO Read Ptr is set  
                      else if (TxCount == HDSS) 
                        begin
                          TxCount <= ((TxCount) + 1);
                          TxShft[15:1] <= TxShft[14:0];
                          TxShft[0] <= 1'b0;
                          LocalTxFRdPtrInc <= 1'b1;
                        end 
                      else if (NewMSFRM == 1'b1) 
                        begin
                          TxCount <= ((TxCount) + 1);
                          TxShft[15:1] <= TxFRdDataIn[14:0];
                          TxShft[0] <= 1'b0;
                          NewMRST <= 1'b1; 
                        end 
                      else
                        begin
                          TxCount <= ((TxCount) + 1);
                          TxShft[15:1] <= TxShft[14:0];
                          TxShft[0] <= 1'b0;
                          NewMRST <= 1'b0; 
                        end
                    end
                end
            end
            // SPI mode -2'b01 
          else if ((SPH == 1'b0)  &&  (SPO == 1'b1)) 
            begin 
              if (SCLK == 1'b1) 
                begin
                  if (LocalSFRM == 1'b0) 
                    begin
                      if (TxCount == DSS) 
                        begin
                          TxCount <= 4'b0000; 
                          TxShft[15:0] <= TxFRdDataIn[15:0]; 
                        end
      // when Tx counter is half of the DSS vaule, then TxFiFO Read Ptr is set  
                      else if (TxCount == HDSS) 
                        begin 
                          TxCount <= ((TxCount) + 1);
                          TxShft[15:1] <= TxShft[14:0];
                          TxShft[0] <= 1'b0;
                          LocalTxFRdPtrInc <= 1'b1;
                        end
                      else if  (NewMSFRM == 1'b1) 
                        begin
                          TxCount <= ((TxCount) + 1);
                          TxShft[15:1] <= TxFRdDataIn[14:0];
                          TxShft[0] <= 1'b0;
                          NewMRST <= 1'b1; 
                        end
                      else
                        begin 
                          TxCount <= ((TxCount) + 1);
                          TxShft[15:1] <= TxShft[14:0];
                          TxShft[0] <= 1'b0;
                          NewMRST <= 1'b0; 
                        end
                    end
                end
            end
        // SPIMode  - "10" 
          else if ((SPH == 1'b1)  &&  (SPO == 1'b0)) 
            begin 
              if (SCLK == 1'b1) 
                begin
                  if (LocalSFRM == 1'b0) 
                    begin
                      if (TxCount == DSS) 
                        begin
                          TxCount <= 4'b0000; 
                          TxShft[15:0] <= TxFRdDataIn[15:0]; 
                        end
            // when   Tx counter is half the DSS vaule, TxFiFO Read Ptr is set  
                      else if (TxCount == HDSS) 
                        begin
                          TxCount <= ((TxCount) + 1);
                          TxShft[15:1] <= TxShft[14:0];
                          TxShft[0] <= 1'b0;
                          LocalTxFRdPtrInc <= 1'b1;
                        end
                      else if  (NewMSFRM == 1'b1) 
                        begin
                          TxShft[15:0] <= TxFRdDataIn[15:0];
                          NewMRST <= 1'b1; 
                        end
                      else
                        begin
                          TxCount <= ((TxCount) + 1);
                          TxShft[15:1] <= TxShft[14:0];
                          TxShft[0] <= 1'b0;
                          NewMRST <= 1'b0; 
                        end
                    end
                end
            end
            // SPIMode -"11"
          else if ((SPH == 1'b1)  &&  (SPO == 1'b1)) 
            begin 
              if (SCLK == 1'b0) 
                begin
                  if (LocalSFRM == 1'b0) 
                    begin
                      if (TxCount == DSS) 
                        begin
                          TxCount <= 4'b0000; 
                          TxShft[15:0] <= TxFRdDataIn[15:0]; 
                        end
            //    when Tx Counter is Half the DSS Vaule, TxFiFO Read Ptr is set 
                      else if (TxCount == HDSS)
                        begin
                          TxCount <= ((TxCount) + 1);
                          TxShft[15:1] <= TxShft[14:0];
                          TxShft[0] <= 1'b0;
                          LocalTxFRdPtrInc <= 1'b1;
                        end
                      else if (NewMSFRM == 1'b1) 
                        begin
                          TxShft[15:0] <= TxFRdDataIn[15:0];
                          NewMRST <= 1'b1; 
                        end
                      else
                        begin
                          TxCount <= ((TxCount) + 1);
                          TxShft[15:1] <= TxShft[14:0];
                          TxShft[0] <= 1'b0;
                          NewMRST <= 1'b0; 
                        end
                    end
                end
            end     
        end   
    // When the frame format is NationalMicrowire Mode 
      if (FRF == 2'b10) 
        begin
          if (SCLK == 1'b0) 
            begin
              if (LocalSFRM == 1'b0) 
                begin
             // when National microwire Tx is enabled,  &&  it is the first bit
             // to be transmitted, Then load the Tx data into Tx shift Register.
              //  &&  disable  the Nw Rx enable bit.  
                  if ((NWTXEn == 1'b1)  &&  (NewTXF == 1'b0)) 
                    begin
                      TxShft[15:0] <= TxFRdDataIn[15:0]; 
                      NWRXEn <= 1'b0; 
                      NewTXF <= 1'b1;
                    end
              // when the Tx count equals the DSS vaule , Reset  the TxCount,  
              // Tx shift Register  &&  NewTx Flag.  
                  else if (TxCount == DSS) 
                    begin
                      TxCount <= 4'b0000; 
                      TxShft  <= 16'b0000000000000000;
                      NewTXF <= 1'b0;   
                    end
               // when the Tx count equals the one less than DSS vaule, 
              // then set  the NW RxEn Bit. 
              // Tx shift Register  
                  else if (TxCount == NWRDSS) 
                    begin 
                      TxCount <= ((TxCount) + 1);
                      TxShft[15:1] <= TxShft[14:0];
                      TxShft[0] <= 1'b0;
                      NWRXEn <= 1'b1;  
                    end
            //when Tx Counter is Half the DSS Vaule,then TxFiFO Read Ptr is set  
                  else if (TxCount == HDSS) 
                    begin
                      TxCount <= ((TxCount) + 1);
                      TxShft[15:1] <= TxShft[14:0];
                      TxShft[0] <= 1'b0;
                      LocalTxFRdPtrInc <= 1'b1;
                    end
                  else if (NewTXF == 1'b1) 
                    begin 
                      TxCount <= ((TxCount) + 1);
                      TxShft[15:1] <= TxShft[14:0];
                      TxShft[0] <= 1'b0;
                    end
                end
            end
        end
    // Reset the TX FIFORdPtrInc,when the TX Count becomes Zero.  
      if (SCLK == 1'b1) 
        begin
          if ((LocalTxFRdPtrInc == 1'b1)  &&  (TxCount == 4'b0000)) 
            begin
              LocalTxFRdPtrInc <=  1'b0;
            end
        end
    end
end    // p_TxLogicSeq;

// ---------------------------------------------------------------------
// Receive Logic
// ---------------------------------------------------------------------
always @(SCLK or  PRESETn or SSTBESync) 
begin : p_RxLogicSeq
  if (PRESETn == 1'b0) 
    begin
      LocalRxFWr     <= 1'b0;
      DelayRxFWr     <= 1'b0;
      LocalRxFWrData <= 16'b0000000000000000;
      RxShft         <= 16'b0000000000000000 ;
      RxCount        <= 4'b0000 ;
      NEWTIRxEn      <= 1'b0;
      NWTXEn         <= 1'b0; 
    end  
  // When SSPTrickBox is disabled, Then Reset the all output signals. 
  else if (SSTBESync == 1'b0) 
    begin
      LocalRxFWr     <= 1'b0;
      DelayRxFWr     <= 1'b0;
      LocalRxFWrData <= 16'b0000000000000000;
      RxShft         <= 16'b0000000000000000 ;
      RxCount        <= 4'b0000 ;
      NEWTIRxEn      <= 1'b0;
      NWTXEn         <= 1'b0;
    end  
  else
    begin 
     // when the frame format is TI mode 
      if (FRF == 2'b01) 
        begin
          if (SCLK == 1'b0) 
            begin
              if (LocalSFRM == 1'b1  &&  RxCount == 4'b0000) 
                begin
                  NEWTIRxEn <= 1'b1;
                end 
          // when Rx counter becomes DDS value, transfer the Rx shift register 
          // along with last bit into Rx FIFO write data register.  
              else if (RxCount == DSS) 
                begin 
                  if (LocalSFRM == 1'b1) 
                    begin
                      NEWTIRxEn <= 1'b1; 
                      RxCount <= 4'b0000;
                      LocalRxFWrData <= {RxShft[14:0], SSPRXDIn };
                      RxShft   <= 16'b0000000000000000 ;
                      LocalRxFWr <= 1'b1;  
                    end 
                  else
                    begin
                      NEWTIRxEn <= 1'b0; 
                      RxCount <= 4'b0000;
                      LocalRxFWrData <= {RxShft[14:0], SSPRXDIn};
                      RxShft   <= 16'b0000000000000000 ;
                      LocalRxFWr <= 1'b1;  
                    end 
                end 
              else if (NEWTIRxEn == 1'b1) 
                begin 
                  RxShft[0]  <=  SSPRXDIn ;
                  RxCount <= ((RxCount) + 1);
                  RxShft[14:1]  <= RxShft[13:0] ;
                end
            end
        end 
      // when the  frame format is Motorola Mode 
      if (FRF == 2'b00) 
        begin
        // SPI -"00"
          if (((SPH == 1'b0)  &&  (SPO == 1'b0)) || 
               ((SPH == 1'b1)  &&  (SPO == 1'b1))) 
            begin
              if (SCLK == 1'b1) 
                begin
                  if (LocalSFRM == 1'b0) 
                    begin
                      RxShft[0]  <=  SSPRXDIn ;
          // when Rx counter becomes DDS value, transfer the Rx shift register 
          // along with last bit into Rx FIFO write data register.  
                      if (RxCount == DSS) 
                        begin
                          RxCount <= 4'b0000;
                          LocalRxFWrData <= {RxShft[14:0], SSPRXDIn};
                          RxShft   <= 16'b0000000000000000 ;
                          LocalRxFWr <= 1'b1;  
                        end 
                      else
                        begin  
                          RxCount <= ((RxCount) + 1);
                          RxShft[14:1]  <= RxShft[13:0] ;
                        end 
                    end 
                end
            end
          else if (((SPH == 1'b0)  &&  (SPO == 1'b1)) || 
               ((SPH == 1'b1)  &&  (SPO == 1'b0))) 
            begin
              if (SCLK == 1'b0) 
                begin
                  if (LocalSFRM == 1'b0) 
                    begin
                      RxShft[0]  <=  SSPRXDIn ;
          // when Rx counter becomes DDS value, transfer the Rx shift register 
          // along with last bit into Rx FIFO write data register.  
                      if (RxCount == DSS) 
                        begin
                          RxCount <= 4'b0000;
                          LocalRxFWrData <= {RxShft[14:0], SSPRXDIn};
                          RxShft   <= 16'b0000000000000000 ;
                          LocalRxFWr <= 1'b1;  
                        end 
                      else
                        begin
                          RxCount <= ((RxCount) + 1);
                          RxShft[14:1]  <= RxShft[13:0] ;
                        end 
                    end 
                end
            end
        end
         // when the frame format is National microwire  
      if (FRF == 2'b10) 
        begin
          if (SCLK == 1'b1) 
            begin
              if (LocalSFRM == 1'b0) 
                begin
                  if (NWRXEn == 1'b1) 
                    NWTXEn <= 1'b0;
                  if (NWTXEn <= 1'b0) 
                    begin   
                      RxShft[0]  <=  SSPRXDIn ;
                      if (RxCount == `NWDSS) 
                        begin
                          NWTXEn  <= 1'b1;  
                          RxCount <= 4'b0000;
                          LocalRxFWrData <= RxShft[15:0] ;
                          RxShft   <= 16'b0000000000000000 ;
                          LocalRxFWr <= 1'b1;  
                        end 
                      else
                        begin
                          RxCount <= ((RxCount) + 1);
                          RxShft[14:1]  <= RxShft[13:0] ;
                        end 
                    end 
                end 
            end
        end
      if ((LocalRxFWr == 1'b1)  &&  (DelayRxFWr == 1'b0)) 
        begin
          DelayRxFWr <= 1'b1;
        end   
      if ((LocalRxFWr == 1'b1)  &&  (DelayRxFWr == 1'b1))
        begin
          DelayRxFWr  <= 1'b0;
          LocalRxFWr  <= 1'b0;            
        end
    end 
end    // p_RxLogicSeq;

// -----------------------------------------------------------------------------
// NewSFRM generation for Motorola Mode 
// -----------------------------------------------------------------------------
always @(negedge SFRM or  negedge PRESETn or  posedge NewMRST)
begin : p_seqNewMSFRM
  if ((PRESETn == 1'b0) || (NewMRST == 1'b1))
    NewMSFRM <= 1'b0; 
  else if (SSTBESync == 1'b0) 
    NewMSFRM <= 1'b0; 
  else if (SFRM == 1'b0) 
    begin
      if (FRF == 2'b00) 
          NewMSFRM <= 1'b1; 
    end                 
end    // p_seqNewMSFRM;

endmodule

//  --============================= End ======================================--
 
