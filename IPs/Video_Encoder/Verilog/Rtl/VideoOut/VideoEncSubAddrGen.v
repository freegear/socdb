// =======================================================================
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from SANGHWA MICRO Technology
// ALL RIGHTS RESERVED SANGHWA MICRO Technology      
// -----------------------------------------------------------------------
// Version and Release information:
// 
// File Name           : VideoEncSubAddrGen.v
// File Revision       : 0.1
// -----------------------------------------------------------------------
// Purpose            : This module is generating the sub-address in video
//                      Encoder
// =======================================================================
//Hue level function added  2007/3/14

`timescale 1ns/10ps
`define ROM_MODEL_SYN       //for Synthesis CT2000
//`define ROM_MODEL_FPGA    //for FPGA
//`define ROM_MODEL         //for Simulation CT500

module VideoEncSubAddrGen(
    CLK,
    RESETn,

    //Input
    SUB_REQ,
    SUB_PHASE,
    OUT_MODE,
    EN_RESET_SCH,
    HUE_LEV,
    HALF_HSYNC,

    ACT_DISPLAY_SYN,
    BURST_ENABLE,
    RESET_ADDR,
    BURST_ID,
    
    //Output
    COS,
    SIN
);

parameter PHASE_180 = 32'h80000000;
parameter PHASE_0   = 32'h00000000;
parameter PHASE_135 = 32'h60000000;
parameter PHASE_225 = 32'hA0000000;  
parameter PHASE_1   = 32'h00B60B60;  
parameter PHASE0_175= 32'h1FFFFF;

//Output format define///////
parameter NTSCM = 3'b000;
parameter NTSCJ = 3'b001;
parameter NTSC4 = 3'b010;
parameter PALM  = 3'b011;
parameter PAL   = 3'b100;
parameter PALNc = 3'b101;
parameter PALN  = 3'b110;
////////////////////////////

input CLK;
input RESETn;

input [31:0] SUB_REQ;
input [15:0] SUB_PHASE;

input [2:0] OUT_MODE;
input EN_RESET_SCH;
input [7:0] HUE_LEV;

input ACT_DISPLAY_SYN;
input BURST_ENABLE;
input RESET_ADDR;
input BURST_ID;
input HALF_HSYNC;

output [10:0] SIN;
output [10:0] COS;

// =======================================================================
// Wire & Reg assign 
// -----------------------------------------------------------------------

wire [31:0] ADDR;
wire [10:0] ShiftADDR;
reg  [2:0]  ShiftADDR_0d/* synthesis syn_preserve =1 */;
wire [31:0] PhaseAdjAddr;
wire [31:0] StepAddr = SUB_REQ;
wire [7:0]  ReDefAddr;

reg  [31:0] rADDR;
reg  [31:0] rADDRB;
wire [31:0] adjADDR;

//'07.1.18
reg  [10:0] rSIN;
reg  [10:0] rCOS;
wire [8:0] SINTableOut;
wire [8:0] COSTableOut;
wire [10:0] SINinput;
wire [10:0] COSinput;

wire EN_TABLE = ~(BURST_ENABLE | ACT_DISPLAY_SYN);

wire NTSC_PAL = ((OUT_MODE == NTSCM) ||
                 (OUT_MODE == NTSCJ) ||
                 (OUT_MODE == NTSC4)) ? 1'b0 : 1'b1; // NTSC_PAL = 0 --> NTSC mode
                                                     //          = 1 --> PAL mode

reg EN_TABLE_d;

always @(posedge CLK or negedge RESETn) begin
    if(!RESETn) begin
        EN_TABLE_d <= 1'b0;
    end
    else begin
        EN_TABLE_d <= EN_TABLE;
    end
end

//wire RESET_ADDR_FILED = RESET_ADDR;
wire [31:0] HUE_ADDR;

reg  FirstFlag;
reg  RESET_ADDR_FIELD;

always @(posedge CLK or negedge RESETn) begin

    if(!RESETn) begin
        FirstFlag        <= 1'd0;
        RESET_ADDR_FIELD <= 1'b0;
    end
    else if(!FirstFlag) begin
        if(RESET_ADDR) begin
            RESET_ADDR_FIELD <= 1'b1;
            FirstFlag <= 1'b1;
        end
        else if(HALF_HSYNC) begin
            RESET_ADDR_FIELD <= 1'b0;
        end
    end
    else if(FirstFlag & EN_RESET_SCH) begin
        if(RESET_ADDR)      RESET_ADDR_FIELD <= 1'b1;
        else if(HALF_HSYNC) RESET_ADDR_FIELD <= 1'b0;
    end
    else if(HALF_HSYNC) begin
        RESET_ADDR_FIELD <= 1'b0;
    end

end

// =======================================================================
// Address Generation
// -----------------------------------------------------------------------

