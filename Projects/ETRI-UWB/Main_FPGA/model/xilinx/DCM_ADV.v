// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/data/virtex4/DCM_ADV.v,v 1.10.4.14 2005/07/14 22:14:27 yanx Exp $
///////////////////////////////////////////////////////////////////////////////
// Copyright (c) 1995/2004 Xilinx, Inc.
// All Right Reserved.
///////////////////////////////////////////////////////////////////////////////
//   ____  ____
//  /   /\/   /
// /___/  \  /    Vendor : Xilinx
// \   \   \/     Version : 7.3i (H.42)
//  \   \         Description : Xilinx Functional Simulation Library Component
//  /   /                  Digital Clock Manager with Advanced Features
// /___/   /\     Filename : DCM_ADV.v
// \   \  /  \    Timestamp : Thu Mar 25 16:43:43 PST 2004
//  \___\/\___\
//
// Revision:
//    03/23/04 - Initial version.
//    04/27/05 - Change DRP set clkfx M/D value effected on RST=1, not rising
//               edge. (CR 206731)
//    05/11/05 - Add parameter DCM_AUTOCALIBRATION. (CR 208095)
//    07/05/05 - Use counter to generate clkdv_out to align with clk0_out. (CR211465).


`timescale  1 ps / 1 ps
`define CLKFX_MULTIPLY_ADDR 80
`define CLKFX_DIVIDE_ADDR  82
`define PHASE_SHIFT_ADDR 85
`define PHASE_SHIFT_KICK_OFF_ADDR 17
`define DCM_DEFAULT_STATUS_ADDR 0


module DCM_ADV (
        CLK0,
        CLK180,
        CLK270,
        CLK2X,
        CLK2X180,
        CLK90,
        CLKDV,
        CLKFX,
        CLKFX180,
        DO,
        DRDY,
        LOCKED,
        PSDONE,
        CLKFB,
        CLKIN,
        DADDR,
        DCLK,
        DEN,
        DI,
        DWE,
        PSCLK,
        PSEN,
        PSINCDEC,
        RST
);

parameter CLKDV_DIVIDE = 2.0;
parameter CLKFX_DIVIDE = 1;
parameter CLKFX_MULTIPLY = 4;
parameter CLKIN_DIVIDE_BY_2 = "FALSE";
parameter CLKIN_PERIOD = 0.0;                  // non-simulatable
parameter CLKOUT_PHASE_SHIFT = "NONE";
parameter CLK_FEEDBACK = "1X";
parameter DCM_AUTOCALIBRATION = "TRUE";
parameter DCM_PERFORMANCE_MODE = "MAX_SPEED";   // non-simulatable
parameter DESKEW_ADJUST = "SYSTEM_SYNCHRONOUS"; // non-simulatable
parameter DFS_FREQUENCY_MODE = "LOW";
parameter DLL_FREQUENCY_MODE = "LOW";
parameter DUTY_CYCLE_CORRECTION = "TRUE";
parameter FACTORY_JF = 16'hF0F0;                // non-simulatable
localparam MAXPERCLKIN = 1000000;                // non-modifiable simulation parameter
localparam MAXPERPSCLK = 100000000;              // non-modifiable simulation parameter
parameter PHASE_SHIFT = 0;
localparam SIM_CLKIN_CYCLE_JITTER = 300;         // non-modifiable simulation parameter
localparam SIM_CLKIN_PERIOD_JITTER = 1000;       // non-modifiable simulation parameter
parameter STARTUP_WAIT = "FALSE";               // non-simulatable

output CLK0;
output CLK180;
output CLK270;
output CLK2X180;
output CLK2X;
output CLK90;
output CLKDV;
output CLKFX180;
output CLKFX;
output DRDY;
output LOCKED;
output PSDONE;
output [15:0] DO;

input CLKFB;
input CLKIN;
input DCLK;
input DEN;
input DWE;
input PSCLK;
input PSEN;
input PSINCDEC;
tri0 GSR = glbl.GSR;
input RST;
input [15:0] DI;
input [6:0] DADDR;

reg CLK0;
reg CLK180;
reg CLK270;
reg CLK2X180;
reg CLK2X;
reg CLK90;
reg CLKDV;
reg CLKFX180;
reg CLKFX;

wire [15:0] di_in;
wire [6:0] daddr_in;

wire clkfb_in, clkin_in, dssen_in;
wire psclk_in, psen_in, psincdec_in, rst_in, gsr_in, rst_input ;
reg clk0_out;
reg clk2x_out, clkdv_out;
reg clkfx_out, locked_out, psdone_out, ps_overflow_out;
reg clkfx_out_avg, clkfx_out_ph;
reg ps_lock;
reg drdy_out;
reg [15:0] do_out;
reg valid_daddr;


reg [1:0] clkfb_type;
reg [8:0] divide_type;
reg clkin_type;
reg [2:0] ps_type;
reg [3:0] deskew_adjust_mode;
reg dfs_mode_type;
reg dll_mode_type;
reg clk1x_type;
integer ps_in, ps_min, ps_max;
integer ps_in_ps, ps_in_psdrp, ps_in_curr;
integer ps_delay_ps, ps_delay_drp;
integer clkdv_cnt;

reg lock_period, lock_delay, lock_clkin, lock_clkfb;
reg [1:0] lock_out;
reg lock_out1_neg;
reg lock_fb, lock_ps, lock_ps_dly;
reg fb_delay_found;
reg clock_stopped;
reg clkin_chkin, clkfb_chkin;

wire chk_enable, chk_rst;
wire clkin_div;
wire locked_out_tmp;
wire lock_period_pulse;

reg clkin_ps;
reg clkin_fb;

time FINE_SHIFT_RANGE;
time ps_delay;
time delay_edge;
time clkin_period [2:0];
time period;
time period_div;
time period_orig;
time period_ps;
time clkout_delay;
time fb_delay;
time period_fx, remain_fx;
time period_fxtmp, period_fxavg;
time period_dv_high, period_dv_low;
time cycle_jitter, period_jitter;
time clkin_div_edge, clkin_ps_edge, clkin_edge;
time tap_delay_step;

reg clkin_window, clkfb_window;
reg [2:0] rst_reg;
reg [12:0] numerator, denominator, gcd;
reg [23:0] i, n, d, p;

reg first_time_locked;
reg en_status;
reg [1521:0] mem_drp;
reg drp_lock;
reg ps_drp_lock, ps_drp_lock_tmp;
integer ps_drp, ps_in_drp;
reg  ps_kick_off_cmd;

reg single_step_lock, single_step_lock_tmp, single_step_done;
integer clkfx_multiply_drp, clkfx_divide_drp;
reg inc_dec;
reg do_out0, do_out1, do_out2, do_out3, do_out4, do_out5, do_out6, do_out7;
reg do_out8, do_out9, do_out10, do_out11, do_out12, do_out13, do_out14, do_out15;


reg notifier;

initial begin
    #1;
    if ($realtime == 0) begin
	$display ("Simulator Resolution Error : Simulator resolution is set to a value greater than 1 ps.");
	$display ("In order to simulate the DCM_ADV, the simulator resolution must be set to 1ps or smaller.");
	$finish;
    end
end

