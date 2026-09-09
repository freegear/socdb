`include "mmcParams.v"
`timescale 1ns/10ps

module tb_mmc;



tri		MMC_CMD;
tri		[7:0]	MMC_DAT	;

wire	[7:0]	MMC_DATIN;

wire	MMC_CMDOUT;
wire	[7:0]	MMC_DATOUT;
wire	MMC_nDATEN;
wire	MMC_nCMDEN;
reg		PCLK;
reg		PRESETn;
reg	[31:0]	PWDATA;
reg [7:2]	PADDR;
reg		PENABLE;
reg		PSEL;
reg		PWRITE;

reg		Busy;

wire	[31:0]	PRDATA;
assign	MMC_DATIN = MMC_DAT;
assign	MMC_CMDIN= MMC_CMD;

assign	MMC_DAT[7] = (MMC_nDATEN == 1'b0) ? MMC_DATOUT[7]: 1'bz ;
assign	MMC_DAT[6] = (MMC_nDATEN == 1'b0) ? MMC_DATOUT[6]: 1'bz ;
assign	MMC_DAT[5] = (MMC_nDATEN == 1'b0) ? MMC_DATOUT[5]: 1'bz ;
assign	MMC_DAT[4] = (MMC_nDATEN == 1'b0) ? MMC_DATOUT[4]: 1'bz ;
assign	MMC_DAT[3] = (MMC_nDATEN == 1'b0) ? MMC_DATOUT[3]: 1'bz ;
assign	MMC_DAT[2] = (MMC_nDATEN == 1'b0) ? MMC_DATOUT[2]: 1'bz ;
assign	MMC_DAT[1] = (MMC_nDATEN == 1'b0) ? MMC_DATOUT[1]: 1'bz ;
assign	MMC_DAT[0] = (MMC_nDATEN == 1'b0) ? MMC_DATOUT[0]: 1'bz ;
assign	MMC_CMD    = (MMC_nCMDEN == 1'b0) ? MMC_CMDOUT: 1'bz ;

pullup  (MMC_DAT[7]);
pullup  (MMC_DAT[6]);
pullup  (MMC_DAT[5]);
pullup  (MMC_DAT[4]);
pullup  (MMC_DAT[3]);
pullup  (MMC_DAT[2]);
pullup  (MMC_DAT[1]);
pullup  (MMC_DAT[0]);
pullup	(MMC_CMD);

// ---------------------------------------------------------------
// clock and reset
// ---------------------------------------------------------------
wire	MMC_FBCLK;
assign  #3 MMC_FBCLK =  PCLK;
assign  MCLK = PCLK;
assign	nMCLK = ~MCLK;
initial 
begin
	PCLK = 1'b0;
	PRESETn = 1'b0;
	#100
	PRESETn = 1'b1;
	#100
	PRESETn = 1'b0;
	#100
	PRESETn = 1'b1;
	
end

always #5 PCLK = ~PCLK;


initial
begin

PWDATA	= 32'd0;
PENABLE = 1'b0;
PSEL    = 1'b0;
PWRITE  = 1'b0;
PADDR	= 32'd0;
#1000
// ---------------------------------------------------------------
// initial value check 
// ---------------------------------------------------------------
		APBRead ({`SDICONAddr,	 2'b00}	);
#100	APBRead ({`SDIPREAddr,	 2'b00}	); 
#100	APBRead ({`SDICmdArgAddr,2'b00} );
#100	APBRead ({`SDICmdConAddr,2'b00} );
#100	APBRead ({`SDICmdStaAddr,2'b00}	);
#100	APBRead ({`SDIRSP0Addr,	 2'b00} );
#100	APBRead ({`SDIRSP1Addr,	 2'b00}	);
#100	APBRead ({`SDIRSP2Addr,	 2'b00}	);
#100	APBRead ({`SDIRSP3Addr,	 2'b00}	);
#100	APBRead ({`SDIDTimerAddr,2'b00}	);
#100	APBRead ({`SDIBSizeAddr, 2'b00}	);
#100	APBRead ({`SDIDatConAddr,2'b00}	);
#100	APBRead ({`SDIDatCntAddr,2'b00}	);
#100	APBRead ({`SDIDatStaAddr,2'b00}	);
#100	APBRead ({`SDIFSTAAddr,  2'b00}	);
#100	APBRead ({`SDIIntMskAddr,2'b00}	);
#100	APBRead ({`SDIDATAddr,	 2'b00}	);

// ---------------------------------------------------------------
// initial value check 
// ---------------------------------------------------------------

	APBWrite ({`SDIDatConAddr, 2'b00} ,{6'b001000, 11'b00000000000,1'b0,2'b11 ,12'd1});
	// Transmit modeb setting
// ---------------------------------------------------------------
// Transmiit FIFO write Test & Full, Half signal check (BUS)
// ---------------------------------------------------------------

#100	APBWrite ({`SDIDATAddr,2'b00}, 32'h00000000);
#100	APBWrite ({`SDIDATAddr,2'b00}, 32'h00000000);
#100	APBWrite ({`SDIDATAddr,2'b00}, 32'h00000000);
#100	APBWrite ({`SDIDATAddr,2'b00}, 32'h00000000);
#100	APBWrite ({`SDIDATAddr,2'b00}, 32'h00000000);
#100	APBWrite ({`SDIDATAddr,2'b00}, 32'h00000000);
#100	APBWrite ({`SDIDATAddr,2'b00}, 32'h00000000);
#100	APBWrite ({`SDIDATAddr,2'b00}, 32'h00000000);
#100	APBWrite ({`SDIDATAddr,2'b00}, 32'h00000000);
#100	APBWrite ({`SDIDATAddr,2'b00}, 32'h00000000);
#100	APBWrite ({`SDIDATAddr,2'b00}, 32'h00000000);
#100	APBWrite ({`SDIDATAddr,2'b00}, 32'h00000000);
#100	APBWrite ({`SDIDATAddr,2'b00}, 32'h00000000);
#100	APBWrite ({`SDIDATAddr,2'b00}, 32'h00000000);
#100	APBWrite ({`SDIDATAddr,2'b00}, 32'h01020304);
#100	APBWrite ({`SDIDATAddr,2'b00}, 32'h05060708);
#100	APBWrite ({`SDIDATAddr,2'b00}, 32'h090A0B0C);
#100	APBWrite ({`SDIDATAddr,2'b00}, 32'h0D0E0F10);

//-----------------------------------------------------------------
// Data Write to MMC Card in block Mode        Check
//-----------------------------------------------------------------
	APBWrite ({`SDIIntMskAddr, 2'b00}, 32'hffffffff);//all interrupt Mask


	APBWrite ({`SDICONAddr,	   2'b00}, {23'd0, 1'b1, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0, 1'b1});
        

	APBWrite ({`SDIPREAddr,    2'b00}, 32'd8  ); // prescaler setting
// identification mode  400KHz (<= Specification 참조)
       	
	#500000// SEND_OP_COND
	APBWrite ({`SDICmdArgAddr, 2'b00}, 32'h00000000);
	APBWrite ({`SDICmdConAddr, 2'b00}, { 19'd0 ,1'b0, 1'b1, 1'b0, 1'b1, 1'b1, 8'b01000001});

	// MMC Card Busy Check
	Busy = 1'b0;
	#10000
	MMCCardBusyChk(Busy);
	
	while(Busy)
	begin
		$display ("[MMC State] Card is Busy ");        
		// SEND_OP_COND(CMD1)
    	APBWrite ({`SDICmdConAddr, 2'b00}, { 19'd0 ,1'b0, 1'b1, 1'b0, 1'b1, 1'b1, 8'b01000001});
					//         WithData,LongRsp,WaitRsp ,CMST,Command index : 1
		#100000
		MMCCardBusyChk(Busy);
	end
	$display ("[MMC State] Card initialize state Done ");        

	#500000//ALL_SEND_CID(CMD2)
	APBWrite ({`SDICmdArgAddr, 2'b00}, 32'h00000000);
	APBWrite ({`SDICmdConAddr, 2'b00}, { 19'd0 ,1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 8'b01000010});
					//         WithData,LongRsp,WaitRsp ,CMST,Command index : 1
	
	$display (" CMD2 (ALL_SEND_CID) sending ");        

	#500000 //set Relative card address(CMD3) 
	APBWrite ({`SDICmdArgAddr, 2'b00}, 32'h00100000);
	APBWrite ({`SDICmdConAddr, 2'b00}, { 19'd0 ,1'b0, 1'b1, 1'b0, 1'b1, 1'b1, 8'b01000011});
					//         WithData,LongRsp,WaitRsp ,CMST,Command index : 1
	$display (" CMD3 (SET_RELATIVE_ADDR) sending ");        
	APBWrite ({`SDIBSizeAddr,  2'b00}, 32'd511);


	#50000 //SEND_CSD(CMD9)
    	APBWrite ({`SDICmdArgAddr, 2'b00}, 32'h00100000);
	APBWrite ({`SDICmdConAddr, 2'b00}, { 19'd0 ,1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 8'b01001001});
					//         WithData,LongRsp,WaitRsp ,CMST,Command index : 1
	$display (" CMD9 (SEND_CSD) sending ");        

	#50000//SEND_CID(CMD10)
	APBWrite ({`SDICmdArgAddr, 2'b00}, 32'h00100000);
	APBWrite ({`SDICmdConAddr, 2'b00}, { 19'd0 ,1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 8'b01001010});
					//         WithData,LongRsp,WaitRsp ,CMST,Command index : 1
	$display (" CMD10 (SEND_CID) sending ");        
        
	#50000 //select Card (CMD7)
	APBWrite ({`SDICmdArgAddr, 2'b00}, 32'h00100000);
	APBWrite ({`SDICmdConAddr, 2'b00}, { 19'd0 ,1'b0, 1'b1, 1'b0, 1'b1, 1'b1, 8'b01000111});
					//         WithData,LongRsp,WaitRsp ,CMST,Command index : 1
	$display (" CMD7 (SELECT_CARD) sending ");        

	#50000 //SET_BLOCKLEN 
	APBWrite ({`SDICmdArgAddr, 2'b00}, 32'd511);
	APBWrite ({`SDICmdConAddr, 2'b00}, { 19'd0 ,1'b0, 1'b1, 1'b0, 1'b1, 1'b1, 8'b01010000});
					//         WithData,LongRsp,WaitRsp ,CMST,Command index : 1
	$display (" CMD16 (SET_BLOCKLEN) sending ");        

	#500000//SWITCH  change bus width (CMD6)
	APBWrite ({`SDICmdArgAddr, 2'b00}, {6'd0, 2'b11, 8'b10110111, 8'b00000010, 5'd0, 3'b000});
	APBWrite ({`SDICmdConAddr, 2'b00}, { 17'd0 ,1'b1 , 1'b0, 1'b0, 1'b1, 1'b0, 1'b1, 1'b1, 8'b01000110});
					//         WithData,LongRsp,WaitRsp ,CMST,Command index : 1
	$display (" CMD6 (SWITCH) sending ");        


	#500000//SEND_EXT_CSD (CMD8) 
	APBWrite ({`SDIFSTAAddr,   2'b00}, { 16'hFFFF,16'hFFFF});
	APBWrite ({`SDICmdArgAddr, 2'b00}, 32'd0);
	APBWrite ({`SDIDatConAddr, 2'b00}, {6'b001000,1'b1, 8'b10011111, 1'b1,16'b1110000000000000});
	APBWrite ({`SDICmdConAddr, 2'b00}, { 19'd0 ,1'b0, 1'b1, 1'b0, 1'b1, 1'b1, 8'b01001000});
					//         WithData,LongRsp,WaitRsp ,CMST,Command index : 1
	$display (" CMD8 (SEND_EXT_CSD) sending ");        

// FIFO full일 때 FIFO를 비우는 동작을 하기위해
#100000
repeat (500)
begin
#5000   APBRead ({`SDIDATAddr,2'b00});
end

	#5000000//WRITE_BLOCK 1블록만 쓰기
	APBWrite ({`SDICmdArgAddr, 2'b00}, 32'd0);
	APBWrite ({`SDIDatConAddr, 2'b00}, {6'b001000,1'b1, 8'b10111111, 1'b1,16'b1111000000000000});// 1block transfer
	APBWrite ({`SDICmdConAddr, 2'b00}, { 19'd0 ,1'b0, 1'b1, 1'b0, 1'b1, 1'b1, 8'b01011000});//single transfer
					//         WithData,LongRsp,WaitRsp ,CMST,Command index : 1
	$display (" CMD24 (WRITE_BLOCK) sending ");        
	
// FIFO가 empty되는 상황에서 FIFO 를 채우는 동작을 하기 위해
#100000
repeat (500)
begin
#5000	APBWrite ({`SDIDATAddr,2'b00}, 32'h04030201);
end


	#300000//READ_BLOCK 1블록만 읽기
	APBWrite ({`SDICmdArgAddr, 2'b00}, 32'd0);
	APBWrite ({`SDIFSTAAddr,   2'b00}, { 16'hFFFF,16'hFFFF});
	$display (" FIFO reset");        
	APBWrite ({`SDIDatConAddr, 2'b00}, {6'b001000,1'b1, 8'b10111111, 1'b1,16'b1110000000000000});
	APBWrite ({`SDICmdConAddr, 2'b00}, { 19'd0 ,1'b0, 1'b1, 1'b0, 1'b1, 1'b1, 8'b01010001});
	$display (" CMD17 (READ_SINGLE_BLOCK) sending ");        

#100000
repeat (500)
begin
#5000   APBRead ({`SDIDATAddr,2'b00});
end

//-----------------------------------------------------------------
// Multi black Write and Read Test
//-----------------------------------------------------------------



	#500000//SET_BLOCK_COUNT
	APBWrite ({`SDICmdArgAddr, 2'b00}, {16'd0,16'b0000000000010000});//Write address
	APBWrite ({`SDICmdConAddr, 2'b00}, { 19'd0 ,1'b0, 1'b1, 1'b0, 1'b1, 1'b1, 8'b01010111});//Multiple transfer
	$display (" CMD16 (SET_BLOCK_COUNT) sending ");        


	#5000000//WRITE_BLOCK Multi블록 쓰기
	APBWrite ({`SDICmdArgAddr, 2'b00}, 32'd0);//Write address
	APBWrite ({`SDIDatConAddr, 2'b00}, {6'b001000,1'b1, 8'b10111111, 1'b1,16'b1111000000010000});// 1block transfer
	APBWrite ({`SDICmdConAddr, 2'b00}, { 19'd0 ,1'b0, 1'b1, 1'b0, 1'b1, 1'b1, 8'b01011001});//Multiple transfer
	                                         //         WithData,LongRsp,WaitRsp ,CMST,Command index : 25
	$display (" CMD25 (WRITE_MULTIPLE_BLOCK) sending ");        

#100000
repeat (10000)
begin
#5000	APBWrite ({`SDIDATAddr,2'b00}, 32'h04030201);
end
	
	#500000//SET_BLOCK_COUNT
	APBWrite ({`SDICmdArgAddr, 2'b00}, {16'd0,16'b0000000000010000});//Write address
	APBWrite ({`SDICmdConAddr, 2'b00}, { 19'd0 ,1'b0, 1'b1, 1'b0, 1'b1, 1'b1, 8'b01010111});//Multiple transfer
	$display (" CMD23 (SET_BLOCK_COUNT) sending ");        
	#5000000//Read_BLOCK Multi블록 read
	APBWrite ({`SDICmdArgAddr, 2'b00}, 32'd0);// Read address
	APBWrite ({`SDIDatConAddr, 2'b00}, {6'b001000,1'b1, 8'b10111111, 1'b1,16'b1110000000010000});// 1block transfer
	APBWrite ({`SDICmdConAddr, 2'b00}, { 19'd0 ,1'b0, 1'b1, 1'b0, 1'b1, 1'b1, 8'b01010010});//Multiple transfer
	                                         //         WithData,LongRsp,WaitRsp ,CMST,Command index : 18
	$display (" CMD18 (READ_MULTIPLE_BLOCK) sending ");        
#100000
repeat (100)
begin
#10000  MMCRead ({`SDIDATAddr,2'b00});
end
	// Abort command CMD12
#10000  MMCRead ({`SDIDATAddr,2'b00});
		APBWrite ({`SDICmdConAddr, 2'b00}, { 19'd0 ,1'b1, 1'b1, 1'b0, 1'b1, 1'b1, 8'b01001100});//Multiple transfer
	$display (" CMD12 (STOP_TRANSMISSION) sending ");        
#10000  MMCRead ({`SDIDATAddr,2'b00});
#10000  MMCRead ({`SDIDATAddr,2'b00});
#10000  MMCRead ({`SDIDATAddr,2'b00});
#10000  MMCRead ({`SDIDATAddr,2'b00});
#10000  MMCRead ({`SDIDATAddr,2'b00});
#10000  MMCRead ({`SDIDATAddr,2'b00});
#10000  MMCRead ({`SDIDATAddr,2'b00});
#10000  MMCRead ({`SDIDATAddr,2'b00});
#10000  MMCRead ({`SDIDATAddr,2'b00});
#10000  MMCRead ({`SDIDATAddr,2'b00});
#10000  MMCRead ({`SDIDATAddr,2'b00});
#10000  MMCRead ({`SDIDATAddr,2'b00});
#10000  MMCRead ({`SDIDATAddr,2'b00});
#10000  MMCRead ({`SDIDATAddr,2'b00});
#10000  MMCRead ({`SDIDATAddr,2'b00});
#10000  MMCRead ({`SDIDATAddr,2'b00});
#10000  MMCRead ({`SDIDATAddr,2'b00});

//-----------------------------------------------------------------
// Data Write to MMC Card in Stream Mode 
//-----------------------------------------------------------------
// Card Not Support This mode

//-----------------------------------------------------------------
// Data Read from MMC Card in Stream Mode 
//-----------------------------------------------------------------
// Card Not Support This mode

end

parameter DLY  = 10;
task APBRead;
input [31:0] Addr;
begin
  #DLY PADDR   = Addr[7:2];
       PENABLE = 1'b0;
       PSEL    = 1'b1;
       PWRITE  = 1'b0;
	repeat(1) @(posedge PCLK);
  #DLY PENABLE = 1'b1;
	repeat(1) @(posedge PCLK);
  #DLY PENABLE = 1'b0;
       PSEL    = 1'b0;
	repeat(3) @(posedge PCLK);
end
endtask

task APBWrite;
input [31:0] Addr;
input [31:0] WData;
begin
  #DLY PADDR   = Addr[7:2];
       PENABLE = 1'b0;
       PSEL    = 1'b1;
       PWRITE  = 1'b1;
       PWDATA  = WData;
	repeat(1) @(posedge PCLK);
  #DLY PENABLE = 1'b1;
	repeat(1) @(posedge PCLK);
  #DLY PENABLE = 1'b0;
       PSEL    = 1'b0;
       PWRITE  = 1'b0;
	repeat(3) @(posedge PCLK);
end
endtask

task MMCCardBusyChk;
output Busy;
begin
  #DLY	PADDR   = `SDIRSP0Addr;
		PENABLE = 1'b0;
		PSEL    = 1'b1;
		PWRITE  = 1'b0;
	repeat(1) @(posedge PCLK);
  #DLY  PENABLE = 1'b1;
  #5
	if (PRDATA[31] == 1'b0)
		Busy = 1'b1;
	else
		Busy = 1'b0;
	repeat(1) @(posedge PCLK);
  #DLY  PENABLE = 1'b0;
		PSEL    = 1'b0;
	repeat(3) @(posedge PCLK);
end
endtask


task MMCRead;
input [31:0] Addr;
begin
	#DLY PADDR   = Addr[7:2];
		PENABLE = 1'b0;
		PSEL    = 1'b1;
		PWRITE  = 1'b0;
	repeat(1) @(posedge PCLK);
	#DLY PENABLE = 1'b1;
	//#5 $display (" MMC Read DATA :  %h  ",PRDATA);
	repeat(1) @(posedge PCLK);
	#DLY PENABLE = 1'b0;
		PSEL    = 1'b0;
	repeat(3) @(posedge PCLK);
end
endtask

mmctop	test_mmc(
		.PCLK		(PCLK),
		.PRESETn	(PRESETn),
		.PSEL		(PSEL),
		.PENABLE	(PENABLE),
		.PWRITE		(PWRITE),
		.PADDR		(PADDR),
		.PWDATA		(PWDATA),	
 	
		.PRDATA		(PRDATA),
			
		.MCLK		(MCLK),
		.nMCLK		(nMCLK),	
		.MMC_FBCLK	(MMC_FBCLK),
		.MMC_CMDIN	(MMC_CMDIN),
		.MMC_DATIN	(MMC_DATIN),

		.MMC_INT	(MMC_INT),
		.MMC_DMAREQ	(MMC_DMAREQ),
		.MMC_CLKOUT	(MMC_CLKOUT),
		.MMC_CMDOUT	(MMC_CMDOUT),
		.MMC_DATOUT	(MMC_DATOUT),
		.MMC_nCMDEN	(MMC_nCMDEN),
		.MMC_nDATEN	(MMC_nDATEN)

	);

S3F49SAX  MMC1GB
	(
		.MCLK	(MMC_CLKOUT), 
		.MCMD	(MMC_CMD),
        .MDAT7	(MMC_DAT[7]),
        .MDAT6	(MMC_DAT[6]),
        .MDAT5	(MMC_DAT[5]),
        .MDAT4	(MMC_DAT[4]),
        .MDAT3	(MMC_DAT[3]),
        .MDAT2	(MMC_DAT[2]),
        .MDAT1	(MMC_DAT[1]),
        .MDAT0	(MMC_DAT[0])
   	 ); 
 

endmodule
// end of fil e
