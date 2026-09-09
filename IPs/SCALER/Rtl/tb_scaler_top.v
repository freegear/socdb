//*****************************************
// module name : tb_scaler_top.v
// by  : Brother
// date: 2006-7-10
//*****************************************

`timescale 1ns/10ps
`define SIZE 2048*2048*3

module tb_scaler_top;
//APB-IF
reg		 	pclk   ;
reg 	 	presetn;
reg[3:2] 	paddr  ;
reg		 	psel   ;
reg			penable;
reg			pwrite ;
reg [31:0]	pwdata ;
wire[31:0]	prdata ; 

//AXI-IF
reg    		clk    ;
reg    		rstb   ;
//reg  		Wready ;
wire   		Wbusy  ;  
wire    	WR     ;
wire[4:0]   Wsize  ;
wire[7:0]   Wbe    ;
wire[31:0]  Waddr  ;
wire[63:0]  Wdata  ;

wire        finish_write;
wire[31:0]  total_size;

wire   		Rbusy  ;
reg    		Rvalid ;
reg[ 7:0]   Rbe    ;
reg[63:0]   Rdata  ;
wire   		RD     ;
wire[ 4:0]  Rsize  ;
wire[31:0]  Raddr  ;

wire[31:0] addr;
reg [63:0] tdata;
reg [ 4:0] rbyte_cnt;
reg [31:0] l_addr;
reg        read;
reg [ 7:0] be;
reg [ 7:0] tbe;
reg        valid;
reg        valid_dly;
reg        busy;
reg        last;
reg        last_dly;
reg        enable;


wire[3:0] w_num;

reg[ 7:0] w_size;
reg[ 7:0] trans_size;
reg[ 7:0] byte_cnt;

///
parameter   IDLE =4'b0001;
parameter   LOAD =4'b0010;
parameter   WRITE=4'b0100;
parameter   WAIT =4'b1000;

reg[63:0] data_64;
reg[31:0] dst_addr;
reg[ 3:0] ns;
reg[ 3:0] cs;
reg       load;
reg[ 7:0] l_wbe;
reg[31:0] start_addr;
wire go_idle;
wire go_wait;
reg[7:0] data_8;
wire[7:0] mem_be;
//
reg[7:0] src_mem[`SIZE:0];
reg[7:0] dst_mem[`SIZE:0];

parameter DLY = 20;

integer i;

initial begin
    $readmemh("input.dat",src_mem);
	paddr=0;
	psel=0;
	pwrite=0;
	pwdata=0;
	penable=0;
	rstb=0;
	clk=0;
	pclk=0;
	presetn=0;
	#100 rstb=1;
	presetn=1;
end	

always #(DLY/2) clk<=~clk;
always #DLY pclk<=~pclk;

scaler_top tb_scaler_top(
    .pclk         (pclk    ),
	.presetn      (presetn ),
	.paddr        (paddr   ),
	.psel         (psel    ),
	.penable      (penable ),
	.pwrite       (pwrite  ),
	.pwdata       (pwdata  ),
	.prdata       (prdata  ),
    //AXI-IF(//AXI-IF)
    .clk          (clk     ),
    .rstb         (rstb    ),
    .Wready       (Wready  ),
    .Wbusy        (Wbusy   ), 
    .WR           (WR      ),
    .Wsize        (Wsize   ),
    .Wbe          (Wbe     ),
    .Waddr        (Waddr   ),
    .Wdata        (Wdata   ),
    .finish_write (finish_write ),
    .total_size   (total_size   ),

    .Rbusy        (Rbusy   ),
    .Rvalid       (Rvalid  ),
    .Rbe          (Rbe     ),
    .Rdata        (Rdata   ),
    .RD           (RD      ),
    .Rsize        (Rsize   ),
    .Raddr        (Raddr   )    
    );

task reg_write;
input[ 1:0]	addr;
input[31:0]	data;
begin
	@(posedge pclk)
		psel<=1'b1;
	pwrite<=1'b1;
	paddr<=addr;
	pwdata<=data;
	penable<=1'b0;
	@(posedge pclk) 
		penable<=1'b1;  
	@(posedge pclk)
		psel<=0;
	pwrite<=1'b0;
	penable<=1'b0;
	@(posedge pclk);					
end
endtask
	
task reg_read;
input[ 1:0]	addr;
input[31:0]	data;
begin
	@(posedge pclk)
		psel<=1'b1;
	pwrite<=1'b0;
	paddr<=addr;
	penable<=1'b0;
	@(posedge pclk) 
		penable<=1'b1; 
	@(posedge pclk)
		psel<=0;
	pwrite<=1'b0;
	penable<=1'b0;
    if(prdata!=data) begin
		$display($realtime,"      error");
    end
	@(posedge pclk);				
end
endtask
	
