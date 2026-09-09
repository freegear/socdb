`timescale 1ns/10ps


module mmc_IntMsk (

	// interrupt source
	//
	NoBusy,
	RspCrc,
	CmdSent,
	CmdTout,
	RspEnd,
	FFfail,
	CrcSta,
	DatCrc,
	DatTout,
	DatFin,
	BusyFin,
	BusyFin2,
	TFHalf,
	TFEmpt,
	RFFull,
	RFHalf,
	
	IntMsk,

	MMC_INT
);

input		NoBusy;
input		RspCrc;
input		CmdSent;
input		CmdTout;
input		RspEnd;
input		FFfail;
input		CrcSta;
input		DatCrc;
input		DatTout;
input		DatFin;
input		BusyFin;
input		BusyFin2;
input		TFHalf;
input		TFEmpt;
input		RFFull;
input		RFHalf;
	
input	[15:0]	IntMsk;

output		MMC_INT;

assign MMC_INT = 	((IntMsk[15] & NoBusy)|
			(IntMsk[14] & RspCrc)|
			(IntMsk[13] & CmdSent)|
			(IntMsk[12] & CmdTout)|
			(IntMsk[11] & RspEnd)|
			(IntMsk[10] & FFfail)|
			(IntMsk[9] & CrcSta)|
			(IntMsk[8] & DatCrc)|
			(IntMsk[7] & DatTout)|
			(IntMsk[6] & DatFin)|
			(IntMsk[5] & BusyFin)|
			(IntMsk[4] & BusyFin2)|
			(IntMsk[3] & TFHalf)|
			(IntMsk[2] & TFEmpt)|
			(IntMsk[1] & RFFull)|
			(IntMsk[0] & RFHalf));

endmodule

