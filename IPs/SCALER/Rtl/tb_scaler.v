/****************************************************
******************************************************/

`timescale 1ns/10ps

`define   CLK_FREQ         10
`define   DLY               2
`define   SIZE		2048*2048

`define   fruit

module tb_sacler;



//================================================
// AXI bus signals
parameter            ID_WID  =    4;
parameter 			 ID_WIDTH = ID_WID;
parameter            WID_WIDTH = 4;	// AWID/WID/BID width
parameter 			 RID_WIDTH = 4;	// ARID/RID width
parameter 			 MASTER_WID = 4;
parameter 			 SID_WIDTH = ID_WID+MASTER_WID;

parameter 			 DATA_WIDTH = 64;
parameter 			 NUM_BYTE = DATA_WIDTH/8;


wire [WID_WIDTH-1:0] AWID;
wire [31:0] 		 AWADDR;
wire [3:0] 			 AWLEN;
wire [2:0] 			 AWSIZE;
wire [1:0] 			 AWBURST; // fixed
wire [1:0] 			 AWLOCK;  // fixed
wire [3:0] 			 AWCACHE; // fixed
wire [2:0] 			 AWPROT;  // fixed
wire 				 AWVALID;
wire 				 AWREADY;

wire [WID_WIDTH-1:0] WID;
wire [DATA_WIDTH-1:0]WDATA;
wire [NUM_BYTE-1:0]  WSTRB;
wire 				 WLAST;
wire 				 WVALID;
wire 				 WREADY;


wire [WID_WIDTH-1:0] BID;
wire [1:0] 			 BRESP;
wire 				 BVALID;
wire 				 BREADY;

//-------------------------------
wire [RID_WIDTH-1:0] ARID;
wire [31:0] 		 ARADDR;
wire [3:0] 			 ARLEN;
wire [2:0] 			 ARSIZE;
wire [1:0] 			 ARBURST;
wire [1:0] 			 ARLOCK;
wire [3:0] 			 ARCACHE;
wire [2:0] 			 ARPROT;
wire 				 ARVALID;
wire 				 ARREADY;

wire [RID_WIDTH-1:0] RID;
wire [DATA_WIDTH-1:0]RDATA;
wire [1:0] 			 RRESP;
wire 				 RLAST;
wire 				 RVALID;
wire 				 RREADY;
   
reg		 	pclk   ;
reg 	 	presetn;
reg[3:2] 	paddr  ;
reg		 	psel   ;
reg			penable;
reg			pwrite ;
reg [31:0]	pwdata ;
wire[31:0]	prdata ; 

//BUS-IF
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
wire[ 2:0]  bpp;

wire   		Rbusy  ;
wire  		Rvalid ;
wire[ 7:0]  Rbe    ;
wire[63:0]  Rdata  ;
wire   		RD     ;
wire[ 4:0]  Rsize  ;
wire[31:0]  Raddr  ;


always #(`CLK_FREQ/2)  clk <= ~clk;
always #(`CLK_FREQ  )  pclk<=~pclk;


/*
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
*/
/*
   //-------------------------------------------
   // Graphic bus
   reg 					 grd;
   reg [31:0] 			 graddr;
   reg [4:0] 			 grsize;
   wire [NUM_BYTE-1:0] 	 grbe;
   wire [DATA_WIDTH-1:0] grdata;
   wire 				 grvalid;
   wire 				 grbusy;
   
   reg 					 gwr;
   reg [31:0] 			 gwaddr;
   reg [4:0] 			 gwsize;
   reg [NUM_BYTE-1:0] 	 gwbe;
   wire [DATA_WIDTH-1:0] gwdata;
   wire 				 gwready;
   wire 				 gwbusy;
*/
   // Slave 0 : Internal SRAM
wire [28:0]		      MEMADDR;
wire [DATA_WIDTH-1:0] MEMRDATA0;
wire [DATA_WIDTH-1:0] MEMRDATA1;
wire [DATA_WIDTH-1:0] MEMRDATA;
wire [DATA_WIDTH-1:0] MEMWDATA;
wire 				  MEMCEn;
wire				  CEn0;
wire				  CEn1;
wire [NUM_BYTE-1:0]   MEMWEn;
wire[24:0]            mem_addr;
wire[63:0]            mem_rdata;
  

