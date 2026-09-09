// --=================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from ARM Limited
//   (C) COPYRIGHT 2000 ARM Limited
//       ALL RIGHTS RESERVED
// The entire notice above must be reproduced on all authorised
// copies and copies may only be made to the extent permitted
// by a licensing agreement from ARM Limited.
//
// ---------------------------------------------------------------------
// Version  and  Release Control Information:
//
// File Name              : buswatch.v.rca
// File Revision          : 1.1
//
// Release Information    : PrimeCell(TM)-GLOBAL-r8p0-00rel0
//
// ---------------------------------------------------------------------
// Purpose :
//           Protocol checker for AHB Slave
//
// --=================================================================--

`timescale 1ns/1ps

`include "../common/defs.v"
`include "../tbench/timing.v"

// ---------------------------------------------------------------------

module buswatch 
               (
                HRESETn,
                HCLK,
                HRDATA,
                DelHWRITE,
                HTRANS,
                HMASTER,
                HSPLIT,
                HREADY,
                HRESP 
               ); 
parameter 
  Verbosity       = 0,
  HaltOnMismatch  = 0,
  SuppressOnReset = 0; 

input        HRESETn;      
// Active low system reset 

input        HCLK ;
// The main bus clock

input [63:0] HRDATA;
// AHB Read Data 

input        DelHWRITE;  
// Delayed AHB Write

input  [1:0] HTRANS;
// AHB Transfer type signal 

input [3:0]  HMASTER;
// AHB Master 

input [15:0] HSPLIT;  
// AHB HSPLIT bus

input        HREADY;
// AHB Transfer done signal

input  [1:0] HRESP;
// AHB Response 

// ---------------------------------------------------------------------
//
//                               buswatch
//                               ========
//
// ---------------------------------------------------------------------
//
// Overview
// ========
//   This module implements the protocol checks for the AHB slave's
// output signals and will provide warnings and error messages if it
// finds some mismatch. It will continously check the signals for high
// impedance state  and  will check for unknown condition at the
// posedge of each clock.
// It ensures the slave's zero wait state OK  response for BUSY and
// IDLE cycle. HSPLITx lines are continously polled and if it is driven
// then it will ensure that it is driven only for one clock and that
// particular master has been given a split response before.
//
// ---------------------------------------------------------------------

// ---------------------------------------------------------------------
// Constant declaration 
// ---------------------------------------------------------------------
reg [159 : 0] msg_RespZ; 
// Error message : "HRESPZ: HRESP driven to Z" ;
reg [159 : 0] msg_ReadyZ;  
// Error message : "HREADYZ: HREADY driven to Z" ;
reg [159 : 0] msg_RdataZ;
// Error message : "HRDATAZ: HRDATA driven to Z" ;
reg [159 : 0] msg_HSplitZ;     
// Error message : "HSPLITZ: HSPLIT driven to Z" ;
 
reg [159 : 0] msg_RespXrclk;   
//Error message : HRESPXRCLK: HRESP unknown on rising HCLK";
reg [159 : 0] msg_ReadyXrclk;  
//Error message : "HREADYXRCLK: HREADY unknown on rising HCLK";
reg [159 : 0] msg_HSPXrclk;    
//Error message : "HSPXRCLK: HSPLIT unknown on rising HCLK";
reg [159 : 0] msg_HDreXrclk;   
// Error message : "HRDATAXR:HRDATA unknown on rising HCLK during last
// cycle of read operation";

// ---------------------------------------------------------------------
// Signal declarations
// ---------------------------------------------------------------------
integer    i;
// For loop variable

reg  [1:0] DelResponse;
// Delayed HRESP signal

wire       Tequal;
// Enables protocol checkings of HRESP and HREADY

wire       Tequaldr;
// Enables protocol checkings of HRDATA

reg        msg_Tovready;
// Notifier for HREADY valid checking

reg        msg_Tovresp;
// Notifier for HRESP valid checking

reg        msg_Tovdr;
// Notifier for HRDATA valid checking

reg        msg_Tovsplt;
// Notifier for HSPLIT valid checking

reg        msg_Tohready;
// Notifier for HREADY hold checking

reg        msg_Tohresp;
// Notifier for HREADY hold checking

reg        msg_Tohdr;
// Notifier for HRDATA hold checking
 
reg        msg_Tohsplt;
// Notifier for HSPLIT hold checking

reg        Write; 
// Denotes Write transfer

reg        Waited;             
// Wait for end of transfer 

reg        Resetover;          
// Reset cycle over

reg        Resetstrd;          
// Latch reset status;

reg        Startcheck;         
// Denotes HRESP =/ OK 

reg        DelHREADY;          
// Delayed HREADY signal

reg [15:0] SPLIT;        
// Storing SPLIT status

reg [1:0]  DelHTRANS;    
//  Delayed HTRANS

reg [1:0]  Expresponse;  
// Expected response

reg [1:0]  Delresponse;  
// Delayed response

reg [3:0]  DelMASTER;    
// Delayed HMASTER

reg [15:0] DelHSPLIT;    
// Delayed HSPLIT 


// ---------------------------------------------------------------------
//
// Main body of code
// =================
//
// ---------------------------------------------------------------------


initial
begin
  $timeformat(-9, 0, " ns", 13);
  Resetover <= 1'b0;
end

// -------------------------------------------------------------------
// Latching when first HRESETn is over
// Protocol checking enabled after first reset is over
// -------------------------------------------------------------------
// indicate the end of the first reset in the simulation
always @(posedge HCLK or HRESETn)
begin : p_resetstore
  if ((HCLK == 1'b1) & (HRESETn == 1'b0))
    Resetstrd = 1'b1;
  if ((Resetstrd == 1'b1) & (HRESETn == 1'b1))
    Resetover = 1'b1;
end // p_resetstore;

// ---------------------------------------------------------------------
//  HRESP and HREADY checking
//  Checks for timing parameters of HRESP  and  also whether it goes to
//  high impedance state or to unknown condition at positive edge of
//  HCLK.
// ---------------------------------------------------------------------
assign Tequal   = ((HRESETn| (SuppressOnReset == 1'b0)) & Resetover);
assign Tequaldr = (HRESETn | (SuppressOnReset == 1'b0) & (!DelHWRITE) & 
                                                             Resetover);

// ---------------------------------------------------------------------
always @ (posedge HCLK or  HRESETn)
begin : p_CheckHRESP 
  //  Check HRESP is valid at rising clock edge
  if ((HCLK == 1'b1)  & Resetover) 
    if ((HRESETn == 1'b1) ||  (SuppressOnReset == 1'b0))
    begin 
      if ((HRESP == 2'b00) === 1'bX)
      begin
        $display("%t:HRESPXR:Error : HRESP unknown on rising edge of ",
                 $time, "HCLK");
        if (HaltOnMismatch)
          $finish;
      end
      if (HREADY === 1'bX)
      begin
        $display("%t:HREADYX:Error : HREADY unknown on rising edge of",
                 $time, " HCLK");
      if (HaltOnMismatch)
          $finish;
      end
      if (((HRDATA == 64'h0000000000000000) === 1'bX) 
            && (DelHTRANS == 1'b1) && (DelHWRITE == 1'b0))
      begin 
        $display("%t:HRDATAXR: Error :HRDATA unknown on rising edge of",
                 $time, " HCLK");
        if (HaltOnMismatch)
          $finish;
      end
      if ((HSPLIT == 16'h0000) === 1'bX)
      begin 
        $display("%t:HSPLTXR: Error :HSPLIT unknown on rising edge of",
                 $time, " HCLK");
        if (HaltOnMismatch)
          $finish;
      end
    end
end  // p_CheckHRESP;

// ---------------------------------------------------------------------
// The following block does the timing checks on the
// master-output-signals.
// ---------------------------------------------------------------------
specify

  specparam  Tsetuprdy  = (`Tclk - `Tovrdy), Tholdrdy   = `Tohrdy,
             Tsetupresp = (`Tclk - `Tovrsp), Tholdresp  = `Tohrsp,
             Tsetupdr   = (`Tclk - `Tovdr),  TholdRd    = `Tohdr,
             Tsetupsplt = (`Tclk - `Tovsplt), TholdSplt = `Tohsplt; 

// Check response valid from rising clock edge
$setup ( HREADY, posedge HCLK &&& Tequal, Tsetuprdy, msg_Tovready);
$setup ( HRESP, posedge HCLK &&& Tequal, Tsetupresp, msg_Tovresp);
$setup ( HRDATA, posedge HCLK &&& Tequal, Tsetupdr, msg_Tovdr);
$setup ( HSPLIT, posedge HCLK &&& Tequal, Tsetupsplt, msg_Tovsplt);

// Check response valid from rising clock edge
$hold  ( posedge HCLK &&& Tequal, HREADY, Tholdrdy, msg_Tohready);
$hold  ( posedge HCLK &&& Tequal, HRESP, Tholdresp, msg_Tohresp);
$hold  ( posedge HCLK &&& Tequal, HRDATA, TholdRd, msg_Tohdr);
$hold  ( posedge HCLK &&& Tequal, HSPLIT, TholdSplt, msg_Tohsplt);

endspecify

always @(msg_Tovready)
  $display("Warning : Timing Violation: at time:%t:%s", $time,
  "(Tovready) HREADY valid after rising HCLK" );

always @(msg_Tovresp)
  $display("Warning : Timing Violation: at time:%t:%s", $time,
  "(Tovresp) HRESP valid after rising HCLK" );

always @(msg_Tovdr)
  $display("Warning : Timing Violation: at time:%t:%s", $time,
  "(Tovdr) HRDATA valid after rising HCLK" );

always @(msg_Tovsplt)
  $display("Warning : Timing Violation: at time:%t:%s", $time,
  "(Tovsplt) HSPLIT valid after rising HCLK" );

always @(msg_Tohready)
  $display("Warning : Timing Violation: at time:%t:%s", $time,
  "(Tohready) HREADY hold time after rising HCLK" );

always @(msg_Tohresp)
  $display("Warning : Timing Violation: at time:%t:%s", $time,
  "(Tohresp) HRESP hold time after rising HCLK" );

always @(msg_Tohdr)
  $display("Warning : Timing Violation: at time:%t: %s", $time,
  "(Tohdr) HRDATA hold time after rising HCLK" );

always @(msg_Tohsplt)
  $display("Warning : Timing Violation: at time:%t: %s", $time,
  "(Tohsplt) HSPLIT hold time after rising HCLK" );
 
// ---------------------------------------------------------------------
//  BUSY, IDLE Cycle Checking
//  Ensures a zero wait state OK response
// ---------------------------------------------------------------------
always @ (posedge HCLK)
begin : p_Chk0WSC 
  if ((HCLK == 1'b1) && Resetover && (HRESETn != 1'b0)) 
  begin
    if (HREADY == 1'b1) 
      DelHTRANS <= HTRANS;
    if (DelHTRANS[1] == 1'b0)
    begin 
      if (HREADY == 1'b0)
      begin 
        $display("%t:BUSWIB0WS: Error : HREADY not asserted in a BUSY ",
                 $time, "or IDLE transfer");
        if (HaltOnMismatch)
          $finish;
      end
      if (HRESP != 2'b00) 
      begin
        $display("%t:BUSWIBOK: Error: HRESP not driven to OK in a BUSY",
                 $time, " or IDLE transfer");
        if (HaltOnMismatch)
          $finish;
      end
      if (Verbosity)
        if (HREADY == 1'b1 & HRESP == 2'b00)
          $display("%t: HSIBC: Correct execution of IDLE or BUSY transfer",$time);
    end
  end
end  // p_Chk0WSC;

// ---------------------------------------------------------------------
//  SPLITx Checking
//  Splitstatus of masters stored  and  then checks whether only the
//  masters which have been split are only given HSPLITx  and  it
//  should be active for only one clock cycle. 
// ---------------------------------------------------------------------
always @ ( posedge HCLK or HREADY or HRESP or HMASTER or HSPLIT or  
           Resetover or DelMASTER)
begin : p_ChkSPLIT 
  if (HCLK == 1'b1   && Resetover)
  begin  
    DelHSPLIT  = HSPLIT;
    if (HREADY == 1'b1) 
      DelMASTER  = HMASTER;
    
    if (HSPLIT != 16'h0000  &&  HSPLIT != 16'hxxxx)
    begin 
      if (DelHSPLIT == HSPLIT)
      begin 
        $display("%t:BUSWSPSM: Error : Same HSPLIT lines driven", $time,
                 " consecutively");
        if (HaltOnMismatch)
          $finish;
      end
      for (i= 0; i < 16; i = i + 1)
      begin
        if (HSPLIT[i] != SPLIT[i]) 
        begin
          $display("%t: BUSWSPERR: Error : Master %d is not given ",
                   $time, i, "SPLIT, but it's HSPLIT is asserted");
          if (HaltOnMismatch)
            $finish;
        end
        else
        begin
          if (Verbosity)
            if (DelHSPLIT !== HSPLIT)
              $display("%t:BUSWSPC: Correct assertion of HSPLIT for ",
                       $time, "Master %d who got SPLIT",i);
        end
 
        if (HSPLIT[i] == 1'b1)  
          SPLIT[i] = 1'b0;
      end
    end
  end
  if ((HRESP == 2'b11)   && (HREADY == 1'b0)) 
    SPLIT[DelMASTER] = 1'b1;
end  // p_ChkSPLIT; 

// ---------------------------------------------------------------------
//  Response Checking
//  HRESP if it is not OK and HREADY is low, then in next cycle HRESP
//  should be same and HREADY HIGH.
//  HRESP if it is not OK and HREADY is HIGH, then in previous cycle
//  HRESP should be same and HREADY LOW. 
// ---------------------------------------------------------------------
always @ ( posedge HCLK or Resetover)
begin : p_CheckResponse 
  if ((HCLK == 1'b1)  && Resetover  &&  (HRESETn != 1'b0)) 
    begin 
      DelResponse <= HRESP;
      DelHREADY   <= HREADY;
    end
  if ((HRESP != 2'b00)  && (HREADY == 1'b0) && (Startcheck == 1'b0))
    begin 
      Startcheck  <= 1'b1;
      Expresponse <= HRESP;
    end
  else
    Startcheck <= 1'b0;
    
  if ((Startcheck == 1'b1)  && (HREADY == 1'b0))
  begin 
    $display("%t:BUSWHREADY2: Error : HREADY not asserted in second ",
             $time, "cycle of ERROR, RETRY or SPLIT response");
    if (HaltOnMismatch)
      $finish;
  end

  if ((Expresponse != HRESP)  && (Startcheck == 1'b1))
  begin 
    $display("%t: BUSWHRESP2: Error: HRESP changed in second cycle of ",
             $time, "ERROR, RETRY, or SPLIT response");
    if (HaltOnMismatch)
      $finish;
  end
        
  if ((HRESP != 2'b00)  && (HREADY == 1'b1))
  begin  
    if (Delresponse != HRESP) 
    begin 
      $display("%t: BUSWHRESP1: Error: HRESP not driven to ERROR, ",
               $time,
           "RETRY or SPLIT response in the previous cycle of transfer");
      if (HaltOnMismatch)
        $finish;
    end
    if (DelHREADY == 1'b1) 
    begin 
      $display("%t: BUSWHREADY1: HREADY not de-asserted in first cycle",
               $time,
               " of ERROR, RETRY or SPLIT response");
      if (HaltOnMismatch)
        $finish;
    end
  end
end  // p_CheckResponse;


endmodule 

// --============================= End ===============================--
