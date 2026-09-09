// $Header: /cvsroot/anonymous/or1k/orp/orp_soc/lib/xilinx/unisims/DCM.v,v 1.1 2002/03/28 20:15:26 lampret Exp $

/*

FUNCTION	: Digital Clock Manager

*/

`timescale  1 ps / 1 ps

module DCM      (CLKFB, CLKIN, DSSEN,
                 PSCLK, PSEN, PSINCDEC, RST,
                 CLK0, CLK90, CLK180, CLK270, CLK2X, CLK2X180,
                 CLKDV, CLKFX, CLKFX180, LOCKED, PSDONE, STATUS);

parameter CLK_FEEDBACK = "1X";
parameter CLKDV_DIVIDE = 2.0;
parameter CLKFX_DIVIDE = 1;
parameter CLKFX_MULTIPLY = 4;
parameter CLKOUT_PHASE_SHIFT = "NONE";
parameter DFS_FREQUENCY_MODE = "LOW";
parameter DLL_FREQUENCY_MODE = "LOW";
parameter DSS_MODE = "NONE";
parameter DUTY_CYCLE_CORRECTION = "TRUE";
parameter FACTORY_JF = 8'h00;
parameter MAXPERCLKIN = 100000;
parameter MAXPERPSCLK = 100000;
parameter PHASE_SHIFT = 0;
parameter STARTUP_WAIT = "FALSE";

input CLKFB, CLKIN, DSSEN;
input PSCLK, PSEN, PSINCDEC, RST;

output CLK0, CLK90, CLK180, CLK270, CLK2X, CLK2X180;
output CLKDV, CLKFX, CLKFX180, LOCKED, PSDONE;
output [7:0] STATUS;

reg    CLK0, CLK90, CLK180, CLK270, CLK2X, CLK2X180;
reg    CLKDV, CLKFX, CLKFX180;

reg    lock_period, lock_delay, lock_clkin, lock_clkfb;
reg    delay_found;
time   clkin_edge[0:1];
time   psclk_edge[0:1], psclk_period;
time   delay_edge[0:1];
time   period, delay, delay_fb;

reg    clkin_in, clkfb_in;
wire   psclk_in, psen_in, psincdec_in, rst_in;
reg    clklost_out, locked_out, psdone_out, psoverflow_out, pslock;
wire   clk0_int, clk4x_int, clkdv_int;
reg    clk2x_int;
wire   clk2x_2575, clk2x_5050;

reg    clkin_locked, clkin_period, clkin_div2_r, clkin_div2_f;
reg    clkin_low1, clkin_low2, clkin_high1, clkin_high2;

reg    clkin_window, clkfb_window;
reg    clk1x, clkin_5050, clk1x_5050;
reg    clk1x_shift125, clk1x_shift250;
reg    clk2x_shift;

reg    [7:0] count3, count4, count5, count7, count9, count11, count13, count15;
reg    [32:1] divider;
reg    [8:0] divide_type;
reg    [1:0] clkfb_type;
reg    clk1x_type;
reg    dll_mode_type;
reg    rst_1, rst_2;
reg    notifier;

reg    [11:0] numerator, denominator, gcd;
reg    [23:0] i, n, d;
reg    generate, clkfx_int;
time   period_fx;

reg    [9:0] ps_in;
time   clkin_delay, clkfb_delay;

initial begin
  clk1x <= 0;
  clk1x_5050 <= 0;
  clk1x_shift125 <= 0;
  clk1x_shift250 <= 0;
  clk2x_shift <= 0;
  clkfb_delay <= 0;
  clkfb_window <= 0;
  clkfx_int <= 0;
  clkin_5050 <= 0;
  clkin_delay <= 0;
  clkin_div2_f <= 0;
  clkin_div2_r <= 0;
  clkin_edge[0] <= 1'bx;
  clkin_edge[1] <= 1'bx;
  clkin_high1 <= 0;
  clkin_high2 <= 0;
  clkin_low1 <= 0;
  clkin_low2 <= 0;
  clkin_window <= 0;
  count11 <= 0;
  count13 <= 0;
  count15 <= 0;
  count3 <= 0;
  count4 <= 0;
  count5 <= 0;
  count7 <= 0;
  count9 <= 0;
  delay <= 0;
  delay_fb <= 0;
  delay_found <= 0;
  divider <= 0;
  generate <= 0;
  lock_delay <= 0;
  lock_period <= 0;
  locked_out <= 0;
  period <= 0;
  psdone_out <= 0;
  pslock <= 0;
  psoverflow_out <= 0;
  case (CLK_FEEDBACK)
    "none" : clkfb_type <= 0;
    "NONE" : clkfb_type <= 0;
    "1x" : clkfb_type <= 1;
    "1X" : clkfb_type <= 1;
    "2x"  : clkfb_type <= 2;
    "2X"  : clkfb_type <= 2;
    default : begin
		$display("Error : CLK_FEEDBACK = %s is neither NONE, 1X nor 2X.", CLK_FEEDBACK);
		$finish;
	      end
  endcase

  case (DLL_FREQUENCY_MODE)
    "high" : dll_mode_type <= 1;
    "HIGH" : dll_mode_type <= 1;
    "low"  : dll_mode_type <= 0;
    "LOW"  : dll_mode_type <= 0;
    default : begin
		$display("Error : DLL_FREQUENCY_MODE = %s is neither HIGH nor LOW.", DLL_FREQUENCY_MODE);
		$finish;
	      end
  endcase

  case (DUTY_CYCLE_CORRECTION)
    "false" : clk1x_type <= 0;
    "FALSE" : clk1x_type <= 0;
    "true"  : clk1x_type <= 1;
    "TRUE"  : clk1x_type <= 1;
    default : begin
		$display("Error : DUTY_CYCLE_CORRECTION = %s is neither TRUE nor FALSE.", DUTY_CYCLE_CORRECTION);
		$finish;
	      end
  endcase

  case (CLKDV_DIVIDE)
    1.5   : divide_type <= 'd3;
    2.0   : divide_type <= 'd4;
    2.5   : divide_type <= 'd5;
    3.0   : divide_type <= 'd6;
    3.5   : divide_type <= 'd7;
    4.0   : divide_type <= 'd8;
    4.5   : divide_type <= 'd9;
    5.0   : divide_type <= 'd10;
    5.5   : divide_type <= 'd11;
    6.0   : divide_type <= 'd12;
    6.5   : divide_type <= 'd13;
    7.0   : divide_type <= 'd14;
    7.5   : divide_type <= 'd15;
    8.0   : divide_type <= 'd16;
    9.0   : divide_type <= 'd18;
    10.0  : divide_type <= 'd20;
    11.0  : divide_type <= 'd22;
    12.0  : divide_type <= 'd24;
    13.0  : divide_type <= 'd26;
    14.0  : divide_type <= 'd28;
    15.0  : divide_type <= 'd30;
    16.0  : divide_type <= 'd32;
    default : begin
		$display("Error : CLKDV_DIVIDE = %f is not 1.5, 2.0, 2.5, 3.0, 3.5, 4.0, 4.5, 5.0, 5.5, 6.0, 6.5, 7.0, 7.5, 8.0, 9.0, 10.0, 11.0, 12.0, 13.0, 14.0, 15.0, or 16.0.", CLKDV_DIVIDE);
		$finish;
	      end
  endcase
end

//
// phase shift parameters
//

initial begin
  case (CLKOUT_PHASE_SHIFT)
    "NONE"     : ps_in <= 0;
    "none"     : ps_in <= 0;
    "FIXED"   : ps_in <= PHASE_SHIFT + 256;
    "fixed"   : ps_in <= PHASE_SHIFT + 256;
    "VARIABLE" : ps_in <= PHASE_SHIFT + 256;
    "variable" : ps_in <= PHASE_SHIFT + 256;
    default : begin
                $display("Error : CLKOUT_PHASE_SHIFT = %s is neither NONE, FIXED nor VARIABLE.", CLKOUT_PHASE_SHIFT);
                $finish;
              end
  endcase
end

always @(posedge psclk_in) begin
  if ((CLKOUT_PHASE_SHIFT == "VARIABLE") || (CLKOUT_PHASE_SHIFT == "variable"))
    if (psen_in)
      if (pslock)
	$display("Warning : Please wait for PSDONE signal before adjusting the Phase Shift.");
      else
        if (psincdec_in == 1)
          if (ps_in == 511)
            psoverflow_out <= 1;
          else begin
            ps_in <= ps_in + 1;
            psoverflow_out <= 0;
            delay_fb <= delay_fb + period * 1 / 256;
            pslock <= 1;
          end
        else
          if (ps_in == 0)
            psoverflow_out <= 1;
          else begin
            ps_in <= ps_in - 1;
            psoverflow_out <= 0;
            delay_fb <= delay_fb - period * 1 / 256;
            pslock <= 1;
          end
end

//
// determine phase shift
//
always @ (lock_period or ps_in) begin
  if (lock_period & (clkfb_type != 0)) begin
    clkin_delay <= period;
    clkfb_delay <= period * (512 - ps_in) / 256;
  end
end

always @ (posedge pslock) begin
  @(posedge CLKIN)
  @(posedge psclk_in)
    psdone_out <= 1;
  @(posedge psclk_in)
    psdone_out <= 0;
    pslock <= 0;
end

//
// fx parameters
//

initial begin
  generate = 1'b0;
  numerator = CLKFX_MULTIPLY;
  denominator = CLKFX_DIVIDE;
  gcd = 1;
  for (i = 2; i <= numerator; i = i + 1) begin
    if (((numerator % i) == 0) && ((denominator % i) == 0))
      gcd = i;
  end
  numerator = CLKFX_MULTIPLY / gcd;
  denominator = CLKFX_DIVIDE  / gcd;
end

//
// input wire delays
//
// buf b_clkin (clkin_in, CLKIN);
// buf b_clkfb (clkfb_in, CLKFB);
always @(CLKIN) begin
  clkin_in <= #clkin_delay CLKIN;
end

always @(CLKFB) begin
  clkfb_in <= #clkfb_delay CLKFB;
end

buf b_dssen (dssen_in, DSSEN);
buf b_psclk (psclk_in, PSCLK);
buf b_psen (psen_in, PSEN);
buf b_psincdec (psincdec_in, PSINCDEC);
buf b_rst (rst_in, RST);
buf b_locked (LOCKED, locked_out);
buf b_psdone (PSDONE, psdone_out);
buf b_psoverflow (STATUS[0], psoverflow_out);
buf b_clklost (STATUS[1], clklost_out);

//
// clock lost
//

always @(CLKIN) begin
    clkin_locked <= #period CLKIN;
end

always @(clkin_locked) begin
  clkin_period <= #period clkin_locked;
end

always @(posedge clkin_locked) begin
  clkin_div2_r <= ~clkin_div2_r;
end

always @(negedge clkin_period) begin
  clkin_low1 <= clkin_div2_r;
end

always @(negedge clkin_period) begin
  clkin_low2 <= clkin_low1;
end

always @(negedge clkin_locked) begin
  clkin_div2_f <= ~clkin_div2_f;
end

always @(posedge clkin_period) begin
  clkin_high1 <= clkin_div2_f;
end

always @(posedge clkin_period) begin
  clkin_high2 <= clkin_high1;
end

always @(clkin_low1 or clkin_low2 or clkin_high1 or clkin_high2) begin 
  clklost_out <= locked_out && (!(clkin_low1 ^ clkin_low2) || !(clkin_high1 ^ clkin_high2));
end

//
// determine clock period
//
always @(posedge clkin_in) begin
  clkin_edge[0] <= $time;
  clkin_edge[1] <= clkin_edge[0];
  if (rst_2)
    period <= 0;
  else if (period < clkin_edge[0] - clkin_edge[1] - 500)
    period <= clkin_edge[0] - clkin_edge[1];
  else if (period > clkin_edge[0] - clkin_edge[1] + 500)
    period <= clkin_edge[0] - clkin_edge[1];
end

always @(period) begin
  CLK0 <= 0;                    // period changed reset everything
  CLK180 <= 0;
  clk1x <= 0;
  clk1x_5050 <= 0;
  clk1x_shift125 <= 0;
  clk1x_shift250 <= 0;
  CLK270 <= 0;
  CLK2X <= 0;
  CLK2X180 <= 0;
  clk2x_shift <= 0;
  CLK90 <= 0;
  CLKDV <= 0;
  clkfb_window <= 0;
  CLKFX <= 0;
  CLKFX180 <= 0;
  clkfx_int <= 0;
  clkin_5050 <= 0;
  clkin_window <= 0;
  clklost_out <= 0;
  delay <= 0;
  delay_fb <= 0;
  delay_found <= 0;
  divider <= 0;
  generate <= 0;
  lock_clkfb <= 0;
  lock_clkin <= 0;
  lock_delay <= 0;
  lock_period <= 0;
  locked_out <= 0;
  psdone_out <= 0;
  pslock <= 0;
  psoverflow_out <= 0;
  if (period < clkin_edge[0] - clkin_edge[1] - 500)
    lock_period <= 0;
  else if (period > clkin_edge[0] - clkin_edge[1] + 500)
    lock_period <= 0;
  else if ((clkin_edge[0] != 1'bx) && (clkin_edge[1] != 1'bx))
    lock_period <= 1;
end

always @(posedge lock_period) begin
  if (period > MAXPERCLKIN) begin
    $display("    \$maxperiod( posedge CLKIN:%0.3f", $time/1000, "ns,  %0d", MAXPERCLKIN, " : %0.3f", period/1000, "ns );");
  end
end

always @(posedge psclk_in) begin
  psclk_edge[0] <= $time;
  psclk_edge[1] <= psclk_edge[0];
  psclk_period <= psclk_edge[0] - psclk_edge[1];
  if (psclk_period > MAXPERPSCLK) begin
    $display("    \$maxperiod( posedge PSCLK:%0.3f", $time/1000, "ns,  %0d", MAXPERPSCLK, " : %0.3f", period/1000, "ns );");
  end
end

//
// determine clock delay
//
always @ (lock_period or delay_found) begin
  if (lock_period && !delay_found) begin
    assign CLK0 = 0; assign CLK2X = 0;
    #period
    assign CLK0 = 1; assign CLK2X = 1;
    delay_edge[1] = $time;
    @(posedge clkfb_in)
    delay_edge[0] = $time;
    #period
    assign CLK0 = 0; assign CLK2X = 0;
    deassign CLK0; deassign CLK2X;
    #period
    delay = (10 * period - (delay_edge[0] - delay_edge[1])) % period;
    delay_found = 1;
  end
end

always @ (lock_period or delay_found) begin
  if (lock_period && delay_found) begin
    for (delay_fb = 0; delay_fb < delay; delay_fb = delay_fb + 1000)
      @(posedge clkin_in);
    delay_fb <= delay + period;
  end
end

always @ (posedge clkin_in) begin
  if (rst_2) begin
    CLK0 <= 0;
    CLK180 <= 0;
    clk1x <= 0;
    clk1x_5050 <= 0;
    clk1x_shift125 <= 0;
    clk1x_shift250 <= 0;
    CLK270 <= 0;
    CLK2X <= 0;
    CLK2X180 <= 0;
    clk2x_shift <= 0;
    CLK90 <= 0;
    CLKDV <= 0;
    clkfb_window <= 0;
    CLKFX <= 0;
    CLKFX180 <= 0;
    clkfx_int <= 0;
    clkin_5050 <= 0;
    clkin_edge[0] <= 1'bx;
    clkin_edge[1] <= 1'bx;
    clkin_window <= 0;
    clklost_out <= 0;
    count11 <= 0;
    count13 <= 0;
    count15 <= 0;
    count3 <= 0;
    count4 <= 0;
    count5 <= 0;
    count7 <= 0;
    count9 <= 0;
    delay <= 0;
    delay_fb <= 0;
    delay_found <= 0;
    divider <= 0;
    generate <= 0;
    lock_clkfb <= 0;
    lock_clkin <= 0;
    lock_delay <= 0;
    lock_period <= 0;
    locked_out <= 0;
    psdone_out <= 0;
    pslock <= 0;
    psoverflow_out <= 0;
    case (CLKOUT_PHASE_SHIFT)
      "NONE"     : ps_in <= 0;
      "none"     : ps_in <= 0;
      "FIXED"   : ps_in <= PHASE_SHIFT + 256;
      "fixed"   : ps_in <= PHASE_SHIFT + 256;
      "VARIABLE" : ps_in <= PHASE_SHIFT + 256;
      "variable" : ps_in <= PHASE_SHIFT + 256;
    endcase
  end
end

always @ (posedge clkfb_in) begin
  #0   clkfb_window = 1;
  #100 clkfb_window = 0;
end

always @ (posedge clkin_in) begin
  #0   clkin_window = 1;
  #100 clkin_window = 0;
end

always @ (posedge clkin_in) begin
  #1
  if (clkfb_window && delay_found)
    lock_clkin <= 1;
  else
    lock_clkin <= 0;
end

always @ (posedge clkfb_in) begin
  #1
  if (clkin_window && delay_found)
    lock_clkfb <= 1;
  else
    lock_clkfb <= 0;
  @ (posedge clkfb_in);
end

always @ (lock_clkin or lock_clkfb) begin
  if (lock_clkin || lock_clkfb)
    lock_delay <= 1;
  else
    lock_delay <= 0;
end

//
// generate master reset signal
//
always @ (posedge clkin_in) begin
   {rst_2,rst_1} <= {rst_1,rst_in};
end

//
// generate lock signal
//
always @ (posedge clkin_in) begin
  if ((clkfb_type == 0) & lock_period)
    locked_out <= 1;
  else
    locked_out <= lock_delay & lock_period & ~rst_2;
end

//
// generate the clk0_int
//
always @ (clkin_in) begin
  if (delay_found)
    clk1x <= #delay_fb clkin_in;
end

always @ (posedge clkin_in) begin
    clkin_5050 <= 1;
    #(period/2)
    clkin_5050 <= 0;
end

always @ (clkin_5050) begin
  if (delay_found)
    clk1x_5050 <= #delay_fb clkin_5050;
end

assign clk0_int = (clk1x_type) ? clk1x_5050 : clk1x;

//
// generate the clk2x_int
//
always @(clk1x_5050) begin
  clk1x_shift125 <= #(period/8) clk1x_5050;
  clk1x_shift250 <= #(period/4) clk1x_5050;
end

assign clk2x_2575 = clk1x_5050 & ~clk1x_shift250;
assign clk2x_5050 = clk1x_5050 ^ clk1x_shift250;

always @(clk2x_5050 or clk2x_2575) begin
  if (locked_out)
    clk2x_int = clk2x_5050;
  else
    clk2x_int = clk2x_2575;
end

//
// generate the clk4x_int
//
always @(clk2x_5050) begin
  clk2x_shift <= #(period/8) clk2x_5050;
end

assign clk4x_int = clk2x_5050 ^ clk2x_shift;

//
// generate the clkdv_int
//

always @(posedge clk4x_int) begin
  if (dll_mode_type) begin
    if (count3 == 0)
      divider[3] <= 1;
    if (count3 == 2)
      divider[3] <= 0;
  end
  else
    if (count3 == 0 || count3 == 3)
      divider[3] <= divider[3] + 1;
  count3 <= (count3 + 1) % 6;
end

always @(posedge clk4x_int) begin
  if (count4 == 0)
    divider[4] <= divider[4] + 1;
  count4 <= (count4 + 1) % 4;
end

always @(posedge clk4x_int) begin
  if (dll_mode_type) begin
    if (count5 == 0)
      divider[5] <= 1;
    if (count5 == 4)
      divider[5] <= 0;
  end
  else
    if (count5 == 0 || count5 == 5)
      divider[5] <= divider[5] + 1;
  count5 <= (count5 + 1) % 10;
end

always @(posedge divider[3]) begin
  divider[6] <= divider[6] + 1;
end

always @(posedge clk4x_int) begin
  if (dll_mode_type) begin
    if (count7 == 0)
      divider[7] <= 1;
    if (count7 == 6)
      divider[7] <= 0;
  end
  else
    if (count7 == 0 || count7 == 7)
      divider[7] <= divider[7] + 1;
  count7 <= (count7 + 1) % 14;
end

always @(posedge divider[4]) begin
  divider[8] <= divider[8] + 1;
end

always @(posedge clk4x_int) begin
  if (dll_mode_type) begin
    if (count9 == 0)
      divider[9] <= 1;
    if (count9 == 8)
      divider[9] <= 0;
  end
  else
    if (count9 == 0 || count9 == 9)
      divider[9] <= divider[9] + 1;
  count9 <= (count9 + 1) % 18;
end

always @(posedge divider[5]) begin
  divider[10] <= divider[10] + 1;
end

always @(posedge clk4x_int) begin
  if (dll_mode_type) begin
    if (count11 == 0)
      divider[11] <= 1;
    if (count11 == 10)
      divider[11] <= 0;
  end
  else
    if (count11 == 0 || count11 == 11)
      divider[11] <= divider[11] + 1;
  count11 <= (count11 + 1) % 22;
end

always @(posedge divider[6]) begin
  divider[12] <= divider[12] + 1;
end

always @(posedge clk4x_int) begin
  if (dll_mode_type) begin
    if (count13 == 0)
      divider[13] <= 1;
    if (count13 == 12)
      divider[13] <= 0;
  end
  else
    if (count13 == 0 || count13 == 13)
      divider[13] <= divider[13] + 1;
  count13 <= (count13 + 1) % 26;
end

always @(posedge divider[7]) begin
  divider[14] <= divider[14] + 1;
end

always @(posedge clk4x_int) begin
  if (dll_mode_type) begin
    if (count15 == 0)
      divider[15] <= 1;
    if (count15 == 14)
      divider[15] <= 0;
  end
  else
    if (count15 == 0 || count15 == 15)
      divider[15] <= divider[15] + 1;
  count15 <= (count15 + 1) % 30;
end

always @(posedge divider[8]) begin
  divider[16] <= divider[16] + 1;
end

always @(posedge divider[9]) begin
  divider[18] <= divider[18] + 1;
end

always @(posedge divider[10]) begin
  divider[20] <= divider[20] + 1;
end

always @(posedge divider[11]) begin
  divider[22] <= divider[22] + 1;
end

always @(posedge divider[12]) begin
  divider[24] <= divider[24] + 1;
end

always @(posedge divider[13]) begin
  divider[26] <= divider[26] + 1;
end

always @(posedge divider[14]) begin
  divider[28] <= divider[28] + 1;
end

always @(posedge divider[15]) begin
  divider[30] <= divider[30] + 1;
end

always @(posedge divider[16]) begin
  divider[32] <= divider[32] + 1;
end

assign clkdv_int = divider[divide_type];

//
// generate fx output signal
//

always @(locked_out) begin
  if (locked_out) begin
    period_fx = period * denominator / numerator;
    while (period > 0) begin
      generate = !generate;
      for (n = 1; n <= denominator; n = n + 1) begin
        #(period);
      end
    end
  end
end

always @(generate) begin
  if (period_fx > 0) begin
    for (d = 1; d < numerator; d = d + 1) begin
      clkfx_int <= 1;
      #(period_fx/2);
      clkfx_int <= 0;
      #(period_fx/2);
    end
    clkfx_int <= 1;
    #(period_fx/2);
    clkfx_int <= 0;
  end
end

//
// generate all output signal
//
always @ (clk0_int) begin
    CLK0 <= clk0_int;
end

always @ (clk0_int) begin
    CLK90 <= #(period/4) clk0_int;
end

always @ (clk0_int) begin
    CLK180 <= #(period/2) clk0_int;
end

always @ (clk0_int) begin
    CLK270 <= #(3*period/4) clk0_int;
end

always @ (clk2x_int) begin
    CLK2X <= clk2x_int;
end

always @ (clk2x_int) begin
    CLK2X180 <= #(period/4) clk2x_int;
end

always @ (clkdv_int) begin
  if (locked_out)
    CLKDV <= #(period) clkdv_int;
end

always @ (clkfx_int) begin
    CLKFX <= #(delay_fb) clkfx_int;
end

always @ (clkfx_int) begin
    CLKFX180 <= #(delay_fb + period_fx/2) clkfx_int;
end

specify
	specparam CLKFBDLYLH = 0:0:0, CLKFBDLYHL = 0:0:0;
	specparam CLKINDLYLH = 0:0:0, CLKINDLYHL = 0:0:0;
	specparam DSSENDLYLH = 0:0:0, DSSENDLYHL = 0:0:0;
	specparam PSCLKDLYLH = 0:0:0, PSCLKDLYHL = 0:0:0;
	specparam PSENDLYLH = 0:0:0, PSENDLYHL = 0:0:0;
	specparam PSINCDECDLYLH = 0:0:0, PSINCDECDLYHL = 0:0:0;
	specparam RSTDLYLH = 0:0:0, RSTDLYHL = 0:0:0;
	specparam LOCKEDDLYLH = 0:0:0, LOCKEDDLYHL = 0:0:0;
	specparam PSDONEDLYLH = 0:0:0, PSDONEDLYHL = 0:0:0;
	specparam STATUS0DLYLH = 0:0:0, STATUS0DLYHL = 0:0:0;
	specparam STATUS1DLYLH = 0:0:0, STATUS1DLYHL = 0:0:0;
	specparam STATUS2DLYLH = 0:0:0, STATUS2DLYHL = 0:0:0;
	specparam STATUS3DLYLH = 0:0:0, STATUS3DLYHL = 0:0:0;
	specparam STATUS4DLYLH = 0:0:0, STATUS4DLYHL = 0:0:0;
	specparam STATUS5DLYLH = 0:0:0, STATUS5DLYHL = 0:0:0;
	specparam STATUS6DLYLH = 0:0:0, STATUS6DLYHL = 0:0:0;
	specparam STATUS7DLYLH = 0:0:0, STATUS7DLYHL = 0:0:0;

	specparam PWCLKINHI = 0:0:0, PWCLKINLO = 0:0:0;
	specparam PWPSCLKHI = 0:0:0, PWPSCLKLO = 0:0:0;
	specparam PWRSTHI = 0:0:0;
	specparam MINPERCLKIN = 10:10:10;
	specparam MINPERPSCLK = 10:10:10;

	specparam SUPSENHIPSCLK = 0:0:0, SUPSENLOPSCLK = 0:0:0;
	specparam HOLDPSENHIPSCLK = 0:0:0, HOLDPSENLOPSCLK = 0:0:0;
	specparam SUPSINCDECHIPSCLK = 0:0:0, SUPSINCDECLOPSCLK = 0:0:0;
	specparam HOLDPSINCDECHIPSCLK = 0:0:0, HOLDPSINCDECLOPSCLK = 0:0:0;

	(CLKIN => LOCKED) = (CLKINDLYLH + LOCKEDDLYLH, CLKINDLYHL + LOCKEDDLYHL);

	$setup (posedge PSEN, posedge PSCLK, SUPSENHIPSCLK, notifier);
	$setup (negedge PSEN, posedge PSCLK, SUPSENLOPSCLK, notifier);
	$hold (posedge PSCLK, posedge PSEN, HOLDPSENHIPSCLK, notifier);
	$hold (posedge PSCLK, negedge PSEN, HOLDPSENLOPSCLK, notifier);
	$setup (posedge PSINCDEC, posedge PSCLK, SUPSINCDECHIPSCLK, notifier);
	$setup (negedge PSINCDEC, posedge PSCLK, SUPSINCDECLOPSCLK, notifier);
	$hold (posedge PSCLK, posedge PSINCDEC, HOLDPSINCDECHIPSCLK, notifier);
	$hold (posedge PSCLK, negedge PSINCDEC, HOLDPSINCDECLOPSCLK, notifier);

	$period (posedge CLKIN, MINPERCLKIN, notifier);
	$period (posedge PSCLK, MINPERCLKIN, notifier);
	$width (posedge CLKIN, PWCLKINHI, 0, notifier);
	$width (negedge CLKIN, PWCLKINLO, 0, notifier);
	$width (posedge PSCLK, PWPSCLKHI, 0, notifier);
	$width (negedge PSCLK, PWPSCLKLO, 0, notifier);
	$width (posedge RST, PWRSTHI, 0, notifier);
endspecify

endmodule