scaler_top tb_scaler(
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
//synopsys translate_off
    .finish_write (finish_write ),
    .total_size   (total_size   ),
    .bpp          (bpp     ),
//synopsys translate_on
    .Rbusy        (Rbusy   ),
    .Rvalid       (Rvalid  ),
    .Rbe          (Rbe     ),
    .Rdata        (Rdata   ),
    .RD           (RD      ),
    .Rsize        (Rsize   ),
    .Raddr        (Raddr   )    
    );
    	 
   ga_axim    ga_axim
	 (
	  .clk                 ( clk ),
	  .rstb                ( rstb ),
	  
	  .AWID                ( AWID ),
	  .AWADDR              ( AWADDR ),
	  .AWLEN               ( AWLEN ),
	  .AWSIZE              ( AWSIZE ),
	  .AWBURST             ( AWBURST ),
	  .AWLOCK              ( AWLOCK ),
	  .AWCACHE             ( AWCACHE ),
	  .AWPROT              ( AWPROT ),
	  .AWVALID             ( AWVALID ),
	  .AWREADY             ( AWREADY ),
	  
	  .WID                 ( WID ),
	  .WDATA               ( WDATA ),
	  .WSTRB               ( WSTRB ),
	  .WLAST               ( WLAST ),
	  .WVALID              ( WVALID ),
	  .WREADY              ( WREADY ),
	  
	  .BID                 ( BID ),
	  .BRESP               ( BRESP ),
	  .BVALID              ( BVALID ),
	  .BREADY              ( BREADY ),
	  
	  .ARID                ( ARID ),
	  .ARADDR              ( ARADDR ),
	  .ARLEN               ( ARLEN ),
	  .ARSIZE              ( ARSIZE ),
	  .ARBURST             ( ARBURST ),
	  .ARLOCK              ( ARLOCK ),
	  .ARCACHE             ( ARCACHE ),
	  .ARPROT              ( ARPROT ),
	  .ARVALID             ( ARVALID ),
	  .ARREADY             ( ARREADY ),
	  
	  .RID                 ( RID ),
	  .RDATA               ( RDATA ),
	  .RRESP               ( RRESP ),
	  .RLAST               ( RLAST ),
	  .RVALID              ( RVALID ),
	  .RREADY              ( RREADY ),
	  
	  .grd                 ( RD ),				 
	  .graddr              ( Raddr ),          
	  .grsize              ( Rsize ),          
	  .grbe                ( Rbe ),            
	  .grdata              ( Rdata ),          
	  .grvalid             ( Rvalid ),         
	  .grbusy              ( Rbusy ),          
	  
	  .gwr                 ( WR ),
	  .gwaddr              ( Waddr ),
	  .gwsize              ( Wsize ),
	  .gwbe                ( Wbe ),
	  .gwdata              ( Wdata ),
	  .gwready             ( Wready ),
	  .gwbusy              ( Wbusy )
	  );

   IntSRAMController #(.DATA_WIDTH(DATA_WIDTH),
					   .RID_WIDTH(WID_WIDTH),
					   .WID_WIDTH(WID_WIDTH)) 
   IntSRAMController
	 (
	  .ACLK(clk),
	  .ARESETn(rstb),
	  
	  .AWID(AWID),
	  .AWADDR(AWADDR),
	  .AWLEN(AWLEN),
	  .AWSIZE(AWSIZE),
	  .AWBURST(AWBURST),
	  .AWVALID(AWVALID),
	  .AWREADY(AWREADY),
	  
	  .WID(WID),
	  .WDATA(WDATA),
	  .WSTRB(WSTRB),
	  .WLAST(WLAST),
	  .WVALID(WVALID),
	  .WREADY(WREADY),
	  
	  .BID(BID),
	  .BRESP(BRESP),
	  .BVALID(BVALID),
	  .BREADY(BREADY),
	  
	  .ARID(ARID),
	  .ARADDR(ARADDR),
	  .ARLEN(ARLEN),
	  .ARSIZE(ARSIZE),
	  .ARBURST(ARBURST),
	  .ARVALID(ARVALID),
	  .ARREADY(ARREADY),
	  
	  // Read Data Channel
	  .RID(RID),
	  .RDATA(RDATA),
	  .RRESP(RRESP),
	  .RLAST(RLAST),
	  .RVALID(RVALID),
	  .RREADY(RREADY),
	  
	  .MEMADDR(MEMADDR[28:0]),
	  .MEMCEn(MEMCEn),
	  .MEMWEn(MEMWEn),
	  .MEMRDATA(MEMRDATA),
	  .MEMWDATA(MEMWDATA)
	  );

   SRCRAM  SRCSRAM //32M RAM
	 (
	  .CLK(clk),
	  .ADDR(MEMADDR[24:0]),
	  .CEn(CEn0),
	  .WEn(MEMWEn),
	  .RDATA(MEMRDATA0),
	  .WDATA(MEMWDATA)
	  );

      
    SSRAM  SRAM //32M RAM
	 (
	  .CLK(clk),
	  .ADDR(mem_addr),
	  .CEn(cen),
	  .WEn(MEMWEn),
	  .RDATA(MEMRDATA1),
	  .WDATA(MEMWDATA)
	  );

