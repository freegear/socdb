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
// Version and Release Control Information:
//
// File Name              : buswatch.v.rca
// File Revision          : 1.1
//
// Release Information    : PrimeCell(TM)-GLOBAL-REL1v6
//
// ---------------------------------------------------------------------
// Purpose : Buswatcher for AMBA signals. This is a simulation tool,
//           it has no hardware function.
//
// --=================================================================--
`timescale 1ns/1ps

module buswatch (
// Inputs
        BA,
        BCLK,
        BD,
        BERROR,
        BLAST,
        BLOK,
        BPROT,
        BnRES,
        BSIZE,
        BTRAN,
        BWAIT,
        BWRITE
        );

// input and output decalrations
input  [31:0]   BA;            // System Address Bus
input           BCLK;          // Master Bus Clock
input  [31:0]   BD;            // Bidirectional system Data Bus
input           BERROR;        // Xfer error resopnse
input           BLAST;         // Last xfer of burst response
input           BLOK;          // Locked xfer control signal
input   [1:0]   BPROT;         // Bus access protection control
input           BnRES;         // Bus reset status lines
input   [1:0]   BSIZE;         // Xfer size (byte, halfword, word)
input   [1:0]   BTRAN;         // Transfer type (Addr, Nseq, Seq)
input           BWAIT;         // Xfer wait response
input           BWRITE;        // Xfer Direction (R/W) control

`include "../common/Defs.v"

//----------------------------------------------------------------------
// Constant declarations
//----------------------------------------------------------------------
// Set to '1' to use the decode states version, and '0' for the mindec 
// version as in the Decoder

 `define BUS_DEC_EN  1'b1

  parameter tsu_ba_bclk = 0;    // BA setup to BCLK falling
  parameter tsu_btran_bclk = 0; // BTRAN setup to BCLK falling
  parameter tsu_slv_bclk = 0;   // Slave response setup to BCLK rising
  parameter tsu_b_d = 0;        // BD setup to BCLK falling

  parameter FALLING = 1'b0;
  parameter RISING  = 1'b1;
  parameter TRUE = 1'b1;
  parameter FALSE = 1'b0;
  parameter error = 1'b0;
  parameter warning = 1'b1;

// When set to TRUE input checking is only perfomed when BnRES is HIGH
// When set to FALSE, input checking in performed continuously
  parameter SUPPRESS_ON_RESET = TRUE;

//----------------------------------------------------------------------
// Signal declarations
//----------------------------------------------------------------------

reg         DecodeCycle;
wire [31:0] BA;
wire        BCLK;
wire [31:0] BD;
wire        BERROR;
wire        BLAST;
wire        BLOK;
wire  [1:0] BPROT;
wire        BnRES;
wire  [1:0] BSIZE;
wire  [1:0] BTRAN;
wire        BWAIT;
wire        BWRITE;

wire        InReset;
reg   [1:0] B_TRAND1;
reg   [1:0] BTRANLat;
reg         write;
reg         waited;
reg         atran;

// clock edge variables
event posedge_BCLK;  // positive edge BCLK event control
event negedge_BCLK;  // negative edge BCLK event control
reg   BD_event;      // true on change of Read  Data Bus value.
reg   BA_event;      // true on change of Address Bus Value.
reg   BERROR_event;  // true on change of BERROR value
reg   BLAST_event;   // true on change of BLAST value
reg   BPROT_event;   // true on change of BPROT value
reg   BSIZE_event;   // true on change of BSIZE value
reg   BTRAN0_event;  // true on change of BTRAN value
reg   BTRAN1_event;  // true on change of BTRAN value
reg   BWAIT_event;   // true on change of BWAIT value
reg   BWRITE_event;  // true on change of BWRITE value

reg   posedge_BCLKa; // Pos edge BCLK flag used in Check_BD 
reg   posedge_BCLKb; // copy of above used in slave_response_check  
reg   posedge_BCLKc; // copy of above used in Check_BTRAN

reg   negedge_BCLKa; // Neg edge BCLK flag used in Check_BA
reg   negedge_BCLKb; // copy of above used in Check_BD 
reg   negedge_BCLKc; // copy of above used in slave_response_check
reg   negedge_BCLKd; // copy of above used in Check_BWRITE
reg   negedge_BCLKe; // copy of above used in Check_BSIZE
reg   negedge_BCLKf; // copy of above used in Check_BPROT
reg   negedge_BCLKg; // copy of above used in Check_BTRAN

// time variables

time BA_prev_event;     // time of previous BA event
time BA_event_time;     // time of current BA event
time BD_prev_event;     // time of previous BD event
time BD_event_time;     // time of current BD event
time BERROR_prev_event; // time of previous BERROR event
time BERROR_event_time; // time of current BERROR event
time BLAST_prev_event;  // time of previous BLAST event
time BLAST_event_time;  // time of current BLAST event
time BWAIT_prev_event;  // time of previous BWAIT event
time BWAIT_event_time;  // time of current BWAIT event
time BWRITE_prev_event; // time of previous BWRITE event
time BWRITE_event_time; // time of current BWRITE event
time BSIZE_prev_event;  // time of previous BSIZE event
time BSIZE_event_time;  // time of current BSIZE event
time BPROT_prev_event;  // time of previous BPROT event
time BPROT_event_time;  // time of current BPROT event
time BTRAN0_prev_event; // time of previous BTRAN event
time BTRAN1_prev_event; // time of previous BTRAN event
time BTRAN0_event_time; // time of current BTRAN event
time BTRAN1_event_time; // time of current BTRAN event

//----------------------------------------------------------------------
// Internal functions
//----------------------------------------------------------------------

function Is_stable;

input	base_time;
input	new_time;
input	test_time;

begin
  assign Is_stable = ((new_time - base_time) >= test_time);
end

endfunction  //Is_stable


function Is_X_bus32;
input  [31:0]	sig;

integer i;
reg     j;

begin
  j = 0;
  for (i = 0; i <= 31; i = i + 1)
    j = j || (sig[i] === 1'bX);
  Is_X_bus32 = j;
end

endfunction 
	
function Is_Z_bus32;
input   [31:0]  sig;

integer i;
reg     j;

begin
  j = 1;
  for (i = 0; i <= 31; i = i + 1)
    j = j && (sig[i] === 1'bZ);

  Is_Z_bus32 = j;

end

endfunction 

//----------------------------------------------------------------------
// Internal tasks
//----------------------------------------------------------------------

task capture_event_time;
output	base_time;
inout	new_time;

begin
  base_time = new_time;
  new_time = $realtime;
end

endtask  //capture_event_time

task errhandler;
input [60*8:1]	message;
input           STRENGTH;

begin
  while (message[60*8:59*8] == 8'H00)
    message = message << 8;

  case(STRENGTH)
    warning:
      begin
        $display("WARNING: (time: %t) %s",$time,message);
      end

    error:
      begin
        $display("ERROR: (time: %t) %s",$time,message);
`ifdef assertion_error
        $stop(1);                          
