//*****************************************
// module name : write_mem.v
// by  : Brother
// date: 2006-7-6
//*****************************************
`timescale 1ns/10ps

module write_mem(
    clk,
    rstb,
    //from reg block
    start,
    //from scaler
    wr_buf_en,
    st_init,
    t_init,
    t_last,
    last_width,
    scale_end,
    wr_cmd,
    result_pixel,
    h_new_pix_num,
    v_new_pix_num,
    //from reg block
    bpp,
    new_width,
    new_img_addr,
    //BUS-interface
    Wready,
    Wbusy,    
    WR,
    Wsize,
    Wbe,
    Waddr,
    Wdata,
    finish_write,
    //to scaler
    pause);

input        clk;
input        rstb;
//from reg block
input        start;
//from scaler
input        wr_buf_en;
input        st_init;
input        t_init;
input        t_last;
input        last_width;
input        scale_end;
input[ 1:0]  wr_cmd;
input[11:0]  h_new_pix_num;
input[22:0]  v_new_pix_num;
input[31:0]  result_pixel;

//from reg block
input[ 2:0]  bpp;
input[11:0]  new_width;
input[31:0]  new_img_addr;

//BUS-interface
input        Wready;
input        Wbusy;
output       WR;
output[ 4:0] Wsize;
output[ 7:0] Wbe;
output[31:0] Waddr;
output[63:0] Wdata;
output       finish_write;

//to scaler
output       pause;

parameter DATA_WIDTH = 64;
parameter BE_WIDTH   = 8;

parameter IDLE      = 4'b0001;
parameter READY     = 4'b0010;
parameter WR_CMD    = 4'b0100;
parameter WR_DATA   = 4'b1000;

parameter BUFFSIZE  = 4;

parameter CONV_IDLE  = 4'b0001;
parameter CONV_DCALC = 4'b0010;
parameter CONV_WAIT  = 4'b0100;
parameter CONV_DSAVE = 4'b1000;

reg[ 3:0]   ns;
reg[ 3:0]   cs;
reg[ 3:0]   c_cs;
reg[ 3:0]   c_ns;

reg[31:0]   Waddr;
reg[ 4:0]   Wsize;

reg[DATA_WIDTH-1:0] tdata;
reg[DATA_WIDTH-1:0] w_buf [0:BUFFSIZE-1];

reg[BE_WIDTH-1:0]   be_buf[0:BUFFSIZE-1];
reg[BE_WIDTH-1:0]   be;
reg[BE_WIDTH-1:0]   tbe;
reg[BE_WIDTH-1:0]   rest_be;

reg[ 1:0]   wr_pointer;
reg[ 1:0]   rd_pointer;

reg[ 5:0]   rd_cnt;
reg[ 5:0]   wr_cnt;
reg[ 5:0]   all_wnum;


reg[15:0]   rest_data;

reg[22:0]   start_pix;
reg[22:0]   l_start_pix;

reg         split_addr2;
reg         split_addr5;
wire        pause;
reg         full_buf;
reg         overlap; //
reg         wbuf_en;
reg         not_save;
reg         wrap_ptr;
reg         Wbusy_dly;
reg         finish_conv;
reg[ 5:0]   size_cnt;
reg[ 5:0]   l_size_cnt;
//reg[ 5:0]   send_size;
reg[ 7:0]   send_size; //9.6 pm10:50
reg[ 5:0]   overlap_size;
reg[12:0]   align_pix;
reg[12:0]   l_align_pix;
reg[12:0]   addr_align_pix;


//wire[ 7:0]  Wbe;
reg [ 7:0]  Wbe;
wire[63:0]  Wdata;
wire[31:0]  addr;
wire[22:0]  new_pix_num; 
wire[ 2:0]  counter;
wire[ 3:0]  byte;
wire[ 1:0]  add_pix;
wire[24:0]  wr_pix;

wire        data_ready;

//reg finish_dly;
assign finish_write = (c_cs==CONV_IDLE & cs==IDLE & scale_end) ? 
                      1'b1 : 1'b0;
//assign finish_write=finish & ~finish_dly;                  
//always @(posedge clk or negedge rstb)
//begin
//    if(!rstb) begin
//        finish_dly<=0;
//    end
//    else begin
//        finish_dly<=finish;
//    end
//end

//assign pause = (c_cs==CONV_IDLE | finish_conv==1) ? 1'b0 : full;
assign align_bpp = (bpp==1 || bpp==2 || bpp==3) ? 1'b1 : 1'b0;
//assign align = (new_width[1:0]==0) ? 1'b1 : 1'b0;
assign align = (new_width[1:0]==0 || bpp==4 || bpp==5) ? 1'b1 : 1'b0;
assign add_pix = (new_width[1:0]==1 && align_bpp==1'b1) ? 2'b11 :
                 (new_width[1:0]==2 && align_bpp==1'b1) ? 2'b10 :
                 (new_width[1:0]==3 && align_bpp==1'b1) ? 2'b01 : 2'b00 ;

assign new_pix_num=h_new_pix_num+v_new_pix_num;
assign full=(counter==BUFFSIZE) ? 1'b1 : 1'b0;

assign byte=tbe[7]+tbe[6]+tbe[5]+tbe[4]+tbe[3]+tbe[2]+tbe[1]+tbe[0];

//  ============================================
//	PAUSE Control		
//  ============================================
always @(posedge clk or negedge rstb)
begin
    if(!rstb) begin
        full_buf<=0;
        overlap<=0;
    end
    else begin
        if(t_last&~Wbusy) overlap<=1'b1;
 //       else if(ns==READY) overlap<=1'b0;
        else if(ns==WR_CMD) overlap<=1'b0;

        if(full) full_buf<=1'b1;
        else if(counter==0 | counter==1) full_buf<=1'b0;
    end
end

//assign pause = overlap | full_buf;
assign pause = full_buf;

//  ============================================
//	BUFFER Control		
//  ============================================
assign counter={wrap_ptr,wr_pointer}-{1'b0,rd_pointer}; 
assign rd_en = (wr_cmd==2'b11) ? (Wbusy & ~Wbusy_dly) :
                                  Wready | (Wbusy & ~Wbusy_dly);

always @(posedge clk or negedge rstb)
begin
    if(!rstb) begin
        wrap_ptr<=0;
    end
    else begin
/*        if( (c_ns==CONV_DSAVE & (wr_pointer==BUFFSIZE-1) & ~rd_en) |
            (rd_en & (rd_pointer==BUFFSIZE-1) & c_ns!=CONV_DSAVE) )
            wrap_ptr<=~wrap_ptr;
*/

 
        if ( (c_ns==CONV_DSAVE & (wr_pointer==BUFFSIZE-1)) |
             (rd_en & (rd_pointer==BUFFSIZE-1)) )
            wrap_ptr<=~wrap_ptr;
    end
end

//  ============================================
//	current state		
//  ============================================
always @(posedge clk or negedge rstb)
begin
    if(!rstb)
        cs<=IDLE;
    else 
        cs<=ns;
end

//  ============================================
//	next state		
//  ============================================
reg cont;
reg full_dly;
reg last_data;
reg last_data_dly;

assign vertical = (Wbusy & counter!=0 & !(counter==1 & cs==WR_DATA)) ? 1'b1 : 1'b0;

assign data_ready = (wr_cmd==2'b01 | wr_cmd==2'b00) ? 
                    (last_data | full) & Wbusy :
                    vertical ;

always @(cs or data_ready or Wbusy)
begin
    case(cs) // synopsys parallel_case
        IDLE    :
            if(data_ready) ns<=READY;
            else ns<=IDLE;
        READY    :
            ns<=WR_CMD;
        WR_CMD  : 
            ns<=WR_DATA;
        WR_DATA :
            if(data_ready) ns<=READY;
            else if(Wbusy) ns<=IDLE;
            else ns<=WR_DATA;
        default: ns<=IDLE;
    endcase
end

always @(posedge clk or negedge rstb)
begin
    if(!rstb) begin
        last_data<=0;
        last_data_dly<=0;
    end
    else begin
        last_data_dly<=last_data;
        if(t_last) last_data<=1'b1;
        else if(ns==WR_CMD) last_data<=1'b0;
        
    end
end
//  ============================================
//			BUS-IF
//  ============================================
reg split_en;
always @(posedge clk or negedge rstb)
begin
    if(!rstb) begin
        split_en<=0;
    end
    else begin
        if(split_addr2 | split_addr5) begin
            if(Wready) split_en<=1'b1;
            else if(Wbusy & ~Wbusy_dly) split_en<=1'b0;
        end
    end
end

assign WR = (cs==WR_CMD) ? 1'b1 : 1'b0;
//assign Wbe = (cs==WR_CMD | cs==WR_DATA) ? be_buf[rd_pointer] : 0;
assign Wdata = (cs==WR_CMD | cs==WR_DATA) ? w_buf[rd_pointer] : 0;

always @(cs or rd_pointer or split_en or rd_pointer or 
        split_addr2 or split_addr5 or wr_cmd) 
begin
    if(wr_cmd==2'b11) begin
        if(split_addr2 & split_en)
            Wbe<=8'b0000_0001;
        else if(split_addr5 & split_en)
            Wbe<=8'b0000_0011;
        else 
            Wbe<=be_buf[rd_pointer];
    end
    else begin
        if(cs==WR_CMD | cs==WR_DATA) Wbe<=be_buf[rd_pointer];
        else Wbe<=8'd0;
    end
end

assign wv_end = (all_wnum!=0 & all_wnum == rd_cnt) ? 1'b1 : 1'b0;//write vertical end
// start point calculation
reg wv_end_dly;
reg t_init_dly;
reg last_width_dly;
reg[1:0] t_last_cnt;
wire[22:0] new_align_pix;
assign new_align_pix = new_pix_num+align_pix;

always @(posedge clk or negedge rstb)
begin
    if(!rstb) begin
        start_pix<=0;
        l_start_pix<=0;
        wv_end_dly<=0;
        align_pix<=0; //8.31 am 10:19
        l_align_pix<=0;//8.31 pm 9:19 
        addr_align_pix<=0; //8.31 pm 8:19 new pixel byte enable 구할때 사용~
        t_init_dly<=0; //8.31 am 10:19
        last_width_dly<=0; //9.1 am 9
        t_last_cnt<=0;
    end
    else begin
        wv_end_dly<=wv_end;
        t_init_dly<=t_init; //8.31 am 10:19
        last_width_dly<=last_width;

        if(start) begin //초기화
            align_pix<=0;
            start_pix<=0;
            l_align_pix<=0;
            addr_align_pix<=0;
        end

        if(wr_cmd==2'b00) begin //dn_dn
            if(t_init) begin
                if(~st_init) begin
                    align_pix<=align_pix+add_pix;//8.31 am 10 added
                    addr_align_pix<=addr_align_pix+add_pix;//8.31 am 10 added
                end
            end
            else if(t_init_dly) begin
                if(bpp==1 || bpp==2) begin
                    if(new_align_pix!=0)
                        start_pix<={new_align_pix,1'b0};
                end
                else if(bpp==3)
                    start_pix<={new_align_pix,1'b0}+new_align_pix;
                else 
                    start_pix<={new_align_pix,2'b0};
            end
            else if(cont) start_pix<=Waddr-new_img_addr;
        end
        else if(wr_cmd==2'b01) begin //uu | ud |(du & no_hresize)
            if(t_init) begin
                start_pix<=new_pix_num;
                align_pix<=0;//8.31 am 10 added
                addr_align_pix<=0;//8.31 am 10 added
            end
            if(t_last) begin
                addr_align_pix<=addr_align_pix+add_pix;//8.31 am 10 added
            end
            if(~last_data & last_data_dly) begin
                start_pix<=start_pix+new_width;
                align_pix<=align_pix+add_pix;//8.31 am 10 added
            end
        end
        else begin// w_vertical이면 (wr_cmd==2'b10 |2'b11, du & no_vresize, du)
            if(wr_cmd==2'b10) begin
                if(t_last) begin
                    if(t_last_cnt==2) t_last_cnt<=0;
                    else t_last_cnt<=t_last_cnt+1;
                end
                if(wbuf_en) begin
                    addr_align_pix<=addr_align_pix+add_pix;
                end
                else if(t_last & ~last_width & t_last_cnt==2) begin
                    addr_align_pix<=l_align_pix;
                end
            end
            else begin
                if(wbuf_en) begin
                    addr_align_pix<=addr_align_pix+add_pix;
                end
                else if(t_last & ~last_width) begin
                    addr_align_pix<=l_align_pix;
                end
            end
            if(last_width & ~last_width_dly) l_align_pix<=addr_align_pix;
            
            
            if(t_init) begin
                start_pix<=new_pix_num;
                l_start_pix<=new_pix_num; //초기값 래치
            end
            
            if(wv_end & ~wv_end_dly) begin
                l_start_pix<=l_start_pix+1; //horizontal방향으로 +1해줌
            end
            else if(~wv_end & wv_end_dly) begin 
                start_pix<=l_start_pix;
                align_pix<=l_align_pix;//8.31 pm 9:25
            end
            else if(ns==WR_CMD) begin
                start_pix<=start_pix+new_width;
                align_pix<=align_pix+add_pix;//8.31 pm 9:25
            end
        end 
    end
end
assign wr_pix = (align) ? start_pix :
                (wr_cmd!=2'b00) ? start_pix+align_pix : start_pix;
always @(posedge clk or negedge rstb)
begin
    if(!rstb) begin
        Waddr<=0;
    end
    else begin
        if(bpp==1 | bpp==2) begin //16bpp
            if(cs==READY) 
                if(wr_cmd==2'b00)
                    Waddr <= new_img_addr + wr_pix + send_size;//*2 1픽셀이 2byte
                else
                    Waddr <= new_img_addr + {6'd0,wr_pix,1'b0} + send_size;//*2 1픽셀이 2byte
        end
        else if(bpp==3) begin//24bpp
            if(cs==READY) begin
                if(wr_cmd==2'b00)
                    Waddr <= new_img_addr + wr_pix + send_size;//*3 1픽셀이 3byte
                else
                    Waddr <= new_img_addr + {6'd0,wr_pix,1'b0} + wr_pix + send_size;//*3 1픽셀이 3byte
            end
        end
        else begin //32bpp 
            if(cs==READY)
                if(wr_cmd==2'b00)
                    Waddr <= new_img_addr + wr_pix + send_size;//*4 1픽셀이 4byte
                else
                    Waddr <= new_img_addr + {5'd0,wr_pix,2'b00} + send_size;//*4 1픽셀이 4byte
        end
    end
end

// Wsize calculation
always @(posedge clk or negedge rstb)
begin
    if(!rstb) begin
        cont<=0;
        Wsize<=0;
        full_dly<=0;
        send_size<=0;
    end
    else begin
        full_dly<=full;
        //if(full & ~t_last) cont<=1;
        //buffer full 일때 size_cnt>=25면 이어서 전송한다
        //if(size_cnt>=25 & full & ~full_dly & ~last_data) cont<=1;//8.3 revise
        if(size_cnt>=25 & full & ~full_dly & ~last_data) cont<=1;//8.28 pm 14
        else if(last_data & ~last_data_dly) cont<=0;
        if(ns==READY) begin
//            if(cont) send_size<=Wsize+1;
            if(cont) begin
                if(wr_cmd!=2'b00) 
                    send_size<=send_size+Wsize+1; //9.6 pm 10:50
                else send_size<=Wsize+1;
            end
            else send_size<=0;
        end
        else if(ns==WR_CMD) begin
            //if(wr_cmd==2'b01 | wr_cmd==2'b00) Wsize<=size_cnt-1;
            if(wr_cmd==2'b01 | wr_cmd==2'b00) Wsize<=l_size_cnt-1; //8.28 pm14
            else begin
                if(bpp==1 | bpp==2) Wsize<=5'd1; //9.4 pm 9:58
                else if(bpp==3) Wsize<=5'd2; //9.4 pm 9:58
                else Wsize<=5'd3; //9.4 pm 9:58
            end
        end
        else if(ns==WR_DATA) begin
            //send_size<=0;
            if(!cont) send_size<=0;//9.6 pm 10:50
        end
        
    end
end

//8.21 added
always @(posedge clk or negedge rstb)
begin
    if(!rstb) begin
        split_addr2<=0;
        split_addr5<=0;
    end
    else begin
        if(wr_cmd==2'b11 & wr_buf_en) begin
            if(addr[2:0]==2) split_addr2<=1'b1;
            else if(addr[2:0]==5) split_addr5<=1'b1;
        end
        else if(ns==IDLE & Wbusy & ~Wbusy_dly) begin
            split_addr2<=1'b0;
            split_addr5<=1'b0;
        end
    end
end
//

// read pointer calculation
always @(posedge clk or negedge rstb)
begin
    if(!rstb) begin
        rd_pointer<=0;
        //Wbusy_dly<=Wbusy;
        Wbusy_dly<=1'b1;
    end
    else begin
        Wbusy_dly<=Wbusy;
        if(split_addr2 | split_addr5) begin //8.21 added
            if(Wbusy & ~Wbusy_dly) begin 
                if(rd_pointer>=BUFFSIZE-1)
                    rd_pointer<=0;
                else 
                    rd_pointer<=rd_pointer+1;
            end
        end// 8.21 
        else if(Wready | (Wbusy==1 & Wbusy_dly==0)) begin
            if(rd_pointer>=BUFFSIZE-1)
                rd_pointer<=0;
            else 
                rd_pointer<=rd_pointer+1;
        end
    end
end
// write pointer calculation
always @(posedge clk or negedge rstb)
begin
    if(!rstb) begin
        wr_pointer<=0;
    end
    else begin
        if(c_ns==CONV_DSAVE & ~full &~ pause) begin
            if(wr_pointer==BUFFSIZE-1) wr_pointer<=0;
            else wr_pointer<=wr_pointer+1;
        end

    end
end

//
// w_vertical시 총 wirte 개수 계산
//
always @(posedge clk or negedge rstb)
begin
    if(!rstb) begin
        rd_cnt<=0;
        wr_cnt<=0;
        all_wnum<=0;
    end
    else begin
        if(start) wr_cnt<=0;
        else if(wr_buf_en & ~wbuf_en) 
            wr_cnt<=wr_cnt+1;
        else if(wr_cmd==2'b11) begin 
            if(t_last) begin
                wr_cnt<=0;
                all_wnum<=wr_cnt;
            end
            else if(all_wnum==rd_cnt)
                all_wnum<=0;
        end
        else if(wr_cmd==2'b10) all_wnum<=6'd3; //wr_cmd2'b10 du_NoVresize
        
        //if(Wbusy & ~Wbusy_dly) rd_cnt<=rd_cnt+1; //8.19
        if(start) rd_cnt<=0;
        else if(cs==WR_CMD & ns==WR_DATA) rd_cnt<=rd_cnt+1;
        else if(wv_end) rd_cnt<=0;
    end
end

//  ============================================
//			color conversion
//	bpp 0: 15bpp format unused R G B(1555)
//	bpp 1: 16bpp format R G B (565)
//  bpp 2: 24bpp format BRGB RGBR GBRG BRGB......
//  bpp 3: 32bpp format 1) unused B R G (8888)
//  bpp 4:              2) A R G B (8888)
//  ============================================
assign addr = (align) ? new_img_addr+new_pix_num : 
                        new_img_addr+new_pix_num+addr_align_pix; 
wire[1:0] addr1_0;
wire[2:0] addr2_0;
reg [2:0] addr2_0_dly;

assign addr1_0 = addr[1:0];
assign addr2_0 =(t_last) ? addr2_0_dly : addr[2:0];


always @(posedge clk or negedge rstb)
begin
    if(!rstb) begin
        addr2_0_dly<=0;
    end
    else begin
        addr2_0_dly<=addr[2:0];
    end
end

always @(addr or addr2_0 or bpp) 
begin
    if(bpp==1 | bpp==2) begin
        rest_be<=8'b00000000;
        case(addr[1:0])  // synopsys parallel_case
            2'b00  : be<=8'b00000011;
            2'b01  : be<=8'b00001100;
            2'b10  : be<=8'b00110000;
            default: be<=8'b11000000;
        endcase
    end
    else if(bpp==3) begin
        case(addr2_0)  // synopsys parallel_case
            3'b000: begin
                be<=8'b00000111;
                rest_be<=8'b00000000;
            end
            3'b001: begin
                be<=8'b00111000;
                rest_be<=8'b00000000;
            end
            3'b010: begin
                be     <=8'b11000000;
                rest_be<=8'b00000001;
            end
            3'b011: begin
                be<=8'b00001110;
                rest_be<=8'b00000000;
            end
            3'b100: begin
                be<=8'b01110000;
                rest_be<=8'b00000000;
            end
            3'b101: begin  
                be     <=8'b10000000;
                rest_be<=8'b00000011;
            end
            3'b110: begin
                be<=8'b00011100;
                rest_be<=8'b00000000;
            end
            default: begin
                be<=8'b11100000;
                rest_be<=8'b00000000;
            end
        endcase        
    end
    else begin
        rest_be<=8'b00000000;
        if(addr[0]==0)
            be<=8'b00001111;
        else
            be<=8'b11110000;
    end
end


//  ============================================
//  color conversion current state
//  ============================================
always @(posedge clk or negedge rstb)
begin
    if(!rstb) 
        c_cs<=CONV_IDLE;
    else 
        c_cs<=c_ns;
end
//  ============================================
//  color conversion next state
//  ============================================

assign bpp16 = ((bpp==1 | bpp==2)&(addr[1:0]==3)) ? 1'b1 : 1'b0;
assign bpp24 = ((bpp==3) & (addr[2:0]==2 | addr[2:0]==5 | addr[2:0]==7)) ? 1'b1 : 1'b0;
assign bpp32 = ((bpp==5 | bpp==4) & addr[0]==1) ? 1'b1 : 1'b0;

assign save = (wr_cmd!=2'b11) ? 
              (wbuf_en & (bpp16 | bpp24 | bpp32)) | (t_last & ~not_save) : 
              wbuf_en;

assign calc_info = wr_buf_en & ~wbuf_en;

always @(posedge clk or negedge rstb)
begin
    if(!rstb) begin
        wbuf_en<=0;
        not_save<=0;
    end
    else begin
        wbuf_en<=wr_buf_en;
        if( bpp16 | bpp32 | ((bpp==3) & (addr[2:0]==7)) ) not_save<=1'b1;
        else not_save<=1'b0;
    end
end
always @(c_cs or calc_info or finish_conv or save or scale_end)
begin
    case(c_cs) // synopsys parallel_case
        CONV_IDLE :
            if(calc_info) c_ns<=CONV_DCALC;
            else c_ns<=CONV_IDLE;
        CONV_DCALC :
            if(save) c_ns<=CONV_DSAVE;
            else c_ns<=CONV_WAIT;
        CONV_WAIT :
            if(calc_info) c_ns<=CONV_DCALC;
            else if(finish_conv | scale_end) c_ns<=CONV_IDLE;
            else if(save) c_ns<=CONV_DSAVE;
            else c_ns<=CONV_WAIT;
        CONV_DSAVE :
            if(save) c_ns<=CONV_DSAVE;
            else if(calc_info) c_ns<=CONV_DCALC;
            else if(finish_conv) c_ns<=CONV_IDLE;
            else c_ns<=CONV_WAIT;
        default:
            c_ns<=CONV_IDLE;
    endcase
end



always @(posedge clk or negedge rstb)
begin
    if(!rstb) begin
        overlap_size<=0;
    end
    else begin
        if(c_ns==CONV_DSAVE & overlap) overlap_size<=overlap_size+byte;
        else if(cs==WR_CMD) overlap_size<=0;
    end
end

wire[15:0] data_1555;
wire[15:0] data_565;

assign data_1555 = {1'b0,result_pixel[23:19],
                         result_pixel[15:11],
                         result_pixel[ 7:3 ]};
assign data_565  = {result_pixel[23:19],
                    result_pixel[15:10],
                    result_pixel[ 7:3 ]};

// byte enable calculation
// prepare Wdata
always @(posedge clk or negedge rstb)
begin
    if(!rstb) begin
        tbe<=0;
        tdata<=0;
        size_cnt<=0;
        rest_data<=0;
        l_size_cnt<=0;
//        overlap_size<=0;
//        wr_pointer<=0;
        finish_conv<=0;
        w_buf[0]<=0; w_buf[1]<=0;
        w_buf[2]<=0; w_buf[3]<=0;
        be_buf[0]<=0; be_buf[1]<=0;
        be_buf[2]<=0; be_buf[3]<=0;

    end
    else begin
        finish_conv<=t_last;
        if(finish_conv==1'b1 || (full & ~full_dly & ~last_data)) l_size_cnt<=size_cnt;//8.28 pm14

        if(c_ns==CONV_IDLE) begin
            tbe<=0;
            tdata<=0;
            rest_data<=0;
            //if(cs==WR_CMD) size_cnt<=0;//8.16 new
            if(ns==WR_CMD) size_cnt<=overlap_size;//8.28 pm 14
        end
        else if(c_ns==CONV_DCALC) begin 
            tbe<=tbe | be;
            case(bpp) // synopsys parallel_case 
            1: begin//16bpp1555
                tdata<=tdata | 
                    { {8{be[7:6]}}&data_1555,{8{be[5:4]}}&data_1555,
                      {8{be[3:2]}}&data_1555,{8{be[1:0]}}&data_1555 };
            end
            2: begin//16bpp565
                tdata<=tdata | 
                    { {8{be[7:6]}}&data_565,{8{be[5:4]}}&data_565,
                      {8{be[3:2]}}&data_565,{8{be[1:0]}}&data_565 };
            end
            3: begin//24bpp888
                if(addr[2:0]<3) begin
                    tdata<=tdata | 
                           { {8{be[7]}  }&result_pixel[15:8],
                             {8{be[6]}  }&result_pixel[7:0],
                             {8{be[5:3]}}&result_pixel[23:0],
                             {8{be[2:0]}}&result_pixel[23:0] };
                    if(addr[2:0]==2) begin
                        /*if(wr_pointer==7)
                            rest_data[7:0]<=result_pixel[23:16];
                        else */
                            rest_data[7:0]<=result_pixel[23:16];
                    end
                    else rest_data<=0;
                end
                else if(addr[2:0]<6) begin 
                    tdata<=tdata | 
                          { {8{be[7]}}  &result_pixel[ 7:0],
                            {8{be[6:4]}}&result_pixel[23:0],
                            {8{be[3:1]}}&result_pixel[23:0],
                             8'h00 };
                    if(addr[2:0]==5) begin
                        rest_data[15:0]<=result_pixel[23:8];
                    end
                    else rest_data<=0;
                end
                else if(addr[2:0]<8) begin
                    tdata<=tdata | 
                          { { {8{be[7:5]}} }&result_pixel[23:0],
                            { {8{be[4:2]}} }&result_pixel[23:0],{16{1'b0}} };
                    rest_data<=0;
                end
            end
            default : begin//32bpp1888 or 32bpp8888
                tdata<=tdata | { {8{be[7:4]}}&result_pixel,
                                {8{be[3:0]}}&result_pixel };
            end
            endcase // end case
//            if(cs==WR_CMD) size_cnt<=0;//8.16 new
            if(ns==WR_CMD) size_cnt<=overlap_size;//8.28 pm 14
        end
        else if(c_ns==CONV_DSAVE) begin
//            if(overlap) overlap_size<=overlap_size + byte;
            if(wr_cmd==2'b11 & (split_addr2 | split_addr5)) begin // down_up size(wr_cmd==2'b11)
                tdata<=0;
                if(~pause & ~full) begin
                    be_buf[wr_pointer]<=be;//8.30 am 11 revise
                    w_buf[wr_pointer]<=tdata | rest_data;
                    if(cs==WR_CMD | overlap) size_cnt<=byte;
                    else size_cnt<=size_cnt+byte; 
                    //size_cnt<=size_cnt+byte; 
                end
            end
            else begin
                tbe<=rest_be;
                tdata<=rest_data;
                if(~pause & ~full) begin
                    be_buf[wr_pointer]<=tbe;
                    w_buf[wr_pointer]<=tdata;
                    if(cs==WR_CMD | overlap) size_cnt<=byte;
                    else size_cnt<=size_cnt+byte; 
                    //size_cnt<=size_cnt+byte; 
                end
            end
        end
        else if(c_ns==CONV_WAIT) begin
//            if(cs==WR_CMD) size_cnt<=0;//8.16 new
            if(ns==WR_CMD) size_cnt<=overlap_size;//8.28 pm 14
        end
        //if(cs==WR_CMD) size_cnt<=0;//8.16 revise
        /*
        if(c_cs==CONV_DSAVE) begin
            if(full | size_cnt==32) size_cnt<=0;
        end
        else if(cs==WR_CMD) size_cnt<=0;
        */ //8.3 revise

    end
end
// synopsys translate_off
reg [8*10 : 1] NState;
always @(ns)
begin 
    case(ns) 
        IDLE   : NState = "IDLE"; 
        READY  : NState = "READY";
        WR_CMD : NState = "WR_CMD";
        WR_DATA: NState = "WR_DATA";
    endcase
end

reg [8*10 : 1] CState;
always @(cs)
begin  
    case(cs) 
        IDLE   : CState = "IDLE";  
        READY  : CState = "READY";
        WR_CMD : CState = "WR_CMD";
        WR_DATA: CState = "WR_DATA";
    endcase
end


reg [8*10 : 1] C_NState;
always @(c_ns)
begin 
    case(c_ns) 
        CONV_IDLE : C_NState = "CONV_IDLE";  
        CONV_DCALC: C_NState = "CONV_DCALC";
        CONV_WAIT : C_NState = "CONV_WAIT";
        CONV_DSAVE: C_NState = "CONV_DSAVE";
    endcase
end

reg [8*10 : 1] C_CState;
always @(c_cs)
begin  
    case(c_cs) 
        CONV_IDLE : C_CState = "CONV_IDLE";  
        CONV_DCALC: C_CState = "CONV_DCALC";
        CONV_WAIT : C_CState = "CONV_WAIT";
        CONV_DSAVE: C_CState = "CONV_DSAVE";
    endcase
end

// synopsys translate_on


endmodule

