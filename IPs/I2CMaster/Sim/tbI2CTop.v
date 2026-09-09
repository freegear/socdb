`timescale 1ns/1ps
module I2CTb;


reg				PCLK	;
reg				PRESETn	;
reg				PENABLE	;
reg				PSEL    ;
reg				PWRITE  ;
reg		[5:0]	PADDR   ;
reg		[31:0]	PWDATA  ;
wire	[31:0]	PRDATA  ;

wire	int		; // Interrupt Signal
wire	int_aas ; // Interrupt Signal
wire	SCL_i	;
wire	SCL_o	;
wire	nSCL_En	;
wire	SDA_i	;
wire	SDA_o	;
wire	nSDA_En ;

/*
`define ICCR0		0	 
`define ICCR1		1
`define ICSR		2
`define IAR			3
`define IDSR		4


`define AckEn		7
`define TxClkSel	6
`define TxRxIntEn	5
`define IntPendFlag 4
`define TxClkVal	0

`define HsPreVal	0

`define	OpMode		6
`define	OutputEn	4
`define	StartStop	5

`define	IAR			0

`define	IDSR		0
/*/

parameter HALFCYCLE = 5;

parameter ICCR0REG 	=	0;
parameter ICSRREG  	=	1;
parameter IDSRREG 	=	2;


parameter TxRxIntEn	= 8'b00000001;
parameter AckEn		= 8'b00000010;
parameter OpMode 	= 8'b00000100;
parameter IntPending= 8'b00001000;
//parameter TxClkVal	= 13'b1111111110000;
parameter TxClkVal	= 13'b0000011110000;


parameter OutputEn 	= 8'b00100000;
parameter Start  	= 8'b00010000;
parameter Busy	 	= 8'b00001000;
parameter Arbit	 	= 8'b00000100;
parameter AckValue	= 8'b00000010;
parameter BusError	= 8'b00000001;





initial 
	begin
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


/*
	$display ("I2C Register Initial Value Checking");

	#200 APB_READ(ICCR0REG);
	#200 APB_READ(ICSRREG);
	#200 APB_READ(IDSRREG);

	$display ("I2C Master Tx Mode Test");

	$display ("EEPROM DataWrite ");
*/


// Write
	#200 	APB_WRITE(ICCR0REG	,OpMode|AckEn|TxRxIntEn|TxClkVal);
			APB_WRITE(IDSRREG 	,8'b10100000);

	#200	APB_WRITE(ICSRREG	,Start);
	@(posedge int )

	#10 	APB_WRITE(IDSRREG ,8'b00000000);
			APB_WRITE(ICCR0REG,OpMode|AckEn|TxRxIntEn|IntPending|TxClkVal); // Interrupt Pending clear
	@(posedge int ) // Sub Address

	#10 	APB_WRITE(IDSRREG ,8'b01010101);
			APB_WRITE(ICCR0REG,OpMode|AckEn|TxRxIntEn|IntPending|TxClkVal); // Interrupt Pending clear
	@(posedge int ) // Sub Address

	#10 	APB_WRITE(IDSRREG ,8'b10101010);
			APB_WRITE(ICCR0REG,OpMode|AckEn|TxRxIntEn|IntPending|TxClkVal); // Interrupt Pending clear
	@(posedge int ) // Sub Address

	#10 	APB_WRITE(IDSRREG ,8'b11111000);
			APB_WRITE(ICCR0REG,OpMode|AckEn|TxRxIntEn|IntPending|TxClkVal); // Interrupt Pending clear
	@(posedge int ) // Sub Address

	#10 APB_WRITE(ICSRREG	,0); // Stop
	APB_WRITE(ICCR0REG, AckEn|TxRxIntEn|IntPending|TxClkVal); // Interrupt Pending clear






/// read

	#2000 	APB_WRITE(ICCR0REG	,OpMode|AckEn|TxRxIntEn|IntPending|TxClkVal);
			APB_WRITE(IDSRREG 	,8'b10100000);

	#200	APB_WRITE(ICSRREG	,Start);
	@(posedge int )

	#10 	APB_WRITE(IDSRREG ,8'b00000000);
			APB_WRITE(ICCR0REG,OpMode|AckEn|TxRxIntEn|IntPending|TxClkVal); // Interrupt Pending clear
	@(posedge int ) // Sub Address


	// Repeat Start
	#200 	APB_WRITE(IDSRREG 	,8'b10100001); // Read Mode Address Setting
			APB_WRITE(ICSRREG	,Start);
			APB_WRITE(ICCR0REG,OpMode|AckEn|TxRxIntEn|IntPending|TxClkVal); // Interrupt Pending clear
	@(posedge int ) // Repeat Start Address


	#10 	APB_WRITE(ICCR0REG, AckEn|TxRxIntEn|IntPending|TxClkVal); // Interrupt Pending clear and RX Mode
	@(posedge int ) // Data Read

	#10 	APB_WRITE(ICCR0REG, AckEn|TxRxIntEn|IntPending|TxClkVal); // Interrupt Pending clear and RX Mode
	@(posedge int ) // Data Read

	#10 	APB_WRITE(ICCR0REG, AckEn|TxRxIntEn|IntPending|TxClkVal); // Interrupt Pending clear and RX Mode
	@(posedge int ) // Data Read

	#10 APB_WRITE(ICSRREG	,0); // Stop
		APB_WRITE(ICCR0REG, AckEn|TxRxIntEn|IntPending|TxClkVal); // Interrupt Pending clear

/*	
	#700000 APB_WRITE(ICSRREG,OpMode|OutputEn);
		APB_WRITE(0,8'b11010110); // Interrupt Pending clear
	$display ("Send STOP ");

	
	#100000 APB_WRITE(2,8'b11110000);
	#200000 APB_WRITE(2,8'b11010000);
	$display ("Send STOP ");
*/


//	$display ("I2C Master Tx Rx Test : %t");

//	#200 APB_WRITE(,);
	end
 I2CTop I2C
(
	.PCLK		(PCLK	),
	.PRESETn	(PRESETn),
	.PENABLE	(PENABLE),
	.PSEL    	(PSEL	),
	.PWRITE  	(PWRITE	),
	.PADDR   	(PADDR	),
	.PWDATA  	(PWDATA	),
	.PRDATA  	(PRDATA	),
	
	.int		(int	), // Interrupt Signal
	.SCL_i		(SCL_i	),
	.SCL_o		(SCL_o	),
	.nSCL_En	(nSCL_En),
	.SDA_i		(SDA_i	),
	.SDA_o		(SDA_o	),
	.nSDA_En 	(nSDA_En)
);

i2c_slave_model i2c_slave_model
(
	.scl (SCL),
	.sda (SDA)
);


always @(posedge int ) begin
	$display (" Interrupt Occur");
end



tri SDA;
tri SCL;

pullup (SDA);
pullup (SCL);

assign SCL = (nSCL_En) ? 1'bz : SCL_o ; 
assign SDA = (nSDA_En) ? 1'bz : SDA_o ;
assign SCL_i = SCL;
assign SDA_i = SDA;


parameter DLY = 1;
task APB_READ;
input	[31:0]	Addr;
begin
		@(posedge PCLK);
  		#DLY 	PADDR   = Addr[7:0];
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

task APB_WRITE;
input	[31:0]	Addr;
input	[31:0]	Wdata;
begin
		@(posedge PCLK);
		#DLY 	PADDR   = Addr[7:0];
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
