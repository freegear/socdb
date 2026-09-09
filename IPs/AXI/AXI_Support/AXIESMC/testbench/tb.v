/*****************************************************************
		         TestMaster Simple testbench
*****************************************************************/
`timescale 1 ns/ 10ps
module tb;

parameter CLK_HALFPERIOD=5;

parameter DATA_WIDTH = 32;	// only support 32 now
parameter WID_WIDTH = 4;
parameter RID_WIDTH = 4;

// auto assign from above parameter
parameter NUM_BYTE = DATA_WIDTH/8;

reg         ACLK        ;     // APB system clock
reg         ARESETn     ;     // APB system reset

wire [WID_WIDTH-1:0]  AWID;
wire [31:0]           AWADDR;
wire [3:0]            AWLEN;
wire [2:0]            AWSIZE;
wire [1:0]            AWBURST;
wire                  AWVALID;
wire                  AWREADY;

wire [WID_WIDTH-1:0]  WID;
wire [DATA_WIDTH-1:0] WDATA;
wire [NUM_BYTE-1:0]   WSTRB;
wire                  WLAST;
wire                  WVALID;
wire                  WREADY;

wire [WID_WIDTH-1:0]  BID;
wire [1:0]            BRESP;
wire                  BVALID;
wire                  BREADY;

wire [RID_WIDTH-1:0]  ARID;
wire [31:0]           ARADDR;
wire [3:0]            ARLEN;
wire [2:0]            ARSIZE;
wire [1:0]            ARBURST;
wire                  ARVALID;
wire                  ARREADY;

wire [RID_WIDTH-1:0]  RID;
wire [DATA_WIDTH-1:0] RDATA;
wire [1:0]            RRESP;
wire                  RLAST;
wire                  RVALID;
wire                  RREADY;


always #CLK_HALFPERIOD	ACLK = ~ACLK;

initial ACLK 		= 0;     // clock
initial
begin
	ARESETn 	= 0;     // reset
	repeat(10) @(posedge ACLK);
	ARESETn	= 1;
end

TestMaster TestMaster
(
		.ACLK(ACLK),
		.ARESETn(ARESETn),

		.AWID(AWID),
		.AWADDR(AWADDR),
		.AWLEN(AWLEN),
		.AWSIZE(AWSIZE),
		.AWBURST(AWBURST),
		.AWLOCK(),
		.AWCACHE(),
		.AWPROT(),
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
		.ARLOCK(),
		.ARCACHE(),
		.ARPROT(),
		.ARVALID(ARVALID),
		.ARREADY(ARREADY),

		// Read Data Channel
		.RID(RID),
		.RDATA(RDATA),
		.RRESP(RRESP),
		.RLAST(RLAST),
		.RVALID(RVALID),
		.RREADY(RREADY)
);

//APB SIGN      	          
reg	[ 2:3]			PADDR     ;
reg					PSEL      ;
reg					PENABLE   ;
reg					PWRITE    ;
reg	[31:0]			PWDATA    ;
wire[31:0]  		PRDATA    ;
                	          
wire[19:0]			EXT_ADDR  ;
wire[31:0]			EXT_WDATA ;
wire[31:0]			EXT_RDATA ;
wire[ 3:0]			EXT_CSb   ;
wire				EXT_OEb   ;
wire				EXT_WEb   ;
wire[3:0]			EXT_BEb   ;
wire[3:0]			EXT_WBEb  ;
wire				EXT_BIDEN ;

wire[7 :0]			sram_data_0;
wire[7 :0]			sram_data_1;
wire[7 :0]			sram_data_2;
wire[7 :0]			sram_data_3;
wire[31:0]			sram_data_32;

SMC_TOP uSMC_TOP(
		.ACLK(ACLK),
		.ARESETn(ARESETn),

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
                   	                 
		.PCLK      	(ACLK      ),    
		.PRESETn   	(ARESETn   ),    
		.PADDR     	(PADDR     ),    
		.PSEL      	(PSEL      ),    
		.PENABLE   	(PENABLE   ),    
		.PWRITE    	(PWRITE    ),    
		.PWDATA    	(PWDATA    ),    
		.PRDATA    	(PRDATA    ),    
        	           	                 
		.EXT_ADDR  	(EXT_ADDR  ),    
		.EXT_WDATA 	(EXT_WDATA ),    
		.EXT_RDATA 	(EXT_RDATA ),    
		.EXT_CSb   	(EXT_CSb   ),    
		.EXT_OEb   	(EXT_OEb   ),    
		.EXT_WEb   	(EXT_WEb   ),    
		.EXT_BEb   	(EXT_BEb   ),    
		.EXT_WBEb  	(EXT_WBEb  ),    
		.EXT_BIDEN 	(EXT_BIDEN ));   
                                     
// bank0
sram8bit u1_sram8bit(
		.data	   	(sram_data_0   	),
		.addr	   	(EXT_ADDR[17:0]	),
		.we_n	   	(EXT_WBEb[0]   	),
		.oe_n	   	(EXT_OEb	   	),
		.cs_n	   	(EXT_CSb[0]	   	));

//bank1
sram16bit u0_sram16bit(
		.data  		({sram_data_1,sram_data_0}	),
		.addr  		({EXT_ADDR[17:0]}			),
		.we_n  		(EXT_WEb					),
		.oe_n  		(EXT_OEb					),
		.cs_n  		(EXT_CSb[1]	 				),
		.ble_n 		(EXT_BEb[0]					),
		.bhe_n 		(EXT_BEb[1]					));

sram32bit u2_sram32bit(
		.data  		(sram_data_32 				),
		.addr  		({2'b00, EXT_ADDR[17:2]}		),
		.we_n  		(EXT_WEb					),
		.oe_n  		(EXT_OEb					),
		.cs_n  		(EXT_CSb[2]	 				),
		.be0_n		(EXT_BEb[0]					),
		.be1_n		(EXT_BEb[1]					),
		.be2_n		(EXT_BEb[2]					),
		.be3_n		(EXT_BEb[3]					));

sram32bit u3_sram32bit(
		.data  		(sram_data_32 				),
		.addr  		(EXT_ADDR[17:0]				),
		.we_n  		(EXT_WEb					),
		.oe_n  		(EXT_OEb					),
		.cs_n  		(EXT_CSb[3]	 				),
		.be0_n		(EXT_BEb[0]					),
		.be1_n		(EXT_BEb[1]					),
		.be2_n		(EXT_BEb[2]					),
		.be3_n		(EXT_BEb[3]					));

assign	sram_data_3 = (EXT_BIDEN) ? EXT_WDATA[31:24] : 32'hz;
assign	sram_data_2 = (EXT_BIDEN) ? EXT_WDATA[23:16] : 32'hz;
assign	sram_data_1 = (EXT_BIDEN) ? EXT_WDATA[15:8 ] : 32'hz;
assign	sram_data_0 = (EXT_BIDEN) ? EXT_WDATA[ 7:0 ] : 32'hz;

assign  sram_data_32= {sram_data_3,sram_data_2,sram_data_1,sram_data_0};
assign  EXT_RDATA   = sram_data_32;

initial
begin
	PADDR     = 0;
	PSEL      = 0;
	PENABLE   = 0;
	PWRITE    = 0;
	PWDATA    = 0;    
end		
		
task reg_write; 
	input[ 1:0]	addr;
	input[31:0] data;
	begin
		@(negedge ACLK) #2
			PENABLE = 1'b0;
		@(posedge ACLK) #2
			PSEL = 1'b1;
			PWRITE = 1'b1;
			PADDR = addr;
			PWDATA = data;
		@(posedge ACLK) #2
			PENABLE = 1'b1;
		@(posedge ACLK) #2
			$display($time, " : address [%h]   reg write : data [%h]", addr, data);
			PSEL = 1'b0;
			PENABLE = 1'b0;
			PWDATA = 32'd0;
	end
endtask

task reg_read; 
	input[ 1:0]	addr;
	input[31:0] data;
	begin
		@(negedge ACLK) #2
			PENABLE = 1'b0;
		@(posedge ACLK) #2
			PSEL = 1'b1;
			PWRITE = 1'b0;
			PADDR = addr;
		@(posedge ACLK) #2
			PENABLE = 1'b1;
		@(posedge ACLK) #2
			if(PRDATA == data)
				$display($time, " : match data ");
			else	
				$display($time, " : error repected data[%h] : read data[%h]",data , PRDATA);
			PSEL = 1'b0;
			PENABLE = 1'b0;
			PWDATA = 32'd0;
	end
endtask

endmodule