reg start_fileout;
reg start;
reg [24:0]            temp_addr;
wire[24:0]            tb_addr;
wire[23:0]            hi_addr;
reg                   tb_cen;

assign hi_addr = tb_addr[23:0];
assign tb_addr = {1'b1,temp_addr[23:0]};

assign CEn0 =(MEMWEn==8'hff) ? 1'b0 : 1'b1;   
assign CEn1 =(MEMWEn!=8'hff) ? 1'b0 : 1'b1;


assign MEMRDATA=(CEn0) ? MEMRDATA1 : MEMRDATA0;
assign cen = (start_fileout) ? tb_cen : CEn1;
assign mem_addr = (start_fileout) ? tb_addr : MEMADDR[24:0];
/*
//  ============================================
//			WRITE DESTINATION MEMORY
//  ============================================
integer result[1:40];
integer debug[1:40];
integer i;
integer p;

initial begin
    i=40;
    result[0]=$fopen("result0.dat");
    result[40]=$fopen("result40.dat");
    debug[0]=$fopen("debug0.dat");
    debug[1]=$fopen("debug1.dat");

    $fwrite(result[i],"TEST");
end
 
always @(posedge clk or negedge rstb) 
begin
    if(!rstb) begin
        temp_addr<=0;
        tb_cen<=1'b1;
    end
    else begin
        if(start_fileout) begin
            tb_cen<=1'b0;
            if(!tb_cen) begin
                if(temp_addr!={3'd0,total_size[31:3]}+1) begin
                    temp_addr<=temp_addr+1;
                    if(temp_addr!=0) begin
                        $fwrite(result[0],"%h\n",MEMRDATA1);

                    end
                end
                else #1000 $stop;
            end                
        end
        if(cen==0 & MEMWEn!=8'hff)
            $fwrite(debug[0],$time,"  addr :%d :: WEn :%h :: data :%h\n",mem_addr-16777216,MEMWEn,MEMWDATA);
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

*/
//////////////////////////////

initial begin
	
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
		//$display($realtime,"      error");
    end
	@(posedge pclk);				
end
endtask
	
//  ============================================
//				color conversion
//	bpp 1: 15bpp format unused R G B(1555)
//	bpp 2: 16bpp format R G B (565)
//  bpp 3: 24bpp format BRGB RGBR GBRG BRGB......
//  bpp 4: 32bpp format 1) unused B R G (8888)
//  bpp 5:              2) A R G B (8888)
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
integer result[100];
integer debug[100];
reg[7:0] i;
reg     restart;
//wire[2:0] bpp_type=3'd1;
reg[2:0] bpp_type;

initial 
begin
	wait(rstb)
	repeat(10) @(posedge clk);
        reg_write(2'h1,{3'd3,1'd0,12'd640,4'd0,12'd480});
        reg_write(2'h0,{1'b0,3'd0,12'd320,4'd0,12'd240});
        reg_write(2'h0,{1'b0,3'd0,12'd320,4'd0,12'd240});
    	reg_write(2'h2,32'h05000000);
        reg_write(2'h3,32'h08000000);

        reg_read(2'h1,{3'd3,2'd0,11'd640,5'd0,11'd480});
        reg_read(2'h2,32'h00000000);
        reg_read(2'h3,32'h08000000);
        reg_read(2'h0,{1'b0,4'd0,11'd320,5'd0,11'd240});

        reg_write(2'h2,32'h00000000);
        reg_write(2'h3,32'h08000000);
    `ifdef fruit // 과일그림 테스트

//**************************************************************************
//      UP_UP Test
//**************************************************************************


        bpp_type = 4;
        i<=0;
        reg_write(2'h1,{bpp_type,1'd0,12'd700,4'd0,12'd600});//UP_UP
        reg_write(2'h0,{2'd1,2'd0,12'd640,4'd0,12'd480});
        
        wait(restart) 
        i<=1;
        reg_write(2'h1,{bpp_type,1'd0,12'd1680,4'd0,12'd936});//UP_UP
        reg_write(2'h0,{2'd1,2'd0,12'd640,4'd0,12'd480});

//**************************************************************************
//      UP_DOWN Test
//**************************************************************************
        wait(restart) 
        i<=2;
        reg_write(2'h1,{bpp_type,2'd0,11'd1680,5'd0,11'd240});//UP_DN
        reg_write(2'h0,{2'd1,2'd0,12'd640,4'd0,12'd480});
        
        wait(restart) 
        i<=3;
        reg_write(2'h1,{bpp_type,2'd0,11'd1024,5'd0,11'd100});//UP_DN
        reg_write(2'h0,{2'd1,2'd0,12'd640,4'd0,12'd480});
        
//**************************************************************************
//      UP_NoVresize Test
//**************************************************************************
        wait(restart) 
        i<=4;
        reg_write(2'h1,{bpp_type,2'd0,11'd700,5'd0,11'd480});//UP_NoVresize ** overlap
        reg_write(2'h0,{2'd1,2'd0,12'd640,4'd0,12'd480});

        wait(restart) 
        i<=5;
        reg_write(2'h1,{bpp_type,2'd0,11'd1048,5'd0,11'd480});//UP_NoVresize
        reg_write(2'h0,{2'd1,2'd0,12'd640,4'd0,12'd480});
        
        
//**************************************************************************
//      NoHresize_DOWN Test
//**************************************************************************
        wait(restart) 
        i<=6;
        reg_write(2'h1,{bpp_type,2'd0,11'd640,5'd0,11'd120});//NoHresize_DN
        reg_write(2'h0,{2'd1,2'd0,12'd640,4'd0,12'd480});

        wait(restart) 
        i<=7;
        reg_write(2'h1,{bpp_type,2'd0,11'd640,5'd0,11'd400});//NoHresize_DN
        reg_write(2'h0,{2'd1,2'd0,12'd640,4'd0,12'd480});


//**************************************************************************
//      DOWN_UP Test
//**************************************************************************
        wait(restart) 
        i<=8;
        reg_write(2'h1,{bpp_type,2'd0,11'd300,5'd0,11'd1024});//DN_UP 
        reg_write(2'h0,{2'd1,2'd0,12'd640,4'd0,12'd480});

        wait(restart) 
        i<=9;
        reg_write(2'h1,{bpp_type,2'd0,11'd240,5'd0,11'd936});//DN_UP
        reg_write(2'h0,{2'd1,2'd0,12'd640,4'd0,12'd480});

//**************************************************************************
//      NoHresize_UP Test
//**************************************************************************
        wait(restart) 
        i<=10;
        reg_write(2'h1,{bpp_type,2'd0,11'd640,5'd0,11'd627});//NoHresize_UP
        reg_write(2'h0,{2'd1,2'd0,12'd640,4'd0,12'd480});

        wait(restart) 
        i<=11;
        reg_write(2'h1,{bpp_type,2'd0,11'd640,5'd0,11'd1680});//NoHresize_UP
        reg_write(2'h0,{2'd1,2'd0,12'd640,4'd0,12'd480});
        

//**************************************************************************
//      DOWN_NoVresize Test
//**************************************************************************
        wait(restart) 
        i<=12;
        reg_write(2'h1,{bpp_type,2'd0,11'd240,5'd0,11'd480});//DN_NoVresize 
        reg_write(2'h0,{2'd1,2'd0,12'd640,4'd0,12'd480});

        wait(restart) 
        i<=13;
        reg_write(2'h1,{bpp_type,2'd0,11'd400,5'd0,11'd480});//DN_NoVresize
        reg_write(2'h0,{2'd1,2'd0,12'd640,4'd0,12'd480});

//**************************************************************************
//      DOWN_DOWN Test
//**************************************************************************
        wait(restart) 
        i<=14;
        reg_write(2'h1,{bpp_type,2'd0,11'd240,5'd0,11'd200});//DN_DN
        reg_write(2'h0,{2'd1,2'd0,12'd640,4'd0,12'd480});

        wait(restart) 
        i<=29;
        reg_write(2'h1,{bpp_type,2'd0,11'd120,5'd0,11'd100});//DN_DN
        reg_write(2'h0,{2'd1,2'd0,12'd640,4'd0,12'd480});

//**************************************************************************
//      Single Test
//**************************************************************************
/*
            bpp_type = 4;
            i<=29;
            reg_write(2'h1,{bpp_type,1'd0,12'd120,4'd0,12'd100});//UP_UP
            
            reg_write(2'h0,{2'd1,2'd0,12'd640,4'd0,12'd480});
       
*/
`else // mp3 picture 로 테스트
//**************************************************************************
//      UP_UP Test
//**************************************************************************
/*

        bpp_type = 3;
        i<=0;
        reg_write(2'h1,{bpp_type,1'd0,12'd324,4'd0,12'd241});//UP_UP
        reg_write(2'h0,{2'd1,2'd0,12'd320,4'd0,12'd240});
        
        wait(restart) 
        i<=1;
        reg_write(2'h1,{bpp_type,1'd0,12'd324,4'd0,12'd244});//UP_UP
        reg_write(2'h0,{2'd1,2'd0,12'd320,4'd0,12'd240});

        wait(restart) 
        i<=2;
        reg_write(2'h1,{bpp_type,1'd0,12'd640,4'd0,12'd480});//UP_UP
        reg_write(2'h0,{2'd1,2'd0,12'd320,4'd0,12'd240});

        wait(restart) 
        i<=3;
        reg_write(2'h1,{bpp_type,1'd0,12'd1680,4'd0,12'd936});//UP_UP
        reg_write(2'h0,{2'd1,2'd0,12'd320,4'd0,12'd240});

//**************************************************************************
//      UP_DOWN Test
//**************************************************************************
        wait(restart) 
        i<=4;
        reg_write(2'h1,{bpp_type,2'd0,11'd640,5'd0,11'd201});//UP_DN 줄갔었다
        reg_write(2'h0,{2'd1,2'd0,12'd320,4'd0,12'd240});

        wait(restart) 
        i<=5;
        reg_write(2'h1,{bpp_type,2'd0,11'd640,5'd0,11'd120});//UP_DN "
        reg_write(2'h0,{2'd1,2'd0,12'd320,4'd0,12'd240});
        
        wait(restart) 
        i<=6;
        reg_write(2'h1,{bpp_type,2'd0,11'd700,5'd0,11'd80});//UP_DN
        reg_write(2'h0,{2'd1,2'd0,12'd320,4'd0,12'd240});
        
        wait(restart) 
        i<=7;
        reg_write(2'h1,{bpp_type,2'd0,11'd324,5'd0,11'd80});//UP_DN
        reg_write(2'h0,{2'd1,2'd0,12'd320,4'd0,12'd240});
        
        wait(restart) 
        i<=8;
        reg_write(2'h1,{bpp_type,2'd0,11'd324,5'd0,11'd45});//UP_DN
        reg_write(2'h0,{2'd1,2'd0,12'd320,4'd0,12'd240});

//**************************************************************************
//      UP_NoVresize Test
//**************************************************************************
        wait(restart) 
        i<=9;
        reg_write(2'h1,{bpp_type,2'd0,11'd324,5'd0,11'd240});//UP_NoVresize ** overlap
        reg_write(2'h0,{2'd1,2'd0,12'd320,4'd0,12'd240});

        wait(restart) 
        i<=10;
        reg_write(2'h1,{bpp_type,2'd0,11'd604,5'd0,11'd240});//UP_NoVresize
        reg_write(2'h0,{2'd1,2'd0,12'd320,4'd0,12'd240});
        
        wait(restart) 
        i<=11;
        reg_write(2'h1,{bpp_type,2'd0,11'd824,5'd0,11'd240});//UP_NoVresize
        reg_write(2'h0,{2'd1,2'd0,12'd320,4'd0,12'd240});
        
//**************************************************************************
//      NoHresize_DOWN Test
//**************************************************************************
        wait(restart) 
        i<=12;
        reg_write(2'h1,{bpp_type,2'd0,11'd320,5'd0,11'd120});//NoHresize_DN
        reg_write(2'h0,{2'd1,2'd0,12'd320,4'd0,12'd240});

        wait(restart) 
        i<=13;
        reg_write(2'h1,{bpp_type,2'd0,11'd320,5'd0,11'd239});//NoHresize_DN
        reg_write(2'h0,{2'd1,2'd0,12'd320,4'd0,12'd240});

        wait(restart) 
        i<=14;
        reg_write(2'h1,{bpp_type,2'd0,11'd320,5'd0,11'd48});//NoHresize_DN
        reg_write(2'h0,{2'd1,2'd0,12'd320,4'd0,12'd240});


//**************************************************************************
//      DOWN_UP Test
//**************************************************************************
        wait(restart) 
        i<=15;
        reg_write(2'h1,{bpp_type,2'd0,11'd300,5'd0,11'd320});//DN_UP 
        reg_write(2'h0,{2'd1,2'd0,12'd320,4'd0,12'd240});

        wait(restart) 
        i<=16;
        reg_write(2'h1,{bpp_type,2'd0,11'd240,5'd0,11'd700});//DN_UP
        reg_write(2'h0,{2'd1,2'd0,12'd320,4'd0,12'd240});

        wait(restart) 
        i<=17;
        reg_write(2'h1,{bpp_type,2'd0,11'd240,5'd0,11'd320});//DN_UP
        reg_write(2'h0,{2'd1,2'd0,12'd320,4'd0,12'd240});

        wait(restart) 
        i<=18;
        reg_write(2'h1,{bpp_type,2'd0,11'd48,5'd0,11'd320});//DN_UP
        reg_write(2'h0,{2'd1,2'd0,12'd320,4'd0,12'd240});

        
//**************************************************************************
//      NoHresize_UP Test
//**************************************************************************
        wait(restart) 
        i<=19;
        reg_write(2'h1,{bpp_type,2'd0,11'd320,5'd0,11'd320});//NoHresize_UP
        reg_write(2'h0,{2'd1,2'd0,12'd320,4'd0,12'd240});

        wait(restart) 
        i<=20;
        reg_write(2'h1,{bpp_type,2'd0,11'd320,5'd0,11'd627});//NoHresize_UP
        reg_write(2'h0,{2'd1,2'd0,12'd320,4'd0,12'd240});

        wait(restart) 
        i<=21;
        reg_write(2'h1,{bpp_type,2'd0,11'd320,5'd0,11'd1680});//NoHresize_UP
        reg_write(2'h0,{2'd1,2'd0,12'd320,4'd0,12'd240});
        

//**************************************************************************
//      DOWN_NoVresize Test
//**************************************************************************
        wait(restart) 
        i<=22;
        reg_write(2'h1,{bpp_type,2'd0,11'd240,5'd0,11'd240});//DN_NoVresize 
        reg_write(2'h0,{2'd1,2'd0,12'd320,4'd0,12'd240});

        wait(restart) 
        i<=23;
        reg_write(2'h1,{bpp_type,2'd0,11'd120,5'd0,11'd240});//DN_NoVresize
        reg_write(2'h0,{2'd1,2'd0,12'd320,4'd0,12'd240});

        wait(restart) 
        i<=24;
        reg_write(2'h1,{bpp_type,2'd0,11'd48,5'd0,11'd240});//DN_NoVresize
        reg_write(2'h0,{2'd1,2'd0,12'd320,4'd0,12'd240});


//**************************************************************************
//      DOWN_DOWN Test
//**************************************************************************
        wait(restart) 
        i<=25;
        reg_write(2'h1,{bpp_type,2'd0,11'd240,5'd0,11'd200});//DN_DN
        reg_write(2'h0,{2'd1,2'd0,12'd320,4'd0,12'd240});

        wait(restart) 
        i<=26;
        reg_write(2'h1,{bpp_type,2'd0,11'd240,5'd0,11'd120});//DN_DN
        reg_write(2'h0,{2'd1,2'd0,12'd320,4'd0,12'd240});

        wait(restart) 
        i<=27;
        reg_write(2'h1,{bpp_type,2'd0,11'd120,5'd0,11'd97});//DN_DN
        reg_write(2'h0,{2'd1,2'd0,12'd320,4'd0,12'd240});

        wait(restart) 
        i<=28;
        reg_write(2'h1,{bpp_type,2'd0,11'd80,5'd0,11'd60});//DN_DN
        reg_write(2'h0,{2'd1,2'd0,12'd320,4'd0,12'd240});

        wait(restart) 
        i<=29;
        reg_write(2'h1,{bpp_type,2'd0,11'd48,5'd0,11'd48});//DN_DN
        reg_write(2'h0,{2'd1,2'd0,12'd320,4'd0,12'd240});
        
   
*/       
//**************************************************************************
//      Single Test
//**************************************************************************
/*
            bpp_type = 5;
            i<=29;
            reg_write(2'h1,{bpp_type,1'd0,12'd240,4'd0,12'd200});//UP_UP
            
        reg_write(2'h0,{2'd1,2'd0,12'd320,4'd0,12'd240});
*/       
//------------------------------------------------------------       
//              32bit align test
//------------------------------------------------------------       

