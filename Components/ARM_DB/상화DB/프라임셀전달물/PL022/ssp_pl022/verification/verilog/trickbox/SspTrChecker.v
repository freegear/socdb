// --=========================================================================--
//  This confidential  &&  proprietary software may be used only as
//  authorised by a licensing agreement from ARM Limited
//    (C) COPYRIGHT 1999 ARM Limited
//        ALL RIGHTS RESERVED
//  The entire notice above must be reproduced on all authorised
//  copies  &&  copies may only be made to the extent permitted
//  by a licensing agreement from ARM Limited.
//
//  ----------------------------------------------------------------------------
//  Version  &&  Release Control Information:
//
//  File Name              : SspTrChecker.v.rca
//  File Revision          : 1.1
//
//  Release Information    : PrimeCell(TM)-PL022-REL1v2
//
// -----------------------------------------------------------------------------
// Purpose      : Checker module for checking the protocols  &&  
//                SCLK width.
// -----------------------------------------------------------------------------

`timescale 1ns/1ps

// -----------------------------------------------------------------------------

 
`define OFFSET 2'b10 

// -----------------------------------------------------------------------------

module SspTrChecker( 
                    PCLK,     
                    SSPCLK,  
                    PRESETn,  
                    SCLK,  
                    SFRM,        
                    SFRMOUT,        
                    SCLKOUT,  
                    SSPRXD,      
                    SPO,       
                    SPH,        
                    SSESync,      
                    TxRxBSY,       
                    STxRxBSY,       
                    ChkTxBSY,       
                    MS,
                    OD,   
                    TiDASFRM,
                    SSPOE,
                    DSS,        
                    FRF, 
                    SCR,      
                    PRESCALE,  
                    GENCLK1,
                    SSPTBCLKREG, 
                    SSPTBCLKREG1 
                   );

input        PCLK;         // PCLK input
input        SSPCLK;       // SSPCLK input
input        PRESETn;        // RESET pin
input        SCLK;         // SCLK input pin
input        SCLKOUT;      // SCLKOUT from SspTrSTxRxCntl
input        SFRM;         // Serial Frame input
input        SFRMOUT;      // SFRMOUT from  Tx/Rx Controler
input        SSPRXD;       // Serial Receive data input
input        SPO;          // Polarity of SCLK for SPI mode
input        SPH;          // Phase of SCLK for SPI mode
input        SSESync;      // Trickbox Enable input
input        TxRxBSY;      // Busy status of Master-testing block 
input        STxRxBSY;     // Busy status of Slave-testing block
input        ChkTxBSY;     // TX Busy
input        MS;           // Master/Slave select input
input        OD;           // Ignore SSP output
input        TiDASFRM;     // Disable TI protocol check
input        SSPOE;        // SSP output Enable
input  [3:0] DSS;          // Data size select
input  [1:0] FRF;          // Frame format
input  [7:0] SCR;          // Serial Clock rate
input  [3:0] PRESCALE;     // Prescale value
input        GENCLK1;      // Indicates SSPCLK1 is routed to the SSP
input [15:0] SSPTBCLKREG;  // SSPCLK time period value
input [15:0] SSPTBCLKREG1; // SSPCLK1 time period value

// -----------------------------------------------------------------------------
//
//                             SspTrChecker
//                             ============
//
// -----------------------------------------------------------------------------
//
// Overview
// ======== 
//
// This module checks the protocol for the TI, Motorola SPI  &&  National  
// MicroWire modes. The check is also done to measure the width of the SCLK
// and SFRM. Data Setup and Hold Times are measured and it is ensured that 
// a minimum Setup/Hold time of half SCLK is present. Any discrepancy is
// reported.
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Wire declarations
// -----------------------------------------------------------------------------
wire        PCLK;
// PCLK wire

wire        SSPCLK;
// SSPCLK wire

wire        PRESETn;
// RESET pin

wire        SCLK;
// SCLK wire pin

wire        SCLKOUT;
// SCLKOUT from SspTrSTxRxCntl

wire        SFRM;
// Serial Frame wire

wire        SFRMOUT;
// SFRMOUT from  Tx/Rx Controler

wire        SSPRXD;
// Serial Receive data wire

wire        SPO;
// Polarity of SCLK for SPI mode

wire        SPH;
// Phase of SCLK for SPI mode

wire        SSESync;
// Trickbox Enable wire

wire        TxRxBSY;
// Busy status of Master-testing block 

wire        STxRxBSY;
// Busy status of Slave-testing block

wire        ChkTxBSY;
// TX Busy

wire        MS;
// Master/Slave select wire

wire        OD;
// Ignore SSP output

wire        TiDASFRM;
// Disable TI protocol check

wire        SSPOE;
// SSP output Enable

wire  [3:0] DSS;
// Data size select

wire  [1:0] FRF;
// Frame format

wire  [7:0] SCR;
// Serial Clock rate

wire  [3:0] PRESCALE;
// Prescale value

