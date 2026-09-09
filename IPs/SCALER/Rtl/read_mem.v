//*****************************************
// module name : read_mem.v
// by  : Brother
// date: 2006-6-29
//************************************

//  ============================================
//  BUS WIDTH : 64 bit(8byte)
//
//  read_mem에서 한번에 읽는 픽셀은 4개  
//  16bpp는  8byte를 읽는다 
//  24bpp는 12byte를 읽는다 
//  32bpp는 16byte를 읽는다
//  ============================================

`timescale 1ns/10ps

module read_mem(
    clk,
    rstb,
// from reg_block
    bpp,
    src_width,
    src_img_addr,
// from scaler    
    rd_cmd,
    rd_num,
    fill_buf, 
    rd_pix_num,
// to scaler
    end_fill,
    read_busy,
    buf_a,
    buf_r,
    buf_g,
    buf_b,
//  BUS-IF    
    Rbusy,
    Rvalid,
    Rbe,
    Rdata,
    RD,
    Rsize,
    Raddr
);

input clk;
input rstb;

// from reg_block
input[ 2:0] bpp;
input[11:0] src_width;
input[31:0] src_img_addr;

// from scaler    
input[ 2:0] rd_cmd;
input[ 2:0] rd_num;
input       fill_buf;
input[22:0] rd_pix_num;

//to scaler
output       end_fill;
output       read_busy;
output[95:0] buf_a;
output[95:0] buf_r;
output[95:0] buf_g;
output[95:0] buf_b;

input        Rbusy;
input        Rvalid;
input [ 7:0] Rbe;
input [63:0] Rdata;
output       RD;
output[ 4:0] Rsize;
output[31:0] Raddr;



//state define
parameter IDLE       = 4'b0001;
parameter SETTING    = 4'b0010;
parameter ADDR_CALC  = 4'b0100;
parameter R_MEM      = 4'b1000;

reg[127:0] in_buf[2:0];

reg RD;
reg[31:0] Raddr;
reg[ 4:0] Rsize;

reg[63:0] l_Rdata;
reg[ 3:0] in_buf_num;

reg[3:0] cs;
reg[3:0] ns;

reg[ 2:0] read_cnt;
reg[22:0] latch_rd_pix_num;

reg[ 7:0] l_Rbe;

reg       read_busy;

reg[ 7:0] receive_byte;

reg[ 2:0] shift;

//
reg[ 1:0] cnt;
reg       Rvalid_dly;
reg[4:0]  byte;
reg       conversion;
reg       conversion_dly;

wire[3:0] num;
wire[7:0] byte_8;
//

wire[ 2:0] full_buf;


//  ============================================
//     A          R          G          B     
//  [ 31:24 ]  [ 23:16 ]  [ 15:8  ]  [  7:0  ]
//  [ 63:56 ]  [ 55:48 ]  [ 47:40 ]  [ 39:32 ]
//  [ 95:88 ]  [ 87:80 ]  [ 79:72 ]  [ 71:64 ]
//  [127:120]  [119:112]  [111:104]  [103:96 ]
//
//  buf_x = {a[11],a[10],a[9],a[8],
//           a[7] ,a[6] ,a[5],a[4],
//           a[3] ,a[2] ,a[1],a[0]};
//  ============================================
assign buf_a = {in_buf[2][127:120],in_buf[2][95:88],in_buf[2][63:56],in_buf[2][31:24],     
                in_buf[1][127:120],in_buf[1][95:88],in_buf[1][63:56],in_buf[1][31:24],     
                in_buf[0][127:120],in_buf[0][95:88],in_buf[0][63:56],in_buf[0][31:24]};    
                                                                                           
assign buf_r = {in_buf[2][119:112],in_buf[2][87:80],in_buf[2][55:48],in_buf[2][23:16],     
                in_buf[1][119:112],in_buf[1][87:80],in_buf[1][55:48],in_buf[1][23:16],     
                in_buf[0][119:112],in_buf[0][87:80],in_buf[0][55:48],in_buf[0][23:16]};    

assign buf_g = {in_buf[2][111:104],in_buf[2][79:72],in_buf[2][47:40],in_buf[2][15:8] ,      
                in_buf[1][111:104],in_buf[1][79:72],in_buf[1][47:40],in_buf[1][15:8] ,      
                in_buf[0][111:104],in_buf[0][79:72],in_buf[0][47:40],in_buf[0][15:8] };     
                                                                                           
assign buf_b = {in_buf[2][103:96],in_buf[2][71:64],in_buf[2][39:32],in_buf[2][7:0],        
                in_buf[1][103:96],in_buf[1][71:64],in_buf[1][39:32],in_buf[1][7:0],        
                in_buf[0][103:96],in_buf[0][71:64],in_buf[0][39:32],in_buf[0][7:0]};       

assign full_buf = in_buf_num;
assign end_fill = (cs==IDLE) ? conversion_dly : 1'b0;
//  ============================================
//			AXI-IF
//  ============================================
assign go_idle=(read_cnt==rd_cmd[1:0]) ? 1'b1 : 1'b0;
//reg go_setting;
//assign go_setting=(cs==R_MEM & read_cnt!=rd_cmd[1:0] & Rvalid_dly==1 ) ? Rbusy : 1'b0;
assign go_setting = (cs==R_MEM & read_cnt!=rd_cmd[1:0] & receive_byte-1==Rsize) ? Rvalid_dly : 1'b0;
always @(posedge clk or negedge rstb)
begin
    if(!rstb) begin
        RD<=0;
        Rsize<=0;
        Raddr<=0;
        read_cnt<=0;
        l_Rbe<=0;
        l_Rdata<=0;
        read_busy<=0;
        latch_rd_pix_num<=0;
        receive_byte<=0;
    end
    else begin
        if(ns==SETTING) begin
            if(go_setting)
                latch_rd_pix_num<=latch_rd_pix_num+src_width;
            else 
                latch_rd_pix_num <= rd_pix_num;
        end
        else if(ns==ADDR_CALC) begin
            if(bpp==1 | bpp==2)
                Raddr<=src_img_addr+{latch_rd_pix_num,1'b0}; //*2
            else if(bpp==3)
                Raddr<=src_img_addr+{latch_rd_pix_num,1'b0}+latch_rd_pix_num; // *3
            else if(bpp==4 | bpp==5)
                Raddr<=src_img_addr+{latch_rd_pix_num,2'b00};//*4
            //read_size
            if(bpp==1 | bpp==2) begin
                Rsize<={rd_num,1'b0}-1; // rd_num(pixel num) * 2(byte)=read byte
            end
            else if(bpp==3) begin
                Rsize<={rd_num,1'b0}+rd_num-1; // rd_num(pix_num) *3(byte)=read byte
            end
            else if(bpp==4 | bpp==5) begin
                Rsize<={rd_num,2'b00}-1; //rd_num(pix_num) * 4(byte) =read byte
            end
            RD<=1'b1;
        end
        else if(ns==R_MEM) begin
            RD<=1'b0;
        end
        
        if(receive_byte-1==Rsize & receive_byte!=0) begin
            if(rd_cmd[1:0]!=read_cnt)
                read_cnt<=read_cnt+1;
            else 
                read_cnt<=0;
        end

        if(fill_buf) begin
            read_busy<=1;
        end
//       else if(cs==IDLE & conversion) begin
       else if(cs==IDLE) begin//8.30 pm 11:21
            read_busy<=0;
        end
        if(read_cnt==rd_cmd[1:0]) begin
            read_cnt<=0;
        end
        
        if(ns!=R_MEM) receive_byte<=0;
        
        //latch data,be
        if(Rvalid) begin
            receive_byte<=receive_byte+Rbe[7]+Rbe[6]+Rbe[5]+Rbe[4]+
                                       Rbe[3]+Rbe[2]+Rbe[1]+Rbe[0];
            l_Rdata<=Rdata;
            l_Rbe<=Rbe;
        end
        
    end
end


//  ============================================
//			current_state
//  ============================================
always @(posedge clk or negedge rstb)
begin
    if(!rstb) cs<=IDLE;
    else cs<=ns;
end
//  ============================================
//			next_state
//  ============================================
always @(cs or fill_buf or go_setting or go_idle or Rbusy)
begin
    case(cs) // synopsys parallel_case
        IDLE: 
            if(fill_buf) ns<=SETTING;
            else ns<=IDLE;
        SETTING:
            if(go_idle) ns<=IDLE;
            else if(Rbusy) ns<=ADDR_CALC;
            else ns<=SETTING;
//            else ns<=ADDR_CALC;
        ADDR_CALC:
            if(go_idle) ns<=IDLE;
            else ns<=R_MEM;
        R_MEM:
            if(go_idle) ns<=IDLE;
            else if(go_setting) ns<=SETTING;
            else ns<=R_MEM;
        default:
            ns<=IDLE;
    endcase
end

// synopsys translate_off
reg [8*10 : 1] next_state;
always @(ns)
begin 
    case(ns) 
        IDLE        : next_state = "IDLE";  
        SETTING     : next_state = "SETTING";
        ADDR_CALC   : next_state = "ADDR_CALC";
        R_MEM       : next_state = "R_MEM";
    endcase
end

reg [8*10 : 1] current_state;
always @(cs)
begin  
    case(cs) 
        IDLE        : current_state = "IDLE";  
        SETTING     : current_state = "SETTING";
        ADDR_CALC   : current_state = "ADDR_CALC";
        R_MEM       : current_state = "R_MEM";
    endcase
end
// synopsys translate_on
//  ============================================
//			color conversion
//	bpp 1: 15bpp format unused R G B(1555)
//	bpp 2: 16bpp format R G B (565)
//  bpp 3: 24bpp format BRGB RGBR GBRG BRGB......
//  bpp 4: 32bpp format 1) unused B R G (8888)
//  bpp 5:              2) A R G B (8888)
//  ============================================

// 바이트 수 
assign num   = l_Rbe[7]+l_Rbe[6]+l_Rbe[5]+l_Rbe[4]+
               l_Rbe[3]+l_Rbe[2]+l_Rbe[1]+l_Rbe[0];

assign byte_8 = l_Rbe ^~ 8'b0000_0000;


always @(posedge clk or negedge rstb)
begin
    if(!rstb) begin
        shift<=0;
    end
    else begin
        if(Rvalid & ~Rvalid_dly & cnt==0) begin
//        if(Rvalid_dly & cnt==0) begin //8.2 revise Rbe=> l_Rbe로 바꿈
            if(bpp==1 | bpp==2) begin
                case(Rbe)  // synopsys parallel_case
                    8'b1111_1111 : shift<=0;
                    8'b1111_1100 : shift<=2;
                    8'b1111_0000 : shift<=4;
                    8'b1100_0000 : shift<=6;
                    default : shift<=0;
                endcase
            end
            if(bpp==3) begin
                if(Rbe==8'b1111_1111) shift<=0;
                else if(Rbe[1]) shift<=1;
                else if(Rbe[2]) shift<=2;
                else if(Rbe[3]) shift<=3;
                else if(Rbe[4]) shift<=4;
                else if(Rbe[5]) shift<=5;
                else if(Rbe[6]) shift<=6;
                else if(Rbe[7]) shift<=7;
                else shift<=0;
            end
            if(bpp==4 | bpp==5) begin
                if(Rbe==8'b1111_0000) shift<=4;
                else shift<=0;
            end
        end
    end
end


    
always @(posedge clk or negedge rstb)
begin
    if(!rstb) begin
        in_buf[0]<=0; 
        in_buf[1]<=0; 
        in_buf[2]<=0;
        cnt<=0;
        byte<=0;
        Rvalid_dly<=0;
        conversion<=0;
        conversion_dly<=0;
    end
    else begin
        conversion_dly<=conversion;
        Rvalid_dly<=Rvalid;
        if(byte-1==Rsize) begin
            cnt<=0;
            byte<=0;
            if(Rsize!=0) conversion<=1;
        end
        if(Rvalid_dly) begin
            byte<=byte+num;
            if(cnt==0) begin
                if(byte_8==0) begin
                    in_buf[in_buf_num]<=l_Rdata;
                end
                else begin
                    in_buf[in_buf_num]<=l_Rdata>>{shift,3'b000};//shift*8
                end
                cnt<=cnt+1;
            end
            else if(cnt==1) begin
                in_buf[in_buf_num]<=in_buf[in_buf_num] | ( {l_Rdata,{64{1'b0}}}>>{shift,3'b000} );
                cnt<=cnt+1;
            end
            else if(cnt==2) begin
                in_buf[in_buf_num]<=in_buf[in_buf_num] | ( {l_Rdata,{128{1'b0}}}>>{shift,3'b000} );
                cnt<=0;
            end
        end
        if(conversion) begin
            case(bpp) // synopsys parallel_case
            1: begin
            //  ==========================================================
            //  16bpp 1555(unused R G B)
            //  [63:48] [47:32] [31:16] [15:0]
            //	 x      R       G       B     x      R		 G       B
            //  [31] [30:26] [25:21] [20:16] [15] [14:10] [ 9:5 ] [ 4:0 ]
            //  [63] [62:58] [57:53] [52:48] [47] [46:42] [41:37] [36:32]
            //  ==========================================================
                in_buf[in_buf_num]<=
                    {8'd0,in_buf[in_buf_num][62:58],3'd0,in_buf[in_buf_num][57:53],3'd0,in_buf[in_buf_num][52:48],3'd0,
                     8'd0,in_buf[in_buf_num][46:42],3'd0,in_buf[in_buf_num][41:37],3'd0,in_buf[in_buf_num][36:32],3'd0,
                     8'd0,in_buf[in_buf_num][30:26],3'd0,in_buf[in_buf_num][25:21],3'd0,in_buf[in_buf_num][20:16],3'd0,
                     8'd0,in_buf[in_buf_num][14:10],3'd0,in_buf[in_buf_num][ 9:5 ],3'd0,in_buf[in_buf_num][ 4:0 ],3'd0};
            end
            2: begin//16bpp565
            //  ==========================================================
            //  16bpp 565(R G B)
            //  [63:48] [47:32] [31:16] [15:0]
            //	   R       G       B       R	   G       B
            //  [31:27] [26:21] [20:16] [15:11] [10:5 ] [ 4:0 ]
            //  [63:59] [58:53] [52:48] [47:43] [42:37] [36:32]
            //  ==========================================================
                in_buf[in_buf_num]<=
                    {8'd0,in_buf[in_buf_num][63:59],3'd0,in_buf[in_buf_num][58:53],2'd0,in_buf[in_buf_num][52:48],3'd0,
                     8'd0,in_buf[in_buf_num][47:43],3'd0,in_buf[in_buf_num][42:37],2'd0,in_buf[in_buf_num][36:32],3'd0,
                     8'd0,in_buf[in_buf_num][31:27],3'd0,in_buf[in_buf_num][26:21],2'd0,in_buf[in_buf_num][20:16],3'd0,
                     8'd0,in_buf[in_buf_num][15:11],3'd0,in_buf[in_buf_num][10:5 ],2'd0,in_buf[in_buf_num][ 4:0 ],3'd0};
            end
            3: begin//24bpp888
            //  ==========================================================
            //  24bpp 888(B G R) 이지만 RGB로 함 메모리에 쓰는 순서 같음
            //  [95:72] [71:48] [47:24] [23:0]
            //	   R       G       B       R	   G       B
            //  [47:40] [39:32] [31:24] [23:16] [15:7 ] [ 7:0 ]
            //  [95:88] [87:80] [79:72] [71:64] [63:56] [55:48]
            //  ==========================================================
                in_buf[in_buf_num]<=
                    {8'd0,in_buf[in_buf_num][95:72],8'd0,in_buf[in_buf_num][71:48],
                     8'd0,in_buf[in_buf_num][47:24],8'd0,in_buf[in_buf_num][23:0 ]};
            end
            default : begin//32bpp1888 or 32bpp8888
            //  ==========================================================
            //  32bpp 8888(unused B G R) 이지만 unused RGB로 함
            //  [127:96] [95:64] [63:32] [31:0]
            //	 unused       R         G         B    unused     R       G       B
            //  [ 63:56 ] [ 55:48 ] [ 47:40 ] [ 39:32] [31:24] [23:16] [15:7 ] [ 7:0 ]
            //  [127:120] [119:112] [111:104] [103:96] [95:88] [87:80] [79:72] [71:64]
            //  ==========================================================
            //  ==========================================================
            //  32bpp 8888(A B G R) 
            //  [127:96] [95:64] [63:32] [31:0]
            //	    A         R         G         B       A       R       G       B
            //  [ 63:56 ] [ 55:48 ] [ 47:40 ] [ 39:32] [31:24] [23:16] [15:7 ] [ 7:0 ]
            //  [127:120] [119:112] [111:104] [103:96] [95:88] [87:80] [79:72] [71:64]
            //  ==========================================================
            in_buf[in_buf_num]<=in_buf[in_buf_num];
            end
            endcase // end case
            conversion<=0;
        end
    end
end

//  ============================================
//	in_buf_num counter		
//  ============================================
always @(posedge clk or negedge rstb)
begin
    if(!rstb) begin
        in_buf_num<=0;
    end
    else begin
        if(fill_buf) begin
            if(rd_cmd[2]==0) in_buf_num<=0;
        end
        if(conversion) begin
            if(in_buf_num==2)
                in_buf_num<=0;
            else
                in_buf_num<=in_buf_num+1;
        end
    end
end


endmodule

