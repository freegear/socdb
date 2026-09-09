// --=========================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from ARM Limited
//   (C) COPYRIGHT 1999 ARM Limited
//       ALL RIGHTS RESERVED
// The entire notice above must be reproduced on all authorised
// copies and copies may only be made to the extent permitted
// by a licensing agreement from ARM Limited.
// 
// -----------------------------------------------------------------------------
// Version and Release Control Information:
// 
// File Name           : data_driver.v,v 
// File Revision       : 1.2 
// 
// Release Information : PL160-REL1v1 
// 
// -----------------------------------------------------------------------------
// Purpose             : PWDATA driver module
// --=========================================================================--
 
`timescale 1ns/1ps

module DATA_DRIVER (BCLK, DATA_SEL, APB_PACKET_SEL, APB_PACKET_WRITE,
                    APB_PACKET_ADDR, APB_PACKET_DATA, APB_PACKET_MASK,
                    APB_PACKET_EXP, APB_PACKET_LIMIT, APB_PACKET_NUM_CYC, APB_PACKET_TAG,
                    POSTATI, POSTATO, PENABLE, RDATA_BUS, WDATA_BUS);

   parameter
      Tclkh = 50,
      Tispdw = 5,
      Tihpdw = 2,
      Verbosity = 0,
      HaltOnMismatch = 0;
   
   
  `include "../common/defs.v"
 
  input BCLK;
  input [2:0] DATA_SEL;
  input APB_PACKET_SEL;
  input APB_PACKET_WRITE;
  input [31:0] APB_PACKET_ADDR;
  input [31:0] APB_PACKET_DATA;
  input [31:0] APB_PACKET_MASK;
  input [31:0] APB_PACKET_EXP;
  input [7:0] APB_PACKET_LIMIT;
  input [7:0] APB_PACKET_NUM_CYC;
  input [159:0] APB_PACKET_TAG;
  input POSTATI;
  output POSTATO;
  input PENABLE;
  input [31:0] RDATA_BUS;
  output [31:0] WDATA_BUS;
 
  reg [31:0] I_WDATA_BUS;
  assign WDATA_BUS = I_WDATA_BUS;
 
//  reg [31:0] I_R_DATA_0;   // due to timing problems, isn't used as in vhdl version
  reg [31:0] I_EXP_0;
  reg [31:0] I_MASK_0;
  reg [159:0] I_TAG_0;

  reg [31:0] count;
  reg [31:0] nextcount;
  reg countflag;
  reg d_sel;
  reg [31:0] limit;
  reg POSTATO;

  reg posedge_BCLK;     // Register set on posedge BCLK
  reg posedge_POSTATI;  // Register set on posedge POSTATI
  reg posedge_POSTATI2; // Register set on posedge POSTATI

  always @(posedge POSTATI)
  begin
    posedge_POSTATI  = 1'b1;
    posedge_POSTATI2 = 1'b1;
  end

  always @(posedge BCLK)
  begin
    posedge_BCLK = 1'b1;
  end


   // When the number of Polls becomes equal to the parameter "limit",
   // countflag become FALSE and Polling is stopped. Otherwise, polling
   // continues until countflag becomes FALSE or the required value is polled.

   // Counter for number of polls.
  always @(posedge_POSTATI or DATA_SEL)
   begin
        if (posedge_POSTATI)
        begin
          limit = APB_PACKET_LIMIT;
          count = 32'h00000000;
          if (!countflag)
            countflag = 1'b1;
        end
        else if ((POSTATI) && (DATA_SEL === `T_D_DRV_SEL_D_READ))
        begin
          count = nextcount;
          if (count == limit - 1)
            countflag = 1'b0;
        end
        posedge_POSTATI = 1'b0;
   end

   always @(DATA_SEL or posedge_BCLK or posedge_POSTATI2) 
     begin
      if (posedge_POSTATI2)
       nextcount = 32'h00000001;
      else if (posedge_BCLK && (DATA_SEL === `T_D_DRV_SEL_D_READ) && (POSTATI))
       nextcount = (count + 32'h00000001);
     posedge_POSTATI2 = 1'b0;
     posedge_BCLK = 1'b0;
     end

   
  always @(DATA_SEL)
  begin
    case (DATA_SEL)
      `T_D_DRV_SEL_D_RESET , `T_D_DRV_SEL_DR_HIZ: ;
      `T_D_DRV_SEL_D_IDLE : ;
      `T_D_DRV_SEL_DR_IDLE :
      begin
        I_MASK_0 = APB_PACKET_MASK;
        I_EXP_0 = APB_PACKET_EXP;
        I_TAG_0 = APB_PACKET_TAG;
      end
      `T_D_DRV_SEL_D_WRITE :
        I_WDATA_BUS <= #( Tclkh - Tispdw ) APB_PACKET_DATA;
      `T_D_DRV_SEL_D_READ :
      begin
//        I_R_DATA_0 <= RDATA_BUS;
      POSTATO = POSTATI;
        @(posedge BCLK)
          if (DATA_SEL === `T_D_DRV_SEL_D_READ && PENABLE)
            REPORTREAD(RDATA_BUS, I_MASK_0, I_EXP_0, I_TAG_0);
      end
      default  : ;
    endcase
 
  end

  task REPORTREAD;
 
    input [31:0] DATA;
    input [31:0] MASK;
    input [31:0] EXP;
    input [159:0] TAG;
  begin
    if (((MASK & DATA) !== (MASK & EXP)))
    begin
      $display("%t: PSRE: Error on data read. Expected: %h Actual: %h Mask: %h TAG: %0s", $time, EXP, DATA, MASK, TAG);

      if (HaltOnMismatch)
        $finish;
    end
    else if (Verbosity)
      $display("%t: PSRC: Correct read value of %h with mask %h, TAG: %0s", 
               $time, DATA, MASK, TAG);
  end
  endtask
 
  initial
  begin
 
//    I_R_DATA_0 = {1'd0, 1'd0, 1'd0, 1'd0, 1'd0, 1'd0, 1'd0, 1'd0, 1'd0, 1'd0,
//      1'd0, 1'd0, 1'd0, 1'd0, 1'd0, 1'd0, 1'd0, 1'd0, 1'd0, 1'd0, 1'd0, 1'd0,
//      1'd0, 1'd0, 1'd0, 1'd0, 1'd0, 1'd0, 1'd0, 1'd0, 1'd0, 1'd0};
    I_EXP_0 = {1'd0, 1'd0, 1'd0, 1'd0, 1'd0, 1'd0, 1'd0, 1'd0, 1'd0, 1'd0, 1'd0,
      1'd0, 1'd0, 1'd0, 1'd0, 1'd0, 1'd0, 1'd0, 1'd0, 1'd0, 1'd0, 1'd0, 1'd0,
      1'd0, 1'd0, 1'd0, 1'd0, 1'd0, 1'd0, 1'd0, 1'd0, 1'd0};
    I_MASK_0 = {1'd0, 1'd0, 1'd0, 1'd0, 1'd0, 1'd0, 1'd0, 1'd0, 1'd0, 1'd0, 1'd0
      , 1'd0, 1'd0, 1'd0, 1'd0, 1'd0, 1'd0, 1'd0, 1'd0, 1'd0, 1'd0, 1'd0, 1'd0,
      1'd0, 1'd0, 1'd0, 1'd0, 1'd0, 1'd0, 1'd0, 1'd0, 1'd0};
  end
 
endmodule

// --================================= End ===================================--