wire        GENCLK1;
// Indicates SSPCLK1 is routed to the SSP

wire [15:0] SSPTBCLKREG;
// SSPCLK time period value

wire [15:0] SSPTBCLKREG1;
// SSPCLK1 time period value

// -----------------------------------------------------------------------------
// Register declarations
// -----------------------------------------------------------------------------
reg [64:0] SCLKRiseEdge;   
// Rise Time of SCLK

reg [64:0] SFRMRiseEdge;  
// Rise Time of SFRM

reg [64:0] SetupStartTime; 
// Start of Setup time

reg [64:0] HoldStartTime; 
// Start of Hold time

reg [64:0] SCLKFallEdge; 
// Time at the falling Edge of SCLK

reg [64:0] SFRMFallEdge; 
// Time at the falling Edge of SFRM

reg [64:0] SetupEndTime;  
// End of Setup time

reg [64:0] HoldEndTime;     
// End of Hold time

reg [64:0] SFRMREFTIME;     
// Time for which SFRM shuld be active in TI mode

reg [3:0]  Rxcounter;       
// Used to count 8 SCLKs for MW mode to indicate that transmission is over. 

reg [4:0]  Txcounter;
// Used to count SCLKs depending on the DSS in MW mode in receive mode.

reg [4:0] CountRxData;
// Reg for counting the number of data bits received

reg [32:0] SCLKREFVALUE;
// Used to compute the period of SCLK

reg [17:0] SYNCOFFSET;
// Tolerance setting for timing checks to account for gate delay variations

reg [16:0] SSPCLKPRD;
// Used to compute the period of SSPCLK when the SSP is operating at a SSPCLK
// frequency different from that of the Trickbox

reg [17:0] SSPCLKPRD2;
// Used to generate the MSSync  SSPCLK 

reg SCLKFlag1; 
// Flag for the high phase of SCLK

reg SCLKFlag2; 
// Flag for the low phase of SCLK  

reg SFRMFlag;    
// Flag to capture edges of SFRM 

reg SFRMFlag2;    
// Flag to capture edges of SFRM 

reg SetupFlag; 
// Flag used to capture the Setup time

reg HoldFlag;  
// Flag used to capture the Hold time

reg SSPRXDFlag;   
// Flag used to ensure that the data has arrived correctly at the falling  
// edge of SFRM in the SPI mode

reg TxRxBSYFlag;  
// Flag to detect the condition when the receive line is tri-state and TxRxBSY 
// is present

reg RxBeginFlag;    
// Flag to indicate the begin of a receive in MW mode 

reg TxBeginFlag;    
// Flag to indicate the begin of a transmit in MW mode 

reg Flag;
// Flag used for NM protocol check.

wire [4:0] iDSS;  
// Internal version of DSS

reg DelSTxRxBSY;
// Delayed STxRxBSY for TI mode

reg DelSFRMOUT;
// Delayed SFRMOUT For TI mode

reg DelSFRM;
// Delayed SFRM 

reg ModSSPOE;
// Modified SSPOE For NMW Z Test

reg DelSFRMOUT2;
// Delayed SFRMOUT for 3 SSP Clock

reg MSSync;
// Two SSPCLK delayed version 

// -----------------------------------------------------------------------------
//
// Main body of code
// =================
//
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Initialization of the registers used in the module
// -----------------------------------------------------------------------------

initial
begin
  SFRMFlag2      <= 1'b0;
  DelSTxRxBSY    <= 1'b0;
  DelSFRMOUT     <= 1'b0;
  DelSFRMOUT2    <= 1'b0;
  RxBeginFlag    <= 1'b0;
  TxBeginFlag    <= 1'b0;
  Rxcounter      <= 4'b0000;
  Txcounter      <= 5'b00000;
  CountRxData    <= 5'b00000;
  SCLKREFVALUE   <= 32'h00000000;
  SYNCOFFSET     <= 17'b00000000000000000;
  SSPCLKPRD      <= 16'b0000000000000000;
  SSPCLKPRD2     <= 17'b00000000000000000;
  Flag           <= 1'b0;
  TxRxBSYFlag    <= 1'b0;
  SFRMRiseEdge   <= 64'b0;
  SFRMFallEdge   <= 64'b0;
  SCLKRiseEdge   <= 64'b0;
  SCLKFallEdge   <= 64'b0;
  SetupStartTime <= 64'b0;
  SetupEndTime   <= 64'b0;
  HoldStartTime  <= 64'b0;
  HoldEndTime    <= 64'b0;
end

