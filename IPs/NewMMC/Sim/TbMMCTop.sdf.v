`timescale 1ns/1ps
module TbMMCTop;

reg				PCLK	;
reg				PRESETn	;
reg				PENABLE	;
reg				PSEL    ;
reg				PWRITE  ;
reg		[4:0]	PADDR   ;
reg		[31:0]	PWDATA  ;
wire	[31:0]	PRDATA  ;

wire			MMC_CMDIN;
wire [3:0]		MMC_DATIN;
wire			MMC_INT;
wire			MMC_DMAREQ;
wire			MMC_CLKOUT;
wire			MMC_CMDOUT;
wire [3:0]		MMC_DATOUT;
wire 			MMC_nCMDEN;
wire			MMC_nDATEN;

reg		[31:0]  REGVALUE;
reg		[31:0]  REGVALUE0;

parameter HALFCYCLE = 5; // 100MHz

initial 
	begin
$sdf_annotate("../Syn/Sdf/MMCTop.noscan.sdf", TbMMCTop. MMC);
		PCLK = 0;
		PRESETn = 0;
		PENABLE	= 0;
		PSEL	= 0;
		PADDR	= 0;
		PWDATA  = 0;
		PWRITE  = 0;
		#100 PRESETn = 1;
	end

always 
 # HALFCYCLE PCLK = ~PCLK;

initial
	begin
	$display ("MMC Initial Value Check");

	#200 APB_READandCOMPARE(0,0);
	#200 APB_READandCOMPARE(1,1);
	#200 APB_READandCOMPARE(2,0);
	#200 APB_READandCOMPARE(3,0);
	#200 APB_READandCOMPARE(4,0);
	#200 APB_READandCOMPARE(5,0);
	#200 APB_READandCOMPARE(6,0);
	#200 APB_READandCOMPARE(7,0);
	#200 APB_READandCOMPARE(8,0);
	#200 APB_READandCOMPARE(9,32'h00010000);
	#200 APB_READandCOMPARE(10,0);
	#200 APB_READandCOMPARE(11,32'h20000000);
	#200 APB_READandCOMPARE(12,0);
	#200 APB_READandCOMPARE(13,0);
	#200 APB_READandCOMPARE(14,0);
	#200 APB_READandCOMPARE(15,0);
	#200 APB_READandCOMPARE(16,0);
	#200 APB_READandCOMPARE(18,0);
	#200 APB_READandCOMPARE(19,0);
	#200 APB_READandCOMPARE(20,0);
	#200 APB_READandCOMPARE(21,0);

	// Delay Cell Check

	#200 APB_WRITE(21 , 32'h00000009);



	$display ("MMC Initialize Sequence");
	#200 APB_WRITE(5'h01 , 32'h00000000);// Prescaler Setting 1/2 clock
		#200 APB_WRITE(5'h00 , 32'h00000001);// SDCON Setting Clock Enable
	#200 APB_WRITE(5'h0f , 32'h00000000);// all interrupt disable
	#200 APB_WRITE(5'h02 , 32'h00000000);// argument Setting 
	
	#200 APB_WRITE(5'h03 , 32'h00000140);// CMDCONTROL Setting //CMD0 & Start 
	$display ("MMC CMD0 Send");
	REGVALUE = 0;
		while ((REGVALUE&32'h00000800) != 32'h00000800) // CMDSent Check
		begin
			APB_READVALUE(5'h04,REGVALUE);
		end
	#200 APB_WRITE(5'h04 , 32'h0000ffff); // CMDSent Bit Clear

	#10000; 


	REGVALUE0 = 0;
	while ((REGVALUE0&32'h80000000) ==32'h00000000 )
	begin
		#200 APB_WRITE(5'h02 , 32'h00ff8000); // Argument is 0
		#200 APB_WRITE(5'h03 , 32'h00002341);// CMDCONTROL Setting //CMD1 & Start 
		$display ("MMC CMD1 Send");
		REGVALUE = 0;
			while ((REGVALUE&32'h00000200) != 32'h00000200) // RspFin Check
			begin
				APB_READVALUE(5'h04,REGVALUE);
			end
		#200 APB_WRITE(5'h04 , 32'h0000ffff); // CMDSent Bit Clear
		#200 APB_READVALUE(5'h05,REGVALUE0);
	end

	#200 APB_WRITE(5'h02 , 32'h00ff8000); // Argument is 0
	#200 APB_WRITE(5'h03 , 32'h00002742);// CMDCONTROL Setting //CMD1 & Start 
	$display ("MMC CMD2 Send");
	REGVALUE = 0;
		while ((REGVALUE&32'h00000200) != 32'h00000200) // RspFin Check
		begin
			APB_READVALUE(5'h04,REGVALUE);
		end
	#200 APB_WRITE(5'h04 , 32'h0000ffff); // CMDSent Bit Clear

	$display ("MMC CMD3 Send");
	#200 APB_WRITE(5'h02 , 32'h00010000); 
	#200 APB_WRITE(5'h03 , 32'h00000343); 
	REGVALUE = 32'h0;
		while ( (REGVALUE&32'h00000200) != 32'h00000200) // RspFin Check
		begin
			APB_READVALUE(5'h04,REGVALUE);
		end
	#200 APB_WRITE(5'h04 , 32'h0000ffff); 
		

	$display ("MMC CMD7 Send");
	#200 APB_WRITE(5'h02 , 32'h00010000); 
	#200 APB_WRITE(5'h03 , 32'h00000347); 
	REGVALUE = 32'h0;
		while ( (REGVALUE&32'h00000200) != 32'h00000200) // RspFin Check
		begin
			APB_READVALUE(5'h04,REGVALUE);
		end
	#200 APB_WRITE(5'h04 , 32'h0000ffff); 
		
		

	$display ("MMC CMD6 Send");
	#200 APB_WRITE(5'h02 , 32'h03b70100); 
	#200 APB_WRITE(5'h03 , 32'h00004346); 
	REGVALUE = 32'h0;
		while ( (REGVALUE&32'h00000008) != 32'h00000008) // RspFin Check
		begin
			APB_READVALUE(5'h0D,REGVALUE);
		end
	#200 APB_WRITE(5'h04 , 32'h0000ffff); 
	#200 APB_WRITE(5'h0D , 32'h0000ffff); 


	$display ("MMC CMD13 Send");
	#200 APB_WRITE(5'h02 , 32'h00010000); 
	#200 APB_WRITE(5'h03 , 32'h0000034d); 
	REGVALUE = 32'h0;
		while ( (REGVALUE&32'h00000200) != 32'h00000200) // RspFin Check
		begin
			APB_READVALUE(5'h04,REGVALUE);
		end
	#200 APB_WRITE(5'h04 , 32'h0000ffff); 


	$display ("MMC CMD16 Send");
	#200 APB_WRITE(5'h02 , 32'h00000200); 
	#200 APB_WRITE(5'h03 , 32'h00000350); 
	REGVALUE = 32'h0;
		while ( (REGVALUE&32'h00000200) != 32'h00000200) // RspFin Check
		begin
			APB_READVALUE(5'h04,REGVALUE);
		end
	#200 APB_WRITE(5'h04 , 32'h0000ffff); 



	$display ("MMC Power Save Mode On");
	#200 APB_WRITE(5'h00 , 32'h00000003); 


	$display ("MMC Frequency Max ");
	#200 APB_WRITE(5'h01 , 32'h00000000); 

	#200 APB_WRITE(5'h0b , 32'h00000000); 
	#200 APB_WRITE(5'h0e , 32'hffffffff); // Fifo Clear

	#200 APB_WRITE(5'h0a , 32'h000001ff);  // Block Size 512 byte

	#200 APB_WRITE(5'h0b , 32'h03570000); // Fifo Setting


	$display ("MMC OneBlock Write Test ");
	REGVALUE = 32'h0;
		while ( (REGVALUE&32'h00002000) != 32'h00002000) //Fifo available
		begin
			APB_READVALUE(5'h0e,REGVALUE);
		end


	#200 APB_WRITE(5'h11 , 32'h00000001); 
	#200 APB_WRITE(5'h11 , 32'h00000002); 
	#200 APB_WRITE(5'h11 , 32'h00000003); 
	#200 APB_WRITE(5'h11 , 32'h00000004); 
	#200 APB_WRITE(5'h11 , 32'h00000005); 
	#200 APB_WRITE(5'h11 , 32'h00000006); 
	#200 APB_WRITE(5'h11 , 32'h00000007); 
	#200 APB_WRITE(5'h11 , 32'h00000008); 
	#200 APB_WRITE(5'h11 , 32'h00000009); 
	#200 APB_WRITE(5'h11 , 32'h0000000a); 
	#200 APB_WRITE(5'h11 , 32'h0000000b); 
	#200 APB_WRITE(5'h11 , 32'h0000000c); 
	#200 APB_WRITE(5'h11 , 32'h0000000d); 
	#200 APB_WRITE(5'h11 , 32'h0000000e); 
	#200 APB_WRITE(5'h11 , 32'h0000000f); 
	#200 APB_WRITE(5'h11 , 32'h00000010); 
	#200 APB_WRITE(5'h11 , 32'h00000011); 
	#200 APB_WRITE(5'h11 , 32'h00000012); 
	#200 APB_WRITE(5'h11 , 32'h00000013); 
	#200 APB_WRITE(5'h11 , 32'h00000014); 
	#200 APB_WRITE(5'h11 , 32'h00000015); 
	#200 APB_WRITE(5'h11 , 32'h00000016); 
	#200 APB_WRITE(5'h11 , 32'h00000017); 
	#200 APB_WRITE(5'h11 , 32'h00000018); 
	#200 APB_WRITE(5'h11 , 32'h00000019); 
	#200 APB_WRITE(5'h11 , 32'h0000001a); 
	#200 APB_WRITE(5'h11 , 32'h0000001b); 
	#200 APB_WRITE(5'h11 , 32'h0000001c); 
	#200 APB_WRITE(5'h11 , 32'h0000001d); 
	#200 APB_WRITE(5'h11 , 32'h0000001e); 
	#200 APB_WRITE(5'h11 , 32'h0000001f); 
	#200 APB_WRITE(5'h11 , 32'h00000020); 
	#200 APB_WRITE(5'h02 , 32'h00000000); 
	#200 APB_WRITE(5'h03 , 32'h00000358); 
	REGVALUE = 32'h0;
		while ( (REGVALUE&32'h00000400) != 32'h00000400) //Fifo Empty check
		begin
			APB_READVALUE(5'h0e,REGVALUE);
		end
	#200 APB_WRITE(5'h11 , 32'h00000021); 
	#200 APB_WRITE(5'h11 , 32'h00000022); 
	#200 APB_WRITE(5'h11 , 32'h00000023); 
	#200 APB_WRITE(5'h11 , 32'h00000024); 
	#200 APB_WRITE(5'h11 , 32'h00000025); 
	#200 APB_WRITE(5'h11 , 32'h00000026); 
	#200 APB_WRITE(5'h11 , 32'h00000027); 
	#200 APB_WRITE(5'h11 , 32'h00000028); 
	#200 APB_WRITE(5'h11 , 32'h00000029); 
	#200 APB_WRITE(5'h11 , 32'h0000002a); 
	#200 APB_WRITE(5'h11 , 32'h0000002b); 
	#200 APB_WRITE(5'h11 , 32'h0000002c); 
	#200 APB_WRITE(5'h11 , 32'h0000002d); 
	#200 APB_WRITE(5'h11 , 32'h0000002e); 
	#200 APB_WRITE(5'h11 , 32'h0000002f); 
	#200 APB_WRITE(5'h11 , 32'h00000030); 
	#200 APB_WRITE(5'h11 , 32'h00000031); 
	#200 APB_WRITE(5'h11 , 32'h00000032); 
	#200 APB_WRITE(5'h11 , 32'h00000033); 
	#200 APB_WRITE(5'h11 , 32'h00000034); 
	#200 APB_WRITE(5'h11 , 32'h00000035); 
	#200 APB_WRITE(5'h11 , 32'h00000036); 
	#200 APB_WRITE(5'h11 , 32'h00000037); 
	#200 APB_WRITE(5'h11 , 32'h00000038); 
	#200 APB_WRITE(5'h11 , 32'h00000039); 
	#200 APB_WRITE(5'h11 , 32'h0000003a); 
	#200 APB_WRITE(5'h11 , 32'h0000003b); 
	#200 APB_WRITE(5'h11 , 32'h0000003c); 
	#200 APB_WRITE(5'h11 , 32'h0000003d); 
	#200 APB_WRITE(5'h11 , 32'h0000003e); 
	#200 APB_WRITE(5'h11 , 32'h0000003f); 
	#200 APB_WRITE(5'h11 , 32'h00000040); 
	REGVALUE = 32'h0;
		while ( (REGVALUE&32'h00000400) != 32'h00000400) //Fifo Empty check
		begin
			APB_READVALUE(5'h0e,REGVALUE);
		end
	#200 APB_WRITE(5'h11 , 32'h00000041); 
	#200 APB_WRITE(5'h11 , 32'h00000042); 
	#200 APB_WRITE(5'h11 , 32'h00000043); 
	#200 APB_WRITE(5'h11 , 32'h00000044); 
	#200 APB_WRITE(5'h11 , 32'h00000045); 
	#200 APB_WRITE(5'h11 , 32'h00000046); 
	#200 APB_WRITE(5'h11 , 32'h00000047); 
	#200 APB_WRITE(5'h11 , 32'h00000048); 
	#200 APB_WRITE(5'h11 , 32'h00000049); 
	#200 APB_WRITE(5'h11 , 32'h0000004a); 
	#200 APB_WRITE(5'h11 , 32'h0000004b); 
	#200 APB_WRITE(5'h11 , 32'h0000004c); 
	#200 APB_WRITE(5'h11 , 32'h0000004d); 
	#200 APB_WRITE(5'h11 , 32'h0000004e); 
	#200 APB_WRITE(5'h11 , 32'h0000004f); 
	#200 APB_WRITE(5'h11 , 32'h00000050); 
	#200 APB_WRITE(5'h11 , 32'h00000051); 
	#200 APB_WRITE(5'h11 , 32'h00000052);
	#200 APB_WRITE(5'h11 , 32'h00000053); 
	#200 APB_WRITE(5'h11 , 32'h00000054); 
	#200 APB_WRITE(5'h11 , 32'h00000055); 
	#200 APB_WRITE(5'h11 , 32'h00000056); 
	#200 APB_WRITE(5'h11 , 32'h00000057); 
	#200 APB_WRITE(5'h11 , 32'h00000058); 
	#200 APB_WRITE(5'h11 , 32'h00000059); 
	#200 APB_WRITE(5'h11 , 32'h0000005a); 
	#200 APB_WRITE(5'h11 , 32'h0000005b); 
	#200 APB_WRITE(5'h11 , 32'h0000005c); 
	#200 APB_WRITE(5'h11 , 32'h0000005d); 
	#200 APB_WRITE(5'h11 , 32'h0000005e); 
	#200 APB_WRITE(5'h11 , 32'h0000005f); 
	#200 APB_WRITE(5'h11 , 32'h00000060); 
	REGVALUE = 32'h0;
		while ( (REGVALUE&32'h00000400) != 32'h00000400) //Fifo Empty check
		begin
			APB_READVALUE(5'h0e,REGVALUE);
		end

	#200 APB_WRITE(5'h11 , 32'h00000061); 
	#200 APB_WRITE(5'h11 , 32'h00000062); 
	#200 APB_WRITE(5'h11 , 32'h00000063); 
	#200 APB_WRITE(5'h11 , 32'h00000064); 
	#200 APB_WRITE(5'h11 , 32'h00000065); 
	#200 APB_WRITE(5'h11 , 32'h00000066); 
	#200 APB_WRITE(5'h11 , 32'h00000067); 
	#200 APB_WRITE(5'h11 , 32'h00000068); 
	#200 APB_WRITE(5'h11 , 32'h00000069); 
	#200 APB_WRITE(5'h11 , 32'h0000006a); 
	#200 APB_WRITE(5'h11 , 32'h0000006b); 
	#200 APB_WRITE(5'h11 , 32'h0000006c); 
	#200 APB_WRITE(5'h11 , 32'h0000006d); 
	#200 APB_WRITE(5'h11 , 32'h0000006e); 
	#200 APB_WRITE(5'h11 , 32'h0000006f); 
	#200 APB_WRITE(5'h11 , 32'h00000070); 
	#200 APB_WRITE(5'h11 , 32'h00000071); 
	#200 APB_WRITE(5'h11 , 32'h00000072); 
	#200 APB_WRITE(5'h11 , 32'h00000073); 
	#200 APB_WRITE(5'h11 , 32'h00000074); 
	#200 APB_WRITE(5'h11 , 32'h00000075); 
	#200 APB_WRITE(5'h11 , 32'h00000076); 
	#200 APB_WRITE(5'h11 , 32'h00000077); 
	#200 APB_WRITE(5'h11 , 32'h00000078); 
	#200 APB_WRITE(5'h11 , 32'h00000079); 
	#200 APB_WRITE(5'h11 , 32'h0000007a); 
	#200 APB_WRITE(5'h11 , 32'h0000007b); 
	#200 APB_WRITE(5'h11 , 32'h0000007c); 
	#200 APB_WRITE(5'h11 , 32'h0000007d); 
	#200 APB_WRITE(5'h11 , 32'h0000007e); 
	#200 APB_WRITE(5'h11 , 32'h0000007f); 
	#200 APB_WRITE(5'h11 , 32'h00000080); 
	REGVALUE = 32'h0;
		while ( (REGVALUE&32'h00000400) != 32'h00000400) //Fifo Empty check
		begin
			APB_READVALUE(5'h0e,REGVALUE);
		end
	#200 APB_WRITE(5'h04 , 32'h0000ffff); 
	#200 APB_READ(5'h0c); // Data Count Check


	REGVALUE = 32'h0;
		while ( (REGVALUE&32'h00000010) != 32'h00000010) // DatFin Check
		begin
			APB_READVALUE(5'h0d,REGVALUE);
		end
	#200 APB_WRITE(5'h0d , 32'hffffffff); 



	$display ("MMC OneBlock Read Test ");

	#200 APB_WRITE(5'h0a , 32'h000001ff); // MMC Block Size is 512byte
	#200 APB_WRITE(5'h09 , 32'h001fffff); // Timout Conter set
	#200 APB_WRITE(5'h0b , 32'h03000000); // data mode is Nooperation
	#200 APB_WRITE(5'h0e , 32'hffffffff); // FIFO Reset
	#200 APB_WRITE(5'h0b , 32'h03560000); // Data Mode is Rx and start
	#200 APB_WRITE(5'h02 , 32'h00000000); // Address 0
	#200 APB_WRITE(5'h03 , 32'h00000351); // Command Control Register CMD 17

	REGVALUE = 32'h0;
		while ( (REGVALUE&32'h00000010) != 32'h00000010) // CmdSent Check
		begin
			APB_READVALUE(5'h04,REGVALUE);
		end

	REGVALUE = 32'h0;
		while ( (REGVALUE&32'h00000100) != 32'h00000100) // FIFO Full ? 
		begin
			APB_READVALUE(5'h0e,REGVALUE);
		end
	#200 APB_WRITE(5'h04 , 32'h0000ffff); 
	repeat (32) APB_READ(5'h11);

	REGVALUE = 32'h0;
		while ( (REGVALUE&32'h00000100) != 32'h00000100) // FIFO Full ? 
		begin
			APB_READVALUE(5'h0e,REGVALUE);
		end
	repeat (32) APB_READ(5'h11);

	REGVALUE = 32'h0;
		while ( (REGVALUE&32'h00000100) != 32'h00000100) // FIFO Full ? 
		begin
			APB_READVALUE(5'h0e,REGVALUE);
		end
	repeat (32) APB_READ(5'h11);

	REGVALUE = 32'h0;
		while ( (REGVALUE&32'h00000100) != 32'h00000100) // FIFO Full ? 
		begin
			APB_READVALUE(5'h0e,REGVALUE);
		end
	repeat (32) APB_READ(5'h11);

	REGVALUE = 32'h0;
		while ( (REGVALUE&32'h00000010) != 32'h00000010) // DatFin Check
		begin
			APB_READVALUE(5'h0d,REGVALUE);
		end
	#200 APB_WRITE(5'h0d , 32'hffffffff); 


	$display ("MMC DMA WRITE MODE TEST	");






	$display ("MMC DMA READ MODE TEST	");

	end

always @(posedge MMC_INT) begin
	$display (" Interrupt Occur");
end

always @(posedge MMC_DMAREQ) begin
	$display (" DMA REQUEST Occur");
end


MMCTop	MMC(
	.PCLK			(PCLK),
	.PRESETn		(PRESETn),
	.PSEL			(PSEL),
	.PENABLE		(PENABLE),
	.PWRITE			(PWRITE),
	.PADDR			(PADDR),
	.PWDATA			(PWDATA),		
 	
	.PRDATA			(PRDATA),
	
	.MMC_FBCLK		(MMC_CLKOUT),
	.MMC_CMDIN		(MMC_CMDIN),
	.MMC_DATIN		(MMC_DATIN),

	.TESTMODE		(1'b0), // for Scan insertion

	.MMC_INT		(MMC_INT),
	.MMC_DMAREQ		(MMC_DMAREQ),
	.MMC_CLKOUT		(MMC_CLKOUT),
	.MMC_CMDOUT		(MMC_CMDOUT),
	.MMC_DATOUT		(MMC_DATOUT),
	.MMC_nCMDEN		(MMC_nCMDEN),	
	.MMC_nDATEN		(MMC_nDATEN)	
	
		);

tri [3:0] MMC_DAT;
tri MMC_CMD;
assign	MMC_DATIN = MMC_DAT;
assign	MMC_CMDIN= MMC_CMD;
assign	MMC_DAT[3] = (MMC_nDATEN == 1'b0) ? MMC_DATOUT[3]: 1'bz ;
assign	MMC_DAT[2] = (MMC_nDATEN == 1'b0) ? MMC_DATOUT[2]: 1'bz ;
assign	MMC_DAT[1] = (MMC_nDATEN == 1'b0) ? MMC_DATOUT[1]: 1'bz ;
assign	MMC_DAT[0] = (MMC_nDATEN == 1'b0) ? MMC_DATOUT[0]: 1'bz ;
assign	MMC_CMD    = (MMC_nCMDEN == 1'b0) ? MMC_CMDOUT: 1'bz ;

// MMC
pullup (MMC_CMD);
pullup (MMC_DAT[3]);
pullup (MMC_DAT[2]);
pullup (MMC_DAT[1]);
pullup (MMC_DAT[0]);

// MMC Device Model
S3F49SAX MMC1GB(
                .MCLK(MMC_CLKOUT),
                .MCMD(MMC_CMD),
                .MDAT7(),
                .MDAT6(),
                .MDAT5(),
                .MDAT4(),
                .MDAT3(MMC_DAT[3]),      // MCS  common
                .MDAT2(MMC_DAT[2]),
                .MDAT1(MMC_DAT[1]),
                .MDAT0(MMC_DAT[0])
                );

parameter DLY = 1;
task APB_READ;
input	[31:0]	Addr;
begin
		@(posedge PCLK);
  		#DLY 	PADDR   = Addr[4:0];
       			PENABLE = 1'b0;
       			PSEL    = 1'b1;
		       	PWRITE  = 1'b0;
       repeat(1) @(posedge PCLK);
	  	#DLY 	PENABLE = 1'b1;
       repeat(1) @(posedge PCLK);
		$display ("APB Register READ Value: %b\n",PRDATA);
		#DLY 	PENABLE = 1'b0;
				PSEL    = 1'b0;
       repeat(1) @(posedge PCLK);
	
end
endtask

task APB_READVALUE;
input	[31:0]	Addr;
output	[31:0]	Data;
begin
		@(posedge PCLK);
  		#DLY 	PADDR   = Addr[4:0];
       			PENABLE = 1'b0;
       			PSEL    = 1'b1;
		       	PWRITE  = 1'b0;
       repeat(1) @(posedge PCLK);
	  	#DLY 	PENABLE = 1'b1;
       repeat(1) @(posedge PCLK);
				Data = PRDATA;
		#DLY 	PENABLE = 1'b0;
				PSEL    = 1'b0;
       repeat(1) @(posedge PCLK);
end
endtask
	






task APB_READandCOMPARE;
input	[31:0]	Addr;
input	[31:0]	Data;
begin
		@(posedge PCLK);
  		#DLY 	PADDR   = Addr[4:0];
       			PENABLE = 1'b0;
       			PSEL    = 1'b1;
		       	PWRITE  = 1'b0;
       repeat(1) @(posedge PCLK);
	  	#DLY 	PENABLE = 1'b1;
       repeat(1) @(posedge PCLK);
		$display ("APB Register READ Value: %b\n",PRDATA);
			if (PRDATA!=Data)
			begin
			$display ("Not Matched\n");
			$Finish;
			end 
		#DLY 	PENABLE = 1'b0;
				PSEL    = 1'b0;
       repeat(1) @(posedge PCLK);
end
endtask	

task APB_WRITE;
input	[31:0]	Addr;
input	[31:0]	Wdata;
begin
		@(posedge PCLK);
		#DLY 	PADDR   = Addr[4:0];
	 			PWDATA  = Wdata;
	 			PENABLE = 1'b0;
	 			PSEL    = 1'b1;
	 			PWRITE  = 1'b1;
	 repeat(1) @(posedge PCLK);
		#DLY 	PENABLE = 1'b1;
	 repeat(1) @(posedge PCLK);
		#DLY 	PENABLE = 1'b0;
	 			PSEL    = 1'b0;
	 repeat(1) @(posedge PCLK);
end
endtask

endmodule
