module tb_MemCtrlTop;


reg		RESETn;
reg		CLK;

reg		sdclk;
reg		hreset_b;
reg		blast_b;
reg		[3:0]	be_b;
reg		[9:0]	size;
// 8051 interfaces
reg		[15:0]	M		;
reg		NMWE	;
//reg			NMOE	;
wire	[7:0]	MD		;
reg		[7:0]	FA		;  
reg		[7:0]	FO	   	;
reg				NSFRWE	;
reg				NSFROE	;
wire	[7:0]	MEM_FI	;

reg		[31:0]	MMCRAM_DATAi;
wire	[31:0]	MMCRAM_DATAo;
reg				NandREQ;
wire			NandRW;
wire			NandEnable;
wire			RSEn_Start;
wire			RSEn_Wait;
wire			RSDe_Start;
wire			RSDe_Wait;
	
reg		[7:0]	NandReadData;
wire	[7:0]	NandWriteData;

wire			mmc_rdy_b;

initial
begin
	be_b = 4'b0000;
	size = 10;
	NMWE = 1;
	NandREQ = 0;
// 8051 interfaces
	CLK 	 = 0;
	RESETn	 = 0;
	sdclk 	 = 0;
	hreset_b = 0;
	blast_b	 = 1;
	NSFRWE	 = 1;
	NSFROE	 = 1;
	MMCRAM_DATAi=0;
	M =0;
end

always
begin
	#10	sdclk = ~sdclk ;
end

always 
begin
	#5	CLK = ~CLK;
end

integer i;
initial
begin
	#200
	RESETn = 1;
	hreset_b	= 1;
	$display ("Cpu Select RAM 0 Setting");
	Reg_Write(0,	8'b10000001);
	Reg_Write(1,	8'b00000100);
	Reg_Write(2,	8'b00000010);
	$display ("Cpu Access RAM 0 Write");

	for(i=0; i<2048 ; i= i+1)
	begin
	Mem_Write(i,i);
	end
	$display ("Cpu Access RAM 0 Read");

	for(i=0; i<2048 ; i= i+1)
	begin
	Mem_Read(i);
	end

	$display ("Cpu Select RAM 0 Setting");
	Reg_Write(0,	8'b00000100);
	$display ("Cpu Access RAM 0 Write");


	for(i=0; i<2048 ; i= i+1)
	begin
	Mem_Write(i,i);
	end
	$display ("Cpu Access RAM 0 Read");

	for(i=0; i<2048 ; i= i+1)
	begin
	Mem_Read(i);
	end
end


task Reg_Write;
input	[7:0]	ADDR;
input	[7:0]	DATA; 
begin

	FA	= 	ADDR;
	FO	=	DATA;
	@(posedge CLK)
	#2 NSFRWE	= 0;
	@(posedge CLK)
	#2 NSFRWE	= 1;
end
endtask

task Reg_Read;
input	[7:0]	ADDR;
begin
	FA	= ADDR;
	@(posedge CLK)
	#2 NSFROE = 0;
	@(posedge CLK)
	#2 NSFROE = 1;
end
endtask

task Mem_Write;
input	[15:0]	ADDR;
input	[7:0]	DATA;
begin
	M	=	ADDR;
	FO	= DATA;
	@(posedge CLK)
	#2 NMWE = 0;
	@(posedge CLK)
	#2 NMWE	= 1;
end
endtask

task Mem_Read;
input	[15:0]	ADDR;
begin
	M	=	ADDR;
	@(posedge CLK);
//	#2	NMOE = 0;
	@(posedge CLK);
	M= 0;
//	#2 	NMOE  =1;
end
endtask




MemCtrlTop MEMCtrl(
		.RESETn			(RESETn			),
		.CLK			(CLK			),
		.sdclk			(sdclk			),
		.hreset_b		(hreset_b		),
		.blast_b		(blast_b		),
		.be_b			(be_b			),
		.size			(size			),
		.mmc_rdy_b		(mmc_rdy_b		),
		.M				(M				),
		.NMWE			(NMWE			),
		//NMOE,          
		.MD				(MD				),
		.FA	 			(FA	 			),  
		.FO	   			(FO	   			),
		.NSFRWE			(NSFRWE			),
		.NSFROE			(NSFROE			),
		.MEM_FI			(MEM_FI			),
		                                
		.MMCRAM_DATAi	(MMCRAM_DATAi	),
		.MMCRAM_DATAo	(MMCRAM_DATAo	),
                                        
                                        
		.NandREQ		(NandREQ		),
		.NandRW			(NandRW			),
		.NandEnable		(NandEnable		),
		.RSEn_Start		(RSEn_Start		),
		.RSEn_Wait		(RSEn_Wait		),
		.RSDe_Start		(RSDe_Start		),
		.RSDe_Wait		(RSDe_Wait		),
                                        
		.NandWriteData	(NandWriteData	),
		.NandReadData	(NandReadData	)
);

endmodule
