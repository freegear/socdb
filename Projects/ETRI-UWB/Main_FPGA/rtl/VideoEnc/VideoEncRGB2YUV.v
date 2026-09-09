// =======================================================================
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from SANGHWA MICRO Technology
// ALL RIGHTS RESERVED SANGHWA MICRO Technology      
// -----------------------------------------------------------------------
// Version and Release information:
// 
// File Name           : VideoEncRGB2YUV.v
// File Revision       : 0.1
// -----------------------------------------------------------------------
// Purpose            : This module is converting RGB to YUV in video
//                      Encoder
// =======================================================================

`timescale 1ns/10ps

module VideoEncRGB2YUV
(
    //CLK,       // 27Mhz clock input
    //RESETn,

    //Input
    //ENABLE_PIXEL,

    EN_INTERNAL_PATTERN,
    Rin,
    Gin,
    Bin,

    Rgen,
    Ggen,
    Bgen,

    OUT_MODE,

    //Output
    Y,
    U,
    V
);

parameter R_YPARA_NTSC = 155;      
parameter G_YPARA_NTSC = 304;      
parameter B_YPARA_NTSC = 59;      
parameter R_UPARA_NTSC = 76; //-76;      
parameter G_UPARA_NTSC = 150;//-150;      
parameter B_UPARA_NTSC = 226;      
parameter R_VPARA_NTSC = 319;      
parameter G_VPARA_NTSC = 267;//-267;      
parameter B_VPARA_NTSC = 52; //-52;      

parameter R_YPARA_NTSCJ = 168;      
parameter G_YPARA_NTSCJ = 329;      
parameter B_YPARA_NTSCJ = 63;      
parameter R_UPARA_NTSCJ = 82; //-82;      
parameter G_UPARA_NTSCJ = 163;//-163;      
parameter B_UPARA_NTSCJ = 245;      
parameter R_VPARA_NTSCJ = 345;      
parameter G_VPARA_NTSCJ = 289;//-289;      
parameter B_VPARA_NTSCJ = 56; //-56;      

parameter R_YPARA_PAL = 164;      
parameter G_YPARA_PAL = 322;      
parameter B_YPARA_PAL = 62;      
parameter R_UPARA_PAL = 81; //-81;      
parameter G_UPARA_PAL = 159;//-159;      
parameter B_UPARA_PAL = 240;      
parameter R_VPARA_PAL = 337;      
parameter G_VPARA_PAL = 282;//-282;      
parameter B_VPARA_PAL = 55; //-55;      

//Output format define///////
parameter NTSCM = 3'b000;
parameter NTSCJ = 3'b001;
parameter NTSC4 = 3'b010;
parameter PALM  = 3'b011;
parameter PAL   = 3'b100;
parameter PALNc = 3'b101;
parameter PALN  = 3'b110;
////////////////////////////


//input CLK;
//input RESETn;

input [7:0] Rin;
input [7:0] Gin;
input [7:0] Bin;

input [7:0] Rgen;
input [7:0] Ggen;
input [7:0] Bgen;

//input ENABLE_PIXEL;
input EN_INTERNAL_PATTERN;
input [2:0] OUT_MODE;

output [9:0] Y;
output [9:0] U;
output [9:0] V;

wire [7:0] R;
wire [7:0] G;
wire [7:0] B;


// =======================================================================
// Converting Function 
// -----------------------------------------------------------------------

//  NTSC---------------------------------------------
//  Y= 0.151R¢¥ +0.297G¢¥ +0.058B¢¥
//  U= -0.074R¢¥- 0.147G¢¥ + 0.221B¢¥
//  V= 0.312R¢¥- 0.261G¢¥- 0.051B¢¥

//  NTSCJ--------------------------------------------
//  Y= 0.164R¢¥ +0.321G¢¥ + 0.062B¢¥
//  U= -0.080R¢¥- 0.159G¢¥ + 0.239B¢¥
//  V= 0.337R¢¥- 0.282G¢¥- 0.055B¢¥

//  PAL----------------------------------------------
//  Y= 0.160R¢¥ +0.314G¢¥ +0.061B¢¥
//  U= -0.079R¢¥- 0.155G¢¥ + 0.234B¢¥
//  V= 0.329R¢¥- 0.275G¢¥- 0.054B¢¥

//  3-1 0.5
//  4-2 0.25
//  5-3 0.125
//  6-4 0.0625
//  7-5 0.03125
//  8-6 0.015625
//  9-7 0.0078125
// +1-8 0.00390625     (16)
// +2-9 0.001953125    (8)
//+3-10 0.0009765625   (4)
//+4-11 0.00048828125  (2)
//+5-12 0.000244140625 (1)
// -----------------------------------------------------------------------

wire PARA1_ON = ((OUT_MODE == NTSCM) || 
                 (OUT_MODE == PALM ) ||
                 (OUT_MODE == PALN )) ? 1'b1 : 1'b0; 
wire PARA2_ON =  (OUT_MODE == NTSCJ)  ? 1'b1 : 1'b0;

wire PARA3_ON = ((OUT_MODE == PAL   ) || 
                 (OUT_MODE == PALNc )) ? 1'b1 : 1'b0; 


assign R = (EN_INTERNAL_PATTERN) ? Rgen : Rin;
assign G = (EN_INTERNAL_PATTERN) ? Ggen : Gin;
assign B = (EN_INTERNAL_PATTERN) ? Bgen : Bin;

wire ColorZero = ((R==B) && (R==G) && (B==G) ) ? 
				 1'b1: 1'b0; 

wire [15:0] Rin_2 = {5'd0, R[7:0], 3'd0};
wire [15:0] Rin_3 = {6'd0, R[7:0], 2'd0};
wire [15:0] Rin_4 = {7'd0, R[7:0], 1'd0};
wire [15:0] Rin_5 = {8'd0, R[7:0]};
wire [15:0] Rin_6 = ({9'd0, R[7:1]}) + R[0];
wire [15:0] Rin_7 = ({10'd0,R[7:2]}) + R[1];

/*
wire [15:0] Rin_8 = 16'd0;
wire [15:0] Rin_9 = 16'd0;
wire [15:0] Rin_10= 16'd0;
*/
wire [15:0] Rin_8 = (R==8'h00) ? 16'd0 : 16'd16;
wire [15:0] Rin_9 = (R==8'h00) ? 16'd0 : 16'd8;
wire [15:0] Rin_10= (R==8'h00) ? 16'd0 : 16'd4;

wire [15:0] Gin_2 = {5'd0, G[7:0], 3'd0};
wire [15:0] Gin_3 = {6'd0, G[7:0], 2'd0};
wire [15:0] Gin_4 = {7'd0, G[7:0], 1'd0};
wire [15:0] Gin_5 = {8'd0, G[7:0]};
wire [15:0] Gin_6 = ({9'd0, G[7:1]}) + G[0];
wire [15:0] Gin_7 = ({10'd0,G[7:2]}) + G[1];
/*
wire [15:0] Gin_8 = 16'd0;
wire [15:0] Gin_9 = 16'd0;
wire [15:0] Gin_10= 16'd0;
*/
wire [15:0] Gin_8 = (G==8'h00) ? 16'd0 : 16'd16;
wire [15:0] Gin_10= (G==8'h00) ? 16'd0 : 16'd4;

wire [15:0] Bin_2 = {5'd0, B[7:0], 3'd0};
wire [15:0] Bin_4 = {7'd0, B[7:0], 1'd0};
wire [15:0] Bin_5 = {8'd0, B[7:0]};
wire [15:0] Bin_6 = ({9'd0, B[7:1]}) + B[0];
wire [15:0] Bin_7 = ({10'd0,B[7:2]}) + B[1];
/*
wire [15:0] Bin_8 = 16'd0;
wire [15:0] Bin_9 = 16'd0;
wire [15:0] Bin_10= 16'd0;
*/
wire [15:0] Bin_8 = (B==8'h00) ? 16'd0 : 16'd16;
wire [15:0] Bin_9 = (B==8'h00) ? 16'd0 : 16'd8;
wire [15:0] Bin_10= (B==8'h00) ? 16'd0 : 16'd4;

reg  [15:0] Y_Ri0;
reg  [15:0] Y_Gi0;
reg  [15:0] Y_Bi0;

reg  [15:0] U_Ri0;
reg  [15:0] U_Gi0;
reg  [15:0] U_Bi0;

reg  [15:0] V_Ri0;
reg  [15:0] V_Gi0;
reg  [15:0] V_Bi0;


always @(PARA1_ON or PARA2_ON or PARA3_ON or 
         Rin_5 or
         Bin_7 or
         Gin_6 or 
         Bin_5 or
         Rin_4 or
         Rin_7 or
         Gin_4 or
         Gin_7 or
         Gin_5 or
         Bin_6 or
         Rin_3 or
         Rin_8 or
         Rin_9 or
         Rin_10 or
         Gin_8  or
         Gin_10 or
         Bin_8  or
         Bin_9  or
         Bin_10 or
         Rin_6

        ) begin

    case({PARA1_ON, PARA2_ON, PARA3_ON}) // synopsys parallel_case
        
        3'b100: begin
                    Y_Ri0 = Rin_5 - Rin_8; 
                    //0.125 +0.0312B5 - 0.00390625 = 0.15234375
                    Y_Gi0 = Gin_5 + Gin_6;  
                    //0.25 +0.0312B5 +0.015625 = 0.296875
                    Y_Bi0 = Bin_7 + Bin_8; //16'd16; 
                    //0.0625 - 0.0078125 + 0.00390625 = 0.05859375

                    U_Ri0 =  Rin_6 - Rin_8;
                    //0.0625 + 0.015625 - 0.00390625 = 0.07421875
                    U_Gi0 =  Gin_6 + Gin_7; 
                    //0.125 + 0.015625 + 0.0078125 = 0.1484375
                    U_Bi0 =  Bin_5 + Bin_9; //16'd8; 
                    //0.25 - 0.0312B5+  0.001953125 = 0.220703125

                    V_Ri0 =  Rin_4;         
                    // 0.25 + 0.0625 = 0.3125
                    V_Gi0 =  Gin_6 - Gin_8; //16'd16;
                    //0.25  + 0.015625 - 0.00390625 = 0.26171875
                    V_Bi0 =  Bin_7 - Bin_8; //16'd16;
                    //0.0625 - 0.0078125 - 0.00390625 = 0.05078125

                  end
        3'b010: begin
                    Y_Ri0 = Rin_5 + Rin_7; 
                    //0.125 + 0.0312B5 + 0.0078125 = 0.1640625
                    Y_Gi0 = Gin_4 + Gin_7; 
                    //0.25 + 0.0625 +0.0078125 = 0.3203125
                    Y_Bi0 = 0;

                    U_Ri0 = Rin_6 + Rin_9; //16'd8; 
                    //0.0625 + 0.015625 + 0.001953125 = 0.080078125
                    U_Gi0 = Gin_5 + Gin_8; //16'd16;
                    //0.125 + 0.0312B5 + 0.00390625 = 0.16015625
                    U_Bi0 = Bin_6 + Bin_8; //16'd16;
                    //0.25 - 0.015625 + 0.00390625 = 0.23828125

                    V_Ri0 = Rin_3 - Rin_5;
                    V_Gi0 = Gin_5;         //0.28125 = 0.25 + 0.0312B5
                    V_Bi0 = Bin_7;         //0.0625 - 0.0078125 = 0.0546875

                  end
        3'b001: begin
                    Y_Ri0 = Rin_5 + Rin_8;  //16'd16; 
                    //0.125 + 0.0312B5 + 0.00390625 = 0.16015625
                    Y_Gi0 = Gin_4;          
                    //0.25 + 0.0625 = 0.3125
                    Y_Bi0 = Bin_10; //16'd4;          
                    //0.0625 - 0.0009765625 = 0.0615234375

                    U_Ri0 = Rin_6 + Rin_10; //16'd4;  
                    //0.0625 + 0.015625 + 0.0009765625 = 0.0791015625
                    U_Gi0 = Gin_5 - Gin_10; //16'd4;  
                    //0.125 + 0.0312B5 - 0.0009765625 = 0.1552734375
                    U_Bi0 = Bin_6;          
                    //0.25 - 0.015625 = 0.234375

                    V_Ri0 = Rin_4 + Rin_6;  
                    //0.25 + 0.0625 + 0.015625 = 0.328125
                    V_Gi0 = Gin_6 + Gin_7;  
                    //0.25  + 0.015625 + 0.0078125 = 0.2734375
                    V_Bi0 = Bin_7;          
                    //0.0625 - 0.0078125 = 0.0546875
                  end
		default: begin
					Y_Ri0 = 0;
					Y_Gi0 = 0;
					Y_Bi0 = 0;
					U_Ri0 = 0;
					U_Gi0 = 0;
					U_Bi0 = 0;
					V_Ri0 = 0;
					V_Gi0 = 0;
					V_Bi0 = 0;
				 end
    endcase
end

/* TEST
wire [15:0] Yr = (Rin_3 + Y_Ri0);
wire [15:0] Yg = (Gin_2 + Y_Gi0);
wire [15:0] Yb = (Bin_4 - Y_Bi0);
wire [15:0] Ur = (Rin_4 + U_Ri0);
wire [15:0] Ug = (Gin_3 + U_Gi0);
wire [15:0] Ub = (Bin_2 - U_Bi0);
wire [15:0] Vr = (Rin_2 + V_Ri0);
wire [15:0] Vg = (Gin_2 + V_Gi0);
wire [15:0] Vb = (Bin_4 - V_Bi0);
*/

wire [15:0] Y_Temp  = (Rin_3 + Y_Ri0) + // Rin
                      (Gin_2 + Y_Gi0) + // Gin
                      (Bin_4 - Y_Bi0) ; // Bin


wire [15:0] U_Temp  = -(Rin_4 + U_Ri0) - // Rin
                       (Gin_3 + U_Gi0) + // Gin
                       (Bin_2 - U_Bi0) ; // Bin




wire [15:0] V_Temp  =  (Rin_2 + V_Ri0 ) - // Rin
                       (Gin_2 + V_Gi0)  - // Gin
                       (Bin_4 - V_Bi0)   ;// Bin


assign Y = (Y_Temp[15]) ? 10'd0 : (Y_Temp[12:3] + Y_Temp[2]);
assign U = (ColorZero)  ? 10'd0 : RoundPro(U_Temp); 
assign V = (ColorZero)  ? 10'd0 : RoundPro(V_Temp); 

function [9:0] RoundPro;
    input [15:0] A;
    begin
        case({A[15],A[14]})
            2'b10: RoundPro = 10'h3ff;
            2'b01: RoundPro = 10'h2ff;
            default:
                RoundPro = ({A[15], A[11:3]});
        endcase
    end
endfunction

endmodule