initial begin
    case (CLKDV_DIVIDE)
	1.5  : divide_type = 'd3;
	2.0  : divide_type = 'd4;
	2.5  : divide_type = 'd5;
	3.0  : divide_type = 'd6;
	3.5  : divide_type = 'd7;
	4.0  : divide_type = 'd8;
	4.5  : divide_type = 'd9;
	5.0  : divide_type = 'd10;
	5.5  : divide_type = 'd11;
	6.0  : divide_type = 'd12;
	6.5  : divide_type = 'd13;
	7.0  : divide_type = 'd14;
	7.5  : divide_type = 'd15;
	8.0  : divide_type = 'd16;
	9.0  : divide_type = 'd18;
	10.0 : divide_type = 'd20;
	11.0 : divide_type = 'd22;
	12.0 : divide_type = 'd24;
	13.0 : divide_type = 'd26;
	14.0 : divide_type = 'd28;
	15.0 : divide_type = 'd30;
	16.0 : divide_type = 'd32;
	default : begin
	    $display("Attribute Syntax Error : The attribute CLKDV_DIVIDE on DCM_ADV instance %m is set to %0.1f.  Legal values for this attribute are 1.5, 2.0, 2.5, 3.0, 3.5, 4.0, 4.5, 5.0, 5.5, 6.0, 6.5, 7.0, 7.5, 8.0, 9.0, 10.0, 11.0, 12.0, 13.0, 14.0, 15.0, or 16.0.", CLKDV_DIVIDE);
	    $finish;
	end
    endcase

//    if (DFS_OSCILLATOR_MODE == "AVE_FREQ_LOCK") 
//       if ((CLKFX_DIVIDE <= 0) || (4096 < CLKFX_DIVIDE)) begin
//	   $display("Attribute Syntax Error : The attribute CLKFX_DIVIDE on DCM_ADV instance %m is set to %d.  Legal values for this attribute are 1 ... 4096.", CLKFX_DIVIDE);
//	   $finish;
//       end
//    else
       if ((CLKFX_DIVIDE <= 0) || (32 < CLKFX_DIVIDE)) begin
	   $display("Attribute Syntax Error : The attribute CLKFX_DIVIDE on DCM_ADV instance %m is set to %d.  Legal values for this attribute are 1 ... 32.", CLKFX_DIVIDE);
	   $finish;
       end