assign PhaseAdjAddr = {SUB_PHASE, 16'd0}; 
assign ADDR = rADDR + StepAddr + PhaseAdjAddr;
assign HUE_ADDR  = {HUE_LEV, 24'd0};
assign adjADDR   = rADDR + rADDRB;
assign ShiftADDR = adjADDR[31:21]; 
assign ReDefAddr = addrdef_gen(ShiftADDR);

always @(posedge CLK or negedge RESETn) begin
    if(!RESETn) begin
        ShiftADDR_0d <= 0;
    end
    else begin
        ShiftADDR_0d <= ShiftADDR[10:8];
    end
end

always @(posedge CLK or negedge RESETn) begin
    if(!RESETn) begin
        rADDR <= 32'd0;
    end
    else begin
        //if(RESET_ADDR_FILED && EN_RESET_SCH) begin
        if(RESET_ADDR_FIELD | !FirstFlag) begin
            rADDR <= 32'd0;
        end
        else begin
            rADDR <= ADDR;
        end
    end
end

always @(BURST_ENABLE or NTSC_PAL or rADDR or BURST_ID or HUE_ADDR) begin

    case({NTSC_PAL, BURST_ENABLE, BURST_ID})// synopsys parallel_case

        3'b111: begin /* PAL mode ID = 1 */
                rADDRB = PHASE_135;         //adjADDR = rADDR + PHASE_135;
               end
        3'b110: begin /* PAL mode ID = 0 */
                rADDRB = PHASE_225;         //adjADDR = rADDR + PHASE_225;
               end

        3'b101: begin /* PAL mode ID = 1 */
                rADDRB = HUE_ADDR;          //adjADDR = rADDR + HUE_ADDR;
               end
        3'b100: begin /* PAL mode ID = 0 */
                rADDRB = (~HUE_ADDR+ 32'd1);//adjADDR = rADDR - HUE_ADDR;
               end

        3'b011: begin /* NTSC mode ID = 1 */
                rADDRB = PHASE_180;         //adjADDR = rADDR + PHASE_180;
               end
        3'b010: begin /* NTSC mode ID = 0 */
                rADDRB = PHASE_180;         //adjADDR = rADDR + PHASE_180;
               end
        default: rADDRB = HUE_ADDR;         //adjADDR = rADDR + HUE_ADDR;

    endcase
end


// =======================================================================
// COS / SIN  Generation
// -----------------------------------------------------------------------

reg  [10:0] SIN;
reg  [10:0] COS;
always @(posedge CLK or negedge RESETn) begin
	if(!RESETn) begin
		SIN <= 0;
		COS <= 0;
	end	
	else begin
		SIN <= rSIN;
		COS <= rCOS;
	end
end

assign SINinput = (SINTableOut == 9'd0) ? 11'd512 : {2'b00, SINTableOut};
assign COSinput = (COSTableOut == 9'd0) ? 11'd512 : {2'b00, COSTableOut};

//always @(ShiftADDR_0d or SINinput or COSinput or EN_TABLE) begin
always @(ShiftADDR_0d or SINinput or COSinput or EN_TABLE_d) begin

    case({EN_TABLE_d, ShiftADDR_0d[2:0]}) // synopsys parallel_case 
        //------------------
        //MSB 1bit Sign bit
        //------------------
        4'd0:  begin  
                rSIN = SINinput;
                rCOS = COSinput;
            end
        4'd1:  begin  
                rSIN = COSinput;
                rCOS = SINinput;
            end
        4'd2:  begin  
                rSIN = COSinput;
                rCOS = {1'b1, SINinput[9:0]};//(~SINinput+11'd1);
            end
        4'd3:  begin  
                rSIN = SINinput;
                rCOS = {1'b1, COSinput[9:0]};//(~COSinput+11'd1);
            end
        4'd4:  begin  
                rSIN = {1'b1, SINinput[9:0]};//(~SINinput+11'd1);
                rCOS = {1'b1, COSinput[9:0]};//(~COSinput+11'd1);
            end
        4'd5:  begin  
                rSIN = {1'b1, COSinput[9:0]};//(~COSinput+11'd1);
                rCOS = {1'b1, SINinput[9:0]};//(~SINinput+11'd1);
            end
        4'd6:  begin  
                rSIN = {1'b1, COSinput[9:0]};//(~COSinput+11'd1);
                rCOS = SINinput;
            end
        4'd7:  begin  
                rSIN = {1'b1, SINinput[9:0]};//(~SINinput+11'd1);
                rCOS = COSinput;
            end
        default: begin
                rSIN = 11'd0;
                rCOS = 11'd0;
            end
    endcase
end

// =======================================================================
// Rom Table
// -----------------------------------------------------------------------

`ifdef ROM_MODEL_SYN
SIN_RODSH256x9  SineTable(
   .Q(SINTableOut),
   .CLK(CLK),
   .CEN(EN_TABLE),
   .A(ReDefAddr)
);

COS_RODSH256x9 CosineTable(
   .Q(COSTableOut),
   .CLK(CLK),
   .CEN(EN_TABLE),
   .A(ReDefAddr)
);
`endif


`ifdef ROM_MODEL_FPGA
COS_ROM_FPGA CosineTable(
   .Q(COSTableOut),
   .CLK(CLK),
   .CEN(EN_TABLE),
   .A(ReDefAddr)
);

SIN_ROM_FPGA SineTable(
   .Q(SINTableOut),
   .CLK(CLK),
   .CEN(EN_TABLE),
   .A(ReDefAddr)
);
`endif


`ifdef ROM_MODEL
/* Rom model */
CosineRODSH256x9 CosineTable(
   .Q(COSTableOut),
   .CLK(CLK),
   .CEN(EN_TABLE),
   .A(ReDefAddr)
);

SineRODSH256x9 SineTable(
   .Q(SINTableOut),
   .CLK(CLK),
   .CEN(EN_TABLE),
   .A(ReDefAddr)
);
`endif

// =======================================================================
// Address Function
// -----------------------------------------------------------------------

function  [7:0] addrdef_gen;
    input [10:0] addr;
    begin
        if(addr[8]) begin
            case(addr) // synopsys parallel_case 
                11'h100: addrdef_gen = 8'hff; // 1
                11'h300: addrdef_gen = 8'hff; // 3
                11'h500: addrdef_gen = 8'hff; // 5
                11'h700: addrdef_gen = 8'hff; // 7
                default: begin
                    addrdef_gen = ~addr[7:0];
                end
            endcase
        end
        else begin
                    addrdef_gen = addr[7:0];
        end
    end
endfunction

// -----------------------------------------------------------------------
endmodule
