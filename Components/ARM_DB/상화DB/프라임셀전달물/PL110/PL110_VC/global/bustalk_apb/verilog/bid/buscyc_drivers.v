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
// File Name              : buscyc_drivers.v.rca
// File Revision          : 1.1
//
// Release Information    : PrimeCell(TM)-GLOBAL-REL1v6
//
// ---------------------------------------------------------------------
// Purpose                : State generation for bus signals
//
// --=================================================================-
`timescale 1ns/1ps

module BUSCYC_DRIVERS (PCLK, PRESETn, CYC_SEL, APB_PACKET_SEL, 
                       APB_PACKET_WRITE, APB_PACKET_ADDR, 
                       APB_PACKET_DATA, APB_PACKET_MASK, APB_PACKET_EXP,
                       APB_PACKET_NUM_CYC, APB_PACKET_TAG, POSTATO, 
                       POSTATI, APB_GET_LINE, PADDR_SEL, PWDATA_SEL,
                       PSEL_SEL, PWRITE_SEL, PENABLE_SEL, CYC_COUNT);
   parameter
      Verbosity = 0;
   
  //   PADDR_sel and PWrite timing

  `include "../common/defs.v"
 
  input PCLK;
  input PRESETn;
  input [3:0] CYC_SEL;
  input APB_PACKET_SEL;
  input APB_PACKET_WRITE;
  input [31:0] APB_PACKET_ADDR;
  input [31:0] APB_PACKET_DATA;
  input [31:0] APB_PACKET_MASK;
  input [31:0] APB_PACKET_EXP;
  input [7:0] APB_PACKET_NUM_CYC;
  input [159:0] APB_PACKET_TAG;
  input POSTATO;
  input POSTATI;
  output APB_GET_LINE;
  output PADDR_SEL;
  output [2:0] PWDATA_SEL;
  output PSEL_SEL;
  output PWRITE_SEL;
  output [1:0] PENABLE_SEL;
  output [7:0] CYC_COUNT;
  wire [7:0] VAL;
  wire [7:0] LAST;
  wire [7:0] I_CYC_COUNT;
  wire A_STATE;  //   for PADDR, PWr
  wire [1:0] PHI;  // for generating t_state
  wire [1:0] T_STATE;  //       Penable
  wire S_STATE;  //       PSel
  wire [2:0] D_STATE;  //       PWDATA
  wire I_STATE;  //   special state for PI counting
  reg  SIMULATOR_START;
  //  Asynchronous reset signals to state machines
  wire GEN_STATE_RESET;
  wire I_STATE_SET;
  wire A_STATE_SET;
  wire S_STATE_SET;
 
  reg reg_S_STATE_SET;
  assign S_STATE_SET = reg_S_STATE_SET;
 
  reg reg_I_STATE_SET;
  assign I_STATE_SET = reg_I_STATE_SET;
 
  reg reg_A_STATE_SET;
  assign A_STATE_SET = reg_A_STATE_SET;
 
  reg [7:0] reg_VAL;
  assign VAL = reg_VAL;
 
  reg reg_I_STATE;
  assign I_STATE = reg_I_STATE;
 
  reg reg_A_STATE;
  assign A_STATE = reg_A_STATE;
 
  reg reg_S_STATE;
  assign S_STATE = reg_S_STATE;
 
  reg [2:0] reg_D_STATE;
  assign D_STATE = reg_D_STATE;
 
  reg reg_PHI_0;
  assign PHI[0] = reg_PHI_0;
 
  reg reg_PHI_1;
  assign PHI[1] = reg_PHI_1;
 
  reg [1:0] reg_T_STATE;
  assign T_STATE = reg_T_STATE;
 
  reg reg_APB_GET_LINE;
  assign APB_GET_LINE = reg_APB_GET_LINE;
 
  assign GEN_STATE_RESET = SIMULATOR_START | ~ PRESETn;

  reg negedge_POSTATO; // Register set on negedge POSTATO
 
  COUNTDOWN  U_COUNTDOWN
    (.PCLK(PCLK),
     .VAL(VAL),
     .LAST(LAST));

  initial
  begin
    SIMULATOR_START = 0;
    SIMULATOR_START = #0.1 1;
    SIMULATOR_START = #0.1 0;
  end

  //  State machine reset signal generators
  always @(CYC_SEL or A_STATE)
  begin
    case (CYC_SEL)
      `T_CYCLE_C_PI :
      begin
        reg_A_STATE_SET <= 1'b0;
        reg_I_STATE_SET <= 1'b1;
        reg_S_STATE_SET <= 1'b1;
      end
      `T_CYCLE_C_PSR,`T_CYCLE_C_PSW,`T_CYCLE_C_PNR,`T_CYCLE_C_PNW,
       `T_CYCLE_C_PO:
      begin
        if ((!A_STATE))
          reg_A_STATE_SET <= 1'b1;
 
        reg_I_STATE_SET <= 1'b0;
        reg_S_STATE_SET <= 1'b1;
      end
      `T_CYCLE_C_IDLE :
      begin
        reg_A_STATE_SET <= 1'b0;
        reg_I_STATE_SET <= 1'b0;
        reg_S_STATE_SET <= 1'b0;
      end
      default  :
      begin
        reg_A_STATE_SET <= 1'b0;
        reg_I_STATE_SET <= 1'b0;
        reg_S_STATE_SET <= 1'b1;
      end
    endcase
  end
 
  //  here the select lines are assigned according to their timing
  assign PADDR_SEL   = A_STATE;
  assign PWRITE_SEL  = A_STATE;
  assign PENABLE_SEL = T_STATE;
  assign PSEL_SEL    = S_STATE;
  assign PWDATA_SEL  = D_STATE;
  assign I_CYC_COUNT = (PCLK === 1'b0 ?(APB_PACKET_NUM_CYC - LAST + 1) :
                        I_CYC_COUNT);
  assign CYC_COUNT   = I_CYC_COUNT;

  //   Load num_cyc into counter
  always @(CYC_SEL or PCLK or POSTATO)
  begin
    if (CYC_SEL === `T_CYCLE_C_PSR || CYC_SEL  === `T_CYCLE_C_PSW  ||
        CYC_SEL === `T_CYCLE_C_PNR || CYC_SEL  === `T_CYCLE_C_PNW  ||
        CYC_SEL === `T_CYCLE_C_PO  || (CYC_SEL === `T_CYCLE_C_IDLE &&
        POSTATO === 1 && LAST === 1 && PCLK === 1))
      reg_VAL <= 2;
    else if (CYC_SEL === `T_CYCLE_C_IDLE && LAST === 1 && POSTATO === 0 
             && PCLK === 1)
      reg_VAL <= 1;
    else if (CYC_SEL === `T_CYCLE_C_PI && PCLK=== 1 )
      reg_VAL <= APB_PACKET_NUM_CYC;
    else
      reg_VAL <= 0;
  end
 
  //   PI idle cycle timing
  //   cannot use just a_state to determine when next apb packet
  //   is required  because the PI command does not drive an address.
  //   So a new signal i_state is added.
  //   Re-modelled as an asynchronously settable positive edge-triggered
  //   flip-flop
  always @(posedge (SIMULATOR_START) or posedge (I_STATE_SET) or 
           posedge (PCLK))
  begin
    if (SIMULATOR_START)
      reg_I_STATE <= `T_A_DRV_SEL_A_IDLE;
    else if ((I_STATE_SET))
      reg_I_STATE <= `T_A_DRV_SEL_A_ADDR;
    else
      if ((A_STATE) && (LAST === 1))
        reg_I_STATE <= `T_A_DRV_SEL_A_IDLE;
  end
 
  //   PADDR and PWrite timing
  always @( posedge (GEN_STATE_RESET) or posedge (A_STATE_SET) or 
            posedge (PCLK) or CYC_SEL or 
            posedge (A_STATE === `T_A_DRV_SEL_A_IDLE && POSTATI === 1))
  begin
    if (GEN_STATE_RESET)
      reg_A_STATE <= `T_A_DRV_SEL_A_IDLE;
    else if ((A_STATE_SET) || (POSTATI && CYC_SEL === `T_CYCLE_C_IDLE
             && !(A_STATE)))
      reg_A_STATE <= `T_A_DRV_SEL_A_ADDR;
    else if ((A_STATE) && (LAST === 1))
      reg_A_STATE <= `T_A_DRV_SEL_A_IDLE;
  end
 
  //   PSel timing
  always @( posedge (GEN_STATE_RESET) or posedge (S_STATE_SET) or 
            posedge (PCLK) or CYC_SEL or 
            posedge (S_STATE === `T_A_DRV_SEL_A_IDLE && POSTATI === 1))
  begin
    if (GEN_STATE_RESET)
      reg_S_STATE <= `T_A_DRV_SEL_A_IDLE;
    else if (S_STATE_SET || CYC_SEL === `T_CYCLE_C_PO ||
            (POSTATI && CYC_SEL === `T_CYCLE_C_IDLE && !(S_STATE)))
      reg_S_STATE <= `T_A_DRV_SEL_A_ADDR;
    else if ((S_STATE) && (LAST === 1))
      reg_S_STATE <= `T_A_DRV_SEL_A_IDLE;
  end
 
  //   PWDATA timing
  always @( posedge (GEN_STATE_RESET) or PRESETn or CYC_SEL or 
            posedge(PCLK) or LAST or 
            posedge (D_STATE === `T_D_DRV_SEL_D_IDLE && POSTATO === 1))
  begin
    if (GEN_STATE_RESET || !PRESETn)
      reg_D_STATE <= `T_D_DRV_SEL_D_RESET;
    else if ((PRESETn) && D_STATE === `T_D_DRV_SEL_D_RESET)
      reg_D_STATE <= `T_D_DRV_SEL_D_IDLE;
    else if ((D_STATE === `T_D_DRV_SEL_D_IDLE) && 
             (CYC_SEL === `T_CYCLE_C_PSR ||
              CYC_SEL === `T_CYCLE_C_PO  ||
              (POSTATO && CYC_SEL === `T_CYCLE_C_IDLE)))
      reg_D_STATE <= `T_D_DRV_SEL_DR_IDLE;
    else if ((D_STATE === `T_D_DRV_SEL_D_IDLE) &&
             (CYC_SEL === `T_CYCLE_C_PNR))
      reg_D_STATE <= `T_D_DRV_SEL_D_IDLE;
    else if ((D_STATE === `T_D_DRV_SEL_D_IDLE) && 
             (CYC_SEL === `T_CYCLE_C_PNW ||
              CYC_SEL === `T_CYCLE_C_PSW))
      reg_D_STATE <= `T_D_DRV_SEL_D_WRITE;
    else if ((D_STATE === `T_D_DRV_SEL_DR_IDLE) && (PCLK === 1))
      reg_D_STATE <= `T_D_DRV_SEL_D_READ;
    else if ((LAST === 1) && (PCLK === 1))
      reg_D_STATE <= `T_D_DRV_SEL_D_IDLE;
  end
 
  //  Bi-phase t_state signal built up from two flip-flops, one negative
  //  edge triggered the other positive edge triggered.  The default
  //  condition for both flip-flops is zero, causing t-state to remain 
  //  at value en_ph1.

  always @( negedge (PRESETn) or negedge (PCLK) )
  begin
    if ((!PRESETn))
      reg_PHI_0 <= 1'b0;
    else
      if ((CYC_SEL === `T_CYCLE_C_PNR || CYC_SEL === `T_CYCLE_C_PSR ||
           CYC_SEL === `T_CYCLE_C_PNW || CYC_SEL === `T_CYCLE_C_PSW ||
           CYC_SEL === `T_CYCLE_C_PO  || 
          (POSTATO && CYC_SEL === `T_CYCLE_C_IDLE)) && (!PHI[0]))
        reg_PHI_0 <= 1'b1;
      else
        reg_PHI_0 <= 1'b0;
  end
 
  always @( negedge (PRESETn) or posedge (PCLK) )
  begin
    if ((!PRESETn))
      reg_PHI_1 <= 1'b0;
    else
      reg_PHI_1 <= PHI[0];
  end
 
  always @(PHI)
  begin
    if (!PHI[0])
      if (!PHI[1])
        reg_T_STATE <= `T_E_DRV_SEL_EN_PH1;
      else
        reg_T_STATE <= `T_E_DRV_SEL_EN_PH4;
    else
      if (!PHI[1])
        reg_T_STATE <= `T_E_DRV_SEL_EN_PH2;
      else
        reg_T_STATE <= `T_E_DRV_SEL_EN_PH3;
  end
 
