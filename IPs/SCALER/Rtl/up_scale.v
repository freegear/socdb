//*****************************************
// module name : up_scale.v
// by  : Brother
// date: 2006-7-4
//*****************************************
`timescale 1ns/10ps

//  ============================================
//          up_scale			
//          ÀÓ½Ã test¿ë 
//          °ö¼À±â ºÙ¿©¼­ °íÄ¡¼À
//  ============================================
module up_scale(
    clk,
    rstb,
    mul,
    point_a0,
    point_a1,
    point_r0,
    point_r1,
    point_g0,
    point_g1,
    point_b0,
    point_b1,
    up_enable,
    up_ready,
    result_a,
    result_r,
    result_g,
    result_b);

input 		 clk;
input 		 rstb;
input [10:0] mul;
input [ 7:0] point_a0;
input [ 7:0] point_a1;
input [ 7:0] point_r0;
input [ 7:0] point_r1;
input [ 7:0] point_g0;
input [ 7:0] point_g1;
input [ 7:0] point_b0;
input [ 7:0] point_b1;
input        up_enable;

output[ 7:0] result_a;
output[ 7:0] result_r;
output[ 7:0] result_g;
output[ 7:0] result_b;

output 		 up_ready;

reg[7:0]  	 result_a;
reg[7:0]  	 result_r;
reg[7:0]  	 result_g;
reg[7:0]  	 result_b;

reg			 not_ready;
wire[8:0]	 slope_a;
wire[8:0]	 slope_r;
wire[8:0]	 slope_g;
wire[8:0]	 slope_b;

wire[8:0]	 s_a;
wire[8:0]	 s_r;
wire[8:0]	 s_g;
wire[8:0]	 s_b;

assign slope_a = point_a1-point_a0;
assign slope_r = point_r1-point_r0;
assign slope_g = point_g1-point_g0;
assign slope_b = point_b1-point_b0;

wire[8:0] t_a;
wire[8:0] t_r;
wire[8:0] t_g;
wire[8:0] t_b;

assign t_a = (~slope_a)+1;
assign t_r = (~slope_r)+1;
assign t_g = (~slope_g)+1;
assign t_b = (~slope_b)+1;

assign s_a = (slope_a[8]) ? t_a : slope_a;
assign s_r = (slope_r[8]) ? t_r : slope_r;
assign s_g = (slope_g[8]) ? t_g : slope_g;
assign s_b = (slope_b[8]) ? t_b : slope_b;

/*
wire[20:0] calc_a;
wire[20:0] calc_r;
wire[20:0] calc_g;
wire[20:0] calc_b;
*/
wire[19:0]  a;
wire[19:0]  r;
wire[19:0]  g;
wire[19:0]  b;

//wire[10:0] t_mul;

//assign t_mul=mul[10:0];

assign a = ((s_a*mul)+512)>>11;//+0.25
assign r = ((s_r*mul)+512)>>11;//+0.25
assign g = ((s_g*mul)+512)>>11;//+0.25
assign b = ((s_b*mul)+512)>>11;//+0.25

/*
always @(posedge clk or negedge rstb)
begin
	if(!rstb) begin
		a <=0;
		r <=0;
		g <=0;
		b <=0;
	end
	else begin
		a <= ((s_a*t_mul)+512)>>11;//+0.25
		r <= ((s_r*t_mul)+512)>>11;//+0.25
		g <= ((s_g*t_mul)+512)>>11;//+0.25
		b <= ((s_b*t_mul)+512)>>11;//+0.25
	end
end
*/



/*
assign calc_a = (slope_a*mul[10:0])>>11;
assign calc_r = (slope_r*mul[10:0])>>11;
assign calc_g = (slope_g*mul[10:0])>>11;
assign calc_b = (slope_b*mul[10:0])>>11;

assign a = (slope_a[8]) ? ~calc_a[7:0]+1 : calc_a[7:0];
assign r = (slope_r[8]) ? ~calc_r[7:0]+1 : calc_r[7:0];
assign g = (slope_g[8]) ? ~calc_g[7:0]+1 : calc_g[7:0];
assign b = (slope_b[8]) ? ~calc_b[7:0]+1 : calc_b[7:0];
*/


reg not_ready_dly;


assign up_ready = ~(up_enable | not_ready | not_ready_dly);  

always @(posedge clk or negedge rstb)
begin
    if(!rstb) begin
        result_a<=0;
        result_r<=0;
        result_g<=0;
        result_b<=0;
        not_ready<=0;
        not_ready_dly<=0;
    end
    else begin
        not_ready_dly<=not_ready;
        if(up_enable) begin
        	if(slope_a[8]) result_a<=point_a0-a;
        	else result_a<=point_a0+a;

        	if(slope_r[8]) result_r<=point_r0-r;
        	else result_r<=point_r0+r;

        	if(slope_g[8]) result_g<=point_g0-g;
        	else result_g<=point_g0+g;

        	if(slope_b[8]) result_b<=point_b0-b;
        	else result_b<=point_b0+b;
        	not_ready<=1'b1;
        end
        else not_ready<=0;
        

    end
end


endmodule

