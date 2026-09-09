//-----------------------------------------------------------------------------
//--
//--  project : JPROJECT
//--  design: ROM, SRAM, IO Control
//--  file:   sram_ctrl.v
//--  ver:    0.1
//--  copyright (c) 2001 Advanced Digital Chips Inc. (Han jeong-soo). all rights reserved.
//--
//-----------------------------------------------------------------------------

module sram_ctrl ( resetx, clk, sram, mesb_adr26_0, esb_bex, 
                   esb_rdx, esb_wrx, esb_burst, adr_setup, cs_setup, 
                   acc_cycle, cs_hold, adr_hold, use_bex, 
                   wait_enable, dbus_width, adr_sft, burst_src, waitx, 
                   sram_csx, sram_adr, sram_bex, sram_wex, sram_rdx, 
                   sram_ibex, sram_latch, sram_rdyx, sram_wenx, sram_idle,
				   burst_end );

input         resetx; 
input         clk; 
input         sram;         // from register block
input  [26:0] mesb_adr26_0; // from register block
input  [ 3:0] esb_bex;      // from esb_top
input         esb_rdx;      // from esb_top
input         esb_wrx;      // from esb_top
input         esb_burst;    // from esb_top
input  [ 1:0] adr_setup;    // from register block
input  [ 1:0] cs_setup;     // from register block
input  [ 3:0] acc_cycle;    // from register block. 2 to 3. 2006.2.21
input  [ 1:0] cs_hold;      // from register block
input  [ 1:0] adr_hold;     // from register block
input         use_bex;      // from register block
input         wait_enable;  // from register block
input         dbus_width;   // from register block 8/16bit
input 	      adr_sft;      // address shift right by 1
input [ 6:0]  burst_src;    // from register block
input         waitx;        // from EXT

output        sram_csx;     // to register block
output [26:0] sram_adr;     // to output_control block
output [ 3:0] sram_bex;     // to output_control block 
output        sram_wex;     // to output_control block 
output        sram_rdx;     // to output_control block 
output [ 3:0] sram_ibex;    // to output_control block 
output        sram_latch;   // to output_control block 
output        sram_rdyx;    // to output_control block 
output        sram_wenx;    // to output_control block
output        sram_idle;
   output 	  burst_end;
   
//-----------------------------------------------------------------
supply1   vdd;

reg [ 8:0] cs, ns;
reg [ 4:0] wait_count;
reg [ 6:0] burst_cnt;
reg [26:0] fsm_adr;
reg [ 3:0] sram_rbex;
reg [ 3:0] sram_ibex;
reg [ 3:0] sram_bex;

parameter s0  = 9'b000000001;
parameter s1  = 9'b000000010;
parameter s2  = 9'b000000100;
parameter s3  = 9'b000001000;
parameter s4  = 9'b000010000;
parameter s5  = 9'b000100000;
parameter s6  = 9'b001000000;
parameter s7  = 9'b010000000;
parameter s8  = 9'b100000000;

wire mcs0  = cs[0];
wire mcs1  = cs[1];
wire mcs2  = cs[2];
wire mcs3  = cs[3];
wire mcs4  = cs[4];
wire mcs5  = cs[5];
wire mcs6  = cs[6];
wire mcs7  = cs[7];
wire mcs8  = cs[8];

//-----------------------------------------------------------------
wire reset           = ~resetx;
wire port_08bit      = ~dbus_width;
wire port_16bit      =  dbus_width;
wire port_32bit      =  1'b0;
wire adr_setup_0clk  = ~adr_setup[1]  & ~adr_setup[0];
wire cs_setup_0clk   = ~cs_setup[1]   & ~cs_setup[0];
wire acc_cycle_1clk  = ~acc_cycle[3]  & ~acc_cycle[2]  & ~acc_cycle[1]   & ~acc_cycle[0];
wire adr_hold_0clk   = ~adr_hold[1]   & ~adr_hold[0];
wire cs_hold_0clk    = ~cs_hold[1]    & ~cs_hold[0];
wire rd_or_wr        = ~esb_rdx       | ~esb_wrx;
wire wait_end        = ~(|wait_count);
wire burst_end       = ~(|burst_cnt);
wire go_state        =  sram & rd_or_wr;

