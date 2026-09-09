// =======================================================================
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from RichenTech
// ALL RIGHTS RESERVED RichenTech
// -----------------------------------------------------------------------
// Version and Release information:
// 
// File Name           : HDCTimerGen.v
// File Revision       : 0.1
// -----------------------------------------------------------------------
// Purpose            : This module is Timing genreation in HD-Components 
// =======================================================================

`timescale 1ns/10ps

module HDCTimerGen
(
    //Interface signal 
    CLK,       // 27Mhz or 74.25Mhz clock input
    RESETn,
    HSYNCn,
    VSYNCn,

    //Setting Signal input
    ENABLE,
    HD_MODE,
    EN_INTERNAL_PATTERN,

    ACT_DISPLAY,
    H1, H2, H3, H4, H5, H6, H7, H8, H9, H10,

    OUT_LEVEL,
    ACT_DISPLAY_SYN
);
        
// =======================================================================
// Input & Ouput define
// -----------------------------------------------------------------------
input  CLK;
input  RESETn;
input  HSYNCn;
input  VSYNCn;

input  ENABLE;
input  EN_INTERNAL_PATTERN;
input  [1:0] HD_MODE;

input  [11:0] ACT_DISPLAY;
input  [11:0] H1;
input  [11:0] H2;
input  [11:0] H3;
input  [11:0] H4;
input  [11:0] H5;
input  [11:0] H6;
input  [11:0] H7;
input  [11:0] H8;
input  [11:0] H9;
input  [11:0] H10;

output [1:0] OUT_LEVEL;
output ACT_DISPLAY_SYN;


// =======================================================================
// REG & wire define
// -----------------------------------------------------------------------
reg  [11:0] H_CNT;
reg  [10:0] V_CNT;

reg  HSYNCn_d;
reg  H_SET_MASTER_d /* synthesis syn_preserve =1 */; 

wire MASTER_SLAVE_SEL = 1; //Slave mode by out side sync
wire H_SET;
wire H_SET_MASTER; 
wire H_SET_M; // in  master mode

wire  F_UP_odd;
wire  F_UP_even;
wire  SETMUX;

reg  [10:0]  TOTAL_LINE;  
reg  [11:0]  END_HSync;  
reg  [11:0]  END_ACT;  
wire [10:0]  HALF_LINE = 563;
wire EN_NONINTERLACE = (HD_MODE == 2'b10) ? 1'b0 : 1'b1;

reg  [11:0] FirstHSyncStart;
reg  [11:0] FirstHSyncEnd;
reg  [11:0] SecoundHSyncStart;
reg  [11:0] SecoundHSyncEnd;
reg  [11:0] AddA;
reg  [11:0] AddB;
reg  [4:0]  AddCnt;

// =======================================================================
// Setting function
// -----------------------------------------------------------------------

always @(HD_MODE) begin
    case(HD_MODE) // synopsys parallel_case
        2'b00: TOTAL_LINE = 525;
        2'b01: TOTAL_LINE = 750;
        2'b10: TOTAL_LINE = 1125;
        default: 
               TOTAL_LINE = 525;
    endcase
end

always @(HD_MODE) begin
    case(HD_MODE) // synopsys parallel_case 
        2'b00: END_HSync = 857;
        2'b01: END_HSync = 1649;
        2'b10: END_HSync = 2199;
        default: 
               END_HSync = 1715;
    endcase
end

always @(HD_MODE) begin
    case(HD_MODE) // synopsys parallel_case 
        2'b00: END_ACT = 854;
        2'b01: END_ACT = 1643;
        2'b10: END_ACT = 2193;
        default: 
               END_ACT = 1709;
    endcase
end
// =======================================================================
// Evne Odd detect
// -----------------------------------------------------------------------
reg   STABLE;
reg   NxSTABLE_EXT;
reg   [3:0] FIELD_CNT;
wire  [3:0] FIELD_OVER = 2;

always @(ENABLE or
         STABLE or
         FIELD_CNT or
         F_UP_odd or
         F_UP_even )
begin
    
    NxSTABLE_EXT = 0;
    case(STABLE) //synopsys parallel_case

        1'b0: begin // UnSTABLE
                if(ENABLE && (FIELD_CNT == 0) && F_UP_odd) begin
                    NxSTABLE_EXT = 1'b1; //STABLE state
                end
                else begin
                    NxSTABLE_EXT = 1'b0; //UnSTABLE
                end
              end

        1'b1: begin //STABLE 
                if(ENABLE & FIELD_CNT[0] & F_UP_odd) begin
                    NxSTABLE_EXT = 1'b0; //STABLE state
                end
                else if(ENABLE & !FIELD_CNT[0] & F_UP_even) begin
                    NxSTABLE_EXT = 1'b0; //STABLE state
                end
                else begin
                    NxSTABLE_EXT =  1'b1;
                end
              end
    endcase
end


always @(posedge CLK or negedge RESETn) begin
    if(!RESETn) STABLE <= 0;
    else        STABLE <= NxSTABLE_EXT;
end

wire NxSTABLE = (SETMUX && (HD_MODE == 2'b10)) ? NxSTABLE_EXT : ENABLE;
// =======================================================================
//  Horizontal Counter Generation
// -----------------------------------------------------------------------
/* Horizontal pixel counter */
assign SETMUX = (EN_INTERNAL_PATTERN) ? 1'b0 : MASTER_SLAVE_SEL;
assign H_SET  = (SETMUX) ? (!HSYNCn & HSYNCn_d) : 1'b0;

always @(posedge CLK or negedge RESETn) begin
    if(!RESETn) begin
        HSYNCn_d <= 1'b0;
        H_SET_MASTER_d <= 1'b0;
    end
    else begin
        HSYNCn_d <= HSYNCn;
        H_SET_MASTER_d <= H_SET_MASTER;
    end
end

assign H_SET_MASTER = (H_CNT == END_HSync) ? 1'b0 : 1'b1;
assign H_SET_M      = H_SET_MASTER_d & !H_SET_MASTER;

always @(posedge CLK or negedge RESETn) begin
    if(!RESETn) begin
        H_CNT <= 0;
    end
    else if(NxSTABLE)begin
        if(!ENABLE)
            H_CNT <= 0;
        else if(H_SET)
            H_CNT <= H1;
        else if(H_CNT == END_HSync)
            H_CNT <= 0;
        else
            H_CNT <= H_CNT + 1;
    end
    else begin
        H_CNT <= 0;
    end
end

// =======================================================================
//  Vertical counter gen.
// -----------------------------------------------------------------------
/* Vertical Line counter */

wire V_SET0;
wire V_SET1;
wire V_SET0_d;
wire V_SET0_1d;

reg VSYNCn_d;
reg VSET_d  ;
reg VSET_1d ;

wire VSET = !VSYNCn & VSYNCn_d;
always @(posedge CLK or negedge RESETn) begin
    if(!RESETn) begin
        VSYNCn_d <= 1'b0;
        VSET_d   <= 1'b0;
        VSET_1d  <= 1'b0;
    end
    else begin
        VSYNCn_d <= VSYNCn;
        VSET_d   <= VSET;
        VSET_1d  <= VSET_d;
    end
end

//applied for mode2
assign V_SET0 = (SETMUX) ? (VSET & H_SET )  : 1'b0; 
              //field change even->odd
assign V_SET1 = (SETMUX) ? (VSET & !H_SET)  : 1'b0; 
              //field change odd ->even
assign V_SET0_d  = (SETMUX) ? (VSET_d  & H_SET)  : 1'b0; 
assign V_SET0_1d = (SETMUX) ? (VSET_1d & H_SET)  : 1'b0; 

always @(posedge CLK or negedge RESETn) begin
    if(!RESETn) begin
        V_CNT <= 0;
    end
    else if(NxSTABLE)begin
        if(!ENABLE)
            V_CNT <= 11'd1;
        else if(V_SET0)
            V_CNT <= 11'd1;
        else if(V_SET0_d)
            V_CNT <= 11'd1;
        else if(V_SET0_1d)
            V_CNT <= 11'd1;
        else if(V_SET1)
            V_CNT <= HALF_LINE;
        else if((V_CNT == TOTAL_LINE) && (H_CNT == END_HSync))
            V_CNT <= 11'd1;
        else if(H_CNT == END_HSync)
            V_CNT <= V_CNT + 1;
    end
    else begin
        V_CNT <= 0;
    end
end

// =======================================================================
//  Field counter gen.
// -----------------------------------------------------------------------
/* Field counter */
assign  F_UP_odd  = (SETMUX) ? V_SET0 : ((V_CNT == 11'd1)         && H_SET_M); 
assign  F_UP_even = (SETMUX) ? V_SET1 : ((V_CNT == HALF_LINE ) && H_SET_M); 

always @(posedge CLK or negedge RESETn) begin
    if(!RESETn) begin
        FIELD_CNT <= 4'd0;
    end
    else if(NxSTABLE)begin
        if(!ENABLE) begin
            FIELD_CNT <= 4'd0;
        end
        else if(F_UP_odd && (FIELD_CNT == FIELD_OVER)) begin
            FIELD_CNT <= 4'd1;
        end
        else if(F_UP_odd) begin
            FIELD_CNT <= FIELD_CNT + 4'd1;
        end
        else if(F_UP_even && (FIELD_CNT == FIELD_OVER) && EN_NONINTERLACE) begin
            FIELD_CNT <= 4'd1;
        end
        else if(F_UP_even) begin
            FIELD_CNT <= FIELD_CNT + 4'd1;
        end
    end
    else begin
        FIELD_CNT <= 4'd0;
    end
end


// =======================================================================
//  Output Timing Generation By Vertical counter
// -----------------------------------------------------------------------
reg  A480p;  //480 progressive mode output
reg  B480p;
reg  Ac480p; //Active area
reg  AHDp;   //720 progressive mode output
reg  BHDp;
reg  AcHDp;  //Active area
reg  AHDi;   //1080 interlace mode output
reg  BHDi;
reg  CHDi;
reg  DHDi;
reg  EHDi;
reg  AcHDi;  //Active area

reg  [1:0] LevelState;
wire [1:0] NxLevelState;

always @(V_CNT  or HD_MODE)
begin
    case(HD_MODE) //synopsys parallel_case

        2'b00: begin //480p
                if((V_CNT >= 1   && V_CNT <  7)  ||
                   (V_CNT >= 13  && V_CNT <  44) ||
                   (V_CNT >= 524 && V_CNT <= 525)
                   ) begin
                    A480p = 1;
                    B480p = 0;
                    Ac480p= 0;

                    //Not Active 
                    AHDp = 0;
                    BHDp = 0;
                    AcHDp= 0;

                    AHDi = 0;
                    BHDi = 0;
                    CHDi = 0;
                    DHDi = 0;
                    EHDi = 0;
                    AcHDi= 0;
                end
                else if(V_CNT >= 7 && V_CNT < 13) begin
                    A480p = 0;
                    B480p = 1;
                    Ac480p= 0;

                    //Not Active 
                    AHDp = 0;
                    BHDp = 0;
                    AcHDp= 0;

                    AHDi = 0;
                    BHDi = 0;
                    CHDi = 0;
                    DHDi = 0;
                    EHDi = 0;
                    AcHDi= 0;
                end
                else if(V_CNT >= 44 && V_CNT < 524) begin
                    A480p = 0;
                    B480p = 0;
                    Ac480p= 1;

                    //Not Active 
                    AHDp = 0;
                    BHDp = 0;
                    AcHDp= 0;

                    AHDi = 0;
                    BHDi = 0;
                    CHDi = 0;
                    DHDi = 0;
                    EHDi = 0;
                    AcHDi= 0;
                end
                else begin
                    A480p = 0;
                    B480p = 0;
                    Ac480p= 0;

                    //Not Active 
                    AHDp = 0;
                    BHDp = 0;
                    AcHDp= 0;

                    AHDi = 0;
                    BHDi = 0;
                    CHDi = 0;
                    DHDi = 0;
                    EHDi = 0;
                    AcHDi= 0;

                end
               end
        2'b01: begin //720p
                if(V_CNT >= 1 && V_CNT < 6) begin
                    AHDp = 1;
                    BHDp = 0;
                    AcHDp= 0;

                    //Not Active 
                    A480p = 0;
                    B480p = 0;
                    Ac480p= 0;
                    AHDi = 0;
                    BHDi = 0;
                    CHDi = 0;
                    DHDi = 0;
                    EHDi = 0;
                    AcHDi= 0;
                end
                else if((V_CNT >= 6    && V_CNT <  26) ||
                        (V_CNT >= 746  && V_CNT <= 750)) begin
                    AHDp = 0;
                    BHDp = 1;
                    AcHDp= 0;
                    //Not Active 
                    A480p = 0;
                    B480p = 0;
                    Ac480p= 0;
                    AHDi = 0;
                    BHDi = 0;
                    CHDi = 0;
                    DHDi = 0;
                    EHDi = 0;
                    AcHDi= 0;
                end
                else if(V_CNT >= 26 && V_CNT < 746) begin
                    AHDp = 0;
                    BHDp = 0;
                    AcHDp= 1;

                    //Not Active 
                    A480p = 0;
                    B480p = 0;
                    Ac480p= 0;
                    AHDi = 0;
                    BHDi = 0;
                    CHDi = 0;
                    DHDi = 0;
                    EHDi = 0;
                    AcHDi= 0;
                end
                else begin
                    AHDp = 0;
                    BHDp = 0;
                    AcHDp= 0;

                    //Not Active 
                    A480p = 0;
                    B480p = 0;
                    Ac480p= 0;
                    AHDi = 0;
                    BHDi = 0;
                    CHDi = 0;
                    DHDi = 0;
                    EHDi = 0;
                    AcHDi= 0;
                end
               end
        2'b10: begin //1080i
                if((V_CNT >= 1 && V_CNT < 6) || 
                   (V_CNT >= 564 && V_CNT < 568)) 
                begin
                    AHDi = 1;
                    BHDi = 0;
                    CHDi = 0;
                    DHDi = 0;
                    EHDi = 0;
                    AcHDi= 0;

                    //Not Active 
                    A480p = 0;
                    B480p = 0;
                    Ac480p= 0;
                    AHDp = 0;
                    BHDp = 0;
                    AcHDp= 0;
                end
                else if(V_CNT == 6) begin
                    AHDi = 0;
                    BHDi = 0;
                    CHDi = 0;
                    DHDi = 1;
                    EHDi = 0;
                    AcHDi= 0;
                    //Not Active 
                    A480p = 0;
                    B480p = 0;
                    Ac480p= 0;
                    AHDp = 0;
                    BHDp = 0;
                    AcHDp= 0;
                end
                else if((V_CNT >= 7   && V_CNT < 21)  ||
                        (V_CNT >= 561 && V_CNT < 563) ||
                        (V_CNT >= 569 && V_CNT < 583) ||
                        (V_CNT >= 1124 && V_CNT <= 1125) 
                        ) begin
                    AHDi = 0;
                    BHDi = 1;
                    CHDi = 0;
                    DHDi = 0;
                    EHDi = 0;
                    AcHDi= 0;
                    //Not Active 
                    A480p = 0;
                    B480p = 0;
                    Ac480p= 0;
                    AHDp = 0;
                    BHDp = 0;
                    AcHDp= 0;
                end
                else if(V_CNT == 563) begin
                    AHDi = 0;
                    BHDi = 0;
                    CHDi = 1;
                    DHDi = 0;
                    EHDi = 0;
                    AcHDi= 0;
                    //Not Active 
                    A480p = 0;
                    B480p = 0;
                    Ac480p= 0;
                    AHDp = 0;
                    BHDp = 0;
                    AcHDp= 0;
                end
                else if(V_CNT == 568) begin
                    AHDi = 0;
                    BHDi = 0;
                    CHDi = 0;
                    DHDi = 0;
                    EHDi = 1;
                    AcHDi= 0;
                    //Not Active 
                    A480p = 0;
                    B480p = 0;
                    Ac480p= 0;
                    AHDp = 0;
                    BHDp = 0;
                    AcHDp= 0;
                end
                else if((V_CNT >= 21   && V_CNT < 561) ||
                        (V_CNT >= 584 && V_CNT < 1124) ) begin
                    AHDi = 0;
                    BHDi = 0;
                    CHDi = 0;
                    DHDi = 0;
                    EHDi = 0;
                    AcHDi= 1;
                    //Not Active 
                    A480p = 0;
                    B480p = 0;
                    Ac480p= 0;
                    AHDp = 0;
                    BHDp = 0;
                    AcHDp= 0;
                end
                else begin
                    AHDi = 0;
                    BHDi = 0;
                    CHDi = 0;
                    DHDi = 0;
                    EHDi = 0;
                    AcHDi= 0;
                    //Not Active 
                    A480p = 0;
                    B480p = 0;
                    Ac480p= 0;
                    AHDp = 0;
                    BHDp = 0;
                    AcHDp= 0;
                end
               end
        default:
               begin //ohters
                    AHDi = 0;
                    BHDi = 0;
                    CHDi = 0;
                    DHDi = 0;
                    EHDi = 0;
                    AcHDi= 0;
                    A480p = 0;
                    B480p = 0;
                    Ac480p= 0;
                    AHDp = 0;
                    BHDp = 0;
                    AcHDp= 0;
               end
    endcase
end

// =======================================================================
//  Output Timing Generation By Horizontal counter
// -----------------------------------------------------------------------

reg [1:0] OutLevel;
reg       ActDisplay;

assign OUT_LEVEL = OutLevel;
assign ACT_DISPLAY_SYN = ActDisplay;

always @(posedge CLK or negedge RESETn) begin
    if(!RESETn) begin
        ActDisplay <= 0;
    end
    else begin
        if(H_CNT == END_ACT)                ActDisplay <= 0;
        else if(H_CNT == ACT_DISPLAY) begin
            case({HD_MODE, Ac480p, AcHDp, AcHDi}) //synopsys parallel_case
                5'b00100: ActDisplay <= 1;//480p mode
                5'b01010: ActDisplay <= 1;//720p mode
                5'b10001: ActDisplay <= 1;//1080i mode
                default:  ActDisplay <= 0;
            endcase
        end
    end
end

always @(posedge CLK or negedge RESETn) begin

    if(!RESETn) begin
        OutLevel <= 2'b01;
    end
    else begin

    case(HD_MODE) //synopsys parallel_case

        2'b00:  begin //480p mode
                    if(B480p && (H4 == H_CNT) && (V_CNT != 10'd12)) begin
                        OutLevel <= 2'b00;
                    end
                    else if(B480p && (H4 == H_CNT) && (V_CNT == 10'd12)) begin
                        OutLevel <= 2'b01;
                    end
                    else if(B480p && (H3 == H_CNT)) begin
                        OutLevel <= 2'b01;
                    end
                    else if((A480p | Ac480p) && (H1 == H_CNT)) begin
                        OutLevel <= 2'b00;
                    end
                    else if((A480p | Ac480p) && (H2 == H_CNT)) begin
                        OutLevel <= 2'b01;
                    end
                    else if(A480p && (V_CNT == 10'd6) && (H4 == H_CNT)) begin
                        OutLevel <= 2'b00;
                    end
                end
        2'b01:  begin //720p mode
                    if(H1 == H_CNT) begin
                        OutLevel <= 2'b00;
                    end
                    else if(H2 == H_CNT) begin
                        OutLevel <= 2'b10;
                    end
                    else if(H3 == H_CNT) begin
                        OutLevel <= 2'b01;
                    end
                    else if(AHDp && H4 == H_CNT) begin //vertical period
                        OutLevel <= 2'b00;
                    end
                    else if(AHDp && H10 == H_CNT) begin//vertical period
                        OutLevel <= 2'b01;
                    end
                end

        3'b10: begin //1080i mode

                    //All type support_________________
                    if(H1 == H_CNT) begin
                        OutLevel <= 2'b00;
                    end
                    else if(H2 == H_CNT) begin
                        OutLevel <= 2'b10;
                    end
                    else if(H3 == H_CNT) begin
                        OutLevel <= 2'b01;
                    end
                    //A/E type support__________________
                    else if((AHDi || EHDi) && H4 == H_CNT) begin //vertical period
                        OutLevel <= 2'b00;
                    end
                    else if((AHDi || EHDi) && H5 == H_CNT) begin //vertical period
                        OutLevel <= 2'b01;
                    end
                    //A/C/D type support________________
                    else if((AHDi || CHDi || DHDi) && H6 == H_CNT) begin //vertical period
                        OutLevel <= 2'b00;
                    end
                    else if((AHDi || CHDi || DHDi) && H7 == H_CNT) begin //vertical period
                        OutLevel <= 2'b10;
                    end
                    else if((AHDi || CHDi || DHDi) && H8 == H_CNT) begin //vertical period
                        OutLevel <= 2'b01;
                    end
                    else if((AHDi || CHDi) && H9 == H_CNT) begin //vertical period
                        OutLevel <= 2'b00;
                    end
                    else if((AHDi || CHDi) && H10== H_CNT) begin //vertical period
                        OutLevel <= 2'b01;
                    end
               end

        default:    OutLevel <= 2'b00;
    endcase
    end
end

// -----------------------------------------------------------------------
endmodule
