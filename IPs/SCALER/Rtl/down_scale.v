//*****************************************
// module name : down_scale.v
// by  : Brother
// date: 2006-7-4
//*****************************************
`timescale 1ns/10ps

module down_scale(
    clk,
    rstb,
    div0,
    div1,
    rate_calc,
    point_a0,
    point_a1,
    point_r0,
    point_r1,
    point_g0,
    point_g1,
    point_b0,
    point_b1,
    down_cmd,
    down_enable,
    div_end,
    result_a,
    result_r,
    result_g,
    result_b);

input        clk;
input        rstb;
input[10:0]  div0;
input[10:0]  div1;
input        rate_calc;
input[12:0]  point_a0;
input[12:0]  point_a1;
input[12:0]  point_r0;
input[12:0]  point_r1;
input[12:0]  point_g0;
input[12:0]  point_g1;
input[12:0]  point_b0;
input[12:0]  point_b1;
input 		 down_cmd;
input        down_enable;
output 		 div_end;
output[16:0] result_a;
output[16:0] result_r;
output[16:0] result_g;
output[16:0] result_b;

wire[16:0]	 result_a;
wire[16:0]	 result_r;
wire[16:0]	 result_g;
wire[16:0]	 result_b;

//reg			 down_ready;
/*
reg[23:0] a;
reg[23:0] r;
reg[23:0] g;
reg[23:0] b;
*/
wire        divend_a;
wire        divend_r;
wire        divend_g;
wire        divend_b;


wire[23:0]   q_a;
wire[23:0]   q_r;
wire[23:0]   q_g;
wire[23:0]   q_b;

wire[23:0]   dividend_a;
wire[23:0]   dividend_r;
wire[23:0]   dividend_g;
wire[23:0]   dividend_b;

wire[23:0]   divisor;
wire[23:0]   divisor0;
wire[23:0]   divisor1;

wire[ 3:0]   q_hbit;

reg          l_down_cmd;
// ============================================
// h(v)rate 계산일때 몫을 18bit로 한다. 
// q_hbit=8, 소수점은 12번bit와 11번bit 사이
// divisor에 6'd0을 붙여준다
// 몫을 [11:0]취한다
//
// pixel 계산일때는 몫을 16bit로 한다. 
// q_hbit=7, 소수점은 9번bit와 8번bit사이
// divisor에 7'd0을 붙여준다
// 몫을 
// ============================================

assign diven0 = down_enable;
assign diven1 = (rate_calc) ? 1'b0 : down_enable;
assign q_hbit = (rate_calc) ? 4'd8 : 4'd7;

assign divisor  = {div0,7'd0};
assign divisor0 = (rate_calc) ? {div0,6'd0} : {div0,7'd0}; 
assign divisor1 = (rate_calc) ? {div1,6'd0} : {div1,7'd0};

assign dividend_a = point_a0+point_a1;
assign dividend_r = point_r0+point_r1;
assign dividend_g = point_g0+point_g1;
assign dividend_b = point_b0+point_b1;


assign result_a = (l_down_cmd) ? q_a : dividend_a;
assign result_r = (l_down_cmd) ? q_r : dividend_r;
assign result_g = (l_down_cmd) ? q_g : dividend_g;
assign result_b = (l_down_cmd) ? q_b : dividend_b;

assign div_end = (rate_calc) ? divend_a & divend_r :
                               divend_a & divend_r & divend_g & divend_b;

always @(posedge clk or negedge rstb)
begin
    if(!rstb) begin
        l_down_cmd<=0;
    end
    else begin
        if(down_enable)
            l_down_cmd<=down_cmd;
        else if(div_end)
            l_down_cmd<=0;
    end
end
divider U0_divider
(
    .clk        (clk        ),
    .rstb       (rstb       ),

    .diven      (diven0     ),
    .dividend   (dividend_a ),
    .divisor    (divisor0   ),
    .q_hbit     (q_hbit     ),

    .divend     (divend_a   ),
    .q          (q_a        )
);
divider U1_divider
(
    .clk        (clk        ),
    .rstb       (rstb       ),

    .diven      (diven0     ),
    .dividend   (dividend_r ),
    .divisor    (divisor1   ),
    .q_hbit     (q_hbit     ),

    .divend     (divend_r   ),
    .q          (q_r        )
);
divider U2_divider
(
    .clk        (clk        ),
    .rstb       (rstb       ),

    .diven      (diven1     ),
    .dividend   (dividend_g ),
    .divisor    (divisor    ),
    .q_hbit     (4'd7       ),

    .divend     (divend_g   ),
    .q          (q_g        )
);
divider U3_divider
(
    .clk        (clk        ),
    .rstb       (rstb       ),

    .diven      (diven1     ),
    .dividend   (dividend_b ),
    .divisor    (divisor    ),
    .q_hbit     (4'd7       ),

    .divend     (divend_b   ),
    .q          (q_b        )
);

/*
always @(posedge clk or negedge rstb)
begin
    if(!rstb) begin
        down_ready<=1;
        a<=0;
        r<=0;
        g<=0;
        b<=0;
    end
    else begin
        if(down_enable) begin
            down_ready<=1'b0;
        end
        else begin
            if(down_cmd | rate_calc) begin
                if(div_end) begin
                    down_ready<=1'b1;
                    a<=q_an
                    r<=q_r;
                    g<=q_g;
                    b<=q_b;
                end
            end
            else down_ready<=1'b1;
        end
    end
end
*/
endmodule
