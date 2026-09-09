// $Header: /cvsroot/anonymous/or1k/orp/orp_soc/lib/xilinx/unisims/CLKDLL.v,v 1.1 2002/03/28 20:15:25 lampret Exp $

/*

FUNCTION	: Clock Delay Locked Loop

*/

`timescale  1 ps / 1 ps

module CLKDLL (CLK0, CLK90, CLK180, CLK270, CLK2X, CLKDV, LOCKED,
	       CLKIN, CLKFB, RST);

parameter CLKDV_DIVIDE = 2.0;
parameter DUTY_CYCLE_CORRECTION = "TRUE";
parameter MAXPERCLKIN = 100000;

input  CLKIN, CLKFB, RST;
output CLK0, CLK90, CLK180, CLK270, CLK2X, CLKDV, LOCKED;
reg    CLK0, CLK90, CLK180, CLK270, CLK2X, CLKDV;

reg    lock_period, lock_delay, lock_clkin, lock_clkfb;
reg    delay_found;
time   clkin_edge[0:1];
time   delay_edge[0:1];
time   period, delay, delay_fb;

wire   clkin_in, clkfb_in, rst_in;
reg    locked_out;
wire   clk0_int, clk2x_int, clk4x_int, clkdv_int;
wire   clk2x_2575, clk2x_5050;

reg    clkin_window, clkfb_window;
reg    clk1x, clkin_5050, clk1x_5050;
reg    clk1x_shift125, clk1x_shift250;
reg    clk2x_shift;

reg    [7:0] count3, count4, count5;
reg    [32:1] divider;
reg    [7:0] divide_type;
reg    clk1x_type;
reg    rst_1, rst_2;
reg    notifier;

initial begin
  clk1x          <= 0;
  clk1x_5050     <= 0;
  clk1x_shift125 <= 0;
  clk1x_shift250 <= 0;
  clk2x_shift    <= 0;
  clkfb_window   <= 0;
  clkin_5050     <= 0;
  clkin_edge[0]  <= 1'bx;
  clkin_edge[1]  <= 1'bx;
  clkin_window   <= 0;
  count3         <= 0;
  count4         <= 0;
  count5         <= 0;
  delay          <= 0;
  delay_fb       <= 0;
  delay_found    <= 0;
  divider        <= 0;
  lock_delay     <= 0;
  lock_period    <= 0;
  period         <= 0;

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
    4.0   : divide_type <= 'd8;
    5.0   : divide_type <= 'd10;
    8.0   : divide_type <= 'd16;
    16.0  : divide_type <= 'd32;
    default : begin
		$display("Error : CLKDV_DIVIDE = %f is not 1.5, 2.0, 2.5, 3.0, 4.0, 5.0, 8.0 or 16.0.", CLKDV_DIVIDE);
		$finish;
	      end
  endcase
end

//
// input wire delays
//
buf b_clkin (clkin_in, CLKIN);
buf b_clkfb (clkfb_in, CLKFB);
buf b_rst (rst_in, RST);
buf b_locked (LOCKED, locked_out);

//
// determine clock period
//
always @(posedge clkin_in) begin
  clkin_edge[0] <= $time;
  clkin_edge[1] <= clkin_edge[0];
  if (rst_2)
    period <= 0;
  else if (period < clkin_edge[0] - clkin_edge[1] - 100)
    period <= clkin_edge[0] - clkin_edge[1];
  else if (period > clkin_edge[0] - clkin_edge[1] + 100)
    period <= clkin_edge[0] - clkin_edge[1];
end

always @(period) begin // period changed reset everything
  clk1x          <= 0;
  clk1x_5050     <= 0;
  clk1x_shift125 <= 0;
  clk1x_shift250 <= 0;
  clk2x_shift    <= 0;
  clkin_5050     <= 0;
  delay          <= 0;
  delay_fb       <= 0;
  delay_found    <= 0;
  lock_delay     <= 0;
  lock_period    <= 0;
  if (period < clkin_edge[0] - clkin_edge[1] - 100)
    lock_period <= 0;
  else if (period > clkin_edge[0] - clkin_edge[1] + 100)
    lock_period <= 0;
  else if ((clkin_edge[0] != 1'bx) && (clkin_edge[1] != 1'bx))
    lock_period <= 1;
end

always @(posedge lock_period) begin
  if (period > MAXPERCLKIN) begin
    $display("    \$maxperiod( posedge CLKIN:%0.3f", $time/1000, "ns,  %0d", MAXPERCLKIN, " : %0.3f", period/1000, "ns );");
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
    delay = (10 * period - (delay_edge[0] - delay_edge[1])) % period;
    delay_found = 1;
  end
end

always @ (lock_period or delay_found) begin
  if (lock_period && delay_found) begin
    for (delay_fb = 0; delay_fb < delay; delay_fb = delay_fb + 1000)
      @(posedge clkin_in);
    delay_fb <= delay;
  end
end

always @ (posedge clkin_in) begin
  if (rst_2) begin
    clk1x          <= 0;
    clk1x_5050     <= 0;
    clk1x_shift125 <= 0;
    clk1x_shift250 <= 0;
    clk2x_shift    <= 0;
    clkin_5050     <= 0;
    delay          <= 0;
    delay_fb       <= 0;
    delay_found    <= 0;
    lock_delay     <= 0;
    lock_period    <= 0;
    period         <= 0;
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
assign clk2x_int = (locked_out) ? clk2x_5050 : clk2x_2575;

//
// generate the clk4x_int
//
always @(clk2x_5050) begin
  clk2x_shift <= #(period/8) clk2x_5050;
end

assign clk4x_int = locked_out & (clk2x_5050 ^ clk2x_shift);

//
// generate the clkdv_int
//
always @ (negedge rst_2) begin
  count3  <= 0;
  count4  <= 0;
  count5  <= 0;
  divider <= 0;
end

always @(posedge clk4x_int) begin
  if (count3 == 0)
    divider[3] <= divider[3] + 1;
  count3 <= (count3 + 1) % 3;
end

always @(posedge clk4x_int) begin
  if (count4 == 0)
    divider[4] <= divider[4] + 1;
  count4 <= (count4 + 1) % 4;
end

always @(posedge clk4x_int) begin
  if (count5 == 0)
    divider[5] <= divider[5] + 1;
  count5 <= (count5 + 1) % 5;
end

always @(posedge divider[3]) begin
  divider[6] <= divider[6] + 1;
end

always @(posedge divider[4]) begin
  divider[8] <= divider[8] + 1;
end

always @(posedge divider[5]) begin
  divider[10] <= divider[10] + 1;
end

always @(posedge divider[8]) begin
  divider[16] <= divider[16] + 1;
end

always @(posedge divider[16]) begin
  divider[32] <= divider[32] + 1;
end

assign clkdv_int = divider[divide_type];

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

always @ (clkdv_int) begin
    CLKDV <= clkdv_int;
end

specify
	specparam CLKFBDLYLH = 0:0:0, CLKFBDLYHL = 0:0:0;
	specparam CLKINDLYLH = 0:0:0, CLKINDLYHL = 0:0:0;
	specparam RSTDLYLH = 0:0:0, RSTDLYHL = 0:0:0;
	specparam LOCKEDDLYLH = 0:0:0, LOCKEDDLYHL = 0:0:0;
	specparam PWCLKINHI = 0:0:0, PWCLKINLO = 0:0:0;
	specparam PWRSTHI = 0:0:0;
	specparam MINPERCLKIN = 10:10:10;

	(CLKIN => LOCKED) = (CLKINDLYLH + LOCKEDDLYLH, CLKINDLYHL + LOCKEDDLYHL);
	$width (posedge CLKIN, PWCLKINHI, 0, notifier);
	$width (negedge CLKIN, PWCLKINLO, 0, notifier);
	$width (posedge RST, PWRSTHI, 0, notifier);
	$period (posedge CLKIN, MINPERCLKIN, notifier);
endspecify

endmodule
