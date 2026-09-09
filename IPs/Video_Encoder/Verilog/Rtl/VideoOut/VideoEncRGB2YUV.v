// =======================================================================
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from RichenTech
// ALL RIGHTS RESERVED RichenTech      
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
//New version

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

wire [8:0] R;
wire [8:0] G;
wire [8:0] B;


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

assign R = (EN_INTERNAL_PATTERN) ? {1'b0, Rgen} : {1'b0, Rin};
assign G = (EN_INTERNAL_PATTERN) ? {1'b0, Ggen} : {1'b0, Gin};
assign B = (EN_INTERNAL_PATTERN) ? {1'b0, Bgen} : {1'b0, Bin};

wire [8:0] R2s = ~R + 1;
wire [8:0] G2s = ~G + 1;
wire [8:0] B2s = ~B + 1;

reg  [15:0] Y_Ri0;
reg  [15:0] Y_Gi0;
reg  [15:0] Y_Bi0;

reg  [15:0] U_Ri0;
reg  [15:0] U_Gi0;
reg  [15:0] U_Bi0;

reg  [15:0] V_Ri0;
reg  [15:0] V_Gi0;
reg  [15:0] V_Bi0;

//////////////////////////////////////////////
reg [18:0] YRin; 
reg [18:0] YGin; 
reg [18:0] YBin; 

reg [18:0] URin; 
reg [18:0] UGin; 
reg [18:0] UBin; 

reg [18:0] VRin; 
reg [18:0] VGin; 
reg [18:0] VBin; 

wire [18:0] Y_Temp = YRin + YGin + YBin;
wire [18:0] U_Temp = URin + UGin + UBin;
wire [18:0] V_Temp = VRin + VGin + VBin;

//////////////////////////////////////////////
reg  [14:0] Y_RTemp0A;
reg  [14:0] Y_RTemp0B;
reg  [17:0] Y_RTemp1A;
reg  [17:0] Y_RTemp1B;

reg  [14:0] Y_Gtemp0A;
reg  [14:0] Y_Gtemp0B;
reg  [15:0] Y_Gtemp1A;
reg  [15:0] Y_Gtemp1B;
reg  [18:0] Y_Gtemp2A;
reg  [18:0] Y_Gtemp2B;

reg  [15:0] Y_BTemp0A;
reg  [15:0] Y_BTemp0B;
reg  [16:0] Y_BTemp1A;
reg  [16:0] Y_BTemp1B;

reg  [14:0] U_Rtemp0A;
reg  [14:0] U_Rtemp0B;
reg  [11:0] U_Rtemp1A;
reg  [11:0] U_Rtemp1B;
reg  [16:0] U_Rtemp2A;
reg  [16:0] U_Rtemp2B;

reg  [17:0] U_Gtemp0A;
reg  [17:0] U_Gtemp0B;
reg  [13:0] U_Gtemp1A;
reg  [13:0] U_Gtemp1B;
reg  [18:0] U_Gtemp2A;
reg  [18:0] U_Gtemp2B;

reg  [16:0] U_Btemp0A;
reg  [16:0] U_Btemp0B;
reg  [15:0] U_Btemp1A;
reg  [15:0] U_Btemp1B;
reg  [17:0] U_Btemp2A;
reg  [17:0] U_Btemp2B;
reg  [19:0] U_Btemp3A;
reg  [19:0] U_Btemp3B;

reg  [11:0] V_Rtemp0A;
reg  [11:0] V_Rtemp0B;
reg  [18:0] V_Rtemp1A;
reg  [18:0] V_Rtemp1B;
reg  [15:0] V_Rtemp2A;
reg  [15:0] V_Rtemp2B;
reg  [19:0] V_Rtemp3A;
reg  [19:0] V_Rtemp3B;

reg  [16:0] V_Gtemp0A;
reg  [16:0] V_Gtemp0B;
reg  [13:0] V_Gtemp1A;
reg  [13:0] V_Gtemp1B;
reg  [18:0] V_Gtemp2A;
reg  [18:0] V_Gtemp2B;
reg  [19:0] V_Gtemp3A;
reg  [19:0] V_Gtemp3B;

reg  [15:0] V_Btemp0A;
reg  [15:0] V_Btemp0B;
reg  [16:0] V_Btemp1A;
reg  [16:0] V_Btemp1B;

//Cal.. Y convsion///////////////////////////
wire [14:0] Y_RTemp0 = Y_RTemp0A + Y_RTemp0B;
wire [17:0] Y_RTemp1 = Y_RTemp1A + Y_RTemp1B;