//    if (DFS_OSCILLATOR_MODE == "AVE_FREQ_LOCK")
//       if ((CLKFX_MULTIPLY <= 1) || (4096 < CLKFX_MULTIPLY)) begin
//   	  $display("Attribute Syntax Error : The attribute CLKFX_MULTIPLY on DCM_ADV instance %m is set to %d.  Legal values for this attribute are 2 ... 4096.", CLKFX_MULTIPLY);
//   	  $finish;
//       end
//    else 
       if ((CLKFX_MULTIPLY <= 1) || (32 < CLKFX_MULTIPLY)) begin
   	  $display("Attribute Syntax Error : The attribute CLKFX_MULTIPLY on DCM_ADV instance %m is set to %d.  Legal values for this attribute are 2 ... 32.", CLKFX_MULTIPLY);
   	  $finish;
       end

    case (CLKIN_DIVIDE_BY_2)
	"FALSE" : clkin_type = 0;
	"TRUE"  : clkin_type = 1;
	default : begin
	    $display("Attribute Syntax Error : The attribute CLKIN_DIVIDE_BY_2 on DCM_ADV instance %m is set to %s.  Legal values for this attribute are TRUE or FALSE.", CLKIN_DIVIDE_BY_2);
	    $finish;
	end
    endcase

    case (CLKOUT_PHASE_SHIFT)
	"NONE"     : begin
		ps_in = 0 + 256;
		ps_type = 3'b000;
	end
	"FIXED"    : begin
	    ps_in = PHASE_SHIFT + 256;
	    ps_max = 255 + 256;
	    ps_min = -255 + 256;
	    ps_type = 3'b001;
            if ( DCM_PERFORMANCE_MODE == "MAX_RANGE" )
               FINE_SHIFT_RANGE = 10000;
            else
               FINE_SHIFT_RANGE = 7000;
    	    if ((PHASE_SHIFT < -255) || (PHASE_SHIFT > 255)) begin
		$display("Attribute Syntax Error : The attribute PHASE_SHIFT on DCM_ADV instance %m is set to %d.  Legal values for this attribute are -255 ... 255.", PHASE_SHIFT);
		$display("Error : PHASE_SHIFT = %d is not -255 ... 255.", PHASE_SHIFT);
		$finish;
	    end
	end
	"VARIABLE_POSITIVE" : begin
	    ps_in = PHASE_SHIFT + 256;
	    ps_max = 255 + 256;
	    ps_min = 0 + 256;
	    ps_type = 3'b011;
            if ( DCM_PERFORMANCE_MODE == "MAX_RANGE" )
               FINE_SHIFT_RANGE = 10000;
            else
               FINE_SHIFT_RANGE = 7000;
    	    if ((PHASE_SHIFT < 0) || (PHASE_SHIFT > 255)) begin
		$display("Attribute Syntax Error : The attribute PHASE_SHIFT on DCM_ADV instance %m is set to %d.  Legal values for this attribute are 0 ... 255.", PHASE_SHIFT);
		$display("Error : PHASE_SHIFT = %d is not 0 ... 255.", PHASE_SHIFT);
		$finish;
	    end
	end
	"VARIABLE_CENTER" : begin
	    ps_in = PHASE_SHIFT + 256;
	    ps_max = 255 + 256;
	    ps_min = -255 + 256;
	    ps_type = 3'b100;
            if ( DCM_PERFORMANCE_MODE == "MAX_RANGE" )
               FINE_SHIFT_RANGE = 5000;
            else
               FINE_SHIFT_RANGE = 3500;
    	    if ((PHASE_SHIFT < -255) || (PHASE_SHIFT > 255)) begin
		$display("Attribute Syntax Error : The attribute PHASE_SHIFT on DCM_ADV instance %m is set to %d.  Legal values for this attribute are -255 ... 255.", PHASE_SHIFT);
		$display("Error : PHASE_SHIFT = %d is not -255 ... 255.", PHASE_SHIFT);
		$finish;
	    end
	end
	"DIRECT" : begin
	    ps_in = PHASE_SHIFT;
            ps_max = 1023;
            ps_min = 0;
	    ps_type = 3'b101;
            if (DCM_PERFORMANCE_MODE == "MAX_RANGE")
            begin
                  tap_delay_step = 18;
                FINE_SHIFT_RANGE = 10000;
            end
            else
            begin
                tap_delay_step = 11;
                FINE_SHIFT_RANGE = 7000;
            end
    	    if ((PHASE_SHIFT < 0) || (PHASE_SHIFT > 1023)) begin
		$display("Attribute Syntax Error : The attribute PHASE_SHIFT on DCM_ADV instance %m is set to %d.  Legal values for this attribute is 0 to 1023.", PHASE_SHIFT);
		$display("Error : PHASE_SHIFT = %d is not 0 to 1023.", PHASE_SHIFT);
		$finish;
	    end
	end
	default : begin
	    $display("Attribute Syntax Error : The Attribute CLKOUT_PHASE_SHIFT on DCM_ADV instance %m is set to %s.  Legal values for this attribute are NONE, FIXED, VARIABLE_POSITIVE, VARIABLE_CENTER or DIRECT.", CLKOUT_PHASE_SHIFT);
	    $finish;
	end
    endcase

    case (CLK_FEEDBACK)
	"NONE" : begin
                   clkfb_type = 0;
                   $display("Attribute CLK_FEEDBACK is set to value NONE.");
                   $display("In this mode, the output ports CLK0, CLK180, CLK270, CLK2X, CLK2X180, CLK90 and  CLKDV can have any random phase relation w.r.t. input port CLKIN");
                 end
	"1X"   : clkfb_type = 1;
	default : begin
	    $display("Attribute Syntax Error : The attribute CLK_FEEDBACK on DCM_ADV instance %m is set to %s.  Legal values for this attribute are NONE or 1X.", CLK_FEEDBACK);
	    $finish;
	end
    endcase

    case (DCM_PERFORMANCE_MODE)
        "MAX_SPEED" : ;
        "MAX_RANGE" : ;
        default : begin
            $display("Attribute Syntax Error : The Attribute DCM_PERFORMANCE_MODE on DCM_ADV instance %m is set to %s.  Legal values for this attribute are MAX_SPEED or MAX_RANGE.", DCM_PERFORMANCE_MODE);
            $finish;
        end
    endcase

    case (DESKEW_ADJUST)
	"SOURCE_SYNCHRONOUS" : deskew_adjust_mode = 0;
	"SYSTEM_SYNCHRONOUS" : deskew_adjust_mode = 11;
	"0"		     : deskew_adjust_mode = 0;
	"1"		     : deskew_adjust_mode = 1;
	"2"		     : deskew_adjust_mode = 2;
	"3"		     : deskew_adjust_mode = 3;
	"4"		     : deskew_adjust_mode = 4;
	"5"		     : deskew_adjust_mode = 5;
	"6"		     : deskew_adjust_mode = 6;
	"7"		     : deskew_adjust_mode = 7;
	"8"		     : deskew_adjust_mode = 8;
	"9"		     : deskew_adjust_mode = 9;
	"10"		     : deskew_adjust_mode = 10;
	"11"		     : deskew_adjust_mode = 11;
	"12"		     : deskew_adjust_mode = 12;
	"13"		     : deskew_adjust_mode = 13;
	"14"		     : deskew_adjust_mode = 14;
	"15"		     : deskew_adjust_mode = 15;
        "16"                 : deskew_adjust_mode = 16;
        "17"                 : deskew_adjust_mode = 17;
        "18"                 : deskew_adjust_mode = 18;
        "19"                 : deskew_adjust_mode = 19;
        "20"                 : deskew_adjust_mode = 20;
        "21"                 : deskew_adjust_mode = 21;
        "22"                 : deskew_adjust_mode = 22;
        "23"                 : deskew_adjust_mode = 23;
        "24"                 : deskew_adjust_mode = 24;
        "25"                 : deskew_adjust_mode = 25;
        "26"                 : deskew_adjust_mode = 26;
        "27"                 : deskew_adjust_mode = 27;
        "28"                 : deskew_adjust_mode = 28;
        "29"                 : deskew_adjust_mode = 29;
        "30"                 : deskew_adjust_mode = 30;
        "31"                 : deskew_adjust_mode = 31;
	default : begin
	    $display("Attribute Syntax Error : The attribute DESKEW_ADJUST on DCM_ADV instance %m is set to %s.  Legal values for this attribute are SOURCE_SYNCHRONOUS, SYSTEM_SYNCHRONOUS or 0 ... 15.", DESKEW_ADJUST);
	    $finish;
	end
    endcase

    case (DFS_FREQUENCY_MODE)
	"HIGH" : dfs_mode_type = 1;
	"LOW"  : dfs_mode_type = 0;
	default : begin
	    $display(" Attribute Syntax Error : The attribute DFS_FREQUENCY_MODE on DCM_ADV instance %m is set to %s. Legal values for this attribute are HIGH or LOW.", DFS_FREQUENCY_MODE);
	    $finish;
	end
     endcase

    period_jitter = SIM_CLKIN_PERIOD_JITTER;
    cycle_jitter = SIM_CLKIN_CYCLE_JITTER;

    case (DLL_FREQUENCY_MODE)
	"HIGH" : dll_mode_type = 1;
	"LOW"  : dll_mode_type = 0;
	default : begin
	    $display("Attribute Syntax Error : The attribute DLL_FREQUENCY_MODE on DCM_ADV instance %m is set to %s.  Legal values for this attribute are HIGH or LOW.", DLL_FREQUENCY_MODE);
	    $finish;
	end
    endcase

    case (FACTORY_JF)
      16'hF0F0 : ;
      default : 
	    $display("Attribute Syntax Warning : The attribute FACTORY_JF on DCM_ADV instance %m is set to %h.  Legal value is F0F0.", FACTORY_JF);
    endcase

    case (DUTY_CYCLE_CORRECTION)
	"FALSE" : clk1x_type = 0;
	"TRUE"  : clk1x_type = 1;
	default : begin
	    $display("Attribute Syntax Error : The attribute DUTY_CYCLE_CORRECTION on DCM_ADV instance %m is set to %s.  Legal values for this attribute are TRUE or FALSE.", DUTY_CYCLE_CORRECTION);
	    $finish;
	end
    endcase

    case (STARTUP_WAIT)
	"FALSE" : ;
	"TRUE"  : ;
	default : begin
	    $display("Attribute Syntax Error : The attribute STARTUP_WAIT on DCM_ADV instance %m is set to %s.  Legal values for this attribute are TRUE or FALSE.", STARTUP_WAIT);
	    $finish;
	end
    endcase

    case (DCM_AUTOCALIBRATION)
	"FALSE" : ;
	"TRUE"  : ;
	default : begin
	    $display("Attribute Syntax Error : The attribute DCM_AUTOCALIBRATION on DCM_ADV instance %m is set to %s.  Legal values for this attribute are TRUE or FALSE.", DCM_AUTOCALIBRATION);
	    $finish;
	end
    endcase

end


//
// input wire delays
//


buf #100 b_LOCKED (LOCKED, locked_out);
buf #100 b_PSDONE (PSDONE, psdone_out);
buf #100 b_DO0 (DO[0], do_out0);
buf #100 b_DO1 (DO[1], do_out1);
buf #100 b_DO2 (DO[2], do_out2);
buf #100 b_DO3 (DO[3], do_out3);
buf #100 b_DO4 (DO[4], do_out4);
buf #100 b_DO5 (DO[5], do_out5);
buf #100 b_DO6 (DO[6], do_out6);
buf #100 b_DO7 (DO[7], do_out7);
buf #100 b_DO8 (DO[8], do_out8);
buf #100 b_DO9 (DO[9], do_out9);
buf #100 b_DO10 (DO[10], do_out10);
buf #100 b_DO11 (DO[11], do_out11);
buf #100 b_DO12 (DO[12], do_out12);
buf #100 b_DO13 (DO[13], do_out13);
buf #100 b_DO14 (DO[14], do_out14);
buf #100 b_DO15 (DO[15], do_out15);
buf #100 b_DRDY (DRDY, drdy_out);

