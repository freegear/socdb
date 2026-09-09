
module GpuReg(
				ACLK,
				ARESETn,
    			PSEL, 
    			PENABLE, 
    			PADDR, 
    			PWRITE, 
    			PWDATA, 
				PRDATA,
				
				IC, EC, FL, EM, RF,
				CQWrite, CQData,

				RE, LEN, ED,
				
				DnEnable, DnWrite, DnAddr, DnData, DnRData,
				GpuReset,
				
				EndInt, ErrInt

);

`include "GpuPara.v"

input			ACLK;
input			ARESETn;

input  [ 9:2] 	PADDR;
input         	PWRITE;
input         	PSEL;
input         	PENABLE;
input  [31:0] 	PWDATA;
output [31:0] 	PRDATA;

// Command Queue
input	[3:0]	IC, EC;
input		 	FL, EM, RF;
output	[31:0]	CQData;
output			CQWrite;

// Read DMA Command Buffer
input			RE;
input	[ 4:0]	LEN; 
input			ED;

// DownLoad Engine
output	[10:0]	DnAddr;
input	[31:0]	DnRData;
output	[31:0]	DnData;
output			DnWrite;
output			DnEnable;

output			GpuReset;

output			EndInt, ErrInt;
//------------------------------------------------------------------------------
wire rWrite   =  PWRITE;
wire rRead    = ~PWRITE;
wire rSelect  =  PSEL & ~PENABLE;

wire rCQCONSel = rSelect & (PADDR == CQCON[9:2]);
wire rCQSTSSel = rSelect & (PADDR == CQSTS[9:2]);  
wire rCQDATSel = rSelect & (PADDR == CQDAT[9:2]);  
wire rCBCONSel = rSelect & (PADDR == CBCON[9:2]);  
wire rQDCONSel = rSelect & (PADDR == QDCON[9:2]);  
wire rQDDATSel = rSelect & (PADDR == QDDAT[9:2]);  

wire rCQCONWr  = rCQCONSel	& rWrite;
wire rCQSTSWr  = rCQSTSSel	& rWrite; 
wire rCQDATWr  = rCQDATSel	& rWrite; 
wire rCBCONWr  = rCBCONSel	& rWrite;
wire rQDCONWr  = rQDCONSel	& rWrite;
wire rQDDATWr  = rQDDATSel	& rWrite;

wire rCQCONRd  = rCQCONSel	& rRead;
wire rCQSTSRd  = rCQSTSSel	& rRead; 
wire rCQDATRd  = rCQDATSel	& rRead; 
wire rCBCONRd  = rCBCONSel	& rRead;
wire rQDCONRd  = rQDCONSel	& rRead;
wire rQDDATRd  = rQDDATSel	& rRead;
//------------------------------------------------------------------------------
// Command Queue Control Register
// 1	Start Flag(SF)
// 1.1	Operation Start Command Flag
// 2	Interrupt Enable Flag
// 2.1	ECI : Enable Complete Interrupt
// 2.2	EEI : Enable Error Notice Interrupt
// 2.3	EDI : Enable Download End Interrupt
//-------------------------------------------------------------------------------
reg			SF;
reg			ECI;
reg			EEI;
reg			EDI;
reg	[31:0]	QDAT;
//-------------------------------------------------------------------------------
always @(negedge ARESETn or posedge ACLK)
	if (!ARESETn) begin
        SF  <= 0;
        ECI <= 0;
        EEI <= 0;
        EDI <= 0;
	end
	else if (rCQCONWr) begin
	    SF  <= PWDATA[0];
	    ECI <= PWDATA[5];
	    EEI <= PWDATA[4];
	    EDI <= PWDATA[3];
	end

always @(negedge ARESETn or posedge ACLK)
	if (!ARESETn) begin
        QDAT <= 0;
	end
	else if (rCQDATWr) begin
	    QDAT <= PWDATA;
	end

reg 	rCQDATWrD;
always @(negedge ARESETn or posedge ACLK)
	if (!ARESETn)	rCQDATWrD <= 0;
	else			rCQDATWrD <= rCQDATWr;

assign CQWrite 	= ~rCQDATWr & rCQDATWrD;
assign CQData	= QDAT;
//------------------------------------------------------------------------------
// Q Memory Download Control Register
// 1	DE : Download Enable -> GPU Hold -> Reset GPU
// 2	DL : Download 할 개수(word 단위, 2K Word)
// 3	DA : Current Download Address
// 
// Q Memory Download Data Register
// 1	DAT : Download Data
//------------------------------------------------------------------------------
reg	[10:0]	DL;
reg			DE;
reg	[31:0]	DAT;
//------------------------------------------------------------------------------
always @(negedge ARESETn or posedge ACLK)
	if (!ARESETn) begin
        DE  <= 0;
        DL  <= 0;
	end
	else if (rQDCONWr) begin
	    DE  <= PWDATA[0];
	    DL  <= PWDATA[12:1];
	end

always @(negedge ARESETn or posedge ACLK)
	if (!ARESETn) begin
        DAT <= 0;
	end
	else if (rQDDATWr) begin
	    DAT <= PWDATA;
	end
//------------------------------------------------------------------------------
// Q Memory Download Engine
reg 	rQDDATWrD;
always @(negedge ARESETn or posedge ACLK)
	if (!ARESETn)	rQDDATWrD <= 0;
	else			rQDDATWrD <= rQDDATWr;

reg 	rQDDATRdD;
always @(negedge ARESETn or posedge ACLK)
	if (!ARESETn)	rQDDATRdD <= 0;
	else			rQDDATRdD <= rQDDATRd;

assign DnWrite 	= ~rQDDATWr & rQDDATWrD;
assign DnData	= DAT;

wire   DnRead   = ~rQDDATRd & rQDDATRdD;

reg	[10:0] DnAddr;
always @(negedge ARESETn or posedge ACLK)
	if (!ARESETn)		DnAddr <= 0;
	else if (!DE)		DnAddr <= DL;
	else if (DnWrite | DnRead)	
						DnAddr <= DnAddr + 1;

wire DnEnd = (DnAddr == DL);

reg			GpuReset;
always @(negedge ARESETn or posedge ACLK)
	if (!ARESETn)		GpuReset <= 1;
	else if (DnEnd)		GpuReset <= 0;
	else if (DE)		GpuReset <= 1;
	else				GpuReset <= GpuReset;

assign DnEnable = DE;
//------------------------------------------------------------------------------
// Error Status & Interrupt
//------------------------------------------------------------------------------
wire	DEndInt = EDI & DnEnd;
assign	ErrInt  = EEI & |EC;
assign	EndInt  = (ECI & |IC) | DEndInt;
//------------------------------------------------------------------------------
// Command Queue Status Register
// 1	RF : Running flag
// 1.1	현재 operation 수행중임을 알림
// 2	EM : Command queue empty
// 3	FL : Command queue full
// 4	EC : Error Code
// 4.1	Error Kind
// 4.2	If 0, no error
// 5	IC : Interrupt Code
// 5.1	Interrupt Kind
// 5.2	If 0, no interrupt
//------------------------------------------------------------------------------
// 	Command Buffer Status Register
// 1	LEN : Read할 Command의 개수
// 2	ED : Read DMA 종료
// 3	RE : Read DMA Start
//------------------------------------------------------------------------------
// Read Data Mux.
reg [31:0] 	PRDATA;
always @(negedge ARESETn or posedge ACLK)
	if 	(!ARESETn)		  PRDATA <= 32'b0;
	else begin
		case(1'b1) // synopsys parallel_case
    	  	rCQCONRd	: PRDATA <= {26'b0, ECI, EEI, EDI, 2'b0, SF};
    	  	rCQSTSRd	: PRDATA <= {20'b0, IC, EC, 1'b0, FL, EM, RF};
    	  	rCQDATRd	: PRDATA <= QDAT;

			rCBCONRd	: PRDATA <= {28'b0, RE, ED, 3'b0, LEN};
			
			rQDCONRd	: PRDATA <= {6'b0, DnAddr, 4'b0, DL, DE};
			rQDDATRd	: PRDATA <= DnRData;

    	  	default  	: PRDATA <= 32'b0;
    	endcase
    end
//------------------------------------------------------------------------------

endmodule