wire [14:0] Y_Gtemp0 = Y_Gtemp0A + Y_Gtemp0B;
wire [15:0] Y_Gtemp1 = Y_Gtemp1A + Y_Gtemp1B;
wire [18:0] Y_Gtemp2 = Y_Gtemp2A + Y_Gtemp2B;

wire [15:0] Y_BTemp0 = Y_BTemp0A + Y_BTemp0B;
wire [16:0] Y_BTemp1 = Y_BTemp1A + Y_BTemp1B;

wire [14:0] U_Rtemp0 = U_Rtemp0A + U_Rtemp0B;
wire [11:0] U_Rtemp1 = U_Rtemp1A + U_Rtemp1B;
wire [16:0] U_Rtemp2 = U_Rtemp2A + U_Rtemp2B;

wire [17:0] U_Gtemp0 = U_Gtemp0A + U_Gtemp0B;
wire [13:0] U_Gtemp1 = U_Gtemp1A + U_Gtemp1B;
wire [18:0] U_Gtemp2 = U_Gtemp2A + U_Gtemp2B;

wire [16:0] U_Btemp0 = U_Btemp0A + U_Btemp0B;
wire [15:0] U_Btemp1 = U_Btemp1A + U_Btemp1B;
wire [17:0] U_Btemp2 = U_Btemp2A + U_Btemp2B;
wire [19:0] U_Btemp3 = U_Btemp3A + U_Btemp3B;

wire [11:0] V_Rtemp0 = V_Rtemp0A + V_Rtemp0B;
wire [18:0] V_Rtemp1 = V_Rtemp1A + V_Rtemp1B;
wire [15:0] V_Rtemp2 = V_Rtemp2A + V_Rtemp2B;
wire [19:0] V_Rtemp3 = V_Rtemp3A + V_Rtemp3B;

wire [16:0] V_Gtemp0 = V_Gtemp0A + V_Gtemp0B;
wire [13:0] V_Gtemp1 = V_Gtemp1A + V_Gtemp1B;
wire [18:0] V_Gtemp2 = V_Gtemp2A + V_Gtemp2B;
wire [19:0] V_Gtemp3 = V_Gtemp3A + V_Gtemp3B;

wire [15:0] V_Btemp0 = V_Btemp0A + V_Btemp0B;
wire [16:0] V_Btemp1 = V_Btemp1A + V_Btemp1B;