//  ============================================
//				color conversion
//	bpp 0: 15bpp format unused R G B(1555)
//	bpp 1: 16bpp format R G B (565)
//  bpp 2: 24bpp format BRGB RGBR GBRG BRGB......
//  bpp 3: 32bpp format 1) unused B R G (8888)
//  bpp 4:              2) A R G B (8888)
//  ============================================
//  ============================================
//	addr ::			register map
// 	0    : src size reg[31:0] : enable[31],src_width[27:16],src_height[11:0]
// 	1    : new size reg[31:0] : bpp[31:29],new_width[27:16],new_height[11:0]
// 	2    : src addr reg[31:0] : source image address
// 	3    : dst addr reg[31:0] : new image address
//  ============================================
// 				task foramt
// 	reg_write(addr,data)
// 	reg_read (addr)
//  ============================================

initial 
begin
	wait(rstb)
	repeat(10) @(posedge clk);
	reg_write(2'h1,{3'd3,1'd0,12'd640,4'd0,12'd480});//up_up
	//reg_write(2'h1,{3'd3,2'd0,11'd640,5'd0,11'd120});//up_dn
	//reg_write(2'h1,{3'd3,2'd0,11'd640,5'd0,11'd240});//up_NoVresize
	reg_write(2'h2,32'h00000000);
	reg_write(2'h3,32'h90000000);
	reg_write(2'h0,{1'b1,3'd0,12'd220,4'd0,12'd240});
	reg_write(2'h0,{1'b0,3'd0,12'd220,4'd0,12'd240});

	reg_read(2'h1,{3'd3,2'd0,11'd640,5'd0,11'd480});
	reg_read(2'h2,32'h00000000);
	reg_read(2'h3,32'h90000000);
	reg_read(2'h0,{1'b0,4'd0,11'd320,5'd0,11'd240});

end	
//  ============================================
//			WRITE DESTINATION MEMORY
//  ============================================
integer result;
integer debug;

reg start_fileout;
initial begin
    result=$fopen("result.dat");
    debug=$fopen("debug.dat");
end



always @(clk) 
begin
    if(start_fileout) begin
        for(i=0;i<total_size;i=i+1)
            $fwrite(result,"%h\n",dst_mem[i]);
        #1000 $stop;
    end
end




always @(posedge clk or negedge rstb)
begin
    if(!rstb) begin
        start_fileout<=0;
    end
    else begin 
        if(finish_write)
            start_fileout<=1;
    end
end

//assign temp = (trans_size==0)

assign go_idle = ( (cs==WRITE) & ((trans_size)==byte_cnt) ) ? 1'b1 : 1'b0;
//assign go_wait=(dst_addr[2:0]==7) ? 1'b1 : 1'b0;
assign go_wait=(byte_cnt[2:0]==7) ? 1'b1 : 1'b0;
/*
reg idle;
always @(posedge clk or negedge rstb)
begin
    if(!rstb) idle<=1'b0;
    else begin
        if(go_idle & go_wait) idle<=1'b1;
        else if(ns==IDLE) idle<=1'b0;
    end
end
*/
////cs
always @(posedge clk or negedge rstb)
begin
    if(!rstb) cs<=IDLE;
    else cs<=ns;
end

/////ns
//always @(cs or go_idle or go_wait or load or WR or Wready or idle)
always @(cs or go_idle or go_wait or load or WR or Wready)
begin
    case(cs)
        IDLE: begin 
            if(WR | Wready) ns<=LOAD;
            else ns<=IDLE;
        end
        LOAD: begin
            ns<=WRITE;
        end
        WRITE: begin
            if(go_idle) ns<=IDLE;
            else if(go_wait) ns<=WAIT;
            else ns<=WRITE;
        end
        WAIT: begin
//            if(go_idle | idle) ns<=IDLE;
            if(go_idle) ns<=IDLE;
            else ns<=WRITE;
        end

    endcase
end


always @(posedge clk or negedge rstb)
begin
    if(!rstb) begin
        dst_addr<=0;
        byte_cnt<=0;
     //   for(i=0;i<12582912;i=i+1) begin
    //    for(i=0;i<100000;i=i+1) begin
     //       dst_mem[i]<=0;
      //  end
    end
    else begin
        if(cs==LOAD) dst_addr<=start_addr-32'h90000000;//img_start addr »©ÁØ´Ù
        else if(cs==WRITE) begin
            if(Wready==0) begin
                dst_addr<=dst_addr+1;
                byte_cnt<=byte_cnt+1;
            end
        end
        if(ns==IDLE) begin
            dst_addr<=0;
            byte_cnt<=0;
        end

        if(cs==WRITE) begin 
            dst_mem[dst_addr] = data_8;
            $fwrite(debug,"addr : %d  :: data : %h\n",dst_addr,data_8);
        end
    end
end

always @(posedge clk or negedge rstb)
begin
    if(!rstb) begin
        data_64<=0;
        l_wbe<=0;
    end
    else begin
        if(Wready) begin
            data_64<=Wdata;
            l_wbe<=Wbe;
        end
    end
end

