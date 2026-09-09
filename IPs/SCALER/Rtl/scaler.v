//*****************************************
// module name : scaler.v
// by  : Brother
// date: 2006-6-29
//*****************************************

`timescale 1ns/10ps

module scaler(
    clk,
    rstb,
    // from reg_block
    start,
    src_width,
    src_height,
    new_width,
    new_height,
    width,
    height,
    // from read_mem block:
    buf_a,
    buf_r,
    buf_g,
    buf_b,
    end_fill,
    read_busy,
    // from write_mem
    pause,
    // to read memory
    rd_cmd,
    rd_num,
    fill_buf,
    rd_pix_num,
    // to write memory
    wr_buf_en,
    st_init,
    t_init,
    t_last,
    last_width,
    scale_end,
    wr_cmd,
    h_new_pix_num,
    v_new_pix_num,
    result_pixel
    );

input clk;
input rstb;
//from reg_block
input start;
input[11:0] src_width;
input[11:0] src_height;
input[11:0] new_width;
input[11:0] new_height;
input[11:0] width;
input[11:0] height;
//from read_mem block
input[95:0] buf_a;
input[95:0] buf_r;
input[95:0] buf_g;
input[95:0] buf_b;
input       end_fill;
input       read_busy;
//from write_mem block
input       pause;

//to read memory
output[ 2:0] rd_cmd;
output[ 2:0] rd_num;
output       fill_buf;
output[22:0] rd_pix_num;
//to write memory
output       wr_buf_en;
output       st_init;
output       t_init;
output       t_last;
output       last_width;
output       scale_end;
output[ 1:0] wr_cmd;
output[11:0] h_new_pix_num;
output[22:0] v_new_pix_num;
output[31:0] result_pixel;


//state define
parameter IDLE     = 11'b00000000001;
parameter INIT     = 11'b00000000010;
parameter UU_HUP   = 11'b00000000100;
parameter UU_VUP   = 11'b00000001000;
parameter DU_HDOWN = 11'b00000010000;
parameter DU_VUP   = 11'b00000100000;
parameter UD_VDOWN = 11'b00001000000;
parameter UD_HUP   = 11'b00010000000;
parameter DD_VDOWN = 11'b00100000000;
parameter DD_HDOWN = 11'b01000000000;
parameter ST_WAIT  = 11'b10000000000;

//


reg[10:0] cs;
reg[10:0] ns;
reg[10:0] before_state;

wire[ 7:0] in_buf_a[0:11];
wire[ 7:0] in_buf_r[0:11];
wire[ 7:0] in_buf_g[0:11];
wire[ 7:0] in_buf_b[0:11];


reg[12:0] cal_buf_a[4:0];
reg[12:0] cal_buf_r[4:0];
reg[12:0] cal_buf_g[4:0];
reg[12:0] cal_buf_b[4:0];

reg[12:0] temp_a;
reg[12:0] temp_r;
reg[12:0] temp_g;
reg[12:0] temp_b;


wire[ 7:0] result_a;
wire[ 7:0] result_r;
wire[ 7:0] result_g;
wire[ 7:0] result_b;

wire[16:0] down_a;
wire[16:0] down_r;
wire[16:0] down_g;
wire[16:0] down_b;

reg[12:0] point_a0;
reg[12:0] point_a1;
reg[12:0] point_a2;
reg[12:0] point_a3;
reg[12:0] point_a4;
reg[12:0] point_a5;
reg[12:0] point_a6;
reg[12:0] point_a7;

reg[12:0] point_r0;
reg[12:0] point_r1;
reg[12:0] point_r2;
reg[12:0] point_r3;
reg[12:0] point_r4;
reg[12:0] point_r5;
reg[12:0] point_r6;
reg[12:0] point_r7;

reg[12:0] point_g0;
reg[12:0] point_g1;
reg[12:0] point_g2;
reg[12:0] point_g3;
reg[12:0] point_g4;
reg[12:0] point_g5;
reg[12:0] point_g6;
reg[12:0] point_g7;

reg[12:0] point_b0;
reg[12:0] point_b1;
reg[12:0] point_b2;
reg[12:0] point_b3;
reg[12:0] point_b4;
reg[12:0] point_b5;
reg[12:0] point_b6;
reg[12:0] point_b7;

reg[12:0] point0_a;
reg[12:0] point1_a;
reg[12:0] point0_r;
reg[12:0] point1_r;
reg[12:0] point0_g;
reg[12:0] point1_g;
reg[12:0] point0_b;
reg[12:0] point1_b;

reg[11:0] h_new_pix_num;
reg[22:0] v_new_pix_num;

reg[11:0] h_new_pix_base;
reg[22:0] v_new_pix_base;

reg[11:0] rd_remain;
//reg[11:0] rd_remain_dly;

reg[16:0] h_rate;
reg[16:0] v_rate;

reg[22:0] h_rate_cnt;
reg[22:0] h_rate_base;
reg[22:0] v_rate_cnt;
reg[22:0] v_rate_base;

reg[11:0] h_comp_val;
reg[11:0] v_comp_val;

reg[2:0] h_seq_cnt;
reg[2:0] v_seq_cnt;
//reg[2:0] seq_comp_val;
reg[11:0] width_cnt;
reg[11:0] height_cnt;
reg[11:0] width_cnt1;
reg[11:0] height_cnt1;
reg[11:0] v_cnt;
reg[11:0] remain_height;
reg[11:0] div_num_cnt;
reg[11:0] hdiv_num_cnt;
reg[11:0] last_remain;
reg[11:0] remain_width;
reg[11:0] h_div;

//*** to read memory
reg[2:0] rd_cmd;
reg[2:0] rd_num;
reg fill;
reg fill_dly;
reg w_buf_en;
reg[11:0] rd_h_pix_num;
reg[22:0] rd_v_pix_num;
reg[22:0] l_rd_v_pix_num;
reg[22:0] rd_v_pix_num_base;
//*** to read memory
//

reg      t_last;
reg      last_width;
reg      t_init;
reg      init_en;

reg[3:0] h_addr0;
reg[3:0] h_addr1;

reg[3:0] v_addr0;
reg[3:0] v_addr1;

reg[15:0] mul;
reg[15:0] div;

reg[ 2:0] down_num;

reg first_row;
reg down_cmd;
reg dn_enable;
reg dn_enable_dly;
reg down_enable;
reg up_enable;
reg dn_ready;

wire down_ready;

reg up_ready_dly;
reg up_ready_dly1;

wire up_ready;

reg uu_hup;
reg uu_vup;
reg du_hdown;
reg du_vup;
reg ud_hup;
reg ud_vdown;
reg dd_vdown;
reg dd_hdown;

reg src_enable;
reg src_enable_dly;
reg not_calc;
reg rd_en;

reg go_idle;
reg go_wait;

wire no_hresize;
wire no_vresize;

wire start;
wire go_uu_hup;
wire go_du_vup;
wire go_du_hdown;
wire go_ud_vdown;
wire go_ud_hup;
wire go_dd_vdown;
wire r_uu_hup;
wire r_uu_vup;
wire r_du_vup;
wire r_du_hdown;
wire r_ud_vdown;
wire r_ud_hup;
wire r_dd_vdown;
wire[22:0] new_pix_num;
wire[11:0] remain;

reg [1:0] vcnt;
wire[3:0] num;
wire[3:0] addr;
wire[3:0] b_addr;  // in buf addr;
wire down_end;
reg  down_end_dly;

reg[10:0] div0;
reg[10:0] div1;

//reg     remain_en;


up_scale U1_up(
    .clk        (clk          ),
    .rstb       (rstb         ),
    .mul        (mul[10:0]    ),
    .point_a0   (point_a0[7:0]),
    .point_a1   (point_a1[7:0]),
    .point_r0   (point_r0[7:0]),
    .point_r1   (point_r1[7:0]),
    .point_g0   (point_g0[7:0]),
    .point_g1   (point_g1[7:0]),
    .point_b0   (point_b0[7:0]),
    .point_b1   (point_b1[7:0]),
    .up_enable  (up_enable    ),
    .up_ready   (up_ready     ),
    .result_a   (result_a     ),
    .result_r   (result_r     ),
    .result_g   (result_g     ),
    .result_b	(result_b     ));

down_scale U1_down(
    .clk	    (clk	    ),
    .rstb	    (rstb	    ),
    .div0	    (div0	    ),
    .div1       (div1       ),
    .rate_calc  (rate_calc  ),
    .point_a0	(point0_a	),
    .point_a1	(point1_a	),
    .point_r0	(point0_r	),
    .point_r1	(point1_r	),
    .point_g0	(point0_g	),
    .point_g1	(point1_g	),
    .point_b0	(point0_b	),
    .point_b1	(point1_b	),
    .down_cmd	(down_cmd	),
    .down_enable(down_enable),
    .div_end	(down_end	),
    .result_a	(down_a	    ),
    .result_r	(down_r	    ),
    .result_g	(down_g 	),
    .result_b	(down_b     ));

assign remain =rd_remain-3 ;
assign st_init = (cs==INIT) ? 1'b1 : 1'b0;
assign new_pix_num = h_new_pix_num + v_new_pix_num;
assign rd_pix_num = rd_h_pix_num + rd_v_pix_num;
assign fill_buf = (fill==1 & fill_dly==0) ? 1'b1 : 1'b0;

assign in_buf_a[0]  = buf_a[ 7:0 ];
assign in_buf_a[1]  = buf_a[15:8 ];
assign in_buf_a[2]  = buf_a[23:16];
assign in_buf_a[3]  = buf_a[31:24];
assign in_buf_a[4]  = buf_a[39:32];
assign in_buf_a[5]  = buf_a[47:40];
assign in_buf_a[6]  = buf_a[55:48];
assign in_buf_a[7]  = buf_a[63:56];
assign in_buf_a[8]  = buf_a[71:64];
assign in_buf_a[9]  = buf_a[79:72];
assign in_buf_a[10] = buf_a[87:80];
assign in_buf_a[11] = buf_a[95:88];

assign in_buf_r[0]  = buf_r[ 7:0 ];
assign in_buf_r[1]  = buf_r[15:8 ];
assign in_buf_r[2]  = buf_r[23:16];
assign in_buf_r[3]  = buf_r[31:24];
assign in_buf_r[4]  = buf_r[39:32];
assign in_buf_r[5]  = buf_r[47:40];
assign in_buf_r[6]  = buf_r[55:48];
assign in_buf_r[7]  = buf_r[63:56];
assign in_buf_r[8]  = buf_r[71:64];
assign in_buf_r[9]  = buf_r[79:72];
assign in_buf_r[10] = buf_r[87:80];
assign in_buf_r[11] = buf_r[95:88];

assign in_buf_g[0]  = buf_g[ 7:0 ];
assign in_buf_g[1]  = buf_g[15:8 ];
assign in_buf_g[2]  = buf_g[23:16];
assign in_buf_g[3]  = buf_g[31:24];
assign in_buf_g[4]  = buf_g[39:32];
assign in_buf_g[5]  = buf_g[47:40];
assign in_buf_g[6]  = buf_g[55:48];
assign in_buf_g[7]  = buf_g[63:56];
assign in_buf_g[8]  = buf_g[71:64];
assign in_buf_g[9]  = buf_g[79:72];
assign in_buf_g[10] = buf_g[87:80];
assign in_buf_g[11] = buf_g[95:88];

assign in_buf_b[0]  = buf_b[ 7:0 ];
assign in_buf_b[1]  = buf_b[15:8 ];
assign in_buf_b[2]  = buf_b[23:16];
assign in_buf_b[3]  = buf_b[31:24];
assign in_buf_b[4]  = buf_b[39:32];
assign in_buf_b[5]  = buf_b[47:40];
assign in_buf_b[6]  = buf_b[55:48];
assign in_buf_b[7]  = buf_b[63:56];
assign in_buf_b[8]  = buf_b[71:64];
assign in_buf_b[9]  = buf_b[79:72];
assign in_buf_b[10] = buf_b[87:80];
assign in_buf_b[11] = buf_b[95:88];

assign error = (width==0) & (height==0) ? 1'b1 : 1'b0;//**************

//  ============================================
//		NEXT STATE CONTROL SIGNAL	
//  ============================================
assign uu = ((width[11]==1) & (height[11]==1)) ? 1'b1 : 1'b0;
assign ud = ((width[11]==1 || width==0) & (height[11]==0 || height==0) & (error==0)) ? 1'b1 : 1'b0;
assign du = ((width[11]==0 || width==0) & (height[11]==1 || height==0) & (error==0)) ? 1'b1 : 1'b0;
assign dd = ((width[11]==0 && width!=0) & (height[11]==0 && height!=0)) ? 1'b1 : 1'b0;

assign go_uu_hup   = (down_ready & end_fill & uu) ? 1'b1 : 1'b0;
assign go_du_vup   = (down_ready & end_fill & du & no_hresize) ? 1'b1 : 1'b0;
assign go_du_hdown = (down_ready & end_fill & du & (no_hresize==0 || no_vresize)) ? 1'b1 : 1'b0;
assign go_ud_vdown = (down_ready & end_fill & ud & (no_vresize==0 || no_hresize)) ? 1'b1 : 1'b0;
assign go_ud_hup   = (down_ready & end_fill & ud & no_vresize) ? 1'b1 : 1'b0;
assign go_dd_vdown = (down_ready & end_fill & dd & no_hresize==0) ? 1'b1 : 1'b0;

assign r_uu_hup   = (~read_busy && (before_state==UU_HUP))   ? 1'b1 : 1'b0;
assign r_uu_vup   = (~read_busy && (before_state==UU_VUP))   ? 1'b1 : 1'b0;
assign r_du_hdown = (~read_busy && (before_state==DU_HDOWN)) ? 1'b1 : 1'b0;
assign r_du_vup   = (~read_busy && (before_state==DU_VUP))   ? 1'b1 : 1'b0;
assign r_ud_vdown = (~read_busy && (before_state==UD_VDOWN)) ? 1'b1 : 1'b0;
assign r_ud_hup   = ~read_busy & ud;
assign r_dd_vdown = ~read_busy & dd;

assign no_hresize = (width==0) ? 1'b1 : 1'b0;
assign no_vresize = (height==0) ? 1'b1 : 1'b0;

assign src_calc_h = (v_new_pix_num==0) ? 1'b1 : 1'b0;

assign num = (vcnt==0) ? 4'd0 :
             (vcnt==1) ? 4'd4 :
             (vcnt==2) ? 4'd8 : 4'd0;

assign addr = h_seq_cnt+num;
//  ============================================
//		RESULT PIXEL GENERATE	
//  ============================================
reg[31:0]   pause_buff;
reg         pause_dly;
reg         pause_wr_en;
reg         pause_data_en;
//reg[31:0]   result;
wire[31:0]   result;
reg         scale_end;
//reg         down_ready_dly;

assign result_pixel = (pause_wr_en) ? pause_buff : result;


//임시

assign result = 
    (uu & new_pix_num==0)               ? {in_buf_a[0],in_buf_r[0],in_buf_g[0],in_buf_b[0]} :
    (uu & h_new_pix_num==0)             ? {cal_buf_a[0][7:0],cal_buf_r[0][7:0],cal_buf_g[0][7:0],cal_buf_b[0][7:0]} :
    (du & no_hresize & src_enable)      ? {in_buf_a[h_addr1],in_buf_r[h_addr1],in_buf_g[h_addr1],in_buf_b[h_addr1]} :
    (du & no_hresize==0 & src_enable)   ? {cal_buf_a[0][7:0],cal_buf_r[0][7:0],cal_buf_g[0][7:0],cal_buf_b[0][7:0]} :
    (du & no_vresize)                   ? {down_a[15:8],down_r[15:8],down_g[15:8],down_b[15:8]} :
    (ud & no_vresize & src_enable)      ? {in_buf_a[addr],in_buf_r[addr],in_buf_g[addr],in_buf_b[addr]} :
    (ud & no_vresize==0 & src_enable)   ? {cal_buf_a[0][7:0],cal_buf_r[0][7:0],cal_buf_g[0][7:0],cal_buf_b[0][7:0]} :
    (ud & no_hresize)                   ? {down_a[15:8],down_r[15:8],down_g[15:8],down_b[15:8]} :
    (dd & cs==DD_HDOWN)                 ? {down_a[15:8],down_r[15:8],down_g[15:8],down_b[15:8]} :
                                          {result_a,result_r,result_g,result_b};

/*
always @(posedge clk or negedge rstb)
begin
    if(!rstb) begin
        result <= 0;
    end
    else begin
        if(uu & new_pix_num==0) 
            result<={in_buf_a[0],in_buf_r[0],in_buf_g[0],in_buf_b[0]};
        else if(uu & h_new_pix_num==0)
            result<={cal_buf_a[0],cal_buf_r[0],cal_buf_g[0],cal_buf_b[0]};
        else if(du & no_hresize & src_enable)
            result<={in_buf_a[h_addr0],in_buf_r[h_addr0],in_buf_g[h_addr0],in_buf_b[h_addr0]};
        else if(du & no_hresize==0 & src_enable) 
            result<={cal_buf_a[0],cal_buf_r[0],cal_buf_g[0],cal_buf_b[0]};
        else if(du & no_vresize)
            result<={down_a[15:8],down_r[15:8],down_g[15:8],down_b[15:8]};
        else if(ud & no_vresize & src_enable) 
            result<={in_buf_a[addr],in_buf_r[addr],in_buf_g[addr],in_buf_b[addr]};
        else if(ud & no_vresize==0 & src_enable) 
            result<={cal_buf_a[0],cal_buf_r[0],cal_buf_g[0],cal_buf_b[0]};
        else if(ud & no_hresize)
            result<={down_a[15:8],down_r[15:8],down_g[15:8],down_b[15:8]};
        else result<={result_a,result_r,result_g,result_b};
    end
end
*/
always @(posedge clk or negedge rstb)
begin
    if(!rstb) begin
        scale_end<=1'b0;
    end
    else begin
        if(go_idle) scale_end<=1'b1;
        else if(cs!=IDLE) scale_end<=1'b0;
    end
end

//  ============================================
//		PAUSE buffer
//	write mem에서 pause시 
//	픽셀 연산기에서 나오는 데이터 래치함
//  ============================================
//assign wr_enable = (up_ready & ~up_ready_dly & w_buf_en & ~wr_buf_en) ? 1'b1 : 1'b0;

//8.30 pm 2:50 revise
assign wr_enable = ( (w_buf_en & up_ready & ~up_ready_dly) ||
                     (w_buf_en & down_cmd & down_end & ~down_end_dly)   ) ? 1'b1 : 1'b0;
    
always @(posedge clk or negedge rstb)
begin
    if(!rstb) begin
        pause_dly<=0;
        pause_buff<=0;
        pause_data_en<=0;
        pause_wr_en<=0;
    end
    else begin
        pause_dly<=pause;
        if(pause & wr_enable) begin
            pause_data_en<=1'b1;
            pause_buff<=result;            
        end
        else if(pause_wr_en) pause_data_en<=1'b0;
        
        if(~pause & pause_dly) pause_wr_en<=1'b1;
        else pause_wr_en<=0;
    end
end

// WRITE ENABLE GENERATE
reg wr_buf_en;

always @(cs or up_ready or up_ready_dly or w_buf_en or pause_data_en or 
         down_cmd or pause_wr_en or pause_dly or down_end or down_end_dly or
         no_hresize or src_enable or src_enable_dly or no_vresize or pause)
begin
    case(cs) // synopsys parallel_case
        UU_HUP: begin 
//            if(~pause_dly) begin
            if(~pause) begin
                if(pause_data_en) wr_buf_en<=pause_wr_en;
                else if(src_enable | src_enable_dly) wr_buf_en<=w_buf_en & up_ready;
                else wr_buf_en<=w_buf_en & up_ready & ~up_ready_dly;
            end
            else wr_buf_en<=0;
        end
        UD_HUP: begin
//            if(~pause_dly) begin
            if(~pause) begin
                if(pause_data_en) wr_buf_en<=pause_wr_en;
                else if(src_enable) wr_buf_en<=w_buf_en & up_ready;
                else wr_buf_en<=w_buf_en & up_ready & ~up_ready_dly;

            end
            else wr_buf_en<=0;
        end
        UD_VDOWN : begin
//            if(~pause_dly) begin
            if(~pause) begin
                if(pause_data_en) wr_buf_en<=pause_wr_en;
                //else if(no_hresize) wr_buf_en<=w_buf_en & down_end & ~down_end_dly;
                else if(no_hresize) wr_buf_en<=down_cmd & down_end & ~down_end_dly;
                else wr_buf_en<=0;
            end
            else wr_buf_en<=0;
        end
        DU_VUP: begin
//            if(~pause_dly) begin
            if(~pause) begin
                if(pause_data_en) wr_buf_en<=pause_wr_en;
                else if(src_enable) wr_buf_en<=w_buf_en & up_ready;
                else wr_buf_en<=w_buf_en & up_ready & ~up_ready_dly;
            end
            else wr_buf_en<=0;
        end
        DU_HDOWN: begin
//            if(~pause_dly) begin
            if(~pause) begin
                if(pause_data_en) wr_buf_en<=pause_wr_en;
                else if(no_vresize) wr_buf_en<=down_cmd & down_end & ~down_end_dly;
                else wr_buf_en<=0;
            end
            else wr_buf_en<=0;
        end
        DD_HDOWN: begin
//            if(~pause_dly) begin
            if(~pause) begin
                if(pause_data_en) wr_buf_en<=pause_wr_en;
                else wr_buf_en<=down_cmd & down_end & ~down_end_dly;
            end
            else wr_buf_en<=0;
        end
        default: wr_buf_en<=0;
    endcase
end

//  ============================================
//		POINT A,R,G,B MUX	
//  ============================================

assign rate_calc = (cs==INIT) ? 1'b1 : 1'b0;

always @(posedge clk or negedge rstb) 
begin
    if(!rstb) begin
        div0<=0;
        div1<=0;
        point0_a<=0;
        point1_a<=0;
        point0_r<=0;
        point1_r<=0;
        point0_g<=0;
        point1_g<=0;
        point0_b<=0;
        point1_b<=0;
    end
    else begin
        if(ns==DD_HDOWN) begin
            div0<=h_div;
            div1<=h_div;
        end
        else begin
            div0<=div;   
            div1<=div;
        end
        if(ns==INIT & start) begin
            if(width[11]==0 && width!=0) begin //horizontal down sizing
                div0<=new_width;
                point0_a<=src_width;
                point1_a<=0;
                //h_rate<= (src_width*2048)/new_width;
            end
            else if(width[11]==1 || width==0) begin //horizontal up sizing 
                div0<=new_width-1;
                point0_a<=src_width-1;
                point1_a<=0;
                //h_rate<= ((src_width-1)*2048) / (new_width-1);
            end

            if(height[11]==0 && height!=0) begin //vertical down sizing
                div1<=new_height;
                point0_r<=src_height;
                point1_r<=0;
                //v_rate<= (src_height*2048)/new_height;
            end
            else if(height[11]==1 || height==0) begin //vertical down sizing
                div1<=new_height-1;
                point0_r<=src_height-1;
                point1_r<=0;
                //v_rate<= ((src_height-1)*2048)/(new_height-1);
            end
        end
        else if(ns==DD_HDOWN) begin
            point0_a<=point_a0; point0_r<=point_r0;
            point1_a<=point_a1; point1_r<=point_r1;
            point0_g<=point_g0; point0_b<=point_b0;
            point1_g<=point_g1; point1_b<=point_b1;
        end
        else if(ns==DU_HDOWN) begin
            if(down_num==0) begin
                point0_a<=point_a0; point0_r<=point_r0;
                point1_a<=point_a1; point1_r<=point_r1;
                point0_g<=point_g0; point0_b<=point_b0;
                point1_g<=point_g1; point1_b<=point_b1;
            end
            else if(down_num==1) begin
                point0_a<=point_a2; point0_r<=point_r2;
                point1_a<=point_a3; point1_r<=point_r3;
                point0_g<=point_g2; point0_b<=point_b2;
                point1_g<=point_g3; point1_b<=point_b3;
            end
            else if(down_num==2) begin
                point0_a<=point_a4; point0_r<=point_r4;
                point1_a<=point_a5; point1_r<=point_r5;
                point0_g<=point_g4; point0_b<=point_b4;
                point1_g<=point_g5; point1_b<=point_b5;
            end
        end
        else if(ns==DD_VDOWN | ns==UD_VDOWN) begin
            if(down_num==0) begin
                point0_a<=point_a0; point0_r<=point_r0;
                point1_a<=point_a4; point1_r<=point_r4;
                point0_g<=point_g0; point0_b<=point_b0;
                point1_g<=point_g4; point1_b<=point_b4;
            end
            else if(down_num==1) begin
                point0_a<=point_a1; point0_r<=point_r1;
                point1_a<=point_a5; point1_r<=point_r5;
                point0_g<=point_g1; point0_b<=point_b1;
                point1_g<=point_g5; point1_b<=point_b5;
            end
            else if(down_num==2) begin
                point0_a<=point_a2; point0_r<=point_r2;
                point1_a<=point_a6; point1_r<=point_r6;
                point0_g<=point_g2; point0_b<=point_b2;
                point1_g<=point_g6; point1_b<=point_b6;
            end
            else if(down_num==3) begin
                point0_a<=point_a3; point0_r<=point_r3;
                point1_a<=point_a7; point1_r<=point_r7;
                point0_g<=point_g3; point0_b<=point_b3;
                point1_g<=point_g7; point1_b<=point_b7;
            end
        end
        else begin
            point0_a<=0; point0_r<=0;
            point1_a<=0; point1_r<=0;
            point0_g<=0; point0_b<=0;
            point1_g<=0; point1_b<=0;
        end
    end
end

assign down_ready = dn_ready & ~dn_enable;

always @(down_ready or dn_enable or dn_enable_dly or h_comp_val or 
         h_div or div or v_comp_val or down_end or down_end_dly or 
         cs or div_num_cnt or hdiv_num_cnt or down_num)
begin
    if(cs==INIT) begin
        if(dn_enable==1 & dn_enable_dly==0) begin
            down_cmd<=1'b1;
            down_enable<=1'b1;
        end
        else begin
            down_cmd<=1'b0;
            down_enable<=1'b0;
        end
    end
    else if(cs==DD_HDOWN) begin
        if( (hdiv_num_cnt==(h_div-1))&&(hdiv_num_cnt!=0) )
            down_cmd<=1'b1;
        else 
            down_cmd<=1'b0;

        if(down_num==0) 
            down_enable<=dn_enable_dly; //| down_end_dly;
        else
            down_enable<=1'b0;
    end
    else if(cs==DU_HDOWN) begin
        if( (div_num_cnt==(div-1))&&(div_num_cnt!=0) )
            down_cmd<=1'b1;
        else 
            down_cmd<=1'b0;

        if(down_num!=3) 
            down_enable<=dn_enable_dly | down_end_dly;
        else
            down_enable<=1'b0;

    end
    else if(cs==DD_VDOWN | UD_VDOWN) begin
        if( (div_num_cnt==v_comp_val)&&(div_num_cnt!=0) )
            down_cmd<=1'b1;
        else 
            down_cmd<=1'b0;
        if(down_num!=4) 
            down_enable<=dn_enable_dly | down_end_dly;
        else
            down_enable<=1'b0;
        
    end
    else begin
        down_enable<=0;
        down_cmd<=0;
    end
end

/*
always @(posedge clk or negedge rstb)
begin
    if(!rstb) begin
        down_cmd<=0;
        down_enable<=0;
    end
    else begin
        if(ns==INIT) begin
            if(dn_enable==1 & dn_enable_dly==0) begin
                down_cmd<=1'b1;
                down_enable<=1'b1;
            end
            else begin
                down_cmd<=1'b0;
                down_enable<=1'b0;
            end
        end
        else if(ns==DD_HDOWN) begin
            if( (hdiv_num_cnt==h_comp_val)&&(hdiv_num_cnt!=0) )
                down_cmd<=1'b1;
            else 
                down_cmd<=1'b0;

            if(down_num==0) 
                down_enable<=dn_enable_dly; //| down_end_dly;
            else
                down_enable<=1'b0;
        end
        else if(ns==DU_HDOWN) begin
            if( (div_num_cnt==h_comp_val)&&(div_num_cnt!=0) )
                down_cmd<=1'b1;
            else 
                down_cmd<=1'b0;

            if(down_num!=3) 
                down_enable<=dn_enable_dly | down_end_dly;
            else
                down_enable<=1'b0;

        end
        else if(ns==DD_VDOWN | UD_VDOWN) begin
            if( (div_num_cnt==v_comp_val)&&(div_num_cnt!=0) )
                down_cmd<=1'b1;
            else 
                down_cmd<=1'b0;
            if(down_num!=4) 
                down_enable<=dn_enable_dly | down_end_dly;
            else
                down_enable<=1'b0;
            
        end
        else begin
            down_enable<=0;
            down_cmd<=0;
        end
    end
end
*/

// 몇번 나눌지 결정
always @(posedge clk or negedge rstb) 
begin
    if(!rstb) begin
        down_num<=0;        
        dn_ready<=1;
        down_end_dly<=0;
    end
    else begin
        down_end_dly<=down_end;

        if(dn_enable) dn_ready<=0;
        if(dn_ready==0) begin
            if(down_end) begin
                down_num<=down_num+1;
            end
            if(cs==DD_HDOWN | cs==INIT) begin //1번 나눈다.
                if(down_num==1) dn_ready<=1;
            end
            else if(cs==DU_HDOWN) begin//3번 나눈다.
                if(down_num==3) dn_ready<=1;
            end
            else if(cs==DD_VDOWN | cs==UD_VDOWN) begin //4번 나눈다.
                if(down_num==4) dn_ready<=1;
            end
        end
        else down_num<=0;
    end
end

always @(posedge clk or negedge rstb)
begin
    if(!rstb) begin
        fill_dly<=0;
//        up_ready_dly<=up_ready;
        up_ready_dly<=0;
        up_ready_dly1<=0;
//        down_ready_dly<=0;
    end
    else begin
        fill_dly<=fill;
        up_ready_dly<=up_ready;
        up_ready_dly1<=up_ready_dly;
//        down_ready_dly<=down_ready;
    end
end

//
// 각 state에 따라 calcultion buffer에 값을 할당
//

always @(posedge clk or negedge rstb)
begin
    if(!rstb) begin
        cal_buf_a[0]<=0; cal_buf_a[1]<=0;
        cal_buf_a[2]<=0; cal_buf_a[3]<=0;
        cal_buf_a[4]<=0;
        cal_buf_r[0]<=0; cal_buf_r[1]<=0;
        cal_buf_r[2]<=0; cal_buf_r[3]<=0;
        cal_buf_r[4]<=0;
        cal_buf_g[0]<=0; cal_buf_g[1]<=0;
        cal_buf_g[2]<=0; cal_buf_g[3]<=0;
        cal_buf_g[4]<=0;
        cal_buf_b[0]<=0; cal_buf_b[1]<=0;
        cal_buf_b[2]<=0; cal_buf_b[3]<=0;
        cal_buf_b[4]<=0;
    end
    else begin
        if(cs==UU_VUP && (up_ready==1 & up_ready_dly==0)) begin
            cal_buf_a[v_seq_cnt-1]<=result_a;
            cal_buf_r[v_seq_cnt-1]<=result_r;
            cal_buf_g[v_seq_cnt-1]<=result_g;
            cal_buf_b[v_seq_cnt-1]<=result_b;
        end
        else if((cs==UD_VDOWN | cs==DD_VDOWN | cs==DU_HDOWN) & down_end) begin
            if(down_cmd) begin//나눈값          
                cal_buf_a[down_num]<=down_a[15:8];
                cal_buf_r[down_num]<=down_r[15:8];
                cal_buf_g[down_num]<=down_g[15:8];
                cal_buf_b[down_num]<=down_b[15:8];
            end
            else begin//더한값
                cal_buf_a[down_num]<=down_a[12:0];
                cal_buf_r[down_num]<=down_r[12:0];
                cal_buf_g[down_num]<=down_g[12:0];
                cal_buf_b[down_num]<=down_b[12:0];
            end
        end
        else if((cs==DD_HDOWN & down_end)) begin
            if(down_cmd) begin// 나눈값
                cal_buf_a[4]<=down_a[15:8];
                cal_buf_r[4]<=down_r[15:8];
                cal_buf_g[4]<=down_g[15:8];
                cal_buf_b[4]<=down_b[15:8];
            end
            else begin// 더한값
                cal_buf_a[4]<=down_a[12:0];
                cal_buf_r[4]<=down_r[12:0];
                cal_buf_g[4]<=down_g[12:0];
                cal_buf_b[4]<=down_b[12:0];
            end
        end
    end
end

    // rd_cmd 2번째 bit가 1이면 read continue 
    // rd_cmd 2번째 bit가 0이면 in_buf_num은 0부터 read
    // max read: 32개 까지 read ==> rd_cmd=0x3f;
    // 3'b001: 1-line read , in_buf_num=0 :: 3'b101: 1-line read continue   
    // 3'b010: 2-line read , in_buf_num=0 :: 3'b110: 2-line read continue
    // 3'b011: 3-line read , in_buf_num=0 :: 3'b111: 3-line read continue

//  ============================================
//			current_state
//  ============================================
assign next_calc = ((h_rate_cnt[21:11])==h_comp_val) ? 1'b1 : 1'b0;

assign wr_cmd = (uu || ud || (du & no_hresize)) ? 2'b01 :
                (du & no_vresize) ? 2'b10 : 
                (du) ? 2'b11 : 2'b00; // dd이면 2'b00;

assign calc_up = up_ready & ~pause & ~pause_dly;
assign calc_dn = down_ready & ~pause;

assign b_addr = (v_seq_cnt==0) ? 4'd0 :
                (v_seq_cnt==1) ? 4'd4 :
                (v_seq_cnt==2) ? 4'd8 : 4'd0;


always @(posedge clk or negedge rstb)
begin
    if(!rstb) begin
        cs<=IDLE;
        point_a0<=0; point_a1<=0; point_a2<=0; point_a3<=0;
        point_a4<=0; point_a5<=0; point_a6<=0; point_a7<=0;
        point_r0<=0; point_r1<=0; point_r2<=0; point_r3<=0;
        point_r4<=0; point_r5<=0; point_r6<=0; point_r7<=0;
        point_g0<=0; point_g1<=0; point_g2<=0; point_g3<=0;
        point_g4<=0; point_g5<=0; point_g6<=0; point_g7<=0;
        point_b0<=0; point_b1<=0; point_b2<=0; point_b3<=0;
        point_b4<=0; point_b5<=0; point_b6<=0; point_b7<=0;
        rd_v_pix_num_base<=0;
        go_idle<=0;
        go_wait<=0;
        uu_hup<=0;
        uu_vup<=0;
        du_hdown<=0;
        du_vup<=0;
        ud_hup<=0;
        ud_vdown<=0;
        dd_vdown<=0;
        dd_hdown<=0;
        src_enable<=0;
        rd_en<=0;
        up_enable<=0;
        dn_enable<=0;
        //down_cmd<=0;
        first_row<=0;
        v_cnt<=0;
        before_state<=0;
        w_buf_en<=0;
        h_div<=0;
//        seq_comp_val<=0;
        remain_height<=0;
        last_remain<=0;
        remain_width<=0;
        width_cnt<=0;
        height_cnt<=0;
        width_cnt1<=0;
        height_cnt1<=0;
        div_num_cnt<=0;
        hdiv_num_cnt<=0;
        h_comp_val<=0;
        v_comp_val<=0;
        h_seq_cnt<=0;
        v_seq_cnt<=0;
        h_rate_cnt<=0;
        v_rate_cnt<=0;
        h_rate_base<=0;
        v_rate_base<=0;
        rd_h_pix_num<=0;
        rd_v_pix_num<=0;
        h_new_pix_num<=0;
        v_new_pix_num<=0;
        v_new_pix_base<=0;
        h_new_pix_base<=0;
        //
        //
        fill<=0;
        rd_cmd<=0;
        rd_num<=0;
        mul<=0;
        div<=0;
        h_addr0<=0;
        h_addr1<=0;
        v_addr0<=0;
        v_addr1<=0;
        t_last<=0;
        t_init<=0;
        init_en<=0;
        h_rate<=0;
        v_rate<=0;
        dn_enable_dly<=0;
        not_calc<=1;
        vcnt<=0;
        temp_a<=0; 
        temp_r<=0;
        temp_g<=0;
        temp_b<=0;
        rd_remain<=0;
        src_enable_dly<=0;
//        remain_en<=0;
        l_rd_v_pix_num<=0;
        last_width<=0;
    end
    else begin
        cs<=ns;
        t_last<=0;
        t_init<=0;
        dn_enable_dly<=dn_enable;
        src_enable_dly<=src_enable;

        case(ns)  // synopsys parallel_case
            IDLE: begin
                point_a0<=0; point_a1<=0; point_a2<=0; point_a3<=0;
                point_a4<=0; point_a5<=0; point_a6<=0; point_a7<=0;
                point_r0<=0; point_r1<=0; point_r2<=0; point_r3<=0;
                point_r4<=0; point_r5<=0; point_r6<=0; point_r7<=0;
                point_g0<=0; point_g1<=0; point_g2<=0; point_g3<=0;
                point_g4<=0; point_g5<=0; point_g6<=0; point_g7<=0;
                point_b0<=0; point_b1<=0; point_b2<=0; point_b3<=0;
                point_b4<=0; point_b5<=0; point_b6<=0; point_b7<=0;
                rd_v_pix_num_base<=0;
                go_idle<=0;
                go_wait<=0;
                uu_hup<=0;
                uu_vup<=0;
                du_hdown<=0;
                du_vup<=0;
                ud_hup<=0;
                ud_vdown<=0;
                dd_vdown<=0;
                dd_hdown<=0;
                src_enable<=0;
                rd_en<=0;
                up_enable<=0;
                dn_enable<=0;
                //down_cmd<=0;
                first_row<=0;
                v_cnt<=0;
                before_state<=0;
                w_buf_en<=0;
                h_div<=0;
//                seq_comp_val<=0;
                remain_height<=0;
                last_remain<=0;
                remain_width<=0;
                width_cnt<=0;
                height_cnt<=0;
                width_cnt1<=0;
                height_cnt1<=0;
                div_num_cnt<=0;
                hdiv_num_cnt<=0;
                h_comp_val<=0;
                v_comp_val<=0;
                h_seq_cnt<=0;
                v_seq_cnt<=0;
                h_rate_cnt<=0;
                v_rate_cnt<=0;
                h_rate_base<=0;
                v_rate_base<=0;
                rd_h_pix_num<=0;
                rd_v_pix_num<=0;
                h_new_pix_num<=0;
                v_new_pix_num<=0;
                v_new_pix_base<=0;
                h_new_pix_base<=0;
                //
                //
                fill<=0;
                rd_cmd<=0;
                rd_num<=0;
                mul<=0;
                div<=0;
                h_addr0<=0;
                h_addr1<=0;
                v_addr0<=0;
                v_addr1<=0;
                t_last<=0;
                t_init<=0;
                init_en<=0;
                h_rate<=0;
                v_rate<=0;
                dn_enable_dly<=0;
                not_calc<=1;
                vcnt<=0;            
                temp_a<=0; 
                temp_r<=0;
                temp_g<=0;
                temp_b<=0;
                rd_remain<=0;
                src_enable_dly<=0;
//                remain_en<=0;
                l_rd_v_pix_num<=0;
                last_width<=0;
            end
            INIT: begin
                first_row<=1'b1;
                t_init<=1'b1;
                h_rate_cnt<=h_rate;
                v_rate_cnt<=v_rate;
                rd_num<=3'b100;
                if(start) begin
                    dn_enable<=1'b1;
                    //down_cmd<=1'b1;
                end
                else begin
                    //down_cmd<=1'b0;
                    dn_enable<=1'b0;
                end
                if(down_end) begin 
                    h_rate<=down_a[16:0]; //정수[16:11] 소수[10:0]
                    v_rate<=down_r[16:0];
                end 
                if(read_busy==0) fill<=1'b1;
                else fill<=1'b0;
                if(uu) begin
                    rd_cmd<=3'b010;//2-line read
                    h_rate_base<=h_rate;
                    v_rate_base<=v_rate;
                    src_enable<=1;
                end
                else if(ud) begin
                    h_rate_base<=h_rate;
                    v_rate_base<=0;
                    //vertical:1 horizontal:down
                    if(no_vresize) rd_cmd<=3'b010;//5'h02;//2-line read; 
                    else rd_cmd<=3'b011;//5'h03; //3-line read
                end
                else if(du) begin
                    v_rate_base<=v_rate;
                    h_rate_base<=0;
                    //vertical:down horizontal:1
                    if(no_hresize) rd_cmd<=3'b010;//2-line read;
                    else rd_cmd<=3'b011;//5'h03;//3-line read //vertical:down horizontal:up
                end
                else if(dd) begin
                    h_rate_base<=0;
                    v_rate_base<=0;
                    rd_cmd<=3'b011;//5'h03;//5'b00010;//3-line read
                end
            end
            UU_HUP: begin
                rd_cmd<=3'b101;//h21;// 1-line read continue
                fill<=0;
                up_enable<=0;
                go_wait<=0;
                go_idle<=0;
                v_seq_cnt<=0;
                uu_vup<=0;
                uu_hup<=0;
                if(v_rate_cnt[22:11]==v_comp_val) 
                    v_addr0<=v_addr1;
                else begin
                    v_addr1<=v_addr0;
                    if(v_addr0==12) begin
                        v_addr0<=0;
                        v_addr1<=0;
                    end
                end
                if(up_enable) begin
                    h_new_pix_num<=h_new_pix_num+1;
                    if(init_en) begin
                        t_init<=1'b1;
                        init_en<=0;
                    end
                end

                if(calc_up) begin //7.27 new
                    w_buf_en<=0;
                    if(v_new_pix_num==0) rd_en<=1;
                    else rd_en<=0;

                    if(src_enable) begin
                        w_buf_en<=1;
                        src_enable<=0;
                    end
                    else if(h_new_pix_num==(new_width-1) && h_seq_cnt!=3) begin //9.1 pm 5
                            h_seq_cnt<=3;
                    end
                    else begin
                        //if(h_seq_cnt==3 || (up_ready_dly & (h_new_pix_num==new_width-1))) begin //9.1 pm 4
                        if(h_seq_cnt==3) begin //9.1 pm 5
                           t_last<=1'b1;
                            h_seq_cnt<=0;
                            if(h_new_pix_num==new_width-1 && height_cnt==new_height-1)
                                go_idle<=1;

                            if(height_cnt==new_height-1) begin
                                h_comp_val<=h_rate_cnt[22:11];
                                h_rate_base<=h_rate_cnt;
                                //h_new_pix_base<=h_new_pix_num+1;//7.20 revise
                                h_new_pix_base<=h_new_pix_num;
                                rd_num<=4;
                                rd_cmd<=3'b010;//5'h02;////0x01 2-line read
                                v_new_pix_num<=0;
                                rd_v_pix_num<=0;
                                rd_h_pix_num<=rd_h_pix_num+3;
                                fill<=1;
                                go_wait<=1;
                                before_state<=UU_HUP;
                                height_cnt<=0;
                                v_addr0<=0;
                                v_addr1<=0;
                                v_rate_cnt<=v_rate;
                                init_en<=1'b1;
                            end
                            else begin
                                uu_vup<=1;
                                h_rate_cnt<=h_rate_base;
                                h_comp_val<=h_rate_base[22:11];
                                h_new_pix_num<=h_new_pix_base;
                            end
                        end
                        else begin
                            //if((h_rate_cnt[21:11])==h_comp_val) begin
                            if(next_calc) begin
                                uu_vup<=0;
                                mul<=h_rate_cnt;
                                up_enable<=1;
                                if(src_calc_h) begin
                                    point_a0<=in_buf_a[h_seq_cnt];
                                    point_a1<=in_buf_a[h_seq_cnt+1];
                                    point_r0<=in_buf_r[h_seq_cnt];
                                    point_r1<=in_buf_r[h_seq_cnt+1];
                                    point_g0<=in_buf_g[h_seq_cnt];
                                    point_g1<=in_buf_g[h_seq_cnt+1];
                                    point_b0<=in_buf_b[h_seq_cnt];
                                    point_b1<=in_buf_b[h_seq_cnt+1];
                                end
                                else begin
                                    point_a0<=cal_buf_a[h_seq_cnt];
                                    point_a1<=cal_buf_a[h_seq_cnt+1];
                                    point_r0<=cal_buf_r[h_seq_cnt];
                                    point_r1<=cal_buf_r[h_seq_cnt+1];
                                    point_g0<=cal_buf_g[h_seq_cnt];
                                    point_g1<=cal_buf_g[h_seq_cnt+1];
                                    point_b0<=cal_buf_b[h_seq_cnt];
                                    point_b1<=cal_buf_b[h_seq_cnt+1];
                                end
                                w_buf_en<=1;
                                //h_new_pix_num<=h_new_pix_num+1;
                                h_rate_cnt<=h_rate_cnt+h_rate;
                                if(height_cnt==new_height-1 )//|| (new_width-width_cnt<5))
                                    width_cnt<=width_cnt+1;
                            end
                            else begin//next memory로 pixel계산 
                                //up_enable<=0;
                                h_seq_cnt<=h_seq_cnt+1;
                                h_comp_val<=h_rate_cnt[22:11];
                            end//if((h_rate_cnt[22:11])==h_comp_val)
                        end//if(h_seq_cnt==3 || width_cnt==new_width) else //horizontal끝 vertical시작
                    end//if(src_enable) else
                end//if(ready)
            end // end UU_HUP
            UU_VUP: begin 
                w_buf_en<=0;
                up_enable<=0;
                uu_vup<=0;
                uu_hup<=0;
                fill<=0;
                
                if(h_new_pix_num==0)
                    src_enable<=1;
                else src_enable<=0;
                
                if(up_ready) begin 
                    if(v_seq_cnt==4) begin
                        uu_hup<=1;
                        //v_seq_cnt<=0;
                        v_rate_cnt<=v_rate_cnt+v_rate;
                        height_cnt<=height_cnt+1;
                        v_new_pix_num<=v_new_pix_num+new_width;
 //                       t_init<=1'b1;//8.1new
                    end
                    else begin
                        if(v_rate_cnt[22:11]==v_comp_val) begin
                            if(v_seq_cnt==0) begin
                                // 추가 & ) //pipeline  memory refill
                                if(h_rate_cnt==h_rate_base && rd_en && height_cnt!=new_height-1) begin
                                    rd_en<=0;
                                    rd_num<=4;
                                    rd_cmd<=3'b101;//5'h21;//1-line read continue
                                    fill<=1;
                                    if(rd_v_pix_num==0)
                                        rd_v_pix_num<=rd_v_pix_num+{src_width,1'b0};
                                    else 
                                        rd_v_pix_num<=rd_v_pix_num+src_width;              
                                end
                                //v_addr0<=v_addr1;//7.20 revise
                            end
                            up_enable<=1;
                            mul<=v_rate_cnt;
                            point_a0<=in_buf_a[v_addr0];
                            point_r0<=in_buf_r[v_addr0];
                            point_g0<=in_buf_g[v_addr0];
                            point_b0<=in_buf_b[v_addr0];
                            if(v_addr0>7) begin
                                point_a1<=in_buf_a[v_addr0-8];
                                point_r1<=in_buf_r[v_addr0-8];
                                point_g1<=in_buf_g[v_addr0-8];
                                point_b1<=in_buf_b[v_addr0-8];
                            end
                            else begin
                                point_a1<=in_buf_a[v_addr0+4];
                                point_r1<=in_buf_r[v_addr0+4];
                                point_g1<=in_buf_g[v_addr0+4];
                                point_b1<=in_buf_b[v_addr0+4];
                            end
                            v_addr0<=v_addr0+1;
                            v_seq_cnt<=v_seq_cnt+1;
                        end 
                        else begin
                            //if(r_mem_cs!=IDLE1 || r_mem_ns!=IDLE1) begin
                            if(read_busy) begin
                                go_wait<=1;
                                before_state<=UU_VUP;
                            end
                            else go_wait<=0;
                            
                            //v_addr1<=v_addr0;  7.20 revise    
                            v_comp_val<=v_rate_cnt[22:11];
                            rd_en<=1;
                        end 
                    end
                end//end if(up_ready)
            end// end UU_VUP
            DU_HDOWN: begin
                fill<=1'b0;
                go_idle<=0;
                //down_cmd<=0;
                dn_enable<=0;
                du_vup<=0;
                du_hdown<=0;
                before_state<=DU_HDOWN;
                w_buf_en<=0;

                if(no_vresize) begin
                    if(dn_enable) begin
                        if(init_en) begin
                            t_init<=1'b1;
                            init_en<=1'b0;
                        end
                    end
                    if(down_cmd & ~down_end & down_end_dly) begin
                        v_new_pix_num<=v_new_pix_num+new_width;
                        t_last<=1'b1;
                        if(h_new_pix_num==(new_width-1)) last_width<=1'b1;
                    end
                    else if(down_num==3) begin
                        last_width<=0;
                        v_new_pix_num<=v_new_pix_base;
                    end
                    else last_width<=0;
                end
                
                if(calc_dn) begin
                    if(h_seq_cnt==4/*seq_comp_val*/ || width_cnt==new_width) begin //buffer empty
                        go_wait<=1;
                        h_seq_cnt<=0;
                        dn_enable<=0;
                        fill<=1;
                        rd_num<=4;
                        if(width_cnt==new_width) begin
                            h_rate_base<=0;
                            rd_h_pix_num<=0;
                            h_rate_cnt<=h_rate;
                            v_cnt<=v_cnt+3;
                            remain_height<=src_height-v_cnt;
                            width_cnt<=0;
                            if(no_vresize) begin//06.26 added
                                if(v_cnt==(new_height-3)) go_idle<=1;
                                else go_idle<=0;
                                init_en<=1'b1;//8.8new
                                h_new_pix_num<=0;
                                v_new_pix_base<=v_new_pix_base+{new_width,1'b0}+new_width;
                                v_new_pix_num<=v_new_pix_base+{new_width,1'b0}+new_width;
                                rd_v_pix_num<=rd_v_pix_num+{src_width,1'b0}+src_width;// vertical=1
                            end
                            else begin
                                rd_v_pix_num<=rd_v_pix_num+{src_width,1'b0};//vertical 중복
                            end
                        end
                        else
                            rd_h_pix_num<=rd_h_pix_num+4;

                        if(remain_height<=2) begin
                            if(remain_height==1)
                                rd_cmd<=3'b010;//5'h02;//5'b000001;//0x01; //2-line_read;
                            else if(remain_height==2)
                                rd_cmd<=3'b011;//5'h03;//5'b000010;//0x02; //3-line_read;
                        end
                        else begin
                            rd_cmd<=3'b011;//5'h03;//5'b000010;//0x02; //3-line_read;
                        end
                    end
                    else begin
                        go_wait<=0;
                        if(div_num_cnt==0) begin
                            dn_enable<=1'b0;
                            //point calculation
                            point_a0<=in_buf_a[h_seq_cnt];
                            point_r0<=in_buf_r[h_seq_cnt];
                            point_g0<=in_buf_g[h_seq_cnt];
                            point_b0<=in_buf_b[h_seq_cnt];

                            point_a2<=in_buf_a[h_seq_cnt+4];
                            point_r2<=in_buf_r[h_seq_cnt+4];
                            point_g2<=in_buf_g[h_seq_cnt+4];
                            point_b2<=in_buf_b[h_seq_cnt+4];

                            point_a4<=in_buf_a[h_seq_cnt+8];
                            point_r4<=in_buf_r[h_seq_cnt+8];
                            point_g4<=in_buf_g[h_seq_cnt+8];
                            point_b4<=in_buf_b[h_seq_cnt+8];
                            /////확인 요망***************
                            if(width_cnt==(new_width-1) && last_remain==1 && 
                               h_seq_cnt==h_comp_val) begin 

                                width_cnt<=width_cnt+1;
                                du_vup<=1;
                                //down_cmd<=1'b1;//5'b000001;//0x01;// cal_buf/div
                                div_num_cnt<=0;
                                h_rate_base<=h_rate_cnt;
                                h_rate_cnt<=h_rate_cnt+h_rate;
                            end /////**************************
                            else begin
                                if(h_rate[16:11]<2) begin
                                    h_comp_val<=1;
                                    div<=2;
                                end
                                else begin
                                    if((new_width-1)==width_cnt) begin //last
                                        div<=src_width-h_rate_base[22:11]; 
                                    end
                                    else begin
                                        div<=(h_rate_cnt[22:11]-h_rate_base[22:11]);
                                    end
                                    //h_comp_val<=div-1;//8.17 revise
                                end
                                div_num_cnt<=div_num_cnt+1;
                            end
                            h_seq_cnt<=h_seq_cnt+1;
                        end
                        else begin  
                            if(div_num_cnt!=1) begin
                                point_a0<=cal_buf_a[0];
                                point_r0<=cal_buf_r[0];
                                point_g0<=cal_buf_g[0];
                                point_b0<=cal_buf_b[0];

                                point_a2<=cal_buf_a[1];
                                point_r2<=cal_buf_r[1];
                                point_g2<=cal_buf_g[1];
                                point_b2<=cal_buf_b[1];

                                point_a4<=cal_buf_a[2];
                                point_r4<=cal_buf_r[2];
                                point_g4<=cal_buf_g[2];
                                point_b4<=cal_buf_b[2];
                            end
                            //point calculation
                            point_a1<=in_buf_a[h_seq_cnt];
                            point_r1<=in_buf_r[h_seq_cnt];
                            point_g1<=in_buf_g[h_seq_cnt];
                            point_b1<=in_buf_b[h_seq_cnt];
                            
                            point_a3<=in_buf_a[h_seq_cnt+4];
                            point_r3<=in_buf_r[h_seq_cnt+4];
                            point_g3<=in_buf_g[h_seq_cnt+4];
                            point_b3<=in_buf_b[h_seq_cnt+4];

                            point_a5<=in_buf_a[h_seq_cnt+8];
                            point_r5<=in_buf_r[h_seq_cnt+8];
                            point_g5<=in_buf_g[h_seq_cnt+8];
                            point_b5<=in_buf_b[h_seq_cnt+8];
                            //h_comp_val<=div-1;//8.17 new
                            if(down_num==3) begin

                                if(div_num_cnt==(div-1)) begin //go DU_VUP
                                    //if(h_comp_val!=1) h_comp_val<=div-1;//8.24 new
                                    if(no_vresize) begin
                                        w_buf_en<=1;
                                        h_new_pix_num<=h_new_pix_num+1;//8.8 revise
                                    end
                                    else begin
                                        du_vup<=1'b1; 
                                    end
                                    width_cnt<=width_cnt+1;
                                   // down_cmd<=1'b1;//0x01;// cal_buf/div
                                    div_num_cnt<=0;
                                    h_rate_base<=h_rate_cnt;
                                    h_rate_cnt<=h_rate_cnt+h_rate;
                                    if(h_rate[16:11]<2) begin
                                        //overlap
                                        if( (h_rate_cnt[22:11]-h_rate_base[22:11])==1 || 
                                            (width_cnt==new_width-1) ) begin
                                            h_seq_cnt<=h_seq_cnt;
                                        end
                                        else begin 
                                            h_seq_cnt<=h_seq_cnt+1;
                                        end
                                    end
                                    else begin
                                        h_seq_cnt<=h_seq_cnt+1;
                                    end

                                end
                                else begin// continue HDOWN
                                    h_seq_cnt<=h_seq_cnt+1;
                                    div_num_cnt<=div_num_cnt+1;
                                end
                            end
                            else dn_enable<=1'b1;
                        end//div_num_cnt==0) else
                    end
                end            
            end// end DU_HDOWN
            DU_VUP: begin 
                dn_enable<=0;
                src_enable<=0;
                up_enable<=0;
                du_vup<=0;
                before_state<=DU_VUP;
                go_idle<=0;
                fill<=1'b0;
                last_width<=0;
                if(up_enable & ~no_hresize) begin
                    v_new_pix_num<=v_new_pix_num+new_width;
                end
                if(up_enable | src_enable) begin 
                    if(init_en) begin
                        t_init<=1'b1;
                        init_en<=0;
                    end
                end
                if(no_hresize & up_ready_dly & ~up_ready_dly1) begin
                   if(h_seq_cnt!=0) begin
                        h_new_pix_num<=h_new_pix_num+1;
                    end
                end

                //if((height_cnt==new_height-1)&&(h_new_pix_num==(new_width-1)) begin
                //    go_idle<=1;
                //    t_last<=1'b1;
                //end
                //else if(calc_up) begin
                if(calc_up) begin
                    w_buf_en<=0;
                    if(no_hresize) begin//vertical=up,horizontal=1
                        if(h_seq_cnt==4) begin//last in_buf
                            if(h_new_pix_num==(new_width-1)) begin
                                last_width<=1'b1;
                                if(height_cnt==new_height-1) go_idle<=1'b1;
                            end
                            t_last<=1'b1;
                            h_seq_cnt<=0;
                            if(read_busy) go_wait<=1'b1;
                            else go_wait<=1'b0;

                            if(h_addr0==12) h_addr0<=0; //8.8 new

                            if(height_cnt!=new_height-1) begin//
                                /*
                                if(v_new_pix_num!=0) begin
                                    v_rate_cnt<=v_rate_cnt+v_rate;
                                end
                                */
                                //v_rate_base<=v_rate_cnt;
                                if(v_rate_cnt[22:11]!=v_comp_val) begin
                                    rd_en<=1'b1;
                                end
                                else if(v_new_pix_num!=0) begin
                                    if(h_addr0==0)
                                        h_addr0<=8;
                                    else h_addr0<=h_addr0-4;                           
                                end
                                if(v_new_pix_num==0) rd_en<=1'b1;
                                
                                height_cnt<=height_cnt+1;
                                v_comp_val<=v_rate_cnt[22:11];
                                //h_addr0<=h_addr0-4;//revise 8.8
                                h_new_pix_num<=h_new_pix_base;
                                v_new_pix_num<=v_new_pix_num+new_width;
                            end
                            else begin//last_height
                                h_addr0<=0;
                                init_en<=1'b1;
                                height_cnt<=0;
                                h_new_pix_base<=h_new_pix_num+1;
                                h_new_pix_num<=h_new_pix_num+1;
                                v_new_pix_base<=0;
                                v_new_pix_num<=0;
                                v_rate_cnt<=v_rate;
                                v_comp_val<=0;
                                //v_rate_base<=v_rate;
                                /// read memory
                                fill<=1;
                                rd_cmd<=3'b010;//5'h02;////2-line_read 
                                rd_num<=4;
                                go_wait<=1;
                                rd_v_pix_num<=0;
                                rd_h_pix_num<=rd_h_pix_num+4;
                            end
                        end
                        else begin
                            
                            if(h_seq_cnt==3) begin
                                if(height_cnt!=new_height-1) begin
                                    if(v_new_pix_num!=0) begin
                                        v_rate_cnt<=v_rate_cnt+v_rate;
                                    end
                                end
                            end
                            
                            if(v_new_pix_num!=0) begin
                                h_addr1<=0;
                                //read memory fsm enable
                                if(h_seq_cnt==0 & (height_cnt!=new_height-1) & rd_en) begin
                                    rd_en<=0;
                                    fill<=1;
                                    rd_cmd<=3'b101;//5'h21;//1-line_read continue
                                    rd_num<=4;
                                    if(v_rate_cnt==v_rate) begin
                                        rd_v_pix_num<={src_width,1'b0};
                                    end
                                    else begin
                                        rd_v_pix_num<=rd_v_pix_num+src_width;
                                    end
                                end
                                mul<=v_rate_cnt;
                                point_a0<=in_buf_a[h_addr0];
                                point_r0<=in_buf_r[h_addr0];
                                point_g0<=in_buf_g[h_addr0];
                                point_b0<=in_buf_b[h_addr0];
                                if(h_addr0>7) begin
                                    point_a1<=in_buf_a[h_addr0-8];
                                    point_r1<=in_buf_r[h_addr0-8];
                                    point_g1<=in_buf_g[h_addr0-8];
                                    point_b1<=in_buf_b[h_addr0-8];
                                end
                                else begin 
                                    point_a1<=in_buf_a[h_addr0+4];
                                    point_r1<=in_buf_r[h_addr0+4];
                                    point_g1<=in_buf_g[h_addr0+4];
                                    point_b1<=in_buf_b[h_addr0+4];
                                end
                                if(h_seq_cnt!=3) begin
                                    w_buf_en<=1;
                                    up_enable<=1;
                                    h_addr0<=h_addr0+1;
                                end
                                if(up_ready & ~up_ready_dly)
                                    h_seq_cnt<=h_seq_cnt+1;
                            end
                            else begin// 첫번째 라인
                                src_enable<=1;
                                w_buf_en<=1;
                                if(src_enable) begin
                                    h_seq_cnt<=h_seq_cnt+1;
                                    src_enable<=0;
                                    w_buf_en<=0;
                                    h_addr1<=h_addr1+1;
                                end
                                else begin
                                    if(h_seq_cnt!=0) begin
                                        h_new_pix_num<=h_new_pix_num+1;
                                    end
                                end
                            end
                        end
                    end
                    else if(height_cnt==(new_height-1) && v_seq_cnt!=2) begin
                        v_seq_cnt<=2;
                    end
                    else begin //vertical=up,horizontal=down
                
                        //if(v_seq_cnt==2 || (up_ready_dly==1'b1 && height_cnt==new_height-1)) begin // refill cal_buf
                        if(v_seq_cnt==2) begin // 9.1 pm 4
                            du_hdown<=1;
                            v_seq_cnt<=0;
                            t_last<=1'b1;
                            if(h_new_pix_num==(new_width-1)) begin
                                last_width<=1'b1;
                                if(height_cnt==new_height-1) go_idle<=1'b1;
                            end
        //                    v_new_pix_num=v_new_pix_base;
                            if(new_width==width_cnt) begin
                                height_cnt1<=height_cnt;//8.28 pm 9:25
                                init_en<=1'b1;
                                v_rate_base<=v_rate_cnt; 
                                v_comp_val<=v_rate_cnt[22:11];
                                v_new_pix_base<=v_new_pix_num;
                                h_new_pix_num<=0;
                                if(v_rate_cnt[22:11]>=src_height) begin//last_height
                                    go_idle<=1;
                                end
                            end
                            else begin
                                if(v_rate_base==v_rate) begin
                                    first_row<=1;
                                end
                                v_rate_cnt<=v_rate_base;
                                v_comp_val<=v_rate_base[22:11];
        //                        v_new_pix_num<=v_new_pix_base;
                                //v_new_pix_num<=0;                        
                                v_new_pix_num<=v_new_pix_base;
                                h_new_pix_num<=h_new_pix_num+1;
                                height_cnt<=height_cnt1;//8.28 pm 9:25 
                            end

                        end
                        else begin // continue pixel generate
                            if(first_row) begin
                                src_enable<=1;
                                w_buf_en<=1;
                                first_row<=0;
 //                               v_new_pix_num<=v_new_pix_num+new_width;
                            end
                            else begin
                                if(v_rate_cnt[22:11]==v_comp_val) begin
                                    mul<=v_rate_cnt;
                                    point_a0<=cal_buf_a[v_seq_cnt];
                                    point_a1<=cal_buf_a[v_seq_cnt+1];
                                    point_r0<=cal_buf_r[v_seq_cnt];
                                    point_r1<=cal_buf_r[v_seq_cnt+1];
                                    point_g0<=cal_buf_g[v_seq_cnt];
                                    point_g1<=cal_buf_g[v_seq_cnt+1];
                                    point_b0<=cal_buf_b[v_seq_cnt];
                                    point_b1<=cal_buf_b[v_seq_cnt+1];
        //                            v_new_pix_num<=v_new_pix_num+new_width;
                                    //v_new_pix_num<=v_new_pix_num+new_width;//8.30
                                    height_cnt<=height_cnt+1;//8.28 pm 9:25
                                    up_enable<=1;
                                    w_buf_en<=1;
                                    v_rate_cnt<=v_rate_cnt+v_rate;
                                end
                                else begin
                                    v_seq_cnt<=v_seq_cnt+1;
                                    v_comp_val<=v_rate_cnt[22:11];
                                end
                            end
                        end
                    end
                end
            end // end DU_VUP
            UD_VDOWN: begin 
                before_state<=UD_VDOWN;
                fill<=0;
               // down_cmd<=0;
                go_wait<=0;
                dn_enable<=0;
                up_enable<=0;
                ud_hup<=0;
                t_last<=0;
                //w_buf_en<=0;
                src_enable<=0;
                if(dn_enable & no_hresize) begin
                    if(init_en) begin
                        t_init<=1'b1;
                        init_en<=1'b0;
                    end
                end
                if(no_hresize) begin
                    if(down_cmd & ~down_end & down_end_dly) begin
                        h_new_pix_num<=h_new_pix_num+1;
                        if(down_num==4) t_last<=1'b1;
                    end
                    else if(down_num==4) begin
                        h_new_pix_num<=h_new_pix_base;
                    end
                end
                if(h_new_pix_num==0) not_calc<=1'b1;
                else not_calc<=1'b0;
                

                if(calc_dn) begin
                    if(v_seq_cnt==3 || height_cnt==new_height) begin//seq_comp_val)// buffer refill
                        go_wait<=1;
                        v_seq_cnt<=0;
                        dn_enable<=0;
                        fill<=1;
                        rd_num<=4;
                        go_idle<=0;
                        if(height_cnt==new_height) begin
                            v_rate_base<=0;
                            v_rate_cnt<=v_rate;
                            height_cnt<=0;
                            rd_v_pix_num<=0;
                            if(no_hresize) begin
                                if(remain_width<=8 && h_new_pix_num!=0) begin//last pixel 
                                    go_idle<=1;
                                end
                                rd_h_pix_num<=rd_h_pix_num+4;//horizontal<=<=1
                                h_new_pix_base<=h_new_pix_base+4;//8.8 new
                                h_new_pix_num<=h_new_pix_base+4;
                                init_en<=1'b1;
                                //h_new_pix_num<=h_new_pix_num+4;//8.8 revise
                            end
                            else begin
                                rd_h_pix_num<=rd_h_pix_num+3;
                            end
                            remain_width<=new_width-h_new_pix_num;
                        end
                        else begin
                            rd_v_pix_num<=rd_v_pix_num+{src_width,1'b0}+src_width;
                        end
                    end
                    else begin
                        go_wait<=0;
                        /* 
                        if(v_seq_cnt==0) h_addr0<=0;
                        else if(v_seq_cnt==1) h_addr0<=4;
                        else if(v_seq_cnt==2) h_addr0<=8;
                        */
                        if(div_num_cnt==0) begin
                            dn_enable<=0;
                            point_a0<=in_buf_a[b_addr];
                            point_a1<=in_buf_a[b_addr+1];
                            point_a2<=in_buf_a[b_addr+2];
                            point_a3<=in_buf_a[b_addr+3];

                            point_r0<=in_buf_r[b_addr];
                            point_r1<=in_buf_r[b_addr+1];
                            point_r2<=in_buf_r[b_addr+2];
                            point_r3<=in_buf_r[b_addr+3];

                            point_g0<=in_buf_g[b_addr];
                            point_g1<=in_buf_g[b_addr+1];
                            point_g2<=in_buf_g[b_addr+2];
                            point_g3<=in_buf_g[b_addr+3];

                            point_b0<=in_buf_b[b_addr];
                            point_b1<=in_buf_b[b_addr+1];
                            point_b2<=in_buf_b[b_addr+2];
                            point_b3<=in_buf_b[b_addr+3];

                            if(v_rate[16:11]<2) begin
                                //v_comp_val<=1;//7.24 revise
                                v_comp_val<=1;
                                div<=2;
                            end
                            else begin
                                if((new_height-1)==height_cnt) begin
                                    div<=src_height-v_rate_base[22:11];
                                end
                                else begin
                                    div<=(v_rate_cnt[22:11]-v_rate_base[22:11]);
                                end
                                //v_comp_val<=div-1;//7.24 revise
                            end
                            div_num_cnt<=div_num_cnt+1;
                            v_seq_cnt<=v_seq_cnt+1;

                        end
                        else begin  
                            if(div_num_cnt!=1) begin
                                point_a0<=cal_buf_a[0];
                                point_a1<=cal_buf_a[1];
                                point_a2<=cal_buf_a[2];
                                point_a3<=cal_buf_a[3];

                                point_r0<=cal_buf_r[0];
                                point_r1<=cal_buf_r[1];
                                point_r2<=cal_buf_r[2];
                                point_r3<=cal_buf_r[3];

                                point_g0<=cal_buf_g[0];
                                point_g1<=cal_buf_g[1];
                                point_g2<=cal_buf_g[2];
                                point_g3<=cal_buf_g[3];

                                point_b0<=cal_buf_b[0];
                                point_b1<=cal_buf_b[1];
                                point_b2<=cal_buf_b[2];
                                point_b3<=cal_buf_b[3];
                            end
                            point_a4<=in_buf_a[b_addr];                       
                            point_a5<=in_buf_a[b_addr+1];                       
                            point_a6<=in_buf_a[b_addr+2];                       
                            point_a7<=in_buf_a[b_addr+3];                       

                            point_r4<=in_buf_r[b_addr];                       
                            point_r5<=in_buf_r[b_addr+1];                       
                            point_r6<=in_buf_r[b_addr+2];                       
                            point_r7<=in_buf_r[b_addr+3];                       

                            point_g4<=in_buf_g[b_addr];                       
                            point_g5<=in_buf_g[b_addr+1];                       
                            point_g6<=in_buf_g[b_addr+2];                       
                            point_g7<=in_buf_g[b_addr+3];                       

                            point_b4<=in_buf_b[b_addr]; 
                            point_b5<=in_buf_b[b_addr+1];                       
                            point_b6<=in_buf_b[b_addr+2];                       
                            point_b7<=in_buf_b[b_addr+3]; 
                            w_buf_en<=(no_hresize) ? 1'b1 : 1'b0;
                            v_comp_val<=div-1;//8.17 new
                            if(down_num==4) begin
                                //t_last<=1'b1;
                                if(div_num_cnt==v_comp_val) begin
                                    height_cnt<=height_cnt+1;
                                    //down_cmd<=1'b1;//0x01;// cal_buf/div
                                    div_num_cnt<=0;
                                    v_rate_base<=v_rate_cnt;
                                    v_rate_cnt<=v_rate_cnt+v_rate;
                                    if(no_hresize) begin
                                        w_buf_en<=1;
                                        if(height_cnt==new_height-1) begin
        //                                    v_new_pix_num=0;
                                            v_new_pix_num<=0;
                                        end
                                        else begin
                                            v_new_pix_num<=v_new_pix_num+new_width;
                                        end
                                    end
                                    else begin
                                        if(ud) ud_hup<=1;
                                    end
                                end
                                else begin
                                    div_num_cnt<=div_num_cnt+1;
                                end
                                if((v_rate_cnt[22:11]-v_rate_base[22:11])==1) begin
                                    v_seq_cnt<=v_seq_cnt;//overlap
                                end
                                else begin
                                    v_seq_cnt<=v_seq_cnt+1;
                                end
                            end
                            else dn_enable<=1;
                        end//div_num_cnt==0) else
                    end
                end//if(down_ready && (v_rate[22:11])<=32) 
            end // end UD_VDOWN
            UD_HUP: begin 
                dn_enable<=0;
                ud_vdown<=0;
                up_enable<=0;
                ud_hup<=0;
                go_idle<=0;
                fill<=0;
                if(up_enable) begin 
                    h_new_pix_num<=h_new_pix_num+1;
                    if(init_en) begin
                        t_init<=1'b1;
                        init_en<=0;
                    end
                end
 
                if(~up_ready & up_ready_dly) src_enable<=0;

                if(calc_up) begin
                    //w_buf_en<=0;//7.25 new
                    if(not_calc) begin// first column wirte
                        src_enable<=1;
                        w_buf_en<=1'b1;
                        not_calc<=1'b0;
                    end
                    else if(h_new_pix_num==(new_width-1) && h_seq_cnt!=3) begin
                        h_seq_cnt<=3;
                    end
                    //else if(h_seq_cnt==3 | ( (h_new_pix_num==new_width-1)&up_ready_dly) ) begin //vertical=down,horizontal=up
                    else if(h_seq_cnt==3 | ( (h_new_pix_num==new_width-1)&up_ready) ) begin //9.1 pm 4
                        t_last<=1'b1;
                        h_seq_cnt<=0;
                        ud_vdown<=1'b1;
                        
                        if(read_busy & no_vresize) go_wait<=1'b1;
                        else go_wait<=1'b0;

                        if(h_new_pix_num==new_width-1 && height_cnt1==new_height-1)
                            go_idle<=1;
                        else if(height_cnt1==new_height-1) begin//last height
                            init_en<=1'b1; //7.25 new
                            height_cnt1<=0;
                            h_comp_val<=h_rate_cnt[22:11];
                            h_rate_base<=h_rate_cnt;
                            h_new_pix_base<=h_new_pix_num;
                            v_new_pix_num<=0;
                            if(no_vresize) begin
                                fill<=1;
                                rd_cmd<=3'b010;//5'h02;//2-line read 
                                rd_num<=4;
                                go_wait<=1;
                                rd_v_pix_num<=0;
                                rd_h_pix_num<=rd_h_pix_num+3;
                                ud_vdown<=1'b0;
                                vcnt<=0;
                            end
                        end
                        else begin
                            h_rate_cnt<=h_rate_base;
                            h_comp_val<=h_rate_base[22:11];
                            h_new_pix_num<=h_new_pix_base;
                            height_cnt1<=height_cnt1+1;
                            v_new_pix_num<=v_new_pix_num+new_width;
                            if(no_vresize) begin
                                ud_vdown<=1'b0;
                                if(vcnt==2) vcnt<=0;
                                else vcnt<=vcnt+1;
                                if(h_new_pix_base==0) not_calc<=1'b1;
                                else not_calc<=1'b0;
                            end
                        end
                    end
                    else begin
                        if(h_rate_cnt[22:11]==h_comp_val) begin//  ****** vertical=down,horizontal=up ******
                            w_buf_en<=1;
                            up_enable<=1;
                            mul<=h_rate_cnt;
                            h_rate_cnt<=h_rate_cnt+h_rate;
                            point_a0<=(no_vresize) ? in_buf_a[addr]   : cal_buf_a[h_seq_cnt];
                            point_a1<=(no_vresize) ? in_buf_a[addr+1] : cal_buf_a[h_seq_cnt+1];
                            point_r0<=(no_vresize) ? in_buf_r[addr]   : cal_buf_r[h_seq_cnt];
                            point_r1<=(no_vresize) ? in_buf_r[addr+1] : cal_buf_r[h_seq_cnt+1];
                            point_g0<=(no_vresize) ? in_buf_g[addr]   : cal_buf_g[h_seq_cnt];
                            point_g1<=(no_vresize) ? in_buf_g[addr+1] : cal_buf_g[h_seq_cnt+1];
                            point_b0<=(no_vresize) ? in_buf_b[addr]   : cal_buf_b[h_seq_cnt];
                            point_b1<=(no_vresize) ? in_buf_b[addr+1] : cal_buf_b[h_seq_cnt+1];
                            if(no_vresize) begin
                                if(h_rate_cnt==h_rate_base && height_cnt1!=new_height-1) begin
                                    rd_cmd<=3'b101;//5'h21;// 1-line read continue
                                    rd_num<=4;
                                    fill<=1;
                                    if(v_new_pix_num==0) 
                                        rd_v_pix_num<=rd_v_pix_num+{src_width,1'b0};//src_width*2
                                    else rd_v_pix_num<=rd_v_pix_num+src_width;
                                end
                            end
                        end
                        else begin 
                            w_buf_en<=1'b0;
                            h_seq_cnt<=h_seq_cnt+1;
                            h_comp_val<=h_rate_cnt[22:11];
                        end
                    end
                end
            end // end UD_HUP
            DD_VDOWN: begin 
                before_state<=DD_VDOWN;
                fill<=0;
                //down_cmd<=0;
                go_wait<=0;
                dn_enable<=0;
                w_buf_en<=0;
                dd_hdown<=0;
                remain_width<=src_width-rd_h_pix_num;
                if(calc_dn) begin
                    if(v_seq_cnt==3 || height_cnt==new_height) begin//seq_comp_val)// buffer refill
                        go_wait<=1;
                        v_seq_cnt<=0;
                        dn_enable<=0;
                        fill<=1;
                        rd_num<=4;
//                        remain_en<=0;
                        if(src_width==remain_width) begin
                            if(div==2) l_rd_v_pix_num<=rd_v_pix_num + src_width;
                            else if(div==3) l_rd_v_pix_num<=rd_v_pix_num + {src_width,1'b0};
                            //else l_rd_v_pix_num<=rd_v_pix_num;
                            else if(rd_cmd==3'b101) l_rd_v_pix_num<=rd_v_pix_num;
                            else if(rd_cmd==3'b110) l_rd_v_pix_num<=rd_v_pix_num + src_width;
                        end
                        //rd_remain_dly<=rd_remain;
                        if(div==1) rd_cmd<=3'b001;//5'h01;//1-line read 
                        else if(div==2) rd_cmd<=3'b010;//5'h02;//2-line read 
                        else if(div==3) rd_cmd<=3'b011;//5'h03;//3-line read 
                        //else if(remain>=3 | rd_remain<=0) rd_cmd<=3'b011;//5'h03;//3-line read
                        else if(remain==1) rd_cmd<=3'b101;//5'h21;//1-line read continue
                        else if(remain==2) rd_cmd<=3'b110;//5'h22;//2-line read continue
                        else rd_cmd<=3'b011;

                        rd_remain<=rd_remain-3;//8.17 revise
                        if(remain[11]!=1'b1 && remain!=0) begin// rd_remain>0
                            rd_v_pix_num<=rd_v_pix_num+{src_width,1'b0}+src_width;
                        end
                        else begin
                            if(remain_width<=4) begin/////// last column ?
                                rd_cmd<=3'b011;//5'h03;//3-line_read
                                v_rate_base<=v_rate_cnt;
                                v_rate_cnt<=v_rate_cnt+v_rate;
                                rd_h_pix_num<=0;
                                if(v_rate[16:11]<2) begin
                                    //overlap
                                    if( (v_rate_cnt[22:11]-v_rate_base[22:11])==1 ) begin  
                                    //if(overlap_comp==1) begin
                                        rd_v_pix_num<=rd_v_pix_num+src_width;
                                        rd_v_pix_num_base<=rd_v_pix_num+src_width;
                                    end
                                    else begin
                                        rd_v_pix_num<=rd_v_pix_num+{src_width,1'b0};
                                        rd_v_pix_num_base<=rd_v_pix_num+{src_width,1'b0};
                                    end
                                end
                                else begin
                                    rd_v_pix_num<=l_rd_v_pix_num+src_width;
                                    rd_v_pix_num_base<=l_rd_v_pix_num+src_width;
                                end
                            end
                            else begin
                                rd_v_pix_num<=rd_v_pix_num_base;
                                rd_h_pix_num<=rd_h_pix_num+4;
                            end
                        end
                    end
                    else begin
                        if(div_num_cnt==0) begin
                            dn_enable<=0;
                            point_a0<=in_buf_a[b_addr];
                            point_a1<=in_buf_a[b_addr+1];
                            point_a2<=in_buf_a[b_addr+2];
                            point_a3<=in_buf_a[b_addr+3];

                            point_r0<=in_buf_r[b_addr];
                            point_r1<=in_buf_r[b_addr+1];
                            point_r2<=in_buf_r[b_addr+2];
                            point_r3<=in_buf_r[b_addr+3];

                            point_g0<=in_buf_g[b_addr];
                            point_g1<=in_buf_g[b_addr+1];
                            point_g2<=in_buf_g[b_addr+2];
                            point_g3<=in_buf_g[b_addr+3];

                            point_b0<=in_buf_b[b_addr];
                            point_b1<=in_buf_b[b_addr+1];
                            point_b2<=in_buf_b[b_addr+2];
                            point_b3<=in_buf_b[b_addr+3];

                            if(v_rate[16:11]<2) begin
                                v_comp_val<=1;
                                div<=2;
                                rd_remain<=2;
                            end
                            else begin
                                if((new_height-1)==height_cnt) begin
                                    div<=src_height-v_rate_base[22:11];
                                    rd_remain<=src_height-v_rate_base[22:11];
                                end
                                else begin
                                    div<=(v_rate_cnt[22:11]-v_rate_base[22:11]);
                                    rd_remain<=(v_rate_cnt[22:11]-v_rate_base[22:11]);
                                end
                                //v_comp_val<=div-1;//8.17 revise
                            end

                            //rd_remain<=div;
                            div_num_cnt<=div_num_cnt+1;
                            v_seq_cnt<=v_seq_cnt+1;
                        end
                        else begin 
                            if(div_num_cnt!=1) begin
                                point_a0<=cal_buf_a[0];
                                point_a1<=cal_buf_a[1];
                                point_a2<=cal_buf_a[2];
                                point_a3<=cal_buf_a[3];

                                point_r0<=cal_buf_r[0];
                                point_r1<=cal_buf_r[1];
                                point_r2<=cal_buf_r[2];
                                point_r3<=cal_buf_r[3];

                                point_g0<=cal_buf_g[0];
                                point_g1<=cal_buf_g[1];
                                point_g2<=cal_buf_g[2];
                                point_g3<=cal_buf_g[3];

                                point_b0<=cal_buf_b[0];
                                point_b1<=cal_buf_b[1];
                                point_b2<=cal_buf_b[2];
                                point_b3<=cal_buf_b[3];
                            end

                            point_a4<=in_buf_a[b_addr];                       
                            point_a5<=in_buf_a[b_addr+1];                       
                            point_a6<=in_buf_a[b_addr+2];                       
                            point_a7<=in_buf_a[b_addr+3];                       

                            point_r4<=in_buf_r[b_addr];                       
                            point_r5<=in_buf_r[b_addr+1];                       
                            point_r6<=in_buf_r[b_addr+2];                       
                            point_r7<=in_buf_r[b_addr+3];                       

                            point_g4<=in_buf_g[b_addr];                       
                            point_g5<=in_buf_g[b_addr+1];                       
                            point_g6<=in_buf_g[b_addr+2];                       
                            point_g7<=in_buf_g[b_addr+3];                       

                            point_b4<=in_buf_b[b_addr]; 
                            point_b5<=in_buf_b[b_addr+1];                       
                            point_b6<=in_buf_b[b_addr+2];                       
                            point_b7<=in_buf_b[b_addr+3]; 

                            v_comp_val<=div-1;//8.17 new
                            if(down_num==4) begin
                                if(div_num_cnt==v_comp_val) begin
                                    //down_cmd<=1'b1;//0x01;// cal_buf/div
                                    div_num_cnt<=0;
                                    dd_hdown<=1;
                                    v_seq_cnt<=3;
//                                    remain_en<=1'b1;
                                end   
                                else begin
                                    div_num_cnt<=div_num_cnt+1;
                                    if((v_rate_cnt[22:11]-v_rate_base[22:11])==1) begin
                                        v_seq_cnt<=v_seq_cnt;//overlap
                                    end
                                    else begin
                                        v_seq_cnt<=v_seq_cnt+1;
                                    end
                                    //v_seq_cnt<=v_seq_cnt+1;
                                end
                            end
                            else dn_enable<=1;
                        end//div_num_cnt==0) else
                    end
                end//if(down_ready && (v_rate[22:11])<=32) 
            end //end DD_VDOWN
            DD_HDOWN: begin 
                dd_hdown<=0;
                go_idle<=0;
               // down_cmd<=0;
                dn_enable<=0;
                //w_buf_en<=0;
                dd_vdown<=0;
                if(down_cmd & ~down_end & down_end_dly) begin
                    h_new_pix_num<=h_new_pix_num+1;
                    if(width_cnt1==(new_width-1)) t_last<=1'b1;//8.18 new
                end
                if(dn_enable) begin 
                    if(init_en) begin
                        t_init<=1'b1;
                        init_en<=0;
                    end
                    
                end
                if(calc_dn) begin
                    if(h_seq_cnt==4 || width_cnt1==new_width) begin // cal_buffer empty
                        h_seq_cnt<=0;
                        dn_enable<=0;
                        dd_vdown<=1;
                        if(width_cnt1==new_width) begin
                            if(height_cnt1==new_height) go_idle<=1;
                            else go_idle<=0;
                            init_en<=1'b1;
                            h_rate_base<=0;
                            h_rate_cnt<=h_rate;
                            width_cnt1<=0;
                            height_cnt1<=height_cnt1+1;
                            h_new_pix_num<=0;
                            v_new_pix_num<=v_new_pix_num+new_width;
                        end                        
                    end
                    else begin
                        if(hdiv_num_cnt==0) begin
                            //point calculation
                            temp_a<=cal_buf_a[h_seq_cnt];
                            temp_r<=cal_buf_r[h_seq_cnt];
                            temp_g<=cal_buf_g[h_seq_cnt];
                            temp_b<=cal_buf_b[h_seq_cnt];
                            if(h_rate[16:11]<2) begin
                                //h_comp_val<=1;
                                h_div<=2;
                            end
                            else begin
                                if((new_width-1)==width_cnt1)//last
                                    h_div<=src_width-h_rate_base[22:11];
                                else h_div<=h_rate_cnt[22:11]-h_rate_base[22:11];
                                //h_comp_val<=h_div-1;//8.17 revise
                            end
                            hdiv_num_cnt<=hdiv_num_cnt+1;
                            h_seq_cnt<=h_seq_cnt+1;
                        end
                        else begin  
                            //horizontal=down,vertical=down
                                //point calculation
                            if(hdiv_num_cnt==1) begin
                                point_a0<=temp_a;
                                point_r0<=temp_r;
                                point_g0<=temp_g;
                                point_b0<=temp_b;
                            end
                            else begin
                                point_a0<=cal_buf_a[4];
                                point_r0<=cal_buf_r[4];
                                point_g0<=cal_buf_g[4];
                                point_b0<=cal_buf_b[4];
                            end
                            point_a1<=cal_buf_a[h_seq_cnt];
                            point_r1<=cal_buf_r[h_seq_cnt];
                            point_g1<=cal_buf_g[h_seq_cnt];
                            point_b1<=cal_buf_b[h_seq_cnt];
                            if(down_num==1) begin
                                //if(hdiv_num_cnt==h_comp_val) begin
                                if(hdiv_num_cnt==(h_div-1)) begin //8.17 new
                                    w_buf_en<=1;
                                    width_cnt1<=width_cnt1+1;
                                    //down_cmd<=1'b1;//0x01;// cal_buf/div
                                    hdiv_num_cnt<=0;
                                    h_rate_base<=h_rate_cnt;
                                    h_rate_cnt<=h_rate_cnt+h_rate;
                                    //h_new_pix_num<=h_new_pix_num+1;//8.17 revise
                                    if(h_rate[16:11]<2) begin
                                        //overlap
                                        if( (h_rate_cnt[22:11]-h_rate_base[22:11])==1 || 
                                            (width_cnt1==new_width-1) )
                                            h_seq_cnt<=h_seq_cnt;
                                        else begin 
                                            h_seq_cnt<=h_seq_cnt+1;
                                        end
                                    end
                                    else begin
                                        h_seq_cnt<=h_seq_cnt+1;
                                    end
                                end
                                else begin 
                                    hdiv_num_cnt<=hdiv_num_cnt+1;
                                    h_seq_cnt<=h_seq_cnt+1;
                                end
                            end
                            else dn_enable<=1;
                        end//hdiv_num_cnt==0) else
                    end//if(h_seq_cnt==seq_comp_val || width_cnt1==new_width)
                end //if(down_ready)
            end
            ST_WAIT: begin     
                go_wait<=0;
                fill<=1'b0;
            end
        endcase
    end

end





//  ============================================
//			next_state
//  ============================================
always @(cs or start or go_idle or go_uu_hup or go_du_vup or go_du_hdown or
         go_ud_vdown or go_ud_hup or go_dd_vdown or go_wait or uu_hup or
         uu_vup or du_hdown or du_vup or ud_hup or ud_vdown or dd_vdown or dd_hdown or
         r_uu_hup or r_du_vup or r_du_hdown or r_ud_vdown or 
         r_ud_hup or r_dd_vdown)
begin
    case(cs) // synopsys parallel_case
        IDLE:
            if(start) ns<=INIT;
            else ns<=IDLE;
        INIT:
            if(go_uu_hup) ns<=UU_HUP;
            else if(go_du_vup) ns<=DU_VUP;
            else if(go_du_hdown) ns<=DU_HDOWN;
            else if(go_ud_vdown) ns<=UD_VDOWN;
            else if(go_ud_hup) ns<=UD_HUP;
            else if(go_dd_vdown) ns<=DD_VDOWN;
            else ns<=INIT;
        UU_HUP:
            if(go_idle) ns<=IDLE;
            else if(uu_vup) ns<=UU_VUP;
            else if(go_wait) ns<=ST_WAIT;
            else ns<=UU_HUP;
        UU_VUP:
            if(uu_hup) ns<=UU_HUP;
            else ns<=UU_VUP;
        DU_HDOWN:
            if(go_idle) ns<=IDLE;
            else if(du_vup) ns<=DU_VUP;
            else if(go_wait) ns<=ST_WAIT;
            else ns<=DU_HDOWN;
        DU_VUP:
            if(go_idle) ns<=IDLE;
            else if(du_hdown) ns<=DU_HDOWN;
            else if(go_wait) ns<=ST_WAIT;
            else ns<=DU_VUP;
        UD_VDOWN:
            if(go_idle) ns<=IDLE;
            else if(ud_hup) ns<=UD_HUP;
            else if(go_wait) ns<=ST_WAIT;
            else ns<=UD_VDOWN;
        UD_HUP:
            if(go_idle) ns<=IDLE;
            else if(ud_vdown) ns<=UD_VDOWN;
            else if(go_wait) ns<=ST_WAIT;
            else ns<=UD_HUP;
        DD_VDOWN:
            if(go_wait) ns<=ST_WAIT;
            else if(dd_hdown) ns<=DD_HDOWN;
            else ns<=DD_VDOWN;
        DD_HDOWN:
            if(go_idle) ns<=IDLE;
            else if(dd_vdown) ns<=DD_VDOWN;
            else ns<=DD_HDOWN;
        ST_WAIT:
            if(r_uu_hup) ns<=UU_HUP;
            else if(r_ud_vdown) ns<=UD_VDOWN;
            else if(r_du_hdown) ns<=DU_HDOWN;
            else if(r_du_vup) ns<=DU_VUP;
            else if(r_ud_hup) ns<=UD_HUP;
            else if(r_dd_vdown) ns<=DD_VDOWN;
            else ns<=ST_WAIT;
        default:
            ns<=IDLE;
    endcase
end

// synopsys translate_off
wire[11:0] h_rate_cnt10bit=h_rate_cnt[22:11];

reg [8*10 : 1] next_state;
always @(ns)
begin 
    case(ns) 
        IDLE     : next_state = "IDLE";  
        INIT     : next_state = "INIT";
        UU_HUP   : next_state = "UU_HUP";
        UU_VUP   : next_state = "UU_VUP";
        DU_HDOWN : next_state = "DU_HDOWN";
        DU_VUP   : next_state = "DU_VUP";
        UD_VDOWN : next_state = "UD_VDOWN";
        UD_HUP   : next_state = "UD_HUP";
        DD_VDOWN : next_state = "DD_VDOWN";
        DD_HDOWN : next_state = "DD_HDOWN";
        ST_WAIT  : next_state = "ST_WAIT";
    endcase
end

reg [8*10 : 1] current_state;
always @(cs)
begin  
    case(cs) 
        IDLE     : current_state = "IDLE";  
        INIT     : current_state = "INIT";
        UU_HUP   : current_state = "UU_HUP";
        UU_VUP   : current_state = "UU_VUP";
        DU_HDOWN : current_state = "DU_HDOWN";
        DU_VUP   : current_state = "DU_VUP";
        UD_VDOWN : current_state = "UD_VDOWN";
        UD_HUP   : current_state = "UD_HUP";
        DD_VDOWN : current_state = "DD_VDOWN";
        DD_HDOWN : current_state = "DD_HDOWN";
        ST_WAIT  : current_state = "ST_WAIT";
    endcase
end
// synopsys translate_on



endmodule
