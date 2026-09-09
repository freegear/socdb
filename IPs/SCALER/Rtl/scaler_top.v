//*****************************************
// module name : scaler_top.v
// by  : Brother
// date: 2006-7-10
//*****************************************

`timescale 1ns/10ps

module scaler_top(
    //APB-IF
    pclk,
	presetn,
	paddr,
	psel,
	penable,
	pwrite,
	pwdata,
	prdata,
    //BUS-IF
    clk,
    rstb,
    Wready,
    Wbusy,    
    WR,
    Wsize,
    Wbe,
    Waddr,
    Wdata,
    // synopsys translate_off
    finish_write,
    total_size,
    bpp,
    // synopsys translate_on

    Rbusy,
    Rvalid,
    Rbe,
    Rdata,
    RD,
    Rsize,
    Raddr);

input 		 pclk;
input 		 presetn;
input [3:2]  paddr;
input 		 psel;
input 		 penable;
input 		 pwrite;
input [31:0] pwdata;
output[31:0] prdata;

//BUS-interface
input		 clk;
input        rstb;
input        Wready;
input        Wbusy;
output       WR;
output[ 4:0] Wsize;
output[ 7:0] Wbe;
output[31:0] Waddr;
output[63:0] Wdata;
// synopsys translate_off
output       finish_write;
output[31:0] total_size;
output[ 2:0] bpp;
// synopsys translate_on

input        Rbusy;
input        Rvalid;
input [ 7:0] Rbe;
input [63:0] Rdata;
output       RD;
output[ 4:0] Rsize;
output[31:0] Raddr;

wire       start;
wire[ 2:0] bpp;
wire[11:0] width;
wire[11:0] height;
wire[11:0] src_width;
wire[11:0] src_height;
wire[11:0] new_width;
wire[11:0] new_height;
wire[31:0] src_img_addr;
wire[31:0] new_img_addr;

wire[ 2:0] rd_cmd;
wire[ 2:0] rd_num;
wire	   fill_buf;
wire[95:0] buf_a;
wire[95:0] buf_r;
wire[95:0] buf_g;
wire[95:0] buf_b;

wire 	   wr_buf_en;
wire       st_init;
wire       t_init;
wire       t_last;
wire       last_width;
wire[ 1:0] wr_cmd;
wire[11:0] h_new_pix_num;
wire[22:0] v_new_pix_num;
wire[31:0] result_pixel;

wire[22:0] rd_pix_num;
wire       scale_end;
// synopsys translate_off
wire[31:0]  n_width;
assign n_width = (new_width[1:0]==1) ? new_width+2'b11 :
                 (new_width[1:0]==2) ? new_width+2'b10 :
                 (new_width[1:0]==3) ? new_width+2'b01 : new_width;
wire[2:0] mul; 
assign mul = (bpp==4 || bpp==5) ? 4 : 3;
assign total_size = n_width * new_height * mul;
// synopsys translate_on

reg_block Ureg_block(
	.pclk        (pclk        ),
	.presetn     (presetn     ),
	.paddr       (paddr       ),
	.psel        (psel        ),
	.penable     (penable     ),
	.pwrite      (pwrite      ),
	.pwdata      (pwdata      ),
	.prdata      (prdata      ),

    .finish_write(finish_write),
    .start       (start       ),
    .bpp         (bpp         ),
    .width       (width       ),
    .height      (height      ),
    .src_width   (src_width   ),
    .src_height  (src_height  ),
    .new_width   (new_width   ),
    .new_height  (new_height  ),
    .src_img_addr(src_img_addr),
    .new_img_addr(new_img_addr));
    
read_mem Uread_mem(   
    .clk         (clk         ),
    .rstb        (rstb        ),
	// from reg_block 
    .bpp         (bpp         ),
    .src_width   (src_width   ),
    .src_img_addr(src_img_addr),
	// from scaler       
    .rd_cmd      (rd_cmd      ),
    .rd_num      (rd_num      ),
    .fill_buf    (fill_buf    ),
    .rd_pix_num  (rd_pix_num  ),
	// to scaler   
    .end_fill    (end_fill    ),
    .read_busy   (read_busy   ),
    .buf_a       (buf_a       ),
    .buf_r       (buf_r       ),
    .buf_g       (buf_g       ),
    .buf_b       (buf_b       ),
	// AXI-IF         
    .Rbusy       (Rbusy       ),
    .Rvalid      (Rvalid      ),
    .Rbe         (Rbe         ),
    .Rdata       (Rdata       ),
    .RD          (RD          ),
    .Rsize       (Rsize       ),
    .Raddr       (Raddr       ));
    
write_mem Uwrite_mem(
    .clk          (clk          ),  
    .rstb         (rstb         ),  
    .start        (start        ),
    //from scaler                
    .wr_buf_en    (wr_buf_en    ),
    .st_init      (st_init      ),
    .t_init       (t_init       ),
    .t_last       (t_last       ),
    .last_width   (last_width   ),
    .scale_end    (scale_end    ),
    .wr_cmd       (wr_cmd       ),
    .result_pixel (result_pixel ),  
    .h_new_pix_num(h_new_pix_num),  
    .v_new_pix_num(v_new_pix_num),  
    //from reg block             
    .bpp          (bpp          ),
    .new_width    (new_width    ),
    .new_img_addr (new_img_addr ),  
    //AXI-interface              
    .Wready       (Wready       ),  
    .Wbusy        (Wbusy        ),  
    .WR           (WR           ),  
    .Wsize        (Wsize        ),  
    .Wbe          (Wbe          ),  
    .Waddr        (Waddr        ),  
    .Wdata        (Wdata        ),
    .finish_write (finish_write ),

    //to scaler                
    .pause        (pause        ));    
    
scaler Uscaler(
    .clk          (clk          ),  
    .rstb         (rstb         ),  
    // from reg_block          
    .start        (start        ), 
    .src_width    (src_width    ), 
    .src_height   (src_height   ), 
    .new_width    (new_width    ), 
    .new_height   (new_height   ), 
    .width        (width        ),
    .height       (height       ),
    // from read_mem block    
    .buf_a        (buf_a        ), 
    .buf_r        (buf_r        ), 
    .buf_g        (buf_g        ), 
    .buf_b        (buf_b        ), 
    .end_fill     (end_fill     ), 
    .read_busy    (read_busy    ),
    // from write_mem
    .pause        (pause        ),
    // to read_mem           
    .rd_cmd       (rd_cmd       ), 
    .rd_num       (rd_num       ),
    .fill_buf     (fill_buf     ),
    .rd_pix_num   (rd_pix_num   ),
    // to write_mem
    .wr_buf_en    (wr_buf_en    ),
    .st_init      (st_init      ),
    .t_init       (t_init       ),
    .t_last       (t_last       ),
    .last_width   (last_width   ),
    .scale_end    (scale_end    ),
    .wr_cmd       (wr_cmd       ),
    .h_new_pix_num(h_new_pix_num),
    .v_new_pix_num(v_new_pix_num),
    .result_pixel (result_pixel )); 
                            
    
    
endmodule    
    













