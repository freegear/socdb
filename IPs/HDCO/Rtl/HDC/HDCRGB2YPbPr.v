// =======================================================================
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from RichenTech
// ALL RIGHTS RESERVED RichenTech
// -----------------------------------------------------------------------
// Version and Release information:
// 
// File Name           : HDCRGB2YPbPr.v
// File Revision       : 0.1
// -----------------------------------------------------------------------
// Purpose            : This module is converting RGB to YPbPr in video
//                      Encoder
// =======================================================================

`timescale 1ns/10ps

module HDCRGB2YPbPr
(
    CLK,       // 27Mhz clock input
    RESETn,

    //Input
    EN_INTERNAL_PATTERN,
    HD_MODE,
    BLANKn,

    YRpara,
    YGpara,
    YBpara,

    PbRpara,
    PbGpara,
    PbBpara,

    PrRpara,
    PrGpara,
    PrBpara,

    Rin,
    Gin,
    Bin,

    Rgen,
    Ggen,
    Bgen,

    //Output
    Y,
    Pb,
    Pr
);

input CLK;
input RESETn;

input [1:0] HD_MODE;
input       BLANKn;
input [7:0] Rin;
input [7:0] Gin;
input [7:0] Bin;

input [7:0] Rgen;
input [7:0] Ggen;
input [7:0] Bgen;

input EN_INTERNAL_PATTERN;

input [9:0] YRpara; 
input [9:0] YGpara; 
input [9:0] YBpara; 
                   
input [9:0] PbRpara; 
input [9:0] PbGpara; 
input [9:0] PbBpara; 
                   
input [9:0] PrRpara; 
input [9:0] PrGpara; 
input [9:0] PrBpara; 

output [9:0] Y;
output [9:0] Pb;
output [9:0] Pr;

// =======================================================================
// Converting Function 
// -----------------------------------------------------------------------

wire [7:0] TRin;
wire [7:0] TGin;
wire [7:0] TBin;

reg [7:0] R;
reg [7:0] G;
reg [7:0] B;

wire [7:0] bR;
wire [7:0] bG;
wire [7:0] bB;

wire [18:0] wY;
wire [18:0] wPb;
wire [18:0] wPr;

wire [9:0] rY;
wire [9:0] rPb;
wire [9:0] rPr;

reg [9:0] rY_d;
reg [9:0] rPb_d;
reg [9:0] rPr_d;

reg [9:0] Y;
reg [9:0] Pb;
reg [9:0] Pr;
// =======================================================================
// MUX RGB Function 
// -----------------------------------------------------------------------
/*                          480p mode
X1024__________________________
Y¡¯ = 306R¡¯ + 601G¡¯ + 117B¡¯
Pb = -173R' - 334G' + 512B'
Pr = 512R'  - 429G' - 83B'
______________________________

                           720p 1080i
X1024_________________________
Y¡Ç  = 218R¡Ç + 732G¡Ç + 74B¡Ç
Pb = -118R' - 394G' + 512B'
Pr = 512R¡Ç - 465G¡Ç - 47B¡Ç
______________________________

// ----------------------------------------------------------------------- */

assign TRin = (EN_INTERNAL_PATTERN) ? Rgen : Rin;
assign TGin = (EN_INTERNAL_PATTERN) ? Ggen : Gin;
assign TBin = (EN_INTERNAL_PATTERN) ? Bgen : Bin;

assign bR = Limit(TRin);
assign bG = Limit(TGin);
assign bB = Limit(TBin);


always @(posedge CLK or negedge RESETn) begin
    if(!RESETn) begin
        R <= 0;
        G <= 0;
        B <= 0;

        rY_d  <= 0;
        rPb_d <= 0;
        rPr_d <= 0;
    end
    else begin

        if(BLANKn & !EN_INTERNAL_PATTERN) begin
            R <= bR;
            G <= bG;
            B <= bB;
        end
        else if(EN_INTERNAL_PATTERN) begin
            R <= bR;
            G <= bG;
            B <= bB;
        end
        else begin
            R <= 0;
            G <= 0;
            B <= 0;
        end

        rY_d  <= rY;
        rPb_d <= rPb;
        rPr_d <= rPr;
    end
end



// =======================================================================
// Calculation Function 
// -----------------------------------------------------------------------

assign wY  = YRpara*R  + YGpara*G  + YBpara*B;
assign wPb = -PbRpara*R - PbGpara*G + PbBpara*B;
assign wPr = PrRpara*R - PrGpara*G - PrBpara*B;

assign rY  = (wY[17:8] > 939) ? 10'd939 : wY[17:8];
assign rPb = RoundPro(wPb);
assign rPr = RoundPro(wPr);

// =======================================================================
// Output Reg Function 
// -----------------------------------------------------------------------

always @(posedge CLK or negedge RESETn) begin

    if(!RESETn) begin
        Y  <= 0;
        Pb <= 0;
        Pr <= 0;
    end 
    else
    begin
        Y  <= rY_d;
        Pb <= rPb_d;
        Pr <= rPr_d;
    end
end

// =======================================================================
// Limit Function 
// -----------------------------------------------------------------------

function [7:0] Limit;
    input [7:0] A;
    begin
        if(A > 235)         Limit = 235;
        else if(A < 16)     Limit = 16;
        else                Limit = A;
    end
endfunction
// -----------------------------------------------------------------------

function [9:0] RoundPro;
    input [18:0] A;
    begin
        case({A[18],A[17]})// synopsys parallel_case
            2'b10: RoundPro = 10'h3ff;
            2'b01: RoundPro = 10'h2ff;
            default:
                RoundPro = ({A[18], A[16:8]}) + A[7];
        endcase
    end
endfunction
// -----------------------------------------------------------------------
endmodule
