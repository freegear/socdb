module PMTop (
   				UExtClk,
   				ExtClk,
   				ExtResetb,
   				TestMode,
   				EINT,
   				EIntLvl,
   				EIntPol,
   				EIntMsk,

				LCDPDIV,
				VideoSyncEn,
				VideoBPAck,
				VidClk,

   				CpuClkOut,
   				SysClkOut,
   				PeriClkOut, PeriClk2xOut,
				GDMAClkOut,
				DMAClkOut,
				DMClkOut,
				VIFClkOut,
				VidClkOut,
				NANDClkOut,
				DDRClk1xOut, DDRClk2xOut, nDDRClk1xOut, nDDRClk2xOut,
				SEIPClkOut,	
   				UsbClkOut,
   				LcdClkOut,
   
   				CfgIn,
   				CfgEnb,
   				PocResetb,

   				ARESETn,
   				WDOGRES,
   				WDOGRESn,
   				
// Register Interface
    			PSEL, 
    			PENABLE, 
    			PADDR, 
    			PWRITE, 
    			PWDATA, 
				PRDATA
);

input         	UExtClk;		//External USB Clock
input         	ExtClk;			//External Clock
input			ExtResetb;		//External Reset#
input         	TestMode;
input 	[7:0]   EINT;     		//External Interrupt
input  	[7:0]  	EIntLvl;
input  	[7:0]  	EIntPol;
input  	[7:0]  	EIntMsk;

input	[2:0]	LCDPDIV;
input			VideoSyncEn;	// Video Sync Enable From DM
input			VideoBPAck;		// External Bypass Enable From VIF
input			VidClk;			// External Video Clock

output        	CpuClkOut;     	//ARM Clock, MCLK
output        	SysClkOut;     	//System Clock, ACLK
output        	PeriClkOut, PeriClk2xOut;    	//Peri. Clock, PCLK
output			GDMAClkOut;
output			DMAClkOut;
output			DMClkOut;
output			VidClkOut;	// Video Clock
output			VIFClkOut;
output			NANDClkOut;
output			DDRClk1xOut, DDRClk2xOut, nDDRClk1xOut, nDDRClk2xOut;
output			SEIPClkOut;	
output			UsbClkOut;
output			LcdClkOut;	// Video/LCD Clock

input	[0:0]	CfgIn;
output			CfgEnb;
output			PocResetb;

output			ARESETn;
input			WDOGRES;
output			WDOGRESn;

input  [ 7:2] 	PADDR;
input         	PWRITE;
input         	PSEL;
input         	PENABLE;
input  [31:0] 	PWDATA;
output [31:0] 	PRDATA;

wire			tPMSlow;
wire 			MPllPD;
wire  [7:0] 	MPllFR;
wire  [4:0] 	MPllRR;
wire  [1:0] 	MPllODR;

PMPLL PMPLL(
   				.ExtClk			(ExtClk),
   				.ExtResetb		(ExtResetb),
   				.TestMode		(TestMode),
                            	
				.tPMSlow		(tPMSlow),
				.MPllPD			(MPllPD	),
				.MPllFR			(MPllFR	),
				.MPllODR		(MPllODR),
				.MPllRR			(MPllRR	),
				            	
				.MPllClk		(MPllClk)
);

PMCtl PMCtl(
				.UExtClk		(UExtClk), 
				.ExtClk			(ExtClk), 
				.ExtResetb		(ExtResetb),
				.TestMode		(TestMode),
				.ARESETB		(ARESETn),
   				.EINT			(EINT),
   				.EIntLvl		(EIntLvl),
   				.EIntPol		(EIntPol),
   				.EIntMsk		(EIntMsk),
   				.LCDPDIV		(LCDPDIV),
   				.VideoSyncEn	(VideoSyncEn),
   				.VideoBPAck		(VideoBPAck),
   				.VidClk			(VidClk),
        		            	
				.CpuClkOut		(CpuClkOut),
				.SysClkOut		(SysClkOut),
				.PeriClkOut		(PeriClkOut),
				.PeriClk2xOut	(PeriClk2xOut),
				.GDMAClkOut		(GDMAClkOut),
				.DMAClkOut		(DMAClkOut),
				.DMClkOut		(DMClkOut),
				.VIFClkOut		(VIFClkOut),
				.VidClkOut		(VidClkOut),
				.NANDClkOut		(NANDClkOut),
				.DDRClk1xOut	(DDRClk1xOut), 
				.DDRClk2xOut	(DDRClk2xOut), 
				.nDDRClk1xOut	(nDDRClk1xOut), 
				.nDDRClk2xOut	(nDDRClk2xOut),
				.SEIPClkOut		(SEIPClkOut),	
				.UsbClkOut		(UsbClkOut),
				.LcdClkOut		(LcdClkOut),
				
				.CfgIn			(CfgIn),
				.CfgEnb			(CfgEnb),
				.PocResetb		(PocResetb),
                            	
				.tPMSlow		(tPMSlow),
				.MPllPD			(MPllPD	),
				.MPllFR			(MPllFR	),
				.MPllODR		(MPllODR),
				.MPllRR			(MPllRR	),
				.MPllClk		(MPllClk),
				       			
				.PCLK			(PeriClkOut), 
				.PRESETB		(ARESETn),
				.PENABLE 		(PENABLE), 
				.PSEL    		(PSEL), 
				.PWRITE  		(PWRITE), 
				.PADDR   		(PADDR), 
				.PWDATA  		(PWDATA),
				.PRDATA  		(PRDATA)
);

RstCtl RstCtl(
  				.ACLK	 		(SysClkOut),
  				.TestMode		(TestMode), 
				.PocResetb		(PocResetb),
  				.nPOReset		(ExtResetb), 
  				.WDOGRES 		(WDOGRES), 
  				.ARESETn 		(ARESETn), 
  				.WDOGRESn		(WDOGRESn)
);

endmodule