wire state0_1        =  go_state      & ~adr_setup_0clk;
wire state0_2        =  go_state      &  adr_setup_0clk & ~cs_setup_0clk;
wire state0_3        =  go_state      &  adr_setup_0clk &  cs_setup_0clk  & ~acc_cycle_1clk;
wire state0_4        =  go_state      &  adr_setup_0clk &  cs_setup_0clk  &  acc_cycle_1clk &  wait_enable;
wire state0_7        =  go_state      &  adr_setup_0clk &  cs_setup_0clk  &  acc_cycle_1clk & ~wait_enable;
wire state1_2        =  wait_end      & ~cs_setup_0clk;
wire state1_3        =  wait_end      &  cs_setup_0clk  & ~acc_cycle_1clk;
wire state1_4        =  wait_end      &  cs_setup_0clk  &  acc_cycle_1clk &  wait_enable;
wire state1_7        =  wait_end      &  cs_setup_0clk  &  acc_cycle_1clk & ~wait_enable;
wire state2_3        =  wait_end      & ~acc_cycle_1clk;
wire state2_4        =  wait_end      &  acc_cycle_1clk &  wait_enable;
wire state2_7        =  wait_end      &  acc_cycle_1clk & ~wait_enable;
wire state3_4        =  wait_end      &  wait_enable;
wire state3_7        =  wait_end      & ~wait_enable;
wire state4_7        =  waitx;
wire state5_6        =  wait_end      & ~adr_hold_0clk;
wire state5_8        =  wait_end      &  adr_hold_0clk;
wire state6_8        =  wait_end;
wire state7_5        = ~cs_hold_0clk;
wire state7_6        =  cs_hold_0clk  & ~adr_hold_0clk;
wire state8_0        =  burst_end;
wire state8_1        = ~burst_end     & ~adr_setup_0clk;
wire state8_2        = ~burst_end     &  adr_setup_0clk & ~cs_setup_0clk;
wire state8_3        = ~burst_end     &  adr_setup_0clk &  cs_setup_0clk  & ~acc_cycle_1clk;
wire state8_4        = ~burst_end     &  adr_setup_0clk &  cs_setup_0clk  &  acc_cycle_1clk &  wait_enable;
wire state8_7        = ~burst_end     &  adr_setup_0clk &  cs_setup_0clk  &  acc_cycle_1clk & ~wait_enable;
//#################################################################
// state machine
//-----------------------------------------------------------------
always @(posedge reset or posedge clk)
  if (reset) cs <= s0;  
  else       cs <= ns;
  