assign iDSS = {1'b0, DSS};

// -----------------------------------------------------------------------------
// Calculation of SCLK pulse width from the registers 
// SCLKTBCLKREG, SCR, PRESCALE according to the formula 
// SCLKPhaseTimePeriod == SCLKTBCLKREG * PRESCALE * (SCR + 1)
// -----------------------------------------------------------------------------
always @(SSESync or PRESCALE or SCR or TxRxBSY or GENCLK1 or SSPRXD)
begin : p_CalcSCLKComb
  if (SSESync == 1'b1)
    begin
      if (PRESCALE == 4'b0000)
        begin
          $display($time,"Error : PRESCALE value not defined");
        end
      else
        begin
          SCLKREFVALUE = SSPTBCLKREG * PRESCALE * (SCR + 1);
          if (GENCLK1 == 1'b0)
            begin
              SYNCOFFSET   = SSPTBCLKREG * 3;
              SSPCLKPRD    = 16'b0000000000000000;
            end
          else
            begin
              SYNCOFFSET   = SSPTBCLKREG1 * 3;
              SSPCLKPRD    = SSPTBCLKREG1 * 2;
            end
        end
    end
  if ((TxRxBSY == 1'b1) && (SSPRXD === 1'bz))
    begin
      TxRxBSYFlag = 1'b1;
    end
  else if ((TxRxBSY == 1'b0) && (SSPRXD === 1'bz))
    begin
      TxRxBSYFlag = 1'b0;
    end
end   // p_CalcSCLKComb;

// -----------------------------------------------------------------------------
// Getting the period of SCLK pulse for later verification
// This always @ captures the positive  &&  the negative edges of SCLK
// The always @ is sensitized to SCLK
// SCLKFlag1 is used as a flag for the High Phase
// SCLKFlag2 is used as a flag for the Low Phase
// -----------------------------------------------------------------------------
always @(SCLK or negedge SSESync or negedge PRESETn or negedge ChkTxBSY)
begin : p_GetSCLKedgesSeq
  if ((PRESETn == 1'b0) | (SSESync == 1'b0) | (ChkTxBSY == 1'b0)) 
    begin
      SCLKFlag1 = 1'b0;
      SCLKFlag2 = 1'b0;
    end 
  else if (SCLK == 1'b1) 
    begin
      if (SCLKFlag1 == 1'b0)
        begin
          SCLKRiseEdge = $time;
          SCLKFlag1 = 1'b1;
        end
      if (SCLKFlag2 == 1'b1)
        begin
          SCLKRiseEdge = $time;
          SCLKFlag2 = 1'b0;
        end
    end 
  else if (SCLK == 1'b0)
    begin
      if (SCLKFlag2 == 1'b0)
        begin
          SCLKFallEdge = $time;
          SCLKFlag2 = 1'b1;
        end
      if (SCLKFlag1 == 1'b1)
        begin
          SCLKFallEdge = $time;
          SCLKFlag1 = 1'b0;
        end 
    end
end   // p_GetSCLKedgesSeq;

// -----------------------------------------------------------------------------
// Checking for validity of SCLK width.   
// The difference in time between the rising  &&  the falling edge of the 
// SCLK is compared with the value calculated from the registers  &&  an Offset
// is provided for Gate Level Simulations.
// -----------------------------------------------------------------------------
always @(negedge SCLKFlag2)
begin : p_ChecklowphaseSeq
  if (SCLKFlag2 == 1'b0)
    begin
      if ((SSESync == 1'b1) && (ChkTxBSY == 1'b1))
        begin
          if (((SCLKRiseEdge - SCLKFallEdge) > (SCLKREFVALUE + `OFFSET))
              || ((SCLKRiseEdge - SCLKFallEdge) < (SCLKREFVALUE - `OFFSET)))
            $display($time, "ERROR : SCLK ERROR in the low phase");
        end
    end
end   // p_ChecklowphaseSeq;

always @(negedge SCLKFlag1)
begin : p_CheckhighphaseSeq
  if (SCLKFlag1 == 1'b0)
    begin
      if ((SSESync == 1'b1) && (ChkTxBSY == 1'b1))
        begin
          if ((SCLKFallEdge - SCLKRiseEdge) > (SCLKREFVALUE + `OFFSET)
             || (SCLKFallEdge - SCLKRiseEdge) < (SCLKREFVALUE - `OFFSET))
            $display($time, "ERROR : SCLK ERROR in the high phase");
        end
    end
end   // p_CheckhighphaseSeq;

// -----------------------------------------------------------------------------
// This always @ checks for the signal SCLK at the time SFRM goes low
// in the Motorola SPI mode. The values to be present in the SCLK line are as
// follows 
//
//       00        -     0
//       01        -     1 
//       10        -     0
//       11        -     1
//
// The always @ is sensitized to SFRM
// -----------------------------------------------------------------------------
always @(negedge SFRM)
begin : p_MotSCLKcheckSeq
  if (SSESync == 1'b1)
    begin
      if (SFRM == 1'b0)
        begin
          if (FRF == 2'b00)
            begin 
              if (SPH == 1'b0 && SPO == 1'b0)
                begin
                  if (SCLK != 1'b0)
                    $display($time,"SCLK not initially low in SPI 00 mode");
                end
              else if (SPH == 1'b0 && SPO == 1'b1)
                begin
                  if (SCLK != 1'b1)
                    $display($time,"SCLK not initially high in SPI 01 mode");
                end
              else if (SPH == 1'b1 && SPO == 1'b0)
                begin
                  if (SCLK != 1'b0)
                    $display($time,"SCLK not initially low in SPI 10 mode");
                end
              else if (SPH == 1'b1 && SPO == 1'b1)
                begin
                  if (SCLK != 1'b1) 
                    $display($time,"SCLK not initially high in SPI 11 mode");
                end
            end
        end
    end
end   // p_MotSCLKcheckSeq

// -----------------------------------------------------------------------------
// Getting the period of SFRM pulse for later verification
// For TI mode
// -----------------------------------------------------------------------------
always @(SFRM or negedge SSESync)                          
begin : p_GetSFRMedgesSeq
  if (SSESync == 1'b0) 
    begin
      SFRMFlag = 1'b0;
    end 
  if (SSESync == 1'b1)
    begin
      if (SFRM == 1'b1)
        begin
          SFRMREFTIME = SCLKREFVALUE * 2;
          if (SFRMFlag == 1'b0)
            begin
              SFRMRiseEdge = $time;
              SFRMFlag = 1'b1; 
            end
        end
      else if (SFRM == 1'b0)
        begin
          if (SFRMFlag == 1'b1)
            begin
              SFRMFallEdge = $time;
              SFRMFlag = 1'b0;
            end
        end
    end
end   // p_GetSFRMedgesSeq;

// -----------------------------------------------------------------------------
// Checking for SFRM width in TI mode
// Check if SFRM is going high at the right place after transmission
// -----------------------------------------------------------------------------
always @(SFRMFlag)
begin
  if ((SFRMFlag == 1'b0) & (MS == 1'b0))
    begin
      if (SSESync == 1'b1)
        begin
          if (FRF == 2'b01)
            begin
              if (((SFRMFallEdge - SFRMRiseEdge) > SFRMREFTIME + `OFFSET) || 
                  ((SFRMFallEdge - SFRMRiseEdge) < SFRMREFTIME - `OFFSET)) 
                $display($time,"SFRM ERROR in TI Mode");
            end
        end
    end
  else if ((SFRMFlag == 1'b1) & (MS == 1'b0))
    begin
      if (SSESync == 1'b1)
        if (SFRM == 1'b1)
        begin
          if ((FRF == 2'b00 && SPH == 1'b0 && SPO == 1'b0) || (FRF == 2'b10))
            begin
              if (((SFRMRiseEdge - SCLKFallEdge) > (SCLKREFVALUE + `OFFSET)) ||
                  ((SFRMRiseEdge - SCLKFallEdge) < (SCLKREFVALUE - `OFFSET)))
                $display($time,"SFRM HASNT GONE HIGH");
            end    
          else if (FRF == 2'b00 && SPH == 1'b1 && SPO == 1'b0)
            begin
              if (((SFRMRiseEdge - SCLKFallEdge) > SFRMREFTIME + `OFFSET) || 
                  ((SFRMRiseEdge - SCLKFallEdge) < SFRMREFTIME - `OFFSET)) 
                $display($time,"SFRM HASNT GONE HIGH in SPI 10 mode");
            end 
          else if (FRF == 2'b00 && SPH == 1'b0 && SPO == 1'b1) 
            begin
              if (((SFRMRiseEdge - SCLKRiseEdge) > (SCLKREFVALUE + `OFFSET)) ||
                  ((SFRMRiseEdge - SCLKRiseEdge) < (SCLKREFVALUE - `OFFSET))) 
                $display($time,"SFRM HASNT GONE HIGH in SPI 01 mode");
            end
          else if (FRF == 2'b00 &&  SPH == 1'b1  &&  SPO == 1'b1)
            begin
              if (((SFRMRiseEdge - SCLKRiseEdge) > SFRMREFTIME + `OFFSET) || 
                  ((SFRMRiseEdge - SCLKRiseEdge) < SFRMREFTIME - `OFFSET))
                $display($time,"SFRM HASNT GONE HIGH in SPI 11 mode");
            end
        end
    end
end  // p_CheckSFRMComb;

// -----------------------------------------------------------------------------
// Check for ensuring that the Transmit line goes Z after the transmission 
// of 8 bits. This process also checks if the data is transmitted at the edge
// of SFRM turning low. 
// -----------------------------------------------------------------------------
always @(posedge SSPCLK or SFRM or SSESync)
begin : p_CheckTxSeq
  if (SFRM == 1'b1)
    begin
      SSPRXDFlag = 1'b0;
    end
  if (SSPCLK == 1'b1)
    begin
      if (RxBeginFlag == 1'b0 && TxBeginFlag == 1'b1 && FRF == 2'b10)
        begin
          if (!(SSPRXD === 1'bz))
            $display($time,"In MW mode Transmit line is not Z");
        end
      if (SSPRXDFlag == 1'b0) 
        if (FRF == 2'b00 || FRF == 2'b10)
          if (SSESync == 1'b1 && TxRxBSY == 1'b1 && TxRxBSYFlag == 1'b0)
             if (SFRM == 1'b0)
               begin
                 SSPRXDFlag = 1'b1;
                 if (SSPRXD === 1'bz)
                   begin
                     if (FRF == 2'b00)
                       $write($time, "First Data hasnt arrived correctly");
                       $display("in SPI at SFRM");
                     if (FRF == 2'b10)  
                       $write($time, "First Data hasnt arrived correctly");
                       $display("in MW at SFRM");
                   end
               end 
    end
end  // p_CheckTxSeq;

// -----------------------------------------------------------------------------
// Protocol Checking for the National Microwire Mode
// -----------------------------------------------------------------------------
always @(posedge RxBeginFlag or negedge SFRM)
begin
  if (SFRM == 1'b0) 
    begin
      if ((FRF == 2'b10) && (RxBeginFlag == 1'b0)) 
        begin
          Flag <= 1'b1;
        end
      else if ((FRF == 2'b10) && (RxBeginFlag == 1'b1))
        begin
          Flag <= 1'b0;
        end
    end
end

always @(posedge SCLK or negedge SSESync)
begin : p_CheckMWSeq
  if (SSESync == 1'b0)
    begin
      RxBeginFlag = 1'b0;
      TxBeginFlag = 1'b0;
    end
  if (FRF == 2'b10)
    begin
      if (SCLK == 1'b1)
        begin
          if ((Flag == 1'b1) & (Rxcounter == 4'b0000))
            begin
              RxBeginFlag = 1'b1;
              Rxcounter = Rxcounter + 1;
            end
          else if ((Rxcounter == 4'b1000) & (RxBeginFlag == 1'b1))
            begin
              RxBeginFlag = 1'b0;
              Rxcounter = 4'b0000;
              TxBeginFlag = 1'b1;
            end
          else if (RxBeginFlag == 1'b1)  
              Rxcounter = Rxcounter + 1;
          else if ((Txcounter == iDSS) & (TxBeginFlag == 1'b1))
            begin
              TxBeginFlag = 1'b0;
              RxBeginFlag = 1'b1;
              Txcounter = 5'b00000;
            end
          else if (TxBeginFlag == 1'b1)
              Txcounter = Txcounter + 1;
        end
    end
end  // p_CheckMWSeq;

// -----------------------------------------------------------------------------
// This always block set the Setupflag and clears the holdflag with respect to
//  changes of SSPRXD 
// -----------------------------------------------------------------------------
always @(SSPRXD or negedge SSESync or negedge PRESETn)
begin : p_GetedgeforSetupSeq
  if (PRESETn == 1'b0) 
    begin
      SetupFlag = 1'b0;
      HoldFlag  = 1'b0;
    end
  else if (SSESync == 1'b0)
    begin
      SetupFlag = 1'b0;
      HoldFlag  = 1'b0;
    end
  else if ((STxRxBSY == 1'b0) & (MS == 1'b1))
    begin
      SetupFlag = 1'b0;
    end
   else if (SSPRXD !== 1'bz)
    begin
      if (~((FRF == 2'b01) & (((SFRM == 1'b1) &
         (MS == 1'b0)) | ((SFRMOUT == 1'b1) & (MS == 1'b1))))) 
        begin
          if ((FRF == 2'b10) & (((RxBeginFlag == 1'b0) & ~MS)
              | (ModSSPOE & MS)))
            SetupFlag = 1'b0;
          else
            begin
              SetupFlag = STxRxBSY;
              SetupStartTime = $time;
            end
        end
      if (HoldFlag == 1'b1)
        begin 
          HoldFlag = 1'b0;
          HoldEndTime = $time;
        end 
    end
end // p_GetedgeforSetupSeq

// -----------------------------------------------------------------------------
// This always block clears the Setupflag and set the hold flag on the edges of
// SCLK or SCLKOUT regarding to Master or Slave
// -----------------------------------------------------------------------------
always @(SCLK or SCLKOUT)
begin : p_GetedgeforSetupSeq1
  if (((SCLK == 1'b0) && (MS == 1'b0)) || 
      ((SCLKOUT == 1'b0) && (MS == 1'b1)))
    begin
      if ((FRF == 2'b01) || (FRF == 2'b00 && SPH == 1'b0 && SPO == 1'b1) 
         || (FRF == 2'b00 && SPH == 1'b1 && SPO == 1'b0))
        begin
          if (SetupFlag == 1'b1)
            begin
              SetupFlag = 1'b0;
              SetupEndTime = $time;
              HoldFlag = 1'b1;
              HoldStartTime = $time;
            end
        end
    end
  else if (((SCLK == 1'b1) && (MS == 1'b0)) || 
          ((SCLKOUT == 1'b1) && (MS == 1'b1)))
    begin
      if ((FRF == 2'b10) || (FRF == 2'b00 && SPH == 1'b0 && SPO == 1'b0)
         || (FRF == 2'b00 && SPH == 1'b1 && SPO == 1'b1))
        begin
          if (SetupFlag == 1'b1)
            begin
              SetupFlag = 1'b0;
              SetupEndTime = $time;
              HoldFlag = 1'b1;
              HoldStartTime = $time;
            end
        end
    end
end // p_GetedgeforSetupSeq1;   

// -----------------------------------------------------------------------------
// Check for the Setup Time  &&  indicate an error if the time is less than
// the SCLK half period.
// -----------------------------------------------------------------------------
always @(negedge SetupFlag)
begin : p_CheckSetupSeq
  if (SetupFlag == 1'b0)
    begin
      if ((SSESync == 1'b1) && (MS == 1'b0))
        begin
          if ((SetupEndTime - SetupStartTime) < (SCLKREFVALUE - `OFFSET))
            $display($time,"Setup Time violated");
        end
      else if ((SSESync == 1'b1) && (MS == 1'b1) && (STxRxBSY == 1'b1))
        begin
          if ((SetupEndTime - SetupStartTime) < (SCLKREFVALUE - 
             (`OFFSET + SYNCOFFSET)))
            $display($time,"Setup Time violated");
        end
    end
end   // p_CheckSetupSeq; 
  
// -----------------------------------------------------------------------------
// Check for the Setup Time  &&  indicate an error if the time is less than
// the SCLK half period.
// -----------------------------------------------------------------------------
always @(negedge HoldFlag)
begin : p_CheckHoldSeq
  if (HoldFlag == 1'b0)
    begin
      if ((SSESync == 1'b1) & (MS == 1'b0))
        begin
          if ((HoldEndTime - HoldStartTime) < (SCLKREFVALUE - `OFFSET))
          $display($time,"Hold Time violated");
        end
      else if ((SSESync == 1'b1) & (MS == 1'b1))
        begin
          if ((HoldEndTime - HoldStartTime) < (SCLKREFVALUE -
             (`OFFSET + SYNCOFFSET)))
          $display($time,"Hold Time violated");
        end
    end
end // p_CheckHoldSeq;

// -----------------------------------------------------------------------------
// If the SSP is in the Master mode, with the frame format set to SPI and with 
// SPH = 0, on a rising edge of SFRM, SCLK should be at the value programmed in
// SPO. Also, signals used to check the duration of SFRM deactivation in this 
// mode are initialised.
// -----------------------------------------------------------------------------
always @(posedge SFRM )
begin : p_CheckFrDeact
  if (SFRM == 1'b1)
    begin
     if ((FRF == 2'b00) && (SPH == 1'b0) && (MS == 1'b0) & (SSESync == 1'b1))
       begin
         CountRxData  <= 1'b0;
         SFRMFlag2    <= 1'b1;
         if (SCLK == ~SPO)
           begin
             $display($time,"Error : SCLK is not Default value when SFRM High");
           end
       end
    end
end  //p_CheckFrDeact;

// -----------------------------------------------------------------------------
// Verify that 
//   - the SSP negates SFRM between frames
//   - the duration of SFRM negation between frames is atleast one SCLK phase 
//     time
// -----------------------------------------------------------------------------
always @(negedge SFRM or SCLK)
begin : p_CheckFrDeact1
  if (SFRM == 1'b0)
    begin
     if ((FRF == 2'b00) && (SPH == 1'b0) && (MS == 1'b0) & (SSESync == 1'b1))
       begin
         if (SFRMFlag2 == 1'b1)
           begin
             SFRMFlag2    <= 1'b0;
             if (SFRMRiseEdge - SFRMFallEdge < (SCLKREFVALUE - `OFFSET))
               $display($time, "Error : SFRM is not  high for  half SCLK");
             if (SCLK != SPO)
               begin
                 $display($time, "Error: SCLK Not at Default value at falling edge of SFRM");
               end
           end
         if (SCLK == ~SPO)
           begin
             CountRxData = CountRxData + 1'b1;
             if (CountRxData > DSS + 1'b1)
               $display($time, "Error : SFRM is not  Deactivated ");
           end
       end
    end
end // p_CheckFrDeact1

// -----------------------------------------------------------------------------
// Generate a delayed version of SFRM for use in checking the tri-stating of the
// SSPRXD line.
// -----------------------------------------------------------------------------
always @(SFRM)
begin : GenDelSFRM
  if (SFRM == 1'b0)
    begin
      # (`OFFSET);
      DelSFRM = 1'b0;
    end
  else
    DelSFRM = 1'b1;
end // GenDelSFRM

// -----------------------------------------------------------------------------
// Verify that 
//   - the SSPRXD input is not tri-stated during the period for which DelSFRM is
//     negated between successive frames.
// -----------------------------------------------------------------------------
always @(negedge DelSFRM)
begin : p_CheckSSPRXDComb
  if (DelSFRM == 1'b0)
    begin
      if ((FRF == 2'b00) && (SPH == 1'b0) && (MS == 1'b0) & (SSESync == 1'b1) &&
           (SSPRXD === 1'bz))
        begin
          $display($time,"Error: SSPRXD is  'Z' at SFRM fall edge");
        end
    end
end // p_CheckSSPRXDComb

// -----------------------------------------------------------------------------
// In the TI mode, it is expected that the SSPRXD line from the SSP should 
// remain tri-stated when a valid frame is not being transferred. The 
// DelSTxRxBSY signal, when low indicates that the trickbox is Idle, which in
// turn indicates that the SSPRXD line should remain tri-stated.
// -----------------------------------------------------------------------------
always @(DelSTxRxBSY or SSPRXD)
begin : p_TiHighZTest
  if ((MS == 1'b1) && (FRF == 2'b01))
    begin
      if ((DelSTxRxBSY == 1'b0) && (SSPRXD !== 1'bz) && ~TiDASFRM)
        $display($time,"Error : SSPRXD is not  'Z' at Idle in Ti mode");
    end
end // p_TiHighZTest
        
// -----------------------------------------------------------------------------
// Generation of the DelSTxRxBSY signal. This signal when cleared indicates
// that the SSPRXD line should be checked for tri-state. 
// This signal is set one SCLK phase time after the end of a frame of data. This
// is because the SSPRXD from the SSP goes tri-state one SCLK phase time after
// the end of the frame.
// This signal is cleared a few SSPCLKs after the start of a frame to account
// for synchronisation delays.
// -----------------------------------------------------------------------------
always @(STxRxBSY)
begin : GenDelSTxRxBSY
  if (STxRxBSY == 1'b1)
    begin
      #(SCLKREFVALUE - `OFFSET);
      DelSTxRxBSY = STxRxBSY;
    end
  else if (STxRxBSY == 1'b0)
    begin
      #(SYNCOFFSET + `OFFSET + SSPCLKPRD);
      DelSTxRxBSY = STxRxBSY;
    end
end // GenDelTxRxBSY

// -----------------------------------------------------------------------------
// In the Slave mode, the SSPRXD from the SSP is expected to remain tri-stated
// when there is no data transfer in progress i.e. when SFRMIN to the SSP is
// high (inactive). The DelSFRMOUT2 signal has a waveform similar to SFRMOUT
// with slight corrections to account for synchronisation delays.
// -----------------------------------------------------------------------------
always @ (SFRMOUT)
begin : p_GDSFRMOUT2seq
  if (SFRMOUT == 1'b1)
    begin
     #(SYNCOFFSET + `OFFSET) DelSFRMOUT2 <= SFRMOUT;
    end
  else if (SFRMOUT == 1'b0)
    begin
      DelSFRMOUT2 <=  SFRMOUT;
    end
end // p_GDSFRMOUT2seq

// -----------------------------------------------------------------------------
// When the SSP slave is in the SPI mode, SSPRXD from the SSP is expected to 
// remain tri-stated when SFRM is negated.
// -----------------------------------------------------------------------------
always @(posedge DelSFRMOUT2)
begin : p_SpiHighZTest
  if (DelSFRMOUT2 == 1'b1)
    begin
      if ((MS == 1'b1) && (FRF == 2'b00) && (SSPRXD !== 1'bz) && 
         (SSESync == 1'b1))
        $display($time,"Error : SSPRXD is not  'z' at SFRM = 1 in SPI");
    end
end // p_SpiHighZTest

// -----------------------------------------------------------------------------
// When the SSP slave is in the SPI mode, SSPRXD from the SSP is expected to 
// remain tri-stated when there is no data transfer.
// -----------------------------------------------------------------------------
always @(SSPRXD)
begin : p_SpiHighZTest1
  if (DelSFRMOUT2 == 1'b1)
    begin
      if ((MS == 1'b1) && (FRF == 2'b00) && (SSPRXD !== 1'bz) && 
         (SSESync == 1'b1))
        $display($time,"Error : SSPRXD is not 'z' at SFRM = 1 in SPI");
    end
end // p_SpiHighZTest1

// -----------------------------------------------------------------------------
// The ModSSPOE signal is high for the duration of transmission of serial data
// by the Trickbox. This signal is used to check the tri-stating of the SSPRXD
// line in the NM mode.
// -----------------------------------------------------------------------------
always @(posedge SSPOE)
begin : p_GenModSSPOEseq
  if (SSPOE == 1'b1)
    begin
      ModSSPOE <= #((2 * SCLKREFVALUE) + SYNCOFFSET + `OFFSET) 1'b1;
      ModSSPOE <= #((15 * SCLKREFVALUE) - `OFFSET) 1'b0;
    end
end // p_GenModSSPOEseq

// -----------------------------------------------------------------------------
// When the SSP slave is in the NM mode, the SSPRXD from the SSP is expected
// to remain tr-stated when SFRM is inactive and during the transmit duration
// of the control word from the Trickbox.
// -----------------------------------------------------------------------------
always @(SSPRXD or ModSSPOE or DelSFRMOUT2)
begin :p_NMWHighZTest
  if ((MS == 1'b1) && (FRF == 2'b10) && (SSESync == 1'b1))
    begin
      if ((DelSFRMOUT2 == 1'b1) || (ModSSPOE == 1'b1))
         begin
           if (SSPRXD !== 1'bz)
             $display($time, "Error : SSPRXD is not  'z' this point in NM");
         end
    end
end // p_NMHighZTest

// -----------------------------------------------------------------------------
// Verify that the SSPRXD line from the SSP slave is tristated when 
//   - the SOD bit in the SSP is set
//   - the SSP is disabled
// In both these cases, the OD bit in the Trickbox is set to enable the check on
// the SSPRXD line.
// -----------------------------------------------------------------------------
always @(SSPRXD or MS or OD)
begin : p_SodTestComb
  if ((MS == 1'b1) && (OD == 1'b1) && (SSPRXD !== 1'bz))
    $display($time, "Error : SSPRXD is not 'Z' for OD = 1");
end // p_SodTestComb

// -----------------------------------------------------------------------------
// The DelSFRMOUT signal is asserted for a period during which the SSPRXD line
// from the SSP slave is expected to remain stable.
// -----------------------------------------------------------------------------
always @(SFRMOUT or negedge SSESync)
begin : p_DelSFRMOUTComb
  if (SFRMOUT == 1'b1)
    begin
      DelSFRMOUT <= #((2 * SCLKREFVALUE) + (SYNCOFFSET + `OFFSET)) SSESync;
    end
  else if (SFRMOUT == 1'b0)
    begin
      DelSFRMOUT <= #((2 * SCLKREFVALUE) - `OFFSET) 1'b0;
    end
end // p_DelSFRMOUTComb

// -----------------------------------------------------------------------------
// Monitor the SSPRXD line from the SSP slave to verify that it does not
// change when SFRM is high in the TI mode. Specifically, in the Extended
// SFRM mode, the SSP is expected to retain the first bit of transmit data on 
// the serial line till the first falling edge of SCLK after SFRM has gone low.
// -----------------------------------------------------------------------------
always @(SSPRXD)
begin : p_ESFRMComb
  if ((FRF == 2'b01) & (DelSFRMOUT == 1'b1) & (MS == 1'b1))
    $display($time, "Error : SSPRXD changed when SFRM high in TI mode");
end // p_ESFRMComb

// -----------------------------------------------------------------------------
// When the SSP is in the Master mode and is disabled, monitor the SCLK and 
// SFRM outputs to verify that they are at the default values. The OD bit in
// the trickbox is set to enable this check.
// -----------------------------------------------------------------------------
always @(SCLK or SFRM or FRF or OD or MS)
begin : p_MDTestComb
  if ((MS == 1'b0) & (OD == 1'b1))
    begin
      if ((FRF == 2'b00) & ((SCLK != SPO) | (SFRM != 1'b1)))
        $display($time, "Error : SCLK/SFRM not at default value when SSP disabled");
      else if ((FRF == 2'b10) & ((SCLK != 1'b0) | (SFRM != 1'b1)))
        $display($time, "Error : SCLK/SFRM not at default value when SSP disabled");
      else if ((FRF == 2'b01) & ((SCLK != 1'b0) | (SFRM != 1'b0)))
        $display($time, "Error : SCLK/SFRM not at default value when SSP disabled");
     end
end // p_MDTestComb

// -----------------------------------------------------------------------------
// The SSPCLKPRD2 signal holds the value corresponding to 2 periods of the
// SSPCLK on which the SSP operates.
// -----------------------------------------------------------------------------
always @(SSPTBCLKREG or SSPTBCLKREG1 or GENCLK1)
begin : p_SSPCLKPRD2Comb
  if (GENCLK1 == 1'b0)
    SSPCLKPRD2  <= SSPTBCLKREG * 2;
  else if (GENCLK1 == 1'b1)
    SSPCLKPRD2   = SSPTBCLKREG1 * 2;
end // p_SSPCLKPRD2Comb

// -----------------------------------------------------------------------------
// Ensure that the MS bit is seen at the same time or after it is seen by the
// SSP.
// -----------------------------------------------------------------------------
always @(MS)
begin : p_GenMSSync
  if (MS == 1'b1)
    MSSync <= # SSPCLKPRD2 1'b1;
  else if (MS == 1'b0)
    MSSync <= 1'b0;
end // p_GenMSSync
   
// -----------------------------------------------------------------------------
// Monitor the SCLKOUT and SFRMOUT signals from the SSP to verify that these
// are not driven by the SSP when in slave mode.
// -----------------------------------------------------------------------------
always @(MSSync or SCLK or SFRM)
begin : p_GenSTestComb
  if ((MSSync == 1'b1) & ((SCLK !== 1'bz) | (SFRM !==1'bz)))
     $display($time, "Error : SCLKOUT and SFRMOUT is not 'z' in slave mode");
end // p_GenSTestComb
endmodule

// --============================= End =======================================--
