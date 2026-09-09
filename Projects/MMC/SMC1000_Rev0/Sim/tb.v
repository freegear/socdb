// --=========================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from SANGHWA MICRO Technology
// ALL RIGHTS RESERVED SANGHWA MICRO Technology      
// -----------------------------------------------------------------------------
// Version and Release information:
// 
// File Name           : tb.v
// File Revision       : 1.0
// ----------------------------------------------------------------------------
// Purpose            : Test Benc for TestPlatform
// --========================================================================--

`timescale 1ns/1ps
module tb;

`define PERIOD 10 	// 100 MHz
`define PHASETIME (`PERIOD / 2)
parameter DLY=1;

reg   RESETn;
reg   Clock;

initial Clock = 0;
always #`PHASETIME Clock = ~Clock;
initial
begin
	RESETn = 1'b0;

	repeat(100) @(posedge Clock);
	#(DLY*3) RESETn = 1'b1;
end

wire  [19:0]		EXT_ADDR ;
wire  [15:0]			EXT_DATA ;
wire 				EXT_CSb  ;
wire  				EXT_OEb  ;

wire	[15:0]	NFDATA0;
wire	[15:0]	NFDATA1;

wire			RnB0;
wire			RnB1;
wire			RnB2;
wire			RnB3;

pullup(RnB0);
pullup(RnB1);
pullup(RnB2);
pullup(RnB3);


SMC1000FPGATop Top
(
	// sd signal
	.SD_CLK		(),
	.SD_DATA	(),
	.SD_CMD		(),

	// SD External Setting PIN
	.SEL_MMC	(),

	// 8051 debug interface
	.M_CLK		(Clock),	
	.RESETn		(RESETn),


	// External ROM Interface
	.EXT_ADDR	(EXT_ADDR	),
	.EXT_DATA	(EXT_DATA	),
	.EXT_CSb	(EXT_CSb	),
	.EXT_OEb	(EXT_OEb	),	


	// 8051 UART signal
	.UART_RXD	(1'b1),
	.UART_TXD	(),

	//	NAND Flash Interface
	.NFDATA0	(NFDATA0),
	.NFDATA1	(NFDATA1),
	.CLE0		(CLE0),
	.CLE1		(CLE1),
	.ALE0		(ALE0),
	.ALE1		(ALE1),
	.nNFCE0		(nNFCE0	),
	.nNFCE1		(nNFCE1	),
	.nNFCE2		(nNFCE2	),
	.nNFCE3		(nNFCE3	),
	.nNFRE0		(nNFRE0	),
	.nNFRE1		(nNFRE1	),
	.nNFWE0		(nNFWE0	),
	.nNFWE1		(nNFWE1	),
	.RnB0		(RnB0	),
	.RnB1		(RnB1	),
	.RnB2		(RnB2	),
	.RnB3		(RnB3	),

	.WP0		(),
	.WP1		(),
	.PRE0		(),
	.PRE1		(),
	// 8051 Gpio FND
	.GPIO		(),
	.FNDControlOut(),
	.FNDCommonOut ()
);

/*
prom8bit prom(
	.addr		({1'b0,EXT_ADDR}	), 
	.romdata	(EXT_DATA	), 
	.oeb		(EXT_CSb	), 
	.csb		(EXT_OEb	)
);
*/

// NAND FLASH Model

     nand_model_0 uut0(
           .Io  (NFDATA0[7:0] ),        
           .Cle (CLE0      ),
           .Ale (ALE0       ),
           .Ce_n(nNFCE0     ),
           .We_n(nNFWE0      ),
           .Re_n(nNFRE0      ),
           .Wp_n(1'b1       ),
           .Pre (1'b1       ),
           .Rb_n(RnB0       ));

        nand_model_0 uut1(
           .Io  (NFDATA0[7:0]  ),        
           .Cle (CLE0        ),
           .Ale (ALE0        ),
           .Ce_n(nNFCE1     ),
           .We_n(nNFWE0      ),
           .Re_n(nNFRE0      ),
           .Wp_n(1'b1       ),
           .Pre (1'b1       ),
           .Rb_n(RnB1       ));

        nand_model_0 uut2(
           .Io  (NFDATA1[7:0]),        
           .Cle (CLE1       ),
           .Ale (ALE1       ),
           .Ce_n(nNFCE4     ),
           .We_n(nNFWE1      ),
           .Re_n(nNFRE1      ),
           .Wp_n(1'b1       ),
           .Pre (1'b1       ),
           .Rb_n(RnB2       ));

        nand_model_0 uut3(
           .Io  (NFDATA1[7:0]),        
           .Cle (CLE1       ),
           .Ale (ALE1       ),
           .Ce_n(nNFCE5     ),
           .We_n(nNFWE1      ),
           .Re_n(nNFRE1      ),
           .Wp_n(1'b1       ),
           .Pre (1'b1       ),
           .Rb_n(RnB3       ));



prom16bit prom(
	.addr		(EXT_ADDR[19:0]), 
	.romdata	(EXT_DATA	), 
	.oeb		(EXT_CSb	), 
	.csb		(EXT_OEb	)
);



/*
always @(posedge Clock)
	if(GpioDat[15:8] === 8'hde)
	begin
		$display("Simulation Ended with error code(%h)", GpioDat[7:0]);
		$finish;
	end
*/
endmodule