buf b_CLKIN (clkin_in, CLKIN);
buf b_CLKFB (clkfb_in, CLKFB);
buf b_PSCLK (psclk_in, PSCLK);
buf b_PSEN (psen_in, PSEN);
buf b_PSINCDEC (psincdec_in, PSINCDEC);
buf b_GSR (gsr_in, GSR);
buf b_RST (rst_input, RST);
buf b_DADDR0 (daddr_in[0], DADDR[0]);
buf b_DADDR1 (daddr_in[1], DADDR[1]);
buf b_DADDR2 (daddr_in[2], DADDR[2]);
buf b_DADDR3 (daddr_in[3], DADDR[3]);
buf b_DADDR4 (daddr_in[4], DADDR[4]);
buf b_DADDR5 (daddr_in[5], DADDR[5]);
buf b_DADDR6 (daddr_in[6], DADDR[6]);
buf b_DI0 (di_in[0], DI[0]);
buf b_DI1 (di_in[1], DI[1]);
buf b_DI2 (di_in[2], DI[2]);
buf b_DI3 (di_in[3], DI[3]);
buf b_DI4 (di_in[4], DI[4]);
buf b_DI5 (di_in[5], DI[5]);
buf b_DI6 (di_in[6], DI[6]);
buf b_DI7 (di_in[7], DI[7]);
buf b_DI8 (di_in[8], DI[8]);
buf b_DI9 (di_in[9], DI[9]);
buf b_DI10 (di_in[10], DI[10]);
buf b_DI11 (di_in[11], DI[11]);
buf b_DI12 (di_in[12], DI[12]);
buf b_DI13 (di_in[13], DI[13]);
buf b_DI14 (di_in[14], DI[14]);
buf b_DI15 (di_in[15], DI[15]);
buf b_DWE (dwe_in, DWE);
buf b_DEN (den_in, DEN);
buf b_DCLK (dclk_in, DCLK);

assign rst_in = gsr_in | rst_input;

dcm_adv_clock_divide_by_2 i_clock_divide_by_2 (clkin_in, clkin_type, clkin_div, rst_in);

dcm_adv_maximum_period_check #("CLKIN", MAXPERCLKIN) i_max_clkin (clkin_in);
dcm_adv_maximum_period_check #("PSCLK", MAXPERPSCLK) i_max_psclk (psclk_in);

dcm_adv_clock_lost i_clkin_lost (clkin_in, first_time_locked, clkin_lost_out, rst_in);
dcm_adv_clock_lost i_clkfx_lost (CLKFX, first_time_locked, clkfx_lost_out, rst_in);
dcm_adv_clock_lost i_clkfb_lost (CLKFB, first_time_locked, clkfb_lost_out, rst_in);


always @(clkin_div) 
    clkin_ps <= #(ps_delay) clkin_div;

always @(clkin_ps or lock_fb)
//    clkin_fb <= #(period_ps) clkin_ps & lock_fb;
    clkin_fb =  clkin_ps & lock_fb;

always @(posedge clkin_fb or posedge chk_rst)
    if (chk_rst)
       clkin_chkin <= 0;
    else
       clkin_chkin <= 1;

always @(posedge clkfb_in or posedge chk_rst)
    if (chk_rst)
       clkfb_chkin <= 0;
    else
       clkfb_chkin <= 1;

    assign chk_rst = (rst_in==1 || clock_stopped==1 ) ? 1 : 0;
    assign chk_enable = (clkin_chkin == 1 && clkfb_chkin == 1 &&
                         lock_ps ==1 && lock_fb ==1 ) ? 1 : 0;

always @(posedge clkin_div)
 if ( clkin_div == 1) begin
    clkin_div_edge <= $time;
    if (($time - clkin_div_edge) <= (1.5 * period_div))
	period_div <= $time - clkin_div_edge;
    else if ((period_div == 0) && (clkin_div_edge != 0))
	period_div <= $time - clkin_div_edge;
 end


always @(posedge clkin_ps) 
 if (clkin_ps==1) begin
    clkin_ps_edge <= $time;
#0;
    if (($time - clkin_ps_edge) <= (1.5 * period_ps))
	period_ps <= $time - clkin_ps_edge;
    else if ((period_ps == 0) && (clkin_ps_edge != 0))
	period_ps <= $time - clkin_ps_edge;
 end

always @(posedge clkin_ps) begin
    lock_ps <= lock_period;
    lock_ps_dly <= lock_ps;
    lock_fb <= lock_ps_dly;
end

always @(period or fb_delay)
  if (fb_delay ==0)
    clkout_delay = 0;
  else
    clkout_delay = period - fb_delay;

//
// generate master reset signal
//

always @(posedge clkin_in) begin
    rst_reg[0] <= rst_in;
    rst_reg[1] <= rst_reg[0] & rst_in;
    rst_reg[2] <= rst_reg[1] & rst_reg[0] & rst_in;
end

reg rst_tmp1, rst_tmp2;
initial
begin
rst_tmp1 = 0;
rst_tmp2 = 0;
end

always @(rst_input)
begin
   rst_tmp1 = rst_input;
   if (rst_tmp1 == 0 && rst_tmp2 == 1) begin
    if ((rst_reg[2] & rst_reg[1] & rst_reg[0]) == 0)
	$display("Input Error : RST on instance %m must be asserted for 3 CLKIN clock cycles.");
   end
   rst_tmp2 = rst_tmp1;
end

initial begin
    CLK0 = 0;
    CLK2X =0;
    CLK2X180 = 0;
    CLK90 = 0;
    CLK180 =0;
    CLK270 = 0;
    CLKDV = 0;
    CLKFX = 0;
    CLKFX180 =0;
    clk0_out = 0;
    clk2x_out = 0;
    clkdv_out = 0;
    clkdv_cnt = 0;
    clkfb_window = 0;
    clkfx_out = 0;
    clkfx_out_avg = 0;
    clkfx_out_ph = 0;
    clkin_div_edge = 0;
    clkin_period[0] = 0;
    clkin_period[1] = 0;
    clkin_period[2] = 0;
    period = 0;
    clkin_ps_edge = 0;
    clkin_window = 0;
    clkout_delay = 0;
    clock_stopped = 1;
    fb_delay  = 0;
    fb_delay_found = 0;
    lock_clkfb = 0;
    lock_clkin = 0;
    lock_delay = 0;
    lock_fb = 0;
    lock_out = 2'b00;
    lock_out1_neg = 0;
    lock_period = 0;
    lock_ps = 0;
    lock_ps_dly = 0;
    locked_out = 0;
    period = 0;
    period_div = 0;
    period_fx = 0;
    period_fxavg = 0;
    period_orig = 0;
    period_ps = 0;
    delay_edge = 0;
    psdone_out = 0;
    ps_delay = 0;
    ps_lock = 0;
    inc_dec = 0;
    ps_overflow_out = 0;
    ps_delay_ps = 0;
    ps_delay_drp = 0;
    ps_in_ps = 0;
    ps_in_psdrp = 0;
    ps_in_curr = 0;
    rst_reg = 3'b000;
    numerator = CLKFX_MULTIPLY;
    denominator = CLKFX_DIVIDE;
    clkfx_multiply_drp = CLKFX_MULTIPLY;
    clkfx_divide_drp = CLKFX_DIVIDE;
    gcd = 1;
    drdy_out = 0;
    do_out = 16'h0000;
    do_out0 = 0;
    do_out1 = 0;
    do_out2 = 0;
    do_out3 = 0;
    do_out4 = 1'b0;
    do_out5 = 1'b0;
    do_out6 = 1'b0;
    do_out7 = 1'b0;
    do_out8 = 1'b0;
    do_out9 = 1'b0;
    do_out10 = 1'b0;
    do_out11 = 1'b0;
    do_out12 = 1'b0;
    do_out13 = 1'b0;
    do_out14 = 1'b0;
    do_out15 = 1'b0;
    valid_daddr = 0;
    
    first_time_locked = 0;
    en_status = 0;
    drp_lock = 0;
    ps_drp = 0;
    ps_kick_off_cmd = 0;
    single_step_lock = 0;
    single_step_lock_tmp = 0;
    single_step_done = 0;
    ps_drp_lock = 0;
    ps_drp_lock_tmp = 0;
    clkin_chkin = 0;
    clkfb_chkin = 0;