always @(mcs0 or mcs1 or mcs2 or mcs3 or mcs4 or mcs5 or mcs6 or mcs7 or mcs8 or 
         state0_1 or state0_2 or state0_3 or state0_4 or state0_7 or state1_2 or 
         state1_3 or state1_4 or state1_7 or state2_3 or state2_4 or state2_7 or 
         state3_4 or state3_7 or state4_7 or state5_6 or state5_8 or state6_8 or 
         state7_5 or state7_6 or state8_0 or state8_1 or state8_2 or state8_3 or 
         state8_4 or state8_7) begin
  ns = s0;
  case (1'b1) //synopsys parallel_case
     mcs0    :  if      (state0_1)  ns = s1;
                else if (state0_2)  ns = s2;
                else if (state0_3)  ns = s3;
                else if (state0_4)  ns = s4;
                else if (state0_7)  ns = s7;
                else                ns = s0;
     mcs1    :  if      (state1_2)  ns = s2;
                else if (state1_3)  ns = s3;
                else if (state1_4)  ns = s4;
                else if (state1_7)  ns = s7;
                else                ns = s1;
     mcs2    :  if      (state2_3)  ns = s3;
                else if (state2_4)  ns = s4;
                else if (state2_7)  ns = s7;
                else                ns = s2;
     mcs3    :  if      (state3_4)  ns = s4;
                else if (state3_7)  ns = s7;
                else                ns = s3;
     mcs4    :  if      (state4_7)  ns = s7;
                else                ns = s4;
     mcs5    :  if      (state5_6)  ns = s6;
                else if (state5_8)  ns = s8;
                else                ns = s5;
     mcs6    :  if      (state6_8)  ns = s8;
                else                ns = s6;
     mcs7    :  if      (state7_5)  ns = s5;
                else if (state7_6)  ns = s6;
                else                ns = s8;
     mcs8    :  if      (state8_0)  ns = s0;
                else if (state8_1)  ns = s1;
                else if (state8_2)  ns = s2;
                else if (state8_3)  ns = s3;
                else if (state8_4)  ns = s4;
                else if (state8_7)  ns = s7;
                else                ns = s0;
     default :                      ns = s0;
  endcase
end

//assign sram_csx   = ~(mcs2 | mcs3 | mcs4  | mcs5 | mcs7);
//assign sram_wex   = ~(mcs3 | mcs4 | mcs7) | esb_wrx;
//assign sram_rdx   = ~(mcs3 | mcs4 | mcs7) | esb_rdx;
assign sram_wenx  =  esb_wrx | mcs0;
assign sram_latch = ~esb_rdx & mcs7;

wire pre_cs     = ns[2] | ns[3] | ns[4] | ns[5] | ns[7];
wire pre_access = ns[3] | ns[4] | ns[7];

reg  sram_csx;
reg  sram_wex;
reg  sram_rdx;

always @(posedge reset or posedge clk)
  if      (reset)  sram_csx <= 1'b1;
  else if (pre_cs) sram_csx <= 1'b0;
  else             sram_csx <= 1'b1;

always @(posedge reset or posedge clk)
  if      (reset)                 sram_wex <= 1'b1;
  else if (~esb_wrx & pre_access) sram_wex <= 1'b0;
  else                            sram_wex <= 1'b1;

always @(posedge reset or posedge clk)
  if      (reset)                 sram_rdx <= 1'b1;
  else if (~esb_rdx & pre_access) sram_rdx <= 1'b0;
  else                            sram_rdx <= 1'b1;
//-----------------------------------------------------------------
// wait count source generation
//-----------------------------------------------------------------
reg [1:0] adr_setup_wait;
reg [1:0] adr_hold_wait;
reg [1:0] cs_setup_wait;
reg [1:0] cs_hold_wait;
reg [4:0] acc_cycle_wait;

always @(adr_setup)
  case (adr_setup)  // synopsys parallel_case
    2'b10   : adr_setup_wait = 2'b01;
    2'b11   : adr_setup_wait = 2'b10;
    default : adr_setup_wait = 2'b00;
  endcase               
               
always @(adr_hold)
  case (adr_hold)  // synopsys parallel_case
    2'b10   : adr_hold_wait = 2'b01;
    2'b11   : adr_hold_wait = 2'b10;
    default : adr_hold_wait = 2'b00;
  endcase               
               
always @(cs_setup)
  case (cs_setup)  // synopsys parallel_case
    2'b10   : cs_setup_wait = 2'b01;
    2'b11   : cs_setup_wait = 2'b10;
    default : cs_setup_wait = 2'b00;
  endcase               
               
always @(cs_hold)
  case (cs_hold)  // synopsys parallel_case
    2'b10   : cs_hold_wait = 2'b01;
    2'b11   : cs_hold_wait = 2'b10;
    default : cs_hold_wait = 2'b00;
  endcase               

always @(acc_cycle)
  case (acc_cycle)  // synopsys parallel_case
    4'b0001 : acc_cycle_wait = 5'b00000;// 2 clock
    4'b0010 : acc_cycle_wait = 5'b00001;// 3 clock
    4'b0011 : acc_cycle_wait = 5'b00010;// 4 clock
    4'b0100 : acc_cycle_wait = 5'b00011;// 5 clock
    4'b0101 : acc_cycle_wait = 5'b00100;// 6 clock
    4'b0110 : acc_cycle_wait = 5'b00101;// 7 clock
    4'b0111 : acc_cycle_wait = 5'b00110;// 8 clock
    4'b1000 : acc_cycle_wait = 5'b00111;// 9 clock
    4'b1001 : acc_cycle_wait = 5'b01000;// 10clock
    4'b1010 : acc_cycle_wait = 5'b01001;// 11clock
    4'b1011 : acc_cycle_wait = 5'b01010;// 12clock
    4'b1100 : acc_cycle_wait = 5'b01011;// 13clock
    4'b1101 : acc_cycle_wait = 5'b01100;// 14clock
    4'b1110 : acc_cycle_wait = 5'b01101;// 15clock
    4'b1111 : acc_cycle_wait = 5'b01110;// 16clock
    default : acc_cycle_wait = 5'b00000;
  endcase               
//-----------------------------------------------------------------
// wait counter, burst counter generation
//-----------------------------------------------------------------
wire load_adr_setup  = ns[1] & ~cs[1];
wire load_cs_setup   = ns[2] & ~cs[2];
wire load_acc_cycle  = ns[3] & ~cs[3];
wire load_cs_hold    = ns[5] & ~cs[5];
wire load_adr_hold   = ns[6] & ~cs[6];
wire down_wait_count = mcs1 | mcs2 | mcs3 | mcs5 | mcs6;

/*
always @(posedge reset or posedge clk)
  if      (reset)           wait_count <= 4'b0000;
  else if (load_adr_setup)  wait_count <= {2'b0, adr_setup_wait};
  else if (load_cs_setup)   wait_count <= {2'b0, cs_setup_wait};
  else if (load_acc_cycle)  wait_count <=        acc_cycle_wait;
  else if (load_cs_hold)    wait_count <= {2'b0, cs_hold_wait};
  else if (load_adr_hold)   wait_count <= {2'b0, adr_hold_wait};
  else if (down_wait_count) wait_count <= wait_count - 1'b1;
*/
always @(posedge reset or posedge clk)
  if      (reset)           wait_count <= 5'b0000;
  else if (load_adr_setup)  wait_count <= {3'b0, adr_setup_wait};
  else if (load_cs_setup)   wait_count <= {3'b0, cs_setup_wait};
  else if (load_acc_cycle)  wait_count <=        acc_cycle_wait;
  else if (load_cs_hold)    wait_count <= {3'b0, cs_hold_wait};
  else if (load_adr_hold)   wait_count <= {3'b0, adr_hold_wait};
  else if (down_wait_count) wait_count <= wait_count - 1'b1;

always @(posedge reset or posedge clk)
  if      (reset)     burst_cnt <= 7'h00;
  else if (mcs0)      burst_cnt <= burst_src;
  else if (burst_end) burst_cnt <= burst_cnt;
  else if (mcs8)      burst_cnt <= burst_cnt - 1'b1;
   
//-----------------------------------------------------------------
wire inc01 = mcs8 & ~burst_end & port_08bit;
wire inc02 = mcs8 & ~burst_end & port_16bit;
wire inc04 = mcs8 & ~burst_end & port_32bit;
//-----------------------------------------------------------------
always @(posedge reset or posedge clk)
  if      (reset) fsm_adr <= 27'h0000000;
  else if (mcs0)  fsm_adr <= mesb_adr26_0;
  else if (inc01) fsm_adr <= fsm_adr + 1'b1;
  else if (inc02) fsm_adr <= fsm_adr + 2'b10;
  else if (inc04) fsm_adr <= fsm_adr + 3'b100;
//-----------------------------------------------------------------
wire fsm_adr1 =  fsm_adr[1];
wire fsm_adr0 =  fsm_adr[0];
wire m08bit   = ~mcs0 & port_08bit;
wire m08bit0  =  m08bit & ~fsm_adr1 & ~fsm_adr0;
wire m08bit1  =  m08bit & ~fsm_adr1 &  fsm_adr0;
wire m08bit2  =  m08bit &  fsm_adr1 & ~fsm_adr0;
wire m08bit3  =  m08bit &  fsm_adr1 &  fsm_adr0;
wire m16bit0  = ~mcs0 & port_16bit & ~fsm_adr1;
wire m16bit1  = ~mcs0 & port_16bit &  fsm_adr1;
wire m32bit0  = ~mcs0 & port_32bit;
wire [3:0] temp_bex  = {m08bit, m16bit0, m16bit1, m32bit0};
wire [6:0] temp_ibex = {m08bit0, m08bit1, m08bit2, m08bit3, m16bit0, m16bit1, m32bit0};

   // byte enable is not used to address
always @(temp_bex or fsm_adr1 or fsm_adr0 or esb_bex)
  case (temp_bex)  // synopsys parallel_case
    4'b1000 : sram_rbex = {1'b1, 1'b1, 1'b1, 1'b0};
    4'b0100 : sram_rbex = {1'b1, 1'b1, esb_bex[1:0]};
    4'b0010 : sram_rbex = {1'b1, 1'b1, esb_bex[3:2]};
    4'b0001 : sram_rbex = esb_bex;
    default : sram_rbex = 4'b1111;
  endcase
/*
always @(temp_bex or fsm_adr1 or fsm_adr0 or esb_bex)
  case (temp_bex)  // synopsys parallel_case
    4'b1000 : sram_rbex = {1'b1, fsm_adr1, 1'b1, fsm_adr0};
    4'b0100 : sram_rbex = {1'b1, fsm_adr1, esb_bex[1:0]};
    4'b0010 : sram_rbex = {1'b1, fsm_adr1, esb_bex[3:2]};
    4'b0001 : sram_rbex = esb_bex;
    default : sram_rbex = 4'b1111;
  endcase
*/
always @(temp_ibex)
  case (temp_ibex) // synopsys parallel_case
    7'b1000000 : sram_ibex = 4'b1110;
    7'b0100000 : sram_ibex = 4'b1101;
    7'b0010000 : sram_ibex = 4'b1011;
    7'b0001000 : sram_ibex = 4'b0111;
    7'b0000100 : sram_ibex = 4'b1100;
    7'b0000010 : sram_ibex = 4'b0011;
    7'b0000001 : sram_ibex = 4'b0000;
    default    : sram_ibex = 4'b1111;
  endcase

//-----------------------------------------------------------------
// sram_rdyx, sram_wenx generation
//-----------------------------------------------------------------
wire bst_p32_rdy     =  esb_burst & port_32bit & mcs8;
wire bst_p16_rdy     =  esb_burst & port_16bit & mcs8 & ~burst_cnt[0];
wire bst_p08_rdy     =  esb_burst & port_08bit & mcs8 & ~burst_cnt[1] & ~burst_cnt[0];
wire nor_rdy         = ~esb_burst & burst_end  & mcs8;
wire when_sram8x2    = ~use_bex   & ~esb_wrx   & port_16bit;
wire when_sram8x4    = ~use_bex   & ~esb_wrx   & port_32bit;
wire [3:0] sram_wbex = {sram_wex | sram_rbex[3], sram_wex | sram_rbex[2], sram_wex | sram_rbex[1], sram_wex | sram_rbex[0]}; 

always @(when_sram8x2 or when_sram8x4 or sram_wbex or sram_rbex)
  if      (when_sram8x2) sram_bex = {sram_rbex[3:2], sram_wbex[1:0]};
  else if (when_sram8x4) sram_bex = sram_wbex;
  else                   sram_bex = sram_rbex;

   // added function for SDI V5. 2006.2.23
assign sram_adr  =  (adr_sft)? {1'b0,fsm_adr[26:1]} : fsm_adr[26:0];
   
assign sram_rdyx = ~(bst_p32_rdy | bst_p16_rdy | bst_p08_rdy | nor_rdy);
assign sram_idle =  mcs0;
//-----------------------------------------------------------------
endmodule