// Falling edge of POSTATO 
  always @(negedge POSTATO)
  begin
    negedge_POSTATO = 1'b1;
  end

// apb_get_line goes to g_get at the end of a Poll command execution or
// when  all the drivers are in idle state.
  always @(LAST or A_STATE or POSTATI or POSTATO or CYC_SEL or
           negedge_POSTATO)
  begin
    if ((LAST === 1) || ((!A_STATE) && (!I_STATE)))
      if (POSTATI !== 1 || negedge_POSTATO || POSTATO !== 1)
        reg_APB_GET_LINE <= `T_GET_G_GET;
      else // Need to end this 'if' before the next 'else'
        begin
        end
    else
      reg_APB_GET_LINE <= `T_GET_G_IDLE;
    negedge_POSTATO <= 1'b0;
  end
 
 //   The following process prints out the bus cycle information at the 
 //   time it starts, i.e. when address and control information are
 //   driven during the low PCLK phase of the previous cycle.
  always @(negedge PCLK)
  begin
    if ((CYC_SEL !== `T_CYCLE_C_IDLE) && Verbosity)
      REPORTP_CYCLE (CYC_SEL,
                     APB_PACKET_EXP,
                     APB_PACKET_MASK,
                     APB_PACKET_ADDR,
                     APB_PACKET_DATA,
                     APB_PACKET_TAG,
                     APB_PACKET_NUM_CYC);
  end
 
 
  task REPORTP_CYCLE;
 
    input [3:0] SEL;
    input [31:0] EXP;
    input [31:0] MASK;
    input [31:0] ADDR;
    input [31:0] DATA;
    input [159:0] TAG;
    input [7:0] NUM_CYC;
  begin
    if (Verbosity)
      case (SEL)
        `T_CYCLE_C_PNR :
         $display("%t: PNRI: Started PNR transfer at address %h, TAG:%0s ",
                  $time, ADDR, TAG) ;
        `T_CYCLE_C_PSR :
         begin
          $write("%t: PSRI: Started PSR of expected data %h with ",
                  $time, EXP);
          $display("mask %h from address %h, TAG:%0s", MASK, ADDR, TAG);
         end
        `T_CYCLE_C_PNW :
         $display("%t: PNWI: Started PNW with data %h at address %h, TAG: %0s",
                  $time, DATA, ADDR, TAG) ;
        `T_CYCLE_C_PSW :
         $display("%t: PSWI: Started PSW with data %h at address %h, TAG:%0s", 
         $time, DATA, ADDR, TAG) ;
        `T_CYCLE_C_PI :
         $display("%t: PII: Started PI for %d cycles, TAG:%0s", $time,
                   NUM_CYC, TAG);
        `T_CYCLE_C_PO :
         begin
          $write("%t: POI: Started PO of expected data %h with ", 
                  $time, EXP);
          $display("mask %h from address %h, TAG:%0s", MASK, ADDR, TAG);
         end
        default  : ;
      endcase
  end
  endtask

endmodule

// --================================= End ===========================--
