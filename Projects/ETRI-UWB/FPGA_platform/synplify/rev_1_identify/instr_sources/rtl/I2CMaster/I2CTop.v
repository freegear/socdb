// ==============================================================================
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from SANGHWA MICRO Technology
// ALL RIGHTS RESERVED SANGHWA MICRO Technology      
// ------------------------------------------------------------------------------
// Version and Release information:
// 
// File Name           : I2CTop.v
// File Revision       : 1.1
// Revision History	: ADD Soft reset and Prescaler Bit 
//  -----------------------------------------------------------------------------
//  Purpose            : I2C Top file
//  =============================================================================
module I2CTop(
	PCLK	,
	PRESETn	,
	PENABLE	,
	PSEL    ,
	PWRITE  ,
	PADDR   ,
	PWDATA  ,
	PRDATA  ,

	int	, // Interrupt Signal
	SCL_i	,
	SCL_o	,
	nSCL_En	,
	SDA_i	,
	SDA_o	,
	nSDA_En 

);

//APB
	input          	PCLK   	;
	input          	PRESETn	;  
	input          	PENABLE	; 
	input          	PSEL   	; 
	input          	PWRITE 	; 
	input  [1:0]  	PADDR  	; 
	input  [31:0]  	PWDATA 	; 
	output [31:0]  	PRDATA 	;

// Interrupt Src
	output	       	int  	;
// I2C Bus
	input			SCL_i	;
	output			SCL_o	;
	output			nSCL_En	;
	input			SDA_i	;
	output			SDA_o	;
	output			nSDA_En	;



	
wire	[7:0]	IDSRo;

wire	[11:0]	TxClkVal;
wire	[7:0]	ReadData;

I2CRegIF	I2CReg
(
	//APB
	.PCLK		(PCLK		), 
	.PRESETn	(PRESETn	), 
	.PENABLE	(PENABLE	), 
	.PSEL		(PSEL		), 
	.PWRITE		(PWRITE		), 
	.PADDR		(PADDR		),	 
	.PWDATA		(PWDATA		),
	.PRDATA		(PRDATA		),
	
	//input	
	.BusyDet	(BusyDet	),  // Bus Busy Detected
	.StartDet	(StartDet	),
	.StopDet	(StopDet	),
	.ArbitLostDet(ArbitLostDet),

	.AckValue	(AckValue	),

	.TxCompInt	(TxCompInt	),
	
	//Control Signal
	.AckEn		(AckEn		),
	.IntPendFlag(IntPendFlag),
	.IntPendClr (IntPendClr ),
	.TxClkVal	(TxClkVal	),


	.OpMode		(OpMode		),
	.Start		(Start		),
	.Stop		(Stop		),
	.StartClr	(StartDet	),
	.StopClr	(StopDet	),
	
	.IDSRo		(IDSRo		),
	.ReadData	(ReadData	),
	.SW_RST		(SW_RST		),
	.int		(int		)

);

I2CLoClk	FsModeClock 
	(
	.PCLK		(PCLK		),
	.PRESETn	(PRESETn	),
	.SW_RST		(SW_RST		),
	.Start		(Start		),
	.Stop		(Stop		),

	.IntPendFlag(IntPendFlag),
	.DataTrans	(IntPendClr	),	

	.StartDet	(StartDet	),
	.StopDet	(StopDet	),
	.BusErrorDet	(BusErrorDet),
	.ArbitLostDet	(ArbitLostDet),
	.ClkEn		(ClkEn		),
	.TxPre		(TxClkVal	), // Prescaler value
	.WaitCnt	(WaitCnt	), // Wait Control for Clock Synchronization
	.CntRst		(CntRst		), // Counter Reset for Clock Synchromization
	.SCLWait	(SCLWait	),
	.CntIsZero	(CntIsZero	),
	.RepeatStart(RepeatStart),
	.SendStop	(SendStop	),
	.out_clk	(Fs_Clk		)
	);


assign nSCL_En = Fs_Clk;

I2CDetect	I2CDetect
(
	.PCLK			(PCLK		 ),
	.PRESETn		(PRESETn	 ),


	.ArbitCheck		(ArbitCheck	),
	.SCL_i			(SCL_i		),
	.SDA_i			(SDA_i		),

	.SCL_o			(nSCL_En	),
	.SDA_o			(nSDA_En	),

	.DSCL			(DSCL_in	),
	.DDSCL			(DDSCL_in	),
	.DSCL_o			(DSCL_o		),

	.ReadData		(ReadData	),

	.ClkEn			(ClkEn		 ), // Clock Trasition Detect
	.BusyDet		(BusyDet	 ),
	.StartDet		(StartDet	 ),
	.StopDet		(StopDet	 ),
	.ArbitLostDet		(ArbitLostDet)

);

I2CClkCtrl	I2CClkCtrl // SCL Line Control
(
	.PCLK			(PCLK		),
	.PRESETn		(PRESETn	),
	.StartDet 		(StartDet	),
	.StopDet		(StopDet	),
	.ArbitLostDet	(ArbitLostDet	),
	.DSCL_in		(DSCL_in	),
	.DDSCL_in		(DDSCL_in	),
	.DSCL_o			(DSCL_o		),
	.ReadUpd		(ReadUpd	),
	.WriteUpd		(WriteUpd	),
	.WaitCnt		(WaitCnt	),
	.CntRst			(CntRst		),
	.ClkEn			(ClkEn		)
);

I2CShift	I2CShift // SDA Line Control
(
	.PCLK			(PCLK		),
	.PRESETn		(PRESETn	),

	.SW_RST			(SW_RST		),
	.AckEn			(AckEn		),
	.OpMode			(OpMode		),
	.Start			(Start		),
	.Stop			(Stop		),

	.IntPendFlag	(IntPendFlag),
	.DataTrans		(IntPendClr	),

	.StartDet		(StartDet	),
	.StopDet		(StopDet	),
	.ArbitLostDet	(ArbitLostDet),
	
	.ClkEn			(ClkEn		),
	
	.IDSRo			(IDSRo		),
	.ReadData		(ReadData	),
	.AckValue		(AckValue	),
	.ReadUpd		(ReadUpd	),
	.WriteUpd		(WriteUpd	),

	.SDAErrorDet	(SDAErrorDet),
	.SCLWait		(SCLWait	),
	.CntIsZero		(CntIsZero	),
	.TxCompInt		(TxCompInt	),
	.RepeatStart	(RepeatStart),
	.SendStop		(SendStop	),

	.ArbitCheck		(ArbitCheck	),
	.SDA_IN			(SDA_i		),	//sychronized SDA input
	// Control Signal
	.nSDA_En		(nSDA_En	)
);

// output Statge
assign SCL_o = 1'b0;
assign SDA_o = 1'b0;

endmodule