`endif
      end

    default:  //should never do this!!
      begin
        $display("FAILURE: (time: %t) Unknown Error-- %s",$time,
                                                              message);
`ifdef assertion_error
        $finish(2);
`endif
      end
   endcase
end

endtask  //errhandler


//----------------------------------------------------------------------
// Beginning of main code
//----------------------------------------------------------------------
initial
begin
  if (`BUS_DEC_EN == 1'd1)
    errhandler("*** Buswatcher set to use Decode Cycles ***", warning);
  else
    errhandler("*** Buswatcher set NOT to use Decode Cycles ***", 
                                                               warning);
end

// Used to disable input checking during reset - masked by 
// SUPPRESS_ON_RESET
assign InReset = (BnRES == 1'd0);

always @(BTRANLat)
begin
  if ((`BUS_DEC_EN == 1'd1) && (BTRANLat == TRAN_NTRAN))
    DecodeCycle = 1'b1;
  else
    DecodeCycle = 1'b0;
end

//----------------------------------------------------------------------
//  BTRAN Latch
//----------------------------------------------------------------------
// Used in DecodeCycle generation to maintain value when BTRAN is Z
always @(BCLK or BnRES or BTRAN)
begin
  if (!BnRES)
    BTRANLat = 2'b00;
  else if (BCLK)
    BTRANLat = BTRAN;
end

//----------------------------------------------------------------------
// BA Checking
//----------------------------------------------------------------------
// Checks validity and stability of BA

always @(BA)
begin
  capture_event_time(BA_prev_event, BA_event_time);
  BA_event <= TRUE;
end	
   
always @(negedge_BCLK or BWAIT_event or BA_event or BTRAN0_event
         or BTRAN1_event)
begin: Check_BA
  if((! InReset) || (! SUPPRESS_ON_RESET))
    begin

      if(Is_X_bus32(BA) && negedge_BCLKa && (BTRAN != TRAN_ATRAN))
        errhandler("BA unknown", error);

      if(negedge_BCLKa
         && !(Is_stable(BA_prev_event, BA_event_time, tsu_ba_bclk)))
        errhandler("BA setup to BCLK falling violated", error);

      if((! BCLK ) &&  BA_event && (B_TRAND1 != TRAN_ATRAN))
        errhandler("BA changing during BCLK low", error);
    end

    BA_event <= FALSE;
    negedge_BCLKa <= FALSE;

end


//----------------------------------------------------------------------
// BCLK Checking
//----------------------------------------------------------------------
// Checks that the system clock is always valid

always @(BCLK)
begin: Check_BClk
  if (BCLK === 1'bX)
    errhandler("BCLK unknown", error);
end

always @(posedge BCLK)
begin
  posedge_BCLKa = TRUE;
  posedge_BCLKb = TRUE;
  posedge_BCLKc = TRUE;
  -> posedge_BCLK;
end

always @(negedge BCLK)
begin
  negedge_BCLKa = TRUE;
  negedge_BCLKb = TRUE;
  negedge_BCLKc = TRUE;
  negedge_BCLKd = TRUE;
  negedge_BCLKe = TRUE;
  negedge_BCLKf = TRUE;
  negedge_BCLKg = TRUE;
  -> negedge_BCLK;
end


//----------------------------------------------------------------------
// BD Checking
//----------------------------------------------------------------------
// Checks valididity and stability of BD during read and write transfers

always @(BD)
begin
  capture_event_time(BD_prev_event, BD_event_time);
  BD_event <= TRUE;
end


always @(posedge_BCLK or negedge_BCLK)
begin: Check_BD
  write  <= write;
  waited <= waited;
  atran  <= atran;

  if (posedge_BCLKa)		// done on rising edge of BClk
  begin
    write  <= BWRITE;
    waited <= BWAIT;
  end

  if ((negedge_BCLKb) && (! waited))    // done on falling edge of BCLK
    atran <= (BTRAN == TRAN_ATRAN);

  if (negedge_BCLKb)		        // done on falling edge of BCLK
    begin
      if (write && (! atran))		// Write operation
        begin
          if (Is_X_bus32(BD))
            errhandler
             ("BD unknown on falling BCLK during write operation", 
                                                                 error);
        
          if (! (Is_stable(BD_prev_event, BD_event_time, tsu_b_d)))
            errhandler ({"BD setup to BCLK falling violated",
                          "during write operation"},error);
	end

      else if ((! write) && (! atran) && (! waited))
        begin
          if (Is_X_bus32(BD))
            errhandler ({"BD unknown on falling BCLK during",
                         "read operation"}, error);
        
          if (! (Is_stable(BD_prev_event, BD_event_time, tsu_b_d)))
            errhandler ({"BD setup to BCLK falling violated ",
                         "during read operation"},error);
       
        end  //else if
    end  //if !BCLK

  posedge_BCLKa <= FALSE;
  negedge_BCLKb <= FALSE;
  BD_event  <= FALSE;

end  //always
  

//----------------------------------------------------------------------
// BWAIT, BERROR, BLAST checking
//----------------------------------------------------------------------
// Checks validity and stability of the three slave response signals

always @(BWAIT)
begin
  capture_event_time(BWAIT_prev_event, BWAIT_event_time);
  BWAIT_event <= TRUE;
end


always @(BERROR)
begin
  capture_event_time(BERROR_prev_event, BERROR_event_time);
  BERROR_event <= TRUE;
end


always @(BLAST)
begin
  capture_event_time(BLAST_prev_event, BLAST_event_time);
  BLAST_event <= TRUE;
end


always @(posedge_BCLK or negedge_BCLK or BERROR_event or BLAST_event
         or BWAIT_event)
begin: slave_response_check
  if(posedge_BCLKb)
    begin
      if ((! InReset) || (! SUPPRESS_ON_RESET))
        begin
          if (BERROR === 1'bX)
            errhandler("BERROR unknown on rising BCLK", error);

          if (!(Is_stable(BERROR_prev_event, BERROR_event_time, 
                                                        tsu_slv_bclk)))
            errhandler("BERROR setup to BCLK rising violated", error);

          if(BLAST === 1'bX)
            errhandler("BLAST unknown on rising BCLK", error);

          if(!(Is_stable(BLAST_prev_event, BLAST_event_time, 
                                                        tsu_slv_bclk)))
            errhandler("BLAST setup to BCLK rising violated", error);
        end // if

      if (BWAIT === 1'bX)
        errhandler("BWAIT unknown on rising BCLK", error);

      if (!(Is_stable(BWAIT_prev_event, BWAIT_event_time, 
                                                        tsu_slv_bclk)))
        errhandler("BWAIT setup to BCLK rising violated", error);

    end // if

  if ((BCLK && BERROR_event) || negedge_BCLKc)
    begin
      if (! (BERROR === 1'bZ))
        errhandler("BERROR driven during BCLK high", error);
    end // if

  if ((BCLK && BLAST_event) || negedge_BCLKc)
    begin
      if (! (BLAST === 1'bZ))
        errhandler("BLAST driven during BCLK high", error);
    end  // if;

  if ((BCLK && BWAIT_event) || negedge_BCLKc)
    begin
      if (! (BWAIT === 1'bZ))
        errhandler("BWAIT driven during BCLK high", error);
    end // if

  negedge_BCLKc <= FALSE;
  posedge_BCLKb <= FALSE;
  BWAIT_event   <= FALSE;
  BERROR_event  <= FALSE;
  BLAST_event   <= FALSE;

end //always block


//----------------------------------------------------------------------
// BWRITE checking
//----------------------------------------------------------------------
// Checks validity and stability of BWRITE

always @(BWRITE)
begin
  capture_event_time(BWRITE_prev_event, BWRITE_event_time);
  BWRITE_event   <= TRUE;
end


always @(negedge_BCLK or BWAIT_event or BTRAN0_event or BTRAN1_event
         or BWRITE_event)
begin: Check_BWRITE
  if((! InReset) || (!SUPPRESS_ON_RESET))
    begin
      if ((BWRITE === 1'bX) && (negedge_BCLKd) && (BTRAN != TRAN_ATRAN))
        errhandler("BWRITE unknown", error);

      if ((negedge_BCLKd)
          && !(Is_stable(BWRITE_prev_event, BWRITE_event_time, 
                                                        tsu_ba_bclk)))
        errhandler("BWRITE setup to BCLK falling violated", error);

      if((! BCLK) && BWRITE_event && (B_TRAND1 != TRAN_ATRAN))
        errhandler("BWRITE changing during BCLK low", error);
    end

  negedge_BCLKd <= FALSE;
  BWRITE_event  <= FALSE;

end // always block


//----------------------------------------------------------------------
// BSIZE checking
//----------------------------------------------------------------------
// Checks validity and stability of BSIZE
// Uses DecodeCycle to disable BSIZE checking

always @(BSIZE)
begin
  capture_event_time(BSIZE_prev_event, BSIZE_event_time);
  BSIZE_event   <= TRUE;
end

always @(negedge_BCLK or BWAIT_event or BTRAN0_event or BTRAN1_event
         or BSIZE_event)
begin: Check_BSIZE
  if((! InReset) || (!SUPPRESS_ON_RESET))
    begin
      if (((BSIZE[0] === 1'bX) || (BSIZE[1] === 1'bX)) &&
          (negedge_BCLKe) && (BTRAN != TRAN_ATRAN) && ~DecodeCycle)
        errhandler("BSIZE unknown", error);

      if ((negedge_BCLKe)
          && !(Is_stable(BSIZE_prev_event, BSIZE_event_time, 
                                                        tsu_ba_bclk)))
        errhandler("BSIZE setup to BCLK falling violated", error);

      if((! BCLK) && BSIZE_event && (B_TRAND1 != TRAN_ATRAN) && 
                                                        ~DecodeCycle)
        errhandler("BSIZE changing during BCLK low", error);

    end

  negedge_BCLKe <= FALSE;
  BSIZE_event  <= FALSE;

end // always block


//----------------------------------------------------------------------
// BPROT checking
//----------------------------------------------------------------------
// Checks validity and stability of BPROT
// Uses DecodeCycle to disable BPROT checking

always @(BPROT)
begin
  capture_event_time(BPROT_prev_event, BPROT_event_time);
  BPROT_event  <= TRUE;
end


always @(negedge_BCLK or BWAIT_event or BTRAN0_event or BTRAN1_event
         or BPROT_event)
begin: Check_BPROT
  if((! InReset) || (!SUPPRESS_ON_RESET))
    begin
      if (((BPROT[0] === 1'bX) || (BPROT[1] === 1'bx)) &&
          (negedge_BCLKf) && (BTRAN != TRAN_ATRAN) && ~DecodeCycle)
        errhandler("BPROT unknown", error);

      if ((negedge_BCLKf)
          && !(Is_stable(BPROT_prev_event, BPROT_event_time, 
                                                        tsu_ba_bclk)))
        errhandler("BPROT setup to BCLK falling violated", error);

      if((! BCLK) && BPROT_event && (B_TRAND1 != TRAN_ATRAN) && 
                                                        ~DecodeCycle)
        errhandler("BPROT changing during BCLK low", error);
    end

  negedge_BCLKf <= FALSE;
  BPROT_event  <= FALSE;

end // always block

//----------------------------------------------------------------------
// BTRAN checking
//----------------------------------------------------------------------
// Checks validity and stability of both BTRAN signals

// For synthesised modules the output timing of BTRAN0 and BTRAN1 can be
//  different, so need separate processes to check each BTRAN line

always @(BTRAN[0])
begin
  capture_event_time(BTRAN0_prev_event, BTRAN0_event_time);
  BTRAN0_event  <= TRUE;
end


always @(posedge_BCLK or negedge_BCLK or BWAIT_event or BTRAN0_event)
begin: Check_BTRAN0
  if ((! InReset) || (! SUPPRESS_ON_RESET))
    begin
      if ((negedge_BCLKg) && (BTRAN[0] === 1'bX))
        errhandler("BTRAN[0] unknown on falling BCLK", error);

      if ((negedge_BCLKg)
         && !(Is_stable(BTRAN0_prev_event, BTRAN0_event_time, 
                                                      tsu_btran_bclk))) 
        errhandler("BTRAN[0] setup to BCLK falling violated", error);

      if ((((! BCLK) && BTRAN0_event) || posedge_BCLKc) && 
                                                    (BTRAN[0] !== 1'bZ))
        errhandler("BTRAN[0] driven during BCLK low", error);

    end  // if

  if (negedge_BCLKg)
    B_TRAND1[0] <= BTRAN[0];

  #1 negedge_BCLKg <= FALSE;
     posedge_BCLKc <= FALSE;
     BTRAN0_event   <= FALSE;

end //always block


always @(BTRAN[1])
begin
  capture_event_time(BTRAN1_prev_event, BTRAN1_event_time);
  BTRAN1_event  <= TRUE;
end


always @(posedge_BCLK or negedge_BCLK or BWAIT_event or BTRAN1_event)
begin: Check_BTRAN1
  if ((! InReset) || (! SUPPRESS_ON_RESET))
    begin
      if ((negedge_BCLKg) && (BTRAN[1] === 1'bX))
        errhandler("BTRAN[1] unknown on falling BCLK", error);

      if ((negedge_BCLKg)
         && !(Is_stable(BTRAN1_prev_event, BTRAN1_event_time, 
                                                      tsu_btran_bclk))) 
        errhandler("BTRAN[1] setup to BCLK falling violated", error);

      if ((((! BCLK) && BTRAN1_event) || posedge_BCLKc) && 
                                                    (BTRAN[1] !== 1'bZ))
        errhandler("BTRAN[1] driven during BCLK low", error);

    end  // if

  if (negedge_BCLKg)
    B_TRAND1[1] <= BTRAN[1];

  #1 negedge_BCLKg <= FALSE;
     posedge_BCLKc <= FALSE;
     BTRAN1_event   <= FALSE;

end //always block

//----------------------------------------------------------------------
// Initialization
//----------------------------------------------------------------------

initial
begin
  write  = FALSE;
  waited = FALSE;
  atran  = TRUE;

  BA_event_time     = $realtime;
  BD_event_time     = $realtime;
  BERROR_event_time = $realtime;
  BLAST_event_time  = $realtime;
  BWAIT_event_time  = $realtime;
  BWRITE_event_time = $realtime;
  BSIZE_event_time  = $realtime;
  BPROT_event_time  = $realtime;
  BTRAN0_event_time = $realtime;
  BTRAN1_event_time = $realtime;

  BA_event     = FALSE;
  BD_event     = FALSE;
  BERROR_event = FALSE;
  BLAST_event  = FALSE;
  BWAIT_event  = FALSE;
  BWRITE_event = FALSE;
  BSIZE_event  = FALSE;
  BPROT_event  = FALSE;
  BTRAN0_event = FALSE;
  BTRAN1_event = FALSE;

end
  
endmodule

// --============================== End ==============================--
