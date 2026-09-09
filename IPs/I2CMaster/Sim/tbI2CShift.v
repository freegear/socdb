module tbI2CShift;
reg			PCLK;
reg			PRESETn;

reg			AckEn;
reg	[1:0]	OpMode;

reg			Start;
reg			Stop;

reg			DataTrans;

reg			StartDet;
reg			StopDet;

reg			ClkEn;

reg	[7:0]	IDSRo;

wire[7:0]	ReadData;
wire		AckValue;
reg			ReadUpd;
reg			WriteUpd;

wire		SDAErrorDet;

wire		nSDA_En;



initial
begin
	PCLK 		= 	0;
	PRESETn 	= 	0;
	AckEn 		=	0;
	OpMode 		= 	0;
	
	Start 		=	0;
	Stop 		=	0;
	
	DataTrans 	= 	0;
	
	StartDet 	= 	0;
	StopDet 	=	0;

	ClkEn		=	0;

	IDSRo 		=	0;

	ReadUpd 	=	0;
	WriteUpd	=	0;	
end

always #5 PCLK = ~PCLK;

initial
begin
	#100
	PRESETn = 1;
	$display ("Shift Write test");
	OpMode = 2'b01;
	#10
	Start =1;
	IDSRo = 8'b11100111;
	#10
	StartDet = 1;
	#10
	StartDet =0;
	Start=0;
	ClkEn = 1;
	#50
	ReadUpd = 1;
	WriteUpd =1;
	#10
	ReadUpd = 0;
	WriteUpd =0;
	#50
	ReadUpd = 1;
	WriteUpd =1;
	#10
	ReadUpd = 0;
	WriteUpd =0;
	#50
	ReadUpd = 1;
	WriteUpd =1;
	#10
	ReadUpd = 0;
	WriteUpd =0;
	#50
	ReadUpd = 1;
	WriteUpd =1;
	#10
	ReadUpd = 0;
	WriteUpd =0;
	#50
	ReadUpd = 1;
	WriteUpd =1;
	#10
	ReadUpd = 0;
	WriteUpd =0;
	#50
	ReadUpd = 1;
	WriteUpd =1;
	#10
	ReadUpd = 0;
	WriteUpd =0;
	#50
	ReadUpd = 1;
	WriteUpd =1;
	#10
	ReadUpd = 0;
	WriteUpd =0;
	#50
	ReadUpd = 1;
	WriteUpd =1;
	#10
	ReadUpd = 0;
	WriteUpd =0;
	#50
	ReadUpd = 1;
	WriteUpd =1;
	#10
	ReadUpd = 0;
	WriteUpd =0;
	#50
	ReadUpd = 1;
	WriteUpd =1;
	#10
	ReadUpd = 0;
	WriteUpd =0;
end

assign SDA = nSDA_En;


I2CShift I2CShift(
	.PCLK		(PCLK),
	.PRESETn	(PRESETn),
	
	.AckEn		(AckEn), 	// Acknowledge Assertion
	.OpMode		(OpMode),	// 00: Slave Rx 01: Slave Tx 10: Master Rx 11: Master Tx
	.Start		(Start),	// Start Signal
	.Stop		(Stop),	// Stop Signal
	
	.DataTrans	(DataTrans),	// Data Pending Clear and Next Data Trans 
	
	//Detect Signal from Detect module
	
	.StartDet	(StartDet),
	.StopDet	(StopDet),
	
	.ClkEn		(ClkEn), 	// Clock Working Sign (Started)
	
	.IDSRo		(IDSRo),	// Send Data
	.ReadData	(ReadData),
	.AckValue	(AckValue),
	.ReadUpd	(ReadUpd),	// from clock module
	.WriteUpd	(WriteUpd),	// from clock module
	
	.SDAErrorDet(),	// I2C Bus Error Detect
	// Control Signal
	.SDA_IN		(SDA),
	.nSDA_En	(nSDA_En)
);

endmodule