/*
        bpp_type = 3;        
        //********** UP_UP **********
        i<=0;
        reg_write(2'h1,{bpp_type,1'd0,12'd323,4'd0,12'd244});//UP_UP
        reg_write(2'h0,{2'd1,2'd0,12'd320,4'd0,12'd240});
        
        wait(restart) 
        i<=1;
        reg_write(2'h1,{bpp_type,1'd0,12'd1677,4'd0,12'd936});//UP_UP
        reg_write(2'h0,{2'd1,2'd0,12'd320,4'd0,12'd240});

        //********** UP_DOWN *********
        wait(restart) 
        i<=2;
        reg_write(2'h1,{bpp_type,2'd0,11'd638,5'd0,11'd201});//UP_DN 
        reg_write(2'h0,{2'd1,2'd0,12'd320,4'd0,12'd240});

        wait(restart) 
        i<=3;
        reg_write(2'h1,{bpp_type,2'd0,11'd321,5'd0,11'd45});//UP_DN
        reg_write(2'h0,{2'd1,2'd0,12'd320,4'd0,12'd240});

        //********** UP_NoVresize **********
        wait(restart) 
        i<=4;
        reg_write(2'h1,{bpp_type,2'd0,11'd322,5'd0,11'd240});//UP_NoVresize 
        reg_write(2'h0,{2'd1,2'd0,12'd320,4'd0,12'd240});
        wait(restart) 
        i<=5;
        reg_write(2'h1,{bpp_type,2'd0,11'd801,5'd0,11'd240});//UP_NoVresize
        reg_write(2'h0,{2'd1,2'd0,12'd320,4'd0,12'd240});
        
        //********** DOWN_UP **********
        wait(restart) 
        i<=6;
        reg_write(2'h1,{bpp_type,2'd0,11'd299,5'd0,11'd320});//DN_UP
        reg_write(2'h0,{2'd1,2'd0,12'd320,4'd0,12'd240});
        wait(restart) 
        i<=7;
        reg_write(2'h1,{bpp_type,2'd0,11'd46,5'd0,11'd320});//DN_UP
        reg_write(2'h0,{2'd1,2'd0,12'd320,4'd0,12'd240});

        //********** DOWN_NoVresize *********
        wait(restart) 
        i<=8;
        reg_write(2'h1,{bpp_type,2'd0,11'd239,5'd0,11'd240});//DN_NoVresize
        reg_write(2'h0,{2'd1,2'd0,12'd320,4'd0,12'd240});
        wait(restart) 
        i<=9;
        reg_write(2'h1,{bpp_type,2'd0,11'd47,5'd0,11'd240});//DN_NoVresize
        reg_write(2'h0,{2'd1,2'd0,12'd320,4'd0,12'd240});

        //********** DOWN_DOWN **********
        wait(restart) 
        i<=10;
        reg_write(2'h1,{bpp_type,2'd0,11'd45,5'd0,11'd48});//DN_DN
        reg_write(2'h0,{2'd1,2'd0,12'd320,4'd0,12'd240});
        wait(restart) 
        i<=29;
        reg_write(2'h1,{bpp_type,2'd0,11'd117,5'd0,11'd77});//DN_DN
        reg_write(2'h0,{2'd1,2'd0,12'd320,4'd0,12'd240});

*/      
/*
        i<=14;
        reg_write(2'h1,{bpp_type,2'd0,11'd46,5'd0,11'd320});
        //reg_write(2'h1,{bpp_type,2'd0,11'd639,5'd0,11'd480});
        reg_write(2'h0,{2'd1,2'd0,12'd320,4'd0,12'd240});
*/
    
    `endif


end	



//  ============================================
//			WRITE DESTINATION MEMORY
//  ============================================

initial begin
	result[0 ]=$fopen("result0.dat"); result[8 ]=$fopen("result8.dat");
	result[1 ]=$fopen("result1.dat"); result[9 ]=$fopen("result9.dat");
	result[2 ]=$fopen("result2.dat"); result[10]=$fopen("result10.dat");
	result[3 ]=$fopen("result3.dat"); result[11]=$fopen("result11.dat");
	result[4 ]=$fopen("result4.dat"); result[12]=$fopen("result12.dat");
	result[5 ]=$fopen("result5.dat"); result[13]=$fopen("result13.dat");
	result[6 ]=$fopen("result6.dat"); result[14]=$fopen("result14.dat");
	result[7 ]=$fopen("result7.dat"); result[15]=$fopen("result15.dat");
	
	result[16]=$fopen("result16.dat"); result[23]=$fopen("result23.dat");
	result[17]=$fopen("result17.dat"); result[24]=$fopen("result24.dat");
	result[18]=$fopen("result18.dat"); result[25]=$fopen("result25.dat");
	result[19]=$fopen("result19.dat"); result[26]=$fopen("result26.dat");
	result[20]=$fopen("result20.dat"); result[27]=$fopen("result27.dat");
	result[21]=$fopen("result21.dat"); result[28]=$fopen("result28.dat");
	result[22]=$fopen("result22.dat"); result[29]=$fopen("result29.dat");

/*    
    debug[0 ]=$fopen("debug0.dat"); debug[8 ]=$fopen("debug8.dat");
	debug[1 ]=$fopen("debug1.dat"); debug[9 ]=$fopen("debug9.dat");
	debug[2 ]=$fopen("debug2.dat"); debug[10]=$fopen("debug10.dat");
	debug[3 ]=$fopen("debug3.dat"); debug[11]=$fopen("debug11.dat");
	debug[4 ]=$fopen("debug4.dat"); debug[12]=$fopen("debug12.dat");
	debug[5 ]=$fopen("debug5.dat"); debug[13]=$fopen("debug13.dat");
	debug[6 ]=$fopen("debug6.dat"); debug[14]=$fopen("debug14.dat");
	debug[7 ]=$fopen("debug7.dat"); 
*/
end

wire[31:0] size;
reg finish_write_dly;

assign size = (bpp==1 | bpp==2) ? {1'b0,total_size[31:1]} : total_size;


always @(posedge clk or negedge rstb)
begin
    if(!rstb) begin
        finish_write_dly<=0;
    end
    else begin
        finish_write_dly<=finish_write;
    end
end

assign end_write = finish_write & ~finish_write_dly;

always @(posedge clk or negedge rstb) 
begin
    if(!rstb) begin
        temp_addr<=0;
        tb_cen<=1'b1;
        restart<=0;
        start_fileout<=0;
    end
    else begin
        restart<=0;
        if(end_write) start_fileout<=1;
        if(start_fileout) begin
            tb_cen<=1'b0;
            if(!tb_cen) begin
                if(temp_addr!={3'd0,total_size[31:3]}+1) begin
                    temp_addr<=temp_addr+1;
                    if(temp_addr!=0) begin
                        if(bpp==1)
                            $fwrite(result[i],"%h\n",
                                    { {MEMRDATA1[62:58],3'd0},{MEMRDATA1[57:53],3'd0},{MEMRDATA1[52:48],3'd0},
                                      {MEMRDATA1[46:42],3'd0},{MEMRDATA1[41:37],3'd0},{MEMRDATA1[36:32],3'd0},
                                      {MEMRDATA1[30:26],3'd0},{MEMRDATA1[25:21],3'd0},{MEMRDATA1[20:16],3'd0},
                                      {MEMRDATA1[14:10],3'd0},{MEMRDATA1[ 9:5 ],3'd0},{MEMRDATA1[ 4:0 ],3'd0} });
                        else if(bpp==2)
                            $fwrite(result[i],"%h\n",
                                    { {MEMRDATA1[63:59],3'd0},{MEMRDATA1[58:53],2'd0},{MEMRDATA1[52:48],3'd0},
                                      {MEMRDATA1[47:43],3'd0},{MEMRDATA1[42:37],2'd0},{MEMRDATA1[36:32],3'd0},
                                      {MEMRDATA1[31:27],3'd0},{MEMRDATA1[26:21],2'd0},{MEMRDATA1[20:16],3'd0},
                                      {MEMRDATA1[15:11],3'd0},{MEMRDATA1[10:5 ],2'd0},{MEMRDATA1[ 4:0 ],3'd0} });
                        else if(bpp==3)
                            $fwrite(result[i],"%h\n",MEMRDATA1);
                        else if(bpp==4) begin
 //                           $fwrite(result[i],"%h\n",
 //                                   {{MEMRDATA1[55:32],MEMRDATA1[23:0]}} );
                            $fwrite(result[i],"%h\n",MEMRDATA1[7:0]);
                            $fwrite(result[i],"%h\n",MEMRDATA1[15:8]);
                            $fwrite(result[i],"%h\n",MEMRDATA1[23:16]);
                            $fwrite(result[i],"%h\n",MEMRDATA1[39:32]);
                            $fwrite(result[i],"%h\n",MEMRDATA1[47:40]);
                            $fwrite(result[i],"%h\n",MEMRDATA1[55:48]);
                        end
                        else if(bpp==5)
 //                           $fwrite(result[i],"%h\n",MEMRDATA1);
                            $fwrite(result[i],"%h\n",
                                    {{MEMRDATA1[55:32],MEMRDATA1[23:0]}} );
                    end
                end
                else begin
                    start_fileout<=0;
                    temp_addr<=0;
                    restart<=1'b1;
                    if(i==29) begin
                        #1000 $stop;
                    end
                end
            end                
        end
        if(cen==0 & MEMWEn!=8'hff)
            $fwrite(debug[i],$time,"  addr :%d :: WEn :%h :: data :%h\n",mem_addr-16777216,MEMWEn,MEMWDATA);
    end
end



//////////////////////////////
endmodule // Atb_ga_axi


