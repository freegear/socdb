`timescale 1ns/1ps
module tb_Top;

parameter 		ADDRESSWIDTH = 21;
reg				M_PCLK	;
reg				PRESETn	;
reg				M_PSEL	;
reg				M_PENABLE;
wire			M_PREADY;
reg				M_PWRITE;
reg		[ADDRESSWIDTH-1:0]	M_PADDR	;
reg		[31:0]	M_PWDATA;
wire	[31:0]	M_PRDATA;

reg				R_PCLK;
reg				R_PSEL;
reg				R_PENABLE;
reg				R_PWRITE;
reg		[31:0]	R_PADDR;
reg		[31:0]	R_PWDATA;
wire	[31:0]	R_PRDATA;

wire			[ADDRESSWIDTH-1:0]	ADDR;



/// clock input	
initial 
	begin
	M_PCLK   =	0;
	PRESETn  =	0;
	R_PCLK	 =	0;
	M_PSEL	 =	0;
	M_PENABLE=	0;
	M_PWRITE = 	0;
	M_PADDR	 = 	0;
	M_PWDATA = 	0;



	R_PSEL	 =	0;
	R_PENABLE=	0;
	R_PWRITE =	0;
	R_PADDR  =	0;
	R_PWDATA =  0;
	end

always 
	begin
	#5 M_PCLK = ~M_PCLK;
	end

always
	begin
	#10 R_PCLK = ~R_PCLK;
	end

`define psramcon 	0
`define psramtcon 	1
`define Enable		32'b1
`define PageSize	32'b111
`define	BurstRMode	32'b1
`define PowerUp		32'b1

`define tRC			32'b1111
`define tAA			32'b1111
`define tPRC		32'b111
`define tPA			32'b111
`define tWC			32'b1111
`define tAS			32'b11
`define tWP			32'b1111
`define tWR			32'b11
`define tDW			32'b11
`define tDH			32'b11



integer rvalue;
integer mvalue;

// main test code

initial
	begin
	#200
	PRESETn = 1;
	//----------------------------------------------------
	#100
	$display ("Register Default Value Check!!\n");
	$display ("PSRAMCON Register Default Value Check!!");
	REG_Read(`psramcon);
	$display ("PSRAMTCON Register Default Value Check!!");
	REG_Read(`psramtcon);
	//----------------------------------------------------

	//----------------------------------------------------
	$display ("PSRAM Initial Setting!!\n");

	rvalue = ((`Enable&1'b1)<<0)|((`PageSize&3'b0)<<3)|((`BurstRMode&1'b0)<<2)|((`PowerUp&1'b1)<<1);
	$display ("PSRAM -> PowerUP!!!!!\n");
	REG_Write(`psramcon, rvalue);
	#200000
	$display ("PSRAM -> PowerUPClr!!!!!\n");
	rvalue = ((`Enable&1'b1)<<0)|((`PageSize&3'b0)<<3)|((`BurstRMode&1'b0)<<2)|((`PowerUp&1'b0)<<1);
	REG_Write(`psramcon, rvalue);

	REG_Write(`psramtcon, 32'h0);
	//----------------------------------------------------
	$display ("PSRAM Disable Test!");
	rvalue = ((`Enable&1'b0)<<0)|((`PageSize&3'b0)<<3)|((`BurstRMode&1'b0)<<2)|((`PowerUp&1'b0)<<1);
	REG_Write(`psramcon, rvalue);

	#100
	$display ("PSRAM no tested state Test!");
	rvalue = ((`Enable&1'b0)<<0)|((`PageSize&3'b0)<<3)|((`BurstRMode&1'b0)<<2)|((`PowerUp&1'b1)<<1);
	REG_Write(`psramcon, rvalue);

	$display ("PSRAM ReInitialize Test!");
	rvalue = ((`Enable&1'b1)<<0)|((`PageSize&3'b0)<<3)|((`BurstRMode&1'b0)<<2)|((`PowerUp&1'b1)<<1);
	$display ("PSRAM -> PowerUP!!!!!\n");
	REG_Write(`psramcon, rvalue);
	#200000
	$display ("PSRAM -> PowerUPClr!!!!!\n");
	rvalue = ((`Enable&1'b1)<<0)|((`PageSize&3'b0)<<3)|((`BurstRMode&1'b0)<<2)|((`PowerUp&1'b0)<<1);
	REG_Write(`psramcon, rvalue);
	//-----------------------------------------------------
	#100
	
	$display ("PSRAM Timing Control register Setting!\n");
	rvalue = 	((`tRC &4'b1000)<<28)|
			   	((`tAA &4'b1000)<<24)|
			   	((`tPRC&3'b111)<<21)|
			   	((`tPA &3'b110)<<18)|
			   	((`tWC &4'b1000)<<14)|
			   	((`tAS &2'b00)<<12)|
			   	((`tWP &4'b1000)<<8)| // relative WE line
			   	((`tWR &2'b11)<<6)| // write recovery time relative WE and tWC
				((`tDW &2'b11)<<4)|
				((`tDH &2'b11)<<2);
	REG_Write(`psramtcon, rvalue);
	//-----------------------------------------------------
	// PSRAM READ WRITE TEST
	$display ("No Burst Mode Test Start~\n");
	$display ("Memory Write test!!\n");
	for (mvalue = 0 ; mvalue < 100 ; mvalue = mvalue+2)
	begin
	MEM_Write(mvalue ,mvalue);
	end
	$display ("Memory Read test!!\n");
	for (mvalue = 0 ; mvalue < 100 ; mvalue = mvalue+2)
	begin
	MEM_Read(mvalue);
	end
	//--------------------------------------------------------
	$display ("PSRAM Timing Control register Setting! for PageMode\n");
	rvalue = ((`Enable&1'b1)<<0)|((`PageSize&3'b100)<<3)|((`BurstRMode&1'b1)<<2)|((`PowerUp&1'b0)<<1);
	REG_Write(`psramcon, rvalue);
	rvalue = 	((`tRC &4'b1000)<<28)|
			   	((`tAA &4'b1000)<<24)|
			   	((`tPRC&3'b100)<<21)|
			   	((`tPA &3'b011)<<18)|
			   	((`tWC &4'b1000)<<14)|
			   	((`tAS &2'b00)<<12)|
			   	((`tWP &4'b1000)<<8)| // relative WE line
			   	((`tWR &2'b11)<<6)| // write recovery time relative WE and tWC
				((`tDW &2'b11)<<4)|
				((`tDH &2'b11)<<2);
	REG_Write(`psramtcon, rvalue);
	//-----------------------------------------------------
	#100
	$display ("PageMode Burst Read Test Start~\n");
	$display ("Memory Read test!!\n");
	for (mvalue = 0 ; mvalue < 100 ; mvalue = mvalue+2)
	begin
	MEM_Read(mvalue);
	end
	//--------------------------------------------------------

end



parameter DLY = 1;
task MEM_Read;
input [31:0] Addr;
begin
		@(posedge M_PCLK);
		#DLY	M_PENABLE = 1'b0;
				M_PADDR   = Addr[7:0];
       			M_PSEL    = 1'b1;
				M_PWRITE  = 1'b0;
       	repeat(1) @(posedge M_PCLK);
  		#DLY 	M_PENABLE = 1'b1;
       	repeat(1) @(posedge M_PCLK);

		while (M_PREADY == 1'b0)
		begin
		repeat(1) @(posedge M_PCLK);
		end
		#DLY 	M_PENABLE = 1'b0;
				M_PSEL    = 1'b0;

//       	repeat(1) @(posedge M_PCLK);
end
endtask

task MEM_Write;
input	[31:0]	Addr;
input	[31:0]	Wdata;
begin
		@(posedge M_PCLK);
		#DLY 	M_PADDR   = Addr[7:0];
	 			M_PWDATA  = Wdata;
				M_PENABLE = 1'b0;
				M_PSEL    = 1'b1;
				M_PWRITE  = 1'b1;
	 	repeat(1) @(posedge M_PCLK);
		#DLY 	M_PENABLE = 1'b1;
       	repeat(1) @(posedge M_PCLK);

		while (M_PREADY == 1'b0)
		begin
		repeat(1) @(posedge M_PCLK);
		end

		#DLY 	M_PENABLE = 1'b0;
				M_PSEL    = 1'b0;
	 	repeat(1) @(posedge M_PCLK);
end
endtask

task REG_Read;
input	[31:0]	Addr;
begin
		@(posedge R_PCLK);
  		#DLY 	R_PADDR   = Addr[7:0];
       			R_PENABLE = 1'b0;
       			R_PSEL    = 1'b1;
		       	R_PWRITE  = 1'b0;
       repeat(1) @(posedge R_PCLK);
	  	#DLY 	R_PENABLE = 1'b1;
       repeat(1) @(posedge R_PCLK);
		$display ("APB Register READ Value: %b\n",R_PRDATA);
		#DLY 	R_PENABLE = 1'b0;
				R_PSEL    = 1'b0;
       repeat(1) @(posedge R_PCLK);
	
end
endtask


task REG_Write;
input	[31:0]	Addr;
input	[31:0]	Wdata;
begin
		@(posedge R_PCLK);
		#DLY 	R_PADDR   = Addr[7:0];
	 			R_PWDATA  = Wdata;
	 			R_PENABLE = 1'b0;
	 			R_PSEL    = 1'b1;
	 			R_PWRITE  = 1'b1;
	 repeat(1) @(posedge R_PCLK);
		#DLY 	R_PENABLE = 1'b1;
	 repeat(1) @(posedge R_PCLK);
		#DLY 	R_PENABLE = 1'b0;
	 			R_PSEL    = 1'b0;
	 repeat(1) @(posedge R_PCLK);
end
endtask



tri     [15:0]  DATA;
wire    [15:0]  DATAIN;
wire	[15:0]	DATAOUT;
wire		nDATAEN;

assign  DATAIN = DATA;
assign  DATA = nDATAEN ? 16'bzzzzzzzzzzzzzzzz :DATAOUT;


pmcon_APBTOP PSRAMCtrl
(
        //------------------------------
        // AMBA3APB for momory access
        //------------------------------
        .M_PCLK          (M_PCLK	),
        .PRESETn         (PRESETn	),
        .M_PSEL          (M_PSEL	),
        .M_PENABLE       (M_PENABLE	),
        .M_PREADY        (M_PREADY	),

        .M_PWRITE        (M_PWRITE	),
        .M_PADDR         (M_PADDR	),
        .M_PWDATA        (M_PWDATA	),
        .M_PRDATA        (M_PRDATA	),

        //-----------------------------------
        // APB Interface for Register setting
        //-----------------------------------
        .R_PCLK          (R_PCLK	),
        .R_PSEL          (R_PSEL	),
        .R_PENABLE       (R_PENABLE	),

        .R_PWRITE        (R_PWRITE	),
        .R_PADDR         (R_PADDR	),
        .R_PWDATA        (R_PWDATA	),
        .R_PRDATA        (R_PRDATA	),

        //----------- PSRAM
        .CSb             (CSb	),
        .ZZb             (ZZb	),
        .OEb             (OEb	),
        .WEb             (WEb	),
        .UBb             (UBb	),
        .LBb             (LBb	),

        .ADDR            (ADDR	),
        .DATAIN          (DATAIN),
        .nDATAEN         (nDATAEN),
        .DATAOUT	 	 (DATAOUT)

);


psram32m    PSRAM32 
	(
            .Dq (DATA),
            .Addr   (ADDR),
            .Ce_n   (CSb),
            .We_n   (WEb),
            .Oe_n   (OEb),
            .Lb_n   (LBb),
            .Ub_n   (UBb),
            .Zz_n   (ZZb)
        );

endmodule