always @(PARA1_ON or PARA2_ON or PARA3_ON or 

          R or R2s or Y_RTemp0 or Y_RTemp1 or
          G or G2s or Y_Gtemp0 or Y_Gtemp1 or Y_Gtemp2 or
          B or B2s or Y_BTemp0 or Y_BTemp1 or
          U_Rtemp0 or U_Rtemp1 or U_Rtemp2 or
          U_Gtemp0 or U_Gtemp1 or U_Gtemp2 or
          U_Btemp0 or U_Btemp1 or U_Btemp2 or U_Btemp3 or
          V_Rtemp0 or V_Rtemp1 or V_Rtemp2 or V_Rtemp3 or
          V_Gtemp0 or V_Gtemp1 or V_Gtemp2 or V_Gtemp3 or
          V_Btemp0 or V_Btemp1 

        ) begin

    case({PARA1_ON, PARA2_ON, PARA3_ON}) // synopsys parallel_case
        
        3'b100: begin

                //Y_______
                    //155
                    Y_RTemp0A = {1'b0, R, 5'd0};
                    Y_RTemp0B = {{6{R2s[8]}}, R2s};
                    Y_RTemp1A = {{2{Y_RTemp0[14]}}, Y_RTemp0, 2'd0};
                    Y_RTemp1B = {4'd0, Y_RTemp0};
                    YRin      = {1'b0, Y_RTemp1};

                    //304
                    Y_Gtemp0A = {1'b0, G, 5'd0};
                    Y_Gtemp0B = {{6{G2s[8]}}, G2s};
                    Y_Gtemp1A = {5'd0, G, 2'd0};
                    Y_Gtemp1B = {{7{G2s[8]}}, G2s};
                    Y_Gtemp2A = {Y_Gtemp0, 4'd0};
                    Y_Gtemp2B = -{Y_Gtemp1[12:0], 6'd0};
                    YGin      = Y_Gtemp2;

                    //59
                    Y_BTemp0A = {1'b0 ,B, 6'd0};
                    Y_BTemp0B = {{7{B2s[8]}}, B2s};
                    Y_BTemp1A = {Y_BTemp0[15], Y_BTemp0};
                    Y_BTemp1B = -{{6{B[8]}}, B, 2'd0};
                    YBin      = {1'd0, Y_BTemp1};

                //U_______
                    //-76
                    U_Rtemp0A = {1'd0, R, 5'd0};
                    U_Rtemp0B = {{6{R2s[8]}}, R2s};
                    U_Rtemp1A = {4'd0, R, 2'd0};
                    U_Rtemp1B = {{6{R2s[8]}}, R2s};
                    U_Rtemp2A = {{3'd0}, U_Rtemp0, 2'd0};
                    U_Rtemp2B = -{{1'd0}, U_Rtemp1, 4'd0};
                    URin      = -{1'd0, U_Rtemp2};

                    //-150
                    U_Gtemp0A = 0;
                    U_Gtemp0B = 0;
                    U_Gtemp1A = {1'd0, G, 4'd0};
                    U_Gtemp1B = {{5{G2s[8]}}, G2s};
                    U_Gtemp2A = {{2'd0}, U_Gtemp1, 3'd0};
                    U_Gtemp2B = {{4'd0}, U_Gtemp1, 1'd0};
                    UGin      = -U_Gtemp2;

                    //226
                    U_Btemp0A = {1'd0, B, 7'd0};
                    U_Btemp0B = {{8{B2s[8]}}, B2s};
                    U_Btemp1A = {6'd0, B, 3'd0};
                    U_Btemp1B = {{8{B2s[8]}}, B2s};
                    U_Btemp2A = {U_Btemp0, 1'd0};
                    U_Btemp2B = -{U_Btemp1, 2'd0};
                    U_Btemp3A = 0;
                    U_Btemp3B = 0;
                    UBin      = {1'd0, U_Btemp2};


                //V_______
                    //319
                    V_Rtemp0A = 0;
                    V_Rtemp0B = 0;
                    V_Rtemp1A = {1'd0, R, 9'd0};
                    V_Rtemp1B = {{10{R2s[8]}}, R2s};
                    V_Rtemp2A = {5'd0, R, 2'd0};
                    V_Rtemp2B = {{7{R2s[8]}}, R2s};
                    V_Rtemp3A = {1'd0, V_Rtemp1};
                    V_Rtemp3B = -{V_Rtemp2[13:0], 6'd0};
                    VRin      = {V_Rtemp3[18:0]};

                    //-267
                    V_Gtemp0A = {2'd0, G, 6'd0};
                    V_Gtemp0B = {{8{G2s[8]}}, G2s};
                    V_Gtemp1A = {1'd0, G, 4'd0};
                    V_Gtemp1B = {{5{G2s[8]}}, G2s};
                    V_Gtemp2A = {V_Gtemp0, 2'd0};
                    V_Gtemp2B = {5'd0, V_Gtemp1};
                    V_Gtemp3A = 0;
                    V_Gtemp3B = 0;
                    VGin      = -{V_Gtemp2};

                    //-52
                    V_Btemp0A = {3'd0, B, 4'd0};
                    V_Btemp0B = {{7{B2s[8]}}, B2s};
                    V_Btemp1A = {V_Btemp0[14:0], 2'd0};
                    V_Btemp1B = -{5'd0, B,3'd0};
                    VBin      = -{2'd0,V_Btemp1};

                end

        3'b010: begin
                //Y_______
                    //168
                    Y_RTemp0A = {R, 3'd0};
                    Y_RTemp0B = {{6{R2s[8]}}, R2s};
                    Y_RTemp1A = {Y_RTemp0, 4'd0};
                    Y_RTemp1B = {1'd0, Y_RTemp0, 3'd0};
                    YRin      = {1'b0, Y_RTemp1};

                    //329
                    Y_Gtemp0A = {4'd0, G, 2'd0};
                    Y_Gtemp0B = {6'd0, G};
                    Y_Gtemp1A = {4'd0, G, 3'd0};
                    Y_Gtemp1B = {7'd0, G};
                    Y_Gtemp2A = {Y_Gtemp0[12:0], 6'd0};
                    Y_Gtemp2B = {Y_Gtemp1};
                    YGin      = Y_Gtemp2;

                    //63
                    Y_BTemp0A = {1'b0 ,B, 6'd0};
                    Y_BTemp0B = {{7{B2s[8]}}, B2s};
                    Y_BTemp1A = 0;
                    Y_BTemp1B = 0;
                    YBin      = {1'd0, Y_BTemp0};

                //U_______
                    //-82
                    U_Rtemp0A = 0;
                    U_Rtemp0B = 0;
                    U_Rtemp1A = {R, 2'd0};
                    U_Rtemp1B = {R};
                    U_Rtemp2A = {U_Rtemp1, 4'd0};
                    U_Rtemp2B = {R, 1'd0};
                    URin      = -{1'd0, U_Rtemp2};

                    //-163
                    U_Gtemp0A = {G, 2'd0};
                    U_Gtemp0B = G;
                    U_Gtemp1A = {G, 2'd0};
                    U_Gtemp1B = {{5{G2s[8]}}, G2s};
                    U_Gtemp2A = {U_Gtemp0, 5'd0};
                    U_Gtemp2B = {U_Gtemp1};
                    UGin      = -U_Gtemp2;

                    //245
                    U_Btemp0A = {B, 3'd0};
                    U_Btemp0B = {{8{B2s[8]}}, B2s};
                    U_Btemp1A = {B, 6'd0};
                    U_Btemp1B = {{8{B2s[8]}}, B2s};
                    U_Btemp2A = {U_Btemp1, 1'd0};
                    U_Btemp2B = -{U_Btemp0};
                    U_Btemp3A = {U_Btemp2, 1'd0};
                    U_Btemp3B = {U_Btemp0};
                    UBin      = {1'd0, U_Btemp3};

                //V_______
                    //345
                    V_Rtemp0A = {R, 2'd0};
                    V_Rtemp0B = -R;
                    V_Rtemp1A = {R, 2'd0};
                    V_Rtemp1B = {R};
                    V_Rtemp2A = {V_Rtemp0, 3'd0};
                    V_Rtemp2B = {R};
                    V_Rtemp3A = {V_Rtemp1, 6'd0};
                    V_Rtemp3B = {V_Rtemp2};
                    VRin      = {V_Rtemp3[18:0]};

                    //-289
                    V_Gtemp0A = 0;
                    V_Gtemp0B = 0;
                    V_Gtemp1A = 0;
                    V_Gtemp1B = 0;
                    V_Gtemp2A = {G, 3'd0};
                    V_Gtemp2B = {G};
                    V_Gtemp3A = {V_Gtemp2, 5'd0};
                    V_Gtemp3B = {G};
                    VGin      = -{V_Gtemp3};

                    //-56
                    V_Btemp0A = {4'd0, B, 3'd0};
                    V_Btemp0B = {{7{B2s[8]}}, B2s};
                    V_Btemp1A = 0;
                    V_Btemp1B = 0;
                    VBin      = -{V_Btemp0, 3'd0};

                end

        3'b001: begin
                //Y_______
                    //164
                    Y_RTemp0A = {1'd0, R, 2'd0};
                    Y_RTemp0B = {3'd0, R};
                    Y_RTemp1A = {Y_RTemp0[12:0], 3'd0};
                    Y_RTemp1B = {8'd0, R};
                    YRin      = {Y_RTemp1, 2'd0};

                    //322
                    Y_Gtemp0A = 0;
                    Y_Gtemp0B = 0;
                    Y_Gtemp1A = {5'd0, G, 2'd0};
                    Y_Gtemp1B = {7'd0, G};
                    Y_Gtemp2A = {Y_Gtemp1[13:0], 5'd0};
                    Y_Gtemp2B = {10'd0, G};
                    YGin      = {Y_Gtemp2[17:0], 1'b0};

                    //62
                    Y_BTemp0A = 0;
                    Y_BTemp0B = 0;
                    Y_BTemp1A = {3'd0, B, 5'd0};
                    Y_BTemp1B = -{{9{B[8]}}, B};
                    YBin      = {1'd0, Y_BTemp1, 1'b0};

                //U_______
                    //-81
                    U_Rtemp0A = 0;
                    U_Rtemp0B = 0;
                    U_Rtemp1A = {1'd0, R, 2'd0};
                    U_Rtemp1B = {3'd0, R};
                    U_Rtemp2A = {1'd0, U_Rtemp1, 4'd0};
                    U_Rtemp2B = {8'd0, R};
                    URin      = -{1'd0, U_Rtemp2};

                    //-159
                    U_Gtemp0A = {1'd0, G,8'd0};
                    U_Gtemp0B = {{9{G2s[8]}}, G2s};
                    U_Gtemp1A = {3'd0, G, 2'd0};
                    U_Gtemp1B = {{5{G2s[8]}}, G2s};
                    U_Gtemp2A = {1'd0, U_Gtemp0};
                    U_Gtemp2B = -{U_Gtemp1, 5'd0};
                    UGin      = -U_Gtemp2;

                    //240
                    U_Btemp0A = {4'd0, B, 4'd0};
                    U_Btemp0B = {{8{B2s[8]}}, B2s};
                    U_Btemp1A = 0;
                    U_Btemp1B = 0;
                    U_Btemp2A = 0;
                    U_Btemp2B = 0;
                    U_Btemp3A = 0;
                    U_Btemp3B = 0;
                    UBin      = {U_Btemp0[13:0], 4'd0};

                //V_______
                    //337
                    V_Rtemp0A = {1'd0, R, 2'd0};
                    V_Rtemp0B = {3'd0, R};
                    V_Rtemp1A = {6'd0, R, 4'd0};
                    V_Rtemp1B = {10'd0, R};
                    V_Rtemp2A = 0;
                    V_Rtemp2B = 0;
                    V_Rtemp3A = {2'd0, V_Rtemp0, 6'd0};
                    V_Rtemp3B = {1'd0, V_Rtemp1};
                    VRin      = {V_Rtemp3[18:0]};

                    //-282
                    V_Gtemp0A = {1'd0, G, 7'd0};
                    V_Gtemp0B = {8'd0, G};
                    V_Gtemp1A = {3'd0, G, 2'd0};
                    V_Gtemp1B = {{5{G2s[8]}}, G2s};

                    V_Gtemp2A = {3'b0, V_Gtemp0};
                    V_Gtemp2B = {4'd0, V_Gtemp1, 1'd0};

                    V_Gtemp3A = {V_Gtemp2[17:0], 1'd0};
                    V_Gtemp3B = -{2'd0, V_Gtemp0};

                    VGin      = -{V_Gtemp3[17:0], 1'd0};

                    //-55
                    V_Btemp0A = {1'd0, B, 6'd0};
                    V_Btemp0B = {{7{B2s[8]}}, B2s};
                    V_Btemp1A = {2'd0, V_Btemp0[14:0]};
                    V_Btemp1B = -{5'd0, B,3'd0};
                    VBin      = -{2'd0,V_Btemp1};

                end
		default: begin

            Y_RTemp0A = 0;
            Y_RTemp0B = 0;
            Y_RTemp1A = 0;
            Y_RTemp1B = 0;

            Y_Gtemp0A = 0;
            Y_Gtemp0B = 0;
            Y_Gtemp1A = 0;
            Y_Gtemp1B = 0;
            Y_Gtemp2A = 0;
            Y_Gtemp2B = 0;

            Y_BTemp0A = 0;
            Y_BTemp0B = 0;
            Y_BTemp1A = 0;
            Y_BTemp1B = 0;

            U_Rtemp0A = 0;
            U_Rtemp0B = 0;
            U_Rtemp1A = 0;
            U_Rtemp1B = 0;
            U_Rtemp2A = 0;
            U_Rtemp2B = 0;

            U_Gtemp0A = 0;
            U_Gtemp0B = 0;
            U_Gtemp1A = 0;
            U_Gtemp1B = 0;
            U_Gtemp2A = 0;
            U_Gtemp2B = 0;

            U_Btemp0A = 0;
            U_Btemp0B = 0;
            U_Btemp1A = 0;
            U_Btemp1B = 0;
            U_Btemp2A = 0;
            U_Btemp2B = 0;
            U_Btemp3A = 0;
            U_Btemp3B = 0;

            V_Rtemp0A = 0;
            V_Rtemp0B = 0;
            V_Rtemp1A = 0;
            V_Rtemp1B = 0;
            V_Rtemp2A = 0;
            V_Rtemp2B = 0;
            V_Rtemp3A = 0;
            V_Rtemp3B = 0;

            V_Gtemp0A = 0;
            V_Gtemp0B = 0;
            V_Gtemp1A = 0;
            V_Gtemp1B = 0;
            V_Gtemp2A = 0;
            V_Gtemp2B = 0;
            V_Gtemp3A = 0;
            V_Gtemp3B = 0;
            
            V_Btemp0A = 0;
            V_Btemp0B = 0;
            V_Btemp1A = 0;
            V_Btemp1B = 0;

            YRin = 0; 
            YGin = 0; 
            YBin = 0; 
            
            URin = 0; 
            UGin = 0; 
            UBin = 0; 

            VRin = 0; 
            VGin = 0; 
            VBin = 0; 

			   end
    endcase
end

assign Y = (Y_Temp[18]) ? 10'd0 : (Y_Temp[17:8] + Y_Temp[7]);
//assign U = (ColorZero)  ? 10'd0 : RoundPro(U_Temp[15:0]); 
//assign V = (ColorZero)  ? 10'd0 : RoundPro(V_Temp[15:0]); 
assign U = RoundPro(U_Temp); 
assign V = RoundPro(V_Temp); 

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

endmodule
