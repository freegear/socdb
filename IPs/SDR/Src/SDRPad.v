
module SDRPad(
				RESETB,
    			OSCIN,
            	
    			SD_CKE,
    			SD_CLK,
    			SD_CSB,
    			SD_RASB,
    			SD_CASB,
    			SD_WEB,
    			SD_BADDR,
    			SD_ADDR,
    			SD_DQ,
    			SD_DQM
);

input			RESETB;
input    		OSCIN;

// SDRAM
output    		SD_CKE;
output    		SD_CLK;
output    		SD_CSB;
output    		SD_RASB;
output    		SD_CASB;
output    		SD_WEB;
output [BAW:0]  SD_BADDR;
output [RAW:0]  SD_ADDR;
inout  [DW:0]	SD_DQ;
output [BW:0]	SD_DQM;
//-------------------------------------------------------------
wire FDClk;
//-------------------------------------------------------------
SDRTop SDRTop(
		.ACLK		(ACLK), 
		.nACLK		(~ACLK), 
		.ARESETB	(ARESETB),
		.PORESETB	(ARESETB),
		.FCLK		(FDClk),
		
		.SD_CSB		(SDcsb), 
		.SD_RASB	(SDrasb), 
		.SD_CASB	(SDcasb), 
		.SD_WEB		(SDweb), 
		.SD_CKE		(SDcke), 
		.SD_BADDR	(SDba), 
		.SD_ADDR	(SDadr),
		.SD_DQE		(SDdate),
		.SD_DQI		(SDdati), 
		.SD_DQO		(SDdato),
		.SD_DQM		(SDdqm)
);
//-------------------------------------------------------------
/*
input  PAD PDIDGZ (PAD, C);
input  PAD PDUDGZ (PAD, C); // Pull Up(44K/66K/110K)
output PAD PDO04CDG (I, PAD);
tri-output PAD PDT04DGZ (I, OEN, PAD);
inout PAD PDB04DGZ (I, OEN, PAD, C);
inout PAD PDU04DGZ (I, OEN, PAD, C);	// input pullup
inout PAD PDB08SDGZ (I, OEN, PAD, C); 	// schmit trigger input
*/
//-------------------------------------------------------------
PDIDGZ pRESETB	(.PAD(RESETB), 	.C(PORESETB));
PDIDGZ pOSCIN	(.PAD(OSCIN), 	.C(OSCCLK));

PDO04CDG pSDCKE(.I(), 	.PAD(SD_CKE));
PDB04DGZ pSDCLK(.I(SDClk), 	.OEN(1'b0), 	.PAD(SD_CLK), 	.C(FDClk));
//-------------------------------------------------------------

endmodule