end
//
// phase shift parameters
//

always @(posedge lock_period) begin
  if ((ps_type == 3'b000) || (ps_type == 3'b001) || (ps_type == 3'b011) || (ps_type == 3'b100))  begin
    if (PHASE_SHIFT > 0) begin
	if ((ps_in * period_orig / 256) > period_orig + FINE_SHIFT_RANGE) begin
            $display("Function Error : Instance %m Requested Phase Shift = PHASE_SHIFT * PERIOD / 256 = %d * %1.3f / 256 = %1.3f. This exceeds the FINE_SHIFT_RANGE of %1.3f ns.", PHASE_SHIFT, period_orig / 1000.0, PHASE_SHIFT * period_orig/ 256 / 1000.0, FINE_SHIFT_RANGE / 1000.0);
	      $finish;
	end
    end
    else if (PHASE_SHIFT < 0) begin
	if ((period_orig > FINE_SHIFT_RANGE) &&
	    ((ps_in * period_orig / 256) < period_orig - FINE_SHIFT_RANGE)) begin
            $display("Function Error : Instance %m Requested Phase Shift = PHASE_SHIFT * PERIOD / 256 = %d * %1.3f / 256 = %1.3f. This exceeds the FINE_SHIFT_RANGE of %1.3f ns.", PHASE_SHIFT, period_orig / 1000.0, -(PHASE_SHIFT) * period_orig / 256 / 1000.0, FINE_SHIFT_RANGE / 1000.0);
	      $finish;
	end
    end
  end
  else if (ps_type == 3'b101) begin
            if ((ps_in * tap_delay_step) > FINE_SHIFT_RANGE) begin
	    $display(" Phase shift Error : Allowed phase shift range on instance %m is between 0 to  %d. ", FINE_SHIFT_RANGE / tap_delay_step);
	      $finish;
            end
  end
end

always @(posedge lock_period_pulse or posedge rst_in or ps_delay_ps or ps_delay_drp or ps_in_ps
          or ps_in_psdrp) 
  if (rst_in) begin
     ps_delay <= 0;
     ps_in_curr <= ps_in;
  end
  else  if (lock_period_pulse) begin
     if ((ps_type == 3'b000) || (ps_type == 3'b001) || (ps_type == 3'b011) || (ps_type == 3'b100))
          ps_delay <= (ps_in * period_div / 256);
     else if (ps_type == 3'b101) 
          ps_delay <= ps_in * tap_delay_step;
  end
  else  begin
    if (((ps_type == 3'b011) || (ps_type == 3'b100) ) ) 
     begin
          ps_in_curr = ps_in_ps;
          ps_delay = (ps_in_ps * period_div / 256);
     end
    else if ((ps_type == 3'b101) && (ps_lock==1))
    begin
          ps_in_curr = ps_in_ps;
          ps_delay = ps_in_ps * tap_delay_step;
    end
    else if ((ps_type == 3'b101) && (ps_drp_lock==1))
    begin
          ps_in_curr = ps_in_psdrp;
          ps_delay = ps_delay_drp;
    end
  end
     



always @(posedge psclk_in or posedge rst_in) 
  if (rst_in) begin
    ps_in_ps <= ps_in;
    ps_overflow_out <= 0;
    ps_delay_ps <= 0;
  end
  else begin
    if ((ps_type == 3'b011) || (ps_type == 3'b100) ) begin
	if (psen_in)
	    if (ps_lock == 1)
		  $display(" Warning : Please wait for PSDONE signal before adjusting the Phase Shift.");
	    else
	    if (psincdec_in == 1) begin
		if (ps_in_ps == ps_max)
		    ps_overflow_out <= 1;
		else if (((ps_in_ps + 1) * period_orig / 256) > period_orig + FINE_SHIFT_RANGE)
		    ps_overflow_out <= 1;
		else begin
		    ps_in_ps <= ps_in_ps + 1;
//		    ps_delay_ps = (ps_in_ps * period_div / 256);
		    ps_overflow_out <= 0;
		end
		ps_lock <= 1;
	    end
	    else if (psincdec_in == 0) begin
		if (ps_in_ps == ps_min)
		    ps_overflow_out <= 1;
		else if ((period_orig > FINE_SHIFT_RANGE) &&
		     (((ps_in_ps - 1) * period_orig / 256) < period_orig - FINE_SHIFT_RANGE))
		      ps_overflow_out <= 1;
		else begin
		    ps_in_ps <= ps_in_ps - 1;
//		    ps_delay_ps = (ps_in_ps * period_div / 256);
		    ps_overflow_out <= 0;
		end
		ps_lock <= 1;
	    end
     end
     if (ps_type == 3'b101)  begin
          if (psen_in == 1) begin
            if (ps_lock == 1) begin
              $display(" Warning : Please wait for PSDONE signal before adjusting the Phase Shift. ");
            end
            else
            begin
              if (psincdec_in == 1) begin
                if (ps_in_curr == ps_max) 
                  ps_overflow_out <= 1;
                else if (ps_in_curr * tap_delay_step > FINE_SHIFT_RANGE) 
                  ps_overflow_out <= 1;
                else
                 begin
                  ps_in_ps <= ps_in_curr + 1;
//                  ps_delay_ps = ps_in_curr * tap_delay_step;
                  ps_overflow_out <= 0;
                end
                ps_lock <= 1;
              end
              else if (psincdec_in == 0) begin
                if (ps_in_curr == ps_min) 
                  ps_overflow_out <= 1;
                else if (ps_in_curr * tap_delay_step > FINE_SHIFT_RANGE) 
                  ps_overflow_out <= 1;
                else
                begin
                  ps_in_ps <= ps_in_curr - 1;
//                  ps_delay_ps = ps_in_curr * tap_delay_step;
                  ps_overflow_out <= 0;
                end
                ps_lock <= 1;
              end
            end
          end
     end
     if ( psdone_out == 1)
            ps_lock <= 0;
end

always @(posedge clkin_ps or posedge rst_in)
  if (rst_in) begin
     single_step_lock <= 0;
     ps_in_psdrp <= ps_in;
     ps_delay_drp <= 0;
  end
  else begin
     if (ps_type == 3'b101) begin
        if (ps_drp_lock == 1) begin 
            if (inc_dec == 1) begin 
              if (ps_in_curr < ps_in_drp) begin 
                if (single_step_lock == 0) 
                begin
                  single_step_lock <= 1;
                  ps_in_psdrp <= ps_in_curr + 1;
                  ps_delay_drp <= ps_delay + tap_delay_step;
                end
               end
              else if (ps_in_curr == ps_in_drp) 
                ps_drp_lock <= 0;
            end
            else if (inc_dec == 0) begin 
              if (ps_in_curr > ps_in_drp) begin
                if (single_step_lock == 0) 
                begin 
                  single_step_lock <= 1;
                  ps_in_psdrp <= ps_in_curr - 1;
                  ps_delay_drp <= ps_delay - tap_delay_step;
                end
              end
              else if (ps_in_psdrp == ps_in_drp) 
                ps_drp_lock <= 0;
            end
        end
    end

    if ( single_step_lock_tmp == 1)
         single_step_lock <= 0;
  
    if (ps_drp_lock_tmp == 1)
         ps_drp_lock <= 1;
end

always @( single_step_lock or clkin_ps)
begin
      @( posedge single_step_lock)
      @( posedge clkin_ps)
      @( posedge clkin_ps)
      @( posedge clkin_ps)
         single_step_lock_tmp <= 1;
      @( posedge clkin_ps)
         single_step_lock_tmp <= 0;
end

always @( ps_kick_off_cmd or dclk_in or clkin_in or ps_drp_lock )
begin
      @(posedge ps_kick_off_cmd)
      @( posedge dclk_in)
      @( posedge dclk_in)
      @( posedge clkin_in)
      @( posedge clkin_in)
      @( posedge clkin_in)
      @( posedge clkin_in)
      @( posedge clkin_in)
         ps_drp_lock_tmp <= 1;
      @( posedge ps_drp_lock)
         ps_drp_lock_tmp <= 0;
end

always @(posedge ps_lock or negedge ps_drp_lock )
//  if (ps_lock == 1) begin
//     @(posedge clkin_ps)
//     @(posedge psclk_in)
//     @(posedge psclk_in)
//     @(posedge psclk_in)
//       begin
//         psdone_out = 1;
//         @(posedge psclk_in);
//           psdone_out = 0;
//       end
//  end
//  else
//    if (ps_type == 5 && ps_drp_lock == 0) begin
        @(posedge clkin_ps)
        @(posedge clkin_ps)
        @(posedge clkin_ps)
        @(posedge clkin_ps)
        @(posedge psclk_in)
        @(posedge psclk_in)
          begin
            psdone_out = 1;
            @(posedge psclk_in);
               psdone_out = 0;
          end
//    end

//
// determine clock period
//

always @(posedge clkin_div or negedge clkin_div or posedge rst_in) 
   if ( rst_in == 1)
   begin
     clkin_period[0] <= 0;
     clkin_period[1] <= 0;
     clkin_period[2] <= 0;
     clkin_edge <= 0;
   end
   else 
    if (clkin_div == 1) begin
       clkin_edge <= $time;
       clkin_period[2] <= clkin_period[1];
       clkin_period[1] <= clkin_period[0];
       if (clkin_edge != 0)
	   clkin_period[0] <= $time - clkin_edge;
      end
    else if (clkin_div == 0) 
      if (lock_period == 1) begin
        if (100000000 < clkin_period[0]/1000) 
        begin
        end
        else if ((period_orig * 2 < clkin_period[0]) && (clock_stopped == 0)) begin
          clkin_period[0] <= clkin_period[1];
        end
      end

//
// evaluate_clock_period process
//
always @(negedge clkin_div or posedge rst_in)
  if (rst_in == 1) begin
      lock_period <= 0;
      clock_stopped <= 1;
//      period_fxtmp <= 0;
  end
  else begin
    if (lock_period == 1'b0) begin
	if ((clkin_period[0] != 0) &&
		(clkin_period[0] - cycle_jitter <= clkin_period[1]) &&
		(clkin_period[1] <= clkin_period[0] + cycle_jitter) &&
		(clkin_period[1] - cycle_jitter <= clkin_period[2]) &&
		(clkin_period[2] <= clkin_period[1] + cycle_jitter)) begin
	    lock_period <= 1;
	    period_orig <= (clkin_period[0] +
			    clkin_period[1] +
			    clkin_period[2]) / 3;
//	    period_fxtmp <= (clkin_period[0] +
//			    clkin_period[1] +
//			    clkin_period[2]) / 3;
	    period <= clkin_period[0];
	end
    end
    else if (lock_period == 1'b1) begin
	if (100000000 < (clkin_period[0] / 1000)) begin
	    $display(" Warning : CLKIN stopped toggling on instance %m exceeds %d ms.  Current CLKIN Period = %1.3f ns.", 10000, clkin_period[0] / 1000.0);
	    lock_period <= 0;
	    @(negedge rst_reg[2]);
	end
	else if ((period_orig * 2 < clkin_period[0]) && clock_stopped == 1'b0) begin
//	    clkin_period[0] = clkin_period[1];
	    clock_stopped <= 1'b1;
	end
	else if ((clkin_period[0] < period_orig - period_jitter) ||
		(period_orig + period_jitter < clkin_period[0])) begin
	    $display(" Warning : Input Clock Period Jitter on instance %m exceeds %1.3f ns.  Locked CLKIN Period = %1.3f.  Current CLKIN Period = %1.3f.", period_jitter / 1000.0, period_orig / 1000.0, clkin_period[0] / 1000.0);
	    lock_period <= 0;
	    @(negedge rst_reg[2]);
	end
	else if ((clkin_period[0] < clkin_period[1] - cycle_jitter) ||
		(clkin_period[1] + cycle_jitter < clkin_period[0])) begin
	    $display(" Warning : Input Clock Cycle-Cycle Jitter on instance %m exceeds %1.3f ns.  Previous CLKIN Period = %1.3f.  Current CLKIN Period = %1.3f.", cycle_jitter / 1000.0, clkin_period[1] / 1000.0, clkin_period[0] / 1000.0);
	    lock_period <= 0;
	    @(negedge rst_reg[2]);
	end
	else begin
	    period <= clkin_period[0];
	    clock_stopped <= 1'b0;
//	    period_fxtmp <= (clkin_period[0] +
//			    clkin_period[1] +
//			    clkin_period[2]) / 3;
	end
    end
end

  assign #(period/2) lock_period_dly = lock_period;
  assign lock_period_pulse = (lock_period==1 && lock_period_dly==0) ? 1 : 0;
//
// determine clock delay
//


//always @(posedge lock_period or posedge rst_in) begin
always @(posedge lock_ps_dly or posedge rst_in) begin
  if (rst_in) begin
    fb_delay  <= 0;
    fb_delay_found <= 0;
  end
  else begin
    if (lock_period && clkfb_type != 0) begin
	if (clkfb_type == 1) begin
	    @(posedge CLK0 or rst_in)
		delay_edge = $time;
	end
	else if (clkfb_type == 2) begin
	    @(posedge CLK2X or rst_in)
		delay_edge = $time;
	end
	@(posedge clkfb_in or rst_in)
	fb_delay <= ($time - delay_edge) % period_orig;
    end
    fb_delay_found <= 1;
  end
end

//
// determine feedback lock
//

always @(posedge clkfb_in or posedge rst_in) begin
//always @(posedge clkfb_chk or posedge rst_in) begin
  if (rst_in)
      clkfb_window <= 0;
  else begin
    #0  clkfb_window <= 1;
    #cycle_jitter clkfb_window <= 0;
  end
end

always @(posedge clkin_fb or posedge rst_in) begin
  if (rst_in)
      clkin_window <= 0;
  else begin
    #0  clkin_window <= 1;
    #cycle_jitter clkin_window <= 0;
  end
end

always @(posedge clkin_fb or posedge rst_in) begin
  if (rst_in)
     lock_clkin <= 0;
  else begin
    #1
    if ((clkfb_window && fb_delay_found ) || (clkin_lost_out == 1'b1 && lock_out[0]==1'b1))
	lock_clkin <= 1;
    else
      if (chk_enable ==1)
	lock_clkin <= 0;
  end
end

always @(posedge clkfb_in or posedge rst_in) begin
  if (rst_in)
    lock_clkfb <= 0;
  else begin
    #1
    if ((clkin_window && fb_delay_found) || (clkin_lost_out == 1'b1 && lock_out[0]==1'b1)) 
	lock_clkfb <= 1;
    else
      if (chk_enable ==1)
	lock_clkfb <= 0;
  end
end

always @(negedge clkin_fb or posedge rst_in) begin
  if (rst_in)
    lock_delay <= 0;
  else
    lock_delay <= lock_clkin || lock_clkfb;
end

//
// generate lock signal
//

always @(posedge clkin_ps or posedge rst_in) 
  if (rst_in) begin
      lock_out <= 2'b00;
      locked_out <=0;
  end
  else begin
    if (clkfb_type == 0)
        lock_out[0] <= lock_period;
    else
        lock_out[0] <= lock_period & lock_delay & lock_fb;
    lock_out[1] <= lock_out[0];
    locked_out <= lock_out[1];
  end

always @(negedge clkin_ps or posedge rst_in)
  if (rst_in)
    lock_out1_neg <= 0;
  else
    lock_out1_neg <= lock_out[1];

//
// generate the clk1x_out
//

always @(posedge clkin_ps or negedge clkin_ps or posedge rst_in)
  if (rst_in)
      clk0_out <= 0;
  else
    if (clkin_ps ==1)
       if (clk1x_type==1 && lock_out[0]) begin
          clk0_out <= 1;
          #(period / 2)
             clk0_out <= 0;
       end
       else
          clk0_out <= 1;
    else
      if (clkin_ps == 0 && ((clk1x_type && lock_out[0]) == 0 || (lock_out[0] ==1 && lock_out[1] == 0)))
          clk0_out <= 0;

//
// generate the clk2x_out
//

always @(posedge clkin_ps or posedge rst_in )
  if (rst_in)
     clk2x_out <= 0;
  else begin
    clk2x_out <= 1;
    #(period / 4)
    clk2x_out <= 0;
    if (lock_out[0]) begin
	#(period / 4)
	clk2x_out <= 1;
	#(period / 4)
	clk2x_out <= 0;
    end
    else begin
	#(period / 2);
    end
end

//
// generate the clkdv_out
//

always @(posedge clkin_ps or negedge clkin_ps or posedge rst_in)
  if (rst_in) begin
       clkdv_out <= 1'b0;
       clkdv_cnt <= 0;
  end
  else
    if (lock_out1_neg) begin
      if (clkdv_cnt >= divide_type -1)
           clkdv_cnt <= 0;
      else
           clkdv_cnt <= clkdv_cnt + 1;

      if (clkdv_cnt < divide_type /2)
          clkdv_out <= 1'b1;
      else
         if ( (divide_type[0] == 1'b1) && dll_mode_type == 1'b0)
             clkdv_out <= #(period/4) 1'b0;
         else
            clkdv_out <= 1'b0;
    end

//
//determine_clkfx_divide_multiply
//
always @(rst_in or clkfx_multiply_drp or clkfx_divide_drp)
begin
    if (rst_in == 1 ) begin
        numerator = clkfx_multiply_drp;
        denominator = clkfx_divide_drp;
    end
end 
     
//
// generate fx output signal
//

always @(lock_period or period or denominator or numerator )
    if (lock_period == 1'b1) begin
       period_fx = (period * denominator) / (numerator * 2);
       remain_fx = (period * denominator) % (numerator * 2);
    end

always @( clkfx_out_ph)
     clkfx_out = clkfx_out_ph;



always @(posedge clkin_ps or posedge clkin_lost_out or posedge rst_in) 
  if (rst_in == 1)
         clkfx_out_ph  = 0;
  else if (clkin_lost_out == 1'b1 ) begin
           if (locked_out == 1)
            @(negedge rst_reg[2]);
        end
  else
    if (lock_out[1] == 1 ) begin
	clkfx_out_ph = 1'b1;
	for (p = 0; p < (numerator * 2 - 1); p = p + 1) begin
	    #(period_fx);
	    if (p < remain_fx)
		#1;
	    clkfx_out_ph = !clkfx_out_ph;
	end
	if (period_fx > (period / 2)) begin
	    #(period_fx - (period / 2));
	end
    end

//
// detect_first_time_locked
//

always @(posedge locked_out)
   if (first_time_locked == 0) 
      first_time_locked <= 1;

always @(ps_overflow_out or clkin_lost_out or clkfx_lost_out or
         clkfb_lost_out or rst_in or en_status)
begin
   mem_drp[`DCM_DEFAULT_STATUS_ADDR*16] = ps_overflow_out;
   mem_drp[`DCM_DEFAULT_STATUS_ADDR*16 + 1] = clkin_lost_out;
   mem_drp[`DCM_DEFAULT_STATUS_ADDR*16 + 2] = clkfx_lost_out;
   mem_drp[`DCM_DEFAULT_STATUS_ADDR*16 + 3] = clkfb_lost_out;
  
  if ( en_status != 1) 
   begin
     do_out0 = 1'b0;
     do_out1 = 1'b0;
     do_out2 = 1'b0;
     do_out3 = 1'b0;
  end
  else
  begin
     do_out0 = ps_overflow_out;
     do_out1 = clkin_lost_out;
     do_out2 = clkfx_lost_out;
     do_out3 = clkfb_lost_out;
  end
end

//always @(posedge rst_in or posedge locked_out)
always @(posedge rst_in or posedge LOCKED)
  if (rst_in == 1)
      en_status <= 0;
   else
      en_status <= 1;

//
// drp process
//

always @(posedge dclk_in or posedge gsr_in)
begin
  if (gsr_in == 1) begin
       drp_lock <= 0;
       ps_in_drp <= 0;
       ps_kick_off_cmd <= 0;
    end 
  else begin
    valid_daddr = addr_is_valid(daddr_in);
    if (DEN == 1) begin 
        if (drp_lock == 1)
        begin
          $display(" Warning : Please wait for DRDY signal before next read/write operation through DRP. ");
          $finish;
        end
        else 
          drp_lock <= 1;
       
        if (DWE == 1) begin
            if (valid_daddr) begin 
              if (daddr_in == `CLKFX_MULTIPLY_ADDR) begin 
                mem_drp[((`CLKFX_MULTIPLY_ADDR*16) + 15) : (`CLKFX_MULTIPLY_ADDR*16)] <= di_in;
                clkfx_multiply_drp = di_in[4:0] + 1;
              end
              else if (daddr_in == `CLKFX_DIVIDE_ADDR) begin 
                mem_drp[((`CLKFX_DIVIDE_ADDR*16) + 15) : (`CLKFX_DIVIDE_ADDR*16)] <= di_in;
                clkfx_divide_drp = di_in[4:0] + 1;
              end
              else if (daddr_in == `PHASE_SHIFT_ADDR) begin 
                mem_drp[((`PHASE_SHIFT_ADDR*16) + 15) : (`PHASE_SHIFT_ADDR*16)] <= di_in;
                ps_drp = di_in[10:0];
              end
              else if (daddr_in == `PHASE_SHIFT_KICK_OFF_ADDR) begin 
                if (ps_kick_off_cmd == 0) begin
                  ps_kick_off_cmd <= 1;
                  ps_in_drp <= ps_drp;
                    if (ps_in < ps_drp) 
                      inc_dec <= 1;
                    else if (ps_in > ps_drp) 
                      inc_dec <= 0;
                 end
             end
           end
         end
    end
    if (ps_drp_lock == 1)  
            if (ps_kick_off_cmd == 1)
               ps_kick_off_cmd <= 0;

    if ( drp_lock == 1) 
          drp_lock <= 0;
  end
end

function addr_is_valid;
input [6:0] daddr_funcin;
begin
  addr_is_valid = 1;
  for (i=0; i<=6; i=i+1)
    if ( daddr_funcin[i] != 0 && daddr_funcin[i] != 1)
       addr_is_valid = 0;
end
endfunction

// end process drp;

//
//   drive_drdy_out  process
//

always @(drp_lock or dclk_in or gsr_in)
    @(negedge drp_lock)
      @(posedge dclk_in) begin
         if (gsr_in == 0)
            drdy_out = 1;
         @(posedge dclk_in)
         drdy_out = 0;
    end

//
// generate all output signal
//

always @(clk0_out) begin
    CLK0 <= #(clkout_delay) clk0_out;
    CLK90 <= #(clkout_delay + period / 4) clk0_out;
end

always @( clk0_out or posedge rst_in )
  if (rst_in ) begin
     CLK180 <= 0;
     CLK270 <= 0;
  end
  else begin
      CLK180 <= #(clkout_delay + period / 2) clk0_out;
      CLK270 <= #(clkout_delay + period / 4) ~clk0_out;
  end

always @(clk2x_out) 
    CLK2X <= #(clkout_delay) clk2x_out;

always @( clk2x_out or posedge rst_in ) 
  if (rst_in )
     CLK2X180 <= 0;
  else
    CLK2X180 <= #(clkout_delay) ~clk2x_out ;


always @(clkdv_out) 
    CLKDV <= #(clkout_delay) clkdv_out;

always @(clkfx_out or posedge rst_in)
 if (rst_in )
       CLKFX <= 0;
 else
    CLKFX <= #(clkout_delay) clkfx_out;

always @( clkfx_out or posedge rst_in or first_time_locked or locked_out) begin
  if (rst_in | ~first_time_locked)
     CLKFX180 <= 0;
  else
    CLKFX180 <=  #(clkout_delay) ~clkfx_out;
end


endmodule

//////////////////////////////////////////////////////

module dcm_adv_clock_divide_by_2 (clock, clock_type, clock_out, rst);
input clock;
input clock_type;
input rst;
output clock_out;

reg clock_out;
reg clock_div2;
reg [2:0] rst_reg;

initial begin
    clock_out = 1'b0;
    clock_div2 = 1'b0;
end

always @(posedge clock)
    clock_div2 <= ~clock_div2;

always @(posedge clock) begin
    rst_reg[0] <= rst;
    rst_reg[1] <= rst_reg[0] & rst;
    rst_reg[2] <= rst_reg[1] & rst_reg[0] & rst;
end

always @(clock_div2 or clock or rst or rst_reg) begin
    if ((clock_type == 1'b0) && (rst == 1'b0))
	clock_out = clock;
    else if ((clock_type == 1'b1) && (rst == 1'b0))
	clock_out = clock_div2;
    else if (rst == 1'b1) begin
	clock_out = 1'b0;
	@(negedge rst_reg[2]);
    end
end

endmodule

module dcm_adv_maximum_period_check (clock);
parameter clock_name = "";
parameter maximum_period = 0;
input clock;
//input rst;

time clock_edge;
time clock_period;

initial begin
    clock_edge = 0;
    clock_period = 0;
end

always @(posedge clock) begin
    clock_edge <= $time;
    clock_period <= $time - clock_edge;
//    if (clock_period > maximum_period && rst == 0) begin
    if (clock_period > maximum_period ) begin
	$display(" Warning : Input clock period of, %1.3f ns, on the %s port of instance %m exceeds allowed value of %1.3f ns at simulation time %1.3f ns.", clock_period/1000.0, clock_name, maximum_period/1000.0, $time/1000.0);
    end
end
endmodule

module dcm_adv_clock_lost (clock, enable, lost, rst);
input clock;
input enable;
input rst;
output lost;

reg lost_r, lost_f, lost;

time clock_edge;
reg [63:0] period;
reg clock_low, clock_high;
reg clock_posedge, clock_negedge;
reg clock_second_pos, clock_second_neg;

initial begin
    clock_edge = 0;
    clock_high = 0;
    clock_low = 0;
    lost_r = 0;
    lost_f = 0;
    period = 0;
    clock_posedge = 0;
    clock_negedge = 0;
    clock_second_pos = 0;
    clock_second_neg = 0;
end

always @(posedge clock or posedge rst)
  if (rst) begin
    period <= 0;
    clock_second_pos <= 0;
  end
  else begin
    clock_edge <= $time;
    clock_second_pos <= 1;
    if (period != 0 && (($time - clock_edge) <= (1.5 * period)))
        period <= $time - clock_edge;
    else if (period != 0 && (($time - clock_edge) > (1.5 * period)))
        period <= 0;
    else if ((period == 0) && (clock_edge != 0) && clock_second_pos == 1)
        period <= $time - clock_edge;
  end

always @(posedge clock or posedge rst)
  if (rst) 
    lost_r <= 0;
  else 
  if (enable == 1 && clock_second_pos == 1) begin
      #1;
      if ( period != 0)
         lost_r <= 0;
      #((period * 9.1) / 10)
      if ((clock_low != 1'b1) && (clock_posedge != 1'b1) && rst == 0)
        lost_r <= 1;
    end

always @(negedge clock or posedge rst)
  if (rst==1) begin
     lost_f <= 0;
     clock_second_neg <= 0;
   end
   else begin
     clock_second_neg <= 1;
     if (enable == 1 && clock_second_neg == 1) begin
      if ( period != 0)
        lost_f <= 0;
      #((period * 9.1) / 10)
      if ((clock_high != 1'b1) && (clock_negedge != 1'b1) && rst == 0)
        lost_f <= 1;
      end
  end

always @( lost_r or  lost_f or enable)
  if (enable == 1) 
         lost = lost_r | lost_f;
  else
        lost = 0;

always @(posedge clock or negedge clock or posedge rst)
  if (rst==1) begin
           clock_low   <= 1'b0;
           clock_high  <= 1'b0;
           clock_posedge  <= 1'b0;
           clock_negedge <= 1'b0;
  end
  else 
    if (clock ==1) begin
           clock_low   <= 1'b0;
           clock_high  <= 1'b1;
           clock_posedge  <= 1'b0;
           clock_negedge <= 1'b1;
    end
    else if (clock == 0) begin
           clock_low   <= 1'b1;
           clock_high  <= 1'b0;
           clock_posedge  <= 1'b1;
           clock_negedge <= 1'b0;
    end

endmodule
