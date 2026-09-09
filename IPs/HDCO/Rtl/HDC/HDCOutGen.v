// =======================================================================
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from RichenTech
// ALL RIGHTS RESERVED RichenTech
// -----------------------------------------------------------------------
// Version and Release information:
// 
// File Name           : HDCOutGen.v
// File Revision       : 0.1
// -----------------------------------------------------------------------
// Purpose            : This module is Output Level genreation 
//                      for HD-Components 
// =======================================================================

`timescale 1ns/10ps

module HDCOutGen
(
    //Interface signal 
    CLK,       // 27Mhz or 74.25Mhz clock input
    RESETn,

    HD_MODE,
    ENABLE,
    EnSYNCPbPr,
    EnDAC0,
    EnDAC1,
    EnDAC2,

    Y,
    Pb,
    Pr,

    YH0to1_1,
    YH0to1_2,
    YH0to1_3,
    YH0to2_1,
    YH0to2_2,
    YH0to2_3,
    YH2to1_1,
    YH2to1_2,
    YH2to1_3,

    YLevel00,
    YLevel01,
    YLevel02,

    PH0to1_1,
    PH0to1_2,
    PH0to1_3,
    PH0to2_1,
    PH0to2_2,
    PH0to2_3,
    PH2to1_1,
    PH2to1_2,
    PH2to1_3,

    PLevel00,
    PLevel01,
    PLevel02,

    LUMA_AMP,
    Pb_AMP,
    Pr_AMP,

    OUT_LEVEL,
    ACT_DISPLAY_SYN,

    DAC0_Luminace,
    DAC1_Pb,
    DAC2_Pr
);

// =======================================================================
// Input & Ouput define
// -----------------------------------------------------------------------

input CLK;       // 27Mhz or 74.25Mhz clock input
input RESETn;

input ENABLE;
input [1:0] HD_MODE;
input EnSYNCPbPr;
input EnDAC0;
input EnDAC1;
input EnDAC2;

input [9:0] Y;
input [9:0] Pb;
input [9:0] Pr;

input [9:0] YH0to1_1;
input [9:0] YH0to1_2;
input [9:0] YH0to1_3;
input [9:0] YH0to2_1;
input [9:0] YH0to2_2;
input [9:0] YH0to2_3;
input [9:0] YH2to1_1;
input [9:0] YH2to1_2;
input [9:0] YH2to1_3;

input [9:0] YLevel00;
input [9:0] YLevel01;
input [9:0] YLevel02;

input [9:0] PH0to1_1;
input [9:0] PH0to1_2;
input [9:0] PH0to1_3;
input [9:0] PH0to2_1;
input [9:0] PH0to2_2;
input [9:0] PH0to2_3;
input [9:0] PH2to1_1;
input [9:0] PH2to1_2;
input [9:0] PH2to1_3;
 
input [9:0] PLevel00;
input [9:0] PLevel01;
input [9:0] PLevel02;

input [7:0] LUMA_AMP;
input [7:0] Pb_AMP;
input [7:0] Pr_AMP;

input [1:0] OUT_LEVEL;
input ACT_DISPLAY_SYN;

output [9:0] DAC0_Luminace;
output [9:0] DAC1_Pb;
output [9:0] DAC2_Pr;

// =======================================================================
// REG & wire define
// -----------------------------------------------------------------------
reg [2:0]  SlopCnt;
reg [17:0] SatuPbMul_d;
reg [17:0] SatuPrMul_d;
reg [17:0] SatuYMul_d;
reg SigPb_d;
reg SigPr_d;
reg [1:0]  OutLevel_d;

reg ACT_DISPLAY_SYN_1d;
reg ACT_DISPLAY_SYN_2d;
reg ACT_DISPLAY_SYN_3d;
reg ACT_DISPLAY_SYN_4d;
reg ACT_DISPLAY_SYN_5d;
reg ACT_DISPLAY_SYN_6d;
reg ACT_DISPLAY_SYN_7d;

reg [9:0]  TempY0;
reg [9:0]  TempPb0;
reg [9:0]  TempPr0;

reg [9:0]  DAC0_Luminace;
reg [9:0]  DAC1_Pb;
reg [9:0]  DAC2_Pr;

wire [9:0] YH1to0_1 = YH0to1_3;
wire [9:0] YH1to0_2 = YH0to1_2;
wire [9:0] YH1to0_3 = YH0to1_1;

wire [9:0] PH1to0_1 = PH0to1_3;
wire [9:0] PH1to0_2 = PH0to1_2;
wire [9:0] PH1to0_3 = PH0to1_1;


wire ActArea = ACT_DISPLAY_SYN_1d | ACT_DISPLAY_SYN_2d | ACT_DISPLAY_SYN_3d |
               ACT_DISPLAY_SYN_4d | ACT_DISPLAY_SYN_5d ;

// =======================================================================
// Slop counter
// -----------------------------------------------------------------------

wire [2:0] NxSlopCntP1 = SlopCnt + 1;
wire [2:0] NxSlopCntP2 = SlopCnt + 2;

reg St1to0;
reg St0to2;
reg St2to1;
reg St0to1;
reg ActDisplay;

wire EnCnt  = St1to0 |
              St0to2 |
              St2to1 |
              St0to1 |
              ActDisplay;

always @(posedge CLK or negedge RESETn) begin
    if(!RESETn) begin
        SlopCnt <= 4;
    end
    else if(!ENABLE) begin
        SlopCnt <= 4;
    end
    else if(SlopCnt == 4 && EnCnt)begin
        SlopCnt <= 0;
    end
    else if((SlopCnt >= 0) && (SlopCnt <= 3) && (HD_MODE != 2'b00))begin
        SlopCnt <= NxSlopCntP1;
    end
    else if((SlopCnt >= 0) && (SlopCnt <= 3) && (HD_MODE == 2'b00))begin
        SlopCnt <= NxSlopCntP2;
    end
    else if(SlopCnt == 4)begin
        SlopCnt <= 4;
    end
end

always @(posedge CLK or negedge RESETn) begin
    if(!RESETn) begin
        St1to0 <= 0;
        St0to2 <= 0;
        St2to1 <= 0;
        St0to1 <= 1;
        ActDisplay <= 0;
    end
    else if(ENABLE) begin

        if(ACT_DISPLAY_SYN != ACT_DISPLAY_SYN_1d) ActDisplay <= 1'b1;
        else                                      ActDisplay <= 1'b0;

        if(OutLevel_d != OUT_LEVEL) begin
            case(OUT_LEVEL)
                2'b00:begin
                        St1to0 <= 1;
                        St0to2 <= 0;
                        St2to1 <= 0;
                        St0to1 <= 0;
                      end
                2'b01:begin
                        St1to0 <= 0;
                        St0to2 <= 0;
                        if(OutLevel_d == 2'd2) begin
                            St2to1 <= 1;
                            St0to1 <= 0;
                        end
                        else begin
                            St2to1 <= 0;
                            St0to1 <= 1;
                        end
                      end
                2'b10:begin
                        St1to0 <= 0;
                        St0to2 <= 1;
                        St2to1 <= 0;
                        St0to1 <= 0;
                      end
                default: begin
                        St1to0 <= 0;
                        St0to2 <= 0;
                        St2to1 <= 0;
                        St0to1 <= 0;
                         end
            endcase
        end
        else begin
                        St1to0 <= 0;
                        St0to2 <= 0;
                        St2to1 <= 0;
                        St0to1 <= 0;
        end
    end
    /*
    else begin
        St1to0 <= 0;
        St0to2 <= 0;
        St2to1 <= 0;
        St0to1 <= 1;
        ActDisplay <= 1'b0;
    end
    */
end

reg rSt1to0;
reg rSt0to2;
reg rSt2to1;
reg rSt0to1;
reg rActDisplay;

always @(posedge CLK or negedge RESETn) begin
    if(!RESETn) begin
        rSt1to0 <= 0;
        rSt0to2 <= 0;
        rSt2to1 <= 0;
        rSt0to1 <= 0;
        rActDisplay <= 0;
    end
    else begin
        if(St1to0) begin
            rSt1to0 <= 1;
            rSt0to2 <= 0;
            rSt2to1 <= 0;
            rSt0to1 <= 0;
            rActDisplay <= 0;
        end
        else if(St0to2) begin
            rSt1to0 <= 0;
            rSt0to2 <= 1;
            rSt2to1 <= 0;
            rSt0to1 <= 0;
            rActDisplay <= 0;
        end
        else if(St2to1) begin
            rSt1to0 <= 0;
            rSt0to2 <= 0;
            rSt2to1 <= 1;
            rSt0to1 <= 0;
            rActDisplay <= 0;
        end
        else if(St0to1) begin
            rSt1to0 <= 0;
            rSt0to2 <= 0;
            rSt2to1 <= 0;
            rSt0to1 <= 1;
            rActDisplay <= 0;
        end
        else if(ActDisplay) begin
            rSt1to0 <= 0;
            rSt0to2 <= 0;
            rSt2to1 <= 0;
            rSt0to1 <= 0;
            rActDisplay <= ~rActDisplay;
        end
    end
end

// =======================================================================
// Sync Delay
// -----------------------------------------------------------------------

always @(posedge CLK or negedge RESETn) begin
    if(!RESETn) begin
        ACT_DISPLAY_SYN_1d <= 0;
        ACT_DISPLAY_SYN_2d <= 0;
        ACT_DISPLAY_SYN_3d <= 0;
        ACT_DISPLAY_SYN_4d <= 0;
        ACT_DISPLAY_SYN_5d <= 0;
        ACT_DISPLAY_SYN_6d <= 0;
        ACT_DISPLAY_SYN_7d <= 0;
        OutLevel_d         <= 0;
    end
    else begin
        ACT_DISPLAY_SYN_1d <= ACT_DISPLAY_SYN;
        ACT_DISPLAY_SYN_2d <= ACT_DISPLAY_SYN_1d;
        ACT_DISPLAY_SYN_3d <= ACT_DISPLAY_SYN_2d;
        ACT_DISPLAY_SYN_4d <= ACT_DISPLAY_SYN_3d;
        ACT_DISPLAY_SYN_5d <= ACT_DISPLAY_SYN_4d;
        ACT_DISPLAY_SYN_6d <= ACT_DISPLAY_SYN_5d;
        ACT_DISPLAY_SYN_7d <= ACT_DISPLAY_SYN_6d;
        OutLevel_d         <= OUT_LEVEL;
    end
end

// =======================================================================
// Amplified Y/Pb/Pr
// -----------------------------------------------------------------------

//Envelop Y/Pb/Pr signal
wire [9:0]Y0_5  = Y[9:1];
wire [9:0]Y0_25 = Y[9:2];
wire [9:0]Y0_75 = Y0_5 + Y0_25;

wire [9:0]Pb0_5  = {Pb[9], Pb[9:1]};
wire [9:0]Pb0_25 = {{2{Pb[9]}}, Pb[9:2]};
wire [9:0]Pb0_75 = Pb0_5 + Pb0_25;

wire [9:0]Pr0_5  = {Pr[9], Pr[9:1]};
wire [9:0]Pr0_25 = {{2{Pr[9]}}, Pr[9:2]};
wire [9:0]Pr0_75 = Pr0_5 + Pr0_25;


reg [9:0] inY;
reg [9:0] inPb;
reg [9:0] inPr;


always @(SlopCnt or 
         Y     or Pb     or Pr     or ACT_DISPLAY_SYN_1d or ACT_DISPLAY_SYN_3d or
         Y0_5  or Y0_25  or Y0_75  or ACT_DISPLAY_SYN_2d or ACT_DISPLAY_SYN_5d or
         Pb0_5 or Pb0_25 or Pb0_75 or ACT_DISPLAY_SYN_4d or ACT_DISPLAY_SYN_6d or
         Pr0_5 or Pr0_25 or Pr0_75 or ActArea
        ) begin

    case({!ActArea,SlopCnt}) //synopsys parallel_case
        4'd0: begin
                if(ACT_DISPLAY_SYN_1d) begin
                    inY  = 0;
                    inPb = 0;
                    inPr = 0;
                end
                else begin
                    inY  = Y;
                    inPb = Pb;
                    inPr = Pr;
                end
              end
        4'd1: begin
                if(ACT_DISPLAY_SYN_2d) begin
                    inY  = Y0_25;
                    inPb = Pb0_25;
                    inPr = Pr0_25;
                end
                else begin
                    inY  = Y0_75;
                    inPb = Pb0_75;
                    inPr = Pr0_75;
                end
              end
        4'd2: begin
                inY = Y0_5;
                inPb = Pb0_5;
                inPr = Pr0_5;
              end
        4'd3: begin
                if(ACT_DISPLAY_SYN_4d) begin
                    inY  = Y0_75;
                    inPb = Pb0_75;
                    inPr = Pr0_75;
                end
                else begin
                    inY  = Y0_25;
                    inPb = Pb0_25;
                    inPr = Pr0_25;
                end
              end
        4'd4: begin
                if(ACT_DISPLAY_SYN_5d |
                   ACT_DISPLAY_SYN_4d |
                   ACT_DISPLAY_SYN_3d |
                   ACT_DISPLAY_SYN_2d |
                   ACT_DISPLAY_SYN_6d 
                  ) begin 
                    inY  = Y;
                    inPb = Pb;
                    inPr = Pr;
                end
                else begin
                    inY  = 0;
                    inPb = 0;
                    inPr = 0;
                end
              end
        default: begin
                    inY  = 0;
                    inPb = 0;
                    inPr = 0;
                 end
    endcase

end

//Y
wire [17:0] SatuYMul   = inY * LUMA_AMP;
wire [9:0]  UnSigSatuY = (SatuYMul_d[17:7] > 1023) ? 10'd1023: 
                                                     (SatuYMul_d[16:7]+SatuYMul_d[6]);
wire [9:0]  SatuY      = UnSigSatuY;

//Pb
wire [9:0]  UnSigPb   = (inPb[9]) ? (~inPb + 10'd1) : inPb;
wire [17:0] SatuPbMul = UnSigPb * Pb_AMP;
wire [9:0]  UnSigSatuPb= SatuOut(SatuPbMul_d);
wire [9:0]  SigSatuPb  = (SigPb_d) ? (~UnSigSatuPb + 10'd1) : UnSigSatuPb; 
wire [9:0]  SatuPb     = SigSatuPb;

//Pr
wire [9:0]  UnSigPr   = (inPr[9]) ? (~inPr + 10'd1) : inPr;
wire [17:0] SatuPrMul = UnSigPr * Pr_AMP;
wire [9:0]  UnSigSatuPr= SatuOut(SatuPrMul_d);
wire [9:0]  SigSatuPr  = (SigPr_d) ? (~UnSigSatuPr + 10'd1) : UnSigSatuPr; 
wire [9:0]  SatuPr     = SigSatuPr;


always @(posedge CLK or negedge RESETn) begin
    if(!RESETn) begin
        SatuPbMul_d <= 0;
        SatuPrMul_d <= 0;
        SatuYMul_d  <= 0;
        SigPb_d <= 0;
        SigPr_d <= 0;
    end
    else begin
        SatuPbMul_d <= SatuPbMul;
        SatuPrMul_d <= SatuPrMul;
        SatuYMul_d  <= SatuYMul;
        SigPb_d <= Pb[9];
        SigPr_d <= Pr[9];
    end
end

// =====================================================================
// Output Synthesis
// ---------------------------------------------------------------------


/*
wire DelaySync         = (HD_MODE == 2'b00) ? (ACT_DISPLAY_SYN_1d | ACT_DISPLAY_SYN_5d): 
                                              (ACT_DISPLAY_SYN_1d | ACT_DISPLAY_SYN_7d);
*/
wire DelaySync         = (ACT_DISPLAY_SYN_1d | ACT_DISPLAY_SYN_7d);
wire [11:0] AddY0      = (DelaySync) ? (YLevel01 + SatuY):TempY0;
wire [9:0]  LimitAddY0 = LimitOut(AddY0);

always @(posedge CLK or negedge RESETn) begin
    if(!RESETn) begin
        TempY0 <= 0;
    end
    else begin
        case({rSt1to0, rSt0to2, rSt2to1, rSt0to1, 
              SlopCnt, ACT_DISPLAY_SYN_1d}
            ) //synopsys parallel_case
            //State 1 to 0  && conut == 0
            8'b10000000: TempY0 <= YLevel01; 
            8'b10000010: TempY0 <= YH1to0_1; 
            8'b10000100: TempY0 <= YH1to0_2; 
            8'b10000110: TempY0 <= YH1to0_3; 
            8'b10001000: TempY0 <= YLevel00; 

            //State 0 to 2  && conut == 0
            8'b01000000: TempY0 <= YLevel00; 
            8'b01000010: TempY0 <= YH0to2_1; 
            8'b01000100: TempY0 <= YH0to2_2; 
            8'b01000110: TempY0 <= YH0to2_3; 
            8'b01001000: TempY0 <= YLevel02; 

            //State 2 to 1  && conut == 0
            8'b00100000: TempY0 <= YLevel02; 
            8'b00100010: TempY0 <= YH2to1_1; 
            8'b00100100: TempY0 <= YH2to1_2; 
            8'b00100110: TempY0 <= YH2to1_3; 
            8'b00101000: TempY0 <= YLevel01; 

            //State 0 to 1  && conut == 0
            8'b00010000: TempY0 <= YLevel00; 
            8'b00010010: TempY0 <= YH0to1_1; 
            8'b00010100: TempY0 <= YH0to1_2; 
            8'b00010110: TempY0 <= YH0to1_3; 
            8'b00011000: TempY0 <= YLevel01; 

            /*
            //State 2 to 1  && conut == 0 Active display
            8'b00101001: TempY0 <= LimitAddY0; 
            //State 0 to 1  && conut == 0 Active display
            8'b00010001: TempY0 <= LimitAddY0; 
            */
        default: TempY0 <= YLevel01;
        endcase
    end
end

wire [11:0] AddPb0      = (DelaySync) ? 
                               ({{2{PLevel01}}, PLevel01} + {{2{SatuPb[9]}}, SatuPb}):
                               TempPb0;

wire [9:0]  LimitAddPb0 = LimitOut(AddPb0);

always @(posedge CLK or negedge RESETn) begin
    if(!RESETn) begin
        TempPb0 <= 0;
    end
    else if(EnSYNCPbPr) begin
        case({rSt1to0, rSt0to2, rSt2to1, rSt0to1, 
              SlopCnt, ACT_DISPLAY_SYN_1d}
            ) //synopsys parallel_case
            //State 1 to 0  && conut == 0
            8'b10000000: TempPb0 <= PLevel01; 
            8'b10000010: TempPb0 <= PH1to0_1; 
            8'b10000100: TempPb0 <= PH1to0_2; 
            8'b10000110: TempPb0 <= PH1to0_3; 
            8'b10001000: TempPb0 <= PLevel00; 

            //State 0 to 2  && conut == 0
            8'b01000000: TempPb0 <= PLevel00; 
            8'b01000010: TempPb0 <= PH0to2_1; 
            8'b01000100: TempPb0 <= PH0to2_2; 
            8'b01000110: TempPb0 <= PH0to2_3; 
            8'b01001000: TempPb0 <= PLevel02; 

            //State 2 to 1  && conut == 0
            8'b00100000: TempPb0 <= PLevel02; 
            8'b00100010: TempPb0 <= PH2to1_1; 
            8'b00100100: TempPb0 <= PH2to1_2; 
            8'b00100110: TempPb0 <= PH2to1_3; 
            8'b00101000: TempPb0 <= PLevel01; 

            //State 0 to 1  && conut == 0
            8'b00010000: TempPb0 <= PLevel00; 
            8'b00010010: TempPb0 <= PH0to1_1; 
            8'b00010100: TempPb0 <= PH0to1_2; 
            8'b00010110: TempPb0 <= PH0to1_3; 
            8'b00011000: TempPb0 <= PLevel01; 

            /*
            //State 2 to 1  && conut == 0 Active display
            8'b00101001: TempPb0 <= LimitAddPb0; 
            //State 0 to 1  && conut == 0 Active display
            8'b00010001: TempPb0 <= LimitAddPb0; 
            */
        default: TempPb0 <= PLevel01;
        endcase
    end
    else begin
            TempPb0 <= PLevel01; 
    end
    /*
    else begin
        if(ACT_DISPLAY_SYN_1d) begin
            TempPb0 <= LimitAddPb0; 
        end
        else begin
            TempPb0 <= PLevel01; 
        end
    end
    */
end


wire [11:0] AddPr0      = (DelaySync) ? 
                              ({{2{PLevel01}}, PLevel01} + {{2{SatuPr[9]}}, SatuPr}):
                              TempPr0;
wire [9:0]  LimitAddPr0 = LimitOut(AddPr0);

always @(posedge CLK or negedge RESETn) begin
    if(!RESETn) begin
        TempPr0 <= 0;
    end
    else if(EnSYNCPbPr) begin
        case({rSt1to0, rSt0to2, rSt2to1, rSt0to1, 
              SlopCnt, ACT_DISPLAY_SYN_1d}
            ) //synopsys parallel_case
            //State 1 to 0  && conut == 0
            8'b10000000: TempPr0 <= PLevel01; 
            8'b10000010: TempPr0 <= PH1to0_1; 
            8'b10000100: TempPr0 <= PH1to0_2; 
            8'b10000110: TempPr0 <= PH1to0_3; 
            8'b10001000: TempPr0 <= PLevel00; 

            //State 0 to 2  && conut == 0
            8'b01000000: TempPr0 <= PLevel00; 
            8'b01000010: TempPr0 <= PH0to2_1; 
            8'b01000100: TempPr0 <= PH0to2_2; 
            8'b01000110: TempPr0 <= PH0to2_3; 
            8'b01001000: TempPr0 <= PLevel02; 

            //State 2 to 1  && conut == 0
            8'b00100000: TempPr0 <= PLevel02; 
            8'b00100010: TempPr0 <= PH2to1_1; 
            8'b00100100: TempPr0 <= PH2to1_2; 
            8'b00100110: TempPr0 <= PH2to1_3; 
            8'b00101000: TempPr0 <= PLevel01; 

            //State 0 to 1  && conut == 0
            8'b00010000: TempPr0 <= PLevel00; 
            8'b00010010: TempPr0 <= PH0to1_1; 
            8'b00010100: TempPr0 <= PH0to1_2; 
            8'b00010110: TempPr0 <= PH0to1_3; 
            8'b00011000: TempPr0 <= PLevel01; 

            /*
            //State 2 to 1  && conut == 0 Active display
            8'b00101001: TempPr0 <= LimitAddPr0; 
            //State 0 to 1  && conut == 0 Active display
            8'b00010001: TempPr0 <= LimitAddPr0; 
            */
        default: TempPr0 <= PLevel01;
        endcase
    end
    else begin
            TempPr0 <= PLevel01; 
    end
    /*
    else begin
        if(ACT_DISPLAY_SYN_1d) begin
            TempPr0 <= LimitAddPr0; 
        end
        else begin
            TempPr0 <= PLevel01; 
        end
    end
    */
end

// =====================================================================
// DAC otuput Latch
// ---------------------------------------------------------------------

always @(posedge CLK or negedge RESETn) begin
    if(!RESETn) begin
        DAC0_Luminace <= 0;
        DAC1_Pb <= 0;
        DAC2_Pr <= 0;
    end
    else begin
        if(EnDAC0)  DAC0_Luminace <= LimitAddY0;
        else        DAC0_Luminace <= 0;
        
        if(EnDAC1)  DAC1_Pb <= LimitAddPb0;
        else        DAC1_Pb <= 0;

        if(EnDAC2)  DAC2_Pr <= LimitAddPr0;
        else        DAC2_Pr <= 0;
    end
end

// =====================================================================
// Ov saturation 
// ---------------------------------------------------------------------
function  [9:0] SatuOut;
    input [17:0] In;
    begin
        if(In[17:7] > 10'd511) begin 
            SatuOut = 10'd512;
        end
        else begin 
            SatuOut = In[16:7];
        end
    end
endfunction

// =====================================================================
// Ov saturation 
// ---------------------------------------------------------------------
function [9:0]LimitOut;
    input [11:0] In;
    begin
        if(In > 1023 && In[11]) begin
            LimitOut = 10'd0;
        end
        else if(In > 1023 && !In[11]) begin
            LimitOut = 10'd1023;
        end
        else begin
            LimitOut = In[9:0];
        end
    end
endfunction
// -----------------------------------------------------------------------
endmodule