always @(dst_addr or cs or data_64) 
begin
    if(cs==WRITE) begin
        case(dst_addr[2:0])
            3'b000:  data_8<=data_64[ 7:0 ];
            3'b001:  data_8<=data_64[15:8 ];
            3'b010:  data_8<=data_64[23:16];
            3'b011:  data_8<=data_64[31:24];
            3'b100:  data_8<=data_64[39:32];
            3'b101:  data_8<=data_64[47:40];
            3'b110:  data_8<=data_64[55:48];
            3'b111:  data_8<=data_64[63:56];
        endcase        
    end
    else
        data_8<=0;
end

reg [8*10 : 1] NState;
always @(ns)
begin 
    case(ns) 
        IDLE:  NState = "IDLE";  
        LOAD:  NState = "LOAD";
        WRITE: NState = "WRITE";
        WAIT:  NState = "WAIT";
    endcase
end

reg [8*10 : 1] CState;
always @(cs)
begin  
    case(cs) 
        IDLE:  CState = "IDLE";  
        LOAD:  CState = "LOAD";
        WRITE: CState = "WRITE";
        WAIT:  CState = "WAIT";
    endcase
end

//  ============================================
//			AXI-IF
//  ============================================
assign w_num  = l_wbe[7]+l_wbe[6]+l_wbe[5]+l_wbe[4]+
                l_wbe[3]+l_wbe[2]+l_wbe[1]+l_wbe[0];

//			AXI-IF (WRITE)
assign Wbusy  = (cs!=IDLE) ? 1'b0 : 1'b1; 
assign Wready = ((cs==LOAD | cs==WAIT)) ? 1'b1 : 1'b0;
always @(posedge clk or negedge rstb)
begin
    if(!rstb) begin
        w_size<=0;
        //Wready<=0;
        trans_size<=0;
        start_addr<=0;
        load<=0;
    end
    else begin
        load<=0;
        if(WR) begin
            start_addr<=Waddr;
            trans_size<=Wsize;
            load<=1'b1;
            //Wready<=1'b1; 
        end
        else begin

            if((trans_size-w_size)<8) begin
                w_size<=0;
            end
            else begin
                w_size<=w_size+w_num;
            end
            
        end
    end
end

//			AXI-IF (READ)
assign addr = l_addr + rbyte_cnt;
always @(posedge clk or negedge rstb) 
begin
    if(!rstb) begin
        Rbe<=0;
        Rdata<=0;
        Rvalid<=0;
        l_addr<=0;
        read<=0;
        valid<=0;
        valid_dly<=0;
        rbyte_cnt<=0;
        last<=0;
        last_dly<=0;
        enable<=0;
        tdata<=0;
        busy<=0;
    end
    else begin
        #1
        valid_dly<=valid;
        last_dly<=last;
        if(valid==1 & valid_dly==0) begin
            Rvalid<=1'b1;
            Rbe<=tbe;
            Rdata<=tdata;
            tdata<=0;
        end
        else begin
            Rvalid<=1'b0;
        end
        if(RD) begin
            l_addr<=Raddr;
            enable<=1;
            read<=1'b1;
            last<=0;
            busy<=1'b1;
        end
        valid<=0;
        if(read) begin
            rbyte_cnt<=rbyte_cnt+1;
            if(addr[2:0]==3'b111 | rbyte_cnt==(Rsize-1)) begin
                read<=0;
                valid<=1'b1;
            end
                
            tdata<= tdata | 
                { {( {8{be[7]}} & src_mem[addr] )},{( {8{be[6]}} & src_mem[addr] )}, 
                  {( {8{be[5]}} & src_mem[addr] )},{( {8{be[4]}} & src_mem[addr] )}, 
                  {( {8{be[3]}} & src_mem[addr] )},{( {8{be[2]}} & src_mem[addr] )},     
                  {( {8{be[1]}} & src_mem[addr] )},{( {8{be[0]}} & src_mem[addr] )} };
        end
        else begin
            if(rbyte_cnt!=Rsize) begin
                if(enable) read<=1'b1;
            end
            else begin
                busy<=0;
                if(rbyte_cnt!=0) begin
                    last<=1;
                    enable<=0;
                end
                read<=1'b0;
                rbyte_cnt<=0;
            end
        end
    end
end

assign Rbusy = busy;


// byte enable
always @(posedge clk or negedge rstb) 
begin
    if(!rstb)
        tbe<=0;
    else begin
        #1
        if(read==0) tbe<=0;
        else if(read)
           tbe<=tbe | be;

    end
end

always @(addr) 
begin
    case(addr[2:0])
        3'b000:  be<=8'b00000001;
        3'b001:  be<=8'b00000010;
        3'b010:  be<=8'b00000100;
        3'b011:  be<=8'b00001000;
        3'b100:  be<=8'b00010000;
        3'b101:  be<=8'b00100000;
        3'b110:  be<=8'b01000000;
        default: be<=8'b10000000;
    endcase        
end


endmodule
